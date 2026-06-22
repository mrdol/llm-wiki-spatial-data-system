# Télécharge et extrait exhaustivement les jeux de données des archives sources CRAN.
#
# Utilisation depuis la racine du dépôt llm-wiki-karpathy :
# Rscript Code_scrapping/extract_r_software_datasets.R
#
# Le script télécharge les archives de packages manquantes dans :
# data/downloads/software/r_datasets/cran_packages/
# écrit l'inventaire des datasets trouvés dans :
# data/manifests/datasets/software_r_dataset_inventory.jsonl
# puis écrit les objets tabulaires extractibles dans :
# data/downloads/software/r_datasets/extracted_csv/

find_repo_root <- function(start = getwd()) {
  start <- normalizePath(start, winslash = "/", mustWork = TRUE)
  if (basename(start) == "llm-wiki-karpathy") {
    return(start)
  }
  nested <- file.path(start, "llm-wiki-karpathy")
  if (dir.exists(nested)) {
    return(normalizePath(nested, winslash = "/", mustWork = TRUE))
  }
  stop("Run from llm-wiki-karpathy or its parent workspace.", call. = FALSE)
}

repo_root <- find_repo_root()
cran_dir <- file.path(repo_root, "data", "downloads", "software", "r_datasets", "cran_packages")
out_dir <- file.path(repo_root, "data", "downloads", "software", "r_datasets", "extracted_csv")
manifest_path <- file.path(repo_root, "data", "manifests", "datasets", "software_r_extracted_datasets.jsonl")
inventory_manifest_path <- file.path(repo_root, "data", "manifests", "datasets", "software_r_dataset_inventory.jsonl")
cran_repo <- getOption("repos")[["CRAN"]]
if (is.null(cran_repo) || identical(cran_repo, "@CRAN@")) {
  cran_repo <- "https://cloud.r-project.org"
}
rforge_repo <- "http://R-Forge.R-project.org"
repos <- c(
  CRAN = cran_repo,
  nowosad = "https://nowosad.r-universe.dev",
  RForge = rforge_repo
)
available_packages_cache <- NULL
rforge_packages_cache <- NULL

dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(dirname(manifest_path), recursive = TRUE, showWarnings = FALSE)

# Ce scraper travaille au niveau des archives de données plutôt qu'avec les APIs
# internes des packages : ces APIs sont hétérogènes, peuvent nécessiter beaucoup
# de dépendances, et exposent souvent les exemples via des helpers spécifiques.
# La convention CRAN commune est que les datasets embarqués vivent sous data/
# sous forme de fichiers sérialisés.
packages <- c(
  "spdep",
  "spatialreg",
  "spData",
  "spDataLarge",
  "sphet",
  "spse",
  "GWmodel",
  "mgwrsar",
  "spgwr",
  "gstat",
  "sp",
  "sf",
  "sfdep",
  "plm",
  "splm",
  "spacetime",
  "surveillance",
  "STRbook",
  "SpatialEpi",
  "spatstat",
  "spatstat.data",
  "CARBayes",
  "CARBayesST",
  "spaMM",
  "vegan",
  "ade4",
  "dismo",
  "MASS",
  "HistData",
  "AER",
  "agridat",
  "rgeoboundaries",
  "giscoR"
)

archive_urls <- list(
  spse = "http://R-Forge.R-project.org/src/contrib/"
)

json_escape <- function(x) {
  x <- ifelse(is.na(x), "", as.character(x))
  x <- gsub("\\\\", "\\\\\\\\", x)
  x <- gsub('"', '\\"', x)
  x <- gsub("\n", "\\\\n", x)
  x
}

write_jsonl <- function(con, record) {
  keys <- names(record)
  values <- vapply(keys, function(key) {
    value <- record[[key]]
    if (is.null(value) || length(value) == 0 || all(is.na(value))) {
      "null"
    } else if (is.logical(value) && length(value) == 1) {
      if (isTRUE(value)) "true" else "false"
    } else if (is.numeric(value) && length(value) == 1) {
      as.character(value)
    } else {
      paste0('"', json_escape(paste(value, collapse = "; ")), '"')
    }
  }, character(1))
  writeLines(paste0("{", paste(paste0('"', keys, '":', values), collapse = ","), "}"), con)
}

safe_filename <- function(x) {
  x <- gsub("[^A-Za-z0-9._-]+", "_", x)
  x <- gsub("^_+|_+$", "", x)
  if (!nzchar(x)) "object" else x
}

archive_for_package <- function(package) {
  hits <- list.files(cran_dir, pattern = paste0("^", package, "_.*[.]tar[.]gz$"), full.names = TRUE)
  if (length(hits) == 0) return(NA_character_)
  hits <- hits[order(file.info(hits)$mtime, decreasing = TRUE)]
  hits[[1]]
}

download_current_cran_archive <- function(package) {
  if (is.null(available_packages_cache)) {
    available_packages_cache <<- try(utils::available.packages(repos = cran_repo, type = "source"), silent = TRUE)
  }
  available <- available_packages_cache
  if (inherits(available, "try-error") || !(package %in% rownames(available))) {
    return(NA_character_)
  }

  version <- available[package, "Version"]
  filename <- paste0(package, "_", version, ".tar.gz")
  destination <- file.path(cran_dir, filename)
  if (file.exists(destination)) {
    return(normalizePath(destination, winslash = "/", mustWork = TRUE))
  }

  source_url <- paste0(utils::contrib.url(cran_repo, type = "source"), "/", filename)
  status <- try(utils::download.file(source_url, destination, mode = "wb", quiet = TRUE), silent = TRUE)
  if (inherits(status, "try-error") || !file.exists(destination)) {
    unlink(destination, force = TRUE)
    return(NA_character_)
  }
  normalizePath(destination, winslash = "/", mustWork = TRUE)
}

download_current_rforge_archive <- function(package) {
  if (is.null(rforge_packages_cache)) {
    rforge_packages_cache <<- try(utils::available.packages(repos = rforge_repo, type = "source"), silent = TRUE)
  }
  available <- rforge_packages_cache
  if (inherits(available, "try-error") || !(package %in% rownames(available))) {
    return(NA_character_)
  }

  version <- available[package, "Version"]
  filename <- paste0(package, "_", version, ".tar.gz")
  destination <- file.path(cran_dir, filename)
  if (file.exists(destination)) {
    return(normalizePath(destination, winslash = "/", mustWork = TRUE))
  }

  source_url <- paste0(utils::contrib.url(rforge_repo, type = "source"), "/", filename)
  status <- try(utils::download.file(source_url, destination, mode = "wb", quiet = TRUE), silent = TRUE)
  if (inherits(status, "try-error") || !file.exists(destination)) {
    unlink(destination, force = TRUE)
    return(NA_character_)
  }
  normalizePath(destination, winslash = "/", mustWork = TRUE)
}

install_if_missing <- function(package) {
  # Vérifie d'abord si le package est déjà installé.
  # requireNamespace() ne charge pas le package dans l'environnement global.
  if (requireNamespace(package, quietly = TRUE)) {
    return(TRUE)
  }

  cat("\nInstallation de", package, "...\n")

  # Tente une installation binaire depuis les dépôts indiqués.
  # Sur Windows, type = "binary" évite autant que possible le besoin de Rtools.
  ok <- tryCatch({
    utils::install.packages(package, repos = repos, type = "binary")
    requireNamespace(package, quietly = TRUE)
  }, error = function(e) {
    FALSE
  })

  # Si l'installation a réussi, on renvoie TRUE.
  if (ok) {
    return(TRUE)
  }

  # spse est distribué via R-Forge en source.
  if (identical(package, "spse")) {
    ok <- tryCatch({
      utils::install.packages(package, repos = rforge_repo, type = "source")
      requireNamespace(package, quietly = TRUE)
    }, error = function(e) {
      FALSE
    })
    if (ok) {
      return(TRUE)
    }
  }

  # Sinon, on signale l'échec et on laisse les autres fonctions essayer
  # l'inspection de l'archive source CRAN sans installation.
  cat("Installation standard échouée pour", package, "\n")
  FALSE
}

list_installed_package_datasets <- function(package) {
  # data(package = package) demande à R la liste officielle des datasets
  # exposés par le package installé.
  datasets <- tryCatch(
    utils::data(package = package)$results,
    error = function(e) NULL
  )

  # Si aucun dataset n'est déclaré, on renvoie un vecteur vide.
  if (is.null(datasets) || nrow(datasets) == 0) {
    return(character())
  }

  # La colonne "Item" contient les noms des datasets.
  datasets[, "Item"]
}

get_cran_archive_url <- function(package) {
  # Récupère la table des packages disponibles sur CRAN en version source.
  if (is.null(available_packages_cache)) {
    available_packages_cache <<- try(utils::available.packages(repos = repos["CRAN"], type = "source"), silent = TRUE)
  }
  available <- available_packages_cache

  # Si le package est disponible sur CRAN courant, on construit directement
  # l'URL de son archive .tar.gz.
  if (!inherits(available, "try-error") && package %in% rownames(available)) {
    version <- available[package, "Version"]
    return(sprintf(
      "%s/%s_%s.tar.gz",
      utils::contrib.url(repos["CRAN"], type = "source"),
      package,
      version
    ))
  }

  # Si le package n'est plus sur CRAN courant, on cherche dans l'archive
  # historique de CRAN.
  archive_index <- paste0("https://cran.r-project.org/src/contrib/Archive/", package, "/")

  # Lit la page HTML de l'archive du package.
  html <- tryCatch(
    paste(readLines(archive_index, warn = FALSE), collapse = "\n"),
    error = function(e) NULL
  )

  if (is.null(html)) {
    return(NA_character_)
  }

  # Cherche tous les fichiers du type package_version.tar.gz.
  files <- extract_archive_links(html, package)
  if (length(files) == 0) {
    return(NA_character_)
  }

  # Prend la dernière version trouvée selon l'ordre alphabétique décroissant.
  latest <- sort(files, decreasing = TRUE)[1]

  # Renvoie l'URL complète de l'archive.
  paste0(archive_index, latest)
}

extract_archive_links <- function(index_html, package) {
  matches <- gregexpr(paste0(package, "_[^\"'<>[:space:]]+[.]tar[.]gz"), index_html, perl = TRUE)
  links <- regmatches(index_html, matches)[[1]]
  unique(links)
}

download_archived_cran_archive <- function(package) {
  base_url <- archive_urls[[package]]
  if (is.null(base_url)) {
    base_url <- paste0("https://cran.r-project.org/src/contrib/Archive/", package, "/")
  }

  index_html <- try(paste(readLines(base_url, warn = FALSE), collapse = "\n"), silent = TRUE)
  if (inherits(index_html, "try-error")) {
    return(NA_character_)
  }

  links <- extract_archive_links(index_html, package)
  if (length(links) == 0) {
    return(NA_character_)
  }

  filename <- sort(links, decreasing = TRUE)[[1]]
  destination <- file.path(cran_dir, filename)
  if (file.exists(destination)) {
    return(normalizePath(destination, winslash = "/", mustWork = TRUE))
  }

  source_url <- paste0(base_url, filename)
  status <- try(utils::download.file(source_url, destination, mode = "wb", quiet = TRUE), silent = TRUE)
  if (inherits(status, "try-error") || !file.exists(destination)) {
    unlink(destination, force = TRUE)
    return(NA_character_)
  }
  normalizePath(destination, winslash = "/", mustWork = TRUE)
}

ensure_archive_for_package <- function(package) {
  local_archive <- archive_for_package(package)
  if (!is.na(local_archive)) {
    return(list(path = local_archive, status = "local_archive_found"))
  }

  current_archive <- download_current_cran_archive(package)
  if (!is.na(current_archive)) {
    return(list(path = current_archive, status = "downloaded_current_cran"))
  }

  rforge_archive <- download_current_rforge_archive(package)
  if (!is.na(rforge_archive)) {
    return(list(path = rforge_archive, status = "downloaded_current_rforge"))
  }

  archived_archive <- download_archived_cran_archive(package)
  if (!is.na(archived_archive)) {
    return(list(path = archived_archive, status = "downloaded_cran_archive"))
  }

  list(path = NA_character_, status = "archive_not_found")
}

list_source_archive_datasets <- function(package) {
  # Trouve l'archive source CRAN ou CRAN Archive, en réutilisant le cache local
  # si l'archive a déjà été téléchargée.
  archive_result <- ensure_archive_for_package(package)
  archive <- archive_result$path

  if (is.na(archive)) {
    return(list(
      datasets = character(),
      source = "archive_indisponible",
      archive = NA_character_,
      archive_status = archive_result$status
    ))
  }

  # Liste les fichiers contenus dans l'archive sans l'extraire complètement.
  members <- tryCatch(
    utils::untar(archive, list = TRUE),
    error = function(e) character()
  )

  # Garde uniquement les fichiers de datasets R embarqués.
  data_files <- members[
    grepl(
      "/data/.*[.](rda|RData|rda.gz|RData.gz)$",
      members,
      ignore.case = TRUE
    )
  ]

  # Convertit les noms de fichiers en noms de datasets.
  datasets <- basename(data_files)
  datasets <- sub(
    "[.](rda|RData|rda.gz|RData.gz)$",
    "",
    datasets,
    ignore.case = TRUE
  )

  list(
    datasets = unique(datasets),
    source = "archive_cran_sans_installation",
    archive = archive,
    archive_status = archive_result$status
  )
}

list_package_datasets_safe <- function(package) {
  # Essaie d'abord la voie normale : installer le package, puis demander à R
  # les datasets déclarés par data(package = ...).
  installed <- install_if_missing(package)

  if (installed) {
    datasets <- list_installed_package_datasets(package)

    if (length(datasets) > 0) {
      cat("\n====================\n")
      cat("Package :", package, "\n")
      cat("Source  : package installé\n")
      cat("====================\n")
      print(datasets)
      return(list(
        datasets = datasets,
        source = "package_installe",
        archive = NA_character_,
        archive_status = "not_needed"
      ))
    }
  }

  # Si le package n'est pas installable ou ne déclare aucun dataset, on inspecte
  # directement l'archive source CRAN sans installation.
  result <- list_source_archive_datasets(package)

  cat("\n====================\n")
  cat("Package :", package, "\n")
  cat("Source  :", result$source, "\n")
  cat("====================\n")

  if (length(result$datasets) == 0) {
    cat("Aucun dataset trouvé ou package inaccessible.\n")
    return(result)
  }

  print(result$datasets)
  result
}

is_candidate_member <- function(member) {
  grepl("/data/.*[.](rda|RData|rda.gz|RData.gz)$", member, ignore.case = TRUE)
}

dataset_name_from_member <- function(member) {
  name <- basename(member)
  name <- sub("[.](rda|RData|rda.gz|RData.gz)$", "", name, ignore.case = TRUE)
  safe_filename(name)
}

as_tabular <- function(object) {
  if (inherits(object, "data.frame")) {
    return(as.data.frame(object))
  }
  if (is.matrix(object) || is.table(object)) {
    return(as.data.frame(object))
  }
  if (is.vector(object) && !is.list(object)) {
    return(data.frame(value = object))
  }
  if (is.list(object) && length(object) > 0) {
    simple_lengths <- vapply(object, function(item) {
      if (is.atomic(item) && length(dim(item)) == 0) length(item) else -1L
    }, integer(1))
    if (all(simple_lengths > 0) && length(unique(simple_lengths)) == 1) {
      return(as.data.frame(object, stringsAsFactors = FALSE))
    }
    frames <- object[vapply(object, inherits, logical(1), what = "data.frame")]
    if (length(frames) > 0) {
      frames <- Map(function(name, frame) {
        frame <- as.data.frame(frame)
        frame$component <- name
        frame
      }, names(frames), frames)
      return(do.call(rbind, frames))
    }
  }
  NULL
}

inventory_con <- file(inventory_manifest_path, open = "w", encoding = "UTF-8")
on.exit(close(inventory_con), add = TRUE)

# Premier passage : inventaire lisible des datasets disponibles par package.
# Cette sortie sert à vérifier manuellement les packages avant ou après
# l'extraction CSV exhaustive.
for (package in packages) {
  inventory <- list_package_datasets_safe(package)

  if (length(inventory$datasets) == 0) {
    write_jsonl(inventory_con, list(
      package = package,
      dataset = NA_character_,
      status = "no_dataset_found",
      source = inventory$source,
      archive_status = inventory$archive_status,
      archive = inventory$archive
    ))
    next
  }

  for (dataset in inventory$datasets) {
    write_jsonl(inventory_con, list(
      package = package,
      dataset = dataset,
      status = "listed",
      source = inventory$source,
      archive_status = inventory$archive_status,
      archive = inventory$archive
    ))
  }
}

manifest_con <- file(manifest_path, open = "w", encoding = "UTF-8")
on.exit(close(manifest_con), add = TRUE)

for (package in packages) {
  archive_result <- ensure_archive_for_package(package)
  archive <- archive_result$path
  archive_status <- archive_result$status

  if (is.na(archive)) {
    write_jsonl(manifest_con, list(
      package = package,
      dataset = "all_data",
      status = archive_status,
      archive_status = archive_status,
      archive = NA_character_,
      member = NA_character_,
      object = NA_character_,
      output = NA_character_,
      rows = NA_real_,
      columns = NA_real_
    ))
    next
  }

  members <- utils::untar(archive, list = TRUE)
  candidates <- members[vapply(members, is_candidate_member, logical(1))]
  if (length(candidates) == 0) {
    write_jsonl(manifest_con, list(
      package = package,
      dataset = "all_data",
      status = "data_file_not_found",
      archive_status = archive_status,
      archive = archive,
      member = NA_character_,
      object = NA_character_,
      output = NA_character_,
      rows = NA_real_,
      columns = NA_real_
    ))
    next
  }

  temp_dir <- tempfile("rdata_extract_")
  dir.create(temp_dir)
  on.exit(unlink(temp_dir, recursive = TRUE, force = TRUE), add = TRUE)
  utils::untar(archive, files = candidates, exdir = temp_dir)

  for (member in candidates) {
    dataset <- dataset_name_from_member(member)
    target_dir <- file.path(out_dir, package, dataset)
    dir.create(target_dir, recursive = TRUE, showWarnings = FALSE)

    data_path <- file.path(temp_dir, member)
    env <- new.env(parent = emptyenv())
    loaded <- try(load(data_path, envir = env), silent = TRUE)
    if (inherits(loaded, "try-error")) {
      write_jsonl(manifest_con, list(
        package = package,
        dataset = dataset,
        status = "load_failed",
        archive_status = archive_status,
        archive = archive,
        member = member,
        object = NA_character_,
        output = NA_character_,
        rows = NA_real_,
        columns = NA_real_
      ))
      next
    }

    for (object_name in loaded) {
      object <- get(object_name, envir = env)
      table <- try(as_tabular(object), silent = TRUE)
      if (inherits(table, "try-error") || is.null(table)) {
        write_jsonl(manifest_con, list(
          package = package,
          dataset = dataset,
          status = "not_tabular",
          archive_status = archive_status,
          archive = archive,
          member = member,
          object = object_name,
          output = NA_character_,
          rows = NA_real_,
          columns = NA_real_
        ))
        next
      }

      output <- file.path(target_dir, paste0(safe_filename(object_name), ".csv"))
      utils::write.csv(table, output, row.names = FALSE, fileEncoding = "UTF-8")
      write_jsonl(manifest_con, list(
        package = package,
        dataset = dataset,
        status = "extracted_csv",
        archive_status = archive_status,
        archive = archive,
        member = member,
        object = object_name,
        output = output,
        rows = nrow(table),
        columns = ncol(table)
      ))
    }
  }
}

cat("Manifeste d'inventaire :", inventory_manifest_path, "\n")
cat("Manifeste d'extraction :", manifest_path, "\n")
