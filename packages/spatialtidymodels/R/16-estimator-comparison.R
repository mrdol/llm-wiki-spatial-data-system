# Couche de comparaison estimateur de reference / variante.
#
# Cette couche est purement statistique: elle ne trace rien et ne connait pas
# Shiny. Un futur dashboard ne fait qu'appeler compare_estimator_variant() et
# afficher cmp$verdict, cmp$summary et cmp$per_case -- la regle de decision
# vit ici, pas dans l'UI, pour qu'un chercheur puisse reproduire exactement la
# meme conclusion en console (print(cmp)) sans ouvrir de dashboard.
#
# Reference methodologique: Demsar (2006), "Statistical Comparisons of
# Classifiers over Multiple Data Sets", JMLR 7:1-30 -- recommande un test de
# Wilcoxon signe sur les differences par dataset plutot qu'un simple comptage
# de victoires, car les differences de performance entre datasets ne sont pas
# commensurables et souvent non-normales. Le comptage win/tie/loss (avec zone
# d'equivalence, ou ROPE) reste utile comme lecture immediate, mais le
# verdict "SUPERIOR"/"INFERIOR" exige en plus la significativite Wilcoxon par
# defaut -- un taux de victoire de 70% sur 12 datasets n'est pas la meme
# preuve qu'un taux de victoire de 70% sur 200 datasets.

#' Define the decision thresholds used to turn a comparison into a verdict
#'
#' @param min_win_rate Minimum share of non-tied, non-failed cases the
#'   candidate must win for a `"SUPERIOR"` verdict (and, symmetrically, the
#'   minimum loss share for `"INFERIOR"`). Default `0.70`.
#' @param max_large_loss_rate Maximum share of cases where the candidate is
#'   allowed to degrade the primary metric by more than
#'   `large_loss_threshold`. Default `0.10`.
#' @param large_loss_threshold Relative degradation (as a proportion, e.g.
#'   `0.10` = 10%) on the primary metric beyond which a single case counts as
#'   a "large loss" for the candidate (or, symmetrically, a "large win" for
#'   the candidate when used as the `"INFERIOR"` guardrail). Default `0.10`.
#' @param min_median_delta Minimum median relative improvement (in
#'   percentage points, e.g. `0` requires the median case to not be worse) the
#'   candidate must show for `"SUPERIOR"`. Default `0`.
#' @param max_failure_rate_increase Maximum tolerated increase in fit-failure
#'   rate (candidate vs reference, as a proportion) before the verdict is
#'   forced to `"UNSTABLE"` regardless of how the candidate scores otherwise
#'   -- a variant that wins on RMSE but fails to fit far more often than the
#'   reference is not a safe default. Default `0.05`.
#' @param rope Region of practical equivalence on the primary metric's
#'   relative delta (as a proportion, e.g. `0.01` = 1%). Cases inside
#'   `[-rope, +rope]` count as `"TIE"` rather than `"WIN"`/`"LOSS"`, so a
#'   `+0.001%` improvement isn't counted as a win. Default `0.01`.
#' @param alpha Significance level for the paired Wilcoxon signed-rank test on
#'   the primary metric's per-case delta. Default `0.05`.
#' @param min_cases_for_verdict Minimum number of valid (non-failed) cases
#'   required before issuing any verdict other than
#'   `"INSUFFICIENT_EVIDENCE"`. Default `10`.
#'
#' @return A `spatial_comparison_rules` object, a plain list of thresholds.
#' @export
comparison_rules <- function(min_win_rate = 0.70,
                             max_large_loss_rate = 0.10,
                             large_loss_threshold = 0.10,
                             min_median_delta = 0,
                             max_failure_rate_increase = 0.05,
                             rope = 0.01,
                             alpha = 0.05,
                             min_cases_for_verdict = 10L) {
  structure(
    list(
      min_win_rate = min_win_rate,
      max_large_loss_rate = max_large_loss_rate,
      large_loss_threshold = large_loss_threshold,
      min_median_delta = min_median_delta,
      max_failure_rate_increase = max_failure_rate_increase,
      rope = rope,
      alpha = alpha,
      min_cases_for_verdict = as.integer(min_cases_for_verdict)
    ),
    class = "spatial_comparison_rules"
  )
}

#' @export
print.spatial_comparison_rules <- function(x, ...) {
  cat("Comparison rules\n")
  labels <- list(
    min_win_rate = "Min. win rate (SUPERIOR/INFERIOR)",
    max_large_loss_rate = "Max. large-loss rate",
    large_loss_threshold = "Large-loss threshold (relative)",
    min_median_delta = "Min. median delta (pct points)",
    max_failure_rate_increase = "Max. failure-rate increase",
    rope = "ROPE (equivalence zone, relative)",
    alpha = "Significance level (Wilcoxon)",
    min_cases_for_verdict = "Min. cases required for a verdict"
  )
  for (nm in names(x)) {
    cat(sprintf("  %-38s %s\n", labels[[nm]] %||% nm, format(x[[nm]])))
  }
  invisible(x)
}

wilson_ci <- function(successes, n, conf = 0.95) {
  # Wilson score interval -- no extra dependency, well-behaved at the
  # boundaries (p near 0 or 1) unlike the naive normal approximation, which
  # matters here because win rates near 100% or 0% are common with strong
  # variants.
  if (is.na(n) || n == 0L) return(c(lower = NA_real_, upper = NA_real_))
  z <- stats::qnorm(1 - (1 - conf) / 2)
  p <- successes / n
  denom <- 1 + z^2 / n
  center <- (p + z^2 / (2 * n)) / denom
  half <- (z * sqrt((p * (1 - p) + z^2 / (4 * n)) / n)) / denom
  c(lower = max(0, center - half), upper = min(1, center + half))
}

relative_delta_pct <- function(reference, candidate, lower_is_better) {
  # Positive = candidate better, regardless of metric direction. Uses
  # abs(reference) as the normalizer so the sign of the reference value
  # doesn't flip the interpretation.
  denom <- abs(reference)
  denom[denom == 0 | !is.finite(denom)] <- NA_real_
  raw <- if (isTRUE(lower_is_better)) (reference - candidate) else (candidate - reference)
  100 * raw / denom
}

classify_outcome <- function(delta_pct, rope_pct) {
  ifelse(
    is.na(delta_pct), NA_character_,
    ifelse(delta_pct > rope_pct, "WIN",
      ifelse(delta_pct < -rope_pct, "LOSS", "TIE"))
  )
}

#' Compare a candidate estimator to a reference estimator across datasets
#'
#' Computes per-dataset (per `dataset` x `cv_scheme` "case") relative deltas
#' between a candidate and a reference estimator on a primary metric and any
#' number of secondary metrics, classifies each case as a win, tie or loss
#' against a region of practical equivalence, and turns the aggregate picture
#' into a verdict using [comparison_rules()] plus (by default) a paired
#' Wilcoxon signed-rank test on the primary metric's deltas.
#'
#' This function does no plotting. A dashboard should call it and display
#' `cmp$verdict`, `cmp$summary` and `cmp$per_case` -- it should never
#' recompute or override the verdict logic.
#'
#' @param suite A `spatial_benchmark_suite` (from [benchmark_spatial_suite()])
#'   or a results-shaped `data.frame` with at least `dataset`, `cv_scheme`,
#'   `estimator` and the metric columns referenced by `primary_metric`/
#'   `secondary_metrics`.
#' @param reference,candidate Estimator names present in the results table
#'   (see `available_benchmark_estimators()`/the `estimator` column).
#' @param primary_metric Metric that drives the win/tie/loss classification
#'   and the verdict. Default `"rmse"`.
#' @param secondary_metrics Additional metrics to report deltas for, without
#'   driving the verdict. Default `c("mae", "moran_abs", "duration_sec")`.
#' @param lower_is_better Named logical vector giving the direction of each
#'   metric referenced above (`TRUE` = lower is better). Metrics not listed
#'   default to `TRUE`.
#' @param rules A [comparison_rules()] object. Default `comparison_rules()`.
#' @param wilcoxon If `TRUE` (default), run a paired Wilcoxon signed-rank test
#'   on the primary metric's per-case delta and require significance (at
#'   `rules$alpha`) for a `"SUPERIOR"`/`"INFERIOR"` verdict. Set `FALSE` to
#'   fall back to pure threshold counting.
#'
#' @return An `estimator_comparison` object with `per_case` (one row per
#'   dataset x cv_scheme), `summary` (aggregate statistics), `wilcoxon` (the
#'   `htest` result, or `NULL`), `rules` and `verdict`.
#' @export
compare_estimator_variant <- function(suite,
                                      reference,
                                      candidate,
                                      primary_metric = "rmse",
                                      secondary_metrics = c("mae", "moran_abs", "duration_sec"),
                                      lower_is_better = c(
                                        rmse = TRUE, mae = TRUE,
                                        moran_abs = TRUE, duration_sec = TRUE
                                      ),
                                      rules = comparison_rules(),
                                      wilcoxon = TRUE) {
  results <- if (inherits(suite, "spatial_benchmark_suite")) suite$results else suite
  if (!is.data.frame(results)) {
    stop("`suite` doit etre un spatial_benchmark_suite ou un data.frame de resultats.", call. = FALSE)
  }
  metrics <- unique(c(primary_metric, secondary_metrics))
  required <- c("dataset", "cv_scheme", "estimator", metrics)
  missing_cols <- setdiff(required, names(results))
  if (length(missing_cols)) {
    stop(sprintf("Colonnes manquantes dans les resultats: %s", paste(missing_cols, collapse = ", ")), call. = FALSE)
  }

  ref_rows <- results[results$estimator == reference, , drop = FALSE]
  cand_rows <- results[results$estimator == candidate, , drop = FALSE]
  if (nrow(ref_rows) == 0L) stop(sprintf("Estimateur de reference introuvable dans les resultats: %s", reference), call. = FALSE)
  if (nrow(cand_rows) == 0L) stop(sprintf("Estimateur candidat introuvable dans les resultats: %s", candidate), call. = FALSE)

  optional_cols <- intersect(c("n_failed_resamples", "n_resamples", "fit_error"), names(results))
  key_cols <- c("dataset", "cv_scheme")
  ref_keep <- ref_rows[, unique(c(key_cols, metrics, optional_cols)), drop = FALSE]
  cand_keep <- cand_rows[, unique(c(key_cols, metrics, optional_cols)), drop = FALSE]
  names(ref_keep)[!(names(ref_keep) %in% key_cols)] <- paste0(names(ref_keep)[!(names(ref_keep) %in% key_cols)], "_reference")
  names(cand_keep)[!(names(cand_keep) %in% key_cols)] <- paste0(names(cand_keep)[!(names(cand_keep) %in% key_cols)], "_candidate")

  merged <- merge(ref_keep, cand_keep, by = key_cols, all = FALSE)
  if (nrow(merged) == 0L) {
    stop("Aucun dataset/cv_scheme commun entre reference et candidat.", call. = FALSE)
  }

  primary_ref_col <- paste0(primary_metric, "_reference")
  primary_cand_col <- paste0(primary_metric, "_candidate")
  primary_direction <- if (primary_metric %in% names(lower_is_better)) lower_is_better[[primary_metric]] else TRUE

  merged$reference_failed <- is.na(merged[[primary_ref_col]])
  merged$candidate_failed <- is.na(merged[[primary_cand_col]])

  delta_cols <- character(0)
  for (m in metrics) {
    direction <- if (m %in% names(lower_is_better)) lower_is_better[[m]] else TRUE
    delta_name <- paste0("delta_", m)
    merged[[delta_name]] <- relative_delta_pct(merged[[paste0(m, "_reference")]], merged[[paste0(m, "_candidate")]], direction)
    delta_cols <- c(delta_cols, delta_name)
  }

  rope_pct <- 100 * rules$rope
  merged$outcome <- classify_outcome(merged[[paste0("delta_", primary_metric)]], rope_pct)
  merged$outcome[merged$reference_failed & merged$candidate_failed] <- "BOTH_FAILED"
  merged$outcome[merged$reference_failed & !merged$candidate_failed] <- "REFERENCE_FAILED"
  merged$outcome[!merged$reference_failed & merged$candidate_failed] <- "CANDIDATE_FAILED"

  merged$reference <- reference
  merged$candidate <- candidate
  ordered_cols <- c(
    "dataset", "cv_scheme", "reference", "candidate",
    unlist(lapply(metrics, function(m) c(paste0(m, "_reference"), paste0(m, "_candidate"), paste0("delta_", m)))),
    "reference_failed", "candidate_failed", "outcome"
  )
  per_case <- merged[, intersect(ordered_cols, names(merged)), drop = FALSE]
  row.names(per_case) <- NULL

  valid <- per_case[!per_case$reference_failed & !per_case$candidate_failed, , drop = FALSE]
  n_cases <- nrow(valid)
  primary_delta <- valid[[paste0("delta_", primary_metric)]]

  wins <- sum(valid$outcome == "WIN")
  ties <- sum(valid$outcome == "TIE")
  losses <- sum(valid$outcome == "LOSS")
  win_rate <- if (n_cases > 0L) wins / n_cases else NA_real_
  loss_rate <- if (n_cases > 0L) losses / n_cases else NA_real_
  tie_rate <- if (n_cases > 0L) ties / n_cases else NA_real_
  win_ci <- wilson_ci(wins, n_cases)

  large_loss_pct <- 100 * rules$large_loss_threshold
  # large_loss_rate: share of cases where the CANDIDATE crashes badly
  # (delta < -threshold) -- guardrail against a SUPERIOR verdict hiding a few
  # catastrophic candidate losses behind a good median/win rate.
  large_loss_rate <- if (n_cases > 0L) mean(primary_delta < -large_loss_pct) else NA_real_
  # large_candidate_win_rate: share of cases where the CANDIDATE wins big
  # (delta > +threshold) -- symmetric guardrail against an INFERIOR verdict
  # hiding a chunk of spectacular candidate wins behind a bad median (a sign
  # the variant might be SPECIALIZED rather than plainly worse).
  large_candidate_win_rate <- if (n_cases > 0L) mean(primary_delta > large_loss_pct) else NA_real_

  failure_rate_reference <- mean(per_case$reference_failed)
  failure_rate_candidate <- mean(per_case$candidate_failed)
  failure_rate_increase <- failure_rate_candidate - failure_rate_reference

  wilcoxon_result <- NULL
  if (isTRUE(wilcoxon) && n_cases >= 3L && length(unique(stats::na.omit(primary_delta))) > 1L) {
    # suppressWarnings(): wilcox.test() warns when the deltas contain ties or
    # exact zeroes (normal approximation used instead of the exact
    # distribution) -- expected with a handful of datasets, not a real
    # problem worth surfacing to the caller.
    wilcoxon_result <- tryCatch(
      suppressWarnings(stats::wilcox.test(primary_delta, mu = 0, alternative = "two.sided")),
      error = function(e) NULL
    )
  }

  summary_stats <- list(
    reference = reference,
    candidate = candidate,
    primary_metric = primary_metric,
    n_cases = n_cases,
    wins = wins,
    ties = ties,
    losses = losses,
    win_rate = win_rate,
    win_rate_ci_lower = unname(win_ci["lower"]),
    win_rate_ci_upper = unname(win_ci["upper"]),
    loss_rate = loss_rate,
    tie_rate = tie_rate,
    median_delta = if (n_cases > 0L) stats::median(primary_delta) else NA_real_,
    mean_delta = if (n_cases > 0L) mean(primary_delta) else NA_real_,
    best_delta = if (n_cases > 0L) max(primary_delta) else NA_real_,
    worst_delta = if (n_cases > 0L) min(primary_delta) else NA_real_,
    large_loss_rate = large_loss_rate,
    large_candidate_win_rate = large_candidate_win_rate,
    failure_rate_reference = failure_rate_reference,
    failure_rate_candidate = failure_rate_candidate,
    failure_rate_increase = failure_rate_increase,
    wilcoxon_p_value = if (!is.null(wilcoxon_result)) wilcoxon_result$p.value else NA_real_
  )

  verdict <- comparison_verdict(summary_stats, rules, wilcoxon_requested = isTRUE(wilcoxon))

  structure(
    list(
      per_case = per_case,
      summary = summary_stats,
      wilcoxon = wilcoxon_result,
      rules = rules,
      verdict = verdict
    ),
    class = "estimator_comparison"
  )
}

comparison_verdict <- function(s, rules, wilcoxon_requested) {
  if (is.na(s$n_cases) || s$n_cases < rules$min_cases_for_verdict) {
    return("INSUFFICIENT_EVIDENCE")
  }
  if (!is.na(s$failure_rate_increase) && s$failure_rate_increase > rules$max_failure_rate_increase) {
    return("UNSTABLE")
  }

  sig_improves <- !wilcoxon_requested || (!is.na(s$wilcoxon_p_value) && s$wilcoxon_p_value < rules$alpha && s$median_delta > 0)
  sig_degrades <- !wilcoxon_requested || (!is.na(s$wilcoxon_p_value) && s$wilcoxon_p_value < rules$alpha && s$median_delta < 0)

  superior <- isTRUE(s$win_rate >= rules$min_win_rate) &&
    isTRUE(s$large_loss_rate <= rules$max_large_loss_rate) &&
    isTRUE(s$median_delta >= rules$min_median_delta) &&
    sig_improves

  inferior <- isTRUE(s$loss_rate >= rules$min_win_rate) &&
    isTRUE(s$large_candidate_win_rate <= rules$max_large_loss_rate) &&
    isTRUE(s$median_delta <= -rules$min_median_delta) &&
    sig_degrades

  if (superior) "SUPERIOR" else if (inferior) "INFERIOR" else "EQUIVALENT"
}

#' @export
print.estimator_comparison <- function(x, ...) {
  s <- x$summary
  cat("Reference vs candidate comparison\n")
  cat(sprintf("  Reference       %s\n", s$reference))
  cat(sprintf("  Candidate       %s\n", s$candidate))
  cat(sprintf("  Primary metric  %s\n", s$primary_metric))
  cat(sprintf("  Cases           %d (wins=%d, ties=%d, losses=%d)\n", s$n_cases, s$wins, s$ties, s$losses))
  if (!is.na(s$win_rate)) {
    cat(sprintf(
      "  Win rate        %.1f%% [%.1f%%, %.1f%%] (95%% CI)\n",
      100 * s$win_rate, 100 * s$win_rate_ci_lower, 100 * s$win_rate_ci_upper
    ))
  }
  cat(sprintf("  Median delta    %+.2f%%\n", s$median_delta))
  cat(sprintf("  Worst delta     %+.2f%%\n", s$worst_delta))
  cat(sprintf("  Large-loss rate %.1f%%\n", 100 * s$large_loss_rate))
  if (!is.null(x$wilcoxon)) {
    cat(sprintf("  Wilcoxon p      %.4g\n", s$wilcoxon_p_value))
  }
  if (!is.na(s$failure_rate_increase) && s$failure_rate_increase != 0) {
    cat(sprintf(
      "  Failure rate    reference=%.1f%% candidate=%.1f%% (delta %+.1f pts)\n",
      100 * s$failure_rate_reference, 100 * s$failure_rate_candidate, 100 * s$failure_rate_increase
    ))
  }
  cat(sprintf("  Verdict         %s\n", x$verdict))
  invisible(x)
}
