# Cree le catalogue brut des jeux de donnees R issus des packages logiciels.
#
# Utilisation depuis la racine du depot llm-wiki-karpathy :
# Rscript Code_scrapping/create_r_software_catalog.R
#
# Ce script appelle uniquement les fonctions definies dans :
# Code_scrapping/Inspection_of_each_dataset.R

find_repo_root <- function(start = getwd()) {
  # Retrouve la racine du depot pour que le script fonctionne depuis
  # llm-wiki-karpathy ou depuis son dossier parent.
  start <- normalizePath(start, winslash = "/", mustWork = TRUE)

  if (basename(start) == "llm-wiki-karpathy") {
    return(start)
  }

  nested <- file.path(start, "llm-wiki-karpathy")
  if (dir.exists(nested)) {
    return(normalizePath(nested, winslash = "/", mustWork = TRUE))
  }

  stop("Lance ce script depuis llm-wiki-karpathy ou son dossier parent.", call. = FALSE)
}

repo_root <- find_repo_root()
setwd(repo_root)

source(file.path("Code_scrapping", "Inspection_of_each_dataset.R"), encoding = "UTF-8")

software_r_packages <- c(
  "spdep", "spatialreg", "spData", "spDataLarge", "sphet", "spse",
  "GWmodel", "mgwrsar", "spgwr", "gstat", "sp", "sf", "sfdep",
  "plm", "splm", "spacetime", "surveillance", "STRbook",
  "SpatialEpi", "spatstat", "spatstat.data", "CARBayes",
  "CARBayesST", "spaMM", "vegan", "ade4", "dismo", "MASS",
  "HistData", "AER", "agridat", "rgeoboundaries", "giscoR"
)

get_dataset_documentation_text <- function(pkg, bundle) {
  # Recupere la documentation Rd du bundle et la convertit en texte brut.
  rd <- tryCatch({
    tools::Rd_db(pkg)[[paste0(bundle, ".Rd")]]
  }, error = function(err) {
    NULL
  })

  if (is.null(rd)) {
    return(NA_character_)
  }

  txt <- tryCatch({
    capture.output(tools::Rd2txt(rd))
  }, error = function(err) {
    NA_character_
  })

  if (length(txt) == 1 && is.na(txt)) {
    return(NA_character_)
  }

  paste(txt, collapse = "\n")
}

extract_doc_section <- function(doc_text, section_name) {
  # Extrait grossierement une section de documentation Rd convertie en texte.
  # Cette extraction reste volontairement simple pour rester robuste entre packages.
  if (is.na(doc_text) || !nzchar(doc_text)) {
    return(NA_character_)
  }

  lines <- unlist(strsplit(doc_text, "\n", fixed = TRUE))
  clean <- trimws(gsub("_\b", "", lines, fixed = TRUE))

  section_pattern <- paste0("^", section_name, ":$")
  start <- grep(section_pattern, clean, ignore.case = TRUE)

  if (length(start) == 0) {
    return(NA_character_)
  }

  start <- start[1] + 1
  section_names <- c(
    "Description", "Usage", "Format", "Details", "Note", "Source",
    "References", "Author", "Authors", "See Also", "Examples"
  )
  possible_end <- grep(paste0("^(", paste(section_names, collapse = "|"), "):$"), clean)
  possible_end <- possible_end[possible_end > start]
  end <- if (length(possible_end) == 0) length(clean) else possible_end[1] - 1

  value <- paste(trimws(clean[start:end]), collapse = " ")
  value <- gsub("\\s+", " ", value)
  value <- trimws(value)

  if (!nzchar(value)) {
    return(NA_character_)
  }

  value
}

get_object_dimensions <- function(obj) {
  # Renvoie les dimensions N,K adaptees au type de l'objet principal.
  if (inherits(obj, "sf")) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }

  if (inherits(obj, "Spatial") && !is.null(obj@data)) {
    return(c(n = nrow(obj@data), k = ncol(obj@data)))
  }

  if (is.data.frame(obj)) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }

  if (is.matrix(obj)) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }

  c(n = length(obj), k = NA_integer_)
}

get_object_variables <- function(obj) {
  # Liste les variables exploitables du jeu de donnees principal.
  if (inherits(obj, "sf")) {
    return(paste(names(obj), collapse = ", "))
  }

  if (inherits(obj, "Spatial") && !is.null(obj@data)) {
    return(paste(names(obj@data), collapse = ", "))
  }

  if (is.data.frame(obj)) {
    return(paste(names(obj), collapse = ", "))
  }

  if (is.matrix(obj)) {
    vars <- colnames(obj)
    if (is.null(vars)) {
      vars <- paste0("V", seq_len(ncol(obj)))
    }
    return(paste(vars, collapse = ", "))
  }

  vars <- names(obj)
  if (is.null(vars)) {
    return(NA_character_)
  }

  paste(vars, collapse = ", ")
}

object_as_attribute_data <- function(obj) {
  # Recupere la table attributaire quand elle existe.
  if (inherits(obj, "sf")) {
    return(as.data.frame(obj))
  }

  if (inherits(obj, "Spatial") && !is.null(obj@data)) {
    return(obj@data)
  }

  if (is.data.frame(obj)) {
    return(obj)
  }

  if (is.matrix(obj)) {
    return(as.data.frame(obj))
  }

  NULL
}

collapse_names <- function(x) {
  # Colle une liste de noms en chaine lisible pour le CSV.
  x <- unique(x[!is.na(x) & nzchar(x)])
  if (length(x) == 0) {
    return("")
  }
  paste(x, collapse = ", ")
}

yes_no <- function(value) {
  # Standardise les champs booleens du catalogue.
  if (isTRUE(value)) {
    return("Yes")
  }
  "No"
}

detect_metadata_signals <- function(obj) {
  # Detecte des signaux utiles pour la curation modele :
  # geometrie, coordonnees, date/time, noms de lieux, X potentiels et Y potentiels.
  dat <- object_as_attribute_data(obj)

  if (is.null(dat)) {
    return(list(
      has_geometry = yes_no(inherits(obj, "sf") || inherits(obj, "Spatial")),
      has_coordinates = "No",
      coordinate_columns = "",
      has_multiple_x = "No",
      candidate_x_variables = "",
      has_y = "No",
      candidate_y_variables = "",
      has_place_name_if_no_geometry = "No",
      place_name_columns = "",
      has_datetime = "No",
      datetime_columns = ""
    ))
  }

  vars <- names(dat)
  vars_lower <- tolower(vars)

  geometry_object <- inherits(obj, "sf") || inherits(obj, "Spatial")

  coordinate_columns <- vars[
    grepl("(^x$|^y$|lon|long|longitude|lat|latitude|coord|coords|easting|northing)", vars_lower)
  ]

  datetime_columns <- vars[
    grepl("year|date|time|month|day|period|syear|timestep", vars_lower) |
      vapply(dat, function(col) inherits(col, "Date") || inherits(col, "POSIXct") || inherits(col, "POSIXt"), logical(1))
  ]

  place_name_columns <- vars[
    grepl("country|state|county|city|town|municip|commune|depart|region|zip|postal|fips|tract|neig|name|place|nuts|geoid|id_?geo", vars_lower)
  ]

  excluded_for_model <- unique(c(
    coordinate_columns,
    datetime_columns,
    place_name_columns,
    vars[grepl("geometry|geom|shape|wkt", vars_lower)]
  ))

  numeric_or_factor <- vapply(dat, function(col) {
    is.numeric(col) || is.integer(col) || is.factor(col) || is.logical(col)
  }, logical(1))

  y_pattern <- paste(
    c(
      "^y$", "target", "response", "outcome", "dependent",
      "price", "value", "crime", "homicide", "burgl", "murder",
      "death", "mort", "rate", "cases", "count", "incidence",
      "income", "wage", "employment", "unemployment", "yield",
      "rent", "sales", "disease", "sids", "leuk", "pop"
    ),
    collapse = "|"
  )

  candidate_y <- vars[
    numeric_or_factor &
      grepl(y_pattern, vars_lower) &
      !(vars %in% excluded_for_model)
  ]

  candidate_x <- vars[
    numeric_or_factor &
      !(vars %in% excluded_for_model) &
      !(vars %in% candidate_y)
  ]

  # Si aucun Y evident n'est trouve, on signale le premier numerique comme
  # candidat faible pour aider la curation manuelle sans bloquer le catalogue.
  if (length(candidate_y) == 0) {
    weak_y <- vars[
      numeric_or_factor &
        !(vars %in% excluded_for_model)
    ]
    candidate_y <- head(weak_y, 1)
    candidate_x <- setdiff(candidate_x, candidate_y)
  }

  has_coordinates <- length(coordinate_columns) > 0
  has_geometry <- geometry_object || has_coordinates

  list(
    has_geometry = yes_no(has_geometry),
    has_coordinates = yes_no(has_coordinates),
    coordinate_columns = collapse_names(coordinate_columns),
    has_multiple_x = yes_no(length(candidate_x) >= 2),
    candidate_x_variables = collapse_names(candidate_x),
    has_y = yes_no(length(candidate_y) > 0),
    candidate_y_variables = collapse_names(candidate_y),
    has_place_name_if_no_geometry = yes_no(!has_geometry && length(place_name_columns) > 0),
    place_name_columns = collapse_names(place_name_columns),
    has_datetime = yes_no(length(datetime_columns) > 0),
    datetime_columns = collapse_names(datetime_columns)
  )
}

guess_dataset_theme <- function(pkg, bundle, object, description = NA_character_, variables = NA_character_) {
  # Classe thematiquement le dataset avec des regles heuristiques.
  # Ce n'est pas une verite definitive : c'est une aide de pre-curation.
  text <- tolower(paste(pkg, bundle, object, description, variables, collapse = " "))

  if (grepl("house|housing|home|property|price|boston|baltimore|hedonic", text)) {
    return("housing / immobilier")
  }

  if (grepl("crime|burgl|murder|conflict|war|weapon|gun", text)) {
    return("crime / conflit / securite")
  }

  if (grepl("election|voter|vote|president|politic|guerry", text)) {
    return("politique / elections / histoire sociale")
  }

  if (grepl("health|disease|sids|leukemia|measles|rotavirus|flu|hepatitis|cancer|mortality|epidem", text)) {
    return("sante / epidemiologie")
  }

  if (grepl("forest|tree|ecolog|species|biodiv|vegetation|mite|dune|varespec|spatstat|plant|animal", text)) {
    return("biodiversite / ecologie")
  }

  if (grepl("air|climate|weather|temperature|fire|river|water|soil|pollution|environment|ozone", text)) {
    return("environnement / climat")
  }

  if (grepl("crop|wheat|rice|corn|maize|barley|sorghum|cotton|agri|farm|yield|agridat", text)) {
    return("agronomie / agriculture")
  }

  if (grepl("income|wage|employment|unemployment|product|gdp|growth|economic|cigar|gasoline|trade", text)) {
    return("economie / panel / econometrie")
  }

  if (grepl("transport|traffic|cycle|road|street|commute|travel", text)) {
    return("transport / mobilite")
  }

  if (grepl("world|country|state|county|boundary|nuts|gisco|region|municip", text)) {
    return("geometries administratives / demographie")
  }

  "a qualifier manuellement"
}

list_package_dataset_entries <- function(pkg) {
  # Recupere les entrees declarees par data(package = pkg).
  d <- tryCatch({
    data(package = pkg)$results
  }, error = function(err) {
    NULL
  })

  if (is.null(d) || nrow(d) == 0) {
    return(data.frame())
  }

  data.frame(
    item = d[, "Item"],
    title = d[, "Title"],
    stringsAsFactors = FALSE
  )
}

catalog_main_datasets_from_packages <- function(packages = software_r_packages,
                                                install_missing = FALSE,
                                                verbose = TRUE) {
  # Parcourt les packages R listes et construit un data.frame des objets
  # identifies comme jeux de donnees principaux par guess_object_role().
  rows <- list()

  for (pkg in packages) {
    if (verbose) {
      cat("\nPackage :", pkg, "\n")
    }

    if (!requireNamespace(pkg, quietly = TRUE)) {
      if (install_missing) {
        install.packages(pkg)
      }
    }

    if (!requireNamespace(pkg, quietly = TRUE)) {
      if (verbose) {
        cat("  Package non disponible, ignore.\n")
      }
      next
    }

    entries <- list_package_dataset_entries(pkg)
    if (nrow(entries) == 0) {
      if (verbose) {
        cat("  Aucun dataset declare par data(package = ...).\n")
      }
      next
    }

    parsed <- lapply(entries$item, parse_dataset_label)
    entries$object <- vapply(parsed, `[[`, character(1), "object")
    entries$bundle <- vapply(parsed, `[[`, character(1), "bundle")

    for (bundle in unique(entries$bundle)) {
      e <- new.env(parent = emptyenv())

      ok <- tryCatch({
        data(list = bundle, package = pkg, envir = e)
        TRUE
      }, error = function(err) {
        FALSE
      })

      if (!ok) {
        if (verbose) {
          cat("  Bundle non charge :", bundle, "\n")
        }
        next
      }

      objects <- ls(e)
      if (length(objects) == 0) {
        next
      }

      curation <- do.call(rbind, lapply(objects, function(obj_name) {
        obj <- e[[obj_name]]
        role <- guess_object_role(obj, obj_name, bundle)
        keep <- guess_keep_from_role(role)

        data.frame(
          object = obj_name,
          role = role,
          keep = keep,
          stringsAsFactors = FALSE
        )
      }))

      main_objects <- curation$object[curation$keep == "yes"]
      auxiliary_objects <- setdiff(objects, main_objects)

      if (length(main_objects) == 0) {
        next
      }

      doc_text <- get_dataset_documentation_text(pkg, bundle)
      description_bundle <- entries$title[entries$bundle == bundle][1]
      source <- extract_doc_section(doc_text, "Source")

      for (main_object in main_objects) {
        obj <- e[[main_object]]
        dims <- get_object_dimensions(obj)
        variables <- get_object_variables(obj)
        metadata_signals <- detect_metadata_signals(obj)
        role <- curation$role[curation$object == main_object][1]
        theme <- guess_dataset_theme(
          pkg = pkg,
          bundle = bundle,
          object = main_object,
          description = description_bundle,
          variables = variables
        )

        rows[[length(rows) + 1]] <- data.frame(
          package = pkg,
          bundle = bundle,
          main_object = main_object,
          role = role,
          description_bundle = description_bundle,
          source = source,
          variables = variables,
          auxiliary_files = paste(auxiliary_objects, collapse = ", "),
          n = unname(dims["n"]),
          k = unname(dims["k"]),
          has_geometry = metadata_signals$has_geometry,
          has_coordinates = metadata_signals$has_coordinates,
          coordinate_columns = metadata_signals$coordinate_columns,
          has_multiple_x = metadata_signals$has_multiple_x,
          candidate_x_variables = metadata_signals$candidate_x_variables,
          has_y = metadata_signals$has_y,
          candidate_y_variables = metadata_signals$candidate_y_variables,
          has_place_name_if_no_geometry = metadata_signals$has_place_name_if_no_geometry,
          place_name_columns = metadata_signals$place_name_columns,
          has_datetime = metadata_signals$has_datetime,
          datetime_columns = metadata_signals$datetime_columns,
          theme = theme,
          stringsAsFactors = FALSE
        )
      }
    }
  }

  if (length(rows) == 0) {
    return(data.frame())
  }

  catalog <- do.call(rbind, rows)
  row.names(catalog) <- NULL
  catalog
}

catalog_r <- catalog_main_datasets_from_packages(
  packages = software_r_packages,
  install_missing = FALSE,
  verbose = TRUE
)

output_path <- file.path(
  "data",
  "manifests",
  "datasets",
  "software_r_catalog_main_datasets.csv"
)

write.csv2(
  catalog_r,
  file = output_path,
  row.names = FALSE,
  fileEncoding = "UTF-8"
)

cat("\nCatalogue R ecrit :", output_path, "\n")
cat("Nombre de lignes :", nrow(catalog_r), "\n")
cat("Nombre de colonnes :", ncol(catalog_r), "\n")
