"""Prepare executable portal scraping jobs from a saved or generated plan.

This runner stays in dry-run mode by default. It does not fetch anything yet.
It materializes the exact jobs, parser hints, and output targets so the next
network-enabled phase can run immediately.
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from portal_common import (
    add_paper_enrichment_to_plan_payload,
    build_fetch_jobs,
    resolve_plan_payload,
    save_plan_payload,
)


WAREHOUSE_LAYER_DEFAULTS: dict[str, tuple[str, ...]] = {
    "insee": ("portal", "publication_page", "bulk_download", "api"),
    "eurostat": ("portal", "metadata_page", "api", "bulk_download"),
    "data_gouv": ("portal", "bulk_download", "api"),
    "oecd": ("publication_portal", "api", "catalog"),
    "world_bank": ("catalog", "bulk_download", "api", "sdmx_api_documentation"),
    "un_comtrade": ("portal", "methodology_page", "record_layout", "api_catalogue", "api_portal_reference"),
    "cepii": ("direct_download_portal", "portal", "bulk_download"),
}


def main() -> None:
    parser = argparse.ArgumentParser(description="Build dry-run portal scraping jobs from a plan.")
    parser.add_argument("--plan", help="Path to a saved portal plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument("--include-nonpreferred", action="store_true", help="Keep all discovery layers.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the generated job batch.")
    parser.add_argument(
        "--enrich-paper",
        action="store_true",
        help="Enrich plan seeds with paper abstracts/modeling signals when catalog DOI links exist.",
    )
    parser.add_argument("--mailto", help="Optional email parameter for polite OpenAlex API requests.")
    args = parser.parse_args()

    preferred_layer_types = None
    if args.warehouse_id:
        preferred_layer_types = WAREHOUSE_LAYER_DEFAULTS.get(args.warehouse_id)
        if preferred_layer_types is None:
            raise ValueError(f"No default layer configuration for warehouse_id={args.warehouse_id}")

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        preferred_layer_types=preferred_layer_types,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
        include_nonpreferred=args.include_nonpreferred,
    )
    if args.enrich_paper:
        add_paper_enrichment_to_plan_payload(plan_payload, mailto=args.mailto)
    payload = {
        "mode": "dry_run",
        "warehouse_id": plan_payload["warehouse_id"],
        "warehouse_title": plan_payload["warehouse_title"],
        "seed_count": plan_payload["seed_count"],
        "job_count": len(plan_payload.get("seeds_preview", [])),
        "jobs": build_fetch_jobs(plan_payload),
        "notes": [
            "No HTTP requests are executed by this runner.",
            "The next implementation step is to execute each job and append raw results to raw_response_jsonl.",
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
