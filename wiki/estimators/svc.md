---
title: SVC
type: estimator
created: 2026-04-23
updated: 2026-07-06
sources:
  - SVC_Murakami.pdf
  - Murakami and Griffith, Spatially varying coefficient modeling for large datasets
  - Gelfand et al. 2003, Spatial modeling with spatially varying coefficient processes
tags: [estimator, spatial, varying-coefficient, hyperparameters, paper-supported]
---

SVC models allow regression coefficients to vary over space. They are useful
when the relationship between `Y` and one or more covariates is spatially
nonstationary.

## Summary

SVC is broader than GWR: coefficient variation can be represented through local
kernels, Gaussian processes, eigenvector spatial filtering, basis functions or
other regularized spatial structures. In this project, SVC is a methodological
family for datasets where global coefficients are likely too restrictive.

## Estimator Family

- Family: spatially varying coefficient regression.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference papers and local PDF.
- Related estimators: [[mgwr]], [[inla]], [[stvc]].

## Model Equation

```math
y_i = \beta_0(s_i) + \sum_{j=1}^{p}\beta_j(s_i)x_{ij} + \epsilon_i
```

where `s_i` is the spatial location and `beta_j(s_i)` is a spatially varying
coefficient surface.

## Data Structures It May Fit

- Point or areal spatial regression data.
- Continuous response by default, unless implementation supports other
  likelihoods.
- Covariates whose effects may differ by region.
- Spatial support must be reliable: coordinates, areal centroids or adjacency.

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Murakami and Griffith SVC reference | paper_supported | scalable spatially varying coefficient framing |
| Gelfand et al. (2003) | paper_supported | spatially varying coefficient process framing |
| Current project wrappers | project_candidate | no dedicated SVC wrapper yet in the benchmark |

## Main Use Cases

- Interpret spatial nonstationarity in selected covariate effects.
- Compare global coefficients against local or spatially smoothed coefficient surfaces.
- Motivate MGWR/MGWRSAR use when coefficient variation is central.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| varying coefficients set | Which covariates vary spatially | yes | Do not vary every coefficient by default. |
| spatial smoothing scale | Controls coefficient surface smoothness | yes | Bandwidth, covariance range or basis penalty. |
| kernel/covariance/basis type | Representation of spatial variation | yes | Implementation-dependent. |
| regularization strength | Stabilizes local coefficients | yes | Especially important with collinearity. |
| basis dimension / rank | Low-rank approximation size | later | Needed for scalable SVC variants. |
| local intercept | Whether intercept varies | yes | Can absorb omitted spatial structure. |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| covariance range | spatial dependence scale | later | paper_supported | backend-dependent |
| nugget/noise variance | residual noise | later | paper_supported | backend-dependent |
| approximation rank | scalability control | later | implementation_supported | needed for large datasets |

## Hyperparameter Interactions

- The varying-coefficient set and smoothing scale must be chosen together.
- A varying intercept can absorb broad spatial trend and mask covariate effects.
- Local collinearity can make coefficient surfaces unstable even when prediction improves.

## Cross-validation Policy

Use spatially blocked validation. Random folds may reward interpolation instead
of real transfer. Compare against global regression, GWR/MGWR and non-spatial
machine-learning baselines when prediction is the target.

## Diagnostics To Inspect

- Coefficient maps.
- Uncertainty or stability of coefficient surfaces.
- Local collinearity.
- Residual spatial autocorrelation.
- Sensitivity to smoothing scale and varying-coefficient set.

## Failure Modes

- Overinterpreting noisy local coefficients.
- Letting too many coefficients vary.
- Local collinearity producing unstable maps.
- Boundary artifacts.
- Treating coefficient maps as causal evidence without design support.

## Minimal Tuning Workflow

1. Fit global regression.
2. Identify candidate covariates for spatial variation.
3. Tune smoothing/regularization under spatial validation.
4. Inspect coefficient maps and residual autocorrelation.
5. Compare with [[mgwr]] and [[inla]] when appropriate.

## Dataset Compatibility Notes

- Compatible `Y`: continuous response by default.
- Compatible `X`: predictors with a plausible reason to vary spatially.
- Spatial support: required.
- Temporal support: use [[stvc]] when coefficients vary over both space and time.
- Current benchmark note: no standalone SVC model is wired yet; MGWR/MGWRSAR cover related functionality.

## Open Questions From Papers

- Which SVC backend should become the project implementation route.
- Whether SVC should be represented separately from MGWR in the benchmark.

## Related Pages

- [[mgwr]]
- [[stvc]]
- [[spatial_heterogeneity]]
- [[spatial_regression]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
