# Cross-language Software Dataset Access

This note consolidates software datasets that exist in both R and Python. The system keeps one conceptual dataset identity for metadata and modeling decisions, while preserving both software access routes and both downloaded copies when available.

## Rule

- One conceptual metadata fiche when the same empirical dataset appears in both ecosystems.
- Multiple access routes under that fiche: `R` and `Python`.
- Do not delete duplicated downloaded data: duplicates are useful for checking package-specific geometry, coding, column names, and documentation differences.
- Machine records for this mapping are stored in `data/manifests/software_cross_language_dataset_access.jsonl`.

## Conceptual Datasets

### Columbus Crime

- Conceptual id: `software_dataset.columbus_crime`
- Modeling use: spatial regression and spatial econometrics benchmark.
- Y: crime rate.
- X candidates: income, housing value, neighborhood covariates, spatial weights.
- Temporal status: absent.
- R access: `spdep::columbus`.
- Python access: `geodatasets geoda.columbus`, also available through `libpysal.examples`.
- R local data: package archive `data/downloads/software/r_datasets/cran_packages/spdep_1.4-2.tar.gz`; extracted CSVs may be generated from the R extraction script.
- Python local data: `data/downloads/software/python_datasets/csv/geodatasets__columbus.csv` and `data/downloads/software/python_datasets/geojson/geodatasets__columbus.geojson`.

### North Carolina SIDS

- Conceptual id: `software_dataset.north_carolina_sids`
- Modeling use: spatial epidemiology, count/rate modeling, spatial risk smoothing.
- Y: SIDS deaths or rates.
- X candidates: births, non-white births, period indicators, county geometry.
- Temporal status: partial two-period structure.
- R access: `spdep::nc.sids`, also reused by `sf` examples.
- Python access: `geodatasets geoda.sids`.
- R local data: package archive `data/downloads/software/r_datasets/cran_packages/spdep_1.4-2.tar.gz`.
- Python local data: `data/downloads/software/python_datasets/csv/geodatasets__sids.csv` and `data/downloads/software/python_datasets/geojson/geodatasets__sids.geojson`.

### Boston Housing

- Conceptual id: `software_dataset.boston_housing`
- Modeling use: spatial regression and housing-price prediction benchmark.
- Y: median housing value.
- X candidates: crime, NOx, rooms, distance, tax, pupil ratio, socioeconomic variables.
- Temporal status: absent.
- R access: `MASS::Boston`; spatial versions also appear in `spData`.
- Python access: `geodatasets spdata.boston`.
- R local data: `data/downloads/software/r_datasets/rdatasets_csv/MASS/Boston.csv`.
- Python local data: `data/downloads/software/python_datasets/csv/geodatasets__boston.csv` and `data/downloads/software/python_datasets/geojson/geodatasets__boston.geojson`.

### Guerry Moral Statistics

- Conceptual id: `software_dataset.guerry_moral_statistics`
- Modeling use: spatial social-science regression and historical regional analysis.
- Y: crime, suicide, literacy or related social outcomes depending on modeling target.
- X candidates: literacy, wealth, clergy donations, occupation and population variables.
- Temporal status: absent.
- R access: `HistData::Guerry`.
- Python access: `geodatasets geoda.guerry`.
- R local data: `data/downloads/software/r_datasets/rdatasets_csv/HistData/Guerry.csv`.
- Python local data: `data/downloads/software/python_datasets/csv/geodatasets__guerry.csv` and `data/downloads/software/python_datasets/geojson/geodatasets__guerry.geojson`.

### Georgia Education

- Conceptual id: `software_dataset.georgia_education`
- Modeling use: GWR, MGWR, and spatially varying coefficient benchmarks.
- Y: bachelor or education-rate variable.
- X candidates: income, rurality, race, poverty, age, population variables.
- Temporal status: absent.
- R access: `GWmodel::Georgia`.
- Python access: `libpysal.examples georgia`.
- R local data: package archive `data/downloads/software/r_datasets/cran_packages/GWmodel_2.4-1.tar.gz`; extracted CSVs may be generated from the R extraction script.
- Python local data: `data/downloads/software/python_datasets/csv/libpysal__georgia.csv` and `data/downloads/software/python_datasets/geojson/libpysal__georgia.geojson`.

## How the LLM Should Use This

When the user asks for software datasets, first reason at the conceptual dataset level. If a dataset exists in both languages, report it once, then list the available software access routes. For implementation, choose the route that best matches the current workflow: R for estimator examples from R packages, Python for GeoPandas/PySAL workflows, or both for reproducibility checks.
