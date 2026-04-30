source("R/utils/estimator_common.R")

# SpBoost is allowlisted, but no stable backend has been validated yet.
# This explicit stub prevents accidental substitution with a non-approved method.
fit_spboost <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  stop(
    "SpBoost backend is not validated yet. ",
    "Keep this estimator in implementation_pending status until a stable R or reticulate route is selected.",
    call. = FALSE
  )
}
