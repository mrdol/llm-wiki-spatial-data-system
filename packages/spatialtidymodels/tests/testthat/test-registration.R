test_that("les constructeurs parsnip exposent des specs", {
  skip_if_not_installed("parsnip")

  expect_s3_class(spatialreg_reg(coords = c("x", "y"), model_type = "SAR"), "spatialreg_reg")
  expect_s3_class(spboost_reg(coords = c("x", "y"), DGP = "SAR", mstop = 50), "spboost_reg")
  expect_s3_class(mgwrsar_reg(coords = c("x", "y"), model_type = "GWR", kernel = "gauss", bandwidth = 20), "mgwrsar_reg")
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

test_that("les parametres dials du package sont disponibles", {
  skip_if_not_installed("dials")

  expect_s3_class(mstop(), "quant_param")
  expect_s3_class(bandwidth(), "quant_param")
  expect_s3_class(k_neighbors(), "quant_param")
  expect_s3_class(kernel(), "qual_param")
})
