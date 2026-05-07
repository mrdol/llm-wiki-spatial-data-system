"""Prepare estimator fiche inventory from raw paper filenames.

This script does not read or modify raw paper files. It maps known raw paper
filenames to the restricted estimator allowlist and reports which wiki fiche
pages exist, are missing, or still need paper extraction.
"""

from __future__ import annotations

import argparse
import json
from dataclasses import asdict, dataclass
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]
RAW_PAPER_DIR = REPO_ROOT / "raw" / "paper"
ESTIMATOR_DIR = REPO_ROOT / "wiki" / "estimators"


@dataclass(frozen=True)
class EstimatorMapping:
    estimator: str
    slug: str
    fiche_path: str
    candidate_papers: list[str]
    fiche_exists: bool
    extraction_status: str


ESTIMATOR_PAPER_HINTS: dict[str, tuple[str, list[str]]] = {
    "XGBoost": ("xgboost", ["XGBoost.pdf"]),
    "LightGBM": ("lightgbm", ["LightGBM.pdf"]),
    "GAMBoost": ("gamboost", ["GAMboosting.pdf"]),
    "Random Forest": ("random_forest", ["randomforest2001.pdf"]),
    "MARS": ("mars", ["Earth_MARS__a_note_on_earth.pdf"]),
    "INLA": ("inla", ["OpitzINLA.pdf"]),
    "STVC": (
        "stvc",
        ["Geographical Analysis - 2025 - Murakami - Fast Spatio‐Temporally Varying Coefficient Modeling With Reluctant Interaction.pdf"],
    ),
    "SVC": ("svc", ["SVC_Murakami.pdf"]),
    "MGWR": ("mgwr", ["Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.pdf"]),
    "MGWRSAR": ("mgwrsar", ["MGWR-SAR_Geniaux&Martinetti.pdf"]),
    "SpBoost": ("spboost", ["spbbost_article.pdf"]),
    "RNN": ("rnn", []),
    "SVM": ("svm", ["ISLRv2_corrected_June_2023.pdf"]),
}


def build_inventory() -> list[EstimatorMapping]:
    raw_files = {path.name for path in RAW_PAPER_DIR.glob("*") if path.is_file()}
    inventory: list[EstimatorMapping] = []
    for estimator, (slug, paper_hints) in ESTIMATOR_PAPER_HINTS.items():
        fiche = ESTIMATOR_DIR / f"{slug}.md"
        candidate_papers = [paper for paper in paper_hints if paper in raw_files]
        missing_papers = [paper for paper in paper_hints if paper not in raw_files]
        if not paper_hints:
            extraction_status = "documentation_not_yet_provided"
        elif missing_papers:
            extraction_status = "paper_file_missing"
        elif fiche.exists():
            extraction_status = "fiche_template_ready_pending_extraction"
        else:
            extraction_status = "fiche_missing"
        inventory.append(
            EstimatorMapping(
                estimator=estimator,
                slug=slug,
                fiche_path=str(fiche),
                candidate_papers=candidate_papers,
                fiche_exists=fiche.exists(),
                extraction_status=extraction_status,
            )
        )
    return inventory


def main() -> None:
    parser = argparse.ArgumentParser(description="Prepare estimator fiche inventory from raw paper filenames.")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output.")
    parser.add_argument("--write", help="Optional path to write the inventory JSON.")
    args = parser.parse_args()

    payload = {
        "raw_paper_dir": str(RAW_PAPER_DIR),
        "estimator_dir": str(ESTIMATOR_DIR),
        "cross_validation_policy": "CV scheme is fixed by the project owner outside estimator fiches.",
        "records": [asdict(record) for record in build_inventory()],
    }

    if args.write:
        path = Path(args.write)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(json.dumps(payload, indent=2, ensure_ascii=True), encoding="utf-8")

    if args.pretty:
        print(json.dumps(payload, indent=2, ensure_ascii=True))
    else:
        print(json.dumps(payload, ensure_ascii=True))


if __name__ == "__main__":
    main()
