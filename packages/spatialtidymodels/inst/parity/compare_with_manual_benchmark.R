# Comparaison de parite avec le benchmark manuel.
#
# A lancer depuis la racine du depot, apres un run manuel qui a produit:
# - data/manifests/runs/resamples_<dataset>_2026-07.rds
# - data/manifests/runs/benchmark_manual_predictions_<dataset>_2026-07.rds
#
# Exemple:
#   source("packages/spatialtidymodels/inst/parity/compare_with_manual_benchmark.R")
#   out <- run_spatialtidymodels_parity_check("columbus_crime",
#     estimators = c("sar_lag", "sem_error", "sdm_mixed")
#   )

compare_prediction_vectors <- function(package_predictions, manual_predictions,
                                       tolerance = 1e-8) {
  stopifnot(length(package_predictions) == length(manual_predictions))
  delta <- abs(package_predictions - manual_predictions)
  data.frame(
    n = length(delta),
    max_abs_diff = max(delta, na.rm = TRUE),
    mean_abs_diff = mean(delta, na.rm = TRUE),
    parity_ok = isTRUE(max(delta, na.rm = TRUE) <= tolerance),
    stringsAsFactors = FALSE
  )
}

load_parity_context <- function(repo_root = normalizePath(".")) {
  # Charge le benchmark manuel pour reutiliser DATASETS, prep_dataset() et les
  # fonctions de formule, puis charge le package local spatialtidymodels. Les
  # fonctions package sont toujours appelees avec spatialtidymodels:: pour ne
  # pas confondre les wrappers source() historiques avec le package.
  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(file.path(repo_root, "code"))
  source("R/estimators/benchmark_manual_test_2026-07.R")
  setwd(repo_root)
  if (requireNamespace("pkgload", quietly = TRUE)) {
    pkgload::load_all(file.path(repo_root, "packages/spatialtidymodels"), quiet = TRUE)
  } else {
    library(spatialtidymodels)
  }
  invisible(TRUE)
}

prepare_parity_dataset <- function(dataset, repo_root = normalizePath(".")) {
  # Reconstruit exactement le data.frame prepare par le benchmark manuel,
  # y compris .row_id, pour que les indices sauvegardes pointent sur les memes
  # observations.
  if (!exists("DATASETS", inherits = TRUE)) {
    stop("DATASETS introuvable: appelez load_parity_context() d'abord.", call. = FALSE)
  }
  spec <- DATASETS[[dataset]]
  if (is.null(spec)) {
    stop(sprintf("Dataset inconnu: %s", dataset), call. = FALSE)
  }
  old_wd <- getwd()
  on.exit(setwd(old_wd), add = TRUE)
  setwd(file.path(repo_root, "code"))
  df <- prep_dataset(spec)
  df$.row_id <- seq_len(nrow(df))
  list(spec = spec, data = df)
}

split_from_manifest <- function(df, manifest, cv_scheme, fold) {
  # Reconstruit un split rsample depuis le manifeste compact train/test.
  rows <- manifest[manifest$cv_scheme == cv_scheme & manifest$fold == fold, ]
  if (nrow(rows) == 0L) {
    stop(sprintf("Split introuvable: %s / %s", cv_scheme, fold), call. = FALSE)
  }
  train_ids <- rows$row_id[rows$role == "train"]
  test_ids <- rows$row_id[rows$role == "test"]
  rsample::make_splits(
    list(
      analysis = match(train_ids, df$.row_id),
      assessment = match(test_ids, df$.row_id)
    ),
    data = df
  )
}

package_model_entry <- function(estimator, y, x, coords = c("coord_x", "coord_y")) {
  # Construit la specification package correspondant a l'estimateur manuel.
  # On commence par les trois spatialreg, car ils n'ont pas de tuning externe
  # et sont donc les meilleurs candidats pour valider la parite.
  spatial_formula <- build_estimator_formula(y, c(x, coords))
  switch(estimator,
    sar_lag = list(
      spec = spatialtidymodels::spatialreg_reg(coords = coords, model_type = "SAR", k_neighbors = 8) |>
        parsnip::set_engine("spatialreg") |>
        parsnip::set_mode("regression"),
      formula = spatial_formula
    ),
    sem_error = list(
      spec = spatialtidymodels::spatialreg_reg(coords = coords, model_type = "SEM", k_neighbors = 8) |>
        parsnip::set_engine("spatialreg") |>
        parsnip::set_mode("regression"),
      formula = spatial_formula
    ),
    sdm_mixed = list(
      spec = spatialtidymodels::spatialreg_reg(coords = coords, model_type = "SDM", k_neighbors = 8) |>
        parsnip::set_engine("spatialreg") |>
        parsnip::set_mode("regression"),
      formula = spatial_formula
    ),
    stop(sprintf(
      "Parite package non encore implementee pour %s. Commencer par sar_lag, sem_error, sdm_mixed.",
      estimator
    ), call. = FALSE)
  )
}

predict_package_split <- function(model_entry, split) {
  # Ajuste le modele package sur analysis(split) puis predit assessment(split).
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  wf <- workflows::workflow() |>
    workflows::add_formula(model_entry$formula) |>
    workflows::add_model(model_entry$spec)
  fit <- workflows::fit(wf, data = train)
  preds <- predict(fit, new_data = test)$.pred
  data.frame(row_id = test$.row_id, package_pred = as.numeric(preds), stringsAsFactors = FALSE)
}

run_spatialtidymodels_parity_check <- function(dataset = "columbus_crime",
                                               estimators = c("sar_lag", "sem_error", "sdm_mixed"),
                                               cv_schemes = c("holdout_10pct", "near_prediction", "block_spatial"),
                                               tolerance = 1e-8,
                                               repo_root = normalizePath(".")) {
  # Compare les predictions manuelles et package a split identique. Le rapport
  # agrege et les predictions package sont sauvegardes comme objets R natifs.
  load_parity_context(repo_root)
  prepared <- prepare_parity_dataset(dataset, repo_root)
  spec <- prepared$spec
  df <- prepared$data

  runs_dir <- file.path(repo_root, "data/manifests/runs")
  manual_path <- file.path(runs_dir, sprintf("benchmark_manual_predictions_%s_2026-07.rds", dataset))
  resamples_path <- file.path(runs_dir, sprintf("resamples_%s_2026-07.rds", dataset))
  if (!file.exists(manual_path)) {
    stop(sprintf("Predictions manuelles absentes: %s. Relancez run_spatial_benchmark() d'abord.", manual_path),
         call. = FALSE)
  }
  if (!file.exists(resamples_path)) {
    stop(sprintf("Manifeste resamples absent: %s. Relancez run_spatial_benchmark() d'abord.", resamples_path),
         call. = FALSE)
  }

  manual <- readRDS(manual_path)
  manifest <- readRDS(resamples_path)
  manual <- manual[manual$estimator %in% estimators & manual$cv_scheme %in% cv_schemes, ]
  if (nrow(manual) == 0L) {
    stop("Aucune prediction manuelle ne correspond aux estimateurs/schemas demandes.", call. = FALSE)
  }

  groups <- unique(manual[c("estimator", "cv_scheme", "fold")])
  report_rows <- list()
  package_rows <- list()

  for (i in seq_len(nrow(groups))) {
    estimator <- groups$estimator[[i]]
    cv_scheme <- groups$cv_scheme[[i]]
    fold <- groups$fold[[i]]
    cat(sprintf("parity %s / %s / %s ... ", estimator, cv_scheme, fold))

    split <- split_from_manifest(df, manifest, cv_scheme, fold)
    entry <- package_model_entry(estimator, spec$y, spec$x)
    package_pred <- tryCatch(predict_package_split(entry, split), error = function(e) e)
    manual_pred <- manual[manual$estimator == estimator & manual$cv_scheme == cv_scheme & manual$fold == fold, ]
    manual_error <- unique(stats::na.omit(manual_pred$error))
    manual_error <- if (length(manual_error) == 0L) NA_character_ else paste(manual_error, collapse = " | ")
    manual_failed <- all(is.na(manual_pred$.pred))

    if (inherits(package_pred, "error")) {
      package_error <- conditionMessage(package_pred)
      report <- data.frame(
        n = nrow(manual_pred),
        max_abs_diff = NA_real_,
        mean_abs_diff = NA_real_,
        parity_ok = FALSE,
        manual_failed = manual_failed,
        package_failed = TRUE,
        failure_matches = isTRUE(manual_failed && identical(manual_error, package_error)),
        manual_error = manual_error,
        package_error = package_error,
        stringsAsFactors = FALSE
      )
      cat(sprintf("ERROR [%s]\n", package_error))
    } else {
      joined <- merge(
        manual_pred[c("row_id", "truth", ".pred")],
        package_pred,
        by = "row_id",
        all = FALSE
      )
      names(joined)[names(joined) == ".pred"] <- "manual_pred"
      report <- compare_prediction_vectors(joined$package_pred, joined$manual_pred, tolerance = tolerance)
      report$manual_failed <- manual_failed
      report$package_failed <- FALSE
      report$failure_matches <- FALSE
      report$manual_error <- manual_error
      report$package_error <- NA_character_
      package_rows[[length(package_rows) + 1L]] <- cbind(
        dataset = dataset,
        estimator = estimator,
        cv_scheme = cv_scheme,
        fold = fold,
        joined,
        stringsAsFactors = FALSE
      )
      cat(sprintf("max_abs_diff=%.6g parity=%s\n", report$max_abs_diff, report$parity_ok))
    }

    report_rows[[length(report_rows) + 1L]] <- cbind(
      dataset = dataset,
      estimator = estimator,
      cv_scheme = cv_scheme,
      fold = fold,
      report,
      stringsAsFactors = FALSE
    )
  }

  report_out <- do.call(rbind, report_rows)
  package_out <- if (length(package_rows) > 0L) do.call(rbind, package_rows) else data.frame()
  report_path <- file.path(runs_dir, sprintf("parity_report_%s_2026-07.rds", dataset))
  pred_path <- file.path(runs_dir, sprintf("parity_package_predictions_%s_2026-07.rds", dataset))
  saveRDS(report_out, report_path)
  saveRDS(package_out, pred_path)
  cat(sprintf("Wrote %s\n", report_path))
  cat(sprintf("Wrote %s\n", pred_path))
  report_out
}
