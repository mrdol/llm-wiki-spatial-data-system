---
title: World Development Indicators
type: dataset
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [dataset, World Bank, WDI, country-time, metadata, global, spatio-temporal]
---

Large multi-topic country-time indicator database with strong metadata layers for series, countries, classifications, and access APIs.

## Dataset Name

- World Development Indicators (WDI)

## Source / Warehouse

- Warehouse: [[world_bank]]
- Provider: World Bank
- Warehouse type: international development data warehouse
- Official catalog page: [World Development Indicators](https://datacatalog.worldbank.org/infrastructure-data/search/dataset/0037712/world-development-indicators)
- Official API documentation: [SDMX API Queries](https://datahelpdesk.worldbank.org/knowledgebase/articles/1886701-sdmx-api-queries)

## Why It Is Useful for Metadata Enrichment

- It is one of the strongest examples of a metadata-rich global indicator warehouse.
- It combines series metadata, country metadata, classifications, and API-query dimensions in a single dissemination system.
- It is highly useful for modeling catalog fields such as indicator code, source note, topic, country metadata, region, income level, time range, and download method.

## Structured Metadata

### Variables

- Indicator values by country and year
- Series code
- Series name
- Unit
- Source note
- Source organization
- Topic identifier and topic name
- Country code
- Country name
- Region
- Income level
- Lending type
- Capital city
- Latitude and longitude in country metadata responses

### Classifications

- Indicator codes
- Topic taxonomy
- Country ISO codes
- Region classifications
- Income-level classifications
- Lending-type classifications

### Spatial Units

- Countries and territories
- Regional and global aggregates

### Time Dimension

- Single year or year ranges in API queries
- Multi-decade historical coverage

### Frequency

- Mostly annual in the standard WDI dissemination model, with API support for time-scoped requests

## Data Type

- Global spatio-temporal indicator panel

## Structure

- Country-year panel across a large indicator set

## N (observations)

- Very large; over 1,500 indicators across more than 200 countries and territories

## T (time periods)

- Several decades

## N/T Profile

- N large, T large

## Spatial Resolution

- Country and aggregate region level

## Temporal Resolution

- Annual in the standard WDI interpretation

## Spatial Extent

- Global

## Time Range

- Several decades according to the World Bank catalog page

## Reproducibility

- Strong reproducibility through stable catalog versions, API access, downloadable files, and explicit metadata endpoints.

## Access Conditions

- Public access through the World Bank Data Catalog, Databank, Indicators API, and SDMX API
- Downloadable ZIP and metadata files are listed on the catalog page
- API access does not require authentication according to the developer documentation

## Limitations

- The database is extremely broad, so meaningful extraction requires careful indicator and country scoping.
- Entire-database SDMX requests are not allowed in a single call; requests are limited to 15,000 data points including nulls.
- Spatial support is country-level rather than subnational in the core WDI design.

## Related Pages

- [[world_bank]]
- [[overview]]
- [[dataset_catalog_schema_v2]]
