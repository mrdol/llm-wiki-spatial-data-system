"""Construit le catalogue analytique des datasets fournis par Python.

La logique est volontairement alignee sur create_r_software_catalog.R :
- retrait des identifiants, noms, dates, coordonnees et geometries ;
- calcul de k a partir des variables analytiques ;
- classement dans les memes groupes R/Python.

Le script reutilise l'inventaire et les fichiers locaux produits par
extract_python_software_datasets.py.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
import unicodedata
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[2]
SCRIPT_DIR = Path(__file__).resolve().parent
if str(SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(SCRIPT_DIR))

from Inspection_of_each_python_dataset import (  # noqa: E402
    catalog_python_datasets,
    read_jsonl,
    split_variables,
)


DEFAULT_OUTPUT = (
    REPO_ROOT
    / "data"
    / "manifests"
    / "datasets"
    / "software_python_catalog_classified.jsonl"
)

MIN_MODEL_ROWS = 10

KNOWN_DATASET_REFERENCES = {
    ("libpysal", "baltimore"): {
        "has_referenced_paper": "Yes",
        "paper_doi": "10.1016/0166-0462(92)90038-J",
        "paper_doi_status": "doi_found",
        "paper_title": "Spatial autocorrelation and neighborhood quality",
        "paper_reference_evidence": (
            "Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood "
            "quality. Regional Science and Urban Economics 22(3), 433-452."
        ),
        "paper_evidence_status": "known_dataset_reference",
        "paper_use_summary": (
            "Hedonic housing-price application using Baltimore house sales and "
            "spatial autocorrelation/neighborhood quality."
        ),
        "paper_model_keywords": "spatial autocorrelation, hedonic pricing, neighborhood quality",
    },
    ("libpysal", "baltim"): {
        "has_referenced_paper": "Yes",
        "paper_doi": "10.1016/0166-0462(92)90038-J",
        "paper_doi_status": "doi_found",
        "paper_title": "Spatial autocorrelation and neighborhood quality",
        "paper_reference_evidence": (
            "Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood "
            "quality. Regional Science and Urban Economics 22(3), 433-452."
        ),
        "paper_evidence_status": "known_dataset_reference",
        "paper_use_summary": (
            "Hedonic housing-price application using Baltimore house sales and "
            "spatial autocorrelation/neighborhood quality."
        ),
        "paper_model_keywords": "spatial autocorrelation, hedonic pricing, neighborhood quality",
    },
}


def normalize_name(value: str) -> str:
    value = unicodedata.normalize("NFKD", str(value))
    value = "".join(ch for ch in value if not unicodedata.combining(ch))
    return re.sub(r"^_+|_+$", "", re.sub(r"[^a-z0-9]+", "_", value.lower()))


def semantic_name(value: str) -> str:
    """Retire les suffixes de millesime pour reconnaitre CODE21, NAME_2024, etc."""
    normalized = normalize_name(value)
    return re.sub(r"_?\d{2,4}$", "", normalized)


def split_local_files(value: Any) -> list[Path]:
    if not value:
        return []
    files: list[Path] = []
    for item in str(value).split(","):
        item = item.strip()
        if not item:
            continue
        path = Path(item)
        if not path.is_absolute():
            path = REPO_ROOT / path
        files.append(path)
    return files


def sample_csv(path: Path, max_rows: int = 500) -> dict[str, list[Any]]:
    try:
        csv.field_size_limit(sys.maxsize)
    except OverflowError:
        csv.field_size_limit(2_147_483_647)
    for encoding in ("utf-8-sig", "utf-8", "latin-1"):
        try:
            with path.open("r", encoding=encoding, newline="") as handle:
                sample = handle.read(8192)
                handle.seek(0)
                try:
                    dialect = csv.Sniffer().sniff(sample, delimiters=",;\t|")
                except csv.Error:
                    dialect = csv.excel
                reader = csv.DictReader(handle, dialect=dialect)
                values: dict[str, list[Any]] = {
                    name: [] for name in (reader.fieldnames or []) if name
                }
                for index, row in enumerate(reader):
                    if index >= max_rows:
                        break
                    for name in values:
                        values[name].append(row.get(name))
                return values
        except (UnicodeError, OSError, csv.Error):
            continue
    return {}


def sample_geojson(path: Path, max_rows: int = 500) -> dict[str, list[Any]]:
    # Les gros GeoJSON ont toujours un export CSV associe dans notre pipeline.
    # Eviter de charger 50-200 Mo en memoire uniquement pour profiler 500 lignes.
    try:
        if path.stat().st_size > 25 * 1024 * 1024:
            return {}
    except OSError:
        return {}
    try:
        payload = json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, UnicodeError, json.JSONDecodeError):
        return {}
    features = payload.get("features", []) if isinstance(payload, dict) else []
    values: dict[str, list[Any]] = {}
    for feature in features[:max_rows]:
        props = feature.get("properties") or {}
        for name, value in props.items():
            values.setdefault(str(name), []).append(value)
    return values


def sample_local_columns(row: dict[str, Any]) -> dict[str, list[Any]]:
    for path in split_local_files(row.get("local_files")):
        if not path.exists():
            continue
        suffix = path.suffix.lower()
        if suffix in {".csv", ".tsv", ".txt"}:
            values = sample_csv(path)
        elif suffix in {".geojson", ".json"}:
            values = sample_geojson(path)
        else:
            values = {}
        if values:
            return values
    return {}


def is_key_like(values: list[Any]) -> bool:
    cleaned = [value for value in values if value not in (None, "", "NA", "NaN")]
    if not cleaned:
        return False
    unique = {str(value) for value in cleaned}
    ratio = len(unique) / len(cleaned)
    if len(unique) >= min(20, max(5, len(cleaned) // 2)) and ratio >= 0.90:
        return True
    try:
        numbers = sorted(int(str(value)) for value in cleaned)
    except ValueError:
        return False
    return len(numbers) == len(set(numbers)) and numbers == list(
        range(min(numbers), max(numbers) + 1)
    )


def detect_identifier_columns(
    variables: list[str], description: str, sampled: dict[str, list[Any]]
) -> list[str]:
    explicit = re.compile(
        r"^(id|ids|name|names|label|labels|row_?id|record_?id|object_?id|"
        r"observation_?id|case_?id|subject_?id|person_?id|individual_?id)$|"
        r"(^id_|_id$|_identifier$|^identifier_|_name$|_label$|_lbl$|"
        r"^code_|_code$|_uri$|_url$)"
    )
    geographic = re.compile(
        r"^(geoid|geo_id|fips|nuts|area_key|areakey|sr_id|gridcode|"
        r"site_code|station_code|region_code|country_code|county_code|"
        r"municipality_code|commune_code|postal_code|zip_code)$"
    )
    ambiguous = re.compile(
        r"(^|_)(key|code|number|index|record|subject|individual|unit|station|site)($|_)"
    )
    documentation_says_identifier = re.compile(
        r"identifier|identification|unique[ -]?(id|code|number)|row number|"
        r"record number|observation number|case number|subject number|"
        r"individual number|name of (the )?|code for (the )?|index (of|for)",
        re.IGNORECASE,
    )
    description = str(description or "")

    result: list[str] = []
    for variable in variables:
        normalized = semantic_name(variable)
        values = sampled.get(variable, [])
        documented = bool(
            re.search(rf"(?i)(?<!\w){re.escape(variable)}(?!\w)", description)
            and documentation_says_identifier.search(description)
        )
        if (
            explicit.search(normalized)
            or geographic.search(normalized)
            or (ambiguous.search(normalized) and (documented or is_key_like(values)))
        ):
            result.append(variable)
    return result


def detect_metadata_columns(variables: list[str]) -> list[str]:
    """Detecte les drapeaux et libelles techniques qui ne sont pas des X."""
    pattern = re.compile(
        r"(^|_)(flag|chg_flag|change_flag|status|label|lbl|uri|url|href|link)($|_)"
    )
    return [name for name in variables if pattern.search(semantic_name(name))]


def nonmissing_values(values: list[Any]) -> list[Any]:
    return [value for value in values if value not in (None, "", "NA", "NaN", "null")]


def is_constant(values: list[Any]) -> bool:
    cleaned = nonmissing_values(values)
    return bool(cleaned) and len({str(value) for value in cleaned}) <= 1


def row_count(row: dict[str, Any]) -> int | None:
    try:
        value = int(float(str(row.get("n"))))
    except (TypeError, ValueError):
        return None
    return value if value >= 0 else None


def looks_like_reference_geometry(row: dict[str, Any], candidate_y: list[str], analytical: list[str]) -> bool:
    """Reconnait contours, masques et fonds de carte sans observations modelisables."""
    description = str(row.get("description") or "").lower()
    dataset = str(row.get("dataset") or row.get("dataset_key") or "").lower()
    reference_pattern = re.compile(
        r"\b(boundary|boundaries|border|borders|outline|land polygon|label points?|"
        r"basemap|base map|study area|mask|coastline|administrative geometry|"
        r"states? and territor(?:y|ies)|reference regions?)\b"
    )
    explicit_reference = bool(reference_pattern.search(f"{dataset} {description}"))
    return explicit_reference and not candidate_y


def coordinate_columns(variables: list[str]) -> list[str]:
    lowered = {normalize_name(name): name for name in variables}
    pairs = [
        ("x", "y"),
        ("lon", "lat"),
        ("long", "lat"),
        ("longitude", "latitude"),
        ("easting", "northing"),
        ("east", "north"),
        ("coord_x", "coord_y"),
        ("xcoord", "ycoord"),
        ("center_x", "center_y"),
        ("centroid_x", "centroid_y"),
        ("xc", "yc"),
        ("xaxis", "yaxis"),
    ]
    result: list[str] = []
    for left, right in pairs:
        if left in lowered and right in lowered:
            result.extend([lowered[left], lowered[right]])
    return list(dict.fromkeys(result))


def datetime_columns(variables: list[str]) -> list[str]:
    """Detecte des champs temporels par tokens, sans confondre candidates et date."""
    pattern = re.compile(
        r"(^|_)(year|date|datetime|time|month|week|day|period|timestamp|season|round)($|_)"
    )
    result: list[str] = []
    for name in variables:
        normalized = semantic_name(name)
        if "degree_day" in normalized or "degre_day" in normalized:
            continue
        if pattern.search(normalized):
            result.append(name)
    return result


def classify_row(row: dict[str, Any]) -> dict[str, Any]:
    variables = split_variables(row.get("variables"))
    sampled = sample_local_columns(row)
    identifiers = detect_identifier_columns(
        variables, str(row.get("description") or ""), sampled
    )
    metadata_columns = detect_metadata_columns(variables)
    coordinates = coordinate_columns(variables)
    dates = datetime_columns(variables)
    places = [
        name
        for name in variables
        if re.search(
            r"country|state|county|city|town|municip|commune|depart|district|"
            r"borough|province|village|locality|region|zip|postal|fips|tract|"
            r"neigh|place|nuts|geoid",
            normalize_name(name),
        )
    ]
    geometry = [
        name
        for name in variables
        if normalize_name(name) in {"geometry", "geom", "shape", "wkt"}
    ]
    excluded = set(identifiers + metadata_columns + coordinates + dates + places + geometry)

    analytical: list[str] = []
    for name in variables:
        if name in excluded:
            continue
        values = sampled.get(name, [])
        if is_constant(values):
            continue
        analytical.append(name)

    y_pattern = re.compile(
        r"(^y$|target|response|outcome|dependent|price|value|crime|homicide|"
        r"burgl|murder|death|mort|(^|_)rate($|_)|cases|count|incidence|income|"
        r"wage|employment|unemployment|yield|rent|sales|disease|sids|leuk|pop|"
        r"temperature|(^|_)temp($|_)|tair|velocity|precip|rain|concentration|"
        r"biomass|abundance|^v[xy]$)",
        re.IGNORECASE,
    )
    candidate_y = [name for name in analytical if y_pattern.search(semantic_name(name))]
    candidate_x = [name for name in analytical if name not in candidate_y]

    row = dict(row)
    row["source_language"] = "Python"
    row["identifier_variables"] = ", ".join(identifiers)
    row["metadata_variables"] = ", ".join(metadata_columns)
    row["analytical_variables"] = ", ".join(analytical)
    row["k"] = len(analytical)
    row["has_coordinates"] = "Yes" if coordinates else "No"
    row["coordinate_columns"] = ", ".join(coordinates)
    row["datetime_columns"] = ", ".join(dates)
    row["place_name_columns"] = ", ".join(places)
    row["candidate_y_variables"] = ", ".join(candidate_y)
    row["candidate_x_variables"] = ", ".join(candidate_x)
    row["has_y"] = "Yes" if candidate_y else "No"
    row["has_multiple_x"] = "Yes" if len(candidate_x) >= 2 else "No"

    spatial = (
        row.get("has_geometry") == "Yes"
        or bool(coordinates)
        or row.get("has_place_name_if_no_geometry") == "Yes"
    )
    n = row_count(row)
    enough_rows = n is not None and n >= MIN_MODEL_ROWS
    has_response = bool(candidate_y)
    has_covariates = len(candidate_x) >= 2
    reference_geometry = spatial and looks_like_reference_geometry(row, candidate_y, analytical)

    if reference_geometry:
        category = "Declasser auxiliaire"
        usage_role = "reference_geometry"
        reason = "contour/masque/couche de reference sans reponse modelisable"
    elif spatial and enough_rows and has_response and has_covariates:
        category = "Bons candidats spatial"
        usage_role = "spatial_model_candidate"
        reason = "geometrie, n suffisant, reponse et au moins deux covariables"
    elif spatial and analytical and (n is None or n >= 2):
        category = "Spatial simple"
        usage_role = "spatial_exploration"
        missing = []
        if not enough_rows:
            missing.append(f"n<{MIN_MODEL_ROWS}" if n is not None else "n inconnu")
        if not has_response:
            missing.append("reponse absente")
        if not has_covariates:
            missing.append("moins de deux covariables")
        reason = "; ".join(missing) or "preuves de modelisation incompletes"
    elif not spatial and enough_rows and has_response and has_covariates:
        category = "ML non spatial"
        usage_role = "nonspatial_model_candidate"
        reason = "n suffisant, reponse et au moins deux covariables"
    else:
        category = "Declasser auxiliaire"
        usage_role = "auxiliary_or_incomplete"
        reason = "preuves analytiques insuffisantes"
    row["final_category"] = category
    row["usage_role"] = usage_role
    row["classification_reason"] = reason

    reference_key = (
        normalize_name(str(row.get("package") or "")),
        normalize_name(
            str(
                row.get("dataset")
                or row.get("dataset_key")
                or row.get("main_file_or_entry")
                or ""
            )
        ),
    )
    known_reference = KNOWN_DATASET_REFERENCES.get(reference_key)
    if known_reference:
        row.update(known_reference)
    else:
        row.setdefault("has_referenced_paper", "")
        row.setdefault("paper_doi", "")
        row.setdefault("paper_doi_status", "")
        row.setdefault("paper_title", "")
        row.setdefault("paper_reference_evidence", "")
        row.setdefault("paper_evidence_status", "")
        row.setdefault("paper_use_summary", "")
        row.setdefault("paper_model_keywords", "")
    return row


def build_catalog(packages: list[str] | None = None) -> list[dict[str, Any]]:
    rows = catalog_python_datasets(packages=packages)
    if not rows and DEFAULT_OUTPUT.exists():
        # Les manifestes d'inventaire/extraction peuvent etre archives apres la
        # constitution du catalogue. Le JSONL classe devient alors la source de
        # reprise, sans perdre les chemins locaux et metadonnees deja collectes.
        rows = read_jsonl(DEFAULT_OUTPUT)
        if packages:
            wanted = {str(package).lower().replace("_", "-") for package in packages}
            rows = [
                row
                for row in rows
                if str(row.get("package") or "").lower().replace("_", "-") in wanted
            ]
        print(
            "[reprise] manifestes bruts absents; reclassement du catalogue Python existant",
            file=sys.stderr,
        )
    return [classify_row(row) for row in rows]


def save_catalog_jsonl(rows: list[dict[str, Any]], output_path: Path) -> None:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    with output_path.open("w", encoding="utf-8") as handle:
        for row in rows:
            handle.write(json.dumps(row, ensure_ascii=False, default=str) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--package", action="append", help="Package Python a traiter.")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    rows = build_catalog(packages=args.package)
    save_catalog_jsonl(rows, args.output)
    counts: dict[str, int] = {}
    for row in rows:
        category = str(row["final_category"])
        counts[category] = counts.get(category, 0) + 1
    print(f"Catalogue Python ecrit : {args.output}")
    print(f"Nombre de datasets : {len(rows)}")
    for category in sorted(counts):
        print(f"- {category}: {counts[category]}")


if __name__ == "__main__":
    main()
