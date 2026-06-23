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
# NB CRS : conformement a la decision "geometrie d'abord, CRS plus tard", ce
# script NE reprojette PAS. Il enregistre seulement le CRS natif et un drapeau
# est_projete ; une etape dediee (st_transform vers le CRS metrique de la zone)
# viendra ensuite, sur les jeux marques non projetes.
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

split_fields <- function(x) {
  x <- as.character(x)
  if (length(x) == 0 || is.na(x) || !nzchar(trimws(x))) return(character(0))
  values <- trimws(unlist(strsplit(x, ",", fixed = TRUE)))
  unique(values[nzchar(values)])
}

nonempty <- function(x) {
  !is.na(x) & nzchar(trimws(as.character(x)))
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
load_dataset_object <- function(row, repo_root, max_file_mb = Inf) {
  fail <- function(reason) {
    out <- NULL
    attr(out, "reason") <- reason
    out
  }
  lang <- as.character(row$source_language)
  pkg  <- trimws(as.character(row$package))
  dsn  <- trimws(as.character(row$dataset_name))
  ent  <- trimws(as.character(row$source_entry))

  too_big <- function(path) {
    mb <- file.size(path) / 1024^2
    if (is.finite(max_file_mb) && mb > max_file_mb) {
      return(sprintf("fichier ignore (%.0f Mo > %g Mo): %s", mb, max_file_mb, basename(path)))
    }
    ""
  }

  # 1a. Fichier spatial / tabulaire local (surtout cote Python)
  files <- resolve_local_files(row$local_files, repo_root)
  spat  <- files[grepl("[.](geojson|gpkg|shp|parquet)$", files, ignore.case = TRUE)]
  if (length(spat) > 0) {
    big <- too_big(spat[1]); if (nzchar(big)) return(fail(big))
    obj <- tryCatch(sf::st_read(spat[1], quiet = TRUE), error = function(e) NULL)
    if (!is.null(obj)) return(list(obj = obj, grille = FALSE))
  }
  csvs <- files[grepl("[.]csv$", files, ignore.case = TRUE)]
  if (length(csvs) > 0) {
    big <- too_big(csvs[1]); if (nzchar(big)) return(fail(big))
    obj <- tryCatch(utils::read.csv(csvs[1], stringsAsFactors = FALSE),
                    error = function(e) NULL)
    if (!is.null(obj)) return(list(obj = obj, grille = FALSE))
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
      list(obj = obj, grille = is_grid)
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
  fail <- function(reason) { out <- NULL; attr(out, "reason") <- reason; out }

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

build_unified_sf <- function(sf_obj, famille, row) {
  pts <- derive_point_geometry(sf_obj, famille)
  if (is.null(pts) || length(pts) == 0) {
    stop("derivation de la geometrie point impossible", call. = FALSE)
  }

  crs_orig  <- sf::st_crs(sf_obj)
  pts       <- sf::st_sfc(pts, crs = crs_orig)          # garantir un sfc
  geom_orig <- sf::st_geometry(sf_obj)
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

classify_response <- function(sf_obj, row) {
  attrs <- sf::st_drop_geometry(sf_obj)
  ycols <- match_columns(names(attrs), split_fields(row$candidate_y_variables))
  if (length(ycols) == 0) return(list(var = NA_character_, type = "inconnu", continu = NA))
  y <- attrs[[ycols[1]]]
  y <- y[!is.na(y)]
  if (length(y) == 0) return(list(var = ycols[1], type = "inconnu", continu = NA))

  if (is.logical(y) || is.factor(y) || is.character(y)) {
    return(list(var = ycols[1], type = "discret", continu = FALSE))
  }
  if (is.numeric(y)) {
    u <- unique(y)
    entiers <- all(abs(y - round(y)) < 1e-9)
    if (all(y >= 0 & y <= 1) && !entiers) {
      return(list(var = ycols[1], type = "proportion", continu = TRUE))
    }
    if (entiers && length(u) <= 10) {
      return(list(var = ycols[1], type = "discret", continu = FALSE))
    }
    if (entiers) {
      return(list(var = ycols[1], type = "comptage", continu = FALSE))
    }
    return(list(var = ycols[1], type = "continu", continu = TRUE))
  }
  list(var = ycols[1], type = "inconnu", continu = NA)
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
                              dedupe = TRUE,
                              verbose = TRUE) {
  manifest_dir <- file.path(repo_root, "data", "manifests", "datasets")
  combined_path <- file.path(manifest_dir, "software_catalog_combined.RData")
  if (!file.exists(combined_path)) {
    stop("Catalogue combine absent : ", combined_path, call. = FALSE)
  }
  out_dir <- file.path(repo_root, "data", "final_datasets", "sf")
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

  env <- new.env(parent = emptyenv())
  load(combined_path, envir = env)
  catalog <- if (exists("catalogue_combine_complet", envir = env, inherits = FALSE)) {
    env$catalogue_combine_complet
  } else {
    stop("Objet catalogue_combine_complet absent du RData.", call. = FALSE)
  }

  keep <- is_constructible(catalog)
  candidates <- catalog[keep, , drop = FALSE]
  n_constructibles <- nrow(candidates)
  if (isTRUE(dedupe)) {
    candidates <- dedupe_cross_package(candidates)
    cat(sprintf("Doublons inter-packages retires : %d\n",
                n_constructibles - nrow(candidates)))
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
      loaded <- load_dataset_object(row, repo_root, max_file_mb)
      if (is.null(loaded)) stop(attr(loaded, "reason") %||% "chargement impossible", call. = FALSE)
      step <- "coercition_sf"
      cls <- paste(class(loaded$obj), collapse = "/")
      sf_raw <- tryCatch(coerce_to_sf(loaded$obj, row), error = function(e) {
        z <- NULL
        attr(z, "reason") <- paste0("coercion impossible [", cls, "]: ", conditionMessage(e))
        z
      })
      if (is.null(sf_raw)) {
        stop(attr(sf_raw, "reason") %||% paste0("coercition sf impossible [", cls, "]"), call. = FALSE)
      }
      # Garde : retirer les geometries vides / manquantes avant derivation.
      step <- "nettoyage_geometries"
      sf_raw <- sf_raw[!sf::st_is_empty(sf::st_geometry(sf_raw)), , drop = FALSE]
      if (nrow(sf_raw) == 0) stop("toutes les geometries sont vides", call. = FALSE)
      step <- "famille_geometrie"
      famille <- geom_family(sf_raw, loaded$grille)
      if (famille == "autre") stop("type de geometrie non exploitable", call. = FALSE)

      step <- "construction_sf_unifie"
      unified <- build_unified_sf(sf_raw, famille, row)
      step <- "classification_reponse"
      resp <- classify_response(unified, row)

      step <- "metadonnees"
      crs_obj <- sf::st_crs(sf_raw)
      est_projete <- tryCatch(isFALSE(sf::st_is_longlat(sf_raw)), error = function(e) NA)
      attrs <- sf::st_drop_geometry(unified)
      k_attr <- ncol(attrs) - sum(c(COORD_X, COORD_Y, TIME_VAR) %in% names(attrs))

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
        est_projete = est_projete,
        n = nrow(unified),
        k = k_attr,
        has_formule = nonempty(row$formula_text) || nonempty(row$paper_formula_or_equation),
        variable_reponse = resp$var,
        type_reponse = resp$type,
        reponse_continue = resp$continu,
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
  rejets_sf <- if (length(rejets)) to_df(rejets) else index_sf[0, , drop = FALSE]

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
    reponse_continue = table(index_sf$reponse_continue[ok]),
    avec_formule = table(index_sf$has_formule[ok]),
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
  cat("Reponse continue (TRUE/FALSE) :\n"); print(stats_sf$reponse_continue)
  cat("Avec formule :\n");                  print(stats_sf$avec_formule)
  cat("Par taille N :\n");                  print(stats_sf$par_taille_N)
  cat("Principales raisons de rejet :\n");  print(utils::head(sort(stats_sf$par_raison_rejet, decreasing = TRUE), 10))

  invisible(list(index = index_sf, rejets = rejets_sf, stats = stats_sf))
}

if (sys.nframe() == 0L) {
  # Astuces :
  #   build_sf_datasets(limit = 20)            # essai rapide
  #   build_sf_datasets(max_file_mb = 100)     # ignore les fichiers > 100 Mo
  #   build_sf_datasets(dedupe = FALSE)        # desactive la dedup inter-packages
  #   build_sf_datasets(verbose = FALSE)       # sortie silencieuse
  build_sf_datasets()
}
