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

drop_formula_terms <- function(formula, terms_to_drop, data = NULL) {
  # Retire certains termes d'une formule. Utilise surtout pour enlever
  # coord_x/coord_y avant l'appel au backend, car les coordonnees servent a la
  # structure spatiale mais ne doivent pas etre traitees comme covariables X.
  response <- deparse(formula[[2]])
  terms_to_keep <- setdiff(attr(stats::terms(formula, data = data), "term.labels"), terms_to_drop)
  rhs <- if (length(terms_to_keep) == 0) "1" else paste(terms_to_keep, collapse = " + ")
  stats::as.formula(paste(response, "~", rhs), env = environment(formula))
}

sanitize_formula_response <- function(formula, data, response_name = "response_var") {
  # workflows/parsnip renomme parfois la reponse en "..y". Certains packages
  # natifs n'acceptent pas ce nom special. On copie donc la reponse dans une
  # colonne stable "response_var" et on met la formule a jour.
  response <- deparse(formula[[2]])
  if (response == response_name) {
    return(list(formula = formula, data = data))
  }
  if (response %in% names(data) && (response == "..y" || make.names(response) != response)) {
    data[[response_name]] <- data[[response]]
    data[[response]] <- NULL
    formula[[2]] <- as.name(response_name)
  }
  list(formula = formula, data = data)
}

build_gam_spatial_formula <- function(y, x, coords) {
  # Build y ~ x1 + x2 + ... + s(lon, lat) — a single global spatial trend
  # smooth added on top of linear covariate terms, for mgcv::gam via
  # parsnip::gen_additive_mod(engine = "mgcv"). Deliberately simpler than
  # fit_svc.R's spatially-varying-coefficient formula (which makes every
  # coefficient vary in space) — here only the intercept-level trend is
  # smoothed spatially, matching "GAM avec un lisseur spatial" as a distinct,
  # lighter baseline from SVC.
  stopifnot(is.character(y), length(y) == 1, nzchar(y))
  stopifnot(is.character(x), length(x) >= 1, all(nzchar(x)))
  stopifnot(is.character(coords), length(coords) == 2, all(nzchar(coords)))
  rhs <- paste(c(x, sprintf("s(%s, %s)", coords[[1]], coords[[2]])), collapse = " + ")
  formula <- stats::as.formula(paste(y, "~", rhs))
  # Rattache mgcv::s a l'environnement de la formule pour les appels directs
  # parsnip::fit(). Le workflow complet reste evite pour ce modele dans le
  # benchmark, car model.frame gere mal le terme s() dans ce chemin.
  environment(formula)$s <- mgcv::s
  formula
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
