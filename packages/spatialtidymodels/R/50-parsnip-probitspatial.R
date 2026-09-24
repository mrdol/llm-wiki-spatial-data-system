
# Moteur parsnip custom pour le probit spatial (SAR/SEM), package ProbitSpatial
# (Martinetti & Geniaux, 2017, "Approximate likelihood estimation of spatial
# probit models", Regional Science and Urban Economics 64:30-45).
#
# Objectif: premier estimateur binaire du package -- meme patron que
# 10-parsnip-spatialreg.R (fit_impl/pred_impl enregistres pour parsnip), mais
# mode = "classification". ProbitSpatial::predict.ProbitSpatial() expose deja
# une prediction hors echantillon via la formule BLUP de Goulard et al.
# (2017) -- meme reference deja etudiee pour KP2 dans 10-parsnip-spatialreg.R
# -- donc contrairement a SDM (forme reduite maison necessaire), on reutilise
# directement la methode du package plutot que de recoder la prediction.
#
# SARAR n'est volontairement pas expose ici, pour rester coherent avec le trio
# SAR/SEM/SDM deja gere ailleurs dans le package (pas de troisieme
# specification tant qu'aucun jeu de donnees curee n'en a besoin).

#' Specification parsnip pour le probit spatial (SAR/SEM)
#'
#' Cree une specification `parsnip` pour un modele probit avec dependance
#' spatiale, ajuste par `ProbitSpatial::ProbitSpatialFit()`.
#'
#' @param mode Mode parsnip. Seul `"classification"` est supporte.
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param W Matrice de poids spatiaux fournie au fit (sinon construite par kNN).
#' @param model_type Type de modele: `"SAR"` ou `"SEM"`.
#' @param k_neighbors Nombre de voisins utilise pour construire W.
#' @param style Style de standardisation (seul `"W"`, row-standardise, est
#'   supporte -- `ProbitSpatialFit()` exige un W standardise par ligne).
#' @param zero_policy Politique pour les observations sans voisin.
#'
#' @return Une specification de modele `parsnip`.
#' @export
probit_spatial_reg <- function(mode = "classification", coords = NULL, W = NULL,
                               model_type = NULL, k_neighbors = NULL,
                               style = "W", zero_policy = TRUE) {
  args <- list(
    coords = rlang::enquo(coords),
    W = rlang::enquo(W),
    model_type = rlang::enquo(model_type),
    k_neighbors = rlang::enquo(k_neighbors),
    style = rlang::enquo(style),
    zero_policy = rlang::enquo(zero_policy)
  )
  parsnip::new_model_spec(
    "probit_spatial_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Specification parsnip explicite pour SAR probit
#'
#' Raccourci lisible autour de `probit_spatial_reg(model_type = "SAR")`.
#'
#' @inheritParams probit_spatial_reg
#' @return Une specification de modele `parsnip`.
#' @export
sar_probit_reg <- function(mode = "classification", coords = NULL, W = NULL,
                           k_neighbors = NULL, style = "W", zero_policy = TRUE) {
  parsnip::new_model_spec(
    "probit_spatial_reg",
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

#' Specification parsnip explicite pour SEM probit
#'
#' Raccourci lisible autour de `probit_spatial_reg(model_type = "SEM")`.
#'
#' @inheritParams probit_spatial_reg
#' @return Une specification de modele `parsnip`.
#' @export
sem_probit_reg <- function(mode = "classification", coords = NULL, W = NULL,
                           k_neighbors = NULL, style = "W", zero_policy = TRUE) {
  parsnip::new_model_spec(
    "probit_spatial_reg",
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

#' @export
#' @method update probit_spatial_reg
update.probit_spatial_reg <- function(object, parameters = NULL, coords = NULL,
                                      W = NULL, model_type = NULL, k_neighbors = NULL,
                                      style = NULL, zero_policy = NULL,
                                      fresh = FALSE, ...) {
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
    fresh = fresh, cls = "probit_spatial_reg", ...
  )
}

#' Attache `Matrix` au chemin de recherche si necessaire
#'
#' Contournement pour un defaut interne de `ProbitSpatial` (confirme
#' empiriquement, 2026-09): `ProbitSpatialFit()`/`predict.ProbitSpatial()`
#' echouent avec "aucun element du nom de 'package:Matrix' dans la liste de
#' recherche" des que `Matrix` n'est charge que comme dependance d'espace de
#' noms (`Imports`, le cas normal pour un package qui appelle
#' `ProbitSpatial::...` explicitement) plutot qu'attache via `library()`.
#' `Matrix::Matrix()`/`methods::as(..., "dgCMatrix")` fonctionnent
#' parfaitement dans ce meme contexte -- le probleme est interne au code de
#' `ProbitSpatial`, pas a notre construction de W. `library()` dans une
#' fonction de package est habituellement deconseille, mais c'est le seul
#' contournement qui fonctionne sans forker `ProbitSpatial`; garde par
#' `search()` pour rester idempotent.
#'
#' @keywords internal
probitspatial_ensure_matrix_attached <- function() {
  if (!"package:Matrix" %in% search()) {
    suppressPackageStartupMessages(library("Matrix", character.only = TRUE))
  }
  invisible(TRUE)
}

#' Construit un W dgCMatrix standardise par ligne pour ProbitSpatial
#'
#' `ProbitSpatialFit()`/`predict.ProbitSpatial()` exigent une classe
#' `"dgCMatrix"` explicite (confirme dans la doc CRAN et empiriquement:
#' `build_knn_W(..., sparse = TRUE)` retourne un `Matrix::Matrix` sparse deja
#' standardise par ligne via `mgwrsar::normW()`, mais pas toujours strictement
#' de classe `dgCMatrix` selon la version de `Matrix` -- coercion explicite
#' pour eviter une erreur silencieuse cote ProbitSpatial).
#'
#' @keywords internal
probitspatial_build_W <- function(coords, k_neighbors) {
  W <- build_knn_W(as.matrix(coords), k = k_neighbors, sparse = TRUE)
  methods::as(W, "dgCMatrix")
}

#' Fonction interne de fit du probit spatial pour parsnip
#'
#' @keywords internal
#' @export
probitspatial_fit_impl <- function(formula, data, coords, W = NULL,
                                   model_type = "SAR", k_neighbors = 8,
                                   style = "W", zero_policy = TRUE) {
  probitspatial_ensure_matrix_attached()
  model_type <- toupper(model_type)
  if (!model_type %in% c("SAR", "SEM")) {
    stop(sprintf(
      "probit_spatial_reg: model_type inconnu: %s (seuls SAR et SEM sont geres)",
      model_type
    ), call. = FALSE)
  }
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  spatial_args <- resolve_spatial_knn_args(
    coords = coords, W = W, k_neighbors = k_neighbors,
    style = style, zero_policy = zero_policy, data = data
  )
  coords <- spatial_args$coords
  k_neighbors <- spatial_args$k_neighbors
  model_formula <- drop_formula_terms(formula, coords, data = data)

  y_name <- all.vars(model_formula)[1]
  y_raw <- data[[y_name]]
  # Normalisation 0/1 explicite, independante de ce que parsnip fait de
  # object$lvl en amont (le mode classification de parsnip attend un facteur,
  # mais les jeux binaires cures du projet stockent souvent Y en 0/1
  # numerique -- voir wiki/datasets/fiches_datasets/paper_coral_bathypathes.md
  # par exemple). On stocke nos propres etiquettes de niveaux sur l'objet
  # ajuste plutot que de dependre de object$lvl cote appelant.
  if (is.factor(y_raw)) {
    if (nlevels(y_raw) != 2L) {
      stop(sprintf(
        "probit_spatial_reg: la reponse doit avoir exactement 2 niveaux, %d trouves.",
        nlevels(y_raw)
      ), call. = FALSE)
    }
    lvl <- levels(y_raw)
    y01 <- as.integer(y_raw) - 1L
  } else {
    uy <- sort(unique(y_raw[!is.na(y_raw)]))
    if (!identical(as.numeric(uy), c(0, 1))) {
      stop(sprintf(
        "probit_spatial_reg: la reponse doit etre binaire (0/1 ou facteur a 2 niveaux), valeurs trouvees: %s.",
        paste(uy, collapse = ", ")
      ), call. = FALSE)
    }
    lvl <- c("0", "1")
    y01 <- as.integer(y_raw)
  }
  data[[y_name]] <- y01

  W_train <- if (!is.null(spatial_args$W)) {
    methods::as(spatial_args$W, "dgCMatrix")
  } else {
    probitspatial_build_W(data[, coords, drop = FALSE], k_neighbors)
  }

  fit_obj <- ProbitSpatial::ProbitSpatialFit(
    formula = model_formula, data = data, W = W_train,
    DGP = model_type, method = "conditional"
  )

  attr(fit_obj, "probitspatial_train_data") <- data
  attr(fit_obj, "probitspatial_coords_cols") <- coords
  attr(fit_obj, "probitspatial_k_neighbors") <- k_neighbors
  attr(fit_obj, "probitspatial_formula") <- model_formula
  attr(fit_obj, "probitspatial_lvl") <- lvl
  fit_obj
}

#' Fonction interne de prediction du probit spatial pour parsnip
#'
#' Retourne toujours la probabilite predite (classe positive = second niveau
#' stocke au fit); `set_pred()` construit les sorties "class"/"prob" a partir
#' de ce vecteur, comme le fait `parsnip` lui-meme pour `logistic_reg()`.
#'
#' @keywords internal
#' @export
probitspatial_pred_impl <- function(object, new_data) {
  probitspatial_ensure_matrix_attached()
  fit_obj <- parsnip::extract_fit_engine(object)
  train <- attr(fit_obj, "probitspatial_train_data")
  coords <- attr(fit_obj, "probitspatial_coords_cols")
  k_neighbors <- attr(fit_obj, "probitspatial_k_neighbors")
  model_formula <- attr(fit_obj, "probitspatial_formula")
  test <- as.data.frame(new_data)
  coords <- check_spatial_coords(coords, data = test)

  # predict.ProbitSpatial(oos=TRUE) attend un WSO ordonne in-sample d'abord,
  # puis out-of-sample (voir doc CRAN, confirme empiriquement) -- meme
  # exigence d'ordre que le "train dans all_data en premier" deja utilise pour
  # SAR/SEM dans spatialreg_pred_impl().
  common_cols <- intersect(names(train), names(test))
  all_data <- rbind(train[, common_cols, drop = FALSE], test[, common_cols, drop = FALSE])
  W_all <- probitspatial_build_W(all_data[, coords, drop = FALSE], k_neighbors)

  # X doit avoir les memes colonnes, dans le meme ordre, que celles utilisees
  # au fit (ProbitSpatialFit applique lui-meme model.matrix(formula) en
  # interne au moment du fit ; predict() ne refait pas cette verification,
  # donc reconstruire X avec la MEME formule est essentiel pour que l'ordre
  # des colonnes corresponde aux coefficients internes du fit).
  X_all <- stats::model.matrix(model_formula[-2], data = all_data)

  # predict.ProbitSpatial() est une methode S3, pas une fonction exportee
  # individuellement -- stats::predict() dispatche dessus via la classe de
  # fit_obj (meme mecanique que stats::predict() sur un objet Sarlm).
  preds <- tryCatch(
    stats::predict(
      fit_obj, X = X_all, type = "response", oos = TRUE, WSO = W_all
    ),
    error = function(e) e
  )
  if (inherits(preds, "error")) {
    stop(sprintf(
      "probit_spatial_reg: predict.ProbitSpatial() a echoue. Cause: %s",
      conditionMessage(preds)
    ), call. = FALSE)
  }
  preds <- as.numeric(preds)
  n_test <- nrow(test)
  if (length(preds) != n_test) {
    preds <- utils::tail(preds, n_test)
  }
  as.numeric(preds)
}
