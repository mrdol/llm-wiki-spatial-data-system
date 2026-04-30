---
title: R Estimator Backend Audit 2026-04-30
type: analysis
created: 2026-04-30
updated: 2026-04-30
sources: []
tags: [analysis, modeling, estimators, r, reticulate]
---

Audit of the R-first implementation route for the project allowlisted estimators.

## Summary

The modeling layer now has a first implementation map that privileges R-native packages and keeps Python-only routes behind R wrappers with `reticulate`.

The canonical machine-readable registry is `data/manifests/estimator_software_registry.jsonl`.

## Backend Decisions

| Estimator | R route | Python route | Status | Action |
|---|---|---|---|---|
| XGBoost | `xgboost` | optional `reticulate` fallback | `native_r` | Use R first |
| LightGBM | `lightgbm` | optional `reticulate` fallback | `native_r` | Use R first, watch installation |
| GAMBoost | `mboost` | none selected | `native_r` | Use R first |
| Random Forest | `ranger` | not needed | `native_r` | Use R first |
| MARS | `earth` | none selected | `native_r` | Use R first |
| INLA | `INLA` | none selected | `native_r` | Use R first |
| SVC | `mgcv` spatially varying smooth variant | optional Python `mgwr` route | `r_native_variant` | Validate against estimator fiche |
| STVC | `mgcv` spatio-temporal smooth variant | none selected | `r_native_variant` | Validate against estimator fiche |
| MGWR | `GWmodel` | optional Python `mgwr` route | `native_r` | Use R first |
| MGWRSAR | `mgwrsar` | none selected | `native_r` | Confirm exact package API before production fitting |
| SpBoost | none validated | none selected | `implementation_pending` | Select package route before fitting |
| RNN | R wrapper around `tensorflow.keras` | Python backend through `reticulate` | `r_wrapper_python` | Keep Python hidden behind R |
| SVM | `e1071` | not needed | `native_r` | Use R first |

## Wrapper Files

- `R/estimators/fit_xgboost.R`
- `R/estimators/fit_lightgbm.R`
- `R/estimators/fit_gamboost.R`
- `R/estimators/fit_random_forest.R`
- `R/estimators/fit_mars.R`
- `R/estimators/fit_inla.R`
- `R/estimators/fit_svc.R`
- `R/estimators/fit_stvc.R`
- `R/estimators/fit_mgwr.R`
- `R/estimators/fit_mgwrsar.R`
- `R/estimators/fit_spboost.R`
- `R/estimators/fit_rnn_reticulate.R`
- `R/estimators/fit_svm.R`

## Open Validation Points

- Confirm whether `GWmodel::gwr.multiscale` covers the project MGWR definition sufficiently.
- Confirm the exact public fitting function exposed by the installed `mgwrsar` package.
- Select or reject a concrete `SpBoost` backend before any production fit.
- Decide whether SVC and STVC should remain `mgcv` smooth variants or move to a more specialized spatial package.
- Add estimator-specific tests once the first modeling dataset is fixed.

## Related Pages

- [[r_estimator_implementation_policy_v1]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
