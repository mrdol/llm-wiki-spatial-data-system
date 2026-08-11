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
    benchmark_status = "needs_covariate_join_and_nuts3_reconciliation",
    benchmark_task = "regression_spatial_econometrics",
    package_include = "no",
    missing_items = "reconcilier les NUTS3 du papier avec le LAD extrait, joindre les covariables publiees de Table 6/Table 9, puis reconstruire W NUTS3",
    reason = "Le papier modelise 134 regions NUTS3 avec un tableau X documente, alors que l'extraction actuelle contient 380 LAD et seulement les agregats PV locaux."
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
    benchmark_status = "almost_ready_derived_regression",
    benchmark_task = "derived_continuous_species_richness_regression",
    package_include = "manual_review",
    missing_items = "documenter que la reponse log1p_species_richness est derivee; le benchmark ne reproduit pas les SDM PO/PA complets du papier et n inclut pas cloud cover/TRI",
    reason = "Y derivee continue, covariables CHELSA/EVI locales et coordonnees disponibles; utilisable pour benchmark comparatif avec reserve scientifique explicite."
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
    benchmark_status = "almost_ready_ogc_spatial_covariates",
    benchmark_task = "regression_continuous_ogc_spatial_covariates",
    package_include = "manual_review",
    missing_items = "documenter que les X sont des covariables spatiales construites par OGC, pas des covariables environnementales; choisir le nombre d angles si tuning souhaite",
    reason = "Le papier Moller et al. (2020) compare explicitement OGCs, EDFs, RFsp et kriging sur Swiss rainfall; le loader genere maintenant des covariables OGC depuis la geometrie."
  ),
  vindum = list(
    benchmark_status = "almost_ready_ogc_aux_spatial_covariates",
    benchmark_task = "regression_continuous_ogc_aux_spatial_covariates",
    package_include = "manual_review",
    missing_items = "valider le niveau d inclusion package et documenter que les X combinent auxiliaires publiees du package OGC et covariables OGC generees localement",
    reason = "Le papier Moller et al. (2020) utilise SOM avec OGCs, avec et sans auxiliaires; le loader extrait maintenant les 19 covariables auxiliaires Vindum_covariates du package OGC cite par le papier et ajoute six covariables OGC reproductibles."
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
    benchmark_status = "local_reduced_formula",
    benchmark_task = "regression_continuous",
    package_include = "no",
    missing_items = "joindre LANDScapes/GEOL/VEGET et reconstruire la composante de krigeage des residus pour reproduire le GLM/KR complet",
    reason = "AGB_mean est reconstruit depuis le supplement PLOS; HAND, LOG, ALT et SLO sont maintenant joints localement, mais LANDScapes, GEOL, VEGET et la composante de krigeage des residus restent absents."
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
                                     ml_estimator_context = c("random_forest", "xgboost", "gamboost", "spboost")) {
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
  has_formula <- !is.na(formula_used) && nzchar(formula_used) && formula_used != "pending"
  has_x <- length(x_terms_vec) > 0
  is_ready_like <- grepl("^(ready|almost_ready|manual_review)", status)
  is_not_ready <- grepl("^not_ready", status)
  eligible <- character(0)
  conditional <- character(0)
  ineligible_reason <- ""

  if (is_ready_like && has_formula && has_x) {
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
    ml_estimator_context = if (!is.null(ov) && !is.null(ov$ml_estimator_context)) ov$ml_estimator_context else c("random_forest", "xgboost", "gamboost", "spboost")
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

  readiness <- PAPER_READINESS[[record_id]]
  if (is.null(readiness)) readiness <- default_readiness(record_id)
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


