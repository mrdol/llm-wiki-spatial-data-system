"""Build DOI completeness reports for datasets covered by literature plans."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import build_doi_report, save_plan_payload


def main() -> None:
    """Entry point for DOI report generation."""

    parser = argparse.ArgumentParser(description="Check dataset and publication DOI coverage.")
    parser.add_argument("--warehouse-id", help="Restrict the report to one warehouse.")
    parser.add_argument("--dataset-id", help="Restrict the report to one dataset.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the DOI report.")
    args = parser.parse_args()

    payload = build_doi_report(warehouse_id=args.warehouse_id, dataset_id=args.dataset_id)
    if args.write:
        save_plan_payload(payload, args.write)
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
