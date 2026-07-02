#!/usr/bin/env python3
"""Ingest the Zenodo 18421412 "Mountain Fire" CSV dump into a proper sf-equivalent
GeoDataFrame, then compute the same deterministic column typology used by
export_sf_metadata.R (ported to Python) -- no R/sf involved, this dataset is a
raw warehouse CSV dump, not an R/Python package object.

Coordinates are NOT a literal column: `pixel_id` encodes them as
"<region>_<lonE4>_<latE4>" (verified against the README's stated bbox per
region). This script decodes them, builds a GeoDataFrame (CRS EPSG:4326), and
writes:
  - data/final_datasets/sf/Zenodo_18421412_mountainfire.gpkg (the sf-equivalent)
  - data/manifests/datasets/zenodo_18421412_mountainfire_typology.json (typed
    column list + N/T/CRS/bbox, in the same shape consumed by generate_fiches.py)

Usage:
    python Code_scrapping/pipeline_portals/python/ingest_zenodo_18421412_mountainfire.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

import geopandas as gpd
import pandas as pd

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))
from Code_scrapping.common.typology import classify_columns  # noqa: E402

REPO_ROOT = Path(__file__).resolve().parents[3]
SRC_DIR = REPO_ROOT / "data" / "candidates" / "datasets" / "zenodo" / "18421412"
OUT_GPKG = REPO_ROOT / "data" / "final_datasets" / "sf" / "Zenodo_18421412_mountainfire.gpkg"
OUT_JSON = REPO_ROOT / "data" / "manifests" / "datasets" / "zenodo_18421412_mountainfire_typology.json"

PIXEL_ID_RE = re.compile(r"^(?P<region>.+)_(?P<lon>-?\d+)_(?P<lat>-?\d+)$")


def decode_pixel_id(pixel_id: str) -> tuple[float, float]:
    match = PIXEL_ID_RE.match(pixel_id)
    if not match:
        raise ValueError(f"pixel_id non reconnu: {pixel_id!r}")
    lon = int(match.group("lon")) / 10000.0
    lat = int(match.group("lat")) / 10000.0
    return lon, lat


def main() -> None:
    csv_files = sorted(SRC_DIR.glob("MountainFire_*.csv"))
    print(f"Fichiers regionaux trouves : {len(csv_files)}")

    frames = []
    for f in csv_files:
        df = pd.read_csv(f)
        df["lon"], df["lat"] = zip(*df["pixel_id"].map(decode_pixel_id))
        frames.append(df)
        print(f"  {f.name}: {len(df)} lignes")

    full = pd.concat(frames, ignore_index=True)
    print(f"\nTotal combine : {len(full)} lignes, {full['pixel_id'].nunique()} pixels uniques, "
          f"{full['year'].nunique()} annees ({full['year'].min()}-{full['year'].max()})")

    gdf = gpd.GeoDataFrame(
        full, geometry=gpd.points_from_xy(full["lon"], full["lat"]), crs="EPSG:4326"
    )

    OUT_GPKG.parent.mkdir(parents=True, exist_ok=True)
    gdf.to_file(OUT_GPKG, driver="GPKG")
    print(f"\nGeoPackage ecrit : {OUT_GPKG}")

    # -- Typologie par colonne (module commun Code_scrapping/common/typology.py,
    #    meme logique deterministe que export_sf_metadata.R) --
    vars_ = [c for c in gdf.columns if c != "geometry"]
    variables, coord_columns, id_columns = classify_columns(gdf, exclude=("geometry",))

    N = int(gdf["pixel_id"].nunique())
    T = int(gdf["year"].nunique())
    bounds = gdf.total_bounds  # xmin, ymin, xmax, ymax

    result = {
        "dataset_id": "Zenodo_18421412_mountainfire",
        "package": "zenodo:18421412",
        "dataset": "MountainFire panel (6 regions)",
        "source_lang": "python",
        "rds_path": str(OUT_GPKG.relative_to(REPO_ROOT)).replace("\\", "/"),
        "bloc1": {
            "variables": variables,
            "coordinate_columns": coord_columns,
            "identifier_columns": id_columns,
            "has_formule_in_catalogue": True,  # README enonce explicitement l'intention de modelisation
        },
        "bloc4": {
            "N": N, "T": T, "T_var": "year", "k": len(vars_),
            "data_type": "spatio-temporel", "structure": "panel",
            "profil_nt": ("N_grand" if N >= 500 else "N_moyen" if N >= 50 else "N_petit")
                          + "_" + ("T_grand" if T >= 10 else "T_moyen" if T > 1 else "T_1"),
        },
        "bloc5": {
            "geom_type": "POINT",
            "crs_epsg": "4326",
            "crs_name": "WGS 84",
            "bbox": {"xmin": round(float(bounds[0]), 6), "xmax": round(float(bounds[2]), 6),
                     "ymin": round(float(bounds[1]), 6), "ymax": round(float(bounds[3]), 6)},
        },
        "qc": {
            "vars_high_na": [v["name"] for v in variables if v["pct_na"] > 20],
            "crs_missing": False,
            "geom_complex": False,
        },
    }

    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(result, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Typologie JSON ecrite : {OUT_JSON}")
    print(f"\nN={N} pixels, T={T} annees, k={len(vars_)} variables candidates "
          f"({len(coord_columns)} coordonnees, {len(id_columns)} identifiants exclus)")


if __name__ == "__main__":
    main()
