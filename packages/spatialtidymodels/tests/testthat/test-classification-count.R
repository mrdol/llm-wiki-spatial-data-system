# Tests for binary (classification) and count (Poisson) response routing,
# added 2026-09 alongside the new spatial probit estimator (sar_probit/
# sem_probit, ProbitSpatial::ProbitSpatialFit()) and the Tier-1 family/mode
# routing added to ols/gam_spatial/random_forest/xgboost in
# fit_one_benchmark_estimator() (R/13-benchmark-spatial.R). Kept fast (tiny
# synthetic datasets), same convention as test-benchmark-suite.R.

# Grille robuste a n'importe quel n (contrairement a rep(...)[seq_len(n)] avec
# une grille de taille fixe, qui produit des NA des que n depasse la grille).
grid_coords <- function(n) {
  side <- ceiling(sqrt(n))
  list(
    x_coord = rep(seq_len(side), each = side)[seq_len(n)],
    y_coord = rep(seq_len(side), times = side)[seq_len(n)]
  )
}

binary_test_data <- function(n = 60L, seed = 1L) {
  set.seed(seed)
  g <- grid_coords(n)
  x1 <- stats::rnorm(n)
  x2 <- stats::rnorm(n)
  latent <- 0.4 + 1.3 * x1 - 0.9 * x2 + stats::rnorm(n, sd = 0.6)
  y <- as.integer(latent > 0)
  data.frame(y = y, x1 = x1, x2 = x2, x_coord = g$x_coord, y_coord = g$y_coord)
}

count_test_data <- function(n = 60L, seed = 1L) {
  set.seed(seed)
  g <- grid_coords(n)
  x1 <- stats::rnorm(n)
  lambda <- exp(1 + 0.35 * x1)
  y <- stats::rpois(n, lambda)
  data.frame(y = y, x1 = x1, x_coord = g$x_coord, y_coord = g$y_coord)
}

continuous_test_data <- function(n = 60L, seed = 1L) {
  set.seed(seed)
  g <- grid_coords(n)
  x1 <- stats::rnorm(n)
  y <- 1 + 0.8 * x1 + stats::rnorm(n, sd = 0.3)
  data.frame(y = y, x1 = x1, x_coord = g$x_coord, y_coord = g$y_coord)
}

# --- Tier 1: family/mode routing on fit_one_benchmark_estimator() directly ---

test_that("fit_one_benchmark_estimator() routes ols/gam_spatial to binomial family for a binary task", {
  dat <- binary_test_data()
  fit_ols <- fit_one_benchmark_estimator(
    "ols", y ~ x1 + x2, dat, coords = c("x_coord", "y_coord"),
    response_typology = "binary"
  )
  expect_s3_class(fit_ols, "glm")
  expect_equal(fit_ols$family$family, "binomial")

  fit_gam <- fit_one_benchmark_estimator(
    "gam_spatial", y ~ x1 + x2, dat, coords = c("x_coord", "y_coord"),
    response_typology = "binary"
  )
  expect_true(inherits(fit_gam, "gam"))
  expect_equal(fit_gam$family$family, "binomial")
})

test_that("fit_one_benchmark_estimator() routes ols/gam_spatial to poisson family for a count task", {
  dat <- count_test_data()
  fit_ols <- fit_one_benchmark_estimator(
    "ols", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "count"
  )
  expect_equal(fit_ols$family$family, "poisson")

  fit_gam <- fit_one_benchmark_estimator(
    "gam_spatial", y ~ x1, dat, coords = c("x_coord", "y_coord"),
    response_typology = "count"
  )
  expect_equal(fit_gam$family$family, "poisson")
})

test_that("fit_one_benchmark_estimator() defaults to gaussian family when response_typology is not supplied", {
  dat <- continuous_test_data()
  fit_ols <- fit_one_benchmark_estimator("ols", y ~ x1, dat, coords = c("x_coord", "y_coord"))
  expect_equal(fit_ols$family$family, "gaussian")
})

# --- End-to-end: benchmark_spatial() with response_typology, metrics shape ---

test_that("benchmark_spatial() produces well-formed classification metrics for a binary task (ols/gam_spatial)", {
  dat <- binary_test_data()
  bench <- benchmark_spatial(
    formula = y ~ x1 + x2, data = dat, coords = c("x_coord", "y_coord"),
    estimators = c("ols", "gam_spatial"),
    cv_scheme = "holdout_10pct", seed = 1L, response_typology = "binary"
  )
  expect_true(all(c("accuracy", "auc", "deviance") %in% names(bench$results)))
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(is.finite(bench$results$accuracy)))
  expect_true(all(is.finite(bench$results$auc)))
  expect_true(all(bench$results$accuracy >= 0 & bench$results$accuracy <= 1))
  expect_true(all(bench$results$auc >= 0 & bench$results$auc <= 1))
  # rmse/mae stay well-defined (probability vs 0/1) and bounded in [0, 1] --
  # never replaced by accuracy/auc, see make_metric_values() in
  # 12-diagnose-spatial.R.
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(bench$results$rmse <= 1 + 1e-8))
})

test_that("benchmark_spatial() routes random_forest/xgboost to classification mode for a binary task", {
  skip_if_not_installed("ranger")
  skip_if_not_installed("xgboost")
  dat <- binary_test_data()
  bench <- benchmark_spatial(
    formula = y ~ x1 + x2, data = dat, coords = c("x_coord", "y_coord"),
    estimators = c("random_forest", "xgboost"),
    cv_scheme = "holdout_10pct", seed = 1L, response_typology = "binary"
  )
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(is.finite(bench$results$accuracy)))
  expect_true(all(bench$results$rmse <= 1 + 1e-8))
})

test_that("benchmark_spatial() computes Poisson deviance for a count task without breaking rmse/mae", {
  dat <- count_test_data()
  bench <- benchmark_spatial(
    formula = y ~ x1, data = dat, coords = c("x_coord", "y_coord"),
    estimators = c("ols", "gam_spatial"),
    cv_scheme = "holdout_10pct", seed = 1L, response_typology = "count"
  )
  expect_true(all(is.finite(bench$results$deviance)))
  expect_true(all(is.na(bench$results$accuracy)))
  expect_true(all(is.na(bench$results$auc)))
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(is.na(bench$results$fit_error)))
})

test_that("benchmark_spatial() routes xgboost to objective=count:poisson for a count task", {
  skip_if_not_installed("xgboost")
  dat <- count_test_data()
  bench <- benchmark_spatial(
    formula = y ~ x1, data = dat, coords = c("x_coord", "y_coord"),
    estimators = "xgboost",
    cv_scheme = "holdout_10pct", seed = 1L, response_typology = "count"
  )
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(is.finite(bench$results$deviance)))
})

# --- Spatial probit (sar_probit/sem_probit) on a self-consistent synthetic SAR-probit DGP ---

test_that("sar_probit/sem_probit fit and predict end-to-end on a synthetic SAR-probit DGP", {
  skip_if_not_installed("ProbitSpatial")
  set.seed(1)
  n <- 100L
  coords <- cbind(x_coord = stats::runif(n, 0, 10), y_coord = stats::runif(n, 0, 10))
  # Meme construction W que celle utilisee en interne par
  # probitspatial_fit_impl() (build_knn_W()), pour que le DGP simule et le
  # fit voient exactement la meme structure de voisinage.
  W <- methods::as(build_knn_W(coords, k = 6L, sparse = TRUE), "dgCMatrix")
  X <- cbind(1, stats::rnorm(n, 0, 1.2), stats::rnorm(n))
  colnames(X) <- c("intercept", "x1", "x2")
  y <- ProbitSpatial::sim_binomial_probit(
    W = W, X = X, beta = c(0.3, 1.4, -1.1), rho = 0.5, model = "SAR", seed = 1L
  )
  skip_if(length(unique(y)) < 2L, "degenerate simulated response (all 0 or all 1)")
  dat <- data.frame(y = y, x1 = X[, "x1"], x2 = X[, "x2"], x_coord = coords[, 1], y_coord = coords[, 2])

  bench <- benchmark_spatial(
    formula = y ~ x1 + x2, data = dat, coords = c("x_coord", "y_coord"),
    estimators = c("sar_probit", "sem_probit"),
    cv_scheme = "holdout_10pct", seed = 1L, response_typology = "binary", k_neighbors = 6L
  )
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(is.finite(bench$results$accuracy)))
  expect_true(all(is.finite(bench$results$auc)))
  expect_true(all(bench$results$rmse <= 1 + 1e-8))
})

test_that("probit_spatial_reg()/sar_probit_reg() reject a non-binary response with a clear error", {
  skip_if_not_installed("ProbitSpatial")
  dat <- data.frame(
    y = stats::rnorm(20), x1 = stats::rnorm(20),
    x_coord = rep(1:5, 4), y_coord = rep(1:4, each = 5)
  )
  expect_error(
    probitspatial_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), model_type = "SAR"),
    "binaire"
  )
})

# --- response_typology routing: auto-detection and mixed suites ---

test_that("benchmark_spatial_datasets() routes a mixed binary + continuous list correctly in one call", {
  spec_binary <- spatial_dataset_spec(
    "synth_binary", binary_test_data(seed = 5), y ~ x1 + x2, c("x_coord", "y_coord"),
    response_typology = "binary"
  )
  spec_continuous <- spatial_dataset_spec(
    "synth_continuous", continuous_test_data(seed = 6),
    y ~ x1, c("x_coord", "y_coord")
    # response_typology absent -- doit defaulter a "continuous"
  )

  bench <- benchmark_spatial_datasets(
    datasets = list(spec_binary, spec_continuous),
    estimators = c("ols", "gam_spatial"),
    cv_scheme = "holdout_10pct", seed = 1L
  )
  bin_rows <- bench$results[bench$results$dataset == "synth_binary", ]
  cont_rows <- bench$results[bench$results$dataset == "synth_continuous", ]
  expect_true(all(is.finite(bin_rows$accuracy)))
  expect_true(all(is.na(cont_rows$accuracy)))
  expect_true(all(is.na(bin_rows$fit_error)))
  expect_true(all(is.na(cont_rows$fit_error)))
})

test_that("detect_response_typology_from_spec() reads binary/count/continuous from a registry-shaped spec row", {
  spec_binary <- data.frame(response_typology = I(list(c("binary"))))
  spec_count <- data.frame(response_typology = I(list(c("count"))))
  spec_continuous <- data.frame(response_typology = I(list(c("continuous"))))
  spec_empty <- data.frame(response_typology = I(list(character())))

  expect_equal(detect_response_typology_from_spec(spec_binary), "binary")
  expect_equal(detect_response_typology_from_spec(spec_count), "count")
  expect_equal(detect_response_typology_from_spec(spec_continuous), "continuous")
  expect_equal(detect_response_typology_from_spec(spec_empty), "continuous")
})

# --- block_spatial: blockCV promoted to Imports (was Suggests), first-class scheme ---

test_that("block_spatial CV scheme runs end-to-end now that blockCV/sf are hard dependencies", {
  dat <- binary_test_data(n = 80L)
  bench <- benchmark_spatial(
    formula = y ~ x1 + x2, data = dat, coords = c("x_coord", "y_coord"),
    estimators = "ols",
    cv_scheme = "block_spatial", block_folds = 4L, seed = 1L, response_typology = "binary"
  )
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(is.finite(bench$results$rmse))
})

# --- pred_type opt-in (KP2) on sar_reg()/sem_reg() ---

test_that("sar_reg()/sem_reg() default to pred_type=TS and accept KP2 as opt-in on a small dataset", {
  dat <- suite_continuous_small <- {
    set.seed(3)
    n <- 60L
    data.frame(
      y = stats::rnorm(n), x1 = stats::rnorm(n),
      x_coord = rep(1:10, 6)[seq_len(n)], y_coord = rep(1:6, each = 10)[seq_len(n)]
    )
  }
  fit_default <- spatialreg_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), model_type = "SAR")
  expect_equal(attr(fit_default, "spatialreg_pred_type"), "TS")

  fit_kp2 <- spatialreg_fit_impl(
    y ~ x1, dat, coords = c("x_coord", "y_coord"), model_type = "SAR", pred_type = "KP2"
  )
  expect_equal(attr(fit_kp2, "spatialreg_pred_type"), "KP2")
})

test_that("spatialreg_fit_impl() refuses pred_type=KP2 above the 200-observation size guard", {
  set.seed(4)
  n <- 220L
  dat <- data.frame(
    y = stats::rnorm(n), x1 = stats::rnorm(n),
    x_coord = rep(1:20, 11)[seq_len(n)], y_coord = rep(1:11, each = 20)[seq_len(n)]
  )
  expect_error(
    spatialreg_fit_impl(y ~ x1, dat, coords = c("x_coord", "y_coord"), model_type = "SAR", pred_type = "KP2"),
    "KP2"
  )
})
