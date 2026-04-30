source("R/utils/estimator_common.R")

# GAMBoost wrapper using mboost::gamboost.
fit_gamboost <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("mboost", "GAMBoost")
  check_columns(data, c(y, x), role = "GAMBoost variables")
  formula <- build_estimator_formula(y, x)

  # Boosting controls and family settings can be supplied through config.
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(mboost::gamboost, args)
  estimator_result(
    estimator = "GAMBoost",
    backend_language = "R",
    backend_package = "mboost",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
