"""Discover spatial and spatio-temporal dataset candidates from Dryad."""

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


DRYAD_BASE_URL = "https://datadryad.org/api/v2"
DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "dryad.records.jsonl"
DEFAULT_QUERY = "spatiotemporal OR spatial OR geospatial OR longitudinal OR panel data"


def _as_list(value: Any) -> list[Any]:
    """Garantit qu'une valeur Dryad est manipulee comme une liste."""

    if value is None:
        return []
    if isinstance(value, list):
        return value
    return [value]


def dryad_get(session: requests.Session, endpoint: str, params: dict[str, Any]) -> dict[str, Any] | None:
    """Interroge l'API JSON Dryad avec requests."""

    try:
        response = session.get(f"{DRYAD_BASE_URL}{endpoint}", params=params, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.json()


def fetch_dryad_records(query: str, *, max_pages: int, per_page: int, verbose: bool) -> list[dict[str, Any]]:
    """Recherche des datasets Dryad page par page via l'API."""

    session = requests.Session()
    records: list[dict[str, Any]] = []
    for page in range(1, max_pages + 1):
        if verbose:
            print(f"Fetching Dryad page {page}", file=sys.stderr)
        payload = dryad_get(session, "/search", {"q": query, "page": page, "per_page": per_page})
        if not payload:
            break
        embedded = payload.get("_embedded") if isinstance(payload.get("_embedded"), dict) else {}
        hits = (
            embedded.get("stash:datasets")
            or embedded.get("datasets")
            or payload.get("items")
            or payload.get("results")
            or []
        )
        if not hits:
            break
        records.extend(hit for hit in hits if isinstance(hit, dict))
    return records


def extract_files(record: dict[str, Any]) -> list[dict[str, Any]]:
    """Extrait les fichiers ou l'archive globale declares dans une fiche Dryad."""

    files: list[dict[str, Any]] = []
    for item in _as_list(record.get("files") or record.get("file_links") or record.get("_embedded", {}).get("stash:files")):
        if not isinstance(item, dict):
            continue
        filename = item.get("path") or item.get("filename") or item.get("name")
        url = item.get("download_url") or item.get("url")
        links = item.get("_links") if isinstance(item.get("_links"), dict) else {}
        if not url and isinstance(links.get("stash:download"), dict):
            url = links["stash:download"].get("href")
        size = item.get("size") or item.get("size_bytes")
        files.append(
            {
                "filename": filename,
                "size_bytes": int(size) if isinstance(size, (int, float, str)) and str(size).isdigit() else None,
                "url_dl": url,
                "format": file_extension(filename or url),
                "is_spatial": is_spatial_format(filename or url),
            }
        )
    if not files:
        links = record.get("_links") if isinstance(record.get("_links"), dict) else {}
        download = links.get("stash:download") if isinstance(links.get("stash:download"), dict) else {}
        url = download.get("href")
        if url:
            if url.startswith("/"):
                url = f"https://datadryad.org{url}"
            size = record.get("storageSize")
            files.append(
                {
                    "filename": "dryad_dataset_download.zip",
                    "size_bytes": int(size) if isinstance(size, (int, float)) else None,
                    "url_dl": url,
                    "format": "zip",
                    "is_spatial": False,
                }
            )
    return files


def parse_dryad_record(
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    """Filtre et normalise une fiche Dryad en candidat dataset."""

    title = record.get("title") or record.get("name")
    description = record.get("abstract") or record.get("description")
    keywords = record.get("keywords") or record.get("subjects")
    files = extract_files(record)
    text_parts = [title, description, keywords, record.get("abstract"), record.get("subjects"), files]
    if not (has_spatiotemporal_signal(*text_parts) or any(item.get("is_spatial") for item in files)):
        return None

    doi_dataset = record.get("identifier") or record.get("doi") or record.get("global_id")
    publication_dois = extract_dois_from_text(" ".join(str(item) for item in _as_list(record.get("relatedPublicationDOI"))))
    if not publication_dois:
        publication_dois = extract_dois_from_text(str(record.get("related_identifiers") or record.get("relatedPublication") or ""))
    paper_metadata = first_found_paper_metadata(publication_dois, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)

    total_size = sum(item.get("size_bytes") or 0 for item in files)
    year_value = record.get("publicationDate") or record.get("publication_date") or record.get("created")
    year = int(str(year_value)[:4]) if str(year_value)[:4].isdigit() else None
    record_id = str(record.get("id") or doi_dataset or title)
    return {
        "record_type": "dataset_candidate",
        "source": "dryad",
        "scraped_at": utc_now(),
        "record_id": record_id,
        "doi_dataset": doi_dataset,
        "title": title,
        "description": description,
        "year": year,
        "license": record.get("license") or record.get("licenseLabel"),
        "is_spatiotemporal": True,
        "doi_publication": publication_dois,
        "n_files": len(files),
        "spatial_formats": sorted({item["format"] for item in files if item.get("is_spatial") and item.get("format")}),
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": round(total_size / 1_000_000, 2) if total_size else None,
        "landing_url": record.get("url") or (f"https://datadryad.org/stash/dataset/{doi_dataset}" if doi_dataset else None),
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_dryad_spatial(
    *,
    query: str,
    max_pages: int,
    per_page: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    """Execute le flux Dryad complet: API, fichiers, DOI et scoring."""

    raw_records = fetch_dryad_records(query, max_pages=max_pages, per_page=per_page, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_dryad_record(
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    """Point d'entree CLI pour Dryad: scraping, export et telechargement."""

    parser = argparse.ArgumentParser(description="Scrape Dryad spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=3)
    parser.add_argument("--per-page", type=int, default=25)
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

    records, raw_count = scrape_dryad_spatial(
        query=args.query,
        max_pages=args.max_pages,
        per_page=args.per_page,
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
        source="dryad",
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
