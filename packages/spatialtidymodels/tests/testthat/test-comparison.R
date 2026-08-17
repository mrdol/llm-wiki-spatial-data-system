make_synthetic_results <- function(n_datasets, reference_rmse, candidate_rmse,
                                    cv_scheme = "near_prediction",
                                    reference_fail_idx = integer(0),
                                    candidate_fail_idx = integer(0)) {
  ref_rmse <- reference_rmse
  cand_rmse <- candidate_rmse
  if (length(reference_fail_idx)) ref_rmse[reference_fail_idx] <- NA_real_
  if (length(candidate_fail_idx)) cand_rmse[candidate_fail_idx] <- NA_real_

  rbind(
    data.frame(
      dataset = paste0("ds_", seq_len(n_datasets)),
      cv_scheme = cv_scheme,
      estimator = "sar_lag",
      rmse = ref_rmse,
      mae = ref_rmse * 0.8,
      moran_abs = 0.05,
      duration_sec = 1,
      stringsAsFactors = FALSE
    ),
    data.frame(
      dataset = paste0("ds_", seq_len(n_datasets)),
      cv_scheme = cv_scheme,
      estimator = "spboost_bspa_sar_ml",
      rmse = cand_rmse,
      mae = cand_rmse * 0.8,
      moran_abs = 0.05,
      duration_sec = 5,
      stringsAsFactors = FALSE
    )
  )
}

test_that("compare_estimator_variant() declares SUPERIOR when the candidate wins clearly", {
  set.seed(1)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85 # ~15% better everywhere

  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_s3_class(cmp, "estimator_comparison")
  expect_equal(cmp$summary$n_cases, n)
  expect_equal(cmp$summary$wins, n)
  expect_gt(cmp$summary$median_delta, 10)
  expect_equal(cmp$verdict, "SUPERIOR")
})

test_that("compare_estimator_variant() declares INFERIOR when the candidate loses clearly", {
  set.seed(2)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 1.15 # ~15% worse everywhere

  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_equal(cmp$summary$losses, n)
  expect_lt(cmp$summary$median_delta, -10)
  expect_equal(cmp$verdict, "INFERIOR")
})

test_that("compare_estimator_variant() declares EQUIVALENT within the ROPE", {
  set.seed(3)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * stats::runif(n, 0.997, 1.003) # inside default 1% ROPE

  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_equal(cmp$verdict, "EQUIVALENT")
  expect_true(cmp$summary$ties > 0)
})

test_that("compare_estimator_variant() declares UNSTABLE when the candidate fails much more often", {
  set.seed(4)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85 # candidate wins where it fits

  results <- make_synthetic_results(
    n, reference, candidate,
    candidate_fail_idx = 1:6 # 30% failure rate on the candidate, 0% on reference
  )
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_gt(cmp$summary$failure_rate_increase, 0.05)
  expect_equal(cmp$verdict, "UNSTABLE")
})

test_that("compare_estimator_variant() returns INSUFFICIENT_EVIDENCE below min_cases_for_verdict", {
  set.seed(5)
  n <- 5
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.7

  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_equal(cmp$verdict, "INSUFFICIENT_EVIDENCE")
})

test_that("compare_estimator_variant() errors on unknown estimators or missing columns", {
  results <- make_synthetic_results(10, rep(10, 10), rep(9, 10))

  expect_error(
    compare_estimator_variant(results, reference = "does_not_exist", candidate = "spboost_bspa_sar_ml"),
    "reference"
  )
  expect_error(
    compare_estimator_variant(results, reference = "sar_lag", candidate = "does_not_exist"),
    "candidat"
  )
  expect_error(
    compare_estimator_variant(results[, setdiff(names(results), "rmse")], reference = "sar_lag", candidate = "spboost_bspa_sar_ml"),
    "manquantes"
  )
})

test_that("wilcoxon = FALSE falls back to pure threshold counting", {
  set.seed(6)
  n <- 12
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85

  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    wilcoxon = FALSE
  )

  expect_null(cmp$wilcoxon)
  expect_equal(cmp$verdict, "SUPERIOR")
})

test_that("comparison_rules() stores thresholds and prints without error", {
  rules <- comparison_rules(min_win_rate = 0.6, rope = 0.02)
  expect_s3_class(rules, "spatial_comparison_rules")
  expect_equal(rules$min_win_rate, 0.6)
  expect_equal(rules$rope, 0.02)
  expect_output(print(rules), "Comparison rules")
})

test_that("print.estimator_comparison() runs without error", {
  results <- make_synthetic_results(15, 10 + stats::runif(15, -1, 1), 8.5 + stats::runif(15, -1, 1))
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  expect_output(print(cmp), "Reference vs candidate comparison")
  expect_output(print(cmp), "Verdict")
})
