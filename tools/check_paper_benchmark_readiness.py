#!/usr/bin/env python
"""Check paper-derived dataset fiches before package promotion.

This script is intentionally stricter than the general wiki evaluator. Its job
is not to grade a fiche; it prevents a paper/DataCite/warehouse candidate from
being treated as a usable spatialtidymodels benchmark before the required
readiness evidence exists.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]

ALLOWED_STATUSES = {
    "ready",
    "almost_ready",
    "almost_ready_crs_unverified",
    "almost_ready_partial_coverage",
    "almost_ready_simulation",
    "manual_review",
    "manual_review_derived_reconstruction",
    "needs_preprocessing",
    "needs_covariate_join",
    "needs_original_W",
    "needs_response_reconstruction",
    "needs_model_specification_review",
    "manual_review_derived_reconstruction",
    "not_ready_current_package",
    "not_ready_prediction_product",
    "not_ready_derived_response",
    "not_ready_derived_clusters",
    "not_ready_geostatistical_univariate",
    "not_ready_relevance_check",
    "excluded",
    "not_assessed",
}

READY_FOR_PACKAGE = {"ready"}
MANUAL_REVIEW_OK = {
    "ready",
    "almost_ready",
    "almost_ready_crs_unverified",
    "almost_ready_partial_coverage",
    "almost_ready_simulation",
    "needs_preprocessing",
    "needs_covariate_join",
    "needs_original_W",
    "needs_response_reconstruction",
    "needs_model_specification_review",
    "manual_review_derived_reconstruction",
}


def clean_scalar(value: str) -> str:
    return value.strip().strip('"').strip("'").strip()


def extract_block(text: str) -> str | None:
    match = re.search(r"(?ms)```yaml\s*\n\s*benchmark_readiness:\s*(.*?)\n```", text)
    return match.group(1) if match else None


def parse_block(block: str | None) -> dict[str, str]:
    out: dict[str, str] = {}
    if not block:
        return out
    for raw_line in block.splitlines():
        match = re.match(r"\s*([A-Za-z_]+):\s*(.*?)\s*$", raw_line.rstrip())
        if match:
            out[match.group(1)] = clean_scalar(match.group(2))
    return out


def has_nonempty_bullet(text: str, label: str) -> bool:
    match = re.search(rf"(?im)^\s*-\s+{re.escape(label)}:\s*(.+?)\s*$", text)
    if not match:
        return False
    value = clean_scalar(match.group(1))
    return bool(value and value.lower() not in {"pending", "none", "n/a", "not_applicable", "unavailable"})


def check_fiche(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8", errors="replace")
    block = parse_block(extract_block(text))
    errors: list[str] = []
    status = block.get("benchmark_status", "not_assessed")
    package_include = block.get("package_include", "manual_review")

    if not block:
        errors.append("missing benchmark_readiness block")
        return errors

    if status not in ALLOWED_STATUSES:
        errors.append(f"unknown benchmark_status: {status}")

    if package_include not in {"yes", "no", "manual_review"}:
        errors.append(f"invalid package_include: {package_include}")

    if package_include == "yes" and status not in READY_FOR_PACKAGE:
        errors.append("package_include=yes is allowed only with benchmark_status=ready")

    if package_include == "manual_review" and status not in MANUAL_REVIEW_OK:
        errors.append(f"manual_review status is inconsistent with {status}")

    if package_include == "yes":
        required_bullets = [
            "formula_used",
            "y_term_used",
            "x_terms_used",
            "Candidate Y variables",
            "Candidate X variables",
            "Source URL",
        ]
        for label in required_bullets:
            if not has_nonempty_bullet(text, label):
                errors.append(f"package_include=yes but missing/non-final field: {label}")

        if not re.search(r"data/final_datasets/sf/[^\s`\]]+\.(rds|gpkg)", text):
            errors.append("package_include=yes but no local final dataset artifact is referenced")

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="Check paper-derived benchmark readiness blocks.")
    parser.add_argument("--repo-root", type=Path, default=ROOT)
    parser.add_argument("--quiet", action="store_true")
    args = parser.parse_args()

    fiches_dir = args.repo_root / "wiki" / "datasets" / "fiches_datasets"
    paths = sorted(fiches_dir.glob("paper_*.md"))
    failures: list[tuple[Path, list[str]]] = []
    for path in paths:
        errors = check_fiche(path)
        if errors:
            failures.append((path, errors))

    if not args.quiet:
        print(f"Checked paper fiches: {len(paths)}")
        if failures:
            print(f"Failures: {len(failures)}")
            for path, errors in failures:
                rel = path.relative_to(args.repo_root)
                print(f"- {rel}")
                for error in errors:
                    print(f"  * {error}")
        else:
            print("All paper benchmark readiness checks passed.")

    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
