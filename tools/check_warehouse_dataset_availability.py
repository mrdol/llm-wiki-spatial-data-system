#!/usr/bin/env python
"""Controle precoce des candidats Bloc 3 (entrepots, sans papier associe).

A la difference du Bloc 2 (check_dataset_availability.py), il n'y a pas de
PDF a recuperer - le dataset est juge sur ses seuls merites structurels :

1. Pas un miroir de data-availability d'article (meme controle que Bloc 2) ;
2. PAS uniquement du raster/imagerie - il faut au moins un fichier
   vecteur/tabulaire (Y/X potentiellement identifiables) ;
3. Poids total sous le plafond "pas lourd" du projet.

Usage:
    python tools/check_warehouse_dataset_availability.py
    python tools/check_warehouse_dataset_availability.py --max-size-mb 200
"""

from __future__ import annotations

import argparse
import json
import sys
import time
from pathlib import Path
from typing import Any

from dataset_manifest_check import check_dataset_doi

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")


ROOT = Path(__file__).resolve().parent.parent
DEFAULT_CANDIDATES = ROOT / "data" / "manifests" / "papers" / "warehouse_dataset_candidates.json"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Early structural check for Bloc 3 (warehouse, no-paper) candidates.")
    parser.add_argument("--candidates-json", default=str(DEFAULT_CANDIDATES))
    parser.add_argument("--max-size-mb", type=float, default=200, help="Ecarte les depots plus lourds. 0 = pas de limite.")
    parser.add_argument("--sleep", type=float, default=0.3)
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    path = Path(args.candidates_json).resolve()
    rows: list[dict[str, Any]] = json.loads(path.read_text(encoding="utf-8-sig"))
    max_size_mb = args.max_size_mb if args.max_size_mb > 0 else None

    kept: list[dict[str, Any]] = []
    dropped: list[dict[str, Any]] = []

    for index, row in enumerate(rows, start=1):
        dataset_doi = str(row.get("dataset_doi") or "")
        data_access_url = str(row.get("data_access_url") or row.get("source_url") or "")
        title = str(row.get("title") or "")[:60]

        verdict = check_dataset_doi(dataset_doi, data_access_url, max_size_mb=max_size_mb, require_vector_tabular=True)
        row["dataset_check_repo"] = verdict["repo"]
        row["dataset_check_ok"] = verdict["probably_real_dataset"]
        row["dataset_check_reason"] = verdict["reason"]
        row["dataset_check_size_mb"] = verdict.get("total_size_mb")

        if verdict["probably_real_dataset"]:
            print(f"[{index}/{len(rows)}] {dataset_doi} -> OK : {title}")
            kept.append(row)
        else:
            row["candidate_status"] = "rejected_warehouse_early_check"
            print(f"[{index}/{len(rows)}] {dataset_doi} -> REJECT : {verdict['reason'][:90]} : {title}")
            dropped.append(row)

        if verdict["checked"] and args.sleep > 0:
            time.sleep(args.sleep)

    print(f"\nkept={len(kept)}  dropped={len(dropped)}  total={len(rows)}")

    if args.dry_run:
        return 0

    path.write_text(json.dumps(kept, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    dropped_path = path.with_name(path.stem + "_dropped_early_check.json")
    dropped_path.write_text(json.dumps(dropped, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(f"candidates (filtered): {path}")
    print(f"dropped (trace): {dropped_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
