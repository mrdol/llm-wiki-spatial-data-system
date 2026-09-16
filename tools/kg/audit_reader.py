"""Lecture des audits de preuves issus des TEI.

Ce module fournit une petite couche commune pour les scripts KG aval. L'audit
reste une source de candidats : il aide a orienter la curation, mais ne valide
pas automatiquement une formule, un dataset ou un estimateur.
"""

from __future__ import annotations

import csv
import hashlib
import json
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
AUDIT_CSV = ROOT / "data" / "manifests" / "papers" / "model_evidence_audit.csv"
LLM_DISAMBIGUATION_CACHE = ROOT / "data" / "manifests" / "papers" / "llm_candidate_disambiguation_cache.json"

# Seuils de l'action prioritaire "review_for_dataset_use"/"review_for_model_evidence"
# par type de candidat. Calibres sur l'echelle de score corrigee de
# section_role.py (voir tools/kg/10_make_audit_candidate_review.py pour le
# detail) : ils definissent aussi la "zone prioritaire" que le script de
# desambiguisation LLM (09b_llm_disambiguate_candidates.py) verifie en plus
# du filtre a mots-cles, puisque c'est la que les faux positifs restants
# (prose theorique bien notee) coutent le plus cher a un relecteur humain.
DATASET_USE_THRESHOLD_BY_KIND = {
    "DataSourceCandidate": 50,
    "VariableTableCandidate": 45,
}
MODEL_EVIDENCE_KINDS = {"FormulaCandidate", "ModelEvidenceCandidate", "ModelTableCandidate"}
MODEL_EVIDENCE_THRESHOLD = 55
LLM_THEORETICAL_DOWNGRADE_CONFIDENCE = 0.6


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


def is_priority_candidate(row: dict[str, Any]) -> bool:
    """Le candidat atteint-il deja une action prioritaire sur le seul score a mots-cles ?

    Utilise a la fois par le rapport de revue et par le script de
    desambiguisation LLM pour cibler exactement la meme "zone prioritaire".
    """
    kind = audit_candidate_kind(row)
    score = parse_int(row.get("priority_score_int", row.get("priority_score")))
    threshold = DATASET_USE_THRESHOLD_BY_KIND.get(kind)
    if threshold is not None and score >= threshold:
        return True
    if kind in MODEL_EVIDENCE_KINDS and score >= MODEL_EVIDENCE_THRESHOLD:
        return True
    return False


def candidate_key(row: dict[str, Any]) -> str:
    """Cle de cache stable pour un candidat (invalide si le texte change)."""
    text = (row.get("candidate_text") or row.get("table_caption") or "")[:400]
    raw = f"{row.get('paper_id')}|{row.get('section_id')}|{text}"
    return hashlib.sha256(raw.encode("utf-8")).hexdigest()[:24]


def load_llm_disambiguation_cache(path: Path = LLM_DISAMBIGUATION_CACHE) -> dict[str, Any]:
    """Lit le cache de verdicts LLM (theorique/empirique) s'il existe."""
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}


def llm_downgrade_reason(row: dict[str, Any], cache: dict[str, Any]) -> str | None:
    """Retourne la justification LLM si le candidat doit etre declasse, sinon None.

    Le LLM ne sert qu'a retirer des faux positifs de la zone prioritaire
    (verdict "theoretical" avec une confiance suffisante) ; il ne peut pas
    promouvoir un candidat que le score a mots-cles n'a pas deja retenu.
    """
    entry = cache.get(candidate_key(row))
    if not entry:
        return None
    if entry.get("verdict") == "theoretical" and float(entry.get("confidence") or 0.0) >= LLM_THEORETICAL_DOWNGRADE_CONFIDENCE:
        return str(entry.get("reasoning") or "")
    return None


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
