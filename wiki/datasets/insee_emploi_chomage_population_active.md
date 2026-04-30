---
title: INSEE - Emploi, chomage, population active
type: dataset
created: 2026-04-21
updated: 2026-04-21
sources: []
tags: [dataset, labour-market, unemployment, France, INSEE, education, territorial]
---

French official labour-market dataset family relevant for unemployment measurement, education-related breakdowns, and territorial analysis in France.

## Candidate Relevance

- Relevant for `unemployment` because it is the France-focused reference source for employment, unemployment, and active-population indicators.
- Relevant for `education` because INSEE publishes unemployment tables broken down by diploma level, including long-series tables.
- Relevant for `regional or territorial analysis in France` because INSEE documents localized unemployment rates by region, department, and employment zone.

## Source / Warehouse

- Warehouse: [[insee]]
- Provider: INSEE
- Warehouse type: national statistical warehouse
- Main discovery page: [INSEE home](https://www.insee.fr/)
- Territorial source page identified during this query: [Taux de chômage localisés](https://www.insee.fr/fr/metadonnees/source/serie/s2107/bases-donnees-ligne)
- Long-series detailed page identified during this query: [Chômage et halo autour du chômage - Séries longues](https://www.insee.fr/fr/statistiques/7625228)

## Why It Is Relevant

- It is the strongest candidate in the current wiki for France-only labour-market work.
- It supports unemployment analysis with official national definitions and publication workflows.
- It exposes diploma-based unemployment tables directly as downloadable CSV files.
- It documents territorial unemployment dissemination and mentions a web service on `api.insee.fr` for localized unemployment rates.

## Variables and Coverage

- Core variables already documented in the wiki:
  - `emploi`
  - `chomage`
  - `population_active`
  - `taux_chomage`
- Additional education-oriented breakdown confirmed on the INSEE long-series page:
  - unemployment and unemployment rate by highest diploma obtained
- Spatial resolution:
  - France national level
  - regions and departments for some series
  - employment zones for localized unemployment products
- Temporal resolution:
  - variable by series

## Access Conditions

- Public web access for published tables and series
- Direct file downloads are available in CSV and XLSX on several INSEE publication pages
- The localized unemployment source page explicitly states that data are also retrievable via a web service on `api.insee.fr` following SDMX
- Exact API export URL for the localized territorial series was not pinned down in the current query

## Raw Files Downloaded

- Downloaded raw file:
  - `data/downloads/insee_t304_chomage_diplome.csv`
- Official source URL:
  - `https://www.insee.fr/fr/statistiques/fichier/7625228/T304.csv`
- What this file contains:
  - unemployment and unemployment rate by highest diploma obtained, sex, and grouped age, in annual averages
- Manifest:
  - `data/manifests/insee_emploi_chomage_population_active.json`

## Limitations

- The current wiki record still groups several INSEE labour-market products under one catalog entry rather than one fixed table.
- Territorial access is documented, but the exact SDMX/API extraction route for the localized unemployment series was not pinned down in this turn.
- Cross-source comparison with Eurostat still requires confirming the BIT/ILO unemployment definition and the exact series/table used.

## Related Pages

- [[insee]]
- [[eurostat_labour_force_survey]]
- [[france_unemployment_datasets_comparison]]
- [[dataset_catalog_schema_v2]]
- [[overview]]
