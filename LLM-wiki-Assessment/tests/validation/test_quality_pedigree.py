"""Tests deterministes de la matrice de controle qualite homme-LLM."""

from __future__ import annotations

from typing import Any


SCORE_FIELDS = (
    "provenance_score",
    "rigour_score",
    "evidence_score",
    "coherence_score",
    "claim_discipline_score",
)

EVIDENCE_FIELDS = (
    "provenance_evidence",
    "rigour_evidence",
    "evidence_evidence",
    "coherence_evidence",
    "claim_discipline_evidence",
)

REVIEW_STATUSES = {"pending", "needs_revision", "reviewed", "rejected"}
DELTA1_RISKS = {"low", "medium", "high", "not_applicable"}
CITATION_SOURCES = {"openalex", "datacite", "crossref", "manual_review", "none", "unknown"}
CITATION_INTERPRETATIONS = {
    "not_applicable",
    "not_checked",
    "no_signal",
    "weak_signal",
    "moderate_signal",
    "strong_signal",
    "very_strong_signal",
    "ambiguous",
}


def _records_requiring_quality_pedigree(catalog: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    """Retourne les records du catalogue qui doivent porter la matrice qualite."""

    records: list[tuple[str, dict[str, Any]]] = []
    for group_name in ("datasets", "papers", "warehouses"):
        for index, record in enumerate(catalog.get(group_name, [])):
            if isinstance(record, dict):
                label = str(
                    record.get("dataset_id")
                    or record.get("paper_id")
                    or record.get("warehouse_id")
                    or f"{group_name}[{index}]"
                )
                records.append((label, record))
    return records


def test_catalog_records_have_quality_pedigree(catalog):
    """Verifie que les records actifs ont un bloc quality_pedigree."""

    missing = [
        label
        for label, record in _records_requiring_quality_pedigree(catalog)
        if not isinstance(record.get("quality_pedigree"), dict)
    ]

    assert not missing, f"Records without quality_pedigree: {missing}"


def test_quality_pedigree_scores_and_evidence(catalog):
    """Verifie que chaque score est borne et justifie par une preuve textuelle."""

    failures: list[str] = []

    for label, record in _records_requiring_quality_pedigree(catalog):
        quality = record.get("quality_pedigree")
        if not isinstance(quality, dict):
            continue

        for field in SCORE_FIELDS:
            value = quality.get(field)
            if not isinstance(value, int) or not 1 <= value <= 5:
                failures.append(f"{label}: {field} must be an integer from 1 to 5")

        for field in EVIDENCE_FIELDS:
            value = quality.get(field)
            if not isinstance(value, str) or not value.strip():
                failures.append(f"{label}: {field} must contain a non-empty justification")

    assert not failures, "\n".join(failures)


def test_quality_pedigree_human_review_gate(catalog):
    """Verifie que le LLM ne marque pas seul une evaluation comme revue."""

    failures: list[str] = []

    for label, record in _records_requiring_quality_pedigree(catalog):
        quality = record.get("quality_pedigree")
        if not isinstance(quality, dict):
            continue

        status = quality.get("review_status")
        if status not in REVIEW_STATUSES:
            failures.append(f"{label}: invalid review_status {status!r}")

        delta1_risk = quality.get("delta1_risk")
        if delta1_risk not in DELTA1_RISKS:
            failures.append(f"{label}: invalid delta1_risk {delta1_risk!r}")

        proposed_by = quality.get("evaluator_proposed_by")
        human_required = quality.get("human_review_required")
        reviewer = quality.get("reviewer")

        if status == "reviewed" and not reviewer:
            failures.append(f"{label}: reviewed records must identify the human reviewer")

        if proposed_by == "llm" and status == "reviewed" and human_required is not False and not reviewer:
            failures.append(f"{label}: LLM-proposed evaluations require human reviewer before reviewed status")

        if proposed_by == "llm" and status == "pending" and human_required is not True:
            failures.append(f"{label}: pending LLM evaluations must set human_review_required=true")

    assert not failures, "\n".join(failures)


def test_quality_pedigree_schema_is_registered(catalog):
    """Verifie que la politique catalogue pointe vers le schema qualite."""

    policy = catalog.get("catalog_policy", {}).get("quality_pedigree_policy")
    assert isinstance(policy, dict), "catalog_policy.quality_pedigree_policy is missing"
    assert policy.get("schema") == "wiki/metadata/quality_pedigree_schema_v1.md"
    assert policy.get("llm_may_propose_scores") is True
    assert policy.get("human_review_required_for_reviewed_status") is True


def test_quality_pedigree_citation_metrics(catalog):
    """Verifie que les citations sont tracees comme signal documente, pas comme score nu."""

    failures: list[str] = []

    for label, record in _records_requiring_quality_pedigree(catalog):
        quality = record.get("quality_pedigree")
        if not isinstance(quality, dict):
            continue

        metrics = quality.get("citation_metrics")
        if metrics is None:
            continue
        if not isinstance(metrics, dict):
            failures.append(f"{label}: citation_metrics must be an object when present")
            continue

        source = metrics.get("citation_source")
        if source not in CITATION_SOURCES:
            failures.append(f"{label}: invalid citation_source {source!r}")

        interpretation = metrics.get("citation_interpretation")
        if interpretation not in CITATION_INTERPRETATIONS:
            failures.append(f"{label}: invalid citation_interpretation {interpretation!r}")

        evidence = metrics.get("citation_evidence")
        if not isinstance(evidence, str) or not evidence.strip():
            failures.append(f"{label}: citation_evidence must explain the citation signal")

        checked_at = metrics.get("citation_checked_at")
        has_count = any(
            isinstance(metrics.get(field), int)
            for field in ("dataset_citation_count", "paper_citation_count")
        )
        if has_count and not checked_at:
            failures.append(f"{label}: citation_checked_at is required when a citation count is recorded")

        for field in ("dataset_citation_count", "paper_citation_count"):
            value = metrics.get(field)
            if value is not None and (not isinstance(value, int) or value < 0):
                failures.append(f"{label}: {field} must be null or a non-negative integer")

        if source in {"openalex", "datacite", "crossref", "manual_review"} and interpretation in {
            "not_applicable",
            "not_checked",
        }:
            failures.append(f"{label}: checked citation source needs an interpreted signal")

    assert not failures, "\n".join(failures)
