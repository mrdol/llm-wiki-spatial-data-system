#!/usr/bin/env python
"""Ingere les candidats verifies du harvest journal-first dans la file
paper-dataset du projet -- pont manquant entre tools/harvest_journal_first.py
(data/manifests/papers/journal_first_candidates.json) et la generation de
fiches (code/r_catalog/generate_fiches_papers.R + build_sf_datasets_papers.R),
symetrique de tools/ingest_datacite_verified.py pour la file DataCite.

N'ingere que les dataset_candidates avec verified=True, c'est-a-dire ceux pour
lesquels dataset_manifest_check.classify_file_manifest() a confirme un depot
de fichiers de donnees reel via l'API du repo (jamais un candidat "needs_
manual_retrieval" faute d'API, ni un candidat trop petit) -- ce filtre est le
seul filtre de "readiness minimale", tout le reste (formule, N/k, geometrie,
package_include) reste `pending`/`manual_review` tant qu'un humain ou une
passe Claude explicite n'a pas ecrit le loader sf et verifie la fiche.

Ne telecharge rien, n'ecrit aucune fiche, ne genere aucun .rds. Se contente
de transformer l'accumulateur journal-first en entrees PaperDatasetUse dans
inst/kg/paper_dataset_uses.json, pour que le prochain run de
tools/build_paper_dataset_curation_manifest.py les fasse apparaitre dans la
file de curation au meme titre que les candidats DataCite.
"""

from __future__ import annotations

import argparse
import csv
import html
import json
import re
import unicodedata
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CANDIDATES = ROOT / "data" / "manifests" / "papers" / "journal_first_candidates.json"
DEFAULT_KG_MANIFEST = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
DEFAULT_OUTPUT_JSON = ROOT / "data" / "manifests" / "papers" / "journal_first_ingestion_manifest.json"
DEFAULT_OUTPUT_CSV = ROOT / "data" / "manifests" / "papers" / "journal_first_ingestion_manifest_excel.csv"
DEFAULT_STAGING_BIB = ROOT / "gg" / "journal_first_candidates_staging.bib"
DEFAULT_REPORT = ROOT / "wiki" / "analyses" / "journal_first_ingestion_2026-08.md"


ESTIMATOR_PATTERNS = [
    ("MGWR", re.compile(r"\bMGWR\b|multiscale geographically weighted", re.IGNORECASE)),
    ("GWR", re.compile(r"\bGWR\b|geographically weighted", re.IGNORECASE)),
    ("SVC", re.compile(r"spatially varying coefficient|varying coefficient", re.IGNORECASE)),
    ("SAR", re.compile(r"spatial lag|spatial autoregressive|\bSAR\b", re.IGNORECASE)),
    ("SEM", re.compile(r"spatial error|\bSEM\b", re.IGNORECASE)),
    ("SDM", re.compile(r"spatial durbin|\bSDM\b", re.IGNORECASE)),
    ("SLX", re.compile(r"\bSLX\b|spatial lag of x", re.IGNORECASE)),
    ("spatial_random_forest", re.compile(r"spatial random forest|geographically weighted random forest", re.IGNORECASE)),
    ("random_forest", re.compile(r"random forest", re.IGNORECASE)),
    ("INLA", re.compile(r"\bINLA\b|\bSPDE\b", re.IGNORECASE)),
    ("kriging", re.compile(r"kriging|spatial interpolation", re.IGNORECASE)),
    ("OLS", re.compile(r"\bOLS\b|ordinary least squares|linear regression", re.IGNORECASE)),
]


@dataclass
class Paths:
    candidates: Path
    kg_manifest: Path
    output_json: Path
    output_csv: Path
    staging_bib: Path
    report: Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Ingest verified journal-first dataset candidates into project manifests.")
    parser.add_argument("--candidates", default=str(DEFAULT_CANDIDATES), help="Accumulateur JSON de tools/harvest_journal_first.py.")
    parser.add_argument("--kg-manifest", default=str(DEFAULT_KG_MANIFEST), help="Manifest PaperDatasetUse a mettre a jour.")
    parser.add_argument("--output-json", default=str(DEFAULT_OUTPUT_JSON), help="Manifeste JSON d'ingestion.")
    parser.add_argument("--output-csv", default=str(DEFAULT_OUTPUT_CSV), help="CSV Excel avec separateur point-virgule.")
    parser.add_argument("--staging-bib", default=str(DEFAULT_STAGING_BIB), help="BibTeX de staging, non verse dans le corpus general.")
    parser.add_argument("--report", default=str(DEFAULT_REPORT), help="Rapport Markdown d'ingestion.")
    parser.add_argument("--dry-run", action="store_true", help="Calcule les sorties sans ecrire de fichiers.")
    return parser.parse_args()


def build_paths(args: argparse.Namespace) -> Paths:
    return Paths(
        candidates=Path(args.candidates).resolve(),
        kg_manifest=Path(args.kg_manifest).resolve(),
        output_json=Path(args.output_json).resolve(),
        output_csv=Path(args.output_csv).resolve(),
        staging_bib=Path(args.staging_bib).resolve(),
        report=Path(args.report).resolve(),
    )


def read_json(path: Path, default: Any = None) -> Any:
    if not path.exists():
        if default is not None:
            return default
        raise FileNotFoundError(path)
    with path.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def normalize_doi(value: Any) -> str:
    text = str(value or "").strip().lower()
    text = re.sub(r"^https?://(dx\.)?doi\.org/", "", text)
    text = text.replace("doi:", "").strip().rstrip(".")
    return text


def clean_text(value: Any) -> str:
    text = html.unescape(str(value or ""))
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def slug(value: str) -> str:
    value = unicodedata.normalize("NFKD", value or "").encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9]+", "_", value.lower())
    return value.strip("_") or "unknown"


def split_doi_or_url(value: str) -> tuple[str | None, str | None]:
    """Un candidat dataset peut etre un DOI ('10.5061/dryad.x') ou une URL nue
    ('https://zenodo.org/record/...' via ScienceBase/b2share) -- ne jamais
    forcer l'un dans l'autre, les deux champs restent distincts en aval."""
    v = clean_text(value)
    if not v:
        return None, None
    if v.lower().startswith("10.") or "doi.org" in v.lower():
        return normalize_doi(v), None
    return None, v


def bib_key(paper_title: str, paper_year: Any, dataset_ref: str) -> str:
    year = str(paper_year or "nd")
    title = clean_text(paper_title) or "journal first candidate"
    words = [part for part in re.split(r"[^A-Za-z0-9]+", title) if part]
    title_part = "".join(word[:18].capitalize() for word in words[:4]) or "JournalFirstCandidate"
    ref_part = slug(dataset_ref)[:16]
    return f"JournalFirst_{year}_{title_part}_{ref_part}"


def estimate_methods(*texts: str) -> list[str]:
    haystack = " ".join(clean_text(t) for t in texts if t)
    found = []
    for label, pattern in ESTIMATOR_PATTERNS:
        if pattern.search(haystack) and label not in found:
            found.append(label)
    return found


DOWNLOAD_STATUS_TO_INGESTION = {
    "downloaded": (
        "raw_data_downloaded_pending_loader",
        "write sf loader in build_sf_datasets_papers.R using the downloaded files and formula_completeness evidence, then generate the fiche",
    ),
    "partial": (
        "raw_data_partial_download_pending_loader",
        "some files failed to download (see verification_notes) -- inspect local_raw_dir, complete the download manually if needed, then write the loader",
    ),
    "failed": (
        "candidate_dataset_download_pending",
        "API confirmed real files but the download attempt failed (see verification_notes) -- retry via tools/harvest_journal_first.py --download-data, or download the DOI manually",
    ),
    "verified_pending_download": (
        "candidate_dataset_download_pending",
        "real files confirmed via the repo API but not yet downloaded -- re-run tools/harvest_journal_first.py --download-data, or download the DOI manually",
    ),
}


def iter_verified_dataset_rows(accumulator: dict[str, Any]) -> list[dict[str, Any]]:
    """Aplati l'accumulateur (schema {"records": [...]}, un enregistrement par
    papier avec une liste dataset_candidates[]) en une ligne par candidat
    verifie -- seuls les candidats avec verified=True (fichiers reels
    confirmes par classify_file_manifest via l'API du depot) sont retenus,
    jamais un candidat needs_manual_retrieval ou skipped_too_small."""
    rows = []
    for record in accumulator.get("records", []):
        if not isinstance(record, dict):
            continue
        for cand in record.get("dataset_candidates") or []:
            if cand.get("verified"):
                rows.append({"paper": record, "candidate": cand})
    rows.sort(
        key=lambda r: (
            normalize_doi(r["paper"].get("paper_doi")),
            normalize_doi(r["candidate"].get("doi_or_url")),
        )
    )
    return rows


def ingestion_record(row: dict[str, Any]) -> dict[str, Any] | None:
    paper = row["paper"]
    cand = row["candidate"]
    download_status = cand.get("download_status") or ""
    mapping = DOWNLOAD_STATUS_TO_INGESTION.get(download_status)
    if mapping is None:
        return None
    ingestion_status, next_step = mapping

    dataset_doi, dataset_url = split_doi_or_url(cand.get("doi_or_url"))
    paper_doi = normalize_doi(paper.get("paper_doi"))
    paper_title = clean_text(paper.get("paper_title"))
    dataset_ref = dataset_doi or dataset_url or "unknown"

    fc = cand.get("formula_completeness") or {}
    formula_pub = fc.get("formula_raw") if fc.get("status") in {"complete", "incomplete"} else None
    formula_status = {
        "complete": "explicit_verified_complete",
        "incomplete": "explicit_verified_incomplete",
        "non_verifiable": "pending_manual_check",
    }.get(fc.get("status"), "pending_grobid_kg")

    methods = estimate_methods(paper_title, paper.get("paper_abstract"), cand.get("note"))

    verification_bits = [cand.get("note") or ""]
    if fc.get("note"):
        verification_bits.append(f"completude formule: {fc['note']}")
    verification_notes = " | ".join(b for b in verification_bits if b)

    return {
        "metadata_schema": "spatialtidymodels_journal_first_ingestion_v1",
        "dataset_doi": dataset_doi,
        "dataset_url": dataset_url,
        "dataset_repo": cand.get("repo"),
        "dataset_n_files": cand.get("n_files"),
        "publication_doi": paper_doi or None,
        "publication_title": paper_title,
        "publication_venue": clean_text(paper.get("paper_venue")),
        "publication_year": paper.get("paper_year"),
        "discovery_source": paper.get("discovery_source") or paper.get("source"),
        "full_text_literature_score": paper.get("full_text_literature_score"),
        "full_text_modeling_signals": paper.get("full_text_modeling_signals") or [],
        "estimators_from_metadata": methods,
        "formula_status": formula_status,
        "formula_pub": formula_pub,
        "formula_completeness": fc or None,
        "local_pdf": paper.get("local_pdf"),
        "local_tei": paper.get("local_tei"),
        "local_raw_dir": cand.get("local_raw_dir"),
        "download_status": download_status,
        "verification_notes": verification_notes,
        "ingestion_status": ingestion_status,
        "ingestion_next_step": next_step,
        "bib_key": bib_key(paper_title, paper.get("paper_year"), dataset_ref),
    }


def kg_record(record: dict[str, Any]) -> dict[str, Any]:
    dataset_ref_slug = slug(record.get("dataset_doi") or record.get("dataset_url") or "unknown")
    publication_doi = record.get("publication_doi") or ""
    paper_id = (
        f"paper:doi:{publication_doi}"
        if publication_doi
        else f"paper:journal_first:{slug(record.get('publication_title'))}"
    )
    dataset_id = f"dataset_candidate:journal_first:{record.get('dataset_repo') or 'unknown'}:{dataset_ref_slug}"
    source_ref = "; ".join(
        part
        for part in (
            f"Journal-first dataset candidate {record.get('dataset_doi') or record.get('dataset_url')}",
            f"Publication DOI {publication_doi}" if publication_doi else "",
            f"Discovered via {record.get('discovery_source')}" if record.get("discovery_source") else "",
        )
        if part
    )
    evidence = record.get("verification_notes") or "Verified journal-first dataset candidate (real files confirmed via repo API)."
    return {
        "paper_id": paper_id,
        "bib_key": record["bib_key"],
        "paper_title": record["publication_title"],
        "paper_doi": record["publication_doi"],
        "dataset_name_in_paper": record.get("dataset_doi") or record.get("dataset_url") or "",
        "canonical_dataset_id": dataset_id,
        "target_type": "DatasetCandidate",
        "ingestion_status": record["ingestion_status"],
        "theme": "",
        "n_observations": None,
        "n_covariates": None,
        "source_type": "journal_first_verified_candidate",
        "source_ref": source_ref,
        "source_url": record.get("dataset_url") or record.get("dataset_doi"),
        "evidence": evidence,
        "evidence_page": None,
        "estimators_used": record.get("estimators_from_metadata") or [],
        "cv_scheme": None,
        "formula": record.get("formula_pub"),
        "spatial_characterization": (
            "Journal-first discovery: paper published in a spatial-econometrics-scoped journal "
            "(see tools/harvest_journal_first.py DEFAULT_SOURCES); coordinates, geometry or W must "
            "still be verified from the downloaded data files before any fiche is written."
        ),
        "confidence": "medium" if record["ingestion_status"].startswith("raw_data_downloaded") else "low",
        "dataset_doi": record.get("dataset_doi"),
        "data_access_url": record.get("dataset_url"),
        "local_pdf": record.get("local_pdf"),
        "local_tei": record.get("local_tei"),
        "local_raw_dir": record.get("local_raw_dir"),
        "formula_completeness": record.get("formula_completeness"),
    }


def upsert_kg_manifest(path: Path, new_records: list[dict[str, Any]]) -> dict[str, Any]:
    payload = read_json(path, {"records": []})
    records = list(payload.get("records", []))

    def key(row: dict[str, Any]) -> tuple[str, str]:
        paper_doi = normalize_doi(row.get("paper_doi"))
        paper_part = paper_doi or f"title:{slug(row.get('paper_title') or '')}"
        dataset_part = normalize_doi(row.get("dataset_doi")) or slug(row.get("data_access_url") or row.get("canonical_dataset_id") or "")
        return (paper_part, dataset_part)

    by_key = {key(row): i for i, row in enumerate(records)}
    inserted = 0
    updated = 0
    for record in new_records:
        record_key = key(record)
        if record_key in by_key:
            records[by_key[record_key]] = record
            updated += 1
        else:
            records.append(record)
            by_key[record_key] = len(records) - 1
            inserted += 1
    payload["records"] = records
    payload.setdefault("metadata", {})
    payload["metadata"]["last_journal_first_ingestion"] = date.today().isoformat()
    payload["metadata"]["last_journal_first_inserted"] = inserted
    payload["metadata"]["last_journal_first_updated"] = updated
    return payload


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter=";")
        writer.writeheader()
        for row in rows:
            flat = dict(row)
            for k, v in flat.items():
                if isinstance(v, (list, dict)):
                    flat[k] = json.dumps(v, ensure_ascii=False)
            writer.writerow(flat)


def bib_escape(value: Any) -> str:
    text = clean_text(value)
    text = text.replace("\\", "\\\\").replace("{", "\\{").replace("}", "\\}")
    return text


def write_staging_bib(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    entries = []
    for row in rows:
        fields = {
            "title": row.get("publication_title"),
            "journaltitle": row.get("publication_venue"),
            "year": row.get("publication_year"),
            "doi": row.get("publication_doi"),
            "note": (
                "Journal-first verified candidate; check corpus/bib/references.bib first "
                "(manually-scanned PDFs are usually already merged there via Biblio_from_pdf). "
                f"Dataset: {row.get('dataset_doi') or row.get('dataset_url')}."
            ),
        }
        lines = [f"@article{{{row['bib_key']},"]
        for k, v in fields.items():
            if v not in (None, ""):
                lines.append(f"  {k} = {{{bib_escape(v)}}},")
        lines.append("}")
        entries.append("\n".join(lines))
    path.write_text("\n\n".join(entries) + "\n", encoding="utf-8", newline="\n")


def write_report(path: Path, rows: list[dict[str, Any]], inserted: int, updated: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    by_status: dict[str, int] = {}
    for row in rows:
        by_status[row["ingestion_status"]] = by_status.get(row["ingestion_status"], 0) + 1
    incomplete = [r for r in rows if (r.get("formula_completeness") or {}).get("status") == "incomplete"]

    lines = [
        "# Ingestion des candidats journal-first verifies",
        "",
        f"Date : {date.today().isoformat()}",
        "",
        f"- Candidats verifies traites : **{len(rows)}**",
        f"- Derniere execution : **{inserted}** insertion(s), **{updated}** mise(s) a jour dans `inst/kg/paper_dataset_uses.json`",
        "- Repartition par statut : " + ", ".join(f"{k}={v}" for k, v in sorted(by_status.items())),
        f"- Dont formule incomplete (variable(s) manquante(s) detectee(s)) : **{len(incomplete)}**",
        "",
        "Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.",
        "Elles alimentent la meme file de curation reproductible que le harvest DataCite : "
        "KG -> tools/build_paper_dataset_curation_manifest.py -> loader sf -> fiche dataset -> metadata package.",
        "",
        "| Dataset | Repo | Papier | Statut | Formule | Etape suivante |",
        "|---|---|---|---|---|---|",
    ]
    for row in rows:
        fc_status = (row.get("formula_completeness") or {}).get("status", "non_extraite")
        lines.append(
            "| {dataset} | {repo} | {paper} | {status} | {formula} | {next_step} |".format(
                dataset=(row.get("dataset_doi") or row.get("dataset_url") or "").replace("|", "/"),
                repo=row.get("dataset_repo") or "",
                paper=(row.get("publication_title") or "").replace("|", "/")[:80],
                status=row.get("ingestion_status") or "",
                formula=fc_status,
                next_step=row.get("ingestion_next_step") or "",
            )
        )

    if incomplete:
        lines += ["", "## Formules incompletes -- variable(s) a chercher via source externe (jamais a fabriquer)", ""]
        for row in incomplete:
            fc = row["formula_completeness"]
            lines.append(f"- **{row.get('dataset_doi') or row.get('dataset_url')}** ({row.get('publication_title')}) : {fc['note']}")

    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    args = parse_args()
    paths = build_paths(args)
    accumulator = read_json(paths.candidates, {})
    verified_rows = iter_verified_dataset_rows(accumulator)
    ingestion_rows = [r for r in (ingestion_record(row) for row in verified_rows) if r is not None]
    kg_rows = [kg_record(row) for row in ingestion_rows]
    updated_payload = upsert_kg_manifest(paths.kg_manifest, kg_rows)
    metadata = updated_payload.get("metadata", {})

    print(f"verified journal-first candidates: {len(ingestion_rows)}")
    print(f"PaperDatasetUse inserted: {metadata.get('last_journal_first_inserted', 0)}")
    print(f"PaperDatasetUse updated: {metadata.get('last_journal_first_updated', 0)}")
    if args.dry_run:
        return 0

    if not ingestion_rows:
        print("Aucun candidat verifie a ingerer -- rien ecrit.")
        return 0

    write_json(paths.output_json, ingestion_rows)
    write_csv(paths.output_csv, ingestion_rows)
    write_staging_bib(paths.staging_bib, ingestion_rows)
    write_json(paths.kg_manifest, updated_payload)
    write_report(
        paths.report,
        ingestion_rows,
        int(metadata.get("last_journal_first_inserted", 0)),
        int(metadata.get("last_journal_first_updated", 0)),
    )
    print(f"manifest: {paths.output_json}")
    print(f"excel_csv: {paths.output_csv}")
    print(f"staging_bib: {paths.staging_bib}")
    print(f"kg_manifest: {paths.kg_manifest}")
    print(f"report: {paths.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
