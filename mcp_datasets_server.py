from typing import Any, Iterable
import json
from pathlib import Path
import re
import sys
import traceback

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("dataset-search")

BASE_DIR = Path(__file__).parent
CATALOG_PATH = BASE_DIR / "catalogue_datasets.json"

SPATIAL_TERMS = {
    "spatial",
    "spatio",
    "spatiotemporal",
    "spatio-temporal",
    "geographic",
    "territorial",
    "regional",
    "region",
    "commune",
    "iris",
    "parcel",
    "coordinates",
    "bilateral",
    "geo",
}
METADATA_TERMS = {
    "metadata",
    "schema",
    "classification",
    "traceability",
    "rich",
    "richness",
    "variables",
    "license",
}
LICENSE_TERMS = {
    "license",
    "licence",
    "open",
    "reusable",
    "reuse",
    "open-data",
    "open_data",
}
PAPER_TERMS = {
    "paper",
    "papers",
    "publication",
    "article",
    "doi",
    "linked",
    "traceability",
}


def load_catalog_payload() -> dict[str, Any]:
    if not CATALOG_PATH.exists():
        return {}

    with open(CATALOG_PATH, "r", encoding="utf-8-sig") as f:
        payload = json.load(f)

    if isinstance(payload, list):
        return {"datasets": payload, "papers": [], "warehouses": [], "sources": []}

    if isinstance(payload, dict):
        return payload

    return {}


def iter_text_values(value: Any) -> Iterable[str]:
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
            yield from iter_text_values(item)
        return

    if isinstance(value, dict):
        for item in value.values():
            yield from iter_text_values(item)


def tokenize_query(query: str) -> list[str]:
    return re.findall(r"[a-z0-9_+\-]+", query.lower())


def get_allowed_estimators(payload: dict[str, Any]) -> set[str]:
    policy = payload.get("estimator_policy", {})
    estimators = policy.get("allowed_estimators", [])
    if not isinstance(estimators, list):
        return set()
    return {str(item) for item in estimators}


def collect_records(
    payload: dict[str, Any], record_types: list[str] | None = None
) -> list[tuple[str, dict[str, Any]]]:
    requested = set(record_types or ["dataset", "paper", "warehouse", "source"])
    if "source" in requested:
        requested.add("warehouse")
    records: list[tuple[str, dict[str, Any]]] = []

    for key, record_type in (
        ("datasets", "dataset"),
        ("papers", "paper"),
        ("warehouses", "warehouse"),
    ):
        if record_type not in requested:
            continue
        entries = payload.get(key, [])
        if isinstance(entries, list):
            for row in entries:
                if isinstance(row, dict):
                    records.append((record_type, row))

    return records


def compute_text_match_score(row: dict[str, Any], tokens: list[str]) -> float:
    if not tokens:
        return 0.0

    haystack = " ".join(iter_text_values(row)).lower()
    score = 0.0
    for token in tokens:
        if token in haystack:
            score += 1.0
    return score


def compute_metadata_richness(row: dict[str, Any]) -> float:
    content = row.get("content_metadata", {})
    access = row.get("access_metadata", {})
    traceability = row.get("traceability", {})
    source_access = row.get("source_access", {})
    methodology = row.get("methodological_selection", {})
    identity = row.get("identity", {})

    score = 0.0
    score += min(len(content.get("variables", [])), 8) * 0.35
    score += min(len(content.get("classification_systems", [])), 6) * 0.4
    score += min(len(content.get("use_cases", [])), 4) * 0.3

    warehouses = source_access.get("warehouses", [])
    score += min(len(warehouses), 3) * 0.4
    for warehouse in warehouses:
        if isinstance(warehouse, dict):
            score += min(len(warehouse.get("discovery_layers", [])), 4) * 0.25

    if access.get("license_metadata"):
        score += 0.8
    if access.get("reproducibility_notes"):
        score += 0.8
    if access.get("access_conditions"):
        score += 0.5
    if identity.get("dataset_doi"):
        score += 1.0
    if identity.get("publication_doi"):
        score += 1.0
    if traceability.get("linked_papers"):
        score += 0.8
    if traceability.get("linked_datasets"):
        score += 0.5
    if methodology.get("selection_criteria"):
        score += 0.4

    return round(score, 2)


def compute_spatial_signal(row: dict[str, Any]) -> float:
    spatiotemporal = row.get("spatiotemporal", {})
    text = " ".join(
        [
            str(spatiotemporal.get("data_type", "")),
            str(spatiotemporal.get("structure", "")),
            str(spatiotemporal.get("spatial_support", "")),
            str(spatiotemporal.get("spatial_resolution", "")),
            str(spatiotemporal.get("spatial_extent", "")),
            str(spatiotemporal.get("temporal_resolution", "")),
            str(spatiotemporal.get("time_range", "")),
        ]
    ).lower()

    score = 0.0
    for term, bonus in (
        ("coordinate", 2.5),
        ("parcel", 2.0),
        ("iris", 1.8),
        ("commune", 1.8),
        ("event", 1.5),
        ("bilateral", 1.5),
        ("country-pair", 1.5),
        ("monthly", 1.0),
        ("daily", 1.0),
        ("annual", 0.6),
        ("panel", 0.8),
        ("spatio", 1.0),
        ("territorial", 1.0),
    ):
        if term in text:
            score += bonus

    if spatiotemporal.get("temporal_resolution"):
        score += 0.5
    if spatiotemporal.get("time_range"):
        score += 0.5

    return round(score, 2)


def compute_license_signal(row: dict[str, Any]) -> float:
    access = row.get("access_metadata", {})
    license_metadata = access.get("license_metadata", {})
    explicit_license_present = bool(license_metadata.get("explicit_license_present"))
    category = str(license_metadata.get("category", "")).lower()
    is_open = license_metadata.get("is_open")
    allows_reuse = license_metadata.get("allows_reuse")

    score = 0.0
    if not explicit_license_present:
        return 0.0

    if category == "open":
        score += 2.0
    elif category == "reusable_with_conditions":
        score += 1.0
    elif category == "restricted":
        score -= 1.0

    if is_open is True:
        score += 1.0
    elif is_open is False:
        score -= 0.5

    if allows_reuse is True:
        score += 1.0
    elif allows_reuse is False:
        score -= 1.0

    return round(score, 2)


def get_dataset_linked_papers(
    row: dict[str, Any], payload: dict[str, Any]
) -> list[str]:
    dataset_id = row.get("dataset_id")
    direct_links = row.get("traceability", {}).get("linked_papers", [])
    linked: list[str] = []

    if isinstance(direct_links, list):
        linked.extend(str(item) for item in direct_links)

    for paper in payload.get("papers", []):
        if not isinstance(paper, dict):
            continue
        traceability = paper.get("traceability", {})
        linked_datasets = traceability.get("linked_datasets", [])
        if dataset_id and isinstance(linked_datasets, list) and dataset_id in linked_datasets:
            paper_id = paper.get("paper_id") or paper.get("identity", {}).get("title")
            if paper_id:
                linked.append(str(paper_id))

    return sorted(set(linked))


def compute_traceability_signal(row: dict[str, Any], payload: dict[str, Any]) -> float:
    identity = row.get("identity", {})
    traceability = row.get("traceability", {})
    linked_papers = get_dataset_linked_papers(row, payload)

    score = 0.0
    if identity.get("dataset_doi"):
        score += 2.0
    if identity.get("publication_doi"):
        score += 2.0
    if linked_papers:
        score += 2.0
    if traceability.get("linked_datasets"):
        score += 1.0

    for paper in payload.get("papers", []):
        if not isinstance(paper, dict):
            continue
        paper_id = paper.get("paper_id") or paper.get("identity", {}).get("title")
        if paper_id in linked_papers:
            metadata = paper.get("paper_metadata", {})
            if metadata.get("has_published_data"):
                score += 1.5
            if metadata.get("has_dataset_doi"):
                score += 1.0

    return round(score, 2)


def score_dataset(
    row: dict[str, Any], tokens: list[str], payload: dict[str, Any]
) -> tuple[float, dict[str, float]]:
    text_score = compute_text_match_score(row, tokens)
    metadata_score = compute_metadata_richness(row)
    spatial_score = compute_spatial_signal(row)
    license_score = compute_license_signal(row)
    traceability_score = compute_traceability_signal(row, payload)

    token_set = set(tokens)
    score = text_score

    # Baseline prioritization, even for generic discovery.
    score += metadata_score * 0.25
    score += spatial_score * 0.2
    score += license_score * 0.1
    score += traceability_score * 0.1

    if token_set & SPATIAL_TERMS:
        score += spatial_score * 0.8
    if token_set & METADATA_TERMS:
        score += metadata_score * 0.8
    if token_set & LICENSE_TERMS:
        score += license_score * 1.2
        if license_score <= 0:
            score -= 1.0
    if token_set & PAPER_TERMS:
        score += traceability_score * 1.2
        if traceability_score <= 0:
            score -= 2.5

    return round(score, 3), {
        "text": round(text_score, 2),
        "metadata": metadata_score,
        "spatial": spatial_score,
        "license": license_score,
        "traceability": traceability_score,
    }


def summarize_dataset(
    row: dict[str, Any],
    score: float,
    score_breakdown: dict[str, float],
    payload: dict[str, Any],
) -> dict[str, Any]:
    identity = row.get("identity", {})
    source_access = row.get("source_access", {})
    content_metadata = row.get("content_metadata", {})
    spatiotemporal = row.get("spatiotemporal", {})
    access_metadata = row.get("access_metadata", {})
    methodology = row.get("methodological_selection", {})
    traceability = row.get("traceability", {})

    warehouses = source_access.get("warehouses", [])
    warehouse_names = [
        warehouse.get("name")
        for warehouse in warehouses
        if isinstance(warehouse, dict) and warehouse.get("name")
    ]
    warehouse_types = [
        warehouse.get("warehouse_type")
        for warehouse in warehouses
        if isinstance(warehouse, dict) and warehouse.get("warehouse_type")
    ]

    discovery_layers = []
    for warehouse in warehouses:
        if not isinstance(warehouse, dict):
            continue
        for layer in warehouse.get("discovery_layers", []):
            if isinstance(layer, dict):
                layer_name = layer.get("name") or layer.get("layer_type")
                if layer_name:
                    discovery_layers.append(layer_name)

    variable_names = []
    for variable in content_metadata.get("variables", []):
        if isinstance(variable, dict):
            name = variable.get("name")
            if name:
                variable_names.append(name)
        elif isinstance(variable, str):
            variable_names.append(variable)

    license_metadata = access_metadata.get("license_metadata", {})
    linked_papers = get_dataset_linked_papers(row, payload)
    estimator_allowlist = get_allowed_estimators(payload)
    candidate_estimators = []
    for estimator in methodology.get("candidate_estimators", []):
        if not isinstance(estimator, dict):
            continue
        name = estimator.get("name")
        if name in estimator_allowlist:
            candidate_estimators.append(
                {
                    "name": name,
                    "plausible": estimator.get("plausible"),
                    "justification": estimator.get("justification"),
                    "evidence_basis": estimator.get("evidence_basis"),
                }
            )

    return {
        "record_type": "dataset",
        "score": score,
        "score_breakdown": score_breakdown,
        "dataset_id": row.get("dataset_id"),
        "title": identity.get("title"),
        "source": warehouse_names,
        "warehouse_types": warehouse_types,
        "discovery_layers": discovery_layers,
        "description": identity.get("description"),
        "variables": variable_names,
        "geography": spatiotemporal.get("spatial_extent"),
        "period": spatiotemporal.get("time_range"),
        "explicit_license_present": license_metadata.get("explicit_license_present"),
        "license_exact_name": license_metadata.get("exact_name"),
        "license_category": license_metadata.get("category"),
        "license_is_open": license_metadata.get("is_open"),
        "license_allows_reuse": license_metadata.get("allows_reuse"),
        "dataset_doi": identity.get("dataset_doi"),
        "publication_doi": identity.get("publication_doi"),
        "linked_papers": linked_papers,
        "linked_datasets": traceability.get("linked_datasets", []),
        "metadata_richness": score_breakdown["metadata"],
        "spatial_signal": score_breakdown["spatial"],
        "license_signal": score_breakdown["license"],
        "traceability_signal": score_breakdown["traceability"],
        "estimator_assessment_status": methodology.get("estimator_assessment_status"),
        "at_least_one_allowed_estimator_plausible": methodology.get(
            "at_least_one_allowed_estimator_plausible"
        ),
        "candidate_estimators": candidate_estimators,
        "estimator_policy_ref": methodology.get("estimator_policy_ref"),
        "use_cases": content_metadata.get("use_cases", []),
        "recommended_when": methodology.get("recommended_when", []),
        "access_conditions": access_metadata.get("access_conditions"),
    }


def summarize_paper(row: dict[str, Any], score: float) -> dict[str, Any]:
    identity = row.get("identity", {})
    metadata = row.get("paper_metadata", {})
    traceability = row.get("traceability", {})
    return {
        "record_type": "paper",
        "score": score,
        "paper_id": row.get("paper_id"),
        "title": identity.get("title"),
        "publication_doi": identity.get("publication_doi"),
        "has_published_data": metadata.get("has_published_data"),
        "has_dataset_doi": metadata.get("has_dataset_doi"),
        "linked_datasets": traceability.get("linked_datasets", []),
    }


def summarize_warehouse(row: dict[str, Any], score: float) -> dict[str, Any]:
    identity = row.get("identity", {})
    metadata = row.get("warehouse_metadata", {})
    return {
        "record_type": "warehouse",
        "score": score,
        "warehouse_id": row.get("warehouse_id"),
        "title": identity.get("title"),
        "description": identity.get("description"),
        "warehouse_type": metadata.get("warehouse_type"),
        "provider": metadata.get("provider"),
        "scope": metadata.get("scope"),
        "access_modes": metadata.get("access_modes", []),
        "source_family": "warehouse",
        "wiki_page": identity.get("wiki_page"),
    }


@mcp.tool()
def search_catalog(
    query: str, top_k: int = 5, record_types: list[str] | None = None
) -> list[dict[str, Any]]:
    """
    Search the local registry across dataset, paper, and source records.
    Ranking combines text relevance with spatial/spatio-temporal structure,
    metadata richness, license reusability, and DOI/paper traceability signals.
    """
    payload = load_catalog_payload()
    tokens = tokenize_query(query.strip())
    records = collect_records(payload, record_types)

    scored: list[dict[str, Any]] = []
    for record_type, row in records:
        text_score = compute_text_match_score(row, tokens)
        if record_type == "dataset":
            total_score, score_breakdown = score_dataset(row, tokens, payload)
            if total_score > 0:
                scored.append(summarize_dataset(row, total_score, score_breakdown, payload))
        elif text_score > 0:
            if record_type == "paper":
                scored.append(summarize_paper(row, round(text_score, 3)))
            elif record_type == "warehouse":
                scored.append(summarize_warehouse(row, round(text_score, 3)))

    scored.sort(key=lambda x: x["score"], reverse=True)
    return scored[:top_k]


@mcp.tool()
def search_datasets(query: str, top_k: int = 5) -> list[dict[str, Any]]:
    """
    Search relevant datasets in the local registry. Ranking combines text
    relevance with spatial/spatio-temporal structure, metadata richness,
    license reusability, and DOI or paper-link traceability signals.
    """
    return search_catalog(query=query, top_k=top_k, record_types=["dataset"])


if __name__ == "__main__":
    try:
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
