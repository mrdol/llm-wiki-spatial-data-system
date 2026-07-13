
# Moteur parsnip custom pour mgwrsar::MGWRSAR() ("tidification" de
# MGWR/MGWRSAR, selon wiki/metadata/r_estimator_implementation_policy_v1.md et
# le test benchmark manuel de 2026-07). La CV reste entierement externe: ce
# fichier enregistre seulement fit/predict, sans logique de resampling.
#
# Signatures confirmees (2026-07-02, mgwrsar 1.3.2):
#   MGWRSAR(formula, data, coords, fixed_vars=NULL, kernels, H, Model="GWR", control=list())
#   predict_mgwrsar(model, newdata, newdata_coords, W=NULL, type="BPN",
#                    h_w=100, kernel_w="rectangle", method_pred='TP', k_extra=8, exposant=8)
# predict_mgwrsar prend directement newdata_coords, pas une matrice W combinee
# comme spboost.

require_package("parsnip", "custom mgwrsar_reg() parsnip engine")
require_package("mgwrsar", "MGWRSAR")

# Model="SAR" appelle en interne Rcpp::mod(), qui rappelle la fonction R
# int_prems() par son nom -- alors qu'elle est bien exportee par mgwrsar,
# requireNamespace() (via require_package() ci-dessus) ne l'attache PAS au
# search path/globalenv, et l'appel echoue avec "impossible de trouver la
# fonction 'int_prems'" (confirme le 2026-07-04 sur Georgia). Meme classe de
# bug, meme correctif que pour library(mboost) dans parsnip_spboost.R.
library(mgwrsar)

# ---------------------------------------------------------------------------
# Construction de W pour Model="SAR" (2026-07-04): MGWRSAR() ne construit
# aucune matrice de poids spatiaux pour ce chemin (contrairement a "GWR", qui
# derive tout du couple kernels/H) -- W doit etre fourni via control$W, sinon
# le SAR global (lambda constant, beta constant) n'a rien a regresser sur
# W%*%Y. La construction kNN + normW ligne-standardise est factorisee dans
# R/utils/spatial_weights.R pour partager exactement la meme definition de W
# entre mgwrsar, spboost, spatialreg et les diagnostics.
mgwrsar_build_knn_W <- function(coords, k = 8) build_knn_W(coords, k = k, sparse = TRUE)

#' Specification parsnip pour mgwrsar
#'
#' Cree une specification `parsnip` experimentale pour les variantes GWR,
#' MGWR et MGWRSAR fournies par `mgwrsar`.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte.
#' @param coords Vecteur de caracteres de longueur 2 avec les noms des colonnes
#'   de coordonnees.
#' @param model_type Valeur mgwrsar `Model=`, par exemple "GWR", "MGWR",
#'   "MGWRSAR_0_kc_kv". Deux valeurs speciales "tds_mgwr"/"atds_mgwr"
#'   (2026-07-04) declenchent un chemin different: mgwrsar::TDS_MGWR() au lieu
#'   de mgwrsar::MGWRSAR() -- voir le commentaire dans mgwrsar_fit_impl().
#' @param kernel Valeur mgwrsar `kernels=`, par exemple `"gauss"` ou `"bisq"`.
#' @param bandwidth Bande passante mgwrsar `H=` (valeur unique ou vecteur par
#'   noyau). Ignoree pour model_type="tds_mgwr"/"atds_mgwr": ces algorithmes
#'   trouvent eux-memes une bande passante par covariable via backfitting.
#' @param kernels Alias historique de `kernel`, conserve pour compatibilite
#'   avec les scripts manuels du benchmark.
#'
#' @return Une specification de modele `parsnip`.
#' @export
mgwrsar_reg <- function(mode = "regression", coords = NULL, model_type = NULL,
                         kernel = NULL, bandwidth = NULL, kernels = NULL) {
  # Constructeur utilisateur: il stocke les arguments dans une spec parsnip.
  # Les noms "model_type" et "bandwidth" sont plus lisibles que les noms natifs
  # MGWRSAR ("Model" et "H"), puis la table set_model_arg() fait la traduction.
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernel = rlang::enquo(kernel),
    bandwidth = rlang::enquo(bandwidth)
  )
  if (!rlang::quo_is_null(rlang::enquo(kernels)) && rlang::quo_is_null(args$kernel)) {
    args$kernel <- rlang::enquo(kernels)
  }
  parsnip::new_model_spec(
    "mgwrsar_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @export
#' @method update mgwrsar_reg
# Methode update() requise par tune::tune_grid()/finalize_model() (2026-07-03).
# Meme besoin que pour spboost_reg (voir parsnip_spboost.R): sans cette
# methode S3, update(spec, parameters) tombe sur stats::update.default() et
# echoue avec "il faut un objet avec une composante call". On delegue a
# l'utilitaire interne parsnip:::update_spec(), comme le font les modeles
# natifs de parsnip (ex. parsnip:::update.linear_reg).
update.mgwrsar_reg <- function(object, parameters = NULL, coords = NULL, model_type = NULL,
                                kernel = NULL, bandwidth = NULL, kernels = NULL,
                                fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernel = rlang::enquo(kernel),
    bandwidth = rlang::enquo(bandwidth)
  )
  if (!rlang::quo_is_null(rlang::enquo(kernels)) && rlang::quo_is_null(args$kernel)) {
    args$kernel <- rlang::enquo(kernels)
  }
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "mgwrsar_reg", ...
  )
}

# ---------------------------------------------------------------------------
# Mise en oeuvre du fit
# ---------------------------------------------------------------------------

# Les noms de parametres doivent correspondre aux noms `original` declares via
# set_model_arg() (coords/Model/kernels/H). Le dispatch parsnip transmet les
# arguments avec ces noms natifs, pas avec les noms exposes dans mgwrsar_reg()
# (model_type/bandwidth).
#' Fonction interne de fit mgwrsar pour parsnip
#'
#' @keywords internal
#' @export
mgwrsar_fit_impl <- function(formula, data, coords, Model = "GWR",
                              kernels = "bisq", H = NULL, control = list()) {
  # Comme pour spboost, workflows peut transmettre une reponse appelee "..y" et
  # un tibble. On normalise avant d'appeler mgwrsar::MGWRSAR().
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
  coords <- check_spatial_coords(coords, data = data)
  # Les coordonnees doivent rester dans data pour construire le noyau spatial,
  # mais elles ne doivent pas devenir des X du modele. On les retire donc de la
  # formule envoyee au backend natif.
  model_formula <- drop_formula_terms(formula, coords, data = data)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])

  # Branche "vrai" MGWR multiscale (2026-07-04): Model="GWR" (le seul chemin
  # utilise jusqu'ici dans le benchmark) impose UNE SEULE bande passante H
  # pour toutes les covariables. Ce n'est pas le MGWR-SAR de
  # Geniaux & Martinetti (2018) ni le MGWR de Fotheringham et al. (2017), qui
  # autorisent une bande passante DIFFERENTE par covariable -- confirme en
  # lisant man/MGWR.Rd ("H: A vector of bandwidths") et le papier top-down
  # scale (mgwrsar::TDS_MGWR(), qui implemente precisement les algorithmes
  # tds_mgwr/atds_mgwr de ce papier). Model="MGWR" dans MGWRSAR() attendrait
  # donc un vecteur H deja connu (pas encore cable ici); TDS_MGWR() est
  # prefere car il trouve lui-meme ce vecteur par backfitting, sans qu'on ait
  # a fournir de bande passante externe -- pas d'equivalent a "mstop"/"H" a
  # tuner ici, contrairement a spboost/GWR.
  if (Model %in% c("tds_mgwr", "atds_mgwr")) {
    ctl <- control
    if (is.null(ctl$adaptive)) ctl$adaptive <- TRUE
    return(mgwrsar::TDS_MGWR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      Model = Model,
      kernels = kernels,
      control_tds = list(nns = 20L),  # defaut recommande par le papier (M=20-30)
      control = ctl
    ))
  }

  # Branche SAR global "simple" (2026-07-04), ajoutee comme baseline de
  # comparaison (lambda constant, beta constant -- pas de variation spatiale
  # des coefficients, contrairement a GWR/MGWR). MGWRSAR() ne construit pas W
  # elle-meme pour ce Model: on la fournit via control$W (kNN, k=8, meme
  # patron que spboost). H/kernels ne sont pas utilises par le calcul SAR
  # lui-meme (pas de noyau), mais MGWRSAR() assigne quand meme
  # `mymodel@H <- H[1]` inconditionnellement en fin de fonction -- un H=NULL
  # y casserait l'assignation du slot S4; on passe donc H=1 en valeur factice.
  if (Model == "SAR") {
    W <- mgwrsar_build_knn_W(coords_mat, k = 8)
    ctl <- control
    ctl$W <- W
    return(mgwrsar::MGWRSAR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      kernels = kernels,
      H = 1,
      Model = "SAR",
      control = ctl
    ))
  }

  # Branche MGWRSAR avec autocorrelation spatiale explicite. Elle repond a la
  # demande "Model = MGWRSAR_1_0_kv + control(W = W)": contrairement au GWR
  # simple, le modele utilise une matrice W fournie dans control pour estimer
  # une dependance spatiale en plus des coefficients locaux.
  if (Model == "MGWRSAR_1_0_kv") {
    ctl <- control
    if (is.null(ctl$adaptive)) ctl$adaptive <- TRUE
    if (is.null(ctl$W)) ctl$W <- mgwrsar_build_knn_W(coords_mat, k = 8)
    if (is.null(H)) H <- 20
    return(mgwrsar::MGWRSAR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      kernels = kernels,
      H = H,
      Model = Model,
      control = ctl
    ))
  }

  if (is.null(H)) {
    stop(
      "mgwrsar_reg() requires `bandwidth` (mgwrsar's `H`) - no default bandwidth ",
      "selection is wired up in this manual-test engine yet; pass a value, use ",
      "mgwrsar::golden_search_bandwidth() beforehand, or set model_type to ",
      "\"tds_mgwr\"/\"atds_mgwr\" for automatic per-covariate bandwidth search.",
      call. = FALSE
    )
  }
  # `adaptive = TRUE` traite H comme un nombre de voisins, ce qui reste portable
  # entre CRS et unites de distance. C'est plus robuste pour un test manuel sur
  # des jeux de donnees aux echelles tres differentes. Un control$adaptive
  # fourni par l'appelant garde toutefois la priorite.
  ctl <- control
  if (is.null(ctl$adaptive)) ctl$adaptive <- TRUE
  # Appel reel au package mgwrsar. Ici Model="GWR" donne le GWR/MGWR simple;
  # d'autres variantes MGWRSAR peuvent etre branchees via model_type.
  mgwrsar::MGWRSAR(
    formula = model_formula,
    data = data,
    coords = coords_mat,
    kernels = kernels,
    H = H,
    Model = Model,
    control = ctl
  )
}

# ---------------------------------------------------------------------------
# Mise en oeuvre du predict
# ---------------------------------------------------------------------------

#' Fonction interne de prediction mgwrsar pour parsnip
#'
#' @keywords internal
#' @export
mgwrsar_pred_impl <- function(object, new_data, coords) {
  # predict_mgwrsar() demande explicitement les coordonnees des nouvelles
  # observations. Contrairement a spboost, on n'a pas besoin de reconstruire
  # une matrice W train+test complete.
  fit_obj <- parsnip::extract_fit_engine(object)
  coords <- check_spatial_coords(coords, data = new_data)
  newdata_coords <- as.matrix(new_data[, coords, drop = FALSE])
  # predict_mgwrsar() est documentee dans man/predict_mgwrsar.Rd mais n'est
  # pas exportee dans le NAMESPACE de mgwrsar (confirme le 2026-07-02); on la
  # recupere donc depuis le namespace interne.
  predict_fun <- get("predict_mgwrsar", envir = asNamespace("mgwrsar"))
  # La valeur par defaut method_pred="TP" (Target Points) renvoie ici des
  # predictions degenerees toutes nulles pour un modele ajuste sans sous-
  # echantillon target-point reduit (notre cas, confirme empiriquement le
  # 2026-07-02 sur Georgia). "kernel" donne des valeurs plausibles pour un
  # ajustement standard sur tout l'echantillon; c'est le defaut de ce moteur.
  # Exception (2026-07-04): pour un modele ajuste avec TDS_MGWR() (Model
  # "tds_mgwr"/"atds_mgwr"), predict_mgwrsar() lui-meme documente que
  # method_pred="TP" n'est pas implemente et bascule automatiquement vers
  # "shepard" -- on demande donc directement "shepard" pour ces modeles,
  # "kernel" restant le choix valide pour GWR classique.
  method_pred <- if (fit_obj@Model %in% c("tds_mgwr", "atds_mgwr")) "shepard" else "kernel"

  extra_args <- list()
  if (fit_obj@Model %in% c("SAR", "MGWRSAR_1_0_kv")) {
    # predict_mgwrsar()'s SAR branch (BP_pred_SAR()) needs an explicit
    # train+test W for out-of-sample extrapolation. Its own auto-build
    # fallback (triggered when W=NULL) reads model@h_w/@kernel_w, but
    # MGWRSAR() never populates those slots (they stay numeric(0)/
    # character(0), not NULL) -- confirmed by reading methods.R's class
    # definition (no prototype defaults) and MGWRSAR.R (no `mymodel@h_w <-`
    # assignment anywhere). `is.null(numeric(0))` is FALSE, so that fallback
    # would silently run with a garbage bandwidth instead of erring loudly.
    # Passing W ourselves sidesteps it entirely (see `is.null(W)` guard in
    # predict_mgwrsar.R).
    combined_coords <- rbind(fit_obj@coords, newdata_coords)
    extra_args$W <- mgwrsar_build_knn_W(combined_coords, k = 8)
  }

  as.numeric(do.call(predict_fun, c(list(
    model = fit_obj,
    newdata = new_data,
    newdata_coords = newdata_coords,
    method_pred = method_pred
  ), extra_args)))
}

# ---------------------------------------------------------------------------
# Enregistrement du modele
# ---------------------------------------------------------------------------

# Protection contre le re-source() (2026-07-04): meme raison que dans
# parsnip_spboost.R -- parsnip::set_new_model() leve une erreur si le modele
# est deja enregistre, ce qui arrive des qu'on relance source() sur ce
# fichier dans une session R deja initialisee. Seuls les appels
# parsnip::set_*() sont proteges par ce garde -- les fonctions ci-dessus
# (mgwrsar_reg, mgwrsar_fit_impl, mgwrsar_pred_impl, update.mgwrsar_reg)
# restent redefinies a chaque source().
