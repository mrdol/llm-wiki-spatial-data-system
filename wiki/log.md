---
title: Wiki Log
type: metadata
created: 2026-04-07
updated: 2026-05-12
sources: []
tags: [log, wiki, chronology]
---

# Wiki Log

Append-only chronological record of all activity: ingests, queries, and lint passes.

## [2026-05-13] estimator | enrich GAMBoost from PDF formula extraction

Files updated:
- `wiki/estimators/gamboost.md`
- `wiki/index.md`

Files moved:
- `wiki/metadata/tier2_5_formula_verification.md` -> `LLM-wiki-Assessment/eval/tier2_5_formula_verification.md`

Key additions:
- Replaced the GAMBoost template status with `paper_formula_extracted_partial`.
- Added paper-supported risk target, initialization, pseudo-residuals, iterative update, final aggregation, reweighting, loss functions, base learners, and stopping/complexity criteria.
- Added `data/manifests/papers/GAMboosting_formulas_extracted.json` as formula evidence.
- Ran Tier evaluation: Tier 1 passed; Tier 2 degraded gracefully because the semantic model dependency/network was unavailable.

---

## [2026-05-13] metadata | draft enriched profile for IPCC ATLAS dataset

Pages created:
- `wiki/analyses/metadata/zenodo_3998463_ipcc_atlas_regions_enriched_metadata_draft.md`

Pages updated:
- `wiki/index.md`

Key additions:
- Created a draft enriched metadata profile from the existing dataset fiche, paper fiche, manifest, and metadata schema.
- Marked the profile as `draft_from_existing_fiches`, not validated.
- Explicitly separated variable typology, feature selection, modeling evidence, methodological selection, traceability, and quality pedigree.
- No dataset files were downloaded or inspected.
- Ran Tier evaluation: Tier 1 passed; Tier 2 degraded gracefully because the semantic model connection was unavailable.

---

## [2026-05-13] policy | paper author and publisher priority gate

Files updated:
- `AGENTS.md`
- `wiki/metadata/discovery_policy_v3.md`
- `data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json`
- `wiki/analyses/discovery/spatial_econometrics_paper_dataset_scrape_2026_05_12.md`
- recent JAE paper fiches in `wiki/papers/`

Key additions:
- Default paper scraping now prioritizes papers with at least 4 authors and a recognized publisher, journal, or scientific data venue.
- Papers below the 4-author threshold may be retained only with an explicit exception: recognized venue, resolvable paper DOI, resolvable dataset/archive DOI or repository package, and explicit spatial or spatio-temporal modeling evidence.
- Recent JAE fiches now record author count, publisher/editor, publisher recognition, and author-count exception reasons.

---

## [2026-05-12] eval-format | align paper fiches with AGENTS and Tier 1

Files updated:
- `AGENTS.md`
- `LLM-wiki-Assessment/eval/tier1_structural.py`
- `wiki/papers/ertur_koch_2007_growth_spatial_externalities.md`
- `wiki/papers/parent_lesage_2008_knowledge_spillovers.md`
- `wiki/papers/behrens_ertur_koch_2012_dual_gravity.md`
- `wiki/papers/millo_2015_house_prices_replication.md`
- `wiki/papers/jin_lee_yang_2024_spatial_moments_employment.md`

Key additions:
- Tier 1 now accepts the canonical `## Abstract` section from `AGENTS.md` as the abstract value.
- Tier 1 now recognizes `## Dataset Linkage`, `## Modeling Evidence`, and `## Dataset Access Decision` for paper fiches.
- Paper fiches now include external paper DOI and dataset/archive DOI URLs in `sources`, plus `Linkage evidence`.

Checks:
- `python -m py_compile LLM-wiki-Assessment/eval/tier1_structural.py`
- No evaluation command was run.

---

## [2026-05-12] discovery | spatial econometrics paper-dataset scrape

Pages created:
- `wiki/analyses/discovery/spatial_econometrics_paper_dataset_scrape_2026_05_12.md`
- `wiki/sources/warehouses/zbw_journal_data_archive.md`
- `wiki/papers/ertur_koch_2007_growth_spatial_externalities.md`
- `wiki/papers/parent_lesage_2008_knowledge_spillovers.md`
- `wiki/papers/behrens_ertur_koch_2012_dual_gravity.md`
- `wiki/papers/millo_2015_house_prices_replication.md`
- `wiki/papers/jin_lee_yang_2024_spatial_moments_employment.md`

Manifest created:
- `data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json`

Key additions:
- Confirmed five paper-to-dataset routes with separate paper DOI and dataset/archive DOI.
- Kept seven papers in review where dataset access was indirect, uncertain, or not found.
- Did not download datasets and did not run tests or evaluation commands.

---

## [2026-05-12] organization | metadata analysis routing cleanup

Pages moved:
- `wiki/analyses/metadata/cross_language_software_dataset_access.md` -> `wiki/metadata/cross_language_software_dataset_access.md`
- `wiki/analyses/metadata/feature_selection_block_template.md` -> `wiki/metadata/feature_selection_block_template.md`
- `wiki/analyses/metadata/software_python_priority_datasets_metadata.md` -> `wiki/analyses/discovery/software_python_priority_datasets_metadata.md`
- `wiki/analyses/metadata/software_r_priority_datasets_metadata.md` -> `wiki/analyses/discovery/software_r_priority_datasets_metadata.md`

Key additions:
- Reserved `wiki/analyses/metadata/` for enriched metadata profiles of confirmed or validated datasets.
- Routed reusable metadata rules and templates to `wiki/metadata/`.
- Routed software dataset candidate catalogues to `wiki/analyses/discovery/`.

---

To view recent activity: `grep "^## \[" log.md | tail -10`

---

## [2026-05-06] ingest | Zenodo scraping — 3 spatial panel datasets

Pages created:
- wiki/datasets/zenodo_15530852_mexico_municipalities_expenditure.md
- wiki/datasets/zenodo_15627695_mexico_property_tax_spillovers.md
- wiki/datasets/zenodo_15781610_poland_ekc_nuts.md

Key additions:
- Dataset 15530852 : panel équilibré 860 municipalités mexicaines × 22 ans (2000-2021), variables fiscales + spatiales, modèle SAR/SDM — Tier 1 PASS, Tier 2 AMBER 0.74 (paper DOI à résoudre)
- Dataset 15627695 : panel non balancé municipalités mexicaines, taxe foncière, retards spatiaux, 2001-2019 — Tier 1 PASS, Tier 2 AMBER 0.74 (paper DOI à résoudre)
- Dataset 15781610 : NUTS2/NUTS3 Pologne + GeoJSON, courbe Kuznets environnementale, Excel + géométries — Tier 1 PASS, Tier 2 AMBER 0.72 (Y/X à vérifier par inspection)
- wiki/index.md mis à jour avec les 3 nouvelles entrées

Scripts utilisés: pipeline_portals/python/scrape_zenodo.py (requête "spatial panel regression econometric", 3 pages API)
Évaluation: Tier 1 PASS × 3 / Tier 2 AMBER × 3 (raw source absent → cap 0.74) → ajoutés à eval_queue.md

---

## [2026-05-05] lint | remove removed trade index estimator and linked pages

Issues found:
- The removed trade index estimator was no longer relevant to the project estimator scope.
- It had active links from the index, glossary, estimator policy, source pages, and historical notes.

Fixes applied:
- Deleted the removed trade-index estimator fiche.
- Deleted the directly linked trade-methodology source page.
- Removed the estimator from `wiki/index.md`.
- Removed related glossary terms and policy references.
- Removed active wiki links and stale references connected to that estimator.

## [2026-05-05] lint | remove unlicensed dataset fiches and normalize wiki/json files

Issues found:
- Dataset fiches in `wiki/datasets/` had no documented licence evidence.
- Some wiki pages lacked YAML frontmatter.
- Some JSON files used UTF-8 with BOM.
- Deleted dataset page links needed demotion to plain text to avoid broken wiki links.

Fixes applied:
- Removed unlicensed dataset fiches from `wiki/datasets/`.
- Removed dataset records without `license_metadata` from `data/catalogue_datasets.json`.
- Cleared dataset entries from `wiki/index.md` until licence metadata is documented.
- Added YAML frontmatter to `wiki/index.md`, `wiki/log.md`, `wiki/analyses/discovery/software_dataset_literature_links_2026_04_29.md`, and `wiki/analyses/metadata/cross_language_software_dataset_access.md`.
- Added missing `sources: []` fields to software source pages.
- Normalized BOM-encoded JSON and key wiki files to UTF-8 without BOM.
- Replaced links to removed dataset fiches with plain code-form identifiers.

## [2026-04-07] init | Wiki created

Wiki initialized for a technical writer's personal knowledge base.

Structure created:
- `raw/` - source documents folder
- `wiki/` - LLM-maintained knowledge base
- `wiki/sources/` - per-source summary pages
- `CLAUDE.md` - schema and operating instructions

Core pages created:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/overview.md`
- `wiki/glossary.md`

Next step: Drop your first source into `raw/` and say **"ingest [filename]"**.


Pages created:
- `wiki/concepts/intra_industry_trade.md`
- `wiki/concepts/trade_aggregation_bias.md`
- `wiki/concepts/product_differentiation_in_trade.md`

Pages updated:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/glossary.md`
- `wiki/log.md`

Key additions:
- Ingested a scientific article as a methodological source (no dataset page created).
- Extracted concepts: trade overlap, aggregation bias, product differentiation in trade.
- Added estimator page for the removed trade index and documented measurement caveats.
- Added analysis translating econometric design choices into metadata schema requirements.
- Updated core wiki navigation and synthesis pages with cross-links and ingest status.

## [2026-04-21] query | suitable datasets for removed trade index

Pages consulted:
- `wiki/index.md`

Output filed: yes - dataset pages created

Pages created:
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/eurostat_comext_itg.md`
- `wiki/datasets/cepii_baci.md`

Pages updated:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/log.md`

Key additions:
- Identified four real-world, documented trade datasets suitable for removed trade index computation.
- Added variable-level mapping for `Xi`, `Mi`, classification, time, and country dimensions.
- Documented key limitations (aggregation bias, classification revision breaks, comparability constraints, metadata gaps).

## [2026-04-21] query | unemployment datasets for France

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`

Output filed: yes - `wiki/analyses/france_unemployment_datasets_comparison.md`

Pages created:
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/eurostat.md`
- `wiki/analyses/france_unemployment_datasets_comparison.md`

Pages updated:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/glossary.md`
- `wiki/log.md`

Key additions:
- Added two unemployment-relevant dataset pages for France-focused and Europe-comparative work.
- Added warehouse pages for INSEE and Eurostat to anchor dataset provenance.
- Filed a short comparison note recommending INSEE for France-only work and Eurostat LFS for harmonized European comparison.
- Recorded remaining metadata gaps: exact series identifiers and table codes still need to be pinned down.

## [2026-04-21] query | dataset catalog schema redesign

Pages consulted:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/analyses/france_unemployment_datasets_comparison.md`
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/cepii_baci.md`

Output filed: yes - `wiki/metadata/dataset_catalog_schema_v2.md`

Pages created:
- `wiki/metadata/dataset_catalog_schema_v2.md`

Pages updated:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/glossary.md`
- `wiki/log.md`

Key additions:
- Redesigned the local dataset catalog into a v2 schema with identity, source/access, content metadata, spatio-temporal metadata, access metadata, and methodological selection blocks.
- Added explicit support for multiple warehouse types and discovery layers per dataset.
- Rebuilt the live root catalog with five documented datasets spanning INSEE, Eurostat, UNSD, OECD, and CEPII.
- Updated the MCP dataset-search server to read the richer nested schema without losing simple text search.

## [2026-04-21] query | candidate datasets for unemployment, education, and territorial France analysis

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/overview.md`
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/eurostat.md`
- `wiki/analyses/france_unemployment_datasets_comparison.md`

Tools consulted:
- `dataset_search` MCP with queries on unemployment, education, and territorial France analysis

Output filed: yes - dataset pages updated and raw download manifests created

Pages updated:
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/log.md`

Files created:
- `data/downloads/insee_t304_chomage_diplome.csv`
- `data/downloads/eurostat_lfst_r_lfu3rt.json`
- `data/manifests/datasets/insee_emploi_chomage_population_active.json`
- `data/manifests/datasets/eurostat_labour_force_survey.json`

Key additions:
- Confirmed two documented candidate datasets from the current wiki and MCP results: INSEE labour-market series and Eurostat Labour Force Survey.
- Recorded why each candidate is relevant for unemployment, education, and regional or territorial analysis in France.
- Added explicit source/warehouse, access-condition, limitation, and raw-download sections to both dataset pages.
- Downloaded raw official files when direct access was available and recorded them in manifest files without cleaning or transforming the data.

## [2026-04-22] query | metadata-oriented exploratory warehouse discovery

Pages consulted:
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/log.md`
- `wiki/metadata/dataset_catalog_schema_v2.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/cepii_baci.md`
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/eurostat.md`

Tools consulted:
- `dataset_search` MCP with exploratory metadata queries spanning spatial, spatio-temporal, classification, geography, and time dimensions
- official warehouse pages for INSEE, Eurostat, data.gouv, OECD, World Bank, UN Comtrade, and CEPII

Output filed: yes - new warehouse pages, new dataset pages, one analysis page, new manifests, and enriched root catalog

Pages created:
- `wiki/datasets/insee_base_permanente_equipements.md`
- `wiki/datasets/data_gouv_dvf_geolocalisees.md`
- `wiki/datasets/world_bank_world_development_indicators.md`
- `wiki/warehouses/data_gouv.md`
- `wiki/warehouses/oecd.md`
- `wiki/warehouses/world_bank.md`
- `wiki/warehouses/un_comtrade.md`
- `wiki/warehouses/cepii.md`
- `wiki/analyses/metadata_oriented_dataset_discovery_warehouses_2026_04_22.md`

Pages updated:
- `wiki/datasets/eurostat_comext_itg.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/cepii_baci.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/eurostat.md`
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/log.md`

Files created:
- `data/manifests/datasets/insee_base_permanente_equipements.json`
- `data/manifests/datasets/eurostat_comext_itg.json`
- `data/manifests/datasets/data_gouv_dvf_geolocalisees.json`
- `data/manifests/datasets/oecd_itcs.json`
- `data/manifests/datasets/world_bank_world_development_indicators.json`
- `data/manifests/datasets/un_comtrade_merchandise_trade.json`
- `data/manifests/datasets/cepii_baci.json`

Key additions:
- Extended the warehouse coverage from INSEE and Eurostat to data.gouv, OECD, World Bank, UN Comtrade, and CEPII.
- Identified datasets with strong spatial, spatio-temporal, and classification structure suitable for metadata enrichment rather than topic-only lookup.
- Standardized dataset pages around variables, classifications, spatial units, time dimensions, and frequency.
- Recorded direct-access methods and URLs in manifests without downloading, cleaning, or transforming newly discovered files.

## [2026-04-22] query | ranking newly documented datasets by metadata richness and spatial usefulness

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/analyses/metadata_oriented_dataset_discovery_warehouses_2026_04_22.md`
- `wiki/datasets/insee_base_permanente_equipements.md`
- `wiki/datasets/data_gouv_dvf_geolocalisees.md`
- `wiki/datasets/world_bank_world_development_indicators.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/eurostat_comext_itg.md`
- `wiki/datasets/cepii_baci.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/data_gouv.md`
- `wiki/warehouses/world_bank.md`
- `wiki/warehouses/un_comtrade.md`
- `wiki/warehouses/oecd.md`
- `wiki/warehouses/eurostat.md`
- `wiki/warehouses/cepii.md`

Output filed: yes - `wiki/analyses/dataset_ranking_metadata_spatial_download_priority_2026_04_22.md`

Pages created:
- `wiki/analyses/dataset_ranking_metadata_spatial_download_priority_2026_04_22.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Reviewed the newly documented dataset and warehouse pages created or extended in the 2026-04-22 discovery pass.
- Ranked the seven discovery candidates by metadata richness and by spatial or spatio-temporal usefulness.
- Identified three raw-download priorities without downloading any files.
- Recorded the main reasoning behind the ranking, including why BACI is a cleaner first international raw target than broader but less operationally fixed trade families.

## [2026-04-22] query | architecture upgrade for license-aware and paper-linked discovery

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/overview.md`
- `wiki/glossary.md`
- `wiki/metadata/dataset_catalog_schema_v2.md`
- `wiki/analyses/metadata_oriented_dataset_discovery_warehouses_2026_04_22.md`
- `wiki/datasets/insee_emploi_chomage_population_active.md`
- `wiki/datasets/eurostat_labour_force_survey.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/cepii_baci.md`
- `wiki/datasets/eurostat_comext_itg.md`
- `wiki/datasets/insee_base_permanente_equipements.md`
- `wiki/datasets/data_gouv_dvf_geolocalisees.md`
- `wiki/datasets/world_bank_world_development_indicators.md`
- `wiki/warehouses/insee.md`
- `wiki/warehouses/eurostat.md`
- `wiki/warehouses/data_gouv.md`
- `wiki/warehouses/oecd.md`
- `wiki/warehouses/world_bank.md`
- `wiki/warehouses/un_comtrade.md`
- `wiki/warehouses/cepii.md`

Output filed: yes - architecture pages, registry schema updates, and discovery-code updates

Pages created:
- `wiki/metadata/catalog_registry_schema_v3.md`
- `wiki/metadata/discovery_policy_v3.md`
- `wiki/metadata/restricted_estimator_policy_v1.md`
- `wiki/papers/papers_directory_conventions.md`

Pages updated:
- `wiki/metadata/dataset_catalog_schema_v2.md`
- `wiki/index.md`
- `wiki/overview.md`
- `wiki/glossary.md`
- `wiki/log.md`

Files updated outside wiki:
- `data/catalogue_datasets.json`
- `mcp_datasets_server.py`
- `data/manifests/papers/README.md`

Key additions:
- Added v3 registry architecture with top-level support for dataset, paper, and warehouse records.
- Added explicit license metadata, dataset DOI, publication DOI, and dataset-paper traceability slots without inventing missing values.
- Added a discovery policy that prioritizes spatial and spatio-temporal structure, metadata richness, reusable licenses, and documented paper or DOI signals.
- Enforced a strict estimator allowlist policy and removed free-form approved-estimator use from dataset records.
- Documented `wiki/papers/` and `data/manifests/papers/`, while only documenting `raw/papers/` because `AGENTS.md` forbids modifying `raw/`.

## [2026-04-22] query | tighten estimator and license schema semantics

Pages consulted:
- `wiki/metadata/catalog_registry_schema_v3.md`
- `wiki/metadata/restricted_estimator_policy_v1.md`
- `wiki/metadata/discovery_policy_v3.md`
- `wiki/log.md`

Output filed: yes - schema and policy logic updated

Pages updated:
- `wiki/metadata/catalog_registry_schema_v3.md`
- `wiki/metadata/restricted_estimator_policy_v1.md`
- `wiki/metadata/discovery_policy_v3.md`
- `wiki/log.md`

Files updated outside wiki:
- `data/catalogue_datasets.json`
- `mcp_datasets_server.py`

Key additions:
- Redefined estimator policy so that only allowlisted estimators are permitted and every dataset record must carry a plausibility-assessment structure with candidate estimators and justifications.
- Redefined license handling so that explicit license presence, exact license name, openness, and reuse permissions are separate fields.
- Tightened discovery logic so generic access wording is no longer treated as an explicit open or reusable license.
- Kept all current dataset records conservative by marking estimator assessment as pending and license evidence as not explicitly documented where exact legal text is not pinned.

## [2026-04-22] query | verify missing raw endpoints for UN Comtrade and OECD ITCS

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/datasets/un_comtrade_merchandise_trade.md`
- `wiki/datasets/oecd_itcs.md`
- `wiki/datasets/eurostat_comext_itg.md`

Output filed: yes - `wiki/analyses/trade_raw_endpoint_verification_2026_04_22.md`

Pages created:
- `wiki/analyses/trade_raw_endpoint_verification_2026_04_22.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files updated outside wiki:
- `data/manifests/datasets/eurostat_comext_itg.json`
- `data/manifests/datasets/un_comtrade_merchandise_trade.json`
- `data/manifests/datasets/oecd_itcs.json`

Key additions:
- Verified and recorded a working raw Eurostat Comext JSON endpoint, then linked it to the downloaded local file in the manifest.
- Documented official UNSD and OECD API reference points for UN Comtrade and OECD ITCS without inventing an operational raw endpoint where one could not be verified.
- Recorded that the tested current UN Comtrade candidate endpoint returned HTML application content rather than raw trade records in this environment.
- Recorded that the OECD ITCS publication page returned HTTP 403 here and that no exact ITCS SDMX dataflow was identified in the official public or archive registries tested on 2026-04-22.

## [2026-04-23] query | estimator fiche templates from raw papers

Pages consulted:
- `wiki/index.md`
- `wiki/log.md`
- `wiki/metadata/restricted_estimator_policy_v1.md`
- `raw/paper/`

Output filed: yes - estimator schema and fiche templates created

Pages created:
- `wiki/metadata/estimator_fiche_schema_v1.md`
- `wiki/estimators/xgboost.md`
- `wiki/estimators/lightgbm.md`
- `wiki/estimators/gamboost.md`
- `wiki/estimators/random_forest.md`
- `wiki/estimators/mars.md`
- `wiki/estimators/inla.md`
- `wiki/estimators/stvc.md`
- `wiki/estimators/svc.md`
- `wiki/estimators/mgwr.md`
- `wiki/estimators/mgwrsar.md`
- `wiki/estimators/spboost.md`
- `wiki/estimators/rnn_svm.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `scripts/prepare_estimator_fiches.py`

Key additions:
- Added a caret-like estimator fiche schema for project modeling preparation.
- Created templates for all 12 allowed estimators from the restricted estimator policy.
- Added a cross-validation rule stating that the validation scheme is fixed by the project owner outside the estimator fiches.
- Added a preparation script that inventories raw paper filenames and maps them to estimator fiche templates without modifying `raw/`.

## [2026-04-23] query | correct RNN + SVM paper status

Pages consulted:
- `wiki/estimators/rnn_svm.md`
- `scripts/prepare_estimator_fiches.py`
- `wiki/log.md`

Output filed: yes - RNN + SVM source status corrected

Pages updated:
- `wiki/estimators/rnn_svm.md`
- `wiki/log.md`

Files updated outside wiki:
- `scripts/prepare_estimator_fiches.py`

Key additions:
- Removed provisional paper associations from the RNN + SVM estimator fiche.
- Marked RNN + SVM as awaiting a dedicated local source paper in `raw/paper/`.
- Updated the estimator inventory script so RNN + SVM reports `documentation_not_yet_provided` rather than mapping unrelated papers.

## [2026-04-23] query | download ISLR and refine RNN + SVM strategy

Pages consulted:
- `wiki/estimators/rnn_svm.md`
- `wiki/index.md`
- `wiki/log.md`

Official online sources consulted:
- `https://www.statlearning.com/`
- `https://link.springer.com/book/10.1007/978-1-0716-1418-1`

Output filed: yes - source note, manifest, and RNN + SVM strategy added

Pages created:
- `wiki/sources/islr2_statistical_learning.md`
- `wiki/analyses/rnn_svm_strategy_2026_04_23.md`

Pages updated:
- `wiki/estimators/rnn_svm.md`
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `data/downloads/reference_books/ISLRv2_corrected_June_2023.pdf`
- `data/manifests/papers/islr2.json`

Key additions:
- Downloaded the official ISLR second-edition PDF from the authors' official download page.
- Recorded a manifest with DOI, official pages, local path, file size, and SHA256.
- Clarified that ISLR supports generic SVM and neural-network background but is not a dedicated RNN + SVM hybrid source.
- Added a strategy note recommending RNN + SVM as an allowed but low-maturity exploratory estimator until a dedicated paper is added to `raw/paper/`.

## [2026-04-23] query | clarify RNN and SVM and add controlled portal scraper

Pages consulted:
- `wiki/estimators/rnn_svm.md`
- `wiki/analyses/rnn_svm_strategy_2026_04_23.md`
- `wiki/log.md`
- `AGENTS.md`

Output filed: yes - estimator interpretation corrected and scraper script added

Pages updated:
- `wiki/estimators/rnn_svm.md`
- `wiki/analyses/rnn_svm_strategy_2026_04_23.md`
- `wiki/log.md`

Files created outside wiki:
- `pipeline_portals/execute_portal_jobs.py`

Key additions:
- Corrected the interpretation of `RNN + SVM`: it means two separate candidate methods, not a required hybrid architecture.
- Added a controlled real-scraping executor for portal metadata jobs.
- The executor records HTTP status, content type, links, DOI strings, license terms, JSON summaries, and optional Playwright rendering output without writing to `raw/`.

## [2026-04-23] query | controlled portal scraping trial

Pages consulted:
- `AGENTS.md`
- `pipeline_portals/execute_portal_jobs.py`
- `data/manifests/datasets/world_bank.records.jsonl`
- `data/manifests/datasets/eurostat.records.jsonl`
- `data/manifests/datasets/data_gouv.records.jsonl`

Output filed: yes - controlled metadata-only scrape records generated

Pages updated:
- `wiki/log.md`

Files created or updated outside wiki:
- `data/manifests/datasets/world_bank.seed-log.jsonl`
- `data/manifests/datasets/world_bank.records.jsonl`
- `data/manifests/datasets/eurostat.seed-log.jsonl`
- `data/manifests/datasets/eurostat.records.jsonl`
- `data/manifests/datasets/data_gouv.seed-log.jsonl`
- `data/manifests/datasets/data_gouv.records.jsonl`
- `pipeline_portals/execute_portal_jobs.py`

Key additions:
- Ran metadata-only scraping trials for World Bank WDI, Eurostat Comext ITG, and data.gouv DVF geolocalisees.
- World Bank WDI returned HTTP 200, a catalog title, extracted links, one DOI string, and license/reuse signals.
- Eurostat Comext ITG returned HTTP 200, a metadata-page title, and extracted metadata links.
- data.gouv timed out through direct HTTP access; the failure is now captured as a manifest record, and Playwright fallback was attempted but is not installed in the current environment.
- No raw dataset file was downloaded and `raw/` was not modified.

## [2026-04-23] query | estimator equations and raw spatio-temporal scraping targets

Pages consulted:
- `wiki/metadata/estimator_fiche_schema_v1.md`
- `wiki/estimators/`
- `wiki/analyses/metadata_oriented_dataset_discovery_warehouses_2026_04_22.md`
- online dataset and paper pages for Copernicus CDS, NOAA NCEI, E-OBS, OpenSky, Global Fishing Watch, NYC TLC, Scientific Data, Zenodo, and IDEAS/RePEc

Output filed: yes - estimator equation sections and scraping target note added

Pages created:
- `wiki/analyses/raw_spatiotemporal_dataset_scraping_targets_2026_04_23.md`

Pages updated:
- `wiki/metadata/estimator_fiche_schema_v1.md`
- `wiki/estimators/xgboost.md`
- `wiki/estimators/lightgbm.md`
- `wiki/estimators/gamboost.md`
- `wiki/estimators/random_forest.md`
- `wiki/estimators/mars.md`
- `wiki/estimators/inla.md`
- `wiki/estimators/stvc.md`
- `wiki/estimators/svc.md`
- `wiki/estimators/mgwr.md`
- `wiki/estimators/mgwrsar.md`
- `wiki/estimators/spboost.md`
- `wiki/estimators/rnn_svm.md`
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Added `Model Equation` as a required estimator fiche section.
- Inserted canonical equations or objectives in all 12 allowed estimator fiche templates, marked as pending paper extraction.
- Created a prioritized raw spatio-temporal dataset scraping target note with paper links, access routes, and rawness categories.
- Added IDEAS/RePEc leads for spatial panel and gridded agricultural/environmental datasets requiring replication-data follow-up.

## [2026-04-23] query | download 10 datasets and 10 papers

Pages consulted:
- `AGENTS.md`
- `wiki/analyses/raw_spatiotemporal_dataset_scraping_targets_2026_04_23.md`
- existing dataset manifests in `data/manifests/`

Output filed: yes - dated download directories, final manifest, and traceability wiki note

Pages created:
- `wiki/analyses/download_batch_2026_04_23_datasets10_papers10.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `data/downloads/2026-04-23_datasets/`
- `data/downloads/2026-04-23_papers/`
- `data/downloads/2026-04-23_rejected_responses/`
- `data/manifests/runs/2026-04-23_download_batch_datasets10_papers10.json`
- `data/manifests/runs/2026-04-23_final_download_batch_datasets10_papers10.json`

Key additions:
- Downloaded 10 dataset files with date-prefixed filenames.
- Downloaded 10 scientific paper PDFs and validated them by checking the PDF header.
- Moved five invalid or blocked paper responses into a rejected-response directory rather than counting them as papers.
- Did not write to `raw/`, following the repository rule.

## [2026-04-23] query | lookup Springer book on high-dimensional data

Pages consulted:
- `wiki/index.md`
- official SpringerLink book page
- ETH Zurich Research Collection record

Output filed: yes - book lookup manifest and access-status note

Pages created:
- `wiki/analyses/book_lookup_statistics_for_high_dimensional_data_2026_04_23.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `data/downloads/2026-04-23_books/`
- `data/downloads/2026-04-23_books/rejected_responses/`
- `data/manifests/runs/2026-04-23_book_statistics_for_high_dimensional_data_attempt.json`
- `data/manifests/papers/statistics_for_high_dimensional_data_buhlmann_vandegeer_2026_04_23.json`

Key additions:
- Identified the requested book as Peter Buhlmann and Sara van de Geer, `Statistics for High-Dimensional Data: Methods, Theory and Applications`, DOI `10.1007/978-3-642-20192-9`.
- Checked SpringerLink and ETH Research Collection official sources.
- Stored official metadata and HTTP/API responses in the local system.
- Did not store a full book PDF because the official endpoints did not expose a legally accessible PDF in this session.
- Moved the non-PDF Springer response into a rejected-response folder for traceability.

## [2026-04-27] query | search 10 scientific papers linked to datasets

Pages consulted:
- `wiki/analyses/raw_spatiotemporal_dataset_scraping_targets_2026_04_23.md`
- `wiki/analyses/download_batch_2026_04_23_datasets10_papers10.md`
- `data/manifests/runs/2026-04-23_final_download_batch_datasets10_papers10.json`
- online publication pages for Scientific Data, Earth System Science Data, IJCAI, Google Research, Global Fishing Watch, NOAA/GHCN, and ERA5 reference metadata

Output filed: yes - shortlist of 10 data-linked scientific papers

Pages created:
- `wiki/analyses/scientific_data_linked_papers_2026_04_27.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Identified 10 papers linked to explicit datasets, data descriptors, or named public benchmark datasets.
- Marked which candidates already have local PDFs and which earlier automated downloads returned rejected HTML or empty responses.
- Separated strong data-descriptor candidates from lower-priority method papers that are mainly useful through benchmark dataset links.

## [2026-04-30] query | add R-first estimator implementation layer

Pages consulted:
- `AGENTS.md`
- `wiki/metadata/restricted_estimator_policy_v1.md`
- `wiki/metadata/estimator_fiche_schema_v1.md`
- selected estimator fiches under `wiki/estimators/`
- software package manifests under `data/manifests/`

Output filed: yes - R implementation policy, backend audit, registry, and wrapper skeletons

Pages created:
- `wiki/metadata/r_estimator_implementation_policy_v1.md`
- `wiki/analyses/modeling/estimations/r_estimator_backend_audit_2026_04_30.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `data/manifests/runs/estimator_software_registry.jsonl`
- `R/utils/estimator_common.R`
- `R/estimators/README.md`
- `R/estimators/load_estimators.R`
- `R/estimators/fit_xgboost.R`
- `R/estimators/fit_lightgbm.R`
- `R/estimators/fit_gamboost.R`
- `R/estimators/fit_random_forest.R`
- `R/estimators/fit_mars.R`
- `R/estimators/fit_inla.R`
- `R/estimators/fit_svc.R`
- `R/estimators/fit_stvc.R`
- `R/estimators/fit_mgwr.R`
- `R/estimators/fit_mgwrsar.R`
- `R/estimators/fit_spboost.R`
- `R/estimators/fit_rnn_reticulate.R`
- `R/estimators/fit_svm.R`

Key additions:
- Added an R-first rule: use native R packages when available, use Python only through R-facing `reticulate` wrappers when necessary.
- Added a machine-readable backend registry for all allowlisted estimators.
- Added initial wrapper functions with common return metadata and clear missing-package failures.
- Marked SpBoost as pending until a stable backend is selected.

Validation:
- Parsed 15 R files successfully with `Rscript` from R 4.5.3.
- Loaded `R/estimators/load_estimators.R` successfully and confirmed 13 `fit_*` functions.
- Detected installed R backends: `mboost`, `mgcv`, `mgwrsar`, `reticulate`, `e1071`.
- Detected missing R backends: `xgboost`, `lightgbm`, `ranger`, `earth`, `INLA`, `GWmodel`.

## [2026-04-30] ingest | enrich MGWR and MGWRSAR estimator fiches from local package docs

Pages consulted:
- `AGENTS.md`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/DESCRIPTION`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/MGWRSAR.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/multiscale_gwr.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/TDS_MGWR.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/kernel_matW.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/search_bandwidths.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/predict.mgwrsar.Rd`
- `raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/mgwrsar_bootstrap_test.Rd`

Output filed: yes - estimator fiches updated from local R package documentation

Pages updated:
- `wiki/estimators/mgwr.md`
- `wiki/estimators/mgwrsar.md`
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Replaced placeholder text with operational estimator fiches.
- Added documented model variants for OLS, SAR, GWR, MGWR, and MGWRSAR.
- Added hyperparameters for kernels, bandwidths, adaptive neighborhoods, spatial weights, generalized kernel types, search controls, prediction controls, and bootstrap comparison.
- Added data requirements, metadata fields to record, validation protocols, diagnostics, and failure modes.
- Left `raw/` unchanged.

## [2026-05-04] ingest | enrich SpBoost estimator fiche from article

Pages consulted:
- `AGENTS.md`
- `raw/paper/spbbost_article.pdf`
- `wiki/estimators/spboost.md`

Output filed: yes - SpBoost estimator fiche updated from article evidence

Pages updated:
- `wiki/estimators/spboost.md`
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Replaced the SpBoost template with a structured fiche for nonlinear spatial autoregressive boosting.
- Added readable LaTeX equations for additive boosting, SAR, SEM, SARAR, transformed losses, and CFE spatial-parameter estimation.
- Added hyperparameters for `W`, `mstop`, learning rate, base learners, CFE/ML choice, and geographic smoother inclusion.
- Added identification warning against flexible geographic smoothers with spatially structured covariates.
- Clarified validation policy and implementation-pending backend status.
- Left `raw/` unchanged.

## [2026-05-05] ingest | integrate local SpBoost package source

Pages consulted:
- `AGENTS.md`
- `raw/estimators/spboost_0.6.3/spboost/DESCRIPTION`
- `raw/estimators/spboost_0.6.3/spboost/NAMESPACE`
- `raw/estimators/spboost_0.6.3/spboost/man/spb_make_boost_control.Rd`
- `raw/estimators/spboost_0.6.3/spboost/man/BSPA_SAR_CFE.Rd`
- `raw/estimators/spboost_0.6.3/spboost/man/BSPA_SEM_CFE.Rd`
- `raw/estimators/spboost_0.6.3/spboost/man/predict_spboost.Rd`

Output filed: yes - SpBoost estimator fiche, R wrapper, and manual R example updated

Pages updated:
- `wiki/estimators/spboost.md`
- `wiki/index.md`
- `wiki/log.md`
- `wiki/analyses/modeling/estimations/r_estimator_backend_audit_2026_04_30.md`

Files updated outside wiki:
- `R/estimators/fit_spboost.R`
- `R/estimators/README.md`
- `data/manifests/runs/estimator_software_registry.jsonl`

Files created outside wiki:
- `R/estimators/manual_spboost_example.R`

Key additions:
- Connected the project wrapper to `spboost::spbgam`.
- Documented the local package API: `BSPA_SAR_*`, `BSPA_SEM_*`, `BSPA_SARAR_*`, `predict_spboost`, and `build_Wk`.
- Added a commented manual R workflow for installing, simulating, fitting SAR CFE/ML, and using the wrapper.
- Left `raw/` unchanged.

## [2026-04-30] query | add R bridge for Python scraping scripts

Pages consulted:
- `pipeline_portals/python/scraping_examples.ps1`
- `pipeline_portals/python/run_portal_plan.py`
- `pipeline_portals/python/execute_portal_jobs.py`
- `pipeline_lit/run_literature_plan.py`

Output filed: yes - R bridge for existing Python scraping entry points

Pages created:
- `wiki/metadata/r_python_scraping_bridge_policy_v1.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `R/scraping/python_scraper_bridge.R`
- `R/scraping/README.md`

Key additions:
- Added `run_python_script()` to execute project Python scripts from R.
- Added `run_portal_scraper()` for warehouse and scientific portal scrapers.
- Added `run_portal_plan()`, `run_portal_jobs()`, and `run_literature_plan()`.
- Kept Python scrapers as the execution source of truth and avoided duplicating scraping logic in R.

## [2026-05-05] quality-control | apply human-LLM quality pedigree matrix

Pages consulted:
- `AGENTS.md`
- `data/catalogue_datasets.json`
- Mick Yates, Adding Quality Control to Andrej Karpathy's LLM Wiki

Output filed: yes - quality pedigree schema, tests, and human review templates

Pages created:
- `wiki/metadata/quality_pedigree_schema_v1.md`

Pages updated:
- `AGENTS.md`
- `wiki/index.md`
- `wiki/log.md`

Files created outside wiki:
- `tests/validation/test_quality_pedigree.py`
- `tests/evaluation/quality_pedigree_review_grid.md`
- `tests/evaluation/sample_quality_pedigree_review.md`

Files updated outside wiki:
- `data/catalogue_datasets.json`
- `tests/README.md`

Key additions:
- Added `quality_pedigree` blocks to active warehouse records in the local catalog.
- Required score evidence fields for provenance, rigour, evidence, coherence, and claim discipline.
- Added Delta1 risk and human-review gate so LLM-proposed scores stay pending until reviewed by a human.
- Added pytest validation for score ranges, evidence presence, review status, and schema registration.

## [2026-05-05] quality-control | add citation metrics to quality pedigree

Pages consulted:
- `wiki/metadata/quality_pedigree_schema_v1.md`
- `tests/validation/test_quality_pedigree.py`
- `data/catalogue_datasets.json`

Output filed: yes - citation metrics rules integrated into quality control

Pages updated:
- `AGENTS.md`
- `wiki/metadata/quality_pedigree_schema_v1.md`
- `wiki/log.md`

Files updated outside wiki:
- `data/catalogue_datasets.json`
- `tests/validation/test_quality_pedigree.py`
- `tests/evaluation/quality_pedigree_review_grid.md`
- `tests/evaluation/sample_quality_pedigree_review.md`
- `tests/README.md`

Key additions:
- Added `citation_metrics` as a decision signal inside `quality_pedigree`.
- Kept dataset citations and paper citations separate.
- Required citation source, interpretation, evidence, and checked date when counts are recorded.
- Documented that citations can enrich `evidence_evidence`, but cannot automatically validate quality or set `review_status` to reviewed.

## [2026-05-06] ingest | Zenodo and Dryad candidate scraping

Pages consulted:
- `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- `data/manifests/datasets/dryad_discovery_fixed_2026_05_06.jsonl`
- `pipeline_portals/python/scrape_dryad.py`
- `pipeline_portals/python/scrape_zenodo.py`

Output filed: yes - Zenodo dataset fiches and source pages

Pages created:
- `wiki/datasets/zenodo_18421412_mountain_fire.md`
- `wiki/datasets/zenodo_5534232_linear_pottery_harris.md`
- `wiki/datasets/zenodo_14499026_cranial_modifications_americas.md`
- `wiki/datasets/zenodo_10476054_stehme_holsea_norway.md`
- `wiki/datasets/zenodo_15501267_imf_by_paper.md`
- `wiki/sources/warehouses/zenodo.md`
- `wiki/sources/warehouses/dryad.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files updated outside wiki:
- `pipeline_portals/python/scrape_dryad.py`

Key additions:
- Created five Zenodo dataset fiches only for records with explicit license metadata and local downloads.
- Documented local datacandidate paths and pending quality review status.
- Fixed Dryad discovery to retrieve file-level metadata through version file endpoints.
- Dryad automated downloads remain blocked by server-side WAF/API responses; metadata and official file links are preserved in manifests.

## [2026-05-06] lint | normalize Zenodo dataset fiches to AGENTS format

Pages consulted:
- `AGENTS.md`
- `wiki/index.md`
- `wiki/log.md`
- `wiki/datasets/zenodo_18421412_mountain_fire.md`
- `wiki/datasets/zenodo_5534232_linear_pottery_harris.md`
- `wiki/datasets/zenodo_14499026_cranial_modifications_americas.md`
- `wiki/datasets/zenodo_10476054_stehme_holsea_norway.md`
- `wiki/datasets/zenodo_15501267_imf_by_paper.md`

Output filed: yes - dataset fiches normalized in place

Pages updated:
- `wiki/datasets/zenodo_18421412_mountain_fire.md`
- `wiki/datasets/zenodo_5534232_linear_pottery_harris.md`
- `wiki/datasets/zenodo_14499026_cranial_modifications_americas.md`
- `wiki/datasets/zenodo_10476054_stehme_holsea_norway.md`
- `wiki/datasets/zenodo_15501267_imf_by_paper.md`
- `wiki/log.md`

Key additions:
- Added explicit dataset name, source family, source URL, DOI, and reproducibility fields.
- Added candidate Y/X typologies and imputed-X status.
- Added structured `feature_selection` and `modeling_evidence` blocks.
- Added data type, N/T profile, spatial and temporal resolution, spatial extent, and time range fields.
- Preserved pending/unknown values where data inspection has not yet been performed.

## [2026-05-06] eval | strengthen dataset fiche evaluation criteria

Pages consulted:
- `AGENTS.md`
- `eval/tier1_structural.py`
- `eval/tier2_semantic.py`
- `eval/tier3_queue.py`
- `eval/run_eval.py`
- `wiki/datasets/zenodo_5534232_linear_pottery_harris.md`

Output filed: yes - evaluation pipeline improved

Pages updated:
- `wiki/datasets/zenodo_5534232_linear_pottery_harris.md`
- `wiki/log.md`

Files updated outside wiki:
- `eval/tier1_structural.py`
- `eval/tier2_semantic.py`
- `eval/tier3_queue.py`
- `eval/run_eval.py`

Key additions:
- Made Tier 1 enforce canonical dataset fields from `AGENTS.md` instead of accepting broad section names alone.
- Added checks for `feature_selection`, `modeling_evidence`, `quality_pedigree`, typology fields, imputed-X status, N/T, resolution, extent, and time range.
- Added a minimal frontmatter parser fallback when PyYAML is unavailable.
- Replaced mojibake/emoji console output with ASCII-safe messages for Windows terminals.
- Extended Tier 2 source loading to use project-relative evidence files such as manifests, not only files under `raw/`.
- Normalized the Linear Pottery Zenodo fiche to the canonical dataset labels caught by the stricter validator.

## [2026-05-06] ingest | France official datasets metadata scrape

Pages consulted:
- `AGENTS.md`
- `wiki/index.md`
- `wiki/log.md`
- `wiki/sources/warehouses/data_gouv.md`
- `wiki/sources/warehouses/insee.md`
- `data/manifests/datasets/data_gouv_dvf_geolocalisees.json`
- `data/manifests/datasets/insee_base_permanente_equipements.json`
- `data/manifests/datasets/insee_emploi_chomage_population_active.json`

Output filed: yes - official France dataset fiches and metadata manifest

Pages created:
- `wiki/datasets/data_gouv_dvf_geolocalisees.md`
- `wiki/datasets/data_gouv_dvf.md`
- `wiki/datasets/insee_base_permanente_equipements.md`
- `wiki/datasets/insee_chomage_halo_series_longues.md`

Pages updated:
- `wiki/index.md`
- `wiki/sources/warehouses/data_gouv.md`
- `wiki/sources/warehouses/insee.md`
- `wiki/log.md`

Files created outside wiki:
- `data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json`

Key additions:
- Scraped official data.gouv.fr API metadata for raw DVF and geolocated DVF.
- Verified `lov2` license metadata, open access status, temporal coverage, file URLs, file formats, and large file sizes for DVF resources.
- Verified current INSEE BPE metadata and BPE 2024 access route without downloading large files.
- Reintroduced INSEE unemployment/halo long-series table as a dataset fiche based on the official page and the existing downloaded CSV manifest.
- Preserved unknown values for N, imputation, exact file schema, and model equations until direct file inspection is performed.

## [2026-05-06] eval | strengthen DOI and enriched metadata gates

Pages consulted:
- `eval/tier1_structural.py`
- `eval/tier2_semantic.py`
- `tests/validation/test_external_catalog_integrity.py`
- `tests/validation/test_doi_format.py`

Output filed: yes - evaluation checks updated

Files updated outside wiki:
- `eval/tier1_structural.py`
- `eval/tier2_semantic.py`
- `tests/validation/test_external_catalog_integrity.py`

Key additions:
- Tier 1 now checks non-null critical dataset fields, while allowing explicit `Dataset DOI: none` only as a warning when no DOI is available.
- Tier 1 now supports `type: paper` and requires scientific paper DOI, source URL, abstract, dataset linkage evidence, quality pedigree, and related pages.
- Tier 2 dataset prompt now evaluates metadata completeness, DOI traceability, paper linkage, feature selection, modeling evidence, license, reproducibility, and quality gate status.
- Tier 2 now includes a dedicated scientific-paper prompt.
- External URL validation now tolerates transient HTTP 5xx server errors and skips cleanly when the local environment blocks all outbound network checks.

Validation:
- `pytest tests/validation/test_external_catalog_integrity.py` with external validation enabled passed outside sandbox.
- Local blocked-network run skipped the external URL test instead of producing false URL failures.

## [2026-05-06] scraping | capture dataset and paper descriptions

Pages consulted:
- `pipeline_portals/python/portal_common.py`
- `pipeline_portals/python/scrape_zenodo.py`
- `pipeline_portals/python/scrape_data_gouv.py`
- `pipeline_portals/python/scrape_insee.py`
- `pipeline_lit/lit_common.py`

Output filed: yes - scraping helpers updated

Files updated outside wiki:
- `pipeline_portals/python/portal_common.py`
- `pipeline_portals/python/scrape_zenodo.py`
- `pipeline_portals/python/scrape_data_gouv.py`
- `pipeline_portals/python/scrape_insee.py`
- `pipeline_lit/lit_common.py`

Key additions:
- Dataset scrapers now emit `description_metadata` with cleaned full description, short excerpt, description source, source URL, capture timestamp, and language when known.
- Zenodo descriptions are captured from API metadata; data.gouv.fr descriptions from API records; INSEE descriptions from cleaned HTML page text.
- Paper discovery records now emit `description_metadata` from OpenAlex/Crossref abstracts, preserving the full abstract in manifests and exposing an excerpt for future fiche/catalogue use.
- The intended storage split is explicit: full source description stays in manifests; fiches and catalogue should use short excerpts plus source links.

Validation:
- Python compilation passed for modified scrapers and helpers.
- Local fake-record checks confirmed Zenodo, data.gouv.fr, INSEE, and OpenAlex records now include `description_metadata`.

## [2026-05-07] discovery | Dryad spatial datasets

Pages consulted:
- `AGENTS.md`
- `pipeline_portals/python/scrape_dryad.py`
- `wiki/sources/warehouses/dryad.md`
- `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`

Output filed: yes - Dryad manifest, CSV, dataset fiches and catalog records

Pages created:
- `wiki/datasets/dryad_v41ns1rvb_forest_loss_cordillera.md`
- `wiki/datasets/dryad_bk3j9kdfk_benthic_trophic_networks.md`
- `wiki/datasets/dryad_8w9ghx3jj_citizen_science_habitat_suitability.md`

Pages updated:
- `wiki/index.md`
- `wiki/sources/warehouses/dryad.md`
- `wiki/log.md`

Files updated outside wiki:
- `pipeline_portals/python/scrape_dryad.py`
- `data/catalogue_datasets.json`
- `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- `data/manifests/datasets/dryad_3_spatial_2026_05_07.csv`

Key additions:
- Scraped three Dryad candidates using the Dryad API with DOI, source description, CC0 license, file metadata and download URLs.
- Added `description_metadata` capture to the Dryad scraper so full descriptions remain in manifests and fiches use short source excerpts.
- Documented three spatial or spatio-temporal candidates: forest loss in the Philippines, benthic trophic networks in Swedish coastal basins, and citizen-science habitat suitability modelling in Sweden.
- No `raw/` files were modified and no dataset files were downloaded during this ingest.

Validation:
- `python -m json.tool data/catalogue_datasets.json` passed.
- Local catalogue, quality pedigree and estimator policy tests passed.
- Tier 1 structural evaluation passed for the three new Dryad fiches, with warnings only for fields intentionally pending file inspection.

## [2026-05-07] scraping | description metadata across portal scrapers

Pages consulted:
- `pipeline_portals/python/portal_common.py`
- `pipeline_portals/python/scrape_cepii.py`
- `pipeline_portals/python/scrape_dataverse.py`
- `pipeline_portals/python/scrape_eurostat.py`
- `pipeline_portals/python/scrape_figshare.py`
- `pipeline_portals/python/scrape_oecd.py`
- `pipeline_portals/python/scrape_un_comtrade.py`
- `pipeline_portals/python/scrape_world_bank.py`

Output filed: yes - scraper metadata fields updated

Files updated outside wiki:
- `pipeline_portals/python/scrape_cepii.py`
- `pipeline_portals/python/scrape_dataverse.py`
- `pipeline_portals/python/scrape_eurostat.py`
- `pipeline_portals/python/scrape_figshare.py`
- `pipeline_portals/python/scrape_oecd.py`
- `pipeline_portals/python/scrape_un_comtrade.py`
- `pipeline_portals/python/scrape_world_bank.py`

Key additions:
- All remaining portal dataset scrapers now emit `description_metadata` alongside the existing `description` field.
- The field stores cleaned full text, a short excerpt, source type, source URL and capture timestamp.
- Existing OpenAlex/Crossref paper discovery already emits the same metadata from abstracts via `pipeline_lit/lit_common.py`.

Validation:
- Python compilation passed for all portal scrapers and the shared helpers.
- Local fake-record checks confirmed CEPII, Dataverse, Eurostat, Figshare, OECD, UN Comtrade and World Bank records include `description_metadata.description_excerpt`.

## [2026-05-07] maintenance | dataset fiches grouped by warehouse

Pages consulted:
- `AGENTS.md`
- `data/catalogue_datasets.json`
- `wiki/index.md`

Output filed: yes - dataset fiche directory convention updated

Pages moved:
- `wiki/datasets/data_gouv/*.md`
- `wiki/datasets/dryad/*.md`
- `wiki/datasets/insee/*.md`
- `wiki/datasets/zenodo/*.md`

Pages updated:
- `wiki/index.md`
- `wiki/log.md`

Files updated outside wiki:
- `data/catalogue_datasets.json`

Key additions:
- Dataset fiches are now grouped by source warehouse under `wiki/datasets/<warehouse>/`.
- The catalogue records now point to the new warehouse-specific fiche paths through `identity.wiki_page`.
- Historical log entries were left unchanged as past ingest traces.

## [2026-05-07] maintenance | manifest directory simplified

Pages consulted:
- `AGENTS.md`
- `data/catalogue_datasets.json`
- `data/manifests/`

Output filed: yes - manifest directory structure simplified

Files moved:
- Dataset/source manifests and scraping outputs to `data/manifests/datasets/`
- Paper and reference-book manifests to `data/manifests/papers/`
- Batch, execution and registry manifests to `data/manifests/runs/`

Files updated:
- `AGENTS.md`
- `data/catalogue_datasets.json`
- `data/manifests/README.md`
- `pipeline_portals/python/portal_common.py`
- Wiki pages that referenced old manifest paths

Key additions:
- `data/manifests/` now keeps only three active buckets: `datasets`, `papers`, and `runs`.
- Legacy `plans`, `download_batches`, and `reference_books` directories were collapsed into those buckets.
- The catalogue and wiki references now point to the new manifest paths.

## [2026-05-07] maintenance | catalogue moved under data

Pages consulted:
- `AGENTS.md`
- `data/catalogue_datasets.json`
- `LLM-wiki-Assessment/tests/`
- `Code_scrapping/`

Output filed: yes - catalogue path updated

Files moved:
- `catalogue_datasets.json` to `data/catalogue_datasets.json`

Files updated:
- `AGENTS.md`
- `data/manifests/README.md`
- `mcp_datasets_server.py`
- `Code_scrapping/pipeline_lit/lit_common.py`
- `Code_scrapping/pipeline_portals/python/portal_common.py`
- `Code_scrapping/pipeline_portals/python/scrape_zenodo.py`
- `LLM-wiki-Assessment/tests/`

Key additions:
- The canonical catalogue path is now `data/catalogue_datasets.json`.
- Scrapers, the MCP server, and assessment tests now load the catalogue from the new location.

## [2026-05-11] discovery | paper-linked dataset scraping

Pages consulted:
- `AGENTS.md`
- `Code_scrapping/pipeline_lit/discover_spatiotemporal_papers.py`
- `Code_scrapping/pipeline_lit/extract_dataset_links_from_papers.py`
- `data/catalogue_datasets.json`

Output filed: yes - one paper-linked dataset candidate documented

Files created:
- `data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl`
- `data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.csv`
- `data/manifests/papers/paper_linked_dataset_links_2026_05_11.json`
- `data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json`
- `wiki/datasets/zenodo/zenodo_3998463_ipcc_atlas_regions.md`
- `wiki/papers/iturbide_2020_ipcc_regions.md`
- `wiki/sources/literature/earth_system_science_data.md`
- `wiki/analyses/discovery/paper_linked_dataset_scraping_2026_05_11.md`

Files updated:
- `data/catalogue_datasets.json`
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Selected an ESSD/Copernicus data paper as source evidence for an IPCC/ATLAS dataset candidate.
- Kept the paper DOI and the Zenodo mixed archive identifier separate to avoid DOI-type confusion.
- Captured the dataset description excerpt in the fiche and the fuller source description in the manifest.

## [2026-05-12] discovery | open-access papers with dataset and method signals

Pages consulted:
- `AGENTS.md`
- `wiki/index.md`
- `Code_scrapping/pipeline_lit/discover_spatiotemporal_papers.py`
- `Code_scrapping/pipeline_lit/extract_dataset_links_from_papers.py`

Output filed: yes - candidate batch only, no dataset fiches generated

Files created:
- `data/manifests/papers/oa_dataset_methods_batch_2026_05_12.jsonl`
- `data/manifests/papers/oa_dataset_methods_batch_2026_05_12.csv`
- `data/manifests/papers/oa_dataset_methods_batch_2026_05_12_q2.csv`
- `data/manifests/papers/oa_dataset_methods_batch_2026_05_12_q3.csv`
- `data/manifests/papers/oa_dataset_methods_links_2026_05_12.json`
- `data/manifests/papers/oa_dataset_methods_enriched_2026_05_12.json`
- `data/manifests/papers/oa_dataset_methods_enriched_2026_05_12.csv`
- `wiki/analyses/discovery/open_access_publication_dataset_methods_scraping_2026_05_12.md`

Files updated:
- `wiki/index.md`
- `wiki/log.md`

Key additions:
- Queried OpenAlex for open-access-oriented publications with dataset and method signals.
- Did not scrape ResearchGate directly and did not use ScienceDirect directly without an API/licensed route.
- Produced a deduplicated enriched manifest with 22 paper candidates, 20 useful dataset/source-link records, and 16 records with detected methods.
- Kept the batch out of `data/catalogue_datasets.json` until dataset identities and access routes are curated.

## [2026-05-12] curation | rejected fiche evidence reconciliation

Pages consulted:
- `AGENTS.md`
- `.eval/rejected/2026-05-12_*.json`
- `wiki/eval_queue.md`
- `data/manifests/runs/rejected_2026_05_12_network_recheck.json`
- `data/manifests/runs/rejected_2026_05_12_dryad_8w9ghx3jj_files_recheck.json`

Output filed: yes - fiche corrections and single-record evidence manifests, no tests or evaluation run

Files created:
- `data/manifests/datasets/dryad_8w9ghx3jj_evidence_2026_05_12.json`
- `data/manifests/datasets/zenodo_10476054_evidence_2026_05_12.json`
- `data/manifests/datasets/zenodo_14499026_evidence_2026_05_12.json`
- `data/manifests/datasets/zenodo_15501267_evidence_2026_05_12.json`
- `data/manifests/datasets/zenodo_5534232_evidence_2026_05_12.json`

Files updated:
- `wiki/datasets/dryad/dryad_8w9ghx3jj_citizen_science_habitat_suitability.md`
- `wiki/datasets/zenodo/zenodo_10476054_stehme_holsea_norway.md`
- `wiki/datasets/zenodo/zenodo_14499026_cranial_modifications_americas.md`
- `wiki/datasets/zenodo/zenodo_15501267_imf_by_paper.md`
- `wiki/datasets/zenodo/zenodo_5534232_linear_pottery_harris.md`
- `wiki/analyses/modeling/estimations/r_estimator_backend_audit_2026_04_30.md`
- `wiki/log.md`

Key additions:
- Reconciled rejected fiche identities against authoritative Zenodo/Dryad API records and explicit JSONL line numbers.
- Added single-record evidence manifests to avoid ambiguity from multi-record JSONL files.
- Filled verified linked-paper DOI fields where found: Dryad habitat suitability, STEHME/HOLSEA Norway, IMF By, and cranial modifications.
- Marked the Linear Pottery linked publication DOI as `unknown_not_found` after lookup rather than leaving a vague unknown.
- Added local data-inspection facts for NetCDF dimensions, CSV headers, row counts, and GraphML node/edge counts where available.
- Updated the R estimator backend audit to reflect the `Code_scrapping/R/` relocation and added source traceability plus quality pedigree.

## [2026-05-12] policy | scientific paper ingestion scope

Pages consulted:
- `AGENTS.md`

Output filed: yes - policy update only

Files updated:
- `AGENTS.md`
- `wiki/log.md`

Key additions:
- Added a scientific-paper ingestion policy: only ingest papers that provide access information for a spatial or spatio-temporal dataset and include modeling evidence behind the dataset.
- Clarified that paper discovery should first capture paper DOI, dataset DOI/access route, data-availability excerpt, and modeling evidence, without immediately scraping or downloading datasets unless requested.
- Reaffirmed that paper DOI and dataset DOI must remain separate.

## [2026-05-12] curation | paper fiche canonical fields

Pages consulted:
- `wiki/papers/iturbide_2020_ipcc_regions.md`
- `data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json`

Output filed: yes - paper fiche enrichment only

Files updated:
- `wiki/papers/iturbide_2020_ipcc_regions.md`
- `wiki/log.md`

Key additions:
- Added explicit canonical fields for Tier 1: `Paper title`, `Paper DOI`, `Source URL`, `Abstract`, and `Dataset Linkage`.
- Kept paper DOI `10.5194/essd-12-2959-2020` separate from dataset/archive DOI `10.5281/zenodo.3998463`.

## [2026-05-12] policy | canonical scientific paper fiche format

Pages consulted:
- `AGENTS.md`

Output filed: yes - policy update only

Files updated:
- `AGENTS.md`
- `wiki/log.md`

Key additions:
- Added a canonical `wiki/papers/` fiche format for scientific papers.
- Required exact field names: `Paper title`, `Paper DOI`, `Source URL`, `Abstract`, `Dataset Linkage`, `Modeling Evidence`, `Dataset Access Decision`, and `Quality Pedigree`.
- Clarified that paper DOI and dataset/archive DOI must remain separate and that a paper without usable dataset access should not become a project paper fiche.
