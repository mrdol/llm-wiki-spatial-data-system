source("R/utils/estimator_common.R")

# Deux schemas de validation croisee spatiale faits maison, gardes externes
# aux wrappers d'estimateurs, selon la politique d'implementation R:
# le split de validation croisee doit rester deliberement externe au wrapper.
#
# Les deux fonctions retournent un rsample::manual_rset(), ce qui permet de les
# brancher sur la mecanique tidymodels standard (workflows::workflow(),
# tune::fit_resamples(), yardstick metrics), tout en gardant le controle complet
# sur les points presents dans chaque fold au lieu de deleguer la CV interne a
# un package.

#' CV spatiale near-prediction, implementation de reference.
#'
#' Portee a l'identique (2026-07-02) depuis le `near_prediction_cv.Rmd` de
#' l'encadrant (`build_near_prediction_folds()`, lui-meme issu de
#' `empiric_estimation_finale.R::build_phase2_spatial_batches()`). Elle est
#' gardee telle quelle volontairement, y compris les appels internes
#' `mgwrsar:::`; voir la decision "Fonctions internes" de cette session: la
#' fidelite a la procedure de reference a ete priorisee sur l'evitement des
#' dependances non exportees. Si une future version de `mgwrsar` renomme ou
#' retire `quadtree()`, `cell()` ou `insidecell()`, cette fonction echouera
#' clairement au moment de l'appel, car elles sont recuperees via
#' `getFromNamespace()` plus bas.
#'
#' Principe (approximation par lots d'une LOOCV spatiale): le domaine est
#' decoupe par quadtree en petites cellules; chaque repetition tire UNE
#' observation par cellule, sans remise entre repetitions, pour former un jeu
#' TEST spatialement disperse. TRAIN contient tout le reste du jeu complet,
#' et pas seulement la meme cellule. C'est la difference cle avec une version
#' anterieure incorrecte testee pendant cette session, ou le train etait limite
#' a la cellule du point test.
#'
#' @param coords Matrice numerique a 2 colonnes, dans le meme ordre de lignes
#'   que `data`.
#' @param n_reps Nombre de repetitions/folds; c'est aussi le nombre maximal de
#'   points tires par cellule, donc chaque cellule doit contenir >= n_reps
#'   observations.
#' @param test_size Nombre cible de cellules quadtree. La taille test effective
#'   par fold vaut `n_cells`, pas forcement exactement cette cible.
#' @param seed Graine de reproductibilite.
build_near_prediction_folds <- function(coords, n_reps = 50L, test_size = 100L, seed = 123L) {
  # Construit les folds near-prediction au format "liste brute":
  # chaque repetition choisit un point test par cellule quadtree, et tous les
  # autres points servent a l'entrainement. La conversion en objet rsample est
  # faite plus bas dans near_prediction_rset().
  coords <- as.matrix(coords)
  n <- nrow(coords)
  n_reps <- as.integer(n_reps)
  test_size <- as.integer(test_size)

  if (!is.numeric(coords) || ncol(coords) != 2L || any(!is.finite(coords))) {
    stop("`coords` doit etre une matrice numerique finie a deux colonnes.")
  }
  if (n_reps < 1L || test_size < 1L) {
    stop("`n_reps` et `test_size` doivent etre strictement positifs.")
  }
  if (n < n_reps * test_size) {
    stop(sprintf(
      paste0(
        "Le jeu contient %d observations : il est insuffisant pour ",
        "%d repetitions de taille cible %d."
      ),
      n, n_reps, test_size
    ))
  }

  require_package("mgwrsar", "quadtree spatial partition (internal functions)")
  ns_mgwrsar <- asNamespace("mgwrsar")
  quadtree_fn <- get("quadtree", envir = ns_mgwrsar)
  cell_fn <- get("cell", envir = ns_mgwrsar)
  insidecell_fn <- get("insidecell", envir = ns_mgwrsar)

  build_quad_partition <- function(k_leaf) {
    # Essaie une granularite de quadtree donnee. On garde ensuite la partition
    # dont le nombre de cellules est le plus proche de test_size, sous
    # contrainte que chaque cellule ait assez de points pour n_reps.
    qt <- quadtree_fn(coords, k = k_leaf)
    xylim <- cbind(
      x = c(min(coords[, 1L]), max(coords[, 1L])),
      y = c(min(coords[, 2L]), max(coords[, 2L]))
    )
    polys <- cell_fn(qt, xylim)
    polys$id <- as.numeric(factor(polys$id))

    inside <- insidecell_fn(polys, coords)
    cell_id <- as.integer(inside$id)

    ids <- sort(unique(cell_id))
    id_map <- seq_along(ids)
    names(id_map) <- ids
    cell_id <- unname(id_map[as.character(cell_id)])
    polys$id <- unname(id_map[as.character(polys$id)])

    cell_members <- split(seq_len(n), cell_id)
    cell_members <- cell_members[order(as.integer(names(cell_members)))]
    cell_sizes <- vapply(cell_members, length, integer(1L))

    list(
      k_leaf = k_leaf, cell_id = cell_id, cell_members = cell_members,
      cell_sizes = cell_sizes, n_cells = length(cell_members),
      min_cell_size = min(cell_sizes), polys = polys
    )
  }

  k_target <- max(n_reps, ceiling(n / (2 * test_size)))
  k_min <- max(n_reps, floor(k_target / 2))
  k_max <- max(k_min, ceiling(k_target * 2))
  k_candidates <- sort(unique(as.integer(round(seq(k_min, k_max, length.out = 15L)))))

  partition_candidates <- lapply(k_candidates, function(k_candidate) {
    tryCatch(build_quad_partition(k_candidate), error = function(e) NULL)
  })
  partition_candidates <- Filter(Negate(is.null), partition_candidates)

  if (length(partition_candidates) == 0L) {
    stop("Aucune partition quadtree valide n'a pu etre construite.")
  }

  valid <- vapply(partition_candidates, function(partition) partition$min_cell_size >= n_reps, logical(1L))

  if (!any(valid)) {
    best <- partition_candidates[[which.max(vapply(partition_candidates, function(p) p$min_cell_size, integer(1L)))]]
    stop(sprintf(
      paste0(
        "Impossible de construire %d repetitions sans remise : ",
        "la meilleure partition a une cellule de seulement %d observations."
      ),
      n_reps, best$min_cell_size
    ))
  }

  valid_partitions <- partition_candidates[valid]
  best_index <- which.min(vapply(valid_partitions, function(p) abs(p$n_cells - test_size), numeric(1L)))
  partition <- valid_partitions[[best_index]]

  selected_by_cell <- lapply(seq_len(partition$n_cells), function(cell) {
    set.seed(seed + 1000L + cell)
    sample(partition$cell_members[[cell]], size = n_reps, replace = FALSE)
  })

  test_matrix <- matrix(NA_integer_, nrow = n_reps, ncol = partition$n_cells)
  for (cell in seq_len(partition$n_cells)) test_matrix[, cell] <- selected_by_cell[[cell]]

  for (rep in seq_len(n_reps)) {
    set.seed(seed + 5000L + rep)
    test_matrix[rep, ] <- sample(test_matrix[rep, ], replace = FALSE)
  }

  test_indices <- lapply(seq_len(n_reps), function(rep) test_matrix[rep, ])
  names(test_indices) <- paste0("rep_", seq_len(n_reps))

  folds <- lapply(test_indices, function(test) list(train = setdiff(seq_len(n), test), test = test))

  list(
    folds = folds, test_indices = test_indices, cell_id = partition$cell_id,
    cell_sizes = partition$cell_sizes, polygons = partition$polys,
    k_leaf = partition$k_leaf, n_cells = partition$n_cells,
    requested_test_size = test_size
  )
}

#' Verification visuelle d'un fold near-prediction.
#'
#' Portee a l'identique (2026-07-02) depuis le `near_prediction_cv.Rmd` de
#' l'encadrant (`plot_near_prediction_fold()`). Elle opere sur la liste brute
#' retournee par `build_near_prediction_folds()`, et non sur le wrapper
#' `manual_rset()` plus bas, car elle a besoin des polygones de cellules
#' quadtree et de l'affectation cellule-par-point que le rset ne transporte
#' pas. Les frontieres de cellules sont tracees en bleu, les points train en
#' gris, et les points test du fold en rouge; l'image attendue contient un
#' point rouge par cellule.
#'
#' @param near_cv Liste retournee par `build_near_prediction_folds()`.
#' @param coords Meme matrice/data.frame de coordonnees que celle utilisee pour
#'   construire `near_cv`.
#' @param fold Indice entier de la repetition a afficher.
plot_near_prediction_fold <- function(near_cv, coords, fold = 1L) {
  coords <- as.matrix(coords)
  fold <- as.integer(fold)

  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Le package `ggplot2` est requis pour produire ce graphique.", call. = FALSE)
  }
  if (ncol(coords) != 2L || nrow(coords) != length(near_cv$cell_id)) {
    stop("`coords` doit correspondre aux coordonnees utilisees pour la CV.", call. = FALSE)
  }
  if (length(fold) != 1L || is.na(fold) || fold < 1L || fold > length(near_cv$folds)) {
    stop("`fold` doit identifier une repetition existante.", call. = FALSE)
  }

  split <- near_cv$folds[[fold]]
  plot_data <- data.frame(x = coords[, 1L], y = coords[, 2L], set = "Train", cell_id = near_cv$cell_id)
  plot_data$set[split$test] <- "Test"
  plot_data$set <- factor(plot_data$set, levels = c("Train", "Test"))

  ggplot2::ggplot() +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Train", , drop = FALSE],
      ggplot2::aes(x = x, y = y), color = "grey65", size = 0.45, alpha = 0.55
    ) +
    ggplot2::geom_path(
      data = near_cv$polygons,
      ggplot2::aes(x = x, y = y, group = id), color = "#006D77", linewidth = 0.45, alpha = 0.9
    ) +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Test", , drop = FALSE],
      ggplot2::aes(x = x, y = y, color = set), size = 2.2, alpha = 0.95
    ) +
    ggplot2::scale_color_manual(values = c(Test = "#D73027"), name = NULL) +
    ggplot2::coord_equal() +
    ggplot2::labs(
      title = sprintf("Near-prediction - fold %d", fold),
      subtitle = sprintf(
        "%d cellules quadtree - %d points test - %d points train",
        near_cv$n_cells, length(split$test), length(split$train)
      ),
      x = "Coordonnee x projetee", y = "Coordonnee y projetee",
      caption = "Rouge : test (un point par cellule) - Gris : train"
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "top",
      plot.title.position = "plot"
    )
}

#' CV spatiale near-prediction sous forme de `rsample::manual_rset()`.
#'
#' Adaptateur mince autour de `build_near_prediction_folds()`, gardee telle
#' quelle plus haut, pour l'integrer a la meme mecanique tidymodels que
#' `spatial_block_rset()`.
#'
#' @param data data.frame ou objet sf.
#' @param coords Vecteur de caracteres de longueur 2 avec les noms des colonnes
#'   de coordonnees, deja dans un CRS projete/metrique.
#' @param n_reps,test_size,seed Arguments transmis a
#'   `build_near_prediction_folds()`.
near_prediction_rset <- function(data, coords, n_reps = 50L, test_size = 100L, seed = 123L) {
  # Adaptateur tidymodels: transforme la CV near-prediction maison en
  # rsample::manual_rset(), donc utilisable par workflow(), fit_resamples()
  # et le tuning externe.
  stopifnot(is.data.frame(data))
  stopifnot(is.character(coords), length(coords) == 2, all(coords %in% names(data)))

  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  # mgwrsar:::insidecell() lit litteralement xy$x / xy$y en minuscules apres
  # data.frame(xy), confirme le 2026-07-02 en lisant son source. D'autres noms
  # de colonnes, comme les "X"/"Y" majuscules de sf::st_coordinates(), peuvent
  # produire des comparaisons NULL et placer tous les points dans une fausse
  # cellule "0". On renomme donc defensivement avant l'appel.
  colnames(coords_mat) <- c("x", "y")
  near_cv <- build_near_prediction_folds(coords_mat, n_reps = n_reps, test_size = test_size, seed = seed)

  splits <- lapply(near_cv$folds, function(fold) {
    rsample::make_splits(x = list(analysis = fold$train, assessment = fold$test), data = data)
  })
  ids <- names(near_cv$folds)
  rset <- rsample::manual_rset(splits, ids)
  attr(rset, "near_cv_meta") <- near_cv[c("n_cells", "cell_sizes", "k_leaf")]
  rset
}

#' CV spatiale en blocs non hexagonaux.
#'
#' Wrapper mince autour de `blockCV::cv_spatial(hexagon = FALSE, ...)`,
#' converti en `rsample::manual_rset()`. Il vise les estimateurs SANS lissage
#' geographique (GLM, SpBoost), pour lesquels des blocs contigus tenus a
#' l'ecart ne penalisent pas injustement le modele comme ils le feraient pour
#' un estimateur a lissage local.
#'
#' @param data data.frame ou objet sf.
#' @param coords Vecteur de caracteres de longueur 2 avec les noms des colonnes
#'   de coordonnees, utilise seulement si `data` n'est pas deja un objet sf.
#' @param crs Code EPSG a assigner lors de la construction de la couche sf de
#'   points depuis `coords`, ignore si `data` est deja un objet sf.
#' @param v Nombre de blocs/folds spatiaux.
#' @param seed Graine optionnelle transmise a `blockCV::cv_spatial`.
spatial_block_rset <- function(data, coords = NULL, crs = NULL, v = 5, seed = NULL) {
  # Deuxieme schema de validation spatiale: blocs contigus non hexagonaux via
  # blockCV. Comme near_prediction_rset(), on convertit ensuite le resultat en
  # rsample::manual_rset() pour garder une API commune.
  require_package("blockCV", "spatial block cross-validation")
  require_package("sf", "spatial block cross-validation")

  pts <- if (inherits(data, "sf")) {
    data
  } else {
    stopifnot(is.character(coords), length(coords) == 2, all(coords %in% names(data)))
    sf::st_as_sf(data, coords = coords, crs = crs, remove = FALSE)
  }

  sb <- blockCV::cv_spatial(
    x = pts, k = v, hexagon = FALSE,
    seed = seed, progress = FALSE, report = FALSE, plot = FALSE
  )

  splits <- lapply(sb$folds_list, function(fold) {
    rsample::make_splits(x = list(analysis = fold[[1]], assessment = fold[[2]]), data = data)
  })
  ids <- sprintf("block%02d", seq_along(splits))
  rsample::manual_rset(splits, ids)
}
