# Visualisations package pour les resamples spatiaux.
#
# Les fonctions ici ne construisent pas les folds: elles inspectent les objets
# crees par make_spatial_resamples() et produisent des graphiques consultables.

extract_benchmark_results_for_plot <- function(x) {
  # Accepte soit l'objet benchmark package, soit directement une table de
  # resultats. Cela garde les fonctions utilisables dans la console.
  if (inherits(x, "spatial_benchmark") || inherits(x, "spatial_benchmark_set")) {
    return(as.data.frame(x$results))
  }
  as.data.frame(x)
}

#' Plot a tuning curve
#'
#' Plots RMSE or MAE against one tuning parameter. This works with the tuning
#' grid returned by `benchmark_spatial(..., tune = TRUE)` or with a plain data
#' frame containing tuning metrics.
#'
#' @param tuning_grid Data frame with at least columns `x` and `metric`.
#' @param x Name of the tuning parameter column, for example `"mstop"` or
#'   `"bandwidth"`.
#' @param metric Metric column to plot, usually `"rmse"` or `"mae"`.
#' @param color Optional column used to draw separate curves, for example
#'   `"kernel"`.
#' @param title Optional plot title.
#'
#' @return A `ggplot2` object.
#' @export
plot_tuning_curve <- function(tuning_grid, x, metric = "rmse", color = NULL,
                              title = NULL) {
  require_package("ggplot2", "tuning curve plot")
  tuning_grid <- as.data.frame(tuning_grid)
  if (!x %in% names(tuning_grid) || !metric %in% names(tuning_grid)) {
    stop("`tuning_grid` must contain the requested tuning parameter and metric columns.", call. = FALSE)
  }
  tuning_grid <- tuning_grid[order(tuning_grid[[x]]), , drop = FALSE]

  p <- ggplot2::ggplot(tuning_grid, ggplot2::aes(x = .data[[x]], y = .data[[metric]]))
  if (!is.null(color) && color %in% names(tuning_grid)) {
    p <- p +
      ggplot2::geom_line(ggplot2::aes(color = .data[[color]], group = .data[[color]]), linewidth = 0.7) +
      ggplot2::geom_point(ggplot2::aes(color = .data[[color]]), size = 2.2)
  } else {
    p <- p +
      ggplot2::geom_line(linewidth = 0.7, color = "#2c7fb8") +
      ggplot2::geom_point(size = 2.2, color = "#2c7fb8")
  }

  best <- tuning_grid[which.min(tuning_grid[[metric]]), , drop = FALSE]
  p +
    ggplot2::geom_point(
      data = best,
      ggplot2::aes(x = .data[[x]], y = .data[[metric]]),
      color = "#d7191c",
      size = 3.5,
      shape = 8
    ) +
    ggplot2::labs(
      title = title %||% sprintf("%s calibration (%s)", x, toupper(metric)),
      subtitle = sprintf(
        "Best candidate: %s = %s, %s = %.4g",
        x, format(best[[x]]), toupper(metric), best[[metric]]
      ),
      x = x,
      y = toupper(metric),
      color = color
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = if (is.null(color)) "none" else "top")
}

#' Plot benchmark metric comparison
#'
#' Plots benchmark RMSE or MAE by estimator and cross-validation scheme.
#'
#' @param benchmark A `spatial_benchmark`, `spatial_benchmark_set`, or data
#'   frame with benchmark results.
#' @param dataset_name Optional dataset name used to filter multi-dataset
#'   results.
#' @param metric Metric to plot, either `"rmse"` or `"mae"`.
#'
#' @return A `ggplot2` object.
#' @export
plot_benchmark_comparison <- function(benchmark, dataset_name = NULL,
                                      metric = "rmse") {
  require_package("ggplot2", "benchmark comparison plot")
  metric <- match.arg(metric, c("rmse", "mae"))
  df <- extract_benchmark_results_for_plot(benchmark)
  if (!metric %in% names(df) || !"estimator" %in% names(df)) {
    stop("`benchmark` must contain estimator and metric columns.", call. = FALSE)
  }
  if (!is.null(dataset_name) && "dataset" %in% names(df)) {
    df <- df[df$dataset == dataset_name, , drop = FALSE]
  }
  if (!"cv_scheme" %in% names(df)) df$cv_scheme <- "in_sample"
  df <- df[is.finite(df[[metric]]), , drop = FALSE]
  if (nrow(df) == 0L) {
    stop("No finite benchmark metric is available to plot.", call. = FALSE)
  }

  agg <- stats::aggregate(
    stats::as.formula(paste(metric, "~ estimator + cv_scheme")),
    data = df,
    FUN = mean
  )

  ggplot2::ggplot(agg, ggplot2::aes(x = estimator, y = .data[[metric]], fill = estimator)) +
    ggplot2::geom_col(width = 0.7, show.legend = FALSE) +
    ggplot2::facet_wrap(~cv_scheme, scales = "free_y") +
    ggplot2::labs(
      title = if (is.null(dataset_name)) {
        sprintf("Mean %s by estimator and CV scheme", toupper(metric))
      } else {
        sprintf("Mean %s by estimator and CV scheme - %s", toupper(metric), dataset_name)
      },
      x = NULL,
      y = toupper(metric)
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))
}

#' Plot spatial predictions or residuals
#'
#' Plots fitted-model predictions on the coordinate plane. If a truth column is
#' supplied, the function can also plot residuals.
#'
#' @param fit A fitted model or workflow with a `predict()` method returning a
#'   `.pred` column.
#' @param data Data frame used for prediction.
#' @param coords Character vector of length 2 giving coordinate columns.
#' @param truth Optional response column used when `type = "residual"`.
#' @param type `"prediction"` or `"residual"`.
#'
#' @return A `ggplot2` object.
#' @export
plot_spatial_predictions <- function(fit, data, coords, truth = NULL,
                                     type = c("prediction", "residual")) {
  # Fonction volontairement generique: elle ne suppose pas un estimateur precis.
  # Tout objet compatible predict(..., new_data=) peut etre visualise.
  require_package("ggplot2", "spatial prediction plot")
  type <- match.arg(type)
  data <- as.data.frame(data)
  coords <- check_spatial_coords(coords, data = data)

  preds <- tryCatch(
    stats::predict(fit, new_data = data),
    error = function(e) stats::predict(fit, newdata = data)
  )
  if (is.atomic(preds)) {
    preds <- data.frame(.pred = as.numeric(preds))
  } else {
    preds <- as.data.frame(preds)
  }
  if (!".pred" %in% names(preds)) {
    stop("`predict(fit, ...)` must return a `.pred` column or a numeric vector.", call. = FALSE)
  }

  plot_data <- data.frame(
    x = data[[coords[[1]]]],
    y = data[[coords[[2]]]],
    value = as.numeric(preds$.pred)
  )
  legend_title <- "Prediction"
  if (identical(type, "residual")) {
    if (is.null(truth)) {
      stop("`truth` must be supplied when `type = 'residual'`.", call. = FALSE)
    }
    truth <- if (is.character(truth)) truth[[1]] else deparse(substitute(truth))
    if (!truth %in% names(data)) {
      stop("`truth` must name a column in `data`.", call. = FALSE)
    }
    plot_data$value <- data[[truth]] - plot_data$value
    legend_title <- "Residual"
  }

  ggplot2::ggplot(plot_data, ggplot2::aes(x = x, y = y, color = value)) +
    ggplot2::geom_point(size = 2.2, alpha = 0.9) +
    ggplot2::coord_equal() +
    ggplot2::scale_color_gradient2(
      low = "#2166ac",
      mid = "#f7f7f7",
      high = "#b2182b",
      midpoint = if (identical(type, "residual")) 0 else stats::median(plot_data$value, na.rm = TRUE),
      name = legend_title
    ) +
    ggplot2::labs(
      title = if (identical(type, "residual")) "Spatial residuals" else "Spatial predictions",
      x = coords[[1]],
      y = coords[[2]]
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(legend.position = "right")
}

#' Plot a near-prediction resampling fold
#'
#' Visualizes one near-prediction fold generated by `make_spatial_resamples()`.
#' Training observations are shown in grey, test observations in red, and the
#' quadtree cell borders in blue.
#'
#' @param rset A near-prediction rset returned by `make_spatial_resamples()`.
#' @param data Optional data frame. If omitted, the function uses the data
#'   stored inside the rsample split.
#' @param coords Coordinate column names. Required when `data` is supplied.
#' @param fold Fold number or fold id.
#'
#' @return A `ggplot2` object.
#' @export
plot_near_prediction_fold <- function(rset, data = NULL, coords = NULL, fold = 1L) {
  # Visualisation reprise du script local code/R/utils/spatial_viz.R, adaptee au
  # rset package et a la metadata stockee dans attr(rset, "near_cv").
  require_package("ggplot2", "near-prediction fold plot")
  near_cv <- attr(rset, "near_cv")
  if (is.null(near_cv)) {
    stop("`rset` does not contain near-prediction metadata. Rebuild it with cv_scheme = 'near_prediction'.", call. = FALSE)
  }

  if (is.character(fold)) {
    fold_index <- match(fold, names(near_cv$folds))
  } else {
    fold_index <- as.integer(fold)
  }
  if (length(fold_index) != 1L || is.na(fold_index) ||
      fold_index < 1L || fold_index > length(near_cv$folds)) {
    stop("`fold` must identify an existing near-prediction repetition.", call. = FALSE)
  }

  if (is.null(data)) {
    split_obj <- rset$splits[[fold_index]]
    data <- split_obj$data
  } else {
    data <- as.data.frame(data)
  }
  if (is.null(coords)) {
    coords <- c("x", "y")
    if (!all(coords %in% names(data))) {
      stop("`coords` must be supplied when data does not contain columns named x and y.", call. = FALSE)
    }
  }
  coords <- check_spatial_coords(coords, data = data)
  coords_mat <- as.matrix(data[, coords, drop = FALSE])

  if (ncol(coords_mat) != 2L || nrow(coords_mat) != length(near_cv$cell_id)) {
    stop("`data` and `coords` must match the coordinates used to build the near-prediction rset.", call. = FALSE)
  }

  split <- near_cv$folds[[fold_index]]
  plot_data <- data.frame(
    x = coords_mat[, 1L],
    y = coords_mat[, 2L],
    set = "Train",
    cell_id = near_cv$cell_id
  )
  plot_data$set[split$test] <- "Test"
  plot_data$set <- factor(plot_data$set, levels = c("Train", "Test"))

  ggplot2::ggplot() +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Train", , drop = FALSE],
      ggplot2::aes(x = x, y = y),
      color = "grey65",
      size = 0.45,
      alpha = 0.55
    ) +
    ggplot2::geom_path(
      data = near_cv$polygons,
      ggplot2::aes(x = x, y = y, group = id),
      color = "#006D77",
      linewidth = 0.45,
      alpha = 0.9
    ) +
    ggplot2::geom_point(
      data = plot_data[plot_data$set == "Test", , drop = FALSE],
      ggplot2::aes(x = x, y = y, color = set),
      size = 2.2,
      alpha = 0.95
    ) +
    ggplot2::scale_color_manual(values = c(Test = "#D73027"), name = NULL) +
    ggplot2::coord_equal() +
    ggplot2::labs(
      title = sprintf("Near-prediction - fold %s", names(near_cv$folds)[[fold_index]]),
      subtitle = sprintf(
        "%d quadtree cells - %d test points - %d train points",
        near_cv$n_cells,
        length(split$test),
        length(split$train)
      ),
      x = coords[[1]],
      y = coords[[2]],
      caption = "Red: test, one point per cell. Grey: train."
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      legend.position = "top",
      plot.title.position = "plot"
    )
}
