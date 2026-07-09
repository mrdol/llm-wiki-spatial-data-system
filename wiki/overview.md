---
title: Overview
type: overview
created: 2026-04-21
updated: 2026-07-08
sources:
  - AGENTS.md
  - README.md
  - inst/kg/concepts.yml
  - wiki/index.md
  - wiki/metadata/tidymodels_spatial_pipeline_status_2026-07.md
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

## Current Tidymodels Mission State

The active modeling mission is the integration of spatial estimators into a
tidymodels-compatible R benchmark. The durable status page is
[[tidymodels_spatial_pipeline_status_2026-07]].

Current implementation state:

- `workflows::workflow()` and `tune::tune_grid()` are working for the custom
  `spboost` and `mgwrsar_gwr` routes, with a static workflow fallback retained
  for fragile custom engines.
- Benchmark outputs, tuning grids and resample manifests are saved as `.rds`
  objects under `data/manifests/runs/`.
- `spatial_viz.R` reads RDS outputs and generates PNG figures from the R-native
  artifacts.
- `Code_scrapping/R/estimators/spatial_model_specs.R` now centralizes
  `build_specs()`, so the estimator registry is separate from the benchmark
  orchestration script.
- The benchmark includes native tidymodels baselines (`glm`, `earth`,
  `random_forest`, `xgboost`, plus `_xy` variants with coordinates), custom
  parsnip wrappers (`spboost`, `mgwrsar_*`) and direct fold-by-fold spatial
  estimators (`spatialreg`, `spmoran`).
- Spatial weights `W` are factorized in `Code_scrapping/R/utils/spatial_weights.R`
  and reused by SpBoost, MGWRSAR variants, spatialreg baselines and Moran
  diagnostics.

The naming convention now separates the R engine from the statistical model:

| Pipeline name | Meaning |
|---|---|
| `mgwrsar_gwr` | GWR model fitted through the R package/engine `mgwrsar` |
| `mgwrsar_mgwr` | MGWR multiscale route via `mgwrsar::TDS_MGWR()` |
| `mgwrsar_sar` | SAR baseline via `mgwrsar::MGWRSAR(Model = "SAR")` |
| `mgwrsar_mgwrsar` | MGWRSAR variant with explicit `W` and spatial autocorrelation |

The old names `mgwrsar`, `mgwrsar_multiscale` and `mgwrsar_autocorr` remain
accepted as aliases in manual calls, but new outputs should use the explicit
names above.

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

### Dataset Node Semantics

As of 2026-07-08, the KG no longer treats every catalogue line as a final
dataset. Dataset-related nodes are split into layers:

| KG type | Meaning | Current count |
|---|---|---:|
| `DatasetCatalogRecord` | raw package/catalogue/inventory line | 1108 |
| `DatasetCandidate` | candidate discovered but not validated as final | 9 |
| `Dataset` | promoted dataset entity with stronger evidence or local conversion | 197 |
| `DatasetArtifact` | local file artifact such as final RDS | 111 |

This change fixes the previous ambiguity where the KG reported more than one
thousand `Dataset` nodes even though many were only broad software catalogue
records. The current `Dataset` count should still be read carefully: it is a
promoted KG entity count, not yet a final "validated data bank" count.

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
- a tidymodels spatial benchmark status page documenting workflows, tuning,
  RDS outputs, estimator names, W construction, fold logging and remaining
  implementation gaps.

---

## Open Questions

- Which package datasets should become validated benchmark datasets first?
- Which scientific papers provide both open data and explicit formulas/models?
- Which paper-derived datasets should be promoted into `corpus/` and then KG/wiki?
- Which data-bank datasets can be linked to spatial or spatio-temporal modeling evidence?
- How should formula extraction distinguish robust source evidence from noisy TEI inference?
- Which validation protocols should be standardized for spatial and
  spatio-temporal estimator comparisons?
- Which spatial estimators should be promoted from direct fold-by-fold scoring
  into full parsnip model specs after the current benchmark stabilizes?
- Which official neighbor matrices, if any, can be recovered from dataset
  bundles and aligned with post-`complete.cases()` rows?

---

## Knowledge Gaps

- Some KG relations still depend on extraction heuristics and need manual review.
- Scientific-paper-with-open-data discovery is less mature than package dataset discovery.
- Source pages for several software packages and corpus web documents still need synthesis.
- `wiki/log.md`, `wiki/glossary.md` and `wiki/overview.md` must be kept in sync after durable changes.
- The KG has concept nodes, but richer concept-method-estimator relations can still be added.
- Several estimator fiches now pass structural review, but Tier 2 semantic
  review still flags source-fidelity gaps when local PDFs or TEI evidence are
  not extractable.
- `spmoran_resf` and some SAR/SEM/SDM prediction paths remain experimental in
  the benchmark because out-of-sample prediction requires careful train/test
  neighborhood handling.

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
- [[tidymodels_spatial_pipeline_status_2026-07]]
- [[spboost]]
- [[mgwrsar]]
