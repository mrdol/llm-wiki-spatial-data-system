---
title: R Estimator Implementation Policy v1
type: metadata
created: 2026-04-30
updated: 2026-04-30
sources: []
tags: [metadata, estimators, r, reticulate, implementation]
---

Project policy for implementing allowed estimators with R as the first execution layer.

## Purpose

This policy defines how project-approved estimators should be implemented when both R and Python software routes exist.

The modeling layer should prefer R-native implementations for estimators available in R. Python implementations may be used only through an R-facing wrapper, typically with `reticulate`, when no reliable R-native backend exists or when the Python backend is materially stronger for the estimator.

## Scope

This policy applies only to estimators allowed by [[restricted_estimator_policy_v1]]:

- `XGBoost`
- `LightGBM`
- `GAMBoost`
- `Random Forest`
- `MARS`
- `INLA`
- `STVC`
- `SVC`
- `MGWR`
- `MGWRSAR`
- `SpBoost`
- `RNN`
- `SVM`

## Implementation Priority Rules

1. If a maintained R package exists and covers the estimator definition, use the R package as the primary backend.
2. If an R package exists but covers only a simpler variant, keep the wrapper R-native but mark the estimator route as `r_native_variant`.
3. If the estimator is effectively Python-first, expose it through R with `reticulate` and mark the route as `r_wrapper_python`.
4. If neither route is stable, create only a stub wrapper that fails with a clear message and mark the route as `implementation_pending`.
5. All wrappers must preserve the project allowlist and must not introduce non-allowlisted estimators as substitutes.

## Wrapper Contract

Each estimator wrapper should expose one public function named `fit_<estimator>()`.

The function should return a list with these fields when fitting succeeds:

- `estimator`: canonical estimator name from the allowlist
- `backend_language`: usually `R`, or `Python via reticulate`
- `backend_package`: package used for fitting
- `model`: fitted model object
- `metadata`: formula, predictor names, response name, spatial fields, and config

When a backend package is missing, the wrapper should fail early with an installation-oriented error message.

## Data Contract

The common R input should be:

- `data`: a `data.frame`, `sf` object, or package-specific spatial object
- `y`: response variable name as a string
- `x`: predictor variable names as a character vector
- `coords`: optional coordinate column names or spatial object metadata
- `time`: optional time index for temporal or spatio-temporal estimators
- `config`: named list of estimator-specific options

The cross-validation split is deliberately external to the wrapper. Wrappers fit one training set at a time.

## Reticulate Rule

Python backends must be called from R with `reticulate`.

The helper should first try the project virtual environment `.venv` when present. If `.venv` is absent, the helper should leave environment selection to `reticulate`.

No wrapper should require users to call Python directly for an allowed estimator.

## Current Backend Registry

The machine-readable implementation map is stored in:

`data/manifests/estimator_software_registry.jsonl`

R wrapper files live under:

`R/estimators/`

Shared R utilities live under:

`R/utils/`

## Related Pages

- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[r_software_datasets]]
- [[python_software_datasets]]
