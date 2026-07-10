"""Find papers that likely hide spatial or spatio-temporal datasets with modeling."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any

import requests

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from lit_common import (
    DEFAULT_LIT_CANDIDATE_DIR,
    append_jsonl,
    literature_rows,
    normalize_openalex_work,
    write_csv,
)


DEFAULT_OUTPUT = DEFAULT_LIT_CANDIDATE_DIR / "spatiotemporal_modeling_papers.jsonl"
DEFAULT_QUERY = (
    '"spatiotemporal" dataset model OR "spatio-temporal" dataset regression OR '
    '"spatial panel" dataset OR "geospatial" dataset "machine learning"'
)


def openalex_search(
    query: str,
    *,
    max_pages: int,
    per_page: int,
    mailto: str | None,
    verbose: bool,
) -> list[dict[str, Any]]:
    session = requests.Session()
    works: list[dict[str, Any]] = []
    cursor = "*"
    for page in range(1, max_pages + 1):
        if verbose:
            print(f"Fetching OpenAlex page {page}", file=sys.stderr)
        params = {
            "search": query,
            "per-page": per_page,
            "cursor": cursor,
            "select": (
                "id,doi,title,publication_year,abstract_inverted_index,"
                "primary_location,locations,authorships"
            ),
        }
        if mailto:
            params["mailto"] = mailto
        try:
            response = session.get("https://api.openalex.org/works", params=params, timeout=60)
        except requests.RequestException as exc:
            if verbose:
                print(f"OpenAlex request failed: {exc}", file=sys.stderr)
            break
        if response.status_code != 200:
            if verbose:
                print(f"OpenAlex returned HTTP {response.status_code}", file=sys.stderr)
            break
        payload = response.json()
        results = payload.get("results") or []
        if not results:
            break
        works.extend(item for item in results if isinstance(item, dict))
        next_cursor = payload.get("meta", {}).get("next_cursor")
        if not next_cursor or next_cursor == cursor:
            break
        cursor = next_cursor
    return works


def discover_papers(
    *,
    query: str,
    max_pages: int,
    per_page: int,
    min_score: int,
    keep_only: bool,
    mailto: str | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    works = openalex_search(
        query,
        max_pages=max_pages,
        per_page=per_page,
        mailto=mailto,
        verbose=verbose,
    )
    records = [normalize_openalex_work(work, query=query) for work in works]
    records = [record for record in records if int(record.get("literature_score") or 0) >= min_score]
    if keep_only:
        records = [record for record in records if record.get("candidate_decision") == "keep"]
    records.sort(key=lambda item: int(item.get("literature_score") or 0), reverse=True)
    return records, len(works)


def print_markdown(rows: list[dict[str, Any]]) -> None:
    columns = ["paper_title", "paper_year", "task_type", "literature_score", "candidate_decision", "paper_doi"]
    print("| " + " | ".join(columns) + " |")
    print("|" + "|".join("---" for _ in columns) + "|")
    for row in rows:
        values = []
        for column in columns:
            value = row.get(column)
            text = "" if value is None else str(value).replace("\n", " ")
            if column == "paper_title" and len(text) > 90:
                text = text[:89] + "..."
            values.append(text.replace("|", "\\|"))
        print("| " + " | ".join(values) + " |")


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Discover papers likely linked to spatial/spatio-temporal datasets with modeling."
    )
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--per-page", type=int, default=25)
    parser.add_argument("--min-score", type=int, default=4)
    parser.add_argument("--keep-only", action="store_true")
    parser.add_argument("--mailto")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--write", nargs="?", const=str(DEFAULT_OUTPUT))
    parser.add_argument("--csv")
    parser.add_argument("--view", choices=("full", "summary", "markdown"), default="summary")
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    records, raw_count = discover_papers(
        query=args.query,
        max_pages=args.max_pages,
        per_page=args.per_page,
        min_score=args.min_score,
        keep_only=args.keep_only,
        mailto=args.mailto,
        verbose=not args.quiet,
    )
    if args.limit is not None:
        records = records[: args.limit]

    payload: dict[str, Any] = {
        "mode": "literature_spatiotemporal_dataset_discovery",
        "query": args.query,
        "raw_record_count": raw_count,
        "candidate_count": len(records),
        "records": records,
    }
    if args.write:
        append_jsonl(Path(args.write), records)
        payload["written_to"] = args.write

    rows = literature_rows(records)
    if args.csv:
        write_csv(Path(args.csv), rows)
        payload["csv_written_to"] = args.csv

    if args.view == "markdown":
        print_markdown(rows)
    elif args.view == "summary":
        summary = {
            "mode": payload["mode"],
            "query": payload["query"],
            "raw_record_count": payload["raw_record_count"],
            "candidate_count": payload["candidate_count"],
            "written_to": payload.get("written_to"),
            "csv_written_to": payload.get("csv_written_to"),
            "records": rows,
        }
        print(json.dumps(summary, indent=2 if args.pretty else None, ensure_ascii=True))
    elif args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
