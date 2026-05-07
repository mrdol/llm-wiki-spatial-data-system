source("R/utils/estimator_common.R")

# Load every estimator wrapper from the repository root.
# This file is the single R entry point for modeling scripts.
estimator_files <- c(
  "R/estimators/fit_xgboost.R",
  "R/estimators/fit_lightgbm.R",
  "R/estimators/fit_gamboost.R",
  "R/estimators/fit_random_forest.R",
  "R/estimators/fit_mars.R",
  "R/estimators/fit_inla.R",
  "R/estimators/fit_svc.R",
  "R/estimators/fit_stvc.R",
  "R/estimators/fit_mgwr.R",
  "R/estimators/fit_mgwrsar.R",
  "R/estimators/fit_spboost.R",
  "R/estimators/fit_rnn_reticulate.R",
  "R/estimators/fit_svm.R"
)

for (estimator_file in estimator_files) {
  # Source in a fixed order so shared helpers are already available.
  source(estimator_file)
}

invisible(TRUE)
