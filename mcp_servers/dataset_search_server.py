from typing import Any, Iterable
import json
from pathlib import Path
import re
import sys
import traceback

from mcp.server.fastmcp import FastMCP

mcp = FastMCP("dataset-search")

PROJECT_ROOT = Path(__file__).parent.parent
CATALOG_PATH = PROJECT_ROOT / "data" / "catalogue_datasets.json"

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


REQUIRED_DATASET_FIELDS = {
    "dataset_id": "Dataset id is required.",
    "identity.title": "Dataset title is required.",
    "identity.description": "Dataset description is required.",
    "source_access.warehouses": "At least one source warehouse or portal is required.",
    "source_access.access_route": "At least one source URL, local manifest, or discovery layer URL is required.",
    "content_metadata.variables": "Candidate or documented variables are required.",
    "spatiotemporal.data_type": "Spatial or spatio-temporal data type is required.",
    "spatiotemporal.structure": "Dataset structure is required.",
    "spatiotemporal.spatial_extent": "Spatial coverage is required.",
    "spatiotemporal.spatial_resolution": "Spatial resolution is required.",
    "spatiotemporal.temporal_resolution": "Temporal resolution is required.",
    "spatiotemporal.time_range": "Temporal coverage is required.",
    "license_metadata": "License metadata is required.",
    "quality_pedigree.review_status": "Quality review status is required.",
    "quality_pedigree.human_review_required": "Human review flag is required.",
}

RECOMMENDED_DATASET_FIELDS = {
    "identity.dataset_doi": "Dataset DOI is recommended when available.",
    "identity.publication_doi": "Publication DOI is recommended when available.",
    "traceability.linked_papers": "Linked papers improve traceability.",
    "traceability.linked_datasets": "Linked datasets improve cross-catalog traceability.",
    "access_metadata.reproducibility_notes": "Reproducibility notes help downstream reuse.",
    "access_metadata.access_conditions": "Access conditions should be explicit.",
    "content_metadata.classification_systems": "Classification systems help interpret variables.",
    "content_metadata.use_cases": "Use cases help prioritize analytical reuse.",
    "methodological_selection.selection_criteria": "Selection criteria document why the dataset belongs in the bank.",
    "methodological_selection.candidate_estimators": "Candidate estimators document modeling readiness.",
    "spatiotemporal.n_observations": "N observations is recommended when available.",
    "spatiotemporal.t_periods": "Number of time periods is recommended when available.",
    "quality_pedigree.provenance": "Quality provenance is recommended.",
    "quality_pedigree.provenance_score": "Quality provenance score is recommended.",
    "quality_pedigree.evidence_score": "Quality evidence score is recommended.",
    "quality_pedigree.coherence_score": "Quality coherence score is recommended.",
}

MISSING_SENTINELS = {
    "",
    "unknown",
    "unknown_not_found",
    "unknown_pending_curation",
    "not_available",
    "not applicable",
    "not_applicable",
    "pending",
    "to_review",
    "tbd",
    "todo",
    "none",
    "null",
}


def is_missing_value(value: Any) -> bool:
    """Détecte les valeurs absentes ou peu exploitables dans le catalogue."""
    if value is None:
        return True
    if isinstance(value, str):
        return value.strip().lower() in MISSING_SENTINELS
    if isinstance(value, (list, tuple, set)):
        return len(value) == 0 or all(is_missing_value(item) for item in value)
    if isinstance(value, dict):
        return len(value) == 0 or all(is_missing_value(item) for item in value.values())
    return False


def nested_get(row: dict[str, Any], path: str) -> Any:
    """Lit un champ imbriqué avec une notation par points, par exemple identity.title."""
    current: Any = row
    for part in path.split("."):
        if not isinstance(current, dict) or part not in current:
            return None
        current = current[part]
    return current


def has_source_access_route(row: dict[str, Any]) -> bool:
    """Vérifie qu'un dataset possède au moins une route d'accès stable ou documentée."""
    source_access = row.get("source_access", {})
    if not isinstance(source_access, dict):
        return False
    if not is_missing_value(source_access.get("local_manifest")):
        return True
    for warehouse in source_access.get("warehouses", []):
        if not isinstance(warehouse, dict):
            continue
        if not is_missing_value(warehouse.get("url")):
            return True
        for layer in warehouse.get("discovery_layers", []):
            if isinstance(layer, dict) and not is_missing_value(layer.get("url")):
                return True
    return False


def get_variables_value(row: dict[str, Any]) -> list[Any]:
    """Retourne les variables documentées, avec repli sur candidate_y/candidate_x."""
    content = row.get("content_metadata", {})
    if not isinstance(content, dict):
        return []
    variables = content.get("variables")
    if not is_missing_value(variables):
        return variables if isinstance(variables, list) else [variables]
    candidates: list[Any] = []
    for key in ("candidate_y", "candidate_x"):
        value = content.get(key)
        if isinstance(value, list):
            candidates.extend(value)
        elif not is_missing_value(value):
            candidates.append(value)
    return candidates


def get_license_metadata(row: dict[str, Any]) -> Any:
    """Retourne les métadonnées de licence, quel que soit le schéma déjà utilisé."""
    access_metadata = row.get("access_metadata", {})
    if isinstance(access_metadata, dict) and not is_missing_value(access_metadata.get("license_metadata")):
        return access_metadata.get("license_metadata")
    return row.get("license_metadata")


def dataset_field_value(row: dict[str, Any], field: str, payload: dict[str, Any]) -> Any:
    """Normalise la lecture des champs spéciaux utilisés par la validation."""
    if field == "source_access.access_route":
        return has_source_access_route(row)
    if field == "content_metadata.variables":
        return get_variables_value(row)
    if field == "license_metadata":
        return get_license_metadata(row)
    if field == "traceability.linked_papers":
        return get_dataset_linked_papers(row, payload)
    return nested_get(row, field)


def find_dataset_record(payload: dict[str, Any], dataset_id: str) -> dict[str, Any] | None:
    """Cherche un record dataset par identifiant dans le catalogue chargé."""
    for row in payload.get("datasets", []):
        if isinstance(row, dict) and row.get("dataset_id") == dataset_id:
            return row
    return None


def missing_fields(
    row: dict[str, Any],
    payload: dict[str, Any],
    field_messages: dict[str, str],
) -> list[str]:
    """Liste les champs manquants parmi un groupe de règles de validation."""
    missing: list[str] = []
    for field in field_messages:
        value = dataset_field_value(row, field, payload)
        if value is False or is_missing_value(value):
            missing.append(field)
    return missing


def validation_priority(missing_required: list[str], missing_recommended: list[str], score: float) -> str:
    """Classe la priorité de curation selon les manques et le score de complétude."""
    if len(missing_required) >= 4 or score < 0.55:
        return "high"
    if missing_required or len(missing_recommended) >= 5 or score < 0.8:
        return "medium"
    return "low"


def validation_status(missing_required: list[str], score: float) -> tuple[bool, str]:
    """Transforme les manques en verdict MCP: pass, review ou fail."""
    if len(missing_required) >= 4 or score < 0.55:
        return False, "fail"
    if missing_required or score < 0.85:
        return False, "review"
    return True, "pass"


def build_next_actions(missing_required: list[str], missing_recommended: list[str]) -> list[str]:
    """Construit une courte liste d'actions concrètes pour compléter la fiche."""
    actions = []
    action_map = {
        "identity.description": "Add a concise dataset description.",
        "source_access.warehouses": "Add the source warehouse or portal.",
        "source_access.access_route": "Add a stable URL, local manifest, or API discovery route.",
        "content_metadata.variables": "Add candidate or documented variables.",
        "spatiotemporal.data_type": "Classify the dataset as spatial or spatio-temporal.",
        "spatiotemporal.structure": "Add the data structure: panel, cross-section, event data, etc.",
        "spatiotemporal.spatial_extent": "Add spatial coverage.",
        "spatiotemporal.spatial_resolution": "Add spatial resolution.",
        "spatiotemporal.temporal_resolution": "Add temporal resolution.",
        "spatiotemporal.time_range": "Add temporal coverage.",
        "license_metadata": "Add license evidence and reuse classification.",
        "quality_pedigree.review_status": "Add quality review status.",
        "quality_pedigree.human_review_required": "Add the human review flag.",
        "identity.dataset_doi": "Check whether a dataset DOI exists.",
        "identity.publication_doi": "Check whether a related publication DOI exists.",
        "traceability.linked_papers": "Record linked papers or state that none were found.",
        "access_metadata.reproducibility_notes": "Add reproducibility notes.",
        "spatiotemporal.n_observations": "Add N observations if available.",
        "spatiotemporal.t_periods": "Add the number of time periods if available.",
    }
    for field in [*missing_required, *missing_recommended]:
        action = action_map.get(field)
        if action and action not in actions:
            actions.append(action)
    return actions[:10]


def validate_dataset_row(row: dict[str, Any], payload: dict[str, Any]) -> dict[str, Any]:
    """Valide un record dataset déjà chargé et calcule son statut de complétude."""
    identity = row.get("identity", {}) if isinstance(row.get("identity"), dict) else {}
    missing_required = missing_fields(row, payload, REQUIRED_DATASET_FIELDS)
    missing_recommended = missing_fields(row, payload, RECOMMENDED_DATASET_FIELDS)
    total_fields = len(REQUIRED_DATASET_FIELDS) + len(RECOMMENDED_DATASET_FIELDS)
    weighted_missing = len(missing_required) * 2 + len(missing_recommended)
    weighted_total = len(REQUIRED_DATASET_FIELDS) * 2 + len(RECOMMENDED_DATASET_FIELDS)
    completeness_score = round(max(0.0, 1.0 - weighted_missing / weighted_total), 2)
    valid, status = validation_status(missing_required, completeness_score)

    errors = [
        {"field": field, "message": REQUIRED_DATASET_FIELDS[field]}
        for field in missing_required
    ]
    warnings = [
        {"field": field, "message": RECOMMENDED_DATASET_FIELDS[field]}
        for field in missing_recommended
    ]

    return {
        "dataset_id": row.get("dataset_id"),
        "title": identity.get("title"),
        "valid": valid,
        "status": status,
        "score": completeness_score,
        "completeness_score": completeness_score,
        "priority": validation_priority(missing_required, missing_recommended, completeness_score),
        "missing_required": missing_required,
        "missing_recommended": missing_recommended,
        "errors": errors,
        "warnings": warnings,
        "metadata_richness": compute_metadata_richness(row),
        "spatial_signal": compute_spatial_signal(row),
        "license_signal": compute_license_signal(row),
        "traceability_signal": compute_traceability_signal(row, payload),
        "next_actions": build_next_actions(missing_required, missing_recommended),
        "field_counts": {
            "required_missing": len(missing_required),
            "recommended_missing": len(missing_recommended),
            "total_checked": total_fields,
        },
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


@mcp.tool()
def validate_dataset_record(dataset_id: str) -> dict[str, Any]:
    """
    Valide un dataset précis et retourne un verdict pass/review/fail.
    Le contrôle couvre l'identité, la source, les variables, la structure
    spatio-temporelle, la licence, la traçabilité et la qualité.
    """
    payload = load_catalog_payload()
    row = find_dataset_record(payload, dataset_id)
    if row is None:
        return {
            "dataset_id": dataset_id,
            "valid": False,
            "status": "fail",
            "score": 0.0,
            "errors": [
                {
                    "field": "dataset_id",
                    "message": "Dataset id not found in catalogue_datasets.json.",
                }
            ],
            "warnings": [],
            "next_actions": ["Add the dataset record to data/catalogue_datasets.json or check the dataset_id."],
        }
    return validate_dataset_row(row, payload)


@mcp.tool()
def list_missing_metadata(top_k: int = 50, include_pass: bool = False) -> list[dict[str, Any]]:
    """
    Audite tous les datasets et liste ceux qui ont des métadonnées manquantes.
    Sert à prioriser la curation du catalogue et à repérer les datasets pas encore
    prêts pour une analyse spatiale ou spatio-temporelle.
    """
    payload = load_catalog_payload()
    audit_rows: list[dict[str, Any]] = []
    for row in payload.get("datasets", []):
        if not isinstance(row, dict):
            continue
        validation = validate_dataset_row(row, payload)
        if include_pass or validation["missing_required"] or validation["missing_recommended"]:
            audit_rows.append(
                {
                    "dataset_id": validation["dataset_id"],
                    "title": validation["title"],
                    "missing_required": validation["missing_required"],
                    "missing_recommended": validation["missing_recommended"],
                    "completeness_score": validation["completeness_score"],
                    "priority": validation["priority"],
                    "status": validation["status"],
                    "metadata_richness": validation["metadata_richness"],
                    "next_actions": validation["next_actions"],
                }
            )

    priority_rank = {"high": 0, "medium": 1, "low": 2}
    audit_rows.sort(
        key=lambda item: (
            priority_rank.get(str(item["priority"]), 9),
            item["completeness_score"],
            item["dataset_id"] or "",
        )
    )
    return audit_rows[:top_k]


if __name__ == "__main__":
    try:
        mcp.run(transport="stdio")
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        traceback.print_exc(file=sys.stderr)
        raise
