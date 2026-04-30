---
title: Base permanente des equipements
type: dataset
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [dataset, INSEE, territorial, spatial, spatio-temporal, equipment, metadata]
---

Annual INSEE territorial database of public-facing services and facilities with fine geography and explicit spatial metadata.

## Dataset Name

- Base permanente des equipements (BPE)

## Source / Warehouse

- Warehouse: [[insee]]
- Provider: INSEE
- Warehouse type: national statistical warehouse
- Official metadata source: [Base permanente des equipements](https://www.insee.fr/fr/metadonnees/source/serie/s1161)
- Official access page: [Base de donnees en ligne - Base permanente des equipements 2020](https://www.insee.fr/fr/metadonnees/source/operation/s2027/bases-donnees-ligne)

## Why It Is Useful for Metadata Enrichment

- It combines strong territorial detail with recurring annual releases.
- It documents multiple spatial units in the same source: commune, Iris, and coordinates `(x, y)`.
- It carries explicit internal thematic classifications through equipment types, domains, and equipment ranges.
- It is well suited to testing metadata fields for geometry support, multi-scale geography, thematic classification, and annual update cadence.

## Structured Metadata

### Variables

- Equipment presence or counts by geographic unit
- Equipment type
- Domain of equipment
- Equipment-range grouping (`gammes`)
- Fine geographic identifiers
- Coordinates `(x, y)` for localized equipment points

### Classifications

- 229 equipment and service types in the 2024 edition
- Seven major domains:
  - services for individuals
  - commerce
  - education
  - health and social action
  - transport and mobility
  - sports, leisure, culture
  - tourism
- Groupings into `gammes` for synthetic territorial indicators

### Spatial Units

- France metropolitan territory and the five overseas departments
- Commune
- Iris
- Point coordinates `(x, y)`

### Time Dimension

- Annual snapshot as of 1 January each year
- First dissemination covers 2007
- Additional quinquennial evolution products are published for selected equipment subsets

### Frequency

- Annual

## Data Type

- Spatio-temporal territorial inventory

## Structure

- Repeated annual cross-sections with fine geographic support

## N (observations)

- Large; depends on whether the extract is at point level, commune level, or Iris level

## T (time periods)

- Annual releases from 2007 onward

## N/T Profile

- N large, T medium

## Spatial Resolution

- Commune, Iris, and point coordinates

## Temporal Resolution

- Annual

## Spatial Extent

- France metropolitan territory plus the five overseas departments

## Time Range

- 2007-present in annual dissemination, with quinquennial evolution products for selected equipment subsets

## Reproducibility

- Strong reproducibility through annual downloadable products, explicit millesime documentation, and stable territorial definitions per release.

## Access Conditions

- Public access on the INSEE website
- Downloadable files are explicitly available in `csv` and `dbf`
- Access method is portal-based download

## Limitations

- Equipment evolution products are only available for a restricted subset of equipment types.
- Geographic support and available variables differ between point-level and aggregated releases.
- Cross-year comparability still requires attention to territorial changes and evolving equipment subsets.

## Related Pages

- [[insee]]
- [[dataset_catalog_schema_v2]]
- [[overview]]
