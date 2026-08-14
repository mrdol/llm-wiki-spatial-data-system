---
title: R_spatstat.data_btb_btb
type: dataset
created: 2026-08-14
updated: 2026-08-14
sources:
  - data/final_datasets/sf/R_spatstat.data_btb_btb.rds
tags: [dataset, r-package, spatial, point]
---

Geospatial data of 873 farm locations with detected bovine tuberculosis in Cornwall, UK, over the years 1989-2002. This data-set was first analysed in Diggle, Zheng and Durr (2005).

## Description du jeu de donnees

- Topic: agriculture / rendement ou experimentation agronomique
- Observation unit: parcelle, placette experimentale ou observation agricole
- Observed population: observations agricoles documentees par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: dimension temporelle structurelle detectee
- Source description: Geospatial data of 873 farm locations with detected bovine tuberculosis in Cornwall, UK, over the years 1989-2002. This data-set was first analysed in Diggle, Zheng and Durr (2005).
- Description source: package R `spatstat.data`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `spoligotype`, `T`
- Candidate Y typology: categorical
- Candidate X variables: `year`
- Candidate X typology: categorical
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `spoligotype` | `factor` | categorical | None | 0% |
| `T` | `factor` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : Le spoligotype et T (vraisemblablement le type/cluster de la souche de tuberculose bovine) sont des variables réponse naturelles pour modéliser la distribution spatiale des souches pathogènes. L'année (year) est une covariable temporelle explicative pertinente pour capturer l'évolution de l'épidémie dans le temps.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - estimation non parametrique de segregation spatiale entre types de spoligotype de tuberculose bovine, pas une regression Y~X.
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Diggle, P.J., Zheng, P. and Durr, P. (2005) Nonparametric estimation of spatial segregation in a multivariate point process: bovine tuberculosis in Cornwall, UK. Applied Statistics 54, 645-658.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: not_applicable - estimation non parametrique de segregation spatiale entre types de spoligotype de tuberculose bovine, pas une regression Y~X.
- x_terms_used: pending
- y_term_used: pending

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

- Dataset ID: `R_spatstat.data_btb_btb`
- Dataset name: spatstat.data::btb
- Source family: r-package
- Source: package R `spatstat.data` (version 3.1.9)
- Source URL: https://CRAN.R-project.org/package=spatstat.data
- Dataset DOI: none
- Publication DOI: 10.1111/j.1467-9876.2005.05155.x
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "not_applicable - estimation non parametrique de segregation spatiale entre types de spoligotype de tuberculose bovine, pas une regression Y~X."
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Diggle, P.J., Zheng, P. and Durr, P. (2005) Nonparametric estimation of spatial segregation in a multivariate point process: bovine tuberculosis in Cornwall, UK. Applied Statistics 54, 645-658."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 873
- T periods: 14
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [136.4, 242.5], y [21.3, 116.9] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=spatstat.data
- License open: yes
- Reproducibility status: available via package R `spatstat.data`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `spatstat.data`
