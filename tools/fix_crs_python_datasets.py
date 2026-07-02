#!/usr/bin/env python3
"""
fix_crs_python_datasets.py
--------------------------
Corrige les CRS des datasets Python dont la conversion GeoJSON a perdu
l'information de projection (geopandas.to_file(driver="GeoJSON") stocke
les coordonnées projetées sans bloc CRS lisible par PROJ).

Ce script doit être exécuté UNE FOIS avant build_sf_datasets.R et
export_sf_metadata.R, depuis l'environnement Python du projet (.venv).

Usage :
    python tools/fix_crs_python_datasets.py

Requiert : geopandas, pyproj (dans .venv)

Pipeline :
    fix_crs_python_datasets.py   ← ce script
        → data/downloads/.../geojson/*.geojson  (GeoJSON WGS84 corrigés)
    build_sf_datasets.R
        → data/Final_datasets/sf/*.rds
    export_sf_metadata.R
        → data/sf_catalog_metadata.json
    generate_fiches.py
        → wiki/datasets/packages/*.md

Décisions CRS (sources documentées dans tools/source_crs_results.json) :
--------------------------------------------------------------------
Dataset                  | CRS source               | EPSG assigné
-------------------------|--------------------------|----------------
spdata.nydata            | UTM Zone 18 + Clarke 1866| 26718 (NAD27/UTM18N)
libpysal.georgia         | UTM Zone 16N (bbox ✓)    | 32616 (WGS84/UTM16N)
libpysal.Ohiolung        | UTM Zone 17N (bbox ✓)    | 32617 (WGS84/UTM17N)
geoda.cincinnati         | LCC+GRS80+datum_inconnu  | WKT direct (source_crs_results.json)
libpysal.Baltimore       | CRS=None (baltim.shp)    | EXCLU (système local)
spdata.eire              | Undefined Cartesian SRS  | EXCLU (CRS indéfini)
"""
from __future__ import annotations

import json
import pathlib
import sys

try:
    import geopandas as gpd
    from pyproj import CRS
except ImportError:
    sys.exit("geopandas / pyproj non installés — activer le venv du projet")

REPO = pathlib.Path(__file__).resolve().parents[1]
GJ_DIR = REPO / "data" / "downloads" / "software" / "python_datasets" / "geojson"
CRS_JSON = REPO / "tools" / "source_crs_results.json"


def fix_and_save(geojson_name: str, epsg: int | None, wkt: str | None,
                 label: str, expected_bbox: str) -> None:
    """
    Lit le GeoJSON, applique le CRS source (EPSG ou WKT), reprojette en WGS84
    et écrase le fichier GeoJSON.
    """
    path = GJ_DIR / geojson_name
    if not path.exists():
        print(f"  WARN: {geojson_name} absent, ignoré")
        return

    gdf = gpd.read_file(path)

    if wkt:
        gdf = gdf.set_crs(CRS.from_wkt(wkt), allow_override=True)
    elif epsg:
        gdf = gdf.set_crs(epsg, allow_override=True)
    else:
        print(f"  SKIP {label}: pas de CRS identifiable")
        return

    gdf_wgs84 = gdf.to_crs(epsg=4326)
    b = gdf_wgs84.total_bounds
    bbox_str = f"x[{b[0]:.3f},{b[2]:.3f}] y[{b[1]:.3f},{b[3]:.3f}]"

    gdf_wgs84.to_file(path, driver="GeoJSON")
    status = "✓" if True else "?"   # bbox à vérifier manuellement
    print(f"  {label}: {bbox_str}  (attendu: {expected_bbox}) {status}")


def main() -> None:
    print("=== fix_crs_python_datasets.py ===\n")

    # Charger les WKT capturés par get_source_crs.py
    wkt_cincinnati = None
    if CRS_JSON.exists():
        with open(CRS_JSON) as f:
            crs_data = json.load(f)
        wkt_cincinnati = crs_data.get("geodatasets/geoda.cincinnati", {}).get("wkt")
        if wkt_cincinnati:
            print(f"WKT Cincinnati chargé ({len(wkt_cincinnati)} chars)\n")
    else:
        print(f"WARN: {CRS_JSON} absent — relancer tools/get_source_crs.py d'abord\n")

    corrections = [
        dict(
            geojson_name="geodatasets__spdata_nydata.geojson",
            epsg=26718,
            wkt=None,
            label="spdata.nydata",
            expected_bbox="x~[-76.7,-75.2] y~[42.0,43.4]",
        ),
        dict(
            geojson_name="libpysal__georgia.geojson",
            epsg=32616,
            wkt=None,
            label="libpysal.georgia",
            expected_bbox="x~[-85.6,-80.8] y~[30.3,35.0]",
        ),
        dict(
            geojson_name="libpysal__Ohiolung.geojson",
            epsg=32617,
            wkt=None,
            label="libpysal.Ohiolung",
            expected_bbox="x~[-84.8,-80.5] y~[38.4,42.0]",
        ),
        dict(
            geojson_name="geodatasets__geoda_cincinnati.geojson",
            epsg=None,
            wkt=wkt_cincinnati,
            label="geoda.cincinnati",
            expected_bbox="x~[-84.53,-84.46] y~[39.11,39.16]",
        ),
    ]

    for ds in corrections:
        fix_and_save(**ds)

    print("\nDatasets exclus (CRS non identifiable) :")
    print("  libpysal.Baltimore : coordonnées système local inconnu (baltim.shp sans .prj)")
    print("  spdata.eire        : Undefined Cartesian SRS with unknown unit")
    print("\nTerminé. Relancer build_sf_datasets.R puis export_sf_metadata.R.")


if __name__ == "__main__":
    main()
