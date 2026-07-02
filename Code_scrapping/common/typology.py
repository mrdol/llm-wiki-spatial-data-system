"""Shared deterministic column typology + structural routing.

Single source of truth for the Python side of the pipeline. This is a direct
port of the logic in `Code_scrapping/r_catalog/export_sf_metadata.R`
(`classify_typology()` / `route_structural()`). It is used by:

  - Code_scrapping/pipeline_portals/python/ingest_*.py (Block 2/3 warehouse
    and paper-linked dataset ingestion -- pandas/geopandas DataFrames)

It deliberately does NOT decide Y vs X (no semantic/content judgment) --
that stays a separate LLM step (see generate_fiches.py:classify_yx_llm).
This module only answers two purely structural questions:

  1. What statistical type is this column (continuous/count/binary/rate/
     categorical/unknown)?
  2. Is this column a coordinate or an identifier, by name pattern alone?

IMPORTANT -- keep in sync with export_sf_metadata.R: the R script duplicates
this logic (R and Python can't share one source file). If you fix a bug here
(e.g. the 2026-06-30 fix removing "index" from the identifier pattern --
"heat_load_index"/"povindex" are computed metrics, not database keys), apply
the same fix in export_sf_metadata.R's `classify_typology()`/
`route_structural()` and vice versa.
"""

from __future__ import annotations

import re
from typing import Any

import pandas as pd

# -- Routage structurel deterministe (port de route_structural() R) -----------

SPATIAL_PATTERN = re.compile(
    r"^lon$|^lat$|^long$|^latitude$|^longitude$|^x$|^y$|^lng$|coord|^easting$|^northing$",
    re.IGNORECASE,
)
# "index" volontairement exclu : trop ambigu dans ce domaine (heat_load_index,
# povindex, vegetation_index sont des metriques calculees, pas des cles
# d'identification). Voir docstring du module.
IDENTIFIER_PATTERN = re.compile(r"id$|^fid$|^gid$|code|key|^no$|^num$|objectid", re.IGNORECASE)
TEMPORAL_PATTERN = re.compile(r"year|date|time|month|annee|periode|timestamp|^yr$|^an$", re.IGNORECASE)


def route_structural(name: str) -> str | None:
    """Classify a column as 'spatial' (x/y coordinate) or 'identifier' by
    name pattern alone -- no content inspection. Returns None if neither
    applies (column should go through classify_typology() instead)."""
    if SPATIAL_PATTERN.search(name):
        return "spatial"
    if IDENTIFIER_PATTERN.search(name):
        return "identifier"
    return None


# -- Typologie statistique (port de classify_typology() R) --------------------

def classify_typology(series: pd.Series) -> dict[str, Any]:
    """Classify a column's statistical typology from its values alone
    (continuous/count/binary/rate/categorical/unknown). No Y/X judgment."""
    dtype = series.dtype
    non_null = series.dropna()

    if dtype == object:
        return {"typology": "categorical", "range": None}

    if dtype == bool:
        return {"typology": "binary", "range": "{0, 1}"}

    if non_null.empty:
        return {"typology": "unknown", "range": None}

    n_uniq = non_null.nunique()
    if pd.api.types.is_integer_dtype(dtype) or pd.api.types.is_float_dtype(dtype):
        unique_vals = set(non_null.unique().tolist())
        if unique_vals <= {0, 1}:
            return {"typology": "binary", "range": "{0, 1}"}
        vmin, vmax = float(non_null.min()), float(non_null.max())
        if pd.api.types.is_float_dtype(dtype):
            if 0 <= vmin and vmax <= 1 and n_uniq > 5:
                return {"typology": "rate", "range": f"[{vmin:.4f}, {vmax:.4f}]"}
            return {"typology": "continuous", "range": f"[{vmin:.4f}, {vmax:.4f}]"}
        return {"typology": "count", "range": f"[{int(vmin)}, {int(vmax)}]"}

    return {"typology": "unknown", "range": None}


def classify_columns(
    df: "pd.DataFrame", exclude: tuple[str, ...] = ()
) -> tuple[list[dict[str, Any]], list[dict[str, Any]], list[dict[str, Any]]]:
    """Run route_structural() + classify_typology() over every column of a
    DataFrame (excluding any in `exclude`, e.g. the geometry column).

    Returns (variables, coordinate_columns, identifier_columns) -- the same
    three-way split produced by export_sf_metadata.R's inspection loop, ready
    to drop into a bloc1-shaped dict for generate_fiches.py-style rendering.
    """
    variables: list[dict[str, Any]] = []
    coord_columns: list[dict[str, Any]] = []
    id_columns: list[dict[str, Any]] = []

    for v in df.columns:
        if v in exclude:
            continue
        col = df[v]
        pct_na = round(100 * col.isna().sum() / len(col), 1) if len(col) else 0.0

        route = route_structural(v)
        if route == "spatial":
            coord_columns.append({"name": v, "class": str(col.dtype), "pct_na": pct_na})
            continue
        if route == "identifier":
            id_columns.append({"name": v, "class": str(col.dtype), "pct_na": pct_na})
            continue

        typ = classify_typology(col)
        variables.append({
            "name": v, "class": str(col.dtype),
            "typology": typ["typology"], "range": typ["range"],
            "n_unique": int(col.nunique()), "pct_na": pct_na,
        })

    return variables, coord_columns, id_columns
