"""Conversion generique d'un dataset Bloc 3 telecharge vers le format sf commun.

Reutilise code/common/typology.py (meme classificateur deterministe que
export_sf_metadata.R pour les packages R, et que le prototype
ingest_zenodo_18421412_mountainfire.py pour les entrepots). Ecrit :

- data/final_datasets/sf/Warehouse_<bib_key>.gpkg
- data/manifests/datasets/warehouse/<bib_key>_typology.json (meme forme que
  le prototype mountainfire : dataset_id/bloc1/bloc4/bloc5/qc)

Ne force jamais une geometrie qui n'existe pas : un CSV sans colonne
coordonnee reconnaissable est laisse de cote (statut
raw_data_downloaded_needs_manual_conversion), pas de fabrication.
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "code"))
from common.typology import classify_columns  # noqa: E402

OUT_SF_DIR = ROOT / "data" / "final_datasets" / "sf"
OUT_TYPOLOGY_DIR = ROOT / "data" / "manifests" / "datasets" / "warehouse"

VECTOR_EXTENSIONS = {".shp", ".geojson", ".gpkg", ".kml", ".gml"}
TABULAR_EXTENSIONS = {".csv", ".tsv", ".xlsx", ".xls", ".dta", ".txt"}
# .parquet est teste a part (sect_vector_or_tabular_parquet) : peut porter une
# geometrie deja encodee (GeoParquet) ou etre un parquet tabulaire classique.
PARQUET_EXTENSIONS = {".parquet"}

LON_PATTERN = re.compile(
    r"^dec(imal)?[_ ]?lon(gitude)?$|^lon(gitude)?([_ ]?dd)?$|^lng$|^long$|^x$|"
    r"^x[_ ]?coord\w*$|^coord\w*[_ ]?x$|^east(ing)?$|^x[_ ]?coo\w*$",
    re.IGNORECASE,
)
LAT_PATTERN = re.compile(
    r"^dec(imal)?[_ ]?lat(itude)?$|^lat(itude)?([_ ]?dd)?$|^y$|"
    r"^y[_ ]?coord\w*$|^coord\w*[_ ]?y$|^north(ing)?$|^y[_ ]?coo\w*$",
    re.IGNORECASE,
)

# Colonnes qui indiquent une dimension spatiale par CODE administratif (pas
# des coordonnees directes) : necessitent une jointure vers un referentiel de
# geometrie externe (GEOID/FIPS americain, code commune/IBGE bresilien,
# sigungu coreen, code postal...). On ne fabrique pas cette jointure (pas de
# referentiel local fiable) mais on le signale distinctement d'un vrai
# "aucun signal spatial".
ADMIN_CODE_PATTERN = re.compile(
    r"^geoid$|^fips\w*$|^statefp$|^countyfp$|"
    r"municipality[_ ]?code|^cod[_ ]?mun\w*$|^ibge\w*$|"
    r"sigungu|^district[_ ]?id$|^region[_ ]?code$|"
    r"^(zip|postal)[_ ]?code$|^nuts\d?$|^admin\d?[_ ]?code$",
    re.IGNORECASE,
)
TEMPORAL_PATTERN = re.compile(r"year|date|time|month|annee|periode|timestamp|^yr$|^an$", re.IGNORECASE)


def extract_zip_archives(folder: Path) -> None:
    """Deballe tout .zip du dossier (une fois) pour exposer les fichiers reels.

    Beaucoup de depots livrent un unique .zip contenant le shapefile/CSV -
    sans cette etape, le convertisseur ne voit jamais les vraies donnees.
    """
    import zipfile

    for zip_path in list(folder.glob("*.zip")):
        marker = folder / f".{zip_path.stem}_extracted"
        if marker.exists():
            continue
        try:
            with zipfile.ZipFile(zip_path) as zf:
                zf.extractall(folder)
            marker.write_text("", encoding="utf-8")
        except Exception:  # noqa: BLE001 - zip corrompu ou non standard, on ignore
            continue


def find_vector_files(folder: Path) -> list[Path]:
    hits: list[Path] = []
    for ext in VECTOR_EXTENSIONS:
        hits.extend(folder.rglob(f"*{ext}"))
    return hits


def find_tabular_files(folder: Path) -> list[Path]:
    hits: list[Path] = []
    for ext in TABULAR_EXTENSIONS:
        hits.extend(folder.rglob(f"*{ext}"))
    return hits


def find_parquet_files(folder: Path) -> list[Path]:
    return list(folder.rglob("*.parquet"))


def guess_admin_code_column(columns: list) -> Any | None:
    return next((c for c in columns if ADMIN_CODE_PATTERN.search(str(c))), None)


def guess_lonlat_columns(columns: list) -> tuple[Any, Any] | None:
    str_columns = [(c, str(c)) for c in columns]
    lon = next((c for c, s in str_columns if LON_PATTERN.match(s)), None)
    lat = next((c for c, s in str_columns if LAT_PATTERN.match(s)), None)
    if lon is not None and lat is not None:
        return lon, lat
    return None


def read_csv_with_fallback_encoding(path: Path, sep: str | None):
    import pandas as pd

    last_exc: Exception | None = None
    for encoding in ("utf-8", "cp1252", "latin1"):
        try:
            if sep is not None:
                df = pd.read_csv(path, sep=sep, engine="python", encoding=encoding)
            else:
                # sep=None + engine="python" laisse pandas deviner le
                # separateur (virgule, point-virgule, tabulation...) -
                # certains depots europeens livrent du ';' sans le signaler.
                df = pd.read_csv(path, sep=None, engine="python", encoding=encoding)
            if df.shape[1] == 1 and sep is None:
                # Un seul "gros" nom de colonne concatene = mauvais separateur
                # devine ; on force ';' explicitement en dernier recours.
                only_col = str(df.columns[0])
                if ";" in only_col:
                    df = pd.read_csv(path, sep=";", engine="python", encoding=encoding)
            return df
        except (UnicodeDecodeError, UnicodeError) as exc:
            last_exc = exc
            continue
    raise last_exc  # noqa: RSE102 - re-leve la derniere erreur si tous les encodages echouent


def coerce_coordinate_series(series):
    """Convertit une colonne coordonnee en nombres, en tolerant un prefixe
    texte corrompu (ex. "None119.09215" observe sur un depot reel) en
    extrayant la sous-chaine numerique plutot qu'en rejetant la valeur."""
    import pandas as pd

    numeric = pd.to_numeric(series, errors="coerce")
    if numeric.notna().sum() >= max(1, int(0.5 * len(series))):
        return numeric

    extracted = series.astype(str).str.extract(r"(-?\d+\.?\d*)", expand=False)
    return pd.to_numeric(extracted, errors="coerce")


def read_tabular_file(path: Path):
    import pandas as pd

    if path.suffix.lower() in {".xlsx", ".xls"}:
        return pd.read_excel(path)
    if path.suffix.lower() == ".dta":
        return pd.read_stata(path)
    sep = "\t" if path.suffix.lower() == ".tsv" else None
    return read_csv_with_fallback_encoding(path, sep)


def load_geodataframe(folder: Path) -> tuple[Any, str] | tuple[None, str]:
    """Retourne (GeoDataFrame, methode) ou (None, raison_echec).

    Parcourt TOUS les fichiers vecteur/tabulaire du dossier (pas seulement le
    premier trouve) : un depot contient souvent plusieurs fichiers annexes
    (README, tables de resultats) a cote du vrai fichier geocode. Si aucun
    fichier n'a de coordonnees directes, on signale un code administratif
    trouve (GEOID/FIPS/IBGE/sigungu/...) comme piste de jointure externe,
    distincte d'une absence totale de signal spatial.
    """
    import geopandas as gpd

    extract_zip_archives(folder)

    for vector_file in find_vector_files(folder):
        try:
            gdf = gpd.read_file(vector_file)
            if len(gdf) and gdf.geometry.notna().any():
                return gdf, f"vector_file:{vector_file.name}"
        except Exception:  # noqa: BLE001 - fichier vecteur illisible, on essaie le suivant
            continue

    admin_code_hits: list[str] = []

    for parquet_file in find_parquet_files(folder):
        # 1) GeoParquet (geometrie deja encodee) ?
        try:
            gdf = gpd.read_parquet(parquet_file)
            geom_cols = [c for c in gdf.columns if str(gdf[c].dtype) == "geometry"]
            if len(geom_cols) > 1:
                # Plusieurs colonnes geometrie (ex. geometrie brute + centroide
                # precalcule) : on garde la geometrie active, on droppe les autres.
                extra = [c for c in geom_cols if c != gdf.geometry.name]
                gdf = gdf.drop(columns=extra)
            if len(gdf) and gdf.geometry.notna().any():
                return gdf, f"geoparquet:{parquet_file.name}"
        except Exception:  # noqa: BLE001 - pas un GeoParquet valide, on retente en tabulaire
            pass
        # 2) Parquet tabulaire classique avec colonnes lon/lat ?
        try:
            import pandas as pd

            df = pd.read_parquet(parquet_file)
        except Exception:  # noqa: BLE001
            continue
        columns = list(df.columns)
        lonlat = guess_lonlat_columns(columns)
        if lonlat:
            lon_col, lat_col = lonlat
            df2 = df.copy()
            df2[lon_col] = coerce_coordinate_series(df2[lon_col])
            df2[lat_col] = coerce_coordinate_series(df2[lat_col])
            df2 = df2.dropna(subset=[lon_col, lat_col])
            try:
                gdf = gpd.GeoDataFrame(df2, geometry=gpd.points_from_xy(df2[lon_col], df2[lat_col]), crs="EPSG:4326")
                if len(gdf):
                    return gdf, f"parquet_lonlat:{parquet_file.name}({lon_col},{lat_col})"
            except Exception:  # noqa: BLE001
                pass
        admin_col = guess_admin_code_column(columns)
        if admin_col:
            admin_code_hits.append(f"{parquet_file.name}:{admin_col}")
    for tabular_file in find_tabular_files(folder):
        try:
            df = read_tabular_file(tabular_file)
        except Exception:  # noqa: BLE001 - fichier illisible, on essaie le suivant
            continue

        columns = list(df.columns)
        lonlat = guess_lonlat_columns(columns)
        if lonlat:
            lon_col, lat_col = lonlat
            df2 = df.copy()
            df2[lon_col] = coerce_coordinate_series(df2[lon_col])
            df2[lat_col] = coerce_coordinate_series(df2[lat_col])
            df2 = df2.dropna(subset=[lon_col, lat_col])
            try:
                gdf = gpd.GeoDataFrame(df2, geometry=gpd.points_from_xy(df2[lon_col], df2[lat_col]), crs="EPSG:4326")
                if len(gdf):
                    return gdf, f"tabular_lonlat:{tabular_file.name}({lon_col},{lat_col})"
            except Exception:  # noqa: BLE001
                continue

        admin_col = guess_admin_code_column(columns)
        if admin_col:
            admin_code_hits.append(f"{tabular_file.name}:{admin_col}")

    if admin_code_hits:
        return None, (
            "code(s) administratif(s) detecte(s) sans geometrie directe - "
            "necessite une jointure vers un referentiel externe (GEOID/FIPS/"
            "IBGE/sigungu/code postal selon le pays) : " + "; ".join(admin_code_hits[:5])
        )

    return None, "aucun fichier vecteur, coordonnee ou code administratif reconnaissable trouve"


def detect_temporal_column(columns: list[str]) -> str | None:
    return next((c for c in columns if TEMPORAL_PATTERN.search(c)), None)


def convert_warehouse_folder(bib_key: str, raw_folder: Path) -> dict[str, Any]:
    """Convertit un dossier de donnees brutes Bloc 3 en sf + JSON type.

    Retourne un dict avec au moins 'status' ('converted' ou 'failed') et,
    si succes, 'sf_path'/'typology_path'.
    """
    gdf, method = load_geodataframe(raw_folder)
    if gdf is None:
        return {"status": "failed", "reason": method}

    gpkg_name = bib_key if bib_key.startswith("Warehouse_") else f"Warehouse_{bib_key}"
    out_gpkg = OUT_SF_DIR / f"{gpkg_name}.gpkg"
    out_gpkg.parent.mkdir(parents=True, exist_ok=True)
    try:
        gdf.to_file(out_gpkg, driver="GPKG")
    except Exception as exc:  # noqa: BLE001
        return {"status": "failed", "reason": f"echec ecriture gpkg: {exc}"}

    variables, coord_columns, id_columns = classify_columns(gdf, exclude=("geometry",))
    n_obs = int(len(gdf))
    temporal_col = detect_temporal_column([c for c in gdf.columns if c != "geometry"])
    t_periods = int(gdf[temporal_col].nunique()) if temporal_col else 1

    bounds = gdf.total_bounds if len(gdf) else [None, None, None, None]
    geom_types = set(gdf.geometry.geom_type.dropna().unique().tolist()) if len(gdf) else set()

    result = {
        "dataset_id": f"Warehouse_{bib_key}",
        "package": f"warehouse:{bib_key}",
        "dataset": bib_key,
        "source_lang": "python",
        "conversion_method": method,
        "rds_path": str(out_gpkg.relative_to(ROOT)).replace("\\", "/"),
        "bloc1": {
            "variables": variables,
            "coordinate_columns": coord_columns,
            "identifier_columns": id_columns,
            "has_formule_in_catalogue": False,
        },
        "bloc4": {
            "N": n_obs,
            "T": t_periods,
            "T_var": temporal_col,
            "k": len(variables),
            "data_type": "spatio-temporel" if t_periods > 1 else "spatial",
            "structure": "panel" if t_periods > 1 else "coupe_transversale",
            "profil_nt": ("N_grand" if n_obs >= 500 else "N_moyen" if n_obs >= 50 else "N_petit")
            + "_"
            + ("T_grand" if t_periods >= 10 else "T_moyen" if t_periods > 1 else "T_petit"),
        },
        "bloc5": {
            "geom_type": next(iter(geom_types), "unknown"),
            "crs_epsg": str(gdf.crs.to_epsg()) if gdf.crs else "unknown",
            "crs_name": str(gdf.crs) if gdf.crs else "unknown",
            "bbox": {
                "xmin": round(float(bounds[0]), 6) if bounds[0] is not None else None,
                "xmax": round(float(bounds[2]), 6) if bounds[2] is not None else None,
                "ymin": round(float(bounds[1]), 6) if bounds[1] is not None else None,
                "ymax": round(float(bounds[3]), 6) if bounds[3] is not None else None,
            },
        },
        "qc": {
            "vars_high_na": [v["name"] for v in variables if v["pct_na"] > 20],
            "crs_missing": gdf.crs is None,
            "geom_complex": len(geom_types) > 1,
        },
    }

    typology_path = OUT_TYPOLOGY_DIR / f"{bib_key}_typology.json"
    typology_path.parent.mkdir(parents=True, exist_ok=True)
    typology_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    return {
        "status": "converted",
        "sf_path": str(out_gpkg.relative_to(ROOT)),
        "typology_path": str(typology_path.relative_to(ROOT)),
        "n_obs": n_obs,
        "t_periods": t_periods,
        "method": method,
    }
