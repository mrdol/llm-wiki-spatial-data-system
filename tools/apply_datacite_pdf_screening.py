#!/usr/bin/env python
"""Appliquer la decision de screening PDF apres download_datacite_verified_pdfs.py.

Version generique (remplace l'ancienne version a listes codees en dur du
2026-08-06, qui ne s'appliquait qu'a un lot precis de DOI). Cette version lit
le statut reel ecrit par `download_datacite_verified_pdfs.py` dans
`datacite_verified_pdf_download_manifest.csv` et applique la regle:

- status == "downloaded"       -> ingestion_status = pdf_present_pending_grobid
- status == "already_present"  -> ingestion_status = pdf_present_pending_grobid
- status == "manual_downloaded" -> ingestion_status = pdf_present_pending_grobid
- tout autre statut             -> ingestion_status = pdf_not_accessible_needs_manual_retrieval
  (pas un rejet definitif : le PDF peut exister derriere un acces qui necessite
  une recuperation manuelle - abonnement institutionnel, portail specifique -
  jamais en contournant une protection anti-bot/CAPTCHA)

Le script met a jour les manifestes DataCite et les usages papier-dataset du KG
sans supprimer les traces historiques.
"""

from __future__ import annotations

import csv
import html
import json
import re
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
PAPER_USE_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
CANDIDATES_JSON = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates.json"
CANDIDATES_CSV = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates_excel.csv"
INGEST_JSON = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest.json"
INGEST_CSV = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest_excel.csv"
PDF_MANIFEST = ROOT / "data" / "manifests" / "papers" / "datacite_verified_pdf_download_manifest.csv"
REPORT = ROOT / "wiki" / "analyses" / "datacite_pdf_screening_latest.md"

READY_STATUSES = {"downloaded", "already_present", "manual_downloaded"}


def normalize_doi(value: Any) -> str:
    text = str(value or "").strip().lower()
    text = text.replace("https://doi.org/", "").replace("http://dx.doi.org/", "")
    return text.replace("doi:", "").strip().rstrip(".")


def clean_text(value: Any) -> str:
    text = html.unescape(str(value or ""))
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def read_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def write_json(path: Path, payload: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle, delimiter=";"))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    if not rows:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    fields: list[str] = []
    seen: set[str] = set()
    for row in rows:
        for key in row.keys():
            if key not in seen:
                seen.add(key)
                fields.append(key)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def pdf_decisions(pdf_rows: list[dict[str, Any]]) -> dict[str, dict[str, Any]]:
    """Construit doi -> {ready, local_pdf, status, note} depuis le manifeste PDF."""
    decisions: dict[str, dict[str, Any]] = {}
    for row in pdf_rows:
        doi = normalize_doi(row.get("publication_doi"))
        if not doi:
            continue
        status = (row.get("status") or "").strip()
        decisions[doi] = {
            "ready": status in READY_STATUSES,
            "local_pdf": row.get("local_pdf") or "",
            "status": status,
            "note": row.get("note") or "",
        }
    return decisions


def update_candidate_row(row: dict[str, Any], decisions: dict[str, dict[str, Any]]) -> dict[str, Any]:
    doi = normalize_doi(row.get("publication_doi"))
    decision = decisions.get(doi)
    if decision is None:
        return row
    if decision["ready"]:
        row["candidate_status"] = "verified_candidate"
        row["local_pdf"] = decision["local_pdf"]
        row["ingestion_next_step"] = "run GROBID -> KG -> formula/model evidence -> dataset fiche"
    else:
        row["candidate_status"] = "needs_manual_curation"
        row["ingestion_next_step"] = (
            "PDF not fetched automatically (status=" + decision["status"] + "); "
            "requires manual retrieval through a legitimate access path (no anti-bot bypass) "
            "before GROBID can run."
        )
    return row


def update_ingestion_rows(rows: list[dict[str, Any]], decisions: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    kept = []
    for row in rows:
        doi = normalize_doi(row.get("publication_doi"))
        decision = decisions.get(doi)
        if decision is None:
            kept.append(row)
            continue
        if decision["ready"]:
            row["local_pdf"] = decision["local_pdf"]
            row["ingestion_status"] = "pdf_present_pending_grobid"
            row["ingestion_next_step"] = "run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted"
        else:
            row["ingestion_status"] = "pdf_not_accessible_needs_manual_retrieval"
            row["ingestion_next_step"] = (
                "No automated OA PDF found (status=" + decision["status"] + "). "
                "Needs a manual, legitimate download (institutional access, author copy, etc.) "
                "before GROBID/KG ingestion can proceed."
            )
        kept.append(row)
    return kept


def update_paper_dataset_uses(payload: dict[str, Any], decisions: dict[str, dict[str, Any]]) -> dict[str, Any]:
    updated = 0
    for row in payload.get("records", []):
        if row.get("source_type") != "datacite_verified_candidate":
            continue
        doi = normalize_doi(row.get("paper_doi"))
        decision = decisions.get(doi)
        if decision is None:
            continue
        if decision["ready"]:
            row["ingestion_status"] = "pdf_present_pending_grobid"
            row["local_pdf"] = decision["local_pdf"]
        else:
            row["ingestion_status"] = "pdf_not_accessible_needs_manual_retrieval"
            row["evidence"] = (row.get("evidence") or "") + (
                " | PDF screening: no automated OA PDF found (status=" + decision["status"] + ")."
            )
        updated += 1
    payload.setdefault("metadata", {})
    payload["metadata"]["datacite_pdf_screening_date"] = date.today().isoformat()
    payload["metadata"]["datacite_pdf_screening_updated"] = updated
    return payload


def write_report(pdf_rows: list[dict[str, Any]], decisions: dict[str, dict[str, Any]]) -> None:
    ready_rows = [r for r in pdf_rows if decisions.get(normalize_doi(r.get("publication_doi")), {}).get("ready")]
    pending_rows = [r for r in pdf_rows if not decisions.get(normalize_doi(r.get("publication_doi")), {}).get("ready")]
    lines = [
        "# Screening PDF DataCite - dernier passage",
        "",
        f"Date : {date.today().isoformat()}",
        "",
        f"- PDF traites : **{len(pdf_rows)}**",
        f"- PDF prets pour GROBID : **{len(ready_rows)}**",
        f"- PDF non recuperes automatiquement (retrait manuel requis) : **{len(pending_rows)}**",
        "",
        "## Prets pour GROBID",
        "",
        "| DOI article | Article | PDF local |",
        "|---|---|---|",
    ]
    for row in ready_rows:
        lines.append(
            "| {doi} | {title} | `{pdf}` |".format(
                doi=row.get("publication_doi", ""),
                title=clean_text(row.get("publication_title", "")).replace("|", "/"),
                pdf=row.get("local_pdf", ""),
            )
        )
    lines.extend(
        [
            "",
            "## Recuperation manuelle requise",
            "",
            "| DOI article | Article | Statut | URL source tentee |",
            "|---|---|---|---|",
        ]
    )
    for row in pending_rows:
        lines.append(
            "| {doi} | {title} | {status} | {url} |".format(
                doi=row.get("publication_doi", ""),
                title=clean_text(row.get("publication_title", "")).replace("|", "/"),
                status=row.get("status", ""),
                url=clean_text(row.get("source_url", "")).replace("|", "/"),
            )
        )
    REPORT.parent.mkdir(parents=True, exist_ok=True)
    REPORT.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    pdf_rows = read_csv(PDF_MANIFEST)
    decisions = pdf_decisions(pdf_rows)

    candidates = [update_candidate_row(row, decisions) for row in read_json(CANDIDATES_JSON)]
    write_json(CANDIDATES_JSON, candidates)
    write_csv(CANDIDATES_CSV, candidates)

    ingestion_rows = update_ingestion_rows(read_json(INGEST_JSON), decisions)
    write_json(INGEST_JSON, ingestion_rows)
    write_csv(INGEST_CSV, ingestion_rows)

    write_json(PAPER_USE_PATH, update_paper_dataset_uses(read_json(PAPER_USE_PATH), decisions))
    write_report(pdf_rows, decisions)

    ready = sum(1 for d in decisions.values() if d["ready"])
    pending = sum(1 for d in decisions.values() if not d["ready"])
    print(f"ready_for_grobid={ready}")
    print(f"needs_manual_retrieval={pending}")
    print(f"report={REPORT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
