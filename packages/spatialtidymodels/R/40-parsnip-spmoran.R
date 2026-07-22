# Moteur parsnip custom pour spmoran::esf() et spmoran::resf().
#
# Objectif: exposer ESF et RE-ESF comme de vrais model specs parsnip, au lieu
# de les garder comme chemins ad hoc du benchmark automatique.

require_package("parsnip", "custom spmoran_reg() parsnip engine")

#' parsnip specification for spmoran models
#'
#' Creates a `parsnip` model specification for eigenvector spatial filtering
#' models fitted by `spmoran`.
#'
#' @param mode parsnip mode. Only `"regression"` is supported.
#' @param coords Character vector of length 2 giving the coordinate columns.
#' @param model_type `"ESF"` for `spmoran::esf()` or `"RESF"` for
#'   `spmoran::resf()`.
#' @param vif Variance inflation threshold passed to `spmoran::esf()`.
#' @param enum Optional number of Moran eigenvectors for `spmoran::meigen_f()`.
#'   When `NULL`, the wrapper uses `spmoran::meigen()` on small datasets and
#'   `spmoran::meigen_f()` on larger datasets.
#'
#' @return A `parsnip` model specification.
#'
#' @details
#' ESF can fail on very small training folds when the spatial eigenvector basis
#' is too short for `spmoran::esf()`. Prefer resampling schemes with enough
#' training observations, or use the automatic benchmark route which records
#' failed folds instead of stopping the whole benchmark.
#' @export
spmoran_reg <- function(mode = "regression", coords = NULL, model_type = NULL,
                        vif = NULL, enum = NULL) {
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    vif = rlang::enquo(vif),
    enum = rlang::enquo(enum)
  )
  parsnip::new_model_spec(
    "spmoran_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' parsnip specification for ESF
#'
#' Convenience constructor for `spmoran::esf()`.
#'
#' @inheritParams spmoran_reg
#' @return A `parsnip` model specification.
#' @export
spmoran_esf_reg <- function(mode = "regression", coords = NULL, vif = 10,
                            enum = NULL) {
  parsnip::new_model_spec(
    "spmoran_reg",
    args = list(
      coords = rlang::enquo(coords),
      model_type = rlang::quo("ESF"),
      vif = rlang::enquo(vif),
      enum = rlang::enquo(enum)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' parsnip specification for RE-ESF
#'
#' Convenience constructor for `spmoran::resf()`.
#'
#' @inheritParams spmoran_reg
#' @return A `parsnip` model specification.
#' @export
spmoran_resf_reg <- function(mode = "regression", coords = NULL, enum = NULL) {
  parsnip::new_model_spec(
    "spmoran_reg",
    args = list(
      coords = rlang::enquo(coords),
      model_type = rlang::quo("RESF"),
      vif = rlang::quo(NULL),
      enum = rlang::enquo(enum)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @export
#' @method update spmoran_reg
update.spmoran_reg <- function(object, parameters = NULL, coords = NULL,
                               model_type = NULL, vif = NULL, enum = NULL,
                               fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    vif = rlang::enquo(vif),
    enum = rlang::enquo(enum)
  )
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "spmoran_reg", ...
  )
}

spmoran_model_matrix <- function(formula, data, require_response = TRUE) {
  # spmoran attend y et x separement. On retire l'intercept de x, car spmoran
  # gere sa constante dans le backend.
  response <- deparse(formula[[2]])
  terms_obj <- stats::terms(formula, data = data)
  x <- stats::model.matrix(stats::delete.response(terms_obj), data = data)
  if ("(Intercept)" %in% colnames(x)) {
    x <- x[, setdiff(colnames(x), "(Intercept)"), drop = FALSE]
  }
  y <- if (isTRUE(require_response)) data[[response]] else NULL
  list(y = y, x = x, response = response)
}

spmoran_build_meigen <- function(coords_mat, enum = NULL) {
  # Sur grands jeux de donnees, meigen_f() evite de calculer toute la base
  # spectrale. Sur petits jeux, meigen() garde le comportement exact.
  if (nrow(coords_mat) > 1000L || !is.null(enum)) {
    if (is.null(enum)) enum <- 200L
    spmoran::meigen_f(coords = coords_mat, enum = as.integer(enum))
  } else {
    spmoran::meigen(coords = coords_mat)
  }
}

check_spmoran_model_type <- function(model_type) {
  # Normalise le choix ESF/RESF pour eviter les erreurs tardives du backend.
  model_type <- toupper(as.character(model_type))
  if (length(model_type) != 1L || is.na(model_type) || !model_type %in% c("ESF", "RESF")) {
    stop("`model_type` must be 'ESF' or 'RESF'.", call. = FALSE)
  }
  model_type
}

check_spmoran_vif <- function(vif) {
  # spmoran::esf() attend un seuil VIF positif et scalaire.
  vif <- as.numeric(vif)
  if (length(vif) != 1L || is.na(vif) || !is.finite(vif) || vif <= 0) {
    stop("`vif` must be a positive finite number.", call. = FALSE)
  }
  vif
}

check_spmoran_enum <- function(enum, n = NULL) {
  # enum est optionnel; quand il est fourni, il controle meigen_f().
  if (is.null(enum)) return(NULL)
  enum <- as.integer(enum)
  if (length(enum) != 1L || is.na(enum) || enum < 1L) {
    stop("`enum` must be a positive integer or NULL.", call. = FALSE)
  }
  if (!is.null(n) && n > 1L) enum <- min(enum, n - 1L)
  enum
}

check_spmoran_numeric_matrix <- function(x, role) {
  # Les sorties model.matrix() doivent rester numeriques et finies pour spmoran.
  if (!is.numeric(x) || any(!is.finite(x))) {
    stop(sprintf("`%s` must be finite and numeric for spmoran.", role), call. = FALSE)
  }
  invisible(TRUE)
}

extract_spmoran_predictions <- function(pred) {
  # Les objets spmoran exposent des structures legerement differentes selon
  # esf(), resf() et predict0(). On centralise l'extraction du vecteur pred.
  if (is.data.frame(pred) && "pred" %in% names(pred)) return(as.numeric(pred$pred))
  if (is.list(pred) && !is.null(pred$pred)) return(extract_spmoran_predictions(pred$pred))
  as.numeric(pred)
}

#' Internal spmoran fit function for parsnip
#'
#' @keywords internal
#' @export
spmoran_fit_impl <- function(formula, data, coords, model_type = "ESF",
                             vif = 10, enum = NULL) {
  require_package("spmoran", "spmoran parsnip engine")
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  coords <- check_spatial_coords(coords, data = data)
  model_formula <- drop_formula_terms(formula, coords, data = data)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  check_spmoran_numeric_matrix(coords_mat, "coords")
  matrices <- spmoran_model_matrix(model_formula, data, require_response = TRUE)
  check_spmoran_numeric_matrix(matrices$x, "x")
  check_spmoran_numeric_matrix(matrices$y, "y")
  model_type <- check_spmoran_model_type(model_type)
  vif <- check_spmoran_vif(vif)
  enum <- check_spmoran_enum(enum, n = nrow(data))
  meig <- spmoran_build_meigen(coords_mat, enum = enum)

  fit <- switch(model_type,
    ESF = spmoran::esf(y = matrices$y, x = matrices$x, meig = meig, vif = vif),
    RESF = spmoran::resf(y = matrices$y, x = matrices$x, meig = meig),
    stop("`model_type` must be 'ESF' or 'RESF'.", call. = FALSE)
  )

  structure(
    list(
      fit = fit,
      meig = meig,
      formula = model_formula,
      coords = coords,
      train_data = data,
      model_type = model_type,
      response = matrices$response
    ),
    class = "spmoran_fit"
  )
}

#' Internal spmoran prediction function for parsnip
#'
#' @keywords internal
#' @export
spmoran_pred_impl <- function(object, new_data) {
  fit_obj <- parsnip::extract_fit_engine(object)
  new_data <- as.data.frame(new_data)
  if (identical(nrow(new_data), nrow(fit_obj$train_data)) &&
      identical(rownames(new_data), rownames(fit_obj$train_data))) {
    pred <- fit_obj$fit$pred
    return(extract_spmoran_predictions(pred))
  }

  coords <- check_spatial_coords(fit_obj$coords, data = new_data)
  coords_mat <- as.matrix(new_data[, coords, drop = FALSE])
  check_spmoran_numeric_matrix(coords_mat, "coords")
  matrices <- spmoran_model_matrix(fit_obj$formula, new_data, require_response = FALSE)
  check_spmoran_numeric_matrix(matrices$x, "x")
  meig0 <- spmoran::meigen0(
    meig = fit_obj$meig,
    coords0 = coords_mat
  )
  pred <- spmoran::predict0(fit_obj$fit, meig0 = meig0, x0 = matrices$x)
  extract_spmoran_predictions(pred)
}
