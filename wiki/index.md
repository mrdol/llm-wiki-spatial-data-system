---
title: Wiki Index
type: metadata
created: 2026-04-07
updated: 2026-06-24
sources: []
tags: [index, wiki, catalog]
---

# Wiki Index

Master catalog of all pages. The LLM reads this first when answering queries to find relevant pages. Updated on every ingest.

---

## How to Read This Index

Each entry follows this format:
```
- `filename` - one-line summary | type | last updated
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

- [[islr2_statistical_learning]] - Official statistical learning textbook used as a general modeling reference for resampling, SVMs, tree methods, and neural networks | source | 2026-04-23

---

## Datasets

*One entry per dataset identified.*
*Storage convention: dataset fiches are grouped by warehouse under `wiki/datasets/<warehouse>/`.*

- [[zenodo_18421412_mountain_fire]] - Zenodo candidate dataset on climate-fire relationships across global mountain systems | dataset | 2026-05-06
- [[zenodo_5534232_linear_pottery_harris]] - Zenodo supplementary graph and table files for Linear Pottery and Harris Figure 8 | dataset | 2026-05-06
- [[zenodo_14499026_cranial_modifications_americas]] - Zenodo analytical dataset and R code for spatial-temporal cranial modification patterns in the Americas | dataset | 2026-05-06
- [[zenodo_10476054_stehme_holsea_norway]] - Zenodo STEHME/HOLSEA NetCDF files for Norway sea-level dynamics | dataset | 2026-05-06
- [[zenodo_15501267_imf_by_paper]] - Zenodo NetCDF simulation dataset linked to IMF By thermosphere paper | dataset | 2026-05-06
- [[dryad_v41ns1rvb_forest_loss_cordillera]] - Dryad forest-loss dataset for spatio-temporal analysis in the Cordillera Administrative Region, Philippines | dataset | 2026-05-07
- [[dryad_bk3j9kdfk_benthic_trophic_networks]] - Dryad trophic-network monitoring dataset with spatial and temporal Baltic/Skagerrak comparisons | dataset | 2026-05-07
- [[dryad_8w9ghx3jj_citizen_science_habitat_suitability]] - Dryad citizen-science and systematic-protocol dataset for spatial habitat suitability modelling in Sweden | dataset | 2026-05-07
- [[zenodo_15530852_mexico_municipalities_expenditure]] - Panel équilibré de 860 municipalités mexicaines (2000-2021) pour l'étude des spillovers de dépenses publiques — SAR/SDM | dataset | 2026-05-06
- [[zenodo_15627695_mexico_property_tax_spillovers]] - Panel non balancé de municipalités mexicaines (2001-2019) avec taxe foncière et retards spatiaux pour modèles spatiaux dynamiques | dataset | 2026-05-06
- [[zenodo_15781610_poland_ekc_nuts]] - Données régionales polonaises NUTS2/NUTS3 + GeoJSON pour la courbe de Kuznets environnementale | dataset | 2026-05-06
- [[zenodo_3998463_ipcc_atlas_regions]] - IPCC/ATLAS reference-region polygons and monthly regional climate aggregates found through an ESSD data paper | dataset | 2026-05-11

---

## Papers

*One entry per documented paper; architecture pages may appear before the first paper record exists.*

- [[papers_directory_conventions]] - Directory and traceability conventions for future paper records and paper manifests | metadata | 2026-04-22
- [[iturbide_2020_ipcc_regions]] - ESSD data paper defining IPCC climate reference regions and linking ATLAS GitHub/Zenodo data assets | paper | 2026-05-11
- [[ertur_koch_2007_growth_spatial_externalities]] - JAE paper linking spatial growth econometrics to a ZBW replication archive | paper | 2026-05-12
- [[parent_lesage_2008_knowledge_spillovers]] - JAE paper using Bayesian CAR modeling for European regional patent spillovers with replication archive | paper | 2026-05-12
- [[behrens_ertur_koch_2012_dual_gravity]] - JAE dual-gravity trade paper with spatial econometrics and ZBW replication archive | paper | 2026-05-12
- [[millo_2015_house_prices_replication]] - JAE R replication of the Holly-Pesaran-Yamagata US house-price spatio-temporal model | paper | 2026-05-12
- [[jin_lee_yang_2024_spatial_moments_employment]] - JAE spatial moments paper with US county employment-growth replication archive | paper | 2026-05-12
- [[fotheringham_yang_kang_2017_mgwr]] - Canonical MGWR paper with formulas, simulations and Irish famine empirical application | paper | 2026-06-04
- [[wu_ren_hu_du_2018_mgtwr]] - MGTWR paper using Shenzhen housing prices, spatio-temporal bandwidths and benchmark comparisons | paper | 2026-06-04
- [[que_ma_ma_chen_2020_stwr]] - STWR paper with spatio-temporal kernels, bandwidth optimization, simulations and precipitation-isotope application | paper | 2026-06-04
- [[comber_harris_brunsdon_2023_ggp_gam]] - GGP-GAM paper comparing smooth spatially varying coefficient modeling with MGWR on simulation and Brexit data | paper | 2026-06-04
- [[lessani_li_2024_sgwr]] - SGWR paper combining geographic and attribute-similarity weights with AICc and prediction metrics | paper | 2026-06-04
- [[li_2022_shap_xgboost_spatial_effects]] - XGBoost/SHAP paper comparing machine-learning spatial effects with SLM and MGWR | paper | 2026-06-04
- [[yun_gramig_2021_spatial_panel_crop_yield]] - Spatial panel crop-yield paper comparing econometric weather-response specifications and prediction performance | paper | 2026-06-04
- [[bivand_millo_piras_2021_spatial_econometrics_r]] - Review of R software for spatial econometrics, spatial panel models and package/data examples | paper | 2026-06-04
- [[arribas_bel_patino_duque_2017_living_environment_deprivation]] - Remote-sensing LED paper comparing linear, spatial and machine-learning models | paper | 2026-06-04

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
- [[zenodo]] - Research repository used for DOI-backed dataset discovery and downloads | source: warehouse | 2026-05-06
- [[dryad]] - Research data repository used for DOI-backed dataset discovery and file metadata | source: warehouse | 2026-05-07
- [[zbw_journal_data_archive]] - Journal replication-data archive used for DOI-backed paper-to-dataset routes in economics | source: warehouse | 2026-05-12
- [[earth_system_science_data]] - Scientific data journal route for identifying peer-reviewed dataset records and repositories | source: literature | 2026-05-11
- [[r_software_datasets]] - R packages distributing benchmark spatial and spatio-temporal datasets for estimator testing | source: software | 2026-04-29
- [[python_software_datasets]] - Python packages distributing benchmark spatial and spatio-temporal datasets, including PySAL, geosnap, xarray, and mobility routes | source: software | 2026-04-29

### Source Families

- `wiki/sources/warehouses/` - institutional or research data portals
- `wiki/sources/software/` - software/package/API data sources
- `wiki/sources/literature/` - scientific-paper or journal routes to datasets

---

## Concepts

*One entry per methodological or data concept.*

- variable typology - Classification of candidate Y and X variables by modeling role and value type | concept | 2026-04-29
- modeling evidence - Evidence that a paper, codebase, README, or metadata source already defines a model formulation | concept | 2026-04-29
- candidate dataset - Dataset discovered by the system but not yet validated as a final modeling dataset | concept | 2026-04-29
- spatiotemporal data - Data indexed by both space and time | concept | 2026-04-29
- spatial panel - Spatial units observed repeatedly over time | concept | 2026-04-29
- [[spatial_autocorrelation]] - Dependence pattern where nearby or connected spatial units tend to have related values | concept | 2026-04-29
- [[spatial_heterogeneity]] - Variation in relationships, distributions, or parameters across space | concept | 2026-04-29
- [[data_leakage]] - Validation failure where train data indirectly uses validation or test information | concept | 2026-04-29
- [[gwr]] - Local geographically weighted regression with bandwidth, kernel weights, and local coefficients | concept | 2026-06-04
- [[mgwr]] - Multiscale GWR concept where coefficients can operate at different spatial bandwidths | concept | 2026-06-04
- [[mgtwr]] - Multiscale GTWR concept with covariate-specific spatial and temporal bandwidths | concept | 2026-06-04
- [[stwr]] - Spatiotemporal weighted regression with space-time local kernels and bandwidth/decay controls | concept | 2026-06-04
- [[sgwr]] - GWR extension combining geographic proximity and attribute similarity weights | concept | 2026-06-04
- [[geographical_gaussian_process_gam]] - GAM/Gaussian-process route for spatially varying coefficient modeling | concept | 2026-06-04
- [[shap_spatial_effects]] - Local explanation route for comparing machine-learning spatial effects with spatial models | concept | 2026-06-04
- [[spatial_regression]] - Umbrella concept for spatial dependence, heterogeneity, random effects, and feature-based baselines | concept | 2026-06-04
- [[gradient_boosted_trees]] - Concept bridge for XGBoost and LightGBM tabular baselines | concept | 2026-06-04
- [[generalized_additive_models]] - Concept bridge for GAM smooth additive models and spatial trend baselines | concept | 2026-06-04
- [[support_vector_machines]] - Concept bridge for SVM and SVR kernel/margin models | concept | 2026-06-04
- [[latent_gaussian_models]] - Concept bridge for INLA, GMRF and SPDE latent spatial models | concept | 2026-06-04
- [[sequence_models]] - Concept bridge for RNN/LSTM sequence models and leakage-safe temporal windows | concept | 2026-06-04
- [[adaptive_regression_splines]] - Concept bridge for MARS/earth hinge-function models | concept | 2026-06-04

---

## Metadata

*Metadata schemas, rules, templates, and conventions. Enriched metadata profiles for confirmed datasets belong under `wiki/analyses/metadata/`.*

- [[dataset_catalog_schema_v2]] - Schema redesign for the local dataset catalog with warehouse roles, discovery layers, and methodological selection | metadata | 2026-04-21
- [[catalog_registry_schema_v3]] - Registry schema adding paper records, license metadata, DOI traceability, and estimator-policy integration | metadata | 2026-04-22
- [[discovery_policy_v3]] - Discovery policy for spatial, metadata-rich, license-aware, and paper-linked ranking | metadata | 2026-04-22
- [[restricted_estimator_policy_v1]] - Strict project allowlist for estimators used in catalog records and discovery | metadata | 2026-04-22
- [[estimator_fiche_schema_v1]] - Schema for caret-like estimator fiches, paper evidence, and tuning-relevant hyperparameters | metadata | 2026-04-23
- [[r_estimator_implementation_policy_v1]] - R-first implementation policy for allowed estimators, with reticulate as the Python fallback route | metadata | 2026-04-30
- [[r_python_scraping_bridge_policy_v1]] - Policy for calling existing Python scraping scripts from R without rewriting every scraper | metadata | 2026-04-30
- [[quality_pedigree_schema_v1]] - Human-LLM quality control matrix with score evidence, Delta1 risk, and review status | metadata | 2026-05-05
- [[feature_selection_block_template]] - Reusable block for documenting X candidates and X selected for estimation | metadata | 2026-05-12
- [[cross_language_software_dataset_access]] - Convention for software datasets available in both R and Python, with both local access routes preserved | metadata | 2026-05-12

---

## Estimators

*Reference fiches for statistical and machine learning models. Estimation results belong under `wiki/analyses/modeling/estimations/`.*

- [[xgboost]] - Regularized gradient-boosted tree baseline with paper-supported objective and tuning fields | estimator | 2026-06-04
- [[lightgbm]] - Efficient gradient boosting decision tree baseline with leaf-wise complexity controls | estimator | 2026-06-04
- [[gam]] - Generalized additive model baseline with smooth effects, spatial smooth option, and mgcv route | estimator | 2026-06-04
- [[gamboost]] - GAMBoost fiche enriched from PDF formulas and model-based boosting references | estimator | 2026-06-04
- [[random_forest]] - Random Forest baseline with Breiman reference, OOB diagnostics, and blocked-validation cautions | estimator | 2026-06-04
- [[mars]] - MARS adaptive regression spline baseline with hinge functions, pruning, and interaction controls | estimator | 2026-06-04
- [[inla]] - INLA fiche for latent Gaussian, GMRF, SPDE and spatial Bayesian modeling | estimator | 2026-06-04
- [[stvc]] - STVC estimator fiche template for spatio-temporally varying coefficient modeling | estimator | 2026-04-23
- [[svc]] - Spatially varying coefficient fiche with smoothing, regularization and coefficient-map diagnostics | estimator | 2026-06-04
- [[mgwr]] - Multiscale geographically weighted regression fiche with reference papers, bandwidth search, TDS variants, and validation notes | estimator | 2026-06-04
- [[mgwrsar]] - GWR/MGWR-SAR fiche with model variants, spatial weights, kernels, bandwidth search, prediction controls, and diagnostics | estimator | 2026-04-30
- [[spboost]] - Nonlinear spatial autoregressive boosting fiche with local package API, SAR/SEM/SARAR methods, CFE rules, and manual R workflow | estimator | 2026-05-05
- [[rnn]] - RNN/LSTM sequence estimator fiche for leakage-safe temporal or event windows | estimator | 2026-06-04
- [[svm]] - Support vector machine fiche for margin-based classification and regression with fold-local scaling | estimator | 2026-06-04

---

## Analyses

*Synthesized outputs, discovery notes, enriched metadata profiles, and modeling pipeline results.*

### Analysis Subfolders

- `wiki/analyses/metadata/` - enriched metadata profiles for confirmed or validated datasets
- `wiki/analyses/discovery/` - dataset, paper, source discovery outputs, candidate catalogues, and priority lists
- `wiki/analyses/modeling/estimations/` - fitted model summaries and estimator comparisons
- `wiki/analyses/modeling/predictions/` - prediction outputs and forecast diagnostics
- `wiki/analyses/modeling/cross_validation/` - validation protocols, folds, leakage checks, and results

- [[software_r_priority_datasets_metadata]] - Discovery catalogue for priority R software dataset candidates with Y/X, temporal status, and download paths | analysis | 2026-05-12
- [[software_python_priority_datasets_metadata]] - Discovery catalogue for priority Python software dataset candidates with Y/X, temporal status, and exported CSV/GeoJSON paths | analysis | 2026-05-12
- [[software_sf_catalog_audit_2026_06_23]] - Synthèse du catalogue spatial R/Python, de la reclassification Python, des objets sf, de l'audit CRS et temporel, du KG et du benchmark pol_pres15 | analysis | 2026-06-24
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
- [[r_estimator_backend_audit_2026_04_30]] - Audit of R-native, R-variant, reticulate, and pending backend routes for allowed estimators | analysis | 2026-04-30
- [[paper_linked_dataset_scraping_2026_05_11]] - OpenAlex/Copernicus discovery note for the paper-linked IPCC ATLAS dataset candidate | analysis | 2026-05-11
- [[open_access_publication_dataset_methods_scraping_2026_05_12]] - Open-access publication scraping batch with dataset links and method extraction | analysis | 2026-05-12
- [[spatial_econometrics_paper_dataset_scrape_2026_05_12]] - User-provided spatial econometrics paper scrape with confirmed and review paper-dataset routes | analysis | 2026-05-12
- [[zenodo_3998463_ipcc_atlas_regions_enriched_metadata_draft]] - Draft enriched metadata profile for the IPCC ATLAS regions dataset built from existing dataset and paper fiches | analysis | 2026-05-13

---

## Index Maintenance Notes

- Add new pages immediately after creation
- Update the "last updated" date when a page changes substantially
- Mark orphan pages with `orphan`
- Prefer linking pages together
