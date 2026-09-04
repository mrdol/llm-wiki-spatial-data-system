#!/usr/bin/env python3
"""Blocking readiness gate for dataset fiches.

This checker separates documentation from benchmark promotion. A fiche may
document an incomplete dataset, but a fiche in the stable dataset wiki must not
be treated as package-ready unless it has the minimum evidence required by
AGENTS.md:

- usable spatial support;
- a real response Y;
- at least two local covariates X for the executable formula;
- a defensible formula/model specification;
- estimator eligibility backed by source evidence.

The absence of a serialized W matrix is not a blocker when the fiche has
usable geometry/coordinates: the benchmark layer can build a documented W from
coordinates or polygon contiguity. A missing W is only blocking when the paper
uses a non-geographic/source-specific network that cannot be reconstructed from
the local spatial support.

The script exits non-zero when a fiche declares package_include: yes without
passing the gate for its declared task. Continuous regression is the default
package path, but explicitly documented classification/SDM fiches may pass as
non-regression package datasets when Y, X, formula, estimator evidence and
spatial support are present. With --strict-stable, it also fails fiches that do
not reach at least 3/4 among Y, X, formula, estimator evidence.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
FICHE_DIR = ROOT / "wiki" / "datasets" / "fiches_datasets"
DEFAULT_CSV = ROOT / "data" / "manifests" / "datasets" / "dataset_fiche_readiness_gate.csv"
DEFAULT_MD = ROOT / "data" / "manifests" / "datasets" / "dataset_fiche_readiness_gate.md"

PENDING_VALUES = {
    "",
    "pending",
    "none",
    "null",
    "na",
    "n/a",
    "unknown",
    "unavailable",
    "not_found",
    "not identified - manual review required",
    "no additional covariates beyond coordinates/identifiers (raster or grid dataset)",
}

NON_CONTINUOUS_TOKENS = {
    "classification",
    "presence_absence",
    "binary",
    "multiclass",
    "survival",
}

NON_REGRESSION_Y_TYPES = {
    "binary",
    "categorical",
    "identifier",
    "geometry",
    "timestamp",
}


@dataclass
class GateResult:
    path: str
    dataset_id: str
    package_include: str
    benchmark_status: str
    benchmark_task: str
    spatial_support: bool
    has_y: bool
    x_count: int
    has_formula: bool
    formula_source: str
    has_estimator_evidence: bool
    score_4: int
    passes_minimum_3_of_4: bool
    passes_package_gate: bool
    blockers: str
    next_action: str


def clean(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, (list, tuple, set)):
        return ", ".join(clean(v) for v in value if clean(v))
    return str(value).strip().strip("`").strip().strip('"').strip("'")


def is_pending(value: Any) -> bool:
    text = clean(value).lower()
    if text in PENDING_VALUES:
        return True
    return text.startswith("pending") or text.startswith("not_applicable")


def strip_front_matter(text: str) -> str:
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) == 3:
            return parts[2]
    return text


def bullet_value(text: str, label: str) -> str:
    pattern = rf"(?im)^\s*-\s+{re.escape(label)}[^:\n]*:\s*(.+?)\s*$"
    match = re.search(pattern, text)
    return clean(match.group(1)) if match else ""


def section(text: str, heading: str) -> str:
    match = re.search(rf"(?ms)^##\s+{re.escape(heading)}\s*$\n(.*?)(?=^##\s+|\Z)", text)
    return match.group(1) if match else ""


def parse_benchmark_readiness(text: str) -> dict[str, str]:
    match = re.search(r"(?ms)```yaml\s*\n\s*benchmark_readiness:\s*(.*?)\n```", text)
    if not match:
        return {}
    out: dict[str, str] = {}
    for line in match.group(1).splitlines():
        m = re.match(r"\s*([A-Za-z_]+):\s*(.*?)\s*$", line)
        if m:
            out[m.group(1)] = clean(m.group(2))
    return out


def parse_inline_list(value: str) -> list[str]:
    value = clean(value)
    if is_pending(value):
        return []
    backticks = re.findall(r"`([^`]+)`", value)
    if backticks:
        return [item.strip() for item in backticks if item.strip()]
    if value.startswith("[") and value.endswith("]"):
        try:
            parsed = json.loads(value.replace("'", '"'))
            if isinstance(parsed, list):
                return [clean(item) for item in parsed if clean(item)]
        except json.JSONDecodeError:
            pass
    if "," in value:
        return [item.strip() for item in value.split(",") if item.strip()]
    if "+" in value:
        return [item.strip() for item in value.split("+") if item.strip()]
    return [value] if value else []


def formula_parts(formula: str) -> tuple[str, list[str]]:
    formula = clean(formula)
    if is_pending(formula) or "~" not in formula:
        return "", []
    lhs, rhs = formula.split("~", 1)
    lhs = clean(lhs)
    rhs = re.sub(r"\[[^\]]+\]", "", rhs)
    rhs = re.sub(r"\.\.\..*$", "", rhs)
    terms = [clean(term) for term in rhs.split("+")]
    terms = [term for term in terms if term and term != "1"]
    return lhs, terms


def formula_source(text: str) -> str:
    model_block = re.search(r"(?ms)```yaml\s*\n\s*modeling_evidence:\s*(.*?)\n```", text)
    if model_block:
        source_type = ""
        existing = ""
        for line in model_block.group(1).splitlines():
            m = re.match(r"\s*([A-Za-z_]+):\s*(.*?)\s*$", line)
            if not m:
                continue
            if m.group(1) == "source_type":
                source_type = clean(m.group(2))
            elif m.group(1) == "existing_model_found":
                existing = clean(m.group(2)).lower()
        if existing == "true" or source_type in {
            "scientific_publication",
            "scientific_publication_or_package_documentation",
            "package_documentation",
            "project_curated",
        }:
            return source_type or "modeling_evidence"

    ref = bullet_value(text, "Reference publication")
    if not is_pending(ref):
        return "reference_publication"
    note = bullet_value(text, "Note")
    if "Formule/reference verifiee" in note or "validated" in note.lower():
        return "curated_note"
    return ""


def has_estimator_evidence(text: str) -> bool:
    block = section(text, "Estimator eligibility")
    if not block:
        return False
    if "eligible_estimators: []" in block and "conditional_estimators: []" in block:
        return False
    if re.search(r"(?im)eligible_estimators:\s*\[[^\]]*[A-Za-z0-9_][^\]]*\]", block):
        return True
    if re.search(r"(?im)conditional_estimators:\s*\[[^\]]*[A-Za-z0-9_][^\]]*\]", block):
        return True
    return "## Estimator eligibility" in text and not re.search(
        r"missing executable formula_used|not currently an executable|hors de propos",
        block,
        flags=re.IGNORECASE,
    )


def spatial_support(text: str) -> bool:
    coords = bullet_value(text, "Coordinates (x, y")
    geom = bullet_value(text, "Type de geometrie")
    local_artifact = bool(re.search(r"data/final_datasets/sf/[^\s`\]]+\.(?:rds|gpkg)", text))
    if coords and not is_pending(coords) and "none detected" not in coords.lower():
        return True
    if geom and not is_pending(geom) and geom.lower() not in {"geometrycollection", "unknown"}:
        return True
    return local_artifact and "sf" in text.lower()


def x_count_from_text(text: str, formula_x: list[str]) -> int:
    count_value = bullet_value(text, "Candidate X count")
    if count_value:
        m = re.search(r"\d+", count_value)
        if m:
            return int(m.group(0))

    x_used = parse_inline_list(bullet_value(text, "x_terms_used"))
    if x_used:
        return len(x_used)

    x_vars = parse_inline_list(bullet_value(text, "Candidate X variables"))
    if x_vars:
        return len(x_vars)

    return len(formula_x)


def y_typology(text: str) -> str:
    value = bullet_value(text, "Candidate Y typology")
    return clean(value).lower()


def is_documented_non_regression_task(benchmark_task: str) -> bool:
    task = clean(benchmark_task).lower()
    return any(token in task for token in {"classification", "sdm", "presence_absence", "binary", "multiclass"})


def evaluate(path: Path, repo_root: Path) -> GateResult:
    raw = path.read_text(encoding="utf-8", errors="replace")
    text = strip_front_matter(raw)
    readiness = parse_benchmark_readiness(text)
    dataset_id = bullet_value(text, "Dataset ID") or path.stem
    dataset_id = dataset_id.strip("`")
    formula_used = bullet_value(text, "formula_used")
    formula_pub = bullet_value(text, "formula_pub")
    response, formula_x = formula_parts(formula_used)
    if not response:
        response = bullet_value(text, "y_term_used") or bullet_value(text, "Candidate Y variables")

    package_include = readiness.get("package_include", "manual_review")
    benchmark_status = readiness.get("benchmark_status", "not_assessed")
    benchmark_task = readiness.get("benchmark_task", "")
    y_type = y_typology(text)
    documented_non_regression = is_documented_non_regression_task(benchmark_task)
    has_y = not is_pending(response)
    x_count = x_count_from_text(text, formula_x)
    has_formula = not is_pending(formula_used) and "~" in formula_used
    f_source = formula_source(text)
    formula_defensible = has_formula and bool(f_source)
    estimator_ok = has_estimator_evidence(text)
    spatial_ok = spatial_support(text)

    x_defensible = x_count >= 2 or (x_count >= 1 and formula_defensible)

    score = sum([has_y, x_defensible, formula_defensible, estimator_ok])
    blockers: list[str] = []
    if not spatial_ok:
        blockers.append("spatial_support_missing")
    if not has_y:
        blockers.append("response_y_missing_or_not_regression_usable")
    if not x_defensible:
        blockers.append("less_than_two_covariates")
    if not has_formula:
        blockers.append("formula_used_missing_or_pending")
    elif not formula_defensible:
        blockers.append("formula_not_source_backed")
    if not estimator_ok:
        blockers.append("estimator_evidence_missing")
    if (
        (y_type in NON_REGRESSION_Y_TYPES or any(token in benchmark_task.lower() for token in NON_CONTINUOUS_TOKENS))
        and not documented_non_regression
    ):
        blockers.append("current_package_regression_only")

    passes_package = (
        package_include == "yes"
        and benchmark_status == "ready"
        and spatial_ok
        and has_y
        and x_defensible
        and formula_defensible
        and estimator_ok
        and "current_package_regression_only" not in blockers
    )

    if passes_package:
        next_action = "OK package benchmark"
    elif score >= 3 and spatial_ok:
        next_action = "source review / reconcile missing criterion"
    elif not has_y or not x_defensible:
        next_action = "complete loader or raw data before stable fiche"
    elif not formula_defensible:
        next_action = "read paper/TEI and add source-backed formula"
    elif not estimator_ok:
        next_action = "add estimator eligibility from paper/package source"
    else:
        next_action = "manual review"

    rel = path.relative_to(repo_root).as_posix()
    return GateResult(
        path=rel,
        dataset_id=dataset_id,
        package_include=package_include,
        benchmark_status=benchmark_status,
        benchmark_task=benchmark_task,
        spatial_support=spatial_ok,
        has_y=has_y,
        x_count=x_count,
        has_formula=has_formula,
        formula_source=f_source,
        has_estimator_evidence=estimator_ok,
        score_4=score,
        passes_minimum_3_of_4=spatial_ok and score >= 3,
        passes_package_gate=passes_package,
        blockers=", ".join(blockers),
        next_action=next_action,
    )


def write_reports(results: list[GateResult], csv_path: Path, md_path: Path) -> None:
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    md_path.parent.mkdir(parents=True, exist_ok=True)
    rows = [asdict(result) for result in results]
    with csv_path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()) if rows else [])
        if rows:
            writer.writeheader()
            writer.writerows(rows)

    total = len(results)
    ready = sum(result.passes_package_gate for result in results)
    min3 = sum(result.passes_minimum_3_of_4 for result in results)
    package_bad = [
        result for result in results
        if result.package_include == "yes" and not result.passes_package_gate
    ]
    lines = [
        "# Dataset Fiche Readiness Gate",
        "",
        f"- Fiches checked: {total}",
        f"- Pass package gate: {ready}",
        f"- Pass minimum 3/4 plus spatial support: {min3}",
        f"- Blocking package_include=yes failures: {len(package_bad)}",
        "",
        "## Blocking Failures",
        "",
    ]
    if package_bad:
        lines.extend([
            "| Dataset | Status | Blockers | Next action |",
            "|---|---|---|---|",
        ])
        for result in package_bad:
            lines.append(
                f"| `{result.dataset_id}` | {result.benchmark_status} | {result.blockers} | {result.next_action} |"
            )
    else:
        lines.append("No `package_include: yes` fiche fails the package gate.")

    review = [
        result for result in results
        if not result.passes_package_gate and result.passes_minimum_3_of_4
    ][:80]
    lines.extend(["", "## 3/4 Candidates", ""])
    if review:
        lines.extend([
            "| Dataset | Score | Missing / blockers | Next action |",
            "|---|---:|---|---|",
        ])
        for result in review:
            lines.append(
                f"| `{result.dataset_id}` | {result.score_4}/4 | {result.blockers} | {result.next_action} |"
            )
    else:
        lines.append("No 3/4 non-package candidate found.")

    md_path.write_text("\n".join(lines) + "\n", encoding="utf-8", newline="\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("paths", nargs="*", type=Path, help="Specific fiches to check.")
    parser.add_argument("--repo-root", type=Path, default=ROOT)
    parser.add_argument("--all", action="store_true", help="Check all dataset fiches, not only paper_*.md.")
    parser.add_argument("--strict-stable", action="store_true", help="Fail any stable fiche below 3/4 plus spatial support.")
    parser.add_argument("--no-report", action="store_true", help="Do not write CSV/Markdown reports.")
    parser.add_argument("--csv-out", type=Path, default=DEFAULT_CSV)
    parser.add_argument("--md-out", type=Path, default=DEFAULT_MD)
    args = parser.parse_args()

    repo_root = args.repo_root.resolve()
    if args.paths:
        paths = [(p if p.is_absolute() else repo_root / p) for p in args.paths]
    else:
        pattern = "*.md" if args.all else "paper_*.md"
        paths = sorted((repo_root / "wiki" / "datasets" / "fiches_datasets").glob(pattern))

    results = [evaluate(path, repo_root) for path in paths if path.exists()]
    if not args.no_report:
        write_reports(results, args.csv_out, args.md_out)

    package_failures = [
        result for result in results
        if result.package_include == "yes" and not result.passes_package_gate
    ]
    strict_failures = [
        result for result in results
        if not result.passes_minimum_3_of_4
    ] if args.strict_stable else []

    print(f"Checked fiches: {len(results)}")
    print(f"Pass package gate: {sum(r.passes_package_gate for r in results)}")
    print(f"Pass minimum 3/4 + spatial: {sum(r.passes_minimum_3_of_4 for r in results)}")
    print(f"Blocking package failures: {len(package_failures)}")
    if strict_failures:
        print(f"Strict stable failures: {len(strict_failures)}")
    if not args.no_report:
        print(f"CSV: {args.csv_out}")
        print(f"MD: {args.md_out}")

    if package_failures or strict_failures:
        for result in package_failures[:20]:
            print(f"FAIL package {result.dataset_id}: {result.blockers}", file=sys.stderr)
        for result in strict_failures[:20]:
            print(f"FAIL strict {result.dataset_id}: {result.blockers}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
