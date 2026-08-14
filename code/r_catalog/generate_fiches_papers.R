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
# Usage : Rscript code/r_catalog/generate_fiches_papers.R [record_id ...]
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
  possum_body_size = "DataCite_2015_LeanSeasonPrimaryProductivity_10_1111_ecog_012",
  # -- Lot DataCite 2026-08 (harvest verifie, session du 2026-08-12) --------
  coral_bathypathes = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_corallium = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_enallopsammia = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_errina = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_goniocorella = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_isididae = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_leiopathes = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_madrepora = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_paragorgia = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_primnoa = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_solenosmilia = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  coral_stylaster = "DataCite_2022_PredictingTheEffectsOf_10_1111_gcb_1638",
  early_season_biomass = "DataCite_2024_EarlySeasonBiomassAnd_10_1002_ael2_201",
  influenza_mortality_chicago = "DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161",
  plant_invasion_fia = "DataCite_2024_SpatialPredictionOfPlant_10_1002_ece3_116",
  maine_baseflow = "DataCite_2021_ModelEstimatedBaseflowFor_10_1002_rra_3835",
  midwest_crop_yield = "DataCite_2022_CropYieldPredictionUsing_10_1080_01621459",
  network_misspecification_elections = "DataCite_2020_BiasFromNetworkMisspecification_10_1017_pan_2020",
  ethiopia_bushcrow_sdm = "DataCite_2021_ClimaticChangeAndExtinction_10_1371_journal_",
  ethiopia_whitetailed_swallow_sdm = "DataCite_2021_ClimaticChangeAndExtinction_10_1371_journal_",
  desert_tortoise_genotype_niche = "DataCite_2019_LocalNicheDifferencesPredict_10_1111_ddi_1292",
  trillium_presence_background = "DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329",
  trillium_proportional_occupancy = "DataCite_2021_ReproductiveTraitsExplainOccupancy_10_1111_ddi_1329",
  wildfire_bootleg_severity = "DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700",
  wildfire_schneider_springs_severity = "DataCite_2024_LearningFromWildfiresA_10_1002_ecs2_700",
  amphibian_malformation_prevalence = "DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_",
  hyena_lion_biomass_africa = "DataCite_2021_EnvironmentalFactorsInfluencingSpotted_10_1002_ece3_835",
  bumblebee_colony_reproduction = "DataCite_2018_LowerBumblebeeColonyReproductive_10_1098_rspb_201",
  rocky_mountain_tree_growth = "DataCite_2017_ClimateAndCompetitionEffects_10_1111_1365_274",
  harbour_porpoise_response = "DataCite_2019_HarbourPorpoiseResponsesTo_10_1098_rsos_190",
  amazon_tree_dominance = "DataCite_2023_UnderstandingDifferentDominancePatterns_10_1111_ele_1435",
  joshua_tree_flowering = "DataCite_2024_Reconstructing120YearsOf_10_1111_ele_1447",
  wildfire_greenup_nbr5 = "DataCite_2024_ClimateLimitsVegetationGreen_10_1186_s42408_0"
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
    source_ref = "Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) - modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer."
  ),
  medicago = list(
    formula_pub = "richness ~ f(Quaternary climate change, environmental energy) via geographically weighted regression (GWR)",
    source_ref = "Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085 - GWR quantifiant les effets de la variation climatique quaternaire et de l'energie environnementale sur la richesse de Medicago, a l'echelle globale/continentale/biome."
  ),
  regulatory_convergence = list(
    formula_pub = "adoption_Basel_II ~ spatial lag (interdependance banques/regulateurs/investisseurs transfrontaliere), spatial lag model",
    source_ref = "Jones & Zeitz (2019), International Studies Quarterly - modeles a decalage spatial (spatial lag models) sur l'adoption des standards Basel II dans ~100 juridictions peripheriques. Variable candidate 'net_bcbs' non confirmee explicitement dans les 2 premieres pages lues ; a verifier contre le texte complet."
  ),
  waste_site = list(
    formula_pub = "elas ~ meta-regression (WLS/REML) sur 727 estimations, correction du biais de publication (PET-PEESE)",
    source_ref = "Schutt (2021), Environmental and Resource Economics 78:381-416 - meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication."
  ),
  pallid_bat = list(
    formula_pub = "body_size ~ NPP + MinWinTemp + TempSeas [top SAR error model]",
    formula_used = "centroid_size ~ NPP + MinWinTemp + TempSeas",
    formula_candidate_formula = "centroid_size ~ NPP + MinWinTemp + TempSeas",
    y_term_pub = "cranium centroid size / body size proxy",
    x_terms_pub = c("NPP", "MinWinTemp", "MaxSumTemp", "TempSeas", "PrecSeas"),
    source_ref = "Kelly, Friedman & Santana (2018), Functional Ecology, DOI 10.1111/1365-2435.13092: Sections 2.2-2.3 and Tables 1-2 use NPP, minimum winter temperature, maximum summer temperature and temperature/precipitation seasonality to explain Pallid bat cranium centroid size with OLS and SAR error models. The local loader extracts the matching Dryad rasters NPP, bio4, bio5, bio6 and bio15 at specimen localities. formula_used uses centroid_size derived from TPS landmarks as the local executable body-size proxy."
  ),
  mammals_sr_pd = list(
    formula_pub = "SR ~ 0.47*AET + 0.31*Mean_annual_temperature (R2=0.75) ; PD ~ 0.95*SR - 0.37*LGM_velocity + 0.12*Mean_elevation (R2=0.97)",
    formula_used = "SR ~ AET + Temp",
    source_ref = "Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 - modele de path analysis (coefficients standardises, moyenne +/- ecart-type mondial) reliant AET, temperature, velocite climatique depuis le LGM et elevation a la richesse specifique (SR) et la diversite phylogenetique (PD) des mammiferes terrestres."
  ),
  pm25_grid = list(
    formula_pub = "PM2.5 ~ f(selected predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]",
    formula_used = "pending",
    formula_candidate_formula = "pending",
    y_term_pub = "monitored PM2.5 concentration",
    x_terms_pub = c("spatially_lagged_PM2.5", "CMAQ_PM2.5", "CMAQ_PM2.5_sulfate", "CMAQ_PM2.5_elemental_carbon", "CMAQ_PM2.5_organic_carbon", "AOD_related_variables", "road_density", "longitude", "latitude", "elevation_sd", "NLCD_developed_area"),
    ml_formula = "monitored_PM2.5 ~ selected predictor variables ranked by learner-specific variable importance",
    ml_response = "monitored PM2.5 concentration",
    ml_predictors = c("spatially_lagged_PM2.5", "CMAQ_PM2.5", "CMAQ_PM2.5_sulfate", "CMAQ_PM2.5_elemental_carbon", "CMAQ_PM2.5_organic_carbon", "AOD_related_variables", "road_density", "longitude", "latitude", "elevation_sd", "NLCD_developed_area", "soil_moisture", "NLCD_tree_canopy", "NLCD_planted_land", "CMAQ_NO2", "daily_max_air_temperature", "MODIS_daytime_surface_temperature", "OMI_NO2_column_concentration", "MERRA2_sulfate_aerosol"),
    ml_source_ref = "Di et al. (2019), Environment International, abstract, sections 1.3-1.5 and Table 4: the authors trained neural network, random forest and gradient boosting learners, ranked predictor contributions, then combined learner predictions with a geographically weighted generalized additive model. Table 4 lists the top 20 variable-importance contributors by learner.",
    ml_estimator_context = c("random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"),
    ml_status = "confirmed_feature_groups",
    source_ref = "Di et al. (2019), Environment International, abstract, sections 1.3-1.5 and Table 4. The current local grid .rds contains final predicted PM2.5 values only; it does not contain the full learner training matrix.",
    equation_family = "ensemble_ml_geographically_weighted_gam",
    model_family = "neural network + random forest + gradient boosting ensemble via geographically weighted GAM"
  ),
  no2_grid = list(
    formula_pub = "NO2 ~ f(selected predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]",
    formula_used = "pending",
    formula_candidate_formula = "pending",
    y_term_pub = "monitored daily NO2 concentration at AQS sites",
    x_terms_pub = c("spatially_lagged_NO2", "temporally_lagged_NO2", "meteorological_variables", "OMI_NO2", "GEOS_Chem_NO2", "CMAQ_NO2", "NLCD_land_cover", "truck_traffic", "road_density", "restaurant_density", "elevation", "NDVI", "nighttime_light", "aerosol_variables", "cloud_cover", "surface_albedo", "MODIS_reflectance", "CAMS_NO2"),
    ml_formula = "monitored_NO2 ~ selected predictor variables from satellite, CTM, meteorology, land-cover and spatial/temporal lag families",
    ml_response = "monitored daily NO2 concentration",
    ml_predictors = c("spatially_lagged_NO2", "temporally_lagged_NO2", "meteorological_variables", "OMI_NO2", "GEOS_Chem_NO2", "CMAQ_NO2", "NLCD_land_cover", "truck_traffic", "road_density", "restaurant_density", "elevation", "NDVI", "nighttime_light", "aerosol_variables", "cloud_cover", "surface_albedo", "MODIS_reflectance", "CAMS_NO2"),
    ml_source_ref = "Di et al. (2019), Environmental Science & Technology, DOI 10.1021/acs.est.9b03358: abstract and Sections 2.1-3.5 describe monitored NO2 as the response, spatial/temporal lagged NO2, meteorology, OMI, GEOS-Chem, CMAQ, land-cover, traffic, elevation, NDVI, nighttime light, aerosols, cloud and albedo predictors, and neural network, random forest, gradient boosting plus geographically weighted GAM ensemble. The current local grid .rds contains final predicted NO2 values only; it does not contain the monitor-level training matrix.",
    ml_estimator_context = c("random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"),
    ml_status = "confirmed_feature_groups",
    source_ref = "Di et al. (2019), Environmental Science & Technology, DOI 10.1021/acs.est.9b03358. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data.",
    equation_family = "ensemble_ml_geographically_weighted_gam",
    model_family = "neural network + random forest + gradient boosting ensemble via geographically weighted GAM"
  ),
  o3_grid = list(
    formula_pub = "O3 ~ f(169 predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]",
    formula_used = "pending",
    formula_candidate_formula = "pending",
    y_term_pub = "daily maximum 8 h O3 concentration at monitoring sites",
    x_terms_pub = c("meteorological_variables", "chemical_transport_model_outputs", "remote_sensing_observations", "land_use_variables", "CMAQ", "GEOS_Chem", "spatiotemporally_lagged_O3", "nearby_monitor_weighted_O3", "AOD", "NDVI", "road_density", "tree_canopy", "developed_area"),
    ml_formula = "monitored_O3 ~ 169 predictor variables from weather, CTM, remote sensing, land-use and spatiotemporal lag families",
    ml_response = "daily maximum 8 h O3 concentration",
    ml_predictors = c("meteorological_variables", "chemical_transport_model_outputs", "remote_sensing_observations", "land_use_variables", "CMAQ", "GEOS_Chem", "spatiotemporally_lagged_O3", "nearby_monitor_weighted_O3", "AOD", "NDVI", "road_density", "tree_canopy", "developed_area"),
    ml_source_ref = "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791: Sections 2.1-2.5 describe monitored daily maximum 8 h O3 as the response, 169 predictors consolidated from weather, CTM outputs, remote sensing and land-use data, random-forest imputation, neural network, random forest, gradient boosting, and a geographically weighted GAM ensemble. The current local grid .rds contains final predicted O3 values only; it does not contain the monitor-level training matrix.",
    ml_estimator_context = c("random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"),
    ml_status = "confirmed_feature_groups",
    source_ref = "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data.",
    equation_family = "ensemble_ml_geographically_weighted_gam",
    model_family = "neural network + random forest + gradient boosting ensemble via geographically weighted GAM"
  ),  biomass_rainforest = list(
    formula_pub = "AGB_plot(s) = mu + sum_e gamma_e * x_e(s) + k(s) [kriging-regression model, Eq. 4]",
    formula_used = "AGB_mean ~ area_ha + n_stems + mean_wsg + HAND + LOG + ALT + SLO",
    formula_candidate_formula = "AGB_plot ~ LANDScapes + HAND + LOG + GEOL + VEGET + ALT + SLO + spatial_kriging_residual",
    y_term_pub = "AGB_plot / above-ground biomass per hectare",
    x_terms_pub = c("LANDScapes", "HAND", "LOG", "GEOL", "VEGET", "ALT", "SLO", "spatial_kriging_residual"),
    source_ref = "Guitet et al. (2015), PLOS ONE, DOI 10.1371/journal.pone.0138456; Dryad 10.5061/dryad.38578. The paper computes plot-level AGB from DBH class, simulated height, wood specific gravity and plot area (Eq. 1-2), then models AGB with GLM selected by AIC and adds a kriged residual spatial component k(s) (Eq. 4-5). Selected effects reported in Results are LANDScapes, HAND, LOG, GEOL, VEGET, ALT and SLO; LANDForms, DRY and RAIN were excluded. The current local artifact now reconstructs AGB_mean from the PLOS S1_Dataset_AGB.xlsx supplement and exposes plot area, stem counts, mean WSG and the reconstructed numeric environmental covariates HAND, LOG, ALT and SLO. LANDScapes, GEOL and VEGET remain documented from the paper sources but are not joined locally, so formula_used is still a reduced local executable benchmark formula rather than the full published GLM/KR specification.",
    yx_selection_note = "Pour `biomass_rainforest`, la reponse publiee n'est pas `mean_wsg` ni `n_stems`, mais `AGB_plot` / above-ground biomass per hectare. Le papier calcule d'abord AGB a partir des classes DBH, de la hauteur simulee, du WSG et de l'aire de placette, puis ajuste un GLM selectionne par AIC avec composante spatiale de krigeage des residus. Dans l'artefact local actuel, `AGB_mean` est reconstruit depuis le supplement PLOS S1_Dataset_AGB.xlsx et sert de reponse locale executable. `area_ha`, `n_stems`, `mean_wsg`, `HAND`, `LOG`, `ALT` et `SLO` sont les covariables locales disponibles. Elles ne remplacent pas la specification complete du papier, car `LANDScapes`, `GEOL`, `VEGET` et la composante de krigeage des residus restent documentees mais non jointes au .rds. Les coordonnees (`Xutm`, `Yutm`), identifiants (`ID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : local_reduced_formula ; la promotion package doit signaler que formula_used est une specification locale reduite, distincte de la formule publication complete.",
    equation_family = "kriging_regression_glm_plus_spatial_residual",
    model_family = "above-ground biomass/carbon mapping with GLM and ordinary kriging"
  ),
  wald_test = list(
    formula_pub = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par",
    formula_used = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par",
    source_ref = "Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs, data/raw/papers/DataCite_2020_TheWaldTestOf_10_1017_pan_2020/EmpiricalExample.R)."
  ),
  swiss_rainfall = list(
    formula_pub = "rainfall ~ oblique_geographic_coordinates [random forest / OGC spatial covariates]",
    formula_used = "rainfall ~ ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150",
    formula_candidate_formula = "rainfall ~ ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150",
    y_term_pub = "rainfall on 8 May 1986",
    x_terms_pub = c("oblique geographic coordinates", "ordinary kriging", "EDFs", "RFsp"),
    source_ref = "Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Section 2.3.2 and Appendix A compare purely spatial methods on the Swiss rainfall dataset, including OGCs as explicit coordinate covariates. The local loader generates six oblique coordinate covariates from the point geometry, making formula_used executable as an OGC benchmark variant rather than a conventional environmental regression."
  ),
  vindum = list(
    formula_pub = "SOM ~ oblique_geographic_coordinates + auxiliary_data [random forest / OGC spatial covariates]",
    formula_used = "SOM ~ aspect_cos + aspect_sin + bluespot + curvature_plan + curvature_prof + DEM + DVI + ECa + flow_accu + midslope + MRVBF + NDVI + RVI + SAGAWI + SAVI + SL + slope_gradient + TWI + valleydepth + ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150",
    formula_candidate_formula = "SOM ~ aspect_cos + aspect_sin + bluespot + curvature_plan + curvature_prof + DEM + DVI + ECa + flow_accu + midslope + MRVBF + NDVI + RVI + SAGAWI + SAVI + SL + slope_gradient + TWI + valleydepth + ogc_000 + ogc_030 + ogc_060 + ogc_090 + ogc_120 + ogc_150",
    y_term_pub = "soil organic matter (SOM)",
    x_terms_pub = c("aspect_cos", "aspect_sin", "bluespot", "curvature_plan", "curvature_prof", "DEM", "DVI", "ECa", "flow_accu", "midslope", "MRVBF", "NDVI", "RVI", "SAGAWI", "SAVI", "SL", "slope_gradient", "TWI", "valleydepth", "oblique geographic coordinates"),
    source_ref = "Moller et al. (2020), Soil, DOI 10.5194/soil-6-269-2020: Sections 2.1.1, 2.2 and 2.3.1 model SOM in the Vindum field using random forest with OGC coordinate rasters, with and without auxiliary data. The OGC package cited in the paper contains Vindum_SOM and Vindum_covariates; the local loader now extracts the 19 auxiliary raster layers (DEM terrain derivatives, Sentinel-2 vegetation indices and DUALEM apparent electrical conductivity) at the 285 SOM points and adds six generated OGC covariates. formula_used is the executable local OGC + AUX benchmark variant.",
    yx_selection_note = "Pour `vindum`, la reponse `SOM` vient des observations Vindum_SOM du package OGC cite par Moller et al. (2020). Les covariables X retenues combinent les 19 couches auxiliaires publiees dans le package OGC (`aspect_cos`, `aspect_sin`, `bluespot`, `curvature_plan`, `curvature_prof`, `DEM`, `DVI`, `ECa`, `flow_accu`, `midslope`, `MRVBF`, `NDVI`, `RVI`, `SAGAWI`, `SAVI`, `SL`, `slope_gradient`, `TWI`, `valleydepth`) et les six coordonnees geographiques obliques generees localement (`ogc_000` a `ogc_150`). Les identifiants, geometries et champs techniques sont exclus de X. Statut benchmark actuel : almost_ready_ogc_aux_spatial_covariates ; la promotion package reste conditionnee au bloc benchmark_readiness."
  ),  uk_photovoltaic = list(
    formula_pub = "PV_uptake ~ rho*W*PV_uptake + X*beta + W*X*theta + u (Spatial Durbin Model, eq. 1)",
    formula_used = "pending",
    formula_candidate_formula = "PV_uptake ~ Lnypc + Density + Detached + Ownedshare + Lnelectricity + QL2 + Avehousehold + Irradiation + CO2",
    y_term_pub = "PV uptake, measured by accumulated capacity and number of installations at Great Britain NUTS3 level",
    x_terms_pub = c("Lnypc", "Density", "Detached", "Ownedshare", "Lnelectricity", "QL2", "Avehousehold", "Irradiation", "CO2"),
    source_ref = "Balta-Ozkan, Yildirim & Connor (2015), Energy Economics, DOI 10.1016/j.eneco.2015.08.003: Section 5.2 lists explanatory variables and sources; Section 5.3 gives the spatial econometric specification; Table 8 reports OLS spatial-dependence tests; Table 9 reports SDM/SAR/SEM/GS-2SLS estimates using Lnypc, Density, Detached, Ownedshare, Lnelectricity, QL2, Avehousehold, Irradiation and CO2. Current local .rds has LAD-level PV aggregates only, so the NUTS3 covariate matrix from the paper still has to be reconstructed before formula_used can be executable."
  ),
  hummingbird_sdm = list(
    formula_pub = "log(lambda_PO) = alpha_PO + beta*x + g(s) ; logit(lambda_PA) = alpha_PA + beta*x + g(s) [modele integre PO+PA, effet spatial latent partage g(s)]",
    formula_used = "log1p_species_richness ~ annual_mean_temperature + mean_diurnal_range + annual_precipitation + precipitation_seasonality + evi_annual",
    formula_candidate_formula = "log1p_species_richness ~ annual_mean_temperature + mean_diurnal_range + annual_precipitation + precipitation_seasonality + evi_annual",
    y_term_pub = "presence-only intensity, presence-absence occurrence probability, and stacked species richness predictions for 71 hummingbird species",
    x_terms_pub = c("annual mean temperature", "mean diurnal range", "annual precipitation", "precipitation seasonality", "intra-annual cloud cover variation", "EVI", "TRI"),
    source_ref = "Makinen, Merow & Jetz (2023), Global Ecology and Biogeography, Section 2.1 and Table 1: SDM integre combinant donnees presence-seule (GBIF) et presence-absence (checklists Andes du Nord) pour 71 especes de colibris, via un processus de Poisson log-lineaire (PO) et un modele Bernoulli (PA) partageant un effet spatial latent g(s). Le README Dryad local fournit CHELSA et EVI ; cloud cover et TRI sont cites par le papier/README mais doivent etre recuperes depuis leurs sources originales avant reproduction complete. formula_used utilise log1p_species_richness, une reponse derivee continue construite depuis le comptage local par cellule ; c est une reconstruction executable partielle au niveau cellule, pas la formule complete des SDM du papier."
  ),
  teles_decapod_biodiversity_brazil = list(
    formula_pub = "Random Forest models for SR, PD.SES and PE.SES using environmental covariates; SR mainly driven by salinity, light availability and primary productivity; PD by bottom temperature, primary productivity and current velocity; PE by temperature and primary productivity.",
    formula_used = "SR ~ sal + light + pp + tempmean + curvel + fishing_effort",
    source_ref = "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description and TEI: decapod richness and phylogenetic diversity benchmark; environmental covariates include salinity, light, primary productivity, temperature, current velocity and fishing effort."
  ),
  # -- Lot DataCite 2026-08 (harvest verifie, session du 2026-08-12) --------
  coral_bathypathes = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    source_ref = "Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales). Le README documente 12 variables nommees explicitement ; le CSV reel en contient 14 (sand et PBO_C en plus, non fabriquees, presentes telles quelles dans le fichier telecharge)."
  ),
  early_season_biomass = list(
    formula_pub = "late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term",
    formula_used = "late_bm_kg_ha ~ early_bm_kg_ha + CGDD_plant_early_term + CGDD_early_late_term + mean_PAR + cuml_precip_plant_early_term + cuml_precip_early_late_term",
    source_ref = "Huddell et al. (2024), Agricultural & Environmental Letters, DOI 10.1002/ael2.20121; data_dictionary.csv (Dryad 10.5061/dryad.ngf1vhj1r) definit late_bm_kg_ha comme biomasse au moment de la terminaison tardive -- la variable predite d'apres le titre du papier (early-season biomass and weather enable ... biomass predictions)."
  ),
  influenza_mortality_chicago = list(
    formula_pub = "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7, offset=pop",
    formula_used = "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7",
    source_ref = "Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp."
  ),
  plant_invasion_fia = list(
    formula_pub = "InvTotalCover ~ 41 predicteurs ecologiques (climat, sol, diversite/phylogenie des arbres) [Random Forest spatial]",
    formula_used = "InvTotalCover ~ Mean_Annual_Temp + annual_Precip + Seasonability + alt + PLT_TPA + Tpha + RelDen + prpfor + plt_drybio_adj + native_spp + PD_all + PSV_all + PSR_all + anmeantemp + anprecip + soilcarbon",
    source_ref = "Shen, LaRue, Fei & Zhang (2024), Ecology and Evolution, DOI 10.1002/ece3.11605; README.md (Dryad 10.5061/dryad.0rxwdbs8t) definit LAT/LON et 41 variables ecologiques auxiliaires, avec InvTotalCover explicitement documente comme 'sum of cover estimates for all invasive plants'. Papier p.4: apurement applique dans le loader via complete.cases() sur les 46071 placettes brutes ('after excluding plots with missing values, we eventually got 42,314 samples for analyses') -> N=42612 localement, ecart residuel de 298 lignes vs le N publie probablement du a un controle qualite supplementaire non detaille dans les pages consultees."
  ),
  maine_baseflow = list(
    formula_pub = "AUGAVGBF ~ SANDGRAVAF + JULYAVPRE [BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]",
    formula_used = "AUGAVGBF ~ SANDGRAVAF + JULYAVPRE",
    source_ref = "Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X.",
    ml_formula = "AUGAVGBF ~ DASQMI + SANDGRAVAF + JULYAVPRE + REGULATED",
    ml_response = "AUGAVGBF",
    ml_predictors = c("DASQMI", "SANDGRAVAF", "JULYAVPRE", "REGULATED"),
    ml_source_type = "generated_system_formula",
    ml_status = "generated",
    ml_source_ref = "Superset genere par le systeme a partir des champs numeriques/binaires disponibles dans le shapefile local (Maine_Mean_August_Baseflow.shp), au-dela des 2 predicteurs de l'equation publiee -- DASQMI et REGULATED n'ont pas de statut de covariable confirme par le papier, a traiter comme features ML exploratoires seulement.",
    ml_estimator_context = c("random_forest", "xgboost", "gamboost")
  ),
  midwest_crop_yield = list(
    formula_pub = "Yield ~ avgPRCP [Z(s) scalaire du modele Eq.1-2 p.3-4 ; Area = omega(s) sert de poids de variance heteroscedastique e(s)~N(0, sigma2/omega(s)), pas de covariable de la moyenne]",
    formula_used = "Yield ~ avgPRCP",
    source_ref = "Park, Li & Li (2022), JASA, DOI 10.1080/01621459.2022.2123333, section 2 p.3 et Eq. (1) p.3-4: le seul covariable scalaire Z(s) du modele est la precipitation annuelle (avgPRCP) ; la taille de terre recoltee (Area, notee omega(s)) est explicitement utilisee comme poids de la variance de l'erreur de sondage (e(s) ~ N(0, sigma_e^2/omega(s))), pas comme predicteur de la moyenne. Le vrai pouvoir predictif du papier vient de trajectoires fonctionnelles de temperature (FPCA), non reproduites localement. MidwestData.RData (supplement JASA) fournit regdat avec Year, State, County (noms complets), Yield et avgPRCP ; jointure verifiee a 98.9% vers tigris::counties().",
    ml_formula = "Yield ~ avgPRCP + Area",
    ml_response = "Yield",
    ml_predictors = c("avgPRCP", "Area"),
    ml_source_type = "generated_system_formula",
    ml_status = "generated",
    ml_source_ref = "Area est ajoute ici uniquement comme feature ML exploratoire supplementaire disponible localement ; le papier ne le traite pas comme une covariable de la moyenne (voir source_ref principal).",
    ml_estimator_context = c("random_forest", "xgboost", "gamboost")
  ),
  network_misspecification_elections = list(
    formula_pub = "votelead ~ gr_an + gr_loc_med_an + gr_glob_med_an + unem_an + unem_loc_med_an + unem_glob_med_an + coalsize + pop + enep [SAR/SLX sous differentes specifications de reseau -- objet methodologique principal du papier]",
    formula_used = "votelead ~ gr_an + unem_an + coalsize + pop + enep",
    source_ref = "Betz, Cook & Hollenbach (2020), Political Analysis, DOI 10.1017/pan.2020.26; KP2012_Benchmarking_Agg_Data.dta (archive PAN Dataverse) est un panel pays x annee electorale (22 pays OCDE, noms de pays en toutes lettres), covariables de vote economique (croissance/chomage a divers niveaux d'agregation). Le papier etudie explicitement le biais de mauvaise specification du reseau spatial -- formula_used est une specification simplifiee, pas la comparaison complete de specifications W du papier."
  ),
  ethiopia_bushcrow_sdm = list(
    formula_pub = "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter [BRT, meilleur modele pour le bush-crow d'apres l'etude anterieure citee]",
    formula_used = "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter",
    source_ref = "Bladon, Donald, Collar, Denge, Dadacha, Wondafrash & Green (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: 5 variables bioclimatiques WorldClim standard (BIO5, BIO4, BIO7, BIO16, BIO17) nommees explicitement. Les .rda Dryad ne contiennent que des points (presence/absence WGS84) sans covariable ; les 5 rasters WorldClim (geodata::worldclim_global, res=2.5 arcmin) ont ete telecharges et extraits localement le 2026-08-12, resolution plus grossiere que celle utilisee dans le papier."
  ),
  ethiopia_whitetailed_swallow_sdm = list(
    formula_pub = "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter [MaxEnt/GLM/GAM]",
    formula_used = "pa ~ max_temp_warmest_month + temp_seasonality + temp_annual_range + precip_wettest_quarter + precip_driest_quarter",
    source_ref = "Bladon et al. (2021), PLOS ONE, DOI 10.1371/journal.pone.0249633, p.3 Materials and methods: memes 5 variables WorldClim que le bush-crow, memes reserves sur la resolution et l'origine externe des covariables (telechargees le 2026-08-12)."
  ),
  desert_tortoise_genotype_niche = list(
    formula_pub = "GenAssociation ~ CLIM1 + CLIM3 + LC + PHYS1 + PHYS2 + SOIL2 + SOIL3 + VEG1 + VEG3 [surface de sortie du modele de niche local original, pas une regression brute]",
    formula_used = "pending",
    y_term_pub = "association genotype-habitat (surface derivee du modele de niche local)",
    x_terms_pub = c("CLIM1", "CLIM3", "LC", "PHYS1", "PHYS2", "SOIL2", "SOIL3", "VEG1", "VEG3"),
    source_ref = "Inman, Fotheringham, Franklin, Esque, Edwards & Nussear (2019), Diversity and Distributions, DOI 10.1111/ddi.12927; le depot Dryad (10.5066/p91v2s8c) ne contient que des rasters .asc deja modelises (co-enregistres, meme grille), pas de points d'echantillon genotype bruts. GenAssociation est une sortie du modele de niche local original, pas une observation empirique -- meme categorie de prudence que beta0_gwr dans ce fichier."
  ),
  trillium_presence_background = list(
    formula_pub = "PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]",
    formula_used = "presence ~ bio1_annual_mean_temperature + bio4_temperature_seasonality + bio5_max_temperature_warmest_month + bio6_min_temperature_coldest_month + bio12_annual_precipitation + bio15_precipitation_seasonality",
    y_term_pub = "proportional occupancy of predicted suitable distribution (PO); presence/background occurrence model is an executable upstream SDM reconstruction, not the paper's final beta-regression response",
    x_terms_pub = c("Flower_Type", "No_ovules", "Seed_weight"),
    formula_candidate_formula = "PO ~ Flower_Type + No_ovules + Seed_weight",
    ml_formula = "presence ~ bio1_annual_mean_temperature + bio4_temperature_seasonality + bio5_max_temperature_warmest_month + bio6_min_temperature_coldest_month + bio12_annual_precipitation + bio15_precipitation_seasonality",
    ml_response = "presence",
    ml_predictors = c("bio1_annual_mean_temperature", "bio4_temperature_seasonality", "bio5_max_temperature_warmest_month", "bio6_min_temperature_coldest_month", "bio12_annual_precipitation", "bio15_precipitation_seasonality"),
    ml_source_type = "derived_from_scientific_publication_plus_public_covariates",
    ml_status = "extracted_needs_review",
    ml_estimator_context = c("random_forest", "xgboost", "gamboost"),
    ml_source_ref = "Executable SDM-style reconstruction from Dryad occurrence CSVs (10.5061/dryad.6m905qg03) plus WorldClim v2.1 bioclimatic rasters. Background pseudo-absences are generated deterministically within species-specific occurrence bounding boxes expanded by one degree. This is a reproducible benchmark surrogate because the paper used ClimateNA ENMs and predicted suitable areas, but the ClimateNA raster stack and final ENM surfaces are not redistributed in the local Dryad files.",
    equation_family = "beta_regression_plus_sdm_reconstruction",
    model_family = "species_distribution_modeling",
    source_ref = "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297. TEI/PDF methods and abstract state that fundamental niches and predicted suitable distributions were estimated using climate-calibrated ecological niche models; PO = occupied distribution area / predicted suitable area; reproductive traits (ovule number, seed set, number of seeds per plant, seed mass, adult biomass, flower type) were related to PO using beta regression and AICc. The local Dryad folder contains occurrence CSVs and Trillium_LifeHistoryTraits.csv, but not the full ClimateNA ENM raster stack; formula_used is therefore a documented executable SDM reconstruction, not a claim to reproduce the final beta-regression exactly."
  ),
  trillium_proportional_occupancy = list(
    formula_pub = "PO ~ Flower_Type + No_ovules + Seed_weight [beta regression; model building also considered seed set, seeds per plant and adult biomass]",
    formula_used = "PO ~ No_ovules + Seed_weight + Flower_Type",
    formula_candidate_formula = "PO ~ reproductive traits",
    y_term_pub = "proportional occupancy of predicted suitable distribution (PO)",
    x_terms_pub = c("Flower_Type", "No_ovules", "Seed_weight", "Seed_setting_rate", "No_seeds_plant", "Biomass"),
    ml_formula = "PO ~ No_ovules + Seed_weight + Flower_Type",
    ml_response = "PO",
    ml_predictors = c("No_ovules", "Seed_weight", "Flower_Type"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "xgboost", "gamboost"),
    ml_status = "confirmed_continuous_response",
    source_ref = "Miller et al. (2021), Diversity and Distributions, DOI 10.1111/ddi.13297: the paper estimates fundamental niches with ENM/MaxEnt, derives proportional occupancy PO, then relates PO to reproductive traits using beta regression and AICc model selection. The local loader uses Trillium_LifeHistoryTraits.csv from Dryad 10.5061/dryad.6m905qg03 and species occurrence centroids from the accompanying occurrence CSVs. This is the continuous regression companion to paper_trillium_presence_background."
  ),
  wildfire_bootleg_severity = list(
    formula_pub = "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501 [modele SAR complet du papier, matching de traitement -- non reproduit ici, benchmark sur les predicteurs bruts]",
    formula_used = "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501",
    source_ref = "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c, fournis par les auteurs) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) comme reponse et la liste exacte des 35 predicteurs du modele du papier. Verifie le 2026-08-12 par recherche exhaustive dans l'archive : 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) sont absentes du depot Dryad public (memes 2 fires) -- non devinees, simplement absentes. formula_used utilise les 34 predicteurs reellement presents (forest_mask/ownership_mask exclus : ce sont des masques de zone d'etude, pas des covariables du papier). Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques)."
  ),
  wildfire_schneider_springs_severity = list(
    formula_pub = "rdnbr ~ Annual_AET_V2_1981_2010 + Annual_Deficit_V2_1981_2010 + Annual_PET_1981_2010 + Annual_PPT_anl_total_1981_2010 + Annual_Tave_anl_mean_1981_2010 + Annual_Tmin_anl_mean_1981_2010 + distance_to_roads_20221021 + distance_to_strms_and_wetlands + distance_to_trt_edge + frs_ss_clipped + gedi_rh100_mean + gedi_rh100_sd + SS_erc + SS_fm100 + SS_fm1000 + SS_minrh + SS_tmmx_celsius + SS_vpd + LF2019_CBD + LF2019_CC + LF2019_CH + scf_20221011 + sdd_20221011 + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230314 + mx_speed_20230310 + northsouthness_mx_speed_direction_20230314 [meme modele SAR que Bootleg, second incendie du papier]",
    formula_used = "rdnbr ~ Annual_AET_V2_1981_2010 + Annual_Deficit_V2_1981_2010 + Annual_PET_1981_2010 + Annual_PPT_anl_total_1981_2010 + Annual_Tave_anl_mean_1981_2010 + Annual_Tmin_anl_mean_1981_2010 + distance_to_roads_20221021 + distance_to_strms_and_wetlands + distance_to_trt_edge + frs_ss_clipped + gedi_rh100_mean + gedi_rh100_sd + SS_erc + SS_fm100 + SS_fm1000 + SS_minrh + SS_tmmx_celsius + SS_vpd + LF2019_CBD + LF2019_CC + LF2019_CH + scf_20221011 + sdd_20221011 + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230314 + mx_speed_20230310 + northsouthness_mx_speed_direction_20230314",
    source_ref = "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables_20221108.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_SchneiderSprings_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 34 predicteurs pour le second incendie (Washington, 2021). Memes 2 couches ecostress absentes du depot public (verifie le 2026-08-12) ; aspect_10res egalement absent. forest_mask present mais exclu de formula_used (masque de zone d'etude). Noms de fichiers legerement differents de Bootleg (versions/dates dans le nom) mais memes categories de variables."
  ),
  amphibian_malformation_prevalence = list(
    formula_pub = "skeletal_abnormality_prevalence ~ dragonfly_abundance + organic_contaminants + inorganic_contaminants [regression logistique individuelle + selection AIC, Reeves et al. 2010 ; X publies (predateurs, contaminants, UVB, temperature) non presents dans le depot Dryad brut]",
    formula_used = "prevalence_abnormal ~ ROADDISTANCE + RoadType [X partiel : seul le sous-ensemble route/contamination humaine du papier est present dans le depot brut, disponible pour 32/54 sites]",
    source_ref = "Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro)."
  ),
  hyena_lion_biomass_africa = list(
    formula_pub = "spotted_hyaena_biomass_log10 / lion_biomass_log10 ~ prey biomass classes + other predator biomass + WorldClim temperature/precipitation + vegetation cover [PLS regression]",
    formula_used = "spotted_hyaena_biomass_log10 ~ other_predator_biomass_log10 + prey_very_small_biomass_log10 + prey_small_biomass_log10 + prey_medium_biomass_log10 + prey_large_biomass_log10 + prey_very_large_biomass_log10 + min_temperature_coolest_month_log10 + max_temperature_warmest_month_log10 + precipitation_wettest_month_log10 + precipitation_driest_month_log10 + precipitation_seasonality_log10 + semi_open_vegetation_clr + open_vegetation_clr + closed_vegetation_clr",
    formula_candidate_formula = "spotted_hyaena_biomass_log10 ~ prey biomass classes + other predator biomass + climate + vegetation cover",
    y_term_pub = "spotted hyena and lion population biomass density, base-10 log transformed",
    x_terms_pub = c("other predator biomass", "very small prey biomass", "small prey biomass", "medium prey biomass", "large prey biomass", "very large prey biomass", "minimum temperature of coolest month", "maximum temperature of warmest month", "temperature seasonality", "precipitation wettest month", "precipitation driest month", "precipitation seasonality", "closed vegetation cover", "semi-open vegetation cover", "open vegetation cover"),
    source_ref = "Jones (2021), Ecology and Evolution, DOI 10.1002/ece3.8359: Sections 2.1-2.2 state that 30 site-year datasets from 14 African sites were analysed with partial least squares regression, using spotted hyena and lion biomass as dependent variables and prey biomass, other predator biomass, temperature, precipitation and vegetation cover as predictors. The Dryad workbook supplies the transformed log10 variables and median coordinates used by the loader."
  ),
  bumblebee_colony_reproduction = list(
    formula_pub = "colony reproductive output ~ weather + floral cover + urban/land-use metrics [GLM/GLMM model-selection context]",
    formula_used = "Tot_rep ~ Ave_temp + Ave_hum + Sum_prec + Prop_flower500 + Prop_imp500 + Prop_urb500 + Prop_open500 + Prop_tree500 + Prop_ag500 + Prop_gard500 + Prop_road500 + X500PC1 + X500PC2",
    formula_candidate_formula = "Tot_rep ~ weather + floral cover + land-use composition around colony sites",
    y_term_pub = "colony reproductive output: total males plus gynes produced",
    x_terms_pub = c("temperature", "humidity", "precipitation", "flower cover", "impervious surface", "urban cover", "open cover", "tree cover", "agricultural cover", "garden cover", "road cover", "land-use PCA axes"),
    source_ref = "Samuelson et al. (2018), Proceedings B, DOI 10.1098/rspb.2018.0807: colony-level reproductive success is analysed against local floral resources, land use and weather covariates. The raw ColonyData table contains the response and covariates; Lat/Lon labels are numerically inverted for southern England and are corrected in the loader."
  ),
  rocky_mountain_tree_growth = list(
    formula_pub = "annual tree growth / ring width ~ climate + competition + topography [mixed-effects tree-growth model]",
    formula_used = "mean_ring_width_mm ~ elevation_m + aspect_degrees + terrain_slope_pct + mean_stem_diameter_cm + mean_age_years + neighbor_count + neighbor_dbh_sum + neighbor_distance_mean",
    formula_candidate_formula = "mean_ring_width_mm ~ topography + tree size/age + local neighbour competition",
    y_term_pub = "annual radial growth / ring width",
    x_terms_pub = c("climate", "neighbour competition", "stem diameter", "age", "elevation", "aspect", "slope"),
    source_ref = "Buechling et al. (2017), Journal of Ecology, DOI 10.1111/1365-2745.12782: the paper models tree growth using climate and competition effects. The local benchmark collapses annual ring-width observations to one spatial record per sampled tree and joins neighbour-count/DBH summaries; climate time series are not reconstructed in this loader."
  ),
  harbour_porpoise_response = list(
    formula_pub = "response_24h ~ log(distance_to_piling) * cumulative_piling_order + received_SEL + ADD + piling_duration + vessel_activity + random_effect(CPOD_site/POD) [binomial probit GLMM]",
    formula_used = "prop24 ~ distance + vessels24_1km + duration + piling_order + Unweighted_SS_SEL + NOAA_SS_SEL + Southall_SS_SEL + Aud_SS_SEL",
    formula_candidate_formula = "prop24 ~ distance + vessel activity + piling duration/order + sound exposure levels",
    y_term_pub = "binary behavioural response and proportional DPH change after piling",
    x_terms_pub = c("distance", "received sound exposure level", "cumulative piling order", "ADD use", "piling duration", "vessel activity"),
    source_ref = "Graham et al. (2019), Royal Society Open Science, DOI 10.1098/rsos.190335: Material and methods model binary response with probit GLMM; distance/log distance and received SEL are used in separate models, with cumulative piling order, ADD, duration and vessel activity. The current regression benchmark uses the continuous proportional 24h DPH change prop24 from the same response table, joined to CPOD coordinates."
  ),
  amazon_tree_dominance = list(
    formula_pub = "mean local abundance ~ regional frequency + habitat type [beta regression for dominant species]",
    formula_used = "mean_local_relative_abundance ~ regional_frequency + habitat_floodplain + habitat_swamp + habitat_white_sand",
    formula_candidate_formula = "mean_local_relative_abundance ~ regional_frequency + habitat type",
    y_term_pub = "dominant-species mean local abundance / dominance pattern",
    x_terms_pub = c("regional frequency", "habitat type"),
    source_ref = "Matas Granados et al. (2023), Ecology Letters, DOI 10.1111/ele.14351: the paper's best-fit beta regression relates mean local abundance and regional frequency of dominant tree species by habitat type. The local loader now reconstructs the dominant-species/habitat table from Raw_to_ecology3.csv and Metadata4.csv: p_ij = abundance of species i in plot j / total individuals in plot j, dominant species are selected until 50% cumulative habitat dominance, regional_frequency is the proportion of habitat plots where the species occurs, and coordinates are occurrence centroids. This is closer to the published beta-regression than the earlier plot-level reduction."
  ),
  joshua_tree_flowering = list(
    formula_pub = "flowering indicator ~ annual precipitation + maximum/minimum temperature + vapor-pressure-deficit predictors [BART classification]; hindcast flowering years ~ selected climate deltas [continuous model output]",
    formula_used = "flyrs ~ Delta.Y1.2..PPT..mm. + Delta.Y0.1..PPT..mm. + Max.VPD.Y0...hPa. + Delta.Y0.1..Min.VPD..hPa. + Delta.Y0.1..Max.Temp..degree.C. + Min.Temp.Y0...degree.C.",
    formula_candidate_formula = "flyrs ~ selected annual weather deltas from the BART hindcast",
    y_term_pub = "binary flowering event indicator for model training; predicted number of flowering years for hindcast summaries",
    x_terms_pub = c("Delta[Y1-2]*PPT", "Delta[Y0-1]*PPT", "Max VPD[Y0]", "Delta[Y0-1]*Min VPD", "Delta[Y0-1]*Max Temp", "Min Temp[Y0]"),
    ml_formula = "flyrs ~ selected climate deltas",
    ml_response = "flyrs",
    ml_predictors = c("Delta.Y1.2..PPT..mm.", "Delta.Y0.1..PPT..mm.", "Max.VPD.Y0...hPa.", "Delta.Y0.1..Min.VPD..hPa.", "Delta.Y0.1..Max.Temp..degree.C.", "Min.Temp.Y0...degree.C."),
    ml_estimator_context = c("random_forest", "xgboost", "gamboost"),
    ml_status = "confirmed_continuous_hindcast_response",
    source_ref = "Yoder et al. (2024), Ecology Letters, DOI 10.1111/ele.14478: Sections Data compilation, Predictor selection and Hindcasting state that binary flowering observations were modelled with BART and then hindcast to 1900. The Dryad output archive contains jotr_flowering_predictors_change.csv, which reports continuous predicted flowering years (flyrs) by 4 km grid cell/timeframe with the six selected climate-change predictors. formula_used uses this continuous hindcast output, not the raw binary flr training response."
  ),
  wildfire_greenup_nbr5 = list(
    formula_pub = "NBR_year5 ~ postfire precipitation total + precipitation coefficient of variation + slope length factor + soil erodibility + fire-year NBR + growing-season VPD + climatic water deficit + precipitation + maximum temperature + fire month [random forest]",
    formula_used = "nbr_5_year ~ postfire_precipitation_total + postfire_precipitation_coefvar + ls_factor + KFACTWS_DC + nbr_0_year + vpd5 + def5 + ppt5 + tmax5 + month",
    formula_candidate_formula = "nbr_5_year ~ year-of-fire erosion factors + year-5 growing-season climate",
    y_term_pub = "Normalized Burn Ratio five years after fire, proxy for post-fire greenness",
    x_terms_pub = c("postfire_precipitation_total", "postfire_precipitation_coefvar", "ls_factor", "KFACTWS_DC", "nbr_0_year", "vpd5", "def5", "ppt5", "tmax5", "month"),
    source_ref = "Crockett et al. (2024), Fire Ecology, DOI 10.1186/s42408-024-00264-0: Data and Results sections describe random forest models for post-fire NBR years 1-5 using year-of-fire precipitation/topography/soil variables plus growing-season climate. The Dryad README documents train_nbr5 with 1,382,557 pixels; the loader keeps a deterministic 50,000-row subset stratified by 20x20 spatial tiles and 5 quantile bins of NBR for package-scale benchmarking, and records the full raw N in the fiche rationale."
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
    benchmark_status = "needs_covariate_join",
    benchmark_task = "regression_spatial_econometrics",
    package_include = "no",
    missing_items = "reconcilier les NUTS3 du papier avec le LAD extrait (0 covariable locale actuellement, formula_used=pending), joindre les covariables publiees de Table 6/Table 9, puis reconstruire W NUTS3",
    reason = "Le papier modelise 134 regions NUTS3 avec un tableau X documente, alors que l'extraction actuelle contient 380 LAD et seulement les agregats PV locaux (0 covariable explicative, non executable) -- statut normalise depuis needs_covariate_join_and_nuts3_reconciliation (2026-08-12)."
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
    benchmark_status = "ready",
    benchmark_task = "derived_continuous_species_richness_regression",
    package_include = "yes",
    missing_items = "reponse log1p_species_richness derivee (agregation continue de comptages d'occurrence reels, pas une sortie de modele) ; ne reproduit pas les SDM PO/PA integres complets du papier et n'inclut pas cloud cover/TRI",
    reason = "Y derive mais defendable (transformation d'un comptage empirique reel), covariables CHELSA/EVI locales et coordonnees disponibles, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_derived_regression."
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
  ethiopia_clusters = list(
    benchmark_status = "not_ready_derived_clusters",
    benchmark_task = "cluster_detection_output",
    package_include = "no",
    missing_items = "retrouver le jeu DHS/GWR original ou rester hors benchmark",
    reason = "Le fichier contient des clusters SaTScan derives, pas les observations de malnutrition utilisees pour la GWR."
  ),
  pallid_bat = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_continuous_spatial_sar",
    package_include = "manual_review",
    missing_items = "documenter que centroid_size est derive des landmarks TPS et verifier l alignement exact lateral/ventral avec la mesure privilegiee dans le papier",
    reason = "Les rasters Dryad NPP/WorldClim utilises dans le papier sont maintenant joints localement aux specimens; formule executable disponible avec reserve sur le proxy de taille."
  ),
  swiss_rainfall = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_ogc_spatial_covariates",
    package_include = "yes",
    missing_items = "X = covariables spatiales construites par OGC (pas des covariables environnementales) ; nombre d'angles fixe a 6, pas de tuning",
    reason = "Le papier Moller et al. (2020) compare explicitement OGCs, EDFs, RFsp et kriging sur Swiss rainfall (benchmark SIC97 classique) ; le loader genere des covariables OGC reproductibles depuis la geometrie. Y continu, X defendable (technique explicitement testee par le papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_spatial_covariates."
  ),
  vindum = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_ogc_aux_spatial_covariates",
    package_include = "yes",
    missing_items = "X combine 19 auxiliaires publiees du package OGC (Vindum_covariates) et 6 covariables OGC generees localement -- documenter cette composition mixte lors de l'usage",
    reason = "Le papier Moller et al. (2020) utilise SOM avec OGCs, avec et sans auxiliaires ; le loader extrait les 19 covariables auxiliaires Vindum_covariates du package OGC cite explicitement par le papier et ajoute six covariables OGC reproductibles. Y continu, X defendables (source publiee + technique testee par le papier), N=285 confirmes, artefact local utilisable -- promu sans revue manuelle (2026-08-12), statut normalise depuis almost_ready_ogc_aux_spatial_covariates."
  ),
  no2_grid = list(
    formula_pub = "NO2 ~ f(selected predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]",
    formula_used = "pending",
    formula_candidate_formula = "pending",
    y_term_pub = "monitored daily NO2 concentration at AQS sites",
    x_terms_pub = c("spatially_lagged_NO2", "temporally_lagged_NO2", "meteorological_variables", "OMI_NO2", "GEOS_Chem_NO2", "CMAQ_NO2", "NLCD_land_cover", "truck_traffic", "road_density", "restaurant_density", "elevation", "NDVI", "nighttime_light", "aerosol_variables", "cloud_cover", "surface_albedo", "MODIS_reflectance", "CAMS_NO2"),
    ml_formula = "monitored_NO2 ~ selected predictor variables from satellite, CTM, meteorology, land-cover and spatial/temporal lag families",
    ml_response = "monitored daily NO2 concentration",
    ml_predictors = c("spatially_lagged_NO2", "temporally_lagged_NO2", "meteorological_variables", "OMI_NO2", "GEOS_Chem_NO2", "CMAQ_NO2", "NLCD_land_cover", "truck_traffic", "road_density", "restaurant_density", "elevation", "NDVI", "nighttime_light", "aerosol_variables", "cloud_cover", "surface_albedo", "MODIS_reflectance", "CAMS_NO2"),
    ml_source_ref = "Di et al. (2019), Environmental Science & Technology, DOI 10.1021/acs.est.9b03358: abstract and Sections 2.1-3.5 describe monitored NO2 as the response, spatial/temporal lagged NO2, meteorology, OMI, GEOS-Chem, CMAQ, land-cover, traffic, elevation, NDVI, nighttime light, aerosols, cloud and albedo predictors, and neural network, random forest, gradient boosting plus geographically weighted GAM ensemble. The current local grid .rds contains final predicted NO2 values only; it does not contain the monitor-level training matrix.",
    ml_estimator_context = c("random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"),
    ml_status = "confirmed_feature_groups",
    source_ref = "Di et al. (2019), Environmental Science & Technology, DOI 10.1021/acs.est.9b03358. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data.",
    equation_family = "ensemble_ml_geographically_weighted_gam",
    model_family = "neural network + random forest + gradient boosting ensemble via geographically weighted GAM"
  ),
  o3_grid = list(
    formula_pub = "O3 ~ f(169 predictor variables) [neural network, random forest, gradient boosting; ensemble via geographically weighted generalized additive model]",
    formula_used = "pending",
    formula_candidate_formula = "pending",
    y_term_pub = "daily maximum 8 h O3 concentration at monitoring sites",
    x_terms_pub = c("meteorological_variables", "chemical_transport_model_outputs", "remote_sensing_observations", "land_use_variables", "CMAQ", "GEOS_Chem", "spatiotemporally_lagged_O3", "nearby_monitor_weighted_O3", "AOD", "NDVI", "road_density", "tree_canopy", "developed_area"),
    ml_formula = "monitored_O3 ~ 169 predictor variables from weather, CTM, remote sensing, land-use and spatiotemporal lag families",
    ml_response = "daily maximum 8 h O3 concentration",
    ml_predictors = c("meteorological_variables", "chemical_transport_model_outputs", "remote_sensing_observations", "land_use_variables", "CMAQ", "GEOS_Chem", "spatiotemporally_lagged_O3", "nearby_monitor_weighted_O3", "AOD", "NDVI", "road_density", "tree_canopy", "developed_area"),
    ml_source_ref = "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791: Sections 2.1-2.5 describe monitored daily maximum 8 h O3 as the response, 169 predictors consolidated from weather, CTM outputs, remote sensing and land-use data, random-forest imputation, neural network, random forest, gradient boosting, and a geographically weighted GAM ensemble. The current local grid .rds contains final predicted O3 values only; it does not contain the monitor-level training matrix.",
    ml_estimator_context = c("random_forest", "gradient_boosting", "neural_network", "gam_spatial", "gwr"),
    ml_status = "confirmed_feature_groups",
    source_ref = "Requia et al. (2020), Environmental Science & Technology, DOI 10.1021/acs.est.0c01791. The publication documents the training response, predictor families and ensemble models, but the downloaded local grid files are prediction products, not raw Y/X training data.",
    equation_family = "ensemble_ml_geographically_weighted_gam",
    model_family = "neural network + random forest + gradient boosting ensemble via geographically weighted GAM"
  ),  biomass_rainforest = list(
    benchmark_status = "needs_covariate_join",
    benchmark_task = "regression_continuous",
    package_include = "no",
    missing_items = "joindre LANDScapes/GEOL/VEGET (3 des 7 effets retenus par le papier, AIC) et reconstruire la composante de krigeage des residus pour reproduire le GLM/KR complet",
    reason = "AGB_mean est reconstruit depuis le supplement PLOS; HAND, LOG, ALT et SLO sont maintenant joints localement, mais LANDScapes, GEOL, VEGET et la composante de krigeage des residus restent absents -- 3 des 7 covariables du modele AIC selectionne par le papier manquent encore, gap trop important pour promotion (2026-08-12), statut normalise depuis local_reduced_formula."
  ),
  # -- Lot DataCite 2026-08 (harvest verifie, session du 2026-08-12) --------
  coral_bathypathes = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review",
    missing_items = "confirmer le choix de Random Forest/BRT comme estimateurs de reference pour ce type de benchmark presence/absence",
    reason = "pa binaire, 14 covariables environnementales et coordonnees WGS84 tous confirmes par contenu reel (README Dryad + verification du CSV)."
  ),
  coral_corallium = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes (README Dryad commun aux 12 taxons)."
  ),
  coral_enallopsammia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_errina = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_goniocorella = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_isididae = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_leiopathes = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_madrepora = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_paragorgia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_primnoa = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_solenosmilia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_stylaster = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review", missing_items = "idem coral_bathypathes",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  early_season_biomass = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun bloquant identifie",
    reason = "late_bm_kg_ha continu, 5 covariables meteo/agronomiques documentees dans data_dictionary.csv, coordonnees WGS84, N=512 confirmes par contenu reel. Y continu, X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  influenza_mortality_chicago = list(
    benchmark_status = "ready", benchmark_task = "regression_count_spatiotemporal",
    package_include = "yes",
    missing_items = "structure panel tract x semaine (T=7) documentee ; a surveiller si le schema de CV du package suppose des observations independantes",
    reason = "counts, offset pop, covariables sociodemographiques et geometrie polygone (jointure GISJOIN verifiee) tous confirmes ; structure spatio-temporelle (496 tracts x 7 semaines). Y defendable (count + offset), X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  plant_invasion_fia = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "InvTotalCover retenu comme reponse principale (formula_used) ; InvSpRichness reste une reponse alternative candidate dans le meme artefact",
    reason = "41 covariables ecologiques documentees dans README.md, LAT/LON confirmes, N=42612 apres apurement complete.cases() (papier: N=42314 apres exclusion des placettes a valeurs manquantes, p.4) -- le plus grand jeu du lot. Y continu, X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  maine_baseflow = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "geometrie source LINESTRING (reseau hydrographique) ; deja convertie en POINT (geom_point, st_point_on_surface) dans l'artefact local via build_unified_sf(), famille geom_family='ligne' geree nativement -- pas un blocage",
    reason = "AUGAVGBF et covariables NHDPlus (SANDGRAVAF, JULYAVPRE) confirmees par l'equation publiee (Eq.1 p.1258). Y continu, X defendables, artefact local deja en POINT et utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  midwest_crop_yield = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "une seule covariable numerique locale (avgPRCP, le seul Z(s) scalaire reel du papier) ; les predicteurs fonctionnels/spline (trajectoires de temperature FPCA) ne sont pas reproduits localement",
    reason = "Yield continu, jointure comte verifiee a 98.9% (tigris), formula_used = formule exacte du papier (le seul covariable scalaire reel, Area est un poids de variance non un predicteur). Y continu, X defendable (correspond exactement au papier), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  network_misspecification_elections = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous_panel",
    package_include = "yes",
    missing_items = "le papier etudie la mauvaise specification du reseau spatial W comme objet methodologique principal ; formula_used est une specification simplifiee documentee, pas la comparaison complete de specifications W du papier",
    reason = "votelead continu et covariables de vote economique confirmees (panel pays x annee, 22 pays, T=65 annees electorales distinctes). Y continu, X defendables (issus du jeu KP2012 reel), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  ethiopia_bushcrow_sdm = list(
    benchmark_status = "almost_ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review",
    missing_items = "covariables WorldClim ajoutees localement le 2026-08-12 a une resolution (2.5 arcmin) plus grossiere que celle utilisee dans le papier ; points de fond (pseudo-absences) non utilises",
    reason = "pa binaire et 5 variables bioclimatiques nommees dans le papier confirmees, mais les covariables viennent d'une source externe (WorldClim) rajoutee cette session, pas du depot Dryad original."
  ),
  ethiopia_whitetailed_swallow_sdm = list(
    benchmark_status = "almost_ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "manual_review",
    missing_items = "idem ethiopia_bushcrow_sdm",
    reason = "Meme source/reserve que ethiopia_bushcrow_sdm."
  ),
  desert_tortoise_genotype_niche = list(
    benchmark_status = "not_ready_derived_response", benchmark_task = "derived_model_output",
    package_include = "no",
    missing_items = "retrouver les points d'echantillonnage genotype bruts (non fournis dans le depot Dryad, uniquement des surfaces .asc deja modelisees)",
    reason = "GenAssociation est une sortie du modele de niche local original (surface interpolee), pas des observations genotype-habitat brutes -- meme categorie que beta0_gwr dans ce fichier."
  ),
  trillium_presence_background = list(
    benchmark_status = "almost_ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "manual_review",
    missing_items = "le registre spatialtidymodels doit accepter un mode classification/binomial avant inclusion package ; verifier que le schema de background pseudo-absence convient a l'objectif benchmark",
    reason = "Occurrences Trillium Dryad et covariables WorldClim publiques sont disponibles dans l'artefact local ; la formule executable est une reconstruction SDM presence/background. Le papier publie toutefois une beta-regression espece-niveau PO ~ traits reproductifs, donc la fiche documente clairement l'ecart entre analyse publiee et benchmark executable."
  ),
  wildfire_bootleg_severity = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m) -- compromis de resolution documente, pas la resolution native de chaque couche ; 3 couches documentees dans predictor_variables.csv du papier (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public",
    reason = "rdnbr continu et 34 des 35 predicteurs documentes par les auteurs (csvs/predictor_variables.csv) confirmes et alignes (2026-08-12). Y continu, X defendables (liste exacte des auteurs, ecart documente pas invente), artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  wildfire_schneider_springs_severity = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "meme reserve que wildfire_bootleg_severity : grille reechantillonnee a 250m Albers, 3 couches du papier absentes du depot public",
    reason = "Meme source/structure que wildfire_bootleg_severity, second incendie (Washington 2021) du meme papier. Y continu, X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
  ),
  amphibian_malformation_prevalence = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "X limite a ROADDISTANCE/RoadType (32/54 sites, NA ailleurs) -- les contaminants/predateurs/UVB du modele publie ne sont pas dans le depot Dryad brut ; version continue derivee du Y binaire individuel, pas une reproduction exacte du Table 1 de l'article (fenetre temporelle plus large, 2000-2012 vs 2004-2006)",
    reason = "Y continu et defendable (prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab agreges depuis 9011 individus, seuil n>=50/site repris du Table 1 de Reeves et al. 2010), coordonnees reelles (SiteLocations.csv), X partiel mais reel et motive par le papier (ROADDISTANCE/RoadType), artefact local utilisable -- promu le 2026-08-13 apres correction du PDF errone et telechargement complet du depot Dryad (85 fichiers, dont FrogAbnormalities.csv absent du telechargement initial partiel)."
  ),
  hyena_lion_biomass_africa = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_small_n",
    package_include = "yes",
    missing_items = "petit N=30 a signaler dans les comparaisons ; le papier travaille lui-meme sur 30 observations site-annee, donc ce n'est pas un defaut de reconstruction",
    reason = "Le papier et le workbook Dryad fournissent 30 observations site-annee avec coordonnees medianes, Y continues log10 et 15 X transformees. Le petit N est conforme a l'analyse publiee et documente comme benchmark small-N."
  ),
  bumblebee_colony_reproduction = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_count_small_n",
    package_include = "manual_review",
    missing_items = "N=38 seulement ; verifier si Tot_rep doit etre traite comme regression continue ou comptage",
    reason = "ColonyData fournit coordonnees corrigees, sortie reproductive Tot_rep et covariables meteo/land-use/floral cover. Benchmark utile mais petit et non strictement gaussien."
  ),
  rocky_mountain_tree_growth = list(
    benchmark_status = "almost_ready",
    benchmark_task = "regression_continuous_reduced_cross_section",
    package_include = "manual_review",
    missing_items = "climat temporel du modele publie non reconstruit ; artefact local agrégé par arbre",
    reason = "Le loader produit une coupe spatiale par arbre avec ring width moyen et competition locale. C'est executable, mais reduit par rapport au modele temporel climat x competition du papier."
  ),
  harbour_porpoise_response = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "la reponse publiee principale est binaire ; formula_used utilise prop24 continu pour le package de regression",
    reason = "Le tableau local fournit prop24 continu, coordonnees CPOD, distance, exposition sonore, ordre/duree de battage et activite navire. Version continue defendable et tracee."
  ),
  amazon_tree_dominance = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_proportion",
    package_include = "yes",
    missing_items = "coordonnees = centroide des occurrences de l'espece dans l'habitat, car l'unite statistique publiee est espece/habitat et non un point individuel unique",
    reason = "Le loader reconstruit la table espece/habitat du papier depuis les arbres bruts et les metadonnees de parcelles : mean local abundance, regional frequency et habitat type. La reponse est continue dans (0,1), compatible avec un benchmark de regression avec reserve sur l'unite spatiale centroide."
  ),
  joshua_tree_flowering = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_model_output",
    package_include = "yes",
    missing_items = "la reponse locale flyrs est une sortie continue du hindcast BART, pas l'observation binaire brute flr ; conserver cette nuance dans toute interpretation benchmark",
    reason = "Le papier entraine un BART sur flr binaire, puis publie des sorties continues de hindcast par cellule et periode. Le loader utilise flyrs et les six predicteurs climatiques de changement fournis dans l'archive, ce qui cree une version continue documentee sans transformer arbitrairement flr."
  ),
  trillium_proportional_occupancy = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_proportion",
    package_include = "yes",
    missing_items = "petit nombre d'especes apres complete.cases ; coordonnees = centroide des occurrences par espece, car l'unite statistique du papier est espece-niveau",
    reason = "PO est une reponse continue dans (0,1) directement fournie dans Trillium_LifeHistoryTraits.csv, avec traits reproductifs publies. Cette fiche suit la beta-regression finale du papier mieux que la version presence/background."
  ),
  wildfire_greenup_nbr5 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "artefact package sous-echantillonne deterministiquement a 50000 lignes sur 1382557 par tuiles spatiales 20x20 et quantiles de NBR ; utiliser le raw complet pour analyses lourdes",
    reason = "Y continu NBR annee 5, X climatiques/sol/topographie documentees dans README et papier, coordonnees lon/lat. Sous-echantillonnage spatialement stratifie et stratifie par reponse pour eviter un benchmark package trop lourd tout en gardant la couverture spatiale et le gradient de NBR."
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
classify_typology <- function(col, name = "") {
  if (!is.atomic(col)) return(list(typology = "unknown", range = NA_character_))
  cls <- class(col)[1]
  if (cls %in% c("factor", "character")) return(list(typology = "categorical", range = NA_character_))
  if (!cls %in% c("numeric", "double", "integer", "logical")) return(list(typology = "unknown", range = NA_character_))
  vals <- suppressWarnings(range(col, na.rm = TRUE))
  n_uniq <- length(unique(stats::na.omit(col)))
  nm <- tolower(name)
  if (cls == "logical" || all(stats::na.omit(col) %in% c(0, 1)))
    return(list(typology = "binary", range = "{0, 1}"))
  if (cls %in% c("numeric", "double")) {
    if (is.finite(vals[1]) && is.finite(vals[2]) && vals[1] >= 0 && vals[2] <= 1 && n_uniq > 5)
      return(list(typology = "rate", range = paste0("[", round(vals[1], 4), ", ", round(vals[2], 4), "]")))
    return(list(typology = "continuous", range = paste0("[", round(vals[1], 4), ", ", round(vals[2], 4), "]")))
  }
  if (cls == "integer") {
    # Some paper datasets store measured continuous variables as integer
    # values. Keep true event/count variables as counts, but avoid classifying
    # rainfall or similar physical measures as count processes.
    if (grepl("rain|precip|temperature|temp|capacity|biomass|agb|carbon|yield|elev|alt|slope", nm)) {
      return(list(typology = "continuous", range = paste0("[", vals[1], ", ", vals[2], "]")))
    }
    return(list(typology = "count", range = paste0("[", vals[1], ", ", vals[2], "]")))
  }
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
  # Exclut les covariables bioclimatiques/climatiques dont le nom contient un
  # token temporel (ex. max_temp_warmest_month, precip_driest_quarter) mais
  # qui ne sont PAS une variable temps -- bug observe sur les fiches SDM
  # ethiopia_bushcrow_sdm / ethiopia_whitetailed_swallow_sdm (session 2026-08-12).
  if (grepl("warmest|coldest|wettest|driest|seasonality|isotherm|bioclim|_bio\\d", nm)) return(FALSE)
  if (!grepl("(^|[_.])(date|datetime|time|timestamp|year|month|week|day|period|season)([_.]|$)|^date$|^time$|^year$|^yr$|^month$",
             nm, perl = TRUE)) return(FALSE)
  exact_time_name <- grepl("^(date|datetime|time|timestamp|year|yr|month|week|day|period|season)$",
                           nm, perl = TRUE)
  values <- col[!is.na(col)]
  if (!exact_time_name && is.numeric(values) && length(values)) {
    unique_ratio <- length(unique(values)) / length(values)
    non_integer <- any(abs(values - round(values)) > sqrt(.Machine$double.eps), na.rm = TRUE)
    if (non_integer && unique_ratio > 0.2) return(FALSE)
  }
  inherits(col, c("Date", "POSIXt")) || is.character(col) || is.factor(col) || is.integer(col) || is.numeric(col)
}

infer_T <- function(df, vars, declared_datetime = NULL) {
  # Priorite au champ datetime_columns declare par le loader (row$datetime_columns)
  # -- ex. "elecyr" (network_misspecification_elections), "MEASYEAR"
  # (plant_invasion_fia) : ces noms ne matchent pas le regex heuristique
  # ci-dessous (pas de separateur avant "yr"/"year") et etaient donc ignores,
  # forcant a tort une structure coupe_transversale/T=1 sur des panels reels
  # (bug observe sur paper_network_misspecification_elections, session
  # 2026-08-12). Le declaratif du loader est une source de verite plus fiable
  # que le heuristique par nom de colonne.
  declared_datetime <- trimws(unlist(strsplit(declared_datetime %||% "", ",")))
  if (any(tolower(declared_datetime) %in% c("none", "aucun", "no", "false"))) {
    return(list(T = 1L, T_var = NA_character_, structure = "coupe_transversale", data_type = "spatial"))
  }
  declared_datetime <- declared_datetime[nzchar(declared_datetime) & declared_datetime %in% vars]
  if (length(declared_datetime)) {
    cand <- declared_datetime[1]
    values <- df[[cand]]
    T_val <- length(unique(values[!is.na(values)]))
    if (T_val > 1L) return(list(T = T_val, T_var = cand, structure = "panel_ou_series", data_type = "spatio-temporel"))
  }
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

extract_formula_response <- function(formula_text) {
  if (is.null(formula_text) || !nzchar(formula_text) || formula_text == "pending") return("pending")
  if (!grepl("~", formula_text, fixed = TRUE)) return("pending")
  lhs <- trimws(strsplit(formula_text, "~", fixed = TRUE)[[1]][1])
  if (!nzchar(lhs)) "pending" else lhs
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

infer_yx_selection_rationale <- function(record_id, paper_title, y_vars, x_vars, coord_vars, id_vars, readiness, selected_x = NULL, published_x = NULL, coord_label = NULL) {
  y_txt <- if (length(y_vars)) fmt_bt(y_vars) else "aucune variable reponse candidate"
  selected_x <- selected_x[!is.na(selected_x) & nzchar(selected_x)]
  shown_x <- if (length(selected_x)) selected_x else utils::head(x_vars, 12)
  published_x <- published_x[!is.na(published_x) & nzchar(published_x)]
  x_txt <- if (length(shown_x)) fmt_bt(shown_x) else "aucune covariable explicative locale"
  published_txt <- if (!length(shown_x) && length(published_x)) {
    sprintf(" ; cependant le papier documente les covariables publiees %s, non presentes dans le .rds actuel", fmt_bt(published_x))
  } else ""
  more_txt <- if (length(selected_x)) {
    extra <- setdiff(x_vars, selected_x)
    if (length(extra)) sprintf(" ; %d autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used", length(extra)) else ""
  } else if (length(x_vars) > 12) {
    sprintf(" ; %d autres covariables restent listees dans Detail X", length(x_vars) - 12)
  } else ""
  coord_txt <- if (length(coord_vars)) fmt_bt(coord_vars) else if (!is.null(coord_label) && nzchar(coord_label)) coord_label else "geometrie sf"
  id_txt <- if (length(id_vars)) fmt_bt(id_vars) else "les identifiants detectes"
  status_txt <- if (!is.null(readiness) && !is.null(readiness$benchmark_status)) readiness$benchmark_status else "pending"
  sprintf(
    "Pour `%s`, la ou les reponses %s viennent du loader papier et/ou des preuves de l article `%s`. Les covariables X retenues sont %s%s%s. Les coordonnees (%s), identifiants (%s), geometries et champs techniques sont exclus de X. Statut benchmark actuel : %s ; la promotion package reste conditionnee au bloc benchmark_readiness.",
    record_id, y_txt, paper_title, x_txt, more_txt, published_txt, coord_txt, id_txt, status_txt
  )
}

# -- Description heuristique (topic/observation_unit), meme esprit que
# infer_dataset_description_fields() dans generate_fiches.py mais appliquee
# au titre du papier + au nom du loader plutot qu'a la doc de package. -------
infer_description_fields <- function(record_id, paper_title, geom_type, data_type, kg_rec = NULL) {
  text <- tolower(paste(record_id, paper_title))
  topic <- NULL; unit <- NULL; population <- NULL
  if (grepl("wildfire|green-up|greenup|nbr_5|post-fire|postfire|fire ecology", text)) {
    topic <- "risques naturels / recuperation post-incendie"
    unit <- "pixel spatial echantillonne depuis une grille de feu de haute severite"
    population <- "pixels d'incendies de haute severite aux Etats-Unis, avec NBR post-feu et covariables climat/sol/topographie"
  } else if (grepl("trillium", text)) {
    topic <- "ecologie vegetale / modeles de distribution d'especes"
    unit <- "point d'occurrence ou pseudo-absence background"
    population <- "occurrences georeferencees de 19 especes de Trillium en Amerique du Nord orientale, completees par un background SDM reconstruit"
  } else if (grepl("pollinat|bee|flower|hummingbird|colibri", text)) {
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
  } else if (grepl("cover crop|cereal rye|early.season.biomass|cgdd", text)) {
    topic <- "agronomie / biomasse de culture de couverture"
    unit <- "placette experimentale (site-annee)"
    population <- "essais de seigle d'hiver (cereal rye) sur 11 etats du centre-est/sud-est des Etats-Unis"
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
  } else if (grepl("species distribution|sampling bias", text)) {
    topic <- "modeles de distribution d'especes integres"
    unit <- "occurrence d'espece / cellule de grille"
    population <- "colibris (Trochilidae), Amerique du Sud/Centrale"
  } else if (grepl("cluster detection|spatial regression coefficient", text)) {
    topic <- "methodologie statistique / detection de cluster spatial"
    unit <- "cellule de grille spatiale simulee"
    population <- "donnees simulees (illustration methodologique)"
  } else if (grepl("crash|traffic|road safety|offcrsh|gsvcm", text)) {
    topic <- "transport / securite routiere"
    unit <- "zone spatiale de comptage des accidents"
    population <- "accidents routiers et facteurs socio-demographiques locaux"
  } else if (grepl("agricultural technology|land use|soy|brazilian municipalities", text)) {
    topic <- "agriculture / adoption technologique et usage des sols"
    unit <- "municipalite bresilienne"
    population <- "municipalites agricoles du Bresil"
  } else if (grepl("decapod|bycatch|marine|biodiversity", text)) {
    topic <- "biodiversite marine / captures accessoires"
    unit <- "cellule ou point d'observation marin"
    population <- "decapodes marins captures en peche accessoire"
  } else if (grepl("swiss_rainfall|sic97|rainfall|precipitation", text)) {
    topic <- "climat / precipitation"
    unit <- "station ou point de mesure pluviometrique"
    population <- "mesures de pluie en Suisse, Spatial Interpolation Comparison 1997 / SIC97"
  } else if (grepl("vindum|soil organic matter|som", text)) {
    topic <- "sol / matiere organique"
    unit <- "point d'echantillonnage pedologique"
    population <- "observations de matiere organique du sol du jeu de donnees Vindum"
  } else if (grepl("eberg|soil", text)) {
    topic <- "sol / cartographie pedologique numerique"
    unit <- "observation pedologique ponctuelle"
    population <- "observations de sol du jeu de donnees Ebergoetzen / plotKML"
  }

  kg_theme <- kg_rec$theme %||% ""
  kg_evidence <- kg_rec$evidence %||% ""
  kg_dataset_name <- kg_rec$dataset_name_in_paper %||% ""
  if (is.null(topic) && nzchar(kg_theme)) topic <- kg_theme
  if (is.null(population) && nzchar(kg_evidence)) {
    first_sentence <- trimws(strsplit(kg_evidence, "\\.|\\|")[[1]][1])
    if (nzchar(first_sentence)) population <- first_sentence
  }
  if (is.null(unit) && nzchar(kg_dataset_name)) {
    unit <- sprintf("observation spatiale du dataset \"%s\"", kg_dataset_name)
  }
  list(
    topic = if (is.null(topic)) sprintf("dataset spatial %s", data_type) else topic,
    observation_unit = if (is.null(unit)) sprintf("observation spatiale de type %s", geom_type) else unit,
    observed_population = if (is.null(population)) "a preciser depuis le papier source" else population
  )
}

# -- Formules candidates (meme structure que build_formula_candidates_block()
# dans generate_fiches.py, version simplifiee pour la famille papers). ------
formula_candidates_block <- function(formula, y_term, x_terms_vec, is_published, source_ref = "pending",
                                     ml_formula = NULL, ml_response = NULL, ml_predictors = NULL,
                                     ml_source_ref = NULL, ml_status = "confirmed",
                                     ml_source_type = "scientific_publication",
                                     ml_estimator_context = c("random_forest", "xgboost", "gamboost", "spboost"),
                                     is_binary_task = FALSE) {
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
    multivariate_context <- if (is_binary_task) {
      # reponse binaire : ols/sar_lag/sem_error/sdm_mixed/gwr supposent une
      # erreur gaussienne continue et ne s'appliquent pas ; seuls les
      # estimateurs que le papier a reellement utilises (RF/BRT) sont notes.
      c("random_forest", "gamboost", "xgboost")
    } else {
      c("ols", "sar_lag", "sem_error", "sdm_mixed", "gwr")
    }
    multivariate <- fmt_entry(
      "paper_main_specification", formula, y_term, x_terms_vec,
      "scientific_publication", "confirmed",
      source_ref,
      multivariate_context
    )
  }
  ml_candidate <- fmt_entry("ml_candidate_features")
  if (!is.null(ml_formula) && !is.null(ml_response) && length(ml_predictors)) {
    ml_candidate <- fmt_entry(
      "ml_candidate_features", ml_formula, ml_response, ml_predictors,
      ml_source_type, ml_status,
      ml_source_ref %||% source_ref,
      ml_estimator_context
    )
  } else if (formula != "pending" && !is_published) {
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


estimator_eligibility_block <- function(record_id, readiness, formula_used, x_terms_vec, is_published) {
  status <- readiness$benchmark_status %||% "needs_manual_review"
  task <- readiness$benchmark_task %||% ""
  has_formula <- !is.na(formula_used) && nzchar(formula_used) && formula_used != "pending"
  has_x <- length(x_terms_vec) > 0
  is_ready_like <- grepl("^(ready|almost_ready|manual_review)", status)
  is_not_ready <- grepl("^not_ready", status)
  # Y binaire (SDM presence/absence, etc.) : le registre du package
  # (packages/spatialtidymodels/R/13-benchmark-spatial.R) code en dur
  # mode="regression" pour TOUS les estimateurs automatiques (ols/gam_spatial/
  # gamboost/random_forest*/xgboost*/sar_lag/sem_error/sdm_mixed) -- aucun ne
  # supporte actuellement une reponse binomiale/classification. Verifie le
  # 2026-08-12 par lecture directe du registre. eligible_estimators doit donc
  # rester vide pour une tache binaire ; seuls les estimateurs que le papier a
  # reellement utilises (random forest / boosting) sont notes conditionnels,
  # en attente d'un mode classification dans le registre.
  is_binary_task <- grepl("classification|binary_panel|presence_absence", task, ignore.case = TRUE)
  eligible <- character(0)
  conditional <- character(0)
  ineligible_reason <- ""

  if (is_binary_task && is_ready_like) {
    conditional <- c("random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial")
    ineligible_reason <- "reponse binaire (presence/absence) ; le registre benchmark du package (13-benchmark-spatial.R) code en dur mode='regression' pour tous les estimateurs automatiques -- aucun ne supporte de mode classification/binomial aujourd'hui. random_forest/gamboost/xgboost sont notes conditionnels car ce sont les estimateurs que le papier source a reellement utilises (RF/BRT) ; ols/sar_lag/sem_error/sdm_mixed/gwr restent hors de propos pour une reponse binaire (hypothese gaussienne continue) et ne sont pas listes."
  } else if (is_ready_like && has_formula && has_x) {
    eligible <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
    if (is_published) eligible <- c(eligible, "sar_lag", "sem_error", "sdm_mixed", "gwr")
  } else if (grepl("needs_original_W", status)) {
    eligible <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
    conditional <- c("sar_lag", "sem_error", "sdm_mixed")
    ineligible_reason <- "spatial econometric estimators require the original paper W or an explicitly accepted proxy W"
  } else if (grepl("needs_covariate_join|needs_preprocessing|needs_model_specification_review", status)) {
    conditional <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr")
    ineligible_reason <- "paper evidence exists, but the local .rds is not yet an executable Y/X benchmark table"
  } else if (is_not_ready) {
    ineligible_reason <- "current package supports continuous spatial regression benchmarks; this fiche is not currently an executable continuous-regression dataset"
  } else if (has_formula && has_x) {
    conditional <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
    ineligible_reason <- "manual review required before package promotion"
  } else {
    ineligible_reason <- "missing executable formula_used and/or covariates in the local artifact"
  }

  yaml_vec <- function(x) paste0("[", paste(sprintf('\"%s\"', x), collapse = ", "), "]")
  paste(
    "## Estimator eligibility", "",
    "```yaml", "estimator_eligibility:",
    sprintf('  status: "%s"', status),
    sprintf('  eligible_estimators: %s', yaml_vec(eligible)),
    sprintf('  conditionally_eligible_estimators: %s', yaml_vec(conditional)),
    sprintf('  ineligible_reason: "%s"', gsub('"', "'", ineligible_reason)),
    '  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"',
    "```",
    sep = "\n"
  )
}

# -- Boucle principale ---------------------------------------------------------
n_ok <- 0L
target_records <- commandArgs(trailingOnly = TRUE)
if (length(target_records)) {
  unknown <- setdiff(target_records, names(LOADER_TO_DIR))
  if (length(unknown)) stop("Record_id inconnu(s): ", paste(unknown, collapse = ", "), call. = FALSE)
  records_to_generate <- target_records
} else {
  records_to_generate <- names(LOADER_TO_DIR)
}

for (record_id in records_to_generate) {
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
  time_info <- infer_T(df, vars, declared_datetime = row_meta$datetime_columns)
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

  y_vars_str <- if (length(y_vars)) paste(sprintf("`%s`", y_vars), collapse = ", ") else "not identified - manual review required"
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
  formula_note <- if (formula_used == "pending" && length(y_vars) && !length(x_vars)) "reponse identifiee dans le loader, mais aucune covariable X locale executable n est disponible dans le .rds actuel." else if (formula_used == "pending") "aucune formule Y ~ X utilisable : aucune variable reponse confirmee ou aucune covariable exploitable n est disponible." else "formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source - a confirmer par revue manuelle."
  ov <- FORMULA_OVERRIDES[[record_id]]
  if (!is.null(ov)) {
    if (!is.null(ov$formula_used)) formula_used <- ov$formula_used
    if (!is.null(ov$formula_pub)) formula_pub <- ov$formula_pub
    formula_note <- paste0("Formule/reference verifiee par lecture directe du papier source (session du ", TODAY, "). ", ov$source_ref)
  }

  y_typologies <- if (length(y_vars)) unique(sapply(y_vars, function(v) classify_typology(df[[v]], v)$typology)) else character(0)
  x_typologies <- if (length(x_vars)) unique(sapply(x_vars, function(v) {
    t <- classify_typology(df[[v]], v)$typology
    switch(t, count = "continuous", binary = "categorical", rate = "continuous", t)
  })) else character(0)
  y_typ_str <- if (length(y_typologies)) paste(y_typologies, collapse = ", ") else "unknown"
  x_typ_str <- if (length(x_typologies)) paste(x_typologies, collapse = ", ") else "unknown"

  y_rows <- if (length(y_vars)) paste(sprintf("| `%s` | `%s` | %s | %s | %s%% |", y_vars,
    sapply(y_vars, function(v) class(df[[v]])[1]),
    sapply(y_vars, function(v) classify_typology(df[[v]], v)$typology),
    sapply(y_vars, function(v) md_escape(classify_typology(df[[v]], v)$range)),
    sapply(y_vars, function(v) pct_na_col(df[[v]]))), collapse = "\n")
  else "| -- | -- | aucun candidat | -- | -- |"

  x_rows <- if (length(x_vars)) paste(sprintf("| `%s` | `%s` | %s | %s%% |", x_vars,
    sapply(x_vars, function(v) class(df[[v]])[1]),
    sapply(x_vars, function(v) classify_typology(df[[v]], v)$typology),
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
  desc <- infer_description_fields(record_id, paper_title, geom_type, time_info$data_type, kg_rec = kg_rec)
  coord_display <- if (length(coord_vars)) fmt_bt(coord_vars) else sprintf("geometrie sf `%s` (%s)", geom_col, geom_type)
  kg_spatial_context <- kg_rec$spatial_characterization %||% ""
  kg_spatial_is_generic <- grepl("^Spatiality is indicated by DataCite/OpenAlex", kg_spatial_context)
  geographic_context <- if (nzchar(kg_spatial_context) && !kg_spatial_is_generic) {
    kg_spatial_context
  } else {
    sprintf("etendue sf: x [%s, %s], y [%s, %s]", md_escape(bbox["xmin"]), md_escape(bbox["xmax"]), md_escape(bbox["ymin"]), md_escape(bbox["ymax"]))
  }
  description_confidence <- if (!is.null(kg_rec$confidence) && nzchar(kg_rec$confidence)) kg_rec$confidence else if (!is.null(ov)) "medium" else "low"

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
  formula_candidate_formula <- if (!is.null(ov) && !is.null(ov$formula_candidate_formula)) ov$formula_candidate_formula else formula_used
  y_pub_display <- if (!is.null(ov) && !is.null(ov$y_term_pub)) ov$y_term_pub else if (formula_used != "pending" && length(y_vars)) y_vars[1] else "pending"
  x_pub_display <- if (!is.null(ov) && !is.null(ov$x_terms_pub)) paste(ov$x_terms_pub, collapse = ", ") else if (formula_used != "pending" && length(x_for_yaml)) paste(x_for_yaml, collapse = ", ") else "pending"
  x_used_display <- if (formula_used != "pending" && length(x_for_yaml)) paste(x_for_yaml, collapse = ", ") else "pending"
  y_used_display <- extract_formula_response(formula_used)
  modeling_source_ref <- if (!is.null(ov)) ov$source_ref else "data/raw/papers (loader-derived, no published equation located)"
  readiness <- PAPER_READINESS[[record_id]]
  if (is.null(readiness)) readiness <- default_readiness(record_id)
  fcb <- formula_candidates_block(
    formula_candidate_formula,
    y_pub_display,
    if (!is.null(ov) && !is.null(ov$x_terms_pub)) ov$x_terms_pub else x_for_yaml,
    is_published,
    modeling_source_ref,
    ml_formula = if (!is.null(ov)) ov$ml_formula else NULL,
    ml_response = if (!is.null(ov)) ov$ml_response else NULL,
    ml_predictors = if (!is.null(ov)) ov$ml_predictors else NULL,
    ml_source_ref = if (!is.null(ov)) ov$ml_source_ref else NULL,
    ml_status = if (!is.null(ov) && !is.null(ov$ml_status)) ov$ml_status else "confirmed",
    ml_source_type = if (!is.null(ov) && !is.null(ov$ml_source_type)) ov$ml_source_type else "scientific_publication",
    ml_estimator_context = if (!is.null(ov) && !is.null(ov$ml_estimator_context)) ov$ml_estimator_context else c("random_forest", "xgboost", "gamboost", "spboost"),
    is_binary_task = grepl("classification|binary_panel|presence_absence", readiness$benchmark_task %||% "", ignore.case = TRUE)
  )

  modeling_existing <- if (is_published) "true" else "false"
  modeling_source_type <- if (is_published) "scientific_publication_or_package_documentation" else if (formula_used != "pending") "generated_system_formula" else "none_found"
  modeling_evidence_block <- paste(
    "```yaml", "modeling_evidence:",
    sprintf("  existing_model_found: %s", modeling_existing),
    sprintf('  equation_text: "%s"', gsub('"', "'", formula_pub)),
    sprintf("  equation_family: %s", if (is_published && !is.null(ov$equation_family)) ov$equation_family else if (is_published) "paper_empirical_or_dataset_specific" else "generated_system_candidate"),
    sprintf("  model_family: %s", if (is_published && !is.null(ov$model_family)) ov$model_family else if (is_published) "spatial_or_paper_specific_regression" else "unknown"),
    sprintf("  source_type: %s", modeling_source_type),
    sprintf('  source_ref: "%s"', gsub('"', "'", modeling_source_ref)),
    sprintf("  confidence: %s", if (is_published) "medium" else "low"),
    "```",
    sep = "\n"
  )

  variables_status <- if (length(y_vars) && length(x_vars)) "OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes)."
    else if (length(y_vars)) "WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle)."
    else "WARN - Y non identifiee automatiquement ; revue manuelle requise."
  regression_status <- if (is_published && formula_used != "pending") "resolu" else if (is_published) "resolu_publication_non_executable" else "pending"
  evidence_level <- if (is_published) "publication" else "n/a"
  estimation_method <- if (is_published && formula_used != "pending") "formule publication confirmee et utilisee" else if (is_published) "modele/formule publication confirme, non executable avec le .rds actuel" else "n/a"
  formula_status <- if (is_published && formula_used != "pending") "OK - formule publication renseignee et formula_used executable."
    else if (is_published) "OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis."
    else if (formula_used != "pending") "PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place)."
    else if (length(y_vars) && !length(x_vars)) "PENDING - reponse identifiee, mais aucune covariable X locale executable n est disponible."
    else "PENDING - aucune formule Y ~ X utilisable ; aucune reponse confirmee ou aucune covariable exploitable n est disponible."
  crs_status <- if (epsg != "unknown") sprintf("OK - CRS renseigne dans le Bloc 5 (%s).", epsg)
    else "WARN - CRS absent du sf source et non resolu automatiquement."
  geometry_status <- sprintf("OK - type geometrique controle (%s).", geom_type)
  reproducibility_status <- sprintf("OK - loader R enregistre et reexecutable (`%s` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.", record_id)

  header_block <- sprintf(
    "---\ntitle: paper_%s\ntype: dataset\ncreated: %s\nupdated: %s\nsources:\n  - data/final_datasets/sf/paper_%s.rds\n  - %s\ntags: %s\n---\n\nDataset spatial converti en sf a partir des donnees brutes du papier \"%s\" (DOI %s).",
    record_id, TODAY, TODAY, record_id, local_raw_dir, tags, paper_title, paper_doi
  )

  description_block <- sprintf(
    "## Description du jeu de donnees\n\n- Topic: %s\n- Observation unit: %s\n- Observed population: %s\n- Geographic context: %s\n- Temporal context: %s\n- Source description: %s\n- Description source: paper_dataset_uses.json + lecture directe du papier\n- Description confidence: %s\n- Paper DOI: %s\n- Dataset DOI: %s\n- Source URL: %s\n- Local raw dir: `data/raw/papers/%s/`\n- Local sf output: `data/final_datasets/sf/paper_%s.rds`",
    desc$topic, desc$observation_unit, desc$observed_population, geographic_context,
    if (time_info$T == 1) "none (cross-sectional)" else temporal_res,
    paper_title, description_confidence,
    paper_doi, dataset_doi, source_url, local_raw_dir, record_id
  )

  yx_rationale <- if (!is.null(ov) && !is.null(ov$yx_selection_note)) {
    ov$yx_selection_note
  } else {
    infer_yx_selection_rationale(
      record_id, paper_title, y_vars, x_vars, coord_vars, id_vars, readiness,
      selected_x = x_for_yaml,
      published_x = if (!is.null(ov) && !is.null(ov$x_terms_pub)) ov$x_terms_pub else character(0),
      coord_label = coord_display
    )
  }

  bloc1_block <- sprintf(
    "## Bloc 1 - Formule et variables\n\n### Variables (niveau systeme - inspection directe du sf)\n\n- Candidate Y variables: %s\n- Candidate Y typology: %s\n- Candidate X variables in local artifact: %s\n- Candidate X count in local artifact: %d\n- Candidate X typology: %s\n- Published X variables from paper: %s\n- Published X count: %d\n- Coordinates (x, y - excluded from X candidates): %s\n- Identifier columns (excluded from X candidates): %s\n- Variables inspected: yes (auto - generate_fiches_papers.R)\n- Presence of imputed X: unknown\n\n#### Detail Y\n\n| Variable | Classe R | Typologie Y | Plage | NA (%%) |\n|---|---|---|---|---|\n%s\n\n> Selection Y/X (paper-loader / curated evidence) : %s\n\n#### Detail X\n\n| Variable | Classe R | Role X | NA (%%) |\n|---|---|---|---|\n%s\n\n### Formule - niveau publication\n\n- formula_pub: %s\n- x_terms_pub: %s\n- y_term_pub: %s\n- Reference publication: %s\n\n### Statut regression canonique\n\n- Statut: %s\n- Niveau de preuve: %s\n- Methode d estimation: %s\n- Correspondance Python/R: aucune identifiee\n- Note: %s\n\n### Formule - niveau systeme\n\n- formula_used: %s\n- x_terms_used: %s\n- y_term_used: %s\n- Note: %s\n\n### Formules candidates\n\n%s",
    y_vars_str, y_typ_str, x_vars_str, length(x_vars), x_typ_str,
    x_pub_display, if (!is.null(ov) && !is.null(ov$x_terms_pub)) length(ov$x_terms_pub) else 0L,
    coord_display, fmt_bt(id_vars),
    y_rows, yx_rationale, x_rows,
    formula_pub,
    x_pub_display,
    y_pub_display,
    if (!is.null(ov)) ov$source_ref else kg_rec$source_ref %||% "pending",
    regression_status,
    evidence_level,
    estimation_method,
    if (is_published) formula_note else "n/a",
    formula_used,
    x_used_display,
    y_used_display,
    formula_note,
    fcb
  )

  bloc2_block <- sprintf(
    "## Bloc 2 - Identification et DOI\n\n- Dataset ID: `paper_%s`\n- Dataset name: %s\n- Source family: paper-derived\n- Source: papier scientifique (voir Paper DOI)\n- Paper title: %s\n- Paper DOI: %s\n- Dataset DOI: %s\n- Source URL: %s\n- Year: unknown",
    record_id, dataset_name, paper_title, paper_doi, dataset_doi, source_url
  )

  bloc3_block <- sprintf(
    "## Bloc 3 - Typologie des modeles\n\n- Modele niveau 1 (tache): %s\n- Modele niveau 2 (famille): pending\n- Modele niveau 3 (variante): pending\n\n%s",
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
    "## Bloc 4 - Typologie des donnees\n\n- Data type: %s\n- Structure: %s\n- N observations: %d\n- k variables: %d\n- T periods: %d\n- Variable temporelle: %s\n- N/T profile: %s",
    time_info$data_type, time_info$structure, N, k, time_info$T,
    md_escape(time_info$T_var), profil_nt(N, time_info$T)
  )

  bloc5_block <- sprintf(
    "## Bloc 5 - Resolution et etendue\n\n- Type de geometrie: %s\n- Spatial resolution: %s\n- Temporal resolution: %s\n- CRS EPSG: %s\n- CRS nom: %s\n- Spatial extent: x [%s, %s], y [%s, %s]\n- Time range: %s\n- CRS analyse recommande: %s",
    geom_type, spatial_res, temporal_res, epsg, crs_name,
    md_escape(bbox["xmin"]), md_escape(bbox["xmax"]), md_escape(bbox["ymin"]), md_escape(bbox["ymax"]),
    time_range_str,
    if (ca$label != "pending") sprintf("%s (%s) - %s", ca$epsg, ca$label, ca$note) else sprintf("pending - %s", ca$note)
  )

  bloc6_block <- sprintf(
    "## Bloc 6 - Reproductibilite\n\n- License present: unknown\n- License name: unknown\n- License URL: unknown\n- License open: unknown\n- Reproducibility status: %s\n- Code available: yes (loader `%s` dans `code/r_catalog/build_sf_datasets_papers.R`)\n- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)",
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

  estimator_eligibility <- estimator_eligibility_block(record_id, readiness, formula_used, x_for_yaml, is_published)

  content <- paste(header_block, "", description_block, "", bloc1_block, "", bloc2_block, "",
                    bloc3_block, "", benchmark_readiness_block, "", estimator_eligibility, "",
                    bloc4_block, "", bloc5_block, "", bloc6_block, "",
                    qc_block, "", related_block, "", sep = "\n")

  out_path <- file.path(OUT_DIR, paste0("paper_", record_id, ".md"))
  writeLines(content, out_path, useBytes = TRUE)
  n_ok <- n_ok + 1L
  cat(sprintf("OK  paper_%s.md  (N=%d, k=%d, Y=%s)\n", record_id, N, k,
              if (length(y_vars)) paste(y_vars, collapse = "+") else "?"))
}

cat(sprintf("\n=== BILAN === %d fiches generees / %d cible(s)\n", n_ok, length(records_to_generate)))
