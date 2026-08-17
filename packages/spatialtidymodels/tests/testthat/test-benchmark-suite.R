# End-to-end tests for benchmark_spatial_suite() -- kept fast (tiny synthetic
# datasets, near_n_reps = 2 / near_test_size = 4, no tuning) since this
# exercises the real modelling stack (ols, sar_lag), not synthetic result
# tables like test-comparison.R does.

suite_test_data <- function(n = 24L, seed = 1L, scale = 1) {
  set.seed(seed)
  x_coord <- rep(seq_len(6), each = 4)[seq_len(n)]
  y_coord <- rep(seq_len(4), times = 6)[seq_len(n)]
  x1 <- seq_len(n) / n
  x2 <- as.integer(x_coord > stats::median(x_coord))
  y <- 1 + scale * (2 * x1 - 0.3 * x2 + 0.05 * x_coord + 0.03 * y_coord)
  data.frame(y = y, x1 = x1, x2 = x2, x_coord = x_coord, y_coord = y_coord)
}

two_synthetic_specs <- function() {
  list(
    spatial_dataset_spec("synth_a", suite_test_data(seed = 1, scale = 1), y ~ x1 + x2, c("x_coord", "y_coord")),
    spatial_dataset_spec("synth_b", suite_test_data(seed = 2, scale = 1.5), y ~ x1 + x2, c("x_coord", "y_coord"))
  )
}

test_that("benchmark_spatial_suite() runs on 2 synthetic datasets x 2 estimators x 1 cv_scheme with well-formed output", {
  suite <- benchmark_spatial_suite(
    datasets = two_synthetic_specs(),
    estimators = c("ols", "sar_lag"),
    cv_schemes = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L,
    seed = 1L
  )

  expect_s3_class(suite, "spatial_benchmark_suite")
  expect_setequal(suite$datasets, c("synth_a", "synth_b"))
  expect_equal(suite$estimators, c("ols", "sar_lag"))
  expect_equal(suite$cv_schemes, "near_prediction")

  # results: dataset x estimator x cv_scheme -> 2 x 2 x 1 = 4 rows
  expect_equal(nrow(suite$results), 4L)
  expect_true(all(c("dataset", "cv_scheme", "estimator", "rmse", "mae", "fit_error") %in% names(suite$results)))
  expect_setequal(suite$results$dataset, c("synth_a", "synth_b"))
  expect_setequal(suite$results$estimator, c("ols", "sar_lag"))
  expect_true(all(suite$results$cv_scheme == "near_prediction"))
  expect_true(all(is.na(suite$results$fit_error)))
  expect_true(all(is.finite(suite$results$rmse)))

  # resample_results: dataset x estimator x cv_scheme x fold
  expect_false(is.null(suite$resample_results))
  expect_true(all(c("dataset", "cv_scheme", "estimator", "id", "rmse") %in% names(suite$resample_results)))
  expect_setequal(suite$resample_results$dataset, c("synth_a", "synth_b"))
  expect_true(nrow(suite$resample_results) >= nrow(suite$results)) # at least one fold per row

  expect_equal(nrow(suite$failures), 0L)
  expect_output(print(suite), "Benchmark spatial suite")
})

test_that("benchmark_spatial_suite() keeps multiple cv_schemes distinct rather than mixing them", {
  suite <- benchmark_spatial_suite(
    datasets = two_synthetic_specs(),
    estimators = "ols",
    cv_schemes = c("near_prediction", "holdout_10pct"),
    near_n_reps = 2L,
    near_test_size = 4L,
    seed = 1L
  )

  expect_setequal(suite$cv_schemes, c("near_prediction", "holdout_10pct"))
  # dataset x estimator x cv_scheme -> 2 x 1 x 2 = 4 rows
  expect_equal(nrow(suite$results), 4L)
  expect_setequal(suite$results$cv_scheme, c("near_prediction", "holdout_10pct"))
  expect_equal(sum(suite$results$cv_scheme == "near_prediction"), 2L)
  expect_equal(sum(suite$results$cv_scheme == "holdout_10pct"), 2L)
  expect_setequal(unique(suite$resample_results$cv_scheme), c("near_prediction", "holdout_10pct"))
  expect_named(suite$benchmarks, c("near_prediction", "holdout_10pct"))
})

test_that("benchmark_spatial_suite() propagates errors instead of swallowing them", {
  expect_error(
    benchmark_spatial_suite(
      datasets = two_synthetic_specs(),
      estimators = "does_not_exist",
      cv_schemes = "near_prediction"
    ),
    "Estimateur"
  )
  expect_error(
    benchmark_spatial_suite(
      datasets = two_synthetic_specs(),
      estimators = "ols",
      cv_schemes = "not_a_real_cv_scheme"
    )
  )
  expect_error(
    benchmark_spatial_suite(
      datasets = two_synthetic_specs(),
      estimators = "ols",
      cv_schemes = character(0)
    ),
    "cv_schemes"
  )
})

test_that("benchmark_spatial_suite() is reproducible given the same seed", {
  run <- function() {
    benchmark_spatial_suite(
      datasets = two_synthetic_specs(),
      estimators = c("ols", "sar_lag"),
      cv_schemes = "near_prediction",
      near_n_reps = 2L,
      near_test_size = 4L,
      seed = 42L
    )
  }
  suite1 <- run()
  suite2 <- run()

  ord <- order(suite1$results$dataset, suite1$results$estimator)
  ord2 <- order(suite2$results$dataset, suite2$results$estimator)
  expect_equal(suite1$results$rmse[ord], suite2$results$rmse[ord2])
  expect_equal(suite1$results$mae[ord], suite2$results$mae[ord2])
})

test_that("benchmark_spatial_suite() accepts registered dataset names directly, not just specs", {
  skip_if_not(nzchar(system.file("metadata", "datasets.json", package = "spatialtidymodels")))
  registry <- tryCatch(available_benchmark_datasets(), error = function(e) NULL)
  skip_if(is.null(registry) || !all(c("columbus_crime", "georgia") %in% registry$dataset),
          "columbus_crime/georgia not resolvable in this registry")

  suite <- tryCatch(
    benchmark_spatial_suite(
      datasets = c("columbus_crime", "georgia"),
      estimators = "ols",
      cv_schemes = "near_prediction",
      near_n_reps = 2L,
      near_test_size = 4L,
      seed = 1L
    ),
    error = function(e) e
  )
  if (inherits(suite, "error")) {
    skip(paste("dataset files not resolvable in this environment:", conditionMessage(suite)))
  }

  expect_setequal(suite$datasets, c("columbus_crime", "georgia"))
  expect_setequal(suite$results$dataset, c("columbus_crime", "georgia"))
})

test_that("benchmark_spatial_suite() works with an estimator registered via register_spatial_estimator()", {
  on.exit(unregister_spatial_estimator("suite_dummy_ols"), add = TRUE)
  register_spatial_estimator(
    id = "suite_dummy_ols",
    fit = function(formula, data, coords) stats::lm(formula, data = data),
    predict = function(fit, new_data) stats::predict(fit, newdata = new_data),
    requires_coords = FALSE
  )

  suite <- benchmark_spatial_suite(
    datasets = two_synthetic_specs(),
    estimators = c("ols", "suite_dummy_ols"),
    cv_schemes = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L,
    seed = 1L
  )

  expect_setequal(suite$results$estimator, c("ols", "suite_dummy_ols"))
  dummy_rows <- suite$results[suite$results$estimator == "suite_dummy_ols", , drop = FALSE]
  expect_true(all(is.na(dummy_rows$fit_error)))
  expect_true(all(is.finite(dummy_rows$rmse)))

  # A registered estimator plugs straight into the comparison engine too.
  cmp <- compare_estimator_variant(
    suite,
    reference = "ols", candidate = "suite_dummy_ols",
    secondary_metrics = character(0),
    rules = comparison_rules(min_cases_for_verdict = 2L)
  )
  expect_s3_class(cmp, "estimator_comparison")
  expect_equal(cmp$summary$n_cases, 2L)
})
