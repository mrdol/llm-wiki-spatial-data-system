make_tiny_spatial_data <- function(n = 28L) {
  set.seed(42)
  x_coord <- rep(seq_len(7), each = 4)[seq_len(n)]
  y_coord <- rep(seq_len(4), times = 7)[seq_len(n)]
  x1 <- seq_len(n) / n
  x2 <- as.integer(x_coord > stats::median(x_coord))
  y <- 1 + 2 * x1 - 0.3 * x2 + 0.05 * x_coord + 0.03 * y_coord
  data.frame(y = y, x1 = x1, x2 = x2, x_coord = x_coord, y_coord = y_coord)
}

find_repo_root_for_tests <- function() {
  # Les tests package peuvent etre lances depuis le repo, depuis le dossier du
  # package, ou depuis un dossier temporaire R CMD check. On remonte quelques
  # niveaux jusqu'a trouver le fichier de donnees attendu.
  current <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  for (i in seq_len(8L)) {
    candidate <- file.path(
      current,
      "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds"
    )
    if (file.exists(candidate)) return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  NA_character_
}

load_columbus_crime_for_tests <- function() {
  # Jeu de reference court pour verifier que les specs explicites fonctionnent
  # sur une vraie fiche dataset du pipeline, pas seulement sur des donnees jouet.
  repo_root <- find_repo_root_for_tests()
  if (is.na(repo_root)) {
    testthat::skip("columbus_crime introuvable hors du repo llm-wiki-karpathy")
  }
  path <- file.path(
    repo_root,
    "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds"
  )
  dat <- as.data.frame(readRDS(path))
  cols <- c("CRIME", "HOVAL", "INC", "X", "Y")
  dat[stats::complete.cases(dat[, cols]), cols]
}

load_london_hp_for_tests <- function(n = 80L) {
  # LondonHP a une formule hedonique confirmee dans la fiche metadata:
  # PURCHASE ~ FLOORSZ + PROF + BATH2. On l'utilise ici comme deuxieme dataset
  # de regression continue, contrairement a lsl dont la cible est binaire.
  repo_root <- find_repo_root_for_tests()
  if (is.na(repo_root)) {
    testthat::skip("LondonHP introuvable hors du repo llm-wiki-karpathy")
  }
  path <- file.path(repo_root, "data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds")
  dat <- as.data.frame(readRDS(path))
  cols <- c("PURCHASE", "FLOORSZ", "PROF", "BATH2", "X", "Y")
  dat <- dat[stats::complete.cases(dat[, cols]), cols]
  dat[seq_len(min(n, nrow(dat))), , drop = FALSE]
}

test_that("spatialreg_reg predit via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- make_tiny_spatial_data()
  train <- dat[1:22, ]
  test <- dat[23:28, ]

  spec <- spatialreg_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "SAR",
    k_neighbors = 3
  ) |>
    parsnip::set_engine("spatialreg")

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  # Sur un micro-jeu de test, spatialreg peut signaler des alias numériques
  # sans empêcher le fit; le test vérifie ici l'intégration workflow/predict.
  fit <- suppressWarnings(workflows::fit(wf, data = train))
  preds <- suppressWarnings(stats::predict(fit, new_data = test))

  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
})

test_that("sar_reg, sem_reg et sdm_reg predisent via workflow() sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  train <- dat[1:39, ]
  test <- dat[40:49, ]

  specs <- list(
    sar = sar_reg(coords = c("X", "Y"), k_neighbors = 8),
    sem = sem_reg(coords = c("X", "Y"), k_neighbors = 8),
    sdm = sdm_reg(coords = c("X", "Y"), k_neighbors = 8)
  )

  for (spec in specs) {
    wf <- workflows::workflow() |>
      workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
      workflows::add_model(parsnip::set_engine(spec, "spatialreg"))

    fit <- suppressWarnings(workflows::fit(wf, data = train))
    preds <- suppressWarnings(stats::predict(fit, new_data = test))

    expect_equal(nrow(preds), nrow(test))
    expect_true(all(is.finite(preds$.pred)))
  }
})

test_that("sar_reg accepte un W explicite au fit sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  train <- dat[1:39, ]
  test <- dat[40:49, ]
  W_train <- build_knn_listw(train[, c("X", "Y")], k = 8, style = "W", zero_policy = TRUE)

  spec <- sar_reg(
    coords = c("X", "Y"),
    W = W_train,
    k_neighbors = 8,
    style = "W",
    zero_policy = TRUE
  ) |>
    parsnip::set_engine("spatialreg")

  wf <- workflows::workflow() |>
    workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
    workflows::add_model(spec)

  fit <- suppressWarnings(workflows::fit(wf, data = train))
  preds <- suppressWarnings(stats::predict(fit, new_data = test))

  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
})

test_that("fit_sar, fit_sem et fit_sdm ajustent un workflow sans appel manuel a workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  train <- dat[1:39, ]
  test <- dat[40:49, ]

  fits <- list(
    sar = fit_sar(CRIME ~ HOVAL + INC, data = train, coords = c("X", "Y"), k_neighbors = 8),
    sem = fit_sem(CRIME ~ HOVAL + INC, data = train, coords = c("X", "Y"), k_neighbors = 8),
    sdm = fit_sdm(CRIME ~ HOVAL + INC, data = train, coords = c("X", "Y"), k_neighbors = 8)
  )

  for (fit in fits) {
    expect_s3_class(fit, "workflow")
    preds <- suppressWarnings(stats::predict(fit, new_data = test))
    expect_equal(nrow(preds), nrow(test))
    expect_true(all(is.finite(preds$.pred)))
  }
})

test_that("diagnose_spatial compare SAR et OLS sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  fit <- fit_sar(CRIME ~ HOVAL + INC, data = dat, coords = c("X", "Y"), k_neighbors = 8)

  diag <- suppressWarnings(diagnose_spatial(fit, data = dat))

  expect_true(all(c("sar_lag", "ols_baseline") %in% diag$estimator))
  expect_true(all(c("rmse", "mae", "aic", "aicc", "logLik", "moran_i", "moran_p_value") %in% names(diag)))
  expect_true(all(is.finite(diag$rmse)))
  expect_true(all(is.finite(diag$mae)))
  expect_equal(diag$spatial_param[diag$estimator == "sar_lag"], "rho")
  expect_true(is.finite(diag$spatial_value[diag$estimator == "sar_lag"]))
})

test_that("diagnose_spatial fonctionne aussi sur une baseline glm", {
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  ols <- stats::glm(CRIME ~ HOVAL + INC, data = dat)

  diag <- suppressWarnings(diagnose_spatial(
    ols,
    data = dat,
    coords = c("X", "Y"),
    formula = CRIME ~ HOVAL + INC,
    include_baseline = FALSE
  ))

  expect_equal(diag$estimator, "ols_glm")
  expect_true(is.finite(diag$rmse))
  expect_true(is.finite(diag$moran_i))
})

test_that("benchmark_spatial lance plusieurs estimateurs sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")
  skip_if_not_installed("mgcv")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c("ols", "gam_spatial", "sar_lag")
  ))

  expect_s3_class(bench, "spatial_benchmark")
  expect_equal(bench$results$estimator, c("ols", "gam_spatial", "sar_lag"))
  expect_true(all(c("rmse", "mae", "aic", "aicc", "logLik", "moran_i", "moran_p_value", "fit_error") %in% names(bench$results)))
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(c("ols", "gam_spatial", "sar_lag") %in% names(bench$fits)))
  expect_output(print(bench), "Benchmark spatial")
  expect_output(print(bench), "Fits reussis")
})

test_that("benchmark_spatial lance les baselines ML natives et leurs versions xy", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("earth")
  skip_if_not_installed("ranger")
  skip_if_not_installed("xgboost")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c(
      "earth", "earth_xy",
      "random_forest", "random_forest_xy",
      "xgboost", "xgboost_xy"
    )
  ))

  expect_s3_class(bench, "spatial_benchmark")
  expect_equal(
    bench$results$estimator,
    c("earth", "earth_xy", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
  )
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(is.finite(bench$results$mae)))
  expect_true(all(is.na(bench$results$fit_error)))
  expect_true(all(c(
    "earth", "earth_xy", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"
  ) %in% names(bench$fits)))
})

test_that("benchmark_spatial lance SpatialML GRF si le package est installe", {
  skip_if_not_installed("SpatialML")

  dat <- make_tiny_spatial_data(n = 18L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "spatialml_grf",
    mgwrsar_bandwidth = 6L
  ))

  expect_equal(bench$results$estimator, "spatialml_grf")
  expect_true(is.na(bench$results$fit_error))
  expect_true(is.finite(bench$results$rmse))
})

test_that("benchmark_spatial lance spatialRF si le package est installe", {
  skip_if_not_installed("spatialRF")

  dat <- make_tiny_spatial_data(n = 18L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "spatialrf"
  ))

  expect_equal(bench$results$estimator, "spatialrf")
  expect_true(is.na(bench$results$fit_error))
  expect_true(is.finite(bench$results$rmse))
})

test_that("spatialRF predit hors echantillon avec les predicteurs Hengl", {
  skip_if_not_installed("spatialRF")

  dat <- make_tiny_spatial_data(n = 24L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "spatialrf",
    cv_scheme = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L
  ))

  expect_equal(bench$results$estimator, "spatialrf")
  expect_equal(bench$results$n_failed_resamples, 0)
  expect_true(is.na(bench$results$fit_error))
  expect_true(all(is.finite(bench$resample_results$rmse)))
  expect_true(all(is.finite(bench$resample_results$mae)))
})

test_that("benchmark_spatial lance RandomForestsGLS si le package est installe", {
  skip_if_not_installed("RandomForestsGLS")

  dat <- make_tiny_spatial_data(n = 24L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "rfgls",
    k_neighbors = 4L
  ))

  expect_equal(bench$results$estimator, "rfgls")
  expect_true(is.na(bench$results$fit_error))
  expect_true(is.finite(bench$results$rmse))
})

test_that("benchmark_spatial tune les forets spatiales externes", {
  skip_if_not_installed("SpatialML")
  skip_if_not_installed("spatialRF")
  skip_if_not_installed("RandomForestsGLS")
  skip_if_not_installed("rsample")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c("spatialml_grf", "spatialrf", "rfgls"),
    tune = TRUE,
    tuning_folds = 2L,
    tuning_grids = list(
      spatialml_grf = data.frame(
        bandwidth = c(8L, 12L),
        ntree = c(20L, 20L),
        mtry = c(1L, 2L)
      ),
      spatialrf = data.frame(
        method = c("hengl", "hengl"),
        ntree = c(20L, 20L),
        mtry = c(1L, 2L),
        max_spatial_predictors = c(5L, 10L)
      ),
      rfgls = data.frame(
        ntree = c(20L, 20L),
        mtry = c(1L, 2L),
        k_neighbors = c(4L, 8L),
        nthsize = c(10L, 10L),
        cov_model = c("exponential", "exponential"),
        param_estimate = c(FALSE, FALSE)
      )
    ),
    cv_scheme = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 8L
  ))

  expect_true(all(c("spatialml_grf", "spatialrf", "rfgls") %in% names(bench$tuning)))
  expect_true(all(vapply(bench$tuning, function(x) nrow(x$grid) >= 1L, logical(1L))))
  expect_true(all(is.finite(bench$results$duration_sec)))
})

test_that("benchmark_spatial lance et tune gamboost", {
  skip_if_not_installed("mboost")
  skip_if_not_installed("rsample")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "gamboost",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(gamboost = data.frame(mstop = c(5L, 10L))),
    gamboost_nu = 0.1
  ))

  expect_equal(bench$results$estimator, "gamboost")
  expect_true("gamboost" %in% names(bench$tuning))
  expect_true(bench$tuning$gamboost$params$gamboost_mstop %in% c(5L, 10L))
  expect_true(all(is.finite(bench$tuning$gamboost$grid$rmse)))
  expect_true(is.na(bench$results$fit_error))
  expect_true(is.finite(bench$results$rmse))
})

test_that("benchmark_spatial lance spboost et les variantes mgwrsar sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")
  skip_if_not_installed("mgwrsar")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c("spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar"),
    spboost_mstop = 20,
    mgwrsar_bandwidth = 20
  ))

  expect_equal(bench$results$estimator, c("spboost", "mgwrsar_gwr", "mgwrsar_sar", "mgwrsar_mgwr", "mgwrsar_mgwrsar"))
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(is.na(bench$results$fit_error)))
})

test_that("benchmark_spatial lance les quatre variantes BSPA spboost", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 16L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = c(
      "spboost_bspa_sar_ml", "spboost_bspa_sar_cfe",
      "spboost_bspa_sem_ml", "spboost_bspa_sem_cfe"
    ),
    spboost_mstop = 5,
    spboost_nu = 0.1,
    k_neighbors = 4
  ))

  expect_equal(
    bench$results$estimator,
    c("spboost_bspa_sar_ml", "spboost_bspa_sar_cfe", "spboost_bspa_sem_ml", "spboost_bspa_sem_cfe")
  )
  expect_true(all(is.na(bench$results$fit_error)))
})

test_that("benchmark_spatial extrait rho et lambda pour SpBoost", {
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 24L)
  estimators <- c(
    "spboost_bspa_sar_ml",
    "spboost_bspa_sar_cfe",
    "spboost_bspa_sem_ml",
    "spboost_bspa_sem_cfe"
  )

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = estimators,
    cv_scheme = "in_sample",
    spboost_mstop = 80L,
    k_neighbors = 4L
  ))

  expect_equal(bench$results$estimator, estimators)
  expect_equal(bench$results$spatial_param, c("rho", "rho", "lambda", "lambda"))
  expect_true(all(is.finite(bench$results$spatial_value)))
})

test_that("benchmark_spatial extrait lambda pour les variantes MGWRSAR autocorrelees", {
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 24L)
  estimators <- c("mgwrsar_sar", "mgwrsar_mgwrsar", "MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = estimators,
    cv_scheme = "in_sample",
    mgwrsar_bandwidth = 6L,
    mgwrsar_fixed_vars = "x2",
    k_neighbors = 4L
  ))

  expect_equal(bench$results$estimator, estimators)
  expect_equal(
    bench$results$spatial_param,
    c("lambda", "lambda", "lambda", "lambda_local_mean")
  )
  expect_true(all(is.finite(bench$results$spatial_value)))
})

test_that("benchmark_spatial laisse NA pour les modeles sans parametre spatial scalaire", {
  skip_if_not_installed("SpatialML")
  skip_if_not_installed("spatialRF")

  dat <- make_tiny_spatial_data(n = 24L)
  estimators <- c("ols", "random_forest", "spatialml_grf", "spatialrf")

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = estimators,
    cv_scheme = "in_sample",
    mgwrsar_bandwidth = 6L
  ))

  expect_equal(bench$results$estimator, estimators)
  expect_true(all(is.na(bench$results$spatial_param)))
  expect_true(all(is.na(bench$results$spatial_value)))
})

test_that("les quatre variantes BSPA spboost passent en workflow sur Columbus et Boston", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  variants <- list(
    spboost_bspa_sar_ml = spboost_bspa_sar_ml,
    spboost_bspa_sar_cfe = spboost_bspa_sar_cfe,
    spboost_bspa_sem_ml = spboost_bspa_sem_ml,
    spboost_bspa_sem_cfe = spboost_bspa_sem_cfe
  )

  datasets <- list(
    columbus = list(
      data = load_columbus_crime_for_tests(),
      formula = CRIME ~ HOVAL + INC + X + Y,
      coords = c("X", "Y"),
      train = 1:40,
      test = 41:49
    ),
    boston = {
      loaded <- load_benchmark_dataset("boston_housing")
      dat <- loaded$data[1:70, , drop = FALSE]
      list(
        data = dat,
        formula = CMEDV ~ CRIM + RM + LSTAT + X + Y,
        coords = c("X", "Y"),
        train = 1:55,
        test = 56:70
      )
    }
  )

  for (dataset_name in names(datasets)) {
    setup <- datasets[[dataset_name]]
    train <- setup$data[setup$train, , drop = FALSE]
    test <- setup$data[setup$test, , drop = FALSE]

    for (variant_name in names(variants)) {
      spec <- variants[[variant_name]](
        coords = setup$coords,
        mstop = 10L,
        nu = 0.1,
        k_neighbors = 4L
      ) |>
        parsnip::set_engine("spboost")

      wf <- workflows::workflow() |>
        workflows::add_formula(setup$formula) |>
        workflows::add_model(spec)

      fit <- suppressWarnings(workflows::fit(wf, data = train))
      preds <- suppressWarnings(stats::predict(fit, new_data = test))

      expect_equal(
        nrow(preds),
        nrow(test),
        info = paste(dataset_name, variant_name)
      )
      expect_true(
        all(is.finite(preds$.pred)),
        info = paste(dataset_name, variant_name)
      )
    }
  }
})

test_that("benchmark_spatial lance spmoran ESF et RESF sur columbus_crime", {
  skip_if_not_installed("spmoran")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressMessages(suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c("spmoran_esf", "spmoran_resf")
  )))

  expect_equal(bench$results$estimator, c("spmoran_esf", "spmoran_resf"))
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(is.finite(bench$results$mae)))
  expect_true(all(is.na(bench$results$fit_error)))

  preds <- stats::predict(bench$fits$spmoran_esf, new_data = dat[1:5, , drop = FALSE])
  expect_equal(nrow(preds), 5L)
  expect_true(all(is.finite(preds$.pred)))
})

test_that("benchmark_spatial score spmoran ESF en holdout", {
  skip_if_not_installed("spmoran")
  skip_if_not_installed("rsample")

  bench <- suppressMessages(suppressWarnings(benchmark_spatial_dataset(
    "columbus_crime",
    estimators = "spmoran_esf",
    cv_scheme = "holdout_10pct",
    seed = 42
  )))

  expect_equal(bench$results$estimator, "spmoran_esf")
  expect_equal(bench$results$n_resamples, 1L)
  expect_true(is.finite(bench$results$rmse))
  expect_true(is.finite(bench$results$mae))
  expect_true(is.na(bench$results$fit_error))
})

test_that("spmoran_esf_reg predit via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spmoran")

  dat <- load_columbus_crime_for_tests()
  spec <- spmoran_esf_reg(coords = c("X", "Y"), vif = 10) |>
    parsnip::set_engine("spmoran") |>
    parsnip::set_mode("regression")
  fit <- suppressWarnings(workflows::workflow() |>
    workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
    workflows::add_model(spec) |>
    workflows::fit(dat))

  preds <- stats::predict(fit, new_data = dat[1:5, , drop = FALSE])
  expect_equal(nrow(preds), 5L)
  expect_true(all(is.finite(preds$.pred)))
})

test_that("spmoran_resf_reg predit via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spmoran")

  dat <- load_columbus_crime_for_tests()
  spec <- spmoran_resf_reg(coords = c("X", "Y")) |>
    parsnip::set_engine("spmoran") |>
    parsnip::set_mode("regression")
  fit <- suppressWarnings(workflows::workflow() |>
    workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
    workflows::add_model(spec) |>
    workflows::fit(dat))

  preds <- stats::predict(fit, new_data = dat[1:5, , drop = FALSE])
  expect_equal(nrow(preds), 5L)
  expect_true(all(is.finite(preds$.pred)))
})

test_that("spmoran_esf_reg et spmoran_resf_reg passent par parsnip::fit()", {
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spmoran")

  dat <- load_columbus_crime_for_tests()[1:30, , drop = FALSE]

  specs <- list(
    esf = spmoran_esf_reg(coords = c("X", "Y"), enum = 8L, vif = 10),
    resf = spmoran_resf_reg(coords = c("X", "Y"), enum = 8L)
  )

  for (spec_name in names(specs)) {
    fit <- suppressMessages(suppressWarnings(parsnip::fit(
      parsnip::set_engine(specs[[spec_name]], "spmoran"),
      CRIME ~ HOVAL + INC + X + Y,
      data = dat
    )))
    preds <- stats::predict(fit, new_data = dat[1:5, , drop = FALSE])

    expect_s3_class(fit, "model_fit")
    expect_s3_class(fit, "_spmoran_fit")
    expect_equal(nrow(preds), 5L, info = spec_name)
    expect_true(all(is.finite(preds$.pred)), info = spec_name)
  }
})

test_that("spmoran ESF supporte tune_grid() sur enum et vif", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spmoran")
  skip_if_not_installed("rsample")
  skip_if_not_installed("tune")
  skip_if_not_installed("yardstick")

  set.seed(42)
  dat <- load_columbus_crime_for_tests()
  spec <- spmoran_esf_reg(coords = c("X", "Y"), enum = tune::tune(), vif = tune::tune()) |>
    parsnip::set_engine("spmoran") |>
    parsnip::set_mode("regression")
  wf <- workflows::workflow() |>
    workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
    workflows::add_model(spec)
  folds <- rsample::mc_cv(dat, prop = 0.9, times = 2)

  tuned <- suppressMessages(suppressWarnings(tune::tune_grid(
    wf,
    resamples = folds,
    grid = expand.grid(enum = c(5L, 8L), vif = c(5, 10), KEEP.OUT.ATTRS = FALSE),
    metrics = yardstick::metric_set(yardstick::rmse)
  )))
  metrics <- tune::collect_metrics(tuned)

  expect_true(all(c("enum", "vif") %in% names(metrics)))
  expect_true(all(is.finite(metrics$mean)))
})

test_that("spmoran RESF supporte tune_grid() sur enum", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spmoran")
  skip_if_not_installed("rsample")
  skip_if_not_installed("tune")
  skip_if_not_installed("yardstick")

  set.seed(42)
  dat <- load_columbus_crime_for_tests()
  spec <- spmoran_resf_reg(coords = c("X", "Y"), enum = tune::tune()) |>
    parsnip::set_engine("spmoran") |>
    parsnip::set_mode("regression")
  wf <- workflows::workflow() |>
    workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
    workflows::add_model(spec)
  folds <- rsample::mc_cv(dat, prop = 0.9, times = 2)

  tuned <- suppressMessages(suppressWarnings(tune::tune_grid(
    wf,
    resamples = folds,
    grid = data.frame(enum = c(5L, 8L)),
    metrics = yardstick::metric_set(yardstick::rmse)
  )))
  metrics <- tune::collect_metrics(tuned)

  expect_true("enum" %in% names(metrics))
  expect_true(all(is.finite(metrics$mean)))
})

test_that("benchmark_spatial tune spmoran ESF et RESF", {
  skip_if_not_installed("spmoran")
  skip_if_not_installed("rsample")
  skip_if_not_installed("tune")
  skip_if_not_installed("yardstick")

  set.seed(42)
  dat <- load_columbus_crime_for_tests()
  tuning_resamples <- rsample::mc_cv(dat, prop = 0.9, times = 2)
  bench <- suppressMessages(suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = c("spmoran_esf", "spmoran_resf"),
    tune = TRUE,
    resamples = tuning_resamples,
    tuning_grids = list(
      spmoran_esf = expand.grid(enum = c(5L, 8L), vif = c(5, 10), KEEP.OUT.ATTRS = FALSE),
      spmoran_resf = data.frame(enum = c(5L, 8L))
    )
  )))

  expect_equal(names(bench$tuning), c("spmoran_esf", "spmoran_resf"))
  expect_null(bench$tuning$spmoran_esf$error)
  expect_null(bench$tuning$spmoran_resf$error)
  expect_true(all(is.finite(bench$results$rmse)))
  expect_length(bench$tuning$spmoran_esf$params$spmoran_enum, 1L)
  expect_length(bench$tuning$spmoran_resf$params$spmoran_enum, 1L)
  expect_length(bench$tuning$spmoran_esf$params$spmoran_vif, 1L)
  expect_true(is.finite(as.numeric(bench$tuning$spmoran_esf$params$spmoran_enum)))
  expect_true(is.finite(as.numeric(bench$tuning$spmoran_resf$params$spmoran_enum)))
  expect_true(is.finite(as.numeric(bench$tuning$spmoran_esf$params$spmoran_vif)))
})

test_that("spmoran valide les arguments utilisateur", {
  skip_if_not_installed("spmoran")

  dat <- load_columbus_crime_for_tests()[1:30, , drop = FALSE]
  expect_error(
    spmoran_fit_impl(CRIME ~ HOVAL + INC, dat, coords = c("X", "Y"), model_type = "bad"),
    "`model_type` must be 'ESF' or 'RESF'",
    fixed = TRUE
  )
  expect_error(
    spmoran_fit_impl(CRIME ~ HOVAL + INC, dat, coords = c("X", "Y"), enum = 0),
    "`enum` must be a positive integer or NULL",
    fixed = TRUE
  )
  expect_error(
    spmoran_fit_impl(CRIME ~ HOVAL + INC, dat, coords = c("X", "Y"), vif = 0),
    "`vif` must be a positive finite number",
    fixed = TRUE
  )
})

test_that("benchmark_spatial_datasets combine columbus_crime et london_hp", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  columbus <- load_columbus_crime_for_tests()
  london_hp <- load_london_hp_for_tests(n = 80L)

  bench <- suppressWarnings(benchmark_spatial_datasets(
    datasets = list(
      spatial_dataset_spec("columbus_crime", columbus, CRIME ~ HOVAL + INC, c("X", "Y")),
      spatial_dataset_spec("london_hp", london_hp, PURCHASE ~ FLOORSZ + PROF + BATH2, c("X", "Y"))
    ),
    estimators = c("ols", "sar_lag"),
    k_neighbors = 6
  ))

  expect_s3_class(bench, "spatial_benchmark_set")
  expect_true(all(c("columbus_crime", "london_hp") %in% bench$results$dataset))
  expect_true(all(c("ols", "sar_lag") %in% bench$results$estimator))
  expect_true(all(is.finite(bench$results$rmse)))
  expect_output(print(bench), "Benchmark spatial multi-dataset")
  expect_output(print(bench), "columbus_crime")
})

test_that("benchmark_spatial_dataset recupere formule et coordonnees du registre", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  bench <- suppressWarnings(benchmark_spatial_dataset(
    "columbus_crime",
    estimators = c("ols", "sar_lag"),
    k_neighbors = 6
  ))

  expect_s3_class(bench, "spatial_benchmark")
  expect_equal(bench$dataset, "columbus_crime")
  expect_equal(deparse(bench$formula), "CRIME ~ HOVAL + INC")
  expect_equal(bench$coords, c("X", "Y"))
  expect_true(all(c("ols", "sar_lag") %in% bench$results$estimator))
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("benchmark_spatial_dataset score les estimateurs en vfold_cv", {
  skip_if_not_installed("rsample")

  bench <- suppressWarnings(benchmark_spatial_dataset(
    "columbus_crime",
    estimators = "ols",
    cv_scheme = "vfold_cv",
    eval_folds = 3
  ))

  expect_s3_class(bench, "spatial_benchmark")
  expect_equal(bench$cv_scheme, "vfold_cv")
  expect_equal(bench$results$estimator, "ols")
  expect_equal(bench$results$n_resamples, 3)
  expect_true(is.finite(bench$results$rmse))
  expect_true(is.finite(bench$results$mae))
  expect_equal(nrow(bench$resample_results), 3)
  expect_true(all(c("id", "n_train", "n_test", "rmse", "mae") %in% names(bench$resample_results)))
  expect_true(all(is.finite(bench$resample_results$rmse)))
})

test_that("make_spatial_resamples construit un holdout de 10 pourcent", {
  skip_if_not_installed("rsample")

  dat <- load_columbus_crime_for_tests()
  rset <- make_spatial_resamples(
    data = dat,
    coords = c("X", "Y"),
    cv_scheme = "holdout_10pct",
    seed = 42
  )

  expect_equal(nrow(rset), 1L)
  expect_equal(rset$id, "holdout")
  expect_equal(nrow(rsample::assessment(rset$splits[[1]])), 5L)
})

test_that("benchmark_spatial_dataset score un holdout de 10 pourcent", {
  skip_if_not_installed("rsample")

  bench <- suppressWarnings(benchmark_spatial_dataset(
    "columbus_crime",
    estimators = c("ols", "random_forest"),
    cv_scheme = "holdout_10pct",
    seed = 42
  ))

  expect_equal(bench$cv_scheme, "holdout_10pct")
  expect_equal(nrow(bench$resample_results), 2L)
  expect_true(all(is.finite(bench$results$rmse)))
  expect_true(all(bench$results$n_resamples == 1L))
})

test_that("benchmark_spatial_dataset score la near-prediction", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("mgwrsar")

  bench <- suppressWarnings(benchmark_spatial_dataset(
    "columbus_crime",
    estimators = "ols",
    cv_scheme = "near_prediction",
    near_n_reps = 2,
    near_test_size = 10,
    seed = 42
  ))

  expect_equal(bench$cv_scheme, "near_prediction")
  expect_equal(bench$results$n_resamples, 2L)
  expect_equal(nrow(bench$resample_results), 2L)
  expect_true(all(is.finite(bench$resample_results$rmse)))

  meta <- attr(bench$eval_resamples, "near_cv_meta")
  expect_true(all(c("test_indices", "cell_id", "k_leaf", "requested_test_size") %in% names(meta)))
  expect_equal(meta$requested_test_size, 10L)

  all_test <- unlist(meta$test_indices, use.names = FALSE)
  expect_equal(anyDuplicated(all_test), 0L)
  expect_true(all(vapply(meta$test_indices, function(test) {
    identical(sort(meta$cell_id[test]), seq_len(attr(bench$eval_resamples, "near_cv")$n_cells))
  }, logical(1L))))
})

test_that("benchmark_spatial enregistre le temps de calcul", {
  dat <- make_tiny_spatial_data(n = 24L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = c("ols", "random_forest"),
    cv_scheme = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L
  ))

  expect_true("duration_sec" %in% names(bench$results))
  expect_true("elapsed_sec" %in% names(bench$resample_results))
  expect_false("elapsed_sec" %in% names(bench$results))
  expect_false("elapsed_sec_sd" %in% names(bench$results))
  expect_false("elapsed_total_sec" %in% names(bench$results))
  expect_true(all(is.finite(bench$results$duration_sec)))
  expect_true(all(is.finite(bench$resample_results$elapsed_sec)))
})

test_that("benchmark_spatial propage les diagnostics du fit final en validation croisee", {
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 24L)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "spboost_bspa_sar_ml",
    cv_scheme = "near_prediction",
    near_n_reps = 2L,
    near_test_size = 4L,
    spboost_mstop = 40L,
    k_neighbors = 4L
  ))

  expect_equal(bench$results$spatial_param, "rho")
  expect_true(is.finite(bench$results$spatial_value))
  expect_true(is.finite(bench$results$logLik))
})

test_that("plot_near_prediction_fold visualise un rset near-prediction", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("mgwrsar")
  skip_if_not_installed("ggplot2")

  dat <- load_columbus_crime_for_tests()
  rset <- make_spatial_resamples(
    data = dat,
    coords = c("X", "Y"),
    cv_scheme = "near_prediction",
    near_n_reps = 2,
    near_test_size = 10,
    seed = 42
  )

  p <- plot_near_prediction_fold(rset, data = dat, coords = c("X", "Y"), fold = "rep_1")
  expect_s3_class(p, "ggplot")
})

test_that("les visualisations benchmark package retournent des ggplot", {
  skip_if_not_installed("ggplot2")

  results <- data.frame(
    estimator = c("ols", "sar_lag"),
    cv_scheme = c("near_prediction", "near_prediction"),
    rmse = c(10, 8),
    mae = c(7, 6)
  )
  tuning <- data.frame(
    bandwidth = c(20L, 40L),
    kernel = c("gauss", "gauss"),
    rmse = c(9, 7),
    mae = c(6, 5)
  )

  expect_s3_class(plot_benchmark_comparison(results, metric = "rmse"), "ggplot")
  expect_s3_class(plot_tuning_curve(tuning, x = "bandwidth", color = "kernel"), "ggplot")
})

test_that("plot_spatial_predictions visualise predictions et residus", {
  skip_if_not_installed("ggplot2")

  dat <- load_columbus_crime_for_tests()
  fit <- stats::glm(CRIME ~ HOVAL + INC, data = dat)

  expect_s3_class(plot_spatial_predictions(fit, dat, coords = c("X", "Y")), "ggplot")
  expect_s3_class(
    plot_spatial_predictions(fit, dat, coords = c("X", "Y"), truth = "CRIME", type = "residual"),
    "ggplot"
  )
})

test_that("make_spatial_resamples construit des blocs spatiaux si blockCV est disponible", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("blockCV")
  skip_if_not_installed("sf")

  dat <- load_columbus_crime_for_tests()
  rset <- suppressWarnings(make_spatial_resamples(
    data = dat,
    coords = c("X", "Y"),
    cv_scheme = "block_spatial",
    block_folds = 3,
    seed = 42
  ))

  expect_equal(nrow(rset), 3L)
  expect_true(all(grepl("^block", rset$id)))
})

test_that("benchmark_spatial_registered_datasets lance plusieurs datasets par nom", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  bench <- suppressWarnings(benchmark_spatial_registered_datasets(
    datasets = c("columbus_crime", "london_hp"),
    estimators = "ols"
  ))

  expect_s3_class(bench, "spatial_benchmark_set")
  expect_true(all(c("columbus_crime", "london_hp") %in% bench$results$dataset))
  expect_equal(unique(bench$results$estimator), "ols")
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("spmoran n'est plus classe comme route non automatisee", {
  registry <- available_benchmark_estimators()

  expect_true(registry$automatic[registry$estimator == "spmoran_esf"])
  expect_true(registry$automatic[registry$estimator == "spmoran_resf"])
})

test_that("benchmark_spatial signale les noms inconnus avec le registre", {
  dat <- load_columbus_crime_for_tests()

  expect_error(
    benchmark_spatial(
      CRIME ~ HOVAL + INC,
      data = dat,
      coords = c("X", "Y"),
      estimators = "modele_inexistant"
    ),
    "available_benchmark_estimators"
  )
})

test_that("benchmark_spatial tune k_neighbors pour SAR", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "sar_lag",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(sar_lag = data.frame(k_neighbors = c(4L, 8L)))
  ))

  expect_true(isTRUE(bench$tune))
  expect_true("sar_lag" %in% names(bench$tuning))
  expect_true(bench$tuning$sar_lag$params$k_neighbors %in% c(4L, 8L))
  expect_true(all(is.finite(bench$tuning$sar_lag$grid$rmse)))
  expect_true(all(is.na(bench$results$fit_error)))
  expect_output(print(bench), "Tuning")
})

test_that("benchmark_spatial tune mstop pour spboost", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 18L)
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "spboost",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(spboost = data.frame(mstop = c(10L, 20L)))
  ))

  expect_true("spboost" %in% names(bench$tuning))
  expect_true(bench$tuning$spboost$params$spboost_mstop %in% c(10L, 20L))
  expect_true(all(is.finite(bench$tuning$spboost$grid$rmse)))
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("benchmark_spatial tune bandwidth avec kernel gauss fixe pour mgwrsar_gwr", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 18L)
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    y ~ x1 + x2,
    data = dat,
    coords = c("x_coord", "y_coord"),
    estimators = "mgwrsar_gwr",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(mgwrsar_gwr = data.frame(
      bandwidth = c(4L, 5L),
      kernel = c("bisq", "gauss")
    ))
  ))

  expect_true("mgwrsar_gwr" %in% names(bench$tuning))
  expect_true(bench$tuning$mgwrsar_gwr$params$mgwrsar_bandwidth %in% c(4L, 5L))
  expect_equal(bench$tuning$mgwrsar_gwr$params$mgwrsar_kernel, "gauss")
  expect_equal(unique(bench$tuning$mgwrsar_gwr$grid$kernel), "gauss")
  expect_true(all(is.finite(bench$tuning$mgwrsar_gwr$grid$rmse)))
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("benchmark_spatial tune MGWRSAR autocorrele avec W fold-specifique", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("mgwrsar")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "mgwrsar_mgwrsar",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(mgwrsar_mgwrsar = data.frame(
      bandwidth = c(8L, 12L),
      kernel = c("gauss", "gauss")
    )),
    k_neighbors = 4
  ))

  expect_true("mgwrsar_mgwrsar" %in% names(bench$tuning))
  expect_null(bench$tuning$mgwrsar_mgwrsar$tune_result)
  expect_true(bench$tuning$mgwrsar_mgwrsar$params$mgwrsar_bandwidth %in% c(8L, 12L))
  expect_equal(bench$tuning$mgwrsar_mgwrsar$params$mgwrsar_kernel, "gauss")
  expect_true(all(c("n_ok", "n_failed") %in% names(bench$tuning$mgwrsar_mgwrsar$grid)))
  expect_true(all(is.finite(bench$tuning$mgwrsar_mgwrsar$grid$rmse)))
})

test_that("benchmark_spatial tune MGWRSAR_0_kc_kv avec W_opt et fixed_vars", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("mgwrsar")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "MGWRSAR_0_kc_kv",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(MGWRSAR_0_kc_kv = data.frame(
      bandwidth = c(8L, 12L),
      kernel = c("gauss", "gauss"),
      k_neighbors = c(4L, 8L),
      fixed_vars = c("HOVAL", "INC")
    ))
  ))

  expect_true("MGWRSAR_0_kc_kv" %in% names(bench$tuning))
  expect_null(bench$tuning$MGWRSAR_0_kc_kv$tune_result)
  expect_true(bench$tuning$MGWRSAR_0_kc_kv$params$k_neighbors %in% c(4L, 8L))
  expect_true(bench$tuning$MGWRSAR_0_kc_kv$params$mgwrsar_bandwidth %in% c(8L, 12L))
  expect_true(bench$tuning$MGWRSAR_0_kc_kv$params$mgwrsar_fixed_vars %in% c("HOVAL", "INC"))
  expect_true(all(c("fixed_vars", "k_neighbors", "n_ok", "n_failed") %in% names(bench$tuning$MGWRSAR_0_kc_kv$grid)))
  expect_true(all(is.finite(bench$tuning$MGWRSAR_0_kc_kv$grid$rmse)))
  expect_true(all(is.finite(bench$results$rmse)))
})

test_that("benchmark_spatial lance MGWRSAR_1_kc_kv avec fixed_vars explicite", {
  skip_if_not_installed("mgwrsar")

  dat <- load_columbus_crime_for_tests()

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "MGWRSAR_1_kc_kv",
    k_neighbors = 4L,
    mgwrsar_bandwidth = 8L,
    mgwrsar_kernel = "gauss",
    mgwrsar_fixed_vars = "HOVAL"
  ))

  expect_equal(bench$results$estimator, "MGWRSAR_1_kc_kv")
  expect_true(is.na(bench$results$fit_error))
  expect_true(is.finite(bench$results$rmse))
})

test_that("benchmark_spatial tune MGWRSAR_1_kc_kv sur bandwidth et k_neighbors", {
  skip_if_not_installed("rsample")
  skip_if_not_installed("mgwrsar")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  bench <- suppressWarnings(benchmark_spatial(
    CRIME ~ HOVAL + INC,
    data = dat,
    coords = c("X", "Y"),
    estimators = "MGWRSAR_1_kc_kv",
    tune = TRUE,
    resamples = folds,
    tuning_grids = list(MGWRSAR_1_kc_kv = data.frame(
      bandwidth = c(8L, 12L),
      kernel = c("gauss", "gauss"),
      k_neighbors = c(4L, 8L),
      fixed_vars = c("HOVAL", "INC")
    ))
  ))

  expect_true("MGWRSAR_1_kc_kv" %in% names(bench$tuning))
  expect_true(bench$tuning$MGWRSAR_1_kc_kv$params$k_neighbors %in% c(4L, 8L))
  expect_true(bench$tuning$MGWRSAR_1_kc_kv$params$mgwrsar_bandwidth %in% c(8L, 12L))
  expect_equal(unique(bench$tuning$MGWRSAR_1_kc_kv$grid$kernel), "gauss")
  expect_true(all(is.finite(bench$tuning$MGWRSAR_1_kc_kv$grid$rmse)))
})

test_that("spatialreg_reg passe dans tune_grid() sur k_neighbors", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- make_tiny_spatial_data()
  folds <- rsample::vfold_cv(dat, v = 2)

  spec <- spatialreg_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "SAR",
    k_neighbors = tune::tune()
  ) |>
    parsnip::set_engine("spatialreg")

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  res <- tune::tune_grid(
    wf,
    resamples = folds,
    grid = data.frame(k_neighbors = c(2L, 3L)),
    metrics = yardstick::metric_set(yardstick::rmse),
    control = tune::control_grid(save_pred = TRUE)
  )

  metrics <- tune::collect_metrics(res)
  expect_true(all(c("k_neighbors", "mean") %in% names(metrics)))
  expect_true(all(is.finite(metrics$mean)))
})

test_that("sar_reg, sem_reg et sdm_reg passent dans tune_grid() sur columbus_crime", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("spatialreg")
  skip_if_not_installed("spdep")

  dat <- load_columbus_crime_for_tests()
  folds <- rsample::vfold_cv(dat, v = 2)

  specs <- list(
    sar = sar_reg(coords = c("X", "Y"), k_neighbors = tune::tune()),
    sem = sem_reg(coords = c("X", "Y"), k_neighbors = tune::tune()),
    sdm = sdm_reg(coords = c("X", "Y"), k_neighbors = tune::tune())
  )

  for (spec in specs) {
    wf <- workflows::workflow() |>
      workflows::add_formula(CRIME ~ HOVAL + INC + X + Y) |>
      workflows::add_model(parsnip::set_engine(spec, "spatialreg"))

    res <- suppressWarnings(tune::tune_grid(
      wf,
      resamples = folds,
      grid = data.frame(k_neighbors = c(4L, 8L)),
      metrics = yardstick::metric_set(yardstick::rmse),
      control = tune::control_grid(save_pred = TRUE)
    ))

    metrics <- tune::collect_metrics(res)
    expect_true(all(c("k_neighbors", "mean") %in% names(metrics)))
    expect_true(all(is.finite(metrics$mean)))
  }
})

test_that("mgwrsar_reg predit via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 16L)
  train <- dat[1:12, ]
  test <- dat[13:16, ]

  spec <- mgwrsar_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "GWR",
    kernel = "gauss",
    bandwidth = 4
  ) |>
    parsnip::set_engine("mgwrsar")

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  fit <- suppressWarnings(workflows::fit(wf, data = train))
  preds <- stats::predict(fit, new_data = test)

  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
})

test_that("mgwrsar_reg couvre GWR, TDS-MGWR et les modeles kc/kv via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 20L)
  train <- dat[1:16, ]
  test <- dat[17:20, ]

  specs <- list(
    mgwrsar_gwr = mgwrsar_reg(
      coords = c("x_coord", "y_coord"),
      model_type = "GWR",
      kernel = "gauss",
      bandwidth = 5L
    ),
    mgwrsar_mgwr = mgwrsar_reg(
      coords = c("x_coord", "y_coord"),
      model_type = "tds_mgwr",
      kernel = "gauss"
    ),
    MGWRSAR_0_kc_kv = mgwrsar_reg(
      coords = c("x_coord", "y_coord"),
      model_type = "MGWRSAR_0_kc_kv",
      kernel = "gauss",
      bandwidth = 5L,
      fixed_vars = "x1"
    ),
    MGWRSAR_1_kc_kv = mgwrsar_reg(
      coords = c("x_coord", "y_coord"),
      model_type = "MGWRSAR_1_kc_kv",
      kernel = "gauss",
      bandwidth = 5L,
      fixed_vars = "x1"
    )
  )

  for (spec_name in names(specs)) {
    wf <- workflows::workflow() |>
      workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
      workflows::add_model(parsnip::set_engine(specs[[spec_name]], "mgwrsar"))

    fit <- suppressWarnings(workflows::fit(wf, data = train))
    preds <- suppressWarnings(stats::predict(fit, new_data = test))

    expect_equal(nrow(preds), nrow(test), info = spec_name)
    expect_true(all(is.finite(preds$.pred)), info = spec_name)
  }
})

test_that("mgwrsar_reg securise bandwidth et fixed_vars", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 18L)

  bad_bandwidth <- mgwrsar_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "GWR",
    kernel = "gauss",
    bandwidth = c(4L, 5L)
  ) |>
    parsnip::set_engine("mgwrsar")

  bad_fixed_unknown <- mgwrsar_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "MGWRSAR_0_kc_kv",
    kernel = "gauss",
    bandwidth = 5L,
    fixed_vars = "missing_x"
  ) |>
    parsnip::set_engine("mgwrsar")

  bad_fixed_all <- mgwrsar_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "MGWRSAR_1_kc_kv",
    kernel = "gauss",
    bandwidth = 5L,
    fixed_vars = c("x1", "x2")
  ) |>
    parsnip::set_engine("mgwrsar")

  expect_error(
    workflows::workflow() |>
      workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
      workflows::add_model(bad_bandwidth) |>
      workflows::fit(data = dat),
    "bandwidth.*scalar"
  )
  expect_error(
    workflows::workflow() |>
      workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
      workflows::add_model(bad_fixed_unknown) |>
      workflows::fit(data = dat),
    "Unknown: missing_x"
  )
  expect_error(
    workflows::workflow() |>
      workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
      workflows::add_model(bad_fixed_all) |>
      workflows::fit(data = dat),
    "at least one non-stationary"
  )
})

test_that("mgwrsar SAR conserve une W train/test coherente pour predict()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 16L)
  train <- dat[1:12, ]
  test <- dat[13:16, ]
  coords <- c("x_coord", "y_coord")
  W_train_test <- build_knn_W(rbind(train[, coords], test[, coords]), k = 3, sparse = TRUE)
  W_train <- mgwrsar::normW(W_train_test[seq_len(nrow(train)), seq_len(nrow(train)), drop = FALSE])

  spec <- mgwrsar_reg(
    coords = coords,
    model_type = "SAR"
  ) |>
    parsnip::set_engine("mgwrsar", control = list(
      W = W_train,
      W_predict = W_train_test,
      W_predict_coords = as.matrix(rbind(train[, coords], test[, coords]))
    ))

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  fit <- suppressWarnings(workflows::fit(wf, data = train))
  engine <- workflows::extract_fit_engine(fit)

  expect_identical(attr(engine, "spatialtidymodels_W_predict"), W_train_test)
  preds <- suppressWarnings(stats::predict(fit, new_data = test))
  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))

  test_wrong_coords <- test
  test_wrong_coords$x_coord <- test_wrong_coords$x_coord + 100
  expect_error(
    stats::predict(fit, new_data = test_wrong_coords),
    "different train/test coordinates"
  )
})

test_that("spboost_reg predit via workflow()", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 18L)
  train <- dat[1:14, ]
  test <- dat[15:18, ]

  spec <- spboost_reg(
    coords = c("x_coord", "y_coord"),
    DGP = "SAR",
    mstop = 20,
    nu = 0.1,
    k_neighbors = 3
  ) |>
    parsnip::set_engine("spboost")

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  fit <- workflows::fit(wf, data = train)
  preds <- suppressWarnings(stats::predict(fit, new_data = test))

  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
})

test_that("spboost_reg et ses variantes BSPA passent dans tune_grid() sur mstop et k_neighbors", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("spboost")
  skip_if_not_installed("mboost")

  dat <- make_tiny_spatial_data(n = 18L)
  folds <- rsample::vfold_cv(dat, v = 2)

  specs <- list(
    spboost_reg = spboost_reg(
      coords = c("x_coord", "y_coord"),
      DGP = "SAR",
      mstop = tune::tune(),
      nu = 0.1,
      k_neighbors = tune::tune()
    ),
    spboost_bspa_sar_ml = spboost_bspa_sar_ml(
      coords = c("x_coord", "y_coord"),
      mstop = tune::tune(),
      nu = 0.1,
      k_neighbors = tune::tune()
    ),
    spboost_bspa_sar_cfe = spboost_bspa_sar_cfe(
      coords = c("x_coord", "y_coord"),
      mstop = tune::tune(),
      nu = 0.1,
      k_neighbors = tune::tune()
    ),
    spboost_bspa_sem_ml = spboost_bspa_sem_ml(
      coords = c("x_coord", "y_coord"),
      mstop = tune::tune(),
      nu = 0.1,
      k_neighbors = tune::tune()
    ),
    spboost_bspa_sem_cfe = spboost_bspa_sem_cfe(
      coords = c("x_coord", "y_coord"),
      mstop = tune::tune(),
      nu = 0.1,
      k_neighbors = tune::tune()
    )
  )

  for (spec_name in names(specs)) {
    wf <- workflows::workflow() |>
      workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
      workflows::add_model(parsnip::set_engine(specs[[spec_name]], "spboost"))

    res <- suppressWarnings(tune::tune_grid(
      wf,
      resamples = folds,
      grid = data.frame(mstop = c(10L, 20L), k_neighbors = c(2L, 3L)),
      metrics = yardstick::metric_set(yardstick::rmse),
      control = tune::control_grid(save_pred = TRUE)
    ))

    metrics <- tune::collect_metrics(res)
    expect_true(all(c("mstop", "k_neighbors", "mean") %in% names(metrics)), info = spec_name)
    expect_true(all(is.finite(metrics$mean)), info = spec_name)
  }
})

test_that("mgwrsar_reg passe dans tune_grid() sur bandwidth", {
  skip_if_not_installed("workflows")
  skip_if_not_installed("parsnip")
  skip_if_not_installed("tune")
  skip_if_not_installed("rsample")
  skip_if_not_installed("yardstick")
  skip_if_not_installed("mgwrsar")

  dat <- make_tiny_spatial_data(n = 18L)
  folds <- rsample::vfold_cv(dat, v = 2)

  spec <- mgwrsar_reg(
    coords = c("x_coord", "y_coord"),
    model_type = "GWR",
    kernel = "gauss",
    bandwidth = tune::tune()
  ) |>
    parsnip::set_engine("mgwrsar")

  wf <- workflows::workflow() |>
    workflows::add_formula(y ~ x1 + x2 + x_coord + y_coord) |>
    workflows::add_model(spec)

  res <- suppressWarnings(tune::tune_grid(
    wf,
    resamples = folds,
    grid = data.frame(bandwidth = c(4L, 6L)),
    metrics = yardstick::metric_set(yardstick::rmse),
    control = tune::control_grid(save_pred = TRUE)
  ))

  metrics <- tune::collect_metrics(res)
  expect_true(all(c("bandwidth", "mean") %in% names(metrics)))
  expect_true(all(is.finite(metrics$mean)))
})
