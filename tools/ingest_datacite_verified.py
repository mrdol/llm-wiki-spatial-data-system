#!/usr/bin/env python
"""Ingere les candidats DataCite valides dans la file paper-dataset du projet.

Le script ne telecharge pas encore les jeux de donnees. Il transforme les
`verified_candidate` issus du harvest DataCite en:

- un manifeste d'ingestion lisible;
- une file BibTeX de staging pour controle JabRef;
- des entrees `PaperDatasetUse` dans `inst/kg/paper_dataset_uses.json`.

Les formules, tailles, variables et geometries restent volontairement en statut
pending tant qu'un PDF/TEI ou une source de donnees n'a pas ete verifiee.
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
DEFAULT_CANDIDATES = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates.json"
DEFAULT_KG_MANIFEST = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
DEFAULT_OUTPUT_JSON = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest.json"
DEFAULT_OUTPUT_CSV = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest_excel.csv"
DEFAULT_STAGING_BIB = ROOT / "gg" / "datacite_verified_candidates_staging.bib"
DEFAULT_REPORT = ROOT / "wiki" / "analyses" / "datacite_verified_ingestion_2026-08.md"


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
    parser = argparse.ArgumentParser(description="Ingest verified DataCite candidates into project manifests.")
    parser.add_argument("--candidates", default=str(DEFAULT_CANDIDATES), help="JSON DataCite apure.")
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


def read_json(path: Path) -> Any:
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
    text = repair_mojibake(text)
    text = normalize_typographic_punctuation(text)
    text = re.sub(r"<[^>]+>", " ", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def normalize_typographic_punctuation(value: str) -> str:
    """Remplace les ponctuations typographiques qui cassent souvent les consoles."""
    return value.translate(
        str.maketrans(
            {
                "‐": "-",
                "‑": "-",
                "‒": "-",
                "–": "-",
                "—": "-",
                "’": "'",
                "‘": "'",
                "“": '"',
                "”": '"',
                "…": "...",
            }
        )
    )


def mojibake_score(value: str) -> int:
    """Score simple pour reperer les textes UTF-8 lus avec le mauvais encodage."""
    markers = ("Ã", "Â", "â€", "â€™", "â€“", "â€”", "�")
    return sum(value.count(marker) for marker in markers)


def repair_mojibake(value: str) -> str:
    """Corrige les mojibakes courants sans toucher aux textes deja corrects."""
    original_score = mojibake_score(value)
    if original_score == 0:
        return value

    best = value
    best_score = original_score
    for encoding in ("cp1252", "latin1"):
        try:
            candidate = value.encode(encoding).decode("utf-8")
        except UnicodeError:
            continue
        score = mojibake_score(candidate)
        if score < best_score:
            best = candidate
            best_score = score

    return best


def slug(value: str) -> str:
    value = unicodedata.normalize("NFKD", value).encode("ascii", "ignore").decode("ascii")
    value = re.sub(r"[^A-Za-z0-9]+", "_", value.lower())
    return value.strip("_") or "unknown"


def bib_key(row: dict[str, Any]) -> str:
    year = str(row.get("article_year") or row.get("year") or "nd")
    title = clean_text(row.get("article_title") or row.get("title") or "datacite candidate")
    words = [part for part in re.split(r"[^A-Za-z0-9]+", title) if part]
    title_part = "".join(word[:18].capitalize() for word in words[:4]) or "DataciteCandidate"
    doi_part = slug(normalize_doi(row.get("publication_doi") or row.get("dataset_doi")))[:16]
    return f"DataCite_{year}_{title_part}_{doi_part}"


def estimate_methods(row: dict[str, Any]) -> list[str]:
    haystack = " ".join(
        clean_text(row.get(key))
        for key in (
            "title",
            "article_title",
            "article_venue",
            "datacite_description",
            "datacite_subjects",
            "model_evidence",
            "verification_matches_objective",
        )
    )
    found = []
    for label, pattern in ESTIMATOR_PATTERNS:
        if pattern.search(haystack) and label not in found:
            found.append(label)
    return found


def verified_candidates(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    selected = [row for row in rows if row.get("candidate_status") == "verified_candidate"]
    selected.sort(key=lambda row: (normalize_doi(row.get("publication_doi")), normalize_doi(row.get("dataset_doi"))))
    return selected


def ingestion_record(row: dict[str, Any]) -> dict[str, Any]:
    dataset_doi = normalize_doi(row.get("dataset_doi"))
    publication_doi = normalize_doi(row.get("publication_doi"))
    dataset_title = clean_text(row.get("title"))
    article_title = clean_text(row.get("article_title")) or dataset_title
    data_url = clean_text(row.get("data_access_url") or row.get("source_url"))
    publication_url = clean_text(row.get("publication_url") or row.get("article_oa_url"))
    methods = estimate_methods(row)

    return {
        "metadata_schema": "spatialtidymodels_datacite_ingestion_v1",
        "candidate_status": row.get("candidate_status"),
        "dataset_doi": dataset_doi,
        "dataset_title": dataset_title,
        "dataset_publisher": clean_text(row.get("publisher")),
        "dataset_year": row.get("year"),
        "data_access_url": data_url,
        "publication_doi": publication_doi,
        "publication_title": article_title,
        "publication_venue": clean_text(row.get("article_venue")),
        "publication_year": row.get("article_year"),
        "publication_url": publication_url,
        "open_access_pdf_url": clean_text(row.get("open_access_pdf_url") or row.get("article_oa_url")),
        "cited_by_count": row.get("cited_by_count"),
        "formula_status": "pending_grobid_kg",
        "formula_pub": None,
        "estimators_from_metadata": methods,
        "spatial_evidence": clean_text(row.get("spatial_evidence")),
        "model_evidence": clean_text(row.get("model_evidence")),
        "verification_notes": clean_text(row.get("verification_matches_objective")),
        "ingestion_status": "candidate_dataset_download_pending",
        "ingestion_next_step": "download legal OA PDF/data metadata, run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted",
        "bib_key": bib_key(row),
    }


def kg_record(record: dict[str, Any]) -> dict[str, Any]:
    dataset_doi_slug = slug(record["dataset_doi"])
    publication_doi = record["publication_doi"]
    paper_id = f"paper:doi:{publication_doi}" if publication_doi else f"paper:datacite:{dataset_doi_slug}"
    dataset_id = f"dataset_candidate:datacite:{dataset_doi_slug}"
    source_ref = "; ".join(
        part
        for part in (
            f"DataCite dataset DOI {record['dataset_doi']}" if record.get("dataset_doi") else "",
            f"Publication DOI {record['publication_doi']}" if record.get("publication_doi") else "",
        )
        if part
    )
    return {
        "paper_id": paper_id,
        "bib_key": record["bib_key"],
        "paper_title": record["publication_title"],
        "paper_doi": record["publication_doi"],
        "dataset_name_in_paper": record["dataset_title"],
        "canonical_dataset_id": dataset_id,
        "target_type": "DatasetCandidate",
        "ingestion_status": record["ingestion_status"],
        "theme": "",
        "n_observations": None,
        "n_covariates": None,
        "source_type": "datacite_verified_candidate",
        "source_ref": source_ref,
        "source_url": record.get("data_access_url") or record.get("publication_url"),
        "evidence": record.get("verification_notes") or record.get("model_evidence") or "Verified DataCite candidate.",
        "evidence_page": None,
        "estimators_used": record.get("estimators_from_metadata") or [],
        "cv_scheme": None,
        "formula": None,
        "spatial_characterization": (
            "Spatiality is indicated by DataCite/OpenAlex screening metadata; "
            "coordinates, geometry or W must still be verified from data files or TEI."
        ),
        "confidence": "medium",
        "dataset_doi": record["dataset_doi"],
        "data_access_url": record.get("data_access_url"),
        "open_access_pdf_url": record.get("open_access_pdf_url"),
    }


def upsert_kg_manifest(path: Path, new_records: list[dict[str, Any]]) -> dict[str, Any]:
    if path.exists():
        payload = read_json(path)
    else:
        payload = {"records": []}
    records = list(payload.get("records", []))

    def key(row: dict[str, Any]) -> tuple[str, str]:
        return (normalize_doi(row.get("paper_doi")), normalize_doi(row.get("dataset_doi")))

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
    payload["metadata"]["last_datacite_verified_ingestion"] = date.today().isoformat()
    payload["metadata"]["last_datacite_verified_inserted"] = inserted
    payload["metadata"]["last_datacite_verified_updated"] = updated
    return payload


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


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
            "url": row.get("publication_url"),
            "note": (
                "DataCite verified candidate; authors not filled here unless retrieved from "
                "bibliographic metadata. Dataset DOI: "
                f"{row.get('dataset_doi')}. Data access: {row.get('data_access_url')}"
            ),
        }
        lines = [f"@article{{{row['bib_key']},"]
        for key, value in fields.items():
            if value not in (None, ""):
                lines.append(f"  {key} = {{{bib_escape(value)}}},")
        lines.append("}")
        entries.append("\n".join(lines))
    path.write_text("\n\n".join(entries) + "\n", encoding="utf-8", newline="\n")


def write_report(path: Path, rows: list[dict[str, Any]], inserted: int, updated: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# Ingestion des candidats DataCite valides",
        "",
        f"Date : {date.today().isoformat()}",
        "",
        f"- Candidats `verified_candidate` traites : **{len(rows)}**",
        f"- Entrees DataCite presentes dans `PaperDatasetUse` : **{len(rows)}**",
        f"- Derniere execution : **{inserted}** insertion(s), **{updated}** mise(s) a jour",
        "",
        "Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.",
        "Elles creent une file d'ingestion reproductible: PDF/data -> GROBID -> KG -> fiche dataset -> metadata package.",
        "",
        "| Dataset DOI | Publication DOI | Article | Dataset | Estimateurs detectes | Statut suivant |",
        "|---|---|---|---|---|---|",
    ]
    for row in rows:
        methods = ", ".join(row.get("estimators_from_metadata") or []) or "pending_tei"
        lines.append(
            "| {dataset_doi} | {publication_doi} | {article} | {dataset} | {methods} | {status} |".format(
                dataset_doi=row.get("dataset_doi") or "",
                publication_doi=row.get("publication_doi") or "",
                article=(row.get("publication_title") or "").replace("|", "/"),
                dataset=(row.get("dataset_title") or "").replace("|", "/"),
                methods=methods,
                status=row.get("ingestion_status") or "",
            )
        )
    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    args = parse_args()
    paths = build_paths(args)
    rows = read_json(paths.candidates)
    selected = verified_candidates(rows)
    ingestion_rows = [ingestion_record(row) for row in selected]
    kg_rows = [kg_record(row) for row in ingestion_rows]
    updated_payload = upsert_kg_manifest(paths.kg_manifest, kg_rows)
    metadata = updated_payload.get("metadata", {})

    print(f"verified candidates: {len(ingestion_rows)}")
    print(f"PaperDatasetUse inserted: {metadata.get('last_datacite_verified_inserted', 0)}")
    print(f"PaperDatasetUse updated: {metadata.get('last_datacite_verified_updated', 0)}")
    if args.dry_run:
        return 0

    write_json(paths.output_json, ingestion_rows)
    write_csv(paths.output_csv, ingestion_rows)
    write_staging_bib(paths.staging_bib, ingestion_rows)
    write_json(paths.kg_manifest, updated_payload)
    write_report(
        paths.report,
        ingestion_rows,
        int(metadata.get("last_datacite_verified_inserted", 0)),
        int(metadata.get("last_datacite_verified_updated", 0)),
    )
    print(f"manifest: {paths.output_json}")
    print(f"excel_csv: {paths.output_csv}")
    print(f"staging_bib: {paths.staging_bib}")
    print(f"kg_manifest: {paths.kg_manifest}")
    print(f"report: {paths.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
