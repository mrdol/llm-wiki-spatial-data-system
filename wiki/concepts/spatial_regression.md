---
title: Spatial Regression
type: concept
created: 2026-06-02
updated: 2026-06-04
sources: []
tags: [concept, spatial, regression, sar, sem, gwr, mgwr]
---

Spatial regression groups regression models that explicitly account for spatial
dependence, spatial heterogeneity, or both.

## Definition

Spatial regression is not one model. It includes several families:

| Family | Main idea | Examples |
|---|---|---|
| Spatial dependence | Dependence between neighboring observations or errors | SAR, SEM, SDM, SARAR |
| Spatial heterogeneity | Coefficients vary across space | GWR, MGWR, SVC |
| Spatial random effects | Latent spatial structure | CAR, BYM, SPDE/INLA |
| Spatial trend/smooth baselines | Smooth spatial or space-time trend terms | GAM, tensor-product smooths |
| Spatial feature baselines | Non-spatial ML using engineered spatial predictors | RF, XGBoost, LightGBM, SVM |

## Modeling Relevance

The dataset must identify `Y`, candidate `X`, spatial support and validation
design. A model is not spatially credible only because coordinates are present:
the model, features, residual diagnostics and validation must use the spatial
structure coherently.

## KG Relations To Expect

- `Dataset HAS_RESPONSE ResponseVariable`
- `Dataset HAS_COVARIATE Covariate`
- `Dataset SHOWS_FORMULA Formula`
- `Paper USES_METHOD Method`
- `Method IMPLEMENTED_BY Package`

## Related Pages

- [[spatial_autocorrelation]]
- [[spatial_heterogeneity]]
- [[gwr]]
- [[mgwr]]
- [[gam]]
- [[inla]]
