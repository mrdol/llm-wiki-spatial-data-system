---
title: MGWRSAR
type: estimator
created: 2026-04-23
updated: 2026-04-30
sources:
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/DESCRIPTION
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/MGWRSAR.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/kernel_matW.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/search_bandwidths.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/predict.mgwrsar.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/mgwrsar_bootstrap_test.Rd
tags: [estimator, spatial, gwr, mgwr, sar, hyperparameters, r-package]
---

MGWRSAR is the project fiche for geographically weighted regression models that combine local or multiscale coefficients with spatial autoregressive dependence.

## Summary

The R package `mgwrsar` implements GWR, mixed GWR, MGWR, GTWR-style space-time kernels, and MGWR-SAR variants. In this system, MGWRSAR is relevant when the data have:

- a continuous response variable `Y`;
- spatial units or points with coordinates;
- candidate explanatory variables `X`;
- evidence of spatial heterogeneity in coefficients;
- possible spatial autocorrelation in the response or residuals.

The package documentation links MGWRSAR to Geniaux and Martinetti (2017) for GWR with spatial autocorrelation and to Geniaux (2026) for multiscale GWR / GTWR top-down scale approaches.

## Estimator Family

- Family: spatial regression with local coefficients and optional spatial lag.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Implementation route: R-first through package `mgwrsar`.
- Related estimators: [[mgwr]], [[svc]], [[stvc]].

## Model Equation

Canonical MGWRSAR form (local coefficients + spatial lag):

`y_i = sum_j beta_j(u_i, v_i) x_ij + lambda * (Wy)_i + epsilon_i`

Where `beta_j(u_i, v_i)` are spatially varying coefficients estimated from the local neighborhood of location `(u_i, v_i)`, `lambda` is the spatial autoregressive parameter, and `W` is the row-standardized spatial weights matrix. In the pure GWR variant, `lambda = 0`. In the mixed MGWR variant, some `beta_j` are fixed (constant) while others are local.

## Model Variants

The main function `MGWRSAR()` exposes several model types through the `Model` argument.

| Model value | Meaning in the system | Main requirement |
|---|---|---|
| `OLS` | Global linear regression baseline | formula and data |
| `SAR` | Global spatial autoregressive model | row-standardized spatial weights matrix `W` |
| `GWR` | Geographically weighted regression with local coefficients | coordinates, kernel, bandwidth |
| `MGWR` | Mixed GWR with fixed and local coefficients | `fixed_vars`, kernel, bandwidth |
| `MGWRSAR_0_0_kv` | MGWR-SAR with fixed spatial lag and varying coefficients | `W`, local coefficient bandwidths |
| `MGWRSAR_1_0_kv` | MGWR-SAR with spatial lag structure and varying coefficients | `W`, local coefficient bandwidths |
| `MGWRSAR_0_kc_kv` | MGWR-SAR with fixed and varying coefficient groups | `fixed_vars`, `W`, bandwidths |
| `MGWRSAR_1_kc_kv` | MGWR-SAR with spatial lag plus fixed and varying coefficient groups | `fixed_vars`, `W`, bandwidths |
| `MGWRSAR_1_kc_0` | SAR-like model with fixed coefficient group | `fixed_vars`, `W` |

`kc` refers to variables treated with constant coefficients. `kv` refers to variables treated with spatially varying coefficients.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | continuous numeric variable | The documented estimator is linear-regression oriented |
| Explanatory variables `X` | numeric or encoded variables | Local models require enough local variation |
| Coordinates | two columns for spatial models; three columns for space-time variants | Used to construct local kernels |
| Spatial weights `W` | row-standardized matrix for SAR/MGWRSAR variants | Defines the spatial lag `Wy` |
| Spatial support | points or areal units | Needed for distance and neighbor structure |
| Metadata | variable typology, CRS, geometry, temporal scope if present | Needed before selecting this estimator |

MGWRSAR is not the first choice for pure rasters, map-only files, or datasets without a response variable.

## Core Hyperparameters

| Hyperparameter | Package argument | Tune? | Notes |
|---|---|---|---|
| Model family | `Model` | yes | Choose between OLS, SAR, GWR, MGWR, and MGWRSAR variants |
| Fixed/local variable split | `fixed_vars` | yes | Determines which X variables are global and which are local |
| Kernel type | `kernels` | yes | Documented choices include `rectangle`, `bisq`, `tcub`, `epane`, `gauss`, `triangle` depending on function |
| Spatial bandwidth | `H` or searched bandwidths | yes | Controls local sample support and coefficient smoothness |
| Adaptive bandwidth | `control$adaptive` | yes | `TRUE` uses neighbor-count logic; `FALSE` uses distance bandwidth |
| Spatial weights | `control$W` | yes | Required for SAR/MGWRSAR; should be documented as part of metadata |
| Spatial-weight kernel | `control$kernel_w` | yes | Kernel used when constructing a spatial weights matrix |
| Spatial-weight bandwidth | `control$h_w` | yes | Bandwidth used for `W` construction |
| SAR estimation method | `control$Method` | usually | Documented choices include `2SLS` and `B2SLS` |
| Kernel variable type | `control$Type` | yes for ST or nonstandard kernels | Examples include `GD` for spatial and `GDT` for space-time |
| Extra kernel variables | `control$Z` | optional | Allows generalized kernels with time, continuous, or categorical dimensions |
| Neighbor truncation | `control$NN` | yes for large data | Limits sparse neighborhood calculations |
| Target points | `control$TP` | optional | Useful for prediction or local estimation at selected locations |
| CPU cores | `control$ncore` | operational | Runtime control, not a scientific hyperparameter |
| LOOCV / GCV flag | `control$isgcv` | diagnostic | Computes leave-one-out style criterion when enabled |

## Bandwidth Search

The package provides `search_bandwidths()` for automated bandwidth selection. It minimizes AICc over spatial and, when relevant, temporal bandwidths.

Important search controls:

| Control | Role |
|---|---|
| `hs_range` | candidate range for spatial bandwidth |
| `ht_range` | candidate range for temporal bandwidth |
| `n_seq` | number of grid points per search round |
| `n_rounds` | number of coarse-to-fine search rounds |
| `refine` | optional final golden-section refinement |
| `tol` | convergence tolerance |
| `ncore` / `parallel_method` | runtime and parallelization controls |

Older functions such as `golden_search_bandwidth()` are documented as deprecated in favor of `search_bandwidths()`.

## Space-Time And Generalized Kernels

`kernel_matW()` documents generalized kernel construction. For this project, the most important `Type` values are:

| Type | Interpretation |
|---|---|
| `GD` | geographic distance only |
| `GDT` | geographic distance plus time index |
| `GDC` | geographic distance plus categorical variable |
| `GDX` | geographic distance plus continuous variable |

This is important because the same estimator family can be used on spatial cross-sections or on spatio-temporal data if the metadata identifies time and the chosen kernel type supports it.

## Prediction Controls

`predict.mgwrsar()` introduces additional controls that must be recorded when prediction results are produced.

| Argument | Role |
|---|---|
| `type` | BLUP or bias-correction choice; default documented as `BPN` |
| `method_pred` | prediction route, default `TP` |
| `h_w` and `kernel_w` | spatial weights used during prediction |
| `maxobs` | threshold for exact matrix solve in spatial prediction |
| `beta_proj` | whether to project coefficient estimates |
| `k_extra` | neighbor count for local parameter extrapolation |
| `exposant` | weighting-shape parameter for some prediction routes |

## Diagnostics To Inspect

- Estimated SAR parameter or local spatial-lag behavior.
- Residual spatial autocorrelation after fitting.
- Local coefficient maps for each varying X.
- Bandwidths by coefficient and their plausibility.
- Sensitivity to `W`, `kernel_w`, and `h_w`.
- AICc, LOOCV/GCV, RMSE, MAE, and out-of-sample metrics when available.
- Bootstrap comparison with `mgwrsar_bootstrap_test()` when comparing nested or alternative models.

## Cross-validation Policy

MGWRSAR must not be validated with naive random folds when observations are spatially or spatio-temporally dependent.

Recommended validation protocols:

- spatial block validation for spatial cross-sections;
- leave-location-out validation when prediction to new places is the goal;
- time-forward or blocked space-time validation when a temporal dimension is present;
- recalculation or strict documentation of `W` for each validation split.

## Failure Modes

- Confounding between spatial lag dependence and local coefficient variation.
- Unstable local coefficients when local neighborhoods contain weak variation in X.
- Strong sensitivity to the spatial weights matrix.
- Excessive compute cost for large candidate datasets.
- Apparent fit improvement caused by spatial leakage in validation.

## Minimal Tuning Workflow

1. Fit OLS and inspect residual spatial autocorrelation.
2. Fit SAR if `W` is defensible.
3. Fit GWR or MGWR to test spatial heterogeneity.
4. Fit MGWRSAR only when both local heterogeneity and spatial dependence remain plausible.
5. Search bandwidths with AICc or validation metrics.
6. Report selected `Model`, `fixed_vars`, `kernels`, bandwidths, `W` construction, validation protocol, and residual diagnostics.

## Metadata Fields To Record

When a dataset is linked to MGWRSAR, the metadata should record:

- `Y` variable name and type;
- `X_candidate` and `X_selected`;
- coordinate fields and CRS;
- temporal field if `Type = GDT`;
- `W` construction rule;
- chosen model variant;
- kernel and bandwidth values;
- validation protocol and leakage controls;
- whether an existing paper equation or model formulation was found.

## Related Pages

- [[mgwr]]
- [[svc]]
- [[stvc]]
- variable typology
- modeling evidence
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
