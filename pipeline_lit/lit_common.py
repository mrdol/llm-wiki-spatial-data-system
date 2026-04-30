"""Shared starter utilities for warehouse-specific literature query scripts.

The goal is to prepare reproducible query seeds for paper-linked dataset
discovery. No external literature API is queried by default.
"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

REPO_ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = REPO_ROOT / "catalogue_datasets.json"
DEFAULT_PLAN_DIR = REPO_ROOT / "data" / "manifests" / "papers"
DEFAULT_LIT_CANDIDATE_DIR = REPO_ROOT / "data" / "candidates" / "papers"

SPATIAL_TERMS = (
    "spatial",
    "geospatial",
    "spatio-temporal",
    "spatiotemporal",
    "space-time",
    "geographic",
    "regional",
    "territorial",
    "coordinates",
    "latitude",
    "longitude",
    "gis",
    "remote sensing",
)

TEMPORAL_TERMS = (
    "temporal",
    "time series",
    "longitudinal",
    "panel data",
    "monthly",
    "annual",
    "daily",
    "yearly",
    "space-time",
    "spatio-temporal",
    "spatiotemporal",
)

DATASET_TERMS = (
    "dataset",
    "data set",
    "data availability",
    "supplementary data",
    "repository",
    "zenodo",
    "figshare",
    "dataverse",
    "dryad",
    "open data",
    "available at",
    "download",
)

DATA_REPOSITORY_URL_PATTERN = re.compile(
    r"https?://[^\s\"'<>)]*(?:zenodo\.org|figshare\.com|datadryad\.org|dryad\.[^\s\"'<>)]*|dataverse\.[^\s\"'<>)]*|github\.com|gitlab\.com|osf\.io|pangaea\.de|mendeley\.com)[^\s\"'<>)]*",
    flags=re.IGNORECASE,
)

SUPPLEMENTARY_URL_PATTERN = re.compile(
    r"https?://[^\s\"'<>)]*(?:supplement|supporting|additional|media|article|download|dataset|data)[^\s\"'<>)]*",
    flags=re.IGNORECASE,
)

MODELING_SIGNAL_GROUPS = {
    "spatial_panel": (
        "spatial panel",
        "spatial econometric",
        "spatial lag",
        "spatial autoregressive",
        "spatial durbin",
    ),
    "spatiotemporal_model": (
        "spatio-temporal model",
        "spatiotemporal model",
        "space-time model",
        "spatio-temporal dynamics",
        "spatiotemporal dynamics",
    ),
    "forecasting": ("forecast", "forecasting", "prediction", "predictive", "nowcasting"),
    "regression": ("regression", "linear model", "generalized linear", "mixed effects", "fixed effects"),
    "machine_learning": (
        "machine learning",
        "random forest",
        "xgboost",
        "gradient boosting",
        "support vector",
        "neural network",
        "deep learning",
        "classification",
    ),
    "causal_inference": ("causal", "difference-in-differences", "instrumental variable", "treatment effect"),
    "bayesian": ("bayesian", "inla", "latent gaussian", "posterior"),
    "simulation_modeling": ("simulation", "numerical model", "model dataset", "simulated"),
}


def _normalize(value: str | None) -> str:
    return (value or "").strip().lower().replace(".", "").replace("/", " ")


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def abstract_from_inverted_index(index: dict[str, Any] | None) -> str | None:
    if not isinstance(index, dict) or not index:
        return None
    positions: list[tuple[int, str]] = []
    for word, offsets in index.items():
        if not isinstance(offsets, list):
            continue
        for offset in offsets:
            if isinstance(offset, int):
                positions.append((offset, word))
    if not positions:
        return None
    return " ".join(word for _, word in sorted(positions))


def compact_authors(work: dict[str, Any], limit: int = 8) -> list[str]:
    authors = []
    for authorship in work.get("authorships", [])[:limit]:
        author = authorship.get("author") if isinstance(authorship, dict) else None
        if isinstance(author, dict) and author.get("display_name"):
            authors.append(str(author["display_name"]))
    return authors


def analyze_literature_candidate(text_source: str | None) -> dict[str, Any]:
    text = (text_source or "").lower()
    spatial_terms = sorted({term for term in SPATIAL_TERMS if term in text})
    temporal_terms = sorted({term for term in TEMPORAL_TERMS if term in text})
    dataset_terms = sorted({term for term in DATASET_TERMS if term in text})
    modeling_signals: list[str] = []
    evidence_terms: list[str] = []
    score = 0

    if spatial_terms:
        score += 2
    if temporal_terms:
        score += 2
    if dataset_terms:
        score += 2

    for signal, terms in MODELING_SIGNAL_GROUPS.items():
        matched = [term for term in terms if term in text]
        if not matched:
            continue
        modeling_signals.append(signal)
        evidence_terms.extend(matched[:3])
        score += 2 if signal in {"spatial_panel", "spatiotemporal_model", "forecasting"} else 1

    if "spatial_panel" in modeling_signals:
        task_type = "spatial_panel_modeling"
    elif "spatiotemporal_model" in modeling_signals and "forecasting" in modeling_signals:
        task_type = "spatio_temporal_forecasting"
    elif "forecasting" in modeling_signals:
        task_type = "forecasting"
    elif "machine_learning" in modeling_signals:
        task_type = "machine_learning"
    elif "regression" in modeling_signals:
        task_type = "regression"
    elif "simulation_modeling" in modeling_signals:
        task_type = "simulation_modeling"
    else:
        task_type = "unknown"

    if score >= 7 and spatial_terms and temporal_terms and dataset_terms and modeling_signals:
        decision = "keep"
    elif score >= 4 and (spatial_terms or temporal_terms) and (dataset_terms or modeling_signals):
        decision = "review"
    else:
        decision = "drop_or_low_priority"

    return {
        "spatial_terms": spatial_terms,
        "temporal_terms": temporal_terms,
        "dataset_terms": dataset_terms,
        "modeling_signals": sorted(set(modeling_signals)),
        "modeling_evidence_terms": sorted(set(evidence_terms)),
        "task_type": task_type,
        "literature_score": score,
        "candidate_decision": decision,
    }


def normalize_openalex_work(work: dict[str, Any], *, query: str | None = None) -> dict[str, Any]:
    abstract = abstract_from_inverted_index(work.get("abstract_inverted_index"))
    title = work.get("title")
    primary_location = work.get("primary_location") if isinstance(work.get("primary_location"), dict) else {}
    source = primary_location.get("source") if isinstance(primary_location.get("source"), dict) else {}
    locations = work.get("locations") if isinstance(work.get("locations"), list) else []
    landing_urls = []
    for location in locations:
        if not isinstance(location, dict):
            continue
        for key in ("landing_page_url", "pdf_url"):
            if location.get(key) and location[key] not in landing_urls:
                landing_urls.append(location[key])
    text = " ".join(str(item or "") for item in (title, abstract))
    return {
        "record_type": "literature_dataset_candidate",
        "source": "openalex",
        "scraped_at": utc_now(),
        "query": query,
        "paper_openalex_id": work.get("id"),
        "paper_doi": work.get("doi"),
        "paper_title": title,
        "paper_year": work.get("publication_year"),
        "paper_venue": source.get("display_name") if isinstance(source, dict) else None,
        "paper_authors": compact_authors(work),
        "paper_abstract": abstract,
        "landing_urls": landing_urls,
        **analyze_literature_candidate(text),
    }


def normalize_crossref_work(work: dict[str, Any], *, query: str | None = None) -> dict[str, Any]:
    title_values = work.get("title") if isinstance(work.get("title"), list) else []
    abstract = re.sub(r"<[^>]+>", " ", str(work.get("abstract") or ""))
    abstract = re.sub(r"\s+", " ", abstract).strip() or None
    links = []
    for item in work.get("link") or []:
        if isinstance(item, dict) and item.get("URL"):
            links.append(item["URL"])
    for item in work.get("relation", {}).values() if isinstance(work.get("relation"), dict) else []:
        for relation in item if isinstance(item, list) else []:
            if isinstance(relation, dict) and relation.get("id"):
                links.append(str(relation["id"]))
    text = " ".join(str(item or "") for item in (title_values[0] if title_values else None, abstract))
    return {
        "record_type": "literature_dataset_candidate",
        "source": "crossref",
        "scraped_at": utc_now(),
        "query": query,
        "paper_openalex_id": None,
        "paper_doi": work.get("DOI"),
        "paper_title": title_values[0] if title_values else None,
        "paper_year": ((work.get("published-print") or work.get("published-online") or work.get("created") or {}).get("date-parts") or [[None]])[0][0],
        "paper_venue": next(iter(work.get("container-title") or []), None),
        "paper_authors": [
            " ".join(str(part) for part in (author.get("given"), author.get("family")) if part)
            for author in (work.get("author") or [])[:8]
            if isinstance(author, dict)
        ],
        "paper_abstract": abstract,
        "landing_urls": [url for url in [work.get("URL"), *links] if url],
        **analyze_literature_candidate(text),
    }


def extract_dataset_links_from_text(text: str | None) -> list[dict[str, Any]]:
    if not text:
        return []
    links: list[dict[str, Any]] = []
    seen: set[str] = set()
    for pattern, kind in ((DATA_REPOSITORY_URL_PATTERN, "repository"), (SUPPLEMENTARY_URL_PATTERN, "supplementary_or_data_page")):
        for match in pattern.findall(text):
            url = match.rstrip(".,;")
            key = url.lower()
            if key in seen:
                continue
            seen.add(key)
            links.append({"url": url, "link_type": kind})
    return links


def append_jsonl(path: Path, records: Iterable[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=True) + "\n")


def literature_rows(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [
        {
            "paper_title": record.get("paper_title"),
            "paper_year": record.get("paper_year"),
            "paper_doi": record.get("paper_doi"),
            "paper_venue": record.get("paper_venue"),
            "abstract_available": bool(record.get("paper_abstract")),
            "task_type": record.get("task_type"),
            "literature_score": record.get("literature_score"),
            "candidate_decision": record.get("candidate_decision"),
            "spatial_terms": ", ".join(record.get("spatial_terms", [])),
            "temporal_terms": ", ".join(record.get("temporal_terms", [])),
            "dataset_terms": ", ".join(record.get("dataset_terms", [])),
            "modeling_signals": ", ".join(record.get("modeling_signals", [])),
            "first_landing_url": next(iter(record.get("landing_urls", [])), None),
        }
        for record in records
    ]


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    import csv

    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else [
        "paper_title",
        "paper_year",
        "paper_doi",
        "paper_venue",
        "abstract_available",
        "task_type",
        "literature_score",
        "candidate_decision",
        "spatial_terms",
        "temporal_terms",
        "dataset_terms",
        "modeling_signals",
        "first_landing_url",
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def _warehouse_aliases(warehouse_record: dict[str, Any], warehouse_id: str) -> set[str]:
    identity = warehouse_record.get("identity", {})
    metadata = warehouse_record.get("warehouse_metadata", {})
    aliases = {
        _normalize(warehouse_id),
        _normalize(warehouse_id.replace("_", " ")),
        _normalize(identity.get("title")),
        _normalize(metadata.get("provider")),
    }
    return {alias for alias in aliases if alias}


def _matches_alias(candidate: str | None, aliases: set[str]) -> bool:
    candidate_norm = _normalize(candidate)
    if not candidate_norm:
        return False
    return any(
        candidate_norm == alias
        or candidate_norm in alias
        or alias in candidate_norm
        for alias in aliases
    )


@dataclass(frozen=True)
class LiteratureSeed:
    """One literature query candidate to run later against OpenAlex/Crossref."""

    dataset_id: str
    dataset_title: str
    warehouse_id: str
    warehouse_title: str
    query_text: str
    source_hint: str
    reason: str
    dataset_doi: str | None
    publication_doi: str | None


@dataclass(frozen=True)
class LiteraturePlan:
    """Prepared but non-executed literature discovery plan."""

    warehouse_id: str
    warehouse_title: str
    dataset_ids: list[str]
    seed_count: int
    seeds: list[LiteratureSeed]
    next_phase_actions: list[str]
    suggested_outputs: dict[str, str]


def load_catalog() -> dict[str, Any]:
    with CATALOG_PATH.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def get_warehouse_record(catalog: dict[str, Any], warehouse_id: str) -> dict[str, Any]:
    for warehouse in catalog.get("warehouses", []):
        if warehouse.get("warehouse_id") == warehouse_id:
            return warehouse
    raise KeyError(f"Unknown warehouse_id: {warehouse_id}")


def _dataset_matches_warehouse(dataset: dict[str, Any], warehouse_aliases: set[str]) -> bool:
    traceability = dataset.get("traceability", {})
    linked = {_normalize(item) for item in traceability.get("linked_warehouses", [])}
    if any(_matches_alias(item, warehouse_aliases) for item in linked):
        return True

    for warehouse in dataset.get("source_access", {}).get("warehouses", []):
        if _matches_alias(warehouse.get("name"), warehouse_aliases):
            return True
        if _matches_alias(warehouse.get("provider"), warehouse_aliases):
            return True
    return False


def iter_dataset_records_for_warehouse(
    catalog: dict[str, Any],
    warehouse_id: str,
    dataset_id_filter: str | None = None,
) -> Iterable[dict[str, Any]]:
    warehouse = get_warehouse_record(catalog, warehouse_id)
    warehouse_aliases = _warehouse_aliases(warehouse, warehouse_id)
    for dataset in catalog.get("datasets", []):
        if dataset_id_filter and dataset.get("dataset_id") != dataset_id_filter:
            continue
        if _dataset_matches_warehouse(dataset, warehouse_aliases):
            yield dataset


def _dedupe_preserve_order(values: Iterable[str]) -> list[str]:
    seen: set[str] = set()
    ordered: list[str] = []
    for value in values:
        if value in seen:
            continue
        seen.add(value)
        ordered.append(value)
    return ordered


def build_literature_seeds(
    warehouse_id: str,
    dataset_id_filter: str | None = None,
) -> tuple[dict[str, Any], list[LiteratureSeed]]:
    catalog = load_catalog()
    warehouse = get_warehouse_record(catalog, warehouse_id)
    warehouse_title = warehouse.get("identity", {}).get("title", warehouse_id)
    seeds: list[LiteratureSeed] = []

    for dataset in iter_dataset_records_for_warehouse(catalog, warehouse_id, dataset_id_filter):
        identity = dataset.get("identity", {})
        metadata = dataset.get("content_metadata", {})
        dataset_id = dataset.get("dataset_id")
        title = identity.get("title", dataset_id)
        short_title = identity.get("short_title")
        dataset_doi = identity.get("dataset_doi")
        publication_doi = identity.get("publication_doi")
        keywords = metadata.get("keywords", [])

        query_candidates = [
            (title, "exact dataset title"),
            (f'"{title}" "{warehouse_title}"', "dataset title plus warehouse title"),
        ]
        if short_title:
            query_candidates.append((f'"{short_title}" "{warehouse_title}"', "short title plus warehouse title"))
        if keywords:
            keyword_query = " ".join(keywords[:5])
            query_candidates.append((f'"{title}" {keyword_query}', "dataset title plus first keyword block"))
        if dataset_doi:
            query_candidates.append((dataset_doi, "explicit dataset DOI"))
        if publication_doi:
            query_candidates.append((publication_doi, "explicit publication DOI"))

        deduped_pairs = _dedupe_preserve_order(
            f"{candidate_text}|||{candidate_reason}"
            for candidate_text, candidate_reason in query_candidates
            if candidate_text
        )
        for packed in deduped_pairs:
            query_value, query_reason = packed.split("|||", maxsplit=1)
            seeds.append(
                LiteratureSeed(
                    dataset_id=dataset_id,
                    dataset_title=title,
                    warehouse_id=warehouse_id,
                    warehouse_title=warehouse_title,
                    query_text=query_value,
                    source_hint="openalex_or_crossref",
                    reason=query_reason,
                    dataset_doi=dataset_doi,
                    publication_doi=publication_doi,
                )
            )

    return warehouse, seeds


def build_literature_plan(
    warehouse_id: str,
    dataset_id_filter: str | None = None,
) -> LiteraturePlan:
    warehouse, seeds = build_literature_seeds(warehouse_id, dataset_id_filter)
    dataset_ids = sorted({seed.dataset_id for seed in seeds})
    output_base = DEFAULT_PLAN_DIR / warehouse_id
    return LiteraturePlan(
        warehouse_id=warehouse_id,
        warehouse_title=warehouse.get("identity", {}).get("title", warehouse_id),
        dataset_ids=dataset_ids,
        seed_count=len(seeds),
        seeds=seeds,
        next_phase_actions=[
            "run query strings against OpenAlex and Crossref in a controlled batch",
            "score results using DOI matches, title similarity, and explicit data availability language",
            "store paper candidates separately from confirmed paper links",
            "update the catalog only when paper-to-dataset links are explicit and documented",
        ],
        suggested_outputs={
            "query_plan_json": str(output_base.with_suffix(".lit-plan.json")),
            "openalex_candidates": str(output_base.with_suffix(".openalex.jsonl")),
            "crossref_candidates": str(output_base.with_suffix(".crossref.jsonl")),
        },
    )


def plan_to_payload(plan: LiteraturePlan, limit: int | None = None) -> dict[str, Any]:
    seeds = [asdict(seed) for seed in plan.seeds[:limit]] if limit is not None else [asdict(seed) for seed in plan.seeds]
    return {
        "warehouse_id": plan.warehouse_id,
        "warehouse_title": plan.warehouse_title,
        "dataset_ids": plan.dataset_ids,
        "seed_count": plan.seed_count,
        "seeds_preview": seeds,
        "next_phase_actions": plan.next_phase_actions,
        "suggested_outputs": plan.suggested_outputs,
    }


def default_plan_path(warehouse_id: str) -> Path:
    return DEFAULT_PLAN_DIR / f"{warehouse_id}.lit-plan.json"


def save_plan_payload(payload: dict[str, Any], output_path: str | Path) -> Path:
    path = Path(output_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=True), encoding="utf-8")
    return path


def load_plan_payload(plan_path: str | Path) -> dict[str, Any]:
    path = Path(plan_path)
    return json.loads(path.read_text(encoding="utf-8"))


def resolve_plan_payload(
    *,
    warehouse_id: str | None,
    dataset_id: str | None = None,
    plan_path: str | None = None,
) -> dict[str, Any]:
    if plan_path:
        return load_plan_payload(plan_path)
    if not warehouse_id:
        raise ValueError("Either --warehouse-id or --plan must be provided.")
    return plan_to_payload(build_literature_plan(warehouse_id=warehouse_id, dataset_id_filter=dataset_id))


def dataset_records_index(catalog: dict[str, Any]) -> dict[str, dict[str, Any]]:
    return {dataset["dataset_id"]: dataset for dataset in catalog.get("datasets", [])}


def _seed_output_prefix(plan_payload: dict[str, Any], key: str, fallback_suffix: str) -> str:
    suggested = plan_payload.get("suggested_outputs", {})
    default = default_plan_path(plan_payload["warehouse_id"]).with_suffix(fallback_suffix)
    return str(suggested.get(key, default))


def build_openalex_requests(plan_payload: dict[str, Any], mailto: str | None = None, per_page: int = 25) -> list[dict[str, Any]]:
    requests_payload: list[dict[str, Any]] = []
    for seed in plan_payload.get("seeds_preview", []):
        params = {
            "search": seed["query_text"],
            "per-page": per_page,
            "select": "id,doi,title,publication_year,primary_location,best_oa_location,authorships,abstract_inverted_index",
        }
        if mailto:
            params["mailto"] = mailto
        requests_payload.append(
            {
                "dataset_id": seed["dataset_id"],
                "query_text": seed["query_text"],
                "reason": seed["reason"],
                "endpoint": "https://api.openalex.org/works",
                "params": params,
                "suggested_output": _seed_output_prefix(plan_payload, "openalex_candidates", ".openalex.jsonl"),
            }
        )
    return requests_payload


def build_crossref_requests(plan_payload: dict[str, Any], mailto: str | None = None, rows: int = 25) -> list[dict[str, Any]]:
    requests_payload: list[dict[str, Any]] = []
    for seed in plan_payload.get("seeds_preview", []):
        params = {"rows": rows}
        if re.match(r"^10\.\d{4,9}/\S+$", seed["query_text"], flags=re.IGNORECASE):
            params["filter"] = f"doi:{seed['query_text']}"
        else:
            params["query.bibliographic"] = seed["query_text"]
        if mailto:
            params["mailto"] = mailto
        requests_payload.append(
            {
                "dataset_id": seed["dataset_id"],
                "query_text": seed["query_text"],
                "reason": seed["reason"],
                "endpoint": "https://api.crossref.org/works",
                "params": params,
                "suggested_output": _seed_output_prefix(plan_payload, "crossref_candidates", ".crossref.jsonl"),
            }
        )
    return requests_payload


def build_doi_report(
    *,
    warehouse_id: str | None = None,
    dataset_id: str | None = None,
) -> dict[str, Any]:
    catalog = load_catalog()
    relevant_datasets = (
        list(iter_dataset_records_for_warehouse(catalog, warehouse_id, dataset_id))
        if warehouse_id
        else [dataset for dataset in catalog.get("datasets", []) if not dataset_id or dataset.get("dataset_id") == dataset_id]
    )
    records = []
    for dataset in relevant_datasets:
        identity = dataset.get("identity", {})
        traceability = dataset.get("traceability", {})
        dataset_doi = identity.get("dataset_doi")
        publication_doi = identity.get("publication_doi")
        records.append(
            {
                "dataset_id": dataset["dataset_id"],
                "dataset_title": identity.get("title", dataset["dataset_id"]),
                "dataset_doi": dataset_doi,
                "publication_doi": publication_doi,
                "doi_traceability_status": traceability.get("doi_traceability_status"),
                "has_any_doi": bool(dataset_doi or publication_doi),
                "ready_for_lookup": bool(dataset_doi or publication_doi),
            }
        )
    return {
        "warehouse_id": warehouse_id,
        "dataset_count": len(records),
        "records": records,
    }


def build_license_report(
    *,
    warehouse_id: str | None = None,
    dataset_id: str | None = None,
) -> dict[str, Any]:
    catalog = load_catalog()
    relevant_datasets = (
        list(iter_dataset_records_for_warehouse(catalog, warehouse_id, dataset_id))
        if warehouse_id
        else [dataset for dataset in catalog.get("datasets", []) if not dataset_id or dataset.get("dataset_id") == dataset_id]
    )
    records = []
    for dataset in relevant_datasets:
        identity = dataset.get("identity", {})
        license_metadata = dataset.get("access_metadata", {}).get("license_metadata", {})
        records.append(
            {
                "dataset_id": dataset["dataset_id"],
                "dataset_title": identity.get("title", dataset["dataset_id"]),
                "explicit_license_present": license_metadata.get("explicit_license_present"),
                "exact_name": license_metadata.get("exact_name"),
                "evidence_type": license_metadata.get("evidence_type"),
                "category": license_metadata.get("category"),
                "is_open": license_metadata.get("is_open"),
                "allows_reuse": license_metadata.get("allows_reuse"),
                "notes": license_metadata.get("notes"),
            }
        )
    return {
        "warehouse_id": warehouse_id,
        "dataset_count": len(records),
        "records": records,
    }


def dataset_aliases_from_plan(plan_payload: dict[str, Any]) -> dict[str, list[str]]:
    aliases: dict[str, list[str]] = {}
    for seed in plan_payload.get("seeds_preview", []):
        dataset_id = seed["dataset_id"]
        aliases.setdefault(dataset_id, [])
        title = seed.get("dataset_title")
        reason = seed.get("reason")
        query = seed.get("query_text")
        candidates: list[str] = []
        if title:
            candidates.append(title)
        if reason == "explicit dataset DOI" and seed.get("dataset_doi"):
            candidates.append(seed["dataset_doi"])
        elif reason == "explicit publication DOI" and seed.get("publication_doi"):
            candidates.append(seed["publication_doi"])
        elif reason == "short title plus warehouse title" and query:
            quoted = re.findall(r'"([^"]+)"', query)
            if quoted:
                candidates.append(quoted[0])
        for candidate in candidates:
            if candidate and candidate not in aliases[dataset_id]:
                aliases[dataset_id].append(candidate)
    return aliases


def run_lit_cli(
    *,
    warehouse_id: str,
    script_label: str,
    extra_notes: tuple[str, ...] = (),
) -> None:
    parser = argparse.ArgumentParser(description=script_label)
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument("--limit", type=int, default=12, help="Limit the number of seeds shown.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print the generated JSON plan.")
    parser.add_argument(
        "--write-plan",
        action="store_true",
        help="Write the generated plan to the default papers manifest location.",
    )
    args = parser.parse_args()

    plan = build_literature_plan(warehouse_id=warehouse_id, dataset_id_filter=args.dataset_id)
    payload = plan_to_payload(plan, limit=args.limit)
    if extra_notes:
        payload["warehouse_specific_notes"] = list(extra_notes)
    if args.write_plan:
        save_plan_payload(payload, default_plan_path(warehouse_id))

    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))
