---
title: Scientific data-linked papers shortlist
type: analysis
created: 2026-04-27
updated: 2026-04-27
sources:
  - wiki/analyses/raw_spatiotemporal_dataset_scraping_targets_2026_04_23.md
  - data/manifests/download_batches/2026-04-23_final_download_batch_datasets10_papers10.json
tags: [papers, datasets, data-descriptors, spatio-temporal, discovery]
---

Shortlist of 10 scientific papers linked to explicit datasets or reusable data assets, selected from the local wiki targets and verified against publication or dataset pages.

## Selection Logic

- Prefer papers with an explicit dataset, data descriptor, DOI, repository, or official data availability section.
- Prioritize spatio-temporal datasets: grids, stations, trajectories, traffic networks, vessel tracks, or satellite patches.
- Keep method papers only when they are strongly tied to named public benchmark datasets.
- Record whether the paper is already downloaded in the local batch.

## Shortlist

| Rank | Paper | Data link | Why it fits | Local status |
|---:|---|---|---|---|
| 1 | Hoehn et al. (2025), "A Spatio-Temporal Dataset for Satellite-Based Landslide Detection", Scientific Data, DOI `10.1038/s41597-025-06167-2` | Sen12Landslides; Hugging Face / NetCDF patch archives | Data descriptor for multi-modal, multi-temporal Sentinel-1/Sentinel-2/DEM landslide patches with event dates and spatial metadata. | attempted earlier; response rejected, not valid PDF |
| 2 | Zhang et al. (2024), "High resolution spatiotemporal modeling of long term anthropogenic nutrient discharge in China", Scientific Data, DOI `10.1038/s41597-024-03102-9` | MEANS-ST1.0; Figshare data in GeoTIFF, NetCDF, Excel | Data descriptor for 1 km monthly nutrient discharge data in China from 1980 to 2020. | attempted earlier; response rejected, not valid PDF |
| 3 | Kim et al. (2025), "A large-scale dataset for training deep learning segmentation and tracking of extreme weather", Scientific Data, DOI `10.1038/s41597-025-05480-0` | Extreme-weather segmentation/tracking dataset | Data descriptor for gridded atmospheric event segmentation and tracking; high-dimensional spatio-temporal ML benchmark. | attempted earlier; response rejected, not valid PDF |
| 4 | Strohmeier et al. (2021), "Crowdsourced air traffic data from the OpenSky Network 2019-2020", Earth System Science Data, DOI `10.5194/essd-13-357-2021` | OpenSky / Zenodo dataset DOI `10.5281/zenodo.3931948` | Data description paper for global flight movements, airports, aircraft, and monthly CSV archives. | downloaded PDF |
| 5 | Hersbach et al. (2020), "The ERA5 global reanalysis", Quarterly Journal of the Royal Meteorological Society, DOI `10.1002/qj.3803` | ERA5 / Copernicus Climate Data Store | Canonical reference paper for global reanalysis data with spatial grid and long temporal coverage. | not in final paper batch |
| 6 | Menne et al. (2012), "An Overview of the Global Historical Climatology Network-Daily Database", Journal of Atmospheric and Oceanic Technology, DOI `10.1175/JTECH-D-11-00103.1` | GHCN-Daily / NOAA | Dataset overview for global station-level daily climate observations. | attempted earlier; empty response rejected |
| 7 | de Baar et al. (2023), "Recent improvements in the E-OBS gridded data set for daily mean wind speed over Europe in the period 1980-2021", Advances in Science and Research, DOI `10.5194/asr-20-91-2023` | E-OBS gridded meteorological data | Paper tied to E-OBS daily gridded data, with wind-speed extension and European spatial coverage. | E-OBS paper PDF downloaded under ESSD/related target |
| 8 | Kroodsma et al. (2018), "Tracking the global footprint of fisheries", Science, DOI `10.1126/science.aao5646` | Global Fishing Watch fishing effort and vessel identity data | Uses AIS-derived global fishing effort data and provides linked data/code access through Global Fishing Watch. | not in final paper batch |
| 9 | Li et al. (2018), "Diffusion Convolutional Recurrent Neural Network: Data-Driven Traffic Forecasting", ICLR | METR-LA and PEMS-BAY traffic datasets | Method paper strongly linked to public road-network traffic benchmarks with temporal sensor observations. | downloaded as DCRNN PDF |
| 10 | Yu et al. (2018), "Spatio-Temporal Graph Convolutional Networks: A Deep Learning Framework for Traffic Forecasting", IJCAI, DOI `10.24963/ijcai.2018/505` | Real-world traffic forecasting datasets including PeMS-style networks | Method paper directly tied to spatio-temporal graph traffic datasets. | downloaded as STGCN PDF |

## Notes for Follow-up

- The first three Scientific Data papers are the strongest "data paper" candidates but the previous automated PDF download returned HTML or blocked responses. They should be re-downloaded from the article pages or harvested through publisher-safe links.
- Papers 4, 5, 6, 7, and 8 are strong dataset-reference papers for the system's metadata catalog.
- Papers 9 and 10 are lower-priority as data descriptors, but useful as benchmark/model links because they define or popularize traffic datasets used in spatio-temporal modeling.
- If promoted into the registry, each paper should become a structured paper record with fields for `publication_doi`, `linked_dataset`, `data_availability_url`, `license`, and `local_pdf_status`.

## Related Pages

- [[raw_spatiotemporal_dataset_scraping_targets_2026_04_23]]
- [[download_batch_2026_04_23_datasets10_papers10]]
- [[dataset_ranking_metadata_spatial_download_priority_2026_04_22]]
- [[catalog_registry_schema_v3]]
- [[discovery_policy_v3]]
