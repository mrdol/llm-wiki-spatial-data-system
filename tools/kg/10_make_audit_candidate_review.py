"""Generer un rapport de revue des candidats issus de l'audit TEI.

Le rapport sert de sas de curation entre :
- les signaux automatiques extraits des TEI ;
- les vrais usages papier-dataset et formules confirmees ;
- les futures fiches datasets.
"""

from __future__ import annotations

import argparse
import sys
from collections import Counter, defaultdict
from datetime import date
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from audit_reader import (
    DATASET_USE_THRESHOLD_BY_KIND,
    MODEL_EVIDENCE_KINDS,
    MODEL_EVIDENCE_THRESHOLD,
    audit_candidate_kind,
    candidate_key,
    confidence_from_audit,
    llm_downgrade_reason,
    load_llm_disambiguation_cache,
    read_model_evidence_audit,
    validation_status,
)


REPORT_PATH = ROOT / "wiki" / "analyses" / "model_evidence_candidates_review_2026-08.md"
MAX_CANDIDATES_PER_PAPER = 12
REPORT_CREATED = "2026-08-06"


def clean_cell(value: Any, limit: int = 260) -> str:
    """Nettoie un champ pour une cellule Markdown."""
    text = str(value or "").replace("\n", " ").replace("\r", " ")
    text = " ".join(text.split())
    text = text.replace("|", "/")
    if len(text) > limit:
        return text[: limit - 3].rstrip() + "..."
    return text


def paper_key(row: dict[str, Any]) -> str:
    """Retourne une cle lisible pour grouper les candidats par papier."""
    return row.get("paper_title") or row.get("paper_id") or row.get("tei_file") or "unknown"


def review_action(row: dict[str, Any], llm_cache: dict[str, Any] | None = None) -> str:
    """Propose une action de curation non automatique.

    Quand `llm_cache` est fourni (voir `09b_llm_disambiguate_candidates.py`),
    un candidat qui atteindrait une action prioritaire sur le seul score a
    mots-cles est declasse en `low_priority_review` si Claude a juge
    l'extrait "theoretical" avec suffisamment de confiance. Le LLM ne peut
    que retirer des faux positifs de la zone prioritaire, jamais en ajouter :
    le filtre a mots-cles reste le seul a decider quels candidats entrent
    dans cette zone.
    """
    kind = audit_candidate_kind(row)
    status = validation_status(row)
    score = int(row.get("priority_score_int") or 0)
    if status == "rejected_generic_formula":
        return "reject_generic"
    if status == "blocked_needs_manual_review":
        return "manual_review"
    dataset_use_threshold = DATASET_USE_THRESHOLD_BY_KIND.get(kind)
    is_dataset_use = dataset_use_threshold is not None and score >= dataset_use_threshold
    is_model_evidence = kind in MODEL_EVIDENCE_KINDS and score >= MODEL_EVIDENCE_THRESHOLD
    if (is_dataset_use or is_model_evidence) and llm_cache is not None and llm_downgrade_reason(row, llm_cache):
        return "low_priority_review"
    if is_dataset_use:
        return "review_for_dataset_use"
    if is_model_evidence:
        return "review_for_model_evidence"
    return "low_priority_review"


def candidate_sort_key(row: dict[str, Any]) -> tuple[int, int, str]:
    """Trie les candidats les plus utiles en premier."""
    kind_weight = {
        "DataSourceCandidate": 0,
        "VariableTableCandidate": 1,
        "FormulaCandidate": 2,
        "ModelEvidenceCandidate": 3,
        "ModelTableCandidate": 4,
        "GenericEstimatorFormulaCandidate": 9,
    }.get(audit_candidate_kind(row), 8)
    return (kind_weight, -int(row.get("priority_score_int") or 0), row.get("section_title") or "")


MIN_SCORE_BY_KIND = {
    # Les tableaux GROBID ont souvent une legende pauvre (le texte descriptif
    # reste englue dans le corps), donc leur score plafonne plus bas que les
    # sections narratives meme quand ils decrivent un vrai tableau de
    # resultats (coefficients, tests LM, ecarts-types). Seuil abaisse
    # specifiquement pour ce type, verifie manuellement sur un echantillon
    # (aucun faux positif trouve, y compris dans les manuels theoriques).
    # Les autres types gardent 45 : les abaisser rouvrirait le flot de faux
    # positifs deja corrige dans la prose theorique/manuels.
    "ModelTableCandidate": 30,
}
DEFAULT_MIN_SCORE = 45


def selected_rows(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Garde les candidats utiles pour le rapport humain."""
    keep_kinds = {
        "DataSourceCandidate",
        "VariableTableCandidate",
        "FormulaCandidate",
        "ModelEvidenceCandidate",
        "ModelTableCandidate",
        "GenericEstimatorFormulaCandidate",
    }
    out = []
    for row in rows:
        kind = audit_candidate_kind(row)
        score = int(row.get("priority_score_int") or 0)
        if kind not in keep_kinds:
            continue
        min_score = MIN_SCORE_BY_KIND.get(kind, DEFAULT_MIN_SCORE)
        if kind == "GenericEstimatorFormulaCandidate" or score >= min_score:
            out.append(row)
    return out


def make_report(rows: list[dict[str, Any]], llm_cache: dict[str, Any] | None = None) -> str:
    """Construit le contenu Markdown du rapport."""
    candidates = selected_rows(rows)
    by_paper: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in candidates:
        by_paper[paper_key(row)].append(row)

    kind_counts = Counter(audit_candidate_kind(row) for row in candidates)
    status_counts = Counter(validation_status(row) for row in candidates)
    action_counts = Counter(review_action(row, llm_cache) for row in candidates)
    llm_downgrades = [
        row
        for row in candidates
        if llm_cache is not None and review_action(row, llm_cache) == "low_priority_review" and review_action(row, None) != "low_priority_review"
    ]

    lines = [
        "---",
        "title: Revue des candidats model evidence issus de l'audit TEI",
        "type: metadata",
        f"created: {REPORT_CREATED}",
        f"updated: {date.today().isoformat()}",
        "sources: [data/manifests/papers/model_evidence_audit.csv]",
        "tags: [metadata, kg, audit, tei, model-evidence, review]",
        "---",
        "",
        "# Revue des candidats model evidence issus de l'audit TEI",
        "",
        f"Date : {REPORT_CREATED}",
        "",
        "Ce rapport est genere automatiquement depuis `data/manifests/papers/model_evidence_audit.csv`.",
        "Il sert a relire les passages candidats avant toute promotion vers les fiches datasets ou les preuves confirmees du KG.",
        "",
        "## Synthese",
        "",
        f"- Lignes d'audit lues : {len(rows)}",
        f"- Candidats retenus dans ce rapport : {len(candidates)}",
        f"- Papiers avec au moins un candidat : {len(by_paper)}",
        "",
        "### Par type",
        "",
        "| Type | Nombre |",
        "|---|---:|",
    ]
    for kind, count in kind_counts.most_common():
        lines.append(f"| `{kind}` | {count} |")

    lines.extend(["", "### Par statut", "", "| Statut | Nombre |", "|---|---:|"])
    for status, count in status_counts.most_common():
        lines.append(f"| `{status}` | {count} |")

    lines.extend(["", "### Action proposee", "", "| Action | Nombre |", "|---|---:|"])
    for action, count in action_counts.most_common():
        lines.append(f"| `{action}` | {count} |")

    lines.extend(
        [
            "",
            "## Regle de lecture",
            "",
            "- `review_for_dataset_use` : passage ou tableau prioritaire pour verifier qu'un papier utilise un dataset exploitable.",
            "- `review_for_model_evidence` : passage utile pour verifier formule, estimateur, metriques ou specification empirique.",
            "- `reject_generic` : equation generique d'estimateur, a ne pas transformer en formule publiee dataset.",
            "- `low_priority_review` : signal conserve mais non prioritaire.",
            "",
        ]
    )

    if llm_cache is not None:
        lines.extend(
            [
                "## Candidats declasses par verification LLM",
                "",
                "Ces candidats auraient obtenu une action prioritaire sur le seul score a mots-cles, "
                "mais Claude a juge l'extrait theorique/methodologique plutot qu'une utilisation empirique "
                "reelle dans ce papier (voir `09b_llm_disambiguate_candidates.py`).",
                "",
            ]
        )
        if llm_downgrades:
            lines.extend(["| Papier | Section/table | Score | Justification LLM |", "|---|---|---:|---|"])
            for row in llm_downgrades:
                cache_entry = llm_cache.get(candidate_key(row)) or {}
                lines.append(
                    "| {paper} | {section} | {score} | {reason} |".format(
                        paper=clean_cell(paper_key(row), 90),
                        section=clean_cell(row.get("section_title"), 90),
                        score=row.get("priority_score") or "",
                        reason=clean_cell(cache_entry.get("reasoning"), 200),
                    )
                )
        else:
            lines.append("Aucun.")
        lines.append("")

    lines.extend(["## Candidats par papier", ""])

    for paper, paper_rows in sorted(by_paper.items()):
        ordered = sorted(paper_rows, key=candidate_sort_key)
        lines.extend([f"### {clean_cell(paper, 180)}", ""])
        doi = ordered[0].get("doi") or ""
        tei_file = ordered[0].get("tei_file") or ""
        if doi:
            lines.append(f"- DOI : `{clean_cell(doi)}`")
        if tei_file:
            lines.append(f"- TEI : `{clean_cell(tei_file, 320)}`")
        lines.extend(
            [
                "",
                "| Action | Type | Score | Section/table | Extrait candidat |",
                "|---|---|---:|---|---|",
            ]
        )
        for row in ordered[:MAX_CANDIDATES_PER_PAPER]:
            candidate_text = row.get("formula_candidate") or row.get("table_caption") or row.get("candidate_text")
            lines.append(
                "| {action} | `{kind}` | {score} | {section} | {text} |".format(
                    action=review_action(row, llm_cache),
                    kind=audit_candidate_kind(row),
                    score=row.get("priority_score") or "",
                    section=clean_cell(row.get("section_title"), 120),
                    text=clean_cell(candidate_text, 260),
                )
            )
        remaining = len(ordered) - MAX_CANDIDATES_PER_PAPER
        if remaining > 0:
            lines.append(f"| low_priority_review | `truncated` |  |  | {remaining} autres candidats non affiches dans ce rapport |")
        lines.append("")

    lines.extend(
        [
            "## Related Pages",
            "",
            "- [[paper_dataset_ingestion_pipeline_2026-08]]",
            "- [[paper_dataset_ingestion_gaps_2026-07]]",
        ]
    )

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description="Genere le rapport de revue des candidats audit.")
    parser.add_argument(
        "--no-llm",
        action="store_true",
        help="Ignorer le cache de desambiguisation LLM meme s'il existe.",
    )
    args = parser.parse_args()

    rows = read_model_evidence_audit()
    llm_cache = None if args.no_llm else load_llm_disambiguation_cache()
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(make_report(rows, llm_cache), encoding="utf-8", newline="\n")
    print(f"rows={len(rows)}")
    if llm_cache is not None:
        print(f"verdicts LLM en cache: {len(llm_cache)}")
    print(f"report={REPORT_PATH}")


if __name__ == "__main__":
    main()
