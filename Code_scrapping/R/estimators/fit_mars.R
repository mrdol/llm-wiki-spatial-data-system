source("R/utils/estimator_common.R")

# MARS wrapper using earth::earth.
fit_mars <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("earth", "MARS")
  check_columns(data, c(y, x), role = "MARS variables")
  formula <- build_estimator_formula(y, x)

  # Pass tuning options such as degree, nprune, and penalty via config.
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(earth::earth, args)
  estimator_result(
    estimator = "MARS",
    backend_language = "R",
    backend_package = "earth",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
