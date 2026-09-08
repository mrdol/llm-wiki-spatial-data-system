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

check_spatial_W <- function(W, n = NULL, arg = "W") {
  # W est optionnel. Quand il est fourni, il doit deja correspondre aux lignes
  # d'entrainement du fold courant. Pour la prediction hors-echantillon, les
  # coordonnees restent necessaires afin de reconstruire le voisinage test.
  W <- rlang::eval_tidy(W)
  if (is.null(W)) return(NULL)
  if (inherits(W, "listw")) return(W)
  if (!is.matrix(W) && !inherits(W, "Matrix")) {
    stop(sprintf("%s doit etre une matrice, une Matrix ou un objet listw.", arg), call. = FALSE)
  }
  if (!is.null(n) && !identical(dim(W), c(n, n))) {
    stop(sprintf("%s doit avoir les dimensions %d x %d.", arg, n, n), call. = FALSE)
  }
  W
}

spatial_W_to_matrix <- function(W, style = "W", zero_policy = TRUE, arg = "W") {
  W <- rlang::eval_tidy(W)
  if (is.null(W)) return(NULL)
  if (inherits(W, "listw")) {
    if (!requireNamespace("spdep", quietly = TRUE)) {
      stop("Le package spdep est requis pour convertir un objet listw.", call. = FALSE)
    }
    return(spdep::listw2mat(W))
  }
  if (inherits(W, "nb")) {
    if (!requireNamespace("spdep", quietly = TRUE)) {
      stop("Le package spdep est requis pour convertir un objet nb.", call. = FALSE)
    }
    return(spdep::listw2mat(spdep::nb2listw(W, style = style, zero.policy = zero_policy)))
  }
  if (!is.matrix(W) && !inherits(W, "Matrix")) {
    stop(sprintf("%s doit etre une matrice, une Matrix, un objet listw ou un objet nb.", arg), call. = FALSE)
  }
  as.matrix(W)
}

normalize_spatial_W_for_data <- function(W, data, style = "W", zero_policy = TRUE, arg = "W") {
  W <- spatial_W_to_matrix(W, style = style, zero_policy = zero_policy, arg = arg)
  if (is.null(W)) return(NULL)
  n <- nrow(data)
  if (!identical(dim(W), c(n, n))) {
    stop(sprintf("%s doit avoir les dimensions %d x %d pour les donnees courantes.", arg, n, n), call. = FALSE)
  }
  W
}

subset_spatial_W_rows <- function(W, row_ids, n_expected = NULL,
                                  style = "W", zero_policy = TRUE,
                                  arg = "W") {
  W <- spatial_W_to_matrix(W, style = style, zero_policy = zero_policy, arg = arg)
  if (is.null(W)) return(NULL)
  idx <- suppressWarnings(as.integer(row_ids))
  if (length(idx) == 0L || anyNA(idx)) {
    stop(
      sprintf(
        "%s ne peut pas etre sous-selectionnee: les noms de lignes doivent etre des indices entiers.",
        arg
      ),
      call. = FALSE
    )
  }
  if (any(idx < 1L | idx > nrow(W))) {
    stop(sprintf("%s ne correspond pas aux indices de lignes du fold courant.", arg), call. = FALSE)
  }
  out <- W[idx, idx, drop = FALSE]
  if (!is.null(n_expected) && !identical(dim(out), c(n_expected, n_expected))) {
    stop(sprintf("%s sous-selectionnee doit avoir les dimensions %d x %d.", arg, n_expected, n_expected), call. = FALSE)
  }
  out
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

check_spatial_style <- function(style, arg = "style") {
  if (is.null(style)) style <- "W"
  style <- rlang::eval_tidy(style)
  allowed <- c("W", "B", "C", "U", "S")
  if (!is.character(style) || length(style) != 1L || !style %in% allowed) {
    stop(sprintf("%s doit etre l'un de: %s.", arg, paste(allowed, collapse = ", ")), call. = FALSE)
  }
  style
}

check_zero_policy <- function(zero_policy, arg = "zero_policy") {
  if (is.null(zero_policy)) zero_policy <- TRUE
  zero_policy <- rlang::eval_tidy(zero_policy)
  if (!is.logical(zero_policy) || length(zero_policy) != 1L || is.na(zero_policy)) {
    stop(sprintf("%s doit etre TRUE ou FALSE.", arg), call. = FALSE)
  }
  zero_policy
}

#' Definir les arguments spatiaux kNN communs
#'
#' Regroupe les arguments geographiques utilises pour construire ou transmettre
#' une structure de voisinage spatial. Cette fonction documente le contrat
#' commun du package: les estimateurs statistiques utilisent les covariables,
#' tandis que ces arguments servent a construire `W`.
#'
#' @param coords Colonnes de coordonnees presentes dans les donnees du workflow.
#' @param W Matrice de poids spatiaux ou objet `listw` deja construit.
#' @param k_neighbors Nombre de voisins kNN utilise si `W` n'est pas fourni.
#' @param style Style de standardisation `spdep::nb2listw()`.
#' @param zero_policy Politique `spdep` pour les observations sans voisin.
#'
#' @return Une liste de classe `spatial_knn_args`.
#' @export
spatial_knn_args <- function(coords = NULL, W = NULL, k_neighbors = 8,
                             style = "W", zero_policy = TRUE) {
  # Objet leger: il sert surtout a documenter et transporter les choix
  # geographiques sans les melanger aux arguments econometriques du modele.
  structure(
    list(
      coords = coords,
      W = W,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy
    ),
    class = "spatial_knn_args"
  )
}

resolve_spatial_knn_args <- function(coords = NULL, W = NULL, k_neighbors = 8,
                                     style = "W", zero_policy = TRUE,
                                     data = NULL) {
  # Normalise les arguments spatiaux au moment du fit. Les specs parsnip
  # transportent souvent des quosures; cette fonction les evalue une seule fois.
  n <- if (is.null(data)) NULL else nrow(data)
  list(
    coords = check_spatial_coords(coords, data = data),
    W = check_spatial_W(W, n = n),
    k_neighbors = check_k_neighbors(k_neighbors, n = n),
    style = check_spatial_style(style),
    zero_policy = check_zero_policy(zero_policy)
  )
}
