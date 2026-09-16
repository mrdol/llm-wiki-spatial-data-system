"""Jointure geometrique par nom de province turque -> GADM ADM1.

Verifie 81/81 (4 via variantes orthographiques GADM VARNAME_1). Voir README.md
de ce dossier pour le detail de la methode et la regle "0 non apparie" avant
ecriture.

Reference : data/reference/admin_boundaries/turkey_adm1_provinces.gpkg
"""

from __future__ import annotations

import sys
import json
from pathlib import Path

import pandas as pd
import geopandas as gpd

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "code"))
from common.typology import classify_columns  # noqa: E402


def normalize_tr(s):
    s = str(s).strip().lower()
    for k, v in {"ı": "i", "İ": "i", "ş": "s", "ğ": "g", "ü": "u", "ö": "o", "ç": "c"}.items():
        s = s.replace(k, v)
    return s


def build_crosswalk() -> dict:
    ref = ROOT / "data" / "reference" / "admin_boundaries" / "turkey_adm1_provinces.gpkg"
    gadm = gpd.read_file(ref)
    crosswalk = {}
    for _, row in gadm.iterrows():
        keys = [normalize_tr(row["NAME_1"])]
        if pd.notna(row["VARNAME_1"]):
            keys += [normalize_tr(v) for v in str(row["VARNAME_1"]).split("|")]
        for k in keys:
            crosswalk[k] = row["geometry"]
    return crosswalk


def join(df: pd.DataFrame, name_col: str) -> gpd.GeoDataFrame:
    """Jointure generique : ajoute 'geometry' a partir d'une colonne de noms
    de province turque. Leve AssertionError si des lignes restent non
    appariees (aucune correspondance forcee).
    """
    crosswalk = build_crosswalk()
    df = df.copy()
    df["_name_norm"] = df[name_col].apply(normalize_tr)
    df["geometry"] = df["_name_norm"].map(crosswalk)
    n_unmatched = df["geometry"].isna().sum()
    if n_unmatched:
        unmatched = sorted(df.loc[df["geometry"].isna(), name_col].unique())
        raise AssertionError(f"{n_unmatched} lignes non appariees : {unmatched}")
    return gpd.GeoDataFrame(df.drop(columns=["_name_norm"]), geometry="geometry", crs="EPSG:4326")


# Exemple d'utilisation deja execute cette session (dataset
# Warehouse_2026_ForeignTradeAndVariety_10_6084_m9_figsh, colonne IL_ADI,
# fichier analiz_icin_2.dta) : voir historique KG pour le resultat.
