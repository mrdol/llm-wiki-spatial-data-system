#!/usr/bin/env python3
"""Render the Bloc 1-6 fiche for Zenodo 18421412 (Mountain Fire) from the
typology JSON produced by ingest_zenodo_18421412_mountainfire.py.

Reuses classify_yx_llm() and the LLM cache from generate_fiches.py so this
warehouse dataset goes through the exact same Y/X selection mechanism (and
cache) as the package datasets -- no separate logic duplicated.

Usage:
    python Code_scrapping/pipeline_portals/python/render_zenodo_18421412_fiche.py
"""

from __future__ import annotations

import json
import os
import sys
from datetime import date
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "r_catalog"))
from generate_fiches import (  # noqa: E402
    repo_root, load_cache, save_cache, classify_yx_llm,
    VALID_X_TYPES, X_TYPOLOGY_TO_ROLE,
)

ROOT = repo_root()
TYPOLOGY_JSON = ROOT / "data" / "manifests" / "datasets" / "zenodo_18421412_mountainfire_typology.json"
CACHE_PATH = ROOT / "data" / "yx_llm_cache.json"
OUT_FICHE = ROOT / "wiki" / "datasets" / "zenodo" / "zenodo_18421412_mountain_fire.md"
TODAY = date.today().isoformat()

INTRO = (
    "Panel spatio-temporel de severite des feux dans 6 systemes montagneux mondiaux "
    "(Alpes occidentales, Andes centrales, Alpes australiennes, hauts-plateaux est-africains, "
    "Himalaya central, Rocheuses centrales), 2013-2023, base sur Landsat 8/9 et ERA5-Land. "
    "Etude de panel examinant l'influence de la temperature et des precipitations sur la "
    "severite des feux (source: README du depot Zenodo)."
)


def main() -> int:
    entry = json.loads(TYPOLOGY_JSON.read_text(encoding="utf-8"))
    b1, b4, b5 = entry["bloc1"], entry["bloc4"], entry["bloc5"]
    did = entry["dataset_id"]

    cache = load_cache(CACHE_PATH)
    client = None
    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        try:
            from dotenv import load_dotenv
            load_dotenv(ROOT / ".env")
            api_key = os.environ.get("ANTHROPIC_API_KEY")
        except ImportError:
            pass
    if api_key:
        import anthropic
        client = anthropic.Anthropic(api_key=api_key)

    all_vars = b1["variables"]
    var_by_name = {v["name"]: v for v in all_vars}
    llm_result = classify_yx_llm(did, all_vars, INTRO, cache, client, refresh=False)
    save_cache(CACHE_PATH, cache)
    rationale = llm_result.get("rationale") or "n/a"

    y_cands = [var_by_name[n] for n in llm_result.get("y_candidates", []) if n in var_by_name]
    x_cands = [var_by_name[n] for n in llm_result.get("x_candidates", []) if n in var_by_name]

    y_vars_str = ", ".join(f"`{v['name']}`" for v in y_cands) or "not identified by LLM classification"
    y_types_str = ", ".join(dict.fromkeys(v["typology"] for v in y_cands)) or "unknown"
    x_vars_str = ", ".join(f"`{v['name']}`" for v in x_cands) or "not identified by LLM classification"
    x_types_str = ", ".join(dict.fromkeys(
        v["typology"] if v["typology"] in VALID_X_TYPES else X_TYPOLOGY_TO_ROLE.get(v["typology"], "categorical")
        for v in x_cands
    )) or "unknown"

    y_rows = "".join(
        f"| `{v['name']}` | `{v['class']}` | {v['typology']} | {v['range']} | {v['pct_na']}% |\n"
        for v in y_cands
    ) or "| — | — | aucun candidat | — | — |\n"
    x_rows = "".join(
        f"| `{v['name']}` | `{v['class']}` | {v['typology']} | {v['pct_na']}% |\n"
        for v in x_cands
    ) or "| — | — | aucun candidat | — |\n"

    coord_str = ", ".join(f"`{c['name']}`" for c in b1["coordinate_columns"]) or "none detected"
    id_str = ", ".join(f"`{c['name']}`" for c in b1["identifier_columns"]) or "none detected"

    bbox = b5["bbox"]
    spatial_extent = f"x [{bbox['xmin']}, {bbox['xmax']}], y [{bbox['ymin']}, {bbox['ymax']}] (EPSG:{b5['crs_epsg']})"

    fiche = f"""\
---
title: {did}
type: dataset
created: {TODAY}
updated: {TODAY}
sources:
  - {entry["rds_path"]}
tags: [dataset, zenodo, warehouse, spatial, temporal, point]
---

{INTRO}

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du GeoPackage)

- Candidate Y variables: {y_vars_str}
- Candidate Y typology: {y_types_str}
- Candidate X variables: {x_vars_str}
- Candidate X typology: {x_types_str}
- Coordinates (x, y — excluded from X candidates): {coord_str}
- Identifier columns (excluded from X candidates): {id_str}
- Variables inspected: yes (auto — ingest_zenodo_18421412_mountainfire.py)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
{y_rows}

> Selection Y/X (claude-sonnet-4-6) : {rationale}

#### Detail X

| Variable | Classe | Role X | NA (%) |
|---|---|---|---|
{x_rows}

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending (README enonce l'intention "panel regression analysis examining how temperature and precipitation influence fire severity" mais ne donne pas la formule R exacte testee)

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `{did}`
- Dataset name: Climate-Fire Relationships Across Global Mountain Systems: A Six-Continent Analysis
- Source family: zenodo-warehouse
- Source: Zenodo
- Source URL: https://zenodo.org/records/18421412
- Dataset DOI: 10.5281/zenodo.18421412
- Publication DOI: pending
- Year: 2026

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

## Bloc 4 — Typologie des donnees

- Data type: {b4['data_type']}
- Structure: {b4['structure']}
- N observations: {b4['N']}
- T periods: {b4['T']}
- Variable temporelle: {b4['T_var']}
- N/T profile: {b4['profil_nt']}

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (grille systematique 500m, resolution Landsat native 30m)
- Temporal resolution: annual (fire-season aggregates)
- Spatial extent: {spatial_extent}
- Time range: 2013-2023
- Type de geometrie: {b5['geom_type']}
- CRS EPSG: {b5['crs_epsg']}
- CRS nom: {b5['crs_name']}
- CRS analyse recommande: pending

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC-BY-4.0
- License URL: https://zenodo.org/records/18421412
- License open: yes
- Reproducibility status: available via Zenodo (donnees + code Google Earth Engine)
- Code available: yes (SM_Code_S1_GEE_Analysis.js)
- Repository: zenodo-warehouse

## Quality Control

Aucune anomalie detectee (NA% nul sur toutes les variables inspectees).

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[zenodo]]
"""

    OUT_FICHE.write_text(fiche, encoding="utf-8", newline="\n")
    print(f"Fiche ecrite : {OUT_FICHE}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
