# Reconstruction de la matrice de poids spatiale (W) pour
# paper_global_nee_gwxgboost ("Estimating Global Site-Level Net Ecosystem
# Exchange with a Geographically Weighted XGBoost Framework").
#
# Le Readme.pdf du depot (data/raw/papers/DatasetFirst_10_5281_zenodo_21635729/
# Readme.pdf) documente un vrai Geographically Weighted XGBoost/Random
# Forest : "For each target site, a local training dataset is constructed
# by identifying the k nearest neighboring sites and assigning Gaussian
# kernel weights based on inter-site distances" -- k optimise par site via
# grid search (pas une valeur fixe unique). C'est un Cas 1 (kNN, base sur
# la distance) mais avec un k adaptatif propre a chaque site, pas
# reconstructible exactement sans rejouer leur recherche en grille
# complete (meme situation que paper_stwr_precip_isotope).
#
# W construite : kNN k=8 (defaut du projet, spatial_knn_args()) sur les 387
# sites distincts (correspond exactement aux "387 eddy covariance flux
# tower sites" de construction du modele, confirme par le Readme.pdf) --
# row-standardized, PAS le noyau gaussien adaptatif des auteurs.
# Specification projet informee par la forme de leur ponderation (kNN +
# noyau), pas une reconstruction de leur k optimal par site.

suppressMessages({library(sf); library(spdep)})

rds_path <- "data/final_datasets/sf/paper_global_nee_gwxgboost.rds"
full <- readRDS(rds_path)
stopifnot(length(unique(full$Site.Name)) == 387L)

d <- sf::st_set_geometry(sf::st_drop_geometry(full), full$geom_origine)
d1 <- d[!duplicated(d$Site.Name), ]
d1 <- d1[order(d1$Site.Name), ]
stopifnot(nrow(d1) == 387L, !anyDuplicated(d1$Site.Name))

coords_mat <- cbind(as.numeric(d1$Longitude), as.numeric(d1$Latitude))
k <- 8L  # defaut du projet, voir spatial_knn_args()/k_neighbors (R/spatial-args.R)
knn_obj <- spdep::knearneigh(coords_mat, k = k, longlat = TRUE)
nb <- spdep::knn2nb(knn_obj)
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
stopifnot(all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- d1$Site.Name
colnames(W) <- d1$Site.Name
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_global_nee_gwxgboost_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$Site.Name,
    method = sprintf("k=%d plus proches voisins (spdep::knearneigh/knn2nb) sur 387 sites distincts (coordonnees geographiques), row-standardized (style='W')", k),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_global_nee_gwxgboost.rds (geom_origine, POINT, 387 sites eddy covariance)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Le Readme.pdf documente un GWXGBoost/GWRF a kNN + noyau gaussien, k optimise par site (grid search) -- non reproductible exactement. Cette W kNN=8 fixe est une specification projet informee par la forme de leur ponderation (adaptatif), pas une reconstruction de leur k optimal.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
