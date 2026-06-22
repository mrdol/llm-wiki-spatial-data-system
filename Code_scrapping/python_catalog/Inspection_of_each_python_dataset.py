from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any


# Le script vit dans Code_scrapping/python_catalog/ : la racine du depot est
# donc deux niveaux au-dessus, pas Code_scrapping/.
PROJECT_ROOT = Path(__file__).resolve().parents[2]
MANIFEST_DIR = PROJECT_ROOT / "data" / "manifests" / "datasets"
INVENTORY_MANIFEST = MANIFEST_DIR / "software_python_dataset_inventory.jsonl"
EXTRACTED_MANIFEST = MANIFEST_DIR / "software_python_extracted_datasets.jsonl"


def read_jsonl(path: Path) -> list[dict[str, Any]]:
    # Lit un manifeste JSONL. Chaque ligne doit etre un objet JSON independant.
    if not path.exists():
        return []

    records: list[dict[str, Any]] = []
    with path.open("r", encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            records.append(json.loads(line))
    return records


def normalize_package_name(package: str) -> str:
    # Normalise les noms pour comparer "PyGeoDa", "pygeoda", etc.
    return package.lower().replace("_", "-")


def package_matches(record: dict[str, Any], packages: list[str] | None) -> bool:
    # Filtre les enregistrements sur un ou plusieurs packages.
    if packages is None:
        return True

    source = record.get("source_package") or record.get("package")
    if source is None:
        return False

    wanted = {normalize_package_name(pkg) for pkg in packages}
    return normalize_package_name(str(source)) in wanted


def dataset_key(record: dict[str, Any]) -> str:
    # Construit une cle stable de dataset.
    # Pour les fichiers embarques, dataset_key peut etre un chemin interne.
    return str(
        record.get("dataset_key")
        or record.get("dataset")
        or record.get("package_file")
        or "unknown_dataset"
    )


def group_key(record: dict[str, Any]) -> tuple[str, str]:
    # Groupe un dataset par package + cle dataset.
    return (str(record.get("source_package") or record.get("package")), dataset_key(record))


def guess_python_object_role(record: dict[str, Any]) -> str:
    # Propose un role pour distinguer un fichier principal d'un auxiliaire.
    status = record.get("inventory_status")
    extension = str(record.get("file_extension") or "").lower()
    key = dataset_key(record).lower()

    if status in {
        "listed_from_geodatasets_catalog",
        "listed_from_libpysal_examples",
        "listed_from_xarray_tutorial",
    }:
        return "main_dataset_catalog_entry"

    if status == "route_only_no_uniform_dataset_api":
        return "external_or_manual_route"

    if extension in {".shp", ".gpkg", ".geojson", ".nc", ".csv", ".parquet"}:
        return "main_data_file_candidate"

    if extension in {".dbf", ".shx", ".prj", ".cpg", ".qix"}:
        return "spatial_sidecar_file"

    if extension in {".json", ".txt", ".tsv"}:
        return "metadata_or_tabular_file"

    if "readme" in key or "license" in key:
        return "documentation_file"

    return "review"


def guess_keep_from_role(role: str) -> str:
    # Decision de conservation provisoire.
    if role in {"main_dataset_catalog_entry", "main_data_file_candidate"}:
        return "yes"
    if role in {"spatial_sidecar_file", "metadata_or_tabular_file", "documentation_file"}:
        return "yes_auxiliary"
    if role == "external_or_manual_route":
        return "review_external"
    return "review"


def variables_from_record(record: dict[str, Any]) -> str | None:
    # Recupere les variables quand elles ont ete detectees par l'extracteur.
    columns = record.get("column_names") or record.get("columns_preview")
    if isinstance(columns, list):
        return ", ".join(map(str, columns))
    return None


def project_path(path_text: str | None) -> Path | None:
    # Convertit un chemin relatif au projet en chemin absolu.
    if not path_text:
        return None

    path = Path(path_text)
    if path.is_absolute():
        return path
    return PROJECT_ROOT / path


def read_columns_from_csv(path: Path) -> tuple[str | None, int | None, int | None]:
    # Lit uniquement l'en-tete CSV et compte les lignes pour obtenir variables, N et K.
    import csv
    import sys

    # Certains exports CSV contiennent une colonne geometry en WKT tres longue.
    # On augmente donc la limite de taille des champs avant de compter les lignes.
    try:
        csv.field_size_limit(sys.maxsize)
    except OverflowError:
        csv.field_size_limit(2_147_483_647)

    try:
        with path.open("r", encoding="utf-8-sig", newline="") as fh:
            reader = csv.reader(fh)
            header = next(reader, [])
            rows = sum(1 for _ in reader)
    except UnicodeDecodeError:
        with path.open("r", encoding="latin-1", newline="") as fh:
            reader = csv.reader(fh)
            header = next(reader, [])
            rows = sum(1 for _ in reader)
    except Exception:  # noqa: BLE001
        return None, None, None

    return ", ".join(map(str, header)), rows, len(header)


def read_columns_from_vector(path: Path) -> tuple[str | None, int | None, int | None]:
    # Lit les colonnes d'un fichier vectoriel local avec geopandas.
    try:
        import geopandas as gpd

        frame = gpd.read_file(path)
    except Exception:  # noqa: BLE001
        return None, None, None

    return ", ".join(map(str, frame.columns)), int(frame.shape[0]), int(frame.shape[1])


def read_columns_from_netcdf(path: Path) -> tuple[str | None, int | None, int | None]:
    # Lit les variables d'un fichier NetCDF local avec xarray.
    try:
        import xarray as xr

        dataset = xr.open_dataset(path)
    except Exception:  # noqa: BLE001
        return None, None, None

    variables = list(map(str, dataset.data_vars))
    coords = list(map(str, dataset.coords))
    size = 1
    for value in dataset.sizes.values():
        size *= int(value)
    return ", ".join(variables + coords), size, len(variables)


def variables_from_local_records(local_records: list[dict[str, Any]]) -> tuple[str | None, int | None, int | None]:
    # Complete variables, N et K a partir des fichiers extraits localement.
    # On privilegie le CSV, puis le GeoJSON, puis les fichiers NetCDF.
    candidate_keys = ["local_csv", "local_geojson", "local_file"]

    for key in candidate_keys:
        for record in local_records:
            path = project_path(record.get(key))
            if path is None or not path.exists():
                continue

            suffix = path.suffix.lower()
            if suffix == ".csv":
                result = read_columns_from_csv(path)
            elif suffix in {".geojson", ".json", ".gpkg", ".shp"}:
                result = read_columns_from_vector(path)
            elif suffix == ".nc":
                result = read_columns_from_netcdf(path)
            else:
                result = (None, None, None)

            if result[0]:
                return result

    return None, None, None


def dimensions_from_record(record: dict[str, Any]) -> tuple[int | None, int | None]:
    # Renvoie les dimensions N,K quand elles existent dans le manifeste.
    n = record.get("rows") or record.get("nrows")
    k = record.get("columns") or record.get("ncols")

    dims = record.get("dims")
    if isinstance(dims, dict) and n is None:
        # Pour xarray, on conserve la taille totale approximative comme N.
        size = 1
        for value in dims.values():
            try:
                size *= int(value)
            except Exception:  # noqa: BLE001
                pass
        n = size
        k = len(record.get("data_vars") or [])

    return n, k


def split_variables(variables: str | None) -> list[str]:
    # Convertit la chaine de variables du catalogue en liste propre.
    # Les variables sont stockees comme "var1, var2, var3" pour rester lisibles
    # dans le CSV final.
    if not variables:
        return []

    return [item.strip() for item in str(variables).split(",") if item.strip()]


def yes_no(value: bool) -> str:
    # Standardise les indicateurs binaires dans le catalogue exporte.
    return "Yes" if value else "No"


def detect_metadata_signals(record: dict[str, Any], variables: str | None) -> dict[str, str]:
    # Detecte des signaux utiles pour la curation manuelle :
    # geometrie, coordonnees, variables explicatives candidates,
    # variable d'interet candidate, nom de lieu et temporalite.
    import re

    variable_names = split_variables(variables)
    variable_names_lower = [name.lower() for name in variable_names]

    geometry_type = str(record.get("geometry_type") or "").strip()
    role = str(record.get("role") or "")
    source_url = str(record.get("url") or "")
    dataset_text = " ".join(
        str(record.get(key) or "")
        for key in [
            "dataset_key",
            "dataset",
            "name",
            "description",
            "package_file",
            "inventory_status",
        ]
    ).lower()

    coordinate_pattern = re.compile(
        r"(^x$|^y$|lon|long|longitude|lat|latitude|coord|coords|easting|northing)"
    )
    datetime_pattern = re.compile(
        r"(year|date|time|month|day|period|syear|timestamp|datetime)"
    )
    place_pattern = re.compile(
        r"(country|state|county|city|town|municip|commune|depart|region|zip|postal|"
        r"fips|tract|neig|name|place|nuts|geoid|id_?geo|^id$|_id$|code)"
    )
    y_pattern = re.compile(
        r"(^y$|target|response|outcome|dependent|price|value|crime|homicide|"
        r"burgl|murder|death|mort|rate|cases|count|incidence|income|wage|"
        r"employment|unemployment|yield|rent|sales|disease|sids|leuk|pop)"
    )

    coordinate_columns = [
        name for name, lower in zip(variable_names, variable_names_lower)
        if coordinate_pattern.search(lower)
    ]
    datetime_columns = [
        name for name, lower in zip(variable_names, variable_names_lower)
        if datetime_pattern.search(lower)
    ]
    place_name_columns = [
        name for name, lower in zip(variable_names, variable_names_lower)
        if place_pattern.search(lower)
    ]

    has_geometry_object = bool(geometry_type) or any(
        token in source_url.lower()
        for token in [".geojson", ".gpkg", ".shp", ".zip"]
    ) or role in {"main_data_file_candidate", "main_dataset_catalog_entry"} and bool(geometry_type)
    has_coordinates = len(coordinate_columns) > 0
    has_geometry = has_geometry_object or has_coordinates

    excluded_columns = set(coordinate_columns + datetime_columns + place_name_columns)
    excluded_columns.update(name for name in variable_names if name.lower() in {"geometry", "geom", "shape"})

    model_candidate_variables = [
        name for name in variable_names
        if name not in excluded_columns
    ]
    candidate_y_variables = [
        name for name in model_candidate_variables
        if y_pattern.search(name.lower())
    ]

    if not candidate_y_variables and model_candidate_variables:
        # Si aucune variable Y evidente n'est detectee, on conserve une premiere
        # candidate faible pour faciliter la revue manuelle.
        candidate_y_variables = [model_candidate_variables[0]]

    candidate_x_variables = [
        name for name in model_candidate_variables
        if name not in candidate_y_variables
    ]

    has_datetime = bool(datetime_columns) or any(
        token in dataset_text for token in ["time", "year", "date", "temporal", "panel"]
    )
    has_place_name_if_no_geometry = (not has_geometry) and bool(place_name_columns)

    return {
        "has_geometry": yes_no(has_geometry),
        "has_coordinates": yes_no(has_coordinates),
        "coordinate_columns": ", ".join(coordinate_columns),
        "has_multiple_x": yes_no(len(candidate_x_variables) >= 2),
        "candidate_x_variables": ", ".join(candidate_x_variables),
        "has_y": yes_no(bool(candidate_y_variables)),
        "candidate_y_variables": ", ".join(candidate_y_variables),
        "has_place_name_if_no_geometry": yes_no(has_place_name_if_no_geometry),
        "place_name_columns": ", ".join(place_name_columns),
        "has_datetime": yes_no(has_datetime),
        "datetime_columns": ", ".join(datetime_columns),
    }


def guess_dataset_theme(record: dict[str, Any]) -> str:
    # Theme heuristique pour pre-trier les datasets.
    text = " ".join(
        str(record.get(key) or "")
        for key in [
            "source_package",
            "dataset_key",
            "dataset",
            "name",
            "description",
            "dataset_role",
            "notes",
            "package_file",
            "geometry_type",
        ]
    ).lower()

    if any(word in text for word in ["house", "housing", "home", "price", "airbnb", "boston", "baltim"]):
        return "housing / immobilier"
    if any(word in text for word in ["crime", "homicide", "ncovr", "columbus"]):
        return "crime / securite"
    if any(word in text for word in ["sids", "malaria", "health", "mortality", "disease", "tokyo"]):
        return "sante / epidemiologie"
    if any(word in text for word in ["income", "census", "acs", "socio", "segregation", "guerry"]):
        return "socio-economie / demographie"
    if any(word in text for word in ["air", "temperature", "rasm", "era", "ocean", "climate", "netcdf"]):
        return "environnement / climat"
    if any(word in text for word in ["mobility", "trajectory", "moving", "taxi", "foursquare", "parking"]):
        return "mobilite / trajectoires"
    if any(word in text for word in ["osm", "street", "network", "momepy", "building", "urban"]):
        return "reseaux / morphometrie urbaine"
    if any(word in text for word in ["species", "ecology", "biodiversity"]):
        return "biodiversite / ecologie"

    return "a qualifier manuellement"


def list_python_package_datasets(package: str, manifest_path: Path = INVENTORY_MANIFEST) -> list[dict[str, Any]]:
    # Equivalent pratique de data(package = "...") cote R.
    # Retourne les entrees connues pour un package Python depuis le manifeste.
    records = read_jsonl(manifest_path)
    return [record for record in records if package_matches(record, [package])]


def catalog_python_datasets(packages: list[str] | None = None) -> list[dict[str, Any]]:
    # Construit un catalogue general ou filtre par package.
    # Le catalogue combine :
    # - l'inventaire brut des datasets/fichiers/routes ;
    # - le manifeste d'extraction, quand un fichier local a ete cree.
    inventory = [r for r in read_jsonl(INVENTORY_MANIFEST) if package_matches(r, packages)]
    extracted = [r for r in read_jsonl(EXTRACTED_MANIFEST) if package_matches(r, packages)]

    extracted_by_group: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for record in extracted:
        extracted_by_group.setdefault(group_key(record), []).append(record)

    rows: list[dict[str, Any]] = []
    for record in inventory:
        role = guess_python_object_role(record)
        keep = guess_keep_from_role(role)
        local_records = extracted_by_group.get(group_key(record), [])

        local_files = []
        for local in local_records:
            for key in ["local_geojson", "local_csv", "local_file"]:
                if local.get(key):
                    local_files.append(str(local[key]))

        n, k = dimensions_from_record(record)
        if (n is None or k is None) and local_records:
            n2, k2 = dimensions_from_record(local_records[0])
            n = n if n is not None else n2
            k = k if k is not None else k2

        variables = variables_from_record(record)
        if local_records:
            local_variables, local_n, local_k = variables_from_local_records(local_records)
            variables = variables or local_variables
            n = n if n is not None else local_n
            k = k if k is not None else local_k

        metadata_signals = detect_metadata_signals({**record, "role": role}, variables)

        rows.append({
            "package": record.get("source_package"),
            "dataset_key": dataset_key(record),
            "dataset": record.get("dataset"),
            "main_file_or_entry": record.get("package_file") or record.get("dataset_key") or record.get("dataset"),
            "role": role,
            "keep": keep,
            "description": record.get("description") or record.get("name") or record.get("notes"),
            "source_url": record.get("url"),
            "variables": variables,
            "auxiliary_files": "",
            "local_files": ", ".join(sorted(set(local_files))),
            "n": n,
            "k": k,
            "geometry_type": record.get("geometry_type"),
            "has_geometry": metadata_signals["has_geometry"],
            "has_coordinates": metadata_signals["has_coordinates"],
            "coordinate_columns": metadata_signals["coordinate_columns"],
            "has_multiple_x": metadata_signals["has_multiple_x"],
            "candidate_x_variables": metadata_signals["candidate_x_variables"],
            "has_y": metadata_signals["has_y"],
            "candidate_y_variables": metadata_signals["candidate_y_variables"],
            "has_place_name_if_no_geometry": metadata_signals["has_place_name_if_no_geometry"],
            "place_name_columns": metadata_signals["place_name_columns"],
            "has_datetime": metadata_signals["has_datetime"],
            "datetime_columns": metadata_signals["datetime_columns"],
            "inventory_status": record.get("inventory_status"),
            "download_status": "; ".join(sorted(set(str(x.get("download_status")) for x in local_records))) if local_records else None,
            "theme": guess_dataset_theme(record),
        })

    return attach_auxiliary_files(rows)


def attach_auxiliary_files(rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    # Associe les fichiers auxiliaires aux fichiers principaux quand ils ont
    # le meme stem interne dans un package, par exemple .shp + .dbf + .shx.
    by_package_stem: dict[tuple[str, str], list[dict[str, Any]]] = {}
    for row in rows:
        package = str(row.get("package"))
        file_or_entry = str(row.get("main_file_or_entry") or "")
        if not file_or_entry.strip():
            continue

        path = Path(file_or_entry)
        stem = str(path.with_suffix("")) if path.name else file_or_entry
        by_package_stem.setdefault((package, stem), []).append(row)

    for (_, _), group in by_package_stem.items():
        main_rows = [row for row in group if row["keep"] == "yes"]
        auxiliary_rows = [row for row in group if row["keep"] != "yes"]
        aux_names = [str(row.get("main_file_or_entry")) for row in auxiliary_rows]
        for row in main_rows:
            row["auxiliary_files"] = ", ".join(aux_names)

    return rows


def print_catalog(rows: list[dict[str, Any]], max_rows: int | None = None) -> None:
    # Affiche un tableau compact sans dependance pandas.
    display_rows = rows if max_rows is None else rows[:max_rows]
    columns = [
        "package",
        "dataset_key",
        "role",
        "keep",
        "n",
        "k",
        "theme",
        "auxiliary_files",
    ]

    for row in display_rows:
        print({column: row.get(column) for column in columns})
    print(f"\nNombre de lignes affichees : {len(display_rows)} / {len(rows)}")


def save_catalog_csv(rows: list[dict[str, Any]], output_path: Path) -> None:
    # Sauvegarde le catalogue en CSV pour inspection dans Excel/R/Python.
    import csv

    output_path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        output_path.write_text("", encoding="utf-8")
        return

    fieldnames = list(rows[0].keys())
    with output_path.open("w", encoding="utf-8-sig", newline="") as fh:
        # Excel en configuration francaise attend souvent ";" comme separateur.
        # Les champs contenant des ";" ou des retours ligne seront automatiquement
        # proteges par des guillemets par le module csv.
        writer = csv.DictWriter(fh, fieldnames=fieldnames, delimiter=";")
        writer.writeheader()
        writer.writerows(rows)


def main() -> None:
    parser = argparse.ArgumentParser(description="Inspecte les datasets Python inventories par extract_python_software_datasets.py.")
    parser.add_argument("--package", action="append", help="Package a inspecter. Peut etre repete. Par defaut : tous les packages.")
    parser.add_argument("--list", action="store_true", help="Liste seulement les entrees du package dans le manifeste.")
    parser.add_argument("--max-rows", type=int, default=30, help="Nombre de lignes affichees.")
    parser.add_argument("--output-csv", type=Path, help="Chemin CSV pour sauvegarder le catalogue.")
    args = parser.parse_args()

    if args.list:
        packages = args.package or []
        if not packages:
            raise SystemExit("--list demande au moins un --package")
        for package in packages:
            print(f"\nPackage : {package}")
            for record in list_python_package_datasets(package):
                print({
                    "dataset_key": dataset_key(record),
                    "dataset": record.get("dataset"),
                    "status": record.get("inventory_status"),
                    "description": record.get("description") or record.get("name") or record.get("notes"),
                })
        return

    rows = catalog_python_datasets(packages=args.package)
    print_catalog(rows, max_rows=args.max_rows)

    if args.output_csv:
        save_catalog_csv(rows, args.output_csv)
        print(f"\nCatalogue ecrit : {args.output_csv}")


if __name__ == "__main__":
    main()
