"""Lecture des audits de preuves issus des TEI.

Ce module fournit une petite couche commune pour les scripts KG aval. L'audit
reste une source de candidats : il aide a orienter la curation, mais ne valide
pas automatiquement une formule, un dataset ou un estimateur.
"""

from __future__ import annotations

import csv
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
AUDIT_CSV = ROOT / "data" / "manifests" / "papers" / "model_evidence_audit.csv"


def slug(value: str) -> str:
    """Transforme un texte en fragment stable d'identifiant KG."""
    value = (value or "").lower()
    value = re.sub(r"[^a-z0-9]+", "_", value)
    return value.strip("_") or "unknown"


def parse_int(value: str | int | None, default: int = 0) -> int:
    """Convertit les scores CSV en entiers robustes."""
    if isinstance(value, int):
        return value
    try:
        return int(float(value or default))
    except ValueError:
        return default


def read_model_evidence_audit(path: Path = AUDIT_CSV) -> list[dict[str, Any]]:
    """Lit l'audit de lecture dirigee si disponible."""
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as fh:
        rows = list(csv.DictReader(fh, delimiter=";"))
    for row in rows:
        row["priority_score_int"] = parse_int(row.get("priority_score"))
    return rows


def audit_candidate_kind(row: dict[str, Any]) -> str:
    """Classe une ligne d'audit en type de candidat KG."""
    reason = row.get("audit_reason") or ""
    section_role = row.get("section_role") or ""
    formula_type = row.get("formula_type") or ""

    if reason == "raw_grobid_formula" or formula_type:
        if formula_type == "generic_estimator_formula":
            return "GenericEstimatorFormulaCandidate"
        return "FormulaCandidate"
    if section_role == "variable_tables":
        return "VariableTableCandidate"
    if section_role == "model_tables":
        return "ModelTableCandidate"
    if section_role == "data_source":
        return "DataSourceCandidate"
    if section_role in {"empirical_model", "preprocessing", "results_model"}:
        return "ModelEvidenceCandidate"
    return "AuditCandidate"


def validation_status(row: dict[str, Any]) -> str:
    """Attribue un statut conservateur aux candidats extraits automatiquement."""
    kind = audit_candidate_kind(row)
    if kind == "GenericEstimatorFormulaCandidate":
        return "rejected_generic_formula"
    if row.get("audit_reason") == "formula_candidate_blocked":
        return "blocked_needs_manual_review"
    return "extracted_needs_review"


def confidence_from_audit(row: dict[str, Any]) -> float:
    """Transforme le score de priorite en confiance indicative non validante."""
    score = parse_int(row.get("priority_score"))
    kind = audit_candidate_kind(row)
    base = min(0.85, max(0.2, score / 100))
    if kind == "GenericEstimatorFormulaCandidate":
        return 0.15
    if kind in {"VariableTableCandidate", "ModelTableCandidate"}:
        return max(base, 0.55)
    if kind in {"FormulaCandidate", "ModelEvidenceCandidate"}:
        return max(base, 0.45)
    return base
