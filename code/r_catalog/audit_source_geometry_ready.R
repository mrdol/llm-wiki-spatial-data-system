#!/usr/bin/env Rscript

# Audit non destructif du support spatial d'origine des jeux techniquement prets.
#
# Le snapshot definit le perimetre. Le script ne regenere ni RDS ni fiche : il
# inspecte l'artefact final, retrouve autant que possible le dossier source local
# utilise par le loader et inventorie les fichiers spatiaux natifs presents.

suppressWarnings(suppressMessages({
  if (!requireNamespace("sf", quietly = TRUE)) stop("Le package sf est requis.")
}))

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (basename(current) == "llm-wiki-karpathy") return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Racine llm-wiki-karpathy introuvable.")
}

ROOT <- find_repo_root()
SNAPSHOT <- file.path(
  ROOT, "extensions_projet_2026-09", "redaction_datapaper",
  "snapshot_noyau_publiable_2026-09-27.tsv"
)
OUTPUT <- file.path(
  ROOT, "extensions_projet_2026-09", "redaction_datapaper",
  "audit_geometrie_origine_276.tsv"
)
PAPER_BUILDER <- file.path(ROOT, "code", "r_catalog", "build_sf_datasets_papers.R")

collapse_unique <- function(x) {
  x <- unique(x[!is.na(x) & nzchar(x)])
  if (length(x)) paste(x, collapse = ";") else ""
}

scalar_text <- function(x) {
  if (!length(x) || is.na(x[1])) "" else as.character(x[1])
}

fiche_bullet <- function(dataset_id, key) {
  path <- file.path(ROOT, "wiki", "datasets", "fiches_datasets", paste0(dataset_id, ".md"))
  if (!file.exists(path)) return("")
  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  prefix <- paste0("- ", key, ":")
  hit <- lines[startsWith(lines, prefix)]
  if (!length(hit)) return("")
  trimws(sub(paste0("^- ", key, ":\\s*"), "", hit[1]))
}

semantic_support <- function(observation_unit, spatial_resolution) {
  text <- tolower(iconv(paste(observation_unit, spatial_resolution), to = "ASCII//TRANSLIT"))
  if (grepl("raster|pixel|cellule|grid|grille", text)) return("grid_or_raster_cell")
  if (grepl("polygone|polygon", text)) return("polygon_feature")
  if (grepl("municip|commune|county|comte|tract|district|province|pays|juridiction|circonscription|zone administrative|bassin versant|atoll", text)) return("areal_unit")
  if (grepl("station|site|point|placette|transect|nid|specimen|individu|transaction|logement|annonce|occurrence|logger|parcelle", text)) return("point_or_localized_observation")
  "unresolved_semantic_support"
}

resolve_r_package_dir <- function(source_id) {
  if (!startsWith(source_id, "R_")) return(character())
  package <- sub("^R_([^_]+)_.*$", "\\1", source_id)
  path <- tryCatch(system.file(package = package), error = function(e) "")
  if (nzchar(path)) file.path(path, "data") else character()
}

geometry_types <- function(x) {
  if (!inherits(x, "sfc")) return("")
  collapse_unique(as.character(sf::st_geometry_type(x)))
}

inspect_artifact <- function(path) {
  ans <- list(
    artifact_readable = FALSE,
    artifact_active_geometry = "",
    artifact_geometry_columns = "",
    artifact_original_geometry = "",
    artifact_original_geometry_present = FALSE,
    artifact_note = ""
  )
  if (!file.exists(path)) {
    ans$artifact_note <- "artifact_missing"
    return(ans)
  }
  obj <- tryCatch({
    if (grepl("\\.rds$", path, ignore.case = TRUE)) readRDS(path)
    else if (grepl("\\.gpkg$", path, ignore.case = TRUE)) sf::st_read(path, quiet = TRUE)
    else NULL
  }, error = function(e) e)
  if (inherits(obj, "error") || is.null(obj)) {
    ans$artifact_note <- if (inherits(obj, "error")) conditionMessage(obj) else "unsupported_artifact"
    return(ans)
  }
  ans$artifact_readable <- TRUE
  if (inherits(obj, "sf")) {
    active <- attr(obj, "sf_column")
    sfc_names <- names(obj)[vapply(obj, inherits, logical(1), what = "sfc")]
    if (!length(active) || !(active %in% sfc_names)) {
      active <- if (length(sfc_names)) sfc_names[1] else ""
      ans$artifact_note <- "invalid_sf_column_attribute"
    }
    ans$artifact_active_geometry <- if (nzchar(active)) geometry_types(obj[[active]]) else ""
    ans$artifact_geometry_columns <- collapse_unique(vapply(
      sfc_names,
      function(nm) paste0(nm, "=", geometry_types(obj[[nm]])),
      character(1)
    ))
    original_names <- setdiff(sfc_names, active)
    preferred <- original_names[tolower(original_names) %in% c(
      "geom_origine", "geometry_original", "original_geometry", "geom_original"
    )]
    if (!length(preferred)) preferred <- original_names
    if (length(preferred)) {
      ans$artifact_original_geometry_present <- TRUE
      ans$artifact_original_geometry <- collapse_unique(vapply(
        preferred,
        function(nm) geometry_types(obj[[nm]]),
        character(1)
      ))
    }
  } else {
    ans$artifact_note <- paste(class(obj), collapse = "/")
  }
  ans
}

paper_loader_map <- function() {
  env <- new.env(parent = globalenv())
  sys.source(PAPER_BUILDER, envir = env)
  loaders <- get("PAPER_DATASET_LOADERS", envir = env)
  expand_body <- function(fun, seen = character(), depth = 0L) {
    txt <- paste(deparse(body(fun), width.cutoff = 500L), collapse = "\n")
    if (depth >= 5L) return(txt)
    called <- unique(all.names(body(fun), functions = TRUE))
    called <- setdiff(called, seen)
    helpers <- called[vapply(called, function(nm) {
      exists(nm, envir = env, inherits = FALSE) && is.function(get(nm, envir = env, inherits = FALSE))
    }, logical(1))]
    if (!length(helpers)) return(txt)
    nested <- vapply(helpers, function(nm) {
      expand_body(get(nm, envir = env, inherits = FALSE), c(seen, nm), depth + 1L)
    }, character(1))
    paste(c(txt, nested), collapse = "\n")
  }
  lapply(loaders, function(fun) expand_body(fun))
}

resolve_paper_dirs <- function(loader_text, raw_dirs, raw_files) {
  if (!nzchar(loader_text)) return(character())
  hit <- gregexpr(
    "find_paper_raw_dir\\([\\\"']([^\\\"']+)[\\\"']\\)",
    loader_text,
    perl = TRUE
  )
  calls <- regmatches(loader_text, hit)[[1]]
  patterns <- if (length(calls) && calls[1] != "") {
    sub(".*find_paper_raw_dir\\([\\\"']([^\\\"']+)[\\\"']\\).*", "\\1", calls)
  } else character()
  out <- character()
  for (pattern in patterns) {
    matched <- raw_dirs[grepl(pattern, basename(raw_dirs), ignore.case = TRUE, perl = TRUE)]
    out <- c(out, matched)
  }
  quoted_files <- regmatches(
    loader_text,
    gregexpr("[\\\"'][^\\\"']+\\.(csv|tsv|txt|dat|tab|dta|xlsx|xls|zip|shp|gpkg|geojson|gml|kml|tif|tiff|img|asc|grd|nc|nc4|hdf|h5|rds|rda|rdata)[\\\"']", loader_text,
              ignore.case = TRUE, perl = TRUE)
  )[[1]]
  if (length(quoted_files) && quoted_files[1] != "") {
    quoted_files <- gsub("^[\\\"']|[\\\"']$", "", quoted_files)
    wanted <- unique(basename(quoted_files))
    matched_files <- raw_files[tolower(basename(raw_files)) %in% tolower(wanted)]
    out <- c(out, dirname(matched_files))
  }
  unique(out)
}

spatial_file_kind <- function(path) {
  ext <- tolower(tools::file_ext(path))
  if (ext %in% c("tif", "tiff", "img", "asc", "grd", "nc", "nc4", "hdf", "h5")) return("raster_or_grid")
  if (ext %in% c("shp", "gpkg", "geojson", "json", "gml", "kml")) return("vector")
  if (ext %in% c("csv", "tsv", "txt", "dat", "tab", "dta", "xlsx", "xls")) return("table")
  if (ext == "zip") return("archive")
  if (ext %in% c("rds", "rda", "rdata")) return("r_object")
  "other"
}

inspect_vector_file <- function(path) {
  obj <- tryCatch(sf::st_read(path, quiet = TRUE), error = function(e) NULL)
  if (is.null(obj)) return("")
  collapse_unique(as.character(sf::st_geometry_type(obj)))
}

inventory_source_dir <- function(paths, loader_text) {
  ans <- list(
    source_files = "",
    source_formats = "",
    native_spatial_files = "",
    native_geometry_types = "",
    source_coordinate_columns = "",
    source_inventory_note = ""
  )
  paths <- unique(paths[dir.exists(paths)])
  if (!length(paths)) {
    ans$source_inventory_note <- "source_directory_unresolved"
    return(ans)
  }
  files <- unique(unlist(lapply(paths, list.files, recursive = TRUE, full.names = TRUE)))
  files <- files[file.exists(files) & !dir.exists(files)]
  if (!length(files)) {
    ans$source_inventory_note <- "source_directory_empty"
    return(ans)
  }
  kinds <- vapply(files, spatial_file_kind, character(1))
  relevant <- files[kinds != "other"]
  # Favorise les noms de fichiers cites litteralement dans le corps du loader.
  used <- relevant[vapply(basename(relevant), function(nm) grepl(nm, loader_text, fixed = TRUE), logical(1))]
  selected <- if (length(used)) used else relevant
  vector_files <- selected[vapply(selected, spatial_file_kind, character(1)) == "vector"]
  raster_files <- selected[vapply(selected, spatial_file_kind, character(1)) == "raster_or_grid"]
  vector_types <- vapply(vector_files, inspect_vector_file, character(1))
  coord_hits <- regmatches(
    loader_text,
    gregexpr("coords\\s*=\\s*c\\([^)]*\\)", loader_text, ignore.case = TRUE, perl = TRUE)
  )[[1]]
  coord_text <- collapse_unique(gsub("[\\\"']", "", coord_hits))
  has_table <- any(vapply(selected, spatial_file_kind, character(1)) == "table")
  type_evidence <- c(
    vector_types[nzchar(vector_types)],
    if (length(raster_files)) "RASTER_GRID",
    if (has_table && nzchar(coord_text)) "COORDINATE_TABLE"
  )
  rel <- vapply(selected, function(p) {
    owner <- paths[startsWith(normalizePath(p, winslash = "/", mustWork = FALSE),
                              paste0(normalizePath(paths, winslash = "/", mustWork = FALSE), "/"))][1]
    if (is.na(owner) || !nzchar(owner)) basename(p) else file.path(basename(owner), substring(p, nchar(owner) + 2L))
  }, character(1))
  ans$source_files <- collapse_unique(rel)
  ans$source_formats <- collapse_unique(tolower(tools::file_ext(selected)))
  ans$native_spatial_files <- collapse_unique(c(basename(vector_files), basename(raster_files)))
  ans$native_geometry_types <- collapse_unique(type_evidence)
  ans$source_coordinate_columns <- coord_text
  ans$source_inventory_note <- if (length(used)) "loader_literal_file_match" else "directory_inventory_requires_file_selection_review"
  ans
}

snapshot <- read.delim(SNAPSHOT, sep = "\t", stringsAsFactors = FALSE, check.names = FALSE)
names(snapshot)[1] <- "dataset_id"
ready <- snapshot[tolower(snapshot$technical_ready) == "true", , drop = FALSE]
if (nrow(ready) != 276L) stop("Le snapshot ne contient pas exactement 276 entrees techniquement pretes.")
cat("Colonnes snapshot : ", paste(names(ready), collapse = ", "), "\n")

cat("Chargement de la carte des loaders papier...\n")
loader_texts <- paper_loader_map()
cat(sprintf("Loaders trouves : %d\n", length(loader_texts)))
raw_paper_root <- file.path(ROOT, "data", "raw", "papers")
raw_paper_dirs <- list.dirs(raw_paper_root, recursive = FALSE, full.names = TRUE)
raw_paper_files <- unique(c(
  list.files(raw_paper_root, recursive = TRUE, full.names = TRUE),
  list.files(file.path(ROOT, "data", "raw", "covariates"), recursive = TRUE, full.names = TRUE),
  list.files(file.path(ROOT, "data", "final_datasets", "sf"), recursive = FALSE, full.names = TRUE)
))

rows <- vector("list", nrow(ready))
for (i in seq_len(nrow(ready))) {
  rec <- ready[i, , drop = FALSE]
  dataset_id <- rec$dataset_id
  source_id <- rec$source_dataset_id
  if (i %% 25L == 1L) cat(sprintf("Audit %d/%d : %s\n", i, nrow(ready), dataset_id))
  artifact_path <- file.path(ROOT, rec$local_artifact)
  artifact <- inspect_artifact(artifact_path)

  loader_key <- if (startsWith(source_id, "paper_")) substring(source_id, 7L) else ""
  loader_text <- if (nzchar(loader_key) && loader_key %in% names(loader_texts)) loader_texts[[loader_key]] else ""
  source_dirs <- resolve_paper_dirs(loader_text, raw_paper_dirs, raw_paper_files)
  if (!length(source_dirs) && startsWith(source_id, "R_")) source_dirs <- resolve_r_package_dir(source_id)
  source_inventory <- inventory_source_dir(source_dirs, loader_text)

  observation_unit <- fiche_bullet(dataset_id, "Observation unit")
  spatial_resolution <- fiche_bullet(dataset_id, "Spatial resolution")
  support_semantic <- semantic_support(observation_unit, spatial_resolution)

  preliminary <- "indeterminate"
  evidence_level <- "pending_source_file_review"
  if (nzchar(source_inventory$native_geometry_types)) {
    preliminary <- source_inventory$native_geometry_types
    evidence_level <- "local_source_file_inspected"
  } else if (isTRUE(artifact$artifact_original_geometry_present) && nzchar(artifact$artifact_original_geometry)) {
    preliminary <- artifact$artifact_original_geometry
    evidence_level <- "artifact_geom_origine_only"
  }

  values <- list(
    dataset_id = dataset_id,
    source_dataset_id = source_id,
    parent_dataset = scalar_text(rec$parent_dataset),
    source_family = scalar_text(rec$source_family),
    observation_unit = observation_unit,
    spatial_resolution = spatial_resolution,
    source_support_semantic = support_semantic,
    source_directory = collapse_unique(gsub("\\\\", "/", source_dirs)),
    loader_key = loader_key,
    source_files_inventory = scalar_text(source_inventory$source_files),
    source_formats = scalar_text(source_inventory$source_formats),
    native_spatial_files = scalar_text(source_inventory$native_spatial_files),
    native_geometry_types_file = scalar_text(source_inventory$native_geometry_types),
    source_coordinate_columns = scalar_text(source_inventory$source_coordinate_columns),
    source_support_preliminary = preliminary,
    evidence_level = evidence_level,
    source_inventory_note = scalar_text(source_inventory$source_inventory_note),
    artifact_path = scalar_text(rec$local_artifact),
    artifact_readable = artifact$artifact_readable,
    artifact_active_geometry = scalar_text(artifact$artifact_active_geometry),
    artifact_geometry_columns = scalar_text(artifact$artifact_geometry_columns),
    artifact_original_geometry_present = artifact$artifact_original_geometry_present,
    artifact_original_geometry = scalar_text(artifact$artifact_original_geometry),
    audit_status = if (evidence_level == "local_source_file_inspected") "source_file_found_needs_semantic_validation" else "manual_source_review_required"
  )
  bad <- names(values)[vapply(values, length, integer(1)) == 0L]
  if (length(bad)) stop(sprintf("%s: zero-length fields: %s", dataset_id, paste(bad, collapse = ", ")))
  rows[[i]] <- as.data.frame(values, stringsAsFactors = FALSE)
}

out <- do.call(rbind, rows)

# Corrections documentees pour les cinq routes dont la source n'est pas
# resolue par PAPER_DATASET_LOADERS (builders dedies ou jointure externe).
manual <- list(
  paper_o3_aqs_ma_2016_monitor_covariates = list(
    directory = file.path(ROOT, "data", "raw", "covariates", "airdata"),
    files = "EPA_AQS daily observations used by tools/build_air_quality_monitor_covariates.R",
    format = "csv",
    native = "COORDINATE_TABLE",
    semantic = "point_or_localized_observation",
    note = "EPA AQS monitoring stations; longitude/latitude are native station coordinates."
  ),
  paper_pm25_aqs_ma_2016_monitor_covariates = list(
    directory = file.path(ROOT, "data", "raw", "covariates", "airdata"),
    files = "EPA_AQS daily observations used by tools/build_air_quality_monitor_covariates.R",
    format = "csv",
    native = "COORDINATE_TABLE",
    semantic = "point_or_localized_observation",
    note = "EPA AQS monitoring stations; longitude/latitude are native station coordinates."
  ),
  paper_regulatory_convergence = list(
    directory = file.path(ROOT, "data", "raw", "papers", "DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0"),
    files = "AA-workingdata.tab + spData::world",
    format = "tab;r-package",
    native = "ATTRIBUTE_TABLE+EXTERNAL_MULTIPOLYGON",
    semantic = "areal_unit",
    note = "The replication table has country identifiers but no native geometry; country polygons are joined locally from spData::world."
  ),
  paper_velado_alonso_wildlife_livestock_diversity = list(
    directory = file.path(ROOT, "data", "raw", "papers", "DataCite_2020_RelationshipsBetweenTheDistribution_10_1111_ddi_1313"),
    files = "vertebrate_livestock_diversity_Spain_database.csv",
    format = "csv",
    native = "COORDINATE_TABLE",
    semantic = "grid_or_raster_cell",
    note = "The local source table represents 10 x 10 km UTM grid cells by coordinates; cell polygons are not stored in the CSV."
  ),
  paper_wang_henan_cultivated_land_quality = list(
    directory = file.path(ROOT, "data", "raw", "papers", "DataCite_2022_ModelingOfSpatialPattern_10_1371_journal_"),
    files = "Soil_quality_information_summary_table.xlsx",
    format = "xlsx",
    native = "ATTRIBUTE_TABLE+EXTERNAL_MULTIPOLYGON",
    semantic = "areal_unit",
    note = "The local source workbook is county-level; the polygon geometry used downstream is stored in the local converted GeoPackage."
  )
)
for (id in names(manual)) {
  idx <- out$source_dataset_id == id
  if (!any(idx)) next
  row <- manual[[id]]
  out$source_directory[idx] <- gsub("\\\\", "/", row$directory)
  out$source_files_inventory[idx] <- row$files
  out$source_formats[idx] <- row$format
  out$native_geometry_types_file[idx] <- row$native
  out$source_support_preliminary[idx] <- row$native
  out$source_support_semantic[idx] <- row$semantic
  out$evidence_level[idx] <- "local_source_file_inspected"
  out$source_inventory_note[idx] <- row$note
  out$audit_status[idx] <- "source_file_found_needs_semantic_validation"
}

# Fichiers caches localement par geodatasets/libpysal. Les types ci-dessous
# sont controles contre les fichiers SHP/GPKG/GeoJSON locaux et contre la
# colonne geom_origine conservee dans l'artefact RDS.
python_cache <- file.path(Sys.getenv("LOCALAPPDATA"), "geodatasets", "geodatasets", "Cache")
python_examples <- file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "Python", "Python314", "Lib", "site-packages", "libpysal", "examples")
python_manual <- list(
  Python_geodatasets_geoda.guerry = c(file.path(python_cache, "guerry.zip.unzip"), "guerry.shp", "MULTIPOLYGON"),
  Python_geodatasets_geoda.ncovr_1960 = c(file.path(python_cache, "ncovr.zip.unzip"), "NAT.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_geoda.ncovr_1970 = c(file.path(python_cache, "ncovr.zip.unzip"), "NAT.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_geoda.ncovr_1980 = c(file.path(python_cache, "ncovr.zip.unzip"), "NAT.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_geoda.ncovr_1990 = c(file.path(python_cache, "ncovr.zip.unzip"), "NAT.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_geoda.sids_1974 = c(python_cache, "sids.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_geoda.sids_1979 = c(python_cache, "sids.gpkg", "MULTIPOLYGON"),
  Python_geodatasets_spdata.boston = c(python_cache, "boston_tracts.gpkg", "POLYGON"),
  Python_geodatasets_spdata.columbus = c(python_cache, "columbus.gpkg", "POLYGON"),
  Python_geodatasets_spdata.nydata = c(python_cache, "NY8_bna_utm18.gpkg", "MULTIPOLYGON"),
  Python_libpysal_Baltimore = c(file.path(python_examples, "baltim"), "baltimore.geojson", "POINT"),
  Python_libpysal_georgia = c(file.path(python_examples, "georgia"), "G_utm.shp", "MULTIPOLYGON")
)
for (id in names(python_manual)) {
  idx <- out$source_dataset_id == id
  if (!any(idx)) next
  row <- python_manual[[id]]
  out$source_directory[idx] <- gsub("\\\\", "/", row[1])
  out$source_files_inventory[idx] <- row[2]
  out$source_formats[idx] <- tolower(tools::file_ext(row[2]))
  out$native_spatial_files[idx] <- row[2]
  out$native_geometry_types_file[idx] <- row[3]
  out$source_support_preliminary[idx] <- row[3]
  out$evidence_level[idx] <- "local_source_file_inspected"
  out$source_inventory_note[idx] <- "Local geodatasets/libpysal source file inspected; type agrees with preserved geom_origine."
  out$audit_status[idx] <- "source_file_found_needs_semantic_validation"
}

# Pour les packages R, build_sf_datasets.R conserve sans conversion destructive
# l'objet charge depuis le repertoire data du package dans geom_origine.
r_idx <- startsWith(out$source_dataset_id, "R_") & nzchar(out$source_directory) &
  nzchar(out$artifact_original_geometry)
out$evidence_level[r_idx] <- "local_r_package_source_preserved"
out$source_support_preliminary[r_idx] <- out$artifact_original_geometry[r_idx]
out$source_inventory_note[r_idx] <- paste0(
  "Installed R package data directory inspected; geom_origine preserves the loaded package object's geometry (",
  out$artifact_original_geometry[r_idx], ")."
)
out$audit_status[r_idx] <- "source_file_found_needs_semantic_validation"

# Propage seulement les informations de source entre variantes partageant le
# meme source_dataset_id. La geometrie propre a chaque artefact reste intacte.
for (source_id in unique(out$source_dataset_id)) {
  idx <- which(out$source_dataset_id == source_id)
  for (field in c("source_directory", "source_files_inventory", "source_formats",
                  "native_spatial_files", "native_geometry_types_file",
                  "source_coordinate_columns", "source_support_preliminary",
                  "source_support_semantic", "evidence_level", "source_inventory_note")) {
    values <- out[[field]][idx]
    chosen <- values[!is.na(values) & nzchar(values)][1]
    if (length(chosen)) out[[field]][idx[!nzchar(out[[field]][idx])]] <- chosen
  }
  original <- out$artifact_original_geometry[idx]
  original <- original[!is.na(original) & nzchar(original)][1]
  if (length(original)) {
    missing <- idx[!nzchar(out$source_support_preliminary[idx]) | out$source_support_preliminary[idx] == "indeterminate"]
    out$source_support_preliminary[missing] <- original
  }
}
write.table(out, OUTPUT, sep = "\t", quote = TRUE, row.names = FALSE, na = "")

cat(sprintf("Ecrit : %s\n", OUTPUT))
cat(sprintf("Entrees : %d ; sources parentes : %d\n", nrow(out), length(unique(out$source_dataset_id))))
print(table(out$evidence_level, useNA = "ifany"))
print(table(out$artifact_original_geometry_present, useNA = "ifany"))
