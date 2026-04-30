---
title: Metadata-oriented dataset discovery across referenced warehouses
type: analysis
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [analysis, metadata, discovery, warehouses, catalog]
---

Comparative note identifying warehouse-backed datasets that are especially useful for building a richer metadata catalog.

## Selection Logic

Datasets were prioritized when they combined:

- explicit spatial units
- a clear time dimension
- structured classifications
- documented variables or schema
- stable access routes or platform metadata

## Comparison Table

| Dataset | Warehouse | Spatial units | Time dimension | Classification richness | Metadata-enrichment value |
|---|---|---|---|---|---|
| [[insee_base_permanente_equipements]] | [[insee]] | commune, Iris, coordinates | annual snapshots | equipment domains, gammes, equipment types | very strong for fine geography and multi-scale spatial metadata |
| [[eurostat_comext_itg]] | [[eurostat]] | reporter, partner, geo-economic areas | month and/or year | CN, SITC, BEC, CPA | very strong for mixed frequency and product-classification metadata |
| [[data_gouv_dvf_geolocalisees]] | [[data_gouv]] | department, commune, parcel, coordinates | mutation date, rolling recent years | INSEE codes, FANTOIR, local and land-use codes | very strong for event-time geospatial metadata and administrative normalization |
| [[oecd_itcs]] | [[oecd]] | reporting country, partner country, groupings | annual | SITC and HS blocks | strong for annual bilateral panels and classification-dependent releases |
| [[world_bank_world_development_indicators]] | [[world_bank]] | countries, regional and global aggregates | country-year | indicator codes, topics, country classifications | very strong for API metadata, country metadata, and series taxonomies |
| [[un_comtrade_merchandise_trade]] | [[un_comtrade]] | reporter, partner | annual and monthly | HS, SITC, BEC, correspondence tables | very strong for classification governance and bilateral trade structure |
| [[cepii_baci]] | [[cepii]] | exporter, importer | annual | HS revisions with bundled country/product metadata | very strong for versioning, lineage, and harmonized trade metadata |

## Main Catalog Design Implications

- Catalog entries should distinguish `warehouse`, `provider`, and `upstream lineage`.
- Spatial metadata must support multiple granularities:
  - country
  - region
  - commune
  - parcel
  - coordinates
- Classification metadata should capture both:
  - the active nomenclature
  - any correspondence or conversion tables
- Time metadata should distinguish:
  - snapshot date
  - event date
  - annual series
  - monthly series
  - rolling window dissemination
- Access metadata should capture:
  - portal
  - API
  - bulk download
  - documentation and notice files

## Related Pages

- [[dataset_catalog_schema_v2]]
- [[insee]]
- [[eurostat]]
- [[data_gouv]]
- [[oecd]]
- [[world_bank]]
- [[un_comtrade]]
- [[cepii]]
