"""Prepare or execute Crossref requests from warehouse literature plans."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

import requests

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import append_jsonl, build_crossref_requests, normalize_crossref_work, resolve_plan_payload, save_plan_payload


def execute_crossref_requests(requests_payload: list[dict], *, min_score: int, keep_only: bool, verbose: bool) -> list[dict]:
    session = requests.Session()
    records: list[dict] = []
    for request_payload in requests_payload:
        if verbose:
            print(f"Crossref: {request_payload['query_text']}", file=sys.stderr)
        try:
            response = session.get(
                request_payload["endpoint"],
                params=request_payload["params"],
                timeout=60,
            )
        except requests.RequestException as exc:
            if verbose:
                print(f"Crossref request failed: {exc}", file=sys.stderr)
            continue
        if response.status_code != 200:
            if verbose:
                print(f"Crossref returned HTTP {response.status_code}", file=sys.stderr)
            continue
        for work in response.json().get("message", {}).get("items", []):
            if not isinstance(work, dict):
                continue
            record = normalize_crossref_work(work, query=request_payload["query_text"])
            record["matched_dataset_id"] = request_payload["dataset_id"]
            record["matched_query_reason"] = request_payload["reason"]
            if int(record.get("literature_score") or 0) < min_score:
                continue
            if keep_only and record.get("candidate_decision") != "keep":
                continue
            records.append(record)
    records.sort(key=lambda item: int(item.get("literature_score") or 0), reverse=True)
    return records


def main() -> None:
    """Entry point for Crossref request preparation."""

    parser = argparse.ArgumentParser(description="Build Crossref request payloads from a literature plan.")
    parser.add_argument("--plan", help="Path to a saved literature plan JSON.")
    parser.add_argument("--warehouse-id", help="Warehouse id to build the plan on the fly.")
    parser.add_argument("--dataset-id", help="Restrict the generated plan to one dataset_id.")
    parser.add_argument("--mailto", help="Optional Crossref mailto parameter.")
    parser.add_argument("--rows", type=int, default=25, help="Rows per Crossref request.")
    parser.add_argument("--execute", action="store_true", help="Execute Crossref requests and score paper candidates.")
    parser.add_argument("--min-score", type=int, default=4)
    parser.add_argument("--keep-only", action="store_true")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the generated request batch.")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    plan_payload = resolve_plan_payload(
        warehouse_id=args.warehouse_id,
        dataset_id=args.dataset_id,
        plan_path=args.plan,
    )
    requests_payload = build_crossref_requests(plan_payload, mailto=args.mailto, rows=args.rows)
    payload = {
        "source": "crossref",
        "warehouse_id": plan_payload["warehouse_id"],
        "request_count": len(requests_payload),
        "requests": requests_payload,
    }
    if args.execute:
        records = execute_crossref_requests(
            requests_payload,
            min_score=args.min_score,
            keep_only=args.keep_only,
            verbose=not args.quiet,
        )
        payload = {
            "source": "crossref",
            "mode": "executed_literature_search",
            "warehouse_id": plan_payload["warehouse_id"],
            "request_count": len(requests_payload),
            "candidate_count": len(records),
            "records": records,
        }
    if args.write:
        if args.execute and str(args.write).lower().endswith(".jsonl"):
            append_jsonl(Path(args.write), payload["records"])
        else:
            save_plan_payload(payload, args.write)
    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
