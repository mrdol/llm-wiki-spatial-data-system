---
title: R_spData_house_house
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spData_house_house.rds
tags: [dataset, r-package, spatial, point]
---

Data on 25,357 single family homes sold in Lucas County, Ohio, 1993-1998 from the county auditor, together with an ‘nb’ neighbour object constructed as a sphere of influence graph from projected coordinates.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data on 25,357 single family homes sold in Lucas County, Ohio, 1993-1998 from the county auditor, together with an ‘nb’ neighbour object constructed as a sphere of influence graph from projected coordinates.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `price`, `avalue`
- Candidate Y typology: count
- Candidate X variables: `yrbuilt`, `stories`, `TLA`, `wall`, `beds`, `baths`, `halfbaths`, `frontage`, `depth`, `garage`, `garagesqft`, `rooms`, `lotsize`, `s1993`, `s1994`, `s1995`, `s1996`, `s1997`, `s1998`, `syear`, `age`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `price` | `integer` | count | [2000, 875000] | 0% |
| `avalue` | `integer` | count | [1714, 788114] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le prix de vente (price) est la cible naturelle d'un modèle hédonique immobilier ; la valeur cadastrale (avalue) peut aussi servir de variable réponse alternative. Les caractéristiques structurelles du logement (surface, chambres, salles de bain, garage, etc.), du terrain (frontage, depth, lotsize), de l'âge et de l'année de vente constituent les covariables explicatives classiques. Les colonnes sdate et T sont exclues car redondantes avec syear/s199x.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `yrbuilt` | `integer` | count | 0% |
| `stories` | `factor` | categorical | 0% |
| `TLA` | `integer` | count | 0% |
| `wall` | `factor` | categorical | 0% |
| `beds` | `numeric` | continuous | 0% |
| `baths` | `numeric` | continuous | 0% |
| `halfbaths` | `numeric` | continuous | 0% |
| `frontage` | `integer` | count | 0% |
| `depth` | `integer` | count | 0% |
| `garage` | `factor` | categorical | 0% |
| `garagesqft` | `integer` | count | 0% |
| `rooms` | `integer` | count | 0% |
| `lotsize` | `integer` | count | 0% |
| `s1993` | `integer` | binary | 0% |
| `s1994` | `integer` | binary | 0% |
| `s1995` | `integer` | binary | 0% |
| `s1996` | `integer` | binary | 0% |
| `s1997` | `integer` | binary | 0% |
| `s1998` | `integer` | binary | 0% |
| `syear` | `factor` | categorical | 0% |
| `age` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Pace, R. Kelley and Barry, Ronald (1997) Quick Computation of Spatial Autoregressive Estimators. Geographical Analysis

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage
- x_terms_used: yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage
- y_term_used: price

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage"
    response: "price"
    predictors: ["yrbuilt", "stories", "TLA", "wall", "beds", "baths", "halfbaths", "frontage"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_house_house`
- Dataset name: spData::house
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "price ~ yrbuilt + stories + TLA + wall + beds + baths + halfbaths + frontage"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 25357
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-83.8824, -83.2399], y [41.4169, 41.7323] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_validated_generated_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv"
  reason: "Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte; conserver la trace de validation dans data/manifests/datasets/package_generated_formula_validation_2026-08.csv
- Raison: Formule generee par le systeme mais validee contre le .rds local: reponse numerique, covariables presentes, model.frame executable et effectif suffisant.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
