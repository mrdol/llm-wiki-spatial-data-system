dummy_fit <- function(formula, data, coords) stats::lm(formula, data = data)
dummy_predict <- function(fit, new_data) stats::predict(fit, newdata = new_data)

# Local, self-contained synthetic data -- does not rely on the
# make_tiny_spatial_data() helper defined in test-workflows.R, since
# testthat sources test files in alphabetical order and this file runs
# before that one.
registration_test_data <- function(n = 28L) {
  set.seed(42)
  x_coord <- rep(seq_len(7), each = 4)[seq_len(n)]
  y_coord <- rep(seq_len(4), times = 7)[seq_len(n)]
  x1 <- seq_len(n) / n
  x2 <- as.integer(x_coord > stats::median(x_coord))
  y <- 1 + 2 * x1 - 0.3 * x2 + 0.05 * x_coord + 0.03 * y_coord
  data.frame(y = y, x1 = x1, x2 = x2, x_coord = x_coord, y_coord = y_coord)
}

test_that("register_spatial_estimator() adds the estimator to the registries", {
  on.exit(unregister_spatial_estimator("my_dummy_ols"), add = TRUE)

  register_spatial_estimator(
    id = "my_dummy_ols",
    fit = dummy_fit,
    predict = dummy_predict,
    family = "baseline",
    reference_estimator = "ols",
    requires_coords = FALSE,
    notes = "test dummy"
  )

  custom <- registered_spatial_estimators()
  expect_true("my_dummy_ols" %in% custom$estimator)

  registry <- available_benchmark_estimators(include_installed = FALSE)
  expect_true("my_dummy_ols" %in% registry$estimator)
  row <- registry[registry$estimator == "my_dummy_ols", , drop = FALSE]
  expect_true(row$automatic)
  expect_equal(row$family, "baseline")
  expect_equal(row$reference_estimator, "ols")
})

test_that("register_spatial_estimator() rejects a name colliding with a built-in estimator", {
  expect_error(
    register_spatial_estimator("ols", fit = dummy_fit, predict = dummy_predict),
    "deja le nom"
  )
})

test_that("register_spatial_estimator() rejects re-registration without overwrite", {
  on.exit(unregister_spatial_estimator("my_dummy_dup"), add = TRUE)
  register_spatial_estimator("my_dummy_dup", fit = dummy_fit, predict = dummy_predict)
  expect_error(
    register_spatial_estimator("my_dummy_dup", fit = dummy_fit, predict = dummy_predict),
    "deja enregistre"
  )
  expect_silent(
    register_spatial_estimator("my_dummy_dup", fit = dummy_fit, predict = dummy_predict, overwrite = TRUE)
  )
})

test_that("register_spatial_estimator() validates fit/predict signatures", {
  expect_error(
    register_spatial_estimator("bad_fit", fit = function(x) x, predict = dummy_predict),
    "formula, data, coords"
  )
  expect_error(
    register_spatial_estimator("bad_predict", fit = dummy_fit, predict = function(x) x),
    "function\\(fit, new_data\\)"
  )
})

test_that("unregister_spatial_estimator() removes the estimator and reverts benchmark_spatial() behaviour", {
  register_spatial_estimator("my_dummy_removable", fit = dummy_fit, predict = dummy_predict)
  expect_true("my_dummy_removable" %in% registered_spatial_estimators()$estimator)
  unregister_spatial_estimator("my_dummy_removable")
  expect_false("my_dummy_removable" %in% registered_spatial_estimators()$estimator)
  expect_false("my_dummy_removable" %in% available_benchmark_estimators(include_installed = FALSE)$estimator)
})

test_that("a registered estimator runs end-to-end through benchmark_spatial()", {
  on.exit(unregister_spatial_estimator("my_dummy_ols"), add = TRUE)
  register_spatial_estimator(
    id = "my_dummy_ols",
    fit = dummy_fit,
    predict = dummy_predict,
    requires_coords = FALSE
  )

  dat <- registration_test_data()
  bench <- benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = c("ols", "my_dummy_ols")
  )

  expect_s3_class(bench, "spatial_benchmark")
  row <- bench$results[bench$results$estimator == "my_dummy_ols", , drop = FALSE]
  expect_equal(nrow(row), 1L)
  expect_true(is.na(row$fit_error) || !nzchar(row$fit_error))
  expect_true(is.finite(row$rmse))
  # A plain lm() on the same formula/data as the built-in OLS route should be
  # numerically identical.
  ols_row <- bench$results[bench$results$estimator == "ols", , drop = FALSE]
  expect_equal(row$rmse, ols_row$rmse, tolerance = 1e-6)
})

test_that("a registered estimator can be compared to a built-in reference via compare_estimator_variant()", {
  on.exit(unregister_spatial_estimator("my_dummy_ols"), add = TRUE)
  register_spatial_estimator(
    id = "my_dummy_ols",
    fit = dummy_fit,
    predict = dummy_predict,
    requires_coords = FALSE
  )

  results <- rbind(
    data.frame(
      dataset = paste0("ds_", 1:12), cv_scheme = "near_prediction",
      estimator = "ols", rmse = 10 + stats::runif(12, -1, 1), stringsAsFactors = FALSE
    ),
    data.frame(
      dataset = paste0("ds_", 1:12), cv_scheme = "near_prediction",
      estimator = "my_dummy_ols", rmse = 9 + stats::runif(12, -1, 1), stringsAsFactors = FALSE
    )
  )
  cmp <- compare_estimator_variant(
    results,
    reference = "ols", candidate = "my_dummy_ols",
    secondary_metrics = character(0)
  )
  expect_s3_class(cmp, "estimator_comparison")
  expect_equal(cmp$summary$n_cases, 12L)
})
