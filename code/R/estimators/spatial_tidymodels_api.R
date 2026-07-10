# API utilisateur pour le pipeline spatial tidymodels.
#
# Objectif: fournir un point d'entree stable et non "manuel" au travail
# d'integration des estimateurs spatiaux. Le script historique
# benchmark_manual_test_2026-07.R reste le moteur d'orchestration, mais les
# utilisateurs peuvent maintenant appeler des fonctions nommees explicitement.

# On recharge toujours le script moteur pour eviter les objets R obsoletes dans
# une session interactive. Sans cela, si run_manual_test() existait deja,
# DATASETS pouvait rester bloque sur une ancienne version du registre.
source("R/estimators/benchmark_manual_test_2026-07.R")

# ---------------------------------------------------------------------------
# Inventaire des datasets et estimateurs disponibles
# ---------------------------------------------------------------------------

list_available_datasets <- function(details = TRUE) {
  # Retourne les jeux de donnees declares dans DATASETS. En mode details=TRUE,
  # la table indique aussi la variable reponse, les covariables et le fichier
  # RDS source afin qu'un utilisateur sache quoi lancer.
  if (!exists("DATASETS", inherits = TRUE)) {
    stop("DATASETS introuvable: source('R/estimators/spatial_tidymodels_api.R') depuis code.", call. = FALSE)
  }

  dataset_names <- names(DATASETS)
  if (isFALSE(details)) return(dataset_names)

  do.call(rbind, lapply(dataset_names, function(name) {
    spec <- DATASETS[[name]]
    data.frame(
      dataset = name,
      response = spec$y,
      predictors = paste(spec$x, collapse = ", "),
      rds = spec$rds,
      near_n_reps = spec$near_n_reps,
      near_test_size = spec$near_test_size,
      stringsAsFactors = FALSE
    )
  }))
}

list_available_estimators <- function(details = TRUE) {
  # Construit la liste depuis build_specs(), qui est la source de verite du
  # pipeline. Les noms retournes sont ceux a utiliser dans estimators = c(...).
  if (!exists("build_specs", mode = "function")) {
    stop("build_specs() introuvable: source('R/estimators/spatial_tidymodels_api.R') depuis code.", call. = FALSE)
  }

  specs <- build_specs("y", c("x1", "x2"))
  estimator_names <- names(specs)
  if (isFALSE(details)) return(estimator_names)

  data.frame(
    estimator = estimator_names,
    tidymodels_route = vapply(specs, function(entry) {
      if (!is.null(entry$score)) {
        "scoring_direct"
      } else if (isFALSE(entry$use_workflow)) {
        "parsnip_fit_direct"
      } else {
        "workflow"
      }
    }, character(1)),
    has_parsnip_spec = vapply(specs, function(entry) !is.null(entry$spec), logical(1)),
    has_formula = vapply(specs, function(entry) !is.null(entry$formula), logical(1)),
    stringsAsFactors = FALSE
  )
}

# ---------------------------------------------------------------------------
# Lancement du pipeline
# ---------------------------------------------------------------------------

run_spatial_benchmark <- function(datasets = "georgia", estimators = NULL) {
  # Fonction publique cible. Elle garde la compatibilite avec run_manual_test()
  # tout en exposant un nom qui decrit la mission: benchmark spatial au format
  # tidymodels quand l'estimateur le permet.
  available_datasets <- list_available_datasets(details = FALSE)
  missing_datasets <- setdiff(datasets, available_datasets)
  if (length(missing_datasets) > 0) {
    stop(sprintf(
      "Dataset(s) inconnu(s): %s. Datasets disponibles: %s",
      paste(missing_datasets, collapse = ", "),
      paste(available_datasets, collapse = ", ")
    ), call. = FALSE)
  }

  available_estimators <- list_available_estimators(details = FALSE)
  selected_estimators <- validate_estimators(estimators, available_estimators)

  run_manual_test(which = datasets, estimators = selected_estimators)
}

run_spatial_smoke_test <- function(dataset = "georgia") {
  # Test court pour verifier que l'API, workflow(), prediction et sauvegarde
  # RDS fonctionnent sans lancer tous les estimateurs couteux.
  run_spatial_benchmark(
    datasets = dataset,
    estimators = c("glm", "earth", "random_forest", "spboost", "mgwrsar_gwr")
  )
}
