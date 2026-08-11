"""Jointure geometrique par nom de province marocaine -> geoBoundaries ADM2.

Verifie 75/75 sur Warehouse_2025_SpatialAnalysisOfRural. Voir README.md :
GADM ADM2 (54 unites, decoupage pre-2015) est ecarte car obsolete par
rapport aux 75 provinces/prefectures officielles actuelles.

Reference : data/reference/admin_boundaries/morocco_adm2_provinces_geoboundaries.gpkg
"""

from __future__ import annotations

import re
import sys
import unicodedata
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]

ADMIN_WORDS = re.compile(r"\b(province|prefecture|pr[eé]fecture)\b", re.IGNORECASE)
CONNECTOR_WORDS = re.compile(r"\b(de|du|des|of|d)\b", re.IGNORECASE)
ARABIC_RX = re.compile(r"[؀-ۿݐ-ݿⴰ-⵿]+")

# 7 variantes orthographiques univoques verifiees manuellement (meme
# province, transliteration differente entre source et geoBoundaries).
# norm(source) -> norm(geoBoundaries)
ALIAS = {
    "agadir ida ou tanane": "agadir ida outanane",
    "el kelaa sraghna": "el kelaat es sraghna",
    "fquih ben salah": "fquih ben saleh",
    "mohammadia": "mohammedia",
    "rehamna": "rhamna",
    "tanger assilah": "tangier assilah",
    "taroudannt": "taroudant",
}


def normalize(s: str) -> str:
    s = str(s)
    s = ARABIC_RX.sub("", s)
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode("ascii")
    s = ADMIN_WORDS.sub("", s)
    s = s.replace("-", " ").replace("'", " ").replace("’", " ")
    s = CONNECTOR_WORDS.sub("", s)
    s = re.sub(r"\s+", " ", s).strip().lower()
    return s


def build_crosswalk() -> dict:
    ref = ROOT / "data" / "reference" / "admin_boundaries" / "morocco_adm2_provinces_geoboundaries.gpkg"
    gb = gpd.read_file(ref)
    gb["norm"] = gb["shapeName"].apply(normalize)
    return dict(zip(gb["norm"], gb["geometry"]))


def join(df: pd.DataFrame, name_col: str) -> gpd.GeoDataFrame:
    crosswalk = build_crosswalk()
    df = df.copy()
    df["_norm"] = df[name_col].apply(normalize).replace(ALIAS)
    df["geometry"] = df["_norm"].map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), name_col].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees : {unmatched}")
    return gpd.GeoDataFrame(df.drop(columns=["_norm"]), geometry="geometry", crs="EPSG:4326")
