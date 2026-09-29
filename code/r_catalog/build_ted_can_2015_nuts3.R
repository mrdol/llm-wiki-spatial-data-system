# =============================================================================
# build_ted_can_2015_nuts3.R
# -----------------------------------------------------------------------------
# Build a lightweight sf benchmark candidate from the TED V2.2 contract award
# notices archive. The raw unit is a TED award notice / lot / award row. The
# benchmark unit created here is NUTS3 region x year 2015.
#
# This is a warehouse-derived dataset, not paper-derived evidence: the formula
# is system-generated and documented from the administrative fields available
# in TED, not extracted from a scientific article.
# =============================================================================

suppressPackageStartupMessages({
  library(data.table)
  library(dplyr)
  library(sf)
  library(jsonlite)
})

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, "AGENTS.md")) &&
        dir.exists(file.path(current, "wiki")) &&
        dir.exists(file.path(current, "packages"))) {
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) break
    current <- parent
  }
  stop("Repo root not found.", call. = FALSE)
}

repo_root <- find_repo_root()

dataset_id <- "warehouse_ted_can_2015_nuts3"
raw_dir <- file.path(repo_root, "data", "raw", "warehouse", dataset_id)
sf_dir <- file.path(repo_root, "data", "final_datasets", "sf")
manifest_dir <- file.path(repo_root, "data", "manifests", "datasets", "warehouse")
fiche_dir <- file.path(repo_root, "wiki", "datasets", "fiches_datasets")
source_zip_external <- "C:/Users/jdoliveira/SynologyDrive/Datasets_dowloading_try/European datasets portal_datasets/TED_V2.2_CAN.zip"
source_zip <- file.path(raw_dir, "TED_V2.2_CAN.zip")
ted_member <- "TED_CAN_2015.csv"
nuts_geojson <- file.path(raw_dir, "NUTS_RG_10M_2013_4326_LEVL_3.geojson")
nuts_url <- "https://gisco-services.ec.europa.eu/distribution/v2/nuts/geojson/NUTS_RG_10M_2013_4326_LEVL_3.geojson"

dir.create(raw_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(sf_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(manifest_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(fiche_dir, recursive = TRUE, showWarnings = FALSE)

if (!file.exists(source_zip)) {
  if (!file.exists(source_zip_external)) {
    stop("TED source archive not found: ", source_zip_external, call. = FALSE)
  }
  file.copy(source_zip_external, source_zip, overwrite = FALSE)
}

if (!file.exists(nuts_geojson)) {
  message("Downloading NUTS3 2013 geometry from GISCO...")
  utils::download.file(nuts_url, nuts_geojson, mode = "wb", quiet = TRUE)
}

members <- utils::unzip(source_zip, list = TRUE)
if (!ted_member %in% members$Name) {
  stop("TED archive does not contain ", ted_member, call. = FALSE)
}

tmp_dir <- tempfile("ted_can_2015_")
dir.create(tmp_dir, recursive = TRUE)
on.exit(unlink(tmp_dir, recursive = TRUE, force = TRUE), add = TRUE)
utils::unzip(source_zip, files = ted_member, exdir = tmp_dir)
csv_path <- file.path(tmp_dir, ted_member)

cols <- c(
  "ID_NOTICE_CAN", "YEAR", "CAE_TYPE", "TYPE_OF_CONTRACT", "TAL_LOCATION_NUTS",
  "B_FRA_AGREEMENT", "B_GPA", "VALUE_EURO", "AWARD_VALUE_EURO",
  "B_ELECTRONIC_AUCTION", "NUMBER_AWARDS", "NUMBER_OFFERS",
  "B_SUBCONTRACTED", "B_EU_FUNDS", "CPV"
)

ted <- data.table::fread(
  csv_path,
  select = cols,
  encoding = "UTF-8",
  na.strings = c("", "NA", "NULL", "null")
)

raw_rows <- nrow(ted)

as_num <- function(x) suppressWarnings(as.numeric(gsub(",", ".", as.character(x), fixed = TRUE)))
is_yes <- function(x) {
  out <- toupper(trimws(as.character(x)))
  out %in% c("Y", "YES", "TRUE", "T", "1")
}

ted[, award_value_eur := as_num(AWARD_VALUE_EURO)]
ted[, estimated_value_eur := as_num(VALUE_EURO)]
ted[, number_offers := as_num(NUMBER_OFFERS)]
ted[, number_awards := as_num(NUMBER_AWARDS)]
ted[, row_id := .I]
ted[, nuts_raw := trimws(as.character(TAL_LOCATION_NUTS))]

loc <- ted[!is.na(nuts_raw) & nzchar(nuts_raw)]
loc[, nuts_item := strsplit(nuts_raw, ";|,|\\s+")]
loc <- loc[, .(nuts_code = unlist(nuts_item, use.names = FALSE)), by = row_id]
loc[, nuts_code := toupper(trimws(nuts_code))]
loc <- loc[nchar(nuts_code) == 5 & grepl("^[A-Z]{2}[A-Z0-9]{3}$", nuts_code)]
loc[, n_nuts3_in_row := .N, by = row_id]
loc[, weight := 1 / n_nuts3_in_row]

ted_loc <- merge(ted, loc, by = "row_id", allow.cartesian = TRUE)
localised_rows <- uniqueN(ted_loc$row_id)
multi_nuts_rows <- uniqueN(ted_loc[n_nuts3_in_row > 1, row_id])

ted_loc[, contract_services := as.integer(TYPE_OF_CONTRACT == "S")]
ted_loc[, contract_works := as.integer(TYPE_OF_CONTRACT == "W")]
ted_loc[, contract_supplies := as.integer(TYPE_OF_CONTRACT == "U")]
ted_loc[, eu_funds := as.integer(is_yes(B_EU_FUNDS))]
ted_loc[, framework_agreement := as.integer(is_yes(B_FRA_AGREEMENT))]
ted_loc[, gpa := as.integer(is_yes(B_GPA))]
ted_loc[, electronic_auction := as.integer(is_yes(B_ELECTRONIC_AUCTION))]
ted_loc[, subcontracted := as.integer(is_yes(B_SUBCONTRACTED))]
ted_loc[, single_bid := fifelse(!is.na(number_offers), as.integer(number_offers == 1), NA_integer_)]
ted_loc[, cpv2 := substr(gsub("[^0-9]", "", as.character(CPV)), 1, 2)]
ted_loc[, cpv45_construction := as.integer(cpv2 == "45")]
ted_loc[, cpv33_medical := as.integer(cpv2 == "33")]
ted_loc[, cpv71_arch_engineering := as.integer(cpv2 == "71")]
ted_loc[, cpv72_it_services := as.integer(cpv2 == "72")]
ted_loc[, cpv90_environment := as.integer(cpv2 == "90")]

wmean <- function(x, w) {
  ok <- !is.na(x) & !is.na(w)
  if (!any(ok)) return(NA_real_)
  sum(x[ok] * w[ok]) / sum(w[ok])
}

wsum <- function(x, w) {
  ok <- !is.na(x) & !is.na(w)
  if (!any(ok)) return(NA_real_)
  sum(x[ok] * w[ok])
}

agg <- ted_loc[, .(
  year = 2015L,
  n_award_rows = wsum(rep(1, .N), weight),
  n_source_rows = uniqueN(row_id),
  total_award_value_eur = wsum(award_value_eur, weight),
  mean_award_value_eur = wmean(award_value_eur, weight),
  total_estimated_value_eur = wsum(estimated_value_eur, weight),
  mean_number_offers = wmean(number_offers, weight),
  single_bid_share = wmean(single_bid, weight),
  mean_number_awards = wmean(number_awards, weight),
  share_services = wmean(contract_services, weight),
  share_works = wmean(contract_works, weight),
  share_supplies = wmean(contract_supplies, weight),
  share_eu_funds = wmean(eu_funds, weight),
  share_framework_agreement = wmean(framework_agreement, weight),
  share_gpa = wmean(gpa, weight),
  share_electronic_auction = wmean(electronic_auction, weight),
  share_subcontracted = wmean(subcontracted, weight),
  share_cpv45_construction = wmean(cpv45_construction, weight),
  share_cpv33_medical = wmean(cpv33_medical, weight),
  share_cpv71_arch_engineering = wmean(cpv71_arch_engineering, weight),
  share_cpv72_it_services = wmean(cpv72_it_services, weight),
  share_cpv90_environment = wmean(cpv90_environment, weight)
), by = nuts_code]

agg[, log_mean_award_value_eur := log1p(mean_award_value_eur)]
agg[, log_total_award_value_eur := log1p(total_award_value_eur)]
agg[, log_total_estimated_value_eur := log1p(total_estimated_value_eur)]

nuts <- sf::st_read(nuts_geojson, quiet = TRUE)
if (!"NUTS_ID" %in% names(nuts)) {
  stop("GISCO NUTS file has no NUTS_ID column.", call. = FALSE)
}
nuts <- nuts[nuts$LEVL_CODE == 3, c("NUTS_ID", "NAME_LATN", "CNTR_CODE", "geometry")]
names(nuts)[names(nuts) == "NUTS_ID"] <- "nuts_code"
names(nuts)[names(nuts) == "NAME_LATN"] <- "nuts_name"
names(nuts)[names(nuts) == "CNTR_CODE"] <- "country_code"

sf_obj <- dplyr::left_join(nuts, as.data.frame(agg), by = "nuts_code")
sf_obj <- sf_obj[!is.na(sf_obj$n_award_rows) & !is.na(sf_obj$log_mean_award_value_eur), ]
sf_obj <- sf_obj[!sf::st_is_empty(sf_obj), ]
sf_obj <- sf::st_make_valid(sf_obj)

formula_used <- paste(
  "log_mean_award_value_eur ~ mean_number_offers + single_bid_share +",
  "share_services + share_works + share_eu_funds + share_gpa +",
  "share_framework_agreement + share_electronic_auction +",
  "share_cpv45_construction + share_cpv71_arch_engineering +",
  "share_cpv72_it_services + share_cpv90_environment"
)

formula_variables <- c(
  "log_mean_award_value_eur",
  "mean_number_offers", "single_bid_share", "share_services", "share_works",
  "share_eu_funds", "share_gpa", "share_framework_agreement",
  "share_electronic_auction", "share_cpv45_construction",
  "share_cpv71_arch_engineering", "share_cpv72_it_services",
  "share_cpv90_environment"
)

ml_predictors <- c(
  "n_award_rows", "n_source_rows", "mean_number_offers",
  "single_bid_share", "mean_number_awards",
  "share_services", "share_works", "share_supplies", "share_eu_funds",
  "share_gpa", "share_framework_agreement", "share_electronic_auction",
  "share_subcontracted", "share_cpv45_construction", "share_cpv33_medical",
  "share_cpv71_arch_engineering", "share_cpv72_it_services",
  "share_cpv90_environment"
)

ml_formula <- paste(
  "log_mean_award_value_eur ~",
  paste(ml_predictors, collapse = " + ")
)

related_literature <- list(
  list(
    citation = "Fazekas and Czibik (2021), Measuring regional quality of government: the public spending quality index based on government contracting data, Regional Studies.",
    doi = "10.1080/00343404.2021.1902975",
    url = "https://doi.org/10.1080/00343404.2021.1902975",
    relevance = "Uses TED contract records over 2006-2015 to build regional NUTS-level public procurement indicators, including competition, transparency, efficiency and corruption-risk dimensions. This is contextual evidence for aggregating TED records by region, not direct evidence for the system formula used here."
  ),
  list(
    citation = "Government Transparency Institute (2026), National and regional annual aggregated public procurement data TED 2011-2025.",
    doi = NULL,
    url = "https://www.govtransparency.eu/national-and-regional-annual-aggregated-public-procurement-data-TED-2011-2025-version-202606/",
    relevance = "Provides annual national and regional procurement indicators from TED, including contract counts, values and competition proxies such as single-bidder shares. This supports the choice of procurement indicators but is not a replication target."
  ),
  list(
    citation = "Tatrai, Vorosmarty and Juhasz (2024), Intensifying Competition in Public Procurement, Public Organization Review.",
    doi = NULL,
    url = "https://link.springer.com/article/10.1007/s11115-023-00742-0",
    relevance = "Uses TED procurement data to study competition and number of bidders. This supports the use of NUMBER_OFFERS and single-bid indicators as meaningful procurement covariates."
  ),
  list(
    citation = "Wachs, Fazekas and Kertesz (2021), Corruption risk in contracting markets: a network science perspective, International Journal of Data Science and Analytics.",
    doi = NULL,
    url = "https://link.springer.com/article/10.1007/s41060-019-00204-1",
    relevance = "Uses TED data and single-bidder information as corruption-risk evidence in contracting markets. This is contextual evidence for competition-related variables."
  ),
  list(
    citation = "Herz and Varela-Irimia (2017), Border Effects in European Public Procurement.",
    doi = NULL,
    url = "https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2883076",
    relevance = "Uses TED contracts with NUTS3 geography in a gravity-model setting. This supports the spatial/NUTS3 nature of TED analyses, but the dyadic structure is different from the NUTS3 cross-section created here."
  )
)
regions_before_formula_complete <- nrow(sf_obj)
sf_obj <- sf_obj[stats::complete.cases(sf::st_drop_geometry(sf_obj)[formula_variables]), ]
regions_dropped_formula_na <- regions_before_formula_complete - nrow(sf_obj)

out_rds <- file.path(sf_dir, paste0(dataset_id, ".rds"))
saveRDS(sf_obj, out_rds)

extent <- sf::st_bbox(sf_obj)
manifest <- list(
  dataset_id = dataset_id,
  source_family = "warehouse-derived",
  source = "TED V2.2 contract award notices CSV subset",
  source_url = "https://data.europa.eu/data/datasets/ted-csv",
  geometry_source = "Eurostat GISCO NUTS 2013 level 3 regions",
  geometry_url = nuts_url,
  raw_archive = "data/raw/warehouse/warehouse_ted_can_2015_nuts3/TED_V2.2_CAN.zip",
  final_artifact = "data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds",
  year = 2015,
  raw_rows = raw_rows,
  rows_with_nuts3 = localised_rows,
  multi_nuts3_rows = multi_nuts_rows,
  regions_dropped_formula_na = regions_dropped_formula_na,
  n_nuts3_regions = nrow(sf_obj),
  formula_status = "system_generated_documented",
  formula_used = formula_used,
  response = "log_mean_award_value_eur",
  predictors = c(
    "mean_number_offers", "single_bid_share", "share_services", "share_works",
    "share_eu_funds", "share_gpa", "share_framework_agreement",
    "share_electronic_auction", "share_cpv45_construction",
    "share_cpv71_arch_engineering", "share_cpv72_it_services",
    "share_cpv90_environment"
  ),
  ml_formula = ml_formula,
  ml_predictors = ml_predictors,
  related_literature = related_literature,
  spatial_support = list(
    type = "NUTS3 polygons",
    crs = as.character(sf::st_crs(sf_obj)$input),
    bbox = as.list(as.numeric(extent))
  ),
  benchmark_readiness = list(
    benchmark_status = "ready_needs_review",
    benchmark_task = "continuous_regression",
    package_include = "manual_review",
    reason = paste(
      "Cross-sectional NUTS3 2015 aggregation with continuous response and",
      "multiple covariates. Not promoted automatically because it is",
      "warehouse-derived, uses an obsolete TED CSV subset for reference, and",
      "contains a system-generated formula rather than article-level evidence."
    )
  )
)

manifest_path <- file.path(manifest_dir, paste0(dataset_id, "_build_manifest.json"))
jsonlite::write_json(manifest, manifest_path, auto_unbox = TRUE, pretty = TRUE)

typology <- list(
  dataset_id = dataset_id,
  package = "warehouse:ted",
  dataset = "TED_CAN_2015_NUTS3",
  source_lang = "R",
  conversion_method = "ted_csv_2015_nuts3_aggregation",
  rds_path = "data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds",
  bloc1 = list(
    candidate_y_variables = c("log_mean_award_value_eur", "log_total_award_value_eur"),
    candidate_x_variables = manifest$predictors,
    ml_candidate_x_variables = ml_predictors,
    formula_used = formula_used,
    ml_formula = ml_formula,
    formula_status = "system_generated_documented"
  ),
  bloc4 = list(
    N = nrow(sf_obj),
    T = 1,
    T_var = "year",
    data_type = "spatial",
    structure = "coupe_transversale",
    profil_nt = paste0(ifelse(nrow(sf_obj) >= 500, "N_grand", "N_moyen"), "_T_petit")
  ),
  bloc5 = list(
    geom_type = paste(unique(as.character(sf::st_geometry_type(sf_obj))), collapse = ", "),
    crs_epsg = sf::st_crs(sf_obj)$epsg,
    bbox = as.list(as.numeric(extent))
  ),
  qc = list(
    raw_rows_without_usable_nuts3 = raw_rows - localised_rows,
    multi_nuts3_rows_equal_weighted = multi_nuts_rows,
    regions_dropped_formula_na = regions_dropped_formula_na,
    geometry_missing = FALSE,
    formula_from_publication = FALSE
  )
)
jsonlite::write_json(
  typology,
  file.path(manifest_dir, paste0(dataset_id, "_typology.json")),
  auto_unbox = TRUE,
  pretty = TRUE
)

fiche <- c(
  "---",
  "title: warehouse_ted_can_2015_nuts3",
  "type: dataset",
  paste0("created: ", Sys.Date()),
  paste0("updated: ", Sys.Date()),
  "tags: [dataset, warehouse, TED, NUTS3, public-procurement, spatial-benchmark]",
  "---",
  "",
  "# warehouse_ted_can_2015_nuts3",
  "",
  "## Description du jeu de donnees",
  "",
  "- Topic: marches publics europeens agreges au niveau NUTS3.",
  "- Observation unit: region NUTS3 en 2015.",
  "- Observed population: avis d'attribution de marches publics TED localisables par code NUTS3.",
  "- Geographic context: Europe, geometries NUTS3 GISCO 2013.",
  "- Temporal context: coupe transversale 2015.",
  "- Source description: TED V2.2 Contract Award Notices CSV subset; geometries Eurostat GISCO NUTS 2013.",
  "- Description confidence: medium.",
  "- Source URL: https://data.europa.eu/data/datasets/ted-csv",
  "- Local raw dir: data/raw/warehouse/warehouse_ted_can_2015_nuts3/",
  "- Local sf output: data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds",
  "",
  "## Bloc 1 - Formule et variables",
  "",
  "### Variables",
  "",
  paste0("- Candidate Y variables: `log_mean_award_value_eur`, `log_total_award_value_eur`."),
  "- Candidate Y typology: continuous.",
  paste0("- Candidate X variables in local artifact: `", paste(manifest$predictors, collapse = "`, `"), "`."),
  paste0("- Candidate X count in local artifact: ", length(manifest$predictors), "."),
  paste0("- ML candidate X variables in local artifact: `", paste(ml_predictors, collapse = "`, `"), "`."),
  paste0("- ML candidate X count in local artifact: ", length(ml_predictors), "."),
  "- Candidate X typology: continuous/rate.",
  "- Coordinates: polygon geometry NUTS3; coordinates are not used as X by default.",
  "- Identifier columns: `nuts_code`, `nuts_name`, `country_code`, `year`.",
  "- Variables inspected: yes, by `build_ted_can_2015_nuts3.R`.",
  "",
  paste0("> Selection Y/X (warehouse-loader / curated evidence) : Pour `", dataset_id, "`, la reponse `log_mean_award_value_eur` decrit la valeur moyenne des marches attribues par region NUTS3 apres transformation `log1p`. Les covariables X de la formule commune decrivent la concurrence (`mean_number_offers`, `single_bid_share`), la composition des contrats, les fonds europeens, les accords-cadres, l'enchere electronique et quelques familles CPV. Le bloc `ml_or_selected` expose aussi les volumes regionaux, le nombre moyen de lots attribues, les fournitures, la sous-traitance et les familles CPV supplementaires afin que les modeles machine learning puissent effectuer leur selection de variables. Les variables directement derivees de la valeur attribuee cible (`mean_award_value_eur`, `total_award_value_eur`, `log_total_award_value_eur`) et les variables incompletes restent exclues de X. Les identifiants et la geometrie sont aussi exclus. La formule est une formule systeme documentee depuis les champs TED, pas une formule publiee dans un article."),
  "",
  "### Formule - niveau publication",
  "",
  "- formula_pub: not_applicable_warehouse_source",
  "- x_terms_pub: not_applicable",
  "- y_term_pub: not_applicable",
  "- Reference publication: none. Source administrative officielle, sans papier empirique associe.",
  "- Related literature: Fazekas and Czibik (2021) use TED 2006-2015 to construct regional public spending quality indicators; GTI (2026) publishes regional annual TED indicators; other TED studies use competition indicators, single-bid proxies or NUTS3 geography. These sources support the relevance of the variables but do not make this dataset a direct paper replication.",
  "",
  "### Formule - niveau systeme",
  "",
  paste0("- formula_used: `", formula_used, "`"),
  "- x_terms_used: see Candidate X variables.",
  "- y_term_used: `log_mean_award_value_eur`.",
  "- Note: formule derivee pour produire une tache de regression continue a partir d'un entrepot officiel. Elle doit rester distinguee des formules issues d'articles scientifiques. La formule commune sert a comparer les estimateurs sur le meme X ; la formule ML complete sert a comparer des pipelines capables de selectionner automatiquement les variables.",
  "",
  "### Formules candidates",
  "",
  "```yaml",
  "formula_candidates:",
  "  univariate:",
  "    formula: \"log_mean_award_value_eur ~ mean_number_offers\"",
  "    response: \"log_mean_award_value_eur\"",
  "    predictors: [\"mean_number_offers\"]",
  "    role: \"simple_baseline\"",
  "    source_type: \"warehouse_fields\"",
  "    source_ref: \"TED CAN 2015 fields aggregated by NUTS3\"",
  "    estimator_context: [\"ols\", \"gam_spatial\", \"random_forest\", \"xgboost\", \"sar_lag\", \"sem_error\", \"sdm_mixed\"]",
  "    status: \"system_generated_documented\"",
  "",
  "  multivariate_constrained:",
  paste0("    formula: \"", formula_used, "\""),
  "    response: \"log_mean_award_value_eur\"",
  paste0("    predictors: [\"", paste(manifest$predictors, collapse = "\", \""), "\"]"),
  "    role: \"warehouse_benchmark_specification\"",
  "    source_type: \"official_administrative_source\"",
  "    source_ref: \"TED V2.2 CAN CSV fields + GISCO NUTS3 2013 geometries\"",
  "    estimator_context: [\"ols\", \"gam_spatial\", \"random_forest\", \"xgboost\", \"sar_lag\", \"sem_error\", \"sdm_mixed\"]",
  "    status: \"system_generated_documented\"",
  "",
  "  ml_or_selected:",
  paste0("    formula: \"", ml_formula, "\""),
  "    response: \"log_mean_award_value_eur\"",
  paste0("    predictors: [\"", paste(ml_predictors, collapse = "\", \""), "\"]"),
  "    role: \"ml_candidate_features\"",
  "    source_type: \"official_administrative_source\"",
  "    source_ref: \"TED V2.2 CAN CSV fields aggregated by NUTS3; broader feature set for RF/XGBoost/boosting variable selection\"",
  "    estimator_context: [\"random_forest\", \"xgboost\", \"gamboost\"]",
  "    status: \"system_generated_documented\"",
  "```",
  "",
  "### Litterature associee",
  "",
  "- Fazekas and Czibik (2021), DOI `10.1080/00343404.2021.1902975`: TED 2006-2015, indicateurs regionaux de qualite de la depense publique.",
  "- Government Transparency Institute (2026): donnees annuelles agregees TED 2011-2025 aux niveaux national et regional.",
  "- Tatrai, Vorosmarty and Juhasz (2024): analyse de la concurrence dans les marches publics a partir de TED.",
  "- Wachs, Fazekas and Kertesz (2021): risque de corruption dans les marches publics, avec usage d'indicateurs de soumission unique.",
  "- Herz and Varela-Irimia (2017): geographie NUTS3 et effets frontiere dans les marches publics europeens.",
  "",
  "Ces references sont des preuves de contexte pour l'exploitation spatiale des donnees TED. Elles ne sont pas utilisees comme formule publiee directe pour ce jeu de donnees.",
  "",
  "## Bloc 2 - Identification et source",
  "",
  "- Dataset ID: `warehouse_ted_can_2015_nuts3`",
  "- Dataset name: TED contract award notices 2015 aggregated by NUTS3",
  "- Source family: warehouse-derived",
  "- Source: Tenders Electronic Daily / data.europa.eu",
  "- Paper DOI: none",
  "- Dataset DOI: none",
  "- Source URL: https://data.europa.eu/data/datasets/ted-csv",
  "- Geometry source: Eurostat GISCO NUTS 2013 level 3",
  "- Year: 2015",
  "",
  "## Bloc 3 - Typologie des modeles",
  "",
  "- Modele niveau 1 (tache): regression continue.",
  "- Modele niveau 2 (famille): modeles globaux, modeles spatiaux avec W reconstruite depuis polygones NUTS3, modeles ML avec effets spatiaux implicites ou coordonnees optionnelles.",
  "- Modele niveau 3 (variante): OLS/GAM/RF/XGBoost/SAR/SEM/SDM selon les besoins du benchmark.",
  "",
  "## Bloc 4 - Structure N/T",
  "",
  paste0("- N: ", nrow(sf_obj), " regions NUTS3 avec information TED exploitable."),
  "- T: 1.",
  "- T variable: `year`.",
  "- Structure: coupe transversale spatiale.",
  paste0("- Raw TED rows: ", raw_rows, "."),
  paste0("- Raw rows with usable NUTS3: ", localised_rows, "."),
  paste0("- Multi-NUTS3 rows split with equal weights: ", multi_nuts_rows, "."),
  paste0("- NUTS3 regions dropped because formula variables contain NA: ", regions_dropped_formula_na, "."),
  "",
  "## Bloc 5 - Spatialisation",
  "",
  "- Geometry: NUTS3 polygons.",
  paste0("- CRS: ", sf::st_crs(sf_obj)$input, "."),
  "- W: not stored. Reconstructible from NUTS3 polygon contiguity or centroid distance in the benchmark.",
  "- CRS/geography note: NUTS 2013 geometry is used because the archive covers 2015. Mixed or lower-level NUTS strings are not assigned artificially to NUTS3.",
  "",
  "## Bloc 6 - Qualite et promotion",
  "",
  "```yaml",
  "benchmark_readiness:",
  "  benchmark_status: \"ready_needs_review\"",
  "  benchmark_task: \"continuous_regression\"",
  "  package_include: \"manual_review\"",
  "  benchmark_missing_items: []",
  "  benchmark_readiness_reason: \"Artefact sf lisible, Y continue, plusieurs X disponibles et support spatial polygonal. Revue manuelle conservee car la formule est systeme/documentee et la source TED V2.2 est une version obsolete pour reference.\"",
  "```",
  "",
  "### Quality control",
  "",
  "- Schema: Bloc 1-6 compatible.",
  "- Source caveat: TED signale ce sous-ensemble V2.2 comme obsolete / reference only; eviter les comparaisons temporelles avec d'autres annees sans controle supplementaire.",
  "- Geometry caveat: les lignes sans NUTS3 exploitable ne sont pas forcees dans une region.",
  "- Package promotion: possible apres validation humaine de la specification systeme et du poids spatial retenu."
)
writeLines(fiche, file.path(fiche_dir, paste0(dataset_id, ".md")), useBytes = TRUE)

kg_path <- file.path(repo_root, "inst", "kg", "paper_dataset_uses.json")
kg <- if (file.exists(kg_path)) jsonlite::read_json(kg_path, simplifyVector = FALSE) else list(records = list())
records <- kg$records
if (is.null(records)) records <- list()
keep <- vapply(records, function(x) {
  !identical(x$canonical_dataset_id, "dataset_candidate:warehouse:ted_can_2015_nuts3")
}, logical(1))
records <- records[keep]
records[[length(records) + 1]] <- list(
  paper_id = "dataset:warehouse:ted_can_2015_nuts3",
  bib_key = "Warehouse_TED_CAN_2015_NUTS3",
  paper_title = NULL,
  paper_doi = NULL,
  dataset_name_in_paper = "TED contract award notices 2015 aggregated by NUTS3",
  canonical_dataset_id = "dataset_candidate:warehouse:ted_can_2015_nuts3",
  target_type = "WarehouseDatasetCandidate",
  ingestion_status = "converted_to_sf",
  theme = "public procurement / regional economic activity",
  n_observations = nrow(sf_obj),
  n_covariates = length(manifest$predictors),
  source_type = "warehouse_verified_candidate",
  source_ref = "TED V2.2 contract award notices 2015 aggregated by NUTS3; GISCO NUTS 2013 polygons; related TED literature documented in the fiche, but no direct associated publication for the system formula.",
  source_url = "https://data.europa.eu/data/datasets/ted-csv",
  evidence = "Warehouse-derived spatial cross-section built from official TED administrative records.",
  evidence_page = NULL,
  estimators_used = c("ols", "gam_spatial", "random_forest", "xgboost", "sar_lag", "sem_error", "sdm_mixed"),
  cv_scheme = NULL,
  formula = formula_used,
  spatial_characterization = "NUTS3 polygon support; W reconstructible by contiguity or centroid distance.",
  confidence = "medium",
  dataset_doi = NULL,
  data_access_url = "https://data.europa.eu/data/datasets/ted-csv",
  license_name = NULL,
  publisher = "European Union Publications Office / TED",
  local_raw_dir = "data/raw/warehouse/warehouse_ted_can_2015_nuts3",
  local_sf_path = "data/final_datasets/sf/warehouse_ted_can_2015_nuts3.rds",
  local_typology_path = "data/manifests/datasets/warehouse/warehouse_ted_can_2015_nuts3_typology.json"
)
kg$records <- records
jsonlite::write_json(kg, kg_path, auto_unbox = TRUE, pretty = TRUE, null = "null")

message("TED CAN 2015 NUTS3 dataset written:")
message("  rows: ", nrow(sf_obj))
message("  rds:  ", out_rds)
message("  fiche:", file.path(fiche_dir, paste0(dataset_id, ".md")))
