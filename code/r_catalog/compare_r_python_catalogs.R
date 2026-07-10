# Compare les catalogues logiciels R/Python, documente les doublons et produit
# un catalogue R combine. Ce catalogue combine est l'entree canonique du futur
# pipeline de conversion des datasets spatiaux vers sf.

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

read_csv2_utf8 <- function(path) {
  if (!file.exists(path)) stop("Fichier absent : ", path, call. = FALSE)
  size <- file.info(path)$size
  con <- file(path, open = "rb")
  on.exit(close(con), add = TRUE)
  raw <- readBin(con, what = "raw", n = size)
  text <- iconv(rawToChar(raw), from = "UTF-8", to = "UTF-8", sub = "")
  text <- sub("^\ufeff", "", text)
  utils::read.csv2(
    text = text,
    stringsAsFactors = FALSE,
    check.names = FALSE,
    na.strings = c("NA")
  )
}

write_csv2_utf8 <- function(data, path) {
  utils::write.csv2(
    data,
    file = path,
    row.names = FALSE,
    fileEncoding = "UTF-8"
  )
}

save_rdata_atomic <- function(object_names, envir, path, compress = "xz") {
  temporary <- paste0(path, ".tmp-", Sys.getpid())
  on.exit(unlink(temporary, force = TRUE), add = TRUE)
  save(list = object_names, envir = envir, file = temporary, compress = compress)
  if (!file.copy(temporary, path, overwrite = TRUE)) {
    stop("Impossible de remplacer le fichier RData : ", path, call. = FALSE)
  }
  invisible(path)
}

normalise_key <- function(x) {
  x <- iconv(as.character(x), from = "", to = "ASCII//TRANSLIT")
  x[is.na(x)] <- ""
  gsub("[^a-z0-9]+", "", tolower(x))
}

field_or_empty <- function(data, field) {
  if (field %in% names(data)) as.character(data[[field]]) else rep("", nrow(data))
}

first_nonempty <- function(...) {
  values <- list(...)
  result <- rep("", length(values[[1]]))
  for (value in values) {
    take <- !nzchar(result) & !is.na(value) & nzchar(trimws(as.character(value)))
    result[take] <- as.character(value[take])
  }
  result
}

canonicalise_r <- function(data) {
  data.frame(
    record_id = paste("R", data$package, data$bundle, data$main_object, sep = "::"),
    source_language = "R",
    package = field_or_empty(data, "package"),
    dataset_name = first_nonempty(
      field_or_empty(data, "bundle"),
      field_or_empty(data, "main_object")
    ),
    source_entry = field_or_empty(data, "main_object"),
    role = field_or_empty(data, "role"),
    usage_role = field_or_empty(data, "usage_role"),
    classification_reason = field_or_empty(data, "classification_reason"),
    description = field_or_empty(data, "description_bundle"),
    theme = field_or_empty(data, "theme"),
    source_url = first_nonempty(
      field_or_empty(data, "source_url"),
      field_or_empty(data, "source")
    ),
    local_files = "",
    n = suppressWarnings(as.numeric(field_or_empty(data, "n"))),
    k = suppressWarnings(as.integer(field_or_empty(data, "k"))),
    variables = field_or_empty(data, "variables"),
    analytical_variables = field_or_empty(data, "analytical_variables"),
    metadata_variables = field_or_empty(data, "metadata_variables"),
    identifier_variables = field_or_empty(data, "identifier_variables"),
    candidate_y_variables = field_or_empty(data, "candidate_y_variables"),
    candidate_x_variables = field_or_empty(data, "candidate_x_variables"),
    has_geometry = field_or_empty(data, "has_geometry"),
    has_coordinates = field_or_empty(data, "has_coordinates"),
    coordinate_columns = field_or_empty(data, "coordinate_columns"),
    has_datetime = field_or_empty(data, "has_datetime"),
    datetime_columns = field_or_empty(data, "datetime_columns"),
    has_place_name_if_no_geometry = field_or_empty(data, "has_place_name_if_no_geometry"),
    place_name_columns = field_or_empty(data, "place_name_columns"),
    formula_text = field_or_empty(data, "formula_text"),
    has_referenced_paper = field_or_empty(data, "has_referenced_paper"),
    paper_doi = field_or_empty(data, "paper_doi"),
    paper_doi_status = field_or_empty(data, "paper_doi_status"),
    paper_title = field_or_empty(data, "paper_title"),
    paper_reference_evidence = field_or_empty(data, "paper_reference_evidence"),
    paper_formula_or_equation = field_or_empty(data, "paper_formula_or_equation"),
    paper_evidence_status = field_or_empty(data, "paper_evidence_status"),
    final_category = field_or_empty(data, "final_category"),
    stringsAsFactors = FALSE
  )
}

canonicalise_python <- function(data) {
  data.frame(
    record_id = paste(
      "Python", data$package,
      first_nonempty(
        field_or_empty(data, "dataset_key"),
        field_or_empty(data, "dataset"),
        field_or_empty(data, "main_file_or_entry")
      ),
      sep = "::"
    ),
    source_language = "Python",
    package = field_or_empty(data, "package"),
    dataset_name = first_nonempty(
      field_or_empty(data, "dataset"),
      field_or_empty(data, "dataset_key"),
      field_or_empty(data, "main_file_or_entry")
    ),
    source_entry = field_or_empty(data, "main_file_or_entry"),
    role = field_or_empty(data, "role"),
    usage_role = field_or_empty(data, "usage_role"),
    classification_reason = field_or_empty(data, "classification_reason"),
    description = field_or_empty(data, "description"),
    theme = field_or_empty(data, "theme"),
    source_url = field_or_empty(data, "source_url"),
    local_files = field_or_empty(data, "local_files"),
    n = suppressWarnings(as.numeric(field_or_empty(data, "n"))),
    k = suppressWarnings(as.integer(field_or_empty(data, "k"))),
    variables = field_or_empty(data, "variables"),
    analytical_variables = field_or_empty(data, "analytical_variables"),
    metadata_variables = field_or_empty(data, "metadata_variables"),
    identifier_variables = field_or_empty(data, "identifier_variables"),
    candidate_y_variables = field_or_empty(data, "candidate_y_variables"),
    candidate_x_variables = field_or_empty(data, "candidate_x_variables"),
    has_geometry = field_or_empty(data, "has_geometry"),
    has_coordinates = field_or_empty(data, "has_coordinates"),
    coordinate_columns = field_or_empty(data, "coordinate_columns"),
    has_datetime = field_or_empty(data, "has_datetime"),
    datetime_columns = field_or_empty(data, "datetime_columns"),
    has_place_name_if_no_geometry = field_or_empty(data, "has_place_name_if_no_geometry"),
    place_name_columns = field_or_empty(data, "place_name_columns"),
    formula_text = field_or_empty(data, "formula_text"),
    has_referenced_paper = field_or_empty(data, "has_referenced_paper"),
    paper_doi = field_or_empty(data, "paper_doi"),
    paper_doi_status = field_or_empty(data, "paper_doi_status"),
    paper_title = field_or_empty(data, "paper_title"),
    paper_reference_evidence = field_or_empty(data, "paper_reference_evidence"),
    paper_formula_or_equation = field_or_empty(data, "paper_formula_or_equation"),
    paper_evidence_status = field_or_empty(data, "paper_evidence_status"),
    final_category = field_or_empty(data, "final_category"),
    stringsAsFactors = FALSE
  )
}

split_variable_set <- function(x) {
  values <- trimws(unlist(strsplit(as.character(x), ",", fixed = TRUE)))
  unique(normalise_key(values[nzchar(values)]))
}

jaccard <- function(left, right) {
  left <- split_variable_set(left)
  right <- split_variable_set(right)
  union_size <- length(union(left, right))
  if (union_size == 0L) return(0)
  length(intersect(left, right)) / union_size
}

name_similarity <- function(left, right) {
  left <- normalise_key(left)
  right <- normalise_key(right)
  denominator <- max(nchar(left), nchar(right))
  if (denominator == 0L) return(0)
  1 - as.numeric(utils::adist(left, right)) / denominator
}

compare_cross_language <- function(r_catalog, python_catalog) {
  rows <- list()
  index <- 0L
  for (i in seq_len(nrow(r_catalog))) {
    for (j in seq_len(nrow(python_catalog))) {
      exact_name <- normalise_key(r_catalog$dataset_name[i]) ==
        normalise_key(python_catalog$dataset_name[j]) &&
        nchar(normalise_key(r_catalog$dataset_name[i])) >= 3L
      exact_description <- normalise_key(r_catalog$description[i]) ==
        normalise_key(python_catalog$description[j]) &&
        nchar(normalise_key(r_catalog$description[i])) >= 20L
      same_url <- nzchar(r_catalog$source_url[i]) &&
        identical(r_catalog$source_url[i], python_catalog$source_url[j])
      similarity <- name_similarity(
        r_catalog$dataset_name[i], python_catalog$dataset_name[j]
      )
      variable_overlap <- jaccard(
        r_catalog$analytical_variables[i],
        python_catalog$analytical_variables[j]
      )
      fuzzy <- similarity >= 0.92 && variable_overlap >= 0.50
      if (!(exact_name || exact_description || same_url || fuzzy)) next

      index <- index + 1L
      match_type <- if (same_url) {
        "same_source_url"
      } else if (exact_name) {
        "exact_dataset_name"
      } else if (exact_description) {
        "exact_description"
      } else {
        "fuzzy_name_and_variables"
      }
      rows[[index]] <- data.frame(
        r_record_id = r_catalog$record_id[i],
        python_record_id = python_catalog$record_id[j],
        r_package = r_catalog$package[i],
        python_package = python_catalog$package[j],
        r_dataset = r_catalog$dataset_name[i],
        python_dataset = python_catalog$dataset_name[j],
        match_type = match_type,
        name_similarity = round(similarity, 4),
        variable_jaccard = round(variable_overlap, 4),
        stringsAsFactors = FALSE
      )
    }
  }
  if (length(rows) == 0L) return(data.frame())
  do.call(rbind, rows)
}

information_score <- function(catalog) {
  nonempty <- function(x) !is.na(x) & nzchar(trimws(as.character(x)))
  k <- catalog$k
  k[is.na(k)] <- 0L
  pmin(k, 20L) +
    5L * nonempty(catalog$local_files) +
    3L * nonempty(catalog$source_url) +
    2L * nonempty(catalog$description) +
    2L * nonempty(catalog$candidate_y_variables) +
    2L * (catalog$has_geometry == "Yes")
}

mark_and_deduplicate <- function(full_catalog, duplicates) {
  full_catalog$duplicate_group <- ""
  full_catalog$duplicate_status <- "unique"
  full_catalog$information_score <- information_score(full_catalog)
  if (nrow(duplicates) == 0L) {
    return(list(full = full_catalog, deduplicated = full_catalog))
  }

  involved <- unique(c(duplicates$r_record_id, duplicates$python_record_id))
  adjacency <- setNames(vector("list", length(involved)), involved)
  for (i in seq_len(nrow(duplicates))) {
    left <- duplicates$r_record_id[i]
    right <- duplicates$python_record_id[i]
    adjacency[[left]] <- unique(c(adjacency[[left]], right))
    adjacency[[right]] <- unique(c(adjacency[[right]], left))
  }

  visited <- character(0)
  group_index <- 0L
  for (start in involved) {
    if (start %in% visited) next
    group_index <- group_index + 1L
    queue <- start
    component <- character(0)
    while (length(queue) > 0L) {
      node <- queue[1]
      queue <- queue[-1]
      if (node %in% component) next
      component <- c(component, node)
      queue <- c(queue, setdiff(adjacency[[node]], component))
    }
    visited <- c(visited, component)
    idx <- match(component, full_catalog$record_id)
    idx <- idx[!is.na(idx)]
    group_name <- sprintf("cross_language_%04d", group_index)
    preferred <- idx[which.max(full_catalog$information_score[idx])]
    full_catalog$duplicate_group[idx] <- group_name
    full_catalog$duplicate_status[idx] <- "duplicate_cross_language"
    full_catalog$duplicate_status[preferred] <- "preferred_cross_language"
  }

  keep <- !full_catalog$duplicate_status %in% "duplicate_cross_language"
  list(full = full_catalog, deduplicated = full_catalog[keep, , drop = FALSE])
}

build_combined_catalog <- function(repo_root = find_repo_root()) {
  manifest_dir <- file.path(repo_root, "data", "manifests", "datasets")
  r_path <- file.path(manifest_dir, "software_r_catalog_classified.RData")
  python_path <- file.path(manifest_dir, "software_python_catalog_classified.jsonl")
  if (!file.exists(r_path)) stop("Catalogue R absent : ", r_path, call. = FALSE)
  if (!file.exists(python_path)) stop("Catalogue Python absent : ", python_path, call. = FALSE)
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Le package R jsonlite est requis pour lire le JSONL Python.", call. = FALSE)
  }

  r_env <- new.env(parent = emptyenv())
  load(r_path, envir = r_env)
  if (!exists("catalogue_r_complet", envir = r_env, inherits = FALSE)) {
    stop("Objet catalogue_r_complet absent du catalogue RData.", call. = FALSE)
  }
  python_file <- file(python_path, open = "rb")
  on.exit(close(python_file), add = TRUE)
  python_bytes <- readBin(
    python_file,
    what = "raw",
    n = file.info(python_path)$size
  )
  python_text <- iconv(
    rawToChar(python_bytes),
    from = "UTF-8",
    to = "ASCII//TRANSLIT",
    sub = ""
  )
  python_text <- gsub("\r", "", python_text, fixed = TRUE)
  python_lines <- strsplit(python_text, "\n", fixed = TRUE)[[1]]
  python_lines <- python_lines[nzchar(trimws(python_lines))]
  python_raw <- jsonlite::fromJSON(
    paste0("[", paste(python_lines, collapse = ","), "]"),
    simplifyDataFrame = TRUE
  )

  r_catalog <- canonicalise_r(r_env$catalogue_r_complet)
  python_catalog <- canonicalise_python(python_raw)
  duplicates <- compare_cross_language(r_catalog, python_catalog)
  combined <- mark_and_deduplicate(rbind(r_catalog, python_catalog), duplicates)

  catalogue_combine_complet <- combined$full
  catalogue_doublons_r_python <- duplicates
  catalogue_logiciel_combine <- combined$deduplicated
  catalogue_bons_candidats_spatiaux <- catalogue_logiciel_combine[
    catalogue_logiciel_combine$final_category == "Bons candidats spatial",
    , drop = FALSE
  ]
  catalogue_spatial_simple <- catalogue_logiciel_combine[
    catalogue_logiciel_combine$final_category == "Spatial simple",
    , drop = FALSE
  ]
  catalogue_ml_non_spatial <- catalogue_logiciel_combine[
    catalogue_logiciel_combine$final_category == "ML non spatial",
    , drop = FALSE
  ]

  save_rdata_atomic(
    c(
      "catalogue_combine_complet",
      "catalogue_doublons_r_python",
      "catalogue_logiciel_combine",
      "catalogue_bons_candidats_spatiaux",
      "catalogue_spatial_simple",
      "catalogue_ml_non_spatial"
    ),
    environment(),
    file.path(manifest_dir, "software_catalog_combined.RData")
  )

  cat("Catalogue R :", nrow(r_catalog), "\n")
  cat("Catalogue Python :", nrow(python_catalog), "\n")
  cat("Paires de doublons R/Python :", nrow(duplicates), "\n")
  cat("Catalogue combine deduplique :", nrow(catalogue_logiciel_combine), "\n")
  print(table(catalogue_logiciel_combine$final_category, useNA = "ifany"))

  invisible(list(
    complet = catalogue_combine_complet,
    doublons = catalogue_doublons_r_python,
    combine = catalogue_logiciel_combine
  ))
}

if (sys.nframe() == 0L) {
  build_combined_catalog()
}
