---
title: Random Forest
type: estimator
created: 2026-04-23
updated: 2026-07-06
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

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Breiman (2001) | paper_supported | canonical bagging/random-feature forest definition |
| `ranger` / `parsnip` implementation | implementation_supported | current R backend used in the benchmark |

## Main Use Cases

- Robust nonlinear baseline for tabular regression.
- Coordinate-augmented baseline (`random_forest_xy`) when raw spatial position is allowed as a predictor.
- Benchmark comparison against boosted trees, MARS, GLM and spatial estimators.
- Screening for nonlinear covariate effects before fitting more interpretable spatial models.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `n_estimators` / `ntree` | Number of trees | yes | Increase until metrics and importances stabilize. |
| `max_features` / `mtry` | Candidate predictors per split | yes | Core decorrelation parameter. |
| `min_samples_leaf` / `nodesize` | Minimum leaf size | yes | Controls smoothness and overfitting. |
| `max_depth` | Optional depth cap | later | Useful for memory or overfitting control. |
| `bootstrap` | Sampling regime | later | Usually true for classical RF. |
| `class_weight` | Class imbalance handling | later | Classification only. |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `splitrule` | split criterion | later | implementation_supported | relevant for `ranger`; usually keep default first |
| `sample.fraction` | bootstrap/subsampling fraction | later | implementation_supported | can regularize large or correlated datasets |
| `importance` | variable importance mode | no | implementation_supported | diagnostic choice, not predictive tuning |

## Hyperparameter Interactions

- `mtry` and leaf size jointly control tree diversity and smoothness.
- More trees reduce Monte Carlo noise but do not fix spatial leakage.
- Coordinate-augmented forests can over-interpolate nearby observations if validation is not spatially blocked.

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

## Dataset Compatibility Notes

- Compatible `Y`: continuous regression targets in the current benchmark; classification is possible but outside this pipeline pass.
- Compatible `X`: numeric, binary or encoded categorical predictors.
- Spatial requirement: none for `random_forest`; optional raw coordinates in `random_forest_xy`.
- Missing data: should be handled before fitting; current benchmark uses prepared complete cases.
- Validation: OOB error is not enough for spatial datasets; keep near-prediction and block-spatial schemes.

## Open Questions From Papers

- Whether spatially explicit forest variants should remain outside this fiche or receive a separate policy entry.
- Whether variable-importance diagnostics are stable enough under highly correlated spatial predictors.

## Project Use As A Baseline (added 2026-07-06)

The manual `tidymodels` benchmark registers two native `parsnip` variants in
`code/R/estimators/benchmark_manual_test_2026-07.R`:

- `random_forest`: `X` only;
- `random_forest_xy`: `X + coord_x + coord_y`.

Both use `parsnip::rand_forest(mode = "regression")` with engine `ranger`.

## Related Pages

- [[gam]]
- [[xgboost]]
- [[lightgbm]]
- [[data_leakage]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
