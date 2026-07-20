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
      "spboost", "mgwrsar_gwr", "mgwrsar_mgwr", "mgwrsar_mgwrsar",
      "spmoran_esf", "spmoran_resf"
    ),
    backend = c(
      "stats::glm", "mgcv::gam", "spatialreg::lagsarlm",
      "spatialreg::errorsarlm", "spatialreg::lagsarlm(Durbin)",
      "spboost::spbgam", "mgwrsar::MGWRSAR(GWR)",
      "mgwrsar::TDS_MGWR", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)",
      "spmoran::esf", "spmoran::resf"
    ),
    automatic = c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),
    notes = c(
      "Baseline lineaire.",
      "Baseline GAM avec lisseur spatial s(x, y).",
      "SAR lag via fit_sar().",
      "SEM error via fit_sem().",
      "SDM mixed via fit_sdm().",
      "Route parsnip disponible; branchement benchmark package a finaliser.",
      "Route parsnip disponible; grille H/kernel a brancher.",
      "Route parsnip disponible; cout et sorties locales a stabiliser.",
      "Route parsnip disponible; W explicite et modele autocorrele a stabiliser.",
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
                                        zero_policy = TRUE) {
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
#'
#' @return Une liste de classe `spatial_benchmark` avec `results` et `fits`.
#' @export
benchmark_spatial <- function(formula, data, coords,
                              estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                              k_neighbors = 8, style = "W", zero_policy = TRUE) {
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
        k_neighbors = k_neighbors, style = style, zero_policy = zero_policy
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
      zero_policy = zero_policy
    ),
    class = "spatial_benchmark"
  )
}
