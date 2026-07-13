# Validation des arguments geographiques.
#
# Les estimateurs melangent deux familles d'arguments:
# - arguments de modele: mstop, bandwidth, kernel, model_type, etc.;
# - arguments geographiques: coords et k_neighbors, qui servent a construire W.
# Ces helpers rendent cette separation explicite et evitent de repeter les
# memes controles dans chaque moteur.

check_spatial_coords <- function(coords, data = NULL, arg = "coords") {
  coords <- rlang::eval_tidy(coords)
  if (is.null(coords)) {
    stop(sprintf("%s doit contenir les noms des colonnes de coordonnees.", arg), call. = FALSE)
  }
  if (!is.character(coords) || length(coords) < 2) {
    stop(sprintf("%s doit etre un vecteur de caracteres d'au moins deux colonnes.", arg), call. = FALSE)
  }
  if (!is.null(data)) check_columns(data, coords, role = arg)
  coords
}

check_k_neighbors <- function(k_neighbors, n = NULL, arg = "k_neighbors") {
  if (is.null(k_neighbors)) k_neighbors <- 8L
  k_neighbors <- as.integer(k_neighbors)
  if (length(k_neighbors) != 1L || is.na(k_neighbors) || k_neighbors < 1L) {
    stop(sprintf("%s doit etre un entier positif.", arg), call. = FALSE)
  }
  if (!is.null(n) && n > 1L) k_neighbors <- min(k_neighbors, n - 1L)
  k_neighbors
}
