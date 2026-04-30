---
title: UN Comtrade Merchandise Trade Database
type: dataset
created: 2026-04-21
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
tags: [dataset, trade, UN, Comtrade, SITC, HS, spatio-temporal, metadata]
---

Global merchandise-trade database with explicit commodity, reporter, partner, value, quantity, and classification metadata.

## Dataset Name

- UN Comtrade Merchandise Trade Database

## Source / Warehouse

- Warehouse: [[un_comtrade]]
- Provider: United Nations Statistics Division (UNSD)
- Official methodology page: [IMTS Methodology](https://unstats.un.org/unsd/trade/imts/methodology.asp)
- Official data record page: [Trade data record layout](https://unstats.un.org/unsd/trade/dataextract/datarecord.htm)
- Official explorer about page: [UN Comtrade data explorer - About](https://comtrade.un.org/labs/data-explorer/About.html)

## Why It Is Useful for Metadata Enrichment

- It is a benchmark example of a very large spatio-temporal trade warehouse with explicit classification governance.
- It clearly distinguishes reporter, partner, direction of trade, commodity code, value, quantity unit, and quantity.
- It is useful for designing metadata fields for classification conversions, mirror-data issues, and valuation conventions.

## Structured Metadata

### Variables

- Direction of trade
- Commodity code
- Partner code
- Value in thousands of US dollars
- Quantity unit code
- Quantity
- Reporter country code

### Classifications

- Standard International Trade Classification (SITC)
- Harmonized System (HS)
- Broad Economic Categories (BEC)
- UN correspondence and conversion tables between HS and SITC

### Spatial Units

- Reporter country or area
- Partner country or area
- Regional groupings in analytical views

### Time Dimension

- Annual trade data from 1962 to the most recent year in the explorer description
- Monthly and annual trade representations depending on extract

### Frequency

- Annual and monthly depending on the extract
- Data in the explorer are refreshed every second week according to the official about page

## Data Type

- Spatio-temporal trade panel

## Structure

- Panel

## N (observations)

- Extremely large; the explorer page describes more than 3 billion records

## T (time periods)

- Long multi-decade coverage

## N/T Profile

- N very large, T large

## Spatial Resolution

- Bilateral reporter-partner flows

## Temporal Resolution

- Annual and monthly depending on extract

## Spatial Extent

- Global, close to 200 countries or areas

## Time Range

- 1962 to recent years in annual trade coverage

## Reproducibility

- Strong reproducibility through UNSD methodology pages, explicit record layout, and classification correspondences.

## Access Conditions

- Public access through UNSD trade pages and Comtrade explorer
- API-powered dissemination is explicitly referenced by UNSD analytical trade pages

## Limitations

- HS to SITC conversion can be approximate.
- Missing reporters may trigger use of mirror or estimated data in some dissemination layers.
- Customs-basis trade data are not directly compatible with balance-of-payments data.

## Related Pages

- [[un_comtrade]]
- [[cepii_baci]]
- [[eurostat_comext_itg]]
- [[dataset_catalog_schema_v2]]
