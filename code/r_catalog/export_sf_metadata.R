#!/usr/bin/env Rscript
# export_sf_metadata.R
#
# Role : produire sf_catalog_metadata.json pour le skill enrich-metadata.
#
# Le catalogue index_sf sert UNIQUEMENT a identifier les datasets
# retenus pour la modelisation spatiale (filtre sf_path + record_id).
# Toutes les metadonnees (Y, X, N, T, CRS, bbox...) sont extraites
# directement des objets sf. Le catalogue ne determine pas Y/X.
#
# Deduplication en 3 categories :
#   duplicate_exact   : meme N + k + bbox  -> retenir le plus riche (auto)
#   suspect_version   : meme nom dataset, N ou k different -> revue humaine
#   ok                : aucun match -> conserver
#
# Usage : source() dans RStudio ou Rscript export_sf_metadata.R

suppressPackageStartupMessages({
  library(sf)
  library(jsonlite)
})

# -- Chemins ------------------------------------------------------------------
REPO_ROOT   <- "C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"
INDEX_FILE  <- file.path(REPO_ROOT, "data/Final_datasets/sf/catalogue_sf_index.RData")
OUTPUT_FILE <- file.path(REPO_ROOT, "data/sf_catalog_metadata.json")

# -- Helpers deduplication ----------------------------------------------------

# Priorite package (dernier recours seulement)
PKG_PRIORITY <- c("spData", "geodaData", "spdep", "spatialreg")
pkg_rank <- function(pkg) {
  r <- match(pkg, PKG_PRIORITY)
  if (is.na(r)) length(PKG_PRIORITY) + 1L else r
}


# CRS d'analyse recommande (UTM local depuis centroide bbox) ------------------
recommend_crs_analyse <- function(crs_epsg, bbox) {
  if (is.null(crs_epsg) || !(crs_epsg %in% c("4326", "4269", "4267"))) {
    return(list(epsg = "pending", label = "pending",
                note = "CRS source non geographique ou inconnu"))
  }
  xmin <- bbox$xmin; xmax <- bbox$xmax
  ymin <- bbox$ymin; ymax <- bbox$ymax
  if (abs(xmin) > 180 || abs(xmax) > 180 || abs(ymin) > 90 || abs(ymax) > 90) {
    return(list(epsg = "pending", label = "pending",
                note = "bbox incoherente avec CRS geographique"))
  }
  lon_c  <- (xmin + xmax) / 2
  lat_c  <- (ymin + ymax) / 2
  x_span <- xmax - xmin
  if (x_span > 18) {
    return(list(epsg = "pending", label = "pending",
                note = paste0("multi-zones (span=", round(x_span,1),
                              "deg) -- projection nationale recommandee")))
  }
  zone <- max(1L, min(60L, as.integer(floor((lon_c + 180) / 6) + 1)))
  if (lat_c >= 0) {
    epsg  <- 32600L + zone
    label <- sprintf("UTM Zone %dN (EPSG:%d)", zone, epsg)
  } else {
    epsg  <- 32700L + zone
    label <- sprintf("UTM Zone %dS (EPSG:%d)", zone, epsg)
  }
  list(epsg = as.character(epsg), label = label,
       note = "calcul auto depuis centroide bbox -- normalisation WGS84 uniquement")
}

# Empreinte structurelle (N, k, bbox arrondie a 1 decimale)
make_fingerprint <- function(N, k, bbox) {
  paste(N, k,
        round(bbox$xmin, 1), round(bbox$xmax, 1),
        round(bbox$ymin, 1), round(bbox$ymax, 1),
        sep = "|")
}

# Nom normalise pour detection de versions proches
norm_name <- function(name) gsub("[^a-z0-9]", "", tolower(name))

# Score de richesse : k d'abord, puis N, puis has_formule, puis pkg_rank
richness_score <- function(entry) {
  k    <- entry$bloc4$k
  N    <- entry$bloc4$N
  has_f <- if (isTRUE(entry$bloc1$has_formule_in_catalogue)) 1L else 0L
  pr   <- pkg_rank(entry$package)
  # Retourner un vecteur comparable : max k, max N, has_formule, min pkg_rank
  c(k, N, has_f, -pr)
}

# Compare deux scores (retourne TRUE si a > b)
score_gt <- function(a, b) {
  for (i in seq_along(a)) {
    if (a[i] > b[i]) return(TRUE)
    if (a[i] < b[i]) return(FALSE)
  }
  FALSE
}

# -- Routage structurel (deterministe, par nom de colonne) --------------------
# Decide si une colonne est une coordonnee ou un identifiant -- jugement purement
# structurel, ne necessite aucune comprehension semantique. Le choix Y vs X
# (jugement de contenu) est delegue a un LLM en aval (generate_fiches.py).
route_structural <- function(name) {
  nm <- tolower(name)
  if (grepl("^lon$|^lat$|^long$|^latitude$|^longitude$|^x$|^y$|^lng$|coord|^easting$|^northing$|xloc$|yloc$|xcoord$|ycoord$", nm))
    return("spatial")
  # "index" volontairement exclu : trop ambigu dans ce domaine (povindex,
  # heat_load_index sont des metriques calculees, pas des cles d'identification).
  if (grepl("id$|^fid$|^gid$|code|key|^no$|^num$|objectid", nm))
    return("identifier")
  return(NA_character_)
}

# -- Typologie statistique -----------------------------------------------------
# Classe une colonne par son type (continuous/count/binary/rate/categorical/unknown).
# Ne prejuge pas de son role Y ou X -- c'est une typologie, pas une selection.
classify_typology <- function(col, name) {
  if (!is.atomic(col)) return(list(typology = "unknown", range = NA_character_))
  cls <- class(col)[1]

  if (cls %in% c("factor", "character"))
    return(list(typology = "categorical", range = NA_character_))

  if (!cls %in% c("numeric", "double", "integer", "logical"))
    return(list(typology = "unknown", range = NA_character_))

  vals   <- suppressWarnings(range(col, na.rm = TRUE))
  n_uniq <- length(unique(na.omit(col)))

  if (cls == "logical" || all(na.omit(col) %in% c(0, 1)))
    return(list(typology = "binary", range = "{0, 1}"))
  if (cls %in% c("numeric", "double")) {
    if (is.finite(vals[1]) && is.finite(vals[2]) && vals[1] >= 0 && vals[2] <= 1 && n_uniq > 5)
      return(list(typology = "rate",
                  range = paste0("[", round(vals[1],4), ", ", round(vals[2],4), "]")))
    return(list(typology = "continuous",
                range = paste0("[", round(vals[1],4), ", ", round(vals[2],4), "]")))
  }
  if (cls == "integer")
    return(list(typology = "count",
                range = paste0("[", vals[1], ", ", vals[2], "]")))
  return(list(typology = "unknown", range = NA_character_))
}

# -- Profil N/T ---------------------------------------------------------------
profil_nt <- function(N, T) {
  n_cat <- if (N >= 500) "N_grand" else if (N >= 50) "N_moyen" else "N_petit"
  t_cat <- if (T >= 10)  "T_grand" else if (T > 1)   "T_moyen" else "T_1"
  paste0(n_cat, "_", t_cat)
}

# -- Inspection complete d'un sf ----------------------------------------------
inspect_sf <- function(path, catalogue_row) {
  obj <- tryCatch(readRDS(path), error = function(e) {
    cat("    ERREUR:", e$message, "\n"); return(NULL)
  })
  if (is.null(obj) || !inherits(obj, "sf")) {
    cat("    Non-sf ou erreur\n"); return(NULL)
  }

  geom_col <- attr(obj, "sf_column")
  vars     <- setdiff(names(obj), geom_col)
  df       <- as.data.frame(obj)[, vars, drop = FALSE]

  # Correction 2 : exclure les colonnes geometrie residuelles (sfc_*, sfg, geom_*)
  sfc_cols <- vars[sapply(vars, function(v) {
    cl <- class(df[[v]])[1]
    startsWith(cl, "sfc") || cl == "sfg" || cl == "sfc"
  })]
  if (length(sfc_cols) > 0) {
    vars <- setdiff(vars, sfc_cols)
    df   <- df[, vars, drop = FALSE]
  }

  crs_info  <- sf::st_crs(obj)
  bbox      <- sf::st_bbox(obj)
  geom_type <- as.character(sf::st_geometry_type(obj, by_geometry = FALSE))
  epsg      <- if (!is.na(crs_info$epsg)) as.character(crs_info$epsg) else "NA_pending_lookup"
  crs_name  <- if (!is.null(crs_info$Name)) crs_info$Name else "unknown"

  time_pat <- "year|date|time|month|annee|periode|timestamp|^yr$|^an$"
  t_vars   <- vars[grepl(time_pat, vars, ignore.case = TRUE)]
  T_val    <- 1L
  T_var    <- NA_character_
  if (length(t_vars) > 0) {
    T_var <- t_vars[1]
    T_val <- as.integer(length(unique(df[[T_var]])))
  }

  variables     <- list()
  coord_columns <- list()
  id_columns    <- list()
  warnings_vars <- character(0)

  for (v in vars) {
    col    <- df[[v]]
    cls    <- class(col)[1]
    n_uniq <- length(unique(na.omit(col)))
    n_na   <- sum(is.na(col))
    pct_na <- round(100 * n_na / length(col), 1)

    if (pct_na > 20)
      warnings_vars <- c(warnings_vars, paste0(v, " (NA=", pct_na, "%)"))

    # Routage structurel deterministe (coordonnees / identifiants) -- jugement
    # de contenu (Y vs X) volontairement absent ici, delegue au LLM en aval.
    route <- route_structural(v)
    if (identical(route, "spatial")) {
      coord_columns[[length(coord_columns)+1]] <- list(
        name = v, class = cls, pct_na = pct_na)
      next
    }
    if (identical(route, "identifier")) {
      id_columns[[length(id_columns)+1]] <- list(
        name = v, class = cls, pct_na = pct_na)
      next
    }

    typ_info <- classify_typology(col, v)
    variables[[length(variables)+1]] <- list(
      name = v, class = cls,
      typology = typ_info$typology, range = typ_info$range,
      n_unique = n_uniq, pct_na = pct_na)
  }

  has_formule        <- isTRUE(as.logical(catalogue_row$has_formule))
  has_formule_modele <- isTRUE(as.logical(catalogue_row$has_formule_modele))
  N <- nrow(obj)
  k <- length(vars)

  bbox_list <- list(
    xmin = round(bbox["xmin"], 6), xmax = round(bbox["xmax"], 6),
    ymin = round(bbox["ymin"], 6), ymax = round(bbox["ymax"], 6)
  )

  list(
    dataset_id   = tools::file_path_sans_ext(basename(path)),
    record_id    = as.character(catalogue_row$record_id),
    rds_path     = sub(paste0(REPO_ROOT, "/"), "", path),
    source_lang  = as.character(catalogue_row$source_language),
    package      = as.character(catalogue_row$package),
    dataset      = as.character(catalogue_row$dataset),
    dataset_norm = norm_name(as.character(catalogue_row$dataset)),
    status       = "ok",
    duplicate_of = NULL,

    bloc1 = list(
      variables                = variables,
      coordinate_columns       = coord_columns,
      identifier_columns       = id_columns,
      formula_pub              = NULL,
      formula_used             = NULL,
      has_formule_in_catalogue = has_formule,
      has_formule_modele       = has_formule_modele
    ),
    bloc2 = list(doi_dataset = NULL, doi_publication = NULL,
                 url_script = NULL, url_source = NULL),
    bloc3 = list(model_level1 = NULL, model_level2 = NULL, model_level3 = NULL),
    bloc4 = list(
      N = N, T = T_val, T_var = T_var, k = k,
      data_type = if (T_val > 1) "spatio-temporel" else "spatial",
      structure  = if (T_val > 1) "panel" else "coupe_transversale",
      profil_nt  = profil_nt(N, T_val)
    ),
    bloc5 = list(
      geom_type             = geom_type,
      crs_epsg              = epsg,
      crs_name              = crs_name,
      bbox                  = bbox_list,
      spatial_resolution    = NULL,
      temporal_resolution   = if (T_val > 1) "pending_inspection" else "NA",
      temporal_extent       = NULL,
      crs_analyse_recommande = recommend_crs_analyse(epsg, bbox_list)
    ),
    bloc6 = list(script_url = NULL, licence = NULL, depot = NULL),
    qc = list(
      vars_high_na = warnings_vars,
      crs_missing  = epsg == "NA_pending_lookup",
      geom_complex = geom_type %in% c("GEOMETRYCOLLECTION", "GEOMETRY"),
      fingerprint  = make_fingerprint(N, k, bbox_list)
    )
  )
}

# -- Chargement du catalogue --------------------------------------------------
cat("Chargement catalogue index_sf...\n")
env <- new.env()
load(INDEX_FILE, envir = env)
index_sf <- env$index_sf

good <- index_sf[index_sf$utilisable == "TRUE" & !is.na(index_sf$sf_path), ]
cat("Datasets a traiter :", nrow(good), "\n\n")

# -- Boucle principale --------------------------------------------------------
catalog    <- list()
date_today <- format(Sys.Date(), "%Y-%m-%d")

for (i in seq_len(nrow(good))) {
  row      <- good[i, ]
  rds_rel  <- as.character(row$sf_path)
  rds_path <- file.path(REPO_ROOT, rds_rel)

  cat(sprintf("[%d/%d] %s\n", i, nrow(good), basename(rds_path)))
  if (!file.exists(rds_path)) { cat("  WARN: fichier absent\n"); next }

  meta <- inspect_sf(rds_path, row)
  if (!is.null(meta)) catalog[[length(catalog)+1]] <- meta
}

# =============================================================================
# DEDUPLICATION
# =============================================================================
cat("\n====== Deduplication ======\n")

# ---- Categorie 1 : duplicate_exact (meme N + k + bbox) ---------------------
cat("\n-- Etape 1 : doublons exacts (N + k + bbox) --\n")

fp_vec    <- sapply(catalog, function(m) m$qc$fingerprint)
dup_grps  <- split(seq_along(catalog), fp_vec)

exact_report <- list()
keep_after_exact <- integer(0)

for (fp in names(dup_grps)) {
  grp <- dup_grps[[fp]]

  if (length(grp) == 1) {
    keep_after_exact <- c(keep_after_exact, grp)
    next
  }

  # Choisir le plus riche
  scores  <- lapply(grp, function(i) richness_score(catalog[[i]]))
  best_pos <- grp[1]
  for (j in seq_along(grp)[-1]) {
    if (score_gt(scores[[j]], scores[[which(grp == best_pos)]])) best_pos <- grp[j]
  }
  losers <- setdiff(grp, best_pos)

  keep_after_exact <- c(keep_after_exact, best_pos)
  winner_id <- catalog[[best_pos]]$dataset_id

  for (l in losers) {
    catalog[[l]]$status       <- "duplicate_exact"
    catalog[[l]]$duplicate_of <- winner_id
  }

  # Raison de selection
  sc_winner <- richness_score(catalog[[best_pos]])
  reason <- paste0("k=", sc_winner[1], " N=", sc_winner[2],
                   " has_formule=", sc_winner[3],
                   " pkg=", catalog[[best_pos]]$package)

  exact_report[[length(exact_report)+1]] <- list(
    fingerprint      = fp,
    retained_id      = winner_id,
    retained_package = catalog[[best_pos]]$package,
    selection_reason = reason,
    duplicates       = lapply(losers, function(l) list(
      dataset_id = catalog[[l]]$dataset_id,
      package    = catalog[[l]]$package,
      k          = catalog[[l]]$bloc4$k,
      N          = catalog[[l]]$bloc4$N
    ))
  )

  cat(sprintf("  EXACT: retenu=%s (%s) | ecartes=%s\n",
    winner_id, catalog[[best_pos]]$package,
    paste(sapply(losers, function(l) catalog[[l]]$dataset_id), collapse=", ")))
}

catalog_after_exact <- catalog[sort(keep_after_exact)]
cat(sprintf("  -> %d retenus apres deduplication exacte\n", length(catalog_after_exact)))

# ---- Categorie 2 : suspect_version (meme nom normalise, N ou k different) ---
cat("\n-- Etape 2 : versions suspectes (meme nom, structure differente) --\n")

norm_vec  <- sapply(catalog_after_exact, function(m) m$dataset_norm)
name_grps <- split(seq_along(catalog_after_exact), norm_vec)

suspect_report <- list()

for (nm in names(name_grps)) {
  grp <- name_grps[[nm]]
  if (length(grp) <= 1 || nchar(nm) == 0) next  # saut si singleton ou nom vide (norm_name bug residuel)

  # Verifier si N ou k different dans le groupe
  Ns <- sapply(grp, function(i) catalog_after_exact[[i]]$bloc4$N)
  ks <- sapply(grp, function(i) catalog_after_exact[[i]]$bloc4$k)

  if (length(unique(Ns)) == 1 && length(unique(ks)) == 1) next  # identiques -> deja traites

  # Flag suspect_version sur tous les membres du groupe
  for (i in grp) catalog_after_exact[[i]]$status <- "suspect_version"

  versions <- lapply(grp, function(i) {
    e <- catalog_after_exact[[i]]
    list(dataset_id  = e$dataset_id,
         package     = e$package,
         N           = e$bloc4$N,
         k           = e$bloc4$k,
         has_formule = e$bloc1$has_formule_in_catalogue,
         crs_epsg    = e$bloc5$crs_epsg)
  })

  suspect_report[[length(suspect_report)+1]] <- list(
    dataset_name_norm = nm,
    n_versions        = length(grp),
    action_required   = "choisir la version a conserver et marquer les autres duplicate_of",
    versions          = versions
  )

  cat(sprintf("  SUSPECT: '%s' -> %d versions (%s)\n",
    nm, length(grp),
    paste(sapply(grp, function(i) sprintf("%s(k=%d,N=%d)",
      catalog_after_exact[[i]]$package,
      catalog_after_exact[[i]]$bloc4$k,
      catalog_after_exact[[i]]$bloc4$N)), collapse=" | ")))
}

# -- Resume ------------------------------------------------------------------
n_exact   <- length(catalog) - length(catalog_after_exact)
n_suspect <- length(suspect_report)
n_ok      <- sum(sapply(catalog_after_exact, function(m) m$status == "ok"))

cat(sprintf("\n%d inspectes | %d doublons exacts ecartes | %d versions suspectes (revue requise) | %d ok\n",
            length(catalog), n_exact, n_suspect, n_ok))

if (n_suspect > 0)
  cat("ATTENTION: voir la section 'suspect_versions' dans le JSON avant de generer les fiches.\n")

# -- Sortie JSON --------------------------------------------------------------
out <- list(
  generated_at         = date_today,
  n_datasets_inspected = length(catalog),
  n_exact_duplicates   = n_exact,
  n_suspect_versions   = n_suspect,
  n_ok                   = n_ok,
  source_index           = as.character(INDEX_FILE),
  schema_ref             = "wiki/metadata/catalog_registry_schema_v3.md",
  exact_duplicate_groups = exact_report,
  suspect_versions       = suspect_report,
  datasets               = catalog_after_exact
)

dir.create(dirname(OUTPUT_FILE), recursive = TRUE, showWarnings = FALSE)
jsonlite::write_json(out, OUTPUT_FILE, auto_unbox = TRUE, pretty = TRUE, null = "null")
cat(sprintf("\nJSON ecrit : %s\n", OUTPUT_FILE))
cat(sprintf("%d datasets dans le JSON (%d ok, %d suspect_version)\n",
            length(catalog_after_exact), n_ok, n_suspect))
