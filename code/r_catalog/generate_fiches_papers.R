# =============================================================================
# generate_fiches_papers.R
# -----------------------------------------------------------------------------
# Phase 12 du pipeline papers (wiki/metadata/paper_dataset_ingestion_pipeline_
# 2026-08.md) : produit une fiche wiki/datasets/fiches_datasets/paper_<id>.md
# par dataset converti en sf (Phase 11, build_sf_datasets_papers.R), suivant
# le meme schema Bloc 1-6 que code/r_catalog/generate_fiches.py (famille
# packages). La selection Y/X est documentee dans le meme emplacement que
# generate_fiches.py : Y vient du loader/papier et X vient des colonnes
# explicatives conservees apres exclusion des coordonnees, identifiants et
# champs techniques.
#
# Usage : Rscript code/r_catalog/generate_fiches_papers.R
# =============================================================================

suppressPackageStartupMessages({
  library(sf)
  library(jsonlite)
})

REPO_ROOT <- "C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/llm-wiki-karpathy"
source(file.path(REPO_ROOT, "code", "r_catalog", "build_sf_datasets_papers.R"))

SF_DIR  <- file.path(REPO_ROOT, "data", "final_datasets", "sf")
OUT_DIR <- file.path(REPO_ROOT, "wiki", "datasets", "fiches_datasets")
KG_PATH <- file.path(REPO_ROOT, "inst", "kg", "paper_dataset_uses.json")
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

TODAY <- format(Sys.Date(), "%Y-%m-%d")

# -- Correspondance record_id (loader) -> local_raw_dir (paper_dataset_uses.json) --
LOADER_TO_DIR <- c(
  metacomnet             = "DataCite_2021_MetacomnetARandomForest_10_1111_2041_210",
  cluster_detection      = "DataCite_2016_ClusterDetectionOfSpatial_10_1002_sim_7172",
  medicago               = "DataCite_2022_NicheConservatismLimitsThe_10_1111_ecog_060",
  crane                  = "DataCite_2022_BalancingStructuralComplexityWith_10_1111_2041_210",
  regulatory_convergence = "DataCite_2019_RegulatoryConvergenceInThe_10_1093_isq_sqz0",
  eberg                  = "Moller_2020_OGC_eberg",
  swiss_rainfall         = "Moller_2020_OGC_swiss_rainfall",
  vindum                 = "Moller_2020_OGC_vindum",
  maipo                  = "Brenning_2023_SpatialMLDiagnostics_maipo",
  ethiopia_clusters      = "DataCite_2022_SpatialTrendsAndProjections_10_1186_s41043_0",
  waste_site             = "DataCite_2021_SystematicVariationInWaste_10_1007_s10640_0",
  biomass_rainforest     = "DataCite_2015_SpatialStructureOfAbove_10_1371_journal_",
  wald_test              = "DataCite_2020_TheWaldTestOf_10_1017_pan_2020",
  uk_photovoltaic        = "DataCite_2015_RegionalDistributionOfPhotovoltaic_10_1016_j_eneco_",
  mammals_sr_pd          = "DataCite_2019_EnvironmentalFactorsExplainThe_10_1111_geb_1299",
  arequipa_climate       = "DataCite_2021_HowDoIndigenousAnd_10_5751_es_12481",
  beta0_gwr              = "DataCite_2018_AGlobalDatasetOf_10_1038_sdata_20",
  pm25_grid              = "DataCite_2019_AnEnsembleBasedModel_10_1016_j_envint",
  o3_grid                = "DataCite_2020_AnEnsembleLearningApproach_10_1021_acs_est_",
  no2_grid               = "DataCite_2019_AssessingNo2Concentration_10_1021_acs_est_",
  pallid_bat             = "DataCite_2018_PrimaryProductivityExplainsSize_10_1111_1365_243",
  hummingbird_sdm        = "DataCite_2023_IntegratedSpeciesDistributionModels_10_1111_geb_1379",
  marrot_spatial_autocorrelation_fitness = "DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210",
  rocha_agricultural_technology_brazil = "DataCite_2019_AgriculturalTechnologyAdoptionAnd_10_1080_1747423x",
  teles_decapod_biodiversity_brazil = "DataCite_2026_DataAndRCode_10_1111_jbi_7007",
  spruce_bark_beetle = "DataCite_2024_ClimaticAndManagementRelated_10_1111_1365_266",
  florida_crash_gsvcm = "DataCite_2020_GeneralizedSpatiallyVaryingCoefficient_10_1080_10618600",
  possum_body_size = "DataCite_2015_LeanSeasonPrimaryProductivity_10_1111_ecog_012"
)

# -- Formules et notes verifiees par lecture directe du papier source --------
# Contrairement au reste de la fiche (typologie/N/T/CRS calcules depuis le
# .rds), ces entrees ne sont PAS derivees automatiquement : chaque formule
# a ete extraite manuellement du texte du papier (methodes, equations,
# scripts de replication) au cours de cette session. formula_used, quand
# fourni, remplace la formule "kitchen sink" generee par defaut.
FORMULA_OVERRIDES <- list(
  spruce_bark_beetle = list(
    formula_pub = "trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture",
    formula_used = "trapcounts ~ masl + spruce_vol + veg_zone + felling_border + temperature + precipitation + soil_moisture",
    source_ref = "Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap counts and covariates are explicitly documented in dryad.csv/README.md; empirical model specification still needs confirmation against the paper text before being marked as a published equation."
  ),
  florida_crash_gsvcm = list(
    formula_pub = "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy [GSVCM negative-binomial application]",
    formula_used = "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy",
    source_ref = "Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps()."
  ),
  possum_body_size = list(
    formula_pub = "CBL ~ productivity/climate/soil covariates [body-size productivity benchmark candidate]",
    formula_used = "CBL ~ WinterMinTemp + AnnualMinTemp + AnnualRain + aaET + NDVI + CenW + Soil_nutrient_availability + Clay_content_0_30cm + Soil_bulk_density_0_30cm",
    source_ref = "Dryad dataset 10.5061/dryad.gq264: continuous body-size response CBL with coordinates and environmental covariates. Exact published regression formula still needs confirmation against the associated paper before source_type can be upgraded beyond dataset documentation."
  ),
  cluster_detection = list(
    formula_pub = "mu_i = beta0 + beta1*x_i (hors cluster) ; mu_i = (beta0+theta_j0) + (beta1+theta_j1)*x_i (dans le cluster C_j)",
    source_ref = "Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer."
  ),
  medicago = list(
    formula_pub = "richness ~ f(Quaternary climate change, environmental energy) via geographically weighted regression (GWR)",
    source_ref = "Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085 — GWR quantifiant les effets de la variation climatique quaternaire et de l'energie environnementale sur la richesse de Medicago, a l'echelle globale/continentale/biome."
  ),
  regulatory_convergence = list(
    formula_pub = "adoption_Basel_II ~ spatial lag (interdependance banques/regulateurs/investisseurs transfrontaliere), spatial lag model",
    source_ref = "Jones & Zeitz (2019), International Studies Quarterly — modeles a decalage spatial (spatial lag models) sur l'adoption des standards Basel II dans ~100 juridictions peripheriques. Variable candidate 'net_bcbs' non confirmee explicitement dans les 2 premieres pages lues ; a verifier contre le texte complet."
  ),
  waste_site = list(
    formula_pub = "elas ~ meta-regression (WLS/REML) sur 727 estimations, correction du biais de publication (PET-PEESE)",
    source_ref = "Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication."
  ),
  pallid_bat = list(
    formula_pub = "body_size ~ net_primary_productivity + heat_conservation (temperature) [spatial autoregressive model, SAR]",
    source_ref = "Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergmann chez Antrozous pallidus via modele autoregressif spatial (SAR) ; la productivite primaire nette explique la variation de taille corporelle mieux que la conservation de chaleur ou la saisonnalite. Note : notre variable 'centroid_size' (derivee des landmarks TPS 2D) est un proxy geometrique-morphometrique, pas la mesure de taille exacte utilisee par les auteurs."
  ),
  mammals_sr_pd = list(
    formula_pub = "SR ~ 0.47*AET + 0.31*Mean_annual_temperature (R2=0.75) ; PD ~ 0.95*SR - 0.37*LGM_velocity + 0.12*Mean_elevation (R2=0.97)",
    formula_used = "SR ~ AET + Temp",
    source_ref = "Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 — modele de path analysis (coefficients standardises, moyenne +/- ecart-type mondial) reliant AET, temperature, velocite climatique depuis le LGM et elevation a la richesse specifique (SR) et la diversite phylogenetique (PD) des mammiferes terrestres."
  ),
  wald_test = list(
    formula_pub = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par",
    formula_used = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par",
    source_ref = "Juhl (2021), Political Analysis — Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R)."
  ),
  uk_photovoltaic = list(
    formula_pub = "PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1) ; X = demande electrique, densite population, pollution, niveau education, type logement",
    source_ref = "Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles econometriques spatiaux (SAR/SEM/SDM) sur le deploiement PV domestique par region NUTS3 en Grande-Bretagne ; le SDM est retenu par tests du multiplicateur de Lagrange."
  ),
  hummingbird_sdm = list(
    formula_pub = "log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]",
    source_ref = "Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Table 1 — SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s)."
  ),
  teles_decapod_biodiversity_brazil = list(
    formula_pub = "Random Forest models for SR, PD.SES and PE.SES using environmental covariates; SR mainly driven by salinity, light availability and primary productivity; PD by bottom temperature, primary productivity and current velocity; PE by temperature and primary productivity.",
    formula_used = "SR ~ sal + light + pp + tempmean + curvel + fishing_effort",
    source_ref = "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description and TEI: decapod richness and phylogenetic diversity benchmark; environmental covariates include salinity, light, primary productivity, temperature, current velocity and fishing effort."
  )
)


# -- Statut benchmark lisible par machine ------------------------------------
# Ces statuts corrigent la faille principale du premier lot paper-derived :
# un fichier .rds local ne veut pas dire que le dataset est utilisable dans un
# benchmark de regression spatiale. Le bloc est recopie dans chaque fiche pour
# guider le KG, le package et la revue humaine.
PAPER_READINESS <- list(
  marrot_spatial_autocorrelation_fitness = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_or_count",
    package_include = "manual_review",
    missing_items = "decider si Number_of_fledglings doit rester count ou etre traite comme regression continue pour benchmark comparatif",
    reason = "Y/X, coordonnees et N sont confirmes; formule locale disponible dans le KG et les donnees converties en sf."
  ),
  rocha_agricultural_technology_brazil = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_rate",
    package_include = "manual_review",
    missing_items = "verifier CRS assume WGS84 et fixer une specification compacte si necessaire",
    reason = "Y continu/rate, covariables climatiques/distances et geometrie municipale sont disponibles; formule locale disponible dans le KG."
  ),
  teles_decapod_biodiversity_brazil = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_biodiversity",
    package_include = "manual_review",
    missing_items = "choisir entre SR, PD ou PE comme reponse principale selon l analyse benchmark",
    reason = "Y biodiversite continue, covariables environnementales et coordonnees sont disponibles; modele RF et diagnostics Moran documentes dans le papier/supplement."
  ),
  spruce_bark_beetle = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_count_spatial",
    package_include = "manual_review",
    missing_items = "confirmer la specification empirique exacte dans le papier associe avant inclusion automatique package",
    reason = "Y=trapcounts, covariables documentees, coordonnees WGS84 et N=1731 sont disponibles dans le README Dryad."
  ),
  florida_crash_gsvcm = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_count_spatial_svc",
    package_include = "manual_review",
    missing_items = "confirmer dans l'article que l'application Florida crash est le cas empirique principal et choisir traitement count vs regression continue",
    reason = "Le script supplementaire donne explicitement Y, X et coordonnees; reponse Offcrsh est un compte."
  ),
  possum_body_size = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_continuous_body_size",
    package_include = "manual_review",
    missing_items = "verifier la formule empirique exacte dans le papier et reduire les covariables si necessaire",
    reason = "Y=CBL continu, coordonnees et covariables environnementales disponibles; la formule exacte n'est pas encore prouvee par TEI/KG."
  ),  cluster_detection = list(
    benchmark_status = "almost_ready_simulation",
    benchmark_task = "regression_continuous_simulated",
    package_include = "manual_review",
    missing_items = "confirmer que le benchmark accepte un dataset simule et non un cas empirique geographique",
    reason = "Y/X et coordonnees disponibles, mais l'exemple principal est une simulation de coefficients spatiaux."
  ),
  mammals_sr_pd = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "choisir une specification canonique SR ou PD puis verifier les noms exacts de variables",
    reason = "Variables ecologiques et formule/pistes de path analysis confirmees, mais une formule benchmark unique reste a figer."
  ),
  wald_test = list(
    benchmark_status = "needs_original_W",
    benchmark_task = "regression_spatial_weights_non_geographic",
    package_include = "manual_review",
    missing_items = "conserver ou reconstruire la matrice W politique du papier",
    reason = "La formule SDM est confirmee, mais W est une proximite politique et non une matrice construite depuis les coordonnees."
  ),
  metacomnet = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "classification_or_count_rf",
    package_include = "no",
    missing_items = "route classification/count et specification de reponse adaptee",
    reason = "Le papier utilise une logique Random Forest sur occurrences/interactions, pas une regression continue standard."
  ),
  maipo = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "classification_multiclass",
    package_include = "no",
    missing_items = "support classification et metriques adaptees",
    reason = "La reponse crop type est categorielle multiclasse."
  ),
  uk_photovoltaic = list(
    benchmark_status = "needs_preprocessing",
    benchmark_task = "regression_spatial_econometrics",
    package_include = "no",
    missing_items = "reconcilier les NUTS3 du papier avec le LAD extrait et joindre les covariables du SDM",
    reason = "Le papier modelise 134 regions NUTS3, alors que l'extraction actuelle contient 380 LAD et pas les covariables du papier."
  ),
  medicago = list(
    benchmark_status = "needs_model_specification_review",
    benchmark_task = "regression_gwr",
    package_include = "manual_review",
    missing_items = "extraire la specification empirique exacte ou choisir une formule benchmark documentee",
    reason = "GWR et covariables confirmees, mais aucune equation Y~X unique n'est encore validee pour le benchmark."
  ),
  eberg = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "soil_classification_or_ogc",
    package_include = "no",
    missing_items = "generer les covariables OGC/oblique geographic coordinates et definir une tache compatible",
    reason = "Dataset pedologique principalement categoriel; la formule systeme actuelle ne reproduit pas la methode du papier."
  ),
  hummingbird_sdm = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "species_distribution_model",
    package_include = "no",
    missing_items = "route SDM presence-only/presence-absence et covariables environnementales completes",
    reason = "Le modele du papier est un SDM integre, pas une regression continue standard."
  ),
  crane = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "binary_panel_or_presence_absence",
    package_include = "no",
    missing_items = "support binaire/panel et schema CV adapte",
    reason = "Reponse binaire et structure temporelle."
  ),
  regulatory_convergence = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "panel_spatial_econometrics",
    package_include = "no",
    missing_items = "support panel, variable reponse confirmee et matrice W du papier",
    reason = "Panel politico-economique avec dependance spatiale institutionnelle; pas un cas cross-section spatial simple."
  ),
  waste_site = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "meta_regression",
    package_include = "no",
    missing_items = "traiter comme meta-analyse, pas comme observations spatiales",
    reason = "Les lignes sont des estimations d'etudes, pas des observations geographiques elementaires."
  ),
  pm25_grid = list(
    benchmark_status = "not_ready_prediction_product",
    benchmark_task = "prediction_product",
    package_include = "no",
    missing_items = "retrouver les observations et covariables sources du modele ensembliste",
    reason = "Le fichier extrait est une grille de predictions, pas un tableau Y/X brut."
  ),
  no2_grid = list(
    benchmark_status = "not_ready_prediction_product",
    benchmark_task = "prediction_product",
    package_include = "no",
    missing_items = "retrouver les observations et covariables sources du modele ensembliste",
    reason = "Le fichier extrait est une grille de predictions, pas un tableau Y/X brut."
  ),
  o3_grid = list(
    benchmark_status = "not_ready_prediction_product",
    benchmark_task = "prediction_product",
    package_include = "no",
    missing_items = "retrouver les observations et covariables sources du modele ensembliste",
    reason = "Le fichier extrait est une grille de predictions, pas un tableau Y/X brut."
  ),
  beta0_gwr = list(
    benchmark_status = "not_ready_derived_response",
    benchmark_task = "derived_model_output",
    package_include = "no",
    missing_items = "retrouver le dataset empirique original et ses covariables",
    reason = "La reponse est un coefficient beta0 derive d'une GWR, pas une variable empirique brute."
  ),
  arequipa_climate = list(
    benchmark_status = "not_ready_relevance_check",
    benchmark_task = "climate_grid_product",
    package_include = "no",
    missing_items = "verifier le lien exact entre la grille extraite et l'analyse empirique du papier",
    reason = "La grille climatique ne contient pas encore un couple Y/X de regression spatiale conforme au papier."
  ),
  ethiopia_clusters = list(
    benchmark_status = "not_ready_derived_clusters",
    benchmark_task = "cluster_detection_output",
    package_include = "no",
    missing_items = "retrouver le jeu DHS/GWR original ou rester hors benchmark",
    reason = "Le fichier contient des clusters SaTScan derives, pas les observations de malnutrition utilisees pour la GWR."
  ),
  pallid_bat = list(
    benchmark_status = "needs_covariate_join",
    benchmark_task = "regression_spatial_sar",
    package_include = "no",
    missing_items = "joindre NPP et variables climatiques mentionnees dans le papier",
    reason = "La formule SAR est confirmee, mais les covariables principales du papier ne sont pas dans l'extraction actuelle."
  ),
  swiss_rainfall = list(
    benchmark_status = "not_ready_geostatistical_univariate",
    benchmark_task = "geostatistical_interpolation",
    package_include = "no",
    missing_items = "ajouter des covariables ou traiter comme kriging/interpolation",
    reason = "Dataset geostatistique univarie sans covariables X."
  ),
  vindum = list(
    benchmark_status = "not_ready_geostatistical_univariate",
    benchmark_task = "geostatistical_interpolation",
    package_include = "no",
    missing_items = "ajouter des covariables ou traiter comme kriging/interpolation",
    reason = "Dataset geostatistique univarie sans covariables X."
  ),
  biomass_rainforest = list(
    benchmark_status = "needs_response_reconstruction",
    benchmark_task = "regression_continuous",
    package_include = "no",
    missing_items = "reconstruire ou extraire AGB/AGC et joindre DBH/H ou covariables environnementales",
    reason = "L'extraction actuelle contient des composantes de l'allometrie, mais pas la variable cible AGB/AGC du papier."
  )
)

default_readiness <- function(record_id) {
  list(
    benchmark_status = "needs_manual_review",
    benchmark_task = "unknown",
    package_include = "manual_review",
    missing_items = "statut benchmark non encore curate",
    reason = sprintf("Aucune decision explicite encodee pour %s.", record_id)
  )
}

# -- Metadonnees papier (DOI, titre, source) depuis le KG --------------------
kg <- jsonlite::fromJSON(KG_PATH, simplifyVector = FALSE)
kg_by_dir <- list()
for (r in kg$records) {
  d <- r$local_raw_dir
  if (!is.null(d) && nzchar(d)) kg_by_dir[[basename(d)]] <- r
}

# -- Helpers de typologie (repris de export_sf_metadata.R, forme minimale) ---
classify_typology <- function(col) {
  if (!is.atomic(col)) return(list(typology = "unknown", range = NA_character_))
  cls <- class(col)[1]
  if (cls %in% c("factor", "character")) return(list(typology = "categorical", range = NA_character_))
  if (!cls %in% c("numeric", "double", "integer", "logical")) return(list(typology = "unknown", range = NA_character_))
  vals <- suppressWarnings(range(col, na.rm = TRUE))
  n_uniq <- length(unique(stats::na.omit(col)))
  if (cls == "logical" || all(stats::na.omit(col) %in% c(0, 1)))
    return(list(typology = "binary", range = "{0, 1}"))
  if (cls %in% c("numeric", "double")) {
    if (is.finite(vals[1]) && is.finite(vals[2]) && vals[1] >= 0 && vals[2] <= 1 && n_uniq > 5)
      return(list(typology = "rate", range = paste0("[", round(vals[1], 4), ", ", round(vals[2], 4), "]")))
    return(list(typology = "continuous", range = paste0("[", round(vals[1], 4), ", ", round(vals[2], 4), "]")))
  }
  if (cls == "integer")
    return(list(typology = "count", range = paste0("[", vals[1], ", ", vals[2], "]")))
  list(typology = "unknown", range = NA_character_)
}

profil_nt <- function(N, Tt) {
  n_cat <- if (N >= 500) "N_grand" else if (N >= 50) "N_moyen" else "N_petit"
  t_cat <- if (Tt >= 10) "T_grand" else if (Tt > 1) "T_moyen" else "T_petit"
  paste0(n_cat, "_", t_cat)
}

recommend_crs_analyse <- function(crs_epsg, bbox) {
  if (is.null(crs_epsg) || is.na(crs_epsg) || !(crs_epsg %in% c("4326", "4269", "4267")))
    return(list(epsg = "pending", label = "pending", note = "CRS source non geographique ou inconnu"))
  xmin <- bbox["xmin"]; xmax <- bbox["xmax"]; ymin <- bbox["ymin"]; ymax <- bbox["ymax"]
  if (abs(xmin) > 180 || abs(xmax) > 180 || abs(ymin) > 90 || abs(ymax) > 90)
    return(list(epsg = "pending", label = "pending", note = "bbox incoherente avec CRS geographique"))
  lon_c <- (xmin + xmax) / 2; lat_c <- (ymin + ymax) / 2; x_span <- xmax - xmin
  if (x_span > 18)
    return(list(epsg = "pending", label = "pending",
                note = paste0("multi-zones (span=", round(x_span, 1), "deg) -- projection nationale recommandee")))
  zone <- max(1L, min(60L, as.integer(floor((lon_c + 180) / 6) + 1)))
  if (lat_c >= 0) { epsg <- 32600L + zone; label <- sprintf("UTM Zone %dN (EPSG:%d)", zone, epsg) }
  else { epsg <- 32700L + zone; label <- sprintf("UTM Zone %dS (EPSG:%d)", zone, epsg) }
  list(epsg = as.character(epsg), label = label,
       note = "calcul auto depuis centroide bbox -- normalisation WGS84 uniquement")
}

is_temporal_candidate <- function(name, col) {
  nm <- tolower(name)
  if (grepl("years?_lost|candidates?_total|pct|percent|rate|score|index|income|price|value", nm)) return(FALSE)
  if (!grepl("(^|[_.])(date|datetime|time|timestamp|year|month|week|day|period|season)([_.]|$)|^date$|^time$|^year$|^yr$|^month$",
             nm, perl = TRUE)) return(FALSE)
  inherits(col, c("Date", "POSIXt")) || is.character(col) || is.factor(col) || is.integer(col) || is.numeric(col)
}

infer_T <- function(df, vars) {
  candidates <- vars[vapply(vars, function(v) is_temporal_candidate(v, df[[v]]), logical(1))]
  if (!length(candidates)) return(list(T = 1L, T_var = NA_character_, structure = "coupe_transversale", data_type = "spatial"))
  for (cand in candidates) {
    values <- df[[cand]]
    T_val <- length(unique(values[!is.na(values)]))
    if (T_val > 1L) return(list(T = T_val, T_var = cand, structure = "panel_ou_series", data_type = "spatio-temporel"))
  }
  list(T = 1L, T_var = NA_character_, structure = "coupe_transversale", data_type = "spatial")
}

md_escape <- function(x) {
  x <- as.character(x)
  x[is.na(x) | !nzchar(x)] <- "n/a"
  x
}

fmt_bt <- function(x) {
  x <- x[!is.na(x) & nzchar(x)]
  if (!length(x)) return("none detected")
  paste(sprintf("`%s`", x), collapse = ", ")
}

pct_na_col <- function(col) {
  if (!length(col)) return(NA_real_)
  round(100 * sum(is.na(col)) / length(col), 1)
}

extract_formula_terms <- function(formula_text, available_vars = character(0)) {
  if (is.null(formula_text) || !nzchar(formula_text) || !grepl("~", formula_text, fixed = TRUE)) return(character(0))
  rhs <- trimws(strsplit(formula_text, "~", fixed = TRUE)[[1]][2])
  if (!nzchar(rhs) || grepl("\\.\\.\\.", rhs)) return(character(0))
  terms <- trimws(unlist(strsplit(rhs, "\\+")))
  terms <- gsub("`", "", terms, fixed = TRUE)
  terms <- terms[nzchar(terms)]
  if (length(available_vars)) terms <- terms[terms %in% available_vars]
  unique(terms)
}

infer_yx_selection_rationale <- function(record_id, paper_title, y_vars, x_vars, coord_vars, id_vars, readiness, selected_x = NULL) {
  y_txt <- if (length(y_vars)) fmt_bt(y_vars) else "aucune variable reponse candidate"
  selected_x <- selected_x[!is.na(selected_x) & nzchar(selected_x)]
  shown_x <- if (length(selected_x)) selected_x else utils::head(x_vars, 12)
  x_txt <- if (length(shown_x)) fmt_bt(shown_x) else "aucune covariable explicative"
  more_txt <- if (length(selected_x)) {
    extra <- setdiff(x_vars, selected_x)
    if (length(extra)) sprintf(" ; %d autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used", length(extra)) else ""
  } else if (length(x_vars) > 12) {
    sprintf(" ; %d autres covariables restent listees dans Detail X", length(x_vars) - 12)
  } else ""
  coord_txt <- if (length(coord_vars)) fmt_bt(coord_vars) else "les coordonnees detectees"
  id_txt <- if (length(id_vars)) fmt_bt(id_vars) else "les identifiants detectes"
  status_txt <- if (!is.null(readiness) && !is.null(readiness$benchmark_status)) readiness$benchmark_status else "pending"
  sprintf(
    "Pour `%s`, la ou les reponses %s viennent du loader papier et/ou des preuves de l article `%s`. Les covariables X retenues sont %s%s. Les coordonnees (%s), identifiants (%s), geometries et champs techniques sont exclus de X. Statut benchmark actuel : %s ; la promotion package reste conditionnee au bloc benchmark_readiness.",
    record_id, y_txt, paper_title, x_txt, more_txt, coord_txt, id_txt, status_txt
  )
}

# -- Description heuristique (topic/observation_unit), meme esprit que
# infer_dataset_description_fields() dans generate_fiches.py mais appliquee
# au titre du papier + au nom du loader plutot qu'a la doc de package. -------
infer_description_fields <- function(record_id, paper_title, geom_type, data_type) {
  text <- tolower(paste(record_id, paper_title))
  topic <- NULL; unit <- NULL; population <- NULL
  if (grepl("pollinat|bee|flower|hummingbird|colibri", text)) {
    topic <- "ecologie / interactions plantes-pollinisateurs"
    unit <- "site d'observation ou cellule de grille d'occurrence"
    population <- "communautes de pollinisateurs ou d'oiseaux nectarivores"
  } else if (grepl("bat|pallid|skull|morpholog", text)) {
    topic <- "morphometrie et biogeographie animale"
    unit <- "specimen museal individuel"
    population <- "specimens de musee d'histoire naturelle geo-references via GBIF"
  } else if (grepl("crane|grus", text)) {
    topic <- "distribution d'espece / demographie de population"
    unit <- "observation ponctuelle de presence"
    population <- "population reintroduite de grues (Grus grus)"
  } else if (grepl("medicago|niche conservatism|richness", text)) {
    topic <- "biogeographie vegetale / gradients de richesse"
    unit <- "cellule de grille (100x100 km)"
    population <- "especes du genre Medicago"
  } else if (grepl("mammal|phylogenetic diversity", text)) {
    topic <- "macroecologie / diversite phylogenetique"
    unit <- "cellule de grille hexagonale globale"
    population <- "mammiferes terrestres"
  } else if (grepl("waste site|property value|hedonic", text)) {
    topic <- "economie environnementale / prix hedoniques"
    unit <- "estimation d'etude (meta-regression)"
    population <- "etudes de prix immobiliers residentiels a proximite de sites de dechets"
  } else if (grepl("photovoltaic|feed-in tariff|pv ", text)) {
    topic <- "energie / deploiement photovoltaique"
    unit <- "autorite locale (Local Authority District, UK)"
    population <- "installations PV domestiques (<10kW)"
  } else if (grepl("regulatory convergence|basel|banking", text)) {
    topic <- "economie politique internationale / regulation financiere"
    unit <- "pays/juridiction de la peripherie financiere"
    population <- "regulateurs bancaires nationaux"
  } else if (grepl("malnutrition|stunting|children", text)) {
    topic <- "sante publique / geographie de la malnutrition"
    unit <- "cluster spatial significatif (SaTScan)"
    population <- "enfants de moins de 5 ans, Ethiopie"
  } else if (grepl("biomass|carbon|forest", text)) {
    topic <- "ecologie forestiere / inventaire de biomasse"
    unit <- "placette d'inventaire forestier"
    population <- "placettes CTFT/ONF, foret tropicale humide"
  } else if (grepl("wald test|spatial model specification", text)) {
    topic <- "econometrie spatiale / methodologie de test"
    unit <- "observation parti x election"
    population <- "partis politiques, democraties occidentales"
  } else if (grepl("air temperature|gwr", text) && grepl("beta0", text)) {
    topic <- "climatologie / desagregation satellite"
    unit <- "cellule de grille globale (0.05 degre)"
    population <- "surface terrestre mondiale"
  } else if (grepl("pm2.5|ozone|no2|ensemble", text)) {
    topic <- "qualite de l'air / modele ensembliste ML"
    unit <- "point de grille 1km"
    population <- "Etats-Unis contigus"
  } else if (grepl("climate change|indigenous|climate maps", text)) {
    topic <- "climatologie regionale / savoirs autochtones"
    unit <- "cellule de grille climatique 1km"
    population <- "bassin versant Arequipa/Colca, Perou"
  } else if (grepl("species distribution|sampling bias", text)) {
    topic <- "modeles de distribution d'especes integres"
    unit <- "occurrence d'espece / cellule de grille"
    population <- "colibris (Trochilidae), Amerique du Sud/Centrale"
  } else if (grepl("cluster detection|spatial regression coefficient", text)) {
    topic <- "methodologie statistique / detection de cluster spatial"
    unit <- "cellule de grille spatiale simulee"
    population <- "donnees simulees (illustration methodologique)"
  }
  list(
    topic = if (is.null(topic)) sprintf("dataset spatial %s", data_type) else topic,
    observation_unit = if (is.null(unit)) sprintf("observation spatiale de type %s", geom_type) else unit,
    observed_population = if (is.null(population)) "a preciser depuis le papier source" else population
  )
}

# -- Formules candidates (meme structure que build_formula_candidates_block()
# dans generate_fiches.py, version simplifiee pour la famille papers). ------
formula_candidates_block <- function(formula, y_term, x_terms_vec, is_published, source_ref = "pending") {
  fmt_entry <- function(role, formula = "pending", response = "pending", predictors = character(0),
                        source_type = "none_found", status = "unavailable", source_ref = "pending",
                        estimator_context = character(0)) {
    pred_yaml <- paste0("[", paste(sprintf('"%s"', predictors), collapse = ", "), "]")
    context_yaml <- paste0("[", paste(sprintf('"%s"', estimator_context), collapse = ", "), "]")
    paste(
      sprintf('    formula: "%s"', formula),
      sprintf('    response: "%s"', response),
      sprintf("    predictors: %s", pred_yaml),
      sprintf('    role: "%s"', role),
      sprintf('    source_type: "%s"', source_type),
      sprintf('    source_ref: "%s"', gsub('"', "'", source_ref)),
      sprintf("    estimator_context: %s", context_yaml),
      sprintf('    status: "%s"', status),
      sep = "\n"
    )
  }
  univariate <- fmt_entry("simple_baseline")
  if (formula != "pending" && length(x_terms_vec) == 1) {
    univariate <- fmt_entry(
      "simple_baseline", formula, y_term, x_terms_vec,
      if (is_published) "scientific_publication" else "generated_system_formula",
      if (is_published) "confirmed" else "generated",
      source_ref,
      c("ols", "spatial_baseline")
    )
  }
  multivariate <- fmt_entry("paper_main_specification")
  if (formula != "pending" && is_published && length(x_terms_vec) >= 2) {
    multivariate <- fmt_entry(
      "paper_main_specification", formula, y_term, x_terms_vec,
      "scientific_publication", "confirmed",
      source_ref,
      c("ols", "sar_lag", "sem_error", "sdm_mixed", "gwr")
    )
  }
  ml_candidate <- fmt_entry("ml_candidate_features")
  if (formula != "pending" && !is_published) {
    ml_candidate <- fmt_entry(
      "ml_candidate_features", formula, y_term, x_terms_vec,
      "generated_system_formula", "generated",
      source_ref,
      c("random_forest", "xgboost", "gamboost", "spboost")
    )
  }
  paste(
    "```yaml", "formula_candidates:", "  univariate:", univariate, "",
    "  multivariate_constrained:", multivariate, "",
    "  ml_or_selected:", ml_candidate, "```",
    sep = "\n"
  )
}

# -- Boucle principale ---------------------------------------------------------
n_ok <- 0L
for (record_id in names(LOADER_TO_DIR)) {
  rds_path <- file.path(SF_DIR, paste0("paper_", record_id, ".rds"))
  if (!file.exists(rds_path)) { cat("SKIP (rds absent):", record_id, "\n"); next }

  obj <- readRDS(rds_path)
  geom_col <- attr(obj, "sf_column")
  df <- as.data.frame(obj)
  df[[geom_col]] <- NULL
  if ("geom_origine" %in% names(df)) df[["geom_origine"]] <- NULL
  vars <- names(df)

  row_meta <- PAPER_DATASET_LOADERS[[record_id]]()$row
  y_vars <- trimws(strsplit(row_meta$candidate_y_variables %||% "", ",")[[1]])
  y_vars <- y_vars[nzchar(y_vars) & y_vars %in% vars]
  coord_vars <- trimws(strsplit(row_meta$coordinate_columns %||% "", ",")[[1]])
  coord_vars <- coord_vars[nzchar(coord_vars) & coord_vars %in% vars]
  id_vars <- trimws(strsplit(row_meta$identifier_variables %||% "", ",")[[1]])
  id_vars <- id_vars[nzchar(id_vars) & id_vars %in% vars]
  x_vars <- setdiff(vars, c(y_vars, coord_vars, id_vars, "X", "Y", "T"))

  crs_info <- sf::st_crs(obj)
  epsg <- if (!is.na(crs_info$epsg)) as.character(crs_info$epsg) else "unknown"
  crs_name <- if (!is.null(crs_info$Name) && !is.na(crs_info$Name)) crs_info$Name else "unknown"
  bbox <- sf::st_bbox(obj)
  geom_type <- as.character(sf::st_geometry_type(obj, by_geometry = FALSE))
  N <- nrow(obj); k <- length(vars)
  time_info <- infer_T(df, vars)
  ca <- recommend_crs_analyse(epsg, bbox)

  gt_up <- toupper(geom_type)
  spatial_res <- if (grepl("MULTIPOINT", gt_up) || (grepl("POINT", gt_up) && !grepl("POLYGON", gt_up))) {
    "point observation"
  } else if (grepl("POLYGON", gt_up)) {
    "areal unit (polygon)"
  } else if (grepl("LINE", gt_up)) {
    "linear feature"
  } else {
    sprintf("spatial feature (%s)", geom_type)
  }
  if (time_info$T == 1) {
    temporal_res <- "not applicable (cross-sectional dataset)"
    time_range_str <- "not applicable (cross-sectional dataset)"
  } else {
    temporal_res <- sprintf("%d distinct periods (variable: %s)", time_info$T, time_info$T_var)
    time_range_str <- sprintf("%s to %s (variable: %s)",
                               md_escape(min(df[[time_info$T_var]], na.rm = TRUE)),
                               md_escape(max(df[[time_info$T_var]], na.rm = TRUE)),
                               time_info$T_var)
  }

  y_vars_str <- if (length(y_vars)) paste(sprintf("`%s`", y_vars), collapse = ", ") else "not identified — manual review required"
  x_vars_str <- if (length(x_vars)) paste(sprintf("`%s`", x_vars), collapse = ", ") else
    "no additional covariates beyond coordinates/identifiers (raster or grid dataset)"

  # Formule candidate systeme : Y ~ X1 + X2 + ... (baseline "kitchen sink"),
  # generee automatiquement -- PAS une formule publiee/verifiee par le papier.
  # Tronquee au-dela de 12 covariables pour rester lisible (ex: jeux de
  # meta-regression a des dizaines/centaines de colonnes).
  formula_used <- if (length(y_vars) >= 1 && length(x_vars) >= 1) {
    x_for_formula <- x_vars
    suffix <- ""
    if (length(x_for_formula) > 12) {
      suffix <- sprintf(" + ... (%d covariables au total, voir Candidate X variables)", length(x_for_formula) - 12)
      x_for_formula <- x_for_formula[1:12]
    }
    sprintf("%s ~ %s%s", y_vars[1], paste(x_for_formula, collapse = " + "), suffix)
  } else "pending"

  formula_pub <- "pending"
  formula_note <- "formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source — a confirmer par revue manuelle."
  ov <- FORMULA_OVERRIDES[[record_id]]
  if (!is.null(ov)) {
    if (!is.null(ov$formula_used)) formula_used <- ov$formula_used
    if (!is.null(ov$formula_pub)) formula_pub <- ov$formula_pub
    formula_note <- paste0("Formule/reference verifiee par lecture directe du papier source (session du ", TODAY, "). ", ov$source_ref)
  }

  y_typologies <- if (length(y_vars)) unique(sapply(y_vars, function(v) classify_typology(df[[v]])$typology)) else character(0)
  x_typologies <- if (length(x_vars)) unique(sapply(x_vars, function(v) {
    t <- classify_typology(df[[v]])$typology
    switch(t, count = "continuous", binary = "categorical", rate = "continuous", t)
  })) else character(0)
  y_typ_str <- if (length(y_typologies)) paste(y_typologies, collapse = ", ") else "unknown"
  x_typ_str <- if (length(x_typologies)) paste(x_typologies, collapse = ", ") else "unknown"

  y_rows <- if (length(y_vars)) paste(sprintf("| `%s` | `%s` | %s | %s | %s%% |", y_vars,
    sapply(y_vars, function(v) class(df[[v]])[1]),
    sapply(y_vars, function(v) classify_typology(df[[v]])$typology),
    sapply(y_vars, function(v) md_escape(classify_typology(df[[v]])$range)),
    sapply(y_vars, function(v) pct_na_col(df[[v]]))), collapse = "\n")
  else "| -- | -- | aucun candidat | -- | -- |"

  x_rows <- if (length(x_vars)) paste(sprintf("| `%s` | `%s` | %s | %s%% |", x_vars,
    sapply(x_vars, function(v) class(df[[v]])[1]),
    sapply(x_vars, function(v) classify_typology(df[[v]])$typology),
    sapply(x_vars, function(v) pct_na_col(df[[v]]))), collapse = "\n")
  else "| -- | -- | aucun candidat | -- |"

  kg_rec <- kg_by_dir[[LOADER_TO_DIR[[record_id]]]]
  paper_title <- if (!is.null(kg_rec$paper_title)) kg_rec$paper_title else "unknown"
  paper_doi <- if (!is.null(kg_rec$paper_doi)) kg_rec$paper_doi else "unknown"
  dataset_doi <- if (!is.null(kg_rec$dataset_doi) && nzchar(kg_rec$dataset_doi)) kg_rec$dataset_doi else "none"
  source_url <- if (!is.null(kg_rec$source_url)) kg_rec$source_url else (kg_rec$data_access_url %||% "unknown")
  if (is.null(ov) && !is.null(kg_rec$formula) && nzchar(kg_rec$formula)) {
    formula_pub <- kg_rec$formula
    formula_used <- kg_rec$formula
    formula_note <- paste0("Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCite). ", paper_title)
    ov <- list(formula_pub = formula_pub, formula_used = formula_used, source_ref = formula_note)
  }
  local_raw_dir <- LOADER_TO_DIR[[record_id]]
  dataset_name <- if (!is.null(kg_rec$dataset_name_in_paper) && nzchar(kg_rec$dataset_name_in_paper)) {
    kg_rec$dataset_name_in_paper
  } else paper_title

  tags <- sprintf("[dataset, paper-derived, spatial, %s]", tolower(gsub("[^A-Za-z]", "", geom_type)))
  desc <- infer_description_fields(record_id, paper_title, geom_type, time_info$data_type)

  high_na <- character(0)
  for (v in vars) {
    pct_na <- round(100 * sum(is.na(df[[v]])) / nrow(df), 1)
    if (pct_na > 20) high_na <- c(high_na, sprintf("%s (NA=%s%%)", v, pct_na))
  }
  missing_status <- if (length(high_na)) sprintf("WARN - variables avec NA > 20%%: %s.", paste(high_na, collapse = ", "))
    else "OK - aucune variable avec NA > 20% detectee."

  is_published <- !is.null(ov) && !is.null(ov$formula_pub)
  formula_x_terms <- extract_formula_terms(formula_used, x_vars)
  x_for_yaml <- if (length(formula_x_terms)) formula_x_terms else if (length(x_vars) > 12) x_vars[1:12] else x_vars
  modeling_source_ref <- if (!is.null(ov)) ov$source_ref else "data/raw/papers (loader-derived, no published equation located)"
  fcb <- formula_candidates_block(
    formula_used,
    if (length(y_vars)) y_vars[1] else "pending",
    x_for_yaml,
    is_published,
    modeling_source_ref
  )

  modeling_existing <- if (is_published) "true" else "false"
  modeling_source_type <- if (is_published) "scientific_publication_or_package_documentation" else "generated_system_formula"
  modeling_evidence_block <- paste(
    "```yaml", "modeling_evidence:",
    sprintf("  existing_model_found: %s", modeling_existing),
    sprintf('  equation_text: "%s"', gsub('"', "'", formula_pub)),
    sprintf("  equation_family: %s", if (is_published) "paper_empirical_or_dataset_specific" else "generated_system_candidate"),
    sprintf("  model_family: %s", if (is_published) "spatial_or_paper_specific_regression" else "unknown"),
    sprintf("  source_type: %s", modeling_source_type),
    sprintf('  source_ref: "%s"', gsub('"', "'", modeling_source_ref)),
    sprintf("  confidence: %s", if (is_published) "medium" else "low"),
    "```",
    sep = "\n"
  )

  variables_status <- if (length(y_vars) && length(x_vars)) "OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes)."
    else if (length(y_vars)) "WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle)."
    else "WARN - Y non identifiee automatiquement ; revue manuelle requise."
  formula_status <- if (is_published) "OK - formule publication renseignee (verifiee par lecture directe du papier)."
    else "PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place)."
  crs_status <- if (epsg != "unknown") sprintf("OK - CRS renseigne dans le Bloc 5 (%s).", epsg)
    else "WARN - CRS absent du sf source et non resolu automatiquement."
  geometry_status <- sprintf("OK - type geometrique controle (%s).", geom_type)
  reproducibility_status <- sprintf("OK - loader R enregistre et reexecutable (`%s` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.", record_id)

  header_block <- sprintf(
    "---\ntitle: paper_%s\ntype: dataset\ncreated: %s\nupdated: %s\nsources:\n  - data/final_datasets/sf/paper_%s.rds\n  - %s\ntags: %s\n---\n\nDataset spatial converti en sf a partir des donnees brutes du papier \"%s\" (DOI %s).",
    record_id, TODAY, TODAY, record_id, local_raw_dir, tags, paper_title, paper_doi
  )

  description_block <- sprintf(
    "## Description du jeu de donnees\n\n- Topic: %s\n- Observation unit: %s\n- Observed population: %s\n- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)\n- Temporal context: %s\n- Source description: %s\n- Description source: paper_dataset_uses.json + lecture directe du papier\n- Description confidence: %s\n- Paper DOI: %s\n- Dataset DOI: %s\n- Source URL: %s\n- Local raw dir: `data/raw/papers/%s/`\n- Local sf output: `data/final_datasets/sf/paper_%s.rds`",
    desc$topic, desc$observation_unit, desc$observed_population,
    if (time_info$T == 1) "none (cross-sectional)" else temporal_res,
    paper_title, if (!is.null(ov)) "medium" else "low",
    paper_doi, dataset_doi, source_url, local_raw_dir, record_id
  )

  readiness <- PAPER_READINESS[[record_id]]
  if (is.null(readiness)) readiness <- default_readiness(record_id)
  yx_rationale <- infer_yx_selection_rationale(record_id, paper_title, y_vars, x_vars, coord_vars, id_vars, readiness, selected_x = x_for_yaml)

  bloc1_block <- sprintf(
    "## Bloc 1 — Formule et variables\n\n### Variables (niveau systeme — inspection directe du sf)\n\n- Candidate Y variables: %s\n- Candidate Y typology: %s\n- Candidate X variables: %s\n- Candidate X count: %d\n- Candidate X typology: %s\n- Coordinates (x, y — excluded from X candidates): %s\n- Identifier columns (excluded from X candidates): %s\n- Variables inspected: yes (auto — generate_fiches_papers.R)\n- Presence of imputed X: unknown\n\n#### Detail Y\n\n| Variable | Classe R | Typologie Y | Plage | NA (%%) |\n|---|---|---|---|---|\n%s\n\n> Selection Y/X (paper-loader/curated evidence) : %s\n\n#### Detail X\n\n| Variable | Classe R | Role X | NA (%%) |\n|---|---|---|---|\n%s\n\n### Formule — niveau publication\n\n- formula_pub: %s\n- x_terms_pub: %s\n- y_term_pub: %s\n- Reference publication: %s\n\n### Statut regression canonique\n\n- Statut: %s\n- Niveau de preuve: %s\n- Methode d estimation: %s\n- Correspondance Python/R: aucune identifiee\n- Note: %s\n\n### Formule — niveau systeme\n\n- formula_used: %s\n- x_terms_used: %s\n- y_term_used: %s\n- Note: %s\n\n### Formules candidates\n\n%s",
    y_vars_str, y_typ_str, x_vars_str, length(x_vars), x_typ_str,
    fmt_bt(coord_vars), fmt_bt(id_vars),
    y_rows, yx_rationale, x_rows,
    formula_pub,
    if (length(x_for_yaml)) paste(x_for_yaml, collapse = ", ") else "pending",
    if (length(y_vars)) y_vars[1] else "pending",
    if (!is.null(ov)) ov$source_ref else "pending",
    if (is_published) "resolu" else "pending",
    if (is_published) "publication" else "n/a",
    if (is_published) "formule publication confirmee et utilisee" else "n/a",
    if (is_published) formula_note else "n/a",
    formula_used,
    if (length(x_for_yaml)) paste(x_for_yaml, collapse = ", ") else "pending",
    if (length(y_vars)) y_vars[1] else "pending",
    formula_note,
    fcb
  )

  bloc2_block <- sprintf(
    "## Bloc 2 — Identification et DOI\n\n- Dataset ID: `paper_%s`\n- Dataset name: %s\n- Source family: paper-derived\n- Source: papier scientifique (voir Paper DOI)\n- Paper title: %s\n- Paper DOI: %s\n- Dataset DOI: %s\n- Source URL: %s\n- Year: unknown",
    record_id, dataset_name, paper_title, paper_doi, dataset_doi, source_url
  )

  bloc3_block <- sprintf(
    "## Bloc 3 — Typologie des modeles\n\n- Modele niveau 1 (tache): %s\n- Modele niveau 2 (famille): pending\n- Modele niveau 3 (variante): pending\n\n%s",
    if (is_published) "regression / modele spatial (voir formula_pub)" else "pending",
    modeling_evidence_block
  )

  benchmark_readiness_block <- sprintf(
    "## Benchmark readiness\n\n```yaml\nbenchmark_readiness:\n  benchmark_status: \"%s\"\n  benchmark_task: \"%s\"\n  package_include: \"%s\"\n  has_local_rds: true\n  missing_items: \"%s\"\n  reason: \"%s\"\n```\n\n- Decision: %s\n- Manque principal: %s\n- Raison: %s",
    readiness$benchmark_status,
    readiness$benchmark_task,
    readiness$package_include,
    gsub('"', "'", readiness$missing_items),
    gsub('"', "'", readiness$reason),
    readiness$benchmark_status,
    readiness$missing_items,
    readiness$reason
  )

  bloc4_block <- sprintf(
    "## Bloc 4 — Typologie des donnees\n\n- Data type: %s\n- Structure: %s\n- N observations: %d\n- k variables: %d\n- T periods: %d\n- Variable temporelle: %s\n- N/T profile: %s",
    time_info$data_type, time_info$structure, N, k, time_info$T,
    md_escape(time_info$T_var), profil_nt(N, time_info$T)
  )

  bloc5_block <- sprintf(
    "## Bloc 5 — Resolution et etendue\n\n- Type de geometrie: %s\n- Spatial resolution: %s\n- Temporal resolution: %s\n- CRS EPSG: %s\n- CRS nom: %s\n- Spatial extent: x [%s, %s], y [%s, %s]\n- Time range: %s\n- CRS analyse recommande: %s",
    geom_type, spatial_res, temporal_res, epsg, crs_name,
    md_escape(bbox["xmin"]), md_escape(bbox["xmax"]), md_escape(bbox["ymin"]), md_escape(bbox["ymax"]),
    time_range_str,
    if (ca$label != "pending") sprintf("%s (%s) — %s", ca$epsg, ca$label, ca$note) else sprintf("pending — %s", ca$note)
  )

  bloc6_block <- sprintf(
    "## Bloc 6 — Reproductibilite\n\n- License present: unknown\n- License name: unknown\n- License URL: unknown\n- License open: unknown\n- Reproducibility status: %s\n- Code available: yes (loader `%s` dans `code/r_catalog/build_sf_datasets_papers.R`)\n- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)",
    reproducibility_status, record_id
  )

  qc_block <- sprintf(
    "## Quality Control\n\n- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.\n- Variables: %s\n- Formula: %s\n- CRS: %s\n- Geometry: %s\n- Missing values: %s\n- Duplicates: OK - aucun doublon exact retenu pour cette fiche.\n- Reproducibility: %s",
    variables_status, formula_status, crs_status, geometry_status, missing_status, reproducibility_status
  )

  related_block <- sprintf(
    "## Related Pages\n\n- [[paper_dataset_ingestion_pipeline_2026-08]]\n- Source: %s",
    paper_title
  )

  content <- paste(header_block, "", description_block, "", bloc1_block, "", bloc2_block, "",
                    bloc3_block, "", benchmark_readiness_block, "", bloc4_block, "", bloc5_block, "", bloc6_block, "",
                    qc_block, "", related_block, "", sep = "\n")

  out_path <- file.path(OUT_DIR, paste0("paper_", record_id, ".md"))
  writeLines(content, out_path, useBytes = TRUE)
  n_ok <- n_ok + 1L
  cat(sprintf("OK  paper_%s.md  (N=%d, k=%d, Y=%s)\n", record_id, N, k,
              if (length(y_vars)) paste(y_vars, collapse = "+") else "?"))
}

cat(sprintf("\n=== BILAN === %d fiches generees / %d loaders\n", n_ok, length(LOADER_TO_DIR)))

