# Reconstruction de la matrice de poids spatiale (W) pour
# paper_fhb_ensembling ("Accuracy in the prediction of disease epidemics
# when ensembling simple but highly correlated models").
#
# Le papier ne documente aucune methode de ponderation spatiale (lu dans le
# TEI, corpus/papers/tei/Accuracy_in_the_prediction_...tei.xml) : un
# ensemble de regressions logistiques sur donnees de site, sans terme
# spatial explicite ("spatial autocorrelation": 0 occurrence, "random
# effect": 0 occurrence). Cette W est donc une SPECIFICATION GEOGRAPHIQUE
# INVENTEE PAR LE PROJET.
#
# Unite = paste(state, location) (69 unites distinctes, position stable
# verifiee -- 0/69 avec >1 geometrie). Repetition T par unite : min=1,
# mediane=5, max=101 (tres asymetrique -- quelques sites tres suivis,
# beaucoup peu).

suppressMessages({library(sf); library(spdep)})

rds_path <- "data/final_datasets/sf/paper_fhb_ensembling.rds"
full <- readRDS(rds_path)
if (!"site_id" %in% names(full)) {
  full$site_id <- paste(full$state, full$location)
  saveRDS(full, rds_path)
  cat("Colonne site_id materialisee dans le .rds\n")
}
stopifnot(length(unique(full$site_id)) == 69L)

d <- sf::st_set_geometry(sf::st_drop_geometry(full), full$geom_origine)
d1 <- d[!duplicated(d$site_id), ]
d1 <- d1[order(d1$site_id), ]
stopifnot(nrow(d1) == 69L, !anyDuplicated(d1$site_id))

coords_mat <- cbind(as.numeric(d1$lon), as.numeric(d1$lat))
k <- 8L  # defaut du projet, voir spatial_knn_args()/k_neighbors (R/spatial-args.R)
knn_obj <- spdep::knearneigh(coords_mat, k = k, longlat = TRUE)
nb <- spdep::knn2nb(knn_obj)
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
stopifnot(all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- d1$site_id
colnames(W) <- d1$site_id
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_fhb_ensembling_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$site_id,
    method = sprintf("k=%d plus proches voisins (spdep::knearneigh/knn2nb) sur 69 sites distincts (state+location, coordonnees geographiques), row-standardized (style='W')", k),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_fhb_ensembling.rds (geom_origine, POINT, 69 sites)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Aucune methode de W documentee par les auteurs -- ensemble de regressions logistiques, aucun terme spatial explicite dans le papier (0 occurrence de 'spatial autocorrelation'/'random effect' dans le TEI).",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
