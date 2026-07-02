# Audit conservateur des CRS absents et des variables temporelles des objets sf.
# Sortie unique : data/Final_datasets/sf/catalogue_sf_metadata_audit.RData

suppressPackageStartupMessages({
  if (!requireNamespace("sf", quietly = TRUE)) stop("Le package sf est requis.")
})

file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_path <- if (length(file_arg)) sub("^--file=", "", file_arg[1]) else ""
script_dir <- if (nzchar(script_path)) {
  dirname(normalizePath(script_path, winslash = "/", mustWork = TRUE))
} else {
  file.path(find_repo_root(), "Code_scrapping", "r_catalog")
}
source(file.path(script_dir, "build_sf_datasets.R"), local = environment())

compact_text <- function(x, max_chars = 600L) {
  x <- trimws(gsub("\\s+", " ", paste(x, collapse = " ")))
  if (nchar(x) > max_chars) paste0(substr(x, 1L, max_chars), "...") else x
}

rd_text <- function(pkg, topics) {
  if (!nzchar(pkg) || !requireNamespace(pkg, quietly = TRUE)) return("")
  db <- tryCatch(tools::Rd_db(pkg), error = function(e) NULL)
  if (is.null(db)) return("")
  topics <- unique(tolower(topics[nzchar(topics)]))
  for (nm in names(db)) {
    aliases <- tryCatch(tools:::.Rd_get_metadata(db[[nm]], "alias"),
                        error = function(e) character(0))
    if (tolower(sub("[.]Rd$", "", nm)) %in% topics ||
        any(tolower(aliases) %in% topics)) {
      return(tryCatch(compact_text(capture.output(tools::Rd2txt(db[[nm]])), 4000L),
                      error = function(e) ""))
    }
  }
  ""
}

extract_documented_crs <- function(text) {
  if (!nzchar(text)) return(NA_character_)
  epsg <- regmatches(text, regexpr("EPSG[ :]+[0-9]{4,6}", text, ignore.case = TRUE))
  if (length(epsg) && nzchar(epsg)) {
    return(paste0("EPSG:", gsub("[^0-9]", "", epsg)))
  }
  proj <- regmatches(text, regexpr("[+]proj=[^;,.\\n]+", text, ignore.case = TRUE))
  if (length(proj) && nzchar(proj)) return(proj)
  NA_character_
}

crs_text <- function(crs) {
  if (is.null(crs) || is.na(crs)) return(NA_character_)
  if (!is.null(crs$epsg) && !is.na(crs$epsg)) return(paste0("EPSG:", crs$epsg))
  crs$input %||% crs$wkt %||% NA_character_
}

source_crs <- function(row, repo_root) {
  loaded <- tryCatch(load_dataset_object(row, repo_root, Inf, 0),
                     error = function(e) make_fail(conditionMessage(e)))
  if (is_fail(loaded)) return(list(crs = NA_character_, evidence = reason_of(loaded)))
  obj <- loaded$obj
  crs <- tryCatch({
    if (inherits(obj, "sf")) sf::st_crs(obj)
    else if (inherits(obj, "Spatial")) sf::st_crs(sf::st_as_sf(obj))
    else if (inherits(obj, "SpatVector")) sf::st_crs(sf::st_as_sf(obj))
    else NA
  }, error = function(e) NA)
  list(crs = crs_text(crs), evidence = paste(class(obj), collapse = ","))
}

all_geometry_crs <- function(x) {
  geom_cols <- names(x)[vapply(x, inherits, logical(1), what = "sfc")]
  values <- vapply(geom_cols, function(nm) crs_text(sf::st_crs(x[[nm]])), character(1))
  values[!is.na(values) & nzchar(values)]
}

sidecar_crs <- function(local_files, repo_root) {
  files <- resolve_local_files(local_files, repo_root)
  prj <- unique(c(files[grepl("[.]prj$", files, ignore.case = TRUE)],
                  sub("[.](shp|geojson|json|gpkg)$", ".prj", files, ignore.case = TRUE)))
  prj <- prj[file.exists(prj)]
  if (!length(prj)) return(list(crs = NA_character_, file = NA_character_))
  wkt <- paste(readLines(prj[1], warn = FALSE), collapse = " ")
  list(crs = crs_text(tryCatch(sf::st_crs(wkt), error = function(e) NA)), file = prj[1])
}

compatible_lonlat_bbox <- function(bb) {
  all(is.finite(bb)) && bb[["xmin"]] >= -180 && bb[["xmax"]] <= 180 &&
    bb[["ymin"]] >= -90 && bb[["ymax"]] <= 90
}

validate_candidate <- function(x, candidate) {
  if (is.na(candidate) || !nzchar(candidate)) return(list(ok = NA, bbox_4326 = NA_character_))
  result <- tryCatch({
    y <- sf::st_set_crs(x, candidate)
    z <- sf::st_transform(y, 4326)
    bb <- sf::st_bbox(z)
    plausible <- compatible_lonlat_bbox(bb) && !any(sf::st_is_empty(z))
    list(ok = plausible, bbox_4326 = paste(signif(as.numeric(bb), 7), collapse = ","))
  }, error = function(e) list(ok = FALSE, bbox_4326 = paste0("ERREUR: ", conditionMessage(e))))
  result
}

is_temporal_name <- function(x) {
  grepl("(^|[_.])(date|datetime|time|timestamp|year|month|week|day|period|season|round)([_.]|$)",
        tolower(x))
}

audit_sf_metadata <- function(repo_root = find_repo_root()) {
  sf_dir <- file.path(repo_root, "data", "Final_datasets", "sf")
  index_path <- file.path(sf_dir, "catalogue_sf_index.RData")
  catalog_path <- file.path(repo_root, "data", "manifests", "datasets",
                            "software_catalog_combined.RData")
  ie <- new.env(parent = emptyenv()); load(index_path, envir = ie)
  ce <- new.env(parent = emptyenv()); load(catalog_path, envir = ce)
  index_sf <- ie$index_sf
  catalog <- ce$catalogue_combine_complet
  catalog_by_id <- match(index_sf$record_id, catalog$record_id)

  missing_idx <- which(index_sf$utilisable == "TRUE" &
                         (is.na(index_sf$crs_input) | !nzchar(index_sf$crs_input)))
  crs_rows <- vector("list", length(missing_idx))
  for (j in seq_along(missing_idx)) {
    i <- missing_idx[j]
    ix <- index_sf[i, , drop = FALSE]
    row <- catalog[catalog_by_id[i], , drop = FALSE]
    x <- readRDS(file.path(repo_root, ix$sf_path))
    bb <- sf::st_bbox(x)
    geom_crs <- all_geometry_crs(x)
    src <- source_crs(row, repo_root)
    side <- sidecar_crs(row$local_files, repo_root)
    docs <- rd_text(row$package, c(row$dataset_name, row$source_entry))
    doc_crs <- extract_documented_crs(docs)
    docs_lonlat <- grepl("longitude|latitude|longlat|lon/lat|geographic coordinates",
                         docs, ignore.case = TRUE)
    coord_names <- split_fields(row$coordinate_columns)
    semantic_lonlat <- any(grepl("lat", coord_names, ignore.case = TRUE)) &&
      any(grepl("lon|long", coord_names, ignore.case = TRUE))

    candidate <- NA_character_; provenance <- "inconnu"; confidence <- "inconnu"
    evidence <- character(0)
    if (length(geom_crs)) {
      candidate <- geom_crs[1]; provenance <- "herite_geometrie_rds"; confidence <- "eleve"
      evidence <- c(evidence, "CRS present sur une colonne sfc du RDS")
    } else if (!is.na(src$crs)) {
      candidate <- src$crs; provenance <- "herite_objet_source"; confidence <- "eleve"
      evidence <- c(evidence, paste("CRS de l'objet source", src$evidence))
    } else if (!is.na(side$crs)) {
      candidate <- side$crs; provenance <- "documente_fichier_prj"; confidence <- "eleve"
      evidence <- c(evidence, paste("fichier", side$file))
    } else if (!is.na(doc_crs)) {
      candidate <- doc_crs; provenance <- "documente_aide_package"; confidence <- "eleve"
      evidence <- c(evidence, "CRS explicite dans l'aide R")
    } else if (compatible_lonlat_bbox(bb) && (docs_lonlat || semantic_lonlat)) {
      candidate <- "EPSG:4326"; provenance <- "infere_coordonnees_et_documentation"
      confidence <- "moyen"; evidence <- c(evidence, "bbox compatible et semantique lon/lat")
    } else if (compatible_lonlat_bbox(bb)) {
      provenance <- "inference_bbox_seule_refusee"; confidence <- "faible"
      evidence <- c(evidence, "bbox compatible lon/lat mais preuve insuffisante")
    } else {
      evidence <- c(evidence, "coordonnees probablement projetees/locales sans definition")
    }
    check <- validate_candidate(x, candidate)
    crs_rows[[j]] <- data.frame(
      record_id = ix$record_id, package = ix$package, dataset = ix$dataset,
      famille_geometrie = ix$famille_geometrie,
      xmin = unname(bb[["xmin"]]), ymin = unname(bb[["ymin"]]),
      xmax = unname(bb[["xmax"]]), ymax = unname(bb[["ymax"]]),
      bbox_compatible_lonlat = compatible_lonlat_bbox(bb),
      crs_candidat = candidate, provenance = provenance, confiance = confidence,
      transformation_4326_plausible = check$ok, bbox_4326 = check$bbox_4326,
      preuve = compact_text(evidence), documentation = compact_text(docs),
      sf_path = ix$sf_path, stringsAsFactors = FALSE
    )
    cat(sprintf("[CRS %d/%d] %s::%s -> %s (%s)\n", j, length(missing_idx),
                ix$package, ix$dataset, candidate %||% "NA", confidence))
  }
  audit_crs <- do.call(rbind, crs_rows)

  # Revue manuelle des propositions moyennes. Une bbox compatible ne suffit
  # pas : certains jeux utilisent des coordonnees de parcelle ou une longitude
  # ouest stockee positive.
  revise_crs <- function(record_id, candidate, provenance, confiance, preuve) {
    z <- which(audit_crs$record_id == record_id)
    if (!length(z)) return(invisible(NULL))
    audit_crs$crs_candidat[z] <<- candidate
    audit_crs$provenance[z] <<- provenance
    audit_crs$confiance[z] <<- confiance
    audit_crs$preuve[z] <<- compact_text(c(audit_crs$preuve[z], preuve))
    check <- validate_candidate(readRDS(file.path(repo_root, audit_crs$sf_path[z])), candidate)
    audit_crs$transformation_4326_plausible[z] <<- check$ok
    audit_crs$bbox_4326[z] <<- check$bbox_4326
  }
  revise_crs("R::gstat::jura::prediction.dat", NA_character_,
             "systeme_coordonnees_local_sans_epsg", "inconnu",
             "l'aide distingue explicitement coordonnees locales et geographiques")
  revise_crs("R::gstat::jura::validation.dat", NA_character_,
             "systeme_coordonnees_local_sans_epsg", "inconnu",
             "l'aide distingue explicitement coordonnees locales et geographiques")
  revise_crs("R::agridat::ortiz.tomato.covs::ortiz.tomato.covs", NA_character_,
             "rejet_inference_spatiale", "rejete",
             "Day est un cumul de degres-jours; les axes detectes ne sont pas lon/lat")
  revise_crs("R::agridat::usgs.herbicides::usgs.herbicides", NA_character_,
             "coordonnees_a_corriger", "revue",
             "la longitude ouest est stockee positive; elle doit etre negatee avant EPSG:4326")

  time_idx <- which(index_sf$utilisable == "TRUE" & index_sf$a_variable_T == "TRUE")
  time_rows <- vector("list", length(time_idx))
  for (j in seq_along(time_idx)) {
    i <- time_idx[j]
    ix <- index_sf[i, , drop = FALSE]
    row <- catalog[catalog_by_id[i], , drop = FALSE]
    x <- readRDS(file.path(repo_root, ix$sf_path))
    declared <- split_fields(row$datetime_columns)
    matched <- names(x)[vapply(names(x), function(nm) {
      if (nm == "T" || inherits(x[[nm]], "sfc") || length(x[[nm]]) != length(x$T)) return(FALSE)
      all((is.na(x[[nm]]) & is.na(x$T)) |
            (!is.na(x[[nm]]) & !is.na(x$T) & as.character(x[[nm]]) == as.character(x$T)))
    }, logical(1))]
    semantic <- any(is_temporal_name(c(declared, matched))) || inherits(x$T, c("Date", "POSIXt"))
    wide_rounds <- any(grepl("^I_", names(x))) && any(grepl("^II_", names(x)))
    verdict <- if (semantic) "confirme" else if (wide_rounds) "faux_positif_T_structure_large" else "faux_positif"
    time_rows[[j]] <- data.frame(
      record_id = ix$record_id, package = ix$package, dataset = ix$dataset,
      datetime_columns_catalogue = paste(declared, collapse = ", "),
      T_identique_a = paste(matched, collapse = ", "),
      classe_T = paste(class(x$T), collapse = ","),
      n_valeurs_T = length(unique(x$T)), structure_tours_large = wide_rounds,
      verdict_temporel = verdict, sf_path = ix$sf_path, stringsAsFactors = FALSE
    )
    cat(sprintf("[TEMPS %d/%d] %s::%s -> %s\n", j, length(time_idx),
                ix$package, ix$dataset, verdict))
  }
  audit_time <- do.call(rbind, time_rows)
  audit_time$verdict_temporel[
    audit_time$record_id == "R::agridat::ortiz.tomato.covs::ortiz.tomato.covs"
  ] <- "faux_positif_degres_jours"
  audit_time$verdict_temporel[
    audit_time$record_id == "Python::libpysal::SanFran Crime"
  ] <- "confirme_T_a_reconstruire"

  synthese_audit_metadata <- list(
    crs = list(total = nrow(audit_crs), par_confiance = table(audit_crs$confiance),
               par_provenance = table(audit_crs$provenance),
               transformables = table(audit_crs$transformation_4326_plausible, useNA = "ifany")),
    temps = list(total = nrow(audit_time), par_verdict = table(audit_time$verdict_temporel))
  )
  output_path <- file.path(sf_dir, "catalogue_sf_metadata_audit.RData")
  save_rdata_atomic(c("audit_crs", "audit_time", "synthese_audit_metadata"),
                    environment(), output_path, compress = TRUE)
  cat("\n=== Audit CRS ===\n"); print(synthese_audit_metadata$crs)
  cat("\n=== Audit temporel ===\n"); print(synthese_audit_metadata$temps)
  cat("\nSortie :", output_path, "\n")
  invisible(list(crs = audit_crs, time = audit_time,
                 summary = synthese_audit_metadata))
}

if (sys.nframe() == 0L) audit_sf_metadata()
