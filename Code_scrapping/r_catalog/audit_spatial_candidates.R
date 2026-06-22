# Audit final des seuls "Bons candidats spatial" du catalogue combine.
# Aucun dataset n'est converti ici : le script qualifie les preuves necessaires
# au futur pipeline sf et conserve les cas incertains pour revue.

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (basename(current) == "llm-wiki-karpathy") return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Racine llm-wiki-karpathy introuvable.", call. = FALSE)
}

split_fields <- function(x) {
  x <- as.character(x)
  if (is.na(x) || !nzchar(trimws(x))) return(character(0))
  values <- trimws(unlist(strsplit(x, ",", fixed = TRUE)))
  unique(values[nzchar(values)])
}

nonempty <- function(x) {
  !is.na(x) & nzchar(trimws(as.character(x)))
}

save_rdata_atomic <- function(object_names, envir, path, compress = FALSE) {
  temporary <- file.path(
    tempdir(),
    paste0(basename(path), ".tmp-", Sys.getpid())
  )
  on.exit(unlink(temporary, force = TRUE), add = TRUE)
  save(list = object_names, envir = envir, file = temporary, compress = compress)
  if (!file.copy(temporary, path, overwrite = TRUE)) {
    stop("Impossible de remplacer le fichier RData : ", path, call. = FALSE)
  }
  invisible(path)
}

audit_spatial_candidates <- function(repo_root = find_repo_root(), write_output = FALSE) {
  manifest_dir <- file.path(repo_root, "data", "manifests", "datasets")
  combined_path <- file.path(manifest_dir, "software_catalog_combined.RData")
  if (!file.exists(combined_path)) {
    stop("Catalogue combine absent : ", combined_path, call. = FALSE)
  }

  env <- new.env(parent = emptyenv())
  load(combined_path, envir = env)
  if (!exists("catalogue_bons_candidats_spatiaux", envir = env, inherits = FALSE)) {
    stop("Objet catalogue_bons_candidats_spatiaux absent.", call. = FALSE)
  }
  catalog <- env$catalogue_bons_candidats_spatiaux

  catalog$covariate_count <- vapply(
    catalog$candidate_x_variables,
    function(x) length(split_fields(x)),
    integer(1)
  )
  catalog$response_count <- vapply(
    catalog$candidate_y_variables,
    function(x) length(split_fields(x)),
    integer(1)
  )
  catalog$coordinate_count <- vapply(
    catalog$coordinate_columns,
    function(x) length(split_fields(x)),
    integer(1)
  )

  has_coordinates <- catalog$has_coordinates == "Yes" &
    catalog$coordinate_count >= 2L
  has_local_spatial_file <- grepl(
    "[.](geojson|gpkg|shp|parquet)(,|$)",
    catalog$local_files,
    ignore.case = TRUE
  )
  has_geometry <- catalog$has_geometry == "Yes" |
    has_local_spatial_file |
    grepl("(^|,\\s*)(geometry|geom|wkt)(\\s*,|$)", catalog$variables, ignore.case = TRUE)
  has_join_key <- catalog$has_place_name_if_no_geometry == "Yes" &
    nonempty(catalog$place_name_columns)

  catalog$spatial_evidence <- ifelse(
    has_coordinates,
    "coordinate_pair",
    ifelse(has_geometry, "geometry_object_or_file", ifelse(
      has_join_key,
      "documented_geographic_join_key",
      "none"
    ))
  )
  catalog$spatial_confidence <- ifelse(
    has_coordinates | has_geometry,
    "strong",
    ifelse(has_join_key, "review", "absent")
  )
  catalog$formula_evidence <- ifelse(
    nonempty(catalog$formula_text) |
      nonempty(catalog$paper_formula_or_equation),
    "Yes",
    "No"
  )
  catalog$scientific_paper_evidence <- ifelse(
    catalog$has_referenced_paper == "Yes" |
      nonempty(catalog$paper_doi) |
      nonempty(catalog$paper_title),
    "Yes",
    "No"
  )

  n_valid <- is.na(catalog$n) | catalog$n >= 10
  has_covariates <- catalog$covariate_count >= 2L
  has_response <- catalog$response_count >= 1L
  has_spatial <- catalog$spatial_evidence != "none"

  catalog$sf_audit_status <- ifelse(
    !has_spatial,
    "fail",
    ifelse(catalog$spatial_confidence == "review", "review", "pass")
  )
  catalog$modeling_evidence_status <- ifelse(
    has_covariates & has_response & n_valid,
    "ready",
    "incomplete"
  )
  catalog$audit_status <- ifelse(
    catalog$sf_audit_status == "fail",
    "fail",
    ifelse(
      catalog$sf_audit_status == "review" |
        catalog$modeling_evidence_status == "incomplete",
      "review",
      "pass"
    )
  )
  catalog$audit_reason <- vapply(seq_len(nrow(catalog)), function(i) {
    reasons <- character(0)
    if (!has_spatial[i]) reasons <- c(reasons, "preuve spatiale absente")
    if (!has_covariates[i]) reasons <- c(reasons, "moins de deux covariables")
    if (!has_response[i]) reasons <- c(reasons, "variable reponse absente")
    if (!n_valid[i]) reasons <- c(reasons, "moins de dix observations")
    if (catalog$spatial_confidence[i] == "review") {
      reasons <- c(reasons, "geometrie a obtenir par jointure")
    }
    if (length(reasons) == 0L) "criteres automatiques satisfaits" else paste(reasons, collapse = "; ")
  }, character(1))
  catalog$sf_conversion_strategy <- ifelse(
    has_coordinates,
    "st_as_sf_from_coordinates",
    ifelse(
      has_geometry,
      "st_as_sf_or_read_spatial_file",
      ifelse(has_join_key, "join_reference_geometry", "not_convertible")
    )
  )

  catalogue_spatial_audite <- catalog
  catalogue_spatial_pass <- catalog[catalog$audit_status == "pass", , drop = FALSE]
  catalogue_spatial_review <- catalog[catalog$audit_status == "review", , drop = FALSE]
  catalogue_spatial_fail <- catalog[catalog$audit_status == "fail", , drop = FALSE]
  catalogue_spatial_sf_eligible <- catalog[
    catalog$sf_audit_status %in% c("pass", "review"),
    , drop = FALSE
  ]
  synthese_audit_spatial <- list(
    total = nrow(catalog),
    par_statut = table(catalog$audit_status),
    aptitude_sf = table(catalog$sf_audit_status),
    preuves_modelisation = table(catalog$modeling_evidence_status),
    par_langage = table(catalog$source_language, catalog$audit_status),
    preuve_spatiale = table(catalog$spatial_evidence),
    formules = table(catalog$formula_evidence),
    papiers_scientifiques = table(catalog$scientific_paper_evidence),
    strategies_sf = table(catalog$sf_conversion_strategy)
  )

  output_path <- file.path(manifest_dir, "software_spatial_candidates_checked.RData")
  if (isTRUE(write_output)) {
    save_rdata_atomic(
      c(
        "catalogue_spatial_audite",
        "catalogue_spatial_pass",
        "catalogue_spatial_review",
        "catalogue_spatial_fail",
        "catalogue_spatial_sf_eligible",
        "synthese_audit_spatial"
      ),
      environment(),
      output_path
    )
  }

  cat("Candidats spatiaux audites :", nrow(catalog), "\n")
  cat("Statuts :\n")
  print(table(catalog$audit_status))
  cat("Preuves spatiales :\n")
  print(table(catalog$spatial_evidence))
  cat("Formule documentee :\n")
  print(table(catalog$formula_evidence))
  cat("Papier scientifique :\n")
  print(table(catalog$scientific_paper_evidence))

  invisible(catalogue_spatial_audite)
}

if (sys.nframe() == 0L) {
  audit_spatial_candidates()
}
