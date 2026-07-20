# Benchmark automatique pour un ensemble d'estimateurs spatiaux.
#
# Cette couche est differente des raccourcis fit_sar()/fit_sem()/fit_sdm():
# elle orchestre plusieurs estimateurs, collecte les diagnostics communs et
# retourne une table comparable. Les raccourcis restent utiles pour inspecter
# un estimateur pas a pas.

spatial_benchmark_registry <- function() {
  # Registre utilisateur des estimateurs. Il sert a la fois de documentation
  # console et de garde-fou pour benchmark_spatial().
  estimators <- c(
    "ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed",
    "spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar",
    "spmoran_esf", "spmoran_resf"
  )
  automatic <- c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE)
  data.frame(
    estimator = estimators,
    status = ifelse(automatic, "automatic", "known_not_automated"),
    mode = rep("regression", length(estimators)),
    package = c(
      "stats", "mgcv", "spatialreg", "spatialreg", "spatialreg",
      "spboost", "mgwrsar", "mgwrsar", "mgwrsar", "mgwrsar",
      "spmoran", "spmoran"
    ),
    backend = c(
      "stats::glm", "mgcv::gam", "spatialreg::lagsarlm",
      "spatialreg::errorsarlm", "spatialreg::lagsarlm(Durbin)",
      "spboost::spbgam", "mgwrsar::MGWRSAR(GWR)",
      "mgwrsar::MGWRSAR(SAR)",
      "mgwrsar::TDS_MGWR", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)",
      "spmoran::esf", "spmoran::resf"
    ),
    automatic = automatic,
    requires_coords = c(FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE),
    requires_W = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE),
    spatial_args = c(
      "", "coords", "coords/W/k_neighbors/style/zero_policy",
      "coords/W/k_neighbors/style/zero_policy", "coords/W/k_neighbors/style/zero_policy",
      "coords/k_neighbors", "coords/bandwidth/kernel", "coords/W",
      "coords", "coords/W/bandwidth/kernel", "coords", "coords"
    ),
    tunable_parameters = c(
      "", "", "k_neighbors", "k_neighbors", "k_neighbors",
      "mstop, nu, k_neighbors", "bandwidth, kernel", "",
      "", "bandwidth, kernel", "enum", "enum"
    ),
    notes = c(
      "Baseline lineaire.",
      "Baseline GAM avec lisseur spatial s(x, y).",
      "SAR lag via fit_sar().",
      "SEM error via fit_sem().",
      "SDM mixed via fit_sdm().",
      "SpBoost SAR via spboost_reg().",
      "GWR local via mgwrsar_reg(Model='GWR').",
      "SAR global via mgwrsar_reg(Model='SAR').",
      "MGWR multiscale via mgwrsar_reg(Model='tds_mgwr').",
      "MGWRSAR autocorrele via mgwrsar_reg(Model='MGWRSAR_1_0_kv').",
      "Encore hors parsnip dans le benchmark manuel.",
      "Encore hors parsnip et predictions NA a corriger."
    ),
    stringsAsFactors = FALSE
  )
}

package_available <- function(package) {
  # stats est fourni par R; les autres packages sont verifies sans les attacher.
  if (identical(package, "stats")) return(TRUE)
  requireNamespace(package, quietly = TRUE)
}

#' Lister les estimateurs benchmarkables par le package
#'
#' Retourne le registre des estimateurs connus par `spatialtidymodels`, en
#' distinguant ceux qui sont deja automatises dans `benchmark_spatial()` et
#' ceux qui sont encore a brancher.
#'
#' @param include_installed Si `TRUE`, ajoute une colonne indiquant si le
#'   package R requis est disponible dans la session.
#'
#' @return Un data frame.
#' @export
available_benchmark_estimators <- function(include_installed = TRUE) {
  out <- spatial_benchmark_registry()
  if (isTRUE(include_installed)) {
    out$installed <- vapply(out$package, package_available, logical(1))
  }
  out
}

add_spatial_smooth_to_formula <- function(formula, coords, data) {
  # Formule GAM: les coordonnees sont ajoutees comme lisseur spatial global.
  coords <- check_spatial_coords(coords, data = data)
  response <- deparse(formula[[2]])
  rhs_terms <- attr(stats::terms(formula, data = data), "term.labels")
  rhs <- paste(c(rhs_terms, sprintf("s(%s, %s)", coords[[1]], coords[[2]])), collapse = " + ")
  out <- stats::as.formula(paste(response, "~", rhs), env = environment(formula))
  environment(out)$s <- mgcv::s
  out
}

fit_one_benchmark_estimator <- function(estimator, formula, data, coords,
                                        k_neighbors = 8, style = "W",
                                        zero_policy = TRUE,
                                        spboost_mstop = 100L,
                                        spboost_nu = 0.1,
                                        mgwrsar_bandwidth = 20,
                                        mgwrsar_kernel = "bisq") {
  # Ajuste un estimateur connu. Les erreurs sont laissees au niveau appelant
  # pour produire une ligne de benchmark explicite plutot qu'un plantage global.
  switch(estimator,
    ols = stats::glm(formula, data = data),
    gam_spatial = {
      require_package("mgcv", "benchmark GAM spatial")
      mgcv::gam(add_spatial_smooth_to_formula(formula, coords, data), data = data)
    },
    sar_lag = fit_sar(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sem_error = fit_sem(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sdm_mixed = fit_sdm(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    spboost = {
      require_package("workflows", "benchmark SpBoost")
      spec <- spboost_reg(
        coords = coords, DGP = "SAR", mstop = spboost_mstop,
        nu = spboost_nu, k_neighbors = k_neighbors
      ) |>
        parsnip::set_engine("spboost") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_gwr = {
      require_package("workflows", "benchmark MGWRSAR GWR")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "GWR",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_sar = {
      require_package("workflows", "benchmark MGWRSAR SAR")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "SAR"
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_mgwr = {
      require_package("workflows", "benchmark MGWR multiscale")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "tds_mgwr",
        kernels = "gauss"
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_mgwrsar = {
      require_package("workflows", "benchmark MGWRSAR autocorrele")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "MGWRSAR_1_0_kv",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    stop(sprintf("Estimateur non automatise dans benchmark_spatial(): %s", estimator), call. = FALSE)
  )
}

make_benchmark_workflow <- function(spec, formula, coords, data) {
  # Les moteurs spatiaux ont besoin des coordonnees dans les donnees du
  # workflow. On les ajoute a la formule de pretraitement, puis les backends
  # retirent ces colonnes du modele econometrique quand c'est necessaire.
  require_package("workflows", "construction du workflow de tuning")
  workflows::workflow() |>
    workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
    workflows::add_model(spec)
}

default_benchmark_grid <- function(estimator, data) {
  # Grilles courtes et conservatrices pour l'API utilisateur. Les gros runs
  # scientifiques doivent fournir une grille explicite via `tuning_grids`.
  n <- nrow(data)
  switch(estimator,
    sar_lag = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sem_error = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sdm_mixed = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    spboost = data.frame(mstop = c(50L, 100L, 200L)),
    mgwrsar_gwr = expand.grid(
      bandwidth = unique(pmin(c(20L, 40L), max(3L, n - 1L))),
      kernel = c("bisq", "gauss"),
      KEEP.OUT.ATTRS = FALSE
    ),
    mgwrsar_mgwrsar = expand.grid(
      bandwidth = unique(pmin(c(20L, 40L), max(3L, n - 1L))),
      kernel = c("bisq", "gauss"),
      KEEP.OUT.ATTRS = FALSE
    ),
    NULL
  )
}

benchmark_tuning_grid <- function(estimator, tuning_grids, data) {
  # Une grille utilisateur a priorite; sinon on cree une petite grille par
  # defaut pour les estimateurs supportes.
  if (!is.null(tuning_grids) && estimator %in% names(tuning_grids)) {
    return(as.data.frame(tuning_grids[[estimator]]))
  }
  default_benchmark_grid(estimator, data)
}

fit_tune_grid_or_error <- function(wf, resamples, grid) {
  # Enveloppe unique pour garder l'erreur dans l'objet benchmark au lieu de
  # stopper tout le run.
  require_package("tune", "tuning benchmark_spatial()")
  require_package("yardstick", "metriques de tuning benchmark_spatial()")
  tryCatch(
    tune::tune_grid(
      wf,
      resamples = resamples,
      grid = grid,
      metrics = yardstick::metric_set(yardstick::rmse, yardstick::mae),
      control = tune::control_grid(save_pred = FALSE, verbose = FALSE)
    ),
    error = function(e) e
  )
}

collect_benchmark_tuning <- function(tuned, grid_cols) {
  # Convertit tune_grid() en table plate: une ligne par candidat avec RMSE/MAE.
  metrics <- tune::collect_metrics(tuned)
  if (nrow(metrics) == 0L) {
    stop("tune_grid() n'a retourne aucune metrique.", call. = FALSE)
  }
  one_metric <- function(metric_name, value_name) {
    rows <- metrics[metrics$.metric == metric_name, c(grid_cols, "mean", "n"), drop = FALSE]
    names(rows)[names(rows) == "mean"] <- value_name
    names(rows)[names(rows) == "n"] <- paste0("n_", metric_name)
    rows
  }
  rmse <- one_metric("rmse", "rmse")
  mae <- one_metric("mae", "mae")
  out <- merge(rmse, mae, by = grid_cols, all = TRUE)
  out$n_ok <- out$n_rmse
  out[order(out$rmse), , drop = FALSE]
}

tune_spatialreg_benchmark <- function(estimator, formula, data, coords, resamples,
                                      grid, style = "W", zero_policy = TRUE) {
  spec <- switch(estimator,
    sar_lag = sar_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sem_error = sem_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sdm_mixed = sdm_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy)
  ) |>
    parsnip::set_engine("spatialreg") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  tuned <- fit_tune_grid_or_error(wf, resamples, grid)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, "k_neighbors")
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(k_neighbors = as.integer(best$k_neighbors[[1]]))
  )
}

tune_spboost_benchmark <- function(formula, data, coords, resamples, grid,
                                  spboost_nu = 0.1, k_neighbors = 8) {
  spec <- spboost_reg(
    coords = coords, DGP = "SAR", mstop = tune::tune(),
    nu = spboost_nu, k_neighbors = k_neighbors
  ) |>
    parsnip::set_engine("spboost") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  tuned <- fit_tune_grid_or_error(wf, resamples, grid)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, "mstop")
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(spboost_mstop = as.integer(best$mstop[[1]]))
  )
}

tune_mgwrsar_benchmark <- function(estimator, formula, data, coords, resamples, grid) {
  # `kernel` est boucle explicitement: c'est plus robuste que de tuner un
  # argument caractere custom dans cette premiere API.
  model_type <- switch(estimator,
    mgwrsar_gwr = "GWR",
    mgwrsar_mgwrsar = "MGWRSAR_1_0_kv"
  )
  if (!"kernel" %in% names(grid)) grid$kernel <- "bisq"
  pieces <- lapply(split(grid, grid$kernel), function(one_kernel_grid) {
    kernel_value <- as.character(one_kernel_grid$kernel[[1]])
    one_grid <- data.frame(bandwidth = as.integer(one_kernel_grid$bandwidth))
    spec <- mgwrsar_reg(
      coords = coords, model_type = model_type,
      kernel = kernel_value, bandwidth = tune::tune()
    ) |>
      parsnip::set_engine("mgwrsar") |>
      parsnip::set_mode("regression")
    wf <- make_benchmark_workflow(spec, formula, coords, data)
    tuned <- fit_tune_grid_or_error(wf, resamples, one_grid)
    if (inherits(tuned, "error")) {
      return(data.frame(
        bandwidth = one_grid$bandwidth,
        kernel = kernel_value,
        rmse = NA_real_, n_rmse = 0L, mae = NA_real_, n_mae = 0L, n_ok = 0L,
        error = conditionMessage(tuned),
        stringsAsFactors = FALSE
      ))
    }
    out <- collect_benchmark_tuning(tuned, "bandwidth")
    out$kernel <- kernel_value
    out$error <- NA_character_
    out
  })
  grid_out <- do.call(rbind, pieces)
  ok <- is.finite(grid_out$rmse) & grid_out$n_ok > 0L
  if (!any(ok)) {
    return(list(error = "Tous les candidats mgwrsar ont echoue pendant tune_grid().", grid = grid_out))
  }
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = NULL,
    params = list(
      mgwrsar_bandwidth = as.integer(best$bandwidth[[1]]),
      mgwrsar_kernel = as.character(best$kernel[[1]])
    )
  )
}

tune_one_benchmark_estimator <- function(estimator, formula, data, coords, resamples,
                                         tuning_grids = NULL, k_neighbors = 8,
                                         style = "W", zero_policy = TRUE,
                                         spboost_nu = 0.1) {
  # Retourne NULL si l'estimateur n'a pas encore de route de tuning package.
  grid <- benchmark_tuning_grid(estimator, tuning_grids, data)
  if (is.null(grid)) return(NULL)
  out <- tryCatch({
    switch(estimator,
      sar_lag = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      sem_error = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      sdm_mixed = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      spboost = tune_spboost_benchmark(formula, data, coords, resamples, grid, spboost_nu, k_neighbors),
      mgwrsar_gwr = tune_mgwrsar_benchmark(estimator, formula, data, coords, resamples, grid),
      mgwrsar_mgwrsar = tune_mgwrsar_benchmark(estimator, formula, data, coords, resamples, grid),
      NULL
    )
  }, error = function(e) list(error = conditionMessage(e)))
  if (is.null(out)) return(NULL)
  out$estimator <- estimator
  out
}

make_default_resamples <- function(data, tuning_folds = 3L) {
  # V-fold classique par defaut. Les validations spatiales specialisees doivent
  # etre construites hors package et passees via `resamples`.
  require_package("rsample", "creation des resamples de tuning")
  v <- min(as.integer(tuning_folds), nrow(data))
  if (v < 2L) stop("tuning_folds doit etre au moins egal a 2.", call. = FALSE)
  rsample::vfold_cv(data, v = v)
}

apply_tuned_params <- function(base, tuned) {
  # Combine les valeurs fixes utilisateur et les meilleurs parametres tunes.
  if (is.null(tuned) || is.null(tuned$params)) return(base)
  utils::modifyList(base, tuned$params)
}

failed_benchmark_row <- function(estimator, data, formula, error) {
  # Ligne rectangulaire pour un estimateur qui echoue. Cela permet de comparer
  # les runs sans perdre l'information d'echec.
  data.frame(
    estimator = estimator,
    n = nrow(data),
    response = deparse(formula[[2]]),
    rmse = NA_real_,
    mae = NA_real_,
    aic = NA_real_,
    logLik = NA_real_,
    spatial_param = NA_character_,
    spatial_value = NA_real_,
    moran_i = NA_real_,
    moran_p_value = NA_real_,
    moran_error = NA_character_,
    fit_error = conditionMessage(error),
    stringsAsFactors = FALSE
  )
}

normalize_diagnostic_row_for_benchmark <- function(row, estimator) {
  # Ajoute les colonnes propres au benchmark automatique.
  row$estimator <- estimator
  row$fit_error <- NA_character_
  row
}

validate_benchmark_estimators <- function(estimators, registry) {
  # Messages d'erreur orientes utilisateur: on indique quoi lister ensuite.
  unknown <- setdiff(estimators, registry$estimator)
  if (length(unknown) > 0L) {
    stop(
      sprintf(
        "Estimateur(s) inconnu(s): %s. Utilisez available_benchmark_estimators() pour voir les noms valides.",
        paste(unknown, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  selected <- registry[match(estimators, registry$estimator), , drop = FALSE]
  not_automatic <- selected$estimator[!selected$automatic]
  if (length(not_automatic) > 0L) {
    stop(
      sprintf(
        "Estimateur(s) connu(s) mais pas encore automatises dans benchmark_spatial(): %s. Consultez available_benchmark_estimators()$status.",
        paste(not_automatic, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  missing_packages <- unique(selected$package[!vapply(selected$package, package_available, logical(1))])
  if (length(missing_packages) > 0L) {
    stop(
      sprintf(
        "Package(s) R manquant(s) pour ces estimateurs: %s.",
        paste(missing_packages, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  invisible(selected)
}

#' Lancer un benchmark spatial automatique
#'
#' Ajuste les estimateurs demandes sur un meme jeu de donnees et retourne une
#' table commune de diagnostics. Cette fonction correspond au mode automatique
#' du package; pour inspecter un estimateur pas a pas, utiliser plutot
#' `fit_sar()`, `fit_sem()`, `fit_sdm()` et `diagnose_spatial()`.
#'
#' @param formula Formule econometrique commune.
#' @param data Donnees.
#' @param coords Colonnes de coordonnees.
#' @param estimators Estimateurs a lancer.
#' @param k_neighbors Nombre de voisins pour les estimateurs a voisinage kNN.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#' @param spboost_mstop Nombre d'iterations pour `spboost`.
#' @param spboost_nu Taux d'apprentissage pour `spboost`.
#' @param mgwrsar_bandwidth Bande passante `H` pour les variantes `mgwrsar`.
#' @param mgwrsar_kernel Noyau spatial pour les variantes `mgwrsar`.
#' @param tune Si `TRUE`, lance un tuning `tune::tune_grid()` avant le fit
#'   final pour les estimateurs supportes.
#' @param resamples Resamples `rsample` utilises pour le tuning. Si `NULL` et
#'   `tune = TRUE`, un `vfold_cv()` classique est cree.
#' @param tuning_grids Liste optionnelle de grilles nommees par estimateur.
#' @param tuning_folds Nombre de folds pour le `vfold_cv()` par defaut.
#'
#' @return Une liste de classe `spatial_benchmark` avec `results` et `fits`.
#' @export
benchmark_spatial <- function(formula, data, coords,
                              estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                              k_neighbors = 8, style = "W", zero_policy = TRUE,
                              spboost_mstop = 100L, spboost_nu = 0.1,
                              mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq",
                              tune = FALSE, resamples = NULL, tuning_grids = NULL,
                              tuning_folds = 3L) {
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  registry <- spatial_benchmark_registry()
  validate_benchmark_estimators(estimators, registry)

  base_params <- list(
    k_neighbors = k_neighbors,
    style = style,
    zero_policy = zero_policy,
    spboost_mstop = spboost_mstop,
    spboost_nu = spboost_nu,
    mgwrsar_bandwidth = mgwrsar_bandwidth,
    mgwrsar_kernel = mgwrsar_kernel
  )
  tuning <- list()
  if (isTRUE(tune)) {
    if (is.null(resamples)) resamples <- make_default_resamples(data, tuning_folds = tuning_folds)
    for (estimator in estimators) {
      tuned <- tune_one_benchmark_estimator(
        estimator = estimator,
        formula = formula,
        data = data,
        coords = coords,
        resamples = resamples,
        tuning_grids = tuning_grids,
        k_neighbors = k_neighbors,
        style = style,
        zero_policy = zero_policy,
        spboost_nu = spboost_nu
      )
      if (!is.null(tuned)) tuning[[estimator]] <- tuned
    }
  }

  fits <- list()
  rows <- list()
  for (estimator in estimators) {
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    fit <- tryCatch(
      fit_one_benchmark_estimator(
        estimator = estimator, formula = formula, data = data, coords = coords,
        k_neighbors = params$k_neighbors, style = params$style, zero_policy = params$zero_policy,
        spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
        mgwrsar_bandwidth = params$mgwrsar_bandwidth, mgwrsar_kernel = params$mgwrsar_kernel
      ),
      error = function(e) e
    )
    if (inherits(fit, "error")) {
      rows[[estimator]] <- failed_benchmark_row(estimator, data, formula, fit)
      next
    }
    fits[[estimator]] <- fit
    diag <- diagnose_spatial(
      fit,
      data = data,
      coords = coords,
      formula = formula,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      include_baseline = FALSE
    )
    rows[[estimator]] <- normalize_diagnostic_row_for_benchmark(diag[1, , drop = FALSE], estimator)
  }

  results <- do.call(rbind, rows)
  row.names(results) <- NULL
  structure(
    list(
      results = results,
      fits = fits,
      formula = formula,
      coords = coords,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      estimators = estimators,
      tune = tune,
      tuning = tuning,
      tuning_grids = tuning_grids,
      resamples = if (isTRUE(tune)) resamples else NULL,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel
    ),
    class = "spatial_benchmark"
  )
}

benchmark_print_columns <- function(results) {
  # Colonnes utiles a l'affichage console; l'objet complet garde toutes les
  # colonnes dans $results.
  cols <- c("dataset", "estimator", "n", "response", "rmse", "mae",
            "aic", "spatial_param", "spatial_value", "moran_p_value", "fit_error")
  cols[cols %in% names(results)]
}

#' @export
print.spatial_benchmark <- function(x, ...) {
  cat("Benchmark spatial\n")
  cat("Formule: ", deparse(x$formula), "\n", sep = "")
  cat("Coordonnees: ", paste(x$coords, collapse = ", "), "\n", sep = "")
  cat("Estimateurs demandes: ", paste(x$estimators, collapse = ", "), "\n", sep = "")
  if (isTRUE(x$tune)) {
    tuned <- names(x$tuning)
    if (length(tuned) > 0L) {
      cat("Tuning: ", paste(tuned, collapse = ", "), "\n", sep = "")
    } else {
      cat("Tuning: aucun estimateur supporte dans cette liste\n")
    }
  }
  if (length(x$fits) > 0L) {
    cat("Fits reussis: ", paste(names(x$fits), collapse = ", "), "\n", sep = "")
  } else {
    cat("Fits reussis: aucun\n")
  }
  failed <- x$results$estimator[!is.na(x$results$fit_error)]
  if (length(failed) > 0L) {
    cat("Fits echoues: ", paste(failed, collapse = ", "), "\n", sep = "")
  }
  cat("\nResultats:\n")
  print(x$results[, benchmark_print_columns(x$results), drop = FALSE], row.names = FALSE)
  invisible(x)
}

#' Definir un jeu de donnees pour `benchmark_spatial_datasets()`
#'
#' @param name Nom court du dataset.
#' @param data Donnees.
#' @param formula Formule econometrique.
#' @param coords Colonnes de coordonnees.
#'
#' @return Une liste de classe `spatial_dataset_spec`.
#' @export
spatial_dataset_spec <- function(name, data, formula, coords) {
  # Petit conteneur explicite pour benchmarker plusieurs jeux sans imposer un
  # registre interne rigide au package.
  structure(
    list(name = name, data = data, formula = formula, coords = coords),
    class = "spatial_dataset_spec"
  )
}

normalize_dataset_specs <- function(datasets) {
  # Accepte soit une spec unique, soit une liste de specs. Les noms manquants
  # sont pris depuis chaque spec.
  if (inherits(datasets, "spatial_dataset_spec")) datasets <- list(datasets)
  if (!is.list(datasets) || length(datasets) == 0L) {
    stop("datasets doit etre une spatial_dataset_spec ou une liste de specs.", call. = FALSE)
  }
  datasets
}

#' Lancer un benchmark spatial sur plusieurs jeux de donnees
#'
#' @param datasets Une `spatial_dataset_spec` ou une liste de specs.
#' @inheritParams benchmark_spatial
#'
#' @return Une liste de classe `spatial_benchmark_set` avec `results` et
#'   `benchmarks`.
#' @export
benchmark_spatial_datasets <- function(datasets,
                                       estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                                       k_neighbors = 8, style = "W", zero_policy = TRUE,
                                       spboost_mstop = 100L, spboost_nu = 0.1,
                                       mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq",
                                       tune = FALSE, resamples = NULL, tuning_grids = NULL,
                                       tuning_folds = 3L) {
  datasets <- normalize_dataset_specs(datasets)
  benchmarks <- list()
  rows <- list()

  for (spec in datasets) {
    if (!inherits(spec, "spatial_dataset_spec")) {
      stop("Chaque entree de datasets doit etre creee avec spatial_dataset_spec().", call. = FALSE)
    }
    bench <- benchmark_spatial(
      formula = spec$formula,
      data = spec$data,
      coords = spec$coords,
      estimators = estimators,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel,
      tune = tune,
      resamples = if (is.null(resamples)) NULL else resamples[[spec$name]],
      tuning_grids = tuning_grids,
      tuning_folds = tuning_folds
    )
    benchmarks[[spec$name]] <- bench
    out <- bench$results
    out$dataset <- spec$name
    rows[[spec$name]] <- out[, c("dataset", setdiff(names(out), "dataset")), drop = FALSE]
  }

  results <- do.call(rbind, rows)
  row.names(results) <- NULL
  structure(
    list(results = results, benchmarks = benchmarks),
    class = "spatial_benchmark_set"
  )
}

#' @export
print.spatial_benchmark_set <- function(x, ...) {
  datasets <- names(x$benchmarks)
  cat("Benchmark spatial multi-dataset\n")
  cat("Datasets: ", paste(datasets, collapse = ", "), "\n", sep = "")
  cat("Nombre de lignes resultat: ", nrow(x$results), "\n", sep = "")
  failed <- x$results$estimator[!is.na(x$results$fit_error)]
  if (length(failed) > 0L) {
    cat("Fits echoues: ", paste(unique(failed), collapse = ", "), "\n", sep = "")
  }
  cat("\nResultats:\n")
  print(x$results[, benchmark_print_columns(x$results), drop = FALSE], row.names = FALSE)
  invisible(x)
}
