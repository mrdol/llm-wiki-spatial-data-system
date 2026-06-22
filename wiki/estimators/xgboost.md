---
title: XGBoost
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - XGBoost.pdf
  - Chen and Guestrin 2016, XGBoost: A Scalable Tree Boosting System, doi:10.1145/2939672.2939785
  - https://xgboost.readthedocs.io/en/stable/parameter.html
tags: [estimator, boosting, trees, hyperparameters, paper-supported]
---

XGBoost is a regularized gradient-boosted tree estimator. In this project it is
a strong non-spatial baseline for tabular prediction after spatial and temporal
features have been engineered.

## Summary

XGBoost fits an additive ensemble of trees and optimizes a differentiable loss
plus a regularization penalty on tree complexity. It is not inherently spatial:
coordinates, distances, spatial lags, eigenvectors, neighborhood summaries or
temporal windows must be provided as predictors if spatial or spatio-temporal
structure should influence the fit.

## Estimator Family

- Family: regularized gradient boosting with tree learners.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference paper and official documentation.
- Core reference: Chen and Guestrin (2016).

## Model Equation

Canonical additive tree ensemble:

```math
\hat{y}_i = \sum_{k=1}^{K} f_k(x_i)
```

where each `f_k` is a regression tree. The training objective is:

```math
Obj = \sum_i l(y_i, \hat{y}_i) + \sum_k \Omega(f_k)
```

The regularization term controls tree complexity, usually through leaf weights
and number of leaves.

## Data Structures It May Fit

- Cross-sectional tabular data.
- Spatial datasets after feature engineering.
- Spatial panels converted into covariates, lags or windows.
- Regression, classification, count and ranking tasks depending on objective.

XGBoost should not be treated as a spatial model unless spatial validation and
spatial residual diagnostics are applied.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `n_estimators` / boosting rounds | Number of trees | yes | Tune with `learning_rate`; use early stopping when possible. |
| `learning_rate` / `eta` | Shrinkage per tree | yes | Smaller values usually require more trees. |
| `max_depth` | Maximum tree depth | yes | Controls interaction order and local complexity. |
| `min_child_weight` | Minimum Hessian weight in child node | yes | Prevents splits supported by too little information. |
| `subsample` | Row subsampling | yes | Regularizes and reduces overfitting. |
| `colsample_bytree` | Feature subsampling per tree | yes | Important when many correlated predictors exist. |
| `gamma` | Minimum split loss reduction | later | Conservative split threshold. |
| `reg_alpha` | L1 regularization | later | Useful for sparse effects. |
| `reg_lambda` | L2 regularization | later | Default regularization path. |
| `objective` | Loss/task definition | yes | Must match response type. |

## Cross-validation Policy

Use the project validation scheme. For spatial or spatio-temporal datasets,
prefer spatial blocks, leave-location-out, temporal blocks, or blocked
space-time validation. Random folds can overstate performance when neighboring
observations leak information.

## Diagnostics To Inspect

- Validation curve and early stopping iteration.
- Train/validation gap.
- Feature importance by gain, with caution under correlated predictors.
- Residual spatial autocorrelation.
- Error by spatial unit or time period.

## Failure Modes

- Excellent random-fold score but poor spatial transfer.
- Overfitting from deep trees and too many rounds.
- Misleading importance when predictors are correlated.
- Poor extrapolation outside observed covariate ranges.

## Minimal Tuning Workflow

1. Set the objective from `Y` type.
2. Start with conservative `max_depth`, moderate `eta`, and early stopping.
3. Tune `max_depth`, `min_child_weight`, `subsample`, and `colsample_bytree`.
4. Add `gamma`, `reg_alpha`, and `reg_lambda` only after the baseline is stable.
5. Check residual spatial or temporal structure.

## Related Pages

- [[gam]]
- [[lightgbm]]
- [[random_forest]]
- [[data_leakage]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
