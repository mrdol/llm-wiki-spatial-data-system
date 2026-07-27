---
title: RandomForestsGLS
type: estimator
created: 2026-07-23
updated: 2026-07-23
sources:
  - https://www.rdocumentation.org/packages/RandomForestsGLS/versions/0.1.5/topics/RFGLS_estimate_spatial
  - https://search.r-project.org/CRAN/refmans/RandomForestsGLS/html/RFGLS_predict.html
  - https://rdrr.io/cran/RandomForestsGLS/f/inst/doc/RandomForestsGLS_user_guide.Rmd
  - https://CRAN.R-project.org/package=RandomForestsGLS
tags: [estimator, spatial, random-forest, gls, covariance, package-supported]
---

RandomForestsGLS designe la route `RandomForestsGLS::RFGLS_estimate_spatial()`.
Elle combine une fonction de regression non lineaire de type Random Forest avec
une correction GLS pour tenir compte de la dependance spatiale.

## Summary

Dans ce projet, RF-GLS est pertinent quand une Random Forest classique explique
bien la partie non lineaire `Y ~ X`, mais que les erreurs gardent une structure
spatiale. L'approche vise a estimer la fonction moyenne tout en modelisant une
covariance spatiale des residus.

## Estimator Family

- Family: Random Forest + generalized least squares spatial.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Implementation route: R package `RandomForestsGLS`.
- Current package route: `rfgls` in `benchmark_spatial()`.

## Model Equation

La structure conceptuelle est:

```math
y_i = f(x_i) + \epsilon_i
```

avec `f` estimee par Random Forest et une covariance spatiale pour
`\epsilon`. Le package utilise des approximations de type voisins les plus
proches / Vecchia pour rendre le calcul possible sur des donnees spatiales.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | continuous numeric response | RF-GLS spatial regression |
| Predictors `X` | numeric design matrix | backend expects `X` explicitly |
| Coordinates | numeric coordinate matrix | needed for spatial covariance |
| Spatial covariance model | exponential, matern, spherical or gaussian | controls residual dependence |

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| `RandomForestsGLS` package documentation | implementation_supported | `RFGLS_estimate_spatial()` and `RFGLS_predict()` |
| Package vignette | implementation_supported | known/unknown covariance parameter workflow |
| Project wrapper | implementation_supported | `benchmark_spatial(estimator = "rfgls")` |

## Main Use Cases

- Nonlinear regression with spatially correlated errors.
- Benchmark against Random Forest, SAR/SEM and SpBoost.
- Spatial prediction when residual covariance is meaningful.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `k_neighbors` / `n.neighbors` | nearest neighbors for approximation | yes | exposed through benchmark route |
| `ntree` | number of trees | later | currently fixed in benchmark wrapper |
| `mtry` | candidate variables per split | later | currently set from design matrix size |
| `cov.model` | spatial covariance family | later | default is exponential |

## Current Package Status

- `RandomForestsGLS` is now a required dependency of `spatialtidymodels`.
- The benchmark route builds `y`, `X` and `coords`, then calls
  `RFGLS_estimate_spatial()`.
- Prediction uses `RFGLS_predict()` with a model matrix matching the training
  formula.

