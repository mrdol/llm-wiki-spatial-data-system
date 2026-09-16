#!/usr/bin/env python
"""Verification precoce de faisabilite d'un candidat DataCite (dataset + papier).

A lancer juste apres tools/harvest_datacite.R, AVANT verify_datacite_candidates.py
(economie d'appels Claude), AVANT ingest_datacite_verified.py (pas de stub KG
pour un candidat mort), et AVANT GROBID.

Un candidat n'est garde que si LES DEUX liens marchent :
1. le dataset a un listing de fichiers qui ressemble a une vraie microdonnee
   (pas un miroir de data-availability d'article type SciELO/figshare) ;
2. le PDF du papier est effectivement recuperable (open access reel, pas une
   page HTML bloquee ou payante) - le PDF est telecharge ici meme, pour ne
   pas refaire ce travail plus tard dans le pipeline.

Motivation (2026-08-08) : le pipeline decouvrait ces deux problemes en tout
dernier, apres avoir deja paye le cout de la verification Claude, de
l'ingestion KG et de GROBID. Ce script deplace les deux controles tout en
amont, puisqu'ils ne dependent que des metadonnees deja connues au harvest.

Usage:
    python tools/check_dataset_availability.py
    python tools/check_dataset_availability.py --candidates-json path/to/candidates.json
    python tools/check_dataset_availability.py --skip-pdf-check   # dataset uniquement
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path
from typing import Any

from dataset_manifest_check import check_dataset_doi
from paper_pdf_check import build_session, fetch_pdf

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CANDIDATES = ROOT / "data" / "manifests" / "papers" / "datacite_spatial_dataset_candidates.json"
DEFAULT_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"

PDF_READY_STATUSES = {"downloaded", "already_present"}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Early feasibility check (dataset + paper) for DataCite harvest candidates.")
    parser.add_argument("--candidates-json", default=str(DEFAULT_CANDIDATES))
    parser.add_argument("--pdf-dir", default=str(DEFAULT_PDF_DIR))
    parser.add_argument("--max-size-mb", type=float, default=200, help="Ecarte les depots plus lourds (projet cible des jeux 'pas lourds'). 0 = pas de limite.")
    parser.add_argument("--sleep", type=float, default=0.3, help="Pause entre deux candidats.")
    parser.add_argument("--pdf-timeout", type=int, default=60)
    parser.add_argument("--skip-pdf-check", action="store_true", help="Ne verifier que le dataset, pas le PDF.")
    parser.add_argument("--dry-run", action="store_true", help="N'ecrit rien (ni JSON filtre, ni PDF), affiche seulement le verdict.")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    path = Path(args.candidates_json).resolve()
    pdf_dir = Path(args.pdf_dir).resolve()
    rows: list[dict[str, Any]] = json.loads(path.read_text(encoding="utf-8-sig"))

    session = build_session()
    kept: list[dict[str, Any]] = []
    dropped: list[dict[str, Any]] = []

    for index, row in enumerate(rows, start=1):
        dataset_doi = str(row.get("dataset_doi") or "")
        data_access_url = str(row.get("data_access_url") or row.get("source_url") or "")
        title = str(row.get("title") or "")[:60]

        max_size_mb = args.max_size_mb if args.max_size_mb > 0 else None
        dataset_verdict = check_dataset_doi(dataset_doi, data_access_url, max_size_mb=max_size_mb)
        # Champs a plat (pas de dict imbrique) : le pipeline R en aval
        # (apply_datacite_verification.R) ecrit ces lignes en CSV et
        # readr::write_excel_csv2 rejette les colonnes liste/matrice.
        row["dataset_check_repo"] = dataset_verdict["repo"]
        row["dataset_check_ok"] = dataset_verdict["probably_real_dataset"]
        row["dataset_check_reason"] = dataset_verdict["reason"]

        if not dataset_verdict["probably_real_dataset"]:
            row["candidate_status"] = "rejected_supplement_mirror_early_check"
            print(f"[{index}/{len(rows)}] {dataset_doi} -> REJECT (dataset) : {dataset_verdict['reason'][:80]}")
            dropped.append(row)
            continue

        if args.skip_pdf_check:
            print(f"[{index}/{len(rows)}] {dataset_doi} -> dataset OK, PDF check skippe : {title}")
            kept.append(row)
            if args.sleep > 0:
                time.sleep(args.sleep)
            continue

        pdf_result = fetch_pdf(row, pdf_dir, session, timeout=args.pdf_timeout, dry_run=args.dry_run)
        row["pdf_check_status"] = pdf_result["status"]
        row["pdf_check_note"] = pdf_result.get("note", "")

        if pdf_result["status"] not in PDF_READY_STATUSES:
            row["candidate_status"] = "rejected_pdf_not_accessible_early_check"
            print(
                f"[{index}/{len(rows)}] {dataset_doi} -> dataset OK, REJECT (papier) : "
                f"{pdf_result['status']} : {title}"
            )
            dropped.append(row)
        else:
            row["local_pdf"] = pdf_result["local_pdf"]
            row["open_access_pdf_url"] = pdf_result.get("source_url") or row.get("open_access_pdf_url") or row.get("article_oa_url")
            print(f"[{index}/{len(rows)}] {dataset_doi} -> OK (dataset + papier) : {title}")
            kept.append(row)

        if args.sleep > 0:
            time.sleep(args.sleep)

    print(f"\nkept={len(kept)}  dropped={len(dropped)}  total={len(rows)}")
    dataset_drops = sum(1 for r in dropped if r.get("candidate_status") == "rejected_supplement_mirror_early_check")
    pdf_drops = sum(1 for r in dropped if r.get("candidate_status") == "rejected_pdf_not_accessible_early_check")
    print(f"  dropped as dataset supplement-mirror: {dataset_drops}")
    print(f"  dropped as paper not accessible: {pdf_drops}")

    if args.dry_run:
        return 0

    path.write_text(json.dumps(kept, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    dropped_path = path.with_name(path.stem + "_dropped_early_check.json")
    dropped_path.write_text(json.dumps(dropped, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"candidates (filtered, both links verified): {path}")
    print(f"dropped (trace, not re-fed into the pipeline): {dropped_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
