#!/usr/bin/env python
"""Verifie les candidats DataCite avec Claude et produit un rapport structure.

Ce script se place entre `harvest_datacite.R` et `apply_datacite_verification.R`.
Il relit les sorties du harvest, ajoute quelques controles deterministes
(doublons locaux, resolution DOI DataCite/Crossref quand le reseau repond),
puis demande a Claude de classer chaque candidat en:

- keep
- needs_manual_check
- reject

La sortie JSON est l'objet machine-readable utilise par le script d'apurement.
La sortie Markdown est seulement un rapport lisible par l'utilisateur.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any
from urllib.error import HTTPError, URLError
from urllib.parse import quote
from urllib.request import Request, urlopen


DEFAULT_MODEL = os.environ.get("ANTHROPIC_MODEL", "claude-sonnet-4-5")
MODEL_FALLBACKS = (
    "claude-sonnet-4-5",
    "claude-sonnet-4-5-20250929",
    "claude-haiku-4-5",
    "claude-haiku-4-5-20251001",
    "claude-sonnet-4-20250514",
)
USER_AGENT = "spatialtidymodels-datacite-verifier/0.1 (johnny.d-oliveira@inrae.fr)"
ACTION_VALUES = {"keep", "needs_manual_check", "reject"}


@dataclass
class Paths:
    repo_root: Path
    candidates_json: Path
    search_prompt: Path
    references_bib: Path
    regression_bib: Path
    output_dir: Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Verify DataCite spatial dataset candidates with Claude."
    )
    parser.add_argument(
        "--repo-root",
        default=None,
        help="Repository root. Defaults to the parent of tools/.",
    )
    parser.add_argument(
        "--candidates-json",
        default=None,
        help="Harvest JSON to verify.",
    )
    parser.add_argument(
        "--search-prompt",
        default=None,
        help="Search policy prompt used to judge candidates.",
    )
    parser.add_argument(
        "--model",
        default=DEFAULT_MODEL,
        help="Anthropic model name.",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=15,
        help="Number of candidates sent to Claude per request.",
    )
    parser.add_argument(
        "--max-description-chars",
        type=int,
        default=1200,
        help="Maximum DataCite description characters passed to Claude.",
    )
    parser.add_argument(
        "--skip-api-checks",
        action="store_true",
        help="Skip DataCite/Crossref DOI checks and use harvest metadata only.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite existing report files for the current year-month.",
    )
    return parser.parse_args()


def build_paths(args: argparse.Namespace) -> Paths:
    script_dir = Path(__file__).resolve().parent
    repo_root = Path(args.repo_root).resolve() if args.repo_root else script_dir.parent
    output_dir = repo_root / "data" / "manifests" / "papers"
    return Paths(
        repo_root=repo_root,
        candidates_json=Path(args.candidates_json).resolve()
        if args.candidates_json
        else output_dir / "datacite_spatial_dataset_candidates.json",
        search_prompt=Path(args.search_prompt).resolve()
        if args.search_prompt
        else repo_root / "tools" / "search_bib.md",
        references_bib=repo_root / "corpus" / "bib" / "references.bib",
        regression_bib=repo_root / "gg" / "regression_article.bib",
        output_dir=output_dir,
    )


def load_env_file(path: Path) -> None:
    # Charge un fichier .env simple sans ajouter de dependance python-dotenv.
    # Les variables deja presentes dans l'environnement gardent la priorite.
    if not path.exists():
        return
    for raw_line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if key and key not in os.environ:
            os.environ[key] = value


def read_json(path: Path) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8-sig") as fh:
        data = json.load(fh)
    if not isinstance(data, list):
        raise ValueError(f"Expected a JSON array in {path}")
    return [dict(row) for row in data]


def read_text_if_exists(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="replace")


def normalize_doi(value: Any) -> str:
    if value is None:
        return ""
    text = str(value).strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    return text.strip()


def extract_local_dois(*bib_paths: Path) -> set[str]:
    # Controle local simple: on cherche les DOI deja presents dans les .bib.
    dois: set[str] = set()
    doi_re = re.compile(r"10\.\d{4,9}/[^\s\"{}>,]+", re.IGNORECASE)
    for path in bib_paths:
        text = read_text_if_exists(path)
        for doi in doi_re.findall(text):
            dois.add(normalize_doi(doi.rstrip(".;")))
    return dois


def http_json(url: str, timeout: int = 30) -> tuple[str, dict[str, Any] | None]:
    request = Request(url, headers={"User-Agent": USER_AGENT})
    try:
        with urlopen(request, timeout=timeout) as response:
            body = response.read().decode("utf-8", errors="replace")
            return "ok", json.loads(body)
    except HTTPError as exc:
        return f"http_{exc.code}", None
    except (URLError, TimeoutError, json.JSONDecodeError) as exc:
        return f"error:{type(exc).__name__}", None


def title_overlap(left: str, right: str) -> float:
    # Score fruste mais reproductible pour detecter les appariements douteux.
    words_left = {
        w
        for w in re.findall(r"[a-z0-9]{4,}", (left or "").lower())
        if w not in {"data", "dataset", "supplementary", "supporting"}
    }
    words_right = {
        w
        for w in re.findall(r"[a-z0-9]{4,}", (right or "").lower())
        if w not in {"data", "dataset", "supplementary", "supporting"}
    }
    if not words_left or not words_right:
        return 0.0
    return len(words_left & words_right) / max(1, min(len(words_left), len(words_right)))


def first_title_from_datacite(payload: dict[str, Any] | None) -> str:
    if not payload:
        return ""
    titles = payload.get("data", {}).get("attributes", {}).get("titles", [])
    if titles and isinstance(titles, list):
        return str(titles[0].get("title", ""))
    return ""


def title_from_crossref(payload: dict[str, Any] | None) -> str:
    if not payload:
        return ""
    titles = payload.get("message", {}).get("title", [])
    if titles and isinstance(titles, list):
        return str(titles[0])
    return ""


def compact_candidate(row: dict[str, Any], max_description_chars: int) -> dict[str, Any]:
    # On limite les champs longs pour garder une requete Claude lisible.
    description = str(row.get("datacite_description") or "")
    if len(description) > max_description_chars:
        description = description[:max_description_chars] + "..."
    formats = str(row.get("formats") or "")
    if len(formats) > 500:
        formats = formats[:500] + "..."
    return {
        "dataset_doi": normalize_doi(row.get("dataset_doi")),
        "dataset_title": row.get("title"),
        "publisher": row.get("publisher"),
        "year": row.get("year"),
        "publication_doi": normalize_doi(row.get("publication_doi")),
        "article_title": row.get("article_title"),
        "article_venue": row.get("article_venue"),
        "article_year": row.get("article_year"),
        "cited_by_count": row.get("cited_by_count"),
        "citation_threshold": row.get("citation_threshold"),
        "data_access_url": row.get("data_access_url"),
        "publication_url": row.get("publication_url"),
        "article_oa_url": row.get("article_oa_url"),
        "formula_status": row.get("formula_status"),
        "formula_pub": row.get("formula_pub"),
        "candidate_task_type": row.get("candidate_task_type"),
        "spatial_evidence": row.get("spatial_evidence"),
        "model_evidence": row.get("model_evidence"),
        "screening_flags": row.get("screening_flags"),
        "datacite_subjects": row.get("datacite_subjects"),
        "datacite_description": description,
        "formats": formats,
    }


def build_raw_records(
    candidates: list[dict[str, Any]],
    paths: Paths,
    max_description_chars: int,
    skip_api_checks: bool,
) -> list[dict[str, Any]]:
    local_dois = extract_local_dois(paths.references_bib, paths.regression_bib)
    raw_records: list[dict[str, Any]] = []

    for idx, row in enumerate(candidates):
        compact = compact_candidate(row, max_description_chars=max_description_chars)
        dataset_doi = compact["dataset_doi"]
        publication_doi = compact["publication_doi"]

        dataset_status = "not_checked"
        dataset_title_resolved = ""
        publication_status = "not_checked"
        publication_title_resolved = ""

        if not skip_api_checks and dataset_doi:
            dataset_status, dataset_payload = http_json(
                f"https://api.datacite.org/dois/{quote(dataset_doi, safe='')}"
            )
            dataset_title_resolved = first_title_from_datacite(dataset_payload)
            time.sleep(0.1)

        if not skip_api_checks and publication_doi:
            publication_status, publication_payload = http_json(
                f"https://api.crossref.org/works/{quote(publication_doi, safe='')}"
            )
            publication_title_resolved = title_from_crossref(publication_payload)
            time.sleep(0.1)

        raw_records.append(
            {
                "idx": idx,
                **compact,
                "dataset_doi_resolves": dataset_status,
                "dataset_title_resolved": dataset_title_resolved,
                "dataset_title_overlap": title_overlap(
                    str(compact.get("dataset_title") or ""), dataset_title_resolved
                ),
                "publication_doi_resolves": publication_status,
                "article_title_resolved": publication_title_resolved,
                "publication_title_overlap": title_overlap(
                    str(compact.get("article_title") or ""), publication_title_resolved
                ),
                "duplicate_in_corpus_dataset_doi": dataset_doi in local_dois,
                "duplicate_in_corpus_publication_doi": publication_doi in local_dois,
            }
        )

    return raw_records


def strip_json_fence(text: str) -> str:
    text = text.strip()
    if text.startswith("```"):
        text = re.sub(r"^```(?:json)?\s*", "", text, flags=re.IGNORECASE)
        text = re.sub(r"\s*```$", "", text)
    return text.strip()


def model_candidates(model: str) -> list[str]:
    # Les identifiants Anthropic changent avec les deprecations. On essaie
    # d'abord le modele demande, puis quelques alias/IDs recents courants.
    seen: set[str] = set()
    candidates: list[str] = []
    for item in [model, os.environ.get("ANTHROPIC_MODEL"), *MODEL_FALLBACKS]:
        if item and item not in seen:
            candidates.append(item)
            seen.add(item)
    return candidates


def is_model_not_found_error(exc: Exception) -> bool:
    text = str(exc).lower()
    return "not_found_error" in text and "model" in text
def anthropic_client() -> Any:
    try:
        from anthropic import Anthropic
    except ImportError as exc:
        raise RuntimeError(
            "Le package Python `anthropic` est requis. Installe-le avec "
            "`python -m pip install anthropic`."
        ) from exc
    if not os.environ.get("ANTHROPIC_API_KEY"):
        raise RuntimeError(
            "La variable d'environnement ANTHROPIC_API_KEY est absente. "
            "Elle est requise pour lancer la verification Claude."
        )
    return Anthropic()


def verify_batch_with_claude(
    client: Any,
    model: str,
    search_policy: str,
    records: list[dict[str, Any]],
) -> list[dict[str, Any]]:
    system = (
        "You are a rigorous bibliographic screening assistant for a spatial "
        "regression benchmark project. Do not invent evidence. Use only the "
        "candidate metadata and deterministic checks supplied by the user. "
        "This screening happens BEFORE GROBID/PDF extraction: formula_status is "
        "ALWAYS 'not_found' at this stage for every candidate, by pipeline design "
        "(the formula is only extracted later from the full text). Do NOT treat "
        "a missing formula as a reason to downgrade a candidate to "
        "needs_manual_check or reject - judge relevance from the title/abstract/ "
        "subjects/method-name evidence available now instead."
    )
    user = {
        "search_policy_excerpt": search_policy[:6000],
        "required_output_schema": {
            "idx": "integer copied from input",
            "dataset_doi": "string copied from input",
            "dataset_doi_resolves": "oui/non/not_checked/http_xxx/error",
            "dataset_title_match": "oui/non/faible/not_checked",
            "publication_doi": "string copied from input",
            "publication_doi_resolves": "oui/non/not_checked/http_xxx/error",
            "publication_title_match": "oui/non/faible/not_checked",
            "matches_search_bib_objective": "short reason in French",
            "response_type_assessment": "likely_continuous_regression | possible_continuous_after_transformation | binary_or_classification | count_response | panel_or_spatiotemporal | prediction_product | unclear",
            "duplicate_in_corpus": "oui/non",
            "issues_found": "short issues in French",
            "recommended_action": "keep | needs_manual_check | reject",
            "dataset_title": "string copied from input",
            "article_title": "string copied from input",
            "cited_by_count": "number or string copied from input",
        },
        "decision_rules": [
            "Reject keyword-collision false positives and records outside spatial regression/econometrics/spatial prediction.",
            "Reject candidates already present in the local corpus.",
            "Reject when the dataset DOI clearly points to a simulation/code supplement or a Monte Carlo example rather than a real empirical dataset with response/covariates/coordinates.",
            "Reject or downgrade to needs_manual_check datasets dominated by ecology species-distribution / habitat suitability / occurrence / presence-absence / biodiversity / phenology signals, unless the metadata clearly indicate a continuous regression benchmark with an empirical Y and covariates.",
            "Reject panel, longitudinal or spatio-temporal candidates when multiple years/daily/monthly/annual records are central to the dataset, unless the metadata explicitly indicate a single cross-sectional spatial slice that can be extracted.",
            "Prioritize likely_continuous_regression. Keep count_response or binary_or_classification only when the dataset is otherwise strong and could plausibly be transformed into a continuous benchmark later; mark this in response_type_assessment and issues_found.",
            "Reject prediction products or final gridded model outputs when the training matrix with observed Y and covariates is not plausibly available.",
            "Reject code-only/document-only supplements when no tabular/spatial/raster data files are visible in the metadata.",
            "formula_status='not_found' is expected for EVERY candidate at this stage (pre-GROBID) - never use it alone as a reason for needs_manual_check or reject.",
            "Use keep when an explicit spatial regression/ML method is named (SAR, SEM, SDM, GWR, MGWR, spatially varying coefficients, kriging/regression kriging, CAR/INLA, spatial random forest, hedonic spatial regression, etc.) AND the dataset is plausibly a real empirical dataset (not a pure simulation or a code-only file) AND it is not a near-duplicate already in the corpus - regardless of citation count or open-access status, since those only affect priority, not eligibility.",
            "Citation rule: use the per-record citation_threshold field from the harvest output. Do not apply an old >=20 citation rule. If cited_by_count is below 20 but the record passed the harvest threshold, citation count is not a rejection reason.",
            "Use needs_manual_check only for genuine ambiguity that title/abstract/subjects cannot resolve: e.g. unclear whether the DOI is a real dataset vs. an article/code supplement, or conflicting domain signals.",
            "Do not invent formulas, datasets, citations, or URLs.",
            "Return only a JSON array. No markdown, no prose outside JSON.",
        ],
        "records": records,
    }
    create_kwargs = dict(
        max_tokens=8192,
        system=system,
        messages=[{"role": "user", "content": json.dumps(user, ensure_ascii=False)}],
    )

    last_error: Exception | None = None
    response = None
    for candidate_model in model_candidates(model):
        kwargs = dict(create_kwargs, model=candidate_model)
        if not candidate_model.startswith("claude-sonnet-5") and not candidate_model.startswith("claude-opus-5"):
            kwargs["temperature"] = 0
        try:
            response = client.messages.create(**kwargs)
            if candidate_model != model:
                print(f"[verification] modele fallback utilise: {candidate_model}", flush=True)
            break
        except Exception as exc:  # l'API Anthropic leve des classes selon la version du SDK.
            last_error = exc
            if is_model_not_found_error(exc):
                print(f"[verification] modele indisponible: {candidate_model}", flush=True)
                continue
            raise

    if response is None:
        tried = ", ".join(model_candidates(model))
        raise RuntimeError(
            "Aucun modele Anthropic disponible parmi: " + tried +
            ". Verifiez les modeles accessibles a votre cle API via l endpoint /v1/models."
        ) from last_error
    text = "".join(block.text for block in response.content if block.type == "text")
    parsed = json.loads(strip_json_fence(text))
    if not isinstance(parsed, list):
        raise ValueError("Claude did not return a JSON array")
    return [dict(row) for row in parsed]


def validate_report_rows(rows: list[dict[str, Any]], expected: list[dict[str, Any]]) -> None:
    expected_by_idx = {int(row["idx"]): row for row in expected}
    seen = set()
    for row in rows:
        idx = int(row.get("idx", -1))
        action = str(row.get("recommended_action", "")).strip()
        if idx not in expected_by_idx:
            raise ValueError(f"Unexpected idx from Claude: {idx}")
        if action not in ACTION_VALUES:
            raise ValueError(f"Invalid recommended_action for idx {idx}: {action}")
        expected_doi = expected_by_idx[idx]["dataset_doi"]
        if normalize_doi(row.get("dataset_doi")) != expected_doi:
            raise ValueError(
                f"Dataset DOI mismatch for idx {idx}: {row.get('dataset_doi')} != {expected_doi}"
            )
        seen.add(idx)
    missing = sorted(set(expected_by_idx) - seen)
    if missing:
        raise ValueError(f"Claude report is missing idx values: {missing}")


def report_markdown(rows: list[dict[str, Any]], raw_path: Path, json_path: Path) -> str:
    counts = {action: 0 for action in sorted(ACTION_VALUES)}
    for row in rows:
        counts[str(row["recommended_action"])] += 1

    lines = [
        "# Verification report - datacite_spatial_dataset_candidates",
        "",
        "Type: automated Claude/DataCite verification for harvest outputs.",
        "",
        "## Summary",
        "",
        f"- Records verified: {len(rows)}",
        f"- Recommended `keep`: {counts['keep']}",
        f"- Recommended `needs_manual_check`: {counts['needs_manual_check']}",
        f"- Recommended `reject`: {counts['reject']}",
        f"- Raw checks: `{raw_path.as_posix()}`",
        f"- Machine report: `{json_path.as_posix()}`",
        "",
        "## Full Verification Table",
        "",
        "| # | dataset_doi | publication_doi | action | response_type | duplicate | matches_objective | issues |",
        "|---|---|---|---|---|---|---|---|",
    ]
    for row in rows:
        lines.append(
            "| {idx} | {dataset_doi} | {publication_doi} | {action} | {response_type} | {duplicate} | {objective} | {issues} |".format(
                idx=row.get("idx", ""),
                dataset_doi=str(row.get("dataset_doi", "")).replace("|", "\\|"),
                publication_doi=str(row.get("publication_doi", "")).replace("|", "\\|"),
                action=str(row.get("recommended_action", "")).replace("|", "\\|"),
                response_type=str(row.get("response_type_assessment", "")).replace("|", "\\|"),
                duplicate=str(row.get("duplicate_in_corpus", "")).replace("|", "\\|"),
                objective=str(row.get("matches_search_bib_objective", "")).replace("|", "\\|"),
                issues=str(row.get("issues_found", "")).replace("|", "\\|"),
            )
        )
    lines.append("")
    return "\n".join(lines)


def write_json(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as fh:
        json.dump(rows, fh, ensure_ascii=False, indent=2)
        fh.write("\n")


def main() -> int:
    args = parse_args()
    paths = build_paths(args)
    load_env_file(paths.repo_root / ".env")
    if not paths.candidates_json.exists():
        raise FileNotFoundError(paths.candidates_json)

    stamp = datetime.now().strftime("%Y-%m")
    raw_path = paths.output_dir / f"datacite_verification_raw_{stamp}.json"
    report_json_path = paths.output_dir / f"datacite_verification_report_{stamp}.json"
    report_md_path = paths.output_dir / f"datacite_verification_report_{stamp}.md"

    if not args.force:
        for path in (raw_path, report_json_path, report_md_path):
            if path.exists():
                raise FileExistsError(
                    f"{path} already exists. Use --force to overwrite it."
                )

    candidates = read_json(paths.candidates_json)
    search_policy = read_text_if_exists(paths.search_prompt)
    raw_records = build_raw_records(
        candidates,
        paths,
        max_description_chars=args.max_description_chars,
        skip_api_checks=args.skip_api_checks,
    )
    write_json(raw_path, raw_records)

    client = anthropic_client()
    verified: list[dict[str, Any]] = []
    for start in range(0, len(raw_records), args.batch_size):
        batch = raw_records[start : start + args.batch_size]
        print(
            f"[verification] Claude batch {start + 1}-{start + len(batch)} / {len(raw_records)}",
            flush=True,
        )
        verified.extend(
            verify_batch_with_claude(
                client=client,
                model=args.model,
                search_policy=search_policy,
                records=batch,
            )
        )

    verified = sorted(verified, key=lambda row: int(row["idx"]))
    validate_report_rows(verified, raw_records)
    write_json(report_json_path, verified)
    report_md_path.write_text(
        report_markdown(verified, raw_path=raw_path, json_path=report_json_path),
        encoding="utf-8",
        newline="\n",
    )

    print(f"[verification] raw: {raw_path}")
    print(f"[verification] json: {report_json_path}")
    print(f"[verification] md: {report_md_path}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"[verification] ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
