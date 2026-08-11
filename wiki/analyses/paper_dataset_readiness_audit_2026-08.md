---
title: Paper dataset readiness audit 2026-08
type: analysis
created: 2026-08-08
updated: 2026-08-08
sources:
  - inst/kg/paper_dataset_uses.json
  - data/raw/papers/
  - data/final_datasets/sf/paper_*.rds
  - wiki/datasets/fiches_datasets/paper_*.md
  - corpus/papers/tei/
tags: [paper-datasets, audit, benchmark, spatialtidymodels, kg]
---

# Paper dataset readiness audit 2026-08

## Executive summary

This audit separates three different notions that were mixed in the first pass:

1. **Candidate validated bibliographically**: the paper and a data source exist.
2. **Raw data downloaded**: a local folder exists in `data/raw/papers/`.
3. **Benchmark-ready dataset**: the local `.rds` contains a defensible response, covariates, spatial support, and a formula/model specification compatible with `spatialtidymodels`.

The current state is therefore expected but must be made explicit:

- Raw paper data folders: **28**.
- Converted paper sf datasets: **22**.
- Paper dataset fiches: **22**.
- Directly or almost benchmark-ready continuous-regression candidates: **2 to 3**, depending on whether simulations and non-geographic W are allowed (paper_mammals_sr_pd, paper_cluster_detection, paper_wald_test).
- Most other datasets are not useless; they are **out of scope for the current continuous spatial regression package** or need preprocessing before benchmark use.

## Main failures found

| Failure | Consequence | Correction applied |
|---|---|---|
| DataCite/OpenAlex validation was treated as benchmark validation | Downloaded datasets entered the KG as if they were close to model-ready | Added explicit `benchmark_readiness` status in paper fiches |
| The generator did not encode readiness | Future regenerated fiches could lose Claude's curation signals | Updated `code/r_catalog/generate_fiches_papers.R` with `PAPER_READINESS` and `benchmark_readiness` output |
| Package metadata export ignored readiness | `spatialtidymodels` could not distinguish documentation candidates from usable benchmark datasets | Updated `code/package_metadata/export_spatialtidymodels_metadata.py` to parse `benchmark_readiness` |
| Formula extraction was not enough | Some formulas were allometry, SDM, generic model equations, or unavailable for the local extracted table | Readiness now records missing response/covariates/W or task mismatch |
| Raw folders and converted datasets diverged | 28 raw folders but 22 final .rds files; one raw downloaded dataset has no loader yet | Added this audit table and flagged raw-without-loader cases |

## Readiness table

| Dataset/source | Raw status | Benchmark status | Package include | Main gap | Next step |
|---|---|---|---|---|---|
| paper_cluster_detection | converted_to_sf | almost_ready_simulation | manual_review | dataset simulated, not an empirical geographic benchmark | decide if simulation benchmarks are allowed; otherwise keep as method validation only |
| paper_mammals_sr_pd | converted_to_sf | almost_ready | manual_review | needs one canonical SR/PD benchmark formula | choose SR or PD target and verify variable names against paper/code |
| paper_wald_test | converted_to_sf | needs_original_W | manual_review | paper W is political/institutional, not geographic KNN | extract original W or mark as non-geographic-W benchmark |
| paper_uk_photovoltaic | converted_to_sf | needs_preprocessing | no | paper uses 134 NUTS3; current extraction has 380 LAD and lacks SDM covariates | rebuild from NUTS3 and join paper covariates |
| paper_medicago | converted_to_sf | needs_model_specification_review | manual_review | GWR confirmed but no single empirical formula has been fixed | review TEI/tables/code to select a defensible formula |
| paper_eberg | converted_to_sf | not_ready_current_package | no | soil classification/OGC covariates, not current continuous regression | keep for future classification or OGC-covariate module |
| paper_hummingbird_sdm | converted_to_sf | not_ready_current_package | no | integrated species distribution model, not continuous regression | future SDM/presence-only route only |
| paper_crane | converted_to_sf | not_ready_current_package | no | binary response and temporal structure | future binary/panel support |
| paper_regulatory_convergence | converted_to_sf | not_ready_current_package | no | panel political-economy dataset with institutional W | future panel spatial econometrics route |
| paper_waste_site | converted_to_sf | not_ready_current_package | no | meta-regression rows are estimates, not spatial observations | exclude from spatial observation benchmark |
| paper_pm25_grid | converted_to_sf | not_ready_prediction_product | no | prediction grid output, no raw Y/X observations | find original monitoring observations and covariates |
| paper_no2_grid | converted_to_sf | not_ready_prediction_product | no | prediction grid output, no raw Y/X observations | find original monitoring observations and covariates |
| paper_o3_grid | converted_to_sf | not_ready_prediction_product | no | prediction grid output, no raw Y/X observations | find original monitoring observations and covariates |
| paper_beta0_gwr | converted_to_sf | not_ready_derived_response | no | response is already a GWR-derived beta coefficient | find original empirical response/covariates |
| paper_ethiopia_clusters | converted_to_sf | not_ready_derived_clusters | no | SaTScan cluster output, not original malnutrition observations | recover DHS/GWR source data or exclude |
| paper_pallid_bat | converted_to_sf | needs_covariate_join | no | NPP and climate covariates from the SAR paper are not joined | join NPP/climate variables or keep unavailable |
| paper_swiss_rainfall | converted_to_sf | not_ready_geostatistical_univariate | no | univariate geostatistical interpolation dataset | future kriging/interpolation track |
| paper_vindum | converted_to_sf | not_ready_geostatistical_univariate | no | univariate/geostatistical soil dataset without covariates | future kriging/interpolation track |
| paper_biomass_rainforest | converted_to_sf | needs_response_reconstruction | no | AGB/AGC target missing; only allometry inputs are extracted | reconstruct/extract AGB/AGC and join environmental covariates |
| paper_metacomnet | converted_to_sf | not_ready_current_package | no | RF occurrence/network task, not continuous regression | future classification/count route |
| paper_maipo | converted_to_sf | not_ready_current_package | no | crop type multiclass classification | future classification route |
| DataCite_2021_AboveGroundCarbonStock_10_1080_17583004 | raw_without_loader | needs_loader_review | no | raw folder exists but no sf loader/final fiche yet | inspect source files and decide whether it is distinct from biomass_rainforest or usable |
| DataCite_2019_SpatialDistributionOfWood_10_1590_0001_376 | tei_present_needs_curation | needs_manual_curation | no | paper/source not converted to sf | review source and only build loader if true Y/X spatial data exists |
| DataCite_2018_ConstruODeUm_10_1590_0034_761 | tei_present_needs_curation | needs_manual_curation | no | paper/source not converted to sf | review source and only build loader if true Y/X spatial data exists |
| DataCite_2019_DeterminantsAndSpatialDependence_10_1590_0103_635 | tei_present_needs_curation | needs_manual_curation | no | paper/source not converted to sf | review source and only build loader if true Y/X spatial data exists |
| DataCite_2019_OImpactoDasCooperativas_10_1590_1806_947 | tei_present_needs_curation | needs_manual_curation | no | paper/source not converted to sf | review source and only build loader if true Y/X spatial data exists |
| DataCite_2022_ModelSelectionAndModel_10_1080_07474938 | rejected_no_novel_data_but_raw_present | excluded | no | raw folder remains although manifest marks rejected_no_novel_data | decide whether to delete raw staging folder or keep outside benchmark path |

## What should not be promoted automatically

The following classes should stay out of `spatialtidymodels` automatic benchmarks until a dedicated route exists:

- Prediction products: PM2.5, NO2, O3 grids.
- Derived model outputs: beta0 GWR grid, SaTScan clusters.
- Meta-analysis datasets: waste-site effect estimates.
- Classification/binary/panel tasks: Maipo, crane, MetacomNet, regulatory convergence.
- Geostatistical univariate interpolation: Swiss rainfall, Vindum.
- Datasets missing essential paper variables: Pallid bat, biomass rainforest, UK photovoltaic.

## Practical next steps

1. Keep paper_mammals_sr_pd, paper_cluster_detection, and paper_wald_test as manual-review candidates only.
2. Rebuild or enrich high-value blocked datasets before benchmarking: paper_uk_photovoltaic, paper_pallid_bat, paper_biomass_rainforest.
3. Review raw-without-loader datasets before creating any new fiche.
4. Only export paper-derived datasets to package metadata when `package_include: "yes"` or after an explicit manual decision.
5. Add a CI/check script later that fails if a paper-derived fiche has no `benchmark_readiness` block.
