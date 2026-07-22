# Moteur parsnip custom pour spmoran::esf() et spmoran::resf().
#
# Objectif: exposer ESF et RE-ESF comme de vrais model specs parsnip, au lieu
# de les garder comme chemins ad hoc du benchmark automatique.

require_package("parsnip", "custom spmoran_reg() parsnip engine")

#' parsnip specification for spmoran models
#'
#' Creates an experimental `parsnip` model specification for eigenvector
#' spatial filtering models fitted by `spmoran`.
#'
#' @param mode parsnip mode. Only `"regression"` is supported.
#' @param coords Character vector of length 2 giving the coordinate columns.
#' @param model_type `"ESF"` for `spmoran::esf()` or `"RESF"` for
#'   `spmoran::resf()`.
#' @param vif Variance inflation threshold passed to `spmoran::esf()`.
#' @param enum Optional number of Moran eigenvectors for `spmoran::meigen_f()`.
#'
#' @return A `parsnip` model specification.
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
  spmoran_reg(mode = mode, coords = coords, model_type = "ESF", vif = vif, enum = enum)
}

#' parsnip specification for RE-ESF
#'
#' Convenience constructor for `spmoran::resf()`.
#'
#' @inheritParams spmoran_reg
#' @return A `parsnip` model specification.
#' @export
spmoran_resf_reg <- function(mode = "regression", coords = NULL, enum = NULL) {
  spmoran_reg(mode = mode, coords = coords, model_type = "RESF", enum = enum)
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
  matrices <- spmoran_model_matrix(model_formula, data, require_response = TRUE)
  meig <- spmoran_build_meigen(coords_mat, enum = enum)
  model_type <- toupper(as.character(model_type))

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
    if (is.data.frame(pred) && "pred" %in% names(pred)) pred <- pred$pred
    return(as.numeric(pred))
  }

  coords <- check_spatial_coords(fit_obj$coords, data = new_data)
  matrices <- spmoran_model_matrix(fit_obj$formula, new_data, require_response = FALSE)
  meig0 <- spmoran::meigen0(
    meig = fit_obj$meig,
    coords0 = as.matrix(new_data[, coords, drop = FALSE])
  )
  pred <- spmoran::predict0(fit_obj$fit, meig0 = meig0, x0 = matrices$x)
  as.numeric(pred$pred$pred)
}
