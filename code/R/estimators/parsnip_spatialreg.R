source("R/utils/estimator_common.R")
source("R/utils/spatial_weights.R")

# Moteur parsnip custom pour les modeles spatialreg classiques.
#
# Objectif: transformer SAR, SEM et SDM en specifications utilisables par
# workflows::workflow(), comme les autres estimateurs du pipeline. La
# validation croisee reste externe: ce fichier enregistre seulement fit/predict.

require_package("parsnip", "custom spatialreg_reg() parsnip engine")
require_package("spatialreg", "modeles SAR/SEM/SDM")

spatialreg_reg <- function(mode = "regression", coords = NULL,
                           model_type = NULL, k_neighbors = NULL) {
  # Constructeur utilisateur. model_type vaut "SAR", "SEM" ou "SDM".
  # Les coordonnees sont conservees dans la formule workflow pour arriver
  # jusqu'au moteur, puis retirees de la formule statistique native.
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    k_neighbors = rlang::enquo(k_neighbors)
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

update.spatialreg_reg <- function(object, parameters = NULL, coords = NULL,
                                  model_type = NULL, k_neighbors = NULL,
                                  fresh = FALSE, ...) {
  # Necessaire pour rester compatible avec la mecanique parsnip/tune, meme si
  # ces modeles ne sont pas encore tunes dans le benchmark courant.
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    k_neighbors = rlang::enquo(k_neighbors)
  )
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "spatialreg_reg", ...
  )
}

spatialreg_fit_impl <- function(formula, data, coords, model_type = "SAR",
                                k_neighbors = 8) {
  # Normalisation standard pour workflow/parsnip: data.frame classique,
  # reponse eventuellement renomme par workflow(), et formule sans coordonnees.
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  model_formula <- drop_formula_terms(formula, coords, data = data)
  x_vars <- attr(stats::terms(model_formula, data = data), "term.labels")

  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  listw_train <- build_knn_listw(coords_mat, k = k_neighbors)
  model_type <- toupper(model_type)

  # do.call() injecte l'objet formule evalue dans l'appel spatialreg. Cela
  # evite que predict.Sarlm() cherche plus tard une variable locale nommee
  # `model_formula`, qui n'existe plus hors de cette fonction.
  fit_obj <- switch(model_type,
    SAR = do.call(spatialreg::lagsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      zero.policy = TRUE
    )),
    SEM = do.call(spatialreg::errorsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      zero.policy = TRUE
    )),
    SDM = do.call(spatialreg::lagsarlm, list(
      formula = model_formula, data = data, listw = listw_train,
      type = "mixed", zero.policy = TRUE
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
  attr(fit_obj, "spatialreg_x_vars") <- x_vars
  fit_obj
}

spatialreg_pred_impl <- function(object, new_data) {
  fit_obj <- parsnip::extract_fit_engine(object)
  train <- attr(fit_obj, "spatialreg_train_data")
  coords <- attr(fit_obj, "spatialreg_coords_cols")
  k_neighbors <- attr(fit_obj, "spatialreg_k_neighbors")
  test <- as.data.frame(new_data)

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
  listw_all <- build_knn_listw(as.matrix(all_data[, coords, drop = FALSE]),
                               k = k_neighbors)
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
      pred.type = "TS", all.data = FALSE, zero.policy = TRUE
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

if (!"spatialreg_reg" %in% parsnip::get_model_env()$models) {
  parsnip::set_new_model("spatialreg_reg")
  parsnip::set_model_mode(model = "spatialreg_reg", mode = "regression")
  parsnip::set_model_engine("spatialreg_reg", mode = "regression", eng = "spatialreg")
  parsnip::set_dependency("spatialreg_reg", eng = "spatialreg", pkg = "spatialreg")

  for (arg in c("coords", "model_type", "k_neighbors")) {
    parsnip::set_model_arg(
      model = "spatialreg_reg",
      eng = "spatialreg",
      parsnip = arg,
      original = arg,
      func = list(pkg = "dials", fun = "neighbors"),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(fun = "spatialreg_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    options = list(
      predictor_indicators = "traditional",
      compute_intercept = TRUE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "spatialreg_reg",
    eng = "spatialreg",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(fun = "spatialreg_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data)
      )
    )
  )
}
