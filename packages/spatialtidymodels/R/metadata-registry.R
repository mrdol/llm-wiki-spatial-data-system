# Lecture des registres JSON installes avec le package.
#
# Les fiches Markdown restent la source humaine; les fichiers inst/metadata/*.json
# sont le format machine genere par code/package_metadata/export_spatialtidymodels_metadata.py.

read_spatialtidymodels_metadata <- function(kind) {
  path <- system.file("metadata", paste0(kind, ".json"), package = "spatialtidymodels")
  if (!nzchar(path) || !file.exists(path)) return(NULL)
  if (!requireNamespace("jsonlite", quietly = TRUE)) return(NULL)

  payload <- tryCatch(
    jsonlite::fromJSON(path, simplifyDataFrame = TRUE),
    error = function(e) NULL
  )
  if (is.null(payload) || is.null(payload$records)) return(NULL)
  payload$records
}

as_character_list_column <- function(x) {
  # jsonlite garde les tableaux de longueur variable comme liste, mais peut
  # simplifier les tableaux de longueur constante. On force une forme stable.
  if (is.null(x)) return(I(list()))
  if (is.data.frame(x)) {
    return(I(lapply(seq_len(nrow(x)), function(i) {
      as.character(unlist(x[i, ], use.names = FALSE))
    })))
  }
  if (is.list(x) && !is.data.frame(x)) {
    return(I(lapply(x, function(value) as.character(value %||% character()))))
  }
  I(lapply(seq_along(x), function(i) as.character(x[[i]] %||% character())))
}

metadata_dataset_registry <- function() {
  records <- read_spatialtidymodels_metadata("datasets")
  if (is.null(records) || !is.data.frame(records)) return(NULL)
  if (!"benchmark_ready" %in% names(records)) return(NULL)
  records <- records[isTRUE(records$benchmark_ready) | records$benchmark_ready %in% TRUE, , drop = FALSE]
  if (nrow(records) == 0L) return(NULL)

  required <- c(
    "dataset", "data_object", "rds", "formula", "response", "predictors",
    "coords", "coords_crs", "coords_source", "recommended_cv", "mode",
    "formula_status", "source_ref", "notes"
  )
  if (!all(required %in% names(records))) return(NULL)

  out <- records[, required, drop = FALSE]
  for (field in c(
    "topic", "observation_unit", "observed_population", "geographic_context",
    "temporal_context", "source_description", "description_source",
    "description_confidence"
  )) {
    out[[field]] <- if (field %in% names(records)) as.character(records[[field]]) else NA_character_
  }
  out$predictors <- as_character_list_column(out$predictors)
  out$coords <- as_character_list_column(out$coords)
  out$recommended_cv <- as_character_list_column(out$recommended_cv)
  if ("eligible_estimators" %in% names(records)) {
    out$eligible_estimators <- as_character_list_column(records$eligible_estimators)
  } else {
    out$eligible_estimators <- I(rep(list(character()), nrow(out)))
  }
  if ("benchmark_estimators" %in% names(records)) {
    out$benchmark_estimators <- as_character_list_column(records$benchmark_estimators)
  } else {
    out$benchmark_estimators <- out$eligible_estimators
  }
  if ("estimator_evidence" %in% names(records) && is.list(records$estimator_evidence)) {
    out$estimator_evidence <- I(records$estimator_evidence)
  } else {
    out$estimator_evidence <- I(rep(list(data.frame()), nrow(out)))
  }
  for (field in c("eligibility_basis", "eligibility_source_ref", "eligibility_notes")) {
    out[[field]] <- if (field %in% names(records)) as.character(records[[field]]) else NA_character_
  }
  out$dataset <- as.character(out$dataset)
  out$data_object <- as.character(out$data_object)
  out$rds <- as.character(out$rds)
  out$formula <- as.character(out$formula)
  out$response <- as.character(out$response)
  out$coords_crs <- as.character(out$coords_crs)
  out$coords_source <- as.character(out$coords_source)
  out$mode <- as.character(out$mode)
  out$formula_status <- as.character(out$formula_status)
  out$source_ref <- as.character(out$source_ref)
  out$notes <- as.character(out$notes)
  rownames(out) <- NULL
  out
}

metadata_estimator_registry <- function() {
  records <- read_spatialtidymodels_metadata("estimators")
  if (is.null(records) || !is.data.frame(records)) return(NULL)

  required <- c(
    "estimator", "status", "mode", "package", "backend", "automatic",
    "requires_coords", "requires_W", "spatial_args", "tunable_parameters",
    "notes"
  )
  if (!all(required %in% names(records))) return(NULL)

  out <- records[, required, drop = FALSE]
  out$estimator <- as.character(out$estimator)
  out$status <- as.character(out$status)
  out$mode <- as.character(out$mode)
  out$package <- as.character(out$package)
  out$backend <- as.character(out$backend)
  out$automatic <- as.logical(out$automatic)
  out$requires_coords <- as.logical(out$requires_coords)
  out$requires_W <- as.logical(out$requires_W)
  if ("test_datasets" %in% names(records)) {
    out$test_datasets <- as_character_list_column(records$test_datasets)
  } else {
    out$test_datasets <- I(rep(list(character()), nrow(out)))
  }
  out$spatial_args <- as.character(out$spatial_args)
  out$tunable_parameters <- as.character(out$tunable_parameters)
  out$notes <- as.character(out$notes)
  rownames(out) <- NULL
  out
}

#' List estimators eligible for a benchmark dataset
#'
#' Eligibility is metadata-driven. A route can be recommended because a
#' scientific source used the dataset with the same model family, or because the
#' project marks the dataset as a useful technical benchmark for that estimator.
#'
#' @param dataset Registered dataset name.
#' @param include_installed If `TRUE`, add whether the backend package is
#'   installed.
#' @param evidence Which evidence layer to return. `"scientific_evidence"`
#'   returns only paper/manual-supported estimator routes. `"benchmark_use"`
#'   returns technical benchmark routes. `"all"` returns both.
#'
#' @return A data frame with estimator metadata and evidence columns.
#' @export
eligible_estimators_for_dataset <- function(dataset,
                                            include_installed = TRUE,
                                            evidence = c("scientific_evidence", "benchmark_use", "all")) {
  evidence <- match.arg(evidence)
  datasets <- benchmark_dataset_registry()
  if (length(dataset) != 1L || !dataset %in% datasets$dataset) {
    stop(
      sprintf(
        "Unknown dataset: %s. Use available_benchmark_datasets() to list valid names.",
        paste(dataset, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  spec <- datasets[datasets$dataset == dataset, , drop = FALSE]
  evidence_rows <- spec$estimator_evidence[[1]]
  if (!is.data.frame(evidence_rows)) {
    evidence_rows <- data.frame(
      estimator = unlist(spec$eligible_estimators[[1]], use.names = FALSE),
      basis = spec$eligibility_basis[[1]],
      source_ref = spec$eligibility_source_ref[[1]],
      pages = NA_character_,
      pdf_pages = NA_character_,
      stringsAsFactors = FALSE
    )
  }
  if (evidence == "all") {
    evidence_rows <- evidence_rows[evidence_rows$basis %in% c("scientific_evidence", "benchmark_use"), , drop = FALSE]
  } else {
    evidence_rows <- evidence_rows[evidence_rows$basis == evidence, , drop = FALSE]
  }
  eligible <- as.character(evidence_rows$estimator)
  registry <- available_benchmark_estimators(include_installed = include_installed)
  out <- registry[registry$estimator %in% eligible, , drop = FALSE]
  if (nrow(out) == 0L) return(out)
  out <- merge(out, evidence_rows, by = "estimator", all.x = TRUE, sort = FALSE)
  out$dataset <- dataset
  out$formula <- spec$formula[[1]]
  out$eligibility_basis <- out$basis
  out$eligibility_source_ref <- out$source_ref
  out$eligibility_notes <- out$notes.y %||% spec$eligibility_notes[[1]]
  rownames(out) <- NULL
  out
}

#' List benchmark datasets eligible for an estimator
#'
#' Returns the registered datasets that the metadata marks as good candidates
#' for a given estimator route.
#'
#' @param estimator Estimator name from `available_benchmark_estimators()`.
#'
#' @return A data frame with dataset metadata and evidence columns.
#' @export
eligible_datasets_for_estimator <- function(estimator) {
  estimators <- available_benchmark_estimators(include_installed = FALSE)
  if (length(estimator) != 1L || !estimator %in% estimators$estimator) {
    stop(
      sprintf(
        "Unknown estimator: %s. Use available_benchmark_estimators() to list valid names.",
        paste(estimator, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  datasets <- benchmark_dataset_registry()
  keep <- vapply(datasets$benchmark_estimators, function(values) {
    estimator %in% values
  }, logical(1))
  out <- datasets[keep, , drop = FALSE]
  out$estimator <- estimator
  rownames(out) <- NULL
  out
}

#' Explain a registered benchmark dataset
#'
#' Summarizes what the package knows about a dataset: topic, observation unit,
#' formula, coordinates, source, and estimator eligibility evidence.
#'
#' @param dataset Registered dataset name from `available_benchmark_datasets()`.
#' @param evidence Evidence layer passed to `eligible_estimators_for_dataset()`.
#' @param include_installed If `TRUE`, report whether estimator backend packages
#'   are installed.
#'
#' @return A list with `summary` and `eligible_estimators`.
#' @export
explain_dataset <- function(dataset,
                            evidence = c("all", "scientific_evidence", "benchmark_use"),
                            include_installed = FALSE) {
  evidence <- match.arg(evidence)
  registry <- benchmark_dataset_registry()
  if (length(dataset) != 1L || !dataset %in% registry$dataset) {
    stop(
      sprintf(
        "Unknown dataset: %s. Use available_benchmark_datasets() to list valid names.",
        paste(dataset, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  spec <- registry[registry$dataset == dataset, , drop = FALSE]
  estimators <- eligible_estimators_for_dataset(
    dataset,
    include_installed = include_installed,
    evidence = evidence
  )
  summary <- data.frame(
    dataset = spec$dataset[[1]],
    topic = spec$topic[[1]],
    observation_unit = spec$observation_unit[[1]],
    observed_population = spec$observed_population[[1]],
    formula = spec$formula[[1]],
    response = spec$response[[1]],
    coords = paste(unlist(spec$coords[[1]], use.names = FALSE), collapse = ", "),
    coords_crs = spec$coords_crs[[1]],
    source_ref = spec$source_ref[[1]],
    source_description = spec$source_description[[1]],
    stringsAsFactors = FALSE
  )
  out <- list(summary = summary, eligible_estimators = estimators)
  class(out) <- "spatial_dataset_explanation"
  out
}

#' Explain a registered benchmark estimator
#'
#' Summarizes estimator requirements and lists datasets currently linked to the
#' estimator by scientific evidence or benchmark-use metadata.
#'
#' @param estimator Estimator name from `available_benchmark_estimators()`.
#'
#' @return A list with `summary` and `eligible_datasets`.
#' @export
explain_estimator <- function(estimator) {
  estimators <- available_benchmark_estimators(include_installed = FALSE)
  if (length(estimator) != 1L || !estimator %in% estimators$estimator) {
    stop(
      sprintf(
        "Unknown estimator: %s. Use available_benchmark_estimators() to list valid names.",
        paste(estimator, collapse = ", ")
      ),
      call. = FALSE
    )
  }

  spec <- estimators[estimators$estimator == estimator, , drop = FALSE]
  datasets <- eligible_datasets_for_estimator(estimator)
  keep_cols <- intersect(
    c(
      "dataset", "topic", "observation_unit", "formula", "response",
      "coords_crs", "eligibility_basis", "eligibility_source_ref",
      "eligibility_notes"
    ),
    names(datasets)
  )
  out <- list(
    summary = spec,
    eligible_datasets = datasets[, keep_cols, drop = FALSE]
  )
  class(out) <- "spatial_estimator_explanation"
  out
}

#' @export
print.spatial_dataset_explanation <- function(x, ...) {
  cat("Dataset explanation\n")
  print(x$summary, row.names = FALSE)
  cat("\nEligible estimators\n")
  if (nrow(x$eligible_estimators) == 0L) {
    cat("No eligible estimator recorded for this evidence layer.\n")
  } else {
    cols <- intersect(
      c("estimator", "eligibility_basis", "eligibility_source_ref", "pages", "pdf_pages", "eligibility_notes"),
      names(x$eligible_estimators)
    )
    print(x$eligible_estimators[, cols, drop = FALSE], row.names = FALSE)
  }
  invisible(x)
}

#' @export
print.spatial_estimator_explanation <- function(x, ...) {
  cat("Estimator explanation\n")
  print(x$summary, row.names = FALSE)
  cat("\nEligible datasets\n")
  if (nrow(x$eligible_datasets) == 0L) {
    cat("No eligible dataset recorded for this estimator.\n")
  } else {
    print(x$eligible_datasets, row.names = FALSE)
  }
  invisible(x)
}
