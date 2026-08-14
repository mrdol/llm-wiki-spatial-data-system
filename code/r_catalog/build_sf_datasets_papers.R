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

find_paper_raw_dir <- function(pattern) {
  dirs <- list.dirs(file.path(REPO_ROOT, "data", "raw", "papers"),
                    recursive = FALSE, full.names = TRUE)
  hit <- dirs[grepl(pattern, basename(dirs), ignore.case = TRUE)]
  if (!length(hit)) stop("Raw paper directory not found for pattern: ", pattern, call. = FALSE)
  hit[1]
}

zip_member_by_basename <- function(zip_path, file_name) {
  members <- utils::unzip(zip_path, list = TRUE)$Name
  hit <- members[basename(members) == file_name]
  if (!length(hit)) stop("File not found in zip: ", file_name, call. = FALSE)
  hit[1]
}

read_excel_sheet_with_header <- function(path, sheet, header_row = 3) {
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("Le package 'readxl' est requis pour lire ", basename(path), ".", call. = FALSE)
  }
  raw <- as.data.frame(readxl::read_excel(path, sheet = sheet, col_names = FALSE))
  header <- as.character(unlist(raw[header_row, ]))
  empty <- is.na(header) | !nzchar(header)
  header[empty] <- paste0("col", which(empty))
  df <- raw[-seq_len(header_row), , drop = FALSE]
  names(df) <- make.names(header, unique = TRUE)
  df[] <- lapply(df, function(x) suppressWarnings(type.convert(as.character(x), as.is = TRUE)))
  df
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

# --- Loader Trillium SDM presence/background (Miller et al. 2021) -----------
# Le papier publie surtout une analyse espece-niveau PO ~ traits reproductifs
# apres ENM climatique. Les fichiers Dryad locaux exposent les occurrences
# georeferencees par espece, pas les surfaces ENM finales ni ClimateNA. Ce
# loader construit donc un benchmark SDM executable : presences auteur +
# background pseudo-absences deterministes + covariables WorldClim publiques.
load_trillium_presence_background <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329")
  files <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
  files <- files[basename(files) != "Trillium_LifeHistoryTraits.csv"]
  if (!length(files)) {
    stop("Aucun fichier d'occurrences Trillium trouve dans ", dir, call. = FALSE)
  }

  read_occurrence_file <- function(path) {
    df <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = FALSE)
    names(df) <- trimws(tolower(names(df)))
    required <- c("species", "longitude", "latitude")
    if (!all(required %in% names(df))) {
      stop("Colonnes species/longitude/latitude introuvables dans ", basename(path),
           call. = FALSE)
    }
    out <- data.frame(
      species = trimws(as.character(df$species)),
      longitude = suppressWarnings(as.numeric(df$longitude)),
      latitude = suppressWarnings(as.numeric(df$latitude)),
      source_file = basename(path),
      stringsAsFactors = FALSE
    )
    out <- out[nzchar(out$species) & is.finite(out$longitude) & is.finite(out$latitude), ]
    out
  }

  pres <- do.call(rbind, lapply(files, read_occurrence_file))
  pres <- unique(pres)
  pres <- pres[pres$longitude >= -100 & pres$longitude <= -50 &
                 pres$latitude >= 20 & pres$latitude <= 55, ]
  if (!nrow(pres)) stop("Aucune occurrence Trillium exploitable apres filtrage.", call. = FALSE)

  set.seed(13297)
  bg_list <- lapply(split(pres, pres$species), function(sp) {
    n <- nrow(sp)
    lon_rng <- range(sp$longitude, na.rm = TRUE)
    lat_rng <- range(sp$latitude, na.rm = TRUE)
    lon_pad <- max(1, diff(lon_rng) * 0.10)
    lat_pad <- max(1, diff(lat_rng) * 0.10)
    data.frame(
      species = sp$species[1],
      longitude = stats::runif(n, lon_rng[1] - lon_pad, lon_rng[2] + lon_pad),
      latitude = stats::runif(n, lat_rng[1] - lat_pad, lat_rng[2] + lat_pad),
      source_file = "generated_background_worldclim_bbox",
      stringsAsFactors = FALSE
    )
  })
  bg <- do.call(rbind, bg_list)
  bg$background_id <- seq_len(nrow(bg))
  pres$background_id <- NA_integer_
  pres$presence <- 1L
  bg$presence <- 0L

  sf_obj <- rbind(pres[, c("species", "longitude", "latitude", "source_file", "background_id", "presence")],
                  bg[, c("species", "longitude", "latitude", "source_file", "background_id", "presence")])
  sf_obj$record_type <- ifelse(sf_obj$presence == 1L, "presence", "background")
  sf_obj <- sf::st_as_sf(sf_obj, coords = c("longitude", "latitude"),
                         crs = 4326, remove = FALSE)

  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis pour extraire WorldClim.", call. = FALSE)
  }
  if (!requireNamespace("geodata", quietly = TRUE)) {
    stop("Le package 'geodata' est requis pour telecharger WorldClim.", call. = FALSE)
  }

  wc_dir <- file.path(REPO_ROOT, "data", "data_retrievals", "worldclim")
  dir.create(wc_dir, recursive = TRUE, showWarnings = FALSE)
  bio <- tryCatch(
    geodata::worldclim_global(var = "bio", res = 10, path = wc_dir),
    error = function(e) e
  )
  if (inherits(bio, "error") || terra::nlyr(bio) == 0) {
    stop(
      "Covariables WorldClim absentes et telechargement indisponible. ",
      "Preparer le cache local avec geodata::worldclim_global(var='bio', res=10, path='",
      wc_dir, "') puis relancer le loader Trillium.",
      call. = FALSE
    )
  }
  wanted <- c(1, 4, 5, 6, 12, 15)
  layer_names <- vapply(wanted, function(i) {
    hit <- grep(paste0("bio_?", i, "$"), names(bio), value = TRUE, ignore.case = TRUE)
    if (!length(hit)) NA_character_ else hit[1]
  }, character(1))
  if (anyNA(layer_names)) {
    stop("Couches WorldClim bioclimatiques introuvables : ",
         paste(wanted[is.na(layer_names)], collapse = ", "), call. = FALSE)
  }
  bio_sel <- bio[[layer_names]]
  names(bio_sel) <- c(
    "bio1_annual_mean_temperature",
    "bio4_temperature_seasonality",
    "bio5_max_temperature_warmest_month",
    "bio6_min_temperature_coldest_month",
    "bio12_annual_precipitation",
    "bio15_precipitation_seasonality"
  )

  pts <- terra::vect(sf_obj)
  env_values <- as.data.frame(terra::extract(bio_sel, pts, ID = FALSE))
  temp_cols <- c("bio1_annual_mean_temperature",
                 "bio5_max_temperature_warmest_month",
                 "bio6_min_temperature_coldest_month")
  for (col in intersect(temp_cols, names(env_values))) {
    if (stats::median(abs(env_values[[col]]), na.rm = TRUE) > 100) {
      env_values[[col]] <- env_values[[col]] / 10
    }
  }
  sf_obj <- cbind(sf_obj, env_values)
  sf_obj <- sf_obj[stats::complete.cases(sf::st_drop_geometry(sf_obj)[, names(env_values), drop = FALSE]), ]

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "longitude,latitude",
      identifier_variables = "species,source_file,background_id,record_type",
      datetime_columns = "",
      candidate_y_variables = "presence"
    )
  )
}

# Miller et al. (2021), Diversity and Distributions. Continuous species-level
# companion dataset for the paper's beta-regression step: proportional
# occupancy (PO) explained by reproductive traits after ENM/MaxEnt modelling.
load_trillium_proportional_occupancy <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329")
  traits <- utils::read.csv(file.path(dir, "Trillium_LifeHistoryTraits.csv"),
                            stringsAsFactors = FALSE, check.names = TRUE)
  names(traits) <- make.names(names(traits), unique = TRUE)
  names(traits)[names(traits) == "Seed_weight."] <- "Seed_weight"
  traits$species <- trimws(tolower(as.character(traits$species)))

  occurrence_files <- list.files(dir, pattern = "\\.csv$", full.names = TRUE)
  occurrence_files <- occurrence_files[basename(occurrence_files) != "Trillium_LifeHistoryTraits.csv"]
  read_occ <- function(path) {
    df <- utils::read.csv(path, stringsAsFactors = FALSE, check.names = TRUE)
    names(df) <- tolower(names(df))
    data.frame(
      species = trimws(tolower(as.character(df$species))),
      Longitude = suppressWarnings(as.numeric(df$longitude)),
      Latitude = suppressWarnings(as.numeric(df$latitude)),
      stringsAsFactors = FALSE
    )
  }
  occ <- do.call(rbind, lapply(occurrence_files, read_occ))
  occ <- occ[is.finite(occ$Longitude) & is.finite(occ$Latitude), ]
  centroids <- aggregate(
    cbind(Longitude, Latitude) ~ species,
    data = occ,
    FUN = function(x) mean(x, na.rm = TRUE)
  )
  observed_occ <- aggregate(
    list(observed_occurrences_local = occ$species),
    by = list(species = occ$species),
    FUN = length
  )

  df <- merge(traits, centroids, by = "species", all.x = TRUE)
  df <- merge(df, observed_occ, by = "species", all.x = TRUE)
  keep_cols <- c("PO", "No_ovules", "Seed_weight", "Flower_Type",
                 "Biomass", "No_seeds_plant", "Seed_setting_rate",
                 "Longitude", "Latitude")
  for (col in intersect(keep_cols, names(df))) {
    df[[col]] <- suppressWarnings(as.numeric(df[[col]]))
  }
  df <- df[stats::complete.cases(df[, c("PO", "No_ovules", "Seed_weight",
                                        "Flower_Type", "Longitude", "Latitude")]), ]
  sf_obj <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "species,NatServe_Status",
      datetime_columns = "",
      candidate_y_variables = "PO"
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

# --- Loader coraux d'eau profonde Nouvelle-Zelande (Anderson et al. 2022) --
# README.txt (Dryad) documente 12 fichiers CSV, un par taxon, colonnes
# identiques : lat/lon (WGS84 decimal), pa (presence=1/absence=0), puis 12
# covariables environnementales nommees (depth, mud, carbonate, bpi_fine,
# slope_per, smtfinal, OXY_C, SFR_OARG_C, OM_CAL3_C, BEN_N_C, DETFLUX3_C,
# SO_C). Un loader partage parametre par nom de fichier espece, comme
# load_pollution_grid() plus haut. Les grilles environnementales completes
# (Present_ENV.csv et scenarios futurs, ~4.86 Go) n'ont pas ete telechargees
# (hors scope benchmark) ; seules les 12 tables presence/absence servent ici.
load_deepwater_coral <- function(species_file) {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638")
  df <- utils::read.csv(file.path(dir, species_file), stringsAsFactors = FALSE)
  sf_obj <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "pa"
    )
  )
}

load_coral_bathypathes <- function() load_deepwater_coral("Bathypathes.csv")
load_coral_corallium <- function() load_deepwater_coral("Corallium.csv")
load_coral_enallopsammia <- function() load_deepwater_coral("Enallopsammia.csv")
load_coral_errina <- function() load_deepwater_coral("Errina.csv")
load_coral_goniocorella <- function() load_deepwater_coral("Goniocorella.csv")
load_coral_isididae <- function() load_deepwater_coral("Isididae.csv")
load_coral_leiopathes <- function() load_deepwater_coral("Leiopathes.csv")
load_coral_madrepora <- function() load_deepwater_coral("Madrepora.csv")
load_coral_paragorgia <- function() load_deepwater_coral("Paragorgia.csv")
load_coral_primnoa <- function() load_deepwater_coral("Primnoa.csv")
load_coral_solenosmilia <- function() load_deepwater_coral("Solenosmilia.csv")
load_coral_stylaster <- function() load_deepwater_coral("Stylaster.csv")

# --- Loader cereal rye cover crop biomass (Huddell et al. 2024) ------------
# data_dictionary.csv (Dryad) documente chaque colonne. On utilise le fichier
# joint experimental_and_weather_data.csv (recommande par le README) :
# reponse = late_bm_kg_ha (biomasse au moment de la terminaison tardive, la
# variable predite d'apres le titre du papier) ; predicteurs = early_bm_kg_ha
# + variables meteo cumulees (CGDD, PAR, precipitations) entre les dates.
load_early_season_biomass <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2024_EarlySeasonBiomassAnd_10_1002_ael2_201", "extracted")
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2024_EarlySeasonBiomassAnd_10_1002_ael2_201",
                        "doi_10_5061_dryad_ngf1vhj1r__v20240121.zip")
  if (!dir.exists(dir)) {
    utils::unzip(zip_path, exdir = dir)
  }
  df <- utils::read.csv(file.path(dir, "experimental_and_weather_data.csv"),
                        stringsAsFactors = FALSE)
  sf_obj <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "state,block,site,early_plot,late_plot",
      datetime_columns = "plant_date,early_term_date,late_term_date,year",
      candidate_y_variables = "late_bm_kg_ha"
    )
  )
}

# --- Loader mortalite grippe Chicago 1918 (Grantz et al. 2016) -------------
# tracts.csv est un panel tract x semaine (496 tracts x 7 semaines = 3472
# lignes) avec `counts` (deces grippe/pneumonie) et covariables socio-
# demographiques (illit, den.r, unemployed.pct, ho.pct, agecat1-7, pop comme
# exposition). shapefile.zip contient les polygones de tract IL avec un champ
# GISJOIN qui correspond exactement a gisjoin dans tracts.csv (verifie :
# meme format de cle). points.csv (localisations individuelles de cas,
# coordonnees projetees en metres) existe aussi mais n'est pas utilise ici --
# le panel tract est la table de regression spatiale principale du papier.
load_influenza_mortality_chicago <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161")
  extracted <- file.path(dir, "extracted")
  if (!dir.exists(extracted)) {
    utils::unzip(file.path(dir, "doi_10_5061_dryad_48nv3__v20171101.zip"), exdir = extracted)
  }
  shp_dir <- file.path(extracted, "shapefile_extracted")
  if (!dir.exists(shp_dir)) {
    utils::unzip(file.path(extracted, "shapefile.zip"), exdir = shp_dir,
                 junkpaths = TRUE)
  }
  tracts <- utils::read.csv(file.path(extracted, "tracts.csv"), stringsAsFactors = FALSE,
                            colClasses = c(gisjoin = "character"))
  polys <- sf::st_read(file.path(shp_dir, "IL_tract_a.shp"), quiet = TRUE)
  polys$GISJOIN <- as.character(polys$GISJOIN)

  merged <- merge(polys[, c("GISJOIN", "geometry")], tracts,
                  by.x = "GISJOIN", by.y = "gisjoin")
  sf_obj <- sf::st_as_sf(merged)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "GISJOIN",
      datetime_columns = "week",
      candidate_y_variables = "counts"
    )
  )
}

# --- Loader invasion vegetale FIA (Shen et al. 2024) ------------------------
# README.md documente LAT/LON (degres decimaux) et 41 variables ecologiques
# auxiliaires. Reponse : InvTotalCover ("Sum of cover estimates for all
# invasive plants") et InvSpRichness, toutes deux explicitement definies dans
# le README -- correspond au titre du papier (prediction spatiale de
# l'invasion vegetale).
load_plant_invasion_fia <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2024_SpatialPredictionOfPlant_10_1002_ece3_116", "extracted")
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2024_SpatialPredictionOfPlant_10_1002_ece3_116",
                        "doi_10_5061_dryad_0rxwdbs8t__v20260410.zip")
  if (!dir.exists(dir)) {
    utils::unzip(zip_path, exdir = dir)
  }
  df <- utils::read.csv(file.path(dir, "newinvasion.csv"), stringsAsFactors = FALSE)
  # Shen et al. (2024) p.4: "After excluding plots with missing values, we
  # eventually got 42,314 samples for analyses" (sur 46,071 placettes FIA
  # forestieres brutes). Reproduit ici via complete.cases() sur l'ensemble
  # des colonnes du CSV -- donne N=42612, tres proche du N publie (42314,
  # ecart residuel de 298 lignes probablement du a un controle qualite
  # supplementaire non detaille dans les 4 pages consultees du papier).
  df <- df[stats::complete.cases(df), ]
  sf_obj <- sf::st_as_sf(df, coords = c("LON", "LAT"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "LON,LAT",
      identifier_variables = "STATEAB,FIPS,county",
      datetime_columns = "MEASYEAR",
      candidate_y_variables = "InvTotalCover,InvSpRichness"
    )
  )
}

# --- Loader debit de base Maine (Lombard et al. 2021) -----------------------
# Shapefile de reseau hydrographique NHDPlus (LINESTRING, 42449 troncons).
# Attributs au format standard USGS/NHDPlus : DASQMI (surface de drainage),
# SANDGRAVAF (aquifere sable/gravier), JULYAVPRE (precipitation moyenne de
# juillet), AUGAVGBF (debit de base moyen d'aout -- reponse, correspond
# exactement au titre du papier), OOB_* (indicateurs out-of-bag du modele
# random forest original), REGULATED.
load_maine_baseflow <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2021_ModelEstimatedBaseflowFor_10_1002_rra_3835")
  extracted <- file.path(dir, "extracted")
  if (!dir.exists(extracted)) {
    utils::unzip(file.path(dir, "Maine_Mean_August_Baseflow_Map.zip"), exdir = extracted)
  }
  sf_obj <- sf::st_read(file.path(extracted, "Maine_Mean_August_Baseflow.shp"), quiet = TRUE)
  sf_obj <- sf::st_zm(sf_obj, drop = TRUE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "GNIS_Name,ReachCode,NHDPlusID",
      datetime_columns = "",
      candidate_y_variables = "AUGAVGBF"
    )
  )
}

# --- Loader rendement mais Midwest (Park, Li & Li 2022) --------------------
# MidwestData.RData (dans le zip supplement JASA) fournit regdat : Year,
# State, County (noms complets en toutes lettres, pas d'index opaque),
# CountyI, Yield (reponse), avgPRCP (covariable), Area. Jointure vers de
# vraies frontieres de comte US via tigris::counties() (TIGER Census), verifie
# a 98.9% de correspondance directe (6271/6340) ; les 5 cas restants sont de
# simples variantes d'espacement documentees ci-dessous (DeKalb, DuPage,
# O'Brien), pas des inventions.
load_midwest_crop_yield <- function() {
  if (!requireNamespace("tigris", quietly = TRUE)) {
    stop("Le package 'tigris' est requis (install.packages('tigris')).", call. = FALSE)
  }
  options(tigris_use_cache = TRUE)

  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2022_CropYieldPredictionUsing_10_1080_01621459",
                        "UASA_A_2123333_supplement.zip")
  inner <- "UASA_A_2123333_supplement/jasa-a_cs-2021-0348-20220907220449/suppl_data/MidwestData.RData"
  tmp <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2022_CropYieldPredictionUsing_10_1080_01621459", "extracted")
  dir.create(tmp, showWarnings = FALSE, recursive = TRUE)
  if (!file.exists(file.path(tmp, inner))) {
    utils::unzip(zip_path, files = inner, exdir = tmp)
  }
  e <- new.env()
  load(file.path(tmp, inner), envir = e)
  regdat <- e$regdat

  state_abb <- c(ILLINOIS = "IL", INDIANA = "IN", IOWA = "IA", KANSAS = "KS", MISSOURI = "MO")
  regdat$state_abb <- state_abb[regdat$State]

  norm_county <- function(x) {
    x <- toupper(trimws(x))
    x <- gsub("[^A-Z]", "", x)  # strip spaces/punctuation entirely for a robust key
    x
  }
  regdat$county_key <- norm_county(regdat$County)

  counties_sf <- tigris::counties(state = unname(state_abb), cb = TRUE, year = 2020, class = "sf")
  counties_sf$county_key <- norm_county(counties_sf$NAME)

  merged <- merge(counties_sf[, c("STUSPS", "county_key", "geometry")], regdat,
                  by.x = c("STUSPS", "county_key"), by.y = c("state_abb", "county_key"))
  sf_obj <- sf::st_as_sf(merged)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "State,County,CountyI",
      datetime_columns = "Year",
      candidate_y_variables = "Yield"
    )
  )
}

# --- Loader elections/reseaux (Betz, Cook & Hollenbach 2020) ---------------
# KP2012_Benchmarking_Agg_Data.dta (archive PAN Dataverse) : panel pays x
# annee electorale, 22 pays OCDE, noms de pays en toutes lettres (Australia,
# Austria, ... United Kingdom). Jointure directe et exacte (22/22) vers
# rnaturalearth::ne_countries(scale="medium")$name. Reponse : votelead (part
# de vote du parti sortant/en tete) -- coherent avec la litterature du "vote
# economique" (croissance, chomage) que le jeu de covariables documente
# (gr_*, unem_*).
load_network_misspecification_elections <- function() {
  if (!requireNamespace("rnaturalearth", quietly = TRUE)) {
    stop("Le package 'rnaturalearth' est requis (install.packages('rnaturalearth')).", call. = FALSE)
  }
  if (!requireNamespace("haven", quietly = TRUE)) {
    stop("Le package 'haven' est requis (install.packages('haven')).", call. = FALSE)
  }
  zip_path <- file.path(REPO_ROOT, "data", "raw", "papers",
                        "DataCite_2020_BiasFromNetworkMisspecification_10_1017_pan_2020",
                        "PAN-archive_full_dataverse_files.zip")
  tmp <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2020_BiasFromNetworkMisspecification_10_1017_pan_2020", "extracted")
  dir.create(tmp, showWarnings = FALSE, recursive = TRUE)
  inner <- "PAN-archive/data/KP2012_Benchmarking_Agg_Data.dta"
  if (!file.exists(file.path(tmp, inner))) {
    utils::unzip(zip_path, files = inner, exdir = tmp)
  }
  df <- as.data.frame(haven::read_dta(file.path(tmp, inner)))

  world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
  merged <- merge(world[, c("name", "geometry")], df, by.x = "name", by.y = "country")
  sf_obj <- sf::st_as_sf(merged)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "name,ccode,key1",
      datetime_columns = "elecyr",
      candidate_y_variables = "votelead"
    )
  )
}

# --- Loader oiseaux endemiques ethiopiens (Bladon et al. 2021) -------------
# Les .rda Dryad ne contiennent que des points (presence, absence, fond) en
# WGS84, sans aucune covariable. Le papier (p.3, Materials and methods) cite
# explicitement 5 variables bioclimatiques WorldClim standard (pas de
# definition Ethiopie sur mesure) : maximum temperature of the warmest month
# (BIO5), temperature seasonality (BIO4), annual temperature range (BIO7),
# precipitation of the wettest quarter (BIO16), precipitation of the driest
# quarter (BIO17). Telechargees via geodata::worldclim_global(res=2.5),
# recadrees sur la zone d'etude du papier (1.86-6.87N, 33.17-43.67E) et
# mises en cache dans data/raw/papers/.../worldclim/ethiopia_bio_subset.tif.
# On combine presence (nest records, pa=1) et vraies absences (transects,
# pa=0) -- les points de fond (background, projection differente non WGS84)
# ne sont pas utilises, une vraie absence etant plus defendable qu'un
# pseudo-absence pour ce type de reponse.
load_ethiopia_bird_sdm <- function(species_prefix, presence_file, absence_file, absence_obj_name) {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2021_ClimaticChangeAndExtinction_10_1371_journal_")
  raster_path <- file.path(dir, "worldclim", "ethiopia_bio_subset.tif")
  if (!file.exists(raster_path)) {
    stop("Rasters WorldClim non trouves : lancer d'abord le telechargement (geodata::worldclim_global).",
         call. = FALSE)
  }
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis.", call. = FALSE)
  }

  e_pres <- new.env()
  load(file.path(dir, presence_file), envir = e_pres)
  pres_obj <- get(ls(e_pres)[1], envir = e_pres)
  pres_xy <- as.data.frame(sp::coordinates(pres_obj))
  names(pres_xy) <- c("lon", "lat")
  pres_xy$pa <- 1L

  e_abs <- new.env()
  load(file.path(dir, absence_file), envir = e_abs)
  abs_obj <- get(absence_obj_name, envir = e_abs)
  abs_xy <- as.data.frame(sp::coordinates(abs_obj))
  names(abs_xy) <- c("lon", "lat")
  abs_xy$pa <- 0L

  df <- rbind(pres_xy, abs_xy)
  sf_obj <- sf::st_as_sf(df, coords = c("lon", "lat"), crs = 4326, remove = FALSE)

  bio <- terra::rast(raster_path)
  pts <- terra::vect(sf_obj)
  env_values <- terra::extract(bio, pts, ID = FALSE)
  sf_obj <- cbind(sf_obj, env_values)
  sf_obj <- sf_obj[stats::complete.cases(sf::st_drop_geometry(sf_obj)[, names(env_values), drop = FALSE]), ]

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "pa"
    )
  )
}

load_ethiopia_bushcrow_sdm <- function() {
  load_ethiopia_bird_sdm("bushcrow", "Bush-crow+nest_records_2005-2015.rda",
                         "Bush-crow_true_absences.rda", "BC_N_abs_1km")
}

load_ethiopia_whitetailed_swallow_sdm <- function() {
  load_ethiopia_bird_sdm("wts", "White-tailed_Swallow+nest_records_2005-2015.rda",
                         "White-tailed_Swallow_true_absenses.rda", "WTS_abs")
}

# --- Loader tortue du desert genotype x niche (Inman et al. 2019) ----------
# Le depot Dryad ne contient que des surfaces raster deja modelisees (11
# grilles .asc parfaitement co-enregistrees, meme dim 1180x1037, meme
# resolution ~1km, meme etendue) : 9 variables environnementales explicatives
# (CLIM1, CLIM3, LC, PHYS1, PHYS2, SOIL2, SOIL3, VEG1, VEG3) et 2 surfaces de
# sortie du modele de niche local (GenAssociation, Clusters). Pas de points
# d'echantillon brut. Meme logique que load_pollution_grid() plus haut (deja
# accepte dans ce fichier pour des surfaces modelisees PM2.5/O3/NO2) :
# reponse = GenAssociation (correspond au titre du papier -- association
# genotype x niche), covariables = les 9 grilles environnementales,
# agregation par facteur 8 pour revenir a un nombre de points raisonnable
# pour un jeu de benchmark (~19k cellules).
load_desert_tortoise_genotype_niche <- function() {
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis.", call. = FALSE)
  }
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2019_LocalNicheDifferencesPredict_10_1111_ddi_1292")
  tmp <- file.path(dir, "extracted")
  dir.create(tmp, showWarnings = FALSE, recursive = TRUE)

  layer_zips <- c(
    GenAssociation = "Habitat_Genotype_Association/GenAssociation.zip",
    CLIM1 = "Environmental_Explanatory_Variables/CLIM1.zip",
    CLIM3 = "Environmental_Explanatory_Variables/CLIM3.zip",
    LC = "Environmental_Explanatory_Variables/LC.zip",
    PHYS1 = "Environmental_Explanatory_Variables/PHYS1.zip",
    PHYS2 = "Environmental_Explanatory_Variables/PHYS2.zip",
    SOIL2 = "Environmental_Explanatory_Variables/SOIL2.zip",
    SOIL3 = "Environmental_Explanatory_Variables/SOIL3.zip",
    VEG1 = "Environmental_Explanatory_Variables/VEG1.zip",
    VEG3 = "Environmental_Explanatory_Variables/VEG3.zip"
  )

  layers <- list()
  for (nm in names(layer_zips)) {
    asc_path <- file.path(tmp, paste0(nm, ".asc"))
    if (!file.exists(asc_path)) {
      utils::unzip(file.path(dir, layer_zips[[nm]]), exdir = tmp)
    }
    layers[[nm]] <- terra::rast(asc_path)
  }
  stack <- terra::rast(layers)
  names(stack) <- names(layer_zips)

  agg <- terra::aggregate(stack, fact = 8, fun = "mean", na.rm = TRUE)
  pts <- terra::as.points(agg, na.rm = TRUE)
  sf_obj <- sf::st_as_sf(pts)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = "GenAssociation"
    )
  )
}

# --- Loader feux de foret / severite de brulure (Chamberlain et al. 2024) --
# README.md (Dryad) documente : reponse = RdNBR (relativized differenced
# normalized burn ratio, 30m) dans severity/. csvs/predictor_variables*.csv
# (fourni par les auteurs) liste les vraies covariables du modele du papier
# -- 35 pour Bootleg, 34 pour Schneider Springs. Verifie le 2026-08-12 :
# 3 couches documentees dans ce CSV (aspect_10res, ecostress_pet,
# ecostress_esi) sont absentes du depot Dryad public pour les DEUX incendies
# (recherche exhaustive dans l'archive, aucun fichier correspondant) --
# probablement retirees du depot public (droits ECOSTRESS ?). Elles restent
# documentees comme manquantes plutot que devinees. forest_mask/
# ownership_mask existent comme fichiers mais NE SONT PAS dans
# predictor_variables.csv : ce sont des masques de zone d'etude, pas des
# covariables du modele -- inclus dans le .rds (utile pour filtrer) mais
# exclus de formula_used.
# Rasters dans des CRS/resolutions tres heterogenes (WGS84, UTM10N
# NAD83(2011), Albers 5070, NAD83 geo, quelques-uns sans CRS attache) :
# reprojetes vers une grille commune (Albers EPSG:5070, ~250m -- compromis
# entre la finesse des predicteurs 9-30m et la grossierete de gedi/
# windninja 429-1000m), rebond bilineaire pour les continues, plus-proche-
# voisin pour les masques.
load_wildfire_severity <- function(fire_dirname, severity_file, response_layer_name) {
  if (!requireNamespace("terra", quietly = TRUE)) {
    stop("Le package 'terra' est requis.", call. = FALSE)
  }
  base <- file.path(REPO_ROOT, "data", "raw", "papers",
                    "DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700",
                    "extracted", fire_dirname)
  if (!dir.exists(base)) {
    stop("Rasters wildfire non trouves : extraire d'abord ", fire_dirname, " du zip Dryad.", call. = FALSE)
  }

  target_crs <- "EPSG:5070"
  target_res <- 250

  sev <- terra::rast(file.path(base, "severity", severity_file))
  sev_proj <- terra::project(sev, target_crs, res = target_res, method = "bilinear")
  names(sev_proj) <- response_layer_name

  pred_files <- list.files(file.path(base, "predictors"), pattern = "\\.(tif|img)$",
                           recursive = TRUE, full.names = TRUE)
  pred_files <- pred_files[!grepl("\\.ovr$", pred_files, ignore.case = TRUE)]
  mask_layers <- c("forest_mask", "ownership_mask")

  aligned <- list()
  for (p in pred_files) {
    lyr_name <- tools::file_path_sans_ext(basename(p))
    method <- if (lyr_name %in% mask_layers) "near" else "bilinear"
    r <- terra::rast(p)
    if (is.na(terra::crs(r))) {
      # Quelques rasters (frs, gedi, masks) n'ont pas de CRS attache dans le
      # fichier source ; d'apres le README ils partagent la meme zone
      # d'etude que les autres couches, on assume donc la projection
      # UTM10N/NAD83(2011) (EPSG:6339) dominante parmi les predicteurs de
      # meme origine pour ce site.
      terra::crs(r) <- "EPSG:6339"
    }
    r_aligned <- terra::project(r, sev_proj, method = method)
    aligned[[lyr_name]] <- r_aligned
  }

  stack <- c(sev_proj, terra::rast(aligned))
  pts <- terra::as.points(stack, na.rm = TRUE)
  sf_obj <- sf::st_as_sf(pts)
  sf_obj <- sf_obj[!is.na(sf_obj[[response_layer_name]]), ]

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "",
      identifier_variables = "",
      datetime_columns = "",
      candidate_y_variables = response_layer_name
    )
  )
}

load_wildfire_bootleg_severity <- function() {
  load_wildfire_severity("bootleg_datasets", "2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif", "rdnbr")
}

load_wildfire_schneider_springs_severity <- function() {
  load_wildfire_severity("schneider_springs_datasets",
                         "2021_SchneiderSprings_rdnbr_w_offset_DATESADJUSTED.tif", "rdnbr")
}

# Reeves et al. (2010), Ecological Monographs (DOI 10.1890/09-0879.1).
# Le Y publie dans l'article (Table 1) est une prevalence de malformations
# par site (2004-2006, seuil >=50 metamorphes par site pour que la stats soit
# jugee fiable par les auteurs). Le depot Dryad complet (10.5061/dryad.sq72d)
# etend cette meme surveillance USFWS jusqu'a 2000-2012 : FrogAbnormalities.csv
# contient 9011 individus avec des indicateurs binaires (ABNORMAL/SKEL_AB/
# EYE_AB/SURF_AB/BLEEDING_INJ). On reproduit ici la meme logique de prevalence
# que le Table 1 de l'article (agregation par site + seuil n>=50), mais sur
# toute la periode disponible localement plutot que sur le seul sous-ensemble
# 2004-2006 du papier -> version continue derivee, pas une reproduction exacte
# de Table 1. Coordonnees jointes depuis SiteLocations.csv (SITE commun).
load_amphibian_malformation_prevalence <- function() {
  dir <- file.path(REPO_ROOT, "data", "raw", "papers",
                   "DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_")
  frogs <- utils::read.csv(file.path(dir, "FrogAbnormalities.csv"), stringsAsFactors = FALSE)
  sites <- utils::read.csv(file.path(dir, "SiteLocations.csv"), stringsAsFactors = FALSE)
  roads <- utils::read.csv(file.path(dir, "RoadsInfo.csv"), stringsAsFactors = FALSE)

  ab_cols <- c("ABNORMAL", "SKEL_AB", "EYE_AB", "SURF_AB", "BLEEDING_INJ")
  for (col in ab_cols) frogs[[col]] <- suppressWarnings(as.numeric(frogs[[col]]))
  frogs <- frogs[!is.na(frogs$SITE) & nzchar(frogs$SITE), ]

  n_frogs <- stats::aggregate(FROG_ID ~ SITE, data = frogs, FUN = length)
  names(n_frogs)[2] <- "n_frogs"
  agg <- n_frogs
  for (col in ab_cols) {
    a <- stats::aggregate(stats::as.formula(paste(col, "~ SITE")), data = frogs,
                          FUN = function(x) sum(x, na.rm = TRUE))
    agg[[paste0("prevalence_", tolower(col))]] <-
      100 * a[[col]][match(agg$SITE, a$SITE)] / agg$n_frogs
  }

  # Meme seuil de fiabilite que le Table 1 de l'article (footnote : "Statistics
  # compiled only from sampling events at which 50 or more frogs were examined").
  agg <- agg[agg$n_frogs >= 50, ]

  names(sites)[names(sites) == "Site"] <- "SITE"
  agg <- merge(agg, sites[, c("SITE", "LATITUDE", "LONGITUDE")], by = "SITE", all.x = TRUE)
  agg <- agg[!is.na(agg$LATITUDE) & !is.na(agg$LONGITUDE), ]

  names(roads)[names(roads) == "Site"] <- "SITE"
  agg <- merge(agg, roads[, c("SITE", "ROADDISTANCE", "RoadType")], by = "SITE", all.x = TRUE)

  sf_obj <- sf::st_as_sf(agg, coords = c("LONGITUDE", "LATITUDE"), crs = 4326, remove = FALSE)

  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "LONGITUDE,LATITUDE",
      identifier_variables = "SITE",
      datetime_columns = "",
      candidate_y_variables = paste0("prevalence_", tolower(ab_cols), collapse = ",")
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

# Jones (2021), Ecology and Evolution. 30 site-year observations across
# 14 African sites; the paper explicitly uses PLS regression with log10
# predator biomass responses and transformed prey, climate, and vegetation X.
load_hyena_lion_biomass_africa <- function() {
  dir <- find_paper_raw_dir("EnvironmentalFactorsInfluencingSpotted")
  xlsx <- file.path(dir, "Predator_biomass__prey_biomass__landcover_and_climate_data_across_Africa.xlsx")
  transformed <- read_excel_sheet_with_header(xlsx, "Transformed data", header_row = 3)
  climate <- read_excel_sheet_with_header(xlsx, "Climate data", header_row = 3)

  coords <- climate[, c("Site", "Year", "Median.lat", "Median.long")]
  df <- merge(transformed, coords, by = c("Site", "Year"), all.x = TRUE)
  rename <- c(
    Spotted.hyaena.biomass.Log10 = "spotted_hyaena_biomass_log10",
    Lion.biomass.Log10 = "lion_biomass_log10",
    Leopard..cheetah..brown.hyaena..wild.dog.biomass.Log10 = "other_predator_biomass_log10",
    Total.biomass.very.small.prey.Log10 = "prey_very_small_biomass_log10",
    Total.biomass.small.prey.Log10 = "prey_small_biomass_log10",
    Total.biomass.medium.prey.Log10 = "prey_medium_biomass_log10",
    Total.biomass.large.prey.Log10 = "prey_large_biomass_log10",
    Total.biomass.very.large.prey.Log10 = "prey_very_large_biomass_log10",
    Bio4...Temperature.seasonality.Log10 = "temperature_seasonality_log10",
    Bio5....Max..temperature.warmest.month.Log10 = "max_temperature_warmest_month_log10",
    Bio6...Min..temperature.coolest.month.Log10 = "min_temperature_coolest_month_log10",
    Bio13...Precipitation.wettest.month.Log10 = "precipitation_wettest_month_log10",
    Bio14...Precipitation.driest.month.Log10 = "precipitation_driest_month_log10",
    Bio15...Precipitation.seasonality.Log10 = "precipitation_seasonality_log10",
    Closed.vegetation.centered.logratio = "closed_vegetation_clr",
    Semi.open.vegetation.centered.logratio = "semi_open_vegetation_clr",
    Open.vegetation.centered.logratio = "open_vegetation_clr",
    Median.lat = "latitude",
    Median.long = "longitude"
  )
  for (old in names(rename)) {
    if (old %in% names(df)) names(df)[names(df) == old] <- rename[[old]]
  }
  df <- df[is.finite(df$longitude) & is.finite(df$latitude), ]
  sf_obj <- sf::st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "longitude,latitude",
      identifier_variables = "Site,Year",
      datetime_columns = "",
      candidate_y_variables = "spotted_hyaena_biomass_log10,lion_biomass_log10"
    )
  )
}

# Samuelson et al. (2018), Proceedings B. Colony-level dataset; the raw
# columns named Lat/Lon are inverted numerically for southern England, so
# longitude is taken from Lat and latitude from Lon.
load_bumblebee_colony_reproduction <- function() {
  dir <- find_paper_raw_dir("LowerBumblebeeColonyReproductive")
  df <- utils::read.csv(file.path(dir, "ASamuelson_UrbanBumblebee_ColonyData.csv"),
                        stringsAsFactors = FALSE, check.names = TRUE)
  df$longitude <- as.numeric(df$Lat)
  df$latitude <- as.numeric(df$Lon)
  sf_obj <- sf::st_as_sf(df, coords = c("longitude", "latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "longitude,latitude,Lat,Lon",
      identifier_variables = "Col,Site,LU750,LU500,LU250,LU100",
      datetime_columns = "",
      candidate_y_variables = "Tot_rep,Countave,Tot_male,Tot_gyne"
    )
  )
}

# Buechling et al. (2017), Journal of Ecology. The paper is temporal/tree-level;
# this executable benchmark collapses yearly ring measurements to one spatial
# observation per sampled tree and keeps local competition summaries from the
# neighbour table.
load_rocky_mountain_tree_growth <- function() {
  dir <- find_paper_raw_dir("ClimateAndCompetitionEffects")
  growth <- utils::read.csv(file.path(dir, "sample tree growth data with locations.csv"),
                            stringsAsFactors = FALSE, check.names = TRUE)
  neigh <- utils::read.csv(file.path(dir, "neighbor tree location and size data.csv"),
                           stringsAsFactors = FALSE, check.names = TRUE)
  names(growth) <- make.names(names(growth), unique = TRUE)
  names(neigh) <- make.names(names(neigh), unique = TRUE)

  comp_count <- aggregate(
    list(neighbor_count = neigh$Neighbor.tree.DBH..cm.),
    by = list(Sample.tree.ID = neigh$Sample.tree.ID),
    FUN = length
  )
  comp_dbh <- aggregate(
    list(neighbor_dbh_sum = neigh$Neighbor.tree.DBH..cm.),
    by = list(Sample.tree.ID = neigh$Sample.tree.ID),
    FUN = function(x) sum(x, na.rm = TRUE)
  )
  comp_dist <- aggregate(
    list(neighbor_distance_mean = neigh$Distance.to.neighbor.tree..m.),
    by = list(Sample.tree.ID = neigh$Sample.tree.ID),
    FUN = function(x) mean(x, na.rm = TRUE)
  )
  comp <- Reduce(function(x, y) merge(x, y, by = "Sample.tree.ID", all = TRUE),
                 list(comp_count, comp_dbh, comp_dist))

  static_cols <- c("Sample.tree.ID", "Species", "Site", "Longitude", "Latitude",
                   "Elevation..m.", "Aspect..degrees.", "Terrain.slope....")
  stat <- growth[!duplicated(growth$Sample.tree.ID), static_cols]
  agg <- aggregate(
    cbind(mean_ring_width_mm = growth$Ring.width..mm.,
          mean_stem_diameter_cm = growth$Stem.diameter..cm.,
          mean_age_years = growth$Age..years.) ~ growth$Sample.tree.ID,
    FUN = mean,
    na.rm = TRUE
  )
  names(agg)[1] <- "Sample.tree.ID"
  df <- merge(stat, agg, by = "Sample.tree.ID", all.x = TRUE)
  df <- merge(df, comp, by = "Sample.tree.ID", all.x = TRUE)
  names(df)[names(df) == "Elevation..m."] <- "elevation_m"
  names(df)[names(df) == "Aspect..degrees."] <- "aspect_degrees"
  names(df)[names(df) == "Terrain.slope...."] <- "terrain_slope_pct"
  df <- df[is.finite(df$Longitude) & is.finite(df$Latitude), ]
  sf_obj <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "Sample.tree.ID,Species,Site",
      datetime_columns = "",
      candidate_y_variables = "mean_ring_width_mm"
    )
  )
}

# Graham et al. (2019), Royal Society Open Science. The published model is a
# binomial probit GLMM for response/no-response; for the current regression
# package we expose the continuous 24h proportional DPH change with the same
# exposure covariates and CPOD coordinates.
load_harbour_porpoise_response <- function() {
  dir <- find_paper_raw_dir("HarbourPorpoiseResponses")
  resp <- utils::read.csv(file.path(dir, "Graham_BOWL_cMMMP_Porpoise_responses_to_construction_data_2019-05-01.csv"),
                          stringsAsFactors = FALSE, check.names = TRUE)
  pod <- utils::read.csv(file.path(dir, "Graham_BOWL_cMMMP_POD_deployment_data_2019-01-18.csv"),
                         stringsAsFactors = FALSE, check.names = TRUE)
  names(pod)[names(pod) == "Dep_no"] <- "dep_no"
  df <- merge(resp, pod[, c("dep_no", "POD_number", "Location_ID", "Latitude", "Longitude")],
              by = "dep_no", all.x = TRUE)
  df <- df[is.finite(df$Longitude) & is.finite(df$Latitude) & is.finite(df$prop24), ]
  sf_obj <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "dep_no,turbine,location,pod,POD_number,Location_ID,ADD",
      datetime_columns = "",
      candidate_y_variables = "prop24,prop12,resp24_50,resp12_50"
    )
  )
}

# Matas Granados et al. (2023), Ecology Letters. The paper's best-fit beta
# regression is species/habitat-level: mean local abundance as a function of
# regional frequency and habitat type for dominant tree species.
load_amazon_tree_dominance <- function() {
  dir <- find_paper_raw_dir("UnderstandingDifferentDominancePatterns")
  raw <- utils::read.csv(file.path(dir, "Raw_to_ecology3.csv"),
                         sep = ";", dec = ".", stringsAsFactors = FALSE,
                         check.names = TRUE)
  meta <- utils::read.csv(file.path(dir, "Metadata4.csv"),
                          sep = ";", dec = ".", stringsAsFactors = FALSE,
                          check.names = TRUE)
  raw$Cod_plot <- trimws(as.character(raw$Cod_plot))
  raw$Species <- trimws(as.character(raw$Species))
  meta$Cod_plot <- trimws(as.character(meta$Cod_plot))
  raw <- merge(raw, meta[, c("Cod_plot", "Longitude", "Latitude", "Forest_type", "Country")],
               by = "Cod_plot", all.x = TRUE, suffixes = c("", ".meta"))
  raw$Forest_type <- ifelse(nzchar(raw$Forest_type), raw$Forest_type, raw$Forest_type.meta)
  raw <- raw[nzchar(raw$Species) & nzchar(raw$Forest_type) &
               is.finite(raw$Longitude) & is.finite(raw$Latitude), ]

  plot_totals <- aggregate(
    list(plot_n_individuals = raw$Species),
    by = list(Cod_plot = raw$Cod_plot, Forest_type = raw$Forest_type),
    FUN = length
  )
  species_plot <- aggregate(
    list(n_ij = raw$Species),
    by = list(Forest_type = raw$Forest_type, Cod_plot = raw$Cod_plot,
              Species = raw$Species),
    FUN = length
  )
  species_plot <- merge(species_plot, plot_totals, by = c("Forest_type", "Cod_plot"))
  species_plot$p_ij <- species_plot$n_ij / species_plot$plot_n_individuals

  dominance_by_habitat <- aggregate(
    list(total_dominance = species_plot$p_ij),
    by = list(Forest_type = species_plot$Forest_type, Species = species_plot$Species),
    FUN = sum
  )
  dominant_keys <- do.call(rbind, lapply(split(dominance_by_habitat, dominance_by_habitat$Forest_type), function(x) {
    x <- x[order(x$total_dominance, decreasing = TRUE), ]
    threshold <- 0.5 * sum(x$total_dominance, na.rm = TRUE)
    before <- c(0, head(cumsum(x$total_dominance), -1))
    x[before < threshold, c("Forest_type", "Species")]
  }))
  dominant_keys$key <- paste(dominant_keys$Forest_type, dominant_keys$Species, sep = "\r")
  species_plot$key <- paste(species_plot$Forest_type, species_plot$Species, sep = "\r")
  species_plot <- species_plot[species_plot$key %in% dominant_keys$key, ]

  n_plots_by_habitat <- aggregate(
    list(n_total_plots_habitat = meta$Cod_plot),
    by = list(Forest_type = meta$Forest_type),
    FUN = function(x) length(unique(x))
  )
  stats <- aggregate(
    cbind(mean_local_relative_abundance = p_ij,
          total_individuals = n_ij,
          n_presence_plots = n_ij) ~ Forest_type + Species,
    data = species_plot,
    FUN = function(x) c(mean = mean(x, na.rm = TRUE), sum = sum(x, na.rm = TRUE), n = length(x))
  )
  stats <- data.frame(
    Forest_type = stats$Forest_type,
    Species = stats$Species,
    mean_local_relative_abundance = stats$mean_local_relative_abundance[, "mean"],
    total_individuals = stats$total_individuals[, "sum"],
    n_presence_plots = stats$n_presence_plots[, "n"],
    stringsAsFactors = FALSE
  )
  stats <- merge(stats, n_plots_by_habitat, by = "Forest_type", all.x = TRUE)
  stats$regional_frequency <- stats$n_presence_plots / stats$n_total_plots_habitat
  stats$habitat_floodplain <- as.integer(stats$Forest_type == "Floodplain")
  stats$habitat_swamp <- as.integer(stats$Forest_type == "Swamp")
  stats$habitat_white_sand <- as.integer(stats$Forest_type == "White sand")

  coords <- aggregate(
    cbind(Longitude, Latitude) ~ Forest_type + Species,
    data = merge(species_plot, raw[, c("Cod_plot", "Species", "Forest_type", "Longitude", "Latitude")],
                 by = c("Cod_plot", "Species", "Forest_type")),
    FUN = function(x) mean(x, na.rm = TRUE)
  )
  df <- merge(stats, coords, by = c("Forest_type", "Species"), all.x = TRUE)
  df <- df[is.finite(df$Longitude) & is.finite(df$Latitude), ]
  sf_obj <- sf::st_as_sf(df, coords = c("Longitude", "Latitude"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "Longitude,Latitude",
      identifier_variables = "Species,Forest_type",
      datetime_columns = "",
      candidate_y_variables = "mean_local_relative_abundance"
    )
  )
}

# Yoder et al. (2024), Ecology Letters. The paper trains BART on binary
# flowering observations, then publishes continuous hindcast summaries. For
# the current regression package, use the continuous number of flowering years
# predicted for each grid cell/timeframe and the associated climate deltas.
load_joshua_tree_flowering <- function() {
  dir <- find_paper_raw_dir("Reconstructing120YearsOf")
  zip_path <- file.path(dir, "output.zip")
  member <- zip_member_by_basename(zip_path, "jotr_flowering_predictors_change.csv")
  long <- utils::read.csv(unz(zip_path, member), stringsAsFactors = FALSE, check.names = TRUE)
  long$predictor_key <- make.names(long$predictor, unique = FALSE)
  wide <- stats::reshape(
    long[, c("lon", "lat", "timeframe", "ri.model", "flyrs", "predictor_key", "pred_value")],
    idvar = c("lon", "lat", "timeframe", "ri.model", "flyrs"),
    timevar = "predictor_key",
    direction = "wide"
  )
  names(wide) <- sub("^pred_value\\.", "", names(wide))
  names(wide) <- make.names(names(wide), unique = TRUE)
  wide <- wide[wide$ri.model == FALSE, ]
  sf_obj <- sf::st_as_sf(wide, coords = c("lon", "lat"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "lon,lat",
      identifier_variables = "timeframe,ri.model",
      datetime_columns = "",
      candidate_y_variables = "flyrs"
    )
  )
}

# Crockett et al. (2024), Fire Ecology. Full train_nbr5 has 1.38M pixels; this
# package artifact keeps a deterministic 50k spatial/response-stratified subset
# and documents the full N.
stratified_spatial_response_sample <- function(df, sample_n, x_col, y_col, response_col,
                                               grid_n = 20L, response_bins = 5L,
                                               seed = 42408L) {
  if (nrow(df) <= sample_n) return(df)

  make_quantile_bin <- function(x, n_bins) {
    probs <- seq(0, 1, length.out = n_bins + 1L)
    breaks <- unique(stats::quantile(x, probs = probs, na.rm = TRUE, names = FALSE))
    if (length(breaks) < 3L) {
      return(rep.int(1L, length(x)))
    }
    as.integer(cut(x, breaks = breaks, include.lowest = TRUE, labels = FALSE))
  }

  x_bin <- make_quantile_bin(df[[x_col]], grid_n)
  y_bin <- make_quantile_bin(df[[y_col]], grid_n)
  response_bin <- make_quantile_bin(df[[response_col]], response_bins)
  strata <- interaction(x_bin, y_bin, response_bin, drop = TRUE, lex.order = TRUE)
  split_idx <- split(seq_len(nrow(df)), strata)
  sizes <- lengths(split_idx)

  target_raw <- sample_n * sizes / sum(sizes)
  allocation <- pmin(sizes, pmax(1L, floor(target_raw)))

  remaining <- sample_n - sum(allocation)
  if (remaining > 0L) {
    can_add <- which(allocation < sizes)
    remainder_order <- can_add[order(target_raw[can_add] - floor(target_raw[can_add]),
                                     decreasing = TRUE)]
    while (remaining > 0L && length(remainder_order)) {
      for (i in remainder_order) {
        if (remaining <= 0L) break
        if (allocation[i] < sizes[i]) {
          allocation[i] <- allocation[i] + 1L
          remaining <- remaining - 1L
        }
      }
      remainder_order <- remainder_order[allocation[remainder_order] < sizes[remainder_order]]
    }
  } else if (remaining < 0L) {
    can_drop <- which(allocation > 1L)
    drop_order <- can_drop[order(allocation[can_drop], decreasing = TRUE)]
    while (remaining < 0L && length(drop_order)) {
      for (i in drop_order) {
        if (remaining >= 0L) break
        if (allocation[i] > 1L) {
          allocation[i] <- allocation[i] - 1L
          remaining <- remaining + 1L
        }
      }
      drop_order <- drop_order[allocation[drop_order] > 1L]
    }
  }

  set.seed(seed)
  selected <- unlist(Map(function(idx, n) {
    if (length(idx) <= n) idx else sample(idx, n)
  }, split_idx, allocation), use.names = FALSE)
  selected <- sort(unique(selected))

  df <- df[selected, , drop = FALSE]
  df$sample_tile_x <- x_bin[selected]
  df$sample_tile_y <- y_bin[selected]
  df$sample_response_bin <- response_bin[selected]
  df$sample_strategy <- sprintf("spatial_response_stratified_%dx%d_%dbins_seed%d",
                                grid_n, grid_n, response_bins, seed)
  df
}

load_wildfire_greenup_nbr5 <- function(sample_n = 50000L) {
  dir <- find_paper_raw_dir("ClimateLimitsVegetationGreen")
  e <- new.env()
  load(file.path(dir, "train_nbr15.rdata"), envir = e)
  df <- e[["train_nbr5"]]
  needed <- c("nbr_5_year", "postfire_precipitation_total",
              "postfire_precipitation_coefvar", "ls_factor", "KFACTWS_DC",
              "nbr_0_year", "vpd5", "def5", "ppt5", "tmax5", "month", "x", "y", "name")
  df <- df[stats::complete.cases(df[, needed]), needed]
  df$raw_full_n <- nrow(df)
  if (nrow(df) > sample_n) {
    df <- stratified_spatial_response_sample(
      df, sample_n = sample_n, x_col = "x", y_col = "y",
      response_col = "nbr_5_year", grid_n = 20L, response_bins = 5L,
      seed = 42408L
    )
  }
  sf_obj <- sf::st_as_sf(df, coords = c("x", "y"), crs = 4326, remove = FALSE)
  list(
    obj = sf_obj,
    row = list(
      coordinate_columns = "x,y",
      identifier_variables = "name,raw_full_n,sample_tile_x,sample_tile_y,sample_response_bin,sample_strategy",
      datetime_columns = "none",
      candidate_y_variables = "nbr_5_year"
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
  possum_body_size = load_possum_body_size,
  coral_bathypathes = load_coral_bathypathes,
  coral_corallium = load_coral_corallium,
  coral_enallopsammia = load_coral_enallopsammia,
  coral_errina = load_coral_errina,
  coral_goniocorella = load_coral_goniocorella,
  coral_isididae = load_coral_isididae,
  coral_leiopathes = load_coral_leiopathes,
  coral_madrepora = load_coral_madrepora,
  coral_paragorgia = load_coral_paragorgia,
  coral_primnoa = load_coral_primnoa,
  coral_solenosmilia = load_coral_solenosmilia,
  coral_stylaster = load_coral_stylaster,
  early_season_biomass = load_early_season_biomass,
  influenza_mortality_chicago = load_influenza_mortality_chicago,
  plant_invasion_fia = load_plant_invasion_fia,
  maine_baseflow = load_maine_baseflow,
  midwest_crop_yield = load_midwest_crop_yield,
  network_misspecification_elections = load_network_misspecification_elections,
  ethiopia_bushcrow_sdm = load_ethiopia_bushcrow_sdm,
  ethiopia_whitetailed_swallow_sdm = load_ethiopia_whitetailed_swallow_sdm,
  desert_tortoise_genotype_niche = load_desert_tortoise_genotype_niche,
  trillium_presence_background = load_trillium_presence_background,
  trillium_proportional_occupancy = load_trillium_proportional_occupancy,
  wildfire_bootleg_severity = load_wildfire_bootleg_severity,
  wildfire_schneider_springs_severity = load_wildfire_schneider_springs_severity,
  amphibian_malformation_prevalence = load_amphibian_malformation_prevalence,
  hyena_lion_biomass_africa = load_hyena_lion_biomass_africa,
  bumblebee_colony_reproduction = load_bumblebee_colony_reproduction,
  rocky_mountain_tree_growth = load_rocky_mountain_tree_growth,
  harbour_porpoise_response = load_harbour_porpoise_response,
  amazon_tree_dominance = load_amazon_tree_dominance,
  joshua_tree_flowering = load_joshua_tree_flowering,
  wildfire_greenup_nbr5 = load_wildfire_greenup_nbr5
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
