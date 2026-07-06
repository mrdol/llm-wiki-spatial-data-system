source("R/utils/estimator_common.R")

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
require_package("nabor", "kNN spatial weight matrix construction (Model=\"SAR\")")

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
# W%*%Y. Meme patron que spb_build_knn_W() dans parsnip_spboost.R (kNN +
# normW ligne-standardise), duplique ici pour eviter une dependance a l'ordre
# de source() entre les deux fichiers de moteurs.
mgwrsar_build_knn_W <- function(coords, k = 8) {
  n <- nrow(coords)
  k_use <- min(k, n - 1)
  knn <- nabor::knn(coords, coords, k = k_use + 1)  # La colonne 1 est le point lui-meme (distance 0).
  idx <- knn$nn.idx[, -1, drop = FALSE]
  W <- matrix(0, n, n)
  for (i in seq_len(n)) W[i, idx[i, ]] <- 1
  W <- mgwrsar::normW(W)
  # normW() renvoie une matrice base R "de meme classe que l'entree" -- ici
  # dense, class "matrix"/"array". Le solveur SAR interne (Rcpp::mod(), route
  # Model="SAR") exige un objet S4 (dgCMatrix), sinon il echoue avec "Not an
  # S4 object" (confirme le 2026-07-04 sur Georgia). Meme correctif que
  # spb_build_knn_W() dans parsnip_spboost.R: un wrap Matrix::Matrix()
  # convertit automatiquement vers dgCMatrix (matrice tres creuse, k=8
  # voisins/ligne).
  Matrix::Matrix(W)
}

#' Constructeur utilisateur, aligne sur le style des specs parsnip::linear_reg().
#'
#' @param coords Vecteur de caracteres de longueur 2 avec les noms des colonnes
#'   de coordonnees.
#' @param model_type Valeur mgwrsar `Model=`, par exemple "GWR", "MGWR",
#'   "MGWRSAR_0_kc_kv". Deux valeurs speciales "tds_mgwr"/"atds_mgwr"
#'   (2026-07-04) declenchent un chemin different: mgwrsar::TDS_MGWR() au lieu
#'   de mgwrsar::MGWRSAR() -- voir le commentaire dans mgwrsar_fit_impl().
#' @param kernels Valeur mgwrsar `kernels=`, par exemple "bisq".
#' @param bandwidth Bande passante mgwrsar `H=` (valeur unique ou vecteur par
#'   noyau). Ignoree pour model_type="tds_mgwr"/"atds_mgwr": ces algorithmes
#'   trouvent eux-memes une bande passante par covariable via backfitting.
mgwrsar_reg <- function(mode = "regression", coords = NULL, model_type = NULL,
                         kernels = NULL, bandwidth = NULL) {
  # Constructeur utilisateur: il stocke les arguments dans une spec parsnip.
  # Les noms "model_type" et "bandwidth" sont plus lisibles que les noms natifs
  # MGWRSAR ("Model" et "H"), puis la table set_model_arg() fait la traduction.
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernels = rlang::enquo(kernels),
    bandwidth = rlang::enquo(bandwidth)
  )
  parsnip::new_model_spec(
    "mgwrsar_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

# Methode update() requise par tune::tune_grid()/finalize_model() (2026-07-03).
# Meme besoin que pour spboost_reg (voir parsnip_spboost.R): sans cette
# methode S3, update(spec, parameters) tombe sur stats::update.default() et
# echoue avec "il faut un objet avec une composante call". On delegue a
# l'utilitaire interne parsnip:::update_spec(), comme le font les modeles
# natifs de parsnip (ex. parsnip:::update.linear_reg).
update.mgwrsar_reg <- function(object, parameters = NULL, coords = NULL, model_type = NULL,
                                kernels = NULL, bandwidth = NULL, fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernels = rlang::enquo(kernels),
    bandwidth = rlang::enquo(bandwidth)
  )
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
mgwrsar_fit_impl <- function(formula, data, coords, Model = "GWR",
                              kernels = "bisq", H = NULL, control = list()) {
  # Comme pour spboost, workflows peut transmettre une reponse appelee "..y" et
  # un tibble. On normalise avant d'appeler mgwrsar::MGWRSAR().
  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)
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

mgwrsar_pred_impl <- function(object, new_data, coords) {
  # predict_mgwrsar() demande explicitement les coordonnees des nouvelles
  # observations. Contrairement a spboost, on n'a pas besoin de reconstruire
  # une matrice W train+test complete.
  fit_obj <- parsnip::extract_fit_engine(object)
  coords <- rlang::eval_tidy(coords)
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
  if (fit_obj@Model == "SAR") {
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
if (!"mgwrsar_reg" %in% parsnip::get_model_env()$models) {

  # Declaration du modele custom cote parsnip. Cette section permet ensuite
  # d'utiliser mgwrsar_reg() dans workflow(), fit_resamples() et tune_grid().
  parsnip::set_new_model("mgwrsar_reg")
  parsnip::set_model_mode(model = "mgwrsar_reg", mode = "regression")
  parsnip::set_model_engine("mgwrsar_reg", mode = "regression", eng = "mgwrsar")
  parsnip::set_dependency("mgwrsar_reg", eng = "mgwrsar", pkg = "mgwrsar")

  # Arguments de configuration non tunables pour le test manuel: coords est
  # obligatoire, tandis que kernels/H/Model ont des valeurs ou choix par defaut.
  for (arg in c("coords", "model_type", "kernels", "bandwidth")) {
    parsnip::set_model_arg(
      model = "mgwrsar_reg",
      eng = "mgwrsar",
      parsnip = arg,
      original = switch(arg,
        coords = "coords", model_type = "Model", kernels = "kernels", bandwidth = "H"
      ),
      func = switch(arg,
        bandwidth = list(pkg = "dials", fun = "neighbors"),
        list(pkg = "dials", fun = "neighbors")
      ),
      has_submodel = FALSE
    )
  }

  parsnip::set_fit(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    value = list(
      interface = "formula",
      protect = c("formula", "data"),
      func = c(fun = "mgwrsar_fit_impl"),
      defaults = list()
    )
  )

  parsnip::set_encoding(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    options = list(
      predictor_indicators = "none",
      compute_intercept = FALSE,
      remove_intercept = FALSE,
      allow_sparse_x = FALSE
    )
  )

  parsnip::set_pred(
    model = "mgwrsar_reg",
    eng = "mgwrsar",
    mode = "regression",
    type = "numeric",
    value = list(
      pre = NULL,
      post = function(results, object) as.numeric(results),
      func = c(fun = "mgwrsar_pred_impl"),
      args = list(
        object = quote(object),
        new_data = quote(new_data),
        coords = quote(object$spec$args$coords)
      )
    )
  )
}
