# Verite terrain CRS : inspecte directement chaque .rds final et enregistre
# le CRS reellement embarque (geometrie active + geometrie source quand
# presente), sans distinction "manquant/renseigne".
#
# A la difference de audit_sf_crs_time.R (qui ne traite que les jeux dont le
# CRS catalogue est absent, pour en proposer un), ce script re-verifie TOUS
# les .rds sans exception -- y compris ceux dont une fiche wiki affirme deja
# un CRS -- afin de detecter une affirmation fausse, pas seulement une
# absence. Sert de verite terrain a tools/verify_fiche_crs.py.
#
# Usage :
#   Rscript code/r_catalog/extract_crs_ground_truth.R
#   Rscript code/r_catalog/extract_crs_ground_truth.R --pattern "R_gstat_*"
#
# Sortie :
#   data/manifests/datasets/crs_ground_truth.json
#   Un objet par fichier .rds, cle par nom de fichier sans extension
#   (correspond au Dataset ID des fiches, ex. "R_gstat_jura_jura.full").

suppressPackageStartupMessages({
  if (!requireNamespace("sf", quietly = TRUE)) stop("Le package sf est requis.")
  if (!requireNamespace("jsonlite", quietly = TRUE)) stop("Le package jsonlite est requis.")
})

args <- commandArgs(trailingOnly = TRUE)
pattern_arg <- grep("^--pattern=", args, value = TRUE)
glob_pattern <- if (length(pattern_arg)) sub("^--pattern=", "", pattern_arg[1]) else "*.rds"

find_repo_root <- function(start = getwd()) {
  dir <- start
  repeat {
    if (file.exists(file.path(dir, "CLAUDE.md"))) return(dir)
    parent <- dirname(dir)
    if (identical(parent, dir)) stop("Racine du depot introuvable (CLAUDE.md absent).")
    dir <- parent
  }
}

ROOT <- find_repo_root()
SF_DIR <- file.path(ROOT, "data", "final_datasets", "sf")
OUT_PATH <- file.path(ROOT, "data", "manifests", "datasets", "crs_ground_truth.json")

crs_summary <- function(crs) {
  if (is.null(crs) || is.na(crs)) {
    return(list(input = NA_character_, epsg = NA_integer_))
  }
  list(
    input = tryCatch(crs$input, error = function(e) NA_character_),
    epsg = tryCatch(as.integer(crs$epsg), error = function(e) NA_integer_)
  )
}

geometry_family <- function(sfc) {
  if (is.null(sfc) || length(sfc) == 0) return(NA_character_)
  types <- tryCatch(unique(as.character(sf::st_geometry_type(sfc))), error = function(e) NA_character_)
  paste(types, collapse = ",")
}

inspect_one <- function(path) {
  dataset_id <- sub("\\.rds$", "", basename(path))
  result <- list(dataset_id = dataset_id, rds_path = file.path("data", "final_datasets", "sf", basename(path)))

  obj <- tryCatch(readRDS(path), error = function(e) e)
  if (inherits(obj, "error")) {
    result$error <- paste("readRDS failed:", conditionMessage(obj))
    return(result)
  }
  if (!inherits(obj, "sf")) {
    result$error <- paste0("not an sf object (class: ", paste(class(obj), collapse = ","), ")")
    return(result)
  }

  active_col <- attr(obj, "sf_column")
  result$active_geometry_column <- active_col
  active_geom <- tryCatch(sf::st_geometry(obj), error = function(e) NULL)
  active_crs <- crs_summary(tryCatch(sf::st_crs(active_geom), error = function(e) NA))
  result$active_crs_input <- active_crs$input
  result$active_crs_epsg <- active_crs$epsg
  result$active_geometry_type <- geometry_family(active_geom)

  bbox <- tryCatch(sf::st_bbox(active_geom), error = function(e) NULL)
  if (!is.null(bbox)) {
    result$bbox <- list(
      xmin = unname(bbox[["xmin"]]), ymin = unname(bbox[["ymin"]]),
      xmax = unname(bbox[["xmax"]]), ymax = unname(bbox[["ymax"]])
    )
  }

  if ("geom_origine" %in% names(obj) && !identical(active_col, "geom_origine")) {
    origine <- obj[["geom_origine"]]
    if (inherits(origine, "sfc")) {
      origine_crs <- crs_summary(tryCatch(sf::st_crs(origine), error = function(e) NA))
      result$origine_crs_input <- origine_crs$input
      result$origine_crs_epsg <- origine_crs$epsg
      result$origine_geometry_type <- geometry_family(origine)
    }
  }

  result$n_rows <- nrow(obj)
  result
}

files <- sort(Sys.glob(file.path(SF_DIR, glob_pattern)))
cat(sprintf("Inspection de %d fichiers .rds (%s)...\n", length(files), glob_pattern))

results <- vector("list", length(files))
for (i in seq_along(files)) {
  results[[i]] <- inspect_one(files[i])
  if (i %% 50 == 0) cat(sprintf("  ... %d/%d\n", i, length(files)))
}

out <- setNames(results, vapply(results, function(r) r$dataset_id, character(1)))
dir.create(dirname(OUT_PATH), recursive = TRUE, showWarnings = FALSE)
jsonlite::write_json(out, OUT_PATH, auto_unbox = TRUE, null = "null", na = "null", pretty = TRUE)

n_errors <- sum(vapply(results, function(r) !is.null(r$error), logical(1)))
n_no_crs <- sum(vapply(results, function(r) is.null(r$error) && is.na(r$active_crs_epsg), logical(1)))
cat(sprintf("\nTermine. %d fichiers inspectes, %d erreurs, %d sans CRS embarque sur geometrie active.\n",
            length(files), n_errors, n_no_crs))
cat("Sortie :", OUT_PATH, "\n")
