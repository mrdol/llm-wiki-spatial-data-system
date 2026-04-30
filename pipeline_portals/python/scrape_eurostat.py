"""Discover Eurostat spatial and spatio-temporal dataset candidates."""

from __future__ import annotations

import argparse
import json
import re
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
    extract_html_links,
    file_extension,
    first_found_paper_metadata,
    has_spatiotemporal_signal,
    html_text,
    html_title,
    is_spatial_format,
    plan_to_payload,
    save_plan_payload,
    selected_download_urls,
    utc_now,
)


DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "eurostat.records.jsonl"
DEFAULT_QUERY = "unemployment employment labour force region nuts time"
PREFERRED_LAYER_TYPES = ("portal", "metadata_page", "api", "bulk_download")
FILE_EXTENSIONS = {"tsv", "csv", "zip", "sdmx", "json", "xml", "xlsx", "pdf"}


def fetch_text(session: requests.Session, url: str) -> str | None:
    """Recupere une page Eurostat ou un endpoint API avec requests."""

    try:
        response = session.get(url, timeout=60, headers={"User-Agent": "llm-wiki-scraper/0.1"})
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.text


def seed_urls() -> list[str]:
    """Construit les URLs Eurostat de depart a partir du catalogue local."""

    plan = build_portal_plan(
        warehouse_id="eurostat",
        preferred_layer_types=PREFERRED_LAYER_TYPES,
        include_nonpreferred=True,
    )
    return list(dict.fromkeys(seed.url for seed in plan.seeds if seed.url))


def fetch_eurostat_records(query: str, *, max_pages: int, verbose: bool) -> list[dict[str, Any]]:
    """Parcourt les endpoints API et pages Eurostat pour trouver des candidats datasets."""

    session = requests.Session()
    records: list[dict[str, Any]] = []
    query_terms = [term.lower() for term in re.findall(r"[a-z0-9_]+", query.lower())]
    for url in seed_urls()[:max_pages]:
        if verbose:
            print(f"Fetching Eurostat seed {url}", file=sys.stderr)
        if "/api/dissemination/statistics/" in url:
            payload_text = fetch_text(session, url)
            if not payload_text:
                continue
            try:
                payload = json.loads(payload_text)
            except json.JSONDecodeError:
                payload = {}
            dimensions = payload.get("dimension") if isinstance(payload, dict) else {}
            description = json.dumps(dimensions, ensure_ascii=True)[:5000]
            records.append(
                {
                    "record_kind": "api_dataset",
                    "landing_url": url,
                    "title": payload.get("label") or Path(url.split("?", 1)[0]).name,
                    "description": description,
                    "files": [
                        {
                            "filename": f"{Path(url.split('?', 1)[0]).name or 'eurostat'}.json",
                            "size_bytes": None,
                            "url_dl": url,
                            "format": "json",
                            "is_spatial": True,
                        }
                    ],
                }
            )
            continue

        html = fetch_text(session, url)
        if html is None:
            continue
        page_text = html_text(html)
        links = extract_html_links(html, url)
        file_links = [
            link
            for link in links
            if file_extension(link["url"]) in FILE_EXTENSIONS
            or file_extension(link["label"]) in FILE_EXTENSIONS
            or "api/dissemination/statistics" in link["url"]
        ]
        if query_terms and not any(term in page_text.lower() for term in query_terms) and not file_links:
            continue
        records.append(
            {
                "record_kind": "html_page",
                "landing_url": url,
                "title": html_title(html) or "Eurostat page",
                "description": page_text[:5000],
                "file_links": file_links,
            }
        )
    return records


def extract_files(record: dict[str, Any]) -> list[dict[str, Any]]:
    """Convertit les endpoints ou liens Eurostat en objets fichiers normalises."""

    if isinstance(record.get("files"), list):
        return [item for item in record["files"] if isinstance(item, dict)]
    files: list[dict[str, Any]] = []
    for link in record.get("file_links") or []:
        url = link.get("url")
        url_name = Path(str(url or "").split("?", 1)[0]).name
        label = link.get("label")
        ext = file_extension(url) or file_extension(label) or ("json" if "api/dissemination/statistics" in str(url) else "")
        filename = url_name if file_extension(url_name) else label or url_name
        files.append(
            {
                "filename": filename,
                "size_bytes": None,
                "url_dl": url,
                "format": ext,
                "is_spatial": is_spatial_format(filename or url) or "nuts" in str(record.get("description", "")).lower(),
            }
        )
    return files


def parse_eurostat_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    """Filtre et normalise une ressource Eurostat en candidat dataset."""

    title = record.get("title")
    description = record.get("description")
    files = extract_files(record)
    if not (files or has_spatiotemporal_signal(title, description)):
        return None
    doi_publication = extract_dois_from_text(description)[:10]
    paper_metadata = first_found_paper_metadata(doi_publication, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)
    url = str(record.get("landing_url") or "")
    record_id = Path(url.split("?", 1)[0]).name or "eurostat"
    return {
        "record_type": "dataset_candidate",
        "source": "eurostat",
        "scraped_at": utc_now(),
        "record_id": record_id,
        "doi_dataset": None,
        "title": title,
        "description": description,
        "year": None,
        "license": "Eurostat dissemination terms",
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


def scrape_eurostat_spatial(
    *,
    query: str,
    max_pages: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    """Execute le flux Eurostat complet: API/HTML, fichiers, DOI et scoring."""

    raw_records = fetch_eurostat_records(query, max_pages=max_pages, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_eurostat_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    """Point d'entree CLI pour Eurostat: plan, scraping, export et telechargement."""

    parser = argparse.ArgumentParser(description="Scrape Eurostat spatial/spatio-temporal dataset metadata.")
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
            warehouse_id="eurostat",
            preferred_layer_types=PREFERRED_LAYER_TYPES,
            dataset_id_filter=args.dataset_id,
            include_nonpreferred=args.include_nonpreferred,
        )
        payload = plan_to_payload(plan, limit=args.limit)
        payload["warehouse_specific_notes"] = [
            "Comext and standard Eurostat dissemination endpoints should be tracked separately.",
            "Keep API seeds distinct from ESMS or SIMS metadata pages in parsing logic.",
        ]
        if args.enrich_paper:
            add_paper_enrichment_to_plan_payload(payload, mailto=args.mailto)
        if args.write_plan:
            save_plan_payload(payload, default_plan_path("eurostat"))
        print(json.dumps(payload, indent=2 if args.pretty else None, ensure_ascii=True))
        return

    records, raw_count = scrape_eurostat_spatial(
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
        source="eurostat",
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
