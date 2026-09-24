# Reconstruction de la matrice de voisinage (W) pour
# paper_n04_glasgow_respiratory (Cunha Godoy, Prates & Yan 2026, JABES,
# doi:10.1007/s13253-025-00720-7).
#
# EXCEPTION DELIBEREE a la regle habituelle du projet ("ne jamais construire
# une W sans estimateur consommateur reel", appliquee le 2026-09-23 aux 4
# jeux checkerspot/red_deer/wildebeest/ltar). Decision explicite de
# l'utilisateur (session 2026-09-23) : ce jeu est le premier du corpus a
# fournir une vraie geometrie polygonale motivant un modele d'adjacence
# (BYM/DAGAR, tous deux reellement ajustes par les auteurs sur ce jeu exact,
# Table 2 du papier -- voir Reference publication de la fiche). BYM/ICAR
# reste hors perimetre dans spatialtidymodels (wiki/estimators/inla.md) faute
# de matrice d'adjacence dans le corpus -- cette W est construite comme
# infrastructure prete pour le jour ou un estimateur de cette famille sera
# implemente, PAS consommee par le harnais aujourd'hui.
#
# Construction : spdep::poly2nb() (contiguite reine, defaut du package) sur
# les 134 polygones IZ -- c'est la construction standard pour ce type
# d'exemple areal (CARBayes/CARBayesST), mais PAS verifiee contre un W
# precalcule et publie par les auteurs (le paquet CARBayesdata ne livre que
# les donnees brutes, pas de W ; le papier N04 ne publie pas non plus sa
# matrice de voisinage exacte -- seulement qu'elle vient d'un "adjacency
# graph"). Row-standardized (style="W"), comme les autres W du projet.

suppressMessages({library(sf); library(spdep)})

rds_path <- "data/final_datasets/sf/paper_n04_glasgow_respiratory.rds"
full <- readRDS(rds_path)
stopifnot(nrow(full) == 134L, !anyDuplicated(full$IZ))

d <- sf::st_set_geometry(sf::st_drop_geometry(full), full$geom_origine)
d <- d[order(d$IZ), ]
stopifnot(nrow(d) == 134L)

nb <- spdep::poly2nb(d, row.names = d$IZ, queen = TRUE)
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes: %d\n", comp$nc))
stopifnot(comp$nc == 1L, all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- d$IZ
colnames(W) <- d$IZ
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_n04_glasgow_respiratory_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = d$IZ,
    method = "Contiguite reine (spdep::poly2nb(queen=TRUE)/nb2listw), 134 polygones Intermediate Zones, row-standardized (style='W')",
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_n04_glasgow_respiratory.rds (geom_origine, POLYGON, 134 IZ, EPSG:27700)",
    verified_against_authors_W = FALSE,
    # TRUE malgre le fait que les auteurs utilisent bien un "adjacency graph"
    # (DAGAR/BYM) : contiguite reine est le choix standard/par defaut du
    # projet pour ce type de construction, informe par la forme de leur
    # methode, mais pas une reconstruction verifiee de leur graphe exact --
    # meme convention que la W kNN de global_nee_gwxgboost.
    project_invented_specification = TRUE,
    note = paste(
      "Construction standard (contiguite reine) pour ce type d'exemple areal,",
      "mais ni CARBayesdata (donnees brutes uniquement) ni le papier N04 ne",
      "publient leur matrice d'adjacence exacte -- non verifiee contre les",
      "auteurs. Construite comme infrastructure pour un futur estimateur",
      "BYM/ICAR/DAGAR (aucun n'existe encore dans spatialtidymodels), pas",
      "consommee par le harnais actuel."
    ),
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
