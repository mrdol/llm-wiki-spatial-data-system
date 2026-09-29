#!/usr/bin/env python
"""Retente la conversion sf des candidats Bloc 3 deja telecharges mais echoues.

Ne retelecharge rien : relit data/raw/warehouse/<bib_key>/ et reapplique
warehouse_sf_conversion (utile apres un correctif du convertisseur, ex.
support zip/encodage/openpyxl).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from warehouse_sf_conversion import convert_warehouse_folder

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent
KG_PATH = ROOT / "inst" / "kg" / "paper_dataset_uses.json"
RAW_DIR = ROOT / "data" / "raw" / "warehouse"

TARGET_STATUS = "raw_data_downloaded_needs_manual_conversion"


def main() -> int:
    payload = json.loads(KG_PATH.read_text(encoding="utf-8-sig"))
    pending = [r for r in payload["records"] if r.get("ingestion_status") == TARGET_STATUS]
    print(f"Candidats a retenter : {len(pending)}")

    converted = 0
    for index, record in enumerate(pending, start=1):
        bib_key = record["bib_key"]
        folder = RAW_DIR / bib_key
        if not folder.exists():
            print(f"[{index}/{len(pending)}] {bib_key} -> dossier brut introuvable, ignore")
            continue
        result = convert_warehouse_folder(bib_key, folder)
        if result["status"] == "converted":
            record["ingestion_status"] = "converted_to_sf"
            record["local_sf_path"] = result["sf_path"]
            record["local_typology_path"] = result["typology_path"]
            record["n_observations"] = result["n_obs"]
            record.pop("conversion_failure_reason", None)
            converted += 1
            print(f"[{index}/{len(pending)}] {bib_key} -> converted_to_sf (N={result['n_obs']}, T={result['t_periods']})")
        else:
            record["conversion_failure_reason"] = result["reason"]
            print(f"[{index}/{len(pending)}] {bib_key} -> toujours en echec : {result['reason']}")

    if converted:
        KG_PATH.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")

    print(f"\nNouvellement convertis : {converted}/{len(pending)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
