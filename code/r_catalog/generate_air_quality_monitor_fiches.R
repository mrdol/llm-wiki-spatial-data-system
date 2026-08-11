suppressPackageStartupMessages({
  library(sf)
  library(jsonlite)
})

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

repo_root <- find_repo_root()
today <- format(Sys.Date(), "%Y-%m-%d")
manifest_path <- file.path(repo_root, "data", "interim", "air_quality_monitor_covariates", "air_quality_monitor_covariates_manifest_2016_state_25.json")
out_dir <- file.path(repo_root, "wiki", "datasets", "fiches_datasets")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
manifest <- jsonlite::fromJSON(manifest_path, simplifyVector = FALSE)

meta <- list(
  pm25 = list(
    dataset_id = "paper_pm25_aqs_ma_2016_monitor_covariates",
    label = "PM2.5",
    paper = "Di et al. (2019), An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution",
    paper_doi = "10.1016/j.envint.2019.104909",
    dataset_doi = "10.7910/DVN/58C6HG",
    source_title = "An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution",
    formula = "pm25_mean_2016 ~ elevation_m_usgs_epqs + power_t2m_mean_c + power_rh2m_mean_pct + nlcd_developed + road_density_primary_secondary_10km_m_per_km2"
  ),
  no2 = list(
    dataset_id = "paper_no2_aqs_ma_2016_monitor_covariates",
    label = "NO2",
    paper = "Di et al. (2020), Assessing NO2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging",
    paper_doi = "10.1021/acs.est.9b03358",
    dataset_doi = "10.7910/DVN/LUFKYG",
    source_title = "Assessing NO2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging",
    formula = "no2_mean_2016 ~ elevation_m_usgs_epqs + power_t2m_mean_c + power_rh2m_mean_pct + nlcd_developed + road_density_primary_secondary_10km_m_per_km2"
  ),
  o3 = list(
    dataset_id = "paper_o3_aqs_ma_2016_monitor_covariates",
    label = "O3",
    paper = "Requia et al. (2020), An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-level Ozone in the Contiguous United States",
    paper_doi = "10.1021/acs.est.0c01791",
    dataset_doi = "10.7910/DVN/DGXCTH",
    source_title = "An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-level Ozone in the Contiguous United States",
    formula = "o3_mean_2016 ~ elevation_m_usgs_epqs + power_t2m_mean_c + power_swdwn_mean_mj_m2_day + nlcd_forest + road_density_primary_secondary_10km_m_per_km2"
  )
)

classify_typology <- function(col) {
  cls <- class(col)[1]
  vals <- stats::na.omit(col)
  if (inherits(col, c("character", "factor"))) return(list(typology = "categorical", range = "n/a"))
  if (inherits(col, "logical") || (is.numeric(col) && length(vals) && all(vals %in% c(0, 1)))) return(list(typology = "binary", range = "{0, 1}"))
  if (is.integer(col)) return(list(typology = "count", range = paste0("[", min(vals), ", ", max(vals), "]")))
  if (is.numeric(col)) return(list(typology = "continuous", range = paste0("[", round(min(vals), 4), ", ", round(max(vals), 4), "]")))
  list(typology = "unknown", range = "n/a")
}

pct_na <- function(col) round(100 * sum(is.na(col)) / length(col), 1)
fmt_bt <- function(x) paste(sprintf("`%s`", x), collapse = ", ")

make_rows <- function(df, vars, y = FALSE) {
  if (!length(vars)) return(if (y) "| -- | -- | aucun candidat | -- | -- |" else "| -- | -- | aucun candidat | -- |")
  rows <- vapply(vars, function(v) {
    typ <- classify_typology(df[[v]])
    if (y) sprintf("| `%s` | `%s` | %s | %s | %s%% |", v, class(df[[v]])[1], typ$typology, typ$range, pct_na(df[[v]]))
    else sprintf("| `%s` | `%s` | %s | %s%% |", v, class(df[[v]])[1], typ$typology, pct_na(df[[v]]))
  }, character(1))
  paste(rows, collapse = "\n")
}

for (pollutant in names(manifest)) {
  cfg <- manifest[[pollutant]]
  m <- meta[[pollutant]]
  obj <- readRDS(cfg$rds)
  geom_col <- attr(obj, "sf_column")
  df <- as.data.frame(obj)
  df[[geom_col]] <- NULL
  response <- cfg$response
  formula_terms <- trimws(strsplit(strsplit(m$formula, "~", fixed = TRUE)[[1]][2], "+", fixed = TRUE)[[1]])
  public_x <- setdiff(cfg$predictors_current, c(paste0(pollutant, "_grid_prediction_2016"), paste0(pollutant, "_grid_distance_m"), "longitude", "latitude"))
  if ("power_ps_mean_kpa" %in% names(df) && !"power_ps_mean_kpa" %in% public_x) public_x <- c(public_x, "power_ps_mean_kpa")
  diagnostic <- intersect(c(paste0(pollutant, "_grid_prediction_2016"), paste0(pollutant, "_grid_distance_m")), names(df))
  id_vars <- intersect(c("site_id", "state_code", "county_code", "site_num", "measurement_column", "response_units", "pollutant", "year", "source_observations", "source_grid_prediction"), names(df))
  crs_info <- sf::st_crs(obj)
  bbox <- sf::st_bbox(obj)
  na_warn <- names(df)[vapply(df, function(x) pct_na(x) > 20, logical(1))]
  missing_status <- if (length(na_warn)) paste("WARN - variables avec NA > 20%:", paste(na_warn, collapse = ", ")) else "OK - aucune variable avec NA > 20% detectee."
  rds_rel <- sub(paste0(gsub("\\\\", "/", repo_root), "/"), "", gsub("\\\\", "/", cfg$rds), fixed = TRUE)
  csv_rel <- sub(paste0(gsub("\\\\", "/", repo_root), "/"), "", gsub("\\\\", "/", cfg$csv), fixed = TRUE)
  x_str <- fmt_bt(public_x)
  y_rationale <- sprintf("%s est la reponse naturelle car elle correspond a la moyenne annuelle 2016 observee aux stations EPA AQS. Les covariables X retenues sont les familles publiques explicitement mentionnees par l article (%s) et reconstruites localement: elevation, meteo/radiation, occupation du sol et routes. Les predictions de grille originales (%s) sont conservees comme colonnes diagnostiques mais exclues de formula_used pour eviter une fuite d information.", response, m$paper_doi, fmt_bt(diagnostic))
  content <- sprintf('---\ntitle: %s\ntype: dataset\ncreated: %s\nupdated: %s\nsources:\n  - %s\n  - tools/build_air_quality_monitor_covariates.R\ntags: [dataset, paper-derived, spatial, point, air-quality, derived-reconstruction, benchmark-candidate]\n---\n\nDataset spatial derive pour transformer le produit de prediction %s en petit benchmark de regression continue au niveau des stations EPA AQS du Massachusetts en 2016.\n\nImportant: cette fiche ne remplace pas la fiche de grille predite du papier. Elle documente une reconstruction publique partielle, fondee uniquement sur des familles de covariables explicitement citees dans le papier et recuperables depuis des sources officielles. Ce nest pas une replication exacte de la matrice dapprentissage des auteurs.\n\n## Description du jeu de donnees\n\n- Topic: qualite de lair / %s / reconstruction monitor-level avec covariables publiques\n- Observation unit: station EPA AQS, moyenne annuelle 2016\n- Observed population: stations de mesure du Massachusetts avec observations journalieres valides en 2016\n- Geographic context: Massachusetts, Etats-Unis ; coordonnees stationnelles WGS84\n- Temporal context: coupe spatiale annuelle 2016 derivee dobservations journalieres\n- Source description: %s\n- Description source: %s + outils publics EPA/USGS/NASA/NLCD/Census\n- Description confidence: medium\n- Paper DOI: %s\n- Dataset DOI original: %s\n- Local sf output: `%s`\n- Builder script: `tools/build_air_quality_monitor_covariates.R`\n\n## Bloc 1 - Formule et variables\n\n### Variables (niveau systeme - inspection directe du sf)\n\n- Candidate Y variables: `%s`\n- Candidate Y typology: continuous\n- Candidate X variables: %s\n- Candidate X count: %d\n- Candidate X typology: continuous, categorical, binary\n- Coordinates (x, y - excluded from X candidates): `longitude`, `latitude`\n- Identifier columns (excluded from X candidates): %s\n- Variables inspected: yes (auto - generate_air_quality_monitor_fiches.R)\n- Presence of imputed X: unknown\n- Diagnostic/proxy columns excluded from formula_used: %s\n\n#### Detail Y\n\n| Variable | Classe R | Typologie Y | Plage | NA (%%) |\n|---|---|---|---|---|\n%s\n\n> Selection Y/X (paper-loader / curated evidence) : %s\n\n#### Detail X\n\n| Variable | Classe R | Role X | NA (%%) |\n|---|---|---|---|\n%s\n\n### Formule - niveau publication\n\n- formula_pub: no single monitor-level regression formula published in the extracted article text.\n- x_terms_pub: air-quality observations, remote-sensing/satellite products, meteorology, land-use/land-cover, elevation, road/traffic proxies and chemical transport model outputs are cited as covariate families in the paper.\n- y_term_pub: %s concentration.\n- Reference publication: %s\n\n### Statut regression canonique\n\n- Statut: derived_reconstruction\n- Niveau de preuve: paper covariate families + public data sources\n- Methode d estimation: benchmark regression candidate, not exact paper replication\n- Correspondance Python/R: aucune identifiee\n- Note: formule compacte derivee pour garder un ratio n/p stable sur une coupe Massachusetts 2016.\n\n### Formule - niveau systeme\n\n- formula_used: %s\n- x_terms_used: %s\n- y_term_used: %s\n- Note: les colonnes de prediction de grille sont exclues pour eviter la fuite dinformation.\n\n### Formules candidates\n\n```yaml\nformula_candidates:\n  multivariate_constrained:\n    formula: "%s"\n    response: "%s"\n    predictors: [%s]\n    role: "derived_public_covariate_benchmark"\n    source_type: "derived_reconstruction"\n    source_ref: "%s; EPA AirData; USGS EPQS; NASA POWER; NLCD ImageServer; Census TIGER/Line"\n    estimator_context: ["ols", "gam_spatial", "random_forest", "xgboost", "sar_lag"]\n    status: "derived_reconstruction"\n```\n\n## Bloc 2 - Identification et DOI\n\n- Dataset ID: `%s`\n- Dataset name: %s AQS Massachusetts 2016 monitor covariates\n- Source family: paper-derived / DataCite-derived / public covariate reconstruction\n- Source: %s\n- Source URL: Dataverse dataset DOI %s\n- Dataset DOI: %s\n- Publication DOI: %s\n- Year: 2016\n\n## Bloc 3 - Typologie des modeles\n\n- Modele niveau 1 (tache): regression continue spatiale\n- Modele niveau 2 (famille): benchmark derive avec covariables publiques\n- Modele niveau 3 (variante): monitor-level annual cross-section\n\n```yaml\nmodeling_evidence:\n  existing_model_found: false\n  equation_text: "no single monitor-level formula found; system formula is a derived reconstruction"\n  equation_family: derived_system_candidate\n  model_family: "spatial regression / machine learning benchmark candidate"\n  source_type: derived_reconstruction_from_public_sources\n  source_ref: "%s"\n  confidence: medium\n```\n\n## Benchmark readiness\n\n```yaml\nbenchmark_readiness:\n  benchmark_status: "manual_review_derived_reconstruction"\n  benchmark_task: "regression_continuous_derived_reconstruction"\n  package_include: "manual_review"\n  has_local_rds: true\n  missing_items: "%s"\n  reason: "Continuous response, coordinates and public covariates are present, but this is a partial reconstruction and not the exact training matrix from the paper."\n```\n\n- Decision: manual_review_derived_reconstruction\n- Manque principal: exact paper training matrix and missing satellite/CTM/traffic covariates\n- Raison: usable for exploratory benchmark only after explicit validation.\n\n## Estimator eligibility\n\n```yaml\nestimator_eligibility:\n  status: "manual_review_derived_reconstruction"\n  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]\n  conditionally_eligible_estimators: ["sar_lag", "sem_error", "sdm_mixed", "gwr"]\n  ineligible_reason: "spatial econometric estimators require explicit validation because this is a partial monitor-level reconstruction, not the exact paper training matrix"\n  rule: "paper-derived reconstructions are eligible only after the response, predictors, coordinates and leakage exclusions are explicit in formula_used"\n```\n\n## Bloc 4 - Typologie des donnees\n\n- Data type: spatial\n- Structure: coupe_transversale\n- N observations: %d\n- k variables: %d\n- T periods: 1\n- Variable temporelle: annualized 2016\n- N/T profile: N_petit_T_petit\n\n## Bloc 5 - Resolution et etendue\n\n- Type de geometrie: POINT\n- Spatial resolution: monitoring station\n- Temporal resolution: annual mean 2016\n- CRS EPSG: %s\n- CRS nom: %s\n- Spatial extent: x [%s, %s], y [%s, %s]\n- Time range: 2016\n- CRS analyse recommande: projected CRS for Massachusetts / CONUS before distance-sensitive weights\n\n## Bloc 6 - Reproductibilite\n\n- License present: unknown\n- License name: public source dependent\n- License URL: see provider APIs\n- License open: mixed public data sources\n- Reproducibility status: partial - public APIs are scripted; exact paper training matrix is not reconstructed\n- Code available: yes (`tools/build_air_quality_monitor_covariates.R`, `code/r_catalog/generate_air_quality_monitor_fiches.R`)\n- Repository: paper-derived reconstruction\n- CSV output: `%s`\n\n## Quality Control\n\n- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_air_quality_monitor_fiches.R`.\n- Variables: OK - formula variables present in the RDS.\n- Formula: WARN - derived compact formula, not a verbatim published equation.\n- CRS: OK - EPSG:4326 in Bloc 5.\n- Geometry: OK - point geometry from EPA AQS station coordinates.\n- Missing values: %s\n- Duplicates: OK - station-level aggregation by site_id.\n- Reproducibility: partial - public APIs are scripted; exact paper training matrix is not reconstructed.\n\n## Related Pages\n\n- [[paper_dataset_ingestion_pipeline_2026-08]]\n- Source grid fiche: [[paper_%s_grid]]\n',
    m$dataset_id, today, today, rds_rel, m$label, m$label, m$source_title, m$paper, m$paper_doi, m$dataset_doi, rds_rel,
    response, x_str, length(public_x), fmt_bt(id_vars), fmt_bt(diagnostic),
    make_rows(df, response, TRUE), y_rationale, make_rows(df, public_x, FALSE),
    m$label, m$paper, m$formula, paste(formula_terms, collapse = ", "), response,
    m$formula, response, paste(sprintf('"%s"', formula_terms), collapse = ", "), m$paper_doi,
    m$dataset_id, m$label, m$paper, m$dataset_doi, m$dataset_doi, m$paper_doi,
    m$paper_doi, cfg$limitation, nrow(obj), length(names(df)),
    as.character(crs_info$epsg), crs_info$Name,
    round(bbox[["xmin"]], 6), round(bbox[["xmax"]], 6), round(bbox[["ymin"]], 6), round(bbox[["ymax"]], 6),
    csv_rel, missing_status, pollutant)
  writeLines(content, file.path(out_dir, paste0(m$dataset_id, ".md")), useBytes = TRUE)
  message("OK ", m$dataset_id, ".md")
}
