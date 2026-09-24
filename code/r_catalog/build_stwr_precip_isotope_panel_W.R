# Reconstruction de la matrice de poids spatiale (W) pour
# paper_stwr_precip_isotope (Que et al., 2020, Geoscientific Model
# Development -- "A spatiotemporal weighted regression model (STWR v1.0)
# for analyzing local nonstationarity").
#
# Le papier documente sa propre etude de cas empirique sur EXACTEMENT ce
# jeu de donnees (lu dans le TEI, corpus/papers/tei/A spatiotemporal
# weighted regression model for nontationarity.tei.xml) : "116 sites
# located in the northeastern United States during [a] 3 d period"
# (29-31 Oct 2012), modele y = b0 + b1*ppt + b2*tmean + b3*height + e,
# "272 points for model calibration" -- confirme exactement l'artefact
# local (116 sites distincts, 3 timestamps, N=272).
#
# MAIS leur ponderation spatiale n'est PAS une W statique de type SAR : STWR
# utilise un noyau continu W_t(u,v) (GWR-style, "Gaussian or bisquare"
# spatial kernel) combine a une decroissance temporelle, dont la bande
# passante est **optimisee par validation croisee** ("we use
# cross-validation (CV) as the default searching criteria") -- pas une
# valeur fixe lisible dans le texte, et pas reproductible sans reexecuter
# leur procedure d'optimisation complete (hors perimetre d'une session,
# consigne de l'encadrant). Le papier ne precise pas non plus lequel des
# deux noyaux (Gaussian/bisquare) a ete retenu pour cette etude de cas
# precise.
#
# Construction retenue, dans l'esprit de leur approche mais PAS une
# reproduction : W kNN (k=8, defaut du projet -- voir spatial_knn_args()/
# k_neighbors dans R/spatial-args.R) sur les 116 sites distincts, meme
# convention que pour paper_midwest_crop_yield (mais ici sans distance
# source des auteurs -- coordonnees geographiques du jeu local, pas un
# dist.mat fourni). Statut : specification projet informee par la forme du
# noyau des auteurs (kernel adaptatif de type kNN, coherent avec un usage
# GWR/STWR standard), PAS une reconstruction de leur bande passante
# optimisee par CV.

suppressMessages({library(sf); library(spdep)})

d <- readRDS("data/final_datasets/sf/paper_stwr_precip_isotope.rds")
d <- sf::st_set_geometry(sf::st_drop_geometry(d), d$geom_origine)
d$.site_key <- paste(round(d$Longitude, 4), round(d$Latitude, 4))
d1 <- d[!duplicated(d$.site_key), ]
d1 <- d1[order(d1$.site_key), ]
stopifnot(nrow(d1) == 116L, !anyDuplicated(d1$.site_key))

coords_mat <- cbind(as.numeric(d1$Longitude), as.numeric(d1$Latitude))
k <- 8L  # defaut du projet, voir spatial_knn_args()/k_neighbors (R/spatial-args.R)
knn_obj <- spdep::knearneigh(coords_mat, k = k, longlat = TRUE)
nb <- spdep::knn2nb(knn_obj)
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
stopifnot(all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- d1$.site_key
colnames(W) <- d1$.site_key
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_stwr_precip_isotope_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$.site_key,
    unit_coords = d1[, c("Longitude", "Latitude")],
    method = sprintf("k=%d plus proches voisins (spdep::knearneigh/knn2nb) sur 116 sites distincts (coordonnees geographiques), row-standardized (style='W')", k),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_stwr_precip_isotope.rds (geom_origine, POINT, 116 sites de mesure de precipitations hydrogen isotope, nord-est des Etats-Unis)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Le papier (Que et al. 2020, GMD) confirme documenter cette etude de cas exacte (116 sites, 3 j, N=272 -- correspondance verifiee) mais utilise un noyau spatio-temporel continu (Gaussian/bisquare) a bande passante optimisee par validation croisee, non reconstructible sans reexecuter leur procedure complete. Cette W kNN (k=8, meme convention que paper_midwest_crop_yield) est une specification projet informee par la forme generale de leur noyau (adaptatif), PAS une reconstruction de leur bande passante.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
