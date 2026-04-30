---
title: SVC
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [SVC_Murakami.pdf]
tags: [estimator, spatial, varying-coefficient, hyperparameters, template]
---

SVC estimator fiche template for spatially varying coefficient modeling.

## Summary

SVC is an allowed estimator in the project registry. This fiche is prepared for future extraction from `SVC_Murakami.pdf`.

## Estimator Family

- Family: spatially varying coefficient model
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical spatially varying coefficient regression:

`y_i = beta_0(s_i) + sum_{j=1}^{p} beta_j(s_i) x_{ij} + epsilon_i`, where `s_i` is the spatial location of observation `i`.

Coefficient surfaces `beta_j(s)` vary over space and are smoothed or regularized by the model specification.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `SVC_Murakami.pdf` | pending extraction | Use this paper to verify spatial coefficient model controls |

## Data Structures It May Fit

- Candidate use: spatial regression where coefficients vary over geography
- Candidate structure: point or areal spatial data
- Evidence status: project_candidate

## Main Use Cases

- Spatial nonstationarity
- Local coefficient interpretation
- Comparison against global regression

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `spatial_bandwidth` | Spatial smoothing scale | yes | project_candidate | Central local-smoothing field |
| `kernel` | Spatial weighting function | yes | project_candidate | If implementation exposes kernels |
| `neighbor_count` | Local sample support | later | project_candidate | Alternative to bandwidth |
| `regularization_strength` | Coefficient stabilization | later | project_candidate | To verify |
| `basis_dimension` | Low-rank approximation size | later | project_candidate | If applicable |

## Secondary Hyperparameters

- distance metric: coordinate-system dependent
- local intercept handling: implementation-dependent
- covariance model: if applicable

## Hyperparameter Interactions

- Bandwidth and kernel jointly determine locality.
- Regularization and basis dimension affect coefficient stability.
- Coordinate system quality affects all spatial tuning choices.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Coefficient maps
- Local standard errors or uncertainty measures
- Residual spatial autocorrelation
- Sensitivity to bandwidth

## Failure Modes

- Overfitting local noise
- Boundary artifacts
- False interpretation of local effects under collinearity

## Minimal Tuning Workflow

1. Fit global baseline.
2. Tune spatial bandwidth or neighbor support.
3. Inspect local coefficients and residual spatial pattern.
4. Compare against MGWR or STVC when scale or time variation matters.

## Dataset Compatibility Notes

- Requires reliable spatial coordinates or spatial units.
- Temporal datasets may require STVC rather than SVC if time-varying effects matter.

## Open Questions From Papers

- Which SVC formulation is used?
- How are local coefficients regularized?
- Which diagnostics are recommended?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[stvc]]
- [[mgwr]]
