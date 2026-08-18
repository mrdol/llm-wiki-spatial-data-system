# Methodology / About page module.
#
# Answers one question: "what would someone need to know to reproduce or
# trust these numbers?" Every value shown is read live from the suite object
# and from a default comparison_rules() -- never hardcoded text -- so a rule
# that changes in R/16-estimator-comparison.R is reflected here automatically
# instead of requiring someone to remember to also edit this page.

mod_methodology_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$div(
      class = "dashboard-subtitle",
      "What would someone need to know to reproduce or trust these numbers?"
    ),
    shiny::uiOutput(ns("body"))
  )
}

#' @param id Module namespace id.
#' @param suite The original `suite` argument passed to
#'   [launch_benchmark_dashboard()] -- may be a `spatial_benchmark_suite`
#'   (exposes `$protocol`, `$dataset_metadata`) or a plain results
#'   `data.frame` (protocol/task-source fields then show as "not
#'   available").
#' @param results The suite's results `data.frame`.
#' @noRd
mod_methodology_server <- function(id, suite, results) {
  shiny::moduleServer(id, function(input, output, session) {
    na_note <- "not available (a plain results data.frame was passed to launch_benchmark_dashboard(), not a spatial_benchmark_suite)"

    output$body <- shiny::renderUI({
      protocol <- if (inherits(suite, "spatial_benchmark_suite")) suite$protocol else NULL
      counts <- tryCatch(dashboard_task_source_counts(suite), error = function(e) NULL)
      rules <- comparison_rules() # the package DEFAULT rules -- read live, not retyped here

      benchmark_pairs <- list(
        "Package version" = as.character(utils::packageVersion("spatialtidymodels")),
        "Benchmark tasks" = if (!is.null(counts)) as.character(counts$n_benchmark_tasks) else na_note,
        "Independent sources" = if (!is.null(counts)) as.character(counts$n_independent_sources) else na_note,
        "Estimators" = paste(sort(unique(results$estimator)), collapse = ", "),
        "CV schemes" = paste(sort(unique(results$cv_scheme)), collapse = ", "),
        "Formula role" = if (!is.null(protocol$formula_role)) protocol$formula_role else na_note,
        "Seed" = if (!is.null(protocol$seed)) as.character(protocol$seed) else na_note,
        "Tuning" = if (!is.null(protocol$tune)) (if (isTRUE(protocol$tune)) "enabled" else "disabled") else na_note,
        "Eval folds (k-fold-style schemes)" = if (!is.null(protocol$eval_folds)) as.character(protocol$eval_folds) else na_note,
        "Holdout proportion (train)" = if (!is.null(protocol$holdout_prop)) as.character(protocol$holdout_prop) else na_note,
        "Near-prediction repetitions" = if (!is.null(protocol$near_n_reps)) as.character(protocol$near_n_reps) else na_note,
        "Block-spatial folds" = if (!is.null(protocol$block_folds)) as.character(protocol$block_folds) else na_note
      )

      rules_pairs <- list(
        "Default primary metric" = "rmse (configurable per comparison on the Reference vs Variant page)",
        "ROPE (region of practical equivalence)" = sprintf("%.1f%% of the primary metric", 100 * rules$rope),
        "Win/tie/loss rule" = sprintf("|delta| <= %.1f%% -> TIE, else WIN/LOSS by sign", 100 * rules$rope),
        "Min. win rate for SUPERIOR/INFERIOR" = sprintf("%.0f%%", 100 * rules$min_win_rate),
        "Significance level (paired Wilcoxon)" = as.character(rules$alpha),
        "Min. cases required for a verdict" = as.character(rules$min_cases_for_verdict),
        "Max large-loss rate" = sprintf("%.1f%%", 100 * rules$max_large_loss_rate),
        "Large-loss threshold" = sprintf("%.1f%%", 100 * rules$large_loss_threshold),
        "Failure rule (-> UNSTABLE)" = sprintf("candidate failure-rate increase > %.1f pts", 100 * rules$max_failure_rate_increase),
        "Min. cases for a SPECIALIZED subgroup" = as.character(rules$min_cases_for_subgroup),
        "Analysis unit" = sprintf("%s (see working notes: source-level aggregation is prepared but not enabled)", rules$analysis_unit)
      )
      if (length(rules$secondary_guardrails) > 0) {
        rules_pairs[["Secondary guardrails"]] <- paste(
          sprintf("%s <= %.1f%%", names(rules$secondary_guardrails), 100 * rules$secondary_guardrails),
          collapse = ", "
        )
      } else {
        rules_pairs[["Secondary guardrails"]] <- "none configured by default"
      }

      shiny::tagList(
        bslib::card(
          bslib::card_header("Benchmark"),
          dashboard_kv_table_html(benchmark_pairs)
        ),
        bslib::card(
          bslib::card_header("Comparison rules (compare_estimator_variant() defaults)"),
          shiny::tags$p(class = "dashboard-kpi-sub", "These are project conventions, not universal statistical constants -- see comparison_rules() documentation. A comparison run with custom rules on the Reference vs Variant page may differ from what's shown here."),
          dashboard_kv_table_html(rules_pairs)
        )
      )
    })

    invisible(NULL)
  })
}
