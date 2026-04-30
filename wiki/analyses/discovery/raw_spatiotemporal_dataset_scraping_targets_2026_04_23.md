---
title: Raw spatio-temporal dataset scraping targets
type: analysis
created: 2026-04-23
updated: 2026-04-23
sources:
  - https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels
  - https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily
  - https://cds.climate.copernicus.eu/datasets/insitu-gridded-observations-europe
  - https://opensky-network.org/data/scientific
  - https://globalfishingwatch.org/dataset-and-code-fishing-effort/
  - https://zenodo.org/records/14982712
  - https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
  - https://www.nature.com/articles/s41597-025-06167-2
  - https://www.nature.com/articles/s41597-024-03102-9
  - https://www.nature.com/articles/s41597-025-05480-0
  - https://ideas.repec.org/p/arx/papers/2002.03922.html
tags: [analysis, scraping, raw-data, spatio-temporal, datasets, papers]
---

Candidate targets for scraping raw or near-raw datasets with explicit spatial and temporal structure, preferably at large scale and with linked papers or data descriptors.

## Selection Criteria

- Spatial support: coordinates, grid cells, stations, zones, regions, trajectories, or polygons.
- Temporal support: timestamp, day, month, year, event date, or time series.
- Large dimension: many rows, large rasters, high-frequency time, global coverage, or high-resolution grids.
- Rawness: direct files, API, NetCDF, GRIB, CSV/Parquet, raw event records, or minimally aggregated records.
- Paper linkage: DOI, Scientific Data descriptor, journal article, IDEAS/RePEc entry, or explicit citation page.

## Priority Targets

| Priority | Dataset | Domain | Spatial x temporal structure | Scale / format | Paper link status | Access / scraping route | Notes |
|---|---|---|---|---|---|---|---|
| 1 | ERA5 hourly single levels | climate / environment | global 0.25 degree grid x hourly from 1940-present | GRIB via Copernicus CDS; DOI `10.24381/cds.adbb2d47` | strong: Hersbach et al. 2020, `10.1002/qj.3803` | CDS API, STAC/CSW metadata | Excellent benchmark for STVC/MGWR-style feature engineering; very large, but extraction should be bounded by region/variables. |
| 1 | GHCN-Daily | station climate | station coordinates x daily records, over 100,000 stations | ASCII station files and global tar.gz | strong: Menne et al. / GHCN-Daily structure papers; Computers & Geosciences overview | NOAA NCEI bulk download | More raw than gridded products; useful for station-to-grid comparisons and missingness metadata. |
| 1 | E-OBS daily gridded observations | Europe climate | Europe land grid x daily, 1950-present | NetCDF, 0.1 and 0.25 degree grids | strong: E-OBS validation and product papers | Copernicus CDS / ECA&D download | Fits European spatio-temporal modelling; variables include temperature, precipitation, pressure, wind, humidity, radiation. |
| 1 | OpenSky Network scientific datasets | aviation trajectories | aircraft state vectors with lat/lon/altitude/time | CSV, Avro, JSON, Trino snapshots | strong: Earth System Science Data 2021 and linked aviation papers | OpenSky scientific dataset pages / Zenodo | Very large trajectory data; strong for spatio-temporal point processes and mobility models. |
| 2 | Global Fishing Watch apparent fishing effort | maritime activity | grid cells or vessel-hour summaries x daily/monthly from 2012-2024 | API, R package, download portal, BigQuery, Zenodo | strong: Science 2018 plus Zenodo dataset | GFW download/API; Zenodo record `14982712` | Not raw AIS publicly; derived effort is open. Keep rawness flag as `processed_from_raw_AIS`. |
| 2 | NYC TLC trip records | urban mobility | pickup/dropoff zones or coordinates x timestamps | monthly Parquet/CSV trip records | medium: many applied papers, official portal not a data paper | TLC monthly files and taxi zone shapefile | Very easy raw scraping, good for large urban spatio-temporal examples; paper links need literature matching. |
| 2 | Sen12Landslides | Earth observation hazards | image patches with Sentinel-1/Sentinel-2/DEM x pre/event/post timestamps | NetCDF tar archives, Hugging Face, 10 m patches | strong: Scientific Data 2025, DOI `10.1038/s41597-025-06167-2` | Hugging Face dataset plus GitHub code | Good high-dimensional spatial-temporal image benchmark; less tabular but metadata-rich. |
| 2 | MEANS-ST1.0 China nutrient discharge | environmental pressure | 1 km grid x monthly, 1980-2020 | GeoTIFF, NetCDF, Excel | strong: Scientific Data 2024, DOI `10.1038/s41597-024-03102-9` | Data descriptor data availability links | Highly relevant for environmental/agricultural modelling; likely manageable subsets. |
| 3 | Extreme weather segmentation/tracking dataset | atmosphere / hazards | gridded weather fields x time with segmentation labels | large ML-ready dataset | strong: Scientific Data 2025, DOI page found | data availability section to verify | Good for high-dimensional spatio-temporal learning; verify licensing and raw file layout before cataloging. |
| 3 | GBIF occurrence downloads | biodiversity | occurrence coordinates x event date/year | TSV/CSV/SQL downloads with DOI per query | medium/strong: DOI per download, many biodiversity papers | GBIF API/download predicates | Very large and flexible; paper linkage may be query-specific rather than one canonical paper. |

## IDEAS / RePEc Leads

These are not necessarily downloadable data sources, but they are useful paper leads for datasets or model use cases:

| Lead | Why useful | Next check |
|---|---|---|
| Bille and Rogna, "The Effect of Weather Conditions on Fertilizer Applications: A Spatial Dynamic Panel Data Analysis" | IDEAS page reports a huge gridded dataset over 1993-2013 and a spatial dynamic panel specification. | Trace data availability from arXiv/paper; look for replication package or cited source datasets. |
| Saguatti, Erickson, Gutierrez, "Spatial panel models for the analysis of land prices" | Agricultural land values, 12 Midwestern U.S. states, 1971-2009; spatial panel model. | Check USDA/NASS or replication materials for raw panel source. |
| Pirotte and Madre, "Car Traffic Elasticities..." | French regional panel, 1973-1999, spatial interdependence. | Check whether data are recoverable from transport statistics. |
| Elhorst spatial panel references | Good methodological anchor for spatial panel compatibility notes. | Use for model-method paper linking, not raw scraping. |

## Scraping Queries To Run

Use these as reproducible seeds for OpenAlex, Crossref, Google Scholar manual checks, IDEAS/RePEc, and general web search:

```text
"spatio-temporal dataset" +"Scientific Data" +"Data availability" +"NetCDF"
"large-scale" +"spatio-temporal" +"dataset" +"raw data" +"DOI"
"spatial dynamic panel" +"dataset" +"replication" +"IDEAS"
"gridded data" +"monthly" +"1 km" +"Scientific Data" +"NetCDF"
"trajectory dataset" +"state vectors" +"Zenodo" +"Scientific Data"
"regional panel dataset" +"spatial panel" +"replication data"
```

## Scraping Implementation Notes

- Do not scrape Google Scholar directly as an automated source; use it for manual confirmation because it is prone to blocking and terms-of-use issues.
- Prefer API-first sources: Copernicus CDS, NOAA, OpenSky, GBIF, Zenodo, OpenAlex, Crossref, RePEc/IDEAS pages.
- Store raw API responses separately from curated catalog entries.
- Add a `rawness_level` field when cataloging:
  - `raw_observations`
  - `lightly_processed_observations`
  - `gridded_reanalysis`
  - `derived_model_output`
  - `ml_benchmark_patch_dataset`
- Add a `paper_link_status` field:
  - `dataset_doi`
  - `data_descriptor`
  - `method_paper`
  - `applied_paper_only`
  - `paper_link_pending`

## Immediate Next Batch

1. Build manifest records for ERA5, GHCN-Daily, E-OBS, OpenSky, Global Fishing Watch, NYC TLC, Sen12Landslides, and MEANS-ST1.0.
2. For each target, run OpenAlex/Crossref by DOI and exact title.
3. Only promote a paper link to the catalog when the paper explicitly names the dataset or the dataset page provides the citation.
4. Download only a bounded sample first: one variable, one region, and one short time range, unless the dataset is already small enough.

## Related Pages

- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]
- [[dataset_ranking_metadata_spatial_download_priority_2026_04_22]]
- [[discovery_policy_v3]]
- [[catalog_registry_schema_v3]]
