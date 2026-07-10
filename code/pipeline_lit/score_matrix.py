"""Score literature candidates against plan seeds without querying remote APIs."""

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

from lit_common import resolve_plan_payload, save_plan_payload


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


def _score_record(record: dict[str, Any], seeds: list[dict[str, Any]], warehouse_title: str) -> dict[str, Any]:
    text = " ".join(str(record.get(field, "")) for field in ("title", "display_name", "abstract", "summary", "text"))
    text_lower = text.lower()
    score = 0
    matched_reasons: list[str] = []
    matched_datasets: set[str] = set()
    doi = str(record.get("doi", "")).lower()

    for seed in seeds:
        query = seed.get("query_text", "")
        if query and query.lower() in text_lower:
            score += 25
            matched_reasons.append(f"title_or_query_match:{seed['dataset_id']}")
            matched_datasets.add(seed["dataset_id"])
        seed_doi = (seed.get("dataset_doi") or seed.get("publication_doi") or "").lower()
        if seed_doi and doi and seed_doi == doi:
            score += 60
            matched_reasons.append(f"doi_match:{seed['dataset_id']}")
            matched_datasets.add(seed["dataset_id"])

    if warehouse_title.lower() in text_lower:
        score += 10
        matched_reasons.append("warehouse_match")

    if re.search(r"(?i)\b(data availability|supplementary data|code availability|available at|github|gitlab|zenodo)\b", text):
        score += 8
        matched_reasons.append("data_availability_terms")

    return {
        "record_id": record.get("id") or record.get("doi") or record.get("title"),
        "score": score,
        "matched_dataset_ids": sorted(matched_datasets),
        "matched_reasons": matched_reasons,
        "source_record": record,
    }


def main() -> None:
    """Entry point for candidate scoring."""

    parser = argparse.ArgumentParser(description="Score local literature records against a warehouse literature plan.")
    parser.add_argument("--input", help="JSON/JSONL records to score.")
    parser.add_argument("--plan", help="Path to a saved literature plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write scored candidates.")
    args = parser.parse_args()

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
    )
    payload: dict[str, Any] = {
        "warehouse_id": plan_payload["warehouse_id"],
        "warehouse_title": plan_payload["warehouse_title"],
        "scoring_rules": {
            "doi_match": 60,
            "title_or_query_match": 25,
            "warehouse_match": 10,
            "data_availability_terms": 8,
        },
        "records": [],
    }

    if args.input:
        records = _load_records(args.input)
        payload["records"] = [
            _score_record(record, plan_payload.get("seeds_preview", []), plan_payload["warehouse_title"])
            for record in records
        ]
        payload["records"].sort(key=lambda item: item["score"], reverse=True)

    if args.write:
        save_plan_payload(payload, args.write)
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
