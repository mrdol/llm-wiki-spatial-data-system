# Shared helpers for all R estimator wrappers.
# These functions keep validation and return objects consistent across backends.

require_package <- function(package, why = NULL) {
  # Fail early with an explicit installation message.
  if (!requireNamespace(package, quietly = TRUE)) {
    reason <- if (is.null(why)) "" else paste0(" for ", why)
    stop(
      "Required R package '", package, "' is not installed", reason, ". ",
      "Install it before fitting this estimator.",
      call. = FALSE
    )
  }
  invisible(TRUE)
}

build_estimator_formula <- function(y, x) {
  # Build the standard y ~ x1 + x2 + ... formula used by formula-based models.
  stopifnot(is.character(y), length(y) == 1, nzchar(y))
  stopifnot(is.character(x), length(x) >= 1, all(nzchar(x)))
  stats::as.formula(paste(y, "~", paste(x, collapse = " + ")))
}

check_columns <- function(data, columns, role = "columns") {
  # Centralize column checks so wrappers report missing variables consistently.
  missing <- setdiff(columns, names(data))
  if (length(missing) > 0) {
    stop(
      "Missing ", role, " in data: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(TRUE)
}

model_matrix_xy <- function(data, y, x) {
  # Convert data.frame inputs into matrix/response objects for boosting libraries.
  check_columns(data, c(y, x), role = "model variables")
  formula <- build_estimator_formula(y, x)
  frame <- stats::model.frame(formula, data = data, na.action = stats::na.omit)
  response <- stats::model.response(frame)
  design <- stats::model.matrix(formula, data = frame)
  intercept <- match("(Intercept)", colnames(design), nomatch = 0)
  if (intercept > 0) {
    design <- design[, -intercept, drop = FALSE]
  }
  list(formula = formula, frame = frame, y = response, x = design)
}

estimator_result <- function(estimator, backend_language, backend_package, model, metadata = list()) {
  # Standard return contract used by every fit_* wrapper.
  list(
    estimator = estimator,
    backend_language = backend_language,
    backend_package = backend_package,
    model = model,
    metadata = metadata
  )
}

load_project_reticulate <- function(venv = ".venv", required = FALSE) {
  # Configure reticulate only when a Python-backed estimator is requested.
  require_package("reticulate", "Python-backed R wrappers")
  if (dir.exists(venv)) {
    reticulate::use_virtualenv(venv, required = required)
  }
  invisible(TRUE)
}

`%||%` <- function(x, y) {
  # Use y when x is NULL.
  if (is.null(x)) y else x
}
