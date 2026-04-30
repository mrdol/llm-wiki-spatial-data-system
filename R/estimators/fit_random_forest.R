source("R/utils/estimator_common.R")

# Random Forest wrapper using ranger as the preferred fast R backend.
fit_random_forest <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("ranger", "Random Forest")
  check_columns(data, c(y, x), role = "Random Forest variables")
  formula <- build_estimator_formula(y, x)

  # Pass tuning options such as num.trees, mtry, and min.node.size via config.
  args <- c(
    list(formula = formula, data = data),
    config
  )
  model <- do.call(ranger::ranger, args)
  estimator_result(
    estimator = "Random Forest",
    backend_language = "R",
    backend_package = "ranger",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
