# Genere les objets data() embarques dans le package a partir des datasets sf
# finalises du repo llm-wiki-karpathy. Ce script doit etre relance quand les
# fichiers sources de data/final_datasets/sf changent.

pkg_root <- normalizePath(file.path(getwd(), "packages", "spatialtidymodels"), winslash = "/", mustWork = TRUE)
repo_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
data_dir <- file.path(pkg_root, "data")
dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)

specs <- data.frame(
  object = c(
    "georgia", "columbus_crime", "london_hp", "boston_housing",
    "dub_voter", "ewhp", "lasrosas",
    # Second wave (2026-08-18): 9 more benchmark_ready, formula-confirmed
    # (formula_status "pub"), cross-sectional datasets, chosen for domain
    # diversity and bounded added size (~23MB total, vs the full pool of
    # 110 not-yet-bundled candidates). Panel candidates deliberately left
    # aside for a later round. See code/package_metadata/
    # export_spatialtidymodels_metadata.py's DATASET_ALIASES for the
    # matching data_object registration.
    "paper_covid_sociodemographic_risk", "paper_spatial_confounding_diabetes",
    "paper_florida_crash_gsvcm", "paper_wildfire_bootleg_severity",
    "paper_amphibian_functional_diversity", "paper_dragonfly_diversity_europe",
    "paper_wang_henan_cultivated_land_quality", "paper_seshat_social_complexity",
    "paper_airbnb_europe_prices"
  ),
  source = c(
    "data/final_datasets/sf/Python_libpysal_georgia.rds",
    "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds",
    "data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds",
    "data/final_datasets/sf/Python_geodatasets_spdata.boston.rds",
    "data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds",
    "data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds",
    "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn_1999.rds",
    "data/final_datasets/sf/paper_covid_sociodemographic_risk.rds",
    "data/final_datasets/sf/paper_spatial_confounding_diabetes.rds",
    "data/final_datasets/sf/paper_florida_crash_gsvcm.rds",
    "data/final_datasets/sf/paper_wildfire_bootleg_severity.rds",
    "data/final_datasets/sf/paper_amphibian_functional_diversity.rds",
    "data/final_datasets/sf/paper_dragonfly_diversity_europe.rds",
    "data/final_datasets/sf/paper_wang_henan_cultivated_land_quality.rds",
    "data/final_datasets/sf/paper_seshat_social_complexity.rds",
    "data/final_datasets/sf/paper_airbnb_europe_prices.rds"
  ),
  stringsAsFactors = FALSE
)

for (i in seq_len(nrow(specs))) {
  source_path <- file.path(repo_root, specs$source[[i]])
  if (!file.exists(source_path)) {
    stop(sprintf("Dataset source introuvable: %s", source_path), call. = FALSE)
  }
  object <- readRDS(source_path)
  assign(specs$object[[i]], object)
  save(
    list = specs$object[[i]],
    file = file.path(data_dir, paste0(specs$object[[i]], ".rda")),
    compress = "xz"
  )
}

message("Datasets package generes: ", paste(specs$object, collapse = ", "))
