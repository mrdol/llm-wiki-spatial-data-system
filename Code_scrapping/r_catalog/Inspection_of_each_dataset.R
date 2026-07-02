###### Identifier le rôle probable d'un objet chargé avec data()
object_attribute_names <- function(obj) {
  if (inherits(obj, "sf") || is.data.frame(obj)) {
    return(names(obj))
  }
  if (inherits(obj, "Spatial") && "data" %in% slotNames(obj)) {
    return(names(obj@data))
  }
  if (is.matrix(obj)) {
    vars <- colnames(obj)
    if (is.null(vars)) {
      vars <- paste0("V", seq_len(ncol(obj)))
    }
    return(vars)
  }
  names(obj)
}

object_attribute_count <- function(obj) {
  vars <- object_attribute_names(obj)
  if (is.null(vars)) {
    return(0L)
  }
  sum(!grepl("^(geometry|geom|shape|wkt)$", vars, ignore.case = TRUE))
}

find_rd_documentation <- function(pkg, topic) {
  rd_db <- tryCatch(tools::Rd_db(pkg), error = function(err) list())
  if (length(rd_db) == 0L) {
    return(NULL)
  }

  direct_name <- paste0(topic, ".Rd")
  if (direct_name %in% names(rd_db)) {
    return(rd_db[[direct_name]])
  }

  matching_page <- names(rd_db)[vapply(rd_db, function(rd) {
    aliases <- tryCatch(
      tools:::.Rd_get_metadata(rd, "alias"),
      error = function(err) character(0)
    )
    topic %in% aliases
  }, logical(1))]

  if (length(matching_page) == 0L) {
    return(NULL)
  }
  rd_db[[matching_page[1L]]]
}

guess_object_role <- function(obj, obj_name, bundle, doc_text = "") {
  # Determine le role analytique, pas seulement le type R de l'objet.
  name_lower <- tolower(obj_name)
  doc_lower <- tolower(paste(doc_text, collapse = " "))
  evidence <- paste(name_lower, tolower(bundle), doc_lower)
  support_name <- grepl(
    "study.?area|study.?mask|mask|boundary|boundaries|border|outline|extent|bbox|domain|window",
    name_lower
  )
  support_doc <- grepl(
    "\\b(mask|study area|study region|boundary|boundaries|prediction domain|spatial extent)\\b",
    doc_lower
  )
  response_doc <- grepl(
    "response|outcome|dependent variable|species richness|community matrix|presence|absence|abundance|yield|cases|counts?",
    evidence
  )
  predictor_doc <- grepl(
    "predictor|covariate|explanatory|environmental variable|elevation|terrain|climate|ndvi",
    evidence
  )

  if (name_lower == "bbs") {
    return("deprecated_auxiliary")
  }

  if (inherits(obj, "nb")) {
    if (grepl("paper|alt|alternative", name_lower)) {
      return("neighbor_graph_alternative")
    }
    return("neighbor_graph")
  }

  if (inherits(obj, "listw")) {
    return("spatial_weights")
  }

  if (inherits(obj, c("ppp", "lpp", "psp", "linnet"))) {
    return("spatial_observations")
  }

  if (inherits(obj, "im")) {
    return("spatial_predictors")
  }

  if (inherits(obj, "owin")) {
    return("prediction_domain")
  }

  if (inherits(obj, c("solist", "hyperframe"))) {
    return("observation_collection")
  }

  if (inherits(obj, c("STSDF", "STFDF", "STIDF"))) {
    return("spatial_observations")
  }

  if (inherits(obj, "sts")) {
    return("spatial_observations")
  }

  if (inherits(obj, c(
    "RasterLayer", "RasterStack", "RasterBrick", "SpatRaster"
  ))) {
    return("spatial_predictors")
  }

  if (inherits(obj, "sf")) {
    if (support_name || (support_doc && object_attribute_count(obj) <= 2L)) {
      return("prediction_domain")
    }
    if (object_attribute_count(obj) == 0L) {
      return("geometry")
    }
    if (response_doc) {
      return("spatial_observations")
    }
    if (predictor_doc) {
      return("spatial_predictors")
    }
    return("spatial_observations")
  }

  if (inherits(obj, "SpatialPointsDataFrame") ||
      inherits(obj, "SpatialPolygonsDataFrame") ||
      inherits(obj, "SpatialLinesDataFrame")) {
    if (support_name || (support_doc && object_attribute_count(obj) <= 2L)) {
      return("prediction_domain")
    }
    return("spatial_observations")
  }

  if (inherits(obj, "SpatialPoints") ||
      inherits(obj, "SpatialPolygons") ||
      inherits(obj, "SpatialLines") ||
      inherits(obj, "polylist")) {
    return("geometry")
  }

  if (is.matrix(obj)) {
    if (ncol(obj) == 2 && grepl("xy|coord|coords", name_lower)) {
      return("coordinates")
    }
    if (nrow(obj) == ncol(obj) &&
        grepl("weight|adj|dist|neighbor|neighbour|connect", evidence)) {
      return("weights_or_adjacency_matrix")
    }
    if (response_doc || grepl("comm|species|response|abund|presence", name_lower)) {
      return("response_matrix")
    }
    if (predictor_doc) {
      return("predictor_matrix")
    }
    return("matrix_review")
  }

  if (inherits(obj, "hyperframe")) {
    return("observation_table")
  }

  if (is.data.frame(obj)) {
    vars_lower <- tolower(names(obj))
    coordinate_only <- (
      grepl("coord|coords|xy$", name_lower) && ncol(obj) <= 4L
    ) || (ncol(obj) <= 2L && (
      all(c("x", "y") %in% vars_lower) ||
        all(c("lon", "lat") %in% vars_lower) ||
        all(c("longitude", "latitude") %in% vars_lower) ||
        all(c("easting", "northing") %in% vars_lower) ||
        all(c("x.loc", "y.loc") %in% vars_lower) ||
        all(c("utm.ew", "utm.ns") %in% vars_lower) ||
        all(c("e", "n") %in% vars_lower)
    ))
    if (coordinate_only) {
      return("coordinates")
    }
    if (support_name && nrow(obj) <= 1L) {
      return("lookup_or_metadata_table")
    }
    if (response_doc && ncol(obj) > 1L) {
      return("response_table")
    }
    if (predictor_doc && ncol(obj) > 1L) {
      return("predictor_table")
    }
    if (obj_name == bundle || grepl("df|data|table", name_lower)) {
      return("observation_table")
    }
    return("observation_table")
  }

  if (is.list(obj) && length(obj) > 0L) {
    analytical_tables <- vapply(obj, function(item) {
      (is.data.frame(item) || is.matrix(item)) &&
        nrow(item) >= 2L &&
        ncol(item) >= 2L
    }, logical(1))
    distance_sizes <- vapply(obj, function(item) {
      if (inherits(item, "dist")) {
        return(as.integer(attr(item, "Size")))
      }
      NA_integer_
    }, integer(1))
    table_rows <- vapply(obj, function(item) {
      if (is.data.frame(item) || is.matrix(item)) {
        return(nrow(item))
      }
      NA_integer_
    }, integer(1))
    distance_matches_table <- any(
      !is.na(distance_sizes) &
        distance_sizes %in% table_rows[!is.na(table_rows)]
    )
    if (any(analytical_tables) || distance_matches_table) {
      return("observation_collection")
    }

    child_classes <- vapply(
      obj,
      function(item) paste(class(item), collapse = "/"),
      character(1)
    )
    if (!grepl("extra|aux|meta", name_lower) &&
        any(grepl("ppp|lpp|psp|im|Spatial|sf", child_classes))) {
      return("observation_collection")
    }
    atomic_parts <- vapply(obj, is.atomic, logical(1))
    part_lengths <- vapply(obj, length, integer(1))
    lengths_match <- length(unique(part_lengths)) == 1L
    if (all(atomic_parts) && lengths_match) {
      return("observation_table")
    }
    return("list_auxiliary")
  }

  if (is.atomic(obj)) {
    return("vector_auxiliary")
  }

  "other"
}

###### Traduire le rôle en décision de conservation provisoir 
guess_keep_from_role <- function(role) {
  if (role %in% c(
    "spatial_observations",
    "spatial_predictors",
    "observation_table",
    "response_table",
    "response_matrix",
    "predictor_table",
    "predictor_matrix",
    "observation_collection"
  )) {
    return("yes")
  }

  if (role == "attribute_table") {
    return("yes_joinable")
  }

  if (role == "deprecated_auxiliary") {
    return("review")
  }

  if (role %in% c(
    "neighbor_graph",
    "neighbor_graph_alternative",
    "spatial_weights",
    "coordinates",
    "geometry",
    "prediction_domain",
    "lookup_or_metadata_table",
    "list_auxiliary",
    "weights_or_adjacency_matrix",
    "vector_auxiliary"
  )) {
    return("yes_auxiliary")
  }

  "review"
}

###### Interprète les libellés affichés par data(package = ...)
as_single_character <- function(x, name) {
  # Convertit les entrees interactives en chaine simple.
  # Cela evite que utils::data(list = ...) recoive par erreur une liste
  # ou un facteur, ce qui produit l'erreur "is.character(list) n'est pas TRUE".
  if (is.factor(x)) {
    x <- as.character(x)
  }

  if (is.list(x) && length(x) == 1L) {
    x <- x[[1L]]
  }

  if (!is.character(x) || length(x) != 1L || is.na(x) || !nzchar(x)) {
    stop(name, " doit etre une chaine de caracteres unique.", call. = FALSE)
  }

  x
}

parse_dataset_label <- function(dataset) {
  # Interprète les libellés affichés par data(package = ...).
  # Exemple : "LO_nb (house)" signifie :
  # - objet demandé : LO_nb
  # - bundle à charger : house
  dataset <- as_single_character(dataset, "dataset")
  has_bundle <- grepl("\\(.+\\)$", dataset)
  
  if (has_bundle) {
    object <- trimws(sub("\\s*\\(.+\\)$", "", dataset))
    bundle <- trimws(sub("^.*\\((.+)\\)$", "\\1", dataset))
  } else {
    object <- dataset
    bundle <- dataset
  }
  
  list(
    object = object,
    bundle = bundle,
    load_name = bundle
  )
}

########################### Instection de chaque jeu de données du package (PRINCIPAL!!!)

print_nb_resume <- function(obj, n_regions = 5) {
  # Résumé compact d'un objet de voisinage.
  degrees <- lengths(obj)
  
  cat("Type : graphe de voisinage spatial\n")
  cat("Nombre de régions :", length(obj), "\n")
  cat("Nombre total de liens :", sum(degrees), "\n")
  cat("Nombre moyen de voisins :", round(mean(degrees), 3), "\n")
  cat("Minimum / maximum de voisins :", min(degrees), "/", max(degrees), "\n")
  
  cat("\nDistribution du nombre de voisins :\n")
  print(table(degrees))
  
  cat("\nAperçu des premiers voisinages :\n")
  for (i in seq_len(min(n_regions, length(obj)))) {
    cat(i, "->", paste(head(obj[[i]], 10), collapse = ", "))
    if (length(obj[[i]]) > 10) cat(" ...")
    cat("\n")
  }
}

print_listw_resume <- function(obj) {
  # Résumé compact d'un objet de poids spatiaux.
  cat("Type : poids spatiaux listw\n")
  cat("Style :", obj$style, "\n")
  cat("Nombre de régions :", length(obj$neighbours), "\n")
  cat("Nombre moyen de voisins :", round(mean(lengths(obj$neighbours)), 3), "\n")
}

print_polylist_resume <- function(obj, n_polygons = 3) {
  # Resume compact d'un objet polylist.
  # Les polylist sont souvent des geometries auxiliaires anciennes,
  # par exemple les contours de quartiers associes a une table principale.
  cat("Type : geometrie polygonale auxiliaire polylist\n")
  cat("Nombre de polygones :", length(obj), "\n")

  region_id <- attr(obj, "region.id")
  if (!is.null(region_id)) {
    cat("Identifiants de regions disponibles : oui\n")
    cat("Apercu des identifiants :", paste(utils::head(region_id, 10), collapse = ", "), "\n")
  } else {
    cat("Identifiants de regions disponibles : non\n")
  }

  maplim <- attr(obj, "maplim")
  if (!is.null(maplim)) {
    cat("\nLimites spatiales approximatives :\n")
    print(maplim)
  }

  cat("\nApercu des premiers polygones :\n")
  for (i in seq_len(min(n_polygons, length(obj)))) {
    poly <- obj[[i]]
    cat("Polygone", i, ":", nrow(poly), "sommets x", ncol(poly), "coordonnees\n")
    print(utils::head(poly, 5))
  }
}

print_auxiliary_resume <- function(obj, obj_name, role, keep) {
  # Affiche uniquement les informations propres à un fichier auxiliaire.
  cat("\n--------------------\n")
  cat("Objet inspecté :", obj_name, "\n")
  cat("Classe :", paste(class(obj), collapse = ", "), "\n")
  cat("Rôle proposé :", role, "\n")
  cat("Décision proposée :", keep, "\n")
  cat("--------------------\n")
  
  if (inherits(obj, "nb")) {
    print_nb_resume(obj)
    
  } else if (inherits(obj, "listw")) {
    print_listw_resume(obj)

  } else if (inherits(obj, "polylist")) {
    print_polylist_resume(obj)
    
  } else if (is.matrix(obj)) {
    cat("Type : matrice auxiliaire\n")
    cat("Dimensions :", nrow(obj), "x", ncol(obj), "\n")
    cat("\nAperçu :\n")
    print(obj[1:min(5, nrow(obj)), 1:min(5, ncol(obj)), drop = FALSE])
    
  } else if (is.atomic(obj)) {
    cat("Type : vecteur auxiliaire\n")
    cat("Longueur :", length(obj), "\n")
    cat("\nAperçu :\n")
    print(utils::head(obj, 10))
    
  } else {
    cat("Type : objet auxiliaire spécifique\n")
    print(utils::str(obj, max.level = 1))
  }
}

print_main_object_details <- function(obj, obj_name, role, keep) {
  # Affiche le détail complet seulement pour le vrai dataset principal.
  cat("\n--------------------\n")
  cat("Objet inspecté :", obj_name, "\n")
  cat("Classe :", paste(class(obj), collapse = ", "), "\n")
  cat("Rôle proposé :", role, "\n")
  cat("Décision proposée :", keep, "\n")
  cat("--------------------\n")
  
  if (inherits(obj, c("STSDF", "STFDF", "STIDF"))) {
    cat("Type : objet spatio-temporel du package spacetime\n")
    cat("Classe :", class(obj)[1L], "\n")
    cat("Nombre de mesures :", nrow(obj@data), "\n")
    cat("Nombre de stations :", nrow(obj@sp), "\n")
    cat("Nombre de dates :", length(obj@time), "\n")

    cat("\nVariables mesurees :\n")
    print(data.frame(
      variable = names(obj@data),
      type = vapply(
        obj@data,
        function(x) paste(class(x), collapse = "/"),
        character(1)
      ),
      row.names = NULL
    ))

    if ("data" %in% slotNames(obj@sp)) {
      cat("\nVariables des stations :\n")
      print(data.frame(
        variable = names(obj@sp@data),
        type = vapply(
          obj@sp@data,
          function(x) paste(class(x), collapse = "/"),
          character(1)
        ),
        row.names = NULL
      ))
    }

    cat("\nCoordonnees des premieres stations :\n")
    print(utils::head(sp::coordinates(obj@sp)))
    cat("\nEmprise spatiale :\n")
    print(obj@sp@bbox)
    cat("\nProjection / CRS :\n")
    print(obj@sp@proj4string)
    cat("\nPremieres dates :\n")
    print(utils::head(zoo::index(obj@time)))
    cat("\nApercu des mesures :\n")
    print(utils::head(obj@data))

  } else if (inherits(obj, "sts")) {
    cat("Type : objet spatio-temporel de surveillance\n")
    observed <- tryCatch(obj@observed, error = function(err) NULL)
    if (!is.null(observed)) {
      observed <- as.matrix(observed)
      cat(
        "Dimensions observees :",
        nrow(observed), "temps x",
        ncol(observed), "unites\n"
      )
      cat("\nApercu des observations :\n")
      print(utils::head(observed[, seq_len(min(5L, ncol(observed))), drop = FALSE]))
    }
    map <- tryCatch(obj@map, error = function(err) NULL)
    if (!is.null(map)) {
      cat("\nCarte associee :\n")
      cat("Classe :", paste(class(map), collapse = ", "), "\n")
      if (inherits(map, "sf")) {
        cat("Dimensions carte :", nrow(map), "lignes x", ncol(map), "colonnes\n")
      } else if (inherits(map, "Spatial")) {
        cat("Nombre d'unites carte :", length(map), "\n")
      }
    }

  } else if (inherits(obj, c(
    "RasterLayer", "RasterStack", "RasterBrick", "SpatRaster"
  ))) {
    cat("Type : grille raster spatiale\n")

    if (inherits(obj, c("RasterLayer", "RasterStack", "RasterBrick")) &&
        requireNamespace("raster", quietly = TRUE)) {
      cat(
        "Dimensions :",
        raster::nrow(obj), "lignes x",
        raster::ncol(obj), "colonnes x",
        raster::nlayers(obj), "couches\n"
      )
      cat("Nombre de cellules :", raster::ncell(obj), "\n")
      cat("Resolution :\n")
      print(raster::res(obj))
      cat("Emprise spatiale :\n")
      print(raster::extent(obj))
      cat("CRS :\n")
      print(raster::crs(obj))
    } else if (inherits(obj, "SpatRaster") &&
               requireNamespace("terra", quietly = TRUE)) {
      cat(
        "Dimensions :",
        terra::nrow(obj), "lignes x",
        terra::ncol(obj), "colonnes x",
        terra::nlyr(obj), "couches\n"
      )
      cat("Nombre de cellules :", terra::ncell(obj), "\n")
      cat("Resolution :\n")
      print(terra::res(obj))
      cat("Emprise spatiale :\n")
      print(terra::ext(obj))
      cat("CRS :", terra::crs(obj), "\n")
    }

    cat("\nVariables raster :\n")
    print(data.frame(
      variable = names(obj),
      type = "numeric_raster_layer",
      row.names = NULL
    ))

  } else if (inherits(obj, "sf")) {
    cat("Type : objet sf\n")
    cat("Dimensions :", nrow(obj), "lignes x", ncol(obj), "colonnes\n")
    
    if (requireNamespace("sf", quietly = TRUE)) {
      cat("Type de géométrie :",
          paste(unique(as.character(sf::st_geometry_type(obj))), collapse = ", "),
          "\n")
      cat("CRS :", as.character(sf::st_crs(obj)$input), "\n")
      cat("Emprise spatiale :\n")
      print(sf::st_bbox(obj))
    }
    
    cat("\nVariables :\n")
    print(data.frame(
      variable = names(obj),
      type = vapply(obj, function(x) paste(class(x), collapse = "/"), character(1)),
      row.names = NULL
    ))
    
    cat("\nAperçu :\n")
    print(utils::head(obj))
    
  } else if (inherits(obj, "Spatial")) {
    cat("Type : objet Spatial du package sp\n")
    
    if (!is.null(obj@data)) {
      cat("Dimensions attributaires :", nrow(obj@data), "lignes x", ncol(obj@data), "colonnes\n")
      
      cat("\nVariables attributaires :\n")
      print(data.frame(
        variable = names(obj@data),
        type = vapply(obj@data, function(x) paste(class(x), collapse = "/"), character(1)),
        row.names = NULL
      ))
      
      cat("\nAperçu des attributs :\n")
      print(utils::head(obj@data))
    }
    
    cat("\nEmprise spatiale :\n")
    print(obj@bbox)
    
    cat("\nProjection / CRS :\n")
    print(obj@proj4string)
    
  } else if (is.data.frame(obj)) {
    cat("Type : data.frame\n")
    cat("Dimensions :", nrow(obj), "lignes x", ncol(obj), "colonnes\n")
    
    cat("\nVariables :\n")
    print(data.frame(
      variable = names(obj),
      type = vapply(obj, function(x) paste(class(x), collapse = "/"), character(1)),
      row.names = NULL
    ))
    
    cat("\nAperçu :\n")
    print(utils::head(obj))
    
  } else {
    cat("Type : objet principal non tabulaire ou spécifique\n")
    print(utils::str(obj, max.level = 2))
  }
}

### Fonction principale d'inspection d'un jeu de données

find_inspection_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (basename(current) == "llm-wiki-karpathy") return(current)
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Racine llm-wiki-karpathy introuvable.", call. = FALSE)
}

find_sf_index_rows <- function(pkg, dataset, repo_root = find_inspection_repo_root()) {
  index_path <- file.path(
    repo_root, "data", "Final_datasets", "sf", "catalogue_sf_index.RData"
  )
  if (!file.exists(index_path)) return(data.frame())
  env <- new.env(parent = emptyenv())
  load(index_path, envir = env)
  if (!exists("index_sf", envir = env, inherits = FALSE)) return(data.frame())
  index_sf <- env$index_sf
  index_sf[
    tolower(as.character(index_sf$package)) == tolower(pkg) &
      tolower(as.character(index_sf$dataset)) == tolower(dataset),
    , drop = FALSE
  ]
}

inspect_sf_index_row <- function(row, repo_root = find_inspection_repo_root()) {
  if (nrow(row) != 1L) stop("Une seule ligne d'index sf est requise.", call. = FALSE)
  usable <- identical(toupper(as.character(row$utilisable)), "TRUE")
  if (!usable || is.na(row$sf_path) || !nzchar(row$sf_path)) {
    cat("Le jeu figure dans l'index sf mais sa conversion n'est pas utilisable.\n")
    cat("Raison :", as.character(row$raison), "\n")
    return(invisible(list(index = row, object = NULL)))
  }
  path <- file.path(repo_root, gsub("\\\\", "/", as.character(row$sf_path)))
  if (!file.exists(path)) stop("Fichier RDS absent : ", path, call. = FALSE)
  obj <- readRDS(path)

  cat("\n====================\n")
  cat("Inspection du catalogue sf normalise\n")
  cat("====================\n")
  cat("Langage source :", as.character(row$source_language), "\n")
  cat("Package :", as.character(row$package), "\n")
  cat("Dataset :", as.character(row$dataset), "\n")
  cat("Record ID :", as.character(row$record_id), "\n")
  cat("Fichier RDS :", as.character(row$sf_path), "\n")
  cat("Famille cataloguée :", as.character(row$famille_geometrie), "\n")
  cat("Statut :", as.character(row$raison), "\n")

  if (inherits(obj, "sf")) {
    geom_cols <- names(obj)[vapply(obj, inherits, logical(1), what = "sfc")]
    cat("Géométrie active :", attr(obj, "sf_column"), "\n")
    cat("Colonnes géométriques :", paste(geom_cols, collapse = ", "), "\n")
    for (nm in geom_cols) {
      types <- unique(as.character(sf::st_geometry_type(obj[[nm]])))
      crs <- sf::st_crs(obj[[nm]])
      crs_label <- if (is.na(crs)) "NA" else crs$input
      cat(" -", nm, ":", paste(types, collapse = "/"), "| CRS :", crs_label, "\n")
    }
  }

  print_main_object_details(obj, as.character(row$dataset), "spatial_observations", "yes")
  invisible(list(index = row, object = obj))
}

inspect_dataset <- function(pkg, dataset, bundle = NULL,
                            source = c("auto", "package", "sf")) {
  # Inspecte un objet affiché par data(package = ...).
  # Si l'objet demandé est principal, affiche les détails complets.
  # Si l'objet demandé est auxiliaire, affiche seulement son résumé
  # et indique le dataset principal du même bundle.
  
  pkg <- as_single_character(pkg, "pkg")
  parsed <- parse_dataset_label(dataset)
  source <- match.arg(source)

  # Les packages Python ne sont pas des packages CRAN. S'ils ont deja ete
  # normalises, on inspecte le RDS sf sans appeler install.packages().
  sf_rows <- find_sf_index_rows(pkg, parsed$bundle)
  if (nrow(sf_rows) == 0L && !identical(parsed$object, parsed$bundle)) {
    sf_rows <- find_sf_index_rows(pkg, parsed$object)
  }
  python_sf <- nrow(sf_rows) > 0L &&
    any(tolower(as.character(sf_rows$source_language)) == "python")
  if (identical(source, "sf") || (identical(source, "auto") && python_sf)) {
    if (nrow(sf_rows) == 0L) {
      stop("Dataset absent de catalogue_sf_index.RData : ", pkg, "::", dataset,
           call. = FALSE)
    }
    if (nrow(sf_rows) > 1L) {
      cat("Plusieurs objets sf correspondent a", pkg, "::", dataset, ":\n")
      print(sf_rows[, intersect(c("record_id", "dataset", "n", "sf_path", "utilisable"),
                                names(sf_rows)), drop = FALSE], row.names = FALSE)
      return(invisible(list(index = sf_rows, object = NULL)))
    }
    return(inspect_sf_index_row(sf_rows))
  }
  
  if (is.null(bundle)) {
    bundle <- parsed$bundle
  } else {
    bundle <- as_single_character(bundle, "bundle")
  }
  
  load_name <- as_single_character(bundle, "load_name")
  requested_object <- as_single_character(parsed$object, "requested_object")
  
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  
  e <- new.env(parent = emptyenv())
  
  ok <- tryCatch({
    utils::data(list = load_name, package = pkg, envir = e)
    TRUE
  }, error = function(err) {
    cat("Erreur au chargement de", pkg, "::", load_name, "\n")
    cat(conditionMessage(err), "\n")
    FALSE
  })
  
  if (!ok) {
    return(invisible(NULL))
  }
  
  objects <- ls(e)

  rd <- find_rd_documentation(pkg, load_name)
  doc_text <- if (is.null(rd)) {
    ""
  } else {
    paste(capture.output(tools::Rd2txt(rd)), collapse = "\n")
  }
  
  curation_rows <- lapply(objects, function(obj_name) {
    obj <- e[[obj_name]]
    role <- guess_object_role(obj, obj_name, bundle, doc_text)
    keep <- guess_keep_from_role(role)
    
    data.frame(
      package = pkg,
      bundle = bundle,
      object = obj_name,
      role = role,
      keep = keep,
      stringsAsFactors = FALSE
    )
  })
  
  curation_table <- do.call(rbind, curation_rows)
  
  main_objects <- curation_table$object[curation_table$keep == "yes"]
  auxiliary_objects <- curation_table$object[curation_table$keep != "yes"]
  
  if (!(requested_object %in% objects)) {
    cat("Objet demandé introuvable dans le bundle chargé :", requested_object, "\n")
    cat("Objets disponibles :", paste(objects, collapse = ", "), "\n")
    return(invisible(list(objects = e, curation = curation_table)))
  }
  
  requested_row <- curation_table[curation_table$object == requested_object, ]
  requested_obj <- e[[requested_object]]
  
  cat("\n====================\n")
  cat("Package :", pkg, "\n")
  cat("Bundle chargé :", load_name, "\n")
  cat("Objet demandé :", requested_object, "\n")
  cat("Rôle de l'objet demandé :", requested_row$role, "\n")
  cat("Décision proposée :", requested_row$keep, "\n")
  cat("Jeu(x) de données principal(aux) :", paste(main_objects, collapse = ", "), "\n")
  cat("Fichier(s) auxiliaire(s) :", paste(auxiliary_objects, collapse = ", "), "\n")
  cat("====================\n")
  
  if (requested_row$keep == "yes") {
    print_main_object_details(
      requested_obj,
      requested_object,
      requested_row$role,
      requested_row$keep
    )
  } else {
    print_auxiliary_resume(
      requested_obj,
      requested_object,
      requested_row$role,
      requested_row$keep
    )
    
    cat("\n====================\n")
    cat("Relation avec le bundle\n")
    cat("====================\n")
    cat("Cet objet est un fichier auxiliaire du bundle :", bundle, "\n")
    cat("Jeu(x) de données principal(aux) :", paste(main_objects, collapse = ", "), "\n")
    
    other_aux <- setdiff(auxiliary_objects, requested_object)
    cat("Autre(s) fichier(s) auxiliaire(s) :",
        ifelse(length(other_aux) == 0, "aucun", paste(other_aux, collapse = ", ")),
        "\n")
  }
  
  cat("\n====================\n")
  cat("Documentation du bundle\n")
  cat("====================\n")
  
  if (is.null(rd)) {
    cat("Aucune documentation Rd trouvée pour", pkg, "::", load_name, "\n")
  } else {
    txt <- tryCatch({
      capture.output(tools::Rd2txt(rd))
    }, error = function(err) {
      paste("Impossible de convertir la documentation Rd :", conditionMessage(err))
    })
    
    cat(paste(txt, collapse = "\n"))
    cat("\n")
  }
  
  cat("\n====================\n")
  cat("Tableau de curation proposé\n")
  cat("====================\n")
  print(curation_table, row.names = FALSE)
  
  invisible(list(
    objects = e,
    curation = curation_table
  ))
}

###### Notes d'utilisation
#
# Ce fichier ne lance plus d'action automatiquement.
# Il sert de bibliotheque de fonctions d'inspection reutilisables.
#
# Exemples interactifs :
# data(package = "spData")
# inspect_dataset("spData", "alaska")
# inspect_dataset("plm", "Produc")
# inspect_dataset("geodatasets", "australia") # source Python -> RDS sf
# inspect_dataset("spData", "house", source = "sf") # forcer le RDS normalise
#
# Pour creer le catalogue R complet, utiliser :
# Rscript Code_scrapping/r_catalog/create_r_software_catalog.R
