test_that("extract_information_criteria() skips logLik/AIC entirely for mboost-derived engines", {
  # stats::AIC(engine) is unaffordable for mboost/gamboost/spboost objects at
  # larger n (AIC.mboost() computes an effective-df boosting hat-matrix trace
  # that scales very badly -- confirmed to still be running after 35s+ of
  # sustained CPU on a 3435-row fold, root-caused from a benchmark suite hang
  # that used to run for ~25 minutes on lasrosas).
  #
  # logLik.mboost() is ALSO skipped (2026-09-13): it returns -risk(mstop), the
  # raw sum of squared residuals at the final boosting step, never normalized
  # into an actual Gaussian log-likelihood -- not comparable to lm/sarlm's
  # logLik, and scales with the response's raw units (confirmed to reach
  # -7M on a kg/ha-scale response and -480 billion on a GBP-scale response,
  # both ~ -n*rmse^2, the signature of a raw SSE rather than a likelihood).
  # So logLik/aic/aicc all stay NA for mboost-derived engines; only the
  # effective df is still reported (spboost_effective_df_for_ic() remains
  # meaningful on its own).
  skip_if_not_installed("mboost")
  fit <- mboost::gamboost(
    Sepal.Length ~ mboost::bbs(Sepal.Width) + mboost::bbs(Petal.Length),
    data = iris, control = mboost::boost_control(mstop = 20L)
  )
  expect_true(inherits(fit, "mboost"))

  ic <- extract_information_criteria(fit, n = nrow(iris))
  expect_true(is.na(ic$logLik))
  expect_true(is.finite(ic$df))
  expect_true(is.na(ic$aic))
  expect_true(is.na(ic$aicc))
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
  # logLik.mboost() is not a real Gaussian log-likelihood (see the
  # extract_information_criteria() test above) -- NA is the correct value,
  # not a missing feature.
  expect_true(is.na(diag$logLik[[1]]))
})
