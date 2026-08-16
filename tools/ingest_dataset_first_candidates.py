#!/usr/bin/env python
"""Ingere les candidats verifies du harvest dataset-first (Dryad+Zenodo) dans
la file paper-dataset du projet -- pont entre tools/harvest_dataset_first.py
(data/manifests/papers/dataset_first_candidates.json) et la generation de
fiches (code/r_catalog/generate_fiches_papers.R + build_sf_datasets_papers.R),
symetrique de tools/ingest_journal_first_candidates.py.

N'ingere que les enregistrements avec verified=True (fichiers reels confirmes
via l'API Dryad/Zenodo) -- jamais un candidat needs_manual_retrieval ou
skipped_too_small. La publication liee (paper_doi/formule) reste `pending`
tant que son DOI n'a pas ete resolu via OpenAlex et son PDF/TEI verifie ;
un dataset sans aucune publication liee dans ses propres metadonnees reste
ingerable (utile pour le package meme sans papier source identifie), mais
avec `formula_status: no_linked_publication` et `manual_review` explicite.

Ne telecharge rien, n'ecrit aucune fiche, ne genere aucun .rds.
"""

from __future__ import annotations

import argparse
from datetime import date
from pathlib import Path
from typing import Any

from ingest_journal_first_candidates import (  # noqa: E402
    DOWNLOAD_STATUS_TO_INGESTION,
    bib_escape,
    bib_key,
    clean_text,
    estimate_methods,
    normalize_doi,
    read_json,
    slug,
    write_csv,
    write_json,
)


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CANDIDATES = ROOT / "data" / "manifests" / "papers" / "dataset_first_candidates.json"
DEFAULT_KG_MANIFEST = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
DEFAULT_OUTPUT_JSON = ROOT / "data" / "manifests" / "papers" / "dataset_first_ingestion_manifest.json"
DEFAULT_OUTPUT_CSV = ROOT / "data" / "manifests" / "papers" / "dataset_first_ingestion_manifest_excel.csv"
DEFAULT_STAGING_BIB = ROOT / "gg" / "dataset_first_candidates_staging.bib"
DEFAULT_REPORT = ROOT / "wiki" / "analyses" / "dataset_first_ingestion_2026-08.md"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Ingest verified dataset-first (Dryad/Zenodo) candidates into project manifests.")
    parser.add_argument("--candidates", default=str(DEFAULT_CANDIDATES))
    parser.add_argument("--kg-manifest", default=str(DEFAULT_KG_MANIFEST))
    parser.add_argument("--output-json", default=str(DEFAULT_OUTPUT_JSON))
    parser.add_argument("--output-csv", default=str(DEFAULT_OUTPUT_CSV))
    parser.add_argument("--staging-bib", default=str(DEFAULT_STAGING_BIB))
    parser.add_argument("--report", default=str(DEFAULT_REPORT))
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def upsert_kg_manifest(path: Path, new_records: list[dict[str, Any]]) -> dict[str, Any]:
    """Copie locale de ingest_journal_first_candidates.upsert_kg_manifest --
    celle-ci ecrit des cles metadata 'last_journal_first_*' codees en dur ;
    la reutiliser telle quelle depuis ce script aurait attribue les compteurs
    d'ingestion dataset-first a la mauvaise provenance."""
    payload = read_json(path, {"records": []})
    records = list(payload.get("records", []))

    def key(row: dict[str, Any]) -> tuple[str, str]:
        paper_doi = normalize_doi(row.get("paper_doi"))
        paper_part = paper_doi or f"title:{slug(row.get('paper_title') or '')}"
        dataset_part = normalize_doi(row.get("dataset_doi")) or slug(row.get("canonical_dataset_id") or "")
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
    payload["metadata"]["last_dataset_first_ingestion"] = date.today().isoformat()
    payload["metadata"]["last_dataset_first_inserted"] = inserted
    payload["metadata"]["last_dataset_first_updated"] = updated
    return payload


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
                "Dataset-first verified candidate (discovered via Dryad/Zenodo search, not the paper's "
                "own text); check corpus/bib/references.bib first. "
                f"Dataset: {row.get('dataset_doi')} ({row.get('dataset_repo')})."
            ),
        }
        lines = [f"@article{{{row['bib_key']},"]
        for k, v in fields.items():
            if v not in (None, ""):
                lines.append(f"  {k} = {{{bib_escape(v)}}},")
        lines.append("}")
        entries.append("\n".join(lines))
    path.write_text("\n\n".join(entries) + "\n", encoding="utf-8", newline="\n")


def ingestion_record(rec: dict[str, Any]) -> dict[str, Any] | None:
    if not rec.get("verified"):
        return None
    download_status = rec.get("download_status") or ""
    mapping = DOWNLOAD_STATUS_TO_INGESTION.get(download_status)
    if mapping is None:
        return None
    ingestion_status, next_step = mapping

    dataset_doi = normalize_doi(rec.get("dataset_doi"))
    paper_resolved = bool(rec.get("paper_resolved"))
    paper_doi = normalize_doi(rec.get("paper_doi")) if paper_resolved else ""
    dataset_title = clean_text(rec.get("dataset_title"))
    paper_title = clean_text(rec.get("paper_title")) if paper_resolved else f"[dataset-first, publication non resolue] {dataset_title}"

    fc = rec.get("formula_completeness") or {}
    formula_pub = fc.get("formula_raw") if fc.get("status") in {"complete", "incomplete"} else None
    if fc.get("status") in {"complete", "incomplete", "non_verifiable"}:
        formula_status = {
            "complete": "explicit_verified_complete",
            "incomplete": "explicit_verified_incomplete",
            "non_verifiable": "pending_manual_check",
        }[fc["status"]]
    elif not rec.get("linked_publication_doi"):
        formula_status = "no_linked_publication"
    else:
        formula_status = "pending_grobid_kg"

    methods = estimate_methods(dataset_title, rec.get("dataset_abstract"), " ".join(rec.get("dataset_keywords") or []))

    verification_bits = [rec.get("note") or ""]
    if fc.get("note"):
        verification_bits.append(f"completude formule: {fc['note']}")
    if not paper_resolved:
        if rec.get("linked_publication_doi"):
            verification_bits.append(f"publication liee non resolue via OpenAlex: {rec.get('linked_publication_doi')}")
        else:
            verification_bits.append("aucune publication liee dans les metadonnees du depot (relatedWorks/related_identifiers vide)")

    return {
        "metadata_schema": "spatialtidymodels_dataset_first_ingestion_v1",
        "dataset_doi": dataset_doi,
        "dataset_title": dataset_title,
        "dataset_repo": rec.get("repo"),
        "dataset_n_files": rec.get("n_files"),
        "dataset_literature_score": rec.get("dataset_literature_score"),
        "publication_doi": paper_doi or None,
        "publication_title": paper_title,
        "publication_venue": clean_text(rec.get("paper_venue")),
        "publication_year": rec.get("paper_year"),
        "publication_resolved": paper_resolved,
        "linked_publication_relationship": rec.get("linked_publication_relationship"),
        "discovery_source": "dataset_first",
        "estimators_from_metadata": methods,
        "formula_status": formula_status,
        "formula_pub": formula_pub,
        "formula_completeness": fc or None,
        "local_pdf": rec.get("local_pdf"),
        "local_tei": rec.get("local_tei"),
        "local_raw_dir": rec.get("local_raw_dir"),
        "download_status": download_status,
        "verification_notes": " | ".join(b for b in verification_bits if b),
        "ingestion_status": ingestion_status,
        "ingestion_next_step": next_step,
        "bib_key": bib_key(paper_title, rec.get("paper_year"), dataset_doi),
    }


def kg_record(record: dict[str, Any]) -> dict[str, Any]:
    dataset_ref_slug = slug(record.get("dataset_doi") or "unknown")
    publication_doi = record.get("publication_doi") or ""
    paper_id = (
        f"paper:doi:{publication_doi}"
        if publication_doi
        else f"paper:dataset_first_unresolved:{dataset_ref_slug}"
    )
    dataset_id = f"dataset_candidate:dataset_first:{record.get('dataset_repo') or 'unknown'}:{dataset_ref_slug}"
    source_ref = "; ".join(
        part
        for part in (
            f"Dataset-first verified candidate {record.get('dataset_doi')}",
            f"Publication DOI {publication_doi}" if publication_doi else "no linked publication in repo metadata",
            f"Repo relation: {record.get('linked_publication_relationship')}" if record.get("linked_publication_relationship") else "",
        )
        if part
    )
    evidence = record.get("verification_notes") or "Verified dataset-first candidate (real files confirmed via Dryad/Zenodo API)."
    return {
        "paper_id": paper_id,
        "bib_key": record["bib_key"],
        "paper_title": record["publication_title"],
        "paper_doi": record["publication_doi"],
        "dataset_name_in_paper": record.get("dataset_title") or record.get("dataset_doi") or "",
        "canonical_dataset_id": dataset_id,
        "target_type": "DatasetCandidate",
        "ingestion_status": record["ingestion_status"],
        "theme": "",
        "n_observations": None,
        "n_covariates": None,
        "source_type": "dataset_first_verified_candidate",
        "source_ref": source_ref,
        "source_url": f"https://doi.org/{record['dataset_doi']}" if record.get("dataset_doi") else None,
        "evidence": evidence,
        "evidence_page": None,
        "estimators_used": record.get("estimators_from_metadata") or [],
        "cv_scheme": None,
        "formula": record.get("formula_pub"),
        "spatial_characterization": (
            "Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py "
            "DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data "
            "files before any fiche is written."
        ),
        "confidence": "medium" if record["ingestion_status"].startswith("raw_data_downloaded") else "low",
        "dataset_doi": record.get("dataset_doi"),
        "data_access_url": None,
        "local_pdf": record.get("local_pdf"),
        "local_tei": record.get("local_tei"),
        "local_raw_dir": record.get("local_raw_dir"),
        "formula_completeness": record.get("formula_completeness"),
    }


def write_report(path: Path, rows: list[dict[str, Any]], inserted: int, updated: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    by_status: dict[str, int] = {}
    for row in rows:
        by_status[row["ingestion_status"]] = by_status.get(row["ingestion_status"], 0) + 1
    unresolved = [r for r in rows if not r.get("publication_resolved")]
    incomplete = [r for r in rows if (r.get("formula_completeness") or {}).get("status") == "incomplete"]

    lines = [
        "# Ingestion des candidats dataset-first verifies (Dryad + Zenodo)",
        "",
        f"Date : {date.today().isoformat()}",
        "",
        f"- Candidats verifies traites : **{len(rows)}**",
        f"- Derniere execution : **{inserted}** insertion(s), **{updated}** mise(s) a jour dans `inst/kg/paper_dataset_uses.json`",
        "- Repartition par statut : " + ", ".join(f"{k}={v}" for k, v in sorted(by_status.items())),
        f"- Sans publication liee resolue (paper_doi absent ou non trouve via OpenAlex) : **{len(unresolved)}**",
        f"- Dont formule incomplete (variable(s) manquante(s) detectee(s)) : **{len(incomplete)}**",
        "",
        "Ces lignes ne signifient pas encore que les datasets sont prets pour `spatialtidymodels`.",
        "Elles alimentent la meme file de curation reproductible que journal-first/DataCite : "
        "KG -> tools/build_paper_dataset_curation_manifest.py -> loader sf -> fiche dataset -> metadata package.",
        "",
        "| Dataset | Repo | Publication | Statut | Formule | Etape suivante |",
        "|---|---|---|---|---|---|",
    ]
    for row in rows:
        fc_status = (row.get("formula_completeness") or {}).get("status", "non_extraite")
        lines.append(
            "| {dataset} | {repo} | {paper} | {status} | {formula} | {next_step} |".format(
                dataset=(row.get("dataset_doi") or "").replace("|", "/"),
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
            lines.append(f"- **{row.get('dataset_doi')}** ({row.get('publication_title')}) : {fc['note']}")

    if unresolved:
        lines += ["", "## Sans publication liee resolue", ""]
        for row in unresolved:
            lines.append(f"- **{row.get('dataset_doi')}** : {row.get('verification_notes')}")

    path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    args = parse_args()
    candidates_path = Path(args.candidates).resolve()
    kg_path = Path(args.kg_manifest).resolve()

    accumulator = read_json(candidates_path, {"records": []})
    ingestion_rows = [r for r in (ingestion_record(rec) for rec in accumulator.get("records", [])) if r is not None]
    kg_rows = [kg_record(row) for row in ingestion_rows]
    updated_payload = upsert_kg_manifest(kg_path, kg_rows)
    metadata = updated_payload.get("metadata", {})

    print(f"verified dataset-first candidates: {len(ingestion_rows)}")
    print(f"PaperDatasetUse inserted: {metadata.get('last_dataset_first_inserted', 0)}")
    print(f"PaperDatasetUse updated: {metadata.get('last_dataset_first_updated', 0)}")
    if args.dry_run:
        return 0

    if not ingestion_rows:
        print("Aucun candidat verifie a ingerer -- rien ecrit.")
        return 0

    write_json(Path(args.output_json).resolve(), ingestion_rows)
    write_csv(Path(args.output_csv).resolve(), ingestion_rows)
    write_staging_bib(Path(args.staging_bib).resolve(), ingestion_rows)
    write_json(kg_path, updated_payload)
    write_report(
        Path(args.report).resolve(),
        ingestion_rows,
        int(metadata.get("last_dataset_first_inserted", 0)),
        int(metadata.get("last_dataset_first_updated", 0)),
    )
    print(f"manifest: {args.output_json}")
    print(f"excel_csv: {args.output_csv}")
    print(f"staging_bib: {args.staging_bib}")
    print(f"kg_manifest: {kg_path}")
    print(f"report: {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
