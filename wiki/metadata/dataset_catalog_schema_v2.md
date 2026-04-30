---
title: Dataset Catalog Schema v2
type: metadata
created: 2026-04-21
updated: 2026-04-21
sources: [pagoulatos1975.pdf]
tags: [metadata, schema, catalog, discovery, methodology]
---

Schema redesign for the local dataset catalog that separates identity, access, enriched metadata, and methodological selection.

## Status

This page documents the v2 architecture and is now superseded by [[catalog_registry_schema_v3]] for ongoing project design.

## Objective

Design a richer local catalog structure that can:

- represent multiple source types per dataset, including warehouse-backed sources
- expose discovery and access layers explicitly
- carry enriched metadata beyond title/source/keywords
- support methodological dataset selection directly in the catalog

## Design Drivers from Current Project Documents

- The minimal root catalog was sufficient for basic lookup but too shallow for source comparison and model-oriented selection.
- [[pagoulatos1975_methodology_to_metadata]] requires explicit fields for classification transparency, comparability notes, and risk annotation.
- [[france_unemployment_datasets_comparison]] shows that dataset choice depends on methodological intent, not only topic keywords.
- Existing dataset pages already document access conditions, reproducibility constraints, spatial-temporal structure, and preferred analytical use.

## Schema Blocks

### 1. Identity

Stable descriptive layer for the dataset itself.

- `dataset_id`
- `identity.title`
- `identity.short_title`
- `identity.description`
- `identity.dataset_doi`
- `identity.publication_doi`
- `identity.language`
- `identity.status`
- `identity.wiki_page`

### 2. Source and Access

Explicit support for multiple sources and discovery channels. In the v2 machine schema these are still stored under `source_access.warehouses[]`; in the wiki layout the corresponding pages now live under `wiki/sources/warehouses/`.

- `source_access.warehouses[]`
- `warehouses[].name`
- `warehouses[].warehouse_type`
- `warehouses[].provider`
- `warehouses[].roles`
- `warehouses[].discovery_layers[]`
- `discovery_layers[].layer_type`
- `discovery_layers[].name`
- `discovery_layers[].access`
- `discovery_layers[].url`
- `discovery_layers[].notes`

This supports cases where:

- a dataset is published by one warehouse but derived from another
- a dataset is discovered through a software/package/API ecosystem
- a dataset is discovered through a scientific paper or journal route
- public aggregates and restricted microdata coexist
- the same dataset can be discovered through portal, API, and bulk-download routes

### 3. Enriched Content Metadata

This block carries analytical content instead of only search text.

- `content_metadata.keywords`
- `content_metadata.variables[]`
- `variables[].name`
- `variables[].role`
- `variables[].type`
- `content_metadata.response_candidates`
- `content_metadata.classification_systems`
- `content_metadata.use_cases`

### 4. Spatio-Temporal Structure

This aligns with the dataset-page requirements in `AGENTS.md`.

- `spatiotemporal.data_type`
- `spatiotemporal.structure`
- `spatiotemporal.spatial_support`
- `spatiotemporal.spatial_resolution`
- `spatiotemporal.spatial_extent`
- `spatiotemporal.temporal_resolution`
- `spatiotemporal.time_range`
- `spatiotemporal.n_observations`
- `spatiotemporal.t_periods`
- `spatiotemporal.nt_profile`

### 5. Access Metadata

Operational extraction and reproducibility layer.

- `access_metadata.file_formats`
- `access_metadata.api_available`
- `access_metadata.bulk_download`
- `access_metadata.license`
- `access_metadata.access_conditions`
- `access_metadata.update_frequency`
- `access_metadata.machine_readable`
- `access_metadata.reproducibility_strength`
- `access_metadata.reproducibility_notes`

### 6. Methodological Selection

This is the key addition missing from the earlier flat schema.

- `methodological_selection.recommended_when`
- `methodological_selection.not_preferred_when`
- `methodological_selection.task_types`
- `methodological_selection.eligible_estimators`
- `methodological_selection.selection_criteria`
- `methodological_selection.comparability_notes`
- `methodological_selection.indicator_specification`
- `methodological_selection.risks`
- `methodological_selection.limitations`

## Methodological Rationale

The project documents imply two distinct selection modes:

- question-driven selection
- estimator-driven selection

For labour-market datasets:

- INSEE is preferred for France-only and territorial analysis
- Eurostat LFS is preferred for harmonized France-versus-Europe comparison

For trade datasets:

- UN Comtrade is preferred for maximum official global coverage
- OECD ITCS is preferred for OECD-centered commodity trade comparisons
- CEPII BACI is preferred when reconciled bilateral flows and HS6 detail matter for Grubel-Lloyd style work

## Supported Catalog Patterns

### Multiple Source Types

Example supported combinations:

- official statistical warehouse
- supranational statistical warehouse
- intergovernmental statistical warehouse
- research data portal
- upstream source dependency
- software/package/API source
- scientific-literature source

### Discovery Layers

Layer types now represent how a dataset is actually found or accessed:

- `portal`
- `api`
- `bulk_download`
- `restricted_microdata`
- `upstream_dependency`

## Current v2 Coverage

The live v2 catalog now includes five documented datasets spanning five distinct providers:

| Dataset | Provider | Warehouse type | Core methodological role |
|---|---|---|---|
| [[insee_emploi_chomage_population_active]] | INSEE | national statistical warehouse | France-only labour-market reference |
| [[eurostat_labour_force_survey]] | Eurostat | supranational statistical warehouse | harmonized European comparison |
| [[un_comtrade_merchandise_trade]] | UNSD | international statistical warehouse | global official trade baseline |
| [[oecd_itcs]] | OECD | intergovernmental statistical warehouse | OECD-centered commodity trade analysis |
| [[cepii_baci]] | CEPII | research data portal | reconciled high-resolution bilateral trade |

## Remaining Gaps

- Exact table identifiers are still missing for the labour-market records.
- Stable dataset URLs are not yet documented for every trade provider in the current wiki pages.
- Variable pages are still missing and should eventually back-link to catalog variable roles.

## Related Pages

- [[pagoulatos1975_methodology_to_metadata]]
- [[france_unemployment_datasets_comparison]]
- [[insee_emploi_chomage_population_active]]
- [[eurostat_labour_force_survey]]
- [[un_comtrade_merchandise_trade]]
- [[oecd_itcs]]
- [[cepii_baci]]
