test_that("extract_information_criteria() skips stats::AIC() for mboost-derived engines and uses the analytic fallback", {
  # stats::AIC(engine) is unaffordable for mboost/gamboost/spboost objects at
  # larger n (AIC.mboost() computes an effective-df boosting hat-matrix trace
  # that scales very badly -- confirmed to still be running after 35s+ of
  # sustained CPU on a 3435-row fold, root-caused from a benchmark suite hang
  # that used to run for ~25 minutes on lasrosas). For an mboost-derived
  # engine, aic must come out equal to the analytic -2*logLik + 2*df formula,
  # proving stats::AIC() was never called.
  skip_if_not_installed("mboost")
  fit <- mboost::gamboost(
    Sepal.Length ~ mboost::bbs(Sepal.Width) + mboost::bbs(Petal.Length),
    data = iris, control = mboost::boost_control(mstop = 20L)
  )
  expect_true(inherits(fit, "mboost"))

  ic <- extract_information_criteria(fit, n = nrow(iris))
  expect_true(is.finite(ic$logLik))
  expect_true(is.finite(ic$df))
  expect_equal(ic$aic, -2 * ic$logLik + 2 * ic$df, tolerance = 1e-8)
})

test_that("extract_information_criteria() still calls stats::AIC() for non-mboost engines (unchanged behaviour)", {
  fit <- stats::glm(Sepal.Length ~ Sepal.Width + Petal.Length, data = iris)
  ic <- extract_information_criteria(fit, n = nrow(iris))
  expect_equal(ic$aic, as.numeric(stats::AIC(fit)), tolerance = 1e-8)
})

test_that("diagnose_spatial() completes on an mboost-derived fit without needing stats::AIC()", {
  skip_if_not_installed("mboost")
  fit <- mboost::gamboost(
    Sepal.Length ~ mboost::bbs(Sepal.Width) + mboost::bbs(Petal.Length),
    data = iris, control = mboost::boost_control(mstop = 20L)
  )
  diag <- diagnose_spatial(
    fit, data = iris, coords = NULL, formula = Sepal.Length ~ Sepal.Width + Petal.Length,
    include_baseline = FALSE
  )
  expect_s3_class(diag, "data.frame")
  expect_equal(nrow(diag), 1L)
  expect_true(is.finite(diag$logLik[[1]]))
})
