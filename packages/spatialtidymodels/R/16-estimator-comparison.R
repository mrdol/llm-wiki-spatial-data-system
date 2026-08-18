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
#
# Un "cas" est une paire (dataset, cv_scheme). Un meme dataset evalue sous
# plusieurs schemas de validation croisee produit plusieurs cas -- ce ne sont
# PAS des sources de donnees independantes. compare_estimator_variant() ne
# les melange donc jamais dans un seul test de Wilcoxon/taux de victoire: par
# defaut chaque schema present recoit sa propre comparaison (voir
# compare_estimator_variant_by_scheme()), et un `cv_scheme` explicite
# restreint a un seul schema. La encore, les seuils (min_win_rate, rope,
# etc.) sont des regles de ce projet, pas des constantes scientifiques
# universelles -- ils sont volontairement parametrables via
# comparison_rules().

#' Define the decision thresholds used to turn a comparison into a verdict
#'
#' These thresholds are project conventions, not universal statistical
#' constants -- adjust them to whatever your benchmark protocol actually
#' requires and document the choice alongside your results.
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
#'   reference is not a safe default. When fold-level `n_resamples`/
#'   `n_failed_resamples` are available, the failure rate is computed per
#'   case as `n_failed_resamples / n_resamples` (so a candidate failing 2 of
#'   5 folds counts as 40% failed for that case, even though it still
#'   produced an aggregate RMSE from the other 3); otherwise it falls back to
#'   an all-or-nothing flag (did this case produce a metric at all). Default
#'   `0.05`.
#' @param rope Region of practical equivalence on the primary metric's
#'   relative delta (as a proportion, e.g. `0.01` = 1%). Cases inside
#'   `[-rope, +rope]` count as `"TIE"` rather than `"WIN"`/`"LOSS"`, so a
#'   `+0.001%` improvement isn't counted as a win. It is also the criterion
#'   for a genuine `"EQUIVALENT"` verdict (median delta inside the ROPE),
#'   as opposed to `"INCONCLUSIVE"` (see [compare_estimator_variant()]).
#'   Default `0.01`.
#' @param alpha Significance level for the paired Wilcoxon signed-rank test on
#'   the primary metric's per-case delta. Default `0.05`.
#' @param min_cases_for_verdict Minimum number of valid (non-failed) cases
#'   required before issuing any verdict other than
#'   `"INSUFFICIENT_EVIDENCE"`. Default `10`.
#' @param secondary_guardrails Named numeric vector of maximum tolerated
#'   median relative degradation (as a proportion) on secondary metrics,
#'   e.g. `c(mae = 0.03, moran_abs = 0.05)`. When the primary metric would
#'   otherwise earn a `"SUPERIOR"` verdict but the candidate's median case
#'   degrades a guarded metric beyond its threshold, the verdict becomes
#'   `"TRADEOFF"` instead. Empty by default (no secondary guardrail active)
#'   so existing calls keep their current behaviour unless you opt in.
#' @param max_runtime_multiplier Maximum tolerated ratio of candidate to
#'   reference `duration_sec` (median across cases) before it counts as a
#'   `"TRADEOFF"` guardrail breach, e.g. `5` = candidate may be up to 5x
#'   slower. `NA` (default) disables the check.
#' @param min_cases_for_subgroup Minimum number of cases a subgroup (see the
#'   `groups` argument of [compare_estimator_variant()]) must have before it
#'   can trigger a `"SPECIALIZED"` verdict. Deliberately smaller than
#'   `min_cases_for_verdict` -- subgroups are inherently smaller slices of the
#'   same evidence -- but still a real floor against calling 2 lucky datasets
#'   a "systematic advantage". Default `5`.
#' @param require_significance_for_subgroup If `TRUE`, a subgroup must also
#'   clear its own paired Wilcoxon test (at `alpha`) to count towards
#'   `"SPECIALIZED"`. Default `FALSE`: with `min_cases_for_subgroup` this
#'   small, few subgroups will ever reach significance, so `"SPECIALIZED"` is
#'   treated as an exploratory/hypothesis-generating signal by default, not a
#'   confirmatory one -- documented as such rather than silently unreachable.
#' @param analysis_unit `"task"` (default) treats every `(dataset, cv_scheme)`
#'   case as independent evidence, exactly the current/historical behaviour.
#'   `"source"` first collapses every case sharing the same
#'   `source_dataset_id` (see `dashboard_task_source_counts()`,
#'   `wiki/metadata/dataset_distribution_architecture_2026-08.md`) into one
#'   representative case per source, per `cv_scheme` -- the median of the
#'   per-task relative deltas (primary metric and every secondary/guardrail
#'   metric) across that source's tasks -- before win/tie/loss and the
#'   Wilcoxon test run. This prevents a dataset split into many benchmark
#'   tasks (e.g. `korea_hedonic_housing`'s 32 yearly splits) from outweighing
#'   a source evaluated as a single task just by volume. A source counts as
#'   failed on a side (reference/candidate) only if *every* one of its tasks
#'   failed on that side; failure rates are collapsed the same way (median
#'   across the source's tasks). Requires a dataset -> `source_dataset_id`
#'   mapping: automatic when `suite` is a `spatial_benchmark_suite` (via
#'   `$dataset_metadata`), otherwise pass `dataset_metadata` explicitly to
#'   [compare_estimator_variant()]. `groups` (subgroup analysis) is not
#'   supported yet under `analysis_unit = "source"` -- mixing a source-level
#'   verdict with task-level subgroups would silently blend two different
#'   units of evidence, so it errors instead. Changes which cases feed the
#'   verdict relative to `"task"`, i.e. can change verdicts on existing
#'   benchmarks -- use deliberately, not as a silent default.
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
                             min_cases_for_verdict = 10L,
                             secondary_guardrails = c(),
                             max_runtime_multiplier = NA_real_,
                             min_cases_for_subgroup = 5L,
                             require_significance_for_subgroup = FALSE,
                             analysis_unit = c("task", "source")) {
  analysis_unit <- match.arg(analysis_unit)
  structure(
    list(
      min_win_rate = min_win_rate,
      max_large_loss_rate = max_large_loss_rate,
      large_loss_threshold = large_loss_threshold,
      min_median_delta = min_median_delta,
      max_failure_rate_increase = max_failure_rate_increase,
      rope = rope,
      alpha = alpha,
      min_cases_for_verdict = as.integer(min_cases_for_verdict),
      secondary_guardrails = secondary_guardrails,
      max_runtime_multiplier = max_runtime_multiplier,
      min_cases_for_subgroup = as.integer(min_cases_for_subgroup),
      require_significance_for_subgroup = isTRUE(require_significance_for_subgroup),
      analysis_unit = analysis_unit
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
    min_cases_for_verdict = "Min. cases required for a verdict",
    secondary_guardrails = "Secondary guardrails (metric -> max degradation)",
    max_runtime_multiplier = "Max runtime multiplier",
    min_cases_for_subgroup = "Min. cases required for a SPECIALIZED subgroup",
    require_significance_for_subgroup = "Require Wilcoxon significance per subgroup",
    analysis_unit = "Analysis unit (task = per (dataset, cv_scheme) case, source = median-collapsed per source_dataset_id)"
  )
  scalar_fields <- setdiff(names(x), c("secondary_guardrails"))
  for (nm in scalar_fields) {
    cat(sprintf("  %-45s %s\n", labels[[nm]] %||% nm, format(x[[nm]])))
  }
  if (length(x$secondary_guardrails) > 0L) {
    cat(sprintf("  %-45s %s\n", labels$secondary_guardrails,
                paste(sprintf("%s<=%.1f%%", names(x$secondary_guardrails), 100 * x$secondary_guardrails), collapse = ", ")))
  } else {
    cat(sprintf("  %-45s (none)\n", labels$secondary_guardrails))
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

get_or_na_col <- function(df, col, n = nrow(df)) {
  if (col %in% names(df)) df[[col]] else rep(NA_real_, n)
}

case_failure_rate <- function(n_failed, n_total, totally_failed) {
  # Fold-level rate when n_resamples/n_failed_resamples are available
  # (0 <= rate <= 1, e.g. 2 failed folds out of 5 -> 0.4 even though an
  # aggregate metric was still produced from the other 3). Falls back to an
  # all-or-nothing flag when those columns are absent (older/synthetic
  # results) -- a totally failed case is rate 1, otherwise rate 0.
  has_fold_info <- !is.na(n_failed) & !is.na(n_total) & n_total > 0
  ifelse(has_fold_info, n_failed / n_total, ifelse(totally_failed, 1, 0))
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
#' A "case" is a (dataset, cv_scheme) pair. The same dataset evaluated under
#' several CV schemes produces several cases that are **not** independent
#' data sources, so this function never pools them into one statistical test
#' silently. If `results` contains more than one CV scheme for the pair of
#' estimators being compared and `cv_scheme` is left `NULL`, it returns an
#' `estimator_comparison_by_scheme` object -- a named list with one
#' independent `estimator_comparison` per scheme -- instead of a single
#' comparison mixing schemes. Pass `cv_scheme` (a single scheme, or a
#' character vector of schemes) to control this explicitly; with exactly one
#' scheme to process, a plain `estimator_comparison` is returned.
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
#' @param cv_scheme `NULL` (default) to auto-detect: a single scheme present
#'   is compared directly, multiple schemes are compared independently and
#'   returned as an `estimator_comparison_by_scheme`. Pass a single scheme
#'   name to restrict to it, or a character vector of schemes to force the
#'   by-scheme comparison over exactly those.
#' @param primary_metric Metric that drives the win/tie/loss classification
#'   and the verdict. Default `"rmse"`.
#' @param secondary_metrics Additional metrics to report deltas for. Any
#'   metric named in `rules$secondary_guardrails` is added automatically even
#'   if omitted here, since its delta must exist for the guardrail to apply.
#'   Default `c("mae", "moran_abs", "duration_sec")`.
#' @param lower_is_better Named logical vector giving the direction of each
#'   metric referenced above (`TRUE` = lower is better). Metrics not listed
#'   default to `TRUE`.
#' @param rules A [comparison_rules()] object. Default `comparison_rules()`.
#' @param wilcoxon If `TRUE` (default), run a paired Wilcoxon signed-rank test
#'   on the primary metric's per-case delta and require significance (at
#'   `rules$alpha`) for a `"SUPERIOR"`/`"INFERIOR"` verdict. Set `FALSE` to
#'   fall back to pure threshold counting.
#' @param groups Optional subgroup analysis: a `data.frame` with a `dataset`
#'   column and exactly one grouping column (e.g. an N bucket, a domain
#'   label, a geometry type -- anything you supply, this function does not
#'   compute meta-features itself). When the candidate is not globally
#'   `"SUPERIOR"`/`"INFERIOR"` (i.e. the verdict would otherwise be
#'   `"EQUIVALENT"` or `"INCONCLUSIVE"`), each group's own win rate is
#'   checked against `rules$min_win_rate`/`rules$min_cases_for_subgroup`; if
#'   any group qualifies, the verdict becomes `"SPECIALIZED"` instead --
#'   "not better everywhere, but systematically better on this identifiable
#'   subset". The full per-group breakdown is always returned in
#'   `$subgroups$table`, whether or not it changed the verdict. `NULL`
#'   (default) skips subgroup analysis entirely -- existing calls are
#'   unaffected. Not supported when `rules$analysis_unit == "source"` (errors).
#' @param dataset_metadata Only used when `rules$analysis_unit == "source"`:
#'   a `data.frame` with `dataset` and `source_dataset_id` columns, giving the
#'   mapping used to collapse tasks into sources. `NULL` (default) auto-fills
#'   from `suite$dataset_metadata` when `suite` is a `spatial_benchmark_suite`;
#'   required explicitly when `suite` is a plain results `data.frame`.
#'
#' @return An `estimator_comparison` object (or `estimator_comparison_by_scheme`
#'   when multiple CV schemes are in play) with `per_case` (one row per case),
#'   `summary` (aggregate statistics, including the CV scheme it covers),
#'   `guardrails` (secondary-guardrail breaches and their values), `subgroups`
#'   (per-group breakdown when `groups` was supplied, else `NULL`), `wilcoxon`
#'   (the `htest` result, or `NULL`), `rules`, `verdict` and
#'   `verdict_reasons` (why that verdict, not just what it is).
#' @export
compare_estimator_variant <- function(suite,
                                      reference,
                                      candidate,
                                      cv_scheme = NULL,
                                      primary_metric = "rmse",
                                      secondary_metrics = c("mae", "moran_abs", "duration_sec"),
                                      lower_is_better = c(
                                        rmse = TRUE, mae = TRUE,
                                        moran_abs = TRUE, duration_sec = TRUE
                                      ),
                                      rules = comparison_rules(),
                                      wilcoxon = TRUE,
                                      groups = NULL,
                                      dataset_metadata = NULL) {
  results <- if (inherits(suite, "spatial_benchmark_suite")) suite$results else suite
  if (!is.data.frame(results)) {
    stop("`suite` doit etre un spatial_benchmark_suite ou un data.frame de resultats.", call. = FALSE)
  }
  if (!"cv_scheme" %in% names(results)) {
    stop("Colonnes manquantes dans les resultats: cv_scheme", call. = FALSE)
  }

  if (identical(rules$analysis_unit, "source")) {
    if (!is.null(groups)) {
      stop(
        paste(
          "`groups` (analyse de sous-groupes) n'est pas supporte avec",
          "analysis_unit = \"source\": melanger un verdict agrege par source",
          "avec des sous-groupes definis par tache melangerait deux unites",
          "d'evidence differentes. Utilisez analysis_unit = \"task\" pour",
          "l'analyse de sous-groupes, ou retirez `groups`."
        ),
        call. = FALSE
      )
    }
    if (is.null(dataset_metadata)) {
      dataset_metadata <- if (inherits(suite, "spatial_benchmark_suite")) {
        suite$dataset_metadata[, c("dataset", "source_dataset_id"), drop = FALSE]
      } else {
        NULL
      }
    }
    if (is.null(dataset_metadata) || !all(c("dataset", "source_dataset_id") %in% names(dataset_metadata))) {
      stop(
        paste(
          "analysis_unit = \"source\" necessite un mapping dataset ->",
          "source_dataset_id. Passez `suite` en tant que spatial_benchmark_suite",
          "(qui l'expose via $dataset_metadata), ou fournissez explicitement",
          "`dataset_metadata` (data.frame avec les colonnes dataset,",
          "source_dataset_id) a compare_estimator_variant()."
        ),
        call. = FALSE
      )
    }
  }

  schemes_to_run <- cv_scheme
  if (is.null(schemes_to_run)) {
    present <- results$cv_scheme[results$estimator %in% c(reference, candidate)]
    schemes_to_run <- unique(present)
  }

  if (length(schemes_to_run) > 1L) {
    out <- stats::setNames(
      lapply(schemes_to_run, function(scheme) {
        compare_estimator_variant_single(
          results = results[results$cv_scheme == scheme, , drop = FALSE],
          reference = reference, candidate = candidate, cv_scheme_label = scheme,
          primary_metric = primary_metric, secondary_metrics = secondary_metrics,
          lower_is_better = lower_is_better, rules = rules, wilcoxon = wilcoxon, groups = groups,
          dataset_metadata = dataset_metadata
        )
      }),
      schemes_to_run
    )
    return(structure(out, class = "estimator_comparison_by_scheme"))
  }

  scheme_label <- if (length(schemes_to_run) == 1L) schemes_to_run else NA_character_
  filtered <- if (length(schemes_to_run) == 1L) results[results$cv_scheme == schemes_to_run, , drop = FALSE] else results
  compare_estimator_variant_single(
    results = filtered, reference = reference, candidate = candidate, cv_scheme_label = scheme_label,
    primary_metric = primary_metric, secondary_metrics = secondary_metrics,
    lower_is_better = lower_is_better, rules = rules, wilcoxon = wilcoxon, groups = groups,
    dataset_metadata = dataset_metadata
  )
}

compare_estimator_variant_single <- function(results, reference, candidate, cv_scheme_label,
                                             primary_metric, secondary_metrics, lower_is_better,
                                             rules, wilcoxon, groups = NULL, dataset_metadata = NULL) {
  guardrail_metrics <- names(rules$secondary_guardrails)
  metrics <- unique(c(primary_metric, secondary_metrics, guardrail_metrics))
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

  merged$reference_failed <- is.na(merged[[primary_ref_col]])
  merged$candidate_failed <- is.na(merged[[primary_cand_col]])

  # Fold-level failure rate per case (falls back to the all-or-nothing flag
  # above when n_resamples/n_failed_resamples aren't in the results table).
  merged$reference_failure_rate <- case_failure_rate(
    get_or_na_col(merged, "n_failed_resamples_reference"),
    get_or_na_col(merged, "n_resamples_reference"),
    merged$reference_failed
  )
  merged$candidate_failure_rate <- case_failure_rate(
    get_or_na_col(merged, "n_failed_resamples_candidate"),
    get_or_na_col(merged, "n_resamples_candidate"),
    merged$candidate_failed
  )

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
    "reference_failed", "candidate_failed",
    "reference_failure_rate", "candidate_failure_rate", "outcome"
  )
  per_case <- merged[, intersect(ordered_cols, names(merged)), drop = FALSE]
  row.names(per_case) <- NULL

  if (identical(rules$analysis_unit, "source")) {
    per_case <- collapse_per_case_to_source(per_case, dataset_metadata, primary_metric, rope_pct)
  }

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

  # Failure rate: mean of the PER-CASE rate (fold-level when available),
  # across ALL cases including totally-failed ones -- not just `valid`.
  failure_rate_reference <- mean(per_case$reference_failure_rate)
  failure_rate_candidate <- mean(per_case$candidate_failure_rate)
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

  guardrails <- evaluate_secondary_guardrails(valid, rules)
  subgroups <- compute_subgroup_analysis(valid, groups, primary_metric, rules)

  summary_stats <- list(
    reference = reference,
    candidate = candidate,
    cv_scheme = cv_scheme_label,
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
    failure_rate_fold_level = any(!is.na(get_or_na_col(merged, "n_resamples_reference"))) ||
      any(!is.na(get_or_na_col(merged, "n_resamples_candidate"))),
    wilcoxon_p_value = if (!is.null(wilcoxon_result)) wilcoxon_result$p.value else NA_real_
  )

  verdict_info <- comparison_verdict(
    summary_stats, rules, wilcoxon_requested = isTRUE(wilcoxon),
    guardrails = guardrails, subgroups = subgroups
  )

  structure(
    list(
      per_case = per_case,
      summary = summary_stats,
      guardrails = guardrails,
      subgroups = subgroups,
      wilcoxon = wilcoxon_result,
      rules = rules,
      verdict = verdict_info$verdict,
      verdict_reasons = verdict_info$reasons
    ),
    class = "estimator_comparison"
  )
}

collapse_per_case_to_source <- function(per_case, dataset_metadata, primary_metric, rope_pct) {
  # Collapses one row per (dataset, cv_scheme) task down to one row per
  # source_dataset_id, so a dataset split into many benchmark tasks (e.g.
  # korea_hedonic_housing's 32 yearly splits) contributes exactly one piece
  # of evidence to win/tie/loss and the Wilcoxon test, same as a source
  # evaluated as a single task. Every delta_ and raw metric column is
  # collapsed via median across the source's tasks (na.rm = TRUE, so a
  # failed task's NA delta doesn't count); reference_failed/candidate_failed
  # are TRUE only if EVERY task for that source failed on that side. A
  # dataset absent from `dataset_metadata` becomes its own source, mirroring
  # build_suite_dataset_metadata()'s fallback.
  src_map <- unique(dataset_metadata[, c("dataset", "source_dataset_id"), drop = FALSE])
  per_case$source_dataset_id <- src_map$source_dataset_id[match(per_case$dataset, src_map$dataset)]
  missing_src <- is.na(per_case$source_dataset_id)
  per_case$source_dataset_id[missing_src] <- per_case$dataset[missing_src]

  numeric_cols <- names(per_case)[vapply(per_case, is.numeric, logical(1))]

  rows <- lapply(split(per_case, per_case$source_dataset_id), function(g) {
    out <- list(
      dataset = g$source_dataset_id[[1]],
      source_dataset_id = g$source_dataset_id[[1]],
      cv_scheme = g$cv_scheme[[1]],
      reference = g$reference[[1]],
      candidate = g$candidate[[1]],
      n_tasks = nrow(g)
    )
    for (col in numeric_cols) {
      out[[col]] <- stats::median(g[[col]], na.rm = TRUE)
    }
    out$reference_failed <- all(g$reference_failed)
    out$candidate_failed <- all(g$candidate_failed)
    as.data.frame(out, stringsAsFactors = FALSE)
  })
  collapsed <- do.call(rbind, rows)
  row.names(collapsed) <- NULL

  delta_primary_col <- paste0("delta_", primary_metric)
  collapsed$outcome <- classify_outcome(collapsed[[delta_primary_col]], rope_pct)
  collapsed$outcome[collapsed$reference_failed & collapsed$candidate_failed] <- "BOTH_FAILED"
  collapsed$outcome[collapsed$reference_failed & !collapsed$candidate_failed] <- "REFERENCE_FAILED"
  collapsed$outcome[!collapsed$reference_failed & collapsed$candidate_failed] <- "CANDIDATE_FAILED"

  collapsed
}

compute_subgroup_analysis <- function(valid, groups, primary_metric, rules) {
  if (is.null(groups)) return(NULL)
  if (!is.data.frame(groups) || !"dataset" %in% names(groups)) {
    stop("`groups` doit etre un data.frame avec une colonne `dataset` et exactement une colonne de regroupement.", call. = FALSE)
  }
  group_col <- setdiff(names(groups), "dataset")
  if (length(group_col) != 1L) {
    stop("`groups` doit avoir exactement une colonne de regroupement en plus de `dataset` (une seule dimension a la fois).", call. = FALSE)
  }
  group_col <- group_col[[1]]

  merged <- merge(valid, groups, by = "dataset", all.x = TRUE)
  merged <- merged[!is.na(merged[[group_col]]), , drop = FALSE]
  empty_table <- data.frame(
    group = character(0), n_cases = integer(0), wins = integer(0), losses = integer(0),
    win_rate = numeric(0), median_delta = numeric(0), large_loss_rate = numeric(0),
    wilcoxon_p_value = numeric(0), eligible = logical(0), stringsAsFactors = FALSE
  )
  if (nrow(merged) == 0L) {
    return(list(dimension = group_col, table = empty_table, specialized_in = character(0)))
  }

  delta_col <- paste0("delta_", primary_metric)
  rope_pct <- 100 * rules$rope
  large_loss_pct <- 100 * rules$large_loss_threshold

  rows <- lapply(split(merged, merged[[group_col]]), function(g) {
    delta <- g[[delta_col]]
    n <- nrow(g)
    wins <- sum(g$outcome == "WIN")
    losses <- sum(g$outcome == "LOSS")
    p_value <- NA_real_
    if (n >= 3L && length(unique(stats::na.omit(delta))) > 1L) {
      wt <- tryCatch(suppressWarnings(stats::wilcox.test(delta, mu = 0, alternative = "two.sided")), error = function(e) NULL)
      if (!is.null(wt)) p_value <- wt$p.value
    }
    data.frame(
      group = as.character(g[[group_col]][[1]]),
      n_cases = n,
      wins = wins,
      losses = losses,
      win_rate = if (n > 0L) wins / n else NA_real_,
      median_delta = if (n > 0L) stats::median(delta) else NA_real_,
      large_loss_rate = if (n > 0L) mean(delta < -large_loss_pct) else NA_real_,
      wilcoxon_p_value = p_value,
      stringsAsFactors = FALSE
    )
  })
  table <- do.call(rbind, rows)
  row.names(table) <- NULL

  sig_ok <- !rules$require_significance_for_subgroup |
    (!is.na(table$wilcoxon_p_value) & table$wilcoxon_p_value < rules$alpha)
  table$eligible <-
    table$n_cases >= rules$min_cases_for_subgroup &
    !is.na(table$win_rate) & table$win_rate >= rules$min_win_rate &
    !is.na(table$large_loss_rate) & table$large_loss_rate <= rules$max_large_loss_rate &
    sig_ok
  table <- table[order(-table$win_rate, -table$n_cases), , drop = FALSE]
  row.names(table) <- NULL

  list(dimension = group_col, table = table, specialized_in = table$group[table$eligible])
}

evaluate_secondary_guardrails <- function(valid, rules) {
  # Median-case degradation per guarded metric, plus an optional runtime
  # multiplier check. Returns breaches (character, empty if none) and the
  # raw values (for display/debugging), never mutates the verdict itself --
  # comparison_verdict() decides what to do with a breach.
  breaches <- character(0)
  details <- list()

  for (metric_name in names(rules$secondary_guardrails)) {
    threshold <- rules$secondary_guardrails[[metric_name]]
    delta_col <- paste0("delta_", metric_name)
    if (!delta_col %in% names(valid) || nrow(valid) == 0L) next
    median_delta <- stats::median(valid[[delta_col]], na.rm = TRUE)
    details[[metric_name]] <- median_delta
    if (!is.na(median_delta) && median_delta < -100 * threshold) {
      breaches <- c(breaches, sprintf(
        "%s (delta median %+.1f%%, seuil -%.1f%%)", metric_name, median_delta, 100 * threshold
      ))
    }
  }

  if (!is.na(rules$max_runtime_multiplier) &&
        all(c("duration_sec_reference", "duration_sec_candidate") %in% names(valid)) &&
        nrow(valid) > 0L) {
    ratio <- valid$duration_sec_candidate / valid$duration_sec_reference
    median_ratio <- stats::median(ratio, na.rm = TRUE)
    details[["runtime_multiplier"]] <- median_ratio
    if (!is.na(median_ratio) && median_ratio > rules$max_runtime_multiplier) {
      breaches <- c(breaches, sprintf(
        "runtime (candidat %.1fx plus lent, max toleré %.1fx)", median_ratio, rules$max_runtime_multiplier
      ))
    }
  }

  list(breaches = breaches, details = details)
}

comparison_verdict <- function(s, rules, wilcoxon_requested, guardrails, subgroups = NULL) {
  if (is.na(s$n_cases) || s$n_cases < rules$min_cases_for_verdict) {
    return(list(
      verdict = "INSUFFICIENT_EVIDENCE",
      reasons = sprintf("n_cases (%s) < min_cases_for_verdict (%d)", format(s$n_cases), rules$min_cases_for_verdict)
    ))
  }
  if (!is.na(s$failure_rate_increase) && s$failure_rate_increase > rules$max_failure_rate_increase) {
    return(list(
      verdict = "UNSTABLE",
      reasons = sprintf(
        "failure_rate_increase (%.1f%%) > max_failure_rate_increase (%.1f%%)%s",
        100 * s$failure_rate_increase, 100 * rules$max_failure_rate_increase,
        if (isTRUE(s$failure_rate_fold_level)) " [fold-level]" else " [fallback: all-or-nothing]"
      )
    ))
  }

  sig_improves <- !wilcoxon_requested || (!is.na(s$wilcoxon_p_value) && s$wilcoxon_p_value < rules$alpha && s$median_delta > 0)
  sig_degrades <- !wilcoxon_requested || (!is.na(s$wilcoxon_p_value) && s$wilcoxon_p_value < rules$alpha && s$median_delta < 0)

  superior_core <- isTRUE(s$win_rate >= rules$min_win_rate) &&
    isTRUE(s$large_loss_rate <= rules$max_large_loss_rate) &&
    isTRUE(s$median_delta >= rules$min_median_delta) &&
    sig_improves

  inferior_core <- isTRUE(s$loss_rate >= rules$min_win_rate) &&
    isTRUE(s$large_candidate_win_rate <= rules$max_large_loss_rate) &&
    isTRUE(s$median_delta <= -rules$min_median_delta) &&
    sig_degrades

  # A genuine equivalence claim requires the typical case to sit inside the
  # ROPE -- NOT simply "neither SUPERIOR nor INFERIOR was reached" (that
  # absence of evidence is INCONCLUSIVE, see below).
  practically_equivalent <- !is.na(s$median_delta) && abs(s$median_delta) <= 100 * rules$rope

  if (isTRUE(superior_core)) {
    if (length(guardrails$breaches) > 0L) {
      return(list(
        verdict = "TRADEOFF",
        reasons = sprintf(
          "%s superieur sur %s mais guardrail(s) secondaire(s) depasse(s): %s",
          s$candidate, s$primary_metric, paste(guardrails$breaches, collapse = "; ")
        )
      ))
    }
    return(list(verdict = "SUPERIOR", reasons = character(0)))
  }
  if (isTRUE(inferior_core)) {
    return(list(verdict = "INFERIOR", reasons = character(0)))
  }

  # No global directional signal (would otherwise be EQUIVALENT or
  # INCONCLUSIVE) -- check whether the candidate is nonetheless
  # systematically better on an identifiable subgroup before settling on
  # either. "Not better everywhere, but reliably better here" is a different,
  # more useful claim than either EQUIVALENT or INCONCLUSIVE.
  if (!is.null(subgroups) && length(subgroups$specialized_in) > 0L) {
    return(list(
      verdict = "SPECIALIZED",
      reasons = sprintf(
        "pas de superiorite globale, mais avantage systematique sur %s = %s (voir $subgroups$table)%s",
        subgroups$dimension,
        paste(sprintf("'%s'", subgroups$specialized_in), collapse = ", "),
        if (!rules$require_significance_for_subgroup) " -- signal exploratoire, significativite par sous-groupe non exigee" else ""
      )
    ))
  }

  if (practically_equivalent) {
    return(list(
      verdict = "EQUIVALENT",
      reasons = sprintf(
        "delta median (%+.2f%%) dans la ROPE (+-%.1f%%) et aucun seuil directionnel atteint",
        s$median_delta, 100 * rules$rope
      )
    ))
  }
  list(
    verdict = "INCONCLUSIVE",
    reasons = sprintf(
      "ni un seuil directionnel (win_rate=%.1f%%, loss_rate=%.1f%%) ni l'equivalence pratique (delta median %+.2f%% hors ROPE +-%.1f%%) ne sont atteints",
      100 * (s$win_rate %||% NA_real_), 100 * (s$loss_rate %||% NA_real_), s$median_delta, 100 * rules$rope
    )
  )
}

#' @export
print.estimator_comparison <- function(x, ...) {
  s <- x$summary
  cat("Reference vs candidate comparison\n")
  cat(sprintf("  Reference       %s\n", s$reference))
  cat(sprintf("  Candidate       %s\n", s$candidate))
  if (!is.null(s$cv_scheme) && !is.na(s$cv_scheme)) {
    cat(sprintf("  CV scheme       %s\n", s$cv_scheme))
  }
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
      "  Failure rate    reference=%.1f%% candidate=%.1f%% (delta %+.1f pts)%s\n",
      100 * s$failure_rate_reference, 100 * s$failure_rate_candidate, 100 * s$failure_rate_increase,
      if (isTRUE(s$failure_rate_fold_level)) "" else " [fallback: all-or-nothing]"
    ))
  }
  if (length(x$guardrails$breaches) > 0L) {
    cat("  Guardrail breach", if (length(x$guardrails$breaches) > 1L) "es" else "", ":\n", sep = "")
    for (b in x$guardrails$breaches) cat(sprintf("    - %s\n", b))
  }
  if (!is.null(x$subgroups) && nrow(x$subgroups$table) > 0L) {
    cat(sprintf("  Subgroups (%s):\n", x$subgroups$dimension))
    for (i in seq_len(nrow(x$subgroups$table))) {
      g <- x$subgroups$table[i, ]
      cat(sprintf(
        "    %s%-20s n=%-3d win_rate=%5.1f%% median_delta=%+.2f%%\n",
        if (isTRUE(g$eligible)) "* " else "  ", g$group, g$n_cases, 100 * g$win_rate, g$median_delta
      ))
    }
  }
  cat(sprintf("  Verdict         %s\n", x$verdict))
  if (length(x$verdict_reasons) > 0L) {
    cat(sprintf("  Reason          %s\n", paste(x$verdict_reasons, collapse = " ")))
  }
  invisible(x)
}

#' @export
print.estimator_comparison_by_scheme <- function(x, ...) {
  cat("Reference vs candidate comparison, by CV scheme\n")
  cat(sprintf("  %d scheme(s): %s\n", length(x), paste(names(x), collapse = ", ")))
  for (scheme in names(x)) {
    cat(sprintf("\n== %s ==\n", scheme))
    print(x[[scheme]])
  }
  invisible(x)
}
