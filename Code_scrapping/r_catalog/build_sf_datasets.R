# =============================================================================
# build_sf_datasets.R
# -----------------------------------------------------------------------------
# Pipeline d'unification spatiale : convertit chaque jeu de donnees du catalogue
# combine en objet sf normalise.
#
# Pour chaque jeu retenu (geometrie directement constructible) :
#   1. chargement (package R, ou fichier local geojson/gpkg/shp/csv)
#   2. coercition en sf + detection du type de geometrie d'origine
#   3. derivation d'une geometrie POINT :
#        - polygone        -> st_point_on_surface()  (point garanti interieur)
#        - grille          -> st_centroid()
#        - point/multipoint-> point lui-meme (centroide si multipoint)
#   4. extraction des coordonnees -> colonnes X, Y
#   5. conservation de la geometrie d'origine (geom_origine) + point (geom_point)
#   6. variable temporelle copiee dans la variable T (si presente)
#   7. enregistrement du CRS natif + drapeau est_projete  (REPROJECTION DIFFEREE)
#   8. classification de la reponse : continu / discret / proportion / comptage
#
# Sorties (tout regroupe dans un seul dossier dedie, rien en vrac ailleurs) :
#   data/final_datasets/sf/
#     |- <record_id>.rds            (un objet sf par jeu)
#     `- catalogue_sf_index.RData   (index_sf, stats_sf, rejets_sf)
#
# Reference methodologique : Code_scrapping/r_catalog/guide_objets_sf.md
# (d'apres *Geocomputation with R*, sf : ch. 2, 5 ; reprojection ch. 7).
#
# NB CRS : normalisation WGS84 integree (step "normalisation_crs").
#   Cat A : CRS projete correctement declare -> st_transform(4326) auto.
#   Cat B : CRS 4326 declare mais coords projetees -> voir CRS_OVERRIDES.
#   Baltimore et Eire : systeme local inconnu, pas de correction auto (EXCLU).
#
# PRE-REQUIS pour les datasets Python (Cat B) :
#   Executer UNE FOIS avant ce script :
#     python tools/fix_crs_python_datasets.py
#   Ce script corrige les GeoJSON Python en WGS84 en appliquant les CRS sources
#   documentes dans tools/source_crs_results.json (obtenu via get_source_crs.py).
#   Sans cette etape, les 4 datasets Cat B auront des coordonnees erronees.
#
# Interpreteur cible : R 4.5.x. Packages requis : sf. Optionnels : terra (rasters).
# =============================================================================

suppressWarnings(suppressMessages({
  if (!requireNamespace("sf", quietly = TRUE)) {
    stop("Le package 'sf' est requis (install.packages('sf')).", call. = FALSE)
  }
  library(sf)
}))

# --- Utilitaires repris du style du depot -----------------------------------

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

# Filtre partage d'acceptation des formules (modele vs graphe).
if (!exists("is_plausible_model_formula")) {
  source(file.path(find_repo_root(), "Code_scrapping", "r_catalog",
                   "formula_model_filter.R"))
}

split_fields <- function(x) {
  x <- as.character(x)
  if (length(x) == 0 || is.na(x) || !nzchar(trimws(x))) return(character(0))
  values <- trimws(unlist(strsplit(x, ",", fixed = TRUE)))
  unique(values[nzchar(values)])
}

nonempty <- function(x) {
  !is.na(x) & nzchar(trimws(as.character(x)))
}

# Normalise une valeur texte (espaces compresses), equivalent R de norm_space.
norm_space <- function(x) {
  x <- as.character(x)
  if (length(x) == 0) return("")
  trimws(gsub("\\s+", " ", x))
}

crs_field <- function(crs_obj, field) {
  if (is.na(crs_obj)) return(NA_character_)
  val <- tryCatch(crs_obj[[field]], error = function(e) NA)
  if (is.null(val) || length(val) == 0 || all(is.na(val))) return(NA_character_)
  as.character(val[1])
}

crs_epsg_code <- function(crs_obj) {
  code <- crs_field(crs_obj, "epsg")
  if (!is.na(code) && nzchar(code)) return(code)
  input <- crs_field(crs_obj, "input")
  hit <- regmatches(input, regexpr("EPSG[:/ ]+[0-9]+", input, ignore.case = TRUE))
  if (length(hit) && nzchar(hit)) return(sub(".*?([0-9]+)$", "\\1", hit))
  NA_character_
}

# Sentinelle d'echec porteuse d'une raison. NB: on NE PEUT PAS faire
# attr(NULL, "reason") <- ... en R (erreur "tentative de changer un attribut en
# NULL"), d'ou cet objet dedie plutot qu'un NULL annote.
make_fail <- function(reason) structure(list(reason = reason), class = "ds_fail")
is_fail <- function(x) is.null(x) || inherits(x, "ds_fail")
reason_of <- function(x) {
  if (inherits(x, "ds_fail")) return(x$reason)
  attr(x, "reason") %||% "echec"
}

# Operateur "valeur par defaut" (NULL/NA-coalescing)
`%||%` <- function(a, b) if (is.null(a) || length(a) == 0 || all(is.na(a))) b else a

# Appariement de noms tolerant (insensible a la casse et aux separateurs).
norm_name <- function(x) gsub("[^a-z0-9]", "", tolower(as.character(x)))

# Pour chaque nom recherche, renvoie le nom de colonne reel correspondant.
match_columns <- function(available, wanted) {
  if (length(available) == 0 || length(wanted) == 0) return(character(0))
  key <- norm_name(available)
  found <- character(0)
  for (w in norm_name(wanted)) {
    if (!nzchar(w)) next
    hit <- available[key == w]
    if (length(hit) >= 1) found <- c(found, hit[1])
  }
  unique(found)
}

save_rdata_atomic <- function(object_names, envir, path, compress = TRUE) {
  temporary <- file.path(tempdir(), paste0(basename(path), ".tmp-", Sys.getpid()))
  on.exit(unlink(temporary, force = TRUE), add = TRUE)
  save(list = object_names, envir = envir, file = temporary, compress = compress)
  if (!file.copy(temporary, path, overwrite = TRUE)) {
    stop("Impossible de remplacer le fichier RData : ", path, call. = FALSE)
  }
  invisible(path)
}

safe_id <- function(record_id) {
  gsub("[^A-Za-z0-9._-]+", "_", as.character(record_id))
}
# =============================================================================
# Table de correction CRS (Cat A + Cat B) ------------------------------------
#
# Cat A : CRS projete correctement declare -> auto st_transform(4326) pour tout
#         dataset avec est_projete = TRUE (pas de table necessaire, c'est general).
#
# Cat B : CRS 4326 declare mais coordonnees en systeme projete.
#         Cles = safe_id(record_id) = nom du fichier .rds sans extension.
#         Valeurs = EPSG reel (NA_integer_ = systeme local inconnu, pas de fix auto).
#
# CRS identifies par analyse des coordonnees brutes dans les GeoJSON sources :
#   nydata     [357628, 4649538] -> UTM Zone 18N  (NY upstate ~75-77W, 42-43N)
#   georgia    [627306, 3368056] -> UTM Zone 16N  (Georgia US ~81-86W, 30-35N)
#   Ohiolung   [170384, 4251390] -> UTM Zone 17N  (Ohio ~80-85W, 38-42N)
#   cincinnati [1392544, 410977] -> Ohio State Plane South ft (SW Ohio)
#   Baltimore  [860, 506]        -> systeme local inconnu (pas de standard EPSG)
#   eire       [-4, 5768]        -> CRS indefini (Undefined Cartesian SRS)
#
# Sources verifiees via tools/get_source_crs.py (lecture .crs geopandas) :
#   nydata     : WKT = UTM Zone 18 + Clarke 1866 -> NAD27/UTM18N = EPSG:26718
#                (corriger 32618->26718 ; diff ~50m negligeable pour census tracts)
#   cincinnati : WKT = LCC + GRS80 + US survey foot + datum inconnu
#                GRS80 ≈ NAD83 -> Ohio South ftUS = EPSG:2835
#                (3734 etait Ohio North/HARN -> faux)
#   georgia    : non trouve dans libpysal examples local ; UTM16N confirme
#                par inspection bbox (x[-85,-81] y[30,35]) ✓
#   Ohiolung   : non trouve dans libpysal examples local ; UTM17N confirme
#                par inspection bbox (x[-85,-80] y[38,42]) ✓
#   Baltimore  : CRS=None dans geopandas (baltim.shp sans .prj) -> NA
#   eire       : Undefined Cartesian SRS (unknown unit) -> NA
# =============================================================================
CRS_OVERRIDES <- list(
  "Python_geodatasets_spdata.nydata"    = 26718L,  # NAD27 / UTM Zone 18N (Clarke 1866, verifie WKT)
  "Python_libpysal_georgia"             = 32616L,  # UTM Zone 16N (WGS84, confirme bbox)
  "Python_libpysal_Ohiolung"            = 32617L,  # UTM Zone 17N (WGS84, confirme bbox)
  "Python_geodatasets_geoda.cincinnati" = 2835L,   # NAD83 / Ohio South (ftUS, LCC+GRS80 verifie WKT)
  "Python_libpysal_Baltimore"           = NA_integer_,  # systeme local inconnu (CRS=None dans source)
  "Python_geodatasets_spdata.eire"      = NA_integer_   # Undefined Cartesian SRS (unknown unit)
)



# --- 1. Chargement du jeu de donnees brut -----------------------------------

# Resout les chemins locaux (colonne local_files, separateurs Windows) en
# chemins absolus existants.
resolve_local_files <- function(local_files, repo_root) {
  parts <- split_fields(local_files)
  if (length(parts) == 0) return(character(0))
  paths <- file.path(repo_root, gsub("\\\\", "/", parts))
  paths[file.exists(paths)]
}

# Retourne list(obj=..., grille=TRUE/FALSE) ou NULL + attribut "reason".
load_dataset_object <- function(row, repo_root, max_file_mb = Inf, min_file_mb = 0) {
  fail <- make_fail
  lang <- as.character(row$source_language)
  pkg  <- trimws(as.character(row$package))
  dsn  <- trimws(as.character(row$dataset_name))
  ent  <- trimws(as.character(row$source_entry))

  # Filtre de taille : "" si OK, sinon raison de rejet (bornes min/max en Mo).
  size_gate <- function(path) {
    mb <- file.size(path) / 1024^2
    if (is.finite(max_file_mb) && mb > max_file_mb) {
      return(sprintf("fichier ignore (%.0f Mo > %g Mo): %s", mb, max_file_mb, basename(path)))
    }
    if (mb < min_file_mb) {
      return(sprintf("sous le seuil min (%.0f Mo < %g Mo): %s", mb, min_file_mb, basename(path)))
    }
    ""
  }

  # 1a. Fichier spatial / tabulaire local (surtout cote Python)
  files <- resolve_local_files(row$local_files, repo_root)
  spat  <- files[grepl("[.](geojson|json|gpkg|shp|parquet)$", files, ignore.case = TRUE)]
  if (length(spat) > 0) {
    bad <- size_gate(spat[1]); if (nzchar(bad)) return(fail(bad))
    is_geojson <- grepl("[.](geojson|json)$", spat[1], ignore.case = TRUE)
    old_geojson_limit <- Sys.getenv("OGR_GEOJSON_MAX_OBJ_SIZE", unset = NA_character_)
    obj <- tryCatch({
      # Certains contours administratifs (Australia) contiennent une seule
      # entite > 50 Mo. OGR la refuse par defaut, meme si le fichier complet
      # reste raisonnable. La limite est levee uniquement pendant la lecture.
      if (is_geojson) Sys.setenv(OGR_GEOJSON_MAX_OBJ_SIZE = "0")
      sf::st_read(spat[1], quiet = TRUE)
    }, error = function(e) NULL, finally = {
      if (is_geojson) {
        if (is.na(old_geojson_limit)) {
          Sys.unsetenv("OGR_GEOJSON_MAX_OBJ_SIZE")
        } else {
          Sys.setenv(OGR_GEOJSON_MAX_OBJ_SIZE = old_geojson_limit)
        }
      }
    })
    if (!is.null(obj)) return(list(obj = obj, grille = FALSE, file_mb = file.size(spat[1]) / 1024^2))
  }
  csvs <- files[grepl("[.]csv$", files, ignore.case = TRUE)]
  if (length(csvs) > 0) {
    bad <- size_gate(csvs[1]); if (nzchar(bad)) return(fail(bad))
    obj <- tryCatch(utils::read.csv(csvs[1], stringsAsFactors = FALSE),
                    error = function(e) NULL)
    if (!is.null(obj)) return(list(obj = obj, grille = FALSE, file_mb = file.size(csvs[1]) / 1024^2))
  }
  # Pass "gros fichiers seulement" : un jeu sans fichier (package R) est ecarte.
  if (min_file_mb > 0) {
    return(fail(sprintf("sous le seuil min (jeu sans fichier local, %g Mo requis)", min_file_mb)))
  }

  # 1b. Jeu fourni par un package R.
  # NB : on utilise new.env() (parent = environnement courant, donc acces a
  # base/methods) et non emptyenv() : les jeux spatiaux sont souvent des objets
  # S4 (Spatial*) ou en lazy-data dont la materialisation echoue sans le chemin
  # de recherche normal. Toute la sequence est protegee par tryCatch.
  if (identical(lang, "R") && nzchar(pkg)) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
      return(fail(paste0("package R non installe: ", pkg)))
    }
    # Le nom du "bundle" data() peut differer du nom de l'objet (ex. data(oldcol)
    # cree COL.OLD ; data(boston) cree boston.c, boston.utm...). On charge donc
    # tous les bundles candidats dans un meme env, puis on recupere l'objet par
    # son nom reel (source_entry en priorite, puis dataset_name).
    e <- new.env()
    for (bundle in unique(c(dsn, ent))) {
      if (!nzchar(bundle)) next
      tryCatch(suppressWarnings(utils::data(list = bundle, package = pkg, envir = e)),
               error = function(err) NULL)
    }
    take <- function(obj) {
      is_grid <- inherits(obj, c("SpatialGrid", "SpatialPixels",
                                 "SpatialGridDataFrame", "SpatialPixelsDataFrame"))
      list(obj = obj, grille = is_grid, file_mb = 0)
    }
    for (nm in unique(c(ent, dsn))) {
      if (nzchar(nm) && exists(nm, envir = e, inherits = FALSE)) {
        return(take(get(nm, envir = e)))
      }
    }
    # Un seul objet charge et noms non concordants -> on le prend.
    loaded_names <- ls(e)
    if (length(loaded_names) == 1L) return(take(get(loaded_names[1], envir = e)))
    # Repli : objet directement accessible dans le namespace (LazyData).
    for (nm in unique(c(ent, dsn))) {
      obj <- tryCatch(get(nm, envir = asNamespace(pkg)), error = function(e) NULL)
      if (!is.null(obj)) return(take(obj))
    }
    if (length(loaded_names) > 1L) {
      return(fail(paste0("plusieurs objets charges (", paste(loaded_names, collapse = ", "),
                         "), nom attendu introuvable: ", ent %||% dsn)))
    }
    return(fail(paste0("objet introuvable dans le package: ", pkg, "::", dsn)))
  }

  fail("aucune source chargeable (ni fichier local ni package R)")
}

# --- 2. Coercition en sf -----------------------------------------------------

coerce_to_sf <- function(obj, row) {
  fail <- make_fail

  if (inherits(obj, "sf")) return(obj)
  if (inherits(obj, "Spatial")) {
    return(tryCatch(sf::st_as_sf(obj), error = function(e) fail("st_as_sf(Spatial) a echoue")))
  }
  if (inherits(obj, c("SpatialGrid", "SpatialPixels"))) {
    return(tryCatch(sf::st_as_sf(methods::as(obj, "SpatialPolygonsDataFrame")),
                    error = function(e) fail("conversion grille->sf a echoue")))
  }
  # Motif de points spatstat (ppp) : on recupere les coordonnees + marques.
  if (inherits(obj, "ppp")) {
    df <- data.frame(x = as.numeric(obj$x), y = as.numeric(obj$y))
    marks <- obj$marks
    if (!is.null(marks)) {
      if (is.data.frame(marks)) df <- cbind(df, marks) else df[["marks"]] <- marks
    }
    return(tryCatch(
      sf::st_as_sf(df, coords = c("x", "y"), crs = NA_integer_, remove = FALSE),
      error = function(e) fail(paste0("st_as_sf(ppp) a echoue: ", conditionMessage(e)))))
  }

  # Motif de points sur reseau spatstat (lpp) : les points sont dans obj$data.
  if (inherits(obj, "lpp")) {
    d <- obj$data
    if (!is.null(d) && all(c("x", "y") %in% names(d))) {
      df <- data.frame(x = as.numeric(d$x), y = as.numeric(d$y))
      for (cc in setdiff(names(d), c("x", "y", "seg", "tp"))) df[[cc]] <- d[[cc]]
      return(tryCatch(
        sf::st_as_sf(df, coords = c("x", "y"), crs = NA_integer_, remove = FALSE),
        error = function(e) fail(paste0("st_as_sf(lpp) a echoue: ", conditionMessage(e)))))
    }
    return(fail("lpp sans coordonnees x/y exploitables"))
  }

  # Objet spatio-temporel S4 'sts' (surveillance) : @map (regions) x @observed (temps).
  # Produit un sf long region x temps : geometrie polygonale repetee, variable T,
  # et la serie 'observed' (comptages) comme reponse.
  if (isS4(obj) && methods::is(obj, "sts")) {
    map <- tryCatch(obj@map, error = function(e) NULL)
    if (is.null(map) || length(map) == 0) return(fail("sts sans slot @map (purement temporel)"))
    map_sf <- tryCatch(sf::st_as_sf(map), error = function(e) NULL)
    if (is.null(map_sf)) return(fail("conversion @map -> sf a echoue"))
    obs <- tryCatch(obj@observed, error = function(e) NULL)
    if (is.null(obs)) return(fail("sts sans @observed"))
    map_sf[[".region"]] <- if (!is.null(rownames(map_sf)) &&
                               length(rownames(map_sf)) == nrow(map_sf)) {
      rownames(map_sf)
    } else as.character(seq_len(nrow(map_sf)))
    reg <- colnames(obs)
    if (is.null(reg) || !all(reg %in% map_sf$.region)) {
      reg <- map_sf$.region[seq_len(min(ncol(obs), nrow(map_sf)))]
    }
    tt <- seq_len(nrow(obs))
    long <- data.frame(.region = rep(reg, each = length(tt)),
                       T = rep(tt, times = length(reg)),
                       observed = as.vector(obs[, seq_along(reg), drop = FALSE]),
                       stringsAsFactors = FALSE)
    geo <- merge(long, map_sf, by = ".region", all.x = TRUE, sort = FALSE)
    return(tryCatch(sf::st_as_sf(geo), error = function(e) fail("assemblage sts -> sf a echoue")))
  }

  # Objet spatio-temporel 'spacetime' (STFDF/STIDF/STSDF) : aplati en table.
  if (isS4(obj) && methods::is(obj, "ST")) {
    flat <- tryCatch(as.data.frame(obj), error = function(e) NULL)
    if (!is.null(flat)) {
      coords <- match_columns(names(flat),
                              c("x", "y", "lon", "lat", "longitude", "latitude",
                                "coords.x1", "coords.x2"))
      if (length(coords) >= 2) {
        tcol <- match_columns(names(flat), c("time", "timeIndex", "endTime"))
        if (length(tcol) >= 1) flat[["T"]] <- flat[[tcol[1]]]
        return(tryCatch(
          sf::st_as_sf(flat, coords = coords[1:2], crs = NA_integer_, remove = FALSE),
          error = function(e) fail("st_as_sf(ST) a echoue")))
      }
    }
    return(fail("objet spacetime non aplatissable en coordonnees"))
  }

  if (is.matrix(obj)) obj <- as.data.frame(obj, stringsAsFactors = FALSE)

  if (is.data.frame(obj)) {
    obj <- as.data.frame(obj, stringsAsFactors = FALSE)
    nms <- names(obj)
    # colonne WKT explicite ?
    wkt_col <- match_columns(nms, c("geometry", "geom", "wkt", "the_geom"))
    # 1) colonnes de coordonnees declarees au catalogue (appariement tolerant)
    coords <- match_columns(nms, split_fields(row$coordinate_columns))
    # 2) sinon paires usuelles
    if (length(coords) < 2) {
      pairs <- list(c("x", "y"), c("lon", "lat"), c("longitude", "latitude"),
                    c("long", "lat"), c("coord_x", "coord_y"),
                    c("easting", "northing"), c("utm_x", "utm_y"))
      for (p in pairs) {
        mc <- match_columns(nms, p)
        if (length(mc) >= 2) { coords <- mc; break }
      }
    }
    if (length(coords) >= 2) {
      return(tryCatch(
        sf::st_as_sf(obj, coords = coords[1:2], crs = NA_integer_, remove = FALSE),
        error = function(e) fail(paste0("st_as_sf(coords) a echoue: ", conditionMessage(e)))))
    }
    if (length(wkt_col) >= 1) {
      return(tryCatch(sf::st_as_sf(obj, wkt = wkt_col[1], crs = NA_integer_),
                      error = function(e) fail("st_as_sf(wkt) a echoue")))
    }
    return(fail("data.frame sans geometrie ni colonnes de coordonnees"))
  }

  # Liste type ade4 : recuperer une sous-table de coordonnees ($xy/$coo/...).
  if (is.list(obj) && !is.data.frame(obj)) {
    coord_tab <- NULL
    for (nm in c("xy", "XY", "coo", "coord", "coords")) {
      cand <- obj[[nm]]
      if (!is.null(cand) && (is.data.frame(cand) || is.matrix(cand)) &&
          ncol(as.data.frame(cand)) >= 2) {
        coord_tab <- as.data.frame(cand)
        break
      }
    }
    if (!is.null(coord_tab)) {
      names(coord_tab)[1:2] <- c("x", "y")
      main <- NULL
      for (nm in c("tab", "data", "df")) {
        cand <- obj[[nm]]
        if (is.data.frame(cand) && nrow(cand) == nrow(coord_tab)) { main <- cand; break }
      }
      df <- if (!is.null(main)) cbind(coord_tab[, 1:2], main) else coord_tab[, 1:2, drop = FALSE]
      return(tryCatch(
        sf::st_as_sf(df, coords = c("x", "y"), crs = NA_integer_, remove = FALSE),
        error = function(e) fail("st_as_sf(liste ade4) a echoue")))
    }
    return(fail("liste sans sous-table de coordonnees"))
  }

  fail(paste0("type d'objet non gere: ", paste(class(obj), collapse = "/")))
}

# --- 3. Famille de geometrie + derivation du point --------------------------

geom_family <- function(sf_obj, grille_hint = FALSE) {
  if (isTRUE(grille_hint)) return("grille")
  gt <- tryCatch(as.character(unique(sf::st_geometry_type(sf_obj))),
                 error = function(e) character(0))
  gt <- toupper(gt)
  if (any(grepl("POLYGON", gt)))    return("polygone")
  if (any(grepl("POINT", gt)))      return("point")
  if (any(grepl("LINE", gt)))       return("ligne")
  "autre"
}

derive_point_geometry <- function(sf_obj, famille) {
  g <- sf::st_geometry(sf_obj)
  g <- tryCatch(sf::st_make_valid(g), error = function(e) g)
  suppressWarnings(switch(
    famille,
    polygone = sf::st_point_on_surface(g),
    grille   = sf::st_centroid(g),
    ligne    = sf::st_point_on_surface(g),
    point    = sf::st_centroid(g),   # centroide = point lui-meme pour un POINT
    NULL
  ))
}

# --- 4-7. Construction du sf unifie -----------------------------------------

COORD_X <- "X"   # nom standard de l'axe (metrique apres reprojection ulterieure)
COORD_Y <- "Y"
TIME_VAR <- "T"  # convention : variable temporelle nommee T

# Simplifie une geometrie (pour alleger la geometrie d'origine des gros jeux).
# keep = proportion de sommets a conserver (rmapshaper) ; repli sur st_simplify.
simplify_geom <- function(g, keep) {
  if (is.null(keep)) return(g)
  if (requireNamespace("rmapshaper", quietly = TRUE)) {
    out <- tryCatch(rmapshaper::ms_simplify(g, keep = keep, keep_shapes = TRUE),
                    error = function(e) NULL)
    if (!is.null(out)) return(sf::st_geometry(out))
  }
  bb <- tryCatch(sf::st_bbox(g), error = function(e) NULL)
  if (is.null(bb)) return(g)
  span <- max(bb["xmax"] - bb["xmin"], bb["ymax"] - bb["ymin"])
  tol <- as.numeric(span) * (1 - keep) / 500
  tryCatch(sf::st_simplify(g, dTolerance = tol, preserveTopology = TRUE),
           error = function(e) g)
}

# Voie rapide pour les gros fichiers : la geometrie est simplifiee AVANT
# st_make_valid(), st_point_on_surface() et la construction de geom_origine.
# C'est le point determinant pour les GeoJSON avec des millions de sommets.
simplify_large_sf_early <- function(sf_obj, keep) {
  if (is.null(keep) || !inherits(sf_obj, "sf") || nrow(sf_obj) == 0L) {
    return(sf_obj)
  }
  g <- sf::st_geometry(sf_obj)
  empty <- tryCatch(sf::st_is_empty(g), error = function(e) rep(NA, length(g)))
  keep_rows <- !is.na(g) & !is.na(empty) & !empty
  sf_obj <- sf_obj[keep_rows, , drop = FALSE]
  if (nrow(sf_obj) == 0L) return(sf_obj)

  bb <- tryCatch(sf::st_bbox(sf_obj), error = function(e) NULL)
  if (is.null(bb)) return(sf_obj)
  span <- max(as.numeric(bb[c("xmax", "ymax")] - bb[c("xmin", "ymin")]))
  denominator <- max(1000, 100000 * keep)
  tolerance <- span / denominator
  if (!is.finite(tolerance) || tolerance <= 0) return(sf_obj)

  old_s2 <- sf::sf_use_s2()
  on.exit(suppressMessages(sf::sf_use_s2(old_s2)), add = TRUE)
  if (isTRUE(sf::st_is_longlat(sf_obj))) {
    suppressMessages(sf::sf_use_s2(FALSE))
  }
  simplified <- tryCatch(
    suppressWarnings(sf::st_simplify(
      sf::st_geometry(sf_obj),
      dTolerance = tolerance,
      preserveTopology = TRUE
    )),
    error = function(e) sf::st_geometry(sf_obj)
  )
  sf::st_geometry(sf_obj) <- simplified
  sf_obj
}

build_unified_sf <- function(sf_obj, famille, row, simplify_keep = NULL) {
  pts <- derive_point_geometry(sf_obj, famille)
  if (is.null(pts) || length(pts) == 0) {
    stop("derivation de la geometrie point impossible", call. = FALSE)
  }

  crs_orig  <- sf::st_crs(sf_obj)
  pts       <- sf::st_sfc(pts, crs = crs_orig)          # garantir un sfc
  geom_orig <- sf::st_geometry(sf_obj)
  # Allege la geometrie d'origine conservee (les points/XY restent calcules
  # sur la geometrie pleine, ci-dessus).
  if (!is.null(simplify_keep) && famille %in% c("polygone", "grille", "ligne")) {
    geom_orig <- simplify_geom(geom_orig, simplify_keep)
  }
  xy        <- sf::st_coordinates(pts)

  # data.frame d'attributs neutre (on neutralise tibble / classe sf residuelle)
  attrs <- as.data.frame(sf::st_drop_geometry(sf_obj), stringsAsFactors = FALSE)
  if (ncol(attrs) == 0) attrs <- data.frame(row_id = seq_along(pts))
  attrs[[COORD_X]] <- xy[, 1]
  attrs[[COORD_Y]] <- xy[, 2]

  # Constructeur canonique : la geometrie point devient la geometrie active,
  # puis on conserve la geometrie d'origine comme seconde colonne sfc.
  out <- sf::st_sf(attrs, geom_point = pts)
  out$geom_origine <- geom_orig

  # Variable temporelle -> T (appariement tolerant)
  tcol <- match_columns(names(out), split_fields(row$datetime_columns))
  if (length(tcol) >= 1) out[[TIME_VAR]] <- out[[tcol[1]]]

  out
}

# --- 8. Classification de la variable reponse -------------------------------

# Mots-clefs usuels de variable reponse (noms normalises, sans separateurs).
RESPONSE_KEYWORDS <- c(
  "price", "saleprice", "value", "val", "medv", "hoval", "income", "wage", "rent",
  "count", "cases", "ncases", "incidence", "deaths", "death", "mortality", "cancer",
  "leuk", "yield", "crime", "rate", "prevalence", "prev", "presence", "abundance",
  "target", "response", "observed", "marks", "score", "prop", "percent", "unemp", "pop"
)

# Tournures indiquant une variable de sortie dans une description textuelle.
OUTCOME_PHRASES <- c(
  "response", "outcome", "dependent", "predicted", "tobepredicted", "explained",
  "numberof", "countof", "rateof", "proportionof", "incidenceof", "prevalenceof",
  "measured", "observedvalue"
)

# Cache des bases d'aide Rd par package (evite de reparser a chaque jeu).
.rd_cache <- new.env(parent = emptyenv())
get_rd_db <- function(pkg) {
  if (!nzchar(pkg)) return(NULL)
  if (exists(pkg, envir = .rd_cache, inherits = FALSE)) return(get(pkg, envir = .rd_cache))
  db <- tryCatch(
    if (requireNamespace(pkg, quietly = TRUE)) tools::Rd_db(pkg) else NULL,
    error = function(e) NULL)
  assign(pkg, db, envir = .rd_cache)
  db
}

# Extrait les paires (variable -> description) du bloc \format de l'aide R.
rd_item_descriptions <- function(pkg, dataset) {
  if (!nzchar(pkg) || !nzchar(dataset)) return(NULL)
  db <- get_rd_db(pkg)
  if (is.null(db) || length(db) == 0) return(NULL)
  cand <- names(db)
  key <- cand[tolower(cand) %in% tolower(c(paste0(dataset, ".Rd"), paste0(dataset, ".rd")))]
  key <- if (length(key)) key[1] else NULL
  if (is.null(key)) {
    for (nm in cand) {
      al <- tryCatch(tools:::.Rd_get_metadata(db[[nm]], "alias"),
                     error = function(e) character(0))
      if (length(al) && tolower(dataset) %in% tolower(al)) { key <- nm; break }
    }
  }
  if (is.null(key)) return(NULL)
  items <- list()
  rec <- function(x) {
    if (is.list(x)) {
      if (identical(attr(x, "Rd_tag"), "\\item") && length(x) >= 2) {
        nm <- trimws(paste(unlist(x[[1]]), collapse = ""))
        desc <- trimws(paste(unlist(x[[2]]), collapse = " "))
        if (nzchar(nm)) items[[nm]] <- desc
      }
      for (el in x) rec(el)
    }
  }
  tryCatch(rec(db[[key]]), error = function(e) NULL)
  if (length(items) == 0) return(NULL)
  unlist(items)
}

# Extrait les termes du membre de gauche d'une formule "Y ~ ...".
parse_formula_lhs <- function(txt) {
  txt <- norm_space(txt)
  if (!nzchar(txt) || !grepl("~", txt, fixed = TRUE)) return(character(0))
  lhs <- trimws(sub("~.*$", "", txt))
  lhs <- gsub("(cbind|log|sqrt|scale|factor|as\\.numeric|I)\\s*\\(", "", lhs)
  lhs <- gsub("[()]", "", lhs)
  toks <- trimws(unlist(strsplit(lhs, "[,+*/-]")))
  toks[nzchar(toks)]
}

# Classe la variable reponse retenue (continu/discret/comptage/proportion).
classify_value <- function(y) {
  y <- y[!is.na(y)]
  if (length(y) == 0) return(list(type = "inconnu", continu = NA))
  if (is.logical(y) || is.factor(y) || is.character(y)) return(list(type = "discret", continu = FALSE))
  if (is.numeric(y)) {
    entiers <- all(abs(y - round(y)) < 1e-9)
    if (all(y >= 0 & y <= 1) && !entiers) return(list(type = "proportion", continu = TRUE))
    if (entiers && length(unique(y)) <= 10) return(list(type = "discret", continu = FALSE))
    if (entiers) return(list(type = "comptage", continu = FALSE))
    return(list(type = "continu", continu = TRUE))
  }
  list(type = "inconnu", continu = NA)
}

# Detection en cascade de la variable reponse, avec tracabilite de la source.
classify_response <- function(sf_obj, row) {
  attrs <- sf::st_drop_geometry(sf_obj)
  nms <- names(attrs)
  exclude <- unique(c(COORD_X, COORD_Y, TIME_VAR,
                      match_columns(nms, split_fields(row$coordinate_columns)),
                      match_columns(nms, split_fields(row$identifier_variables))))
  pool <- setdiff(nms, exclude)
  pick <- function(cols) { cols <- intersect(cols, nms); if (length(cols) >= 1) cols[1] else NA_character_ }

  # 1) catalogue : candidate_y / group_y
  v <- pick(match_columns(nms, c(split_fields(row$candidate_y_variables),
                                 split_fields(row$group_y_variables))))
  source <- if (!is.na(v)) "catalogue" else NA_character_

  # 2) terme de gauche d'une formule
  if (is.na(v)) {
    lhs <- c(parse_formula_lhs(row$formula_text), parse_formula_lhs(row$paper_formula_or_equation))
    v <- pick(match_columns(nms, lhs))
    if (!is.na(v)) source <- "formule"
  }
  # 3) colonne marks / observed (issue ppp / lpp / sts)
  if (is.na(v)) {
    v <- pick(match_columns(nms, c("observed", "marks")))
    if (!is.na(v)) source <- "marks"
  }

  # 4) doc du package : descriptions \item du bloc \format de l'aide R.
  if (is.na(v)) {
    descs <- tryCatch(rd_item_descriptions(norm_space(row$package), norm_space(row$dataset_name)),
                      error = function(e) NULL)
    if (!is.null(descs) && length(descs) > 0) {
      nd <- function(s) gsub("[^a-z0-9]", "", tolower(s))
      rd_names <- names(descs)
      # priorite : description avec une tournure d'outcome
      for (i in seq_along(descs)) {
        col <- pick(match_columns(pool, rd_names[i]))
        if (is.na(col)) next
        if (any(vapply(OUTCOME_PHRASES, function(p) grepl(p, nd(descs[i]), fixed = TRUE), logical(1)))) {
          v <- col; source <- "doc_package"; break
        }
      }
      # sinon : description avec un mot-clef reponse
      if (is.na(v)) {
        for (i in seq_along(descs)) {
          col <- pick(match_columns(pool, rd_names[i]))
          if (is.na(col)) next
          if (any(vapply(RESPONSE_KEYWORDS, function(k) grepl(k, nd(descs[i]), fixed = TRUE), logical(1)))) {
            v <- col; source <- "doc_package"; break
          }
        }
      }
    }
  }

  # 5) description du catalogue : mot-clef present a la fois dans la description
  #    et dans un nom de colonne.
  if (is.na(v)) {
    d <- gsub("[^a-z0-9]", "", tolower(norm_space(row$description)))
    if (nzchar(d) && length(pool) > 0) {
      keyp <- norm_name(pool)
      for (k in RESPONSE_KEYWORDS) {
        if (grepl(k, d, fixed = TRUE)) {
          col <- pick(pool[grepl(k, keyp, fixed = TRUE)])
          if (!is.na(col)) { v <- col; source <- "description"; break }
        }
      }
    }
  }

  # 6) heuristique par mots-clefs (hors X/Y/T, coordonnees, identifiants)
  if (is.na(v) && length(pool) > 0) {
    key <- norm_name(pool)
    is_hit <- Reduce(`|`, lapply(RESPONSE_KEYWORDS, function(k) grepl(k, key, fixed = TRUE)),
                     rep(FALSE, length(pool)))
    hit <- pool[is_hit]
    hit_num <- hit[vapply(hit, function(cc) is.numeric(attrs[[cc]]), logical(1))]
    v <- pick(if (length(hit_num)) hit_num else hit)
    if (!is.na(v)) source <- "heuristique"
  }

  # 7) aucune reponse identifiee : on conserve les candidats analytiques
  if (is.na(v)) {
    analyt <- setdiff(match_columns(nms, split_fields(row$analytical_variables)), exclude)
    if (length(analyt) >= 1) {
      return(list(var = NA_character_, type = "inconnu", continu = NA,
                  source = "a_designer", candidats = paste(utils::head(analyt, 8), collapse = ", ")))
    }
    return(list(var = NA_character_, type = "inconnu", continu = NA,
                source = "aucune", candidats = ""))
  }

  cl <- classify_value(attrs[[v]])
  list(var = v, type = cl$type, continu = cl$continu, source = source, candidats = "")
}

# --- Filtre de perimetre : geometrie directement constructible --------------

is_constructible <- function(catalog) {
  coord_count <- vapply(catalog$coordinate_columns,
                        function(x) length(split_fields(x)), integer(1))
  has_coords <- catalog$has_coordinates == "Yes" & coord_count >= 2L
  has_local_spatial <- grepl("[.](geojson|gpkg|shp|parquet)(,|$)",
                             catalog$local_files, ignore.case = TRUE)
  has_geom <- catalog$has_geometry == "Yes" | has_local_spatial |
    grepl("(^|,\\s*)(geometry|geom|wkt)(\\s*,|$)", catalog$variables, ignore.case = TRUE)
  has_coords | has_geom
}

# Deduplication inter-packages : un meme jeu expose par plusieurs packages
# (ex. geodatasets / libpysal, spData / spdep) partage (description, n, k).
# On garde la ligne du package au plus haut information_score et on retire les
# autres. Aligne le pipeline sf sur la couche catalogue du KG, et evite de
# charger deux fois les memes gros fichiers.
# Quand un jeu existe en version historique (sp/liste) ET en version sf dans le
# meme package (ex. SpatialEpi::scotland vs scotland_sf), on retire la version
# de base et on garde la version sf.
dedupe_sf_variants <- function(catalog) {
  nd <- function(s) gsub("[^a-z0-9]", "", tolower(as.character(s)))
  pkg <- nd(catalog$package)
  ds <- nd(catalog$dataset_name)
  present <- paste(pkg, ds, sep = "|")
  drop <- paste(pkg, paste0(ds, "sf"), sep = "|") %in% present
  catalog[!drop, , drop = FALSE]
}

dedupe_cross_package <- function(catalog) {
  nkey <- function(x) {
    s <- trimws(as.character(x))
    s <- sub("\\.0+$", "", s)
    ifelse(s %in% c("", "NA", "nan", "<NA>"), "", s)
  }
  score <- suppressWarnings(as.numeric(as.character(catalog$information_score)))
  score[is.na(score)] <- 0
  desc <- tolower(substr(trimws(as.character(catalog$description)), 1, 80))
  nk_n <- nkey(catalog$n); nk_k <- nkey(catalog$k)
  sig <- paste(desc, nk_n, nk_k, sep = "|")
  has_sig <- nzchar(desc) & nzchar(nk_n) & nzchar(nk_k)

  keep <- rep(TRUE, nrow(catalog))
  for (s in unique(sig[has_sig])) {
    idx <- which(sig == s & has_sig)
    if (length(idx) <= 1) next
    if (length(unique(catalog$package[idx])) <= 1) next
    best_pkg <- catalog$package[idx[which.max(score[idx])]]
    keep[idx[catalog$package[idx] != best_pkg]] <- FALSE
  }
  catalog[keep, , drop = FALSE]
}

# --- Pipeline principal ------------------------------------------------------

build_sf_datasets <- function(repo_root = find_repo_root(),
                              write_output = TRUE,
                              limit = NULL,
                              max_file_mb = Inf,
                              min_file_mb = 0,
                              simplify_mb = Inf,
                              simplify_keep = 0.05,
                              dedupe = TRUE,
                              drop_sp_variants = TRUE,
                              append = FALSE,
                              only_record_ids = character(0),
                              only_datasets = character(0),
                              skip_record_ids = character(0),
                              skip_datasets = character(0),
                              skip_existing_success = append,
                              verbose = TRUE) {
  manifest_dir <- file.path(repo_root, "data", "manifests", "datasets")
  combined_path <- file.path(manifest_dir, "software_catalog_combined.RData")
  if (!file.exists(combined_path)) {
    stop("Catalogue combine absent : ", combined_path, call. = FALSE)
  }
  out_dir <- file.path(repo_root, "data", "final_datasets", "sf")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  index_path <- file.path(out_dir, "catalogue_sf_index.RData")

  previous_index <- NULL
  if (isTRUE(append) && file.exists(index_path)) {
    prev <- new.env(parent = emptyenv())
    if (isTRUE(tryCatch({ load(index_path, envir = prev); TRUE }, error = function(e) FALSE)) &&
        exists("index_sf", envir = prev, inherits = FALSE)) {
      previous_index <- prev$index_sf
    }
  }

  env <- new.env(parent = emptyenv())
  load(combined_path, envir = env)
  catalog <- if (exists("catalogue_bons_candidats_spatiaux", envir = env, inherits = FALSE)) {
    env$catalogue_bons_candidats_spatiaux
  } else {
    stop("Objet catalogue_bons_candidats_spatiaux absent du RData.", call. = FALSE)
  }

  keep <- is_constructible(catalog)
  candidates <- catalog[keep, , drop = FALSE]
  n_constructibles <- nrow(candidates)
  if (isTRUE(drop_sp_variants)) {
    before_sf <- nrow(candidates)
    candidates <- dedupe_sf_variants(candidates)
    cat(sprintf("Versions sp retirees au profit des versions sf : %d\n",
                before_sf - nrow(candidates)))
  }
  if (isTRUE(dedupe)) {
    candidates <- dedupe_cross_package(candidates)
    cat(sprintf("Doublons inter-packages retires : %d\n",
                n_constructibles - nrow(candidates)))
  }
  scope_ids <- as.character(candidates$record_id)

  only_ids <- trimws(as.character(only_record_ids))
  only_names <- norm_name(only_datasets)
  if (length(only_ids) > 0L || length(only_names) > 0L) {
    selected_only <- as.character(candidates$record_id) %in% only_ids |
      norm_name(candidates$dataset_name) %in% only_names
    candidates <- candidates[selected_only, , drop = FALSE]
    cat(sprintf("Selection ciblee : %d jeu(x)\n", nrow(candidates)))
  }

  # Une passe min_file_mb > 0 vise uniquement les gros fichiers locaux.
  # Les jeux R embarques et les petits fichiers sont ignores sans remplacer
  # leur statut dans l'index cumule de la passe precedente.
  if (min_file_mb > 0) {
    large_local <- vapply(seq_len(nrow(candidates)), function(i) {
      paths <- resolve_local_files(candidates$local_files[i], repo_root)
      if (length(paths) == 0L) return(FALSE)
      sizes <- suppressWarnings(file.size(paths) / 1024^2)
      any(is.finite(sizes) & sizes >= min_file_mb)
    }, logical(1))
    cat(sprintf("Jeux hors passe gros fichiers ignores : %d\n", sum(!large_local)))
    candidates <- candidates[large_local, , drop = FALSE]
  }

  # En mode reprise, les conversions deja reussies ne sont pas relancees.
  # Les rejets restent candidats afin qu'une passe gros fichiers puisse les
  # retenter avec d'autres seuils.
  if (isTRUE(skip_existing_success) && !is.null(previous_index)) {
    previous_ok <- as.character(previous_index$record_id)[
      as.character(previous_index$utilisable) == "TRUE"
    ]
    before_resume <- nrow(candidates)
    candidates <- candidates[!(as.character(candidates$record_id) %in% previous_ok), , drop = FALSE]
    cat(sprintf("Conversions deja reussies sautees : %d\n",
                before_resume - nrow(candidates)))
  }

  skip_ids <- trimws(as.character(skip_record_ids))
  skip_names <- norm_name(skip_datasets)
  skip_match <- as.character(candidates$record_id) %in% skip_ids |
    norm_name(candidates$dataset_name) %in% skip_names
  skipped_candidates <- candidates[skip_match, , drop = FALSE]
  candidates <- candidates[!skip_match, , drop = FALSE]
  if (nrow(skipped_candidates) > 0L) {
    cat(sprintf("Jeux explicitement sautes : %d (%s)\n",
                nrow(skipped_candidates),
                paste(skipped_candidates$dataset_name, collapse = ", ")))
  }
  if (!is.null(limit)) candidates <- utils::head(candidates, limit)
  cat(sprintf("Jeux candidats (geometrie constructible) : %d / %d\n",
              nrow(candidates), nrow(catalog)))

  index_rows <- vector("list", nrow(candidates))
  rejets <- list()

  for (i in seq_len(nrow(candidates))) {
    row <- candidates[i, , drop = FALSE]
    rid <- as.character(row$record_id)
    if (!nzchar(rid)) rid <- paste0(row$source_language, "_", row$package, "_", row$dataset_name)

    if (isTRUE(verbose)) {
      cat(sprintf("[%d/%d] %s::%s ... ", i, nrow(candidates),
                  as.character(row$package), as.character(row$dataset_name)))
      utils::flush.console()
    }

    step <- "init"
    res <- tryCatch({
      step <- "chargement"
      loaded <- load_dataset_object(row, repo_root, max_file_mb, min_file_mb)
      if (is_fail(loaded)) stop(reason_of(loaded), call. = FALSE)
      step <- "coercition_sf"
      cls <- paste(class(loaded$obj), collapse = "/")
      sf_raw <- tryCatch(coerce_to_sf(loaded$obj, row), error = function(e) {
        make_fail(paste0("coercion impossible [", cls, "]: ", conditionMessage(e)))
      })
      if (is_fail(sf_raw)) {
        stop(reason_of(sf_raw), call. = FALSE)
      }
      early_simplified <- FALSE
      if (is.finite(simplify_mb) && !is.null(loaded$file_mb) &&
          loaded$file_mb >= simplify_mb) {
        step <- "simplification_precoce"
        sf_raw <- simplify_large_sf_early(sf_raw, simplify_keep)
        early_simplified <- TRUE
      }
      # Garde : retirer les geometries vides / manquantes avant derivation.
      step <- "nettoyage_geometries"
      empty <- sf::st_is_empty(sf::st_geometry(sf_raw))
      keep_geometry <- !is.na(sf::st_geometry(sf_raw)) & !is.na(empty) & !empty
      sf_raw <- sf_raw[keep_geometry, , drop = FALSE]
      if (nrow(sf_raw) == 0) stop("toutes les geometries sont vides", call. = FALSE)
      step <- "famille_geometrie"
      famille <- geom_family(sf_raw, loaded$grille)
      if (famille == "autre") stop("type de geometrie non exploitable", call. = FALSE)

      step <- "construction_sf_unifie"
      simp <- if (!early_simplified && is.finite(simplify_mb) && !is.null(loaded$file_mb) &&
                  loaded$file_mb >= simplify_mb) simplify_keep else NULL
      unified <- build_unified_sf(sf_raw, famille, row, simplify_keep = simp)
      # La detection de reponse ne doit JAMAIS faire echouer une conversion :
      # toute erreur est capturee et la reponse est juste marquee inconnue.
      step <- "classification_reponse"
      resp <- tryCatch(classify_response(unified, row), error = function(e) {
        list(var = NA_character_, type = "inconnu", continu = NA,
             source = "erreur", candidats = conditionMessage(e))
      })

      step <- "metadonnees"
      crs_obj <- sf::st_crs(sf_raw)
      est_projete <- tryCatch(isFALSE(sf::st_is_longlat(sf_raw)), error = function(e) NA)
      attrs <- sf::st_drop_geometry(unified)
      k_attr <- ncol(attrs) - sum(c(COORD_X, COORD_Y, TIME_VAR) %in% names(attrs))
      explicatives_catalogue <- split_fields(row$candidate_x_variables)
      explicatives_presentes <- match_columns(names(attrs), explicatives_catalogue)


      # -- Normalisation CRS avant sauvegarde ----------------------------------
      # Cat B (CRS_OVERRIDES) : st_set_crs(epsg_reel) + st_transform(4326)
      # Cat A (est_projete)   : st_transform(4326) directement
      step <- "normalisation_crs"
      file_key <- safe_id(rid)

      if (file_key %in% names(CRS_OVERRIDES)) {
        true_epsg <- CRS_OVERRIDES[[file_key]]
        if (!is.na(true_epsg)) {
          cat(sprintf("    [CRS override] %s : set_crs(%d) + transform(4326)\n",
                      file_key, true_epsg))
          unified <- sf::st_set_crs(unified, true_epsg)
          unified <- tryCatch(
            sf::st_transform(unified, 4326),
            error = function(e) {
              warning(sprintf("st_transform(4326) echoue pour %s : %s",
                              file_key, e$message))
              unified
            }
          )
        } else {
          cat(sprintf("    [CRS override] %s : systeme local inconnu, pas de correction\n",
                      file_key))
        }
      } else if (isTRUE(est_projete)) {
        # Cat A : CRS projete correctement declare
        unified <- tryCatch(
          sf::st_transform(unified, 4326),
          error = function(e) {
            warning(sprintf("st_transform(4326) echoue pour %s : %s",
                            file_key, e$message))
            unified
          }
        )
      }

      # Mettre a jour crs_obj et est_projete apres eventuelle reprojection
      crs_obj     <- sf::st_crs(unified)
      est_projete <- tryCatch(isFALSE(sf::st_is_longlat(unified)),
                              error = function(e) NA)

      step <- "ecriture_rds"
      sf_path <- file.path(out_dir, paste0(safe_id(rid), ".rds"))
      saveRDS(unified, sf_path)

      list(
        record_id = rid,
        source_language = as.character(row$source_language),
        package = as.character(row$package),
        dataset = as.character(row$dataset_name),
        famille_geometrie = famille,
        geom_type_origine = paste(unique(as.character(sf::st_geometry_type(sf_raw))), collapse = "/"),
        crs_input = if (is.na(crs_obj)) NA_character_ else crs_obj$input,
        crs_epsg = crs_epsg_code(crs_obj),
        crs_name = crs_field(crs_obj, "Name"),
        crs_wkt = crs_field(crs_obj, "wkt"),
        est_projete = est_projete,
        n = nrow(unified),
        k = k_attr,
        analytical_variables = as.character(row$analytical_variables),
        metadata_variables = as.character(row$metadata_variables),
        identifier_variables = as.character(row$identifier_variables),
        candidate_x_variables = as.character(row$candidate_x_variables),
        candidate_x_variables_presentes = paste(explicatives_presentes, collapse = ", "),
        candidate_y_variables = as.character(row$candidate_y_variables),
        # has_formule : indicateur historique large (tout texte de formule present).
        has_formule = nonempty(row$formula_text) || nonempty(row$paper_formula_or_equation),
        # has_formule_modele : colonne de reference. N'accepte qu'une formule
        # plausible de modele (cf. formula_model_filter.R), filtrant les
        # fragments et les formules de graphe.
        has_formule_modele = is_plausible_model_formula(row$formula_text) ||
          is_plausible_model_formula(row$paper_formula_or_equation),
        variable_reponse = resp$var,
        type_reponse = resp$type,
        reponse_continue = resp$continu,
        reponse_source = resp$source,
        reponse_candidats = resp$candidats,
        a_variable_T = TIME_VAR %in% names(unified),
        sf_path = sub("^/", "", sub(repo_root, "", sf_path, fixed = TRUE)),
        utilisable = TRUE,
        raison = "ok"
      )
    }, error = function(e) {
      list(record_id = rid,
           source_language = as.character(row$source_language),
           package = as.character(row$package),
           dataset = as.character(row$dataset_name),
           utilisable = FALSE,
           raison = paste0("[", step, "] ", conditionMessage(e)))
    })

    if (isTRUE(res$utilisable)) {
      index_rows[[i]] <- res
      if (isTRUE(verbose)) cat(sprintf("ok (%s, n=%s)\n", res$famille_geometrie, res$n))
    } else {
      rejets[[length(rejets) + 1]] <- res
      index_rows[[i]] <- res
      if (isTRUE(verbose)) cat(sprintf("REJET %s\n", res$raison))
    }
  }

  if (nrow(skipped_candidates) > 0L) {
    skip_rows <- lapply(seq_len(nrow(skipped_candidates)), function(i) {
      row <- skipped_candidates[i, , drop = FALSE]
      list(
        record_id = as.character(row$record_id),
        source_language = as.character(row$source_language),
        package = as.character(row$package),
        dataset = as.character(row$dataset_name),
        utilisable = FALSE,
        raison = "[skip] exclusion explicite demandee"
      )
    })
    index_rows <- c(index_rows, skip_rows)
  }

  # Index complet (lignes ok + rejets), normalise en data.frame
  all_cols <- unique(unlist(lapply(index_rows, names)))
  to_df <- function(lst) {
    cols <- lapply(all_cols, function(col) {
      vapply(lst, function(r) {
        v <- r[[col]]
        if (is.null(v) || length(v) == 0) NA_character_ else as.character(v)[1]
      }, character(1))
    })
    names(cols) <- all_cols
    as.data.frame(cols, stringsAsFactors = FALSE, check.names = FALSE)
  }
  index_sf <- to_df(index_rows)

  # Mode fusion : on complete l'index existant au lieu de l'ecraser. Les jeux
  # retraites dans cette passe (memes record_id) sont remplaces par la version
  # courante ; les autres lignes precedentes sont conservees.
  if (isTRUE(append) && !is.null(previous_index)) {
      # Ne conserver que l'ancien index appartenant au perimetre courant des
      # 232 bons candidats spatiaux (apres deduplication).
      prev_index <- previous_index[
        as.character(previous_index$record_id) %in% scope_ids,
        , drop = FALSE
      ]
      prev_keep <- prev_index[!(as.character(prev_index$record_id) %in%
                                  as.character(index_sf$record_id)), , drop = FALSE]
      all_c <- union(names(prev_keep), names(index_sf))
      add_missing <- function(df) {
        for (cc in setdiff(all_c, names(df))) df[[cc]] <- NA_character_
        df[all_c]
      }
      index_sf <- rbind(add_missing(prev_keep), add_missing(index_sf))
      cat(sprintf("Fusion avec l'index existant : %d jeux conserves de la passe precedente\n",
                  nrow(prev_keep)))
  }

  # Les rejets sont derives de l'index final (coherent avec la fusion).
  rejets_sf <- index_sf[index_sf$utilisable != "TRUE", , drop = FALSE]

  ok <- index_sf$utilisable == "TRUE"
  n_num <- suppressWarnings(as.numeric(index_sf$n))
  taille_bucket <- cut(n_num,
                       breaks = c(-Inf, 50, 100, 500, 1000, 5000, Inf),
                       labels = c("<=50", "51-100", "101-500", "501-1000",
                                  "1001-5000", ">5000"))
  stats_sf <- list(
    total_candidats = nrow(index_sf),
    convertis = sum(ok),
    rejetes = sum(!ok),
    par_raison_rejet = table(index_sf$raison[!ok]),
    par_famille = table(index_sf$famille_geometrie[ok]),
    par_type_reponse = table(index_sf$type_reponse[ok]),
    par_source_reponse = table(index_sf$reponse_source[ok]),
    reponse_continue = table(index_sf$reponse_continue[ok]),
    avec_formule = table(index_sf$has_formule[ok]),
    avec_formule_modele = table(index_sf$has_formule_modele[ok]),
    projete = table(index_sf$est_projete[ok]),
    par_taille_N = table(taille_bucket[ok]),
    avec_variable_T = table(index_sf$a_variable_T[ok])
  )

  if (isTRUE(write_output)) {
    save_rdata_atomic(c("index_sf", "rejets_sf", "stats_sf"),
                      environment(),
                      file.path(out_dir, "catalogue_sf_index.RData"))
  }

  cat("\n=== Synthese conversion sf ===\n")
  cat(sprintf("Convertis : %d | Rejetes : %d\n", sum(ok), sum(!ok)))
  cat("Par famille de geometrie :\n");      print(stats_sf$par_famille)
  cat("Type de reponse :\n");               print(stats_sf$par_type_reponse)
  cat("Source de la reponse :\n");          print(stats_sf$par_source_reponse)
  cat("Reponse continue (TRUE/FALSE) :\n"); print(stats_sf$reponse_continue)
  cat("Avec formule (large) :\n");          print(stats_sf$avec_formule)
  cat("Avec formule modele (reference) :\n"); print(stats_sf$avec_formule_modele)
  cat("Par taille N :\n");                  print(stats_sf$par_taille_N)
  cat("Principales raisons de rejet :\n");  print(utils::head(sort(stats_sf$par_raison_rejet, decreasing = TRUE), 10))

  invisible(list(index = index_sf, rejets = rejets_sf, stats = stats_sf))
}

if (sys.nframe() == 0L) {
  # Astuces :
  #   build_sf_datasets(limit = 20)            # essai rapide
  #   build_sf_datasets(max_file_mb = 50)      # passe rapide : ignore les > 50 Mo
  #   build_sf_datasets(min_file_mb = 50,      # passe dediee aux gros jeux,
  #                     simplify_mb = 50,      #   avec simplification de la
  #                     simplify_keep = 0.05,  #   geometrie d'origine (5% sommets)
  #                     append = TRUE)         #   et FUSIONNE au catalogue sf
  build_sf_datasets()
}
