"""Prepare executable literature collection jobs from a saved or generated plan.

This runner packages the exact request batches, downstream checks, and output
targets. Use query_openalex.py or query_crossref.py with --execute for the
network phase.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import (
    build_crossref_requests,
    build_doi_report,
    build_license_report,
    build_openalex_requests,
    resolve_plan_payload,
    save_plan_payload,
)


def main() -> None:
    parser = argparse.ArgumentParser(description="Build dry-run literature jobs from a plan.")
    parser.add_argument("--plan", help="Path to a saved literature plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument("--mailto", help="Optional etiquette email for future API execution.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the generated job batch.")
    args = parser.parse_args()

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
    )
    payload = {
        "mode": "dry_run",
        "warehouse_id": plan_payload["warehouse_id"],
        "warehouse_title": plan_payload["warehouse_title"],
        "seed_count": plan_payload["seed_count"],
        "openalex_requests": build_openalex_requests(plan_payload, mailto=args.mailto),
        "crossref_requests": build_crossref_requests(plan_payload, mailto=args.mailto),
        "doi_report": build_doi_report(
            warehouse_id=plan_payload["warehouse_id"],
            dataset_id=args.dataset_id,
        ),
        "license_report": build_license_report(
            warehouse_id=plan_payload["warehouse_id"],
            dataset_id=args.dataset_id,
        ),
        "notes": [
            "This runner does not execute OpenAlex or Crossref requests directly.",
            "Run query_openalex.py --execute or query_crossref.py --execute to collect and score paper candidates.",
            "Then run extract_dataset_links_from_papers.py to inspect landing pages and locate dataset repositories.",
        ],
    }

    if args.write:
        save_plan_payload(payload, args.write)
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
