"""Discover spatial and spatio-temporal datasets from Zenodo.

This script ports the Zenodo-oriented R prototype into the Python
``pipeline_portals`` layer. It queries the Zenodo InvenioRDM API, filters
records to dataset resources with spatial and temporal signals, extracts
download/file metadata, and can append normalized JSONL records under
``data/manifests/plans/``.
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
import sys
import time
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

import requests

from portal_common import DEFAULT_DATACANDIDATE_DOWNLOAD_DIR, download_candidate_files


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_OUTPUT = REPO_ROOT / "data" / "manifests" / "plans" / "zenodo.records.jsonl"

ZENODO_BASE_URL = "https://zenodo.org/api"
ZENODO_RPM = 25
ZENODO_PAGE_SIZE = 25
ZENODO_MAX_PAGES = 200

SPATIAL_QUERY_TERMS = (
    "spatial",
    "geospatial",
    "shapefile",
    "GeoTIFF",
    "NetCDF",
    "raster",
    "GIS",
    "coordinates",
    "spatiotemporal",
    "geostatistics",
    "geocoded",
    "geographic",
)
SPATIAL_QUERY = " OR ".join(SPATIAL_QUERY_TERMS)

DATASET_TYPES = {"dataset"}

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

SPATIAL_TAGS = (
    "spatial",
    "geospatial",
    "gis",
    "raster",
    "vector",
    "shapefile",
    "geotiff",
    "netcdf",
    "coordinates",
    "longitude",
    "latitude",
    "crs",
    "epsg",
    "projection",
    "geographic",
    "geodata",
    "spatio-temporal",
    "spatiotemporal",
    "space-time",
    "panel data",
)

TEMPORAL_TAGS = (
    r"spatio.?temporal",
    "spatiotemporal",
    "space.time",
    "time.series",
    "longitudinal",
    "panel.data",
    "monthly",
    "annual",
    "daily",
    "yearly",
    "temporal",
    "time.period",
    r"\bpanel\b",
)

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


def utc_now() -> str:
    """Retourne la date UTC pour tracer quand le record Zenodo a ete produit."""

    return datetime.now(timezone.utc).isoformat()


def log(message: str, verbose: bool) -> None:
    """Affiche un message de progression seulement si le mode verbeux est actif."""

    if verbose:
        print(message, file=sys.stderr)


def text_values(value: Any) -> Iterable[str]:
    """Aplati des valeurs imbriquees Zenodo en texte pour les filtres."""

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


def get_path(value: dict[str, Any], *keys: str, default: Any = None) -> Any:
    """Lit un chemin imbrique dans un dictionnaire Zenodo sans lever d'erreur."""

    current: Any = value
    for key in keys:
        if not isinstance(current, dict) or key not in current:
            return default
        current = current[key]
    return current


def as_list(value: Any) -> list[Any]:
    """Garantit qu'une valeur est manipulee comme une liste."""

    if value is None:
        return []
    if isinstance(value, list):
        return value
    return [value]


def file_extension(filename_or_url: str | None) -> str:
    """Recupere l'extension d'un fichier ou d'une URL Zenodo."""

    if not filename_or_url:
        return ""
    cleaned = filename_or_url.split("?", maxsplit=1)[0].rstrip("/")
    return cleaned.rsplit(".", maxsplit=1)[-1].lower() if "." in cleaned else ""


def zenodo_get(
    session: requests.Session,
    endpoint: str,
    params: dict[str, Any],
    *,
    max_tries: int,
    verbose: bool,
) -> dict[str, Any] | None:
    """Interroge l'API Zenodo avec temporisation et gestion des erreurs HTTP."""

    url = f"{ZENODO_BASE_URL}{endpoint}"
    delay = 60 / ZENODO_RPM

    for attempt in range(1, max_tries + 1):
        time.sleep(delay)
        try:
            response = session.get(url, params=params, headers={"Accept": "application/json"}, timeout=60)
        except requests.RequestException as exc:
            log(f"Network failure on attempt {attempt}: {exc}", verbose)
            if attempt == max_tries:
                return None
            time.sleep(min(2**attempt * 5, 120))
            continue

        if response.status_code == 400:
            log(f"HTTP 400 Bad Request: {response.url}", verbose)
            log(response.text[:800], verbose)
            return None
        if response.status_code == 429:
            retry_after = int(response.headers.get("Retry-After", "60"))
            log(f"Rate limited; waiting {retry_after}s", verbose)
            time.sleep(retry_after)
            continue
        if response.status_code >= 500:
            log(f"HTTP {response.status_code}; retrying", verbose)
            time.sleep(min(2**attempt * 5, 120))
            continue
        if response.status_code != 200:
            log(f"Unexpected HTTP {response.status_code}: {response.url}", verbose)
            return None

        return response.json()

    return None


def openalex_get_by_doi(
    session: requests.Session,
    doi: str,
    *,
    mailto: str | None,
    verbose: bool,
) -> dict[str, Any] | None:
    """Interroge OpenAlex pour retrouver les metadonnees d'un papier a partir d'un DOI."""

    doi_value = doi.strip()
    if not doi_value:
        return None
    if not doi_value.lower().startswith("https://doi.org/"):
        doi_value = f"https://doi.org/{doi_value}"
    params = {"select": "id,doi,title,publication_year,abstract_inverted_index,primary_location,authorships,concepts,topics"}
    if mailto:
        params["mailto"] = mailto
    try:
        response = session.get(f"https://api.openalex.org/works/doi:{doi_value}", params=params, timeout=60)
    except requests.RequestException as exc:
        log(f"OpenAlex request failed for {doi}: {exc}", verbose)
        return None
    if response.status_code == 404:
        return None
    if response.status_code != 200:
        log(f"OpenAlex returned HTTP {response.status_code} for {doi}", verbose)
        return None
    return response.json()


def abstract_from_inverted_index(index: dict[str, Any] | None) -> str | None:
    """Reconstruit un abstract OpenAlex stocke sous forme d'index inverse."""

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
    """Retourne une liste courte d'auteurs depuis une fiche OpenAlex."""

    authors = []
    for authorship in as_list(work.get("authorships"))[:limit]:
        author = authorship.get("author") if isinstance(authorship, dict) else None
        if isinstance(author, dict) and author.get("display_name"):
            authors.append(str(author["display_name"]))
    return authors


def extract_paper_metadata(
    publication_dois: list[str],
    *,
    enrich_paper: bool,
    mailto: str | None,
    verbose: bool,
) -> dict[str, Any]:
    """Recupere le premier papier OpenAlex disponible parmi les DOI lies au dataset."""

    if not enrich_paper or not publication_dois:
        return {}

    session = requests.Session()
    for doi in publication_dois:
        work = openalex_get_by_doi(session, doi, mailto=mailto, verbose=verbose)
        if not work:
            continue
        abstract = abstract_from_inverted_index(work.get("abstract_inverted_index"))
        primary_location = work.get("primary_location") if isinstance(work.get("primary_location"), dict) else {}
        source = primary_location.get("source") if isinstance(primary_location.get("source"), dict) else {}
        return {
            "paper_lookup_status": "found",
            "paper_source": "openalex",
            "paper_openalex_id": work.get("id"),
            "paper_doi": work.get("doi") or doi,
            "paper_title": work.get("title"),
            "paper_year": work.get("publication_year"),
            "paper_venue": source.get("display_name") if isinstance(source, dict) else None,
            "paper_authors": compact_authors(work),
            "paper_abstract": abstract,
        }

    return {
        "paper_lookup_status": "not_found",
        "paper_source": "openalex",
        "paper_doi": publication_dois[0],
    }


def analyze_modeling_signals(text_source: str | None) -> dict[str, Any]:
    """Detecte dans le titre/abstract les indices de regression, prediction ou modelisation."""

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


def fetch_all_zenodo_records(
    query: str,
    *,
    max_pages: int,
    communities: list[str],
    verbose: bool,
) -> list[dict[str, Any]]:
    """Recupere les pages de resultats Zenodo correspondant a la requete."""

    session = requests.Session()
    all_hits: list[dict[str, Any]] = []
    total: int | None = None

    q = query
    if communities:
        q = f"{q} AND ({' OR '.join(communities)})"

    for page in range(1, max_pages + 1):
        log(f"Fetching Zenodo page {page}", verbose)
        payload = zenodo_get(
            session,
            "/records",
            {"q": q, "page": page, "size": ZENODO_PAGE_SIZE},
            max_tries=4,
            verbose=verbose,
        )
        if payload is None:
            break

        hits = get_path(payload, "hits", "hits", default=[])
        if not hits:
            break

        if total is None:
            total_value = get_path(payload, "hits", "total")
            total = int(total_value) if isinstance(total_value, int) else None
            if total is not None:
                log(f"Zenodo reports {total} matching records", verbose)

        all_hits.extend(hit for hit in hits if isinstance(hit, dict))
        log(f"{len(all_hits)} records accumulated", verbose)

        if total is not None and len(all_hits) >= total:
            break

    return all_hits


def is_dataset(record: dict[str, Any]) -> bool:
    """Verifie que l'enregistrement Zenodo est bien de type dataset."""

    resource_type = get_path(record, "metadata", "resource_type", "type")
    resource_id = get_path(record, "metadata", "resource_type", "id")
    value = str(resource_type or resource_id or "").lower()
    return value in DATASET_TYPES


def keyword_terms(record: dict[str, Any]) -> list[str]:
    """Extrait les mots-cles et sujets declares dans les metadonnees Zenodo."""

    metadata = record.get("metadata", {})
    terms: list[str] = []
    for keyword in as_list(metadata.get("keywords")):
        terms.append(str(keyword))
    for subject in as_list(metadata.get("subjects")):
        if isinstance(subject, dict):
            terms.append(str(subject.get("term", "")))
        else:
            terms.append(str(subject))
    return [term for term in terms if term]


def record_blob(record: dict[str, Any]) -> str:
    """Construit un grand texte titre-description-notes-mots-cles pour les filtres."""

    metadata = record.get("metadata", {})
    return " ".join(
        [
            str(metadata.get("title") or ""),
            str(metadata.get("description") or ""),
            str(metadata.get("notes") or ""),
            " ".join(keyword_terms(record)),
        ]
    )


def is_spatial_record(record: dict[str, Any]) -> bool:
    """Teste si un record Zenodo porte un signal spatial ou un fichier spatial."""

    keyword_blob = " ".join(keyword_terms(record)).lower()
    if any(tag.lower() in keyword_blob for tag in SPATIAL_TAGS):
        return True

    for file_record in as_list(record.get("files")):
        if isinstance(file_record, dict) and file_extension(file_record.get("key")) in SPATIAL_EXTENSIONS:
            return True

    blob = record_blob(record)
    return any(re.search(re.escape(tag), blob, flags=re.IGNORECASE) for tag in SPATIAL_TAGS)


def has_temporal_dimension(record: dict[str, Any]) -> bool:
    """Teste si un record Zenodo contient un signal temporel exploitable."""

    blob = record_blob(record)
    return any(re.search(pattern, blob, flags=re.IGNORECASE) for pattern in TEMPORAL_TAGS)


def extract_publication_dois(record: dict[str, Any]) -> list[str]:
    """Extrait les DOI de papiers associes dans les relations Zenodo."""

    related = as_list(get_path(record, "metadata", "related_identifiers"))
    publication_relations = {"issupplementto", "isreferencedby", "iscitedby", "isdocumentedby"}
    dois: list[str] = []
    for item in related:
        if not isinstance(item, dict):
            continue
        relation = str(item.get("relation") or "").lower()
        scheme = str(item.get("scheme") or "").lower()
        identifier = item.get("identifier")
        if relation in publication_relations and scheme == "doi" and identifier:
            match = re.search(r"10\.\d{4,9}/[-._;()/:A-Z0-9]+", str(identifier), flags=re.IGNORECASE)
            if match:
                dois.append(match.group(0).rstrip(".,);]"))
    return sorted(set(dois))


@dataclass
class FileInfo:
    filename: str | None
    size_bytes: int | None
    url_dl: str | None
    format: str
    is_spatial: bool


def extract_download_urls(record: dict[str, Any]) -> list[FileInfo]:
    """Normalise les fichiers Zenodo en FileInfo avec URL, taille, format et signal spatial."""

    files = as_list(record.get("files"))
    if not files:
        doi = record.get("doi") or record.get("conceptdoi")
        return [
            FileInfo(
                filename=None,
                size_bytes=None,
                url_dl=f"https://doi.org/{doi}" if doi else None,
                format="",
                is_spatial=False,
            )
        ]

    results: list[FileInfo] = []
    for item in files:
        if not isinstance(item, dict):
            continue
        filename = item.get("key")
        ext = file_extension(filename)
        links = item.get("links") if isinstance(item.get("links"), dict) else {}
        size = item.get("size")
        results.append(
            FileInfo(
                filename=str(filename) if filename else None,
                size_bytes=int(size) if isinstance(size, int) else None,
                url_dl=links.get("self"),
                format=ext,
                is_spatial=ext in SPATIAL_EXTENSIONS,
            )
        )
    return results


def extract_dimensions_from_text(record: dict[str, Any]) -> dict[str, Any]:
    """Cherche N et T dans la description Zenodo avec des expressions regulieres."""

    text = " ".join(
        [
            str(get_path(record, "metadata", "description", default="")),
            str(get_path(record, "metadata", "notes", default="")),
        ]
    )
    n_patterns = (
        r"n\s*=\s*([0-9,]+)",
        r"([0-9,]+)\s*observations",
        r"([0-9,]+)\s*records",
        r"([0-9,]+)\s*(?:spatial units|locations|sites|stations)",
        r"sample size[^0-9]*([0-9,]+)",
        r"([0-9,]+)\s*(?:regions|municipalities|counties|countries)",
    )
    t_patterns = (
        r"t\s*=\s*([0-9]+)",
        r"([0-9]+)\s*(?:periods?|waves?|time points?|years?|months?)",
        r"([0-9]+)\s*(?:annual|monthly|quarterly|weekly)\s*observations",
    )

    n_value: int | None = None
    for pattern in n_patterns:
        match = re.search(pattern, text, flags=re.IGNORECASE)
        if match:
            n_value = int(match.group(1).replace(",", ""))
            break

    t_value: int | None = None
    year_range = re.search(r"from\s+([12][0-9]{3})\s+to\s+([12][0-9]{3})", text, flags=re.IGNORECASE)
    if year_range:
        start, end = int(year_range.group(1)), int(year_range.group(2))
        t_value = end - start + 1
    else:
        for pattern in t_patterns:
            match = re.search(pattern, text, flags=re.IGNORECASE)
            if match:
                t_value = int(match.group(1))
                break

    return {"n_obs": n_value, "t_periods": t_value, "n_t_method": "regex_metadata"}


def read_csv_partial(url: str, *, n_bytes: int = 65536) -> dict[str, Any] | None:
    """Lit seulement le debut d'un CSV distant pour estimer les lignes et periodes."""

    try:
        response = requests.get(url, headers={"Range": f"bytes=0-{n_bytes - 1}"}, timeout=60)
    except requests.RequestException:
        return None
    if response.status_code not in {200, 206}:
        return None

    text = response.content.decode("utf-8", errors="replace")
    lines = text.splitlines()
    if len(lines) < 2:
        return None
    complete = "\n".join(lines[:-1])
    try:
        reader = csv.DictReader(io.StringIO(complete))
        rows = list(reader)
    except csv.Error:
        return None
    if not rows:
        return None

    names = [name or "" for name in (reader.fieldnames or [])]
    time_cols = [name for name in names if re.search(r"^(year|date|time|month|period|wave|t)$", name, flags=re.IGNORECASE)]
    t_periods = None
    if time_cols:
        values = {row.get(time_cols[0]) for row in rows if row.get(time_cols[0]) not in {None, ""}}
        t_periods = len(values) if values else None
    return {"n_obs": len(rows), "t_periods": t_periods, "n_t_method": "csv_partial"}


def enrich_dimensions_from_file(file_info: FileInfo) -> dict[str, Any] | None:
    """Complete N/T depuis un fichier leger quand le format le permet."""

    if not file_info.url_dl:
        return None
    if file_info.format == "csv":
        return read_csv_partial(file_info.url_dl)
    return None


def parse_zenodo_record(
    record: dict[str, Any],
    *,
    enrich: bool,
    enrich_paper: bool,
    mailto: str | None,
    verbose: bool,
) -> dict[str, Any] | None:
    """Filtre, enrichit et transforme un record Zenodo brut en candidat dataset."""

    if not is_dataset(record):
        return None
    if not is_spatial_record(record):
        return None
    if not has_temporal_dimension(record):
        return None

    metadata = record.get("metadata", {})
    dimensions = extract_dimensions_from_text(record)
    files = extract_download_urls(record)
    spatial_files = [item for item in files if item.is_spatial]
    selected_files = spatial_files or files

    if enrich and (dimensions["n_obs"] is None or dimensions["t_periods"] is None):
        for file_info in selected_files:
            enriched = enrich_dimensions_from_file(file_info)
            if not enriched:
                continue
            if dimensions["n_obs"] is None:
                dimensions["n_obs"] = enriched.get("n_obs")
            if dimensions["t_periods"] is None:
                dimensions["t_periods"] = enriched.get("t_periods")
            dimensions["n_t_method"] = enriched.get("n_t_method") or dimensions["n_t_method"]
            if dimensions["n_obs"] is not None and dimensions["t_periods"] is not None:
                break

    total_size = sum(item.size_bytes or 0 for item in files)
    formats = sorted({item.format for item in files if item.is_spatial and item.format})
    publication_dois = extract_publication_dois(record)
    paper_metadata = extract_paper_metadata(
        publication_dois,
        enrich_paper=enrich_paper,
        mailto=mailto,
        verbose=verbose,
    )
    modeling_text = " ".join(
        str(item or "")
        for item in (
            paper_metadata.get("paper_abstract"),
            paper_metadata.get("paper_title"),
            metadata.get("title"),
        )
    )
    modeling_metadata = analyze_modeling_signals(modeling_text)

    return {
        "record_type": "dataset_candidate",
        "source": "zenodo",
        "scraped_at": utc_now(),
        "zenodo_id": str(record.get("id")) if record.get("id") is not None else None,
        "doi_dataset": record.get("doi"),
        "concept_doi": record.get("conceptdoi"),
        "title": metadata.get("title"),
        "year": int(str(metadata.get("publication_date", "0"))[:4]) if str(metadata.get("publication_date", ""))[:4].isdigit() else None,
        "license": get_path(metadata, "license", "id"),
        "is_spatiotemporal": True,
        "n_obs": dimensions["n_obs"],
        "t_periods": dimensions["t_periods"],
        "n_t_method": dimensions["n_t_method"],
        "doi_publication": publication_dois,
        "n_files": len(files),
        "spatial_formats": formats,
        "url_dl": [item.url_dl for item in selected_files if item.url_dl],
        "total_size_mb": round(total_size / 1_000_000, 2),
        "zenodo_url": f"https://zenodo.org/records/{record.get('id')}" if record.get("id") is not None else None,
        "files": [asdict(item) for item in files],
        **paper_metadata,
        **modeling_metadata,
    }


def append_jsonl(path: Path, records: Iterable[dict[str, Any]]) -> None:
    """Ajoute les candidats Zenodo dans un fichier JSONL de manifest."""

    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as handle:
        for record in records:
            handle.write(json.dumps(record, ensure_ascii=True) + "\n")


def records_to_rows(records: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Flatten verbose candidate records into notebook/table friendly rows."""

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
                "zenodo_id": record.get("zenodo_id"),
                "title": record.get("title"),
                "year": record.get("year"),
                "license": record.get("license"),
                "doi_dataset": record.get("doi_dataset"),
                "doi_publication": "; ".join(record.get("doi_publication", [])),
                "n_obs": record.get("n_obs"),
                "t_periods": record.get("t_periods"),
                "n_t_method": record.get("n_t_method"),
                "n_files": record.get("n_files"),
                "formats": ", ".join(formats),
                "spatial_formats": ", ".join(record.get("spatial_formats", [])),
                "total_size_mb": record.get("total_size_mb"),
                "zenodo_url": record.get("zenodo_url"),
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
    """Ecrit une table CSV compacte pour notebook ou tableur."""

    path.parent.mkdir(parents=True, exist_ok=True)
    fieldnames = list(rows[0].keys()) if rows else [
        "zenodo_id",
        "title",
        "year",
        "license",
        "doi_dataset",
        "doi_publication",
        "n_obs",
        "t_periods",
        "n_t_method",
        "n_files",
        "formats",
        "spatial_formats",
        "total_size_mb",
        "zenodo_url",
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
    """Affiche une table Markdown courte dans le terminal."""

    columns = [
        "zenodo_id",
        "title",
        "year",
        "license",
        "n_obs",
        "t_periods",
        "n_files",
        "total_size_mb",
        "zenodo_url",
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


def scrape_zenodo_spatial(
    *,
    query: str,
    max_pages: int,
    communities: list[str],
    enrich: bool,
    enrich_paper: bool = False,
    mailto: str | None = None,
    verbose: bool,
) -> tuple[list[dict[str, Any]], int]:
    """Execute le flux Zenodo complet: API, filtrage spatial/temporel, enrichissement et scoring."""

    raw_records = fetch_all_zenodo_records(query, max_pages=max_pages, communities=communities, verbose=verbose)
    parsed: list[dict[str, Any]] = []
    for record in raw_records:
        result = parse_zenodo_record(
            record,
            enrich=enrich,
            enrich_paper=enrich_paper,
            mailto=mailto,
            verbose=verbose,
        )
        if result:
            parsed.append(result)
    return parsed, len(raw_records)


def main() -> None:
    """Point d'entree CLI pour Zenodo: scraping, export, enrichissement et telechargement."""

    parser = argparse.ArgumentParser(description="Scrape Zenodo spatial/spatio-temporal dataset metadata.")
    parser.add_argument("--query", default=SPATIAL_QUERY, help="Plain Zenodo query string.")
    parser.add_argument("--max-pages", type=int, default=ZENODO_MAX_PAGES, help="Maximum API pages to fetch.")
    parser.add_argument("--community", action="append", default=[], help="Optional Zenodo community slug; repeatable.")
    parser.add_argument("--enrich", action="store_true", help="Try light partial file reads to recover N/T.")
    parser.add_argument("--enrich-paper", action="store_true", help="Fetch paper abstract metadata from OpenAlex when publication DOIs are present.")
    parser.add_argument("--mailto", help="Optional email parameter for polite OpenAlex API requests.")
    parser.add_argument("--limit", type=int, help="Limit records printed/written after filtering.")
    parser.add_argument("--write", nargs="?", const=str(DEFAULT_OUTPUT), help="Append normalized records to JSONL.")
    parser.add_argument("--csv", help="Write a flattened CSV summary for notebooks/spreadsheets.")
    parser.add_argument("--download", action="store_true", help="Download candidate files after discovery.")
    parser.add_argument("--download-dir", default=str(DEFAULT_DATACANDIDATE_DOWNLOAD_DIR))
    parser.add_argument("--heavy-threshold-mb", type=float, default=100.0)
    parser.add_argument("--yes-heavy", action="store_true", help="Download heavy files without interactive confirmation.")
    parser.add_argument(
        "--view",
        choices=("full", "summary", "markdown"),
        default="full",
        help="Choose full JSON, compact JSON summary, or Markdown table output.",
    )
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--quiet", action="store_true", help="Suppress progress logs.")
    args = parser.parse_args()

    records, raw_count = scrape_zenodo_spatial(
        query=args.query,
        max_pages=args.max_pages,
        communities=args.community,
        enrich=args.enrich,
        enrich_paper=args.enrich_paper,
        mailto=args.mailto,
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

    payload = {
        "mode": "zenodo_spatial_discovery",
        "query": args.query,
        "raw_record_count": raw_count,
        "candidate_count": len(records),
        "records": records,
    }

    if args.write:
        append_jsonl(Path(args.write), records)
        payload["written_to"] = str(Path(args.write))

    rows = records_to_rows(records)
    if args.csv:
        write_csv(Path(args.csv), rows)
        payload["csv_written_to"] = args.csv
    if download_summary is not None:
        payload["download_summary"] = download_summary

    if args.view == "markdown":
        print_markdown_table(rows)
    elif args.view == "summary":
        summary_payload = {
            "mode": payload["mode"],
            "query": payload["query"],
            "raw_record_count": payload["raw_record_count"],
            "candidate_count": payload["candidate_count"],
            "written_to": payload.get("written_to"),
            "csv_written_to": payload.get("csv_written_to"),
            "records": rows,
        }
        print(json.dumps(summary_payload, indent=2 if args.pretty else None, ensure_ascii=True))
    elif args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
