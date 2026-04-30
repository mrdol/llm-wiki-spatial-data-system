"""Discover World Bank spatial and spatio-temporal dataset candidates."""

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
    first_found_paper_metadata,
    has_spatiotemporal_signal,
    plan_to_payload,
    save_plan_payload,
    selected_download_urls,
    utc_now,
)


WORLD_BANK_API = "https://api.worldbank.org/v2"
DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "world_bank.records.jsonl"
DEFAULT_QUERY = "unemployment employment population region spatial time series"
PREFERRED_LAYER_TYPES = ("catalog", "bulk_download", "api", "sdmx_api_documentation")


def world_bank_get(session: requests.Session, endpoint: str, params: dict[str, Any]) -> Any:
    """Interroge l'API JSON World Bank avec requests."""

    try:
        response = session.get(f"{WORLD_BANK_API}{endpoint}", params=params, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.json()


def fetch_world_bank_records(query: str, *, page_size: int, verbose: bool) -> list[dict[str, Any]]:
    """Charge le catalogue d'indicateurs World Bank et filtre par mots de requete."""

    session = requests.Session()
    query_terms = [term.lower() for term in re.findall(r"[a-z0-9_]+", query.lower())]
    payload = world_bank_get(
        session,
        "/indicator",
        {"format": "json", "per_page": page_size, "source": 2},
    )
    items = payload[1] if isinstance(payload, list) and len(payload) > 1 and isinstance(payload[1], list) else []
    records: list[dict[str, Any]] = []
    for item in items:
        if not isinstance(item, dict):
            continue
        text = " ".join(str(item.get(key) or "") for key in ("id", "name", "sourceNote", "sourceOrganization")).lower()
        if query_terms and not any(term in text for term in query_terms):
            continue
        if verbose:
            print(f"Found World Bank indicator {item.get('id')}", file=sys.stderr)
        records.append(item)
    return records


def parse_world_bank_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    """Normalise un indicateur World Bank en candidat country x time."""

    indicator_id = record.get("id")
    title = record.get("name")
    description = record.get("sourceNote") or record.get("sourceOrganization")
    if not indicator_id:
        return None
    if not has_spatiotemporal_signal(title, description, "geographic country time series annual panel"):
        return None
    doi_publication = extract_dois_from_text(description)[:10]
    paper_metadata = first_found_paper_metadata(doi_publication, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)
    url = f"{WORLD_BANK_API}/country/all/indicator/{indicator_id}?format=json&per_page=20000"
    files = [
        {
            "filename": f"{indicator_id}.json",
            "size_bytes": None,
            "url_dl": url,
            "format": "json",
            "is_spatial": True,
        }
    ]
    source = record.get("source") if isinstance(record.get("source"), dict) else {}
    topics = record.get("topics") if isinstance(record.get("topics"), list) else []
    return {
        "record_type": "dataset_candidate",
        "source": "world_bank",
        "scraped_at": utc_now(),
        "record_id": indicator_id,
        "doi_dataset": None,
        "title": title,
        "description": description,
        "year": None,
        "license": "World Bank Open Data terms",
        "organization": source.get("value"),
        "is_spatiotemporal": True,
        "doi_publication": doi_publication,
        "n_files": len(files),
        "spatial_formats": ["json"],
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": None,
        "landing_url": f"https://data.worldbank.org/indicator/{indicator_id}",
        "topics": [topic.get("value") for topic in topics if isinstance(topic, dict)],
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_world_bank_spatial(
    *,
    query: str,
    page_size: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    """Execute le flux World Bank complet: catalogue API, filtre et candidats."""

    raw_records = fetch_world_bank_records(query, page_size=page_size, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_world_bank_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    """Point d'entree CLI pour World Bank: plan, scraping, export et telechargement."""

    parser = argparse.ArgumentParser(description="Scrape World Bank spatial/spatio-temporal indicator metadata.")
    parser.add_argument("--plan", action="store_true", help="Only build the legacy portal scraping plan.")
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--page-size", type=int, default=20000)
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
            warehouse_id="world_bank",
            preferred_layer_types=PREFERRED_LAYER_TYPES,
            dataset_id_filter=args.dataset_id,
            include_nonpreferred=args.include_nonpreferred,
        )
        payload = plan_to_payload(plan, limit=args.limit)
        payload["warehouse_specific_notes"] = [
            "World Bank API indicator metadata is useful for candidate discovery before full data download.",
            "Dataset-level and indicator-family metadata should remain separate in later analysis.",
        ]
        if args.enrich_paper:
            add_paper_enrichment_to_plan_payload(payload, mailto=args.mailto)
        if args.write_plan:
            save_plan_payload(payload, default_plan_path("world_bank"))
        print(json.dumps(payload, indent=2 if args.pretty else None, ensure_ascii=True))
        return

    records, raw_count = scrape_world_bank_spatial(
        query=args.query,
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
        source="world_bank",
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
