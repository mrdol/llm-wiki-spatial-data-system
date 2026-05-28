---
title: Metadata enrichie - zenodo_3998463_ipcc_atlas_regions
type: analysis
created: 2026-05-13
updated: 2026-05-13
sources:
  - data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json
  - wiki/datasets/zenodo/zenodo_3998463_ipcc_atlas_regions.md
  - wiki/papers/iturbide_2020_ipcc_regions.md
  - wiki/metadata/catalog_registry_schema_v3.md
  - wiki/metadata/feature_selection_block_template.md
tags: [metadata-enriched, dataset, draft, spatial, spatiotemporal, climate, zenodo, paper-linked]
---

Profil de metadonnees enrichies construit a partir des fiches wiki et du manifest disponible. Cette fiche n'est pas une validation finale du dataset : aucune inspection des fichiers bruts n'a encore ete faite.

## Dataset Identity

- Dataset ID: `zenodo_3998463_ipcc_atlas_regions`
- Dataset name: SantanderMetGroup/ATLAS: Final version of IPCC WGI reference regions v4
- Dataset status: draft_from_existing_fiches
- Dataset curation status: reference_only_not_validated_for_project_modeling
- Source family: literature-linked research repository
- Source: Zenodo / GitHub ATLAS
- Source URL: https://zenodo.org/record/3998463
- Repository URL: https://github.com/SantanderMetGroup/ATLAS
- Dataset DOI: not isolated as a pure dataset DOI
- Dataset/archive DOI: `10.5281/zenodo.3998463`
- Linked paper DOI: `10.5194/essd-12-2959-2020`
- Linked paper fiche: [[iturbide_2020_ipcc_regions]]
- Linked dataset fiche: [[zenodo_3998463_ipcc_atlas_regions]]
- Local data path: none
- Validation date: not_validated
- Validation decision source: existing dataset fiche and paper fiche only

## Access And Provenance

- Repository: Zenodo archive and ATLAS GitHub repository
- License: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/
- License open: yes
- License caveat: CORDEX aggregates may have source-specific non-commercial exceptions; inspect source terms before redistribution.
- Download status: metadata_scraped_files_not_downloaded
- File inventory source: manifest and dataset fiche
- File inventory summary: GeoJSON, shapefile ZIP, CSV coordinates, RDA, NetCDF, notebooks, scripts
- Manifest: `data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json`
- Raw source preserved: metadata only
- Processing history: paper-linked discovery via OpenAlex/DataCite/GitHub metadata; no raw data processing

## Description

The dataset provides updated IPCC WGI reference regions as polygons, coordinates, shapefiles, R/Python notebooks, and regional climate aggregates. The linked ESSD paper describes 46 land regions and 15 ocean regions and monthly temperature and precipitation aggregated over those regions from CMIP5, CMIP6, CORDEX and W5E5 sources.

Description source: dataset fiche, Iturbide et al. paper fiche, and dataset manifest.

## Data Structure

- Data type: spatio-temporal climate reference and aggregate dataset
- Structure: region-time-source-model panel candidate with spatial polygon metadata
- N observations: unknown before file inspection
- T periods: monthly, exact range source-dependent
- N/T profile: medium N with potentially long monthly T
- Spatial extent: global land and ocean IPCC WGI reference regions
- Spatial resolution: IPCC reference region
- Temporal range: source-dependent; not inspected locally
- Temporal resolution: monthly
- Geometry type: polygon
- CRS: unknown before file inspection
- Spatial units: 46 land regions and 15 ocean regions described by polygons
- Temporal units: monthly climate series
- Main file formats: GeoJSON, shapefile ZIP, CSV, RDA, NetCDF, notebooks, scripts

## Variable Inventory

The variable inventory is inferred from the paper and repository description. It is not yet confirmed by local file inspection.

| variable | role | typology | unit | missingness | source |
|---|---|---|---|---|---|
| regional_mean_temperature | candidate target or climate response | continuous, temporal, spatial aggregate | temperature unit pending inspection | unknown | paper and manifest |
| regional_mean_precipitation | candidate target or climate response | continuous, temporal, spatial aggregate | precipitation unit pending inspection | unknown | paper and manifest |
| climate_change_signal | candidate derived response | continuous, temporal, spatial aggregate | source-dependent | unknown | paper fiche |
| region_id | identifier | categorical, spatial identifier | not applicable | unknown | repository description |
| region_polygon | geometry | polygon geometry | geographic coordinates pending inspection | unknown | repository description |
| source_dataset | predictor / source descriptor | categorical | not applicable | unknown | dataset fiche |
| model | predictor / source descriptor | categorical | not applicable | unknown | dataset fiche |
| experiment | predictor / source descriptor | categorical | not applicable | unknown | dataset fiche |
| scenario | predictor / source descriptor | categorical | not applicable | unknown | dataset fiche |
| month | temporal feature | temporal, ordinal | month | unknown | dataset fiche |
| year | temporal feature | temporal, numeric | year | unknown | dataset fiche |
| ensemble_member | source descriptor | categorical | not applicable | unknown | dataset fiche |
| land_sea_mask | spatial feature | categorical, spatial | not applicable | unknown | dataset fiche |

## Variable Typology

```yaml
content_metadata:
  variable_typology:
    y_candidates:
      - name: regional_mean_temperature
        role: candidate_y
        value_type: continuous
        measurement_scale: interval
        bounds: source_dependent
        zero_inflated: false
        missingness_notes: unknown_before_file_inspection
      - name: regional_mean_precipitation
        role: candidate_y
        value_type: continuous
        measurement_scale: ratio
        bounds: non_negative_expected
        zero_inflated: possible
        missingness_notes: unknown_before_file_inspection
    x_variables:
      - name: region_id
        role: identifier
        value_type: categorical
        is_spatial: true
        is_temporal: false
      - name: region_polygon
        role: geometry
        value_type: geometry
        is_spatial: true
        is_temporal: false
      - name: model
        role: source_descriptor
        value_type: categorical
        is_spatial: false
        is_temporal: false
      - name: experiment
        role: source_descriptor
        value_type: categorical
        is_spatial: false
        is_temporal: false
      - name: scenario
        role: source_descriptor
        value_type: categorical
        is_spatial: false
        is_temporal: true
      - name: month
        role: temporal_feature
        value_type: ordinal
        is_spatial: false
        is_temporal: true
      - name: year
        role: temporal_feature
        value_type: numeric
        is_spatial: false
        is_temporal: true
```

## Feature Selection

```yaml
content_metadata:
  feature_selection:
    x_total_reported: unknown
    x_candidates:
      - region_id
      - region_polygon
      - source_dataset
      - model
      - experiment
      - scenario
      - month
      - year
      - ensemble_member
      - land_sea_mask
    x_candidate_count: 10
    x_selected: []
    x_selected_count: 0
    selection_source: metadata
    selection_method: not_yet_selected
    selection_reason: "The dataset has documented candidate descriptors, but no project estimation has selected X variables."
    target_y:
      - regional_mean_temperature
      - regional_mean_precipitation
    estimation_context: none_yet
    confidence: medium
    status: pending
```

## Modeling Readiness

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "No regression equation documented for this dataset in the current fiche; the paper documents spatial aggregation of climate model outputs over reference regions."
  equation_family: aggregation_workflow
  y_variable:
    - regional_mean_temperature
    - regional_mean_precipitation
  x_variables:
    - region_id
    - model
    - experiment
    - scenario
    - month
    - year
  model_family: regional_climate_projection_analysis
  estimator_name: not_an_allowed_project_estimator
  source_type: paper_and_repository_metadata
  source_ref:
    - wiki/papers/iturbide_2020_ipcc_regions.md
    - data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json
  confidence: medium
```

- Modeling task hint: regional climate aggregation and scenario comparison
- Target Y: regional mean temperature or regional mean precipitation if a future modeling task is defined
- Candidate X: region, source dataset, climate model, experiment, scenario, month, year, ensemble member
- Selected X: none
- Excluded variables: unknown before file inspection
- Existing model or equation: spatial aggregation workflow; no project-compatible estimator equation documented
- Estimator candidates: none validated
- Leakage risks: high if climate-model scenario, year, or ensemble information is used without a proper time/source split
- Validation strategy: not defined; would require source-aware and time-aware splitting if prediction is attempted

## Methodological Selection

```yaml
methodological_selection:
  estimator_assessment_status: assessed_from_fiches_only
  at_least_one_allowed_estimator_plausible: false
  estimator_policy_ref: wiki/metadata/restricted_estimator_policy_v1.md
  candidate_estimators:
    - estimator: MGWR
      plausible: false
      justification: "The spatial units are broad IPCC regions, not fine local observations. The linked paper does not define a GWR task."
    - estimator: MGWRSAR
      plausible: false
      justification: "The dataset currently has no project Y/X formulation and no spatial-lag regression target."
    - estimator: STVC
      plausible: false
      justification: "A spatio-temporal panel can be derived, but the current source only documents aggregation and scenario display."
    - estimator: INLA
      plausible: false
      justification: "Potentially possible for a future climate response model, but no project model is currently specified."
    - estimator: Random Forest
      plausible: false
      justification: "Could be used for prediction only after a clear target and leakage-safe validation protocol are defined."
```

## Traceability

```yaml
traceability:
  linked_papers:
    - paper_id: iturbide_2020_ipcc_regions
      paper_doi: 10.5194/essd-12-2959-2020
      wiki_page: wiki/papers/iturbide_2020_ipcc_regions.md
  linked_datasets:
    - dataset_id: zenodo_3998463_ipcc_atlas_regions
      archive_doi: 10.5281/zenodo.3998463
      wiki_page: wiki/datasets/zenodo/zenodo_3998463_ipcc_atlas_regions.md
  linked_warehouses:
    - zenodo
    - github
    - earth_system_science_data
  doi_traceability_status: paper_doi_and_archive_doi_present
```

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_data_journal_to_research_repository
  provenance_score: 5
  provenance_evidence: "The dataset route is documented by an ESSD data paper, a Zenodo archive DOI, and a GitHub repository."
  rigour_score: 4
  rigour_evidence: "The paper documents region definitions, aggregation workflow, notebooks, and worked examples."
  evidence_score: 4
  evidence_evidence: "This enriched metadata profile uses existing fiches and manifests only; raw files were not inspected."
  coherence_score: 4
  coherence_evidence: "Dataset fiche, paper fiche, and manifest consistently describe the ATLAS reference-region release."
  claim_discipline_score: 3
  claim_discipline_evidence: "The profile explicitly limits modeling claims because the dataset is reference-only for the current project."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation counts were not checked for this metadata profile."
  delta1_risk: medium
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Gaps Before Validation

- Download and inspect the Zenodo/GitHub files.
- Confirm CRS, geometry validity, file sizes, and variable names.
- Confirm exact temporal ranges for CMIP5, CMIP6, CORDEX, and W5E5 aggregates.
- Confirm units for temperature and precipitation variables.
- Decide whether this dataset is only a reference geometry source or can support a modeling dataset.
- If modeling is attempted, define a leakage-safe validation protocol before selecting estimators.

## Related Pages

- [[zenodo_3998463_ipcc_atlas_regions]]
- [[iturbide_2020_ipcc_regions]]
- [[catalog_registry_schema_v3]]
- [[feature_selection_block_template]]
- [[quality_pedigree_schema_v1]]
- [[restricted_estimator_policy_v1]]
- [[spatiotemporal_data]]
