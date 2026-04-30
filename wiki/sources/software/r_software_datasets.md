---
title: R Software Datasets
type: source
source_family: software
created: 2026-04-29
updated: 2026-04-29
tags: [software, r, datasets, spatial, spatiotemporal]
---

# R Software Datasets

This source page groups R packages that distribute benchmark datasets useful for the system. These datasets are mainly used for estimator testing, metadata inspection, and controlled examples before moving to large external datasets.

## Storage

- Metadata fiche: `wiki/analyses/metadata/software_r_priority_datasets_metadata.md`
- Machine manifest: `data/manifests/software_r_priority_datasets.jsonl`
- Downloaded CSVs: `data/downloads/software/r_datasets/rdatasets_csv/`
- Downloaded CRAN archives: `data/downloads/software/r_datasets/cran_packages/`
- Extracted `.rda` / `.RData` CSVs: `data/downloads/software/r_datasets/extracted_csv/`
- Extraction manifest: `data/manifests/software_r_extracted_datasets.jsonl`

## Role In The System

- Validate whether the variable typology block can distinguish `Y`, `X_candidates`, and later `X_selected`.
- Test estimator eligibility rules on known spatial and spatio-temporal examples.
- Provide small reproducible data before downloading heavier institutional or paper-derived datasets.

## Priority Packages

- Spatial econometrics: `spdep`, `spatialreg`, `spData`, `GWmodel`, `spgwr`.
- Geostatistical regression: `gstat`, `sp`.
- Spatial panels: `plm`, `splm`.
- Spatio-temporal examples: `spacetime`, `surveillance`, `STRbook` when available.
- Epidemiology and ecology: `SpatialEpi`, `vegan`, `ade4`, `dismo`.
- Agronomic trials: `agridat`.
