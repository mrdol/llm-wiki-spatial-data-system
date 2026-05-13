---
title: Open Access Publication Dataset Methods Scraping 2026-05-12
type: analysis
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/oa_dataset_methods_batch_2026_05_12.jsonl
  - data/manifests/papers/oa_dataset_methods_links_2026_05_12.json
  - data/manifests/papers/oa_dataset_methods_enriched_2026_05_12.json
tags:
  - analysis
  - discovery
  - scraping
  - paper-linked-dataset
  - methods
---

Scraping open-access-oriented de publications susceptibles de pointer vers des datasets reutilisables et de documenter une methode.

## Scope

- Sources utilisees: OpenAlex et landing pages ouvertes accessibles.
- Sources non scrapees directement:
  - ResearchGate: pas d'API publique stable pour ingestion batch.
  - ScienceDirect: pas scrape directement sans route API Elsevier ou droit d'acces explicite.
- Objectif: produire un lot de candidats, pas des fiches dataset finales.

## Outputs

- Candidate manifest: `data/manifests/papers/oa_dataset_methods_batch_2026_05_12.jsonl`
- Link extraction manifest: `data/manifests/papers/oa_dataset_methods_links_2026_05_12.json`
- Enriched manifest: `data/manifests/papers/oa_dataset_methods_enriched_2026_05_12.json`
- Enriched CSV: `data/manifests/papers/oa_dataset_methods_enriched_2026_05_12.csv`

## Counts

- Raw paper records queried: 25
- Deduplicated paper records: 22
- Records with useful dataset/source links after filtering: 20
- Records with detected methods from title/abstract: 16

## Strong Candidate Examples

| Candidate | Dataset signal | Methods detected | Notes |
|---|---|---|---|
| SoilGrids250m: Global gridded soil information based on machine learning | SoilGrids250m / SoilGrids | random forest; gradient boosting; cross-validation; logistic regression | Strong spatial dataset candidate; global gridded soil properties. |
| SoilGrids 2.0: producing soil information for the globe with quantified spatial uncertainty | SoilGrids 2.0 / SoilGrids | machine learning; cross-validation; hyperparameter selection; uncertainty quantification | Strong open-access data-paper route through SOIL/Copernicus. |
| The CHRS Data Portal, an easily accessible public repository for PERSIANN global satellite precipitation data | PERSIANN / PERSIANN-CCS / PERSIANN-CDR / CHRS Data Portal | artificial neural network | Strong repository-style dataset paper in Scientific Data. |
| The world's user-generated road map is more than 80% complete | OpenStreetMap | multilevel regression and poststratification; sigmoid curves | Strong geospatial open-data candidate; method is explicit. |
| Compositional shifts in root-associated bacterial and archaeal microbiota track the plant life cycle in field-grown rice | Figshare data link detected | random forest | Dataset link present, but domain is microbiome/agronomy rather than core spatial econometrics. |
| TGVx: Dynamic Personalized POI Deep Recommendation Model | GitHub repository detected | machine learning / POI recommendation | Repository-backed model candidate; needs dataset access inspection. |

## Method Extraction Rule

Methods were detected by keyword patterns in title and abstract, not by full-paper reading. This is enough for discovery ranking, but not enough for final fiche claims.

Examples of detected method families:

- random forest
- gradient boosting
- machine learning
- spatial lag
- eigenvector spatial filtering
- LASSO feature selection
- geographically weighted regression
- spatial panel
- Bayesian meta-regression / DisMod-MR
- CNN / LSTM / RNN
- SVM / ANN / fuzzy logic
- multilevel regression and poststratification
- sigmoid-curve saturation modelling
- satellite-gauge merged analysis

## Next Curation Step

- Prioritize SoilGrids 2.0, PERSIANN/CHRS, OpenStreetMap completeness, and the spatial panel carbon-emissions paper for fiche generation.
- For each selected candidate, inspect only the official data/repository route, not generic PDF/social/publisher navigation links.
- Keep uncurated candidates in the manifest; do not insert them into `data/catalogue_datasets.json` until a dataset identity and access route are clear.

## Related Pages

- [[earth_system_science_data]]
- [[paper_linked_dataset_scraping_2026_05_11]]
