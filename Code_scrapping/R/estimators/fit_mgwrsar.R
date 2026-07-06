source("R/utils/estimator_common.R")

# MGWRSAR wrapper. The package is R-native, but public fitting function names
# can vary, so the wrapper searches known candidates before fitting.
#
# Confirmed signature (2026-07-02, mgwrsar 1.3.2, R/MGWRSAR.R:132):
#   MGWRSAR(formula, data, coords, fixed_vars=NULL, kernels, H, Model="GWR", control=list())
# `coords`, `kernels` and `H` have no defaults in the underlying function, so the
# caller must supply `coords` (this wrapper's own argument) and `kernels`/`H`
# (via `config`) explicitly.
fit_mgwrsar <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("mgwrsar", "MGWRSAR")
  check_columns(data, c(y, x), role = "MGWRSAR variables")
  if (is.null(coords)) {
    stop(
      "MGWRSAR requires `coords` (column names or a coordinate matrix) — none supplied.",
      call. = FALSE
    )
  }
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

  # `coords` was previously dropped here — it must be forwarded explicitly,
  # config alone does not carry it unless the caller duplicates it manually.
  fit_fun <- get(fit_name[[1]], envir = namespace)
  args <- c(list(formula = formula, data = data, coords = coords), config)
  model <- do.call(fit_fun, args)
  estimator_result(
    estimator = "MGWRSAR",
    backend_language = "R",
    backend_package = "mgwrsar",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config, backend_function = fit_name[[1]])
  )
}
