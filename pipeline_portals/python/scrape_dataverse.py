"""Discover spatial and spatio-temporal dataset candidates from Dataverse."""

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


DEFAULT_BASE_URL = "https://dataverse.harvard.edu"
DEFAULT_OUTPUT = DEFAULT_CANDIDATE_DIR / "dataverse.records.jsonl"
DEFAULT_QUERY = "spatiotemporal OR spatial OR geospatial OR longitudinal OR panel data"


def dataverse_get(base_url: str, endpoint: str, params: dict[str, Any]) -> dict[str, Any] | None:
    """Interroge une API Dataverse et retourne la reponse JSON."""

    try:
        response = requests.get(f"{base_url.rstrip('/')}{endpoint}", params=params, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.json()


def fetch_dataverse_records(
    base_url: str,
    query: str,
    *,
    max_pages: int,
    per_page: int,
    verbose: bool,
) -> list[dict[str, Any]]:
    """Recherche des datasets Dataverse via l'API de recherche."""

    records: list[dict[str, Any]] = []
    for page in range(max_pages):
        start = page * per_page
        if verbose:
            print(f"Fetching Dataverse page {page + 1}", file=sys.stderr)
        payload = dataverse_get(
            base_url,
            "/api/search",
            {"q": query, "type": "dataset", "start": start, "per_page": per_page},
        )
        data = payload.get("data") if isinstance(payload, dict) else None
        items = data.get("items") if isinstance(data, dict) else []
        if not items:
            break
        records.extend(item for item in items if isinstance(item, dict))
    return records


def fetch_dataset_detail(base_url: str, persistent_id: str | None) -> dict[str, Any] | None:
    """Recupere les metadonnees detaillees d'un dataset Dataverse par DOI/persistent ID."""

    if not persistent_id:
        return None
    payload = dataverse_get(
        base_url,
        "/api/datasets/:persistentId",
        {"persistentId": persistent_id},
    )
    data = payload.get("data") if isinstance(payload, dict) else None
    return data if isinstance(data, dict) else None


def metadata_field(version: dict[str, Any], name: str) -> Any:
    """Lit un champ de metadonnees Dataverse dans les blocs de la version courante."""

    for block in version.get("metadataBlocks", {}).values():
        for field in block.get("fields", []):
            if field.get("typeName") == name:
                return field.get("value")
    return None


def extract_files(base_url: str, detail: dict[str, Any] | None) -> list[dict[str, Any]]:
    """Extrait les fichiers Dataverse et construit leurs URLs d'acces API."""

    version = (detail or {}).get("latestVersion") or {}
    files: list[dict[str, Any]] = []
    for item in version.get("files") or []:
        if not isinstance(item, dict):
            continue
        data_file = item.get("dataFile") if isinstance(item.get("dataFile"), dict) else {}
        file_id = data_file.get("id")
        filename = data_file.get("filename")
        content_type = data_file.get("contentType")
        size = data_file.get("filesize")
        url = f"{base_url.rstrip('/')}/api/access/datafile/{file_id}" if file_id else None
        ext = file_extension(filename)
        files.append(
            {
                "filename": filename,
                "size_bytes": int(size) if isinstance(size, (int, float)) else None,
                "url_dl": url,
                "format": ext or content_type,
                "is_spatial": is_spatial_format(filename) or "netcdf" in str(content_type).lower(),
            }
        )
    return files


def parse_dataverse_record(
    base_url: str,
    record: dict[str, Any],
    *,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
) -> dict[str, Any] | None:
    """Filtre et normalise un dataset Dataverse en candidat exploitable."""

    persistent_id = record.get("global_id") or record.get("persistent_id")
    detail = fetch_dataset_detail(base_url, persistent_id)
    version = (detail or {}).get("latestVersion") or {}
    title = record.get("name") or metadata_field(version, "title")
    description = record.get("description") or metadata_field(version, "dsDescription")
    keywords = record.get("subjects") or record.get("keywords") or metadata_field(version, "keyword")
    files = extract_files(base_url, detail)
    portal_context = {
        "publisher": record.get("publisher"),
        "dataverse": record.get("name_of_dataverse"),
        "citation": record.get("citation"),
    }
    if not (
        has_spatiotemporal_signal(title, description, keywords, files, portal_context)
        or any(item.get("is_spatial") for item in files)
    ):
        return None

    publication_refs = metadata_field(version, "publication") or metadata_field(version, "relatedDatasets")
    publication_dois = extract_dois_from_text(str(publication_refs or ""))
    paper_metadata = first_found_paper_metadata(publication_dois, enrich_paper=enrich_paper, mailto=mailto)
    modeling_metadata = candidate_modeling_metadata(title=title, description=description, paper_metadata=paper_metadata)

    total_size = sum(item.get("size_bytes") or 0 for item in files)
    year_value = record.get("published_at") or record.get("releaseOrCreateDate") or version.get("releaseTime")
    year = int(str(year_value)[:4]) if str(year_value)[:4].isdigit() else None
    return {
        "record_type": "dataset_candidate",
        "source": "dataverse",
        "scraped_at": utc_now(),
        "record_id": str(record.get("id") or persistent_id),
        "doi_dataset": persistent_id,
        "title": title,
        "description": description,
        "year": year,
        "license": version.get("license") or version.get("termsOfUse"),
        "is_spatiotemporal": True,
        "doi_publication": publication_dois,
        "n_files": len(files),
        "spatial_formats": sorted({item["format"] for item in files if item.get("is_spatial") and item.get("format")}),
        "url_dl": selected_download_urls(files, max_size_mb=max_file_size_mb),
        "total_size_mb": round(total_size / 1_000_000, 2) if total_size else None,
        "landing_url": record.get("url") or (f"{base_url.rstrip()}/dataset.xhtml?persistentId={persistent_id}" if persistent_id else None),
        "files": files,
        **paper_metadata,
        **modeling_metadata,
    }


def scrape_dataverse_spatial(
    *,
    base_url: str,
    query: str,
    max_pages: int,
    per_page: int,
    enrich_paper: bool,
    mailto: str | None,
    max_file_size_mb: float | None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    """Execute le flux Dataverse complet: recherche API, detail, fichiers et scoring."""

    raw_records = fetch_dataverse_records(base_url, query, max_pages=max_pages, per_page=per_page, verbose=verbose)
    parsed = [
        result
        for record in raw_records
        if (
            result := parse_dataverse_record(
                base_url,
                record,
                enrich_paper=enrich_paper,
                mailto=mailto,
                max_file_size_mb=max_file_size_mb,
            )
        )
    ]
    return parsed, len(raw_records)


def main() -> None:
    """Point d'entree CLI pour Dataverse: scraping, export et telechargement controle."""

    parser = argparse.ArgumentParser(description="Scrape Dataverse spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL)
    parser.add_argument("--query", default=DEFAULT_QUERY)
    parser.add_argument("--max-pages", type=int, default=2)
    parser.add_argument("--per-page", type=int, default=10)
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

    records, raw_count = scrape_dataverse_spatial(
        base_url=args.base_url,
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
        source="dataverse",
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
