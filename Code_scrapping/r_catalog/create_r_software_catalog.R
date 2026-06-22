# Cree le catalogue brut des jeux de donnees R issus des packages logiciels.
#
# Utilisation depuis la racine du depot llm-wiki-karpathy :
# Rscript Code_scrapping/r_catalog/create_r_software_catalog.R
#
# Ce script appelle uniquement les fonctions definies dans :
# Code_scrapping/r_catalog/Inspection_of_each_dataset.R

find_repo_root <- function(start = getwd()) {
  # Remonte l'arborescence pour fonctionner depuis n'importe quel sous-dossier.
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)

  repeat {
    if (basename(current) == "llm-wiki-karpathy") {
      return(current)
    }

    nested <- file.path(current, "llm-wiki-karpathy")
    if (dir.exists(nested)) {
      return(normalizePath(nested, winslash = "/", mustWork = TRUE))
    }

    parent <- dirname(current)
    if (identical(parent, current)) {
      break
    }
    current <- parent
  }

  stop("Racine llm-wiki-karpathy introuvable depuis : ", start, call. = FALSE)
}

repo_root <- find_repo_root()

source_utf8_safely <- function(path, envir = parent.frame()) {
  # Evite le chargement partiel observe avec source(encoding = "UTF-8")
  # lorsque R demarre sous une locale Windows incompatible.
  con <- file(path, open = "rb")
  on.exit(close(con), add = TRUE)
  raw <- readBin(con, what = "raw", n = file.info(path)$size)
  text <- iconv(rawToChar(raw), from = "UTF-8", to = "ASCII//TRANSLIT", sub = "")
  text <- gsub("\r", "", text, fixed = TRUE)
  text <- gsub("\ufeff|\ufffd", "", text, perl = TRUE)
  eval(parse(text = text), envir = envir)
  invisible(TRUE)
}

source_utf8_safely(file.path(
  repo_root,
  "Code_scrapping",
  "r_catalog",
  "Inspection_of_each_dataset.R"
))

software_r_packages <- c(
  "spdep", "spatialreg", "spData", "spDataLarge", "sphet", "spse",
  "GWmodel", "mgwrsar", "spgwr", "gstat", "sp", "sf", "sfdep",
  "plm", "splm", "spacetime", "surveillance", "STRbook",
  "SpatialEpi", "spatstat", "spatstat.data", "CARBayes",
  "CARBayesST", "spaMM", "vegan", "ade4", "dismo", "MASS",
  "HistData", "AER", "agridat", "rgeoboundaries", "giscoR"
)

rd_documentation_cache <- new.env(parent = emptyenv())

get_package_rd_index <- function(pkg) {
  if (!exists(pkg, envir = rd_documentation_cache, inherits = FALSE)) {
    package_docs <- tryCatch({
      rd_db <- tools::Rd_db(pkg)
      aliases <- list()
      for (rd_name in names(rd_db)) {
        rd_aliases <- tryCatch(
          tools:::.Rd_get_metadata(rd_db[[rd_name]], "alias"),
          error = function(err) character(0)
        )
        for (alias in rd_aliases) {
          aliases[[alias]] <- rd_name
        }
      }
      list(rd_db = rd_db, aliases = aliases)
    }, error = function(err) {
      list(rd_db = list(), aliases = list())
    })
    assign(pkg, package_docs, envir = rd_documentation_cache)
  }
  get(pkg, envir = rd_documentation_cache, inherits = FALSE)
}

get_dataset_rd_name <- function(pkg, bundle) {
  package_docs <- get_package_rd_index(pkg)
  rd_name <- package_docs$aliases[[bundle]]
  if (is.null(rd_name) && paste0(bundle, ".Rd") %in% names(package_docs$rd_db)) {
    rd_name <- paste0(bundle, ".Rd")
  }
  if (is.null(rd_name)) NA_character_ else rd_name
}

get_dataset_documentation_text <- function(pkg, bundle) {
  # Recupere la documentation Rd du bundle et la convertit en texte brut.
  package_docs <- get_package_rd_index(pkg)
  rd_name <- get_dataset_rd_name(pkg, bundle)
  if (is.na(rd_name)) {
    return(NA_character_)
  }
  rd <- if (is.null(rd_name)) NULL else package_docs$rd_db[[rd_name]]

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

get_package_documentation_sites <- function(pkg) {
  # Construit les liens de documentation probables sans appeler le web.
  # La sortie sert a guider l'inspection manuelle : CRAN, rdrr, reference
  # R officielle et URLs declarees dans le DESCRIPTION du package.
  desc <- tryCatch({
    utils::packageDescription(pkg)
  }, error = function(err) {
    NULL
  })

  declared_url <- NA_character_
  bug_reports <- NA_character_
  if (!is.null(desc)) {
    declared_url <- desc[["URL"]]
    bug_reports <- desc[["BugReports"]]
  }

  data.frame(
    package = pkg,
    cran_package = paste0("https://cran.r-project.org/package=", pkg),
    cran_reference = paste0("https://search.r-project.org/CRAN/refmans/", pkg, "/html/00Index.html"),
    rdrr_package = paste0("https://rdrr.io/cran/", pkg, "/"),
    declared_url = ifelse(is.null(declared_url), NA_character_, declared_url),
    bug_reports = ifelse(is.null(bug_reports), NA_character_, bug_reports),
    stringsAsFactors = FALSE
  )
}

get_dataset_documentation_links <- function(pkg, bundle) {
  # Genere les liens candidats pour la documentation d'un dataset donne.
  # Les liens sont des candidats stables a verifier manuellement ; le script ne
  # depend pas du reseau pour rester reproductible.
  data.frame(
    package = pkg,
    bundle = bundle,
    cran_topic = paste0("https://search.r-project.org/CRAN/refmans/", pkg, "/html/", bundle, ".html"),
    rdrr_topic = paste0("https://rdrr.io/cran/", pkg, "/man/", bundle, ".html"),
    stringsAsFactors = FALSE
  )
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

extract_documentation_profile <- function(pkg, bundle, doc_text) {
  # Resume les sections Rd importantes pour aider la curation.
  # Ces champs donnent des preuves textuelles avant d'envoyer un cas au LLM.
  sections <- c("Description", "Format", "Details", "Source", "References", "Examples")
  values <- lapply(sections, function(section) {
    extract_doc_section(doc_text, section)
  })
  names(values) <- tolower(sections)

  formula_info <- extract_formula_signals(doc_text)

  data.frame(
    package = pkg,
    bundle = bundle,
    doc_has_rd = yes_no(!is.na(doc_text) && nzchar(doc_text)),
    doc_description = values$description,
    doc_format = values$format,
    doc_details = values$details,
    doc_source = values$source,
    doc_references = values$references,
    doc_examples = values$examples,
    formula_response = formula_info$response,
    formula_predictors = formula_info$predictors,
    formula_text = formula_info$formula_text,
    stringsAsFactors = FALSE
  )
}

extract_formula_signals <- function(doc_text) {
  # Cherche des formules de regression dans la documentation Rd convertie.
  # On extrait surtout le schema y ~ x1 + x2, utile pour identifier Y et X.
  empty <- list(response = "", predictors = "", formula_text = "")
  if (is.na(doc_text) || !nzchar(doc_text)) {
    return(empty)
  }

  text <- gsub("\\s+", " ", doc_text)
  formula_matches <- gregexpr(
    "[A-Za-z.][A-Za-z0-9_.]*\\s*~\\s*[^,)]+",
    text,
    perl = TRUE
  )[[1]]

  if (length(formula_matches) == 1 && formula_matches[1] < 0) {
    return(empty)
  }

  formulas <- regmatches(text, list(formula_matches))[[1]]
  formulas <- unique(trimws(formulas))
  formulas <- formulas[
    !grepl("#|windows|width|height|aspect.?ratio", formulas, ignore.case = TRUE)
  ]
  if (length(formulas) == 0L) {
    return(empty)
  }
  formula <- formulas[1]
  parts <- strsplit(formula, "~", fixed = TRUE)[[1]]
  if (length(parts) < 2) {
    return(empty)
  }

  response <- trimws(parts[1])
  if (tolower(response) %in% c(
    "of", "a", "an", "the", "data", "format", "ratio", "plot"
  )) {
    return(empty)
  }
  rhs <- trimws(parts[2])
  predictors <- unlist(strsplit(rhs, "\\+|\\*|:|\\||-", perl = TRUE))
  predictors <- trimws(gsub("[^A-Za-z0-9_.]", "", predictors))
  predictors <- predictors[nzchar(predictors)]
  predictors <- predictors[!predictors %in% c("1", "0")]

  list(
    response = response,
    predictors = collapse_names(predictors),
    formula_text = formula
  )
}

read_paper_audit <- function(repo_root = find_repo_root()) {
  # Reutilise l'audit bibliographique deja verifie. Le catalogue reste
  # reproductible hors ligne et peut etre enrichi apres une collecte reseau.
  candidates <- file.path(
    repo_root,
    "data",
    "manifests",
    "datasets",
    c(
      "software_r_dataset_paper_formula_audit_verified.csv",
      "software_r_dataset_paper_formula_audit.csv"
    )
  )
  existing <- candidates[file.exists(candidates)]
  if (length(existing) == 0) {
    return(data.frame())
  }
  audits <- lapply(existing, function(path) {
    # Lecture binaire puis normalisation : certains abstracts contiennent des
    # octets invalides pour la locale Windows et bloquaient tout le catalogue.
    con <- file(path, open = "rb")
    on.exit(close(con), add = TRUE)
    raw <- readBin(con, what = "raw", n = file.info(path)$size)
    text <- iconv(rawToChar(raw), from = "UTF-8", to = "UTF-8", sub = "")
    text <- sub("^\ufeff", "", text)
    utils::read.csv2(
      text = text,
      stringsAsFactors = FALSE,
      check.names = FALSE
    )
  })
  richness <- vapply(audits, function(audit) {
    score <- ncol(audit)
    if ("paper_use_summary" %in% names(audit)) {
      score <- score + sum(nzchar(audit$paper_use_summary), na.rm = TRUE)
    }
    score
  }, numeric(1))
  audits[[which.max(richness)]]
}

collapse_evidence <- function(x, max_items = 6L) {
  x <- unique(trimws(as.character(x)))
  x <- x[!is.na(x) & nzchar(x)]
  if (length(x) == 0) {
    return("")
  }
  paste(utils::head(x, max_items), collapse = " | ")
}

extract_formula_variable_names <- function(formula_text) {
  if (!nzchar(formula_text)) {
    return("")
  }
  tokens <- unlist(regmatches(
    formula_text,
    gregexpr("[A-Za-z.][A-Za-z0-9_.]*", formula_text, perl = TRUE)
  ))
  excluded <- c(
    "lm", "glm", "lmer", "glmer", "gam", "gamm", "aov", "data",
    "family", "binomial", "poisson", "gaussian", "weights", "subset"
  )
  collapse_names(tokens[!tolower(tokens) %in% excluded])
}

paper_evidence_for_dataset <- function(paper_audit, pkg, bundle, doc_profile) {
  rows <- data.frame()
  if (nrow(paper_audit) > 0 &&
      all(c("package", "dataset") %in% names(paper_audit))) {
    rows <- paper_audit[
      paper_audit$package == pkg & paper_audit$dataset == bundle,
      ,
      drop = FALSE
    ]
  }

  get_values <- function(column) {
    if (nrow(rows) == 0 || !column %in% names(rows)) {
      return(character(0))
    }
    rows[[column]]
  }

  dois <- collapse_evidence(get_values("doi"))
  titles <- collapse_evidence(get_values("paper_or_book_title"), max_items = 3L)
  models <- collapse_evidence(get_values("model_keywords"))
  formulas <- collapse_evidence(get_values("model_or_equation_found_locally"))
  references <- collapse_evidence(get_values("detected_reference"), max_items = 2L)
  abstracts <- collapse_evidence(get_values("paper_abstract"), max_items = 2L)
  audited_use <- collapse_evidence(get_values("paper_use_summary"), max_items = 2L)
  paper_variables <- extract_formula_variable_names(formulas)
  related_datasets <- ""
  if (nzchar(dois) && nrow(paper_audit) > 0 &&
      all(c("package", "dataset", "doi") %in% names(paper_audit))) {
    doi_values <- trimws(unlist(strsplit(dois, "|", fixed = TRUE)))
    related <- paper_audit[
      paper_audit$package == pkg & paper_audit$doi %in% doi_values,
      "dataset",
      drop = TRUE
    ]
    related_datasets <- collapse_names(related)
  }

  if (!nzchar(references) && !is.na(doc_profile$doc_references)) {
    references <- doc_profile$doc_references
  }

  use_summary <- audited_use
  if (!nzchar(use_summary) && nzchar(titles)) {
    use_summary <- paste0("Referenced work: ", titles, ".")
  }
  if (nzchar(models)) {
    use_summary <- paste(use_summary, paste0(" Models/methods detected: ", models, "."))
  } else if (grepl("predict|mapping|model|regression", titles, ignore.case = TRUE)) {
    use_summary <- paste(
      use_summary,
      "The title indicates a modeling or prediction use; the exact equation was not recovered locally."
    )
  }

  data.frame(
    has_referenced_paper = yes_no(nrow(rows) > 0 || nzchar(references)),
    paper_doi = dois,
    paper_title = titles,
    paper_abstract = abstracts,
    paper_use_summary = trimws(use_summary),
    paper_model_keywords = models,
    paper_formula_or_equation = formulas,
    paper_variables_used = paper_variables,
    paper_related_datasets = related_datasets,
    paper_reference_evidence = references,
    paper_evidence_status = ifelse(
      nzchar(formulas),
      "formula_or_model_found",
      ifelse(nrow(rows) > 0, "paper_identified_no_equation", "rd_reference_only")
    ),
    stringsAsFactors = FALSE
  )
}

list_leaf_components <- function(obj, path = "") {
  excluded_classes <- c(
    "nb", "listw", "polylist", "owin", "im", "ppp", "lpp",
    "psp", "linnet", "solist", "hyperframe", "sf", "Spatial"
  )
  if (!is.list(obj) || is.data.frame(obj) || is.matrix(obj) ||
      inherits(obj, excluded_classes)) {
    return(list(list(path = path, object = obj)))
  }

  component_names <- names(obj)
  if (is.null(component_names)) {
    component_names <- paste0("component_", seq_along(obj))
  }

  result <- list()
  for (i in seq_along(obj)) {
    component_path <- if (nzchar(path)) {
      paste(path, component_names[i], sep = "$")
    } else {
      component_names[i]
    }
    result <- c(
      result,
      list_leaf_components(obj[[i]], component_path)
    )
  }
  result
}

is_raster_object <- function(obj) {
  inherits(obj, c(
    "RasterLayer", "RasterStack", "RasterBrick", "SpatRaster"
  ))
}

is_spacetime_object <- function(obj) {
  inherits(obj, c("STSDF", "STFDF", "STIDF"))
}

is_surveillance_sts_object <- function(obj) {
  inherits(obj, "sts")
}

spacetime_as_attribute_data <- function(obj) {
  if (!is_spacetime_object(obj)) {
    return(NULL)
  }

  values <- as.data.frame(obj@data)
  index <- as.matrix(obj@index)
  if (nrow(index) != nrow(values) || ncol(index) < 2L) {
    return(values)
  }

  spatial_data <- tryCatch(obj@sp@data, error = function(err) NULL)
  if (!is.null(spatial_data)) {
    spatial_data <- spatial_data[index[, 1L], , drop = FALSE]
  }
  coordinates <- tryCatch(
    as.data.frame(sp::coordinates(obj@sp))[index[, 1L], , drop = FALSE],
    error = function(err) NULL
  )
  if (!is.null(coordinates) && ncol(coordinates) >= 2L) {
    names(coordinates)[1:2] <- c("x", "y")
  }
  times <- tryCatch(
    as.POSIXct(zoo::index(obj@time))[index[, 2L]],
    error = function(err) rep(as.POSIXct(NA), nrow(values))
  )

  result <- cbind(
    values,
    spatial_data,
    coordinates,
    datetime = times
  )
  row.names(result) <- NULL
  result
}

sts_as_attribute_data <- function(obj) {
  if (!is_surveillance_sts_object(obj)) {
    return(NULL)
  }

  observed <- tryCatch(obj@observed, error = function(err) NULL)
  if (is.null(observed)) {
    return(NULL)
  }
  observed <- as.matrix(observed)

  epochs <- tryCatch(obj@epoch, error = function(err) seq_len(nrow(observed)))
  units <- colnames(observed)
  if (is.null(units)) {
    units <- paste0("unit_", seq_len(ncol(observed)))
  }

  data.frame(
    time = rep(epochs, times = ncol(observed)),
    unit = rep(units, each = nrow(observed)),
    observed = as.vector(observed),
    stringsAsFactors = FALSE
  )
}

raster_dimensions <- function(obj) {
  if (inherits(obj, c("RasterLayer", "RasterStack", "RasterBrick")) &&
      requireNamespace("raster", quietly = TRUE)) {
    return(c(
      n = as.integer(raster::ncell(obj)),
      k = as.integer(raster::nlayers(obj))
    ))
  }
  if (inherits(obj, "SpatRaster") &&
      requireNamespace("terra", quietly = TRUE)) {
    return(c(
      n = as.integer(terra::ncell(obj)),
      k = as.integer(terra::nlyr(obj))
    ))
  }
  c(n = NA_integer_, k = NA_integer_)
}

raster_variable_names <- function(obj) {
  vars <- tryCatch(names(obj), error = function(err) character(0))
  vars[!is.na(vars) & nzchar(vars)]
}

list_as_aligned_data <- function(obj) {
  # Reconstitue une table d'observations depuis une liste dont les composants
  # tabulaires et les vecteurs partagent le meme nombre de lignes.
  if (!is.list(obj) || length(obj) == 0L ||
      inherits(obj, c(
        "nb", "listw", "polylist", "owin", "im", "ppp", "lpp",
        "psp", "linnet", "solist", "hyperframe"
      ))) {
    return(NULL)
  }

  components <- list_leaf_components(obj)
  component_names <- vapply(components, `[[`, character(1), "path")
  component_objects <- lapply(components, `[[`, "object")

  component_rows <- vapply(component_objects, function(component) {
    if (inherits(component, "dist")) {
      return(as.integer(attr(component, "Size")))
    }
    if (inherits(component, c("nb", "listw"))) {
      return(length(component))
    }
    if (inherits(component, "sf") || is.data.frame(component) ||
        is.matrix(component)) {
      return(nrow(component))
    }
    if (inherits(component, "Spatial") &&
        "data" %in% slotNames(component) &&
        !is.null(component@data)) {
      return(nrow(component@data))
    }
    if (is.atomic(component) && is.null(dim(component))) {
      return(length(component))
    }
    NA_integer_
  }, integer(1))

  valid_rows <- component_rows[!is.na(component_rows) & component_rows > 0L]
  if (length(valid_rows) == 0L) {
    return(NULL)
  }
  direct_rows <- component_rows[
    !grepl("$", component_names, fixed = TRUE) &
      !is.na(component_rows) &
      component_rows > 0L
  ]
  rows_for_reference <- if (length(direct_rows) > 0L) {
    direct_rows
  } else {
    valid_rows
  }
  row_frequencies <- table(rows_for_reference)
  most_frequent <- as.integer(names(row_frequencies)[
    row_frequencies == max(row_frequencies)
  ])
  target_n <- max(most_frequent)

  pieces <- list()
  for (i in seq_along(component_objects)) {
    if (is.na(component_rows[i]) || component_rows[i] != target_n) {
      next
    }
    component <- component_objects[[i]]
    component_name <- component_names[i]

    if (inherits(component, c("dist", "nb", "listw"))) {
      next
    }

    piece <- if (inherits(component, "sf")) {
      as.data.frame(component)
    } else if (inherits(component, "Spatial") &&
               "data" %in% slotNames(component) &&
               !is.null(component@data)) {
      component@data
    } else if (is.data.frame(component)) {
      component
    } else if (is.matrix(component)) {
      as.data.frame(component)
    } else if (is.atomic(component) && is.null(dim(component))) {
      data.frame(
        value = component,
        stringsAsFactors = FALSE,
        check.names = FALSE
      )
    } else {
      NULL
    }

    if (is.null(piece)) {
      next
    }
    if (ncol(piece) == 1L && identical(names(piece), "value")) {
      names(piece) <- component_name
    }
    pieces[[length(pieces) + 1L]] <- piece
  }

  if (length(pieces) == 0L) {
    return(NULL)
  }

  result <- do.call(cbind, pieces)
  names(result) <- make.unique(names(result), sep = "_")
  row.names(result) <- NULL
  result
}

get_object_dimensions <- function(obj) {
  # Renvoie les dimensions N,K adaptees au type de l'objet principal.
  if (is_spacetime_object(obj)) {
    dat <- spacetime_as_attribute_data(obj)
    return(c(n = nrow(dat), k = ncol(dat)))
  }
  if (is_surveillance_sts_object(obj)) {
    dat <- sts_as_attribute_data(obj)
    return(c(n = nrow(dat), k = ncol(dat)))
  }
  if (is_raster_object(obj)) {
    return(raster_dimensions(obj))
  }
  if (inherits(obj, "hyperframe")) {
    raw <- unclass(obj)
    return(c(n = as.integer(raw$ncases), k = as.integer(raw$nvars)))
  }
  if (inherits(obj, c("ppp", "lpp"))) {
    marks <- tryCatch(obj$marks, error = function(err) NULL)
    k <- 2L + ifelse(is.null(marks), 0L, ifelse(is.data.frame(marks), ncol(marks), 1L))
    return(c(n = length(obj$x), k = k))
  }
  if (inherits(obj, "im")) {
    return(c(n = length(obj$v), k = 1L))
  }
  if (inherits(obj, "owin")) {
    return(c(n = 1L, k = 1L))
  }
  if (inherits(obj, "sf")) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }

  if (inherits(obj, "Spatial") &&
      "data" %in% slotNames(obj) &&
      !is.null(obj@data)) {
    return(c(n = nrow(obj@data), k = ncol(obj@data)))
  }

  if (is.data.frame(obj)) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }

  if (is.matrix(obj)) {
    return(c(n = nrow(obj), k = ncol(obj)))
  }
  if (is.list(obj)) {
    dat <- list_as_aligned_data(obj)
    if (!is.null(dat)) {
      return(c(n = nrow(dat), k = ncol(dat)))
    }
  }

  c(n = length(obj), k = NA_integer_)
}

get_object_variables <- function(obj) {
  # Liste les variables exploitables du jeu de donnees principal.
  if (is_spacetime_object(obj)) {
    dat <- spacetime_as_attribute_data(obj)
    return(paste(names(dat), collapse = ", "))
  }
  if (is_surveillance_sts_object(obj)) {
    dat <- sts_as_attribute_data(obj)
    return(paste(names(dat), collapse = ", "))
  }
  if (is_raster_object(obj)) {
    return(paste(raster_variable_names(obj), collapse = ", "))
  }
  if (inherits(obj, "hyperframe")) {
    return(paste(unclass(obj)$vname, collapse = ", "))
  }
  if (inherits(obj, c("ppp", "lpp"))) {
    marks <- tryCatch(obj$marks, error = function(err) NULL)
    mark_names <- if (is.data.frame(marks)) names(marks) else if (!is.null(marks)) "marks" else character(0)
    return(paste(c("x", "y", mark_names), collapse = ", "))
  }
  if (inherits(obj, "im")) {
    return("pixel_value")
  }
  if (inherits(obj, "owin")) {
    return("geometry")
  }
  if (inherits(obj, "sf")) {
    return(paste(names(obj), collapse = ", "))
  }

  if (inherits(obj, "Spatial") &&
      "data" %in% slotNames(obj) &&
      !is.null(obj@data)) {
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
  if (is.list(obj)) {
    dat <- list_as_aligned_data(obj)
    if (!is.null(dat)) {
      return(paste(names(dat), collapse = ", "))
    }
    if (!is.null(names(obj))) {
      return(paste(names(obj), collapse = ", "))
    }
  }

  vars <- names(obj)
  if (is.null(vars)) {
    return(NA_character_)
  }

  paste(vars, collapse = ", ")
}

object_as_attribute_data <- function(obj) {
  # Recupere la table attributaire quand elle existe.
  if (is_spacetime_object(obj)) {
    return(spacetime_as_attribute_data(obj))
  }
  if (is_surveillance_sts_object(obj)) {
    return(sts_as_attribute_data(obj))
  }
  if (is_raster_object(obj)) {
    return(NULL)
  }
  if (inherits(obj, "hyperframe")) {
    return(NULL)
  }
  if (inherits(obj, c("ppp", "lpp"))) {
    return(tryCatch(as.data.frame(obj), error = function(err) NULL))
  }
  if (inherits(obj, "sf")) {
    return(as.data.frame(obj))
  }

  if (inherits(obj, "Spatial") &&
      "data" %in% slotNames(obj) &&
      !is.null(obj@data)) {
    return(obj@data)
  }

  if (is.data.frame(obj)) {
    return(obj)
  }

  if (is.matrix(obj)) {
    return(as.data.frame(obj))
  }
  if (is.list(obj)) {
    return(list_as_aligned_data(obj))
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

escape_regex <- function(x) {
  gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", x)
}

variable_documentation_context <- function(variable, doc_profile = NULL,
                                           window = 140L) {
  # Isole le voisinage du nom de variable dans Format/Details. Utiliser toute
  # la section ferait attribuer la description de `id` aux colonnes voisines.
  if (is.null(doc_profile)) {
    return("")
  }

  fields <- intersect(
    c("doc_format", "doc_details", "doc_description"),
    names(doc_profile)
  )
  if (length(fields) == 0L) {
    return("")
  }

  text <- paste(as.character(unlist(doc_profile[1, fields, drop = FALSE])),
                collapse = " ")
  text <- gsub("\\s+", " ", text)
  if (is.na(text) || !nzchar(text)) {
    return("")
  }

  pattern <- paste0(
    "(?i)(?<![[:alnum:]_])",
    escape_regex(variable),
    "(?![[:alnum:]_])"
  )
  locations <- gregexpr(pattern, text, perl = TRUE)[[1]]
  if (length(locations) == 1L && locations[1] < 0L) {
    return("")
  }

  contexts <- vapply(locations, function(location) {
    start <- max(1L, location - window)
    end <- min(nchar(text), location + attr(locations, "match.length")[1] + window)
    substr(text, start, end)
  }, character(1))
  paste(unique(contexts), collapse = " ")
}

detect_identifier_columns <- function(dat, doc_profile = NULL) {
  # Detecte les cles techniques et libelles, sans confondre une variable
  # continue unique avec un identifiant. Les noms explicites suffisent ; pour
  # les noms ambigus, il faut aussi une preuve documentaire ou structurelle.
  if (is.null(dat) || is.null(names(dat)) || ncol(dat) == 0L) {
    return(character(0))
  }

  vars <- names(dat)
  normalized <- tolower(iconv(vars, from = "", to = "ASCII//TRANSLIT"))
  normalized[is.na(normalized)] <- tolower(vars[is.na(normalized)])
  normalized <- gsub("[^a-z0-9]+", "_", normalized)
  normalized <- gsub("^_+|_+$", "", normalized)

  explicit_name <- grepl(
    paste0(
      "^(id|ids|name|names|label|labels|row_id|rowid|record_id|recordid|",
      "object_id|objectid|observation_id|observationid|case_id|caseid|",
      "subject_id|subjectid|person_id|personid|individual_id|individualid)$|",
      "(^id_|_id$|_identifier$|^identifier_|_name$|_label$)"
    ),
    normalized
  )
  explicit_geo_key <- grepl(
    paste0(
      "^(geoid|geo_id|fips|nuts|area_key|areakey|sr_id|gridcode|",
      "site_code|station_code|region_code|country_code|county_code|",
      "municipality_code|commune_code|postal_code|zip_code)$"
    ),
    normalized
  )
  ambiguous_name <- grepl(
    "(^|_)(key|code|number|index|record|subject|individual|unit|station|site)($|_)",
    normalized
  )

  key_like_values <- vapply(dat, function(column) {
    values <- column[!is.na(column)]
    if (length(values) == 0L) {
      return(FALSE)
    }
    unique_count <- length(unique(values))
    unique_ratio <- unique_count / length(values)
    sequential_integer <-
      (is.numeric(values) || is.integer(values)) &&
      !inherits(values, c("units", "difftime")) &&
      unique_count == length(values) &&
      all(is.finite(values)) &&
      all(as.numeric(values) == floor(as.numeric(values))) &&
      (length(values) <= 1L || all(diff(sort(as.numeric(values))) == 1))
    sequential_integer ||
      (unique_count >= min(20L, max(5L, length(values) %/% 2L)) &&
         unique_ratio >= 0.90)
  }, logical(1))

  documented_identifier <- vapply(vars, function(variable) {
    context <- variable_documentation_context(variable, doc_profile)
    nzchar(context) && grepl(
      paste0(
        "identifier|identification|unique[ -]?(id|code|number)|",
        "row number|record number|observation number|case number|",
        "subject number|individual number|name of (the )?|code for (the )?|",
        "index (of|for) (the )?"
      ),
      context,
      ignore.case = TRUE
    )
  }, logical(1))

  vars[
    explicit_name |
      explicit_geo_key |
      (ambiguous_name & (documented_identifier | key_like_values))
  ]
}

find_coordinate_columns <- function(vars) {
  # Detecte uniquement des paires de coordonnees plausibles.
  # On evite les recherches par sous-chaine : population, name_long,
  # TYPEFLAT ou Alon_meri ne doivent pas devenir des coordonnees.
  vars_lower <- tolower(vars)
  pair_defs <- list(
    c("x", "y"),
    c("lon", "lat"),
    c("long", "lat"),
    c("longitude", "latitude"),
    c("easting", "northing"),
    c("east", "north"),
    c("coord_x", "coord_y"),
    c("coords_x", "coords_y"),
    c("xcoord", "ycoord"),
    c("center_x", "center_y"),
    c("centroid_x", "centroid_y"),
    c("xloc", "yloc"),
    c("x.loc", "y.loc"),
    c("utm.ew", "utm.ns"),
    c("utm_ew", "utm_ns"),
    c("e", "n"),
    c("n", "e"),
    c("c_x", "c_y")
  )

  found <- character(0)
  for (pair in pair_defs) {
    if (all(pair %in% vars_lower)) {
      found <- c(found, vars[match(pair, vars_lower)])
    }
  }

  unique(found)
}

list_spatial_component_names <- function(obj,
                                         include_neighbours = FALSE,
                                         observation_n = NULL) {
  if (!is.list(obj) || is.data.frame(obj) || is.matrix(obj) ||
      length(obj) == 0L ||
      inherits(obj, c(
        "nb", "listw", "polylist", "owin", "im", "ppp", "lpp",
        "psp", "linnet", "solist", "hyperframe"
      ))) {
    return(character(0))
  }

  components <- list_leaf_components(obj)
  component_names <- vapply(components, `[[`, character(1), "path")
  component_objects <- lapply(components, `[[`, "object")

  is_spatial_component <- vapply(seq_along(component_objects), function(i) {
    component <- component_objects[[i]]
    component_name <- tolower(component_names[i])

    if (inherits(component, c(
      "sf", "Spatial", "polylist", "owin", "im", "ppp", "lpp",
      "psp", "linnet"
    ))) {
      return(TRUE)
    }
    if (include_neighbours && inherits(component, c("nb", "listw"))) {
      return(TRUE)
    }

    dat <- if (is.data.frame(component)) {
      component
    } else if (is.matrix(component)) {
      as.data.frame(component)
    } else {
      NULL
    }
    if (!is.null(dat) &&
        length(find_coordinate_columns(names(dat))) >= 2L) {
      return(
        is.null(observation_n) ||
          is.na(observation_n) ||
          nrow(dat) == observation_n
      )
    }

    is.matrix(component) && ncol(component) == 2L &&
      grepl("coord|xy|point|cent", component_name)
  }, logical(1))

  component_names[is_spatial_component]
}

has_point_pattern_component <- function(obj) {
  if (inherits(obj, c("ppp", "lpp", "pp3", "psp", "linnet", "solist", "hyperframe"))) {
    return(TRUE)
  }
  if (!is.list(obj) || is.data.frame(obj) || is.matrix(obj) || length(obj) == 0L) {
    return(FALSE)
  }
  components <- list_leaf_components(obj)
  component_objects <- lapply(components, `[[`, "object")
  any(vapply(component_objects, function(component) {
    inherits(component, c("ppp", "lpp", "pp3", "psp", "linnet", "solist", "hyperframe"))
  }, logical(1)))
}

detect_metadata_signals <- function(obj, doc_profile = NULL, analytical_role = "") {
  # Detecte les signaux utiles au catalogue avec une logique prudente.
  # Les coordonnees exigent une paire valide, et la variable Y n'est plus
  # inventee par defaut : elle doit etre documentee ou fortement nommee.
  dat <- object_as_attribute_data(obj)

  if (is.null(dat)) {
    return(list(
      has_geometry = yes_no(
        inherits(obj, "sf") ||
          inherits(obj, "Spatial") ||
          is_spacetime_object(obj) ||
          is_surveillance_sts_object(obj) ||
          is_raster_object(obj)
      ),
      has_coordinates = "No",
      coordinate_columns = "",
      has_multiple_x = "No",
      candidate_x_variables = "",
      analytical_variables = "",
      analytical_variable_count = 0L,
      identifier_variables = "",
      has_y = "No",
      candidate_y_variables = "",
      target_status = "unknown",
      formula_text = "",
      has_place_name_if_no_geometry = "No",
      place_name_columns = "",
      has_datetime = "No",
      datetime_columns = ""
    ))
  }

  vars <- names(dat)
  vars_lower <- tolower(vars)

  geometry_object <- inherits(obj, "sf") ||
    inherits(obj, "Spatial") ||
    is_surveillance_sts_object(obj) ||
    length(list_spatial_component_names(obj)) > 0L

  coordinate_columns <- find_coordinate_columns(vars)

  identifier_columns <- detect_identifier_columns(dat, doc_profile)

  datetime_columns <- vars[
    grepl("year|date|time|month|day|period|syear|timestep", vars_lower) |
      vapply(dat, function(col) inherits(col, "Date") || inherits(col, "POSIXct") || inherits(col, "POSIXt"), logical(1))
  ]

  place_name_columns <- vars[
    grepl(
      paste0(
        "country|state|county|city|town|municip|commune|depart|district|",
        "borough|ward|province|village|locality|region|zip|postal|fips|",
        "tract|neig|name|place|nuts|geoid|id_?geo"
      ),
      vars_lower
    )
  ]

  excluded_for_model <- unique(c(
    coordinate_columns,
    datetime_columns,
    place_name_columns,
    identifier_columns,
    vars[grepl("geometry|geom|shape|wkt", vars_lower)]
  ))

  formula_response <- character(0)
  formula_predictors <- character(0)
  formula_text <- ""
  if (!is.null(doc_profile)) {
    if (!is.na(doc_profile$formula_response) && nzchar(doc_profile$formula_response)) {
      formula_response <- doc_profile$formula_response
    }
    if (!is.na(doc_profile$formula_predictors) && nzchar(doc_profile$formula_predictors)) {
      formula_predictors <- trimws(unlist(strsplit(doc_profile$formula_predictors, ",", fixed = TRUE)))
    }
    if (!is.na(doc_profile$formula_text) && nzchar(doc_profile$formula_text)) {
      formula_text <- doc_profile$formula_text
    }
  }

  model_usable <- vapply(dat, function(col) {
    if (is.numeric(col) || is.integer(col) || is.factor(col) || is.logical(col)) {
      return(TRUE)
    }
    if (is.character(col)) {
      values <- unique(col[!is.na(col)])
      return(length(values) >= 2L &&
        length(values) <= min(50L, max(2L, nrow(dat) %/% 2L)))
    }
    FALSE
  }, logical(1))
  informative <- vapply(dat, function(col) {
    values <- col[!is.na(col)]
    length(values) > 0L && length(unique(values)) > 1L
  }, logical(1))
  analytical_variables <- vars[
    model_usable & informative & !(vars %in% excluded_for_model)
  ]

  y_pattern <- paste(
    c(
      "^y$", "target", "response", "outcome", "dependent",
      "price", "value", "crime", "homicide", "burgl", "murder",
      "death", "mort", "suicid", "(^|_)rate($|_)", "cases", "count", "incidence",
      "income", "wage", "employment", "unemployment", "yield",
      "rent", "sales", "disease", "sids", "leuk", "pop",
      "pm10", "survivors?",
      "^medv$", "^cmedv$",
      "^spri$", "richness", "species"
    ),
    collapse = "|"
  )

  candidate_y <- intersect(setdiff(vars, excluded_for_model), formula_response)
  if (length(candidate_y) == 0) {
    candidate_y <- vars[
      model_usable & informative &
        grepl(y_pattern, vars_lower) &
        !(vars %in% excluded_for_model)
    ]
  }
  documentation_context <- ""
  if (!is.null(doc_profile)) {
    documentation_context <- paste(
      doc_profile$doc_description,
      doc_profile$doc_format,
      doc_profile$doc_details
    )
  }
  housing_context <- grepl(
    "housing|house price|home value|owner-occupied|hedonic",
    documentation_context,
    ignore.case = TRUE
  )
  if (housing_context) {
    housing_targets <- vars[
      model_usable & informative &
        vars_lower %in% c("mv", "medv", "cmedv") &
        !(vars %in% excluded_for_model)
    ]
    candidate_y <- unique(c(candidate_y, housing_targets))
  }
  chemical_context <- FALSE
  if (!is.null(doc_profile)) {
    chemical_context <- grepl(
      paste0(
        "soil|sediment|geochem|heavy metal|trace element|",
        "metal concentration|chemical concentration|pollut"
      ),
      documentation_context,
      ignore.case = TRUE
    )
  }
  if (chemical_context) {
    chemical_targets <- vars[
      model_usable & informative &
        grepl(
          paste0(
            "^(cd|co|cr|cu|ni|pb|zn|cadmium|cobalt|chromium|",
            "copper|nickel|lead|zinc)$"
          ),
          vars_lower
        ) &
        !(vars %in% excluded_for_model)
    ]
    candidate_y <- unique(c(candidate_y, chemical_targets))
  }
  candidate_y <- intersect(candidate_y, analytical_variables)
  candidate_x <- vars[
    vars %in% analytical_variables &
      !(vars %in% candidate_y)
  ]

  if (length(formula_predictors) > 0) {
    documented_x <- intersect(analytical_variables, formula_predictors)
    if (length(documented_x) > 0) {
      candidate_x <- documented_x
    }
  }

  has_coordinates <- length(coordinate_columns) > 0
  has_geometry <- geometry_object || has_coordinates

  list(
    has_geometry = yes_no(has_geometry),
    has_coordinates = yes_no(has_coordinates),
    coordinate_columns = collapse_names(coordinate_columns),
    has_multiple_x = yes_no(length(candidate_x) >= 2),
    candidate_x_variables = collapse_names(candidate_x),
    analytical_variables = collapse_names(analytical_variables),
    analytical_variable_count = length(analytical_variables),
    identifier_variables = collapse_names(identifier_columns),
    has_y = yes_no(length(candidate_y) > 0),
    candidate_y_variables = collapse_names(candidate_y),
    target_status = ifelse(length(intersect(candidate_y, formula_response)) > 0, "documented_formula",
      ifelse(length(candidate_y) > 0, "strong_name", "unknown")
    ),
    formula_text = formula_text,
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

object_row_count <- function(obj) {
  # Renvoie le nombre d'unites porte par un objet auxiliaire ou principal.
  if (inherits(obj, "nb")) {
    return(length(obj))
  }
  if (inherits(obj, "listw")) {
    return(length(obj$neighbours))
  }
  if (inherits(obj, "polylist")) {
    return(length(obj))
  }
  dims <- get_object_dimensions(obj)
  unname(dims["n"])
}

infer_auxiliary_relation <- function(role) {
  # Traduit le role d'un objet auxiliaire en type de preuve geographique.
  switch(
    role,
    neighbor_graph = "provides_neighbor_graph",
    neighbor_graph_alternative = "provides_alternative_neighbor_graph",
    spatial_weights = "provides_spatial_weights",
    coordinates = "provides_coordinates",
    geometry = "provides_geometry",
    weights_or_adjacency_matrix = "provides_weights_or_adjacency_matrix",
    matrix_auxiliary = "provides_auxiliary_matrix",
    attribute_table = "provides_attribute_table",
    vector_auxiliary = "provides_auxiliary_vector",
    list_auxiliary = "provides_auxiliary_list",
    deprecated_auxiliary = "deprecated_or_legacy_auxiliary",
    "unclear_auxiliary"
  )
}

compare_main_auxiliary_n <- function(main_obj, aux_obj) {
  # Compare les tailles main/auxiliaire pour savoir si l'association est
  # probablement ligne-a-ligne, region-a-region ou seulement contextuelle.
  main_n <- object_row_count(main_obj)
  aux_n <- object_row_count(aux_obj)

  if (is.na(main_n) || is.na(aux_n)) {
    return("unknown")
  }
  if (identical(as.integer(main_n), as.integer(aux_n))) {
    return("matches_main_n")
  }
  "mismatch"
}

build_bundle_profile_rows <- function(pkg,
                                      bundle,
                                      objects,
                                      env,
                                      curation,
                                      doc_profile,
                                      paper_evidence) {
  # Decrit tous les objets charges dans un bundle, pas seulement le principal.
  lapply(objects, function(obj_name) {
    obj <- env[[obj_name]]
    dims <- get_object_dimensions(obj)
    role <- curation$role[curation$object == obj_name][1]
    metadata_signals <- detect_metadata_signals(obj, doc_profile, role)
    data.frame(
      package = pkg,
      bundle = bundle,
      object = obj_name,
      role = role,
      keep = curation$keep[curation$object == obj_name][1],
      class = paste(class(obj), collapse = ", "),
      n = unname(dims["n"]),
      k = metadata_signals$analytical_variable_count,
      variables = get_object_variables(obj),
      analytical_variables = metadata_signals$analytical_variables,
      identifier_variables = metadata_signals$identifier_variables,
      doc_has_rd = doc_profile$doc_has_rd,
      formula_response = doc_profile$formula_response,
      formula_predictors = doc_profile$formula_predictors,
      formula_text = doc_profile$formula_text,
      has_referenced_paper = paper_evidence$has_referenced_paper,
      paper_doi = paper_evidence$paper_doi,
      paper_title = paper_evidence$paper_title,
      paper_abstract = paper_evidence$paper_abstract,
      paper_use_summary = paper_evidence$paper_use_summary,
      paper_formula_or_equation = paper_evidence$paper_formula_or_equation,
      paper_variables_used = paper_evidence$paper_variables_used,
      paper_related_datasets = paper_evidence$paper_related_datasets,
      stringsAsFactors = FALSE
    )
  })
}

build_auxiliary_link_rows <- function(pkg, bundle, main_objects, auxiliary_objects, env, curation) {
  # Cree une table relationnelle main_object -> auxiliary_object.
  # Cette table garde la preuve geographique sans forcer une jointure physique.
  rows <- list()
  if (length(main_objects) == 0 || length(auxiliary_objects) == 0) {
    return(rows)
  }

  for (main_object in main_objects) {
    for (auxiliary_object in auxiliary_objects) {
      role <- curation$role[curation$object == auxiliary_object][1]
      rows[[length(rows) + 1]] <- data.frame(
        package = pkg,
        bundle = bundle,
        main_object = main_object,
        auxiliary_object = auxiliary_object,
        auxiliary_role = role,
        relation_type = infer_auxiliary_relation(role),
        n_alignment = compare_main_auxiliary_n(env[[main_object]], env[[auxiliary_object]]),
        evidence = paste("same data() bundle:", bundle),
        stringsAsFactors = FALSE
      )
    }
  }

  rows
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

catalog_bundles_from_packages <- function(packages = software_r_packages,
                                          install_missing = FALSE,
                                          verbose = TRUE) {
  # Premiere etape volontairement simple du nouveau pipeline :
  # une ligne par bundle avec uniquement les objets charges par data().
  rows <- list()

  for (pkg in packages) {
    if (verbose) {
      cat("\nPackage :", pkg, "\n")
    }

    if (!requireNamespace(pkg, quietly = TRUE) && isTRUE(install_missing)) {
      install.packages(pkg)
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
        cat("  Aucun bundle declare par data(package = ...).\n")
      }
      next
    }

    parsed <- lapply(entries$item, parse_dataset_label)
    entries$bundle <- vapply(parsed, `[[`, character(1), "bundle")
    bundles <- unique(entries$bundle)

    for (bundle in bundles) {
      e <- new.env(parent = emptyenv())
      loaded <- tryCatch({
        data(list = bundle, package = pkg, envir = e)
        TRUE
      }, error = function(err) {
        if (verbose) {
          cat("  Bundle non charge :", bundle, "-", conditionMessage(err), "\n")
        }
        FALSE
      })

      objects <- if (loaded) sort(ls(e, all.names = TRUE)) else character(0)
      contains_sf <- loaded && any(vapply(
        objects,
        function(object_name) inherits(e[[object_name]], "sf"),
        logical(1)
      ))
      doc_text <- get_dataset_documentation_text(pkg, bundle)
      description <- extract_doc_section(doc_text, "Description")
      if (is.na(description) || !nzchar(description)) {
        description <- entries$title[entries$bundle == bundle][1]
      }
      rows[[length(rows) + 1L]] <- data.frame(
        package = pkg,
        bundle = bundle,
        objets_contenus = paste(objects, collapse = ", "),
        contient_sf = contains_sf,
        description = description,
        stringsAsFactors = FALSE
      )

      if (verbose) {
        cat(
          "  Bundle :", bundle,
          "| objets :", ifelse(length(objects) == 0, "aucun", paste(objects, collapse = ", ")),
          "\n"
        )
      }
    }
  }

  if (length(rows) == 0) {
    return(data.frame(
      package = character(),
      bundle = character(),
      objets_contenus = character(),
      contient_sf = logical(),
      description = character(),
      stringsAsFactors = FALSE
    ))
  }

  catalogue_bundles <- do.call(rbind, rows)
  row.names(catalogue_bundles) <- NULL
  catalogue_bundles <- add_bundle_groups(catalogue_bundles)
  catalogue_bundles <- catalogue_bundles[
    order(
      catalogue_bundles$package,
      catalogue_bundles$groupe_bundle,
      catalogue_bundles$bundle
    ),
    ,
    drop = FALSE
  ]
  row.names(catalogue_bundles) <- NULL
  catalogue_bundles
}

add_bundle_groups <- function(catalogue_bundles) {
  # Range les bundles apparentes sous un nom commun sans fusionner leurs donnees.
  catalogue_bundles$groupe_bundle <- catalogue_bundles$bundle

  for (pkg in unique(catalogue_bundles$package)) {
    idx <- which(catalogue_bundles$package == pkg)
    names_in_package <- catalogue_bundles$bundle[idx]
    bases <- names_in_package[order(nchar(names_in_package), names_in_package)]

    for (base in bases) {
      base_lower <- tolower(base)
      candidates <- idx[
        startsWith(tolower(catalogue_bundles$bundle[idx]), base_lower)
      ]

      for (candidate in candidates) {
        variant <- catalogue_bundles$bundle[candidate]
        suffix <- substring(variant, nchar(base) + 1L)
        related <- identical(tolower(variant), base_lower) ||
          grepl("^[._-]", suffix) ||
          grepl("^(\\d+|full)$", suffix, ignore.case = TRUE)

        if (related &&
            identical(catalogue_bundles$groupe_bundle[candidate], variant)) {
          catalogue_bundles$groupe_bundle[candidate] <- base
        }
      }
    }

    # Certains ensembles n'ont pas de bundle portant exactement le nom de
    # base, mais seulement des variantes train/test/grid/prediction.
    package_bundles <- catalogue_bundles$bundle[idx]
    inferred_bases <- sub(
      "([._-](train|test|grids?|pred|prediction|val|validation))$",
      "",
      package_bundles,
      ignore.case = TRUE
    )
    for (base in unique(inferred_bases)) {
      members <- idx[inferred_bases == base]
      if (length(members) < 2L || !nzchar(base)) {
        next
      }
      catalogue_bundles$groupe_bundle[members] <- base
    }

    # Des tables complementaires sont souvent exposees comme plusieurs
    # data() distincts mais documentees sur une seule page Rd. Cette preuve
    # est plus fiable qu'une simple proximite lexicale.
    rd_pages <- vapply(package_bundles, function(bundle) {
      get_dataset_rd_name(pkg, bundle)
    }, character(1))
    for (rd_page in unique(rd_pages[!is.na(rd_pages)])) {
      members <- idx[rd_pages == rd_page & !is.na(rd_pages)]
      if (length(members) < 2L) {
        next
      }

      group_name <- sub("\\.Rd$", "", rd_page, ignore.case = TRUE)
      member_names <- catalogue_bundles$bundle[members]
      common_prefix <- member_names[1L]
      for (member_name in member_names[-1L]) {
        max_length <- min(nchar(common_prefix), nchar(member_name))
        shared <- 0L
        while (shared < max_length &&
               substr(common_prefix, shared + 1L, shared + 1L) ==
                 substr(member_name, shared + 1L, shared + 1L)) {
          shared <- shared + 1L
        }
        common_prefix <- substr(common_prefix, 1L, shared)
      }
      common_prefix <- sub("[._-]+$", "", common_prefix)
      if (nzchar(common_prefix)) {
        group_name <- common_prefix
      }
      catalogue_bundles$groupe_bundle[members] <- group_name
    }
  }

  manual_bundle_links <- data.frame(
    package = c(
      "spaMM",
      "spDataLarge", "spDataLarge",
      "spData", "spData",
      "vegan", "vegan"
    ),
    bundle = c(
      "small_spde",
      "study_area", "comm",
      "worldbank_df", "coffee_data",
      "BCI.env", "sipoo.map"
    ),
    groupe_bundle = c(
      "blackcap",
      "fog_oasis", "fog_oasis",
      "world", "world",
      "BCI", "sipoo"
    ),
    stringsAsFactors = FALSE
  )

  for (i in seq_len(nrow(manual_bundle_links))) {
    members <- which(
      catalogue_bundles$package == manual_bundle_links$package[i] &
        catalogue_bundles$bundle == manual_bundle_links$bundle[i]
    )
    if (length(members) > 0L) {
      catalogue_bundles$groupe_bundle[members] <- manual_bundle_links$groupe_bundle[i]
    }
  }

  catalogue_bundles$contient_sf <- NULL
  catalogue_bundles
}

write_bundle_catalog_rdata <- function(catalogue_bundles,
                                       output_path = file.path(
                                         find_repo_root(),
                                         "data",
                                         "manifests",
                                         "datasets",
                                         "catalogue_datasets_software.RData"
                                       )) {
  dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  output_env <- new.env(parent = emptyenv())
  if (file.exists(output_path)) {
    try(load(output_path, envir = output_env), silent = TRUE)
  }
  output_env$catalogue_bundles <- catalogue_bundles
  save(
    list = ls(output_env, all.names = TRUE),
    envir = output_env,
    file = output_path,
    compress = "xz"
  )

  cat("\nCatalogue des bundles ecrit :", output_path, "\n")
  cat("Nombre de bundles :", nrow(catalogue_bundles), "\n")
  invisible(output_path)
}

consulter_catalogue <- function(regenerer = FALSE,
                                package = NULL,
                                recherche = NULL,
                                n = 20L,
                                afficher = TRUE) {
  # Fonction publique unique pour generer, verifier et afficher le catalogue.
  output_path <- file.path(
    find_repo_root(),
    "data",
    "manifests",
    "datasets",
    "catalogue_datasets_software.RData"
  )

  if (isTRUE(regenerer)) {
    catalogue <- main(write_output = TRUE, verbose = FALSE)
  } else {
    if (!file.exists(output_path)) {
      stop(
        "Catalogue absent. Lance consulter_catalogue(regenerer = TRUE).",
        call. = FALSE
      )
    }
    catalog_env <- new.env(parent = emptyenv())
    load(output_path, envir = catalog_env)
    catalogue <- catalog_env$catalogue_bundles
  }

  resultat <- catalogue
  if (!is.null(package)) {
    resultat <- resultat[resultat$package == package, , drop = FALSE]
  }
  if (!is.null(recherche)) {
    resultat <- resultat[
      grepl(recherche, resultat$bundle, ignore.case = TRUE),
      ,
      drop = FALSE
    ]
  }

  if (isTRUE(afficher)) {
    cat("Bundles dans le catalogue :", nrow(catalogue), "\n")
    cat("Lignes correspondant aux filtres :", nrow(resultat), "\n\n")
    print(utils::head(resultat, n), row.names = FALSE)

    if (nrow(resultat) > n) {
      cat("\nAffichage limite aux", n, "premieres lignes.\n")
    }
  }

  invisible(resultat)
}

consulter_groupe <- function(groupe, package = NULL) {
  # Affiche un groupe comme une arborescence sans charger ni fusionner les donnees.
  catalogue <- consulter_catalogue(afficher = FALSE)
  resultat <- catalogue[
    tolower(catalogue$groupe_bundle) == tolower(groupe),
    ,
    drop = FALSE
  ]
  if (!is.null(package)) {
    resultat <- resultat[resultat$package == package, , drop = FALSE]
  }

  if (nrow(resultat) == 0) {
    cat("Aucun groupe trouve pour :", groupe, "\n")
    return(invisible(resultat))
  }

  for (pkg in unique(resultat$package)) {
    cat("\n", groupe, " [package ", pkg, "]\n", sep = "")
    rows <- resultat[resultat$package == pkg, , drop = FALSE]
    for (i in seq_len(nrow(rows))) {
      cat("  - ", rows$bundle[i], "\n", sep = "")
      cat("      objets : ", rows$objets_contenus[i], "\n", sep = "")
      cat("      description : ", rows$description[i], "\n", sep = "")
    }
  }

  invisible(resultat)
}

charger_groupe_bundle <- function(catalogue_bundles, package, groupe) {
  rows <- catalogue_bundles[
    catalogue_bundles$package == package &
      catalogue_bundles$groupe_bundle == groupe,
    ,
    drop = FALSE
  ]
  loaded <- list()

  for (bundle in rows$bundle) {
    e <- new.env(parent = emptyenv())
    ok <- tryCatch({
      data(list = bundle, package = package, envir = e)
      TRUE
    }, error = function(err) {
      FALSE
    })
    if (!ok) {
      next
    }
    for (object_name in ls(e, all.names = TRUE)) {
      key <- paste(bundle, object_name, sep = "::")
      loaded[[key]] <- list(
        bundle = bundle,
        object_name = object_name,
        object = e[[object_name]]
      )
    }
  }

  loaded
}

est_objet_spatial_auxiliaire <- function(obj, object_name = "", doc_text = "") {
  name_lower <- tolower(object_name)
  inherits(obj, c(
    "Spatial", "polylist", "owin", "im", "ppp", "lpp", "psp", "linnet"
  )) ||
    is_spacetime_object(obj) ||
    is_surveillance_sts_object(obj) ||
    is_raster_object(obj) ||
    length(list_spatial_component_names(obj)) > 0L ||
    ({
      dat <- tryCatch(object_as_attribute_data(obj), error = function(err) NULL)
      !is.null(dat) && length(find_coordinate_columns(names(dat))) >= 2L
    }) ||
    (is.matrix(obj) && nrow(obj) == ncol(obj) &&
      grepl(
        "weight|contigu|neighbou?r|adjacen|spatial matrix",
        paste(name_lower, doc_text),
        ignore.case = TRUE
      )) ||
    (is.matrix(obj) && ncol(obj) == 2L &&
      grepl("coord|xy|poly|grid|point|cent", name_lower)) ||
    grepl(
      "coord|poly|polygon|grid|geom|shape|boundary|border|outline|mask|area",
      name_lower
    )
}

safe_attribute_data <- function(obj) {
  if (inherits(obj, c("nb", "listw", "polylist", "owin", "im"))) {
    return(NULL)
  }
  tryCatch(
    object_as_attribute_data(obj),
    error = function(err) NULL
  )
}

variables_analytiques <- function(obj, response = character(0)) {
  if (is_raster_object(obj)) {
    return(setdiff(raster_variable_names(obj), response))
  }
  if (is.matrix(obj) && nrow(obj) == ncol(obj)) {
    return(character(0))
  }
  dat <- safe_attribute_data(obj)
  if (is.null(dat)) {
    return(character(0))
  }

  vars <- names(dat)
  vars_lower <- tolower(vars)
  coordinates <- find_coordinate_columns(vars)
  dates <- vars[
    grepl("year|date|time|month|day|period|timestep", vars_lower) |
      vapply(dat, function(col) {
        inherits(col, c("Date", "POSIXct", "POSIXt"))
      }, logical(1))
  ]
  identifiers <- vars[
    grepl(
      paste0(
        "(^id$|_id$|^id_|^record$|code|name|label|fips|geoid|tract|",
        "iso[0-9_]*|nuts|id.?geo|^dept$|county|country|state|region|",
        "^site$|site.?id|site.?code|^station$|station.?id|station.?code|",
        "^profile$|profile.?id|profile.?number|",
        "department|municip|commune|city|town|plot|block|treat)"
      ),
      vars_lower
    )
  ]
  geometry <- vars[grepl("^(geometry|geom|shape|wkt)$", vars_lower)]
  usable <- vapply(dat, function(col) {
    if (is.numeric(col) || is.integer(col) || is.factor(col) || is.logical(col)) {
      return(TRUE)
    }
    if (is.character(col)) {
      values <- unique(col[!is.na(col)])
      return(length(values) >= 2L && length(values) <= min(20L, max(2L, nrow(dat) %/% 2L)))
    }
    FALSE
  }, logical(1))
  informative <- vapply(dat, function(col) {
    values <- col[!is.na(col)]
    length(values) > 0L && length(unique(values)) > 1L
  }, logical(1))

  setdiff(vars[usable & informative], unique(c(
    coordinates, dates, identifiers, geometry, response
  )))
}

est_variable_exposition <- function(variable, response, doc_text = "") {
  variable_lower <- tolower(variable)
  response_lower <- tolower(response)
  epidemiology_response <- any(grepl(
    "case|death|mort|incidence|disease|leuk|sids",
    response_lower
  ))
  epidemiology_doc <- grepl(
    "incidence|epidemiolog|disease|case|population at risk|expected",
    doc_text,
    ignore.case = TRUE
  )

  grepl(
    "^(population|pop|expected|exposure|offset|person.?years?|person.?time)$",
    variable_lower
  ) && (epidemiology_response || epidemiology_doc)
}

nettoyer_covariables <- function(covariates, response, doc_text = "") {
  covariates[!vapply(covariates, function(variable) {
    variable_lower <- tolower(variable)
    derived_from_response <- any(vapply(tolower(response), function(target) {
      grepl(
        paste0(
          "^((annual|yearly|monthly)[._]?)?(mean|average|avg)[._]?",
          gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", target),
          "$"
        ),
        variable_lower
      )
    }, logical(1)))

    derived_from_response ||
    est_variable_exposition(variable, response, doc_text)
  }, logical(1))]
}

nettoyer_reponses <- function(response, doc_text = "") {
  response_lower <- tolower(response)
  direct_responses <- response[
    !grepl(
      "^((annual|yearly|monthly)[._]?)?(mean|average|avg)[._]?",
      response_lower
    )
  ]
  if (length(direct_responses) > 0L) {
    derived_suffix <- sub(
      "^((annual|yearly|monthly)[._]?)?(mean|average|avg)[._]?",
      "",
      response_lower
    )
    response <- response[
      !(response_lower != derived_suffix &
          derived_suffix %in% tolower(direct_responses))
    ]
  }

  if (length(response) <= 1L) {
    return(response)
  }
  substantive_response <- response[grepl(
    "case|death|mort|incidence|disease|leuk|sids",
    response,
    ignore.case = TRUE
  )]
  if (length(substantive_response) == 0L &&
      !grepl("incidence|epidemiolog|disease", doc_text, ignore.case = TRUE)) {
    return(response)
  }
  response[!grepl(
    "^(population|pop|expected|exposure|offset|person.?years?|person.?time)$",
    response,
    ignore.case = TRUE
  )]
}

colonnes_geographiques_recuperables <- function(obj, doc_text = "") {
  dat <- safe_attribute_data(obj)
  if (is.null(dat) || nrow(dat) == 0L) {
    return(character(0))
  }

  vars <- names(dat)
  vars_lower <- tolower(vars)
  normalized_names <- gsub("[^a-z0-9]+", "_", vars_lower)
  geographic_name <- grepl(
    paste0(
      "^(country|state|county|city|town|municipality|municipal|commune|",
      "department|departement|district|borough|ward|province|village|",
      "locality|regions?|neighborhood|neighbourhood|place)",
      "(_name|name|_label|label)?$"
    ),
    normalized_names
  )
  identifier_only <- grepl(
    "code|fips|geoid|nuts|zip|postal|(^id$|_id$|^id_)",
    vars_lower
  )
  informative <- vapply(dat, function(col) {
    values <- unique(trimws(as.character(col[!is.na(col)])))
    values <- values[nzchar(values)]
    length(values) >= 2L
  }, logical(1))
  textual <- vapply(dat, function(col) {
    is.character(col) || is.factor(col)
  }, logical(1))
  documented_geography <- grepl(
    paste0(
      "district|borough|county|municip|commune|region|province|state|",
      "city|town|village|geograph|spatial|location"
    ),
    doc_text,
    ignore.case = TRUE
  )

  vars[geographic_name & !identifier_only & informative &
    (textual | documented_geography)]
}

list_geographic_axis_sources <- function(obj, doc_text = "") {
  if (!is.list(obj) || length(obj) == 0L ||
      !grepl(
        "population|continent|world|geograph|spatial|location|region",
        doc_text,
        ignore.case = TRUE
      )) {
    return(character(0))
  }

  components <- list_leaf_components(obj)
  paths <- vapply(components, `[[`, character(1), "path")
  objects <- lapply(components, `[[`, "object")
  tabular <- which(vapply(objects, function(component) {
    is.data.frame(component) || is.matrix(component)
  }, logical(1)))

  sources <- character(0)
  for (i in tabular) {
    main_table <- as.data.frame(objects[[i]])
    if (ncol(main_table) < 2L || is.null(names(main_table))) {
      next
    }
    for (j in setdiff(tabular, i)) {
      metadata <- as.data.frame(objects[[j]])
      if (nrow(metadata) != ncol(main_table)) {
        next
      }
      geographic_columns <- colonnes_geographiques_recuperables(
        metadata,
        doc_text
      )
      if (length(geographic_columns) == 0L) {
        next
      }
      sources <- c(
        sources,
        paste0(paths[i], "[colnames]"),
        paste0(paths[j], "$", geographic_columns)
      )
    }
  }

  unique(sources)
}

documentation_geographic_units <- function(obj, doc_text = "") {
  dat <- safe_attribute_data(obj)
  if (is.null(dat) || nrow(dat) < 2L || !nzchar(doc_text)) {
    return(character(0))
  }

  doc_lower <- tolower(doc_text)
  unit_patterns <- c(
    census_tracts = "census tracts?",
    states = "states?",
    counties = "count(y|ies)",
    regional_units = "regional",
    regions = "regions?",
    districts = "districts?",
    provinces = "provinces?",
    municipalities = "municipalit(y|ies)",
    catchment_areas = "catchment areas?",
    countries = "countries",
    cities = "cities",
    towns = "towns?",
    villages = "villages?"
  )
  context_pattern <- paste0(
    "cross[- ]section|observations?|data (set )?(on|for|from)|",
    "sample of|measured (on|in)|collected (on|in)"
  )
  segments <- trimws(unlist(strsplit(
    doc_lower,
    "[.!?;\\n]+",
    perl = TRUE
  )))
  observation_segments <- segments[
    grepl(context_pattern, segments, perl = TRUE)
  ]
  if (length(observation_segments) == 0L) {
    return(character(0))
  }
  observation_text <- paste(observation_segments, collapse = " ")

  matched <- names(unit_patterns)[vapply(unit_patterns, function(pattern) {
    grepl(paste0("\\b", pattern, "\\b"), observation_text, perl = TRUE)
  }, logical(1))]
  matched
}

decision_manuelle_catalogue <- function(package, groupe) {
  key <- paste(package, groupe, sep = "::")
  decisions <- c(
    "sp::meuse" = "retenu",
    "sfdep::guerry" = "retenu",
    "spData::nz" = "retenu",
    "gstat::jura" = "retenu",
    "spDataLarge::study_area" = "non_retenu",
    "spse::usaww" = "non_retenu",
    "spatstat.data::redwood" = "non_retenu",
    "SpatialEpi::NYleukemia" = "non_retenu",
    "spData::alaska" = "non_retenu",
    "spData::hawaii" = "non_retenu",
    "spData::lnd" = "non_retenu",
    "spData::cycle_hire" = "non_retenu",
    "gstat::ncp.grid" = "non_retenu",
    "gstat::sic2004" = "non_retenu",
    "giscoR::gisco_coastal_lines" = "non_retenu",
    "giscoR::gisco_countries_2024" = "non_retenu",
    "giscoR::gisco_nuts_2024" = "non_retenu"
  )

  if (key %in% names(decisions)) unname(decisions[[key]]) else ""
}

resumer_signaux_groupe <- function(catalogue_bundles, package, groupe) {
  loaded <- charger_groupe_bundle(catalogue_bundles, package, groupe)
  group_rows <- catalogue_bundles[
    catalogue_bundles$package == package &
      catalogue_bundles$groupe_bundle == groupe,
    ,
    drop = FALSE
  ]
  group_description <- paste(group_rows$description, collapse = " ")
  if (length(loaded) == 0) {
    return(list(
      package = package,
      groupe = groupe,
      loaded = loaded,
      priority = 5L
    ))
  }

  has_sf <- any(vapply(loaded, function(item) {
    inherits(item$object, "sf")
  }, logical(1)))
  has_auxiliary <- any(vapply(loaded, function(item) {
    est_objet_spatial_auxiliaire(
      item$object,
      item$object_name,
      group_description
    )
  }, logical(1)))
  has_coordinates <- any(vapply(loaded, function(item) {
    dat <- safe_attribute_data(item$object)
    !is.null(dat) && length(find_coordinate_columns(names(dat))) >= 2L
  }, logical(1)))

  priority <- if (has_sf) {
    1L
  } else if (has_auxiliary) {
    2L
  } else if (has_coordinates) {
    3L
  } else {
    4L
  }

  list(
    package = package,
    groupe = groupe,
    loaded = loaded,
    priority = priority
  )
}

selectionner_50_groupes <- function(catalogue_bundles, n = 50L) {
  groups <- unique(catalogue_bundles[, c("package", "groupe_bundle")])
  signals <- lapply(seq_len(nrow(groups)), function(i) {
    resumer_signaux_groupe(
      catalogue_bundles,
      groups$package[i],
      groups$groupe_bundle[i]
    )
  })
  priorities <- vapply(signals, `[[`, integer(1), "priority")

  quotas <- c(`1` = 20L, `2` = 15L, `3` = 10L, `4` = 5L)
  signal_keys <- paste(
    vapply(signals, `[[`, character(1), "package"),
    vapply(signals, `[[`, character(1), "groupe"),
    sep = "::"
  )
  anchor_keys <- c(
    "sp::meuse",
    "spData::us_states",
    "spDataLarge::study_area",
    "spse::usaww",
    "spatstat.data::redwood"
  )
  selected <- match(anchor_keys, signal_keys, nomatch = 0L)
  selected <- selected[selected > 0L]

  for (priority in names(quotas)) {
    quota <- quotas[[priority]] -
      sum(priorities[selected] == as.integer(priority))
    if (quota <= 0L) {
      next
    }
    candidates <- setdiff(which(priorities == as.integer(priority)), selected)
    candidates <- candidates[order(
      vapply(signals[candidates], `[[`, character(1), "package"),
      vapply(signals[candidates], `[[`, character(1), "groupe")
    )]
    selected <- c(selected, utils::head(candidates, quota))
  }

  if (length(selected) < n) {
    remaining <- setdiff(seq_along(signals), selected)
    remaining <- remaining[order(
      priorities[remaining],
      vapply(signals[remaining], `[[`, character(1), "package"),
      vapply(signals[remaining], `[[`, character(1), "groupe")
    )]
    selected <- c(selected, utils::head(remaining, n - length(selected)))
  }

  signals[utils::head(selected, n)]
}

auditer_groupe_sf <- function(catalogue_bundles, signal) {
  package <- signal$package
  groupe <- signal$groupe
  loaded <- signal$loaded

  if (length(loaded) == 0) {
    return(data.frame(
      package = package,
      groupe = groupe,
      bundles = "",
      spatial_sf = "exclu",
      source_spatiale = "",
      objet_principal = "",
      n = NA_integer_,
      covariables = "",
      nombre_covariables = 0L,
      variable_reponse = "",
      formule = "",
      preuve = "chargement_echoue",
      raison = "Aucun objet du groupe n'a pu etre charge.",
      retenu = "non_retenu",
      stringsAsFactors = FALSE
    ))
  }

  rows <- catalogue_bundles[
    catalogue_bundles$package == package &
      catalogue_bundles$groupe_bundle == groupe,
    ,
    drop = FALSE
  ]
  doc_texts <- vapply(rows$bundle, function(bundle) {
    text <- get_dataset_documentation_text(package, bundle)
    if (is.na(text)) "" else text
  }, character(1))
  doc_text <- paste(unique(doc_texts[nzchar(doc_texts)]), collapse = "\n")
  doc_profile <- extract_documentation_profile(package, groupe, doc_text)

  object_names <- vapply(loaded, `[[`, character(1), "object_name")
  objects <- lapply(loaded, `[[`, "object")
  classes <- vapply(objects, function(obj) paste(class(obj), collapse = "/"), character(1))
  roles <- vapply(seq_along(objects), function(i) {
    guess_object_role(objects[[i]], object_names[i], groupe, doc_text)
  }, character(1))

  sf_idx <- which(vapply(objects, inherits, logical(1), what = "sf"))
  spatial_idx <- which(vapply(objects, inherits, logical(1), what = "Spatial"))
  spacetime_idx <- which(vapply(objects, is_spacetime_object, logical(1)))
  sts_idx <- which(vapply(objects, is_surveillance_sts_object, logical(1)))
  point_pattern_idx <- which(vapply(objects, function(obj) {
    has_point_pattern_component(obj)
  }, logical(1)))
  raster_idx <- which(vapply(objects, is_raster_object, logical(1)))
  tabular_idx <- which(vapply(objects, function(obj) {
    !is.null(safe_attribute_data(obj))
  }, logical(1)))
  coordinate_idx <- tabular_idx[vapply(tabular_idx, function(i) {
    dat <- safe_attribute_data(objects[[i]])
    length(find_coordinate_columns(names(dat))) >= 2L
  }, logical(1))]
  geographic_name_idx <- tabular_idx[vapply(tabular_idx, function(i) {
    length(colonnes_geographiques_recuperables(objects[[i]], doc_text)) > 0L
  }, logical(1))]
  geographic_axis_sources <- unique(unlist(lapply(seq_along(objects), function(i) {
    sources <- list_geographic_axis_sources(objects[[i]], doc_text)
    if (length(sources) == 0L) {
      return(character(0))
    }
    paste0(object_names[i], "$", sources)
  })))
  documented_geographic_units <- unique(unlist(lapply(objects, function(obj) {
    documentation_geographic_units(obj, doc_text)
  })))
  auxiliary_idx <- which(vapply(seq_along(objects), function(i) {
    est_objet_spatial_auxiliaire(objects[[i]], object_names[i], doc_text)
  }, logical(1)))

  main_candidates <- unique(c(
    sf_idx, spatial_idx, spacetime_idx, sts_idx, point_pattern_idx,
    raster_idx, tabular_idx
  ))
  if (length(main_candidates) == 0) {
    main_idx <- 1L
  } else {
    scores <- vapply(main_candidates, function(i) {
      dat <- safe_attribute_data(objects[[i]])
      variable_count <- if (is.null(dat)) 0L else ncol(dat)
      object_signals <- detect_metadata_signals(
        objects[[i]],
        doc_profile,
        roles[i]
      )
      has_response <- nzchar(object_signals$candidate_y_variables)
      support_name <- grepl(
        "grid|mask|boundary|area|river|riv$|coast|outline|window",
        object_names[i],
        ignore.case = TRUE
      )
      support_role <- roles[i] %in% c(
        "prediction_domain", "geometry", "coordinates",
        "spatial_weights", "neighbor_graph", "list_auxiliary"
      )
      80L * (i %in% sf_idx) +
        50L * (i %in% spatial_idx) +
        90L * (i %in% spacetime_idx) +
        85L * (i %in% sts_idx) +
        70L * (i %in% point_pattern_idx) +
        80L * (i %in% raster_idx) +
        60L * has_response -
        90L * (support_name && !has_response) -
        80L * support_role +
        20L * (tolower(object_names[i]) == tolower(groupe)) +
        40L * grepl("(_sf|_nb)$", object_names[i], ignore.case = TRUE) +
        20L * (i %in% coordinate_idx) +
        35L * (roles[i] %in% c(
          "spatial_observations", "observation_table", "response_table"
        )) +
        variable_count
    }, integer(1))
    main_idx <- main_candidates[which.max(scores)]
  }

  main_obj <- objects[[main_idx]]
  main_name <- object_names[main_idx]
  dims <- get_object_dimensions(main_obj)
  signals <- detect_metadata_signals(main_obj, doc_profile, roles[main_idx])
  response <- trimws(unlist(strsplit(
    signals$candidate_y_variables,
    ",",
    fixed = TRUE
  )))
  response <- response[nzchar(response)]
  response <- nettoyer_reponses(response, doc_text)
  covariates <- variables_analytiques(main_obj, response)

  complementary_tables <- setdiff(tabular_idx, main_idx)
  complementary_plain_tables <- complementary_tables[
    !vapply(objects[complementary_tables], inherits, logical(1), what = "sf")
  ]
  if (inherits(main_obj, "sf") &&
      length(covariates) == 0L &&
      length(complementary_tables) > 0) {
    extra_covariates <- unique(unlist(lapply(complementary_tables, function(i) {
      variables_analytiques(objects[[i]], response)
    })))
    covariates <- unique(c(covariates, extra_covariates))
  }
  covariates <- nettoyer_covariables(covariates, response, doc_text)

  source_spatiale <- ""
  preuve <- ""
  preliminary_status <- "a_verifier"
  if (length(sf_idx) > 0) {
    source_spatiale <- paste(object_names[sf_idx], collapse = ", ")
    sf_support_only <- all(roles[sf_idx] %in% c("prediction_domain", "geometry"))
    if (!inherits(main_obj, "sf") && sf_support_only) {
      preuve <- "classe_sf_support_spatial"
      preliminary_status <- "sf_avec_auxiliaire"
    } else {
      preuve <- "classe_sf"
      preliminary_status <- if (length(complementary_plain_tables) > 0) {
        "sf_avec_jointure"
      } else {
        "deja_sf"
      }
    }
  } else if (length(spatial_idx) > 0) {
    source_spatiale <- paste(object_names[spatial_idx], collapse = ", ")
    preuve <- paste0("classe_Spatial: ", paste(classes[spatial_idx], collapse = ", "))
    preliminary_status <- "convertible_sf"
  } else if (length(spacetime_idx) > 0) {
    source_spatiale <- paste(object_names[spacetime_idx], collapse = ", ")
    preuve <- paste0(
      "classe_spacetime: ",
      paste(classes[spacetime_idx], collapse = ", ")
    )
    preliminary_status <- "convertible_sf"
  } else if (length(sts_idx) > 0) {
    source_spatiale <- paste(object_names[sts_idx], collapse = ", ")
    preuve <- paste0(
      "classe_sts_surveillance: ",
      paste(classes[sts_idx], collapse = ", ")
    )
    preliminary_status <- "convertible_sf"
  } else if (length(point_pattern_idx) > 0) {
    source_spatiale <- paste(object_names[point_pattern_idx], collapse = ", ")
    preuve <- paste0(
      "classe_point_pattern: ",
      paste(classes[point_pattern_idx], collapse = ", ")
    )
    preliminary_status <- "convertible_sf"
  } else if (length(raster_idx) > 0) {
    source_spatiale <- paste(object_names[raster_idx], collapse = ", ")
    preuve <- paste0(
      "classe_raster: ",
      paste(classes[raster_idx], collapse = ", ")
    )
    preliminary_status <- "convertible_sf"
  } else if (length(auxiliary_idx) > 0 && length(tabular_idx) > 0) {
    source_labels <- unique(unlist(lapply(auxiliary_idx, function(i) {
      nested <- list_spatial_component_names(
        objects[[i]],
        observation_n = unname(dims["n"])
      )
      if (length(nested) == 0L) {
        return(object_names[i])
      }
      paste0(object_names[i], "$", nested)
    })))
    source_spatiale <- paste(source_labels, collapse = ", ")
    nesting_depth <- lengths(strsplit(
      source_labels,
      "$",
      fixed = TRUE
    ))
    preuve <- if (any(nesting_depth >= 3L)) {
      "coordonnees_imbriquees_alignees"
    } else {
      "objet_spatial_auxiliaire_dans_le_groupe"
    }
    preliminary_status <- "sf_avec_auxiliaire"
  } else if (length(coordinate_idx) > 0) {
    coordinate_names <- unique(unlist(lapply(coordinate_idx, function(i) {
      find_coordinate_columns(names(safe_attribute_data(objects[[i]])))
    })))
    source_spatiale <- paste(coordinate_names, collapse = ", ")
    only_xy <- setequal(tolower(coordinate_names), c("x", "y"))
    documented_spatial <- grepl(
      "coordina|easting|northing|longitude|latitude|spatial|location|geograph",
      doc_text,
      ignore.case = TRUE
    )
    if (only_xy && !documented_spatial) {
      preuve <- "noms_x_y_non_confirmes_par_documentation"
      preliminary_status <- "a_verifier"
    } else {
      preuve <- "coordonnees_dans_table_principale"
      preliminary_status <- "convertible_sf"
    }
  } else if (length(geographic_axis_sources) > 0L) {
    source_spatiale <- paste(geographic_axis_sources, collapse = ", ")
    preuve <- "geographie_documentee_sur_axe_colonnes"
    preliminary_status <- "convertible_sf"
  } else if (length(geographic_name_idx) > 0) {
    geographic_columns <- unique(unlist(lapply(
      geographic_name_idx,
      function(i) {
        colonnes_geographiques_recuperables(objects[[i]], doc_text)
      }
    )))
    source_spatiale <- paste(geographic_columns, collapse = ", ")
    preuve <- "noms_geographiques_pour_jointure"
    preliminary_status <- "convertible_sf"
  } else if (length(documented_geographic_units) > 0L) {
    main_dat <- safe_attribute_data(main_obj)
    geographic_ids <- character(0)
    if (!is.null(main_dat)) {
      vars_lower <- tolower(names(main_dat))
      geographic_ids <- names(main_dat)[grepl(
        paste0(
          "town.?id|tract|census|region.?id|county.?id|state.?id|",
          "municip|commune|district.?id|province.?id|country.?id"
        ),
        vars_lower
      )]
    }
    source_spatiale <- paste0(
      "documentation:",
      paste(documented_geographic_units, collapse = ","),
      if (length(geographic_ids) > 0L) {
        paste0("; identifiers:", paste(geographic_ids, collapse = ","))
      } else {
        ""
      }
    )
    preuve <- "unites_geographiques_documentees_sans_identifiant"
    preliminary_status <- "convertible_sf"
  }

  spatial_sf <- if (preliminary_status %in% c(
    "deja_sf", "sf_avec_jointure"
  )) {
    "deja_sf"
  } else if (preliminary_status %in% c(
    "convertible_sf", "sf_avec_auxiliaire"
  )) {
    "a_convertir"
  } else {
    "exclu"
  }

  n_observations <- unname(dims["n"])
  conditions <- c(
    spatial = spatial_sf != "exclu",
    effectif = !is.na(n_observations) && n_observations >= 10L,
    covariables = length(covariates) > 0L
  )
  manual_decision <- decision_manuelle_catalogue(package, groupe)
  if (nzchar(manual_decision)) {
    retenu <- manual_decision
  } else if (startsWith(preuve, "classe_raster:")) {
    retenu <- "non_retenu"
  } else if (
    identical(preuve, "coordonnees_imbriquees_alignees") &&
      all(conditions)
  ) {
    retenu <- "a_verifier"
  } else if (
    identical(preuve, "geographie_documentee_sur_axe_colonnes") &&
      all(conditions)
  ) {
    retenu <- "a_verifier"
  } else if (
    identical(preuve, "unites_geographiques_documentees_sans_identifiant") &&
      all(conditions)
  ) {
    retenu <- "a_verifier"
  } else if (all(conditions)) {
    retenu <- "retenu"
  } else if (!conditions["effectif"]) {
    retenu <- "non_retenu"
  } else if (!conditions["spatial"] && !nzchar(source_spatiale)) {
    retenu <- "non_retenu"
  } else {
    retenu <- "a_verifier"
  }

  failed <- names(conditions)[!conditions]
  raison_selection <- if (identical(retenu, "retenu")) {
    if (nzchar(manual_decision)) {
      "Retenu apres verification manuelle."
    } else {
      "Spatialite exploitable, effectif suffisant et covariables detectees."
    }
  } else if (identical(retenu, "a_verifier")) {
    if (identical(preuve, "geographie_documentee_sur_axe_colonnes")) {
      paste(
        "Verification requise : les populations ou regions sont documentees,",
        "mais leur geometrie doit etre obtenue par geocodage ou jointure."
      )
    } else if (identical(
      preuve,
      "unites_geographiques_documentees_sans_identifiant"
    )) {
      paste(
        "Verification requise : les unites geographiques sont mentionnees",
        "dans la documentation, mais leurs identifiants doivent etre retrouves."
      )
    } else if (identical(preuve, "coordonnees_imbriquees_alignees")) {
      paste(
        "Verification requise : confirmer que les coordonnees imbriquees",
        "decrivent bien les observations analytiques."
      )
    } else {
      reasons <- c(
        spatial = "spatialite a confirmer",
        effectif = "effectif inferieur a 10",
        covariables = "covariables a confirmer dans la documentation"
      )
      paste("Verification requise :", paste(reasons[failed], collapse = "; "))
    }
  } else if (nzchar(manual_decision)) {
    "Exclu apres verification manuelle."
  } else if (startsWith(preuve, "classe_raster:")) {
    paste(
      "Raster spatial identifie, mais differe car le catalogue actuel",
      "se concentre sur les futurs objets sf."
    )
  } else {
    reasons <- c(
      spatial = "spatialite absente ou non confirmee",
      effectif = "effectif inferieur a 10",
      covariables = "aucune covariable analytique"
    )
    paste(reasons[failed], collapse = "; ")
  }

  raison_spatiale <- switch(
    preliminary_status,
    deja_sf = "Objet sf disponible.",
    sf_avec_jointure = "Objet sf et table complementaire detectes.",
    sf_avec_auxiliaire = "Table principale et support spatial auxiliaire detectes.",
    convertible_sf = if (identical(preuve, "noms_geographiques_pour_jointure")) {
      "Geometrie recuperable par jointure sur des noms geographiques."
    } else if (identical(preuve, "geographie_documentee_sur_axe_colonnes")) {
      paste(
        "Geographie documentee sur l'axe des colonnes,",
        "sans geometrie directement disponible."
      )
    } else if (identical(
      preuve,
      "unites_geographiques_documentees_sans_identifiant"
    )) {
      paste(
        "Possibilite spatiale documentee, sans identifiant geographique",
        "directement disponible dans la table."
      )
    } else {
      "Spatialite explicite convertible en objet sf."
    },
    a_verifier = "Spatialite possible, mais non confirmee.",
    "Aucun support spatial exploitable."
  )
  raison <- paste(raison_spatiale, raison_selection)

  data.frame(
    package = package,
    groupe = groupe,
    bundles = paste(rows$bundle, collapse = ", "),
    spatial_sf = spatial_sf,
    source_spatiale = source_spatiale,
    objet_principal = main_name,
    n = n_observations,
    covariables = paste(covariates, collapse = ", "),
    nombre_covariables = length(covariates),
    variable_reponse = paste(response, collapse = ", "),
    formule = ifelse(is.na(doc_profile$formula_text), "", doc_profile$formula_text),
    preuve = preuve,
    raison = raison,
    retenu = retenu,
    stringsAsFactors = FALSE
  )
}

# =============================================================================
# Audit spatial : selection des jeux convertibles ou deja disponibles en sf
# =============================================================================

construire_audit_sf_50 <- function(catalogue_bundles, n = 50L) {
  selected <- selectionner_50_groupes(catalogue_bundles, n)
  rows <- lapply(selected, function(signal) {
    auditer_groupe_sf(catalogue_bundles, signal)
  })
  audit <- do.call(rbind, rows)
  row.names(audit) <- NULL
  audit
}

construire_audit_sf_complet <- function(catalogue_bundles, verbose = TRUE) {
  groups <- unique(catalogue_bundles[, c("package", "groupe_bundle")])
  rows <- vector("list", nrow(groups))

  for (i in seq_len(nrow(groups))) {
    if (isTRUE(verbose) && (i == 1L || i %% 25L == 0L || i == nrow(groups))) {
      cat("Audit des groupes :", i, "/", nrow(groups), "\n")
    }
    signal <- resumer_signaux_groupe(
      catalogue_bundles,
      groups$package[i],
      groups$groupe_bundle[i]
    )
    rows[[i]] <- auditer_groupe_sf(catalogue_bundles, signal)
  }

  audit <- do.call(rbind, rows)
  row.names(audit) <- NULL
  audit
}

# =============================================================================
# Catalogue ML tabulaire des jeux non retenus pour le catalogue spatial
# =============================================================================

compter_elements_liste_texte <- function(x) {
  if (is.na(x) || !nzchar(x)) {
    return(0L)
  }
  length(trimws(unlist(strsplit(x, ",", fixed = TRUE))))
}

classer_candidat_ml <- function(row) {
  n <- suppressWarnings(as.integer(row$n))
  nb_x <- suppressWarnings(as.integer(row$nombre_covariables))
  has_y <- !is.na(row$variable_reponse) && nzchar(row$variable_reponse)
  has_formula <- !is.na(row$formule) && nzchar(row$formule)
  reason <- tolower(paste(row$raison, row$preuve, row$source_spatiale))

  if (!identical(row$retenu, "non_retenu")) {
    return(list(
      ml_statut = "hors_champ",
      ml_type = "",
      ml_raison = "Deja retenu ou a verifier dans le catalogue spatial."
    ))
  }

  spatial_only <- grepl(
    paste0(
      "support spatial|zone d.etude|study_area|study_mask|mask|",
      "matrice|poids|weights|adjacency|voisinage|boundary|raster|",
      "point_pattern|ppp|lpp|owin|geometry"
    ),
    reason,
    ignore.case = TRUE
  )
  if (isTRUE(spatial_only) && (is.na(nb_x) || nb_x < 2L)) {
    return(list(
      ml_statut = "non_ml",
      ml_type = "",
      ml_raison = "Objet surtout spatial/auxiliaire, sans matrice tabulaire analytique suffisante."
    ))
  }

  if (is.na(n) || n < 30L) {
    return(list(
      ml_statut = "non_ml",
      ml_type = "",
      ml_raison = "Effectif trop faible pour un usage ML general."
    ))
  }

  if (is.na(nb_x) || nb_x < 2L) {
    return(list(
      ml_statut = "non_ml",
      ml_type = "",
      ml_raison = "Pas assez de covariables exploitables pour du ML tabulaire."
    ))
  }

  if (has_y || has_formula) {
    return(list(
      ml_statut = "retenu_ml",
      ml_type = "supervise",
      ml_raison = "Table non retenue spatialement, mais exploitable en ML supervise : reponse et covariables detectees."
    ))
  }

  if (nb_x >= 5L) {
    return(list(
      ml_statut = "a_verifier_ml",
      ml_type = "non_supervise_ou_reponse_a_definir",
      ml_raison = "Table riche en variables, utilisable pour clustering/reduction de dimension ou avec une reponse a definir manuellement."
    ))
  }

  list(
    ml_statut = "non_ml",
    ml_type = "",
    ml_raison = "Pas de variable reponse detectee et trop peu de variables pour un bon candidat ML."
  )
}

construire_catalogue_ml <- function(catalogue_selection_complete) {
  if (nrow(catalogue_selection_complete) == 0L) {
    return(catalogue_selection_complete)
  }

  ml_info <- lapply(seq_len(nrow(catalogue_selection_complete)), function(i) {
    classer_candidat_ml(catalogue_selection_complete[i, , drop = FALSE])
  })

  catalogue_ml_prepare <- catalogue_selection_complete
  catalogue_ml_prepare$ml_statut <- vapply(ml_info, `[[`, character(1), "ml_statut")
  catalogue_ml_prepare$ml_type <- vapply(ml_info, `[[`, character(1), "ml_type")
  catalogue_ml_prepare$ml_raison <- vapply(ml_info, `[[`, character(1), "ml_raison")

  catalogue_ml <- catalogue_ml_prepare[
    catalogue_ml_prepare$ml_statut %in% c("retenu_ml", "a_verifier_ml"),
    ,
    drop = FALSE
  ]
  row.names(catalogue_ml) <- NULL
  catalogue_ml
}

# =============================================================================
# Ecriture des catalogues RData
# =============================================================================

ecrire_catalogues_selection <- function(catalogue_bundles,
                                         catalogue_selection_complete) {
  manifest_dir <- file.path(
    find_repo_root(),
    "data",
    "manifests",
    "datasets"
  )
  full_path <- file.path(
    manifest_dir,
    "catalogue_datasets_selection_complete.RData"
  )
  retained_path <- file.path(
    manifest_dir,
    "catalogue_datasets_retenus.RData"
  )
  ml_path <- file.path(
    manifest_dir,
    "catalogue_datasets_ml.RData"
  )
  catalogue_preparation_sf <- catalogue_selection_complete
  catalogue_datasets_retenus <- catalogue_selection_complete[
    catalogue_selection_complete$retenu == "retenu",
    ,
    drop = FALSE
  ]
  row.names(catalogue_datasets_retenus) <- NULL
  catalogue_datasets_ml <- construire_catalogue_ml(catalogue_selection_complete)

  save(
    catalogue_bundles,
    catalogue_preparation_sf,
    catalogue_selection_complete,
    catalogue_datasets_retenus,
    catalogue_datasets_ml,
    file = full_path,
    compress = "gzip"
  )
  save(
    catalogue_datasets_retenus,
    file = retained_path,
    compress = "gzip"
  )
  save(
    catalogue_datasets_ml,
    file = ml_path,
    compress = "gzip"
  )

  invisible(list(
    complet = full_path,
    retenus = retained_path,
    ml = ml_path,
    nombre_complet = nrow(catalogue_selection_complete),
    nombre_retenu = nrow(catalogue_datasets_retenus),
    nombre_ml = nrow(catalogue_datasets_ml)
  ))
}

# =============================================================================
# Fonctions utilisateur : generation, affichage et consultation
# =============================================================================

auditer_catalogue_sf <- function(
  regenerer = TRUE,
  n = NULL,
  afficher = TRUE,
  ouvrir_view = interactive(),
  verbose = TRUE
) {
  output_path <- file.path(
    find_repo_root(),
    "data",
    "manifests",
    "datasets",
    "catalogue_datasets_selection_complete.RData"
  )
  catalogue_bundles <- consulter_catalogue(afficher = FALSE)

  if (isTRUE(regenerer)) {
    catalogue_preparation_sf <- if (is.null(n)) {
      construire_audit_sf_complet(catalogue_bundles, verbose = verbose)
    } else {
      construire_audit_sf_50(catalogue_bundles, n)
    }
    ecrire_catalogues_selection(
      catalogue_bundles,
      catalogue_preparation_sf
    )
  } else {
    e <- new.env(parent = emptyenv())
    load(output_path, envir = e)
    if (!exists("catalogue_preparation_sf", envir = e, inherits = FALSE)) {
      stop(
        "Catalogue de selection absent. Lance generer_catalogues_selection().",
        call. = FALSE
      )
    }
    catalogue_preparation_sf <- e$catalogue_preparation_sf
  }

  assign(
    "catalogue_preparation_sf",
    catalogue_preparation_sf,
    envir = .GlobalEnv
  )
  catalogue_datasets_retenus <- catalogue_preparation_sf[
    catalogue_preparation_sf$retenu == "retenu",
    ,
    drop = FALSE
  ]
  catalogue_datasets_ml <- construire_catalogue_ml(catalogue_preparation_sf)
  assign(
    "catalogue_datasets_retenus",
    catalogue_datasets_retenus,
    envir = .GlobalEnv
  )
  assign(
    "catalogue_datasets_ml",
    catalogue_datasets_ml,
    envir = .GlobalEnv
  )

  if (isTRUE(afficher)) {
    cat("Groupes audites :", nrow(catalogue_preparation_sf), "\n")
    cat("Groupes retenus :", nrow(catalogue_datasets_retenus), "\n")
    cat("Groupes ML tabulaire :", nrow(catalogue_datasets_ml), "\n")
    cat("Objet disponible : catalogue_preparation_sf\n")
    cat("Objet disponible : catalogue_datasets_retenus\n")
    cat("Objet disponible : catalogue_datasets_ml\n")
    cat("Repartition spatiale :\n")
    print(table(catalogue_preparation_sf$spatial_sf))
    cat("Decision finale :\n")
    print(table(catalogue_preparation_sf$retenu))
    cat("Decision ML :\n")
    print(table(catalogue_datasets_ml$ml_statut))
  }

  if (isTRUE(ouvrir_view)) {
    if (interactive()) {
      utils::View(
        catalogue_preparation_sf,
        title = "Audit spatial des bundles R"
      )
    } else {
      message(
        "View() est disponible dans une session R interactive ou RStudio."
      )
    }
  }

  invisible(catalogue_preparation_sf)
}

voir_audit_sf <- function(regenerer = FALSE, n = NULL) {
  auditer_catalogue_sf(
    regenerer = regenerer,
    n = n,
    afficher = TRUE,
    ouvrir_view = TRUE
  )
}

voir_catalogue_retenu <- function() {
  auditer_catalogue_sf(
    regenerer = FALSE,
    afficher = FALSE,
    ouvrir_view = FALSE
  )
  if (interactive()) {
    utils::View(
      catalogue_datasets_retenus,
      title = "Catalogue des bundles R retenus"
    )
  }
  invisible(catalogue_datasets_retenus)
}

voir_catalogue_ml <- function() {
  auditer_catalogue_sf(
    regenerer = FALSE,
    afficher = FALSE,
    ouvrir_view = FALSE
  )
  if (interactive()) {
    utils::View(
      catalogue_datasets_ml,
      title = "Catalogue ML tabulaire des bundles R non retenus spatialement"
    )
  }
  invisible(catalogue_datasets_ml)
}

generer_catalogues_selection <- function(regenerer_inventaire = FALSE,
                                          ouvrir_view = interactive(),
                                          verbose = TRUE) {
  if (isTRUE(regenerer_inventaire)) {
    main(write_output = TRUE, verbose = verbose)
  }
  auditer_catalogue_sf(
    regenerer = TRUE,
    n = NULL,
    afficher = TRUE,
    ouvrir_view = ouvrir_view,
    verbose = verbose
  )
}

normalise_catalog_key <- function(x) {
  x <- iconv(as.character(x), from = "", to = "ASCII//TRANSLIT")
  x[is.na(x)] <- ""
  x <- tolower(x)
  gsub("[^a-z0-9]+", "", x)
}

add_analytical_group_fields <- function(catalog) {
  if (nrow(catalog) == 0) {
    return(catalog)
  }

  first_doi <- sub("\\s*\\|.*$", "", catalog$paper_doi)
  has_doi <- nzchar(first_doi)
  catalog$analytical_group <- ifelse(
    has_doi,
    paste(catalog$package, first_doi, sep = "::paper::"),
    paste(catalog$package, catalog$bundle, sep = "::bundle::")
  )
  catalog$linked_datasets <- ""
  catalog$group_has_y <- "No"
  catalog$group_y_variables <- ""
  catalog$group_x_variables <- ""

  for (group in unique(catalog$analytical_group)) {
    idx <- which(catalog$analytical_group == group)
    related <- unlist(strsplit(catalog$paper_related_datasets[idx], ",", fixed = TRUE))
    related <- collapse_names(c(trimws(related), catalog$bundle[idx]))
    catalog$linked_datasets[idx] <- related
    y <- unlist(strsplit(catalog$candidate_y_variables[idx], ",", fixed = TRUE))
    x <- unlist(strsplit(catalog$candidate_x_variables[idx], ",", fixed = TRUE))
    y <- collapse_names(trimws(y))
    x <- collapse_names(trimws(x))
    catalog$group_has_y[idx] <- yes_no(nzchar(y))
    catalog$group_y_variables[idx] <- y
    catalog$group_x_variables[idx] <- x
  }

  catalog
}

add_duplicate_fields <- function(catalog) {
  # Marque les doublons probables sans supprimer de ligne. La priorite revient
  # au package dont la ligne cumule le plus de documentation et de variables.
  if (nrow(catalog) == 0) {
    return(catalog)
  }

  object_key <- normalise_catalog_key(catalog$main_object)
  title_key <- normalise_catalog_key(catalog$description_bundle)
  catalog$duplicate_key <- paste(object_key, title_key, sep = "::")

  nonempty <- function(x) !is.na(x) & nzchar(trimws(as.character(x)))
  variable_count <- vapply(strsplit(catalog$variables, ",", fixed = TRUE), function(x) {
    sum(nzchar(trimws(x)))
  }, integer(1))
  catalog$information_score <-
    pmin(variable_count, 20L) +
    4L * nonempty(catalog$source) +
    4L * nonempty(catalog$formula_text) +
    5L * nonempty(catalog$paper_formula_or_equation) +
    3L * nonempty(catalog$paper_title) +
    2L * (catalog$has_y == "Yes") +
    2L * (catalog$has_geometry == "Yes")

  catalog$duplicate_status <- "unique"
  catalog$preferred_package <- catalog$package
  catalog$duplicate_reason <- ""

  for (key in unique(catalog$duplicate_key)) {
    idx <- which(catalog$duplicate_key == key)
    packages <- unique(catalog$package[idx])
    if (!nzchar(key) || length(idx) < 2L || length(packages) < 2L) {
      next
    }
    preferred <- idx[which.max(catalog$information_score[idx])]
    catalog$preferred_package[idx] <- catalog$package[preferred]
    catalog$duplicate_status[idx] <- "duplicate_lower_information"
    catalog$duplicate_status[preferred] <- "preferred_duplicate"
    catalog$duplicate_reason[idx] <- paste0(
      "Same normalized object and dataset title; preferred information score=",
      catalog$information_score[preferred]
    )
  }

  catalog
}

prepare_main_catalog_output <- function(catalog) {
  # Le CSV final garde les preuves utiles a la curation. Les booleens
  # redondants sont omis lorsque la colonne detaillee suffit.
  drop_columns <- c(
    "has_y",
    "has_datetime",
    "preferred_package",
    "duplicate_reason",
    "information_score",
    "paper_abstract"
  )
  catalog[, setdiff(names(catalog), drop_columns), drop = FALSE]
}

classer_catalogue_analytique <- function(catalog) {
  # Applique une regle commune aux catalogues R et Python. `k` designe ici le
  # nombre de variables analytiques apres retrait des identifiants, dates,
  # coordonnees et geometries.
  if (nrow(catalog) == 0L) {
    catalog$final_category <- character(0)
    return(catalog)
  }

  k <- suppressWarnings(as.integer(catalog$k))
  k[is.na(k)] <- 0L
  spatial <- catalog$has_geometry == "Yes" |
    catalog$has_coordinates == "Yes" |
    catalog$has_place_name_if_no_geometry == "Yes"

  catalog$final_category <- ifelse(
    spatial & k >= 5L,
    "Bons candidats spatial",
    ifelse(
      spatial & k >= 1L,
      "Spatial simple",
      ifelse(!spatial & k >= 3L, "ML non spatial", "Declasser auxiliaire")
    )
  )
  catalog
}

save_rdata_atomic <- function(object_names, envir, path, compress = "xz") {
  temporary <- paste0(path, ".tmp-", Sys.getpid())
  on.exit(unlink(temporary, force = TRUE), add = TRUE)
  save(
    list = object_names,
    envir = envir,
    file = temporary,
    compress = compress
  )
  if (!file.copy(temporary, path, overwrite = TRUE)) {
    stop("Impossible de remplacer le fichier RData : ", path, call. = FALSE)
  }
  invisible(path)
}

write_r_classified_catalogs <- function(catalog_r,
                                        manifest_dir = file.path(
                                          "data", "manifests", "datasets"
                                        )) {
  dir.create(manifest_dir, recursive = TRUE, showWarnings = FALSE)
  catalogue_r_complet <- classer_catalogue_analytique(catalog_r)
  catalogue_r_bons_candidats_spatiaux <- catalogue_r_complet[
    catalogue_r_complet$final_category == "Bons candidats spatial",
    , drop = FALSE
  ]
  catalogue_r_spatial_simple <- catalogue_r_complet[
    catalogue_r_complet$final_category == "Spatial simple",
    , drop = FALSE
  ]
  catalogue_r_ml_non_spatial <- catalogue_r_complet[
    catalogue_r_complet$final_category == "ML non spatial",
    , drop = FALSE
  ]

  save_rdata_atomic(
    c(
      "catalogue_r_complet",
      "catalogue_r_bons_candidats_spatiaux",
      "catalogue_r_spatial_simple",
      "catalogue_r_ml_non_spatial"
    ),
    environment(),
    file.path(manifest_dir, "software_r_catalog_classified.RData")
  )
  save_rdata_atomic(
    "catalogue_r_bons_candidats_spatiaux",
    environment(),
    file.path(manifest_dir, "catalogue_r_bons_candidats_spatiaux.RData")
  )
  save_rdata_atomic(
    "catalogue_r_spatial_simple",
    environment(),
    file.path(manifest_dir, "catalogue_r_spatial_simple.RData")
  )
  save_rdata_atomic(
    "catalogue_r_ml_non_spatial",
    environment(),
    file.path(manifest_dir, "catalogue_r_ml_non_spatial.RData")
  )

  invisible(catalogue_r_complet)
}

prepare_auxiliary_catalog_output <- function(bundle_profiles) {
  if (nrow(bundle_profiles) == 0) {
    return(bundle_profiles)
  }
  auxiliary <- bundle_profiles[
    bundle_profiles$keep != "yes",
    ,
    drop = FALSE
  ]
  keep_columns <- c(
    "package",
    "bundle",
    "object",
    "role",
    "keep",
    "class",
    "n",
    "k",
    "variables",
    "doc_has_rd",
    "formula_response",
    "formula_predictors",
    "formula_text",
    "has_referenced_paper",
    "paper_doi",
    "paper_title",
    "paper_use_summary",
    "paper_formula_or_equation",
    "paper_variables_used",
    "paper_related_datasets"
  )
  auxiliary[, intersect(keep_columns, names(auxiliary)), drop = FALSE]
}

catalog_main_datasets_from_packages <- function(packages = software_r_packages,
                                                install_missing = FALSE,
                                                verbose = TRUE) {
  # Parcourt les packages R listes et construit un data.frame des objets
  # identifies comme jeux de donnees principaux par guess_object_role().
  rows <- list()
  bundle_profile_rows <- list()
  auxiliary_link_rows <- list()
  documentation_rows <- list()
  package_documentation_rows <- list()
  paper_audit <- read_paper_audit()

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

    package_documentation_rows[[length(package_documentation_rows) + 1]] <-
      get_package_documentation_sites(pkg)

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
      if (verbose) {
        cat("  Dataset :", bundle, "\n")
      }
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

      doc_text <- get_dataset_documentation_text(pkg, bundle)
      description_bundle <- entries$title[entries$bundle == bundle][1]
      source <- extract_doc_section(doc_text, "Source")
      doc_profile <- extract_documentation_profile(pkg, bundle, doc_text)
      paper_evidence <- paper_evidence_for_dataset(
        paper_audit,
        pkg,
        bundle,
        doc_profile
      )

      curation <- do.call(rbind, lapply(objects, function(obj_name) {
        obj <- e[[obj_name]]
        role <- guess_object_role(obj, obj_name, bundle, doc_text)
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

      documentation_rows[[length(documentation_rows) + 1]] <- cbind(
        doc_profile,
        get_dataset_documentation_links(pkg, bundle)[, c("cran_topic", "rdrr_topic")],
        paper_evidence
      )
      bundle_profile_rows <- c(
        bundle_profile_rows,
        build_bundle_profile_rows(
          pkg,
          bundle,
          objects,
          e,
          curation,
          doc_profile,
          paper_evidence
        )
      )
      auxiliary_link_rows <- c(
        auxiliary_link_rows,
        build_auxiliary_link_rows(pkg, bundle, main_objects, auxiliary_objects, e, curation)
      )

      if (length(main_objects) == 0) {
        next
      }

      for (main_object in main_objects) {
        obj <- e[[main_object]]
        dims <- get_object_dimensions(obj)
        variables <- get_object_variables(obj)
        role <- curation$role[curation$object == main_object][1]
        metadata_signals <- detect_metadata_signals(obj, doc_profile, role)
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
          k = metadata_signals$analytical_variable_count,
          analytical_variables = metadata_signals$analytical_variables,
          identifier_variables = metadata_signals$identifier_variables,
          has_geometry = metadata_signals$has_geometry,
          has_coordinates = metadata_signals$has_coordinates,
          coordinate_columns = metadata_signals$coordinate_columns,
          has_multiple_x = metadata_signals$has_multiple_x,
          candidate_x_variables = metadata_signals$candidate_x_variables,
          has_y = metadata_signals$has_y,
          candidate_y_variables = metadata_signals$candidate_y_variables,
          target_status = metadata_signals$target_status,
          formula_text = metadata_signals$formula_text,
          has_referenced_paper = paper_evidence$has_referenced_paper,
          paper_doi = paper_evidence$paper_doi,
          paper_title = paper_evidence$paper_title,
          paper_abstract = paper_evidence$paper_abstract,
          paper_use_summary = paper_evidence$paper_use_summary,
          paper_model_keywords = paper_evidence$paper_model_keywords,
          paper_formula_or_equation = paper_evidence$paper_formula_or_equation,
          paper_variables_used = paper_evidence$paper_variables_used,
          paper_related_datasets = paper_evidence$paper_related_datasets,
          paper_reference_evidence = paper_evidence$paper_reference_evidence,
          paper_evidence_status = paper_evidence$paper_evidence_status,
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
    return(list(
      catalog = data.frame(),
      bundle_profiles = data.frame(),
      auxiliary_links = data.frame(),
      documentation_profiles = data.frame(),
      package_documentation_sites = data.frame()
    ))
  }

  catalog <- do.call(rbind, rows)
  row.names(catalog) <- NULL
  catalog <- add_analytical_group_fields(catalog)
  catalog <- add_duplicate_fields(catalog)

  list(
    catalog = catalog,
    bundle_profiles = if (length(bundle_profile_rows) == 0) data.frame() else do.call(rbind, bundle_profile_rows),
    auxiliary_links = if (length(auxiliary_link_rows) == 0) data.frame() else do.call(rbind, auxiliary_link_rows),
    documentation_profiles = if (length(documentation_rows) == 0) data.frame() else do.call(rbind, documentation_rows),
    package_documentation_sites = if (length(package_documentation_rows) == 0) data.frame() else do.call(rbind, package_documentation_rows)
  )
}

write_catalog_outputs <- function(pipeline_outputs, write_csv = FALSE) {
  safe_write_csv2 <- function(data, path) {
    tryCatch({
      write.csv2(
        data,
        file = path,
        row.names = FALSE,
        fileEncoding = "UTF-8"
      )
      TRUE
    }, error = function(err) {
      warning(
        "Sortie non ecrite (fichier probablement verrouille) : ",
        path,
        " - ",
        conditionMessage(err),
        call. = FALSE
      )
      FALSE
    })
  }

  catalog_r <- prepare_main_catalog_output(pipeline_outputs$catalog)
  catalog_r <- classer_catalogue_analytique(catalog_r)
  output_path <- file.path(
    "data",
    "manifests",
    "datasets",
    "software_r_catalog_classified.RData"
  )
  write_r_classified_catalogs(catalog_r)

  cat("\nCatalogue RData ecrit : ", output_path, "\n", sep = "")
  cat("Nombre de lignes :", nrow(catalog_r), "\n")
  cat("Nombre de colonnes :", ncol(catalog_r), "\n")

  if (isTRUE(write_csv)) {
    csv_path <- file.path(
      "data", "manifests", "datasets", "software_r_catalog_main_datasets.csv"
    )
    safe_write_csv2(catalog_r, csv_path)
  }

  invisible(output_path)
}

main_detailed_catalog <- function(packages = software_r_packages,
                                  write_outputs = TRUE,
                                  write_csv = FALSE,
                                  verbose = TRUE) {
  pipeline_outputs <- catalog_main_datasets_from_packages(
    packages = packages,
    install_missing = FALSE,
    verbose = verbose
  )
  if (isTRUE(write_outputs)) {
    write_catalog_outputs(pipeline_outputs, write_csv = write_csv)
  }
  invisible(pipeline_outputs)
}

main <- function(packages = software_r_packages, write_output = TRUE, verbose = TRUE) {
  catalogue_bundles <- catalog_bundles_from_packages(
    packages = packages,
    install_missing = FALSE,
    verbose = verbose
  )

  if (isTRUE(write_output)) {
    write_bundle_catalog_rdata(catalogue_bundles)
  }

  invisible(catalogue_bundles)
}

if (sys.nframe() == 0 && !interactive()) {
  main()
}
