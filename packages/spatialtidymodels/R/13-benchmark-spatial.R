# Benchmark automatique pour un ensemble d'estimateurs spatiaux.
#
# Cette couche est differente des raccourcis fit_sar()/fit_sem()/fit_sdm():
# elle orchestre plusieurs estimateurs, collecte les diagnostics communs et
# retourne une table comparable. Les raccourcis restent utiles pour inspecter
# un estimateur pas a pas.

spatial_benchmark_registry <- function() {
  # Registre utilisateur des estimateurs. Il sert a la fois de documentation
  # console et de garde-fou pour benchmark_spatial().
  estimators <- c(
    "ols", "gam_spatial",
    "earth", "earth_xy", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy",
    "sar_lag", "sem_error", "sdm_mixed",
    "spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar",
    "spmoran_esf", "spmoran_resf"
  )
  automatic <- c(
    TRUE, TRUE,
    TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
    TRUE, TRUE, TRUE,
    TRUE, TRUE, TRUE, TRUE, TRUE,
    TRUE, TRUE
  )
  data.frame(
    estimator = estimators,
    status = ifelse(automatic, "automatic", "known_not_automated"),
    mode = rep("regression", length(estimators)),
    package = c(
      "stats", "mgcv",
      "earth", "earth", "ranger", "ranger", "xgboost", "xgboost",
      "spatialreg", "spatialreg", "spatialreg",
      "spboost", "mgwrsar", "mgwrsar", "mgwrsar", "mgwrsar",
      "spmoran", "spmoran"
    ),
    backend = c(
      "stats::glm", "mgcv::gam",
      "earth::earth", "earth::earth", "ranger::ranger", "ranger::ranger",
      "xgboost::xgb.train", "xgboost::xgb.train",
      "spatialreg::lagsarlm",
      "spatialreg::errorsarlm", "spatialreg::lagsarlm(Durbin)",
      "spboost::spbgam", "mgwrsar::MGWRSAR(GWR)",
      "mgwrsar::MGWRSAR(SAR)",
      "mgwrsar::TDS_MGWR", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)",
      "spmoran::esf", "spmoran::resf"
    ),
    automatic = automatic,
    requires_coords = c(
      FALSE, TRUE,
      FALSE, TRUE, FALSE, TRUE, FALSE, TRUE,
      TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE
    ),
    requires_W = c(
      FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE
    ),
    spatial_args = c(
      "", "coords",
      "", "coords_as_covariates", "", "coords_as_covariates", "", "coords_as_covariates",
      "coords/W/k_neighbors/style/zero_policy",
      "coords/W/k_neighbors/style/zero_policy", "coords/W/k_neighbors/style/zero_policy",
      "coords/k_neighbors", "coords/bandwidth/kernel", "coords/W",
      "coords", "coords/W/bandwidth/kernel", "coords", "coords"
    ),
    tunable_parameters = c(
      "", "",
      "", "", "", "", "", "",
      "k_neighbors", "k_neighbors", "k_neighbors",
      "mstop, nu, k_neighbors", "bandwidth, kernel", "",
      "", "bandwidth, kernel", "enum", "enum"
    ),
    notes = c(
      "Baseline lineaire.",
      "Baseline GAM avec lisseur spatial s(x, y).",
      "Baseline MARS native tidymodels sur X seules.",
      "Baseline MARS native tidymodels sur X et coordonnees brutes.",
      "Baseline random forest native tidymodels sur X seules.",
      "Baseline random forest native tidymodels sur X et coordonnees brutes.",
      "Baseline XGBoost native tidymodels sur X seules.",
      "Baseline XGBoost native tidymodels sur X et coordonnees brutes.",
      "SAR lag via fit_sar().",
      "SEM error via fit_sem().",
      "SDM mixed via fit_sdm().",
      "SpBoost SAR via spboost_reg().",
      "GWR local via mgwrsar_reg(Model='GWR').",
      "SAR global via mgwrsar_reg(Model='SAR').",
      "MGWR multiscale via mgwrsar_reg(Model='tds_mgwr').",
      "MGWRSAR autocorrele via mgwrsar_reg(Model='MGWRSAR_1_0_kv').",
      "Eigenvector spatial filtering via spmoran::esf().",
      "Random-effects eigenvector spatial filtering via spmoran::resf()."
    ),
    stringsAsFactors = FALSE
  )
}

package_available <- function(package) {
  # stats est fourni par R; les autres packages sont verifies sans les attacher.
  if (identical(package, "stats")) return(TRUE)
  requireNamespace(package, quietly = TRUE)
}

#' List benchmark estimators
#'
#' Returns the estimator registry known by `spatialtidymodels`, including the
#' backend package, automation status, spatial arguments, tuning parameters, and
#' whether the required R package is installed.
#'
#' @param include_installed If `TRUE`, add a column indicating whether the
#'   required R package is available in the current session.
#'
#' @return A data frame.
#' @export
available_benchmark_estimators <- function(include_installed = TRUE) {
  out <- spatial_benchmark_registry()
  if (isTRUE(include_installed)) {
    out$installed <- vapply(out$package, package_available, logical(1))
  }
  out
}

add_coords_to_baseline_formula <- function(formula, coords, data) {
  # Formule des baselines "_xy": les coordonnees deviennent des covariables
  # ordinaires. Ce n'est pas une autocorrelation spatiale ni une matrice W.
  add_coords_to_formula(formula, check_spatial_coords(coords, data = data), data)
}

add_spatial_smooth_to_formula <- function(formula, coords, data) {
  # Formule GAM: les coordonnees sont ajoutees comme lisseur spatial global.
  coords <- check_spatial_coords(coords, data = data)
  response <- deparse(formula[[2]])
  rhs_terms <- attr(stats::terms(formula, data = data), "term.labels")
  rhs <- paste(c(rhs_terms, sprintf("s(%s, %s)", coords[[1]], coords[[2]])), collapse = " + ")
  out <- stats::as.formula(paste(response, "~", rhs), env = environment(formula))
  environment(out)$s <- mgcv::s
  out
}

fit_parsnip_baseline <- function(spec, formula, data, coords = NULL) {
  # Route commune pour les baselines ML natives de tidymodels. Elles restent
  # volontairement simples: pas de W, pas de modele spatial explicite.
  require_package("workflows", "benchmark baseline tidymodels")
  workflows::workflow() |>
    workflows::add_formula(formula) |>
    workflows::add_model(spec) |>
    workflows::fit(data = data)
}

spmoran_model_matrix <- function(formula, data) {
  # spmoran attend y et x separement. On retire l'intercept de x, car spmoran
  # gere sa constante dans le backend.
  response <- deparse(formula[[2]])
  x <- stats::model.matrix(formula, data = data)
  if ("(Intercept)" %in% colnames(x)) {
    x <- x[, setdiff(colnames(x), "(Intercept)"), drop = FALSE]
  }
  list(y = data[[response]], x = x, response = response)
}

fit_spmoran_benchmark <- function(formula, data, coords, model_type = c("esf", "resf")) {
  # Route benchmark pour spmoran. Elle n'est pas encore une spec parsnip, mais
  # elle supporte prediction hors-echantillon via meigen0() + predict0().
  require_package("spmoran", "spmoran benchmark")
  model_type <- match.arg(model_type)
  coords <- check_spatial_coords(coords, data = data)
  xy <- as.matrix(data[, coords, drop = FALSE])
  matrices <- spmoran_model_matrix(formula, data)
  meig <- if (nrow(data) > 1000L) {
    spmoran::meigen_f(coords = xy)
  } else {
    spmoran::meigen(coords = xy)
  }
  fit <- switch(model_type,
    esf = spmoran::esf(y = matrices$y, x = matrices$x, meig = meig, vif = 10),
    resf = spmoran::resf(y = matrices$y, x = matrices$x, meig = meig)
  )
  structure(
    list(
      fit = fit,
      meig = meig,
      formula = formula,
      coords = coords,
      train_data = data,
      model_type = model_type,
      response = matrices$response
    ),
    class = "spmoran_benchmark"
  )
}

#' @export
predict.spmoran_benchmark <- function(object, new_data = NULL, newdata = NULL, ...) {
  # Prediction in-sample depuis l'objet spmoran, prediction hors-echantillon
  # via meigen0()/predict0() comme documente par spmoran.
  if (is.null(new_data) && !is.null(newdata)) new_data <- newdata
  if (is.null(new_data)) new_data <- object$train_data
  new_data <- as.data.frame(new_data)
  if (identical(nrow(new_data), nrow(object$train_data)) &&
      identical(rownames(new_data), rownames(object$train_data))) {
    pred <- object$fit$pred
    if (is.data.frame(pred) && "pred" %in% names(pred)) pred <- pred$pred
    return(data.frame(.pred = as.numeric(pred)))
  }
  matrices <- spmoran_model_matrix(object$formula, new_data)
  meig0 <- spmoran::meigen0(
    meig = object$meig,
    coords0 = as.matrix(new_data[, object$coords, drop = FALSE])
  )
  pred <- spmoran::predict0(object$fit, meig0 = meig0, x0 = matrices$x)
  data.frame(.pred = as.numeric(pred$pred$pred))
}

fit_one_benchmark_estimator <- function(estimator, formula, data, coords,
                                        k_neighbors = 8, style = "W",
                                        zero_policy = TRUE,
                                        spboost_mstop = 100L,
                                        spboost_nu = 0.1,
                                        mgwrsar_bandwidth = 20,
                                        mgwrsar_kernel = "bisq") {
  # Ajuste un estimateur connu. Les erreurs sont laissees au niveau appelant
  # pour produire une ligne de benchmark explicite plutot qu'un plantage global.
  switch(estimator,
    ols = stats::glm(formula, data = data),
    gam_spatial = {
      require_package("mgcv", "benchmark GAM spatial")
      mgcv::gam(add_spatial_smooth_to_formula(formula, coords, data), data = data)
    },
    earth = {
      require_package("earth", "benchmark MARS")
      fit_parsnip_baseline(
        parsnip::mars(mode = "regression") |> parsnip::set_engine("earth"),
        formula, data
      )
    },
    earth_xy = {
      require_package("earth", "benchmark MARS avec coordonnees")
      fit_parsnip_baseline(
        parsnip::mars(mode = "regression") |> parsnip::set_engine("earth"),
        add_coords_to_baseline_formula(formula, coords, data), data
      )
    },
    random_forest = {
      require_package("ranger", "benchmark random forest")
      fit_parsnip_baseline(
        parsnip::rand_forest(mode = "regression", trees = 100L) |> parsnip::set_engine("ranger"),
        formula, data
      )
    },
    random_forest_xy = {
      require_package("ranger", "benchmark random forest avec coordonnees")
      fit_parsnip_baseline(
        parsnip::rand_forest(mode = "regression", trees = 100L) |> parsnip::set_engine("ranger"),
        add_coords_to_baseline_formula(formula, coords, data), data
      )
    },
    xgboost = {
      require_package("xgboost", "benchmark XGBoost")
      fit_parsnip_baseline(
        parsnip::boost_tree(mode = "regression", trees = 100L) |> parsnip::set_engine("xgboost"),
        formula, data
      )
    },
    xgboost_xy = {
      require_package("xgboost", "benchmark XGBoost avec coordonnees")
      fit_parsnip_baseline(
        parsnip::boost_tree(mode = "regression", trees = 100L) |> parsnip::set_engine("xgboost"),
        add_coords_to_baseline_formula(formula, coords, data), data
      )
    },
    sar_lag = fit_sar(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sem_error = fit_sem(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sdm_mixed = fit_sdm(
      formula, data = data, coords = coords, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    spboost = {
      require_package("workflows", "benchmark SpBoost")
      spec <- spboost_reg(
        coords = coords, DGP = "SAR", mstop = spboost_mstop,
        nu = spboost_nu, k_neighbors = k_neighbors
      ) |>
        parsnip::set_engine("spboost") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_gwr = {
      require_package("workflows", "benchmark MGWRSAR GWR")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "GWR",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_sar = {
      require_package("workflows", "benchmark MGWRSAR SAR")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "SAR"
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_mgwr = {
      require_package("workflows", "benchmark MGWR multiscale")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "tds_mgwr",
        kernels = "gauss"
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    mgwrsar_mgwrsar = {
      require_package("workflows", "benchmark MGWRSAR autocorrele")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "MGWRSAR_1_0_kv",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth
      ) |>
        parsnip::set_engine("mgwrsar") |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    spmoran_esf = fit_spmoran_benchmark(
      formula = formula, data = data, coords = coords, model_type = "esf"
    ),
    spmoran_resf = fit_spmoran_benchmark(
      formula = formula, data = data, coords = coords, model_type = "resf"
    ),
    stop(sprintf("Estimateur non automatise dans benchmark_spatial(): %s", estimator), call. = FALSE)
  )
}

make_benchmark_workflow <- function(spec, formula, coords, data) {
  # Les moteurs spatiaux ont besoin des coordonnees dans les donnees du
  # workflow. On les ajoute a la formule de pretraitement, puis les backends
  # retirent ces colonnes du modele econometrique quand c'est necessaire.
  require_package("workflows", "construction du workflow de tuning")
  workflows::workflow() |>
    workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
    workflows::add_model(spec)
}

default_benchmark_grid <- function(estimator, data) {
  # Grilles courtes et conservatrices pour l'API utilisateur. Les gros runs
  # scientifiques doivent fournir une grille explicite via `tuning_grids`.
  n <- nrow(data)
  switch(estimator,
    sar_lag = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sem_error = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sdm_mixed = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    spboost = data.frame(mstop = c(50L, 100L, 200L)),
    mgwrsar_gwr = expand.grid(
      bandwidth = unique(pmin(c(20L, 40L), max(3L, n - 1L))),
      kernel = c("bisq", "gauss"),
      KEEP.OUT.ATTRS = FALSE
    ),
    mgwrsar_mgwrsar = expand.grid(
      bandwidth = unique(pmin(c(20L, 40L), max(3L, n - 1L))),
      kernel = c("bisq", "gauss"),
      KEEP.OUT.ATTRS = FALSE
    ),
    NULL
  )
}

benchmark_tuning_grid <- function(estimator, tuning_grids, data) {
  # Une grille utilisateur a priorite; sinon on cree une petite grille par
  # defaut pour les estimateurs supportes.
  if (!is.null(tuning_grids) && estimator %in% names(tuning_grids)) {
    return(as.data.frame(tuning_grids[[estimator]]))
  }
  default_benchmark_grid(estimator, data)
}

fit_tune_grid_or_error <- function(wf, resamples, grid) {
  # Enveloppe unique pour garder l'erreur dans l'objet benchmark au lieu de
  # stopper tout le run.
  require_package("tune", "tuning benchmark_spatial()")
  require_package("yardstick", "metriques de tuning benchmark_spatial()")
  tryCatch(
    tune::tune_grid(
      wf,
      resamples = resamples,
      grid = grid,
      metrics = yardstick::metric_set(yardstick::rmse, yardstick::mae),
      control = tune::control_grid(save_pred = FALSE, verbose = FALSE)
    ),
    error = function(e) e
  )
}

collect_benchmark_tuning <- function(tuned, grid_cols) {
  # Convertit tune_grid() en table plate: une ligne par candidat avec RMSE/MAE.
  metrics <- tune::collect_metrics(tuned)
  if (nrow(metrics) == 0L) {
    stop("tune_grid() n'a retourne aucune metrique.", call. = FALSE)
  }
  one_metric <- function(metric_name, value_name) {
    rows <- metrics[metrics$.metric == metric_name, c(grid_cols, "mean", "n"), drop = FALSE]
    names(rows)[names(rows) == "mean"] <- value_name
    names(rows)[names(rows) == "n"] <- paste0("n_", metric_name)
    rows
  }
  rmse <- one_metric("rmse", "rmse")
  mae <- one_metric("mae", "mae")
  out <- merge(rmse, mae, by = grid_cols, all = TRUE)
  out$n_ok <- out$n_rmse
  out[order(out$rmse), , drop = FALSE]
}

tune_spatialreg_benchmark <- function(estimator, formula, data, coords, resamples,
                                      grid, style = "W", zero_policy = TRUE) {
  spec <- switch(estimator,
    sar_lag = sar_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sem_error = sem_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sdm_mixed = sdm_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy)
  ) |>
    parsnip::set_engine("spatialreg") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  tuned <- fit_tune_grid_or_error(wf, resamples, grid)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, "k_neighbors")
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(k_neighbors = as.integer(best$k_neighbors[[1]]))
  )
}

tune_spboost_benchmark <- function(formula, data, coords, resamples, grid,
                                  spboost_nu = 0.1, k_neighbors = 8) {
  spec <- spboost_reg(
    coords = coords, DGP = "SAR", mstop = tune::tune(),
    nu = spboost_nu, k_neighbors = k_neighbors
  ) |>
    parsnip::set_engine("spboost") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  tuned <- fit_tune_grid_or_error(wf, resamples, grid)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, "mstop")
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(spboost_mstop = as.integer(best$mstop[[1]]))
  )
}

tune_mgwrsar_benchmark <- function(estimator, formula, data, coords, resamples, grid) {
  # `kernel` est boucle explicitement: c'est plus robuste que de tuner un
  # argument caractere custom dans cette premiere API.
  model_type <- switch(estimator,
    mgwrsar_gwr = "GWR",
    mgwrsar_mgwrsar = "MGWRSAR_1_0_kv"
  )
  if (!"kernel" %in% names(grid)) grid$kernel <- "bisq"
  pieces <- lapply(split(grid, grid$kernel), function(one_kernel_grid) {
    kernel_value <- as.character(one_kernel_grid$kernel[[1]])
    one_grid <- data.frame(bandwidth = as.integer(one_kernel_grid$bandwidth))
    spec <- mgwrsar_reg(
      coords = coords, model_type = model_type,
      kernel = kernel_value, bandwidth = tune::tune()
    ) |>
      parsnip::set_engine("mgwrsar") |>
      parsnip::set_mode("regression")
    wf <- make_benchmark_workflow(spec, formula, coords, data)
    tuned <- fit_tune_grid_or_error(wf, resamples, one_grid)
    if (inherits(tuned, "error")) {
      return(data.frame(
        bandwidth = one_grid$bandwidth,
        kernel = kernel_value,
        rmse = NA_real_, n_rmse = 0L, mae = NA_real_, n_mae = 0L, n_ok = 0L,
        error = conditionMessage(tuned),
        stringsAsFactors = FALSE
      ))
    }
    out <- collect_benchmark_tuning(tuned, "bandwidth")
    out$kernel <- kernel_value
    out$error <- NA_character_
    out
  })
  grid_out <- do.call(rbind, pieces)
  ok <- is.finite(grid_out$rmse) & grid_out$n_ok > 0L
  if (!any(ok)) {
    return(list(error = "Tous les candidats mgwrsar ont echoue pendant tune_grid().", grid = grid_out))
  }
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = NULL,
    params = list(
      mgwrsar_bandwidth = as.integer(best$bandwidth[[1]]),
      mgwrsar_kernel = as.character(best$kernel[[1]])
    )
  )
}

tune_one_benchmark_estimator <- function(estimator, formula, data, coords, resamples,
                                         tuning_grids = NULL, k_neighbors = 8,
                                         style = "W", zero_policy = TRUE,
                                         spboost_nu = 0.1) {
  # Retourne NULL si l'estimateur n'a pas encore de route de tuning package.
  grid <- benchmark_tuning_grid(estimator, tuning_grids, data)
  if (is.null(grid)) return(NULL)
  out <- tryCatch({
    switch(estimator,
      sar_lag = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      sem_error = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      sdm_mixed = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy),
      spboost = tune_spboost_benchmark(formula, data, coords, resamples, grid, spboost_nu, k_neighbors),
      mgwrsar_gwr = tune_mgwrsar_benchmark(estimator, formula, data, coords, resamples, grid),
      mgwrsar_mgwrsar = tune_mgwrsar_benchmark(estimator, formula, data, coords, resamples, grid),
      NULL
    )
  }, error = function(e) list(error = conditionMessage(e)))
  if (is.null(out)) return(NULL)
  out$estimator <- estimator
  out
}

make_default_resamples <- function(data, tuning_folds = 3L) {
  # V-fold classique par defaut. Les validations spatiales specialisees doivent
  # etre construites hors package et passees via `resamples`.
  require_package("rsample", "creation des resamples de tuning")
  v <- min(as.integer(tuning_folds), nrow(data))
  if (v < 2L) stop("tuning_folds doit etre au moins egal a 2.", call. = FALSE)
  rsample::vfold_cv(data, v = v)
}

build_near_prediction_folds <- function(coords, n_reps = 3L, test_size = 20L,
                                        seed = 123L) {
  # Port minimal de la near-prediction du benchmark manuel: le domaine est
  # decoupe par quadtree, puis chaque repetition tire un point test par cellule.
  coords <- as.matrix(coords)
  n <- nrow(coords)
  n_reps <- as.integer(n_reps)
  test_size <- as.integer(test_size)

  if (!is.numeric(coords) || ncol(coords) != 2L || any(!is.finite(coords))) {
    stop("`coords` must be a finite numeric matrix with two columns.", call. = FALSE)
  }
  if (n_reps < 1L || test_size < 1L) {
    stop("`near_n_reps` and `near_test_size` must be positive.", call. = FALSE)
  }
  if (n < n_reps * test_size) {
    stop(sprintf(
      "The dataset has %d rows, which is too small for %d near-prediction repeats with target test size %d.",
      n, n_reps, test_size
    ), call. = FALSE)
  }

  require_package("mgwrsar", "near-prediction resampling")
  ns_mgwrsar <- asNamespace("mgwrsar")
  quadtree_fn <- get("quadtree", envir = ns_mgwrsar)
  cell_fn <- get("cell", envir = ns_mgwrsar)
  insidecell_fn <- get("insidecell", envir = ns_mgwrsar)

  build_quad_partition <- function(k_leaf) {
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
      k_leaf = k_leaf,
      cell_id = cell_id,
      cell_members = cell_members,
      cell_sizes = cell_sizes,
      n_cells = length(cell_members),
      min_cell_size = min(cell_sizes)
    )
  }

  k_target <- max(n_reps, ceiling(n / (2 * test_size)))
  k_min <- max(n_reps, floor(k_target / 2))
  k_max <- max(k_min, ceiling(k_target * 2))
  k_candidates <- sort(unique(as.integer(round(seq(k_min, k_max, length.out = 15L)))))

  partitions <- lapply(k_candidates, function(k_candidate) {
    tryCatch(build_quad_partition(k_candidate), error = function(e) NULL)
  })
  partitions <- Filter(Negate(is.null), partitions)
  if (length(partitions) == 0L) {
    stop("No valid quadtree partition could be built for near-prediction.", call. = FALSE)
  }

  valid <- vapply(partitions, function(partition) partition$min_cell_size >= n_reps, logical(1L))
  if (!any(valid)) {
    best <- partitions[[which.max(vapply(partitions, function(p) p$min_cell_size, integer(1L)))]]
    stop(sprintf(
      "Cannot build %d near-prediction repeats: the best partition has a cell with only %d rows.",
      n_reps, best$min_cell_size
    ), call. = FALSE)
  }

  partitions <- partitions[valid]
  best_index <- which.min(vapply(partitions, function(p) abs(p$n_cells - test_size), numeric(1L)))
  partition <- partitions[[best_index]]

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

  folds <- lapply(seq_len(n_reps), function(rep) {
    test <- test_matrix[rep, ]
    list(train = setdiff(seq_len(n), test), test = test)
  })
  names(folds) <- paste0("rep_", seq_len(n_reps))

  test_indices <- lapply(seq_len(n_reps), function(rep) test_matrix[rep, ])
  names(test_indices) <- names(folds)

  # Assertions de fidelite au protocole near-prediction: aucun recouvrement
  # train/test, univers complet dans chaque fold, tests disjoints, un point test
  # par cellule et par repetition.
  if (!all(vapply(folds, function(fold) length(intersect(fold$train, fold$test)) == 0L, logical(1L)))) {
    stop("Internal near-prediction check failed: train/test overlap.", call. = FALSE)
  }
  if (!all(vapply(folds, function(fold) length(union(fold$train, fold$test)) == n, logical(1L)))) {
    stop("Internal near-prediction check failed: incomplete train/test universe.", call. = FALSE)
  }
  all_test <- unlist(test_indices, use.names = FALSE)
  if (anyDuplicated(all_test)) {
    stop("Internal near-prediction check failed: test sets are not disjoint.", call. = FALSE)
  }
  one_per_cell <- all(vapply(test_indices, function(test) {
    identical(sort(partition$cell_id[test]), seq_len(partition$n_cells))
  }, logical(1L)))
  if (!one_per_cell) {
    stop("Internal near-prediction check failed: expected one test point per cell.", call. = FALSE)
  }

  list(
    folds = folds,
    test_indices = test_indices,
    cell_id = partition$cell_id,
    cell_sizes = partition$cell_sizes,
    polygons = partition$polys,
    k_leaf = partition$k_leaf,
    n_cells = partition$n_cells,
    requested_test_size = test_size
  )
}

near_prediction_rset <- function(data, coords, n_reps = 3L, test_size = 20L,
                                 seed = 123L) {
  # Convertit la near-prediction maison en manual_rset tidymodels.
  coords_mat <- as.matrix(data[, coords, drop = FALSE])
  colnames(coords_mat) <- c("x", "y")
  near_cv <- build_near_prediction_folds(
    coords_mat,
    n_reps = n_reps,
    test_size = test_size,
    seed = seed
  )
  splits <- lapply(near_cv$folds, function(fold) {
    rsample::make_splits(x = list(analysis = fold$train, assessment = fold$test), data = data)
  })
  rset <- rsample::manual_rset(splits, names(near_cv$folds))
  attr(rset, "near_cv") <- near_cv
  attr(rset, "near_cv_meta") <- near_cv[c(
    "test_indices", "cell_id", "cell_sizes", "k_leaf",
    "n_cells", "requested_test_size"
  )]
  rset
}

#' Plot a near-prediction resampling fold
#'
#' Visualizes one near-prediction fold generated by `make_spatial_resamples()`.
#' Training observations are shown in grey, test observations in red, and the
#' quadtree cell borders in blue.
#'
#' @param rset A near-prediction rset returned by `make_spatial_resamples()`.
#' @param data Optional data frame. If omitted, the function uses the data
#'   stored inside the rsample split.
#' @param coords Coordinate column names. Required when `data` is supplied.
#' @param fold Fold number or fold id.
#'
#' @return A `ggplot2` object.
#' @export
plot_near_prediction_fold <- function(rset, data = NULL, coords = NULL, fold = 1L) {
  # Visualisation reprise du script local code/R/utils/spatial_cv.R, adaptee au
  # rset package et a la metadata stockee dans attr(rset, "near_cv").
  require_package("ggplot2", "near-prediction fold plot")
  near_cv <- attr(rset, "near_cv")
  if (is.null(near_cv)) {
    stop("`rset` does not contain near-prediction metadata. Rebuild it with cv_scheme = 'near_prediction'.", call. = FALSE)
  }

  if (is.character(fold)) {
    fold_index <- match(fold, names(near_cv$folds))
  } else {
    fold_index <- as.integer(fold)
  }
  if (length(fold_index) != 1L || is.na(fold_index) ||
      fold_index < 1L || fold_index > length(near_cv$folds)) {
    stop("`fold` must identify an existing near-prediction repetition.", call. = FALSE)
  }

  if (is.null(data)) {
    split_obj <- rset$splits[[fold_index]]
    data <- split_obj$data
  } else {
    data <- as.data.frame(data)
  }
  if (is.null(coords)) {
    coords <- c("x", "y")
    if (!all(coords %in% names(data))) {
      stop("`coords` must be supplied when data does not contain columns named x and y.", call. = FALSE)
    }
  }
  coords <- check_spatial_coords(coords, data = data)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])

  if (ncol(coords_mat) != 2L || nrow(coords_mat) != length(near_cv$cell_id)) {
    stop("`data` and `coords` must match the coordinates used to build the near-prediction rset.", call. = FALSE)
  }

  split <- near_cv$folds[[fold_index]]
  plot_data <- data.frame(
    x = coords_mat[, 1L],
    y = coords_mat[, 2L],
    set = "Train",
    cell_id = near_cv$cell_id
  )
  plot_data$set[split$test] <- "Test"
  plot_data$set <- factor(plot_data$set, levels = c("Train", "Test"))

  ggplot2::ggplot() +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Train", , drop = FALSE],
      ggplot2::aes(x = x, y = y),
      color = "grey65",
      size = 0.45,
      alpha = 0.55
    ) +
    ggplot2::geom_path(
      data = near_cv$polygons,
      ggplot2::aes(x = x, y = y, group = id),
      color = "#006D77",
      linewidth = 0.45,
      alpha = 0.9
    ) +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Test", , drop = FALSE],
      ggplot2::aes(x = x, y = y, color = set),
      size = 2.2,
      alpha = 0.95
    ) +
    ggplot2::scale_color_manual(values = c(Test = "#D73027"), name = NULL) +
    ggplot2::coord_equal() +
    ggplot2::labs(
      title = sprintf("Near-prediction - fold %s", names(near_cv$folds)[[fold_index]]),
      subtitle = sprintf(
        "%d quadtree cells - %d test points - %d train points",
        near_cv$n_cells,
        length(split$test),
        length(split$train)
      ),
      x = coords[[1]],
      y = coords[[2]],
      caption = "Red: test, one point per cell. Grey: train."
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "top",
      plot.title.position = "plot"
    )
}

spatial_block_rset <- function(data, coords, block_folds = 5L, seed = NULL) {
  # Validation spatiale par blocs contigus non hexagonaux via blockCV.
  require_package("blockCV", "spatial block resampling")
  require_package("sf", "spatial block resampling")

  pts <- sf::st_as_sf(data, coords = coords, remove = FALSE)
  sb <- blockCV::cv_spatial(
    x = pts,
    k = as.integer(block_folds),
    hexagon = FALSE,
    seed = seed,
    progress = FALSE,
    report = FALSE,
    plot = FALSE
  )

  splits <- lapply(sb$folds_list, function(fold) {
    rsample::make_splits(x = list(analysis = fold[[1]], assessment = fold[[2]]), data = data)
  })
  rsample::manual_rset(splits, sprintf("block%02d", seq_along(splits)))
}

#' Create spatial resamples for benchmark evaluation
#'
#' Builds the resampling objects used by `benchmark_spatial()` to score
#' out-of-sample performance. The spatial schemes mirror the manual benchmark:
#' a 10 percent holdout, near-prediction folds, and spatial block folds.
#'
#' @param data Data frame.
#' @param coords Coordinate column names.
#' @param cv_scheme Evaluation scheme.
#' @param eval_resamples Custom `rsample` object, used only with
#'   `cv_scheme = "custom"`.
#' @param eval_folds Number of folds for `vfold_cv`.
#' @param holdout_prop Proportion kept in the training set for
#'   `holdout_10pct`.
#' @param near_n_reps Number of near-prediction repetitions.
#' @param near_test_size Target number of near-prediction test cells.
#' @param block_folds Number of spatial block folds.
#' @param seed Random seed.
#'
#' @return An `rsample` rset, or `NULL` for `cv_scheme = "in_sample"`.
#' @export
make_spatial_resamples <- function(data, coords,
                                   cv_scheme = c(
                                     "holdout_10pct", "near_prediction",
                                     "block_spatial", "vfold_cv",
                                     "custom", "in_sample"
                                   ),
                                   eval_resamples = NULL,
                                   eval_folds = 5L,
                                   holdout_prop = 0.9,
                                   near_n_reps = 3L,
                                   near_test_size = NULL,
                                   block_folds = 5L,
                                   seed = 123L) {
  cv_scheme <- match.arg(cv_scheme)
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  if (identical(cv_scheme, "in_sample")) return(NULL)

  require_package("rsample", "benchmark evaluation resampling")
  if (identical(cv_scheme, "custom")) {
    if (is.null(eval_resamples)) {
      stop("cv_scheme = 'custom' requires `eval_resamples`.", call. = FALSE)
    }
    return(eval_resamples)
  }
  if (!is.null(eval_resamples)) return(eval_resamples)

  if (identical(cv_scheme, "holdout_10pct")) {
    set.seed(seed)
    split <- rsample::initial_split(data, prop = holdout_prop)
    return(rsample::manual_rset(list(split), "holdout"))
  }
  if (identical(cv_scheme, "vfold_cv")) {
    v <- min(as.integer(eval_folds), nrow(data))
    if (v < 2L) stop("eval_folds must be at least 2.", call. = FALSE)
    return(rsample::vfold_cv(data, v = v))
  }
  if (identical(cv_scheme, "near_prediction")) {
    if (is.null(near_test_size)) {
      near_test_size <- max(1L, floor(nrow(data) / as.integer(near_n_reps)))
    }
    return(near_prediction_rset(
      data = data,
      coords = coords,
      n_reps = near_n_reps,
      test_size = near_test_size,
      seed = seed
    ))
  }
  if (identical(cv_scheme, "block_spatial")) {
    return(spatial_block_rset(
      data = data,
      coords = coords,
      block_folds = block_folds,
      seed = seed
    ))
  }
}

make_evaluation_resamples <- function(data, coords, cv_scheme = "in_sample",
                                      eval_resamples = NULL, eval_folds = 5L,
                                      holdout_prop = 0.9,
                                      near_n_reps = 3L,
                                      near_test_size = NULL,
                                      block_folds = 5L,
                                      seed = 123L) {
  # Construit les folds utilises pour scorer la generalisation. Cette couche
  # est separee du tuning: `resamples` reste reserve a tune_grid().
  make_spatial_resamples(
    data = data,
    coords = coords,
    cv_scheme = cv_scheme,
    eval_resamples = eval_resamples,
    eval_folds = eval_folds,
    holdout_prop = holdout_prop,
    near_n_reps = near_n_reps,
    near_test_size = near_test_size,
    block_folds = block_folds,
    seed = seed
  )
}

apply_tuned_params <- function(base, tuned) {
  # Combine les valeurs fixes utilisateur et les meilleurs parametres tunes.
  if (is.null(tuned) || is.null(tuned$params)) return(base)
  utils::modifyList(base, tuned$params)
}

failed_benchmark_row <- function(estimator, data, formula, error) {
  # Ligne rectangulaire pour un estimateur qui echoue. Cela permet de comparer
  # les runs sans perdre l'information d'echec.
  data.frame(
    estimator = estimator,
    n = nrow(data),
    response = deparse(formula[[2]]),
    rmse = NA_real_,
    mae = NA_real_,
    aic = NA_real_,
    logLik = NA_real_,
    spatial_param = NA_character_,
    spatial_value = NA_real_,
    moran_i = NA_real_,
    moran_p_value = NA_real_,
    moran_error = NA_character_,
    fit_error = conditionMessage(error),
    stringsAsFactors = FALSE
  )
}

normalize_diagnostic_row_for_benchmark <- function(row, estimator) {
  # Ajoute les colonnes propres au benchmark automatique.
  row$estimator <- estimator
  row$fit_error <- NA_character_
  row
}

predict_vector_for_benchmark <- function(fit, new_data) {
  # Normalise les sorties predict(): workflow renvoie .pred, certains backends
  # renvoient directement un vecteur numerique.
  pred <- stats::predict(fit, new_data = new_data)
  if (is.data.frame(pred) && ".pred" %in% names(pred)) return(pred$.pred)
  as.numeric(pred)
}

score_benchmark_fold <- function(estimator, fold_id, split, formula, coords, params) {
  # Ajuste sur analysis(split), predit sur assessment(split), puis calcule les
  # metriques hors-echantillon. Les erreurs restent dans une ligne de resultat.
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  fit <- tryCatch(
    fit_one_benchmark_estimator(
      estimator = estimator, formula = formula, data = train, coords = coords,
      k_neighbors = params$k_neighbors, style = params$style,
      zero_policy = params$zero_policy,
      spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
      mgwrsar_bandwidth = params$mgwrsar_bandwidth,
      mgwrsar_kernel = params$mgwrsar_kernel
    ),
    error = function(e) e
  )
  if (inherits(fit, "error")) {
    return(data.frame(
      estimator = estimator,
      id = fold_id,
      n_train = nrow(train),
      n_test = nrow(test),
      response = deparse(formula[[2]]),
      rmse = NA_real_,
      mae = NA_real_,
      moran_i = NA_real_,
      moran_p_value = NA_real_,
      moran_error = NA_character_,
      fit_error = conditionMessage(fit),
      stringsAsFactors = FALSE
    ))
  }
  diag <- tryCatch(
    diagnose_spatial(
      fit,
      data = test,
      coords = coords,
      formula = formula,
      k_neighbors = params$k_neighbors,
      style = params$style,
      zero_policy = params$zero_policy,
      include_baseline = FALSE
    ),
    error = function(e) e
  )
  if (inherits(diag, "error")) {
    return(data.frame(
      estimator = estimator,
      id = fold_id,
      n_train = nrow(train),
      n_test = nrow(test),
      response = deparse(formula[[2]]),
      rmse = NA_real_,
      mae = NA_real_,
      moran_i = NA_real_,
      moran_p_value = NA_real_,
      moran_error = NA_character_,
      fit_error = conditionMessage(diag),
      stringsAsFactors = FALSE
    ))
  }
  metric_error <- if (!is.finite(diag$rmse[[1]]) || !is.finite(diag$mae[[1]])) {
    "Prediction metrics are not finite for this resample."
  } else {
    NA_character_
  }
  data.frame(
    estimator = estimator,
    id = fold_id,
    n_train = nrow(train),
    n_test = nrow(test),
    response = diag$response[[1]],
    rmse = diag$rmse[[1]],
    mae = diag$mae[[1]],
    moran_i = diag$moran_i[[1]],
    moran_p_value = diag$moran_p_value[[1]],
    moran_error = diag$moran_error[[1]],
    fit_error = metric_error,
    stringsAsFactors = FALSE
  )
}

evaluate_benchmark_resamples <- function(estimators, formula, data, coords,
                                         eval_resamples, base_params, tuning) {
  # Boucle explicite fold x estimateur pour obtenir une table comparable au
  # benchmark manuel, avec une ligne par fold.
  rows <- list()
  for (estimator in estimators) {
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    for (i in seq_len(nrow(eval_resamples))) {
      fold_id <- if ("id" %in% names(eval_resamples)) {
        as.character(eval_resamples$id[[i]])
      } else {
        paste0("Fold", i)
      }
      key <- paste(estimator, fold_id, sep = "__")
      rows[[key]] <- score_benchmark_fold(
        estimator = estimator,
        fold_id = fold_id,
        split = eval_resamples$splits[[i]],
        formula = formula,
        coords = coords,
        params = params
      )
    }
  }
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}

summarize_resample_results <- function(resample_results, formula, cv_scheme) {
  # Agrege les lignes fold par fold en une table principale par estimateur.
  pieces <- lapply(split(resample_results, resample_results$estimator), function(rows) {
    ok <- is.na(rows$fit_error) & is.finite(rows$rmse) & is.finite(rows$mae)
    data.frame(
      estimator = rows$estimator[[1]],
      n = sum(rows$n_test[ok]),
      response = deparse(formula[[2]]),
      rmse = if (any(ok)) mean(rows$rmse[ok]) else NA_real_,
      mae = if (any(ok)) mean(rows$mae[ok]) else NA_real_,
      rmse_sd = if (sum(ok) > 1L) stats::sd(rows$rmse[ok]) else NA_real_,
      mae_sd = if (sum(ok) > 1L) stats::sd(rows$mae[ok]) else NA_real_,
      aic = NA_real_,
      logLik = NA_real_,
      spatial_param = NA_character_,
      spatial_value = NA_real_,
      moran_i = if (any(ok)) mean(rows$moran_i[ok], na.rm = TRUE) else NA_real_,
      moran_p_value = if (any(ok)) mean(rows$moran_p_value[ok], na.rm = TRUE) else NA_real_,
      moran_error = paste(unique(stats::na.omit(rows$moran_error)), collapse = " | "),
      cv_scheme = cv_scheme,
      n_resamples = nrow(rows),
      n_failed_resamples = sum(!is.na(rows$fit_error)),
      fit_error = if (all(ok)) NA_character_ else paste(unique(stats::na.omit(rows$fit_error)), collapse = " | "),
      stringsAsFactors = FALSE
    )
  })
  out <- do.call(rbind, pieces)
  out <- out[match(unique(resample_results$estimator), out$estimator), , drop = FALSE]
  out$moran_i[is.nan(out$moran_i)] <- NA_real_
  out$moran_p_value[is.nan(out$moran_p_value)] <- NA_real_
  out$moran_error[out$moran_error == ""] <- NA_character_
  out$fit_error[out$fit_error == ""] <- NA_character_
  row.names(out) <- NULL
  out
}

fit_final_benchmark_estimators <- function(estimators, formula, data, coords,
                                           base_params, tuning) {
  # Ajuste les modeles finaux sur toutes les donnees pour inspection ulterieure
  # dans bench$fits. L'evaluation CV reste stockee separement.
  fits <- list()
  for (estimator in estimators) {
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    fit <- tryCatch(
      fit_one_benchmark_estimator(
        estimator = estimator, formula = formula, data = data, coords = coords,
        k_neighbors = params$k_neighbors, style = params$style,
        zero_policy = params$zero_policy,
        spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
        mgwrsar_bandwidth = params$mgwrsar_bandwidth,
        mgwrsar_kernel = params$mgwrsar_kernel
      ),
      error = function(e) e
    )
    if (!inherits(fit, "error")) fits[[estimator]] <- fit
  }
  fits
}

validate_benchmark_estimators <- function(estimators, registry) {
  # Messages d'erreur orientes utilisateur: on indique quoi lister ensuite.
  unknown <- setdiff(estimators, registry$estimator)
  if (length(unknown) > 0L) {
    stop(
      sprintf(
        "Estimateur(s) inconnu(s): %s. Utilisez available_benchmark_estimators() pour voir les noms valides.",
        paste(unknown, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  selected <- registry[match(estimators, registry$estimator), , drop = FALSE]
  not_automatic <- selected$estimator[!selected$automatic]
  if (length(not_automatic) > 0L) {
    stop(
      sprintf(
        "Estimateur(s) connu(s) mais pas encore automatises dans benchmark_spatial(): %s. Consultez available_benchmark_estimators()$status.",
        paste(not_automatic, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  missing_packages <- unique(selected$package[!vapply(selected$package, package_available, logical(1))])
  if (length(missing_packages) > 0L) {
    stop(
      sprintf(
        "Package(s) R manquant(s) pour ces estimateurs: %s.",
        paste(missing_packages, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  invisible(selected)
}

#' Run an automatic spatial benchmark
#'
#' Fits the requested estimators on one dataset and returns comparable
#' diagnostics. By default, results are in-sample diagnostics. Use `cv_scheme`
#' to evaluate out-of-sample performance with a holdout, near-prediction folds,
#' spatial blocks, classic v-fold cross-validation, or custom rsample objects.
#'
#' @param formula Common model formula.
#' @param data Data frame.
#' @param coords Coordinate column names.
#' @param estimators Estimators to run.
#' @param k_neighbors Number of nearest neighbours used to build kNN weights.
#' @param style Row-standardization style passed to `spdep::nb2listw()`.
#' @param zero_policy Zero-neighbour policy passed to `spdep`.
#' @param spboost_mstop Number of boosting iterations for `spboost`.
#' @param spboost_nu Learning rate for `spboost`.
#' @param mgwrsar_bandwidth Spatial bandwidth `H` for `mgwrsar` variants.
#' @param mgwrsar_kernel Spatial kernel for `mgwrsar` variants.
#' @param tune If `TRUE`, run `tune::tune_grid()` before the final fit for
#'   estimators with a supported tuning route.
#' @param resamples `rsample` object used for tuning. If `NULL` and
#'   `tune = TRUE`, a classic `vfold_cv()` is created.
#' @param tuning_grids Optional named list of tuning grids, one per estimator.
#' @param tuning_folds Number of folds for the default tuning `vfold_cv()`.
#' @param cv_scheme Evaluation scheme. `"in_sample"` keeps the diagnostic on
#'   the full data; `"holdout_10pct"`, `"near_prediction"`, `"block_spatial"`
#'   and `"vfold_cv"` score models out-of-sample; `"custom"` uses
#'   `eval_resamples`.
#' @param eval_resamples Custom `rsample` object for out-of-sample evaluation.
#' @param eval_folds Number of folds for `cv_scheme = "vfold_cv"`.
#' @param holdout_prop Proportion kept in the training set for
#'   `cv_scheme = "holdout_10pct"`.
#' @param near_n_reps Number of near-prediction repetitions.
#' @param near_test_size Target number of near-prediction test cells.
#' @param block_folds Number of spatial block folds.
#' @param seed Random seed used for resampling.
#'
#' @return A `spatial_benchmark` object with `results`, `resample_results`, and
#'   final `fits`.
#' @export
benchmark_spatial <- function(formula, data, coords,
                              estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                              k_neighbors = 8, style = "W", zero_policy = TRUE,
                              spboost_mstop = 100L, spboost_nu = 0.1,
                              mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq",
                              tune = FALSE, resamples = NULL, tuning_grids = NULL,
                              tuning_folds = 3L,
                              cv_scheme = c(
                                "in_sample", "holdout_10pct", "near_prediction",
                                "block_spatial", "vfold_cv", "custom"
                              ),
                              eval_resamples = NULL, eval_folds = 5L,
                              holdout_prop = 0.9,
                              near_n_reps = 3L, near_test_size = NULL,
                              block_folds = 5L, seed = 123L) {
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  cv_scheme <- match.arg(cv_scheme)
  registry <- spatial_benchmark_registry()
  validate_benchmark_estimators(estimators, registry)

  base_params <- list(
    k_neighbors = k_neighbors,
    style = style,
    zero_policy = zero_policy,
    spboost_mstop = spboost_mstop,
    spboost_nu = spboost_nu,
    mgwrsar_bandwidth = mgwrsar_bandwidth,
    mgwrsar_kernel = mgwrsar_kernel
  )
  tuning <- list()
  if (isTRUE(tune)) {
    if (is.null(resamples)) resamples <- make_default_resamples(data, tuning_folds = tuning_folds)
    for (estimator in estimators) {
      tuned <- tune_one_benchmark_estimator(
        estimator = estimator,
        formula = formula,
        data = data,
        coords = coords,
        resamples = resamples,
        tuning_grids = tuning_grids,
        k_neighbors = k_neighbors,
        style = style,
        zero_policy = zero_policy,
        spboost_nu = spboost_nu
      )
      if (!is.null(tuned)) tuning[[estimator]] <- tuned
    }
  }

  eval_resamples <- make_evaluation_resamples(
    data = data,
    coords = coords,
    cv_scheme = cv_scheme,
    eval_resamples = eval_resamples,
    eval_folds = eval_folds,
    holdout_prop = holdout_prop,
    near_n_reps = near_n_reps,
    near_test_size = near_test_size,
    block_folds = block_folds,
    seed = seed
  )

  fits <- list()
  rows <- list()
  resample_results <- NULL
  if (!is.null(eval_resamples)) {
    resample_results <- evaluate_benchmark_resamples(
      estimators = estimators,
      formula = formula,
      data = data,
      coords = coords,
      eval_resamples = eval_resamples,
      base_params = base_params,
      tuning = tuning
    )
    results <- summarize_resample_results(resample_results, formula = formula, cv_scheme = cv_scheme)
    fits <- fit_final_benchmark_estimators(estimators, formula, data, coords, base_params, tuning)
  } else {
    for (estimator in estimators) {
      params <- apply_tuned_params(base_params, tuning[[estimator]])
      fit <- tryCatch(
        fit_one_benchmark_estimator(
          estimator = estimator, formula = formula, data = data, coords = coords,
          k_neighbors = params$k_neighbors, style = params$style, zero_policy = params$zero_policy,
          spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
          mgwrsar_bandwidth = params$mgwrsar_bandwidth, mgwrsar_kernel = params$mgwrsar_kernel
        ),
        error = function(e) e
      )
      if (inherits(fit, "error")) {
        rows[[estimator]] <- failed_benchmark_row(estimator, data, formula, fit)
        next
      }
      fits[[estimator]] <- fit
      diag <- diagnose_spatial(
        fit,
        data = data,
        coords = coords,
        formula = formula,
        k_neighbors = k_neighbors,
        style = style,
        zero_policy = zero_policy,
        include_baseline = FALSE
      )
      rows[[estimator]] <- normalize_diagnostic_row_for_benchmark(diag[1, , drop = FALSE], estimator)
    }

    results <- do.call(rbind, rows)
    row.names(results) <- NULL
  }

  structure(
    list(
      results = results,
      resample_results = resample_results,
      fits = fits,
      formula = formula,
      coords = coords,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      estimators = estimators,
      tune = tune,
      tuning = tuning,
      tuning_grids = tuning_grids,
      resamples = if (isTRUE(tune)) resamples else NULL,
      cv_scheme = cv_scheme,
      eval_resamples = eval_resamples,
      eval_folds = eval_folds,
      holdout_prop = holdout_prop,
      near_n_reps = near_n_reps,
      near_test_size = near_test_size,
      block_folds = block_folds,
      seed = seed,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel
    ),
    class = "spatial_benchmark"
  )
}

benchmark_print_columns <- function(results) {
  # Colonnes utiles a l'affichage console; l'objet complet garde toutes les
  # colonnes dans $results.
  cols <- c("dataset", "estimator", "n", "response", "rmse", "mae",
            "aic", "spatial_param", "spatial_value", "moran_p_value", "fit_error")
  cols[cols %in% names(results)]
}

#' @export
print.spatial_benchmark <- function(x, ...) {
  cat("Benchmark spatial\n")
  cat("Formule: ", deparse(x$formula), "\n", sep = "")
  cat("Coordonnees: ", paste(x$coords, collapse = ", "), "\n", sep = "")
  cat("Estimateurs demandes: ", paste(x$estimators, collapse = ", "), "\n", sep = "")
  cat("Evaluation: ", x$cv_scheme %||% "in_sample", "\n", sep = "")
  if (isTRUE(x$tune)) {
    tuned <- names(x$tuning)
    if (length(tuned) > 0L) {
      cat("Tuning: ", paste(tuned, collapse = ", "), "\n", sep = "")
    } else {
      cat("Tuning: aucun estimateur supporte dans cette liste\n")
    }
  }
  if (length(x$fits) > 0L) {
    cat("Fits reussis: ", paste(names(x$fits), collapse = ", "), "\n", sep = "")
  } else {
    cat("Fits reussis: aucun\n")
  }
  failed <- x$results$estimator[!is.na(x$results$fit_error)]
  if (length(failed) > 0L) {
    cat("Fits echoues: ", paste(failed, collapse = ", "), "\n", sep = "")
  }
  cat("\nResultats:\n")
  print(x$results[, benchmark_print_columns(x$results), drop = FALSE], row.names = FALSE)
  invisible(x)
}

#' Define a dataset for `benchmark_spatial_datasets()`
#'
#' @param name Short dataset name.
#' @param data Data frame.
#' @param formula Model formula.
#' @param coords Coordinate column names.
#'
#' @return A `spatial_dataset_spec` object.
#' @export
spatial_dataset_spec <- function(name, data, formula, coords) {
  # Petit conteneur explicite pour benchmarker plusieurs jeux sans imposer un
  # registre interne rigide au package.
  structure(
    list(name = name, data = data, formula = formula, coords = coords),
    class = "spatial_dataset_spec"
  )
}

normalize_dataset_specs <- function(datasets) {
  # Accepte soit une spec unique, soit une liste de specs. Les noms manquants
  # sont pris depuis chaque spec.
  if (inherits(datasets, "spatial_dataset_spec")) datasets <- list(datasets)
  if (!is.list(datasets) || length(datasets) == 0L) {
    stop("datasets doit etre une spatial_dataset_spec ou une liste de specs.", call. = FALSE)
  }
  datasets
}

#' Run spatial benchmarks on several datasets
#'
#' @param datasets A `spatial_dataset_spec` object, or a list of specs.
#' @inheritParams benchmark_spatial
#'
#' @return A `spatial_benchmark_set` object with combined `results` and the
#'   individual `benchmarks`.
#' @export
benchmark_spatial_datasets <- function(datasets,
                                       estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                                       k_neighbors = 8, style = "W", zero_policy = TRUE,
                                       spboost_mstop = 100L, spboost_nu = 0.1,
                                       mgwrsar_bandwidth = 20, mgwrsar_kernel = "bisq",
                                       tune = FALSE, resamples = NULL, tuning_grids = NULL,
                                       tuning_folds = 3L,
                                       cv_scheme = c(
                                         "in_sample", "holdout_10pct", "near_prediction",
                                         "block_spatial", "vfold_cv", "custom"
                                       ),
                                       eval_resamples = NULL, eval_folds = 5L,
                                       holdout_prop = 0.9,
                                       near_n_reps = 3L, near_test_size = NULL,
                                       block_folds = 5L, seed = 123L) {
  datasets <- normalize_dataset_specs(datasets)
  cv_scheme <- match.arg(cv_scheme)
  benchmarks <- list()
  rows <- list()

  for (spec in datasets) {
    if (!inherits(spec, "spatial_dataset_spec")) {
      stop("Chaque entree de datasets doit etre creee avec spatial_dataset_spec().", call. = FALSE)
    }
    bench <- benchmark_spatial(
      formula = spec$formula,
      data = spec$data,
      coords = spec$coords,
      estimators = estimators,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel,
      tune = tune,
      resamples = if (is.null(resamples)) NULL else resamples[[spec$name]],
      tuning_grids = tuning_grids,
      tuning_folds = tuning_folds,
      cv_scheme = cv_scheme,
      eval_resamples = if (is.null(eval_resamples)) NULL else eval_resamples[[spec$name]],
      eval_folds = eval_folds,
      holdout_prop = holdout_prop,
      near_n_reps = near_n_reps,
      near_test_size = near_test_size,
      block_folds = block_folds,
      seed = seed
    )
    benchmarks[[spec$name]] <- bench
    out <- bench$results
    out$dataset <- spec$name
    rows[[spec$name]] <- out[, c("dataset", setdiff(names(out), "dataset")), drop = FALSE]
  }

  results <- do.call(rbind, rows)
  row.names(results) <- NULL
  structure(
    list(results = results, benchmarks = benchmarks),
    class = "spatial_benchmark_set"
  )
}

#' @export
print.spatial_benchmark_set <- function(x, ...) {
  datasets <- names(x$benchmarks)
  cat("Benchmark spatial multi-dataset\n")
  cat("Datasets: ", paste(datasets, collapse = ", "), "\n", sep = "")
  cat("Nombre de lignes resultat: ", nrow(x$results), "\n", sep = "")
  failed <- x$results$estimator[!is.na(x$results$fit_error)]
  if (length(failed) > 0L) {
    cat("Fits echoues: ", paste(unique(failed), collapse = ", "), "\n", sep = "")
  }
  cat("\nResultats:\n")
  print(x$results[, benchmark_print_columns(x$results), drop = FALSE], row.names = FALSE)
  invisible(x)
}
