## -----------------------------------------------------------------------
## harvest_warehouse_datasets.R
##
## Bloc 3 du roadmap projet : entrepots/portails (Zenodo, Dryad, figshare,
## Dataverse...) SANS exiger de papier associe. Contrairement au Bloc 2
## (harvest_datacite.R), on ne cherche pas a verifier une formule publiee
## dans un article - le dataset est juge sur ses propres merites structurels :
## une dimension spatiale (coordonnees/CRS/geometrie) et une table
## observation x variable ou une reponse et des covariables sont
## identifiables (PAS uniquement du raster/imagerie brut).
##
## Reutilise l'infrastructure de harvest_datacite.R (requetes DataCite,
## lexiques, heuristiques de filtrage) via source() - le garde-fou
## `if (sys.nframe() == 0L)` de ce fichier empeche le harvest Bloc 2 de se
## relancer automatiquement quand on le source ici.
##
## Sortie : data/manifests/papers/warehouse_dataset_candidates.json (piste
## separee du Bloc 2, ne pollue pas datacite_spatial_dataset_candidates.json)
## -----------------------------------------------------------------------

suppressPackageStartupMessages({
  library(httr2)
  library(jsonlite)
  library(dplyr)
  library(purrr)
  library(tibble)
  library(stringr)
  library(tidyr)
  library(readr)
})

script_path <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0L) {
    return(normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = FALSE))
  }
  normalizePath(file.path(getwd(), "tools", "harvest_warehouse_datasets.R"), mustWork = FALSE)
}

REPO_ROOT <- normalizePath(file.path(dirname(script_path()), ".."), mustWork = FALSE)

## Source le Bloc 2 pour reutiliser ses fonctions (datacite_search,
## flatten_record, screen_candidate_rows, dedupe_candidate_rows, les lexiques
## et regex de filtrage...). Le bloc d'execution automatique en bas de ce
## fichier ne se declenche pas quand on le source (sys.nframe() > 0 ici).
source(file.path(REPO_ROOT, "tools", "harvest_datacite.R"), chdir = FALSE)

TARGET_CANDIDATES_WAREHOUSE <- 150L
OPENALEX_ENRICH_LIMIT_WAREHOUSE <- 400L

OUTPUT_JSON_WAREHOUSE <- file.path(
  REPO_ROOT, "data", "manifests", "papers", "warehouse_dataset_candidates.json"
)
OUTPUT_EXCEL_CSV_WAREHOUSE <- file.path(
  REPO_ROOT, "data", "manifests", "papers", "warehouse_dataset_candidates_excel.csv"
)

harvest_warehouse <- function(min_citations = 0L,
                              target_candidates = TARGET_CANDIDATES_WAREHOUSE,
                              verbose = TRUE,
                              existing_path = PATH_EXISTING) {
  # min_citations = 0 : sans papier associe, le critere de citation de
  # l'article parent n'a pas de sens - on ne filtre pas dessus.
  old_limit <- OPENALEX_ENRICH_LIMIT
  on.exit(assign("OPENALEX_ENRICH_LIMIT", old_limit, envir = .GlobalEnv), add = TRUE)
  assign("OPENALEX_ENRICH_LIMIT", OPENALEX_ENRICH_LIMIT_WAREHOUSE, envir = .GlobalEnv)

  harvest(
    min_citations = min_citations,
    target_candidates = target_candidates,
    verbose = verbose,
    existing_path = existing_path,
    require_parent = FALSE
  )
}

merge_warehouse_outputs <- function(new_rows, existing_path = OUTPUT_EXCEL_CSV_WAREHOUSE) {
  old_rows <- read_existing_candidates(existing_path)
  combined <- bind_rows(old_rows, new_rows) |> screen_candidate_rows()
  dedupe_candidate_rows(combined)
}

write_warehouse_outputs <- function(rows) {
  dir.create(dirname(OUTPUT_EXCEL_CSV_WAREHOUSE), recursive = TRUE, showWarnings = FALSE)
  tryCatch(
    readr::write_excel_csv2(rows, OUTPUT_EXCEL_CSV_WAREHOUSE, na = ""),
    error = function(e) {
      stop(
        "Impossible d'ecrire la sortie CSV Excel. Fermez le fichier dans Excel puis relancez. Chemin : ",
        OUTPUT_EXCEL_CSV_WAREHOUSE,
        call. = FALSE
      )
    }
  )
  jsonlite::write_json(rows, OUTPUT_JSON_WAREHOUSE, dataframe = "rows", auto_unbox = TRUE, pretty = TRUE)
  invisible(rows)
}

if (sys.nframe() == 0L) {
  new_res <- harvest_warehouse(target_candidates = TARGET_CANDIDATES_WAREHOUSE)
  res <- merge_warehouse_outputs(new_res, existing_path = OUTPUT_EXCEL_CSV_WAREHOUSE)
  write_warehouse_outputs(res)
  message("Nouveaux candidats entrepot (Bloc 3) du run : ", nrow(new_res))
  message("Candidats entrepot cumules dedoublonnes : ", nrow(res))
  message("CSV Excel : ", OUTPUT_EXCEL_CSV_WAREHOUSE)
  message("JSON : ", OUTPUT_JSON_WAREHOUSE)
  print(head(res, 20))
}
