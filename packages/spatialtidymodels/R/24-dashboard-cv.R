# CV Schemes page module.
#
# Answers one question: "how does an estimator's performance change across
# CV schemes -- without pooling them into one number?" An estimator that
# looks great in near_prediction and mediocre in block_spatial must be
# visible as exactly that, side by side -- never averaged into a single
# figure. Every number on this page comes from
# dashboard_relative_metric_by_scheme()/dashboard_failure_summary_by_scheme()
# (R/18), which compute each scheme independently and only ever stack the
# per-scheme results with a `cv_scheme` column; nothing here mixes cases
# across schemes into a shared statistic.

mod_cv_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$div(
      class = "dashboard-subtitle",
      "How does an estimator's performance change across CV schemes -- without pooling them into one number?"
    ),
    shiny::uiOutput(ns("body"))
  )
}

#' @param id Module namespace id.
#' @param results Suite results `data.frame` (all CV schemes).
#' @param families Output of [dashboard_estimator_families()].
#' @param baseline_default Estimator preselected as the baseline.
#' @noRd
mod_cv_server <- function(id, results, families, baseline_default) {
  shiny::moduleServer(id, function(input, output, session) {
    cv_schemes <- sort(unique(results$cv_scheme))
    estimator_choices <- sort(unique(results$estimator))
    metric_choices <- intersect(c("rmse", "mae", "moran_abs", "duration_sec"), names(results))
    # accuracy/auc/deviance (2026-09, classification/comptage): toujours
    # presentes comme colonnes des que le harnais binaire/comptage est
    # utilise (voir make_metric_values(), 12-diagnose-spatial.R), mais NA
    # partout pour une suite purement continue -- ne les proposer que si au
    # moins une valeur finie existe, sinon le menu contiendrait une option
    # qui ne renvoie jamais de donnees.
    for (extra in c("accuracy", "auc", "deviance")) {
      if (extra %in% names(results) && any(is.finite(results[[extra]]))) {
        metric_choices <- c(metric_choices, extra)
      }
    }

    output$body <- shiny::renderUI({
      ns <- session$ns
      if (length(cv_schemes) < 2L) {
        return(shiny::tags$div(
          class = "dashboard-placeholder",
          shiny::tags$p(sprintf(
            "Only one CV scheme (%s) is present in this suite -- nothing to compare side by side.",
            paste(cv_schemes, collapse = ", ")
          ))
        ))
      }
      shiny::tagList(
        shiny::tags$div(
          class = "dashboard-filterbar",
          shiny::selectInput(ns("baseline"), "Baseline", choices = estimator_choices, selected = baseline_default),
          shiny::selectInput(ns("metric"), "Metric", choices = metric_choices, selected = metric_choices[[1]])
        ),
        bslib::card(
          bslib::card_header("Relative performance by estimator x CV scheme", shiny::tags$span(class = "dashboard-card-note", "values < 1.0 are better than baseline")),
          shiny::uiOutput(ns("scheme_heatmap"))
        ),
        bslib::card(
          bslib::card_header("Median relative metric per estimator, by scheme"),
          shiny::plotOutput(ns("scheme_bars"), height = "360px")
        ),
        bslib::card(
          bslib::card_header("Fold failures by CV scheme"),
          DT::DTOutput(ns("failure_table"))
        )
      )
    })

    scheme_matrix <- shiny::reactive({
      shiny::req(input$baseline, input$metric)
      # accuracy/auc (classification, 2026-09): higher is better, contrairement
      # a tous les autres metriques de cette page -- sans ca, le ratio relatif
      # serait invers e (une plus faible accuracy relative se lirait comme
      # "meilleure").
      lower_is_better <- !input$metric %in% c("accuracy", "auc")
      dashboard_relative_metric_by_scheme(
        results, baseline_estimator = input$baseline, metric = input$metric,
        lower_is_better = lower_is_better, cv_schemes = cv_schemes
      )
    })

    output$scheme_heatmap <- shiny::renderUI({
      agg <- scheme_matrix()
      if (nrow(agg) == 0L) return(shiny::tags$p("Pas assez de donnees pour ce filtre."))
      wide <- stats::reshape(agg[, c("estimator", "cv_scheme", "median_relative")], idvar = "estimator", timevar = "cv_scheme", direction = "wide")
      names(wide) <- sub("^median_relative\\.", "", names(wide))
      missing_scheme <- setdiff(cv_schemes, names(wide))
      for (s in missing_scheme) wide[[s]] <- NA_real_
      wide <- wide[, c("estimator", cv_schemes), drop = FALSE]
      wide <- wide[order(wide$estimator), , drop = FALSE]

      header <- shiny::tags$tr(shiny::tags$th("Estimator"), lapply(cv_schemes, shiny::tags$th))
      body_rows <- lapply(seq_len(nrow(wide)), function(i) {
        shiny::tags$tr(
          shiny::tags$td(wide$estimator[[i]]),
          lapply(cv_schemes, function(s) {
            val <- wide[[s]][[i]]
            label <- if (is.na(val)) "–" else sprintf("%.2f", val)
            shiny::tags$td(label, style = sprintf("background-color:%s;text-align:center;", dashboard_heatmap_color(val)))
          })
        )
      })
      shiny::tags$div(
        class = "dashboard-table-scroll",
        shiny::tags$table(class = "dashboard-heatmap-table", shiny::tags$thead(header), shiny::tags$tbody(body_rows))
      )
    })

    output$scheme_bars <- shiny::renderPlot({
      require_package("ggplot2", "le graphique CV schemes du dashboard")
      agg <- scheme_matrix()
      agg <- agg[is.finite(agg$median_relative), , drop = FALSE]
      if (nrow(agg) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas assez de donnees pour ce filtre") + ggplot2::theme_void())
      }
      agg <- merge(agg, families, by = "estimator", all.x = TRUE)
      ggplot2::ggplot(agg, ggplot2::aes(x = .data$estimator, y = .data$median_relative, fill = .data$dashboard_group)) +
        ggplot2::geom_col() +
        ggplot2::geom_hline(yintercept = 1, linewidth = 0.3, linetype = "dashed", color = "#666") +
        ggplot2::facet_wrap(~cv_scheme) +
        ggplot2::scale_fill_manual(values = dashboard_group_palette(), drop = TRUE) +
        ggplot2::labs(x = NULL, y = sprintf("Median relative %s (vs %s)", input$metric, input$baseline), fill = "Estimator family") +
        ggplot2::theme_minimal(base_size = 12) +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 40, hjust = 1), legend.position = "bottom")
    })

    output$failure_table <- DT::renderDT({
      require_package("DT", "le tableau des echecs par scheme du dashboard")
      fs <- dashboard_failure_summary_by_scheme(results, cv_schemes = cv_schemes)
      display <- data.frame(
        `CV scheme` = fs$cv_scheme,
        Estimator = fs$estimator,
        `Failed folds (total)` = fs$n_failed,
        `Failed folds (%)` = fs$failure_rate,
        `Worst failure rate (%)` = fs$worst_case_failure_rate,
        check.names = FALSE
      )
      DT::datatable(
        display, rownames = FALSE,
        options = list(pageLength = 15, scrollX = TRUE),
        class = "stripe hover"
      ) |> DT::formatPercentage(c("Failed folds (%)", "Worst failure rate (%)"), digits = 1)
    }, server = FALSE)

    invisible(NULL)
  })
}
