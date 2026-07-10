"""Prepare dataset-mention extraction rules or apply them to local records."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import dataset_aliases_from_plan, resolve_plan_payload, save_plan_payload


def _load_records(input_path: str) -> list[dict[str, Any]]:
    path = Path(input_path)
    if path.suffix.lower() == ".jsonl":
        return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]
    data = json.loads(path.read_text(encoding="utf-8"))
    if isinstance(data, list):
        return data
    if isinstance(data, dict):
        return data.get("records", [])
    return []


def main() -> None:
    """Entry point for dataset mention extraction preparation."""

    parser = argparse.ArgumentParser(description="Build dataset mention rules or apply them to local literature records.")
    parser.add_argument("--plan", help="Path to a saved literature plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument("--input", help="Optional JSON/JSONL literature records to scan.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the extraction results.")
    args = parser.parse_args()

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
    )
    aliases = dataset_aliases_from_plan(plan_payload)
    payload: dict[str, Any] = {
        "warehouse_id": plan_payload["warehouse_id"],
        "dataset_aliases": aliases,
        "rules": {
            dataset_id: [rf"(?i)\b{re.escape(alias)}\b" for alias in alias_list]
            for dataset_id, alias_list in aliases.items()
        },
    }

    if args.input:
        matches = []
        for record in _load_records(args.input):
            haystack = " ".join(
                str(record.get(field, ""))
                for field in ("title", "display_name", "abstract", "summary", "text")
            )
            matched_dataset_ids = []
            for dataset_id, patterns in payload["rules"].items():
                if any(re.search(pattern, haystack) for pattern in patterns):
                    matched_dataset_ids.append(dataset_id)
            if matched_dataset_ids:
                matches.append(
                    {
                        "record_id": record.get("id") or record.get("doi") or record.get("title"),
                        "matched_dataset_ids": matched_dataset_ids,
                    }
                )
        payload["matches"] = matches

    if args.write:
        save_plan_payload(payload, args.write)
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
