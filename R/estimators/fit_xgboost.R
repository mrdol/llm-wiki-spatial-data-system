source("R/utils/estimator_common.R")

# XGBoost wrapper using the native R xgboost package.
fit_xgboost <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("xgboost", "XGBoost")

  # xgboost expects a numeric matrix rather than a formula/data.frame pair.
  xy <- model_matrix_xy(data, y, x)
  dtrain <- xgboost::xgb.DMatrix(data = xy$x, label = xy$y)

  # Callers can override defaults with config$params and config$nrounds.
  params <- config$params %||% list(objective = "reg:squarederror")
  nrounds <- config$nrounds %||% 100
  watchlist <- config$watchlist %||% list(train = dtrain)
  model <- xgboost::xgb.train(
    params = params,
    data = dtrain,
    nrounds = nrounds,
    watchlist = watchlist,
    verbose = config$verbose %||% 0
  )
  estimator_result(
    estimator = "XGBoost",
    backend_language = "R",
    backend_package = "xgboost",
    model = model,
    metadata = list(formula = xy$formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
