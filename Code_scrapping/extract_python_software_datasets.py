from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import subprocess
import sys
from pathlib import Path
from typing import Any


PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "downloads" / "software" / "python_datasets"
MANIFEST_DIR = PROJECT_ROOT / "data" / "manifests" / "datasets"
PRIORITY_MANIFEST = MANIFEST_DIR / "software_python_priority_datasets.jsonl"
EXTRACTED_MANIFEST = MANIFEST_DIR / "software_python_extracted_datasets.jsonl"
REQUESTED_MANIFEST = MANIFEST_DIR / "software_python_requested_packages.jsonl"
INVENTORY_MANIFEST = MANIFEST_DIR / "software_python_dataset_inventory.jsonl"
EMBEDDED_DATA_EXTENSIONS = {
    ".csv",
    ".tsv",
    ".txt",
    ".json",
    ".geojson",
    ".gpkg",
    ".shp",
    ".dbf",
    ".shx",
    ".prj",
    ".nc",
    ".parquet",
    ".pkl",
    ".pickle",
    ".zip",
}


PYTHON_PACKAGES = [
    {"source_package": "geodatasets", "import_name": "geodatasets", "pip_name": "geodatasets"},
    {"source_package": "libpysal", "import_name": "libpysal", "pip_name": "libpysal"},
    {"source_package": "spreg", "import_name": "spreg", "pip_name": "spreg"},
    {"source_package": "esda", "import_name": "esda", "pip_name": "esda"},
    {"source_package": "mgwr", "import_name": "mgwr", "pip_name": "mgwr"},
    {"source_package": "giddy", "import_name": "giddy", "pip_name": "giddy"},
    {"source_package": "pointpats", "import_name": "pointpats", "pip_name": "pointpats"},
    {"source_package": "segregation", "import_name": "segregation", "pip_name": "segregation"},
    {"source_package": "geosnap", "import_name": "geosnap", "pip_name": "geosnap"},
    {"source_package": "momepy", "import_name": "momepy", "pip_name": "momepy"},
    {"source_package": "geopandas", "import_name": "geopandas", "pip_name": "geopandas"},
    {"source_package": "PyGeoDa", "import_name": "pygeoda", "pip_name": "pygeoda"},
    {"source_package": "OSMnx", "import_name": "osmnx", "pip_name": "osmnx"},
    {"source_package": "Pyrosm", "import_name": "pyrosm", "pip_name": "pyrosm"},
    {"source_package": "cenpy", "import_name": "cenpy", "pip_name": "cenpy"},
    {"source_package": "xarray", "import_name": "xarray", "pip_name": "xarray"},
    {"source_package": "movingpandas", "import_name": "movingpandas", "pip_name": "movingpandas"},
    {"source_package": "scikit-mobility", "import_name": "skmob", "pip_name": "scikit-mobility"},
]


GEODATASETS_TARGETS = [
    {
        "priority": 1,
        "source_package": "geodatasets",
        "dataset_key": "geoda.columbus",
        "dataset": "columbus",
        "family": "spatial_econometrics",
        "y": "crime",
        "x": "income, housing value",
        "temporal": "absent",
        "geometry": "neighborhood polygons",
    },
    {
        "priority": 1,
        "source_package": "geodatasets",
        "dataset_key": "geoda.sids",
        "dataset": "sids",
        "family": "spatial_epidemiology",
        "y": "SIDS deaths / rates",
        "x": "births, non-white births",
        "temporal": "partial_2_periods",
        "geometry": "county polygons",
    },
    {
        "priority": 1,
        "source_package": "geodatasets",
        "dataset_key": "spdata.boston",
        "dataset": "boston",
        "family": "spatial_econometrics",
        "y": "housing value",
        "x": "crime, NOx, rooms, distance, tax, pupil ratio",
        "temporal": "absent",
        "geometry": "tract points/polygons depending source",
    },
    {
        "priority": 1,
        "source_package": "geodatasets",
        "dataset_key": "geoda.guerry",
        "dataset": "guerry",
        "family": "spatial_social_science",
        "y": "crime, suicide, literacy outcomes",
        "x": "literacy, wealth, donations, occupation variables",
        "temporal": "absent",
        "geometry": "French departments",
    },
    {
        "priority": 1,
        "source_package": "geodatasets",
        "dataset_key": "geoda.malaria",
        "dataset": "malaria",
        "family": "spatiotemporal_epidemiology",
        "y": "malaria incidence",
        "x": "population, census/projection variables",
        "temporal": "1973_2005_mixed",
        "geometry": "regions",
    },
    {
        "priority": 2,
        "source_package": "geodatasets",
        "dataset_key": "geoda.chicago_health",
        "dataset": "chicago_health",
        "family": "spatial_health_regression",
        "y": "health indicators",
        "x": "socioeconomic variables",
        "temporal": "snapshot",
        "geometry": "Chicago community areas",
    },
    {
        "priority": 2,
        "source_package": "geodatasets",
        "dataset_key": "geoda.ncovr",
        "dataset": "ncovr",
        "family": "spatiotemporal_spatial_counts",
        "y": "homicides",
        "x": "county socioeconomic variables",
        "temporal": "1960_1990",
        "geometry": "US counties",
    },
    {
        "priority": 2,
        "source_package": "geodatasets",
        "dataset_key": "geoda.airbnb",
        "dataset": "airbnb",
        "family": "spatial_regression",
        "y": "rental price / occupancy proxy",
        "x": "socioeconomics, crime, location",
        "temporal": "absent_or_snapshot",
        "geometry": "Chicago community areas / listings",
    },
    {
        "priority": 2,
        "source_package": "geodatasets",
        "dataset_key": "geoda.home_sales",
        "dataset": "home_sales",
        "family": "spatial_econometrics",
        "y": "home sale price",
        "x": "housing attributes, location",
        "temporal": "2014_2015_partial",
        "geometry": "King County points/polygons",
    },
]


LIBPYSAL_TARGETS = [
    {
        "priority": 1,
        "source_package": "libpysal",
        "dataset_key": "georgia",
        "dataset": "georgia",
        "family": "gwr_mgwr",
        "y": "education / bachelor rate",
        "x": "income, rurality, race, socioeconomic variables",
        "temporal": "absent",
        "geometry": "county polygons",
    },
    {
        "priority": 1,
        "source_package": "libpysal",
        "dataset_key": "baltim",
        "dataset": "baltim",
        "family": "spatial_econometrics",
        "y": "housing price",
        "x": "housing attributes and coordinates",
        "temporal": "absent",
        "geometry": "points",
    },
    {
        "priority": 1,
        "source_package": "libpysal",
        "dataset_key": "us_income",
        "dataset": "us_income",
        "family": "spatial_panel",
        "y": "per-capita income",
        "x": "state, year, neighbors, lag variables possible",
        "temporal": "1929_2009_panel",
        "geometry": "US states",
    },
    {
        "priority": 1,
        "source_package": "libpysal",
        "dataset_key": "mexico",
        "dataset": "mexico",
        "family": "spatial_panel",
        "y": "per-capita income",
        "x": "Mexican state, decade, spatial structure",
        "temporal": "1940_2000_panel",
        "geometry": "Mexican states",
    },
    {
        "priority": 1,
        "source_package": "libpysal",
        "dataset_key": "stl",
        "dataset": "stl",
        "family": "spatiotemporal_spatial_counts",
        "y": "homicide counts / rates",
        "x": "socioeconomic variables",
        "temporal": "three_periods",
        "geometry": "county polygons",
    },
    {
        "priority": 2,
        "source_package": "libpysal",
        "dataset_key": "tokyo",
        "dataset": "tokyo",
        "family": "spatial_health_regression",
        "y": "mortality",
        "x": "area-level covariates",
        "temporal": "snapshot_or_period",
        "geometry": "Tokyo areas",
    },
]


PACKAGE_ROUTES = [
    {
        "source_package": "spreg",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "pysal_satellite_examples_route",
        "dataset_role": "spatial_econometrics_examples",
        "useful_datasets": ["spreg.examples"],
        "family": "spatial_econometrics",
        "temporal": "depends_on_example",
        "notes": "Inspecter spreg.examples et les données du package ; beaucoup d'exemples réutilisent les datasets PySAL avec des fichiers propres à la régression.",
    },
    {
        "source_package": "esda",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "pysal_satellite_examples_route",
        "dataset_role": "exploratory_spatial_data_analysis_examples",
        "useful_datasets_already_in_system": ["libpysal", "geodatasets"],
        "family": "exploratory_spatial_data_analysis",
        "temporal": "depends_on_example",
        "notes": "esda est surtout un package d'estimateurs/statistiques ; les exemples réutilisent généralement les ressources libpysal/geodatasets.",
    },
    {
        "source_package": "mgwr",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "pysal_satellite_examples_route",
        "dataset_role": "gwr_mgwr_examples",
        "useful_datasets_already_in_system": ["libpysal__georgia"],
        "family": "gwr_mgwr",
        "temporal": "mostly_spatial",
        "notes": "Les exemples mgwr utilisent souvent Georgia de PySAL ou des fichiers d'exemple locaux ; inspecter les exemples avant de le traiter comme source de données.",
    },
    {
        "source_package": "pointpats",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "pysal_satellite_examples_route",
        "dataset_role": "point_pattern_examples",
        "useful_datasets": ["point process example patterns"],
        "family": "point_pattern_analysis",
        "temporal": "mostly_spatial",
        "notes": "Inspecter les exemples et tests pointpats pour repérer des coordonnées ponctuelles embarquées et des semis réutilisables.",
    },
    {
        "source_package": "segregation",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "pysal_satellite_examples_route",
        "dataset_role": "segregation_analysis_examples",
        "useful_datasets": ["segregation examples"],
        "family": "spatial_segregation",
        "temporal": "depends_on_example",
        "notes": "Inspecter les exemples/tests du package ; c'est plus souvent un package de méthodes qu'un dépôt primaire de données.",
    },
    {
        "source_package": "geopandas",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "utility_no_bundled_dataset",
        "dataset_role": "vector_read_export_utility",
        "useful_datasets_already_in_system": ["geodatasets", "libpysal"],
        "family": "geospatial_vector_io",
        "temporal": "not_applicable",
        "notes": "geopandas est conservé comme backend de lecture/export des données vectorielles ; ce n'est pas un package de datasets.",
    },
    {
        "source_package": "momepy",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "urban_morphometry_examples_route",
        "dataset_role": "urban_morphometry_examples",
        "useful_datasets": ["momepy sample urban fabrics"],
        "family": "urban_morphometry",
        "temporal": "mostly_spatial",
        "notes": "Inspecter les exemples et datasets momepy pour les bâtiments, rues et tessellations.",
    },
    {
        "source_package": "pygeoda",
        "display_name": "PyGeoDa",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "geoda_interface_route",
        "dataset_role": "geoda_dataset_interface",
        "useful_datasets_already_in_system": ["geodatasets"],
        "family": "spatial_analysis_geoda",
        "temporal": "depends_on_dataset",
        "notes": "PyGeoDa est une interface vers les méthodes GeoDa ; utiliser geodatasets pour le catalogue explicite de données d'exemple GeoDa.",
    },
    {
        "source_package": "osmnx",
        "display_name": "OSMnx",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "external_api_route",
        "dataset_role": "openstreetmap_network_poi_builder",
        "useful_datasets": ["street networks", "POIs", "building footprints where available"],
        "family": "openstreetmap_networks",
        "temporal": "snapshot_from_osm_query_time",
        "notes": "OSMnx construit des datasets à partir de requêtes OpenStreetMap ; ce n'est pas un package à données embarquées.",
    },
    {
        "source_package": "pyrosm",
        "display_name": "Pyrosm",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "external_file_reader_route",
        "dataset_role": "osm_pbf_reader",
        "useful_datasets": [".osm.pbf extracts"],
        "family": "openstreetmap_extracts",
        "temporal": "depends_on_pbf_snapshot",
        "notes": "Pyrosm lit des dumps OSM PBF locaux ; une étape séparée de téléchargement d'extraits OSM est nécessaire.",
    },
    {
        "source_package": "cenpy",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "external_api_route",
        "dataset_role": "us_census_api_builder",
        "useful_datasets": ["ACS", "Decennial Census", "TIGER geometries"],
        "family": "us_census_spatial_socieconomic_data",
        "temporal": "census_or_survey_year",
        "notes": "cenpy est l'analogue Python pratique pour accéder à l'API Census ; il construit les données par appels API plutôt qu'avec des données embarquées.",
    },
    {
        "source_package": "giddy",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "method_package_reusing_pysal_examples",
        "dataset_role": "spatial_dynamics_examples",
        "useful_datasets_already_in_system": ["libpysal__us_income", "libpysal__mexico", "geodatasets__ncovr", "libpysal__stl"],
        "family": "spatiotemporal_spatial_dynamics",
        "temporal": "panel_or_repeated_periods",
        "notes": "giddy est un package de méthodes PySAL et réutilise normalement les exemples libpysal/geodatasets.",
    },
    {
        "source_package": "geosnap",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "external_datastore_route",
        "dataset_role": "longitudinal_socio_spatial_data_store",
        "useful_datasets": ["msa_definitions", "states", "counties"],
        "family": "longitudinal_socio_spatial_analysis",
        "temporal": "longitudinal_possible",
        "notes": "Utiliser le datastore geosnap ou les ressources publiques spatial-ucr pour les États, comtés et historiques de quartiers.",
    },
    {
        "source_package": "xarray",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "tutorial_data_route",
        "dataset_role": "spatiotemporal_array_tutorial_datasets",
        "useful_datasets": ["air_temperature", "rasm", "eraint_uvz", "ersstv5"],
        "family": "gridded_spatiotemporal_climate_ocean_data",
        "temporal": "explicit_spatiotemporal_cube",
        "notes": "Utiliser les fichiers NetCDF d'exemple pydata/xarray-data quand l'accès au niveau package n'est pas disponible.",
    },
    {
        "source_package": "movingpandas",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "external_examples_route",
        "dataset_role": "trajectory_processing_examples",
        "useful_datasets": ["geolife_small", "boat_positions"],
        "family": "trajectory_spatiotemporal_data",
        "temporal": "explicit_event_or_trajectory_time",
        "notes": "Le package n'embarque pas les datasets principaux ; utiliser les ressources du dépôt d'exemples movingpandas.",
    },
    {
        "source_package": "scikit-mobility",
        "import_name": "skmob",
        "record_type": "software_package_dataset_route",
        "source_family": "software",
        "source_language": "Python",
        "status": "package_data_module_route",
        "dataset_role": "human_mobility_processing_examples",
        "useful_datasets": ["nyc_boundaries", "parking_san_francisco"],
        "failed_datasets": ["flow_foursquare_nyc", "foursquare_nyc", "taxi_san_francisco"],
        "family": "trajectory_and_flow_mobility_data",
        "temporal": "explicit_event_or_flow_time",
        "notes": "Certains exemples publics exigent des domaines obsolètes ou une authentification ; conserver séparément les réussites et les échecs.",
    },
]


def write_jsonl(path: Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fh:
        for record in records:
            fh.write(json.dumps(record, ensure_ascii=False, sort_keys=False) + "\n")


def module_available(name: str) -> bool:
    return importlib.util.find_spec(name) is not None


def module_root(name: str) -> Path | None:
    # Trouve le dossier du package sans l'importer. C'est important pour les
    # packages installés mais cassés à l'import, par exemple scikit-mobility avec
    # certaines versions récentes de shapely.
    spec = importlib.util.find_spec(name)
    if spec is None or spec.origin is None:
        return None
    return Path(spec.origin).parent


def install_if_missing(package: dict[str, str], install_missing: bool) -> dict[str, Any]:
    # Vérifie d'abord si le module importable est déjà disponible dans
    # l'environnement Python courant.
    if module_available(package["import_name"]):
        return {**package, "package_available": True, "install_status": "already_installed"}

    # Par défaut, on n'installe rien : certains packages géospatiaux peuvent
    # déclencher de grosses dépendances compilées. L'installation explicite se
    # fait avec --install-missing.
    if not install_missing:
        return {**package, "package_available": False, "install_status": "missing_not_installed"}

    # Tente une installation via le pip du même interpréteur que celui qui lance
    # ce script, pour rester dans le bon venv.
    command = [sys.executable, "-m", "pip", "install", package["pip_name"]]
    completed = subprocess.run(command, check=False, capture_output=True, text=True)
    available = module_available(package["import_name"])
    return {
        **package,
        "package_available": available,
        "install_status": "installed" if available else "install_failed",
        "install_returncode": completed.returncode,
        "install_error": completed.stderr[-1000:] if completed.stderr else None,
    }


def inspect_delimited_file(path: Path) -> dict[str, Any]:
    # Lit seulement l'en-tête et compte les lignes pour éviter de charger des
    # fichiers potentiellement volumineux en mémoire.
    delimiter = "\t" if path.suffix.lower() == ".tsv" else ","
    try:
        with path.open("r", encoding="utf-8-sig", newline="") as fh:
            reader = csv.reader(fh, delimiter=delimiter)
            header = next(reader, [])
            rows = sum(1 for _ in reader)
        profile = {"rows": rows, "columns": len(header), "column_names": header, "columns_preview": header[:30]}
    except UnicodeDecodeError:
        with path.open("r", encoding="latin-1", newline="") as fh:
            reader = csv.reader(fh, delimiter=delimiter)
            header = next(reader, [])
            rows = sum(1 for _ in reader)
        profile = {"rows": rows, "columns": len(header), "column_names": header, "columns_preview": header[:30]}
    except Exception as exc:  # noqa: BLE001 - on note l'erreur au niveau du fichier
        return {"file_inspection_error": str(exc)}

    return profile


def inspect_json_file(path: Path) -> dict[str, Any]:
    try:
        with path.open("r", encoding="utf-8") as fh:
            payload = json.load(fh)
    except Exception as exc:  # noqa: BLE001 - on note l'erreur au niveau du fichier
        return {"file_inspection_error": str(exc)}

    if isinstance(payload, dict):
        return {
            key: payload.get(key)
            for key in ["name", "description", "url", "data_type", "download_format", "auth", "sep", "encoding"]
            if key in payload
        }
    if isinstance(payload, list):
        return {"json_items": len(payload)}
    return {"json_type": type(payload).__name__}


def inventory_embedded_files(package_state: dict[str, Any]) -> list[dict[str, Any]]:
    # Parcourt les fichiers de données réellement embarqués dans le package
    # installé : CSV de geosnap, définitions JSON de scikit-mobility, NetCDF de
    # tests xarray, zip de tests esda, etc.
    root = module_root(package_state["import_name"])
    if root is None:
        return []

    records: list[dict[str, Any]] = []
    for path in sorted(root.rglob("*")):
        if not path.is_file() or path.suffix.lower() not in EMBEDDED_DATA_EXTENSIONS:
            continue
        if "__pycache__" in path.parts:
            continue

        relative_path = path.relative_to(root)
        dataset_name = path.stem
        record = {
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset_key": str(relative_path).replace("\\", "/"),
            "dataset": dataset_name,
            "inventory_status": "embedded_package_file",
            "file_extension": path.suffix.lower(),
            "package_file": str(relative_path).replace("\\", "/"),
            "absolute_file": str(path),
            "file_size_bytes": path.stat().st_size,
        }

        if path.suffix.lower() in {".csv", ".tsv"}:
            record.update(inspect_delimited_file(path))
        elif path.suffix.lower() == ".json":
            record.update(inspect_json_file(path))

        records.append(record)
    return records


def package_route(package_name: str) -> dict[str, Any] | None:
    normalized = package_name.lower()
    for route in PACKAGE_ROUTES:
        if route["source_package"].lower() == normalized:
            return route
    return None


def inventory_geodatasets(package_state: dict[str, Any]) -> list[dict[str, Any]]:
    # geodatasets expose un catalogue structuré ; flatten() renvoie toutes les
    # clés du type "geoda.columbus", "spdata.boston", etc.
    try:
        import geodatasets

        flattened = geodatasets.data.flatten()
        records = []
        for dataset_key, meta in sorted(flattened.items()):
            record = {
                **package_state,
                "record_type": "software_package_dataset_inventory",
                "source_family": "software",
                "source_language": "Python",
                "dataset_key": dataset_key,
                "dataset": dataset_key.split(".")[-1],
                "inventory_status": "listed_from_geodatasets_catalog",
            }
            for key in ["name", "description", "geometry_type", "nrows", "ncols", "url"]:
                if hasattr(meta, key):
                    record[key] = getattr(meta, key)
                elif isinstance(meta, dict) and key in meta:
                    record[key] = meta[key]
            records.append(record)
        return records
    except Exception as exc:  # noqa: BLE001 - on garde l'erreur dans le manifeste
        return [{
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset": None,
            "inventory_status": "catalog_read_failed",
            "error": str(exc),
        }]


def inventory_libpysal(package_state: dict[str, Any]) -> list[dict[str, Any]]:
    # libpysal.examples.available() est le catalogue central des exemples PySAL.
    try:
        import libpysal

        available = libpysal.examples.available()
        records = []
        for _, row in available.iterrows():
            records.append({
                **package_state,
                "record_type": "software_package_dataset_inventory",
                "source_family": "software",
                "source_language": "Python",
                "dataset_key": str(row.get("Name")),
                "dataset": str(row.get("Name")),
                "description": str(row.get("Description")),
                "installed_in_libpysal_examples": bool(row.get("Installed")),
                "inventory_status": "listed_from_libpysal_examples",
            })
        return records
    except Exception as exc:  # noqa: BLE001 - on garde l'erreur dans le manifeste
        return [{
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset": None,
            "inventory_status": "catalog_read_failed",
            "error": str(exc),
        }]


def inventory_xarray(package_state: dict[str, Any]) -> list[dict[str, Any]]:
    # xarray ne liste pas des datasets spatiaux via un package data/ classique ;
    # ses exemples officiels sont exposés par xarray.tutorial.
    try:
        import xarray as xr

        file_formats = getattr(xr.tutorial, "file_formats", {})
        return [{
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset_key": dataset,
            "dataset": dataset,
            "file_format_code": file_format,
            "inventory_status": "listed_from_xarray_tutorial",
        } for dataset, file_format in sorted(file_formats.items())]
    except Exception as exc:  # noqa: BLE001 - on garde l'erreur dans le manifeste
        return [{
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset": None,
            "inventory_status": "catalog_read_failed",
            "error": str(exc),
        }]


def inventory_route_only(package_state: dict[str, Any]) -> list[dict[str, Any]]:
    # Pour les packages qui n'ont pas de catalogue de datasets stable, on écrit
    # quand même une route contrôlée : cela dit quoi inspecter manuellement.
    route = package_route(package_state["source_package"])
    useful = []
    if route is not None:
        useful.extend(route.get("useful_datasets", []))
        useful.extend(route.get("useful_datasets_already_in_system", []))
        useful.extend(route.get("failed_datasets", []))

    if not useful:
        useful = [None]

    return [{
        **package_state,
        "record_type": "software_package_dataset_inventory",
        "source_family": "software",
        "source_language": "Python",
        "dataset": dataset,
        "inventory_status": "route_only_no_uniform_dataset_api",
        "route_status": route.get("status") if route else "no_route_defined",
        "dataset_role": route.get("dataset_role") if route else None,
        "notes": route.get("notes") if route else None,
    } for dataset in useful]


def list_package_datasets_safe(package: dict[str, str], install_missing: bool) -> list[dict[str, Any]]:
    # Point d'entrée équivalent au script R : installer si demandé, puis lister
    # les datasets détectables sans stopper le lot en cas d'échec.
    package_state = install_if_missing(package, install_missing=install_missing)
    if not package_state["package_available"]:
        return [{
            **package_state,
            "record_type": "software_package_dataset_inventory",
            "source_family": "software",
            "source_language": "Python",
            "dataset": None,
            "inventory_status": "package_not_available",
        }]

    import_name = package_state["import_name"]
    if import_name == "geodatasets":
        return inventory_geodatasets(package_state)
    if import_name == "libpysal":
        return inventory_libpysal(package_state)

    records: list[dict[str, Any]] = []
    if import_name == "xarray":
        records.extend(inventory_xarray(package_state))
    else:
        records.extend(inventory_route_only(package_state))

    records.extend(inventory_embedded_files(package_state))
    return records


def export_vector(path: Path, target: dict[str, Any], output_stem: str) -> dict[str, Any]:
    import geopandas as gpd

    frame = gpd.read_file(path)
    csv_dir = DATA_DIR / "csv"
    geojson_dir = DATA_DIR / "geojson"
    csv_dir.mkdir(parents=True, exist_ok=True)
    geojson_dir.mkdir(parents=True, exist_ok=True)

    csv_path = csv_dir / f"{output_stem}.csv"
    geojson_path = geojson_dir / f"{output_stem}.geojson"
    frame.to_csv(csv_path, index=False)
    frame.to_file(geojson_path, driver="GeoJSON")

    return {
        **target,
        "source": target["source_package"],
        "record_type": "software_dataset_candidate",
        "source_family": "software",
        "source_language": "Python",
        "download_status": "extracted_csv_geojson",
        "source_path": str(path),
        "local_csv": str(csv_path.relative_to(PROJECT_ROOT)),
        "local_geojson": str(geojson_path.relative_to(PROJECT_ROOT)),
        "rows": int(frame.shape[0]),
        "columns": int(frame.shape[1]),
        "columns_preview": list(map(str, frame.columns[:30])),
        "error": None,
    }


def copy_dataset_file(path: Path, record: dict[str, Any], output_stem: str) -> dict[str, Any]:
    # Copie un fichier de donnees embarque quand on ne sait pas le convertir
    # proprement en CSV/GeoJSON. Cela conserve les fichiers NetCDF, JSON, ZIP,
    # Pickle, etc. pour l'inspection manuelle.
    import shutil

    file_dir = DATA_DIR / "files" / record["source_package"]
    file_dir.mkdir(parents=True, exist_ok=True)

    suffix = path.suffix.lower()
    destination = file_dir / f"{output_stem}{suffix}"
    if path.resolve() != destination.resolve():
        shutil.copy2(path, destination)

    return {
        **record,
        "record_type": "software_dataset_candidate",
        "source_family": "software",
        "source_language": "Python",
        "download_status": "copied_package_file",
        "source_path": str(path),
        "local_file": str(destination.relative_to(PROJECT_ROOT)),
        "error": None,
    }


def safe_output_stem(prefix: str, value: str | None) -> str:
    # Transforme une cle de dataset en nom de fichier portable.
    raw = value or "unknown_dataset"
    cleaned = "".join(ch if ch.isalnum() else "_" for ch in raw)
    cleaned = "_".join(part for part in cleaned.split("_") if part)
    return f"{prefix}__{cleaned[:120]}"


def extract_geodatasets_record(record: dict[str, Any], allow_download: bool) -> dict[str, Any]:
    # Extrait tous les datasets du catalogue geodatasets, pas seulement une
    # liste prioritaire. geodatasets.get_path() contacte la source officielle
    # quand le fichier n'est pas encore en cache et que --allow-download est actif.
    if not module_available("geodatasets"):
        return {**record, "download_status": "package_not_installed", "error": "geodatasets is not installed"}
    if not module_available("geopandas"):
        return {**record, "download_status": "dependency_not_installed", "error": "geopandas is not installed"}
    if not allow_download:
        return {**record, "download_status": "not_run_allow_download_false", "error": "pass --allow-download to resolve geodatasets paths"}

    try:
        import geodatasets

        path = Path(geodatasets.get_path(record["dataset_key"]))
        return export_vector(path, record, safe_output_stem("geodatasets", record.get("dataset_key")))
    except Exception as exc:  # noqa: BLE001
        return {**record, "download_status": "extract_failed", "error": str(exc)}


def extract_libpysal_record(record: dict[str, Any]) -> dict[str, Any]:
    # Extrait les exemples libpysal qui contiennent au moins un fichier vectoriel
    # lisible. Les exemples purement matriciels ou texte restent dans l'inventaire.
    if not module_available("libpysal"):
        return {**record, "download_status": "package_not_installed", "error": "libpysal is not installed"}
    if not module_available("geopandas"):
        return {**record, "download_status": "dependency_not_installed", "error": "geopandas is not installed"}

    try:
        import libpysal

        example = libpysal.examples.load_example(record["dataset_key"])
        candidates = [Path(path) for path in example.get_file_list()]
        vector_files = [p for p in candidates if p.suffix.lower() in {".shp", ".gpkg", ".geojson", ".json"}]
        if not vector_files:
            return {**record, "download_status": "vector_file_not_found", "error": "no readable vector file in libpysal example"}
        return export_vector(vector_files[0], record, safe_output_stem("libpysal", record.get("dataset_key")))
    except Exception as exc:  # noqa: BLE001
        return {**record, "download_status": "extract_failed", "error": str(exc)}


def extract_xarray_record(record: dict[str, Any], allow_download: bool) -> dict[str, Any]:
    # Recupere les datasets de tutoriel xarray. Ce sont souvent des cubes
    # NetCDF spatio-temporels ; on les conserve en NetCDF pour l'inspection.
    if not module_available("xarray"):
        return {**record, "download_status": "package_not_installed", "error": "xarray is not installed"}
    if not allow_download:
        return {**record, "download_status": "not_run_allow_download_false", "error": "pass --allow-download to resolve xarray tutorial data"}

    try:
        import xarray as xr

        dataset = xr.tutorial.open_dataset(record["dataset"], cache=True)
        netcdf_dir = DATA_DIR / "netcdf"
        netcdf_dir.mkdir(parents=True, exist_ok=True)
        output_path = netcdf_dir / f"{safe_output_stem('xarray', record.get('dataset'))}.nc"
        dataset.to_netcdf(output_path)
        return {
            **record,
            "record_type": "software_dataset_candidate",
            "source_family": "software",
            "source_language": "Python",
            "download_status": "extracted_netcdf",
            "local_file": str(output_path.relative_to(PROJECT_ROOT)),
            "data_vars": list(map(str, dataset.data_vars)),
            "coords": list(map(str, dataset.coords)),
            "dims": {str(k): int(v) for k, v in dataset.sizes.items()},
            "error": None,
        }
    except Exception as exc:  # noqa: BLE001
        return {**record, "download_status": "extract_failed", "error": str(exc)}


def extract_embedded_file_record(record: dict[str, Any]) -> dict[str, Any]:
    # Copie les fichiers de donnees trouves dans les packages installes. Si le
    # fichier est vectoriel, on tente aussi une conversion CSV/GeoJSON.
    path_text = record.get("absolute_file")
    if not path_text:
        return {**record, "download_status": "missing_absolute_file", "error": "absolute_file is missing"}

    path = Path(path_text)
    if not path.exists():
        return {**record, "download_status": "source_file_not_found", "error": str(path)}

    suffix = path.suffix.lower()
    output_stem = safe_output_stem(record["source_package"], record.get("dataset_key"))

    if suffix in {".shp", ".gpkg", ".geojson"} and module_available("geopandas"):
        try:
            return export_vector(path, record, output_stem)
        except Exception as exc:  # noqa: BLE001
            copied = copy_dataset_file(path, record, output_stem)
            return {**copied, "conversion_error": str(exc)}

    return copy_dataset_file(path, record, output_stem)


def extract_inventory_record(record: dict[str, Any], allow_download: bool) -> dict[str, Any] | None:
    # Route d'extraction exhaustive depuis le manifeste d'inventaire.
    status = record.get("inventory_status")
    package = record.get("source_package")

    if status == "listed_from_geodatasets_catalog":
        return extract_geodatasets_record(record, allow_download=allow_download)
    if status == "listed_from_libpysal_examples":
        return extract_libpysal_record(record)
    if status == "listed_from_xarray_tutorial":
        return extract_xarray_record(record, allow_download=allow_download)
    if status == "embedded_package_file":
        return extract_embedded_file_record(record)

    route = package_route(str(package))
    return {
        **record,
        "record_type": "software_dataset_candidate",
        "source_family": "software",
        "source_language": "Python",
        "download_status": "listed_only_manual_or_external_route",
        "route_status": route.get("status") if route else record.get("route_status"),
        "error": None,
    }


def extract_geodatasets_target(target: dict[str, Any], allow_download: bool) -> dict[str, Any]:
    if not module_available("geodatasets"):
        return {**target, "download_status": "package_not_installed", "error": "geodatasets is not installed"}
    if not module_available("geopandas"):
        return {**target, "download_status": "dependency_not_installed", "error": "geopandas is not installed"}

    try:
        import geodatasets

        if not allow_download:
            return {**target, "download_status": "not_run_allow_download_false", "error": "pass --allow-download to resolve geodatasets paths"}
        path = Path(geodatasets.get_path(target["dataset_key"]))
        return export_vector(path, target, f"geodatasets__{target['dataset']}")
    except Exception as exc:  # noqa: BLE001 - conserver l'erreur dans le manifeste plutôt que stopper le lot
        return {**target, "download_status": "extract_failed", "error": str(exc)}


def extract_libpysal_target(target: dict[str, Any]) -> dict[str, Any]:
    if not module_available("libpysal"):
        return {**target, "download_status": "package_not_installed", "error": "libpysal is not installed"}
    if not module_available("geopandas"):
        return {**target, "download_status": "dependency_not_installed", "error": "geopandas is not installed"}

    try:
        import libpysal

        example = libpysal.examples.load_example(target["dataset_key"])
        candidates = [Path(path) for path in example.get_file_list()]
        vector_files = [p for p in candidates if p.suffix.lower() in {".shp", ".gpkg", ".geojson", ".json"}]
        if not vector_files:
            return {**target, "download_status": "vector_file_not_found", "error": "no readable vector file in libpysal example"}
        return export_vector(vector_files[0], target, f"libpysal__{target['dataset']}")
    except Exception as exc:  # noqa: BLE001 - conserver l'erreur dans le manifeste plutôt que stopper le lot
        return {**target, "download_status": "extract_failed", "error": str(exc)}


def main() -> None:
    parser = argparse.ArgumentParser(description="Extrait ou enregistre les datasets de packages Python pour la découverte spatiale/spatio-temporelle.")
    parser.add_argument("--allow-download", action="store_true", help="Autorise geodatasets à télécharger les ressources absentes du cache.")
    parser.add_argument("--probe-only", action="store_true", help="Écrit les manifestes de routes packages sans extraire les données vectorielles.")
    parser.add_argument("--install-missing", action="store_true", help="Installe avec pip les packages Python absents avant l'inventaire.")
    args = parser.parse_args()

    inventory_records: list[dict[str, Any]] = []
    for package in PYTHON_PACKAGES:
        inventory_records.extend(list_package_datasets_safe(package, install_missing=args.install_missing))

    records: list[dict[str, Any]] = []
    if not args.probe_only:
        write_jsonl(EXTRACTED_MANIFEST, records)
        total = len(inventory_records)
        for index, record in enumerate(inventory_records, start=1):
            print(
                f"[{index}/{total}] extraction {record.get('source_package')} :: {record.get('dataset_key') or record.get('dataset')}",
                flush=True,
            )
            extracted = extract_inventory_record(record, allow_download=args.allow_download)
            if extracted is not None:
                records.append(extracted)
                write_jsonl(EXTRACTED_MANIFEST, records)
    else:
        records = [
            {**record, "record_type": "software_dataset_candidate", "source_family": "software", "source_language": "Python", "download_status": "probe_only"}
            for record in inventory_records
        ]

    routes = []
    for route in PACKAGE_ROUTES:
        import_name = route.get("import_name", route["source_package"].replace("-", "_"))
        routes.append({**route, "package_available": module_available(import_name)})

    write_jsonl(INVENTORY_MANIFEST, inventory_records)
    write_jsonl(EXTRACTED_MANIFEST, records)
    write_jsonl(PRIORITY_MANIFEST, records)
    write_jsonl(REQUESTED_MANIFEST, routes)
    print(f"Manifeste d'inventaire Python : {INVENTORY_MANIFEST}")
    print(f"Manifeste d'extraction Python : {EXTRACTED_MANIFEST}")
    print(f"Manifeste des routes de packages Python : {REQUESTED_MANIFEST}")


if __name__ == "__main__":
    main()
