# Datasets page module.
#
# Answers one question: "what is actually in this benchmark suite's dataset
# bank, and what do we know about each entry?" Entirely driven by
# suite$dataset_metadata (R/15-benchmark-suite.R / build_suite_dataset_metadata())
# -- no fictional domain/geometry_type columns invented here; a column is
# shown only when at least one dataset in this suite actually has a value
# for it (dashboard_datasets_visible_columns() below). Not the download/cache
# UI yet (Section 18 of the working notes) -- only ready to display the
# storage/download_url/license fields once they exist.

# Column -> display label, in the order the user asked for. Kept as a single
# lookup table so the main table and the detail view agree on wording.
dashboard_datasets_column_labels <- function() {
  c(
    dataset = "Dataset",
    source_dataset_id = "Source dataset",
    benchmark_task_id = "Benchmark task",
    parent_dataset = "Parent dataset",
    n = "n",
    p = "p",
    formula_role = "Formula role",
    benchmark_ready = "Benchmark ready",
    bundled = "Bundled",
    storage = "Storage",
    benchmark_suite_display = "Benchmark suite(s)"
  )
}

#' Which dataset_metadata columns actually carry information in this suite
#'
#' A column is included only if at least one row has a non-`NA` (and, for
#' `benchmark_suite`, non-empty) value -- never shows an all-empty column
#' just because the field exists structurally. `dataset` is always shown.
#' @noRd
dashboard_datasets_visible_columns <- function(dataset_metadata) {
  labels <- dashboard_datasets_column_labels()
  candidates <- setdiff(names(labels), "dataset")
  keep <- vapply(candidates, function(col) {
    if (identical(col, "benchmark_suite_display")) {
      if (!"benchmark_suite" %in% names(dataset_metadata)) return(FALSE)
      any(vapply(dataset_metadata$benchmark_suite, function(x) length(x) > 0L, logical(1)))
    } else if (col %in% names(dataset_metadata)) {
      !all(is.na(dataset_metadata[[col]]))
    } else {
      FALSE
    }
  }, logical(1))
  c("dataset", candidates[keep])
}

#' Build the Datasets page's main table (display-ready data.frame)
#'
#' @param dataset_metadata `suite$dataset_metadata`.
#' @return A `data.frame` with only the visible columns (see
#'   [dashboard_datasets_visible_columns()]), display-labeled and formatted
#'   (logicals as Yes/No, benchmark_suite collapsed to a comma-joined string).
#' @noRd
dashboard_datasets_table <- function(dataset_metadata) {
  visible <- dashboard_datasets_visible_columns(dataset_metadata)
  out <- dataset_metadata
  if ("benchmark_suite" %in% names(out)) {
    out$benchmark_suite_display <- vapply(out$benchmark_suite, function(x) {
      if (length(x) == 0L) NA_character_ else paste(x, collapse = ", ")
    }, character(1))
  }
  for (col in intersect(visible, names(out))) {
    if (is.logical(out[[col]])) out[[col]] <- ifelse(is.na(out[[col]]), NA, ifelse(out[[col]], "Yes", "No"))
  }
  out <- out[, visible, drop = FALSE]
  names(out) <- unname(dashboard_datasets_column_labels()[visible])
  out
}

dashboard_dataset_detail_html <- function(row) {
  labels <- dashboard_datasets_column_labels()
  fmt <- function(x) {
    if (is.null(x) || length(x) == 0L || (length(x) == 1L && is.na(x))) return("–")
    if (is.logical(x)) return(if (isTRUE(x)) "Yes" else if (isFALSE(x)) "No" else "–")
    if (is.list(x)) x <- x[[1]]
    if (length(x) > 1L) return(paste(x, collapse = ", "))
    as.character(x)
  }
  main_rows <- lapply(names(labels), function(f) {
    value <- if (identical(f, "benchmark_suite_display")) {
      if ("benchmark_suite" %in% names(row)) row$benchmark_suite[[1]] else NA
    } else if (f %in% names(row)) {
      row[[f]]
    } else {
      NA
    }
    shiny::tags$tr(shiny::tags$th(labels[[f]]), shiny::tags$td(fmt(value)))
  })

  # Distribution-architecture fields: shown explicitly even when NA/absent,
  # as "not yet available" rather than omitted -- the interface is ready to
  # display them once the registry populates them (Section 18 of the working
  # notes: the distribution option itself is still undecided).
  future_fields <- c(
    storage = "Storage", download_url = "Download URL", license_name = "License",
    license_verified = "License verified", redistribution_allowed = "Redistribution allowed",
    checksum_sha256 = "Checksum (SHA-256)", size_bytes = "Size (bytes)"
  )
  future_rows <- lapply(names(future_fields), function(f) {
    value <- if (f %in% names(row)) row[[f]] else NA
    shiny::tags$tr(shiny::tags$th(future_fields[[f]]), shiny::tags$td(fmt(value)))
  })

  shiny::tagList(
    shiny::tags$h5(row$dataset[[1]]),
    shiny::tags$table(class = "dashboard-methodology-table", shiny::tags$tbody(main_rows)),
    shiny::tags$p(class = "dashboard-kpi-sub", style = "margin-top:14px;", "Distribution (not yet implemented -- see working notes Section 18):"),
    shiny::tags$table(class = "dashboard-methodology-table", shiny::tags$tbody(future_rows))
  )
}

mod_datasets_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$div(
      class = "dashboard-subtitle",
      "What datasets make up this benchmark suite, and what do we know about each? Click a row for the full detail."
    ),
    shiny::uiOutput(ns("body"))
  )
}

#' @param id Module namespace id.
#' @param dataset_metadata `suite$dataset_metadata` (or `NULL` when `suite`
#'   was passed to [launch_benchmark_dashboard()] as a plain results
#'   `data.frame` rather than a `spatial_benchmark_suite`).
#' @noRd
mod_datasets_server <- function(id, dataset_metadata) {
  shiny::moduleServer(id, function(input, output, session) {
    output$body <- shiny::renderUI({
      if (is.null(dataset_metadata) || nrow(dataset_metadata) == 0L) {
        return(shiny::tags$div(
          class = "dashboard-placeholder",
          shiny::tags$p("No dataset metadata available -- launch_benchmark_dashboard() was given a plain results data.frame rather than a spatial_benchmark_suite.")
        ))
      }
      shiny::tagList(
        bslib::card(
          bslib::card_header(sprintf("%d dataset(s) in this suite", nrow(dataset_metadata))),
          DT::DTOutput(session$ns("table"))
        ),
        shiny::uiOutput(session$ns("detail"))
      )
    })

    output$table <- DT::renderDT({
      shiny::req(dataset_metadata)
      display <- dashboard_datasets_table(dataset_metadata)
      DT::datatable(
        display,
        rownames = FALSE,
        selection = "single",
        options = list(pageLength = 10, scrollX = TRUE, autoWidth = TRUE),
        class = "stripe hover"
      )
    }, server = FALSE)

    output$detail <- shiny::renderUI({
      shiny::req(dataset_metadata)
      selected <- input$table_rows_selected
      if (is.null(selected) || length(selected) == 0L) {
        return(shiny::tags$p(class = "dashboard-kpi-sub", "Select a row above to see the full detail for a dataset."))
      }
      row <- dataset_metadata[selected, , drop = FALSE]
      bslib::card(
        bslib::card_header("Dataset detail"),
        dashboard_dataset_detail_html(row)
      )
    })

    invisible(NULL)
  })
}
