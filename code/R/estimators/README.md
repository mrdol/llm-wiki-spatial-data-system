# R estimator wrappers

This directory contains R-first wrappers for the estimators allowed by the project policy.

The machine-readable registry is:

`data/manifests/estimator_software_registry.jsonl`

The governing wiki policy is:

`wiki/metadata/r_estimator_implementation_policy_v1.md`

Load all wrappers from the repository root with:

```r
source("R/estimators/load_estimators.R")
```

## Interface

Most wrappers use:

```r
fit_<estimator>(
  data,
  y,
  x,
  coords = NULL,
  time = NULL,
  config = list()
)
```

`RNN` is the exception because sequence models require pre-shaped arrays:

```r
fit_rnn_reticulate(x_array, y_array, config = list(), venv = ".venv")
```

## Status

- R-native wrappers: XGBoost, LightGBM, GAMBoost, Random Forest, MARS, INLA, MGWR, MGWRSAR, SpBoost, SVM.
- R-native variants: SVC and STVC via `mgcv::gam`.
- Python-through-R route: RNN via `reticulate` and `tensorflow.keras`.
- SpBoost uses the local R package source under `raw/estimators/spboost_0.6.3/spboost`; install it manually before fitting. See `R/estimators/manual_spboost_example.R`.

Cross-validation remains external to these wrappers.
