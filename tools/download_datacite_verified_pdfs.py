#!/usr/bin/env python
"""Telecharger les PDF open access des candidats DataCite valides.

Etape de secours: si tools/check_dataset_availability.py a deja recupere le
PDF en amont (pre-flight check), ce script ne refait rien (already_present).
Sinon il retente ici, plus tard dans le pipeline (ex. apres une correction
manuelle d'URL).
"""

from __future__ import annotations

import argparse
import csv
import json
import sys
import time
from pathlib import Path
from typing import Any

from paper_pdf_check import build_session, fetch_pdf

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_INPUT = ROOT / "data" / "manifests" / "papers" / "datacite_verified_ingestion_manifest.json"
DEFAULT_PDF_DIR = ROOT / "corpus" / "papers" / "raw_pdf"
DEFAULT_MANIFEST = ROOT / "data" / "manifests" / "papers" / "datacite_verified_pdf_download_manifest.csv"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Download OA PDFs for verified DataCite candidates.")
    parser.add_argument("--input", default=str(DEFAULT_INPUT), help="Manifeste JSON d'ingestion.")
    parser.add_argument("--pdf-dir", default=str(DEFAULT_PDF_DIR), help="Dossier cible des PDF.")
    parser.add_argument("--manifest", default=str(DEFAULT_MANIFEST), help="Manifeste CSV des telechargements.")
    parser.add_argument("--sleep", type=float, default=0.5, help="Pause en secondes entre deux requetes.")
    parser.add_argument("--timeout", type=int, default=90, help="Timeout HTTP par requete.")
    parser.add_argument("--dry-run", action="store_true", help="N'ecrit aucun PDF.")
    return parser.parse_args()


def read_rows(path: Path) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8-sig") as handle:
        data = json.load(handle)
    if not isinstance(data, list):
        raise ValueError(f"Le manifeste doit etre une liste JSON: {path}")
    return [dict(row) for row in data]


def write_manifest(path: Path, rows: list[dict[str, str]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = list(rows[0].keys()) if rows else []
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fields, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def main() -> int:
    args = parse_args()
    input_path = Path(args.input).resolve()
    pdf_dir = Path(args.pdf_dir).resolve()
    manifest_path = Path(args.manifest).resolve()

    rows = read_rows(input_path)
    session = build_session()
    outputs = []
    for index, row in enumerate(rows, start=1):
        print(f"[{index}/{len(rows)}] {row.get('publication_doi') or row.get('dataset_doi')}", flush=True)
        result = fetch_pdf(row, pdf_dir, session, timeout=args.timeout, dry_run=args.dry_run)
        result["local_pdf"] = (
            str(Path(result["local_pdf"]).relative_to(ROOT))
            if Path(result["local_pdf"]).is_relative_to(ROOT)
            else result["local_pdf"]
        )
        outputs.append(result)
        if args.sleep > 0:
            time.sleep(args.sleep)
    write_manifest(manifest_path, outputs)
    counts: dict[str, int] = {}
    for row in outputs:
        counts[row["status"]] = counts.get(row["status"], 0) + 1
    print("summary:", counts)
    print(f"manifest: {manifest_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
