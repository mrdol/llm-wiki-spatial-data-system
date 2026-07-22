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
    "dub_voter", "ewhp", "lasrosas"
  ),
  source = c(
    "data/final_datasets/sf/Python_libpysal_georgia.rds",
    "data/final_datasets/sf/Python_geodatasets_spdata.columbus.rds",
    "data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds",
    "data/final_datasets/sf/Python_geodatasets_spdata.boston.rds",
    "data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds",
    "data/final_datasets/sf/R_GWmodel_EWHP_ewhp.rds",
    "data/final_datasets/sf/R_agridat_lasrosas.corn_lasrosas.corn.rds"
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
