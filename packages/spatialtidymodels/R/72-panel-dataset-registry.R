# Registre et chargement des jeux de panel spatial, tel qu'expose par les
# fiches (data_structure: spatial_panel). Miroir de benchmark_spatial_dataset()
# / load_benchmark_dataset() (benchmark-datasets.R) pour le harnais panel --
# deux registres separes, jamais l'un ne route vers l'autre (voir le garde-fou
# dans get_benchmark_dataset_spec()). J5 de
# wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md.

#' List registered spatial panel datasets
#'
#' Distinct from [available_benchmark_datasets()] : ce registre n'est PAS
#' filtre a `benchmark_ready == TRUE`. Un jeu de panel peut etre traçable de
#' bout en bout (fiche -> donnees -> W -> resultat) tout en restant
#' conditionnel (`package_include: "no"`) faute de provenance de W/unites
#' prouvee -- consultez la colonne `package_include` du resultat avant de
#' considerer un jeu comme valide pour une replication revendiquee.
#'
#' @return A data frame, or a zero-row data frame if no panel dataset is registered.
#' @export
available_panel_datasets <- function() {
  registry <- metadata_panel_dataset_registry()
  if (is.null(registry)) {
    return(data.frame(
      dataset = character(), rds = character(), panel_unit = character(),
      panel_time = character(), package_include = character(), stringsAsFactors = FALSE
    ))
  }
  registry
}

get_panel_dataset_spec <- function(dataset) {
  registry <- available_panel_datasets()
  if (length(dataset) != 1L || !dataset %in% registry$dataset) {
    stop(sprintf(
      "Jeu de panel inconnu: %s. Utilisez available_panel_datasets() pour la liste.",
      paste(dataset, collapse = ", ")
    ), call. = FALSE)
  }
  registry[registry$dataset == dataset, , drop = FALSE]
}

#' Load a registered spatial panel dataset (data, spec, W, formula)
#'
#' @param dataset Dataset id, as listed by [available_panel_datasets()].
#' @param data_dir Optional override for resolving relative paths (RDS, W)
#'   when not run from the repository root.
#'
#' @return A list with `data` (geometry dropped), `panel` (a
#'   `spatial_panel_spec`), `W` (matrix, or `NULL` if no `w_file` is
#'   declared), `formula`, and `spec` (the raw registry row).
#' @export
load_benchmark_panel_dataset <- function(dataset, data_dir = NULL) {
  spec <- get_panel_dataset_spec(dataset)

  rds_path <- resolve_benchmark_data_path(spec$rds[[1]], data_dir = data_dir)
  raw <- readRDS(rds_path)
  data <- if (inherits(raw, "sf")) sf::st_drop_geometry(raw) else raw

  panel <- spatial_panel_spec(
    unit = spec$panel_unit[[1]],
    time = spec$panel_time[[1]],
    effect = spec$panel_effect[[1]] %||% "individual",
    balance = spec$panel_balance[[1]] %||% "balanced",
    prediction_target = spec$prediction_target[[1]] %||% "fit_only"
  )

  W <- NULL
  w_file <- spec$w_file[[1]]
  if (!is.na(w_file) && nzchar(w_file)) {
    w_path <- resolve_benchmark_data_path(w_file, data_dir = data_dir)
    w_raw <- readRDS(w_path)
    # Convention de ce registre : un fichier W panel est une liste documentee
    # (voir code/r_catalog/build_li_energy_panel_W.R) avec au moins un element
    # $W, jamais une matrice/listw nue directement -- distinct de
    # spatial_weights_file (registre transversal), qui attend l'inverse. Les
    # deux registres ne partagent pas ce champ pour cette raison.
    W <- if (is.list(w_raw) && !is.null(w_raw$W)) w_raw$W else w_raw
  }

  if (is.na(spec$formula[[1]]) || !nzchar(spec$formula[[1]])) {
    stop(sprintf("Aucune formula utilisable pour le jeu de panel %s.", dataset), call. = FALSE)
  }
  formula <- stats::as.formula(spec$formula[[1]])

  list(data = data, panel = panel, W = W, formula = formula, spec = spec)
}

#' Run spatial panel estimators on a registered dataset, by name
#'
#' Single traceable call from a dataset id to a `spatial_panel_benchmark`
#' result, mirroring [benchmark_spatial_dataset()] for the cross-sectional
#' registry. Never available for a dataset whose fiche does not declare
#' `data_structure: spatial_panel` -- see [get_benchmark_dataset_spec()]'s
#' guard for the reverse direction.
#'
#' @param dataset Dataset id, as listed by [available_panel_datasets()].
#' @param data_dir Optional override, passed to [load_benchmark_panel_dataset()].
#' @param ... Passed to [benchmark_spatial_panel()] (`estimators`,
#'   `model_type`, `cv_scheme`, `h`, `initial`, `assess`, `skip`).
#'
#' @return A `spatial_panel_benchmark` object.
#' @export
benchmark_spatial_panel_dataset <- function(dataset, data_dir = NULL, ...) {
  loaded <- load_benchmark_panel_dataset(dataset, data_dir = data_dir)
  benchmark_spatial_panel(loaded$formula, loaded$data, loaded$panel, W = loaded$W, ...)
}
