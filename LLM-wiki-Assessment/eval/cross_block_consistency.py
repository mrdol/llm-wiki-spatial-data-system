"""Verification de coherence inter-blocs pour les fiches dataset.

Contrairement a Tier 1 (presence/validite d'un champ pris isolement) et
Tier 2.5 (fiche vs PDF source), ce module compare des champs situes dans des
blocs DIFFERENTS de la MEME fiche entre eux : est-ce que ce que dit le
Bloc 1 (formule) est coherent avec ce que dit le Bloc 4 (N/k), avec
benchmark_readiness, avec estimator_eligibility et avec le tableau Quality
Control ? C'est un script deterministe (pas d'appel LLM) : il ne modifie
aucune fiche, il ecrit une synthese markdown dans
`.eval/consistency_reports/<date>.md`.

Regles implementees
--------------------
R1 formula_vars_exist       chaque variable citee dans formula_used doit
                             apparaitre parmi les candidats Y/X declares
                             dans le Bloc 1 (sinon la formule reference une
                             colonne absente de l'artefact).
R2 package_yes_needs_formula package_include="yes" => formula_used != pending
                             et formula_status != not_found/vide.
R3 n_observations_consistent le "N observations" du Bloc 4 doit correspondre
                             a tout "N=<nombre>" mentionne dans source_ref
                             / reason (verification croisee textuelle faite
                             par le redacteur lui-meme, doit rester exacte).
R4 eligibility_vs_readiness  estimator_eligibility.status et
                             benchmark_readiness.benchmark_status ne doivent
                             pas se contredire (ready vs not_ready/needs_*).
R5 quality_control_honest   le tableau Quality Control ne doit pas dire "OK"
                             pour un champ dont la valeur source amont est
                             pending/unknown/not_found.

Usage
-----
    python LLM-wiki-Assessment/eval/cross_block_consistency.py
    python LLM-wiki-Assessment/eval/cross_block_consistency.py --fiche wiki/datasets/fiches_datasets/paper_x.md
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass, field
from datetime import date
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent.parent.parent
WIKI_ROOT = PROJECT_ROOT / "wiki"
FICHES_DIR = WIKI_ROOT / "datasets" / "fiches_datasets"
REPORT_DIR = PROJECT_ROOT / ".eval" / "consistency_reports"

NULL_LIKE = {"", "pending", "unknown", "none", "not_found", "n/a", "na", "null"}


def _field_value(body: str, label: str) -> str | None:
    # Some fiches use an em dash "—" instead of a hyphen "-" inside labels
    # (e.g. "Coordinates (x, y — excluded from X candidates)") -- match
    # either so the field is still found.
    label_pattern = re.escape(label).replace(r"\-", "[-—]")
    match = re.search(rf"(?im)^\s*(?:-\s*)?{label_pattern}\s*:\s*(.+?)\s*$", body)
    return match.group(1).strip() if match else None


def _section_value(body: str, title: str) -> str | None:
    pattern = rf"(?ims)^##\s+{re.escape(title)}\s*$\n(.*?)(?=^##\s+|\Z)"
    match = re.search(pattern, body)
    return match.group(1).strip() if match else None


def _yaml_block_after(body: str, anchor: str) -> str | None:
    """Extract the ```yaml ...``` block that follows a given anchor label."""
    idx = body.find(anchor)
    if idx == -1:
        return None
    tail = body[idx:]
    match = re.search(r"```yaml\s*\n(.*?)```", tail, re.DOTALL)
    return match.group(1) if match else None


def _yaml_field(yaml_text: str | None, key: str) -> str | None:
    if not yaml_text:
        return None
    match = re.search(rf'(?m)^\s*{re.escape(key)}\s*:\s*"?(.*?)"?\s*$', yaml_text)
    return match.group(1).strip() if match else None


def _yaml_list_field(yaml_text: str | None, key: str) -> list[str]:
    if not yaml_text:
        return []
    match = re.search(rf"(?m)^\s*{re.escape(key)}\s*:\s*\[(.*?)\]", yaml_text)
    if not match:
        return []
    return [item.strip().strip("'\"") for item in match.group(1).split(",") if item.strip()]


def _clean(value: str | None) -> str:
    if value is None:
        return ""
    return value.strip().strip("`'\"")


def _is_null_like(value: str | None) -> bool:
    return _clean(value).lower() in NULL_LIKE


def _backtick_names(text: str | None) -> set[str]:
    if not text:
        return set()
    return {m.strip() for m in re.findall(r"`([^`]+)`", text)}


R_TOKEN_STOPWORDS = {
    "log", "log1p", "sqrt", "factor", "poly", "I", "as.factor", "scale", "abs",
    "offset", "Matern", "cbind", "f", "s", "te", "ti", "re", "ar1", "iid",
    "rw1", "rw2", "rw2d", "besag", "bym", "bym2", "n", "in",
}


def _formula_variables(formula: str) -> list[str]:
    """Extract bare variable-like tokens from an R-style formula string.

    Formulas are frequently annotated in French with bracketed asides (e.g.
    "[X partiel : ...]") or trailing "... (voir Candidate X variables)"
    truncation notes. These are curator prose, not formula terms, and must
    be stripped before tokenising -- otherwise every French word in the
    aside gets misread as an undeclared variable.
    """
    if not formula or _is_null_like(formula):
        return []
    formula = re.sub(r"\[.*?\]", "", formula, flags=re.DOTALL)
    # Only treat "..." as a prose truncation marker when preceded by
    # whitespace (e.g. "+ ... (44 covariables...)") -- R's make.names()
    # routinely produces real column names containing "..." glued to the
    # previous character (e.g. "Max.VPD.Y0...hPa." from "Max VPD Y0 (hPa)"),
    # which must NOT be cut.
    formula = re.split(r"(?<=\s)\.\.\.", formula)[0]
    formula = re.split(r"\(voir ", formula)[0]
    # drop the response side if present (before the first ~)
    rhs = formula.split("~", 1)[1] if "~" in formula else formula
    tokens = re.findall(r"[A-Za-z_][A-Za-z0-9_.]*", rhs)
    return [t for t in tokens if t not in R_TOKEN_STOPWORDS]


@dataclass
class Issue:
    rule: str
    severity: str  # "error" | "warning"
    message: str


@dataclass
class FicheReport:
    path: Path
    issues: list[Issue] = field(default_factory=list)

    def add(self, rule: str, severity: str, message: str) -> None:
        self.issues.append(Issue(rule, severity, message))


def check_fiche(path: Path) -> FicheReport:
    body = path.read_text(encoding="utf-8")
    report = FicheReport(path=path)

    # --- Bloc 1 : formule et variables --------------------------------
    y_line = _field_value(body, "Candidate Y variables")
    # Paper-derived fiches (generate_fiches_papers.R) label this field
    # "... in local artifact"; package-derived fiches (generate_fiches.py)
    # label it just "Candidate X variables" -- both must be recognised.
    x_line = (
        _field_value(body, "Candidate X variables in local artifact")
        or _field_value(body, "Candidate X variables")
    )
    coord_line = _field_value(body, "Coordinates (x, y - excluded from X candidates)")
    id_line = _field_value(body, "Identifier columns (excluded from X candidates)")
    y_vars = _backtick_names(y_line)
    x_vars = _backtick_names(x_line)
    # Coordinates/identifiers are excluded from the "candidate X" list by
    # construction, but formulas legitimately use them as covariates
    # (e.g. a spatial trend on latitude/longitude) -- they still count as
    # "known" variables for R1, just not as generic X candidates.
    known_vars = y_vars | x_vars | _backtick_names(coord_line) | _backtick_names(id_line)

    formula_used = _field_value(body, "formula_used")
    formula_status_line = _field_value(body, "Statut regression canonique")

    # locate the "### Formule - niveau systeme" sub-section for formula_status
    sys_formula_section = None
    m = re.search(r"(?ims)^###\s+Formule\s*-\s*niveau systeme\s*$\n(.*?)(?=^##|\Z)", body)
    if m:
        sys_formula_section = m.group(1)
    formula_used_sys = _field_value(sys_formula_section or "", "formula_used") or formula_used

    # --- R1 : chaque variable de formula_used doit exister dans Y/X ---
    # Some fiches carry a generic mathematical/theoretical multilevel-model
    # equation as formula_used (subscripted notation like "y_{i,j}",
    # transposes "x'", no concrete column names) rather than an executable
    # R formula -- R1 doesn't apply to those, they're not meant to reference
    # real column names.
    is_theoretical_equation = bool(formula_used_sys and re.search(r"_\{|'\s*_|\\[a-zA-Z]", formula_used_sys))
    if formula_used_sys and not _is_null_like(formula_used_sys) and not is_theoretical_equation:
        used_vars = set(_formula_variables(formula_used_sys))
        missing = sorted(v for v in used_vars if v not in known_vars)
        if missing:
            report.add(
                "R1_formula_vars_exist", "error",
                f"formula_used=`{formula_used_sys}` reference des variables absentes "
                f"des candidats Y/X declares : {', '.join(missing)}",
            )

    # --- benchmark_readiness / estimator_eligibility yaml blocks ------
    br_yaml = _yaml_block_after(body, "## Benchmark readiness")
    package_include = _clean(_yaml_field(br_yaml, "package_include"))
    benchmark_status = _clean(_yaml_field(br_yaml, "benchmark_status"))
    formula_status = _clean(_yaml_field(_yaml_block_after(body, "### Formules candidates") or "", "status"))

    ee_yaml = _yaml_block_after(body, "## Estimator eligibility")
    # Two incompatible schemas coexist in this wiki: paper-derived fiches use
    # a single object with status/eligible_estimators/..., while some older
    # package-derived fiches use a flat YAML list of "- estimator: <name>"
    # entries with no status field at all. Detect and handle both.
    is_flat_list_schema = bool(ee_yaml and re.search(r"(?m)^\s*-\s*estimator\s*:", ee_yaml))
    if is_flat_list_schema:
        ee_status = "ready" if ee_yaml.strip() else ""
        eligible_estimators = re.findall(r"(?m)^\s*-\s*estimator\s*:\s*(\S+)", ee_yaml)
        conditional_estimators = []
        ineligible_reason = ""
    else:
        ee_status = _clean(_yaml_field(ee_yaml, "status"))
        eligible_estimators = _yaml_list_field(ee_yaml, "eligible_estimators")
        conditional_estimators = _yaml_list_field(ee_yaml, "conditionally_eligible_estimators")
        ineligible_reason = _clean(_yaml_field(ee_yaml, "ineligible_reason"))

    # --- R2 : package_include=yes => formule resolue -------------------
    if package_include.lower() == "yes":
        if _is_null_like(formula_used_sys):
            report.add(
                "R2_package_yes_needs_formula", "error",
                "package_include=\"yes\" mais formula_used est pending/vide.",
            )

    # --- R3 : N observations vs N mentionne dans le texte --------------
    n_obs_line = _field_value(body, "N observations")
    n_obs = None
    if n_obs_line:
        m2 = re.search(r"\d+", n_obs_line.replace(" ", ""))
        if m2:
            n_obs = int(m2.group(0))
    # Exclude "N=<x> degres de liberte/df" mentions -- those are a distinct
    # statistical quantity (dof), not a claim about the dataset's row count.
    body_no_df = re.sub(r"N\s*=\s*[\d,]{2,}\s*(degres? de libert|df\b)", "", body, flags=re.IGNORECASE)
    text_n_mentions = set(int(n) for n in re.findall(r"N\s*=\s*([\d,]{2,})", body_no_df.replace(",", "")))
    if n_obs is not None and text_n_mentions:
        mismatched = sorted(n for n in text_n_mentions if n != n_obs)
        # Only flag when the discrepancy isn't already narrated nearby
        # ("ecart", "exclusion", "vs N publie", "millesime", ...) -- those
        # are already-transparent documented gaps, not silent bugs.
        already_explained = bool(re.search(
            r"(?i)ecart|apres exclusion|vs\s+n\s+publi|millesime|controle qualite",
            body,
        ))
        if mismatched and not already_explained:
            report.add(
                "R3_n_observations_consistent", "warning",
                f"Bloc 4 declare N observations={n_obs}, mais le texte mentionne aussi "
                f"N={mismatched} -- verifier laquelle est correcte.",
            )

    # --- R4 : coherence estimator_eligibility vs benchmark_readiness ---
    if benchmark_status == "ready":
        if ee_status and ee_status not in {"ready", ""}:
            report.add(
                "R4_eligibility_vs_readiness", "warning",
                f"benchmark_readiness.benchmark_status=\"ready\" mais "
                f"estimator_eligibility.status=\"{ee_status}\".",
            )
        if ee_yaml and not eligible_estimators and not conditional_estimators and not ineligible_reason:
            report.add(
                "R4_eligibility_vs_readiness", "warning",
                "benchmark_status=\"ready\" mais eligible_estimators ET "
                "conditionally_eligible_estimators sont vides, sans ineligible_reason "
                "expliquant pourquoi.",
            )
    elif benchmark_status and benchmark_status.startswith(("not_ready", "needs_")):
        if ee_status == "ready":
            report.add(
                "R4_eligibility_vs_readiness", "warning",
                f"benchmark_status=\"{benchmark_status}\" mais "
                f"estimator_eligibility.status=\"ready\".",
            )

    # --- R5 : Quality Control ne doit pas dire OK sur du pending -------
    qc = _section_value(body, "Quality Control") or ""
    qc_checks = {
        "Formula": _is_null_like(formula_used_sys) or formula_status in {"not_found", ""},
        "Variables": not known_vars,
    }
    for field_name, upstream_is_bad in qc_checks.items():
        qc_line_match = re.search(rf"(?im)^-\s*{field_name}\s*:\s*(.+)$", qc)
        if not (qc_line_match and upstream_is_bad):
            continue
        qc_line = qc_line_match.group(1).strip()
        # "OK - ... formula_used reste pending ..." is a legitimate, honest
        # nuance (publication-level evidence is OK even when the locally
        # executable formula is not) -- only flag a bare "OK" that hides
        # the caveat instead of stating it.
        if qc_line.startswith("OK") and "pending" not in qc_line.lower():
            report.add(
                "R5_quality_control_honest", "error",
                f"Quality Control dit \"{field_name}: {qc_line}\" mais le champ amont "
                f"correspondant est pending/vide, sans que la ligne QC le mentionne.",
            )

    return report


def iter_fiches() -> list[Path]:
    return sorted(FICHES_DIR.glob("*.md"))


def write_report(reports: list[FicheReport]) -> Path:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    out_path = REPORT_DIR / f"{date.today().isoformat()}.md"

    flagged = [r for r in reports if r.issues]
    n_errors = sum(1 for r in flagged for i in r.issues if i.severity == "error")
    n_warnings = sum(1 for r in flagged for i in r.issues if i.severity == "warning")

    lines = [
        "---",
        'title: "Cross-block consistency report"',
        "type: metadata",
        f"created: {date.today().isoformat()}",
        "tags: [metadata, eval, consistency]",
        "---",
        "",
        "# Rapport de coherence inter-blocs",
        "",
        f"- Fiches analysees : {len(reports)}",
        f"- Fiches avec au moins un probleme : {len(flagged)}",
        f"- Erreurs : {n_errors}",
        f"- Avertissements : {n_warnings}",
        "",
        "## Details par fiche",
        "",
    ]
    for r in flagged:
        try:
            rel = r.path.relative_to(PROJECT_ROOT).as_posix()
        except ValueError:
            rel = r.path.as_posix()
        lines.append(f"### `{rel}`")
        lines.append("")
        for issue in r.issues:
            tag = "ERREUR" if issue.severity == "error" else "AVERTISSEMENT"
            lines.append(f"- [{tag}] ({issue.rule}) {issue.message}")
        lines.append("")

    out_path.write_text("\n".join(lines), encoding="utf-8")
    return out_path


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--fiche", type=Path, default=None, help="Limiter a une seule fiche.")
    args = parser.parse_args()

    targets = [args.fiche] if args.fiche else iter_fiches()
    reports = [check_fiche(p) for p in targets]

    out_path = write_report(reports)
    flagged = [r for r in reports if r.issues]
    print(f"Fiches analysees : {len(reports)}")
    print(f"Fiches avec probleme(s) : {len(flagged)}")
    print(f"Rapport : {out_path}")


if __name__ == "__main__":
    main()
