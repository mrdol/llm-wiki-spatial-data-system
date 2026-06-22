# Convertit la documentation Rd des packages R en Markdown.
#
# Utilisation depuis la racine du depot llm-wiki-karpathy :
# Rscript Code_scrapping/r_catalog/render_r_dataset_rd_docs.R --package spDataLarge
# Rscript Code_scrapping/r_catalog/render_r_dataset_rd_docs.R --package spData --package spDataLarge
# Rscript Code_scrapping/r_catalog/render_r_dataset_rd_docs.R --package spDataLarge --dataset lsl
#
# Sorties :
# - wiki/datasets/r_package_docs/<package>/<package>.md
# - wiki/datasets/r_package_docs/<package>/refman.md
# - wiki/datasets/r_package_docs/<package>/topics/<topic>.md
# - data/manifests/datasets/software_r_rd_documentation_index.csv

script_file <- tryCatch({
  normalizePath(sys.frame(1)$ofile, winslash = "/", mustWork = TRUE)
}, error = function(err) {
  NA_character_
})

find_repo_root <- function(start = getwd()) {
  # Retrouve la racine du depot pour que le script fonctionne depuis
  # llm-wiki-karpathy, son dossier parent, ou apres source() avec un chemin absolu.
  candidates <- c(start)
  if (!is.na(script_file)) {
    candidates <- c(candidates, dirname(script_file))
  }

  for (candidate in candidates) {
    current <- normalizePath(candidate, winslash = "/", mustWork = TRUE)

    while (dirname(current) != current) {
      if (basename(current) == "llm-wiki-karpathy") {
        return(current)
      }

      nested <- file.path(current, "llm-wiki-karpathy")
      if (dir.exists(nested)) {
        return(normalizePath(nested, winslash = "/", mustWork = TRUE))
      }

      current <- dirname(current)
    }
  }

  stop("Lance ce script depuis llm-wiki-karpathy ou son dossier parent.", call. = FALSE)
}

default_r_package_docs_dir <- function() {
  # Repertoire fixe des documentations package/dataset dans le wiki.
  # Les fonctions render_* ecrivent ici par defaut, quel que soit getwd().
  file.path(find_repo_root(), "wiki", "datasets", "r_package_docs")
}

resolve_output_dir <- function(output_dir = NULL) {
  # Convertit un repertoire de sortie optionnel en chemin absolu.
  # Si rien n'est donne, on utilise toujours le repertoire fixe du wiki.
  repo_root <- find_repo_root()

  if (is.null(output_dir) || !nzchar(output_dir)) {
    return(default_r_package_docs_dir())
  }

  if (grepl("^([A-Za-z]:|/)", output_dir)) {
    return(normalizePath(output_dir, winslash = "/", mustWork = FALSE))
  }

  normalizePath(file.path(repo_root, output_dir), winslash = "/", mustWork = FALSE)
}

parse_args <- function(args = commandArgs(trailingOnly = TRUE)) {
  # Petit parseur d'arguments sans dependance externe.
  out <- list(
    packages = character(0),
    datasets = character(0),
    output_dir = NULL,
    render_refman = TRUE,
    render_package_help = TRUE
  )

  i <- 1L
  while (i <= length(args)) {
    key <- args[[i]]

    if (key == "--no-refman") {
      out$render_refman <- FALSE
      i <- i + 1L
      next
    }

    if (key == "--no-package-help") {
      out$render_package_help <- FALSE
      i <- i + 1L
      next
    }

    if (i == length(args)) {
      stop("Argument sans valeur : ", key, call. = FALSE)
    }

    value <- args[[i + 1L]]

    if (key == "--package") out$packages <- c(out$packages, value)
    if (key == "--dataset") out$datasets <- c(out$datasets, value)
    if (key == "--output-dir") out$output_dir <- value

    i <- i + 2L
  }

  if (length(out$packages) == 0) {
    stop("Indique au moins un --package, par exemple --package spDataLarge.", call. = FALSE)
  }

  out
}

safe_filename <- function(x) {
  # Produit un nom de fichier stable pour Windows et Git.
  x <- gsub("[^A-Za-z0-9_.-]+", "_", x)
  x <- gsub("_+", "_", x)
  trimws(x, whitespace = "_")
}

ensure_namespace <- function(pkg) {
  # Verifie qu'un package R est disponible sans l'installer automatiquement.
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(
      "Package R indisponible : ", pkg,
      ". Installe-le d'abord avec install.packages(\"", pkg, "\").",
      call. = FALSE
    )
  }
}

rd_to_markdown <- function(rd) {
  # Convertit un objet Rd en Markdown si Rd2md est disponible.
  # Sinon, on bascule vers un texte brut Rd2txt pour ne pas bloquer le pipeline.
  if (requireNamespace("Rd2md", quietly = TRUE) &&
      "as_markdown" %in% getNamespaceExports("Rd2md")) {
    return(paste(Rd2md::as_markdown(rd), collapse = "\n"))
  }

  if (requireNamespace("Rd2md", quietly = TRUE) &&
      "Rd2markdown" %in% getNamespaceExports("Rd2md")) {
    tmp <- tempfile(fileext = ".md")
    Rd2md::Rd2markdown(rd, outfile = tmp)
    md <- readLines(tmp, warn = FALSE, encoding = "UTF-8")
    unlink(tmp)
    return(paste(md, collapse = "\n"))
  }

  paste(capture.output(tools::Rd2txt(rd)), collapse = "\n")
}

clean_rd2txt_lines <- function(lines) {
  # Nettoie la sortie texte produite par tools::Rd2txt().
  # Rd2txt utilise parfois des caracteres de surlignage console comme "_\b" ;
  # on les retire pour obtenir un texte proche de RDocumentation.
  lines <- gsub("_\b", "", lines, fixed = TRUE)
  lines <- gsub("\b", "", lines, fixed = TRUE)
  lines <- gsub("[[:space:]]+$", "", lines)

  section_headers <- c(
    "Description", "Usage", "Arguments", "Format", "Details",
    "Source", "References", "See Also", "Examples"
  )
  for (section in section_headers) {
    lines <- sub(paste0("^", section, ":$"), section, lines)
  }

  out <- character(0)
  blank_count <- 0L
  for (line in lines) {
    if (!nzchar(line)) {
      blank_count <- blank_count + 1L
      if (blank_count <= 1L) {
        out <- c(out, line)
      }
    } else {
      blank_count <- 0L
      out <- c(out, line)
    }
  }

  out
}

load_dataset_object <- function(pkg, topic, object_name) {
  # Charge le bundle du dataset dans un environnement isole.
  # Pour une page comme "LO_nb (house)", topic = "house" et object_name = "LO_nb".
  e <- new.env(parent = emptyenv())
  ok <- tryCatch({
    data(list = topic, package = pkg, envir = e)
    TRUE
  }, error = function(err) {
    FALSE
  })

  if (!ok) {
    return(NULL)
  }

  if (object_name %in% ls(e)) {
    return(e[[object_name]])
  }

  if (topic %in% ls(e)) {
    return(e[[topic]])
  }

  objects <- ls(e)
  if (length(objects) == 0) {
    return(NULL)
  }

  e[[objects[[1]]]]
}

object_as_data_frame <- function(obj) {
  # Transforme les objets courants de datasets spatiaux en table attributaire.
  # Cela permet de lister les variables meme quand la section Rd Format est pauvre.
  if (is.null(obj)) {
    return(NULL)
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

  NULL
}

describe_dataset_variables <- function(pkg, topic, object_name) {
  # Decrit les variables observees dans l'objet R installe.
  # On ne peut pas inventer les descriptions semantiques absentes du Rd, mais
  # on peut au moins fournir nom, classe, nombre de valeurs manquantes et exemple.
  obj <- load_dataset_object(pkg, topic, object_name)
  dat <- object_as_data_frame(obj)

  if (is.null(dat)) {
    return(character(0))
  }

  lines <- c(
    "",
    "Variables detected from installed object",
    ""
  )

  for (variable in names(dat)) {
    col <- dat[[variable]]
    class_text <- paste(class(col), collapse = "/")
    missing_count <- sum(is.na(col))

    # Ne jamais afficher d'exemples pour les colonnes geometriques ou les
    # objets complexes : une geometrie sf peut contenir des milliers de
    # coordonnees et rendre le fichier illisible.
    show_examples <- !(
      inherits(col, "sfc") ||
        inherits(col, "sfg") ||
        is.list(col) ||
        is.matrix(col) ||
        grepl("^geometry$", variable, ignore.case = TRUE)
    )

    example <- ""
    if (show_examples) {
      example <- tryCatch({
        values <- unique(utils::head(stats::na.omit(as.character(col)), 3))
        paste(values, collapse = ", ")
      }, error = function(err) {
        ""
      })
    }

    if (nzchar(example)) {
      lines <- c(
        lines,
        paste0(variable, ": ", class_text, " ; missing=", missing_count, " ; examples=", example),
        ""
      )
    } else {
      lines <- c(
        lines,
        paste0(variable, ": ", class_text, " ; missing=", missing_count),
        ""
      )
    }
  }

  lines
}

format_section_has_variables <- function(body, variable_names) {
  # Evite de recréer les descriptions de variables si la section Format du Rd
  # contient deja des lignes comme :
  # GEOID: character vector...
  # NAME: character vector...
  # AREA: area in square kilometers...
  # geometry: sfc_MULTIPOLYGON
  #
  # Dans ce cas, la documentation officielle est meilleure que notre detection
  # automatique, donc on la conserve telle quelle.
  format_start <- which(body == "Format")
  if (length(format_start) == 0) {
    return(FALSE)
  }

  section_headers <- c(
    "Description", "Usage", "Arguments", "Format", "Details",
    "Source", "References", "See Also", "Examples"
  )
  possible_end <- which(seq_along(body) > format_start[[1]] & body %in% section_headers)
  format_end <- if (length(possible_end) == 0) length(body) else possible_end[[1]] - 1L
  format_lines <- body[format_start[[1]]:format_end]

  variable_patterns <- paste0("^\\s*", gsub("([.])", "\\\\\\1", variable_names), "\\s*:")
  matches <- vapply(variable_patterns, function(pattern) {
    any(grepl(pattern, format_lines, ignore.case = FALSE, perl = TRUE))
  }, logical(1))

  sum(matches, na.rm = TRUE) >= 2
}

rd_to_rdocumentation_text <- function(pkg, topic, object_name, title, rd) {
  # Produit une page texte/Markdown au style RDocumentation.
  # C'est ce format qui est le plus utile pour relire les datasets :
  # package + version, nom du topic, sections Description/Usage/Format/Examples.
  version <- tryCatch({
    as.character(utils::packageVersion(pkg))
  }, error = function(err) {
    NA_character_
  })

  body <- clean_rd2txt_lines(capture.output(tools::Rd2txt(rd)))
  variable_lines <- describe_dataset_variables(pkg, topic, object_name)

  if (length(body) == 0 || !grepl(topic, body[[1]], fixed = TRUE)) {
    body <- c(paste0(topic, ": ", title), "", body)
  }

  # On ajoute les variables detectees uniquement si la section Format ne les
  # documente pas deja. Le but est de completer les docs pauvres, pas de
  # dupliquer une doc RDocumentation deja precise.
  variable_names <- character(0)
  if (length(variable_lines) > 0) {
    variable_names <- sub(":.*$", "", variable_lines[grepl(":", variable_lines, fixed = TRUE)])
  }
  format_already_detailed <- length(variable_names) > 0 &&
    format_section_has_variables(body, variable_names)

  format_section <- which(body == "Format")
  examples_section <- which(body == "Examples")
  if (!format_already_detailed && length(variable_lines) > 0 && length(format_section) > 0) {
    insert_after <- if (length(examples_section) > 0) examples_section[[1]] - 1L else length(body)
    body <- append(body, variable_lines, after = insert_after)
  } else if (!format_already_detailed && length(variable_lines) > 0) {
    body <- c(body, variable_lines)
  }

  examples <- which(body == "Examples")
  if (length(examples) > 0) {
    insert_at <- examples[[1]] + 1L
    body <- append(body, "Run this code", after = insert_at - 1L)
  }

  header <- c(
    "Rdocumentation",
    "powered by",
    "",
    "Search all packages and functions",
    paste0(pkg, " (version ", version, ")"),
    ""
  )

  paste(c(header, body), collapse = "\n")
}

render_package_refman <- function(pkg, output_file) {
  # Cree un manuel Markdown complet du package.
  # Rd2md::render_refman() rend generalement toutes les pages d'aide du package :
  # fonctions, classes, methodes, datasets et pages internes documentees.
  dir.create(dirname(output_file), recursive = TRUE, showWarnings = FALSE)

  if (requireNamespace("Rd2md", quietly = TRUE) &&
      "render_refman" %in% getNamespaceExports("Rd2md")) {
    Rd2md::render_refman(pkg, output_file)
    return(TRUE)
  }

  return(FALSE)
}

package_description_markdown <- function(pkg) {
  # Rend les metadonnees DESCRIPTION du package dans une forme lisible.
  desc <- utils::packageDescription(pkg)
  fields <- c(
    "Package", "Title", "Version", "Date", "Description", "Authors@R",
    "Author", "Maintainer", "Depends", "Imports", "Suggests", "License",
    "URL", "BugReports"
  )

  lines <- c(
    paste0("# ", pkg, " package help"),
    "",
    "## Package Description",
    ""
  )

  for (field in fields) {
    value <- desc[[field]]
    if (!is.null(value) && nzchar(as.character(value))) {
      lines <- c(lines, paste0("- ", field, ": ", as.character(value)))
    }
  }

  lines
}

package_help_pages_markdown <- function(pkg) {
  # Liste les pages d'aide du package sans appeler help(package = pkg).
  # help(package = pkg) peut ouvrir une page HTML dans RStudio et produire
  # "URL ... 00Index.html not found". On lit donc directement la base Rd.
  rd_db <- tryCatch({
    tools::Rd_db(pkg)
  }, error = function(err) {
    NULL
  })

  if (is.null(rd_db) || length(rd_db) == 0) {
    return(c("", "## Help Pages", "", "No help pages found."))
  }

  topics <- sub("\\.Rd$", "", names(rd_db))
  titles <- vapply(rd_db, function(rd) {
    title <- tryCatch({
      tools:::.Rd_get_metadata(rd, "title")
    }, error = function(err) {
      character(0)
    })
    if (length(title) == 0) {
      return("")
    }
    paste(trimws(as.character(title)), collapse = " ")
  }, character(1))

  order_idx <- order(tolower(topics))
  lines <- c("", "## Help Pages", "")
  for (i in order_idx) {
    topic <- topics[[i]]
    title <- titles[[i]]
    lines <- c(lines, paste0("- ", topic, ": ", title))
  }

  lines
}

find_package_help_rd <- function(pkg) {
  # Cherche la page Rd generale du package, quand elle existe.
  rd_db <- tools::Rd_db(pkg)
  candidates <- c(
    paste0(pkg, "-package.Rd"),
    paste0(pkg, ".Rd"),
    paste0(pkg, "_package.Rd"),
    "package.Rd"
  )
  hit <- candidates[candidates %in% names(rd_db)]
  if (length(hit) == 0) {
    return(NULL)
  }
  rd_db[[hit[[1]]]]
}

render_package_help <- function(pkg, output_dir = NULL) {
  # Sauvegarde l'aide generale d'une librairie/package R dans <package>.md.
  # Cette page est volontairement plus courte que refman.md : elle sert a
  # comprendre le role du package avant de descendre vers les datasets.
  output_dir <- resolve_output_dir(output_dir)
  ensure_namespace(pkg)

  package_dir <- file.path(output_dir, pkg)
  dir.create(package_dir, recursive = TRUE, showWarnings = FALSE)
  output_file <- file.path(package_dir, paste0(tolower(safe_filename(pkg)), ".md"))

  lines <- package_description_markdown(pkg)
  lines <- c(lines, package_help_pages_markdown(pkg))

  rd <- find_package_help_rd(pkg)
  if (!is.null(rd)) {
    rd_lines <- clean_rd2txt_lines(capture.output(tools::Rd2txt(rd)))
    lines <- c(lines, "", "## Package Rd Help", "", rd_lines)
  } else {
    lines <- c(lines, "", "## Package Rd Help", "", "No package-level Rd help page found.")
  }

  writeLines(paste(lines, collapse = "\n"), output_file, useBytes = TRUE)
  output_file
}

render_package <- function(pkg,
                           output_dir = NULL,
                           refman = FALSE) {
  # Fonction simple pour la console R.
  # Elle cree <package>.md et, si refman = TRUE, le manuel complet refman.md.
  #
  # Exemple :
  # render_package("spDataLarge")
  # render_package("spDataLarge", refman = TRUE)
  repo_root <- find_repo_root()
  setwd(repo_root)
  output_dir <- resolve_output_dir(output_dir)
  ensure_namespace(pkg)

  package_dir <- file.path(output_dir, pkg)
  dir.create(package_dir, recursive = TRUE, showWarnings = FALSE)

  package_file <- render_package_help(pkg, output_dir)
  refman_file <- NA_character_

  if (isTRUE(refman)) {
    refman_file <- file.path(package_dir, "refman.md")
    ok <- render_package_refman(pkg, refman_file)
    if (!ok) {
      warning("Rd2md::render_refman() indisponible.", call. = FALSE)
      refman_file <- NA_character_
    }
  }

  cat("Package doc ecrite :", package_file, "\n")
  if (!is.na(refman_file)) {
    cat("Refman ecrit :", refman_file, "\n")
  }

  invisible(list(package_file = package_file, refman_file = refman_file))
}

list_package_dataset_topics <- function(pkg) {
  # Recupere les topics declares par data(package = pkg).
  # Exemple : "lsl" ou "LO_nb (house)".
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

parse_dataset_label <- function(dataset) {
  # Interprete les libelles de data(package = ...).
  # "LO_nb (house)" signifie objet LO_nb, documentation/bundle house.
  has_bundle <- grepl("\\(.+\\)$", dataset)

  if (has_bundle) {
    object <- trimws(sub("\\s*\\(.+\\)$", "", dataset))
    bundle <- trimws(sub("^.*\\((.+)\\)$", "\\1", dataset))
  } else {
    object <- dataset
    bundle <- dataset
  }

  list(object = object, bundle = bundle)
}

show_package_help <- function(pkg) {
  # Affiche dans la console R l'aide generale d'un package.
  # Cette fonction ne cree aucun fichier. Elle sert a lire rapidement le role
  # d'une librairie avant de lancer les fonctions render_* qui sauvegardent.
  #
  # Exemple dans la console R :
  # source("Code_scrapping/r_catalog/render_r_dataset_rd_docs.R")
  # show_package_help("spDataLarge")
  ensure_namespace(pkg)

  lines <- package_description_markdown(pkg)
  lines <- c(lines, package_help_pages_markdown(pkg))

  rd <- find_package_help_rd(pkg)
  if (!is.null(rd)) {
    rd_lines <- clean_rd2txt_lines(capture.output(tools::Rd2txt(rd)))
    lines <- c(lines, "", "## Package Rd Help", "", rd_lines)
  } else {
    lines <- c(lines, "", "## Package Rd Help", "", "No package-level Rd help page found.")
  }

  cat(paste(lines, collapse = "\n"), "\n")
  invisible(lines)
}

show_dataset_help <- function(pkg, dataset) {
  # Affiche dans la console R la documentation d'un dataset precis.
  # Cette fonction ne cree aucun fichier. Elle imite le format RDocumentation
  # utilise par render_dataset_doc(), mais uniquement pour lecture console.
  #
  # Exemple dans la console R :
  # show_dataset_help("spDataLarge", "lsl")
  ensure_namespace(pkg)

  label <- parse_dataset_label(dataset)
  rd_db <- tools::Rd_db(pkg)
  rd_name <- paste0(label$bundle, ".Rd")
  if (!rd_name %in% names(rd_db)) {
    stop("Aucune page Rd trouvee pour ", pkg, "::", dataset, call. = FALSE)
  }

  entries <- list_package_dataset_topics(pkg)
  title <- ""
  if (nrow(entries) > 0) {
    hit <- entries[entries$item == dataset, , drop = FALSE]
    if (nrow(hit) == 0) {
      hit <- entries[entries$item == label$bundle, , drop = FALSE]
    }
    if (nrow(hit) > 0) {
      title <- hit$title[[1]]
    }
  }

  text <- rd_to_rdocumentation_text(
    pkg = pkg,
    topic = label$bundle,
    object_name = label$object,
    title = title,
    rd = rd_db[[rd_name]]
  )

  cat(text, "\n")
  invisible(text)
}

render_dataset_topics <- function(pkg, output_dir, selected_datasets = character(0)) {
  # Ecrit une page Markdown par documentation de dataset quand la page Rd existe.
  rd_db <- tools::Rd_db(pkg)
  entries <- list_package_dataset_topics(pkg)
  if (nrow(entries) == 0) {
    return(data.frame())
  }

  parsed <- lapply(entries$item, parse_dataset_label)
  entries$object <- vapply(parsed, `[[`, character(1), "object")
  entries$bundle <- vapply(parsed, `[[`, character(1), "bundle")

  if (length(selected_datasets) > 0) {
    entries <- entries[
      entries$object %in% selected_datasets | entries$bundle %in% selected_datasets,
      ,
      drop = FALSE
    ]
  }

  topic_dir <- file.path(output_dir, pkg, "topics")
  dir.create(topic_dir, recursive = TRUE, showWarnings = FALSE)

  rows <- list()
  for (i in seq_len(nrow(entries))) {
    topic <- entries$bundle[[i]]
    rd_name <- paste0(topic, ".Rd")
    output_file <- file.path(topic_dir, paste0(safe_filename(topic), ".md"))

    has_rd <- rd_name %in% names(rd_db)
    if (has_rd) {
      md <- rd_to_rdocumentation_text(
        pkg = pkg,
        topic = topic,
        object_name = entries$object[[i]],
        title = entries$title[[i]],
        rd = rd_db[[rd_name]]
      )
      writeLines(md, output_file, useBytes = TRUE)
    }

    rows[[length(rows) + 1L]] <- data.frame(
      package = pkg,
      dataset_item = entries$item[[i]],
      object = entries$object[[i]],
      bundle = entries$bundle[[i]],
      title = entries$title[[i]],
      rd_topic = rd_name,
      has_rd = ifelse(has_rd, "Yes", "No"),
      markdown_file = ifelse(has_rd, output_file, NA_character_),
      cran_topic = paste0("https://search.r-project.org/CRAN/refmans/", pkg, "/html/", topic, ".html"),
      rdrr_topic = paste0("https://rdrr.io/cran/", pkg, "/man/", topic, ".html"),
      stringsAsFactors = FALSE
    )
  }

  do.call(rbind, rows)
}

render_dataset_doc <- function(pkg,
                               dataset = NULL,
                               output_dir = NULL,
                               refman = FALSE,
                               package_help = TRUE,
                               write_index = TRUE) {
  # Fonction interactive simple, pensee pour la console R.
  # Exemple :
  # source("Code_scrapping/r_catalog/render_r_dataset_rd_docs.R")
  # render_dataset_doc("spDataLarge", "lsl")
  #
  # Si dataset = NULL, la fonction rend les pages Rd de tous les datasets
  # declares par data(package = pkg). Si refman = TRUE, elle rend aussi le
  # manuel complet du package dans refman.md.
  repo_root <- find_repo_root()
  setwd(repo_root)
  output_dir <- resolve_output_dir(output_dir)
  ensure_namespace(pkg)

  selected_datasets <- character(0)
  if (!is.null(dataset)) {
    selected_datasets <- dataset
  }

  package_dir <- file.path(output_dir, pkg)
  dir.create(package_dir, recursive = TRUE, showWarnings = FALSE)

  package_help_file <- NA_character_
  if (isTRUE(package_help)) {
    package_help_file <- render_package_help(pkg, output_dir)
  }

  refman_file <- NA_character_
  if (isTRUE(refman)) {
    refman_file <- file.path(package_dir, "refman.md")
    ok <- render_package_refman(pkg, refman_file)
    if (!ok) {
      warning(
        "Rd2md::render_refman() indisponible. Seules les pages dataset seront rendues.",
        call. = FALSE
      )
      refman_file <- NA_character_
    }
  }

  index <- render_dataset_topics(
    pkg = pkg,
    output_dir = output_dir,
    selected_datasets = selected_datasets
  )

  if (nrow(index) > 0) {
    index$refman_file <- refman_file
    index$package_help_file <- package_help_file
  }

  index_path <- file.path("data", "manifests", "datasets", "software_r_rd_documentation_index.csv")
  if (isTRUE(write_index)) {
    dir.create(dirname(index_path), recursive = TRUE, showWarnings = FALSE)
    write.csv2(index, index_path, row.names = FALSE, fileEncoding = "UTF-8")
  }

  cat("Documentation rendue pour :", pkg, "\n")
  if (!is.null(dataset)) {
    cat("Dataset demande :", dataset, "\n")
  }
  if (isTRUE(write_index)) {
    cat("Index ecrit :", index_path, "\n")
  }
  cat("Nombre de topics :", nrow(index), "\n")

  invisible(index)
}

render_dataset_docs <- function(packages,
                                dataset = NULL,
                                output_dir = NULL,
                                refman = FALSE,
                                package_help = TRUE) {
  # Fonction batch pour la console R.
  # Contrairement a une boucle qui appelle render_dataset_doc() package par
  # package, cette fonction ecrit un seul index final combine.
  #
  # Exemple :
  # render_dataset_docs(c("spData", "spDataLarge", "spdep"))
  repo_root <- find_repo_root()
  setwd(repo_root)
  output_dir <- resolve_output_dir(output_dir)

  indexes <- list()
  status_rows <- list()

  for (pkg in packages) {
    message("Rendering docs for: ", pkg)

    result <- tryCatch({
      index <- render_dataset_doc(
        pkg = pkg,
        dataset = dataset,
        output_dir = output_dir,
        refman = refman,
        package_help = package_help,
        write_index = FALSE
      )

      status_rows[[length(status_rows) + 1L]] <<- data.frame(
        package = pkg,
        status = "ok",
        topics = nrow(index),
        message = "",
        stringsAsFactors = FALSE
      )

      index
    }, error = function(err) {
      status_rows[[length(status_rows) + 1L]] <<- data.frame(
        package = pkg,
        status = "error",
        topics = 0L,
        message = conditionMessage(err),
        stringsAsFactors = FALSE
      )
      data.frame()
    })

    if (nrow(result) > 0) {
      indexes[[length(indexes) + 1L]] <- result
    }
  }

  index <- if (length(indexes) == 0) data.frame() else do.call(rbind, indexes)
  status <- if (length(status_rows) == 0) data.frame() else do.call(rbind, status_rows)

  index_path <- file.path("data", "manifests", "datasets", "software_r_rd_documentation_index.csv")
  status_path <- file.path("data", "manifests", "datasets", "software_r_rd_documentation_status.csv")
  dir.create(dirname(index_path), recursive = TRUE, showWarnings = FALSE)
  write.csv2(index, index_path, row.names = FALSE, fileEncoding = "UTF-8")
  write.csv2(status, status_path, row.names = FALSE, fileEncoding = "UTF-8")

  cat("Index combine ecrit :", index_path, "\n")
  cat("Statut des packages ecrit :", status_path, "\n")
  cat("Nombre total de topics :", nrow(index), "\n")

  invisible(list(index = index, status = status))
}

main <- function() {
  args <- parse_args()
  repo_root <- find_repo_root()
  setwd(repo_root)
  output_dir <- resolve_output_dir(args$output_dir)

  index_rows <- list()

  for (pkg in args$packages) {
    ensure_namespace(pkg)
    package_dir <- file.path(output_dir, pkg)
    dir.create(package_dir, recursive = TRUE, showWarnings = FALSE)

    package_help_file <- NA_character_
    if (args$render_package_help) {
      package_help_file <- render_package_help(pkg, output_dir)
    }

    refman_file <- file.path(package_dir, "refman.md")
    refman_created <- FALSE
    if (args$render_refman) {
      refman_created <- render_package_refman(pkg, refman_file)
      if (!refman_created) {
        warning(
          "Rd2md::render_refman() indisponible. ",
          "Les topics individuels seront quand meme rendus.",
          call. = FALSE
        )
      }
    }

    topic_index <- render_dataset_topics(
      pkg = pkg,
      output_dir = output_dir,
      selected_datasets = args$datasets
    )

    if (nrow(topic_index) > 0) {
      topic_index$refman_file <- ifelse(refman_created, refman_file, NA_character_)
      topic_index$package_help_file <- package_help_file
      index_rows[[length(index_rows) + 1L]] <- topic_index
    }
  }

  index <- if (length(index_rows) == 0) data.frame() else do.call(rbind, index_rows)
  index_path <- file.path("data", "manifests", "datasets", "software_r_rd_documentation_index.csv")
  dir.create(dirname(index_path), recursive = TRUE, showWarnings = FALSE)
  write.csv2(index, index_path, row.names = FALSE, fileEncoding = "UTF-8")

  cat("Index ecrit :", index_path, "\n")
  cat("Nombre de lignes :", nrow(index), "\n")
}

if (sys.nframe() == 0 && !interactive()) {
  main()
}
