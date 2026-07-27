
# Moteur parsnip custom pour spboost::spbgam() ("tidification" de SpBoost,
# selon wiki/metadata/r_estimator_implementation_policy_v1.md et le test
# benchmark manuel de 2026-07). La CV reste entierement externe: ce fichier
# enregistre seulement fit/predict, sans logique de resampling.
#
# Signatures confirmees (2026-07-02, spboost 0.6.3):
#   spbgam(formula, data, W, W2=NULL, DGP="SAR", method="gamboost_ML", control=list())
#   predict_spboost(model, newdata, data, W, W2=NULL, type="BPN", maxobs=25000, chunksize=4000)
# predict_spboost demande a la fois les donnees d'entrainement `data` ET une
# matrice `W` complete (train+test), reconstruite puis standardisee par ligne
# a partir des coordonnees combinees. Voir R/example_SAR_NONLIN.R:120-127 dans
# le code source de spboost pour le patron de reference suivi ici.

require_package("parsnip", "custom spboost_reg() parsnip engine")
require_package("spboost", "SpBoost spatial boosting models")
require_package("mboost", "SpBoost boost_control objects")

# mboost::gamboost() (appele en interne par spboost::spbgam()) doit pouvoir
# resoudre bbs()/bols() au moment ou il evalue les termes de la formule.
# Le patron habituel du projet -- attacher juste la fonction dans
# environment(formula), comme fait pour mgcv::s dans build_gam_spatial_formula()
# -- ne marche PAS ici: teste le 2026-07-04, gamboost() ne les trouve pas via
# l'environnement de la formule et echoue avec "objet 'bbs' introuvable". Un
# library(mboost) explicite (donc un attachement reel du package, pas
# seulement requireNamespace) est necessaire; voir spb_build_boosting_formula()
# plus bas pour le contexte complet du bug corrige.
library(mboost)

# ---------------------------------------------------------------------------
# Construction de W: matrice de poids kNN simple, standardisee par ligne.
# Les valeurs par defaut de build_Wk()/kernel_matW() dans spboost sont reglees
# pour des n plus grands et plantaient sur de petits jeux de test (2026-07-02);
# un assemblage direct nabor::knn + mgwrsar::normW est plus simple et marche
# pour tout n >= k+1.
# ---------------------------------------------------------------------------

spb_build_knn_W <- function(coords, k = 8) build_knn_W(coords, k = k, sparse = TRUE)

# ---------------------------------------------------------------------------
# Construction de la formule de boosting: bbs() pour les predicteurs continus,
# bols() pour les predicteurs binaires 0/1.
# ---------------------------------------------------------------------------
# Bug corrige le 2026-07-04: une formule brute "y ~ x1 + x2 + ..." fait que
# gamboost() attribue par defaut un lisseur P-spline bbs() a CHAQUE
# predicteur numerique, y compris les dummies 0/1. Un lisseur P-spline sur
# seulement deux valeurs distinctes produit une base rank-deficiente, ce qui
# fait planter le solveur Lapack interne ("leading principal minor of order
# k is zero"). Confirme sur ewhp (dataset immobilier avec 8 dummies de type/
# age de batiment): l'echec se produit meme avec la formule reduite utilisee
# AVANT ce correctif (5 dummies + FlrArea), donc ce n'est pas propre au
# dataset "corrige" avec 9 predicteurs -- c'est un probleme general dont
# aucun des estimateurs testes jusqu'ici (georgia, nyc_education) n'avait de
# predicteur binaire pour le reveler. On route donc chaque predicteur vers
# bols() (terme lineaire) s'il n'a que 2 valeurs distinctes, sinon vers bbs()
# (lissage P-spline), un patron standard en boosting/GAM pour des covariables
# melangees continues/binaires.
spb_build_boosting_formula <- function(formula, data) {
  y <- deparse(formula[[2]])
  x_vars <- attr(stats::terms(formula, data = data), "term.labels")
  is_binary <- function(v) length(unique(v[!is.na(v)])) <= 2
  term_txt <- vapply(x_vars, function(v) {
    if (is_binary(data[[v]])) {
      sprintf("mboost::bols(%s)", v)
    } else {
      sprintf("mboost::bbs(%s)", v)
    }
  }, character(1))
  stats::as.formula(paste(y, "~", paste(term_txt, collapse = " + ")))
}

#' Specification parsnip pour spboost
#'
#' Cree une specification `parsnip` pour les estimateurs boosting spatiaux
#' fournis par `spboost::spbgam()`.
#'
#' Cette spec est fonctionnelle dans les workflows et le benchmark du package.
#' Le backend natif reste toutefois exigeant: il attend une formule et un
#' `data.frame` classiques, et `predict_spboost()` demande les donnees
#' d'entrainement plus une matrice W train+test reconstruite au moment de la
#' prediction. Le wrapper gere ces contraintes, mais elles expliquent pourquoi
#' cette route est plus encadree que les modeles parsnip natifs.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Vecteur de caracteres de longueur 2 avec les noms des colonnes
#'   de coordonnees, deja dans un CRS projete/metrique.
#' @param DGP Famille du processus generateur de donnees spboost: "SAR", "SEM",
#'   "SARAR".
#' @param method Nom de methode spboost, par exemple "BSPA_SAR_ML"/"BSPA_SEM_ML".
#'   Si NULL, il est deduit de `DGP` (SAR -> BSPA_SAR_ML, SEM -> BSPA_SEM_ML,
#'   SARAR -> BSPA_SARAR_ML), comme dans R/estimators/fit_spboost.R.
#'   Les suffixes ML et CFE indiquent deux methodes d'estimation du parametre
#'   spatial; ils ne changent pas la famille spatiale du modele.
#' @param mstop Nombre d'iterations de boosting mboost.
#' @param nu Taux d'apprentissage mboost. Dans le benchmark automatique, `nu`
#'   est conserve fixe via `spboost_nu`; le tuning porte sur `mstop` et
#'   `k_neighbors`.
#' @param k_neighbors Nombre de plus proches voisins utilise pour construire
#'   la matrice de poids spatiaux W standardisee par ligne, au fit et au predict.
#'
#' @return Une specification de modele `parsnip`.
#' @export
spboost_reg <- function(mode = "regression", coords = NULL, DGP = NULL,
                         method = NULL, mstop = NULL, nu = NULL, k_neighbors = NULL) {
  # Constructeur utilisateur: c'est l'equivalent local de linear_reg() ou
  # boost_tree(), mais pour le package spboost. Les arguments sont captures
  # avec enquo() pour rester compatibles avec tune::tune().
  args <- list(
    coords = rlang::enquo(coords),
    DGP = rlang::enquo(DGP),
    method = rlang::enquo(method),
    mstop = rlang::enquo(mstop),
    nu = rlang::enquo(nu),
    k_neighbors = rlang::enquo(k_neighbors)
  )
  parsnip::new_model_spec(
    "spboost_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

spboost_bspa_reg <- function(mode = "regression", coords = NULL, DGP,
                             method, mstop = NULL, nu = NULL,
                             k_neighbors = NULL) {
  # Raccourci interne pour les variantes BSPA explicites. ML et CFE sont deux
  # estimateurs du parametre spatial, pas deux structures spatiales differentes.
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo(!!DGP),
      method = rlang::quo(!!method),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Explicit parsnip specification for BSPA SAR ML
#'
#' Creates a `parsnip` specification for `spboost::spbgam()` with
#' `DGP = "SAR"` and `method = "BSPA_SAR_ML"`.
#'
#' `ML` and `CFE` are alternative estimators of the spatial parameter, not
#' different spatial model families. `nu` is treated as a fixed learning rate;
#' the supported tuning path uses `mstop` and `k_neighbors`.
#'
#' @inheritParams spboost_reg
#' @return A `parsnip` model specification.
#' @export
spboost_bspa_sar_ml <- function(mode = "regression", coords = NULL,
                                mstop = NULL, nu = NULL,
                                k_neighbors = NULL) {
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo("SAR"),
      method = rlang::quo("BSPA_SAR_ML"),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Explicit parsnip specification for BSPA SAR CFE
#'
#' Creates a `parsnip` specification for `spboost::spbgam()` with
#' `DGP = "SAR"` and `method = "BSPA_SAR_CFE"`.
#'
#' `ML` and `CFE` are alternative estimators of the spatial parameter, not
#' different spatial model families. `nu` is treated as a fixed learning rate;
#' the supported tuning path uses `mstop` and `k_neighbors`.
#'
#' @inheritParams spboost_reg
#' @return A `parsnip` model specification.
#' @export
spboost_bspa_sar_cfe <- function(mode = "regression", coords = NULL,
                                 mstop = NULL, nu = NULL,
                                 k_neighbors = NULL) {
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo("SAR"),
      method = rlang::quo("BSPA_SAR_CFE"),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Explicit parsnip specification for BSPA SEM ML
#'
#' Creates a `parsnip` specification for `spboost::spbgam()` with
#' `DGP = "SEM"` and `method = "BSPA_SEM_ML"`.
#'
#' `ML` and `CFE` are alternative estimators of the spatial parameter, not
#' different spatial model families. `nu` is treated as a fixed learning rate;
#' the supported tuning path uses `mstop` and `k_neighbors`.
#'
#' @inheritParams spboost_reg
#' @return A `parsnip` model specification.
#' @export
spboost_bspa_sem_ml <- function(mode = "regression", coords = NULL,
                                mstop = NULL, nu = NULL,
                                k_neighbors = NULL) {
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo("SEM"),
      method = rlang::quo("BSPA_SEM_ML"),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' Explicit parsnip specification for BSPA SEM CFE
#'
#' Creates a `parsnip` specification for `spboost::spbgam()` with
#' `DGP = "SEM"` and `method = "BSPA_SEM_CFE"`.
#'
#' `ML` and `CFE` are alternative estimators of the spatial parameter, not
#' different spatial model families. `nu` is treated as a fixed learning rate;
#' the supported tuning path uses `mstop` and `k_neighbors`.
#'
#' @inheritParams spboost_reg
#' @return A `parsnip` model specification.
#' @export
spboost_bspa_sem_cfe <- function(mode = "regression", coords = NULL,
                                 mstop = NULL, nu = NULL,
                                 k_neighbors = NULL) {
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo("SEM"),
      method = rlang::quo("BSPA_SEM_CFE"),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @export
#' @method update spboost_reg
# Methode update() requise par tune::tune_grid()/finalize_model() (2026-07-03).
# tune_grid() substitue chaque valeur de grille dans la spec en appelant
# update(spec, parameters = <tibble avec la colonne "mstop">). Sans cette
# methode S3 propre au modele, R retombe sur stats::update.default(), qui
# exige un champ $call absent de nos specs -> "need an object with call
# component" / "il faut un objet avec une composante call". C'est exactement
# le patron suivi par parsnip pour ses propres modeles (voir
# parsnip:::update.linear_reg): on delegue a l'utilitaire interne
# parsnip:::update_spec(), qui fusionne les nouveaux arguments dans la spec.
update.spboost_reg <- function(object, parameters = NULL, coords = NULL, DGP = NULL,
                                method = NULL, mstop = NULL, nu = NULL, k_neighbors = NULL,
                                fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    DGP = rlang::enquo(DGP),
    method = rlang::enquo(method),
    mstop = rlang::enquo(mstop),
    nu = rlang::enquo(nu),
    k_neighbors = rlang::enquo(k_neighbors)
  )
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "spboost_reg", ...
  )
}

# ---------------------------------------------------------------------------
# Mise en oeuvre du fit
# ---------------------------------------------------------------------------

#' Fonction interne de fit spboost pour parsnip
#'
#' @keywords internal
#' @export
spboost_fit_impl <- function(formula, data, coords, DGP = "SAR", method = NULL,
                              mstop = 500L, nu = 0.1, k_neighbors = 8) {
  # workflows/parsnip peut renommer la reponse en "..y" et fournir un tibble.
  # Le backend spboost est exigeant: il attend une formule et un data.frame classiques.
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  coords <- check_spatial_coords(coords, data = data)
  k_neighbors <- check_k_neighbors(k_neighbors, n = nrow(data))

  # Les coordonnees sont utilisees pour construire W, pas comme covariables.
  # Elles sont pourtant presentes dans la formule workflow pour eviter que
  # workflows les supprime avant l'appel au moteur.
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  W <- spb_build_knn_W(coords_mat, k = k_neighbors)
  model_formula <- drop_formula_terms(formula, coords, data = data)
  # bbs()/bols() explicites plutot qu'une formule brute -- voir le commentaire
  # de spb_build_boosting_formula() plus haut pour le bug que ceci corrige.
  model_formula <- spb_build_boosting_formula(model_formula, data)

  default_method <- switch(toupper(DGP),
    SAR = "BSPA_SAR_ML", SEM = "BSPA_SEM_ML", SARAR = "BSPA_SARAR_ML",
    "BSPA_SAR_ML"
  )
  method_use <- if (is.null(method)) default_method else method

  control <- list(control_gamboost = mboost::boost_control(mstop = mstop, nu = nu))
  # Appel reel au package spboost: tout ce qui precede sert uniquement a
  # traduire l'interface tidymodels vers l'API native spboost::spbgam().
  model <- spboost::spbgam(
    formula = model_formula, data = data, W = W,
    DGP = DGP, method = method_use, control = control
  )

  # predict_spboost() a besoin des donnees d'entrainement ORIGINALES et des
  # coordonnees pour reconstruire W train+test au moment de predire. On les
  # stocke donc comme attributs sur l'objet ajuste.
  attr(model, "spb_train_data") <- data
  attr(model, "spb_train_coords_cols") <- coords
  attr(model, "spb_k_neighbors") <- k_neighbors
  model
}

# ---------------------------------------------------------------------------
# Mise en oeuvre du predict
# ---------------------------------------------------------------------------

#' Fonction interne de prediction spboost pour parsnip
#'
#' @keywords internal
#' @export
spboost_pred_impl <- function(object, new_data) {
  # Pour predire, spboost a besoin des donnees d'entrainement ET des nouvelles
  # observations dans une meme matrice W train+test. Ces informations ont ete
  # stockees comme attributs sur l'objet fit dans spboost_fit_impl().
  fit_obj <- parsnip::extract_fit_engine(object)
  train_data <- attr(fit_obj, "spb_train_data")
  coords <- attr(fit_obj, "spb_train_coords_cols")
  k <- attr(fit_obj, "spb_k_neighbors")
  coords <- check_spatial_coords(coords, data = new_data)

  train_coords <- as.matrix(train_data[, coords, drop = FALSE])
  test_coords <- as.matrix(new_data[, coords, drop = FALSE])
  W_full <- spb_build_knn_W(rbind(train_coords, test_coords), k = k)

  as.numeric(spboost::predict_spboost(
    model = fit_obj,
    newdata = new_data,
    data = train_data,
    W = W_full
  ))
}

# ---------------------------------------------------------------------------
# Enregistrement du modele
# ---------------------------------------------------------------------------

# Protection contre le re-source() (2026-07-04): parsnip::set_new_model()
# leve une erreur ("Model ... already exists") si le modele est deja
# enregistre. Ca arrive des qu'on relance source() sur ce fichier dans une
# session R deja initialisee -- un cas frequent en developpement interactif
# (ex. re-sourcer benchmark_manual_test_2026-07.R apres une premiere
# execution dans la meme console). Seuls les appels parsnip::set_*() sont
# proteges par ce garde -- les fonctions ci-dessus (spboost_reg,
# spboost_fit_impl, spboost_pred_impl, update.spboost_reg) restent
# redefinies a chaque source(), pour qu'une correction apportee a l'une
# d'elles soit bien prise en compte sans devoir redemarrer R.
