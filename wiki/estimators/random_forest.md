---
title: Random Forest
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - randomforest2001.pdf
  - Breiman 2001, Random Forests, doi:10.1023/A:1010933404324
tags: [estimator, trees, ensemble, hyperparameters, paper-supported]
---

Random Forest is a bagged ensemble of randomized decision trees. In this project
it is a robust nonlinear baseline for tabular datasets and engineered
spatial/spatio-temporal feature matrices.

## Summary

Random Forest averages many trees fitted on perturbed data and split candidates.
It usually requires less delicate tuning than boosted trees, but it is not a
spatial model by itself. Spatial dependence must be handled through feature
engineering, blocked validation and residual diagnostics.

## Estimator Family

- Family: bagged decision-tree ensemble.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference paper.
- Core reference: Breiman (2001).

## Model Equation

Regression forest:

```math
\hat{y}(x) = \frac{1}{B}\sum_{b=1}^{B} T_b(x)
```

where `T_b` is a tree trained with bootstrap sampling and random feature
selection at splits. Classification uses majority vote or averaged class
probabilities.

## Data Structures It May Fit

- General tabular datasets.
- Spatial datasets with coordinates, lags, distances or neighborhood summaries.
- Spatial panels after feature engineering.
- Classification or regression tasks.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `n_estimators` / `ntree` | Number of trees | yes | Increase until metrics and importances stabilize. |
| `max_features` / `mtry` | Candidate predictors per split | yes | Core decorrelation parameter. |
| `min_samples_leaf` / `nodesize` | Minimum leaf size | yes | Controls smoothness and overfitting. |
| `max_depth` | Optional depth cap | later | Useful for memory or overfitting control. |
| `bootstrap` | Sampling regime | later | Usually true for classical RF. |
| `class_weight` | Class imbalance handling | later | Classification only. |

## Cross-validation Policy

Out-of-bag error is useful but does not replace spatial or temporal validation.
For spatial/ST datasets, use blocked validation and inspect whether the forest
only interpolates nearby observations.

## Diagnostics To Inspect

- OOB error if available.
- Validation error under blocked folds.
- Variable importance stability.
- Partial dependence or accumulated local effects for selected predictors.
- Residual spatial autocorrelation.

## Failure Modes

- Poor extrapolation.
- Biased importance under correlated predictors.
- Random folds overestimating spatial transfer.
- Large memory use with many trees and large data.

## Minimal Tuning Workflow

1. Tune `mtry`/`max_features` and leaf size.
2. Increase tree count until stable.
3. Compare random-fold and spatial-block validation.
4. Inspect residual spatial structure and variable importance stability.

## Related Pages

- [[gam]]
- [[xgboost]]
- [[lightgbm]]
- [[data_leakage]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
