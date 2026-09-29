test_that("la route utilise une seule reponse et refuse une union ambigue", {
  spec <- function(types) data.frame(response_typology = I(list(types)))
  expect_identical(detect_response_typology_from_spec(spec("rate")), "continuous")
  expect_identical(detect_response_typology_from_spec(spec("count")), "count")
  expect_error(detect_response_typology_from_spec(spec(c("continuous", "binary"))), "selectionne")
  expect_error(detect_response_typology_from_spec(spec("categorical")), "selectionne")
})

test_that("une mauvaise famille echoue avant toute conversion destructive", {
  dat <- data.frame(y = c(-1, 0.2, 0.5, 1.8, 6), x = 1:5)
  expect_error(fit_one_benchmark_estimator("ols", y ~ x, dat, coords = character(), response_typology = "binary"), "perdrait")
  expect_error(fit_one_benchmark_estimator("ols", y ~ x, dat, coords = character(), response_typology = "count"), "entieres")
  fit <- fit_one_benchmark_estimator("ols", y ~ x, dat, coords = character(), response_typology = "continuous")
  expect_equal(stats::nobs(fit), 5L)
  expect_identical(fit$family$family, "gaussian")
  dat$y <- c(0L, 2L, 1L, 3L, 5L)
  count_fit <- fit_one_benchmark_estimator("ols", y ~ x, dat, coords = character(), response_typology = "count")
  expect_identical(count_fit$family$family, "poisson")
})
