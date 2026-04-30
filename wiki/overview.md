---
title: Overview
type: overview
created: 2026-04-21
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
tags: [overview, synthesis]
---

# Knowledge Base Overview

*This page is the LLM's working synthesis of the dataset and metadata knowledge base. It updates after every ingest or major query.*

---

## Current State

The wiki now contains one methodological source, a broader metadata-oriented inventory of official and research source pages, and a new architecture layer for paper-aware, license-aware, DOI-traceable discovery.

**Source count:** 1  
**Datasets identified:** 9  
**Papers documented:** 0  
**Variables identified:** 0  
**Wiki pages:** 34  
**Last ingest:** `pagoulatos1975.pdf` (methodological source)  
**Last query:** architecture upgrade for license-aware, paper-linked, DOI-traceable discovery and restricted estimator policy  
**Last lint:** -  

---

## What This Wiki Covers

This wiki is designed to progressively build a structured knowledge base of:

- datasets (economic, social, territorial, trade, and property)
- variables and indicators
- data source families: warehouses, software/package/API sources, and scientific-literature sources
- paper records and paper-directory conventions for future source-linked discovery
- metadata structures
- methodological concepts
- links between data and statistical models
- dataset and paper registry schemas with methodological selection rules
- direct-access manifests for reproducible raw extraction
- analysis subfolders for progressive metadata construction, discovery, estimation, prediction, and cross-validation results
- variable typology and modeling-evidence concepts for estimator eligibility decisions

---

## Key Themes

Current themes from ingested literature and exploratory discovery:

- intra-industry (two-way) trade measurement
- product differentiation and imperfect competition
- aggregation bias from classification granularity
- tariff and non-tariff barrier effects in econometric models
- metadata design for proxy variables and constructed indicators
- France labour-market measurement
- unemployment dataset selection for national versus European comparison
- metadata-oriented exploration of sources with strong spatial and spatio-temporal structure
- classification-aware catalog design for product, geography, and time dimensions
- raw-data acquisition workflow for candidate datasets without transformation
- license-aware search and DOI-based traceability
- paper-linked dataset discovery without inventing paper records
- restricted estimator governance through a project allowlist

---

## Open Questions

*(Maintained dynamically by the LLM)*

- Which trade datasets provide consistent SITC mappings across classification levels?
- How should non-tariff barriers be harmonized across sources and periods?
- Which metadata fields best capture proxy validity and confounder risks?
- What minimum documentation is needed to compare IIT metrics across studies?
- Which exact INSEE series should be treated as the canonical France unemployment reference in this wiki?
- Which Eurostat LFS tables best align with France-focused unemployment analysis in this wiki?
- Which exact INSEE API endpoint should be used to export localized unemployment series directly from `api.insee.fr`?
- Which World Bank indicator families should receive dedicated variable pages first?
- How should commune, IRIS, NUTS, country, and parcel-level supports be normalized across source families in the catalog?
- Which documented papers should become the first explicit paper records in `wiki/papers/`?
- Which datasets have exact legal licenses that can be normalized beyond `unknown` in the registry?
- Which dataset pages can support dataset DOI or publication DOI fields from official documentation?

---

## Knowledge Gaps

*(Areas where more sources or datasets are needed)*

- no wiki variable pages yet for trade flow variables (`Xi`, `Mi`) and harmonization fields
- new standardized catalog schema exists, but variable-level pages are still missing
- limited metadata for barrier measures and partner-country comparability
- limited guidance on HS-to-SITC concordance for cross-source comparability
- no dedicated variable pages yet for labour-market indicators such as unemployment rate or labour-force participation
- exact table identifiers are still missing for some labour-market records
- many access pages are documented, but raw downloads were not attempted in this turn for the newly discovered sources
- the wiki now records access manifests, but there is still no dedicated page for download-manifest conventions
- no explicit paper records yet, even though the architecture now supports them
- most dataset licenses are still normalized conservatively because exact legal license texts are not yet pinned
- DOI fields are structurally present in the registry, but not yet populated from documented evidence
- current dataset records do not yet validate any project-allowed estimator against a specific dataset
- no progressive metadata-inspection outputs have yet been filed under `wiki/analyses/metadata/`
- no estimation, prediction, or cross-validation pipeline outputs have yet been filed under `wiki/analyses/modeling/`

---

## Related Pages

- [[index]] - full catalog of all wiki pages
- [[glossary]] - terminology and definitions
- [[pagoulatos1975_two_way_trade]] - first methodological source ingest
- [[pagoulatos1975_methodology_to_metadata]] - actionable metadata implications
- [[dataset_catalog_schema_v2]] - enriched local catalog schema with methodological selection
- [[catalog_registry_schema_v3]] - registry schema adding papers, DOI fields, and license metadata
- [[discovery_policy_v3]] - ranking logic for spatial, metadata, license, and paper traceability signals
- [[restricted_estimator_policy_v1]] - strict project estimator allowlist
- [[papers_directory_conventions]] - conventions for future paper pages and paper manifests
- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]] - warehouse-level exploration for metadata enrichment
- [[insee_base_permanente_equipements]] - strong commune/IRIS annual territorial structure
- [[data_gouv_dvf_geolocalisees]] - property transaction dataset with coordinates and cadastral identifiers
- [[world_bank_world_development_indicators]] - global indicator warehouse with country-time metadata
- [[eurostat_comext_itg]] - EU trade warehouse with rich geography-product-time classifications
- [[un_comtrade_merchandise_trade]] - global official trade baseline
- [[cepii_baci]] - reconciled bilateral high-resolution trade database

## Raw Access State

- Historical raw downloads remain documented for earlier labour-market work.
- No new raw datasets were downloaded in this architecture stage.
- No raw papers were downloaded or transformed in this architecture stage.
