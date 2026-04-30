---
title: LightGBM
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [LightGBM.pdf]
tags: [estimator, boosting, trees, hyperparameters, template]
---

LightGBM estimator fiche template for later paper-supported tuning documentation.

## Summary

LightGBM is an allowed estimator in the project registry. This fiche is prepared for future extraction from `LightGBM.pdf`.

## Estimator Family

- Family: gradient boosting with tree learners
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical additive tree ensemble:

`y_hat_i = sum_{k=1}^{K} f_k(x_i)`, where `f_k` is a tree learner and `K` is the number of boosting rounds.

The method optimizes a differentiable loss by sequentially adding trees to reduce residual gradient structure.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `LightGBM.pdf` | pending extraction | Use this paper to verify algorithm details and tuning fields |

## Data Structures It May Fit

- Candidate use: large tabular datasets with many covariates
- Candidate structure: cross-section, engineered panels, high-dimensional indicators
- Evidence status: project_candidate

## Main Use Cases

- Fast boosted-tree benchmark
- Large feature matrices
- Nonlinear prediction with interactions

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `num_leaves` | Leaf complexity | yes | project_candidate | Central LightGBM complexity field |
| `learning_rate` | Shrinkage per boosting round | yes | project_candidate | Tune with boosting rounds |
| `n_estimators` | Number of boosting rounds | yes | project_candidate | Tune jointly with `learning_rate` |
| `max_depth` | Optional tree-depth cap | later | project_candidate | Use if leaf growth becomes unstable |
| `min_child_samples` | Minimum observations per leaf | yes | project_candidate | Controls leaf reliability |
| `subsample` | Row sampling | yes | project_candidate | Candidate overfitting control |
| `colsample_bytree` | Feature sampling | yes | project_candidate | Candidate overfitting control |
| `reg_alpha` | L1 regularization | later | project_candidate | Secondary regularization |
| `reg_lambda` | L2 regularization | later | project_candidate | Secondary regularization |

## Secondary Hyperparameters

- `min_split_gain`: split threshold to verify
- categorical-feature handling: pending implementation choice
- objective-specific parameters: pending modeling target

## Hyperparameter Interactions

- `num_leaves`, `max_depth`, and `min_child_samples` jointly control model complexity.
- `learning_rate` and `n_estimators` must be tuned together.
- Sampling parameters should be used after baseline complexity is stable.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Validation error curve
- Overfitting gap
- Feature importance stability
- Residual spatial or temporal autocorrelation where relevant

## Failure Modes

- Overfitting from too many leaves
- Instability on small datasets
- Misleading importance when covariates are highly correlated

## Minimal Tuning Workflow

1. Start with conservative `num_leaves` and `min_child_samples`.
2. Tune `learning_rate` with `n_estimators`.
3. Tune complexity fields.
4. Tune sampling and regularization fields.

## Dataset Compatibility Notes

- Plausible for large metadata-rich tabular datasets.
- Not inherently spatial; spatial structure must enter through features or diagnostics.

## Open Questions From Papers

- Which speed and memory arguments are paper-supported?
- Which histogram or leaf-wise details matter for tuning?
- Which defaults should be recorded for reproducibility?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[xgboost]]
- [[random_forest]]
