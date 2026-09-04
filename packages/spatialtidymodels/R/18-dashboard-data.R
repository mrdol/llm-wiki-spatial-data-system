# Preparation des donnees pour le dashboard.
#
# Ces fonctions sont volontairement independantes de Shiny -- testables sans
# lancer d'application, et reutilisables en console. Le dashboard (R/19-
# dashboard.R) ne fait qu'appeler ces fonctions et afficher leur resultat ;
# aucun calcul de KPI/heatmap/echec ne doit vivre dans le code Shiny lui-meme,
# meme principe que compare_estimator_variant() vis-a-vis d'un futur dashboard
# de comparaison.

dashboard_results_table <- function(suite) {
  if (inherits(suite, "spatial_benchmark_suite")) return(suite$results)
  if (is.data.frame(suite)) return(suite)
  stop("`suite` doit etre un spatial_benchmark_suite ou un data.frame de resultats.", call. = FALSE)
}

# compare_estimator_variant() (R/16) never pools cv_scheme silently -- every
# dashboard summary helper must honour the same rule. `cv_scheme = NULL`
# (default) is only safe when the data already has a single scheme (or none);
# with more than one present it errors instead of quietly medianing them
# together, forcing the caller (the dashboard UI, or a console user) to pick
# one explicitly. Pass `cv_scheme` to filter to it directly.
dashboard_require_single_cv_scheme <- function(results, cv_scheme = NULL) {
  if (!"cv_scheme" %in% names(results)) return(results)
  if (!is.null(cv_scheme)) {
    if (length(cv_scheme) != 1L) {
      stop("`cv_scheme` doit designer un seul schema a la fois dans les helpers dashboard.", call. = FALSE)
    }
    return(results[results$cv_scheme == cv_scheme, , drop = FALSE])
  }
  present <- unique(results$cv_scheme)
  if (length(present) > 1L) {
    stop(sprintf(
      "Plusieurs cv_scheme presents dans les resultats (%s) : precisez `cv_scheme=` pour eviter un melange silencieux entre schemas de validation croisee.",
      paste(present, collapse = ", ")
    ), call. = FALSE)
  }
  results
}

#' Compute headline KPIs for a benchmark suite
#'
#' For each requested metric, finds the single best (dataset, estimator,
#' cv_scheme) row -- the "champion" -- among cases with no fit error. Meant
#' for the four value-box style cards on a dashboard Overview page.
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#' @param metrics Metrics to report a champion for, in order.
#' @param lower_is_better Named logical vector giving each metric's
#'   direction. Metrics not listed default to `TRUE`.
#' @param cv_scheme `NULL` (default) requires `suite` to already cover a
#'   single CV scheme; pass a scheme name to filter to it explicitly. Errors
#'   rather than silently pooling multiple schemes together -- see
#'   [dashboard_require_single_cv_scheme()].
#'
#' @return A `data.frame`, one row per metric, with `metric`, `value`,
#'   `estimator`, `dataset`, `cv_scheme`. A metric with no finite value
#'   anywhere gets an `NA` row rather than being dropped, so a caller can
#'   still render an (empty) card for it.
#' @export
dashboard_kpis <- function(suite,
                           metrics = c("rmse", "mae", "moran_abs", "duration_sec"),
                           lower_is_better = c(rmse = TRUE, mae = TRUE, moran_abs = TRUE, duration_sec = TRUE),
                           cv_scheme = NULL) {
  results <- dashboard_require_single_cv_scheme(dashboard_results_table(suite), cv_scheme)
  if ("fit_error" %in% names(results)) {
    results <- results[is.na(results$fit_error), , drop = FALSE]
  }

  rows <- lapply(metrics, function(m) {
    if (!m %in% names(results) || nrow(results) == 0L) {
      return(data.frame(
        metric = m, value = NA_real_, estimator = NA_character_,
        dataset = NA_character_, cv_scheme = NA_character_, stringsAsFactors = FALSE
      ))
    }
    direction <- if (m %in% names(lower_is_better)) lower_is_better[[m]] else TRUE
    values <- results[[m]]
    finite <- is.finite(values)
    if (!any(finite)) {
      return(data.frame(
        metric = m, value = NA_real_, estimator = NA_character_,
        dataset = NA_character_, cv_scheme = NA_character_, stringsAsFactors = FALSE
      ))
    }
    candidates <- results[finite, , drop = FALSE]
    best_idx <- if (isTRUE(direction)) which.min(candidates[[m]]) else which.max(candidates[[m]])
    data.frame(
      metric = m,
      value = candidates[[m]][[best_idx]],
      estimator = candidates$estimator[[best_idx]],
      dataset = candidates$dataset[[best_idx]],
      cv_scheme = if ("cv_scheme" %in% names(candidates)) candidates$cv_scheme[[best_idx]] else NA_character_,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}

#' Compute a dataset x estimator metric table relative to a baseline
#'
#' Aggregates each (dataset, estimator) pair's metric across CV schemes
#' (median, to avoid mixing schemes into a single number silently) then
#' expresses it relative to a baseline estimator's value on the *same*
#' dataset. Values `< 1` mean "better than baseline" regardless of the
#' metric's own direction -- a heatmap can use one consistent color scale.
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#' @param baseline_estimator Estimator every other estimator is expressed
#'   relative to, e.g. `"ols"`.
#' @param metric Metric to compute the ratio on. Default `"rmse"`.
#' @param lower_is_better Whether lower values of `metric` are better.
#'   Default `TRUE`.
#' @param cv_scheme `NULL` (default) requires `suite` to already cover a
#'   single CV scheme; pass a scheme name to filter to it explicitly. Errors
#'   rather than silently pooling multiple schemes together.
#'
#' @return A `data.frame` in long form: `dataset`, `estimator`, `value`
#'   (the aggregated metric), `relative` (ratio to the baseline, `NA` where
#'   the baseline itself has no value for that dataset).
#' @export
dashboard_relative_metric <- function(suite, baseline_estimator, metric = "rmse", lower_is_better = TRUE, cv_scheme = NULL) {
  results <- dashboard_require_single_cv_scheme(dashboard_results_table(suite), cv_scheme)
  if (!metric %in% names(results)) {
    stop(sprintf("Metrique absente des resultats: %s", metric), call. = FALSE)
  }
  if (!baseline_estimator %in% results$estimator) {
    stop(sprintf("Estimateur de reference introuvable dans les resultats: %s", baseline_estimator), call. = FALSE)
  }

  agg <- stats::aggregate(
    stats::as.formula(sprintf("%s ~ dataset + estimator", metric)),
    data = results[is.finite(results[[metric]]), , drop = FALSE],
    FUN = stats::median
  )
  names(agg)[names(agg) == metric] <- "value"

  baseline <- agg[agg$estimator == baseline_estimator, c("dataset", "value")]
  names(baseline)[names(baseline) == "value"] <- "baseline_value"

  out <- merge(agg, baseline, by = "dataset", all.x = TRUE)
  out$relative <- if (isTRUE(lower_is_better)) {
    out$value / out$baseline_value
  } else {
    out$baseline_value / out$value
  }
  out <- out[order(out$dataset, out$estimator), , drop = FALSE]
  row.names(out) <- NULL
  out[, c("dataset", "estimator", "value", "relative")]
}

#' Join estimators present in a suite with their taxonomy family and dashboard group
#'
#' Thin wrapper around [available_benchmark_estimators()] restricted to the
#' estimators actually present in `suite`'s results -- used to color a
#' performance/duration scatter by family, and to drive a dashboard_group
#' sidebar nav.
#'
#' `family` (the scientific model family, e.g. `"SAR"`) and `dashboard_group`
#' (which dashboard menu section to list the estimator under, e.g.
#' `"Boosting"`) are deliberately different columns and can disagree: an
#' estimator like `spboost_bspa_sar_ml` is scientifically a SAR (`family =
#' "SAR"`) but implemented via a boosting backend, so it belongs under a
#' `"Boosting"` dashboard section -- never conflate the two.
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#'
#' @return A `data.frame` with `estimator`, `family`, `dashboard_group`
#'   (both fall back to `"other"`/`"Other"` when the estimator has no
#'   taxonomy entry, e.g. a custom estimator registered without one).
#' @export
dashboard_estimator_families <- function(suite) {
  results <- dashboard_results_table(suite)
  present <- sort(unique(results$estimator))
  registry <- tryCatch(available_benchmark_estimators(include_installed = FALSE), error = function(e) NULL)
  if (is.null(registry)) {
    family <- rep(NA_character_, length(present))
    dashboard_group <- rep(NA_character_, length(present))
  } else {
    idx <- match(present, registry$estimator)
    family <- registry$family[idx]
    dashboard_group <- if ("dashboard_group" %in% names(registry)) registry$dashboard_group[idx] else rep(NA_character_, length(present))
  }
  family[is.na(family)] <- "other"
  dashboard_group[is.na(dashboard_group)] <- "Other"
  data.frame(estimator = present, family = family, dashboard_group = dashboard_group, stringsAsFactors = FALSE)
}

#' Aggregate a metric per estimator across all filtered rows
#'
#' Generic building block for a single-metric summary chart (e.g. residual
#' spatial autocorrelation): one aggregated value per estimator, computed
#' only over finite values. Deliberately does not collapse cv_scheme first --
#' pass an already cv_scheme-filtered `suite`/`results` if that distinction
#' matters, same convention as the rest of this file.
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#' @param metric Column to aggregate, e.g. `"moran_i"`.
#' @param fun Aggregation function applied to the finite values of `metric`
#'   for each estimator. Default `stats::median`.
#' @param cv_scheme `NULL` (default) requires `suite` to already cover a
#'   single CV scheme; pass a scheme name to filter to it explicitly. Errors
#'   rather than silently pooling multiple schemes together.
#'
#' @return A `data.frame` with `estimator`, `value`. An estimator with no
#'   finite values gets `NA` rather than being dropped.
#' @export
dashboard_metric_by_estimator <- function(suite, metric, fun = stats::median, cv_scheme = NULL) {
  results <- dashboard_require_single_cv_scheme(dashboard_results_table(suite), cv_scheme)
  if (!metric %in% names(results)) {
    stop(sprintf("Metrique absente des resultats: %s", metric), call. = FALSE)
  }
  rows <- lapply(split(results, results$estimator), function(g) {
    values <- g[[metric]][is.finite(g[[metric]])]
    data.frame(
      estimator = g$estimator[[1]],
      value = if (length(values)) fun(values) else NA_real_,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out[order(out$estimator), , drop = FALSE]
}

#' Pivot the estimator-vs-baseline relative metric into a heatmap-ready matrix
#'
#' Wraps [dashboard_relative_metric()] and reshapes its long-form output into
#' a wide `dataset x estimator` table of `relative` values, with the baseline
#' column (always `1`) included and an appended summary row (column-wise,
#' ignoring `NA`) -- shaped for a color-graded HTML table rather than a
#' ggplot heatmap.
#'
#' @inheritParams dashboard_relative_metric
#' @param summary_row Which cross-dataset summary to append as a final row:
#'   `"median"` (default -- robust to one dataset having an extreme ratio,
#'   preferred per project convention) or `"mean"`. Set `"none"` to omit it.
#'
#' @return A `data.frame` with a `dataset` column followed by one column per
#'   estimator (baseline first), values are the `relative` ratio.
#' @export
dashboard_relative_metric_wide <- function(suite, baseline_estimator, metric = "rmse", lower_is_better = TRUE,
                                           cv_scheme = NULL, summary_row = c("median", "mean", "none")) {
  summary_row <- match.arg(summary_row)
  long <- dashboard_relative_metric(suite, baseline_estimator, metric, lower_is_better, cv_scheme = cv_scheme)
  estimators <- unique(c(baseline_estimator, sort(unique(long$estimator))))

  wide <- stats::reshape(
    long[, c("dataset", "estimator", "relative")],
    idvar = "dataset", timevar = "estimator", direction = "wide"
  )
  names(wide) <- sub("^relative\\.", "", names(wide))
  missing_est <- setdiff(estimators, names(wide))
  for (est in missing_est) wide[[est]] <- NA_real_
  wide <- wide[, c("dataset", estimators), drop = FALSE]
  wide <- wide[order(wide$dataset), , drop = FALSE]

  if (identical(summary_row, "none")) return(wide)
  summary_fun <- if (identical(summary_row, "median")) stats::median else mean
  summary_label <- if (identical(summary_row, "median")) "Median (all datasets)" else "Average (all datasets)"
  summary_vals <- c(list(dataset = summary_label), lapply(wide[, estimators, drop = FALSE], function(col) {
    if (all(is.na(col))) NA_real_ else summary_fun(col, na.rm = TRUE)
  }))
  rbind(wide, as.data.frame(summary_vals, stringsAsFactors = FALSE))
}

#' Summarize fit failures per estimator
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#'   Fold-level failure rate is used when `n_resamples`/`n_failed_resamples`
#'   are present; otherwise falls back to counting rows with a non-`NA`
#'   `fit_error`.
#'
#' @param cv_scheme `NULL` (default) requires `suite` to already cover a
#'   single CV scheme; pass a scheme name to filter to it explicitly. Errors
#'   rather than silently pooling multiple schemes together.
#'
#' @return A `data.frame`, one row per estimator: `n_cases`, `n_failed`
#'   (fold-level count when available, else case count), `failure_rate`,
#'   `datasets_affected`, `worst_case_failure_rate`. Estimators with zero
#'   failures are still included (helps a dashboard show "0 failures"
#'   explicitly rather than omitting a clean estimator).
#' @export
dashboard_failure_summary <- function(suite, cv_scheme = NULL) {
  results <- dashboard_require_single_cv_scheme(dashboard_results_table(suite), cv_scheme)
  has_fold_info <- all(c("n_resamples", "n_failed_resamples") %in% names(results))

  rows <- lapply(split(results, results$estimator), function(g) {
    if (has_fold_info) {
      n_total <- sum(g$n_resamples, na.rm = TRUE)
      n_failed <- sum(g$n_failed_resamples, na.rm = TRUE)
      case_rate <- ifelse(
        !is.na(g$n_resamples) & g$n_resamples > 0,
        g$n_failed_resamples / g$n_resamples,
        as.numeric(!is.na(g$fit_error))
      )
    } else {
      n_total <- nrow(g)
      n_failed <- sum(!is.na(g$fit_error))
      case_rate <- as.numeric(!is.na(g$fit_error))
    }
    affected <- g$dataset[case_rate > 0]
    data.frame(
      estimator = g$estimator[[1]],
      n_cases = nrow(g),
      n_failed = n_failed,
      failure_rate = if (n_total > 0) n_failed / n_total else NA_real_,
      datasets_affected = length(unique(affected)),
      worst_case_failure_rate = if (length(case_rate)) max(case_rate, na.rm = TRUE) else NA_real_,
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  out <- out[order(-out$failure_rate), , drop = FALSE]
  row.names(out) <- NULL
  out
}

#' Median relative metric per estimator, aggregated across datasets
#'
#' Response variables are not on a comparable scale between datasets, so a
#' raw metric aggregated across datasets (e.g. `median(rmse)` mixing a
#' dataset where Y is in the 0-1 range with one where Y is in the millions)
#' is not a valid cross-dataset ranking -- see [dashboard_relative_metric()].
#' This is the function an Overview KPI card or a performance-vs-duration
#' scatter should use for a cross-dataset Y axis: the per-(dataset,
#' estimator) relative ratio from `dashboard_relative_metric()`, aggregated
#' to one value per estimator via the median across datasets (not the mean,
#' so one dataset with an extreme ratio can't dominate).
#'
#' @inheritParams dashboard_relative_metric
#'
#' @return A `data.frame`, one row per estimator, ordered best-first:
#'   `estimator`, `median_relative`, `n_datasets` (how many datasets
#'   contributed a finite relative value).
#' @export
dashboard_relative_metric_by_estimator <- function(suite, baseline_estimator, metric = "rmse", lower_is_better = TRUE, cv_scheme = NULL) {
  long <- dashboard_relative_metric(suite, baseline_estimator, metric, lower_is_better, cv_scheme = cv_scheme)
  rows <- lapply(split(long, long$estimator), function(g) {
    vals <- g$relative[is.finite(g$relative)]
    data.frame(
      estimator = g$estimator[[1]],
      median_relative = if (length(vals)) stats::median(vals) else NA_real_,
      n_datasets = length(vals),
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, rows)
  out <- out[order(out$median_relative), , drop = FALSE]
  row.names(out) <- NULL
  out
}

#' Pick the best estimator by median relative metric, for a KPI card
#'
#' Thin wrapper around [dashboard_relative_metric_by_estimator()] that picks
#' the single best row -- e.g. "Best median relative RMSE: 0.72x, SpBoost SAR
#' ML, vs SAR Lag". Never picks based on a raw, cross-dataset-incomparable
#' metric value (see [dashboard_relative_metric_by_estimator()]).
#'
#' @inheritParams dashboard_relative_metric
#'
#' @return A list: `metric`, `estimator` (`NA` if no estimator has a finite
#'   value), `value` (the median relative ratio), `baseline`, `n_datasets`.
#' @export
dashboard_best_relative_estimator <- function(suite, baseline_estimator, metric = "rmse", lower_is_better = TRUE, cv_scheme = NULL) {
  agg <- dashboard_relative_metric_by_estimator(suite, baseline_estimator, metric, lower_is_better, cv_scheme = cv_scheme)
  valid <- agg[is.finite(agg$median_relative), , drop = FALSE]
  if (nrow(valid) == 0L) {
    return(list(metric = metric, estimator = NA_character_, value = NA_real_, baseline = baseline_estimator, n_datasets = 0L))
  }
  best <- valid[which.min(valid$median_relative), , drop = FALSE]
  list(
    metric = metric,
    estimator = best$estimator[[1]],
    value = best$median_relative[[1]],
    baseline = baseline_estimator,
    n_datasets = best$n_datasets[[1]]
  )
}

#' Residual spatial dependence, corrected for E(I) under CSR when appropriate
#'
#' `moran_abs` (`|I|`) treats a small positive `I` on a small test sample the
#' same as a small positive `I` on a huge one, but under complete spatial
#' randomness `E(I) = -1/(n-1)` is not `0` -- for small `n`, a mildly
#' negative `I` can be *closer* to what pure randomness predicts than a
#' mildly positive one. `|I - E(I)|` corrects for this, but it is only
#' statistically meaningful when the row's own `n` is the exact test size
#' the row's `moran_i` was computed on.
#'
#' At the aggregated-row level (one row per dataset x estimator x cv_scheme),
#' `moran_i` is the **unweighted mean** of each fold/repetition's own Moran's
#' I (see `summarize_resample_results()` in R/13), while `n` is the
#' **pooled** test size across all those folds. For any cv_scheme with more
#' than one evaluation (`n_resamples > 1`, e.g. `near_prediction`'s
#' repetitions or `block_spatial`'s folds), pairing the pooled `n` with the
#' averaged `I` in `E(I) = -1/(n-1)` would not correspond to any single
#' Moran test actually run -- silently misleading. The correction is
#' therefore applied only where `n_resamples == 1` (a single evaluation,
#' e.g. `holdout_10pct` or `in_sample`); every other row falls back to
#' `moran_abs`.
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#' @param cv_scheme `NULL` (default) requires `suite` to already cover a
#'   single CV scheme; pass a scheme name to filter to it explicitly.
#'
#' @return `results` (after the `cv_scheme` filter) with two columns added:
#'   `residual_spatial_dependence` (the corrected or fallback value, `NA` if
#'   neither `moran_i` nor `moran_abs` is available) and
#'   `residual_spatial_dependence_method` (`"corrected"`,
#'   `"moran_abs_fallback"`, or `NA`).
#' @export
dashboard_residual_spatial_dependence <- function(suite, cv_scheme = NULL) {
  results <- dashboard_require_single_cv_scheme(dashboard_results_table(suite), cv_scheme)
  has_moran_i <- "moran_i" %in% names(results)
  has_moran_abs <- "moran_abs" %in% names(results)
  has_n <- "n" %in% names(results)
  has_n_resamples <- "n_resamples" %in% names(results)

  n_rows <- nrow(results)
  value <- rep(NA_real_, n_rows)
  method <- rep(NA_character_, n_rows)

  if (has_moran_i && has_n && has_n_resamples) {
    single_eval <- !is.na(results$n_resamples) & results$n_resamples == 1L &
      !is.na(results$n) & results$n > 1L & !is.na(results$moran_i)
    expected_i <- -1 / (results$n - 1)
    value[single_eval] <- abs(results$moran_i[single_eval] - expected_i[single_eval])
    method[single_eval] <- "corrected"
  }

  needs_fallback <- is.na(value)
  if (has_moran_abs) {
    method[needs_fallback & !is.na(results$moran_abs)] <- "moran_abs_fallback"
    value[needs_fallback] <- results$moran_abs[needs_fallback]
  } else if (has_moran_i) {
    method[needs_fallback & !is.na(results$moran_i)] <- "moran_abs_fallback"
    value[needs_fallback] <- abs(results$moran_i[needs_fallback])
  }

  results$residual_spatial_dependence <- value
  results$residual_spatial_dependence_method <- method
  results
}

#' Count benchmark tasks vs. independent data sources in a suite
#'
#' A dataset split into several benchmark tasks from the same underlying data
#' collection (e.g. one country's housing data split into per-year files,
#' see `korea_hedonic_housing`) is one independent *source*, not several --
#' see `wiki/metadata/dataset_distribution_architecture_2026-08.md`. This
#' counts both so a dashboard can report "N benchmark tasks / N independent
#' sources" rather than implying every task is an independent source.
#'
#' @param suite A `spatial_benchmark_suite` (uses its `dataset_metadata`
#'   directly -- see [benchmark_spatial_suite()] -- rather than rebuilding
#'   it), or a character vector of dataset/benchmark-task names.
#'
#' @return A list: `n_benchmark_tasks`, `n_independent_sources`, `table` (a
#'   `data.frame` with `dataset`, `source_dataset_id`, `benchmark_task_id`
#'   for each dataset in `suite`; a dataset absent from the package metadata
#'   registry -- e.g. a synthetic/ad hoc dataset used outside the registry --
#'   is treated as its own task and its own source, the same fallback
#'   convention as `metadata_dataset_registry()`).
#' @export
dashboard_task_source_counts <- function(suite) {
  if (inherits(suite, "spatial_benchmark_suite") && !is.null(suite$dataset_metadata)) {
    table <- suite$dataset_metadata[, c("dataset", "source_dataset_id", "benchmark_task_id"), drop = FALSE]
  } else {
    dataset_names <- unique(if (inherits(suite, "spatial_benchmark_suite")) suite$datasets else as.character(suite))
    meta <- build_suite_dataset_metadata(dataset_names)
    table <- meta[, c("dataset", "source_dataset_id", "benchmark_task_id"), drop = FALSE]
  }

  list(
    n_benchmark_tasks = length(unique(table$benchmark_task_id)),
    n_independent_sources = length(unique(table$source_dataset_id)),
    table = table
  )
}

#' Bucket datasets into dataset-size tertiles for subgroup analysis
#'
#' Builds a `groups` data.frame usable directly as
#' `compare_estimator_variant(groups = ...)`'s subgroup dimension, from a
#' suite's `dataset_metadata$n` (see [benchmark_spatial_suite()]). Returns
#' `NULL` when there isn't enough real per-dataset `n` to make tertiles
#' meaningful -- this never invents a grouping that isn't backed by actual
#' dataset metadata; a page should render "Not enough metadata for subgroup
#' analysis" in that case rather than fabricating buckets.
#'
#' @param dataset_metadata `suite$dataset_metadata` (or an equivalent
#'   `data.frame` with `dataset` and `n` columns).
#' @param min_datasets Minimum number of datasets with a known `n` required
#'   before bucketing is attempted. Default `6` (so each tertile has at
#'   least ~2 datasets).
#'
#' @return A `data.frame(dataset, n_tertile)` with `n_tertile` in
#'   `c("small", "medium", "large")` (fewer levels if the data doesn't span
#'   enough distinct values for 3 buckets), or `NULL`.
#' @export
dashboard_n_tertile_groups <- function(dataset_metadata, min_datasets = 6L) {
  if (is.null(dataset_metadata) || !all(c("dataset", "n") %in% names(dataset_metadata))) return(NULL)
  known <- dataset_metadata[!is.na(dataset_metadata$n), c("dataset", "n"), drop = FALSE]
  if (nrow(known) < min_datasets || length(unique(known$n)) < 2L) return(NULL)

  breaks <- unique(stats::quantile(known$n, probs = c(0, 1 / 3, 2 / 3, 1), type = 7))
  if (length(breaks) < 3L) return(NULL) # not enough distinct values for at least 2 real cut points
  labels <- c("small", "medium", "large")[seq_len(length(breaks) - 1L)]
  known$n_tertile <- as.character(cut(known$n, breaks = breaks, labels = labels, include.lowest = TRUE))
  row.names(known) <- NULL
  known[, c("dataset", "n_tertile")]
}

#' Median relative metric per estimator, computed independently per CV scheme
#'
#' Runs [dashboard_relative_metric_by_estimator()] once per CV scheme and
#' stacks the results with a `cv_scheme` column -- this is the building
#' block for a CV Schemes comparison page: it must be possible to see that
#' an estimator does well in `near_prediction` but poorly in
#' `block_spatial`, which requires the per-scheme numbers to stay separate.
#' Never pools cases across schemes into one number (the way
#' [dashboard_relative_metric()] would if called on unfiltered multi-scheme
#' data without `cv_scheme=`).
#'
#' @inheritParams dashboard_relative_metric
#' @param cv_schemes CV schemes to include. `NULL` (default) uses every
#'   scheme present in `suite`.
#'
#' @return A `data.frame`: `cv_scheme`, `estimator`, `median_relative`,
#'   `n_datasets`. A scheme with no valid cases for `baseline_estimator`
#'   contributes no rows rather than erroring.
#' @export
dashboard_relative_metric_by_scheme <- function(suite, baseline_estimator, metric = "rmse", lower_is_better = TRUE, cv_schemes = NULL) {
  results <- dashboard_results_table(suite)
  schemes <- if (is.null(cv_schemes)) sort(unique(results$cv_scheme)) else cv_schemes
  rows <- lapply(schemes, function(cv) {
    agg <- tryCatch(
      dashboard_relative_metric_by_estimator(results, baseline_estimator, metric, lower_is_better, cv_scheme = cv),
      error = function(e) NULL
    )
    if (is.null(agg) || nrow(agg) == 0L) return(NULL)
    agg$cv_scheme <- cv
    agg
  })
  rows <- rows[!vapply(rows, is.null, logical(1))]
  if (length(rows) == 0L) {
    return(data.frame(cv_scheme = character(0), estimator = character(0), median_relative = numeric(0), n_datasets = integer(0), stringsAsFactors = FALSE))
  }
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out[, c("cv_scheme", "estimator", "median_relative", "n_datasets")]
}

#' Fold-failure summary, computed independently per CV scheme
#'
#' Runs [dashboard_failure_summary()] once per CV scheme and stacks the
#' results with a `cv_scheme` column -- same "never pool across schemes"
#' rule as [dashboard_relative_metric_by_scheme()].
#'
#' @param suite A `spatial_benchmark_suite` or a results-shaped `data.frame`.
#' @param cv_schemes CV schemes to include. `NULL` (default) uses every
#'   scheme present in `suite`.
#'
#' @return A `data.frame`: `cv_scheme` plus every column
#'   [dashboard_failure_summary()] returns.
#' @export
dashboard_failure_summary_by_scheme <- function(suite, cv_schemes = NULL) {
  results <- dashboard_results_table(suite)
  schemes <- if (is.null(cv_schemes)) sort(unique(results$cv_scheme)) else cv_schemes
  rows <- lapply(schemes, function(cv) {
    fs <- dashboard_failure_summary(results, cv_scheme = cv)
    if (nrow(fs) == 0L) return(NULL)
    fs$cv_scheme <- cv
    fs
  })
  rows <- rows[!vapply(rows, is.null, logical(1))]
  if (length(rows) == 0L) {
    return(data.frame(
      cv_scheme = character(0), estimator = character(0), n_cases = integer(0), n_failed = integer(0),
      failure_rate = numeric(0), datasets_affected = integer(0), worst_case_failure_rate = numeric(0),
      stringsAsFactors = FALSE
    ))
  }
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out[, c("cv_scheme", setdiff(names(out), "cv_scheme"))]
}
