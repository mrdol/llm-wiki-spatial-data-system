"""Lecture dirigée des sections TEI pour l'extraction de preuves empiriques.

Ce module centralise les règles qui aident le KG à distinguer :
- les sections de données et de modèles empiriques ;
- les tableaux de variables ou de résultats ;
- les sections théoriques/simulation à ne pas promouvoir automatiquement comme
  formules appliquées à un dataset.
"""

from __future__ import annotations

import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
RULES_PATH = Path(__file__).with_name("section_role_rules.yml")


def norm_space(value: str) -> str:
    """Normalise les espaces sans modifier le contenu textuel utile."""
    return re.sub(r"\s+", " ", value or "").strip()


def _simple_yaml_rules(path: Path) -> dict[str, Any]:
    """Charge le YAML de règles avec PyYAML si disponible.

    Le projet n'ajoute pas PyYAML comme dépendance dure : si la bibliothèque
    n'est pas installée, on retombe sur un dictionnaire embarqué minimal. Cela
    permet au pipeline KG de rester exécutable dans l'environnement actuel.
    """
    try:
        import yaml  # type: ignore

        return yaml.safe_load(path.read_text(encoding="utf-8")) or {}
    except Exception:
        return default_rules()


def default_rules() -> dict[str, Any]:
    """Retourne un jeu de règles minimal si le YAML ne peut pas être lu."""
    return {
        "high_priority_sections": {
            "data_source": {
                "score": 35,
                "title_patterns": ["data", "dataset", "study area", "case study", "materials"],
                "content_patterns": ["dataset", "obtained from", "available at", "coordinates", "shapefile"],
            },
            "preprocessing": {
                "score": 30,
                "title_patterns": ["preprocessing", "variable construction", "covariates"],
                "content_patterns": ["transformed", "log", "standardized", "missing", "covariates"],
            },
            "empirical_model": {
                "score": 40,
                "title_patterns": ["model specification", "empirical model", "methodology", "methods"],
                "content_patterns": ["dependent variable", "explanatory variables", "we estimate", "regression"],
            },
        },
        "table_patterns": {
            "variable_tables": {
                "score": 45,
                "caption_patterns": ["variables", "descriptive statistics", "summary statistics"],
            },
            "model_tables": {
                "score": 30,
                "caption_patterns": ["model results", "regression results", "rmse", "aic"],
            },
        },
        "low_priority_sections": {
            "generic_theory": {
                "penalty": 45,
                "title_patterns": ["theory", "asymptotic", "proof", "estimator"],
                "content_patterns": ["theorem", "proof", "asymptotic", "objective function"],
            },
            "simulation": {
                "penalty": 35,
                "title_patterns": ["simulation", "monte carlo"],
                "content_patterns": ["simulation", "monte carlo", "synthetic data"],
            },
        },
        "evidence_patterns": {
            "data_source": ["downloaded", "obtained from", "available at", "dataset", "repository"],
            "preprocessing": ["transformed", "normalized", "missing values", "selected"],
            "empirical_formula": ["dependent variable", "explanatory variables", "we estimate", "specification"],
            "generic_formula": ["theorem", "proof", "asymptotic", "estimator", "simulation"],
        },
    }


def load_rules(path: Path = RULES_PATH) -> dict[str, Any]:
    """Lit les règles de lecture dirigée."""
    if path.exists():
        return _simple_yaml_rules(path)
    return default_rules()


def pattern_hits(text: str, patterns: list[str]) -> list[str]:
    """Retourne les motifs trouvés dans un texte."""
    lowered = text.lower()
    hits = []
    for pattern in patterns:
        pattern_l = pattern.lower()
        if re.search(r"(?<![a-z0-9])" + re.escape(pattern_l) + r"(?![a-z0-9])", lowered):
            hits.append(pattern)
        elif pattern_l in lowered:
            hits.append(pattern)
    return hits


def score_section(title: str, text: str, rules: dict[str, Any] | None = None) -> dict[str, Any]:
    """Classe une section TEI selon son utilité empirique."""
    rules = rules or load_rules()
    title = norm_space(title)
    text = norm_space(text)
    title_l = title.lower()
    text_l = text.lower()
    roles: list[str] = []
    positive_hits: list[str] = []
    negative_hits: list[str] = []
    score = 0

    for role, cfg in (rules.get("high_priority_sections") or {}).items():
        title_hits = pattern_hits(title_l, cfg.get("title_patterns") or [])
        content_hits = pattern_hits(text_l[:5000], cfg.get("content_patterns") or [])
        if title_hits or content_hits:
            roles.append(role)
            score += int(cfg.get("score", 20))
            score += min(15, 3 * len(title_hits) + 2 * len(content_hits))
            positive_hits.extend([f"{role}:title:{hit}" for hit in title_hits])
            positive_hits.extend([f"{role}:content:{hit}" for hit in content_hits[:8]])

    low_roles: list[str] = []
    for role, cfg in (rules.get("low_priority_sections") or {}).items():
        title_hits = pattern_hits(title_l, cfg.get("title_patterns") or [])
        content_hits = pattern_hits(text_l[:5000], cfg.get("content_patterns") or [])
        if title_hits or content_hits:
            low_roles.append(role)
            score -= int(cfg.get("penalty", 20))
            negative_hits.extend([f"{role}:title:{hit}" for hit in title_hits])
            negative_hits.extend([f"{role}:content:{hit}" for hit in content_hits[:8]])

    if not roles and low_roles:
        primary_role = low_roles[0]
    elif roles:
        primary_role = roles[0]
    else:
        primary_role = "background"

    score = max(0, min(100, score))
    return {
        "section_role": primary_role,
        "section_roles": sorted(set(roles + low_roles)),
        "priority_score": score,
        "positive_hits": positive_hits,
        "negative_hits": negative_hits,
        "is_low_priority": bool(low_roles) and score < 35,
    }


def evidence_types(text: str, rules: dict[str, Any] | None = None) -> list[str]:
    """Identifie les types de preuves contenues dans un extrait."""
    rules = rules or load_rules()
    out = []
    for evidence_type, patterns in (rules.get("evidence_patterns") or {}).items():
        if pattern_hits(text, patterns or []):
            out.append(evidence_type)
    return out


def formula_type(section_score: dict[str, Any], candidate_text: str, rules: dict[str, Any] | None = None) -> str:
    """Classe une formule candidate comme empirique ou générique."""
    types = set(evidence_types(candidate_text, rules))
    roles = set(section_score.get("section_roles") or [])
    if "generic_formula" in types or roles.intersection({"generic_theory", "simulation"}):
        if not roles.intersection({"empirical_model", "data_source"}):
            return "generic_estimator_formula"
    if roles.intersection({"empirical_model", "data_source", "preprocessing", "results_model"}):
        return "empirical_model_candidate"
    return "formula_candidate_needs_review"


def should_attach_formula(section_score: dict[str, Any], candidate_text: str, rules: dict[str, Any] | None = None) -> bool:
    """Décide si une formule peut être rattachée automatiquement à un dataset."""
    ftype = formula_type(section_score, candidate_text, rules)
    if ftype == "generic_estimator_formula":
        return False
    return int(section_score.get("priority_score") or 0) >= 25


def score_table(caption: str, body: str, rules: dict[str, Any] | None = None) -> dict[str, Any]:
    """Classe un tableau TEI selon sa probabilité de décrire variables/résultats."""
    rules = rules or load_rules()
    caption_text = norm_space(caption)
    body_text = norm_space(body)
    roles = []
    hits = []
    score = 0
    for role, cfg in (rules.get("table_patterns") or {}).items():
        caption_hits = pattern_hits(caption_text.lower(), cfg.get("caption_patterns") or [])
        body_hits = pattern_hits(body_text.lower()[:3000], cfg.get("caption_patterns") or [])
        if caption_hits or body_hits:
            roles.append(role)
            hits.extend([f"{role}:caption:{hit}" for hit in caption_hits])
            hits.extend([f"{role}:body:{hit}" for hit in body_hits[:8]])
            score += int(cfg.get("score", 20)) + min(10, 2 * len(caption_hits) + len(body_hits))
    return {
        "table_role": roles[0] if roles else "table_other",
        "table_roles": sorted(set(roles)),
        "priority_score": max(0, min(100, score)),
        "positive_hits": hits,
        "caption": caption_text,
        "body_preview": body_text[:600],
    }
