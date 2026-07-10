source("R/utils/estimator_common.R")

# INLA wrapper. Use config$formula for spatial or temporal latent effects.
fit_inla <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("INLA", "INLA")
  check_columns(data, c(y, x), role = "INLA variables")

  # INLA model structure is often encoded directly in the formula.
  formula <- config$formula %||% build_estimator_formula(y, x)
  family <- config$family %||% "gaussian"
  args <- c(
    list(formula = formula, family = family, data = data),
    config[setdiff(names(config), c("formula", "family"))]
  )
  model <- do.call(INLA::inla, args)
  estimator_result(
    estimator = "INLA",
    backend_language = "R",
    backend_package = "INLA",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
