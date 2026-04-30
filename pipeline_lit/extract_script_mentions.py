"""Prepare code-repository mention extraction rules or apply them locally."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

from lit_common import save_plan_payload


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
    """Entry point for repository mention extraction."""

    parser = argparse.ArgumentParser(description="Build or apply script mention extraction rules.")
    parser.add_argument("--input", help="Optional JSON/JSONL literature records to scan.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the extraction results.")
    args = parser.parse_args()

    patterns = {
        "github_url": r"https?://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+",
        "gitlab_url": r"https?://gitlab\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+",
        "bitbucket_url": r"https?://bitbucket\.org/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+",
        "generic_code_terms": r"(?i)\b(code|repository|github|gitlab|script|software|source code)\b",
    }
    payload: dict[str, Any] = {"patterns": patterns}

    if args.input:
        matches = []
        for record in _load_records(args.input):
            haystack = " ".join(str(record.get(field, "")) for field in ("title", "abstract", "summary", "text"))
            found = {
                key: re.findall(pattern, haystack)
                for key, pattern in patterns.items()
                if re.search(pattern, haystack)
            }
            if found:
                matches.append(
                    {
                        "record_id": record.get("id") or record.get("doi") or record.get("title"),
                        "matches": found,
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
