# Dashboard orchestrator.
#
# launch_benchmark_dashboard() is the package's one public dashboard entry
# point (and stays that way -- this file must not break its existing usage).
# It validates the suite, then wires together the page modules:
#   R/20-dashboard-theme.R       shared bs_theme() + CSS + KPI card/icon/logo helpers
#   R/21-dashboard-overview.R    Overview
#   R/22-dashboard-comparison.R  Reference vs Variant
#   R/23-dashboard-datasets.R    Datasets
#   R/24-dashboard-cv.R          CV Schemes
#   R/25-dashboard-methodology.R Methodology / About
# All calculation stays in R/18-dashboard-data.R; nothing here recomputes a
# KPI, ratio, or verdict -- pages only arrange what those functions return.
#
# Navigation is a single left sidebar (page nav + estimator-family filter),
# not a horizontal navbar: a page-switching bar AND a separate sidebar would
# be two navigation systems for one app. Implemented as a plain
# shiny::tabsetPanel(type = "hidden") whose visible tab headers are replaced
# by the sidebar's own actionLinks -- switching pages never refits anything,
# it only changes which already-built module UI is shown.

dashboard_page_ids <- c(
  Overview = "overview",
  `Reference vs Variant` = "comparison",
  Datasets = "datasets",
  `CV Schemes` = "cv",
  Methodology = "methodology"
)
dashboard_page_icons <- c(
  Overview = "grid", `Reference vs Variant` = "compare", Datasets = "database",
  `CV Schemes` = "layers", Methodology = "info"
)

dashboard_sidebar_ui <- function() {
  shiny::tags$aside(
    class = "dashboard-sidebar",
    shiny::tags$div(
      class = "dashboard-sidebar-brand",
      dashboard_logo(28),
      shiny::tags$span("Spatialtidymodels")
    ),
    shiny::tags$nav(class = "dashboard-sidebar-nav", shiny::uiOutput("sidebar_nav")),
    shiny::tags$div(class = "dashboard-sidebar-footer", sprintf("spatialtidymodels v%s", utils::packageVersion("spatialtidymodels")))
  )
}

dashboard_sidebar_link <- function(input_id, label, icon = NULL, active = FALSE, swatch_color = NULL) {
  shiny::tags$a(
    id = input_id, class = paste("dashboard-sidebar-link action-button", if (active) "active" else ""),
    href = "#",
    if (!is.null(icon)) shiny::tags$span(class = "dashboard-sidebar-icon", dashboard_icon(icon, size = 15)),
    if (!is.null(swatch_color)) shiny::tags$span(class = "dashboard-sidebar-swatch", style = sprintf("background-color:%s;", swatch_color)),
    shiny::tags$span(label)
  )
}

#' Launch the benchmark dashboard
#'
#' Opens a multi-page Shiny app for a benchmark suite: an Overview (headline
#' KPIs, relative-metric heatmap, performance-vs-duration, residual spatial
#' dependence, fold failures), plus Reference vs Variant / Datasets / CV
#' Schemes / Methodology pages, navigated from a single left sidebar. Filters
#' only subset already-computed results -- nothing is refit when a filter or
#' page changes.
#'
#' @param suite A `spatial_benchmark_suite` (from [benchmark_spatial_suite()])
#'   or a results-shaped `data.frame`.
#' @param baseline_estimator Estimator every relative KPI/heatmap/scatter is
#'   expressed against by default. Must be present in `suite`'s `estimator`
#'   column. Default `"ols"`.
#' @param launch If `TRUE` (default), blocks and runs the app
#'   (`shiny::runApp()`). If `FALSE`, returns the `shiny::shinyApp()` object
#'   without running it -- used by tests and for embedding in another app.
#'
#' @return Invisibly, the result of `shiny::runApp()` when `launch = TRUE`;
#'   otherwise the `shiny.appobj` itself.
#' @export
launch_benchmark_dashboard <- function(suite, baseline_estimator = "ols", launch = TRUE) {
  require_package("shiny", "le dashboard spatialtidymodels")
  require_package("bslib", "le dashboard spatialtidymodels")
  require_package("DT", "le dashboard spatialtidymodels")

  results <- dashboard_results_table(suite)
  required_cols <- c("dataset", "cv_scheme", "estimator", "rmse", "mae", "duration_sec")
  missing_cols <- setdiff(required_cols, names(results))
  if (!any(c("moran_i", "moran_abs") %in% names(results))) {
    missing_cols <- c(missing_cols, "moran_i/moran_abs")
  }
  if (length(missing_cols)) {
    stop(sprintf("Colonnes manquantes dans les resultats: %s", paste(missing_cols, collapse = ", ")), call. = FALSE)
  }
  if (!baseline_estimator %in% results$estimator) {
    stop(sprintf(
      "baseline_estimator '%s' introuvable dans les resultats. Estimateurs disponibles: %s",
      baseline_estimator, paste(sort(unique(results$estimator)), collapse = ", ")
    ), call. = FALSE)
  }

  has_moran <- "moran_i" %in% names(results)
  if (!"moran_abs" %in% names(results) && has_moran) {
    results$moran_abs <- abs(results$moran_i)
  }
  metric_choices <- intersect(c("rmse", "mae", "moran_abs", "duration_sec"), names(results))
  # accuracy/auc/deviance (2026-09, classification/comptage): meme logique
  # que mod_cv_server() (24-dashboard-cv.R) -- ne proposer que si au moins
  # une valeur finie existe, sinon le menu contiendrait une option morte
  # pour une suite purement continue (colonnes toujours presentes mais NA,
  # voir make_metric_values() dans 12-diagnose-spatial.R).
  for (extra in c("accuracy", "auc", "deviance")) {
    if (extra %in% names(results) && any(is.finite(results[[extra]]))) {
      metric_choices <- c(metric_choices, extra)
    }
  }
  cv_scheme_choices <- sort(unique(results$cv_scheme))
  estimator_choices <- sort(unique(results$estimator))
  baseline_default <- if (baseline_estimator %in% estimator_choices) baseline_estimator else estimator_choices[[1]]
  families <- dashboard_estimator_families(results)
  dataset_metadata <- if (inherits(suite, "spatial_benchmark_suite")) suite$dataset_metadata else NULL
  taxonomy <- tryCatch(available_benchmark_estimators(include_installed = FALSE), error = function(e) NULL)
  default_candidate <- setdiff(estimator_choices, baseline_default)
  default_candidate <- if (length(default_candidate)) default_candidate[[1]] else baseline_default

  # Estimator-family sidebar section: only the dashboard_group values
  # actually present in this suite, ordered per dashboard_group_palette()'s
  # canonical order (falls back to alphabetical for anything outside it).
  group_palette_order <- names(dashboard_group_palette())
  group_choices <- unique(families$dashboard_group)
  group_choices <- c(intersect(group_palette_order, group_choices), setdiff(group_choices, group_palette_order))

  ui <- bslib::page_fillable(
    title = "Spatialtidymodels Benchmark Dashboard",
    theme = dashboard_theme(),
    padding = 0,
    dashboard_include_css(),
    shiny::tags$div(
      class = "dashboard-shell",
      dashboard_sidebar_ui(),
      shiny::tags$div(
        class = "dashboard-main",
        shiny::tags$header(
          class = "dashboard-topbar",
          shiny::tags$h3("Spatialtidymodels Benchmark Dashboard"),
          shiny::tags$a(
            id = "nav_methodology_about", class = "dashboard-topbar-about action-button", href = "#",
            dashboard_icon("info", size = 15), shiny::tags$span("About")
          )
        ),
        shiny::tags$div(
          class = "dashboard-content",
          shiny::tabsetPanel(
            id = "page_nav", type = "hidden",
            shiny::tabPanelBody("overview", mod_overview_ui("overview", cv_scheme_choices, estimator_choices, metric_choices, baseline_default)),
            shiny::tabPanelBody("comparison", mod_comparison_ui("comparison", estimator_choices, cv_scheme_choices, metric_choices, baseline_default, default_candidate)),
            shiny::tabPanelBody("datasets", mod_datasets_ui("datasets")),
            shiny::tabPanelBody("cv", mod_cv_ui("cv")),
            shiny::tabPanelBody("methodology", mod_methodology_ui("methodology"))
          )
        )
      )
    )
  )

  server <- function(input, output, session) {
    selected_group <- shiny::reactiveVal("All")

    output$sidebar_nav <- shiny::renderUI({
      current_page <- input$page_nav %||% "overview"
      current_group <- selected_group()

      page_section <- shiny::tags$div(
        class = "dashboard-sidebar-section",
        shiny::tags$div(class = "dashboard-sidebar-section-title", "Overview"),
        dashboard_sidebar_link("nav_overview", "Overview", icon = dashboard_page_icons[["Overview"]], active = identical(current_page, "overview"))
      )
      analysis_section <- shiny::tags$div(
        class = "dashboard-sidebar-section",
        shiny::tags$div(class = "dashboard-sidebar-section-title", "Analysis"),
        dashboard_sidebar_link("nav_comparison", "Reference vs Variant", icon = dashboard_page_icons[["Reference vs Variant"]], active = identical(current_page, "comparison")),
        dashboard_sidebar_link("nav_datasets", "Datasets", icon = dashboard_page_icons[["Datasets"]], active = identical(current_page, "datasets")),
        dashboard_sidebar_link("nav_cv", "CV Schemes", icon = dashboard_page_icons[["CV Schemes"]], active = identical(current_page, "cv"))
      )
      families_section <- shiny::tags$div(
        class = "dashboard-sidebar-section",
        shiny::tags$div(class = "dashboard-sidebar-section-title", "Estimator Families"),
        dashboard_sidebar_link("group_All", "All", active = identical(current_group, "All")),
        lapply(group_choices, function(grp) {
          swatch <- unname(dashboard_group_palette()[grp]) # NA (not NULL) for an unmapped group
          if (is.na(swatch)) swatch <- unname(dashboard_group_palette()[["Other"]])
          dashboard_sidebar_link(
            paste0("group_", make.names(grp)), grp,
            active = identical(current_group, grp),
            swatch_color = swatch
          )
        })
      )
      info_section <- shiny::tags$div(
        class = "dashboard-sidebar-section",
        shiny::tags$div(class = "dashboard-sidebar-section-title", "Info"),
        dashboard_sidebar_link("nav_methodology", "Methodology", icon = dashboard_page_icons[["Methodology"]], active = identical(current_page, "methodology"))
      )
      shiny::tagList(page_section, analysis_section, families_section, info_section)
    })
    shiny::outputOptions(output, "sidebar_nav", suspendWhenHidden = FALSE)

    # Page navigation: clicking a sidebar link switches the hidden
    # tabsetPanel's selected tab. Never refits anything -- it only changes
    # which already-built module UI is visible.
    for (page_label in names(dashboard_page_ids)) {
      local({
        page_id <- dashboard_page_ids[[page_label]]
        input_id <- paste0("nav_", page_id)
        shiny::observeEvent(input[[input_id]], {
          shiny::updateTabsetPanel(session, "page_nav", selected = page_id)
        }, ignoreInit = TRUE)
      })
    }
    shiny::observeEvent(input$nav_methodology_about, {
      shiny::updateTabsetPanel(session, "page_nav", selected = "methodology")
    }, ignoreInit = TRUE)

    # Estimator-family filter: shared sidebar state, read by
    # mod_overview_server() via the `selected_group` reactive. Selecting a
    # family also navigates to Overview, since that's the only page it
    # currently filters.
    shiny::observeEvent(input$group_All, {
      selected_group("All")
      shiny::updateTabsetPanel(session, "page_nav", selected = "overview")
    }, ignoreInit = TRUE)
    for (grp in group_choices) {
      local({
        this_group <- grp
        input_id <- paste0("group_", make.names(this_group))
        shiny::observeEvent(input[[input_id]], {
          selected_group(this_group)
          shiny::updateTabsetPanel(session, "page_nav", selected = "overview")
        }, ignoreInit = TRUE)
      })
    }

    mod_overview_server("overview", results = results, families = families,
                        baseline_default = baseline_default,
                        cv_scheme_choices = cv_scheme_choices, metric_choices = metric_choices,
                        selected_group = selected_group)
    mod_comparison_server("comparison", results = results, dataset_metadata = dataset_metadata, taxonomy = taxonomy)
    mod_datasets_server("datasets", dataset_metadata = dataset_metadata)
    mod_cv_server("cv", results = results, families = families, baseline_default = baseline_default)
    mod_methodology_server("methodology", suite = suite, results = results)
  }

  app <- shiny::shinyApp(ui, server)
  if (isTRUE(launch)) {
    return(invisible(shiny::runApp(app)))
  }
  app
}
