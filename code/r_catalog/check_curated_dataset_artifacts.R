# Targeted artifact/loader audit, without running a benchmark or fitting models.
# Usage: Rscript code/r_catalog/check_curated_dataset_artifacts.R [output.json]
suppressPackageStartupMessages({library(jsonlite); library(sf)})
root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
args <- commandArgs(trailingOnly = TRUE)
output <- if (length(args)) args[1] else file.path(root, "data/manifests/datasets/dataset_fiches_validation_2026-09-07.json")
records <- jsonlite::fromJSON(file.path(root, "packages/spatialtidymodels/inst/metadata/datasets.json"), simplifyVector = FALSE)$records
`%||%` <- function(x, y) if (is.null(x)) y else x
source(file.path(root, "packages/spatialtidymodels/R/metadata-registry.R"))
source(file.path(root, "packages/spatialtidymodels/R/benchmark-datasets.R"))
source(file.path(root, "packages/spatialtidymodels/R/spatial-args.R"))
read_spatialtidymodels_metadata <- function(kind) {
  jsonlite::fromJSON(file.path(root, "packages/spatialtidymodels/inst/metadata", paste0(kind, ".json")), simplifyDataFrame = TRUE)$records
}
results <- list()
for (r in records) {
  warnings_seen <- character()
  z <- withCallingHandlers(tryCatch({
    obj <- readRDS(file.path(root, r$rds))
    result <- list(dataset_id = r$dataset_id, rds = r$rds, readable = TRUE,
                   n = nrow(obj), columns = names(obj), benchmark_ready = r$benchmark_ready)
    result$geometry_valid_structure <- inherits(obj, "sf") && inherits(tryCatch(sf::st_geometry(obj), error=function(e) NULL), "sfc")
    f <- r$formula_used %||% "pending"
    if (tolower(f) %in% c("", "pending", "unknown")) {
      result$formula_status <- "unavailable"
    } else {
      formula <- stats::as.formula(f)
      result$missing_variables <- setdiff(all.vars(formula), names(obj))
      result$formula_status <- if (length(result$missing_variables)) "missing_variables" else "valid"
    }
    if (isTRUE(r$benchmark_ready)) {
      loaded <- load_benchmark_dataset(r$dataset, data_dir = root)
      result$loader <- "loaded"
      result$n_loaded <- nrow(loaded$data)
      result$route <- detect_response_typology_from_spec(loaded$spec)
      if (!result$route %in% c("continuous", "binary", "count")) stop("Invalid route")
    } else result$loader <- "not_promoted"
    result
  }, error=function(e) list(dataset_id=r$dataset_id, error=conditionMessage(e))),
  warning=function(w) {
    warnings_seen <<- c(warnings_seen, conditionMessage(w))
    invokeRestart("muffleWarning")
  })
  z$warnings <- unique(warnings_seen)
  results[[length(results)+1L]] <- z
  if (!is.null(z$error)) message(r$dataset_id, ": ", z$error)
  if (length(results) %% 30 == 0) message(length(results), "/", length(records), " checked")
  rm(z); if (exists("obj")) rm(obj); gc(verbose = FALSE)
}
jsonlite::write_json(list(date="2026-09-07", records=results), output, auto_unbox=TRUE, pretty=TRUE, null="null")
errors <- vapply(results, function(z) !is.null(z$error) || identical(z$formula_status, "missing_variables"), logical(1))
cat("Checked:",length(results),"; errors:",sum(errors),"; loaded:",sum(vapply(results,function(z) identical(z$loader,"loaded"),logical(1))),"\n")
if (any(errors)) quit(status=1)
