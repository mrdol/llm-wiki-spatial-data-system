# Theme/CSS shared by every dashboard page module.
#
# One `bslib::bs_theme()` object plus one stylesheet
# (inst/dashboard/www/dashboard.css), instead of each page defining its own
# inline shiny::tags$style(). Not exported: internal to the dashboard's own
# files, not part of the package's public API.

dashboard_theme <- function() {
  # System font stack only (no Google Fonts / CDN): a research dashboard
  # should render identically offline or behind a firewall.
  system_fonts <- bslib::font_collection("Segoe UI", "Helvetica Neue", "Arial", "sans-serif")
  bslib::bs_theme(
    version = 5,
    primary = "#2c5f8a",
    bg = "#f5f7fa",
    fg = "#212529",
    base_font = system_fonts,
    heading_font = system_fonts
  )
}

#' One fixed color per estimator family, used everywhere a plot is colored
#' by family (performance/duration scatter, residual spatial dependence
#' bars) so the same family always reads as the same color across every
#' chart and page -- covers every `family` value in the built-in taxonomy
#' (see ESTIMATOR_TAXONOMY in code/package_metadata/export_spatialtidymodels_metadata.py),
#' plus "other" for anything outside it (custom-registered estimators,
#' dashboard_estimator_families()'s own fallback).
#' @noRd
dashboard_family_palette <- function() {
  c(
    baseline        = "#6c757d",
    SAR             = "#1f7a6c",
    SEM             = "#2c5f8a",
    SDM             = "#6a4c93",
    GWR             = "#c1440e",
    mgwrsar_hybrid  = "#0b7285",
    ESF             = "#5c940d",
    spatialml_grf   = "#e8590c",
    spatialrf       = "#d9480f",
    rfgls           = "#f08c00",
    random_forest   = "#ae3ec9",
    xgboost         = "#e64980",
    earth           = "#495057",
    gam_spatial     = "#343a40",
    other           = "#adb5bd"
  )
}

#' Sidebar/legend order and color for the 6 known dashboard_group sections
#'
#' The sidebar's "Estimator families" section and every chart colored by
#' group (performance/duration scatter, residual spatial dependence bars)
#' use this -- `dashboard_group` (the UI grouping), never `family` (the
#' scientific model family, see [dashboard_family_palette()]) -- so a
#' boosting variant of a SAR model reads as "Boosting" everywhere in the UI,
#' matching how it's grouped in the sidebar. `names()` also gives the
#' canonical section order.
#' @noRd
dashboard_group_palette <- function() {
  c(
    Baselines                = "#6c757d",
    `Spatial Econometrics`   = "#1f7a6c",
    Boosting                 = "#c1440e",
    MGWRSAR                  = "#2c5f8a",
    `Spatial RF`              = "#e8590c",
    `Machine Learning`       = "#ae3ec9",
    Other                    = "#adb5bd"
  )
}

#' Color for a compare_estimator_variant() verdict badge
#'
#' Never used to decide anything -- purely a display mapping from the
#' verdict string compare_estimator_variant() already returned.
#' @noRd
dashboard_verdict_color <- function(verdict) {
  palette <- c(
    SUPERIOR = "#1f7a6c", SPECIALIZED = "#0b7285",
    INFERIOR = "#c1440e", UNSTABLE = "#c1440e",
    TRADEOFF = "#f08c00",
    EQUIVALENT = "#2c5f8a",
    INCONCLUSIVE = "#6c757d", INSUFFICIENT_EVIDENCE = "#6c757d"
  )
  unname(ifelse(verdict %in% names(palette), palette[verdict], "#6c757d"))
}

#' Small inline SVG icon (no external icon-library dependency)
#'
#' A tiny, fixed, hand-drawn icon set (24x24 viewBox, currentColor stroke) --
#' just enough to give KPI cards and the sidebar a visual identity without
#' adding a package dependency (e.g. bsicons) for something this small.
#' @noRd
dashboard_icon <- function(name, size = 18, color = "currentColor") {
  attrs <- sprintf(
    'width="%d" height="%d" viewBox="0 0 24 24" fill="none" stroke="%s" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"',
    size, size, color
  )
  body <- switch(name,
    chart = '<polyline points="3 17 9 11 13 15 21 6"></polyline><polyline points="15 6 21 6 21 12"></polyline>',
    target = '<circle cx="12" cy="12" r="8"></circle><circle cx="12" cy="12" r="3"></circle><line x1="12" y1="2" x2="12" y2="5"></line><line x1="12" y1="19" x2="12" y2="22"></line><line x1="2" y1="12" x2="5" y2="12"></line><line x1="19" y1="12" x2="22" y2="12"></line>',
    clock = '<circle cx="12" cy="12" r="9"></circle><polyline points="12 7 12 12 16 14"></polyline>',
    shield = '<path d="M12 2 4 5v6c0 5 3.5 8.5 8 9 4.5-.5 8-4 8-9V5z"></path><polyline points="9 12 11 14 15 10"></polyline>',
    database = '<ellipse cx="12" cy="5" rx="8" ry="3"></ellipse><path d="M4 5v14c0 1.7 3.6 3 8 3s8-1.3 8-3V5"></path><path d="M4 12c0 1.7 3.6 3 8 3s8-1.3 8-3"></path>',
    layers = '<polygon points="12 2 22 8 12 14 2 8"></polygon><polyline points="2 14 12 20 22 14"></polyline><polyline points="2 11 12 17 22 11"></polyline>',
    info = '<circle cx="12" cy="12" r="9"></circle><line x1="12" y1="11" x2="12" y2="16"></line><circle cx="12" cy="7.5" r="0.6" fill="currentColor" stroke="none"></circle>',
    scatter = '<circle cx="6" cy="17" r="1.4"></circle><circle cx="10" cy="9" r="1.4"></circle><circle cx="15" cy="13" r="1.4"></circle><circle cx="19" cy="6" r="1.4"></circle><line x1="3" y1="21" x2="3" y2="3"></line><line x1="3" y1="21" x2="21" y2="21"></line>',
    compare = '<line x1="6" y1="3" x2="6" y2="21"></line><line x1="18" y1="3" x2="18" y2="21"></line><polyline points="3 8 6 5 9 8"></polyline><polyline points="15 16 18 19 21 16"></polyline>',
    alert = '<path d="M12 3 2 20h20L12 3z"></path><line x1="12" y1="10" x2="12" y2="15"></line><circle cx="12" cy="17.5" r="0.6" fill="currentColor" stroke="none"></circle>',
    grid = '<rect x="3" y="3" width="7" height="7" rx="1"></rect><rect x="14" y="3" width="7" height="7" rx="1"></rect><rect x="3" y="14" width="7" height="7" rx="1"></rect><rect x="14" y="14" width="7" height="7" rx="1"></rect>',
    ""
  )
  shiny::HTML(sprintf("<svg %s>%s</svg>", attrs, body))
}

#' Small inline SVG brand mark (spatial network motif)
#' @noRd
dashboard_logo <- function(size = 30) {
  shiny::HTML(sprintf('
    <svg width="%d" height="%d" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
      <line x1="10" y1="10" x2="20" y2="20" stroke="#2c5f8a" stroke-width="1.6"/>
      <line x1="30" y1="10" x2="20" y2="20" stroke="#2c5f8a" stroke-width="1.6"/>
      <line x1="10" y1="30" x2="20" y2="20" stroke="#1f7a6c" stroke-width="1.6"/>
      <line x1="30" y1="30" x2="20" y2="20" stroke="#1f7a6c" stroke-width="1.6"/>
      <line x1="10" y1="10" x2="10" y2="30" stroke="#adb5bd" stroke-width="1.1"/>
      <line x1="30" y1="10" x2="30" y2="30" stroke="#adb5bd" stroke-width="1.1"/>
      <circle cx="20" cy="20" r="4.4" fill="#2c5f8a"/>
      <circle cx="10" cy="10" r="3" fill="#1f7a6c"/>
      <circle cx="30" cy="10" r="3" fill="#1f7a6c"/>
      <circle cx="10" cy="30" r="3" fill="#0b7285"/>
      <circle cx="30" cy="30" r="3" fill="#0b7285"/>
    </svg>
  ', size, size))
}

#' Two-column label/value HTML table (Methodology page, Datasets detail view)
#'
#' @param pairs A named list or named character vector; each name becomes a
#'   row label, each value the row's content (character or `shiny.tag`).
#' @noRd
dashboard_kv_table_html <- function(pairs) {
  rows <- lapply(names(pairs), function(k) {
    shiny::tags$tr(shiny::tags$th(k), shiny::tags$td(pairs[[k]]))
  })
  shiny::tags$table(class = "dashboard-methodology-table", shiny::tags$tbody(rows))
}

#' Custom KPI card: title / value / estimator / comparison / icon
#'
#' Replaces `bslib::value_box()`, which proved hard to control precisely
#' enough to guarantee no internal scrollbar or clipped text across every
#' KPI content length (a long estimator name, an "n/a" empty state, a long
#' verdict reason). Built directly on `bslib::card()` with a `min-height`
#' only (never a fixed/clipped height, see `.dashboard-kpi-card` in
#' dashboard.css) so content always fits instead of scrolling or truncating.
#'
#' @param title KPI title (top-left, small caps).
#' @param value Main value -- a string, or a `shiny.tag`/`tagList` for
#'   richer content (e.g. a verdict badge).
#' @param estimator Estimator name line (optional).
#' @param comparison Secondary comparison line, e.g. `"vs ols (n=5 datasets)"`
#'   (optional).
#' @param icon Name passed to [dashboard_icon()], or `NULL` for none.
#' @param value_class One of `"better"`/`"worse"`/`"neutral-accent"`/`""`
#'   for the value's color (see dashboard.css).
#' @noRd
dashboard_kpi_card <- function(title, value, estimator = NULL, comparison = NULL, icon = NULL, value_class = "neutral-accent") {
  bslib::card(
    class = "dashboard-kpi-card",
    shiny::tags$div(
      class = "dashboard-kpi-card-top",
      shiny::tags$span(class = "dashboard-kpi-title", title),
      if (!is.null(icon)) shiny::tags$span(class = "dashboard-kpi-icon", dashboard_icon(icon))
    ),
    shiny::tags$div(class = paste("dashboard-kpi-value", value_class), value),
    if (!is.null(estimator)) shiny::tags$div(class = "dashboard-kpi-estimator", estimator),
    if (!is.null(comparison)) shiny::tags$div(class = "dashboard-kpi-sub", comparison)
  )
}

dashboard_css_path <- function() {
  path <- system.file("dashboard", "www", "dashboard.css", package = "spatialtidymodels")
  if (!nzchar(path) || !file.exists(path)) return(NULL)
  path
}

dashboard_include_css <- function() {
  path <- dashboard_css_path()
  if (is.null(path)) return(NULL)
  shiny::includeCSS(path)
}
