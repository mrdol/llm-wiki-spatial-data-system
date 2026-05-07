source("R/utils/estimator_common.R")

# RNN wrapper using Python TensorFlow/Keras through reticulate.
# Inputs must already be shaped as arrays: observations x time steps x features.
fit_rnn_reticulate <- function(x_array, y_array, config = list(), venv = ".venv") {
  load_project_reticulate(venv = venv, required = FALSE)
  tensorflow <- reticulate::import("tensorflow", delay_load = FALSE)
  keras <- tensorflow$keras

  units <- config$units %||% 32L
  epochs <- config$epochs %||% 20L
  batch_size <- config$batch_size %||% 32L
  loss <- config$loss %||% "mse"
  optimizer <- config$optimizer %||% "adam"

  # Keras receives the per-observation shape, excluding the batch dimension.
  input_shape <- dim(x_array)[-1]
  model <- keras$Sequential(list(
    keras$layers$Input(shape = as.integer(input_shape)),
    keras$layers$SimpleRNN(units = as.integer(units)),
    keras$layers$Dense(units = 1L)
  ))
  model$compile(optimizer = optimizer, loss = loss)

  # Training controls stay in config so validation code can manage them externally.
  history <- model$fit(
    x_array,
    y_array,
    epochs = as.integer(epochs),
    batch_size = as.integer(batch_size),
    verbose = config$verbose %||% 0L
  )

  estimator_result(
    estimator = "RNN",
    backend_language = "Python via reticulate",
    backend_package = "tensorflow.keras",
    model = model,
    metadata = list(history = history, config = config, input_shape = input_shape)
  )
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
