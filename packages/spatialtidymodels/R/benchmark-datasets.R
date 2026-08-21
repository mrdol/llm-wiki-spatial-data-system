# Registre package des datasets de benchmark.
#
# Ce fichier evite de forcer l'utilisateur a recopier les formules depuis les
# fiches Markdown. Les entrees sont volontairement explicites et testables.

fallback_benchmark_dataset_registry <- function() {
  data.frame(
    dataset = c(
      "georgia", "columbus_crime", "london_hp", "boston_housing",
      "dub_voter", "ewhp", "lasrosas"
    ),
    data_object = c(
      "georgia", "columbus_crime", "london_hp", "boston_housing",
      "dub_voter", "ewhp", "lasrosas"
    ),
    rds = c(
      "data/final_datasets/sf/Python_libpysal_georgia.rds",
      "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds",
      "data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds",
      "data/final_datasets/sf/Python_geodatasets_spdata.boston.rds",
      "data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds",
      "data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds",
      "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_1999.rds"
    ),
    formula = c(
      "PctBach ~ PctRural + PctFB + PctBlack + PctEld",
      "CRIME ~ HOVAL + INC",
      "PURCHASE ~ FLOORSZ + PROF + BATH2",
      paste(
        "CMEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD +",
        "TAX + PTRATIO + B + LSTAT"
      ),
      paste(
        "GenEl2004 ~ DiffAdd + LARent + SC1 + Unempl + LowEduc +",
        "Age18_24 + Age25_44 + Age45_64"
      ),
      paste(
        "PurPrice ~ BldIntWr + BldPostW + Bld60s + Bld70s + Bld80s +",
        "TypDetch + TypSemiD + TypFlat + FlrArea"
      ),
      "yield ~ nitro + I(nitro^2) + topo + nitro:topo + I(nitro^2):topo"
    ),
    response = c("PctBach", "CRIME", "PURCHASE", "CMEDV", "GenEl2004", "PurPrice", "yield"),
    predictors = I(list(
      c("PctRural", "PctFB", "PctBlack", "PctEld"),
      c("HOVAL", "INC"),
      c("FLOORSZ", "PROF", "BATH2"),
      c("CRIM", "ZN", "INDUS", "CHAS", "NOX", "RM", "AGE", "DIS",
        "RAD", "TAX", "PTRATIO", "B", "LSTAT"),
      c("DiffAdd", "LARent", "SC1", "Unempl", "LowEduc",
        "Age18_24", "Age25_44", "Age45_64"),
      c("BldIntWr", "BldPostW", "Bld60s", "Bld70s", "Bld80s",
        "TypDetch", "TypSemiD", "TypFlat", "FlrArea"),
      c("nitro", "topo")
    )),
    coords = I(rep(list(c("X", "Y")), 7L)),
    coords_crs = c(
      "EPSG:26916", "EPSG:32617", "EPSG:27700", "EPSG:32619",
      "EPSG:2157", "EPSG:27700", "EPSG:32720"
    ),
    coords_source = c(
      "prepared projected coordinates",
      "prepared projected coordinates",
      "native projected coordinates",
      "prepared projected coordinates",
      "native projected coordinates",
      "native projected coordinates",
      "prepared projected coordinates"
    ),
    recommended_cv = I(list(
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial"),
      c("holdout_10pct", "near_prediction", "block_spatial")
    )),
    mode = rep("regression", 7L),
    formula_status = c("pub", "pub", "used", "pub", "pub", "used", "pub"),
    source_ref = c(
      "Georgia education example, libpysal/GWmodel",
      "spData Columbus / Anselin spatial econometrics examples",
      "Lu, Charlton, Harris & Fotheringham (2014), IJGIS",
      "Boston housing hedonic model",
      "GWmodel DubVoter documentation",
      "GWmodel EWHP documentation / project formula",
      "Anselin, Bongiovanni and Lowenberg-DeBoer (2004), Las Rosas 1999"
    ),
    notes = c(
      "Petit dataset de reference pour tests rapides.",
      "Exemple classique SAR/SEM: CRIME ~ HOVAL + INC.",
      "Formule hedonique confirmee et cible continue.",
      "Grand classique hedonique; SDM peut exposer des alias sur CHAS.",
      "Exemple electoral GWR.",
      "Attention aux dummies de type logement; formule projet sans TYPEFLAT.",
      "Coupe 1999 de 1 738 cellules; formule publiee et erreur spatiale documentee."
    ),
    stringsAsFactors = FALSE
  )
}

benchmark_dataset_registry <- function() {
  metadata <- metadata_dataset_registry()
  out <- if (!is.null(metadata)) metadata else fallback_benchmark_dataset_registry()
  if (!"eligible_estimators" %in% names(out)) {
    out$eligible_estimators <- I(rep(list(character()), nrow(out)))
  }
  if (!"benchmark_estimators" %in% names(out)) {
    out$benchmark_estimators <- out$eligible_estimators
  }
  if (!"estimator_evidence" %in% names(out)) {
    out$estimator_evidence <- I(rep(list(data.frame()), nrow(out)))
  }
  for (field in c("eligibility_basis", "eligibility_source_ref", "eligibility_notes")) {
    if (!field %in% names(out)) out[[field]] <- NA_character_
  }
  for (field in c(
    "topic", "observation_unit", "observed_population", "geographic_context",
    "temporal_context", "source_description", "description_source",
    "description_confidence"
  )) {
    if (!field %in% names(out)) out[[field]] <- NA_character_
  }
  for (field in c(
    "formula_pub", "formula_used", "formula_default_role",
    "formula_paper_main_specification", "formula_ml_or_selected"
  )) {
    if (!field %in% names(out)) out[[field]] <- NA_character_
  }
  if (!"formula_roles" %in% names(out)) {
    out$formula_roles <- I(rep(list("default"), nrow(out)))
  }
  # Distribution architecture / dataset-size fields: only present when
  # metadata_dataset_registry() supplied them (see R/metadata-registry.R).
  # The legacy fallback_benchmark_dataset_registry() predates all of these,
  # so without this guard the columns would be entirely absent (not just NA)
  # whenever the JSON registry is unavailable -- a caller like
  # dashboard_task_source_counts() or build_suite_dataset_metadata() reading
  # `registry$source_dataset_id` would silently get NULL instead of a
  # per-row NA.
  if (!"source_dataset_id" %in% names(out)) out$source_dataset_id <- out$dataset
  if (!"benchmark_task_id" %in% names(out)) out$benchmark_task_id <- out$dataset
  if (!"parent_dataset" %in% names(out)) out$parent_dataset <- NA_character_
  if (!"bundled" %in% names(out)) out$bundled <- NA
  if (!"storage" %in% names(out)) out$storage <- NA_character_
  if (!"benchmark_suite" %in% names(out)) out$benchmark_suite <- I(rep(list(character()), nrow(out)))
  if (!"n_observations" %in% names(out)) out$n_observations <- NA_integer_
  if (!"t_periods" %in% names(out)) out$t_periods <- NA_integer_
  if (!"benchmark_ready" %in% names(out)) out$benchmark_ready <- TRUE
  if (!"license_name" %in% names(out)) out$license_name <- NA_character_
  if (!"download_url" %in% names(out)) out$download_url <- NA_character_
  if (!"checksum_sha256" %in% names(out)) out$checksum_sha256 <- NA_character_
  if (!"redistribution_allowed" %in% names(out)) out$redistribution_allowed <- NA
  if (!"license_verified" %in% names(out)) out$license_verified <- FALSE
  if (!"size_bytes" %in% names(out)) out$size_bytes <- NA_real_
  out
}

first_available_formula <- function(...) {
  values <- list(...)
  for (value in values) {
    if (!is.null(value) && length(value) > 0L && !is.na(value[[1L]]) && nzchar(value[[1L]]) && !identical(value[[1L]], "pending")) {
      return(value[[1L]])
    }
  }
  NA_character_
}

select_benchmark_dataset_formula <- function(spec, formula_role = "default") {
  role <- formula_role %||% "default"
  if (length(role) != 1L || is.na(role) || !nzchar(role)) role <- "default"
  value <- switch(role,
    default = spec$formula[[1]],
    package_default = spec$formula[[1]],
    paper_main_specification = first_available_formula(spec$formula_paper_main_specification[[1]], spec$formula_pub[[1]]),
    multivariate_constrained = first_available_formula(spec$formula_paper_main_specification[[1]], spec$formula_pub[[1]]),
    ml_or_selected = first_available_formula(spec$formula_ml_or_selected[[1]], spec$formula[[1]]),
    stop(
      sprintf(
        "Unknown formula_role for dataset %s: %s",
        spec$dataset[[1]], role
      ),
      call. = FALSE
    )
  )
  if (is.null(value) || is.na(value) || !nzchar(value) || identical(value, "pending")) {
    stop(
      sprintf(
        "Formula role '%s' is not available for dataset %s.",
        role, spec$dataset[[1]]
      ),
      call. = FALSE
    )
  }
  vars <- all.vars(stats::as.formula(value))
  list(
    role = role,
    formula = value,
    response = vars[[1L]],
    predictors = vars[-1L]
  )
}

find_benchmark_repo_root <- function(start = getwd()) {
  # Le package peut etre utilise depuis le repo, depuis le dossier code, ou
  # apres installation locale. On remonte jusqu'au premier dossier contenant les
  # donnees finales attendues.
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  marker <- "data/final_datasets/sf"
  for (i in seq_len(10L)) {
    if (dir.exists(file.path(current, marker))) return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  NA_character_
}

resolve_benchmark_data_path <- function(path, data_dir = NULL) {
  # `data_dir` permet a l'utilisateur de pointer explicitement vers le repo ou
  # vers un dossier de donnees. Sinon on tente une resolution depuis getwd().
  if (file.exists(path)) return(normalizePath(path, winslash = "/", mustWork = TRUE))
  if (!is.null(data_dir)) {
    candidate <- file.path(data_dir, path)
    if (file.exists(candidate)) return(normalizePath(candidate, winslash = "/", mustWork = TRUE))
    candidate <- file.path(data_dir, basename(path))
    if (file.exists(candidate)) return(normalizePath(candidate, winslash = "/", mustWork = TRUE))
  }
  root <- find_benchmark_repo_root()
  if (!is.na(root)) {
    candidate <- file.path(root, path)
    if (file.exists(candidate)) return(normalizePath(candidate, winslash = "/", mustWork = TRUE))
  }
  stop(sprintf("Fichier dataset introuvable: %s. Fournissez `data_dir` si vous n'etes pas dans le repo.", path), call. = FALSE)
}

load_packaged_benchmark_data <- function(object) {
  # Charge un objet embarque dans packages/spatialtidymodels/data. Cela rend le
  # benchmark utilisable apres install_local(), sans pointer vers le repo source.
  env <- new.env(parent = emptyenv())
  loaded <- utils::data(list = object, package = "spatialtidymodels", envir = env)
  if (!identical(loaded, object) || !exists(object, envir = env, inherits = FALSE)) {
    return(NULL)
  }
  get(object, envir = env, inherits = FALSE)
}

coerce_numeric_like_columns <- function(data) {
  # Certains datasets empaquetes conservent des indicatrices 0/1 comme chaines.
  # Les backends mgwrsar travaillent mieux avec une matrice de variables
  # numeriques stable entre fit et predict.
  as.data.frame(lapply(data, function(x) {
    if (!is.character(x)) return(x)
    values <- stats::na.omit(x)
    if (length(values) == 0L) return(x)
    numeric_values <- suppressWarnings(as.numeric(values))
    if (all(!is.na(numeric_values))) return(suppressWarnings(as.numeric(x)))
    x
  }), stringsAsFactors = FALSE)
}

derive_benchmark_coords <- function(data, coords) {
  if (length(coords) >= 2L) return(list(data = data, coords = coords))
  if (!inherits(data, "sf") || !requireNamespace("sf", quietly = TRUE)) {
    return(list(data = data, coords = coords))
  }
  centroids <- suppressWarnings(sf::st_centroid(sf::st_geometry(data)))
  xy <- sf::st_coordinates(centroids)
  if (nrow(xy) != nrow(data) || ncol(xy) < 2L) {
    return(list(data = data, coords = coords))
  }
  data$coord_x <- xy[, 1L]
  data$coord_y <- xy[, 2L]
  list(data = data, coords = c("coord_x", "coord_y"))
}

#' List registered benchmark datasets
#'
#' Returns continuous-regression datasets for which the package knows the
#' prepared `.rds` path, formula, coordinate columns, coordinate CRS, formula
#' status, scientific source, and recommended evaluation schemes.
#'
#' @return A data frame.
#' @export
available_benchmark_datasets <- function() {
  benchmark_dataset_registry()
}

get_benchmark_dataset_spec <- function(dataset) {
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
  registry[registry$dataset == dataset, , drop = FALSE]
}

load_benchmark_dataset <- function(dataset, data_dir = NULL, formula_role = "default") {
  # Charge le .rds, conserve uniquement Y/X/coords, puis applique complete.cases
  # sur les colonnes utiles au modele.
  spec <- get_benchmark_dataset_spec(dataset)
  object_name <- spec$data_object[[1]]
  packaged <- if (
    is.null(data_dir) && !is.na(object_name) && nzchar(object_name)
  ) load_packaged_benchmark_data(object_name) else NULL
  if (!is.null(packaged)) {
    raw_data <- packaged
    path <- sprintf("package:spatialtidymodels/data/%s", spec$data_object[[1]])
  } else {
    path <- resolve_benchmark_data_path(spec$rds[[1]], data_dir = data_dir)
    raw_data <- readRDS(path)
  }
  selected_formula <- select_benchmark_dataset_formula(spec, formula_role = formula_role)
  predictors <- selected_formula$predictors
  coords <- unlist(spec$coords[[1]], use.names = FALSE)
  spatial_input <- derive_benchmark_coords(raw_data, coords)
  dat <- as.data.frame(spatial_input$data)
  coords <- spatial_input$coords
  needed <- unique(c(selected_formula$response, predictors, coords))
  missing <- setdiff(needed, names(dat))
  if (length(missing) > 0L) {
    stop(sprintf("Colonnes absentes du dataset %s: %s", dataset, paste(missing, collapse = ", ")), call. = FALSE)
  }
  dat <- coerce_numeric_like_columns(dat[, needed, drop = FALSE])
  dat <- dat[stats::complete.cases(dat[, needed, drop = FALSE]), , drop = FALSE]
  list(
    data = dat,
    formula = stats::as.formula(selected_formula$formula),
    formula_role = selected_formula$role,
    coords = coords,
    spec = spec,
    path = path
  )
}

recommended_benchmark_tuning_grids <- function(dataset, estimators, data) {
  # Grilles courtes inspirees des fiches dataset. Elles servent a reduire
  # l'appel utilisateur pour les routes complexes, pas a remplacer un protocole
  # scientifique complet.
  spec <- get_benchmark_dataset_spec(dataset)
  predictors <- unlist(spec$predictors[[1]], use.names = FALSE)
  n <- nrow(data)
  k_values <- unique(pmin(if (n > 1500L) c(8L) else c(4L, 8L), max(2L, n - 1L)))
  h_values <- unique(pmin(if (n > 1500L) c(20L) else c(8L, 12L), max(3L, n - 1L)))
  numeric_predictors <- predictors[vapply(data[predictors], is.numeric, logical(1))]
  fixed_candidates <- if (length(numeric_predictors) >= 2L) {
    unique(c(numeric_predictors[[1L]], numeric_predictors[[length(numeric_predictors)]]))
  } else {
    numeric_predictors
  }
  out <- list()
  for (estimator in estimators) {
    if (estimator %in% c("MGWRSAR_0_kc_kv", "MGWRSAR_1_kc_kv")) {
      grid <- expand.grid(
        bandwidth = h_values,
        kernel = "gauss",
        k_neighbors = k_values,
        fixed_vars = fixed_candidates,
        KEEP.OUT.ATTRS = FALSE,
        stringsAsFactors = FALSE
      )
      out[[estimator]] <- grid
    }
  }
  if (length(out) == 0L) NULL else out
}

#' Run a benchmark from a registered dataset
#'
#' Loads a dataset registered in `available_benchmark_datasets()`, retrieves its
#' formula and coordinate columns, applies `complete.cases()` on the required
#' model columns, then calls `benchmark_spatial()`.
#'
#' @param dataset Registered dataset name.
#' @param estimators Estimators to run. With `NULL` (the default), uses the
#'   documented package routes and curated technical comparators for this
#'   dataset; explicitly supplied names always take precedence.
#' @param data_dir Optional repository directory, or directory containing the
#'   prepared `.rds` files.
#' @param use_recommended_grids If `TRUE`, fill missing tuning grids from the
#'   dataset registry for complex estimators such as native mixed MGWRSAR.
#' @param formula_role Formula role to use when the dataset exposes several
#'   candidate formulas. Use `"default"` or `"package_default"` for the
#'   package benchmark formula, `"paper_main_specification"` or
#'   `"multivariate_constrained"` for the main published formula, and
#'   `"ml_or_selected"` for the ML-oriented candidate when available.
#' @param ... Arguments passed to `benchmark_spatial()`, such as
#'   `cv_scheme = "near_prediction"`, `tune = TRUE`, or `tuning_grids = ...`.
#'
#' @return A `spatial_benchmark` object.
#' @export
benchmark_spatial_dataset <- function(dataset,
                                      estimators = NULL,
                                      data_dir = NULL,
                                      use_recommended_grids = TRUE,
                                      formula_role = "default",
                                      ...) {
  loaded <- load_benchmark_dataset(dataset, data_dir = data_dir, formula_role = formula_role)
  if (is.null(estimators)) {
    estimators <- unique(eligible_estimators_for_dataset(
      dataset,
      include_installed = FALSE,
      evidence = "all"
    )$estimator)
    if (length(estimators) == 0L) {
      stop(
        sprintf("No executable estimator is recorded for dataset %s. Supply `estimators` explicitly after reviewing its metadata.", dataset),
        call. = FALSE
      )
    }
  }
  dots <- list(...)
  if (isTRUE(dots$tune %||% FALSE) && isTRUE(use_recommended_grids)) {
    recommended <- recommended_benchmark_tuning_grids(dataset, estimators, loaded$data)
    if (!is.null(recommended)) {
      dots$tuning_grids <- utils::modifyList(recommended, dots$tuning_grids %||% list())
    }
  }
  bench <- do.call(
    benchmark_spatial,
    c(
      list(
        formula = loaded$formula,
        data = loaded$data,
        coords = loaded$coords,
        estimators = estimators
      ),
      dots
    )
  )
  bench$dataset <- dataset
  bench$dataset_spec <- loaded$spec
  bench$formula_role <- loaded$formula_role
  bench$data_path <- loaded$path
  bench
}

#' Run benchmarks on several registered datasets
#'
#' @param datasets Registered dataset names.
#' @inheritParams benchmark_spatial_dataset
#'
#' @return A `spatial_benchmark_set` object.
#' @export
benchmark_spatial_registered_datasets <- function(datasets,
                                                  estimators = NULL,
                                                  data_dir = NULL,
                                                  formula_role = "default",
                                                  ...) {
  if (is.null(estimators)) {
    per_dataset <- lapply(datasets, function(dataset) unique(
      eligible_estimators_for_dataset(dataset, include_installed = FALSE, evidence = "all")$estimator
    ))
    estimators <- Reduce(intersect, per_dataset)
    if (length(estimators) == 0L) {
      stop(
        "The registered datasets have no shared executable estimator. Supply `estimators` explicitly or benchmark datasets separately.",
        call. = FALSE
      )
    }
  }
  specs <- lapply(datasets, function(dataset) {
    loaded <- load_benchmark_dataset(dataset, data_dir = data_dir, formula_role = formula_role)
    spatial_dataset_spec(dataset, loaded$data, loaded$formula, loaded$coords)
  })
  names(specs) <- datasets
  benchmark_spatial_datasets(specs, estimators = estimators, ...)
}
