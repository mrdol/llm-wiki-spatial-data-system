"""Discover spatial and spatio-temporal dataset candidates from Figshare."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import Any

import requests

try:
    SCRIPT_DIR = Path(__file__).resolve().parent
except NameError:
    cwd = Path.cwd().resolve()
    candidates = (
        cwd / "pipeline_portals" / "python",
        cwd / "python",
        cwd.parent / "python",
        cwd,
    )
    SCRIPT_DIR = next((path for path in candidates if (path / "portal_common.py").exists()), cwd)
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from portal_common import (
    DEFAULT_CANDIDATE_DIR,
    DEFAULT_DATACANDIDATE_DOWNLOAD_DIR,
    candidate_modeling_metadata,
    download_candidate_files,
    emit_discovery_payload,
    extract_dois_from_text,
    file_extension,
    first_found_paper_metadata,
    has_spatiotemporal_signal,
    is_spatial_format,
    selected_download_urls,
    utc_now,
)


FIGSHARE_BASE_URL = "https://api.figshare.com/v2"
DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "figshare.records.jsonl"
DEFAULT_QUERY = "spatiotemporal spatial geospatial longitudinal panel data"


def figshare_request(
    session: requests.Session,
    method: str,
    endpoint: str,
    *,
    params: dict[str, Any] | None = None,
    json_body: dict[str, Any] | None = None,
) -> Any:
    try:
        response = session.request(
            method,
            f"{FIGSHARE_BASE_URL}{endpoint}",
            params=params,
            json=json_body,
            timeout=60,
        )
    except requests.RequestException:
        return None
    if response.status_code not in {200, 201}:
        return None
    return response.json()


def fetch_figshare_records(query: str, *, max_pages: int, page_size: int, verbose: bool) -> list[dict[str, Any]]:
    session = requests.Session()
    records: list[dict[str, Any]] = []
    for page in range(1, max_pages + 1):
        if verbose:
            print(f"Fetching Figshare page {page}", file=sys.stderr)
        hits = figshare_request(
            session,
            "POST",
            "/articles/search",
            json_body={
                "search_for": query,
                "item_type": 3,
                "page": page,
                "page_size": page_size,
            },
        )
        if not hits:
            break
        for hit in hits:
            if not isinstance(hit, dict) or not hit.get("id"):
                continue
            detail = figshare_request(session, "GET", f"/articles/{hit['id']}") or hit
            records.append(detail if isinstance(detail, dict) else hit)
    return records


def extract_files(record: dict[str, Any]) -> list[dict[str, Any]]:
    files: list[dict[str, Any]] = []
    for item in record.get("files") or []:
        if not isinstance(item, dict):
            continue
        filename = item.get("name")
        url = item.get("download_url")
        size = item.get("size")
        files.append(
            {
                "filename": filename,
                "size_bytes": int(size) if isinstance(size, (int, float)) else None,
                "url_dl": url,
                "format": file_extension(filename or url),
                "is_spatial": is_spatial_format(filename or url),
            }
        )
    return files


def parse_figshare_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    title = record.get("title")
    description = record.get("description")
    tags = record.get("tags") or record.get("categories")
    files = extract_files(record)
    if not (has_spatiotemporal_signal(title, description, tags, files) or any(item.get("is_spatial") for item in files)):
        return None

    doi_dataset = record.get("doi")
    publication_sources = []
    if record.get("resource_doi"):
        publication_sources.append(str(record["resource_doi"]))
    for item in record.get("related_materials") or []:
        if not isinstance(item, dict):
            continue
        if str(item.get("relation") or "").lower() == "references":
            continue
        publication_sources.extend(str(item.get(key) or "") for key in ("identifier", "link", "title"))
    publication_dois = extract_dois_from_text(" ".join(publication_sources))[:10]
    paper_metadata = first_found_paper_metadata(publication_dois, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)

    total_size = sum(item.get("size_bytes") or 0 for item in files)
    year_value = record.get("published_date") or record.get("created_date") or record.get("modified_date")
    year = int(str(year_value)[:4]) if str(year_value)[:4].isdigit() else None
    return {
        "record_type": "dataset_candidate",
        "source": "figshare",
        "scraped_at": utc_now(),
        "record_id": str(record.get("id")),
        "doi_dataset": doi_dataset,
        "title": title,
        "description": description,
        "year": year,
        "license": (record.get("license") or {}).get("name") if isinstance(record.get("license"), dict) else record.get("license"),
        "is_spatiotemporal": True,
        "doi_publication": publication_dois,
        "n_files": len(files),
        "spatial_formats": sorted({item["format"] for item in files if item.get("is_spatial") and item.get("format")}),
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": round(total_size / 1_000_000, 2) if total_size else None,
        "landing_url": record.get("url") or record.get("figshare_url"),
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_figshare_spatial(
    *,
    query: str,
    max_pages: int,
    page_size: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    raw_records = fetch_figshare_records(query, max_pages=max_pages, page_size=page_size, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_figshare_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape Figshare spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=3)
    parser.add_argument("--page-size", type=int, default=25)
    parser.add_argument("--enrich-paper", action="store_true")
    parser.add_argument("--mailto")
    parser.add_argument("--max-file-size-mb", type=float, default=100.0)
    parser.add_argument("--limit", type=int)
    parser.add_argument("--write", nargs="?", const=str(DEFAULT_OUTPUT))
    parser.add_argument("--csv")
    parser.add_argument("--download", action="store_true", help="Download candidate files after discovery.")
    parser.add_argument("--download-dir", default=str(DEFAULT_DATACANDIDATE_DOWNLOAD_DIR))
    parser.add_argument("--heavy-threshold-mb", type=float, default=100.0)
    parser.add_argument("--yes-heavy", action="store_true", help="Download heavy files without interactive confirmation.")
    parser.add_argument("--view", choices=("full", "summary", "markdown"), default="full")
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    records, raw_count = scrape_figshare_spatial(
        query=args.query,
        max_pages=args.max_pages,
        page_size=args.page_size,
        enrich_paper=args.enrich_paper,
        mailto=args.mailto,
        max_file_size_mb=args.max_file_size_mb,
        verbose=not args.quiet,
    )
    if args.limit is not None:
        records = records[: args.limit]
    download_summary = None
    if args.download:
        download_summary = download_candidate_files(
            records,
            output_dir=args.download_dir,
            heavy_threshold_mb=args.heavy_threshold_mb,
            yes_heavy=args.yes_heavy,
        )
    emit_discovery_payload(
        source="figshare",
        query=args.query,
        records=records,
        raw_record_count=raw_count,
        write=args.write,
        csv_path=args.csv,
        view=args.view,
        pretty=args.pretty,
        download_summary=download_summary,
    )


if __name__ == "__main__":
    main()
