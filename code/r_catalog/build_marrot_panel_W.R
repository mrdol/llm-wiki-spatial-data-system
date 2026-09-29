# Reconstruction de la matrice de poids spatiale (W) pour
# paper_marrot_spatial_autocorrelation_fitness (Marrot, Garant & Charmantier,
# 2015, Methods in Ecology and Evolution -- "Spatial autocorrelation in
# fitness affects the estimation of natural selection in the wild").
#
# CONTRAIREMENT aux 3 jeux ecologiques du lot precedent
# (cas_ecologiques_batch1_2026-09-22.md), ce papier documente EXPLICITEMENT
# sa methode de construction de W pour son modele SAR (lu dans le TEI,
# corpus/papers/tei/Spatial autocorrelation in fitness ... .tei.xml) :
#
#   "(1) Compute a pairwise Euclidean distance matrix between spatial
#   units: D = [d_ij]. (2) Truncate this distance matrix at a distance of a
#   threshold value t [...] t is generally chosen as the minimum distance
#   that maintains all sampling units connected using a minimum spanning
#   tree algorithm (Borcard, Gillet & Legendre 2011)."
#
# C'est le Cas 1 de la methodologie de Ghislain (README du dossier) : seuil
# de distance, toujours reconstructible. La regle du seuil t (minimum
# spanning tree = plus petite distance qui maintient toutes les unites
# connectees) est objective et calculable directement -- pas une valeur
# numerique a deviner.
#
# Reserve : le texte documente ce seuil precisement pour le modele PCNM
# (D* utilise ensuite pour une analyse en coordonnees principales, pas
# directement comme W SAR). Le modele SAR du papier utilise "a spatial
# weight matrix" (citant Lichstein et al. 2002) sans repreciser une
# construction distincte -- l'hypothese retenue ici est que le meme seuil
# de connectivite (MST) sert de base a la W SAR, ce qui est l'usage courant
# quand un seul D est calcule pour l'ensemble de l'analyse spatiale du
# papier (pas confirme explicitement pour le cas SAR specifiquement).
#
# Unite spatiale = Nest_boxes_ID (140 nichoirs distincts, position stable
# verifiee -- 0/140 avec >1 position). CRS WGS84 (etendue ~3.66-3.68 E,
# 43.65-43.67 N, site de La Rouviere, France) ; distances calculees par
# sf::st_distance (geodesiques, coherent avec les distances metriques
# rapportees dans le papier, ex. "significant ... at 208 m and 416 m").

suppressMessages({library(sf); library(spdep)})

d <- readRDS("data/final_datasets/sf/paper_marrot_spatial_autocorrelation_fitness.rds")
d <- sf::st_set_geometry(sf::st_drop_geometry(d), d$geom_origine)
d1 <- d[!duplicated(d$Nest_boxes_ID), ]
d1 <- d1[order(d1$Nest_boxes_ID), ]
stopifnot(nrow(d1) == 140L, !anyDuplicated(d1$Nest_boxes_ID))

D <- sf::st_distance(d1)
units(D) <- NULL  # metres
diag(D) <- 0

# Seuil t = plus petite distance qui maintient toutes les unites connectees
# (arbre couvrant minimal) -- regle explicitement documentee par le papier
# (Borcard, Gillet & Legendre 2011), pas une valeur choisie. Reconstruction
# manuelle de l'arbre couvrant minimal (algorithme de Prim) directement sur
# la matrice de distance D, plutot que de dependre d'une fonction spdep
# specifique dont la signature/disponibilite varie selon la version.
n <- nrow(D)
in_tree <- rep(FALSE, n); in_tree[1] <- TRUE
mst_edges <- matrix(NA_real_, nrow = 0, ncol = 3)
while (!all(in_tree)) {
  sub <- D[in_tree, !in_tree, drop = FALSE]
  best <- which(sub == min(sub), arr.ind = TRUE)[1, ]
  from_idx <- which(in_tree)[best[1]]
  to_idx <- which(!in_tree)[best[2]]
  mst_edges <- rbind(mst_edges, c(from_idx, to_idx, D[from_idx, to_idx]))
  in_tree[to_idx] <- TRUE
}
t_threshold <- max(mst_edges[, 3])
cat(sprintf("seuil t (arbre couvrant minimal, metres): %.1f\n", t_threshold))

# Construction directe depuis D (en metres, via sf::st_distance) plutot que
# spdep::dnearneigh sur X/Y bruts : X/Y sont en degres (CRS WGS84), un
# passage par dnearneigh appliquerait le seuil t (metres) directement aux
# degres -- bug d'unites qui rendrait le graphe quasi complet. D est deja
# la bonne distance (geodesique, metres), on l'utilise telle quelle.
nb <- lapply(seq_len(n), function(i) {
  neigh <- which(D[i, ] <= t_threshold & seq_len(n) != i)
  if (length(neigh) == 0L) 0L else as.integer(neigh)
})
class(nb) <- "nb"
attr(nb, "region.id") <- as.character(d1$Nest_boxes_ID)
comp <- n.comp.nb(nb)
cat(sprintf("composantes connexes au seuil t: %d (attendu 1, par construction de l'arbre couvrant minimal)\n", comp$nc))
stopifnot(comp$nc == 1L)
stopifnot(all(sapply(nb, function(x) !identical(x, 0L))))

listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- as.character(d1$Nest_boxes_ID)
colnames(W) <- as.character(d1$Nest_boxes_ID)
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_marrot_spatial_autocorrelation_fitness_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = as.character(d1$Nest_boxes_ID),
    method = sprintf("seuil de distance (spdep::dnearneigh), t=%.1fm = arbre couvrant minimal sur 140 nichoirs distincts (regle documentee par Marrot, Garant & Charmantier 2015, section Methods, citant Borcard, Gillet & Legendre 2011), row-standardized (style='W')", t_threshold),
    isolated_unit_patch = NA_character_,
    source_geometry = "data/final_datasets/sf/paper_marrot_spatial_autocorrelation_fitness.rds (geom_origine, POINT WGS84, positions de nichoirs)",
    verified_against_authors_W = FALSE,
    method_documented_by_authors = TRUE,
    note = "Seuil t reconstruit selon la regle MST explicitement documentee par les auteurs pour leur modele PCNM (5-step procedure, Borcard & Legendre 2002). Le modele SAR du papier cite une 'spatial weight matrix' (Lichstein et al. 2002) sans reconfirmer une construction distincte -- hypothese retenue que le meme seuil sert de base, non confirmee explicitement pour le cas SAR.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
cat("cardinalite (nb voisins/unite):", paste(range(spdep::card(nb)), collapse=" - "), "\n")
