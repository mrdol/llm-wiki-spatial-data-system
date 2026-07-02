#!/usr/bin/env python3
"""
get_source_crs.py
-----------------
Lit le CRS directement depuis les packages Python sources (libpysal, geodatasets)
pour les datasets dont le CRS était perdu lors de la conversion GeoJSON.

Usage :
    python tools/get_source_crs.py

Requiert : libpysal, geodatasets, geopandas (dans l'env Python du projet)
"""
from __future__ import annotations
import json
import sys

try:
    import geopandas as gpd
except ImportError:
    sys.exit("geopandas non installé")

results = {}

def report(label, gdf):
    crs = gdf.crs
    if crs is None:
        print(f"  {label}: CRS = None (inconnu)")
        results[label] = {"epsg": None, "name": None, "wkt": None}
        return
    epsg = crs.to_epsg()
    name = crs.name
    units = crs.axis_info[0].unit_name if crs.axis_info else "?"
    wkt = crs.to_wkt()
    print(f"  {label}:")
    print(f"    EPSG  : {epsg}")
    print(f"    Name  : {name}")
    print(f"    Units : {units}")
    # WKT sur une ligne (utile pour identifier le CRS sans EPSG)
    print(f"    WKT   : {wkt[:200]}...")
    results[label] = {"epsg": epsg, "name": name, "units": units, "wkt": wkt}

# ── libpysal ────────────────────────────────────────────────────────────────
print("\n=== libpysal ===")
try:
    from libpysal import examples

    # Lister tous les datasets disponibles pour trouver les bons noms
    available = examples.available()
    print(f"  Datasets disponibles : {sorted(available)[:20]} ...")

    # Essayer les variantes de noms (libpysal est sensible à la casse et au nom exact)
    name_variants = {
        "Baltimore": ["Baltimore", "baltim", "Baltim"],
        "georgia":   ["georgia", "Georgia"],
        "Ohiolung":  ["Ohiolung", "ohiolung"],
        "Cincinnati": ["Cincinnati", "cincinnati"],
    }
    for ds_label, candidates in name_variants.items():
        found = False
        for name in candidates:
            # Essayer load_example (télécharge si absent) puis get_path
            try:
                examples.load_example(name)
            except Exception:
                pass
            for ext in [".shp", ".gpkg", ".geojson"]:
                try:
                    path = examples.get_path(f"{name}{ext}")
                    if path:
                        gdf = gpd.read_file(path)
                        report(f"libpysal/{ds_label} (via {name}{ext})", gdf)
                        found = True
                        break
                except Exception:
                    pass
            if found:
                break
        if not found:
            print(f"  libpysal/{ds_label}: non trouvé (essayé: {candidates})")
except ImportError:
    print("  libpysal non installé")

# ── geodatasets ─────────────────────────────────────────────────────────────
print("\n=== geodatasets ===")
try:
    import geodatasets
    for ds_key in ["geoda.cincinnati", "spdata.nydata", "spdata.eire"]:
        try:
            path = geodatasets.get_path(ds_key)
            gdf = gpd.read_file(path)
            report(f"geodatasets/{ds_key}", gdf)
        except Exception as e:
            print(f"  geodatasets/{ds_key}: ERREUR — {e}")
except ImportError:
    print("  geodatasets non installé")

# ── Résumé JSON ─────────────────────────────────────────────────────────────
print("\n=== Résumé (pour CRS_OVERRIDES dans build_sf_datasets.R) ===")
for label, info in results.items():
    epsg = info.get("epsg")
    name = info.get("name", "")
    print(f"  {label}: EPSG:{epsg}  ({name})")

out_path = "tools/source_crs_results.json"
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2, ensure_ascii=False)
print(f"\nRésultats sauvegardés dans {out_path}")
