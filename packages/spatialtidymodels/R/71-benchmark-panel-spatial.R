# Orchestration pour le harnais de panel spatial (J2 : panel_full_fit
# uniquement -- pas de rediffusion vers near_prediction/block_spatial/
# vfold_cv, qui supposent des lignes independantes, pas des couples
# unite-temps). Voir wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md.

panel_estimator_registry <- function() {
  data.frame(
    estimator = c("panel_fe", "panel_sar_fe", "panel_sem_fe", "panel_sac_fe", "panel_sdm_fe"),
    requires_W = c(FALSE, TRUE, TRUE, TRUE, TRUE),
    requires_balanced = c(FALSE, FALSE, FALSE, FALSE, TRUE),
    package = c("plm", "splm", "splm", "splm", "splm"),
    notes = c(
      "Panel a effets fixes/aleatoires non spatial (reference plm::plm()).",
      "SAR de panel a effets fixes/aleatoires (splm::spml(lag=TRUE, spatial.error='none')).",
      "SEM de panel, correction Baltagi-Song-Koh (splm::spml(lag=FALSE, spatial.error='b')).",
      "SAC ('sarar') de panel : lag + erreur (splm::spml(lag=TRUE, spatial.error='b')).",
      "SDM de panel : lag + WX construit manuellement (build_panel_wx()) ; requiert un panel equilibre."
    ),
    stringsAsFactors = FALSE
  )
}

#' List panel spatial estimators known to the panel harness
#'
#' Distinct from [available_benchmark_estimators()] (cross-sectional
#' registry) -- panel routes are never listed there and never dispatched by
#' [benchmark_spatial()].
#'
#' @return A data frame.
#' @export
available_panel_estimators <- function() {
  panel_estimator_registry()
}

fit_one_panel_estimator <- function(estimator, formula, data, panel, W, model_type) {
  registry <- panel_estimator_registry()
  spec <- registry[registry$estimator == estimator, , drop = FALSE]
  if (nrow(spec) == 0L) {
    stop(sprintf(
      "Estimateur panel inconnu: %s. Disponibles: %s.",
      estimator, paste(registry$estimator, collapse = ", ")
    ), call. = FALSE)
  }
  if (isTRUE(spec$requires_W) && is.null(W)) {
    stop(sprintf("%s requiert une matrice W definie sur les unites (voir spatial_panel_spec()).", estimator), call. = FALSE)
  }
  switch(estimator,
    panel_fe = panel_fe_fit(formula, data, panel, model_type = model_type),
    panel_sar_fe = panel_sar_fe_fit(formula, data, panel, W = W, model_type = model_type),
    panel_sem_fe = panel_sem_fe_fit(formula, data, panel, W = W, model_type = model_type),
    panel_sac_fe = panel_sac_fe_fit(formula, data, panel, W = W, model_type = model_type),
    panel_sdm_fe = panel_sdm_fe_fit(formula, data, panel, W = W, model_type = model_type)
  )
}

panel_fit_result_row <- function(estimator, cv_scheme, effect, elapsed_sec, fit = NULL,
                                  validated = NULL, fit_error = NA_character_,
                                  fold = NA_integer_, horizon = NA_integer_,
                                  period = NA_character_, n_obs_override = NULL,
                                  rmse = NA_real_, mae = NA_real_) {
  data.frame(
    estimator = estimator,
    cv_scheme = cv_scheme,
    fold = fold,
    horizon = horizon,
    period = period,
    n_units = if (!is.null(fit)) fit$n_units else (validated$n_units %||% NA_integer_),
    n_periods = if (!is.null(fit)) fit$n_periods else (validated$n_periods %||% NA_integer_),
    n_obs = if (!is.null(n_obs_override)) n_obs_override else if (!is.null(fit)) fit$n_obs else NA_integer_,
    balanced = if (!is.null(fit)) fit$balanced else (validated$balanced %||% NA),
    effect = effect,
    lag_coefficient = if (!is.null(fit)) (fit$extra$lag_coefficient %||% NA_real_) else NA_real_,
    error_coefficient = if (!is.null(fit)) (fit$extra$error_coefficient %||% NA_real_) else NA_real_,
    rmse = rmse,
    mae = mae,
    elapsed_sec = elapsed_sec,
    fit_error = fit_error,
    stringsAsFactors = FALSE
  )
}

#' @keywords internal
panel_fit_and_score_fold <- function(estimator, formula, panel, W, model_type,
                                      train, test, cv_scheme, fold) {
  elapsed_start <- proc.time()[["elapsed"]]
  fit <- tryCatch(
    fit_one_panel_estimator(estimator, formula, train, panel, W, model_type),
    error = function(e) e
  )
  if (inherits(fit, "error")) {
    elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
    return(list(fit = NULL, rows = panel_fit_result_row(
      estimator, cv_scheme, panel$effect, elapsed_sec,
      fit_error = conditionMessage(fit), fold = fold
    )))
  }
  pred <- tryCatch(predict_panel_fit(fit, test), error = function(e) e)
  elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
  if (inherits(pred, "error")) {
    return(list(fit = fit, rows = panel_fit_result_row(
      estimator, cv_scheme, panel$effect, elapsed_sec, fit = fit,
      fit_error = conditionMessage(pred), fold = fold
    )))
  }
  # formula[[2]] est evalue (pas simplement recherche comme nom de colonne) :
  # la reponse est generalement une transformation (ex. log(gsp)), jamais un
  # nom de colonne litteral du data frame.
  truth <- eval(formula[[2]], envir = test)
  times_chr <- as.character(test[[panel$time]])
  test_periods <- panel_ordered_periods(test, panel)
  by_horizon <- panel_metrics_by_horizon(truth, pred, times_chr, test_periods)
  rows <- do.call(rbind, lapply(seq_len(nrow(by_horizon)), function(i) {
    panel_fit_result_row(
      estimator, cv_scheme, panel$effect, elapsed_sec, fit = fit,
      fold = fold, horizon = by_horizon$horizon[[i]], period = by_horizon$period[[i]],
      n_obs_override = by_horizon$n_obs[[i]], rmse = by_horizon$rmse[[i]], mae = by_horizon$mae[[i]]
    )
  }))
  list(fit = fit, rows = rows)
}

#' Run spatial panel estimators on one dataset
#'
#' Three mutually exclusive resampling schemes, chosen with `cv_scheme`:
#' `"panel_full_fit"` (replication: fit on the whole panel, no split),
#' `"panel_time_holdout"` (fit on all periods except the last `h`, predict
#' those `h`), and `"panel_rolling_origin"` (growing-window folds, see
#' [panel_rolling_origin()]). Cross-sectional resampling schemes
#' (`near_prediction`, `block_spatial`, `vfold_cv`) do not apply to unit-time
#' observations and are never offered here.
#'
#' @param formula A model formula.
#' @param data A data frame with one row per unit-time observation.
#' @param panel A `spatial_panel_spec` (see [spatial_panel_spec()]).
#' @param W Optional spatial weights matrix defined over units, required by
#'   estimators with `requires_W = TRUE` in [available_panel_estimators()].
#' @param estimators Panel estimators to run: `"panel_fe"`, `"panel_sar_fe"`,
#'   `"panel_sem_fe"`, `"panel_sac_fe"`, `"panel_sdm_fe"` (see
#'   [available_panel_estimators()]). `panel_sdm_fe` requires a balanced
#'   panel; SEM/SAC/SDM/SAR prediction requires every unit present in each
#'   test period (see [predict_panel_fit()]); all prediction targets require
#'   `panel$effect == "individual"`.
#' @param model_type `"within"` (fixed effects) or `"random"`.
#' @param cv_scheme `"panel_full_fit"`, `"panel_time_holdout"`, or
#'   `"panel_rolling_origin"`.
#' @param h Number of trailing periods held out, for `cv_scheme =
#'   "panel_time_holdout"` (see [panel_time_holdout()]).
#' @param initial,assess,skip Rolling-origin window sizes, for `cv_scheme =
#'   "panel_rolling_origin"` (see [panel_rolling_origin()]).
#'
#' @return A `spatial_panel_benchmark` object with `results` (one row per
#'   estimator for `panel_full_fit`; one row per fold/estimator/horizon for
#'   the time-aware schemes) and `fits` (named list of `spatial_panel_fit`
#'   objects -- for `panel_full_fit`, the single fit per estimator; for the
#'   time-aware schemes, the fit from the LAST fold, kept for inspection).
#' @export
benchmark_spatial_panel <- function(formula, data, panel, W = NULL,
                                     estimators = c("panel_fe", "panel_sar_fe"),
                                     model_type = c("within", "random"),
                                     cv_scheme = c("panel_full_fit", "panel_time_holdout", "panel_rolling_origin"),
                                     h = NULL, initial = NULL, assess = NULL, skip = 0L) {
  model_type <- match.arg(model_type)
  cv_scheme <- match.arg(cv_scheme)
  registry <- panel_estimator_registry()
  unknown <- setdiff(estimators, registry$estimator)
  if (length(unknown) > 0L) {
    stop(sprintf(
      "Estimateur(s) panel inconnu(s): %s. Utilisez available_panel_estimators().",
      paste(unknown, collapse = ", ")
    ), call. = FALSE)
  }

  validated <- validate_spatial_panel_data(data, panel, W = W)

  if (cv_scheme == "panel_full_fit") {
    rows <- list()
    fits <- list()
    for (estimator in estimators) {
      elapsed_start <- proc.time()[["elapsed"]]
      fit <- tryCatch(
        fit_one_panel_estimator(estimator, formula, data, panel, W, model_type),
        error = function(e) e
      )
      elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
      if (inherits(fit, "error")) {
        rows[[estimator]] <- panel_fit_result_row(
          estimator, cv_scheme, panel$effect, elapsed_sec,
          validated = validated, fit_error = conditionMessage(fit)
        )
        next
      }
      fits[[estimator]] <- fit
      rows[[estimator]] <- panel_fit_result_row(estimator, cv_scheme, panel$effect, elapsed_sec, fit = fit)
    }
    results <- do.call(rbind, rows)
    row.names(results) <- NULL
    return(structure(
      list(results = results, fits = fits, panel = panel, validated = validated),
      class = "spatial_panel_benchmark"
    ))
  }

  splits <- if (cv_scheme == "panel_time_holdout") {
    if (is.null(h)) stop("cv_scheme='panel_time_holdout' requiert l'argument h.", call. = FALSE)
    list(panel_time_holdout(data, panel, h))
  } else {
    if (is.null(initial) || is.null(assess)) {
      stop("cv_scheme='panel_rolling_origin' requiert les arguments initial et assess.", call. = FALSE)
    }
    panel_rolling_origin(data, panel, initial, assess, skip)
  }

  rows <- list()
  fits <- list()
  for (fold in seq_along(splits)) {
    split <- splits[[fold]]
    for (estimator in estimators) {
      fold_id <- if (cv_scheme == "panel_time_holdout") NA_integer_ else fold
      out <- panel_fit_and_score_fold(estimator, formula, panel, W, model_type, split$train, split$test, cv_scheme, fold_id)
      rows[[length(rows) + 1L]] <- out$rows
      if (!is.null(out$fit)) fits[[estimator]] <- out$fit
    }
  }
  results <- do.call(rbind, rows)
  row.names(results) <- NULL

  structure(
    list(results = results, fits = fits, panel = panel, validated = validated, splits = splits),
    class = "spatial_panel_benchmark"
  )
}

#' @export
print.spatial_panel_benchmark <- function(x, ...) {
  cat(sprintf(
    "<spatial_panel_benchmark> %d units x %d periods (balanced=%s), %d estimator(s)\n",
    x$validated$n_units, x$validated$n_periods, x$validated$balanced, nrow(x$results)
  ))
  print(x$results)
  invisible(x)
}
