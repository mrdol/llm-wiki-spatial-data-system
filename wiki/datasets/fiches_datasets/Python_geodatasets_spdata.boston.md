---
title: Python_geodatasets_spdata.boston
type: dataset
created: 2026-08-11
updated: 2026-08-11
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.boston.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`boston`).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`boston`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `MEDV`, `CMEDV`, `median`, `CRIM`
- Candidate Y typology: continuous
- Candidate X variables: `ZN`, `INDUS`, `CHAS`, `NOX`, `RM`, `AGE`, `DIS`, `RAD`, `TAX`, `PTRATIO`, `B`, `LSTAT`, `POP`, `BB`, `units`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `LON`, `LAT`, `X`, `Y`
- Identifier columns (excluded from X candidates): `NOX_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `MEDV` | `numeric` | continuous | [5, 50] | 0% |
| `CMEDV` | `numeric` | continuous | [5, 50] | 0% |
| `median` | `numeric` | continuous | [5600, 50000] | 3.4% |
| `CRIM` | `numeric` | continuous | [0.0063, 88.9762] | 0% |


> Selection Y/X (claude-sonnet-4-6) : MEDV et CMEDV (valeur médiane des logements) sont les cibles classiques de ce benchmark immobilier, median en est une version alternative (en dollars absolus) ; CRIM (taux de criminalité) peut aussi être une variable réponse dans des études de sécurité urbaine. Les colonnes ZN, INDUS, CHAS, NOX, RM, AGE, DIS, RAD, TAX, PTRATIO, B, LSTAT, POP, BB et units sont des caractéristiques socio-économiques, environnementales et d'accessibilité typiquement utilisées comme covariables explicatives ; les colonnes de comptage de logements par tranche de prix (cu5k, c5_7_5, C7_5_10, etc.) et censored sont ignorées car redondantes avec MEDV/CMEDV ou purement descriptives de la distribution cible.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ZN` | `numeric` | continuous | 0% |
| `INDUS` | `numeric` | continuous | 0% |
| `CHAS` | `character` | categorical | 0% |
| `NOX` | `numeric` | rate | 0% |
| `RM` | `numeric` | continuous | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `DIS` | `numeric` | continuous | 0% |
| `RAD` | `numeric` | continuous | 0% |
| `TAX` | `numeric` | continuous | 0% |
| `PTRATIO` | `numeric` | continuous | 0% |
| `B` | `numeric` | continuous | 0% |
| `LSTAT` | `numeric` | continuous | 0% |
| `POP` | `integer` | count | 0% |
| `BB` | `numeric` | continuous | 0% |
| `units` | `integer` | count | 0% |


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

- formula_used: log(CMEDV) ~ CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + CHAS + I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B
- x_terms_used: CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + CHAS + I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B
- y_term_used: log(CMEDV)

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
    formula: "log(CMEDV) ~ CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + CHAS + I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B"
    response: "log(CMEDV)"
    predictors: ["CRIM", "I(RM^2)", "log(LSTAT)", "TAX", "ZN", "INDUS", "CHAS", "I(NOX^2)", "AGE", "log(DIS)", "log(RAD)", "PTRATIO", "B"]
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

- Dataset ID: `Python_geodatasets_spdata.boston`
- Dataset name: geodatasets::boston
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
  equation_text: "log(CMEDV) ~ CRIM + I(RM^2) + log(LSTAT) + TAX + ZN + INDUS + CHAS + I(NOX^2) + AGE + log(DIS) + log(RAD) + PTRATIO + B"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 506
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-71.4775, -70.689], y [42.049, 42.6364] (EPSG:4267)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4267
- CRS nom: NAD27
- CRS analyse recommande: 32619 (UTM Zone 19N (EPSG:32619)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
    notes: "Classic continuous hedonic regression benchmark."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: gamboost
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: random_forest
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: random_forest_xy
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: xgboost
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: xgboost_xy
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: sar_lag
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: sem_error
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: sdm_mixed
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: spboost_bspa_sar_ml
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: spboost_bspa_sar_cfe
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: spboost_bspa_sem_ml
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: spboost_bspa_sem_cfe
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: mgwrsar_gwr
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: MGWRSAR_0_kc_kv
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
  - estimator: MGWRSAR_1_kc_kv
    basis: benchmark_use
    source_ref: "Boston housing hedonic regression benchmark; package tests and benchmark metadata."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4267).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
