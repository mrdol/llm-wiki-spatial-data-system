---
title: INLA
type: estimator
created: 2026-04-23
updated: 2026-07-06
sources:
  - OpitzINLA.pdf
  - Rue, Martino and Chopin 2009, Approximate Bayesian inference for latent Gaussian models by using integrated nested Laplace approximations
  - Lindgren, Rue and Lindstrom 2011, An explicit link between Gaussian fields and Gaussian Markov random fields: the stochastic partial differential equation approach
  - https://www.r-inla.org/
tags: [estimator, bayesian, spatial, latent-gaussian, spde, hyperparameters, paper-supported]
---

INLA is a deterministic approximate Bayesian inference framework for latent
Gaussian models. In this project it is relevant for spatial, areal,
geostatistical, hierarchical and spatio-temporal models where uncertainty and
latent structure matter.

## Summary

INLA approximates posterior marginals for latent Gaussian models without running
MCMC. The R-INLA ecosystem is especially important for spatial models because
SPDE formulations can represent continuous spatial fields through sparse
Gaussian Markov random fields.

## Estimator Family

- Family: approximate Bayesian inference for latent Gaussian models.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference methodology and R-INLA project documentation.
- Related concepts: latent Gaussian model, GMRF, SPDE, areal random effects.

## Model Equation

Generic latent Gaussian model:

```math
y_i \mid \eta_i,\theta \sim p(y_i \mid \eta_i,\theta)
```

```math
\eta_i = \alpha + x_i^\top\beta + \sum_k u_k(i)
```

where the latent field is Gaussian conditional on hyperparameters:

```math
x \mid \theta \sim N(0, Q(\theta)^{-1})
```

INLA approximates posterior marginals for latent components and
hyperparameters.

## Spatial Formulations

| Formulation | Dataset type | Notes |
|---|---|---|
| ICAR/BYM/BYM2 | areal data | Requires spatial adjacency or neighborhood graph. |
| SPDE Matern field | point or areal with coordinates/mesh | Requires mesh, CRS and prior choices. |
| Spatial econometric latent effects | areal/panel | Possible when latent model is implemented. |
| Space-time latent effects | spatial panels or gridded time series | Requires careful temporal structure and validation. |

## Data Structures It May Fit

- Areal disease mapping or regional indicators.
- Point-referenced spatial observations.
- Spatial panels with repeated units.
- Count, binary, Gaussian and other likelihood families supported by R-INLA.

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Rue, Martino and Chopin (2009) | paper_supported | INLA approximation for latent Gaussian models |
| Lindgren, Rue and Lindstrom (2011) | paper_supported | SPDE/GMRF spatial field construction |
| R-INLA documentation | implementation_supported | software API and families/effects |

## Main Use Cases

- Bayesian spatial regression with explicit uncertainty.
- Areal random effects such as ICAR/BYM/BYM2.
- Point-referenced spatial fields via SPDE meshes.
- Spatio-temporal latent Gaussian models when temporal structure is real.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `family` | Likelihood family | yes | Determined by response type. |
| `link` | Mean-response link | yes | Must match likelihood and interpretation. |
| spatial effect type | ICAR/BYM/SPDE/etc. | yes | Model-structure choice. |
| prior precision | Latent-effect shrinkage | yes | Must be recorded. |
| SPDE range prior | Spatial correlation scale | yes | Central for SPDE models. |
| SPDE variance prior | Field amplitude | yes | Record prior assumptions. |
| mesh resolution | Spatial discretization | yes | Accuracy-cost tradeoff. |
| temporal effect type | AR, RW, iid, interaction | yes if temporal | Only when time structure is real. |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| integration strategy | INLA approximation settings | later | implementation_supported | usually keep defaults first |
| control predictor settings | fitted value / linear predictor controls | no/later | implementation_supported | output control |
| posterior sampling settings | simulation from posterior | no/later | implementation_supported | diagnostic/reporting |

## Hyperparameter Interactions

- Mesh resolution and SPDE priors jointly determine the effective spatial field.
- Priors and likelihood family must be documented together; priors are not neutral defaults.
- Areal adjacency quality directly affects ICAR/BYM-style effects.

## Cross-validation Policy

Use spatial or spatio-temporal validation, not only posterior fit criteria. WAIC,
DIC, CPO and posterior predictive checks are useful, but they do not replace
out-of-sample validation when the goal is prediction.

## Diagnostics To Inspect

- Posterior marginals and credible intervals.
- Prior sensitivity.
- WAIC/DIC/CPO where appropriate.
- Posterior predictive checks.
- Residual spatial autocorrelation.
- Mesh sensitivity for SPDE models.

## Failure Modes

- Treating prior choices as neutral.
- Mesh too coarse or too fine.
- Using areal adjacency without checking geometry/topology.
- Comparing models by information criteria only when prediction transfer is the goal.
- Applying spatial effects to data without reliable spatial support.

## Minimal Tuning Workflow

1. Identify response type and likelihood.
2. Define spatial support: coordinates, mesh or adjacency.
3. Fit a non-spatial baseline.
4. Add spatial latent structure.
5. Record priors, mesh/adjacency, diagnostics and validation design.

## Dataset Compatibility Notes

- Compatible `Y`: Gaussian, count, binary and other R-INLA-supported likelihoods.
- Compatible `X`: fixed effects plus spatial/temporal indexing fields.
- Spatial requirement: adjacency for areal models or coordinates/mesh for SPDE models.
- Current benchmark note: INLA is allowed by policy but not yet wired in `benchmark_manual_test_2026-07.R`.
- Validation: posterior criteria do not replace external spatial or space-time validation.

## Open Questions From Papers

- Which INLA formulation should be the first benchmark route: BYM2, SPDE, or another latent spatial effect.
- How to standardize priors so results are comparable across datasets.
- How to expose INLA in the project without forcing a full `parsnip` wrapper immediately.

## Related Pages

- [[gam]]
- [[svc]]
- [[spatial_autocorrelation]]
- [[spatiotemporal_data]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
