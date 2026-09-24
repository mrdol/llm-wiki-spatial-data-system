# Tests for dashboard_suite_from_seed_runs() (R/26-dashboard-seed-bridge.R),
# the CSV -> spatial_benchmark_suite adapter for tools/bench_inla_multiseed.R.
# Uses a small hand-built fixture directory (2 datasets x 2 seeds) rather than
# the real multi-seed benchmark output, so these tests stay fast and
# deterministic; C:/.../inla_multiseed_2026-09-22 was used for a one-off
# manual cross-check against independently recomputed RMSE (see session log,
# 2026-09-22) but is not part of the automated suite.

seed_bridge_fixture_dir <- function() {
  dir <- tempfile("seed_bridge_")
  dir.create(dir)

  write_pair <- function(dataset, seed, estimators, response_typology, truth_by_fold, pred_by_estimator, ok = TRUE) {
    tag <- sprintf("%s_s%d", dataset, seed)
    frows <- list(); prows <- list()
    for (est in estimators) {
      for (fold in seq_along(truth_by_fold)) {
        truth <- truth_by_fold[[fold]]
        pred <- pred_by_estimator[[est]][[fold]]
        frows[[length(frows) + 1L]] <- data.frame(
          dataset = dataset, seed = seed, estimator = est, fold = fold,
          ok = ok, elapsed = 1.5, attempts = 1L, mlik = if (grepl("^inla", est)) -10 - fold else NA_real_,
          range = if (grepl("^inla", est)) 0.5 else NA_real_, error = NA_character_,
          stringsAsFactors = FALSE
        )
        prows[[length(prows) + 1L]] <- data.frame(
          dataset = dataset, seed = seed, estimator = est, fold = fold, typ = response_typology,
          truth = truth, pred = pred, ytrain_mean = mean(unlist(truth_by_fold)),
          stringsAsFactors = FALSE
        )
      }
    }
    utils::write.csv(do.call(rbind, frows), file.path(dir, paste0(tag, "_folds.csv")), row.names = FALSE)
    utils::write.csv(do.call(rbind, prows), file.path(dir, paste0(tag, "_preds.csv")), row.names = FALSE)
  }

  for (seed in c(11L, 22L)) {
    write_pair(
      "alpha", seed, c("baseline_mean", "ols"), "continuous",
      truth_by_fold = list(c(1, 2), c(3, 4)),
      pred_by_estimator = list(
        baseline_mean = list(c(2.5, 2.5), c(2.5, 2.5)),
        ols = list(c(1.1, 2.1), c(2.9, 4.2))
      )
    )
    write_pair(
      "beta", seed, c("baseline_mean", "inla_spde_st"), "binary",
      truth_by_fold = list(c(0, 1), c(1, 0)),
      pred_by_estimator = list(
        baseline_mean = list(c(0.5, 0.5), c(0.5, 0.5)),
        inla_spde_st = list(c(0.1, 0.8), c(0.7, 0.2))
      )
    )
  }
  dir
}

test_that("dashboard_suite_from_seed_runs() reconstructs a spatial_benchmark_suite with correctly pooled metrics", {
  dir <- seed_bridge_fixture_dir()
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  suite <- dashboard_suite_from_seed_runs(dir)
  expect_s3_class(suite, "spatial_benchmark_suite")
  expect_setequal(names(suite), c("results", "dataset_metadata", "datasets", "estimators", "cv_schemes", "failures", "protocol"))

  # 2 datasets x 2 seeds x 2 estimators each = 8 result rows.
  expect_equal(nrow(suite$results), 8L)
  expect_setequal(suite$results$dataset, c("alpha__s11", "alpha__s22", "beta__s11", "beta__s22"))
  expect_true(all(suite$results$cv_scheme == "block_spatial"))

  # RMSE recomputed independently from the same source values (pooled across
  # both folds), not by re-parsing the CSV -- a real check on the bridge's
  # own pooling/parsing logic.
  ols_row <- suite$results[suite$results$dataset == "alpha__s11" & suite$results$estimator == "ols", ]
  expected_rmse <- sqrt(mean((c(1.1, 2.1, 2.9, 4.2) - c(1, 2, 3, 4))^2))
  expect_equal(ols_row$rmse, expected_rmse, tolerance = 1e-8)
  expect_equal(ols_row$n, 4L)

  # Binary response: accuracy/auc/deviance populate, rmse/mae still present
  # (make_metric_values()'s contract -- see 12-diagnose-spatial.R).
  bin_row <- suite$results[suite$results$dataset == "beta__s11" & suite$results$estimator == "inla_spde_st", ]
  expect_true(is.finite(bin_row$rmse))
  expect_true(is.finite(bin_row$accuracy))
  expect_true(is.finite(bin_row$auc))
  expect_true(is.finite(bin_row$deviance))

  # Moran's I was never computed by this ad hoc benchmark -- always NA, never
  # fabricated as zero or dropped from the schema.
  expect_true(all(is.na(suite$results$moran_i)))
  expect_true(all(is.na(suite$results$moran_abs)))
  expect_true("moran_abs" %in% names(suite$results))
})

test_that("dashboard_suite_from_seed_runs() builds dataset_metadata with source_dataset_id, seed, response_typology and spatio_temporal", {
  dir <- seed_bridge_fixture_dir()
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  suite <- dashboard_suite_from_seed_runs(dir)
  meta <- suite$dataset_metadata
  expect_equal(nrow(meta), 4L)
  expect_setequal(meta$source_dataset_id, c("alpha", "beta"))

  alpha_s11 <- meta[meta$dataset == "alpha__s11", ]
  expect_equal(alpha_s11$source_dataset_id, "alpha")
  expect_equal(alpha_s11$seed, 11L)
  expect_equal(alpha_s11$response_typology, "continuous")
  expect_false(alpha_s11$spatio_temporal) # no inla_spde_st* estimator was run on alpha
  expect_equal(alpha_s11$n, 4L) # baseline_mean never fails: 2 folds x 2 obs

  beta_s22 <- meta[meta$dataset == "beta__s22", ]
  expect_equal(beta_s22$response_typology, "binary")
  expect_true(beta_s22$spatio_temporal) # inla_spde_st was run on beta

  # source_dataset_id links the two seeds of the same real dataset -- the
  # precondition compare_estimator_variant(analysis_unit = "source") needs to
  # collapse seeds of one dataset into a single representative case.
  expect_equal(sort(meta$dataset[meta$source_dataset_id == "alpha"]), c("alpha__s11", "alpha__s22"))
})

test_that("dashboard_suite_from_seed_runs() records fold failures without dropping the estimator's row", {
  dir <- tempfile("seed_bridge_fail_")
  dir.create(dir)
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)

  folds <- data.frame(
    dataset = "gamma", seed = 1L, estimator = c("ols", "ols"), fold = c(1L, 2L),
    ok = c(TRUE, FALSE), elapsed = c(1, NA), attempts = c(1L, 3L), mlik = NA_real_, range = NA_real_,
    error = c(NA_character_, "Matrix is not (numerical) positive definite"),
    stringsAsFactors = FALSE
  )
  preds <- data.frame(
    dataset = "gamma", seed = 1L, estimator = "ols", fold = 1L, typ = "continuous",
    truth = c(1, 2), pred = c(1.1, 2.1), ytrain_mean = 1.5,
    stringsAsFactors = FALSE
  )
  utils::write.csv(folds, file.path(dir, "gamma_s1_folds.csv"), row.names = FALSE)
  utils::write.csv(preds, file.path(dir, "gamma_s1_preds.csv"), row.names = FALSE)

  suite <- dashboard_suite_from_seed_runs(dir)
  row <- suite$results[suite$results$dataset == "gamma__s1" & suite$results$estimator == "ols", ]
  expect_equal(nrow(row), 1L) # the failed fold does not remove the estimator's row
  expect_equal(row$n_resamples, 2L)
  expect_equal(row$n_failed_resamples, 1L)
  expect_match(row$fit_error, "positive definite")
  expect_true(is.finite(row$rmse)) # still computed from the one successful fold
  expect_equal(nrow(suite$failures), 1L)
})

test_that("dashboard_suite_from_seed_runs() errors clearly on a missing directory or one with no matching files", {
  expect_error(dashboard_suite_from_seed_runs(tempfile("does_not_exist_")), "introuvable")

  empty_dir <- tempfile("seed_bridge_empty_")
  dir.create(empty_dir)
  on.exit(unlink(empty_dir, recursive = TRUE), add = TRUE)
  expect_error(dashboard_suite_from_seed_runs(empty_dir), "Aucun fichier")
})

test_that("a suite from dashboard_suite_from_seed_runs() builds successfully in launch_benchmark_dashboard()", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("bslib")

  dir <- seed_bridge_fixture_dir()
  on.exit(unlink(dir, recursive = TRUE), add = TRUE)
  suite <- dashboard_suite_from_seed_runs(dir)

  app <- launch_benchmark_dashboard(suite, baseline_estimator = "baseline_mean", launch = FALSE)
  expect_s3_class(app, "shiny.appobj")

  # The new Overview filters render with the real choices computed from this
  # suite's dataset_metadata (Response type: continuous/binary; Structure:
  # cross-section/spatio-temporal).
  resp <- app$httpHandler(list(REQUEST_METHOD = "GET", PATH_INFO = "/", rook.input = NULL, HTTP_ACCEPT = "text/html"))
  ui_html <- resp$content
  expect_match(ui_html, "Response type", fixed = TRUE)
  expect_match(ui_html, "Structure", fixed = TRUE)
  expect_match(ui_html, "Subgroup dimension", fixed = TRUE)
})
