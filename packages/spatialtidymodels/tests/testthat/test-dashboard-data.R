# Tests for the dashboard data-prep layer (R/18-dashboard-data.R) and the
# launch_benchmark_dashboard() app constructor (R/19-dashboard.R). Kept fast:
# most tests use a hand-built synthetic results data.frame with known
# champions so expectations don't depend on model-fitting internals; only one
# test exercises a real (tiny) benchmark_spatial_suite() run for integration.

# True 2 datasets x 2 cv_schemes x 2 estimators factorial (8 unique rows, no
# duplicates) so row indices are unambiguous in the tests below. sar_lag is
# consistently a bit better on rmse/mae/moran_abs but much slower than ols.
dashboard_test_results <- function() {
  grid <- expand.grid(
    estimator = c("ols", "sar_lag"),
    cv_scheme = c("near_prediction", "holdout_10pct"),
    dataset = c("ds_a", "ds_b"),
    stringsAsFactors = FALSE
  )
  is_sar <- grid$estimator == "sar_lag"
  is_b <- grid$dataset == "ds_b"
  data.frame(
    dataset = grid$dataset,
    cv_scheme = grid$cv_scheme,
    estimator = grid$estimator,
    rmse = ifelse(is_sar, 1.0, 2.0) + ifelse(is_b, 1.0, 0) + ifelse(grid$cv_scheme == "holdout_10pct", 0.2, 0),
    mae = ifelse(is_sar, 0.8, 1.5) + ifelse(is_b, 0.5, 0) + ifelse(grid$cv_scheme == "holdout_10pct", 0.1, 0),
    moran_abs = ifelse(is_sar, 0.02, 0.10) + ifelse(is_b, 0.10, 0) + ifelse(grid$cv_scheme == "holdout_10pct", 0.01, 0),
    duration_sec = ifelse(is_sar, 5.0, 0.5) + ifelse(is_b, 0.1, 0) + ifelse(grid$cv_scheme == "holdout_10pct", 0.1, 0),
    fit_error = NA_character_,
    stringsAsFactors = FALSE
  )
}

test_that("dashboard_results_table() dispatches on suite vs data.frame vs invalid input", {
  df <- dashboard_test_results()
  expect_identical(dashboard_results_table(df), df)

  suite <- structure(list(results = df), class = "spatial_benchmark_suite")
  expect_identical(dashboard_results_table(suite), df)

  expect_error(dashboard_results_table(list(a = 1)), "spatial_benchmark_suite")
})

test_that("dashboard_kpis() picks the correct champion per metric and respects direction", {
  results <- dashboard_test_results()
  kpis <- dashboard_kpis(results, cv_scheme = "near_prediction")

  expect_equal(nrow(kpis), 4L)
  expect_setequal(kpis$metric, c("rmse", "mae", "moran_abs", "duration_sec"))

  rmse_row <- kpis[kpis$metric == "rmse", ]
  expect_equal(rmse_row$value, 1.0)
  expect_equal(rmse_row$estimator, "sar_lag")
  expect_equal(rmse_row$dataset, "ds_a")

  # duration_sec: ols is always faster -> champion should be ols
  duration_row <- kpis[kpis$metric == "duration_sec", ]
  expect_equal(duration_row$estimator, "ols")
  expect_equal(duration_row$value, 0.5)
})

test_that("dashboard_kpis() excludes fit_error rows and returns NA (not dropped) when no finite value exists", {
  results <- dashboard_test_results()
  results$fit_error[results$estimator == "sar_lag"] <- "boom"

  kpis <- dashboard_kpis(results, metrics = "rmse", cv_scheme = "near_prediction")
  expect_equal(nrow(kpis), 1L)
  expect_equal(kpis$estimator, "ols")

  results$fit_error <- "always fails"
  kpis_all_failed <- dashboard_kpis(results, metrics = c("rmse", "mae"), cv_scheme = "near_prediction")
  expect_equal(nrow(kpis_all_failed), 2L)
  expect_true(all(is.na(kpis_all_failed$value)))
  expect_true(all(is.na(kpis_all_failed$estimator)))
})

test_that("dashboard helpers error when multiple cv_scheme are present and none is specified, instead of silently pooling them", {
  # compare_estimator_variant() (R/16) never mixes cv_scheme into one
  # statistical test; every dashboard summary helper must refuse the same
  # way rather than silently medianing near_prediction + holdout_10pct
  # together. This is the regression test for that rule.
  results <- dashboard_test_results()
  expect_error(dashboard_kpis(results), "cv_scheme")
  expect_error(dashboard_relative_metric(results, baseline_estimator = "ols"), "cv_scheme")
  expect_error(dashboard_relative_metric_wide(results, baseline_estimator = "ols"), "cv_scheme")
  expect_error(dashboard_metric_by_estimator(results, "rmse"), "cv_scheme")
  expect_error(dashboard_failure_summary(results), "cv_scheme")

  # A single cv_scheme present (no ambiguity) or an explicit cv_scheme= both
  # work without error (evaluating them directly: an uncaught error would
  # fail this test_that block on its own).
  single_scheme <- results[results$cv_scheme == "near_prediction", , drop = FALSE]
  expect_equal(nrow(dashboard_kpis(single_scheme)), 4L)
  expect_equal(nrow(dashboard_kpis(results, cv_scheme = "near_prediction")), 4L)
  expect_error(dashboard_kpis(results, cv_scheme = c("near_prediction", "holdout_10pct")), "un seul schema")
})

test_that("dashboard_relative_metric() computes ratios to baseline within a single cv_scheme", {
  results <- dashboard_test_results()
  rel <- dashboard_relative_metric(results, baseline_estimator = "ols", metric = "rmse", cv_scheme = "near_prediction")

  expect_setequal(names(rel), c("dataset", "estimator", "value", "relative"))
  ols_a <- rel[rel$dataset == "ds_a" & rel$estimator == "ols", ]
  expect_equal(ols_a$value, 2.0)
  expect_equal(ols_a$relative, 1) # baseline relative to itself is always 1

  sar_a <- rel[rel$dataset == "ds_a" & rel$estimator == "sar_lag", ]
  expect_equal(sar_a$value, 1.0)
  expect_true(sar_a$relative < 1) # sar_lag beats ols on rmse in this fixture
})

test_that("dashboard_relative_metric() still medians genuine duplicate rows within one cv_scheme", {
  # Two rows sharing the same (dataset, cv_scheme, estimator) triple -- e.g. a
  # results table someone concatenated from two runs -- should still be
  # collapsed by median; this is a property of the aggregate() call, distinct
  # from the cv_scheme-mixing question covered above.
  dup <- rbind(
    data.frame(dataset = "ds_a", cv_scheme = "near_prediction", estimator = "ols", rmse = 2.0, stringsAsFactors = FALSE),
    data.frame(dataset = "ds_a", cv_scheme = "near_prediction", estimator = "ols", rmse = 4.0, stringsAsFactors = FALSE),
    data.frame(dataset = "ds_a", cv_scheme = "near_prediction", estimator = "sar_lag", rmse = 1.0, stringsAsFactors = FALSE)
  )
  rel <- dashboard_relative_metric(dup, baseline_estimator = "ols", metric = "rmse")
  ols_a <- rel[rel$estimator == "ols", ]
  expect_equal(ols_a$value, stats::median(c(2.0, 4.0)))
})

test_that("dashboard_relative_metric() inverts the ratio when lower_is_better = FALSE", {
  # Restricted to a single cv_scheme so each (dataset, estimator) has exactly
  # one value -- avoids median(1/x) != 1/median(x) for the n > 1 case, which
  # is a property of the median, not something the function should paper over.
  results <- dashboard_test_results()
  results <- results[results$cv_scheme == "near_prediction", , drop = FALSE]
  results$score <- 1 / results$rmse # higher is better

  rel_lower <- dashboard_relative_metric(results, baseline_estimator = "ols", metric = "rmse", lower_is_better = TRUE)
  rel_higher <- dashboard_relative_metric(results, baseline_estimator = "ols", metric = "score", lower_is_better = FALSE)

  sar_lower <- rel_lower[rel_lower$dataset == "ds_a" & rel_lower$estimator == "sar_lag", ]
  sar_higher <- rel_higher[rel_higher$dataset == "ds_a" & rel_higher$estimator == "sar_lag", ]
  expect_equal(sar_lower$relative, sar_higher$relative, tolerance = 1e-8)
})

test_that("dashboard_relative_metric() errors on an unknown metric or an unknown baseline", {
  results <- dashboard_test_results()
  results <- results[results$cv_scheme == "near_prediction", , drop = FALSE] # single scheme: isolates these checks from the cv_scheme guard
  expect_error(dashboard_relative_metric(results, baseline_estimator = "ols", metric = "not_a_metric"), "Metrique")
  expect_error(dashboard_relative_metric(results, baseline_estimator = "not_an_estimator", metric = "rmse"), "reference")
})

test_that("dashboard_estimator_families() joins present estimators with their taxonomy family and dashboard_group, falling back to 'other'/'Other'", {
  results <- dashboard_test_results()
  fam <- dashboard_estimator_families(results)
  expect_setequal(fam$estimator, c("ols", "sar_lag"))
  expect_true(all(!is.na(fam$family)))
  expect_true(all(nzchar(fam$family)))
  expect_true(all(!is.na(fam$dashboard_group)))
  # family and dashboard_group are allowed to disagree (e.g. a SAR boosting
  # variant's dashboard_group is "Boosting", not "SAR") -- this suite's
  # sar_lag is a reference estimator so they happen to align, but the
  # columns must exist and be independently populated regardless.
  expect_equal(fam$dashboard_group[fam$estimator == "ols"], "Baselines")
  expect_equal(fam$dashboard_group[fam$estimator == "sar_lag"], "Spatial Econometrics")

  results$estimator[results$estimator == "sar_lag"] <- "made_up_estimator_xyz"
  fam2 <- dashboard_estimator_families(results)
  expect_equal(fam2$family[fam2$estimator == "made_up_estimator_xyz"], "other")
  expect_equal(fam2$dashboard_group[fam2$estimator == "made_up_estimator_xyz"], "Other")
})

test_that("dashboard_estimator_families() reflects a scientific-family/dashboard-group divergence for boosting variants", {
  registry <- tryCatch(available_benchmark_estimators(include_installed = FALSE), error = function(e) NULL)
  skip_if(is.null(registry), "estimator registry not available in this environment")
  skip_if_not("spboost_bspa_sar_ml" %in% registry$estimator, "spboost_bspa_sar_ml not present in this registry snapshot")

  results <- data.frame(
    dataset = "ds_a", cv_scheme = "near_prediction", estimator = "spboost_bspa_sar_ml",
    rmse = 1, stringsAsFactors = FALSE
  )
  fam <- dashboard_estimator_families(results)
  expect_equal(fam$family, "SAR")
  expect_equal(fam$dashboard_group, "Boosting")
})

test_that("dashboard_metric_by_estimator() aggregates per estimator over finite values only", {
  results <- dashboard_test_results()
  agg <- dashboard_metric_by_estimator(results, "rmse", cv_scheme = "near_prediction")
  expect_setequal(agg$estimator, c("ols", "sar_lag"))
  ols_rmse <- results$rmse[results$estimator == "ols" & results$cv_scheme == "near_prediction"]
  expect_equal(agg$value[agg$estimator == "ols"], stats::median(ols_rmse))

  results$rmse[results$estimator == "sar_lag"] <- NA_real_
  agg_na <- dashboard_metric_by_estimator(results, "rmse", cv_scheme = "near_prediction")
  expect_true(is.na(agg_na$value[agg_na$estimator == "sar_lag"]))

  expect_error(dashboard_metric_by_estimator(results, "not_a_metric", cv_scheme = "near_prediction"), "Metrique")
})

test_that("dashboard_relative_metric_wide() pivots to dataset x estimator with a baseline column of 1s and a Median summary row by default", {
  results <- dashboard_test_results()
  wide <- dashboard_relative_metric_wide(results, baseline_estimator = "ols", metric = "rmse", cv_scheme = "near_prediction")

  expect_true(all(c("dataset", "ols", "sar_lag") %in% names(wide)))
  expect_equal(names(wide)[[2]], "ols") # baseline column first
  expect_true(all(wide$ols[wide$dataset != "Median (all datasets)"] == 1))
  expect_true("Median (all datasets)" %in% wide$dataset)

  median_row <- wide[wide$dataset == "Median (all datasets)", ]
  ds_rows <- wide[wide$dataset != "Median (all datasets)", ]
  expect_equal(median_row$sar_lag, stats::median(ds_rows$sar_lag, na.rm = TRUE), tolerance = 1e-8)
})

test_that("dashboard_relative_metric_wide() still supports an explicit mean summary row or none at all", {
  results <- dashboard_test_results()
  wide_mean <- dashboard_relative_metric_wide(results, baseline_estimator = "ols", metric = "rmse", cv_scheme = "near_prediction", summary_row = "mean")
  expect_true("Average (all datasets)" %in% wide_mean$dataset)
  avg_row <- wide_mean[wide_mean$dataset == "Average (all datasets)", ]
  ds_rows <- wide_mean[wide_mean$dataset != "Average (all datasets)", ]
  expect_equal(avg_row$sar_lag, mean(ds_rows$sar_lag, na.rm = TRUE), tolerance = 1e-8)

  wide_none <- dashboard_relative_metric_wide(results, baseline_estimator = "ols", metric = "rmse", cv_scheme = "near_prediction", summary_row = "none")
  expect_false(any(grepl("all datasets", wide_none$dataset)))
})

test_that("dashboard_failure_summary() falls back to fit_error counting when fold info is absent, keeping zero-failure estimators", {
  results <- dashboard_test_results()
  results$fit_error[results$estimator == "ols" & results$dataset == "ds_a"] <- "boom" # both ds_a/ols rows (both cv_schemes)

  summary <- dashboard_failure_summary(results, cv_scheme = "near_prediction")
  expect_setequal(summary$estimator, c("ols", "sar_lag"))

  sar_row <- summary[summary$estimator == "sar_lag", ]
  expect_equal(sar_row$n_failed, 0L)
  expect_equal(sar_row$failure_rate, 0)

  # Only the near_prediction ols/ds_a row is in scope once cv_scheme is
  # fixed -- the holdout_10pct ols/ds_a row (also marked failed above) is
  # correctly excluded, not pooled in.
  ols_row <- summary[summary$estimator == "ols", ]
  expect_equal(ols_row$n_failed, 1L)
  expect_true(ols_row$failure_rate > 0)
  expect_true(ols_row$datasets_affected >= 1L)
})

test_that("dashboard_failure_summary() uses fold-level rates when n_resamples/n_failed_resamples are present", {
  results <- dashboard_test_results()
  results$n_resamples <- 5L
  results$n_failed_resamples <- 0L
  results$n_failed_resamples[results$estimator == "sar_lag" & results$dataset == "ds_b"] <- 2L

  summary <- dashboard_failure_summary(results, cv_scheme = "near_prediction")
  sar_row <- summary[summary$estimator == "sar_lag", ]
  expect_true(sar_row$n_failed > 0L)
  expect_true(sar_row$worst_case_failure_rate > 0)

  ols_row <- summary[summary$estimator == "ols", ]
  expect_equal(ols_row$n_failed, 0L)
  expect_equal(ols_row$failure_rate, 0)
})

test_that("dashboard_n_tertile_groups() buckets datasets by n into tertiles when enough real data exists", {
  meta <- data.frame(
    dataset = paste0("ds_", 1:9),
    n = c(10, 12, 15, 100, 110, 120, 1000, 1100, 1200),
    stringsAsFactors = FALSE
  )
  groups <- dashboard_n_tertile_groups(meta)
  expect_false(is.null(groups))
  expect_setequal(names(groups), c("dataset", "n_tertile"))
  expect_setequal(unique(groups$n_tertile), c("small", "medium", "large"))
  expect_equal(groups$n_tertile[groups$dataset == "ds_1"], "small")
  expect_equal(groups$n_tertile[groups$dataset == "ds_9"], "large")
})

test_that("dashboard_n_tertile_groups() returns NULL rather than fabricating buckets when data is insufficient", {
  # Too few datasets with a known n.
  few <- data.frame(dataset = c("a", "b", "c"), n = c(10, 100, 1000), stringsAsFactors = FALSE)
  expect_null(dashboard_n_tertile_groups(few))

  # Enough datasets, but n is missing entirely (all NA) or identical.
  all_na <- data.frame(dataset = paste0("ds_", 1:10), n = NA_integer_, stringsAsFactors = FALSE)
  expect_null(dashboard_n_tertile_groups(all_na))

  identical_n <- data.frame(dataset = paste0("ds_", 1:10), n = 50L, stringsAsFactors = FALSE)
  expect_null(dashboard_n_tertile_groups(identical_n))

  # No `n` column at all.
  expect_null(dashboard_n_tertile_groups(data.frame(dataset = "a", stringsAsFactors = FALSE)))
  expect_null(dashboard_n_tertile_groups(NULL))
})

test_that("a dataset with a tiny Y scale can no longer artificially determine the 'best RMSE' champion", {
  # 'tiny': Y is on a tiny scale, so BOTH estimators' raw RMSE are far smaller
  # than on any other dataset -- but the candidate is relatively WORSE there
  # (2x the baseline's error). 'mid1'/'mid2': normal scale, candidate is
  # relatively better (0.6x, 0.7x). A raw-magnitude champion would pick
  # tiny's tiny numbers regardless of which estimator is actually better;
  # the relative, per-dataset-normalized champion must not.
  results <- data.frame(
    dataset = c("tiny", "tiny", "mid1", "mid1", "mid2", "mid2"),
    cv_scheme = "near_prediction",
    estimator = c("ols", "cand", "ols", "cand", "ols", "cand"),
    rmse = c(0.001, 0.002, 10, 6, 10, 7),
    stringsAsFactors = FALSE
  )

  # This is exactly what the old, now-removed behaviour would have done:
  # min(raw rmse) picks the "tiny" dataset's ols row purely because its Y
  # scale is small, regardless of relative performance.
  naive_champion <- dashboard_kpis(results, metrics = "rmse")
  expect_equal(naive_champion$dataset, "tiny")

  # The corrected KPI must pick based on median relative performance across
  # datasets instead, and must correctly identify "cand" as the better
  # performer overall (relatively better on 2 of 3 datasets), not "ols".
  best <- dashboard_best_relative_estimator(results, baseline_estimator = "ols", metric = "rmse")
  expect_equal(best$estimator, "cand")
  expect_equal(best$value, stats::median(c(2.0, 0.6, 0.7)))
  expect_equal(best$n_datasets, 3L)
})

test_that("dashboard_relative_metric_by_estimator() aggregates the per-dataset ratio via median, ordered best-first", {
  results <- data.frame(
    dataset = rep(c("ds_a", "ds_b", "ds_c"), each = 2),
    cv_scheme = "near_prediction",
    estimator = rep(c("ols", "cand"), 3),
    rmse = c(2, 1, 2, 1.5, 2, 3), # cand relative: 0.5, 0.75, 1.5
    stringsAsFactors = FALSE
  )
  agg <- dashboard_relative_metric_by_estimator(results, baseline_estimator = "ols", metric = "rmse")
  expect_equal(agg$estimator[[1]], "cand") # best-first: median 0.75 < ols's 1.0
  cand_row <- agg[agg$estimator == "cand", ]
  expect_equal(cand_row$median_relative, stats::median(c(0.5, 0.75, 1.5)))
  expect_equal(cand_row$n_datasets, 3L)
})

test_that("dashboard_residual_spatial_dependence() applies |I - E(I)| only for single-evaluation cv_schemes, else falls back to moran_abs", {
  results <- data.frame(
    dataset = c("ds_a", "ds_b", "ds_c", "ds_d"),
    cv_scheme = "holdout_10pct",
    estimator = "ols",
    n = c(21, 21, 21, NA_real_),
    n_resamples = c(1L, 3L, 1L, 1L), # ds_b: multi-eval -> not statistically consistent with pooled n
    moran_i = c(-0.05, -0.05, NA_real_, 0.1),
    moran_abs = c(0.05, 0.05, NA_real_, 0.1),
    stringsAsFactors = FALSE
  )
  out <- dashboard_residual_spatial_dependence(results)

  # ds_a: n_resamples == 1, n and moran_i available -> corrected.
  expected_EI <- -1 / (21 - 1)
  row_a <- out[out$dataset == "ds_a", ]
  expect_equal(row_a$residual_spatial_dependence_method, "corrected")
  expect_equal(row_a$residual_spatial_dependence, abs(-0.05 - expected_EI))

  # ds_b: n_resamples > 1 -> the aggregated n/moran_i don't describe the same
  # test set, so it must fall back to moran_abs, not use E(I).
  row_b <- out[out$dataset == "ds_b", ]
  expect_equal(row_b$residual_spatial_dependence_method, "moran_abs_fallback")
  expect_equal(row_b$residual_spatial_dependence, 0.05)

  # ds_c: moran_i is NA -> falls back to moran_abs.
  row_c <- out[out$dataset == "ds_c", ]
  expect_true(is.na(row_c$residual_spatial_dependence))

  # ds_d: n is NA -> can't compute E(I), falls back to moran_abs.
  row_d <- out[out$dataset == "ds_d", ]
  expect_equal(row_d$residual_spatial_dependence_method, "moran_abs_fallback")
  expect_equal(row_d$residual_spatial_dependence, 0.1)
})

test_that("dashboard_residual_spatial_dependence() falls back to moran_abs entirely when n/n_resamples are unavailable", {
  results <- data.frame(
    dataset = "ds_a", cv_scheme = "near_prediction", estimator = "ols",
    moran_i = -0.2, moran_abs = 0.2, stringsAsFactors = FALSE
  )
  out <- dashboard_residual_spatial_dependence(results)
  expect_equal(out$residual_spatial_dependence, 0.2)
  expect_equal(out$residual_spatial_dependence_method, "moran_abs_fallback")

  no_moran <- data.frame(dataset = "ds_a", cv_scheme = "near_prediction", estimator = "ols", rmse = 1, stringsAsFactors = FALSE)
  out_none <- dashboard_residual_spatial_dependence(no_moran)
  expect_true(is.na(out_none$residual_spatial_dependence))
  expect_true(is.na(out_none$residual_spatial_dependence_method))
})

test_that("dashboard_task_source_counts() treats unregistered dataset names as their own independent task and source", {
  counts <- dashboard_task_source_counts(c("made_up_a", "made_up_b", "made_up_c"))
  expect_equal(counts$n_benchmark_tasks, 3L)
  expect_equal(counts$n_independent_sources, 3L)
  expect_equal(sort(counts$table$source_dataset_id), sort(c("made_up_a", "made_up_b", "made_up_c")))
})

test_that("dashboard_task_source_counts() reads a spatial_benchmark_suite's own dataset_metadata rather than rebuilding it", {
  make_data <- function(seed) {
    set.seed(seed)
    n <- 12L
    data.frame(y = seq_len(n) / n, x1 = seq_len(n), x_coord = seq_len(n), y_coord = seq_len(n))
  }
  specs <- list(
    spatial_dataset_spec("suite_ds_a", make_data(1), y ~ x1, c("x_coord", "y_coord")),
    spatial_dataset_spec("suite_ds_b", make_data(2), y ~ x1, c("x_coord", "y_coord"))
  )
  suite <- benchmark_spatial_suite(
    datasets = specs, estimators = "ols", cv_schemes = "near_prediction",
    near_n_reps = 2L, near_test_size = 2L, seed = 1L
  )
  expect_false(is.null(suite$dataset_metadata))

  counts <- dashboard_task_source_counts(suite)
  expect_equal(counts$n_benchmark_tasks, 2L)
  expect_equal(counts$n_independent_sources, 2L) # ad hoc datasets: each its own source
})

test_that("dashboard_task_source_counts() collapses a real split-dataset family (korea_hedonic_housing) to one independent source", {
  registry <- tryCatch(benchmark_dataset_registry(), error = function(e) NULL)
  korea <- registry$dataset[grepl("korea_hedonic_housing", registry$dataset)]
  skip_if(is.null(registry) || length(korea) == 0L, "korea_hedonic_housing family not present in this registry snapshot")

  counts <- dashboard_task_source_counts(korea)
  expect_equal(counts$n_benchmark_tasks, length(korea)) # every split is its own benchmark task
  expect_equal(counts$n_independent_sources, 1L) # but they are all ONE independent source
})

test_that("dashboard data functions run end-to-end on a real (tiny) benchmark_spatial_suite()", {
  make_data <- function(seed, scale) {
    set.seed(seed)
    n <- 24L
    x_coord <- rep(seq_len(6), each = 4)[seq_len(n)]
    y_coord <- rep(seq_len(4), times = 6)[seq_len(n)]
    x1 <- seq_len(n) / n
    x2 <- as.integer(x_coord > stats::median(x_coord))
    y <- 1 + scale * (2 * x1 - 0.3 * x2 + 0.05 * x_coord + 0.03 * y_coord)
    data.frame(y = y, x1 = x1, x2 = x2, x_coord = x_coord, y_coord = y_coord)
  }
  specs <- list(
    spatial_dataset_spec("synth_a", make_data(1, 1), y ~ x1 + x2, c("x_coord", "y_coord")),
    spatial_dataset_spec("synth_b", make_data(2, 1.5), y ~ x1 + x2, c("x_coord", "y_coord"))
  )
  suite <- benchmark_spatial_suite(
    datasets = specs,
    estimators = c("ols", "sar_lag"),
    cv_schemes = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L,
    seed = 1L
  )

  kpis <- dashboard_kpis(suite)
  expect_equal(nrow(kpis), 4L)
  expect_true(all(is.finite(kpis$value)))

  rel <- dashboard_relative_metric(suite, baseline_estimator = "ols", metric = "rmse")
  expect_true(all(c("ols", "sar_lag") %in% rel$estimator))
  ols_rows <- rel[rel$estimator == "ols", ]
  expect_true(all(abs(ols_rows$relative - 1) < 1e-8))

  fs <- dashboard_failure_summary(suite)
  expect_setequal(fs$estimator, c("ols", "sar_lag"))
  expect_true(all(fs$failure_rate == 0)) # no failures expected in this fixture
})

test_that("dashboard_relative_metric_by_scheme() computes each scheme independently, never pooling cases across them", {
  results <- dashboard_test_results()
  by_scheme <- dashboard_relative_metric_by_scheme(results, baseline_estimator = "ols", metric = "rmse")

  expect_setequal(unique(by_scheme$cv_scheme), c("near_prediction", "holdout_10pct"))
  sar_near <- by_scheme[by_scheme$cv_scheme == "near_prediction" & by_scheme$estimator == "sar_lag", ]
  sar_holdout <- by_scheme[by_scheme$cv_scheme == "holdout_10pct" & by_scheme$estimator == "sar_lag", ]
  expect_equal(sar_near$median_relative, stats::median(c(1.0 / 2.0, 2.0 / 3.0)))
  expect_equal(sar_holdout$median_relative, stats::median(c(1.2 / 2.2, 2.2 / 3.2)))
  # The two schemes' numbers for the SAME estimator must differ -- if they
  # were silently pooled into one figure, this fixture's values would
  # collapse to a single shared number instead.
  expect_false(isTRUE(all.equal(sar_near$median_relative, sar_holdout$median_relative)))

  # Restricting to a single named scheme returns only that scheme's rows.
  only_near <- dashboard_relative_metric_by_scheme(results, baseline_estimator = "ols", metric = "rmse", cv_schemes = "near_prediction")
  expect_equal(unique(only_near$cv_scheme), "near_prediction")
})

test_that("dashboard_relative_metric_by_scheme() skips a requested scheme that has no valid cases instead of erroring", {
  results <- dashboard_test_results()
  out <- dashboard_relative_metric_by_scheme(
    results, baseline_estimator = "ols", metric = "rmse",
    cv_schemes = c("near_prediction", "block_spatial") # block_spatial isn't in this fixture
  )
  expect_setequal(unique(out$cv_scheme), "near_prediction")
})

test_that("dashboard_failure_summary_by_scheme() keeps failures separate per CV scheme", {
  results <- dashboard_test_results()
  results$fit_error[results$estimator == "sar_lag" & results$dataset == "ds_a" & results$cv_scheme == "holdout_10pct"] <- "boom"

  by_scheme <- dashboard_failure_summary_by_scheme(results)
  near_sar <- by_scheme[by_scheme$cv_scheme == "near_prediction" & by_scheme$estimator == "sar_lag", ]
  holdout_sar <- by_scheme[by_scheme$cv_scheme == "holdout_10pct" & by_scheme$estimator == "sar_lag", ]
  expect_equal(near_sar$n_failed, 0L) # the failure was only injected into holdout_10pct
  expect_true(holdout_sar$n_failed > 0L)
})

# launch_benchmark_dashboard() and the Overview module's reactive wiring are
# covered in test-dashboard-app.R, alongside the orchestrator/module split
# introduced in R/19-dashboard-app.R.
