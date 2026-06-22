---
title: GAM
type: estimator
created: 2026-06-04
updated: 2026-06-04
sources:
  - Hastie and Tibshirani 1990, Generalized Additive Models
  - Wood 2017, Generalized Additive Models: An Introduction with R, doi:10.1201/9781315370279
  - mgcv R package documentation, https://cran.r-project.org/package=mgcv
tags: [estimator, gam, additive-model, smoothing, hyperparameters, paper-supported]
---

GAM is a generalized additive model estimator. It extends generalized linear
models by replacing some linear effects with smooth functions.

## Summary

GAM is useful when the relationship between `Y` and one or more predictors is
nonlinear but still should remain interpretable. In this project, it is a simple
and important baseline between global linear/GLM models and more flexible
methods such as MARS, GAMBoost, random forests, XGBoost and LightGBM.

GAM is not automatically spatial. It becomes spatial only if spatial coordinates,
spatial smooths, regional effects, lags, distance features or space-time smooths
are explicitly included and validated with an appropriate spatial or
spatio-temporal protocol.

## Estimator Family

- Family: generalized additive models.
- Project status: allowed baseline estimator.
- Main implementation route: R package `mgcv`.
- Related estimators: [[gamboost]], [[mars]], [[inla]], [[xgboost]],
  [[lightgbm]], [[random_forest]].

## Model Equation

Canonical GAM form:

```math
g(E[Y_i]) = \eta_i = \beta_0 + \sum_{j=1}^{p} f_j(x_{ij})
```

where:

- `g` is a link function;
- `f_j` are smooth functions or structured effects;
- the response distribution is chosen through the model family.

For spatial use, a two-dimensional smooth may be written as:

```math
g(E[Y_i]) = \beta_0 + f_1(x_{i1}) + \cdots + f_p(x_{ip}) + f_s(lon_i, lat_i)
```

This spatial smooth is a baseline for spatial trend, not a substitute for all
spatial dependence models.

## Data Structures It May Fit

- Continuous, binary, count or proportion responses depending on family/link.
- Cross-sectional tabular datasets.
- Spatial datasets with coordinates or areal features.
- Spatial panels after explicit temporal or unit effects.
- Moderate-size datasets where smooth terms remain interpretable.

## Hyperparameters To Optimize Or Record

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `family` | Response distribution | yes | Gaussian, binomial, Poisson, etc. |
| `link` | Mean-response link | yes | Must match `Y` type and interpretation. |
| smooth term choice | Which variables enter as `s()`, `te()`, `ti()` or linear terms | yes | Do not smooth every variable automatically. |
| basis dimension `k` | Maximum smooth complexity | yes | Too small underfits; too large raises cost and instability. |
| smoothing parameter | Penalizes wiggliness | yes | Usually estimated by REML/GCV; record method. |
| smooth basis type | Spline/basis family | later | Implementation-dependent, e.g. thin plate, cubic, tensor product. |
| interaction smooths | Multivariate smooth structure | yes if needed | Use for spatial or space-time surfaces. |
| method | REML, ML, GCV, etc. | yes | Prefer stable, reproducible choice. |

## Cross-validation Policy

For ordinary tabular data, use the project standard validation scheme. For
spatial or spatio-temporal datasets, use spatial blocks, leave-location-out,
temporal blocks or blocked space-time validation. Random folds can make a smooth
spatial trend look more predictive than it is.

## Diagnostics To Inspect

- Effective degrees of freedom for each smooth.
- Smooth plots and confidence bands.
- Residual spatial autocorrelation.
- Concurvity between smooth terms.
- Basis dimension checks.
- Train/validation gap under blocked validation.

## Failure Modes

- Treating `s(lon, lat)` as a complete spatial dependence model.
- Overfitting with excessive basis dimension.
- Underfitting when `k` is too small.
- Concurvity between smooths and spatial features.
- Leakage if smooths are tuned or interpreted only under random folds.

## Minimal Workflow

1. Identify `Y`, response family and link.
2. Fit GLM or linear baseline.
3. Add smooths only for variables with plausible nonlinear effects.
4. Add spatial or space-time smooths only when spatial/time structure is reliable.
5. Check effective degrees of freedom, residuals and blocked validation.
6. Compare against [[gamboost]], [[mars]], [[random_forest]], [[xgboost]] and
   [[lightgbm]] when prediction is the target.

## Related Pages

- [[generalized_additive_models]]
- [[gamboost]]
- [[mars]]
- [[inla]]
- [[xgboost]]
- [[lightgbm]]
- [[random_forest]]
- [[data_leakage]]
- [[spatial_regression]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
