---
title: Iturbide et al. 2020 - IPCC Climate Reference Regions
type: paper
created: 2026-05-11
updated: 2026-05-12
sources:
  - data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl
  - data/manifests/papers/paper_linked_dataset_links_2026_05_11.json
  - data/manifests/datasets/zenodo_3998463_ipcc_atlas_regions_2026_05_11.json
tags:
  - paper
  - dataset-source
  - essd
  - climate
  - spatial
  - spatiotemporal
  - reference-only
---

Paper source utilise pour identifier un dataset bien documente par l'approche publication scientifique -> depot de donnees.

## Identity

- Paper ID: `iturbide_2020_ipcc_regions`
- Paper title: An update of IPCC climate reference regions for subcontinental analysis of climate model data: definition and aggregated datasets
- Title: An update of IPCC climate reference regions for subcontinental analysis of climate model data: definition and aggregated datasets
- Authors: Maialen Iturbide, Jose Manuel Gutierrez, Lincoln Muniz Alves, Joaquin Bedia, Ruth Cerezo-Mota, Ezequiel Cimadevilla, Antonio S. Cofino, Alejandro Di Luca
- Year: 2020
- Venue: Earth System Science Data
- Paper DOI: `10.5194/essd-12-2959-2020`
- Publication DOI: `10.5194/essd-12-2959-2020`
- Source URL: https://doi.org/10.5194/essd-12-2959-2020
- Landing URL: https://doi.org/10.5194/essd-12-2959-2020

## Abstract

Several sets of reference regions have been used in the literature for regional synthesis of observed and modelled climate and climate-change information. This paper updates the IPCC WGI reference regions for subcontinental analysis of observed and simulated climate datasets, including CMIP6. It defines 46 land and 15 ocean regions as polygons, provides coordinates and shapefiles, and documents companion R and Python notebooks. It also describes a new dataset with monthly temperature and precipitation spatially aggregated over the new regions for CMIP5 and CMIP6, with future extension to other datasets. The regions, datasets, and code are made available through the ATLAS GitHub repository and Zenodo archive.

## Dataset Evidence

- Published data available: yes
- Dataset/archive DOI documented: `10.5281/zenodo.3998463`
- Repository documented: https://github.com/SantanderMetGroup/ATLAS
- Linked dataset page: [[zenodo_3998463_ipcc_atlas_regions]]
- Source page: [[earth_system_science_data]]

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `zenodo_3998463_ipcc_atlas_regions`
- Linked dataset page: [[zenodo_3998463_ipcc_atlas_regions]]
- Dataset/archive DOI: `10.5281/zenodo.3998463`
- Dataset source URL: https://zenodo.org/record/3998463
- Repository URL: https://github.com/SantanderMetGroup/ATLAS
- Linkage evidence: the paper abstract and data-availability text state that the regions, datasets, and code are freely available through the ATLAS GitHub repository and the Zenodo archive.

## Modeling Evidence

- Model family (paper): spatial aggregation over reference polygons — **non présent dans l'allowlist projet**
- Method evidence: le papier agrège des sorties CMIP5/CMIP6 (T et P mensuelles) sur 46 régions terrestres et 15 régions océaniques définies comme polygones. Il ne propose pas de régression, de boosting ni de modèle à coefficients variables.
- Lien avec estimateurs autorisés:
  - `MGWR` / `MGWRSAR` — les régions IPCC peuvent servir d'unités spatiales pour une régression géographiquement pondérée si un Y et des X sont définis sur ces unités. Plausibilité : **faible à nulle** — les régions sont trop grandes (continentales) pour GWR.
  - `STVC` — même logique : applicable seulement si les données agrégées constituent un panel spatio-temporel avec Y modélisable. Plausibilité : **nulle sans variable cible définie**.
  - `INLA` — possible en modèle climatique bayésien si les agrégats régionaux servent de Y. Plausibilité : **nulle dans le cadre projet actuel**.
  - `SpBoost` / `XGBoost` / `LightGBM` / `RF` / `MARS` — utilisables sur les agrégats comme features ou Y si une tâche de prédiction est définie. Plausibilité : **nulle — aucune tâche de prédiction documentée**.

```yaml
methodological_selection:
  estimator_assessment_status: assessed
  at_least_one_allowed_estimator_plausible: false
  estimator_policy_ref: wiki/metadata/restricted_estimator_policy_v1.md
  candidate_estimators:
    - estimator: MGWR
      plausible: false
      justification: "Les 46 regions IPCC sont des unites continentales. GWR/MGWR requiert des unites spatiales fines et nombreuses (N >> 46). Structure incompatible."
    - estimator: MGWRSAR
      plausible: false
      justification: "Meme contrainte que MGWR. N=46 insuffisant pour estimer une matrice W et des coefficients locaux stables."
    - estimator: INLA
      plausible: false
      justification: "Aucun Y defini dans le dataset. Les agregats T/P sont des outputs de modeles de circulation, pas des variables observees a predire dans le cadre projet."
    - estimator: SpBoost
      plausible: false
      justification: "Pas de structure panel N x T exploitable avec Y/X clairement definis. Dataset oriente geometrie de reference, pas regression."
```

## Extracted Relevance

- The paper defines updated IPCC WGI reference regions as polygons.
- It documents coordinates, shapefiles, companion R/Python notebooks, and a new dataset of monthly temperature and precipitation aggregated over regions.
- It explicitly links the regions, datasets, and code to the ATLAS GitHub repository and the Zenodo archive.

## Dataset Access Decision

- candidacy_status: `reference_only`
- Access decision: **rejeté pour modélisation** — aucun estimateur autorisé plausible
- Motif: le papier produit un référentiel géométrique (polygones IPCC) et des agrégats climatiques CMIP. Ni la structure du dataset (N=46 régions continentales, Y non défini) ni la méthode du papier (agrégation spatiale) ne correspondent à un estimateur de l'allowlist projet.
- Valeur résiduelle: le dataset peut servir de **référence spatiale externe** (unités géographiques, W matrix grossière) pour un autre dataset dont les unités seraient alignées sur les régions IPCC. Non candidat direct pour la modélisation.
- Next action: ne pas télécharger les fichiers Zenodo dans ce cadre. Conserver la fiche comme source de référence géographique uniquement.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_data_journal
  provenance_score: 5
  provenance_evidence: "The record comes from an Earth System Science Data article with DOI and explicit dataset/repository links."
  rigour_score: 5
  rigour_evidence: "The paper documents region definition, aggregation logic, data products, and worked examples."
  evidence_score: 5
  evidence_evidence: "OpenAlex metadata, DOI, article landing page, Zenodo DOI, and GitHub repository were captured."
  coherence_score: 5
  coherence_evidence: "The paper abstract and repository manifest consistently describe the ATLAS reference-region data products."
  claim_discipline_score: 4
  claim_discipline_evidence: "The paper is used as a dataset-source signal; local raw files still need inspection before modeling claims."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation counts were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[zenodo_3998463_ipcc_atlas_regions]]
- [[earth_system_science_data]]
- [[paper_linked_dataset_scraping_2026_05_11]]
