---
title: GAMBoost
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [GAMboosting.pdf]
tags: [estimator, boosting, gam, hyperparameters, template]
---

GAMBoost estimator fiche template for boosted additive modeling.

## Summary

GAMBoost is an allowed estimator in the project registry. This fiche is prepared for future extraction from `GAMboosting.pdf`.

## Estimator Family

- Family: boosting for generalized additive components
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical boosted additive predictor:

`g(E[y_i]) = eta_i = beta_0 + sum_{j=1}^{p} h_j(x_{ij})`, where `h_j` are selected or updated base learners.

Boosting updates the additive predictor iteratively:

`eta^{[m]} = eta^{[m-1]} + nu * h_{j_m}(x)`.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `GAMboosting.pdf` | pending extraction | Use this paper to verify additive components and stopping rules |

## Data Structures It May Fit

- Candidate use: nonlinear but partially interpretable tabular modeling
- Candidate structure: cross-section or panel-derived features
- Evidence status: project_candidate

## Main Use Cases

- Additive nonlinear effects
- Interpretable smooth components
- Alternative to black-box boosting when additive structure matters

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `mstop` | Number of boosting iterations | yes | project_candidate | Likely central stopping parameter |
| `nu` | Step length or shrinkage | yes | project_candidate | Tune with `mstop` |
| `baselearner_type` | Component family | yes | project_candidate | Linear, spline, spatial, or other learners to verify |
| `df` | Smoothness or degrees of freedom | yes | project_candidate | Relevant for spline components |
| `penalty` | Smoothness penalty | later | project_candidate | Depends on implementation |

## Secondary Hyperparameters

- family/link function: task-dependent
- component selection settings: pending paper extraction
- interaction terms: include only if explicitly needed

## Hyperparameter Interactions

- `mstop` and `nu` jointly control effective model complexity.
- Smoothness fields interact with component interpretability.
- Component type determines what can be tuned downstream.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Component-level effects
- Validation error by boosting iteration
- Stability of selected components
- Residual structure

## Failure Modes

- Overfitting with too many iterations
- Underfitting if additive assumptions are too restrictive
- Hard comparison across component families if tuning is inconsistent

## Minimal Tuning Workflow

1. Define candidate base learners.
2. Tune stopping iteration and shrinkage.
3. Tune smoothness controls.
4. Inspect selected effects before model acceptance.

## Dataset Compatibility Notes

- Useful when interpretability of nonlinear effects matters.
- Spatial usefulness depends on whether spatial base learners are included.

## Open Questions From Papers

- Which stopping criterion is recommended?
- Which additive components are paper-supported?
- How are smoothness and shrinkage selected?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[spboost]]
