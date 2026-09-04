find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  for (i in seq_len(10L)) {
    if (
      file.exists(file.path(current, "packages/spatialtidymodels/DESCRIPTION")) &&
        dir.exists(file.path(current, "data/final_datasets/sf"))
    ) {
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Impossible de trouver la racine du depot.", call. = FALSE)
}

repo_root <- find_repo_root()
# weights_dir reste sous data/final_datasets/weights : prepare-benchmark-data.R
# (packages/spatialtidymodels/data-raw/) lit les .rds a cet emplacement pour
# construire columbus_crime_listw.rda -- ne pas deplacer.
weights_dir <- file.path(repo_root, "data/final_datasets/weights")
audit_dir <- file.path(repo_root, "extensions_projet_2026-09/matrice_W_originale")
report_dir <- file.path(repo_root, "extensions_projet_2026-09/matrice_W_originale")
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(audit_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(report_dir, recursive = TRUE, showWarnings = FALSE)

columbus_status <- "missing_dependency"
columbus_detail <- "spData ou spdep indisponible dans l'environnement R courant."
columbus_nb_file <- NA_character_
columbus_listw_file <- NA_character_
columbus_cardinality <- NA_character_

if (requireNamespace("spData", quietly = TRUE) && requireNamespace("spdep", quietly = TRUE)) {
  gal_path <- system.file("weights/columbus.gal", package = "spData")
  if (nzchar(gal_path) && file.exists(gal_path)) {
    columbus_nb <- spdep::read.gal(gal_path)
    columbus_crime_listw <- spdep::nb2listw(columbus_nb, style = "W", zero.policy = TRUE)
    nb_path <- file.path(weights_dir, "columbus_crime_nb.rds")
    listw_path <- file.path(weights_dir, "columbus_crime_listw.rds")
    saveRDS(columbus_nb, nb_path)
    saveRDS(columbus_crime_listw, listw_path)
    card <- spdep::card(columbus_nb)
    columbus_status <- "available_original"
    columbus_detail <- "Voisinage original lu depuis spData::weights/columbus.gal."
    columbus_nb_file <- "data/final_datasets/weights/columbus_crime_nb.rds"
    columbus_listw_file <- "data/final_datasets/weights/columbus_crime_listw.rds"
    columbus_cardinality <- sprintf(
      "n=49; voisins min=%d, mediane=%s, moyenne=%.2f, max=%d",
      min(card), stats::median(card), mean(card), max(card)
    )
  } else {
    columbus_status <- "not_found"
    columbus_detail <- "Le package spData est installe mais weights/columbus.gal est introuvable."
  }
}

rows <- data.frame(
  dataset = c(
    "georgia", "columbus_crime", "london_hp", "boston_housing",
    "dub_voter", "ewhp", "lasrosas",
    "paper_covid_sociodemographic_risk", "paper_spatial_confounding_diabetes",
    "paper_florida_crash_gsvcm", "paper_wildfire_bootleg_severity",
    "paper_amphibian_functional_diversity", "paper_dragonfly_diversity_europe",
    "paper_wang_henan_cultivated_land_quality", "paper_seshat_social_complexity",
    "paper_airbnb_europe_prices"
  ),
  origin = c(
    "Python package", "Python/R package", "R package", "Python package",
    "R package", "R package", "R package",
    rep("paper-derived dataset", 9L)
  ),
  source_package = c(
    "libpysal/GWmodel", "geodatasets/spData/spdep", "GWmodel", "geodatasets/spData",
    "GWmodel", "GWmodel", "agridat",
    rep(NA_character_, 9L)
  ),
  source_weight_status = c(
    "not_documented_in_source_package",
    columbus_status,
    "not_documented_in_source_package",
    "not_documented_in_source_package",
    "not_documented_in_source_package",
    "not_documented_in_source_package",
    "not_documented_in_source_package",
    rep("not_applicable_not_package_source", 9L)
  ),
  weight_type = c(
    NA_character_,
    if (identical(columbus_status, "available_original")) "irregular_contiguity_neighbors" else NA_character_,
    rep(NA_character_, 14L)
  ),
  weight_style = c(
    NA_character_,
    if (identical(columbus_status, "available_original")) "W" else NA_character_,
    rep(NA_character_, 14L)
  ),
  weight_object = c(
    NA_character_,
    if (identical(columbus_status, "available_original")) "columbus_crime_listw" else NA_character_,
    rep(NA_character_, 14L)
  ),
  weight_file = c(
    NA_character_,
    columbus_listw_file,
    rep(NA_character_, 14L)
  ),
  evidence = c(
    "Documentation libpysal/GWmodel: exemples GWR par coordonnees; aucune matrice W source identifiee.",
    columbus_detail,
    "Documentation GWmodel LondonHP: exemple GWR par coordonnees/bandwidth; aucune matrice W source identifiee.",
    "Documentation geodatasets/spData Boston: donnees et geometries; aucune matrice W source identifiee.",
    "Documentation GWmodel DubVoter: exemple GWR par coordonnees/bandwidth; aucune matrice W source identifiee.",
    "Documentation GWmodel EWHP: exemple hedonique/GWR; aucune matrice W source identifiee.",
    "Documentation agridat lasrosas.corn: donnees grillees; la matrice de voisinage exacte de l'article n'est pas distribuee comme objet source.",
    rep("Dataset issu d'un papier et non d'un package R/Python source; la presence d'une W doit etre lue dans le papier ou reconstruite.", 9L)
  ),
  cardinality_summary = c(
    NA_character_, columbus_cardinality, rep(NA_character_, 14L)
  ),
  action = c(
    "benchmark_knn_default",
    if (identical(columbus_status, "available_original")) "use_original_W_when_loaded" else "benchmark_knn_default_until_dependency_available",
    rep("benchmark_knn_default", 5L),
    rep("paper_specific_review_if_W_needed", 9L)
  ),
  stringsAsFactors = FALSE
)

audit_path <- file.path(audit_dir, "package_embedded_spatial_weights_audit.csv")
utils::write.table(rows, audit_path, sep = ";", dec = ".", row.names = FALSE, na = "", fileEncoding = "UTF-8")

report_path <- file.path(report_dir, "package_embedded_spatial_weights_audit_2026-09.md")
lines <- c(
  "# Matrices de voisinage pour les datasets embarques",
  "",
  "Ce rapport verifie les 16 jeux de donnees actuellement embarques dans le package `spatialtidymodels`.",
  "La question est de savoir si leur source R/Python fournit deja une matrice de voisinage originale ou si le benchmark doit construire un voisinage a partir des coordonnees.",
  "",
  "## Synthese",
  "",
  paste0("- Datasets embarques inspectes : ", nrow(rows)),
  paste0("- Datasets provenant de packages R/Python : ", sum(rows$origin %in% c("Python package", "Python/R package", "R package"))),
  paste0("- Matrice de voisinage source retrouvee : ", sum(rows$source_weight_status == "available_original")),
  "- Quand aucune matrice source n'est documentee, le benchmark conserve le comportement existant : construction d'une W kNN depuis les coordonnees.",
  "",
  "## Detail",
  "",
  "| Dataset | Origine | Package source | Statut W source | Action |",
  "|---|---|---|---|---|"
)
for (i in seq_len(nrow(rows))) {
  lines <- c(lines, sprintf(
    "| `%s` | %s | %s | %s | %s |",
    rows$dataset[[i]],
    rows$origin[[i]],
    ifelse(is.na(rows$source_package[[i]]), "", rows$source_package[[i]]),
    rows$source_weight_status[[i]],
    rows$action[[i]]
  ))
}
lines <- c(
  lines,
  "",
  "## Columbus",
  "",
  "Pour `columbus_crime`, le voisinage source est disponible sous forme `spData::weights/columbus.gal`.",
  "Il a ete sauvegarde sous `data/final_datasets/weights/columbus_crime_nb.rds` et sous forme `listw` standardisee en lignes dans `data/final_datasets/weights/columbus_crime_listw.rds`.",
  paste0("Cardinalite : ", ifelse(is.na(columbus_cardinality), "non disponible", columbus_cardinality), ".")
)
writeLines(lines, report_path, useBytes = TRUE)

message("Weights/audit ecrits:")
message("- ", normalizePath(audit_path, winslash = "/", mustWork = FALSE))
message("- ", normalizePath(report_path, winslash = "/", mustWork = FALSE))
