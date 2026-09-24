---
title: Python_geodatasets_spdata.boston
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.boston.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`boston`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_spdata.boston
- Observation unit: observation spatiale de type POINT
- Observed population: 506 enregistrements dans l’artefact local Python_geodatasets_spdata.boston.rds; unite declaree : house, real-estate transaction, or residential area. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-71.477517316028, -70.689020600411], y [42.04898645, 42.6363945]; CRS NAD27.
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

- formula_pub: CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT
- x_terms_pub: CRIM, ZN, INDUS, CHAS, NOX, RM, AGE, DIS, RAD, TAX, PTRATIO, B, LSTAT
- y_term_pub: CMEDV
- Reference publication: Harrison, D. & Rubinfeld, D.L. (1978). Hedonic housing prices and the demand for clean air. Journal of Environmental Economics and Management, 5(1), 81-102. Corrected coordinates/values per Gilley, O.W. & Pace, R.K. (1996), 'On the Harrison and Rubinfeld Data', JEEM 31(3), 403-405 (source of the CMEDV column).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: CRIM, ZN, INDUS, CHAS, NOX, RM, AGE, DIS, RAD, TAX, PTRATIO, B, LSTAT
- y_term_used: CMEDV

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT"
    response: "CMEDV"
    predictors: ["CRIM, ZN, INDUS, CHAS, NOX, RM, AGE, DIS, RAD, TAX, PTRATIO, B, LSTAT"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Harrison, D. & Rubinfeld, D.L. (1978). Hedonic housing prices and the demand for clean air. Journal of Environmental Economics and Management, 5(1), 81-102. Corrected coordinates/values per Gilley, O.W. & Pace, R.K. (1996), 'On the Harrison and Rubinfeld Data', JEEM 31(3), 403-405 (source of the CMEDV column)."
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

- Dataset ID: `Python_geodatasets_spdata.boston`
- Dataset name: geodatasets::boston
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: 10.1016/0095-0696(78)90006-2
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Harrison, D. & Rubinfeld, D.L. (1978). Hedonic housing prices and the demand for clean air. Journal of Environmental Economics and Management, 5(1), 81-102. Corrected coordinates/values per Gilley, O.W. & Pace, R.K. (1996), 'On the Harrison and Rubinfeld Data', JEEM 31(3), 403-405 (source of the CMEDV column)."
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

- Spatial resolution: point observation (derive d'un polygone source par reduction geometrique -- st_point_on_surface(), rien n'est perdu -- voir Type de geometrie et geom_origine)
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-71.4775, -70.689], y [42.049, 42.6364] (EPSG:4267)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : POLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
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
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles.

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
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (4267).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - groupe de versions suspectes `boston`; autres versions: R_spData_boston_boston.c
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`
- Duplicate/version candidate: [[R_spData_boston_boston.c]]

## Curation documentée — 2026-09-07

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
