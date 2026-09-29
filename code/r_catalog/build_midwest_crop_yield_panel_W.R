# Reconstruction de la matrice de poids spatiale (W) pour
# paper_midwest_crop_yield (Park, Li & Li, 2022, JASA -- Bayesian spatially
# varying functional model, BSVFM).
#
# Le papier n'utilise pas de matrice de poids binaire/SAR classique (modele
# bayesien a coefficients spatialement variables sur des trajectoires
# fonctionnelles de temperature) -- pas de W au sens panel_sar_fe/
# panel_sem_fe a reconstruire depuis leur specification. MAIS le supplement
# JASA (MidwestData.RData) fournit "dist.mat" : la matrice de distance (km)
# INTER-COMTES REELLE DES AUTEURS, exactement ordonnee sur CountyI.info (403
# comtes, 5 etats). C'est une base BEAUCOUP plus solide qu'une reconstruction
# geometrique projet (li_energy/chicago/portugal) : les distances sont
# celles des auteurs, verifiees, pas re-derivees d'une geometrie rejointe.
#
# La W elle-meme (k plus proches voisins sur ces distances, k=8 -- defaut du
# projet, voir spatial_knn_args()/k_neighbors dans R/spatial-args.R) reste
# une construction du projet, pas une reproduction de leur noyau bayesien
# spatialement variable -- mais fondee sur une source de distance 100%
# fidele aux auteurs, contrairement a une contiguite reconstruite depuis une
# geometrie rejointe.
#
# Bug trouve en verifiant (session 2026-09-22) : la colonne locale
# `county_key` (nom de comte seul, ex. "ADAIR") N'EST PAS un identifiant
# unique -- "Adair" existe a la fois dans l'Iowa et le Missouri. L'identifiant
# correct est CountyI (403 valeurs distinctes, alignees sur CountyI.info),
# equivalent a State+CountyI localement. A signaler separement si county_key
# est utilise ailleurs dans le pipeline.
#
# "Lake County" (Illinois, CountyI local) ressortait isole en contiguite
# reine (verifie via poly2nb + snap=1000m, toujours isole -- ses vrais
# voisins geographiques, Cook County IL et le Wisconsin, ne font pas partie
# du perimetre des 403 comtes de l'etude). Le kNN sur dist.mat resout ce cas
# nativement (k=8 plus proches parmi les 403, quelle que soit leur
# contiguite reelle) : pas de patch special necessaire.

suppressMessages({library(spdep)})

d <- readRDS("data/final_datasets/sf/paper_midwest_crop_yield.rds")
sf::st_geometry(d) <- NULL
d$unit_id <- paste(d$State, d$CountyI, sep = "_")
n_units_local <- length(unique(d$unit_id))
cat(sprintf("unites locales distinctes (State_CountyI): %d\n", n_units_local))

e <- new.env()
load("data/raw/papers/DataCite_2022_CropYieldPredictionUsing_10_1080_01621459/extracted/UASA_A_2123333_supplement/jasa-a_cs-2021-0348-20220907220449/suppl_data/MidwestData.RData", envir = e)
ci <- get("CountyI.info", envir = e)
dm <- get("dist.mat", envir = e)
stopifnot(nrow(ci) == 403L, nrow(dm) == 403L, ncol(dm) == 403L)
stopifnot(all(diag(dm) == 0), isTRUE(all.equal(dm, t(dm))))

# ci$State.County est "IL-ADAMS" -- meme convention que notre unit_id local
# ("ILLINOIS_..." non, notre unit_id est State complet + CountyI, pas
# State.County) : le lien fiable entre les deux univers est CountyI seul
# (identifiant numerique partage), pas le nom.
local_countyi <- unique(d$CountyI)
stopifnot(setequal(local_countyi, ci$CountyI))

ci <- ci[match(ci$CountyI, ci$CountyI), ]  # deja dans l'ordre de dist.mat
k <- 8L  # defaut du projet, voir spatial_knn_args()/k_neighbors (R/spatial-args.R)

nb <- vector("list", nrow(ci))
for (i in seq_len(nrow(ci))) {
  ord <- order(dm[i, ])
  ord <- ord[ord != i]
  nb[[i]] <- as.integer(ord[seq_len(k)])
}
class(nb) <- "nb"
attr(nb, "region.id") <- as.character(ci$CountyI)
listw <- nb2listw(nb, style = "W")
W <- listw2mat(listw)
rownames(W) <- as.character(ci$CountyI)
colnames(W) <- as.character(ci$CountyI)
stopifnot(all(abs(rowSums(W) - 1) < 1e-8))
stopifnot(all(diag(W) == 0))

weights_dir <- "data/final_datasets/weights"
dir.create(weights_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(weights_dir, "paper_midwest_crop_yield_W.rds")
saveRDS(
  list(
    W = W,
    unit_order = as.character(ci$CountyI),  # index CountyI (numerique) -- joindre localement via CountyI, pas county_key (voir note ci-dessus)
    county_labels = ci$State.County,
    method = sprintf("k=%d plus proches voisins (spdep::knn2nb-equivalent) sur dist.mat (distance inter-comtes en km, fournie par les auteurs dans MidwestData.RData), row-standardized (style='W')", k),
    isolated_unit_patch = "aucun necessaire -- kNN sur distance reelle resout nativement Lake County (IL), isole en contiguite reine car ses voisins geographiques reels sont hors perimetre de l'etude (verifie via poly2nb + snap=1000m).",
    source_geometry = "data/raw/papers/DataCite_2022_CropYieldPredictionUsing_10_1080_01621459/.../MidwestData.RData (dist.mat + CountyI.info, fournis par Park, Li & Li 2022)",
    verified_against_authors_W = FALSE,
    distances_are_authors_own = TRUE,
    project_invented_specification = TRUE,
    note = "Distances 100% celles des auteurs (dist.mat, verifie symetrique/diag nulle). Le choix k=8 et le style kNN restent une construction projet -- les auteurs utilisent un modele bayesien a coefficients spatialement variables (BSVFM), pas un SAR/W binaire classique. county_key (nom seul) est ambigu (collision inter-etats, ex. Adair IA/MO) -- ne pas l'utiliser comme cle de jointure, utiliser CountyI.",
    built = as.character(Sys.Date())
  ),
  out_path
)
cat("Ecrit :", out_path, "\n")
cat("n_units:", nrow(W), " row sums range:", range(rowSums(W)), "\n")
