## -----------------------------------------------------------------------
## apply_datacite_verification.R
##
## Applique un rapport de verification DataCite aux deux sorties du harvest.
##
## Regle:
## - action reject                 -> ligne retiree
## - action keep                   -> candidate_status = verified_candidate
## - action needs_manual_check     -> candidate_status = needs_manual_curation
## - action needs_manual_check_*   -> candidate_status = needs_manual_curation_priority
##
## Le script ajoute aussi des colonnes `verification_*` pour garder la trace
## de la decision appliquee.
## -----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(jsonlite)
  library(readr)
})

script_path <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0L) {
    return(normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = FALSE))
  }
  normalizePath(file.path(getwd(), "tools", "apply_datacite_verification.R"), mustWork = FALSE)
}

repo_root_default <- function() {
  normalizePath(file.path(dirname(script_path()), ".."), mustWork = FALSE)
}

parse_cli <- function(args) {
  values <- list()
  i <- 1L
  while (i <= length(args)) {
    key <- args[[i]]
    if (startsWith(key, "--")) {
      name <- sub("^--", "", key)
      if (i == length(args) || startsWith(args[[i + 1L]], "--")) {
        values[[name]] <- TRUE
        i <- i + 1L
      } else {
        values[[name]] <- args[[i + 1L]]
        i <- i + 2L
      }
    } else {
      i <- i + 1L
    }
  }
  values
}

latest_verification_json <- function(output_dir) {
  files <- list.files(
    output_dir,
    pattern = "^datacite_verification_report_.*\\.json$",
    full.names = TRUE
  )
  files <- files[!grepl("_raw_", basename(files))]
  if (length(files) == 0L) {
    stop("Aucun rapport de verification JSON trouve dans: ", output_dir)
  }
  files[[which.max(file.info(files)$mtime)]]
}

read_candidates <- function(json_path, csv_path) {
  if (file.exists(json_path)) {
    rows <- jsonlite::fromJSON(json_path, simplifyVector = TRUE)
    return(as.data.frame(rows, stringsAsFactors = FALSE))
  }
  if (file.exists(csv_path)) {
    return(as.data.frame(
      readr::read_delim(
        csv_path,
        delim = ";",
        show_col_types = FALSE,
        locale = readr::locale(encoding = "UTF-8")
      ),
      stringsAsFactors = FALSE
    ))
  }
  stop("Aucune sortie harvest trouvee: ", json_path, " / ", csv_path)
}

normalize_doi <- function(x) {
  x <- tolower(trimws(as.character(x)))
  x <- sub("^https?://(dx\\.)?doi\\.org/", "", x)
  x
}

pick_action_column <- function(report) {
  if ("final_action" %in% names(report)) {
    return("final_action")
  }
  if ("recommended_action" %in% names(report)) {
    return("recommended_action")
  }
  if ("action" %in% names(report)) {
    return("action")
  }
  stop("Le rapport ne contient ni final_action, ni recommended_action, ni action.")
}

status_from_action <- function(action) {
  ifelse(
    action == "keep",
    "verified_candidate",
    ifelse(
      grepl("^needs_manual_check_priority", action),
      "needs_manual_curation_priority",
      "needs_manual_curation"
    )
  )
}

copy_if_present <- function(target, source, target_name, source_name, idx) {
  if (source_name %in% names(source)) {
    target[[target_name]] <- source[[source_name]][idx]
  } else {
    target[[target_name]] <- NA_character_
  }
  target
}

write_outputs <- function(rows, json_path, csv_path) {
  dir.create(dirname(json_path), recursive = TRUE, showWarnings = FALSE)
  jsonlite::write_json(
    rows,
    json_path,
    dataframe = "rows",
    auto_unbox = TRUE,
    pretty = TRUE,
    na = "null"
  )
  tryCatch(
    readr::write_excel_csv2(rows, csv_path, na = ""),
    error = function(e) {
      stop(
        "Impossible d'ecrire le CSV Excel. Fermez le fichier dans Excel/RStudio ",
        "puis relancez. Detail: ",
        conditionMessage(e),
        call. = FALSE
      )
    }
  )
}

main <- function() {
  cli <- parse_cli(commandArgs(trailingOnly = TRUE))
  repo_root <- normalizePath(cli[["repo-root"]] %||% repo_root_default(), mustWork = FALSE)
  output_dir <- file.path(repo_root, "data", "manifests", "papers")

  json_path <- cli[["candidates-json"]] %||%
    file.path(output_dir, "datacite_spatial_dataset_candidates.json")
  csv_path <- cli[["candidates-csv"]] %||%
    file.path(output_dir, "datacite_spatial_dataset_candidates_excel.csv")
  report_path <- cli[["verification-json"]] %||% latest_verification_json(output_dir)

  candidates <- read_candidates(json_path, csv_path)
  report <- as.data.frame(
    jsonlite::fromJSON(report_path, simplifyVector = TRUE),
    stringsAsFactors = FALSE
  )

  if (!"dataset_doi" %in% names(candidates)) {
    stop("La sortie harvest ne contient pas dataset_doi.")
  }
  if (!"dataset_doi" %in% names(report)) {
    stop("Le rapport de verification ne contient pas dataset_doi.")
  }

  action_col <- pick_action_column(report)
  original_names <- names(candidates)
  idx <- match(normalize_doi(candidates$dataset_doi), normalize_doi(report$dataset_doi))
  missing <- is.na(idx)
  if (any(missing)) {
    stop(
      "Certains candidats harvest sont absents du rapport de verification: ",
      paste(candidates$dataset_doi[missing], collapse = ", ")
    )
  }

  candidates$verification_action <- report[[action_col]][idx]
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_matches_objective",
    "matches_search_bib_objective",
    idx
  )
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_issues",
    "issues_found",
    idx
  )
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_duplicate_in_corpus",
    "duplicate_in_corpus",
    idx
  )
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_dataset_doi_resolves",
    "dataset_doi_resolves",
    idx
  )
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_publication_doi_resolves",
    "publication_doi_resolves",
    idx
  )
  candidates <- copy_if_present(
    candidates,
    report,
    "verification_publication_title_match",
    "publication_title_match",
    idx
  )
  candidates$verification_source <- basename(report_path)

  before <- nrow(candidates)
  rejected <- candidates[candidates$verification_action == "reject", , drop = FALSE]
  kept <- candidates[candidates$verification_action != "reject", , drop = FALSE]
  kept$candidate_status <- status_from_action(kept$verification_action)
  kept <- kept[, c(original_names, setdiff(names(kept), original_names))]

  duplicated_doi <- duplicated(normalize_doi(kept$dataset_doi))
  if (any(duplicated_doi)) {
    stop(
      "Doublons dataset_doi detectes apres apurement: ",
      paste(kept$dataset_doi[duplicated_doi], collapse = ", ")
    )
  }

  write_outputs(kept, json_path, csv_path)

  message("Verification appliquee depuis: ", report_path)
  message("Candidats avant apurement: ", before)
  message("Rejets retires: ", nrow(rejected))
  message("Candidats conserves: ", nrow(kept))
  print(table(kept$verification_action, useNA = "ifany"))
}

`%||%` <- function(x, y) {
  if (is.null(x) || length(x) == 0L) y else x
}

main()
