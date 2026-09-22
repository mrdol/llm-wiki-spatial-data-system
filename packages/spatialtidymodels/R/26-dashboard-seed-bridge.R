# Pont entre un benchmark multi-graines ad hoc (tools/bench_inla_multiseed.R,
# CSV bruts par (jeu, graine) hors du harnais tune::tune_grid()/rsample) et le
# dashboard Shiny (R/18- a R/25-dashboard-*.R), qui consomme un
# spatial_benchmark_suite ou sa table $results.
#
# Un "cas" pour compare_estimator_variant() (R/16) est une paire
# (dataset, cv_scheme), jointe par un merge() -- si plusieurs graines
# partageaient le meme (dataset, cv_scheme), le merge deviendrait many-to-many
# et fabriquerait de faux cas (graine 11 de reference appariee a la graine 22
# du candidat). Chaque graine devient donc un DATASET distinct ("<jeu>__s<graine>"),
# cv_scheme restant fixe -- exactement le patron deja utilise pour un jeu source
# eclate en plusieurs benchmark_task (ex. korea_hedonic_housing, 32 tranches
# annuelles, voir analysis_unit = "source" dans R/16). dataset_metadata$
# source_dataset_id relie les graines d'un meme jeu, ce qui rend
# analysis_unit = "source" utilisable tel quel pour agreger les graines.

#' Reconstruct a `spatial_benchmark_suite` from `tools/bench_inla_multiseed.R` output
#'
#' Reads every `<dataset>_s<seed>_folds.csv` / `_preds.csv` pair in `dir`,
#' recomputes per-estimator metrics from the pooled fold predictions (same
#' convention as [summarize_resample_results()]: RMSE/MAE/etc. computed once
#' on every test prediction concatenated across folds, not averaged per-fold
#' first), and assembles a `spatial_benchmark_suite` the dashboard can consume
#' directly via [launch_benchmark_dashboard()].
#'
#' Each (dataset, seed) becomes its own `dataset` row, named
#' `"<dataset>__s<seed>"` -- see the file header for why a seed cannot share a
#' `cv_scheme` with another seed of the same dataset. `dataset_metadata`
#' carries `source_dataset_id` (the real dataset name, shared across its
#' seeds), `seed`, `response_typology` and `spatio_temporal` (`TRUE` when the
#' run declared a time column, i.e. `inla_spde_st` was eligible) for the
#' dashboard's filters and subgroup analysis.
#'
#' Residual spatial autocorrelation (`moran_i`/`moran_abs`) was never computed
#' by this ad hoc benchmark (only `truth`/`pred`/timing/INLA diagnostics were
#' recorded per fold) -- both columns come back all-`NA`, same handling as any
#' other suite missing them (guardrails and the Overview/Comparison plots that
#' depend on them degrade gracefully, never error).
#'
#' @param dir Directory containing the `_folds.csv`/`_preds.csv` files (e.g.
#'   `"data/manifests/runs/inla_multiseed_2026-09-22"`).
#' @param cv_scheme_label Fixed `cv_scheme` value assigned to every row --
#'   describes the actual validation scheme used (5-fold spatial-block CV,
#'   k-means blocks assigned to folds), not the seed. Default
#'   `"block_spatial"`, the existing convention's name for this scheme (see
#'   [make_spatial_resamples()]).
#'
#' @return A `spatial_benchmark_suite` object (same class/shape as
#'   [benchmark_spatial_suite()]'s return value): `results`,
#'   `dataset_metadata`, `datasets`, `estimators`, `cv_schemes`, `failures`,
#'   `protocol`.
#' @export
dashboard_suite_from_seed_runs <- function(dir, cv_scheme_label = "block_spatial") {
  if (!dir.exists(dir)) stop(sprintf("Dossier introuvable: %s", dir), call. = FALSE)
  fold_files <- list.files(dir, pattern = "^.+_s[0-9]+_folds\\.csv$", full.names = TRUE)
  if (length(fold_files) == 0L) {
    stop(sprintf("Aucun fichier '<jeu>_s<graine>_folds.csv' trouve dans %s.", dir), call. = FALSE)
  }

  parse_tag <- function(path) {
    tag <- sub("_folds\\.csv$", "", basename(path))
    m <- regmatches(tag, regexec("^(.+)_s([0-9]+)$", tag))[[1]]
    if (length(m) != 3L) stop(sprintf("Nom de fichier inattendu (attendu '<jeu>_s<graine>_folds.csv'): %s", basename(path)), call. = FALSE)
    list(dataset = m[2], seed = as.integer(m[3]), tag = tag)
  }

  result_rows <- list()
  meta_rows <- list()
  for (path in fold_files) {
    id <- parse_tag(path)
    preds_path <- file.path(dir, paste0(id$tag, "_preds.csv"))
    folds <- utils::read.csv(path, stringsAsFactors = FALSE)
    preds <- if (file.exists(preds_path)) utils::read.csv(preds_path, stringsAsFactors = FALSE) else NULL
    dataset_label <- sprintf("%s__s%d", id$dataset, id$seed)
    response_typology <- if (!is.null(preds) && "typ" %in% names(preds) && nrow(preds) > 0L) preds$typ[[1]] else NA_character_
    # inla_spde_st n'apparait dans les estimateurs testes que si le jeu avait
    # une colonne temporelle declaree (voir tools/bench_inla_multiseed.R) --
    # marqueur direct et sans ambiguite du caractere spatio-temporel du jeu,
    # plus fiable ici qu'une relecture du registre (qui peut diverger de ce
    # qui a reellement tourne).
    spatio_temporal <- any(grepl("^inla_spde_st", unique(folds$estimator)))
    # Nombre total de sites : les folds de test partitionnent l'integralite du
    # jeu (chaque site est teste exactement une fois sur les 5 folds), donc la
    # somme des tailles de test sur les 5 folds d'un estimateur qui ne peut
    # jamais echouer (baseline_mean, prediction constante) redonne N.
    n_obs <- if (!is.null(preds) && "baseline_mean" %in% preds$estimator) {
      nrow(preds[preds$estimator == "baseline_mean", , drop = FALSE])
    } else {
      NA_integer_
    }

    for (est in unique(folds$estimator)) {
      frows <- folds[folds$estimator == est, , drop = FALSE]
      prows <- if (!is.null(preds)) preds[preds$estimator == est, , drop = FALSE] else NULL
      ok <- is.na(frows$error) | frows$error == ""
      n_resamples <- nrow(frows)
      n_failed <- sum(!ok)

      per_fold_rmse <- NA_real_
      global <- list(rmse = NA_real_, mae = NA_real_, accuracy = NA_real_, auc = NA_real_, deviance = NA_real_)
      n_pooled <- 0L
      if (!is.null(prows) && nrow(prows) > 0L) {
        finite <- is.finite(prows$truth) & is.finite(prows$pred)
        pr <- prows[finite, , drop = FALSE]
        if (nrow(pr) > 0L) {
          global <- make_metric_values(pr$truth, pr$pred, response_typology = response_typology)
          n_pooled <- nrow(pr)
          per_fold <- vapply(split(pr, pr$fold), function(g) sqrt(mean((g$pred - g$truth)^2)), numeric(1))
          per_fold_rmse <- if (length(per_fold) > 1L) stats::sd(per_fold) else NA_real_
        }
      }

      result_rows[[length(result_rows) + 1L]] <- data.frame(
        dataset = dataset_label,
        cv_scheme = cv_scheme_label,
        estimator = est,
        n = n_pooled,
        response = NA_character_,
        rmse = global$rmse, mae = global$mae,
        accuracy = global$accuracy, auc = global$auc, deviance = global$deviance,
        rmse_sd = per_fold_rmse, mae_sd = NA_real_,
        duration_sec = if (any(!is.na(frows$elapsed))) sum(frows$elapsed, na.rm = TRUE) else NA_real_,
        aicc = NA_real_, logLik = NA_real_, spatial_param = NA_character_, spatial_value = NA_real_,
        moran_i = NA_real_, moran_abs = NA_real_, moran_p_value = NA_real_, moran_error = NA_character_,
        n_resamples = n_resamples, n_failed_resamples = n_failed,
        fit_error = if (n_failed > 0L) paste(unique(frows$error[!ok]), collapse = " | ") else NA_character_,
        inla_mlik_median = if (any(is.finite(frows$mlik))) stats::median(frows$mlik, na.rm = TRUE) else NA_real_,
        inla_attempts_max = if ("attempts" %in% names(frows) && any(is.finite(frows$attempts))) max(frows$attempts, na.rm = TRUE) else NA_integer_,
        stringsAsFactors = FALSE
      )
    }

    meta_rows[[length(meta_rows) + 1L]] <- data.frame(
      dataset = dataset_label,
      source_dataset_id = id$dataset,
      benchmark_task_id = dataset_label,
      parent_dataset = NA_character_,
      n = n_obs,
      p = NA_integer_,
      formula_role = NA_character_,
      benchmark_ready = NA,
      seed = id$seed,
      response_typology = response_typology,
      spatio_temporal = spatio_temporal,
      stringsAsFactors = FALSE
    )
  }

  results <- do.call(rbind, result_rows)
  row.names(results) <- NULL
  dataset_metadata <- do.call(rbind, meta_rows)
  row.names(dataset_metadata) <- NULL

  failures <- results[!is.na(results$fit_error), , drop = FALSE]

  structure(
    list(
      results = results,
      dataset_metadata = dataset_metadata,
      datasets = unique(results$dataset),
      estimators = sort(unique(results$estimator)),
      cv_schemes = unique(results$cv_scheme),
      failures = failures,
      protocol = list(
        source = "tools/bench_inla_multiseed.R",
        dir = normalizePath(dir, mustWork = FALSE),
        cv_scheme = cv_scheme_label,
        seeds = sort(unique(dataset_metadata$seed)),
        fold_timeout_sec = NA_real_
      )
    ),
    class = "spatial_benchmark_suite"
  )
}
