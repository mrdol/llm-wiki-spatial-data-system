
# Moteur parsnip custom pour INLA via un champ spatial SPDE (Matern, PC-priors),
# packages INLA (non CRAN, r-inla.org) + inlabru (CRAN, interface a base de
# composants/formule).
#
# Phase 1 (2026-09-14): reponse continue (famille gaussienne) uniquement.
# Phase 2 (2026-09-15): familles non-gaussiennes ajoutees -- binomial (lien
# logit ou cloglog) et poisson (lien log) -- motivees par la lecture directe
# de 3 papiers deja verifies dans le corpus qui utilisent reellement INLA
# ainsi: paper_flapper_skate_presence (Loca et al. 2025, binomial+cloglog),
# paper_mistletoe_bird_abundance (Poisson/binomiale negative), et
# paper_goa_trawl_demersal (Shelton et al. 2017, script R original
# "inlaScript Estimation+Proj, Dryad.R": binomial+gamma). La binomiale
# negative et la gamma restent hors perimetre (aucun routage
# response_typology existant dans fit_one_benchmark_estimator() pour ces deux
# familles -- seuls continuous/binary/count existent), extensible plus tard
# sans changer la structure de ce fichier.
#
# BYM2/ICAR (aucune matrice d'adjacence precalculee dans le corpus de jeux
# cures) et le modele barriere de INLAspacetime (aucune geometrie non convexe/
# cote/reseau hydrographique dans le corpus) restent hors perimetre -- voir
# wiki/estimators/inla.md, section "Statut d'implementation actuel".
#
# inlabru::bru() est prefere a INLA::inla() + inla.stack() construit a la
# main: bru() construit la pile du modele automatiquement a partir des
# composants (inlabru_2.14.1/inlabru/doc/component.Rmd). Contrairement a
# ProbitSpatial (aucune methode predict(), logique reconstruite a la main
# dans 50-parsnip-probitspatial.R), predict.bru(fit, newdata, formula=...)
# fait de la vraie prediction hors echantillon nativement (confirme dans
# inlabru_2.14.1/inlabru/doc/prediction_scores.R) -- inlaspde_pred_impl() en
# est donc nettement plus simple, y compris pour les familles non-gaussiennes
# (la transformation inverse-lien est appliquee dans la formule de prediction
# elle-meme, ex. `~ plogis(Intercept + x)`, pas recalculee a la main).

#' Specification parsnip pour un champ spatial INLA SPDE
#'
#' Cree une specification `parsnip` pour une regression avec un champ spatial
#' gaussien de Matern (SPDE, PC-priors), ajustee par `inlabru::bru()`.
#'
#' @param mode Mode parsnip. Seul `"regression"` est supporte -- y compris
#'   pour `family = "binomial"`, ou la prediction retournee est la
#'   probabilite continue (meme convention que `ols`/`gam_spatial` pour les
#'   taches binaires dans ce package: pas de mode `"classification"` distinct).
#' @param coords Colonnes de coordonnees disponibles dans le workflow.
#' @param family Famille `inlabru`/`INLA`: `"gaussian"` (defaut), `"binomial"`
#'   ou `"poisson"`.
#' @param link Lien explicite, ou `NULL` (defaut = lien canonique de la
#'   famille: identite/logit/log). Seul `"cloglog"` est accepte pour
#'   `family = "binomial"` (verifie empiriquement contre `inlabru::bru()`,
#'   motive par `paper_flapper_skate_presence`, Loca et al. 2025, qui utilise
#'   ce lien) ; aucun lien alternatif n'est supporte pour `"gaussian"`/
#'   `"poisson"` dans cette phase.
#' @param prior_range PC-prior `c(range0, p)` pour `INLA::inla.spde2.pcmatern()`.
#'   `NULL` (defaut): calcule depuis la diagonale de la bounding box des
#'   coordonnees, voir `inla_spde_default_priors()`.
#' @param prior_sigma PC-prior `c(sigma0, p)` pour `INLA::inla.spde2.pcmatern()`.
#'   `NULL` (defaut): calcule depuis l'ecart-type empirique de la reponse pour
#'   `family = "gaussian"` (echelle reponse = echelle du champ, lien
#'   identite), ou fixe a 1 pour les familles a lien non-identite (echelle du
#'   predicteur lineaire, pas celle de la reponse brute -- valeur alignee sur
#'   le prior faiblement informatif utilise par Loca et al. 2025, ecart-type
#'   ~1.4 teste jusqu'a 0.5). Voir `inla_spde_default_priors()`.
#' @param mesh_max_edge `max.edge` de `fmesher::fm_mesh_2d_inla()`. `NULL`
#'   (defaut): calcule depuis la diagonale de la bounding box, voir
#'   `inla_spde_default_mesh()`.
#' @param mesh_cutoff `cutoff` de `fmesher::fm_mesh_2d_inla()`. `NULL`
#'   (defaut): calcule depuis la diagonale de la bounding box.
#'
#' @return Une specification de modele `parsnip`.
#' @export
inla_spde_reg <- function(mode = "regression", coords = NULL,
                          family = "gaussian", link = NULL,
                          prior_range = NULL, prior_sigma = NULL,
                          mesh_max_edge = NULL, mesh_cutoff = NULL) {
  args <- list(
    coords = rlang::enquo(coords),
    family = rlang::enquo(family),
    link = rlang::enquo(link),
    prior_range = rlang::enquo(prior_range),
    prior_sigma = rlang::enquo(prior_sigma),
    mesh_max_edge = rlang::enquo(mesh_max_edge),
    mesh_cutoff = rlang::enquo(mesh_cutoff)
  )
  parsnip::new_model_spec(
    "inla_spde_reg",
    args = args,
    eng_args = NULL,
    mode = mode,
    method = NULL,
    engine = NULL
  )
}

#' @export
#' @method update inla_spde_reg
update.inla_spde_reg <- function(object, parameters = NULL, coords = NULL,
                                 family = NULL, link = NULL,
                                 prior_range = NULL, prior_sigma = NULL,
                                 mesh_max_edge = NULL, mesh_cutoff = NULL,
                                 fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    family = rlang::enquo(family),
    link = rlang::enquo(link),
    prior_range = rlang::enquo(prior_range),
    prior_sigma = rlang::enquo(prior_sigma),
    mesh_max_edge = rlang::enquo(mesh_max_edge),
    mesh_cutoff = rlang::enquo(mesh_cutoff)
  )
  parsnip:::update_spec(
    object = object, parameters = parameters, args_enquo_list = args,
    fresh = fresh, cls = "inla_spde_reg", ...
  )
}

#' Priors PC par defaut pour le champ SPDE, derives des donnees
#'
#' Regle deterministe et reproductible (pas de reglage manuel par jeu de
#' donnees): `prior.range = c(diagonale_bbox / 5, 0.5)` -- forme PC-prior
#' standard ("weak default", 50% de probabilite a priori de depassement,
#' Fuglstad et al. 2019). Pour `prior.sigma`, l'echelle pertinente depend du
#' lien: `family = "gaussian"` (lien identite) utilise `c(ecart_type(y), 0.5)`
#' -- l'amplitude du champ est directement sur l'echelle de la reponse. Pour
#' les familles a lien non-identite (`"binomial"`/`"poisson"`), l'ecart-type
#' de Y brut n'a pas de sens sur l'echelle du predicteur lineaire (ex. Y
#' binaire 0/1 a un ecart-type ~0.5, sans rapport avec l'amplitude
#' raisonnable d'un effet spatial en logit/log) -- `c(1, 0.5)` est utilise a
#' la place, aligne sur le prior faiblement informatif de Loca et al. (2025,
#' `paper_flapper_skate_presence`), qui utilisent un ecart-type ~1.4 (teste
#' jusqu'a 0.5) pour leurs effets fixes en contexte similaire. Les valeurs
#' passees explicitement dans `prior_range`/`prior_sigma` court-circuitent le
#' calcul correspondant.
#'
#' @keywords internal
inla_spde_default_priors <- function(coords, y, family = "gaussian",
                                     prior_range = NULL, prior_sigma = NULL) {
  coords <- as.matrix(coords)
  bbox_diag <- sqrt(diff(range(coords[, 1])) ^ 2 + diff(range(coords[, 2])) ^ 2)
  if (is.null(prior_range)) prior_range <- c(bbox_diag / 5, 0.5)
  if (is.null(prior_sigma)) {
    sigma0 <- if (identical(family, "gaussian")) stats::sd(y, na.rm = TRUE) else 1
    prior_sigma <- c(sigma0, 0.5)
  }
  list(prior_range = prior_range, prior_sigma = prior_sigma)
}

#' Maillage SPDE par defaut, derive des donnees
#'
#' Memes considerations que `inla_spde_default_priors()`: parametres
#' `fmesher::fm_mesh_2d_inla()` calcules depuis la diagonale de la bounding
#' box des coordonnees, sans reglage manuel par jeu de donnees.
#'
#' @keywords internal
inla_spde_default_mesh <- function(coords, max_edge = NULL, cutoff = NULL, offset = NULL) {
  coords <- as.matrix(coords)
  bbox_diag <- sqrt(diff(range(coords[, 1])) ^ 2 + diff(range(coords[, 2])) ^ 2)
  if (is.null(max_edge)) max_edge <- c(bbox_diag / 15, bbox_diag / 5)
  if (is.null(cutoff)) cutoff <- bbox_diag / 100
  if (is.null(offset)) offset <- c(bbox_diag / 10, bbox_diag / 5)
  fmesher::fm_mesh_2d_inla(loc = coords, max.edge = max_edge, cutoff = cutoff, offset = offset)
}

#' Normalise Y en 0/1 numerique pour la famille binomiale
#'
#' Meme logique que `probitspatial_fit_impl()` (`50-parsnip-probitspatial.R`):
#' les jeux binaires cures du projet stockent Y soit en facteur a 2 niveaux
#' (coercion faite en amont par `fit_one_benchmark_estimator()` pour
#' `response_typology == "binary"`), soit deja en 0/1 numerique selon le
#' chemin d'appel -- `inlabru::bru(family = "binomial")` exige un 0/1
#' numerique, pas un facteur.
#'
#' @keywords internal
inlaspde_normalize_binomial_y <- function(y_raw) {
  if (is.factor(y_raw)) {
    if (nlevels(y_raw) != 2L) {
      stop(sprintf(
        "inla_spde_reg: la reponse doit avoir exactement 2 niveaux pour family='binomial', %d trouves.",
        nlevels(y_raw)
      ), call. = FALSE)
    }
    return(as.integer(y_raw) - 1L)
  }
  uy <- sort(unique(y_raw[!is.na(y_raw)]))
  if (!identical(as.numeric(uy), c(0, 1))) {
    stop(sprintf(
      "inla_spde_reg: la reponse doit etre binaire (0/1 ou facteur a 2 niveaux) pour family='binomial', valeurs trouvees: %s.",
      paste(uy, collapse = ", ")
    ), call. = FALSE)
  }
  as.integer(y_raw)
}

#' Formule de prediction (echelle reponse) selon famille/lien
#'
#' `predict.bru()` attend une formule sur l'echelle voulue par
#' l'utilisateur, calculee a partir des noms de composants du predicteur
#' lineaire (`Intercept`, les covariables, `field`) -- voir l'exemple Poisson
#' de `inlabru_2.14.1/inlabru/doc/prediction_scores.R`
#' (`formula = ~ exp(Intercept + x)`). Combinaisons famille/lien limitees a
#' celles verifiees empiriquement pour cette phase: gaussienne (identite),
#' binomiale (logit par defaut ou cloglog), poisson (log par defaut). Toute
#' autre combinaison echoue explicitement plutot que de deviner une
#' transformation inverse-lien non verifiee.
#'
#' @keywords internal
inla_spde_pred_transform <- function(family, link) {
  if (identical(family, "gaussian")) {
    if (!is.null(link)) {
      stop("inla_spde_reg: aucun lien alternatif n'est supporte pour family='gaussian'.", call. = FALSE)
    }
    return(function(eta_expr) eta_expr)
  }
  if (identical(family, "binomial")) {
    if (is.null(link) || identical(link, "logit")) {
      return(function(eta_expr) sprintf("plogis(%s)", eta_expr))
    }
    if (identical(link, "cloglog")) {
      return(function(eta_expr) sprintf("1 - exp(-exp(%s))", eta_expr))
    }
    stop(sprintf(
      "inla_spde_reg: lien '%s' non supporte pour family='binomial' (seuls NULL/'logit' et 'cloglog' le sont).",
      link
    ), call. = FALSE)
  }
  if (identical(family, "poisson")) {
    if (!is.null(link) && !identical(link, "log")) {
      stop(sprintf(
        "inla_spde_reg: lien '%s' non supporte pour family='poisson' (seul le lien log par defaut l'est).",
        link
      ), call. = FALSE)
    }
    return(function(eta_expr) sprintf("exp(%s)", eta_expr))
  }
  stop(sprintf(
    "inla_spde_reg: family '%s' non supportee (seules 'gaussian', 'binomial' et 'poisson' le sont dans cette phase).",
    family
  ), call. = FALSE)
}

#' Fonction interne de fit du champ SPDE INLA pour parsnip
#'
#' @keywords internal
#' @export
inlaspde_fit_impl <- function(formula, data, coords, family = "gaussian",
                              link = NULL, prior_range = NULL,
                              prior_sigma = NULL, mesh_max_edge = NULL,
                              mesh_cutoff = NULL) {
  require_package("INLA", "l'estimateur INLA SPDE")
  require_package("inlabru", "l'estimateur INLA SPDE")
  require_package("fmesher", "le maillage de l'estimateur INLA SPDE")

  # Valide la combinaison famille/lien tot, avant tout calcul couteux (mesh,
  # fit), et construit au passage le transformateur inverse-lien reutilise
  # ci-dessous pour la formule de prediction.
  pred_transform <- inla_spde_pred_transform(family, link)

  sanitized <- sanitize_formula_response(formula, data)
  formula <- sanitized$formula
  data <- as.data.frame(sanitized$data)

  coords <- check_spatial_coords(coords, data = data)
  model_formula <- drop_formula_terms(formula, coords, data = data)
  y_name <- all.vars(model_formula)[1]
  x_terms <- attr(stats::terms(model_formula, data = data), "term.labels")

  coord_matrix <- as.matrix(data[, coords[1:2], drop = FALSE])
  y_values <- data[[y_name]]
  if (identical(family, "binomial")) {
    y_values <- inlaspde_normalize_binomial_y(y_values)
    data[[y_name]] <- y_values
  }

  mesh <- inla_spde_default_mesh(coord_matrix, max_edge = mesh_max_edge, cutoff = mesh_cutoff)
  priors <- inla_spde_default_priors(
    coord_matrix, y_values, family = family,
    prior_range = prior_range, prior_sigma = prior_sigma
  )
  spde <- INLA::inla.spde2.pcmatern(
    mesh, prior.range = priors$prior_range, prior.sigma = priors$prior_sigma
  )

  # Syntaxe de composants inlabru: reponse ~ Intercept(1) + covariables +
  # field(cbind(cx, cy), model = spde) -- confirme dans
  # inlabru_2.14.1/inlabru/doc/prediction_scores.R (`bru(y ~ Intercept(1) + x,
  # family = "poisson", data = ...)`) et dans component.Rmd pour la syntaxe
  # de champ spatial (`my_spde_effect(cbind(x, y), model = spde_model)`).
  comp_terms <- c(
    "Intercept(1)",
    x_terms,
    sprintf("field(cbind(%s, %s), model = spde)", coords[1], coords[2])
  )
  comp_formula <- stats::as.formula(
    paste(y_name, "~", paste(comp_terms, collapse = " + ")),
    env = environment(formula)
  )
  environment(comp_formula)$spde <- spde

  # Le lien non-canonique (cloglog) passe par control.family, transmis a
  # INLA::inla() via le "..." de inlabru::bru() -- confirme empiriquement
  # (fit$.args$control.family[[1]]$link reflete bien "cloglog" apres fit).
  bru_args <- list(components = comp_formula, family = family, data = data)
  if (!is.null(link) && !identical(link, "logit") && !identical(link, "log")) {
    bru_args$control.family <- list(link = link)
  }
  fit_obj <- do.call(inlabru::bru, bru_args)

  eta_expr <- paste(c("Intercept", x_terms, "field"), collapse = " + ")
  pred_formula <- stats::as.formula(paste("~", pred_transform(eta_expr)))

  attr(fit_obj, "inlaspde_coords_cols") <- coords[1:2]
  attr(fit_obj, "inlaspde_pred_formula") <- pred_formula
  attr(fit_obj, "inlaspde_mesh") <- mesh
  attr(fit_obj, "inlaspde_spde") <- spde
  attr(fit_obj, "inlaspde_priors") <- priors
  attr(fit_obj, "inlaspde_family") <- family
  attr(fit_obj, "inlaspde_link") <- link
  fit_obj
}

#' Fonction interne de prediction du champ SPDE INLA pour parsnip
#'
#' @keywords internal
#' @export
inlaspde_pred_impl <- function(object, new_data) {
  fit_obj <- parsnip::extract_fit_engine(object)
  pred_formula <- attr(fit_obj, "inlaspde_pred_formula")
  new_df <- as.data.frame(new_data)

  # predict.bru() fait de la vraie prediction hors echantillon nativement
  # (le champ spatial est reprojete sur le maillage aux nouvelles
  # coordonnees) -- contrairement a ProbitSpatial, aucune reconstruction
  # manuelle du predicteur lineaire n'est necessaire ici.
  preds <- tryCatch(
    stats::predict(fit_obj, new_df, formula = pred_formula),
    error = function(e) e
  )
  if (inherits(preds, "error")) {
    stop(sprintf(
      "inla_spde_reg: predict.bru() a echoue. Cause: %s",
      conditionMessage(preds)
    ), call. = FALSE)
  }
  as.numeric(preds$mean)
}
