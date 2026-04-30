---
title: Glossary
type: glossary
created: 2026-04-07
updated: 2026-04-22
sources: [pagoulatos1975.pdf]
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
- See also: [[related-page]]

---

## Terminology

**Intra-industry trade (IIT)** *(canonical form)*
: Simultaneous export and import of goods within the same industry category; also called two-way trade.
- Preferred: `intra-industry trade (IIT)` / Avoid: `intra trade`
- See also: [[grubel_lloyd_index]], [[pagoulatos1975_two_way_trade]]

**Two-way trade** *(canonical form)*
: Synonym of intra-industry trade used in older literature.
- Preferred: `two-way trade` (when quoting historical sources) / Avoid: `double-way trade`
- See also: [[grubel_lloyd_index]], [[pagoulatos1975_two_way_trade]]

**Grubel-Lloyd index** *(canonical form)*
: Bounded measure of intra-industry trade intensity based on exports and imports in the same category.
- Preferred: `Grubel-Lloyd index` / Avoid: `balanced trade score` (ambiguous)
- See also: [[grubel_lloyd_index]]

**Product differentiation** *(canonical form)*
: Degree to which products differ by quality, style, performance, branding, or origin, affecting trade overlap.
- Preferred: `product differentiation` / Avoid: `heterogeneity` (without context)
- See also: [[pagoulatos1975_two_way_trade]]

**Aggregation bias** *(canonical form)*
: Measurement distortion created when broad categories mix heterogeneous sub-products.
- Preferred: `aggregation bias` / Avoid: `classification noise` (too vague)
- See also: [[grubel_lloyd_index]], [[pagoulatos1975_methodology_to_metadata]]

**Export Price Range (EPR)** *(canonical form)*
: Condition in Gray-style trade modeling where exporting yields positive economic rent over time.
- Preferred: `export price range (EPR)` / Avoid: `export margin` (different meaning)
- See also: [[pagoulatos1975_two_way_trade]]

**Non-tariff barriers (NTB)** *(canonical form)*
: Trade restrictions other than tariffs (e.g., quotas, standards, administrative constraints).
- Preferred: `non-tariff barriers (NTB)` / Avoid: `soft tariffs`
- See also: [[pagoulatos1975_two_way_trade]]

**Unemployment rate** *(canonical form)*
: Share of the labour force that is unemployed under the selected statistical definition.
- Preferred: `unemployment rate` / Avoid: `joblessness ratio` (too informal/ambiguous)
- See also: [[insee_emploi_chomage_population_active]], [[eurostat_labour_force_survey]]

**Labour Force Survey (LFS)** *(canonical form)*
: Survey framework used to measure employment, unemployment, and activity status in a harmonized labour-market context.
- Preferred: `Labour Force Survey (LFS)` / Avoid: `employment poll`
- See also: [[eurostat_labour_force_survey]]

**BIT/ILO unemployment** *(canonical form)*
: Unemployment measured according to International Labour Organization criteria; `BIT` is the French shorthand often used in INSEE publications.
- Preferred: `BIT/ILO unemployment` / Avoid: `official unemployment` without definition
- See also: [[insee_emploi_chomage_population_active]], [[eurostat_labour_force_survey]]

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
