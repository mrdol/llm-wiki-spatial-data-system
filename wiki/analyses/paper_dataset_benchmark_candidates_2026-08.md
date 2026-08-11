---
title: "Paper Dataset Benchmark Candidates"
type: analysis
created: 2026-08-09
tags: [papers, datasets, benchmark, curation]
---

# Paper Dataset Benchmark Candidates

Ce rapport resume le manifeste central de curation des datasets issus de papiers.
Il ne promeut aucun dataset vers le package : il sert a decider quoi verifier, telecharger, pretraiter ou rejeter.

## Sorties

- CSV Excel (`;`) : `data/manifests/papers/paper_dataset_benchmark_candidates.csv`
- JSON : `data/manifests/papers/paper_dataset_benchmark_candidates.json`

## Bilan

- Candidats consolides : 194
- Priorite `high` : 6
- Priorite `low` : 82
- Priorite `medium` : 106

## Statuts benchmark

- `almost_ready` : 4
- `almost_ready_simulation` : 1
- `manual_review_derived_reconstruction` : 3
- `needs_covariate_join` : 1
- `needs_dataset_identification` : 66
- `needs_grobid_kg_review` : 24
- `needs_model_specification_review` : 1
- `needs_original_W` : 1
- `needs_preprocessing` : 1
- `needs_reconciliation` : 72
- `needs_response_reconstruction` : 1
- `not_ready_current_package` : 7
- `not_ready_derived_clusters` : 1
- `not_ready_derived_response` : 1
- `not_ready_geostatistical_univariate` : 2
- `not_ready_relevance_check` : 1
- `ready` : 7

## Candidats prioritaires

| priority | dataset | paper | status | next step |
|---|---|---|---|---|
| high | paper_rocha_agricultural_technology_brazil | Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCit | ready | Y continu/rate, covariables climatiques/distances et geometrie municipale sont disponibles; formule locale disponible da |
| high | paper_marrot_spatial_autocorrelation_fitness | Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCit | ready | Y/X, coordonnees et N sont confirmes; formule locale disponible dans le KG et les donnees converties en sf. |
| high | paper_li_energy_price_co2_china | Li, K., Fang, L., He, Q. (2020) "The Impact of Energy Price on CO2 Emissions in  | ready | Y/X et formule publiee sont confirmes; le RDS benchmark utilise la coupe 2016 pour rester compatible avec le benchmark s |
| high | paper_teles_decapod_biodiversity_brazil | Teles & Mantelatto (2025), Journal of Biogeography / Dryad description and TEI:  | ready | Y biodiversite continue, covariables environnementales et coordonnees sont disponibles; modele RF et diagnostics Moran d |
| high | paper_velado_alonso_wildlife_livestock_diversity | Velado-Alonso, E., Morales-Castilla, I., Rebollo, S., Gomez-Sal, A. (2020) "Rela | ready | Y/X clairement identifies et coherents avec le papier. Le RDS benchmark contient des centroides projetes en EPSG:3035 po |
| high | paper_wang_henan_cultivated_land_quality | Wang, H., Zhu, Y., Wang, J., Han, H., Niu, J., Chen, X. (2022) "Modeling of spat | ready | RDS final disponible avec noms R-safe, geometrie de comtes et centroides projetes en EPSG:32650. Effective soil thicknes |
| medium | Replication data for: A Rational Expectations Approach to Hedonic Price Regressi | A Rational Expectations Approach to Hedonic Price Regressions with Time-Varying  | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Replication data for: A Rational Expectations Approach to Hedonic Price Regressi | A Rational Expectations Approach to Hedonic Price Regressions with Time-Varying  | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | A bootstrap test for constant coefficients in geographically weighted regression | A bootstrap test for constant coefficients in geographically weighted regression | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | A bootstrap test for constant coefficients in geographically weighted regression | A bootstrap test for constant coefficients in geographically weighted regression | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Beta0 for the geographically weighted regressions | A global dataset of air temperature derived from satellite remote sensing and we | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key  | Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key  | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Agricultural technology adoption and land use: evidence for Brazilian municipali | Agricultural technology adoption and land use: evidence for Brazilian municipali | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Daily, Monthly, and Annual 8-Hour Maximum O3 Concentrations for the Contiguous U | An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of G | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Daily, Monthly, and Annual PM2.5 Concentrations for the Contiguous United States | An ensemble-based model of PM2.5 concentration across the contiguous United Stat | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Daily, Monthly, and Annual NO2 Concentrations for the Contiguous United States,  | Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Reso | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Transformed crane data from: Balancing structural complexity with ecological ins | Balancing structural complexity with ecological insight in Spatio-temporal speci | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | paper_uk_photovoltaic | Balta-Ozkan, Yildirim & Connor (2015), Energy Economics — famille de modeles eco | needs_preprocessing | rebuild from NUTS3 and join paper covariates |
| medium | paper_mammals_sr_pd | Barreto, Graham & Rangel (2019), Global Ecology and Biogeography, Figure 1 — mod | almost_ready | choose SR or PD target and verify variable names against paper/code |
| medium | Bayesian Model Averaging for Spatial Autoregressive Models Based on Convex Combi | Bayesian Model Averaging for Spatial Autoregressive Models Based on Convex Combi | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Bayesian Model Averaging for Spatial Autoregressive Models Based on Convex Combi | Bayesian Model Averaging for Spatial Autoregressive Models Based on Convex Combi | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Integrating diverse data for robust species distribution models in a  | Building use-inspired species distribution models: Using multiple data types to  | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Data from: Integrating diverse data for robust species distribution models in a  | Building use-inspired species distribution models: Using multiple data types to  | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data for: Climatic and management-related drivers of endemic European spruce bar | Climatic and management-related drivers of endemic European spruce bark beetle p | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Dataset for: Cluster Detection of Spatial Regression Coefficients | Cluster detection of spatial regression coefficients | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Building a sustainable development index and spacial assessment of municipalitie | Construção de um índice de desenvolvimento sustentável e análise espacial das de | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Cost estimation using ANFIS | Cost estimation using ANFIS | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Cost estimation using ANFIS | Cost estimation using ANFIS | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with F | Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with F | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with F | Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with F | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data and R code for: Biogeography and conservation of bycatch decapods | Data and R code for: Biogeography and conservation of bycatch decapods | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Determinants and spatial dependence of innovation in Brazilian regions: evidence | Determinants and spatial dependence of innovation in Brazilian regions: evidence | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | paper_spruce_bark_beetle | Dryad README for Gohli et al. (2024), dataset 10.5061/dryad.kd51c5bdc: trap coun | almost_ready | Y=trapcounts, covariables documentees, coordonnees WGS84 et N=1731 sont disponibles dans le README Dryad. |
| medium | paper_possum_body_size | Dryad dataset 10.5061/dryad.gq264: continuous body-size response CBL with coordi | almost_ready | Y=CBL continu, coordonnees et covariables environnementales disponibles; la formule exacte n'est pas encore prouvee par  |
| medium | Data from: Environmental factors explain the spatial mismatches between species  | Environmental factors explain the spatial mismatches between species richness an | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Dataset for: Estimation and inference in spatially varying coefficient models | Estimation and inference in spatially varying coefficient models | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Dataset for: Estimation and inference in spatially varying coefficient models | Estimation and inference in spatially varying coefficient models | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Omaha Property Values and GI | Examining the effects of green infrastructure on residential sales prices in Oma | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Omaha Property Values and GI | Examining the effects of green infrastructure on residential sales prices in Oma | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Generalized Spatially Varying Coefficient Models | Generalized Spatially Varying Coefficient Models | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Geographically neural network weighted regression for the accurate estimation of | Geographically neural network weighted regression for the accurate estimation of | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Geographically neural network weighted regression for the accurate estimation of | Geographically neural network weighted regression for the accurate estimation of | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Global patterns of taxonomic uncertainty and its impacts on biodiversity researc | Global Patterns of Taxonomic Uncertainty and its Impacts on Biodiversity Researc | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Global patterns of taxonomic uncertainty and its impacts on biodiversity researc | Global Patterns of Taxonomic Uncertainty and its Impacts on Biodiversity Researc | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Global distribution maps of the Leishmaniases | Global distribution maps of the leishmaniases | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Data from: Global distribution maps of the Leishmaniases | Global distribution maps of the leishmaniases | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Table 1 in Global diversity of island floras from a macroecological perspective | Global diversity of island floras from a macroecological perspective | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Global variation in the relationship between avian phylogenetic diver | Global variation in the relationship between avian phylogenetic diversity and fu | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Data from: Global variation in the relationship between avian phylogenetic diver | Global variation in the relationship between avian phylogenetic diversity and fu | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Arequipa Climate Maps - Normals (Version 1) | How do Indigenous and local knowledge systems respond to climate change? | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Integrated species distribution models fitted in INLA are sensitive t | Integrated species distribution models fitted in INLA are sensitive to mesh para | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Data from: Integrated species distribution models fitted in INLA are sensitive t | Integrated species distribution models fitted in INLA are sensitive to mesh para | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Integrated species distribution models to account for sampling biases | Integrated species distribution models to account for sampling biases and improv | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | paper_wald_test | Juhl (2021), Political Analysis — Spatial Durbin Model (SDM), sous-echantillon ' | needs_original_W | extract original W or mark as non-geographic-W benchmark |
| medium | paper_pallid_bat | Kelly, Friedman & Santana (2018), Functional Ecology — test de la regle de Bergm | needs_covariate_join | join NPP/climate variables or keep unavailable |
| medium | Data from: Lean-season primary productivity and heat dissipation as key drivers  | Lean-season primary productivity and heat dissipation as key drivers of geograph | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | paper_cluster_detection | Lee, Gangnon & Zhu (2016), Statistics in Medicine, eq. (1)-(2) — modele a coeffi | almost_ready_simulation | decide if simulation benchmarks are allowed; otherwise keep as method validation only |
| medium | MetaComNet: A random forest-based framework for making spatial prediction of pla | MetaComNet: A random forest-based framework for making spatial predictions of pl | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Method of the Geographically Weighted Regression and an Example for its Applicat | Method of the Geographically Weighted Regression and an Example for its Applicat | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Method of the Geographically Weighted Regression and an Example for its Applicat | Method of the Geographically Weighted Regression and an Example for its Applicat | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Mistletoes could moderate drought impacts on woodland birds, but are themselves  | Mistletoes could moderate drought impacts on birds, but are themselves susceptib | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Mistletoes could moderate drought impacts on woodland birds, but are themselves  | Mistletoes could moderate drought impacts on birds, but are themselves susceptib | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Model selection and model averaging for matrix exponential spatial models | Model selection and model averaging for matrix exponential spatial models | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data for: Modeling of spatial pattern and influencing factors of cultivated land | Modeling of spatial pattern and influencing factors of cultivated land quality i | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Niche conservatism limits the distribution of Medicago in the tropics | Niche conservatism limits the distribution of Medicago in the tropics | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | The impact of cooperatives on Brazilian agricultural production: a spatial econo | O impacto das cooperativas na produção agropecuária brasileira: uma análise econ | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Swiss rainfall | Oblique geographic coordinates as covariates for digital soil mapping | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Vindum | Oblique geographic coordinates as covariates for digital soil mapping | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | eberg | Oblique geographic coordinates as covariates for digital soil mapping | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Airbnb Canary Islands | On the determinants of Airbnb location and its spatial distribution | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data for: On the use of Hedonic Regression Models to Measure the Effect of Energ | On the use of hedonic regression models to measure the effect of energy efficien | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Data for: On the use of Hedonic Regression Models to Measure the Effect of Energ | On the use of hedonic regression models to measure the effect of energy efficien | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Additional file 3: of Patterns of livestock activity on heterogeneous subalpine  | Patterns of livestock activity on heterogeneous subalpine pastures reveal distin | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Additional file 3: of Patterns of livestock activity on heterogeneous subalpine  | Patterns of livestock activity on heterogeneous subalpine pastures reveal distin | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Primary productivity explains size variation across the Pallid bat's  | Primary productivity explains size variation across the Pallid bat's western geo | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data for: Regional distribution of photovoltaic deployment in the UK and its det | Regional distribution of photovoltaic deployment in the UK and its determinants: | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Replication Data for: Regulatory Convergence in the Financial Periphery: How Int | Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Re | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Relationships between the distribution of wildlife and livestock diversity | Relationships between the distribution of wildlife and livestock diversity | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Spatial structure of above-ground biomass limits accuracy of carbon m | Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in R | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Spatial autocorrelation in fitness affects the estimation of natural  | Spatial autocorrelation in fitness affects the estimation of natural selection i | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Spatial distribution of wood volume in Brazilian savannas | Spatial distribution of wood volume in Brazilian savannas | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Maipo | Spatial machine-learning model diagnostics: a model-agnostic distance-based appr | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Additional file 2 of Spatial trends and projections of chronic malnutrition amon | Spatial trends and projections of chronic malnutrition among children under 5 ye | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Spatially Varying Coefficient Model for Neuroimaging Data With Jump Discontinuit | Spatially Varying Coefficient Model for Neuroimaging Data With Jump Discontinuit | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: Spatio-temporal Bayesian model selection for disease mapping | Spatio-temporal Bayesian model selection for disease mapping | needs_grobid_kg_review | run GROBID, extract formula/model evidence, then decide if a dataset fiche is warranted |
| medium | Data from: Spatio-temporal Bayesian model selection for disease mapping | Spatio-temporal Bayesian model selection for disease mapping | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Structure identification and variable selection in geographically weighted regre | Structure identification and variable selection in geographically weighted regre | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Structure identification and variable selection in geographically weighted regre | Structure identification and variable selection in geographically weighted regre | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Replication Data for: Systematic Variation in Waste Site Effects on Residential  | Systematic Variation in Waste Site Effects on Residential Property Values: A Met | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data from: The assembly of ecological communities inferred from taxonomic and fu | The Assembly of Ecological Communities Inferred from Taxonomic and Functional Co | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | The GWmodel R package: further topics for exploring spatial heterogeneity using  | The GWmodel R package: further topics for exploring spatial heterogeneity using  | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | The Importance of Scale in Spatially Varying Coefficient Modeling | The Importance of Scale in Spatially Varying Coefficient Modeling | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | The Importance of Scale in Spatially Varying Coefficient Modeling | The Importance of Scale in Spatially Varying Coefficient Modeling | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts  | The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts  | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts  | The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts  | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Replication Data for: The Wald Test of Common Factors in Spatial Model Specifica | The Wald Test of Common Factors in Spatial Model Specification Search Strategies | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Data for: Assessing the impact of energy price on China's carbon emissions: A sp | The impact of energy price on CO2 emissions in China: A spatial econometric anal | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Berlin | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Clearwater | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | KingHousePrices | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | NYCAirBnb | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Tokyo | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | VaucluseHousePrice | Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Trade-offs between biodiversity and agriculture are moving targets in dynamic la | Trade-offs between biodiversity and agriculture are moving targets in dynamic la | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Trade-offs between biodiversity and agriculture are moving targets in dynamic la | Trade-offs between biodiversity and agriculture are moving targets in dynamic la | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | sj-csv-2-epb-10.1177_23998083211063885 - Supplemental Material for Uncovering sp | Uncovering spatial heterogeneity in real estate prices via combined hierarchical | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | sj-csv-2-epb-10.1177_23998083211063885 - Supplemental Material for Uncovering sp | Uncovering spatial heterogeneity in real estate prices via combined hierarchical | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | Women's political empowerment and welfare policy decisions: a spatial analysis o | Women's political empowerment and welfare policy decisions: a spatial analysis o | needs_grobid_kg_review | No automated OA PDF found (status=not_downloaded). Needs a manual, legitimate download (institutional access, author cop |
| medium | Women's political empowerment and welfare policy decisions: a spatial analysis o | Women's political empowerment and welfare policy decisions: a spatial analysis o | needs_reconciliation | inspect source dataset and create or update fiche if benchmarkable |
| medium | paper_florida_crash_gsvcm | Wu et al. (2020), supplementary script Code/main_GSVCM_application.R: y=Offcrsh, | almost_ready | Le script supplementaire donne explicitement Y, X et coordonnees; reponse Offcrsh est un compte. |
| medium | paper_medicago | Yang, Bian, Ren, Liu & Shrestha (2022), Ecography e06085 — GWR quantifiant les e | needs_model_specification_review | review TEI/tables/code to select a defensible formula |
| medium | paper_biomass_rainforest | pending | needs_response_reconstruction | reconstruct/extract AGB/AGC and join environmental covariates |
