# Reconstruction de la matrice de poids spatiale (W) pour
# paper_influenza_mortality_chicago (Grantz, Rane, Salje, Glass,
# Schachterle & Cummings, 2016, PNAS).
#
# Le papier ne declare aucune matrice de poids spatiale (modele de comptage
# sans terme spatial explicite dans la formule publiee) -- verifie: aucun
# script/readme dans data/raw/papers/DataCite_2016_.../ ne mentionne de
# construction de voisinage (session 2026-09-22). Cette W est donc une
# SPECIFICATION GEOGRAPHIQUE INVENTEE PAR LE PROJET (contiguite reine sur les
# 496 census tracts de Chicago), utile pour panel_sar_fe/panel_sem_fe/
# panel_sac_fe, PAS une reconstruction de la methode des auteurs -- aucune
# valeur publiee de type SAR pour juger sa plausibilite.
#
# Geometrie source : geom_origine (MULTIPOLYGON, NAD83 / Illinois East),
# deja presente dans l'artefact local (jointure via GISJOIN au shapefile
# IL_tract_a.shp, documentee dans la fiche). Unite = GISJOIN (496 census
# tracts distincts, verifie stable -- une seule geometrie par GISJOIN sur les
# 3472 lignes du panel).

suppressMessages({library(sf); library(spdep)})

d <- readRDS("data/final_datasets/sf/paper_influenza_mortality_chicago.rds")
d <- sf::st_set_geometry(sf::st_drop_geometry(d), d$geom_origine)
d1 <- d[!duplicated(d$GISJOIN), ]
d1 <- d1[order(d1$GISJOIN), ]
stopifnot(nrow(d1) == 496L, !anyDuplicated(d1$GISJOIN))

nb <- poly2nb(d1, queen = TRUE, row.names = as.character(d1$GISJOIN))
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
isolated <- d1$GISJOIN[sapply(nb, function(x) identical(x, 0L))]
if (comp$nc != 1L || length(isolated) > 0L) {
  stop(sprintf(
    "Geometrie inattendue (composantes=%d, isoles=%d) -- revoir ce script avant de continuer.",
    comp$nc, length(isolated)
  ))
}

listw <- nb2listw(nb, style = "W")
W <- as(as(listw, "CsparseMatrix"), "matrix")
rownames(W) <- d1$GISJOIN
colnames(W) <- d1$GISJOIN
stopifnot(all(abs(rowSums(W) - 1) < 1e-10))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_influenza_mortality_chicago_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$GISJOIN,
    method = "queen contiguity (spdep::poly2nb) sur geom_origine (496 census tracts, GISJOIN), row-standardized (style='W')",
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_influenza_mortality_chicago.rds (geom_origine, MULTIPOLYGON NAD83/Illinois East)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Aucune methode de W geographique documentee par les auteurs (papier sans terme spatial explicite). Contiguite reine standard, pas une reconstruction publiee.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
