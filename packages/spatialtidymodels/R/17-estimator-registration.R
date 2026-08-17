# API d'extension: enregistrer un estimateur spatial "maison".
#
# Objectif direct de cette couche: quelqu'un qui vient de developper une
# nouvelle variante d'un estimateur (ex. un SAR non lineaire, un SAR
# boosting different de spboost) doit pouvoir la brancher au benchmark et a
# compare_estimator_variant() SANS editer fit_one_benchmark_estimator() ni le
# registre interne du package.
#
# Contrat minimal demande a l'utilisateur:
#   fit(formula, data, coords)      -> un objet modele quelconque
#   predict(fit, new_data)          -> un vecteur numerique de predictions
#
# Ce contrat est volontairement etroit. requires_W = TRUE est pour l'instant
# une metadonnee informative (affichee par available_benchmark_estimators()),
# pas encore une construction automatique de W passee au fit -- si
# l'estimateur a besoin d'une matrice de voisinage, la construire dans `fit`
# avec build_knn_W()/build_knn_listw() (deja exportees). Le tuning
# (tune = TRUE) n'est pas non plus supporte pour les estimateurs enregistres
# ici: benchmark_tuning_grid() retourne NULL pour un nom d'estimateur inconnu
# de default_benchmark_grid(), donc le tuning est silencieusement ignore --
# fixer les hyperparametres dans la fermeture de `fit` a la place.

custom_estimator_registry_env <- new.env(parent = emptyenv())

#' Register a custom spatial estimator for the benchmark
#'
#' Plugs a user-supplied estimator into `benchmark_spatial()`,
#' `available_benchmark_estimators()` and, downstream,
#' `compare_estimator_variant()`, without touching package internals. This is
#' the entry point for testing a new variant of a reference estimator (e.g. a
#' nonlinear or boosted SAR) against the package's built-in routes.
#'
#' @param id Estimator name, used in `estimators = c(...)` and in comparison
#'   calls. Must not collide with a built-in estimator name.
#' @param fit A function with signature `function(formula, data, coords)`
#'   returning a fitted model object. If the estimator needs a spatial
#'   weights matrix, build it inside `fit` (e.g. with `build_knn_W()`).
#' @param predict A function with signature `function(fit, new_data)`
#'   returning a numeric vector of predictions, same length and row order as
#'   `new_data`.
#' @param family Free-text label grouping this estimator with related ones
#'   (e.g. `"sar"`, `"boosting"`). Purely informative.
#' @param reference_estimator Name of the built-in (or another registered)
#'   estimator this one should be compared against by default -- feeds
#'   `compare_estimator_variant(reference = ...)` conventions and any future
#'   dashboard grouping. Purely informative; not enforced.
#' @param requires_coords,requires_W Informative flags describing what the
#'   estimator needs; `requires_W` does not yet trigger automatic `W`
#'   construction (see Details above the source).
#' @param tunable_parameters Character vector naming hyperparameters, for
#'   display in `available_benchmark_estimators()`. Tuning via
#'   `benchmark_spatial(tune = TRUE)` is not yet wired for registered
#'   estimators.
#' @param package Optional R package name this estimator depends on; used by
#'   `available_benchmark_estimators(include_installed = TRUE)`. Leave `NA`
#'   (default) if there is no package dependency to check.
#' @param notes Free-text notes shown in `available_benchmark_estimators()`.
#' @param overwrite If `FALSE` (default), re-registering an existing `id`
#'   errors instead of silently replacing it.
#'
#' @return `id`, invisibly.
#' @export
register_spatial_estimator <- function(id, fit, predict,
                                       family = NA_character_,
                                       reference_estimator = NA_character_,
                                       requires_coords = TRUE,
                                       requires_W = FALSE,
                                       tunable_parameters = character(0),
                                       package = NA_character_,
                                       notes = "",
                                       overwrite = FALSE) {
  if (!is.character(id) || length(id) != 1L || !nzchar(id)) {
    stop("`id` doit etre une chaine de longueur 1.", call. = FALSE)
  }
  if (id %in% fallback_spatial_benchmark_registry()$estimator) {
    stop(sprintf("'%s' est deja le nom d'un estimateur integre au package -- choisissez un autre id.", id), call. = FALSE)
  }
  if (!isTRUE(overwrite) && exists(id, envir = custom_estimator_registry_env, inherits = FALSE)) {
    stop(sprintf("Un estimateur '%s' est deja enregistre. Utilisez overwrite = TRUE pour le remplacer.", id), call. = FALSE)
  }
  if (!is.function(fit) || !all(c("formula", "data", "coords") %in% names(formals(fit)))) {
    stop("`fit` doit etre une fonction avec les arguments formula, data, coords.", call. = FALSE)
  }
  if (!is.function(predict) || length(formals(predict)) < 2L) {
    stop("`predict` doit etre une fonction function(fit, new_data).", call. = FALSE)
  }

  assign(
    id,
    list(
      id = id, fit = fit, predict = predict,
      family = family, reference_estimator = reference_estimator,
      requires_coords = isTRUE(requires_coords), requires_W = isTRUE(requires_W),
      tunable_parameters = tunable_parameters,
      package = package, notes = notes
    ),
    envir = custom_estimator_registry_env
  )
  invisible(id)
}

#' Remove a registered custom spatial estimator
#'
#' @param id Estimator name previously passed to [register_spatial_estimator()].
#' @return `id`, invisibly.
#' @export
unregister_spatial_estimator <- function(id) {
  if (exists(id, envir = custom_estimator_registry_env, inherits = FALSE)) {
    rm(list = id, envir = custom_estimator_registry_env)
  }
  invisible(id)
}

get_custom_estimator <- function(id) {
  if (!exists(id, envir = custom_estimator_registry_env, inherits = FALSE)) return(NULL)
  get(id, envir = custom_estimator_registry_env, inherits = FALSE)
}

custom_estimator_registry_as_df <- function() {
  ids <- ls(custom_estimator_registry_env)
  empty <- data.frame(
    estimator = character(0), status = character(0), mode = character(0),
    package = character(0), backend = character(0), automatic = logical(0),
    requires_coords = logical(0), requires_W = logical(0),
    spatial_args = character(0), tunable_parameters = character(0),
    notes = character(0), family = character(0), reference_estimator = character(0),
    stringsAsFactors = FALSE
  )
  if (!length(ids)) return(empty)
  entries <- mget(ids, envir = custom_estimator_registry_env)
  rows <- lapply(entries, function(e) {
    data.frame(
      estimator = e$id,
      status = "automatic",
      mode = "regression",
      package = e$package %||% NA_character_,
      backend = "user_registered",
      automatic = TRUE,
      requires_coords = isTRUE(e$requires_coords),
      requires_W = isTRUE(e$requires_W),
      spatial_args = if (isTRUE(e$requires_W)) "coords/W" else if (isTRUE(e$requires_coords)) "coords" else "",
      tunable_parameters = paste(e$tunable_parameters, collapse = ", "),
      notes = e$notes %||% "",
      family = e$family %||% NA_character_,
      reference_estimator = e$reference_estimator %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

#' List currently registered custom spatial estimators
#'
#' @return A `data.frame`, one row per estimator registered with
#'   [register_spatial_estimator()] in the current R session (empty if none).
#' @export
registered_spatial_estimators <- function() {
  custom_estimator_registry_as_df()
}

fit_custom_spatial_estimator <- function(entry, formula, data, coords) {
  raw_fit <- entry$fit(formula = formula, data = data, coords = coords)
  structure(
    list(fit = raw_fit, predict_fn = entry$predict),
    class = "spatialtidymodels_custom_fit"
  )
}

#' @export
predict.spatialtidymodels_custom_fit <- function(object, new_data = NULL, newdata = NULL, ...) {
  # predict_vector_for_benchmark() (used during CV fold scoring) calls
  # predict(fit, new_data = ...), the tidymodels convention; diagnose_spatial()'s
  # internal predict_values_for_diagnostics() (used for in-sample diagnostics
  # AND, critically, for the per-fold RMSE/MAE/Moran diagnostics computed
  # inside CV scoring) calls predict(fit, newdata = ...), the base-R
  # convention. Accepting only one silently breaks the other: R propagates an
  # unmatched/missing argument through nested calls instead of erroring, so a
  # mismatched name here doesn't fail loudly -- it falls through to
  # predict.lm()'s no-newdata behaviour (in-sample fitted values), which is
  # invisible for in-sample diagnostics (train == test, so it happens to look
  # right) and silently wrong for every out-of-sample fold. Accept both names.
  nd <- new_data %||% newdata
  if (is.null(nd)) {
    stop("predict.spatialtidymodels_custom_fit() requires `new_data` (or `newdata`).", call. = FALSE)
  }
  as.numeric(object$predict_fn(object$fit, nd))
}
