---
title: MGWR
type: estimator
created: 2026-04-23
updated: 2026-07-06
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

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Fotheringham, Yang and Kang (2017) | paper_supported | canonical MGWR motivation and multiscale coefficient interpretation |
| Oshan et al. (2019) | paper_supported | Python implementation reference and computational framing |
| `mgwrsar` package docs | implementation_supported | R backend route through `TDS_MGWR()` |

## Main Use Cases

- Interpret spatially varying covariate effects at different scales.
- Compare single-bandwidth GWR against true multiscale MGWR.
- Diagnose which covariates behave locally and which are closer to global.
- Produce local coefficient maps for spatial interpretation.

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

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| covariate-specific bandwidths | local scale per coefficient | yes | paper_supported | central MGWR quantity |
| `kernels` | local weighting function | yes/later | implementation_supported | current benchmark uses `gauss` for `tds_mgwr` |
| `fixed_vars` | variables held global in mixed variants | later | implementation_supported | not yet tuned in the benchmark |
| `control_tds$nns` | top-down scale grid size | later | implementation_supported | currently fixed in wrapper |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `control_tds$tol` | convergence tolerance | no/later | implementation_supported | numerical stability |
| `control_tds$maxit` | maximum backfitting iterations | no/later | implementation_supported | runtime cap |
| `control$ncore` | parallel execution | no | implementation_supported | operational |
| `control$NN` | neighborhood truncation | later | implementation_supported | useful for large datasets |

## Hyperparameter Interactions

- Bandwidths cannot be interpreted independently of kernel type.
- Very small bandwidths can create unstable coefficient maps and local collinearity.
- `fixed_vars` changes the target model: a mixed MGWR is not only a faster MGWR.

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

## Prediction Controls

For `mgwrsar::TDS_MGWR()` fits, prediction is not the same route as plain
GWR. The project wrapper uses the prediction method that the backend supports
for top-down multiscale models.

| Control | Role |
|---|---|
| `method_pred = "shepard"` | required project route for `tds_mgwr` / `atds_mgwr` prediction |
| automatic `TP` -> `shepard` switch | documented backend behavior when `TP` is not implemented |
| `h_w` / `kernel_w` | spatial-weight prediction controls for backends that need W-style extrapolation |
| `beta_proj` | controls projection of local coefficients when available |
| `k_extra` | neighbor count for local extrapolation in prediction |

In the current benchmark, `mgwrsar_multiscale` requests `method_pred =
"shepard"` explicitly instead of relying on the backend's automatic fallback.

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

## Dataset Compatibility Notes

- Compatible `Y`: continuous numeric response.
- Compatible `X`: numeric or encoded predictors with enough local variation.
- Spatial requirement: coordinates in a metric CRS or defensible centroids.
- Temporal support: possible only when a real time index is available and a space-time kernel is selected.
- Missing data: complete-case filtering should be finished before bandwidth search.

## Open Questions From Papers

- Whether `atds_mgwr` should be benchmarked despite higher runtime.
- Whether bandwidth interpretation remains stable on the larger catalog datasets.
- Whether local collinearity diagnostics should become mandatory before reporting coefficient maps.

## Project `parsnip` Engine (added 2026-07-04)

The manual `tidymodels` benchmark pipeline
(`wiki/metadata/tidymodels_spatial_pipeline_status_2026-07.md`) exposes true
multiscale MGWR through the same `mgwrsar_reg()` engine documented in
[[mgwrsar]] (`Code_scrapping/R/estimators/parsnip_mgwrsar.R`), via two special
`model_type` values that route to `mgwrsar::TDS_MGWR()` instead of
`mgwrsar::MGWRSAR()`:

```r
mgwrsar_reg(
  coords = c("coord_x", "coord_y"),
  model_type = "tds_mgwr",   # or "atds_mgwr"
  kernels = "gauss"
) |>
  parsnip::set_engine("mgwrsar") |>
  parsnip::set_mode("regression")
```

Why this distinction matters: `mgwrsar_reg(model_type = "GWR")` (the engine's
default, see [[mgwrsar]]) is plain single-bandwidth GWR, not multiscale MGWR
-- `MGWRSAR()`'s own `Model="MGWR"` path expects a pre-computed bandwidth
*vector* (one value per covariate, confirmed in `man/MGWR.Rd`: `H: A vector of
bandwidths`) that the engine does not compute. `TDS_MGWR()` is self-contained:
it finds that per-covariate bandwidth vector itself through the top-down-scale
backfitting algorithm, so no external `bandwidth`/`kernels` grid search is
needed for these two `model_type` values (they are ignored/unused, unlike
`"GWR"` where `bandwidth` is required).

Implementation notes:

- Prediction requires `method_pred="shepard"` for `tds_mgwr`/`atds_mgwr` fits
  -- `predict_mgwrsar()` itself documents that `method_pred="TP"` (the
  engine's implicit default reasoning) is not implemented for these models and
  auto-switches to `"shepard"`; the engine requests it directly rather than
  relying on the auto-switch.
- `control_tds$nns` (number of bandwidth steps in the decreasing sequence) is
  hardcoded to `20L` in the engine, the paper's recommended default (M=20-30).
  It gets auto-truncated by the package for small N (observed: truncated to
  16 on Georgia, N=159) -- worth checking the truncation message on larger
  datasets.
- On Georgia (N=159), `mgwrsar_multiscale` (`tds_mgwr`) beat plain
  `mgwrsar` (`GWR`) on all three CV schemes used in the benchmark: holdout
  RMSE 2.766 vs 2.811, near-prediction RMSE 3.045 vs 3.140, block-spatial
  RMSE 3.293 vs 3.526. The fitted per-covariate bandwidth vector was
  genuinely heterogeneous (e.g. `PctFB` converged to a much smaller bandwidth
  than the other covariates), consistent with the MGWR hypothesis that
  different covariates operate at different spatial scales.

Project update (2026-07-06): `mgwrsar_multiscale` remains the benchmark name
for true MGWR through `TDS_MGWR()`. The new `mgwrsar_autocorr` route belongs
to [[mgwrsar]], not to pure MGWR, because it adds an explicit spatial lag
component through `W`.

## Related Pages

- [[mgwrsar]]
- [[svc]]
- [[stvc]]
- variable typology
- modeling evidence
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
