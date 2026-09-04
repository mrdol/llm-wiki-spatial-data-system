# Reference vs Variant page module.
#
# Answers one question: "does this specific candidate beat this specific
# reference, and where does it win/lose?" This page is a pure display layer
# over compare_estimator_variant()/comparison_rules() (R/16) -- it must NEVER
# recompute SUPERIOR/TRADEOFF/EQUIVALENT/etc. itself, only arrange what that
# function already returned ($summary, $verdict, $verdict_reasons, $per_case,
# $guardrails, $subgroups). A cv_scheme is always fixed to one explicit
# choice here (same rule as everywhere else in this dashboard): the
# comparison never silently pools schemes.

#' @param id Module namespace id.
#' @param estimator_choices,cv_scheme_choices,metric_choices Static choice
#'   lists computed once from the suite's results table.
#' @param default_reference,default_candidate Preselected reference/candidate.
#' @noRd
mod_comparison_ui <- function(id, estimator_choices, cv_scheme_choices, metric_choices, default_reference, default_candidate) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$div(
      class = "dashboard-subtitle",
      "Does a specific candidate estimator beat a specific reference, and where? Verdict and thresholds come directly from compare_estimator_variant() -- never recomputed here."
    ),
    shiny::tags$div(
      class = "dashboard-filterbar",
      shiny::selectInput(ns("reference"), "Reference estimator", choices = estimator_choices, selected = default_reference),
      shiny::selectInput(ns("candidate"), "Candidate estimator", choices = estimator_choices, selected = default_candidate),
      shiny::radioButtons(ns("cv_scheme"), "CV scheme", choices = cv_scheme_choices, selected = cv_scheme_choices[[1]], inline = TRUE),
      shiny::selectInput(ns("primary_metric"), "Primary metric", choices = metric_choices, selected = metric_choices[[1]])
    ),
    shiny::uiOutput(ns("body"))
  )
}

dashboard_verdict_badge_html <- function(verdict, reasons) {
  color <- dashboard_verdict_color(verdict)
  shiny::tagList(
    shiny::tags$span(
      style = sprintf("background-color:%s;color:#fff;padding:3px 10px;border-radius:4px;font-weight:600;font-size:0.85em;display:inline-block;", color),
      verdict
    ),
    if (length(reasons) > 0) shiny::tags$div(class = "dashboard-kpi-sub", style = "margin-top:6px;font-size:0.7em;", paste(reasons, collapse = " "))
  )
}

dashboard_comparison_kpi_row <- function(cmp) {
  s <- cmp$summary
  win_rate_txt <- if (is.na(s$win_rate)) "n/a" else sprintf("%.0f%%", 100 * s$win_rate)
  median_delta_txt <- if (is.na(s$median_delta)) "n/a" else sprintf("%+.1f%%", s$median_delta)
  worst_txt <- if (is.na(s$worst_delta)) "n/a" else sprintf("%+.1f%%", s$worst_delta)
  failure_diff_txt <- if (is.na(s$failure_rate_increase)) "n/a" else sprintf("%+.1f pts", 100 * s$failure_rate_increase)

  median_class <- if (is.na(s$median_delta)) "" else if (s$median_delta > 0.5) "better" else if (s$median_delta < -0.5) "worse" else "neutral-accent"
  worst_class <- if (is.na(s$worst_delta)) "" else if (s$worst_delta < -0.5) "worse" else "neutral-accent"
  failure_class <- if (is.na(s$failure_rate_increase)) "" else if (s$failure_rate_increase > 0) "worse" else "neutral-accent"

  bslib::layout_columns(
    col_widths = c(3, 3, 2, 2, 2),
    dashboard_kpi_card("Win rate", win_rate_txt, comparison = sprintf("n=%d cases", s$n_cases), icon = "target", value_class = "neutral-accent"),
    dashboard_kpi_card(sprintf("Median Δ %s", s$primary_metric), median_delta_txt, icon = "chart", value_class = median_class),
    dashboard_kpi_card("Worst case", worst_txt, icon = "alert", value_class = worst_class),
    dashboard_kpi_card("Failure-rate Δ", failure_diff_txt, icon = "alert", value_class = failure_class),
    dashboard_kpi_card("Verdict", dashboard_verdict_badge_html(cmp$verdict, cmp$verdict_reasons), icon = "shield", value_class = "")
  )
}

#' Pick the Candidate dropdown's choices/selection for a given reference
#'
#' Pure decision logic behind the Candidate dropdown's "propose declared
#' variants first" behavior (kept out of the reactive observer so it's
#' directly unit-testable without a live Shiny session). Never restricts
#' what can be compared -- `choices` always includes every estimator, just
#' grouped so declared variants of `reference` appear first when there are
#' any.
#'
#' @param reference Selected reference estimator.
#' @param current_candidate The candidate input's current value (or `NULL`).
#' @param all_estimators Every estimator present in the suite's results.
#' @param taxonomy `available_benchmark_estimators()` output (or `NULL`) --
#'   only its `estimator`/`reference_estimator` columns are used.
#'
#' @return A list: `choices` (a flat vector, or a named list of two vectors
#'   for `<optgroup>`s when `reference` has declared variants) and
#'   `selected` -- the already-valid `current_candidate` if there is one,
#'   otherwise the first declared variant, otherwise the first other
#'   estimator.
#' @noRd
dashboard_default_candidate <- function(reference, current_candidate, all_estimators, taxonomy) {
  variants <- character(0)
  if (!is.null(taxonomy) && all(c("estimator", "reference_estimator") %in% names(taxonomy))) {
    variants <- taxonomy$estimator[!is.na(taxonomy$reference_estimator) & taxonomy$reference_estimator == reference]
    variants <- intersect(variants, all_estimators)
  }
  others <- setdiff(all_estimators, c(reference, variants))
  choices <- if (length(variants) > 0) {
    stats::setNames(list(variants, others), c(sprintf("Declared variants of %s", reference), "Other estimators"))
  } else {
    all_estimators
  }
  selected <- if (!is.null(current_candidate) && current_candidate %in% all_estimators && !identical(current_candidate, reference)) {
    current_candidate
  } else if (length(variants) > 0) {
    variants[[1]]
  } else {
    (setdiff(all_estimators, reference))[[1]]
  }
  list(choices = choices, selected = selected)
}

#' @param id Module namespace id, must match [mod_comparison_ui()]'s.
#' @param results Suite results `data.frame` (all CV schemes).
#' @param dataset_metadata `suite$dataset_metadata` (or `NULL`), used only
#'   for the n-tertile subgroup dimension -- see
#'   [dashboard_n_tertile_groups()].
#' @param taxonomy `available_benchmark_estimators()` output (or `NULL`),
#'   used only to prioritize a reference's declared variants in the
#'   Candidate dropdown -- never affects the comparison itself.
#' @noRd
mod_comparison_server <- function(id, results, dataset_metadata, taxonomy) {
  shiny::moduleServer(id, function(input, output, session) {
    # Guide the Candidate dropdown toward the selected reference's declared
    # variants (family/role/reference_estimator/dashboard_group), per the
    # working notes: "Reference = sar_lag -> propose its declared variants
    # first." Purely a UI convenience -- never restricts what can be
    # compared, just reorders/groups the choices. The actual decision logic
    # is a pure function (dashboard_default_candidate() below) so it's
    # directly unit-testable without a live Shiny session.
    shiny::observeEvent(input$reference, {
      all_estimators <- sort(unique(results$estimator))
      current <- shiny::isolate(input$candidate)
      result <- dashboard_default_candidate(input$reference, current, all_estimators, taxonomy)
      shiny::updateSelectInput(session, "candidate", choices = result$choices, selected = result$selected)
    }, ignoreNULL = TRUE)

    cmp <- shiny::reactive({
      shiny::req(input$reference, input$candidate, input$cv_scheme, input$primary_metric)
      shiny::validate(shiny::need(!identical(input$reference, input$candidate), "Reference et candidat doivent etre differents."))

      groups <- dashboard_n_tertile_groups(dataset_metadata)
      tryCatch(
        compare_estimator_variant(
          results,
          reference = input$reference, candidate = input$candidate,
          cv_scheme = input$cv_scheme, primary_metric = input$primary_metric,
          groups = groups
        ),
        error = function(e) e
      )
    })

    output$body <- shiny::renderUI({
      x <- cmp()
      ns <- session$ns
      if (inherits(x, "error")) {
        return(shiny::tags$div(class = "dashboard-placeholder", shiny::tags$p(conditionMessage(x))))
      }
      shiny::tagList(
        dashboard_comparison_kpi_row(x),
        bslib::card(
          bslib::card_header(sprintf("Δ %s by dataset (positive = candidate better)", x$summary$primary_metric)),
          shiny::plotOutput(ns("delta_plot"), height = "340px")
        ),
        bslib::layout_columns(
          col_widths = c(6, 6),
          bslib::card(
            bslib::card_header("Win / Tie / Loss"),
            shiny::plotOutput(ns("outcome_plot"), height = "300px")
          ),
          bslib::card(
            bslib::card_header(sprintf("Δ %s vs Δ residual dependence", x$summary$primary_metric)),
            shiny::plotOutput(ns("tradeoff_plot"), height = "300px")
          )
        ),
        bslib::layout_columns(
          col_widths = c(6, 6),
          bslib::card(
            bslib::card_header("Guardrails"),
            shiny::uiOutput(ns("guardrails_ui"))
          ),
          bslib::card(
            bslib::card_header("Subgroup analysis"),
            shiny::uiOutput(ns("subgroups_ui"))
          )
        )
      )
    })

    output$delta_plot <- shiny::renderPlot({
      x <- cmp()
      shiny::req(!inherits(x, "error"))
      require_package("ggplot2", "le graphique delta du dashboard")
      delta_col <- paste0("delta_", x$summary$primary_metric)
      pc <- x$per_case[!is.na(x$per_case[[delta_col]]), , drop = FALSE]
      if (nrow(pc) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas de cas valide pour ce filtre") + ggplot2::theme_void())
      }
      ggplot2::ggplot(pc, ggplot2::aes(x = stats::reorder(.data$dataset, .data[[delta_col]]), y = .data[[delta_col]], fill = .data[[delta_col]] > 0)) +
        ggplot2::geom_col() +
        ggplot2::geom_hline(yintercept = 0, linewidth = 0.4, color = "#333") +
        ggplot2::scale_fill_manual(values = c(`TRUE` = "#1f7a6c", `FALSE` = "#c1440e"), guide = "none") +
        ggplot2::labs(x = NULL, y = sprintf("Δ %s (%%)", x$summary$primary_metric)) +
        ggplot2::coord_flip() +
        ggplot2::theme_minimal(base_size = 12)
    })

    output$outcome_plot <- shiny::renderPlot({
      x <- cmp()
      shiny::req(!inherits(x, "error"))
      require_package("ggplot2", "le graphique win/tie/loss du dashboard")
      counts <- as.data.frame(table(outcome = x$per_case$outcome), stringsAsFactors = FALSE)
      names(counts) <- c("outcome", "n")
      palette <- c(
        WIN = "#1f7a6c", TIE = "#adb5bd", LOSS = "#c1440e",
        BOTH_FAILED = "#495057", REFERENCE_FAILED = "#f08c00", CANDIDATE_FAILED = "#e64980"
      )
      ggplot2::ggplot(counts, ggplot2::aes(x = stats::reorder(.data$outcome, .data$n), y = .data$n, fill = .data$outcome)) +
        ggplot2::geom_col() +
        ggplot2::geom_text(ggplot2::aes(label = .data$n), hjust = -0.3, size = 4) +
        ggplot2::scale_fill_manual(values = palette, guide = "none") +
        ggplot2::labs(x = NULL, y = "N cases") +
        ggplot2::coord_flip(clip = "off") +
        ggplot2::theme_minimal(base_size = 12)
    })

    output$tradeoff_plot <- shiny::renderPlot({
      x <- cmp()
      shiny::req(!inherits(x, "error"))
      require_package("ggplot2", "le graphique de compromis du dashboard")
      delta_primary <- paste0("delta_", x$summary$primary_metric)
      if (!"delta_moran_abs" %in% names(x$per_case) || identical(x$summary$primary_metric, "moran_abs")) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "delta_moran_abs indisponible pour ce filtre") + ggplot2::theme_void())
      }
      pc <- x$per_case[!is.na(x$per_case[[delta_primary]]) & !is.na(x$per_case$delta_moran_abs), , drop = FALSE]
      if (nrow(pc) == 0L) {
        return(ggplot2::ggplot() + ggplot2::annotate("text", x = 0, y = 0, label = "Pas de cas valide pour ce filtre") + ggplot2::theme_void())
      }
      ggplot2::ggplot(pc, ggplot2::aes(x = .data[[delta_primary]], y = .data$delta_moran_abs, label = .data$dataset)) +
        ggplot2::geom_hline(yintercept = 0, linewidth = 0.3, color = "#999") +
        ggplot2::geom_vline(xintercept = 0, linewidth = 0.3, color = "#999") +
        ggplot2::geom_point(size = 3, color = "#2c5f8a") +
        ggplot2::geom_text(vjust = -0.9, size = 3, show.legend = FALSE) +
        ggplot2::labs(x = sprintf("Δ %s (%%, + = candidate better)", x$summary$primary_metric), y = "Δ residual dependence (moran_abs, %, + = candidate better)") +
        ggplot2::theme_minimal(base_size = 12)
    })

    output$guardrails_ui <- shiny::renderUI({
      x <- cmp()
      shiny::req(!inherits(x, "error"))
      g <- x$guardrails
      if (length(g$breaches) == 0L) {
        return(shiny::tags$p(style = "color:#1f7a6c;", "✓ No guardrail breach."))
      }
      shiny::tags$ul(
        style = "color:#c1440e;",
        lapply(g$breaches, shiny::tags$li)
      )
    })

    output$subgroups_ui <- shiny::renderUI({
      x <- cmp()
      shiny::req(!inherits(x, "error"))
      sg <- x$subgroups
      if (is.null(sg) || nrow(sg$table) == 0L) {
        return(shiny::tags$p(class = "dashboard-kpi-sub", "Not enough metadata for subgroup analysis."))
      }
      rows <- lapply(seq_len(nrow(sg$table)), function(i) {
        g <- sg$table[i, ]
        shiny::tags$tr(
          style = if (isTRUE(g$eligible)) "font-weight:600;background-color:#eef6f3;" else "",
          shiny::tags$td(g$group), shiny::tags$td(g$n_cases),
          shiny::tags$td(sprintf("%.0f%%", 100 * g$win_rate)),
          shiny::tags$td(sprintf("%+.1f%%", g$median_delta))
        )
      })
      shiny::tagList(
        shiny::tags$p(class = "dashboard-kpi-sub", sprintf("Dimension: %s (exploratory -- see SPECIALIZED verdict logic in compare_estimator_variant())", sg$dimension)),
        shiny::tags$table(
          class = "dashboard-heatmap-table",
          shiny::tags$thead(shiny::tags$tr(shiny::tags$th("Group"), shiny::tags$th("n"), shiny::tags$th("Win rate"), shiny::tags$th("Median Δ"))),
          shiny::tags$tbody(rows)
        )
      )
    })

    invisible(NULL)
  })
}
