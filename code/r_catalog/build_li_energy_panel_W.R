# Reconstruction de la matrice de poids spatiale (W) pour
# paper_li_energy_price_co2_china (Li, Fang et He, 2020).
#
# Le papier (pages PDF 16-17) declare : "if the two regions have a common
# boundary, the weight of each other is set to 1, and 0 otherwise... we take
# a row normalization of the spatial weight matrix." Aucune mention de
# Hainan (ile sans frontiere terrestre) dans le texte ni le TEI -- les
# auteurs ne documentent pas comment ils traitent ce cas, et le depot brut
# des auteurs (data.xlsx, Mendeley) ne contient que les 14 colonnes de
# variables + id_province numerique : ni nom de province, ni geometrie, ni
# matrice W. L'identification des provinces (population + codes GB/T 2260)
# ET la reconstruction de W sont toutes deux entierement a la charge du
# projet, faute de materiel partage par les auteurs au-dela du tableau brut.
#
# Methodologie de reconstruction W dictee par l'encadrant (voir
# extensions_projet_2026-09/matrice_W_originale/README.md) : pour un noeud
# isole apres reconstruction par contiguite, la sequence est (1) voisins-de-
# voisins (W^2) si un voisinage existant devient vide par sous-echantillonnage,
# puis (2) elimination de la ligne seulement en dernier recours si ce n'est
# pas rapide. Le cas de Hainan est different de celui vise par (1) : elle n'a
# JAMAIS de voisin terrestre, meme dans la geometrie complete a 30 provinces
# -- ce n'est pas un artefact de sous-echantillonnage, W^2 sur une ligne deja
# nulle reste nulle.
#
# Adaptation retenue, dans le meme esprit (une regle geometrique systematique,
# pas un choix arbitraire) : le papier lui-meme (page PDF 16) reconnait le
# plus proche voisin (k-nearest neighbors) comme l'une des trois methodes
# usuelles de construction de W ("binary adjacency matrix, K-nearest
# Neighbors matrix and distance threshold matrix"), a cote de la contiguite
# qu'il dit avoir utilisee. Hainan recoit donc un lien k=1 vers sa province la
# plus proche par distance de centroide -- verifiee, pas supposee : Guangxi
# (566 km), pas Guangdong (643 km) comme le laisserait croire la seule
# proximite du detroit de Qiongzhou.
#
# Cette reconstruction n'est PAS prouvee identique a W des auteurs :
# - l'identification des 30 provinces reste une reconstruction (population +
#   codes GB/T 2260), documentee dans la fiche, pas un codebook officiel ;
# - la geometrie jointe au projet peut differer de celle utilisee par les
#   auteurs (source, resolution, annee de decoupage administratif) ;
# - le lien k-NN de Hainan est une methode reconnue par le papier, mais le
#   choix de la province receptrice (Guangxi, plus proche par centroide)
#   n'est pas documente par les auteurs eux-memes.
#
# Statut : reconstruction plausible, pas verifiee. Ne sert pas de base a une
# promotion package_include=yes tant que ces points ne sont pas leves (voir
# wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md, jalon J5).

suppressMessages(library(sf))
suppressMessages(library(spdep))

d <- readRDS("data/final_datasets/sf/paper_li_energy_price_co2_china.rds")
d1 <- d[d$year == min(d$year), ]
d1 <- d1[order(d1$province_name), ]
stopifnot(nrow(d1) == 30L, !anyDuplicated(d1$province_name))

nb <- poly2nb(d1, queen = TRUE, row.names = d1$province_name)
comp_before <- n.comp.nb(nb)
if (comp_before$nc != 2L) {
  stop(sprintf(
    "Nombre de composantes connexes inattendu (%d, attendu 2 : continent + Hainan) -- la geometrie a peut-etre change, revoir ce script avant de continuer.",
    comp_before$nc
  ))
}
isolated <- d1$province_name[sapply(nb, function(x) identical(x, 0L))]
if (!identical(isolated, "Hainan")) {
  stop(sprintf("Province(s) isolee(s) inattendue(s) : %s (attendu : Hainan uniquement).", paste(isolated, collapse = ", ")))
}

hainan_idx <- which(d1$province_name == "Hainan")
cent <- sf::st_centroid(sf::st_geometry(d1))
dists <- sf::st_distance(cent[hainan_idx], cent)
dists[1, hainan_idx] <- Inf
nearest_idx <- which.min(dists[1, ])
nearest_name <- d1$province_name[nearest_idx]
nearest_km <- as.numeric(dists[1, nearest_idx]) / 1000
cat(sprintf("Hainan -> plus proche voisin par centroide : %s (%.1f km)\n", nearest_name, nearest_km))

nb[[hainan_idx]] <- as.integer(nearest_idx)
nb[[nearest_idx]] <- sort(unique(c(nb[[nearest_idx]], hainan_idx)))
comp_after <- n.comp.nb(nb)
stopifnot(comp_after$nc == 1L)

listw <- nb2listw(nb, style = "W")
W <- as(as(listw, "CsparseMatrix"), "matrix")
rownames(W) <- d1$province_name
colnames(W) <- d1$province_name
stopifnot(all(abs(rowSums(W) - 1) < 1e-10))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_li_energy_price_co2_china_W.rds")
saveRDS(
  list(
    W = W,
    province_order = d1$province_name,
    method = "queen contiguity (spdep::poly2nb), row-standardized (style='W')",
    isolated_unit_patch = sprintf(
      "Hainan (aucun voisin terrestre) liee par k=1 plus proche voisin par distance de centroide : %s (%.1f km) -- methode k-NN explicitement reconnue par le papier (page PDF 16) comme alternative a la contiguite, mais le choix de %s comme receveur n'est pas documente par les auteurs.",
      nearest_name, nearest_km, nearest_name
    ),
    source_geometry = "data/final_datasets/sf/paper_li_energy_price_co2_china.rds (annee 2002, 30 provinces)",
    verified_against_authors_W = FALSE,
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
