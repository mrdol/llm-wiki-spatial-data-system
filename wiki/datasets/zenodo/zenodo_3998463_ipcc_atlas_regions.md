---
title: Zenodo 3998463 - IPCC ATLAS Reference Regions and Aggregated Climate Data
type: dataset
created: 2026-05-11
updated: 2026-05-11
sources:
  - data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json
  - data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl
  - data/manifests/papers/paper_linked_dataset_links_2026_05_11.json
tags:
  - dataset
  - zenodo
  - github
  - climate
  - spatial
  - spatiotemporal
  - paper-linked
---

Dataset candidat issu d'une publication scientifique ESSD. La publication documente des regions de reference IPCC et des jeux de donnees climatiques mensuels agreges spatialement, avec depot GitHub et archive Zenodo.

## Identity

- Dataset ID: `zenodo_3998463_ipcc_atlas_regions`
- Dataset name: SantanderMetGroup/ATLAS: Final version of IPCC WGI reference regions v4
- Source family: literature-linked research repository
- Source: Zenodo / GitHub ATLAS
- Source URL: https://zenodo.org/record/3998463
- Repository URL: https://github.com/SantanderMetGroup/ATLAS
- Dataset DOI: not isolated as a pure dataset DOI; archive DOI is `10.5281/zenodo.3998463`
- Title: SantanderMetGroup/ATLAS: Final version of IPCC WGI reference regions v4
- Year: 2020

## Source Access

- Local download directory: none
- Manifest: `data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json`
- Download status: metadata_scraped_files_not_downloaded
- Main access route: scientific paper -> explicit GitHub repository and Zenodo archive
- Paper route: [[iturbide_2020_ipcc_regions]]

## Description

- Excerpt: Updated IPCC WGI reference regions with polygons, coordinates, shapefiles, notebooks, and monthly temperature and precipitation aggregates over reference regions for climate-model analysis.
- Full description source: `data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json`
- Source description URLs:
  - https://doi.org/10.5194/essd-12-2959-2020
  - https://github.com/SantanderMetGroup/ATLAS
  - https://zenodo.org/record/3998463

## License Metadata

- License present: yes
- License name: `Creative Commons Attribution 4.0 International`
- License URL: https://creativecommons.org/licenses/by/4.0/
- License open: yes
- License evidence: ATLAS `LICENSE.md` states that code, notebooks and datasets are CC BY 4.0 unless otherwise specified.
- License condition: some CORDEX model aggregates have non-commercial exceptions; inspect source-specific terms before redistribution.

## Content Metadata

- Main file formats: GeoJSON, shapefile ZIP, CSV, RDA, NetCDF, notebooks, scripts
- Repository areas:
  - `reference-regions/`: IPCC WGI regions as GeoJSON, shapefile, CSV coordinates, and R data.
  - `datasets-aggregated-regionally/`: monthly spatial aggregates over reference regions.
  - `data-sources/`: CMIP5, CMIP6, CORDEX, W5E5 source inventories and DOI table.
  - `reference-grids/`: masks and reference grids for aggregation.

### Variables

- Candidate Y variables: regional mean precipitation, regional mean near-surface temperature, climate-change signal by region
- Candidate Y typology: continuous, temporal, spatial aggregate
- Candidate X variables: region identifier, region polygon, model, experiment, scenario, source dataset, month, year, land/sea mask, ensemble member
- Candidate X typology: spatial, temporal, categorical, identifier, continuous
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates:
    - region_id
    - source_dataset
    - model
    - experiment
    - scenario
    - month
    - year
    - land_sea_mask
    - ensemble_member
  x_selected: []
  selection_source: paper_and_repository_documentation
  selection_method: not_selected_yet
  target_y:
    - monthly_temperature
    - monthly_precipitation
  estimation_context: regional_climate_model_analysis
```

## Spatiotemporal

- Data type: spatio-temporal climate panel candidate
- Spatial signal: 46 land and 15 ocean IPCC WGI reference regions described by polygons
- Temporal signal: monthly climate series aggregated from CMIP5, CMIP6, CORDEX and W5E5 sources
- Structure: region-time-source-model panel with polygon metadata and reproducible aggregation scripts
- N observations: unknown before file inspection
- T periods: monthly, exact range depends on source model or observation product
- N/T profile: medium N by potentially long monthly T
- Spatial resolution: IPCC reference region
- Temporal resolution: monthly
- Spatial extent: global land and ocean IPCC reference regions
- Time range: source-dependent; not inspected locally

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: 10.5194/essd-12-2959-2020
  paper_title: "An update of IPCC climate reference regions for subcontinental analysis of climate model data: definition and aggregated datasets"
  venue: Earth System Science Data
  modeling_task_hint: regional_climate_projection_analysis
  existing_model_or_equation: climate-model ensemble summaries and regional aggregation workflow
  evidence_source: ESSD paper abstract, GitHub README files, Zenodo/DataCite metadata
```

## Reproducibility

- Code available: yes
- Repository: https://github.com/SantanderMetGroup/ATLAS
- Notebooks available: yes
- Local data path: none
- Reproducibility status: strong documentation; local file inspection and download still pending

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: scientific_publication_to_research_repository
  provenance_score: 5
  provenance_evidence: "The dataset route starts from a peer-reviewed ESSD data paper and points to explicit GitHub and Zenodo records."
  rigour_score: 4
  rigour_evidence: "The paper documents region definition, homogeneity analysis, aggregation workflow, and worked examples; local file inspection remains pending."
  evidence_score: 5
  evidence_evidence: "Paper DOI, source repository, Zenodo archive DOI, license metadata, and scraped manifest are available."
  coherence_score: 4
  coherence_evidence: "The paper abstract, GitHub repository structure, and Zenodo/DataCite metadata all describe the same ATLAS reference-region release."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche keeps the record as candidate and separates pure dataset DOI from mixed software/archive DOI."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation counts were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[zenodo]]
- [[earth_system_science_data]]
- [[iturbide_2020_ipcc_regions]]
- [[paper_linked_dataset_scraping_2026_05_11]]
- spatiotemporal data
- spatial panel
