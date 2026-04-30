"""Discover spatial and spatio-temporal dataset candidates from data.gouv.fr."""

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


DATA_GOUV_API = "https://www.data.gouv.fr/api/1"
DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "data_gouv.records.jsonl"
DEFAULT_QUERY = "spatial spatiotemporal geolocalise donnees territoriales panel"
PREFERRED_LAYER_TYPES = ("portal", "bulk_download", "api")


def data_gouv_get(session: requests.Session, endpoint: str, params: dict[str, Any]) -> dict[str, Any] | None:
    try:
        response = session.get(f"{DATA_GOUV_API}{endpoint}", params=params, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.json()


def fetch_data_gouv_records(query: str, *, max_pages: int, page_size: int, verbose: bool) -> list[dict[str, Any]]:
    session = requests.Session()
    records: list[dict[str, Any]] = []
    for page in range(1, max_pages + 1):
        if verbose:
            print(f"Fetching data.gouv.fr page {page}", file=sys.stderr)
        payload = data_gouv_get(
            session,
            "/datasets/",
            {"q": query, "page": page, "page_size": page_size},
        )
        if not payload:
            break
        data = payload.get("data") if isinstance(payload, dict) else None
        if not data:
            break
        records.extend(item for item in data if isinstance(item, dict))
    return records


def extract_files(record: dict[str, Any]) -> list[dict[str, Any]]:
    files: list[dict[str, Any]] = []
    for resource in record.get("resources") or []:
        if not isinstance(resource, dict):
            continue
        url = resource.get("url") or resource.get("latest") or resource.get("self_web_url")
        filename = resource.get("title") or resource.get("id") or Path(str(url or "")).name
        fmt = str(resource.get("format") or file_extension(filename or url)).lower()
        size = resource.get("filesize") or resource.get("filetype_size")
        files.append(
            {
                "filename": filename,
                "size_bytes": int(size) if isinstance(size, (int, float)) else None,
                "url_dl": url,
                "format": fmt,
                "is_spatial": is_spatial_format(filename or url) or fmt in {"shp", "geojson", "geopackage", "gpkg"},
                "resource_id": resource.get("id"),
                "resource_title": resource.get("title"),
                "resource_type": resource.get("type"),
            }
        )
    return files


def parse_data_gouv_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    title = record.get("title")
    description = record.get("description")
    tags = record.get("tags") or []
    files = extract_files(record)
    spatial = record.get("spatial") if isinstance(record.get("spatial"), dict) else {}
    temporal = record.get("temporal_coverage") or record.get("temporal")
    text_parts = [title, description, tags, spatial, temporal, files]
    if not (has_spatiotemporal_signal(*text_parts) or spatial or any(item.get("is_spatial") for item in files)):
        return None

    doi_publication = extract_dois_from_text(" ".join(str(item or "") for item in (description, record.get("extras"))))[:10]
    paper_metadata = first_found_paper_metadata(doi_publication, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)
    license_info = record.get("license") if isinstance(record.get("license"), dict) else {}
    total_size = sum(item.get("size_bytes") or 0 for item in files)
    organization = record.get("organization") if isinstance(record.get("organization"), dict) else {}

    return {
        "record_type": "dataset_candidate",
        "source": "data_gouv",
        "scraped_at": utc_now(),
        "record_id": record.get("id") or record.get("slug"),
        "doi_dataset": None,
        "title": title,
        "description": description,
        "year": int(str(record.get("created_at", ""))[:4]) if str(record.get("created_at", ""))[:4].isdigit() else None,
        "license": license_info.get("title") or license_info.get("id"),
        "organization": organization.get("name"),
        "is_spatiotemporal": True,
        "doi_publication": doi_publication,
        "n_files": len(files),
        "spatial_formats": sorted({item["format"] for item in files if item.get("is_spatial") and item.get("format")}),
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": round(total_size / 1_000_000, 2) if total_size else None,
        "landing_url": record.get("page") or record.get("self_web_url") or f"https://www.data.gouv.fr/datasets/{record.get('slug')}/",
        "spatial": spatial,
        "temporal": temporal,
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_data_gouv_spatial(
    *,
    query: str,
    max_pages: int,
    page_size: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    raw_records = fetch_data_gouv_records(query, max_pages=max_pages, page_size=page_size, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_data_gouv_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape data.gouv.fr spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--plan", action="store_true", help="Only build the legacy portal scraping plan.")
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--page-size", type=int, default=20)
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
            warehouse_id="data_gouv",
            preferred_layer_types=PREFERRED_LAYER_TYPES,
            dataset_id_filter=args.dataset_id,
            include_nonpreferred=args.include_nonpreferred,
        )
        payload = plan_to_payload(plan, limit=args.limit)
        payload["warehouse_specific_notes"] = [
                "Dataset-level licenses may vary by producer, so parser hooks should capture resource and dataset licenses separately.",
                "Track both dataset cards and resource URLs because data.gouv exposes multiple resource files per dataset.",
        ]
        if args.enrich_paper:
            add_paper_enrichment_to_plan_payload(payload, mailto=args.mailto)
        if args.write_plan:
            save_plan_payload(payload, default_plan_path("data_gouv"))
        print(json.dumps(payload, indent=2 if args.pretty else None, ensure_ascii=True))
        return

    records, raw_count = scrape_data_gouv_spatial(
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
        source="data_gouv",
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
