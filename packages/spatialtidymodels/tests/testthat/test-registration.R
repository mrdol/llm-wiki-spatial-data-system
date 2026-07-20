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
  expect_s3_class(spboost_reg(coords = c("x", "y"), DGP = "SAR", mstop = 50), "spboost_reg")
  expect_s3_class(mgwrsar_reg(coords = c("x", "y"), model_type = "GWR", kernel = "gauss", bandwidth = 20), "mgwrsar_reg")
})

test_that("le registre benchmark distingue routes automatiques et routes a brancher", {
  registry <- available_benchmark_estimators()

  expect_true(all(c("estimator", "backend", "automatic", "notes") %in% names(registry)))
  expect_true(all(c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed") %in% registry$estimator))
  expect_false(registry$automatic[registry$estimator == "spboost"])
})

test_that("les constructeurs SAR/SEM/SDM fixent le type de modele", {
  skip_if_not_installed("rlang")

  expect_equal(rlang::eval_tidy(sar_reg(coords = c("x", "y"))$args$model_type), "SAR")
  expect_equal(rlang::eval_tidy(sem_reg(coords = c("x", "y"))$args$model_type), "SEM")
  expect_equal(rlang::eval_tidy(sdm_reg(coords = c("x", "y"))$args$model_type), "SDM")
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
  expect_s3_class(kernel(), "qual_param")
})
