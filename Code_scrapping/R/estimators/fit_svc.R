source("R/utils/estimator_common.R")

# Spatially varying coefficient wrapper using mgcv smooth interactions.
# This is an R-native variant until the final SVC definition is validated.
fit_svc <- function(data, y, x, coords, time = NULL, config = list()) {
  require_package("mgcv", "spatially varying coefficient model")
  check_columns(data, c(y, x, coords), role = "SVC variables")
  if (length(coords) != 2) {
    stop("SVC requires coords as two column names, for example c('lon', 'lat').", call. = FALSE)
  }

  # Each predictor receives a spatially varying smooth term.
  terms <- paste(sprintf("s(%s, %s, by = %s)", coords[[1]], coords[[2]], x), collapse = " + ")
  base_terms <- paste(x, collapse = " + ")
  formula <- stats::as.formula(paste(y, "~", base_terms, "+", terms))
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(mgcv::gam, args)
  estimator_result(
    estimator = "SVC",
    backend_language = "R",
    backend_package = "mgcv",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
