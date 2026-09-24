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

test_that("comparison_rules() defaults to analysis_unit = 'task' and validates the argument", {
  rules <- comparison_rules()
  expect_equal(rules$analysis_unit, "task")
  expect_equal(comparison_rules(analysis_unit = "source")$analysis_unit, "source")
  expect_error(comparison_rules(analysis_unit = "not_a_valid_unit"))
})

test_that("analysis_unit = 'task' (the default) is unaffected by the analysis_unit argument existing", {
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85
  results <- make_synthetic_results(n, reference, candidate)

  cmp_default <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  cmp_explicit_task <- compare_estimator_variant(
    results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(analysis_unit = "task")
  )
  expect_equal(cmp_default$verdict, cmp_explicit_task$verdict)
  expect_equal(cmp_default$summary$n_cases, cmp_explicit_task$summary$n_cases)
})

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

# --- cv_scheme separation (Etape 2.B) --------------------------------------

test_that("compare_estimator_variant() never pools multiple cv_schemes into one verdict", {
  set.seed(10)
  n <- 15
  reference <- 10 + stats::runif(n, -1, 1)
  candidate_wins_here <- reference * 0.80  # ~20% better under near_prediction
  candidate_loses_here <- reference * 1.20  # ~20% worse under block_spatial

  results <- rbind(
    make_synthetic_results(n, reference, candidate_wins_here, cv_scheme = "near_prediction"),
    make_synthetic_results(n, reference, candidate_loses_here, cv_scheme = "block_spatial")
  )

  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_s3_class(cmp, "estimator_comparison_by_scheme")
  expect_setequal(names(cmp), c("near_prediction", "block_spatial"))
  expect_s3_class(cmp$near_prediction, "estimator_comparison")
  expect_s3_class(cmp$block_spatial, "estimator_comparison")
  expect_equal(cmp$near_prediction$summary$cv_scheme, "near_prediction")
  expect_equal(cmp$near_prediction$verdict, "SUPERIOR")
  expect_equal(cmp$block_spatial$summary$cv_scheme, "block_spatial")
  expect_equal(cmp$block_spatial$verdict, "INFERIOR")
  # Each scheme keeps its own 15 cases -- never 30 mixed together.
  expect_equal(cmp$near_prediction$summary$n_cases, n)
  expect_equal(cmp$block_spatial$summary$n_cases, n)

  expect_output(print(cmp), "by CV scheme")
  expect_output(print(cmp), "near_prediction")
  expect_output(print(cmp), "block_spatial")
})

test_that("compare_estimator_variant() with an explicit single cv_scheme returns a plain comparison", {
  set.seed(11)
  n <- 15
  reference <- 10 + stats::runif(n, -1, 1)
  candidate_a <- reference * 0.80
  candidate_b <- reference * 1.20
  results <- rbind(
    make_synthetic_results(n, reference, candidate_a, cv_scheme = "near_prediction"),
    make_synthetic_results(n, reference, candidate_b, cv_scheme = "block_spatial")
  )

  cmp <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    cv_scheme = "block_spatial"
  )

  expect_s3_class(cmp, "estimator_comparison")
  expect_false(inherits(cmp, "estimator_comparison_by_scheme"))
  expect_equal(cmp$summary$cv_scheme, "block_spatial")
  expect_equal(cmp$summary$n_cases, n)
  expect_equal(cmp$verdict, "INFERIOR")
})

# --- fold-level failure rate (Etape 2.C) ------------------------------------

test_that("partial fold failures trigger UNSTABLE even when the aggregate metric is still available", {
  set.seed(12)
  n <- 15
  reference_rmse <- 10 + stats::runif(n, -1, 1)
  candidate_rmse <- reference_rmse * 0.80 # candidate clearly wins on RMSE where it fits

  results <- rbind(
    data.frame(
      dataset = paste0("ds_", seq_len(n)), cv_scheme = "near_prediction", estimator = "sar_lag",
      rmse = reference_rmse, mae = reference_rmse * 0.8, moran_abs = 0.05, duration_sec = 1,
      n_resamples = 5L, n_failed_resamples = 0L, stringsAsFactors = FALSE
    ),
    data.frame(
      dataset = paste0("ds_", seq_len(n)), cv_scheme = "near_prediction", estimator = "spboost_bspa_sar_ml",
      rmse = candidate_rmse, mae = candidate_rmse * 0.8, moran_abs = 0.05, duration_sec = 5,
      # 2 of 5 folds fail for every dataset, but the aggregate RMSE from the
      # 3 that succeed is still present and still beats the reference.
      n_resamples = 5L, n_failed_resamples = 2L, stringsAsFactors = FALSE
    )
  )

  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  # None of the rows are NA, so the old is.na()-based flag would have seen 0
  # failures. The fold-level rate must catch it instead.
  expect_true(all(!cmp$per_case$candidate_failed))
  expect_equal(cmp$summary$failure_rate_candidate, 0.4, tolerance = 1e-8)
  expect_true(cmp$summary$failure_rate_fold_level)
  expect_gt(cmp$summary$win_rate, 0.9) # candidate still "wins" on RMSE where it fits
  expect_equal(cmp$verdict, "UNSTABLE")
})

test_that("failure rate falls back to the all-or-nothing flag when fold columns are absent", {
  # Same scenario as the SUPERIOR test but re-asserting the fallback flag
  # explicitly, since make_synthetic_results() never sets n_resamples/n_failed_resamples.
  set.seed(1)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85
  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  expect_false(cmp$summary$failure_rate_fold_level)
  expect_equal(cmp$summary$failure_rate_candidate, 0)
})

# --- secondary guardrails (Etape 2.D) ---------------------------------------

test_that("a secondary guardrail breach downgrades SUPERIOR to TRADEOFF", {
  set.seed(13)
  n <- 15
  reference_rmse <- 10 + stats::runif(n, -1, 1)
  candidate_rmse <- reference_rmse * 0.80 # candidate clearly superior on RMSE

  results <- data.frame(
    dataset = rep(paste0("ds_", seq_len(n)), 2),
    cv_scheme = "near_prediction",
    estimator = rep(c("sar_lag", "spboost_bspa_sar_ml"), each = n),
    rmse = c(reference_rmse, candidate_rmse),
    # MAE degrades by ~10% for the candidate -- well beyond a 3% guardrail.
    mae = c(reference_rmse * 0.8, reference_rmse * 0.8 * 1.10),
    moran_abs = 0.05,
    duration_sec = c(rep(1, n), rep(5, n)),
    stringsAsFactors = FALSE
  )

  cmp_default <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  expect_equal(cmp_default$verdict, "SUPERIOR") # no guardrail configured -> unaffected

  cmp_guarded <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(secondary_guardrails = c(mae = 0.03))
  )
  expect_equal(cmp_guarded$verdict, "TRADEOFF")
  expect_true(length(cmp_guarded$guardrails$breaches) > 0)
  expect_match(cmp_guarded$guardrails$breaches[[1]], "mae")
  expect_output(print(cmp_guarded), "Guardrail breach")
})

test_that("max_runtime_multiplier guardrail downgrades SUPERIOR to TRADEOFF", {
  set.seed(14)
  n <- 15
  reference_rmse <- 10 + stats::runif(n, -1, 1)
  candidate_rmse <- reference_rmse * 0.80

  results <- data.frame(
    dataset = rep(paste0("ds_", seq_len(n)), 2),
    cv_scheme = "near_prediction",
    estimator = rep(c("sar_lag", "spboost_bspa_sar_ml"), each = n),
    rmse = c(reference_rmse, candidate_rmse),
    mae = c(reference_rmse * 0.8, candidate_rmse * 0.8),
    moran_abs = 0.05,
    duration_sec = c(rep(1, n), rep(50, n)), # candidate is 50x slower
    stringsAsFactors = FALSE
  )

  cmp <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(max_runtime_multiplier = 5)
  )
  expect_equal(cmp$verdict, "TRADEOFF")
  expect_match(paste(cmp$guardrails$breaches, collapse = " "), "runtime")
})

# --- INCONCLUSIVE vs real EQUIVALENT (Etape 2.E) ----------------------------

test_that("a mixed, non-significant result is INCONCLUSIVE rather than defaulting to EQUIVALENT", {
  # 9 wins at +20%, 11 losses at -12% -- deterministic, no randomness.
  # win_rate = 45%, loss_rate = 55%: neither reaches the 70% threshold, and
  # the median delta (-12%) sits well outside the default 1% ROPE, so this
  # must NOT be reported as a genuine equivalence.
  reference <- rep(100, 20)
  candidate <- c(rep(100 * 0.80, 9), rep(100 * 1.12, 11))
  results <- make_synthetic_results(20, reference, candidate)

  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")

  expect_lt(cmp$summary$win_rate, 0.70)
  expect_lt(cmp$summary$loss_rate, 0.70)
  expect_gt(abs(cmp$summary$median_delta), 1) # outside the 1% ROPE
  expect_equal(cmp$verdict, "INCONCLUSIVE")
  expect_true(nzchar(cmp$verdict_reasons))
})

# --- SPECIALIZED subgroup analysis --------------------------------------

test_that("a candidate that only wins on a specific subgroup is SPECIALIZED, not INCONCLUSIVE/EQUIVALENT", {
  n <- 20
  # First 10 datasets: candidate wins big (+20%). Last 10: exact tie (0%).
  # Global win_rate = 10/20 = 50% (below the 70% SUPERIOR threshold) and the
  # median delta (10%) sits outside the 1% ROPE, so without subgroup
  # information this would be INCONCLUSIVE.
  reference <- rep(100, n)
  candidate <- c(rep(100 * 0.80, 10), rep(100, 10))
  results <- make_synthetic_results(n, reference, candidate)

  cmp_no_groups <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  expect_equal(cmp_no_groups$verdict, "INCONCLUSIVE")
  expect_null(cmp_no_groups$subgroups)

  groups <- data.frame(
    dataset = paste0("ds_", seq_len(n)),
    moran_bucket = rep(c("high_moran", "low_moran"), each = 10),
    stringsAsFactors = FALSE
  )
  cmp <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    groups = groups
  )

  expect_equal(cmp$verdict, "SPECIALIZED")
  expect_true(nzchar(cmp$verdict_reasons))
  expect_match(cmp$verdict_reasons, "high_moran")
  expect_equal(cmp$subgroups$dimension, "moran_bucket")
  expect_equal(nrow(cmp$subgroups$table), 2L)
  expect_equal(cmp$subgroups$specialized_in, "high_moran")
  high_row <- cmp$subgroups$table[cmp$subgroups$table$group == "high_moran", ]
  expect_equal(high_row$win_rate, 1)
  expect_true(high_row$eligible)
  low_row <- cmp$subgroups$table[cmp$subgroups$table$group == "low_moran", ]
  expect_false(low_row$eligible)

  expect_output(print(cmp), "Subgroups")
  expect_output(print(cmp), "high_moran")
})

test_that("groups never overrides an already-SUPERIOR or -INFERIOR verdict", {
  set.seed(1)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85 # clearly SUPERIOR globally
  results <- make_synthetic_results(n, reference, candidate)
  groups <- data.frame(dataset = paste0("ds_", seq_len(n)), bucket = rep(c("a", "b"), n / 2), stringsAsFactors = FALSE)

  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml", groups = groups)
  expect_equal(cmp$verdict, "SUPERIOR") # not overridden to SPECIALIZED
  expect_false(is.null(cmp$subgroups)) # breakdown still computed and available
})

test_that("require_significance_for_subgroup withholds SPECIALIZED when a subgroup can't reach significance", {
  n <- 20
  reference <- rep(100, n)
  candidate <- c(rep(100 * 0.80, 10), rep(100, 10))
  results <- make_synthetic_results(n, reference, candidate)
  groups <- data.frame(
    dataset = paste0("ds_", seq_len(n)),
    moran_bucket = rep(c("high_moran", "low_moran"), each = 10),
    stringsAsFactors = FALSE
  )

  # All 10 "high_moran" deltas are identical (+20%, no variance) -- wilcox.test()
  # cannot reject H0 without any spread, so the subgroup fails a significance
  # requirement even though its win rate is 100%.
  cmp <- compare_estimator_variant(
    results,
    reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    groups = groups,
    rules = comparison_rules(require_significance_for_subgroup = TRUE)
  )
  expect_equal(cmp$subgroups$specialized_in, character(0))
  expect_equal(cmp$verdict, "INCONCLUSIVE")
})

test_that("groups validates its shape", {
  results <- make_synthetic_results(10, rep(10, 10), rep(9, 10))
  expect_error(
    compare_estimator_variant(
      results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
      groups = data.frame(not_dataset = paste0("ds_", 1:10), bucket = "a")
    ),
    "dataset"
  )
  expect_error(
    compare_estimator_variant(
      results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
      groups = data.frame(dataset = paste0("ds_", 1:10), a = "x", b = "y")
    ),
    "une seule"
  )
})

test_that("a genuinely tied result is still EQUIVALENT, not INCONCLUSIVE", {
  set.seed(3)
  n <- 20
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * stats::runif(n, 0.997, 1.003) # inside default 1% ROPE
  results <- make_synthetic_results(n, reference, candidate)
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml")
  expect_equal(cmp$verdict, "EQUIVALENT")
  expect_true(nzchar(cmp$verdict_reasons))
})

# --- analysis_unit = "source" (Etape H) -------------------------------------

# Motivating scenario from comparison_rules(): a source split into many
# benchmark tasks (e.g. korea_hedonic_housing's 32 yearly splits) must not
# outweigh a source evaluated as a single task just by volume. Here one
# "heavy" source contributes 20 losing tasks, and 9 other sources each
# contribute exactly one winning task -- 29 tasks, 10 sources.
make_source_grouped_results <- function() {
  heavy_results <- make_synthetic_results(
    20, rep(100, 20), rep(100 * 1.30, 20) # candidate ~30% worse (LOSS), 20 tasks
  )
  heavy_results$dataset <- paste0("heavy_task_", seq_len(20))

  singles_results <- make_synthetic_results(
    9, rep(100, 9), rep(100 * 0.70, 9) # candidate ~30% better (WIN), 1 task each
  )
  singles_results$dataset <- paste0("single_", seq_len(9))

  results <- rbind(heavy_results, singles_results)

  dataset_metadata <- rbind(
    data.frame(
      dataset = paste0("heavy_task_", seq_len(20)),
      source_dataset_id = "heavy_source",
      stringsAsFactors = FALSE
    ),
    data.frame(
      dataset = paste0("single_", seq_len(9)),
      source_dataset_id = paste0("single_", seq_len(9)), # each its own source
      stringsAsFactors = FALSE
    )
  )

  list(results = results, dataset_metadata = dataset_metadata)
}

test_that("analysis_unit = 'source' requires a dataset -> source_dataset_id mapping when suite is a plain data.frame", {
  scenario <- make_source_grouped_results()
  expect_error(
    compare_estimator_variant(
      scenario$results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
      rules = comparison_rules(analysis_unit = "source")
    ),
    "source_dataset_id"
  )
})

test_that("analysis_unit = 'source' collapses a many-task source to one case, changing the verdict vs 'task'", {
  scenario <- make_source_grouped_results()

  cmp_task <- compare_estimator_variant(
    scenario$results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml"
  )
  expect_equal(cmp_task$summary$n_cases, 29L) # every task counted independently
  expect_equal(cmp_task$verdict, "INCONCLUSIVE") # 20 losses dominate the raw count

  cmp_source <- compare_estimator_variant(
    scenario$results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(analysis_unit = "source"),
    dataset_metadata = scenario$dataset_metadata
  )
  expect_equal(cmp_source$summary$n_cases, 10L) # 1 heavy source + 9 single-task sources
  expect_equal(cmp_source$verdict, "SUPERIOR") # heavy source's 20 losses count once
  expect_equal(cmp_source$summary$wins, 9L)
  expect_equal(cmp_source$summary$losses, 1L)

  # The heavy source's own row reports how many tasks fed its median.
  heavy_row <- cmp_source$per_case[cmp_source$per_case$source_dataset_id == "heavy_source", ]
  expect_equal(nrow(heavy_row), 1L)
  expect_equal(heavy_row$n_tasks, 20L)
  expect_equal(heavy_row$outcome, "LOSS")
})

test_that("analysis_unit = 'source' auto-fills the mapping from a spatial_benchmark_suite", {
  scenario <- make_source_grouped_results()
  fake_suite <- structure(
    list(results = scenario$results, dataset_metadata = scenario$dataset_metadata),
    class = "spatial_benchmark_suite"
  )

  cmp_suite <- compare_estimator_variant(
    fake_suite, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(analysis_unit = "source")
  )
  expect_equal(cmp_suite$summary$n_cases, 10L)
  expect_equal(cmp_suite$verdict, "SUPERIOR")
})

test_that("analysis_unit = 'source' rejects subgroup analysis instead of mixing units silently", {
  scenario <- make_source_grouped_results()
  groups <- data.frame(dataset = unique(scenario$results$dataset), bucket = "a", stringsAsFactors = FALSE)

  expect_error(
    compare_estimator_variant(
      scenario$results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
      rules = comparison_rules(analysis_unit = "source"),
      dataset_metadata = scenario$dataset_metadata,
      groups = groups
    ),
    "groups"
  )
})

test_that("analysis_unit = 'source' treats a dataset absent from dataset_metadata as its own source", {
  set.seed(20)
  n <- 12
  reference <- 10 + stats::runif(n, -1, 1)
  candidate <- reference * 0.85
  results <- make_synthetic_results(n, reference, candidate)
  # Only map half the datasets; the rest must fall back to being their own source.
  dataset_metadata <- data.frame(
    dataset = paste0("ds_", 1:6),
    source_dataset_id = "mapped_source",
    stringsAsFactors = FALSE
  )

  cmp <- compare_estimator_variant(
    results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(analysis_unit = "source", min_cases_for_verdict = 3L),
    dataset_metadata = dataset_metadata
  )
  # 6 mapped tasks -> 1 source, 6 unmapped tasks -> 6 sources of their own = 7 total.
  expect_equal(cmp$summary$n_cases, 7L)
})

test_that("analysis_unit = 'source' still separates cv_schemes independently", {
  scenario <- make_source_grouped_results()
  scenario$results$cv_scheme <- "near_prediction"
  other_scheme <- scenario$results
  other_scheme$cv_scheme <- "holdout_10pct"
  # Flip the sign under the second scheme so the two schemes would disagree
  # if ever pooled together.
  other_scheme$rmse[other_scheme$estimator == "spboost_bspa_sar_ml"] <-
    other_scheme$rmse[other_scheme$estimator == "sar_lag"] * 0.70
  results <- rbind(scenario$results, other_scheme)

  cmp <- compare_estimator_variant(
    results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
    rules = comparison_rules(analysis_unit = "source"),
    dataset_metadata = scenario$dataset_metadata
  )
  expect_s3_class(cmp, "estimator_comparison_by_scheme")
  expect_setequal(names(cmp), c("near_prediction", "holdout_10pct"))
  expect_equal(cmp$near_prediction$summary$n_cases, 10L)
  expect_equal(cmp$holdout_10pct$summary$n_cases, 10L)
})
