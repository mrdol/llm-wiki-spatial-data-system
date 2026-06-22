---
title: MGWR
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.pdf
  - Fotheringham, Yang and Kang 2017, Multiscale Geographically Weighted Regression, doi:10.1080/24694452.2017.1352480
  - Wu, Ren, Hu and Du 2018, Multiscale geographically and temporally weighted regression, doi:10.1080/13658816.2018.1545158
  - Oshan et al. 2019, mgwr: a Python implementation of multiscale geographically weighted regression, doi:10.3390/ijgi8060269
  - Li and Fotheringham 2020, Computational improvements to multi-scale geographically weighted regression, doi:10.1080/13658816.2020.1720692
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/DESCRIPTION
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/multiscale_gwr.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/TDS_MGWR.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/kernel_matW.Rd
  - raw/estimators/Mgwrsar/mgwrsar_1.3.2/mgwrsar/man/search_bandwidths.Rd
tags: [estimator, spatial, gwr, mgwr, multiscale, hyperparameters, r-package, paper-supported]
---

MGWR is the project fiche for multiscale geographically weighted regression, where each explanatory variable may operate at a different spatial scale.

## Summary

MGWR extends GWR by estimating covariate-specific bandwidths. In this system, it is useful when:

- the response `Y` is continuous;
- the data have explicit spatial coordinates or areal geometry;
- several explanatory variables may have effects at different spatial scales;
- the goal is interpretation of spatially varying relationships, not only prediction.

The local R source currently available in `raw/estimators/Mgwrsar` documents two implementation routes:

- `multiscale_gwr()` for backfitting-based MGWR;
- `TDS_MGWR()` for top-down scale MGWR and adaptive top-down variants.

Reference papers establish MGWR as a response to single-bandwidth GWR: each
coefficient can operate at its own spatial scale. The Python `mgwr` paper is
useful for implementation comparison, while Li and Fotheringham (2020) should be
used when runtime and scalability are central.

## Estimator Family

- Family: multiscale geographically weighted regression.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Implementation route: R-first through package `mgwrsar`; `GWmodel` may remain an alternative backend if later needed.
- Related estimators: [[mgwrsar]], [[svc]], [[stvc]].

## Model Equation

Canonical MGWR form:

`y_i = beta_0(s_i) + sum_j beta_j(s_i; b_j) x_ij + epsilon_i`

Each coefficient `beta_j` can have its own bandwidth `b_j`. A small bandwidth implies a highly local effect; a large bandwidth implies an effect closer to global.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | continuous numeric variable | MGWR is documented as a regression estimator |
| Explanatory variables `X` | numeric or encoded variables | Each selected variable can receive its own scale |
| Coordinates | two columns for spatial; three columns for space-time variants | Needed for kernel weights |
| Spatial support | points or areal centroids | Defines local neighborhoods |
| Variable metadata | `X_candidate`, `X_selected`, and variable types | Avoids fitting every available X without justification |

MGWR is not appropriate for a dataset that only contains cartographic geometry without a modeling target.

## Paper Ingest Notes

- [[fotheringham_yang_kang_2017_mgwr]] is the canonical MGWR paper. Its current
  KG ingest exposes model formulas, simulation benchmarks and an Irish famine
  empirical application. Some automatically detected dataset/package relations
  are weak and should be manually checked before being treated as validated.
- [[wu_ren_hu_du_2018_mgtwr]] is the current corpus bridge from MGWR to
  spatio-temporal multiscale modeling. It uses Shenzhen housing prices,
  structural/locational/neighbourhood covariates, and compares HPM, MGWR, GTWR
  and MGTWR.

## Core Hyperparameters

| Hyperparameter | Package argument | Tune? | Notes |
|---|---|---|---|
| Kernel type | `kernels` | yes | `bisq` is documented as default in `multiscale_gwr()`; other choices include `gauss`, `triangle`, `tricube`, and `rectangle` |
| Covariate-specific bandwidths | `H0`, searched `H`, or fitted bandwidths | yes | Central MGWR control |
| Initialization | `control_mgwr$init` | sometimes | Documented choices include `GWR` and `lm` |
| Maximum iterations | `control_mgwr$maxiter` | operational | Default documented as 20 |
| Convergence tolerance | `control_mgwr$tolerance` | operational | Default documented as `1e-6` |
| Stability count | `control_mgwr$nstable` | operational | Default documented as 6 |
| AIC computation | `control_mgwr$get_AIC` | diagnostic | Enables AIC-related output |
| Adaptive bandwidth | `control$adaptive` | yes | Default documented as `TRUE` |
| Kernel type mode | `control$Type` | yes for ST models | `GD` for spatial, `GDT` for space-time |
| Neighbor truncation | `control$NN` | yes for large data | Controls sparse local computation |
| CPU cores | `control$ncore` | operational | Runtime control |
| LOOCV/GCV flag | `control$isgcv` | diagnostic | Leave-one-out style criterion |

## Top-Down Scale MGWR

`TDS_MGWR()` adds a top-down bandwidth-selection strategy. It is especially relevant when full multiscale backfitting is too costly or when the project wants a structured decreasing scale search.

| Argument | Role |
|---|---|
| `Model` | `tds_mgwr`, `atds_mgwr`, or `atds_gwr` |
| `fixed_vars` | variables kept with fixed/global coefficients |
| `Ht` | optional temporal bandwidth for `GDT` models |
| `control_tds$nns` | number of bandwidth steps in the decreasing sequence |
| `control_tds$init_model` | initialization route: `OLS`, `GWR`, `GTWR`, or `known` |
| `control_tds$tol` | convergence tolerance |
| `control_tds$maxit` | maximum iterations |
| `control_tds$nrounds` | boosting rounds for `atds_mgwr` stage 2 |
| `control_tds$get_AIC` | AICc computation flag |

The adaptive top-down variant can be useful when local bandwidths should vary by variable and by location.

## Bandwidth Search

For project use, bandwidth selection should be documented explicitly. `search_bandwidths()` supports:

- spatial search through `hs_range`;
- temporal search through `ht_range`;
- coarse-to-fine grid search with `n_seq` and `n_rounds`;
- optional golden-section refinement with `refine`;
- tolerance control with `tol`;
- parallel execution with `ncore` and `parallel_method`.

The selected bandwidths must be stored in metadata or modeling results, not only printed in the console.

For KG and wiki traceability, each MGWR run should create explicit relations:

- `Dataset SHOWS_FORMULA Formula`;
- `Formula USES_RESPONSE ResponseVariable`;
- `Formula USES_COVARIATE Covariate`;
- `Estimator USES_HYPERPARAMETER Bandwidth`;
- `Estimator IMPLEMENTED_BY Package`.

## Space-Time Extension

MGWR is primarily spatial, but the local package exposes space-time kernels through `Type = GDT` and three-column coordinates. In this project:

- use MGWR for spatial cross-sections;
- use GDT or TDS/GTWR-style settings only when the dataset has a real temporal index;
- prefer blocked space-time validation when time is used in the kernel.

## Diagnostics To Inspect

- Bandwidth by variable.
- Local coefficient maps.
- Residual spatial autocorrelation.
- Convergence status and number of iterations.
- Sensitivity to kernel type and adaptive bandwidth.
- Local collinearity or unstable local coefficients.
- AICc, LOOCV/GCV, RMSE, MAE, or out-of-sample metrics depending on the validation protocol.

## Cross-validation Policy

MGWR should be validated with spatially aware folds.

Recommended protocols:

- spatial block validation;
- leave-location-out validation for transfer to new locations;
- blocked space-time validation if `Type = GDT`;
- comparison against global linear regression and single-scale GWR.

## Failure Modes

- Overinterpretation of noisy local coefficients.
- Local collinearity between X variables.
- Too-small bandwidths producing unstable coefficient surfaces.
- Runtime issues with large datasets.
- Validation leakage if spatial neighbors from validation data are used during training.

## Minimal Tuning Workflow

1. Define `Y`, `X_candidate`, and `X_selected`.
2. Fit global linear regression.
3. Fit GWR as a single-scale baseline.
4. Fit MGWR with adaptive bandwidths.
5. Compare bandwidths, validation metrics, and residual spatial autocorrelation.
6. If time is present, test `GDT` or TDS variants only with blocked temporal validation.

## Metadata Fields To Record

For every MGWR modeling run, record:

- response variable and type;
- `X_candidate` and `X_selected`;
- coordinates and CRS;
- temporal field if used;
- kernel type;
- adaptive/fixed bandwidth choice;
- selected bandwidth per variable;
- validation protocol;
- residual spatial autocorrelation diagnostics.

## Related Pages

- [[mgwrsar]]
- [[svc]]
- [[stvc]]
- variable typology
- modeling evidence
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
