---
title: SpatialML GRF
type: estimator
created: 2026-07-23
updated: 2026-07-23
sources:
  - https://www.rdocumentation.org/packages/SpatialML/versions/1.8.2/topics/SpatialML-package
  - https://www.rdocumentation.org/packages/SpatialML/versions/1.8.2/topics/grf.bw
  - https://www.rdocumentation.org/packages/SpatialML/versions/1.8.2/topics/predict.grf
  - https://CRAN.R-project.org/package=SpatialML
tags: [estimator, spatial, random-forest, geographically-weighted, package-supported]
---

SpatialML GRF designe la route `SpatialML::grf()`, c'est-a-dire une
Geographical Random Forest. Elle adapte le principe de Random Forest a une
prediction locale: le package ajuste une foret globale et des forets locales
construites autour des observations dans l'espace.

## Summary

GRF est pertinent quand la relation entre `Y` et `X` est non lineaire et que
cette relation peut varier spatialement. Dans `spatialtidymodels`, cette route
sert de baseline spatiale non parametrique entre Random Forest classique,
Random Forest + coordonnees et les modeles GWR/MGWRSAR.

## Estimator Family

- Family: Random Forest localise / geographically weighted machine learning.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Implementation route: R package `SpatialML`.
- Current package route: `spatialml_grf` in `benchmark_spatial()`.

## Model Equation

GRF n'a pas une equation parametrique unique du type OLS. Le principe est:

```math
\hat{y}_i = \hat{f}_{local(i)}(x_i)
```

ou `f_local(i)` est une foret estimee sur un voisinage spatial autour de
l'observation `i`. Le voisinage est controle par un bandwidth et un noyau.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | continuous numeric response | current benchmark route targets regression |
| Predictors `X` | numeric or encoded variables | Random Forest backend |
| Coordinates | two coordinate columns | used to define local neighborhoods |
| Spatial support | points or centroids | needed for local fitting and prediction |

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| `SpatialML` package documentation | implementation_supported | `grf()`, `grf.bw()`, `predict.grf()` API |
| GRF methodological literature | paper_supported | local Random Forest idea |
| Project wrapper | implementation_supported | `benchmark_spatial(estimator = "spatialml_grf")` |

## Main Use Cases

- Nonlinear spatial prediction with local model adaptation.
- Benchmark against `random_forest`, `random_forest_xy`, GWR and MGWRSAR.
- Detect whether local nonparametric structure improves residual Moran's I.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `bandwidth` | local neighborhood size | yes | adaptive kernel: number of nearest observations |
| `kernel` | local weighting scheme | later | current package route uses adaptive kernel behavior |
| `ntree` | number of trees | later | currently fixed in benchmark wrapper |
| `mtry` | candidate variables per split | later | can be optimized with SpatialML helpers |

## Current Package Status

- `SpatialML` is now a required dependency of `spatialtidymodels`.
- The benchmark route fits `SpatialML::grf()` and predicts with `predict.grf()`.
- Full parsnip spec is not yet exposed; current stable entry point is
  `benchmark_spatial()` / `benchmark_spatial_dataset()`.

