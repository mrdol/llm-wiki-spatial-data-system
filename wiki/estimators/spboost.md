---
title: SpBoost
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [spbbost_article.pdf]
tags: [estimator, spatial, boosting, hyperparameters, template]
---

SpBoost estimator fiche template for spatial boosting.

## Summary

SpBoost is an allowed estimator in the project registry. This fiche is prepared for future extraction from `spbbost_article.pdf`.

## Estimator Family

- Family: spatial boosting
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical spatial boosting predictor:

`f^{[m]}(x_i, s_i) = f^{[m-1]}(x_i, s_i) + nu * h_m(x_i, s_i)`.

The base learner `h_m` may include spatial smoothers or spatially structured components in addition to covariates.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `spbbost_article.pdf` | pending extraction | Filename retained as-is; verify whether project spelling should be `spboost` or `spbbost` |

## Data Structures It May Fit

- Candidate use: spatial prediction with boosting-style learning
- Candidate structure: spatial cross-section or spatial panel after feature construction
- Evidence status: project_candidate

## Main Use Cases

- Spatially aware boosted prediction
- Benchmark against non-spatial boosting
- Residual spatial-structure reduction

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `n_iterations` | Number of boosting steps | yes | project_candidate | To verify exact implementation name |
| `learning_rate` | Shrinkage | yes | project_candidate | Tune with iterations |
| `spatial_smoother` | Spatial component type | yes | project_candidate | Paper-specific field to extract |
| `spatial_bandwidth` | Spatial smoothing scale | yes | project_candidate | If exposed by implementation |
| `baselearner_complexity` | Complexity of base learners | yes | project_candidate | To verify |

## Secondary Hyperparameters

- loss function
- spatial penalty
- convergence tolerance
- maximum tree or smoother complexity

## Hyperparameter Interactions

- Learning rate and number of iterations jointly control effective complexity.
- Spatial smoother and bandwidth control spatial structure.
- Base learner complexity affects overfitting risk.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Validation error
- Residual spatial autocorrelation
- Spatial component contribution
- Overfitting curve by iteration

## Failure Modes

- Overfitting local spatial noise
- Ambiguous separation between covariate effects and spatial smoother
- Implementation-specific tuning complexity

## Minimal Tuning Workflow

1. Fit non-spatial boosting baseline.
2. Add spatial component.
3. Tune boosting iterations and shrinkage.
4. Tune spatial smoother fields and inspect residual spatial dependence.

## Dataset Compatibility Notes

- Requires spatial support or spatial features.
- Useful only if spatial dependence remains after baseline modeling.

## Open Questions From Papers

- What exact algorithm name and package spelling should be standardized?
- Which spatial smoother is used?
- Which hyperparameters are explicitly recommended?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[gamboost]]
- [[xgboost]]
