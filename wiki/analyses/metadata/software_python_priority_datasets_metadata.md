---
title: Python Software Dataset Metadata Candidates
type: analysis_metadata
created: 2026-04-29
updated: 2026-04-29
sources: [geodatasets, libpysal, geopandas, giddy, geosnap, xarray, movingpandas, scikit-mobility]
tags: [software, python, metadata, spatial, spatiotemporal, regression, classification]
---

# Python Software Dataset Metadata Candidates

This consolidated fiche records Python package datasets retained for the system. They are software-distributed benchmark datasets, mostly from GeoDa/PySAL and `geodatasets`, used to test spatial regression, spatial panel, GWR/MGWR, epidemiology, health, housing, income, and agronomic workflows.

Machine-readable manifest: `data/manifests/software_python_priority_datasets.jsonl`.
Requested-package extension manifest: `data/manifests/software_python_requested_packages.jsonl`.
Downloaded data root: `data/downloads/software/python_datasets/`.

## Selection Rules

- Keep datasets with a response variable `Y`, explanatory variables `X`, and a spatial or spatio-temporal structure.
- Prefer datasets readable through `geopandas` and exportable to both CSV and GeoJSON.
- Exclude pure basemaps, geometry-only examples, toy grids without meaningful `Y`, and pure cartographic layers.
- Mark `X_selected` as pending until formula/model evidence is extracted from examples or package documentation.

## Download Summary

- Total candidate records: 20
- Exported CSV + GeoJSON datasets: 20
- CSV root: `data/downloads/software/python_datasets/csv/`
- GeoJSON root: `data/downloads/software/python_datasets/geojson/`
- Manifest: `data/manifests/software_python_priority_datasets.jsonl`
- Requested package manifest: `data/manifests/software_python_requested_packages.jsonl`
- Additional geosnap support exports: `data/downloads/software/python_datasets/geosnap/msa_definitions.csv` and `data/downloads/software/python_datasets/geosnap/bea_regions.csv`

## Requested Package Extensions

### giddy

- Status: installed.
- Role in system: method route for spatial dynamics, Markov transitions, rank mobility, and regional convergence.
- Dataset implication: `giddy` does not add a separate bundled dataset; it reuses PySAL/libpysal examples already present in the system.
- Useful existing local datasets: `libpysal__us_income`, `libpysal__mexico`, `geodatasets__ncovr`, `libpysal__stl`.
- Priority: high for spatio-temporal estimator testing, because it formalizes spatial dynamics over repeated regional observations.

### geosnap

- Status: downloaded through direct HTTPS fallback.
- Role in system: socio-spatial longitudinal data infrastructure, especially US census/neighborhood dynamics.
- Downloaded files:
  - `data/downloads/software/python_datasets/geosnap/msa_definitions.csv`
  - `data/downloads/software/python_datasets/geosnap/bea_regions.csv`
  - `data/downloads/software/python_datasets/geosnap/states.parquet`
  - `data/downloads/software/python_datasets/geosnap/states.csv`
  - `data/downloads/software/python_datasets/geosnap/states.geojson`
  - `data/downloads/software/python_datasets/geosnap/counties.parquet`
  - `data/downloads/software/python_datasets/geosnap/counties.csv`
  - `data/downloads/software/python_datasets/geosnap/counties.geojson`
- Note: the `DataStore` route failed through DuckDB/S3. Direct HTTPS download from the public S3 bucket worked for `states` and `counties`.
- Priority: high when the project needs longitudinal neighborhood or census-area datasets.

### xarray

- Status: downloaded through direct GitHub fallback.
- Role in system: spatio-temporal arrays and climate/ocean cubes.
- Downloaded tutorial datasets:
  - `data/downloads/software/python_datasets/xarray/air_temperature.nc`
  - `data/downloads/software/python_datasets/xarray/rasm.nc`
  - `data/downloads/software/python_datasets/xarray/tiny.nc`
  - `data/downloads/software/python_datasets/xarray/eraint_uvz.nc`
  - `data/downloads/software/python_datasets/xarray/ersstv5.nc`
- Modeling caution: most `xarray` examples are gridded arrays. They are useful for ST modeling, but lower priority for the current objective when the target is tabular regression/classification with clear `Y` and `X`.
- Validation: all downloaded NetCDF files open with `xarray` after installing `cftime`, `netCDF4`, and `h5netcdf`.

### movingpandas

- Status: installed, external examples downloaded.
- Role in system: trajectory processing once external GPS/AIS/mobility data is available.
- Downloaded example files from the public `movingpandas-examples` repository:
  - `data/downloads/software/python_datasets/movingpandas/geolife_small.csv`
  - `data/downloads/software/python_datasets/movingpandas/geolife_small.gpkg`
  - `data/downloads/software/python_datasets/movingpandas/boat-positions.csv`
  - `data/downloads/software/python_datasets/movingpandas/201901.en-movingpoint.json`
  - `data/downloads/software/python_datasets/movingpandas/201901.en-trajectory.json`
- Priority: optional; useful later for trajectories, stop detection, speed/distance features, and event-based spatio-temporal prediction.

### scikit-mobility

- Status: partially downloaded.
- Compatibility note: `skmob` expects `shapely.ops.cascaded_union`, which is absent in Shapely 2. A runtime alias to `shapely.ops.unary_union` allows package import for discovery.
- Role in system: human mobility trajectory and flow analysis after compatibility is fixed.
- Downloaded/exported datasets:
  - `data/downloads/software/python_datasets/scikit_mobility/nyc_boundaries.csv`
  - `data/downloads/software/python_datasets/scikit_mobility/nyc_boundaries.geojson`
  - `data/downloads/software/python_datasets/scikit_mobility/parking_san_francisco.csv`
- Failed datasets:
  - `foursquare_nyc` and `flow_foursquare_nyc`: source domain did not resolve.
  - `taxi_san_francisco`: requires authentication.
- Priority: optional until the Shapely compatibility issue is resolved in a stable way.

## Priority 1

### geodatasets::columbus

- Dataset key: `geoda.columbus`
- Family: `spatial_econometrics`
- Response candidates `Y`: crime
- Explanatory candidates `X`: income, housing value
- Temporal status: `absent`
- Geometry: neighborhood polygons
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 49 rows x 21 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__columbus.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__columbus.geojson`
- Column preview: `AREA`, `PERIMETER`, `COLUMBUS_`, `COLUMBUS_I`, `POLYID`, `NEIG`, `HOVAL`, `INC`, `CRIME`, `OPEN`, `PLUMB`, `DISCBD`, `X`, `Y`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::sids

- Dataset key: `geoda.sids`
- Family: `spatial_epidemiology`
- Response candidates `Y`: SIDS deaths / rates
- Explanatory candidates `X`: births, non-white births
- Temporal status: `partial_2_periods`
- Geometry: county polygons
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 100 rows x 15 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__sids.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__sids.geojson`
- Column preview: `AREA`, `PERIMETER`, `CNTY_`, `CNTY_ID`, `NAME`, `FIPS`, `FIPSNO`, `CRESS_ID`, `BIR74`, `SID74`, `NWBIR74`, `BIR79`, `SID79`, `NWBIR79`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::boston

- Dataset key: `spdata.boston`
- Family: `spatial_econometrics`
- Response candidates `Y`: housing value
- Explanatory candidates `X`: crime, NOx, rooms, distance, tax, pupil ratio
- Temporal status: `absent`
- Geometry: tract points/polygons depending source
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 506 rows x 37 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__boston.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__boston.geojson`
- Column preview: `poltract`, `TOWN`, `TOWNNO`, `TRACT`, `LON`, `LAT`, `MEDV`, `CMEDV`, `CRIM`, `ZN`, `INDUS`, `CHAS`, `NOX`, `RM`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::guerry

- Dataset key: `geoda.guerry`
- Family: `spatial_social_science`
- Response candidates `Y`: crime, suicide, literacy outcomes
- Explanatory candidates `X`: literacy, wealth, donations, occupation variables
- Temporal status: `absent`
- Geometry: French departments
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 85 rows x 24 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__guerry.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__guerry.geojson`
- Column preview: `dept`, `Region`, `Dprtmnt`, `Crm_prs`, `Crm_prp`, `Litercy`, `Donatns`, `Infants`, `Suicids`, `MainCty`, `Wealth`, `Commerc`, `Clergy`, `Crm_prn`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::georgia

- Dataset key: `georgia`
- Family: `gwr_mgwr`
- Response candidates `Y`: education / bachelor rate
- Explanatory candidates `X`: income, rurality, race, socioeconomic variables
- Temporal status: `absent`
- Geometry: county polygons
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 159 rows x 17 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__georgia.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__georgia.geojson`
- Column preview: `AREA`, `PERIMETER`, `G_UTM_`, `G_UTM_ID`, `Latitude`, `Longitud`, `TotPop90`, `PctRural`, `PctBach`, `PctEld`, `PctFB`, `PctPov`, `PctBlack`, `X`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::baltim

- Dataset key: `baltim`
- Family: `spatial_econometrics`
- Response candidates `Y`: housing price
- Explanatory candidates `X`: housing attributes and coordinates
- Temporal status: `absent`
- Geometry: points
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 211 rows x 18 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__baltim.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__baltim.geojson`
- Column preview: `STATION`, `PRICE`, `NROOM`, `DWELL`, `NBATH`, `PATIO`, `FIREPL`, `AC`, `BMENT`, `NSTOR`, `GAR`, `AGE`, `CITCOU`, `LOTSZ`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::us_income

- Dataset key: `us_income`
- Family: `spatial_panel`
- Response candidates `Y`: per-capita income
- Explanatory candidates `X`: state, year, neighbors, lag variables possible
- Temporal status: `1929_2009_panel`
- Geometry: US states
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 48 rows x 9 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__us_income.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__us_income.geojson`
- Column preview: `AREA`, `PERIMETER`, `STATE_`, `STATE_ID`, `STATE_NAME`, `STATE_FIPS`, `SUB_REGION`, `STATE_ABBR`, `geometry`
- Variable typology:
  - Modeling task hint: `spatial_panel_or_spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::mexico

- Dataset key: `mexico`
- Family: `spatial_panel`
- Response candidates `Y`: per-capita income
- Explanatory candidates `X`: Mexican state, decade, spatial structure
- Temporal status: `1940_2000_panel`
- Geometry: Mexican states
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 32 rows x 35 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__mexico.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__mexico.geojson`
- Column preview: `POLY_ID`, `AREA`, `CODE`, `NAME`, `PERIMETER`, `ACRES`, `HECTARES`, `PCGDP1940`, `PCGDP1950`, `PCGDP1960`, `PCGDP1970`, `PCGDP1980`, `PCGDP1990`, `PCGDP2000`
- Variable typology:
  - Modeling task hint: `spatial_panel_or_spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::stl

- Dataset key: `stl`
- Family: `spatiotemporal_spatial_counts`
- Response candidates `Y`: homicide counts / rates
- Explanatory candidates `X`: socioeconomic variables
- Temporal status: `three_periods`
- Geometry: county polygons
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 78 rows x 23 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__stl.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__stl.geojson`
- Column preview: `POLY_ID_OG`, `NAME`, `STATE_NAME`, `STATE_FIPS`, `CNTY_FIPS`, `FIPS`, `FIPSNO`, `HR7984`, `HR8488`, `HR8893`, `HC7984`, `HC8488`, `HC8893`, `PO7984`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::malaria

- Dataset key: `geoda.malaria`
- Family: `spatiotemporal_epidemiology`
- Response candidates `Y`: malaria incidence
- Explanatory candidates `X`: population, census/projection variables
- Temporal status: `1973_2005_mixed`
- Geometry: regions
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 1068 rows x 51 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__malaria.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__malaria.geojson`
- Column preview: `ID`, `ADM0`, `ADM1`, `ADM2`, `CODDEPT`, `IDDANE`, `DANECODE`, `TP1973`, `UP1973`, `RP1973`, `TP1985`, `UP1985`, `RP1985`, `TP1993`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

## Priority 2

### geodatasets::airbnb

- Dataset key: `geoda.airbnb`
- Family: `spatial_regression`
- Response candidates `Y`: rental price / occupancy proxy
- Explanatory candidates `X`: socioeconomics, crime, location
- Temporal status: `absent_or_snapshot`
- Geometry: Chicago community areas / listings
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 77 rows x 21 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__airbnb.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__airbnb.geojson`
- Column preview: `community`, `shape_area`, `shape_len`, `AREAID`, `response_r`, `accept_r`, `rev_rating`, `price_pp`, `room_type`, `num_spots`, `poverty`, `crowded`, `dependency`, `without_hs`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::chicago_health

- Dataset key: `geoda.chicago_health`
- Family: `spatial_health_regression`
- Response candidates `Y`: health indicators
- Explanatory candidates `X`: socioeconomic variables
- Temporal status: `snapshot`
- Geometry: Chicago community areas
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 77 rows x 87 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__chicago_health.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__chicago_health.geojson`
- Column preview: `ComAreaID`, `community`, `TRACTCnt`, `shape_area`, `shape_len`, `Pop2012`, `Pop2014`, `PopChng`, `PopM`, `PopMP`, `PopF`, `PopFP`, `Under5`, `Under5P`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::ncovr

- Dataset key: `geoda.ncovr`
- Family: `spatiotemporal_spatial_counts`
- Response candidates `Y`: homicides
- Explanatory candidates `X`: county socioeconomic variables
- Temporal status: `1960_1990`
- Geometry: US counties
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 3085 rows x 70 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__ncovr.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__ncovr.geojson`
- Column preview: `NAME`, `STATE_NAME`, `STATE_FIPS`, `CNTY_FIPS`, `FIPS`, `STFIPS`, `COFIPS`, `FIPSNO`, `SOUTH`, `HR60`, `HR70`, `HR80`, `HR90`, `HC60`
- Variable typology:
  - Modeling task hint: `count_model_or_rate_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::lasrosas

- Dataset key: `geoda.lasrosas`
- Family: `agronomic_spatial_regression`
- Response candidates `Y`: corn yield
- Explanatory candidates `X`: fertilizer, field variables, coordinates
- Temporal status: `1999_snapshot`
- Geometry: field points/polygons
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 1738 rows x 35 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__lasrosas.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__lasrosas.geojson`
- Column preview: `TOP2`, `TOP3`, `TOP4`, `NXTOP2`, `NXTOP3`, `NXTOP4`, `N2XTOP2`, `N2XTOP3`, `N2XTOP4`, `LONGITUDE`, `LATITUDE`, `OBS`, `YIELD`, `N`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::chile_labor

- Dataset key: `geoda.chile_labor`
- Family: `spatiotemporal_labor_panel`
- Response candidates `Y`: labor market outcomes
- Explanatory candidates `X`: regional and socioeconomic variables
- Temporal status: `1982_2002`
- Geometry: Chile regions
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 64 rows x 140 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__chile_labor.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__chile_labor.geojson`
- Column preview: `dummy`, `code_flma`, `mun`, `pop_1982`, `pop_1992`, `pop_2002`, `area_km2`, `age1__1982`, `age2__1982`, `age3__1982`, `age4__1982`, `age5__1982`, `age6__1982`, `age7__1982`
- Variable typology:
  - Modeling task hint: `spatial_panel_or_spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::nyc_earnings

- Dataset key: `geoda.nyc_earnings`
- Family: `spatiotemporal_income_panel`
- Response candidates `Y`: earnings
- Explanatory candidates `X`: block-level demographic/economic variables
- Temporal status: `2002_2014`
- Geometry: NYC blocks
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 108487 rows x 71 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__nyc_earnings.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__nyc_earnings.geojson`
- Column preview: `STATEFP10`, `COUNTYFP10`, `TRACTCE10`, `BLOCKCE10`, `GEOID10`, `NAME10`, `MTFCC10`, `UR10`, `UACE10`, `UATYP10`, `FUNCSTAT10`, `ALAND10`, `AWATER10`, `INTPTLAT10`
- Variable typology:
  - Modeling task hint: `spatial_panel_or_spatiotemporal_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::home_sales

- Dataset key: `geoda.home_sales`
- Family: `spatial_econometrics`
- Response candidates `Y`: home sale price
- Explanatory candidates `X`: housing attributes, location
- Temporal status: `2014_2015_partial`
- Geometry: King County points/polygons
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 21613 rows x 22 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__home_sales.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__home_sales.geojson`
- Column preview: `id`, `date`, `price`, `bedrooms`, `bathrooms`, `sqft_liv`, `sqft_lot`, `floors`, `waterfront`, `view`, `condition`, `grade`, `sqft_above`, `sqft_basmt`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::cincinnati

- Dataset key: `geoda.cincinnati`
- Family: `spatial_crime_regression`
- Response candidates `Y`: crime
- Explanatory candidates `X`: socio-demographics
- Temporal status: `2008_snapshot`
- Geometry: Cincinnati neighborhoods
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 457 rows x 73 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__cincinnati.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__cincinnati.geojson`
- Column preview: `ID`, `AREA`, `BLOCK`, `BG`, `TRACT`, `COUNTY`, `MSA`, `POPULATION`, `MALE`, `FEMALE`, `AGE_0_5`, `AGE_5_9`, `AGE_10_14`, `AGE_15_19`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### libpysal::tokyo

- Dataset key: `tokyo`
- Family: `spatial_health_regression`
- Response candidates `Y`: mortality
- Explanatory candidates `X`: area-level covariates
- Temporal status: `snapshot_or_period`
- Geometry: Tokyo areas
- Source package: `libpysal`
- Download status: `extracted_csv_geojson`
- Shape: 262 rows x 4 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\libpysal__tokyo.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\libpysal__tokyo.geojson`
- Column preview: `GEOCODE`, `AREANAME`, `AreaID`, `geometry`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

### geodatasets::us_sdoh

- Dataset key: `geoda.us_sdoh`
- Family: `spatial_health_regression`
- Response candidates `Y`: social/health outcomes
- Explanatory candidates `X`: social determinants of health
- Temporal status: `2014_snapshot`
- Geometry: US units
- Source package: `geodatasets`
- Download status: `extracted_csv_geojson`
- Shape: 71901 rows x 26 columns
- Local CSV: `llm-wiki-karpathy\data\downloads\software\python_datasets\csv\geodatasets__us_sdoh.csv`
- Local GeoJSON: `llm-wiki-karpathy\data\downloads\software\python_datasets\geojson\geodatasets__us_sdoh.geojson`
- Column preview: `tract_fips`, `county`, `state`, `state_fips`, `cnty_fips`, `ep_pov`, `ep_unem`, `ep_pci`, `ep_nohs`, `ep_sngp`, `ep_lime`, `ep_crow`, `ep_nove`, `rent_1`
- Variable typology:
  - Modeling task hint: `spatial_regression`
  - `X_candidates`: documented above; `X_selected`: pending data inspection or model formula extraction.
- Modeling evidence: pending. Package examples should be inspected next to recover formulas or canonical model use.

## Next Actions

- Inspect the exported CSV/GeoJSON pairs to confirm exact `Y`, `X_candidates`, and geometry fields.
- Extract canonical formulas from PySAL/GeoDa notebooks or examples where available.
- Promote only the datasets actually used for estimator tests into separate dataset pages if needed.
- Link selected datasets to estimator eligibility rules, especially `lagsarlm`, GWR/MGWR, count/risk models, and spatial panel models.
