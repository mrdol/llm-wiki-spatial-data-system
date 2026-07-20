# Benchmark automatique pour un ensemble d'estimateurs spatiaux.
#
# Cette couche est differente des raccourcis fit_sar()/fit_sem()/fit_sdm():
# elle orchestre plusieurs estimateurs, collecte les diagnostics communs et
# retourne une table comparable. Les raccourcis restent utiles pour inspecter
# un estimateur pas a pas.

spatial_benchmark_registry <- function() {
  # Registre utilisateur des estimateurs. Les lignes "planned" documentent les
  # routes prevues sans pretendre qu'elles sont deja automatisees dans le
  # package.
  data.frame(
    estimator = c(
      "ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed",
      "spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar",
      "spmoran_esf", "spmoran_resf"
    ),
    backend = c(
      "stats::glm", "mgcv::gam", "spatialreg::lagsarlm",
      "spatialreg::errorsarlm", "spatialreg::lagsarlm(Durbin)",
      "spboost::spbgam", "mgwrsar::MGWRSAR(GWR)",
      "mgwrsar::MGWRSAR(SAR)",
      "mgwrsar::TDS_MGWR", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)",
      "spmoran::esf", "spmoran::resf"
    ),
    automatic = c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE),
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

#' Lister les estimateurs benchmarkables par le package
#'
#' Retourne le registre des estimateurs connus par `spatialtidymodels`, en
#' distinguant ceux qui sont deja automatises dans `benchmark_spatial()` et
#' ceux qui sont encore a brancher.
#'
#' @return Un data frame.
#' @export
available_benchmark_estimators <- function() {
  spatial_benchmark_registry()
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
#'
#' @return Une liste de classe `spatial_benchmark` avec `results` et `fits`.
#' @export
benchmark_spatial <- function(formula, data, coords,
                              estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                              k_neighbors = 8, style = "W", zero_policy = TRUE,
                              spboost_mstop = 100L, spboost_nu = 0.1,
                              mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq") {
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  registry <- spatial_benchmark_registry()
  unknown <- setdiff(estimators, registry$estimator)
  if (length(unknown) > 0L) {
    stop(sprintf("Estimateur(s) inconnu(s): %s", paste(unknown, collapse = ", ")), call. = FALSE)
  }
  not_automatic <- registry$estimator[match(estimators, registry$estimator)]
  not_automatic <- not_automatic[!registry$automatic[match(not_automatic, registry$estimator)]]
  if (length(not_automatic) > 0L) {
    stop(
      sprintf(
        "Estimateur(s) connu(s) mais pas encore automatises dans benchmark_spatial(): %s",
        paste(not_automatic, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  fits <- list()
  rows <- list()
  for (estimator in estimators) {
    fit <- tryCatch(
      fit_one_benchmark_estimator(
        estimator = estimator, formula = formula, data = data, coords = coords,
        k_neighbors = k_neighbors, style = style, zero_policy = zero_policy,
        spboost_mstop = spboost_mstop, spboost_nu = spboost_nu,
        mgwrsar_bandwidth = mgwrsar_bandwidth, mgwrsar_kernel = mgwrsar_kernel
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
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel
    ),
    class = "spatial_benchmark"
  )
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
                                       mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq") {
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
      mgwrsar_kernel = mgwrsar_kernel
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
