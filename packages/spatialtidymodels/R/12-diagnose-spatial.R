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

finite_scalar_or_na <- function(x) {
  # Convertit defensivement les sorties heterogenes des backends en scalaire
  # numerique. Cela evite qu'une methode S3/S4 partielle casse tout le tableau.
  out <- suppressWarnings(tryCatch(as.numeric(x[[1]]), error = function(e) NA_real_))
  if (length(out) != 1L || !is.finite(out)) return(NA_real_)
  out
}

spboost_effective_df_for_ic <- function(engine) {
  # spboost herite de mboost mais logLik() ne pose pas toujours attr(, "df").
  # On utilise alors une approximation transparente: nombre de coefficients
  # actifs plus les parametres spatiaux scalaires. Si cette approximation n'est
  # pas disponible, AICc reste NA plutot que d'inventer k.
  coefs <- tryCatch(stats::coef(engine), error = function(e) NULL)
  k_beta <- if (is.list(coefs)) {
    sum(vapply(coefs, length, integer(1)))
  } else if (!is.null(coefs)) {
    length(coefs)
  } else {
    NA_integer_
  }
  if (!is.finite(k_beta)) return(NA_real_)
  k_spatial <- 0L
  if (!is.null(engine_component(engine, "rho"))) k_spatial <- k_spatial + 1L
  if (!is.null(engine_component(engine, "lambda"))) k_spatial <- k_spatial + 1L
  as.numeric(k_beta + k_spatial)
}

extract_information_criteria <- function(engine, n = NA_integer_) {
  # Extrait logLik/AIC/AICc avec routes par backend. Les methodes standards R
  # restent prioritaires; les champs internes servent seulement de repli quand
  # le backend documente/stocker deja l'information mais ne fournit pas de
  # methode AIC/logLik robuste.
  ll_obj <- tryCatch(stats::logLik(engine), error = function(e) NULL)
  loglik <- if (is.null(ll_obj)) NA_real_ else finite_scalar_or_na(ll_obj)
  k <- if (is.null(ll_obj)) NA_real_ else finite_scalar_or_na(attr(ll_obj, "df"))

  if (!is.finite(loglik)) {
    loglik <- finite_scalar_or_na(engine_component(engine, "logLik"))
  }
  if (!is.finite(loglik)) {
    loglik <- finite_scalar_or_na(engine_component(engine, "logl"))
  }

  if (!is.finite(k)) {
    k <- finite_scalar_or_na(engine_component(engine, "df"))
  }
  if (!is.finite(k) && inherits(engine, "mboost")) {
    # Covers spboost AND plain gamboost -- both inherit "mboost".
    k <- spboost_effective_df_for_ic(engine)
  }

  # stats::AIC(engine) is skipped for mboost-derived engines (spboost,
  # gamboost): AIC.mboost() computes effective degrees of freedom via the
  # boosting hat-matrix trace, which scales very badly with n -- instant on
  # small benchmark datasets (n<=519) but confirmed to still be running after
  # 35s+ of sustained single-core CPU on lasrosas (n=3435), which is what
  # produced the ~25 minute suite stall this was root-caused from. The
  # analytic aic = -2*logLik + 2*k fallback below (logLik is cheap; k comes
  # from spboost_effective_df_for_ic()'s coef()-based approximation) gives an
  # equivalent AIC without ever calling the expensive method.
  aic <- if (inherits(engine, "mboost")) NA_real_ else numeric_or_na(stats::AIC(engine))
  if (!is.finite(aic)) {
    aic <- finite_scalar_or_na(engine_component(engine, "AIC"))
  }
  if (!is.finite(aic) && is.finite(loglik) && is.finite(k)) {
    aic <- -2 * loglik + 2 * k
  }

  n <- finite_scalar_or_na(n)
  aicc <- if (is.finite(aic) && is.finite(k) && is.finite(n) && n > k + 1) {
    aic + (2 * k * (k + 1)) / (n - k - 1)
  } else {
    NA_real_
  }

  list(
    logLik = loglik,
    aic = aic,
    aicc = aicc,
    df = k
  )
}

#' Aire sous la courbe ROC (Mann-Whitney U), sans dependance a yardstick
#'
#' @keywords internal
binary_auc_value <- function(truth01, prob) {
  pos <- prob[truth01 == 1]
  neg <- prob[truth01 == 0]
  if (length(pos) == 0L || length(neg) == 0L) return(NA_real_)
  r <- rank(c(pos, neg))
  n1 <- length(pos)
  (sum(r[seq_len(n1)]) - n1 * (n1 + 1) / 2) / (n1 * length(neg))
}

make_metric_values <- function(truth, pred, response_typology = "continuous") {
  # Metriques simples sans dependance obligatoire a yardstick. Cela rend la
  # fonction utilisable meme hors benchmark complet.
  #
  # rmse/mae restent TOUJOURS calcules et presents, quel que soit le type de
  # reponse (2026-09) -- pour "binary", pred est suppose etre la probabilite
  # de la classe positive (dans [0,1]) et truth 0/1, donc rmse/mae equivalent
  # a une racine de Brier score / erreur absolue moyenne sur la probabilite.
  # Ce choix garde le schema de colonnes stable entre types de reponse (le
  # dashboard et les tests existants lisent rmse/mae sans condition) ;
  # accuracy/auc/deviance s'ajoutent en plus, NA quand non applicables,
  # plutot que de remplacer rmse/mae.
  response_typology <- if (is.null(response_typology) || is.na(response_typology)) {
    "continuous"
  } else {
    response_typology
  }
  na_extra <- list(accuracy = NA_real_, auc = NA_real_, deviance = NA_real_)
  ok <- stats::complete.cases(truth, pred)
  if (!any(ok)) return(c(list(rmse = NA_real_, mae = NA_real_), na_extra))
  truth_ok <- as.numeric(truth[ok])
  pred_ok <- as.numeric(pred[ok])
  err <- pred_ok - truth_ok
  base <- list(rmse = sqrt(mean(err^2)), mae = mean(abs(err)))

  if (identical(response_typology, "binary")) {
    pred_class <- as.numeric(pred_ok >= 0.5)
    accuracy <- mean(pred_class == truth_ok)
    auc <- tryCatch(binary_auc_value(truth_ok, pred_ok), error = function(e) NA_real_)
    eps <- 1e-15
    p <- pmin(pmax(pred_ok, eps), 1 - eps)
    log_loss <- -mean(truth_ok * log(p) + (1 - truth_ok) * log(1 - p))
    return(c(base, list(accuracy = accuracy, auc = auc, deviance = 2 * log_loss * length(truth_ok))))
  }
  if (identical(response_typology, "count")) {
    p <- pmax(pred_ok, 1e-10)
    dev_terms <- ifelse(truth_ok > 0, truth_ok * log(truth_ok / p), 0) - (truth_ok - p)
    deviance <- 2 * sum(dev_terms)
    return(c(base, list(accuracy = NA_real_, auc = NA_real_, deviance = deviance)))
  }
  c(base, na_extra)
}

predict_values_for_diagnostics <- function(object, engine, data, response_typology = "continuous") {
  # Pour un workflow, predict() renvoie un tibble .pred. Pour un modele lm/glm,
  # predict() utilise `newdata` et renvoie directement un vecteur.
  #
  # response_typology == "binary": un workflow classification n'a pas de
  # colonne .pred par defaut (predict() renvoie .pred_class, un facteur) --
  # il faut explicitement demander type="prob" et prendre la DERNIERE colonne
  # (convention tidymodels: une colonne par niveau, dans l'ordre des niveaux;
  # avec exactement 2 niveaux, la derniere est la classe positive).
  if (is.null(data)) return(NULL)
  if (isS4(engine) && "fit" %in% methods::slotNames(engine) &&
      length(engine@fit) == nrow(data)) {
    # Diagnostic in-sample pour mgwrsar: le backend natif stocke les valeurs
    # ajustees dans @fit. C'est plus fiable que predict_mgwrsar() quand les
    # donnees demandees sont exactement celles du fit.
    return(as.numeric(engine@fit))
  }
  if (inherits(object, "workflow")) {
    if (identical(response_typology, "binary")) {
      preds <- tryCatch(stats::predict(object, new_data = data, type = "prob"), error = function(e) e)
      if (!inherits(preds, "error") && is.data.frame(preds) && ncol(preds) >= 2L) {
        return(as.numeric(preds[[ncol(preds)]]))
      }
    }
    preds <- tryCatch(stats::predict(object, new_data = data), error = function(e) e)
    if (!inherits(preds, "error")) {
      if (is.data.frame(preds) && ".pred" %in% names(preds)) return(preds$.pred)
      return(as.numeric(preds))
    }
  }
  # glm(family=binomial()/poisson()) renvoie l'echelle lineaire (logit/log)
  # par defaut -- type="response" est necessaire pour obtenir une probabilite
  # ou un compte, comparable a `truth`.
  predict_type <- if (response_typology %in% c("binary", "count")) "response" else NULL
  predict_args <- if (is.null(predict_type)) list() else list(type = predict_type)
  preds <- tryCatch(
    do.call(stats::predict, c(list(object, newdata = data), predict_args)),
    error = function(e) e
  )
  if (!inherits(preds, "error")) {
    if (is.data.frame(preds) && ".pred" %in% names(preds) && nrow(preds) == nrow(data)) {
      return(preds$.pred)
    }
    if (!is.data.frame(preds) && length(preds) == nrow(data)) return(as.numeric(preds))
  }
  preds <- tryCatch(
    do.call(stats::predict, c(list(engine, newdata = data), predict_args)),
    error = function(e) e
  )
  if (inherits(preds, "error")) return(NULL)
  if (is.data.frame(preds) && ".pred" %in% names(preds) && nrow(preds) == nrow(data)) {
    return(preds$.pred)
  }
  if (length(preds) != nrow(data)) return(NULL)
  as.numeric(preds)
}

residual_values_for_diagnostics <- function(object, engine, data, formula = NULL,
                                            response_typology = "continuous") {
  # Les residus moteur sont preferes. Si leur taille ne correspond pas aux
  # donnees, on reconstruit y - prediction quand c'est possible.
  #
  # response_typology == "binary": stats::residuals() sur un moteur de
  # classification (ex. ranger) peut renvoyer une LISTE (structure par
  # classe), pas un vecteur numerique -- confirme empiriquement
  # (as.numeric(res) plante avec "l'objet 'list' ne peut etre converti...").
  # Aucune notion de residu "moteur" bien definie pour une classe de toute
  # facon: on saute directement a la reconstruction truth-pred (0/1 moins
  # probabilite), coherente avec ce que fait deja make_metric_values().
  if (!identical(response_typology, "binary")) {
    res <- tryCatch(stats::residuals(engine), error = function(e) NULL)
    if (!is.null(res) && (is.null(data) || length(res) == nrow(data))) return(as.numeric(res))
  } else {
    res <- NULL
  }
  if (is.null(data) || is.null(formula)) return(res)
  response <- deparse(formula[[2]])
  if (!response %in% names(data)) return(res)
  pred <- predict_values_for_diagnostics(object, engine, data, response_typology = response_typology)
  if (is.null(pred) || length(pred) != nrow(data)) return(res)
  truth <- data[[response]]
  if (is.factor(truth)) truth <- as.integer(truth) - 1L
  as.numeric(truth) - as.numeric(pred)
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
  # SAR/SDM exposent rho, SEM expose lambda. Certains backends gardent un nom
  # interne different; on renvoie ici le nom econometrique lisible par
  # l'utilisateur du benchmark.
  if (inherits(engine, "spboost")) {
    rho <- engine_component(engine, "rho")
    if (!is.null(rho)) {
      param_name <- if (inherits(engine, "BSPA_SEM_ML") || inherits(engine, "BSPA_SEM_CFE")) {
        "lambda"
      } else {
        "rho"
      }
      return(list(name = param_name, value = as.numeric(rho[[1]])))
    }
  }
  if (isS4(engine) && inherits(engine, "mgwrsar")) {
    model <- engine_component(engine, "Model")
    Betac <- engine_component(engine, "Betac")
    Betav <- engine_component(engine, "Betav")
    if (!is.null(Betac) && "lambda" %in% names(Betac)) {
      return(list(name = "lambda", value = as.numeric(Betac[["lambda"]])))
    }
    if (!is.null(Betac) && "PhWy" %in% names(Betac)) {
      return(list(name = "lambda", value = as.numeric(Betac[["PhWy"]])))
    }
    if (!is.null(Betav) && length(dim(Betav)) == 2L && "lambda" %in% colnames(Betav)) {
      lambda <- as.numeric(Betav[, "lambda"])
      return(list(
        name = if (identical(model, "MGWRSAR_1_kc_kv")) "lambda_local_mean" else "lambda",
        value = mean(lambda[is.finite(lambda)])
      ))
    }
  }
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
    } else if (!inherits(W, "listw")) {
      if (!requireNamespace("spdep", quietly = TRUE)) {
        stop("Le package spdep est requis pour convertir W en listw.", call. = FALSE)
      }
      if (inherits(W, "nb")) {
        W <- spdep::nb2listw(W, style = style, zero.policy = zero_policy)
      } else {
        W <- spdep::mat2listw(
          spatial_W_to_matrix(W, style = style, zero_policy = zero_policy),
          style = style,
          zero.policy = zero_policy
        )
      }
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
                           style = "W", zero_policy = TRUE,
                           response_typology = "continuous") {
  # Construit une ligne de diagnostic. Les champs non disponibles restent NA.
  engine <- extract_engine_for_diagnostics(object)
  response <- if (inherits(formula, "formula")) deparse(formula[[2]]) else NA_character_
  pred <- predict_values_for_diagnostics(object, engine, data, response_typology = response_typology)
  truth <- if (!is.null(data) && !is.na(response) && response %in% names(data)) data[[response]] else NULL
  # truth peut etre un facteur (mode classification impose par parsnip, voir
  # probitspatial_fit_impl()) -- le reconvertir en 0/1 numerique pour que les
  # metriques restent comparables a la probabilite predite.
  if (!is.null(truth) && is.factor(truth)) truth <- as.integer(truth) - 1L
  metrics <- if (!is.null(truth) && !is.null(pred)) {
    make_metric_values(truth, pred, response_typology = response_typology)
  } else {
    list(rmse = NA_real_, mae = NA_real_, accuracy = NA_real_, auc = NA_real_, deviance = NA_real_)
  }
  res <- residual_values_for_diagnostics(object, engine, data, formula = formula, response_typology = response_typology)
  moran <- moran_for_diagnostics(
    residuals = res, data = data, coords = coords, k_neighbors = k_neighbors,
    W = W, style = style, zero_policy = zero_policy
  )
  spatial_param <- spatial_parameter_for_diagnostics(engine)
  info_criteria <- extract_information_criteria(
    engine = engine,
    n = if (is.null(data)) NA_integer_ else nrow(data)
  )

  data.frame(
    estimator = estimator,
    n = if (is.null(data)) NA_integer_ else nrow(data),
    response = response,
    rmse = metrics$rmse,
    mae = metrics$mae,
    accuracy = metrics$accuracy,
    auc = metrics$auc,
    deviance = metrics$deviance,
    aicc = info_criteria$aicc,
    logLik = info_criteria$logLik,
    spatial_param = spatial_param$name,
    spatial_value = spatial_param$value,
    moran_i = moran$i,
    moran_abs = abs(moran$i),
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
                             zero_policy = NULL, include_baseline = TRUE,
                             response_typology = "continuous") {
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
    zero_policy = zero_policy,
    response_typology = response_typology
  ))

  if (isTRUE(include_baseline) && !is.null(data) && inherits(formula, "formula")) {
    ols_family <- switch(response_typology,
      binary = stats::binomial(),
      count = stats::poisson(),
      stats::gaussian()
    )
    ols <- stats::glm(formula, data = data, family = ols_family)
    rows[[length(rows) + 1L]] <- diagnostic_row(
      object = ols,
      estimator = "ols_baseline",
      data = data,
      formula = formula,
      coords = coords,
      W = W,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      response_typology = response_typology
    )
  }

  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}
