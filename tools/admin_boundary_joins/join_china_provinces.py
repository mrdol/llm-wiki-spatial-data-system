"""Jointure geometrique par nom de province chinoise (anglais) -> GADM ADM1.

Verifie 30/30 sur 2 datasets (UntitCanTheDigital, ThePickingTheFittest). Voir
README.md pour la methode.

Reference : data/reference/admin_boundaries/china_adm1_provinces_dissolved.gpkg
"""

from __future__ import annotations

import sys
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]

# Alias explicite : nom officiel GADM -> nom standard des panels econometriques.
ALIAS = {
    "Nei Mongol": "Inner Mongolia",
    "Ningxia Hui": "Ningxia",
    "Xinjiang Uygur": "Xinjiang",
}

# Fautes de frappe evidentes (transposition d'une lettre) rencontrees dans un
# dataset source - a etendre au cas par cas, jamais appliquer sans verifier
# que la province voisine correcte existe bien et qu'aucune autre lecture
# n'est possible.
KNOWN_TYPOS = {"Fujiang": "Fujian", "Sichuang": "Sichuan"}


def build_crosswalk() -> dict:
    ref = ROOT / "data" / "reference" / "admin_boundaries" / "china_adm1_provinces_dissolved.gpkg"
    gadm = gpd.read_file(ref)
    gadm["NAME_STD"] = gadm["NAME_1"].replace(ALIAS)
    return dict(zip(gadm["NAME_STD"], gadm["geometry"]))


def join(df: pd.DataFrame, name_col: str) -> gpd.GeoDataFrame:
    crosswalk = build_crosswalk()
    df = df.copy()
    df["_name_std"] = df[name_col].astype(str).str.strip().replace(KNOWN_TYPOS)
    df["geometry"] = df["_name_std"].map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), "_name_std"].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees : {unmatched}")
    return gpd.GeoDataFrame(df.drop(columns=["_name_std"]), geometry="geometry", crs="EPSG:4326")
