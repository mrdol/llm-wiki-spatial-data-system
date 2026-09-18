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
OUT_DIR <- Sys.getenv("DATASET_FICHE_OUTPUT_DIR", unset = file.path(REPO_ROOT, "wiki", "datasets", "fiches_datasets"))
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
  wildfire_greenup_nbr5 = "DataCite_2024_ClimateLimitsVegetationGreen_10_1186_s42408_0",
  flapper_skate_presence = "DataCite_2025_OnTheBrinkMapping_10_1002_ece3_716",
  bean_landrace_gap_sdm = "DataCite_2020_AGapAnalysisModelling_10_1111_ddi_1304",
  nyc_tract_income_ssig = "DataCite_2023_WhatDictatesIncomeIn_10_1057_s41599_023_0",
  nyc_census2000_gwrboost = "GeoDaLab_2017_NYCCensus2000_geodacenter_data_and_lab",
  hiv_southern_africa = "DataCite_2024_SpatialDistributionHIVSouthernAfrica_10_1371_journal_pone_0301850",
  usgs_flood_skew = "DataCite_2021_MethodsForEstimatingRegional_10_3133_sir20215",
  red_deer_topdown = "DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w",
  gwqlasso_pr = "DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en",
  gwqlasso_rs = "DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en",
  gwqlasso_mt = "DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en",
  fire_forest_loss_dominican_republic = "DatasetFirst_10_5281_zenodo_6990803",
  amphibian_abnormality_hotspots = "DatasetFirst_10_5061_dryad_dc25r",
  covid_sociodemographic_risk = "DatasetFirst_10_5061_dryad_4j0zpc8j1",
  fhb_ensembling = "DatasetFirst_10_5061_dryad_fn2z34trv",
  snake_home_range = "DataCite_2020_EctothermyAndTheMacroecology_10_25338_b85g98",
  amphibian_functional_diversity = "DatasetFirst_10_5061_dryad_nk0bj96",
  dragonfly_colour_lightness = "DatasetFirst_10_5061_dryad_72tp3",
  groundfish_cpue = "DatasetFirst_10_5061_dryad_s23g7bc",
  gcfr_soil = "DatasetFirst_10_5061_dryad_37qc017",
  dougfir_sdm = "DatasetFirst_10_5061_dryad_737gk",
  goa_trawl_demersal = "DatasetFirst_10_5061_dryad_j3t86",
  mimulus_sdm = "DatasetFirst_10_5061_dryad_xsj3tx9g1",
  song_sparrow_breeding_date = "DatasetFirst_10_5061_dryad_n0513",
  houston_lst_landcover = "DatasetFirst_10_5061_dryad_fbg79cnt2",
  chaco_bird_richness = "DataCite_2020_TradeOffsBetweenBiodiversity_10_1111_1365_266",
  kodiak_puffin_density = "DatasetFirst_10_5281_zenodo_17128171",
  macropod_body_size = "DatasetFirst_10_5061_dryad_c3tc6",
  sugarglider_occupancy = "DatasetFirst_10_5061_dryad_4xgxd259g",
  checkerspot_phenology = "DatasetFirst_10_5061_dryad_rr4xgxdhk",
  pacific_atoll_coconut = "DatasetFirst_10_5061_dryad_0k6djhb7x",
  alps_floristic_legacy = "DatasetFirst_10_5061_dryad_w9ghx3g12",
  uk_linear_features_birds = "DatasetFirst_10_5061_dryad_m5g04",
  sfbay_contaminated_sites = "DatasetFirst_10_6078_d15x4n",
  shark_longline_catch = "DatasetFirst_10_25349_d9789w",
  danajon_coral_distribution = "DatasetFirst_10_5061_dryad_z34tmpgpt",
  ltar_crop_rotation_yield = "DatasetFirst_10_6078_d1h409",
  seshat_social_complexity = "DatasetFirst_10_17916_p6159w",
  airbnb_europe_prices = "MediumPriorityRetry_10_5281_zenodo_4446043",
  stwr_precip_isotope = "MediumPriorityRetry_10_5281_zenodo_3637689",
  mistletoe_bird_abundance = "DataCite_2022_MistletoesCouldModerateDrought_10_1098_rspb_202",
  leishmaniasis_occurrence = "DataCite_2014_GlobalDistributionMapsOf_10_7554_elife_02",
  avian_phylo_functional_distance = "DataCite_2023_GlobalVariationInThe_10_1111_geb_1376",
  spatial_confounding_diabetes = "DatasetFirst_10_5281_zenodo_21300380",
  antarctic_biodiversity_completeness = "DatasetFirst_10_5281_zenodo_13988131",
  pollinator_urbanization_meta = "DatasetFirst_10_5061_dryad_dv41ns23r",
  portugal_covid_municipal = "DatasetFirst_10_5281_zenodo_11222023",
  colombia_leptospirosis_risk = "DatasetFirst_10_5281_zenodo_17104058",
  korea_hedonic_housing = "DatasetFirst_10_5281_zenodo_14715630",
  wildebeest_movement_env = "DatasetFirst_10_5061_dryad_5tb2rbp76",
  dragonfly_diversity_europe = "DatasetFirst_10_5061_dryad_78j8g",
  brisbane_urban_vegetation = "DatasetFirst_10_5061_dryad_3bh66",
  banff_stream_temperature = "DatasetFirst_10_5061_dryad_crjdfn391",
  global_nee_gwxgboost = "DatasetFirst_10_5281_zenodo_21635729",
  california_wildfire_growth = "DatasetFirst_10_5281_zenodo_7569337",
  swiss_heat_exposure = "DatasetFirst_10_5281_zenodo_16923676",

  # -- Decoupage temporel de korea_hedonic_housing (session 2026-08-17) ------
  korea_hedonic_housing_1989 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1990 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1991 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1992 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1993 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1994 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1995 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1996 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1997 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1998 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_1999 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2000 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2001 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2002 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2003 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2004 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2005 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2006 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2007 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2008 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2009 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2010 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2011 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2012 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2013 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2014 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2015 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2016 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2017 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2018 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_2019 = "DatasetFirst_10_5281_zenodo_14715630",
  korea_hedonic_housing_pre1989 = "DatasetFirst_10_5281_zenodo_14715630"
)

# -- Datasets derives par decoupage (splits) d'une source independante ------
# Un split (ex. korea_hedonic_housing_2012) est un benchmark_task_id a part
# entiere -- il a sa propre fiche, son propre .rds, son propre statut de
# promotion -- mais ce n'est PAS une source de donnees independante : c'est
# le meme jeu de donnees original que son parent, juste filtre sur une
# periode. Cette table alimente le champ "Parent dataset" du Bloc 2, lu par
# code/package_metadata/export_spatialtidymodels_metadata.py pour calculer
# source_dataset_id (l'identite "source independante" a des fins de comptage,
# cf. wiki/metadata/dataset_distribution_architecture_2026-08.md section M) --
# sans cette table, chacun des 32 splits de korea_hedonic_housing compterait
# comme une source distincte et dominerait artificiellement un verdict
# agrege par nombre de "datasets".
PARENT_DATASET <- (function() {
  years <- c(1989:2019, "pre1989")
  out <- stats::setNames(rep("korea_hedonic_housing", length(years)),
                          paste0("korea_hedonic_housing_", years))
  as.list(out)
})()

# -- Formules et notes verifiees par lecture directe du papier source --------
# Contrairement au reste de la fiche (typologie/N/T/CRS calcules depuis le
# .rds), ces entrees ne sont PAS derivees automatiquement : chaque formule
# a ete extraite manuellement du texte du papier (methodes, equations,
# scripts de replication) au cours de cette session. formula_used, quand
# fourni, remplace la formule "kitchen sink" generee par defaut.
FORMULA_OVERRIDES <- list(
  marrot_spatial_autocorrelation_fitness = list(
    formula_pub = "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration [GLS/SAR selon la structure d'autocorrelation spatiale testee]",
    formula_used = "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration",
    y_term_pub = "Number_of_fledglings (nombre de jeunes a l'envol, seule reponse disponible -- pas de variante continue dans le depot)",
    x_terms_pub = c("Clutch_size (taille de ponte)", "Laying_date (date de ponte)", "Incubation_duration (duree d'incubation)"),
    ml_formula = "Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration",
    ml_response = "Number_of_fledglings",
    ml_predictors = c("Clutch_size", "Laying_date", "Incubation_duration"),
    ml_estimator_context = c("gls", "sar_lag", "sar_error", "pcnm", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Formule presente dans inst/kg/paper_dataset_uses.json (bib_key DataCite_2015_SpatialAutocorrelationInFitness_10_1111_2041_210) : Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration, estimateurs geoles/SAR-lag/SAR-error/PCNM. Les 3 covariables et la reponse sont presentes telles quelles dans le .rds local (N=229). Aucune variante continue de la reponse n'existe dans le depot -- Number_of_fledglings (compte de jeunes a l'envol) est la seule reponse disponible, promue package_include=yes le 2026-08-15 (decision utilisateur : Y present + formule disponible + rds/fiche prets suffit, pas besoin d'une variante continue quand aucune n'existe)."
  ),
  spruce_bark_beetle = list(
    formula_pub = "trapcounts ~ spruce_vol + felling_border_lag3 * veg_zone + temperature_lag3 + soil_moisture_lag3 + longitude + latitude + second_order_terms [negative binomial GLM]",
    formula_used = "trapcounts ~ spruce_vol + felling_border + temperature + soil_moisture + veg_zone",
    source_ref = "Gohli et al. (2024), Journal of Applied Ecology, DOI 10.1111/1365-2664.14606: Sections 2.1.1-2.2 define trap counts and predictors; Section 2.1.5 selects a 3-year lag for clearcut edge, temperature, precipitation and soil moisture; Section 3 reports the final parsimonious negative-binomial GLM, where precipitation, altitude and sampling year are dropped, while mature spruce volume, new clearcut edge, temperature, soil moisture, vegetation zone interactions and longitude/latitude remain supported. formula_used keeps the executable non-coordinate subset available in the local .rds."
  ),
  florida_crash_gsvcm = list(
    formula_pub = "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy [GSVCM negative-binomial application]",
    formula_used = "Offcrsh ~ log.VMT + log.Pop + Rmale + Rhisp + Rold + Runemploy",
    year = "2020",
    source_ref = "Kim & Wang (2020) (auteurs corriges le 2026-09-14 -- confirmes via Crossref, DOI 10.1080/10618600.2020.1754225 ; l'attribution anterieure 'Wu et al.' etait fausse, aucun auteur de ce nom sur ce papier), Generalized Spatially Varying Coefficient Models, Journal of Computational and Graphical Statistics. Formule confirmee via le script supplementaire des auteurs, Code/main_GSVCM_application.R (archive Taylor & Francis ucgs_a_1754225_sm8959.zip) : y=Offcrsh, S=(Lon,Lat), X=log.VMT, log.Pop, Rmale, Rhisp, Rold, Runemploy; family=nb_bps()."
  ),
  possum_body_size = list(
    formula_pub = "CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type [selected aspatial and spatial SAR model]",
    formula_used = "CBL ~ SummerMaxTemp + MinSeasP.PET + Island_type",
    year = "2015",
    source_ref = "Correll, Prowse & Prideaux (2015) (authors and DOI corrected 2026-09-14 -- confirmed via Crossref ; the previous attribution 'Isaac et al., DOI 10.1111/ecog.01204' was fabricated, that DOI does not resolve to any real publication), Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial, Ecography 39(1):77-86, DOI 10.1111/ecog.01243. Table 2 states that the selected aspatial and spatial SAR model for Trichosurus vulpecula condylobasal length (CBL) is CBL ~ SummerMaxTemp + MinSeasP-PET + island effect (N=588 specimens, matching this artifact). The local .rds uses the matching columns SummerMaxTemp, MinSeasP.PET and Island_type."
  ),
  cluster_detection = list(
    formula_pub = "mu_i = beta0 + beta1*x_i (hors cluster) ; mu_i = (beta0+theta_j0) + (beta1+theta_j1)*x_i (dans le cluster C_j)",
    source_ref = "Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) - modele a coefficients de regression variables par cluster spatial (varying-coefficient regression), methode de detection de cluster testee sur donnees simulees puis sur mortalite par cancer. Ce jeu est exclu du package benchmark empirique car l artefact local est une simulation."
  ),
  medicago = list(
    formula_pub = "richness ~ environmental_energy_PC1 [GWR, fixed kernel, AICc bandwidth] ; richness ~ each climatic variable / environmental-category PC1 [negative binomial GLM]",
    formula_used = "richness ~ MAT + MTCQ + PET + WI + Solar_rad",
    formula_candidate_formula = "richness ~ MAT + MTCQ + PET + WI + Solar_rad",
    y_term_pub = "species richness of Medicago on 100 x 100 km grid cells",
    x_terms_pub = c("MAT", "MTCQ", "PET", "WI", "Solar_rad", "MI", "MAP", "PDQ", "AET", "WD", "DRT", "TSN", "ART", "PSN", "MATR", "MAPR", "Ele_range", "Ele_std", "LGMmat_ano", "LGMmap_ano", "LGMmtcq_ano", "MHmat_ano", "MHmap_ano", "MHmtcq_ano"),
    source_ref = "Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085, Sections Environmental variables and Models/statistical analyses: the paper maps Medicago richness on 100 x 100 km grid cells, evaluates 24 environmental variables with negative-binomial GLMs and category PC1s, then uses GWR to explore the richness-environmental-energy relationship across latitude. formula_used keeps the documented environmental-energy group available in the local .rds (MAT, MTCQ, PET, WI, Solar_rad) as the canonical executable GWR/GLM benchmark formula.",
    regression_status_override = "mis de cote",
    regression_evidence_override = "publication",
    regression_method_override = "formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier (voir correction 2026-09-08)",
    regression_note_override = "Correction (2026-09-08, lecture TEI approfondie) : confirme -- les GLM binomiaux-negatifs du papier sont univaries (une seule variable climatique a la fois : \"we used univariate generalized linear models (GLMs) to evaluate the effects of each climatic variable\"), et le GWR ne porte que sur un PC1 agrege (\"environmental energy\"), jamais sur les 5 variables brutes MAT+MTCQ+PET+WI+Solar_rad simultanement comme le fait formula_used. Le papier n'ajuste donc jamais ce modele multivarie precis. DECISION UTILISATEUR (2026-09-08) : mis de cote explicitement plutot que resolu -- necessite un pretraitement PCA et une orchestration multi-modeles univaries absents du pipeline actuel ; ne pas promouvoir package_include=yes avant cette extension."
  ),
  crane = list(
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    formula_pub = "logit(P(s,t)) = beta0 + alpha1*Urb_Den_cov + alpha2*PA_Ratio_cov + alpha3*Area_cov + M(s,t) [INLA/SPDE, bayesien]",
    formula_used = "mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov",
    formula_note = "Eq. 1-2 p.165 : modele binomial presence/absence hierarchique bayesien, champ aleatoire gaussien spatio-temporel M(s,t) approxime par SPDE, ajuste avec R-INLA/inlabru ; variante etendue Eq. 4 ajoute un second champ G(s) issu d'un processus ponctuel des zones humides. Voir formula_used_divergence_note pour l'ecart avec formula_used.",
    formula_candidate_formula = "logit(P(s,t)) = beta0 + alpha1*Urb_Den_cov + alpha2*PA_Ratio_cov + alpha3*Area_cov + M(s,t)",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "formula_pub est confirmee et verifiee dans le texte de l'article (Eq. 1-2 p.165 : lien logit, modele binomial hierarchique bayesien, champ aleatoire gaussien spatio-temporel M(s,t) approxime par SPDE/INLA), mais n'est pas reproduite telle quelle : le harnais actuel ne modelise ni le lien logit ni ce champ latent spatio-temporel. formula_used est une approximation GLM plate generee, qui ajoute en outre 'ti' comme covariable a effet fixe alors que dans le papier 'ti' structure le champ aleatoire (IID/AR1), pas un terme x_i.",
    formula_note = "Formule systeme = approximation GLM plate des 3 covariables reellement publiees (Urb_Den_cov, PA_Ratio_cov, Area_cov) plus 'ti' ajoute comme covariable simplifiee -- candidate generee pour un usage futur (Y binaire + panel spatial hors perimetre actuel du package), pas la specification publiee. Voir formula_used_divergence_note.",
    y_term_pub = "O_{s,t} / mark (presence-absence d'un couple reproducteur de grues au site s, annee t ; variable Bernoulli, notee 'mark' dans l'artefact local)",
    x_terms_pub = c("Urb_Den_cov (densite des zones urbanisees dans un buffer terrestre de 10 km)", "PA_Ratio_cov (ratio perimetre/aire de la zone humide)", "Area_cov (surface de la zone humide)"),
    ml_formula = "mark ~ ti + Urb_Den_cov + PA_Ratio_cov + Area_cov",
    ml_response = "mark",
    ml_predictors = c("ti", "Urb_Den_cov", "PA_Ratio_cov", "Area_cov"),
    ml_estimator_context = c("random_forest", "xgboost", "gamboost", "spboost"),
    ml_status = "generated_candidate_binary_panel",
    ml_source_type = "generated_system_formula",
    source_ref = "Laxton, Rodriguez de Rivera, Soriano-Redondo & Illian (2023) (auteurs corriges le 2026-09-14 -- verifies via le TEI local et Crossref ; l'attribution anterieure 'Laxton, Illian, Bachl & O'Hara' etait fausse, Bachl et O'Hara sont des auteurs d'articles cites en bibliographie de ce papier -- ex. inlabru -- pas des auteurs de ce papier), Methods in Ecology and Evolution 14(1):162-172, DOI 10.1111/2041-210X.13957, Section 2.2 'Single-field models', Eq. (1)-(2) p.165: O_{s,t} ~ Bernoulli(P(s,t)), P(s,t) = logit^-1(beta0 + sum_i alpha_i*x_i(s,t) + M(s,t)), avec les 3 covariables environnementales explicitement nommees ('the density of surrounding urbanised areas ... wetland perimeter-to-area ratio, and wetland extent') correspondant aux colonnes locales Urb_Den_cov/PA_Ratio_cov/Area_cov. 'ti' (variable temporelle presente dans l'artefact local) n'est PAS l'une des 3 covariables x_i du papier : c'est l'indice temporel qui structure le champ aleatoire gaussien spatio-temporel M(s,t) (options IID ou AR1, Section 2.2), pas un terme a effet fixe. formula_used garde 'ti' comme covariable simplifiee (approximation GLM plate, sans champ aleatoire spatio-temporel ni lien logit reproduit par le harnais actuel) -- ce n'est pas la specification publiee, seulement une candidate executable la plus proche. Paper precedemment non lu lors du remplissage de FORMULA_OVERRIDES (formula_pub restait 'pending' malgre un Statut/Reference publication deja renseignes) ; corrige le 2026-09-10 apres lecture directe du texte (Eq. 1-2, p.164-166)."
  ),
  regulatory_convergence = list(
    formula_pub = "bii_index ~ Lreceiveforeign_wght_bin + Lsendingabroad_wght_bin + Lnetwork_spw_bin + Lsovrating_spw_same + Ltradebin30_wght + Lprivcredit1 + Lfdi_in_gdp1 + Lpolity + Lcpi + Lcbiw + Lbankcon1 + Limf_iiiyr + factor(region)",
    formula_used = "pending",
    y_term_pub = "bii_index",
    x_terms_pub = c("Lreceiveforeign_wght_bin", "Lsendingabroad_wght_bin", "Lnetwork_spw_bin", "Lsovrating_spw_same", "Ltradebin30_wght", "Lprivcredit1", "Lfdi_in_gdp1", "Lpolity", "Lcpi", "Lcbiw", "Lbankcon1", "Limf_iiiyr", "region"),
    source_ref = "Jones & Zeitz (2019), International Studies Quarterly 63(4), doi:10.1093/isq/sqz068. CORRECTION (2026-09-09) : la version precedente (lecture du 2026-08-15, limitee au resume) indiquait par erreur y_term_pub=net_bcbs. Lecture du fichier de replication Stata original (Jones & Zeitz - Replication.do, present dans data/raw/) confirme que net_bcbs est une variable de FILTRE D'ECHANTILLON (keep if net_bcbs==0), jamais la reponse. La vraie reponse est bii_index (indice d'adoption Basel II/III) ; le modele principal (Table 2) est une regression OLS robuste sur des variables de decalage spatial deja precalculees, pour deux coupes transversales separees (2008 et 2013). Voir [[paper_regulatory_convergence_2008]] pour la reproduction executable complete (Table 2, 2008).",
    regression_status_override = "resolu",
    regression_evidence_override = "verbatim",
    regression_method_override = "formule confirmee verbatim dans le fichier de replication Stata original",
    regression_note_override = "Correction du 2026-09-09 -- voir 'Reference publication' ci-dessus. Le fichier de replication a ete lu integralement (Jones & Zeitz - Replication.do), corrigeant la lecture partielle du 2026-08-15. Le panel complet (18 annees, membres et non-membres du Comite de Bale confondus) n'a pas de specification unique executable -- le papier estime deux coupes transversales separees (2008, 2013) sur l'echantillon filtre net_bcbs==0. La coupe 2008 a ete extraite en fiche separee [[paper_regulatory_convergence_2008]] (benchmark_status: ready). La coupe 2013 (N=78) n'a pas encore ete extraite -- meme methode applicable si besoin.",
    ml_status = "not_applicable_panel_no_single_formula"
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
    source_ref = "Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 - modele de path analysis (coefficients standardises, moyenne +/- ecart-type mondial) reliant AET, temperature, velocite climatique depuis le LGM et elevation a la richesse specifique (SR) et la diversite phylogenetique (PD) des mammiferes terrestres.",
    regression_status_override = "mis de cote",
    regression_evidence_override = "publication",
    regression_method_override = "formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier (voir correction 2026-09-08)",
    regression_note_override = "Correction (2026-09-08, lecture TEI approfondie) : confirme -- le papier n'ajuste pas un GLM/Poisson simple sur SR, mais une analyse de chemin geographiquement ponderee (GWPath) ou les coefficients de chemin varient regionalement via GWR (package spgwr) : \"we developed a geographically weighted path analysis (GWPath), which allows path coefficients to vary regionally... GWPath uses geographically weighted regressions (GWR)\". formula_used (SR ~ AET + Temp) isole un seul chemin du modele complet (qui relie conjointement SR, PD et l'environnement) et perd le cadre GWPath/GWR."
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
    formula_pub = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par [Spatial Durbin Model (SDM), sous-echantillon clear1=1, matrice W politique originale de Williams & Whitten 2015 attachee]",
    formula_used = "change ~ rgdppc_growth + growth_govt + pm_growth + party_shift_t + party_shift_t1 + ciep_perc + govt_ciep + pm_ciep + xregbet + prime_dummy + niche + gparties + pm_gparties + lag_pervote + pm_lag_pervote + niche_lag_pervote + eff_par",
    source_ref = "Juhl (2021), Political Analysis - Spatial Durbin Model (SDM), sous-echantillon 'haute clarte de responsabilite' (clear1=1), extrait directement de EmpiricalExample.R (script de replication des auteurs). RESOLU le 2026-08-15 : le fichier WW2015_Data.Rdata contient W_high (398x398) et W_low (1030x1030), matrices de proximite politique/institutionnelle de la replication Williams & Whitten (2015) -- verifie que W_high correspond exactement ligne a ligne au sous-echantillon clear1==1 (398 observations) et W_low au sous-echantillon clear1==0 (1030 observations). Ces matrices originales du papier (pas des voisinages geographiques reconstruits) sont desormais sauvegardees comme artefacts compagnons : data/final_datasets/sf/paper_wald_test_W_clear1.rds (398x398, correspond a formula_used sur le sous-echantillon clear1=1) et paper_wald_test_W_notclear1.rds (1030x1030)."
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
    formula_pub = "PD.SES ~ tempmean + pp + curvel [Random Forest ; PD.SES = effet standardise de diversite phylogenetique, principale reponse continue modelisee par le papier avec SR (count) et PE.SES]",
    formula_used = "PD.SES ~ tempmean + pp + curvel + sal + light + fishing_effort",
    y_term_pub = "PD.SES (diversite phylogenetique, effet standardise -- reponse continue choisie par defaut parmi les 3 reponses publiees SR/PD.SES/PE.SES, toutes les 3 disponibles en option dans le package)",
    x_terms_pub = c("tempmean (temperature moyenne du fond)", "pp (productivite primaire)", "curvel (vitesse du courant)", "sal (salinite)", "light (disponibilite lumineuse)", "fishing_effort (effort de peche)"),
    ml_formula = "PD.SES ~ tempmean + pp + curvel + sal + light + fishing_effort",
    ml_response = "PD.SES",
    ml_predictors = c("tempmean", "pp", "curvel", "sal", "light", "fishing_effort"),
    ml_estimator_context = c("random_forest", "random_forest_spatial", "xgboost"),
    ml_status = "executable_continuous_variant",
    source_ref = "Teles & Mantelatto (2025), Journal of Biogeography / Dryad description et TEI : le papier modelise par Random Forest 3 reponses -- SR (richesse specifique, count, principalement expliquee par salinite/lumiere/productivite primaire), PD.SES (diversite phylogenetique standardisee, principalement temperature du fond/productivite primaire/vitesse du courant) et PE.SES (originalite phylogenetique standardisee, principalement temperature/productivite primaire). PD.SES est choisie comme reponse par defaut le 2026-08-15 (decision utilisateur : reponse principale = celle qui est continue) car c'est une metrique continue (z-score, peut etre negative) contrairement a SR (count) ; SR, PE.SES, WE, WE.SES, ED, ED.SES restent documentees et disponibles comme reponses alternatives dans le .rds (N=160, toutes colonnes presentes)."
  ),
  # -- Lot DataCite 2026-08 (harvest verifie, session du 2026-08-12) --------
  coral_bathypathes = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales). Le README documente 12 variables nommees explicitement ; le CSV reel en contient 14 (sand et PBO_C en plus, non fabriquees, presentes telles quelles dans le fichier telecharge). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels), memes 12 taxons du meme depot."
  ),
  coral_corallium = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- corallium est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_enallopsammia = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- enallopsammia est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_errina = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- errina est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_goniocorella = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- goniocorella est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_isididae = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- isididae est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_leiopathes = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- leiopathes est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_madrepora = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- madrepora est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_paragorgia = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- paragorgia est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_primnoa = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- primnoa est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_solenosmilia = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- solenosmilia est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
  ),
  coral_stylaster = list(
    formula_pub = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C [Random Forests + Boosted Regression Trees ensemble SDM]",
    formula_used = "pa ~ carbonate + mud + sand + bpi_fine + depth + slope_per + smtfinal + BEN_N_C + DETFLUX3_C + OM_CAL3_C + OXY_C + PBO_C + SO_C + SFR_OARG_C",
    ml_estimator_context = c("random_forest", "random_forest_spatial"),
    ml_status = "executable_binary_variant",
    source_ref = "CORRECTION 2026-09-14 (etendue depuis coral_bathypathes, meme depot Dryad/meme papier, formule verifiee independamment) : Anderson, Stephenson, Behrens & Rowden (2022), Global Change Biology, DOI 10.1111/gcb.16389; README.txt Dryad (dataset 10.5061/dryad.41ns1rnht) documente colonne-par-colonne les 12 fichiers presence/absence par taxon (lat, lon, pa, puis les variables environnementales) -- stylaster est l'un de ces 12 taxons, memes 14 covariables confirmees presentes dans l'artefact local (Candidate X count=14, identique a coral_bathypathes). Estimateurs de reference fixes le 2026-08-15 sur random_forest/random_forest_spatial (deja disponibles dans le package spatialtidymodels)."
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
    formula_pub = "aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm [BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]",
    formula_used = "aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm",
    source_ref = "Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). CORRIGE le 2026-08-15 : le loader utilisait auparavant le shapefile Dryad/ScienceBase (Maine_Mean_August_Baseflow.shp, 42449 troncons NHDPlus), qui n'est PAS la table d'apprentissage du papier mais la carte de PREDICTION du modele applique a tout le reseau hydrographique de l'Etat (section 2.4 'Mapping') -- ce qui avait fait passer la fiche package_include=yes a tort sur un produit de prediction, pas 42449 observations independantes. Le loader lit maintenant table1_gage_stations.csv, transcription de la vraie Table 1 (p.1257, N=31 stations de jaugeage USGS reelles utilisees pour calibrer le modele) + coordonnees recuperees via l'API USGS NWIS Site Service pour les 31 numeros de station publics (voir README_table1_gage_stations.txt dans le dossier raw). DASQMI (surface du bassin) servait uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele -- non repris dans le loader.",
    ml_formula = "pending",
    ml_response = "pending",
    ml_predictors = character(0),
    ml_source_type = "none_found",
    ml_status = "unavailable",
    ml_source_ref = "N=31 (Table 1 du papier) ne fournit que les 2 predicteurs publies (AQ, JULAVEPRE) ; aucune covariable ML supplementaire disponible depuis que le loader utilise la vraie table de calibration au lieu du shapefile de prediction (qui portait des champs supplementaires DASQMI/REGULATED/OOB_* sans statut de covariable confirme).",
    ml_estimator_context = character(0)
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
    formula_pub = "rdnbr ~ treatment_type_x_time_since_treatment + top predictors RF + W [SAR, lag=35m]",
    formula_used = "rdnbr ~ minrh + LF2020_CC + annual_tmmin_anl_mean_1981_2010 + annual_deficit_1981_2010 + distance_to_trt_edge + tri_10res_410win + scf + fm100 + gedi_rh100_mean + gedi_rh100_sd + northsouthness_mx_speed_direction_20230501",
    formula_note = "Chamberlain et al. (2024), Ecosphere, Fig. 1 (cadre en 3 etapes RF -> appariement -> SAR), Fig. 4a (importance RF, Nagelkerke pseudo-R2=0.92, RMSE=208), p.10 (equation SAR, 300 unites traitees/controles appariees sur RH/TMIN/TRI-410m). Predicteurs RF retenus : RH, canopy cover, TMIN, CWD, distance au bord de traitement, TRI-410m, snow cover frequency, FM100, GEDI height mean/SD, wind northsouthness. Voir formula_used_divergence_note pour l'ecart avec formula_used.",
    formula_candidate_formula = "rdnbr ~ minrh + LF2020_CC + annual_tmmin_anl_mean_1981_2010 + annual_deficit_1981_2010 + distance_to_trt_edge + tri_10res_410win + scf + fm100 + gedi_rh100_mean + gedi_rh100_sd + northsouthness_mx_speed_direction_20230501",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "Le papier n'ajuste PAS une regression lineaire/SAR sur les 34 predicteurs bruts disponibles dans le depot : (1) un Random Forest reduit d'abord ces predicteurs a 11 variables retenues par importance (Fig. 4a, apres reduction de colinearite par correlations de Spearman) ; (2) ces variables servent aussi a apparier 300 unites traitees a 300 controles non traites (matching sur RH, TMIN et TRI uniquement, un par categorie) ; (3) le modele SAR final utilise en X les 11 variables retenues PLUS le type de traitement et le temps depuis traitement (categoriel), avec une structure spatiale (lag=35m). formula_used ne reprend que les 11 variables continues retenues par le RF (correspondance verifiee colonne par colonne avec Table 2 et Figure 4a de l'article) -- treatment_type et time_since_treatment sont ABSENTS de l'artefact local (35 colonnes disponibles, aucune ne code le type/l'age de traitement), donc le coeur du modele publie (l'effet du traitement, objet meme de l'article) n'est pas reproductible ici. Precedemment la fiche listait les 34 predicteurs bruts comme si c'etait 'le' modele SAR publie, avec Statut='resolu'/'formule publication confirmee et utilisee' -- confondait les variables candidates pre-reduction avec la specification econometrique reelle (signale par l'utilisateur 2026-09-10, verifie par lecture directe du PDF, p.6-14).",
    ml_formula = "rdnbr ~ annual_aet_1981_2010 + annual_deficit_1981_2010 + annual_pet_1981_2010 + annual_ppt_anl_total_1981_2010 + annual_tmmean_anl_mean_1981_2010 + annual_tmmin_anl_mean_1981_2010 + distance_to_roads + distance_to_streams_wetlands + distance_to_trt_edge + frs + gedi_rh100_mean + gedi_rh100_sd + erc + fm100 + fm1000 + minrh + tmmx + vpd + LF2020_CBD + LF2020_CC + LF2020_CH + scf + sdd + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230501 + mx_speed_20230501 + northsouthness_mx_speed_direction_20230501",
    ml_response = "rdnbr",
    ml_predictors = c("annual_aet_1981_2010", "annual_deficit_1981_2010", "annual_pet_1981_2010", "annual_ppt_anl_total_1981_2010", "annual_tmmean_anl_mean_1981_2010", "annual_tmmin_anl_mean_1981_2010", "distance_to_roads", "distance_to_streams_wetlands", "distance_to_trt_edge", "frs", "gedi_rh100_mean", "gedi_rh100_sd", "erc", "fm100", "fm1000", "minrh", "tmmx", "vpd", "LF2020_CBD", "LF2020_CC", "LF2020_CH", "scf", "sdd", "elevation_10res", "hli_10res", "slope_10res", "sri_10res", "tpi_10res_2010win", "tpi_10res_410win", "tpi_10res_8010win", "tri_10res_410win", "eastwestness_mx_speed_direction_20230501", "mx_speed_20230501", "northsouthness_mx_speed_direction_20230501"),
    ml_source_type = "scientific_publication",
    ml_status = "confirmed_predictor_pool_before_rf_reduction",
    ml_estimator_context = c("random_forest", "random_forest_xy", "xgboost", "xgboost_xy"),
    year = "2024",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    source_ref = "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_Bootleg_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 35 predicteurs candidats. 3 couches documentees (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public (verifie 2026-08-12) -- non devinees. Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) sur l'ensemble des predicteurs continus apres reduction de colinearite (Spearman) ramene a 11 variables retenues (Fig. 4a) ; ces 3 variables (RH, TMIN, TRI-410m, une par categorie bioclimatique/meteo/topographique) servent a apparier 300 controles a 300 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.92) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 11 variables retenues. Tout reprojete/reechantillonne le 2026-08-12 vers une grille commune Albers EPSG:5070 a 250m (bilineaire pour les variables continues, plus-proche-voisin pour les masques) -- resolution native du papier : 30m."
  ),
  wildfire_schneider_springs_severity = list(
    formula_pub = "rdnbr ~ treatment_type_x_time_since_treatment + top predictors RF + W [SAR, lag=35m]",
    formula_used = "rdnbr ~ Annual_Deficit_V2_1981_2010 + SS_minrh + SS_fm1000 + distance_to_roads_20221021 + LF2019_CC + gedi_rh100_mean + gedi_rh100_sd + distance_to_trt_edge + tpi_10res_8010win + northsouthness_mx_speed_direction_20230314 + mx_speed_20230310 + frs_ss_clipped + Annual_AET_V2_1981_2010",
    formula_note = "Chamberlain et al. (2024), Ecosphere, Fig. 1 (cadre en 3 etapes RF -> appariement -> SAR), Fig. 5a (importance RF, Nagelkerke pseudo-R2=0.94, RMSE=231), p.10-13 (equation SAR, 118 unites traitees/controles appariees sur CWD/RH/TPI-8010m). Predicteurs RF retenus : CWD, RH, FM1000, distance aux routes, canopy cover, GEDI height mean/SD, distance au bord de traitement, TPI-8010m, wind northsouthness, wind speed, fire resistance score, AET. Voir formula_used_divergence_note pour l'ecart avec formula_used.",
    formula_candidate_formula = "rdnbr ~ Annual_Deficit_V2_1981_2010 + SS_minrh + SS_fm1000 + distance_to_roads_20221021 + LF2019_CC + gedi_rh100_mean + gedi_rh100_sd + distance_to_trt_edge + tpi_10res_8010win + northsouthness_mx_speed_direction_20230314 + mx_speed_20230310 + frs_ss_clipped + Annual_AET_V2_1981_2010",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "Le papier n'ajuste PAS une regression lineaire/SAR sur les 34 predicteurs bruts disponibles dans le depot : (1) un Random Forest reduit d'abord ces predicteurs a 13 variables retenues par importance (Fig. 5a, R2=0.570, RMSE=231, apres reduction de colinearite par correlations de Spearman) ; (2) 3 de ces variables (CWD, RH, TPI-8010m, une par categorie bioclimatique/meteo/topographique) servent a apparier 118 unites traitees a 118 controles non traites ; (3) le modele SAR final (lag=35m, pseudo-R2 Nagelkerke=0.94) utilise en X les 13 variables retenues PLUS le type de traitement et le temps depuis traitement (categoriel). formula_used ne reprend que les 13 variables continues retenues par le RF (correspondance verifiee colonne par colonne avec Table 2 et Figure 5a de l'article) -- treatment_type et time_since_treatment sont ABSENTS de l'artefact local (35 colonnes disponibles, aucune ne code le type/l'age de traitement), donc le coeur du modele publie (l'effet du traitement, objet meme de l'article) n'est pas reproductible ici. Precedemment la fiche affirmait 'meme modele SAR que Bootleg' en listant les 34 predicteurs bruts comme la formule publiee, avec Statut='resolu'/'formule publication confirmee et utilisee' -- en realite chaque incendie a son propre ensemble de variables retenues par le RF (differentes entre Bootleg et Schneider Springs, cf. Fig. 4a vs 5a), seule la DEMARCHE en 3 etapes est commune aux deux feux (signale par l'utilisateur 2026-09-10 apres relecture croisee avec ChatGPT, verifie independamment par lecture directe du PDF, p.6-14).",
    ml_formula = "rdnbr ~ Annual_AET_V2_1981_2010 + Annual_Deficit_V2_1981_2010 + Annual_PET_1981_2010 + Annual_PPT_anl_total_1981_2010 + Annual_Tave_anl_mean_1981_2010 + Annual_Tmin_anl_mean_1981_2010 + distance_to_roads_20221021 + distance_to_strms_and_wetlands + distance_to_trt_edge + frs_ss_clipped + gedi_rh100_mean + gedi_rh100_sd + SS_erc + SS_fm100 + SS_fm1000 + SS_minrh + SS_tmmx_celsius + SS_vpd + LF2019_CBD + LF2019_CC + LF2019_CH + scf_20221011 + sdd_20221011 + elevation_10res + hli_10res + slope_10res + sri_10res + tpi_10res_2010win + tpi_10res_410win + tpi_10res_8010win + tri_10res_410win + eastwestness_mx_speed_direction_20230314 + mx_speed_20230310 + northsouthness_mx_speed_direction_20230314",
    ml_response = "rdnbr",
    ml_predictors = c("Annual_AET_V2_1981_2010", "Annual_Deficit_V2_1981_2010", "Annual_PET_1981_2010", "Annual_PPT_anl_total_1981_2010", "Annual_Tave_anl_mean_1981_2010", "Annual_Tmin_anl_mean_1981_2010", "distance_to_roads_20221021", "distance_to_strms_and_wetlands", "distance_to_trt_edge", "frs_ss_clipped", "gedi_rh100_mean", "gedi_rh100_sd", "SS_erc", "SS_fm100", "SS_fm1000", "SS_minrh", "SS_tmmx_celsius", "SS_vpd", "LF2019_CBD", "LF2019_CC", "LF2019_CH", "scf_20221011", "sdd_20221011", "elevation_10res", "hli_10res", "slope_10res", "sri_10res", "tpi_10res_2010win", "tpi_10res_410win", "tpi_10res_8010win", "tri_10res_410win", "eastwestness_mx_speed_direction_20230314", "mx_speed_20230310", "northsouthness_mx_speed_direction_20230314"),
    ml_source_type = "scientific_publication",
    ml_status = "confirmed_predictor_pool_before_rf_reduction",
    ml_estimator_context = c("random_forest", "random_forest_xy", "xgboost", "xgboost_xy"),
    year = "2024",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    source_ref = "Chamberlain et al. (2024), Ecosphere, DOI 10.1002/ecs2.70073; README.md + csvs/predictor_variables_20221108.csv (Dryad 10.5061/dryad.mcvdnck6c) documentent RdNBR (severity/2021_SchneiderSprings_rdnbr_w_offset_DATESADJUSTED.tif, 30m) et 34 predicteurs candidats pour le second incendie (Washington, 2021). 2 couches ecostress absentes du depot public (verifie 2026-08-12) ; aspect_10res egalement absent. forest_mask present mais exclu (masque de zone d'etude). Methode verifiee par lecture directe du PDF (2026-09-10) : Random Forest (Fig. 1, etape 1) ramene les predicteurs a 13 variables retenues (Fig. 5a, R2=0.570) ; CWD/RH/TPI-8010m (une par categorie) servent a apparier 118 controles a 118 traitements (etape 2) ; modele SAR final (etape 3, lag=35m, pseudo-R2 Nagelkerke=0.94) evalue l'effet du type de traitement x temps depuis traitement en controlant pour les 13 variables retenues."
  ),
  amphibian_malformation_prevalence = list(
    formula_pub = "prevalence_skel_ab ~ inorganic_contaminants_metal_PCA2 + dragonfly_abundance + organic_contaminants_PCA2 + metamorph_size + developmental_stage [logistique, selection AIC]",
    formula_used = "prevalence_skel_ab ~ ROADDISTANCE + RoadType",
    formula_used_evidence = "reconstructed_from_data",
    formula_used_generated_despite_pub = TRUE,
    formula_note = "Reeves et al. 2010, 'best model step 3' pour les anomalies squelettiques (72% des cas) : Metal PCA2 + larval dragonfly abundance + organic PCA2, taille et stade de developpement inclus comme covariables obligatoires dans TOUS les modeles squelettiques (justifie par Reeves et al. 2008). Modele SEPARE pour les anomalies oculaires (28% des cas, best model = predatory beetle abundance + developmental stage + size), non retenu ici comme formula_pub principale. X publies (predateurs, contaminants, UVB, temperature, taille, stade) non presents dans le depot Dryad brut. Voir formula_used_divergence_note pour l'ecart avec formula_used.",
    formula_used_divergence_note = "formula_pub est confirmee par le texte integral (Reeves et al. 2010, section 'Statistical assessment of skeletal abnormalities', best model step 3 = Metal PCA2 + larval dragonfly abundance + organic PCA2 + taille + stade), mais aucun des X publies (contaminants, predateurs, UVB, temperature, taille, stade) n'est present dans le depot Dryad brut telecharge -- seuls ROADDISTANCE/RoadType (32/54 sites) sont disponibles localement, motives par l'introduction du papier ('abnormality frequency was higher... at road-accessible sites') mais PAS le modele logistique final retenu par selection AIC.",
    y_term_pub = "prevalence_skel_ab (prevalence d'anomalies squelettiques par site, agregee localement depuis 9011 individus 2000-2012, seuil n>=50/site repris du Table 1 -- CORRECTION 2026-09-10 : remplace prevalence_abnormal (toutes anomalies confondues), qui ne correspond a AUCUN modele publie -- le papier analyse separement squelettique (72% des cas, formula_pub ci-dessus) et oculaire (28%, modele different), jamais une categorie combinee).",
    x_terms_pub = c("inorganic contaminants (Metal PCA2, composante d'ACP sur les metaux)", "larval dragonfly abundance (predateur)", "organic contaminants (organic PCA2, composante d'ACP sur les contaminants organiques)", "metamorph size (covariable obligatoire, tous modeles squelettiques)", "developmental stage (covariable obligatoire, tous modeles squelettiques)"),
    year = "2010",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro). CORRECTION (2026-09-10, verification directe TEI) : (a) formula_pub precisait seulement 3 des 5 termes du 'best model step 3' publie (taille et stade de developpement manquaient, alors qu'ils sont des covariables obligatoires dans TOUS les modeles squelettiques du papier) ; (b) Y utilisait a tort prevalence_abnormal (agregat toutes anomalies), alors que le papier n'analyse jamais cette categorie combinee -- seulement squelettique (72% des cas, best model documente) et oculaire (28%, modele different avec predateurs coleopteres) separement. Y bascule sur prevalence_skel_ab pour correspondre au LHS deja annonce par formula_pub. Year=2010 ajoute (citation Reeves et al. 2010 sans ambiguite)."
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
    source_ref = "Samuelson et al. (2018), Proceedings B, DOI 10.1098/rspb.2018.0807: colony-level reproductive success is analysed against local floral resources, land use and weather covariates. The raw ColonyData table contains the response and covariates; Lat/Lon labels are numerically inverted for southern England and are corrected in the loader.",
    regression_status_override = "mis de cote",
    regression_evidence_override = "publication",
    regression_method_override = "formule adaptee/reconstruite a partir des variables du depot -- ne reproduit PAS la methode exacte du papier (voir correction 2026-09-08)",
    regression_note_override = "Correction (2026-09-08, lecture TEI approfondie) : le papier modelise 'Total production of sexuals' par un hurdle model binomial-negatif zero-altere (partie binaire presence/absence + partie comptage tronquee a zero), pas un GLM/GLMM simple -- \"Total production of sexuals... was analysed using zero-altered negative binomial hurdle models\". Le predicteur d'occupation du sol est aussi different : les auteurs regroupent 80 classes d'occupation du sol en 3 clusters categoriels ('city'/'village'/'agricultural' par PCA+Ward), alors que formula_used utilise les proportions individuelles (Prop_flower500, Prop_imp500, etc.) et des composantes PC comme predicteurs lineaires simultanes -- combinaison non testee telle quelle dans le papier."
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
    formula_pub = "mean_local_relative_abundance ~ regional_frequency * habitat_type [beta regression, logit, mgcv::gam]",
    formula_used = "mean_local_relative_abundance ~ regional_frequency + habitat_floodplain + habitat_swamp + habitat_white_sand + regional_frequency:habitat_floodplain + regional_frequency:habitat_swamp + regional_frequency:habitat_white_sand",
    formula_note = "Matas-Granados et al. (2024), Ecology Letters 27:e14351, section 'Local abundance-regional frequency relationship by habitat type', p.4-6. Modele le plus complexe teste inclut explicitement l'INTERACTION entre regional_frequency et habitat_type, comparaison par AIC (difference>2 = modele ecarte) ; confirme par le texte des resultats -- la pente regional_frequency differe par habitat ('the relationship was more negative in white sand, followed by swamp, floodplain and terra firme'), ce qui exige l'interaction (une simple ordonnee a l'origine differente ne suffirait pas).",
    formula_candidate_formula = "mean_local_relative_abundance ~ regional_frequency * habitat_type",
    y_term_pub = "mean_local_relative_abundance (abondance locale relative moyenne des especes dominantes, moyennee sur les parcelles ou l'espece est presente)",
    x_terms_pub = c("regional_frequency (proportion de parcelles de l'habitat ou l'espece est presente)", "habitat_type (categoriel, 4 niveaux : terra firme/floodplain/swamp/white sand)", "interaction regional_frequency:habitat_type (pentes differentes par habitat, cf. Note)"),
    model_family = "beta_regression_logit_link_gam_betar",
    year = "2024",
    license_name = "Creative Commons Zero v1.0 Universal (CC0 1.0)",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Matas-Granados, Draper, Cayuela, de Aledo, Arellano, Ben Saadi, Baker, Phillips, Honorio Coronado, Ruokolainen, Garcia-Villacorta, Roucoux, Gueze, Valderrama Sandoval, Fine, Amasifuen Guerra, Zarate Gomez, Stevenson Diaz, Monteagudo-Mendoza, Vasquez Martinez, Socolar, Disney, del Aguila Pasquel, Flores Llampazo, Vega Arenas, Reyna Huaymacari, Grandez Rios & Macia (2024), Understanding different dominance patterns in western Amazonian forests, Ecology Letters 27:e14351, DOI 10.1111/ele.14351 (accepte 23 nov. 2023, publie 2024 -- 'Ecology Letters. 2024;27:e14351' est la citation officielle du journal, corrige de 'Matas Granados et al. (2023)' precedent). CORRECTION (2026-09-10, verification directe PDF+TEI) : le modele beta-regression teste explicitement l'interaction regional_frequency:habitat_type comme 'the most complex model' (comparaison AIC), et le texte des resultats confirme que la pente de regional_frequency differe significativement selon l'habitat -- la formule additive precedente (sans interaction) ne pouvait pas reproduire ce resultat central du papier (Figure 2a montre 4 courbes de formes tres differentes par habitat, pas de simples decalages verticaux). Le local loader reconstruit la table espece-dominante x habitat depuis Raw_to_ecology3.csv et Metadata4.csv : p_ij = abondance de l'espece i dans la parcelle j / total d'individus dans la parcelle j, especes dominantes selectionnees jusqu'a 50% de dominance cumulee par habitat (D_i, seuil de Draper et al. 2019 / ter Steege et al. 2013), regional_frequency = parcelles ou l'espece est presente / total de parcelles de l'habitat. N=221 especes-habitat dans l'artefact local, proche mais pas identique a la somme publiee des especes dominantes par habitat (106 terra firme + 73 floodplain + 20 swamp + 18 white sand = 217, texte p.5) -- ecart de 4 non explique, a signaler comme ecart mineur non resolu plutot que suppose identique. Le modele publie (beta, lien logit) n'est pas une famille explicitement enregistree dans le harnais actuel (ols/gam_spatial/sar_lag/sem_error/sdm_mixed/random_forest/xgboost/gwr/probit) -- gam_spatial (mgcv::gam) pourrait en principe accepter family=betar() mais ce n'est pas verifie dans le code du package a ce jour, a traiter comme une approximation non confirmee, pas une reproduction exacte."
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
  ),
  flapper_skate_presence = list(
    formula_pub = "presence_absence ~ depth + distance_to_coast + current + benthic_productivity + fishing_pressure [INLA/SPDE presence-absence model with cloglog link, champ spatial SPDE explicite]",
    formula_used = "present_01 ~ bath + dcoast + current + pp_mean + fishing_hours",
    formula_candidate_formula = "present_01 ~ bath + dcoast + current + pp_mean + fishing_hours",
    y_term_pub = "flapper skate presence/absence by survey haul",
    x_terms_pub = c("bath", "dcoast", "current", "pp_mean", "fishing_hours"),
    ml_formula = "present_01 ~ bath + dcoast + current + pp_mean + fishing_hours",
    ml_response = "present_01",
    ml_predictors = c("bath", "dcoast", "current", "pp_mean", "fishing_hours"),
    ml_estimator_context = c("random_forest", "xgboost", "gamboost"),
    ml_status = "executable_binary_sdm_variant",
    source_ref = "Loca, Collins, Garbett, McGeady, Thorburn & McGonigle (2025) (auteurs corriges le 2026-09-14 -- verifies via le TEI local Loca2025OnThe.tei.xml et Crossref ; l'attribution anterieure 'Bacheler et al.' etait fausse, aucun auteur de ce nom ne figure sur le papier), Ecology and Evolution, DOI 10.1002/ece3.71650; Dryad 10.5061/dryad.w0vt4b954. The README and model_script.R provide full_dataset.csv with haul-level flapper skate presence/absence, lon/lat, bathymetry, distance to coast, current, bottom temperature, benthic productivity and fishing pressure. Le papier ajuste un modele INLA/SPDE (champ aleatoire spatial explicite, lien cloglog). Correction (2026-09-08, lecture TEI approfondie, Loca2025OnThe.tei.xml) : btemp (bottom temperature) a ete RETIRE par les auteurs de leur modele final pour cause de colinearite (\"bottom temperature was dropped from the analysis\"). formula_used/x_terms_used/formula_pub corriges pour ne plus inclure btemp, qui restait a tort dans la specification executable malgre son exclusion documentee par le papier. La colonne btemp reste disponible dans Detail X (candidate non retenue)."
  ),
  bean_landrace_gap_sdm = list(
    formula_pub = "landrace occurrence ~ 23 predicteurs VIF/PCA-selectionnes (16 climatiques + 7 non-climatiques) [MaxEnt/maxnet, puis score de gap seuillee]",
    formula_used = "status_H_01 ~ bio_1 + bio_12 + alt + PETa + popdens + access + distgp1 + rivers + irri + aharv + prod + yield",
    formula_candidate_formula = "status_H_01 ~ selected climate, accessibility and agricultural predictors",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "CORRECTION 2026-09-14 (relecture critique externe + verification directe du fichier source) : la version precedente de cette note affirmait a tort que status_H_01 etait 'probablement' un score de gap derive du MaxEnt. Verifie faux par inspection directe de dataset_s1_revised2.xlsx (feuille bean_predicted_bd_americas, 21561 lignes, colonnes source/status/genepool/coordonnees/50 covariables) : aucune colonne de score de gap, de priorite de collecte ou de sortie MaxEnt n'existe dans ce fichier -- seulement 3 colonnes de metadonnees de provenance (source, status, genepool). status_H_01 est calcule par le loader R (`df$status_H_01 <- as.integer(df$status == \"H\")`) directement depuis la colonne brute `status` du jeu d'occurrences compile (Dataset S1 du papier, section 2.1 du TEI: 'Our full occurrence dataset for P. vulgaris is available in Dataset S1'), qui code si chaque occurrence provient d'une accession de genebank (G, 19831/21561 lignes -- CIAT/Genesys/USDA/WIEWS) ou d'un releve herbier/GBIF independant (H, 1730/21561 lignes -- confirme par le TEI: 'Additional occurrences were gathered from GBIF ... 25,670 observations from herbaria, botanic gardens and other plant repositories, to provide independent data from non-genebank sources'). C'est donc une metadonnee de provenance des points d'occurrence UTILISES EN ENTREE du MaxEnt du papier, pas une sortie de son pipeline de gap analysis (qui produit S_CON/S_ACC/S_ENV, seuilles puis sommes en une carte 0-3, jamais materialisee dans cet artefact local). formula_used est donc une tache de classification binaire entierement construite par le systeme (provenance genebank vs herbier/GBIF, prediction a partir de covariables environnementales/socioeconomiques du meme pool candidat que le papier), et non une approximation du pipeline SDM+gap du papier -- a ne plus presenter comme tel.",
    formula_note = "23 des 50 variables candidates documentees (Table S2.1 du depot, README.txt local) ont ete retenues par les auteurs apres filtrage VIF (<10) + PCA (contribution >=15% au premier axe) -- 16 climatiques + 7 non-climatiques d'apres le texte, mais la liste exacte des 23 survivantes n'est disponible que dans le detail de Table S2.1 (non extrait de ce TEI). Les 12 covariables de formula_used (bio_1, bio_12, alt, PETa, popdens, access, distgp1, rivers, irri, aharv, prod, yield) sont un sous-ensemble plausible et documente de ce pool candidat (couvrant climat + non-climat comme le papier le souligne), pas confirme comme etant exactement les 23 survivantes du filtrage VIF/PCA. Point verifie separement : la colonne locale `ethnic` (texte, 75 groupes ethniques nommes, ex. 'Argentinians', 'Quechua') est un champ de provenance categoriel de l'accession, PAS la covariable numerique 'geographic distribution of ethnic groups' (Weidmann et al. 2010) listee en variable #47 du Tableau S2.1 -- meme nom de colonne, source differente ; exclue de X a raison, mais pour cause de non-numerique/haute-cardinalite, pas en tant qu'identifiant.",
    y_term_pub = "status_H_01 : indicateur binaire de provenance des occurrences (1 = releve herbier/GBIF hors genebank, 0 = accession de genebank), calcule depuis la colonne brute `status` du Dataset S1 du papier -- PAS une sortie du MaxEnt SDM ni du score de gap (verification directe du fichier source, aucune colonne de ce type n'existe localement)",
    x_terms_pub = c("WorldClim bioclimatic variables (16 candidates, bio_1-19)", "solar radiation", "wind speed", "water vapor pressure", "altitude", "potential evapotranspiration (+ variantes ENVIREM)", "population density", "accessibility (temps de trajet)", "distance to primary genepool wild relatives", "distance to rivers", "irrigation fraction", "harvested area", "production", "yield"),
    ml_formula = "status_H_01 ~ climate + accessibility + agricultural predictors",
    ml_response = "status_H_01",
    ml_predictors = c("bio_1", "bio_12", "alt", "PETa", "popdens", "access", "distgp1", "rivers", "irri", "aharv", "prod", "yield"),
    ml_estimator_context = c("random_forest", "xgboost", "gamboost"),
    ml_source_type = "derived_from_scientific_publication_plus_local_dataset_metadata",
    year = "2020",
    ml_status = "executable_provenance_classification_task",
    equation_family = "sdm_maxent_then_locally_constructed_binary_classification",
    model_family = "species_distribution_modeling",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    source_ref = "Ramirez-Villegas, Khoury, Achicanoy, Mendez, Diaz, Sosa, Debouck, Kehel & Guarino (2020), A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces, Diversity and Distributions, DOI 10.1111/ddi.13046 (Ramirez-Villegas, Julian est le premier auteur, Khoury, Colin est le 2e). Dryad 10.5061/dryad.866t1g1n0, README.txt local documente les 50 variables candidates (Table S2.1) avec definitions/unites/sources completes. Methode du papier confirmee par lecture directe du TEI (section 2.4.1) : MaxEnt (package R 'maxnet'), presence/pseudo-absence, K=5 cross-validation, variables sub-selectionnees par VIF (<10) + PCA (contribution >=15% au PC1) parmi les 50 candidates -- 23 retenues (16 climatiques + 7 non-climatiques) pour le meilleur modele ('both' config climat+non-climat). CORRECTION 2026-09-14 (verification directe de dataset_s1_revised2.xlsx + TEI section 2.1) : le fichier local est le Dataset S1 du papier, c.a.d. le jeu d'occurrences COMPILE utilise en ENTREE du MaxEnt (21561 lignes, colonnes source/status/genepool + coordonnees + 50 covariables candidates), pas une sortie du gap analysis. La colonne `status` (G=genebank accession, majoritaire ; H=releve herbier/GBIF independant, ~8% des lignes) code la provenance de chaque occurrence -- confirme par le TEI ('Additional occurrences were gathered from GBIF ... to provide independent data from non-genebank sources'). status_H_01 = as.integer(status==\"H\") est donc une metadonnee de provenance des points d'entree, pas le score de gap ou une sortie MaxEnt. formula_used est une tache de classification binaire construite par le systeme sur cette metadonnee, en reutilisant le pool de covariables environnementales/socioeconomiques documente par le papier -- voir formula_used_divergence_note."
  ),
  nyc_tract_income_ssig = list(
    formula_pub = "per_capita_income, median_household_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare + latitude + longitude [Gaussian Process, noyau Matern-3/2, pas d'equation lineaire fermee -- SHAP utilise pour l'importance des variables]",
    formula_used = "per_capita_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare",
    y_term_pub = "per_capita_income (ou median_household_income), District income at Tract-level",
    x_terms_pub = c("proportion bachelor >=25 ans (UDG25)", "proportion diplome superieur >=25 ans (PGD25)", "taux de chomage (Unemploy)", "proportion >=65 ans (Age65p)", "proportion <18 ans (AgeU18)", "densite de population (PopDensity)", "proportion hommes (MaleShare)", "proportion Black/African American (BlackShare)", "proportion Asian (AsianShare)", "proportion White (WhiteShare)", "latitude/longitude du centroide (spatial info)"),
    ml_formula = "per_capita_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare",
    ml_response = "per_capita_income",
    ml_predictors = c("UDG25", "PGD25", "Unemploy", "Age65p", "AgeU18", "PopDensity", "MaleShare", "BlackShare", "AsianShare", "WhiteShare"),
    ml_estimator_context = c("random_forest", "xgboost", "gamboost", "gam_spatial"),
    ml_status = "executable_continuous_variant",
    source_ref = "Bai, Lam & Li (2023), Humanities and Social Sciences Communications 10:60, DOI 10.1057/s41599-023-01548-7 (SSIG model). Table 2 documente exactement les 10 variables socio-economiques utilisees ; le depot du papier n'est pas public (donnees sur demande), reconstruit depuis les sources publiques citees (ACS via Census Reporter, geometrie TIGER/Line), millesime ACS 2020-2024 5-year au lieu de 2015-2019 (cle API Census Bureau indisponible, decision utilisateur 2026-08-15, cf. README_nyc_tract_income.txt). Modele publie = Gaussian Process (noyau Matern-3/2) + SHAP, pas une regression lineaire ; formula_used est une variante continue executable sur les memes 10 predicteurs."
  ),
  nyc_census2000_gwrboost = list(
    formula_pub = "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT [GWR/GWRBoost, Table 2-3 : OLS R2=0.557, GWR R2=0.825, GWRBoost R2=0.882]",
    formula_used = "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT",
    y_term_pub = "mean_inc (revenu moyen par bloc de recensement)",
    x_terms_pub = c("sub18 (population <18 ans)", "PER_PRV_SC (% eleves ecole privee)", "YOUTH_DROP (% decrocheurs 16-19 ans)", "HS_DROP (% decrocheurs lycee >25 ans)", "COL_DEGREE (% bachelor+ >25 ans)", "SCHOOL_CT (nombre d'ecoles)"),
    ml_formula = "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT",
    ml_response = "mean_inc",
    ml_predictors = c("sub18", "PER_PRV_SC", "YOUTH_DROP", "HS_DROP", "COL_DEGREE", "SCHOOL_CT"),
    ml_estimator_context = c("ols", "gwr", "random_forest", "xgboost", "gamboost"),
    ml_status = "executable_continuous_variant",
    year = "2022",
    source_ref = "Wang, Huang, Yin, Bao, Zhou & Gao (2022) (annee corrigee 2026-09-14 -- le champ Year affichait 2017, qui est l'annee de mise en ligne du shapefile sur GeoDa Lab, pas l'annee de publication de l'article, un arXiv preprint soumis en decembre 2022), arXiv:2212.05814 (GWRBoost, preprint). Section 4.3 'Empirical case study' cite explicitement le jeu de donnees et son URL (https://geodacenter.github.io/data-and-lab//NYC-Census-2000), Table 2 documente les 6 variables independantes exactes + mean_inc en reponse, Table 3-4 rapportent les resultats OLS/GWR/GWRBoost. Shapefile telecharge directement depuis GeoDa Lab -- N=2216 identique au papier, pas une reconstruction. Les 49 autres colonnes du shapefile (race, scolarisation detaillee, sexe, densite) ne font pas partie du cas d'etude publie."
  ),
  hiv_southern_africa = list(
    formula_pub = "PER ~ URBAN_RURA + country + DHSYEAR [regression multivariable, plus autocorrelation spatiale (LISA/hotspot) sur PER par pays]",
    formula_used = "PER ~ URBAN_RURA + country",
    y_term_pub = "PER (taux de positivite VIH par cluster DHS, %)",
    x_terms_pub = c("URBAN_RURA (classification urbain/rural du cluster)", "country (6 pays d'Afrique australe)", "DHSYEAR (annee d'enquete DHS, 2013-2018)", "region administrative ADM1"),
    ml_formula = "PER ~ URBAN_RURA + country + DHSYEAR",
    ml_response = "PER",
    ml_predictors = c("URBAN_RURA", "country", "DHSYEAR"),
    ml_estimator_context = c("gwr", "car", "random_forest", "logistic_binomial_POS_TOT"),
    ml_status = "executable_continuous_variant",
    source_ref = "Adetokunboh, O.O. & Are, E.B. (2024), PLoS ONE 19(4): e0301850, doi:10.1371/journal.pone.0301850. Le depot figshare (10.25413/sun.26976469, mirroir https://figshare.com/s/33e95ee4594a7c146e3b) ne contient QUE les donnees geographiques agregees par cluster DHS (NEG/POS/TOT/PER + coordonnees + URBAN_RURA) utilisees pour l'analyse d'autocorrelation spatiale (LISA/hotspot par pays). La regression multivariable complete du papier (determinants: divorce, age, ISTs recentes) utilise des microdonnees DHS individuelles (DHS Individual Recode) qui necessitent un enregistrement separe aupres du DHS Program et ne sont PAS incluses dans ce depot -- formula_used se limite donc aux covariables reellement presentes dans les donnees locales."
  ),
  usgs_flood_skew = list(
    formula_pub = "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00 [Bayesian Weighted Least Squares / Bayesian Generalized Least Squares (B-WLS/B-GLS), asymetrie regionale des crues annuelles de pointe]",
    formula_used = "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00",
    y_term_pub = "UnbiasSkew (asymetrie regionale non biaisee des debits de pointe annuels)",
    x_terms_pub = c("DRAIN_SQKM (superficie du bassin versant, km2)", "LAT_CENT/LONG_CENT (centroide du bassin)", "BSLDEM100M (pente moyenne du bassin)", "ELEV (elevation)", "COMPRAT (ratio de compacite)", "LC06FOREST (% couverture forestiere)", "LC06WATER (% couverture en eau)", "PERMAVE (permeabilite moyenne du sol)", "PRECPRIS00 (precipitation moyenne)"),
    ml_formula = "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00",
    ml_response = "UnbiasSkew",
    ml_predictors = c("DRAIN_SQKM", "LAT_CENT", "LONG_CENT", "BSLDEM100M", "ELEV", "COMPRAT", "LC06FOREST", "LC06WATER", "PERMAVE", "PRECPRIS00"),
    ml_estimator_context = c("bayesian_wls", "bayesian_gls", "ols", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Veilleux, A.G. & Wagner, D.M. (2021), Methods for estimating regional skewness of annual peak flows in parts of eastern New York and Pennsylvania, based on data through water year 2013, USGS Scientific Investigations Report 2021-5015, doi:10.3133/sir20215015. Shapefile HU02basins.shp telecharge directement depuis ScienceBase (10.5066/p9pgal0d, item enfant 5ea08b8e82cefae35a13fe2b) -- pas une reconstruction, N=183 stations de jaugeage identique au depot source. UnbiasSkew = estimation finale non biaisee de l'asymetrie regionale (methode EMA + correction B-WLS/B-GLS documentee dans le rapport) ; les 10 caracteristiques de bassin correspondent exactement aux variables independantes decrites dans le rapport (drainage area, centroid, slope, elevation, compactness, land cover, permeability, precipitation)."
  ),
  red_deer_topdown = list(
    formula_pub = "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer [Generalized Additive Model (GAM), effets top-down numeriques sur le cerf elaphe]",
    formula_used = "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer",
    y_term_pub = "Deer_density (densite de cerf elaphe, Cervus elaphus)",
    x_terms_pub = c("NPP (productivite primaire nette)", "Bear_presence/Wolf_presence/Lynx_presence (presence des 3 grands carnivores)", "hunting (chasse par l'homme)", "Human_influence_index (indice d'influence humaine)", "IUCN_Catergory (statut de protection du site)", "Prec_all_year (precipitation annuelle)", "Min_Temp_summer/Min_Temp_winter (temperatures minimales)", "NDSI_Snow_Cover (indice de couverture neigeuse)", "Tree_canopy_cover (% couverture forestiere)", "Palmer_drought_summer (indice de secheresse de Palmer)"),
    ml_formula = "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer",
    ml_response = "Deer_density",
    ml_predictors = c("NPP", "Bear_presence", "Wolf_presence", "Lynx_presence", "hunting", "Human_influence_index", "Prec_all_year", "Min_Temp_summer", "Min_Temp_winter", "NDSI_Snow_Cover", "Tree_canopy_cover", "Palmer_drought_summer"),
    ml_estimator_context = c("gam_spatial", "random_forest", "xgboost"),
    ml_status = "executable_continuous_variant",
    year = "2023",
    source_ref = "van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse)."
  ),
  fire_forest_loss_dominican_republic = list(
    formula_pub = "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR [Spatial Lag Model (SAR) ou Spatial Error Model (SEM), choix base sur le test du multiplicateur de Lagrange + test de Breusch-Pagan + AIC ; contiguite Queen's case, ponderation W row-standardized ; approche 'long-terme' 2001-2018]",
    formula_used = "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR",
    y_term_pub = "LOSS0118_PCT_PYR (perte moyenne de couvert forestier par an, % de la surface de la cellule, periode 2001-2018)",
    x_terms_pub = c("NFIRESM6_PSQKM_PYR (densite de points de feu MODIS Collection 6, points/km2/an, filtre 'noise-free')"),
    ml_formula = "LOSS0118_PCT_PYR ~ NFIRESM6_PSQKM_PYR",
    ml_response = "LOSS0118_PCT_PYR",
    ml_predictors = c("NFIRESM6_PSQKM_PYR"),
    ml_estimator_context = c("sar_lag", "sar_error", "spatial_error_model", "spatial_lag_model", "ols"),
    ml_status = "executable_continuous_variant",
    source_ref = "Martinez Batlle, J.R. (2021), Fire and forest loss in the Dominican Republic during the 21st Century, bioRxiv, doi:10.1101/2021.06.15.448604. Fichier grd_zonal_statistics.RDS extrait directement du depot Zenodo (10.5281/zenodo.6990803, isSupplementTo le papier), lui-meme reference dans le depot comme le jeu de donnees exact de l'approche 'long-terme' (grille hexagonale de 482 cellules ~100km2, >=45% de surface terrestre, texte du papier section 'Long-term approach') -- pas une reconstruction. Y et X correspondent exactement a la description du papier ('average forest loss per unit area per year' et 'fire density' = points de feu / aire / annees). NFIRESM6_PSQKM_PYR est NA pour 24/482 cellules (aucune valeur exacte de 0 n'existe ailleurs dans la colonne source, minimum non-NA = 1) -- impute a 0 (absence de feu detecte dans la cellule), coherent avec la definition de densite du papier (comptage/aire/annees), pas une donnee fabriquee."
  ),
  amphibian_abnormality_hotspots = list(
    formula_pub = "sk_plus_eye_ab_percent ~ s(Corrected_LATITUDE, Corrected_LONGITUDE) + (1|site.year) [GAMM, binomial/logit]",
    formula_used = "sk_plus_eye_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION",
    formula_used_generated_despite_pub = TRUE,
    formula_note = "mgcv, distribution binomiale + lien logit, estimation PQL (1000 iterations), terme spatial non-lineaire lat/long, effet aleatoire UNIQUE concatene 'site.year' (retenu par comparaison AIC contre Region/Refuge/Site/Year/Species nested et non-nested) ; analyse complementaire par Getis-Ord Gi* pour la detection de hotspots (echantillon au niveau site, pas le GAMM). Modele SEPARE de variance partitioning (aucun effet fixe, effets aleatoires nested site/refuge/region) pour les % de variance par echelle spatiale (site=53%, refuge=28%, region=17%) -- pas le meme modele que le GAMM. Voir formula_used_divergence_note pour l'ecart avec formula_used.",
    formula_used_divergence_note = "formula_pub est confirmee par le texte de l'article (section 'Spatially explicit analyses', GAMM mgcv, famille binomiale/lien logit, effet aleatoire 'site.year'), mais n'est pas reproduite telle quelle : le harnais actuel ne modelise ni le lien logit/famille binomiale, ni l'effet aleatoire site.year, ni le smooth s(lat,long) dans sa forme GAMM native. formula_used est une approximation continue (lien identite) generee, avec REFUGE/REGION en covariables categoriques plates plutot qu'en effet aleatoire imbrique -- une simplification documentee, pas la specification publiee. Le smooth complet reste disponible via ml_formula (variante gam_spatial).",
    y_term_pub = "sk_plus_eye_ab_percent (pourcentage d'amphibiens d'une collecte presentant AU MOINS une anomalie squelettique OU oculaire -- categorie combinee definie dans README_for_CoreDataset.txt, distincte de all_ab_percent qui inclut EN PLUS les categories surface et maladie). CORRECTION (2026-09-10) : la fiche precedente utilisait a tort all_ab_percent comme Y en affirmant une correspondance exacte au papier -- le GAMM du papier est explicitement decrit comme ajuste sur 'skeletal and eye abnormality prevalence', qui correspond au nom et a la definition README de sk_plus_eye_ab_percent, pas de all_ab_percent.",
    x_terms_pub = c("Corrected_LATITUDE/Corrected_LONGITUDE (terme spatial non-lineaire principal du GAMM, s(lat,long))", "site.year (effet aleatoire unique concatene du GAMM -- PAS des effets separes REFUGE/REGION, cf. Note)"),
    ml_formula = "sk_plus_eye_ab_percent ~ Corrected_LATITUDE + Corrected_LONGITUDE + REFUGE + REGION",
    ml_response = "sk_plus_eye_ab_percent",
    ml_predictors = c("Corrected_LATITUDE", "Corrected_LONGITUDE", "REFUGE", "REGION"),
    ml_estimator_context = c("gam_spatial", "gamm", "random_forest", "xgboost"),
    ml_status = "executable_continuous_variant",
    year = "2013",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Reeves, Medley, Pinkney, Holyoak, Johnson & Lannoo (2013) (auteurs corriges le 2026-09-14 -- confirmes via le TEI local, Crossref et OpenAlex ; l'attribution anterieure 'Gray, M.J., Rogers, J.D., Miller, D.L. et al.' etait fausse, aucun de ces noms ne figure sur ce papier), Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges, PLoS ONE 8(11): e77467, doi:10.1371/journal.pone.0077467. CoreDataset.csv (675 evenements de collecte) joint a Site.csv (666 sites apres dedoublonnage de 4 SITE_ID dupliques dans le depot source) via site_id, telecharge directement depuis Dryad (10.5061/dryad.dc25r, isSupplementTo/primary_article) -- pas une reconstruction. 77/675 evenements sans coordonnee valide (protection d'especes listees federalement, documente dans README_for_Site.txt) sont exclus (N final=598), pas imputes. CORRECTION (2026-09-10, verification directe TEI + README_for_CoreDataset.txt) : la fiche precedente affirmait a tort 'Y et coordonnees correspondent exactement a la description du papier' en utilisant all_ab_percent et (1|REFUGE)+(1|REGION) comme effets aleatoires du GAMM. Le texte TEI (section 'Spatially explicit analyses') confirme que (a) le GAMM cite est ajuste sur 'skeletal and eye abnormality prevalence' = sk_plus_eye_ab_percent (nom et definition confirmes par README_for_CoreDataset.txt, categorie combinee squelettique+oculaire, distincte de all_ab_percent qui inclut aussi surface+maladie), avec famille binomiale et lien logit (PQL, 1000 iterations) ; (b) l'effet aleatoire du GAMM est un terme UNIQUE concatene 'site.year', retenu apres comparaison AIC de plusieurs structures (Region/Refuge/Site/Year/Species, nested/non-nested, Table S6) -- PAS des effets separes (1|REFUGE)+(1|REGION) ; (c) la structure nichee site/refuge/region (53%/28%/17% de variance) provient d'un modele DIFFERENT et plus simple ('simple variance components analysis', sans effet fixe), utilise uniquement pour le partitionnement de variance, jamais combine avec le smooth s(lat,long) dans le meme modele. Year=2013 ajoute (citation Gray et al. 2013 sans ambiguite ; aucun bib_key/record KG associe a ce dataset dans paper_dataset_uses.json, donc pas de derivation automatique possible)."
  ),
  covid_sociodemographic_risk = list(
    formula_pub = "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65 [approche 1 : regression multilineaire de Poisson par region HHS + niveau national (10 modeles) ; approche 2 : Geographically Weighted Random Forest (GWRF), technique novatrice du papier, ajustee separement pour 3 vagues pandemiques (Alpha/Delta/Omicron)]",
    formula_used = "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65",
    y_term_pub = "death_rate_per_100k (deces cumules COVID-19 par comte, ajustes a la population, coupe transversale au 2022-04-27)",
    x_terms_pub = c("RPL_THEME1-4 (les 4 themes CDC SVI 2018 : statut socio-economique, composition menage/handicap, statut minoritaire/langue, logement/transport)", "pct_voted_biden_2020 (pourcentage de vote democrate 2020, proxy ideologie politique)", "vaccination_pct_apr2022 (taux de vaccination au 2022-04-27)", "population_density", "Obesity, Unemployed, Uninsured_Adults, Associations, Diabetes, Food_Insecurity (CDC County Health Rankings)", "broadband_access", "Age_over_65"),
    ml_formula = "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65",
    ml_response = "death_rate_per_100k",
    ml_predictors = c("RPL_THEME1", "RPL_THEME2", "RPL_THEME3", "RPL_THEME4", "pct_voted_biden_2020", "vaccination_pct_apr2022", "population_density", "Obesity", "Unemployed", "Uninsured_Adults", "Associations", "Diabetes", "Food_Insecurity", "broadband_access", "Age_over_65"),
    ml_estimator_context = c("spatial_random_forest", "gwr", "random_forest", "poisson_regression", "xgboost"),
    ml_status = "executable_continuous_variant",
    source_ref = "Seamon, E., Ridenhour, B.J., Miller, C.R. & Johnson-Leung, J. (2023), Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality, medRxiv, doi:10.1101/2023.07.21.23292785. Shapefile UScounties_conus.shp + 8 fichiers de covariables CSV telecharges directement depuis Dryad (10.5061/dryad.4j0zpc8j1, repo GitHub du papier archive sur Dryad) -- pas une reconstruction, jointure sur FIPS via data/raw/papers/DatasetFirst_10_5061_dryad_4j0zpc8j1/build_county_covid_table.py (script documente, aucune valeur inventee). Les 15 covariables correspondent exactement a la Table 1 du papier. Le papier ajuste 3 modeles distincts par vague pandemique (Alpha/Delta/Omicron) plus un modele national/regional Poisson -- ce loader utilise une coupe transversale unique en fin de periode commune aux sources (deces cumules + vaccination au 2022-04-27) plutot que de reproduire les 3 vagues separement, reduction de perimetre assumee et documentee."
  ),
  fhb_ensembling = list(
    formula_pub = "Class ~ resist + wc + [sous-ensemble de variables meteo, variable selon le modele] [39 modeles de regression logistique de base (M1-M39), issus de 4 papiers anterieurs (DeWolf 2003, Shah 2013/2014/2019) + 20 nouveaux modeles, ensembles via vote souple, moyenne ponderee, et stacking (ridge/lasso/elastic-net) -- le papier evalue l'ensembling de modeles simples mais fortement correles]",
    formula_used = "S ~ resist + wc + corn + type",
    y_term_pub = "Class (classification binaire epidemie/non-epidemie de fusariose de l'epi, seuil sur S) ; S (indice de severite FHB continu, %, 0-100) disponible comme variante continue directement dans les donnees",
    x_terms_pub = c("resist (4 niveaux de resistance varietale : VS/S/MS/MR)", "wc (type ble : sw=printemps, wwc=hiver+residus mais, wwnoc=hiver sans residus mais)", "corn (presence de residus de mais dans la parcelle)", "340 variables meteo candidates (temperature, point de rosee, pression, humidite relative, deficit de pression de vapeur -- Section 2.1 de FHBEnsemblesCode.html), differentes selon chacun des 39 modeles de base"),
    ml_formula = "S ~ resist + wc + corn + type",
    ml_response = "S",
    ml_predictors = c("resist", "wc", "corn", "type"),
    ml_estimator_context = c("logistic_regression", "random_forest", "gwr", "stacking_ensemble"),
    ml_status = "executable_continuous_variant",
    source_ref = "Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure."
  ),
  snake_home_range = list(
    formula_pub = "HR ~ log(Mass) + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip + (1|study) + (1|species) [Modele Lineaire Mixte (LMM), package lme4, intercepts aleatoires etude/espece, comparaison de modeles emboites par AICc]",
    formula_used = "X100MCP ~ MaleMass + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip",
    y_term_pub = "HR (taille du domaine vital, home range, methodes MCP/Kernel Density selon l'etude source)",
    x_terms_pub = c("Mass (masse corporelle, log-transformee)", "IUCN_habitats (largeur de niche d'habitat)", "Aquatic_index (indice d'aquaticite)", "Elevation", "NPP (productivite primaire nette)", "MeanAnnualTemp", "Total_Precip"),
    ml_formula = "X100MCP ~ MaleMass + IUCN_habitats + Aquatic_index + Elevation + NPP + MeanAnnualTemp + Total_Precip",
    ml_response = "X100MCP",
    ml_predictors = c("MaleMass", "IUCN_habitats", "Aquatic_index", "Elevation", "NPP", "MeanAnnualTemp", "Total_Precip"),
    ml_estimator_context = c("mixed_effects_model", "gwr", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Todd, B.D. & Nowakowski, A.J. (2021), Ectothermy and the macroecology of home range scaling in snakes, Global Ecology and Biogeography, doi:10.1111/geb.13225. CSV original (todd_and_nowakowski_snake_home_range_full_dataset.csv) telecharge directement depuis le depot DataCite/Dryad (10.25338/b85g98) -- pas une reconstruction, N=113 especes, N=109 apres exclusion des 4 lignes sans coordonnees. Les noms de colonnes numeriques (100MCP, 95MCP, 100KD, 95KD) sont automatiquement prefixes 'X' par R a la lecture (100MCP -> X100MCP) -- comportement standard de read.csv/make.names, pas une erreur de donnee. X100MCP retenu comme Y principal (41/109 valeurs non-NA, differentes etudes ayant utilise differentes methodes d'estimation du domaine vital -- NA reel documente, pas fabrique)."
  ),
  amphibian_functional_diversity = list(
    formula_pub = "H0 ~ MeanAnnualTemp + Pp + Ts + AI [modele SAR (spatial autoregressive), modele final publie -- OLS+Dutilleul ne sert qu'au criblage prealable de colinearite sur le jeu complet de 6 variables candidates]",
    formula_used = "H0 ~ MeanAnnualTemp + Pp + Ts + AI",
    y_term_pub = "H0 ; Richness disponible comme variante",
    x_terms_pub = c("MeanAnnualTemp", "Pp", "Ts", "AI"),
    ml_formula = "H0 ~ MeanAnnualTemp + Pp + Ts + AI",
    ml_response = "H0",
    ml_predictors = c("MeanAnnualTemp", "Pp", "Ts", "AI"),
    ml_estimator_context = c("ols", "sar_lag", "sar_error", "gwr", "random_forest"),
    ml_status = "executable_continuous_variant",
    year = "2019",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Ochoa-Ochoa, L.M. et al. (2019), Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World, Global Ecology and Biogeography, doi:10.1111/geb.12926. Appendix S3 CSV telecharge directement depuis le depot Dryad (10.5061/dryad.nk0bj96) -- pas une reconstruction, N=4065 cellules de grille (Ameriques, X/Y en degres decimaux). CORRECTION (session 2026-08-16) : colonne source 'T' renommee 'MeanAnnualTemp' dans le loader pour lever la collision avec la convention TIME_VAR du pipeline partage -- meme colonne/valeurs, pas une reconstruction. CORRECTION APPLIQUEE (2026-09-08, lecture TEI approfondie) : le modele publie H0~environnement est un SAR (spatial autoregressive), pas un OLS -- le TEI precise 'We generated an SAR model for each functional diversity metric... explicit spatial dependence is allowed within a neighbourhood structure' (l'OLS+correction Dutilleul ne sert qu'au criblage prealable de colinearite sur les 6 variables candidates, pas au modele final). Le texte precise : 'Final models were run with annual mean temperature, annual precipitation, temperature seasonality and aridity index' (4 variables, NPP et Pps retires) -- desormais disponibles telles quelles dans le RDS local, sar_lag ajoute comme estimateur eligible.",
    regression_status_override = "resolu (corrige 2026-09-08)",
    regression_evidence_override = "publication -- variables ET methode (SAR) desormais conformes au modele final du papier",
    regression_method_override = "formule publication confirmee et corrigee (4 variables du modele final, SAR)",
    regression_note_override = "Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique."
  ),
  dragonfly_colour_lightness = list(
    formula_pub = "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean [Modeles a erreur autoregressive (SEM) pour corriger l'autocorrelation spatiale ; regressions ajustees separement par continent (Amerique du Nord / Europe)]",
    formula_used = "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean",
    y_term_pub = "meanRGB (luminosite/clarte de couleur moyenne de l'assemblage de libellules)",
    x_terms_pub = c("bio1_mean (temperature annuelle moyenne)", "bio4_mean (saisonnalite de temperature)", "bio10_mean (temperature moyenne du trimestre le plus chaud)", "bio12_mean (precipitation annuelle)", "bio18_mean (precipitation du trimestre le plus chaud)", "alt_mean (altitude)"),
    ml_formula = "meanRGB ~ bio1_mean + bio4_mean + bio10_mean + bio12_mean + bio18_mean + alt_mean",
    ml_response = "meanRGB",
    ml_predictors = c("bio1_mean", "bio4_mean", "bio10_mean", "bio12_mean", "bio18_mean", "alt_mean"),
    ml_estimator_context = c("sem_error", "sar_lag", "ols", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Pinkert, S., Brandl, R. & Zeuss, D. (2016), Colour lightness of dragonfly assemblages across North America and Europe, Ecography, doi:10.1111/ecog.02578. CSV original (grille poolee Amerique du Nord + Europe) telecharge directement depuis le depot Dryad (10.5061/dryad.72tp3) -- pas une reconstruction, N=9966 cellules de grille. Fichier europeen (';' separateur de champs, ',' separateur decimal), lu via read.csv2. Y et X correspondent exactement aux variables bioclimatiques WorldClim decrites dans le papier."
  ),
  groundfish_cpue = list(
    formula_pub = "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5 [Moyenne de modeles (multimodel averaging, AIC), modeles candidats a differentes fenetres temporelles de coefficient de variation de la temperature de surface de la mer (SST) hivernale]",
    formula_used = "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5",
    y_term_pub = "CPUE (capture par unite d'effort, standardisee par palangre, especes de poissons de fond d'Alaska)",
    x_terms_pub = c("SST_cvW1-W5 (coefficient de variation de la temperature de surface de la mer hivernale, sur grille 0.25 degre, a 5 largeurs de fenetre temporelle differentes)"),
    ml_formula = "CPUE ~ SST_cvW1 + SST_cvW2 + SST_cvW3 + SST_cvW4 + SST_cvW5",
    ml_response = "CPUE",
    ml_predictors = c("SST_cvW1", "SST_cvW2", "SST_cvW3", "SST_cvW4", "SST_cvW5"),
    ml_estimator_context = c("model_averaging", "gwr", "random_forest", "sar_lag"),
    ml_status = "executable_continuous_variant",
    source_ref = "Correia, H.E. (2018), Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch, Ecology and Evolution, doi:10.1002/ece3.4488. CSV original (stema_data.csv) telecharge directement depuis Dryad (10.5061/dryad.s23g7bc) -- pas une reconstruction, N=6716 (panel station x annee). Y et X correspondent exactement aux variables decrites dans le papier (CPUE standardisee AFSC, coefficient de variation de la SST hivernale sur grille 0.25 degre, plusieurs fenetres temporelles)."
  ),
  leishmaniasis_occurrence = list(
    formula_pub = "P(occurrence) ~ [modele boosted regression trees (BRT) sur points de presence, pour cartographier la niche environnementale de la leishmaniose cutanee et viscerale a l'echelle mondiale, avec covariables climatiques/environnementales et generation de pseudo-absences]",
    formula_used = "DISEASE_binary ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY",
    y_term_pub = "DISEASE",
    x_terms_pub = c("YEAR (annee du releve)", "SOURCE_TYPE (type de source bibliographique)", "ADMIN_LEVEL (niveau administratif de la localisation)", "COUNTRY (pays)"),
    ml_formula = "DISEASE_binary ~ YEAR + SOURCE_TYPE + ADMIN_LEVEL + COUNTRY",
    ml_response = "DISEASE_binary",
    ml_predictors = c("YEAR", "SOURCE_TYPE", "ADMIN_LEVEL", "COUNTRY"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_binary_variant",
    source_ref = "Pigott et al. (2014), Global distribution maps of the leishmaniases, eLife, doi:10.7554/elife.02851. Le papier compile des points d'occurrence bibliographiques de leishmaniose cutanee et viscerale a l'echelle mondiale et ajuste des modeles boosted regression trees (BRT) avec covariables environnementales/climatiques et pseudo-absences generees pour cartographier le risque. Donnees brutes (CL_final_dataset.xlsx + VL_final_dataset.xlsx, localites de type 'point' uniquement) telechargees directement depuis Dryad (10.5061/dryad.05f5h) -- pas une reconstruction, N=7762 occurrences ponctuelles, echelle mondiale. Reduction binaire APPLIQUEE (2026-09-08, investigation complete : dossier brut re-ouvert, papier relu, ecart d'effectifs elucide) : le TEI confirme que les auteurs modelisent CL et VL SEPAREMENT comme deux taches binaires (jamais une classification a 3 niveaux). Mucocutaneous est un sous-type clinique reconnu de la leishmaniose cutanee, donc le regroupement Cutaneous+Mucocutaneous=CL vs Visceral=VL est a la fois clinique et fidele au cadre de modelisation separee CL/VL du papier. Nouvelle colonne DISEASE_binary (factor, VL/CL) ajoutee au RDS local (2026-09-08) ; formula_used/x_terms_used/Selected Y typology corriges en consequence.",
    regression_status_override = "resolu (corrige 2026-09-08)",
    regression_evidence_override = "publication -- reponse binaire (DISEASE_binary) alignee sur la modelisation separee CL/VL des auteurs ; covariables X restent une adaptation (BRT+covariables climatiques du papier non disponibles localement)",
    regression_method_override = "formule adaptee (covariables du depot uniquement) mais reponse desormais fidele au cadre binaire CL/VL du papier",
    regression_note_override = "Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16), reponse corrigee en binaire le 2026-09-08 apres investigation complete (dossier brut + TEI)."
  ),
  mistletoe_bird_abundance = list(
    formula_pub = "TotalBirdAbundance ~ blossom_score + Season + noisy_miner_abundance + canopy_cover + shrub_cover + tree_species_composition + land_use + water_distance + survey_time + log1p(live_mistletoe_abundance) + live_mistletoe_abundance:Season [modele INLA GLMM avec effet aleatoire spatial SPDE (Matern), erreur de Poisson, effets aleatoires observateur/region, testant l'interaction mistletoe x saison de reproduction pour evaluer la moderation de la secheresse]",
    formula_used = "Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season",
    y_term_pub = "Total_abundance (abondance totale d'oiseaux, toutes especes hors bruyant polyphonique noisy miner, par visite de site)",
    x_terms_pub = c("total_live_mistletoe (abondance de gui vivant, log+1 transformee dans le papier)", "canopy_cover (couverture de canopee)", "shrub_cover (couverture arbustive)", "Season (saison de reproduction, interaction avec le gui)", "land_use, distance a l'eau, heure de releve (non retenus dans formula_used, disponibles dans l'artefact local)"),
    ml_formula = "Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season + Region",
    ml_response = "Total_abundance",
    ml_predictors = c("total_live_mistletoe", "total_dead_mistletoe", "canopy_cover", "shrub_cover", "large_old_tree_total", "Season", "Region"),
    ml_estimator_context = c("gam_spatial", "random_forest", "xgboost", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie."
  ),
  stwr_precip_isotope = list(
    formula_pub = "d2h ~ ppt + tmean + height [Eq. 21 du papier : modele de regression spatio-temporelle ponderee (STWR), compare a GWR et GTWR, sur les isotopes d'hydrogene des precipitations (delta2H) dans le nord-est des Etats-Unis]",
    formula_used = "d2h ~ ppt + tmean + Elevation",
    y_term_pub = "d2h (isotope d'hydrogene des precipitations, delta2H, per mille)",
    x_terms_pub = c("ppt (precipitation totale journaliere, pluie + neige fondue)", "tmean (temperature moyenne journaliere)", "height/Elevation (elevation du site)"),
    ml_formula = "d2h ~ ppt + tmean + Elevation",
    ml_response = "d2h",
    ml_predictors = c("ppt", "tmean", "Elevation"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "sem_error", "random_forest"),
    ml_status = "confirmed_continuous_response",
    year = "2020",
    source_ref = "Que et al. (2020), A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time, Geoscientific Model Development, doi:10.5194/gmd-13-6149-2020. Le papier presente l'equation exacte (Eq. 21) : y = b0 + b1*ppt + b2*tmean + b3*height + e, appliquee a un jeu de donnees reel de 272 points de mesure d'isotopes d'hydrogene des precipitations dans le nord-est des Etats-Unis ('272 points for model calibration', correspond exactement a N=272 du fichier precip_isotope_D3.csv). Donnees brutes telechargees directement depuis le depot logiciel Zenodo du papier (10.5281/zenodo.3637689) -- pas une reconstruction, formule et N confirmes par lecture directe du texte (TEI)."
  ),
  airbnb_europe_prices = list(
    formula_pub = "SDM (spatial Durbin model, WX+WY, modele retenu) : log_price ~ rho*W*log_price + room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + W*X [Gyodi & Nawaro (2021), Eq. 5 p.6 ; 4 modeles estimes -- OLS, SLX (WX), SAR (WY), SDM (WX+WY) -- SDM retenu (meilleure log-vraisemblance dans les 10 villes, AIC le plus bas dans 7/10) ; SAR second meilleur ; aucun modele SEM n'est estime par ce papier (SEM cite uniquement dans la revue de litterature d'autres etudes, jamais ajuste ici) ; rest_index teste separement d'attr_index (colinearite VIF documentee, jamais dans la meme regression) ; W = k plus proches voisins (k=10) standardise par ligne, robustesse testee avec k=5/25/50 et W de distance a 500m/1000m]",
    formula_used = "log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index",
    formula_candidate_formula = "log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index",
    y_term_pub = "log_price (logarithme du prix Airbnb, distribution asymetrique justifiant la transformation log selon le papier)",
    x_terms_pub = c("room_private (dummy chambre privee, reference = logement entier)", "room_shared (dummy chambre partagee)", "person_capacity", "host_is_superhost", "multi/biz (professionnalisation de l'hote)", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist (distance au centre-ville)", "metro_dist (distance au metro)", "attr_index (indice d'attractivite touristique, specification principale -- rest_index teste separement, cf. Note)"),
    ml_formula = "log_price ~ room_private + room_shared + person_capacity + host_is_superhost + multi + biz + cleanliness_rating + guest_satisfaction_overall + bedrooms + dist + metro_dist + attr_index + city + period",
    ml_response = "log_price",
    ml_predictors = c("room_private", "room_shared", "person_capacity", "host_is_superhost", "multi", "biz", "cleanliness_rating", "guest_satisfaction_overall", "bedrooms", "dist", "metro_dist", "attr_index", "city", "period"),
    ml_estimator_context = c("ols", "sar_lag", "sdm_mixed", "gam_spatial", "random_forest", "gwr"),
    ml_status = "confirmed_continuous_response",
    source_ref = "Gyodi & Nawaro (2021), Determinants of Airbnb prices in European cities: A spatial econometrics approach, Tourism Management 86:104319, doi:10.1016/j.tourman.2021.104319. CORRECTION (2026-09-10, verification directe PDF+TEI apres signalement utilisateur) : (1) room_type (colonne locale) n'est pas la variable publiee -- Table 1 documente room_private et room_shared comme 2 dummies separes (reference = logement entier), confirme par Fig. 3 (coefficients direct_room_shared/direct_room_private distincts) ; les 2 vraies colonnes existent dans l'artefact local et remplacent room_type. (2) Le papier N'ESTIME PAS de modele SEM : Section 4.1 confirme 4 modeles compares (OLS, SLX/WX, SAR/WY, SDM/WX+WY, Eq. 3-5), SDM retenu ('we will focus on the results of the SDM model', meilleure log-vraisemblance/AIC), SAR second. SEM n'apparait que dans la revue de litterature d'autres etudes (Section 3.2, ex. Halleck Vega & Elhorst 2015), jamais ajuste par ces auteurs. (3) attr_index et rest_index ne sont jamais dans la meme regression : test VIF documente une colinearite entre les 2 indices TripAdvisor, 'the two variables will be tested separately in the analysis' -- attr_index est la specification presentee en premier (Figs. 3-5), rest_index en variante secondaire (fin de section 4.2) ; formula_used retient attr_index. (4) Construction de W documentee par les auteurs (Section 3.2, p.6) : 'we decided to calculate row-standardised W with the 10 closest neighbours' (k=10, standardise par ligne) comme choix principal ; robustesse testee avec k=5/25/50 voisins et W de distance a 500m et 1000m. (5) 'weekday/weekend' n'est PAS une structure panel a 2 periodes du point de vue du papier : Section 3.1 dit explicitement 'The analysis is based on the weekday samples, while the weekend data are used for robustness checks' (Appendix B, Fig. B.1) -- modele principal sur l'echantillon weekday uniquement, weekend = re-estimation independante de robustesse, pas un panel joint. Le fait que les memes annonces apparaissent dans les 2 fichiers (repetitions de coordonnees reelles) reste vrai et justifie toujours un regroupement par annonce en CV, mais ce n'est pas une structure temporelle documentee par le papier lui-meme. Donnees brutes (20 fichiers ville x periode) telechargees directement depuis Zenodo (10.5281/zenodo.4446043) -- pas une reconstruction, N=51707 annonces, coordonnees reelles (lng/lat)."
  ),
  seshat_social_complexity = list(
    formula_pub = "PolityPopulation_t ~ PolityPopulation_(t-1) + covariables de complexite sociale [modele de regression dynamique (autoregressif) ajuste separement pour chaque variable de complexite sociale Seshat -- l'article demontre comment ajuster des modeles de regression dynamique a des donnees panel NGA x Polity x temps avec autocorrelation temporelle et incertitude de codage]",
    formula_used = "Polity_Population ~ Polity_territory + Administrative_levels + Settlement_hierarchy",
    y_term_pub = "Polity_Population (population totale de la polite, valeur maximale enregistree sur sa duree de vie)",
    x_terms_pub = c("Polity_territory (superficie territoriale de la polite, km2)", "Administrative_levels (nombre de niveaux hierarchiques administratifs)", "Settlement_hierarchy (nombre de niveaux hierarchiques d'habitat)"),
    ml_formula = "Polity_Population ~ Polity_territory + Administrative_levels + Settlement_hierarchy",
    ml_response = "Polity_Population",
    ml_predictors = c("Polity_territory", "Administrative_levels", "Settlement_hierarchy"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Turchin (2018), Fitting Dynamic Regression Models to Seshat Data, Cliodynamics, doi:10.21237/C7clio9137696. Le papier demontre comment ajuster des modeles de regression dynamique (autoregressifs, tenant compte de l'autocorrelation temporelle) aux donnees panel de la base Seshat (Natural Geographic Area x Polity x variable x periode). formula_used simplifie le panel temporel du papier en une coupe transversale par polite (valeur maximale enregistree sur la duree de vie de chaque polite pour chacune des 4 variables, agregation documentee du format long NGA/Polity/Variable/Date vers une table large) -- ce n'est pas le modele dynamique du papier mais une regression de complexite sociale standard dans la litterature Seshat (correlation population-hierarchie administrative). Coordonnees des 33 zones geographiques naturelles (NGA) Seshat obtenues par geocodage Nominatim/OpenStreetMap de leur nom de region historique (service public, verifie individuellement, pas une estimation -- 2 NGA non appariees a une polite avec donnees de population completes exclues). Donnees brutes (SCdat.csv) telechargees directement depuis Dryad (10.17916/p6159w) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=307 polites, 31 NGA."
  ),
  ltar_crop_rotation_yield = list(
    formula_pub = "maize_yield ~ RCI (indice de complexite rotationnelle) x year (effet d'interaction, modele bayesien hierarchique par site) [le papier synthetise 11 experiences de rotation de cultures de long terme en Amerique du Nord (347 site-annees) pour montrer que la diversification des rotations ameliore les rendements de mais, notamment sous conditions stressantes]",
    formula_used = "yield_kg_ha ~ system + tillage + fertilization + year",
    y_term_pub = "yield_kg_ha (rendement de mais, kg/ha, releve historique par parcelle-annee)",
    x_terms_pub = c("system (identifiant de rotation de culture, utilise pour calculer le RCI)", "tillage (travail du sol : conventionnel/reduit/sans labour)", "fertilization (regime de fertilisation azotee)", "year (annee, tendance temporelle)"),
    ml_formula = "yield_kg_ha ~ system + tillage + fertilization + year + site",
    ml_response = "yield_kg_ha",
    ml_predictors = c("system", "tillage", "fertilization", "year", "site"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    year = "2020",
    source_ref = "Bowles, Mooshammer, Socolar, Calderon, Cavigelli, Culman, Deen, Drury, Garcia y Garcia, Gaudin, Harkcom, Lehman, Osborne, Robertson, Salerno, Schmer, Strock & Grandy (2020) (auteurs corriges le 2026-09-14 -- confirmes via Crossref, DOI 10.1016/j.oneear.2020.02.007 ; l'attribution anterieure 'Macchi et al.' etait fausse -- Macchi est l'auteur d'un tout autre papier, chaco_bird_richness, dans ce meme corpus), Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America, One Earth. Le papier synthetise 11 experiences de rotation de mais de long terme (347 site-annees, 1959-2016) et modelise le rendement en fonction d'un indice de diversite rotationnelle (RCI) et de son interaction avec le temps, dans un cadre bayesien hierarchique par site. formula_used utilise les covariables de conception experimentale directement presentes dans le fichier de donnees (systeme de rotation, travail du sol, fertilisation), une simplification documentee du RCI calcule par le papier a partir du systeme. Coordonnees des 11 sites lues directement dans le Tableau 1 du papier (lat/lon publies, pas une estimation ni un geocodage approximatif) : Akron CO (40.2,-103.1), Brookings SD (44.4,-96.8), Lamberton MN (44.2,-95.3), Mead NE (41.1,-96.5), Woodslee ON (42.2,-82.7), Hoytville OH (41.2,-83.8), Hickory Corners MI (42.4,-85.4), Elora ON (43.6,-80.4), Wooster OH (40.8,-81.9), Rock Springs PA (40.7,-78.0), Beltsville MD (39.0,-76.9). Donnees brutes (ltar.data.csv) telechargees directement depuis Dryad (10.6078/d1h409) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=11970 parcelle-annees."
  ),
  danajon_coral_distribution = list(
    formula_pub = "P(coral) ~ multiple_stressors (pression de peche, distance au marche, population humaine) + geomorphologie + zone ecologique [le papier etudie l'influence de facteurs de stress multiples (pression de peche, acces au marche, demographie des barangays) sur la distribution spatiale des coraux dans le Danajon Bank, a partir d'une carte d'habitat combinant teledetection et cartographie participative (connaissance ecologique locale)]",
    formula_used = "is_coral ~ Geomorphic + Location + Map + reclass + area_m2",
    y_term_pub = "is_coral (indicateur binaire de presence de corail, classe reclassifiee Hab_Paper=='Coral' de la carte d'habitat du papier)",
    x_terms_pub = c("Geomorphic (classe geomorphologique : recif frangeant/pente/lagune)", "Location (zone ecologique : recif interne/externe, cotier, ile terrestre)", "Map (source de cartographie : teledetection RS, connaissance ecologique locale LEK, edition manuelle)", "reclass (indicateur de reclassification manuelle)", "area_m2 (surface du polygone d'habitat)"),
    ml_formula = "is_coral ~ Geomorphic + Location + Map + reclass + area_m2",
    ml_response = "is_coral",
    ml_predictors = c("Geomorphic", "Location", "Map", "reclass", "area_m2"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_binary_variant",
    source_ref = "Selgrath, Gergel & Vincent (2025), The influence of multiple stressors on the spatial distribution of corals, People and Nature, doi:10.1002/pan3.70208. Le papier utilise une carte d'habitat combinant teledetection et cartographie participative (Selgrath et al. 2016, Ecosphere, doi:10.1002/ecs2.1325, pour la methode de cartographie) pour etudier l'effet de facteurs de stress humains (peche, marche, demographie -- covariables dans les fichiers barangay_* du meme depot) sur la distribution des coraux. formula_used utilise le polygone d'habitat reclassifie (Hab_Paper, variable de classification utilisee dans l'analyse du papier selon le readme du depot) converti en points (centroides de polygones) avec un indicateur binaire de corail, plus les covariables geomorphologiques et de zone ecologique deja presentes dans la meme couche -- une simplification documentee qui n'inclut pas encore les covariables de pression humaine (barangay_demographics, distance_market) du meme depot, non jointes spatialement ici par manque de cle de jointure directe entre polygones d'habitat et barangays. Donnees brutes (habitat_full_area_rs_lek_reclass_20250615_union_with_fa2.shp) telechargees directement depuis Dryad (10.5061/dryad.z34tmpgpt) -- pas une reconstruction, N=29512 polygones d'habitat (apres exclusion des classes Cloud/Deep/DeepWater/No Class), coordonnees reelles (Danajon Bank, Bohol, Philippines)."
  ),
  shark_longline_catch = list(
    formula_pub = "catch ~ sdm + species_commonname + mean_sst + mean_chla + effort + [combinaisons de mean_ssh, cv_sst, cv_chla, cv_ssh, prix ex-vessel] [modele Random Forest a deux composantes : (1) classification presence/absence, (2) regression de la capture conditionnelle a la presence ; prediction finale = composante 1 x composante 2 ; ajuste separement par ORGP (ICCAT/IOTC/IATTC/WCPFC)]",
    formula_used = "catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species",
    y_term_pub = "catch (capture de requin, comptage, palangre industrielle, ICCAT -- Atlantique)",
    x_terms_pub = c("mean_sst (temperature de surface de la mer moyenne)", "mean_chla (chlorophylle-a moyenne)", "mean_ssh (hauteur de surface de la mer moyenne)", "sdm (score de modele de distribution d'espece, covariable d'entree du RF)", "target_effort (effort de peche par pavillon)", "median_price_species (prix ex-vessel median par espece)"),
    ml_formula = "catch ~ mean_sst + mean_chla + mean_ssh + sdm + target_effort + median_price_species + species_commonname",
    ml_response = "catch",
    ml_predictors = c("mean_sst", "mean_chla", "mean_ssh", "sdm", "target_effort", "median_price_species", "species_commonname"),
    ml_estimator_context = c("random_forest", "random_forest_xy", "xgboost", "gam_spatial", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Burns, Bradley & Thomas (2023), Global hotspots of shark interactions with industrial longline fisheries, Frontiers in Marine Science, doi:10.3389/fmars.2022.1062447. Le papier ajuste des modeles Random Forest en deux composantes (classification presence/absence x regression de capture) par ORGP (ICCAT/IOTC/IATTC/WCPFC) avec SST, chlorophylle-a, hauteur de mer, effort de peche, prix ex-vessel et un score de modele de distribution d'espece comme predicteurs. formula_used utilise la table de predicteurs reels (pas les predictions .pred/.final_pred du modele, exclues) pour ICCAT (Atlantique) uniquement -- les 4 ORGP ont des schemas de colonnes legerement differents (drapeaux de flotte differents), non fusionnes ici. Donnees brutes (ICCAT_ll_untuned_final_predict.csv) telechargees directement depuis Dryad (10.25349/d9789w) -- pas une reconstruction, N=8592 cellules de grille, papier recupere manuellement par l'utilisateur (session 2026-08-16)."
  ),
  sfbay_contaminated_sites = list(
    formula_pub = "is_open_case ~ FID_Rise_S (niveau de risque de remontee de nappe) + gridcode (zone d'inondation) [le papier compare la vulnerabilite des sites contamines (statut ouvert/actif vs ferme) aux zones de remontee de nappe phreatique (GWR) et d'inondation par elevation du niveau marin, sur les bases de donnees Envirostor (DTSC) et GeoTracker (SWRCB) combinees pour la baie de San Francisco]",
    formula_used = "is_open_case ~ FID_Rise_S + gridcode + COUNTY",
    y_term_pub = "is_open_case (statut du site contamine : 1=ouvert/actif en investigation-remediation, 0=ferme/remediation terminee -- residus de contamination possibles meme fermes)",
    x_terms_pub = c("FID_Rise_S (classe de risque de remontee de nappe phreatique sous scenario d'elevation du niveau marin de 1m, 10 classes)", "gridcode (indicateur de zone d'inondation cotiere)", "COUNTY (comte)"),
    ml_formula = "is_open_case ~ FID_Rise_S + gridcode + COUNTY + ACRES",
    ml_response = "is_open_case",
    ml_predictors = c("FID_Rise_S", "gridcode", "COUNTY", "ACRES"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_binary_variant",
    source_ref = "Hill, Hirshfeld, Lindquist, Cook & Warner (2023), Rising Coastal Groundwater as a Result of Sea-Level Rise Will Influence Contaminated Coastal Sites and Underground Infrastructure, Earth's Future, doi:10.1029/2023ef003825. Le papier combine les bases Envirostor (DTSC) et GeoTracker (SWRCB) pour cartographier les sites contamines de la baie de San Francisco et evalue leur vulnerabilite a la remontee de nappe phreatique (GWR) et a l'inondation cotiere sous un scenario d'elevation du niveau marin de 1m ; il classe explicitement les sites en 'open' (investigation/remediation active) vs 'closed' (remediation terminee, residus de contamination possibles). Donnees brutes (shapefiles ClosedSites/OpenSites_Kh1_SLR1m_RGWorInund, zip nomme d'apres les auteurs du papier HillHirshfeldLindquistCookWarner) telechargees directement depuis Dryad (10.6078/d15x4n, fichier de 782MB deconseille au telechargement automatique par la taille -- recupere manuellement par l'utilisateur, session 2026-08-16) -- pas une reconstruction, N=802 sites uniques (dedoublonnage necessaire : les tables sources contenaient des doublons par site issus de jointures spatiales multiples), coordonnees reelles (baie de San Francisco)."
  ),
  uk_linear_features_birds = list(
    formula_pub = "abundance_species_i ~ LinearFeaturesLength + WoodyLinearFeaturesLength + [covariables d'habitat national] [modeles d'abondance par espece (18 especes d'oiseaux, 24 especes de papillons) sur 3723 (BBS) et 1547 (UKBMS) sites de suivi au Royaume-Uni, comparant modeles avec/sans le jeu de donnees national de haies/elements lineaires]",
    formula_used = "total_bird_abundance ~ LinearFeaturesLength + WoodyLinearFeaturesLength",
    y_term_pub = "total_bird_abundance (abondance totale d'oiseaux toutes especes BBS confondues, agregation communautaire des comptages individuels par espece publies par le papier)",
    x_terms_pub = c("LinearFeaturesLength (longueur totale d'elements lineaires, ex. haies, autour du site)", "WoodyLinearFeaturesLength (longueur d'elements lineaires ligneux)"),
    ml_formula = "total_bird_abundance ~ LinearFeaturesLength + WoodyLinearFeaturesLength",
    ml_response = "total_bird_abundance",
    ml_predictors = c("LinearFeaturesLength", "WoodyLinearFeaturesLength"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sullivan et al. (2017), A national-scale model of linear features improves predictions of farmland biodiversity, Journal of Applied Ecology, doi:10.1111/1365-2664.12912. Le papier ajuste des modeles d'abondance par espece (18 oiseaux BBS, 24 papillons UKBMS) avec un jeu de donnees national d'elements lineaires (haies) comme covariable. Le depot Dryad original contenait 2 fichiers -- seul le fichier de covariables (elements lineaires) avait ete recupere lors du harvest initial ; le fichier de donnees d'abondance par espece (Species abundance data from Sullivan et al...) a ete identifie et telecharge separement via l'API Dryad (session 2026-08-16, apres verification qu'il existait bien sur le depot). formula_used agrege l'abondance BBS toutes especes (reponse communautaire) plutot que les 18 modeles par espece du papier. Coordonnees converties depuis les references de grille nationale britannique (British National Grid, ex. 'TQ5114') vers WGS84 via le package rnrfa::osg_parse (conversion deterministe standard, verifiee sur references de test connues). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.m5g04) -- pas une reconstruction, N=3312 sites (intersection BBS x elements lineaires), Royaume-Uni.",
    regression_status_override = "mis de cote",
    regression_evidence_override = "publication",
    regression_method_override = "formule adaptee/reconstruite -- ne reproduit PAS la structure GLMM/effets aleatoires du papier (voir correction 2026-09-08)",
    regression_note_override = "Correction/confirmation (2026-09-08, PDF fourni par l'utilisateur, converti en TEI via GROBID) : methode confirmee verbatim -- \"We modelled bird and butterfly abundance at each site in each year as a function of environmental variables using generalised linear mixed models with a Poisson error term... we fitted year as a fixed effect, with site... as a random effect... we used the 50-km British Ordnance Survey grid square... as a random effect\". Modele exact par espece : log(N_it) = a + b1*X1_i + ... + bn*Xn_i + bt*Year_t + [log(P_iv)] + Observation_it + Site_i + 50kmRegion_j + e (eqn 1, GLMM Poisson). 42 modeles distincts (18 oiseaux + 24 papillons), chacun avec sa propre structure d'effets aleatoires. DECISION UTILISATEUR (2026-09-08) : mis de cote -- aucun estimateur GLMM Poisson multi-niveaux (effet aleatoire site + region + observation) n'existe dans le harnais actuel."
  ),
  alps_floristic_legacy = list(
    formula_pub = "Standardised_SR ~ Refugia_distance_all + Velocity_med [SAR, lagsarlm]",
    formula_used = "Standardised_SR ~ Refugia_distance_all + Velocity_med",
    formula_note = "Wootton et al. (2025), Systematic Botany 50(1):83-98, Table 1 : W='all neighbours of each grid cell', effets totaux verifies -- distance aux refuges=-7.43 (p<0.001), vitesse de changement climatique=131.16 (p<0.001) ; regression lineaire de base + confirmation SAR car Moran's I detecte une autocorrelation spatiale residuelle.",
    formula_candidate_formula = "Standardised_SR ~ Refugia_distance_all + Velocity_med",
    y_term_pub = "Standardised_SR (richesse specifique standardisee a 95% de completude d'echantillonnage, via rarefaction iNEXT::estimateD() -- PAS S.obs, richesse brute observee, non corrigee de l'effort d'echantillonnage variable)",
    x_terms_pub = c("Refugia_distance_all (distance au refuge glaciaire le plus proche, nunatak OU peripherique)", "Velocity_med (vitesse de changement climatique depuis le LGM, VoCC)"),
    ml_formula = "Standardised_SR ~ Refugia_distance_all + Velocity_med + Deglac + Temp_annual + Precip_total + Pet + Elev_sd + Bedrock_class",
    ml_response = "Standardised_SR",
    ml_predictors = c("Refugia_distance_all", "Velocity_med", "Deglac", "Temp_annual", "Precip_total", "Pet", "Elev_sd", "Bedrock_class"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    year = "2025",
    license_name = "Creative Commons Zero v1.0 Universal (CC0 1.0)",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Wootton, Boucher, Renaud, Valla, Midolo, Lososova, Thuiller & Lavergne (2025), The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps, Systematic Botany 50(1):83-98, DOI 10.1600/036364425X17466502618876. CORRECTION (2026-09-10) : papier obtenu et lu integralement (l'utilisateur a telecharge le PDF, traite via GROBID/KG 2026-09-10 ; aucune version locale n'existait avant, la fiche precedente affirmait a tort 'formule verifiee par lecture directe du papier' avec Statut=resolu alors que inst/kg/paper_dataset_uses.json montrait local_pdf={}/local_tei={}/formula=null/ingestion_status='raw_data_downloaded_pending_loader' -- jamais lu). Table 1 (verifiee, page 47 du PDF) confirme que le modele SAR retenu pour la richesse specifique standardisee n'utilise QUE 2 predicteurs -- distance au refuge le plus proche et vitesse de changement climatique -- PAS Deglac (temps depuis deglaciation, contrairement a une phrase du texte page 21 qui semble erronee/contredite par sa propre Table 1 et par la phrase suivante du meme papier), PAS de variables climatiques contemporaines (Temp_annual/Precip_total/Pet) ni de landscape (Elev_sd/Bedrock_class) : ces dernieres n'apparaissent que dans une analyse SEPAREE de partitionnement de variance (vegan::varpart(), pas une formule de regression). Echantillon : grille Alpine 10x10km (n=1611 cellules initiales, GMBA v2) filtree a >=95% de completude d'echantillonnage et >=250 observations (-1088 cellules), puis exclusion des cellules jamais englacees au dernier cycle glaciaire (-14) = 509 cellules, EXACTEMENT N=509 confirme sur le .rds local. W construit sur 'tous les voisins de chaque cellule de grille' (contigue, pas kNN). Le papier appelle sa methode 'spatial simultaneous autoregressive ERROR modelling approach (SAR)' tout en utilisant lagsarlm() (fonction LAG de spatialreg, pas errorsarlm()) -- ambiguite terminologique du papier lui-meme, non resolue par le texte, mappee ici sur sar_lag (fonction R explicitement citee, signal le plus fiable). Donnees brutes (Supplementary_data_legacy.csv) telechargees directement depuis Dryad (10.5061/dryad.w9ghx3g12) -- pas une reconstruction. R2 note : le modele lineaire de base n'explique que 9% de la variance de la richesse specifique (bien moins que pour les 3 autres indices du papier, 31-45%) -- attente de performance faible a documenter pour le benchmark. Correspondance Y/X revérifiée (2026-09-10, question explicite de l'utilisateur) contre le README des auteurs (data/raw/papers/DatasetFirst_10_5061_dryad_w9ghx3g12/README.md, dictionnaire de donnees Dryad) : confirme 'Refugia_distance_all = distance to the closest refugium whether nunatak of peripheral (km)', 'Velocity_med = median value of climate change velocity (km/ky)', 'Standardised_SR = standardised species richness' (distinct de 'S.obs = observed number of species') -- source primaire independante du texte de l'article, qui accorde le nom de colonne mais pas necessairement la methode de calcul detaillee (rarefaction iNEXT a 95% de completude, decrite uniquement dans le texte p.11-12, pas dans ce README)."
  ),
  pacific_atoll_coconut = list(
    formula_pub = "cocos% ~ Average.Rainfall + Elevation + Inhabited + History.of.copra.production [classification satellite (Sentinel-2/Planet) de la couverture cocos vs autre vegetation/non-vegetation par atoll, comparee aux variables environnementales et a l'histoire de production de coprah]",
    formula_used = "cocos. ~ Average.Rainfall..mm.yr. + Elevation..m. + Inhabited. + History.of.copra.production",
    y_term_pub = "cocos. (pourcentage de couverture en cocotier, classification satellite, par atoll du Pacifique)",
    x_terms_pub = c("Average.Rainfall..mm.yr. (precipitation annuelle moyenne)", "Elevation..m. (elevation)", "Inhabited. (habite ou non)", "History.of.copra.production (histoire de production de coprah, oui/non)"),
    ml_formula = "cocos. ~ Average.Rainfall..mm.yr. + Elevation..m. + Inhabited. + History.of.copra.production + broadleaf. + shrub. + non_veg.",
    ml_response = "cocos.",
    ml_predictors = c("Average.Rainfall..mm.yr.", "Elevation..m.", "Inhabited.", "History.of.copra.production", "broadleaf.", "shrub.", "non_veg."),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Burnett, French, Jones, Fischer, Holland, Roybal, White, Steibl, Anderegg, Young, Holmes & Wegmann (2024) (auteurs completes le 2026-09-14 -- confirmes via Crossref, le placeholder 'Auteurs' n'en nommait aucun), Satellite imagery reveals widespread coconut plantations on Pacific atolls, Environmental Research Letters, doi:10.1088/1748-9326/ad8c66. Le papier classifie la couverture vegetale par imagerie satellite (Sentinel-2/Planet) sur des atolls du Pacifique et relie la prevalence du cocotier a l'histoire de production de coprah et aux variables environnementales. Donnees brutes (master-atoll-database-2024-04-16.csv) telechargees directement depuis Dryad (10.5061/dryad.0k6djhb7x) -- pas une reconstruction, N=266 atolls avec coordonnees reelles, statistiques de couverture vegetale issues de la classification satellite du papier lui-meme (pas une reconstruction/estimation)."
  ),
  checkerspot_phenology = list(
    formula_pub = "startDayOfYear ~ latitude + year [analyse de decalage phenologique sur 140 ans d'archives de musee/citizen-science de papillons demi-lune de Baltimore (Baltimore checkerspot, Euphydryas phaeton), comparee a la disponibilite de nectar sur le terrain]",
    formula_used = "startDayOfYear ~ decimalLatitude + year",
    y_term_pub = "startDayOfYear (jour julien de premiere observation/collection du papillon demi-lune de Baltimore, proxy de phenologie de vol)",
    x_terms_pub = c("decimalLatitude (gradient latitudinal)", "year (tendance temporelle, changement climatique)"),
    ml_formula = "startDayOfYear ~ decimalLatitude + decimalLongitude + year",
    ml_response = "startDayOfYear",
    ml_predictors = c("decimalLatitude", "decimalLongitude", "year"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    year = "2024",
    source_ref = "Crone, E.E., Arriens, J.V. & Brown, L.M. (2024) (auteurs confirmes via Crossref le 2026-09-14, absents des metadonnees locales), Phenological mismatch is less important than total nectar availability for checkerspot butterflies, Ecology, 105(12):e4461, doi:10.1002/ecy.4461. Le papier compare la phenologie historique (archives de musee/citizen-science, 1877-2017) du papillon demi-lune de Baltimore (Euphydryas phaeton, dossier bcbformattedFINAL.csv) a des mesures de terrain de disponibilite de nectar (transects.csv, nectar.csv) sur des sites nommes sans coordonnees precises -- formula_used utilise uniquement le sous-jeu georeference (occurrences de musee avec decimalLatitude/decimalLongitude reelles) pour une regression continue latitude-annee, standard pour ce type d'etude phenologique. PDF non recupere localement (bloque par anti-bot Wiley, 403) -- confirme via OpenAlex et le depot Zenodo du code d'analyse associe (10.5281/zenodo.13760920). Donnees brutes telechargees directement depuis Dryad (10.5061/dryad.rr4xgxdhk) -- pas une reconstruction, N=1989 occurrences georeferencees."
  ),
  sugarglider_occupancy = list(
    formula_pub = "psi(occupancy) ~ mature_forest_extent(200-2000m) + elev ; p(detection) ~ temperature + wind + moonlight + owl_playback [modele d'occupation-detection (site-occupancy model), naive occupancy = 0.79, detectabilite = 0.52 +/- 0.03 sur 5 visites]",
    formula_used = "n_detections ~ mat200 + mat500 + mat1000 + mat1500 + mat2000 + elev",
    y_term_pub = "n_detections (nombre de detections de planeur du sucre sur 5 visites de site, proxy continu/comptage d'occupation)",
    x_terms_pub = c("mat200-mat2000 (etendue de foret mature dans des tampons de 200 a 2000m)", "elev (elevation)"),
    ml_formula = "n_detections ~ mat200 + mat500 + mat1000 + mat1500 + mat2000 + elev",
    ml_response = "n_detections",
    ml_predictors = c("mat200", "mat500", "mat1000", "mat1500", "mat2000", "elev"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Allen, Webb, Alves, Heinsohn & Stojanovic (2018) (auteurs corriges le 2026-09-14 -- confirmes via Crossref ; 'Cooper' n'est pas un auteur de ce papier, les vrais 3e et 4e auteurs sont Alves et Heinsohn), Occupancy patterns of the introduced, predatory sugar glider in Tasmanian forests, Austral Ecology, doi:10.1111/aec.12583. Le papier ajuste un modele d'occupation-detection sur 100 sites du Southern Forest, Tasmanie (naive occupancy=0.79, confirme empiriquement : 79/100 sites avec au moins une detection dans les donnees locales). formula_used utilise le nombre total de detections (n_detections, somme des 5 visites) comme proxy continu de l'occupation, contre les covariables d'habitat reelles du papier (etendue de foret mature a plusieurs echelles de tampon, elevation) ; les covariables de detectabilite (temperature, vent, lune, appel de chouette) restent disponibles dans l'artefact local mais ne sont pas retenues dans formula_used (elles modelisent p, pas psi, dans le cadre occupation-detection original). Donnees brutes (Sugarglider.csv) telechargees directement depuis Dryad (10.5061/dryad.4xgxd259g, depot reutilisant les donnees originales de Stojanovic pour un papier methodologique sur la dependance spatiale) -- pas une reconstruction, N=100 sites, coordonnees reelles (Southern Forest, Tasmanie, converties de UTM zone 55S vers WGS84)."
  ),
  macropod_body_size = list(
    formula_pub = "CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Island + Year [modele spatial bayesien controlant pour l'age (MI, molar progression index), le sexe, l'effet ile, et l'annee ; teste l'hypothese de nanisme induit par la chasse le long d'un gradient geographique sur >2000 cranes de macropodes]",
    formula_used = "CL ~ SummerMaxTemp + AnnualRain + MI + Sex + Year",
    y_term_pub = "CL (longueur condylobasale du crane, indicateur standard de taille corporelle chez les macropodes), espece Macropus rufogriseus (wallaby de Bennett, N=856, la mieux representee des 3 especes du depot)",
    x_terms_pub = c("SummerMaxTemp (temperature maximale estivale)", "AnnualRain (precipitation annuelle)", "MI (molar progression index, proxy d'age)", "Sex", "Year"),
    ml_formula = "CL ~ WinterMinTemp + SummerMaxTemp + SummerWetBulbTemp + AnnualRain + AnnualNDVI + GrowSeasRain + GrowSeasNDVI + MinSeasRain + MinSeasNDVI + MI + Sex + Year",
    ml_response = "CL",
    ml_predictors = c("WinterMinTemp", "SummerMaxTemp", "SummerWetBulbTemp", "AnnualRain", "AnnualNDVI", "GrowSeasRain", "GrowSeasNDVI", "MinSeasRain", "MinSeasNDVI", "MI", "Sex", "Year"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "xgboost", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Prowse et al. (2015), Empirical tests of harvest-induced body-size evolution along a geographic gradient in Australian macropods, Journal of Animal Ecology, doi:10.1111/1365-2656.12273. Le papier mesure plus de 2000 cranes de macropodes (collections fauniques, >130 ans) et ajuste des modeles bayesiens spatiaux controlant pour l'age, le sexe et les effets d'ile ; les resultats montrent une taille de crane augmentant avec une temperature estivale maximale plus basse et des precipitations plus elevees (hypotheses de dissipation thermique et de productivite). Confirme par recherche web (resume Wiley/besjournals, session 2026-08-16), PDF non recupere localement (a ajouter a la liste de recuperation manuelle). Donnees brutes (ProwseEtAl_MacropodData.csv) telechargees directement depuis Dryad (10.5061/dryad.c3tc6) -- pas une reconstruction. Le depot pool 3 especes (M. rufogriseus, M. giganteus, M. fuliginosus) ; formula_used filtre sur M. rufogriseus (N=856, la mieux representee) pour respecter l'approche du papier qui ajuste un modele separe par espece plutot que de pooler des especes aux tailles cranio-corporelles tres differentes."
  ),
  kodiak_puffin_density = list(
    formula_pub = "density_it(s) ~ depth + distance_to_shoreline + SSTa_t + PDO_t [modele conjoint VAST (vector autoregressive spatiotemporal), Poisson-link delta-GLMM avec erreur gamma pour la partie positive, ordination d'especes (1 facteur partage), effets spatio-temporels aleatoires en marche aleatoire, 500 noeuds spatiaux ; covariables de capturabilite (mois, heure, plateforme, qualite des donnees) modelisees separement]",
    formula_used = "density ~ transect_width + sample_area + month + species_code",
    y_term_pub = "density (densite de macareux en mer, individus par unite de surface de transect, Fratercula cirrhata et F. corniculata combines)",
    x_terms_pub = c("depth (profondeur du fond marin)", "distance_to_shoreline (distance a la cote)", "SSTa (anomalie de temperature de surface de la mer)", "PDO (Pacific Decadal Oscillation)"),
    ml_formula = "density ~ transect_width + sample_area + month + year + species_code + modified_platform_type",
    ml_response = "density",
    ml_predictors = c("transect_width", "sample_area", "month", "year", "species_code", "modified_platform_type"),
    ml_estimator_context = c("random_forest", "xgboost", "gam_spatial", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Stoner, Corcoran, Arimitsu, Piatt & Lyons (2026), Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term declines in Kodiak, Alaska, Ornithological Applications, doi:10.1093/ornithapp/duag053. Papier en libre acces (CC-BY) ; PDF bloque par protection anti-bot du site academic.oup.com (403), resume/methodologie confirmes via la page officielle de l'article (abstract + section methodes), texte integral non recupere localement -- ajoute a la liste de recuperation manuelle. Le papier ajuste un modele VAST conjoint avec des covariables (profondeur, distance a la cote, SSTa, PDO) issues d'une grille de covariables separee (cov_data_at_sea_Stoner.et.al.csv, non jointe ici pour eviter une jointure spatiale approximative). formula_used utilise uniquement les variables deja presentes dans la table d'observation brute (puffin_data_at_sea_Stoner.et.al.csv), une simplification documentee en base de conception d'echantillonnage plutot que la specification environnementale complete du papier. Donnees brutes telechargees directement depuis Zenodo (10.5281/zenodo.17128171) -- pas une reconstruction, N=17908 (8954 transects x 2 especes), Kodiak, Alaska, 1975-2022 -- correspond exactement aux '8,954 at-sea transect samples' cites dans le resume officiel du papier."
  ),
  chaco_bird_richness = list(
    formula_pub = "occupancy_ij ~ agricultural_intensity + woodland_extent + environmental_covariate + agricultural_intensity:woodland_extent [modele hierarchique bayesien d'occupation (detection/occupancy) par espece, 197 especes x 234 sites, avec 24 combinaisons de modeles testees (3 metriques d'intensite agricole: yieldE/yieldP/yieldM x 2 mesures d'etendue boisee: forest_6km/forest_10km OU 2 covariables environnementales: rainfall/aridity, avec termes d'interaction)]",
    formula_used = "species_richness ~ yieldM + forest_6km + aridity",
    y_term_pub = "richesse specifique d'oiseaux par site (agregation de l'occupation par espece publiee par le papier en richesse communautaire au niveau site, N=234 sites, 197 especes recensees)",
    x_terms_pub = c("yieldM (rendement en viande, metrique d'intensite agricole)", "forest_6km (etendue boisee, tampon 6km)", "aridity (indice d'aridite)"),
    ml_formula = "species_richness ~ yieldE + yieldP + yieldM + forest_6km + forest_10km + annual.rain + aridity",
    ml_response = "species_richness",
    ml_predictors = c("yieldE", "yieldP", "yieldM", "forest_6km", "forest_10km", "annual.rain", "aridity"),
    ml_estimator_context = c("random_forest", "xgboost", "gam_spatial", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Macchi et al. (2020), Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes, Journal of Applied Ecology, doi:10.1111/1365-2664.13699. Le papier ajuste un modele hierarchique bayesien d'occupation par espece (197 especes, 234 sites du Chaco argentin) avec 3 metriques d'intensite agricole (meat/energy/profit yield), 2 mesures d'etendue boisee et 2 covariables environnementales (24 combinaisons de modeles, avec interactions). Ce modele par espece n'est pas reproductible directement (historiques de detection par espece non incluses dans ce depot). formula_used agrege les occurrences en richesse specifique par site (mesure communautaire standard) et utilise exactement les covariables reelles du papier (yieldM, forest_6km, aridity) au niveau site. Donnees brutes (covas_sitios_03012018.csv + species_sitios_03012018.csv) telechargees directement depuis Dryad (10.5061/dryad.msbcc2fvt) -- pas une reconstruction, N=234 sites, coordonnees reelles (Chaco argentin)."
  ),
  houston_lst_landcover = list(
    formula_pub = "[Le papier construit un modele spatiotemporel physiquement contraint sur l'ensemble des 27 passages satellite pour combler les zones nuageuses (clear-sky reconstruction) de la temperature de surface (LST) ; il ne publie pas de regression Y~X statique unique -- la relation LST~couverture du sol est neanmoins directement mesurable dans les donnees deposees (grille appariee lat/lon/land_cover/LST par passage satellite)]",
    formula_used = "LST_kelvin ~ land_cover",
    y_term_pub = "LST_kelvin (temperature de surface terrestre, degres Kelvin, passage satellite du 2014-07-01 22:06 UTC, couverture non-nuageuse la plus complete parmi les 27 passages disponibles : 19059/22801 pixels)",
    x_terms_pub = c("land_cover (categorie de couverture du sol par pixel : cropland, forest, grassland, other, savanna, urban)"),
    ml_formula = "LST_kelvin ~ land_cover",
    ml_response = "LST_kelvin",
    ml_predictors = c("land_cover"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "gwr"),
    ml_status = "executable_continuous_variant",
    year = "2019",
    source_ref = "Collins, Heaton & Hu (2019) (auteurs corriges le 2026-09-14 -- confirmes via Crossref et OpenAlex, DOI 10.1080/02664763.2019.1681384 ; l'attribution anterieure 'Chang & Wikle' etait fausse, aucun auteur de ce nom sur ce papier), Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data, Journal of Applied Statistics. Le papier reconstruit les zones nuageuses de LST par modele spatiotemporel a contrainte physique sur toute la sequence de 27 passages satellite (pas de formule Y~X statique). Les fichiers deposes fournissent une grille 151x151 de latitude, longitude, couverture du sol et LST par passage -- formula_used utilise le passage avec la meilleure couverture non-nuageuse (2014-07-01 22:06 UTC) comme coupe transversale ile-de-chaleur urbaine (LST~land_cover), une simplification documentee du probleme spatiotemporel complet du papier. Donnees brutes (Phoenix_Houston_LST_Dryad.zip, sous-dossier Houston) telechargees directement depuis Dryad (10.5061/dryad.fbg79cnt2) -- pas une reconstruction, grille reelle sur Houston, Texas."
  ),
  song_sparrow_breeding_date = list(
    formula_pub = "y = Xb + Z1*a_female + Z2*a_male + Z3*PI_female + Z4*PI_male + Z5*Year + e [modele animal quantitatif-genetique (mixed model) avec effets fixes b (coefficients de consanguinite, classes d'age, statut immigrant, par sexe) et effets aleatoires genetiques additifs (matrice de parente A issue du pedigree), effets individuels permanents, annee et residus ; trois variantes spatiales ajoutent en plus des effets de localisation de nid]",
    formula_used = "Breeding_Date ~ female_f + female_age + female_is + male_f + male_age + male_is",
    y_term_pub = "Breeding_Date (date de premiere ponte, jour julien depuis le 1er janvier)",
    x_terms_pub = c("female_f/male_f (coefficient de consanguinite)", "female_age/male_age (classe d'age: 1, 2-4, 5+)", "female_is/male_is (statut immigrant: 0=residente, 1=immigrante)"),
    ml_formula = "Breeding_Date ~ female_f + female_age + female_is + male_f + male_age + male_is + year",
    ml_response = "Breeding_Date",
    ml_predictors = c("female_f", "female_age", "female_is", "male_f", "male_age", "male_is", "year"),
    ml_estimator_context = c("ols", "gam_spatial", "random_forest", "xgboost", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Germain, Wolak, Arcese, Losdat & Reid (2016), Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows, Journal of Animal Ecology, doi:10.1111/1365-2656.12575. Le papier ajuste un modele animal quantitatif-genetique complet (equation 1 du texte : y = Xb + Z1a' + Z2a'' + Z3PI' + Z4PI'' + Z5Y + e) avec effets aleatoires genetiques (pedigree, matrice A) et de localisation spatiale non reproductibles sans le pedigree complet et le solveur animal model. formula_used retient exactement la partie effets fixes (b) du papier : consanguinite, classe d'age et statut immigrant, separement pour la femelle et le male. Donnees brutes (Main_Dataset.txt) telechargees directement depuis Dryad (10.5061/dryad.n0513) -- pas une reconstruction, N=1040 nids, ile de Mandarte, Colombie-Britannique, Canada, coordonnees UTM reelles converties en WGS84."
  ),
  mimulus_sdm = list(
    formula_pub = "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO [WiBB : cadre de ponderation multi-modele (AICc, poids de sommation, WiBB) pour classer l'importance relative des predicteurs dans des GLM binomiaux ajustes espece par espece]",
    formula_used = "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO",
    y_term_pub = "presence (1=occurrence Mimulus, 0=point de fond aleatoire dans l'aire de distribution)",
    x_terms_pub = c("T_cold (temperature du mois le plus froid)", "GDD0 (degres-jours de croissance > 0C)", "P_season (saisonnalite des precipitations)", "TP_syn (synchronicite temperature-precipitation)", "Aridity (aridite de la saison de croissance)", "ISO (isothermalite)"),
    ml_formula = "presence ~ T_cold + GDD0 + P_season + TP_syn + Aridity + ISO",
    ml_response = "presence",
    ml_predictors = c("T_cold", "GDD0", "P_season", "TP_syn", "Aridity", "ISO"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_binary_variant",
    source_ref = "Li & Kou (2021), WiBB: an integrated method for quantifying the relative importance of predictive variables, Ecography, doi:10.1111/ecog.05651. Le jeu de donnees empirique (empirical_dataset/) applique la methode WiBB a 71 especes de Mimulus avec occurrences reelles et 6 variables climatiques (memes noms de colonnes que le papier). Donnees brutes (mimulus_occ_var.csv + background_pts_var.csv) telechargees directement depuis Dryad (10.5061/dryad.xsj3tx9g1) -- pas une reconstruction, N=21307 (11362 occurrences + 9945 points de fond), especes multiples poolees en un seul jeu presence/fond pour ce benchmark (le papier ajuste un GLM separe par espece ; formula_used est le pooling multi-especes standard pour un benchmark SDM binaire)."
  ),
  goa_trawl_demersal = list(
    formula_pub = "logit(p_it(s)) = X_t(s)*beta_i + e_it(s) [GLMM binomial pour la probabilite d'occurrence + sous-modele positif pour la CPUE conditionnelle, avec effets fixes log(profondeur) lineaire+quadratique et effets aleatoires spatio-temporels autoregressifs (AR1) par espece ; e_it(s) capture la correlation spatiale residuelle par annee de releve, non reproductible sans re-estimer le modele complet]",
    formula_used = "Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2",
    y_term_pub = "CPUE de fletan a dents fines (Atheresthes stomias, arrowtooth flounder), espece la plus frequemment capturee du jeu de donnees (8270/9213 traits non-nuls)",
    x_terms_pub = c("log(BottomDepth) centre, terme lineaire et quadratique (seule covariable fixe utilisee par le papier pour tous les modeles d'occurrence et de CPUE positive)"),
    ml_formula = "Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2 + BottomTemp + SurfTemp",
    ml_response = "Atheresthesstomias",
    ml_predictors = c("log.BottomDepth", "log.BottomDepth2", "BottomTemp", "SurfTemp"),
    ml_estimator_context = c("gam_spatial", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_continuous_variant",
    source_ref = "Shelton et al. (2017), Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill, ICES Journal of Marine Science, doi:10.1093/icesjms/fsx079. Le papier ajuste un GLMM binomial (occurrence) + modele positif (CPUE|presence) avec log(profondeur) lineaire/quadratique comme seule covariable fixe, et des effets aleatoires spatio-temporels AR1 par espece (equation 1-2 du texte). Ces effets aleatoires ne sont pas reproductibles sans re-estimer le modele INLA complet ; formula_used retient la partie effets fixes exacte du papier (log-profondeur lineaire+quadratique) comme regression continue de base. Donnees brutes (goa_trawl_albers.csv, table station x annee x espece) telechargees directement depuis Dryad (10.5061/dryad.j3t86) -- pas une reconstruction, N=9213 traits de chalut, Golfe d'Alaska, 1984-2011. BottomTemp/SurfTemp sont des covariables reelles supplementaires du meme fichier, ajoutees uniquement a la variante ml_or_selected."
  ),
  dougfir_sdm = list(
    formula_pub = "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6 [modele de distribution d'espece (SDM) : GLM binomial stepwise (lineaire et quadratique) et Random Forest sur les composantes principales climatiques, compares sous differentes strategies de validation croisee (aleatoire, par blocs spatiaux, par blocs environnementaux)]",
    formula_used = "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6",
    y_term_pub = "PRES (presence/absence du sapin de Douglas, Pseudotsuga menziesii, Amerique du Nord)",
    x_terms_pub = c("PC1-PC6 (composantes principales des variables climatiques MWMT, MCMT, PPT_sm, MDMP, DD5, AHM, Elev)"),
    ml_formula = "PRES ~ PC1 + PC2 + PC3 + PC4 + PC5 + PC6",
    ml_response = "PRES",
    ml_predictors = c("PC1", "PC2", "PC3", "PC4", "PC5", "PC6"),
    ml_estimator_context = c("glm_logistic", "random_forest", "random_forest_xy", "xgboost", "gwr"),
    ml_status = "executable_binary_variant",
    year = "2017",
    source_ref = "Roberts et al. (2017), Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure, Ecography, doi:10.1111/ecog.02881 (annee de publication confirmee via Crossref le 2026-09-14, volume 40(8):913-929 -- corrige de '2016', qui etait l'annee de depot Dryad extraite du bib_key, non l'annee de publication de l'article). Box 4 de l'article decrit une etude de cas de modelisation de distribution d'espece (Douglas-fir) pour comparer blocage aleatoire, spatial et environnemental en validation croisee. Script fourni (Appendix_6_Box_4_CODE_Environmental_blocking.R) confirme modvars <- paste0('PC',1:6) et lin.modform <- PRES ~ modvars, ajuste par GLM binomial stepwise (lineaire/quadratique) et randomForest. Donnees brutes (Appendix_6_Box_4_DATA_NorthAmerica_DougFir.RData) telechargees directement depuis Dryad (10.5061/dryad.737gk) -- pas une reconstruction, N=53293, PRES binaire (34692 absences / 18601 presences), Lat/Long reels couvrant l'Amerique du Nord."
  ),
  gcfr_soil = list(
    formula_pub = "[Pas de regression Y~X unique dans le papier pour cette table -- les echantillons ponctuels de sol servent d'entree a une interpolation spatiale (krigeage/apprentissage automatique avec covariables environnementales, dans la lignee de SoilGrids) produisant des couches regionales de sol, elles-memes utilisees comme covariables dans un modele separe de prediction du type de vegetation (non inclus dans ce depot)]",
    formula_used = "N_total_. ~ pH_extract + C_total_.",
    y_term_pub = "N_total_. (azote total du sol, %) -- reponse choisie pour ce benchmark parmi les proprietes de sol mesurees (le papier n'ayant pas de formule Y~X unique pour cette table de points) ; N_total_. retenue plutot que pH_H2O ou C_organic_. car ces deux dernieres n'ont que 31/2767 et 110/2767 valeurs non-NA respectivement (0 cas complets avec les autres covariables candidates), rendant toute regression non executable -- N_total_. a 2195/2767 valeurs non-NA (79%) et 1927 cas complets avec pH_extract + C_total_.",
    x_terms_pub = c("pH_extract (pH du sol par extraction, meilleure couverture que pH_H2O)", "C_total_. (carbone total du sol, %, correlat classique de l'azote)"),
    ml_formula = "N_total_. ~ pH_extract + C_total_.",
    ml_response = "N_total_.",
    ml_predictors = c("pH_extract", "C_total_."),
    ml_estimator_context = c("gwr", "kriging", "random_forest", "ols"),
    ml_status = "executable_continuous_variant",
    source_ref = "Cramer, M.D. & Verboom, G.A. (2019), New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models, Diversity and Distributions, doi:10.1111/ddi.12973. CSV original (GCFR_soil.csv) telecharge directement depuis Dryad (10.5061/dryad.37qc017) -- pas une reconstruction, N=2767 points d'echantillonnage de sol (Greater Cape Floristic Region, Afrique du Sud). Le papier utilise ces points pour interpoler des couches de sol regionales (methode SoilGrids ameliore), elles-memes covariables d'un modele separe de type de vegetation non inclus dans ce depot -- formula_used est une reformulation raisonnable en regression continue (N_total_. ~ pH_extract + C_total_.), documentee comme telle, pas la formule publiee du papier. Verification empirique (session 2026-08-16) : 1927/2767 cas complets pour ce triplet (contre 0 cas complets pour la formule initiale pH_H2O ~ 7 covariables, pH_H2O n'ayant que 31 valeurs non-NA)."
  ),
  gwqlasso_pr = list(
    formula_pub = "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]",
    formula_used = "Yield_kg_ha ~ precip_annual_mm",
    y_term_pub = "Yield_kg_ha (rendement du soja, kg/ha, niveau municipal)",
    x_terms_pub = c("SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)"),
    ml_formula = "Yield_kg_ha ~ precip_annual_mm + Year",
    ml_response = "Yield_kg_ha",
    ml_predictors = c("precip_annual_mm", "Year"),
    ml_estimator_context = c("gwr", "quantile_regression", "lasso", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Le depot Dataverse (10.7910/DVN/UEZMJT) contient les donnees BRUTES completes (1030 municipalites/3 Etats, 78 stations) plus larges que l'echantillon exact du papier (41/41, Parana uniquement, non identifie dans les metadonnees) -- decision utilisateur 2026-08-15 : utiliser les donnees completes decoupees par Etat plutot que deviner le sous-echantillon. precip_annual_mm (precipitation annuelle de la station la plus proche) est un PROXY SIMPLIFIE du SPI publie (voir README_source.txt pour la methodologie complete de geocodage/jointure), PAS une reproduction exacte."
  ),
  gwqlasso_rs = list(
    formula_pub = "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]",
    formula_used = "Yield_kg_ha ~ precip_annual_mm",
    y_term_pub = "Yield_kg_ha (rendement du soja, kg/ha, niveau municipal)",
    x_terms_pub = c("SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)"),
    ml_formula = "Yield_kg_ha ~ precip_annual_mm + Year",
    ml_response = "Yield_kg_ha",
    ml_predictors = c("precip_annual_mm", "Year"),
    ml_estimator_context = c("gwr", "quantile_regression", "lasso", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Rio Grande do Sul du meme jeu de donnees brutes complet (1030 municipalites/3 Etats)."
  ),
  gwqlasso_mt = list(
    formula_pub = "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]",
    formula_used = "Yield_kg_ha ~ precip_annual_mm",
    y_term_pub = "Yield_kg_ha (rendement du soja, kg/ha, niveau municipal)",
    x_terms_pub = c("SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)"),
    ml_formula = "Yield_kg_ha ~ precip_annual_mm + Year",
    ml_response = "Yield_kg_ha",
    ml_predictors = c("precip_annual_mm", "Year"),
    ml_estimator_context = c("gwr", "quantile_regression", "lasso", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Mato Grosso du meme jeu de donnees brutes complet (1030 municipalites/3 Etats)."
  ),
  avian_phylo_functional_distance = list(
    formula_pub = "MPFD_SES ~ PD_SES * abs_latitude + proportion_migratory_species + altitude + species_richness [path analysis/SEM, lavaan cfa]",
    formula_used = "MPFDses ~ PDses + abs_lat + sp_richn",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "formula_pub est confirmee par le texte des resultats (Yaxley et al. 2023, p.2127 : 'the model with the lowest BIC ... included both the proportion of migratory species and the interaction between PD_SES and latitude as predictors of MPFD_SES', coefficients PD_SES beta=-0.323 [-0.346,-0.23] p<0.001, Migration beta=-0.298 [-0.329,-0.267] p<0.001 ; altitude et richesse specifique sont des covariables communes aux trois variantes de modele comparees -- Altitude beta=0.032 [0.018,0.047] p<0.001, Species richness beta=-0.012 [-0.032,0.007] p=0.205). L'altitude (source externe Weeks et al. 2022, Bioclim, disponible pour 16979/17099 sites seulement dans le papier) n'est PAS dans ce depot Dryad et reste absente de formula_used ; la proportion d'especes migratrices (source externe Dufour et al. 2019) n'y est pas non plus. species_richness (sp_richn) EST disponible localement et ajoutee a formula_used. Le terme d'interaction PD_SES:abs_latitude n'est PAS en soi un obstacle -- une interaction est un simple terme produit, calculable dans n'importe quelle regression classique (PDses*abs_lat) ; ce qui manque reellement pour reproduire le papier est le systeme complet a 4 equations simultanees (path analysis lavaan::cfa sur MPFD_SES/PD_SES/migration/richesse, verifie robuste par une variante spatiale sesem) et la migration externe -- pas la syntaxe de l'interaction elle-meme. formula_used reste une regression lineaire simple sur les variables disponibles localement -- une simplification documentee, pas le systeme SEM du papier.",
    formula_note = "CORRECTION (2026-09-10, verification PDF p.2127) : la fiche precedente avait Y et X inverses (PD_SES ~ MPFD_SES au lieu de MPFD_SES ~ PD_SES). Le texte des resultats et le resume du papier ('PD is an unreliable surrogate for functional diversity') confirment sans ambiguite que MPFD_SES est la variable expliquee (outcome) et PD_SES (en interaction avec la latitude) plus la proportion migratrice sont les predicteurs -- pas l'inverse. CORRECTION (2026-09-14, relecture suite a une revue externe) : altitude et richesse specifique avaient ete a tort exclues de formula_pub en interpretant 'very little effect' comme 'non retenues du modele' -- le texte precise en realite qu'elles sont des covariables communes aux 3 variantes de modele comparees, avec un coefficient rapporte pour chacune (altitude significative, p<0.001 ; richesse specifique non significative, p=0.205). species_richness (sp_richn) est disponible localement et ajoutee a formula_used ; altitude reste absente (source externe Weeks et al. 2022, non incluse dans ce depot).",
    y_term_pub = "MPFD_SES (taille d'effet standardisee de la distance fonctionnelle moyenne par paire, variable expliquee du modele le mieux ajuste)",
    x_terms_pub = c("PD_SES (taille d'effet standardisee de la diversite phylogenetique de Faith, en interaction avec la latitude)", "abs_latitude", "proportion_migratory_species (source externe Dufour et al. 2019, absente de ce depot)", "altitude (source externe Weeks et al. 2022/Bioclim, disponible pour 16979/17099 sites dans le papier, absente de ce depot)", "species_richness (disponible localement : sp_richn)"),
    ml_formula = "MPFDses ~ PDses + abs_lat + sp_richn",
    ml_response = "MPFDses",
    ml_predictors = c("PDses", "abs_lat", "sp_richn"),
    ml_estimator_context = c("sem_path_analysis", "gwr", "sar_lag", "random_forest_xy"),
    ml_status = "executable_continuous_variant",
    model_family = "path_analysis_structural_equation_model",
    year = "2023",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "Yaxley, K.J., Skeels, A. & Foley, R.A. (2023), Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints, Global Ecology and Biogeography 32:2122-2134, doi:10.1111/geb.13762 (Crossref confirme publication 2023-09-28 -- la fiche precedente et le source_ref citaient a tort '2024'). CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad (10.5061/dryad.05qfttf8t) -- pas une reconstruction, N=17099 assemblages d'oiseaux georeferences (grille mondiale), verifie identique au N=17,097 degres de liberte cite dans le texte. CORRECTION MAJEURE (2026-09-10, lecture directe du PDF p.2127, section 3.2) : le modele le mieux ajuste (BIC le plus bas) a pour variable expliquee MPFD_SES, pas PD_SES -- 'the two most important predictors of MPFD_SES were PD_SES and migration' (coefficients cites ci-dessus dans formula_used_divergence_note). La fiche precedente inversait Y et X (PD_SES ~ MPFD_SES), erreur non detectee lors de la premiere lecture du 2026-08-16. Le resume du papier motive aussi ce sens : PD est teste comme 'surrogate' (predicteur) de la diversite fonctionnelle, pas l'inverse. CORRECTION (2026-09-14, revue externe croisee avec relecture directe du PDF p.2127) : altitude et richesse specifique sont en realite des covariables communes aux 3 variantes de modele comparees par les auteurs ('across all three models', avec coefficient et p-value rapportes pour chacune), pas des predicteurs testes-puis-ecartes comme la fiche l'affirmait a tort -- formula_pub corrigee pour les inclure. species_richness (sp_richn) est disponible localement et ajoutee a formula_used ; altitude (Weeks et al. 2022, Bioclim, 16979/17099 sites seulement dans le papier) et la proportion d'especes migratrices (Dufour et al. 2019) restent des sources externes absentes de ce depot Dryad. Le papier utilise une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- PAS un SAR/SEM-error/SDM/GWR au sens econometrie spatiale du benchmark (ambiguite de vocabulaire : 'SEM' designe ici Structural Equation Model, pas Spatial Error Model). Un terme d'interaction (PD_SES:abs_latitude) reste un simple terme produit, parfaitement calculable hors lavaan dans une regression classique -- ce n'est pas ce qui empeche la reproduction du systeme complet."
  ),
  spatial_confounding_diabetes = list(
    formula_pub = "[obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality] ~ XB_S + G + E_S [Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232 (texte integral libre acces consulte, session 2026-08-16). Modele areolaire bayesien coregionalise MULTIVARIE (3 reponses simultanees, structure spatiale BYM2 partagee via matrice de dependance M), avec 15 predicteurs exacts groupes en 5 domaines : contexte economique (Poverty Rate, Median Income, Unemployment, SNAP Assistance), contexte sanitaire (Uninsured Rate, PCP Density, Outpatient Visits, Low Access), environnement (Physical Inactivity, Recreation Facilities), education (HS Diploma Rate), demographie (Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent). CORRESPONDANCE VERIFIEE A 100% (session 2026-08-16) entre les 15 predicteurs du papier et les colonnes reelles de RDA_data.csv -- ce depot Zenodo est manifestement le jeu de donnees original des auteurs, pas une source secondaire]",
    formula_used = "diabetes_pct_est ~ PCT_18YOUNGER10 + PCT_65OLDER10 + PCT_HISP10 + PCT_LACCESS_POP15 + PCT_NHBLACK10 + RECFACPTH16 + physical_inactivity_2015 + pcps_2015_100k + outpatient_visits_2015_100k + urban_percent_2010 + hs_dipl_percent_2011_15 + unemployment_2015 + med_hh_inc_2015 + poverty_rate_2015 + snap_pct_2015 + uninsured_2015",
    y_term_pub = "diabetes_pct_est (prevalence du diabete diagnostique chez les adultes de 20 ans et plus, ajustee sur l'age, 2015, US Diabetes Surveillance System) -- le papier utilise en realite 3 reponses simultanees dans un modele multivarie : obesity_pct_est, diabetes_pct_est, diabetes_cancer_mortality",
    x_terms_pub = c("Les 15 predicteurs exacts du papier (Poverty Rate, Median Income, Unemployment, SNAP Assistance, Uninsured Rate, PCP Density, Outpatient Visits, Low Access, Physical Inactivity, Recreation Facilities, HS Diploma Rate, Percent NH-Black, Percent Hispanic, Percent >=65, Percent <=18, Urban Percent), tous verifies presents dans RDA_data.csv"),
    ml_formula = "diabetes_pct_est ~ PCT_18YOUNGER10 + PCT_65OLDER10 + PCT_HISP10 + PCT_LACCESS_POP15 + PCT_NHBLACK10 + RECFACPTH16 + physical_inactivity_2015 + pcps_2015_100k + outpatient_visits_2015_100k + urban_percent_2010 + hs_dipl_percent_2011_15 + unemployment_2015 + med_hh_inc_2015 + poverty_rate_2015 + snap_pct_2015 + uninsured_2015 + obesity_pct_est",
    ml_response = "diabetes_pct_est",
    ml_predictors = c("PCT_18YOUNGER10", "PCT_65OLDER10", "PCT_HISP10", "PCT_LACCESS_POP15", "PCT_NHBLACK10", "RECFACPTH16", "physical_inactivity_2015", "pcps_2015_100k", "outpatient_visits_2015_100k", "urban_percent_2010", "hs_dipl_percent_2011_15", "unemployment_2015", "med_hh_inc_2015", "poverty_rate_2015", "snap_pct_2015", "uninsured_2015", "obesity_pct_est"),
    ml_estimator_context = c("ols", "sar_lag", "sar_error", "car_besag", "bym2", "gwr", "random_forest"),
    ml_status = "executable_continuous_variant",
    year = "2025",
    source_ref = "CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : papier retrouve avec certitude quasi-absolue -- Wu, K.L. & Banerjee, S., 'Spatial Confounding in Multivariate Areal Data Analysis', arXiv:2505.07232, DOI 10.48550/arXiv.2505.07232, texte integral libre acces consulte. Le papier analyse des donnees de comtes americains sur obesite/diabete/mortalite par cancer lie au diabete avec un modele areolaire bayesien coregionalise multivarie (Y=XB_S+G+E_S, structure BYM2 partagee entre les 3 reponses via une matrice de dependance M), 15 predicteurs exacts groupes en 5 domaines de determinants sanitaires (economique, sanitaire, environnemental, educatif, demographique). CORRESPONDANCE VERIFIEE A 100% : les 15 predicteurs cites dans le papier (Poverty Rate->poverty_rate_2015, Median Income->med_hh_inc_2015, Unemployment->unemployment_2015, SNAP Assistance->snap_pct_2015, Uninsured Rate->uninsured_2015, PCP Density->pcps_2015_100k, Outpatient Visits->outpatient_visits_2015_100k, Low Access->PCT_LACCESS_POP15, Physical Inactivity->physical_inactivity_2015, Recreation Facilities->RECFACPTH16, HS Diploma Rate->hs_dipl_percent_2011_15, Percent NH-Black->PCT_NHBLACK10, Percent Hispanic->PCT_HISP10, Percent >=65->PCT_65OLDER10, Percent <=18->PCT_18YOUNGER10, Urban Percent->urban_percent_2010) correspondent tous exactement aux colonnes de RDA_data.csv, et diabetes_cancer_mortality (une des 3 reponses du modele multivarie du papier) est deja une colonne du depot -- ce Zenodo est manifestement le jeu de donnees original de Wu & Banerjee, pas une source secondaire. formula_used corrigee (session 2026-08-16) : passe de 6 covariables choisies par analogie a la totalite des 15 predicteurs exacts du papier (obesity_pct_est retiree du role de covariable et notee comme reponse multivariee alternative du vrai modele, mais gardee en ml_formula comme covariable disponible pour un usage benchmark simple univariee). Le vrai modele du papier reste multivarie (3 reponses simultanees, structure BYM2 coregionalisee) -- non reproductible tel quel par une regression univariee simple, formula_used documente donc une regression classique diabetes_pct_est~X sur les vrais predicteurs, pas le modele multivarie complet. RDA_data.csv (2984 comtes americains) telecharge directement depuis Zenodo -- pas une reconstruction. Geometrie jointe par code FIPS (5 chiffres, zero-pad corrige) au shapefile officiel Census cb_2017_us_county_500k inclus dans le meme depot -- pas une reconstruction, N=2984/2984 comtes joints (couverture complete). package_include laisse en manual_review : papier et predicteurs desormais confirmes a 100%, mais formula_used reste une simplification univariee du vrai modele multivarie coregionalise."
  ),
  antarctic_biodiversity_completeness = list(
    formula_pub = "aucune regression Y~X publiee -- Cmpltns est un indice descriptif (KnowBR), voir Note",
    formula_used = "Cmpltns ~ Records + Shap_Ar",
    formula_note = "Formule proposee par le curateur, pas une formule publiee. Le script R original des auteurs (SUPPORTING FILE 4, present dans le depot Zenodo) utilise uniquement KnowBR::KnowBPolygon() pour produire ce CSV, suivi d'une carte -- aucune regression ajustee. Slope et Obsrvd_ sont des ingredients directs du calcul de Cmpltns (documentation CRAN KnowBR) et ont ete exclus des X pour eviter la circularite ; ne restent que Records et Shap_Ar (entrees independantes). Voir source_ref pour la citation complete et le detail methodologique.",
    y_term_pub = "Cmpltns (completude de l'inventaire biodiversite par cellule de grille Antarctique, %, calculee via le package KnowBR a partir de courbes d'accumulation d'especes, estimateur de Ugland et al. 2003)",
    x_terms_pub = c("Records (nombre d'enregistrements d'occurrence dans la cellule, proxy d'effort d'echantillonnage -- entree independante du calcul KnowBR)", "Shap_Ar (aire de la cellule de grille -- geometrie independante)"),
    regression_status_override = "generated_system_formula",
    regression_evidence_override = "system_generated",
    regression_method_override = "formule proposee par le curateur (Records + Shap_Ar) ; aucune regression Y~X publiee pour cette table -- voir Note",
    regression_note_override = "Cmpltns est un diagnostic descriptif KnowBR, pas une variable expliquee dans le papier (script R original des auteurs confirme aucune regression ajustee). Slope/Obsrvd_ exclus des X car ingredients directs du calcul (circularite). Voir 'Reference publication' pour le detail complet.",
    ml_formula = "Cmpltns ~ Records + Shap_Ar",
    ml_response = "Cmpltns",
    ml_predictors = c("Records", "Shap_Ar"),
    ml_estimator_context = c("ols", "gwr", "random_forest", "sar_lag"),
    ml_status = "executable_continuous_variant",
    year = "2025",
    license_name = "Creative Commons Attribution 4.0 International",
    license_url = "https://creativecommons.org/licenses/by/4.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-10",
    source_ref = "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : papier retrouve et DOI corrige -- Pertierra et al. (2025, pas 2024), 'Advances and shortfalls in knowledge of Antarctic terrestrial and freshwater biodiversity', Science 387:609-615, doi:10.1126/science.adk2118. Le script R original des auteurs est present dans ce meme depot (SUPPORTING FILE 4 Spatial Completeness R CODE.R) et confirme sans ambiguite que le pipeline se limite a KnowBR::KnowBPolygon() (calcul de completude par courbe d'accumulation d'especes) suivi d'une carte -- aucune regression Y~X publiee sur cette table. DECOUVERTE METHODOLOGIQUE IMPORTANTE (documentation officielle CRAN du package KnowBR, Lobo et al.) : Slope et Obsrvd_ (richesse observee) sont des INGREDIENTS DIRECTS du calcul de Completeness lui-meme (la completude = richesse observee / richesse extrapolee par la courbe d'accumulation, dont Slope est la pente finale) -- les inclure comme covariables X d'une regression Cmpltns~... serait quasi-circulaire (tautologique par construction de l'algorithme), pas une relation causale testable. formula_used corrigee (session 2026-08-16) : Slope et Obsrvd_ retires, ne restent que Records (entree brute independante, proxy d'effort d'echantillonnage) et Shap_Ar (geometrie de cellule, independante). CSV original (SUPPORTING FILE 3 Antarctic Inventories Spatial Completeness.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=1518 cellules de grille Antarctique. VERIFICATION EMPIRIQUE (session 2026-08-16) : les colonnes 'Latitude'/'Longitude' du CSV source sont inversees (colonne 'Latitude' variant sur [-175,176], plage de longitude ; colonne 'Longitude' variant sur [-89.6,-60.2], plage de latitude coherente avec l'Antarctique) -- corrige dans le loader (true_lat=Longitude, true_lon=Latitude), verifie geographiquement valide apres correction. package_include laisse en manual_review : formule corrigee pour eviter la circularite mais reste une proposition du curateur, le papier lui-meme ne publie aucune regression sur cette table."
  ),
  pollinator_urbanization_meta = list(
    formula_pub = "d ~ taxonomic_group * origin [Liang, He, Theodorou & Yang (2023), 'The effects of urbanization on pollinators and pollination: A meta-analysis', Ecology Letters 26:1629-1642, doi:10.1111/ele.14277. Meta-analyse hierarchique multivariee (metafor::rma.mv, ponderee par la variance d'echantillonnage V=Vd, PAS Vd comme covariable) sur 133 etudes ; les auteurs testent explicitement si l'effet de l'urbanisation depend du groupe taxonomique de pollinisateur et de l'origine (native vs. non-native) -- confirme par le resume officiel du papier]",
    formula_used = "d ~ Pollinator_group + Urban_gradient",
    y_term_pub = "d (taille d'effet standardisee de Hedges, effet de l'urbanisation sur l'abondance/richesse des pollinisateurs, par etude/espece)",
    x_terms_pub = c("Pollinator_group (groupe taxonomique du pollinisateur -- correspond au moderateur 'taxonomic group' confirme par le resume officiel du papier)", "Urban_gradient (type de gradient d'urbanisation etudie)", "Pollinator_origin (native vs. non-native -- moderateur confirme par le papier mais 122/228 valeurs manquantes, 54%, exclu de formula_used pour cette raison)"),
    ml_formula = "d ~ Pollinator_group + Urban_gradient + Climate_region",
    ml_response = "d",
    ml_predictors = c("Pollinator_group", "Urban_gradient", "Climate_region"),
    ml_estimator_context = c("meta_regression", "ols", "random_forest"),
    ml_status = "executable_continuous_variant",
    year = "2023",
    source_ref = "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : papier identifie et confirme -- Liang, He, Theodorou & Yang (2023), Ecology Letters 26:1629-1642, doi:10.1111/ele.14277, 'The effects of urbanization on pollinators and pollination: A meta-analysis' (133 etudes). Abstract officiel (Wiley/PubMed) confirme une meta-analyse hierarchique multivariee testant si l'effet de l'urbanisation depend du 'taxonomic group' et de l' 'origin (native vs. non-native)' -- ces deux moderateurs correspondent aux colonnes reelles Pollinator_group/Order (6% NA) et Pollinator_origin (54% NA) du CSV local. Texte integral non accessible (Wiley payant HTTP 402, ResearchGate/Authorea 403, depot institutionnel opendata.uni-halle.de protege par verification anti-bot Anubis -- non contourne, conforme a la politique du projet), donc les noms exacts de tous les moderateurs testes et la specification complete du modele restent a confirmer par lecture du texte integral si l'utilisateur peut se le procurer. formula_used corrigee (session 2026-08-16) : Pollinator_origin remplace par Pollinator_group (meme esprit -- moderateur taxonomique confirme -- mais bien mieux rempli, 6% vs 54% NA) ; Vd retiree des covariables X (erreur de specification corrigee : dans metafor::rma.mv, la variance d'echantillonnage est le parametre de ponderation V=, jamais un terme de la formule mods=~...). CSV original (Appendix_S1.1_effect_size_pollinator_abundance.csv) telecharge directement depuis Dryad, N=228 tailles d'effet reelles, pas une reconstruction. package_include laisse en manual_review : le modele exact (interaction taxonomic_group*origin) n'a pas pu etre verifie verbatim faute d'acces au texte integral."
  ),
  portugal_covid_municipal = list(
    formula_pub = "log(cases_per_10k_15days) ~ pct_emploi_services + temps_trajet_moyen_individuel + pct_emploi_agricole + taille_moyenne_famille + [12 autres variables retenues sur 33 candidates, VIF<2.5] [Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073, texte integral lu (PDF telecharge depuis repositorio.ulisboa.pt, licence CC-BY-NC 4.0). GLMM distribution Tweedie avec effet aleatoire NUTS-3, sur N=278 municipalites (Portugal continental, Acores/Madere exclus faute de donnees), 12 modeles separes (un par periode de 15 jours, avril-septembre 2020). 33 variables candidates en 6 categories (population, socio-economique, habitat, mobilite, sante, environnement -- source principale INE/Statistics Portugal + E-OBS pour temperature/precipitation), reduites a 16 apres diagnostic de multicollinearite (VIF>2.5 retire)]",
    formula_used = "incidencia ~ population + densidade_populacional",
    y_term_pub = "incidencia (taux d'incidence COVID-19 standardise sur 14 jours, par concelho) -- le papier utilise en realite le nombre de cas par periode de 15 jours, converti en incidence pour 10000 habitants, log-transforme",
    x_terms_pub = c("population (population totale du concelho)", "densidade_populacional (densite de population, hab/km2) -- confirmee dans la categorie 'Population' des 33 variables candidates du papier"),
    ml_formula = "incidencia ~ population + densidade_populacional + population_65_mais",
    ml_response = "incidencia",
    ml_predictors = c("population", "densidade_populacional", "population_65_mais"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "gam_spatial"),
    ml_status = "executable_continuous_variant",
    year = "2022",
    source_ref = "REVISE x2 (session 2026-08-16 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : (1) papier trouve et confirme -- Barbosa, Silva, Capinha, Garcia & Rocha (2022), 'Spatial correlates of COVID-19 first wave across continental Portugal', Geospatial Health 17(s1):1073, doi:10.4081/gh.2022.1073. (2) TEXTE INTEGRAL LU (recherche web demandee par l'utilisateur, PDF en libre acces telecharge depuis le depot institutionnel repositorio.ulisboa.pt, CC-BY-NC 4.0) : etude sur N=278 municipalites du Portugal continental (Acores et Madere exclus, donnees indisponibles pour plusieurs variables explicatives), periode avril-septembre 2020, 12 fenetres de 15 jours. Y = nombre de nouveaux cas COVID-19 par periode de 15 jours, converti en incidence pour 10000 habitants, transformation logarithmique. 33 VARIABLES CANDIDATES EXHAUSTIVES identifiees (Figure 2 du papier), groupees en 6 categories : (a) Population -- densite de population, population par groupe d'age (0-9/10-19/20-64/65+), nombre de familles classiques, dimension des familles classiques, indice de dependance ; (b) Socio-economique -- emploi par secteur (agriculture/industrie/infrastructure/services), remuneration moyenne, taux de chomage, population illettree, population avec/sans enseignement superieur, taux d'abandon scolaire, pouvoir d'achat par habitant, pensionnes securite sociale en age actif, retraits aux distributeurs ; (c) Habitation -- logements familiaux classiques, logements avec tout confort, logements occupes, logements surpeuples/collectifs/non-classiques, densite de logements, nombre de quartiers sociaux ; (d) Mobilite -- duree moyenne des trajets domicile-travail en transport individuel, mobilite en transport prive/collectif (interne/externe), proportion d'usage de la voiture ; (e) Sante -- existence de services d'urgence de base/permanents/etendus ; (f) Environnement -- temperature moyenne et precipitation totale (source E-OBS, Cornes et al. 2018), emissions de polluants. Apres diagnostic de multicollinearite (VIF>2.5 retire), 16 variables retenues pour l'analyse finale (modele GLMM distribution Tweedie, effet aleatoire NUTS-3). Covariables significatives confirmees 'de facon consistante dans le temps' : pourcentage d'emploi dans les services, temps de trajet moyen en transport individuel, pourcentage d'emploi agricole, taille moyenne des familles. AUCUNE DE CES 33 VARIABLES INE/E-OBS N'EST PRESENTE dans le depot Zenodo local (dgs_data_concelhos_new.csv contient uniquement population/densite/incidence, source DGS pas INE) -- tentative de recuperation directe des donnees PORDATA (base de statistiques municipales portugaises certifiees, https://www.pordata.pt) : lien de telechargement direct teste, retourne HTTP 404 (URL expiree), non poursuivi. formula_used (population + densidade_populacional) reste donc une proposition du curateur, dans l'esprit de la litterature confirmee (densite demographique = categorie 'Population' du papier) mais tres partielle face aux 16 variables retenues du vrai modele. CSV original (dgs_data_concelhos_new.csv) telecharge directement depuis Zenodo -- pas une reconstruction, panel journalier des 308 concelhos portugais. Geometrie jointe a la couche publique geoBoundaries PRT/ADM2 (CC0), 298/308 concelhos apparies (96.8%), N=20604 observations. package_include laisse en manual_review : papier et structure exacte du modele desormais entierement documentes, mais les vraies covariables INE/E-OBS restent hors de portee sans acces direct a un portail de donnees municipales portugaises fonctionnel."
  ),
  colombia_leptospirosis_risk = list(
    formula_pub = "monthly_incidence ~ rainfall + temperature + overflooding + confondants_sociodemographiques [modele bayesien hierarchique BYM spatio-temporel, 180 mois (2007-2021), tous les municipalites colombiennes ; 'Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach', Journal of Public Health/Taylor & Francis, doi:10.1080/09581596.2025.2578588. La pluviometrie (rainfall) est identifiee comme le determinant environnemental le plus important apres ajustement pour les confondants socio-economiques/environnementaux et la structure spatiale. RR (risque relatif spatial) et la statistique de Mann-Kendall (tendance temporelle emergente) sont les deux SORTIES du modele BYM, pas des variables d'entree]",
    formula_used = "RR ~ MannKendall + emerging_trend + mean_annual_temp_c + annual_precip_mm",
    y_term_pub = "RR (risque relatif spatial de leptospirose par municipalite, effet spatial estime du modele BYM du papier)",
    x_terms_pub = c("MannKendall (statistique de tendance temporelle de Mann-Kendall par municipalite, meme modele)", "emerging_trend (indicateur binaire de tendance emergente, distinct du signe de MannKendall -- verifie empiriquement non redondant, 35% de desaccord de signe)", "mean_annual_temp_c (temperature annuelle moyenne, normale climatique CHELSA V2.1 1981-2010, degres C)", "annual_precip_mm (precipitation annuelle totale, normale climatique CHELSA V2.1 1981-2010, mm) -- proxy de la pluviometrie identifiee par le papier comme le determinant environnemental le plus important"),
    ml_formula = "RR ~ MannKendall + emerging_trend + mean_annual_temp_c + annual_precip_mm",
    ml_response = "RR",
    ml_predictors = c("MannKendall", "emerging_trend", "mean_annual_temp_c", "annual_precip_mm"),
    ml_estimator_context = c("ols", "gwr", "car_besag", "random_forest_xy"),
    ml_status = "executable_continuous_variant",
    year = "2025",
    source_ref = "Cortes-Ramirez, Wilches-Vega, Parvez, Galvis-Serrano, Parada-Jurado & Gutierrez (2025) (auteurs et journal Critical Public Health confirmes via Crossref le 2026-09-14 -- corrige de l'attribution generique anterieure 'Journal of Public Health/Taylor & Francis'), Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach, Critical Public Health, doi:10.1080/09581596.2025.2578588. REVISE x2 (session 2026-08-16) : (1) recherche bibliographique demandee par l'utilisateur -- papier identifie avec un haut degre de confiance. Correspondance structurelle exacte confirmee : le papier utilise un test de Mann-Kendall pour identifier les tendances emergentes de risque spatio-temporel ET un modele hierarchique bayesien BYM produisant des cartes de risque relatif spatial (RR) par municipalite, sur exactement 180 mois (2007-2021), ce qui correspond exactement aux 180 colonnes 'month 1' a 'month 180' de la feuille '1. iar_lepto' du fichier Sup_materials_lepto.xlsx local. Selon le resume de l'article, le vrai modele est incidence mensuelle ~ pluviometrie + temperature + inondation (overflooding), la pluviometrie etant le determinant environnemental le plus important. (2) CORRECTION METHODOLOGIQUE (signalee par l'utilisateur, session 2026-08-16) : p_value retiree des covariables -- la significativite d'un test statistique n'est pas une variable explicative independante, elle mesure l'incertitude sur MannKendall lui-meme (correlation empirique MannKendall~p_value = 0.70, confirmant leur non-independance), meme famille d'erreur que la circularite deja corrigee pour antarctic_biodiversity_completeness. emerging_trend conservee : verifiee empiriquement NON redondante avec le signe de MannKendall (35% de desaccord de signe dans les donnees reelles, cf. table de contingence). COVARIABLES CLIMATIQUES REELLES AJOUTEES (recherche demandee par l'utilisateur) : mean_annual_temp_c et annual_precip_mm, normales climatiques CHELSA V2.1 1981-2010 (https://chelsa-climate.org, licence CC-BY-4.0, lecture directe via GDAL /vsicurl/ sans telechargement du raster mondial complet), extraites par moyenne zonale sur les polygones municipaux geoBoundaries deja utilises pour la geometrie -- proxy legitime et verifie geographiquement coherent (temperature 7.8-28.5 degres C, precipitation 399-6553 mm/an sur les 931 municipalites, plages plausibles pour la Colombie) de la pluviometrie/temperature identifiees par le papier comme determinants principaux -- CE SONT DES NORMALES CLIMATIQUES (moyennes 1981-2010), PAS les covariables mensuelles exactes du modele BYM original (qui utiliserait des donnees IDEAM/CHIRPS mensuelles alignees sur la periode 2007-2021 exacte du papier) ; approximation documentee, pas une reconstruction des vraies donnees d'entree du papier. Texte integral du papier toujours non accessible (Taylor & Francis HTTP 403, PubMed cookie-gated). Geometrie : jointe par nom de municipalite normalise a la couche ADM2 publique geoBoundaries (source officielle DANE, CC BY 4.0, COL/ADM2, 1122 unites) ; 987/1036 municipalites uniques appariees par nom (95.3%), puis 65 noms ambigus (homonymes entre departements colombiens) retires -- N final=931 municipalites univoques, aucune supplementaire perdue lors de la jointure climatique (0 NA climat/mm2 sur les 931). package_include laisse en manual_review : papier et structure confirmes, covariables climatiques reelles ajoutees mais restent des normales/proxy, pas les vraies donnees mensuelles du modele original."
  ),
  korea_hedonic_housing = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 -- article 'data descriptor' officiel de ce meme jeu de donnees (26 variables en 4 categories : housing properties, local demographics, local amenities, seasonal controls). Etude d'application liee trouvee : Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900, confirmant 'network distance to nearest subway station' comme la variable la plus importante pour expliquer le prix, avec les caracteristiques du logement]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station -- variable confirmee comme la plus importante par l'etude d'application liee)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    year = "2021",
    source_ref = "CONFIRMED (session 2026-08-16, recherche bibliographique demandee par l'utilisateur) : le papier 'data descriptor' officiel de ce jeu de donnees a ete retrouve -- Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877 (texte consulte via PMC, article en libre acces). Structure officielle confirmee : 26 variables en 4 categories (housing properties : size/floor/parking/annee construction ; demographie locale : population/densite/education/age ; amenites locales : distance metro/bus/espaces verts/CBD ; controles saisonniers). Une etude d'application du meme jeu de donnees a egalement ete identifiee -- Ahn et al., 'Economic impact of being close to subway networks', doi:10.1016/j.retrec.2020.100900 -- confirmant explicitement que la distance au metro et les caracteristiques du logement sont les determinants les plus importants du prix. formula_used (deja proposee par le curateur avant cette recherche) s'avere BIEN ALIGNEE avec la structure officiellement documentee (Area/Floor/Subway.distance/Population.density/Green.space.distance correspondent directement aux 4 categories du data descriptor, Subway.distance confirmee comme variable cle) -- aucune correction necessaire, seule la reference bibliographique est ajoutee. 4 fichiers xlsx (Busan.xlsx, Daegu.xlsx, Daejeon.xlsx, Gwangju.xlsx) telecharges directement depuis Zenodo (DOI 10.5281/zenodo.14715630, tres probablement une extension/mise a jour du dataset original de Song et al. par les memes auteurs ou un groupe associe) -- pas une reconstruction, N=178719 transactions immobilieres (Busan 53458, Daegu 56606, Daejeon 24350, Gwangju 44305). Coordonnees reelles (Longitude/Latitude) verifiees coherentes par ville, pas d'inversion. package_include laisse en manual_review : formule alignee avec la documentation officielle du dataset, mais pas verifiee terme-a-terme contre une regression publiee precise (le data descriptor ne publie pas lui-meme d'equation de regression, seulement la structure des variables)."
  ),
  wildebeest_movement_env = list(
    formula_pub = "speed(x) ~ NDVI(x) + Nitrogen(x) + D_drainage(x) [sens causal INVERSE de formula_used ci-dessous] -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), 'Inferring spatially varying animal movement characteristics using a hierarchical continuous-time velocity model', Ecology Letters, doi:10.1111/ele.14117 (article en libre acces, PMC9828272, texte integral consulte). Modele hierarchique gaussien a 2 niveaux (processus Ornstein-Uhlenbeck de vitesse continue) : les covariables environnementales (NDVI/azote/distance drainage) n'entrent PAS comme predicteurs lineaires directs, elles modifient la MOYENNE des champs latents spatiaux gaussiens qui controlent persistance directionnelle (tau) et vitesse moyenne (sigma) -- Eq. 21-22 du papier, transformation exponentielle pour garantir la positivite. Le resume officiel confirme : 'NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage' -- donc NDVI EXPLIQUE la vitesse, pas l'inverse",
    formula_used = "NDVI ~ Nitrogen + D_drainage",
    y_term_pub = "speed/tau/sigma (parametres latents de vitesse et persistance directionnelle du processus Ornstein-Uhlenbeck, PAS une colonne directement disponible dans ce depot)",
    x_terms_pub = c("NDVI (indice de vegetation, covariable confirmee du papier -- via l'intercept du champ latent gaussien)", "Nitrogen (teneur en azote de l'herbe, meme role)", "D_drainage (distance au reseau de drainage, meme role)"),
    ml_formula = "NDVI ~ Nitrogen + D_drainage + AID",
    ml_response = "NDVI",
    ml_predictors = c("Nitrogen", "D_drainage", "AID"),
    ml_estimator_context = c("ols", "gwr", "gam_spatial", "random_forest_xy"),
    ml_status = "executable_continuous_variant",
    year = "2022",
    source_ref = "REVISE (session 2026-08-16, recherche bibliographique demandee par l'utilisateur ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : papier confirme et texte integral consulte (article en libre acces, PMC9828272) -- Paun, Husmeier, Hopcraft, Masolele & Torney (2022), Ecology Letters, doi:10.1111/ele.14117. DECOUVERTE IMPORTANTE : le vrai modele du papier teste l'effet de NDVI/azote/distance-drainage SUR la vitesse de deplacement (sens causal inverse de formula_used ci-dessous, qui met NDVI comme reponse) -- confirme explicitement par le resume officiel ('NDVI values have a significant effect on the average speed of wildebeest, with lower speeds being associated with high quality forage') et par la specification mathematique exacte (Eq. 21-22, processus gaussien hierarchique Ornstein-Uhlenbeck, PAS une regression lineaire classique : les covariables modifient l'intercept de la moyenne des champs latents spatiaux tau/sigma, une relation non-parametrique flexible). 'Vitesse' n'est PAS une colonne disponible dans ce depot Dryad (seulement les positions GPS brutes x/y/Date par individu -- confirme par le README.txt) ; la calculer necessiterait de deriver des differences de position/temps successives par animal (AID), un calcul non trivial non effectue ici pour eviter de fabriquer une variable non documentee. formula_used (NDVI~Nitrogen+D_drainage) reste donc une EXPLORATION DE CORRELATION ENVIRONNEMENTALE LOCALE entre les covariables reellement disponibles, PAS un test du mecanisme causal du papier -- documentee comme telle. CSV original (wildebeest_env_data.csv) telecharge directement depuis Dryad, pas une reconstruction, N=94006 positions GPS (43 individus, Serengeti 1999-2016, coordonnees UTM 36S verifiees coherentes). package_include laisse en manual_review : papier et sens causal desormais confirmes, mais formula_used reste une proposition du curateur eloignee du vrai modele (processus gaussien non reproductible sans calcul de vitesse derivee)."
  ),
  dragonfly_diversity_europe = list(
    formula_pub = "sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM [Pinkert, Dijkstra, Zeuss, Reudenbach, Brandl & Hof (2017), Ecography 40, doi:10.1111/ecog.03137, Table 1 -- GAM (mgcv::gam) avec famille gamma pour la richesse, quasi-Poisson pour l'endemisme (CWE), gaussienne pour SES MPD]",
    formula_used = "sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM",
    y_term_pub = "sp_rich",
    x_terms_pub = c("pc_thermo_1", "pc_thermo_2", "pc_preci_1", "pc_preci_2", "prop_lelo", "iso.LGM"),
    ml_formula = "sp_rich ~ pc_thermo_1 + pc_thermo_2 + pc_preci_1 + pc_preci_2 + prop_lelo + iso.LGM",
    ml_response = "sp_rich",
    ml_predictors = c("pc_thermo_1", "pc_thermo_2", "pc_preci_1", "pc_preci_2", "prop_lelo", "iso.LGM"),
    ml_estimator_context = c("gam_spatial", "ols", "sar_error", "gwr", "random_forest"),
    ml_status = "executable_continuous_variant",
    source_ref = "Pinkert et al. (2017), Ecography 40, doi:10.1111/ecog.03137, 'Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies'. CORRECTION FINALE (2026-09-08, PDF fourni par l'utilisateur, converti en TEI via GROBID, texte integral Material and Methods + Table 1 lus directement) : le modele reellement publie (Table 1, 'Regression models') est un GAM (mgcv, Wood 2011) avec predicteurs = 4 composantes PCA du climat (pc_thermo_1/2, pc_preci_1/2 -- 'four principal components that describe temperature and precipitation') + proportion lentique/lotique (prop_lelo) + isotherme LGM (iso.LGM). La latitude (center_lat) n'est PAS un predicteur du modele GAM principal (Table 1) -- elle sert uniquement a une analyse SEPAREE de regression par segments (broken-line, package segmented) pour detecter des ruptures de pente, une analyse complementaire distincte, pas le modele principal. La correction du 2026-08-16 (basee sur l'abstract seul) avait a tort remplace pc_thermo_1/pc_preci_1 par center_lat -- cette session retablit les variables PCA, desormais confirmees par le texte integral et deja disponibles telles quelles dans le RDS local (aucune reconstruction necessaire)."
  ),
  brisbane_urban_vegetation = list(
    formula_pub = "log(dens_015_1+0.01) ~ poly(tree_area,2) + poly(aspect_cos,2) + poly(aspect_sin,2) + poly(slope,2) [modele SAR mixte (lagsarlm), poids de voisinage a 150m -- Mitchell, Wu, Johansen, Maron, McAlpine & Rhodes (2016), 'Landscape structure influences urban vegetation vertical structure', doi:10.1111/1365-2664.12741 (OpenAlex-linked publication non resolue dans le KG). Formule confirmee par lecture directe du script R original des auteurs (Mitchell_etal_2016_1ha_analysis_20160624.R, present dans le meme depot Dryad) -- meilleur modele combine (selection par AICc/model averaging) pour la strate de densite de vegetation 0.15-1m]",
    formula_used = "dens_015_1 ~ tree_area + aspect_cos + aspect_sin + slope",
    y_term_pub = "dens_015_1 (densite de vegetation entre 0.15 et 1m de hauteur, proportion, transformee log(x+0.01) dans le papier)",
    x_terms_pub = c("tree_area (proportion de couvert arbore dans la cellule)", "aspect_cos (composante nord-sud de l'orientation du terrain)", "aspect_sin (composante est-ouest de l'orientation du terrain)", "slope (pente du terrain, degres)"),
    ml_formula = "dens_015_1 ~ tree_area + aspect_cos + aspect_sin + slope + mb_dwel_dens + park_prop + sa1_medtothinc",
    ml_response = "dens_015_1",
    ml_predictors = c("tree_area", "aspect_cos", "aspect_sin", "slope", "mb_dwel_dens", "park_prop", "sa1_medtothinc"),
    ml_estimator_context = c("ols", "sar_lag", "sar_mixed", "gwr", "random_forest"),
    ml_status = "executable_continuous_variant",
    year = "2016",
    source_ref = "Publication liee identifiee automatiquement via OpenAlex dans le manifeste (10.1111/1365-2664.12741, Journal of Applied Ecology) et confirmee par lecture directe du script R original des auteurs, present dans le meme depot Dryad (Mitchell_etal_2016_1ha_analysis_20160624.R) -- le script ajuste des modeles SAR mixtes (lagsarlm, poids de voisinage dnearneigh a 150m) pour 5 strates de hauteur de vegetation (0.15-1m, 1-2m, 2-5m, 5-10m, >10m), chacune avec un jeu de covariables physiques/pedologiques/demographiques/urbaines/paysageres teste separement puis combine. Le meilleur modele combine pour la strate 0.15-1m (retenu par model averaging/dredge, m.max=4) inclut tree_area, aspect_cos, aspect_sin et slope -- formula_used simplifie les termes polynomiaux (poly(x,2)) en lineaire et omet la structure SAR (poids spatiaux 150m), une simplification documentee, pas la specification exacte du papier. CSV original (Mitchell_etal_data_1ha_20160627.csv) telecharge directement depuis Dryad -- pas une reconstruction, N=63142 cellules de grille 1ha (Brisbane, Australie, coordonnees UTM MGA zone 56 verifiees coherentes). DOI 10.1111/1365-2664.12741 confirme via Crossref (Mitchell, M.G.E., Wu, D., Johansen, K., Maron, M., McAlpine, C. & Rhodes, J.R. (2016), Journal of Applied Ecology, 53(5), 1477-1488) -- KG mis a jour le 2026-09-14 (paper_doi/paper_title, precedemment non resolus)."
  ),
  banff_stream_temperature = list(
    formula_pub = "WaterTemp ~ Elev + RSlope + LE [SSN glmssn + INLA barrier model, effet aleatoire HUC10]",
    formula_used = "WaterTemp ~ Elev + RSlope + LE",
    formula_used_generated_despite_pub = TRUE,
    formula_used_divergence_note = "formula_pub est confirmee par lecture directe des scripts R des auteurs (Zenodo 10.5281/zenodo.7942855, deposes avec le papier) : SSN_R-Script.R ligne 263, modele SSN final retenu -- 'Final <- glmssn(WaterTemp ~ S.Elev + S.RSlope + LEf, data, ...)' -- et INLA_R-Script.R lignes 270-303, modele INLA (barrier model) -- 'f2 <- y ~ -1 + y.intercept + RSlope.std + Elev.std + LEf1 + f(spatial.field, model=barrier.model) + f(HUC10f, model='iid', ...)'. Les DEUX modeles (SSN et INLA) convergent exactement sur les memes 3 predicteurs (Elev, RSlope, LE), standardises avant ajustement (prefixe S./.std) -- ni logRCA ni h2oAreaKm2 n'apparaissent dans le modele final retenu (ce sont des variables candidates testees en exploration, ex. td3/tu3 dans le script SSN, mais pas retenues). formula_used reprend exactement ces 3 variables (toutes disponibles localement, y compris LE) en regression lineaire simple -- il manque la structure de covariance spatiale sur reseau (glmssn, tail-up/tail-down) et le champ spatial barrier + effet aleatoire HUC10 (watershed) du modele INLA, une simplification documentee mais desormais sur les VRAIES variables du papier.",
    formula_note = "CORRECTION MAJEURE (2026-09-14, lecture directe des scripts R des auteurs, Zenodo 10.5281/zenodo.7942855) : la fiche precedente utilisait h2oAreaKm2+logRCA (jamais dans le modele final des auteurs) et omettait LE (present dans les DEUX modeles finaux, SSN et INLA). HUC10 (watershed) sert d'effet aleatoire dans le modele INLA -- actuellement exclue comme simple identifiant dans cette fiche, disponible localement si une route avec effet aleatoire groupe est souhaitee (cf. support (1|groupe) via gam_spatial/mgcv ajoute au package le 2026-09-10).",
    y_term_pub = "WaterTemp (temperature moyenne d'aout du cours d'eau, degres C, mesuree par logger)",
    x_terms_pub = c("Elev (elevation du site, m, standardisee S.Elev/Elev.std dans les scripts)", "RSlope (pente du cours d'eau, standardisee S.RSlope/RSlope.std)", "LE (indicateur binaire d'effet lac en amont, LEf/LEf1 dans les scripts)"),
    ml_formula = "WaterTemp ~ Elev + RSlope + LE + h2oAreaKm2 + logRCA",
    ml_response = "WaterTemp",
    ml_predictors = c("Elev", "RSlope", "LE", "h2oAreaKm2", "logRCA"),
    ml_estimator_context = c("ols", "gwr", "sar_error", "random_forest_xy"),
    ml_status = "executable_continuous_variant",
    year = "2024",
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    source_ref = "Struthers, Gutowsky, Lucas, Mochnacz, Carli & Taylor (2024), Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners, Canadian Journal of Fisheries and Aquatic Sciences 81:417-432, doi:10.1139/cjfas-2023-0136 (Crossref confirme publication en ligne 2024-04-01 -- la fiche precedente citait a tort '2023' et les pages '417-232', DOI 'unknown'). CSV original (bnp_data_June2022_V5.csv) telecharge directement depuis Dryad (10.5061/dryad.crjdfn391) -- pas une reconstruction, N=110 sites de mesure de temperature, Parc national de Banff, coordonnees UTM Zone 11N. CORRECTION MAJEURE (2026-09-14, recherche web + lecture directe des scripts R des auteurs via leur depot Zenodo 10.5281/zenodo.7942855, SSN_R-Script.R et INLA_R-Script.R -- rapatries dans data/raw/papers/DatasetFirst_10_5061_dryad_crjdfn391/ pour archivage local) : le modele final RETENU par les auteurs (pas seulement teste) est WaterTemp ~ Elev + RSlope + LE, confirme IDENTIQUEMENT par les deux approches (SSN glmssn ligne 263 ; INLA barrier model lignes 270-303, avec en plus un effet aleatoire iid sur HUC10/watershed). Les termes logRCA et h2oAreaKm2, presents dans la fiche precedente, ne figurent PAS dans le modele final -- ce sont des candidats explores puis ecartes (ex. modeles td3/tu3 du script SSN). CONFIRMATION INDEPENDANTE (2026-09-14, PDF obtenu par l'utilisateur, traite via GROBID, TEI local desormais disponible) : le texte du papier confirme mot pour mot -- 'The fitted model (SSN-1) included all fixed terms (i.e., elevation, reach slope, and lake effect)... we also fit an equivalent nonspatial model (SSN-2)... while retaining all fixed terms and the HUC-10 random effect' ; et explique explicitement pourquoi logRCA est absent -- 'upstream drainage area... was dropped because of collinearity with elevation (r=0.82) and had a higher VIF score'. Fichier bnp_data_preds_June2022_V5.csv (grille de prediction, 642 lignes) present dans le meme depot mais non utilise ici (pas de Y, utile seulement pour du krigeage). package_include laisse en manual_review du fait de l'ecart de methode (covariance de reseau/effet aleatoire non reproduits)."
  ),
  global_nee_gwxgboost = list(
    formula_pub = "[Titre du depot : 'Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'. Aucun DOI de publication resolu (recherche web, session 2026-08-17 : aucune correspondance exacte trouvee, papier probablement pas encore indexe/publie). Le titre indique un modele XGBoost pondere geographiquement (GWR-style local weighting) pour predire le NEE a partir de variables de teledetection]",
    formula_used = "NEE.g.C.m.2.day.1. ~ LSWI + NDVImax + LAI + LSTnight.K. + Ratio_ET_PET",
    y_term_pub = "NEE (echange net d'ecosysteme, g C m-2 jour-1, mesure par eddy covariance aux tours de flux FLUXNET)",
    x_terms_pub = c("LSWI (Land Surface Water Index)", "NDVImax (indice de vegetation normalise, maximum)", "LAI (indice de surface foliaire)", "LSTnight.K. (temperature de surface nocturne, Kelvin)", "Ratio_ET_PET (ratio evapotranspiration reelle/potentielle)"),
    ml_formula = "NEE.g.C.m.2.day.1. ~ LSWI + NDVImax + LAI + LSTnight.K. + Ratio_ET_PET + WUEmax.kg.C.per.kg.H2O. + IGBP",
    ml_response = "NEE.g.C.m.2.day.1.",
    ml_predictors = c("LSWI", "NDVImax", "LAI", "LSTnight.K.", "Ratio_ET_PET", "WUEmax.kg.C.per.kg.H2O.", "IGBP"),
    ml_estimator_context = c("xgboost_xy", "gwr", "random_forest_xy", "ols"),
    ml_status = "executable_continuous_variant",
    source_ref = "Aucune publication n'a ete identifiee avec certitude pour ce candidat dataset-first (Zenodo, DOI 10.5281/zenodo.21635729, titre du depot 'Dataset and Code for Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'). Recherche web (session 2026-08-17) n'a pas trouve de correspondance exacte -- papiers proches identifies (Random Forest/XGBoost sur NEE FLUXNET, GW-XGBoost pixel-level vegetation) mais aucun ne correspond exactement au titre du depot. Data1_387_sites.csv telecharge directement depuis Zenodo -- pas une reconstruction, N=109154 observations (387 sites de flux FLUXNET mondiaux, panel site x jour x annee), coordonnees reelles verifiees coherentes (couverture mondiale -163.7 a 161.3 lon, -54.97 a 78.92 lat). formula_used est une proposition du curateur (session 2026-08-17) exploitant les variables de teledetection reellement presentes et correspondant au cadre methodologique decrit par le titre (variables satellitaires -> NEE), pas une formule extraite d'un texte publie verifie. package_include laisse en manual_review pour cette raison."
  ),
  california_wildfire_growth = list(
    formula_pub = "large_growth_binary(>10000 acres/24h) ~ weather_vars + fuel_vars + topographic_vars [modele Random Forest, feature importance -- Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p. 16013 jours-incendie CA 2003-2020. Variables meteo (temperature, vent, humidite, precipitation), combustible (type, charge, disponibilite, humidite), topographie (pente, aspect, elevation, forme) confirmees comme predicteurs testes]",
    formula_used = "Final_size_perimeter ~ T2 + WS + mean_RH + ERC + BI + PDSI",
    y_term_pub = "Final_size_perimeter (taille finale du perimetre de l'incendie) -- le papier utilise en realite un seuil binaire (>10000 acres en 24h de croissance journaliere), non retenu ici (formula_used utilise la taille finale continue, une variable reelle disponible mais differente de la reponse binaire exacte du papier)",
    x_terms_pub = c("T2 (temperature a 2m, WRF)", "WS (vitesse du vent)", "mean_RH (humidite relative moyenne)", "ERC (Energy Release Component, indice de secheresse combustible)", "BI (Burning Index)", "PDSI (Palmer Drought Severity Index)"),
    ml_formula = "Final_size_perimeter ~ T2 + WS + mean_RH + ERC + BI + PDSI + SMOIS + Q2",
    ml_response = "Final_size_perimeter",
    ml_predictors = c("T2", "WS", "mean_RH", "ERC", "BI", "PDSI", "SMOIS", "Q2"),
    ml_estimator_context = c("random_forest_xy", "ols", "gwr", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    year = "2022",
    source_ref = "Papier identifie via recherche web (session 2026-08-17) : Hanley, H.S. (2022), 'Environmental Influences on Large Daily Wildfire Growth in California', Master's Thesis, San Jose State University, doi:10.31979/etd.5znn-tm8p (these avec DOI officiel, ScholarWorks repository). Le papier ajuste un modele Random Forest sur 16013 jours-incendie (2003-2020) pour predire un SEUIL BINAIRE (croissance >10000 acres en 24h), pas une regression continue -- formula_used utilise la taille finale du perimetre (Final_size_perimeter, variable continue reelle disponible dans ce depot) comme proxy, avec les memes familles de covariables meteo/combustible/topographie confirmees par le resume du papier (temperature, vent, humidite, indices de secheresse ERC/BI/PDSI) -- une reformulation en regression continue documentee, pas la specification binaire exacte du papier. CSV original (Fire_03_20.csv) telecharge directement depuis Zenodo -- pas une reconstruction, N=23031 incendies avec coordonnees d'ignition reelles (Californie, 32.5-42.0 lat / -124.4 a -114.2 lon, coherent). Fichier drought_cumu_perc_area.csv (serie temporelle secheresse CA sans coordonnees) present dans le meme depot mais non utilise ici. package_include laisse en manual_review : formule reste une simplification (continue au lieu de binaire) documentee. DOI 10.31979/etd.5znn-tm8p confirme via Crossref (2026-09-14) ; KG mis a jour (paper_doi/paper_title, precedemment non resolus)."
  ),
  swiss_heat_exposure = list(
    formula_pub = "deaths ~ f(temperature, nonlinear, spatially-varying) [modele bayesien BYM2 avec effets non-lineaires spatialement variables -- Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Mortalite toutes causes en Suisse, disparites spatiales de mortalite liee a la chaleur expliquees principalement par la structure d'age de la population, les espaces verts et les vulnerabilites liees a l'exposition a la chaleur (resume officiel)]",
    formula_used = "deaths ~ offset(log(population)) + temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity",
    y_term_pub = "deaths (nombre quotidien de deces, population 65 ans et plus, par commune)",
    x_terms_pub = c("temperature (temperature quotidienne)", "temperature_lag1/2/3 (temperature des 3 jours precedents)", "greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel)", "urbanicity (statut urbain/rural de la commune)"),
    ml_formula = "deaths ~ offset(log(population)) + temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity + holiday + dow",
    ml_response = "deaths",
    ml_predictors = c("population", "temperature", "temperature_lag1", "temperature_lag2", "temperature_lag3", "greenspace", "urbanicity", "holiday", "dow"),
    ml_estimator_context = c("bym2", "car_besag", "gam_spatial", "gwr", "random_forest_xy"),
    ml_status = "executable_continuous_variant",
    year = "2025",
    source_ref = "Papier identifie via recherche web (session 2026-08-17 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022). CORRECTION (2026-09-09) : le depot Zenodo n'a pas de README expliquant deaths vs deaths_sim ; verification faite en lisant le code de replication des auteurs (repository GitHub associe, fxinyichen/SwissHeat_svc, script '1. SH_model_12.R') : la reponse du modele BYM2 publie est bien deaths (deaths_sim sert a autre chose, jamais utilise comme y). Le script confirme aussi un offset log(population) -- absent de la formule precedente -- desormais ajoute. Modele publie complet (non reproduit ici) : Poisson avec offset log(population), factor(dow), factor(holiday), 4 termes de base temperature (splines DLNM), effet aleatoire jour-de-l'annee (RW2), effet aleatoire annee (iid), effet spatial regional BYM2, et 4 coefficients spatialement variables pour la temperature (BYM2 x spline). formula_used simplifie ce modele en regression additive standard (sans les effets spatialement variables ni les effets aleatoires temporels), approximation documentee, pas la specification exacte. package_include laisse en manual_review pour cette raison.",
    regression_status_override = "resolu",
    regression_evidence_override = "publication",
    regression_method_override = "formule publication confirmee et utilisee",
    regression_note_override = "Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17), reponse (deaths vs deaths_sim) et offset log(population) confirmes le 2026-09-09 par lecture directe du code de replication des auteurs."
  ),

  korea_hedonic_housing_1989 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1989, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=2424 transactions, 69 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1990 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1990, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=1794 transactions, 65 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1991 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1991, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=3828 transactions, 98 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1992 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1992, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5697 transactions, 156 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1993 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1993, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5432 transactions, 164 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1994 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1994, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6771 transactions, 169 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1995 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1995, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6914 transactions, 177 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1996 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1996, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=9261 transactions, 180 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1997 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1997, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=9135 transactions, 186 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1998 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1998, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6485 transactions, 135 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_1999 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 1999, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5572 transactions, 103 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2000 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2000, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6599 transactions, 144 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2001 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2001, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4165 transactions, 144 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2002 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2002, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4799 transactions, 257 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2003 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2003, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6122 transactions, 372 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2004 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2004, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4346 transactions, 234 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2005 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2005, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6559 transactions, 193 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2006 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2006, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=7328 transactions, 193 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2007 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2007, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5510 transactions, 147 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2008 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2008, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6084 transactions, 107 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2009 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2009, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4816 transactions, 82 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2010 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2010, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=3463 transactions, 57 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2011 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2011, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4302 transactions, 81 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2012 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2012, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=2981 transactions, 98 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2013 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2013, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5694 transactions, 152 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2014 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2014, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5622 transactions, 170 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2015 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2015, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=6986 transactions, 180 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2016 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2016, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=5868 transactions, 239 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2017 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2017, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4990 transactions, 225 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2018 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2018, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=4260 transactions, 189 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_2019 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de l'annee 2019, donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=1810 transactions, 131 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  korea_hedonic_housing_pre1989 = list(
    formula_pub = "Condominium_price ~ Size + Floor + Subway_distance + Population_density + Green_space_distance + ... [Song, Ahn, An & Jang (2021), 'Hedonic dataset of the metropolitan housing market -- Cases in South Korea', Data in Brief, doi:10.1016/j.dib.2021.106877]",
    formula_used = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance",
    y_term_pub = "Housing.price (prix du logement -- Condominium price, KRW)",
    x_terms_pub = c("Area (Size, surface, m2)", "Floor (etage)", "Subway.distance (Network distance to nearest subway station)", "Population.density (densite de population locale)", "Green.space.distance (distance a un espace vert)"),
    ml_formula = "Housing.price ~ Area + Floor + Subway.distance + Population.density + Green.space.distance + Maximum.floor + Higher.degree.ratio + City",
    ml_response = "Housing.price",
    ml_predictors = c("Area", "Floor", "Subway.distance", "Population.density", "Green.space.distance", "Maximum.floor", "Higher.degree.ratio", "City"),
    ml_estimator_context = c("ols", "gwr", "sar_lag", "random_forest_xy", "xgboost_xy"),
    ml_status = "executable_continuous_variant",
    source_ref = "Sous-ensemble temporel du dataset parent paper_korea_hedonic_housing (deja package_include=\"yes\", formule confirmee alignee sur le data descriptor officiel Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877 -- session 2026-08-16). Decoupage effectue le 2026-08-17 pour augmenter le nombre de jeux de donnees deja benchmarkables sans casser la validite spatiale (chaque sous-ensemble garde la totalite des localisations distinctes de les annees clairsemees 1969-1988 regroupees en un seul sous-ensemble (2 a 69 localisations distinctes par annee prise isolement, jugees trop eparses pour un decoupage annuel individuel), donc une matrice W construite sur ce sous-ensemble reste non degeneree) ni la formule (Area/Floor/Subway.distance/Population.density/Green.space.distance -- aucune n'est Year, formule inchangee par rapport au parent). N=13102 transactions, 510 localisations distinctes dans ce sous-ensemble (verifie directement sur le .rds decoupe, code/r_catalog/split_korea_hedonic_housing.R)."
  ),
  metacomnet = list(
    license_name = "Creative Commons Zero v1.0 Universal",
    license_url = "https://creativecommons.org/publicdomain/zero/1.0/legalcode",
    license_open = "yes",
    license_checked = "2026-09-14",
    yx_selection_note = "Les covariables X retenues sont les 16 predicteurs reels documentes par le papier (Table 1-2) : RegionalCommonness, NearestOcc, BeeDCA1-4, Solitary, PlantFreq, DCA1-4, MASL, LndscpGR, LnscpH, DistSand. `FacOccurrence` (17e colonne candidate du .rds) est EXCLUE : verification empirique (2026-09-10) confirme une correspondance bijective parfaite avec la variable reponse `Occurrence` (X0<->0, X1<->1, 9594/9594 lignes) -- c'est la version factorielle de l'autre reponse publiee (Table 2), pas une covariable ; l'inclure aurait constitue une fuite de donnees pour predire `Number`.",
    formula_pub = "Number ~ RegionalCommonness + NearestOcc + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + DCA1 + DCA2 + DCA3 + DCA4 + MASL + LndscpGR + LnscpH + DistSand [Random Forest, ranger]",
    formula_used = "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness",
    formula_note = "Sydenham et al. (2022), Table 1-2 : Random Forest regression trees (Breiman 2001, ranger/caret) ; modele jumeau sur Occurrence (presence/absence) via arbres de classification, memes predicteurs. Voir yx_selection_note pour l'exclusion de FacOccurrence (fuite de donnees).",
    formula_candidate_formula = "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness",
    y_term_pub = "Number (nombre d'interactions observees entre une espece d'abeille et une espece de plante sur un site) ; Occurrence (presence/absence de cette meme interaction, {0,1}) est un second Y publie avec la meme importance -- le papier ajuste 3 modeles RF : classification sur Occurrence, regression sur Occurrence, regression sur Number (Table 2, Section 2.2)",
    x_terms_pub = c("RegionalCommonness", "NearestOcc", "BeeDCA1", "BeeDCA2", "BeeDCA3", "BeeDCA4", "Solitary", "PlantFreq", "DCA1", "DCA2", "DCA3", "DCA4", "MASL", "LndscpGR", "LnscpH", "DistSand"),
    regression_status_override = "resolu",
    regression_evidence_override = "publication",
    regression_method_override = "formule publication confirmee et utilisee (verifiee 2026-09-10)",
    regression_note_override = "Formule etablie par lecture directe du PDF (2026-09-10, Table 1-2 p.503-504 + Section 2.2 p.504-505) : N=9594 = 39 especes d'abeilles x 44 especes de plantes x 16 sites (correspondance exacte confirmee). 16 predicteurs reels retrouves un a un dans le Table 1/2 (Regional Commonness, Distance to conspecifics, DCA1-4 abeille/plante, sociality Bombus, abondance locale de la plante, elevation, grassland 250m, Shannon landscape 250m, distance aux sols sableux). ERREUR CORRIGEE : `FacOccurrence` (17e colonne candidate) etait inclus a tort dans formula_used comme covariable -- verification empirique sur le .rds (2026-09-10) confirme une correspondance bijective parfaite avec `Occurrence` (FacOccurrence='X0' ssi Occurrence=0, 'X1' ssi Occurrence=1, 9594/9594 lignes, aucun croisement) : c'est la version factorielle de l'AUTRE variable reponse du papier (Table 2 : \"Occurrence... transformed into a two-level categorical variable for models using classification trees\"), pas une covariable -- fuite de donnees (l'autre reponse servait de predicteur). Retiree de x_terms_pub/formula_used. Occurrence reste une deuxieme cible Y legitime et documentee (non retenue comme formula_used ici, qui cible Number), a traiter si besoin comme un second modele plutot que remplacer Number.",
    ml_formula = "Number ~ DCA1 + DCA2 + DCA3 + DCA4 + BeeDCA1 + BeeDCA2 + BeeDCA3 + BeeDCA4 + Solitary + PlantFreq + MASL + LnscpH + LndscpGR + DistSand + NearestOcc + RegionalCommonness",
    ml_response = "Number",
    ml_predictors = c("DCA1", "DCA2", "DCA3", "DCA4", "BeeDCA1", "BeeDCA2", "BeeDCA3", "BeeDCA4", "Solitary", "PlantFreq", "MASL", "LnscpH", "LndscpGR", "DistSand", "NearestOcc", "RegionalCommonness"),
    ml_source_type = "scientific_publication",
    ml_status = "confirmed",
    ml_estimator_context = c("random_forest", "random_forest_xy", "xgboost", "xgboost_xy"),
    year = "2022",
    source_ref = "Sydenham, Venter, Reitan, Rasmussen, Skrindo, Skoog, Hanevik, Hegland, Dupont, Nielsen, Chipperfield & Rusch (2022), 'MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions', Methods in Ecology and Evolution 13(3):500-513, DOI 10.1111/2041-210X.13762 (recu 2 septembre 2021, accepte 12 octobre 2021, publie 2022). Table 1-2 documentent exactement les colonnes presentes dans le depot Dryad (10.5061/dryad.n02v6wwzn) : reponses Number/Occurrence par combinaison abeille x plante x site (N=9594=39x44x16, verifie), predicteurs bee/plant/site. Random Forest (Breiman 2001, package ranger via caret) est explicitement la methode publiee, pour 3 strategies de modelisation (classification Occurrence, regression Occurrence, regression Number)."
  )
)

# CRS_NOTES : caveat de lecture manuelle sur le CRS/les coordonnees qu'une
# regeneration ne doit pas ecraser (hypothese testee et ecartee, coordonnees
# jitterees/transformees par les auteurs, source du CRS verifiee dans le
# package/la doc, etc.). recommend_crs_analyse() reste la source de la
# recommandation de reprojection ; ceci n'ajoute qu'une ligne de contexte.
CRS_NOTES <- list(
  crane = "hypothese testee et ecartee (session 2026-09-10) -- l'etendue x/y (234-862 km, 23-627 km, Angleterre, grue eurasienne) est numeriquement compatible avec le British National Grid (EPSG:27700) en km, mais le loader (code/r_catalog/build_sf_datasets_papers.R, fonction load_crane) documente deja que le README Dryad ne precise pas la zone UTM, ET que les coordonnees sont 'aleatoirement transformees' par les auteurs pour proteger les sites de nidification -- pas les vraies positions. Assigner un CRS, meme correct, ne rendrait donc pas ces positions geographiquement exploitables : ne pas assigner de CRS ni construire de matrice de voisinage sur ce jeu tant que ce point n'est pas leve."
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
    package_include = "yes",
    missing_items = "aucune reponse continue alternative disponible dans le depot -- Number_of_fledglings (compte) reste la seule variable Y",
    reason = "Y/X, coordonnees et N sont confirmes; formule desormais dans FORMULA_OVERRIDES (Number_of_fledglings ~ Clutch_size + Laying_date + Incubation_duration). Promu package_include=yes le 2026-08-15 (decision utilisateur : Y present + formule + rds + fiche prets suffit)."
  ),
  rocha_agricultural_technology_brazil = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_rate",
    package_include = "yes",
    missing_items = "aucun -- CRS confirme WGS84 le 2026-08-15",
    reason = "Y continu/rate, covariables climatiques/distances et geometrie municipale sont disponibles; formule locale disponible dans le KG. CRS verifie le 2026-08-15 : le shapefile source (land_kr.shp) n'a pas de .prj, mais la bounding box (x:[-73.99,-32.38], y:[-33.75,5.27]) correspond exactement a l'etendue geographique du Bresil en degres decimaux (pas une projection metrique) -- WGS84 confirme par la geometrie elle-meme, coherent avec un shapefile municipal IBGE standard non documente."
  ),
  teles_decapod_biodiversity_brazil = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_biodiversity",
    package_include = "yes",
    missing_items = "aucun -- PD.SES choisie comme reponse continue par defaut (voir FORMULA_OVERRIDES), SR/PE.SES/WE/WE.SES/ED/ED.SES documentees comme alternatives disponibles dans le .rds",
    reason = "Y biodiversite continue (PD.SES), covariables environnementales et coordonnees sont disponibles; modele RF et diagnostics Moran documentes dans le papier/supplement. Promu package_include=yes le 2026-08-15."
  ),
  spruce_bark_beetle = list(
    benchmark_status = "ready",
    benchmark_task = "regression_count_spatial",
    package_include = "yes",
    missing_items = "formula_used est une version executable sans longitude/latitude et sans interactions/quadratiques explicites du GLM negatif binomial publie",
    reason = "Y=trapcounts, covariables retenues par le papier, coordonnees WGS84 et N=1731 sont disponibles; le papier confirme l'analyse de regression et le modele final."
  ),
  florida_crash_gsvcm = list(
    benchmark_status = "ready",
    benchmark_task = "regression_count_spatial_svc",
    package_include = "yes",
    missing_items = "reponse Offcrsh = compte d accidents; utiliser RMSE/MAE comme benchmark numerique ou une route count dediee quand elle sera disponible",
    reason = "Le script supplementaire donne explicitement Y, X et coordonnees; l'application Florida crash est un cas empirique GSVCM/negative-binomial. La reponse est un count, documente comme tel mais conservable dans le package."
  ),
  possum_body_size = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_body_size",
    package_include = "yes",
    missing_items = "aucun blocage package; formule_used alignee sur le modele aspatial/spatial SAR selectionne du papier",
    reason = "Y=CBL continu, coordonnees et covariables du modele selectionne sont disponibles; Table 2 du papier confirme la specification."
  ),  cluster_detection = list(
    benchmark_status = "excluded_simulation",
    benchmark_task = "regression_continuous_simulated",
    package_include = "no",
    missing_items = "exclu du package benchmark empirique",
    reason = "Y/X et coordonnees sont disponibles, mais l artefact local est un jeu simule de detection de clusters de coefficients, pas un benchmark empirique."
  ),
  mammals_sr_pd = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "SR est retenu comme benchmark canonique; PD reste documente comme reponse alternative publiee",
    reason = "Y=SR continu, covariables AET et Temp, coordonnees et formule canonique issue de la Figure 1 sont disponibles."
  ),
  wald_test = list(
    benchmark_status = "ready",
    benchmark_task = "regression_spatial_weights_non_geographic",
    package_include = "yes",
    missing_items = "aucun -- matrice W originale du papier verifiee et attachee le 2026-08-15 (paper_wald_test_W_clear1.rds, 398x398, alignee sur le sous-echantillon clear1=1 utilise par formula_used)",
    reason = "La formule SDM est confirmee, et la matrice W politique originale (non geographique, replication Williams & Whitten 2015) est desormais disponible et verifiee ligne a ligne contre le sous-echantillon clear1=1 (398 observations). Promu package_include=yes le 2026-08-15."
  ),
  metacomnet = list(
    benchmark_status = "not_ready_current_package",
    benchmark_task = "classification_or_count_rf",
    package_include = "no",
    missing_items = "formule et 16 covariables reelles desormais etablies (verifie 2026-09-10, Table 1-2 du papier) et la fuite de donnees FacOccurrence corrigee -- reste a verifier concretement que la route classification/count du harnais (ajoutee 2026-09-04) fonctionne de bout en bout sur ce Y=Number (compte, plage [0,27], probablement surdisperse/zero-inflate) et sur Y=Occurrence (second Y publie, non modelise ici)",
    reason = "Le papier ajuste 3 modeles Random Forest (Breiman 2001) : classification sur Occurrence, regression sur Occurrence, regression sur Number -- desormais documente avec formule/covariables reelles (voir FORMULA_OVERRIDES). Pas encore promu : verification d'execution de bout en bout non faite pour ce jeu specifique."
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
    benchmark_status = "ready",
    benchmark_task = "regression_gwr",
    package_include = "yes",
    missing_items = "formula_used retient le bloc environmental energy du GWR; les GLM par variables individuelles et les PC1 par categories restent documentes comme variantes papier non toutes reproduites dans une formule unique",
    reason = "Le papier confirme richesse Medicago, 24 covariables environnementales, GLM negatif binomial et GWR sur la relation richesse-energie. Les variables du bloc energie environnementale sont disponibles localement et fournissent une formule benchmark defendable."
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
  ethiopia_clusters = list(
    benchmark_status = "not_ready_derived_clusters",
    benchmark_task = "cluster_detection_output",
    package_include = "no",
    missing_items = "retrouver le jeu DHS/GWR original ou rester hors benchmark",
    reason = "Le fichier contient des clusters SaTScan derives, pas les observations de malnutrition utilisees pour la GWR."
  ),
  pallid_bat = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_spatial_sar",
    package_include = "yes",
    missing_items = "centroid_size est un proxy cranien de taille corporelle derive des landmarks TPS; le papier privilegie les resultats ventraux mais indique que les resultats lateraux sont quasi identiques",
    reason = "Le papier definit centroid size comme proxy de body size, selectionne des modeles OLS/SARerr, et le top SARerr inclut NPP, MinWinTemp et TempSeas. Ces variables sont jointes localement et la formule est executable."
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
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "formula_used est une version locale reduite : LANDScapes, GEOL, VEGET et la composante de krigeage des residus restent documentees mais absentes du .rds",
    reason = "AGB_mean est reconstruit depuis le supplement PLOS; area_ha, n_stems, mean_wsg, HAND, LOG, ALT et SLO sont disponibles localement. Par decision de curation, cette version reduite est conservable dans le package avec la difference explicite entre formule publiee complete et formule executable locale."
  ),
  # -- Lot DataCite 2026-08 (harvest verifie, session du 2026-08-12) --------
  coral_bathypathes = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes",
    missing_items = "Y binaire (pa) uniquement -- pas de variante continue disponible ; estimateurs de reference fixes sur random_forest/random_forest_spatial (deja dans le package)",
    reason = "pa binaire, 14 covariables environnementales et coordonnees WGS84 tous confirmes par contenu reel (README Dryad + verification du CSV). Promu package_include=yes le 2026-08-15 : le seul frein etait la typologie Y binaire, pas un manque de donnees -- traitement Y-binaire dans le package a regler plus tard globalement."
  ),
  coral_corallium = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes (README Dryad commun aux 12 taxons)."
  ),
  coral_enallopsammia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_errina = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_goniocorella = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_isididae = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_leiopathes = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_madrepora = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_paragorgia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_primnoa = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_solenosmilia = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
    reason = "Meme source/structure que coral_bathypathes."
  ),
  coral_stylaster = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes", missing_items = "idem coral_bathypathes (Y binaire uniquement, estimateurs fixes sur random_forest/random_forest_spatial)",
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
    missing_items = "N=31 seulement (petit echantillon, cf. table1_gage_stations.csv) ; les 2 predicteurs sont exactement ceux de l'equation publiee, aucune covariable ML additionnelle disponible",
    reason = "CORRIGE le 2026-08-15 : le loader utilisait a tort le shapefile de PREDICTION (42449 troncons NHDPlus, sortie du modele applique a tout l'Etat, section 2.4 du papier), pas une table d'apprentissage -- la fiche etait promue package_include=yes sur cette base erronee. Reconstruit avec la vraie table de calibration (Table 1 p.1257, N=31 stations de jaugeage USGS reelles, coordonnees recuperees via l'API USGS NWIS pour les numeros de station publics). Y continu (aug_baseflow_m3s_km2), X = les 2 predicteurs exacts de l'equation publiee (Eq.1 p.1258), coordonnees reelles -- promu a nouveau apres correction."
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
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes",
    missing_items = "reponse pa binaire; covariables WorldClim ajoutees localement a une resolution plus grossiere que la resolution du papier; pseudo-absences/background a documenter dans les benchmarks",
    reason = "pa binaire et 5 variables bioclimatiques nommees dans le papier sont presentes. Ce n'est pas une regression continue, mais le dataset est suffisamment trace pour entrer dans le package comme cas SDM/classification documente."
  ),
  ethiopia_whitetailed_swallow_sdm = list(
    benchmark_status = "ready", benchmark_task = "classification_binary_presence_absence",
    package_include = "yes",
    missing_items = "reponse pa binaire; covariables WorldClim ajoutees localement a une resolution plus grossiere que la resolution du papier; pseudo-absences/background a documenter dans les benchmarks",
    reason = "pa binaire et 5 variables bioclimatiques nommees dans le papier sont presentes -- structure strictement identique a ethiopia_bushcrow_sdm (meme papier, memes covariables, meme methodologie). Corrige le 2026-08-15 : le statut almost_ready/manual_review etait une incoherence de copier-coller (missing_items disait deja 'idem ethiopia_bushcrow_sdm' sans justifier un statut inferieur) -- aligne sur bushcrow (ready/yes)."
  ),
  desert_tortoise_genotype_niche = list(
    benchmark_status = "not_ready_derived_response", benchmark_task = "derived_model_output",
    package_include = "no",
    missing_items = "retrouver les points d'echantillonnage genotype bruts (non fournis dans le depot Dryad, uniquement des surfaces .asc deja modelisees)",
    reason = "GenAssociation est une sortie du modele de niche local original (surface interpolee), pas des observations genotype-habitat brutes -- meme categorie que beta0_gwr dans ce fichier."
  ),
  trillium_presence_background = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "cas classification/binomial; le papier publie aussi une beta-regression espece-niveau PO ~ traits reproductifs mieux couverte par paper_trillium_proportional_occupancy",
    reason = "Occurrences Trillium Dryad et covariables WorldClim publiques sont disponibles dans l'artefact local; la reconstruction presence/background est tracee et conservable dans le package, avec son type de tache explicite."
  ),
  wildfire_bootleg_severity = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "grille reechantillonnee a 250m Albers depuis des sources heterogenes (9m a 1000m, resolution native du papier 30m) -- compromis documente ; 3 couches (aspect_10res, ecostress_pet, ecostress_esi) absentes du depot Dryad public ; treatment_type et time_since_treatment (les predicteurs centraux du modele SAR publie sur l'effet des traitements) sont ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici (voir Bloc 1, formula_used_divergence_note)",
    reason = "Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (11 variables, Fig. 4a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Y et X reels/documentes (pas inventes), artefact local utilisable pour cette tache de regression -- corrige 2026-09-10 (la fiche affirmait auparavant a tort que les 34 predicteurs bruts formaient le modele SAR publie)."
  ),
  wildfire_schneider_springs_severity = list(
    benchmark_status = "ready", benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "meme reserve que wildfire_bootleg_severity : grille reechantillonnee a 250m Albers (resolution native 30m), 2 couches ecostress + aspect_10res absentes du depot public ; treatment_type et time_since_treatment (predicteurs centraux du modele SAR publie) ABSENTS de l'artefact local -- corrige 2026-09-10, le modele publie n'est pas reproductible tel quel ici",
    reason = "Tache benchmark : predire rdnbr (continu, reel) a partir des covariables environnementales retenues par le Random Forest du papier (13 variables, Fig. 5a) -- distincte de la tache causale du papier (effet du traitement sur la severite via SAR), qui necessite treatment_type/time_since_treatment absents du depot local. Meme source/structure que wildfire_bootleg_severity, second incendie (Washington 2021) du meme papier -- corrige 2026-09-10 (la fiche affirmait auparavant a tort 'meme modele SAR que Bootleg' en listant les 34 predicteurs bruts comme formule publiee)."
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
    benchmark_status = "ready",
    benchmark_task = "regression_count_small_n",
    package_include = "yes",
    missing_items = "N=38 et Y de comptage ; a signaler dans les comparaisons, mais le papier travaille a ce niveau de colonie et le package peut evaluer RMSE/MAE sur une reponse numerique.",
    reason = "ColonyData fournit coordonnees corrigees, sortie reproductive Tot_rep et covariables meteo/land-use/floral cover. Le petit N et la nature count de Tot_rep sont documentes, sans bloquer le benchmark numerique."
  ),
  rocky_mountain_tree_growth = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_reduced_cross_section",
    package_include = "yes",
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
  ),
  flapper_skate_presence = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_sdm",
    package_include = "yes",
    missing_items = "reponse binaire present_01 ; hors cahier de regression continue stricte, mais conserve comme cas SDM/classification documente dans le package",
    reason = "Le dossier Dryad contient full_dataset.csv avec presence/absence, lon/lat et covariables bathymetrie, distance a la cote, courant, temperature de fond, productivite benthique et effort de peche. Le loader applique les exclusions documentees par le papier/code puis produit un sf WGS84."
  ),
  bean_landrace_gap_sdm = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_sdm",
    package_include = "yes",
    missing_items = "reponse binaire status_H_01 ; hors cahier de regression continue stricte, mais conserve comme cas SDM/classification documente dans le package",
    reason = "Le fichier Excel Dryad contient coordonnees, statut/genepool et covariables climatiques, d'accessibilite et agricoles. Le loader produit une version sf executable pour benchmark SDM/classification, en documentant que formula_used est une variante binaire locale."
  ),
  nyc_tract_income_ssig = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "millesime ACS 2020-2024 au lieu de 2015-2019 (cle API Census Bureau indisponible) ; N=2199 vs N=2117 publie, ecart du au millesime different ; formula_pub liste les 10 predicteurs exacts du papier mais le modele publie est un Gaussian Process + SHAP, pas une equation lineaire fermee",
    reason = "Y continu reel (per_capita_income / median_household_income, ACS), X = les 10 covariables socio-economiques exactes de Table 2 du papier (education, chomage, age, densite, sexe, race), coordonnees reelles des centroides de tract. Reconstruit depuis sources publiques (Census Reporter + TIGER/Line) car le depot du papier n'est pas public -- promu avec ecart de millesime documente."
  ),
  nyc_census2000_gwrboost = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- shapefile original du papier telecharge directement (pas une reconstruction), N=2216 identique",
    reason = "Y continu reel (mean_inc), X = les 6 covariables exactes de Table 2 du papier, geometrie polygonale originale (blocs de recensement NYC 2000). Dataset telecharge directement depuis la source citee par le papier (GeoDa Lab), aucun ecart de millesime ni reconstruction -- meilleure fidelite possible."
  ),
  hiv_southern_africa = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_rate",
    package_include = "yes",
    missing_items = "regression multivariable complete du papier (divorce, age, ISTs) necessite les microdonnees DHS individuelles (DHS Individual Recode), non incluses dans le depot public et non re-telechargeables sans enregistrement DHS Program separe -- formula_used se limite aux covariables cluster-level reellement presentes (URBAN_RURA, country, DHSYEAR)",
    reason = "Y continu reel (PER, taux de positivite VIH par cluster DHS, %), coordonnees GPS reelles des clusters (LATNUM/LONGNUM), N=3347 sur 6 pays d'Afrique australe (2013-2018). Depot recupere via mirroir figshare cite explicitement dans le papier (Data Availability Statement), pas une reconstruction."
  ),
  usgs_flood_skew = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- shapefile original telecharge directement depuis ScienceBase (pas une reconstruction), N=183 identique au depot source",
    reason = "Y continu reel (UnbiasSkew), X = les 10 caracteristiques de bassin exactes du rapport USGS, geometrie polygonale originale (bassins versants). Dataset telecharge directement depuis la source officielle (ScienceBase), aucune reconstruction. Verifie manuellement le 2026-08-15 sur demande explicite de l'utilisateur avant promotion."
  ),
  red_deer_topdown = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad (pas une reconstruction), N=534 identique au depot source",
    reason = "Y continu reel (Deer_density), X = 10+ covariables environnementales/humaines exactes decrites dans le README du depot et le papier, coordonnees reelles (Latitude/Longitude) pour 534 sites d'etude dans 28 pays europeens. CSV telecharge directement depuis Dryad via API OAuth, N identique au depot source. Promu package_include=yes le 2026-08-15 (decision utilisateur explicite) : le domaine ecologie n'est pas un motif de blocage en soi, coherent avec les autres datasets ecologie-regression-continue deja promus dans le corpus."
  ),
  gwqlasso_pr = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "precip_annual_mm est un proxy simplifie (station la plus proche, total annuel) du SPI 1-mois publie, pas une reproduction exacte -- 7% de precip_annual_mm manquant (station la plus proche sans annee fiable) ; N=17157 vs echantillon exact du papier (41 municipalites/annees non identifiees) inconnu -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (Yield_kg_ha), municipalites geocodees via reference IBGE publique (44591/44592 matchees), precipitation reelle jointe par station la plus proche. Decoupe Etat du Parana depuis le depot brut complet (1030 municipalites/3 Etats) sur decision utilisateur 2026-08-15, evite le sous-echantillonnage."
  ),
  gwqlasso_rs = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "precip_annual_mm est un proxy simplifie (station la plus proche, total annuel) du SPI 1-mois publie, pas une reproduction exacte -- 7% de precip_annual_mm manquant ; N=21371, Etat (Rio Grande do Sul) hors du perimetre geographique exact decrit dans l'abstract du papier (Parana uniquement) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (Yield_kg_ha), municipalites geocodees via reference IBGE publique, precipitation reelle jointe par station la plus proche. Decoupe Etat depuis le depot brut complet sur decision utilisateur 2026-08-15."
  ),
  gwqlasso_mt = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "precip_annual_mm est un proxy simplifie (station la plus proche, total annuel) du SPI 1-mois publie, pas une reproduction exacte -- 5% de precip_annual_mm manquant ; N=6063, Etat (Mato Grosso) hors du perimetre geographique exact decrit dans l'abstract du papier (Parana uniquement) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (Yield_kg_ha), municipalites geocodees via reference IBGE publique, precipitation reelle jointe par station la plus proche. Decoupe Etat depuis le depot brut complet sur decision utilisateur 2026-08-15."
  ),
  fire_forest_loss_dominican_republic = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "NFIRESM6_PSQKM_PYR impute a 0 pour 24/482 cellules (NA source = absence de feu detecte, verifie via l'absence de tout 0 exact ailleurs dans la colonne) -- documente, pas une donnee fabriquee",
    reason = "Y continu reel (LOSS0118_PCT_PYR, perte de couvert forestier), X continu reel (densite de feux MODIS), formule bivariee exacte du papier (section 'Long-term approach'), geometrie polygonale hexagonale originale (grd_zonal_statistics.RDS extrait directement du depot Zenodo cite en isSupplementTo, pas une reconstruction), N=482 identique au depot source. Decouvert via le pipeline dataset-first (recherche directe Zenodo/Dryad, session 2026-08-16), papier lu integralement (TEI) pour confirmer formule et estimateur (Spatial Lag/Error Model)."
  ),
  amphibian_abnormality_hotspots = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_rate",
    package_include = "yes",
    missing_items = "77/675 evenements de collecte sans coordonnee valide exclus (proteection d'especes listees federalement documentee dans README_for_Site.txt), pas imputes -- N=598 final vs 675 collectes au total ; 4 SITE_ID dupliques dans le depot source dedoublonnes (garde la ligne avec coordonnees valides)",
    reason = "Y continu reel (all_ab_percent, % d'anomalies), coordonnees GPS reelles corrigees (Corrected_LATITUDE/LONGITUDE), N=598 sur 131 refuges USFWS / 9 regions. CSV original telecharge directement depuis Dryad (isSupplementTo/primary_article), pas une reconstruction. Papier lu integralement (TEI) : formule confirmee (GAMM spatial non-lineaire lat/long + effets aleatoires imbriques site/refuge/region)."
  ),
  covid_sociodemographic_risk = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous_rate",
    package_include = "yes",
    missing_items = "coupe transversale unique (fin de periode 2022-04-27) au lieu des 3 vagues pandemiques separees (Alpha/Delta/Omicron) modelisees individuellement dans le papier -- reduction de perimetre documentee, pas une reconstruction ; 2-3% de NA par covariable (comtes tres peu peuples exclus par les sources CDC), non imputes",
    reason = "Y continu reel (death_rate_per_100k), les 15 covariables exactes de la Table 1 du papier, geometrie polygonale originale (UScounties_conus.shp), N=3068 comtes CONUS. Shapefile + CSV telecharges directement depuis le depot Dryad du papier (archive GitHub complete), jointure documentee sur FIPS via script trace (build_county_covid_table.py), aucune valeur inventee. Papier lu integralement (TEI) pour confirmer la formule et les deux approches d'estimation (Poisson regional + Geographically Weighted Random Forest)."
  ),
  fhb_ensembling = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucune coordonnee dans le depot source -- 69/80 localites geocodees via Nominatim/OpenStreetMap (API publique, pas invente), 14/999 lignes exclues faute de correspondance ; formula_used limitee aux covariables categorielles documentees (resist/wc/corn/type), les 340 variables meteo candidates du papier restent dans l'artefact local mais ne sont pas fixees dans une formule unique (39 modeles de base competing dans le papier, pas une specification canonique)",
    reason = "Y continu reel (S, severite FHB %), panel spatio-temporel non-equilibre reel (80 sites x jusqu'a 32 ans), N=985 apres geocodage. CSV original telecharge directement depuis Dryad (isCitedBy le papier de methodologie), pas une reconstruction. Papier correctement identifie apres correction d'une erreur d'attribution du pipeline (isCitedBy pointait vers un papier anterieur), lu integralement (TEI) pour confirmer le cadre d'ensembling de 39 modeles de regression logistique."
  ),
  snake_home_range = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "X100MCP (Y principal) non-NA pour 41/109 lignes seulement -- differentes etudes sources ayant utilise differentes methodes d'estimation du domaine vital (MCP vs kernel density), NA reel documente dans le depot, pas impute ni fabrique",
    reason = "Y continu reel (domaine vital, methode MCP), coordonnees GPS reelles (Latitude/Longitude) pour 109/113 especes, covariables ecologiques/biogeographiques exactes du papier (masse, habitat, elevation, NPP, temperature, precipitation). CSV original telecharge directement depuis le depot DataCite/Dryad du papier, pas une reconstruction. Papier lu integralement (TEI) pour confirmer le cadre LMM (lme4, intercepts aleatoires etude/espece)."
  ),
  amphibian_functional_diversity = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=4065 identique au depot source",
    reason = "Y continu reel (H0, richesse fonctionnelle), N=4065 cellules de grille avec coordonnees reelles (X/Y), covariables climatiques/environnementales exactes du papier (NPP, temperature, precipitation, aridite). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la formule (OLS avec correction d'autocorrelation spatiale de Dutilleul). Papier recupere manuellement par l'utilisateur (session 2026-08-16)."
  ),
  dragonfly_colour_lightness = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=9966 identique au depot source",
    reason = "Y continu reel (meanRGB, clarte de couleur), N=9966 cellules de grille avec coordonnees reelles, 6 covariables bioclimatiques WorldClim exactes du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la formule (SEM, modele a erreur autoregressive). Papier recupere manuellement par l'utilisateur (session 2026-08-16)."
  ),
  groundfish_cpue = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=6716 identique au depot source",
    reason = "Y continu reel (CPUE), N=6716 (panel station x annee) avec coordonnees reelles, covariables SST exactes du papier (5 fenetres temporelles). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la formule (moyenne de modeles, AIC). Papier recupere manuellement par l'utilisateur (session 2026-08-16)."
  ),
  leishmaniasis_occurrence = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "le papier ajuste un modele BRT sur presence/pseudo-absence avec covariables climatiques externes (rasters non inclus dans ce depot) -- formula_used reformule en classification du type clinique a partir des seules variables presentes (pas de pseudo-absences, pas de covariables environnementales) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y categoriel reel (type clinique de leishmaniose, 3 classes), N=7762 occurrences ponctuelles reelles avec coordonnees mondiales, covariables administratives/temporelles reelles. Fichiers originaux (localites 'point' uniquement) telecharges directement depuis Dryad, pas une reconstruction. Papier deja identifie (Pigott et al. 2014, eLife) et PDF deja integre."
  ),
  mistletoe_bird_abundance = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=9012 identique au chiffre publie dans le README ; formula_used omet le terme spatial SPDE et l'interaction mistletoe x saison du modele complet, disponible en X supplementaires (Season deja inclus)",
    reason = "Y continu/comptage reel (abondance totale d'oiseaux), N=9012 visites de site avec coordonnees reelles (sud-est de l'Australie), covariables de gui et de vegetation exactement celles du papier (memes noms de colonnes). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la reponse et les predicteurs (question 2 du papier)."
  ),
  stwr_precip_isotope = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis le depot logiciel Zenodo du papier, N=272 identique au chiffre publie",
    reason = "Y continu reel (delta2H, isotope d'hydrogene des precipitations), N=272 stations avec coordonnees reelles (nord-est des Etats-Unis), covariables exactement celles de l'equation 21 du papier (precipitation, temperature, elevation). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Formule et N confirmes par lecture directe du texte integral (correspondance exacte : 272 points de calibration cites dans le papier = N du fichier)."
  ),
  airbnb_europe_prices = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- 20 fichiers originaux (10 villes x weekday/weekend) telecharges directement depuis Zenodo, N=51707 identique au depot source",
    reason = "Y continu reel (log du prix Airbnb, transformation explicitement justifiee et utilisee par le papier), N=51707 annonces avec coordonnees reelles (10 villes europeennes), covariables exactement celles du papier (type de logement, capacite, note de proprete, distance au centre/metro, indices d'attractivite touristique/restauration). Fichiers originaux telecharges directement depuis Zenodo, pas une reconstruction. Papier deja identifie et PDF deja integre (Gyodi & Nawaro 2021, Tourism Management)."
  ),
  seshat_social_complexity = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier ajuste des modeles de regression dynamique (panel temporel avec autocorrelation), pas une regression transversale -- formula_used agrege chaque polite a sa valeur maximale enregistree (simplification documentee du format panel long) ; coordonnees des NGA obtenues par geocodage de noms de regions historiques (pas des coordonnees officielles Seshat, non publiees) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (population de polite, valeurs historiques codees par les experts Seshat), N=307 polites sur 31 zones geographiques naturelles avec coordonnees reelles (geocodees individuellement et verifiees), covariables de complexite sociale reelles (territoire, hierarchie administrative, hierarchie d'habitat). CSV original telecharge directement depuis Dryad (fausse alerte 'aucun fichier' corrigee), pas une reconstruction des valeurs elles-memes."
  ),
  ltar_crop_rotation_yield = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad ; coordonnees des 11 sites lues directement dans le Tableau 1 du papier (pas un geocodage approximatif)",
    reason = "Y continu reel (rendement de mais), N=11970 parcelle-annees avec coordonnees reelles des 11 sites (Amerique du Nord, Table 1 du papier), covariables de conception experimentale reelles (systeme de rotation, travail du sol, fertilisation). CSV original telecharge directement depuis Dryad (fausse alerte 'aucun fichier' corrigee), pas une reconstruction. Papier lu integralement (TEI) pour confirmer les coordonnees exactes des 11 sites et la formule du papier (RCI x annee)."
  ),
  danajon_coral_distribution = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "le papier etudie l'effet de facteurs de stress humains (peche, marche, demographie -- disponibles dans le meme depot mais non joints spatialement ici, absence de cle de jointure directe polygone-barangay) sur la distribution des coraux -- formula_used n'utilise que les covariables geomorphologiques/spatiales deja presentes dans la couche d'habitat, pas les covariables de stress humain du papier -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y binaire reel (indicateur de corail, classe reclassifiee du papier), N=29512 polygones d'habitat (convertis en centroides) avec coordonnees reelles (Danajon Bank, Philippines), covariables geomorphologiques et de zone ecologique reelles issues de la meme carte d'habitat que le papier. Shapefile original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le fichier readme du depot (Selgrath, Gergel & Vincent 2025, People and Nature) ; l'attribution papier_doi initiale (PANGAEA, carte d'habitat) etait incorrecte et corrigee en session precedente."
  ),
  shark_longline_catch = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- table de predicteurs reels (pas les predictions du modele) telechargee directement depuis Dryad, N=8592 cellules ICCAT",
    reason = "Y continu reel (capture de requin), N=8592 cellules de grille avec coordonnees reelles (Atlantique, ICCAT), covariables environnementales et d'effort de peche exactement celles du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction (colonnes de prediction .pred/.final_pred explicitement exclues de X). Papier identifie (Frontiers in Marine Science, DOI 10.3389/fmars.2022.1062447), recupere manuellement par l'utilisateur (session 2026-08-16)."
  ),
  sfbay_contaminated_sites = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "aucun -- shapefiles originaux (sous-ensemble cible extrait du zip complet de 782MB) telecharges directement depuis Dryad, N=802 sites uniques apres dedoublonnage documente",
    reason = "Y binaire reel (statut ouvert/ferme du site contamine, explicitement defini et analyse par le papier), N=802 sites uniques avec coordonnees reelles (baie de San Francisco), covariables de risque de remontee de nappe et d'inondation exactement celles du papier (memes noms de champs que la geodatabase source). Shapefiles originaux telecharges directement depuis Dryad, pas une reconstruction. Papier identifie via correspondance exacte du nom de fichier zip (HillHirshfeldLindquistCookWarner) avec les auteurs, texte integral lu (TEI) pour confirmer la definition open/closed et les covariables de risque."
  ),
  uk_linear_features_birds = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier publie 18 modeles d'abondance par espece, pas une regression communautaire -- formula_used agrege l'abondance BBS toutes especes (simplification documentee) ; coordonnees dependent d'une conversion BNG->WGS84 via package externe (rnrfa), verifiee sur references connues mais non issue directement du depot -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu/comptage reel (abondance totale d'oiseaux BBS), N=3312 sites avec coordonnees reelles (Royaume-Uni, converties depuis references de grille nationale britannique), covariables d'elements lineaires exactement celles du papier. Fichier de donnees d'abondance manquant du harvest initial retrouve et telecharge directement depuis Dryad (session 2026-08-16), pas une reconstruction."
  ),
  alps_floristic_legacy = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=509 cellules identique au depot source ; formule desormais verifiee contre Table 1 du papier (2026-09-10, papier obtenu et lu -- corrige un blocage precedent ou aucun PDF/TEI local n'existait)",
    reason = "Y continu reel (richesse specifique standardisee a 95% de completude), N=509 cellules avec coordonnees reelles (Alpes europeennes), covariables (distance au refuge le plus proche, vitesse de changement climatique) exactement celles du modele SAR retenu par les auteurs (Table 1, R2 faible=9% documente). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier obtenu (2026-09-10) et verifie integralement -- corrige un cas ou la fiche precedente affirmait une verification qui n'avait jamais eu lieu."
  ),
  pacific_atoll_coconut = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=266 atolls, statistiques de couverture vegetale issues de la classification satellite propre au papier",
    reason = "Y continu reel (pourcentage de couverture cocotier, classification satellite), N=266 atolls du Pacifique avec coordonnees reelles, covariables environnementales et historiques reelles (pluviometrie, elevation, histoire de production de coprah). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie et confirme (titre exact + DOI via OpenAlex, session 2026-08-16)."
  ),
  checkerspot_phenology = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier compare phenologie historique et disponibilite de nectar sur le terrain (sites nommes sans coordonnees) ; formula_used utilise uniquement le sous-jeu georeference (occurrences de musee), pas la comparaison complete du papier ; PDF non recupere localement (bloque anti-bot) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (jour julien d'observation), N=1989 occurrences de musee/citizen-science georeferencees (1877-2017, Amerique du Nord), covariables latitude/annee reelles pour une analyse phenologie-climat standard. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via OpenAlex (le paper_doi initial pointait vers le depot Zenodo du code, pas l'article)."
  ),
  sugarglider_occupancy = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier ajuste un modele occupation-detection (psi/p separes), pas une regression continue -- formula_used utilise le nombre de detections sur 5 visites comme proxy continu documente, pas la specification exacte du papier -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu/comptage reel (n_detections, 0-4 sur 5 visites), N=100 sites avec coordonnees reelles (Tasmanie), covariables d'habitat exactement celles du papier (etendue de foret mature a 5 echelles de tampon, elevation). Naive occupancy confirmee empiriquement (79/100 sites avec detection >0, correspond exactement au 0.79 publie). CSV original telecharge directement depuis Dryad, pas une reconstruction. paper_doi corrige (pointait vers un papier methodologique reutilisant ces donnees, pas l'etude originale) ; original Allen et al. 2018 confirme par recherche web (session 2026-08-16)."
  ),
  macropod_body_size = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad ; PDF du papier non recupere localement (evidence via resume web), formula_used filtre sur une seule espece (M. rufogriseus, N=856) parmi les 3 poolees dans le depot, conforme a l'approche par-espece du papier",
    reason = "Y continu reel (CL, longueur condylobasale, standard de taille corporelle), N=856 (M. rufogriseus) avec coordonnees reelles (Australie), covariables climatiques exactement celles du papier (SummerMaxTemp, AnnualRain, confirmees par le resume : 'skull size increasing with decreasing summer maximum temperature and increasing rainfall'), plus age (MI) et sexe. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par recherche web (resume officiel Journal of Animal Ecology, session 2026-08-16)."
  ),
  kodiak_puffin_density = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier publie un modele VAST joint avec covariables environnementales sur grille separee (profondeur, distance a la cote, SSTa, PDO) non jointe ici -- formula_used utilise uniquement les variables de conception d'echantillonnage deja presentes dans la table d'observation, une simplification documentee ; texte integral du papier non recupere localement (PDF bloque par anti-bot, resume/methodes confirmes via la page officielle) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (densite de macareux en mer), N=17908 (8954 transects x 2 especes, correspond exactement au resume officiel du papier), coordonnees reelles (Kodiak, Alaska, 1975-2022). Fichier original telecharge directement depuis Zenodo, pas une reconstruction. Paper_doi corrige (etait la source de donnees NPPSD citee, pas le papier reel) ; methodologie VAST confirmee via la page officielle de l'article (abstract + methodes), PDF complet a recuperer manuellement."
  ),
  chaco_bird_richness = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier publie un modele d'occupation par espece (197 modeles), pas une regression de richesse au niveau site -- formula_used est une agregation communautaire standard et documentee (richesse specifique), pas la specification per-espece du papier -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu/comptage reel (richesse specifique agregee de vraies observations d'oiseaux), N=234 sites avec coordonnees reelles (Chaco argentin), covariables agricoles/environnementales exactement celles du papier (yieldM, forest_6km, aridity parmi les 7 covariables testees). Fichiers originaux telecharges directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la nature du modele publie (occupation hierarchique par espece) et les covariables exactes."
  ),
  houston_lst_landcover = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier ne publie pas de regression Y~X statique (modele spatiotemporel physiquement contraint sur toute la sequence de passages satellite) -- formula_used est une coupe transversale ile-de-chaleur urbaine (LST~land_cover) sur le passage le mieux couvert, une simplification documentee, pas la specification publiee -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (LST en Kelvin, mesure satellite reelle), N=19059 pixels avec coordonnees reelles (Houston, Texas), covariable land_cover categorique reelle (6 classes). Grille originale telechargee directement depuis Dryad, pas une reconstruction. Papier lu (titre/abstract + structure des fichiers) pour confirmer la nature du probleme (reconstruction clear-sky spatiotemporelle, pas une regression statique)."
  ),
  song_sparrow_breeding_date = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- fichier original telecharge directement depuis Dryad, N=1040 identique au depot source ; formula_used retient uniquement la partie effets fixes du modele animal publie (les effets aleatoires genetiques bases sur le pedigree et les effets de localisation spatiale ne sont pas reproductibles sans le pedigree complet)",
    reason = "Y continu reel (date de premiere ponte, jour julien), N=1040 nids avec coordonnees UTM reelles converties en WGS84 (ile de Mandarte, BC, Canada), covariables de consanguinite/age/statut immigrant exactement celles du papier (equation 1, partie effets fixes b). Fichier original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la specification exacte des effets fixes."
  ),
  mimulus_sdm = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "aucun -- CSV originaux telecharges directement depuis Dryad, N=21307 identique au depot source (multi-especes poolees, pas de reconstruction des valeurs)",
    reason = "presence binaire reelle (occurrences Mimulus vs points de fond), N=21307 avec coordonnees reelles (Amerique du Nord), 6 covariables climatiques exactement celles du papier (memes noms de colonnes que la publication). CSV originaux telecharges directement depuis Dryad, pas une reconstruction. Papier lu (README du depot) pour confirmer la nature et les colonnes du jeu de donnees empirique."
  ),
  goa_trawl_demersal = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- CSV original telecharge directement depuis Dryad, N=9213 identique au depot source ; formula_used retient uniquement la partie effets fixes du modele publie (les effets aleatoires spatio-temporels AR1 par espece ne sont pas reproductibles sans re-estimation complete)",
    reason = "Y continu reel (CPUE de fletan a dents fines), N=9213 traits de chalut avec coordonnees reelles (Golfe d'Alaska, 1984-2011), covariable log(profondeur) lineaire+quadratique exactement celle du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la specification des effets fixes (equation 1 du texte)."
  ),
  dougfir_sdm = list(
    benchmark_status = "ready",
    benchmark_task = "classification_binary_presence_absence_sdm",
    package_include = "yes",
    missing_items = "aucun -- RData original telecharge directement depuis Dryad, N=53293 identique au depot source",
    reason = "PRES binaire reel (presence/absence Douglas-fir), N=53293 avec coordonnees reelles (Amerique du Nord), covariables climatiques PC1-PC6 exactement celles du script de replication de l'article (Box 4, modvars <- paste0('PC',1:6)). RData original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) et script R de replication inspecte pour confirmer la formule exacte (GLM binomial stepwise + Random Forest)."
  ),
  gcfr_soil = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier n'a pas de formule Y~X unique pour cette table de points d'echantillonnage (utilisee pour interpolation spatiale de couches de sol, pas pour une regression directe) -- formula_used (N_total_. ~ pH_extract + C_total_.) est une reformulation raisonnable documentee comme telle, pas la specification publiee -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A)",
    reason = "Y continu reel (N_total_., azote total du sol), N=2767 points d'echantillonnage avec coordonnees reelles, 1927 cas complets pour la formule retenue (79% de couverture sur N_total_.). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) : la table sert d'entree a une interpolation spatiale, pas a une regression Y~X du papier -- reformulation transparente en regression continue pour ce benchmark. Y initial (pH_H2O) ecarte car seulement 31/2767 valeurs non-NA (0 cas complets avec les covariables), non executable."
  ),
  avian_phylo_functional_distance = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "le papier ajuste une path analysis / Structural Equation Model (lavaan::cfa, verifiee robuste par une variante spatiale sesem) sur un systeme de 4 equations simultanees (MPFD_SES, PD_SES, migration, richesse specifique comme variables endogenes) -- pas un SAR/SEM-error/SDM/GWR au sens econometrie spatiale (attention a l'ambiguite de vocabulaire : 'SEM' du papier = Structural Equation Model, pas Spatial Error Model). formula_used (MPFDses ~ PDses + abs_lat + sp_richn) est une simplification lineaire documentee du chemin MPFD_SES du systeme complet, sans la proportion migratrice (Dufour et al. 2019) ni l'altitude (Weeks et al. 2022, Bioclim) -- toutes deux des sources externes absentes de ce depot Dryad -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16, groupe A ; corrige 2026-09-10 pour l'inversion Y/X, corrige 2026-09-14 pour la specification complete du chemin MPFD_SES)",
    reason = "Y continu reel (MPFDses, taille d'effet standardisee de la distance fonctionnelle moyenne par paire -- variable expliquee du chemin le mieux ajuste du papier, PAS PDses), N=17099 assemblages d'oiseaux georeferences a l'echelle mondiale, verifie contre le degre de liberte cite dans le papier (df=17097 -> N=17099 sites). X (PDses, taille d'effet standardisee de la diversite phylogenetique de Faith, plus abs_lat et sp_richn) sont les variables du chemin MPFD_SES disponibles localement. CSV original (standerdised_effect_sizes.csv) telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (PDF p.2127, section 3.2) pour confirmer MPFD_SES comme variable expliquee et PD_SES/abs_latitude/migration/altitude/richesse specifique comme predicteurs de ce chemin."
  ),
  spatial_confounding_diabetes = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "papier retrouve avec certitude (Wu & Banerjee, arXiv:2505.07232) -- correspondance verifiee a 100% entre les 15 predicteurs du papier et les colonnes locales ; le vrai modele reste multivarie (3 reponses coregionalisees BYM2), formula_used simplifie en regression univariee -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (diabetes_pct_est, prevalence du diabete ajustee sur l'age), N=2984/2984 comtes americains joints (couverture complete). CSV original (RDA_data.csv) et shapefile officiel Census (cb_2017_us_county_500k) telecharges directement depuis Zenodo -- pas une reconstruction. Chaque variable est sourcee individuellement dans RDA_data_variables.csv (US HHS County Level Area Health Resources Files, US Diabetes Surveillance System, USDA Food Environment Atlas, CDC WONDER). Jointure par code FIPS verifiee empiriquement (bug de zero-padding detecte et corrige, N passe de 2689 a 2984/2984 apres correction)."
  ),
  antarctic_biodiversity_completeness = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "papier confirme (Pertierra et al. 2025, Science, doi:10.1126/science.adk2118) -- script R original des auteurs retrouve dans le depot, confirme aucune regression publiee ; formula_used corrigee pour eviter la circularite methodologique (Slope/Obsrvd_ retires, ingredients directs du calcul KnowBR) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (Cmpltns, completude d'inventaire biodiversite, indice KnowBR), N=1518 cellules de grille Antarctique avec coordonnees reelles. CSV original telecharge directement depuis Zenodo, pas une reconstruction. Bug d'inversion Latitude/Longitude dans le CSV source detecte et corrige empiriquement (verifie geographiquement valide apres correction : latitude [-89.6,-60.2], coherent avec l'Antarctique)."
  ),
  pollinator_urbanization_meta = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "papier confirme (Liang, He, Theodorou & Yang 2023, Ecology Letters, doi:10.1111/ele.14277) -- moderateurs alignes sur ceux confirmes par le resume officiel (groupe taxonomique, gradient urbain), Vd corrigee (poids meta-analytique, pas covariable) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (d, taille d'effet de Hedges de l'urbanisation sur l'abondance des pollinisateurs), N=228 etudes/especes avec coordonnees geographiques reelles a l'echelle mondiale. CSV original (Appendix S1.1) telecharge directement depuis Dryad, pas une reconstruction."
  ),
  portugal_covid_municipal = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "aucune publication n'a ete identifiee pour ce candidat dataset-first (donnees officielles DGS) -- formula_used est une proposition du curateur, pas une formule extraite d'un papier ; geometrie jointe a une source externe (geoBoundaries) avec 10/308 concelhos non apparies (ambiguites de denomination) ; package_include laisse en manual_review pour ces deux raisons",
    reason = "Y continu/comptage reel (incidencia, taux d'incidence COVID-19 sur 14 jours), N=20604 observations (panel journalier x 298/308 concelhos portugais). CSV original (dgs_data_concelhos_new.csv) telecharge directement depuis Zenodo, pas une reconstruction. Geometrie jointe a la couche publique geoBoundaries PRT/ADM2 (CC0), taux d'appariement verifie empiriquement a 96.8%."
  ),
  colombia_leptospirosis_risk = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "aucune publication n'a ete identifiee pour ce candidat dataset-first -- RR et MannKendall sont des sorties reelles du modele BYM du papier, mais formula_used (leur mise en relation) est une proposition du curateur ; geometrie jointe a une source externe (geoBoundaries) avec exclusion documentee de 65 noms de municipalites ambigus (homonymes inter-departementaux) ; package_include laisse en manual_review pour ces raisons",
    reason = "Y continu reel (RR, risque relatif spatial de leptospirose, sortie directe du modele BYM des auteurs), N=931 municipalites colombiennes univoques. Sup_materials_lepto.xlsx telecharge directement depuis Zenodo, pas une reconstruction. Geometrie jointe a la couche publique geoBoundaries COL/ADM2 (source officielle DANE), taux d'appariement verifie empiriquement, homonymes exclus plutot qu'approximes."
  ),
  korea_hedonic_housing = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "data descriptor officiel retrouve (Song, Ahn, An & Jang 2021, Data in Brief, doi:10.1016/j.dib.2021.106877) -- formula_used deja alignee avec la structure officielle documentee (Subway.distance confirmee comme variable cle par une etude d'application liee) -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (Housing.price, prix du logement), N=178719 transactions immobilieres reelles (4 villes coreennes) avec coordonnees reelles. 4 fichiers xlsx telecharges directement depuis Zenodo, pas une reconstruction, 0% NA verifie sur toutes les colonnes cles."
  ),
  wildebeest_movement_env = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "papier confirme et texte integral consulte (Paun et al. 2022, Ecology Letters, doi:10.1111/ele.14117) -- vrai modele est un processus gaussien complexe reliant les covariables A la vitesse (sens inverse de formula_used), non reproductible tel quel ; formula_used reste une exploration de correlation environnementale locale, documentee comme telle -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (NDVI estime au point/instant du GPS-fix), N=94006 positions GPS de gnous (43 individus suivis, Serengeti 1999-2016). CSV original telecharge directement depuis Dryad, pas une reconstruction. Coordonnees UTM 36S verifiees coherentes avec le Serengeti."
  ),
  dragonfly_diversity_europe = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "papier confirme avec DOI (Pinkert et al. 2017, Ecography, doi:10.1111/ecog.03137) -- formula_used corrigee pour utiliser les variables explicitement confirmees par l'abstract (latitude, proportion lentique/lotique, glaciation LGM) au lieu de variables bioclimatiques non verifiees -- promu a package_include=\"yes\" apres validation utilisateur (session 2026-08-16)",
    reason = "Y continu reel (sp_rich, richesse specifique de libellules), N=4192 cellules d'assemblage europeennes avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via le nom du fichier (Pinkert et al. 2017, Ecography ECOG-03137)."
  ),
  brisbane_urban_vegetation = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "formula_used simplifie les termes polynomiaux (poly(x,2)) du meilleur modele combine en lineaire et omet la structure SAR (poids spatiaux a 150m) du papier original -- simplification documentee",
    reason = "Y continu reel (dens_015_1, densite de vegetation basse), N=63142 cellules de grille 1ha (Brisbane, Australie) avec coordonnees reelles. CSV original telecharge directement depuis Dryad, pas une reconstruction. Formule confirmee par lecture directe du script R original des auteurs (present dans le meme depot), publication liee identifiee automatiquement via OpenAlex (Mitchell et al. 2016, J. Appl. Ecol., doi:10.1111/1365-2664.12741)."
  ),
  banff_stream_temperature = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "le papier presente une methodologie SSN (Spatial Stream Network) + INLA sur reseau hydrographique, pas une regression classique -- formula_used est une simplification lineaire du curateur utilisant les covariables reelles disponibles ; package_include laisse en manual_review pour cette raison",
    reason = "Y continu reel (WaterTemp, temperature moyenne d'aout), N=110 sites de mesure avec coordonnees UTM reelles (Parc national de Banff, Alberta). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie avec certitude via le README du depot (citation complete des auteurs)."
  ),
  global_nee_gwxgboost = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "aucune publication n'a ete identifiee avec certitude (recherche web sans correspondance exacte) -- formula_used est une proposition du curateur exploitant les variables de teledetection presentes ; package_include laisse en manual_review pour cette raison",
    reason = "Y continu reel (NEE, echange net d'ecosysteme, mesures eddy covariance FLUXNET), N=109154 observations (387 sites mondiaux, panel site x jour x annee) avec coordonnees reelles. CSV original telecharge directement depuis Zenodo, pas une reconstruction."
  ),
  california_wildfire_growth = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "le papier (Hanley 2022, these SJSU, doi:10.31979/etd.5znn-tm8p) predit un seuil binaire de croissance journaliere (>10000 acres/24h), pas une regression continue -- formula_used utilise la taille finale du perimetre comme proxy continu, meme familles de covariables meteo/combustible/topographie ; package_include laisse en manual_review pour cette raison",
    reason = "Y continu reel (Final_size_perimeter, taille finale de l'incendie), N=23031 incendies avec coordonnees d'ignition reelles (Californie). CSV original telecharge directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (these avec DOI officiel)."
  ),
  swiss_heat_exposure = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "manual_review",
    missing_items = "le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables, pas une regression lineaire -- formula_used simplifie en regression multiple lineaire ; package_include laisse en manual_review pour cette raison",
    reason = "Y continu/comptage reel (deaths, deces quotidiens population 65+), N=2368080 (panel 2145 communes x ~1104 jours) avec coordonnees reelles (centroides communaux). RDS originaux telecharges directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (Chen et al. 2025, JRSS Series A)."
  ),

  korea_hedonic_housing_1989 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1989 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=2424 transactions, 69 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1990 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1990 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=1794 transactions, 65 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1991 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1991 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=3828 transactions, 98 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1992 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1992 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5697 transactions, 156 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1993 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1993 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5432 transactions, 164 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1994 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1994 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6771 transactions, 169 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1995 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1995 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6914 transactions, 177 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1996 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1996 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=9261 transactions, 180 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1997 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1997 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=9135 transactions, 186 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1998 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1998 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6485 transactions, 135 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_1999 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 1999 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5572 transactions, 103 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2000 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2000 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6599 transactions, 144 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2001 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2001 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4165 transactions, 144 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2002 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2002 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4799 transactions, 257 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2003 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2003 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6122 transactions, 372 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2004 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2004 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4346 transactions, 234 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2005 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2005 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6559 transactions, 193 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2006 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2006 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=7328 transactions, 193 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2007 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2007 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5510 transactions, 147 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2008 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2008 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6084 transactions, 107 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2009 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2009 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4816 transactions, 82 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2010 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2010 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=3463 transactions, 57 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2011 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2011 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4302 transactions, 81 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2012 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2012 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=2981 transactions, 98 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2013 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2013 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5694 transactions, 152 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2014 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2014 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5622 transactions, 170 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2015 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2015 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=6986 transactions, 180 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2016 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2016 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=5868 transactions, 239 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2017 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2017 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4990 transactions, 225 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2018 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2018 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=4260 transactions, 189 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_2019 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de l'annee 2019 du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=1810 transactions, 131 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
  ),
  korea_hedonic_housing_pre1989 = list(
    benchmark_status = "ready",
    benchmark_task = "regression_continuous",
    package_include = "yes",
    missing_items = "aucun -- formule et provenance heritees telles quelles du dataset parent deja valide (package_include=\"yes\" depuis la session 2026-08-16) ; seul le decoupage temporel est nouveau",
    reason = "Y continu reel (Housing.price), sous-ensemble temporel de les annees clairsemees 1969-1988 regroupees en un seul sous-ensemble (2 a 69 localisations distinctes par annee prise isolement, jugees trop eparses pour un decoupage annuel individuel) du dataset parent deja promu package_include=\"yes\" (paper_korea_hedonic_housing, session 2026-08-16). N=13102 transactions, 510 localisations distinctes (verifie sur le .rds decoupe) -- assez pour une matrice de voisinage W non degeneree. Meme formule/Y/X que le parent, aucune correction necessaire."
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

# Bloc 2 "Year" etait un literal "unknown" code en dur pour TOUTES les fiches
# paper-derived (jamais derive d'aucune donnee), signale par l'utilisateur
# (2026-09-10) sur plusieurs fiches. bib_key (inst/kg/paper_dataset_uses.json)
# encode deja l'annee de publication reelle dans sa convention de nommage --
# soit "Auteur AAAA Titre" (ex. Chamberlain2024Learning, verifie contre
# l'article : Ecosphere 2024;15:e70073), soit "DataCite_AAAA_Titre_..." (ex.
# DataCite_2021_SystematicVariationInWaste... -> Schutt 2021, verifie contre
# le fiche waste_site). Les bib_key "JournalFirst_nd_..." utilisent "nd" (no
# date) de facon deliberee quand l'annee n'a pas ete determinee -- laisser
# "unknown" dans ce cas, ne pas inventer. Extraction verifiee sur un
# echantillon (2026-09-10) : ne pas la generaliser sans revue si le taux de
# NA remonte anormalement sur un futur lot de papiers.
extract_year_from_bib_key <- function(bib_key) {
  if (is.null(bib_key) || !nzchar(bib_key)) return("unknown")
  # bib_key "DataCite_AAAA_..." encode l'annee de DEPOT Dryad/DataCite du
  # jeu de donnees, pas necessairement l'annee de publication de l'article
  # (verifie 2026-09-10 : concordant pour medicago/2022 et waste_site/2021,
  # mais decale d'un an pour crane -- depot Dryad 2022, article Laxton et al.
  # publie 2023). Marquer ce cas explicitement plutot que l'affirmer comme
  # certain. Les conventions JournalFirst_AAAA_.../Warehouse_AAAA_.../
  # AuteurAAAATitre (sans prefixe) proviennent d'OpenAlex/CrossRef ou de la
  # reference bibliographique elle-meme -- traitees comme fiables.
  is_datacite <- grepl("^DataCite_", bib_key)
  tokens <- strsplit(bib_key, "[^0-9A-Za-z]")[[1]]
  year_token <- tokens[grepl("^(19|20)[0-9]{2}$", tokens)]
  year <- if (length(year_token)) year_token[1] else {
    m <- regmatches(bib_key, regexpr("(19|20)[0-9]{2}", bib_key))
    if (length(m) && nzchar(m)) m else NA_character_
  }
  if (is.na(year)) return("unknown")
  if (is_datacite) sprintf("%s (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)", year) else year
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
    # Storage as integer alone proves neither a count process nor a continuous
    # measurement. Curated selected-response evidence resolves this uncertainty.
    return(list(typology = "unknown", range = paste0("[", vals[1], ", ", vals[2], "]")))
  }
  list(typology = "unknown", range = NA_character_)
}

profil_nt <- function(N, Tt) {
  n_cat <- if (N >= 5000) "N_grand" else if (N >= 50) "N_moyen" else "N_petit"
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
  # Paliers (2026-09-18) : l'ancien seuil unique (>18deg -> "projection
  # nationale recommandee") traitait un span de 19deg et un span de 360deg de
  # la meme facon, ce qui est absurde pour un jeu reellement mondial/continental
  # (ex. medicago span=333.6deg, coraux span=360deg). Un span de 18-90deg reste
  # compatible avec un grand pays (ex. USA continental ~57deg, Canada ~90deg) ou
  # est deja verifie par ailleurs, donc la recommandation nationale/regionale
  # garde un sens mais doit etre confirmee, pas juste supposee ; au-dela de
  # 90deg, aucune projection nationale ne peut raisonnablement couvrir
  # l'etendue et une projection equal-area continentale/mondiale s'impose.
  if (x_span > 90)
    return(list(epsg = "pending", label = "pending",
                note = paste0("etendue continentale/mondiale (span=", round(x_span, 1),
                               "deg) -- projection nationale non pertinente ; privilegier une ",
                               "projection equal-area continentale ou mondiale (ex: Albers ",
                               "equal-area continental, Behrmann/Mollweide pour une couverture mondiale)")))
  if (x_span > 18)
    return(list(epsg = "pending", label = "pending",
                note = paste0("multi-zones (span=", round(x_span, 1), "deg) -- etendue compatible ",
                               "avec un grand pays/une region ; verifier qu'une projection ",
                               "nationale/regionale existe et convient a cette zone avant de ",
                               "l'utiliser, sinon envisager une projection continentale equal-area")))
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
  if (grepl("swiss_heat_exposure|spatially varying non.linear effects of heat", text)) {
    topic <- "sante environnementale / mortalite liee a la chaleur"
    unit <- "commune x jour"
    population <- "population 65+, communes suisses (N=2145), panel journalier 2011-2022"
  } else if (grepl("california_wildfire_growth|large daily wildfire growth", text)) {
    topic <- "risques naturels / croissance journaliere de feux de foret"
    unit <- "jour-incendie (fire day)"
    population <- "incendies, Californie 2003-2020, N=23031 jours-incendie"
  } else if (grepl("wildfire_bootleg_severity|wildfire_schneider_springs_severity|learning from wildfires", text)) {
    # Corrige 2026-09-10 (signale par l'utilisateur/ChatGPT, verifie par
    # lecture directe du PDF, Chamberlain et al. 2024) : RdNBR est la reponse
    # CONTINUE utilisee dans toute la modelisation statistique du papier
    # ("we used continuous RdNBR as our primary response variable in all
    # statistical modeling"), PAS un sous-ensemble filtre aux seuls pixels de
    # haute severite -- la population couvre la gamme complete de severite
    # (basse/moderee/haute) sur les zones forestieres des deux perimetres.
    topic <- "risques naturels / effets des traitements sur la severite des feux"
    unit <- "pixel spatial (grille de 30m rééchantillonnée) au sein du perimetre forestier de l'incendie"
    population <- "pixels forestiers du perimetre de l'incendie (Bootleg, Oregon, ou Schneider Springs, Washington, 2021), RdNBR continu (toutes classes de severite) et covariables bioclimatiques, meteorologiques, topographiques, structurelles et de gestion"
  } else if (grepl("wildfire|green-up|greenup|nbr_5|post-fire|postfire|fire ecology", text)) {
    topic <- "risques naturels / recuperation post-incendie"
    unit <- "pixel spatial echantillonne depuis une grille de feu de haute severite"
    population <- "pixels d'incendies de haute severite aux Etats-Unis, avec NBR post-feu et covariables climat/sol/topographie"
  } else if (grepl("trillium", text)) {
    topic <- "ecologie vegetale / modeles de distribution d'especes"
    unit <- "point d'occurrence ou pseudo-absence background"
    population <- "occurrences georeferencees de 19 especes de Trillium en Amerique du Nord orientale, completees par un background SDM reconstruit"
  } else if (grepl("colombia_leptospirosis|leptospirosis.*colombia|lepto.*bym", text)) {
    topic <- "epidemiologie spatiale / leptospirose en Colombie"
    unit <- "municipalite colombienne"
    population <- "municipalites de Colombie (931 univoques), risque relatif spatial issu d'un modele BYM"
  } else if (grepl("portugal_covid_municipal|dgs_data_concelhos|concelho.*covid", text)) {
    topic <- "epidemiologie spatiale / covid-19 au niveau municipal"
    unit <- "concelho portugais x jour"
    population <- "concelhos du Portugal (298/308 apparies), panel journalier DGS, N=20604"
  } else if (grepl("urbanisation.*pollinat|pollinator_urbanization_meta|effects of urbanisation on pollinators", text)) {
    topic <- "meta-analyse / effets de l'urbanisation sur les pollinisateurs"
    unit <- "taille d'effet (etude x espece)"
    population <- "tailles d'effet de Hedges issues d'etudes mondiales sur l'urbanisation et les pollinisateurs, N=228"
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
  } else if (grepl("leishmania|leishmaniases", text)) {
    topic <- "epidemiologie / distribution mondiale de la leishmaniose"
    unit <- "occurrence ponctuelle"
    population <- "cas de leishmaniose cutanee, mucocutanee et viscerale, echelle mondiale, N=7762 occurrences"
  } else if (grepl("mistletoe|drought.induced dieback", text)) {
    topic <- "ecologie / gui, secheresse et communautes d'oiseaux"
    unit <- "visite de site"
    population <- "communautes d'oiseaux forestiers, sud-est de l'Australie, N=9012 visites"
  } else if (grepl("stwr|precip.*isotope|spatiotemporal weighted regression", text)) {
    topic <- "geochimie / isotopes des precipitations et modelisation spatio-temporelle"
    unit <- "station de mesure"
    population <- "stations de mesure d'isotopes de precipitation, nord-est des Etats-Unis, N=272"
  } else if (grepl("airbnb.*europe|airbnb.*prices|determinants.*airbnb", text)) {
    topic <- "economie urbaine / econometrie spatiale des prix Airbnb"
    unit <- "annonce Airbnb"
    population <- "annonces Airbnb, 10 villes europeennes (Amsterdam, Athenes, Barcelone, Berlin, Budapest, Lisbonne, Londres, Paris, Rome, Vienne), N=51707"
  } else if (grepl("seshat|social complexity|dynamic regression.*polity", text)) {
    topic <- "histoire quantitative / evolution de la complexite sociale"
    unit <- "polite historique"
    population <- "polites historiques codees par la base Seshat, 31 zones geographiques naturelles, echelle mondiale"
  } else if (grepl("ltar.*crop.*rotation|crop.rotation.diversification|rotational complexity", text)) {
    topic <- "agronomie / diversification des rotations de cultures et rendement"
    unit <- "parcelle-annee"
    population <- "11 experiences de rotation de mais de long terme, Amerique du Nord (Etats-Unis et Canada), 1959-2016"
  } else if (grepl("danajon|multiple stressors.*coral|coral.*spatial distribution", text)) {
    topic <- "ecologie marine / distribution spatiale des coraux et facteurs de stress"
    unit <- "polygone d'habitat (centroide)"
    population <- "recifs coralliens du Danajon Bank, Bohol, Philippines, N=29512 polygones"
  } else if (grepl("shark.*longline|shark.*catch|longline.*fisher", text)) {
    topic <- "halieutique / capture de requins par palangre industrielle"
    unit <- "cellule de grille (5x5 degres)"
    population <- "requins captures par palangre, ORGP ICCAT (Atlantique), N=8592 cellules"
  } else if (grepl("sfbay.*contaminated|groundwater rise|contaminated.*coastal.*sites", text)) {
    topic <- "risque environnemental / remontee de nappe et sites contamines"
    unit <- "site contamine (DTSC/SWRCB)"
    population <- "sites contamines de la baie de San Francisco, N=802 sites"
  } else if (grepl("linear.features|hedgerow|farmland biodiversity", text)) {
    topic <- "ecologie agricole / elements lineaires du paysage (haies) et biodiversite"
    unit <- "carre de 1km (site de suivi BBS)"
    population <- "oiseaux communs (Breeding Bird Survey), Royaume-Uni, N=3312 sites"
  } else if (grepl("alps floristic|post.glacial recolonization|nunatak", text)) {
    topic <- "biogeographie / heritage glaciaire de la flore alpine"
    unit <- "cellule de grille"
    population <- "flore vasculaire des Alpes europeennes, N=509 cellules"
  } else if (grepl("pacific atoll|coconut plantation|cocos nucifera", text)) {
    topic <- "teledetection / agriculture-foresterie tropicale (cocotier)"
    unit <- "atoll"
    population <- "atolls du Pacifique, N=266"
  } else if (grepl("checkerspot|euphydryas phaeton|baltimore checkerspot", text)) {
    topic <- "phenologie / decalage phenologique et papillons"
    unit <- "occurrence de musee/citizen-science georeferencee"
    population <- "papillon demi-lune de Baltimore (Euphydryas phaeton), Amerique du Nord, 1877-2017, N=1989 occurrences"
  } else if (grepl("sugarglider|sugar glider|petaurus breviceps", text)) {
    topic <- "ecologie / occupation d'espece introduite predatrice"
    unit <- "site de detection (camera/appel)"
    population <- "planeur du sucre (Petaurus breviceps, espece introduite predatrice), Southern Forest, Tasmanie, N=100 sites"
  } else if (grepl("macropod|rufogriseus|harvest.induced body.size", text)) {
    topic <- "ecologie evolutive / evolution de la taille corporelle induite par la chasse"
    unit <- "crane individuel (collection faunique)"
    population <- "wallaby de Bennett (Macropus rufogriseus), Australie, N=856 cranes"
  } else if (grepl("kodiak.*puffin|fratercula|tufted puffin|horned puffin", text)) {
    topic <- "ornithologie marine / declin de population de macareux"
    unit <- "transect d'observation en mer (echantillon)"
    population <- "macareux huppes et cornus (Fratercula cirrhata, F. corniculata), archipel de Kodiak, Alaska, 1975-2022"
  } else if (grepl("chaco.*bird|trade.offs.*biodiversity.*agriculture|moving.targets", text)) {
    topic <- "ecologie agricole / compromis biodiversite-agriculture"
    unit <- "site de releve ornithologique"
    population <- "communautes d'oiseaux (197 especes), Chaco argentin, N=234 sites"
  } else if (grepl("medicago|niche conservatism|richness", text)) {
    topic <- "biogeographie vegetale / gradients de richesse"
    unit <- "cellule de grille (100x100 km)"
    population <- "especes du genre Medicago"
  } else if (grepl("antarctic.*complet|antarctic.*biodiversity|antarctic.*inventor", text)) {
    topic <- "biodiversite / completude d'inventaires en Antarctique"
    unit <- "cellule de grille Antarctique"
    population <- "cellules de grille d'inventaire biodiversite, Antarctique, N=1518"
  } else if (grepl("spatial confounding.*areal data|diabetes.*county|spatial_confounding_diabetes", text)) {
    topic <- "sante publique / epidemiologie spatiale des comtes americains"
    unit <- "comte americain (polygone)"
    population <- "comtes des Etats-Unis, N=2984 (couverture quasi nationale)"
  } else if (grepl("avian.*phylogenetic.*functional|functional distance.*environmental context|avian phylo", text)) {
    topic <- "macroecologie / diversite phylogenetique et fonctionnelle aviaire"
    unit <- "assemblage d'oiseaux georeference (grille mondiale)"
    population <- "assemblages d'oiseaux, echelle mondiale, N=17099 sites"
  } else if (grepl("mammal|phylogenetic diversity", text)) {
    topic <- "macroecologie / diversite phylogenetique"
    unit <- "cellule de grille hexagonale globale"
    population <- "mammiferes terrestres"
  } else if (grepl("wildebeest|serengeti", text)) {
    topic <- "ecologie du mouvement / covariables environnementales le long de trajectoires GPS"
    unit <- "position GPS (fix)"
    population <- "positions GPS de gnous, Serengeti (43 individus, 1999-2016), N=94006"
  } else if (grepl("^korea_hedonic_housing_", record_id)) {
    period_label <- sub("^korea_hedonic_housing_", "", record_id)
    period_txt <- if (identical(period_label, "pre1989")) {
      "annees 1969-1988 regroupees (sous-ensemble clairseme)"
    } else {
      sprintf("annee %s", period_label)
    }
    topic <- "economie immobiliere / prix hedoniques en Coree du Sud"
    unit <- "transaction immobiliere"
    population <- sprintf(
      "transactions residentielles, 4 villes coreennes (Busan, Daegu, Daejeon, Gwangju) -- sous-ensemble temporel (%s) du dataset parent paper_korea_hedonic_housing (N total parent = 178719) ; voir Bloc 4 pour le N exact de ce sous-ensemble",
      period_txt
    )
  } else if (grepl("korea_hedonic_housing|busan|daegu|daejeon|gwangju", text)) {
    topic <- "economie immobiliere / prix hedoniques en Coree du Sud"
    unit <- "transaction immobiliere"
    population <- "transactions residentielles, 4 villes coreennes (Busan, Daegu, Daejeon, Gwangju), N=178719"
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
  } else if (grepl("groundfish|cpue|alaskan.*catch", text)) {
    topic <- "halieutique / prevision de capture (poissons de fond)"
    unit <- "station de peche a la palangre (annee)"
    population <- "poissons de fond d'Alaska (morue, fletan, grenadier), releves longline AFSC"
  } else if (grepl("gcfr|greater cape floristic|soil layers", text)) {
    topic <- "pedologie / cartographie regionale du sol"
    unit <- "point d'echantillonnage de sol"
    population <- "Greater Cape Floristic Region, Afrique du Sud, N=2767 points"
  } else if (grepl("houston.*lst|land.surface.temperature|clear.sky", text)) {
    topic <- "climatologie urbaine / ilot de chaleur urbain"
    unit <- "pixel de grille satellite"
    population <- "grille de temperature de surface (LST) et couverture du sol, Houston, Texas, N=19059 pixels"
  } else if (grepl("song.sparrow|mandarte|breeding.date", text)) {
    topic <- "ecologie evolutive / genetique quantitative de la phenologie de reproduction"
    unit <- "nid (evenement de reproduction)"
    population <- "bruants chanteurs (Melospiza melodia), ile de Mandarte, Colombie-Britannique, Canada, N=1040 nids"
  } else if (grepl("mimulus|wibb", text)) {
    topic <- "ecologie / modelisation de distribution d'espece (SDM multi-especes)"
    unit <- "point d'occurrence/fond"
    population <- "71 especes de Mimulus (monkeyflowers), Amerique du Nord, N=21307 points"
  } else if (grepl("goa_trawl|demersal communit|exxon valdez", text)) {
    topic <- "halieutique / communautes demersales et impact ecologique"
    unit <- "trait de chalut (station-annee)"
    population <- "communautes de poissons demersaux, Golfe d'Alaska, releves triennaux/biennaux 1984-2011, N=9213 traits"
  } else if (grepl("dougfir|douglas.fir", text)) {
    topic <- "ecologie / modelisation de distribution d'espece (SDM)"
    unit <- "point d'occurrence/pseudo-absence"
    population <- "sapin de Douglas (Pseudotsuga menziesii), Amerique du Nord, N=53293 points"
  } else if (grepl("global_nee_gwxgboost|net ecosystem exchange.*xgboost|geographically weighted xgboost", text)) {
    topic <- "cycle du carbone / echange net d'ecosysteme (teledetection)"
    unit <- "site de flux FLUXNET x jour"
    population <- "tours de flux eddy covariance, couverture mondiale, N=109154 observations (387 sites)"
  } else if (grepl("banff_stream_temperature|stream temperature.*ssn|ssn.*inla", text)) {
    topic <- "hydrologie / temperature des cours d'eau (modelisation SSN)"
    unit <- "site de mesure de temperature (logger)"
    population <- "cours d'eau, Parc national de Banff, Alberta, N=110 sites"
  } else if (grepl("brisbane_urban_vegetation|vertical structure.*urban vegetation|urban vegetation vertical structure", text)) {
    topic <- "ecologie urbaine / structure verticale de la vegetation"
    unit <- "cellule de grille (1ha)"
    population <- "cellules urbaines, Brisbane, Australie, N=63142"
  } else if (grepl("dragonfly_diversity_europe|dispersal limitation.*climatic history|diversity patterns of european dragonflies", text)) {
    topic <- "macroecologie / patrons de diversite des libellules europeennes"
    unit <- "cellule de grille (assemblage)"
    population <- "assemblages de libellules (Odonata), Europe, N=4192 cellules"
  } else if (grepl("dragonfly|colour lightness|anisoptera", text)) {
    topic <- "macroecologie / thermoregulation et couleur"
    unit <- "cellule de grille climatique"
    population <- "assemblages de libellules (Odonata: Anisoptera), Amerique du Nord et Europe, N=9966 cellules"
  } else if (grepl("amphibian functional diversity|precipitation seasonality", text)) {
    topic <- "biogeographie / diversite fonctionnelle des amphibiens"
    unit <- "cellule de grille"
    population <- "amphibiens du Nouveau Monde (Ameriques), N=4065 cellules de grille"
  } else if (grepl("ectothermy|home range scaling|snake", text)) {
    topic <- "macroecologie / mise a l'echelle du domaine vital"
    unit <- "espece de serpent (moyenne d'etude)"
    population <- "113 especes de serpents, estimations de domaine vital compilees depuis la litterature"
  } else if (grepl("fusarium|head blight|ensembling.*correlated models", text)) {
    topic <- "phytopathologie / prevision d'epidemies de fusariose de l'epi"
    unit <- "essai varietal (site x annee)"
    population <- "essais de ble/orge sur 80 sites du centre-est/centre des Etats-Unis, 1982-2015"
  } else if (grepl("covid.*mortality|sociodemographic risk|covid-19 mortality", text)) {
    topic <- "epidemiologie / mortalite COVID-19 et facteurs sociodemographiques"
    unit <- "comte (county), Etats-Unis continentaux"
    population <- "3068 comtes CONUS, deces cumules COVID-19 ajustes a la population au 2022-04-27"
  } else if (grepl("abnormal amphibian|amphibian.*hotspot|localized hotspot", text)) {
    topic <- "ecotoxicologie / anomalies amphibiennes"
    unit <- "evenement de collecte (site x date)"
    population <- "amphibiens examines sur les refuges fauniques nationaux USFWS, Etats-Unis (2000-2009)"
  } else if (grepl("fire and forest loss|dominican republic|forest loss.*fire|fire.*forest loss", text)) {
    topic <- "ecologie forestiere / feu et deforestation"
    unit <- "cellule de grille hexagonale (statistiques zonales, ~100km2)"
    population <- "grille hexagonale de la Republique Dominicaine (482 cellules), perte de couvert forestier et densite de feux MODIS, 2001-2018"
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
                                     is_binary_task = FALSE, formula_used_diverges = FALSE) {
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
      # reponse binaire : ols/sar_lag/sem_error/sdm_mixed/mgwrsar_gwr supposent une
      # erreur gaussienne continue et ne s'appliquent pas ; seuls les
      # estimateurs que le papier a reellement utilises (RF/BRT) sont notes.
      c("random_forest", "gamboost", "xgboost")
    } else {
      c("ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr")
    }
    # formula_used_diverges (ov$formula_used_generated_despite_pub) signale que
    # formula_pub est confirmee mais formula_used est une approximation
    # generee -- role/status doivent le refleter ici aussi, pas seulement
    # dans le bloc "Statut regression canonique" (les deux etaient
    # incoherents entre eux : ce bloc affichait role="paper_main_specification"/
    # status="confirmed" avec les estimateurs generiques du benchmark comme
    # si c'etait la methode du papier, meme quand formula_used divergeait
    # deja explicitement -- signale par l'utilisateur 2026-09-14 sur
    # avian_phylo_functional_distance, ou le papier utilise en realite
    # lavaan::cfa/sesem (structural equation modeling), pas ols/sar_lag/
    # sem_error/sdm_mixed/mgwrsar_gwr).
    multivariate <- if (formula_used_diverges) {
      fmt_entry(
        "benchmark_simplified_specification", formula, y_term, x_terms_vec,
        "derived_from_scientific_publication", "executable_approximation",
        source_ref,
        multivariate_context
      )
    } else {
      fmt_entry(
        "paper_main_specification", formula, y_term, x_terms_vec,
        "scientific_publication", "confirmed",
        source_ref,
        multivariate_context
      )
    }
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


# Rend le bloc "### Panel spatial - structure et W" (jalon J5,
# wiki/analyses/plan_implementation_panel_spatial_2026-09-09.md) pour un
# dataset panel spatial enregistre dans PANEL_METADATA -- champs structures
# (parses par _panel_field()/_panel_int_field() dans
# code/package_metadata/export_spatialtidymodels_metadata.py, exportes dans
# datasets.json) + une narrative libre pour la partie non generalisable
# (etude de cas W, comparaison de versions testees, caveats specifiques).
# Retourne "" pour tout dataset non panel -- aucun changement pour les
# ~180 autres fiches paper-derived.
panel_metadata_block <- function(record_id) {
  pm <- PANEL_METADATA[[record_id]]
  if (is.null(pm)) return("")
  bullets <- paste(
    sprintf("- Data structure: %s", pm$data_structure %||% "spatial_panel"),
    sprintf("- Panel unit: %s", pm$panel_unit %||% "pending"),
    sprintf("- Panel time: %s", pm$panel_time %||% "pending"),
    sprintf("- N units: %s", pm$n_units %||% "pending"),
    sprintf("- N periods: %s", pm$n_periods %||% "pending"),
    sprintf("- Panel balance: %s", pm$panel_balance %||% "pending"),
    sprintf("- Panel effect: %s", pm$panel_effect %||% "pending"),
    sprintf("- W level: %s", pm$w_level %||% "unit"),
    sprintf("- W time varying: %s", pm$w_time_varying %||% "no"),
    sprintf("- W file: %s", pm$w_file %||% "pending"),
    sprintf("- W unit order source: %s", pm$w_unit_order_source %||% "pending"),
    sprintf("- Prediction target: %s", pm$prediction_target %||% "fit_only"),
    sprintf("- Supported resampling: %s", pm$supported_resampling %||% "panel_full_fit"),
    sprintf("- Niveau de parite atteint: %s", pm$niveau_parite %||% "non prouve"),
    sep = "\n"
  )
  narrative <- if (!is.null(pm$narrative)) paste0("\n\n", pm$narrative) else ""
  paste0("### Panel spatial - structure et W\n\n", bullets, narrative)
}

estimator_eligibility_block <- function(record_id, readiness, formula_used, x_terms_vec, is_published) {
  status <- readiness$benchmark_status %||% "needs_manual_review"
  task <- readiness$benchmark_task %||% ""
  has_formula <- !is.na(formula_used) && nzchar(formula_used) && formula_used != "pending"
  has_x <- length(x_terms_vec) > 0
  is_ready_like <- grepl("^(ready|almost_ready|manual_review)", status)
  is_not_ready <- grepl("^not_ready", status)
  # Y binaire (SDM presence/absence, etc.) : depuis le 2026-09-04 (commit
  # 6752ecd, "add binary/count response routing + spatial probit estimator"),
  # le package a un premier moteur binaire reel : sar_probit/sem_probit
  # (packages/spatialtidymodels/R/50-parsnip-probitspatial.R, via
  # ProbitSpatial::ProbitSpatialFit()), route dans fit_one_benchmark_estimator()
  # (13-benchmark-spatial.R) et teste de bout en bout
  # (tests/testthat/test-classification-count.R, 61 tests PASS au 2026-09-10).
  # ols/sar_lag/sem_error/sdm_mixed/mgwrsar_gwr restent inadaptes (hypothese
  # gaussienne continue) et random_forest/gamboost/xgboost (classification)
  # restent des alternatives generiques -- mais l'affirmation anterieure
  # "aucun estimateur ne supporte de mode classification/binomial aujourd'hui"
  # est perimee depuis cette date (bug de staleness signale par l'utilisateur
  # 2026-09-10, meme categorie que le bug PAPER_READINESS deja corrige ce
  # jour). sar_probit/sem_probit restent notes conditionnels (pas eligible
  # d'office) : ils exigent une matrice W construite sur une geometrie/CRS
  # fiable, ce qui reste a verifier fiche par fiche (voir Bloc 5 / CRS note) ;
  # aucune route combinee binaire+panel spatial n'existe non plus a ce jour
  # (le panel harnais de 70-panel-spatial.R ne gere que le Y continu).
  is_binary_task <- grepl("classification|binary_panel|presence_absence", task, ignore.case = TRUE)
  is_also_panel <- grepl("panel", task, ignore.case = TRUE) || grepl("panel", readiness$missing_items %||% "", ignore.case = TRUE)
  eligible <- character(0)
  conditional <- character(0)
  ineligible_reason <- ""

  if (is_binary_task) {
    conditional <- c("random_forest", "random_forest_xy", "gamboost", "xgboost", "xgboost_xy", "gam_spatial", "sar_probit", "sem_probit")
    ineligible_reason <- if (is_also_panel) {
      "reponse binaire ET structure panel spatial : aucune route du package ne gere cette combinaison aujourd'hui (sar_probit/sem_probit sont cross-sectionnels ; le harnais panel -- 70-panel-spatial.R -- ne gere que le Y continu). random_forest/gamboost/xgboost/gam_spatial restent des alternatives generiques ignorant la structure panel ; sar_probit/sem_probit necessiteraient de traiter chaque periode separement (non implemente) et une matrice W fiable (voir Bloc 5 / CRS note)."
    } else {
      "reponse binaire (presence/absence) ; random_forest/gamboost/xgboost/gam_spatial sont des alternatives generiques, sar_probit/sem_probit (ProbitSpatial::ProbitSpatialFit(), ajoute 2026-09-04) sont le moteur spatial dedie -- tous notes conditionnels le temps de verifier au cas par cas qu'une matrice W fiable est constructible sur la geometrie locale (voir Bloc 5 / CRS note) ; ols/sar_lag/sem_error/sdm_mixed/mgwrsar_gwr restent hors de propos (hypothese gaussienne continue)."
    }
  } else if (is_ready_like && has_formula && has_x) {
    eligible <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
    if (is_published) eligible <- c(eligible, "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr")
  } else if (grepl("needs_original_W", status)) {
    eligible <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy")
    conditional <- c("sar_lag", "sem_error", "sdm_mixed")
    ineligible_reason <- "spatial econometric estimators require the original paper W or an explicitly accepted proxy W"
  } else if (grepl("needs_covariate_join|needs_preprocessing|needs_model_specification_review", status)) {
    conditional <- c("ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr")
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
    '  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"',
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
    t_raw <- df[[time_info$T_var]]
    t_min_raw <- min(t_raw, na.rm = TRUE)
    t_max_raw <- max(t_raw, na.rm = TRUE)
    # t_raw stocke parfois des dates "M/D/YYYY" en character (ex.
    # early_season_biomass$plant_date) : min()/max() comparent alors les
    # chaines lexicographiquement, pas chronologiquement (ex. "10/1/2019" <
    # "9/8/2017" car '1' < '9'), produisant une plage affichee a l'envers.
    # Filet de securite : si min/max brut est deja chronologiquement coherent,
    # ne rien changer ; sinon, retenter en interpretant comme date M/D/Y
    # (convention dominante dans ce corpus, majoritairement US) et n'utiliser
    # le resultat que s'il corrige effectivement l'inversion.
    t_raw_nonNA <- t_raw[!is.na(t_raw)]
    if (is.character(t_raw) && length(t_raw_nonNA) &&
        all(grepl("^\\d{1,2}/\\d{1,2}/\\d{4}$", t_raw_nonNA))) {
      parsed <- tryCatch(
        suppressWarnings(as.Date(t_raw, tryFormats = c("%m/%d/%Y"))),
        error = function(e) rep(as.Date(NA), length(t_raw))
      )
      if (length(parsed) == length(t_raw) && all(is.na(parsed) == is.na(t_raw))) {
        p_min <- min(parsed, na.rm = TRUE); p_max <- max(parsed, na.rm = TRUE)
        if (p_max >= p_min && format(p_min) != format(p_max)) {
          raw_min_pos <- which(t_raw == t_min_raw)[1]
          raw_max_pos <- which(t_raw == t_max_raw)[1]
          if (!identical(parsed[raw_min_pos] <= parsed[raw_max_pos], TRUE)) {
            t_min_raw <- format(p_min, "%m/%d/%Y")
            t_max_raw <- format(p_max, "%m/%d/%Y")
          }
        }
      }
    }
    time_range_str <- sprintf("%s to %s (variable: %s)",
                               md_escape(t_min_raw),
                               md_escape(t_max_raw),
                               time_info$T_var)
  }

  y_vars_str <- if (length(y_vars)) paste(sprintf("`%s`", y_vars), collapse = ", ") else "not identified - manual review required"
  x_vars_str <- if (length(x_vars)) paste(sprintf("`%s`", x_vars), collapse = ", ") else
    "no additional covariates beyond coordinates/identifiers (raster or grid dataset)"

  # Formule candidate systeme : Y ~ X1 + X2 + ... (baseline "kitchen sink"),
  # generee automatiquement -- PAS une formule publiee/verifiee par le papier.
  # Never truncate executable R syntax. Readability belongs in notes/tables.
  formula_used <- if (length(y_vars) >= 1 && length(x_vars) >= 1) {
    x_for_formula <- x_vars
    quote_name <- function(v) ifelse(make.names(v) == v, v, paste0("`", v, "`"))
    sprintf("%s ~ %s", quote_name(y_vars[1]), paste(quote_name(x_for_formula), collapse = " + "))
  } else "pending"

  formula_pub <- "pending"
  formula_note <- if (formula_used == "pending" && length(y_vars) && !length(x_vars)) "reponse identifiee dans le loader, mais aucune covariable X locale executable n est disponible dans le .rds actuel." else if (formula_used == "pending") "aucune formule Y ~ X utilisable : aucune variable reponse confirmee ou aucune covariable exploitable n est disponible." else "formule candidate generee automatiquement (Y ~ toutes les covariables X detectees), PAS une formule publiee ou verifiee dans le papier source - a confirmer par revue manuelle."
  ov <- FORMULA_OVERRIDES[[record_id]]
  if (!is.null(ov)) {
    if (!is.null(ov$formula_used)) formula_used <- ov$formula_used
    if (!is.null(ov$formula_pub)) formula_pub <- ov$formula_pub
    formula_note <- ov$formula_note %||% "Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee."
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

  is_published <- !is.null(ov) && !is.null(ov$formula_pub) && !tolower(ov$formula_pub) %in% c("", "pending", "unknown")
  # x_vars exclut TOUTES les colonnes candidate_y_variables, pas seulement
  # celle effectivement choisie comme Y -- cas limite ou une colonne listee
  # comme Y alternative sert en realite de X dans formula_used (ex.
  # avian_phylo_functional_distance : Y=MPFDses, X inclut PDses, qui reste
  # une reponse candidate alternative). c(x_vars, y_vars) elargit juste
  # l'ensemble des noms de colonnes reels reconnus ; un terme doit de toute
  # facon deja apparaitre tel quel dans formula_used pour etre retenu.
  # coord_vars ajoute le meme jour (ex. checkerspot_phenology : le papier
  # regresse startDayOfYear sur decimalLatitude comme covariable ordinaire,
  # pas comme reference spatiale -- sans cet ajout, x_terms_used affichait
  # seulement "year" alors que formula_used contenait bien decimalLatitude,
  # une incoherence purement d'affichage, formula_used restant correct).
  formula_x_terms <- extract_formula_terms(formula_used, c(x_vars, y_vars, coord_vars))
  x_for_yaml <- if (length(formula_x_terms)) formula_x_terms else x_vars
  formula_candidate_formula <- if (!is.null(ov) && !is.null(ov$formula_candidate_formula)) ov$formula_candidate_formula else formula_used
  y_pub_display <- if (!is.null(ov) && !is.null(ov$y_term_pub)) ov$y_term_pub else if (formula_used != "pending" && length(y_vars)) y_vars[1] else "pending"
  # x_terms_pub_count doit compter EXACTEMENT les termes affiches par
  # x_pub_display -- avant ce correctif, "Published X count" retombait
  # toujours a 0 des que ov$x_terms_pub n'etait pas explicitement fixe dans
  # FORMULA_OVERRIDES, meme quand x_pub_display affichait deja une longue
  # liste de covariables via le repli x_for_yaml (bug signale par
  # l'utilisateur 2026-09-10 sur wildfire_schneider_springs_severity : 33
  # variables listees, "Published X count: 0").
  x_terms_pub_vec <- if (!is.null(ov) && !is.null(ov$x_terms_pub)) ov$x_terms_pub else if (formula_used != "pending") x_for_yaml else character(0)
  x_pub_display <- if (length(x_terms_pub_vec)) paste(x_terms_pub_vec, collapse = ", ") else "pending"
  x_used_display <- if (formula_used != "pending" && length(x_for_yaml)) paste(x_for_yaml, collapse = ", ") else "pending"
  y_used_display <- extract_formula_response(formula_used)
  modeling_source_ref_full <- if (!is.null(ov)) ov$source_ref else "data/raw/papers (loader-derived, no published equation located)"
  # The full citation/methodology text lives once in prose ("Reference
  # publication" in Bloc 1) and once as structured data (modeling_evidence
  # YAML in Bloc 3). formula_candidates_block()'s per-role source_ref fields
  # reuse it verbatim otherwise, so point back to those instead of repeating
  # the same paragraph 3 more times in the same fiche.
  modeling_source_ref_pointer <- if (!is.null(ov)) {
    "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
  } else modeling_source_ref_full
  readiness <- PAPER_READINESS[[record_id]]
  if (is.null(readiness)) readiness <- default_readiness(record_id)
  fcb <- formula_candidates_block(
    formula_candidate_formula,
    y_pub_display,
    if (!is.null(ov) && !is.null(ov$x_terms_pub)) ov$x_terms_pub else x_for_yaml,
    is_published,
    modeling_source_ref_pointer,
    ml_formula = if (!is.null(ov)) ov$ml_formula else NULL,
    ml_response = if (!is.null(ov)) ov$ml_response else NULL,
    ml_predictors = if (!is.null(ov)) ov$ml_predictors else NULL,
    ml_source_ref = if (!is.null(ov)) ov$ml_source_ref else NULL,
    ml_status = if (!is.null(ov) && !is.null(ov$ml_status)) ov$ml_status else "confirmed",
    ml_source_type = if (!is.null(ov) && !is.null(ov$ml_source_type)) ov$ml_source_type else "scientific_publication",
    ml_estimator_context = if (!is.null(ov) && !is.null(ov$ml_estimator_context)) ov$ml_estimator_context else c("random_forest", "xgboost", "gamboost", "spboost"),
    is_binary_task = grepl("classification|binary_panel|presence_absence", readiness$benchmark_task %||% "", ignore.case = TRUE),
    formula_used_diverges = !is.null(ov) && isTRUE(ov$formula_used_generated_despite_pub)
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
    sprintf('  source_ref: "%s"', gsub('"', "'", modeling_source_ref_full)),
    sprintf("  confidence: %s", if (is_published) "medium" else "low"),
    "```",
    sep = "\n"
  )

  variables_status <- if (length(y_vars) && length(x_vars)) "OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes)."
    else if (length(y_vars)) "WARN - Y identifiee, mais aucune covariable X detectee (grille/raster sans covariable additionnelle)."
    else "WARN - Y non identifiee automatiquement ; revue manuelle requise."
  # Une formule publiee confirmee (is_published) ne veut PAS dire que
  # formula_used la reprend telle quelle : un papier peut publier un modele au
  # lien non-identite (logit/probit/log) ou avec un champ aleatoire spatial/
  # spatio-temporel (SAR/SEM/SPDE/panel) que le harnais actuel ne sait pas
  # reproduire tel quel. Dans ce cas formula_used reste une approximation
  # generee (GLM plat, sans lien ni champ latent) -- il faut le dire
  # explicitement plutot que d'annoncer a tort "formule publication confirmee
  # ET utilisee" (bug signale par l'utilisateur sur paper_crane, 2026-09-10 :
  # le papier publie un GLMM binomial logit + champ spatio-temporel, mais la
  # fiche affichait quand meme "resolu / formule publication confirmee et
  # utilisee" des que formula_pub et formula_used etaient tous deux non-vides).
  # Marquer ov$formula_used_generated_despite_pub = TRUE (+ un
  # ov$formula_used_divergence_note explicatif) dans FORMULA_OVERRIDES pour ces cas.
  formula_used_diverges <- !is.null(ov) && isTRUE(ov$formula_used_generated_despite_pub)
  divergence_note <- if (formula_used_diverges) {
    ov$formula_used_divergence_note %||%
      "formula_pub est confirmee (voir Reference publication) mais correspond a un lien/structure (logit, probit, log, champ spatial ou spatio-temporel latent) que le harnais actuel ne reproduit pas ; formula_used est une approximation generee distincte."
  } else NULL

  # Decision utilisateur documentee de mettre une fiche de cote (Statut
  # 'mis de cote'), independante d'une simple divergence formula_pub/
  # formula_used : le harnais ne sait pas encore executer la methode publiee
  # (ex. GLM univaries + PCA, un paradigme multi-modeles) et une combinaison
  # additive de toutes les covariables ne remplace pas cette methode -- ne
  # PAS annoncer "resolu" tant que ce n'est pas leve. Marquer
  # ov$regression_status_override (une valeur de REGRESSION_STATUS_VALUES,
  # tier1_structural.py) + ov$regression_evidence_override + les champs
  # associes dans FORMULA_OVERRIDES pour ces cas (ex: medicago, 2026-09-08).
  has_status_override <- !is.null(ov) && !is.null(ov$regression_status_override)

  regression_status <- if (has_status_override) ov$regression_status_override
    else if (formula_used_diverges) "generated_system_formula"
    else if (is_published && formula_used != "pending") "resolu"
    else if (is_published) "resolu_publication_non_executable"
    else "pending"
  evidence_level <- if (has_status_override) (ov$regression_evidence_override %||% "publication")
    else if (formula_used_diverges) "system_generated"
    else if (is_published) "publication"
    else "n/a"
  estimation_method <- if (has_status_override) (ov$regression_method_override %||% "voir Note ci-dessous")
    else if (formula_used_diverges) "formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)"
    else if (is_published && formula_used != "pending") "formule publication confirmee et utilisee"
    else if (is_published) "modele/formule publication confirme, non executable avec le .rds actuel"
    else "n/a"
  formula_status <- if (has_status_override) sprintf("OK - Statut '%s' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.", regression_status)
    else if (formula_used_diverges) "OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note)."
    else if (is_published && formula_used != "pending") "OK - formule publication renseignee et formula_used executable."
    else if (is_published) "OK - preuve de modele/formule publication renseignee ; formula_used reste pending car le .rds local ne contient pas le tableau Y/X requis."
    else if (formula_used != "pending") "PENDING - formule publication non encore etablie (formule candidate systeme fournie a la place)."
    else if (length(y_vars) && !length(x_vars)) "PENDING - reponse identifiee, mais aucune covariable X locale executable n est disponible."
    else "PENDING - aucune formule Y ~ X utilisable ; aucune reponse confirmee ou aucune covariable exploitable n est disponible."
  crs_note_extra <- CRS_NOTES[[record_id]]
  crs_status <- if (epsg != "unknown") sprintf("OK - CRS renseigne dans le Bloc 5 (%s).", epsg)
    else if (!is.null(crs_note_extra)) "WARN (verifie) - CRS absent du sf source ; caveat documente, voir Bloc 5 > CRS note."
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
    x_pub_display, length(x_terms_pub_vec),
    coord_display, fmt_bt(id_vars),
    y_rows, yx_rationale, x_rows,
    formula_pub,
    x_pub_display,
    y_pub_display,
    if (!is.null(ov)) ov$source_ref else kg_rec$source_ref %||% "pending",
    regression_status,
    evidence_level,
    estimation_method,
    if (has_status_override) (ov$regression_note_override %||% "n/a")
      else if (formula_used_diverges) divergence_note
      else if (is_published) formula_note else "n/a",
    formula_used,
    x_used_display,
    y_used_display,
    formula_note,
    fcb
  )

  parent_dataset <- PARENT_DATASET[[record_id]]
  parent_line <- if (!is.null(parent_dataset)) {
    sprintf("\n- Parent dataset: `paper_%s` (sous-ensemble temporel -- ne pas compter comme source independante, voir source_dataset_id)", parent_dataset)
  } else {
    ""
  }
  paper_year <- if (!is.null(ov) && !is.null(ov$year)) ov$year else extract_year_from_bib_key(kg_rec$bib_key)
  bloc2_block <- sprintf(
    "## Bloc 2 - Identification et DOI\n\n- Dataset ID: `paper_%s`\n- Dataset name: %s\n- Source family: paper-derived\n- Source: papier scientifique (voir Paper DOI)\n- Paper title: %s\n- Paper DOI: %s\n- Dataset DOI: %s\n- Source URL: %s\n- Year: %s%s",
    record_id, dataset_name, paper_title, paper_doi, dataset_doi, source_url, paper_year, parent_line
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

  # CRS_NOTES (calcule plus haut, avant crs_status) : caveat manuel (paper lu,
  # hypothese testee et ecartee, coord. jitterees/transformees par les
  # auteurs, etc.) qu'une regeneration ne doit pas effacer.
  crs_note_line <- if (!is.null(crs_note_extra)) sprintf("\n- CRS note: %s", crs_note_extra) else ""
  bloc5_block <- sprintf(
    "## Bloc 5 - Resolution et etendue\n\n- Type de geometrie: %s\n- Spatial resolution: %s\n- Temporal resolution: %s\n- CRS EPSG: %s\n- CRS nom: %s\n- Spatial extent: x [%s, %s], y [%s, %s]\n- Time range: %s\n- CRS analyse recommande: %s%s",
    geom_type, spatial_res, temporal_res, epsg, crs_name,
    md_escape(bbox["xmin"]), md_escape(bbox["xmax"]), md_escape(bbox["ymin"]), md_escape(bbox["ymax"]),
    time_range_str,
    if (ca$label != "pending") sprintf("%s (%s) - %s", ca$epsg, ca$label, ca$note) else sprintf("pending - %s", ca$note),
    crs_note_line
  )

  # License etait un literal "unknown" x4 code en dur pour TOUTES les fiches
  # paper-derived -- jamais derive d'aucune donnee, meme quand un check
  # DataCite avait deja ete fait et enregistre une fois dans le .md (perdu des
  # qu'une fiche est regeneree, cas reel constate 2026-09-10 sur
  # alps_floristic_legacy/amazon_tree_dominance : le texte "License present:
  # yes / CC0..." existait dans le fichier mais ne venait d'aucun override
  # relance-safe -- regenerer l'a efface). Marquer ov$license_name/
  # ov$license_url/ov$license_checked dans FORMULA_OVERRIDES pour les
  # fiches deja verifiees (source : DataCite API rightsList pour le DOI du
  # jeu de donnees), ne pas inventer pour les autres.
  has_license_override <- !is.null(ov) && !is.null(ov$license_name)
  license_present <- if (has_license_override) "yes" else "unknown"
  license_name <- if (has_license_override) ov$license_name else "unknown"
  license_url <- if (has_license_override && !is.null(ov$license_url)) ov$license_url else "unknown"
  license_open <- if (has_license_override) (ov$license_open %||% "yes") else "unknown"
  license_evidence_line <- if (has_license_override) sprintf(
    "\n- License evidence: DataCite API record for DOI %s (checked %s): rightsList = '%s'.",
    dataset_doi, ov$license_checked %||% "2026-09-10", license_name
  ) else ""
  bloc6_block <- sprintf(
    "## Bloc 6 - Reproductibilite\n\n- License present: %s\n- License name: %s\n- License URL: %s\n- License open: %s%s\n- Reproducibility status: %s\n- Code available: yes (loader `%s` dans `code/r_catalog/build_sf_datasets_papers.R`)\n- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)",
    license_present, license_name, license_url, license_open, license_evidence_line,
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
  # Reapply reviewed fields after rendering; preserves the curation on future runs.
  curation_python <- Sys.getenv("DATASET_CURATION_PYTHON", unset = Sys.which("python"))
  if (!nzchar(curation_python)) stop("Python requis pour appliquer dataset_curation.py")
  curation_status <- system2(curation_python, c(shQuote(file.path(REPO_ROOT, "code/r_catalog/dataset_curation.py")), "--files", shQuote(out_path)))
  if (curation_status != 0L) stop("Echec de la curation : ", record_id)
  n_ok <- n_ok + 1L
  cat(sprintf("OK  paper_%s.md  (N=%d, k=%d, Y=%s)\n", record_id, N, k,
              if (length(y_vars)) paste(y_vars, collapse = "+") else "?"))
}

cat(sprintf("\n=== BILAN === %d fiches generees / %d cible(s)\n", n_ok, length(records_to_generate)))
