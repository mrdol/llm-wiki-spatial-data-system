source("R/utils/estimator_common.R")

# MGWR wrapper using GWmodel when its multiscale GWR function is available.
fit_mgwr <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("GWmodel", "MGWR")
  check_columns(data, c(y, x), role = "MGWR variables")
  formula <- build_estimator_formula(y, x)

  # GWmodel APIs vary by version, so check for the exact multiscale entry point.
  if (!exists("gwr.multiscale", where = asNamespace("GWmodel"), mode = "function")) {
    stop("GWmodel is installed, but GWmodel::gwr.multiscale is not available in this version.", call. = FALSE)
  }

  # Spatial arguments such as bandwidth, kernel, and distance options go in config.
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(GWmodel::gwr.multiscale, args)
  estimator_result(
    estimator = "MGWR",
    backend_language = "R",
    backend_package = "GWmodel",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
