"""Export scored literature candidates to compact structured summaries."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


def _load_payload(input_path: str) -> dict[str, Any]:
    path = Path(input_path)
    return json.loads(path.read_text(encoding="utf-8"))


def main() -> None:
    """Entry point for candidate export."""

    parser = argparse.ArgumentParser(description="Export scored candidate records into a compact summary.")
    parser.add_argument("--input", help="Path to a scored candidates JSON payload.")
    parser.add_argument("--top", type=int, default=20, help="How many top candidates to keep.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the exported summary.")
    args = parser.parse_args()

    if not args.input:
        payload = {
            "note": "Provide --input with a score_matrix output to export top candidates.",
            "expected_fields": ["record_id", "score", "matched_dataset_ids", "matched_reasons", "source_record"],
        }
    else:
        source_payload = _load_payload(args.input)
        records = source_payload.get("records", [])
        exported = [
            {
                "rank": index + 1,
                "record_id": record.get("record_id"),
                "score": record.get("score"),
                "matched_dataset_ids": record.get("matched_dataset_ids"),
                "matched_reasons": record.get("matched_reasons"),
            }
            for index, record in enumerate(records[: args.top])
        ]
        payload = {
            "warehouse_id": source_payload.get("warehouse_id"),
            "warehouse_title": source_payload.get("warehouse_title"),
            "top_n": args.top,
            "exported_candidates": exported,
        }

    if args.write:
        Path(args.write).write_text(json.dumps(payload, indent=2, ensure_ascii=True), encoding="utf-8")
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
