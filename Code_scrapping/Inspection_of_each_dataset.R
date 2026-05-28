###### Identifier le rôle probable d'un objet chargé avec data()
guess_object_role <- function(obj, obj_name, bundle) {
  # Propose un rôle simple pour distinguer jeu principal et auxiliaires.
  name_lower <- tolower(obj_name)

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
  
  if (inherits(obj, "sf")) {
    return("main_spatial_sf")
  }
  
  if (inherits(obj, "SpatialPointsDataFrame") ||
      inherits(obj, "SpatialPolygonsDataFrame") ||
      inherits(obj, "SpatialLinesDataFrame")) {
    return("main_spatial_sp")
  }
  
  if (inherits(obj, "SpatialPoints") ||
      inherits(obj, "SpatialPolygons") ||
      inherits(obj, "SpatialLines")) {
    return("geometry")
  }
  
  if (inherits(obj, "polylist")) {
    return("geometry")
  }

  if (is.matrix(obj)) {
    if (ncol(obj) == 2 && grepl("xy|coord|coords", name_lower)) {
      return("coordinates")
    }
    if (nrow(obj) == ncol(obj)) {
      return("weights_or_adjacency_matrix")
    }
    return("matrix_auxiliary")
  }
  
  if (is.data.frame(obj)) {
    if (obj_name == bundle) {
      return("main_table")
    }
    if (grepl("df|data|table", name_lower)) {
      return("attribute_table")
    }
    return("table")
  }
  
  if (is.atomic(obj)) {
    return("vector_auxiliary")
  }
  
  "other"
}

###### Traduire le rôle en décision de conservation provisoir 
guess_keep_from_role <- function(role) {
  # Propose une décision de curation.
  if (role %in% c("main_spatial_sf", "main_spatial_sp", "main_table")) {
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
    "matrix_auxiliary",
    "weights_or_adjacency_matrix",
    "vector_auxiliary"
  )) {
    return("yes_auxiliary")
  }
  
  "review"
}

###### Interprète les libellés affichés par data(package = ...)
parse_dataset_label <- function(dataset) {
  # Interprète les libellés affichés par data(package = ...).
  # Exemple : "LO_nb (house)" signifie :
  # - objet demandé : LO_nb
  # - bundle à charger : house
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
  
  if (inherits(obj, "sf")) {
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

inspect_dataset <- function(pkg, dataset, bundle = NULL) {
  # Inspecte un objet affiché par data(package = ...).
  # Si l'objet demandé est principal, affiche les détails complets.
  # Si l'objet demandé est auxiliaire, affiche seulement son résumé
  # et indique le dataset principal du même bundle.
  
  parsed <- parse_dataset_label(dataset)
  
  if (is.null(bundle)) {
    bundle <- parsed$bundle
  }
  
  load_name <- parsed$load_name
  requested_object <- parsed$object
  
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
  
  e <- new.env(parent = emptyenv())
  
  ok <- tryCatch({
    data(list = load_name, package = pkg, envir = e)
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
  
  curation_rows <- lapply(objects, function(obj_name) {
    obj <- e[[obj_name]]
    role <- guess_object_role(obj, obj_name, bundle)
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
  
  rd <- tryCatch({
    tools::Rd_db(pkg)[[paste0(load_name, ".Rd")]]
  }, error = function(err) {
    NULL
  })
  
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
#
# Pour creer le catalogue R complet, utiliser :
# Rscript Code_scrapping/create_r_software_catalog.R
