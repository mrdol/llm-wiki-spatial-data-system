---
title: R Software Dataset Metadata Candidates
type: analysis_metadata
created: 2026-04-29
updated: 2026-04-29
sources: [Rdatasets, CRAN package archives]
tags: [software, r, metadata, spatial, spatiotemporal, regression, classification]
---

# R Software Dataset Metadata Candidates

This consolidated fiche records the priority 1 and priority 2 R software datasets retained for the system. These datasets are not external warehouse targets; they are software-distributed benchmark datasets used to test estimator eligibility, variable typology, and spatial/spatio-temporal modeling workflows.

Machine-readable manifest: `data/manifests/software_r_priority_datasets.jsonl`.
Downloaded data root: `data/downloads/software/r_datasets/`.

## Selection Rules

- Keep datasets with a response variable `Y`, explanatory variables `X`, and a spatial or spatio-temporal structure.
- Exclude pure basemaps, pure rasters, cartographic examples, and geometry-only datasets.
- Treat package archives as raw software sources when direct CSV export is unavailable.
- Mark `X_selected` as pending until the dataset is inspected or a paper/manual specifies the actual model formula.

## Download Summary

- Total candidate records: 32
- Direct CSV files downloaded: 7
- Candidate records covered through CRAN package archives: 23
- Not downloaded: 2
- Extracted CSV objects from CRAN archives after enabling local R 4.5.3: 28
- Extraction manifest: `data/manifests/software_r_extracted_datasets.jsonl`
- Extracted CSV root: `data/downloads/software/r_datasets/extracted_csv/`

## R Extraction Status

Local R was found at `C:/Users/jdoliveira/AppData/Local/Programs/R/R-4.5.3/bin/Rscript.exe` and used to extract `.rda` / `.RData` objects from downloaded CRAN archives.

Successfully extracted examples include:

- `spdep::columbus`: tabular attributes, coordinates, and neighbor-boundary support tables.
- `GWmodel::Georgia` and `GWmodel::EWHP`: GWR-ready attribute tables.
- `gstat::meuse` and `gstat::jura`: geostatistical point/grid/prediction/validation tables.
- `spacetime::air`: wide station-time air-quality table.
- `surveillance::imdepi`: spatio-temporal event table.
- `SpatialEpi::pennLC`, `SpatialEpi::scotland`, `SpatialEpi::NYleukemia`: sf-like epidemiological attribute tables.
- `vegan::mite`, `vegan::dune`, `vegan::varespec/varechem`: ecological response/covariate tables.

Some objects remain unconverted because they are specialized S4/spatial classes or require package namespaces not installed in the R library, especially `surveillance`, `sp`, and some `ade4` objects. Those remain traceable through the package archives and extraction manifest.

## Priority 1

### spdep::columbus

- Family: `spatial_econometrics`
- Response candidates `Y`: crime
- Explanatory candidates `X`: income, housing value
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\spdep_1.4-2.tar.gz`
- Data files found in archive: `spdep/data/columbus.rda`
- Download URL: `https://cran.r-project.org/src/contrib/spdep_1.4-2.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### spdep::nc.sids

- Family: `spatial_epidemiology`
- Response candidates `Y`: SIDS deaths / rates
- Explanatory candidates `X`: births, non-white births
- Temporal status: `partial_2_periods`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\spdep_1.4-2.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/spdep_1.4-2.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### MASS::Boston

- Family: `spatial_econometrics`
- Response candidates `Y`: median housing value
- Explanatory candidates `X`: crime, NOx, rooms, distance, tax, pupil ratio
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\MASS\Boston.csv`
- Rdatasets shape: 506 rows x 14 columns
- Column preview: `rownames`, `crim`, `zn`, `indus`, `chas`, `nox`, `rm`, `age`, `dis`, `rad`, `tax`, `ptratio`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/MASS/Boston.csv`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### HistData::Guerry

- Family: `spatial_social_science`
- Response candidates `Y`: crime, suicide, literacy outcomes
- Explanatory candidates `X`: literacy, wealth, donations, occupation variables
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\HistData\Guerry.csv`
- Rdatasets shape: 86 rows x 23 columns
- Column preview: `rownames`, `dept`, `Region`, `Department`, `Crime_pers`, `Crime_prop`, `Literacy`, `Donations`, `Infants`, `Suicides`, `MainCity`, `Wealth`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/HistData/Guerry.csv`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### GWmodel::Georgia

- Family: `gwr_mgwr`
- Response candidates `Y`: education / bachelor rate
- Explanatory candidates `X`: income, rurality, race, socioeconomic variables
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\GWmodel_2.4-1.tar.gz`
- Data files found in archive: `GWmodel/data/GeorgiaCounties.rda`, `GWmodel/data/Georgia.rda`
- Download URL: `https://cran.r-project.org/src/contrib/GWmodel_2.4-1.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### GWmodel::LondonHP

- Family: `gwr_mgwr`
- Response candidates `Y`: housing price
- Explanatory candidates `X`: floor area, rooms, property and access variables
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\GWmodel_2.4-1.tar.gz`
- Data files found in archive: `GWmodel/data/LondonHP.rda`
- Download URL: `https://cran.r-project.org/src/contrib/GWmodel_2.4-1.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### GWmodel::EWHP

- Family: `gwr_mgwr`
- Response candidates `Y`: housing price
- Explanatory candidates `X`: housing attributes
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\GWmodel_2.4-1.tar.gz`
- Data files found in archive: `GWmodel/data/EWHP.rda`
- Download URL: `https://cran.r-project.org/src/contrib/GWmodel_2.4-1.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### GWmodel::DubVoter

- Family: `gwr_mgwr`
- Response candidates `Y`: vote rate
- Explanatory candidates `X`: socioeconomic indicators
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\GWmodel_2.4-1.tar.gz`
- Data files found in archive: `GWmodel/data/DubVoter.rda`
- Download URL: `https://cran.r-project.org/src/contrib/GWmodel_2.4-1.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### gstat::meuse

- Family: `geostatistical_regression`
- Response candidates `Y`: zinc, copper, lead, cadmium
- Explanatory candidates `X`: distance to river, flood frequency, soil, lime, elevation
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\gstat_2.1-6.tar.gz`
- Data files found in archive: `gstat/data/meuse.all.rda`, `gstat/data/meuse.alt.rda`
- Download URL: `https://cran.r-project.org/src/contrib/gstat_2.1-6.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### gstat::jura

- Family: `geostatistical_regression`
- Response candidates `Y`: soil metals
- Explanatory candidates `X`: land use, rock, coordinates
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\gstat_2.1-6.tar.gz`
- Data files found in archive: `gstat/data/jura.rda`
- Download URL: `https://cran.r-project.org/src/contrib/gstat_2.1-6.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### plm::Produc

- Family: `spatial_panel`
- Response candidates `Y`: gross state product
- Explanatory candidates `X`: capital, labor, public capital, unemployment
- Temporal status: `annual_panel`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\plm\Produc.csv`
- Rdatasets shape: 816 rows x 11 columns
- Column preview: `rownames`, `state`, `year`, `region`, `pcap`, `hwy`, `water`, `util`, `pc`, `gsp`, `emp`, `unemp`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/plm/Produc.csv`
- Variable typology:
  - Modeling task hint: `panel_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### AER::GrowthDJ

- Family: `spatial_panel`
- Response candidates `Y`: GDP growth
- Explanatory candidates `X`: investment, education, trade, macro variables
- Temporal status: `panel_or_period`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\AER\GrowthDJ.csv`
- Rdatasets shape: 121 rows x 10 columns
- Column preview: `rownames`, `oil`, `inter`, `oecd`, `gdp60`, `gdp85`, `gdpgrowth`, `popgrowth`, `invest`, `school`, `literacy60`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/AER/GrowthDJ.csv`
- Variable typology:
  - Modeling task hint: `panel_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### spacetime::air

- Family: `spatiotemporal_regression`
- Response candidates `Y`: NO2 concentration
- Explanatory candidates `X`: station, season, traffic proxies
- Temporal status: `explicit_st`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\spacetime_1.3-3.tar.gz`
- Data files found in archive: `spacetime/data/air.rda`
- Download URL: `https://cran.r-project.org/src/contrib/spacetime_1.3-3.tar.gz`
- Variable typology:
  - Modeling task hint: `spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### STRbook::NOAA_df_1990

- Family: `spatiotemporal_regression`
- Response candidates `Y`: temperature / precipitation
- Explanatory candidates `X`: station, coordinates, date
- Temporal status: `daily_st`
- Source family: `software` / R package
- Download status: `not_found_on_cran`
- Variable typology:
  - Modeling task hint: `spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### STRbook::Midwest_df

- Family: `spatiotemporal_regression`
- Response candidates `Y`: temperature
- Explanatory candidates `X`: coordinates, time
- Temporal status: `monthly_st`
- Source family: `software` / R package
- Download status: `not_found_on_cran`
- Variable typology:
  - Modeling task hint: `spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### surveillance::measles

- Family: `spatiotemporal_epidemiology`
- Response candidates `Y`: measles cases
- Explanatory candidates `X`: vaccination, seasonality, region
- Temporal status: `weekly_st`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\surveillance_1.25.0.tar.gz`
- Data files found in archive: `surveillance/data/measles.weser.RData`, `surveillance/data/measlesDE.RData`, `surveillance/data/measlesWeserEms.RData`
- Download URL: `https://cran.r-project.org/src/contrib/surveillance_1.25.0.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### surveillance::rotavirus

- Family: `spatiotemporal_epidemiology`
- Response candidates `Y`: rotavirus cases
- Explanatory candidates `X`: region, seasonality
- Temporal status: `weekly_st`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\surveillance_1.25.0.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/surveillance_1.25.0.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### surveillance::imdepi

- Family: `spatiotemporal_epidemiology`
- Response candidates `Y`: meningococcal cases
- Explanatory candidates `X`: strain type, spatial and temporal coordinates
- Temporal status: `event_st`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\surveillance_1.25.0.tar.gz`
- Data files found in archive: `surveillance/data/imdepifit.RData`, `surveillance/data/imdepi.RData`
- Download URL: `https://cran.r-project.org/src/contrib/surveillance_1.25.0.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

## Priority 2

### SpatialEpi::pennLC

- Family: `spatial_epidemiology`
- Response candidates `Y`: lung cancer mortality
- Explanatory candidates `X`: smoking, race, sex, age
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\SpatialEpi_1.2.8.tar.gz`
- Data files found in archive: `SpatialEpi/data/pennLC_sf.rda`, `SpatialEpi/data/pennLC.rda`
- Download URL: `https://cran.r-project.org/src/contrib/SpatialEpi_1.2.8.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### SpatialEpi::scotland

- Family: `spatial_epidemiology`
- Response candidates `Y`: lip cancer mortality
- Explanatory candidates `X`: AFF agriculture/fishing/forestry
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\SpatialEpi_1.2.8.tar.gz`
- Data files found in archive: `SpatialEpi/data/scotland_sf.rda`, `SpatialEpi/data/scotland.rda`
- Download URL: `https://cran.r-project.org/src/contrib/SpatialEpi_1.2.8.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### SpatialEpi::NYleukemia

- Family: `spatial_epidemiology`
- Response candidates `Y`: leukemia cases
- Explanatory candidates `X`: TCE exposure
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\SpatialEpi_1.2.8.tar.gz`
- Data files found in archive: `SpatialEpi/data/NYleukemia_sf.rda`, `SpatialEpi/data/NYleukemia.rda`
- Download URL: `https://cran.r-project.org/src/contrib/SpatialEpi_1.2.8.tar.gz`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### SpatialEpi::germany

- Family: `spatial_epidemiology`
- Response candidates `Y`: laryngeal cancer
- Explanatory candidates `X`: foundry exposure / covariates
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\SpatialEpi_1.2.8.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/SpatialEpi_1.2.8.tar.gz`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### vegan::mite

- Family: `ecological_regression_classification`
- Response candidates `Y`: mite abundance
- Explanatory candidates `X`: substrate density, water content, shrub, topography
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\vegan_2.7-3.tar.gz`
- Data files found in archive: `vegan/data/mite.rda`, `vegan/data/mite.pcnm.rda`, `vegan/data/mite.env.rda`, `vegan/data/mite.xy.rda`
- Download URL: `https://cran.r-project.org/src/contrib/vegan_2.7-3.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### vegan::dune

- Family: `ecological_regression_classification`
- Response candidates `Y`: plant abundance
- Explanatory candidates `X`: moisture, management, use, manure
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\vegan_2.7-3.tar.gz`
- Data files found in archive: `vegan/data/dune.env.rda`, `vegan/data/dune.taxon.rda`, `vegan/data/dune.phylodis.rda`, `vegan/data/dune.rda`
- Download URL: `https://cran.r-project.org/src/contrib/vegan_2.7-3.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### vegan::varespec/varechem

- Family: `ecological_regression_classification`
- Response candidates `Y`: vegetation cover
- Explanatory candidates `X`: soil chemistry, bare soil, humus depth
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\vegan_2.7-3.tar.gz`
- Data files found in archive: `vegan/data/varespec.rda`
- Download URL: `https://cran.r-project.org/src/contrib/vegan_2.7-3.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### ade4::doubs

- Family: `ecological_regression_classification`
- Response candidates `Y`: fish abundance
- Explanatory candidates `X`: water chemistry, pH, hardness, phosphate, nitrate
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\ade4_1.7-24.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/ade4_1.7-24.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### ade4::mafragh

- Family: `ecological_regression_classification`
- Response candidates `Y`: vegetation
- Explanatory candidates `X`: soil chemistry, texture
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\ade4_1.7-24.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/ade4_1.7-24.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### ade4::rpjdl

- Family: `ecological_regression_classification`
- Response candidates `Y`: bird abundance
- Explanatory candidates `X`: habitat variables
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\ade4_1.7-24.tar.gz`
- Data files found in archive: `ade4/data/rpjdl.rda`
- Download URL: `https://cran.r-project.org/src/contrib/ade4_1.7-24.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### dismo::bradypus

- Family: `species_distribution_classification`
- Response candidates `Y`: presence / absence
- Explanatory candidates `X`: bioclimatic variables
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded`
- Local package archive: `llm-wiki-karpathy\data\downloads\software\r_datasets\cran_packages\dismo_1.3-16.tar.gz`
- Download URL: `https://cran.r-project.org/src/contrib/dismo_1.3-16.tar.gz`
- Variable typology:
  - Modeling task hint: `classification`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### agridat::adugna.sorghum

- Family: `agronomic_spatiotemporal_trials`
- Response candidates `Y`: yield
- Explanatory candidates `X`: genotype, location, year, treatment
- Temporal status: `multi_year`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\agridat\adugna.sorghum.csv`
- Rdatasets shape: 289 rows x 6 columns
- Column preview: `rownames`, `gen`, `trial`, `env`, `yield`, `year`, `loc`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/agridat/adugna.sorghum.csv`
- Variable typology:
  - Modeling task hint: `spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### agridat::acorsi.grayleafspot

- Family: `agronomic_spatial_trials`
- Response candidates `Y`: disease / yield traits
- Explanatory candidates `X`: genotype, location, treatment
- Temporal status: `partial`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\agridat\acorsi.grayleafspot.csv`
- Rdatasets shape: 648 rows x 4 columns
- Column preview: `rownames`, `gen`, `env`, `rep`, `y`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/agridat/acorsi.grayleafspot.csv`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

### agridat::battese.survey

- Family: `agronomic_remote_sensing_regression`
- Response candidates `Y`: corn/soy area
- Explanatory candidates `X`: survey and satellite covariates
- Temporal status: `absent`
- Source family: `software` / R package
- Download status: `downloaded_csv`
- Local CSV: `llm-wiki-karpathy\data\downloads\software\r_datasets\rdatasets_csv\agridat\battese.survey.csv`
- Rdatasets shape: 37 rows x 9 columns
- Column preview: `rownames`, `county`, `segment`, `countysegs`, `cornhect`, `soyhect`, `cornpix`, `soypix`, `cornmean`, `soymean`
- Download URL: `https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/agridat/battese.survey.csv`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. No equation has been extracted yet from package manuals or associated papers.

## Next Actions

- Install or enable R when `.rda` package data must be converted to CSV/Parquet.
- Inspect each downloaded CSV/archive to populate exact `X_candidates`, `X_selected`, geometry columns, and missingness.
- Link each dataset to eligible estimators after variable typology is confirmed.
- For CRAN archives, extract package manual examples to recover published formulas when available.
