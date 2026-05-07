source("R/utils/estimator_common.R")

# MGWRSAR wrapper. The package is R-native, but public fitting function names
# can vary, so the wrapper searches known candidates before fitting.
fit_mgwrsar <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("mgwrsar", "MGWRSAR")
  check_columns(data, c(y, x), role = "MGWRSAR variables")
  formula <- build_estimator_formula(y, x)
  namespace <- asNamespace("mgwrsar")
  candidates <- c("MGWRSAR", "mgwrsar", "MGWRSAR_0")

  # Pick the first known fitting function exposed by the installed package.
  fit_name <- candidates[vapply(candidates, exists, logical(1), where = namespace, mode = "function")]
  if (length(fit_name) == 0) {
    stop(
      "Package 'mgwrsar' is installed, but no known fitting function was found. ",
      "Inspect the package API and update R/estimators/fit_mgwrsar.R.",
      call. = FALSE
    )
  }

  # Package-specific spatial weights and multiscale controls go in config.
  fit_fun <- get(fit_name[[1]], envir = namespace)
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(fit_fun, args)
  estimator_result(
    estimator = "MGWRSAR",
    backend_language = "R",
    backend_package = "mgwrsar",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config, backend_function = fit_name[[1]])
  )
}
