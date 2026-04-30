---
title: Eurostat Labour Force Survey
type: dataset
created: 2026-04-21
updated: 2026-04-21
sources: []
tags: [dataset, labour-market, unemployment, Europe, France, Eurostat, education, regional]
---

Harmonized European labour-force dataset relevant for unemployment, education-related labour outcomes, and regional comparison including France.

## Candidate Relevance

- Relevant for `unemployment` because it is the Eurostat reference framework for employment and unemployment indicators.
- Relevant for `education` because Eurostat documents education level and educational attainment outputs derived from EU-LFS.
- Relevant for `regional or territorial analysis in France` because Eurostat publishes regional unemployment tables and includes France in the regional LFS-based outputs.

## Source / Warehouse

- Warehouse: [[eurostat]]
- Provider: Eurostat
- Warehouse type: supranational statistical warehouse
- Main thematic page: [Employment and unemployment (LFS)](https://ec.europa.eu/eurostat/web/lfs)
- Information page: [Information on data](https://ec.europa.eu/eurostat/web/lfs/information-data)
- API guide used for raw extraction: [Statistics API getting started](https://ec.europa.eu/eurostat/web/user-guides/data-browser/api-data-access/api-getting-started/api)

## Why It Is Relevant

- It is the strongest candidate in the current wiki for harmonized France-versus-Europe comparison.
- Eurostat states that EU-LFS covers education-related characteristics and makes educational attainment indicators available from EU-LFS-based outputs.
- Eurostat publishes regional unemployment results; a Eurostat news article on EU regional unemployment cites the regional source dataset `lfst_r_lfu3rt`.
- The official API supports direct raw export without transformation.

## Variables and Coverage

- Core variables already documented in the wiki:
  - `employment`
  - `unemployment`
  - `education_level`
  - `age`
- Regional signal confirmed by Eurostat:
  - NUTS 2 regional unemployment dataset `lfst_r_lfu3rt`
- Spatial resolution:
  - country level
  - regional outputs in some datasets
- Temporal resolution:
  - annual in the current wiki record
- Time range currently documented in the wiki:
  - `2000-2023`

## Access Conditions

- Public aggregate outputs are freely available on the Eurostat website and via API
- Public and scientific microdata access routes are distinct
- Eurostat public microdata are available only for a limited number of countries and years, with explicit caveats against statistical inference from public-use files
- API access is free and supports JSON-stat, SDMX-CSV, and TSV

## Raw Files Downloaded

- Downloaded raw file:
  - `data/downloads/eurostat_lfst_r_lfu3rt.json`
- Official source URL:
  - `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/lfst_r_lfu3rt?lang=EN`
- What this file contains:
  - raw JSON-stat export for the regional unemployment-rate dataset cited by Eurostat for EU regional unemployment analysis
- Manifest:
  - `data/manifests/eurostat_labour_force_survey.json`

## Limitations

- The current wiki still does not pin down one single LFS table code for all unemployment and education use cases.
- Public-use microdata are not appropriate for valid statistical inference according to Eurostat; scientific use files are required for publication-grade microdata analysis.
- The downloaded `lfst_r_lfu3rt` raw export is a regional unemployment table, not the full EU-LFS microdata corpus.
- France-only administrative detail is weaker than in INSEE products.

## Related Pages

- [[eurostat]]
- [[insee_emploi_chomage_population_active]]
- [[france_unemployment_datasets_comparison]]
- [[dataset_catalog_schema_v2]]
- [[overview]]
