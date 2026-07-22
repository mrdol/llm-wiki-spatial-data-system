# Parametres dials propres au package.
#
# Ces fonctions donnent a tune::tune_grid() des objets de grille avec des noms
# explicites. Les bornes sont volontairement larges: chaque benchmark doit les
# restreindre selon la taille du jeu de donnees et le papier de reference.

#' Parametre dials pour mstop
#'
#' Nombre d'iterations de boosting utilise par `spboost`.
#'
#' @param range Bornes entieres du nombre d'iterations.
#' @param trans Transformation optionnelle.
#'
#' @return Un parametre `dials`.
#' @export
mstop <- function(range = c(50L, 1500L), trans = NULL) {
  dials::new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(mstop = "Nombre d'iterations de boosting")
  )
}

#' Parametre dials pour la bande passante spatiale
#'
#' Bande passante utilisee par les estimateurs locaux de type GWR/MGWR/MGWRSAR.
#'
#' @param range Bornes entieres de la bande passante.
#' @param trans Transformation optionnelle.
#'
#' @return Un parametre `dials`.
#' @export
bandwidth <- function(range = c(10L, 300L), trans = NULL) {
  dials::new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(bandwidth = "Bande passante spatiale")
  )
}

#' Parametre dials pour le noyau spatial
#'
#' Famille de noyau utilisee par les estimateurs locaux. Les valeurs doivent
#' rester compatibles avec le backend appele.
#'
#' @param values Valeurs candidates du noyau.
#'
#' @return Un parametre qualitatif `dials`.
#' @export
spatial_kernel <- function(values = c("gauss", "bisq", "rectangle", "exponential")) {
  dials::new_qual_param(
    type = "character",
    values = values,
    label = c(kernel = "Noyau spatial")
  )
}

#' Parametre dials pour le nombre de voisins kNN
#'
#' Nombre de voisins utilise pour construire la matrice de poids spatiaux W.
#'
#' @param range Bornes entieres du nombre de voisins.
#' @param trans Transformation optionnelle.
#'
#' @return Un parametre `dials`.
#' @export
k_neighbors <- function(range = c(3L, 30L), trans = NULL) {
  dials::new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(k_neighbors = "Nombre de voisins kNN")
  )
}

#' dials parameter for the number of Moran eigenvectors
#'
#' Number of Moran eigenvectors used by `spmoran::meigen_f()`. Small values
#' keep tuning fast; larger values allow richer spatial filtering bases.
#'
#' @param range Integer bounds for the number of eigenvectors.
#' @param trans Optional transformation.
#'
#' @return A `dials` parameter.
#' @export
spmoran_enum <- function(range = c(5L, 200L), trans = NULL) {
  dials::new_quant_param(
    type = "integer",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(enum = "Number of Moran eigenvectors")
  )
}

#' dials parameter for the ESF VIF threshold
#'
#' Variance inflation threshold passed to `spmoran::esf()`.
#'
#' @param range Numeric bounds for the VIF threshold.
#' @param trans Optional transformation.
#'
#' @return A `dials` parameter.
#' @export
spmoran_vif <- function(range = c(5, 20), trans = NULL) {
  dials::new_quant_param(
    type = "double",
    range = range,
    inclusive = c(TRUE, TRUE),
    trans = trans,
    label = c(vif = "ESF VIF threshold")
  )
}
