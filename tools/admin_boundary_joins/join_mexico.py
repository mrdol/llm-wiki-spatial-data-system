"""Jointure geometrique par code INEGI (CVE_ENT+CVE_MUN) -> municipios.

Verifie 860/860 sur Warehouse_2025_DatasetForThePaper. Jointure par CODE
officiel (pas par nom) : la plus fiable des jointures externes de cette
serie. Voir README.md.

Reference : data/reference/admin_boundaries/mexico_municipios_inegi.gpkg
(polygones reconstruits depuis le package R mxmaps, colonne 'region' =
code INEGI 5 chiffres).
"""

from __future__ import annotations

import sys
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]


def build_crosswalk() -> dict:
    ref = ROOT / "data" / "reference" / "admin_boundaries" / "mexico_municipios_inegi.gpkg"
    mx = gpd.read_file(ref)
    mx["region"] = mx["region"].astype(str).str.zfill(5)
    return dict(zip(mx["region"], mx["geometry"]))


def join(df: pd.DataFrame, cve_ent_col: str, cve_mun_col: str) -> gpd.GeoDataFrame:
    crosswalk = build_crosswalk()
    df = df.copy()
    df["_cve5"] = (
        df[cve_ent_col].astype(int).astype(str).str.zfill(2)
        + df[cve_mun_col].astype(int).astype(str).str.zfill(3)
    )
    df["geometry"] = df["_cve5"].map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), "_cve5"].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees (codes) : {unmatched}")
    return gpd.GeoDataFrame(df.drop(columns=["_cve5"]), geometry="geometry", crs="EPSG:4326")
