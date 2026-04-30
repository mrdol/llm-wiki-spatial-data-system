---
title: STVC
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: ["Geographical Analysis - 2025 - Murakami - Fast Spatio‐Temporally Varying Coefficient Modeling With Reluctant Interaction.pdf"]
tags: [estimator, spatial, spatio-temporal, varying-coefficient, hyperparameters, template]
---

STVC estimator fiche template for spatio-temporally varying coefficient modeling.

## Summary

STVC is an allowed estimator in the project registry. This fiche is prepared for future extraction from the Murakami spatio-temporally varying coefficient paper in `raw/paper`.

## Estimator Family

- Family: spatio-temporally varying coefficient model
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical spatio-temporally varying coefficient regression:

`y_it = beta_0(s_i, t) + sum_{j=1}^{p} beta_j(s_i, t) x_ijt + epsilon_it`.

The coefficient surfaces `beta_j(s, t)` vary jointly over spatial location `s` and time `t`.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `Geographical Analysis - 2025 - Murakami - Fast Spatio‐Temporally Varying Coefficient Modeling With Reluctant Interaction.pdf` | pending extraction | Use this paper to verify model structure and tuning controls |

## Data Structures It May Fit

- Candidate use: spatio-temporal regression where coefficients vary over space and time
- Candidate structure: spatial units observed over multiple periods
- Evidence status: project_candidate

## Main Use Cases

- Modeling spatially and temporally nonstationary effects
- Detecting coefficient heterogeneity
- Comparing global and local effects

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `spatial_bandwidth` | Spatial smoothing scale | yes | project_candidate | To verify exact formulation |
| `temporal_bandwidth` | Temporal smoothing scale | yes | project_candidate | To verify exact formulation |
| `interaction_control` | Space-time interaction handling | yes | project_candidate | Paper-specific field to extract |
| `basis_dimension` | Basis or approximation dimension | later | project_candidate | If used by implementation |
| `regularization_strength` | Coefficient smoothness control | later | project_candidate | To verify |

## Secondary Hyperparameters

- kernel type: if applicable
- local-neighbor settings: if applicable
- approximation tolerance: if implementation exposes it

## Hyperparameter Interactions

- Spatial and temporal bandwidths jointly define nonstationarity.
- Interaction control determines whether space-time patterns are separable or coupled.
- Basis dimension and regularization jointly affect speed and smoothness.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Coefficient surfaces over space and time
- Residual spatial autocorrelation
- Residual temporal autocorrelation
- Stability of local coefficients
- Comparison against global models

## Failure Modes

- Overfitting local coefficients
- Boundary instability
- Misleading effects when spatial or temporal support is sparse

## Minimal Tuning Workflow

1. Confirm spatial and temporal support in the dataset.
2. Fit global baseline.
3. Tune spatial and temporal smoothing controls.
4. Inspect coefficient surfaces and residual dependence.

## Dataset Compatibility Notes

- Requires explicit space and time dimensions.
- Strong candidate for geolocated or regional panel datasets.

## Open Questions From Papers

- What exact interaction controls are defined?
- What computational shortcuts are introduced?
- Which validation criteria are used in the source paper?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[svc]]
- [[mgwr]]
