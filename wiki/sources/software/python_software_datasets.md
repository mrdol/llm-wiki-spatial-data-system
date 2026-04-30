---
title: Python Software Datasets
type: source
source_family: software
created: 2026-04-29
updated: 2026-04-29
tags: [software, python, datasets, spatial, spatiotemporal, pysal, geodatasets, giddy, geosnap, xarray]
---

# Python Software Datasets

This source page groups Python packages that distribute benchmark spatial and spatio-temporal datasets useful for estimator testing and metadata inspection.

## Storage

- Metadata fiche: `wiki/analyses/metadata/software_python_priority_datasets_metadata.md`
- Machine manifest: `data/manifests/software_python_priority_datasets.jsonl`
- Requested package manifest: `data/manifests/software_python_requested_packages.jsonl`
- Cross-language conceptual mapping: `data/manifests/software_cross_language_dataset_access.jsonl`
- Exported CSVs: `data/downloads/software/python_datasets/csv/`
- Exported GeoJSONs: `data/downloads/software/python_datasets/geojson/`
- geosnap support exports: `data/downloads/software/python_datasets/geosnap/`

## Packages Used

- `geodatasets`: downloads GeoDa and `spData` datasets by stable keys.
- `libpysal`: ships PySAL example datasets, including spatial weights examples and classic benchmark datasets.
- `geopandas`: reads vector formats and exports CSV/GeoJSON inspection copies.
- `giddy`: spatial dynamics and mobility methods; reuses PySAL datasets already retained.
- `geosnap`: longitudinal socio-spatial data infrastructure; support tables plus states/counties were downloaded through direct HTTPS fallback.
- `xarray`: spatio-temporal arrays and climate/ocean tutorial datasets; NetCDF tutorials were downloaded through direct GitHub fallback.
- `movingpandas`: trajectory processing library; public example datasets were downloaded from `movingpandas-examples`.
- `scikit-mobility`: mobility analysis library; two public datasets were exported after a Shapely 2 compatibility workaround.

## Role In The System

- Provide Python-side benchmark datasets parallel to the R software datasets.
- Represent cross-language duplicates once at the conceptual level while keeping both R and Python local copies.
- Test spatial regression, spatial panel, GWR/MGWR, epidemiological, housing, income, and agronomic examples.
- Support fast local experiments before using heavier external warehouse or paper-derived datasets.
