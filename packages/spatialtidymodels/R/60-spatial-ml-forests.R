# Wrappers internes pour les estimateurs spatial machine learning.
#
# Ces fonctions branchent des packages R externes au benchmark automatique sans
# en faire encore des specs parsnip completes. Chaque wrapper garde une
# interface commune: fit(formula, data, coords), puis predict(..., new_data).

spatial_forest_formula_parts <- function(formula, data, coords) {
  # Recupere la reponse et les predicteurs non geographiques de la formule.
  model_formula <- drop_formula_terms(formula, coords, data = data)
  response <- deparse(model_formula[[2]])
  predictors <- attr(stats::terms(model_formula, data = data), "term.labels")
  if (length(predictors) < 1L) {
    stop("Spatial forest estimators require at least one non-coordinate predictor.", call. = FALSE)
  }
  list(formula = model_formula, response = response, predictors = predictors)
}

fit_spatialml_grf_impl <- function(formula, data, coords, bandwidth = 20L,
                                   kernel = "adaptive", ntree = 100L,
                                   mtry = NULL, nthreads = 1L) {
  # SpatialML::grf() ajuste une foret locale par observation. Avec
  # kernel="adaptive", bandwidth est interprete comme un nombre de voisins.
  require_package("SpatialML", "benchmark SpatialML GRF")
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  parts <- spatial_forest_formula_parts(formula, data = data, coords = coords)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  bw <- min(as.integer(bandwidth), nrow(data) - 1L)
  bw <- max(2L, bw)

  fit <- SpatialML::grf(
    formula = parts$formula,
    dframe = data,
    bw = bw,
    kernel = kernel,
    coords = coords_mat,
    ntree = as.integer(ntree),
    mtry = mtry,
    nthreads = as.integer(nthreads),
    forests = TRUE,
    print.results = FALSE
  )

  structure(
    list(model = fit, formula = parts$formula, coords = coords),
    class = "spatialtidymodels_spatialml_grf"
  )
}

#' @export
predict.spatialtidymodels_spatialml_grf <- function(object, new_data = NULL,
                                                    newdata = NULL, ...) {
  if (is.null(new_data)) new_data <- newdata
  new_data <- as.data.frame(new_data)
  stats::predict(
    object$model,
    new.data = new_data,
    x.var.name = object$coords[[1]],
    y.var.name = object$coords[[2]],
    ...
  )
}

fit_spatialrf_impl <- function(formula, data, coords, ntree = 100L,
                               method = "hengl", mtry = NULL,
                               min_node_size = NULL,
                               max_spatial_predictors = NULL,
                               ncores = 1L) {
  # spatialRF::rf_spatial() cree des predicteurs spatiaux pour reduire
  # l'autocorrelation residuelle. On utilise une matrice de distances construite
  # depuis les coordonnees du dataset courant.
  require_package("spatialRF", "benchmark spatialRF")
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  parts <- spatial_forest_formula_parts(formula, data = data, coords = coords)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  distance_matrix <- as.matrix(stats::dist(coords_mat))

  ranger_arguments <- list(num.trees = as.integer(ntree))
  if (!is.null(mtry)) ranger_arguments$mtry <- as.integer(mtry)
  if (!is.null(min_node_size)) ranger_arguments$min.node.size <- as.integer(min_node_size)

  fit <- spatialRF::rf_spatial(
    data = data,
    dependent.variable.name = parts$response,
    predictor.variable.names = parts$predictors,
    distance.matrix = distance_matrix,
    distance.thresholds = 0,
    xy = coords,
    method = method,
    ranger.arguments = ranger_arguments,
    max.spatial.predictors = max_spatial_predictors,
    n.cores = as.integer(ncores),
    verbose = FALSE
  )

  structure(
    list(
      model = fit,
      formula = parts$formula,
      coords = coords,
      train_coords = coords_mat,
      train_n = nrow(data),
      train_rownames = rownames(data)
    ),
    class = "spatialtidymodels_spatialrf"
  )
}

spatialrf_hengl_prediction_data <- function(object, new_data) {
  # Avec method="hengl", spatialRF ajoute au fit une colonne par distance entre
  # l'observation courante et chaque point train. predict.ranger() attend ces
  # memes colonnes dans new_data. On les reconstruit donc en test-train.
  method <- object$model$spatial$method
  if (!identical(method, "hengl")) return(new_data)

  coords <- check_spatial_coords(object$coords, data = new_data)
  train_coords <- object$train_coords
  test_coords <- as.matrix(new_data[, coords, drop = FALSE])
  all_coords <- rbind(test_coords, train_coords)
  distance_matrix <- as.matrix(stats::dist(all_coords))
  n_test <- nrow(test_coords)
  n_train <- nrow(train_coords)
  spatial_predictors <- distance_matrix[
    seq_len(n_test),
    n_test + seq_len(n_train),
    drop = FALSE
  ]
  colnames(spatial_predictors) <- paste0("spatial_predictor_", seq_len(n_train))
  cbind(new_data, as.data.frame(spatial_predictors, check.names = FALSE))
}

#' @export
predict.spatialtidymodels_spatialrf <- function(object, new_data = NULL,
                                                newdata = NULL, ...) {
  # spatialRF expose explicitement get_predictions() pour l'in-sample. Pour le
  # hors-echantillon, on tente la methode predict() du modele sous-jacent; si le
  # package ne peut pas reconstruire les predicteurs spatiaux, le benchmark
  # gardera cette erreur fold par fold.
  if (is.null(new_data)) new_data <- newdata
  new_data <- as.data.frame(new_data)
  if (nrow(new_data) == object$train_n &&
      identical(rownames(new_data), object$train_rownames)) {
    return(as.numeric(spatialRF::get_predictions(object$model)))
  }
  new_data <- spatialrf_hengl_prediction_data(object, new_data)
  pred <- stats::predict(object$model, data = new_data, ...)
  if (is.list(pred) && !is.null(pred$predictions)) return(as.numeric(pred$predictions))
  if (is.list(pred) && !is.null(pred$predictions$values)) return(as.numeric(pred$predictions$values))
  as.numeric(pred)
}

fit_rfgls_impl <- function(formula, data, coords, ntree = 50L,
                           n_neighbors = 15L, nthsize = 20L,
                           mtry = NULL, cov_model = "exponential",
                           param_estimate = FALSE) {
  # RandomForestsGLS attend y, X et coords separes. X garde l'intercept, comme
  # demande par RFGLS_predict() qui impose la meme structure au predict.
  require_package("RandomForestsGLS", "benchmark RandomForestsGLS")
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  parts <- spatial_forest_formula_parts(formula, data = data, coords = coords)
  terms_obj <- stats::terms(parts$formula, data = data)
  X <- stats::model.matrix(stats::delete.response(terms_obj), data = data)
  y <- data[[parts$response]]
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  if (is.null(mtry)) mtry <- max(1L, floor(ncol(X) / 3L))

  fit <- RandomForestsGLS::RFGLS_estimate_spatial(
    coords = coords_mat,
    y = y,
    X = X,
    mtry = mtry,
    ntree = as.integer(ntree),
    nthsize = as.integer(min(nthsize, max(2L, floor(nrow(data) / 2L)))),
    n.neighbors = as.integer(min(n_neighbors, nrow(data) - 1L)),
    cov.model = cov_model,
    param_estimate = isTRUE(param_estimate),
    verbose = FALSE
  )

  structure(
    list(model = fit, terms = terms_obj, formula = parts$formula),
    class = "spatialtidymodels_rfgls"
  )
}

#' @export
predict.spatialtidymodels_rfgls <- function(object, new_data = NULL,
                                            newdata = NULL, ...) {
  if (is.null(new_data)) new_data <- newdata
  new_data <- as.data.frame(new_data)
  Xtest <- stats::model.matrix(stats::delete.response(object$terms), data = new_data)
  pred <- RandomForestsGLS::RFGLS_predict(object$model, Xtest = Xtest, verbose = FALSE, ...)
  if (is.list(pred) && !is.null(pred$predicted)) return(as.numeric(pred$predicted))
  as.numeric(pred)
}
