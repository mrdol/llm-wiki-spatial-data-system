# Curation assistee par LLM des jeux de donnees R.
#
# Principe :
# 1. lire une ligne du catalogue R brut ;
# 2. appeler inspect_dataset(package, bundle) en interne ;
# 3. envoyer la ligne du catalogue + le texte d'inspection au LLM ;
# 4. recuperer une decision JSON stricte ;
# 5. ecrire les decisions dans un JSONL dans data/manifests/datasets.
#
# Aucun nouveau dossier n'est cree.
#
# Prerequis :
# - definir ANTHROPIC_API_KEY ou OPENAI_API_KEY dans l'environnement
#   ou dans un fichier .env a la racine du depot ;
# - optionnel : definir LLM_PROVIDER=anthropic, openai ou auto ;
# - les packages jsonlite et httr2 sont installes automatiquement si absents.
#
# Exemples :
# Rscript Code_scrapping/r_catalog/llm_curate_r_datasets.R --max_rows 5
# Rscript Code_scrapping/r_catalog/llm_curate_r_datasets.R --package ade4 --bundle macon
# Rscript Code_scrapping/r_catalog/llm_curate_r_datasets.R --category Bons_candidats_spatial --max_rows 20

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

parse_args <- function(args = commandArgs(trailingOnly = TRUE)) {
  # Petit parseur d'arguments --cle valeur pour eviter une dependance CLI.
  out <- list(
    package = NA_character_,
    bundle = NA_character_,
    category = NA_character_,
    max_rows = 10L,
    dry_run = FALSE
  )

  i <- 1L
  while (i <= length(args)) {
    key <- args[[i]]

    if (key == "--dry_run") {
      out$dry_run <- TRUE
      i <- i + 1L
      next
    }

    if (i == length(args)) {
      stop("Argument sans valeur : ", key, call. = FALSE)
    }

    value <- args[[i + 1L]]

    if (key == "--package") out$package <- value
    if (key == "--bundle") out$bundle <- value
    if (key == "--category") out$category <- value
    if (key == "--max_rows") out$max_rows <- as.integer(value)

    i <- i + 2L
  }

  out
}

require_namespace <- function(pkg) {
  # Installe puis charge une dependance sans l'attacher a l'environnement global.
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(
      pkg,
      repos = "https://cloud.r-project.org"
    )
  }

  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop("Impossible d'installer ou charger le package R : ", pkg, call. = FALSE)
  }
}

install_runtime_dependencies <- function() {
  # Installe les dependances necessaires a la reproduction du script.
  # Equivalent reproductible de :
  # install.packages(c("jsonlite", "httr2"))
  needed <- c("jsonlite", "httr2")
  missing <- needed[
    !vapply(needed, requireNamespace, quietly = TRUE, FUN.VALUE = logical(1))
  ]

  if (length(missing) > 0) {
    install.packages(
      missing,
      repos = "https://cloud.r-project.org"
    )
  }

  invisible(TRUE)
}

load_dot_env <- function(path = ".env") {
  # Charge les variables d'un fichier .env simple sans afficher les secrets.
  # Format attendu : CLE=valeur, avec commentaires commencant par #.
  if (!file.exists(path)) {
    return(invisible(FALSE))
  }

  lines <- readLines(path, warn = FALSE, encoding = "UTF-8")
  lines <- trimws(lines)
  lines <- lines[nzchar(lines)]
  lines <- lines[!grepl("^#", lines)]

  for (line in lines) {
    if (!grepl("=", line, fixed = TRUE)) {
      next
    }

    key <- trimws(sub("=.*$", "", line))
    value <- trimws(sub("^[^=]*=", "", line))
    value <- sub("^['\"]", "", value)
    value <- sub("['\"]$", "", value)

    if (nzchar(key) && !nzchar(Sys.getenv(key))) {
      do.call(Sys.setenv, stats::setNames(list(value), key))
    }
  }

  invisible(TRUE)
}

json_escape_row <- function(row) {
  # Convertit une ligne de data.frame en JSON compact.
  as_list <- as.list(row)
  as_list <- lapply(as_list, function(x) {
    if (length(x) == 0 || is.na(x)) "" else as.character(x)
  })
  jsonlite::toJSON(as_list, auto_unbox = TRUE, null = "null", pretty = TRUE)
}

read_optional_csv2 <- function(path) {
  # Lit un fichier CSV2 si le pipeline enrichi l'a deja produit.
  # Si le fichier n'existe pas encore, on renvoie une table vide pour garder
  # le script compatible avec l'ancien catalogue.
  if (!file.exists(path)) {
    return(data.frame())
  }

  read.csv2(path, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
}

rows_to_json <- function(rows) {
  # Convertit une petite table de preuves en JSON lisible pour le prompt LLM.
  if (is.null(rows) || nrow(rows) == 0) {
    return("[]")
  }

  jsonlite::toJSON(rows, auto_unbox = TRUE, null = "null", pretty = TRUE)
}

filter_if_columns_exist <- function(rows, conditions) {
  # Filtre seulement si les colonnes attendues existent.
  # Cela evite de casser la curation LLM quand les fichiers enrichis n'ont pas
  # encore ete generes.
  if (nrow(rows) == 0 || !all(names(conditions) %in% names(rows))) {
    return(data.frame())
  }

  keep <- rep(TRUE, nrow(rows))
  for (column in names(conditions)) {
    keep <- keep & rows[[column]] == conditions[[column]]
  }
  rows[keep, , drop = FALSE]
}

supplemental_context_for_row <- function(row, repo_root) {
  # Rassemble les preuves produites par le pipeline enrichi :
  # - profil de documentation Rd ;
  # - objets auxiliaires associes au main_object ;
  # - profil complet des objets du bundle.
  package <- as.character(row$package)
  bundle <- as.character(row$bundle)
  main_object <- as.character(row$main_object)
  manifest_dir <- file.path(repo_root, "data", "manifests", "datasets")

  docs <- read_optional_csv2(file.path(manifest_dir, "software_r_documentation_profiles.csv"))
  aux_links <- read_optional_csv2(file.path(manifest_dir, "software_r_bundle_auxiliary_links.csv"))
  profiles <- read_optional_csv2(file.path(manifest_dir, "software_r_bundle_profiles.csv"))

  doc_rows <- filter_if_columns_exist(docs, list(package = package, bundle = bundle))
  aux_rows <- filter_if_columns_exist(
    aux_links,
    list(package = package, bundle = bundle, main_object = main_object)
  )
  profile_rows <- filter_if_columns_exist(profiles, list(package = package, bundle = bundle))

  paste(
    "Documentation structuree du bundle :",
    rows_to_json(doc_rows),
    "",
    "Liens main_object -> auxiliaires :",
    rows_to_json(aux_rows),
    "",
    "Profil de tous les objets du bundle :",
    rows_to_json(profile_rows),
    sep = "\n"
  )
}

inspection_text_for_row <- function(row) {
  # Appelle inspect_dataset() et recupere sa sortie console comme texte.
  package <- as.character(row$package)
  bundle <- as.character(row$bundle)

  txt <- capture.output(
    inspect_dataset(package, bundle),
    type = "output"
  )

  paste(txt, collapse = "\n")
}

build_curation_prompt <- function(catalog_row_json, inspection_text, supplemental_context = "") {
  # Prompt contraint : le LLM doit seulement juger a partir des informations
  # fournies et retourner un JSON valide.
  paste(
    "Tu es un curateur de jeux de donnees pour modelisation spatiale, spatio-temporelle et machine learning.",
    "",
    "Tu dois comparer la ligne actuelle du catalogue avec l'inspection R du dataset.",
    "N'utilise que les informations fournies. N'invente aucune metadonnee.",
    "",
    "Regles de decision :",
    "- Un objet sf ou Spatial est spatial.",
    "- Des colonnes x/y ne sont des coordonnees que si la documentation, la classe de l'objet ou le contexte spatial le confirme.",
    "- Une colonne country/state/city/region/name rend la geometrie reconstructible, mais pas directement presente.",
    "- Une variable nommee Time, year, date ou similaire ne suffit pas a classer un dataset comme temporel.",
    "- Pour classer un dataset comme temporel, il faut une dimension temporelle documentee, des dates reelles, des annees repetees, une serie chronologique ou une structure panel explicite.",
    "- Un dataset ne peut pas etre spatio-temporel si aucune dimension spatiale n'est presente, reconstructible ou documentee.",
    "- Si le dataset a seulement une variable appelee Time sans preuve de dimension temporelle, mets is_spatiotemporal=false et explique le doute.",
    "- Un objet nb/listw/poids/voisinage est auxiliaire.",
    "- Si n < 5, recommander a_eliminer sauf si l'objet est clairement un auxiliaire.",
    "- Si la geometrie est presente mais qu'il y a trop peu de variables, recommander spatial_simple.",
    "- Si le dataset n'est pas spatial mais a assez de variables, recommander ml_non_spatial.",
    "- Si le dataset est une geometrie, un masque, un reseau ou une table support, recommander declasser_auxiliaire.",
    "- Si l'inspection contredit le catalogue, explique la contradiction.",
    "- Si tu n'es pas sur, recommande a_revoir.",
    "",
    "Categories autorisees :",
    "bon_candidat_spatial, spatial_simple, geometry_reconstructible, ml_non_spatial, declasser_auxiliaire, a_eliminer, a_revoir",
    "",
    "Retourne uniquement un JSON strict avec les champs :",
    "{",
    '  "package": "",',
    '  "bundle": "",',
    '  "main_object": "",',
    '  "catalogue_correct": true,',
    '  "is_spatial": false,',
    '  "is_spatiotemporal": false,',
    '  "geometry_status": "present|coordinates|reconstructible|absent|auxiliary|unclear",',
    '  "has_valid_coordinates": false,',
    '  "coordinate_columns": [],',
    '  "geometry_reconstructible": false,',
    '  "place_identifier_quality": "none|weak|usable|strong|unclear",',
    '  "usable_predictor_count": 0,',
    '  "target_candidates": [],',
    '  "recommended_category": "a_revoir",',
    '  "reason": "",',
    '  "confidence": "low|medium|high"',
    "}",
    "",
    "Ligne actuelle du catalogue :",
    catalog_row_json,
    "",
    "Preuves structurees ajoutees par le pipeline enrichi :",
    supplemental_context,
    "",
    "Inspection R :",
    inspection_text,
    sep = "\n"
  )
}

extract_json_object <- function(text) {
  # Nettoie une reponse LLM et extrait le premier objet JSON.
  text <- gsub("^```json\\s*", "", text)
  text <- gsub("^```\\s*", "", text)
  text <- gsub("\\s*```$", "", text)

  start <- regexpr("\\{", text)
  end_positions <- gregexpr("\\}", text)[[1]]

  if (start[[1]] < 0 || length(end_positions) == 0 || end_positions[[1]] < 0) {
    stop("Aucun objet JSON trouve dans la reponse LLM.", call. = FALSE)
  }

  end <- tail(end_positions, 1)
  substr(text, start[[1]], end)
}

call_anthropic_llm <- function(prompt) {
  # Appelle l'API Anthropic Messages avec la cle ANTHROPIC_API_KEY.
  # Les valeurs peuvent etre changees par variables d'environnement :
  # - ANTHROPIC_API_URL
  # - ANTHROPIC_MODEL
  require_namespace("httr2")
  require_namespace("jsonlite")

  api_key <- Sys.getenv("ANTHROPIC_API_KEY")
  if (!nzchar(api_key)) {
    stop("ANTHROPIC_API_KEY n'est pas defini dans l'environnement.", call. = FALSE)
  }

  api_url <- Sys.getenv(
    "ANTHROPIC_API_URL",
    unset = "https://api.anthropic.com/v1/messages"
  )
  model <- Sys.getenv("ANTHROPIC_MODEL", unset = "claude-sonnet-4-20250514")

  body <- list(
    model = model,
    max_tokens = 1200,
    temperature = 0,
    system = "Tu retournes uniquement du JSON valide, sans markdown.",
    messages = list(
      list(
        role = "user",
        content = prompt
      )
    )
  )

  response <- httr2::request(api_url) |>
    httr2::req_headers(
      "x-api-key" = api_key,
      "anthropic-version" = "2023-06-01",
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  status <- httr2::resp_status(response)
  if (status >= 400) {
    body_text <- httr2::resp_body_string(response)
    stop(
      sprintf(
        "Anthropic API HTTP %s. Modele demande : %s. Endpoint : %s. Reponse : %s",
        status,
        model,
        api_url,
        substr(body_text, 1, 800)
      ),
      call. = FALSE
    )
  }

  parsed <- httr2::resp_body_json(response, simplifyVector = FALSE)
  paste(vapply(parsed$content, function(part) {
    if (!is.null(part$text)) {
      part$text
    } else {
      ""
    }
  }, character(1)), collapse = "\n")
}

call_openai_llm <- function(prompt) {
  # Appelle une API compatible OpenAI Chat Completions en secours.
  # Les valeurs peuvent etre changees par variables d'environnement :
  # - LLM_API_URL
  # - OPENAI_MODEL
  require_namespace("httr2")
  require_namespace("jsonlite")

  api_key <- Sys.getenv("OPENAI_API_KEY")
  if (!nzchar(api_key)) {
    stop("OPENAI_API_KEY n'est pas defini dans l'environnement.", call. = FALSE)
  }

  api_url <- Sys.getenv(
    "LLM_API_URL",
    unset = "https://api.openai.com/v1/chat/completions"
  )
  model <- Sys.getenv("OPENAI_MODEL", unset = "gpt-4.1-mini")

  body <- list(
    model = model,
    temperature = 0,
    messages = list(
      list(
        role = "system",
        content = "Tu retournes uniquement du JSON valide, sans markdown."
      ),
      list(
        role = "user",
        content = prompt
      )
    )
  )

  response <- httr2::request(api_url) |>
    httr2::req_headers(
      Authorization = paste("Bearer", api_key),
      "Content-Type" = "application/json"
    ) |>
    httr2::req_body_json(body, auto_unbox = TRUE) |>
    httr2::req_error(is_error = function(resp) FALSE) |>
    httr2::req_perform()

  status <- httr2::resp_status(response)
  if (status >= 400) {
    body_text <- httr2::resp_body_string(response)
    stop(
      sprintf(
        "OpenAI API HTTP %s. Modele demande : %s. Endpoint : %s. Reponse : %s",
        status,
        model,
        api_url,
        substr(body_text, 1, 800)
      ),
      call. = FALSE
    )
  }

  parsed <- httr2::resp_body_json(response, simplifyVector = FALSE)
  parsed$choices[[1]]$message$content
}

call_llm <- function(prompt) {
  # Charge les cles depuis .env et choisit le fournisseur LLM.
  # En mode auto, Claude est essaye d'abord, puis OpenAI en secours.
  load_dot_env(".env")

  provider <- tolower(Sys.getenv("LLM_PROVIDER", unset = "auto"))
  has_anthropic <- nzchar(Sys.getenv("ANTHROPIC_API_KEY"))
  has_openai <- nzchar(Sys.getenv("OPENAI_API_KEY"))

  if (provider == "anthropic") {
    return(call_anthropic_llm(prompt))
  }

  if (provider == "openai") {
    return(call_openai_llm(prompt))
  }

  if (!provider %in% c("auto", "")) {
    stop(
      "LLM_PROVIDER doit valoir auto, anthropic ou openai.",
      call. = FALSE
    )
  }

  if (has_anthropic) {
    anthropic_answer <- tryCatch(
      call_anthropic_llm(prompt),
      error = function(err) err
    )

    if (!inherits(anthropic_answer, "error")) {
      return(anthropic_answer)
    }

    if (!has_openai) {
      stop(conditionMessage(anthropic_answer), call. = FALSE)
    }

    warning(
      paste(
        "Anthropic indisponible, bascule vers OpenAI.",
        conditionMessage(anthropic_answer)
      ),
      call. = FALSE
    )
  }

  if (has_openai) {
    return(call_openai_llm(prompt))
  }

  stop(
    paste(
      "Aucune cle API trouvee.",
      "Definis ANTHROPIC_API_KEY ou OPENAI_API_KEY dans .env ou dans l'environnement."
    ),
    call. = FALSE
  )
}

curate_one_row <- function(row, repo_root, dry_run = FALSE) {
  # Produit la decision LLM pour une ligne du catalogue.
  catalog_row_json <- json_escape_row(row)
  inspection_text <- inspection_text_for_row(row)
  supplemental_context <- supplemental_context_for_row(row, repo_root)
  prompt <- build_curation_prompt(catalog_row_json, inspection_text, supplemental_context)

  if (dry_run) {
    return(list(
      package = as.character(row$package),
      bundle = as.character(row$bundle),
      prompt = prompt
    ))
  }

  raw_answer <- call_llm(prompt)
  json_text <- extract_json_object(raw_answer)
  decision <- jsonlite::fromJSON(json_text, simplifyVector = FALSE)
  decision$raw_llm_answer <- raw_answer
  decision
}

append_jsonl <- function(path, object) {
  # Ajoute une decision a un fichier JSONL existant dans manifests/datasets.
  line <- jsonlite::toJSON(object, auto_unbox = TRUE, null = "null")
  cat(line, "\n", file = path, append = TRUE, sep = "")
}

main <- function() {
  args <- parse_args()

  install_runtime_dependencies()
  require_namespace("jsonlite")
  require_namespace("httr2")

  repo_root <- find_repo_root()
  setwd(repo_root)
  load_dot_env(".env")

  source(file.path("Code_scrapping", "r_catalog", "Inspection_of_each_dataset.R"), encoding = "UTF-8")

  catalog_path <- file.path(
    "data",
    "manifests",
    "datasets",
    "software_r_catalog_main_datasets.csv"
  )
  output_path <- file.path(
    "data",
    "manifests",
    "datasets",
    "software_r_llm_curation_decisions.jsonl"
  )

  catalog <- read.csv2(catalog_path, stringsAsFactors = FALSE, fileEncoding = "UTF-8")

  if (!is.na(args$package)) {
    catalog <- catalog[catalog$package == args$package, , drop = FALSE]
  }

  if (!is.na(args$bundle)) {
    catalog <- catalog[catalog$bundle == args$bundle, , drop = FALSE]
  }

  # Si un classeur de curation a ete exporte en CSV plat plus tard,
  # cette option pourra etre branchee dessus. Pour le catalogue brut,
  # category est volontairement ignoree si la colonne n'existe pas.
  if (!is.na(args$category) && "curation_decision" %in% names(catalog)) {
    catalog <- catalog[catalog$curation_decision == args$category, , drop = FALSE]
  }

  if (nrow(catalog) == 0) {
    stop("Aucune ligne a curer avec les filtres fournis.", call. = FALSE)
  }

  catalog <- head(catalog, args$max_rows)

  if (args$dry_run) {
    result <- curate_one_row(catalog[1, , drop = FALSE], repo_root, dry_run = TRUE)
    cat(result$prompt)
    return(invisible(result))
  }

  for (i in seq_len(nrow(catalog))) {
    row <- catalog[i, , drop = FALSE]
    cat(
      "\nCuration LLM :",
      row$package,
      "::",
      row$bundle,
      "(",
      i,
      "/",
      nrow(catalog),
      ")\n"
    )

    decision <- tryCatch({
      curate_one_row(row, repo_root, dry_run = FALSE)
    }, error = function(err) {
      list(
        package = as.character(row$package),
        bundle = as.character(row$bundle),
        main_object = as.character(row$main_object),
        recommended_category = "a_revoir",
        reason = paste("Erreur pendant la curation LLM :", conditionMessage(err)),
        confidence = "low"
      )
    })

    append_jsonl(output_path, decision)
  }

  cat("\nDecisions ecrites dans :", output_path, "\n")
}

if (sys.nframe() == 0) {
  main()
}
