"""Shared starter utilities for warehouse portal discovery scripts.

These scripts do not perform scraping by default. They build structured
discovery plans, seed URLs, and output locations so later phases can
implement collection with minimal redesign.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

REPO_ROOT = Path(__file__).resolve().parents[2]
CATALOG_PATH = REPO_ROOT / "catalogue_datasets.json"
DEFAULT_PLAN_DIR = REPO_ROOT / "data" / "manifests" / "plans"
DEFAULT_CANDIDATE_DIR = REPO_ROOT / "data" / "candidates"
DEFAULT_DATACANDIDATE_DOWNLOAD_DIR = REPO_ROOT / "data" / "downloads" / "datacandidates"

MODELING_SIGNAL_GROUPS = {
    "spatial_panel": (
        "spatial panel",
        "spatial econometric",
        "spatial lag",
        "spatial autoregressive",
        "sar model",
        "spatial durbin",
    ),
    "spatiotemporal_model": (
        "spatio-temporal model",
        "spatiotemporal model",
        "space-time model",
        "spatio-temporal dynamics",
        "spatiotemporal dynamics",
    ),
    "forecasting": (
        "forecast",
        "forecasting",
        "prediction",
        "predictive",
        "nowcasting",
    ),
    "regression": (
        "regression",
        "linear model",
        "generalized linear",
        "mixed effects",
        "fixed effects",
        "random effects",
    ),
    "machine_learning": (
        "machine learning",
        "random forest",
        "xgboost",
        "gradient boosting",
        "lightgbm",
        "support vector",
        "neural network",
        "deep learning",
        "graph neural",
        "classification",
        "segmentation",
    ),
    "causal_inference": (
        "causal",
        "treatment effect",
        "difference-in-differences",
        "instrumental variable",
        "propensity score",
    ),
    "bayesian": (
        "bayesian",
        "inla",
        "latent gaussian",
        "posterior",
    ),
    "simulation_modeling": (
        "simulation",
        "large eddy simulation",
        "numerical model",
        "model dataset",
        "simulated",
        "coupled model",
    ),
}

LOW_MODELING_VALUE_TERMS = (
    "map",
    "mapping",
    "inventory",
    "cartographic",
    "atlas",
    "land cover product",
    "remote sensing product",
)

DOI_PATTERN = re.compile(r"\b10\.\d{4,9}/[-._;()/:A-Z0-9]+\b", flags=re.IGNORECASE)

SPATIAL_TERMS = (
    "spatial",
    "geospatial",
    "spatio-temporal",
    "spatiotemporal",
    "space-time",
    "gis",
    "raster",
    "vector",
    "shapefile",
    "geotiff",
    "netcdf",
    "coordinates",
    "longitude",
    "latitude",
    "geographic",
    "geocoded",
    "crs",
    "epsg",
)

TEMPORAL_TERMS = (
    "spatio-temporal",
    "spatiotemporal",
    "space-time",
    "time series",
    "longitudinal",
    "panel data",
    "monthly",
    "annual",
    "daily",
    "yearly",
    "temporal",
    "time period",
)

SPATIAL_EXTENSIONS = {
    "shp",
    "gpkg",
    "geojson",
    "kml",
    "kmz",
    "tif",
    "tiff",
    "nc",
    "nc4",
    "hdf",
    "h5",
    "grib",
    "gdb",
    "sqlite",
    "spatialite",
    "parquet",
}


def _normalize(value: str | None) -> str:
    return (value or "").strip().lower().replace(".", "").replace("/", " ")


def _warehouse_aliases(warehouse_record: dict[str, Any], warehouse_id: str) -> set[str]:
    identity = warehouse_record.get("identity", {})
    metadata = warehouse_record.get("warehouse_metadata", {})
    aliases = {
        _normalize(warehouse_id),
        _normalize(warehouse_id.replace("_", " ")),
        _normalize(identity.get("title")),
        _normalize(metadata.get("provider")),
    }
    return {alias for alias in aliases if alias}


def _matches_alias(candidate: str | None, aliases: set[str]) -> bool:
    candidate_norm = _normalize(candidate)
    if not candidate_norm:
        return False
    return any(
        candidate_norm == alias
        or candidate_norm in alias
        or alias in candidate_norm
        for alias in aliases
    )


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def text_values(value: Any) -> Iterable[str]:
    if value is None:
        return
    if isinstance(value, str):
        yield value
        return
    if isinstance(value, (int, float, bool)):
        yield str(value)
        return
    if isinstance(value, list):
        for item in value:
            yield from text_values(item)
        return
    if isinstance(value, dict):
        for item in value.values():
            yield from text_values(item)


def file_extension(filename_or_url: str | None) -> str:
    if not filename_or_url:
        return ""
    cleaned = filename_or_url.split("?", maxsplit=1)[0].rstrip("/")
    return cleaned.rsplit(".", maxsplit=1)[-1].lower() if "." in cleaned else ""


def is_spatial_format(filename_or_url: str | None) -> bool:
    return file_extension(filename_or_url) in SPATIAL_EXTENSIONS


def has_spatiotemporal_signal(*parts: Any) -> bool:
    text = " ".join(item for part in parts for item in text_values(part)).lower()
    return any(term in text for term in SPATIAL_TERMS) and any(term in text for term in TEMPORAL_TERMS)


def selected_download_urls(files: list[dict[str, Any]], *, max_size_mb: float | None = None) -> list[str]:
    urls: list[str] = []
    max_bytes = max_size_mb * 1_000_000 if max_size_mb is not None else None
    for file_info in files:
        url = file_info.get("url_dl") or file_info.get("url") or file_info.get("download_url")
        size = file_info.get("size_bytes")
        if not url:
            continue
        if max_bytes is not None and isinstance(size, (int, float)) and size > max_bytes:
            continue
        urls.append(str(url))
    return urls


def safe_filename(value: str | None, *, fallback: str = "download") -> str:
    text = (value or fallback).strip().replace("\\", "_").replace("/", "_")
    text = re.sub(r"[^A-Za-z0-9._-]+", "_", text)
    text = text.strip("._")
    return text[:180] or fallback


def download_candidate_files(
    records: list[dict[str, Any]],
    *,
    output_dir: str | Path = DEFAULT_DATACANDIDATE_DOWNLOAD_DIR,
    heavy_threshold_mb: float = 100.0,
    yes_heavy: bool = False,
    overwrite: bool = False,
) -> list[dict[str, Any]]:
    """Download candidate files with an interactive confirmation for heavy files."""

    import requests

    output_base = Path(output_dir)
    output_base.mkdir(parents=True, exist_ok=True)
    downloads: list[dict[str, Any]] = []
    threshold_bytes = int(heavy_threshold_mb * 1_000_000)

    for record in records:
        source = safe_filename(str(record.get("source") or "unknown"))
        record_id = safe_filename(str(record.get("record_id") or record.get("zenodo_id") or record.get("doi_dataset") or "record"))
        record_dir = output_base / source / record_id
        record_dir.mkdir(parents=True, exist_ok=True)
        record_downloads: list[dict[str, Any]] = []

        files = record.get("files") if isinstance(record.get("files"), list) else []
        selected_urls = {str(url) for url in record.get("url_dl", []) if url}
        if files and selected_urls:
            files = [
                file_info
                for file_info in files
                if isinstance(file_info, dict)
                and str(file_info.get("url_dl") or file_info.get("url") or file_info.get("download_url")) in selected_urls
            ]
        if not files:
            files = [{"url_dl": url, "filename": None, "size_bytes": None} for url in record.get("url_dl", [])]

        for index, file_info in enumerate(files, start=1):
            if not isinstance(file_info, dict):
                continue
            url = file_info.get("url_dl") or file_info.get("url") or file_info.get("download_url")
            if not url:
                continue
            size = file_info.get("size_bytes")
            filename = safe_filename(file_info.get("filename") or Path(str(url).split("?", 1)[0]).name, fallback=f"file_{index}")
            local_path = record_dir / filename

            if not isinstance(size, (int, float)):
                try:
                    head = requests.head(str(url), allow_redirects=True, timeout=30)
                    if head.ok and head.headers.get("content-length"):
                        size = int(head.headers["content-length"])
                except (requests.RequestException, ValueError):
                    size = None

            if isinstance(size, (int, float)) and size > threshold_bytes and not yes_heavy:
                size_mb = round(float(size) / 1_000_000, 2)
                answer = input(
                    f"{filename} fait environ {size_mb} MB, seuil {heavy_threshold_mb} MB. "
                    "Telecharger ? [y/N] "
                ).strip().lower()
                if answer not in {"y", "yes", "o", "oui"}:
                    skipped = {
                        "url": url,
                        "local_path": None,
                        "status": "skipped_heavy",
                        "size_mb": size_mb,
                    }
                    downloads.append(skipped)
                    record_downloads.append(skipped)
                    continue

            if local_path.exists() and not overwrite:
                existing = {
                    "url": url,
                    "local_path": str(local_path),
                    "status": "exists",
                    "size_bytes": local_path.stat().st_size,
                }
                downloads.append(existing)
                record_downloads.append(existing)
                continue

            hasher = hashlib.sha256()
            bytes_written = 0
            try:
                with requests.get(str(url), stream=True, timeout=120) as response:
                    response.raise_for_status()
                    with local_path.open("wb") as handle:
                        for chunk in response.iter_content(chunk_size=1024 * 1024):
                            if not chunk:
                                continue
                            handle.write(chunk)
                            hasher.update(chunk)
                            bytes_written += len(chunk)
            except requests.RequestException as exc:
                failed = {
                    "url": url,
                    "local_path": str(local_path),
                    "status": "failed",
                    "error": repr(exc),
                }
                downloads.append(failed)
                record_downloads.append(failed)
                if local_path.exists() and bytes_written == 0:
                    local_path.unlink()
                continue

            downloaded = {
                "url": url,
                "local_path": str(local_path),
                "status": "downloaded",
                "size_bytes": bytes_written,
                "sha256": hasher.hexdigest(),
            }
            downloads.append(downloaded)
            record_downloads.append(downloaded)
        record["downloads"] = record_downloads

    return downloads


def append_jsonl(path: Path, records: Iterable[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=True) + "\n")


def records_to_rows(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for record in records:
        files = record.get("files", [])
        formats = sorted(
            {
                str(file_info.get("format"))
                for file_info in files
                if isinstance(file_info, dict) and file_info.get("format")
            }
        )
        rows.append(
            {
                "source": record.get("source"),
                "record_id": record.get("record_id"),
                "title": record.get("title"),
                "year": record.get("year"),
                "license": record.get("license"),
                "doi_dataset": record.get("doi_dataset"),
                "doi_publication": "; ".join(record.get("doi_publication", [])),
                "n_files": record.get("n_files"),
                "formats": ", ".join(formats),
                "spatial_formats": ", ".join(record.get("spatial_formats", [])),
                "total_size_mb": record.get("total_size_mb"),
                "landing_url": record.get("landing_url"),
                "first_download_url": next(iter(record.get("url_dl", [])), None),
                "paper_title": record.get("paper_title"),
                "paper_year": record.get("paper_year"),
                "abstract_available": bool(record.get("paper_abstract")),
                "paper_abstract_preview": (record.get("paper_abstract") or "")[:240],
                "task_type": record.get("task_type"),
                "modeling_signals": ", ".join(record.get("modeling_signals", [])),
                "modeling_score": record.get("modeling_score"),
                "candidate_decision": record.get("candidate_decision"),
            }
        )
    return rows


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    import csv

    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else [
        "source",
        "record_id",
        "title",
        "year",
        "license",
        "doi_dataset",
        "doi_publication",
        "n_files",
        "formats",
        "spatial_formats",
        "total_size_mb",
        "landing_url",
        "first_download_url",
        "paper_title",
        "paper_year",
        "abstract_available",
        "paper_abstract_preview",
        "task_type",
        "modeling_signals",
        "modeling_score",
        "candidate_decision",
    ]
    with path.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def print_markdown_table(rows: list[dict[str, Any]], *, max_title: int = 80) -> None:
    columns = [
        "source",
        "record_id",
        "title",
        "year",
        "n_files",
        "total_size_mb",
        "landing_url",
        "candidate_decision",
    ]
    print("| " + " | ".join(columns) + " |")
    print("|" + "|".join("---" for _ in columns) + "|")
    for row in rows:
        values = []
        for column in columns:
            value = row.get(column)
            text = "" if value is None else str(value).replace("\n", " ")
            if column == "title" and len(text) > max_title:
                text = text[: max_title - 1] + "..."
            values.append(text.replace("|", "\\|"))
        print("| " + " | ".join(values) + " |")


def first_found_paper_metadata(
    dois: Iterable[str],
    *,
    enrich_paper: bool,
    mailto: str | None = None,
) -> dict[str, Any]:
    if not enrich_paper:
        return {}
    enrichments = enrich_paper_dois(dois, mailto=mailto, max_papers=3)
    for item in enrichments:
        if item.get("paper_lookup_status") == "found":
            return item
    return enrichments[0] if enrichments else {}


def candidate_modeling_metadata(
    *,
    title: str | None,
    description: str | None,
    paper_metadata: dict[str, Any],
) -> dict[str, Any]:
    modeling_text = " ".join(
        str(item or "")
        for item in (
            paper_metadata.get("paper_abstract"),
            paper_metadata.get("paper_title"),
            title,
            description,
        )
    )
    return analyze_modeling_signals(modeling_text)


def emit_discovery_payload(
    *,
    source: str,
    query: str,
    records: list[dict[str, Any]],
    raw_record_count: int,
    write: str | None,
    csv_path: str | None,
    view: str,
    pretty: bool,
    download_summary: list[dict[str, Any]] | None = None,
) -> None:
    payload = {
        "mode": f"{source}_spatial_discovery",
        "query": query,
        "raw_record_count": raw_record_count,
        "candidate_count": len(records),
        "records": records,
    }
    if write:
        append_jsonl(Path(write), records)
        payload["written_to"] = str(Path(write))

    rows = records_to_rows(records)
    if csv_path:
        write_csv(Path(csv_path), rows)
        payload["csv_written_to"] = csv_path
    if download_summary is not None:
        payload["download_summary"] = download_summary

    if view == "markdown":
        print_markdown_table(rows)
    elif view == "summary":
        summary_payload = {
            "mode": payload["mode"],
            "query": payload["query"],
            "raw_record_count": payload["raw_record_count"],
            "candidate_count": payload["candidate_count"],
            "written_to": payload.get("written_to"),
            "csv_written_to": payload.get("csv_written_to"),
            "records": rows,
        }
        print(json.dumps(summary_payload, indent=2 if pretty else None, ensure_ascii=True))
    elif pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


def _as_list(value: Any) -> list[Any]:
    if value is None:
        return []
    if isinstance(value, list):
        return value
    return [value]


def extract_dois_from_text(text: str | None) -> list[str]:
    """Extract DOI-like strings from text."""

    if not text:
        return []
    return sorted({match.rstrip(".,);]") for match in DOI_PATTERN.findall(text)})


def abstract_from_inverted_index(index: dict[str, Any] | None) -> str | None:
    """Reconstruct an OpenAlex abstract from its inverted index."""

    if not isinstance(index, dict) or not index:
        return None
    positions: list[tuple[int, str]] = []
    for word, offsets in index.items():
        if not isinstance(offsets, list):
            continue
        for offset in offsets:
            if isinstance(offset, int):
                positions.append((offset, word))
    if not positions:
        return None
    return " ".join(word for _, word in sorted(positions))


def compact_authors(work: dict[str, Any], limit: int = 8) -> list[str]:
    authors = []
    for authorship in _as_list(work.get("authorships"))[:limit]:
        author = authorship.get("author") if isinstance(authorship, dict) else None
        if isinstance(author, dict) and author.get("display_name"):
            authors.append(str(author["display_name"]))
    return authors


def openalex_get_by_doi(
    session: Any,
    doi: str,
    *,
    mailto: str | None = None,
) -> dict[str, Any] | None:
    import requests

    doi_value = doi.strip()
    if not doi_value:
        return None
    if not doi_value.lower().startswith("https://doi.org/"):
        doi_value = f"https://doi.org/{doi_value}"
    params = {
        "select": "id,doi,title,publication_year,abstract_inverted_index,primary_location,authorships,concepts,topics"
    }
    if mailto:
        params["mailto"] = mailto
    try:
        response = session.get(f"https://api.openalex.org/works/doi:{doi_value}", params=params, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code != 200:
        return None
    return response.json()


def analyze_modeling_signals(text_source: str | None) -> dict[str, Any]:
    """Classify whether paper text suggests useful modeling relations."""

    text = (text_source or "").lower()
    signals: list[str] = []
    evidence_terms: list[str] = []
    score = 0

    for signal, terms in MODELING_SIGNAL_GROUPS.items():
        matched = [term for term in terms if term in text]
        if not matched:
            continue
        signals.append(signal)
        evidence_terms.extend(matched[:3])
        score += 2 if signal in {"spatial_panel", "spatiotemporal_model", "forecasting"} else 1

    low_value_terms = [term for term in LOW_MODELING_VALUE_TERMS if term in text]
    score -= min(len(low_value_terms), 3)

    if "spatial_panel" in signals:
        task_type = "spatial_panel_modeling"
    elif "spatiotemporal_model" in signals and "forecasting" in signals:
        task_type = "spatio_temporal_forecasting"
    elif "machine_learning" in signals and any(term in text for term in ("classification", "segmentation")):
        task_type = "spatial_ml_classification"
    elif "forecasting" in signals:
        task_type = "forecasting"
    elif "regression" in signals:
        task_type = "regression"
    elif "machine_learning" in signals:
        task_type = "machine_learning"
    elif "simulation_modeling" in signals:
        task_type = "simulation_modeling"
    elif low_value_terms:
        task_type = "descriptive_mapping"
    else:
        task_type = "unknown"

    if score >= 3:
        decision = "keep"
    elif score >= 1:
        decision = "review"
    elif low_value_terms:
        decision = "drop_or_low_priority"
    else:
        decision = "review"

    return {
        "modeling_signals": sorted(set(signals)),
        "modeling_evidence_terms": sorted(set(evidence_terms)),
        "low_modeling_value_terms": sorted(set(low_value_terms)),
        "task_type": task_type,
        "modeling_score": score,
        "candidate_decision": decision,
    }


def enrich_paper_dois(
    dois: Iterable[str],
    *,
    mailto: str | None = None,
    max_papers: int = 3,
) -> list[dict[str, Any]]:
    """Fetch paper abstracts and modeling signals for DOI candidates."""

    import requests

    unique_dois = []
    seen = set()
    for doi in dois:
        cleaned = (doi or "").strip()
        if not cleaned or cleaned.lower() in seen:
            continue
        seen.add(cleaned.lower())
        unique_dois.append(cleaned)

    session = requests.Session()
    enriched: list[dict[str, Any]] = []
    for doi in unique_dois[:max_papers]:
        work = openalex_get_by_doi(session, doi, mailto=mailto)
        if not work:
            enriched.append(
                {
                    "paper_lookup_status": "not_found",
                    "paper_source": "openalex",
                    "paper_doi": doi,
                }
            )
            continue

        abstract = abstract_from_inverted_index(work.get("abstract_inverted_index"))
        primary_location = work.get("primary_location") if isinstance(work.get("primary_location"), dict) else {}
        source = primary_location.get("source") if isinstance(primary_location.get("source"), dict) else {}
        analysis_text = " ".join(
            item
            for item in (
                str(work.get("title") or ""),
                abstract or "",
            )
            if item
        )
        enriched.append(
            {
                "paper_lookup_status": "found",
                "paper_source": "openalex",
                "paper_openalex_id": work.get("id"),
                "paper_doi": work.get("doi") or doi,
                "paper_title": work.get("title"),
                "paper_year": work.get("publication_year"),
                "paper_venue": source.get("display_name") if isinstance(source, dict) else None,
                "paper_authors": compact_authors(work),
                "paper_abstract": abstract,
                **analyze_modeling_signals(analysis_text),
            }
        )
    return enriched


def extract_publication_dois_from_dataset(dataset: dict[str, Any]) -> list[str]:
    """Find DOI-like publication references already known in the catalog."""

    candidates: list[str] = []
    identity = dataset.get("identity", {})
    traceability = dataset.get("traceability", {})
    for key in ("publication_doi", "paper_doi", "article_doi"):
        candidates.extend(str(item) for item in _as_list(identity.get(key)) if item)
    for key in ("linked_papers", "source_papers", "publications"):
        for item in _as_list(traceability.get(key)):
            if isinstance(item, dict):
                candidates.extend(str(value) for value in item.values() if value)
            elif item:
                candidates.append(str(item))
    return extract_dois_from_text(" ".join(candidates))


def add_paper_enrichment_to_plan_payload(
    payload: dict[str, Any],
    *,
    mailto: str | None = None,
    max_papers: int = 3,
) -> dict[str, Any]:
    """Attach paper abstract/modeling metadata to plan seeds when DOI links exist."""

    catalog = load_catalog()
    datasets = {dataset.get("dataset_id"): dataset for dataset in catalog.get("datasets", [])}
    enrichment_by_dataset: dict[str, list[dict[str, Any]]] = {}

    for seed in payload.get("seeds_preview", []):
        dataset_id = seed.get("dataset_id")
        if dataset_id in enrichment_by_dataset:
            seed["paper_enrichment"] = enrichment_by_dataset[dataset_id]
            continue
        dataset = datasets.get(dataset_id)
        publication_dois = extract_publication_dois_from_dataset(dataset or {})
        enrichment = enrich_paper_dois(publication_dois, mailto=mailto, max_papers=max_papers)
        enrichment_by_dataset[dataset_id] = enrichment
        seed["paper_enrichment"] = enrichment

    payload["paper_enrichment_summary"] = {
        "source": "catalog_doi_to_openalex",
        "dataset_count": len(enrichment_by_dataset),
        "enriched_dataset_count": sum(1 for values in enrichment_by_dataset.values() if values),
    }
    return payload


@dataclass(frozen=True)
class PortalSeed:
    """One discovery layer candidate to revisit in a later scraping phase."""

    dataset_id: str
    dataset_title: str
    warehouse_id: str
    warehouse_title: str
    provider: str | None
    layer_type: str
    layer_name: str | None
    access: str | None
    url: str
    notes: str | None


@dataclass(frozen=True)
class PortalPlan:
    """Prepared but non-executed scraping plan for one warehouse."""

    warehouse_id: str
    warehouse_title: str
    preferred_layer_types: list[str]
    dataset_ids: list[str]
    seed_count: int
    seeds: list[PortalSeed]
    next_phase_actions: list[str]
    suggested_outputs: dict[str, str]


def load_catalog() -> dict[str, Any]:
    """Load the local catalog registry."""

    with CATALOG_PATH.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def get_warehouse_record(catalog: dict[str, Any], warehouse_id: str) -> dict[str, Any]:
    """Return the warehouse record matching ``warehouse_id``."""

    for warehouse in catalog.get("warehouses", []):
        if warehouse.get("warehouse_id") == warehouse_id:
            return warehouse
    raise KeyError(f"Unknown warehouse_id: {warehouse_id}")


def _dataset_matches_warehouse(dataset: dict[str, Any], warehouse_aliases: set[str]) -> bool:
    traceability = dataset.get("traceability", {})
    linked = {_normalize(item) for item in traceability.get("linked_warehouses", [])}
    if any(_matches_alias(item, warehouse_aliases) for item in linked):
        return True

    for warehouse in dataset.get("source_access", {}).get("warehouses", []):
        if _matches_alias(warehouse.get("name"), warehouse_aliases):
            return True
        if _matches_alias(warehouse.get("provider"), warehouse_aliases):
            return True
    return False


def iter_dataset_records_for_warehouse(
    catalog: dict[str, Any],
    warehouse_id: str,
    dataset_id_filter: str | None = None,
) -> Iterable[dict[str, Any]]:
    """Yield dataset records linked to a warehouse."""

    warehouse = get_warehouse_record(catalog, warehouse_id)
    warehouse_aliases = _warehouse_aliases(warehouse, warehouse_id)
    for dataset in catalog.get("datasets", []):
        dataset_id = dataset.get("dataset_id")
        if dataset_id_filter and dataset_id != dataset_id_filter:
            continue
        if _dataset_matches_warehouse(dataset, warehouse_aliases):
            yield dataset


def build_portal_seeds(
    catalog: dict[str, Any],
    warehouse_id: str,
    preferred_layer_types: tuple[str, ...],
    dataset_id_filter: str | None = None,
    include_nonpreferred: bool = False,
) -> list[PortalSeed]:
    """Collect seed URLs for later scraping."""

    warehouse = get_warehouse_record(catalog, warehouse_id)
    warehouse_title = warehouse.get("identity", {}).get("title", warehouse_id)
    warehouse_aliases = _warehouse_aliases(warehouse, warehouse_id)
    preferred_set = {item for item in preferred_layer_types}
    seeds: list[PortalSeed] = []

    for dataset in iter_dataset_records_for_warehouse(catalog, warehouse_id, dataset_id_filter):
        dataset_id = dataset["dataset_id"]
        dataset_title = dataset.get("identity", {}).get("title", dataset_id)
        for source_warehouse in dataset.get("source_access", {}).get("warehouses", []):
            if not _dataset_matches_warehouse({"source_access": {"warehouses": [source_warehouse]}}, warehouse_aliases):
                continue
            for layer in source_warehouse.get("discovery_layers", []):
                layer_type = layer.get("layer_type", "unknown")
                if not include_nonpreferred and layer_type not in preferred_set:
                    continue
                url = layer.get("url")
                if not url:
                    continue
                seeds.append(
                    PortalSeed(
                        dataset_id=dataset_id,
                        dataset_title=dataset_title,
                        warehouse_id=warehouse_id,
                        warehouse_title=warehouse_title,
                        provider=source_warehouse.get("provider"),
                        layer_type=layer_type,
                        layer_name=layer.get("name"),
                        access=layer.get("access"),
                        url=url,
                        notes=layer.get("notes"),
                    )
                )

    seeds.sort(key=lambda item: (item.dataset_id, item.layer_type, item.url))
    return seeds


def build_portal_plan(
    warehouse_id: str,
    preferred_layer_types: tuple[str, ...],
    dataset_id_filter: str | None = None,
    include_nonpreferred: bool = False,
) -> PortalPlan:
    """Build a non-executed portal scraping plan."""

    catalog = load_catalog()
    warehouse = get_warehouse_record(catalog, warehouse_id)
    seeds = build_portal_seeds(
        catalog=catalog,
        warehouse_id=warehouse_id,
        preferred_layer_types=preferred_layer_types,
        dataset_id_filter=dataset_id_filter,
        include_nonpreferred=include_nonpreferred,
    )
    dataset_ids = sorted({seed.dataset_id for seed in seeds})
    output_base = DEFAULT_PLAN_DIR / warehouse_id
    return PortalPlan(
        warehouse_id=warehouse_id,
        warehouse_title=warehouse.get("identity", {}).get("title", warehouse_id),
        preferred_layer_types=list(preferred_layer_types),
        dataset_ids=dataset_ids,
        seed_count=len(seeds),
        seeds=seeds,
        next_phase_actions=[
            "fetch robots.txt and warehouse terms before enabling network collection",
            "classify each seed as html page, api endpoint, metadata page, or bulk file",
            "add warehouse-specific parsers for dataset cards, download links, and license fields",
            "write normalized records into data/manifests/ without mutating raw/",
        ],
        suggested_outputs={
            "plan_json": str(output_base.with_suffix(".plan.json")),
            "raw_seed_log": str(output_base.with_suffix(".seed-log.jsonl")),
            "normalized_records": str(output_base.with_suffix(".records.jsonl")),
        },
    )


def plan_to_payload(plan: PortalPlan, limit: int | None = None) -> dict[str, Any]:
    seeds = [asdict(seed) for seed in plan.seeds[:limit]] if limit is not None else [asdict(seed) for seed in plan.seeds]
    return {
        "warehouse_id": plan.warehouse_id,
        "warehouse_title": plan.warehouse_title,
        "preferred_layer_types": plan.preferred_layer_types,
        "dataset_ids": plan.dataset_ids,
        "seed_count": plan.seed_count,
        "seeds_preview": seeds,
        "next_phase_actions": plan.next_phase_actions,
        "suggested_outputs": plan.suggested_outputs,
    }


def default_plan_path(warehouse_id: str) -> Path:
    return DEFAULT_PLAN_DIR / f"{warehouse_id}.plan.json"


def save_plan_payload(payload: dict[str, Any], output_path: str | Path) -> Path:
    path = Path(output_path)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=True), encoding="utf-8")
    return path


def load_plan_payload(plan_path: str | Path) -> dict[str, Any]:
    return json.loads(Path(plan_path).read_text(encoding="utf-8"))


def resolve_plan_payload(
    *,
    warehouse_id: str | None,
    preferred_layer_types: tuple[str, ...] | None = None,
    dataset_id: str | None = None,
    plan_path: str | None = None,
    include_nonpreferred: bool = False,
) -> dict[str, Any]:
    if plan_path:
        return load_plan_payload(plan_path)
    if not warehouse_id or not preferred_layer_types:
        raise ValueError("Either --plan or both --warehouse-id and preferred_layer_types are required.")
    return plan_to_payload(
        build_portal_plan(
            warehouse_id=warehouse_id,
            preferred_layer_types=preferred_layer_types,
            dataset_id_filter=dataset_id,
            include_nonpreferred=include_nonpreferred,
        )
    )


def build_fetch_jobs(plan_payload: dict[str, Any]) -> list[dict[str, Any]]:
    parser_hints = {
        "portal": "html_dataset_listing",
        "publication_page": "html_publication_page",
        "metadata_page": "html_metadata_page",
        "bulk_download": "direct_file_or_download_page",
        "catalog": "catalog_page",
        "api": "api_endpoint",
        "api_catalogue": "api_catalogue",
        "api_portal_reference": "api_reference_page",
        "record_layout": "documentation_page",
        "methodology_page": "documentation_page",
        "direct_download_portal": "download_portal",
        "publication_portal": "publication_portal",
        "sdmx_api_documentation": "api_documentation_page",
    }
    jobs: list[dict[str, Any]] = []
    for seed in plan_payload.get("seeds_preview", []):
        dataset_id = seed["dataset_id"]
        layer_type = seed["layer_type"]
        jobs.append(
            {
                "job_id": f"{plan_payload['warehouse_id']}::{dataset_id}::{layer_type}",
                "warehouse_id": plan_payload["warehouse_id"],
                "dataset_id": dataset_id,
                "dataset_title": seed["dataset_title"],
                "layer_type": layer_type,
                "url": seed["url"],
                "method": "GET",
                "headers": {
                    "User-Agent": "llm-wiki-scraper/0.1",
                    "Accept": "*/*",
                },
                "parser_hint": parser_hints.get(layer_type, "generic_page"),
                "capture": {
                    "status_code": True,
                    "content_type": True,
                    "final_url": True,
                    "download_links": True,
                    "license_text": True,
                    "doi_strings": True,
                },
                "output_targets": {
                    "raw_response_jsonl": plan_payload["suggested_outputs"]["raw_seed_log"],
                    "normalized_records_jsonl": plan_payload["suggested_outputs"]["normalized_records"],
                },
            }
        )
    return jobs


def _plan_to_jsonable(plan: PortalPlan, limit: int | None = None) -> dict[str, Any]:
    return plan_to_payload(plan, limit=limit)


def run_portal_cli(
    *,
    warehouse_id: str,
    preferred_layer_types: tuple[str, ...],
    script_label: str,
    extra_notes: tuple[str, ...] = (),
) -> None:
    """Standard CLI for warehouse portal plan builders."""

    parser = argparse.ArgumentParser(description=script_label)
    parser.add_argument("--dataset-id", help="Restrict the plan to one dataset_id.")
    parser.add_argument(
        "--include-nonpreferred",
        action="store_true",
        help="Keep all discovery layers instead of filtering to preferred ones.",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=10,
        help="Limit the number of seeds shown in the preview output.",
    )
    parser.add_argument(
        "--pretty",
        action="store_true",
        help="Pretty-print the generated plan as JSON.",
    )
    parser.add_argument(
        "--write-plan",
        action="store_true",
        help="Write the generated plan to the default plans location.",
    )
    parser.add_argument(
        "--enrich-paper",
        action="store_true",
        help="Enrich plan seeds with paper abstracts/modeling signals when catalog DOI links exist.",
    )
    parser.add_argument(
        "--mailto",
        help="Optional email parameter for polite OpenAlex API requests used by --enrich-paper.",
    )
    args = parser.parse_args()

    plan = build_portal_plan(
        warehouse_id=warehouse_id,
        preferred_layer_types=preferred_layer_types,
        dataset_id_filter=args.dataset_id,
        include_nonpreferred=args.include_nonpreferred,
    )
    payload = _plan_to_jsonable(plan, limit=args.limit)
    if extra_notes:
        payload["warehouse_specific_notes"] = list(extra_notes)
    if args.enrich_paper:
        add_paper_enrichment_to_plan_payload(payload, mailto=args.mailto)
    if args.write_plan:
        save_plan_payload(payload, default_plan_path(warehouse_id))

    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))
