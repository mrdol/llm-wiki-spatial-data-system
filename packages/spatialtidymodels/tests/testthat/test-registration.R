test_that("les constructeurs parsnip exposent des specs", {
  skip_if_not_installed("parsnip")

  expect_s3_class(spatialreg_reg(coords = c("x", "y"), model_type = "SAR"), "spatialreg_reg")
  expect_s3_class(sar_reg(coords = c("x", "y")), "spatialreg_reg")
  expect_s3_class(sem_reg(coords = c("x", "y")), "spatialreg_reg")
  expect_s3_class(sdm_reg(coords = c("x", "y")), "spatialreg_reg")
  expect_true(is.function(fit_sar))
  expect_true(is.function(fit_sem))
  expect_true(is.function(fit_sdm))
  expect_true(is.function(diagnose_spatial))
  expect_true(is.function(benchmark_spatial))
  expect_true(is.function(available_benchmark_estimators))
  expect_true(is.function(available_benchmark_datasets))
  expect_true(is.function(benchmark_spatial_dataset))
  expect_true(is.function(make_spatial_resamples))
  expect_true(is.function(plot_near_prediction_fold))
  expect_s3_class(spboost_reg(coords = c("x", "y"), DGP = "SAR", mstop = 50), "spboost_reg")
  expect_s3_class(spboost_bspa_sar_ml(coords = c("x", "y"), mstop = 50), "spboost_reg")
  expect_s3_class(spboost_bspa_sar_cfe(coords = c("x", "y"), mstop = 50), "spboost_reg")
  expect_s3_class(spboost_bspa_sem_ml(coords = c("x", "y"), mstop = 50), "spboost_reg")
  expect_s3_class(spboost_bspa_sem_cfe(coords = c("x", "y"), mstop = 50), "spboost_reg")
  expect_s3_class(mgwrsar_reg(coords = c("x", "y"), model_type = "GWR", kernel = "gauss", bandwidth = 20), "mgwrsar_reg")
  expect_s3_class(spmoran_reg(coords = c("x", "y"), model_type = "ESF"), "spmoran_reg")
  expect_s3_class(spmoran_esf_reg(coords = c("x", "y")), "spmoran_reg")
  expect_s3_class(spmoran_resf_reg(coords = c("x", "y")), "spmoran_reg")
})

test_that("le registre benchmark distingue routes automatiques et routes a brancher", {
  registry <- available_benchmark_estimators()

  expect_true(all(c(
    "estimator", "status", "mode", "package", "backend", "automatic",
    "requires_coords", "requires_W", "spatial_args", "tunable_parameters",
    "notes", "installed"
  ) %in% names(registry)))
  expect_true(all(c(
    "ols", "gam_spatial", "gamboost", "sar_lag", "sem_error", "sdm_mixed",
    "spatialml_grf", "spatialrf", "rfgls"
  ) %in% registry$estimator))
  expect_equal(registry$package[registry$estimator == "gamboost"], "mboost")
  expect_match(registry$tunable_parameters[registry$estimator == "gamboost"], "mstop")
  expect_equal(registry$status[registry$estimator == "spboost"], "automatic")
  expect_equal(registry$package[registry$estimator == "spboost"], "spboost")
  expect_match(registry$tunable_parameters[registry$estimator == "spboost"], "mstop")
  expect_true(registry$requires_coords[registry$estimator == "sar_lag"])
  expect_true(registry$automatic[registry$estimator == "spboost"])
  expect_true(registry$automatic[registry$estimator == "spboost_bspa_sar_ml"])
  expect_true(registry$automatic[registry$estimator == "spboost_bspa_sar_cfe"])
  expect_true(registry$automatic[registry$estimator == "spboost_bspa_sem_ml"])
  expect_true(registry$automatic[registry$estimator == "spboost_bspa_sem_cfe"])
  expect_match(registry$tunable_parameters[registry$estimator == "spboost_bspa_sar_cfe"], "k_neighbors")
  expect_false(grepl("nu", registry$tunable_parameters[registry$estimator == "spboost_bspa_sar_cfe"]))
  expect_true(registry$automatic[registry$estimator == "mgwrsar_gwr"])
  expect_true(registry$automatic[registry$estimator == "mgwrsar_sar"])
  expect_true(registry$automatic[registry$estimator == "mgwrsar_mgwr"])
  expect_true(registry$automatic[registry$estimator == "mgwrsar_mgwrsar"])
  expect_true(registry$automatic[registry$estimator == "MGWRSAR_0_kc_kv"])
  expect_true(registry$automatic[registry$estimator == "MGWRSAR_1_kc_kv"])
  expect_match(registry$tunable_parameters[registry$estimator == "MGWRSAR_0_kc_kv"], "fixed_vars")
  expect_true(registry$automatic[registry$estimator == "spmoran_esf"])
  expect_true(registry$automatic[registry$estimator == "spmoran_resf"])
  expect_true(registry$automatic[registry$estimator == "spatialml_grf"])
  expect_true(registry$automatic[registry$estimator == "spatialrf"])
  expect_true(registry$automatic[registry$estimator == "rfgls"])
  expect_match(registry$backend[registry$estimator == "spatialml_grf"], "SpatialML::grf")
  expect_match(registry$backend[registry$estimator == "spatialrf"], "spatialRF::rf_spatial")
  expect_match(registry$backend[registry$estimator == "rfgls"], "RFGLS_estimate_spatial")
})

test_that("available_benchmark_estimators peut omettre la verification d'installation", {
  registry <- available_benchmark_estimators(include_installed = FALSE)

  expect_false("installed" %in% names(registry))
})

test_that("le registre dataset expose les formules confirmees", {
  datasets <- available_benchmark_datasets()

  expect_true(all(c("dataset", "data_object", "rds", "formula", "response", "predictors", "coords") %in% names(datasets)))
  expect_true(all(c("coords_crs", "formula_status", "source_ref", "recommended_cv") %in% names(datasets)))
  expect_true(all(c("columbus_crime", "london_hp") %in% datasets$dataset))
  expect_equal(
    datasets$formula[datasets$dataset == "columbus_crime"],
    "CRIME ~ HOVAL + INC"
  )
  expect_equal(
    datasets$formula[datasets$dataset == "london_hp"],
    "PURCHASE ~ FLOORSZ + PROF + BATH2"
  )
})

test_that("les datasets de benchmark sont chargeables avec data()", {
  env <- new.env(parent = emptyenv())
  loaded <- utils::data("columbus_crime", package = "spatialtidymodels", envir = env)

  expect_equal(loaded, "columbus_crime")
  expect_true(exists("columbus_crime", envir = env, inherits = FALSE))
  expect_true(all(c("CRIME", "HOVAL", "INC", "X", "Y") %in% names(env$columbus_crime)))
})

test_that("le chargement benchmark convertit les indicatrices numeriques texte", {
  dat <- load_benchmark_dataset("boston_housing")$data

  expect_true(is.numeric(dat$CHAS))
})

test_that("les grilles recommandees reduisent l'appel utilisateur MGWRSAR papier", {
  dat <- load_benchmark_dataset("columbus_crime")$data
  grids <- recommended_benchmark_tuning_grids(
    "columbus_crime",
    estimators = c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv"),
    data = dat
  )

  expect_true(all(c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv") %in% names(grids)))
  expect_true(all(c("bandwidth", "kernel", "k_neighbors", "fixed_vars") %in% names(grids$MGWRSAR_0_kc_kv)))
  expect_equal(unique(grids$MGWRSAR_0_kc_kv$kernel), "gauss")
  expect_lte(nrow(grids$MGWRSAR_0_kc_kv), 8L)
})

test_that("les grilles recommandees restent courtes sur gros dataset", {
  dat <- load_benchmark_dataset("lasrosas")$data
  grids <- recommended_benchmark_tuning_grids(
    "lasrosas",
    estimators = c("MGWRSAR_0_kc_kv"),
    data = dat
  )

  expect_equal(unique(grids$MGWRSAR_0_kc_kv$bandwidth), 20L)
  expect_equal(unique(grids$MGWRSAR_0_kc_kv$kernel), "gauss")
  expect_equal(unique(grids$MGWRSAR_0_kc_kv$k_neighbors), 8L)
  expect_lte(nrow(grids$MGWRSAR_0_kc_kv), 2L)
})

test_that("le tuning lourd de plusieurs MGWRSAR est protege sur gros dataset", {
  dat <- load_benchmark_dataset("lasrosas")$data

  expect_error(
    benchmark_spatial(
      yield ~ nitro + bv,
      data = dat,
      coords = c("X", "Y"),
      estimators = c("mgwrsar_gwr", "MGWRSAR_0_kc_kv"),
      tune = TRUE
    ),
    "Tuning lourd demande"
  )
})

test_that("les constructeurs SAR/SEM/SDM fixent le type de modele", {
  skip_if_not_installed("rlang")

  expect_equal(rlang::eval_tidy(sar_reg(coords = c("x", "y"))$args$model_type), "SAR")
  expect_equal(rlang::eval_tidy(sem_reg(coords = c("x", "y"))$args$model_type), "SEM")
  expect_equal(rlang::eval_tidy(sdm_reg(coords = c("x", "y"))$args$model_type), "SDM")
})

test_that("les constructeurs ESF/RESF fixent le type de modele", {
  skip_if_not_installed("rlang")

  expect_equal(rlang::eval_tidy(spmoran_esf_reg(coords = c("x", "y"))$args$model_type), "ESF")
  expect_equal(rlang::eval_tidy(spmoran_resf_reg(coords = c("x", "y"))$args$model_type), "RESF")
})

test_that("les constructeurs BSPA fixent DGP et methode spboost", {
  skip_if_not_installed("rlang")

  sar_ml <- spboost_bspa_sar_ml(coords = c("x", "y"))
  sar_cfe <- spboost_bspa_sar_cfe(coords = c("x", "y"))
  sem_ml <- spboost_bspa_sem_ml(coords = c("x", "y"))
  sem_cfe <- spboost_bspa_sem_cfe(coords = c("x", "y"))

  expect_equal(rlang::eval_tidy(sar_ml$args$DGP), "SAR")
  expect_equal(rlang::eval_tidy(sar_ml$args$method), "BSPA_SAR_ML")
  expect_equal(rlang::eval_tidy(sar_cfe$args$method), "BSPA_SAR_CFE")
  expect_equal(rlang::eval_tidy(sem_ml$args$DGP), "SEM")
  expect_equal(rlang::eval_tidy(sem_ml$args$method), "BSPA_SEM_ML")
  expect_equal(rlang::eval_tidy(sem_cfe$args$method), "BSPA_SEM_CFE")
})

test_that("la construction de W conserve les dimensions attendues", {
  skip_if_not_installed("nabor")
  skip_if_not_installed("Matrix")
  skip_if_not_installed("mgwrsar")

  coords <- cbind(x = 1:5, y = c(1, 2, 1, 2, 3))
  W <- build_knn_W(coords, k = 2)

  expect_equal(dim(W), c(5L, 5L))
  expect_true(inherits(W, "Matrix"))
})

test_that("les arguments spatiaux communs sont explicites", {
  args <- spatial_knn_args(
    coords = c("x", "y"),
    k_neighbors = 4,
    style = "W",
    zero_policy = TRUE
  )

  expect_s3_class(args, "spatial_knn_args")
  expect_equal(args$coords, c("x", "y"))
  expect_equal(args$k_neighbors, 4)
  expect_equal(args$style, "W")
  expect_true(args$zero_policy)
})

test_that("les parametres dials du package sont disponibles", {
  skip_if_not_installed("dials")

  expect_s3_class(mstop(), "quant_param")
  expect_s3_class(bandwidth(), "quant_param")
  expect_s3_class(k_neighbors(), "quant_param")
  expect_s3_class(spatial_kernel(), "qual_param")
  expect_s3_class(spmoran_enum(), "quant_param")
  expect_s3_class(spmoran_vif(), "quant_param")
})

test_that("les parametres dials generent des grilles standard", {
  skip_if_not_installed("dials")

  regular_grid <- dials::grid_regular(
    dials::parameters(
      mstop(range = c(50L, 100L)),
      bandwidth(range = c(10L, 20L)),
      k_neighbors(range = c(4L, 8L))
    ),
    levels = 2
  )

  expect_equal(nrow(regular_grid), 8L)
  expect_true(all(c("mstop", "bandwidth", "k_neighbors") %in% names(regular_grid)))
  expect_true(is.integer(regular_grid$mstop))
  expect_true(is.integer(regular_grid$bandwidth))
  expect_true(is.integer(regular_grid$k_neighbors))

  latin_grid <- suppressWarnings(dials::grid_latin_hypercube(
    dials::parameters(
      mstop(range = c(50L, 100L)),
      k_neighbors(range = c(4L, 8L))
    ),
    size = 3
  ))

  expect_equal(nrow(latin_grid), 3L)
  expect_true(all(c("mstop", "k_neighbors") %in% names(latin_grid)))
  expect_true(is.integer(latin_grid$mstop))
  expect_true(is.integer(latin_grid$k_neighbors))

  kernel_grid <- dials::grid_regular(
    spatial_kernel(values = c("gauss", "bisq")),
    levels = 2
  )

  expect_equal(kernel_grid$kernel, c("gauss", "bisq"))
})
