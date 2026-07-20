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
  expect_true(all(c("rmse", "mae", "aic", "logLik", "moran_i", "moran_p_value") %in% names(diag)))
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

  fit <- workflows::fit(wf, data = train)
  preds <- stats::predict(fit, new_data = test)

  expect_equal(nrow(preds), nrow(test))
  expect_true(all(is.finite(preds$.pred)))
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
