"""Generer un rapport de revue des candidats issus de l'audit TEI.

Le rapport sert de sas de curation entre :
- les signaux automatiques extraits des TEI ;
- les vrais usages papier-dataset et formules confirmees ;
- les futures fiches datasets.
"""

from __future__ import annotations

import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from audit_reader import audit_candidate_kind, confidence_from_audit, read_model_evidence_audit, validation_status


REPORT_PATH = ROOT / "wiki" / "analyses" / "model_evidence_candidates_review_2026-08.md"
MAX_CANDIDATES_PER_PAPER = 12


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


def review_action(row: dict[str, Any]) -> str:
    """Propose une action de curation non automatique."""
    kind = audit_candidate_kind(row)
    status = validation_status(row)
    score = int(row.get("priority_score_int") or 0)
    if status == "rejected_generic_formula":
        return "reject_generic"
    if status == "blocked_needs_manual_review":
        return "manual_review"
    if kind in {"DataSourceCandidate", "VariableTableCandidate"} and score >= 70:
        return "review_for_dataset_use"
    if kind in {"FormulaCandidate", "ModelEvidenceCandidate", "ModelTableCandidate"} and score >= 55:
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
        if kind == "GenericEstimatorFormulaCandidate" or score >= 45:
            out.append(row)
    return out


def make_report(rows: list[dict[str, Any]]) -> str:
    """Construit le contenu Markdown du rapport."""
    candidates = selected_rows(rows)
    by_paper: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for row in candidates:
        by_paper[paper_key(row)].append(row)

    kind_counts = Counter(audit_candidate_kind(row) for row in candidates)
    status_counts = Counter(validation_status(row) for row in candidates)
    action_counts = Counter(review_action(row) for row in candidates)

    lines = [
        "# Revue des candidats model evidence issus de l'audit TEI",
        "",
        "Date : 2026-08-06",
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
            "## Candidats par papier",
            "",
        ]
    )

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
                    action=review_action(row),
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

    return "\n".join(lines).rstrip() + "\n"


def main() -> None:
    rows = read_model_evidence_audit()
    REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    REPORT_PATH.write_text(make_report(rows), encoding="utf-8", newline="\n")
    print(f"rows={len(rows)}")
    print(f"report={REPORT_PATH}")


if __name__ == "__main__":
    main()
