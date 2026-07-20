# Raccourcis utilisateur pour ajuster SAR, SEM et SDM.
#
# Ces fonctions sont volontairement plus proches de glm(formula, data) que de
# l'API tidymodels complete. Elles construisent en interne la spec parsnip, le
# workflow, puis ajustent le modele.

add_coords_to_formula <- function(formula, coords, data) {
  # Les coordonnees doivent etre presentes dans la formule workflow pour etre
  # transmises au moteur. Elles seront ensuite retirees de la formule
  # econometrique native par spatialreg_fit_impl().
  coords <- check_spatial_coords(coords, data = data)
  response <- deparse(formula[[2]])
  rhs_terms <- attr(stats::terms(formula, data = data), "term.labels")
  rhs_terms <- unique(c(rhs_terms, setdiff(coords, rhs_terms)))
  out <- stats::reformulate(rhs_terms, response = response)
  environment(out) <- environment(formula)
  out
}

fit_spatialreg_shortcut <- function(formula, data, coords, W = NULL,
                                    k_neighbors = 8, style = "W",
                                    zero_policy = TRUE, model = "SAR") {
  # Point commun aux trois raccourcis. Le choix du modele reste separe du
  # choix geographique: model = SAR/SEM/SDM, coords/W/k/style pour le voisinage.
  require_package("workflows", "raccourcis fit_sar()/fit_sem()/fit_sdm()")
  require_package("parsnip", "specifications tidymodels")
  data <- as.data.frame(data)
  formula <- add_coords_to_formula(formula, coords = coords, data = data)

  spec <- switch(toupper(model),
    SAR = sar_reg(
      coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    SEM = sem_reg(
      coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    SDM = sdm_reg(
      coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    stop(sprintf("Modele spatialreg inconnu: %s", model), call. = FALSE)
  ) |>
    parsnip::set_engine("spatialreg") |>
    parsnip::set_mode("regression")

  fit <- workflows::workflow() |>
    workflows::add_formula(formula) |>
    workflows::add_model(spec) |>
    workflows::fit(data = data)
  attr(fit, "spatialtidymodels_formula") <- formula
  attr(fit, "spatialtidymodels_coords") <- coords
  attr(fit, "spatialtidymodels_k_neighbors") <- k_neighbors
  attr(fit, "spatialtidymodels_style") <- style
  attr(fit, "spatialtidymodels_zero_policy") <- zero_policy
  fit
}

#' Ajuster un modele SAR lag avec une API courte
#'
#' Raccourci utilisateur proche de `glm(formula, data)`. La fonction construit
#' automatiquement `sar_reg()`, `workflow()` et `fit()`.
#'
#' @param formula Formule statistique, par exemple `CRIME ~ HOVAL + INC`.
#' @param data Donnees d'entrainement.
#' @param coords Colonnes de coordonnees utilisees pour construire le voisinage.
#' @param W Matrice de poids spatiaux ou objet `listw` fourni au fit.
#' @param k_neighbors Nombre de voisins si `W` n'est pas fourni.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Un workflow ajuste.
#' @export
fit_sar <- function(formula, data, coords, W = NULL, k_neighbors = 8,
                    style = "W", zero_policy = TRUE) {
  fit_spatialreg_shortcut(
    formula = formula, data = data, coords = coords, W = W,
    k_neighbors = k_neighbors, style = style, zero_policy = zero_policy,
    model = "SAR"
  )
}

#' Ajuster un modele SEM error avec une API courte
#'
#' Raccourci utilisateur proche de `glm(formula, data)`. La fonction construit
#' automatiquement `sem_reg()`, `workflow()` et `fit()`.
#'
#' @inheritParams fit_sar
#'
#' @return Un workflow ajuste.
#' @export
fit_sem <- function(formula, data, coords, W = NULL, k_neighbors = 8,
                    style = "W", zero_policy = TRUE) {
  fit_spatialreg_shortcut(
    formula = formula, data = data, coords = coords, W = W,
    k_neighbors = k_neighbors, style = style, zero_policy = zero_policy,
    model = "SEM"
  )
}

#' Ajuster un modele SDM mixed avec une API courte
#'
#' Raccourci utilisateur proche de `glm(formula, data)`. La fonction construit
#' automatiquement `sdm_reg()`, `workflow()` et `fit()`.
#'
#' @inheritParams fit_sar
#'
#' @return Un workflow ajuste.
#' @export
fit_sdm <- function(formula, data, coords, W = NULL, k_neighbors = 8,
                    style = "W", zero_policy = TRUE) {
  fit_spatialreg_shortcut(
    formula = formula, data = data, coords = coords, W = W,
    k_neighbors = k_neighbors, style = style, zero_policy = zero_policy,
    model = "SDM"
  )
}
