source("R/utils/estimator_common.R")

# LightGBM wrapper using the native R lightgbm package.
fit_lightgbm <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("lightgbm", "LightGBM")

  # lightgbm uses its own Dataset object built from a numeric matrix.
  xy <- model_matrix_xy(data, y, x)
  dtrain <- lightgbm::lgb.Dataset(data = xy$x, label = xy$y)

  # Keep default objective simple; project tuning code can pass config$params.
  params <- config$params %||% list(objective = "regression", metric = "l2")
  nrounds <- config$nrounds %||% 100
  model <- lightgbm::lgb.train(
    params = params,
    data = dtrain,
    nrounds = nrounds,
    verbose = config$verbose %||% -1
  )
  estimator_result(
    estimator = "LightGBM",
    backend_language = "R",
    backend_package = "lightgbm",
    model = model,
    metadata = list(formula = xy$formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
