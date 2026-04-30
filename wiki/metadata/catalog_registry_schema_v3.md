---
title: Catalog and Registry Schema v3
type: metadata
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [metadata, schema, catalog, registry, papers, doi, license, discovery]
---

Schema redesign for the local registry so that discovery can operate across datasets, papers, source records, licenses, DOI traceability, and restricted estimator policy.

## Objective

The v3 registry extends the previous dataset-centered catalog so that the project can:

- carry dataset records, paper records, and source records in one machine-readable file
- expose license metadata explicitly and distinguish exact documented licenses from generic access wording
- preserve dataset DOI and publication DOI separately
- support links between datasets and papers without inventing missing records
- enforce a strict project-level estimator allowlist with per-dataset plausibility assessment
- prioritize discovery using spatial structure, metadata richness, license reusability, and paper or DOI traceability

## Top-Level Registry Layout

The root registry is now a single object with explicit record groups and policy blocks.

- `schema_version`
- `updated_at`
- `catalog_policy`
- `estimator_policy`
- `datasets[]`
- `papers[]`
- `warehouses[]`

## Catalog Policy

`catalog_policy` documents the architecture rather than any one record.

- `supported_record_types`
- `directory_conventions`
- `license_priority`
- `doi_traceability_rules`
- `paper_link_rules`
- `discovery_priorities`

### Required Directory Conventions

- `wiki/datasets/` for dataset pages
- `wiki/papers/` for paper pages and paper-directory conventions
- `wiki/sources/warehouses/` for warehouse and portal source pages
- `wiki/sources/software/` for software, package, API, and code-distributed data sources
- `wiki/sources/literature/` for scientific-paper and journal sources that lead to datasets
- `wiki/metadata/` for metadata schemas, rules, and conventions only
- `wiki/estimators/` for stable estimator reference fiches only
- `wiki/analyses/metadata/` for progressive metadata profiles constructed from raw metadata, source descriptions, and data inspection
- `wiki/analyses/discovery/` for dataset, paper, and source discovery outputs
- `wiki/analyses/modeling/estimations/` for fitted-model and estimator-comparison outputs
- `wiki/analyses/modeling/predictions/` for prediction outputs and forecast diagnostics
- `wiki/analyses/modeling/cross_validation/` for validation protocols, fold definitions, leakage checks, and validation results
- `raw/papers/` as the preferred raw-paper staging directory for future ingest
- `data/manifests/` for dataset access manifests
- `data/manifests/papers/` for paper access and traceability manifests

## Dataset Record

Each dataset record keeps the v2 core blocks and adds explicit traceability and license substructures.

- `record_type`
- `dataset_id`
- `identity.title`
- `identity.short_title`
- `identity.description`
- `identity.dataset_doi`
- `identity.publication_doi`
- `identity.language`
- `identity.status`
- `identity.wiki_page`
- `source_access.warehouses[]`
- `content_metadata.*`
- `content_metadata.variable_typology`
- `content_metadata.feature_selection`
- `spatiotemporal.*`
- `access_metadata.*`
- `access_metadata.license_metadata`
- `traceability.linked_papers`
- `traceability.linked_datasets`
- `traceability.linked_warehouses`
- `traceability.doi_traceability_status`
- `methodological_selection.*`
- `methodological_selection.estimator_assessment_status`
- `methodological_selection.at_least_one_allowed_estimator_plausible`
- `methodological_selection.candidate_estimators[]`
- `methodological_selection.estimator_policy_ref`
- `modeling_evidence.*`

### Variable Typology Block

Variable typology is required before automatic estimator eligibility can be trusted.

Store it under `content_metadata.variable_typology` and keep uncertainty explicit.

- `variable_typology.y_candidates[]`
- `y_candidates[].name`
- `y_candidates[].role`
- `y_candidates[].value_type`
- `y_candidates[].measurement_scale`
- `y_candidates[].bounds`
- `y_candidates[].zero_inflated`
- `y_candidates[].missingness_notes`
- `variable_typology.x_variables[]`
- `x_variables[].name`
- `x_variables[].role`
- `x_variables[].value_type`
- `x_variables[].is_spatial`
- `x_variables[].is_temporal`
- `x_variables[].is_lagged`
- `x_variables[].is_imputed`
- `variable_typology.modeling_task_hint`

Allowed `value_type` values:

- `continuous`
- `binary`
- `count`
- `rate`
- `proportion`
- `presence_absence`
- `categorical`
- `ordinal`
- `duration`
- `identifier`
- `geometry`
- `timestamp`
- `unknown`

Allowed `modeling_task_hint` values:

- `regression`
- `classification`
- `count_model`
- `survival`
- `panel_regression`
- `spatial_regression`
- `spatiotemporal_regression`
- `forecasting`
- `unknown`

This block should be progressively refined from raw metadata, dataset descriptions, direct data inspection, and paper evidence.

### Feature Selection Block

`content_metadata.feature_selection` records the difference between all explanatory variables documented or detected for a dataset and the subset actually used for estimation.

This is required when a source says, for example, that the data contain 30 possible `X` variables but the author or project estimation uses only 10.

- `feature_selection.x_total_reported`
- `feature_selection.x_candidates[]`
- `feature_selection.x_candidate_count`
- `feature_selection.x_selected[]`
- `feature_selection.x_selected_count`
- `feature_selection.selection_source`
- `feature_selection.selection_method`
- `feature_selection.selection_reason`
- `feature_selection.target_y`
- `feature_selection.estimation_context`
- `feature_selection.confidence`
- `feature_selection.status`

Allowed `selection_source` values:

- `paper`
- `metadata`
- `code`
- `software_documentation`
- `manual`
- `data_inspection`
- `unknown`

Allowed `selection_method` values:

- `author_selected`
- `model_selected`
- `domain_selected`
- `missingness_filter`
- `correlation_filter`
- `variance_filter`
- `collinearity_filter`
- `manual_project_choice`
- `not_yet_selected`
- `unknown`

Allowed `confidence` values:

- `low`
- `medium`
- `high`

Use `status: pending` when the dataset has not yet been inspected enough to distinguish `X_candidates` from `X_selected`.

### Modeling Evidence Block

`modeling_evidence` records whether a source already documents a model equation, objective, or statistical formulation for the dataset.

It must not assume a linear form such as `y = X beta`. Store the observed formulation as written or summarized from the source.

- `modeling_evidence.existing_model_found`
- `modeling_evidence.equation_text`
- `modeling_evidence.equation_family`
- `modeling_evidence.y_variable`
- `modeling_evidence.x_variables[]`
- `modeling_evidence.model_family`
- `modeling_evidence.estimator_name`
- `modeling_evidence.source_type`
- `modeling_evidence.source_ref`
- `modeling_evidence.confidence`

Allowed `equation_family` values:

- `linear`
- `generalized_linear`
- `spatial_lag`
- `spatial_error`
- `spatial_panel`
- `varying_coefficient`
- `spatiotemporal_varying_coefficient`
- `geographically_weighted`
- `tree_ensemble`
- `boosting_objective`
- `kernel_margin`
- `neural_sequence`
- `bayesian_latent_field`
- `index_formula`
- `simulation_model`
- `unknown`

Allowed `source_type` values:

- `paper_abstract`
- `full_paper`
- `code`
- `software_documentation`
- `dataset_metadata`
- `readme`
- `unknown`

Allowed `confidence` values:

- `low`
- `medium`
- `high`

### License Metadata Block

The previous single `license` string is replaced by a structured evidence block.

- `license_metadata.explicit_license_present`
- `license_metadata.exact_name`
- `license_metadata.evidence_type`
- `license_metadata.category`
- `license_metadata.is_open`
- `license_metadata.allows_reuse`
- `license_metadata.requires_attribution`
- `license_metadata.requires_share_alike`
- `license_metadata.commercial_use`
- `license_metadata.machine_readable`
- `license_metadata.notes`

The registry must preserve uncertainty explicitly. If the exact legal license is not pinned, use:

- `explicit_license_present: false`
- `exact_name: null`
- `evidence_type: generic_access_terms` or `unknown`
- `category: unknown`
- `is_open: null`
- `allows_reuse: null`
- `notes: exact license not yet pinned from official source`

If an exact documented license is present:

- `explicit_license_present: true`
- `exact_name: <exact documented license text>`
- `evidence_type: explicit_license_text`
- `category`, `is_open`, and `allows_reuse` may be classified from that exact documented license only

Generic wording such as `public access`, `dissemination terms`, or `open-data wording` must not be stored as an exact legal license name.

### DOI Traceability Block

The registry distinguishes:

- `identity.dataset_doi` for a DOI that identifies the dataset itself
- `identity.publication_doi` for a DOI that identifies a paper or publication associated with the dataset
- `traceability.linked_papers[]` for internal registry links to paper records
- `traceability.doi_traceability_status` with values such as:
  - `dataset_doi_documented`
  - `publication_doi_documented`
  - `linked_paper_record`
  - `not_documented`

## Paper Record

Paper records are supported even when the registry currently contains none.

- `record_type`
- `paper_id`
- `identity.title`
- `identity.short_title`
- `identity.publication_doi`
- `identity.language`
- `identity.status`
- `identity.wiki_page`
- `source_access.raw_path`
- `source_access.discovery_layers[]`
- `paper_metadata.authors`
- `paper_metadata.year`
- `paper_metadata.publication_venue`
- `paper_metadata.paper_type`
- `paper_metadata.has_published_data`
- `paper_metadata.has_dataset_doi`
- `paper_metadata.has_code_repository`
- `traceability.linked_datasets`
- `traceability.linked_warehouses`
- `traceability.dataset_dois`
- `traceability.notes`

The registry must not fabricate paper DOIs or dataset links. Empty arrays and null values are valid and preferred over unsupported guesses.

## Source Records

Source records describe where data can be discovered or obtained. The wiki stores source pages under `wiki/sources/`, grouped by source family.

Current source families:

- `warehouse`: official, institutional, or research data portals
- `software`: software/package/API ecosystems that expose data
- `literature`: scientific papers, journals, or review routes that lead to datasets

### Warehouse Record

Warehouse records remain first-class registry entries for compatibility with existing scripts, but their wiki pages now live under `wiki/sources/warehouses/`.

- `record_type`
- `warehouse_id`
- `identity.title`
- `identity.description`
- `identity.wiki_page` using `wiki/sources/warehouses/<source>.md`
- `warehouse_metadata.warehouse_type`
- `warehouse_metadata.provider`
- `warehouse_metadata.scope`
- `warehouse_metadata.access_modes`
- `warehouse_metadata.license_signals`
- `warehouse_metadata.notes`

Future software and literature source records should use the same top-level source identity pattern, but must keep their family explicit so they are not confused with institutional warehouses.

## Discovery Priorities

The registry must support ranking signals for:

- spatial datasets
- spatio-temporal datasets
- metadata-rich datasets
- open or reusable licenses
- papers with published data
- datasets linked to papers
- DOI-documented datasets and papers

These priorities are discovery signals, not proof of legal or scientific superiority. They should be based only on documented metadata.

## Estimator Policy Integration

The registry no longer allows free-form approved-estimator names inside dataset records.

- project-wide policy lives in `estimator_policy`
- every dataset record must carry an estimator-assessment block
- dataset records use `methodological_selection.candidate_estimators[]`
- each candidate estimator must come from the project allowlist
- each candidate estimator must store a justification grounded in documented dataset characteristics
- each dataset must record `methodological_selection.at_least_one_allowed_estimator_plausible`
- any estimator not present in the policy allowlist must not appear as a candidate estimator
- legacy methodological notes may mention non-allowlisted estimators only as historical context, never as project-approved options

### Candidate Estimator Entry

Each entry in `methodological_selection.candidate_estimators[]` must contain:

- `name`
- `plausible`
- `justification`
- `evidence_basis`

Where:

- `name` must be in the allowlist
- `plausible` is `true` or `false`
- `justification` explains why the estimator is or is not plausible for this dataset
- `evidence_basis` points to documented dataset traits such as spatial support, panel structure, response candidates, or temporal structure

If the dataset has not yet been assessed, use:

- `estimator_assessment_status: pending`
- `at_least_one_allowed_estimator_plausible: null`
- `candidate_estimators: []`

## Migration Notes from v2

- v2 `datasets[]` remains the core registry content
- `papers[]` and `warehouses[]` are added at the root
- free-text access wording may be preserved separately, but exact legal license evidence should be normalized into `access_metadata.license_metadata`
- `methodological_selection.eligible_estimators` should be replaced by a stricter candidate-estimator assessment block
- datasets without DOI information must keep DOI fields as null

## Related Pages

- [[dataset_catalog_schema_v2]]
- [[discovery_policy_v3]]
- [[restricted_estimator_policy_v1]]
- [[papers_directory_conventions]]
