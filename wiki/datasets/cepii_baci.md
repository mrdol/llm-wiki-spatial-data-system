---
title: CEPII BACI Bilateral Trade Database
type: dataset
created: 2026-04-21
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
tags: [dataset, trade, CEPII, BACI, HS6, spatio-temporal, metadata]
---

Harmonized bilateral product-level trade database with explicit annual files, country metadata, and product metadata.

## Dataset Name

- CEPII BACI

## Source / Warehouse

- Warehouse: [[cepii]]
- Provider: CEPII
- Official BACI page: [The CEPII-BACI dataset](https://www.cepii.fr/DATA_DOWNLOAD/baci/doc/baci_webpage.html)

## Why It Is Useful for Metadata Enrichment

- It is an excellent catalog case for derived datasets that preserve upstream structure while adding harmonization logic.
- It ships both trade-flow files and explicit country/product metadata files.
- It is useful for modeling release versioning, classification revisions, and upstream lineage from UN Comtrade.

## Structured Metadata

### Variables

- `t` year
- `k` product category (HS 6-digit code)
- `i` exporter (3-digit country code)
- `j` importer (3-digit country code)
- `v` trade value in thousands current USD
- `q` quantity in metric tons

### Classifications

- HS 1992
- HS 1996
- HS 2002
- HS 2007
- HS 2012
- HS 2017
- HS 2022

### Spatial Units

- Exporter country
- Importer country
- Country metadata mapping files included in each archive

### Time Dimension

- Annual
- One file per year within each HS-revision archive

### Frequency

- Annual releases, updated yearly in January according to CEPII FAQ

## Data Type

- Spatio-temporal bilateral product panel

## Structure

- Panel

## N (observations)

- Very large country-pair-product-year matrix

## T (time periods)

- Multi-decade annual coverage

## N/T Profile

- N very large, T medium

## Spatial Resolution

- Bilateral country-pair flows at HS6 product level

## Temporal Resolution

- Annual

## Spatial Extent

- Roughly 200 countries

## Time Range

- 1995-2024 in HS92 and revision-dependent windows for later HS versions

## Reproducibility

- Strong reproducibility through fixed-version archives, explicit naming conventions, and bundled metadata files.

## Access Conditions

- Public direct download through CEPII
- Archives are available by HS revision as zip files

## Limitations

- Country codes are inherited from Comtrade and may differ from ISO codes without the mapping file.
- Last-year coverage may be revised in subsequent releases.
- The harmonization process introduces differences relative to raw Comtrade.

## Related Pages

- [[cepii]]
- [[un_comtrade]]
- [[oecd_itcs]]
- [[dataset_catalog_schema_v2]]
