"""Exporte les comptes d'estimateurs affiches dans le rapport de stage.

La source est `packages/spatialtidymodels/inst/metadata/datasets.json`.
Le rapport ne recopie donc plus de valeurs comme "11 variantes" : les macros
LaTeX comptent les routes effectivement autorisees pour le benchmark.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


DATASET_MACROS = {
    "boston_housing": "BostonEligibleCount",
    "paper_spatial_confounding_diabetes": "DiabetesEligibleCount",
    "paper_dragonfly_diversity_europe": "DragonflyEligibleCount",
    "paper_florida_crash_gsvcm": "FloridaEligibleCount",
    "paper_seshat_social_complexity": "SeshatEligibleCount",
    "paper_airbnb_europe_prices": "AirbnbEligibleCount",
}


def export_counts(repo_root: Path, output: Path) -> None:
    metadata_path = repo_root / "packages" / "spatialtidymodels" / "inst" / "metadata" / "datasets.json"
    payload = json.loads(metadata_path.read_text(encoding="utf-8"))
    records = {record["dataset"]: record for record in payload["records"]}

    missing = sorted(set(DATASET_MACROS) - set(records))
    if missing:
        raise RuntimeError(f"Datasets absents des metadonnees : {', '.join(missing)}")

    lines = ["% Fichier genere par code/package_metadata/export_report_eligibility_counts.py."]
    for dataset, macro in DATASET_MACROS.items():
        count = len(records[dataset].get("benchmark_estimators", []))
        lines.append(f"\\newcommand{{\\{macro}}}{{{count}}}")
    lines.append("")

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(lines), encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo-root", type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Par defaut : Memoire/Rapport de stage/generated/eligibility_counts.tex",
    )
    args = parser.parse_args()
    repo_root = args.repo_root.resolve()
    output = args.output or repo_root / "Mémoire" / "Rapport de stage" / "generated" / "eligibility_counts.tex"
    export_counts(repo_root, output)
    print(f"Wrote {output}")


if __name__ == "__main__":
    main()
