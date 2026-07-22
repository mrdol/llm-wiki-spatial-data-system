from __future__ import annotations

import argparse
import csv
import re
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FICHE_ROOT = ROOT / "wiki" / "datasets" / "fiches_datasets"
OUT = ROOT / "data" / "manifests" / "datasets" / "proposed_formula_used_audit.csv"

PENDING_PREFIXES = ("pending", "null", "none", "n/a", "na", "unknown")


@dataclass
class Proposal:
    dataset_id: str
    fiche_path: str
    action: str
    formula_used: str
    y_term_used: str
    x_terms_used: str
    formula_candidate_1: str
    formula_candidate_2: str
    recommended_candidate: str
    source: str
    reason: str


def is_pending(value: str | None) -> bool:
    if value is None:
        return True
    low = value.strip().lower()
    return not low or any(low == item or low.startswith(item + " ") or low.startswith(item + "(") for item in PENDING_PREFIXES)


def field_value(text: str, field: str) -> str:
    match = re.search(rf"(?im)^-\s*{re.escape(field)}\s*:\s*(.+?)\s*$", text)
    return match.group(1).strip() if match else ""


def backtick_values(text: str, field: str) -> list[str]:
    value = field_value(text, field)
    return re.findall(r"`([^`]+)`", value)


def split_formula(formula: str) -> tuple[str, str]:
    if "~" not in formula:
        return "", ""
    y_term, x_terms = formula.split("~", 1)
    return y_term.strip().strip("`"), x_terms.strip().strip("`")


def split_x_terms(x_terms: str) -> list[str]:
    return [term.strip() for term in x_terms.split("+") if term.strip()]


def join_formula(y_term: str, x_terms: list[str]) -> str:
    return f"{y_term} ~ {' + '.join(x_terms)}" if y_term and x_terms else ""


def build_formula_candidates(formula_used: str, y_term: str, x_terms: str, x_candidates: list[str]) -> tuple[str, str, str, str]:
    """Construit deux formules systeme candidates pour une fiche sans formule publiee.

    La premiere formule reste la formule par defaut deja utilisee par le benchmark.
    La seconde donne une variante parcimonieuse ou etendue selon le nombre de
    variables deja retenues.
    """
    primary_terms = split_x_terms(x_terms)
    candidate_pool = [term for term in x_candidates if term not in primary_terms]

    if len(primary_terms) >= 5:
        secondary_terms = primary_terms[:4]
        reason = (
            "candidate_1 conserve la specification systeme actuelle pour comparer les estimateurs; "
            "candidate_2 est une variante parcimonieuse utile si colinearite, temps de calcul ou petits folds posent probleme."
        )
    elif candidate_pool:
        secondary_terms = (primary_terms + candidate_pool)[:8]
        reason = (
            "candidate_1 est prioritaire car elle reste parcimonieuse; "
            "candidate_2 ajoute davantage de covariables candidates pour les estimateurs avec selection implicite."
        )
    else:
        secondary_terms = primary_terms
        reason = (
            "une seule specification distincte est disponible avec les variables candidates actuelles; "
            "candidate_2 repete candidate_1 en attendant une revue manuelle."
        )

    candidate_1 = formula_used
    candidate_2 = join_formula(y_term, secondary_terms)
    return candidate_1, candidate_2, "formula_candidate_1", reason


def candidate_block(candidate_1: str, candidate_2: str, recommended: str, reason: str) -> str:
    return "\n".join([
        "",
        "### Formules candidates — niveau systeme",
        "",
        f"- formula_candidate_1: {candidate_1}",
        "- formula_candidate_1_role: recommended_default",
        f"- formula_candidate_2: {candidate_2}",
        "- formula_candidate_2_role: alternative_specification",
        f"- recommended_formula: {recommended}",
        "- selection_status: generated_system_formula",
        f"- selection_reason: {reason}",
        "- preprocessing_note: Les estimateurs comme xgboost, random_forest, gamboost et spboost peuvent reduire l'effet de certaines variables via leur mecanisme d'apprentissage ou de regularisation ; les modeles lineaires/spatiaux parametriques restent plus sensibles au choix explicite de X.",
    ])


def upsert_candidate_block(text: str, block: str) -> str:
    pattern = (
        r"(?ms)^### Formules candidates — niveau systeme\n\n"
        r".*?"
        r"(?=^## Bloc 2|^### |\Z)"
    )
    if re.search(pattern, text):
        return re.sub(pattern, block + "\n\n", text)
    marker = r"(?m)^-\s*y_term_used\s*:.*$"
    match = re.search(marker, text)
    if not match:
        return text
    insert_at = match.end()
    return text[:insert_at] + "\n" + block + text[insert_at:]


def executable_public_formula(formula_pub: str) -> tuple[str, str, str] | None:
    """Retourne une formule publiee reutilisable telle quelle en benchmark.

    Les formules textuelles avec plusieurs equations, ellipses ou notation
    theorique restent dans `formula_pub` mais ne sont pas reprises
    automatiquement comme `formula_used`.
    """
    formula = formula_pub.strip().strip("`")
    if is_pending(formula) or "~" not in formula:
        return None
    if ";" in formula or "..." in formula or "y_{" in formula or formula.startswith("~"):
        return None
    y_term, x_terms = split_formula(formula)
    if not y_term or not x_terms:
        return None
    return formula, y_term, x_terms


def replace_line(text: str, field: str, value: str) -> str:
    pattern = rf"(?im)^-\s*{re.escape(field)}\s*:\s*.*$"
    replacement = f"- {field}: {value}"
    if re.search(pattern, text):
        return re.sub(pattern, replacement, text)
    return text


def replace_note_if_empty(text: str, note: str) -> str:
    pattern = r"(?im)^-\s*Note\s*:\s*n/a\s*$"
    if re.search(pattern, text):
        return re.sub(pattern, f"- Note: {note}", text)
    return text


def propose_for_fiche(path: Path, apply: bool) -> Proposal:
    text = path.read_text(encoding="utf-8", errors="replace")
    dataset_id = field_value(text, "Dataset ID").strip("`") or path.stem
    rel_path = path.relative_to(ROOT).as_posix()
    current_used = field_value(text, "formula_used")

    if path.name.startswith("R_ade4_"):
        return Proposal(dataset_id, rel_path, "skipped", "", "", "", "", "", "", "none", "ade4 exclu de la passe benchmark spatial")

    formula_pub = field_value(text, "formula_pub")
    x_candidates = backtick_values(text, "Candidate X variables")

    if not is_pending(current_used) and is_pending(formula_pub):
        formula = current_used
        y_term = field_value(text, "y_term_used")
        x_terms = field_value(text, "x_terms_used")
        candidate_1, candidate_2, recommended, candidate_reason = build_formula_candidates(formula, y_term, x_terms, x_candidates)
        if apply:
            updated = upsert_candidate_block(text, candidate_block(candidate_1, candidate_2, recommended, candidate_reason))
            path.write_text(updated, encoding="utf-8", newline="\n")
        return Proposal(
            dataset_id, rel_path, "updated", formula, y_term, x_terms,
            candidate_1, candidate_2, recommended,
            "generated_formula_candidates",
            "formula_used existante completee par deux formules candidates",
        )

    if not is_pending(current_used):
        return Proposal(
            dataset_id, rel_path, "skipped", current_used,
            field_value(text, "y_term_used"), field_value(text, "x_terms_used"),
            "", "", "", "existing_published_or_manual_formula",
            "formula_used deja renseignee depuis une source publiee ou une revue manuelle",
        )

    public = executable_public_formula(formula_pub)
    if public:
        formula, y_term, x_terms = public
        source = "published_formula_reused"
        reason = "formula_pub executable reprise dans formula_used"
        candidate_1 = candidate_2 = recommended = ""
    else:
        y_candidates = backtick_values(text, "Candidate Y variables")
        if not y_candidates or not x_candidates:
            return Proposal(dataset_id, rel_path, "skipped", "", "", "", "", "", "", "none", "candidats Y/X insuffisants")
        y_term = y_candidates[0]
        x_terms = " + ".join(x_candidates[:8])
        formula = f"{y_term} ~ {x_terms}"
        source = "generated_from_yx_candidates"
        reason = "formule systeme proposee depuis les candidats Y/X inspectes"
        candidate_1, candidate_2, recommended, candidate_reason = build_formula_candidates(formula, y_term, x_terms, x_candidates)

    if apply:
        updated = replace_line(text, "formula_used", formula)
        updated = replace_line(updated, "x_terms_used", x_terms)
        updated = replace_line(updated, "y_term_used", y_term)
        if source == "generated_from_yx_candidates":
            updated = replace_note_if_empty(
                updated,
                "Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.",
            )
            updated = upsert_candidate_block(updated, candidate_block(candidate_1, candidate_2, recommended, candidate_reason))
        path.write_text(updated, encoding="utf-8", newline="\n")

    return Proposal(dataset_id, rel_path, "updated", formula, y_term, x_terms, candidate_1, candidate_2, recommended, source, reason)


def write_manifest(rows: list[Proposal], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(Proposal.__annotations__.keys()))
        writer.writeheader()
        for row in rows:
            writer.writerow(row.__dict__)


def main() -> None:
    parser = argparse.ArgumentParser(description="Propose formula_used for benchmarkable non-ade4 dataset fiches.")
    parser.add_argument("--apply", action="store_true", help="Modifie les fiches au lieu de seulement produire le manifeste.")
    parser.add_argument("--out", default=str(OUT))
    args = parser.parse_args()

    rows = [propose_for_fiche(path, apply=args.apply) for path in sorted(FICHE_ROOT.glob("*.md"))]
    write_manifest(rows, Path(args.out))
    counts: dict[str, int] = {}
    for row in rows:
        key = f"{row.action}:{row.source}"
        counts[key] = counts.get(key, 0) + 1
    for key in sorted(counts):
        print(f"{key}={counts[key]}")


if __name__ == "__main__":
    main()
