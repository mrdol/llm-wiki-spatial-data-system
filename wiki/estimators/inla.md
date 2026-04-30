---
title: INLA
type: estimator
created: 2026-04-23
updated: 2026-04-23
sources: [OpitzINLA.pdf]
tags: [estimator, bayesian, spatial, hyperparameters, template]
---

INLA estimator fiche template for latent Gaussian and spatial Bayesian modeling.

## Summary

INLA is an allowed estimator in the project registry. This fiche is prepared for future extraction from `OpitzINLA.pdf`.

## Estimator Family

- Family: approximate Bayesian inference for latent Gaussian models
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: template pending paper extraction

## Model Equation

Canonical latent Gaussian model:

`y_i | eta_i, theta ~ p(y_i | eta_i, theta)` and `eta_i = alpha + x_i' beta + sum_k u_k(i)`.

Latent effects `u_k` are assigned Gaussian priors, and INLA approximates posterior marginals for latent variables and hyperparameters.

Evidence status: `canonical_form_pending_paper_extraction`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `OpitzINLA.pdf` | pending extraction | Use this paper to verify INLA model components and hyperparameter treatment |

## Data Structures It May Fit

- Candidate use: spatial, spatio-temporal, and hierarchical modeling
- Candidate structure: areal, point-referenced, or latent-field models depending on formulation
- Evidence status: project_candidate

## Main Use Cases

- Bayesian spatial models
- Latent field modeling
- Structured random effects
- Uncertainty-aware estimation

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `family` | Likelihood family | yes | project_candidate | Determined by response type |
| `spatial_effect` | Spatial latent effect specification | yes | project_candidate | Model-structure choice rather than simple scalar tuning |
| `temporal_effect` | Temporal effect specification | yes | project_candidate | Use only for temporal data |
| `prior_precision` | Precision prior settings | later | project_candidate | Must be paper-supported before final use |
| `prior_range` | Spatial range prior settings | later | project_candidate | Relevant for SPDE-style models |
| `mesh_resolution` | Spatial mesh granularity | yes | project_candidate | If using mesh-based spatial models |

## Secondary Hyperparameters

- integration strategy: implementation-dependent
- random-effect structure: dataset-dependent
- link function: response-dependent

## Hyperparameter Interactions

- Spatial prior choices and mesh resolution interact strongly.
- Likelihood family and link function determine interpretation.
- Temporal and spatial effects should be added only when supported by data structure.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

This fiche only defines candidate hyperparameters or model-structure choices to tune inside that future validation scheme.

## Diagnostics To Inspect

- Posterior summaries
- Predictive validation metrics
- Spatial residual structure
- Sensitivity to priors
- Computational stability

## Failure Modes

- Misleading inference from poorly chosen priors
- Mesh or spatial-resolution artifacts
- High setup complexity relative to simpler baselines

## Minimal Tuning Workflow

1. Define likelihood and response family.
2. Fit a non-spatial or simple random-effect baseline.
3. Add spatial and temporal effects only when metadata supports them.
4. Inspect prior sensitivity and residual spatial structure.

## Dataset Compatibility Notes

- Plausible for spatial or spatio-temporal datasets with explicit geometry or spatial identifiers.
- Less appropriate for purely tabular prediction if uncertainty and latent structure are not needed.

## Open Questions From Papers

- Which latent structures are discussed in `OpitzINLA.pdf`?
- Which priors and diagnostics are recommended?
- Which computational constraints matter for the project scale?

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[stvc]]
- [[svc]]
