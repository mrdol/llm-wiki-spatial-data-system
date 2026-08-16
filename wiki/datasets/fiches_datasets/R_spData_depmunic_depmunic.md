---
title: R_spData_depmunic_depmunic
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spData_depmunic_depmunic.rds
tags: [dataset, r-package, spatial, point]
---

The geographic boundaries of departments (sf) of the municipality of Athens. This is accompanied by various characteristics in these areas.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: The geographic boundaries of departments (sf) of the municipality of Athens. This is accompanied by various characteristics in these areas.
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `airbnb`, `pop_rest`
- Candidate Y typology: continuous
- Candidate X variables: `museums`, `population`, `greensp`, `area`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `airbnb` | `numeric` | continuous | [144, 2171] | 0% |
| `pop_rest` | `numeric` | continuous | [2735, 16531] | 0% |


> Selection Y/X (claude-sonnet-4-6) : airbnb (densité de locations touristiques) et pop_rest (population résidente restante ou flottante) sont des variables-réponses plausibles reflétant des phénomènes socio-économiques à expliquer. museums, population, greensp et area constituent des covariables explicatives caractérisant l'attractivité, la démographie et la morphologie des départements athéniens. num_dep est un identifiant ordinal sans valeur explicative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `museums` | `numeric` | continuous | 0% |
| `population` | `numeric` | continuous | 0% |
| `greensp` | `numeric` | continuous | 0% |
| `area` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j
- x_terms_pub: x_{i,j} (lower-level covariates), z_j (higher-level covariates), W_i (lower-level spatial weights matrix), M_j (higher-level spatial weights matrix)
- y_term_pub: y_{i,j} (outcome for lower-level unit i in higher-level unit j)
- Reference publication: Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j
- x_terms_used: x_{i,j} (lower-level covariates), z_j (higher-level covariates), W_i (lower-level spatial weights matrix), M_j (higher-level spatial weights matrix)
- y_term_used: y_{i,j} (outcome for lower-level unit i in higher-level unit j)

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j"
    response: "y_{i,j} (outcome for lower-level unit i in higher-level unit j)"
    predictors: ["x_{i,j} (lower-level covariates), z_j (higher-level covariates), W_i (lower-level spatial weights matrix), M_j (higher-level spatial weights matrix)"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis."
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

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

- Dataset ID: `R_spData_depmunic_depmunic`
- Dataset name: spData::depmunic
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: 10.1111/gean.12049
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "y_{i,j} = rho * W_i * y + x'_{i,j} * beta + z'_j * gamma + theta_j + epsilon_{i,j}; theta_j = lambda * M_j * theta + mu_j"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Dong, G. and Harris, R. (2014) Spatial Autoregressive Models for Geographically Hierarchical Data Structures. Geographical Analysis."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 7
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [23.7042, 23.7657], y [37.9625, 38.0204] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32634 (UTM Zone 34N (EPSG:32634)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
  benchmark_status: "not_ready_too_small"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "n < 10 observations"
  reason: "Le jeu est trop petit pour une validation spatiale stable."
```

- Decision: not_ready_too_small
- Manque principal: n < 10 observations
- Raison: Le jeu est trop petit pour une validation spatiale stable.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
