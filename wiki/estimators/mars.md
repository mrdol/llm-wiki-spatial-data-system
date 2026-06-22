---
title: MARS
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - Earth_MARS__a_note_on_earth.pdf
  - Friedman 1991, Multivariate Adaptive Regression Splines, doi:10.1214/aos/1176347963
tags: [estimator, mars, splines, hyperparameters, paper-supported]
---

MARS fits adaptive piecewise-linear spline models. In this project it is an
interpretable nonlinear baseline between linear regression and tree ensembles.

## Summary

MARS builds hinge-function basis terms in a forward pass and prunes them in a
backward pass. It can represent nonlinearities and low-order interactions while
remaining easier to inspect than boosted trees.

It is not inherently spatial. Spatial structure must be encoded through
coordinates, spatial lags, distances, regional effects or other engineered
features.

## Estimator Family

- Family: adaptive regression splines.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference paper.
- Core reference: Friedman (1991).

## Model Equation

```math
\hat{y}_i = \beta_0 + \sum_{m=1}^{M} \beta_m B_m(x_i)
```

where basis functions are hinge terms such as:

```math
\max(0, x_j - c), \quad \max(0, c - x_j)
```

Interactions are products of basis terms up to a specified degree.

## Data Structures It May Fit

- Continuous-response tabular regression.
- Classification only through implementation-specific extensions.
- Spatial datasets after feature engineering.
- Medium-size datasets where interpretability matters.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `degree` | Maximum interaction order | yes | Keep low unless validation supports interactions. |
| `nprune` | Number of retained terms | yes | Main post-pruning complexity control. |
| `nk` | Maximum candidate terms | yes | Upper bound during forward construction. |
| `penalty` | Complexity penalty | yes | Affects pruning and interaction cost. |
| `minspan` | Minimum spacing between knots | later | Stabilizes knot placement. |
| `endspan` | Boundary knot control | later | Helps avoid unstable edge knots. |

## Cross-validation Policy

Use the project validation scheme. For spatial datasets, tune term complexity
under spatially blocked validation rather than random folds.

## Diagnostics To Inspect

- Retained basis terms.
- Selected variables and knot locations.
- Validation error.
- Residual spatial autocorrelation.
- Extrapolation behavior outside observed covariate ranges.

## Failure Modes

- Too many terms causing unstable local fits.
- Boundary artifacts from knots near data extremes.
- Weak performance for highly discontinuous local processes.
- Spatial leakage if random folds are used.

## Minimal Tuning Workflow

1. Fit degree 1 with conservative `nk`.
2. Tune `nprune`.
3. Test degree 2 only if interactions improve blocked validation.
4. Inspect retained terms and residual maps.

## Related Pages

- [[gam]]
- [[random_forest]]
- [[xgboost]]
- [[data_leakage]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
