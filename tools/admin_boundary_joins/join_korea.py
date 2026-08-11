"""Jointure geometrique par nom de sigungu coreen (Hangul) -> KOSTAT 2018.

Verifie 229/229 sur le dataset Warehouse_2026_HepatitisEInThe (217 directs +
11 grandes villes agregees par dissolution de leurs sous-districts + 1
district renomme verifie par centroide). Voir README.md.

Reference : data/reference/admin_boundaries/korea_sigungu_kostat2018.gpkg
"""

from __future__ import annotations

import sys
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]

# Grandes villes subdivisees en gu dans KOSTAT 2018 mais souvent agregees au
# niveau ville dans les datasets sources - a dissoudre au besoin.
AGGREGATE_CITIES = [
    "고양시", "성남시", "수원시", "안산시", "안양시", "용인시",
    "창원시", "포항시", "전주시", "천안시", "청주시",
]

# District renomme verifie par centroide (37.45N/126.67E = Incheon) : ancien
# nom 남구 (code KOSTAT 23030) -> 미추홀구 depuis 2018. A revalider si un
# nouveau dataset utilise un autre district "남구" homonyme (nom generique
# partage par 5 villes coreennes).
RENAMED_DISTRICTS = {"미추홀구": "23030"}


def build_crosswalk(aggregate_cities: list[str] | None = None) -> dict:
    ref = ROOT / "data" / "reference" / "admin_boundaries" / "korea_sigungu_kostat2018.gpkg"
    kostat = gpd.read_file(ref)
    aggregate_cities = aggregate_cities if aggregate_cities is not None else AGGREGATE_CITIES

    crosswalk = {}
    for city in aggregate_cities:
        base = city.replace("시", "")
        sub = kostat[kostat["name"].str.startswith(base) & (kostat["name"] != city)]
        if len(sub):
            crosswalk[city] = sub.union_all()

    for name, code in RENAMED_DISTRICTS.items():
        match = kostat[kostat["code"] == code]
        if len(match) == 1:
            crosswalk[name] = match.geometry.iloc[0]

    direct_names = set(kostat["name"]) - set(aggregate_cities)
    for _, row in kostat[kostat["name"].isin(direct_names)].iterrows():
        crosswalk.setdefault(row["name"], row["geometry"])
    return crosswalk


def join(df: pd.DataFrame, name_col: str) -> gpd.GeoDataFrame:
    crosswalk = build_crosswalk()
    df = df.copy()
    df["geometry"] = df[name_col].map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), name_col].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees : {unmatched}")
    return gpd.GeoDataFrame(df, geometry="geometry", crs="EPSG:4326")
