---
title: Paper-linked Dataset Scraping 2026-05-11
type: analysis
created: 2026-05-11
updated: 2026-05-11
sources:
  - data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl
  - data/manifests/papers/paper_linked_dataset_links_2026_05_11.json
  - data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json
tags:
  - analysis
  - discovery
  - scraping
  - paper-linked-dataset
---

Scraping run using the route "scientific publication in a journal -> dataset documented or used by the paper".

## Query

- Source API: OpenAlex
- Query: `climate dataset model`
- Selection objective: find a spatial or spatio-temporal dataset with explicit publication evidence, repository links, DOI traceability, and enough metadata for a dataset fiche.
- Candidate manifest: `data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl`
- Link extraction manifest: `data/manifests/papers/paper_linked_dataset_links_2026_05_11.json`

## Selected Dataset

- Dataset: [[zenodo_3998463_ipcc_atlas_regions]]
- Paper: [[iturbide_2020_ipcc_regions]]
- Source: [[earth_system_science_data]]
- Archive DOI: `10.5281/zenodo.3998463`
- Paper DOI: `10.5194/essd-12-2959-2020`

## Why This Candidate Was Kept

- The paper is a peer-reviewed data-paper style record in Earth System Science Data.
- The abstract explicitly states that regions, datasets, and R/Python code are freely available through GitHub and Zenodo.
- The dataset is spatial and spatio-temporal: IPCC reference-region polygons plus monthly temperature and precipitation aggregates.
- The repository includes metadata-rich areas: source inventories, region files, grids, notebooks, and scripts.
- License evidence is documented in the repository.

## Remaining Checks

- Download and inspect the exact aggregated data files before marking the dataset as modeling-ready.
- Verify variable names, dimensions, missing values, and exact time ranges.
- Check citation counts only if they become decision-relevant.
- Inspect source-specific license exceptions for CORDEX before redistributing any downloaded files.

## Related Pages

- [[zenodo_3998463_ipcc_atlas_regions]]
- [[iturbide_2020_ipcc_regions]]
- [[earth_system_science_data]]
