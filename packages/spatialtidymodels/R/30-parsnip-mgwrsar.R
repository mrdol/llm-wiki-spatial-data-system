
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

# Model="SAR" appelle en interne une routine qui rappelle int_prems() par nom
# nu. Dans un package installe, Imports charge le namespace mgwrsar mais ne
# l'attache pas au search path; on attache donc mgwrsar uniquement quand cette
# branche specifique est appelee.
ensure_mgwrsar_attached <- function() {
  # Necessaire pour mgwrsar::MGWRSAR(Model = "SAR") dans le backend actuel de
  # mgwrsar; sans attachement, l'appel interne echoue sur int_prems().
  if (!"package:mgwrsar" %in% search()) {
    suppressPackageStartupMessages(
      base::library("mgwrsar", character.only = TRUE)
    )
  }
  invisible(TRUE)
}

# ---------------------------------------------------------------------------
# Construction de W pour Model="SAR" (2026-07-04): MGWRSAR() ne construit
# aucune matrice de poids spatiaux pour ce chemin (contrairement a "GWR", qui
# derive tout du couple kernels/H) -- W doit etre fourni via control$W, sinon
# le SAR global (lambda constant, beta constant) n'a rien a regresser sur
# W%*%Y. La construction kNN + normW ligne-standardise est factorisee dans
# R/utils/spatial_weights.R pour partager exactement la meme definition de W
# entre mgwrsar, spboost, spatialreg et les diagnostics.
mgwrsar_build_knn_W <- function(coords, k = 8) build_knn_W(coords, k = k, sparse = TRUE)

split_mgwrsar_control <- function(control) {
  # Le backend natif comprend control$W, mais pas les champs auxiliaires que le
  # benchmark utilise pour garantir une prediction fold par fold coherente.
  # On retire donc ces champs avant MGWRSAR(), puis on les stocke sur l'objet
  # ajuste pour mgwrsar_pred_impl().
  if (is.null(control)) control <- list()
  W_predict <- control$W_predict
  W_predict_coords <- control$W_predict_coords
  control$W_predict <- NULL
  control$W_predict_coords <- NULL
  list(control = control, W_predict = W_predict, W_predict_coords = W_predict_coords)
}

attach_mgwrsar_prediction_context <- function(fit, W_predict = NULL, W_predict_coords = NULL) {
  # Conserve le contexte de prediction construit au niveau du fold. C'est utile
  # pour SAR/MGWRSAR: le bloc train de W_predict doit correspondre au W utilise
  # pendant le fit, au lieu de reconstruire un nouveau voisinage au predict().
  if (!is.null(W_predict)) {
    attr(fit, "spatialtidymodels_W_predict") <- W_predict
  }
  if (!is.null(W_predict_coords)) {
    attr(fit, "spatialtidymodels_W_predict_coords") <- as.matrix(W_predict_coords)
  }
  fit
}

#' parsnip specification for mgwrsar models
#'
#' Creates a `parsnip` model specification for GWR, MGWR, TDS-MGWR, SAR and
#' MGWRSAR variants provided by `mgwrsar`.
#'
#' @param mode parsnip mode. Only `"regression"` is supported.
#' @param coords Character vector of length 2 with the coordinate column names.
#' @param model_type Native mgwrsar `Model=` value, for example `"GWR"`,
#'   `"MGWR"` or `"MGWRSAR_1_0_kv"`. The special values `"tds_mgwr"` and
#'   `"atds_mgwr"` call `mgwrsar::TDS_MGWR()` instead of
#'   `mgwrsar::MGWRSAR()`.
#' @param kernel Native mgwrsar `kernels=` value. The benchmark layer fixes it
#'   to `"gauss"`; direct advanced model specs may still pass another native
#'   value if needed.
#' @param bandwidth Native mgwrsar `H=` bandwidth. Use a scalar for GWR and
#'   MGWRSAR benchmark routes, or a vector for direct `model_type = "MGWR"`
#'   fits. Ignored for `"tds_mgwr"` and `"atds_mgwr"` because those algorithms
#'   estimate one bandwidth per covariate internally by backfitting.
#' @param fixed_vars Character vector naming coefficients kept spatially
#'   stationary in mixed MGWRSAR models such as `"MGWRSAR_0_kc_kv"` and
#'   `"MGWRSAR_1_kc_kv"`.
#' @param kernels Historical alias of `kernel`, kept for compatibility with
#'   earlier benchmark scripts.
#'
#' @details
#' The automatic benchmark tunes scalar `bandwidth`/`kernel` grids for
#' `mgwrsar_gwr` and `mgwrsar_mgwrsar`. Direct vector-`H` tuning for native
#' `Model = "MGWR"` is intentionally left to the user because each covariate
#' has its own bandwidth dimension.
#'
#' @return A `parsnip` model specification.
#' @export
mgwrsar_reg <- function(mode = "regression", coords = NULL, model_type = NULL,
                         kernel = NULL, bandwidth = NULL, fixed_vars = NULL,
                         kernels = NULL) {
  # Constructeur utilisateur: il stocke les arguments dans une spec parsnip.
  # Les noms "model_type" et "bandwidth" sont plus lisibles que les noms natifs
  # MGWRSAR ("Model" et "H"), puis la table set_model_arg() fait la traduction.
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernel = rlang::enquo(kernel),
    bandwidth = rlang::enquo(bandwidth),
    fixed_vars = rlang::enquo(fixed_vars)
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
                                kernel = NULL, bandwidth = NULL, fixed_vars = NULL,
                                kernels = NULL,
                                fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    model_type = rlang::enquo(model_type),
    kernel = rlang::enquo(kernel),
    bandwidth = rlang::enquo(bandwidth),
    fixed_vars = rlang::enquo(fixed_vars)
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
                              kernels = "gauss", H = NULL, fixed_vars = NULL,
                              control = list()) {
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
  control_parts <- split_mgwrsar_control(control)
  control <- control_parts$control

  # Branche MGWR multiscale par Top-Down Scale (2026-07-04): `TDS_MGWR()`
  # estime lui-meme le vecteur H par backfitting. C'est la route automatique
  # recommandee pour le benchmark lorsque chaque covariable peut avoir sa
  # propre echelle spatiale. Le `Model = "MGWR"` natif reste disponible plus
  # bas si l'utilisateur fournit deja un vecteur H. Le benchmark automatique se
  # limite volontairement aux grilles scalaires pour eviter une grille
  # combinatoire sur un H par covariable.
  if (Model %in% c("tds_mgwr", "atds_mgwr")) {
    ctl <- control
    if (is.null(ctl$adaptive)) ctl$adaptive <- TRUE
    fit <- mgwrsar::TDS_MGWR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      fixed_vars = fixed_vars,
      Model = Model,
      kernels = kernels,
      control_tds = list(nns = 20L),  # defaut recommande par le papier (M=20-30)
      control = ctl
    )
    return(attach_mgwrsar_prediction_context(
      fit,
      W_predict = control_parts$W_predict,
      W_predict_coords = control_parts$W_predict_coords
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
    ensure_mgwrsar_attached()
    ctl <- control
    if (is.null(ctl$W)) ctl$W <- mgwrsar_build_knn_W(coords_mat, k = 8)
    fit <- mgwrsar::MGWRSAR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      kernels = kernels,
      H = 1,
      Model = "SAR",
      control = ctl
    )
    return(attach_mgwrsar_prediction_context(
      fit,
      W_predict = control_parts$W_predict,
      W_predict_coords = control_parts$W_predict_coords
    ))
  }

  # Branche MGWRSAR avec autocorrelation spatiale explicite. Elle repond a la
  # demande "Model = MGWRSAR_1_0_kv + control(W = W)": contrairement au GWR
  # simple, le modele utilise une matrice W fournie dans control pour estimer
  # une dependance spatiale en plus des coefficients locaux.
  if (Model %in% c("MGWRSAR_1_0_kv", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")) {
    if (Model %in% c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv") && is.null(fixed_vars)) {
      stop("Mixed MGWRSAR models require `fixed_vars`.", call. = FALSE)
    }
    ctl <- control
    if (is.null(ctl$adaptive)) ctl$adaptive <- TRUE
    if (is.null(ctl$W)) ctl$W <- mgwrsar_build_knn_W(coords_mat, k = 8)
    if (is.null(H)) H <- 20
    fit <- mgwrsar::MGWRSAR(
      formula = model_formula,
      data = data,
      coords = coords_mat,
      fixed_vars = fixed_vars,
      kernels = kernels,
      H = H,
      Model = Model,
      control = ctl
    )
    return(attach_mgwrsar_prediction_context(
      fit,
      W_predict = control_parts$W_predict,
      W_predict_coords = control_parts$W_predict_coords
    ))
  }

  if (is.null(H)) {
    stop(
      "mgwrsar_reg() requires `bandwidth` (mgwrsar's `H`) for this model_type. ",
      "Pass a scalar H, pass a vector H for native MGWR, use ",
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
  # Appel reel au package mgwrsar. Ici `Model` peut etre "GWR", "MGWR" si H est
  # un vecteur deja choisi, ou une autre variante MGWRSAR acceptee par le
  # backend natif.
  fit <- mgwrsar::MGWRSAR(
    formula = model_formula,
    data = data,
    coords = coords_mat,
    fixed_vars = fixed_vars,
    kernels = kernels,
    H = H,
    Model = Model,
    control = ctl
  )
  attach_mgwrsar_prediction_context(
    fit,
    W_predict = control_parts$W_predict,
    W_predict_coords = control_parts$W_predict_coords
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
  if (nrow(newdata_coords) == nrow(fit_obj@coords) &&
      isTRUE(all.equal(newdata_coords, fit_obj@coords, check.attributes = FALSE)) &&
      "fit" %in% methods::slotNames(fit_obj) &&
      length(fit_obj@fit) == nrow(new_data)) {
    # Prediction in-sample: les modeles MGWRSAR mixtes ont deja leurs valeurs
    # ajustees dans le slot natif @fit. Les repasser dans predict_mgwrsar()
    # ferait croire au backend qu'on demande une prediction train+test, ce qui
    # double artificiellement l'echantillon et casse certains chemins C++.
    return(as.numeric(fit_obj@fit))
  }
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
  if (fit_obj@Model %in% c("SAR", "MGWRSAR_1_0_kv", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")) {
    # Pour SAR/MGWRSAR_1_0_kv, la prediction hors echantillon a besoin d'une W
    # train+test explicite. Le backend natif sait tenter une reconstruction
    # interne avec h_w/kernel_w quand W=NULL, mais notre route de fit ne renseigne
    # pas ces slots. Le contrat du package est donc plus net: on reconstruit W
    # ici avec la meme convention kNN que le fit et on la transmet explicitement.
    combined_coords <- rbind(fit_obj@coords, newdata_coords)
    stored_W <- attr(fit_obj, "spatialtidymodels_W_predict", exact = TRUE)
    stored_coords <- attr(fit_obj, "spatialtidymodels_W_predict_coords", exact = TRUE)
    if (!is.null(stored_W)) {
      if (!identical(dim(stored_W), rep(nrow(combined_coords), 2L))) {
        stop(
          "Stored MGWRSAR prediction W does not match the requested train/test size.",
          call. = FALSE
        )
      }
      if (!is.null(stored_coords) && !isTRUE(all.equal(stored_coords, combined_coords, check.attributes = FALSE))) {
        stop(
          "Stored MGWRSAR prediction W was built for different train/test coordinates.",
          call. = FALSE
        )
      }
      extra_args$W <- stored_W
    } else {
      extra_args$W <- mgwrsar_build_knn_W(combined_coords, k = 8)
    }
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
