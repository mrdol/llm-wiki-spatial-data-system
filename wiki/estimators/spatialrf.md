---
title: spatialRF
type: estimator
created: 2026-07-23
updated: 2026-07-23
sources:
  - https://blasbenito.github.io/spatialRF/
  - https://www.rdocumentation.org/packages/spatialRF/versions/1.1.5/topics/rf_spatial
  - https://search.r-project.org/CRAN/refmans/spatialRF/html/00Index.html
  - https://CRAN.R-project.org/package=spatialRF
tags: [estimator, spatial, random-forest, moran-eigenvectors, package-supported]
---

`spatialRF` designe la route `spatialRF::rf_spatial()`. Elle part d'une Random
Forest classique et ajoute des predicteurs spatiaux, souvent bases sur des
Moran Eigenvector Maps, afin de capturer la structure spatiale non expliquee
par les covariables classiques.

## Summary

Dans ce projet, `spatialRF` est un estimateur utile quand on veut garder la
robustesse predictive d'une Random Forest tout en reduisant l'autocorrelation
spatiale residuelle. Il se place entre les baselines ML non spatiales et les
modeles econometriques spatiaux explicites.

## Estimator Family

- Family: Random Forest avec predicteurs spatiaux construits automatiquement.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Implementation route: R package `spatialRF`.
- Current package route: `spatialrf` in `benchmark_spatial()`.

## Model Equation

La forme pratique est:

```math
\hat{y}_i = RF(x_i, s_i)
```

ou `x_i` contient les covariables initiales et `s_i` contient des predicteurs
spatiaux derives de la matrice de distances ou de la structure spatiale. Ces
predicteurs servent de proxies pour les processus spatiaux absents de `X`.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | continuous numeric response | current benchmark route targets regression |
| Predictors `X` | numeric or encoded variables | Random Forest backend |
| Coordinates | two coordinate columns | used to build distance matrix and spatial predictors |
| Spatial support | points or centroids | required by the spatial predictor generation route |

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| `spatialRF` package documentation | implementation_supported | `rf_spatial()`, prediction and diagnostics |
| `spatialRF` tutorials/site | implementation_supported | intended workflow and interpretation |
| Project wrapper | implementation_supported | `benchmark_spatial(estimator = "spatialrf")` |

## Main Use Cases

- Random Forest with explicit spatial proxies.
- Reduction of residual spatial autocorrelation.
- Comparison with `random_forest_xy`, `spmoran_esf`, `spmoran_resf` and SAR/SEM.
- Variable importance after accounting for spatial structure.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `ntree` | number of trees | later | currently fixed in benchmark wrapper |
| `mtry` | candidate variables per split | later | handled by ranger/spatialRF arguments |
| spatial predictor method | MEM/PCA/Hengl strategy | later | current wrapper uses a conservative default |

## Current Package Status

- `spatialRF` is now a required dependency of `spatialtidymodels`.
- The benchmark route calls `spatialRF::rf_spatial()`.
- In-sample prediction is well supported through `spatialRF::get_predictions()`.
- Out-of-sample behavior depends on the upstream spatial predictor workflow and
  still needs stronger tests before being considered as mature as `random_forest`.

