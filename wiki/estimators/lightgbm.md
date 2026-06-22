---
title: LightGBM
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - LightGBM.pdf
  - Ke et al. 2017, LightGBM: A Highly Efficient Gradient Boosting Decision Tree
  - https://papers.nips.cc/paper/6907-lightgbm-a-highly-efficient-gradient-boosting-decision
  - https://lightgbm.readthedocs.io/en/v4.5.0/Parameters-Tuning.html
tags: [estimator, boosting, trees, hyperparameters, paper-supported]
---

LightGBM is a high-efficiency gradient boosting decision tree estimator. In this
project it is mainly a fast tabular benchmark for large software, paper-derived
or portal-derived datasets.

## Summary

LightGBM uses histogram-based tree learning and leaf-wise tree growth. This can
be very efficient, but it makes complexity control through `num_leaves`,
`min_data_in_leaf` and `max_depth` especially important.

It is not an inherently spatial estimator. Spatial information must be supplied
as engineered predictors, and validation must respect spatial or temporal
dependence.

## Estimator Family

- Family: gradient boosting decision trees.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference paper and official documentation.
- Core reference: Ke et al. (2017).

## Model Equation

Canonical additive tree ensemble:

```math
\hat{y}_i = \sum_{k=1}^{K} f_k(x_i)
```

where trees are added sequentially to reduce loss gradients. The practical
difference from XGBoost is mainly computational and algorithmic: LightGBM uses
histograms and leaf-wise growth, so leaf complexity is central.

## Data Structures It May Fit

- Large tabular datasets.
- High-dimensional feature matrices.
- Spatial datasets after feature engineering.
- Spatial panels after lag/window construction.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `num_leaves` | Maximum leaves per tree | yes | Main complexity control. |
| `min_data_in_leaf` / `min_child_samples` | Minimum observations per leaf | yes | Crucial against overfitting. |
| `learning_rate` | Shrinkage | yes | Tune with `n_estimators`. |
| `n_estimators` / `num_iterations` | Boosting rounds | yes | Use early stopping when possible. |
| `max_depth` | Depth cap | yes | Useful to constrain leaf-wise growth. |
| `feature_fraction` / `colsample_bytree` | Feature sampling | yes | Reduces overfitting and cost. |
| `bagging_fraction` / `subsample` | Row sampling | yes | Use with `bagging_freq`. |
| `lambda_l1` / `reg_alpha` | L1 regularization | later | Secondary regularization. |
| `lambda_l2` / `reg_lambda` | L2 regularization | later | Secondary regularization. |
| `max_bin` | Histogram granularity | later | Accuracy-speed tradeoff. |

## Cross-validation Policy

Use spatial or spatio-temporal blocking when data are spatially dependent.
LightGBM is fast enough to encourage extensive tuning, but random folds can
hide leakage.

## Diagnostics To Inspect

- Early stopping iteration.
- Train/validation gap.
- Feature importance stability.
- Error by location/time.
- Residual spatial autocorrelation.

## Failure Modes

- Too many leaves on small datasets.
- Leaf-wise overfitting without `min_data_in_leaf`.
- Misleading random-fold performance under spatial dependence.
- Importance bias with correlated or duplicated predictors.

## Minimal Tuning Workflow

1. Fix the objective from the response type.
2. Start with conservative `num_leaves` and `min_data_in_leaf`.
3. Tune `learning_rate` and `n_estimators` with early stopping.
4. Tune `num_leaves`, `max_depth`, and sampling fractions.
5. Check blocked validation and residual maps.

## Related Pages

- [[gam]]
- [[xgboost]]
- [[random_forest]]
- [[data_leakage]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
