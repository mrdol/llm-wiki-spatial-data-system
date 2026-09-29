# Contrat de donnees et moteurs pour les panels spatiaux (SAR/SEM/SDM de
# panel). Branche distincte du harnais transversal (sar_lag/sem_error/
# sdm_mixed) : une observation de panel est un couple unite-temps, alors que
# sa matrice de poids W est definie au niveau des unites, pas des lignes.
# Voir wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md pour le
# plan complet (J0-J7) ; ce fichier couvre J1 (spatial_panel_spec, alignement
# W) et le debut de J2 (panel_fe, panel_sar_fe).

#' Declare the unit/time/W contract for a spatial panel dataset
#'
#' @param unit Column name identifying the cross-sectional unit (e.g. a
#'   province or state).
#' @param time Column name identifying the time period.
#' @param effect Panel effect: individual, time, or twoways.
#' @param balance Declared balance of the panel. Checked against the actual
#'   data by [validate_spatial_panel_data()] rather than trusted blindly.
#' @param w_unit_order Optional character/numeric vector giving the unit
#'   identifiers in the row/column order of `W`, required when `W` has no
#'   dimnames.
#' @param prediction_target Capability this panel is expected to support.
#'   `"fit_only"` (the only target implemented so far) means replication and
#'   in-sample coefficients, not out-of-sample prediction.
#'
#' @return A `spatial_panel_spec` object.
#' @export
spatial_panel_spec <- function(unit, time,
                                effect = c("individual", "time", "twoways"),
                                balance = c("balanced", "unbalanced"),
                                w_unit_order = NULL,
                                prediction_target = c(
                                  "fit_only", "in_sample",
                                  "time_forecast_known_units", "new_units"
                                )) {
  stopifnot(is.character(unit), length(unit) == 1L, nzchar(unit))
  stopifnot(is.character(time), length(time) == 1L, nzchar(time))
  effect <- match.arg(effect)
  balance <- match.arg(balance)
  prediction_target <- match.arg(prediction_target)
  if (!is.null(w_unit_order)) {
    stopifnot(is.character(w_unit_order) || is.numeric(w_unit_order))
  }
  structure(
    list(
      unit = unit, time = time, effect = effect, balance = balance,
      w_unit_order = w_unit_order, prediction_target = prediction_target
    ),
    class = "spatial_panel_spec"
  )
}

#' @export
print.spatial_panel_spec <- function(x, ...) {
  cat(sprintf(
    "<spatial_panel_spec> unit=%s time=%s effect=%s balance=%s prediction_target=%s\n",
    x$unit, x$time, x$effect, x$balance, x$prediction_target
  ))
  invisible(x)
}

panel_key_pairs <- function(data, panel) {
  if (!panel$unit %in% names(data)) {
    stop(sprintf("Colonne unit '%s' absente des donnees du panel.", panel$unit), call. = FALSE)
  }
  if (!panel$time %in% names(data)) {
    stop(sprintf("Colonne time '%s' absente des donnees du panel.", panel$time), call. = FALSE)
  }
  units <- data[[panel$unit]]
  times <- data[[panel$time]]
  if (anyNA(units) || anyNA(times)) {
    stop("Identifiants unit/time du panel contiennent des NA : l'alignement W ne peut pas etre garanti.", call. = FALSE)
  }
  list(units = units, times = times)
}

#' Validate a panel dataset against its declared spatial_panel_spec
#'
#' Checks unit-time uniqueness, actual vs. declared balance, and (when `W` is
#' supplied) that `W`'s dimension and unit identifiers match the data exactly.
#' Never builds `W` from coordinates -- panel neighbours are unit-level and
#' must be supplied explicitly, unlike the cross-sectional harness's
#' point-based kNN construction (repeated point geometries across time periods
#' are unit repetitions, not new neighbours).
#'
#' @param data A data frame with one row per unit-time observation.
#' @param panel A `spatial_panel_spec`.
#' @param W Optional spatial weights matrix defined over units (not rows).
#'
#' @return An invisible list describing the validated panel structure:
#'   `units` (canonical sorted unit ids), `n_units`, `periods` (canonical
#'   sorted periods), `n_periods`, `balanced`, `missing_unit_periods` (a data
#'   frame of unit-period gaps, zero rows when balanced), and `W` (the
#'   input `W` reordered to the canonical unit order, or `NULL`).
#' @export
validate_spatial_panel_data <- function(data, panel, W = NULL) {
  if (!inherits(panel, "spatial_panel_spec")) {
    stop("panel doit etre construit avec spatial_panel_spec().", call. = FALSE)
  }
  keys <- panel_key_pairs(data, panel)
  units_chr <- as.character(keys$units)
  times_chr <- as.character(keys$times)

  # Separateur explicite entre unite et temps : une simple concatenation sans
  # separateur confondrait unit="1"/time="23" avec unit="12"/time="3".
  key_sep <- ":::"
  pair_key <- paste(units_chr, times_chr, sep = key_sep)
  dup <- duplicated(pair_key)
  if (any(dup)) {
    dup_examples <- unique(pair_key[dup])
    stop(sprintf(
      "Couples unite-temps dupliques dans le panel (%d couple(s)), ex: %s.",
      length(dup_examples),
      paste(gsub(key_sep, "/", utils::head(dup_examples, 5), fixed = TRUE), collapse = ", ")
    ), call. = FALSE)
  }

  units <- sort(unique(units_chr))
  # Trie sur les valeurs d'origine (pas sur leur forme caractere) quand elles
  # sont naturellement ordonnables : un tri de chaines confondrait "9" et
  # "10" (ordre lexicographique) pour des periodes non zero-paddees. Le
  # holdout/rolling-origin temporel (J4) depend directement de cet ordre.
  periods_orig <- unique(keys$times)
  periods_orig_ord <- if (is.numeric(periods_orig) || inherits(periods_orig, "Date")) {
    sort(periods_orig)
  } else {
    periods_orig[order(as.character(periods_orig))]
  }
  periods <- as.character(periods_orig_ord)
  n_units <- length(units)
  n_periods <- length(periods)

  full_grid <- expand.grid(unit = units, time = periods, stringsAsFactors = FALSE)
  full_key <- paste(full_grid$unit, full_grid$time, sep = key_sep)
  observed_key <- pair_key
  missing_mask <- !full_key %in% observed_key
  missing_unit_periods <- full_grid[missing_mask, , drop = FALSE]
  row.names(missing_unit_periods) <- NULL

  balanced <- nrow(missing_unit_periods) == 0L
  if (panel$balance == "balanced" && !balanced) {
    stop(sprintf(
      "Panel declare 'balanced' mais %d couple(s) unite-temps manquant(s) sur %d attendus (%d unites x %d periodes). Ex: %s/%s.",
      nrow(missing_unit_periods), nrow(full_grid), n_units, n_periods,
      missing_unit_periods$unit[[1]], missing_unit_periods$time[[1]]
    ), call. = FALSE)
  }
  if (panel$balance == "unbalanced" && balanced) {
    stop("Panel declare 'unbalanced' mais toutes les combinaisons unite-temps sont presentes ; corrigez balance='balanced' dans spatial_panel_spec().", call. = FALSE)
  }

  W_aligned <- if (!is.null(W)) align_panel_W(units, W, panel$w_unit_order) else NULL

  invisible(list(
    units = units,
    n_units = n_units,
    periods = periods,
    n_periods = n_periods,
    balanced = balanced,
    missing_unit_periods = missing_unit_periods,
    W = W_aligned
  ))
}

#' Align a spatial weights matrix to the canonical (sorted) unit order
#'
#' Guarantees that the fit is invariant to the row order of `data` and to the
#' row/column order of `W`: both are always reordered to `sort(unique(units))`
#' before being handed to a panel engine.
#'
#' @param units Unit identifiers actually present in the panel data (any
#'   order, duplicates allowed -- only the unique set matters).
#' @param W A square matrix (or an object coercible to one) of spatial
#'   weights defined over units.
#' @param w_unit_order Optional vector giving the unit identifiers in `W`'s
#'   row/column order, required when `W` has no dimnames.
#'
#' @return `W` as a matrix, reordered to `sort(unique(units))`.
#' @export
align_panel_W <- function(units, W, w_unit_order = NULL) {
  if (inherits(W, "listw")) {
    stop("align_panel_W attend une matrice W, pas un objet listw ; convertissez-la avant l'alignement (ex: as(W, \"CsparseMatrix\")).", call. = FALSE)
  }
  canonical <- sort(unique(as.character(units)))
  n <- length(canonical)

  W_mat <- as.matrix(W)
  if (!is.matrix(W_mat) || nrow(W_mat) != ncol(W_mat)) {
    stop(sprintf("W doit etre une matrice carree ; dimensions recues: %s.", paste(dim(W_mat), collapse = " x ")), call. = FALSE)
  }
  if (nrow(W_mat) != n) {
    stop(sprintf(
      "Dimension de W (%d x %d) incoherente avec le nombre d'unites du panel (%d).",
      nrow(W_mat), ncol(W_mat), n
    ), call. = FALSE)
  }

  w_names <- rownames(W_mat)
  if (is.null(w_names)) {
    if (is.null(w_unit_order)) {
      stop("W sans noms de lignes/colonnes : fournissez w_unit_order dans spatial_panel_spec() pour identifier chaque ligne de W a une unite.", call. = FALSE)
    }
    w_unit_order_chr <- as.character(w_unit_order)
    if (length(w_unit_order_chr) != n || !setequal(w_unit_order_chr, canonical)) {
      stop("w_unit_order ne correspond pas exactement a l'ensemble des unites presentes dans les donnees.", call. = FALSE)
    }
    dimnames(W_mat) <- list(w_unit_order_chr, w_unit_order_chr)
  } else {
    col_names <- colnames(W_mat)
    if (is.null(col_names) || !setequal(col_names, canonical) || !setequal(w_names, canonical)) {
      stop("Les noms de lignes/colonnes de W ne correspondent pas exactement aux unites presentes dans les donnees.", call. = FALSE)
    }
  }

  W_mat[canonical, canonical, drop = FALSE]
}

build_panel_pdata <- function(data, panel) {
  plm::pdata.frame(data, index = c(panel$unit, panel$time))
}

#' Row-standardize a unit-level spatial weights matrix
#'
#' Every panel spatial engine in this module calls `spdep::mat2listw(W,
#' style = "W")` to fit (row-standardized weights), so `W` as stored in
#' `spatial_panel_fit$extra` and as used by [build_panel_wx()] and
#' [panel_sar_sdm_impacts()] must be row-standardized too -- otherwise the
#' impacts decomposition and WX construction would silently use a different W
#' convention than the one the model was actually estimated with. This only
#' matters when the caller's `W` is not already row-standardized (e.g. a raw
#' 0/1 contiguity matrix); a pre-standardized `W` is unaffected (row sums
#' already equal to 1).
#'
#' @param W A square, aligned spatial weights matrix.
#' @return `W` with each row divided by its row sum.
#' @export
row_standardize_W <- function(W) {
  row_sums <- rowSums(W)
  if (any(row_sums == 0)) {
    stop(
      "W contient une ou plusieurs unites sans voisin (somme de ligne nulle) : la standardisation par ligne est indefinie pour ces unites.",
      call. = FALSE
    )
  }
  W / row_sums
}

new_spatial_panel_fit <- function(engine, model_type, fit, panel, validated, formula, effect, extra = list()) {
  structure(
    list(
      engine = engine,
      model_type = model_type,
      fit = fit,
      panel = panel,
      formula = formula,
      effect = effect,
      n_units = validated$n_units,
      n_periods = validated$n_periods,
      n_obs = tryCatch(stats::nobs(fit), error = function(e) NA_integer_),
      balanced = validated$balanced,
      units = validated$units,
      periods = validated$periods,
      extra = extra
    ),
    class = "spatial_panel_fit"
  )
}

#' @export
print.spatial_panel_fit <- function(x, ...) {
  cat(sprintf(
    "<spatial_panel_fit> engine=%s model_type=%s N=%s (%d units x %d periods, balanced=%s)\n",
    x$engine, x$model_type, format(x$n_obs), x$n_units, x$n_periods, x$balanced
  ))
  invisible(x)
}

#' Fit a non-spatial panel fixed/random-effects model (reference route)
#'
#' Thin wrapper around `plm::plm()` used as the non-spatial baseline for panel
#' routes -- distinct from, and not a substitute for, the cross-sectional
#' `ols` estimator.
#'
#' @param formula A model formula, e.g. `log(gsp) ~ log(pcap) + log(pc)`.
#' @param data A data frame with one row per unit-time observation.
#' @param panel A `spatial_panel_spec` (see [spatial_panel_spec()]).
#' @param model_type One of `"within"` (fixed effects) or `"random"`.
#'
#' @return A `spatial_panel_fit` wrapping the `plm` object.
#' @export
panel_fe_fit <- function(formula, data, panel, model_type = c("within", "random")) {
  require_package("plm", "panel_fe_fit")
  model_type <- match.arg(model_type)
  validated <- validate_spatial_panel_data(data, panel)
  pdata <- build_panel_pdata(data, panel)
  fit <- plm::plm(formula, data = pdata, model = model_type, effect = panel$effect)
  new_spatial_panel_fit("panel_fe", model_type, fit, panel, validated, formula, panel$effect)
}

#' @keywords internal
NULL

# Note de nommage (piege confirme empiriquement) : le vecteur de coefficients
# retourne par splm::spml() nomme le parametre AUTOREGRESSIF SPATIAL (lag)
# "lambda" et le parametre d'ERREUR spatiale "rho" -- l'inverse de la
# convention LeSage-Pace/spdep habituelle (rho=lag, lambda=erreur), mais
# conforme a la notation historique de Baltagi que splm implemente. Pour
# eviter de propager cette ambiguite, l'API de ce module n'utilise ni "rho" ni
# "lambda" : `lag_coefficient` et `error_coefficient` dans `extra`, quel que
# soit le nom interne utilise par le backend.
extract_splm_lag_coefficient <- function(fit) {
  tryCatch(unname(fit$coefficients[["lambda"]]), error = function(e) NA_real_)
}
extract_splm_error_coefficient <- function(fit) {
  tryCatch(unname(fit$coefficients[["rho"]]), error = function(e) NA_real_)
}

#' Fit a spatial-lag (SAR) fixed/random-effects panel model
#'
#' Thin wrapper around `splm::spml(..., lag = TRUE, spatial.error = "none")`.
#' Distinct from the cross-sectional `sar_lag` estimator: the spatial
#' dependence, effects structure, and standard errors are all panel-specific
#' (Elhorst 2003; Millo & Piras 2012, JSS 47).
#'
#' @inheritParams panel_fe_fit
#' @param W A spatial weights matrix defined over units (see
#'   [align_panel_W()]) -- not a `listw` object; converted internally with
#'   `spdep::mat2listw()`.
#'
#' @return A `spatial_panel_fit` wrapping the `splm` object, with
#'   `lag_coefficient` in `extra`.
#' @export
panel_sar_fe_fit <- function(formula, data, panel, W, model_type = c("within", "random")) {
  require_package("splm", "panel_sar_fe_fit")
  require_package("plm", "panel_sar_fe_fit")
  require_package("spdep", "panel_sar_fe_fit")
  model_type <- match.arg(model_type)
  validated <- validate_spatial_panel_data(data, panel, W = W)
  W_std <- row_standardize_W(validated$W)
  pdata <- build_panel_pdata(data, panel)
  listw <- spdep::mat2listw(W_std, style = "W")
  fit <- splm::spml(
    formula, data = pdata, listw = listw,
    model = model_type, effect = panel$effect,
    lag = TRUE, spatial.error = "none"
  )
  new_spatial_panel_fit(
    "panel_sar_fe", model_type, fit, panel, validated, formula, panel$effect,
    extra = list(lag_coefficient = extract_splm_lag_coefficient(fit), error_coefficient = NA_real_, W = W_std)
  )
}

#' Fit a spatial-error (SEM) fixed/random-effects panel model
#'
#' Thin wrapper around `splm::spml(..., lag = FALSE, spatial.error = "b")`
#' (Baltagi-Song-Koh spatial error correction). Distinct from the
#' cross-sectional `sem_error` estimator.
#'
#' @inheritParams panel_sar_fe_fit
#' @return A `spatial_panel_fit` with `error_coefficient` in `extra`.
#' @export
panel_sem_fe_fit <- function(formula, data, panel, W, model_type = c("within", "random")) {
  require_package("splm", "panel_sem_fe_fit")
  require_package("plm", "panel_sem_fe_fit")
  require_package("spdep", "panel_sem_fe_fit")
  model_type <- match.arg(model_type)
  validated <- validate_spatial_panel_data(data, panel, W = W)
  W_std <- row_standardize_W(validated$W)
  pdata <- build_panel_pdata(data, panel)
  listw <- spdep::mat2listw(W_std, style = "W")
  fit <- splm::spml(
    formula, data = pdata, listw = listw,
    model = model_type, effect = panel$effect,
    lag = FALSE, spatial.error = "b"
  )
  new_spatial_panel_fit(
    "panel_sem_fe", model_type, fit, panel, validated, formula, panel$effect,
    extra = list(lag_coefficient = NA_real_, error_coefficient = extract_splm_error_coefficient(fit), W = W_std)
  )
}

#' Fit a SAC (spatial lag + spatial error, "sarar") fixed/random-effects panel model
#'
#' Thin wrapper around `splm::spml(..., lag = TRUE, spatial.error = "b")`.
#' Combines the dependence structures of [panel_sar_fe_fit()] and
#' [panel_sem_fe_fit()] in a single model; distinct from either alone.
#'
#' @inheritParams panel_sar_fe_fit
#' @return A `spatial_panel_fit` with both `lag_coefficient` and
#'   `error_coefficient` in `extra`.
#' @export
panel_sac_fe_fit <- function(formula, data, panel, W, model_type = c("within", "random")) {
  require_package("splm", "panel_sac_fe_fit")
  require_package("plm", "panel_sac_fe_fit")
  require_package("spdep", "panel_sac_fe_fit")
  model_type <- match.arg(model_type)
  validated <- validate_spatial_panel_data(data, panel, W = W)
  W_std <- row_standardize_W(validated$W)
  pdata <- build_panel_pdata(data, panel)
  listw <- spdep::mat2listw(W_std, style = "W")
  fit <- splm::spml(
    formula, data = pdata, listw = listw,
    model = model_type, effect = panel$effect,
    lag = TRUE, spatial.error = "b"
  )
  new_spatial_panel_fit(
    "panel_sac_fe", model_type, fit, panel, validated, formula, panel$effect,
    extra = list(
      lag_coefficient = extract_splm_lag_coefficient(fit),
      error_coefficient = extract_splm_error_coefficient(fit),
      W = W_std
    )
  )
}

#' Build spatially-lagged covariates (WX) for a panel Spatial Durbin Model
#'
#' `splm` does not offer a native Durbin ("no option is inferred from its
#' name" per the implementation plan) -- WX is built explicitly here, one
#' time period at a time, and verified independently in
#' `tests/testthat/test-panel-spatial.R` against a hand-written per-period
#' loop using a different code path.
#'
#' @param data A data frame with one row per unit-time observation.
#' @param panel A `spatial_panel_spec`.
#' @param W A spatial weights matrix defined over units.
#' @param x_formula A one-sided formula naming the covariates to lag (the
#'   fixed-effect model's RHS; the intercept, if any, is dropped).
#'
#' @return A data frame with one `W_<term>` column per RHS term of
#'   `x_formula`, aligned row-for-row with `data`. Requires a balanced panel
#'   (one row per unit for every period).
#' @export
build_panel_wx <- function(data, panel, W, x_formula) {
  validated <- validate_spatial_panel_data(data, panel, W = W)
  if (!validated$balanced) {
    stop("build_panel_wx requiert un panel equilibre (une ligne par unite et par periode) pour construire WX periode par periode.", call. = FALSE)
  }
  # Row-standardise comme pour l'ajustement (spdep::mat2listw(..., style="W"))
  # : WX doit utiliser la meme convention de W que le terme de lag, sinon les
  # deux parties du modele Durbin ne sont plus coherentes entre elles.
  Wc <- row_standardize_W(validated$W)
  units_order <- rownames(Wc)

  mm <- stats::model.matrix(x_formula, data = data)
  intercept_col <- which(colnames(mm) == "(Intercept)")
  if (length(intercept_col) > 0L) mm <- mm[, -intercept_col, drop = FALSE]

  units_chr <- as.character(data[[panel$unit]])
  times_chr <- as.character(data[[panel$time]])
  # Noms syntaxiquement valides des l'origine (pas de "W_log(pcap)") : evite
  # tout re-mangling silencieux par cbind()/data.frame() plus loin, qui
  # desynchroniserait le nom de colonne effectif du nom utilise dans la
  # formule augmentee.
  base_terms <- colnames(mm)
  wx_names <- make.names(paste0("W_", base_terms), unique = TRUE)
  wmm <- matrix(NA_real_, nrow(mm), ncol(mm), dimnames = list(NULL, wx_names))

  for (tt in unique(times_chr)) {
    idx <- which(times_chr == tt)
    ord <- match(units_order, units_chr[idx])
    if (anyNA(ord) || length(ord) != length(units_order)) {
      stop(sprintf("Periode '%s' n'a pas exactement une observation par unite : WX ne peut pas etre construit.", tt), call. = FALSE)
    }
    idx_ord <- idx[ord]
    wmm[idx_ord, ] <- Wc %*% mm[idx_ord, , drop = FALSE]
  }
  out <- as.data.frame(wmm)
  attr(out, "base_terms") <- base_terms
  out
}

#' Fit a panel Spatial Durbin Model (SDM): spatial lag plus WX covariates
#'
#' Augments `formula` with spatially-lagged covariates (see
#' [build_panel_wx()]) and fits the result with
#' `splm::spml(..., lag = TRUE, spatial.error = "none")`. This is a lag model
#' on an augmented regressor set, not a native "Durbin" backend option.
#'
#' @inheritParams panel_sar_fe_fit
#' @return A `spatial_panel_fit` with `lag_coefficient` and the WX term names
#'   (`wx_terms`) in `extra`.
#' @export
panel_sdm_fe_fit <- function(formula, data, panel, W, model_type = c("within", "random")) {
  require_package("splm", "panel_sdm_fe_fit")
  require_package("plm", "panel_sdm_fe_fit")
  require_package("spdep", "panel_sdm_fe_fit")
  model_type <- match.arg(model_type)
  validated <- validate_spatial_panel_data(data, panel, W = W)
  W_std <- row_standardize_W(validated$W)

  rhs_terms <- attr(stats::terms(formula), "term.labels")
  x_formula <- stats::reformulate(rhs_terms)
  # W deja standardise par ligne transmis directement : build_panel_wx()
  # re-standardiserait sinon un W deja standardise, ce qui est un no-op ici
  # mais garde une seule source de verite pour la convention utilisee.
  wx <- build_panel_wx(data, panel, W_std, x_formula)
  # names(wx) sont deja des identifiants R valides (make.names() applique dans
  # build_panel_wx()) : pas de mangling silencieux possible via cbind()/
  # data.frame(), et pas besoin de backticks dans la formule augmentee.
  augmented_data <- cbind(data, wx, deparse.level = 0)
  wx_term_map <- stats::setNames(names(wx), attr(wx, "base_terms"))
  augmented_formula <- stats::update(formula, paste(". ~ . +", paste(names(wx), collapse = " + ")))

  pdata <- build_panel_pdata(augmented_data, panel)
  listw <- spdep::mat2listw(W_std, style = "W")
  fit <- splm::spml(
    augmented_formula, data = pdata, listw = listw,
    model = model_type, effect = panel$effect,
    lag = TRUE, spatial.error = "none"
  )
  new_spatial_panel_fit(
    "panel_sdm_fe", model_type, fit, panel, validated, augmented_formula, panel$effect,
    extra = list(
      lag_coefficient = extract_splm_lag_coefficient(fit),
      error_coefficient = NA_real_,
      W = W_std,
      wx_terms = names(wx),
      wx_term_map = wx_term_map,
      base_terms = rhs_terms
    )
  )
}

#' LeSage-Pace direct/indirect/total impacts for a panel SAR or SDM fit
#'
#' Closed-form decomposition (LeSage & Pace 2009, ch. 2) computed directly
#' from `(I - rho * W)^-1`, rather than via `spatialreg::impacts()` /
#' `splm:::impacts.splm_ML()`: the latter currently errors on this
#' installation (`have_factor_preds` attribute mismatch between the installed
#' `splm` and `spatialreg` versions, confirmed empirically -- not something
#' this package can fix by calling it differently). Verified independently in
#' `tests/testthat/test-panel-spatial.R` on a small deterministic example.
#'
#' @param fit A `spatial_panel_fit` with `engine %in% c("panel_sar_fe", "panel_sdm_fe")`.
#'
#' @return A data frame with one row per base covariate: `term`, `direct`,
#'   `indirect`, `total`.
#' @export
panel_sar_sdm_impacts <- function(fit) {
  if (!inherits(fit, "spatial_panel_fit") || !fit$engine %in% c("panel_sar_fe", "panel_sdm_fe")) {
    stop("panel_sar_sdm_impacts() attend un spatial_panel_fit issu de panel_sar_fe_fit() ou panel_sdm_fe_fit().", call. = FALSE)
  }
  rho <- fit$extra$lag_coefficient
  W <- fit$extra$W
  n <- nrow(W)
  S_inv <- solve(diag(n) - rho * W)

  coefs <- fit$fit$coefficients
  coef_names <- names(coefs)
  wx_names <- if (fit$engine == "panel_sdm_fe") fit$extra$wx_terms else character(0)
  wx_term_map <- if (fit$engine == "panel_sdm_fe") fit$extra$wx_term_map else NULL
  base_names <- setdiff(coef_names, c("lambda", "rho", wx_names))

  rows <- lapply(base_names, function(term) {
    beta <- unname(coefs[[term]])
    wx_term <- if (!is.null(wx_term_map) && term %in% names(wx_term_map)) wx_term_map[[term]] else NA_character_
    theta <- if (!is.na(wx_term) && wx_term %in% coef_names) unname(coefs[[wx_term]]) else 0
    Sk <- S_inv %*% (beta * diag(n) + theta * W)
    direct <- mean(diag(Sk))
    total <- sum(Sk) / n
    data.frame(term = term, direct = direct, indirect = total - direct, total = total, stringsAsFactors = FALSE)
  })
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}

# --- Prediction (J4): fit_only was the only target through J3. Adds
# time_forecast_known_units for effect="individual" fits, verified against
# each fit's own estimation residuals before being trusted for genuinely
# out-of-sample periods (see tests/testthat/test-panel-spatial.R). effect
# %in% c("time","twoways") is refused explicitly: a future period's time
# effect is undefined, exactly as flagged in the implementation plan.

#' Extract level-scale unit fixed effects from a fitted spatial_panel_fit
#'
#' @param fit A `spatial_panel_fit`.
#' @return A named numeric vector (unit id -> fixed effect), in `fit$units`
#'   order, or `NULL` for `panel_fe` (handled directly by `plm::predict.plm()`
#'   instead, which already applies each unit's own effect from a properly
#'   indexed `pdata.frame`).
#' @keywords internal
extract_panel_fixed_effects <- function(fit) {
  if (fit$engine == "panel_fe") return(NULL)
  res_eff <- fit$fit$res.eff
  if (is.null(res_eff) || is.null(res_eff[[1]]$res.sfe)) {
    stop(sprintf(
      "Effets fixes non disponibles sur l'objet ajuste par '%s' ; prediction hors echantillon impossible.",
      fit$engine
    ), call. = FALSE)
  }
  alpha <- as.numeric(res_eff[[1]]$res.sfe) + as.numeric(res_eff[[1]]$intercept)
  stats::setNames(alpha, fit$units)
}

panel_fixed_effect_prediction_x <- function(fit, newdata, base_terms) {
  x_formula <- stats::reformulate(base_terms)
  mm <- stats::model.matrix(x_formula, data = newdata)
  intercept_col <- which(colnames(mm) == "(Intercept)")
  if (length(intercept_col) > 0L) mm <- mm[, -intercept_col, drop = FALSE]
  beta <- fit$fit$coefficients[colnames(mm)]
  if (anyNA(beta)) {
    stop("Coefficient(s) introuvable(s) dans le modele ajuste pour les termes de newdata ; verifiez que la formule utilisee correspond au modele.", call. = FALSE)
  }
  as.numeric(mm %*% beta)
}

check_known_units <- function(fit, newdata) {
  new_units <- as.character(newdata[[fit$panel$unit]])
  unknown <- setdiff(unique(new_units), fit$units)
  if (length(unknown) > 0L) {
    stop(sprintf(
      "Unite(s) absente(s) du panel d'entrainement : %s. La prediction pour de nouvelles unites n'est pas prise en charge pour un modele a effets fixes individuels (l'effet de cette unite n'a jamais ete estime).",
      paste(unknown, collapse = ", ")
    ), call. = FALSE)
  }
  new_units
}

predict_panel_fe <- function(fit, newdata) {
  check_known_units(fit, newdata)
  pdata_new <- plm::pdata.frame(newdata, index = c(fit$panel$unit, fit$panel$time))
  as.numeric(stats::predict(fit$fit, newdata = pdata_new))
}

predict_panel_sem <- function(fit, newdata) {
  new_units <- check_known_units(fit, newdata)
  alpha <- extract_panel_fixed_effects(fit)
  base_terms <- attr(stats::terms(fit$formula), "term.labels")
  Xb <- panel_fixed_effect_prediction_x(fit, newdata, base_terms)
  Xb + unname(alpha[new_units])
}

predict_panel_sar_like <- function(fit, newdata, use_wx) {
  panel <- fit$panel
  new_units <- check_known_units(fit, newdata)
  W <- fit$extra$W
  units_order <- fit$units
  n <- length(units_order)
  rho <- fit$extra$lag_coefficient
  alpha <- extract_panel_fixed_effects(fit)[units_order]

  base_terms <- if (use_wx) fit$extra$base_terms else attr(stats::terms(fit$formula), "term.labels")
  x_formula <- stats::reformulate(base_terms)
  Xb <- panel_fixed_effect_prediction_x(fit, newdata, base_terms)
  if (use_wx) {
    wx <- build_panel_wx(newdata, panel, W, x_formula)
    theta <- fit$fit$coefficients[fit$extra$wx_terms]
    Xb <- Xb + as.numeric(as.matrix(wx) %*% theta)
  }

  times_chr <- as.character(newdata[[panel$time]])
  S_inv <- solve(diag(n) - rho * W)
  yhat <- rep(NA_real_, nrow(newdata))
  for (tt in unique(times_chr)) {
    idx <- which(times_chr == tt)
    idx_units <- new_units[idx]
    if (!setequal(idx_units, units_order) || length(idx) != n) {
      stop(sprintf(
        "La periode '%s' ne contient pas exactement les %d unites du panel d'entrainement : la prediction SAR/SDM exige la coupe complete par periode (la dependance spatiale relie toutes les unites simultanement, contrairement a SEM).",
        tt, n
      ), call. = FALSE)
    }
    ord <- match(units_order, idx_units)
    idx_ord <- idx[ord]
    yhat[idx_ord] <- S_inv %*% (Xb[idx_ord] + alpha)
  }
  yhat
}

#' Predict from a fitted spatial panel model (known units only)
#'
#' Implements the `time_forecast_known_units` capability declared in
#' [spatial_panel_spec()]: predicting periods for units that were present at
#' estimation time. Never predicts for a genuinely new unit (its fixed effect
#' was never estimated) or for `effect %in% c("time", "twoways")` (a future
#' period's time effect is undefined) -- both fail with an explicit error
#' rather than silently falling back to an average effect.
#'
#' @param fit A `spatial_panel_fit` (see [panel_fe_fit()], [panel_sar_fe_fit()],
#'   [panel_sem_fe_fit()], [panel_sac_fe_fit()], [panel_sdm_fe_fit()]).
#' @param newdata A data frame with the same unit/time/covariate columns used
#'   to fit `fit`. For `panel_sar_fe`/`panel_sac_fe`/`panel_sdm_fe`, each
#'   period present in `newdata` must contain every unit seen at training
#'   time (the spatial lag links units within a period simultaneously).
#'
#' @return A numeric vector of predictions, one per row of `newdata`.
#' @export
predict_panel_fit <- function(fit, newdata) {
  if (!inherits(fit, "spatial_panel_fit")) {
    stop("predict_panel_fit() attend un spatial_panel_fit.", call. = FALSE)
  }
  if (fit$panel$effect != "individual") {
    stop(
      "Prediction hors echantillon non prise en charge pour effect != 'individual' : l'effet temporel d'une periode future est indefini (voir le plan d'implementation, section 'Contrat de prediction').",
      call. = FALSE
    )
  }
  switch(fit$engine,
    panel_fe = predict_panel_fe(fit, newdata),
    panel_sem_fe = predict_panel_sem(fit, newdata),
    panel_sar_fe = predict_panel_sar_like(fit, newdata, use_wx = FALSE),
    panel_sac_fe = predict_panel_sar_like(fit, newdata, use_wx = FALSE),
    panel_sdm_fe = predict_panel_sar_like(fit, newdata, use_wx = TRUE),
    stop(sprintf("Prediction non prise en charge pour l'engine '%s'.", fit$engine), call. = FALSE)
  )
}

# --- Time-aware resampling (J4) ---
#
# near_prediction/block_spatial/vfold_cv (harnais transversal) ne s'appliquent
# jamais ici : un pli panel est toujours coupe par periode, jamais par ligne
# individuelle. Anti-fuite garanti par construction (les periodes de train
# sont toujours strictement anterieures aux periodes de test), verifie
# explicitement via assert_no_temporal_leakage() plutot que suppose.

assert_no_temporal_leakage <- function(train_periods, test_periods, periods) {
  # Comparaison par POSITION dans le vecteur `periods` deja correctement
  # ordonne (pas par comparaison directe des libelles) : une comparaison de
  # chaines confondrait "9" et "10" exactement comme le tri lui-meme (voir
  # validate_spatial_panel_data()).
  train_pos <- match(train_periods, periods)
  test_pos <- match(test_periods, periods)
  if (max(train_pos) >= min(test_pos)) {
    stop(sprintf(
      "Fuite temporelle detectee : la derniere periode d'entrainement (%s) n'est pas strictement anterieure a la premiere periode de test (%s).",
      periods[[max(train_pos)]], periods[[min(test_pos)]]
    ), call. = FALSE)
  }
  invisible(TRUE)
}

panel_ordered_periods <- function(data, panel) {
  validate_spatial_panel_data(data, panel)$periods
}

#' Reserve the last `h` periods of a panel as a test set
#'
#' A single global cutoff on the chronologically ordered, unique period
#' values (see [validate_spatial_panel_data()] for how non-zero-padded
#' numeric periods are ordered correctly) -- every unit's last `h` periods
#' become the test set, everything before is train.
#'
#' @param data A data frame with one row per unit-time observation.
#' @param panel A `spatial_panel_spec`.
#' @param h Number of trailing periods to reserve for testing (`1 <= h < `
#'   total periods).
#'
#' @return A list with `train`, `test` (data frames), `train_periods`,
#'   `test_periods` (character vectors, chronologically ordered).
#' @export
panel_time_holdout <- function(data, panel, h) {
  periods <- panel_ordered_periods(data, panel)
  n_periods <- length(periods)
  if (!is.numeric(h) || length(h) != 1L || h < 1L || h >= n_periods) {
    stop(sprintf("h doit etre un entier entre 1 et %d (nombre de periodes - 1) ; recu %s.", n_periods - 1L, format(h)), call. = FALSE)
  }
  h <- as.integer(h)
  train_periods <- utils::head(periods, n_periods - h)
  test_periods <- utils::tail(periods, h)
  assert_no_temporal_leakage(train_periods, test_periods, periods)

  times_chr <- as.character(data[[panel$time]])
  structure(
    list(
      train = data[times_chr %in% train_periods, , drop = FALSE],
      test = data[times_chr %in% test_periods, , drop = FALSE],
      train_periods = train_periods,
      test_periods = test_periods
    ),
    class = "panel_time_split"
  )
}

#' Build growing-window rolling-origin folds over a panel's periods
#'
#' Each fold's training window grows from the first `initial` periods;
#' `assess` subsequent periods are held out for testing, and the origin
#' advances by `assess + skip` periods between folds. Mirrors
#' `rsample::rolling_origin()`'s semantics, but cut on the panel's ordered
#' unique periods rather than on rows (a panel row is a unit-time pair, not
#' an independent observation).
#'
#' @inheritParams panel_time_holdout
#' @param initial Number of periods in the first training window.
#' @param assess Number of periods held out for testing in each fold.
#' @param skip Number of periods to skip between the end of one assessment
#'   window and the start of the next training window (default `0`, i.e. the
#'   next fold's test window starts immediately after the previous one).
#'
#' @return A list of `panel_time_split` objects, one per fold, in
#'   chronological order.
#' @export
panel_rolling_origin <- function(data, panel, initial, assess, skip = 0L) {
  periods <- panel_ordered_periods(data, panel)
  n_periods <- length(periods)
  if (!is.numeric(initial) || initial < 1L) stop("initial doit etre un entier >= 1.", call. = FALSE)
  if (!is.numeric(assess) || assess < 1L) stop("assess doit etre un entier >= 1.", call. = FALSE)
  if (!is.numeric(skip) || skip < 0L) stop("skip doit etre un entier >= 0.", call. = FALSE)
  initial <- as.integer(initial); assess <- as.integer(assess); skip <- as.integer(skip)

  times_chr <- as.character(data[[panel$time]])
  splits <- list()
  origin_end <- initial
  while (origin_end + assess <= n_periods) {
    train_periods <- periods[seq_len(origin_end)]
    test_periods <- periods[(origin_end + 1L):(origin_end + assess)]
    assert_no_temporal_leakage(train_periods, test_periods, periods)
    splits[[length(splits) + 1L]] <- structure(
      list(
        train = data[times_chr %in% train_periods, , drop = FALSE],
        test = data[times_chr %in% test_periods, , drop = FALSE],
        train_periods = train_periods,
        test_periods = test_periods
      ),
      class = "panel_time_split"
    )
    origin_end <- origin_end + assess + skip
  }
  if (length(splits) == 0L) {
    stop(sprintf(
      "Aucune fenetre rolling-origin possible : initial=%d + assess=%d depasse les %d periodes disponibles.",
      initial, assess, n_periods
    ), call. = FALSE)
  }
  splits
}

#' @export
print.panel_time_split <- function(x, ...) {
  cat(sprintf(
    "<panel_time_split> train: %d period(s) [%s .. %s] (%d rows) | test: %d period(s) [%s .. %s] (%d rows)\n",
    length(x$train_periods), x$train_periods[[1]], utils::tail(x$train_periods, 1),
    nrow(x$train),
    length(x$test_periods), x$test_periods[[1]], utils::tail(x$test_periods, 1),
    nrow(x$test)
  ))
  invisible(x)
}

panel_metrics_by_horizon <- function(truth, pred, times_chr, test_periods) {
  horizon <- match(times_chr, test_periods)
  rows <- lapply(seq_along(test_periods), function(h) {
    idx <- which(horizon == h)
    err <- truth[idx] - pred[idx]
    data.frame(
      horizon = h,
      period = test_periods[[h]],
      n_obs = length(idx),
      rmse = sqrt(mean(err^2)),
      mae = mean(abs(err)),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}
