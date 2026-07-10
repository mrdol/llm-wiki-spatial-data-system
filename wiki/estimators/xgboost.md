---
title: XGBoost
type: estimator
created: 2026-04-23
updated: 2026-07-06
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

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Chen and Guestrin (2016) | paper_supported | canonical boosted-tree objective and regularization |
| Official XGBoost parameter documentation | implementation_supported | software parameter names and current defaults |

## Main Use Cases

- Non-spatial baseline for tabular regression.
- Coordinate-augmented baseline when `coord_x` and `coord_y` are included as raw predictors.
- Nonlinear comparison point against GLM, GAM, GWR, MGWR and SpBoost.
- Feature-engineered spatial prediction when spatial lags, eigenvectors or neighborhood summaries are provided explicitly.

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

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `tree_method` | tree construction algorithm | no/later | implementation_supported | operational choice; use stable defaults unless runtime requires change |
| `max_bin` | histogram bin count | later | implementation_supported | relevant mainly with histogram tree methods |
| `early_stopping_rounds` | stopping rule | yes when validation split exists | implementation_supported | belongs to tuning workflow, not estimator definition |

## Hyperparameter Interactions

- `learning_rate` and boosting rounds must be tuned together: smaller `eta` usually needs more trees.
- `max_depth`, `min_child_weight` and `gamma` jointly control tree complexity.
- `subsample` and `colsample_bytree` regularize correlated predictors, including coordinate-augmented designs.

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

## Dataset Compatibility Notes

- Compatible `Y`: continuous regression targets in the current benchmark.
- Compatible `X`: numeric, binary or encoded categorical predictors.
- Spatial requirement: none for `xgboost`; optional coordinates may be added in `xgboost_xy`.
- Missing data: handle before fitting; the project pipeline currently uses `complete.cases()` during dataset preparation.
- Validation: spatial/block validation is required before interpreting it as a spatial benchmark result.

## Open Questions From Papers

- Whether coordinate-augmented XGBoost should be treated as a spatial baseline or only as a feature-engineered non-spatial model.
- Whether monotonic constraints or interaction constraints are useful for any catalog datasets.

## Project Use As A Non-Spatial Baseline (added 2026-07-04)

Added to the manual `tidymodels` benchmark
(`code/R/estimators/benchmark_manual_test_2026-07.R`,
`build_specs()`) as a strict "no spatial information" baseline alongside
plain OLS (`glm`) and plain GWR/SAR (see [[mgwrsar]]). No custom engine is
needed: `parsnip::boost_tree()` already ships a native `xgboost` engine.

```r
parsnip::boost_tree(mode = "regression") |> parsnip::set_engine("xgboost")
```

The benchmark now fits two variants:

- `xgboost`: strict baseline on `X` only;
- `xgboost_xy`: coordinate-augmented baseline on `X + coord_x + coord_y`.

The `xgboost_xy` variant is not a spatial econometric model. It only tests
whether a standard ML model can exploit raw coordinates as predictors.

## Related Pages

- [[gam]]
- [[lightgbm]]
- [[random_forest]]
- [[data_leakage]]
- [[mgwrsar]]
- [[spboost]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
