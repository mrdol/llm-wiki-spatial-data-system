# Diagnostics communs pour comparer modeles spatiaux et baseline OLS.
#
# Objectif: fournir une sortie courte, tabulaire, utilisable dans un benchmark.
# Chaque backend ne fournit pas les memes objets; la fonction remplit donc ce
# qu'elle peut et laisse NA quand une mesure n'est pas disponible.

extract_engine_for_diagnostics <- function(object) {
  # Un workflow tidymodels contient le fit moteur; un glm ou un Sarlm est deja
  # le moteur. On isole cette difference pour garder diagnose_spatial() simple.
  if (inherits(object, "workflow")) {
    require_package("workflows", "extraction du moteur d'un workflow")
    return(workflows::extract_fit_engine(object))
  }
  object
}

extract_formula_for_diagnostics <- function(object, engine, formula = NULL,
                                            coords = NULL, data = NULL) {
  # Priorite a la formule utilisateur, puis a celle stockee par fit_sar().
  if (!is.null(formula)) return(formula)
  stored <- attr(object, "spatialtidymodels_formula")
  if (inherits(stored, "formula")) {
    if (!is.null(coords) && !is.null(data)) {
      return(drop_formula_terms(stored, coords, data = data))
    }
    return(stored)
  }
  if (inherits(engine, "glm") && inherits(stats::formula(engine), "formula")) {
    return(stats::formula(engine))
  }
  NULL
}

extract_coords_for_diagnostics <- function(object, engine, coords = NULL) {
  # Les coordonnees peuvent etre fournies par l'utilisateur ou stockees par les
  # wrappers spatialtidymodels/spatialreg.
  if (!is.null(coords)) return(coords)
  stored <- attr(object, "spatialtidymodels_coords")
  if (!is.null(stored)) return(stored)
  stored_engine <- attr(engine, "spatialreg_coords_cols")
  if (!is.null(stored_engine)) return(stored_engine)
  NULL
}

numeric_or_na <- function(expr) {
  # Certains backends n'ont pas AIC/logLik ou ne les exposent pas proprement.
  out <- tryCatch(expr, error = function(e) NA_real_)
  if (length(out) == 0L || is.null(out)) return(NA_real_)
  as.numeric(out[[1]])
}

make_metric_values <- function(truth, pred) {
  # Metriques simples sans dependance obligatoire a yardstick. Cela rend la
  # fonction utilisable meme hors benchmark complet.
  ok <- stats::complete.cases(truth, pred)
  if (!any(ok)) return(list(rmse = NA_real_, mae = NA_real_))
  err <- as.numeric(pred[ok]) - as.numeric(truth[ok])
  list(
    rmse = sqrt(mean(err^2)),
    mae = mean(abs(err))
  )
}

predict_values_for_diagnostics <- function(object, engine, data) {
  # Pour un workflow, predict() renvoie un tibble .pred. Pour un modele lm/glm,
  # predict() renvoie directement un vecteur.
  if (is.null(data)) return(NULL)
  preds <- tryCatch(stats::predict(object, new_data = data), error = function(e) e)
  if (!inherits(preds, "error")) {
    if (is.data.frame(preds) && ".pred" %in% names(preds)) return(preds$.pred)
    return(as.numeric(preds))
  }
  preds <- tryCatch(stats::predict(engine, newdata = data), error = function(e) e)
  if (inherits(preds, "error")) return(NULL)
  as.numeric(preds)
}

residual_values_for_diagnostics <- function(object, engine, data, formula = NULL) {
  # Les residus moteur sont preferes. Si leur taille ne correspond pas aux
  # donnees, on reconstruit y - prediction quand c'est possible.
  res <- tryCatch(stats::residuals(engine), error = function(e) NULL)
  if (!is.null(res) && (is.null(data) || length(res) == nrow(data))) return(as.numeric(res))
  if (is.null(data) || is.null(formula)) return(res)
  response <- deparse(formula[[2]])
  if (!response %in% names(data)) return(res)
  pred <- predict_values_for_diagnostics(object, engine, data)
  if (is.null(pred) || length(pred) != nrow(data)) return(res)
  as.numeric(data[[response]]) - as.numeric(pred)
}

engine_component <- function(engine, name) {
  # Les backends n'ont pas tous la meme structure: spatialreg est surtout S3,
  # mgwrsar peut etre S4, et certains objets ne supportent pas `$`. On centralise
  # donc l'extraction defensive des champs utiles aux diagnostics.
  out <- tryCatch({
    if (isS4(engine) && name %in% methods::slotNames(engine)) {
      return(methods::slot(engine, name))
    }
    if (!isS4(engine) && !is.null(engine[[name]])) {
      return(engine[[name]])
    }
    NULL
  }, error = function(e) NULL)
  out
}

spatial_parameter_for_diagnostics <- function(engine) {
  # SAR/SDM exposent rho, SEM expose lambda. Les autres modeles retournent NA.
  rho <- engine_component(engine, "rho")
  if (!is.null(rho)) {
    return(list(name = "rho", value = as.numeric(rho[[1]])))
  }
  lambda <- engine_component(engine, "lambda")
  if (!is.null(lambda)) {
    return(list(name = "lambda", value = as.numeric(lambda[[1]])))
  }
  list(name = NA_character_, value = NA_real_)
}

model_label_for_diagnostics <- function(object, engine) {
  # Etiquette courte pour la table benchmark.
  if (inherits(engine, "glm")) return("ols_glm")
  if (inherits(engine, "Sarlm")) {
    type <- engine_component(engine, "type")
    if (!is.null(type) && identical(type, "mixed")) return("sdm_mixed")
    if (!is.null(type) && identical(type, "error")) return("sem_error")
    if (!is.null(engine_component(engine, "rho"))) return("sar_lag")
    return("spatialreg")
  }
  class(engine)[[1]]
}

moran_for_diagnostics <- function(residuals, data, coords, k_neighbors = 8,
                                  W = NULL, style = "W", zero_policy = TRUE) {
  # Moran I n'est calcule que si les residus et une structure spatiale sont
  # disponibles. Sinon on laisse NA pour garder une table rectangulaire.
  if (is.null(residuals) || is.null(data) || length(residuals) != nrow(data)) {
    return(list(i = NA_real_, p = NA_real_, error = NA_character_))
  }
  out <- tryCatch({
    if (is.null(W)) {
      coords <- check_spatial_coords(coords, data = data)
      W <- build_knn_listw(data[, coords, drop = FALSE], k = k_neighbors,
                           style = style, zero_policy = zero_policy)
    }
    test <- spdep::moran.test(residuals, listw = W, zero.policy = zero_policy)
    list(
      i = unname(test$estimate[["Moran I statistic"]]),
      p = test$p.value,
      error = NA_character_
    )
  }, error = function(e) {
    list(i = NA_real_, p = NA_real_, error = conditionMessage(e))
  })
  out
}

diagnostic_row <- function(object, estimator, data = NULL, formula = NULL,
                           coords = NULL, W = NULL, k_neighbors = 8,
                           style = "W", zero_policy = TRUE) {
  # Construit une ligne de diagnostic. Les champs non disponibles restent NA.
  engine <- extract_engine_for_diagnostics(object)
  response <- if (inherits(formula, "formula")) deparse(formula[[2]]) else NA_character_
  pred <- predict_values_for_diagnostics(object, engine, data)
  truth <- if (!is.null(data) && !is.na(response) && response %in% names(data)) data[[response]] else NULL
  metrics <- if (!is.null(truth) && !is.null(pred)) make_metric_values(truth, pred) else list(rmse = NA_real_, mae = NA_real_)
  res <- residual_values_for_diagnostics(object, engine, data, formula = formula)
  moran <- moran_for_diagnostics(
    residuals = res, data = data, coords = coords, k_neighbors = k_neighbors,
    W = W, style = style, zero_policy = zero_policy
  )
  spatial_param <- spatial_parameter_for_diagnostics(engine)

  data.frame(
    estimator = estimator,
    n = if (is.null(data)) NA_integer_ else nrow(data),
    response = response,
    rmse = metrics$rmse,
    mae = metrics$mae,
    aic = numeric_or_na(stats::AIC(engine)),
    logLik = numeric_or_na(stats::logLik(engine)),
    spatial_param = spatial_param$name,
    spatial_value = spatial_param$value,
    moran_i = moran$i,
    moran_p_value = moran$p,
    moran_error = moran$error,
    stringsAsFactors = FALSE
  )
}

#' Diagnostiquer un modele spatial et une baseline OLS
#'
#' Produit une table de diagnostic pour un modele ajuste par `spatialtidymodels`
#' ou par un backend compatible. Quand `include_baseline = TRUE`, la fonction
#' ajuste aussi une baseline OLS `glm(formula, data)` et calcule les memes
#' diagnostics. C'est le chemin court pour savoir si SAR/SEM/SDM apporte quelque
#' chose par rapport a OLS sur un jeu de donnees donne.
#'
#' @param object Modele ajuste: workflow `spatialtidymodels`, modele `glm`, ou
#'   moteur compatible.
#' @param data Donnees utilisees pour les diagnostics in-sample.
#' @param coords Colonnes de coordonnees pour le test de Moran.
#' @param formula Formule econometrique. Si elle est absente, la fonction tente
#'   de la recuperer depuis un fit cree par `fit_sar()`, `fit_sem()` ou
#'   `fit_sdm()`.
#' @param W Matrice de poids ou objet `listw`. Si absent, construit depuis
#'   `coords`.
#' @param k_neighbors Nombre de voisins pour construire `W`.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#' @param include_baseline Si `TRUE`, ajoute une baseline OLS.
#'
#' @return Un data frame de diagnostics.
#' @export
diagnose_spatial <- function(object, data = NULL, coords = NULL, formula = NULL,
                             W = NULL, k_neighbors = NULL, style = NULL,
                             zero_policy = NULL, include_baseline = TRUE) {
  engine <- extract_engine_for_diagnostics(object)
  coords <- extract_coords_for_diagnostics(object, engine, coords = coords)
  k_neighbors <- k_neighbors %||% attr(object, "spatialtidymodels_k_neighbors") %||%
    attr(engine, "spatialreg_k_neighbors") %||% 8L
  style <- style %||% attr(object, "spatialtidymodels_style") %||%
    attr(engine, "spatialreg_style") %||% "W"
  zero_policy <- zero_policy %||% attr(object, "spatialtidymodels_zero_policy") %||%
    attr(engine, "spatialreg_zero_policy") %||% TRUE
  formula <- extract_formula_for_diagnostics(
    object, engine, formula = formula, coords = coords, data = data
  )

  rows <- list(diagnostic_row(
    object = object,
    estimator = model_label_for_diagnostics(object, engine),
    data = data,
    formula = formula,
    coords = coords,
    W = W,
    k_neighbors = k_neighbors,
    style = style,
    zero_policy = zero_policy
  ))

  if (isTRUE(include_baseline) && !is.null(data) && inherits(formula, "formula")) {
    ols <- stats::glm(formula, data = data)
    rows[[length(rows) + 1L]] <- diagnostic_row(
      object = ols,
      estimator = "ols_baseline",
      data = data,
      formula = formula,
      coords = coords,
      W = W,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy
    )
  }

  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}
