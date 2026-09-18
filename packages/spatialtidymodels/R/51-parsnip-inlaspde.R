
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
# Phase 3 (2026-09-18): deux variantes ajoutees, suivant le meme patron que
# mgwrsar/spboost (UN modele parsnip enregistre, des arguments natifs qui
# changent le comportement au fit -- pas de set_new_model() separe) :
#   - `time` (variante `inla_spde_st`) : champ spatio-temporel separable
#     espace x AR1, via `group=`/`control.group=list(model="ar1")` sur le
#     terme `field()` (arguments confirmes dans `args(INLA::f)` avant
#     d'ecrire ce code, pas supposes). Motive par paper_crane, paper_
#     mistletoe_bird_abundance et paper_goa_trawl_demersal, qui utilisent
#     tous les trois un champ M(s,t) structure par le temps.
#   - Effet(s) aleatoire(s) de groupe (variante `inla_spde_group`) :
#     detection automatique de `(1 | groupe)` dans la formule via
#     `extract_group_re_terms()` (deja utilisee par gam_spatial pour
#     `s(groupe, bs="re")`, `13-benchmark-spatial.R`), traduit ici en
#     composant iid `groupe(groupe, model="iid")`. Motive par paper_
#     banff_stream_temperature (HUC10) et paper_mistletoe_bird_abundance
#     (observateur/region). Fonctionne aussi silencieusement avec
#     l'estimateur `inla_spde` de base si la formule contient un tel terme
#     -- `inla_spde_group` n'est qu'un nom d'estimateur distinct cote
#     harnais, avec un garde-fou explicite (erreur si aucun terme de
#     groupe n'est present) pour qu'une fiche ne puisse jamais declarer
#     cette variante eligible sans effet de groupe reel.
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
#' @param time Nom de colonne (chaine) a utiliser comme index de groupe
#'   temporel pour un champ spatio-temporel separable espace x AR1 (variante
#'   `inla_spde_st`). `NULL` (defaut): champ purement spatial, cross-section,
#'   comportement inchange. Voir `inlaspde_fit_impl()`.
#'
#' @return Une specification de modele `parsnip`.
#' @export
inla_spde_reg <- function(mode = "regression", coords = NULL,
                          family = "gaussian", link = NULL,
                          prior_range = NULL, prior_sigma = NULL,
                          mesh_max_edge = NULL, mesh_cutoff = NULL,
                          time = NULL) {
  args <- list(
    coords = rlang::enquo(coords),
    family = rlang::enquo(family),
    link = rlang::enquo(link),
    prior_range = rlang::enquo(prior_range),
    prior_sigma = rlang::enquo(prior_sigma),
    mesh_max_edge = rlang::enquo(mesh_max_edge),
    mesh_cutoff = rlang::enquo(mesh_cutoff),
    time = rlang::enquo(time)
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
                                 time = NULL,
                                 fresh = FALSE, ...) {
  args <- list(
    coords = rlang::enquo(coords),
    family = rlang::enquo(family),
    link = rlang::enquo(link),
    prior_range = rlang::enquo(prior_range),
    prior_sigma = rlang::enquo(prior_sigma),
    mesh_max_edge = rlang::enquo(mesh_max_edge),
    mesh_cutoff = rlang::enquo(mesh_cutoff),
    time = rlang::enquo(time)
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
                              mesh_cutoff = NULL, time = NULL) {
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

  # Effet(s) aleatoire(s) de groupe `(1 | groupe)` : meme detection que
  # gam_spatial (`extract_group_re_terms()`, 13-benchmark-spatial.R), pour
  # que la meme syntaxe de formule produise un effet equivalent quel que
  # soit l'estimateur choisi. Retires des termes fixes ici, traduits plus
  # bas en composant(s) iid inlabru.
  group_re <- extract_group_re_terms(model_formula, data = data)
  x_terms <- group_re$fixed_terms
  group_cols <- group_re$re_groups
  for (g in group_cols) {
    if (!is.factor(data[[g]])) data[[g]] <- factor(data[[g]])
  }

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

  # Champ spatio-temporel separable (espace x AR1) via `group=`/
  # `control.group=list(model="ar1")` sur le terme `field()` -- arguments
  # confirmes dans `args(INLA::f)` (`group`, `control.group`), transmis tels
  # quels par inlabru a travers le "..." du composant. `time` doit etre un
  # index de groupe entier 1..ngroup pour INLA -- coercion explicite ici en
  # facteur puis entier, pas suppose deja dans ce format cote appelant.
  field_extra <- ""
  if (!is.null(time)) {
    if (!is.factor(data[[time]])) data[[time]] <- factor(data[[time]])
    time_levels <- levels(data[[time]])
    data[[time]] <- as.integer(data[[time]])
    field_extra <- sprintf(
      ', group = %s, control.group = list(model = "ar1"), ngroup = %d',
      time, length(time_levels)
    )
  }

  # Syntaxe de composants inlabru: reponse ~ Intercept(1) + covariables +
  # field(cbind(cx, cy), model = spde) -- confirme dans
  # inlabru_2.14.1/inlabru/doc/prediction_scores.R (`bru(y ~ Intercept(1) + x,
  # family = "poisson", data = ...)`) et dans component.Rmd pour la syntaxe
  # de champ spatial (`my_spde_effect(cbind(x, y), model = spde_model)`) et
  # la syntaxe `main`/`group`/`replicate` d'un composant.
  group_terms <- if (length(group_cols) > 0) sprintf('%s(%s, model = "iid")', group_cols, group_cols) else character(0)
  comp_terms <- c(
    "Intercept(1)",
    x_terms,
    sprintf("field(cbind(%s, %s), model = spde%s)", coords[1], coords[2], field_extra),
    group_terms
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

  eta_expr <- paste(c("Intercept", x_terms, "field", group_cols), collapse = " + ")
  pred_formula <- stats::as.formula(paste("~", pred_transform(eta_expr)))

  attr(fit_obj, "inlaspde_coords_cols") <- coords[1:2]
  attr(fit_obj, "inlaspde_pred_formula") <- pred_formula
  attr(fit_obj, "inlaspde_mesh") <- mesh
  attr(fit_obj, "inlaspde_spde") <- spde
  attr(fit_obj, "inlaspde_priors") <- priors
  attr(fit_obj, "inlaspde_family") <- family
  attr(fit_obj, "inlaspde_link") <- link
  attr(fit_obj, "inlaspde_group_cols") <- group_cols
  attr(fit_obj, "inlaspde_group_levels") <- stats::setNames(
    lapply(group_cols, function(g) levels(data[[g]])), group_cols
  )
  attr(fit_obj, "inlaspde_time_col") <- time
  attr(fit_obj, "inlaspde_time_levels") <- if (!is.null(time)) time_levels else NULL
  fit_obj
}

#' Fonction interne de prediction du champ SPDE INLA pour parsnip
#'
#' Accepte soit un `model_fit` parsnip (chemin `inla_spde`/`inla_spde_st`,
#' via `workflows`), soit l'objet de fit brut lui-meme (chemin
#' `inla_spde_group`, qui contourne `workflows::fit()` -- voir
#' `predict.inla_spde_group_fit()` ci-dessous et la note dans
#' `fit_one_benchmark_estimator()` sur l'incompatibilite de `(1 | groupe)`
#' avec `hardhat::mold()`/`stats::model.frame()`).
#'
#' @keywords internal
#' @export
inlaspde_pred_impl <- function(object, new_data) {
  fit_obj <- if (inherits(object, "model_fit")) parsnip::extract_fit_engine(object) else object
  # Un fit inla_spde_group porte la classe supplementaire "inla_spde_group_fit"
  # (voir predict.inla_spde_group_fit() plus bas). La retirer avant l'appel a
  # stats::predict() ci-dessous evite une recursion infinie ET un mauvais
  # dispatch: `predict` s'est avere promu en generique S4 par un package charge
  # (INLA, confirme empiriquement -- isGeneric("predict") est TRUE alors que
  # stats::predict n'est pas cense l'etre), ce qui a fait ignorer nos methodes
  # S3 informelles lors d'un test direct -- stats::predict() ci-dessous doit
  # voir un objet de classe "bru" nu pour atteindre le predict.bru() natif.
  fit_obj_for_predict <- fit_obj
  class(fit_obj_for_predict) <- setdiff(class(fit_obj_for_predict), "inla_spde_group_fit")
  pred_formula <- attr(fit_obj, "inlaspde_pred_formula")
  new_df <- as.data.frame(new_data)

  # Effet(s) de groupe : la nouvelle donnee doit etre un facteur avec les
  # memes niveaux qu'a l'entrainement. Un niveau non vu a l'entrainement
  # N'EST PAS traite comme une erreur : verifie empiriquement, predict.bru()
  # gere nativement un groupe iid absent en marginalisant sur son prior
  # bayesien (comportement correct et documente pour un effet aleatoire
  # iid -- contrairement a mgcv::predict.gam() sur un s(x, bs="re"), qui n'a
  # pas cette notion de prior). Pas de NA force ici.
  for (g in attr(fit_obj, "inlaspde_group_cols") %||% character(0)) {
    levels_train <- attr(fit_obj, "inlaspde_group_levels")[[g]]
    new_df[[g]] <- factor(as.character(new_df[[g]]), levels = levels_train)
  }

  # Champ spatio-temporel : meme index de groupe (1..ngroup) qu'a
  # l'entrainement. Une periode non vue a l'entrainement n'a pas de niveau
  # AR1 estime -- erreur explicite plutot qu'une extrapolation temporelle
  # non verifiee.
  time_col <- attr(fit_obj, "inlaspde_time_col")
  if (!is.null(time_col)) {
    time_levels <- attr(fit_obj, "inlaspde_time_levels")
    time_idx <- match(as.character(new_df[[time_col]]), time_levels)
    if (anyNA(time_idx)) {
      stop(sprintf(
        "inla_spde_reg: periode(s) de '%s' absente(s) de l'entrainement dans new_data -- pas d'extrapolation temporelle hors du groupe AR1 ajuste.",
        time_col
      ), call. = FALSE)
    }
    new_df[[time_col]] <- time_idx
  }

  # predict.bru() fait de la vraie prediction hors echantillon nativement
  # (le champ spatial est reprojete sur le maillage aux nouvelles
  # coordonnees) -- contrairement a ProbitSpatial, aucune reconstruction
  # manuelle du predicteur lineaire n'est necessaire ici.
  preds <- tryCatch(
    stats::predict(fit_obj_for_predict, new_df, formula = pred_formula),
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

#' Methode predict() pour un fit INLA SPDE ajuste hors `workflows`
#'
#' `inla_spde_group` (formule contenant `(1 | groupe)`) contourne
#' `make_benchmark_workflow()`/`workflows::fit()`: `stats::model.frame()`,
#' appele en interne par `hardhat::mold()`, ne comprend pas la syntaxe
#' `(1 | groupe)` (confirme empiriquement -- erreur "'|' not meaningful for
#' factors") et n'a pas de point d'extension pour la contourner, contrairement
#' a `drop_formula_terms()`/`add_coords_to_formula()` qui ne font que
#' manipuler des term.labels. Meme strategie de contournement que
#' `gam_spatial` (appel direct au moteur, pas de `workflows::workflow()`).
#' Cette methode S3 permet neanmoins au reste du harnais de rester generique:
#' `fit_one_benchmark_estimator()` retourne un objet de classe
#' `inla_spde_group_fit`, et le code appelant (`stats::predict(fit, new_data,
#' type=...)`, voir 13-benchmark-spatial.R) n'a pas besoin de savoir que ce
#' fit particulier ne vient pas de `workflows`. `type` est accepte et ignore:
#' `inlaspde_pred_impl()` renvoie toujours l'echelle reponse (transformation
#' inverse-lien deja appliquee dans `inlaspde_pred_formula`), contrairement a
#' `predict.glm()`/`predict.gam()` qui ont besoin de `type="response"`
#' explicite.
#'
#' @keywords internal
#' @export
predict.inla_spde_group_fit <- function(object, new_data, type = NULL, ...) {
  inlaspde_pred_impl(object, new_data)
}
