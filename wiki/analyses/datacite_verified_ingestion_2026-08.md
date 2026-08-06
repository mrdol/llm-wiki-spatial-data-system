# Ingestion des candidats DataCite valides

Date : 2026-08-06

- Candidats initiaux : **29**
- PDF locaux conserves pour la suite : **24**
- Rejets apres verification manuelle : **5**

Les 24 lignes conservees poursuivent le pipeline: PDF -> GROBID -> TEI -> KG -> fiche dataset.
Les 5 rejets restent traces dans les manifestes, mais sont exclus de la suite automatique.

## Conserves

| DOI article | Article | PDF local |
|---|---|---|
| 10.1002/sim.7172 | Cluster detection of spatial regression coefficients | `corpus\papers\raw_pdf\Cluster detection of spatial regression coefficients.pdf` |
| 10.1007/s10640-021-00536-2 | Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer | `corpus\papers\raw_pdf\Systematic Variation in Waste Site Effects on Residential Property Values - A Meta-Regression Analysis and Benefit Transfer.pdf` |
| 10.1016/j.eneco.2015.08.003 | Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach | `corpus\papers\raw_pdf\Regional distribution of photovoltaic deployment in the UK and its determinants A spatial econometric approach.pdf` |
| 10.1016/j.envint.2019.104909 | An ensemble-based model of PM2.5 concentration across the contiguous United States with high spatiotemporal resolution | `corpus\papers\raw_pdf\An ensemble-based model of PM2.5 concentration across the contiguous united states with high spatiotemporal resolution.pdf` |
| 10.1017/pan.2020.23 | The Wald Test of Common Factors in Spatial Model Specification Search Strategies | `corpus\papers\raw_pdf\Juhl_2021_WaldTestCommonFactorsSpatialModelSpecification.pdf` |
| 10.1021/acs.est.0c01791 | An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States | `corpus\papers\raw_pdf\AnEnsembleLearningApproachforEstimatingHighSpatiotemporalResolution.pdf` |
| 10.1021/acs.est.9b03358 | Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging | `corpus\papers\raw_pdf\Assessing NO2 Concentration and Model Uncertainty with High spatiotemporal resolution accross the contiguous united states.pdf` |
| 10.1038/sdata.2018.246 | A global dataset of air temperature derived from satellite remote sensing and weather stations | `corpus\papers\raw_pdf\A global dataset of air temperature derived from satellite remote sensing and weather stations.pdf` |
| 10.1080/07474938.2022.2047507 | Model selection and model averaging for matrix exponential spatial models | `corpus\papers\raw_pdf\Model selection and model averaging for matrix exponential spatial models_nodatafound.pdf` |
| 10.1080/17583004.2021.1962979 | Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key source to the C sink | `corpus\papers\raw_pdf\Above ground carbon stock mapping over coimbatore and Nilgiris biosphere.pdf` |
| 10.1093/isq/sqz068 | Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions | `corpus\papers\raw_pdf\Regulatory Convergence in the Financial Periphery.pdf` |
| 10.1111/1365-2435.13092 | Primary productivity explains size variation across the Pallid bat's western geographic range | `corpus\papers\raw_pdf\Primary productivity explains size variation across the Pallid bat western geographic range.pdf` |
| 10.1111/2041-210x.13762 | MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions | `corpus\papers\raw_pdf\Sydenham_2022_MetaComNet_RandomForestSpatialPollinatorPredictions.pdf` |
| 10.1111/2041-210x.13957 | Balancing structural complexity with ecological insight in Spatio-temporal species distribution models | `corpus\papers\raw_pdf\Laxton_2023_StructuralComplexityEcologicalInsightSpatioTemporalSDM.pdf` |
| 10.1111/ecog.06085 | Niche conservatism limits the distribution of Medicago in the tropics | `corpus\papers\raw_pdf\Niche conservatism limits the distribution of Medicago in the tropics.pdf` |
| 10.1111/geb.12999 | Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals | `corpus\papers\raw_pdf\Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals.pdf` |
| 10.1111/geb.13792 | Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions | `corpus\papers\raw_pdf\Global Ecology and Biogeography - 2023 - Mäkinen - Integrated species distribution models to account for sampling biases.pdf` |
| 10.1186/s41043-022-00309-7 | Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis | `corpus\papers\raw_pdf\Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019 a geographically weighted regression analysis.pdf` |
| 10.1371/journal.pone.0138456 | Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome | `corpus\papers\raw_pdf\Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome.pdf` |
| 10.1590/0001-3765201920180666 | Spatial distribution of wood volume in Brazilian savannas | `corpus\papers\raw_pdf\Spatial distribution of wood volume in Brazilian savannas.pdf` |
| 10.1590/0034-7612163114 | Construção de um índice de desenvolvimento sustentável e análise espacial das desigualdades nos municípios cearenses | `corpus\papers\raw_pdf\Building a sustainable development index and spacial assessment of municipalities inequalities in the state of Ceara.pdf` |
| 10.1590/0103-6351/4456 | Determinants and spatial dependence of innovation in Brazilian regions: evidence from a Spatial Tobit Model | `corpus\papers\raw_pdf\Determinants and spatial dependence of innovation in Brazilian regions - evidence from a Spatial Tobit Model.pdf` |
| 10.1590/1806-9479.2019.187145 | O impacto das cooperativas na produção agropecuária brasileira: uma análise econométrica espacial | `corpus\papers\raw_pdf\O impacto das cooperativas na producao agropecuaria brasileira - uma analise econometrica espacial.pdf` |
| 10.5751/es-12481-260327 | How do Indigenous and local knowledge systems respond to climate change? | `corpus\papers\raw_pdf\How do Indigenous and local knowledge systems respond to climate change.pdf` |

## Rejetes

| DOI article | Article | Raison |
|---|---|---|
| 10.1016/j.ufug.2020.126778 | Examining the effects of green infrastructure on residential sales prices in Omaha, Nebraska | Rejected after manual PDF/source screening on 2026-08-06: article is paywalled or does not provide an exploitable benchmark dataset. |
| 10.1002/eap.2893 | Building use-inspired species distribution models: Using multiple data types to examine and improve model performance | Rejected after manual PDF/source screening on 2026-08-06: article is paywalled or does not provide an exploitable benchmark dataset. |
| 10.1093/ajae/aaz047 | The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts on US Agriculture | Rejected after manual PDF/source screening on 2026-08-06: article is paywalled or does not provide an exploitable benchmark dataset. |
| 10.1080/13658816.2019.1707834 | Geographically neural network weighted regression for the accurate estimation of spatial non-stationarity | Rejected after manual PDF/source screening on 2026-08-06: article is paywalled or does not provide an exploitable benchmark dataset. |
| 10.1080/24694452.2018.1462691 | The Importance of Scale in Spatially Varying Coefficient Modeling | Rejected after manual PDF/source screening on 2026-08-06: article is paywalled or does not provide an exploitable benchmark dataset. |
