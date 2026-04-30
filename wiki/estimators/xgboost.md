---
title: XGBoost
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [XGBoost.pdf]
tags: [estimator, boosting, trees, hyperparameters, template]
---

Gradient-boosted tree estimator fiche template for later paper-supported tuning documentation.

## Summary

XGBoost is an allowed estimator in the project registry. This fiche is prepared for future extraction from `XGBoost.pdf`.

## Estimator Family

- Family: gradient boosting with tree learners
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical additive tree ensemble:

`y_hat_i = sum_{k=1}^{K} f_k(x_i)`, where `f_k` is a regression tree and `K` is the number of boosting rounds.

Training adds trees sequentially by minimizing a regularized objective:

`Obj = sum_i l(y_i, y_hat_i) + sum_{k=1}^{K} Omega(f_k)`.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `XGBoost.pdf` | pending extraction | Use this paper to verify algorithm details and tuning fields |

## Data Structures It May Fit

- Candidate use: tabular prediction after dataset bank construction
- Candidate structure: cross-section, panel-derived features, spatial covariates after feature engineering
- Evidence status: project_candidate

## Main Use Cases

- Nonlinear prediction with many covariates
- Interaction-heavy tabular modeling
- Benchmarking against Random Forest and LightGBM

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `n_estimators` | Number of boosting rounds | yes | project_candidate | To verify from implementation and paper evidence |
| `learning_rate` | Shrinkage per boosting round | yes | project_candidate | Usually interacts with `n_estimators` |
| `max_depth` | Tree depth and interaction complexity | yes | project_candidate | Controls local complexity |
| `min_child_weight` | Minimum child-node weight | yes | project_candidate | Regularization-like split control |
| `subsample` | Row subsampling | yes | project_candidate | Candidate overfitting control |
| `colsample_bytree` | Feature subsampling | yes | project_candidate | Candidate overfitting control |
| `reg_alpha` | L1 regularization | later | project_candidate | Use after baseline complexity tuning |
| `reg_lambda` | L2 regularization | later | project_candidate | Use after baseline complexity tuning |

## Secondary Hyperparameters

- `gamma`: split-gain threshold to verify
- objective-specific settings: pending task definition
- monotonic constraints: pending use-case need

## Hyperparameter Interactions

- `learning_rate` and `n_estimators` must be tuned together.
- `max_depth`, `min_child_weight`, and regularization jointly control complexity.
- `subsample` and `colsample_bytree` jointly control stochasticity.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Prediction error on validation folds
- Overfitting gap between training and validation
- Feature importance stability
- Residual structure, including spatial or temporal residual patterns if relevant

## Failure Modes

- Overfitting when depth and rounds are too high
- Poor extrapolation outside observed covariate ranges
- Interpretability loss when many interactions are learned

## Minimal Tuning Workflow

1. Establish a simple baseline with conservative depth and learning rate.
2. Tune `n_estimators`, `learning_rate`, and `max_depth`.
3. Tune sampling and regularization only after the baseline is stable.
4. Inspect residual structure before accepting the model.

## Dataset Compatibility Notes

- Plausible for rich tabular datasets after feature construction.
- Spatial use requires explicit spatial features or residual diagnostics; the estimator is not inherently spatial.

## Open Questions From Papers

- Which hyperparameters are emphasized in `XGBoost.pdf`?
- Which loss functions are discussed?
- What regularization guidance is explicitly paper-supported?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[lightgbm]]
- [[random_forest]]
