# Reconstruction de la matrice de poids spatiale (W) pour
# paper_portugal_covid_municipal (Barbosa, Silva, Capinha, Garcia & Rocha,
# 2022, Geospatial Health).
#
# Le papier utilise un GLMM Tweedie a effet aleatoire NUTS-3 (pas de W
# SAR/SEM classique a reconstruire depuis leur specification) sur N=278
# municipalites du Portugal CONTINENTAL (Acores/Madere explicitement
# exclus par les auteurs, donnees indisponibles). L'artefact local
# (jointure geoBoundaries PRT/ADM2) contient 296 communes portugaises,
# Acores et Madere inclus -- confirme a la demande de l'utilisateur :
# construire la W sur ce perimetre, pas seulement le sous-ensemble
# continental.
#
# Session 2026-09-23 : le loader (load_portugal_covid_municipal(),
# code/r_catalog/build_sf_datasets_papers.R) a ete corrige -- il pretendait
# exclure les homonymes municipaux mais les fusionnait en realite
# silencieusement. Desormais : CALHETA et LAGOA (vrais homonymes
# administratifs, Acores/Madere/continent, centroides a 1100-1500 km)
# sont EXCLUES ; ILHAVO, MONTIJO et OLIVEIRA DE FRADES (memes communes
# scindees en 2 features dans geoBoundaries, centroides a 7-29 km, aucune
# homonymie officielle identifiee) sont FUSIONNEES en une geometrie. D'ou
# 298 -> 296 communes. L'anomalie "LAGOA a distrito=ACORES avec une
# geometrie continentale" documentee le 2026-09-22 disparait avec
# l'exclusion de LAGOA.
#
# Consequence geometrique (verifiee) : 1 bloc continental, les archipeles
# des Acores et de Madere se scindent en plusieurs sous-reseaux internes et
# des communes isolees (aucun voisin, meme au sein de leur archipel) --
# reel, pas un artefact (Acores/Madere n'ont aucune frontiere terrestre
# avec le continent). Traitement, dans l'esprit Hainan/li_energy (README
# extensions_projet_2026-09/matrice_W_originale/) : PATCHER uniquement les
# communes a degre zero (k=1 plus proche voisin par distance de centroide,
# verifie geometriquement), laisser intacte la separation continent/
# Acores/Madere et les sous-reseaux internes aux archipels.

suppressMessages({library(sf); library(spdep)})

d <- readRDS("data/final_datasets/sf/paper_portugal_covid_municipal.rds")
d <- sf::st_set_geometry(sf::st_drop_geometry(d), d$geom_origine)
d1 <- d[!duplicated(d$key), ]
d1 <- d1[order(d1$key), ]
stopifnot(nrow(d1) == 296L, !anyDuplicated(d1$key))
stopifnot(!any(d1$key %in% c("CALHETA", "LAGOA")))

nb <- poly2nb(d1, queen = TRUE, row.names = as.character(d1$key))
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
isolated_idx <- which(sapply(nb, function(x) identical(x, 0L)))
isolated_keys <- d1$key[isolated_idx]
cat(sprintf("communes a degre zero: %d -> %s\n", length(isolated_idx), paste(isolated_keys, collapse = ", ")))

cent <- sf::st_centroid(sf::st_geometry(d1))
patch_log <- character(0)
for (idx in isolated_idx) {
  dists <- sf::st_distance(cent[idx], cent)
  dists[1, idx] <- Inf
  nearest_idx <- which.min(dists[1, ])
  nearest_km <- as.numeric(dists[1, nearest_idx]) / 1000
  nb[[idx]] <- as.integer(nearest_idx)
  nb[[nearest_idx]] <- sort(unique(c(nb[[nearest_idx]], idx)))
  patch_log <- c(patch_log, sprintf("%s -> %s (%.1f km)", d1$key[idx], d1$key[nearest_idx], nearest_km))
  cat(sprintf("%s -> plus proche voisin par centroide : %s (%.1f km)\n", d1$key[idx], d1$key[nearest_idx], nearest_km))
}
comp_after <- n.comp.nb(nb)
cat(sprintf("composantes connexes apres patch: %d (attendu : reduit de %d, jamais 1 -- continent/Acores/Madere restent separes)\n", comp_after$nc, comp$nc))
stopifnot(all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- d1$key
colnames(W) <- d1$key
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_portugal_covid_municipal_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d1$key,
    method = "queen contiguity (spdep::poly2nb) sur geom_origine (296 communes -- continent + Acores + Madere, CALHETA/LAGOA exclues comme homonymes), row-standardized (style='W')",
    isolated_unit_patch = paste(patch_log, collapse = " | "),
    source_geometry = "data/final_datasets/sf/paper_portugal_covid_municipal.rds (geom_origine, MULTIPOLYGON, jointure geoBoundaries PRT/ADM2, loader corrige le 2026-09-23)",
    verified_against_authors_W = FALSE,
    project_invented_specification = TRUE,
    note = "Le papier (Barbosa et al. 2022) n'utilise pas de W SAR/SEM (GLMM Tweedie, effet aleatoire NUTS-3) et exclut Acores/Madere (N=278 continental). Cette W couvre les 296 communes de l'artefact local (demande explicite), pas le perimetre du papier -- continent/Acores/Madere restent des composantes disjointes (geographiquement reel), seules les communes a degre zero sont patchees par kNN=1 verifie.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
