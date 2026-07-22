# Registre package des datasets de benchmark.
#
# Ce fichier evite de forcer l'utilisateur a recopier les formules depuis les
# fiches Markdown. Les entrees sont volontairement explicites et testables.

benchmark_dataset_registry <- function() {
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
      "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds"
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
      "yield ~ nitro + bv"
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
      c("nitro", "bv")
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
    formula_status = c("pub", "pub", "used", "pub", "pub", "used", "used"),
    source_ref = c(
      "Georgia education example, libpysal/GWmodel",
      "spData Columbus / Anselin spatial econometrics examples",
      "Lu, Charlton, Harris & Fotheringham (2014), IJGIS",
      "Boston housing hedonic model",
      "GWmodel DubVoter documentation",
      "GWmodel EWHP documentation / project formula",
      "agridat lasrosas.corn project regression formula"
    ),
    notes = c(
      "Petit dataset de reference pour tests rapides.",
      "Exemple classique SAR/SEM: CRIME ~ HOVAL + INC.",
      "Formule hedonique confirmee et cible continue.",
      "Grand classique hedonique; SDM peut exposer des alias sur CHAS.",
      "Exemple electoral GWR.",
      "Attention aux dummies de type logement; formule projet sans TYPEFLAT.",
      "Formule simplifiee continue; dataset plus grand."
    ),
    stringsAsFactors = FALSE
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

load_benchmark_dataset <- function(dataset, data_dir = NULL) {
  # Charge le .rds, conserve uniquement Y/X/coords, puis applique complete.cases
  # sur les colonnes utiles au modele.
  spec <- get_benchmark_dataset_spec(dataset)
  packaged <- if (is.null(data_dir)) load_packaged_benchmark_data(spec$data_object[[1]]) else NULL
  if (!is.null(packaged)) {
    dat <- as.data.frame(packaged)
    path <- sprintf("package:spatialtidymodels/data/%s", spec$data_object[[1]])
  } else {
    path <- resolve_benchmark_data_path(spec$rds[[1]], data_dir = data_dir)
    dat <- as.data.frame(readRDS(path))
  }
  predictors <- unlist(spec$predictors[[1]], use.names = FALSE)
  coords <- unlist(spec$coords[[1]], use.names = FALSE)
  needed <- unique(c(spec$response[[1]], predictors, coords))
  missing <- setdiff(needed, names(dat))
  if (length(missing) > 0L) {
    stop(sprintf("Colonnes absentes du dataset %s: %s", dataset, paste(missing, collapse = ", ")), call. = FALSE)
  }
  dat <- coerce_numeric_like_columns(dat[, needed, drop = FALSE])
  dat <- dat[stats::complete.cases(dat[, needed, drop = FALSE]), , drop = FALSE]
  list(
    data = dat,
    formula = stats::as.formula(spec$formula[[1]]),
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
#' @param estimators Estimators to run.
#' @param data_dir Optional repository directory, or directory containing the
#'   prepared `.rds` files.
#' @param use_recommended_grids If `TRUE`, fill missing tuning grids from the
#'   dataset registry for complex estimators such as native mixed MGWRSAR.
#' @param ... Arguments passed to `benchmark_spatial()`, such as
#'   `cv_scheme = "near_prediction"`, `tune = TRUE`, or `tuning_grids = ...`.
#'
#' @return A `spatial_benchmark` object.
#' @export
benchmark_spatial_dataset <- function(dataset,
                                      estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                                      data_dir = NULL,
                                      use_recommended_grids = TRUE,
                                      ...) {
  loaded <- load_benchmark_dataset(dataset, data_dir = data_dir)
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
                                                  estimators = c("ols", "gam_spatial", "sar_lag", "sem_error", "sdm_mixed"),
                                                  data_dir = NULL,
                                                  ...) {
  specs <- lapply(datasets, function(dataset) {
    loaded <- load_benchmark_dataset(dataset, data_dir = data_dir)
    spatial_dataset_spec(dataset, loaded$data, loaded$formula, loaded$coords)
  })
  names(specs) <- datasets
  benchmark_spatial_datasets(specs, estimators = estimators, ...)
}
