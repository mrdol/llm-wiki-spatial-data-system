"""Inspect paper metadata and landing pages to extract dataset links."""

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

from lit_common import DEFAULT_LIT_CANDIDATE_DIR, extract_dataset_links_from_text, save_plan_payload


DEFAULT_OUTPUT = DEFAULT_LIT_CANDIDATE_DIR / "paper_dataset_links.json"


def load_records(path: str | Path) -> list[dict[str, Any]]:
    input_path = Path(path)
    if input_path.suffix.lower() == ".jsonl":
        return [json.loads(line) for line in input_path.read_text(encoding="utf-8").splitlines() if line.strip()]
    payload = json.loads(input_path.read_text(encoding="utf-8"))
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        return payload.get("records", [])
    return []


def fetch_text(url: str, *, max_bytes: int, timeout: int = 45) -> str | None:
    try:
        with requests.get(url, timeout=timeout, stream=True, headers={"User-Agent": "llm-wiki-lit/0.1"}) as response:
            content_type = response.headers.get("content-type", "").lower()
            if response.status_code >= 400:
                return None
            if not any(marker in content_type for marker in ("text/", "html", "json", "xml")):
                return None
            chunks: list[bytes] = []
            captured = 0
            for chunk in response.iter_content(chunk_size=65536):
                if not chunk:
                    continue
                chunks.append(chunk)
                captured += len(chunk)
                if captured >= max_bytes:
                    break
            return b"".join(chunks).decode("utf-8", errors="replace")
    except requests.RequestException:
        return None


def inspect_records(
    records: list[dict[str, Any]],
    *,
    inspect_landing_pages: bool,
    max_pages: int,
    max_bytes: int,
    verbose: bool,
) -> list[dict[str, Any]]:
    enriched: list[dict[str, Any]] = []
    for record in records:
        text_parts = [
            record.get("paper_title"),
            record.get("paper_abstract"),
            " ".join(str(url) for url in record.get("landing_urls", [])),
        ]
        links = extract_dataset_links_from_text(" ".join(str(part or "") for part in text_parts))
        inspected_pages: list[str] = []
        if inspect_landing_pages:
            for url in (record.get("landing_urls") or [])[:max_pages]:
                if verbose:
                    print(f"Inspecting {url}", file=sys.stderr)
                page_text = fetch_text(str(url), max_bytes=max_bytes)
                inspected_pages.append(str(url))
                links.extend(extract_dataset_links_from_text(page_text))

        seen = set()
        deduped_links = []
        for link in links:
            key = link["url"].lower()
            if key in seen:
                continue
            seen.add(key)
            deduped_links.append(link)

        enriched.append(
            {
                **record,
                "dataset_links": deduped_links,
                "dataset_link_count": len(deduped_links),
                "inspected_landing_pages": inspected_pages,
            }
        )
    enriched.sort(key=lambda item: (item.get("dataset_link_count", 0), item.get("literature_score", 0)), reverse=True)
    return enriched


def main() -> None:
    parser = argparse.ArgumentParser(description="Extract dataset links from literature candidate records.")
    parser.add_argument("--input", required=True, help="JSON/JSONL paper candidate records.")
    parser.add_argument("--inspect-landing-pages", action="store_true")
    parser.add_argument("--max-pages", type=int, default=2, help="Landing pages to inspect per paper.")
    parser.add_argument("--max-bytes", type=int, default=500000, help="Maximum bytes captured per landing page.")
    parser.add_argument("--only-with-links", action="store_true")
    parser.add_argument("--write", default=str(DEFAULT_OUTPUT))
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    records = load_records(args.input)
    enriched = inspect_records(
        records,
        inspect_landing_pages=args.inspect_landing_pages,
        max_pages=args.max_pages,
        max_bytes=args.max_bytes,
        verbose=not args.quiet,
    )
    if args.only_with_links:
        enriched = [record for record in enriched if record.get("dataset_links")]

    payload = {
        "mode": "paper_dataset_link_extraction",
        "input": args.input,
        "paper_count": len(records),
        "records_with_links": sum(1 for record in enriched if record.get("dataset_links")),
        "records": enriched,
    }
    save_plan_payload(payload, args.write)
    print(json.dumps(payload, indent=2 if args.pretty else None, ensure_ascii=True))


if __name__ == "__main__":
    main()
