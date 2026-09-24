# Reconstruction de la matrice de poids spatiale (W) pour
# paper_early_season_biomass (Huddell et al. 2024, Agricultural & Environmental Letters).
#
# Le papier documente un GLMM (lme4::glmer) avec intercepts aleatoires
# imbriques par localisation et par bloc ("random intercepts for each
# location and for blocks (nested under each location) to address the
# non-independence of repeated measurements within the same locations and
# blocks through time") -- lu dans le TEI. Aucune matrice de poids spatiale
# (adjacence/kNN/distance) documentee. Cette W est donc une SPECIFICATION
# GEOGRAPHIQUE INVENTEE PAR LE PROJET.
#
# Bug trouve en verifiant (session 2026-09-23) : la colonne `site` (nom de
# site en texte libre) N'EST PAS un identifiant fiable -- le meme lieu
# physique porte plusieurs libelles selon l'annee/la source (ex. "AR
# Fayetteville" vs "AR Fayetteville, AR" ; "MO Bradford Research Center" vs
# "(assumed)" vs "Bradford Research Farm, Columbia, MO") : 25 valeurs
# distinctes de `site` pour seulement 18 lieux physiques reels (verifie par
# arrondi des coordonnees, coherent avec la Note N/T deja etablie en
# 2026-08-17). Un site (VA Kentland Farm) a meme deux positions legerement
# differentes (~100m) selon l'annee (bruit GPS/relectures de terrain, pas un
# lieu different). Identifiant construit sur les coordonnees arrondies a 3
# decimales (~110m), qui redonne exactement 18 unites -- pas la colonne
# `site` brute.

suppressMessages({library(sf); library(spdep)})

rds_path <- "data/final_datasets/sf/paper_early_season_biomass.rds"
full <- readRDS(rds_path)
if (!"site_id" %in% names(full)) {
  full$site_id <- paste(round(full$lat, 3), round(full$lon, 3))
  saveRDS(full, rds_path)
  cat("Colonne site_id materialisee dans le .rds\n")
}
stopifnot(length(unique(full$site_id)) == 18L)

d <- sf::st_set_geometry(sf::st_drop_geometry(full), full$geom_origine)
d1 <- d[!duplicated(d$site_id), ]
d1 <- d1[order(d1$site_id), ]
stopifnot(nrow(d1) == 18L, !anyDuplicated(d1$site_id))

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
out_path <- file.path(weights_dir, "paper_early_season_biomass_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$site_id,
    method = sprintf("k=%d plus proches voisins (spdep::knearneigh/knn2nb) sur 18 sites distincts (coordonnees geographiques), row-standardized (style='W')", k),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_early_season_biomass.rds (geom_origine, POINT, 18 sites distincts par coordonnees arrondies)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Aucune matrice de poids spatiale documentee par les auteurs (GLMM avec intercepts aleatoires par site/bloc, pas de W geographique). La colonne `site` (texte libre) est ambigue -- 25 valeurs distinctes pour 18 lieux reels (variantes de libelle du meme lieu) -- `site_id` materialise a partir des coordonnees arrondies (3 decimales) resout ceci.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
