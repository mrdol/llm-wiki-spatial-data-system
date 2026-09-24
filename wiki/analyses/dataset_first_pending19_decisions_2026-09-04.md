---
title: Decisions sur les 19 dataset-first verified_pending_download
type: analysis
created: 2026-09-04
updated: 2026-09-04
sources:
  - data/manifests/papers/dataset_first_pending_download_19_candidates_2026-09-04.json
tags: [datasets, dataset-first, audit]
---

# Decisions sur les 19 dataset-first verified_pending_download

Cette revue suit la tentative de telechargement ciblee sur les fichiers tabulaires/vectoriels.

| DOI | Telechargement | Statut pipeline | Package | Note |
|---|---|---|---|---|
| `10.25349/d9x893` | `downloaded` | `pending_manual_large_archive_extraction` | `manual_review` | README describes nemo_full_1901_2019.csv with observations, coordinates and climate variables. Dryad exposes it only inside ECOG-06107_R2-data_package_04252022.rar (~3.1 GB), not as a separate CSV. |
| `10.5061/dryad.236j7` | `downloaded` | `rejected_low_priority_domain` | `no` | Spatial genome organization microscopy dataset, not geographic/spatial benchmark data for regression. |
| `10.5061/dryad.3n5tb2rqt` | `verified_pending_download` | `raw_data_subset_downloaded_pending_paper_review_and_loader` | `manual_review` | Small CSVs were downloaded (camera observations, monthly summaries, camera/CFU locations, LDF/extrapolation). Multi-GB simulation outputs were intentionally skipped; paper review must decide whether the compact tables support a defensible benchmark. |
| `10.5061/dryad.4qrfj6q6b` | `failed` | `rejected_low_priority_domain` | `no` | Genetic tagging/genotype uncertainty dataset; no directly downloadable tabular/vector file matched the benchmark filter. |
| `10.5061/dryad.69p8cz94j` | `downloaded` | `rejected_classification_no_geographic_yx` | `no` | Downloaded CSVs contain acoustic classification test sets with file/transect/species, but no geographic coordinates or regression Y/X table. |
| `10.5061/dryad.6m905qgc7` | `failed` | `rejected_out_of_scope_domain` | `no` | Temporal-spatial boiling/heat-flux engineering data; outside the target geographic benchmark scope. |
| `10.5061/dryad.9v46k` | `failed` | `rejected_spatiotemporal_occurrence_model` | `no` | Fish distribution/occurrence space-time model; no direct tabular/vector benchmark file matched the filter. |
| `10.5061/dryad.bk3j9kdk5` | `failed` | `rejected_raster_product_no_yx_table` | `no` | Global gross primary productivity product; no compact observation-level Y/X table was available through the targeted filter. |
| `10.5061/dryad.c2fqz61cv` | `failed` | `rejected_forecast_product` | `no` | Probabilistic severe-weather forecast product; outside cross-sectional spatial regression benchmark scope. |
| `10.5061/dryad.cb8gd26` | `verified_pending_download` | `rejected_low_priority_domain_large` | `no` | Large niche/phenotype evolution dataset, low-priority phylogenetic domain and too large for automatic ingestion. |
| `10.5061/dryad.k0p2ngfcc` | `verified_pending_download` | `rejected_out_of_scope_domain_large` | `no` | CODEX multiplexed biomedical imaging dataset; not geographic benchmark data. |
| `10.5061/dryad.nzs7h44s4` | `downloaded` | `rejected_out_of_scope_tracking_data` | `no` | README describes fly/mouse pose tracking Parquet data; this is not geographic spatial regression data and only README was downloaded. |
| `10.5061/dryad.r4xgxd2tm` | `failed` | `rejected_spatiotemporal_remote_sensing_product` | `no` | Diurnal surface-energy-flux estimation is spatiotemporal remote sensing, not a compact cross-sectional Y/X benchmark. |
| `10.5061/dryad.tdz08kq33` | `failed` | `rejected_sequence_data` | `no` | Environmental DNA sequencing/raw metabarcoding data; outside target benchmark scope. |
| `10.5061/dryad.v6wwpzhb8` | `failed` | `rejected_neuroscience_keyword_collision` | `no` | Neuroscience use of 'spatial'; explicit keyword collision, not geographic data. |
| `10.5281/zenodo.14965669` | `downloaded` | `raw_data_downloaded_pending_publication_link_and_loader` | `manual_review` | CSV contains density response, latitude/longitude and reference fields; next step is to select a defensible associated paper/source and write a loader. |
| `10.5281/zenodo.4090917` | `downloaded` | `pending_targeted_subset_download` | `manual_review` | Only a model-results text file was downloaded. The full iSDAsoil product is huge; select a useful variable/area/depth subset before ingestion. |
| `10.5281/zenodo.7298913` | `failed` | `large_dataset_manual_subset_required` | `manual_review` | DEM uncertainty dataset remains too large or not directly tabular under the benchmark filter; requires paper/source review and targeted subset. |
| `10.6071/m3wm3g` | `failed` | `rejected_spatiotemporal_raster_model` | `no` | High-resolution snow model/time-varying raster product; outside default cross-sectional benchmark scope. |


## Related Pages

Aucune fiche wiki associee a ce rapport ; se referer aux sources listees en frontmatter.
