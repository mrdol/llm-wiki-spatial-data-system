source("R/utils/estimator_common.R")

# SVM wrapper using e1071 as the conservative R-native backend.
fit_svm <- function(data, y, x, coords = NULL, time = NULL, config = list()) {
  require_package("e1071", "SVM")
  check_columns(data, c(y, x), role = "SVM variables")
  formula <- build_estimator_formula(y, x)

  # Kernel, cost, gamma, epsilon, and type can be supplied through config.
  args <- c(list(formula = formula, data = data), config)
  model <- do.call(e1071::svm, args)
  estimator_result(
    estimator = "SVM",
    backend_language = "R",
    backend_package = "e1071",
    model = model,
    metadata = list(formula = formula, y = y, x = x, coords = coords, time = time, config = config)
  )
}
