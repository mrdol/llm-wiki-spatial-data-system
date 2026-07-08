source("R/utils/estimator_common.R")

# Outils partages de construction des voisinages spatiaux.
# Objectif: une seule definition de W pour spboost, mgwrsar, spatialreg et
# les diagnostics, afin d'eviter que chaque wrapper construise une matrice
# legerement differente.

require_package("nabor", "construction kNN des poids spatiaux")
require_package("Matrix", "matrices creuses pour les poids spatiaux")
require_package("mgwrsar", "standardisation ligne des matrices W")

build_knn_W <- function(coords, k = 8, sparse = TRUE) {
  # Construit une matrice k-plus-proches-voisins standardisee par ligne.
  # `coords` doit deja etre dans un CRS metrique. k reste fixe dans le
  # benchmark courant: on tune les modeles, pas la structure W.
  coords <- as.matrix(coords)
  n <- nrow(coords)
  if (n < 2) stop("build_knn_W(): il faut au moins deux observations.", call. = FALSE)
  k_use <- min(k, n - 1)
  knn <- nabor::knn(coords, coords, k = k_use + 1)
  idx <- knn$nn.idx[, -1, drop = FALSE]
  W <- matrix(0, n, n)
  for (i in seq_len(n)) W[i, idx[i, ]] <- 1
  W <- mgwrsar::normW(W)
  if (isTRUE(sparse)) Matrix::Matrix(W, sparse = TRUE) else W
}

build_knn_listw <- function(coords, k = 8) {
  # Version spdep/spatialreg de la meme structure W. spatialreg attend un
  # objet listw construit depuis un voisinage nb; nb2listw evite les erreurs
  # observees avec une conversion directe depuis matrice dense.
  require_package("spdep", "objets listw pour spatialreg")
  coords <- as.matrix(coords)
  n <- nrow(coords)
  if (n < 2) stop("build_knn_listw(): il faut au moins deux observations.", call. = FALSE)
  k_use <- min(k, n - 1)
  knn <- spdep::knearneigh(coords, k = k_use)
  nb <- spdep::knn2nb(knn, sym = FALSE)
  spdep::nb2listw(nb, style = "W", zero.policy = TRUE)
}

moran_i_knn <- function(values, coords, k = 8) {
  # Diagnostic simple d'autocorrelation spatiale. On l'utilise pour documenter
  # les residus, pas pour decider automatiquement quel estimateur lancer.
  require_package("spdep", "diagnostic Moran I")
  listw <- build_knn_listw(coords, k = k)
  out <- tryCatch(
    spdep::moran.test(values, listw = listw, zero.policy = TRUE),
    error = function(e) e
  )
  if (inherits(out, "error")) {
    return(data.frame(moran_i = NA_real_, p_value = NA_real_, error = conditionMessage(out)))
  }
  data.frame(
    moran_i = unname(out$estimate[["Moran I statistic"]]),
    p_value = out$p.value,
    error = NA_character_
  )
}
