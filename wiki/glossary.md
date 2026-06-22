---
title: Glossary
type: glossary
created: 2026-04-07
updated: 2026-06-04
sources: []
tags: [terminology, style, glossary]
---

# Glossary

Living reference of terms, definitions, and style conventions. The LLM checks this before using any technical term. Updated on every ingest that introduces new or refined terminology.

---

## How to Read This Glossary

Each entry follows this format:

**Term** *(canonical form)*
: Definition. Usage notes. Related terms.
- Preferred: `term` / Avoid: `deprecated term`
- See also: `related-page`

---

## Terminology

**Unemployment rate** *(canonical form)*
: Share of the labour force that is unemployed under the selected statistical definition.
- Preferred: `unemployment rate` / Avoid: `joblessness ratio` (too informal/ambiguous)

**Labour Force Survey (LFS)** *(canonical form)*
: Survey framework used to measure employment, unemployment, and activity status in a harmonized labour-market context.
- Preferred: `Labour Force Survey (LFS)` / Avoid: `employment poll`

**BIT/ILO unemployment** *(canonical form)*
: Unemployment measured according to International Labour Organization criteria; `BIT` is the French shorthand often used in INSEE publications.
- Preferred: `BIT/ILO unemployment` / Avoid: `official unemployment` without definition

**Warehouse type** *(canonical form)*
: Functional category describing the nature of the data source that publishes or intermediates a dataset (for example national statistical warehouse, research data portal, or intergovernmental statistical warehouse).
- Preferred: `warehouse type` / Avoid: `source kind` (too vague)
- See also: [[dataset_catalog_schema_v2]]

**Discovery layer** *(canonical form)*
: Explicit access surface through which a dataset can be found or retrieved, such as a portal, API, bulk-download channel, or restricted microdata route.
- Preferred: `discovery layer` / Avoid: `entry point` (too ambiguous)
- See also: [[dataset_catalog_schema_v2]]

**Methodological selection** *(canonical form)*
: Dataset choice logic based on the analytical objective, estimator, comparability needs, and known risks rather than topic labels alone.
- Preferred: `methodological selection` / Avoid: `best dataset` (context-free)
- See also: [[dataset_catalog_schema_v2]], [[france_unemployment_datasets_comparison]]

**License-aware search** *(canonical form)*
: Discovery logic that considers documented reuse rights or license categories when ranking datasets.
- Preferred: `license-aware search` / Avoid: `open-data search` when the exact license is not documented
- See also: [[discovery_policy_v3]]

**Paper-linked dataset discovery** *(canonical form)*
: Dataset discovery strategy that boosts records with explicit links to paper records, published-data statements, or DOI traceability.
- Preferred: `paper-linked dataset discovery` / Avoid: `paper-backed dataset` unless the link is documented
- See also: [[discovery_policy_v3]], [[papers_directory_conventions]]

**DOI traceability** *(canonical form)*
: Separation and tracking of dataset DOI, publication DOI, and explicit links between datasets and papers in the registry.
- Preferred: `DOI traceability` / Avoid: `DOI link` when the relationship type is unclear
- See also: [[catalog_registry_schema_v3]]

**Paper record** *(canonical form)*
: Registry or wiki entry describing a documented paper, its DOI, provenance, and links to datasets or warehouses.
- Preferred: `paper record` / Avoid: `paper note` when the page is meant to be a formal registry entry
- See also: [[papers_directory_conventions]], [[catalog_registry_schema_v3]]

**Restricted estimator policy** *(canonical form)*
: Project rule that only allowlisted estimators may appear as approved estimators in dataset records or discovery outputs.
- Preferred: `restricted estimator policy` / Avoid: `recommended models` unless they are in the allowlist
- See also: [[restricted_estimator_policy_v1]]

**Knowledge graph (KG)** *(canonical form)*
: Structured graph layer linking papers, datasets, variables, formulas, methods, packages and documentation pages.
- Preferred: `KG` or `knowledge graph` / Avoid: `graphify` unless referring to the external tool
- See also: `inst/kg/concepts.yml`, `.kg/graph.sqlite`

**Corpus** *(canonical form)*
: Curated source layer containing bibliographic records, PDFs, TEI files, web Markdown and source metadata.
- Preferred: `corpus` / Avoid: `raw` for curated material
- See also: `corpus/bib/references.bib`, `corpus/papers/raw_pdf/`, `corpus/web_md/`

**Raw archive** *(canonical form)*
: Read-only archive or staging area at root `raw/`. Agents may inspect it but should not modify it unless explicitly asked.
- Preferred: `raw archive` / Avoid: treating `raw/` as the active ingestion layer
- See also: `corpus`

**Source family** *(canonical form)*
: One of the three dataset discovery routes: R/Python package datasets, scientific papers with open spatial/ST data, or data banks/portals.
- Preferred: `source family` / Avoid: `source type` when the three-family distinction matters
- See also: [[overview]]

**Package dataset** *(canonical form)*
: Dataset distributed through an R or Python package, often with package help, examples or documentation.
- Preferred: `package dataset` / Avoid: `software dataset` if the package source is unclear
- See also: `wiki/datasets/r_package_docs/`

**GROBID** *(canonical form)*
: PDF parsing service used to convert scientific PDFs into TEI XML for downstream KG extraction.
- Preferred: `GROBID` / Avoid: treating it as a paper search or download tool
- See also: `corpus/papers/tei/`

**TEI** *(canonical form)*
: XML representation of a parsed scientific document produced by GROBID.
- Preferred: `TEI` / Avoid: treating TEI extraction as validated interpretation
- See also: `corpus/papers/tei/`

**JabRef/BibDesk bibliography** *(canonical form)*
: Bibliographic management layer for `references.bib`, citation keys, DOI, metadata and local PDF links.
- Preferred: `JabRef/BibDesk bibliography` / Avoid: treating JabRef as the KG
- See also: `corpus/bib/references.bib`

**GAM** *(canonical form)*
: Generalized additive model using smooth terms to model nonlinear effects while preserving additive interpretability.
- Preferred: `GAM` / Avoid: confusing with `GAMBoost`
- See also: [[gam]], [[generalized_additive_models]]

**GAMBoost** *(canonical form)*
: Model-based boosting family that fits base learners to pseudo-residuals and updates an additive predictor through boosting iterations.
- Preferred: `GAMBoost` / Avoid: using it as a synonym for ordinary GAM
- See also: [[gamboost]], [[gam]]

**MGTWR** *(canonical form)*
: Multiscale geographically and temporally weighted regression, a GTWR extension with covariate-specific spatial and temporal bandwidths.
- Preferred: `MGTWR` / Avoid: using it as a synonym for spatial-only `MGWR`
- See also: [[mgtwr]], [[mgwr]]

**STWR** *(canonical form)*
: Spatiotemporal weighted regression, a local regression model using space-time weights to analyze nonstationarity in space and time.
- Preferred: `STWR` / Avoid: treating it as ordinary spatial-only GWR
- See also: [[stwr]], [[spatiotemporal_data]]

**SGWR** *(canonical form)*
: Similarity and geographically weighted regression, a GWR extension that combines geographic proximity and attribute similarity weights.
- Preferred: `SGWR` / Avoid: using it for any similarity model without a geographic weighting component
- See also: [[sgwr]], [[gwr]]

**GGP-GAM** *(canonical form)*
: Geographical Gaussian Process GAM, a smooth GAM/Gaussian-process route for spatially varying coefficient modeling.
- Preferred: `GGP-GAM` / Avoid: treating it as a kernel-weighted GWR variant
- See also: [[geographical_gaussian_process_gam]], [[generalized_additive_models]]

**SHAP spatial effects** *(canonical form)*
: Use of SHAP/local feature attribution to interpret spatial patterns learned by machine-learning models and compare them with spatial statistical models.
- Preferred: `SHAP spatial effects` / Avoid: claiming SHAP estimates causal spatial effects without design evidence
- See also: [[shap_spatial_effects]], [[gradient_boosted_trees]]

**Spatial validation** *(canonical form)*
: Validation design that respects spatial dependence, for example spatial blocks or leave-location-out splits.
- Preferred: `spatial validation` / Avoid: random folds as default for spatial transfer claims
- See also: [[data_leakage]], [[spatial_regression]]

---

## Style Conventions

*(Writing rules and tone guidelines specific to this knowledge base's domain. Will populate as style guides and branded content are ingested.)*

| Convention | Rule | Example |
|---|---|---|
| *(none yet)* | | |

---

## Deprecated / Avoid List

Terms that have been replaced, renamed, or should not be used:

| Avoid | Use Instead | Reason |
|---|---|---|
| *(none yet)* | | |

---

## Regional / Variant Terms

Terms that differ between audiences, teams, or locales:

| Term | Region/Context | Notes |
|---|---|---|
| `BIT` | French statistical publications | French shorthand corresponding to ILO unemployment definitions |

---

## Related Pages

- [[overview]] - big-picture synthesis
- [[index]] - master catalog
