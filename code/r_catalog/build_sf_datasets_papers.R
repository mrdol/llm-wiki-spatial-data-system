# =============================================================================
# build_sf_datasets_papers.R
# -----------------------------------------------------------------------------
# Conversion en objets sf unifies des jeux de donnees telecharges depuis des
# papiers (inst/kg/paper_dataset_uses.json), en reutilisant la meme convention
# que code/r_catalog/build_sf_datasets.R (famille de packages) : voir
# code/r_catalog/guide_objets_sf.md pour la methodologie.
#
# Contrairement au pipeline packages, il n'y a pas de catalogue tabulaire
# uniforme en entree : chaque dataset a un format brut different (shp+csv,
# rda, netCDF, zip Dryad...). On fournit donc un loader dedie par dataset
# (liste `PAPER_DATASET_LOADERS` ci-dessous), qui renvoie un data.frame/sf brut
# + les noms de colonnes reponse/coordonnees/temps ; le reste (derivation du
# point, CRS differe, classification de la reponse, sortie .rds) reutilise
# telle quelle les fonctions partagees de build_sf_datasets.R.
#
# Sortie : data/final_datasets/sf/paper_<record_id>.rds (meme dossier que le
# pipeline packages, prefixe "paper_" pour eviter toute collision de nom).
# =============================================================================

suppressWarnings(suppressMessages({
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("Le package 'sf' est requis (install.packages('sf')).", call. = FALSE)
  }
  library(sf)
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

# Reutilise les fonctions partagees (geom_family, derive_point_geometry,
# build_unified_sf, classify_response, match_columns, split_fields, ...)
# sans relancer le pipeline packages lui-meme (build_sf_datasets() n'est pas
# appelee ici, seule sa definition est chargee).
source(file.path(REPO_ROOT, "code", "r_catalog", "build_sf_datasets.R"))

OUT_DIR <- file.path(REPO_ROOT, "data", "final_datasets", "sf")
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

# --- Loader MetaComNet --------------------------------------------------
# --- Helper partage : raster (terra) -> points sf, avec agregation ---------
# Reutilise pour tout loader base sur un fichier raster (NetCDF/GeoTIFF).
# `derive_point_geometry()` (build_sf_datasets.R) sait deja transformer une
# "grille" sf en points (st_centroid), mais a l'echelle native d'un raster
# global/continental (millions de cellules) c'est trop fin pour le catalogue
# (les autres jeux de donnees restent de l'ordre du millier a la dizaine de
# milliers de lignes) -> on agrege AVANT de convertir en points, pas apres.
raster_to_points_sf <- function(r, agg_fact = NULL, fun = "mean") {
  if (!is.null(agg_fact) && agg_fact > 1) {
    r <- terra::aggregate(r, fact = agg_fact, fun = fun, na.rm = TRUE)
  }
  pts <- terra::as.points(r, na.rm = TRUE)
  sf::st_as_sf(pts)
}

add_oblique_geographic_coordinates <- function(sf_obj, angles_deg = c(0, 30, 60, 90, 120, 150)) {
  xy <- sf::st_coordinates(sf_obj)
  x <- as.numeric(xy[, 1])
  y <- as.numeric(xy[, 2])
  x <- x - mean(x, na.rm = TRUE)
  y <- y - mean(y, na.rm = TRUE)
  for (angle in angles_deg) {
    theta <- angle * pi / 180
    sf_obj[[paste0("ogc_", sprintf("%03d", angle))]] <- x * cos(theta) + y * sin(theta)
  }
  sf_obj
}
# data/raw/papers/DataCite_2021_MetacomnetARandomForest_10_1111_2041_210/
#   Site_locations.shp            -> geometrie point des 16 sites
#   Sydenham_et_al_MetaComNet_data_frame.csv -> table Y/X (jointure sur Site)
load_metacomnet <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2021_MetacomnetARandomForest_10_1111_2041_210")
  sites <- sf::st_read(file.path(dir, "Site_locations.shp"), quiet = TRUE)
  df <- utils::read.csv(file.path(dir, "Sydenham_et_al_MetaComNet_data_frame.csv"),
                        stringsAsFactors = FALSE)

  # Colonne d'identite de site : deviner le nom dans le shapefile (souvent
  # tronque a 10 caracteres en DBF).
  site_col <- intersect(c("Site", "SITE", "site"), names(sites))
  if (length(site_col) == 0) {
    stop("Colonne 'Site' introuvable dans Site_locations.shp : ",
         paste(names(sites), collapse = ", "), call. = FALSE)
  }
  site_col <- site_col[1]

  merged <- merge(df, sf::st_drop_geometry(sites)[, site_col, drop = FALSE],
                  by.x = "Site", by.y = site_col, all.x = TRUE)
  # merge() casse la classe sf -> reconstruire avec la geometrie par site.
  geo <- sites[match(merged$Site, sites[[site_col]]), ]
  out <- sf::st_sf(merged, geometry = sf::st_geometry(geo))
  list(
    obj = out,
    row = list(
      coordinate_columns = "",
      identifier_variables = "Site,SiteBee,SitePlant,SitePlantBee",
      datetime_columns = "",
      candidate_y_variables = "Number,Occurrence"
    )
  )
}

# --- Loader Cluster Detection (Lee 2016) --------------------------------
# data/raw/papers/DataCite_2016_ClusterDetectionOfSpatial_10_1002_sim_7172/
#   SuppInfo_SoutheastFakeData.RData -> objet SE_FakeData (616 comtes,
#   sud-est des Etats-Unis). D'apres le papier (section "Southeast U.S.A
#   Cancer Mortality Data") : y = log du taux de mortalite cancer
#   (logMortality), x = proportion de population urbaine (purban). NB : ce
#   fichier reproduit la structure spatiale reelle (616 comtes / 7 etats)
#   mais avec des valeurs SIMULEES ("FakeData"), pas les observations
#   reelles (donnees de sante probablement restreintes). A noter dans la
#   fiche dataset.
load_cluster_detection <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2016_ClusterDetectionOfSpatial_10_1002_sim_7172")
  e <- new.env()
  load(file.path(dir, "SuppInfo_SoutheastFakeData.RData"), envir = e)
  df <- e$SE_FakeData
  names(df)[names(df) == "y"] <- "y_response_simulated"
  names(df)[names(df) == "x"] <- "x_covariate_simulated"

  sf_obj <- sf::st_as_sf(df, coords = c("long", "lat"), crs = 4326, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "long,lat",
      identifier_variables = "State,County,FIPS",
      datetime_columns = "",
      candidate_y_variables = "y_response_simulated"
    )
  )
}

# --- Loader Medicago (Yang, Shrestha et al. 2022) -----------------------
# data/raw/papers/DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060/
#   dryad_280gb5mrw_data.zip -> raw_data.xlsx (malgre le nom du README qui
#   annonce un .csv). 8299 cellules de grille 100km x 100km, colonnes X/Y =
#   longitude/latitude du centre de cellule (deja des coordonnees point, pas
#   un polygone). D'apres le README Dryad : reponse = richness (richesse en
#   especes Medicago par cellule), avec les sous-composantes annual/perennial.
load_medicago <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060")
  zip_path <- file.path(dir, "dryad_280gb5mrw_data.zip")
  extract_dir <- file.path(dir, "_extracted")
  if (!dir.exists(extract_dir)) {
    utils::unzip(zip_path, exdir = extract_dir)
  }
  xlsx_path <- list.files(extract_dir, pattern = "raw_data\\.xlsx$",
                          full.names = TRUE, recursive = TRUE)[1]
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Le package 'readxl' est requis pour lire raw_data.xlsx.", call. = FALSE)
  }
  df <- as.data.frame(readxl::read_excel(xlsx_path))

  # X/Y sont deja longitude/latitude : on les consomme comme coordonnees
  # (remove = TRUE) puisque build_unified_sf() reconstruira des colonnes
  # X/Y identiques a partir de la geometrie point derivee.
  sf_obj <- sf::st_as_sf(df, coords = c("X", "Y"), crs = 4326, remove = TRUE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "GRIDCODE,Continent,Biome",
      datetime_columns = "",
      candidate_y_variables = "richness,annual,perennial"
    )
  )
}

# --- Loader Balancing crane (Laxton et al. 2022) -------------------------
# data/raw/papers/DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210/
#   dryad_2z34tmpps_data.zip -> transformed-crane-data.csv. D'apres le README
#   Dryad : ti=index temporel, mark=presence/absence de couple reproducteur
#   (reponse binaire), x/y = UTM easting/northing en km (zone non precisee
#   dans le README -> CRS laisse NA, a confirmer via l'annexe du papier avant
#   toute reprojection). NB : coordonnees "aleatoirement transformees" par
#   les auteurs pour proteger les sites de nidification -- pas les vraies
#   positions.
load_crane <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210")
  extract_dir <- file.path(dir, "_extracted")
  if (!dir.exists(extract_dir)) {
    utils::unzip(file.path(dir, "dryad_2z34tmpps_data.zip"), exdir = extract_dir)
  }
  df <- utils::read.csv(file.path(extract_dir, "transformed-crane-data.csv"),
                        stringsAsFactors = FALSE)
  # km -> m, coherent avec l'unite standard des CRS UTM projetes.
  df$x_m <- df$x * 1000
  df$y_m <- df$y * 1000
  sf_obj <- sf::st_as_sf(df, coords = c("x_m", "y_m"), crs = NA, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "x,y,x_m,y_m",
      identifier_variables = "",
      datetime_columns = "ti",
      candidate_y_variables = "mark"
    )
  )
}

# --- Loader Regulatory Convergence (Jones & Zeitz 2019) -------------------
# data/raw/papers/DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0/
#   AA-workingdata.tab -> panel pays x annee (2863 lignes), colonne "iso" en
#   code numerique M49 (ex. 4 = Afghanistan). Geometrie absente du
#   telechargement (donnees de panel, pas de fichier spatial) : jointure sur
#   les frontieres pays de spData::world (iso_a2) via countrycode::countrycode().
load_regulatory_convergence <- function() {
  if (!requireNamespace("countrycode", quietly = TRUE) ||
      !requireNamespace("spData", quietly = TRUE)) {
    stop("Packages 'countrycode' et 'spData' requis pour la jointure pays.", call. = FALSE)
  }
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0",
                    "AA-workingdata.tab")
  df <- utils::read.delim(path, stringsAsFactors = FALSE)
  df$iso_a2 <- suppressWarnings(countrycode::countrycode(df$iso, "un", "iso2c"))

  utils::data(world, package = "spData", envir = environment())
  world_min <- world[, c("iso_a2", "geom")]
  merged <- merge(df, sf::st_drop_geometry(world_min), by = "iso_a2", all.x = TRUE)
  geo <- world_min$geom[match(merged$iso_a2, world_min$iso_a2)]
  sf_obj <- sf::st_sf(merged, geometry = geo)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "iso,iso_a2,country,year",
      datetime_columns = "year",
      candidate_y_variables = "net_bcbs"
    )
  )
}

# --- Loader eberg (Moller 2020, via package R plotKML) ---------------------
# eberg.rda contient un data.frame brut (pas un objet sp), colonnes X/Y deja
# presentes (CRS non documente dans le package -> laisse NA, a confirmer).
# D'apres Moller et al. (2020) : "we mapped soil types" -> reponse = TAXGRSC
# (groupe taxonomique du sol, categoriel).
load_eberg <- function() {
  tarball <- file.path(REPO_ROOT, "data", "raw", "papers", "Moller_2020_OGC_eberg",
                       "plotKML_0.8-3.tar.gz")
  extract_dir <- file.path(dirname(tarball), "_extracted")
  if (!file.exists(file.path(extract_dir, "plotKML", "data", "eberg.rda"))) {
    utils::untar(tarball, files = "plotKML/data/eberg.rda", exdir = extract_dir)
  }
  e <- new.env()
  load(file.path(extract_dir, "plotKML", "data", "eberg.rda"), envir = e)
  df <- e$eberg
  sf_obj <- sf::st_as_sf(df, coords = c("X", "Y"), crs = NA, remove = TRUE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ID,soiltype",
      datetime_columns = "",
      candidate_y_variables = "TAXGRSC"
    )
  )
}

# --- Loader Swiss rainfall / SIC97 (Moller 2020, via package R gstat) -----
# sic97.rda contient 3 objets sp : demstd (grille DEM, sans rapport),
# sic_full (467 points, toutes les mesures) et sic_obs (sous-ensemble de 100
# points). Moller et al. (2020) citent 476 mesures -> sic_full (467) est la
# correspondance la plus proche disponible dans le package.
load_swiss_rainfall <- function() {
  tarball <- file.path(REPO_ROOT, "data", "raw", "papers", "Moller_2020_OGC_swiss_rainfall",
                       "gstat_2.1-6.tar.gz")
  extract_dir <- file.path(dirname(tarball), "_extracted")
  if (!file.exists(file.path(extract_dir, "gstat", "data", "sic97.rda"))) {
    utils::untar(tarball, files = "gstat/data/sic97.rda", exdir = extract_dir)
  }
  e <- new.env()
  load(file.path(extract_dir, "gstat", "data", "sic97.rda"), envir = e)
  obj <- e$sic_full
  sf_obj <- if (inherits(obj, "sf")) obj else sf::st_as_sf(obj)
  sf_obj <- add_oblique_geographic_coordinates(sf_obj)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ID",
      datetime_columns = "",
      candidate_y_variables = "rainfall"
    )
  )
}

# --- Loader Vindum (Moller 2020 / Pouladi 2019) ---------------------------
# La declaration "Code and data availability" du papier Moller (2020) renvoie
# vers l'archive Zenodo, mais celle-ci ne contient QUE le code : les dossiers
# Vindum/buffers, Vindum/EDF sont vides. Les vraies donnees (data('Vindum_SOM'))
# sont chargees par le script depuis le package R "OGC"
# (install_bitbucket('abmoeller/ogc/rPackage/OGC')), recuperees ici
# directement via l'API Bitbucket plutot que via un `remotes::install_bitbucket`.
load_vindum <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers", "Moller_2020_OGC_vindum")
  e <- new.env()
  load(file.path(dir, "Vindum_SOM.rda"), envir = e)
  obj <- e$Vindum_SOM  # SpatialPointsDataFrame : ID, SOM

  cov_path <- file.path(dir, "Vindum_covariates.rda")
  if (file.exists(cov_path)) {
    if (!requireNamespace("raster", quietly = TRUE)) {
      stop("Package 'raster' is required to extract Vindum_covariates.")
    }
    cov_env <- new.env()
    load(cov_path, envir = cov_env)
    covariates <- cov_env$Vindum_covariates
    cov_df <- raster::extract(covariates, obj, df = TRUE, sp = FALSE)
    cov_df <- cov_df[, setdiff(names(cov_df), "ID"), drop = FALSE]
    names(cov_df) <- make.names(names(cov_df), unique = TRUE)
    obj@data <- cbind(obj@data, cov_df)
  }

  sf_obj <- sf::st_as_sf(obj)
  sf_obj <- add_oblique_geographic_coordinates(sf_obj)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ID",
      datetime_columns = "",
      candidate_y_variables = "SOM"
    )
  )
}

# --- Loader Maipo (Brenning 2023, via depot GitHub spdiag) -----------------
# run_maipo.rda contient l'objet data.frame `d` prepare par spdiag_maipo.R
# a partir de data("maipo", package="sperrorest") : x/y (UTM), croptype
# (reponse), field, covariables spectrales nd.i0.*/b0-99.
load_maipo <- function() {
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "Brenning_2023_SpatialMLDiagnostics_maipo", "run_maipo.rda")
  e <- new.env()
  load(path, envir = e)
  df <- e$d
  sf_obj <- sf::st_as_sf(df, coords = c("x", "y"), crs = NA, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "x,y,utmx,utmy",
      identifier_variables = "field",
      datetime_columns = "",
      candidate_y_variables = "croptype"
    )
  )
}

# --- Loader Ethiopia stunting clusters (Seboka 2022) ----------------------
# La premiere passe n'avait recupere que "Additional file 2" (figshare
# 20236415), qui ne contient que 3 GIF. Le vrai tableau spatial est dans
# "Additional file 1" (figshare 20236412, non recupere par la moulinette
# DataCite initiale), extrait ici en ethiopia_stunting_clusters.csv (voir
# scratchpad/extract_ethiopia_clusters.py) : 8 clusters SaTScan significatifs
# de retard de croissance (stunting), 3 vagues EDHS (2011/2016/2019), avec
# centre du cluster (lat/lon), rayon, population, cas, RR, LLR, p-value.
# NB : ce n'est PAS la donnee d'enquete individuelle (EDHS reste a acces
# restreint), seulement les clusters agreges publies par les auteurs.
load_ethiopia_clusters <- function() {
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2022_SpatialTrendsAndProjections_10_1186_s41043_0",
                    "ethiopia_stunting_clusters.csv")
  df <- utils::read.csv(path, stringsAsFactors = FALSE)
  df <- df[!is.na(suppressWarnings(as.numeric(df$lat))) &
           !is.na(suppressWarnings(as.numeric(df$lon))), ]
  df$lat <- as.numeric(df$lat)
  df$lon <- as.numeric(df$lon)
  df$RR <- as.numeric(df$RR)
  df$cases <- as.numeric(df$cases)
  df$population <- as.numeric(df$population)

  sf_obj <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "cluster,year",
      datetime_columns = "year",
      candidate_y_variables = "RR,cases"
    )
  )
}

# --- Loader Waste Site meta-regression (Schutt 2021) -----------------------
# Le fichier "Meta_dataset.tab" tabularise par Dataverse ne contenait que la
# feuille "Reader's guide". Le fichier original multi-feuilles (recupere via
# l'API Dataverse ?format=original) contient la vraie feuille "Stata" : 727
# estimations d'effet (une ligne = une etude/regression), colonne "country"
# (texte, 14 pays, majorite USA) mais pas de coordonnees precises -> jointure
# pays sur spData::world (meme technique que Regulatory Convergence). Reponse
# candidate : elas (elasticite estimee de l'effet du site de dechets sur les
# prix immobiliers).
load_waste_site <- function() {
  if (!requireNamespace("readxl", quietly = TRUE) ||
      !requireNamespace("countrycode", quietly = TRUE) ||
      !requireNamespace("spData", quietly = TRUE)) {
    stop("Packages 'readxl', 'countrycode' et 'spData' requis.", call. = FALSE)
  }
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2021_SystematicVariationInWaste_10_1007_s10640_0",
                    "Meta_dataset_original.xlsx")
  df <- as.data.frame(readxl::read_excel(path, sheet = "Stata"))
  df$iso_a2 <- suppressWarnings(countrycode::countrycode(df$country, "country.name", "iso2c"))

  utils::data(world, package = "spData", envir = environment())
  world_min <- world[, c("iso_a2", "geom")]
  geo <- world_min$geom[match(df$iso_a2, world_min$iso_a2)]
  sf_obj <- sf::st_sf(df, geometry = geo)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ID_Study,ID_Est,ID_Uni,ID_regress,iso_a2,country",
      datetime_columns = "year_publish",
      candidate_y_variables = "elas"
    )
  )
}

# --- Loader Above-ground biomass rainforest (Guitet 2015) ------------------
# DataAGB.xlsx (Dryad) contient les inventaires bruts (classes de DBH +
# simulations de densite de bois "WSG"). Le supplement PLOS S1_Dataset_AGB.xlsx
# contient les 1000 simulations AGB par placette : on en tire AGB_mean, la
# reponse locale executable. Deux reseaux de placettes : "P" (CTFT, 1974-1976,
# 2010 placettes dont seulement 1172 georeferencees) et "H" (ONF, 2006-2013,
# 1335 placettes, TOUTES georeferencees et couplees a DBHhab + WSGhab). On
# retient le reseau H (couverture complete XY/DBH/WSG/AGB) et on derive aussi
# deux variables descriptives directement disponibles : nombre total de tiges
# par placette (n_stems, structure) et WSG moyen (mean_wsg).
# CRS : readme indique "WSG1984 -UTM22N" (coquille pour WGS1984) -> EPSG:32622.
load_biomass_rainforest <- function() {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Package 'readxl' requis.", call. = FALSE)
  }
  raw_dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                       "DataCite_2015_SpatialStructureOfAbove_10_1371_journal_")
  path <- file.path(raw_dir, "_extracted", "DataAGB.xlsx")
  agb_path <- file.path(raw_dir, "plos_supplements", "S1_Dataset_AGB.xlsx")

  xy <- as.data.frame(readxl::read_excel(path, sheet = "XYplot"))
  xy <- xy[grepl("^H", xy$ID), ]
  xy$Xutm <- as.numeric(xy$Xutm)
  xy$Yutm <- as.numeric(xy$Yutm)
  xy$area_ha <- as.numeric(xy[["Area (ha)"]])
  xy[["Area (ha)"]] <- NULL

  dbh <- as.data.frame(readxl::read_excel(path, sheet = "DBHhab"))
  names(dbh)[names(dbh) == "DBH class"] <- "DBHclass"
  stems <- stats::aggregate(N ~ ID, data = dbh, sum)
  names(stems) <- c("ID", "n_stems")

  wsg <- suppressMessages(as.data.frame(readxl::read_excel(
    path, sheet = "WSGhab", col_names = FALSE, skip = 1)))
  sims <- sapply(wsg[, 2:ncol(wsg)], as.numeric)
  mean_wsg <- data.frame(ID = wsg[[1]], mean_wsg = rowMeans(sims, na.rm = TRUE))

  agb <- as.data.frame(readxl::read_excel(agb_path, sheet = "AGB_distribution_chave_Hab2014"))
  names(agb)[names(agb) == "parcs"] <- "ID"
  agb <- agb[grepl("^H", agb$ID), ]
  agb_sim_cols <- setdiff(names(agb), c("ID", "Surf", "Xutm", "Yutm"))
  agb_sims <- sapply(agb[, agb_sim_cols], as.numeric)
  agb_mean <- data.frame(ID = agb$ID, AGB_mean = rowMeans(agb_sims, na.rm = TRUE))

  df <- merge(xy, stems, by = "ID", all.x = TRUE)
  df <- merge(df, mean_wsg, by = "ID", all.x = TRUE)
  df <- merge(df, agb_mean, by = "ID", all.x = TRUE)

  env_path <- file.path(
    REPO_ROOT, "data", "manifests", "papers",
    "paper_biomass_rainforest_env_covariates_2026-08.csv"
  )
  if (file.exists(env_path)) {
    env <- utils::read.csv(env_path, stringsAsFactors = FALSE, check.names = FALSE)
    keep <- intersect(c("plot_id", "ALT", "SLO", "HAND", "LOG"), names(env))
    env <- env[, keep, drop = FALSE]
    names(env)[names(env) == "plot_id"] <- "ID"
    for (v in setdiff(names(env), "ID")) env[[v]] <- as.numeric(env[[v]])
    df <- merge(df, env, by = "ID", all.x = TRUE)
  }

  sf_obj <- sf::st_as_sf(df, coords = c("Xutm", "Yutm"), crs = 32622, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Xutm,Yutm",
      identifier_variables = "ID",
      datetime_columns = "",
      candidate_y_variables = "AGB_mean"
    )
  )
}

# --- Loader Wald Test replication (Juhl 2020) -------------------------------
# WW2015_Data.Rdata reprend les donnees de Williams & Whitten (2015) : panel
# de 1428 observations parti x election dans 23 democraties occidentales
# (Canada, UE-15+, Suisse, Norvege, Islande, Israel, Japon, Australie,
# Nouvelle-Zelande), avec une colonne `ccode` (code pays COW) mais
# `countryname` vide. Les matrices W_high/W_low (398x398 et 1030x1030,
# cf. EmpiricalExample.R) sont des matrices de proximite POLITIQUE (pas
# geographique) utilisees pour l'econometrie spatiale du papier - on ne les
# reutilise donc pas comme geometrie. Geometrie assignee ici par pays (via
# ccode -> iso2c -> spData::world), meme technique que Regulatory Convergence
# et Waste Site. Reponse : `change` (variation de depenses publiques, cf.
# `change ~ rgdppc_growth + ...` dans EmpiricalExample.R).
load_wald_test <- function() {
  if (!requireNamespace("countrycode", quietly = TRUE) ||
      !requireNamespace("spData", quietly = TRUE)) {
    stop("Packages 'countrycode' et 'spData' requis pour la jointure pays.", call. = FALSE)
  }
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2020_TheWaldTestOf_10_1017_pan_2020", "WW2015_Data.Rdata")
  e <- new.env()
  load(path, envir = e)
  df <- e$data
  df$iso_a2 <- suppressWarnings(countrycode::countrycode(df$ccode, "cown", "iso2c"))

  utils::data(world, package = "spData", envir = environment())
  world_min <- world[, c("iso_a2", "geom")]
  geo <- world_min$geom[match(df$iso_a2, world_min$iso_a2)]
  sf_obj <- sf::st_sf(df, geometry = geo)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ccode,iso_a2,party,ts",
      datetime_columns = "ts",
      candidate_y_variables = "change"
    )
  )
}

# --- Loader UK photovoltaic FIT (Balta-Ozkan 2015) --------------------------
# Le zip Mendeley (fthhmvgm6r) ne contient que le script Stata, pas la donnee ;
# le fichier gov.uk initialement recupere n'etait qu'un total national agrege
# (aucune ventilation geographique). Le papier (section 5.1, Table 4) precise
# la vraie source : le "Central FIT Register" Ofgem, niveau installation
# (postcode, local authority, GOR, LLSOA), agrege par les auteurs au NUTS3
# (134 regions GB), sur les installations PV domestiques <10kW au 30/06/2013.
# On recupere ici le rapport Ofgem officiel le plus proche disponible
# (31/03/2013, 3 mois avant la date exacte du papier) et on agrege par Local
# Authority (380 LAD, disponible directement dans les donnees, pas de
# jointure LLSOA->NUTS3 necessaire) plutot que NUTS3 - simplification
# documentee du niveau de zonage, meme source et meme filtre que le papier.
# Frontieres : ONS Open Geography Portal, Local Authority Districts
# (December 2013) Boundaries GB BFC (meme millesime que le registre).
load_uk_photovoltaic <- function() {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Package 'readxl' requis.", call. = FALSE)
  }
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_")
  df <- as.data.frame(readxl::read_excel(
    file.path(dir, "ofgem_fit_installation_report_31mar2013.xlsx"), sheet = 1, skip = 1))

  df_pv <- df[df$`Technology Type` == "Photovoltaic" &
              df$`Installation Type` == "Domestic" &
              !is.na(df$`Installed Capacity (kW)`) &
              df$`Installed Capacity (kW)` <= 10 &
              df$`Local Authority` != "UnKnown" &
              !is.na(df$`Local Authority`), ]

  # Alignement des noms de Local Authority avec LAD13NM (ecarts orthographiques
  # mineurs : "&" vs "and", ordre virgule pour Edinburgh/Rhondda)
  recode <- c("Argyll & Bute" = "Argyll and Bute",
              "Dumfries & Galloway" = "Dumfries and Galloway",
              "Edinburgh, City of" = "City of Edinburgh",
              "Perth & Kinross" = "Perth and Kinross",
              "Rhondda, Cynon, Taff" = "Rhondda Cynon Taf",
              "The Vale of Glamorgan" = "Vale of Glamorgan")
  la <- df_pv$`Local Authority`
  matched <- la %in% names(recode)
  la[matched] <- recode[la[matched]]
  df_pv$LAD13NM <- la

  agg <- stats::aggregate(
    cbind(n_installations = rep(1, nrow(df_pv)),
          total_capacity_kw = df_pv$`Installed Capacity (kW)`) ~ LAD13NM,
    data = df_pv, sum)

  lad <- sf::st_read(file.path(dir, "lad_2013_boundaries_gb_bfc.geojson"), quiet = TRUE)
  lad_min <- lad[, c("LAD13CD", "LAD13NM", "geometry")]
  sf_obj <- merge(lad_min, agg, by = "LAD13NM", all.x = TRUE)
  sf_obj$n_installations[is.na(sf_obj$n_installations)] <- 0
  sf_obj$total_capacity_kw[is.na(sf_obj$total_capacity_kw)] <- 0

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "LAD13CD,LAD13NM",
      datetime_columns = "",
      candidate_y_variables = "n_installations,total_capacity_kw"
    )
  )
}

# --- Loader mammifÃƒÂ¨res SR/PD (Barreto et al. 2019) --------------------------
# all_data.shp : grille terrestre quasi-globale (17151 cellules) issue du
# script GWPath_Barreto_et_al_2019.R (path analysis geographiquement
# ponderee). Colonnes SR (richesse specifique) et PD (diversite
# phylogenetique) sont les variables reponse etudiees ; PD_1..PD_999 sont des
# replicats de randomisation (null model pour SES.PD) ecartes ici pour ne pas
# alourdir le fichier de sortie (~1000 colonnes) - non utiles au catalogue.
# On conserve les predicteurs (LGM_vel, Temp, AET, Elev) et les coefficients
# de path analysis calcules par les auteurs (d_*, R2_*, res_*, i_*, t_*).
# CRS absent du shapefile (pas de .prj dans l'archive Dryad) ; l'emprise
# (-181/-52 a 179/83 degres) est neanmoins caracteristique d'une grille
# lon/lat WGS84 standard en ecologie globale -> assigne en EPSG:4326.
load_mammals_sr_pd <- function() {
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2019_EnvironmentalFactorsExplainThe_10_1111_geb_1299",
                    "_extracted", "all_data.shp")
  d <- sf::st_read(path, quiet = TRUE)
  pd_cols <- grep("^PD_[0-9]+$", names(d), value = TRUE)
  d <- d[, !(names(d) %in% pd_cols)]
  sf::st_crs(d) <- 4326

  list(
    obj = d,
    row = list(
      coordinate_columns = "",
      identifier_variables = "ID",
      datetime_columns = "",
      candidate_y_variables = "SR,PD"
    )
  )
}

# --- Loader Beta0 GWR temperature (Xu et al. 2018) --------------------------
# Coeffs_GWR_b0.nc : grille globale 0.05 degre (3600x7200), 12 couches
# (b0 mensuel de la regression geographiquement ponderee utilisee pour la
# desagregation satellite/stations de temperature de l'air). Fichier deja
# complet et minimal (rien a retirer). ~8.9M cellules terrestres non-NA au
# resolution native -> beaucoup trop pour le catalogue (autres jeux de
# donnees : dizaines de milliers de lignes max) ; agrege a 1 degre (facteur
# 20, moyenne) avant conversion en points, ce qui ramene a ~25k cellules
# tout en preservant la structure spatiale globale.
load_beta0_gwr <- function() {
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Package 'terra' requis.", call. = FALSE)
  }
  path <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2018_AGlobalDatasetOf_10_1038_sdata_20", "Coeffs_GWR_b0.nc")
  r <- terra::rast(path)
  names(r) <- paste0("b0_month", sprintf("%02d", 1:12))
  r_annual <- terra::app(r, mean, na.rm = TRUE)
  names(r_annual) <- "b0_annual_mean"
  sf_obj <- raster_to_points_sf(r_annual, agg_fact = 20)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "b0_annual_mean"
    )
  )
}

# --- Loaders PM2.5 / O3 / NO2 (Harvard Chan ensemble grids, Di/Requia et al.) -
# Chaque archive Dataverse contient un fichier grid.csv/grid.gpkg (coordonnees
# des 11.2M points) SEPARE des fichiers <polluant>-<annee>.dat (juste un
# vecteur de valeurs, sans coordonnees, dans le meme ordre que grid.csv) - le
# README precise explicitement cet appariement positionnel. Seul grid.csv
# manquait initialement (telecharge le 2026-08-08, ~370 Mo/dataset, avec
# accord explicite). On ne garde qu'une seule annee (2016, la plus recente)
# sur les 17 disponibles (2000-2016) - suffisant pour le catalogue, les 16
# autres ne sont pas necessaires. 11.2M points bruts -> sous-echantillonnage
# systematique (1 point sur 400, ~28k points) pour rester a l'echelle des
# autres jeux de donnees du catalogue.
load_pollution_grid <- function(dir_name, dat_file, value_col) {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers", dir_name)
  grid <- utils::read.csv(file.path(dir, "grid.csv"), stringsAsFactors = FALSE)
  vals <- scan(file.path(dir, dat_file), what = numeric(), quiet = TRUE)
  stopifnot(nrow(grid) == length(vals))
  grid[[value_col]] <- vals

  keep <- seq(1, nrow(grid), by = 400)
  grid <- grid[keep, ]

  sf_obj <- sf::st_as_sf(grid, coords = c("lon", "lat"), crs = 4326, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "idx",
      datetime_columns = "",
      candidate_y_variables = value_col
    )
  )
}

load_pm25_grid <- function() {
  load_pollution_grid("DataCite_2019_AnEnsembleBasedModel_10_1016_j_envint",
                       "PM25-2016.dat", "PM25_2016")
}

load_o3_grid <- function() {
  load_pollution_grid("DataCite_2020_AnEnsembleLearningApproach_10_1021_acs_est_",
                       "O3-2016.dat", "O3_2016")
}

load_no2_grid <- function() {
  load_pollution_grid("DataCite_2019_AssessingNo2Concentration_10_1021_acs_est_",
                       "NO2-2016.dat", "NO2_2016")
}

# --- Loader Pallid bat morphologie (Snyder & Terry 2018) --------------------
# L'archive Dryad (765 Mo) contient 788 photos de crane (utilisees par les
# auteurs pour digitaliser les landmarks TPS) et 2 fichiers TPS_Landmarks
# (lateral_skull.tps, ventral_skull.TPS) avec les coordonnees de landmarks en
# pixels + nom d'image (ex. "anpa_lacm_11659_..."), mais AUCUNE coordonnee
# geographique de specimen. Le nom d'image encode le code d'institution
# museale (lacm/msb/mvz/psm/uwbm) + numero de catalogue -> localite recuperee
# via l'API GBIF (scientificName=Antrozous pallidus, institutionCode=X),
# catalogNumber au format GBIF "INST:Coll:NUM" -> on matche sur le suffixe
# numerique. 190/196 specimens retrouves avec coordonnees (cache dans
# gbif_pallid_lookup.json, cf. scratchpad/gbif_lookup_pallid_bat.py).
# Reponse : centroid_size (taille geometrique-morphometrique standard,
# distance quadratique moyenne des landmarks au centroide), calculee
# directement depuis les landmarks bruts de lateral_skull.tps (188 specimens,
# vue la plus complete) - pas besoin de superposition Procuste pour la taille
# seule. Coordonnees CRS=4326 (GBIF fournit decimalLatitude/Longitude WGS84).
parse_tps <- function(path) {
  lines <- readLines(path, warn = FALSE)
  specimens <- list()
  i <- 1
  while (i <= length(lines)) {
    if (startsWith(lines[i], "LM=")) {
      n <- as.integer(sub("LM=", "", lines[i]))
      coords <- utils::read.table(text = lines[(i + 1):(i + n)])
      image_line <- lines[i + n + 1]
      image <- sub("IMAGE=", "", image_line)
      specimens[[length(specimens) + 1]] <- list(image = image, coords = coords)
      i <- i + n + 3
    } else {
      i <- i + 1
    }
  }
  specimens
}

load_pallid_bat <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243",
                   "_extracted_tmp")
  specimens <- parse_tps(file.path(dir, "lateral_skull.tps"))
  lookup <- jsonlite::fromJSON(file.path(dir, "gbif_pallid_lookup.json"))

  rows <- lapply(specimens, function(s) {
    m <- regmatches(s$image, regexec("^anpa_([a-z]+)_([0-9]+)_", s$image))[[1]]
    if (length(m) != 3) return(NULL)
    inst <- m[2]
    num <- m[3]
    key <- paste0(inst, "|", sub("^0+", "", num))
    if (is.null(lookup[[key]]) || is.null(lookup[[key]]$lat)) return(NULL)
    xy <- as.matrix(s$coords)
    centroid <- colMeans(xy)
    centroid_size <- sqrt(sum(rowSums(sweep(xy, 2, centroid)^2)))
    data.frame(institution = inst, catalog_number = num,
               lat = lookup[[key]]$lat, lon = lookup[[key]]$lon,
               centroid_size = centroid_size)
  })
  df <- do.call(rbind, rows)

  sf_obj <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)

  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis pour joindre les rasters environnementaux Pallid bat.",
         call. = FALSE)
  }

  raw_dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                       "DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243")
  outer_zip <- file.path(raw_dir, "dryad_c5805_data.zip")
  inner_zip <- file.path(dir, "data.zip")
  if (!file.exists(inner_zip)) {
    utils::unzip(outer_zip, files = "data.zip", exdir = dir)
  }
  env_files <- c(
    "data/environmental_variables/bio4.bil",
    "data/environmental_variables/bio4.hdr",
    "data/environmental_variables/bio5.bil",
    "data/environmental_variables/bio5.hdr",
    "data/environmental_variables/bio6.bil",
    "data/environmental_variables/bio6.hdr",
    "data/environmental_variables/bio15.bil",
    "data/environmental_variables/bio15.hdr",
    "data/environmental_variables/MOD17A3_Science_NPP_mean_00_14.tif"
  )
  missing_env <- env_files[!file.exists(file.path(dir, env_files))]
  if (length(missing_env)) {
    utils::unzip(inner_zip, files = missing_env, exdir = dir)
  }

  env_dir <- file.path(dir, "data", "environmental_variables")
  env_rasters <- list(
    NPP = terra::rast(file.path(env_dir, "MOD17A3_Science_NPP_mean_00_14.tif")),
    MinWinTemp = terra::rast(file.path(env_dir, "bio6.bil")),
    MaxSumTemp = terra::rast(file.path(env_dir, "bio5.bil")),
    TempSeas = terra::rast(file.path(env_dir, "bio4.bil")),
    PrecSeas = terra::rast(file.path(env_dir, "bio15.bil"))
  )
  pts <- terra::vect(sf_obj)
  env_values <- lapply(names(env_rasters), function(name) {
    raster <- env_rasters[[name]]
    pts_projected <- terra::project(pts, terra::crs(raster))
    values <- terra::extract(raster, pts_projected, method = "bilinear", ID = FALSE)[[1]]
    stats::setNames(data.frame(values), name)
  })
  env_values <- do.call(cbind, env_values)
  env_values$MinWinTemp <- env_values$MinWinTemp / 10
  env_values$MaxSumTemp <- env_values$MaxSumTemp / 10
  env_values$TempSeas <- env_values$TempSeas / 100
  sf_obj <- cbind(sf_obj, env_values)
  sf_obj <- sf_obj[stats::complete.cases(sf::st_drop_geometry(sf_obj)[, names(env_values), drop = FALSE]), ]

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "institution,catalog_number",
      datetime_columns = "",
      candidate_y_variables = "centroid_size"
    )
  )
}

# --- Loader colibris SDM integre (MÃƒÂ¤kinen et al. 2023) ----------------------
# L'archive Dryad (559 Mo) contient des rasters environnementaux locaux
# (CHELSA et EVI) et des zones d'etude. Le README indique que certains
# fichiers de l'article ont ete retires "due to licensing concerns" :
# observations PA Map of Life, certains PO, cloud cover et TRI doivent etre
# recuperes depuis leurs sources originales. On utilise donc ici :
# - une extraction GBIF directe de colibris, deja presente localement ;
# - les covariables CHELSA/EVI vraiment presentes dans Data.zip.
# Le .rds reste une reconstruction benchmarkable partielle, pas la table
# complete des 71 SDM du papier.
load_hummingbird_sdm <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379")
  path <- file.path(dir, "_extracted", "gbif_hummingbird_occurrences.csv")
  df <- utils::read.csv(path, stringsAsFactors = FALSE)
  df <- df[!is.na(df$lat) & !is.na(df$lon) & nzchar(df$species), ]

  cell <- 1
  df$cell_lon <- floor(df$lon / cell) * cell + cell / 2
  df$cell_lat <- floor(df$lat / cell) * cell + cell / 2

  agg <- stats::aggregate(
    species ~ cell_lon + cell_lat,
    data = df, FUN = function(x) length(unique(x)))
  names(agg)[3] <- "species_richness"
  n_occ <- stats::aggregate(species ~ cell_lon + cell_lat, data = df, FUN = length)
  agg$n_occurrences <- n_occ$species[match(paste(agg$cell_lon, agg$cell_lat),
                                            paste(n_occ$cell_lon, n_occ$cell_lat))]

  sf_obj <- sf::st_as_sf(agg, coords = c("cell_lon", "cell_lat"), crs = 4326, remove = FALSE)

  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis pour joindre les rasters Dryad hummingbird.",
         call. = FALSE)
  }

  data_zip <- file.path(dir, "_extracted", "Data.zip")
  data_dir <- file.path(dir, "_extracted", "Data")
  if (!file.exists(data_zip)) {
    utils::unzip(file.path(dir, "dryad_k98sf7mdg_data.zip"),
                 files = "Data.zip",
                 exdir = file.path(dir, "_extracted"))
  }
  needed <- c(
    "Data/Environment/Chelsa_SA.tif",
    "Data/EVI/Annual_EVI_resampled_NA30x30_americas.tif"
  )
  missing <- needed[!file.exists(file.path(data_dir, needed))]
  if (length(missing)) {
    utils::unzip(data_zip, files = missing, exdir = data_dir)
  }

  chelsa <- terra::rast(file.path(data_dir, "Data", "Environment", "Chelsa_SA.tif"))
  names(chelsa) <- c(
    "annual_mean_temperature",
    "mean_diurnal_range",
    "annual_precipitation",
    "precipitation_seasonality"
  )
  evi <- terra::rast(file.path(data_dir, "Data", "EVI",
                               "Annual_EVI_resampled_NA30x30_americas.tif"))
  names(evi) <- "evi_annual"

  pts <- terra::vect(sf_obj)
  pts <- terra::project(pts, terra::crs(chelsa))
  env_values <- terra::extract(c(chelsa, evi), pts, ID = FALSE)
  env_values <- as.data.frame(env_values)
  sf_obj <- cbind(sf_obj, env_values)

  complete_env <- stats::complete.cases(sf::st_drop_geometry(sf_obj)[, names(env_values), drop = FALSE])
  sf_obj <- sf_obj[complete_env, ]
  sf_obj$log1p_species_richness <- log1p(sf_obj$species_richness)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "cell_lon,cell_lat",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "log1p_species_richness,species_richness,n_occurrences"
    )
  )
}


# --- Loader spruce bark beetle (Gohli et al. 2024) --------------------------
# Dryad 10.5061/dryad.kd51c5bdc : 1 731 pheromone-trap observations in
# southern Norway (2004-2021). README explicitly documents latitude/longitude,
# trapcounts and covariates: elevation, spruce volume, vegetation zone,
# clearcut border, temperature, precipitation and soil moisture.
load_spruce_bark_beetle <- function() {
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266",
                        "dryad_kd51c5bdc_v20240201.zip")
  df <- utils::read.csv2(unz(zip_path, "dryad.csv"), stringsAsFactors = FALSE)
  df$veg_zone <- as.factor(df$veg_zone)
  sf_obj <- sf::st_as_sf(df, coords = c("east", "north"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "east,north",
      identifier_variables = "",
      datetime_columns = "year",
      candidate_y_variables = "trapcounts"
    )
  )
}

# --- Loader Florida crash GSVCM (Wu et al. 2020) ----------------------------
# Supplementary code for generalized spatially varying coefficient models.
# main_GSVCM_application.R defines y=Offcrsh, S=(Lon,Lat), and X = log.VMT,
# log.Pop, Rmale, Rhisp, Rold, Runemploy for a Florida crash-count application.
load_florida_crash_gsvcm <- function() {
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2020_GeneralizedSpatiallyVaryingCoefficient_10_1080_10618600",
                        "ucgs_a_1754225_sm8959.zip")
  df <- utils::read.csv(unz(zip_path, "Code/data/Crash_Florida.csv"),
                        stringsAsFactors = FALSE, check.names = TRUE)
  sf_obj <- sf::st_as_sf(df, coords = c("Lon", "Lat"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Lon,Lat",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "Offcrsh"
    )
  )
}

# --- Loader possum body size (Kelly et al. 2015/2018 dataset) ---------------
# Dryad 10.5061/dryad.gq264 : Trichosurus vulpecula specimens with continuous
# body-size response CBL, coordinates, island type and environmental covariates.
load_possum_body_size <- function() {
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2015_LeanSeasonPrimaryProductivity_10_1111_ecog_012",
                        "dryad_gq264_v20150323.zip")
  df <- utils::read.csv(unz(zip_path, "Trichosurus_vulpecula_variables_data.csv"),
                        stringsAsFactors = FALSE, check.names = FALSE,
                        fileEncoding = "latin1")
  names(df) <- make.names(iconv(names(df), from = "latin1", to = "ASCII//TRANSLIT"),
                          unique = TRUE)
  # Keep ASCII aliases for the fields used by the package metadata.
  names(df)[names(df) == "Registration.number"] <- "Registration_number"
  names(df)[names(df) == "Island.type"] <- "Island_type"
  names(df)[names(df) == "Soil.nutrient.availability"] <- "Soil_nutrient_availability"
  names(df)[names(df) == "Clay.content.percentage..0...30.cm."] <- "Clay_content_0_30cm"
  names(df)[names(df) == "Soil.bulk.density..0...30.cm."] <- "Soil_bulk_density_0_30cm"
  sf_obj <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "Collection,Registration_number",
      datetime_columns = "Date",
      candidate_y_variables = "CBL"
    )
  )
}
# --- Loaders candidats high promus au benchmark -----------------------------
# Ces trois jeux de donnees ont d'abord ete convertis par la couche warehouse
# en GeoPackage. On reutilise ces GeoPackages comme source stabilisee, puis on
# applique ici la convention commune du pipeline papier : sortie finale en RDS
# nommee `paper_<record_id>.rds`, directement consommable par le package.
read_final_gpkg <- function(file_name) {
  # Do not rely on OUT_DIR here: generate_fiches_papers.R reuses that name for the wiki output directory.
  path <- file.path(REPO_ROOT, "data", "final_datasets", "sf", file_name)
  if (!file.exists(path)) {
    stop("GeoPackage source introuvable : ", path, call. = FALSE)
  }
  sf::st_read(path, quiet = TRUE)
}

# Marrot et al. (2015), Methods in Ecology and Evolution.
# Reponse de benchmark : Number_of_fledglings ; covariables confirmees dans la
# fiche et le papier : Clutch_size, Laying_date, Incubation_duration.
load_marrot_spatial_autocorrelation_fitness <- function() {
  sf_obj <- read_final_gpkg("Warehouse_DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210.gpkg")
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "Individuals_ID,Nest_boxes_ID,Years",
      datetime_columns = "Years",
      candidate_y_variables = "Number_of_fledglings"
    )
  )
}

# Rocha et al. (2019), Journal of Land Use Science.
# Niveau spatial : municipalites bresiliennes. La geometrie polygonale est
# conservee ; build_unified_sf derive ensuite un point representatif pour les
# estimateurs qui demandent des coordonnees.
load_rocha_agricultural_technology_brazil <- function() {
  sf_obj <- read_final_gpkg("DataCite_2019_AgriculturalTechnologyAdoptionAnd_10_1080_1747423x.gpkg")
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "LONG,LATI",
      identifier_variables = "MUN,COD6,COD7,UF,UF_IBGE,MESO_IBGE,MICRO_IBGE",
      datetime_columns = "",
      candidate_y_variables = "SOY"
    )
  )
}

# Teles et Mantelatto (2025), Journal of Biogeography.
# Reponse principale de benchmark : SR ; autres reponses possibles : PD, PE.
load_teles_decapod_biodiversity_brazil <- function() {
  sf_obj <- read_final_gpkg("DataCite_2026_DataAndRCode_10_1111_jbi_7007.gpkg")
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "SR,PD,PE"
    )
  )
}
PAPER_DATASET_LOADERS <- list(
  metacomnet = load_metacomnet,
  cluster_detection = load_cluster_detection,
  medicago = load_medicago,
  crane = load_crane,
  regulatory_convergence = load_regulatory_convergence,
  eberg = load_eberg,
  swiss_rainfall = load_swiss_rainfall,
  vindum = load_vindum,
  maipo = load_maipo,
  ethiopia_clusters = load_ethiopia_clusters,
  waste_site = load_waste_site,
  biomass_rainforest = load_biomass_rainforest,
  wald_test = load_wald_test,
  uk_photovoltaic = load_uk_photovoltaic,
  mammals_sr_pd = load_mammals_sr_pd,
  beta0_gwr = load_beta0_gwr,
  pm25_grid = load_pm25_grid,
  o3_grid = load_o3_grid,
  no2_grid = load_no2_grid,
  pallid_bat = load_pallid_bat,
  hummingbird_sdm = load_hummingbird_sdm,
  marrot_spatial_autocorrelation_fitness = load_marrot_spatial_autocorrelation_fitness,
  rocha_agricultural_technology_brazil = load_rocha_agricultural_technology_brazil,
  teles_decapod_biodiversity_brazil = load_teles_decapod_biodiversity_brazil,
  spruce_bark_beetle = load_spruce_bark_beetle,
  florida_crash_gsvcm = load_florida_crash_gsvcm,
  possum_body_size = load_possum_body_size
)

convert_paper_dataset <- function(record_id, verbose = TRUE) {
  loader <- PAPER_DATASET_LOADERS[[record_id]]
  if (is.null(loader)) stop("Pas de loader pour : ", record_id, call. = FALSE)
  loaded <- loader()
  sf_obj <- loaded$obj
  row <- loaded$row

  famille <- geom_family(sf_obj)
  if (isTRUE(verbose)) cat(sprintf("[%s] famille de geometrie : %s (n=%d)\n",
                                   record_id, famille, nrow(sf_obj)))

  unified <- build_unified_sf(sf_obj, famille, row)
  resp <- classify_response(unified, row)

  out_path <- file.path(OUT_DIR, paste0("paper_", record_id, ".rds"))
  saveRDS(unified, out_path)
  if (isTRUE(verbose)) {
    cat(sprintf("[%s] reponse detectee : %s (%s, source=%s) -> %s\n",
               record_id, resp$var %||% "?", resp$type %||% "?", resp$source %||% "?", out_path))
  }
  invisible(list(sf = unified, response = resp, path = out_path))
}

convert_all_registered <- function(verbose = TRUE) {
  for (id in names(PAPER_DATASET_LOADERS)) {
    tryCatch(
      convert_paper_dataset(id, verbose = verbose),
      error = function(e) cat(sprintf("[%s] ECHEC : %s\n", id, conditionMessage(e)))
    )
  }
}

if (sys.nframe() == 0) {
  convert_all_registered()
}


