---
title: Zenodo
type: source
source_family: warehouse
created: 2026-05-06
updated: 2026-05-06
sources: []
tags: [source, warehouse, zenodo, research-repository, doi]
---

Research repository and data warehouse used to discover DOI-backed datasets, files, licenses, and paper links.

## Scope

- Research datasets with DOI records
- Files exposed through the Zenodo InvenioRDM API
- Licenses and related publication DOI metadata when present
- Spatial and spatio-temporal candidates selected by `Code_scrapping/pipeline_portals/python/scrape_zenodo.py`

## Local Pipeline

- Scraper: `Code_scrapping/pipeline_portals/python/scrape_zenodo.py`
- Common download helper: `Code_scrapping/pipeline_portals/python/portal_common.py`
- Candidate manifests: `data/manifests/datasets/`
- Download target: `data/candidates/datasets/zenodo/`

## Quality Notes

Zenodo usually provides strong provenance because DOI, license, creator, files, and landing URL are exposed through an official API. Dataset-level quality still depends on inspecting variables, documentation, files, and any linked paper.

## Related Pages

- [[quality_pedigree_schema_v1]]
- spatiotemporal data
