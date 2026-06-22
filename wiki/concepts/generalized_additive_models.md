---
title: Generalized Additive Models
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - Hastie and Tibshirani 1990, Generalized Additive Models
  - Wood 2017, Generalized Additive Models: An Introduction with R, doi:10.1201/9781315370279
  - https://cran.r-project.org/package=mgcv
tags: [concept, gam, smoothing, additive-model]
---

Generalized additive models represent the predictor as a sum of smooth
functions. They are interpretable nonlinear baselines for regression,
classification and count modeling.

## Definition

```math
g(E[Y_i]) = \beta_0 + \sum_j f_j(x_{ij})
```

The functions `f_j` are estimated smooth terms. The response family and link
function determine the likelihood scale.

## Modeling Relevance

GAM is useful when nonlinear effects are expected but full black-box models are
not desired. Spatial coordinates can enter through a two-dimensional smooth, but
the model still needs spatial validation and residual checks.

## Related Pages

- [[gam]]
- [[gamboost]]
- [[mars]]
- [[spatial_regression]]
- [[data_leakage]]
