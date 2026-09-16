# =============================================================================
# reconstruct_env_covariates_biomass_rainforest.R
# -----------------------------------------------------------------------------
# Reconstruit les covariables environnementales du modele publie pour le
# dataset `paper_biomass_rainforest` (Guitet et al. 2015, PLOS ONE,
# DOI 10.1371/journal.pone.0138456 ; Dryad DOI 10.5061/dryad.38578).
#
# Formule publiee (fiche wiki/datasets/fiches_datasets/paper_biomass_rainforest.md,
# Bloc 1) :
#   AGB_plot(s) = mu + sum_e gamma_e * x_e(s) + k(s)
#   x_terms_pub: LANDScapes, HAND, LOG, GEOL, VEGET, ALT, SLO, spatial_kriging_residual
#
# Le .rds local (data/final_datasets/sf/paper_biomass_rainforest.rds) ne contient
# que les coordonnees, la surface, le nombre de tiges et le WSG moyen -- pas les
# covariables environnementales. Ce script les reconstruit pour ALT/SLO/HAND/LOG
# a partir de sources ouvertes, et documente explicitement ce qui reste bloque
# (LANDScapes, GEOL, VEGET).
#
# Sources :
#   - ALT, SLO : mosaique derivee de SRTM (NASA), bucket public AWS Open Data
#     "Terrain Tiles" (elevation-tiles-prod), sans identifiants, via le package
#     R `elevatr`.
#   - HAND, LOG : calcules depuis le meme MNT via WhiteboxTools (package R
#     `whitebox`) -- remplissage des depressions, direction de flux D8,
#     accumulation de flux, extraction du reseau de drainage (seuil ~1 km2),
#     puis `ElevationAboveStream` (methode de Renno et al. pour HAND). LOG est
#     le log de l'aire de bassin versant contributive.
#   - LANDScapes, GEOL : source identifiee (Guyane-SIG / CEBA / BRGM) mais acces
#     restreint ("Please get in touch with a point of contact"). Non contourne.
#   - VEGET : reference identifiee (Gond et al. 2011, carte SPOT-VEGETATION),
#     aucun point d'acces direct trouve lors de la recherche du 2026-08-11.
#
# Limite methodologique assumee : le papier ne precise pas le seuil de reseau
# de drainage ni la resolution native du MNT utilises pour deriver HAND/LOG.
# Le seuil (625 cellules a 40 m, soit ~1 km2) et la resolution (elevatr z=11,
# ~40 m) sont des choix documentes de cette reconstruction, pas une
# reproduction certifiee de la methode originale. A garder en tete pour
# `modeling_evidence.confidence` dans la fiche (ne pas monter a "high" sur
# cette seule base).
#
# Sorties :
#   - data/raw/papers/DataCite_2015_SpatialStructureOfAbove_10_1371_journal_/
#     env_covariates/*.tif (MNT brut, reprojete, pente, et rasters intermediaires
#     whitebox)
#   - data/manifests/papers/paper_biomass_rainforest_env_covariates_2026-08.csv
#     (plot_id x ALT/SLO/HAND/LOG + LANDScapes/GEOL/VEGET marques pending)
# =============================================================================

suppressWarnings(suppressMessages({
  required <- c("sf", "terra", "elevatr", "whitebox")
  missing_pkgs <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_pkgs) > 0) {
    stop(
      sprintf(
        "Packages manquants : %s. Installer avec install.packages(c(%s)).",
        paste(missing_pkgs, collapse = ", "),
        paste(sprintf("'%s'", missing_pkgs), collapse = ", ")
      ),
      call. = FALSE
    )
  }
  library(sf)
  library(terra)
}))

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (basename(current) == "llm-wiki-karpathy") return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Racine llm-wiki-karpathy introuvable.", call. = FALSE)
}

REPO_ROOT <- find_repo_root()

INPUT_RDS <- file.path(REPO_ROOT, "data", "final_datasets", "sf", "paper_biomass_rainforest.rds")
RASTER_DIR <- file.path(REPO_ROOT, "data", "raw", "papers",
                         "DataCite_2015_SpatialStructureOfAbove_10_1371_journal_",
                         "env_covariates")
OUTPUT_CSV <- file.path(REPO_ROOT, "data", "manifests", "papers",
                         "paper_biomass_rainforest_env_covariates_2026-08.csv")
dir.create(RASTER_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(OUTPUT_CSV), recursive = TRUE, showWarnings = FALSE)

PLOT_CRS <- "EPSG:32622"          # WGS 84 / UTM zone 22N, CRS natif du .rds
TARGET_RES_M <- 40                # resolution cible de la reprojection (m)
ELEVATR_ZOOM <- 11                # ~38-40 m/pixel a cette latitude
STREAM_THRESHOLD_CELLS <- 625     # ~1 km2 de bassin versant a 40 m de resolution

# -----------------------------------------------------------------------------
# Etape 1 -- coordonnees des placettes
# -----------------------------------------------------------------------------
# NB : la colonne secondaire `geom_origine` du .rds se serialise en CSV sous la
# forme non echappee "c(x, y)" et decale les colonnes suivantes si on la garde
# telle quelle -- on ne retient donc que les colonnes scalaires propres.
x <- readRDS(INPUT_RDS)
stopifnot(sf::st_crs(x)$epsg == 32622)

plots <- data.frame(
  plot_id = x$ID,
  Xutm = x$Xutm,
  Yutm = x$Yutm
)
cat(sprintf("[1/5] %d placettes chargees depuis %s\n", nrow(plots), INPUT_RDS))

bbox_wgs84 <- sf::st_bbox(sf::st_transform(
  sf::st_as_sf(plots, coords = c("Xutm", "Yutm"), crs = PLOT_CRS), 4326
))
cat(sprintf(
  "      emprise WGS84 : lon [%.4f, %.4f], lat [%.4f, %.4f]\n",
  bbox_wgs84["xmin"], bbox_wgs84["xmax"], bbox_wgs84["ymin"], bbox_wgs84["ymax"]
))

# -----------------------------------------------------------------------------
# Etape 2 -- MNT SRTM (sans identifiants, bucket AWS Open Data via elevatr)
# -----------------------------------------------------------------------------
dem_wgs84_path <- file.path(RASTER_DIR, "srtm_dem_guyane_wgs84.tif")
if (!file.exists(dem_wgs84_path)) {
  margin <- 0.05
  corners <- sf::st_as_sf(
    data.frame(
      lon = c(bbox_wgs84["xmin"] - margin, bbox_wgs84["xmax"] + margin),
      lat = c(bbox_wgs84["ymin"] - margin, bbox_wgs84["ymax"] + margin)
    ),
    coords = c("lon", "lat"), crs = 4326
  )
  dem <- elevatr::get_elev_raster(locations = corners, z = ELEVATR_ZOOM,
                                   prj = sf::st_crs(corners)$wkt, clip = "bbox")
  terra::writeRaster(terra::rast(dem), dem_wgs84_path, overwrite = TRUE)
  cat(sprintf("[2/5] MNT SRTM telecharge -> %s\n", dem_wgs84_path))
} else {
  cat(sprintf("[2/5] MNT SRTM deja present, reutilise -> %s\n", dem_wgs84_path))
}

# -----------------------------------------------------------------------------
# Etape 3 -- reprojection, pente, extraction ALT/SLO
# -----------------------------------------------------------------------------
dem_utm_path <- file.path(RASTER_DIR, "dem_utm22n.tif")
slope_path <- file.path(RASTER_DIR, "slope_utm22n.tif")

dem_wgs84 <- terra::rast(dem_wgs84_path)
dem_utm <- terra::project(dem_wgs84, PLOT_CRS, method = "bilinear", res = TARGET_RES_M)
terra::writeRaster(dem_utm, dem_utm_path, overwrite = TRUE)

slope <- terra::terrain(dem_utm, v = "slope", unit = "degrees")
terra::writeRaster(slope, slope_path, overwrite = TRUE)

pts <- terra::vect(plots, geom = c("Xutm", "Yutm"), crs = PLOT_CRS)
plots$ALT <- terra::extract(dem_utm, pts)[, 2]
plots$SLO <- terra::extract(slope, pts)[, 2]

cat(sprintf(
  "[3/5] ALT [%.1f, %.1f] m ; SLO [%.2f, %.2f] deg ; %d/%d valeurs manquantes\n",
  min(plots$ALT, na.rm = TRUE), max(plots$ALT, na.rm = TRUE),
  min(plots$SLO, na.rm = TRUE), max(plots$SLO, na.rm = TRUE),
  sum(is.na(plots$ALT)) + sum(is.na(plots$SLO)), 2 * nrow(plots)
))

# -----------------------------------------------------------------------------
# Etape 4 -- HAND et LOG (WhiteboxTools)
# -----------------------------------------------------------------------------
# Le binaire WhiteboxTools (Rust) echoue a parser les chemins contenant une
# apostrophe et/ou des espaces (cas de ce depot : ".../johnny D'OLIVEIRA/Travaux
# stages/..."), meme correctement quotes -- panique "os error 3". Contournement :
# on bascule le repertoire de travail whitebox sur le chemin court Windows
# (8.3, sans espace ni caractere special) et on ne passe que des noms de
# fichiers relatifs aux appels wbt_*.
filled_path <- file.path(RASTER_DIR, "dem_filled.tif")
d8ptr_path <- file.path(RASTER_DIR, "d8_pointer.tif")
d8acc_path <- file.path(RASTER_DIR, "d8_accum.tif")
streams_path <- file.path(RASTER_DIR, "streams.tif")
hand_path <- file.path(RASTER_DIR, "hand.tif")

wbt_dir <- if (.Platform$OS.type == "windows") utils::shortPathName(RASTER_DIR) else RASTER_DIR
whitebox::wbt_init()
whitebox::wbt_wd(wbt_dir)

whitebox::wbt_fill_depressions(dem = basename(dem_utm_path), output = basename(filled_path))
whitebox::wbt_d8_pointer(dem = basename(filled_path), output = basename(d8ptr_path))
whitebox::wbt_d8_flow_accumulation(input = basename(filled_path), output = basename(d8acc_path),
                                    out_type = "cells")
whitebox::wbt_extract_streams(flow_accum = basename(d8acc_path), output = basename(streams_path),
                               threshold = STREAM_THRESHOLD_CELLS)
whitebox::wbt_elevation_above_stream(dem = basename(filled_path), streams = basename(streams_path),
                                      output = basename(hand_path))

hand_r <- terra::rast(hand_path)
acc_r <- terra::rast(d8acc_path)
cell_area_m2 <- prod(terra::res(acc_r))

plots$HAND <- terra::extract(hand_r, pts)[, 2]
plots$LOG <- log(terra::extract(acc_r, pts)[, 2] * cell_area_m2 + 1)

cat(sprintf(
  "[4/5] HAND [%.1f, %.1f] m ; LOG [%.2f, %.2f] ; %d/%d valeurs manquantes\n",
  min(plots$HAND, na.rm = TRUE), max(plots$HAND, na.rm = TRUE),
  min(plots$LOG, na.rm = TRUE), max(plots$LOG, na.rm = TRUE),
  sum(is.na(plots$HAND)) + sum(is.na(plots$LOG)), 2 * nrow(plots)
))

# -----------------------------------------------------------------------------
# Etape 5 -- table finale (LANDScapes/GEOL/VEGET marques pending, non inventes)
# -----------------------------------------------------------------------------
plots$LANDScapes <- NA_character_
plots$GEOL <- NA_character_
plots$VEGET <- NA_character_
plots$LANDScapes_status <- "pending_manual_contact"   # Guyane-SIG : acces restreint, contact requis
plots$GEOL_status <- "pending_manual_contact"          # idem (BRGM / Guyane-SIG)
plots$VEGET_status <- "pending_source_not_found"       # Gond et al. 2011 : aucun lien direct trouve

plots <- plots[, c("plot_id", "Xutm", "Yutm", "LANDScapes", "HAND", "LOG", "GEOL", "VEGET",
                    "ALT", "SLO", "LANDScapes_status", "GEOL_status", "VEGET_status")]

write.csv(plots, OUTPUT_CSV, row.names = FALSE)
cat(sprintf("[5/5] Table ecrite -> %s (%d lignes)\n", OUTPUT_CSV, nrow(plots)))
