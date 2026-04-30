---
title: MARS
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [Earth_MARS__a_note_on_earth.pdf]
tags: [estimator, mars, splines, hyperparameters, template]
---

MARS estimator fiche template for multivariate adaptive regression splines.

## Summary

MARS is an allowed estimator in the project registry. This fiche is prepared for future extraction from `Earth_MARS__a_note_on_earth.pdf`.

## Estimator Family

- Family: adaptive regression splines
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical MARS predictor:

`y_hat_i = beta_0 + sum_{m=1}^{M} beta_m B_m(x_i)`, where `B_m` are hinge-function basis terms such as `max(0, x_j - c)` or `max(0, c - x_j)`.

Model selection controls the number and interaction degree of retained basis terms.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `Earth_MARS__a_note_on_earth.pdf` | pending extraction | Use this paper to verify earth/MARS parameters and pruning details |

## Data Structures It May Fit

- Candidate use: interpretable nonlinear tabular modeling
- Candidate structure: cross-section or engineered panel data
- Evidence status: project_candidate

## Main Use Cases

- Nonlinear regression with hinge functions
- Interaction screening
- More interpretable alternative to boosted trees

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `degree` | Maximum interaction degree | yes | project_candidate | Controls interaction complexity |
| `nprune` | Number of retained terms | yes | project_candidate | Central pruning/complexity parameter |
| `nk` | Maximum number of model terms | yes | project_candidate | Candidate upper bound on basis size |
| `penalty` | Penalty for model complexity | later | project_candidate | To verify from earth documentation or paper |
| `minspan` | Minimum spacing between knots | later | project_candidate | Data-size dependent |
| `endspan` | Boundary knot control | later | project_candidate | To verify from paper |

## Secondary Hyperparameters

- response family settings: task-dependent
- variable selection constraints: pending implementation

## Hyperparameter Interactions

- `degree`, `nk`, and `nprune` jointly define model flexibility.
- `penalty` affects pruning and interpretability.
- Knot-spacing fields affect stability in small or uneven datasets.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Number of retained terms
- Selected variables
- Validation error
- Residual plots and extrapolation behavior

## Failure Modes

- Overfitting with too many terms or interactions
- Instability under sparse covariate regions
- Limited performance if discontinuous or highly local effects dominate

## Minimal Tuning Workflow

1. Start with low interaction degree.
2. Tune `nprune` and `nk`.
3. Add interaction degree only if validation supports it.
4. Inspect retained basis terms.

## Dataset Compatibility Notes

- Plausible for medium-size tabular datasets where interpretability matters.
- Not inherently spatial unless spatial covariates or coordinates are included.

## Open Questions From Papers

- Which earth parameters are emphasized?
- How is pruning selected?
- What defaults should be preserved for reproducibility?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
