# Wiki Index

Master catalog of all pages. The LLM reads this first when answering queries to find relevant pages. Updated on every ingest.

---

## How to Read This Index

Each entry follows this format:
```
- [[filename]] - one-line summary | type | last updated
```

---

## Core Files

| Page | Summary | Updated |
|---|---|---|
| [[overview]] | High-level synthesis of the entire knowledge base | 2026-04-22 |
| [[glossary]] | Terminology and definitions | 2026-04-21 |

---

## Ingested Documents

*One entry per raw document ingested.*

- [[pagoulatos1975_two_way_trade]] - Econometric study of two-way trade determinants and metadata-relevant measurement issues | source | 2026-04-21
- [[islr2_statistical_learning]] - Official statistical learning textbook used as a general modeling reference for resampling, SVMs, tree methods, and neural networks | source | 2026-04-23

---

## Datasets

*One entry per dataset identified.*

- [[un_comtrade_merchandise_trade]] - Global official goods trade flows by reporter, partner, product, and time | dataset | 2026-04-22
- [[oecd_itcs]] - OECD commodity trade panel with annual country-partner-product structure and commodity classifications | dataset | 2026-04-22
- [[eurostat_comext_itg]] - EU trade-in-goods warehouse with strong country-partner-product-time metadata and multiple nomenclatures | dataset | 2026-04-22
- [[cepii_baci]] - Harmonized bilateral HS6 trade database with reconciled exporter-importer flows and yearly product metadata | dataset | 2026-04-22
- [[insee_emploi_chomage_population_active]] - France-focused candidate covering unemployment, diploma-based breakdowns, and territorial labour-market analysis | dataset | 2026-04-21
- [[eurostat_labour_force_survey]] - Harmonized European candidate covering unemployment, education-related labour outcomes, and regional comparison including France | dataset | 2026-04-21
- [[insee_base_permanente_equipements]] - France equipment inventory with commune, IRIS, and coordinate-level annual territorial metadata | dataset | 2026-04-22
- [[data_gouv_dvf_geolocalisees]] - Geolocated French property transactions with parcel, commune, and coordinate fields in repeated time slices | dataset | 2026-04-22
- [[world_bank_world_development_indicators]] - Global country-time indicator warehouse with rich indicator, geography, and topic metadata | dataset | 2026-04-22

---

## Papers

*One entry per documented paper; architecture pages may appear before the first paper record exists.*

- [[papers_directory_conventions]] - Directory and traceability conventions for future paper records and paper manifests | metadata | 2026-04-22

---

## Variables

*One entry per key variable.*

*(Empty - will populate via ingest.)*

---

## Sources

*One entry per data source, grouped in `wiki/sources/` by source family.*

- [[insee]] - French national statistical warehouse for official economic and labour-market data | source: warehouse | 2026-04-22
- [[eurostat]] - European statistical warehouse for harmonized cross-country datasets and indicators | source: warehouse | 2026-04-22
- [[data_gouv]] - French open-data warehouse with reusable administrative and territorial datasets | source: warehouse | 2026-04-22
- [[oecd]] - OECD dissemination warehouse for internationally comparable economic and social statistics | source: warehouse | 2026-04-22
- [[world_bank]] - World Bank warehouse and API ecosystem for global country-level indicators and metadata | source: warehouse | 2026-04-22
- [[un_comtrade]] - UNSD trade warehouse and explorer for official merchandise trade records and classifications | source: warehouse | 2026-04-22
- [[cepii]] - CEPII research data portal distributing derived international trade databases and documentation | source: warehouse | 2026-04-22
- [[r_software_datasets]] - R packages distributing benchmark spatial and spatio-temporal datasets for estimator testing | source: software | 2026-04-29
- [[python_software_datasets]] - Python packages distributing benchmark spatial and spatio-temporal datasets, including PySAL, geosnap, xarray, and mobility routes | source: software | 2026-04-29

### Source Families

- `wiki/sources/warehouses/` - institutional or research data portals
- `wiki/sources/software/` - software/package/API data sources
- `wiki/sources/literature/` - scientific-paper or journal routes to datasets

---

## Concepts

*One entry per methodological or data concept.*

- [[variable_typology]] - Classification of candidate Y and X variables by modeling role and value type | concept | 2026-04-29
- [[modeling_evidence]] - Evidence that a paper, codebase, README, or metadata source already defines a model formulation | concept | 2026-04-29
- [[candidate_dataset]] - Dataset discovered by the system but not yet validated as a final modeling dataset | concept | 2026-04-29
- [[spatiotemporal_data]] - Data indexed by both space and time | concept | 2026-04-29
- [[spatial_panel]] - Spatial units observed repeatedly over time | concept | 2026-04-29
- [[spatial_autocorrelation]] - Dependence pattern where nearby or connected spatial units tend to have related values | concept | 2026-04-29
- [[spatial_heterogeneity]] - Variation in relationships, distributions, or parameters across space | concept | 2026-04-29
- [[data_leakage]] - Validation failure where train data indirectly uses validation or test information | concept | 2026-04-29

---

## Metadata

*Metadata schemas, rules, and conventions. Progressive metadata profiles from data inspection belong under `wiki/analyses/metadata/`.*

- [[dataset_catalog_schema_v2]] - Schema redesign for the local dataset catalog with warehouse roles, discovery layers, and methodological selection | metadata | 2026-04-21
- [[catalog_registry_schema_v3]] - Registry schema adding paper records, license metadata, DOI traceability, and estimator-policy integration | metadata | 2026-04-22
- [[discovery_policy_v3]] - Discovery policy for spatial, metadata-rich, license-aware, and paper-linked ranking | metadata | 2026-04-22
- [[restricted_estimator_policy_v1]] - Strict project allowlist for estimators used in catalog records and discovery | metadata | 2026-04-22
- [[estimator_fiche_schema_v1]] - Schema for caret-like estimator fiches, paper evidence, and tuning-relevant hyperparameters | metadata | 2026-04-23

---

## Estimators

*Reference fiches for statistical and machine learning models. Estimation results belong under `wiki/analyses/modeling/estimations/`.*

- [[grubel_lloyd_index]] - Bounded indicator of intra-industry trade intensity based on exports and imports | estimator | 2026-04-21
- [[xgboost]] - Gradient-boosted tree estimator fiche template for later paper-supported tuning documentation | estimator | 2026-04-23
- [[lightgbm]] - LightGBM estimator fiche template for later paper-supported tuning documentation | estimator | 2026-04-23
- [[gamboost]] - GAMBoost estimator fiche template for boosted additive modeling | estimator | 2026-04-23
- [[random_forest]] - Random Forest estimator fiche template for ensemble tree baselines | estimator | 2026-04-23
- [[mars]] - MARS estimator fiche template for multivariate adaptive regression splines | estimator | 2026-04-23
- [[inla]] - INLA estimator fiche template for latent Gaussian and spatial Bayesian modeling | estimator | 2026-04-23
- [[stvc]] - STVC estimator fiche template for spatio-temporally varying coefficient modeling | estimator | 2026-04-23
- [[svc]] - SVC estimator fiche template for spatially varying coefficient modeling | estimator | 2026-04-23
- [[mgwr]] - MGWR estimator fiche template for multiscale geographically weighted regression | estimator | 2026-04-23
- [[mgwrsar]] - MGWRSAR estimator fiche template for multiscale geographically weighted regression with spatial autoregressive structure | estimator | 2026-04-23
- [[spboost]] - SpBoost estimator fiche template for spatial boosting | estimator | 2026-04-23
- [[rnn]] - Recurrent neural network estimator fiche for ordered temporal or sequence prediction tasks | estimator | 2026-04-29
- [[svm]] - Support vector machine estimator fiche for margin-based classification and regression | estimator | 2026-04-29

---

## Analyses

*Synthesized outputs, discovery notes, progressive metadata profiles, and modeling pipeline results.*

### Analysis Subfolders

- `wiki/analyses/metadata/` - metadata profiles built from raw metadata, dataset descriptions, and later data inspection
- `wiki/analyses/discovery/` - dataset, paper, and source discovery outputs
- `wiki/analyses/modeling/estimations/` - fitted model summaries and estimator comparisons
- `wiki/analyses/modeling/predictions/` - prediction outputs and forecast diagnostics
- `wiki/analyses/modeling/cross_validation/` - validation protocols, folds, leakage checks, and results

- [[pagoulatos1975_methodology_to_metadata]] - Translation of econometric methodology into metadata design requirements | analysis | 2026-04-21
- [[feature_selection_block_template]] - Generic block for documenting X candidates and X selected for estimation | analysis | 2026-04-29
- [[software_r_priority_datasets_metadata]] - Consolidated metadata fiche for priority R software datasets with Y/X, temporal status, and download paths | analysis | 2026-04-29
- [[software_python_priority_datasets_metadata]] - Consolidated metadata fiche for priority Python software datasets with Y/X, temporal status, and exported CSV/GeoJSON paths | analysis | 2026-04-29
- [[cross_language_software_dataset_access]] - Conceptual mapping for software datasets available in both R and Python, with both local access routes preserved | analysis | 2026-04-29
- [[france_unemployment_datasets_comparison]] - Short note comparing INSEE and Eurostat options for unemployment work on France | analysis | 2026-04-21
- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]] - Cross-warehouse note on datasets with strong spatial, temporal, and classificatory metadata structure | analysis | 2026-04-22
- [[dataset_ranking_metadata_spatial_download_priority_2026_04_22]] - Ranked review of newly documented datasets by metadata richness, spatial utility, and raw-download priority | analysis | 2026-04-22
- [[trade_raw_endpoint_verification_2026_04_22]] - Verification note on remaining raw trade endpoints, with Comext confirmed and UN Comtrade or OECD ITCS still unresolved | analysis | 2026-04-22
- [[rnn_svm_strategy_2026_04_23]] - Historical strategy note clarifying that RNN and SVM are separate allowed estimators | analysis | 2026-04-23
- [[raw_spatiotemporal_dataset_scraping_targets_2026_04_23]] - Candidate raw spatio-temporal datasets with large dimensions, paper links, and scraping routes | analysis | 2026-04-23
- [[download_batch_2026_04_23_datasets10_papers10]] - Traceability note for the 2026-04-23 batch of 10 downloaded datasets and 10 validated PDF papers | analysis | 2026-04-23
- [[book_lookup_statistics_for_high_dimensional_data_2026_04_23]] - Lookup and access-status note for the Springer book Statistics for High-Dimensional Data | analysis | 2026-04-23
- [[scientific_data_linked_papers_2026_04_27]] - Shortlist of 10 scientific papers linked to explicit datasets or reusable data assets | analysis | 2026-04-27
- [[software_dataset_literature_links_2026_04_29]] - OpenAlex candidate links between documented software datasets and journal papers that may use them | analysis | 2026-04-29

---

## Index Maintenance Notes

- Add new pages immediately after creation
- Update the "last updated" date when a page changes substantially
- Mark orphan pages with `orphan`
- Prefer linking pages together

