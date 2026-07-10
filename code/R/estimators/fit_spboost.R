source("R/utils/estimator_common.R")

# SpBoost est maintenant route vers le package R local `spboost`.
# Le package doit etre installe avant l'appel, par exemple depuis:
# raw/estimators/spboost_0.6.3/spboost
fit_spboost <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("spboost", "SpBoost spatial boosting models")
  require_package("mboost", "SpBoost boost_control objects")

  check_columns(data, c(y, x), role = "SpBoost variables")

  W <- config$W %||% config$spatial_weights
  if (is.null(W)) {
    stop(
      "SpBoost requires a row-standardized spatial weights matrix in config$W ",
      "or config$spatial_weights.",
      call. = FALSE
    )
  }

  formula <- config$formula %||% build_estimator_formula(y, x)
  if (is.character(formula)) {
    formula <- stats::as.formula(formula)
  }

  dgp <- config$DGP %||% config$dgp %||% "SAR"
  default_method <- switch(
    toupper(dgp),
    SAR = "BSPA_SAR_ML",
    SEM = "BSPA_SEM_ML",
    SARAR = "BSPA_SARAR_ML",
    "BSPA_SAR_ML"
  )
  method <- config$method %||% default_method

  control <- config$control %||% list()
  if (!is.null(config$control_gamboost)) {
    control$control_gamboost <- config$control_gamboost
  }
  if (is.null(control$control_gamboost)) {
    boost_args <- config$boost_control %||% list()
    if (is.null(boost_args$mstop)) boost_args$mstop <- config$mstop %||% 500L
    if (is.null(boost_args$nu)) boost_args$nu <- config$nu %||% 0.1
    control$control_gamboost <- do.call(mboost::boost_control, boost_args)
  }

  optional_control <- c(
    "mstop_criterion",
    "mstop_init",
    "nfold",
    "ncore",
    "cv_mode_spatial",
    "rho0",
    "lambda0",
    "verbose"
  )
  for (name in optional_control) {
    if (!is.null(config[[name]]) && is.null(control[[name]])) {
      control[[name]] <- config[[name]]
    }
  }

  W2 <- config$W2 %||% config$spatial_weights_2
  fit_args <- list(
    formula = formula,
    data = data,
    W = W,
    DGP = dgp,
    method = method,
    control = control
  )
  if (!is.null(W2)) {
    fit_args$W2 <- W2
  }

  model <- do.call(spboost::spbgam, fit_args)

  estimator_result(
    estimator = "SpBoost",
    backend_language = "R",
    backend_package = "spboost",
    model = model,
    metadata = list(
      y = y,
      x = x,
      formula = deparse(formula),
      DGP = dgp,
      method = method,
      has_W2 = !is.null(W2),
      mstop = control$control_gamboost@mstop,
      nu = control$control_gamboost@nu,
      mstop_criterion = control$mstop_criterion %||% NA_character_,
      notes = "W is supplied by the caller and must be documented in dataset metadata."
    )
  )
}
