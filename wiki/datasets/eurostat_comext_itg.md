---
title: Eurostat Comext International Trade in Goods (ITG)
type: dataset
created: 2026-04-21
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
tags: [dataset, trade, Eurostat, Comext, CN, SITC, spatio-temporal, metadata]
---

European trade-in-goods warehouse with explicit product nomenclatures, bilateral geography, and mixed monthly-annual time structure.

## Dataset Name

- Eurostat Comext International Trade in Goods (ITG)

## Source / Warehouse

- Warehouse: [[eurostat]]
- Provider: Eurostat
- Official overview page: [International trade in goods](https://ec.europa.eu/eurostat/web/international-trade-in-goods)
- Official metadata page: [International trade in goods - aggregated and detailed data](https://ec.europa.eu/eurostat/cache/metadata/en/ext_go_agg_esms.htm)

## Why It Is Useful for Metadata Enrichment

- It is a strong catalog example for datasets whose metadata vary by product nomenclature and periodicity.
- It clearly separates reporting country, partner country, reference period, trade flow, and product classification.
- It is useful for designing metadata fields for multi-classification datasets, mixed temporal granularity, and bilateral geography.

## Structured Metadata

### Variables

- Reporting country
- Partner country
- Reference period
- Trade flow (`imports`, `exports`)
- Product classification
- Value
- Quantity

### Classifications

- Combined Nomenclature (CN)
- Standard International Trade Classification (SITC)
- Broad Economic Categories (BEC)
- Classification of Products by Activity (CPA)

### Spatial Units

- Reporting country
- Partner country
- Geo-economic areas such as EU and euro area

### Time Dimension

- Month and/or year depending on the dataset

### Frequency

- Monthly, daily, or yearly depending on the detailed dataset
- Long-term and short-term aggregated indicators are updated monthly

## Data Type

- Spatio-temporal trade panel

## Structure

- Panel

## N (observations)

- Very large; depends on geography, nomenclature depth, and period

## T (time periods)

- Monthly and annual series with broad historical range

## N/T Profile

- N very large, T medium

## Spatial Resolution

- Bilateral country-to-country or country-to-area trade flows

## Temporal Resolution

- Monthly and annual, dataset dependent

## Spatial Extent

- EU Member States, EU aggregates, EFTA, enlargement countries, and external partners

## Time Range

- Historical series from the modern harmonized era to current releases

## Reproducibility

- Strong reproducibility through Eurostat metadata documentation, APIs, and bulk download workflows.

## Access Conditions

- Public portal access
- Bulk download and web services are explicitly advertised on the Eurostat trade page
- Dataset-specific access routes depend on the selected ITG table

## Limitations

- EU-centered coverage differs from a fully global trade source.
- Product nomenclature and periodicity differ by dataset and must be captured explicitly.
- CN to SITC or BEC mappings may introduce comparability loss in downstream aggregation.

## Related Pages

- [[eurostat]]
- [[un_comtrade_merchandise_trade]]
- [[oecd_itcs]]
- [[cepii_baci]]
- [[dataset_catalog_schema_v2]]
