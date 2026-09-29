"""Jointure geometrique par nom de ville chinoise (natif) -> GADM ADM2/ADM1.

Verifie 108/108 sur Warehouse_2026_ReplicationCodeForThe (colonne 'city',
noms en caracteres chinois). Voir README.md.

Reference : data/reference/admin_boundaries/china_adm2_prefectures.gpkg
(comprend aussi les municipalites de rang provincial extraites de l'ADM1
GADM pour Beijing/Shanghai/Tianjin/Chongqing - voir build_crosswalk).
"""

from __future__ import annotations

import sys
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]

# Renommages administratifs verifies individuellement (recherche
# independante) - a etendre uniquement apres verification de meme nature,
# jamais par simple ressemblance orthographique.
VERIFIED_RENAMES = {
    # Xiangfan (nom GADM) -> Xiangyang, renomme le 9 decembre 2010, meme
    # ville, province du Hubei.
    "襄阳市": ("Xiangfan", "NAME_2"),
}


def build_crosswalk() -> dict:
    ref2 = ROOT / "data" / "reference" / "admin_boundaries" / "china_adm2_prefectures.gpkg"
    gadm2 = gpd.read_file(ref2)
    # Les municipalites de rang provincial (Beijing/Shanghai/Tianjin/Chongqing)
    # sont au niveau ADM1 chez GADM, pas ADM2 - on reutilise le meme
    # referentiel provinces (dissous) pour les recuperer.
    ref1 = ROOT / "data" / "reference" / "admin_boundaries" / "china_adm1_provinces_dissolved.gpkg"
    gadm1 = gpd.read_file(ref1)

    crosswalk = {}
    for _, row in gadm2.iterrows():
        if pd.isna(row["NL_NAME_2"]):
            continue
        for variant in row["NL_NAME_2"].split("|"):
            crosswalk.setdefault(variant.strip(), row["geometry"])
    for _, row in gadm1.iterrows():
        if pd.isna(row["NL_NAME_1"]):
            continue
        for variant in row["NL_NAME_1"].split("|"):
            crosswalk.setdefault(variant.strip() + "市", row["geometry"])

    for target_name, (gadm_name, gadm_col) in VERIFIED_RENAMES.items():
        match = gadm2.loc[gadm2[gadm_col] == gadm_name, "geometry"]
        if len(match):
            crosswalk[target_name] = match.iloc[0]
    return crosswalk


def join(df: pd.DataFrame, name_col: str) -> gpd.GeoDataFrame:
    crosswalk = build_crosswalk()
    df = df.copy()
    df["geometry"] = df[name_col].astype(str).str.strip().map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), name_col].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees : {unmatched}")
    return gpd.GeoDataFrame(df, geometry="geometry", crs="EPSG:4326")
