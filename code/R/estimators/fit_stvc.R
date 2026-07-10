source("R/utils/estimator_common.R")

# Spatio-temporally varying coefficient wrapper using mgcv smooth interactions.
# This is an R-native variant until the final STVC definition is validated.
fit_stvc <- function(data, y, x, coords, time, config = list()) {
  require_package("mgcv", "spatio-temporally varying coefficient model")
  check_columns(data, c(y, x, coords, time), role = "STVC variables")
  if (length(coords) != 2 || length(time) != 1) {
    stop("STVC requires coords as two column names and time as one column name.", call. = FALSE)
  }

  # Each predictor receives a smooth over space and time.
  terms <- paste(sprintf("s(%s, %s, %s, by = %s)", coords[[1]], coords[[2]], time, x), collapse = " + ")
  base_terms <- paste(x, collapse = " + ")
  formula <- stats::as.formula(paste(y, "~", base_terms, "+", terms))
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(mgcv::gam, args)
  estimator_result(
    estimator = "STVC",
    backend_language = "R",
    backend_package = "mgcv",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
