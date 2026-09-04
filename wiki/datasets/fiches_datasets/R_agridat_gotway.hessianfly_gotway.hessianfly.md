---
title: R_agridat_gotway.hessianfly_gotway.hessianfly
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_agridat_gotway.hessianfly_gotway.hessianfly.rds
tags: [dataset, r-package, spatial, point]
---

Hessian fly damage to wheat varieties

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Hessian fly damage to wheat varieties
- Description source: package R `agridat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `n`
- Candidate Y typology: count
- Candidate X variables: `gen`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `lat`, `long`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `n` | `integer` | count | [6, 20] | 0% |


> Note doc : response is binomial

> Selection Y/X (claude-sonnet-4-6) : n (count of damaged plants, range 6-20) is the natural response variable representing Hessian fly damage intensity. gen (wheat genotype/variety) is the key explanatory variable of interest. block is a design variable (experimental block) that is neither a meaningful target nor a standard spatial covariate, so it is ignored.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `gen` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: cbind(y, n-y) ~ gen + (1|block) + Matern(1|long+lat)
- x_terms_pub: gen
- y_term_pub: y/n (proportion de plants endommages, binomial(n))
- Reference publication: Gotway, C. A. and Stroup, W. W. (1997) A Generalized Linear Model Approach to Spatial Data Analysis and Prediction. Journal of Agricultural, Biological, and Environmental Statistics 2, 157-178.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: cbind(y, n-y) ~ gen + (1|block) + Matern(1|long+lat)
- x_terms_used: gen
- y_term_used: y/n (proportion de plants endommages, binomial(n))

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "cbind(y, n-y) ~ gen + (1|block) + Matern(1|long+lat)"
    response: "y/n (proportion de plants endommages, binomial(n))"
    predictors: ["gen"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Gotway, C. A. and Stroup, W. W. (1997) A Generalized Linear Model Approach to Spatial Data Analysis and Prediction. Journal of Agricultural, Biological, and Environmental Statistics 2, 157-178."
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

- Dataset ID: `R_agridat_gotway.hessianfly_gotway.hessianfly`
- Dataset name: agridat::gotway.hessianfly
- Source family: r-package
- Source: package R `agridat` (version 1.26)
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: 10.2307/1400401
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cbind(y, n-y) ~ gen + (1|block) + Matern(1|long+lat)"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Gotway, C. A. and Stroup, W. W. (1997) A Generalized Linear Model Approach to Spatial Data Analysis and Prediction. Journal of Agricultural, Biological, and Environmental Statistics 2, 157-178."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 64
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [1, 8], y [1, 8] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
