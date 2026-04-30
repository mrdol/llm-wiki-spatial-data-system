---
title: MGWRSAR
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [MGWR-SAR_Geniaux&Martinetti.pdf]
tags: [estimator, spatial, gwr, sar, hyperparameters, template]
---

MGWRSAR estimator fiche template for multiscale geographically weighted regression with spatial autoregressive structure.

## Summary

MGWRSAR is an allowed estimator in the project registry. This fiche is prepared for future extraction from `MGWR-SAR_Geniaux&Martinetti.pdf`.

## Estimator Family

- Family: spatial regression combining multiscale geographically weighted effects and SAR structure
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical MGWR-SAR-style spatial regression:

`y = rho W y + beta_0(s) + sum_{j=1}^{p} beta_{b_j,j}(s) x_j + epsilon`.

`W` is a spatial weights matrix, `rho` is the spatial autoregressive coefficient, and `b_j` are covariate-specific bandwidths.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `MGWR-SAR_Geniaux&Martinetti.pdf` | pending extraction | Use this paper to verify spatial autoregressive and multiscale controls |

## Data Structures It May Fit

- Candidate use: spatial data with local coefficients and spatial dependence
- Candidate structure: point or areal spatial data with a defined spatial weights matrix
- Evidence status: project_candidate

## Main Use Cases

- Spatial nonstationarity plus spatial dependence
- Local effect estimation with autocorrelated outcomes
- Comparison against MGWR and SAR-type baselines

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `bandwidth_per_covariate` | Covariate-specific spatial scale | yes | project_candidate | Core multiscale field |
| `spatial_weights_spec` | Spatial-neighbor matrix definition | yes | project_candidate | Must be project-controlled and documented |
| `sar_rho` | Spatial autoregressive parameter | yes | project_candidate | Estimated or constrained depending on implementation |
| `kernel` | Spatial weighting function | yes | project_candidate | To verify |
| `neighbor_count` | Local support | later | project_candidate | If adaptive bandwidth is used |

## Secondary Hyperparameters

- convergence tolerance
- maximum iterations
- distance metric
- spatial weights normalization

## Hyperparameter Interactions

- Spatial weights specification affects SAR behavior and residual diagnostics.
- Bandwidth and SAR structure jointly affect local coefficient interpretation.
- Kernel and neighbor count affect local sample support.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters to tune inside that future validation scheme.

## Diagnostics To Inspect

- Spatial autoregressive parameter behavior
- Residual spatial autocorrelation
- Local coefficient maps
- Bandwidths by covariate
- Sensitivity to spatial weights specification

## Failure Modes

- Confounding between spatial lag and local coefficient variation
- Instability from poorly chosen spatial weights
- High compute cost

## Minimal Tuning Workflow

1. Define and document spatial weights candidates.
2. Fit MGWR or spatial baseline.
3. Add SAR structure.
4. Compare residual spatial dependence and validation metrics.

## Dataset Compatibility Notes

- Requires explicit spatial units and a defensible spatial weights matrix.
- Strong candidate only after spatial metadata are reliable.

## Open Questions From Papers

- How does the paper define the SAR component?
- Which spatial weights are recommended?
- Which bandwidth-selection method is used?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[mgwr]]
- [[svc]]
