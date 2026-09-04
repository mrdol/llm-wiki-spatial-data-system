# fold_timeout_sec / run_with_fold_timeout() (26-fold-timeout-worker.R).
#
# These tests spawn a real callr subprocess (package load + optional custom
# estimator replication), so each one costs several seconds -- kept to a
# minimal, targeted set rather than exercised through the full
# benchmark_spatial_suite() resampling machinery.

fold_timeout_test_data <- function(n = 20L, seed = 1L) {
  set.seed(seed)
  x_coord <- rep(seq_len(5), each = 4)[seq_len(n)]
  y_coord <- rep(seq_len(4), times = 5)[seq_len(n)]
  x1 <- seq_len(n) / n
  data.frame(y = 1 + 2 * x1 + 0.01 * x_coord, x1 = x1, x_coord = x_coord, y_coord = y_coord)
}

fold_timeout_test_split <- function(data, test_size = 4L) {
  test_idx <- seq_len(test_size)
  rsample::make_splits(
    x = list(analysis = setdiff(seq_len(nrow(data)), test_idx), assessment = test_idx),
    data = data
  )
}

fold_timeout_test_params <- function() {
  list(
    k_neighbors = 4, style = "W", zero_policy = TRUE,
    spboost_mstop = 100L, spboost_nu = 0.1, gamboost_mstop = 100L, gamboost_nu = 0.1,
    mgwrsar_bandwidth = 20, mgwrsar_kernel = "gauss", mgwrsar_fixed_vars = NULL,
    spmoran_enum = NULL, spmoran_vif = 10,
    spatialml_bandwidth = 20L, spatialml_ntree = 100L, spatialml_mtry = NULL,
    spatialrf_ntree = 100L, spatialrf_method = "hengl", spatialrf_mtry = NULL,
    spatialrf_min_node_size = NULL, spatialrf_max_spatial_predictors = NULL,
    rfgls_ntree = 50L, rfgls_mtry = NULL, rfgls_n_neighbors = NULL, rfgls_nthsize = 20L,
    rfgls_cov_model = "exponential", rfgls_param_estimate = FALSE
  )
}

test_that("run_with_fold_timeout() runs a normal case successfully in the worker", {
  skip_if_not_installed("callr")
  skip_if_not_installed("pkgload")

  data <- fold_timeout_test_data()
  split <- fold_timeout_test_split(data)
  session_box <- new.env(parent = emptyenv())
  session_box$session <- NULL
  on.exit(close_fold_timeout_worker(session_box), add = TRUE)

  outcome <- run_with_fold_timeout(
    session_box, 60,
    score_benchmark_fold,
    args = list(
      estimator = "ols", fold_id = "fold1", split = split,
      formula = y ~ x1, coords = c("x_coord", "y_coord"), params = fold_timeout_test_params()
    )
  )

  expect_true(outcome$ok)
  expect_s3_class(outcome$value, "data.frame")
  expect_true(is.na(outcome$value$fit_error[[1]]))
  expect_true(is.finite(outcome$value$rmse[[1]]))
})

test_that("run_with_fold_timeout() kills a genuinely stuck case and reports TIMEOUT", {
  skip_if_not_installed("callr")
  skip_if_not_installed("pkgload")
  on.exit(unregister_spatial_estimator("fold_timeout_test_stuck"), add = TRUE)
  register_spatial_estimator(
    id = "fold_timeout_test_stuck",
    fit = function(formula, data, coords) {
      # Uninterruptible-by-setTimeLimit() tight loop: this is the shape of
      # computation the worker/kill approach exists for (confirmed
      # empirically against the real pathology that motivated it --
      # setTimeLimit() never interrupted it, even 40s+ past a 3s budget).
      x <- 0
      repeat { x <- x * 1.0000001 + 1; if (x > 1e300) break }
      stats::lm(formula, data = data)
    },
    predict = function(fit, new_data) stats::predict(fit, newdata = new_data),
    requires_coords = FALSE,
    overwrite = TRUE
  )

  data <- fold_timeout_test_data()
  split <- fold_timeout_test_split(data)
  session_box <- new.env(parent = emptyenv())
  session_box$session <- NULL
  on.exit(close_fold_timeout_worker(session_box), add = TRUE)

  outcome <- run_with_fold_timeout(
    session_box, 2,
    score_benchmark_fold,
    args = list(
      estimator = "fold_timeout_test_stuck", fold_id = "fold1", split = split,
      formula = y ~ x1, coords = c("x_coord", "y_coord"), params = fold_timeout_test_params()
    )
  )

  expect_false(outcome$ok)
  expect_true(isTRUE(outcome$timeout))
  expect_match(outcome$error_message, "^TIMEOUT:")
  # The worker was killed and dropped -- a fresh one is spawned on next use.
  expect_null(session_box$session)
})

test_that("benchmark_spatial_suite() with fold_timeout_sec = NA never spawns a worker (default, zero overhead)", {
  # Sanity check that leaving the guard off is identical to the code path
  # before it existed -- no callr dependency needed for this one.
  suite <- benchmark_spatial_suite(
    datasets = list(spatial_dataset_spec(
      "synth", fold_timeout_test_data(), y ~ x1, c("x_coord", "y_coord")
    )),
    estimators = "ols",
    cv_schemes = "near_prediction",
    near_n_reps = 1L, near_test_size = 4L, seed = 1L
  )
  expect_true(all(is.na(suite$results$fit_error)))
})
