# Reconstruction de la matrice de poids spatiale (W) pour
# paper_shark_longline_catch (Burns et al. 2024, "Global hotspots of shark
# interactions with industrial longline fisheries").
#
# Le papier ne documente aucune matrice de poids spatiale (lu dans le TEI,
# corpus/papers/tei/Burns_2024_GlobalHotspotsSharkLongline.tei.xml) :
# modeles ML sur grilles 1x1/5x5 degres, pas d'econometrie spatiale. Les 2
# mentions de "nearest neighbors" concernent l'imputation de covariables
# manquantes, pas un poids spatial de modelisation -- verifie, pas suppose.
# Cette W est donc une SPECIFICATION GEOGRAPHIQUE INVENTEE PAR LE PROJET.
#
# Unite = site distinct par (latitude, longitude) arrondies a 3 decimales
# (aucune colonne d'identifiant de site dans l'artefact local). 300 sites
# distincts, repetition T par site : min=4, mediane=36, max=36 -- panel
# quasi equilibre, bon candidat malgre l'absence de methode publiee.

suppressMessages({library(sf); library(spdep)})

rds_path <- "data/final_datasets/sf/paper_shark_longline_catch.rds"
full <- readRDS(rds_path)
if (!"site_id" %in% names(full)) {
  full$site_id <- paste(round(full$latitude, 3), round(full$longitude, 3))
  saveRDS(full, rds_path)
  cat("Colonne site_id materialisee dans le .rds\n")
}
stopifnot(length(unique(full$site_id)) == 300L)

d <- sf::st_set_geometry(sf::st_drop_geometry(full), full$geom_origine)
d1 <- d[!duplicated(d$site_id), ]
d1 <- d1[order(d1$site_id), ]
stopifnot(nrow(d1) == 300L, !anyDuplicated(d1$site_id))

coords_mat <- cbind(as.numeric(d1$longitude), as.numeric(d1$latitude))
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
out_path <- file.path(weights_dir, "paper_shark_longline_catch_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$site_id,
    method = sprintf("k=%d plus proches voisins (spdep::knearneigh/knn2nb) sur 300 sites distincts (coordonnees geographiques), row-standardized (style='W')", k),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_shark_longline_catch.rds (geom_origine, POINT, 300 sites longline)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Aucune methode de W documentee par les auteurs (Burns et al. 2024) -- modeles ML sur grilles, pas d'econometrie spatiale. Verifie que les mentions 'nearest neighbors' du papier concernent l'imputation de covariables, pas un poids de modele.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
