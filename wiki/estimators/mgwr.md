---
title: MGWR
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.pdf]
tags: [estimator, spatial, gwr, multiscale, hyperparameters, template]
---

MGWR estimator fiche template for multiscale geographically weighted regression.

## Summary

MGWR is an allowed estimator in the project registry. This fiche is prepared for future extraction from the Stewart et al. MGWR paper in `raw/paper`.

## Estimator Family

- Family: multiscale geographically weighted regression
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical multiscale geographically weighted regression:

`y_i = beta_0(s_i) + sum_{j=1}^{p} beta_{b_j,j}(s_i) x_{ij} + epsilon_i`.

Each coefficient surface can use its own bandwidth `b_j`, so covariates may operate at different spatial scales.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.pdf` | pending extraction | Use this paper to verify multiscale bandwidth selection |

## Data Structures It May Fit

- Candidate use: spatial regression with covariate-specific spatial scales
- Candidate structure: point or areal spatial cross-sections
- Evidence status: project_candidate

## Main Use Cases

- Spatial nonstationarity with variable-specific bandwidths
- Scale comparison across covariates
- Interpretable local spatial modeling

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `bandwidth_per_covariate` | Covariate-specific spatial scale | yes | project_candidate | Core MGWR tuning concept |
| `kernel` | Spatial weighting function | yes | project_candidate | To verify available choices |
| `neighbor_count` | Local sample support | yes | project_candidate | Alternative bandwidth representation |
| `backfitting_tolerance` | Convergence tolerance | later | project_candidate | Implementation-dependent |
| `max_iterations` | Backfitting iteration cap | later | project_candidate | Compute/stability control |

## Secondary Hyperparameters

- distance metric: depends on geometry
- fixed versus adaptive bandwidth: to verify
- local intercept treatment: implementation-dependent

## Hyperparameter Interactions

- Each covariate bandwidth changes the interpretation of local effects.
- Kernel and bandwidth jointly define spatial weighting.
- Convergence tolerance affects reproducibility and runtime.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Bandwidths by covariate
- Local coefficient maps
- Residual spatial autocorrelation
- Multicollinearity diagnostics
- Convergence diagnostics

## Failure Modes

- Expensive computation on large datasets
- Local coefficient instability
- Misinterpretation when covariates have strong spatial collinearity

## Minimal Tuning Workflow

1. Fit global regression baseline.
2. Fit single-scale spatial baseline if useful.
3. Tune or estimate covariate-specific bandwidths.
4. Inspect coefficient maps and bandwidth plausibility.

## Dataset Compatibility Notes

- Requires explicit spatial support.
- Best suited to spatial cross-sections or carefully aggregated spatial panels.

## Open Questions From Papers

- Which bandwidth-selection criterion is used?
- How are variable-specific scales estimated?
- Which diagnostics are emphasized?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[svc]]
- [[mgwrsar]]
