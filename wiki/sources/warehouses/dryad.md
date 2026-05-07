---
title: Dryad
type: source
source_family: warehouse
created: 2026-05-06
updated: 2026-05-07
sources: [data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl]
tags: [source, warehouse, dryad, research-repository, doi]
---

Research data repository used to discover DOI-backed datasets, licenses, abstracts, methods, and file-level metadata.

## Scope

- Dataset records with Dryad DOI
- CC0 license metadata
- Dataset abstracts and methods
- File-level metadata exposed through Dryad versions and files API

## Local Pipeline

- Scraper: `Code_scrapping/pipeline_portals/python/scrape_dryad.py`
- Common download helper: `Code_scrapping/pipeline_portals/python/portal_common.py`
- Candidate manifests: `data/manifests/datasets/`
- Download target: `data/candidates/datasets/dryad/`

## Current Records

- `dryad_v41ns1rvb`: forest-loss data for the Cordillera Administrative Region, Philippines.
- `dryad_bk3j9kdfk`: benthic invertebrate trophic-network monitoring data for Swedish coastal basins.
- `dryad_8w9ghx3jj`: citizen-science and systematic-protocol data for habitat suitability modelling in Sweden.

## Current Download Caveat

On 2026-05-06, Dryad metadata discovery worked and file-level links were recovered, but automated file downloads were blocked by Dryad/AWS WAF responses (`401`, `403`, and temporary `429`). Browser-mediated download may require an interactive human check.

## Related Pages

- [[quality_pedigree_schema_v1]]
- spatiotemporal data
