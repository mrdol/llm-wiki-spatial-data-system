# Couche d'orchestration multi-dataset x multi-schema CV.
#
# benchmark_spatial_datasets() fait deja dataset x estimateur pour UN schema
# CV. benchmark_spatial_suite() boucle sur plusieurs schemas CV, accepte des
# noms de dataset enregistres directement (pas besoin de construire des
# spatial_dataset_spec a la main), et aplatit les resultats fold-par-fold
# (normalement imbriques dans benchmarks[[dataset]]$resample_results) en une
# seule table dataset x estimateur x cv_scheme x fold. C'est cette table
# aplatie que consomme compare_estimator_variant() (R/16-estimator-comparison.R).

normalize_suite_dataset_specs <- function(datasets, data_dir, formula_role) {
  # Accepte soit des noms de dataset enregistres (character), soit des
  # spatial_dataset_spec deja construites (meme entree que
  # benchmark_spatial_datasets()).
  if (is.character(datasets)) {
    return(lapply(datasets, function(name) {
      loaded <- load_benchmark_dataset(name, data_dir = data_dir, formula_role = formula_role)
      spatial_dataset_spec(
        name = name,
        data = loaded$data,
        formula = loaded$formula,
        coords = loaded$coords
      )
    }))
  }
  normalize_dataset_specs(datasets)
}

#' Run a spatial benchmark suite across datasets, estimators and CV schemes
#'
#' Orchestrates `benchmark_spatial_datasets()` across one or several CV
#' schemes and flattens the fold-level results into a single table. This is
#' the layer a dashboard or a reference-vs-variant comparison should consume;
#' individual `benchmark_spatial()`/`benchmark_spatial_dataset()` calls remain
#' useful for interactive, single-dataset work.
#'
#' @param datasets Character vector of dataset names registered in
#'   `available_benchmark_datasets()`, or a `spatial_dataset_spec`/list of
#'   specs (same input `benchmark_spatial_datasets()` accepts).
#' @param estimators Estimators to run on every dataset/CV scheme.
#' @param cv_schemes One or several CV schemes (`near_prediction`,
#'   `block_spatial`, `holdout_10pct`, `vfold_cv`, `in_sample`). Each dataset
#'   is evaluated once per scheme.
#' @param data_dir,formula_role Passed to `load_benchmark_dataset()` when
#'   `datasets` is a character vector of registered names.
#' @inheritParams benchmark_spatial_datasets
#'
#' @return A `spatial_benchmark_suite` object with:
#'   \describe{
#'     \item{results}{dataset x estimator x cv_scheme summary table.}
#'     \item{resample_results}{dataset x estimator x cv_scheme x fold table
#'       (`NULL` if every CV scheme was `"in_sample"`).}
#'     \item{benchmarks}{nested `spatial_benchmark_set` objects keyed by CV
#'       scheme, kept for introspection/debugging.}
#'     \item{failures}{subset of `results` where `fit_error` is not `NA`.}
#'     \item{protocol}{the evaluation settings used (seed, formula_role,
#'       folds, ...), so a comparison can be reported alongside how it was
#'       produced.}
#'   }
#' @export
benchmark_spatial_suite <- function(datasets,
                                    estimators,
                                    cv_schemes = "near_prediction",
                                    data_dir = NULL,
                                    formula_role = "default",
                                    k_neighbors = 8, style = "W", zero_policy = TRUE,
                                    spboost_mstop = 100L, spboost_nu = 0.1,
                                    gamboost_mstop = 100L, gamboost_nu = 0.1,
                                    mgwrsar_bandwidth = 20, mgwrsar_kernel = "gauss",
                                    mgwrsar_fixed_vars = NULL,
                                    spmoran_enum = NULL, spmoran_vif = 10,
                                    tune = FALSE, resamples = NULL, tuning_grids = NULL,
                                    tuning_folds = 3L,
                                    eval_folds = 5L, holdout_prop = 0.9,
                                    near_n_reps = 3L, near_test_size = NULL,
                                    block_folds = 5L, seed = 123L,
                                    verbose = FALSE, parallel = FALSE,
                                    workers = max(1L, parallel::detectCores(logical = FALSE) - 1L),
                                    allow_heavy_tuning = FALSE) {
  if (length(cv_schemes) == 0L) {
    stop("cv_schemes doit contenir au moins un schema.", call. = FALSE)
  }
  specs <- normalize_suite_dataset_specs(datasets, data_dir = data_dir, formula_role = formula_role)
  dataset_names <- vapply(specs, function(s) s$name, character(1))

  benchmarks <- list()
  results_rows <- list()
  resample_rows <- list()

  for (scheme in cv_schemes) {
    benchmark_log(verbose, "[suite] cv_scheme=%s : %d dataset(s)", scheme, length(specs))
    set_bench <- benchmark_spatial_datasets(
      datasets = specs,
      estimators = estimators,
      k_neighbors = k_neighbors, style = style, zero_policy = zero_policy,
      spboost_mstop = spboost_mstop, spboost_nu = spboost_nu,
      gamboost_mstop = gamboost_mstop, gamboost_nu = gamboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth, mgwrsar_kernel = mgwrsar_kernel,
      mgwrsar_fixed_vars = mgwrsar_fixed_vars,
      spmoran_enum = spmoran_enum, spmoran_vif = spmoran_vif,
      tune = tune, resamples = resamples, tuning_grids = tuning_grids,
      tuning_folds = tuning_folds,
      cv_scheme = scheme,
      eval_folds = eval_folds, holdout_prop = holdout_prop,
      near_n_reps = near_n_reps, near_test_size = near_test_size,
      block_folds = block_folds, seed = seed,
      verbose = verbose, parallel = parallel, workers = workers,
      allow_heavy_tuning = allow_heavy_tuning
    )
    benchmarks[[scheme]] <- set_bench

    res <- set_bench$results
    res$cv_scheme <- scheme
    results_rows[[scheme]] <- res

    for (name in names(set_bench$benchmarks)) {
      rr <- set_bench$benchmarks[[name]]$resample_results
      if (is.null(rr) || nrow(rr) == 0L) next
      rr$dataset <- name
      rr$cv_scheme <- scheme
      resample_rows[[paste(scheme, name, sep = "::")]] <- rr
    }
  }

  results <- do.call(rbind, results_rows)
  row.names(results) <- NULL
  results <- results[, c("dataset", "cv_scheme", setdiff(names(results), c("dataset", "cv_scheme"))), drop = FALSE]

  resample_results <- if (length(resample_rows)) {
    out <- do.call(rbind, resample_rows)
    row.names(out) <- NULL
    out[, c("dataset", "cv_scheme", setdiff(names(out), c("dataset", "cv_scheme"))), drop = FALSE]
  } else {
    NULL
  }

  failures <- if ("fit_error" %in% names(results)) {
    results[!is.na(results$fit_error), , drop = FALSE]
  } else {
    results[0L, , drop = FALSE]
  }

  structure(
    list(
      results = results,
      resample_results = resample_results,
      benchmarks = benchmarks,
      datasets = dataset_names,
      estimators = estimators,
      cv_schemes = cv_schemes,
      failures = failures,
      protocol = list(
        formula_role = formula_role,
        seed = seed,
        tune = tune,
        eval_folds = eval_folds,
        holdout_prop = holdout_prop,
        near_n_reps = near_n_reps,
        block_folds = block_folds
      )
    ),
    class = "spatial_benchmark_suite"
  )
}

#' @export
print.spatial_benchmark_suite <- function(x, ...) {
  cat("Benchmark spatial suite\n")
  cat("Datasets: ", length(x$datasets), "\n", sep = "")
  cat("Estimateurs: ", paste(x$estimators, collapse = ", "), "\n", sep = "")
  cat("CV schemes: ", paste(x$cv_schemes, collapse = ", "), "\n", sep = "")
  cat("Lignes resultat: ", nrow(x$results), "\n", sep = "")
  if (nrow(x$failures) > 0L) {
    cat("Lignes avec au moins un fold en echec: ", nrow(x$failures), "\n", sep = "")
  }
  invisible(x)
}
