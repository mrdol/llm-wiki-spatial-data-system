---
title: Data paper draft - Spatial benchmark data bank from packages and research publications (Blocs 1-2)
type: analysis
created: 2026-08-04
updated: 2026-08-10
sources:
  - raw/docs_methodology/Proposition de STAGE 2026.pdf
  - raw/docs_methodology/metadata_construction.pdf
  - raw/docs_methodology/plan_stage_INRAE_2026.md
  - raw/docs_methodology/1_cadrage_preliminaire.md
  - AGENTS.md
  - wiki/metadata/catalog_registry_schema_v3.md
  - wiki/metadata/quality_pedigree_schema_v1.md
  - wiki/metadata/spatialtidymodels_package_status_2026-07.md
  - wiki/metadata/benchmark_selection_dashboard_supervisor_note_2026-07.md
  - wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md
  - wiki/analyses/datacite_verified_ingestion_2026-08.md
  - wiki/analyses/paper_dataset_readiness_audit_2026-08.md
  - wiki/eval_queue.md
  - wiki/analyses/datapapers/software_datasets_datapaper_draft_2026_07.md
  - code/r_catalog/generate_fiches.py
  - packages/spatialtidymodels/inst/metadata/estimators.json
  - packages/spatialtidymodels/inst/metadata/datasets.json
  - wiki/datasets/fiches_datasets (Bloc 1 package and Bloc 2 paper-linked records, dated inventories)
tags: [datapaper, data-bank, package-datasets, paper-datasets, spatial, benchmark, spatialtidymodels, formula-candidates, quality-control, blocs-1-2, draft]
---

# Data paper draft - Spatial benchmark data bank from packages and research publications (Blocs 1-2)

Working title:

> A provenance-aware spatial benchmark data bank from R and Python packages and publication-linked datasets: metadata harmonization, readiness states, and reproducible evaluation with `spatialtidymodels`

Short alternative title:

> A spatial benchmark data bank from packages and research publications

## Relation to the prior draft

A broader, earlier draft exists at [[software_datasets_datapaper_draft_2026_07]] (created 2026-07-20). That draft scoped the software-distributed catalogue and predates the additions to the fiche schema: per-role `formula_candidates` (`univariate` / `multivariate_constrained` / `ml_or_selected`), `estimator_eligibility`, and the readiness-aware benchmark design.

This revised draft covers the first two source layers of the bank. **Bloc 1** is the package-derived layer: 91 full Bloc 1-6 fiches were found by a direct inventory on 2026-08-10. **Bloc 2** is the publication-linked layer: its bibliographic candidates, downloaded raw material, converted artifacts, and benchmark-readiness are intentionally kept as distinct states. A direct inventory on the same date found 31 `paper_*.md` records, while the dated DataCite ingestion report documents 27 bibliographically verified candidates. These numbers are evidence of a work in progress, not interchangeable release counts.

The manuscript is therefore a refined companion to [[software_datasets_datapaper_draft_2026_07]], not a claim that every source candidate is an executable benchmark case. It describes the common metadata and provenance conventions across Blocs 1-2, and reserves a third warehouse/portal layer for a later, separately validated extension.

## Constraints assumed throughout this draft

- No empirical benchmark result is reported or invented; this is a data/resource paper, not a league table of estimators.
- The bank complements, but does not replace, theoretical derivation and Monte Carlo simulation.
- A bibliographically verified paper candidate, downloaded raw data, converted spatial artifact, and `benchmark_ready` record are distinct states and must never be counted as though they were equivalent.
- No DOI is invented. Dataset DOI is structurally `none` for package-derived data where appropriate; publication DOI is reported only when resolved and verbatim-matched.
- Published, manually confirmed, and system-generated formulas remain visibly distinct throughout.
- `spatialtidymodels` is described as a package under active development, not a finished or released tool.
- Reproducibility, provenance, metadata normalization, benchmark readiness, and reuse by other researchers are the paper's central contributions.

---

## Data-bank foundation for the Blocs 1-2 release

The project’s starting objective is to build a reference bank of real spatial and spatio-temporal data that can support reproducible predictive-model validation across heterogeneous domains and spatial structures (`raw/docs_methodology/Proposition de STAGE 2026.pdf`). Its methodological core is an enriched metadata layer that connects each dataset’s observed structure to estimator eligibility, validation choices, tuning needs, and benchmark outputs (`raw/docs_methodology/metadata_construction.pdf`, Sections 1–2).

This manuscript describes a **Blocs 1-2 release architecture**. It combines package-derived dataset objects (Bloc 1) with publication-linked records and artifacts (Bloc 2) under one common documentation model, while retaining their source layer and maturity state. The 91 package fiches and current paper-linked records are documentary and technical inputs; they are not all promoted automatically to the executable benchmark core.

| Bank component | Bloc 1: package-derived | Bloc 2: publication-linked | Claim supported in this paper |
|---|---|---|---|
| Curation unit | Spatial dataset object distributed in an R/Python package | Paper-data candidate, then downloaded/converted artifact when available | A traceable, bounded registry rather than an exhaustive census |
| Common description | Bloc 1-6 fiche with package/object provenance | Same schema, with paper, access, and processing provenance | Comparable descriptions across source routes |
| Evidence chain | Package documentation, code, and linked references | Bibliographic verification, source access, local reading, empirical specification | Evidence is recorded by stage rather than inferred from citation alone |
| Technical assets | Local `sf`/RDS artifacts and exported metadata where available | Raw folders and final artifacts only when they pass the relevant intake stage | Reproducible inspection without conflating candidates and data records |
| Benchmark core | Entries meeting artifact, specification, and quality gates | Only records explicitly marked ready and admitted to package metadata | A small, explicit operational subset, not the full registry |
| Benchmark interface | `spatialtidymodels`, under active development | Same interface once the readiness gates are passed | A consumer and orchestrator, not evidence of readiness by itself |

The bank is designed as a **coverage-oriented experimental resource**, not as an opportunistic accumulation of examples. The original stage plan defines diversity axes for topic, spatial support, temporal structure, response type, dependence structure, and dataset size or complexity (`raw/docs_methodology/plan_stage_INRAE_2026.md`, Phase 0). The two intake routes provide complementary coverage: software packages supply readily inspectable objects, while research publications connect candidate data to an empirical scientific use case.

### Release boundary and submission prerequisites

Before submission, the data paper must point to a frozen, versioned release containing or unambiguously referencing:

1. a manifest of all Blocs 1-2 registry entries, with stable identifiers, source layer, freeze date, and maturity state;
2. an explicit **benchmark-core manifest** containing only the entries admitted for automated comparison;
3. the metadata schema and data dictionary, including `formula_pub`, `formula_used`, `formula_candidates`, `estimator_eligibility`, and the Bloc 2 readiness fields;
4. source provenance, access instructions, licenses, and the distinction between dataset DOI and publication DOI;
5. code required to recreate the exports and the `spatialtidymodels` registry; and
6. a persistent archival identifier after deposit, without asserting a DOI before that deposit exists.

This boundary follows the project’s original emphasis on data dictionaries, a methodological guide, standardized storage, and reproducible learning protocols (`raw/docs_methodology/Proposition de STAGE 2026.pdf`; `raw/docs_methodology/plan_stage_INRAE_2026.md`, Phases 3–4). It is also the protection against an overclaim: the paper describes how a reusable data resource is assembled, qualified, and exposed for evaluation; it does not report a definitive empirical performance result.

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

Spatial-regression and spatial-machine-learning evaluation requires more than datasets that happen to contain coordinates: it requires documented response and covariate roles, spatial and temporal support, provenance, and an explicit account of modelling evidence. We present a provenance-aware spatial benchmark data bank covering two complementary intake routes: spatial dataset objects derived from R and Python packages (Bloc 1) and publication-linked dataset records (Bloc 2). Both routes are described through a common six-block metadata structure that captures variable typology; geometry, coordinate-reference-system and temporal information; identification and reproducibility evidence; model typology; and the evidence supporting candidate regression formulas.

The bank is designed to complement theoretical analysis and controlled Monte Carlo experiments by supplying a versioned empirical validation layer. It keeps published, manually confirmed, and system-generated formulae distinct, records estimator eligibility separately from scientific evidence, and assigns readiness states that distinguish a bibliographically verified candidate, raw download, converted spatial artifact, and benchmark-ready record. The resulting benchmark core can be consumed by `spatialtidymodels`, a companion R package under active development, only after explicit artifact, specification, and quality gates are met. The resource supports dataset discovery, transparent preparation of reproducible estimator comparisons, and extension to additional source layers. No universal ranking or empirical performance claim is reported; such results require a separately frozen experimental protocol and are outside this data paper.

*Drafting basis: `raw/docs_methodology/Proposition de STAGE 2026.pdf`; `raw/docs_methodology/metadata_construction.pdf`; `wiki/metadata/catalog_registry_schema_v3.md`; `wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`; `wiki/analyses/datacite_verified_ingestion_2026-08.md`; `wiki/analyses/paper_dataset_readiness_audit_2026-08.md`; `wiki/metadata/spatialtidymodels_package_status_2026-07.md`; and dated direct inventories of `wiki/datasets/fiches_datasets/`.*

---

## 3. Background and motivation

Reproducible comparison of spatial-regression and spatial-machine-learning methods requires a data resource in which the analytical role of each field is explicit. Coordinates and identifiers must not be silently treated as covariates; response variables, explanatory variables, spatial support, temporal structure, coordinate reference system, and modelling evidence must remain distinguishable. Without this context, datasets that are superficially similar may lead to incomparable model specifications, validation designs, or interpretations.

### Why an empirical data bank is needed alongside theory and Monte Carlo

Spatial econometric research uses three complementary forms of evidence. **Theoretical approaches** establish estimands, assumptions, identification conditions, and expected properties of an estimator. **Monte Carlo approaches** study finite-sample behaviour under controlled data-generating processes, where the ground truth is known and the researcher can vary spatial dependence, sample size, noise, and misspecification. **Empirical approaches** evaluate whether methods remain useful, reproducible, and interpretable when applied to heterogeneous real data, for which the ground truth is generally unknown and data preparation, support, scale, missingness, and provenance are substantive parts of the problem.

This bank belongs primarily to the third form of evidence. It does not replace a proof or a simulation study; rather, it gives empirical validation a reusable common substrate. A benchmark based on a frozen, documented collection can test robustness across real spatial contexts without rebuilding each data assembly, variable mapping, formula, and validation choice ad hoc. It also makes negative results interpretable: a failure can be traced to a dataset's support, response type, formula evidence, or readiness status rather than being hidden in an undocumented preprocessing chain.

The wider project was conceived as a reference bank for validation of predictive spatial and spatio-temporal methods across diverse domains and dependency structures (`raw/docs_methodology/Proposition de STAGE 2026.pdf`). Its initial design frames dataset selection as a coverage-oriented experimental plan, structured along thematic domain, spatial support, temporal configuration, response type, dependence structure, and size or complexity, rather than as an opportunistic collection of examples (`raw/docs_methodology/plan_stage_INRAE_2026.md`, Phase 0). Such a bank must make this diversity discoverable while preserving the provenance and limitations of every source record.

The proposed response is an enriched metadata layer. The methodological design specifies a progression from source metadata to enriched metadata, dataset typology, eligible estimators, and then a validation and benchmarking pipeline (`raw/docs_methodology/metadata_construction.pdf`, Sections 1–2). Its six blocks retain the information necessary for that progression: formulas and variable roles; identification and DOI traceability; model typology; data typology including the N/T profile; resolution and extent; and reproducibility. This design makes the bank more than a catalogue: it provides a controlled bridge between heterogeneous source data and reproducible methodological use.

Bloc 1 contributes package-derived spatial objects, whose documentation and code make structural inspection comparatively direct. Bloc 2 contributes publication-linked candidates, which add an explicit relation to a real empirical study but require a stricter chain of bibliographic, access, local-reading, specification, preprocessing, and readiness checks. Their integration is deliberately asymmetric: a cited paper is not transformed into a benchmark case merely because it mentions data.

`spatialtidymodels` is the prospective operational interface between the bank and reproducible comparative evaluation. It should consume only the explicit benchmark core and carry the chosen formula, estimator family, spatial resampling design, and output schema through a run. The data paper therefore explains the conditions that make that use possible; it does not treat the package as a proof of estimator performance. A later benchmark or methods paper may report results from a pre-registered or otherwise frozen dataset × estimator × validation protocol.

By making variable roles, formula provenance, spatial metadata, reproducibility information, source layer, and uncertainty inspectable at record level, the Blocs 1-2 release supports transparent dataset discovery; defensible preparation of empirical benchmark specifications; and extension of the same conventions to later warehouse-derived records. Consistent with the data-paper rationale established in the initial project framing, the manuscript documents how the resource was structured and can be reused, rather than testing a new substantive hypothesis (`raw/docs_methodology/1_cadrage_preliminaire.md`, Section 3).

*Drafting basis: `raw/docs_methodology/Proposition de STAGE 2026.pdf`; `raw/docs_methodology/metadata_construction.pdf`; `raw/docs_methodology/plan_stage_INRAE_2026.md`; `raw/docs_methodology/1_cadrage_preliminaire.md`; `wiki/metadata/catalog_registry_schema_v3.md`; `wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`; and `wiki/analyses/paper_dataset_readiness_audit_2026-08.md`.*

---

## 4. Source scope and inclusion criteria

### Scope of the Blocs 1-2 release

The Blocs 1-2 release covers two source layers curated as spatial dataset records in this project. Its unit of inclusion is a traceable **dataset record**, not a package as a whole, a help page, or a paper citation alone. Bloc 1 covers package-distributed objects for which a usable spatial artifact can be inspected and documented. Bloc 2 covers paper-linked records that remain labelled by their documented maturity state. The intended analytical scope includes spatial regression, spatial econometrics, geostatistics, spatial machine learning, and related applied domains; it includes cross-sectional spatial data and records with a temporal dimension, but does not assume that every entry is a spatio-temporal panel.

The 2026-08-10 direct inventory found 91 full Bloc 1-6 package fiches and 31 `paper_*.md` records. The latter must not be collapsed into one release count: the separate DataCite ingestion report identifies 27 bibliographically verified candidates, while the readiness audit uses its own dated snapshots for downloaded, converted, and ready states. Final counts belong in the frozen release manifest, not in an unfixed draft.

### Bloc 1: package-derived admission route

A candidate enters the Bloc 1 curation route only when all of the following conditions hold:

1. **Package provenance.** The object originates from an R or Python package and retains package, dataset-object, and source-language provenance.
2. **Usable local spatial artifact.** The project’s `index_sf` catalogue marks the candidate as usable and provides an `sf_path`; the export process must be able to read the artifact and confirm that it inherits from `sf` (`code/r_catalog/export_sf_metadata.R`, lines 338–359).
3. **Inspectable spatial structure.** Geometry, CRS, bounding box, non-geometry variables, and structural candidates for coordinates, identifiers, and time can be extracted from the object. This is an inspection condition, not a claim that every field is already resolved.
4. **Deduplication treatment.** Exact duplicates are reduced using structural fingerprints; suspected versions with the same normalized dataset name but different structure are retained as review cases rather than silently merged (`code/r_catalog/export_sf_metadata.R`, deduplication stages).
5. **Full documentation record.** The object has a generated and retained Bloc 1-6 fiche. The fiche records evidence, pending fields, and quality status; it does not automatically establish benchmark readiness.

### Bloc 2: publication-linked admission and readiness route

A Bloc 2 record can enter the **registry** when a paper-data relationship and an access route have been documented. This admission establishes a traceable candidate, not an empirical benchmark. Promotion through the pipeline requires distinct evidence that: (1) the paper genuinely uses empirical data; (2) the dataset is spatial for the intended task; (3) a download source works; (4) the data are readable locally; (5) response/covariate roles or the empirical specification can be identified; (6) preprocessing is documented; and (7) a final benchmarkable version exists (`wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`, validation chain).

Only entries explicitly marked as ready and admitted to package metadata may join the automatic `spatialtidymodels` benchmark core. Bibliographic validation, raw download, conversion to `sf`, and an apparently plausible formula are necessary intermediate evidence in some cases, but none is a substitute for this final decision. The readiness audit explicitly warns against treating DataCite/OpenAlex validation as benchmark validation (`wiki/analyses/paper_dataset_readiness_audit_2026-08.md`).

### Exclusions and boundaries

The following materials are outside the automatic benchmark core, even where they remain useful registry records:

- raw package documentation pages that have not reached full Bloc 1-6 curation;
- package objects without a usable local spatial artifact, valid `sf_path`, or readable spatial structure at the time of export;
- paper citations or downloaded materials without documented spatial data, local readability, a defensible empirical specification, and an explicit readiness decision;
- prediction products, derived outputs, task-mismatched records, and cases requiring a dedicated estimator or spatial-weights route; and
- duplicate artifacts superseded by an exact structural match, while suspected-version cases remain explicit review items.

Accordingly, this manuscript describes a **curated, maturity-aware data-bank registry plus an explicitly bounded benchmark core**. It is neither an exhaustive sample of packages and publications nor a claim that all registered entries are ready for the same estimator, validation protocol, or scientific question.

*Drafting basis: `code/r_catalog/export_sf_metadata.R`; dated direct inventory of `wiki/datasets/fiches_datasets/` on 2026-08-10; `wiki/metadata/catalog_registry_schema_v3.md`; `raw/docs_methodology/metadata_construction.pdf`; `raw/docs_methodology/plan_stage_INRAE_2026.md`; `wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`; `wiki/analyses/datacite_verified_ingestion_2026-08.md`; and `wiki/analyses/paper_dataset_readiness_audit_2026-08.md`.*

---

## 5. Data collection and harmonization

The two intake routes are harmonized at the metadata level but deliberately retain different evidence chains. This prevents the collection from treating a package object and a literature mention as the same kind of observation.

### Bloc 1: package-derived objects

The package route is staged and mostly deterministic before semantic curation:

1. **`export_sf_metadata.R`** extracts structural metadata from candidate package datasets, retains usable `sf` artifacts, applies rule-based variable typology, and identifies structural candidates for coordinates and identifiers without deciding the scientific response variable.
2. **`generate_fiches.py`** creates the Bloc 1-6 documentation record from the system-level variable inventory, including proposed response and covariate roles. These proposals remain evidence-qualified and subject to review.
3. **`enrich_web.py`** enriches licenses, years, DOI/reference information, and formula evidence under a guard that accepts a DOI only when it is syntactically valid and found verbatim in the fetched source. Formula discovery is kept separate from publication discovery.

### Bloc 2: publication-linked records

The publication route is a provenance and readiness pipeline: bibliographic identification and verification; paper/data linkage; access and download attempt; local reading/conversion; extraction of the empirical specification and preprocessing evidence; documentation in the shared schema; and an explicit readiness decision. The project pipeline requires a final benchmarkable version before promotion to the benchmark core (`wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`). A candidate that stops at any earlier state remains a documented registry record with that state preserved.

### Common harmonization rule

Both routes converge on the six-block fiche schema and its distinction between source evidence and project-level benchmarking choices. Variable roles, formula provenance, spatial support, N/T profile, CRS, license, artifact location, and quality status are exposed in a common vocabulary. `estimator_eligibility[].basis` records whether an estimator pairing is directly supported by scientific evidence or is a project-internal benchmark-use decision. This allows the benchmark core to be selected transparently while preventing the underlying registry from being flattened into a false binary of “usable” versus “useless”.

**Information to inject before final drafting**: a frozen pipeline-version table naming the exact scripts, commit/tag, environment files, and input/output manifests used for each source route.

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

Metadata harmonization serves a specific downstream consumer: `spatialtidymodels`, an R package **under active development, not a finished or released tool**. It supports direct single-estimator fitting for diagnosis and an automated multi-estimator route for records registered in its benchmark metadata.

The benchmark core is intentionally narrower than the Blocs 1-2 registry. A package-derived record must have a usable artifact, defensible response/covariate roles and formula, spatial support, and the relevant quality checks. A publication-linked record must additionally complete its paper-data, local-reading, preprocessing, and final-readiness chain. The current package snapshot contains seven embedded package-derived benchmark datasets; no paper-linked record should be described as automatically included solely because it has a fiche, a download, or a converted `sf` artifact.

For a strict estimator comparison, all estimators evaluated on a dataset must use the same frozen `formula_used`, spatial-weights specification where applicable, and resampling folds. Formula-specific pipelines using `multivariate_constrained` or `ml_or_selected` variants are a different experimental object: they compare complete modelling pipelines rather than estimators alone and should not be mixed into one ranking table. `spatialtidymodels` should retain the dataset identifier, source layer, formula evidence, resampling design, estimator version, runtime, predictive metrics, and residual spatial-diagnostic outputs for every run.

Technical validation in this data paper can show that metadata are structurally valid and that representative benchmark-core records pass a reproducible smoke test. A substantive comparison of estimator performance belongs in a companion benchmark or methods article using a frozen dataset × estimator × validation protocol.

**Information to inject before final drafting**: freeze and cite a tagged `spatialtidymodels`/registry version, then list only the estimators and resampling schemes actually available in that version.

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

At release freeze, the paper must describe two related inventories and one operational subset rather than presenting a single undifferentiated dataset count:

- the **Blocs 1-2 registry manifest**, containing all package-derived and publication-linked records with stable identifier, source layer, provenance, and maturity status;
- the **asset manifest**, containing only material actually included or reproducibly retrievable in the release (for example curated fiches, final `sf`/RDS artifacts, and exported JSON metadata); and
- the **benchmark-core manifest**, containing the subset explicitly admitted to automated `spatialtidymodels` comparison.

The dated working inventory currently contains 91 full package fiches and 31 paper-linked fiches. It must also disclose that the separate DataCite report identifies 27 bibliographically verified Bloc 2 candidates, because candidate count is not asset count. Before submission, a machine-readable table must report exact deduplicated counts, formats, file sizes, licences or access restrictions, and the status transitions for all Bloc 2 records.

---

## 10. Technical validation
To be completed. Should report, using the same style as §8: CRS resolution status, N/T structural consistency checks, and cross-checks between Bloc 4 (data typology) and the actual `sf` geometry type (at least one known discrepancy was observed in manual review - `R_spData_nz_nz` declares `Type de geometrie: POINT` while the dataset description states "Polygons representing the 16 regions"; such contradictions should be systematically swept, not just spot-checked, before this section is written).

---

## 11. Reuse potential

The resource is reusable in three linked ways: (1) researchers can discover a documented spatial artifact and inspect its variable roles, support, provenance, and uncertainty; (2) they can construct a transparent empirical benchmark specification from the explicit benchmark core; and (3) they can reuse the common schema to add a package, paper-linked, or later warehouse-derived record without abandoning comparability.

`spatialtidymodels` provides the prospective execution layer for the second use. It can run a frozen dataset × estimator × resampling design while carrying the formula and readiness evidence that motivated inclusion. It must not silently draw from the full registry. This separation supports teaching, validation-protocol research, and the development of new spatial estimators without confusing documentary coverage with automatic model eligibility.

---

## 12. Limitations to state honestly
- Package-derived dataset DOI is frequently structurally absent; this is normal for package examples but must be stated explicitly rather than minimized.
- Only 13/91 canonical formulas (`formula_used`) are backed by a verified publication; 53/91 are system-generated and not yet manually validated.
- CRS unresolved for 52/91 fiches.
- `quality_pedigree` is not yet systematically populated - the NUSAP-inspired quality-control layer exists as a schema but is not yet applied everywhere.
- No fiche is yet marked `review_status: reviewed` - the entire corpus remains pending human validation under the Delta-1 rule.
- Gap between documented fiches (91) and datasets actually embedded in `spatialtidymodels` (7) - the package is not yet the systematic consumer of the full corpus.
- `spatialtidymodels` itself is a prototype under development, not a released, exhaustively tested package (several estimators are self-flagged "to watch" in its own status page).
- The `multivariate_constrained` and `ml_or_selected` formula roles remain `unavailable`/`pending` on almost all fiches reviewed - only `univariate` is meaningfully populated at present.
- Bloc 2 includes candidates at multiple stages of maturity. Bibliographic verification, raw download, conversion to `sf`, and package inclusion must remain separate in all tables and interpretations.
- The 91 Bloc 1-6 fiches are a small fraction of the 931 raw R package documentation pages under `wiki/datasets/r_package_docs/` - the paper must be explicit about what is a curated fiche versus an unretouched raw help page.

---

## 13. Information still needed before final drafting

1. A clean, deduplicated list of source packages actually covered by the 91 fiches (a proper extraction script is needed; an ad hoc shell pattern produced an imperfect list during this drafting session).
2. A re-run of `run_eval.py --all`, documented and dated, to cite an aggregate Tier 2 mean score instead of a manually reviewed sample.
3. A frozen Blocs 1-2 release manifest that separates the registry, retrievable assets, and benchmark core, and reports all Bloc 2 state transitions.
4. Per-package license redistribution audit - Bloc 6 partially covers license fields, but they have not been audited for deposit/redistribution compatibility.
5. A flat (CSV/table) export of the Blocs 1-2 registry and a separate benchmark-core table to produce the tables and figures listed below.
6. Target journal choice (Scientific Data, Data in Brief, GigaScience, ...) to fix exact required section names (some journals mandate literal headings such as "Data Records" / "Technical Validation").
7. Confirmation with the supervisor on whether the paper should name individual estimators and resampling schemes, given the package is still evolving. Recommendation: freeze and cite a tagged package/registry version.

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
