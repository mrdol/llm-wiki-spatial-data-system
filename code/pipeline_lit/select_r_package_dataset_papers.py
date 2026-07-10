"""Select papers linked only to R package datasets.

This selector intentionally reads only the audit CSV generated from R dataset
documentation. It does not use the broader paper manifests or OpenAlex
discovery catalogs.
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INPUT = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_paper_formula_audit.csv"
DEFAULT_OUTPUT = ROOT / "data" / "manifests" / "datasets" / "software_r_dataset_papers_selected_for_download.csv"

SPATIAL_TERMS = (
    "spatial",
    "spatio",
    "geographic",
    "geographical",
    "geographically",
    "geostat",
    "gwr",
    "mgwr",
    "krig",
    "landslide",
    "coordinates",
    "latitude",
    "longitude",
    "regional",
    "areal",
    "point pattern",
)

SPATIOTEMPORAL_TERMS = (
    "spatio-temporal",
    "spatiotemporal",
    "space-time",
    "space time",
    "temporally",
    "temporal",
    "time series",
    "panel",
    "longitudinal",
)

MODEL_TERMS = (
    "regression",
    "model",
    "glm",
    "generalized linear",
    "mixed",
    "bayesian",
    "prediction",
    "forecast",
    "kriging",
    "gwr",
    "ammi",
    "anova",
    "response surface",
    "threshold",
)


def clean(value: Any) -> str:
    return re.sub(r"\s+", " ", str(value or "")).strip()


def normalize_doi(value: str | None) -> str:
    doi = clean(value).lower()
    doi = doi.replace("https://doi.org/", "").replace("http://dx.doi.org/", "")
    doi = doi.replace("doi:", "").rstrip(".")
    return doi if doi.startswith("10.") else ""


def as_year(value: Any) -> int:
    match = re.search(r"\b(19|20)\d{2}\b", str(value or ""))
    return int(match.group(0)) if match else 0


def term_hits(text: str, terms: tuple[str, ...]) -> list[str]:
    lower = text.lower()
    return sorted({term for term in terms if term in lower})


def read_rows(path: Path) -> list[dict[str, str]]:
    with path.open(encoding="utf-8-sig", newline="") as fh:
        return list(csv.DictReader(fh, delimiter=";"))


def merge_by_doi(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    grouped: dict[str, dict[str, str]] = {}
    for row in rows:
        doi = normalize_doi(row.get("doi"))
        if not doi:
            continue
        if row.get("doi_verified") not in {"yes", "catalog", ""}:
            continue
        current = grouped.setdefault(doi, dict(row))
        current["doi"] = doi
        pairs = set(filter(None, clean(current.get("package_dataset_pairs")).split(" | ")))
        package = clean(row.get("package"))
        dataset = clean(row.get("dataset"))
        if package and dataset:
            pairs.add(f"{package}::{dataset}")
        current["package_dataset_pairs"] = " | ".join(sorted(pairs))

        for key in (
            "package",
            "dataset",
            "doi_url",
            "paper_or_book_title",
            "authors",
            "year",
            "venue",
            "doi_type",
            "model_or_equation_found_locally",
            "model_keywords",
            "detected_reference",
            "source_url",
            "doc_path",
        ):
            if not clean(current.get(key)) and clean(row.get(key)):
                current[key] = row[key]

    return list(grouped.values())


def score_row(row: dict[str, str]) -> dict[str, str]:
    text = " ".join(
        clean(row.get(key))
        for key in (
            "package",
            "dataset",
            "paper_or_book_title",
            "venue",
            "model_or_equation_found_locally",
            "model_keywords",
            "detected_reference",
            "doc_path",
        )
    )
    spatial_hits = term_hits(text, SPATIAL_TERMS)
    st_hits = term_hits(text, SPATIOTEMPORAL_TERMS)
    model_hits = term_hits(text, MODEL_TERMS)
    row["selection_spatial_terms"] = ", ".join(spatial_hits)
    row["selection_spatiotemporal_terms"] = ", ".join(st_hits)
    row["selection_model_terms"] = ", ".join(model_hits)
    row["selection_score"] = str(len(spatial_hits) * 3 + len(st_hits) * 4 + len(model_hits))
    return row


def select_rows(rows: list[dict[str, str]], *, limit: int, require_spatial: bool) -> list[dict[str, str]]:
    merged = [score_row(row) for row in merge_by_doi(rows)]
    selected = []
    for row in merged:
        if require_spatial and not (row["selection_spatial_terms"] or row["selection_spatiotemporal_terms"]):
            continue
        selected.append(row)

    selected.sort(
        key=lambda row: (
            as_year(row.get("year")),
            int(row.get("selection_score") or 0),
            clean(row.get("paper_or_book_title")),
        ),
        reverse=True,
    )
    return selected[:limit]


def write_rows(rows: list[dict[str, str]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fields = [
        "package",
        "dataset",
        "package_dataset_pairs",
        "reference_type",
        "doi",
        "doi_url",
        "source_url",
        "doi_verified",
        "doi_type",
        "paper_or_book_title",
        "authors",
        "year",
        "venue",
        "publisher",
        "model_or_equation_found_locally",
        "model_keywords",
        "detected_reference",
        "local_raw_match",
        "doc_path",
        "verification_note",
        "selection_score",
        "selection_spatial_terms",
        "selection_spatiotemporal_terms",
        "selection_model_terms",
    ]
    with path.open("w", encoding="utf-8-sig", newline="") as fh:
        writer = csv.DictWriter(fh, delimiter=";", fieldnames=fields, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=DEFAULT_INPUT)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--limit", type=int, default=200)
    parser.add_argument("--all-r-package-papers", action="store_true")
    args = parser.parse_args()

    rows = read_rows(args.input)
    selected = select_rows(
        rows,
        limit=args.limit,
        require_spatial=not args.all_r_package_papers,
    )
    write_rows(selected, args.output)

    print(f"selected={len(selected)}")
    print(f"output={args.output}")
    if selected:
        print(f"newest_year={selected[0].get('year')}")
        print(f"oldest_selected_year={selected[-1].get('year')}")


if __name__ == "__main__":
    main()
