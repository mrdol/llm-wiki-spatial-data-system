---
title: OECD International Trade by Commodity Statistics (ITCS)
type: dataset
created: 2026-04-21
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
tags: [dataset, trade, OECD, SITC, HS, spatio-temporal, metadata]
---

OECD trade panel with commodity and partner-country detail, suitable for metadata models centered on annual bilateral trade series and classification blocks.

## Dataset Name

- OECD International Trade by Commodity Statistics (ITCS)

## Source / Warehouse

- Warehouse: [[oecd]]
- Provider: OECD
- Official serial page: [International Trade by Commodity Statistics](https://www.oecd.org/en/publications/serials/international-trade-by-commodity-statistics_g1g11c24.html)

## Why It Is Useful for Metadata Enrichment

- It is useful for metadata models that need annual bilateral trade by commodity and partner country.
- It provides a clear example of classification-dependent releases using SITC and HS blocks.
- It helps model coverage constraints where geography is broad but still less than full global coverage.

## Structured Metadata

### Variables

- Import value
- Export value
- Commodity code
- Partner country or country grouping
- Reporting country
- Time
- Quantity in online or companion versions where available

### Classifications

- SITC Revision 3 in the publication series
- HS-based versions in richer online variants mentioned by OECD

### Spatial Units

- Reporting country
- Partner country
- OECD country groupings

### Time Dimension

- Annual series
- Six-year windows in the periodical publication format
- Longer multi-decade blocks in broader online dissemination

### Frequency

- Annual

## Data Type

- Spatio-temporal trade panel

## Structure

- Panel

## N (observations)

- Large; depends on commodity and partner detail

## T (time periods)

- Medium-to-large annual series depending on release format

## N/T Profile

- N large, T medium-to-large

## Spatial Resolution

- Bilateral country and country-group trade links

## Temporal Resolution

- Annual

## Spatial Extent

- OECD countries plus selected non-OECD partners or groupings

## Time Range

- Multi-decade, with release format determining exact window

## Reproducibility

- Good reproducibility through documented OECD publication series and stable classification framing.

## Access Conditions

- Public access through OECD publication pages
- Online and publication-based dissemination are documented by OECD

## Limitations

- Coverage is not as globally exhaustive as UN Comtrade.
- Precise live-table access routes are less explicit than in open API-first warehouses.
- Classification blocks and publication windows must be recorded carefully.

## Related Pages

- [[oecd]]
- [[un_comtrade_merchandise_trade]]
- [[cepii_baci]]
- [[dataset_catalog_schema_v2]]
