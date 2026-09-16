# Tests for the multi-page dashboard shell (R/19-dashboard-app.R) and the
# Overview module's reactive wiring (R/21-dashboard-overview.R). Kept
# self-contained (not sourced from test-dashboard-data.R) since testthat
# loads files alphabetically and "app" sorts before "data".

app_test_results <- function() {
  grid <- expand.grid(
    estimator = c("ols", "sar_lag"),
    cv_scheme = c("near_prediction", "holdout_10pct"),
    dataset = c("ds_a", "ds_b"),
    stringsAsFactors = FALSE
  )
  is_sar <- grid$estimator == "sar_lag"
  is_b <- grid$dataset == "ds_b"
  is_holdout <- grid$cv_scheme == "holdout_10pct"
  data.frame(
    dataset = grid$dataset,
    cv_scheme = grid$cv_scheme,
    estimator = grid$estimator,
    rmse = ifelse(is_sar, 1.0, 2.0) + ifelse(is_b, 1.0, 0) + ifelse(is_holdout, 0.3, 0),
    mae = ifelse(is_sar, 0.8, 1.5) + ifelse(is_b, 0.5, 0) + ifelse(is_holdout, 0.2, 0),
    moran_abs = ifelse(is_sar, 0.02, 0.10) + ifelse(is_b, 0.10, 0),
    duration_sec = ifelse(is_sar, 5.0, 0.5) + ifelse(is_b, 0.1, 0),
    fit_error = NA_character_,
    stringsAsFactors = FALSE
  )
}

test_that("dashboard_verdict_color() maps every compare_estimator_variant() verdict to a distinct-enough color, never errors on an unknown one", {
  known_verdicts <- c("SUPERIOR", "INFERIOR", "EQUIVALENT", "TRADEOFF", "UNSTABLE", "INCONCLUSIVE", "INSUFFICIENT_EVIDENCE", "SPECIALIZED")
  colors <- vapply(known_verdicts, dashboard_verdict_color, character(1))
  expect_true(all(grepl("^#[0-9a-fA-F]{6}$", colors)))
  # INFERIOR and UNSTABLE are both "this candidate is unsafe" outcomes and
  # share a color; SUPERIOR/SPECIALIZED are visually distinct favorable
  # outcomes (SPECIALIZED being conditional, not unconditionally better) so
  # they intentionally do NOT share a color.
  expect_equal(unname(dashboard_verdict_color("INFERIOR")), unname(dashboard_verdict_color("UNSTABLE")))
  expect_false(identical(unname(dashboard_verdict_color("SUPERIOR")), unname(dashboard_verdict_color("INFERIOR"))))
  # An unrecognized verdict string (e.g. a future addition to R/16 not yet
  # reflected here) falls back to a neutral color rather than erroring.
  expect_match(dashboard_verdict_color("SOME_FUTURE_VERDICT"), "^#[0-9a-fA-F]{6}$")
})

test_that("launch_benchmark_dashboard() builds a 5-page app (all page bodies present) without launching", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("bslib")

  app <- launch_benchmark_dashboard(app_test_results(), baseline_estimator = "ols", launch = FALSE)
  expect_s3_class(app, "shiny.appobj")

  # shiny.appobj has no direct $ui field to inspect -- render it through its
  # own httpHandler (as a real request would) to get the actual page HTML.
  # Page/nav LABELS live in the sidebar, which is a server-rendered
  # shiny::renderUI() (see R/19) and so isn't present in this static GET
  # snapshot -- check each page's own static subtitle text instead, which
  # confirms every module's UI is actually wired into the tabsetPanel.
  resp <- app$httpHandler(list(REQUEST_METHOD = "GET", PATH_INFO = "/", rook.input = NULL, HTTP_ACCEPT = "text/html"))
  ui_html <- resp$content
  page_subtitles <- c(
    Overview = "What happened in this benchmark",
    `Reference vs Variant` = "Does a specific candidate estimator beat a specific reference",
    Datasets = "What datasets make up this benchmark suite",
    `CV Schemes` = "How does an estimator's performance change across CV schemes",
    Methodology = "What would someone need to know to reproduce or trust these numbers"
  )
  for (page_title in names(page_subtitles)) {
    expect_match(ui_html, page_subtitles[[page_title]], fixed = TRUE, info = page_title)
  }
})

test_that("launch_benchmark_dashboard() still validates required columns and baseline_estimator", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("bslib")

  results <- app_test_results()
  expect_error(
    launch_benchmark_dashboard(results, baseline_estimator = "does_not_exist", launch = FALSE),
    "baseline_estimator"
  )
  incomplete <- results[, setdiff(names(results), "moran_abs")]
  expect_error(
    launch_benchmark_dashboard(incomplete, baseline_estimator = "ols", launch = FALSE),
    "Colonnes manquantes"
  )
})

test_that("mod_overview_server() reacts to the cv_scheme filter without mixing schemes", {
  skip_if_not_installed("shiny")

  results <- app_test_results()
  families <- data.frame(estimator = c("ols", "sar_lag"), family = c("baseline", "SAR"), dashboard_group = c("Baselines", "Spatial Econometrics"), stringsAsFactors = FALSE)

  shiny::testServer(
    mod_overview_server,
    args = list(
      id = "overview_test", results = results, families = families,
      baseline_default = "ols", cv_scheme_choices = c("near_prediction", "holdout_10pct"),
      metric_choices = c("rmse", "mae", "moran_abs", "duration_sec"),
      selected_group = shiny::reactiveVal("All")
    ),
    {
      session$setInputs(cv_scheme_filter = "near_prediction", baseline = "ols", metric = "rmse")
      near_rows <- filtered_results()
      expect_true(all(near_rows$cv_scheme == "near_prediction"))
      expect_equal(nrow(near_rows), 4L) # 2 datasets x 2 estimators, one scheme only

      session$setInputs(cv_scheme_filter = "holdout_10pct")
      holdout_rows <- filtered_results()
      expect_true(all(holdout_rows$cv_scheme == "holdout_10pct"))
      expect_false(identical(sort(near_rows$rmse), sort(holdout_rows$rmse)))
    }
  )
})

test_that("mod_overview_server() reads its group filter from the shared selected_group reactive, narrowing to the group plus the baseline", {
  skip_if_not_installed("shiny")

  results <- app_test_results()
  families <- data.frame(estimator = c("ols", "sar_lag"), family = c("baseline", "SAR"), dashboard_group = c("Baselines", "Spatial Econometrics"), stringsAsFactors = FALSE)
  selected_group_val <- shiny::reactiveVal("All")

  shiny::testServer(
    mod_overview_server,
    args = list(
      id = "overview_test2", results = results, families = families,
      baseline_default = "ols", cv_scheme_choices = c("near_prediction", "holdout_10pct"),
      metric_choices = c("rmse", "mae", "moran_abs", "duration_sec"),
      selected_group = selected_group_val
    ),
    {
      session$setInputs(cv_scheme_filter = "near_prediction", baseline = "ols", metric = "rmse")
      selected_group_val("Spatial Econometrics")
      r <- filtered_results()
      expect_setequal(r$estimator, c("ols", "sar_lag")) # baseline always kept alongside the selected group

      selected_group_val("All")
      r_all <- filtered_results()
      expect_setequal(r_all$estimator, c("ols", "sar_lag"))
    }
  )
})

test_that("mod_overview_server()'s failure_table output has exactly 5 well-named columns, not a mismatched rename artifact", {
  # Regression test: dashboard_failure_summary() returns 6 columns
  # (estimator, n_cases, n_failed, failure_rate, datasets_affected,
  # worst_case_failure_rate); a display data.frame built by renaming that
  # in place with only 5 new names silently produced a garbled extra "NA"
  # column and an empty-looking DT table. Building `display` via explicit
  # column selection (see R/21) avoids this; this test would have caught it.
  skip_if_not_installed("shiny")
  skip_if_not_installed("DT")

  results <- app_test_results()
  families <- data.frame(estimator = c("ols", "sar_lag"), family = c("baseline", "SAR"), dashboard_group = c("Baselines", "Spatial Econometrics"), stringsAsFactors = FALSE)

  shiny::testServer(
    mod_overview_server,
    args = list(
      id = "overview_test3", results = results, families = families,
      baseline_default = "ols", cv_scheme_choices = c("near_prediction", "holdout_10pct"),
      metric_choices = c("rmse", "mae", "moran_abs", "duration_sec"),
      selected_group = shiny::reactiveVal("All")
    ),
    {
      session$setInputs(cv_scheme_filter = "near_prediction", baseline = "ols", metric = "rmse")
      widget <- output$failure_table
      expect_false(is.null(widget))
      payload <- jsonlite::fromJSON(widget, simplifyVector = FALSE)
      # DT's htmlwidget JSON (client-side: server = FALSE in R/21) keeps
      # column names as <th> tags inside x$container's HTML, and the row
      # data as one array per COLUMN (column-major) in x$data -- both must
      # reflect exactly the 5 intended columns, and every estimator must
      # have a value (not the "No matching records found" empty state).
      header_cells <- regmatches(payload$x$container, gregexpr("(?<=<th>)[^<]+(?=<)", payload$x$container, perl = TRUE))[[1]]
      expect_equal(
        header_cells,
        c("Estimator", "Failed folds (total)", "Failed folds (%)", "Datasets affected (n)", "Worst failure rate (%)")
      )
      expect_equal(length(payload$x$data), 5L) # 5 columns
      expect_equal(length(payload$x$data[[1]]), 2L) # 2 estimators -> 2 rows
      expect_setequal(unlist(payload$x$data[[1]]), c("ols", "sar_lag"))
    }
  )
})

# Reference vs Variant page (R/22-dashboard-comparison.R) -----------------

comparison_test_results <- function(n = 20) {
  set.seed(1)
  ref_rmse <- 10 + stats::runif(n, -1, 1)
  cand_rmse <- ref_rmse * 0.85 # candidate ~15% better everywhere -> SUPERIOR
  rbind(
    data.frame(
      dataset = paste0("ds_", seq_len(n)), cv_scheme = "near_prediction", estimator = "sar_lag",
      rmse = ref_rmse, mae = ref_rmse * 0.8, moran_abs = 0.05, duration_sec = 1, stringsAsFactors = FALSE
    ),
    data.frame(
      dataset = paste0("ds_", seq_len(n)), cv_scheme = "near_prediction", estimator = "spboost_bspa_sar_ml",
      rmse = cand_rmse, mae = cand_rmse * 0.8, moran_abs = 0.04, duration_sec = 5, stringsAsFactors = FALSE
    )
  )
}

test_that("mod_comparison_server()'s comparison reactive matches calling compare_estimator_variant() directly -- never recomputes the verdict", {
  skip_if_not_installed("shiny")

  results <- comparison_test_results()
  taxonomy <- data.frame(
    estimator = c("sar_lag", "spboost_bspa_sar_ml"),
    reference_estimator = c(NA_character_, "sar_lag"),
    stringsAsFactors = FALSE
  )

  shiny::testServer(
    mod_comparison_server,
    args = list(id = "cmp_test", results = results, dataset_metadata = NULL, taxonomy = taxonomy),
    {
      session$setInputs(reference = "sar_lag", candidate = "spboost_bspa_sar_ml", cv_scheme = "near_prediction", primary_metric = "rmse")
      module_result <- cmp()
      direct_result <- compare_estimator_variant(
        results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml",
        cv_scheme = "near_prediction", primary_metric = "rmse", groups = NULL
      )
      expect_equal(module_result$verdict, direct_result$verdict)
      expect_equal(module_result$summary, direct_result$summary)
      expect_equal(module_result$verdict, "SUPERIOR") # sanity: this fixture is designed to be an unambiguous win
    }
  )
})

test_that("mod_comparison_server() reports INSUFFICIENT_EVIDENCE (not an error) when too few cases are in scope, exactly like compare_estimator_variant() would", {
  skip_if_not_installed("shiny")

  results <- comparison_test_results(n = 3) # below comparison_rules()'s default min_cases_for_verdict = 10

  shiny::testServer(
    mod_comparison_server,
    args = list(id = "cmp_small", results = results, dataset_metadata = NULL, taxonomy = NULL),
    {
      session$setInputs(reference = "sar_lag", candidate = "spboost_bspa_sar_ml", cv_scheme = "near_prediction", primary_metric = "rmse")
      module_result <- cmp()
      expect_false(inherits(module_result, "error"))
      expect_equal(module_result$verdict, "INSUFFICIENT_EVIDENCE")
    }
  )
})

test_that("dashboard_default_candidate() defaults to the reference's declared variant when no valid candidate is set yet", {
  # Pure function -- no Shiny session needed. (shiny::testServer() can't
  # observe the effect of updateSelectInput() on input$x, since there's no
  # real client to echo the change back -- this is why the decision logic
  # is factored out as a pure function instead of asserted through a
  # simulated reactive round-trip.)
  all_estimators <- c("sar_lag", "sdm_mixed", "sem_error", "spboost_bspa_sar_ml")
  taxonomy <- data.frame(
    estimator = c("sar_lag", "spboost_bspa_sar_ml", "sem_error", "sdm_mixed"),
    reference_estimator = c(NA_character_, "sar_lag", NA_character_, NA_character_),
    stringsAsFactors = FALSE
  )

  result <- dashboard_default_candidate("sar_lag", current_candidate = NULL, all_estimators, taxonomy)
  expect_equal(result$selected, "spboost_bspa_sar_ml")
  expect_named(result$choices, c("Declared variants of sar_lag", "Other estimators"))
  expect_equal(result$choices[["Declared variants of sar_lag"]], "spboost_bspa_sar_ml")

  # No declared variant for sem_error -> falls back to the first other
  # estimator, and choices stay a flat (non-grouped) vector.
  no_variant <- dashboard_default_candidate("sem_error", current_candidate = NULL, all_estimators, taxonomy)
  expect_false(is.list(no_variant$choices))
  expect_equal(no_variant$selected, setdiff(all_estimators, "sem_error")[[1]])
})

test_that("dashboard_default_candidate() does not overwrite a valid, already-made candidate choice", {
  all_estimators <- c("sar_lag", "sdm_mixed", "sem_error", "spboost_bspa_sar_ml")
  taxonomy <- data.frame(
    estimator = c("sar_lag", "spboost_bspa_sar_ml", "sem_error", "sdm_mixed"),
    reference_estimator = c(NA_character_, "sar_lag", NA_character_, NA_character_),
    stringsAsFactors = FALSE
  )

  # sar_lag HAS a declared variant, but the user already picked something
  # else valid (sdm_mixed) -- that manual choice must survive.
  result <- dashboard_default_candidate("sar_lag", current_candidate = "sdm_mixed", all_estimators, taxonomy)
  expect_equal(result$selected, "sdm_mixed")

  # A "current" candidate equal to the new reference itself is not valid and
  # must not be kept.
  invalid_current <- dashboard_default_candidate("sar_lag", current_candidate = "sar_lag", all_estimators, taxonomy)
  expect_equal(invalid_current$selected, "spboost_bspa_sar_ml")

  # A "current" candidate that no longer exists in this suite is not valid either.
  stale_current <- dashboard_default_candidate("sar_lag", current_candidate = "some_removed_estimator", all_estimators, taxonomy)
  expect_equal(stale_current$selected, "spboost_bspa_sar_ml")
})

test_that("dashboard_default_candidate() works with taxonomy = NULL (no metadata registry available)", {
  all_estimators <- c("sar_lag", "spboost_bspa_sar_ml")
  result <- dashboard_default_candidate("sar_lag", current_candidate = NULL, all_estimators, taxonomy = NULL)
  expect_equal(result$selected, "spboost_bspa_sar_ml")
  expect_false(is.list(result$choices))
})

test_that("dashboard_verdict_badge_html() and dashboard_comparison_kpi_row() render without a live Shiny session", {
  # Pure display helpers -- testable directly since they only build
  # htmltools tags from an already-computed estimator_comparison object.
  results <- comparison_test_results()
  cmp <- compare_estimator_variant(results, reference = "sar_lag", candidate = "spboost_bspa_sar_ml", cv_scheme = "near_prediction")

  badge <- dashboard_verdict_badge_html(cmp$verdict, cmp$verdict_reasons)
  expect_true(inherits(badge, "shiny.tag.list") || inherits(badge, "shiny.tag"))
  expect_match(as.character(badge), "SUPERIOR", fixed = TRUE)

  kpi_row <- dashboard_comparison_kpi_row(cmp)
  kpi_html <- as.character(kpi_row)
  expect_match(kpi_html, "Win rate", fixed = TRUE)
  expect_match(kpi_html, "100%", fixed = TRUE) # this fixture's candidate wins every case
})

# Datasets page (R/23-dashboard-datasets.R) --------------------------------

datasets_test_metadata <- function() {
  data.frame(
    dataset = c("ds_a", "ds_b", "ds_c"),
    source_dataset_id = c("ds_a", "ds_a", "ds_c"), # ds_a/ds_b share a source
    benchmark_task_id = c("ds_a", "ds_b", "ds_c"),
    parent_dataset = c(NA, "ds_a", NA),
    n = c(120L, 130L, NA_integer_),
    p = c(4L, 4L, 6L),
    formula_role = NA_character_, # entirely NA -> should be hidden as a column
    benchmark_ready = c(TRUE, TRUE, TRUE),
    bundled = c(TRUE, FALSE, FALSE),
    storage = c("bundled", "repo_only", "repo_only"),
    benchmark_suite = I(list(character(), "suite_v1", character())),
    download_url = NA_character_,
    license_name = NA_character_,
    license_verified = NA,
    redistribution_allowed = NA,
    checksum_sha256 = NA_character_,
    size_bytes = NA_real_,
    stringsAsFactors = FALSE
  )
}

test_that("dashboard_datasets_visible_columns() hides a column that is NA for every dataset in this suite", {
  meta <- datasets_test_metadata()
  visible <- dashboard_datasets_visible_columns(meta)
  expect_true("dataset" %in% visible) # always shown
  expect_true("n" %in% visible) # has at least one non-NA value
  expect_false("formula_role" %in% visible) # all-NA in this fixture
  expect_true("benchmark_suite_display" %in% visible) # at least one non-empty benchmark_suite
})

test_that("dashboard_datasets_table() formats logicals as Yes/No and collapses benchmark_suite to a string", {
  meta <- datasets_test_metadata()
  display <- dashboard_datasets_table(meta)
  bundled_col <- display[["Bundled"]]
  expect_setequal(bundled_col, c("Yes", "No"))
  suite_col <- display[["Benchmark suite(s)"]]
  expect_equal(suite_col[meta$dataset == "ds_b"], "suite_v1")
  expect_true(is.na(suite_col[meta$dataset == "ds_a"])) # empty list -> NA, not "character(0)"
})

test_that("mod_datasets_server() shows a placeholder when no dataset_metadata is available, a real table otherwise", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("DT")

  shiny::testServer(mod_datasets_server, args = list(id = "ds_none", dataset_metadata = NULL), {
    html <- as.character(output$body$html)
    expect_match(html, "No dataset metadata available", fixed = TRUE)
  })

  meta <- datasets_test_metadata()
  shiny::testServer(mod_datasets_server, args = list(id = "ds_some", dataset_metadata = meta), {
    html <- as.character(output$body$html)
    expect_match(html, "3 dataset(s) in this suite", fixed = TRUE)
  })
})

# CV Schemes page (R/24-dashboard-cv.R) ------------------------------------

test_that("mod_cv_server() shows a placeholder when only one CV scheme is present, a real comparison otherwise", {
  skip_if_not_installed("shiny")
  skip_if_not_installed("DT")

  single_scheme <- app_test_results()[app_test_results()$cv_scheme == "near_prediction", , drop = FALSE]
  families <- data.frame(estimator = c("ols", "sar_lag"), family = c("baseline", "SAR"), dashboard_group = c("Baselines", "Spatial Econometrics"), stringsAsFactors = FALSE)

  shiny::testServer(
    mod_cv_server,
    args = list(id = "cv_one", results = single_scheme, families = families, baseline_default = "ols"),
    {
      html <- as.character(output$body$html)
      expect_match(html, "Only one CV scheme", fixed = TRUE)
    }
  )

  two_schemes <- app_test_results()
  shiny::testServer(
    mod_cv_server,
    args = list(id = "cv_two", results = two_schemes, families = families, baseline_default = "ols"),
    {
      session$setInputs(baseline = "ols", metric = "rmse")
      html <- as.character(output$body$html)
      expect_match(html, "Relative performance by estimator x CV scheme", fixed = TRUE)
      matrix <- scheme_matrix()
      expect_setequal(unique(matrix$cv_scheme), c("near_prediction", "holdout_10pct"))
    }
  )
})

# Methodology page (R/25-dashboard-methodology.R) --------------------------

test_that("mod_methodology_server() reads rules live from comparison_rules(), never inventing values", {
  skip_if_not_installed("shiny")

  results <- app_test_results()
  fresh_rules <- comparison_rules() # what the module should be reading from, right now

  shiny::testServer(
    mod_methodology_server,
    args = list(id = "meth_df", suite = results, results = results), # plain data.frame suite -- no protocol
    {
      html <- as.character(output$body$html)
      expect_match(html, "not available", fixed = TRUE) # seed/protocol fields, honestly absent
      expect_match(html, sprintf("%.1f%%", 100 * fresh_rules$rope), fixed = TRUE)
      expect_match(html, as.character(fresh_rules$min_cases_for_verdict), fixed = TRUE)
      expect_match(html, fresh_rules$analysis_unit, fixed = TRUE)
    }
  )
})

test_that("mod_methodology_server() reports N benchmark tasks / N independent sources and the protocol seed from a real suite", {
  skip_if_not_installed("shiny")

  suite <- structure(
    list(
      results = app_test_results(),
      datasets = c("ds_a", "ds_b"),
      dataset_metadata = data.frame(
        dataset = c("ds_a", "ds_b"), source_dataset_id = c("shared_source", "shared_source"),
        benchmark_task_id = c("ds_a", "ds_b"), stringsAsFactors = FALSE
      ),
      protocol = list(formula_role = "default", seed = 777L, tune = FALSE, eval_folds = 5L, holdout_prop = 0.9, near_n_reps = 3L, block_folds = 5L)
    ),
    class = "spatial_benchmark_suite"
  )

  shiny::testServer(
    mod_methodology_server,
    args = list(id = "meth_suite", suite = suite, results = suite$results),
    {
      html <- as.character(output$body$html)
      expect_match(html, "777", fixed = TRUE) # seed

      # ds_a/ds_b are 2 distinct benchmark tasks sharing 1 source -- confirm
      # the underlying computation directly, then confirm those exact values
      # (not just "some digit") appear next to the right row label.
      counts <- dashboard_task_source_counts(suite)
      expect_equal(counts$n_benchmark_tasks, 2L)
      expect_equal(counts$n_independent_sources, 1L)
      expect_match(html, sprintf("<th>Benchmark tasks</th>\\s*<td>%d</td>", counts$n_benchmark_tasks))
      expect_match(html, sprintf("<th>Independent sources</th>\\s*<td>%d</td>", counts$n_independent_sources))
    }
  )
})
