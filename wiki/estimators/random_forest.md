---
title: Random Forest
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [randomforest2001.pdf]
tags: [estimator, trees, ensemble, hyperparameters, template]
---

Random Forest estimator fiche template for ensemble tree baselines.

## Summary

Random Forest is an allowed estimator in the project registry. This fiche is prepared for future extraction from `randomforest2001.pdf`.

## Estimator Family

- Family: bagged decision-tree ensemble
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical forest predictor:

`y_hat_i = (1 / B) * sum_{b=1}^{B} T_b(x_i)` for regression, where `T_b` is a tree fitted on a bootstrap sample.

For classification, the prediction is the majority vote or averaged class probability across trees.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `randomforest2001.pdf` | pending extraction | Use this paper to verify original method assumptions and tuning fields |

## Data Structures It May Fit

- Candidate use: robust nonlinear tabular baseline
- Candidate structure: cross-section or engineered panel data
- Evidence status: project_candidate

## Main Use Cases

- Strong baseline against boosted trees
- Nonlinear prediction with moderate tuning burden
- Variable-importance exploration

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `n_estimators` | Number of trees | yes | project_candidate | Usually tune until performance stabilizes |
| `max_features` | Candidate predictors per split | yes | project_candidate | Core forest diversity parameter |
| `min_samples_leaf` | Minimum leaf size | yes | project_candidate | Controls smoothness and overfitting |
| `max_depth` | Maximum tree depth | later | project_candidate | Optional complexity cap |
| `bootstrap` | Bootstrap sampling toggle | later | project_candidate | Depends on implementation |

## Secondary Hyperparameters

- split criterion: task-dependent
- class weights: classification only
- sample weights: if survey or importance weighting is needed

## Hyperparameter Interactions

- `max_features` controls tree decorrelation.
- `min_samples_leaf` and `max_depth` control local complexity.
- `n_estimators` mostly controls stability and compute cost.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Validation error
- Out-of-bag diagnostics if used
- Variable importance stability
- Residual spatial or temporal patterning

## Failure Modes

- Poor extrapolation
- Biased variable importance under correlated predictors
- Heavy memory use with many trees and large data

## Minimal Tuning Workflow

1. Tune `max_features` and `min_samples_leaf`.
2. Increase `n_estimators` until metrics stabilize.
3. Add depth constraints only if overfitting or compute pressure appears.

## Dataset Compatibility Notes

- Plausible general-purpose baseline for most tabular datasets.
- Spatial or temporal structure must be encoded explicitly or checked in residuals.

## Open Questions From Papers

- Which original parameters are central in `randomforest2001.pdf`?
- Which diagnostics are discussed in the source paper?
- How should out-of-bag estimates be recorded in this project?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[xgboost]]
- [[lightgbm]]
