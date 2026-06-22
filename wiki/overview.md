---
title: Overview
type: overview
created: 2026-04-21
updated: 2026-06-04
sources:
  - AGENTS.md
  - README.md
  - inst/kg/concepts.yml
  - wiki/index.md
tags: [overview, synthesis, kg, corpus, wiki]
---

# Knowledge Base Overview

This page is the working synthesis of the LLM wiki, corpus and knowledge graph
system. It updates after major ingest, query, lint or architecture changes.

---

## Current State

The project is now organized around a KG-first workflow:

```text
curated corpus -> KG extraction/query -> wiki synthesis -> improved KG rules
```

The wiki is the stable narrative layer. The KG is the structured relation layer.
The corpus is the curated source layer. Root `raw/` remains read-only.

Current durable layers:

- `corpus/` for bibliographic records, PDFs, TEI and web Markdown;
- `inst/kg/` for KG schema, concepts, source rules and topic taxonomy;
- `.kg/graph.sqlite` for the local graph;
- `wiki/` for validated synthesis;
- `Code_scrapping/` for discovery, scraping, catalog and audit scripts.

---

## Source Families

Dataset discovery follows three source families.

| Source family | Purpose | Current state |
|---|---|---|
| R/Python package datasets | First controlled route for benchmark datasets distributed with software packages | most advanced |
| Scientific papers with open data | Papers in spatial statistics, spatial econometrics and spatio-temporal modeling that provide data/code/supplements | in construction |
| Data banks and portals | Research and institutional repositories such as Zenodo, Dryad, Dataverse, INSEE, Eurostat, OECD, World Bank | existing scrapers and manifests |

The package route is the first source explored because package documentation,
examples and references often expose variables, formulas and modeling context.

---

## Current Pipeline Picture

```text
R/Python packages
-> dataset inventory and extraction
-> package/dataset documentation
-> paper/formula audit
-> KG catalog extraction
-> wiki synthesis
```

```text
papers and books
-> references.bib
-> PDF in corpus/papers/raw_pdf/
-> GROBID TEI in corpus/papers/tei/
-> TEI parsing
-> KG paper/method/formula/dataset relations
-> wiki paper/concept/dataset pages
```

```text
web docs and tutorials
-> corpus/web_md/
-> KG/web-source extraction
-> wiki concepts, software and dataset documentation
```

---

## What The KG Tracks

The KG currently supports relations such as:

- `Paper USES_DATASET Dataset`
- `RPackage PROVIDES_DATASET Dataset`
- `Dataset HAS_VARIABLE Variable`
- `Dataset HAS_RESPONSE ResponseVariable`
- `Dataset HAS_COVARIATE Covariate`
- `Dataset SHOWS_FORMULA Formula`
- `Dataset DOCUMENTED_BY DocumentationPage`
- `Concept DOCUMENTED_BY WikiPage`

The KG should answer first-level questions before the agent reads long wiki,
TEI or corpus files.

---

## What The Wiki Stabilizes

The wiki stabilizes:

- dataset descriptions and metadata;
- source pages;
- estimator fiches;
- concept definitions;
- paper summaries;
- software/package pages;
- analysis notes and discovery outputs.

Recent durable additions include:

- enriched estimator fiches for GAM, GAMBoost, MGWR, SVC, INLA, MARS, SVM,
  RNN, Random Forest, XGBoost and LightGBM;
- concept pages for GWR, MGWR, spatial regression, generalized additive models,
  gradient boosted trees, latent Gaussian models, sequence models, support
  vector machines and adaptive regression splines;
- paper fiches for STWR, SGWR, GGP-GAM, XGBoost/SHAP spatial effects, spatial
  panel crop-yield models, R spatial econometrics software and remote-sensing
  deprivation modeling;
- a KG concept extraction script that creates `Concept DOCUMENTED_BY WikiPage`
  relations.

---

## Open Questions

- Which package datasets should become validated benchmark datasets first?
- Which scientific papers provide both open data and explicit formulas/models?
- Which paper-derived datasets should be promoted into `corpus/` and then KG/wiki?
- Which data-bank datasets can be linked to spatial or spatio-temporal modeling evidence?
- How should formula extraction distinguish robust source evidence from noisy TEI inference?
- Which validation protocols should be standardized for spatial and
  spatio-temporal estimator comparisons?

---

## Knowledge Gaps

- Some KG relations still depend on extraction heuristics and need manual review.
- Scientific-paper-with-open-data discovery is less mature than package dataset discovery.
- Source pages for several software packages and corpus web documents still need synthesis.
- `wiki/log.md`, `wiki/glossary.md` and `wiki/overview.md` must be kept in sync after durable changes.
- The KG has concept nodes, but richer concept-method-estimator relations can still be added.

---

## Related Pages

- [[index]]
- [[glossary]]
- [[gwr]]
- [[mgwr]]
- [[spatial_regression]]
- [[generalized_additive_models]]
- [[gradient_boosted_trees]]
- [[latent_gaussian_models]]
- [[data_leakage]]
