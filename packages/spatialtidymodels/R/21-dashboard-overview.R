# Overview page module.
#
# Answers one question: "what happened in this benchmark, expressed relative
# to a baseline?" (Not "how does my new estimator compare to a specific
# reference?" -- that is the Reference vs Variant page, R/22.)
#
# Shiny module convention throughout this dashboard: `mod_*_ui(id)` builds
# namespaced UI, `mod_*_server(id, ...)` returns nothing (or a reactive, if a
# later page needs to react to this one's selection) and is invoked once from
# the orchestrator's server (R/19-dashboard-app.R). All calculation stays in
# R/18-dashboard-data.R; this file only arranges what those functions return
# on screen -- never recomputes a KPI, ratio, or verdict itself.
#
# The Estimator Families filter lives in the app-level sidebar
# (R/19-dashboard-app.R), not in this page's own filter bar: the sidebar is
# shared navigation/filtering across pages, so this module reads the
# selection via a `selected_group` reactive passed in from the orchestrator
# rather than owning its own family input.

# Diverging teal (better) -> cream (baseline) -> red (worse) palette used by
# the relative-metric heatmap cells and its legend strip, clamped to
# [heatmap_lo, heatmap_hi] so one very slow/bad estimator can't wash out the
# color contrast for everyone else (what a data-range-driven ggplot2 gradient
# would do).
dashboard_heatmap_lo <- 0.4
dashboard_heatmap_hi <- 1.6

dashboard_heatmap_color <- function(x) {
  if (!requireNamespace("grDevices", quietly = TRUE) || is.na(x)) return("#e9ecef")
  x <- max(dashboard_heatmap_lo, min(dashboard_heatmap_hi, x))
  ramp <- grDevices::colorRamp(c("#1f7a6c", "#f5f1e6", "#a3312a"), space = "Lab")
  pos <- (x - dashboard_heatmap_lo) / (dashboard_heatmap_hi - dashboard_heatmap_lo)
  rgb <- ramp(pos)
  grDevices::rgb(rgb[1], rgb[2], rgb[3], maxColorValue = 255)
}

dashboard_heatmap_table_html <- function(wide) {
  estimators <- setdiff(names(wide), "dataset")
  is_summary_row <- grepl("all datasets", wide$dataset, fixed = TRUE)
  header <- shiny::tags$tr(
    shiny::tags$th("Dataset"),
    lapply(estimators, function(e) shiny::tags$th(e))
  )
  body_rows <- lapply(seq_len(nrow(wide)), function(i) {
    row_style <- if (is_summary_row[[i]]) "font-weight:600;border-top:2px solid #444;" else ""
    shiny::tags$tr(
      style = row_style,
      shiny::tags$td(wide$dataset[[i]]),
      lapply(estimators, function(e) {
        val <- wide[[e]][[i]]
        label <- if (is.na(val)) "–" else sprintf("%.2f", val)
        shiny::tags$td(label, style = sprintf("background-color:%s;text-align:center;", dashboard_heatmap_color(val)))
      })
    )
  })
  shiny::tags$div(
    class = "dashboard-table-scroll",
    shiny::tags$table(
      class = "dashboard-heatmap-table",
      shiny::tags$thead(header),
      shiny::tags$tbody(body_rows)
    )
  )
}

dashboard_heatmap_legend_html <- function() {
  n <- 9
  breaks <- seq(dashboard_heatmap_lo, dashboard_heatmap_hi, length.out = n)
  stops <- vapply(seq_along(breaks), function(i) {
    sprintf("%s %d%%", dashboard_heatmap_color(breaks[[i]]), round(100 * (i - 1) / (n - 1)))
  }, character(1))
  gradient <- paste(stops, collapse = ", ")
  shiny::tags$div(
    class = "dashboard-legend",
    shiny::tags$div(style = sprintf("background: linear-gradient(to right, %s); height:10px;width:260px;border-radius:3px;", gradient)),
    shiny::tags$div(
      style = "display:flex;justify-content:space-between;width:260px;font-size:0.75em;color:#555;",
      shiny::tags$span(sprintf("%.1f", dashboard_heatmap_lo)),
      shiny::tags$span("1.0"),
      shiny::tags$span(sprintf("%.1f", dashboard_heatmap_hi))
    )
  )
}

#' @param id Module namespace id.
#' @param cv_scheme_choices,estimator_choices,metric_choices Static choice
#'   lists computed once from the suite's results table.
#' @param baseline_default Estimator preselected as the baseline.
#' @noRd
mod_overview_ui <- function(id, cv_scheme_choices, estimator_choices, metric_choices, baseline_default) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$div(
      class = "dashboard-subtitle",
      "What happened in this benchmark, relative to a baseline. Filters only subset already-computed results -- nothing is refit."
    ),
    # CV scheme as underlined tabs rather than radio buttons (still a plain
    # radioButtons under the hood -- see .dashboard-cv-tabs in dashboard.css
    # -- so the reactive wiring below is unaffected either way).
    shiny::tags$div(
      class = "dashboard-cv-tabs",
      shiny::radioButtons(ns("cv_scheme_filter"), label = NULL, choices = cv_scheme_choices,
                          selected = cv_scheme_choices[[1]], inline = TRUE)
    ),
    shiny::tags$div(
      class = "dashboard-filterbar",
      shiny::selectInput(ns("baseline"), "Baseline", choices = estimator_choices, selected = baseline_default),
      shiny::selectInput(ns("metric"), "Metric (table)", choices = metric_choices, selected = metric_choices[[1]]),
      shiny::actionButton(ns("reset_filters"), "Reset filters", class = "btn-outline-secondary")
    ),
    bslib::layout_columns(
      col_widths = c(3, 3, 3, 3),
      shiny::uiOutput(ns("kpi_rmse_card")),
      shiny::uiOutput(ns("kpi_mae_card")),
      shiny::uiOutput(ns("kpi_moran_card")),
      shiny::uiOutput(ns("kpi_duration_card"))
    ),
    bslib::card(
      bslib::card_header("Relative performance vs baseline", shiny::tags$span(class = "dashboard-card-note", "values < 1.0 are better than baseline")),
      shiny::uiOutput(ns("heatmap_table")),
      dashboard_heatmap_legend_html()
    ),
    bslib::layout_columns(
      col_widths = c(6, 6),
      bslib::card(
        bslib::card_header("Performance vs Duration"),
        shiny::plotOutput(ns("perf_runtime_plot"), height = "380px")
      ),
      bslib::card(
        bslib::card_header("Residual Spatial Dependence"),
        shiny::plotOutput(ns("moran_plot"), height = "380px")
      )
    ),
    bslib::card(
      bslib::card_header("Fold Failures"),
      DT::DTOutput(ns("failure_table"))
    )
  )
}

#' @param id Module namespace id, must match the id passed to [mod_overview_ui()].
#' @param results The suite's results `data.frame` (all CV schemes; the
#'   module filters to one itself).
#' @param families Output of [dashboard_estimator_families()].
#' @param baseline_default Estimator preselected as the baseline.
#' @param cv_scheme_choices,metric_choices Same static choices passed to the UI.
#' @param selected_group A zero-arg reactive (e.g. `shiny::reactive(...)`)
#'   returning the currently selected `dashboard_group`, or `"All"` --
#'   owned by the app-level sidebar (R/19-dashboard-app.R), not this module.
#' @noRd
mod_overview_server <- function(id, results, families, baseline_default, cv_scheme_choices, metric_choices, selected_group) {
  shiny::moduleServer(id, function(input, output, session) {
    filtered_results <- shiny::reactive({
      r <- results[results$cv_scheme == input$cv_scheme_filter, , drop = FALSE]
      grp <- selected_group()
      if (!is.null(grp) && !identical(grp, "All")) {
        keep_estimators <- c(input$baseline, families$estimator[families$dashboard_group == grp])
        r <- r[r$estimator %in% keep_estimators, , drop = FALSE]
      }
      r
    })

    # Best median relative RMSE/MAE: never a raw cross-dataset champion (see
    # dashboard_best_relative_estimator() -- response variables are not on a
    # comparable scale between datasets).
    #
    # 2026-09: the two headline cards adapt to the response type actually
    # present in the filtered results, instead of always showing RMSE/MAE.
    # rmse/mae stay well-defined and comparable for a binary/count suite too
    # (see make_metric_values() in 12-diagnose-spatial.R -- rmse/mae are
    # always computed, never replaced by accuracy/auc/deviance), so this is
    # purely about surfacing the more informative headline metric when one
    # is available, not a correctness fix.
    build_relative_kpi_card <- function(metric_name, title, icon, lower_is_better = TRUE) {
      best <- dashboard_best_relative_estimator(
        filtered_results(), baseline_estimator = input$baseline,
        metric = metric_name, lower_is_better = lower_is_better
      )
      if (is.na(best$estimator)) return(dashboard_kpi_card(title, "n/a", icon = icon, value_class = ""))
      # < 1x is better than baseline, > 1x is worse, ~1x (the baseline
      # itself, or a genuine tie) stays neutral -- same green/red reading
      # as the heatmap cells, just repeated on the KPI card. For a
      # higher-is-better metric (accuracy/AUC) the sides are flipped.
      good_side <- if (isTRUE(lower_is_better)) best$value < 0.999 else best$value > 1.001
      bad_side <- if (isTRUE(lower_is_better)) best$value > 1.001 else best$value < 0.999
      direction_class <- if (good_side) "better" else if (bad_side) "worse" else "neutral-accent"
      dashboard_kpi_card(
        title, sprintf("%.2fx", best$value),
        estimator = best$estimator,
        comparison = sprintf("vs %s (n=%d datasets)", best$baseline, best$n_datasets),
        icon = icon, value_class = direction_class
      )
    }
    output$kpi_rmse_card <- shiny::renderUI({
      r <- filtered_results()
      if ("accuracy" %in% names(r) && any(is.finite(r$accuracy))) {
        build_relative_kpi_card("accuracy", "Best relative accuracy", "chart", lower_is_better = FALSE)
      } else if ("deviance" %in% names(r) && any(is.finite(r$deviance))) {
        build_relative_kpi_card("deviance", "Best relative deviance", "chart")
      } else {
        build_relative_kpi_card("rmse", "Best median relative RMSE", "chart")
      }
    })
    output$kpi_mae_card <- shiny::renderUI({
      r <- filtered_results()
      if ("auc" %in% names(r) && any(is.finite(r$auc))) {
        build_relative_kpi_card("auc", "Best relative AUC", "chart", lower_is_better = FALSE)
      } else {
        build_relative_kpi_card("mae", "Best median relative MAE", "chart")
      }
    })

    # Residual spatial dependence: magnitude-based (never "most negative
    # wins" -- see dashboard_residual_spatial_dependence()), median across
    # datasets per estimator, smallest wins.
    output$kpi_moran_card <- shiny::renderUI({
      annotated <- dashboard_residual_spatial_dependence(filtered_results())
      agg <- dashboard_metric_by_estimator(annotated, "residual_spatial_dependence")
      agg <- agg[is.finite(agg$value), , drop = FALSE]
      if (nrow(agg) == 0L) return(dashboard_kpi_card("Residual spatial dependence", "n/a", icon = "target", value_class = ""))
      best <- agg[which.min(agg$value), , drop = FALSE]
      dashboard_kpi_card(
        "Residual spatial dependence", sprintf("%.3g", best$value[[1]]),
        estimator = best$estimator[[1]], icon = "target", value_class = "neutral-accent"
      )
    })

    # Fastest model: median duration is not baseline-relative -- unlike
    # RMSE/MAE, duration has no per-dataset Y-scale confound, so the raw
    # median (per estimator, across datasets) is directly comparable.
    output$kpi_duration_card <- shiny::renderUI({
      agg <- dashboard_metric_by_estimator(filtered_results(), "duration_sec")
      agg <- agg[is.finite(agg$value), , drop = FALSE]
      if (nrow(agg) == 0L) return(dashboard_kpi_card("Fastest model", "n/a", icon = "clock", value_class = ""))
      best <- agg[which.min(agg$value), , drop = FALSE]
      dashboard_kpi_card(
        "Fastest model", sprintf("%.3g s", best$value[[1]]),
        estimator = best$estimator[[1]], icon = "clock", value_class = "neutral-accent"
      )
    })

    output$heatmap_table <- shiny::renderUI({
      # accuracy/auc (classification, 2026-09): higher is better -- sans ce
      # garde-fou, le tableau chaud colorierait les bons resultats en rouge
      # (voir dashboard_relative_metric(), 18-dashboard-data.R, qui inverse
      # deja correctement le ratio selon lower_is_better -- encore faut-il le
      # lui passer).
      lower_is_better <- !input$metric %in% c("accuracy", "auc")
      wide <- tryCatch(
        dashboard_relative_metric_wide(
          filtered_results(), baseline_estimator = input$baseline,
          metric = input$metric, lower_is_better = lower_is_better
        ),
        error = function(e) NULL
      )
      if (is.null(wide) || nrow(wide) == 0L) {
        return(shiny::tags$p("Pas assez de donnees pour ce filtre."))
      }
      dashboard_heatmap_table_html(wide)
    })

    output$perf_runtime_plot <- shiny::renderPlot({
      require_package("ggplot2", "le graphique performance/duree du dashboard")
      duration <- dashboard_metric_by_estimator(filtered_results(), "duration_sec")
      # Meme detection de type de reponse que les cartes KPI ci-dessus:
      # accuracy (classification) prime, sinon deviance (comptage) si
      # present sans accuracy, sinon rmse (continu, defaut).
      r <- filtered_results()
      perf_metric <- if ("accuracy" %in% names(r) && any(is.finite(r$accuracy))) {
        list(metric = "accuracy", lower_is_better = FALSE, label = "accuracy")
      } else if ("deviance" %in% names(r) && any(is.finite(r$deviance))) {
        list(metric = "deviance", lower_is_better = TRUE, label = "deviance")
      } else {
        list(metric = "rmse", lower_is_better = TRUE, label = "RMSE")
      }
      relative_rmse <- tryCatch(
        dashboard_relative_metric_by_estimator(
          filtered_results(), baseline_estimator = input$baseline,
          metric = perf_metric$metric, lower_is_better = perf_metric$lower_is_better
        ),
        error = function(e) NULL
      )
      if (is.null(relative_rmse) || nrow(relative_rmse) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas assez de donnees pour ce filtre") + ggplot2::theme_void())
      }
      agg <- merge(relative_rmse, duration, by = "estimator")
      agg <- agg[is.finite(agg$median_relative) & is.finite(agg$value), , drop = FALSE]
      if (nrow(agg) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas assez de donnees pour ce filtre") + ggplot2::theme_void())
      }
      agg <- merge(agg, families, by = "estimator", all.x = TRUE)
      ggplot2::ggplot(agg, ggplot2::aes(x = .data$value, y = .data$median_relative, label = .data$estimator, color = .data$dashboard_group)) +
        ggplot2::geom_hline(yintercept = 1, linewidth = 0.3, linetype = "dashed", color = "#999") +
        ggplot2::geom_point(size = 3.5) +
        ggplot2::geom_text(vjust = -0.9, size = 3.2, show.legend = FALSE) +
        ggplot2::scale_x_log10(name = "Median duration (s, log scale)") +
        ggplot2::scale_color_manual(values = dashboard_group_palette(), drop = TRUE) +
        ggplot2::labs(y = sprintf("Median relative %s (vs %s)", perf_metric$label, input$baseline), color = "Estimator family") +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(legend.position = "bottom", panel.grid.minor = ggplot2::element_blank())
    })

    output$moran_plot <- shiny::renderPlot({
      require_package("ggplot2", "le graphique de dependance spatiale du dashboard")
      annotated <- dashboard_residual_spatial_dependence(filtered_results())
      agg <- dashboard_metric_by_estimator(annotated, "residual_spatial_dependence")
      agg <- agg[!is.na(agg$value), , drop = FALSE]
      if (nrow(agg) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas assez de donnees pour ce filtre") + ggplot2::theme_void())
      }
      agg <- merge(agg, families, by = "estimator", all.x = TRUE)
      ggplot2::ggplot(agg, ggplot2::aes(x = stats::reorder(.data$estimator, .data$value), y = .data$value, fill = .data$dashboard_group)) +
        ggplot2::geom_col() +
        ggplot2::scale_fill_manual(values = dashboard_group_palette(), drop = TRUE) +
        ggplot2::labs(x = NULL, y = "|I - E(I)| (or |I| fallback, median)", fill = "Estimator family") +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(
          axis.text.x = ggplot2::element_text(angle = 30, hjust = 1),
          legend.position = "bottom",
          panel.grid.minor = ggplot2::element_blank()
        )
    })

    output$failure_table <- DT::renderDT({
      require_package("DT", "le tableau des echecs du dashboard")
      out <- dashboard_failure_summary(filtered_results())
      # Failure rates stay raw proportions (0-1) here; DT::formatPercentage()
      # below does the *100 and "%" display, so the underlying sort/compare
      # value is still numeric rather than baked into a display string.
      display <- data.frame(
        Estimator = out$estimator,
        `Failed folds (total)` = out$n_failed,
        `Failed folds (%)` = out$failure_rate,
        `Datasets affected (n)` = out$datasets_affected,
        `Worst failure rate (%)` = out$worst_case_failure_rate,
        check.names = FALSE
      )
      DT::datatable(
        display,
        rownames = FALSE,
        options = list(dom = "t", paging = FALSE, ordering = TRUE, autoWidth = TRUE),
        class = "stripe hover"
      ) |> DT::formatPercentage(c("Failed folds (%)", "Worst failure rate (%)"), digits = 1)
      # server = FALSE (client-side rendering): this table has one row per
      # estimator, never enough to need DT's server-side AJAX round-trip --
      # and server-side mode is DT::renderDT()'s default, which also means
      # the row data isn't embedded in the widget at all until a request
      # completes, an unnecessary complication for a handful of rows.
    }, server = FALSE)

    shiny::observeEvent(input$reset_filters, {
      shiny::updateRadioButtons(session, "cv_scheme_filter", selected = cv_scheme_choices[[1]])
      shiny::updateSelectInput(session, "baseline", selected = baseline_default)
      shiny::updateSelectInput(session, "metric", selected = metric_choices[[1]])
    })

    invisible(NULL)
  })
}
