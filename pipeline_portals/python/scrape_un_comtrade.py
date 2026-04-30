"""Discover UN Comtrade spatial and spatio-temporal dataset candidates."""

from __future__ import annotations

import argparse
import json
import re
import sys
from html import unescape
from pathlib import Path
from typing import Any
from urllib.parse import urljoin

import requests

SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from portal_common import (
    DEFAULT_CANDIDATE_DIR,
    DEFAULT_DATACANDIDATE_DOWNLOAD_DIR,
    add_paper_enrichment_to_plan_payload,
    build_portal_plan,
    candidate_modeling_metadata,
    default_plan_path,
    download_candidate_files,
    emit_discovery_payload,
    extract_dois_from_text,
    file_extension,
    first_found_paper_metadata,
    has_spatiotemporal_signal,
    is_spatial_format,
    plan_to_payload,
    save_plan_payload,
    selected_download_urls,
    utc_now,
)


DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "un_comtrade.records.jsonl"
DEFAULT_QUERY = "trade commodity reporter partner year annual country panel"
PREFERRED_LAYER_TYPES = ("portal", "methodology_page", "record_layout", "api_catalogue", "api_portal_reference")
FILE_EXTENSIONS = {"csv", "xlsx", "xls", "zip", "json", "xml", "pdf", "txt"}
REFERENCE_URLS = (
    "https://comtradeapi.un.org/files/v1/app/reference/Reporters.json",
    "https://comtradeapi.un.org/files/v1/app/reference/Partners.json",
    "https://comtradeapi.un.org/files/v1/app/reference/CommodityClassifications.json",
)


def fetch_text(session: requests.Session, url: str) -> str | None:
    try:
        response = session.get(url, timeout=60, headers={"User-Agent": "llm-wiki-scraper/0.1"})
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.text


def html_title(html: str) -> str | None:
    match = re.search(r"<title[^>]*>(.*?)</title>", html, flags=re.I | re.S)
    if not match:
        return None
    return re.sub(r"\s+", " ", unescape(re.sub("<[^>]+>", " ", match.group(1)))).strip()


def html_text(html: str) -> str:
    cleaned = re.sub(r"<script[\s\S]*?</script>", " ", html, flags=re.I)
    cleaned = re.sub(r"<style[\s\S]*?</style>", " ", cleaned, flags=re.I)
    cleaned = re.sub(r"<[^>]+>", " ", cleaned)
    return re.sub(r"\s+", " ", unescape(cleaned)).strip()


def extract_links(html: str, base_url: str) -> list[dict[str, str]]:
    links: list[dict[str, str]] = []
    for match in re.finditer(r"<a\b[^>]*href=[\"']([^\"']+)[\"'][^>]*>(.*?)</a>", html, flags=re.I | re.S):
        href = unescape(match.group(1)).strip()
        label = re.sub(r"\s+", " ", unescape(re.sub("<[^>]+>", " ", match.group(2)))).strip()
        if href and not href.startswith(("mailto:", "javascript:")):
            links.append({"url": urljoin(base_url, href), "label": label})
    return links


def seed_urls() -> list[str]:
    plan = build_portal_plan(
        warehouse_id="un_comtrade",
        preferred_layer_types=PREFERRED_LAYER_TYPES,
        include_nonpreferred=True,
    )
    urls = [seed.url for seed in plan.seeds if seed.url]
    urls.extend(REFERENCE_URLS)
    return list(dict.fromkeys(urls))


def fetch_un_comtrade_records(query: str, *, max_pages: int, verbose: bool) -> list[dict[str, Any]]:
    session = requests.Session()
    records: list[dict[str, Any]] = []
    query_terms = [term.lower() for term in re.findall(r"[a-z0-9_]+", query.lower())]
    for url in seed_urls()[:max_pages]:
        if verbose:
            print(f"Fetching UN Comtrade seed {url}", file=sys.stderr)
        text = fetch_text(session, url)
        if text is None:
            continue
        if url.lower().endswith(".json"):
            description = text[:5000]
            records.append(
                {
                    "landing_url": url,
                    "title": Path(url).stem,
                    "description": description,
                    "files": [
                        {
                            "filename": Path(url).name,
                            "size_bytes": None,
                            "url_dl": url,
                            "format": "json",
                            "is_spatial": True,
                        }
                    ],
                }
            )
            continue
        page_text = html_text(text)
        links = extract_links(text, url)
        file_links = [
            link
            for link in links
            if file_extension(link["url"]) in FILE_EXTENSIONS
            or file_extension(link["label"]) in FILE_EXTENSIONS
            or "api" in link["url"].lower()
        ]
        if query_terms and not any(term in page_text.lower() for term in query_terms) and not file_links:
            continue
        records.append(
            {
                "landing_url": url,
                "title": html_title(text) or "UN Comtrade page",
                "description": page_text[:5000],
                "file_links": file_links,
            }
        )
    return records


def extract_files(record: dict[str, Any]) -> list[dict[str, Any]]:
    if isinstance(record.get("files"), list):
        return [item for item in record["files"] if isinstance(item, dict)]
    files: list[dict[str, Any]] = []
    for link in record.get("file_links") or []:
        url = link.get("url")
        url_name = Path(str(url or "").split("?", 1)[0]).name
        label = link.get("label")
        ext = file_extension(url) or file_extension(label)
        filename = url_name if file_extension(url_name) else label or url_name
        files.append(
            {
                "filename": filename,
                "size_bytes": None,
                "url_dl": url,
                "format": ext,
                "is_spatial": is_spatial_format(filename or url) or "country" in str(record.get("description", "")).lower(),
            }
        )
    return files


def parse_un_comtrade_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    title = record.get("title")
    description = record.get("description")
    files = extract_files(record)
    if not (files or has_spatiotemporal_signal(title, description, "country year trade panel")):
        return None
    doi_publication = extract_dois_from_text(description)[:10]
    paper_metadata = first_found_paper_metadata(doi_publication, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)
    url = str(record.get("landing_url") or "")
    return {
        "record_type": "dataset_candidate",
        "source": "un_comtrade",
        "scraped_at": utc_now(),
        "record_id": Path(url.split("?", 1)[0]).stem or "un_comtrade",
        "doi_dataset": None,
        "title": title,
        "description": description,
        "year": None,
        "license": "UN Comtrade dissemination terms",
        "is_spatiotemporal": True,
        "doi_publication": doi_publication,
        "n_files": len(files),
        "spatial_formats": sorted({item["format"] for item in files if item.get("is_spatial") and item.get("format")}),
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": None,
        "landing_url": record.get("landing_url"),
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_un_comtrade_spatial(
    *,
    query: str,
    max_pages: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    raw_records = fetch_un_comtrade_records(query, max_pages=max_pages, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_un_comtrade_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape UN Comtrade spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--plan", action="store_true", help="Only build the legacy portal scraping plan.")
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=8)
    parser.add_argument("--enrich-paper", action="store_true")
    parser.add_argument("--mailto")
    parser.add_argument("--max-file-size-mb", type=float, default=100.0)
    parser.add_argument("--limit", type=int)
    parser.add_argument("--write", nargs="?", const=str(DEFAULT_OUTPUT))
    parser.add_argument("--csv")
    parser.add_argument("--download", action="store_true")
    parser.add_argument("--download-dir", default=str(DEFAULT_DATACANDIDATE_DOWNLOAD_DIR))
    parser.add_argument("--heavy-threshold-mb", type=float, default=100.0)
    parser.add_argument("--yes-heavy", action="store_true")
    parser.add_argument("--view", choices=("full", "summary", "markdown"), default="full")
    parser.add_argument("--pretty", action="store_true")
    parser.add_argument("--quiet", action="store_true")
    parser.add_argument("--dataset-id", help="Restrict legacy plan mode to one dataset_id.")
    parser.add_argument("--include-nonpreferred", action="store_true", help="Keep all discovery layers in legacy plan mode.")
    parser.add_argument("--write-plan", action="store_true", help="Write the legacy plan to data/manifests/plans/.")
    args = parser.parse_args()

    if args.plan:
        plan = build_portal_plan(
            warehouse_id="un_comtrade",
            preferred_layer_types=PREFERRED_LAYER_TYPES,
            dataset_id_filter=args.dataset_id,
            include_nonpreferred=args.include_nonpreferred,
        )
        payload = plan_to_payload(plan, limit=args.limit)
        payload["warehouse_specific_notes"] = [
            "UN Comtrade methodology, record layout, and live API routes remain separate parser targets.",
            "Reference JSON files are useful lightweight candidates before large trade extracts.",
        ]
        if args.enrich_paper:
            add_paper_enrichment_to_plan_payload(payload, mailto=args.mailto)
        if args.write_plan:
            save_plan_payload(payload, default_plan_path("un_comtrade"))
        print(json.dumps(payload, indent=2 if args.pretty else None, ensure_ascii=True))
        return

    records, raw_count = scrape_un_comtrade_spatial(
        query=args.query,
        max_pages=args.max_pages,
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
        source="un_comtrade",
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
