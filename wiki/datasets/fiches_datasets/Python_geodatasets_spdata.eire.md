---
title: Python_geodatasets_spdata.eire
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.eire.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`eire`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`eire`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INCOME`, `POPCHG`, `RETSALE`
- Candidate Y typology: continuous
- Candidate X variables: `A`, `towns`, `pale`, `size`, `ROADACC`, `OWNCONS`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INCOME` | `numeric` | continuous | [5297, 164631] | 0% |
| `POPCHG` | `numeric` | continuous | [60, 142] | 0% |
| `RETSALE` | `numeric` | continuous | [1885, 89424] | 0% |


> Selection Y/X (claude-sonnet-4-6) : INCOME, POPCHG et RETSALE sont des variables socio-économiques classiquement utilisées comme cibles dans des modèles spatiaux (revenus, croissance démographique, ventes au détail). Les autres variables numériques (superficie A, taux d'urbanisation towns, indicateur historique pale, taille size, accessibilité routière ROADACC, occupation des logements OWNCONS) constituent des covariables explicatives plausibles ; la colonne names est ignorée car purement administrative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `A` | `numeric` | continuous | 0% |
| `towns` | `numeric` | rate | 0% |
| `pale` | `numeric` | binary | 0% |
| `size` | `numeric` | continuous | 0% |
| `ROADACC` | `numeric` | continuous | 0% |
| `OWNCONS` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: A ~ towns + pale
- x_terms_used: towns + pale
- y_term_used: A

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "A ~ towns + pale"
    response: "A"
    predictors: ["towns", "pale"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_spdata.eire`
- Dataset name: geodatasets::eire
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "A ~ towns + pale"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 26
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-101.7923, 125.2857], y [-70.305, 72.45] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — multi-zones (span=227.1deg) -- projection nationale recommandee

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready_small_n"
  benchmark_task: "regression_spatial_small_sample"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "valider un schema CV adapte aux petits echantillons"
  reason: "La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs."
```

- Decision: almost_ready_small_n
- Manque principal: valider un schema CV adapte aux petits echantillons
- Raison: La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
