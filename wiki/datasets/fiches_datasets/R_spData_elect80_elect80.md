---
title: R_spData_elect80_elect80
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spData_elect80_elect80.rds
tags: [dataset, r-package, spatial, point]
---

A data set for 1980 Presidential election results covering 3,107 US counties using geographical coordinates. In addition, three spatial neighbour objects, ‘k4’ not using Great Circle distances, ‘dll’ using Great Circle distances, and ‘e80_queen’ of Queen contiguities for equivalent County polygons taken from file ‘co1980p020.tar.gz’ on the USGS Nat...

## Description du jeu de donnees

- Topic: elections et comportement electoral
- Observation unit: circonscription, bureau de vote ou unite administrative
- Observed population: resultats electoraux ou population votante
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A data set for 1980 Presidential election results covering 3,107 US counties using geographical coordinates. In addition, three spatial neighbour objects, ‘k4’ not using Great Circle distances, ‘dll’ using Great Circle distances, and ‘e80_queen’ of Queen contiguities for equivalent County polygons taken from file ‘co1980p020.tar.gz’ on the USGS Nat...
- Description source: package R `spData`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `pc_turnout`
- Candidate Y typology: continuous
- Candidate X variables: `pc_college`, `pc_homeownership`, `pc_income`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pc_turnout` | `numeric` | continuous | [0.047, 1.1053] | 0% |


> Selection Y/X (claude-sonnet-4-6) : pc_turnout (taux de participation électorale) est la variable réponse naturelle dans un contexte d'analyse des élections présidentielles de 1980. Les variables socio-économiques pc_college (niveau d'éducation), pc_homeownership (taux de propriété) et pc_income (revenu) sont des covariables explicatives classiques de la participation électorale ; FIPS est un code administratif ignoré.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `pc_college` | `numeric` | rate | 0% |
| `pc_homeownership` | `numeric` | rate | 0% |
| `pc_income` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pc_turnout ~ pc_college + pc_homeownership + pc_income (referencee dans catalogue)
- x_terms_pub: pc_college, pc_homeownership, pc_income
- y_term_pub: pc_turnout
- Reference publication: Pace, R.K. & Barry, R. (1997). Quick computation of spatial autoregressive estimators. Geographical Analysis, 29(3), 232-247. Data distributed via the Spatial Econometrics Toolbox for Matlab (files elect.dat/elect.ford) and packaged in R as spData::elect80.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: pc_turnout ~ pc_college + pc_homeownership + pc_income
- x_terms_used: pc_college, pc_homeownership, pc_income
- y_term_used: pc_turnout

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pc_turnout ~ pc_college + pc_homeownership + pc_income"
    response: "pc_turnout"
    predictors: ["pc_college, pc_homeownership, pc_income"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Pace, R.K. & Barry, R. (1997). Quick computation of spatial autoregressive estimators. Geographical Analysis, 29(3), 232-247. Data distributed via the Spatial Econometrics Toolbox for Matlab (files elect.dat/elect.ford) and packaged in R as spData::elect80."
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

- Dataset ID: `R_spData_elect80_elect80`
- Dataset name: spData::elect80
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
  existing_model_found: true
  equation_text: "pc_turnout ~ pc_college + pc_homeownership + pc_income"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Pace, R.K. & Barry, R. (1997). Quick computation of spatial autoregressive estimators. Geographical Analysis, 29(3), 232-247. Data distributed via the Spatial Econometrics Toolbox for Matlab (files elect.dat/elect.ford) and packaged in R as spData::elect80."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3107
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.2299, -67.61], y [25.1171, 48.8337] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

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
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`
