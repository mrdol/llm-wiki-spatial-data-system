
# Moteur parsnip custom pour les modeles spatialreg classiques.
#
# Objectif: transformer SAR, SEM et SDM en specifications utilisables par
# workflows::workflow(), comme les autres estimateurs du pipeline. La
# validation croisee reste externe: ce fichier enregistre seulement fit/predict.

#' Specification parsnip pour SAR, SEM et SDM
#'
#' Cree une specification `parsnip` experimentale pour les modeles spatiaux
#' classiques ajustes par `spatialreg`: SAR lag, SEM error et SDM mixed.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param W Matrice de poids spatiaux ou objet `listw` fourni au fit.
#' @param model_type Type de modele: `"SAR"`, `"SEM"` ou `"SDM"`.
#' @param k_neighbors Nombre de voisins utilise pour construire W.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Une specification de modele `parsnip`.
#' @export
spatialreg_reg <- function(mode = "regression", coords = NULL, W = NULL,
                           model_type = NULL, k_neighbors = NULL,
                           style = "W", zero_policy = TRUE) {
  # Constructeur utilisateur. model_type vaut "SAR", "SEM" ou "SDM".
  # Les coordonnees sont conservees dans la formule workflow pour arriver
  # jusqu'au moteur, puis retirees de la formule statistique native.
  args <- list(
    coords = rlang::enquo(coords),
    W = rlang::enquo(W),
    model_type = rlang::enquo(model_type),
    k_neighbors = rlang::enquo(k_neighbors),
    style = rlang::enquo(style),
    zero_policy = rlang::enquo(zero_policy)
  )
  parsnip::new_model_spec(
    "spatialreg_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Specification parsnip explicite pour SAR lag
#'
#' Cree une specification `parsnip` pour un modele SAR lag ajuste avec
#' `spatialreg::lagsarlm()`. Cette fonction est un raccourci lisible autour de
#' `spatialreg_reg(model_type = "SAR")`.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param W Matrice de poids spatiaux ou objet `listw` fourni au fit.
#' @param k_neighbors Nombre de voisins utilise pour construire W.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Une specification de modele `parsnip`.
#' @export
sar_reg <- function(mode = "regression", coords = NULL, W = NULL,
                    k_neighbors = NULL, style = "W", zero_policy = TRUE) {
  # Raccourci utilisateur: la route interne reste spatialreg_reg(). On capture
  # directement les arguments utilisateur pour que tune::tune() reste visible
  # par tune_grid(), au lieu de capturer le symbole local `k_neighbors`.
  parsnip::new_model_spec(
    "spatialreg_reg",
    args = list(
      coords = rlang::enquo(coords),
      W = rlang::enquo(W),
      model_type = rlang::quo("SAR"),
      k_neighbors = rlang::enquo(k_neighbors),
      style = rlang::enquo(style),
      zero_policy = rlang::enquo(zero_policy)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Specification parsnip explicite pour SEM error
#'
#' Cree une specification `parsnip` pour un modele SEM error ajuste avec
#' `spatialreg::errorsarlm()`. Cette fonction est un raccourci lisible autour
#' de `spatialreg_reg(model_type = "SEM")`.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param W Matrice de poids spatiaux ou objet `listw` fourni au fit.
#' @param k_neighbors Nombre de voisins utilise pour construire W.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Une specification de modele `parsnip`.
#' @export
sem_reg <- function(mode = "regression", coords = NULL, W = NULL,
                    k_neighbors = NULL, style = "W", zero_policy = TRUE) {
  # Le moteur spatialreg commun est conserve pour garantir la parite avec la
  # route generique et eviter trois implementations presque identiques.
  parsnip::new_model_spec(
    "spatialreg_reg",
    args = list(
      coords = rlang::enquo(coords),
      W = rlang::enquo(W),
      model_type = rlang::quo("SEM"),
      k_neighbors = rlang::enquo(k_neighbors),
      style = rlang::enquo(style),
      zero_policy = rlang::enquo(zero_policy)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Specification parsnip explicite pour SDM mixed
#'
#' Cree une specification `parsnip` pour un modele SDM mixed ajuste avec
#' `spatialreg::lagsarlm(Durbin = ...)`. Cette fonction est un raccourci
#' lisible autour de `spatialreg_reg(model_type = "SDM")`.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param W Matrice de poids spatiaux ou objet `listw` fourni au fit.
#' @param k_neighbors Nombre de voisins utilise pour construire W.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Une specification de modele `parsnip`.
#' @export
sdm_reg <- function(mode = "regression", coords = NULL, W = NULL,
                    k_neighbors = NULL, style = "W", zero_policy = TRUE) {
  # SDM garde la correction interne deja mise en place: formule Durbin explicite
  # sans intercept spatialement lagge.
  parsnip::new_model_spec(
    "spatialreg_reg",
    args = list(
      coords = rlang::enquo(coords),
      W = rlang::enquo(W),
      model_type = rlang::quo("SDM"),
      k_neighbors = rlang::enquo(k_neighbors),
      style = rlang::enquo(style),
      zero_policy = rlang::enquo(zero_policy)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @export
#' @method update spatialreg_reg
update.spatialreg_reg <- function(object, parameters = NULL, coords = NULL,
                                  W = NULL, model_type = NULL, k_neighbors = NULL,
                                  style = NULL, zero_policy = NULL,
                                  fresh = FALSE, ...) {
  # Necessaire pour rester compatible avec la mecanique parsnip/tune, meme si
  # ces modeles ne sont pas encore tunes dans le benchmark courant.
  args <- list(
    coords = rlang::enquo(coords),
    W = rlang::enquo(W),
    model_type = rlang::enquo(model_type),
    k_neighbors = rlang::enquo(k_neighbors),
    style = rlang::enquo(style),
    zero_policy = rlang::enquo(zero_policy)
  )
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "spatialreg_reg", ...
  )
}

#' Fonction interne de fit spatialreg pour parsnip
#'
#' @keywords internal
#' @export
spatialreg_fit_impl <- function(formula, data, coords, W = NULL,
                                model_type = "SAR", k_neighbors = 8,
                                style = "W", zero_policy = TRUE) {
  # Normalisation standard pour workflow/parsnip: data.frame classique,
  # reponse eventuellement renomme par workflow(), et formule sans coordonnees.
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  spatial_args <- resolve_spatial_knn_args(
    coords = coords, W = W, k_neighbors = k_neighbors,
    style = style, zero_policy = zero_policy, data = data
  )
  coords <- spatial_args$coords
  k_neighbors <- spatial_args$k_neighbors
  style <- spatial_args$style
  zero_policy <- spatial_args$zero_policy
  model_formula <- drop_formula_terms(formula, coords, data = data)
  x_vars <- attr(stats::terms(model_formula, data = data), "term.labels")
  # Pour SDM, `type = "mixed"` lagge implicitement aussi l'intercept dans
  # certaines versions de spatialreg. On passe une formule Durbin explicite
  # limitee aux covariables pour eviter `lag.(Intercept)` et l'alias associe.
  sdm_durbin_formula <- if (length(x_vars) > 0) stats::reformulate(x_vars) else FALSE

  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  listw_train <- if (is.null(spatial_args$W)) {
    build_knn_listw(coords_mat, k = k_neighbors, style = style, zero_policy = zero_policy)
  } else if (inherits(spatial_args$W, "listw")) {
    spatial_args$W
  } else {
    spdep::mat2listw(as.matrix(spatial_args$W), style = style)
  }
  model_type <- toupper(model_type)

  # do.call() injecte l'objet formule evalue dans l'appel spatialreg. Cela
  # evite que predict.Sarlm() cherche plus tard une variable locale nommee
  # `model_formula`, qui n'existe plus hors de cette fonction.
  fit_obj <- switch(model_type,
    SAR = do.call(spatialreg::lagsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      zero.policy = zero_policy
    )),
    SEM = do.call(spatialreg::errorsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      zero.policy = zero_policy
    )),
    SDM = do.call(spatialreg::lagsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      Durbin = sdm_durbin_formula, zero.policy = zero_policy
    )),
    stop(sprintf("spatialreg_reg: model_type inconnu: %s", model_type),
         call. = FALSE)
  )
  fit_obj$call$formula <- model_formula

  # predict.Sarlm() a besoin de reconstruire un listw compatible avec les
  # donnees train+test. On stocke donc les donnees d'entrainement et le
  # parametrage du voisinage sur l'objet ajuste.
  attr(fit_obj, "spatialreg_train_data") <- data
  attr(fit_obj, "spatialreg_coords_cols") <- coords
  attr(fit_obj, "spatialreg_k_neighbors") <- k_neighbors
  attr(fit_obj, "spatialreg_style") <- style
  attr(fit_obj, "spatialreg_zero_policy") <- zero_policy
  attr(fit_obj, "spatialreg_x_vars") <- x_vars
  fit_obj
}

#' Forme reduite manuelle pour SDM (type="mixed") hors echantillon
#'
#' SDM a besoin de W*X pour les nouvelles observations en plus de W*y.
#' `predict.Sarlm(all.data=FALSE)` ne sait pas la construire hors echantillon
#' pour ce type -- confirme le 2026-07-06 sur london_hp: "Input data and
#' neighbourhood list have different dimensions", que ce soit newdata=test
#' seul (listw train+test) ou newdata=train+test complet (listw incoherente
#' avec les row.names internes du fit). API documentee comme fragile dans
#' `wiki/metadata/tidymodels_parsnip_extension_procedure.md`. On calcule donc
#' la forme reduite nous-memes sur un systeme ferme limite au fold de test:
#' W_test (kNN parmi les points de test uniquement), X_test avec ses lags
#' W_test %*% X_test, puis y_hat = (I - rho*W_test)^-1 %*% (design %*% beta).
#' C'est une approximation (le systeme "vrai" inclurait aussi les voisins
#' d'entrainement), mais elle produit un resultat defendable plutot qu'un
#' plantage ou -- pire -- un nombre faux silencieux.
#'
#' @keywords internal
#' @export
spatialreg_predict_sdm_reduced_form <- function(fit_obj, test_data, x_vars, coords, k_neighbors) {
  Xd <- stats::model.matrix(stats::reformulate(x_vars), data = test_data)
  k_use <- min(k_neighbors, nrow(test_data) - 1)
  W_test <- as.matrix(build_knn_W(as.matrix(test_data[, coords, drop = FALSE]),
                                  k = k_use, sparse = FALSE))
  WX <- W_test %*% Xd[, setdiff(colnames(Xd), "(Intercept)"), drop = FALSE]
  colnames(WX) <- paste0("lag.", colnames(WX))
  design <- cbind(Xd, WX)

  coefs <- stats::coef(fit_obj)
  keep <- intersect(colnames(design), names(coefs))
  trend <- as.numeric(design[, keep, drop = FALSE] %*% coefs[keep])
  rho <- unname(fit_obj$rho)
  as.numeric(solve(diag(nrow(W_test)) - rho * W_test, trend))
}

#' Fonction interne de prediction spatialreg pour parsnip
#'
#' @keywords internal
#' @export
spatialreg_pred_impl <- function(object, new_data) {
  fit_obj <- parsnip::extract_fit_engine(object)
  train <- attr(fit_obj, "spatialreg_train_data")
  coords <- attr(fit_obj, "spatialreg_coords_cols")
  k_neighbors <- attr(fit_obj, "spatialreg_k_neighbors")
  style <- attr(fit_obj, "spatialreg_style")
  zero_policy <- attr(fit_obj, "spatialreg_zero_policy")
  x_vars <- attr(fit_obj, "spatialreg_x_vars")
  test <- as.data.frame(new_data)
  coords <- check_spatial_coords(coords, data = test)

  if (isTRUE(fit_obj$type == "mixed")) {
    common_cols <- intersect(names(train), names(test))
    test_data <- test[, common_cols, drop = FALSE]
    return(spatialreg_predict_sdm_reduced_form(fit_obj, test_data, x_vars, coords, k_neighbors))
  }

  # workflow::predict() transmet new_data sans la variable reponse. On construit
  # le listw sur train+test pour que les nouveaux points aient des voisins,
  # mais on passe seulement les lignes test a predict.Sarlm(). Avec SDM/type
  # mixed, passer train+test comme newdata cree des region.id dupliques.
  common_cols <- intersect(names(train), names(test))
  all_data <- rbind(train[, common_cols, drop = FALSE], test[, common_cols, drop = FALSE])
  row.names(all_data) <- as.character(seq_len(nrow(all_data)))
  # NE PAS decaler les noms de lignes de test_data vers n_train+1..n_train+
  # n_test: teste et confirme empiriquement (2026-07-06, london_hp) que ce
  # decalage fausse la prediction de predict.Sarlm(all.data=FALSE) -- RMSE
  # ~30% pire qu'avec les noms de lignes naturels de `test`, alors que
  # sar_lag/sem_error/sdm_mixed devraient au moins egaler glm sur le meme
  # fold. Les lignes de test_data restent donc avec leurs propres noms de
  # lignes (issus de `new_data`), independants de ceux de all_data/listw_all.
  test_data <- test[, common_cols, drop = FALSE]
  listw_all <- build_knn_listw(
    as.matrix(all_data[, coords, drop = FALSE]),
    k = k_neighbors, style = style, zero_policy = zero_policy
  )
  # all.data=TRUE dirait a predict.Sarlm() que `newdata` contient DEJA train+
  # test combines; comme on ne lui passe que les lignes test (test_data), ce
  # desaccord ne plante pas mais produit des predictions fausses (confirme
  # empiriquement: RMSE ~30% pire qu'avec all.data=FALSE sur london_hp, alors
  # que sar_lag/sem_error/sdm_mixed devraient au moins egaler glm). listw_all
  # (construit sur train+test) reste necessaire pour que les nouveaux points
  # aient des voisins dans W, mais all.data doit rester FALSE puisque
  # `newdata` ne contient que les lignes nouvelles.
  preds <- tryCatch(
    suppressWarnings(stats::predict(
      fit_obj, newdata = test_data, listw = listw_all,
      pred.type = "TS", all.data = FALSE, zero.policy = zero_policy
    )),
    error = function(e) e
  )
  if (inherits(preds, "error")) {
    stop(sprintf(
      "spatialreg_reg: predict.Sarlm() a echoue; aucune prediction tendance X*beta n'est utilisee en repli. Cause: %s",
      conditionMessage(preds)
    ), call. = FALSE)
  }
  preds <- as.numeric(preds)
  if (length(preds) != nrow(test)) {
    preds <- tail(preds, nrow(test))
  }

  as.numeric(preds)
}
