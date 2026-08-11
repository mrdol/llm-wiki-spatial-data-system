## -----------------------------------------------------------------------
## harvest_datacite.R
##
## Recherche inversee "donnee -> article" pour l'alimentation du corpus
## de benchmarks de regression spatiale.
##
## Principe : au lieu de partir des articles et d'esperer que la donnee
## soit telechargeable, on part des depots (DataCite = Zenodo, Dryad,
## openICPSR, Figshare, Pangaea...) filtres sur resourceType=Dataset,
## puis on remonte vers l'article parent via relatedIdentifiers
## (relationType = IsSupplementTo / IsCitedBy / IsDescribedBy).
##
## La contrainte "donnee reellement telechargeable" est ainsi satisfaite
## par construction, et la licence recuperee est celle de la DONNEE
## (rightsList) et non celle d'un package R/Python.
##
## Sortie : un data.frame de candidats au schema spatialtidymodels_metadata_v1
## (champs partiels ; formula_pub reste a extraire par la chaine GROBID -> KG).
## -----------------------------------------------------------------------

library(httr2)
library(jsonlite)
library(dplyr)
library(purrr)
library(tibble)
library(stringr)
library(tidyr)
library(readr)

## ---- 0. Parametres -----------------------------------------------------

script_path <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0L) {
    return(normalizePath(sub("^--file=", "", file_arg[[1]]), mustWork = FALSE))
  }
  if (!is.null(sys.frames()[[1]]$ofile)) {
    return(normalizePath(sys.frames()[[1]]$ofile, mustWork = FALSE))
  }
  normalizePath(file.path(getwd(), "tools", "harvest_datacite.R"), mustWork = FALSE)
}

REPO_ROOT <- normalizePath(file.path(dirname(script_path()), ".."), mustWork = FALSE)

OPENALEX_MAILTO <- "johnny.d-oliveira@inrae.fr"  # polite pool OpenAlex
CROSSREF_MAILTO <- "johnny.d-oliveira@inrae.fr" # polite pool Crossref
UA <- "spatial-benchmark-harvester/0.1 (INRAE Ecodev)"

# Chemin du catalogue package deja integre, pour l'exclusion.
PATH_EXISTING <- file.path(
  REPO_ROOT,
  "packages", "spatialtidymodels", "inst", "metadata", "datasets.json"
)

OUTPUT_JSON <- file.path(
  REPO_ROOT,
  "data", "manifests", "papers", "datacite_spatial_dataset_candidates.json"
)

# Sortie CSV dediee a Excel en environnement francais :
# separateur `;` et BOM UTF-8.
OUTPUT_EXCEL_CSV <- file.path(
  REPO_ROOT,
  "data", "manifests", "papers", "datacite_spatial_dataset_candidates_excel.csv"
)

# Seuil de citations de l'article parent (0 = pas de filtre).
# La recherche bibliographique du projet cible prioritairement les articles
# ayant au moins 5 citations pour garder un compromis entre qualite et rappel.
MIN_CITATIONS <- 5L

# Nombre de candidats retenus que l'on veut remonter dans le manifeste final.
# Le script peut interroger plus d'enregistrements bruts, puis filtre et classe
# les resultats pour garder au maximum TARGET_CANDIDATES lignes.
TARGET_CANDIDATES <- 300L

# Nombre maximum de candidats DataCite a enrichir via OpenAlex avant le
# filtrage final. Plus cette valeur est grande, plus le rappel augmente, mais
# plus le script est long.
OPENALEX_ENRICH_LIMIT <- 1200L

SCREENING_VERSION <- "datacite_harvest_v2"

# Taille minimale du depot DataCite lorsque DataCite renseigne `sizes`.
# Les tailles inconnues passent encore le filtre, car beaucoup de depots ne
# publient pas ce champ. Le seuil evite surtout les depots "code only" de
# quelques Ko, comme un simple script sans table de donnees.
MIN_DATASET_SIZE_BYTES <- 50L * 1024L

# Pour cette passe, on vise d'abord des jeux de donnees spatiaux de
# regression/econometrie spatiale. Les jeux spatio-temporels restent utiles au
# projet, mais ils seront traites dans une passe separee.
STRICT_SPATIAL_ONLY <- FALSE

# On ne rejette pas systematiquement un candidat lorsque l'article parent n'a
# pas de version ouverte signalee par OpenAlex : cela serait trop restrictif.
# Le statut open access sert plutot a classer la priorite d'ingestion.
REQUIRE_OPEN_ACCESS_ARTICLE <- FALSE



## ---- 0b. Arguments CLI -------------------------------------------------

parse_cli_args <- function(args = commandArgs(trailingOnly = TRUE)) {
  out <- list()
  i <- 1L
  while (i <= length(args)) {
    key <- args[[i]]
    if (startsWith(key, "--")) {
      name <- sub("^--", "", key)
      value <- TRUE
      if (i < length(args) && !startsWith(args[[i + 1L]], "--")) {
        value <- args[[i + 1L]]
        i <- i + 1L
      }
      out[[name]] <- value
    }
    i <- i + 1L
  }
  out
}

cli_int <- function(args, name, default) {
  value <- args[[name]]
  if (is.null(value) || isTRUE(value)) return(default)
  parsed <- suppressWarnings(as.integer(value))
  if (is.na(parsed) || parsed <= 0L) {
    stop("Argument --", name, " invalide: ", value, call. = FALSE)
  }
  parsed
}

cli_nonnegative_int <- function(args, name, default) {
  value <- args[[name]]
  if (is.null(value) || isTRUE(value)) return(default)
  parsed <- suppressWarnings(as.integer(value))
  if (is.na(parsed) || parsed < 0L) {
    stop("Argument --", name, " invalide: ", value, call. = FALSE)
  }
  parsed
}


## ---- 1. Requetes DataCite ----------------------------------------------
## La syntaxe `query` de DataCite est un query_string Elasticsearch :
## on peut cibler des champs (titles.title, descriptions.description,
## subjects.subject) et combiner avec AND/OR/NOT.
##
## Strategie : croiser un lexique "modele spatial" avec un lexique
## "support geometrique". Le second est ce qui elimine le bruit
## (datasets acoustiques, spectro, etc. qui matchent "spatial").

lex_model <- c(
  '"spatial lag"', '"spatial error model"', '"spatial Durbin"',
  '"spatial autoregressive"', '"geographically weighted"',
  '"spatially varying coefficient"', '"spatial econometric"',
  '"hedonic price"', '"hedonic housing"', '"hedonic regression"',
  '"kriging"', '"disease mapping"', '"areal data"',
  '"conditional autoregressive"', '"INLA"', '"SPDE"'
)

lex_geom <- c(
  'shapefile', 'geopackage', 'geojson', '"spatial weights"',
  'coordinates', 'latitude', 'longitude', 'EPSG', 'CRS',
  'polygons', 'centroid'
)

# Profils thematiques : ils ajoutent des requetes ciblees au noyau spatial.
# Objectif : diversifier les domaines sans remplacer les filtres regression,
# geometrie, article parent, citations et verification LLM.
THEME_PROFILES <- list(
  core = character(),
  transport_mobility = c('transport', 'mobility', 'accessibility', 'commuting', 'transit', 'walkability'),
  energy_infrastructure = c('energy', 'electricity', 'renewable', 'solar', 'photovoltaic', 'infrastructure', 'network'),
  public_health = c('public health', 'mortality', 'disease', 'epidemiology', 'malnutrition', 'health inequality'),
  natural_hazards = c('flood', 'wildfire', 'fire', 'earthquake', 'landslide', 'natural hazard', 'risk'),
  education_inequality = c('education', 'school', 'inequality', 'income', 'poverty', 'segregation'),
  agriculture_economic = c('crop yield', 'agriculture', 'farmland', 'land value', 'farm', 'soil productivity'),
  marine_littoral = c('fishery', 'fisheries', 'marine', 'coastal', 'littoral', 'aquaculture'),
  urban_services = c('urban services', 'retail', 'commerce', 'amenity', 'facility', 'public service'),
  public_policy_governance = c('public policy', 'tax', 'fiscal', 'governance', 'municipal', 'local government')
)

DEFAULT_PROFILES <- paste(names(THEME_PROFILES), collapse = ',')

build_query <- function(model_terms, geom_terms) {
  paste0(
    "(", paste(model_terms, collapse = " OR "), ")",
    " AND ",
    "(", paste(geom_terms, collapse = " OR "), ")"
  )
}

build_loose_queries <- function(model_terms, geom_terms) {
  # Requetes de rappel: DataCite indexe inegalement les descriptions. On part
  # de la requete stricte modele AND geometrie, puis on ajoute des requetes
  # thematiques moins restrictives pour augmenter le rappel.
  c(
    build_query(model_terms, geom_terms),
    build_query(c('"geographically weighted"', '"multiscale geographically weighted"', '"GWR"', '"MGWR"'), geom_terms),
    build_query(c('"spatial lag"', '"spatial error"', '"spatial Durbin"', '"spatial econometric"', '"spatial autoregressive"'), geom_terms),
    build_query(c('"spatial random forest"', '"geographically weighted random forest"', '"geospatial machine learning"', '"spatial prediction"'), geom_terms),
    build_query(c('"kriging"', '"regression kriging"', '"spatial interpolation"'), geom_terms),
    build_query(model_terms, c("dataset", "data", "csv", "shapefile", "coordinates", "latitude", "longitude")),
    paste0(
      "(", paste(model_terms, collapse = " OR "), ")",
      " AND ",
      "(covariate OR predictor OR regression OR model OR response)"
    )
  )
}

quote_terms <- function(terms) {
  map_chr(terms, ~ if (str_detect(.x, "^[\\\"].*[\\\"]$")) .x else paste0('"', .x, '"'))
}

normalize_profiles <- function(profiles) {
  if (is.null(profiles) || !nzchar(profiles)) return("core")
  selected <- str_split(profiles, "[,;]", simplify = FALSE)[[1]] |>
    str_trim() |>
    discard(~ !nzchar(.x))
  if (length(selected) == 0L || any(selected == "all")) return(names(THEME_PROFILES))
  unknown <- setdiff(selected, names(THEME_PROFILES))
  if (length(unknown) > 0L) {
    stop(
      "Profil(s) inconnu(s): ", paste(unknown, collapse = ", "),
      ". Profils disponibles: ", paste(names(THEME_PROFILES), collapse = ", "),
      call. = FALSE
    )
  }
  unique(selected)
}

build_topic_query <- function(topic_terms, model_terms, geom_terms) {
  paste0(
    "(", paste(quote_terms(topic_terms), collapse = " OR "), ")",
    " AND ",
    "(", paste(c(model_terms, "regression", "model", "covariate", "predictor", "response"), collapse = " OR "), ")",
    " AND ",
    "(", paste(geom_terms, collapse = " OR "), ")"
  )
}

build_profile_queries <- function(profiles, model_terms, geom_terms) {
  selected <- normalize_profiles(profiles)
  queries <- character()
  if ("core" %in% selected) {
    queries <- c(queries, build_loose_queries(model_terms, geom_terms))
  }
  topic_profiles <- setdiff(selected, "core")
  topic_queries <- map_chr(topic_profiles, ~ build_topic_query(THEME_PROFILES[[.x]], model_terms, geom_terms))
  unique(c(queries, topic_queries))
}

#' Interroge l'API DataCite avec pagination par curseur.
#'
#' @param query chaine query_string Elasticsearch
#' @param page_size 1..1000
#' @param max_pages garde-fou
datacite_search <- function(query,
                            page_size = 500L,
                            max_pages = 20L,
                            resource_type = "dataset") {
  
  out <- list()
  cursor <- 1L
  
  for (i in seq_len(max_pages)) {
    
    req <- request("https://api.datacite.org/dois") |>
      req_user_agent(UA) |>
      req_url_query(
        query             = query,
        `resource-type-id`= resource_type,
        `page[size]`      = page_size,
        `page[cursor]`    = cursor
      ) |>
      req_retry(max_tries = 3, backoff = ~ 2^.x) |>
      req_throttle(rate = 30 / 60)  # 30 req/min, courtoisie
    
    resp <- req_perform(req)
    js   <- resp_body_json(resp, simplifyVector = FALSE)
    
    if (length(js$data) == 0L) break
    out[[i]] <- js$data
    
    # DataCite renvoie l'URL de page suivante ; on en extrait le curseur
    nxt <- js$links$`next`
    if (is.null(nxt)) break
    cursor <- sub(".*page%5Bcursor%5D=([^&]+).*", "\\1", nxt)
    if (identical(cursor, nxt)) break  # extraction ratee -> on s'arrete
  }
  
  flatten(out)
}

## ---- 2. Aplatissement des enregistrements ------------------------------

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0L) y else x

pluck_chr <- function(x, ..., .default = NA_character_) {
  v <- purrr::pluck(x, ..., .default = NULL)
  if (is.null(v)) .default else as.character(v)[1]
}

compact_unique <- function(x) {
  x <- x[!is.na(x) & nzchar(x)]
  unique(tolower(x))
}

normalize_datacite_doi <- function(x) {
  # DataCite/Figshare expose parfois le meme depot avec et sans suffixe
  # de version, par exemple 10.6084/m9.figshare.5645320 et ...5645320.v1.
  # Pour le criblage, on les dedoublonne au niveau de la famille DOI.
  str_replace(tolower(x %||% NA_character_), "\\.v\\d+$", "")
}

#' Extrait le DOI de l'article parent parmi les relatedIdentifiers.
#' On privilegie IsSupplementTo, puis IsDescribedBy, puis IsCitedBy.
parent_article_doi <- function(rel) {
  if (length(rel) == 0L) return(NA_character_)
  df <- map_dfr(rel, ~ tibble(
    type  = .x$relatedIdentifierType %||% NA_character_,
    rtype = .x$relationType          %||% NA_character_,
    id    = .x$relatedIdentifier     %||% NA_character_
  ))
  df <- df |> filter(type == "DOI")
  if (nrow(df) == 0L) return(NA_character_)
  prio <- c("IsSupplementTo", "IsDescribedBy", "IsCitedBy",
            "IsReferencedBy", "IsPartOf")
  df <- df |>
    mutate(rank = match(rtype, prio)) |>
    filter(!is.na(rank)) |>
    arrange(rank)
  if (nrow(df) == 0L) NA_character_ else tolower(df$id[1])
}

parse_datacite_sizes <- function(sizes) {
  size_text <- paste(unlist(sizes %||% character()), collapse = " ")
  if (!nzchar(size_text)) return(NA_real_)

  matches <- str_match_all(
    size_text,
    regex("([0-9]+(?:\\.[0-9]+)?)\\s*(bytes?|b|kb|kib|mb|mib|gb|gib)?", ignore_case = TRUE)
  )[[1]]
  if (nrow(matches) == 0L) return(NA_real_)

  values <- suppressWarnings(as.numeric(matches[, 2]))
  units <- tolower(matches[, 3] %||% "bytes")
  units[is.na(units) | units == ""] <- "bytes"
  multipliers <- case_when(
    units %in% c("gb", "gib") ~ 1024^3,
    units %in% c("mb", "mib") ~ 1024^2,
    units %in% c("kb", "kib") ~ 1024,
    TRUE ~ 1
  )
  total <- sum(values * multipliers, na.rm = TRUE)
  if (is.na(total) || total <= 0) NA_real_ else total
}

flatten_record <- function(rec) {
  a <- rec$attributes
  tibble(
    dataset_doi   = tolower(a$doi %||% NA_character_),
    title         = pluck_chr(a, "titles", 1, "title"),
    publisher     = {
      p <- a$publisher
      if (is.list(p)) (p$name %||% NA_character_) else (p %||% NA_character_)
    },
    year          = as.integer(a$publicationYear %||% NA),
    description   = pluck_chr(a, "descriptions", 1, "description"),
    license_name  = pluck_chr(a, "rightsList", 1, "rights"),
    license_uri   = pluck_chr(a, "rightsList", 1, "rightsUri"),
    formats       = paste(unlist(a$formats %||% character()), collapse = ";"),
    subjects      = paste(map_chr(a$subjects %||% list(),
                                  ~ .x$subject %||% NA_character_),
                          collapse = ";"),
    size_bytes    = parse_datacite_sizes(a$sizes),
    url           = a$url %||% NA_character_,
    publication_doi = parent_article_doi(a$relatedIdentifiers %||% list())
  )
}

## ---- 3. Filtres de qualite ---------------------------------------------

## 3a. Heuristique "geometrie presente" : le depot doit exposer soit un
## format vectoriel, soit un vocabulaire de coordonnees dans la description.
GEOM_FORMAT_RX <- regex(
  "shp|shapefile|gpkg|geopackage|geojson|kml|gml|gdb|tif|nc\\b|parquet",
  ignore_case = TRUE)

GEOM_TEXT_RX <- regex(
  "coordinate|latitude|longitude|easting|northing|epsg|crs\\b|projection|
   polygon|centroid|spatial weight|adjacency|neighbou?r",
  ignore_case = TRUE)

has_geometry <- function(formats, description, subjects) {
  str_detect(formats %||% "", GEOM_FORMAT_RX) |
    str_detect(paste(description, subjects), GEOM_TEXT_RX)
}

## 3b. Heuristique "regression identifiable" : on veut une reponse ET des
## covariables, pas un simple semis de points ou un raster nu.
REG_TEXT_RX <- regex(
  "covariate|predictor|explanatory|independent variable|dependent variable|
   response variable|regression|model matrix",
  ignore_case = TRUE)

## 3c. Licences reellement ouvertes (le point faible du corpus actuel :
## 91/98 jeux portent la licence du PACKAGE, pas celle de la donnee).
OPEN_LICENSE_RX <- regex("cc0|cc-by|cc by|public domain|odbl|etalab|open data",
                         ignore_case = TRUE)

## 3c-bis. Miroirs SciELO/figshare et depots non geres.
## Ils generent beaucoup de faux positifs : supplements automatiques,
## figures/tableaux ou depots sans API exploitable par notre pipeline.
SCIELO_MIRROR_RX <- regex("scielo\\.figshare\\.com|scielo", ignore_case = TRUE)

is_scielo_supplement_mirror <- function(url, publisher) {
  str_detect(paste(url %||% "", publisher %||% ""), SCIELO_MIRROR_RX)
}

SCIENCEDB_RX <- regex("scidb\\.cn|sciencedb\\.cn|cstr\\.cn.*sciencedb", ignore_case = TRUE)

is_sciencedb <- function(url, publisher, dataset_doi) {
  str_detect(paste(url %||% "", publisher %||% "", dataset_doi %||% ""), SCIENCEDB_RX) |
    str_detect(dataset_doi %||% "", regex("^10\\.57760/", ignore_case = TRUE))
}

passes_min_dataset_size <- function(size_bytes,
                                    min_dataset_size_bytes = MIN_DATASET_SIZE_BYTES) {
  if (is.null(min_dataset_size_bytes) || is.na(min_dataset_size_bytes) || min_dataset_size_bytes <= 0) {
    return(rep(TRUE, length(size_bytes)))
  }
  size <- suppressWarnings(as.numeric(size_bytes))
  is.na(size) | size >= min_dataset_size_bytes
}

## 3d. Heuristique stricte "benchmark de regression spatiale".
## Elle est plus exigeante que REG_TEXT_RX, sinon DataCite remonte des cartes,
## des rasters ou des jeux seulement descriptifs.
MODEL_STRONG_RX <- regex(
  "\\bOLS\\b|ordinary least squares|linear regression|regression model|
   spatial regression|spatial econometric|spatial lag|spatial error|
   spatial Durbin|\\bSAR\\b|\\bSEM\\b|\\bSDM\\b|\\bSLX\\b|
   geographically weighted regression|geographically weighted|\\bGWR\\b|\\bMGWR\\b|
   spatially varying coefficient|hedonic (price|housing|house|property|land|model|regression)|ricardian|
   Moran'?s? I|eigenvector spatial filtering|\\bESF\\b|
   random forest|xgboost|boosting|gamboost|spboost|
   spatial random forest|geographically weighted random forest|
   regression kriging",
  ignore_case = TRUE)

## 3e. Faux positifs frequents pour notre objectif actuel.
## Ces objets sont spatiaux, mais ce sont surtout des produits cartographiques,
## des rasters ou des series temporelles, pas des tables de regression spatiale
## directement exploitables pour benchmarker des estimateurs.
NON_BENCHMARK_DATA_PRODUCT_RX <- regex(
  "soil organic carbon stock|gridded|grid cells|grids from|raster|
   climate maps|atlas of|distribution atlas|land surface temperature|
   MODIS|MISR|SeaWiFS|aerosol optical depth|satellite observations|
   remote sensing|PM2\\.5 grids|network-behavior|network autoregressive|
   television|abundance, biomass|macroinvertebrate data",
  ignore_case = TRUE)

SPATIOTEMP_TEXT_RX <- regex(
  "time series|spatio-temporal|spatiotemporal|spatial-temporal|
   monthly|daily|seasonal|through time|temporal|longitudinal|
   1990-2020|1998-2016|1998-2021|2014-2017",
  ignore_case = TRUE)

## ---- 4. Enrichissement OpenAlex (citations de l'article parent) --------

openalex_work <- function(doi) {
  if (is.na(doi)) return(tibble(cited_by_count = NA_integer_,
                                article_title  = NA_character_,
                                article_venue  = NA_character_,
                                article_year   = NA_integer_,
                                article_type = NA_character_,
                                article_is_oa = NA,
                                article_oa_url = NA_character_,
                                article_landing_page_url = NA_character_))
  res <- try({
    request(paste0("https://api.openalex.org/works/doi:", doi)) |>
      req_user_agent(UA) |>
      req_url_query(mailto = OPENALEX_MAILTO) |>
      req_retry(max_tries = 3) |>
      req_throttle(rate = 100 / 60) |>
      req_perform() |>
      resp_body_json(simplifyVector = FALSE)
  }, silent = TRUE)
  
  if (inherits(res, "try-error")) {
    return(tibble(cited_by_count = NA_integer_, article_title = NA_character_,
                  article_venue = NA_character_, article_year = NA_integer_,
                  article_type = NA_character_, article_is_oa = NA,
                  article_oa_url = NA_character_,
                  article_landing_page_url = NA_character_))
  }

  is_oa <- res$open_access$is_oa %||% NA
  
  tibble(
    cited_by_count = as.integer(res$cited_by_count %||% NA),
    article_title  = res$display_name %||% NA_character_,
    article_venue  = res$primary_location$source$display_name %||% NA_character_,
    article_year   = as.integer(res$publication_year %||% NA),
    article_type = res$type %||% NA_character_,
    article_is_oa = if (is.na(is_oa)) NA else isTRUE(is_oa),
    article_oa_url = res$open_access$oa_url %||% NA_character_,
    article_landing_page_url = res$primary_location$landing_page_url %||% NA_character_
  )
}



## ---- 4b. Controle Crossref ---------------------------------------------

crossref_empty <- function() {
  tibble(
    crossref_doi_resolves = FALSE,
    crossref_title = NA_character_,
    crossref_venue = NA_character_,
    crossref_year = NA_integer_,
    crossref_type = NA_character_,
    crossref_reference_count = NA_integer_,
    crossref_is_referenced_by_count = NA_integer_
  )
}

crossref_first <- function(x) {
  if (is.null(x) || length(x) == 0L) return(NA_character_)
  if (is.list(x)) x <- unlist(x, use.names = FALSE)
  if (length(x) == 0L) return(NA_character_)
  as.character(x[[1]])
}

crossref_work <- function(doi) {
  doi <- normalize_datacite_doi(doi)
  if (is.na(doi) || !nzchar(doi)) return(crossref_empty())

  res <- try({
    encoded <- utils::URLencode(doi, reserved = TRUE)
    request(paste0("https://api.crossref.org/works/", encoded)) |>
      req_user_agent(UA) |>
      req_url_query(mailto = CROSSREF_MAILTO) |>
      req_retry(max_tries = 3) |>
      req_throttle(rate = 30 / 60) |>
      req_perform() |>
      resp_body_json(simplifyVector = FALSE)
  }, silent = TRUE)

  if (inherits(res, "try-error") || is.null(res$message)) {
    return(crossref_empty())
  }

  item <- res$message
  year <- suppressWarnings(as.integer(item$published$`date-parts`[[1]][[1]] %||% NA))

  tibble(
    crossref_doi_resolves = TRUE,
    crossref_title = crossref_first(item$title),
    crossref_venue = crossref_first(item$`container-title`),
    crossref_year = year,
    crossref_type = item$type %||% NA_character_,
    crossref_reference_count = as.integer(item$`reference-count` %||% NA),
    crossref_is_referenced_by_count = as.integer(item$`is-referenced-by-count` %||% NA)
  )
}

crossref_map <- function(dois, workers = 1L, verbose = TRUE) {
  norm_dois <- normalize_datacite_doi(dois)
  unique_dois <- unique(norm_dois[!is.na(norm_dois) & nzchar(norm_dois)])

  if (length(unique_dois) == 0L) {
    return(bind_rows(rep(list(crossref_empty()), length(dois))))
  }

  workers <- max(1L, min(as.integer(workers), length(unique_dois)))
  if (verbose) {
    message(
      "Controle Crossref sur ", length(dois), " lignes article (",
      length(unique_dois), " DOI uniques, ", workers, " worker(s))..."
    )
  }

  results <- if (workers <= 1L) {
    map(unique_dois, crossref_work)
  } else {
    cl <- parallel::makeCluster(workers)
    on.exit(parallel::stopCluster(cl), add = TRUE)
    parallel::clusterEvalQ(cl, {
      library(httr2)
      library(tibble)
      library(stringr)
      NULL
    })
    parallel::clusterExport(
      cl,
      varlist = c(
        "%||%", "normalize_datacite_doi", "crossref_empty",
        "crossref_first", "crossref_work", "UA", "CROSSREF_MAILTO"
      ),
      envir = environment()
    )
    parallel::parLapply(cl, unique_dois, crossref_work)
  }

  lookup <- bind_rows(results) |>
    mutate(publication_doi_crossref = unique_dois)

  tibble(publication_doi_crossref = norm_dois) |>
    left_join(lookup, by = "publication_doi_crossref") |>
    mutate(crossref_doi_resolves = coalesce(crossref_doi_resolves, FALSE)) |>
    select(-publication_doi_crossref)
}


## ---- 5. Exclusion du corpus deja integre -------------------------------

load_existing_keys <- function(path = PATH_EXISTING) {
  if (!file.exists(path)) return(character())
  js <- jsonlite::fromJSON(path, simplifyVector = FALSE)
  records <- js$records %||% list()

  ids <- map_chr(records, ~ .x$dataset_id %||% NA_character_)
  datasets <- map_chr(records, ~ .x$dataset %||% NA_character_)
  titles <- map_chr(records, ~ .x$title %||% NA_character_)
  dataset_dois <- map_chr(records, ~ .x$dataset_doi %||% NA_character_)
  publication_dois <- map_chr(records, ~ .x$publication_doi %||% NA_character_)

  # On garde a la fois les identifiants complets et des radicaux simples pour
  # reperer les doublons de type package::dataset, geodatasets.dataset, etc.
  radicals <- c(ids, datasets, titles) |>
    str_replace("^(Python|R)_[^_]+_", "") |>
    str_replace("\\..*$", "") |>
    str_replace("^.*_", "") |>
    str_to_lower()

  compact_unique(c(ids, datasets, titles, radicals, dataset_dois, publication_dois))
}

is_already_covered <- function(title, publication_doi, keys) {
  if (length(keys) == 0L) return(rep(FALSE, length(title)))
  hit_doi <- !is.na(publication_doi) & tolower(publication_doi) %in% keys
  usable_keys <- keys[nchar(keys) >= 5]
  toks <- str_to_lower(title %||% NA_character_)
  hit_name <- map_lgl(toks, function(t) {
    if (is.na(t) || length(usable_keys) == 0L) return(FALSE)
    any(str_detect(t, fixed(usable_keys)))
  })
  hit_doi | hit_name
}

## ---- 5b. Fusion cumulative des sorties ---------------------------------

read_existing_candidates <- function(path = OUTPUT_EXCEL_CSV) {
  if (!file.exists(path)) return(tibble())

  tryCatch(
    readr::read_csv2(path, show_col_types = FALSE, progress = FALSE),
    error = function(e) {
      warning("Impossible de lire la sortie existante : ", conditionMessage(e))
      tibble()
    }
  )
}

normalize_title_key <- function(title) {
  title |>
    str_to_lower() |>
    str_replace("^data( and code)? (from|for):\\s*", "") |>
    str_replace("^replication data( for)?:\\s*", "") |>
    str_replace_all("[^a-z0-9]+", " ") |>
    str_squish()
}

candidate_dedupe_key <- function(dataset_doi, title, data_access_url, publication_doi = NA_character_) {
  doi <- normalize_datacite_doi(dataset_doi)
  pub <- tolower(publication_doi %||% NA_character_)
  title_key <- normalize_title_key(title)
  fallback <- str_to_lower(str_squish(paste(title_key, data_access_url)))

  # DataCite expose souvent un fichier par variable, annee ou raster annexe.
  # Pour la curation bibliographique, on garde d'abord une ligne par article
  # parent ; le detail des fichiers sera inspecte lors de l'ingestion.
  ifelse(!is.na(pub) & nzchar(pub),
         pub,
         ifelse(!is.na(doi) & nzchar(doi), doi, fallback))
}

candidate_column <- function(rows, name, default = NA_character_) {
  if (name %in% names(rows)) {
    return(rows[[name]])
  }
  rep(default, nrow(rows))
}

screen_candidate_rows <- function(rows, min_dataset_size_bytes = MIN_DATASET_SIZE_BYTES) {
  if (nrow(rows) == 0L) return(rows)

  rows <- rows |>
    filter(!is_scielo_supplement_mirror(
      candidate_column(rows, "data_access_url"),
      candidate_column(rows, "publisher")
    )) |>
    filter(!is_sciencedb(
      candidate_column(rows, "data_access_url"),
      candidate_column(rows, "publisher"),
      candidate_column(rows, "dataset_doi")
    )) |>
    filter(passes_min_dataset_size(
      candidate_column(rows, "size_bytes", default = NA_real_),
      min_dataset_size_bytes
    ))
  if (nrow(rows) == 0L) return(rows)

  text_blob <- paste(
    candidate_column(rows, "title"),
    candidate_column(rows, "article_title"),
    candidate_column(rows, "article_venue"),
    candidate_column(rows, "formats"),
    candidate_column(rows, "datacite_description"),
    candidate_column(rows, "datacite_subjects"),
    candidate_column(rows, "description"),
    candidate_column(rows, "subjects"),
    candidate_column(rows, "spatial_evidence"),
    candidate_column(rows, "model_evidence")
  )

  article_is_oa <- candidate_column(rows, "article_is_oa", default = NA)
  article_is_oa <- as.logical(article_is_oa)
  existing_tier <- candidate_column(rows, "screening_tier")
  existing_version <- candidate_column(rows, "screening_version")
  current_screening <- existing_version == SCREENING_VERSION &
    !is.na(existing_tier) &
    existing_tier != "low_reject"

  rows |>
    mutate(
      flag_benchmark_model = str_detect(text_blob, MODEL_STRONG_RX) | current_screening,
      flag_non_benchmark_product = str_detect(text_blob, NON_BENCHMARK_DATA_PRODUCT_RX),
      flag_spatiotemporal = str_detect(text_blob, SPATIOTEMP_TEXT_RX),
      flag_open_article = !REQUIRE_OPEN_ACCESS_ARTICLE | coalesce(article_is_oa, FALSE),
      flag_target_scope = !flag_non_benchmark_product &
        (!STRICT_SPATIAL_ONLY | !flag_spatiotemporal),
      screening_tier = case_when(
        flag_benchmark_model & coalesce(article_is_oa, FALSE) & !flag_spatiotemporal ~ "high_open_spatial_regression",
        flag_benchmark_model & !flag_spatiotemporal ~ "medium_spatial_regression_article_not_oa",
        flag_benchmark_model & flag_spatiotemporal ~ "medium_spatiotemporal_review",
        TRUE ~ "low_reject"
      ),
      screening_flags = paste0(
        "benchmark_model=", flag_benchmark_model,
        "; article_is_oa=", coalesce(article_is_oa, FALSE),
        "; target_scope=", flag_target_scope,
        "; spatiotemporal=", flag_spatiotemporal,
        "; non_benchmark_product=", flag_non_benchmark_product,
        "; min_size_bytes=", min_dataset_size_bytes
      )
    ) |>
    filter(screening_tier != "low_reject", flag_target_scope)
}

dedupe_candidate_rows <- function(rows) {
  if (nrow(rows) == 0L) return(rows)

  screened_rank <- if ("article_is_oa" %in% names(rows)) {
    if_else(!is.na(rows$article_is_oa), 1L, 0L)
  } else {
    rep(0L, nrow(rows))
  }

  rows |>
    mutate(
      dedupe_key = candidate_dedupe_key(dataset_doi, title, data_access_url, publication_doi),
      score_rank = suppressWarnings(as.numeric(score)),
      citation_rank = suppressWarnings(as.numeric(cited_by_count)),
      screened_rank = screened_rank
    ) |>
    arrange(
      dedupe_key,
      desc(screened_rank),
      desc(coalesce(score_rank, 0)),
      desc(coalesce(citation_rank, -1))
    ) |>
    distinct(dedupe_key, .keep_all = TRUE) |>
    arrange(desc(coalesce(score_rank, 0)), desc(coalesce(citation_rank, -1))) |>
    select(-any_of(c("dedupe_key", "score_rank", "citation_rank", "screened_rank")))
}

merge_candidate_outputs <- function(new_rows,
                                    existing_path = OUTPUT_EXCEL_CSV,
                                    min_dataset_size_bytes = MIN_DATASET_SIZE_BYTES) {
  old_rows <- read_existing_candidates(existing_path)
  combined <- bind_rows(old_rows, new_rows) |>
    screen_candidate_rows(min_dataset_size_bytes = min_dataset_size_bytes)

  dedupe_candidate_rows(combined)
}

write_candidate_outputs <- function(rows) {
  dir.create(dirname(OUTPUT_EXCEL_CSV), recursive = TRUE, showWarnings = FALSE)

  # CSV compatible avec l'ouverture directe dans Excel FR. On ne cree pas de
  # copie de secours : si le fichier est ouvert dans Excel, il faut le fermer.
  tryCatch(
    readr::write_excel_csv2(rows, OUTPUT_EXCEL_CSV, na = ""),
    error = function(e) {
      stop(
        "Impossible d'ecrire la sortie CSV Excel. ",
        "Fermez le fichier dans Excel puis relancez le script. Chemin : ",
        OUTPUT_EXCEL_CSV,
        call. = FALSE
      )
    }
  )

  jsonlite::write_json(rows, OUTPUT_JSON, dataframe = "rows", auto_unbox = TRUE, pretty = TRUE)

  invisible(rows)
}

## ---- 6. Pipeline -------------------------------------------------------

harvest <- function(min_citations = MIN_CITATIONS,
                    target_candidates = TARGET_CANDIDATES,
                    openalex_enrich_limit = OPENALEX_ENRICH_LIMIT,
                    crossref_workers = 1L,
                    min_dataset_size_bytes = MIN_DATASET_SIZE_BYTES,
                    profiles = DEFAULT_PROFILES,
                    verbose = TRUE,
                    existing_path = PATH_EXISTING,
                    require_parent = TRUE) {
  
  selected_profiles <- normalize_profiles(profiles)
  if (verbose) message("Profils harvest : ", paste(selected_profiles, collapse = ", "))
  queries <- build_profile_queries(profiles, lex_model, lex_geom)
  raw <- list()
  seen_raw <- character()
  
  for (query_id in seq_along(queries)) {
    q <- queries[[query_id]]
    if (verbose) message("DataCite query ", query_id, "/", length(queries), ":\n", q)
    
    batch <- datacite_search(q)
    batch <- keep(batch, ~ {
      doi <- normalize_datacite_doi(.x$attributes$doi %||% NA_character_)
      if (is.na(doi) || doi %in% seen_raw) return(FALSE)
      seen_raw <<- c(seen_raw, doi)
      TRUE
    })
    raw <- c(raw, batch)
    if (verbose) message("  enregistrements bruts cumules : ", length(raw))
  }
  if (verbose) message("Enregistrements bruts uniques : ", length(raw))
  
  cand <- map_dfr(raw, flatten_record) |>
    mutate(dataset_doi_base = normalize_datacite_doi(dataset_doi)) |>
    distinct(dataset_doi_base, .keep_all = TRUE)
  
  cand <- cand |>
    mutate(
      screening_text_raw = paste(title, description, subjects, formats),
      flag_geometry   = has_geometry(formats, description, subjects),
      flag_regression = str_detect(paste(description, subjects), REG_TEXT_RX),
      flag_model_signal = str_detect(screening_text_raw, MODEL_STRONG_RX),
      flag_non_benchmark_product = str_detect(screening_text_raw, NON_BENCHMARK_DATA_PRODUCT_RX),
      flag_spatiotemporal = str_detect(screening_text_raw, SPATIOTEMP_TEXT_RX),
      flag_open_lic   = str_detect(paste(license_name, license_uri),
                                   OPEN_LICENSE_RX),
      flag_scielo_mirror = is_scielo_supplement_mirror(url, publisher),
      flag_sciencedb = is_sciencedb(url, publisher, dataset_doi),
      flag_priority_repo = str_detect(url %||% "",
        regex("zenodo\\.org|datadryad\\.org|figshare\\.com|dataverse\\.harvard\\.edu",
              ignore_case = TRUE)),
      has_parent      = !is.na(publication_doi)
    ) |>
    filter(!flag_scielo_mirror, !flag_sciencedb) |>
    filter(passes_min_dataset_size(size_bytes, min_dataset_size_bytes))
  
  if (verbose) {
    message("  avec geometrie   : ", sum(cand$flag_geometry, na.rm = TRUE))
    message("  avec regression  : ", sum(cand$flag_regression, na.rm = TRUE))
    message("  modele spatial   : ", sum(cand$flag_model_signal, na.rm = TRUE))
    message("  avec article lie : ", sum(cand$has_parent))
  }
  
  keep <- cand |>
    mutate(
      pre_screen_score = 0 +
        if_else(flag_geometry & flag_regression, 4, 0) +
        if_else(flag_model_signal, 4, 0) +
        if_else(flag_geometry, 2, 0) +
        if_else(flag_regression, 1, 0) +
        if_else(flag_open_lic, 1, 0) +
        if_else(flag_priority_repo, 3, 0) +
        if_else(flag_spatiotemporal, -1, 0) +
        if_else(flag_non_benchmark_product, -4, 0)
    ) |>
    filter(has_parent | !require_parent, pre_screen_score > 0) |>
    arrange(desc(pre_screen_score)) |>
    slice_head(n = openalex_enrich_limit)
  
  # Enrichissement citations (le plus couteux : on le fait apres filtrage)
  if (verbose) message("Enrichissement OpenAlex sur ", nrow(keep), " candidats...")
  enr <- map_dfr(keep$publication_doi, openalex_work)
  keep <- bind_cols(keep, enr)

  xref <- crossref_map(keep$publication_doi, workers = crossref_workers, verbose = verbose)
  keep <- bind_cols(keep, xref) |>
    mutate(
      article_title = coalesce(article_title, crossref_title),
      article_venue = coalesce(article_venue, crossref_venue),
      article_year = coalesce(article_year, crossref_year),
      article_type = coalesce(article_type, crossref_type)
    )
  
  keys <- load_existing_keys(existing_path)
  keep <- keep |>
    mutate(
      screening_text = paste(title, description, subjects, formats,
                             article_title, article_venue),
      flag_benchmark_model = str_detect(screening_text, MODEL_STRONG_RX),
      flag_non_benchmark_product = str_detect(screening_text, NON_BENCHMARK_DATA_PRODUCT_RX),
      flag_spatiotemporal = str_detect(screening_text, SPATIOTEMP_TEXT_RX),
      flag_open_article = !REQUIRE_OPEN_ACCESS_ARTICLE | coalesce(article_is_oa, FALSE),
      flag_target_scope = !flag_non_benchmark_product &
        (!STRICT_SPATIAL_ONLY | !flag_spatiotemporal),
      screening_tier = case_when(
        flag_benchmark_model & coalesce(article_is_oa, FALSE) & !flag_spatiotemporal ~ "high_open_spatial_regression",
        flag_benchmark_model & !flag_spatiotemporal ~ "medium_spatial_regression_article_not_oa",
        flag_benchmark_model & flag_spatiotemporal ~ "medium_spatiotemporal_review",
        flag_regression & coalesce(article_is_oa, FALSE) ~ "medium_open_weak_model_signal",
        TRUE ~ "low_reject"
      ),
      screening_flags = paste0(
        "benchmark_model=", flag_benchmark_model,
        "; article_is_oa=", coalesce(article_is_oa, FALSE),
        "; target_scope=", flag_target_scope,
        "; spatiotemporal=", flag_spatiotemporal,
        "; non_benchmark_product=", flag_non_benchmark_product,
        "; min_size_bytes=", min_dataset_size_bytes
      ),
      already_covered = is_already_covered(title, publication_doi, keys)
    ) |>
    filter(!already_covered) |>
    filter(is.na(cited_by_count) | cited_by_count >= min_citations) |>
    filter(screening_tier != "low_reject", flag_target_scope) |>
    mutate(selection_tier = screening_tier)

  if (verbose) {
    message("  modele spatial fort : ", sum(keep$flag_benchmark_model, na.rm = TRUE))
    message("  article OA          : ", sum(coalesce(keep$article_is_oa, FALSE), na.rm = TRUE))
    message("  dans le perimetre   : ", sum(keep$flag_target_scope, na.rm = TRUE))
    message("  candidats retenus   : ", nrow(keep))
  }
  
  # Score de priorite : on privilegie ce qui comble les trous du corpus
  # (gros n, licence ouverte, article bien cite)
  keep |>
    mutate(
      score = 0 +
        if_else(flag_open_lic, 2, 0) +
        if_else(coalesce(article_is_oa, FALSE), 2, 0) +
        if_else(flag_benchmark_model, 2, 0) +
        if_else(flag_priority_repo, 3, 0) +
        if_else(!is.na(size_bytes) & size_bytes > 5e6, 2, 0) +
        pmin(coalesce(cited_by_count, 0L) / 50, 3),
      metadata_schema = "spatialtidymodels_metadata_v1",
      discovery_source = "datacite",
      candidate_status = "needs_manual_curation",
      citation_threshold = min_citations,
      screening_version = SCREENING_VERSION,
      datacite_description = description,
      datacite_subjects = subjects,
      article_access_status = if_else(coalesce(article_is_oa, FALSE),
                                      "open_access",
                                      "not_open_or_unknown"),
      formula_status = "not_found",
      formula_pub = "pending_grobid_kg",
      data_access_url = url,
      source_url = if_else(!is.na(dataset_doi),
                           paste0("https://doi.org/", dataset_doi),
                           url),
      publication_url = coalesce(article_oa_url,
                                 if_else(!is.na(publication_doi),
                                         paste0("https://doi.org/", publication_doi),
                                         NA_character_)),
      spatial_evidence = "DataCite formats/description/subjects matched geometry heuristics",
      model_evidence = "DataCite/OpenAlex title, abstract metadata or subjects matched strict spatial regression heuristics",
      ingestion_next_step = "download data metadata, add BibTeX, fetch OA PDF if legal, run GROBID -> KG -> wiki fiche"
    ) |>
    arrange(desc(score)) |>
    mutate(output_dedupe_key = candidate_dedupe_key(dataset_doi, title, data_access_url, publication_doi)) |>
    distinct(output_dedupe_key, .keep_all = TRUE) |>
    slice_head(n = target_candidates) |>
    select(-output_dedupe_key) |>
    select(
      metadata_schema, discovery_source, candidate_status,
      selection_tier, citation_threshold,
      dataset_doi, title, publisher, year,
      datacite_description, datacite_subjects,
      publication_doi, article_title, article_venue, article_year,
      article_type, article_is_oa, article_access_status,
      crossref_doi_resolves, crossref_title, crossref_venue, crossref_year,
      crossref_type, crossref_reference_count, crossref_is_referenced_by_count,
      article_oa_url, article_landing_page_url,
      cited_by_count, license_name, license_uri, formats, size_bytes,
      data_access_url, source_url, publication_url,
      formula_status, formula_pub,
      spatial_evidence, model_evidence, ingestion_next_step,
      screening_version, screening_tier, screening_flags, score
    )
}

## ---- 7. Variantes de moissonnage ---------------------------------------
## Les depots specialises ne sont pas tous bien indexes par DataCite ;
## deux compléments utiles :

## 7a. Zenodo (API native, facettes plus fines sur le type de fichier)
zenodo_search <- function(q, size = 200L) {
  request("https://zenodo.org/api/records") |>
    req_user_agent(UA) |>
    req_url_query(q = q, type = "dataset", size = size,
                  sort = "mostrecent") |>
    req_perform() |>
    resp_body_json(simplifyVector = FALSE) |>
    purrr::pluck("hits", "hits")
}

## 7b. Dryad (fortement oriente ecologie / agronomie : comble l'axe
##     "reponse non gaussienne" et l'axe geographique Sud global)
dryad_search <- function(q, per_page = 100L) {
  request("https://datadryad.org/api/v2/search") |>
    req_user_agent(UA) |>
    req_url_query(q = q, per_page = per_page) |>
    req_perform() |>
    resp_body_json(simplifyVector = FALSE) |>
    purrr::pluck("_embedded", "stash:datasets")
}

## ---- 8. Execution ------------------------------------------------------
if (sys.nframe() == 0L) {
  cli <- parse_cli_args()
  min_citations <- cli_int(cli, "min-citations", MIN_CITATIONS)
  target_candidates <- cli_int(cli, "target", TARGET_CANDIDATES)
  openalex_limit <- cli_int(cli, "openalex-limit", OPENALEX_ENRICH_LIMIT)
  crossref_workers <- cli_int(cli, "crossref-workers", 1L)
  min_dataset_size_kb <- cli_nonnegative_int(cli, "min-dataset-size-kb", MIN_DATASET_SIZE_BYTES / 1024L)
  min_dataset_size_bytes <- as.numeric(min_dataset_size_kb) * 1024
  profiles <- cli[["profiles"]]
  if (is.null(profiles) || isTRUE(profiles)) profiles <- DEFAULT_PROFILES

  message(
    "Parametres harvest : min_citations=", min_citations,
    "; target=", target_candidates,
    "; openalex_limit=", openalex_limit,
    "; crossref_workers=", crossref_workers,
    "; min_dataset_size_kb=", min_dataset_size_kb,
    "; profiles=", profiles
  )

  new_res <- harvest(
    min_citations = min_citations,
    target_candidates = target_candidates,
    openalex_enrich_limit = openalex_limit,
    crossref_workers = crossref_workers,
    min_dataset_size_bytes = min_dataset_size_bytes,
    profiles = profiles
  )
  res <- merge_candidate_outputs(new_res, existing_path = OUTPUT_EXCEL_CSV, min_dataset_size_bytes = min_dataset_size_bytes)
  write_candidate_outputs(res)
  message("Nouveaux candidats du run : ", nrow(new_res))
  message("Candidats cumules dedoublonnes : ", nrow(res))
  message("CSV Excel : ", OUTPUT_EXCEL_CSV)
  message("JSON : ", OUTPUT_JSON)
  print(head(res, 20))
}
