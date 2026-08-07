---
title: Data paper draft - Package-derived spatial benchmark datasets (Bloc 1-6 fiches)
type: analysis
created: 2026-08-04
updated: 2026-08-04
sources:
  - AGENTS.md
  - wiki/metadata/catalog_registry_schema_v3.md
  - wiki/metadata/quality_pedigree_schema_v1.md
  - wiki/metadata/spatialtidymodels_package_status_2026-07.md
  - wiki/metadata/benchmark_selection_dashboard_supervisor_note_2026-07.md
  - wiki/eval_queue.md
  - wiki/analyses/datapapers/software_datasets_datapaper_draft_2026_07.md
  - code/r_catalog/generate_fiches.py
  - packages/spatialtidymodels/inst/metadata/estimators.json
  - packages/spatialtidymodels/inst/metadata/datasets.json
  - wiki/datasets/fiches_datasets (91 Bloc 1-6 fiches, aggregate counts)
tags: [datapaper, package-datasets, spatial, benchmark, spatialtidymodels, formula-candidates, quality-control, draft]
---

# Data paper draft - Package-derived spatial benchmark datasets

Working title:

> A harmonized, benchmark-ready collection of spatial datasets distributed through R and Python packages: metadata schema, candidate formulas, and estimator eligibility for the `spatialtidymodels` framework

Short alternative title:

> Package-derived spatial benchmark datasets: a curated metadata layer for spatial regression and spatial machine learning

## Relation to the prior draft

A broader, earlier draft exists at [[software_datasets_datapaper_draft_2026_07]] (created 2026-07-20). That draft scopes the whole software-distributed catalogue (1,178 catalogue records, 120-entry harmonized `sf` index) and predates the 2026-07-28/29 additions to the fiche schema: per-role `formula_candidates` (`univariate` / `multivariate_constrained` / `ml_or_selected`), the `estimator_eligibility` block, and the `spatialtidymodels` benchmark design (CV schemes, output columns, ranking criteria).

This draft is narrower and more precise: it targets specifically the 91 datasets currently documented as full Bloc 1-6 Markdown fiches under `wiki/datasets/fiches_datasets/`, which is the subset actually structured enough to feed `spatialtidymodels`. It should be treated as a refined, more current companion to the 2026-07-20 draft, not a duplicate — the two should eventually be merged or the older one explicitly superseded once the catalogue-level and fiche-level numbers are reconciled.

## Constraints assumed throughout this draft

- No empirical benchmark results are reported or invented; this is a data/methods paper, not a results paper.
- No DOI is invented. Dataset DOI is structurally `none` for package-derived data; publication DOI is reported only when resolved and verbatim-matched.
- Published, manually-confirmed, and system-generated formulas are kept visibly distinct throughout (never merged into a single "formula" claim).
- `spatialtidymodels` is described as a package under active development, not a finished or released tool.
- Reproducibility, metadata normalization, benchmark-readiness, and reuse by other researchers are treated as the paper's central contributions.

---

## 1. Proposed manuscript structure

| # | Section |
|---|---|
| 1 | Title |
| 2 | Abstract |
| 3 | Background and motivation |
| 4 | Source scope and inclusion criteria |
| 5 | Data collection and harmonization |
| 6 | Metadata schema |
| 7 | Benchmark readiness |
| 8 | Quality control |
| 9 | Data records |
| 10 | Technical validation |
| 11 | Reuse potential |
| 12 | Limitations |
| 13 | Code availability |
| 14 | Data availability and licensing |
| 15 | Author contributions / competing interests / acknowledgements |

---

## 2. Abstract (draft)

Benchmarking spatial regression and spatial machine-learning estimators requires datasets whose response and covariate roles, spatial structure, and modelling evidence are explicitly documented — a requirement rarely met by the ad hoc example datasets distributed inside R and Python packages. We present a curated collection of 91 spatial datasets harmonized from R and Python software packages (including `spdep`, `spData`, `spDataLarge`, `GWmodel`, `gstat`, `sp`, `sfdep`, `ade4`, `agridat`, `geodatasets`, `libpysal`), each documented through a standardized six-block metadata fiche covering variable typology, geometry, coordinate reference system, temporal structure, and reproducibility evidence. For each dataset we distinguish three tiers of candidate regression formula — a simple univariate baseline, a multivariate specification tied to published or manually confirmed evidence when available, and a machine-learning candidate feature set — alongside a single common `formula_used` intended for strict cross-estimator benchmarking. Datasets are further annotated with per-estimator eligibility notes distinguishing scientific evidence from benchmark-use justification, feeding a companion R package, `spatialtidymodels` (in active development), which exposes up to 26 spatial and non-spatial estimators and four cross-validation schemes (near-prediction, spatial block, holdout, and standard v-fold). We report the current state of quality control transparently: most fiches carry system-generated rather than publication-confirmed formulas, coordinate reference systems remain unresolved for a majority of records, and dataset-level DOIs are structurally absent for package-derived data. We describe this collection as a first, package-derived layer of a larger three-part spatial data-bank construction strategy, intended to be reused for reproducible estimator comparison rather than presented as a finished benchmark suite.

*(Figures to re-verify at freeze time: 91 fiches, package list, 26 estimators, 4 CV schemes — pipeline is still running as of 2026-07-29.)*

---

## 3. Background and motivation

Comparing spatial regression estimators — from classical SAR/SEM specifications to spatially-aware machine learning methods such as SpBoost, MGWRSAR, or geographically weighted random forests — requires more than access to raw data. It requires knowing, for each dataset, which variable plays the role of response, which variables are legitimate covariates versus coordinates or identifiers, whether a documented model specification exists, what spatial support and coordinate reference system apply, and which estimators are scientifically or practically justified for that dataset. Existing example datasets embedded in R and Python spatial packages (e.g. `spdep::columbus`, `GWmodel::LondonHP`, `gstat::meuse`) are widely reused in tutorials and papers, but this metadata is rarely made explicit or machine-readable, and formula specifications — when they exist at all — are typically buried in vignettes, textbooks, or the original publication rather than in the package documentation itself.

This paper documents the first of three planned source layers of a larger spatial data-bank construction effort: datasets distributed through R and Python software packages. This layer was deliberately built first because it is the most controlled: package documentation, source code, and (in some cases) an associated publication provide a traceable evidence base, allowing the metadata-extraction pipeline and its quality-control rules to be calibrated before being applied to less structured sources such as paper-linked replication archives or institutional data portals.

The contribution is a harmonization and annotation layer, not new field data. We standardize 91 datasets from a set of R/Python packages into a six-block metadata fiche (Bloc 1-6) recording variable typology, candidate and confirmed regression formulas, model typology, spatiotemporal structure, spatial resolution/extent, and reproducibility evidence. Each fiche additionally stores a structured, estimator-by-estimator eligibility assessment feeding a companion R package under active development, `spatialtidymodels`.

**Information to inject before final drafting**: an exact, deduplicated list of source packages and dataset counts per package (requires a clean extraction script, not an ad hoc pattern match) — see §13.1.

---

## 4. Source scope and inclusion criteria

To be completed with: the explicit rule used to admit a package into the pipeline (spatial statistics / spatial econometrics / geostatistics / spatial panels / epidemiology / ecology / agronomy relevance), and the explicit rule used to admit an individual dataset from that package (geometry constructible, or coordinates present, or explicit spatial reference in documentation). This section should also state clearly that not all datasets documented in `wiki/datasets/r_package_docs/` (931 raw R help pages) reached full Bloc 1-6 curation — only 91 currently have a complete fiche under `wiki/datasets/fiches_datasets/`.

---

## 5. Data collection and harmonization

The pipeline follows a strictly staged, mostly deterministic architecture, deliberately separating steps that require no judgment from steps that require semantic interpretation:

1. **`export_sf_metadata.R`** - deterministic extraction: for each candidate R/Python package dataset, coerce to `sf` where geometry is directly constructible, apply a rule-based statistical typology (continuous/binary/count/rate/...), and route coordinate and identifier columns by name pattern, without any judgment about which variable is the response.
2. **`generate_fiches.py`** - LLM-assisted selection (Claude Sonnet 4.6): given the system-level variable inventory, the model proposes which variable(s) are plausible response candidates and which are covariates, and writes the Bloc 1-6 Markdown fiche. This step is cached per dataset.
3. **`enrich_web.py`** - deterministic license/year lookup (PyPI/CRAN/GitHub) plus LLM+web-search enrichment for DOI, reference publication, and formula evidence, under an explicit anti-hallucination guard: a DOI is accepted only if it matches the DOI regex **and** is found verbatim in the fetched source, never reconstructed from memory. Formula search is run as a query separate from publication search, because a paper rarely reproduces the exact regression formula used in package vignettes, tutorials, or textbooks.

Each fiche stores its provenance and evidence status explicitly (`Description confidence`, `Niveau de preuve`, `estimator_eligibility[].basis`) rather than presenting all fields as equally certain.

**Information to inject before final drafting**: a close re-read of `code/r_catalog/generate_fiches.py` and `enrich_web.py` bodies (only the commit trace and schema notes were inspected for this draft, not the full script logic) to confirm the step descriptions above are exact.

---

## 6. Metadata schema

Each dataset is documented as a Markdown fiche following the **Bloc 1-6 structure** (Bloc 1 - Formula and variables, Bloc 2 - Identification and DOI, Bloc 3 - Model typology, Bloc 4 - Data typology, Bloc 5 - Resolution and extent, Bloc 6 - Reproducibility), enforced structurally by an automated Tier 1 check. This concrete Markdown layout implements, but does not literally mirror, the conceptual JSON registry schema ([[catalog_registry_schema_v3]]), which defines the underlying field semantics (variable typology, feature-selection provenance, modelling-evidence provenance, license-metadata evidence blocks) shared across all three planned source layers of the project.

### Formula candidates

Bloc 1 stores up to three formula profiles, each carrying its own status and evidence trail:

| Role | Intended use | `source_type` values observed |
|---|---|---|
| `univariate` | simple baseline / pedagogical formula | `published_or_manual_formula` |
| `multivariate_constrained` | specification tied to a paper or documentation | `published_or_manual_formula` / `none_found` |
| `ml_or_selected` | broader feature set for tree/boosting models | `generated_system_formula` / `none_found` |

A single `formula_used` (with `x_terms_used`, `y_term_used`) is retained per dataset as the canonical formula for strict cross-estimator benchmarking. It is explicitly tagged with a `Statut regression canonique` (`resolu` / `pending` / `generated_system_formula`) and a `Niveau de preuve` (`publication` / `system_generated` / `n/a`), so that a reader can distinguish a formula confirmed against a published source from one proposed by the pipeline itself.

### Estimator eligibility

Each fiche carries an `estimator_eligibility` block listing, per candidate estimator, a `basis` (`scientific_evidence` when a cited source directly supports the pairing, `benchmark_use` when the pairing is a project-internal test choice) and a `source_ref`. This block is the direct machine-readable input to the dataset x estimator matrix used downstream.

**Information to inject before final drafting**: one or two contrasted example fiches to cite as illustrations - one with a publication-confirmed formula (e.g. `R_GWmodel_LondonHP_londonhp`, formula tied to Lu, Charlton, Harris & Fotheringham 2014, DOI 10.1080/13658816.2013.865739), one with a system-generated, unvalidated formula - to be selected and cited precisely in an appendix.

---

## 7. Benchmark readiness

Metadata harmonization exists to serve a specific downstream consumer: `spatialtidymodels`, an R package **currently under active development, not a finished or released tool**. The package exposes two levels of use: direct single-estimator fitting (e.g. `fit_sar()`) for diagnosis, and `benchmark_spatial_dataset()` for automated multi-estimator comparison on a registered dataset.

As of the current package snapshot, `spatialtidymodels` embeds 7 ready-to-use benchmark datasets (`boston_housing`, `columbus_crime`, `dub_voter`, `ewhp`, `georgia`, `lasrosas`, `london_hp`) out of the 91 documented fiches. The gap between documented fiches and package-embedded datasets should be reported honestly as a maturity indicator, not elided. The estimator registry (`inst/metadata/estimators.json`) currently lists 26 estimator variants spanning non-spatial baselines (OLS, MARS, random forest, XGBoost, GAMBoost), coordinate-augmented baselines (`*_xy` variants), classical spatial econometrics (`sar_lag`, `sem_error`, `sdm_mixed` via `spatialreg`), SpBoost (4 variants: SAR/SEM x ML/CFE), MGWRSAR (6 variants), spatial eigenvector filtering (SpMoran, 2 variants), and spatial random forests (SpatialML GRF, SpatialRF, RFGLS).

Cross-validation is handled through four schemes with distinct interpretations: `near_prediction` (local prediction around observed zones, closer to spatial interpolation), `block_spatial` (spatially separated training/test blocks, a stricter generalization test), `holdout_10pct` (quick single split), and `vfold_cv` (standard non-spatial CV, retained mainly as a cautionary comparison since it can overestimate performance under spatial autocorrelation). Benchmark output per estimator x fold includes RMSE, MAE, residual Moran's I and its p-value, computation duration, and, where the backend exposes a likelihood, AIC/AICc/logLik; not all estimator families expose all metrics (random forest, XGBoost, SpatialRF, and SpatialML GRF have no comparable scalar spatial parameter or likelihood).

For strict cross-estimator comparison, all estimators evaluated on a given dataset must use the same `formula_used` and the same folds; formula-specific pipelines (using `multivariate_constrained` or `ml_or_selected` variants) are treated as a separate comparison mode - pipeline comparison, not pure estimator comparison - and must not be mixed into the same ranking table.

**Information to inject before final drafting**: a decision, with the supervisor, on whether the paper names all 26 estimators explicitly given the package is still evolving (some are flagged "to watch" in its own status page). Recommended: freeze and cite a tagged package/registry version at time of writing rather than an in-text list that will drift.

---

## 8. Quality control

Every fiche passes through a three-tier evaluation pipeline before being considered stable: Tier 1 (structural - YAML frontmatter, required Bloc sections, resolvable `[[wiki-links]]`), Tier 2 (semantic, LLM-as-judge scoring `y_typology_ok`, `x_typology_ok`, `nt_profile_consistent`, `formula_faithful`), and Tier 3 (amber queue for scores in [0.50, 0.75)). A score >= 0.75 requires a verifiable source; fiches with `sources: []` or an unresolved reference are capped at 0.74 regardless of internal coherence.

As of the current snapshot, essentially all package-derived dataset fiches sit in the amber band (observed scores 0.62-0.74 across the sample reviewed in [[eval_queue]]), pending manual correction; none has yet been marked `reviewed`. This is expected under the project's Delta-1 rule (an LLM may propose a quality assessment but never self-validate it as `reviewed`, see [[quality_pedigree_schema_v1]]); it is not evidence of poor fiche quality, but it does mean the collection should be described as *provisionally validated*, not *finalized*, in any external submission.

Concrete completeness figures across the 91 fiches (counted directly from `wiki/datasets/fiches_datasets/`, 2026-08-04):

| Indicator | Value |
|---|---:|
| Dataset DOI present | 0 / 91 (structurally absent for package-derived data; recorded as `none`, per project policy) |
| Publication DOI resolved | 10 / 91 |
| Canonical formula backed by a publication (`Niveau de preuve: publication`) | 13 / 91 |
| Canonical formula system-generated, not yet validated | 53 / 91 |
| Canonical formula status pending / not applicable | 25 / 91 |
| CRS still flagged for manual resolution (`CRS analyse recommandé: pending`) | 52 / 91 |
| `quality_pedigree` block populated | not yet systematic across the sample; flagged as a recurring gap in [[eval_queue]] |

The absence of a dataset DOI for package-distributed data is a structural, not a quality, feature: the project's metadata policy explicitly accepts `Dataset DOI: none` when package source, object name, source URL/documentation, license, and local artifact path are otherwise documented (`AGENTS.md`, Dataset Metadata Requirements).

**Information to inject before final drafting**: recount these figures at version-freeze time (they reflect the state inspected on 2026-08-04, and the pipeline was still adding fiches on 2026-07-29). Run a documented, dated `run_eval.py --all` pass to cite an aggregate Tier 2 mean score instead of a manually inspected sample.

---

## 9. Data records

To be completed at freeze time. Should describe:

- fiches under `wiki/datasets/fiches_datasets/` (91, Bloc 1-6 format);
- raw R documentation pages under `wiki/datasets/r_package_docs/<package>/topics/` (931, help-page level, not curated fiches — the paper must be explicit that these are a different, less-curated layer);
- local `sf`/RDS artifacts under `data/final_datasets/sf/`;
- exported JSON metadata under `packages/spatialtidymodels/inst/metadata/`.

**Information to inject before final drafting**: an exact, deduplicated count and file-size/format table — no flat export of the 91 fiches currently exists; one should be produced before this section is finalized (see §13.5).

---

## 10. Technical validation

To be completed. Should report, using the same style as §8: CRS resolution status, N/T structural consistency checks, and cross-checks between Bloc 4 (data typology) and the actual `sf` geometry type (at least one known discrepancy was observed in manual review - `R_spData_nz_nz` declares `Type de geometrie: POINT` while the dataset description states "Polygons representing the 16 regions"; such contradictions should be systematically swept, not just spot-checked, before this section is written).

---

## 11. Reuse potential

This layer is designed to be reused in at least three ways: (1) directly, by loading a documented `sf`/RDS artifact and its fiche to obtain response/covariate roles without re-deriving them from raw column names; (2) through `spatialtidymodels`, for automated multi-estimator benchmarking once a dataset is registered and its `formula_used` is stable; (3) as a template - the Bloc 1-6 schema, the three-tier formula-candidate structure, and the `estimator_eligibility` block are reusable patterns intended to be applied unchanged to the two remaining planned source layers (paper-linked datasets, institutional/warehouse portals), so that the eventual multi-layer data bank stays internally consistent rather than accumulating ad hoc formats per source family.

Researchers outside this project can reuse the collection for: benchmarking new spatial estimators against an already-annotated set of response/covariate roles; teaching, since several datasets (Columbus crime, Boston housing, Meuse, LondonHP) are canonical textbook examples now carrying explicit typology and CRS metadata; and methodological work on spatial cross-validation design, since the fiches already flag which datasets have resolved CRS and temporal structure versus which remain uncertain.

---

## 12. Limitations to state honestly

- Dataset DOI is structurally absent for 100% of fiches (91/91) - normal for package-derived data, but must be stated explicitly, not minimized.
- Only 13/91 canonical formulas (`formula_used`) are backed by a verified publication; 53/91 are system-generated and not yet manually validated.
- CRS unresolved for 52/91 fiches.
- `quality_pedigree` is not yet systematically populated - the NUSAP-inspired quality-control layer exists as a schema but is not yet applied everywhere.
- No fiche is yet marked `review_status: reviewed` - the entire corpus remains pending human validation under the Delta-1 rule.
- Gap between documented fiches (91) and datasets actually embedded in `spatialtidymodels` (7) - the package is not yet the systematic consumer of the full corpus.
- `spatialtidymodels` itself is a prototype under development, not a released, exhaustively tested package (several estimators are self-flagged "to watch" in its own status page).
- The `multivariate_constrained` and `ml_or_selected` formula roles remain `unavailable`/`pending` on almost all fiches reviewed - only `univariate` is meaningfully populated at present.
- The 91 Bloc 1-6 fiches are a small fraction of the 931 raw R package documentation pages under `wiki/datasets/r_package_docs/` - the paper must be explicit about what is a curated fiche versus an unretouched raw help page.

---

## 13. Information still needed before final drafting

1. A clean, deduplicated list of source packages actually covered by the 91 fiches (a proper extraction script is needed; an ad hoc shell pattern produced an imperfect list during this drafting session).
2. A re-run of `run_eval.py --all`, documented and dated, to cite an aggregate Tier 2 mean score instead of a manually reviewed sample.
3. A scope decision: does this data paper cover only the 91 Bloc 1-6 fiches, or also the older-format pages under `wiki/datasets/r_package_docs/{spdep,spData,...}/topics/`, which appear to be a different (raw help-page) format, not Bloc 1-6?
4. Per-package license redistribution audit - Bloc 6 partially covers license fields, but they have not been audited for deposit/redistribution compatibility.
5. A flat (CSV/table) export of the 91 fiches to actually produce the tables and figures listed below - does not currently exist and needs to be built.
6. Target journal choice (Scientific Data, Data in Brief, GigaScience, ...) to fix exact required section names (some journals mandate literal headings such as "Data Records" / "Technical Validation").
7. Confirmation with the supervisor on whether the paper should name the 26 estimators and 4 CV schemes explicitly, given the package is still evolving (risk of the published text drifting from the code). Recommendation: freeze and cite a tagged package/registry version.

---

## 14. Tables to produce

| # | Table | Key columns | Data source |
|---|---|---|---|
| T1 | Dataset inventory | dataset_id, source package, theme, N observations, geometry, CRS, response variable (Y), `formula_used`, formula status, eligible estimators, recommended CV schemes, metadata completeness | aggregation of the 91 Bloc 1-6 fiches |
| T2 | Source packages | package, language, number of datasets provided, license, URL | Bloc 2 of each fiche |
| T3 | Formula status by role | `univariate` / `multivariate_constrained` / `ml_or_selected` x status (`confirmed` / `pending` / `unavailable`) | `formula_candidates` block |
| T4 | Dataset x eligible-estimator matrix | 0/1, or `basis` (scientific_evidence / benchmark_use) | `estimator_eligibility` block |
| T5 | Estimator registry | estimator, backend package, requires_coords, requires_W, tunable hyperparameters, maturity status | `estimators.json` + package status page |
| T6 | Aggregated Tier 1/2/3 results | mean score, % PASS/AMBER/REJECTED, recurring reasons | `run_eval.py --all` (to be re-run) |
| T7 | CRS/DOI/formula completeness | as in the §8 table, full version (91 rows or aggregated) | counts over fiches |
| T8 | Cross-validation schemes | name, description, recommended use case | 2026-07-29 benchmark brief |

## 15. Figures to produce

| # | Figure | Content |
|---|---|---|
| F1 | End-to-end pipeline | `raw source -> export_sf_metadata.R -> generate_fiches.py -> enrich_web.py -> Bloc 1-6 fiche -> sf/RDS -> JSON metadata -> spatialtidymodels` (flowchart; base version already exists in [[spatialtidymodels_package_status_2026-07]]) |
| F2 | Source-package map/diagram | R vs Python packages, grouped by family (spatial econometrics, geostatistics, panels, ecology, ...) |
| F3 | Dataset size distribution | histogram of N (observations) across the 91 fiches |
| F4 | Spatial/temporal typology | breakdown of point/polygon/raster x cross-section/panel |
| F5 | Dataset x eligible-estimator matrix | heatmap, scientific_evidence vs benchmark_use in two shades |
| F6 | Benchmark schema | `dataset x estimator x cv_scheme x fold x metric`, adapted from the 2026-07-29 brief |
| F7 | Metadata completeness diagram | stacked bars per field (DOI, CRS, formula) showing published / system-generated / pending evidence |

**Information to inject**: for F1 and F6, mermaid diagrams already exist in [[spatialtidymodels_package_status_2026-07]] and [[benchmark_selection_dashboard_supervisor_note_2026-07]] - adapt, do not reinvent. For F3/F4/F7, a flat table extraction from the 91 fiches must be built first (no such aggregator script currently exists - to be verified before writing one).

---

## Related Pages

- [[software_datasets_datapaper_draft_2026_07]]
- [[catalog_registry_schema_v3]]
- [[quality_pedigree_schema_v1]]
- [[spatialtidymodels_package_status_2026-07]]
- [[benchmark_selection_dashboard_supervisor_note_2026-07]]
- [[eval_queue]]
