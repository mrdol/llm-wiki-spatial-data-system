# Benchmark automatique pour un ensemble d'estimateurs spatiaux.
#
# Cette couche est differente des raccourcis fit_sar()/fit_sem()/fit_sdm():
# elle orchestre plusieurs estimateurs, collecte les diagnostics communs et
# retourne une table comparable. Les raccourcis restent utiles pour inspecter
# un estimateur pas a pas.

fallback_spatial_benchmark_registry <- function() {
  # Registre utilisateur des estimateurs. Une ligne = une route benchmark,
  # pour eviter les erreurs de longueur entre vecteurs paralleles.
  row <- function(estimator, package, backend, requires_coords, requires_W,
                  spatial_args, tunable_parameters, notes,
                  automatic = TRUE, mode = "regression") {
    data.frame(
      estimator = estimator,
      status = ifelse(automatic, "automatic", "known_not_automated"),
      mode = mode,
      package = package,
      backend = backend,
      automatic = automatic,
      requires_coords = requires_coords,
      requires_W = requires_W,
      spatial_args = spatial_args,
      tunable_parameters = tunable_parameters,
      notes = notes,
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, list(
    row("ols", "stats", "stats::glm", FALSE, FALSE, "", "", "Baseline lineaire."),
    row("gam_spatial", "mgcv", "mgcv::gam", TRUE, FALSE, "coords", "", "Baseline GAM avec lisseur spatial s(x, y)."),
    row("gamboost", "mboost", "mboost::gamboost", FALSE, FALSE, "", "mstop", "Baseline GAMBoost gradient-based via mboost::gamboost()."),
    row("earth", "earth", "earth::earth", FALSE, FALSE, "", "", "Baseline MARS native tidymodels sur X seules."),
    row("earth_xy", "earth", "earth::earth", TRUE, FALSE, "coords_as_covariates", "", "Baseline MARS native tidymodels sur X et coordonnees brutes."),
    row("random_forest", "ranger", "ranger::ranger", FALSE, FALSE, "", "", "Baseline random forest native tidymodels sur X seules."),
    row("random_forest_xy", "ranger", "ranger::ranger", TRUE, FALSE, "coords_as_covariates", "", "Baseline random forest native tidymodels sur X et coordonnees brutes."),
    row("xgboost", "xgboost", "xgboost::xgb.train", FALSE, FALSE, "", "", "Baseline XGBoost native tidymodels sur X seules."),
    row("xgboost_xy", "xgboost", "xgboost::xgb.train", TRUE, FALSE, "coords_as_covariates", "", "Baseline XGBoost native tidymodels sur X et coordonnees brutes."),
    row("spatialml_grf", "SpatialML", "SpatialML::grf", TRUE, FALSE, "coords/bandwidth/kernel", "bandwidth, ntree, mtry", "Geographical Random Forest: une foret locale par observation; kernel adaptive, bandwidth = voisins."),
    row("spatialrf", "spatialRF", "spatialRF::rf_spatial", TRUE, FALSE, "coords/distance_matrix/MEM", "method, ntree, mtry, max_spatial_predictors", "Spatial Random Forest avec predicteurs spatiaux/MEM pour reduire l'autocorrelation residuelle."),
    row("rfgls", "RandomForestsGLS", "RandomForestsGLS::RFGLS_estimate_spatial", TRUE, FALSE, "coords/covariance/n_neighbors", "ntree, mtry, k_neighbors, nthsize, cov_model", "Random Forest GLS pour donnees spatialement dependantes via approximation NNGP/Vecchia."),
    row("sar_lag", "spatialreg", "spatialreg::lagsarlm", TRUE, FALSE, "coords/W/k_neighbors/style/zero_policy", "k_neighbors", "SAR lag via fit_sar()."),
    row("sem_error", "spatialreg", "spatialreg::errorsarlm", TRUE, FALSE, "coords/W/k_neighbors/style/zero_policy", "k_neighbors", "SEM error via fit_sem()."),
    row("sdm_mixed", "spatialreg", "spatialreg::lagsarlm(Durbin)", TRUE, FALSE, "coords/W/k_neighbors/style/zero_policy", "k_neighbors", "SDM mixed via fit_sdm()."),
    row("sar_probit", "ProbitSpatial", "ProbitSpatial::ProbitSpatialFit(DGP=SAR)", TRUE, FALSE, "coords/W/k_neighbors/style/zero_policy", "k_neighbors", "Probit spatial SAR (Martinetti & Geniaux, 2017) via sar_probit_reg(); reponse binaire uniquement.", mode = "classification"),
    row("sem_probit", "ProbitSpatial", "ProbitSpatial::ProbitSpatialFit(DGP=SEM)", TRUE, FALSE, "coords/W/k_neighbors/style/zero_policy", "k_neighbors", "Probit spatial SEM (Martinetti & Geniaux, 2017) via sem_probit_reg(); reponse binaire uniquement.", mode = "classification"),
    row("spboost", "spboost", "spboost::spbgam(BSPA_SAR_ML)", TRUE, FALSE, "coords/k_neighbors", "mstop, k_neighbors", "Alias historique: SpBoost BSPA SAR avec ML pour rho; nu reste fixe."),
    row("spboost_bspa_sar_ml", "spboost", "spboost::spbgam(BSPA_SAR_ML)", TRUE, FALSE, "coords/k_neighbors", "mstop, k_neighbors", "BSPA SAR; ML estime le parametre spatial rho; nu reste fixe."),
    row("spboost_bspa_sar_cfe", "spboost", "spboost::spbgam(BSPA_SAR_CFE)", TRUE, FALSE, "coords/k_neighbors", "mstop, k_neighbors", "BSPA SAR; CFE estime le parametre spatial rho; nu reste fixe."),
    row("spboost_bspa_sem_ml", "spboost", "spboost::spbgam(BSPA_SEM_ML)", TRUE, FALSE, "coords/k_neighbors", "mstop, k_neighbors", "BSPA SEM; ML estime le parametre spatial lambda; nu reste fixe."),
    row("spboost_bspa_sem_cfe", "spboost", "spboost::spbgam(BSPA_SEM_CFE)", TRUE, FALSE, "coords/k_neighbors", "mstop, k_neighbors", "BSPA SEM; CFE estime le parametre spatial lambda; nu reste fixe."),
    row("mgwrsar_gwr", "mgwrsar", "mgwrsar::MGWRSAR(GWR)", TRUE, FALSE, "coords/bandwidth/kernel", "bandwidth", "GWR local via mgwrsar_reg(Model='GWR'); benchmark kernel fixed to gauss."),
    row("mgwrsar_sar", "mgwrsar", "mgwrsar::MGWRSAR(SAR)", TRUE, TRUE, "coords/W", "", "SAR global via mgwrsar_reg(Model='SAR')."),
    row("mgwrsar_mgwr", "mgwrsar", "mgwrsar::TDS_MGWR", TRUE, TRUE, "coords", "", "MGWR multiscale via mgwrsar_reg(Model='tds_mgwr')."),
    row("mgwrsar_mgwrsar", "mgwrsar", "mgwrsar::MGWRSAR(MGWRSAR_1_0_kv)", TRUE, TRUE, "coords/W/bandwidth/kernel", "bandwidth", "MGWRSAR autocorrele via mgwrsar_reg(Model='MGWRSAR_1_0_kv'); benchmark kernel fixed to gauss."),
    row("MGWRSAR_0_kc_kv", "mgwrsar", "mgwrsar::MGWRSAR(MGWRSAR_0_kc_kv)", TRUE, TRUE, "coords/W/bandwidth/kernel/fixed_vars", "bandwidth, k_neighbors, fixed_vars", "MGWRSAR mixte: lambda constant, coefficients fixes et locaux; W_opt par CV; benchmark kernel fixed to gauss."),
    row("MGWRSAR_1_kc_kv", "mgwrsar", "mgwrsar::MGWRSAR(MGWRSAR_1_kc_kv)", TRUE, TRUE, "coords/W/bandwidth/kernel/fixed_vars", "bandwidth, k_neighbors, fixed_vars", "MGWRSAR mixte: lambda local, coefficients fixes et locaux; W_opt par CV; benchmark kernel fixed to gauss."),
    row("spmoran_esf", "spmoran", "spmoran::esf", TRUE, FALSE, "coords", "enum, vif", "Eigenvector spatial filtering via spmoran::esf()."),
    row("spmoran_resf", "spmoran", "spmoran::resf", TRUE, FALSE, "coords", "enum", "Random-effects eigenvector spatial filtering via spmoran::resf().")
  ))
}

spatial_benchmark_registry <- function() {
  metadata <- metadata_estimator_registry()
  out <- if (!is.null(metadata)) metadata else fallback_spatial_benchmark_registry()
  if (!"test_datasets" %in% names(out)) {
    out$test_datasets <- I(rep(list(character()), nrow(out)))
  }
  for (field in c("family", "role", "reference_estimator", "variant_family", "dashboard_group")) {
    if (!field %in% names(out)) out[[field]] <- NA_character_
  }
  custom <- registered_spatial_estimators()
  if (nrow(custom) > 0L) {
    custom$test_datasets <- I(rep(list(character()), nrow(custom)))
    common_cols <- intersect(names(out), names(custom))
    out <- rbind(out[, common_cols, drop = FALSE], custom[, common_cols, drop = FALSE])
  }
  out
}

package_available <- function(package) {
  # stats est fourni par R; les autres packages sont verifies sans les attacher.
  # NA/vide: estimateur enregistre par l'utilisateur sans dependance externe a
  # verifier (voir register_spatial_estimator()).
  if (identical(package, "stats")) return(TRUE)
  if (is.na(package) || !nzchar(package)) return(TRUE)
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

xgboost_benchmark_spec <- function(response_typology = "continuous") {
  # xgboost supporte nativement mode="classification" (binaire) et un
  # objectif Poisson en mode regression (objective="count:poisson", passe en
  # argument moteur) -- contrairement a ranger, pas besoin d'approximation
  # continue pour le comptage.
  if (identical(response_typology, "binary")) {
    return(parsnip::boost_tree(mode = "classification", trees = 100L) |> parsnip::set_engine("xgboost"))
  }
  if (identical(response_typology, "count")) {
    return(parsnip::boost_tree(mode = "regression", trees = 100L) |>
             parsnip::set_engine("xgboost", objective = "count:poisson"))
  }
  parsnip::boost_tree(mode = "regression", trees = 100L) |> parsnip::set_engine("xgboost")
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

ensure_mboost_attached <- function() {
  # mboost::gamboost() evalue certains termes comme bbs()/bols() par nom dans
  # l'environnement de formule. requireNamespace() ne suffit donc pas dans un
  # package installe; il faut attacher mboost au search path.
  if (!"package:mboost" %in% search()) {
    suppressPackageStartupMessages(
      base::library("mboost", character.only = TRUE)
    )
  }
  invisible(TRUE)
}

spboost_benchmark_spec <- function(estimator, coords, mstop, nu, k_neighbors) {
  # Route commune pour les variantes BSPA. ML et CFE ne changent que la facon
  # d'estimer le parametre spatial (rho/lambda), pas la famille SAR/SEM.
  dgp <- switch(estimator,
    spboost = "SAR",
    spboost_bspa_sar_ml = "SAR",
    spboost_bspa_sar_cfe = "SAR",
    spboost_bspa_sem_ml = "SEM",
    spboost_bspa_sem_cfe = "SEM"
  )
  method <- switch(estimator,
    spboost = "BSPA_SAR_ML",
    spboost_bspa_sar_ml = "BSPA_SAR_ML",
    spboost_bspa_sar_cfe = "BSPA_SAR_CFE",
    spboost_bspa_sem_ml = "BSPA_SEM_ML",
    spboost_bspa_sem_cfe = "BSPA_SEM_CFE"
  )
  parsnip::new_model_spec(
    "spboost_reg",
    args = list(
      coords = rlang::enquo(coords),
      DGP = rlang::quo(!!dgp),
      method = rlang::quo(!!method),
      mstop = rlang::enquo(mstop),
      nu = rlang::enquo(nu),
      k_neighbors = rlang::enquo(k_neighbors)
    ),
    eng_args = NULL,
    mode = "regression",
    method = NULL,
    engine = NULL
  ) |>
    parsnip::set_engine("spboost") |>
    parsnip::set_mode("regression")
}

fit_one_benchmark_estimator <- function(estimator, formula, data, coords,
                                        k_neighbors = 8, style = "W",
                                        zero_policy = TRUE,
                                        W = NULL,
                                        spboost_mstop = 100L,
                                        spboost_nu = 0.1,
                                        gamboost_mstop = 100L,
                                        gamboost_nu = 0.1,
                                        mgwrsar_bandwidth = 20,
                                        mgwrsar_kernel = "gauss",
                                        mgwrsar_fixed_vars = NULL,
                                        spmoran_enum = NULL,
                                        spmoran_vif = 10,
                                        spatialml_bandwidth = 20L,
                                        spatialml_ntree = 100L,
                                        spatialml_mtry = NULL,
                                        spatialrf_ntree = 100L,
                                        spatialrf_method = "hengl",
                                        spatialrf_mtry = NULL,
                                        spatialrf_min_node_size = NULL,
                                        spatialrf_max_spatial_predictors = NULL,
                                        rfgls_ntree = 50L,
                                        rfgls_mtry = NULL,
                                        rfgls_n_neighbors = NULL,
                                        rfgls_nthsize = 20L,
                                        rfgls_cov_model = "exponential",
                                        rfgls_param_estimate = FALSE,
                                        mgwrsar_control = list(),
                                        response_typology = "continuous") {
  # Ajuste un estimateur connu. Les erreurs sont laissees au niveau appelant
  # pour produire une ligne de benchmark explicite plutot qu'un plantage global.
  #
  # response_typology == "binary": coercion en facteur a 2 niveaux c(0,1) ICI,
  # une seule fois, pour que TOUS les chemins binaires en aval (ols/gam_spatial
  # via glm/gam qui acceptent facteur ou 0/1 nu, ET random_forest/xgboost/
  # sar_probit/sem_probit via parsnip mode="classification" qui EXIGENT un
  # facteur -- confirme empiriquement, parsnip::check_outcome() rejette un
  # 0/1 numerique avec une erreur explicite) recoivent une entree coherente
  # sans dupliquer cette logique dans chaque branche.
  glm_family <- switch(response_typology,
    binary = stats::binomial(),
    count = stats::poisson(),
    stats::gaussian()
  )
  if (identical(response_typology, "binary")) {
    y_name <- all.vars(formula)[1]
    if (!is.factor(data[[y_name]])) {
      data[[y_name]] <- factor(data[[y_name]], levels = c(0, 1))
    }
  }
  switch(estimator,
    ols = stats::glm(formula, data = data, family = glm_family),
    gam_spatial = {
      require_package("mgcv", "benchmark GAM spatial")
      mgcv::gam(add_spatial_smooth_to_formula(formula, coords, data), data = data, family = glm_family)
    },
    gamboost = {
      require_package("mboost", "benchmark GAMBoost")
      ensure_mboost_attached()
      boosting_formula <- spb_build_boosting_formula(formula, data)
      mboost::gamboost(
        formula = boosting_formula,
        data = data,
        control = mboost::boost_control(mstop = gamboost_mstop, nu = gamboost_nu)
      )
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
      # Pas de mode Poisson natif dans ranger/parsnip pour le comptage: reste
      # en mode regression (approximation, deja pratiquee sur les jeux
      # `count` cures du projet, ex. paper_chaco_bird_richness).
      rf_mode <- if (identical(response_typology, "binary")) "classification" else "regression"
      fit_parsnip_baseline(
        parsnip::rand_forest(mode = rf_mode, trees = 100L) |> parsnip::set_engine("ranger"),
        formula, data
      )
    },
    random_forest_xy = {
      require_package("ranger", "benchmark random forest avec coordonnees")
      rf_mode <- if (identical(response_typology, "binary")) "classification" else "regression"
      fit_parsnip_baseline(
        parsnip::rand_forest(mode = rf_mode, trees = 100L) |> parsnip::set_engine("ranger"),
        add_coords_to_baseline_formula(formula, coords, data), data
      )
    },
    xgboost = {
      require_package("xgboost", "benchmark XGBoost")
      fit_parsnip_baseline(
        xgboost_benchmark_spec(response_typology),
        formula, data
      )
    },
    xgboost_xy = {
      require_package("xgboost", "benchmark XGBoost avec coordonnees")
      fit_parsnip_baseline(
        xgboost_benchmark_spec(response_typology),
        add_coords_to_baseline_formula(formula, coords, data), data
      )
    },
    spatialml_grf = fit_spatialml_grf_impl(
      formula = formula,
      data = data,
      coords = coords,
      bandwidth = spatialml_bandwidth,
      kernel = "adaptive",
      ntree = spatialml_ntree,
      mtry = spatialml_mtry
    ),
    spatialrf = fit_spatialrf_impl(
      formula = formula,
      data = data,
      coords = coords,
      ntree = spatialrf_ntree,
      method = spatialrf_method,
      mtry = spatialrf_mtry,
      min_node_size = spatialrf_min_node_size,
      max_spatial_predictors = spatialrf_max_spatial_predictors,
      ncores = 1L
    ),
    rfgls = fit_rfgls_impl(
      formula = formula,
      data = data,
      coords = coords,
      ntree = rfgls_ntree,
      n_neighbors = rfgls_n_neighbors %||% k_neighbors,
      nthsize = rfgls_nthsize,
      mtry = rfgls_mtry,
      cov_model = rfgls_cov_model,
      param_estimate = rfgls_param_estimate
    ),
    sar_lag = fit_sar(
      formula, data = data, coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sem_error = fit_sem(
      formula, data = data, coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sdm_mixed = fit_sdm(
      formula, data = data, coords = coords, W = W, k_neighbors = k_neighbors,
      style = style, zero_policy = zero_policy
    ),
    sar_probit = {
      require_package("workflows", "benchmark probit spatial SAR")
      require_package("ProbitSpatial", "benchmark probit spatial SAR")
      make_benchmark_workflow(
        sar_probit_reg(coords = coords, W = W, k_neighbors = k_neighbors,
                       style = style, zero_policy = zero_policy) |>
          parsnip::set_engine("ProbitSpatial"),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    sem_probit = {
      require_package("workflows", "benchmark probit spatial SEM")
      require_package("ProbitSpatial", "benchmark probit spatial SEM")
      make_benchmark_workflow(
        sem_probit_reg(coords = coords, W = W, k_neighbors = k_neighbors,
                       style = style, zero_policy = zero_policy) |>
          parsnip::set_engine("ProbitSpatial"),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    spboost = {
      require_package("workflows", "benchmark SpBoost")
      make_benchmark_workflow(
        spboost_benchmark_spec(estimator, coords, spboost_mstop, spboost_nu, k_neighbors),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    spboost_bspa_sar_ml = {
      require_package("workflows", "benchmark SpBoost BSPA SAR ML")
      make_benchmark_workflow(
        spboost_benchmark_spec(estimator, coords, spboost_mstop, spboost_nu, k_neighbors),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    spboost_bspa_sar_cfe = {
      require_package("workflows", "benchmark SpBoost BSPA SAR CFE")
      make_benchmark_workflow(
        spboost_benchmark_spec(estimator, coords, spboost_mstop, spboost_nu, k_neighbors),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    spboost_bspa_sem_ml = {
      require_package("workflows", "benchmark SpBoost BSPA SEM ML")
      make_benchmark_workflow(
        spboost_benchmark_spec(estimator, coords, spboost_mstop, spboost_nu, k_neighbors),
        formula, coords, data
      ) |>
        workflows::fit(data = data)
    },
    spboost_bspa_sem_cfe = {
      require_package("workflows", "benchmark SpBoost BSPA SEM CFE")
      make_benchmark_workflow(
        spboost_benchmark_spec(estimator, coords, spboost_mstop, spboost_nu, k_neighbors),
        formula, coords, data
      ) |>
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
        parsnip::set_engine("mgwrsar", control = mgwrsar_control) |>
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
        parsnip::set_engine("mgwrsar", control = mgwrsar_control) |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    MGWRSAR_0_kc_kv = {
      require_package("workflows", "benchmark MGWRSAR mixte")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "MGWRSAR_0_kc_kv",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth,
        fixed_vars = mgwrsar_fixed_vars
      ) |>
        parsnip::set_engine("mgwrsar", control = mgwrsar_control) |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    MGWRSAR_1_kc_kv = {
      require_package("workflows", "benchmark MGWRSAR mixte local")
      spec <- mgwrsar_reg(
        coords = coords, model_type = "MGWRSAR_1_kc_kv",
        kernels = mgwrsar_kernel, bandwidth = mgwrsar_bandwidth,
        fixed_vars = mgwrsar_fixed_vars
      ) |>
        parsnip::set_engine("mgwrsar", control = mgwrsar_control) |>
        parsnip::set_mode("regression")
      workflows::workflow() |>
        workflows::add_formula(add_coords_to_formula(formula, coords, data)) |>
        workflows::add_model(spec) |>
        workflows::fit(data = data)
    },
    spmoran_esf = {
      require_package("workflows", "benchmark SpMoran ESF")
      spec <- spmoran_esf_reg(coords = coords, vif = spmoran_vif, enum = spmoran_enum) |>
        parsnip::set_engine("spmoran") |>
        parsnip::set_mode("regression")
      make_benchmark_workflow(spec, formula, coords, data) |>
        workflows::fit(data = data)
    },
    spmoran_resf = {
      require_package("workflows", "benchmark SpMoran RESF")
      spec <- spmoran_resf_reg(coords = coords, enum = spmoran_enum) |>
        parsnip::set_engine("spmoran") |>
        parsnip::set_mode("regression")
      make_benchmark_workflow(spec, formula, coords, data) |>
        workflows::fit(data = data)
    },
    {
      custom <- get_custom_estimator(estimator)
      if (is.null(custom)) {
        stop(sprintf("Estimateur non automatise dans benchmark_spatial(): %s", estimator), call. = FALSE)
      }
      fit_custom_spatial_estimator(custom, formula, data, coords)
    }
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
  mgwrsar_h <- unique(pmin(if (n > 1500L) c(20L) else c(20L, 40L), max(3L, n - 1L)))
  mgwrsar_kernel <- "gauss"
  mgwrsar_k <- unique(pmin(if (n > 1500L) c(8L) else c(4L, 8L, 12L), max(2L, n - 1L)))
  spmoran_enum_grid <- unique(pmin(if (n > 1500L) c(50L, 100L) else c(5L, 10L, 20L), max(2L, n - 1L)))
  p <- max(1L, ncol(data) - 3L)
  forest_mtry <- unique(pmin(p, pmax(1L, c(floor(sqrt(p)), floor(p / 3L)))))
  grf_bandwidth <- unique(pmin(max(2L, n - 1L), if (n > 1500L) 100L else c(50L, 100L)))
  rfgls_neighbors <- unique(pmin(max(2L, n - 1L), 15L))
  switch(estimator,
    sar_lag = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sem_error = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    sdm_mixed = data.frame(k_neighbors = unique(pmin(c(4L, 8L, 12L), max(2L, n - 1L)))),
    gamboost = data.frame(mstop = c(50L, 100L, 200L)),
    spboost = expand.grid(mstop = c(50L, 100L, 200L), k_neighbors = unique(pmin(c(4L, 8L), max(2L, n - 1L))), KEEP.OUT.ATTRS = FALSE),
    spboost_bspa_sar_ml = expand.grid(mstop = c(50L, 100L, 200L), k_neighbors = unique(pmin(c(4L, 8L), max(2L, n - 1L))), KEEP.OUT.ATTRS = FALSE),
    spboost_bspa_sar_cfe = expand.grid(mstop = c(50L, 100L, 200L), k_neighbors = unique(pmin(c(4L, 8L), max(2L, n - 1L))), KEEP.OUT.ATTRS = FALSE),
    spboost_bspa_sem_ml = expand.grid(mstop = c(50L, 100L, 200L), k_neighbors = unique(pmin(c(4L, 8L), max(2L, n - 1L))), KEEP.OUT.ATTRS = FALSE),
    spboost_bspa_sem_cfe = expand.grid(mstop = c(50L, 100L, 200L), k_neighbors = unique(pmin(c(4L, 8L), max(2L, n - 1L))), KEEP.OUT.ATTRS = FALSE),
    spatialml_grf = expand.grid(
      bandwidth = grf_bandwidth,
      ntree = 100L,
      mtry = forest_mtry[[1L]],
      KEEP.OUT.ATTRS = FALSE
    ),
    spatialrf = expand.grid(
      method = "hengl",
      ntree = 100L,
      mtry = forest_mtry[[1L]],
      max_spatial_predictors = if (n > 1500L) 25L else c(10L, 25L),
      KEEP.OUT.ATTRS = FALSE
    ),
    rfgls = expand.grid(
      ntree = 50L,
      mtry = forest_mtry[[1L]],
      k_neighbors = rfgls_neighbors,
      cov_model = "exponential",
      param_estimate = FALSE,
      KEEP.OUT.ATTRS = FALSE
    ),
    mgwrsar_gwr = expand.grid(
      bandwidth = mgwrsar_h,
      kernel = mgwrsar_kernel,
      KEEP.OUT.ATTRS = FALSE
    ),
    mgwrsar_mgwrsar = expand.grid(
      bandwidth = mgwrsar_h,
      kernel = mgwrsar_kernel,
      KEEP.OUT.ATTRS = FALSE
    ),
    MGWRSAR_0_kc_kv = expand.grid(
      bandwidth = mgwrsar_h,
      kernel = mgwrsar_kernel,
      k_neighbors = mgwrsar_k,
      KEEP.OUT.ATTRS = FALSE
    ),
    MGWRSAR_1_kc_kv = expand.grid(
      bandwidth = mgwrsar_h,
      kernel = mgwrsar_kernel,
      k_neighbors = mgwrsar_k,
      KEEP.OUT.ATTRS = FALSE
    ),
    spmoran_esf = expand.grid(
      enum = spmoran_enum_grid,
      vif = c(5, 10),
      KEEP.OUT.ATTRS = FALSE
    ),
    spmoran_resf = data.frame(enum = spmoran_enum_grid),
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

formula_predictor_terms <- function(formula, data, coords = NULL) {
  # Recupere les termes explicites de la formule pour construire des candidats
  # fixed_vars. On evite les coordonnees, qui sont dans le workflow seulement
  # pour les backends spatiaux et ne doivent pas devenir fixes par defaut.
  terms <- attr(stats::terms(formula, data = data), "term.labels")
  setdiff(terms, coords %||% character(0))
}

normalize_fixed_vars_value <- function(value) {
  # Les grilles utilisateur peuvent fournir fixed_vars sous forme de vecteur,
  # de liste-colonne ou de chaine "x1+x2"/"x1,x2"/"x1;x2".
  if (is.null(value) || length(value) == 0L) return(NULL)
  if (is.list(value) && length(value) == 1L) value <- value[[1]]
  if (is.null(value) || length(value) == 0L) return(NULL)
  if (is.character(value) && length(value) == 1L) {
    value <- unlist(strsplit(value, "\\s*[+,;|]\\s*"))
  }
  value <- unique(stats::na.omit(as.character(value)))
  value <- value[nzchar(value)]
  if (length(value) == 0L) NULL else value
}

default_mgwrsar_fixed_vars_candidates <- function(formula, data, coords) {
  # Heuristique prudente quand l'utilisateur ne precise pas les coefficients
  # stationnaires: on teste quelques partitions simples en gardant toujours au
  # moins une variable locale. La validation CV choisit ensuite la meilleure.
  predictors <- formula_predictor_terms(formula, data = data, coords = coords)
  if (length(predictors) < 2L) {
    stop(
      "Mixed MGWRSAR requires at least two non-coordinate predictors or an explicit `fixed_vars` grid.",
      call. = FALSE
    )
  }
  candidates <- list(
    predictors[[1L]],
    predictors[-length(predictors)]
  )
  if (length(predictors) > 2L) candidates <- c(candidates, list(predictors[seq_len(2L)]))
  unique(lapply(candidates, normalize_fixed_vars_value))
}

expand_mgwrsar_mixed_grid <- function(grid, formula, data, coords, k_neighbors = 8L) {
  # Complete une grille MGWRSAR mixte avec W_opt (k_neighbors) et les partitions
  # fixed/local. fixed_vars reste une liste-colonne pour permettre plusieurs
  # variables stationnaires dans une seule ligne.
  # Le benchmark fixe le noyau MGWRSAR a gauss pour reduire la grille et suivre
  # le protocole courant. L'argument direct mgwrsar_reg(kernel=...) reste libre.
  grid$kernel <- "gauss"
  if (!"bandwidth" %in% names(grid)) grid$bandwidth <- default_benchmark_grid("mgwrsar_mgwrsar", data)$bandwidth[[1]]
  if (!"k_neighbors" %in% names(grid)) grid$k_neighbors <- k_neighbors
  grid$bandwidth <- as.integer(grid$bandwidth)
  grid$kernel <- "gauss"
  grid$k_neighbors <- as.integer(grid$k_neighbors)

  if ("fixed_vars" %in% names(grid)) {
    fixed_candidates <- lapply(seq_len(nrow(grid)), function(i) normalize_fixed_vars_value(grid$fixed_vars[i]))
    grid$fixed_vars <- I(fixed_candidates)
    return(unique(grid[, c("bandwidth", "kernel", "k_neighbors", "fixed_vars"), drop = FALSE]))
  }

  fixed_candidates <- default_mgwrsar_fixed_vars_candidates(formula, data = data, coords = coords)
  expanded <- do.call(rbind, lapply(seq_len(nrow(grid)), function(i) {
    data.frame(
      bandwidth = grid$bandwidth[[i]],
      kernel = grid$kernel[[i]],
      k_neighbors = grid$k_neighbors[[i]],
      fixed_id = seq_along(fixed_candidates),
      stringsAsFactors = FALSE
    )
  }))
  expanded$fixed_vars <- I(rep(fixed_candidates, times = nrow(grid)))
  expanded$fixed_id <- NULL
  expanded
}

fit_tune_grid_or_error <- function(wf, resamples, grid, verbose = FALSE) {
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
      control = tune::control_grid(save_pred = FALSE, verbose = verbose)
    ),
    error = function(e) e
  )
}

benchmark_log <- function(verbose, ...) {
  # Journal console optionnel pour les runs longs. Par defaut le package reste
  # silencieux pour ne pas polluer les petits appels interactifs.
  if (isTRUE(verbose)) message(sprintf(...))
}

# Garde-fou timeout par cas (dataset x estimateur x fold) -------------------
#
# NA/Inf/<=0 (defaut) desactive completement le garde-fou -- comportement
# identique a avant son introduction, zero overhead. Objectif: transformer un
# calcul genuinement non borne pour UN cas en un fit_error "TIMEOUT" proprement
# enregistre, plutot que de geler tout le suite indefiniment -- sans presumer
# de la cause (voir extract_information_criteria() dans 12-diagnose-spatial.R
# pour un exemple de pathologie deja corrigee a la racine: ce garde-fou est
# generique et vise les futures pathologies non encore identifiees sur de gros
# datasets, pas seulement celle-la).
#
# L'application reelle du timeout (worker callr, kill du process) vit dans
# 26-fold-timeout-worker.R -- voir run_with_fold_timeout(). fold_error_row()
# ici est le format de ligne partage entre un echec normal (fit/predict/
# diagnose leve une erreur a l'interieur de score_benchmark_fold()) et un
# timeout (detecte depuis l'EXTERIEUR de score_benchmark_fold(), qui n'a donc
# pas pu construire sa propre ligne -- voir evaluate_benchmark_resamples()).
normalize_fold_timeout_sec <- function(fold_timeout_sec) {
  timeout_sec <- suppressWarnings(as.numeric(fold_timeout_sec)[1])
  if (!is.finite(timeout_sec) || timeout_sec <= 0) NA_real_ else timeout_sec
}

fold_error_row <- function(estimator, fold_id, n_train, n_test, response, message,
                           elapsed_sec = NA_real_) {
  data.frame(
    estimator = estimator,
    id = fold_id,
    n_train = n_train,
    n_test = n_test,
    response = response,
    rmse = NA_real_,
    mae = NA_real_,
    accuracy = NA_real_,
    auc = NA_real_,
    deviance = NA_real_,
    elapsed_sec = elapsed_sec,
    moran_i = NA_real_,
    moran_abs = NA_real_,
    moran_p_value = NA_real_,
    moran_error = NA_character_,
    fit_error = message,
    truth = I(list(numeric())),
    pred = I(list(numeric())),
    stringsAsFactors = FALSE
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
                                      grid, style = "W", zero_policy = TRUE,
                                      verbose = FALSE) {
  spec <- switch(estimator,
    sar_lag = sar_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sem_error = sem_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy),
    sdm_mixed = sdm_reg(coords = coords, k_neighbors = tune::tune(), style = style, zero_policy = zero_policy)
  ) |>
    parsnip::set_engine("spatialreg") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  benchmark_log(verbose, "[tuning] %s: %d candidats via tune_grid()", estimator, nrow(grid))
  tuned <- fit_tune_grid_or_error(wf, resamples, grid, verbose = verbose)
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

tune_spboost_benchmark <- function(estimator, formula, data, coords, resamples, grid,
                                  spboost_nu = 0.1, k_neighbors = 8,
                                  verbose = FALSE) {
  if (!"mstop" %in% names(grid)) grid$mstop <- 100L
  if (!"k_neighbors" %in% names(grid)) grid$k_neighbors <- k_neighbors
  grid$mstop <- as.integer(grid$mstop)
  grid$k_neighbors <- as.integer(grid$k_neighbors)
  spec <- spboost_benchmark_spec(
    estimator = estimator, coords = coords,
    mstop = tune::tune(), nu = spboost_nu, k_neighbors = tune::tune()
  )
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  benchmark_log(verbose, "[tuning] %s: %d candidats via tune_grid()", estimator, nrow(grid))
  tuned <- fit_tune_grid_or_error(wf, resamples, grid, verbose = verbose)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, c("mstop", "k_neighbors"))
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(
      spboost_mstop = as.integer(best$mstop[[1]]),
      k_neighbors = as.integer(best$k_neighbors[[1]])
    )
  )
}

tune_mgwrsar_gwr_benchmark <- function(estimator, formula, data, coords, resamples, grid,
                                       verbose = FALSE) {
  # GWR ne depend pas d'une W SAR globale train+test. On peut donc garder la
  # route workflow()/tune_grid() classique pour tuner H et le noyau.
  model_type <- switch(estimator,
    mgwrsar_gwr = "GWR"
  )
  grid$kernel <- "gauss"
  grid$bandwidth <- as.integer(grid$bandwidth)
  grid$kernel <- "gauss"
  spec <- mgwrsar_reg(
    coords = coords, model_type = model_type,
    kernel = tune::tune(), bandwidth = tune::tune()
  ) |>
    parsnip::set_engine("mgwrsar") |>
    parsnip::set_mode("regression")
  wf <- make_benchmark_workflow(spec, formula, coords, data)
  benchmark_log(verbose, "[tuning] %s: %d candidats via tune_grid()", estimator, nrow(grid))
  tuned <- fit_tune_grid_or_error(wf, resamples, grid, verbose = verbose)
  if (inherits(tuned, "error")) return(list(error = conditionMessage(tuned)))
  grid_out <- collect_benchmark_tuning(tuned, c("bandwidth", "kernel"))
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = tuned,
    params = list(
      mgwrsar_bandwidth = as.integer(best$bandwidth[[1]]),
      mgwrsar_kernel = as.character(best$kernel[[1]])
    )
  )
}

tune_gamboost_benchmark <- function(estimator, formula, coords, resamples, grid,
                                    gamboost_nu = 0.1, verbose = FALSE) {
  # GAMBoost est une baseline non spatiale hors parsnip. On tune donc mstop
  # avec la meme boucle fold x candidat que les routes manuelles.
  if (!"mstop" %in% names(grid)) grid$mstop <- 100L
  grid$mstop <- as.integer(grid$mstop)
  rows <- lapply(seq_len(nrow(grid)), function(i) {
    benchmark_log(verbose, "[tuning] %s candidat %d/%d: mstop=%s", estimator, i, nrow(grid), grid$mstop[[i]])
    params <- list(
      k_neighbors = 8L,
      style = "W",
      zero_policy = TRUE,
      spboost_mstop = 100L,
      spboost_nu = 0.1,
      gamboost_mstop = grid$mstop[[i]],
      gamboost_nu = gamboost_nu,
      mgwrsar_bandwidth = 20L,
      mgwrsar_kernel = "gauss",
      mgwrsar_fixed_vars = NULL,
      spmoran_enum = NULL,
      spmoran_vif = 10
    )
    fold_rows <- lapply(seq_len(nrow(resamples)), function(j) {
      fold_id <- if ("id" %in% names(resamples)) as.character(resamples$id[[j]]) else paste0("Fold", j)
      score_benchmark_fold(
        estimator = estimator,
        fold_id = fold_id,
        split = resamples$splits[[j]],
        formula = formula,
        coords = coords,
        params = params
      )
    })
    fold_rows <- do.call(rbind, fold_rows)
    ok <- is.na(fold_rows$fit_error) & is.finite(fold_rows$rmse) & is.finite(fold_rows$mae)
    data.frame(
      mstop = grid$mstop[[i]],
      rmse = if (any(ok)) mean(fold_rows$rmse[ok]) else NA_real_,
      mae = if (any(ok)) mean(fold_rows$mae[ok]) else NA_real_,
      n_rmse = sum(ok),
      n_mae = sum(ok),
      n_ok = sum(ok),
      fit_error = paste(unique(stats::na.omit(fold_rows$fit_error)), collapse = " | "),
      stringsAsFactors = FALSE
    )
  })
  grid_out <- do.call(rbind, rows)
  grid_out$fit_error[grid_out$fit_error == ""] <- NA_character_
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  if (!any(is.finite(grid_out$rmse))) {
    stop("All GAMBoost tuning candidates failed.", call. = FALSE)
  }
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = NULL,
    params = list(gamboost_mstop = as.integer(best$mstop[[1]]))
  )
}

tune_spmoran_benchmark <- function(estimator, formula, data, coords, resamples,
                                   grid, verbose = FALSE) {
  # ESF/RESF supportent tune_grid() via leurs specs parsnip, mais le benchmark
  # utilise une boucle tolerante: spmoran::esf() peut echouer sur certains
  # petits folds quand la base de vecteurs propres est trop courte.
  if (!"enum" %in% names(grid)) grid$enum <- 20L
  grid$enum <- as.integer(grid$enum)
  if (identical(estimator, "spmoran_esf")) {
    if (!"vif" %in% names(grid)) grid$vif <- 10
    grid$vif <- as.numeric(grid$vif)
  } else {
    grid$vif <- 10
  }
  rows <- lapply(seq_len(nrow(grid)), function(i) {
    benchmark_log(
      verbose, "[tuning] %s candidat %d/%d: enum=%s vif=%s",
      estimator, i, nrow(grid), grid$enum[[i]], grid$vif[[i]]
    )
    params <- list(
      k_neighbors = 8L,
      style = "W",
      zero_policy = TRUE,
      spboost_mstop = 100L,
      spboost_nu = 0.1,
      gamboost_mstop = 100L,
      gamboost_nu = 0.1,
      mgwrsar_bandwidth = 20L,
      mgwrsar_kernel = "gauss",
      mgwrsar_fixed_vars = NULL,
      spmoran_enum = grid$enum[[i]],
      spmoran_vif = grid$vif[[i]]
    )
    fold_rows <- lapply(seq_len(nrow(resamples)), function(j) {
      fold_id <- if ("id" %in% names(resamples)) as.character(resamples$id[[j]]) else paste0("Fold", j)
      score_benchmark_fold(
        estimator = estimator,
        fold_id = fold_id,
        split = resamples$splits[[j]],
        formula = formula,
        coords = coords,
        params = params
      )
    })
    fold_rows <- do.call(rbind, fold_rows)
    ok <- is.na(fold_rows$fit_error) & is.finite(fold_rows$rmse) & is.finite(fold_rows$mae)
    data.frame(
      enum = grid$enum[[i]],
      vif = if (identical(estimator, "spmoran_esf")) grid$vif[[i]] else NA_real_,
      rmse = if (any(ok)) mean(fold_rows$rmse[ok]) else NA_real_,
      mae = if (any(ok)) mean(fold_rows$mae[ok]) else NA_real_,
      n_rmse = sum(ok),
      n_mae = sum(ok),
      n_ok = sum(ok),
      n_failed = sum(!is.na(fold_rows$fit_error)),
      fit_error = paste(unique(stats::na.omit(fold_rows$fit_error)), collapse = " | "),
      stringsAsFactors = FALSE
    )
  })
  grid_out <- do.call(rbind, rows)
  grid_out$fit_error[grid_out$fit_error == ""] <- NA_character_
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  if (!any(is.finite(grid_out$rmse))) {
    stop("All SpMoran tuning candidates failed.", call. = FALSE)
  }
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = NULL,
    params = list(
      spmoran_enum = as.integer(best$enum[[1]]),
      spmoran_vif = if (identical(estimator, "spmoran_esf")) as.numeric(best$vif[[1]]) else 10
    )
  )
}

tune_spatial_forest_benchmark <- function(estimator, formula, coords, resamples,
                                          grid, k_neighbors = 8L,
                                          verbose = FALSE) {
  # Les packages SpatialML/spatialRF/RandomForestsGLS ne passent pas encore par
  # parsnip. On tune donc leurs hyperparametres avec la meme boucle manuelle que
  # les estimateurs spatiaux externes: candidat x folds -> RMSE moyen.
  if (identical(estimator, "spatialml_grf")) {
    if (!"bandwidth" %in% names(grid)) grid$bandwidth <- 20L
    if (!"ntree" %in% names(grid)) grid$ntree <- 100L
    if (!"mtry" %in% names(grid)) grid$mtry <- NA_integer_
    grid$bandwidth <- as.integer(grid$bandwidth)
    grid$ntree <- as.integer(grid$ntree)
    grid$mtry <- as.integer(grid$mtry)
    grid_cols <- c("bandwidth", "ntree", "mtry")
  } else if (identical(estimator, "spatialrf")) {
    if (!"method" %in% names(grid)) grid$method <- "hengl"
    if (!"ntree" %in% names(grid)) grid$ntree <- 100L
    if (!"mtry" %in% names(grid)) grid$mtry <- NA_integer_
    if (!"min_node_size" %in% names(grid)) grid$min_node_size <- NA_integer_
    if (!"max_spatial_predictors" %in% names(grid)) grid$max_spatial_predictors <- NA_integer_
    grid$method <- as.character(grid$method)
    grid$ntree <- as.integer(grid$ntree)
    grid$mtry <- as.integer(grid$mtry)
    grid$min_node_size <- as.integer(grid$min_node_size)
    grid$max_spatial_predictors <- as.integer(grid$max_spatial_predictors)
    grid_cols <- c("method", "ntree", "mtry", "min_node_size", "max_spatial_predictors")
  } else {
    if (!"ntree" %in% names(grid)) grid$ntree <- 50L
    if (!"mtry" %in% names(grid)) grid$mtry <- NA_integer_
    if (!"k_neighbors" %in% names(grid)) grid$k_neighbors <- k_neighbors
    if (!"nthsize" %in% names(grid)) grid$nthsize <- 20L
    if (!"cov_model" %in% names(grid)) grid$cov_model <- "exponential"
    if (!"param_estimate" %in% names(grid)) grid$param_estimate <- FALSE
    grid$ntree <- as.integer(grid$ntree)
    grid$mtry <- as.integer(grid$mtry)
    grid$k_neighbors <- as.integer(grid$k_neighbors)
    grid$nthsize <- as.integer(grid$nthsize)
    grid$cov_model <- as.character(grid$cov_model)
    grid$param_estimate <- as.logical(grid$param_estimate)
    grid_cols <- c("ntree", "mtry", "k_neighbors", "nthsize", "cov_model", "param_estimate")
  }

  rows <- lapply(seq_len(nrow(grid)), function(i) {
    candidate <- grid[i, , drop = FALSE]
    benchmark_log(
      verbose,
      "[tuning] %s candidat %d/%d",
      estimator, i, nrow(grid)
    )
    params <- list(
      k_neighbors = if ("k_neighbors" %in% names(candidate)) as.integer(candidate$k_neighbors[[1]]) else k_neighbors,
      style = "W",
      zero_policy = TRUE,
      spboost_mstop = 100L,
      spboost_nu = 0.1,
      gamboost_mstop = 100L,
      gamboost_nu = 0.1,
      mgwrsar_bandwidth = 20L,
      mgwrsar_kernel = "gauss",
      mgwrsar_fixed_vars = NULL,
      spmoran_enum = NULL,
      spmoran_vif = 10,
      spatialml_bandwidth = if ("bandwidth" %in% names(candidate)) as.integer(candidate$bandwidth[[1]]) else 20L,
      spatialml_ntree = if ("ntree" %in% names(candidate)) as.integer(candidate$ntree[[1]]) else 100L,
      spatialml_mtry = if ("mtry" %in% names(candidate) && !is.na(candidate$mtry[[1]])) as.integer(candidate$mtry[[1]]) else NULL,
      spatialrf_ntree = if ("ntree" %in% names(candidate)) as.integer(candidate$ntree[[1]]) else 100L,
      spatialrf_method = if ("method" %in% names(candidate)) as.character(candidate$method[[1]]) else "hengl",
      spatialrf_mtry = if ("mtry" %in% names(candidate) && !is.na(candidate$mtry[[1]])) as.integer(candidate$mtry[[1]]) else NULL,
      spatialrf_min_node_size = if ("min_node_size" %in% names(candidate) && !is.na(candidate$min_node_size[[1]])) as.integer(candidate$min_node_size[[1]]) else NULL,
      spatialrf_max_spatial_predictors = if ("max_spatial_predictors" %in% names(candidate) && !is.na(candidate$max_spatial_predictors[[1]])) as.integer(candidate$max_spatial_predictors[[1]]) else NULL,
      rfgls_ntree = if ("ntree" %in% names(candidate)) as.integer(candidate$ntree[[1]]) else 50L,
      rfgls_mtry = if ("mtry" %in% names(candidate) && !is.na(candidate$mtry[[1]])) as.integer(candidate$mtry[[1]]) else NULL,
      rfgls_n_neighbors = if ("k_neighbors" %in% names(candidate)) as.integer(candidate$k_neighbors[[1]]) else k_neighbors,
      rfgls_nthsize = if ("nthsize" %in% names(candidate)) as.integer(candidate$nthsize[[1]]) else 20L,
      rfgls_cov_model = if ("cov_model" %in% names(candidate)) as.character(candidate$cov_model[[1]]) else "exponential",
      rfgls_param_estimate = if ("param_estimate" %in% names(candidate)) isTRUE(candidate$param_estimate[[1]]) else FALSE
    )
    fold_rows <- lapply(seq_len(nrow(resamples)), function(j) {
      fold_id <- if ("id" %in% names(resamples)) as.character(resamples$id[[j]]) else paste0("Fold", j)
      benchmark_log(verbose, "[tuning] %s candidat %d fold %s", estimator, i, fold_id)
      score_benchmark_fold(
        estimator = estimator,
        fold_id = fold_id,
        split = resamples$splits[[j]],
        formula = formula,
        coords = coords,
        params = params
      )
    })
    fold_rows <- do.call(rbind, fold_rows)
    ok <- is.na(fold_rows$fit_error) & is.finite(fold_rows$rmse) & is.finite(fold_rows$mae)
    out <- candidate[, grid_cols, drop = FALSE]
    out$rmse <- if (any(ok)) mean(fold_rows$rmse[ok]) else NA_real_
    out$mae <- if (any(ok)) mean(fold_rows$mae[ok]) else NA_real_
    out$n_rmse <- sum(ok)
    out$n_mae <- sum(ok)
    out$n_ok <- sum(ok)
    out$n_failed <- sum(!ok)
    out$fit_error <- paste(unique(stats::na.omit(fold_rows$fit_error)), collapse = " | ")
    out
  })
  grid_out <- do.call(rbind, rows)
  grid_out$fit_error[grid_out$fit_error == ""] <- NA_character_
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  if (!any(is.finite(grid_out$rmse))) {
    stop(sprintf("All %s tuning candidates failed.", estimator), call. = FALSE)
  }
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  params <- switch(estimator,
    spatialml_grf = list(
      spatialml_bandwidth = as.integer(best$bandwidth[[1]]),
      spatialml_ntree = as.integer(best$ntree[[1]]),
      spatialml_mtry = if (!is.na(best$mtry[[1]])) as.integer(best$mtry[[1]]) else NULL
    ),
    spatialrf = list(
      spatialrf_ntree = as.integer(best$ntree[[1]]),
      spatialrf_method = as.character(best$method[[1]]),
      spatialrf_mtry = if (!is.na(best$mtry[[1]])) as.integer(best$mtry[[1]]) else NULL,
      spatialrf_min_node_size = if (!is.na(best$min_node_size[[1]])) as.integer(best$min_node_size[[1]]) else NULL,
      spatialrf_max_spatial_predictors = if (!is.na(best$max_spatial_predictors[[1]])) as.integer(best$max_spatial_predictors[[1]]) else NULL
    ),
    rfgls = list(
      rfgls_ntree = as.integer(best$ntree[[1]]),
      rfgls_mtry = if (!is.na(best$mtry[[1]])) as.integer(best$mtry[[1]]) else NULL,
      rfgls_n_neighbors = as.integer(best$k_neighbors[[1]]),
      rfgls_nthsize = as.integer(best$nthsize[[1]]),
      rfgls_cov_model = as.character(best$cov_model[[1]]),
      rfgls_param_estimate = isTRUE(best$param_estimate[[1]]),
      k_neighbors = as.integer(best$k_neighbors[[1]])
    )
  )
  list(grid = grid_out, best = best, tune_result = NULL, params = params)
}

tune_mgwrsar_candidate <- function(i, estimator, formula, coords, resamples, grid, mixed,
                                   verbose = FALSE) {
  # Evalue un candidat MGWRSAR sur tous les folds. Cette fonction est separee
  # pour pouvoir etre appelee par lapply() ou par parallel::parLapply().
  candidate <- grid[i, , drop = FALSE]
  params <- list(
    k_neighbors = as.integer(candidate$k_neighbors[[1]]),
    style = "W",
    zero_policy = TRUE,
    spboost_mstop = 100L,
    spboost_nu = 0.1,
    mgwrsar_bandwidth = as.integer(candidate$bandwidth[[1]]),
    mgwrsar_kernel = as.character(candidate$kernel[[1]]),
    mgwrsar_fixed_vars = if (isTRUE(mixed)) candidate$fixed_vars[[1]] else NULL
  )
  benchmark_log(
    verbose,
    "[tuning] %s candidat %d/%d: H=%s kernel=%s k=%s fixed=%s",
    estimator, i, nrow(grid), params$mgwrsar_bandwidth,
    params$mgwrsar_kernel, params$k_neighbors,
    paste(params$mgwrsar_fixed_vars %||% NA_character_, collapse = "+")
  )
  fold_rows <- lapply(seq_len(nrow(resamples)), function(j) {
    fold_id <- if ("id" %in% names(resamples)) as.character(resamples$id[[j]]) else paste0("Fold", j)
    benchmark_log(verbose, "[tuning] %s candidat %d fold %s", estimator, i, fold_id)
    score_benchmark_fold(
      estimator = estimator,
      fold_id = fold_id,
      split = resamples$splits[[j]],
      formula = formula,
      coords = coords,
      params = params
    )
  })
  fold_rows <- do.call(rbind, fold_rows)
  ok <- is.na(fold_rows$fit_error) & is.finite(fold_rows$rmse) & is.finite(fold_rows$mae)
  data.frame(
    bandwidth = candidate$bandwidth[[1]],
    kernel = candidate$kernel[[1]],
    k_neighbors = candidate$k_neighbors[[1]],
    fixed_vars = if (isTRUE(mixed)) paste(params$mgwrsar_fixed_vars, collapse = "+") else NA_character_,
    rmse = if (any(ok)) mean(fold_rows$rmse[ok]) else NA_real_,
    mae = if (any(ok)) mean(fold_rows$mae[ok]) else NA_real_,
    n_rmse = sum(ok),
    n_mae = sum(ok),
    n_ok = sum(ok),
    n_failed = sum(!ok),
    fit_error = paste(unique(stats::na.omit(fold_rows$fit_error)), collapse = " | "),
    stringsAsFactors = FALSE
  )
}

parallel_mgwrsar_candidates <- function(indices, estimator, formula, coords, resamples,
                                        grid, mixed, workers = 2L, verbose = FALSE) {
  # Parallele PSOCK compatible Windows/RStudio. Les workers chargent le package
  # installe; en developpement, garder parallel=FALSE pour tester le code charge
  # par devtools::load_all().
  workers <- max(1L, min(as.integer(workers), length(indices)))
  if (workers <= 1L) {
    return(lapply(indices, tune_mgwrsar_candidate, estimator, formula, coords, resamples, grid, mixed, verbose))
  }
  require_package("parallel", "parallel MGWRSAR tuning")
  cl <- parallel::makeCluster(workers)
  on.exit(parallel::stopCluster(cl), add = TRUE)
  parallel::clusterEvalQ(cl, suppressPackageStartupMessages(library(spatialtidymodels)))
  parallel::clusterExport(
    cl,
    varlist = c("estimator", "formula", "coords", "resamples", "grid", "mixed"),
    envir = environment()
  )
  parallel::parLapply(cl, indices, function(i) {
    spatialtidymodels:::tune_mgwrsar_candidate(
      i = i,
      estimator = estimator,
      formula = formula,
      coords = coords,
      resamples = resamples,
      grid = grid,
      mixed = mixed,
      verbose = FALSE
    )
  })
}

tune_mgwrsar_autocorrelated_benchmark <- function(estimator, formula, data, coords, resamples,
                                                  grid, k_neighbors = 8,
                                                  parallel = FALSE, workers = 2L,
                                                  verbose = FALSE) {
  # MGWRSAR autocorrele a besoin d'une W train+test propre a chaque fold. On ne
  # passe donc pas par tune_grid(): on controle explicitement chaque split pour
  # construire W_train_test, extraire W_train, fitter, predire et scorer.
  mixed <- estimator %in% c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")
  if (isTRUE(mixed)) {
    grid <- expand_mgwrsar_mixed_grid(grid, formula = formula, data = data, coords = coords, k_neighbors = k_neighbors)
  } else {
    grid$kernel <- "gauss"
    if (!"k_neighbors" %in% names(grid)) grid$k_neighbors <- k_neighbors
    grid$bandwidth <- as.integer(grid$bandwidth)
    grid$kernel <- "gauss"
    grid$k_neighbors <- as.integer(grid$k_neighbors)
    grid <- unique(grid[, c("bandwidth", "kernel", "k_neighbors"), drop = FALSE])
  }

  benchmark_log(
    verbose,
    "[tuning] %s: %d candidats x %d folds%s",
    estimator, nrow(grid), nrow(resamples),
    if (isTRUE(parallel)) sprintf(" en parallele (%d workers)", workers) else ""
  )
  rows <- if (isTRUE(parallel)) {
    parallel_mgwrsar_candidates(
      indices = seq_len(nrow(grid)),
      estimator = estimator,
      formula = formula,
      coords = coords,
      resamples = resamples,
      grid = grid,
      mixed = mixed,
      workers = workers,
      verbose = verbose
    )
  } else {
    lapply(seq_len(nrow(grid)), tune_mgwrsar_candidate, estimator, formula, coords, resamples, grid, mixed, verbose)
  }
  grid_out <- do.call(rbind, rows)
  grid_out$fit_error[grid_out$fit_error == ""] <- NA_character_
  grid_out <- grid_out[order(grid_out$rmse), , drop = FALSE]
  if (!any(is.finite(grid_out$rmse))) {
    stop("All MGWRSAR tuning candidates failed.", call. = FALSE)
  }
  best <- grid_out[which.min(grid_out$rmse), , drop = FALSE]
  list(
    grid = grid_out,
    best = best,
    tune_result = NULL,
    params = list(
      mgwrsar_bandwidth = as.integer(best$bandwidth[[1]]),
      mgwrsar_kernel = as.character(best$kernel[[1]]),
      k_neighbors = as.integer(best$k_neighbors[[1]]),
      mgwrsar_fixed_vars = if (isTRUE(mixed)) normalize_fixed_vars_value(best$fixed_vars[[1]]) else NULL
    )
  )
}

tune_one_benchmark_estimator <- function(estimator, formula, data, coords, resamples,
                                         tuning_grids = NULL, k_neighbors = 8,
                                         style = "W", zero_policy = TRUE,
                                         spboost_nu = 0.1,
                                         gamboost_nu = 0.1,
                                         parallel = FALSE, workers = 2L,
                                         verbose = FALSE) {
  # Retourne NULL si l'estimateur n'a pas encore de route de tuning package.
  grid <- benchmark_tuning_grid(estimator, tuning_grids, data)
  if (is.null(grid)) return(NULL)
  out <- tryCatch({
    switch(estimator,
      sar_lag = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy, verbose),
      sem_error = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy, verbose),
      sdm_mixed = tune_spatialreg_benchmark(estimator, formula, data, coords, resamples, grid, style, zero_policy, verbose),
      gamboost = tune_gamboost_benchmark(estimator, formula, coords, resamples, grid, gamboost_nu, verbose),
      spboost = tune_spboost_benchmark(estimator, formula, data, coords, resamples, grid, spboost_nu, k_neighbors, verbose),
      spboost_bspa_sar_ml = tune_spboost_benchmark(estimator, formula, data, coords, resamples, grid, spboost_nu, k_neighbors, verbose),
      spboost_bspa_sar_cfe = tune_spboost_benchmark(estimator, formula, data, coords, resamples, grid, spboost_nu, k_neighbors, verbose),
      spboost_bspa_sem_ml = tune_spboost_benchmark(estimator, formula, data, coords, resamples, grid, spboost_nu, k_neighbors, verbose),
      spboost_bspa_sem_cfe = tune_spboost_benchmark(estimator, formula, data, coords, resamples, grid, spboost_nu, k_neighbors, verbose),
      spatialml_grf = tune_spatial_forest_benchmark(estimator, formula, coords, resamples, grid, k_neighbors, verbose),
      spatialrf = tune_spatial_forest_benchmark(estimator, formula, coords, resamples, grid, k_neighbors, verbose),
      rfgls = tune_spatial_forest_benchmark(estimator, formula, coords, resamples, grid, k_neighbors, verbose),
      mgwrsar_gwr = tune_mgwrsar_gwr_benchmark(estimator, formula, data, coords, resamples, grid, verbose),
      mgwrsar_mgwrsar = tune_mgwrsar_autocorrelated_benchmark(estimator, formula, data, coords, resamples, grid, k_neighbors, parallel, workers, verbose),
      MGWRSAR_0_kc_kv = tune_mgwrsar_autocorrelated_benchmark(estimator, formula, data, coords, resamples, grid, k_neighbors, parallel, workers, verbose),
      MGWRSAR_1_kc_kv = tune_mgwrsar_autocorrelated_benchmark(estimator, formula, data, coords, resamples, grid, k_neighbors, parallel, workers, verbose),
      spmoran_esf = tune_spmoran_benchmark(estimator, formula, data, coords, resamples, grid, verbose),
      spmoran_resf = tune_spmoran_benchmark(estimator, formula, data, coords, resamples, grid, verbose),
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

  # Partition spatiale maison (decoupage recursif par mediane, axes
  # alternes) plutot que mgwrsar::quadtree()/cell()/insidecell(). Ces
  # fonctions du package s'appuient sur un seuil aleatoire (runif() dans
  # quadtree()) puis un decoupage de polygones par inegalites strictes
  # (cell.quadtree() : `if (q$threshold > xylim[1,i])`) qui perd
  # silencieusement des branches entieres des qu'un seuil retombe pile sur
  # une borne deja decoupee -- verifie empiriquement : sur des coordonnees
  # geographiques reelles (Henan), la partition s'effondre a une seule
  # cellule geante sur 15 graines aleatoires differentes, avec ou sans
  # normalisation des coordonnees, alors que des coordonnees synthetiques
  # uniformes ne posent jamais ce probleme. La partition maison ci-dessous
  # n'a besoin que d'assigner chaque point a une feuille (pas de geometrie de
  # polygone pour la modelisation elle-meme), donc ce contournement local
  # est suffisant et evite la dependance a ce chemin de code fragile.
  split_median <- function(idx, axis) {
    if (length(idx) < 2L * k_leaf_current) {
      return(list(idx))
    }
    x0 <- stats::median(coords[idx, axis])
    left <- idx[coords[idx, axis] <= x0]
    right <- idx[coords[idx, axis] > x0]
    if (length(left) == length(idx) || length(right) == length(idx)) {
      # valeurs trop repetees pour que la mediane separe le groupe : on
      # arrete la recursion ici plutot que de boucler indefiniment.
      return(list(idx))
    }
    next_axis <- axis %% 2L + 1L
    c(split_median(left, next_axis), split_median(right, next_axis))
  }

  k_leaf_current <- NULL

  build_quad_partition <- function(k_leaf) {
    k_leaf_current <<- k_leaf
    cell_members <- split_median(seq_len(n), 1L)
    cell_sizes <- vapply(cell_members, length, integer(1L))

    polys <- do.call(rbind, lapply(seq_along(cell_members), function(cell) {
      members <- cell_members[[cell]]
      xr <- range(coords[members, 1L])
      yr <- range(coords[members, 2L])
      data.frame(
        id = cell,
        x = c(xr[1], xr[2], xr[2], xr[1], xr[1]),
        y = c(yr[1], yr[1], yr[2], yr[2], yr[1])
      )
    }))

    list(
      k_leaf = k_leaf,
      cell_id = local({
        cid <- integer(n)
        for (cell in seq_along(cell_members)) cid[cell_members[[cell]]] <- cell
        cid
      }),
      cell_members = cell_members,
      cell_sizes = cell_sizes,
      n_cells = length(cell_members),
      min_cell_size = min(cell_sizes),
      polys = polys
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
    row_values <- test_matrix[rep, ]
    # sample(x, ...) traite un x de longueur 1 comme "echantillonner dans
    # 1:x" plutot que comme "melanger ce vecteur d'un element" -- utiliser
    # sample.int() sur les indices evite ce piege, y compris quand la
    # partition retenue n'a qu'une seule cellule.
    test_matrix[rep, ] <- row_values[sample.int(length(row_values))]
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

ensure_mgwrsar_fixed_vars_params <- function(params, estimator, formula, data, coords) {
  # Les modeles MGWRSAR_0/1_kc_kv demandent une partition entre coefficients
  # fixes et locaux. Pour un appel utilisateur court, on prend le premier
  # candidat heuristique; le tuning explicite reste prioritaire.
  if (!estimator %in% c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")) return(params)
  if (!is.null(normalize_fixed_vars_value(params$mgwrsar_fixed_vars))) return(params)
  params$mgwrsar_fixed_vars <- default_mgwrsar_fixed_vars_candidates(
    formula = formula,
    data = data,
    coords = coords
  )[[1L]]
  params
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
    accuracy = NA_real_,
    auc = NA_real_,
    deviance = NA_real_,
    aicc = NA_real_,
    logLik = NA_real_,
    elapsed_sec = NA_real_,
    elapsed_total_sec = NA_real_,
    duration_sec = NA_real_,
    spatial_param = NA_character_,
    spatial_value = NA_real_,
    moran_i = NA_real_,
    moran_abs = NA_real_,
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
  if (!"elapsed_sec" %in% names(row)) row$elapsed_sec <- NA_real_
  if (!"elapsed_total_sec" %in% names(row)) row$elapsed_total_sec <- NA_real_
  if (!"duration_sec" %in% names(row)) row$duration_sec <- row$elapsed_total_sec
  if (!"moran_abs" %in% names(row)) row$moran_abs <- abs(row$moran_i)
  row
}

predict_vector_for_benchmark <- function(fit, new_data, response_typology = "continuous") {
  # Normalise les sorties predict(): workflow renvoie .pred, certains backends
  # renvoient directement un vecteur numerique. Les objets tidymodels attendent
  # `new_data`, tandis que les objets R classiques attendent souvent `newdata`.
  #
  # response_typology == "binary": un workflow classification n'a pas de
  # .pred par defaut (predict() renvoie .pred_class, un facteur, sans
  # type="prob") -- meme contournement que predict_values_for_diagnostics()
  # dans 12-diagnose-spatial.R (derniere colonne = probabilite classe
  # positive, convention tidymodels a 2 niveaux).
  if (identical(response_typology, "binary") && inherits(fit, "workflow")) {
    pred_prob <- tryCatch(stats::predict(fit, new_data = new_data, type = "prob"), error = function(e) e)
    if (!inherits(pred_prob, "error") && is.data.frame(pred_prob) && ncol(pred_prob) >= 2L) {
      return(as.numeric(pred_prob[[ncol(pred_prob)]]))
    }
  }
  # response_typology %in% c("binary","count") pour un objet NON-workflow
  # (glm/gam ajustes directement, cf. fit_one_benchmark_estimator()): sans
  # type="response" explicite, predict.glm()/predict.gam() renvoient
  # l'echelle lineaire (logit pour binomial, log pour poisson), pas la
  # probabilite/le compte -- confirme empiriquement (RMSE > 1 impossible
  # sinon pour une reponse 0/1). Meme contournement que
  # predict_values_for_diagnostics() dans 12-diagnose-spatial.R.
  predict_type <- if (!inherits(fit, "workflow") && response_typology %in% c("binary", "count")) {
    "response"
  } else {
    NULL
  }
  predict_args <- if (is.null(predict_type)) list() else list(type = predict_type)
  pred <- tryCatch(
    do.call(stats::predict, c(list(fit, new_data = new_data), predict_args)),
    error = function(e) e
  )
  pred_len <- if (inherits(pred, "error")) {
    NA_integer_
  } else if (is.data.frame(pred)) {
    nrow(pred)
  } else {
    length(pred)
  }
  if (inherits(pred, "error") || !identical(pred_len, nrow(new_data))) {
    pred_newdata <- tryCatch(
      do.call(stats::predict, c(list(fit, newdata = new_data), predict_args)),
      error = function(e) e
    )
    if (!inherits(pred_newdata, "error")) pred <- pred_newdata
  }
  if (is.data.frame(pred) && ".pred" %in% names(pred)) return(pred$.pred)
  if (inherits(pred, "error")) stop(pred)
  as.numeric(pred)
}

prepare_mgwrsar_fold_control <- function(estimator, train, test, coords, k_neighbors) {
  # Reproduit le protocole du package mgwrsar pour les modeles avec
  # autocorrelation: on construit W sur train+test, puis on extrait le bloc
  # train-train pour le fit. Ainsi, le bloc train de W_predict reste coherent
  # avec la matrice utilisee pour estimer le modele.
  if (!estimator %in% c("mgwrsar_sar", "mgwrsar_mgwrsar", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")) {
    return(list())
  }
  require_package("mgwrsar", "benchmark MGWRSAR fold W")
  coords_train <- as.matrix(train[, coords, drop = FALSE])
  coords_test <- as.matrix(test[, coords, drop = FALSE])
  coords_train_test <- rbind(coords_train, coords_test)
  W_train_test <- build_knn_W(coords_train_test, k = k_neighbors, sparse = TRUE)
  n_train <- nrow(train)
  W_train <- W_train_test[seq_len(n_train), seq_len(n_train), drop = FALSE]
  W_train <- mgwrsar::normW(W_train)
  list(
    W = W_train,
    W_predict = W_train_test,
    W_predict_coords = coords_train_test
  )
}

score_benchmark_fold <- function(estimator, fold_id, split, formula, coords, params) {
  # Ajuste sur analysis(split), predit sur assessment(split), puis calcule les
  # metriques hors-echantillon. Les erreurs restent dans une ligne de resultat.
  #
  # Ne gere PAS elle-meme de garde-fou timeout: cette fonction peut etre
  # executee soit directement (fold_timeout_sec desactive), soit expediee a
  # un worker callr par evaluate_benchmark_resamples() (fold_timeout_sec
  # actif) -- voir run_with_fold_timeout()/26-fold-timeout-worker.R. Un
  # timeout est applique de l'EXTERIEUR (kill du process worker), pas
  # depuis l'interieur de cette fonction: setTimeLimit() a ete teste
  # empiriquement contre le vrai calcul pathologique qui a motive ce
  # garde-fou (stats::AIC() sur un objet mboost) et ne l'a jamais interrompu
  # (toujours actif apres 40s+ contre un budget de 3s) -- R ne vérifie les
  # interruptions qu'entre deux instructions de l'evaluateur, jamais au
  # milieu d'un seul appel compile/matriciel prolonge, ce qui est
  # exactement le cas ici.
  train <- rsample::analysis(split)
  test <- rsample::assessment(split)
  W_train <- subset_spatial_W_rows(
    params$W %||% NULL,
    rownames(train),
    n_expected = nrow(train),
    style = params$style,
    zero_policy = params$zero_policy,
    arg = "W fournie au benchmark"
  )
  W_test <- subset_spatial_W_rows(
    params$W %||% NULL,
    rownames(test),
    n_expected = nrow(test),
    style = params$style,
    zero_policy = params$zero_policy,
    arg = "W fournie au benchmark"
  )
  elapsed_start <- proc.time()[["elapsed"]]
  elapsed_now <- function() as.numeric(proc.time()[["elapsed"]] - elapsed_start)
  params <- ensure_mgwrsar_fixed_vars_params(
    params = params,
    estimator = estimator,
    formula = formula,
    data = train,
    coords = coords
  )
  mgwrsar_control <- prepare_mgwrsar_fold_control(
    estimator = estimator,
    train = train,
    test = test,
    coords = coords,
    k_neighbors = params$k_neighbors
  )

  response_typology <- params$response_typology %||% "continuous"
  fit <- tryCatch(
    fit_one_benchmark_estimator(
      estimator = estimator, formula = formula, data = train, coords = coords,
      k_neighbors = params$k_neighbors, style = params$style,
      zero_policy = params$zero_policy,
      W = W_train,
      response_typology = response_typology,
      spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
      gamboost_mstop = params$gamboost_mstop, gamboost_nu = params$gamboost_nu,
      mgwrsar_bandwidth = params$mgwrsar_bandwidth,
      mgwrsar_kernel = params$mgwrsar_kernel,
      mgwrsar_fixed_vars = params$mgwrsar_fixed_vars,
      spmoran_enum = params$spmoran_enum,
      spmoran_vif = params$spmoran_vif,
      spatialml_bandwidth = params$spatialml_bandwidth,
      spatialml_ntree = params$spatialml_ntree,
      spatialml_mtry = params$spatialml_mtry,
      spatialrf_ntree = params$spatialrf_ntree,
      spatialrf_method = params$spatialrf_method,
      spatialrf_mtry = params$spatialrf_mtry,
      spatialrf_min_node_size = params$spatialrf_min_node_size,
      spatialrf_max_spatial_predictors = params$spatialrf_max_spatial_predictors,
      rfgls_ntree = params$rfgls_ntree,
      rfgls_mtry = params$rfgls_mtry,
      rfgls_n_neighbors = params$rfgls_n_neighbors,
      rfgls_nthsize = params$rfgls_nthsize,
      rfgls_cov_model = params$rfgls_cov_model,
      rfgls_param_estimate = params$rfgls_param_estimate,
      mgwrsar_control = mgwrsar_control
    ),
    error = function(e) e
  )
  if (inherits(fit, "error")) {
    return(fold_error_row(
      estimator, fold_id, nrow(train), nrow(test), deparse(formula[[2]]),
      conditionMessage(fit), elapsed_sec = elapsed_now()
    ))
  }
  response_name <- deparse(formula[[2]])
  pred <- tryCatch(
    predict_vector_for_benchmark(fit, test, response_typology = response_typology),
    error = function(e) e
  )
  if (inherits(pred, "error")) {
    return(fold_error_row(
      estimator, fold_id, nrow(train), nrow(test), response_name,
      conditionMessage(pred), elapsed_sec = elapsed_now()
    ))
  }
  truth <- as.numeric(test[[response_name]])
  pred <- as.numeric(pred)
  if (length(pred) != length(truth)) {
    return(fold_error_row(
      estimator, fold_id, nrow(train), nrow(test), response_name,
      sprintf("Prediction length mismatch: expected %d, got %d.", length(truth), length(pred)),
      elapsed_sec = elapsed_now()
    ))
  }
  diag <- tryCatch(
    diagnose_spatial(
      fit,
      data = test,
      coords = coords,
      formula = formula,
      k_neighbors = params$k_neighbors,
      W = W_test,
      style = params$style,
      zero_policy = params$zero_policy,
      include_baseline = FALSE,
      response_typology = response_typology
    ),
    error = function(e) e
  )
  if (inherits(diag, "error")) {
    return(fold_error_row(
      estimator, fold_id, nrow(train), nrow(test), deparse(formula[[2]]),
      conditionMessage(diag), elapsed_sec = elapsed_now()
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
    accuracy = diag$accuracy[[1]],
    auc = diag$auc[[1]],
    deviance = diag$deviance[[1]],
    elapsed_sec = elapsed_now(),
    moran_i = diag$moran_i[[1]],
    moran_abs = diag$moran_abs[[1]],
    moran_p_value = diag$moran_p_value[[1]],
    moran_error = diag$moran_error[[1]],
    fit_error = metric_error,
    truth = I(list(truth)),
    pred = I(list(pred)),
    stringsAsFactors = FALSE
  )
}

evaluate_benchmark_resamples <- function(estimators, formula, data, coords,
                                         eval_resamples, base_params, tuning,
                                         verbose = FALSE, fold_timeout_sec = NA_real_) {
  # Boucle explicite fold x estimateur pour obtenir une table comparable au
  # benchmark manuel, avec une ligne par fold.
  timeout_sec <- normalize_fold_timeout_sec(fold_timeout_sec)
  # session_box: environnement mutable tenant le worker callr persistant
  # (voir 26-fold-timeout-worker.R) pour tous les folds/estimateurs de cet
  # appel -- jamais cree si timeout_sec est NA (chemin direct, inchange).
  session_box <- new.env(parent = emptyenv())
  session_box$session <- NULL
  on.exit(close_fold_timeout_worker(session_box), add = TRUE)

  rows <- list()
  for (estimator in estimators) {
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    benchmark_log(
      verbose,
      "[evaluation] %s: %d resamples",
      estimator,
      nrow(eval_resamples)
    )
    for (i in seq_len(nrow(eval_resamples))) {
      fold_id <- if ("id" %in% names(eval_resamples)) {
        as.character(eval_resamples$id[[i]])
      } else {
        paste0("Fold", i)
      }
      split <- eval_resamples$splits[[i]]
      benchmark_log(
        verbose,
        "[evaluation] %s fold %s: train=%d test=%d",
        estimator,
        fold_id,
        nrow(rsample::analysis(split)),
        nrow(rsample::assessment(split))
      )
      key <- paste(estimator, fold_id, sep = "__")
      rows[[key]] <- if (is.finite(timeout_sec)) {
        outcome <- run_with_fold_timeout(
          session_box, timeout_sec, score_benchmark_fold,
          args = list(
            estimator = estimator, fold_id = fold_id, split = split,
            formula = formula, coords = coords, params = params
          )
        )
        if (isTRUE(outcome$ok)) {
          outcome$value
        } else {
          fold_error_row(
            estimator, fold_id, nrow(rsample::analysis(split)), nrow(rsample::assessment(split)),
            deparse(formula[[2]]), outcome$error_message
          )
        }
      } else {
        score_benchmark_fold(
          estimator = estimator, fold_id = fold_id, split = split,
          formula = formula, coords = coords, params = params
        )
      }
    }
  }
  out <- do.call(rbind, rows)
  row.names(out) <- NULL
  out
}

summarize_resample_results <- function(resample_results, formula, cv_scheme,
                                       response_typology = "continuous") {
  # Agrege les lignes fold par fold en une table principale par estimateur.
  # RMSE/MAE sont recalcules sur toutes les predictions test concatenees: cela
  # donne a chaque observation le meme poids, au lieu de moyenner des RMSE de
  # folds qui peuvent avoir des tailles differentes.
  if (!"moran_abs" %in% names(resample_results)) {
    resample_results$moran_abs <- abs(resample_results$moran_i)
  }
  pieces <- lapply(split(resample_results, resample_results$estimator), function(rows) {
    has_predictions <- "truth" %in% names(rows) && "pred" %in% names(rows)
    pred_lengths <- if (has_predictions) {
      vapply(rows$pred, length, integer(1))
    } else {
      integer(nrow(rows))
    }
    ok <- is.na(rows$fit_error) & is.finite(rows$rmse) & is.finite(rows$mae) & pred_lengths > 0L
    truth_all <- if (has_predictions && any(ok)) unlist(rows$truth[ok], use.names = FALSE) else numeric()
    pred_all <- if (has_predictions && any(ok)) unlist(rows$pred[ok], use.names = FALSE) else numeric()
    finite_predictions <- is.finite(truth_all) & is.finite(pred_all)
    truth_all <- truth_all[finite_predictions]
    pred_all <- pred_all[finite_predictions]
    has_global_metrics <- length(truth_all) > 0L && length(truth_all) == length(pred_all)
    global_metrics <- if (has_global_metrics) {
      make_metric_values(truth_all, pred_all, response_typology = response_typology)
    } else {
      list(rmse = NA_real_, mae = NA_real_, accuracy = NA_real_, auc = NA_real_, deviance = NA_real_)
    }
    data.frame(
      estimator = rows$estimator[[1]],
      n = if (has_global_metrics) length(truth_all) else sum(rows$n_test[ok]),
      response = deparse(formula[[2]]),
      rmse = global_metrics$rmse,
      mae = global_metrics$mae,
      accuracy = global_metrics$accuracy,
      auc = global_metrics$auc,
      deviance = global_metrics$deviance,
      rmse_sd = if (sum(ok) > 1L) stats::sd(rows$rmse[ok]) else NA_real_,
      mae_sd = if (sum(ok) > 1L) stats::sd(rows$mae[ok]) else NA_real_,
      duration_sec = if (any(!is.na(rows$elapsed_sec))) {
        sum(rows$elapsed_sec, na.rm = TRUE)
      } else {
        NA_real_
      },
      aicc = NA_real_,
      logLik = NA_real_,
      spatial_param = NA_character_,
      spatial_value = NA_real_,
      moran_i = if (any(ok)) mean(rows$moran_i[ok], na.rm = TRUE) else NA_real_,
      moran_abs = if (any(ok)) mean(rows$moran_abs[ok], na.rm = TRUE) else NA_real_,
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
  out$moran_abs[is.nan(out$moran_abs)] <- NA_real_
  out$moran_p_value[is.nan(out$moran_p_value)] <- NA_real_
  out$moran_error[out$moran_error == ""] <- NA_character_
  out$fit_error[out$fit_error == ""] <- NA_character_
  row.names(out) <- NULL
  out
}

augment_results_with_final_diagnostics <- function(results, fits, data, coords, formula,
                                                   base_params, tuning) {
  # Les performances restent celles de la validation croisee. Cette passe ajoute
  # seulement les diagnostics disponibles sur le modele final ajuste sur tout le
  # jeu de donnees: AICc, logLik et parametre spatial explicite.
  #
  # Pas de fold_timeout_sec ici (contrairement a evaluate_benchmark_resamples()):
  # le garde-fou timeout fiable (voir run_with_fold_timeout(),
  # 26-fold-timeout-worker.R) execute le calcul dans un worker callr et n'en
  # fait traverser que le RESULTAT (une petite table) -- jamais un objet
  # modele ajuste. Ici `fit` (potentiellement un objet fragile a serialiser,
  # ex. un backend xgboost dont le pointeur C++ ne survit pas a un aller-retour
  # process) doit rester dans le process appelant, donc cette passe n'est pas
  # (encore) couverte par le garde-fou.
  for (estimator in intersect(results$estimator, names(fits))) {
    fit <- fits[[estimator]]
    if (inherits(fit, "error") || is.null(fit)) next
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    diag <- tryCatch(
      diagnose_spatial(
        fit,
        data = data,
        coords = coords,
        formula = formula,
        k_neighbors = params$k_neighbors,
        W = params$W %||% NULL,
        style = params$style,
        zero_policy = params$zero_policy,
        include_baseline = FALSE,
        response_typology = params$response_typology %||% "continuous"
      ),
      error = function(e) NULL
    )
    if (is.null(diag) || nrow(diag) == 0L) next
    idx <- which(results$estimator == estimator)
    results$aicc[idx] <- diag$aicc[[1]]
    results$logLik[idx] <- diag$logLik[[1]]
    results$spatial_param[idx] <- diag$spatial_param[[1]]
    results$spatial_value[idx] <- diag$spatial_value[[1]]
  }
  results
}

fit_final_benchmark_estimators <- function(estimators, formula, data, coords,
                                           base_params, tuning,
                                           verbose = FALSE) {
  # Ajuste les modeles finaux sur toutes les donnees pour inspection ulterieure
  # dans bench$fits. L'evaluation CV reste stockee separement.
  #
  # Pas de fold_timeout_sec ici: le modele ajuste doit rester dans ce process
  # (il est retourne a l'appelant pour bench$fits), donc il ne peut pas etre
  # produit par un worker callr jetable comme le fait
  # evaluate_benchmark_resamples() -- voir la note dans
  # augment_results_with_final_diagnostics() ci-dessus pour le detail.
  fits <- list()
  for (estimator in estimators) {
    benchmark_log(
      verbose,
      "[final fit] %s: n=%d",
      estimator,
      nrow(data)
    )
    params <- apply_tuned_params(base_params, tuning[[estimator]])
    params <- ensure_mgwrsar_fixed_vars_params(
      params = params,
      estimator = estimator,
      formula = formula,
      data = data,
      coords = coords
    )
    fit <- tryCatch(
      fit_one_benchmark_estimator(
        estimator = estimator, formula = formula, data = data, coords = coords,
        k_neighbors = params$k_neighbors, style = params$style,
        zero_policy = params$zero_policy,
        W = params$W %||% NULL,
        spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
        gamboost_mstop = params$gamboost_mstop, gamboost_nu = params$gamboost_nu,
        mgwrsar_bandwidth = params$mgwrsar_bandwidth,
        mgwrsar_kernel = params$mgwrsar_kernel,
        mgwrsar_fixed_vars = params$mgwrsar_fixed_vars,
        spmoran_enum = params$spmoran_enum,
        spmoran_vif = params$spmoran_vif,
        spatialml_bandwidth = params$spatialml_bandwidth,
        spatialml_ntree = params$spatialml_ntree,
        spatialml_mtry = params$spatialml_mtry,
        spatialrf_ntree = params$spatialrf_ntree,
        spatialrf_method = params$spatialrf_method,
        spatialrf_mtry = params$spatialrf_mtry,
        spatialrf_min_node_size = params$spatialrf_min_node_size,
        spatialrf_max_spatial_predictors = params$spatialrf_max_spatial_predictors,
        rfgls_ntree = params$rfgls_ntree,
        rfgls_mtry = params$rfgls_mtry,
        rfgls_n_neighbors = params$rfgls_n_neighbors,
        rfgls_nthsize = params$rfgls_nthsize,
        rfgls_cov_model = params$rfgls_cov_model,
        rfgls_param_estimate = params$rfgls_param_estimate,
        mgwrsar_control = list()
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

validate_heavy_tuning_request <- function(estimators, data, tune, allow_heavy_tuning) {
  # Evite les appels pieges sur gros datasets: tuner plusieurs MGWRSAR en meme
  # temps peut lancer des dizaines de fits couteux sans retour console.
  if (!isTRUE(tune) || isTRUE(allow_heavy_tuning) || nrow(data) <= 1500L) {
    return(invisible(TRUE))
  }
  heavy <- intersect(estimators, c("mgwrsar_gwr", "mgwrsar_mgwrsar", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv"))
  if (length(heavy) > 1L) {
    stop(
      sprintf(
        paste(
          "Tuning lourd demande sur %d lignes pour plusieurs estimateurs MGWRSAR: %s.",
          "Lancez-les un par un, fournissez une grille courte, ou forcez avec `allow_heavy_tuning = TRUE`."
        ),
        nrow(data), paste(heavy, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  invisible(TRUE)
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
#' @param W Optional spatial weights matrix or `listw` object. When supplied,
#'   SAR/SEM/SDM routes and residual Moran diagnostics use it instead of
#'   rebuilding a kNN structure from `coords`.
#' @param spboost_mstop Number of boosting iterations for `spboost`.
#' @param spboost_nu Learning rate for `spboost`.
#' @param gamboost_mstop Number of boosting iterations for `mboost::gamboost`.
#' @param gamboost_nu Learning rate for `mboost::gamboost`.
#' @param mgwrsar_bandwidth Spatial bandwidth `H` for `mgwrsar` variants.
#' @param mgwrsar_kernel Spatial kernel for `mgwrsar` variants.
#' @param mgwrsar_fixed_vars Character vector of stationary coefficients for
#'   mixed MGWRSAR models.
#' @param spmoran_enum Optional number of Moran eigenvectors for SpMoran ESF
#'   and RE-ESF.
#' @param spmoran_vif VIF threshold for SpMoran ESF.
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
#' @param verbose If `TRUE`, print progress messages during tuning,
#'   resampling evaluation, and final fits.
#' @param parallel If `TRUE`, evaluate manual MGWRSAR tuning candidates in
#'   parallel with `parallel::makeCluster()`.
#' @param workers Number of parallel workers when `parallel = TRUE`.
#' @param allow_heavy_tuning If `FALSE`, protect large datasets from tuning
#'   several expensive MGWRSAR estimators in the same call.
#' @param fold_timeout_sec Maximum wall-clock seconds allowed for a single
#'   (estimator, fold) case in the cross-validated evaluation path (`fit`,
#'   `predict` and diagnostics combined) -- see [evaluate_benchmark_resamples()]/
#'   `run_with_fold_timeout()` (`26-fold-timeout-worker.R`). `NA` (default)
#'   disables the guard entirely, identical to before this argument existed
#'   -- zero overhead, no subprocess ever spawned. When set, a case that
#'   exceeds the budget is aborted and recorded as a normal failure with
#'   `fit_error` starting `"TIMEOUT:"` instead of freezing the whole suite;
#'   every other case keeps running unaffected. Enforced by running the fold
#'   in a persistent `callr` worker process and killing it on timeout -- this
#'   is a hard, OS-level guarantee, unlike base R's `setTimeLimit()`, which
#'   was tested against the real pathology this guard was built for
#'   (`stats::AIC()` on an `mboost`-derived engine) and never interrupted it,
#'   even 40s+ past a 3s budget: R only checks for interrupts between
#'   evaluator statements, never mid-way through one long-running
#'   compiled/matrix call, which is exactly what that case was doing. This is
#'   a generic safety net for unforeseen pathological cases on large
#'   datasets, not a diagnosis of *why* a case is slow -- a confirmed root
#'   cause should still be fixed directly when found (the `stats::AIC()` case
#'   above already was, in `extract_information_criteria()`,
#'   `12-diagnose-spatial.R`). Not yet applied to the final full-data
#'   fit/diagnostics pass or to `cv_scheme = "in_sample"`, since those need
#'   the fitted model object to survive in this process for `bench$fits`,
#'   and some backends (e.g. xgboost) do not serialize reliably across a
#'   process boundary.
#'
#' @return A `spatial_benchmark` object with `results`, `resample_results`, and
#'   final `fits`.
#'
#' @details
#' Spatial machine-learning forest routes are available when their optional
#' packages are installed. `spatialml_grf` calls `SpatialML::grf()`, a
#' Geographical Random Forest that fits one local random forest per training
#' observation and predicts new observations from the nearest local forest.
#' `spatialrf` calls `spatialRF::rf_spatial()`, which augments a random forest
#' with spatial predictors such as Moran eigenvector maps; its most robust
#' diagnostic path is currently in-sample because the upstream package exposes
#' `get_predictions()` for fitted predictions. `rfgls` calls
#' `RandomForestsGLS::RFGLS_estimate_spatial()`, which combines random forests
#' with a GLS correction for spatial dependence using a nearest-neighbour
#' Gaussian-process/Vecchia-style approximation.
#'
#' `AICc` and `logLik` are reported when the fitted backend exposes a
#' likelihood and a usable parameter count. For `spboost`, the package first
#' tries the standard R methods, then falls back to backend fields such as
#' `logl`/backend information and an explicit active-coefficient count when
#' available.
#'
#' The `spatial_param` and `spatial_value` columns report a single explicit
#' spatial dependence parameter when the fitted backend exposes one. SAR-style
#' models usually report `rho`, the coefficient of the spatially lagged
#' response `W y`. SEM-style models report `lambda`, the coefficient of the
#' spatially autocorrelated error process. Some MGWRSAR variants estimate a
#' local spatial parameter; those are summarized as `lambda_local_mean`.
#'
#' Models such as `random_forest`, `spatialml_grf`, and `spatialrf` may use
#' coordinates, local forests, distances, or spatial predictors, but they do not
#' estimate one scalar econometric parameter equivalent to `rho` or `lambda`.
#' Their `spatial_param` and `spatial_value` columns therefore remain `NA`.
#'
#' The `moran_i` column reports Moran's I on residuals, while `moran_abs`
#' reports `abs(moran_i)`. When the goal is to remove residual spatial
#' autocorrelation, `moran_abs` is usually the metric to minimize because both
#' positive clustering and negative checkerboard-like autocorrelation indicate
#' remaining spatial structure.
#'
#' Runtime is recorded in seconds. The main `results` table reports
#' `duration_sec`, the total measured time spent by each estimator across all
#' evaluation folds. The fold-level `resample_results` table reports
#' `elapsed_sec`, the elapsed time for each estimator/fold pair. In in-sample
#' evaluations, `duration_sec` reports the elapsed time for the fit plus
#' diagnostic pass on the full data.
#' @export
benchmark_spatial <- function(formula, data, coords,
                              estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                              k_neighbors = 8, style = "W", zero_policy = TRUE,
                              W = NULL,
                              spboost_mstop = 100L, spboost_nu = 0.1,
                              gamboost_mstop = 100L, gamboost_nu = 0.1,
                              mgwrsar_bandwidth = 20, mgwrsar_kernel = "gauss",
                              mgwrsar_fixed_vars = NULL,
                              spmoran_enum = NULL, spmoran_vif = 10,
                              tune = FALSE, resamples = NULL, tuning_grids = NULL,
                              tuning_folds = 3L,
                              cv_scheme = c(
                                "in_sample", "holdout_10pct", "near_prediction",
                                "block_spatial", "vfold_cv", "custom"
                              ),
                              eval_resamples = NULL, eval_folds = 5L,
                              holdout_prop = 0.9,
                              near_n_reps = 3L, near_test_size = NULL,
                              block_folds = 5L, seed = 123L,
                              verbose = FALSE, parallel = FALSE,
                              workers = max(1L, parallel::detectCores(logical = FALSE) - 1L),
                              allow_heavy_tuning = FALSE,
                              fold_timeout_sec = NA_real_,
                              response_typology = "continuous") {
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)
  W <- normalize_spatial_W_for_data(W, data = data, style = style, zero_policy = zero_policy)
  cv_scheme <- match.arg(cv_scheme)
  response_typology <- if (is.null(response_typology) || is.na(response_typology)) "continuous" else response_typology
  if (!response_typology %in% c("continuous", "binary", "count")) {
    stop(sprintf(
      "benchmark_spatial: response_typology inconnu: %s (attendu: continuous, binary, count)",
      response_typology
    ), call. = FALSE)
  }
  registry <- spatial_benchmark_registry()
  validate_benchmark_estimators(estimators, registry)
  validate_heavy_tuning_request(estimators, data, tune, allow_heavy_tuning)

  base_params <- list(
    k_neighbors = k_neighbors,
    style = style,
    zero_policy = zero_policy,
    W = W,
    spboost_mstop = spboost_mstop,
    spboost_nu = spboost_nu,
    gamboost_mstop = gamboost_mstop,
    gamboost_nu = gamboost_nu,
    mgwrsar_bandwidth = mgwrsar_bandwidth,
    mgwrsar_kernel = mgwrsar_kernel,
    mgwrsar_fixed_vars = mgwrsar_fixed_vars,
    spmoran_enum = spmoran_enum,
    spmoran_vif = spmoran_vif,
    spatialml_bandwidth = 20L,
    spatialml_ntree = 100L,
    spatialml_mtry = NULL,
    spatialrf_ntree = 100L,
    spatialrf_method = "hengl",
    spatialrf_mtry = NULL,
    spatialrf_min_node_size = NULL,
    spatialrf_max_spatial_predictors = NULL,
    rfgls_ntree = 50L,
    rfgls_mtry = NULL,
    rfgls_n_neighbors = NULL,
    rfgls_nthsize = 20L,
    rfgls_cov_model = "exponential",
    rfgls_param_estimate = FALSE,
    response_typology = response_typology
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
        spboost_nu = spboost_nu,
        gamboost_nu = gamboost_nu,
        parallel = parallel,
        workers = workers,
        verbose = verbose
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
      tuning = tuning,
      verbose = verbose,
      fold_timeout_sec = fold_timeout_sec
    )
    results <- summarize_resample_results(
      resample_results, formula = formula, cv_scheme = cv_scheme,
      response_typology = base_params$response_typology %||% "continuous"
    )
    fits <- fit_final_benchmark_estimators(
      estimators, formula, data, coords, base_params, tuning,
      verbose = verbose
    )
    results <- augment_results_with_final_diagnostics(
      results = results,
      fits = fits,
      data = data,
      coords = coords,
      formula = formula,
      base_params = base_params,
      tuning = tuning
    )
  } else {
    # Pas de fold_timeout_sec ici non plus, meme raison que
    # fit_final_benchmark_estimators(): `fit` doit rester dans ce process pour
    # alimenter bench$fits.
    for (estimator in estimators) {
      benchmark_log(verbose, "[in-sample] %s: n=%d", estimator, nrow(data))
      elapsed_start <- proc.time()[["elapsed"]]
      params <- apply_tuned_params(base_params, tuning[[estimator]])
      fit <- tryCatch(
        fit_one_benchmark_estimator(
          estimator = estimator, formula = formula, data = data, coords = coords,
          response_typology = params$response_typology %||% "continuous",
          k_neighbors = params$k_neighbors, style = params$style, zero_policy = params$zero_policy,
          W = params$W %||% NULL,
          spboost_mstop = params$spboost_mstop, spboost_nu = params$spboost_nu,
          gamboost_mstop = params$gamboost_mstop, gamboost_nu = params$gamboost_nu,
          mgwrsar_bandwidth = params$mgwrsar_bandwidth,
          mgwrsar_kernel = params$mgwrsar_kernel,
          mgwrsar_fixed_vars = params$mgwrsar_fixed_vars,
          spmoran_enum = params$spmoran_enum,
          spmoran_vif = params$spmoran_vif,
          spatialml_bandwidth = params$spatialml_bandwidth,
          spatialml_ntree = params$spatialml_ntree,
          spatialml_mtry = params$spatialml_mtry,
          spatialrf_ntree = params$spatialrf_ntree,
          spatialrf_method = params$spatialrf_method,
          spatialrf_mtry = params$spatialrf_mtry,
          spatialrf_min_node_size = params$spatialrf_min_node_size,
          spatialrf_max_spatial_predictors = params$spatialrf_max_spatial_predictors,
          rfgls_ntree = params$rfgls_ntree,
          rfgls_mtry = params$rfgls_mtry,
          rfgls_n_neighbors = params$rfgls_n_neighbors,
          rfgls_nthsize = params$rfgls_nthsize,
          rfgls_cov_model = params$rfgls_cov_model,
          rfgls_param_estimate = params$rfgls_param_estimate
        ),
        error = function(e) e
      )
      if (inherits(fit, "error")) {
        rows[[estimator]] <- failed_benchmark_row(estimator, data, formula, fit)
        rows[[estimator]]$elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
        rows[[estimator]]$elapsed_total_sec <- rows[[estimator]]$elapsed_sec
        rows[[estimator]]$duration_sec <- rows[[estimator]]$elapsed_total_sec
        rows[[estimator]]$elapsed_sec <- NULL
        rows[[estimator]]$elapsed_total_sec <- NULL
        next
      }
      fits[[estimator]] <- fit
      diag <- tryCatch(
        diagnose_spatial(
          fit,
          data = data,
          coords = coords,
          formula = formula,
          k_neighbors = k_neighbors,
          W = W,
          style = style,
          zero_policy = zero_policy,
          include_baseline = FALSE,
          response_typology = params$response_typology %||% "continuous"
        ),
        error = function(e) e
      )
      if (inherits(diag, "error")) {
        rows[[estimator]] <- failed_benchmark_row(estimator, data, formula, diag)
        rows[[estimator]]$elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
        rows[[estimator]]$elapsed_total_sec <- rows[[estimator]]$elapsed_sec
        rows[[estimator]]$duration_sec <- rows[[estimator]]$elapsed_total_sec
        rows[[estimator]]$elapsed_sec <- NULL
        rows[[estimator]]$elapsed_total_sec <- NULL
        next
      }
      rows[[estimator]] <- normalize_diagnostic_row_for_benchmark(diag[1, , drop = FALSE], estimator)
      rows[[estimator]]$elapsed_sec <- as.numeric(proc.time()[["elapsed"]] - elapsed_start)
      rows[[estimator]]$elapsed_total_sec <- rows[[estimator]]$elapsed_sec
      rows[[estimator]]$duration_sec <- rows[[estimator]]$elapsed_total_sec
      rows[[estimator]]$elapsed_sec <- NULL
      rows[[estimator]]$elapsed_total_sec <- NULL
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
      spatial_weights_provided = !is.null(W),
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
      verbose = verbose,
      parallel = parallel,
      workers = workers,
      allow_heavy_tuning = allow_heavy_tuning,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      gamboost_mstop = gamboost_mstop,
      gamboost_nu = gamboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel,
      mgwrsar_fixed_vars = mgwrsar_fixed_vars,
      spmoran_enum = spmoran_enum,
      spmoran_vif = spmoran_vif,
      fold_timeout_sec = fold_timeout_sec
    ),
    class = "spatial_benchmark"
  )
}

benchmark_print_columns <- function(results) {
  # Colonnes utiles a l'affichage console; l'objet complet garde toutes les
  # colonnes dans $results.
  cols <- c("dataset", "estimator", "n", "response", "rmse", "mae",
            "duration_sec", "aicc", "spatial_param", "spatial_value",
            "moran_abs", "moran_p_value", "fit_error")
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
#' @param W Optional spatial weights matrix or `listw` object aligned with
#'   `data`. If omitted, eligible spatial models build a kNN structure from
#'   `coords`.
#'
#' @return A `spatial_dataset_spec` object.
#' @export
spatial_dataset_spec <- function(name, data, formula, coords, W = NULL,
                                 response_typology = NULL) {
  # Petit conteneur explicite pour benchmarker plusieurs jeux sans imposer un
  # registre interne rigide au package.
  # response_typology: "continuous" (defaut si absent)/"binary"/"count",
  # permet a benchmark_spatial_datasets() de router chaque jeu correctement
  # meme au sein d'un meme appel (suite mixte continu/binaire/comptage).
  structure(
    list(name = name, data = data, formula = formula, coords = coords, W = W,
         response_typology = response_typology),
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
                                       gamboost_mstop = 100L, gamboost_nu = 0.1,
                                       mgwrsar_bandwidth = 20, mgwrsar_kernel = "gauss",
                                       mgwrsar_fixed_vars = NULL,
                                       spmoran_enum = NULL, spmoran_vif = 10,
                                       tune = FALSE, resamples = NULL, tuning_grids = NULL,
                                       tuning_folds = 3L,
                                       cv_scheme = c(
                                         "in_sample", "holdout_10pct", "near_prediction",
                                         "block_spatial", "vfold_cv", "custom"
                                       ),
                                       eval_resamples = NULL, eval_folds = 5L,
                                       holdout_prop = 0.9,
                                       near_n_reps = 3L, near_test_size = NULL,
                                       block_folds = 5L, seed = 123L,
                                       verbose = FALSE, parallel = FALSE,
                                       workers = max(1L, parallel::detectCores(logical = FALSE) - 1L),
                                       allow_heavy_tuning = FALSE,
                                       fold_timeout_sec = NA_real_) {
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
      W = spec$W %||% NULL,
      response_typology = spec$response_typology %||% "continuous",
      estimators = estimators,
      k_neighbors = k_neighbors,
      style = style,
      zero_policy = zero_policy,
      spboost_mstop = spboost_mstop,
      spboost_nu = spboost_nu,
      gamboost_mstop = gamboost_mstop,
      gamboost_nu = gamboost_nu,
      mgwrsar_bandwidth = mgwrsar_bandwidth,
      mgwrsar_kernel = mgwrsar_kernel,
      mgwrsar_fixed_vars = mgwrsar_fixed_vars,
      spmoran_enum = spmoran_enum,
      spmoran_vif = spmoran_vif,
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
      seed = seed,
      verbose = verbose,
      parallel = parallel,
      workers = workers,
      allow_heavy_tuning = allow_heavy_tuning,
      fold_timeout_sec = fold_timeout_sec
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
