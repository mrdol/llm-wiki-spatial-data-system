---
title: Geographically Weighted Regression
type: concept
created: 2026-06-02
updated: 2026-06-04
sources:
  - Fotheringham, Brunsdon and Charlton 2002, Geographically Weighted Regression
tags: [concept, spatial, gwr, local-regression, bandwidth]
---

GWR is a local regression framework where coefficients are estimated at
locations using distance-weighted observations.

## Definition

For observation `i` at location `s_i`, GWR can be summarized as:

```math
y_i = \beta_0(s_i) + \sum_j \beta_j(s_i)x_{ij} + \epsilon_i
```

Nearby observations receive higher weights according to a kernel and bandwidth.

## Modeling Relevance

GWR is useful when the relationship between `Y` and `X` is spatially
nonstationary. It should be compared against global regression and validated
with spatially aware folds.

## KG Relations To Expect

- `Method IMPLEMENTED_BY Package`
- `Dataset SHOWS_FORMULA Formula`
- `Formula USES_RESPONSE ResponseVariable`
- `Formula USES_COVARIATE Covariate`
- `Estimator USES_HYPERPARAMETER Bandwidth`

## Related Pages

- [[mgwr]]
- [[spatial_heterogeneity]]
- [[spatial_regression]]
- [[svc]]
