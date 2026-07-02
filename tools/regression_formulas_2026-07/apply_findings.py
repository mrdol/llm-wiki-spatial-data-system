\
# -*- coding: utf-8 -*-
"""Apply regression-formula findings to wiki/datasets/packages/*.md fiches.

Idempotent-ish: re-running replaces the same blocks with the same content.
Only touches: '### Formule - niveau publication' field values, adds a new
'### Statut regression canonique' subsection, adds a 'modeling_evidence:'
block in Bloc 3, and bumps the frontmatter 'updated:' date.
"""
import re
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from regression_findings import FINDINGS

ROOT = Path(__file__).resolve().parents[2]  # tools/regression_formulas_2026-07/ -> repo root
PKG_DIR = ROOT / "wiki" / "datasets" / "packages"
TODAY = date.today().isoformat()

STATUS_LABEL = {
    "bon_candidat": "bon candidat",
    "a_verifier": "a verifier",
    "mauvais_candidat": "mauvais candidat",
    "mis_de_cote": "mis de cote",
    "candidat_par_analogie": "candidat par analogie -- non verifie",
}

EQUATION_FAMILY_KEYWORDS = [
    ("geographically weighted", "geographically_weighted"),
    ("gwr", "geographically_weighted"),
    ("spatial error", "spatial_error"),
    ("sem", "spatial_error"),
    ("spatial lag", "spatial_lag"),
    ("sar", "spatial_lag"),
    ("bayesien", "bayesian_latent_field"),
    ("bayesian", "bayesian_latent_field"),
    ("car)", "bayesian_latent_field"),
    ("bym", "bayesian_latent_field"),
    ("krigeage", "unknown"),
    ("kriging", "unknown"),
    ("glmm", "generalized_linear"),
    ("poisson", "generalized_linear"),
    ("binomial", "generalized_linear"),
    ("logistique", "generalized_linear"),
    ("glm", "generalized_linear"),
    ("pls", "unknown"),
    ("splines", "unknown"),
    ("ols", "linear"),
    ("twinsir", "simulation_model"),
]


def guess_equation_family(method: str | None) -> str:
    if not method:
        return "unknown"
    lowered = method.lower()
    for kw, fam in EQUATION_FAMILY_KEYWORDS:
        if kw in lowered:
            return fam
    return "unknown"


def build_formula_block(f: dict) -> str:
    status = f["status"]
    if f.get("formula"):
        formula_pub = f["formula"]
        y_term = f.get("formula", "").split("~")[0].strip() if "~" in f.get("formula", "") else "pending"
        x_terms = f.get("formula", "").split("~", 1)[1].strip() if "~" in f.get("formula", "") else "pending"
    else:
        formula_pub = "none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)"
        y_term = "none"
        x_terms = "none"
    source = f.get("source") or "none (aucune source verifiable retrouvee)"
    return (
        "### Formule — niveau publication\n\n"
        f"- formula_pub: {formula_pub}\n"
        f"- x_terms_pub: {x_terms}\n"
        f"- y_term_pub: {y_term}\n"
        f"- Reference publication: {source}\n"
    )


def build_status_block(did: str, f: dict) -> str:
    status_label = STATUS_LABEL[f["status"]]
    evidence = f.get("evidence") or "n/a"
    method = f.get("method") or "n/a"
    homolog = f.get("homolog") or "aucune identifiee"
    note = f.get("note") or "n/a"
    return (
        "### Statut regression canonique (mission recherche manuelle, juillet 2026)\n\n"
        f"- Statut: {status_label}\n"
        f"- Niveau de preuve: {evidence}\n"
        f"- Methode d'estimation: {method}\n"
        f"- Correspondance Python/R: {homolog}\n"
        f"- Note: {note}\n"
    )


def build_modeling_evidence_block(f: dict) -> str:
    has_formula = bool(f.get("formula"))
    equation_family = guess_equation_family(f.get("method"))
    confidence = {"verbatim": "high", "code": "medium", "article": "medium",
                  "analogie": "low", None: "low"}.get(f.get("evidence"), "low")
    source_type = "software_documentation" if f.get("evidence") == "verbatim" else (
        "full_paper" if f.get("evidence") == "article" else (
            "dataset_metadata" if f.get("evidence") == "code" else "unknown"))
    formula_escaped = (f.get("formula") or "null")
    source_escaped = (f.get("source") or "null")
    return (
        "```yaml\n"
        "modeling_evidence:\n"
        f"  existing_model_found: {'true' if has_formula else 'false'}\n"
        f"  equation_text: \"{formula_escaped}\"\n"
        f"  equation_family: {equation_family}\n"
        f"  model_family: \"{f.get('method') or 'unknown'}\"\n"
        f"  source_type: {source_type}\n"
        f"  source_ref: \"{source_escaped}\"\n"
        f"  confidence: {confidence}\n"
        "```\n"
    )


def process(path: Path, f: dict) -> bool:
    text = path.read_text(encoding="utf-8-sig")

    # 1) Replace "### Formule — niveau publication" block
    pattern_formula = re.compile(
        r"### Formule — niveau publication\n\n"
        r"- formula_pub:.*?\n"
        r"- x_terms_pub:.*?\n"
        r"- y_term_pub:.*?\n"
        r"- Reference publication:.*?\n",
        re.DOTALL,
    )
    new_formula_block = build_formula_block(f)
    if not pattern_formula.search(text):
        raise RuntimeError(f"Formula block pattern not found in {path.name}")
    text = pattern_formula.sub(lambda m: new_formula_block, text, count=1)

    # 2) Insert "### Statut regression canonique" right after the formula block,
    #    before "### Formule — niveau systeme" (replace if already present, for idempotency)
    status_marker = "### Statut regression canonique (mission recherche manuelle, juillet 2026)"
    if status_marker in text:
        pattern_status = re.compile(
            re.escape(status_marker) + r"\n\n(?:- .*\n)+",
        )
        text = pattern_status.sub(lambda m: build_status_block(path.stem, f), text, count=1)
    else:
        anchor = "### Formule — niveau systeme"
        if anchor not in text:
            raise RuntimeError(f"Anchor '### Formule — niveau systeme' not found in {path.name}")
        text = text.replace(anchor, build_status_block(path.stem, f) + "\n" + anchor, 1)

    # 3) Insert modeling_evidence yaml block in Bloc 3, after "Modele niveau 3 (variante): pending"
    me_marker = "```yaml\nmodeling_evidence:"
    if me_marker in text:
        pattern_me = re.compile(r"```yaml\nmodeling_evidence:\n(?:  .*\n)+```\n")
        text = pattern_me.sub(lambda m: build_modeling_evidence_block(f), text, count=1)
    else:
        anchor3 = "## Bloc 4 — Typologie des donnees"
        if anchor3 not in text:
            raise RuntimeError(f"Anchor '## Bloc 4' not found in {path.name}")
        text = text.replace(
            anchor3,
            build_modeling_evidence_block(f) + "\n" + anchor3,
            1,
        )

    # 4) Bump 'updated:' frontmatter date
    text = re.sub(r"(?m)^updated:\s*\d{4}-\d{2}-\d{2}\s*$", f"updated: {TODAY}", text, count=1)

    path.write_text(text, encoding="utf-8", newline="\n")
    return True


def main():
    n_ok = 0
    errors = []
    for did, f in FINDINGS.items():
        path = PKG_DIR / f"{did}.md"
        try:
            process(path, f)
            n_ok += 1
        except Exception as exc:  # noqa: BLE001
            errors.append((did, str(exc)))

    print(f"OK: {n_ok}/{len(FINDINGS)}")
    if errors:
        print("ERRORS:")
        for did, msg in errors:
            print(f"  {did}: {msg}")


if __name__ == "__main__":
    main()
