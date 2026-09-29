#!/usr/bin/env Rscript
# Audit all final sf artifacts and rank them by benchmark evidence completeness.
#
# This script is intentionally diagnostic. It does not promote datasets and does
# not edit fiches. It answers: among final .rds sf artifacts, which datasets
# already have a plausible Y, at least two X, a formula, and estimator evidence?

suppressPackageStartupMessages({
  library(jsonlite)
  library(sf)
})

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, ".git")) && dir.exists(file.path(current, "wiki"))) {
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Repo root not found.", call. = FALSE)
}

clean <- function(x) {
  if (is.null(x) || length(x) == 0) return("")
  x <- as.character(x[[1]])
  x <- trimws(gsub("`", "", x, fixed = TRUE))
  if (is.na(x)) "" else x
}

clean_vec <- function(x) {
  if (is.null(x) || length(x) == 0) return(character())
  x <- as.character(unlist(x, use.names = FALSE))
  x <- trimws(gsub("`", "", x, fixed = TRUE))
  x[!is.na(x) & nzchar(x)]
}

is_pending <- function(x) {
  x <- tolower(clean(x))
  !nzchar(x) || x %in% c("pending", "none", "null", "na", "n/a", "unknown", "unavailable", "not_found")
}

safe_read_json <- function(path) {
  if (!file.exists(path)) return(NULL)
  fromJSON(path, simplifyVector = FALSE)
}

formula_parts <- function(formula) {
  formula <- clean(formula)
  if (is_pending(formula) || !grepl("~", formula, fixed = TRUE)) {
    return(list(y = "", x = character()))
  }
  split <- strsplit(formula, "~", fixed = TRUE)[[1]]
  lhs <- trimws(split[1])
  rhs <- trimws(split[2])
  rhs <- gsub("\\[[^]]+\\]", "", rhs)
  rhs <- sub("\\.\\.\\..*$", "", rhs)
  terms <- trimws(unlist(strsplit(rhs, "\\+")))
  terms <- terms[nzchar(terms) & terms != "1"]
  list(y = lhs, x = unique(terms))
}

parse_bullet <- function(text, label) {
  pattern <- sprintf("(?im)^\\s*-\\s+%s[^:\\n]*:\\s*(.+?)\\s*$", gsub("([\\W])", "\\\\\\1", label))
  hit <- regexpr(pattern, text, perl = TRUE)
  if (hit < 0) return("")
  line <- regmatches(text, hit)
  sub("^\\s*-\\s+[^:]+:\\s*", "", line)
}

parse_backticks_or_csv <- function(value) {
  value <- clean(value)
  if (is_pending(value)) return(character())
  ticks <- gregexpr("`([^`]+)`", value, perl = TRUE)
  tick_matches <- regmatches(value, ticks)[[1]]
  if (length(tick_matches) && tick_matches[1] != "-1") {
    return(gsub("`", "", tick_matches, fixed = TRUE))
  }
  if (grepl(",", value, fixed = TRUE)) {
    return(trimws(unlist(strsplit(value, ","))))
  }
  if (grepl("\\+", value)) {
    return(trimws(unlist(strsplit(value, "\\+"))))
  }
  value
}

read_fiche_meta <- function(path) {
  if (!file.exists(path)) {
    return(list(
      formula_used = "", response = "", predictors = character(),
      estimator_evidence = FALSE, package_include = "", benchmark_status = "",
      source_ref = "", source_url = ""
    ))
  }
  text <- paste(readLines(path, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  formula_used <- parse_bullet(text, "formula_used")
  parts <- formula_parts(formula_used)
  y <- parts$y
  if (!nzchar(y)) y <- parse_bullet(text, "y_term_used")
  x <- parts$x
  if (!length(x)) x <- parse_backticks_or_csv(parse_bullet(text, "x_terms_used"))
  if (!length(x)) x <- parse_backticks_or_csv(parse_bullet(text, "Candidate X variables"))
  readiness <- regmatches(text, regexpr("(?ms)```yaml\\s*\\n\\s*benchmark_readiness:\\s*(.*?)\\n```", text, perl = TRUE))
  package_include <- ""
  benchmark_status <- ""
  if (length(readiness) && readiness != "") {
    package_include <- sub(".*\\n\\s*package_include:\\s*\"?([^\"\\n]+)\"?.*", "\\1", readiness)
    benchmark_status <- sub(".*\\n\\s*benchmark_status:\\s*\"?([^\"\\n]+)\"?.*", "\\1", readiness)
  }
  list(
    formula_used = clean(formula_used),
    response = clean(y),
    predictors = x[nzchar(x)],
    estimator_evidence = grepl("## Estimator eligibility", text, fixed = TRUE),
    package_include = clean(package_include),
    benchmark_status = clean(benchmark_status),
    source_ref = clean(parse_bullet(text, "Reference publication")),
    source_url = clean(parse_bullet(text, "Source URL"))
  )
}

infer_identifier_cols <- function(names_vec) {
  names_vec[grepl("(^id$|_id$|id_|code|name|label|objectid|fid|gid|iso|uuid|key)", names_vec, ignore.case = TRUE)]
}

infer_coord_cols <- function(names_vec) {
  names_vec[grepl("^(x|y|lon|long|longitude|lat|latitude|east|north|easting|northing)$", names_vec, ignore.case = TRUE)]
}

infer_numeric_covariates <- function(df, y, predictors, coords, ids) {
  vars <- setdiff(names(df), c(y, predictors, coords, ids, attr(df, "sf_column")))
  vars <- vars[!vapply(df[vars], function(col) inherits(col, c("Date", "POSIXt")), logical(1))]
  numeric_like <- vars[vapply(df[vars], function(col) is.numeric(col) || is.integer(col), logical(1))]
  numeric_like[!grepl("(^id$|_id$|id_|code|fid|gid)", numeric_like, ignore.case = TRUE)]
}

classify_y <- function(col, name) {
  name_l <- tolower(name)
  if (is.null(col)) return("missing")
  if (inherits(col, c("Date", "POSIXt"))) return("timestamp")
  values <- col[!is.na(col)]
  n_unique <- length(unique(values))
  if (n_unique <= 1) return("constant")
  if (is.logical(col)) return("binary")
  if (is.factor(col) || is.character(col)) return("categorical")
  if (!is.numeric(col) && !is.integer(col)) return("categorical")
  if (n_unique == 2) return("binary")
  if (grepl("class|type|category|mark|presence|pa$|winner|croptype|profclass", name_l)) {
    return("categorical")
  }
  if (all(abs(values - round(values)) < sqrt(.Machine$double.eps), na.rm = TRUE)) {
    if (n_unique <= 10 && max(values, na.rm = TRUE) <= 10) return("ordinal_or_small_count")
    return("count")
  }
  if (min(values, na.rm = TRUE) >= 0 && max(values, na.rm = TRUE) <= 1) return("rate")
  "continuous"
}

is_regression_y_type <- function(y_type) {
  y_type %in% c("continuous", "count", "rate", "ordinal_or_small_count")
}

metadata_map <- function(records) {
  out <- list()
  if (is.null(records)) return(out)
  for (rec in records) {
    id <- clean(rec$dataset_id %||% rec$dataset)
    if (nzchar(id)) out[[id]] <- rec
    local <- clean(rec$local_artifact %||% rec$rds)
    if (nzchar(local)) out[[basename(tools::file_path_sans_ext(local))]] <- rec
  }
  out
}

`%||%` <- function(a, b) if (!is.null(a)) a else b

main <- function() {
  root <- find_repo_root()
  sf_dir <- file.path(root, "data", "final_datasets", "sf")
  out_csv <- file.path(root, "data", "manifests", "datasets", "sf_benchmark_candidate_audit.csv")
  out_md <- file.path(root, "data", "manifests", "datasets", "sf_benchmark_candidate_audit.md")
  dir.create(dirname(out_csv), recursive = TRUE, showWarnings = FALSE)

  package_meta <- safe_read_json(file.path(root, "packages", "spatialtidymodels", "inst", "metadata", "datasets.json"))
  meta_by_id <- metadata_map(package_meta$records %||% list())

  files <- sort(list.files(sf_dir, pattern = "\\.rds$", full.names = TRUE))
  rows <- vector("list", length(files))

  for (i in seq_along(files)) {
    path <- files[[i]]
    id <- tools::file_path_sans_ext(basename(path))
    fiche <- file.path(root, "wiki", "datasets", "fiches_datasets", paste0(id, ".md"))
    fiche_meta <- read_fiche_meta(fiche)
    rec <- meta_by_id[[id]]

    obj <- tryCatch(readRDS(path), error = function(e) e)
    read_ok <- !inherits(obj, "error")
    is_sf <- read_ok && inherits(obj, "sf")
    n <- if (read_ok && (is.data.frame(obj) || inherits(obj, "sf"))) nrow(obj) else NA_integer_
    df <- if (is_sf) sf::st_drop_geometry(obj) else if (read_ok && is.data.frame(obj)) obj else data.frame()
    vars <- names(df)
    geom_type <- if (is_sf) paste(unique(as.character(sf::st_geometry_type(obj, by_geometry = FALSE))), collapse = ",") else ""
    crs <- if (is_sf) {
      epsg <- sf::st_crs(obj)$epsg
      if (is.na(epsg)) "" else as.character(epsg)
    } else ""
    coords <- infer_coord_cols(vars)
    ids <- infer_identifier_cols(vars)

    formula <- clean(rec$formula_used %||% rec$formula %||% fiche_meta$formula_used)
    parts <- formula_parts(formula)
    y <- clean(rec$response %||% fiche_meta$response %||% parts$y)
    predictors <- rec$predictors %||% fiche_meta$predictors %||% parts$x
    predictors <- clean_vec(predictors)
    predictors <- predictors[nzchar(predictors) & predictors %in% vars]

    if (!nzchar(y) || !(y %in% vars)) {
      y <- ""
    }
    heuristic_x <- infer_numeric_covariates(df, y, predictors, coords, ids)
    x_count <- max(length(predictors), length(heuristic_x))
    y_type <- if (nzchar(y) && y %in% names(df)) classify_y(df[[y]], y) else "missing"
    has_y <- nzchar(y) && is_regression_y_type(y_type)
    has_formula <- !is_pending(formula) && grepl("~", formula, fixed = TRUE)
    source_ref <- clean(rec$source_ref %||% fiche_meta$source_ref)
    has_formula_source <- has_formula && !is_pending(source_ref)
    has_x_defensible <- x_count >= 2 || (x_count >= 1 && has_formula_source)
    estimator_count <- length(unlist(rec$eligible_estimators %||% rec$benchmark_estimators %||% list(), use.names = FALSE))
    has_estimator <- estimator_count > 0 || isTRUE(fiche_meta$estimator_evidence)
    spatial <- is_sf || length(coords) >= 2
    score <- sum(has_y, has_x_defensible, has_formula_source, has_estimator)
    package_ready <- isTRUE(rec$benchmark_ready)

    blockers <- c()
    if (!spatial) blockers <- c(blockers, "spatial_support_missing")
    if (!has_y) blockers <- c(blockers, "response_y_missing_or_not_regression_usable")
    if (!has_x_defensible) blockers <- c(blockers, "less_than_two_covariates")
    if (!has_formula) blockers <- c(blockers, "formula_missing")
    if (has_formula && !has_formula_source) blockers <- c(blockers, "formula_source_missing")
    if (!has_estimator) blockers <- c(blockers, "estimator_evidence_missing")

    rows[[i]] <- data.frame(
      dataset_id = id,
      rds = normalizePath(path, winslash = "/", mustWork = FALSE),
      read_ok = read_ok,
      is_sf = is_sf,
      n = n,
      k = length(vars),
      geom_type = geom_type,
      crs_epsg = crs,
      y = y,
      y_type = y_type,
      x_count = x_count,
      x_examples = paste(utils::head(if (length(predictors)) predictors else heuristic_x, 8), collapse = ", "),
      formula = formula,
      has_formula_source = has_formula_source,
      has_estimator_evidence = has_estimator,
      score_4 = score,
      candidate_level = if (spatial && score == 4) "4_of_4" else if (spatial && score >= 3) "3_of_4" else "below_gate",
      package_ready = package_ready,
      benchmark_status = clean(rec$benchmark_status %||% fiche_meta$benchmark_status),
      package_include = clean(rec$package_include %||% fiche_meta$package_include),
      blockers = paste(blockers, collapse = ", "),
      stringsAsFactors = FALSE
    )
  }

  audit <- do.call(rbind, rows)
  audit <- audit[order(audit$candidate_level, audit$score_4, audit$dataset_id, decreasing = TRUE), ]
  write.csv2(audit, out_csv, row.names = FALSE, fileEncoding = "UTF-8")

  non_ready <- audit[!audit$package_ready, ]
  candidates <- non_ready[non_ready$candidate_level %in% c("4_of_4", "3_of_4"), ]
  lines <- c(
    "# SF Benchmark Candidate Audit",
    "",
    sprintf("- RDS inspected: %d", nrow(audit)),
    sprintf("- Package-ready already: %d", sum(audit$package_ready, na.rm = TRUE)),
    sprintf("- Non-ready with 4/4 local evidence: %d", sum(candidates$candidate_level == "4_of_4")),
    sprintf("- Non-ready with 3/4 local evidence: %d", sum(candidates$candidate_level == "3_of_4")),
    "",
    "## Priority Candidates",
    "",
    "| Dataset | Level | N | Y | X count | Missing / blockers |",
    "|---|---|---:|---|---:|---|"
  )
  if (nrow(candidates)) {
    top <- utils::head(candidates, 120)
    for (j in seq_len(nrow(top))) {
      lines <- c(lines, sprintf(
        "| `%s` | %s | %s | `%s` | %s | %s |",
        top$dataset_id[j], top$candidate_level[j], top$n[j],
        ifelse(nzchar(top$y[j]), top$y[j], "pending"),
        top$x_count[j], top$blockers[j]
      ))
    }
  } else {
    lines <- c(lines, "| Aucun | - | - | - | - | - |")
  }
  writeLines(lines, out_md, useBytes = TRUE)

  cat("RDS inspected:", nrow(audit), "\n")
  cat("Package-ready already:", sum(audit$package_ready, na.rm = TRUE), "\n")
  cat("Non-ready 4/4:", sum(candidates$candidate_level == "4_of_4"), "\n")
  cat("Non-ready 3/4:", sum(candidates$candidate_level == "3_of_4"), "\n")
  cat("CSV:", out_csv, "\n")
  cat("MD:", out_md, "\n")
}

main()
