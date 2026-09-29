---
title: Revue des candidats model evidence issus de l'audit TEI
type: metadata
created: 2026-08-06
updated: 2026-09-15
sources: [data/manifests/papers/model_evidence_audit.csv]
tags: [metadata, kg, audit, tei, model-evidence, review]
---

# Revue des candidats model evidence issus de l'audit TEI

Date : 2026-08-06

Ce rapport est genere automatiquement depuis `data/manifests/papers/model_evidence_audit.csv`.
Il sert a relire les passages candidats avant toute promotion vers les fiches datasets ou les preuves confirmees du KG.

## Synthese

- Lignes d'audit lues : 11118
- Candidats retenus dans ce rapport : 2632
- Papiers avec au moins un candidat : 339

### Par type

| Type | Nombre |
|---|---:|
| `ModelEvidenceCandidate` | 1410 |
| `ModelTableCandidate` | 556 |
| `DataSourceCandidate` | 318 |
| `VariableTableCandidate` | 317 |
| `GenericEstimatorFormulaCandidate` | 31 |

### Par statut

| Statut | Nombre |
|---|---:|
| `extracted_needs_review` | 2601 |
| `rejected_generic_formula` | 31 |

### Action proposee

| Action | Nombre |
|---|---:|
| `low_priority_review` | 1695 |
| `review_for_model_evidence` | 527 |
| `review_for_dataset_use` | 379 |
| `reject_generic` | 31 |

## Regle de lecture

- `review_for_dataset_use` : passage ou tableau prioritaire pour verifier qu'un papier utilise un dataset exploitable.
- `review_for_model_evidence` : passage utile pour verifier formule, estimateur, metriques ou specification empirique.
- `reject_generic` : equation generique d'estimateur, a ne pas transformer en formule publiee dataset.
- `low_priority_review` : signal conserve mais non prioritaire.

## Candidats declasses par verification LLM

Ces candidats auraient obtenu une action prioritaire sur le seul score a mots-cles, mais Claude a juge l'extrait theorique/methodologique plutot qu'une utilisation empirique reelle dans ce papier (voir `09b_llm_disambiguate_candidates.py`).

| Papier | Section/table | Score | Justification LLM |
|---|---|---:|---|
| The Effect of Weather Conditions on Fertilizer Applications: A Spatial Dynamic Panel Da... | Controlling for Spatial Error Correlations | 58 | L'extrait décrit une exposition méthodologique générique : définition du modèle théorique (équations 1 et 2), revue de littérature sur les tests d'autocorrélation spatiale (Baltagi et al. 2003, Mil... |
| The False Dilemma: Bayesian vs. Frequentist * 1 | Metaphysical values: | 58 | Cet extrait est une exposition purement théorique et philosophique sur les fondements épistémologiques de la statistique (réalisme vs subjectivisme, approches bayésiennes vs fréquentistes). Il cite... |
| A dimension reduction approach to edge weight estimation for use in spatial models | Basis functions and spatial models | 61 | L'extrait présente uniquement des définitions mathématiques générales (modèles spatiaux, fonctions de base, formulations), une revue de littérature de méthodes existantes (kernel convolution, predi... |
| A dimension reduction approach to edge weight estimation for use in spatial models | Visualizations of method and interpretation of basis coefficients | 62 | L'extrait expose le cadre méthodologique du modèle GDEF (définitions mathématiques, comparaisons théoriques avec CAR et approches de déformation, formulations d'équations, interprétations conceptue... |
| GWRBoost:A geographically weighted gradient boosting method for explainable quantificat... | Variants of geographically weighted regression | 72 | L'extrait est une revue de littérature et une exposition méthodologique des variants de GWR. Il décrit des méthodes (SGWR, MGWR, métriques de distance) et des concepts théoriques sans présenter d'a... |
| GWRBoost:A geographically weighted gradient boosting method for explainable quantificat... | Additive linear model for located observations | 56 | L'extrait décrit le cadre méthodologique général du modèle GWR (Geographically Weighted Regression) avec des formules mathématiques, des notations abstraites (u_i, v_i, β_k, W), et des explications... |
| GWRBoost:A geographically weighted gradient boosting method for explainable quantificat... | Computation of Akaike information criterion | 66 | L'extrait expose des définitions et concepts méthodologiques génériques (AIC, AICc, formules mathématiques, propriétés des modèles GWR) sans mentionner aucun dataset réel, source de données concrèt... |
| A Review of Software for Spatial Econometrics in R | Cross Sectional Models | 70 | Cet extrait présente uniquement le cadre méthodologique général du modèle spatial de Cliff-Ord (équations, notation matricielle, paramètres, hypothèses de distribution). Aucun dataset réel n'est me... |
| A Review of Software for Spatial Econometrics in R | Early ML Estimation | 70 | L'extrait est une exposition méthodologique générique décrivant le développement historique des méthodes ML pour modèles spatiaux (Cliff & Ord, Ord, CAR vs SAR). Il contient des formules mathématiq... |
| A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationar... | The strategy of time distance decay | 56 | L'extrait décrit le cadre méthodologique de GWR et GTWR via des équations formelles, des références bibliographiques et des concepts génériques (distance decay, kernel functions, bandwidth). Aucun... |
| A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationar... | Results with simulated data | 58 | L'extrait décrit clairement une expérience de simulation Monte Carlo (DGP = Data Generating Process, lattice générée artificiellement 25×25, données simulées). Il n'y a aucun dataset réel nommé, au... |
| A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationar... | Case study 1 | 60 | Les données x1 et x2 sont explicitement générées par simulation (η1=0.5, η2=0.1, paramètres contrôlés). Il n'y a pas de dataset réel nommé, pas de source de données externe, pas de cas d'étude conc... |
| A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationar... | Case study 2 | 60 | Cet extrait décrit une simulation Monte Carlo avec données générées artificiellement (η₁, η₂, paramètres ϕ contrôlés). Aucun dataset réel nommé, aucune source de données empiriques, aucun cas d'étu... |
| Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key source... | Stepwise multiple linear regression model (SMLR) | 59 | Extrait purement méthodologique : exposition générique de la technique SMLR (Stepwise Multiple Linear Regression), définitions formelles d'équations mathématiques (Eq. 1, 2, 3), notation matriciell... |
| Airbnb Offer in Spain-Spatial Analysis of the Pattern and Determinants of Its Distribution | GROBID table | 46 | Cet extrait présente une table de variables explicatives génériques utilisées dans des modèles de régression, sans identification d'un dataset spécifique, de source de données concrète, ou d'applic... |
| Agricultural technology adoption and land use: evidence for Brazilian municipalities | GROBID table | 47 | Cet extrait présente une taxonomie de modèles économétriques spatiaux avec des équations formelles et des descriptions méthodologiques génériques. Aucun dataset nommé, source de données concrète, n... |
| Agricultural technology adoption and land use: evidence for Brazilian municipalities | GROBID table | 47 | L'extrait présente uniquement des spécifications de modèles econométriques génériques (équations 1-4) avec variables symboliques (N_j,i, T_i, C_i, E_i, W). Aucun dataset nommé, aucune source de don... |
| Incorporating spatial and genetic competition into breeding pipelines with the R packag... | First step: competition matrix | 53 | L'extrait décrit la structure et l'utilisation générique de deux fonctions logicielles (prepfor et prepcrop) du package gencomp. Il expose le fonctionnement méthodologique des arguments et paramètr... |
| Airbnb Offer in Spain-Spatial Analysis of the Pattern and Determinants of Its Distribution | GROBID table | 46 | Cet extrait présente une table de variables explicatives génériques utilisées dans des modèles de régression, sans identification d'un dataset spécifique, de source de données concrète, ou d'applic... |
| An ensemble-based model of PM 2.5 concentration across the contiguous United States wit... | Machine learning algorithms | 64 | Cet extrait est une revue de littérature qui cite des études existantes (Gupta and Christopher 2009, Di et al. 2016, Chen et al. 2018, etc.) sans présenter d'application empirique propre au papier.... |
| ECONOMICS OF SITE SPEC1fi1C NITROGEN MANAGEMENT IN CORN PRODUCTION | Spatial Models | 67 | L'extrait expose un cadre méthodologique général : définition des modèles de réponse des cultures, critique des méthodes OLS, exposition des problèmes d'autocorrélation spatiale, et revue de littér... |
| ECONOMICS OF SITE SPEC1fi1C NITROGEN MANAGEMENT IN CORN PRODUCTION | Spatial Econometric Models | 72 | L'extrait expose le cadre méthodologique des modèles d'erreur spatiale : définitions (spatial lag vs spatial error model), justification théorique (facteurs agronomiques non observés), formulation... |
| 02-0692-200 ts | A Taxonomy of Spatial Linear Regression Models for Cross-Sec:tion Data | 69 | L'extrait présente une exposition générique de cadre méthodologique et de spécifications de modèles. Il s'agit de définitions formelles (vecteurs de paramètres, matrices de poids spatiaux, structur... |
| 02-0692-200 ts | Appendix G.A: Some Usefnl Results on Matrix Calc:ulus | 58 | Cet extrait est clairement une exposition méthodologique générique. Il s'agit d'une annexe (Appendix G.A) présentant des résultats mathématiques sur le calcul matriciel, avec références à des ouvra... |
| 02-0692-200 ts | CHAPTER 9 SPATIAL HETEROGENEITY | 53 | Extrait purement méthodologique introduisant un chapitre sur l'hétérogénéité spatiale. Aucune mention de dataset réel, d'observations concrètes, de source de données ou de cas d'étude empirique. Le... |
| 02-0692-200 ts | IU.l. Random coemcient Variation | 60 | L'extrait présente le modèle de coefficients aléatoires de Hildreth-Houck (1968) de manière générique : définitions formelles, équations mathématiques, discussion des propriétés statistiques et des... |
| 02-0692-200 ts | IU.2. Error Componmt Model. for Crou Seetion Data | 66 | L'extrait présente uniquement des développements mathématiques et conceptuels : décomposition formelle des erreurs, références à des modèles génériques (Arora et Brown 1977), expressions matriciell... |
| 02-0692-200 ts | IU.4o Spatial Adaptive FUtering | 60 | L'extrait expose la méthode SAF (Spatial Adaptive Filtering) de manière générique : définition de la technique, principes heuristiques, formules mathématiques, algorithme itératif. Aucun dataset ré... |
| 02-0692-200 ts | Error Component Models in Space-Time | 56 | L'extrait est une exposition méthodologique et historiographique. Il définit les modèles à composantes d'erreur (ECM), contraste avec les modèles à effets fixes, et fait une revue de littérature ch... |
| 02-0692-200 ts | Spatial Autocorrelation in Error Component Models | 58 | L'extrait expose un cadre méthodologique général sur les structures de dépendance spatiale dans les modèles à composantes d'erreur. Il présente des formulations mathématiques abstraites (matrices W... |
| 02-0692-200 ts | lZ.I.4. Other Optimilation Methods | 63 | Cet extrait est une exposition méthodologique générique des techniques d'optimisation non-linéaire (steepest descent, Gauss Newton, etc.) pour l'estimation de modèles spatiaux. Il ne mentionne aucu... |
| 02-0692-200 ts | GROBID table | 47 | Cet extrait présente une exposition méthodologique générique des tests non-imbriqués (non-nested tests) basés sur l'estimation par variables instrumentales en économétrie spatiale. Bien qu'une tabl... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | Algorithm 1 (atds_gwr) | 62 | L'extrait décrit formellement un algorithme (Algorithm 1 atds_gwr) et ses composantes méthodologiques (framework de gradient boosting, paramètres hyperM et η, processus itératif avec GWR). Aucun da... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | Computational issues | 62 | L'extrait traite exclusivement de complexité computationnelle, d'algorithmes et d'implémentations logicielles (R, Python). Aucune donnée réelle, cas d'étude empirique, ou application concrète n'est... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | GROBID table | 46 | Le tableau présente des résultats de comparaison de méthodes (GWR, python_mgwr, multiscale_gwr, tds_mgwr, atds_mgwr) selon des paramètres k (nombre de covariables) et n (nombre d'observations). Il... |
| Regional distribution of photovoltaic deployment in the UK and its determinants: A spat... | Methodology | 71 | L'extrait présente une exposition méthodologique générique des modèles d'économétrie spatiale : définitions formelles des variables (Y, X, β), paramètres (ρ, λ), matrice de poids spatiale W, et spé... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Data-generating processes (DGPs) | 62 | L'extrait décrit la construction de processus générateurs de données (DGP) synthétiques pour des simulations Monte Carlo. Il explique comment générer artificiellement des données avec coordonnées t... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Ordinary Least Squares and a global spatial model | 69 | L'extrait expose des modèles (OLS et SLX) de manière générique avec formules mathématiques, définitions et justifications méthodologiques. Aucun dataset réel n'est nommé, aucune observation concrèt... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Random Forest Regression models | 55 | L'extrait décrit des aspects méthodologiques génériques des Random Forests : définition du modèle, principes de fonctionnement (ensemble de arbres de décision, moyenne des prédictions), choix de bi... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Spatial Random Forests | 60 | L'extrait décrit une méthodologie générique (extension des Random Forests avec approche locale spatiale, clustering K-Means, pondération par distances inverses). Aucun dataset réel n'est nommé, auc... |
| Using Geographically Weighted Regression to Explore Local Crime Patterns | Section 1 | 64 | Cet extrait est une introduction théorique et une revue de littérature. Il discute de concepts généraux (clustering spatial du crime, stationarité/non-stationarité des processus spatiaux), cite des... |
| Multiscale geographically and temporally weighted regression: exploring the spatiotempo... | Geographically and temporally weighted regression | 62 | L'extrait décrit la méthode GTWR de manière générique : formules mathématiques, équations matricielles, choix de fonctions de distance (Gaussian, bi-square, exponential). Aucun dataset réel n'est m... |
| Multiscale geographically and temporally weighted regression: exploring the spatiotempo... | GROBID table | 46 | Tableau de simulation Monte Carlo comparant RMSE entre deux méthodes (GTWR vs MGTWR) avec des coefficients 'True value' générés. Aucune source de données réelle nommée, aucun cas d'étude concret, a... |
| Determinants of Airbnb prices in European cities: A spatial econometrics approach | Spatial models | 63 | Extrait purement méthodologique : définitions formelles de modèles spatiaux (modèle de Manski, GNS), notation mathématique générique (matrices, vecteurs), citations de littérature de référence. Auc... |
| An ensemble-based model of PM 2.5 concentration across the contiguous United States wit... | Machine learning algorithms | 64 | Cet extrait est une revue de littérature qui cite des études existantes (Gupta and Christopher 2009, Di et al. 2016, Chen et al. 2018, etc.) sans présenter d'application empirique propre au papier.... |
| Efficiency of spatially multiscale machine learning models in addressing spatial non-st... | Spatially multiscale geographically weighted models | 66 | L'extrait décrit le cadre méthodologique SM-GW (Spatially multiscale Geographically Weighted) de manière générique : définitions des concepts, comparaison avec GWR et MGWR, principes de fonctionnem... |
| Efficiency of spatially multiscale machine learning models in addressing spatial non-st... | Properties of datasets | 64 | L'extrait décrit des résultats de simulation comparative entre méthodes (régression linéaire, RF, SVM, XGB) sur des données synthétiques avec des formes fonctionnelles contrôlées (linéaire, quadrat... |
| On the determinants of Airbnb location and its spatial distribution | Bivariate spatial correlation | 58 | L'extrait expose des définitions et des cadres méthodologiques (statistique de Moran bivariée, extension du coefficient de Pearson, références théoriques à Anselin, Clifford et al., Dutilleul et al... |
| Extracting spatial effects from machine learning model using local interpretation metho... | Results | 60 | L'extrait présente des résultats de comparaison de modèles (MGWR vs XGBoost) sur des données synthétiques avec des variables X1, X2 et des coordonnées spatiales. Les variables sont clairement artif... |
| paper:doi:10.1080/24694452.2017.1352480 | Multiscale Geographically Weighted Regression (MGWR) | 56 | L'extrait présente une exposition méthodologique générique : définitions conceptuelles (scale, spatial nonstationarity), description théorique de la méthode GWR et MGWR, sans aucune mention de data... |
| paper:doi:10.1080/24694452.2017.1352480 | S | 66 | Extrait composé de citations bibliographiques, de définitions conceptuelles du concept de 'scale' en géographie, et de discussion générale sur les processus multi-échelles. Aucune mention de datase... |
| paper:doi:10.1080/24694452.2017.1352480 | SGWR | 56 | L'extrait expose uniquement le cadre méthodologique et mathématique de SGWR (Semi-parametric Geographically Weighted Regression). Il présente des définitions génériques (observation i, location (u_... |
| paper:doi:10.1080/24694452.2017.1352480 | Bandwidth Comparison | 64 | L'extrait expose des définitions méthodologiques (adaptive bandwidth, kernel bisquare, formules générales) et des comparaisons conceptuelles entre MGWR et GWR. Aucun dataset réel n'est nommé, aucun... |
| Boosting Algorithms: Regularization, Prediction and Model Fitting | Binary Classification | 58 | Cet extrait expose un cadre méthodologique générique de classification binaire avec des définitions mathématiques (encodage de variables, fonction de perte, paramétrisation), des formules abstraite... |
| Boosting Algorithms: Regularization, Prediction and Model Fitting | Componentwise Linear Least Squares for Linear Models | 62 | Extrait purement méthodologique décrivant le cadre théorique du boosting componentwise et des algorithmes associés (matching pursuit, weak greedy algorithm, Gauss-Southwell). Aucune donnée réelle,... |
| Boosting Algorithms: Regularization, Prediction and Model Fitting | 5.3.1 | 60 | Cet extrait expose un cadre méthodologique générique sur L2 Boosting avec moindres carrés linéaires par composante. Il développe des formulations mathématiques abstraites (matrices de projection, d... |
| Boosting Algorithms: Regularization, Prediction and Model Fitting | PoissonBoosting | 58 | Cet extrait expose un cadre méthodologique générique : définition mathématique de la régression de Poisson, formulation de la fonction de perte, et implémentation algorithmique abstraite. Aucun dat... |
| paper:tei:geocomputation_with_r_tei | Spatial tuning of machine-learning hyperparameters | 53 | L'extrait est une exposition méthodologique générique qui définit le machine learning, explique les concepts de SVM et hyperparamètres, et annonce des applications futures. Bien que le texte mentio... |
| paper:tei:geocomputation_with_r_tei | mlr building blocks | 60 | L'extrait décrit une méthodologie générique de validation croisée spatiale, d'optimisation d'hyperparamètres et de sélection de modèles (random forest vs SVM). Il n'y a aucune mention de dataset no... |
| paper:tei:geocomputation_with_r_tei | Exercises | 62 | Cet extrait est une section 'Exercises' (exercices) d'un chapitre de manuel ou de support pédagogique. Il propose des instructions génériques pour exécuter des analyses (NMDS, random forest, valida... |
| Short-Term Rental Platform in the Urban Tourism Context: A Geographically Weighted Regr... | The Geographically Weighted Regression and multiscale GWR (MGWR) | 58 | L'extrait expose le cadre méthodologique de GWR et MGWR via des définitions, justifications théoriques et une revue de littérature (citations de Fotheringham et al., Brunsdon et al.). Les exemples... |
| Fast Spatio-Temporally Varying Coefficient Modeling With Reluctant Interaction Selection | / Property of the Model | 58 | L'extrait expose les propriétés méthodologiques du modèle STVC de manière générique (comparaison avec GAM, description des fonctions de base, formules mathématiques). Bien qu'il mentionne une appli... |
| Geographically Weighted Logistic Regression Applied to Credit Scoring Models* | Geographically Weighted Logistic Regression | 56 | L'extrait expose la méthodologie GWLR de manière générique : formules mathématiques, définitions des paramètres, description de la matrice de poids et de la fonction de vraisemblance. Aucun dataset... |
| Annals of the American Association of Geographers | GeoShapley Applied to Models | 62 | L'extrait décrit une démonstration méthodologique utilisant des données SIMULÉES ("simulated data set from Equation 12"), non un dataset réel nommé ou identifiable. Il s'agit d'une exposition génér... |
| Integrated species distribution models to account for sampling biases and improve range... | / INTRODUC TI ON | 58 | Cet extrait de l'INTRODUCTION expose le cadre général, la motivation et les enjeux des Species Distribution Models (SDMs). Il ne présente aucun dataset nommé, aucune observation concrète, aucune so... |
| GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted... | GW regression 6.1. Basic GW regression | 56 | Extrait purement méthodologique : définitions formelles du modèle GW regression, équations mathématiques, exposition générale de la technique sans aucune donnée réelle, cas d'étude concret, source... |
| GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted... | Robust GW regression | 58 | L'extrait décrit des méthodes génériques de régression géographique pondérée robuste (GW regression) sans application à aucun dataset réel nommé. Il expose des définitions mathématiques, des formul... |
| GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted... | LCR GW regression vs. previous penalized GW regression models | 63 | L'extrait compare et contraste des méthodes statistiques (LCR-GWR, GWRR, GWL) sans aucune référence à un dataset réel, à des observations concrètes, à une source de données ou à une application emp... |
| paper:tei:gwr4manual_409_tei | Step 1: The Data Tab | 62 | Cet extrait est un guide d'utilisation du logiciel GWR4 décrivant les formats de données acceptés, les structures requises et les conventions techniques (longueur de noms de fichiers, formats de co... |
| Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key source... | Stepwise multiple linear regression model (SMLR) | 59 | Extrait purement méthodologique : exposition générique de la technique SMLR (Stepwise Multiple Linear Regression), définitions formelles d'équations mathématiques (Eq. 1, 2, 3), notation matriciell... |
| Random forest as a generic framework for predictive modeling of spatial and spatio-temp... | Spatial prediction | 62 | Cet extrait est une exposition générique et didactique des concepts fondamentaux de la prédiction spatiale. Il définit formellement la notation (s_i, D, n), présente les principes mathématiques gén... |
| Random forest as a generic framework for predictive modeling of spatial and spatio-temp... | Random forest | 58 | L'extrait est une exposition méthodologique générique du Random Forest : définitions, références bibliographiques, description du cadre théorique et mathématique de la méthode. Aucun dataset nommé,... |
| Random forest as a generic framework for predictive modeling of spatial and spatio-temp... | Random forest for spatial data (RFsp) | 60 | L'extrait décrit une approche méthodologique générique (RFsp) avec des définitions formelles de covariables (X_G, X_R, X_P) et des explications de concepts (kriging, bandes Landsat, indices topogra... |
| REVISITING GUERRY'S DATA: INTRODUCING SPATIAL CONSTRAINTS IN MULTIVARIATE ANALYSIS | Moran's eigenvector maps. | 58 | L'extrait présente exclusivement des définitions mathématiques, des propriétés théoriques des Moran's Eigenvector Maps (MEM) et une revue de littérature sur leurs applications méthodologiques. Aucu... |
| REVISITING GUERRY'S DATA: INTRODUCING SPATIAL CONSTRAINTS IN MULTIVARIATE ANALYSIS | Conclusions. | 58 | L'extrait est une section Conclusions qui résume les méthodes théoriques et leurs propriétés générales. Il ne présente aucun dataset nommé, aucune source de données concrètes, aucune observation em... |
| Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and... | Eigenvector spatial filtering (ESF) is a regression technique proposed by Getis and | 58 | L'extrait expose la méthode ESF (Eigenvector Spatial Filtering) de manière générique : définitions mathématiques, formules, références bibliographiques, discussion des propriétés computationnelles... |
| Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and... | Random Forest | 60 | L'extrait décrit les choix méthodologiques génériques pour implémenter Random Forest et LASSO (nombre d'arbres, tuning de paramètres, références bibliographiques). Aucun dataset concret n'est nommé... |
| An Introduction to Spatial Data Analysis and Visualisation in R | Inference with regression | 60 | L'extrait expose le cadre général de l'inférence en régression (concepts de ligne de population vs échantillon, erreurs-types, intervalles de confiance, hypothèses de normalité, tests t). Il mentio... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | Algorithm 1 (atds_gwr) | 62 | L'extrait décrit formellement un algorithme (Algorithm 1 atds_gwr) et ses composantes méthodologiques (framework de gradient boosting, paramètres hyperM et η, processus itératif avec GWR). Aucun da... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | Computational issues | 62 | L'extrait traite uniquement de complexité computationnelle, d'algorithmes et d'implémentations logicielles (R, Python). Il n'existe aucune référence à un dataset réel, à des observations concrètes,... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | Computational efficiency of our algorithms | 62 | L'extrait traite exclusivement de complexité computationnelle théorique (notations O(), formules mathématiques, propriétés algorithmiques). La mention de 'vaucluse-HousePrice' est une simple référe... |
| Top-down scale approaches for multiscale GWR with locally adaptive bandwidths | GROBID table | 46 | Le tableau présente des résultats de comparaison de méthodes (GWR, python_mgwr, multiscale_gwr, tds_mgwr, atds_mgwr) selon des paramètres k (nombre de covariables) et n (nombre d'observations). Il... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | Substantive and Residual Dependence in Cross-Sectional Models | 56 | L'extrait expose un cadre conceptuel général distinguant trois types d'effets d'interaction causant l'autocorrélation spatiale (effets endogènes, exogènes, dépendances résiduelles). Il s'agit d'une... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | . An Illustrative Example of the Different Spatial Processes | 56 | L'extrait utilise l'exemple des revenus fiscaux municipaux comme illustration conceptuelle pour expliquer les processus spatiaux (spillover effects, exogenous interactions). Bien qu'il mentionne de... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | Substantive and Residual Dependence in Cross-Sectional Models | 56 | L'extrait expose un cadre conceptuel général distinguant trois types d'effets d'interaction causant l'autocorrélation spatiale (effets endogènes, exogènes, dépendances résiduelles). Il s'agit d'une... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | . An Illustrative Example of the Different Spatial Processes | 56 | L'extrait utilise l'exemple des revenus fiscaux municipaux comme illustration conceptuelle pour expliquer les processus spatiaux (spillover effects, exogenous interactions). Bien qu'il mentionne de... |
| Multivariate Adaptive Regression Splines | Having made the connection between knot selection and basis function (variable) selecti... | 58 | Cet extrait est une exposition méthodologique générique des techniques de sélection de variables pour les splines polynomiales. Il décrit des algorithmes (stepwise deletion/addition, AIC, BIC, GCV)... |
| Multivariate Adaptive Regression Splines | Higher Dimensional Problems | 58 | L'extrait décrit un cadre méthodologique générique pour les problèmes de régression adaptative en dimensions supérieures (MARS, Hare, Polyclass, Polymars). Il expose l'algorithme général, les princ... |
| Exploring Spatial Data Mining Techniques: Predicting Zinc Concentration with Kriging Me... | Geographically weighted regression | 68 | L'extrait expose uniquement la méthode GWR de manière générique : définitions, formulation mathématique (Équation 5), principes de fonctionnement et historique de la technique. Aucun dataset réel n... |
| A Comparison of Four Spatial Regression Models for Yield Monitor Data: A Case Study fro... | Geostatistical approach to spatial regression (REML) | 60 | L'extrait est une revue de littérature et un exposé méthodologique du cadre geostatistique REML. Il décrit l'approche générale, son histoire (Cressie 1993), et cite des applications d'autres auteur... |
| A Comparison of Four Spatial Regression Models for Yield Monitor Data: A Case Study fro... | Discrete spatial regression approach (SAR) | 66 | L'extrait expose le cadre méthodologique général de l'approche de régression spatiale discrète (SAR) : définitions conceptuelles, principes théoriques, critères de contiguïté (bishop, rook, queen),... |
| Balancing structural complexity with ecological insight in Spatio-temporal species dist... | Existing methods for species distribution modelling include: | 57 | Cet extrait est une exposition méthodologique générique qui énumère des méthodes de modélisation existantes (MAXENT, GLM, GAM, MARS, etc.) et discute des problèmes théoriques associés (autocorrélat... |
| Balancing structural complexity with ecological insight in Spatio-temporal species dist... | Existing methods for species distribution modelling include: | 57 | Cet extrait est une exposition méthodologique générique qui énumère des méthodes de modélisation existantes (MAXENT, GLM, GAM, MARS, etc.) et discute des problèmes théoriques associés (autocorrélat... |
| SGWR: similarity and geographically weighted regression | Similarity weight matrix | 56 | L'extrait présente une revue générale de méthodes de similarité (Pearson, Cosine Similarity, K-Means, DBSCAN, etc.) et expose le cadre méthodologique de la matrice de similarité de manière génériqu... |
| SGWR: similarity and geographically weighted regression | Evaluation metrics | 60 | L'extrait décrit les métriques d'évaluation de manière générique et méthodologique : définitions formelles, formules mathématiques, références bibliographiques. Aucun dataset réel n'est mentionné,... |
| SGWR: similarity and geographically weighted regression | Beyond geographical distance | 64 | L'extrait expose le cadre méthodologique de SGWR (Similarity-based Geographically Weighted Regression) et ses principes généraux. Il cite des études antérieures mais ne décrit pas l'application à u... |
| The GWmodel R package: Further Topics for Exploring Spatial Heterogeneity using Geograp... | GW summary statistics | 58 | L'extrait présente des définitions mathématiques formelles (équations 3 et 4), des explications conceptuelles sur GW summary statistics et GW PCA, ainsi qu'une discussion générale sur l'utilité mét... |
| Integrated species distribution models to account for sampling biases and improve range... | / INTRODUC TI ON | 58 | Cet extrait de l'INTRODUCTION expose le cadre général, la motivation et les enjeux des Species Distribution Models (SDMs). Il ne présente aucun dataset nommé, aucune observation concrète, aucune so... |
| A new method for dealing simultaneously with spatial autocorrelation and spatial hetero... | DGPs with spatial autocorrelation and spatially varying coefficients | 68 | L'extrait présente des formulations mathématiques génériques (équations 1 et 2), des discussions sur les hypothèses méthodologiques, les limitations théoriques des modèles de poids spatiaux, et des... |
| A new method for dealing simultaneously with spatial autocorrelation and spatial hetero... | Estimators for models with spatial autocorrelation and spatial heterogeneity | 58 | L'extrait est une revue de littérature exposant des méthodes (Trend Surface Analysis, Variable Expansion, LWR, GWR, Mixed GWR) sans application à un dataset réel nommé, sans observations concrètes,... |
| Multiscale Geographically Weighted Regression | Multiscale Geographically Weighted Regression | 66 | Cet extrait est une exposition historique et conceptuelle de l'évolution de la géographie humaine et de l'analyse spatiale. Il s'agit d'une revue de littérature discutant des concepts théoriques (d... |
| Multiscale Geographically Weighted Regression | Local Versus Global Models | 62 | L'extrait expose le cadre théorique et historique des modèles de régression spatiale. Il décrit des équations génériques (1.1, 1.2), discute de concepts méthodologiques abstraits (dépendance spatia... |
| Multiscale spatially varying coefficient modelling using a Geographical Gaussian Proces... | GAMs | 60 | L'extrait est une exposition méthodologique générique des GAMs : définitions, propriétés mathématiques, comparaisons avec d'autres approches, principes théoriques (splines, basis functions). Aucune... |
| Multiscale spatially varying coefficient modelling using a Geographical Gaussian Proces... | A Geographical Gaussian Process GAM for SVC modelling | 66 | L'extrait expose exclusivement le cadre méthodologique des GAMs, processus gaussiens et modèles SVC à coefficients variables spatialement. Il présente des formulations mathématiques génériques, des... |
| Multivariable geostatistics in S: the gstat package $ | Handling spatial data in S | 58 | Cet extrait décrit des considérations méthodologiques et techniques concernant la manipulation de données spatiales dans le logiciel gstat/R. Il traite de structures de données (grilles, matrices,... |
| Novel approach to the analysis of spatially-varying treatment effects in onfarm experim... | Geographically weighted regression | 60 | L'extrait présente uniquement des développements mathématiques génériques (formulation du modèle GWR, équations de log-vraisemblance, propriétés statistiques). Aucun dataset réel n'est mentionné, a... |
| Novel approach to the analysis of spatially-varying treatment effects in onfarm experim... | Geographically weighted regression | 60 | L'extrait présente uniquement des développements mathématiques génériques (formulation du modèle GWR, équations de log-vraisemblance, propriétés statistiques). Aucun dataset réel n'est mentionné, a... |
| Regional distribution of photovoltaic deployment in the UK and its determinants: A spat... | Methodology | 71 | L'extrait présente une exposition méthodologique générique des modèles d'économétrie spatiale : définitions formelles des variables (Y, X, β), paramètres (ρ, λ), matrice de poids spatiale W, et spé... |
| Remote sensing-based measurement of Living Environment Deprivation: Improving classical... | Model performance | 62 | L'extrait expose un cadre méthodologique générique sur l'évaluation de modèles (validation, performance, métriques comme R² et MSE) sans présenter de résultats empiriques concrets, d'observations r... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | Choice of the Meta-Analytic Model | 53 | L'extrait décrit un cadre méthodologique général de modèles méta-analytiques multivariés (équation 5, fixed effects vs random effects models). Bien que le contexte mentionne une application à 'l'ef... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | Publication Bias | 58 | L'extrait décrit des concepts méthodologiques génériques (funnel plot, publication bias, effet sizes, standard errors, transformation log) sans référence à un dataset spécifique, à des données conc... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | GROBID table | 46 | Il s'agit d'une méta-analyse ou d'une synthèse de résultats d'études multiples (régression WLS avec erreurs groupées au niveau 'study level'). Les variables comme 'Methodology: Estimation Strategy'... |
| The Practical Use of Semiparametric Models in Field Trials | ADDITIVE AND SEMIPARAMETRIC MODELS | 60 | L'extrait expose le cadre méthodologique général des modèles additifs et semi-paramétriques (définitions formelles, équations génériques, description du lisseur loess, références théoriques). Aucun... |
| The Practical Use of Semiparametric Models in Field Trials | Model Selection Criteria | 62 | L'extrait présente une exposition méthodologique générique des critères de sélection de modèle (CV, GCV, AIC, AICc). Il expose des formules mathématiques, des références théoriques et des propriété... |
| SGWR: similarity and geographically weighted regression | Similarity weight matrix | 56 | L'extrait présente une revue générale de méthodes de similarité (Pearson, Cosine Similarity, K-Means, DBSCAN, etc.) et expose le cadre méthodologique de la matrice de similarité de manière génériqu... |
| SGWR: similarity and geographically weighted regression | Evaluation metrics | 60 | L'extrait décrit les métriques d'évaluation de manière générique et méthodologique : définitions formelles, formules mathématiques, références bibliographiques. Aucun dataset réel n'est mentionné,... |
| SGWR: similarity and geographically weighted regression | Beyond geographical distance | 64 | L'extrait expose le cadre méthodologique de SGWR (Similarity-based Geographically Weighted Regression) et ses principes généraux. Il cite des études antérieures mais ne décrit pas l'application à u... |
| Short-Term Rental Platform in the Urban Tourism Context: A Geographically Weighted Regr... | The Geographically Weighted Regression and multiscale GWR (MGWR) | 58 | L'extrait expose le cadre méthodologique de GWR et MGWR via des définitions, justifications théoriques et une revue de littérature (citations de Fotheringham et al., Brunsdon et al.). Les exemples... |
| Spatial autocorrelation in fitness affects the estimation of natural selection in the wild | Principal coordinate matrices of neighbour matrices | 64 | L'extrait décrit la méthode PCNM et les Moran's eigenvectors maps de manière générique et abstraite. Il expose le cadre méthodologique en 5 étapes avec formules mathématiques, sans mentionner de da... |
| Spatial autocorrelation in fitness affects the estimation of natural selection in the wild | S E L E C T I O N A N A L Y S I S A N D G E O S T A T I S T I C S O N S I M U L A T E D... | 60 | Bien que l'extrait utilise un dataset réel (volcano data de R), il s'agit d'une étude de simulation Monte Carlo. Les auteurs ont réduit le grid à 400 cellules et généré 200 datasets synthétiques où... |
| Spatial Clustering Overview and Comparison: Accuracy, Sensitivity, and Computational Ex... | Methods and Data | 63 | L'extrait décrit une évaluation comparative de méthodes de clustering spatial (G*i, Moran's I, AMOEBA, Kulldorff's scan, FlexScan, GAScan, CM-LLR) avec détails formels et mathématiques en appendice... |
| Spatial Statistics for Data Science | Spatial disease risk models | 58 | L'extrait décrit le cadre méthodologique général des modèles hiérarchiques bayésiens pour les risques spatiaux de maladie (définitions mathématiques, spécifications du modèle de Poisson, composante... |
| Spatial Statistics for Data Science | Model-based geostatistics | 58 | L'extrait décrit le cadre général et méthodologique de la géostatistique basée sur les modèles : définitions formelles (modèle Gaussien Y_i = μ + S(·)), méthodes génériques (INLA, SPDE), références... |
| Spatial Statistics for Data Science | Testing complete spatial randomness | 58 | L'extrait décrit une méthodologie générique de test de complète aléatoire spatiale (CSR) via la fonction K. Il expose le cadre théorique et l'algorithme de simulation Monte Carlo sans mentionner de... |
| Spatially Varying Coefficient Model for Neuroimaging Data with Jump Discontinuities | Model Setup | 60 | Cet extrait est une exposition purement méthodologique et générique. Il présente le cadre théorique d'un modèle spatial varying coefficient (SVCM) avec notation mathématique abstraite, sans aucune... |
| Flexible nonlinear spatial autoregressive models: a gradient boosting approach with clo... | Functional gradient descent boosting with additive models | 62 | L'extrait est une exposition méthodologique générique des méthodes de boosting par gradient fonctionnel et des modèles additifs généralisés. Il contient des définitions formelles, des références bi... |
| Flexible nonlinear spatial autoregressive models: a gradient boosting approach with clo... | GROBID table | 46 | Cet extrait décrit une expérience de simulation Monte Carlo (1000 replications, n=2000, paramètres contrôlés ρ=0.0/0.2/0.6/0.9, SNR=0.7). Il s'agit d'une étude de performance de méthodes statistiqu... |
| spmoran (ver. 0.2.0): An R package for Moran eigenvector-based scalable spatial additiv... | Spatially and non-spatially varying coefficient models 2.3.1. Varying coefficient modeling | 62 | L'extrait expose le cadre méthodologique des modèles à coefficients variant spatialement (SVC) et non-spatialement (NVC). Il compare des approches théoriques (GWR, MGWR, SGWR) et énumère des avanta... |
| spmoran (ver. 0.2.0): An R package for Moran eigenvector-based scalable spatial additiv... | GROBID table | 46 | Cet extrait décrit une table de documentation technique d'une fonction logicielle (resf_vc) avec ses arguments et leurs valeurs par défaut. Il s'agit d'une exposition méthodologique générique sur c... |
| Journal of Statistical Software | Special cases: Single-component models | 58 | Cet extrait expose des propriétés mathématiques et méthodologiques : simplification d'équations, équivalence entre modèles (Poisson regression vs twinstim), démonstration théorique de la log-vraise... |
| Spatially varying coefficient modeling for large datasets: Eliminating N from spatial r... | Model | 60 | L'extrait décrit des concepts méthodologiques génériques : définitions du coefficient de Moran, formulation mathématique de matrices spatiales, décomposition en vecteurs propres. Aucun dataset nomm... |
| Spatially varying coefficient modeling for large datasets: Eliminating N from spatial r... | Modeling | 58 | L'extrait décrit une méthode de calcul générique (approximation de Nyström pour les vecteurs propres de Moran) et des considérations de complexité computationnelle. Il n'y a aucune référence à un d... |
| Spatially varying coefficient modeling for large datasets: Eliminating N from spatial r... | Summary | 58 | L'extrait décrit exclusivement une méthodologie générique (réduction de rang, compression pré-estimation, estimation séquentielle) et une analyse de complexité computationnelle (O(L³), dépendance e... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | Choice of the Meta-Analytic Model | 53 | L'extrait décrit un cadre méthodologique général de modèles méta-analytiques multivariés (équation 5, fixed effects vs random effects models). Bien que le contexte mentionne une application à 'l'ef... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | Publication Bias | 58 | L'extrait décrit des concepts méthodologiques génériques (funnel plot, publication bias, effet sizes, standard errors, transformation log) sans référence à un dataset spécifique, à des données conc... |
| Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regre... | GROBID table | 46 | Il s'agit d'une méta-analyse ou d'une synthèse de résultats d'études multiples (régression WLS avec erreurs groupées au niveau 'study level'). Les variables comme 'Methodology: Estimation Strategy'... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | Substantive and Residual Dependence in Cross-Sectional Models | 56 | L'extrait expose un cadre conceptuel général distinguant trois types d'effets d'interaction causant l'autocorrélation spatiale (effets endogènes, exogènes, dépendances résiduelles). Il s'agit d'une... |
| The Wald Test of Common Factors in Spatial Model Specification Search Strategies | . An Illustrative Example of the Different Spatial Processes | 56 | L'extrait utilise l'exemple des revenus fiscaux municipaux comme illustration conceptuelle pour expliquer les processus spatiaux (spillover effects, exogenous interactions). Bien qu'il mentionne de... |
| Comparing spatially varying coefficient models: a case study examining violent crime ra... | Geographically weighted regression | 74 | L'extrait présente une exposition méthodologique générique de la GWR : formules mathématiques, définitions des composantes (y(s), b(s), X(s), e(s)), description du calcul des matrices de poids, et... |
| Comparing spatially varying coefficient models: a case study examining violent crime ra... | Bayesian SVCP model and coefficient shrinkage | 62 | L'extrait expose un cadre méthodologique comparant les modèles GWR et SVCP à travers une discussion sur le shrinkage bayésien et la régression ridge. Il s'agit d'une revue de littérature (référence... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Data-generating processes (DGPs) | 62 | L'extrait décrit la construction de processus générateurs de données (DGP) synthétiques pour des simulations Monte Carlo. Il explique comment générer artificiellement des données avec coordonnées t... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Ordinary Least Squares and a global spatial model | 69 | L'extrait expose des modèles (OLS et SLX) de manière générique avec formules mathématiques, définitions et justifications méthodologiques. Aucun dataset réel n'est nommé, aucune observation concrèt... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Random Forest Regression models | 55 | L'extrait décrit des aspects méthodologiques génériques des Random Forests : définition du modèle, principes de fonctionnement (ensemble de arbres de décision, moyenne des prédictions), choix de bi... |
| Benchmarking Regression Models Under Spatial Heterogeneity | Spatial Random Forests | 60 | L'extrait décrit une méthodologie générique (extension des Random Forests avec approche locale spatiale, clustering K-Means, pondération par distances inverses). Aucun dataset réel n'est nommé, auc... |

## Candidats par papier

### "Covariates impacts in spatial autoregressive models for compositional data"

- TEI : `corpus\papers\tei\Covariates_impacts_in_spatial_autoregressive_models_for_compositional_data_W3102181283.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Local impacts and impacts decomposition | In this section, coming back to the case of a classical explanatory variable, we present several ways of exploring and summarizing the semi-elasticities. Recall that we have for each component m, (m = 1, • • • , D), a n × n matrix of semielasticities and we... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Covariates impacts in spatial autoregressive models and in simplicial regression models | Before combining these techniques in the next section, we first remind the reader some results about covariate impact evaluation both in spatial autoregressive models and in simplicial regression models separately. Note that since the impacts are relative t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Elasticity-based impacts for the spatial-compositional regression model | Nguyen et al. ( 2021 ) introduce a simultaneous spatial regression model of the LAG type for compositional data. Note that this is a multivariate spatial model since the dependent variable vector is in S D and they use Kelejian and Prucha (2004) for definin... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Simplicial regression models | Turning now attention to simplicial regression models, we focus on the case where the dependent variable is of a compositional nature Y ∈ S D and we first assume that the explanatory variable of interest X is not compositional. For a given choice of contras... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Univariate spatial autoregressive models | Let us consider here an ordinary spatial autoregressive regression model, often referred to as the LAG model, of the following type where covariates values observed at the same locations, is a vector of i.i.d. disturbances with mean zero and variance σ 2 ,... |

### 02-0692-200 ts

- DOI : `10.1007/978-94-015-7799-1`
- TEI : `corpus\papers\tei\anselin1988.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 53 | CHAPTER 9 SPATIAL HETEROGENEITY | Many phenomena studied in regional science lead to structural instability over space, in the form of different response functions or systematically varying parameters. In addition, the measurement errors that result from the use of ad hoc spatial units of o... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 11 . |
| low_priority_review | `ModelEvidenceCandidate` | 69 | A Taxonomy of Spatial Linear Regression Models for Cross-Sec:tion Data | In this seetion, I present a general specifieation, which forms a framework to organize various modeling situations of interest in spatial eeonometries. The specification pertains to the situation where observations are available for a crossseetion of spati... |
| low_priority_review | `ModelEvidenceCandidate` | 66 | IU.2. Error Componmt Model. for Crou Seetion Data | In many situations where observations over time and across space are combined (panel data), the regression error term can reasonably be decomposed into a spatial component, a time-specific componenent and an overall component. Formally, where tJ. 1 is the e... |
| low_priority_review | `ModelEvidenceCandidate` | 63 | lZ.I.4. Other Optimilation Methods | In models with spatial dependence in the error term, a direct search approach is not efficient, since it needs to be carried out for every iteration of b EGLS estimates. Other, more traditional nonlinear optimization techniques, such as a steepest decent me... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 61 | lZ.%.I. A Spatial Model of Determinants of Neighborhood Crime | The model that will be used throughout in the treatment of cross-sectional data is a simple linear expression relating crime to measures of income and housing value. This model is selected primarily to illustrate the various spatial effects, and is not inte... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | IU.4o Spatial Adaptive FUtering | A completely different approach to dealing with spatial heterogeneity in regression coefficients is based on heuristic principles of adaptive estimation. In the spatial adaptive filtering technique (SAF), suggested by Foster and Gorr (1983 , 1984 , 1986) ,... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | IU.l. Random coemcient Variation | In many empirical situations, no obvious variables are available to determine a specific form for the spatial variation in the regression coefficients. In such cases, an alternative approach is the Hildreth-Houck (1968) random coefficient model, where the c... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Appendix G.A: Some Usefnl Results on Matrix Calc:ulus | In this Appendix, I will present some useful elements of matrix calculus that are needed to derive the score vector and information matrix for the general spatial process model considered in this chapter. For ease of exposition, I will frame the discussion... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Spatial Autocorrelation in Error Component Models | The equicorrelated form of spatial dependence which is implied by the error component model does not allow for distance decay effects. Since this runs counter to accepted spatial interaction theory, it may not be a very useful structure in applied regional... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Error Component Models in Space-Time | An alternative way in which space and time effects can be incorporated into a regression model consists of the error components (ECM) or variance components (VCM) approach. In this framework, the space (or individual) and time effects are considered as part... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | 1:1.2. Speciftcation TeBting in Spatial EconometricB | In spatial analysis, three general types of specification tests are particularly relevant. The first concerns tests for the presence of spatial effects, i.e., tests for spatial dependence and spatial heterogeneity. These have been discussed at length in pre... |
| low_priority_review | `truncated` |  |  | 30 autres candidats non affiches dans ce rapport |

### A Comparison of Four Spatial Regression Models for Yield Monitor Data: A Case Study from Argentina

- TEI : `corpus\papers\tei\lambert2004_A Comparison of Four Spatial Regression Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Comparison of the spatial regression models | Overall, the base OLS model AIC fit criterion improved between 3% and 15% when error spatial dependence was included in the model (Table 2 ). All models produced the expected signs for the quadratic yield response to nitrogen, and all topography intercept t... |
| low_priority_review | `ModelEvidenceCandidate` | 66 | Discrete spatial regression approach (SAR) | The discrete spatial regression approach assumes that spatial dependence is a relationship among discrete observations, or polygons. Spatial structure may be found in either the dependent variable (e.g., yield) or in regression residuals. Spatial structure... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 61 | Materials and methods | Corn nitrogen response data from the study by Bongiovanni and Lowenberg-DeBoer (2000) were used in this analysis. The data were collected from strip trials at the ''Las Rosas'' farm located near Rı´o Cuarto in the southwestern corner of Co´rdoba Province, A... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Geostatistical approach to spatial regression (REML) | Many agronomists have used geostatistical tools to model crop and soil spatial relationships. Perhaps this is because of the disciplinary links between soil science and geology. Originally, geostatistics was developed to produce maps by interpolation betwee... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Illustrative example: nitrogen budgeting and VRN profitability | Accounting for spatial dependence in yield monitor data has an effect on the inferences drawn about VRN profitability in this case study (Table 5 ). Though the estimated N responses are site-specific and cannot be generalized to other fields, they demonstra... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Nearest-neighbor approach and spatial regression (NN) | The classical experimental design in agronomy is the randomized complete block (RCB). An RCB design is essentially a strategy to control experimental error. Developed by Fisher in the 1920s, the RCB was hailed as a correction for nonhomogeneous experimental... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Practical applications of the results | If the discrete model of spatial dependence is a reasonable assumption, the SAR approach provides several advantages. SAR is a one step maximum likelihood estimation process, while the REML-geostatistical approach requires at least three steps. Second, SAR... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Nearest-neighbor approach | The NN model improved the coefficient of determination by 6%, compared to the OLS estimates (Adjusted R 2 ¼ 0.66, Table 2 ). The appropriate measure of fit statistic is Akaike's information criterion (AIC) criterion since an additional parameter was include... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Polynomial trend regression | The null hypothesis of no spatial structure in the regression error terms was strongly rejected when the model was estimated using the PTR specification (LR ¼ 984, df ¼ 2, Table 2 ). Compared to the original OLS model fit, the Adjusted R 2 for the PTR incre... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Polynomial trend regression and spatial regression (PTR) | Tamura et al. (1988) proposed another alternative to modeling spatial dependence by inserting a polynomial trend variable (T ij ) into the familiar ANOVA model. This approach is somewhat related to the spatial expansion regression methodology that has recei... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | REML-geostatistical approach | A spherical semivariogram model was used to fit the empirical semivariogam of the OLS residuals. The WNLS parameter estimates for the nugget (9), range (140 m), and sill (35) estimates were significant at the 1% level. The F-test for the fitted semivariogra... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### A Generalized Framework for Measuring Pedestrian Accessibility around the World Using Open Data *

- DOI : `10.1111/gean.12290`
- TEI : `corpus\papers\tei\A_Generalized_Framework_for_Measuring_Pedestrian_Accessibility_around_the_World__W3161431278.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 49 | Data sources | This study identifies relatively consistent open data sources that can be used for calculating the pedestrian accessibility indicators. We describe the normalized datasets derived from these open data sources that can be used as input to the main analysis f... |
| low_priority_review | `DataSourceCandidate` | 48 | Sample point estimates processing | Local neighborhood estimates of population, street intersection densities and destination accessibility are evaluated using a multi-step process: a first pass analysis is undertaken using node points from the routable pedestrian network; a second pass analy... |
| low_priority_review | `DataSourceCandidate` | 47 | OSM destination and edge validation | OSM destination and edge validation comprises a quantitative analysis to compare OSM derived data against available local official data for evaluating the data quality, representation, and suitability for indicator calculation. In this process, the proporti... |
| low_priority_review | `DataSourceCandidate` | 47 | Points of interest (POIs) | Points of interest are obtained from OSM to calculate pedestrian access to destinations. A polygon filter file is generated for each study region's buffered boundary and used to extract a subset of relevant OSM data defined in the configuration stage; this... |
| low_priority_review | `DataSourceCandidate` | 46 | Population data and densities | Population data are used to account for local neighborhood population densities, evaluate the spatial distribution of population density across study regions, and estimate the percentage of population with access to destinations. Our process generates a vir... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Indicator Description Urban covariates Study region Study region name Population per sqkm Population per square kilometer of urban study region Intersections Street intersection count Intersections per sqkm Street intersections per square kilometer of urban... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Indicator Description Urban covariates Study region Study region name Area (sqkm) Urban study region area (square kilometer) Population estimate Urban study region population estimate Population per sqkm Population per square kilometer of urban study region... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Global Human Settlements Layer (GHSL) | The GHSL is a repository with global scope produced by the European Commission using mixed data sources including census data, satellite imagery, and volunteered geographic information. The GHSL datasets are provided under CC BY 4.0 licence terms, and inclu... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Indicator aggregation | After sample point estimates are calculated, a separate aggregation process is conducted to summarize them into relevant indicators for within-and between-city comparisons. The aggregation process includes three major components: a) calculate the average of... |

### A Review of Software for Spatial Econometrics in R

- DOI : `10.3390/math9111276`
- TEI : `corpus\papers\tei\A Review of Software for Spatial Econometrics in R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Crime in North Carolina | The second panel data set considered is based on a well known economic model of crime estimated by [17] . (The data are available from the website associated with Baltagi's book [18] .) They use a panel data on 90 counties in North Carolina over the period... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| low_priority_review | `ModelEvidenceCandidate` | 70 | Cross Sectional Models | The general model presented in this section allows for endogeneity of (some of) the regressors. The point of departure is the Cliff-Ord spatial model: where y is an n × 1 vector of observations on the dependent variable, Y is an n × p matrix of observations... |
| low_priority_review | `ModelEvidenceCandidate` | 70 | Early ML Estimation | The ML estimation methods for spatial lattice regression models grew from developments in Cliff and Ord [26] , soon afterwards refined in Ord [30] . In these and in [8, 31] , short-cuts were sought but largely rejected, in favour of optimizing the appropria... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Evolution of the GMM and Recent Developments | The theoretical development of the generalized methods of moments in spatial econometric models has been flourishing over the last 15 years. Many important scholars in the field got involved and major commercial software (like, for example, Stata) started i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Developments and Alternative Approaches in Cross-Sectional Models | One of many implementations of Markov Random Field (MRF) spatially structured random effects in generalized additive models (GAM) is found in Wood [91] , implemented in [92] . The neighbour objects needs to be matched to the variable expressing the random e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | The Pooled Spatial Model | If one could safely assume out any individual heterogeneity, spatial panels could be estimated by simply applying cross-sectional estimation techniques to the pooled dataset, employing an extended W matrix as specified above. This hypothesis, nevertheless,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Driving Under the Influence | One of the main advantages of GMM methods in space is that this technique is able to handle additional endogenous variables (other than the spatial lag). For this reason we choose to employ the simulated county data set US Driving Under the Influence (DUI)... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Spatial Filtering Methods | Spatial filtering methods as developed by Griffith [110] build on using standard linear and generalized linear models supplemented with selected eigenvectors from the spatial weights matrix. In [111] [112] [113] , examples were given of how standard and non... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Conclusions | This paper was dedicated to a review of the functionality for spatial econometric methods available in the R system for statistical computing, in the light of the historical developments of methods, mostly following a chronological order and hinting when ap... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Spatially Correlated Random Effects | The specification for the disturbances of [86] assumes that spatial correlation applies to both the individual effects and the idiosyncratic errors. Although the "Baltagi" and "KKP" data generating processes look similar, they do imply different spatial spi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Conditional and Joint Tests for Spatial or Random Effects | Building on the earlier literature, ref. [59] have extended the ML-based testing framework deriving joint, marginal and conditional tests for all combinations of random effects and spatial correlation. While the marginal tests are those already known, and t... |
| low_priority_review | `truncated` |  |  | 13 autres candidats non affiches dans ce rapport |

### A bootstrap test for constant coefficients in geographically weighted regression models

- DOI : `10.1080/13658816.2016.1149181`
- TEI : `corpus\papers\tei\A bootstrap test for constant coefficients in geographically weighted regression models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Some comments on the test | (1) Testing a globally stationary regression relationship. As one of the most important inferences in the GWR literature, the test for a globally stationary regression relationship can provide the information that a spatially varying coefficient model is re... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Some comments on the test | (1) Testing a globally stationary regression relationship. As one of the most important inferences in the GWR literature, the test for a globally stationary regression relationship can provide the information that a spatially varying coefficient model is re... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Application to Boston housing data | The proposed bootstrap test is illustrated by an application to the Boston housing data set given in Hurrison and Rubinfeld (1978) and corrected for a few minor errors by Gilley and Pace (1996) . The data set consists of the median value (MEDV in $1000) of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Application to Boston housing data | The proposed bootstrap test is illustrated by an application to the Boston housing data set given in Hurrison and Rubinfeld (1978) and corrected for a few minor errors by Gilley and Pace (1996) . The data set consists of the median value (MEDV in $1000) of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Construction of the test statistic | Based on the data set , fit the GWR model in Equation ( 1 ) (the alternative model) according to the estimation procedure described in Subsection 2.1 and compute the residual sum of squares where RðH 1 Þ ¼ ½I À Sðh 1 Þ T ½I À Sðh 1 Þ and h 1 is the optimal... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Construction of the test statistic | Based on the data set , fit the GWR model in Equation ( 1 ) (the alternative model) according to the estimation procedure described in Subsection 2.1 and compute the residual sum of squares where RðH 1 Þ ¼ ½I À Sðh 1 Þ T ½I À Sðh 1 Þ and h 1 is the optimal... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Null hypothesis | Corresponding variables p-Value β 0 (u,v) = β 0 Intercept 0.000 β 1 (u,v) = β 1 CRIM 0.568 β 2 (u,v) = β 2 INDVS 0.667 β 3 (u,v) = β 3 NOX 0.095 β 4 (u,v) = β 4 RM 0.000 β 5 (u,v) = β 5 AGE 0.678 β 6 (u,v) = β 6 DIS 0.021 β 7 (u,v) = β 7 RAD 0.398 β 8 (u,v)... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Null hypothesis | Corresponding variables p-Value β 0 (u,v) = β 0 Intercept 0.000 β 1 (u,v) = β 1 CRIM 0.568 β 2 (u,v) = β 2 INDVS 0.667 β 3 (u,v) = β 3 NOX 0.095 β 4 (u,v) = β 4 RM 0.000 β 5 (u,v) = β 5 AGE 0.678 β 6 (u,v) = β 6 DIS 0.021 β 7 (u,v) = β 7 RAD 0.398 β 8 (u,v)... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Step 1: Based on the original data y | , the alternative model (i.e. the full GWR model in Equation ( 1 )) is calibrated and the optimal bandwidth size h 1 is selected. Then, compute the residual vector εðh Y in Equation ( 6 ) and the residual sum of squares RSS(h 1 ) = Y T R(H 1 )Y in Equation... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Step 1: Based on the original data y | , the alternative model (i.e. the full GWR model in Equation ( 1 )) is calibrated and the optimal bandwidth size h 1 is selected. Then, compute the residual vector εðh Y in Equation ( 6 ) and the residual sum of squares RSS(h 1 ) = Y T R(H 1 )Y in Equation... |

### A dimension reduction approach to edge weight estimation for use in spatial models

- TEI : `corpus\papers\tei\A dimension reduction approach to edge weight.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 62 | Example: Mercer and Hall wheat yield data | We conclude this section with an analysis of the classic wheat yield dataset from Mercer and Hall (1911) and which is available in the spData R package. The version of the data used in the package was taken from Cressie (1993) . Mercer and Hall (1911) consi... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Visualizations of method and interpretation of basis coefficients | As discussed in Christensen and Hoff (2024) regarding the GDEF model, each possible edge weights matrix W corresponds to an embedding of the graph in high-dimensional Euclidean space which is unique up to isometry. The distances between nodes in this embedd... |
| low_priority_review | `ModelEvidenceCandidate` | 61 | Basis functions and spatial models | If y(s) is an observation of a random process at location s ∈ D within some spatial domain (D is typically a subset of R 2 , but could also be the set of spatial regions under the areal data setting), with spatially indexed predictors x(s), a typical model... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Incorporating covariate information | We may be interested in the question of whether certain environmental features inhibit or facilitate connectivity between regions in our spatial domain. As such we may wish to model edge weights as a function of environmental covariates. Generally speaking,... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Moran's and Shapiro-Wilk tests. RMSE MAE Coverage PI Width Moran's I Shapiro-Wilk GDEF 0.410 0.331 0.904 1.450 p = 0.460 p = 0.262 Matérn 0.436 0.355 0.936 1.689 p = 0.000 p = 0.028 H&H 0.684 0.552 0.898 2.209 p = 0.000 p = 0.934 Std. CAR 0.421 0.340 0.940... |

### A flexible approach for statistical disclosure control in geospatial data

- DOI : `10.1007/s10109-025-00472-5`
- TEI : `corpus\papers\tei\A_flexible_approach_for_statistical_disclosure_control_in_geospatial_data_W4413835929.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Year Type Variables Surveyed Population Countries farms* covered* (MM) (MM) 2010 Census 419 12.81 13.03 33 2013 Sample 358 1.73 11.04 30 2016 Sample 363 1.69 10.55 30 2020 Census 364 9.03 9.16 30 Note. * Covers all Member States, candidate, and EFTA countri... |

### A gap analysis modelling framework to prioritize collecting for ex situ conservation of crop landraces

- DOI : `10.1111/ddi.13046`
- TEI : `corpus\papers\tei\RamirezVillegas2020Gap.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Spatial predictors | With the aim of compiling a robust global dataset of important environmental and anthropogenic drivers of the geographic distributions of crop landraces, we gathered and/or calculated spatially explicit (gridded) information for a total of 50 potential pred... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Challenges and limitations to landrace distribution modelling and conservation gap analysis | Predicting the distributions of cultivated plants, whose ranges are determined by anthropogenic along with environmental drivers, presents a challenge that has not been fully resolved in geospatial sciences. While we attempted to gather the widest range of... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Modelling landrace geographic distributions | The objective of this step was to develop a Landrace Distribution Model (LDM) which describes the probability of occurrence of the landrace groups derived from Section 2.4.1. To predict the probability of occurrence for each landrace group, we fitted a MaxE... |

### A geographic feature integrated multivariate linear regression method for house price prediction

- TEI : `corpus\papers\tei\A geographic feature integrated multivariate linear regression method.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Case Study | The King County Houses Sales data set has 21613 house sales records between May 2014 to May 2015. It provides prices and some other potentially related features(See table 1 ). Table 2 𝑅 2 of regression models Model Training Set Test Set Cross-validation lin... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Proposed approach | Our method can generally be summarized as two folds. First, find a proxy to contain the geographic information possibly related to the housing prices. This proxy is an index for classification to divide the data set into different classes. Then, for each cl... |

### A multi-scale area-interaction model for spatio-temporal point patterns

- TEI : `corpus\papers\tei\A_multi_scale_area_interaction_model_for_spatio_temporal_point_patterns_W2626375101.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |

### A national-scale model of linear features improves predictions of farmland biodiversity

- DOI : `10.1111/1365-2664.12912`
- TEI : `corpus\papers\tei\Sullivan2017National.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | E N V I R O N M E N T A L D A T A | Land-cover data were obtained from LCM 2007. Land-cover classes were aggregated in some instances (Table 1 ), and their proportion in 1-km radius buffers around BBS square and UKBMS transect centroids was extracted in ArcMAP 10.0 (ESRI 2010). The 1-km buffe... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Marginal R 2 Conditional R 2 Taxa Explanatory variables Model structure (mean AE SE) (mean AE SE) Birds Full Land cover 0Á339 AE 0Á068 0Á683 AE 0Á045 Land cover + Linear features 0Á344 AE 0Á066 0Á680 AE 0Á046 Land cover * Linear features 0Á351 AE 0Á066 0Á68... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | S T A T I S T I C A L A N A L Y S I S | We modelled bird and butterfly abundance at each site in each year as a function of environmental variables using generalised linear mixed models with a Poisson error term. We used an observation-level random effect to account for overdispersion (Elston et... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Abundance models with land-cover explanatory variables had moderate explanatory power (mean marginal R 2 across species in each group: birds = 0Á339 AE 0Á068 SE, butterflies = 0Á206 AE 0Á025 SE), although the year term explained a considerable proportion of... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |

### A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models ☆

- DOI : `10.1016/j.regsciurbeco.2017.04.001`
- TEI : `corpus\papers\tei\MGWR-SAR_Geniaux&Martinetti.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 68 | DGPs with spatial autocorrelation and spatially varying coefficients | In spatial econometric literature, a regression model that considers spatial autocorrelation of the endogenous variable Y is formally written as: where Y is the n-vector of the continuous dependent variable, X is a matrix of k exogenous explanatory variable... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Estimators for models with spatial autocorrelation and spatial heterogeneity | Although most of the models involving local parameters are unidentifiable because they suppose more parameters than observations, we found in the literature different ways to approximate these local coefficients by introducing conditions on local continuity... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | GWR MGWR | β 0 and β 2 stat. β 0 stat. β 2 stat. 6631 0.1090 0.3344 0.1953 RMSE 0.6816 0.1460 0.3656 0.2289 β u v ( , ) i i 0 BIAS 0.0044 0.0037 0.0039 0.0053 RMSE 0.0068 0.0059 0.0063 0.0073 β u v ( , ) i i 0 BIAS -0.5843 -0.1300 -0.3559 -0.2547 RMSE 0.6011 0.1674 0.... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Motivations for spatially varying coefficient models in urban economics | Spatial heterogeneity problems in regression models are, in our point of view, inseparable from other issues such as non-linearities and spatial autocorrelation. It is the case, for example, of the effects of land area on land price in hedonic price functio... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 12 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | year 1995 1996 Est. W RSS AIC PMSE 10 PMSE 20 RSS AIC PMSE 10 PMSE 20 SAR W soi 152.002 7.020 0.193 0.197 224.616 7.411 0.218 0.223 SAR W opt 150.520 7.011 0.195 0.198 216.116 7.373 0.226 0.234 MGWR-SAR( k k 0, , c v ) W opt 95.596 5.143 0.175 0.177 128.032... |

### A novel individual-tree mixed model to account for competition and environmental heterogeneity: a Bayesian approach

- DOI : `10.1007/s11295-015-0917-3`
- TEI : `corpus\papers\tei\A_novel_individual_tree_mixed_model_to_account_for_competition_and_environmental_W2180965326.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Models of analysis | Four individual-tree mixed models were evaluated in the loblolly pine dataset. All models included a random direct additive genetic effect and a random effect of commercial seed lots. The latter was to avoid biasing in the estimates of the additive genetic... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |

### A space-time conditional intensity model for invasive meningococcal disease occurrence

- DOI : `10.1111/j.1541-0420.2011.01684.x`
- TEI : `corpus\papers\tei\spatstat.data_meningitis - A SpaceTime Conditional Intensity Model for Invasive Meningococcal Disease Occurrence.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | Extension: Type-Specific twinstim | Although the model of the previous subsection allows for a finetype-specific infectivity through the vector of unpredictable marks m j , it is not applicable for a joint modelling of both finetypes. This is because finetypes do not change during transmissio... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Specification of the Endemic Component h(t, s) | The endemic component is of the multiplicative form h(t, s) = ρ(t, s) exp(β z(t, s)), where ρ(t, s) is a known spatio-temporal intensity offset, e.g. the population density at time t in the district containing the location s, such that the endemic rate of i... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 |

### A spatio-temporal autoregressive model for monitoring and predicting COVID infection rates

- DOI : `10.1007/s10109-021-00366-2`
- TEI : `corpus\papers\tei\A_spatio_temporal_autoregressive_model_for_monitoring_and_predicting_COVID_infec_W4224505438.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Time dependent autoregressive count data models | Consider Poisson distributed counts at times t = 1, ..., T, namely y t ∼ Poi( t ), (with Poi for Poisson density, with means t ), or negative binomial (NB) counts, y t ∼ Negbin( t , Ω) (with Negbin for negative binomial density, with means t and dispersion... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Covariate effects | There have been many studies on socio-demographic and environmental risk factors for COVID outcomes. Both incidence and mortality have been linked to area deprivation, urbanicity, poor air quality, and nursing home location (as area risk factors), and non-w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Random coefficient autoregressive area-time models | To generalize these representations to area-time infection count data (areas i = 1, ..., N ), one may add lags to infection counts in spatially close areas (Mar- tines et al. 2021) . These reflect geographic infection spillover-due, for example, to social i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Related Research | The typical form of data encountered in analysis of spatio-temporal infections data involves incidence counts y it for areas i = 1, ..., N and times t = 1, ..., T . However, some spatio-temporal models for such data have used normalizing transformations of... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Remaining effects | For the permanent terms i and e i , one might use iid or spatially correlated ran- dom effects i to represent enduring risk variations for infectious disease, in both endemic and epidemic phases. For example, taking iid effects, and with a positivity constr... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | Methods | We focus here on infectious disease models using count data regression. We consider first models for count time series, without area disaggregation, as these can provide a basis for generalisation to area-time data. Relevant specifications may specify AR de... |

### A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time

- DOI : `10.5194/gmd-13-6149-2020`
- TEI : `corpus\papers\tei\A spatiotemporal weighted regression model for nontationarity.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 60 | Case study 1 | The time interval of observations in case study 1 was one unit, such as 1 s or 1 d. The value changes of x 1 and x 2 were generated by η 1 = 0.5 and η 2 = 0.1 and were affected by T 1 V with ϕ = 0.5 and n power = 1. This means that x 1 and x 2 only changed... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Case study 2 | The time interval of observations in case study 2 was 10 units. The value change of x 1 was generated by η 1 = 0.5 and affected by T 3 V with ϕ = 0.5, and n power = 2. x 2 was generated by η 2 = 2 and affected by T 2 V with ϕ = 1 and n power = 1, which indi... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Results with simulated data | We compared the results of OLS, GWR, GTWR, and STWR. A total of 333 random sample points for five time stages (t 0 , t 1 , t 2 , t 3 , and t 4 from old to new) were collected from the 25×25 lattice generated in the abovementioned DGP. To simplify the calcul... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | The strategy of time distance decay | Since GWR is the background of our work, it is helpful to first give a brief overview of the GWR framework. The basic formulation of GWR can be described in the two equations below (Fotheringham et al., 2003) . In Eq. ( 1 ), y i is a response variable of re... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Bandwidth selection and parameter estimation | Some goodness-of-fit diagnostics (Loader, 1999) are widely used in general GWR-based models, such as the crossvalidation (CV) score (Cleveland, 1979; Bowman, 1984) and the Akaike information criterion (AIC) (Akaike, 1973 (Akaike, , 1998)) . For STWR, we use... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Reasonable searching range and procedure of optimization | In order to obtain the optimized α and θ for STWR (Eqs. 8 and 9), the search range should be limited. Here we use the distance from each regression point p ( t) i to its Mth nearest neighbor as the initial spatial bandwidth b St at t. The range of b St is w... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Section 1 | various natural and socioeconomic processes. Many studies have attempted to introduce time as a new dimension into a geographically weighted regression (GWR) model, but the actual results are sometimes not satisfying or even worse than the original GWR mode... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Time stage t 4 SSE AICc R2 Sigma OLS 676 366.268 805.455 0.138 GWR 45 674.420 705.529 0.942 33.277 GTWR 40 056.823 616.641 0.949 23.331 STWR 5761.109 528.860 0.993 4.293 tiotemporal kernel in Eq. ( |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Time stage t 4 SSE AICc R2 Sigma OLS 5 085 961.816 938.610 0.494 GWR 300 088.969 840.178 0.970 87.201 GTWR 627 011.021 895.662 0.938 127.821 STWR 52 688.545 709.573 0.995 13.299 |

### A structured comparison of causal machine learning methods to assess heterogeneous treatment effects in spatial data

- DOI : `10.1007/s10109-023-00413-0`
- TEI : `corpus\papers\tei\A_structured_comparison_of_causal_machine_learning_methods_to_assess_heterogeneo_W4380538427.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Spatial models | In fact, spatial effects can impact the basic causal inference framework in a variety of complex ways, including treatment assignment (ignorability), spillover effects (SUTVA), mismatched scales for spatial processes and outcomes, and more. Given this, Kola... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Spatial T-learner (STL) | This paper also explores an alternative "forest"-based approach to estimating the CATE, which we have called the "spatial" T-learner (STL) after the two-stage (T) metalearner described in Künzel et al. (2019) . The basic concept for the spatial T-learner is... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Structured model comparison using simulated data | The primary goal of this paper is to compare the performance of causal machine learning methods (Models B-D in Table 1 ) with traditional OLS (Model A) across four different spatial specifications: a baseline (non-spatial) model based in Eq. ( 1 ), 4 ). 6 I... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Causal forest | The causal forest is a type of "generalised" random forest that produces predicted values of the unit-level conditional average treatment effects rather than predicted values of the outcome variable, as in the traditional random forest (Athey et al. 2019) .... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | To better understand the impact of light rail construction on CO 2 emissions and the spatial nature of heterogeneities in this impact, we are primarily interested in three items: (1) the estimated ATE from the causal forest model, (2) the heterogenous relat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Treatment and control groups, variables, and model specification | To test the impact of light rail construction on CO 2 emissions at the block group scale in Phoenix, we first must delineate suitable "treatment" and "control" areas. Whilst distances from 1/4 mile to one mile have been put forward in previous research as b... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Simulated data design | It is difficult to structure a true comparison of the performance of different causal machine learning methods at identifying average and unit-level TE without knowing the values of these effects beforehand, which necessitates the use of some simulated data... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |

### A two-step approach to account for unobserved spatial heterogeneity 1

- DOI : `10.1111/j.1435-5957.2010.00279.x`
- TEI : `corpus\papers\tei\A_two_step_approach_to_account_for_unobserved_spatial_heterogeneity_W2558993060.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Data sets and results | In order to detect the presence of unobserved spatial heterogeneity in the form of spatial regimes and to prove the usefulness of the above two-step approach, we use baltimore and house data sets 9 which summarizes the information on house sales prices in B... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | INSERT TABLE 1 HERE | INSERT FIGURE 1 HERE 9 For details see the spdep package in R (Bivand, 2014) . Tables 2 and 3 with subsamples 𝑛 1 = 101 and 𝑛 2 = 110, mostly dividing the central and the northwest areas from the south and the northeast ones (Figure 2(a) ). Considering AIC... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 5 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | baltimore data set GLOBAL MODELS Coefficients OLS SAR SEM SARAR SDM intercept 2.463 -6.173 . 3.674 -6.125 . 22.920 * dwell 8.171 *** 7.336 *** 9.223 *** 7.547 *** 8.422 *** nbath 7.653 *** 6.839 *** 7.854 *** 6.960 *** 6.226 *** patio 9.948 *** 8.443 *** 7.... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | baltimore data set MODELS WITH SPATIAL REGIMES Coefficients OLS SAR SEM SARAR SDM intercept1 -4.997 -16.409 *** -5.274 -16.670 *** -194.163 * intercept2 12.042 . 0.206 11.374 * -0.602 -16.976 dwell1 6.314 * 6.004 * 8.635 ** 5.269 . 5.551 * dwell2 8.222 ** 7... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | house data set MODELS WITH SPATIAL REGIMES Coefficients OLS SAR SEM SDM intercept1 -5.68E+05 * -5.08E+05 ** -7.53E+05 *** 1.92E+08 . intercept2 -3.29E+05 -6.27E+05 *** -4.93E+05 *** -6.49E+07 . intercept3 4.58E+05 -1.52E+05 -2.09E+05 . 3.85E+07 intercept4 -... |

### AMLB: an AutoML Benchmark

- DOI : `10.1145/1656274.1656278`
- TEI : `corpus\papers\tei\gijsbers_2024_amlb.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Meta-learning | Many AutoML frameworks make use of meta-learning to better initialize and speed up the search (Yang et al., 2018; Feurer et al., 2015a Feurer et al., , 2020)) . Since all data in the benchmark is publicly available and many of them are well known in the Aut... |
| low_priority_review | `DataSourceCandidate` | 45 | Related Literature | In this section, we motivate why we need benchmarks specifically designed for AutoML, review other work evaluating AutoML frameworks, and finally discuss the relevant ML benchmarking literature. Several benchmark suites have been developed in ML (Van Gestel... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Missing Values In Experimental Results | As will be discussed in more detail in Section 6.4, not all frameworks are equally wellbehaved. There are situations where search time budgets are exceeded or the AutoML frameworks crash outright, which results in missing performance estimates. There are mu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Results | In this section, we provide an overview and analysis of the results obtained. This section is accompanied by an interactive visualization tool foot_4 , additional information in Appendix B, and all data artifacts generated from these experiments. 20 For a m... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Appendix A. OpenML Benchmark Suites | Table 2 and Table 3 contain an overview of data sets used in the regression and classification benchmarking suites, respectively. We hope to continuously update the benchmarking suites with new data sets that represent current challenges. Table 15: Results... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | B.1 BT-Trees | As described in Section 6.2, Bradley-Terry (BT) trees may be used to identify subsets of tasks for which the 'preferred' framework is significantly different. Figures 10-12 show BT trees for each task type and time budget, generated by splitting based on di... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Bradley-Terry Trees | Bradley-Terry (BT) trees (Strobl et al., 2011) can be used to statistically analyse benchmark experiments based on data set characteristics (Eugster et al., 2014) . These trees use data set characteristics-such as the number of instances, the number of feat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Evaluation of Automated Machine Learning Frameworks | To establish new best practices for AutoML benchmarking, it is beneficial to study the shortcomings encountered in prior benchmarks as well as lessons learned. Balaji and Allen (2018) conducted one of the first benchmark studies on AutoML frameworks. They e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Observed AutoML Failures | While most jobs completed successfully, we observed multiple framework errors during our experiments. In this section, we will discuss where AutoML frameworks fail, although we want to stress that development for these packages is ongoing. For that reason,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Performance Metrics | In our evaluation, we use area under the receiver operating characteristic curve (AUC) for binary classification, log loss for multi-class classification and root mean-squared error (rmse) for regression to evaluate model performance. 15 We chose to use the... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Benchmark Suites | To facilitate a reproducible experimental evaluation, we make use of OpenML Benchmark suites (Bischl et al., 2021 ). An OpenML benchmark suite is a collection of OpenML tasks, which each reference a data set, an evaluation procedure (such as k-fold cross-va... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | auto-sklearn | Based on the design of AUTO-WEKA, AUTO-SKLEARN (Feurer et al., 2015a) also uses Bayesian optimization but is instead implemented in Python and optimizes pipelines built with SCIKIT-LEARN (Pedregosa et al., 2011) . Additionally, it warm-starts optimization t... |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### APRANK: computational prioritization of antigenic proteins and peptides from complete pathogen proteomes

- DOI : `10.1101/2021.04.27.441630`
- TEI : `corpus\papers\tei\APRANK_computational_prioritization_of_antigenic_proteins_and_peptides_from_comp_W3159682291.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data normalization | Each predictor used by APRANK varied on how they returned their values. Not only they had different value ranges, but while some of them returned their values per protein, others did so per peptide, kmer, or amino acid. For this reason, we needed to parse a... |
| low_priority_review | `DataSourceCandidate` | 45 | Comparative performance | To discard the possibility that our model was simply detecting sequence similarity, we created a 'BLAST model', where we assigned to each protein a score based solely on how similar they were to a known antigenic protein from another organism. The score use... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Development of APRANK as a pan-species ranker of antigens and epitopes | In the previous section we used protein and peptide data from a given pathogen species to train a model that successfully predicted antigenicity for that same organism; however, our end goal was to have a model that was able to predict antigenicity for any... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | CONTRIBUTION TO THE FIELD | The ability to predict which pathogen molecules elicit an immune response and are the target of antibodies during an infection is key for many diagnostic and clinical applications. Over time a number of predictors have been developed that seek to identify l... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Species | Figure S3 . Coefficient values for the leave-one-out generic models. Plots were obtained by recording the coefficient of each predictor in the binomial logistic regression models. The different protein models correspond to each of the 15 leave-out-out gener... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 . |

### Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key source to the C sink

- DOI : `10.1080/17583004.2021.1962979`
- TEI : `corpus\papers\tei\Above ground carbon stock mapping over coimbatore and Nilgiris biosphere.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `ModelEvidenceCandidate` | 59 | Stepwise multiple linear regression model (SMLR) | SMLR-the most widely used non-spatial predictive regression analysis technique to explain the correlation between dependent and independent variables [61, 62] . Using SMLR in AGC estimation, the stepwise regression fitting method was adapted by applying it... |
| low_priority_review | `ModelEvidenceCandidate` | 59 | Stepwise multiple linear regression model (SMLR) | SMLR-the most widely used non-spatial predictive regression analysis technique to explain the correlation between dependent and independent variables [61, 62] . Using SMLR in AGC estimation, the stepwise regression fitting method was adapted by applying it... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Gwr model | Geographically Weighted Regression (GWR)-the local spatial model was used to reckon AGC with spatial autocorrelation preponderance. GWR was fitted with a suitable variable using the Ordinary Least Square (OLS) regression model. Regulating both, the variable... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Gwr model | Geographically Weighted Regression (GWR)-the local spatial model was used to reckon AGC with spatial autocorrelation preponderance. GWR was fitted with a suitable variable using the Ordinary Least Square (OLS) regression model. Regulating both, the variable... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | SMLR model | For the precise understanding of AGC dynamics, SMLR-a prevalent multivariate method of stepwise regression model was used for an accurate assessment. To prognosticate the estimate, SMLR was used to produce quantitatively fitting variable coefficients with t... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | SMLR model | For the precise understanding of AGC dynamics, SMLR-a prevalent multivariate method of stepwise regression model was used for an accurate assessment. To prognosticate the estimate, SMLR was used to produce quantitatively fitting variable coefficients with t... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methodology and model-description | To estimate AGC at a regional scale, SMLR-a nonspatial predictive regression analysis and GWRspatially weighted regression analysis models were constructed and used in this study. To maximize the study's understanding, the better estimated AGC model was att... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methodology and model-description | To estimate AGC at a regional scale, SMLR-a nonspatial predictive regression analysis and GWRspatially weighted regression analysis models were constructed and used in this study. To maximize the study's understanding, the better estimated AGC model was att... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model comparison | For evaluating the model's performance, Taylor diagram analysis was performed [80] . Through the law of cosines, statistics of R, RMSE and SD were plotted contemporaneously to analyse their relation in Figure 7 . All the SMLR model years exhibited practical... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model comparison | For evaluating the model's performance, Taylor diagram analysis was performed [80] . Through the law of cosines, statistics of R, RMSE and SD were plotted contemporaneously to analyse their relation in Figure 7 . All the SMLR model years exhibited practical... |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Accepted Article

- DOI : `10.1111/2041-210X.12690`
- TEI : `corpus\papers\tei\A_multistate_dynamic_site_occupancy_model_for_spatially_aggregated_sessile_commu_W2418568409.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Section 1 | 1. Estimation of transition probabilities of sessile communities seems easy in principle but may still be difficult in practice because resampling error (i.e., a failure to resample exactly the same location at fixed points) may cause significant estimation... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Accepted Article | The hierarchical formulation of the model allows us to readily extend the proposed model, at least conceptually, to add more ecological realism (Royle & Dorazio 2008; Kéry & Schaub 2012; Kéry & Royle 2016) . For example, if some site-or time-specific enviro... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

### Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models

- DOI : `10.1371/journal.pcbi.1008831`
- TEI : `corpus\papers\tei\Accuracy_in_the_prediction_of_disease_epidemics_when_ensembling_simple_but_highl_W3136686952.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Observational data | The data matrix consisted of 999 assessments of FHB in wheat, where the observations were made in research plots across multiple U.S. states. Plots received no fungicide treatment for disease control, and standard agronomic practices were followed for the a... |
| low_priority_review | `DataSourceCandidate` | 45 | Model fitting and evaluation | There were 273 observations of FHB epidemics (as defined by Eq 1) out of 999 total observations. Ten-fold cross-validation (cv) was used to obtain estimates of model performance. For the cv procedure, the full dataset was divided randomly into 10 (approxima... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | The response variable | As with all our past work, the continuous variable S (on a 0 to 100 percentage scale) was dichotomized to a binary classification variable y, where for the i th observation. That is, y i were realizations of the random variable Y i representing whether the... |

### Agricultural technology adoption and land use: evidence for Brazilian municipalities

- DOI : `10.1080/1747423X.2019.1707312`
- TEI : `corpus\papers\tei\Agricultural technology adoption and land use - evidence for Brazilian municipalities.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 3 . |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Model (1) Equations N j;i ¼ f N Àj;i ; T i ; C i ; E i ; N j tÀ1 ð Þ;i ; ε j À Á Simultaneity Feedback Description In the feedback model, the equation that intends to explain the land use j in region i (N j;i ) has as determinants the other types of use (N... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Instrumental variables | Within the system of simultaneous equations, land use variables (N) can not be treated as exogenous to the model. In order to deal with this endogeneity, in this article, the instrumental variable used is time-lag land use (N tÀ1 ð Þ ). This variable can be... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Appendices | Appendix A. Auxiliary tables. Table A1. Stakhovych and Bijmolt Criteria for selection of spatial lag matrix*. Spatial lag matrix Cropland (cr) Pasture (pt) Forest (ft) 1-nearest neighbor (k1) 7635.49 7815.27 9378.89 5-nearest neighbors (k5) 7288.16 7724.41... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Exploratory analysis of spatial data: spatial autocorrelation tests | The presence of spatial autocorrelation was tested globally and locally via the Moran and the LISA (Local Indicator of Spatial Association) indexes, respectively. The existence of spatial patterns was verified for the dependent variables (land use) and the... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Economic model | We use microeconomic assumptions for land use analysis. The land use model is derived from the problem of profit maximization of the farmer. The production function for each land use category is described as: where j is the land use category, y j is the pro... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Econometric results | Figure 3 presents the determinants of agricultural and forestry land use using a structural model (4), following Kelejian and Robinson (1993) for the estimation procedure. All models estimated can be seen in Appendix B (Tables B1-B4 ). In this model structu... |

### Airbnb Offer in Spain-Spatial Analysis of the Pattern and Determinants of Its Distribution

- DOI : `10.3390/ijgi8030155`
- TEI : `corpus\papers\tei\Adamiak_2019_AirbnbSpainSpatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Total Entire Private Shared Listings Homes/Apartments Rooms Rooms (Intercept) -0.144 *** -0.117 *** -0.054 *** -0.001 Primary dwellings (per km 2 , ln) -0.042 *** -0.055 *** 0.004 * - Nonprimary dwellings (per km 2 , ln) 0.133 *** 0.129 *** 0.023 *** 0.001... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 6 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Finding Factors That Explain the Distribution of Airbnb Listings | In order to identify the factors affecting the distribution of Airbnb listings in Spain, we developed a series of regression models. We built eight models: for each territorial unit of analysis (municipality and tourist areas/sites) and for each type of Air... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Factors Affecting the Distribution of Airbnb Listings | After developing four simple regression models at the municipal level, the majority of the explaining variables proved to significantly affect the dependent variables (Table A5 in appendix D). This is partially a result of a large sample size. Despite corre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Factors Affecting the Distribution of Airbnb Listings | After developing four simple regression models at the municipal level, the majority of the explaining variables proved to significantly affect the dependent variables (Table A5 in Appendix D). This is partially a result of a large sample size. Despite corre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Shortage of hotel capacity | Occupancy of hotel rooms (percent, average monthly value between XI 2017 and X 2018; Hotel occupancy survey) Seasonality ratio (ratio between the highest and the lowest monthly number of hotel guests between X 2017 and IX 2018; Hotel occupancy survey) 5. Ac... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Amphibian functional diversity is related to high annual precipitation and low precipitation seasonality in the New World

- DOI : `10.1111/geb.12926`
- TEI : `corpus\papers\tei\Amphibian_functional_diversity_is_related_to_high_annual_precipitation_and_low_p_W2943359851.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | / ME THODS | We compiled existing data on the following traits for American presence/absence of parental care (e.g., Algar, Kerr, & Currie, 2011; De Lisle & Rowe, 2013; Han & Fu, 2013; Sodhi et al., 2008) . This dataset contains 2,776 species occurring in Continental Am... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Spatial autoregressive models for Shannon and Gini-Simpson indices | In the SAR model for the Shannon index, the contribution of annual precipitation was significantly positive; annual mean temperature was negative and non-significant. Precipitation seasonality was significantly negative. The aridity index was always signifi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Spatial autoregressive models for areas with residuals of species functional richness | The SAR model for the top quartile of positive residuals (higher functional diversity than expected) showed a negative and significant relationship with precipitation seasonality and a positive and significant (but less strong) relationship with annual prec... |

### An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States

- DOI : `10.1021/acs.est.0c01791`
- TEI : `corpus\papers\tei\AnEnsembleLearningApproachforEstimatingHighSpatiotemporalResolution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Cross Validation (Seventh Stage). | We performed individual 10-fold cross validation for each one of the three models applied in this study: neural network, random forest, and gradient boosting. Here, we first divided the monitoring sites into 10 splits, and then we trained the models with 90... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Cross Validation (Seventh Stage). | We performed individual 10-fold cross validation for each one of the three models applied in this study: neural network, random forest, and gradient boosting. Here, we first divided the monitoring sites into 10 splits, and then we trained the models with 90... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Model Training (Fourth Stage). | After imputing missing values, we standardized the dataset. Considering a variable "X", data standardization was based on X ij -X mean /X std where X ij is the raw data of the variable "X" on day i in the site j and X mean and X std are the mean and standar... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Model Training (Fourth Stage). | After imputing missing values, we standardized the dataset. Considering a variable "X", data standardization was based on X ij -X mean /X std where X ij is the raw data of the variable "X" on day i in the site j and X mean and X std are the mean and standar... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Study Design. | This study was conducted in seven stages. First, we accessed multiple datasets that included daily maximum 8 h O 3 concentrations at sites across the United States and the predictor variables for O 3 , which included weather parameters, gridded output from... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Study Design. | This study was conducted in seven stages. First, we accessed multiple datasets that included daily maximum 8 h O 3 concentrations at sites across the United States and the predictor variables for O 3 , which included weather parameters, gridded output from... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Machine Learning Approaches. | We used three machine learning models in this study, including a neural network, random forest, and gradient boosting. All three models were used to attempt to model the complex relationship between the dependent variable and predictor variables with differ... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Machine Learning Approaches. | We used three machine learning models in this study, including a neural network, random forest, and gradient boosting. All three models were used to attempt to model the complex relationship between the dependent variable and predictor variables with differ... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Predictions (Fifth Stage) and Ensemble Model (Sixth Stage). | After filling in missing values and interpolating data to 1 km grid cells, all predictor variables were available across the study area. Then, we used the trained models to predict daily maximum 8 h O 3 concentrations at each 1 km × 1 km grid cell in the co... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Predictions (Fifth Stage) and Ensemble Model (Sixth Stage). | After filling in missing values and interpolating data to 1 km grid cells, all predictor variables were available across the study area. Then, we used the trained models to predict daily maximum 8 h O 3 concentrations at each 1 km × 1 km grid cell in the co... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### An Introduction to Spatial Data Analysis and Visualisation in R

- TEI : `corpus\papers\tei\Introduction to Spatial Data Analysis and Visualisation in R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 58 | Downloading data from the CDRC data website | Before we introduce you to R and Rstudio, we will first download some data from the CDRC Data Service. On an internet browser go to https://data.cdrc.ac.uk/ In the top right of the screen you will see options to log in or register for an account. If you hav... |
| review_for_dataset_use | `DataSourceCandidate` | 50 | Loading point data into R | In this practical we will be handling house price paid data originally made available for free by the Land Registry. The sample dataset can be downloaded from the CDRC website here . The data is formatted as CSV where each row is a unique house sale, includ... |
| low_priority_review | `DataSourceCandidate` | 48 | Joining data in R | We next want to combine the data into a single dataset. Joining two data frames together requires a common field, or column, between them. In this case it is the OA field. In this field each OA has a unique ID (or OA name), this IDs can be used to identify... |
| low_priority_review | `DataSourceCandidate` | 47 | Practical 7: Using R as a GIS | This practical is intended to provide a demonstration of some of the basic spatial functionality of R by taking you through a small number of commonly employed techniques. Data for the practical can be downloaded from the Introduction to Spatial Data Analys... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Inference with regression | In real world applications, we have access to a set of observations from which we can compute the least squares line, but the population regression line is unobserved. So our regression line is one of many that could be estimated. A different set of Output... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Mutliple regression | So we have seen our models with just one predictor or explanatory variable. We can build 'better' models by increasing the number of predictors. In our case we can also add another variable into the model for predicting the number of people with degree leve... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Practical 10: Geographically Weighted Regression in R | An Introduction to Spatial Data Analysis and Visualisation in R -Guy Lansley & James Cheshire (2016) This practical will teach you how to run a Geographically Weighted Regression (GWR). GWR is a multivariate model which can indicate where non-stationarity m... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | R squared | In the output above we saw there was something called the residuals. The residuals are the differences between the observed values of Y for each case minus the predicted or expected value of Y, in other words the distances between each point in the dataset... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Regression analysis | A simple linear regression plots a single straight line of predicted values as the model for a relationship. It is a simplification of the real world and its processes, that assumes that there is approximately a linear relationship between X and Y. Another... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Run a linear model | First, we will run a linear model to understand the global relationship between our variables in our study area. In this case, the percentage of people with qualifications is our dependent variable, and the percentages of unemployed economically active adul... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Using gridExtra | We will now consider some of the other outputs. We will create four maps in one image to show the original distributions of our unemployed and White British variables, and their coefficients in the GWR model. To facet four maps in tmap we can use functions... |

### An analysis about the accuracy of geographic profiling in relation to the number of observations and the buffer zone

- DOI : `10.1007/s10109-022-00379-5`
- TEI : `corpus\papers\tei\An_analysis_about_the_accuracy_of_geographic_profiling_in_relation_to_the_number_W4281665765.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods | In order to generalize the results to other fields outside criminology, we will use in the next lines the terms of cases/objects/events instead of crimes; spreading centre or centre of origin instead of "anchor points" as previously used by other authors, d... |

### An ensemble-based model of PM 2.5 concentration across the contiguous United States with high spatiotemporal resolution

- DOI : `10.1016/j.envint.2019.104909`
- TEI : `corpus\papers\tei\An ensemble-based model of PM2.5 concentration across the contiguous united states with high spatiotemporal resolution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Gradient boosting % Neural network % Random forest % Spatially lagged monitored PM 2.5 46.52% AOD related variables [c] 9.25% Spatially lagged monitored PM 2.5 28.96% CMAQ PM 2.5 11.58% Spatially lagged monitored PM 2.5 2.68% CMAQ PM 2.5 16.51% CMAQ PM 2.5... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Gradient boosting % Neural network % Random forest % Spatially lagged monitored PM 2.5 46.52% AOD related variables [c] 9.25% Spatially lagged monitored PM 2.5 28.96% CMAQ PM 2.5 11.58% Spatially lagged monitored PM 2.5 2.68% CMAQ PM 2.5 16.51% CMAQ PM 2.5... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Machine learning algorithms | Neural networks are able to model any kind of nonlinear and interactive relationship given enough data, suitable for modeling PM 2.5 , where the underlying atmospheric dynamics are elusive, and variables have complex interactions (Bishop, 1995; Haykin and N... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Machine learning algorithms | Neural networks are able to model any kind of nonlinear and interactive relationship given enough data, suitable for modeling PM 2.5 , where the underlying atmospheric dynamics are elusive, and variables have complex interactions (Bishop, 1995; Haykin and N... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Base learners and ensemble model | The details of neural network, random forest and gradient boosting algorithms can be found elsewhere (Bishop, 2006) . A simple explanation is that all three machine learning algorithms attempt to model the complex relationship between input variables (X's,... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Base learners and ensemble model | The details of neural network, random forest and gradient boosting algorithms can be found elsewhere (Bishop, 2006) . A simple explanation is that all three machine learning algorithms attempt to model the complex relationship between input variables (X's,... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Model prediction | After filling in missing values and interpolating, all input variables were available across the study area. We trained the three base learners and the ensemble model with input variables and monitored PM 2.5 as the dependent variable, and then used trained... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Model prediction | After filling in missing values and interpolating, all input variables were available across the study area. We trained the three base learners and the ensemble model with input variables and monitored PM 2.5 as the dependent variable, and then used trained... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Results | Table 1 presents the cross-validated R 2 by year. R 2 values ranged from 0.75 to 0.90, with an average of 0.86, indicating good model performance. The spatial R 2 ranged from 0.73 to 0.91, with an average of 0.89, demonstrating that our model can well captu... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Results | Table 1 presents the cross-validated R 2 by year. R 2 values ranged from 0.75 to 0.90, with an average of 0.86, indicating good model performance. The spatial R 2 ranged from 0.73 to 0.91, with an average of 0.89, demonstrating that our model can well captu... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### An extended framework for spatial disaggregation models

- DOI : `10.1007/s10109-026-00495-6`
- TEI : `corpus\papers\tei\An_extended_framework_for_spatial_disaggregation_models_W7162291200.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Standardised regression parameters Dependent variable Predictor Mean St Devn 2.5% 97.5% Crime Urbanicity 0.152 0.018 0.117 0.190 Area SES -0.704 0.020 -0.742 -0.664 Cohesion indicators Trust Crime -0.979 0.055 -1.079 -0.859 Urbanicity -0.027 0.004 -0.155 0.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Latent construct measured by multiple target indicators used to predict observed health outcomes: the framework for t... | We now consider joint modelling frameworks in causally oriented applications, which are the main innovative focus in the present paper. In the first framework set out in Sect. 1.1, we propose multiple target area regressions in a single joint likelihood mod... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Modelling causal influences on multiple target indicators in a joint model: the framework for the second case study | Let G denote an observed neighbourhood indicator, and suppose there is accumulated evidence of potentially causal impacts of G on other neighbourhood features. For example, higher local crime and fear of crime diminish social cohesion (Choi and Matz-Costa G... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Findings: psychosis prevalence and adverse environments | For the first case study, interest is especially in the impact of the ANBE environment factor on neighbourhood psychosis risk. Table 1 shows correlations between the observed risk factors, Z, the two estimates of the ANBE score, and psychosis relative risk.... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Findings: crime impacts on neighbourhood cohesion | Table 3 shows standardised regression coefficients and loadings for the case study of Sect. 3.2, with overall model as in Eqs. ( 10 )-( 12 ), and regressions as in Eq. ( 10 ) and ( 13 ). Regarding the regressions in Eq. ( 13 ), the coefficient for the impac... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model framework | The model framework for this analysis is provided by Eqs. ( 10 )-(13) in Sect. 2.5 The loadings λ k on the cohesion indicators are assigned Student t positive, t + 4 (0,1) , priors. Hence the factor scores f will tend to be higher in high cohesion-low crime... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Comparison with baseline single indicator traditional model | We compare fit between the full joint likelihood, where the loadings are tuned to predict psychosis, and a "traditional" approach, as in existing SDM studies. This treats each the four target indicators separately, as via Eq. ( 1 ), with no borrowing of str... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Joint Likelihood Regression Predictor Mean 2.5% 97.5% Coefficients G Proportion Non-white 0 .007 -0.039 0.054 G Area SES - -0.192 -0.097 0.145 G Fragmentation - -0.061 0.017 0.022 [ Adverse Environment (ANBE) 0.692 0.663 0.722 Loadings Indicator O STD rates... |

### Annals of the American Association of Geographers

- DOI : `10.1080/24694452.2024.2350982`
- TEI : `corpus\papers\tei\GeoShapley A Game Theory Approach to Measuring Spatial Effects in Machine Learning Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 62 | GeoShapley Applied to Models | Empirically, as illustrated in Figure 5 , a true model is often unknown to us. Instead, we rely on the available data, such as features X and outcome y, to fit a model, generate predictions, and use an explanation method to explain the model, thereby facili... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Department of Geography, Florida State University, USA | This article introduces GeoShapley, a game theory approach to measuring spatial effects in machine learning models. GeoShapley extends the Nobel Prize-winning Shapley value framework in game theory by conceptualizing location as a player in a model predicti... |

### Application of optimal data-based binning method to spatial analysis of ecological datasets

- TEI : `corpus\papers\tei\Application_of_optimal_data_based_binning_method_to_spatial_analysis_of_ecologic_W2304859687.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Knuth method description of cluster features | As a preliminary analysis we investigated how the Knuth method reproduces the features of three different type of clusters: square, circular with constant density and circular with Gaussian density. We consider plots of area A 0 = 1000 × 500 units as is the... |

### Applying generalized allometric regressions to predict live body mass of tropical and temperate arthropods

- DOI : `10.1002/ece3.4702`
- TEI : `corpus\papers\tei\Applying_generalized_allometric_regressions_to_predict_live_body_mass_of_tropica_W2796705168.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Statistical analysis | All statistical analyses were performed using R Version 3.4.0 (R Core Team, 2015) . All larvae and taxa without width measurements were excluded from the main analysis. We present length-mass regressions for these excluded taxonomic groups, along with a ran... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Charnov | Generally, adding body width as an additional morphological predictor strongly improved body mass prediction accuracy. This increase in model performance is probably due to certain groups where the body length-to-width ratio is considerably different to the... |

### Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging

- DOI : `10.1021/acs.est.9b03358`
- TEI : `corpus\papers\tei\Assessing NO2 Concentration and Model Uncertainty with High spatiotemporal resolution accross the contiguous united states.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Meteorological Data. | Reanalysis data sets rely on data sourced from land-surface monitors, ship, aircraft, satellite radiosondes, pibals, and other sources. The National Oceanic and Atmospheric Administration (NOAA) assimilates these data sets into a data assimilation system an... |
| low_priority_review | `DataSourceCandidate` | 48 | Meteorological Data. | Reanalysis data sets rely on data sourced from land-surface monitors, ship, aircraft, satellite radiosondes, pibals, and other sources. The National Oceanic and Atmospheric Administration (NOAA) assimilates these data sets into a data assimilation system an... |
| low_priority_review | `DataSourceCandidate` | 46 | Study Area and NO 2 Measurements. | Our study area is the contiguous United States, including 48 states and Washington, DC. The contiguous United States has several NO 2 monitoring networks included in the Air Quality System (AQS) from the Environmental Protection Agency (EPA), encompassing 9... |
| low_priority_review | `DataSourceCandidate` | 46 | Study Area and NO 2 Measurements. | Our study area is the contiguous United States, including 48 states and Washington, DC. The contiguous United States has several NO 2 monitoring networks included in the Air Quality System (AQS) from the Environmental Protection Agency (EPA), encompassing 9... |
| low_priority_review | `DataSourceCandidate` | 45 | Land-cover Variables. | A large percentage of surface NO 2 concentrations stems from local traffic emissions, which are sensitive to land-cover patterns 50 and can be approximated by land-cover terms. Hence, land-use variables are among the most important predictor variables in NO... |
| low_priority_review | `DataSourceCandidate` | 45 | Land-cover Variables. | A large percentage of surface NO 2 concentrations stems from local traffic emissions, which are sensitive to land-cover patterns 50 and can be approximated by land-cover terms. Hence, land-use variables are among the most important predictor variables in NO... |
| low_priority_review | `DataSourceCandidate` | 45 | Other Ancillary Variables. | The retrieval algorithm of satellite-based NO 2 is affected by aerosol, surface reflectance 53 /surface albedo, and cloud contamination, 54 although the agreement of satellite-based NO 2 with in situ measurements is usually good. 55 To correct possible erro... |
| low_priority_review | `DataSourceCandidate` | 45 | Other Ancillary Variables. | The retrieval algorithm of satellite-based NO 2 is affected by aerosol, surface reflectance 53 /surface albedo, and cloud contamination, 54 although the agreement of satellite-based NO 2 with in situ measurements is usually good. 55 To correct possible erro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Three Machine Learning Algorithms. | Previous studies have used neural network, random forest, 63 and other machine learning algorithms to estimate surface-level NO 2 . 17, 23, 33, 34 In these studies, land-cover variables, satellite measurements and other predictors were input variables of th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Three Machine Learning Algorithms. | Previous studies have used neural network, random forest, 63 and other machine learning algorithms to estimate surface-level NO 2 . 17, 23, 33, 34 In these studies, land-cover variables, satellite measurements and other predictors were input variables of th... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Ensemble Model. | To blend NO 2 estimations from the three machine learning algorithms, we used a generalized additive model with penalized spline on both location and NO 2 estimation to account for geographic weights where f 1 denotes a thin plate spline for an interaction... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Ensemble Model. | To blend NO 2 estimations from the three machine learning algorithms, we used a generalized additive model with penalized spline on both location and NO 2 estimation to account for geographic weights where f 1 denotes a thin plate spline for an interaction... |
| low_priority_review | `truncated` |  |  | 8 autres candidats non affiches dans ce rapport |

### Assessing excess mortality and heat-attributable risk during the summer of 2022 in Catalonia, Spain: a Bayesian spatiotemporal analysis

- DOI : `10.1007/s10109-025-00475-2`
- TEI : `corpus\papers\tei\Assessing_excess_mortality_and_heat_attributable_risk_during_the_summer_of_2022__W4414395084.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | The MoMo model | Using data corresponding to the 288 ABSs in Catalonia for the period 2015-2022, we first applied the model used by the MoMo to predict excess all-cause mortality attributable to heat extremes in those ABSs. where the subindexes i and t indicate the province... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |

### Assessing public transport infrastructure: the role of employment matching in spatial accessibility measures

- DOI : `10.1007/s10109-026-00490-x`
- TEI : `corpus\papers\tei\Assessing_public_transport_infrastructure_the_role_of_employment_matching_in_spa_W7134279624.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Accessibility measures and empirical application | Location-based measures consist of the sum of the product of two functions, namely g(•) and f (•), as shown in Eq. 1 (Páez et al. 2012) : Here, A denotes the accessibility to opportunities of type k from location i, from the perspective of person type p. Th... |
| low_priority_review | `DataSourceCandidate` | 45 | Spatial analysis | Table 3 summarises descriptive statistics for both accessibility measures across various SASs. The mean values for the measure considering all types of employment range from 59,400 in the 0.5 km grid to 107,000 in the postcode scheme, while the matching mea... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Summary statistics of accessibility measures over various SAS Note: Descriptive statistics: Mean (SD) [1st-Q, 3rd-Q]. Figures shown in thousands |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Modelling travel time | Travel time by public transport was calculated for each origin-destination (OD) pair across each SAS using a combination of walking and public transport services within the main public transport network. OD points are represented by populationweighted centr... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | The modifiable areal unit problem in accessibility measures | Location-based measures tend to characterise space in discrete units. Thus, these often suffer from the MAUP. The MAUP literature distinguishes two main types of issues, namely scale effects and zoning effects (Wong 2009b) . Scale effects refer to the varia... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | All correlation estimates are significant at p-value > 0.01 SAS = Spatial analytical scheme |

### Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data

- DOI : `10.1371/journal.pone.0157166`
- TEI : `corpus\papers\tei\agridat_kayad.alfalfa - Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |

### Assimilating MODIS data-derived minimum input data set and water stress factors into CERES-Maize model improves regional corn yield predictions

- DOI : `10.1371/journal.pone.0211874`
- TEI : `corpus\papers\tei\Assimilating_MODIS_data_derived_minimum_input_data_set_and_water_stress_factors__W2915741115.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 58 | Data and data processing | Corn yield and phenology data. Corn yields from 2000 to 2013 in Illinois were obtained from the National Agricultural Statistics Service (NASS) by AD and state to evaluate the reliability of assimilation strategies for predicting regional corn yields. Plant... |
| review_for_dataset_use | `DataSourceCandidate` | 54 | Estimation of assimilation data | Estimate of planting date. The planting date was estimated via the crop phenology prediction model [38] using a logistic function describing the seasonal changes in LAD which is Table 1. Management settings for the crop growth model. Management Unit Value P... |
| review_for_dataset_use | `DataSourceCandidate` | 54 | Surface reflectance data. | The MODIS surface reflectance data (i.e. 8-day composited products MOD09A1 with 500-m spatial resolution) from 2000 to 2013 were obtained from Reverb operated by the National Aeronautics and Space Administration (available at http:// modis.gsfc.nasa.gov/ ).... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . Statistical indices for predicted corn yields at the state level with different data assimilation and simulation conditions by end of day of year (DOY) [EOD]. |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Assimilation method R 2 RMSE (tha -1 ) NRMSE (%) EOD 209 EOD 257 EOD 321 EOD 209 EOD 257 EOD 321 EOD 209 EOD 257 EOD 321 Default_rain 0.37 0.33 0.38 2.78 2.93 3.00 28.05 29.50 30.26 Default_auto 0.73 0.71 0.72 1.60 1.53 1.47 16.15 15.42 14.79 Stress_rain 0.... |

### Balancing structural complexity with ecological insight in Spatio-temporal species distribution models

- DOI : `10.1111/2041-210X.13957`
- TEI : `corpus\papers\tei\Laxton2022Balancing.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | / DISCUSS ION | In this paper, we have fitted four different models of varying complexity. The simplest model is a spatio-temporal model with a single likelihood with an IID assumption between years. We will now compare the relative benefits of the different models with re... |
| low_priority_review | `DataSourceCandidate` | 47 | / DISCUSS ION | In this paper, we have fitted four different models of varying complexity. The simplest model is a spatio-temporal model with a single likelihood with an IID assumption between years. We will now compare the relative benefits of the different models with re... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | TA B L E 1 | Posterior mean and 95% credible intervals for: Regression coefficients of environmental covariates; scaling parameter ( ) representing the interaction between G(s) and the probability of crane presence; temporal correlation parameter from the AR1 process; p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | TA B L E 1 | Posterior mean and 95% credible intervals for: Regression coefficients of environmental covariates; scaling parameter ( ) representing the interaction between G(s) and the probability of crane presence; temporal correlation parameter from the AR1 process; p... |
| low_priority_review | `ModelEvidenceCandidate` | 57 | Existing methods for species distribution modelling include: | approaches developed to deal with presence-only datasets (such as maximum entropy algorithm, distance sampling, similarity, and envelope methods such as MAXENT, Gower metric, Mahalanobis distance, and ecological niche factor analysis); machine-learning algo... |
| low_priority_review | `ModelEvidenceCandidate` | 57 | Existing methods for species distribution modelling include: | approaches developed to deal with presence-only datasets (such as maximum entropy algorithm, distance sampling, similarity, and envelope methods such as MAXENT, Gower metric, Mahalanobis distance, and ecological niche factor analysis); machine-learning algo... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Data | We investigate the spatial distribution of a resident breeding population of Eurasian crane in England following the return of the species to the UK in 1979 (Stanbury, 2011) , with the aim of predicting the distribution of the population in future years. Br... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Data | We investigate the spatial distribution of a resident breeding population of Eurasian crane in England following the return of the species to the UK in 1979 (Stanbury, 2011) , with the aim of predicting the distribution of the population in future years. Br... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / INTRODUC TI ON | The continuing increase and the improvement both of the availability and detail of ecological information, and of computational resources allows realistically complex and flexible statistical models to be fitted to ecological data. However, increasing struc... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / INTRODUC TI ON | The continuing increase and the improvement both of the availability and detail of ecological information, and of computational resources allows realistically complex and flexible statistical models to be fitted to ecological data. However, increasing struc... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Single-field models | In order to explore what level of model complexity is needed to answer relevant ecological questions based on the crane data, we start with a relatively simple spatio-temporal model in continuous space. To improve our understanding of the spatio-temporal di... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Single-field models | In order to explore what level of model complexity is needed to answer relevant ecological questions based on the crane data, we start with a relatively simple spatio-temporal model in continuous space. To improve our understanding of the spatio-temporal di... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Bayesian analysis of agricultural ®eld experiments

- TEI : `corpus\papers\tei\Bayesian analysis of agricultural field experiments.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Binary data from an experiment on morning-glory plants | In this section, we describe an analysis of binary observations, though the complete data are in the form of counts. This is one aspect of an experiment concerning the maintenance of genetic variation in morning-glory (Ipomoea purpurea) plants: in particula... |
| low_priority_review | `DataSourceCandidate` | 45 | Other Gaussian representations | An appealing alternative approach is to represent fertility by a process in continuous space and to integrate over each plot to obtain corresponding average values i , as proposed in the pioneering work of Whittle (1954) and MateÂ rn (1960) . Of course, the... |
| low_priority_review | `DataSourceCandidate` | 45 | Results | Fig. 1 shows two dierent additive decompositions of the yields. The upper one corresponds to the basic Bayesian formulation, with Gaussian components for the likelihood and the variety and fertility priors. This agrees closely with the decomposition when Ga... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Other issues | Gilmour and Talbot add competition and interference to the list of possible complications. We agree that design, rather than analysis, should play the key role in tackling these, though additional plots may then be required. One advantage of spatial analysi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Walter T. Federer (Cornell University, Ithaca) | A ®eld design of an experiment consists of ®rst selecting an experiment design plan (randomized complete-block design (RCBD), incomplete-block design, row±column, etc.) based on knowledge of the suspected experimental variation. The second step arises with... |

### Bayesian model averaging for spatial autoregressive models based on convex combinations of different types of connectivity matrices

- DOI : `10.1080/07350015.2020.1840993`
- TEI : `corpus\papers\tei\Bayesian Model Averaging for Spatial Autoregressive Models Based on Convex Combinations of Different Types of Connectivity Matrices.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | An applied illustration | To illustrate the method, we estimate a hedonic house price regression using a sample of 72,045 homes sold in the state of Ohio during the year 2000. The data is described in Brasington and Haurin (2006) ; Brasington (2007) and Brasington and Hite (2008) .... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | A c c e p t e d M a n u s c r i p t | To compare the two approaches, we produce estimates based on either the DGP from ( 28 ) or (29) using matrices W1 and W2 separately, and then calculate Bayesian model averaging estimates based on the two sets of results (approach of LeSage and Fischer, 2008... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Alternative estimation methods | There is a literature on Bayesian model averaging for spatial autoregressive models, where the focus has been on extending the approaches of Fernàndez et al. (2001) and George and McCulloch (1993, 1997) from non-spatial regression modeling that focuses on s... |
| low_priority_review | `ModelEvidenceCandidate` | 52 |   | for the spatial neighbors model. Of course, this leads to larger indirect or spillover effects, As noted earlier, larger spillover estimates may also arise because the convex combination model weight matrix is denser than the spatial weight matrix. (A check... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 10 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 9 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Estimates (variable) Constant β1(lTLA) Wspace -0.358 [-0.422; -0.297] [-0.181; -0.053] [-0.113; 0.005] [-0.465; -0.342] [-0.571; -0.453] Wbeds Wbaths Wage 1 2 c beds W W W baths     -0.119 -0.052 -0.402 -0.513 0.391 0.351 0.314 0.384 0.306 M a n u s c r... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Estimates (variable) Wspace c W   1 W beds   2 W baths   2 W age Constant 0.475 -0.513 [0.380; 0.567] [-0.571; -0.453] β1(lTLA) 0.331 0.306 [0.320; 0.341] [0.298; 0.316] β2(lLSIZE) 0.056 0.062 [0.052; 0.060] [0.058; 0.066] Bedrooms (#) Bathrooms (#) H... |

### Bayesian spatial econometrics: a software architecture

- DOI : `10.1007/s43071-022-00023-w(`
- TEI : `corpus\papers\tei\Bayesian_spatial_econometrics_a_software_architecture_W4280578504.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Interpretation of spatial econometric models | Partial effects of an explanatory variable k are directly captured by the respective coefficient b k in the standard linear model. This is not generally the case for models with spatial lags of the dependent and explanatory variables, such as the SLX and SA... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Spatial econometric models | Consider a standard linear regression model where y 2 R N , X 2 R N ÂK , and e 2 R N is an error term with mean zero. The idea behind spatial econometric models is to extend this model with spatial information by using neighbouring values. A comprehensive s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Cigarette demand model | In this section, I use bsreg to estimate various specifications of the demand model for cigarettes in the continental United States (US) by Baltagi and Li (2004) . With this application, I follow Halleck Vega and Elhorst (2015) and focus on specifics of the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Technical implementation | The implementation of bsreg follows the object-oriented structure outlined above. For the object-oriented system, I rely on the third-party R6 package (Chang 2021) over more idiomatic, native systems. foot_5 This type of object-oriented system is somewhat a... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Design philosophy | MCMC methods of interest to us can be understood as a machine with a state-the parameters-and a set of rules to update this state-the sampling steps. To instantiate this machine some inputs are necessary-namely the data and prior settings, i.e. immutable pa... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |

### Benchmarking Distribution Shift in Tabular Data with TableShift

- TEI : `corpus\papers\tei\gardner_2023_tableshift.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 51 | Data Source: | We use the MIMIC-extract dataset [87] . MIMIC-extract is an open-source pipeline for transforming raw electronic health record (EHR) data from the Medical Information Mart for Intensive Care (MIMIC-III) dataset [45] . MIMIC-III, the underlying data source,... |
| review_for_dataset_use | `DataSourceCandidate` | 51 | Data Source: | We use the dataset from the FICO Commmunity Explainable AI Challenge 21 , an open-source dataset containing features derived from anonymized credit bureau data. The binary prediction target is an indicator for whether a consumer was 90 days past due or wors... |
| low_priority_review | `DataSourceCandidate` | 49 | Data Source: | We use person-level data from the American Community Survey (ACS), as described in Task B.1. However, for this task, we filter the data to include only low-income individuals (those with income less than $30, 000) who are below the age of 65 (at which age a... |
| low_priority_review | `DataSourceCandidate` | 47 | TableShift API | Successful existing benchmarks for distribution/domain shift in machine learning (e.g. WILDS, DomainBed) not only include high-quality datasets, but also make the data accessible by providing a high-quality API as an interface to the otherwise-disparate sou... |
| low_priority_review | `DataSourceCandidate` | 45 | Data Source: | We use the dataset provided by [81] foot_18 . The dataset represents 10 years (1999-2008) of clinical care at 130 US medical facilities, including hospitals and other networks. It includes over 50 features representing patient and hospital outcomes. The dat... |
| low_priority_review | `DataSourceCandidate` | 45 | E.4 Results with Additional Random Seeds | Our experiments on each model-dataset pair comprise a single run of 100 rounds of our hyperparameter tuning protocol described in Section 4.2. Here, we provide the results of additional experiments conducted using different random seeds, in order to evaluat... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 8 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 9 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 10 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 15 : |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Benchmarking Regression Models Under Spatial Heterogeneity

- DOI : `10.4230/LIPIcs.GIScience.2023.11`
- TEI : `corpus\papers\tei\Benchmarking Regression Models Under Spatial heterogeneity.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Results based on real-world data | We experiment with five benchmark datasets that have been used in previous work on spatial data analysis and prediction, e.g. [19, 22, 14, 1] . The following sub-section first introduces these datasets. Afterward, we discuss the results obtained. |
| low_priority_review | `DataSourceCandidate` | 46 | Results based on real-world data | We experiment with five benchmark datasets that have been used in previous work on spatial data analysis and prediction, e.g. [19, 22, 14, 1] . The following sub-section first introduces these datasets. Afterward, we discuss the results obtained. |
| low_priority_review | `ModelEvidenceCandidate` | 69 | Ordinary Least Squares and a global spatial model | We employ two linear global types of regression models. One of these is the Ordinary Least Squares (OLS) model, which assumes a linear dependency of Y on X. It is given as with ϵ being the error term and β ∈ R m denoting the coefficients. In OLS, the coeffi... |
| low_priority_review | `ModelEvidenceCandidate` | 69 | Ordinary Least Squares and a global spatial model | We employ two linear global types of regression models. One of these is the Ordinary Least Squares (OLS) model, which assumes a linear dependency of Y on X. It is given as with ϵ being the error term and β ∈ R m denoting the coefficients. In OLS, the coeffi... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Data-generating processes (DGPs) | One of our investigated DGPs represents a linear relationship of Y on k independent variables x j (j ∈ [1..k]). It is given as where x ij is the j-th feature of the i-th sample, (u i , v i ) are the coordinates of the i-th sample, and β j (u i , v i ) is th... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Data-generating processes (DGPs) | One of our investigated DGPs represents a linear relationship of Y on k independent variables x j (j ∈ [1..k]). It is given as where x ij is the j-th feature of the i-th sample, (u i , v i ) are the coordinates of the i-th sample, and β j (u i , v i ) is th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Datasets | There are five real-world, publicly available datasets that we employ for validation: The California housing dataset 5 was generated from the 1990 California census. Our goal is to predict the median house price from the location and seven other variables,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Datasets | There are five real-world, publicly available datasets that we employ for validation: The California housing dataset 5 was generated from the 1990 California census. Our goal is to predict the median house price from the location and seven other variables,... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Spatial Random Forests | Aside from simply extending non-linear models by adding geographic coordinates or spatial features as covariates, another option is to fit them locally, as a non-linear counterpart to GWR. Similar to [11] , we implement this approach for RFs. To provide a l... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Spatial Random Forests | Aside from simply extending non-linear models by adding geographic coordinates or spatial features as covariates, another option is to fit them locally, as a non-linear counterpart to GWR. Similar to [11] , we implement this approach for RFs. To provide a l... |
| low_priority_review | `ModelEvidenceCandidate` | 55 | Random Forest Regression models | Random Forests (RFs) are established machine learning models for regression tasks and have been shown to be very successful for a wide range of applications. We choose RFs as the main non-linear model in our experiments since it is arguably most prominent i... |
| low_priority_review | `ModelEvidenceCandidate` | 55 | Random Forest Regression models | Random Forests (RFs) are established machine learning models for regression tasks and have been shown to be very successful for a wide range of applications. We choose RFs as the main non-linear model in our experiments since it is arguably most prominent i... |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### Bias from Network Misspecification Under Spatial Dependence

- DOI : `10.1017/pan.2020.26`
- TEI : `corpus\papers\tei\Betz2020Bias.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | Bias from a Misspecified Network | Omitting relevant spatial inputs induces bias, yet we can still infer substantively relevant information from such results. Modeling these spatial terms explicitly promises greater gains. To do so, researchers must presupply the weights matrix. In applied w... |

### Boosting Algorithms: Regularization, Prediction and Model Fitting

- DOI : `10.1214/07-STS242`
- TEI : `corpus\papers\tei\GAMboosting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 62 | Componentwise Linear Least Squares for Linear Models | Boosting can be very useful for fitting potentially high-dimensional generalized linear models. Consider the base procedure It selects the best variable in a simple linear model in the sense of ordinary least squares fitting. When using L 2 Boosting with th... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | 5.3.1 | Componentwise linear least squares. We consider L 2 Boosting with componentwise linear least squares. Denote by the n × n hat matrix for the linear least squares fitting operator using the j th predictor variable denotes the Euclidean norm for a vector x ∈... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | BinomialBoosting | For binary classification with Y ∈ {0, 1}, Binomi-alBoosting uses the negative binomial log-likelihood from (3.1) as loss function. The algorithm is described in Section 3.3.2. Since the population minimizer is f * (x) = log[p(x)/(1p(x))]/2, estimates from... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | R> yfit <-as.numeric(y) -1 | The general framework implemented in mboost allows us to specify the negative gradient (the ngradient argument) corresponding to the surrogate loss function, here the squared error loss implemented as a function rho, and a different evaluating loss function... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Trees | In the machine learning community, regression trees are the most popular base procedures. They have the advantage to be invariant under monotone transformations of predictor variables, that is, we do not need to search for good data transformations. Moreove... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Binary Classification | For binary classification, the response variable is Y ∈ {0, 1} with P[Y = 1] = p. Often, it is notationally more convenient to encode the response by Ỹ = 2Y -1 ∈ {-1, +1} (this coding is used in mboost as well). We consider the negative binomial log-likelih... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | PoissonBoosting | For count data with Y ∈ {0, 1, 2, . . .}, we can use Poisson regression: we assume that Y /X = x has a Poisson(λ(x)) distribution and the goal is to estimate the function f (x) = log(λ(x)). The negative loglikelihood yields then the loss function ρ(y, f ) =... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Connections to binary classification. | Motivated from the population point of view, the L 2 -or L 1 -loss can also be used for binary classification. For Y ∈ {0, 1}, the population minimizers are Thus, the population minimizer of the L 1 -loss is the Bayes classifier. Moreover, both the L 1 -and... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | FUNCTIONAL GRADIENT DESCENT | Breiman [15, 16] showed that the AdaBoost algorithm can be represented as a steepest descent algorithm in function space which we call functional gradient descent (FGD). Friedman, Hastie and Tibshirani [33] and Friedman [32] then developed a more general, s... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Initialization of Boosting | We have briefly described in Sections 2.1 and 4.1 the issue of choosing an initial value f [0] (•) for boosting. This can be quite important for applications where we would like to estimate some parts of a model in an unpenalized (nonregularized) fashion, w... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Models | Consider a potentially high-dimensional linear model where ε 1 , . . . , ε n are i.i.d. with E[ε i ] = 0 and independent from all X i 's. We allow for the number of predictors p to be much larger than the sample size n. The model encompasses the representat... |

### Building a sustainable development index and spacial assessment of municipalities inequalities in the state of Ceará

- DOI : `10.1590/0034-7612163114`
- TEI : `corpus\papers\tei\Building a sustainable development index and spacial assessment of municipalities inequalities in the state of Ceara.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | SPATIAL MODELING TO MEASURE INEQUALITY IN MUNICIPALITIES OF THE STATE OF CEARÁ | The spatial econometric modeling began with the standardization of the indicators formed by the confirmatory factorial analysis, determining value 1 for the municipality with the highest index and 0 for the municipality with the lowest index. There is evide... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | SPATIAL MODELING TO MEASURE INEQUALITY IN MUNICIPALITIES OF THE STATE OF CEARÁ | The spatial econometric modeling began with the standardization of the indicators formed by the confirmatory factorial analysis, determining value 1 for the municipality with the highest index and 0 for the municipality with the lowest index. There is evide... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | AGGREGATING INDICATORS THROUGH SPATIAL ECONOMETRIC MODELING | The standardized SDI of each municipality was used to form a spatial stochastic process, i.e., a sequence of random variables ordered according to the geographic criterion, forming spatial data. According to Almeida (2012) this spatial data is a sample of p... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | AGGREGATING INDICATORS THROUGH SPATIAL ECONOMETRIC MODELING | The standardized SDI of each municipality was used to form a spatial stochastic process, i.e., a sequence of random variables ordered according to the geographic criterion, forming spatial data. According to Almeida (2012) this spatial data is a sample of p... |

### Building use-inspired species distribution models: Using multiple data types to examine and improve model performance

- DOI : `10.1002/eap.2893`
- TEI : `corpus\papers\tei\Building use-inspired species distribution models Using multiple data types to examine and improve model performance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | RESULTS | After quality control and temporal filtering to match available environmental data, we selected 56,240 presence observations for blue sharks in the North Atlantic from the four data types (Figure 1 ). Our treatments identified a spectrum of model sensitivit... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Comparing model performance | We evaluated model performance across three dimensions: explanatory power, predictive skill and ecological realism. Explanatory power indicates a model's ability to explain the variability in a given dataset and was evaluated using the percent explained dev... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Exploratory treatments: Sample size, spatial extent, absences | In any SDM application, practitioners are faced with a number of decisions during model development that may impact the resulting model skill and applicability to the desired use case. We used the different data types to test the impact of three important a... |

### Building use-inspired species distribution models: using multiple data types to examine and improve model performance

- DOI : `10.5061/dryad.h44j0zpr2`
- TEI : `corpus\papers\tei\Braun2023Data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Results | After quality control and temporal filtering to match available environmental data, we selected 56,240 presence observations for blue sharks in the North Atlantic from the 4 data types (Fig. 1 ). Our treatments identified a spectrum of model sensitivity to... |
| low_priority_review | `DataSourceCandidate` | 45 | Results | After quality control and temporal filtering to match available environmental data, we selected 56,240 presence observations for blue sharks in the North Atlantic from the 4 data types (Fig. 1 ). Our treatments identified a spectrum of model sensitivity to... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Comparing model performance | We evaluated model performance across three dimensions: explanatory power, predictive skill and ecological realism. Explanatory power indicates a models ability to explain the variability in a given dataset and was evaluated using percent explained deviance... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Comparing model performance | We evaluated model performance across three dimensions: explanatory power, predictive skill and ecological realism. Explanatory power indicates a models ability to explain the variability in a given dataset and was evaluated using percent explained deviance... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Exploratory treatments: sample size, spatial extent, absences | In any SDM application, practitioners are faced with a number of decisions during model development that may impact the resulting model skill and applicability to the desired use case. We used the different data types to test the impact of three important a... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Exploratory treatments: sample size, spatial extent, absences | In any SDM application, practitioners are faced with a number of decisions during model development that may impact the resulting model skill and applicability to the desired use case. We used the different data types to test the impact of three important a... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |

### Caravan -a global community dataset for large-sample hydrology

- DOI : `10.1038/s41597-023-01975-w`
- TEI : `corpus\papers\tei\kratzert_2023_caravan.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 54 | Data processing in the cloud. | The major computational challenge for developing LSH datasets is processing gridded meteorological and attributes data. To make the development and augmentation of Caravan as democratic as possible (i.e., to make it as easy as possible for anyone to add new... |
| low_priority_review | `DataSourceCandidate` | 46 | Basin selection & streamflow data. | Daily streamflow observations for the 6830 basins currently in Caravan were aggregated from several existing open datasets: • 482 basins from CAMELS (US) 27 • 150 basins from CAMELS-AUS 19 • 376 basins from CAMELS-BR 21 • 314 basins from CAMELS-CL (using an... |
| low_priority_review | `DataSourceCandidate` | 45 | Section 1 | provides river discharge estimates at 10,000+ locations. Both of these collections, however, are not coupled with catchment attributes or meteorological forcing data. Critically, GSIM does not provide daily streamflow data (only indices), and GRDC does not... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |

### Causal identification of single-cell experimental perturbation effects with CINEMA-OT

- DOI : `10.1101/2022.07.31.502173`
- TEI : `corpus\papers\tei\Causal_identification_of_single_cell_experimental_perturbation_effects_with_CINE_W4289261415.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Rhinovirus infection data | Primary human bronchial epithelial cells from healthy adult donors were obtained from commercial vendor (Lonza) and cultured at air-liquid interface according to the manufacturers instructions (Stem Cell Technologies) using reduced hydrocortisone. Cells wer... |
| low_priority_review | `DataSourceCandidate` | 48 | Sequencing and 10x sample alignment | Single cell RNA sequencing libraries were sequenced on Illumina NovaSeq at read length of 150bp pair-end and depth of 300 million reads per sample. scRNA-seq data analysis Data from three donors across Day 2 and Day 7 are concatenated together into labeled... |
| low_priority_review | `DataSourceCandidate` | 46 | Sci-Plex4 data | The Sci-Plex4 data was accessed from https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi ? acc=GSM4150379 with GEO accession number GSM4150379. The data is preprocessed via protocol https://github.com/manuyavuz/single-cell-analysis/blob/main/single_cell_analysis... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Diffusion-map dependence coefficient | In order to evaluate preservation of underlying confounders, we use diffusion-map dependence coefficients. We calculate these coefficients for both cell state and cell trajectory. As our simulated data do not form a well-defined trajectory, and multiple ort... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Differential abundance correction via causal reweighting | A treatment may change the distribution of cell densities, e.g. cells may die or proliferate in response to some perturbation. Thus, we may have an additional factor of differential confounder abundance across experimentally perturbed datasets. This factor... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Validation of CINEMA-OT using simulated ground truth datasets | There are a number of existing methods that perform single-cell level perturbation effect analysis [3-7, 18-20, 32] . Extended figure 1 comprises a summary table of currently available methods and their capabilities. To investigate how CINEMA-OT differs fro... |

### Climate and competition effects on tree growth in Rocky Mountain forests

- DOI : `10.1111/1365-2745.12782`
- TEI : `corpus\papers\tei\Buechling2017Climate.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | G R O W T H D A T A | Geospatial analyses were used to design a stratified random distribution of plot locations for sample data collection. Plot locations were dispersed over environmental gradients hypothesized to affect both climate and forest stand structure, and hence assoc... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | M O D E L S P E C I F I C A T I O N A N D E V A L U A T I O N | A series of alternate models based on eqn (1) were produced to evaluate the relative importance of climate and crowding effects. Simulated annealing, a global optimization algorithm, was used to solve for maximum likelihood estimates of regression parameter... |

### Climate limits vegetation green-up more than slope, soil erodibility, and immediate precipitation following high-severity wildfire

- DOI : `10.1186/s42408-024-00264-0`
- TEI : `corpus\papers\tei\Crockett2024Climate.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 56 | Data | We used the LANDFIRE Existing Vegetation Type layer (LANDFIRE 2016) to select ponderosa pine, mixed conifer, and sub-alpine forests and then selected burned areas using Monitoring Trends in Burn Severity (MTBS) fire perimeters for the period 1985-2017. The... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Variable Source Description | Normalized burn ratio years 1, 2, 3, 4, 5 Landsat + LandTrendr (30 m) Normalized burn ratio for years 1 through 5 Year-of-fire effect variables Soil erodibility (K-factor) gSSURGO, processed in ArcMap Unitless factor denoting a soils susceptibility to erosi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Modeling | We modeled relationships between post-fire vegetation and predictors with random forest using the Ranger package (Wright and Ziegler 2017) to determine how much of the variability of post-fire greenness could be explained by erosion-related factors. The ran... |

### Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests

- DOI : `10.1111/1365-2664.14606`
- TEI : `corpus\papers\tei\Climatic and management-related drivers of endemic European spruce bark beetle populations in boreal forests.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | / Bark beetle trap data | Trap data were obtained from the Norwegian bark beetle monitoring program, which started in 1979. Trap data from 2004 to 2021 (N = 1731 trap locations; Figure 1 ) was selected for analysis due to the availability of relevant predictor variables for those ye... |
| low_priority_review | `DataSourceCandidate` | 47 | / Landscape covariates | Two landscape variables were collated within a 5 km radius of each trap site, which is similar to the spatial scale used in a study of bark beetle damage during the Norwegian outbreak in the 1970s (Worrell, 1983) . (1) Volume mature spruce (m 3 /ha) was obt... |
| low_priority_review | `DataSourceCandidate` | 45 | / Climate covariates | Temperature (°C), precipitation (mm) and soil moisture were obtained from interpolated data presented at a 1 × 1 km grid at senorge.no (Krøgli et al., 2018; Lussana et al., 2019) . Daily values from 1 April to 31 August were used to calculate an average val... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / RE SULTS | The initial tests of different time lags (0-3 years) for four covariates (sum new stand edge, temperature, precipitation and soil moisture) supported a 3-year time lag for all of them (Table 1 ). For all four covariates, ΔAIC values (relative to the AIC val... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Regression analysis | The landscape and climate variables listed above, in addition to 'sampling year', 'latitude', 'longitude' and 'altitude', were regressed on untransformed bark beetle trap counts. All pairs of continuous explanatory variables had absolute correlation coeffic... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | / Spatial prediction using regression model | The glm regression model described above was used to predict trap counts, i.e., our proxy for local bark beetle population size, over a 41,173 km 2 area in SE Norway, including parts of the boreonemoral and southern boreal zones. The prediction was performe... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / DISCUSS ION | Understanding future developments in forest disturbances at northern latitudes is important since boreal forests are huge TA B L E 1 Univariate negative binomial regression models fitted to bark beetle trap counts with different time lags. Predictor Time la... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Time lag on predictors | To test for different time lags on certain predictors (sum new stand edge, temperature, precipitation and soil moisture), univariate negative binomial regression models were fitted to bark beetle trap count data with four levels of time lag (0-3 years). The... |

### Climatic change and extinction risk of two globally threatened Ethiopian endemic bird species

- DOI : `10.1371/journal.pone.0249633`
- TEI : `corpus\papers\tei\Bladon2021Climatic.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Cluster detection of spatial regression coefficients

- DOI : `10.1002/sim.7172`
- TEI : `corpus\papers\tei\Cluster detection of spatial regression coefficients.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Simultaneous Detection | Table II's left panel and Table III's top panel provide the significant clusters and the corresponding coefficient estimates that were detected via the simultaneous detection method at 𝛼 = 0.05. There are a total Table III. Coefficients estimates for sequen... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Simultaneous Detection | Table II's left panel and Table III's top panel provide the significant clusters and the corresponding coefficient estimates that were detected via the simultaneous detection method at 𝛼 = 0.05. There are a total Table III. Coefficients estimates for sequen... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Two-Stage Detection | Table II's right panel and Table III 's bottom panel provide the significant clusters and the corresponding coefficient estimates that were detected via the two-stage detection method at 𝛼 = 0.05. There are a total of five detected clusters with one overlap... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Two-Stage Detection | Table II's right panel and Table III 's bottom panel provide the significant clusters and the corresponding coefficient estimates that were detected via the two-stage detection method at 𝛼 = 0.05. There are a total of five detected clusters with one overlap... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Test for Spatial Cluster Effects in a Simplified Setting | Let D denote a spatial domain of interest in R 2 . Let N denote the number of cells that partition the spatial domain D and form a spatial lattice. For cell i = 1, … , N, let y i denote the ith response variable. We model the response variable as y i = 𝜇 i... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Test for Spatial Cluster Effects in a Simplified Setting | Let D denote a spatial domain of interest in R 2 . Let N denote the number of cells that partition the spatial domain D and form a spatial lattice. For cell i = 1, … , N, let y i denote the ith response variable. We model the response variable as y i = 𝜇 i... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Multiple Clusters | To detect potential additional clusters, we propose a sequential algorithm. That is, we estimate the first cluster Ĉ1 = arg max C∈C F(C), where C is pre-defined with N cells on the spatial lattice and the maximum radius is R max . To test H 0 ∶ 𝜽 C = 0 for... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Multiple Clusters | To detect potential additional clusters, we propose a sequential algorithm. That is, we estimate the first cluster Ĉ1 = arg max C∈C F(C), where C is pre-defined with N cells on the spatial lattice and the maximum radius is R max . To test H 0 ∶ 𝜽 C = 0 for... |

### Colour lightness of dragonfly assemblages across North America and Europe

- DOI : `10.1111/ecog.02578`
- TEI : `corpus\papers\tei\Colour_lightness_of_dragonfly_assemblages_across_North_America_and_Europe_W2515393316.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Distribution data | Distribution ranges of the 152 North American dragonfly species were digitalised from contour maps published in Paulson (2011) using QGIS (QGIS Development Team 2015). The polygons obtained were resampled to half-degree grid cells with functions provided in... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Accepted Ar ticle | 'This article is protected by copyright. All rights reserved.' predictors in ordinary least-squares regressions. However, residuals from these models were spatially autocorrelated (Supplementary material Appendix 1, Fig. A10 ), which can affect parameter es... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial autocorrelation | We evaluated spatial autocorrelation for colour lightness in North America and Europe with spatial correlograms generated with the R-package ncf. We calculated Moran's I for the residuals of the regression models (see below) and found that spatial independe... |
| low_priority_review | `ModelEvidenceCandidate` | 47 | Regression models | We analysed the importance of environmental factors for the spatial variation in colour lightness of dragonfly assemblages using several linear regression models. In the simplest analysis, we considered the average colour lightness of each assemblage as the... |

### Comparative analysis of vestibular ecomorphology in birds

- DOI : `10.1111/joa.12726`
- TEI : `corpus\papers\tei\Comparative_analysis_of_vestibular_ecomorphology_in_birds_W2769366837.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 56 | Morphometric dataset assembly | This study uses lCT scans of 64 avian crania assembled by S.W. (extended from Walsh et al. 2009 Walsh et al. , 2013) ) from the Natural History Museum, London (NHM) and National Museums Scotland, Edinburgh (NMS). Crania were scanned using Nikon Metrology HM... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Labyrinth inter-canal angles | The angles between the best-fit planes of pairs of semicircular canals in birds are typically > 90 °(Fig. 4: 1.57 radians, indicated by dashed grey line). The median angles are 94.0 °(1.64 radians) between the anterior and lateral canals, 98.0 °(= 1.71 radi... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 8 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 9 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Statistical hypothesis tests | We used two approaches for testing the relationships of labyrinth shape, size, and the angles between the planes of the semicircular canals (henceforth: inter-canal angles) with other variables: phylogenetic generalised least-squares regression (pGLS; Grafe... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Labyrinth centroid size | Across all the flying and flightless birds in our sample, labyrinth size is best explained by body mass and BI together (Fig. 3a ; Table 3 , upper portion; this was true across all 100 phylogenies), according to AICc. The best model of the relationships amo... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Functional interpretations of comparative results | The effect of labyrinth size (or canal lengths) on the functional properties of the vestibular system is well understood. These effects are consistent with our findings from regression analysis that manoeuvrability (BI) explains a portion of the variance in... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### Comparing cal3 and other a posteriori time-scaling approaches in a case study with the pterocephaliid trilobites

- DOI : `10.5061/dryad.292dd`
- TEI : `corpus\papers\tei\Comparing_i_cal3_i_and_other_a_posteriori_time_scaling_approaches_in_a_case_stud_W2560059612.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Estimates of Sampling and Diversification Rates | As trilobites are a group of marine invertebrates with a rich fossil record, a number of previous estimates for sampling rate already exist in the literature, at a range of taxonomic, temporal, and geographic scales (Table 2 ). These estimates can have a co... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Obtaining Rates for cal3 | The cal3 time-scaling method relies on a family of models sometimes referred to as the fossilized birth-death or BDSS models (Foote 2001; Stadler 2010; Stadler and Yang 2013; Gavryushkina et al. 2014; Heath et al. 2014; Bapst et al. 2016; Zhang et al. 2016)... |
| low_priority_review | `DataSourceCandidate` | 46 | Empirical Case Study: Results |  |
| review_for_model_evidence | `ModelEvidenceCandidate` | 59 | Phylogenetic Comparative Methods for Testing Time-Dependent Rates of Trait Evolution | Hopkins (2013b) recovered a negative trend through time in the rate of ancestordescendant morphological change, using a multivariate approach. These rates were calculated via maximum-likelihood reconstructions of ancestral node values (Schluter et al. 1997... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Empirical Case Study: Methods |  |

### Comparing spatially varying coefficient models: a case study examining violent crime rates and their relationships to alcohol outlets and illegal drug arrests

- DOI : `10.1007/s10109-008-0073-5`
- TEI : `corpus\papers\tei\wheeler2008_Comparing spatially varying coefficient models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 74 | Geographically weighted regression | The technical details underlying GWR have been described elsewhere (Fotheringham et al. 2002 ), but we review the basics here for completeness. In GWR, a regression model can be fitted at each observation location in the dataset. The spatial coordinates of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Conclusions | In this paper, we have compared two different approaches, geographically weighted regression and a Bayesian SVCP model, for estimating potentially spatially varying regression coefficients for alcohol sales outlets and illegal drug violations to explain Fig... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Estimating Houston violent crime rates with spatially varying coefficient models | In this section, we present the results of estimating the GWR and Bayesian SVCP model parameters for the Houston violent crime data. For the violent crime data, the base model is where y is the natural log of the number of violent crimes (murder, robbery, r... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Model prediction | Also of interest in spatial regression models and violent crime analysis is the prediction of the response variable for a new observation, for example the crime rate at a new census tract or for a tract for which violent crime data are missing. Both GWR and... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Bayesian SVCP model and coefficient shrinkage | In comparing the GWR and SVCP models on similar footing, features in model properties become apparent. One such feature is the similarity between the Bayesian SVCP model and ridge regression, which allows us to summarize the nature of the Bayesian shrinkage... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Introduction | Statistical models enable estimation of associations between an outcome of interest and a set of covariates measured on the same observational units. Statistical linear model theory provides the pervasive analytic tool of linear regression for Gaussian outc... |

### Consistent concentrations of critically endangered Balearic shearwaters in UK waters revealed by at-sea surveys

- DOI : `10.1002/ece3.7059`
- TEI : `corpus\papers\tei\Phillips2021Consistent.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | / Predictive RF | We first excluded fish abundance variables when creating the predictive model, as no data were available outside the boat transects. In order to have an unseen dataset to test the predictive accuracy of our RF model, we set aside the 2013 data, and used the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Explanatory RF | Random Forest bootstrap samples the dataset, fitting a regression tree to each random subset of the data (Breiman, 2001) . At each split in the tree, the data are divided in two by the value of a predictor variable, chosen from a random subset of all predic... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Environmental variables | Data on salinity, sea surface temperature, and chlorophyll levels for the area of interest (latitude: 49.491 to 51.622, longitude: -6.888 to -2.003) in each of the 5 years (2013-2017) were downloaded from the Copernicus Marine Environment Monitoring Service... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Explanatory GAM | We set the presence or absence of Balearic shearwaters as the response variable, and used a binomial distribution. We also assigned sea state as a variable to account for variations in detectability, and log transformed the fish abundances to decrease the i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | TA B L E 3 | Estimated abundance of Balearic shearwaters in the prediction area in each year during the survey period 2.2.5 / Abundance estimate Oppel et al. (2012) attempted to predict Balearic shearwater abundance using five methods, including RF and GAMs; they conclu... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Predictive GAM | Because measurements of prey were not available beyond survey areas, separate predictive models based entirely on environmental variables were constructed. To avoid making extrapolations of Balearic shearwater presence beyond the surveyed area, we restricte... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | / Analytical methods | The area of interest was divided into a grid of 1-km 2 cells to provide predictions of bird presence at a suitably fine spatial scale while allowing variation between cells. Because 1 km 2 represents a small area when considering the observation methods, it... |

### Contrasting effects of spatial heterogeneity and environmental stochasticity on population dynamics of a perennial wildflower

- DOI : `10.1111/1365-2745.12500`
- TEI : `corpus\papers\tei\Contrasting_effects_of_spatial_heterogeneity_and_environmental_stochasticity_on__W2293547265.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | A N A L Y S I S O F V I T A L R A T E S | I analysed vital rates (survival, growth and reproduction) using generalized linear mixed models (GLMMs), with fixed effects of plant size and random effects of year and block. Models fit to data for individual plants (e.g. growth, survival and flower produ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | S T U D Y S Y S T E M A N D F I E L D M O N I T O R I N G | Pulsatilla patens [(L.) Miller = Anenome patens] is an herbaceous perennial plant with a circumboreal distribution, extending from central North America to central Europe (Lesica 2002) . Pulsatilla patens is one of the earliest plants to flower in spring. L... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Copula-based fuzzy clustering of spatial time series

- TEI : `corpus\papers\tei\Copula_based_fuzzy_clustering_of_spatial_time_series_W2737567426.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data preprocessing | In order to disentangle the marginal effects of each univariate time series from the (rank-invariant) dependence properties, it is necessary to conduct a preliminary filtering of the data matrix. Specifically, we can assume that each time series (x 1 , . .... |

### Coregionalization of trace metals in the soil in the Swiss Jura

- TEI : `corpus\papers\tei\Webster_1994_coregionalization_trace_metals_Jura_EJSS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | F2 | Semivariances were calculated using the general computing formula for each pair of elements u and v: (2) 0.8where 9," (h) estimates the semivariance of two random variables Z,(x) and Z,(x) at any pair of places x and x+h separated by the lag h. The quantiti... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 9 . |

### County-to-county migration modeling in the United States: the effects of data source and model selection

- DOI : `10.1007/s10109-025-00470-7`
- TEI : `corpus\papers\tei\County_to_county_migration_modeling_in_the_United_States_the_effects_of_data_sou_W4412186483.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 49 | Data sources | Despite the longstanding use of ACS, Census, and IRS migration datasets in U.S. internal migration research, the specific trade-offs inherent in these data sourcessuch as ACS's rolling multiyear estimates, IRS's lack of demographic details but greater cover... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Data source Time period # Migration interval Suppressions Percent of of unique data- flows that sets are 0 ACS 2005 to 2020 11 Annual (five-year average) Small flows * 97.3 Census 2000** 1 Five years Unknown *** 92.9 IRS 1990 to 2020 30 Annual Flows < 20 99.2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Zero-inflated poisson | Zero-Inflated Poisson regression presents a compelling solution to address overdispersion, characterized by the presence of excess zeros in a dataset, by blending two zero-generating processes. Despite its suitability for migration modeling, ZIP regression... |

### Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors

- DOI : `10.1080/01621459.2022.2123333`
- TEI : `corpus\papers\tei\Crop Yield Prediction Using Bayesian Spatially Varying Coefficient Models with Functional Predictors.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Bayesian Spatially Varying Functional Model | For ease of exposition, we present the model based on singleyear data. Our analysis treats data from multiple years as conditionally independent replicates, with rationals detailed in Section 5.1. Let Y(s) denote the scalar response at location s ∈ D for a... |
| low_priority_review | `DataSourceCandidate` | 47 | Bayesian Spatially Varying Functional Model | For ease of exposition, we present the model based on singleyear data. Our analysis treats data from multiple years as conditionally independent replicates, with rationals detailed in Section 5.1. Let Y(s) denote the scalar response at location s ∈ D for a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Crop and Weather Data | We obtain the county-level annual crop yield data (measured in bushels per acre) together with the size of harvested land (acre) of Illinois, Indiana, Iowa, Kansas, and Missouri between 1999 and 2020 from the National Agricultural Statistics Agency ( https:... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Crop and Weather Data | We obtain the county-level annual crop yield data (measured in bushels per acre) together with the size of harvested land (acre) of Illinois, Indiana, Iowa, Kansas, and Missouri between 1999 and 2020 from the National Agricultural Statistics Agency ( https:... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Prediction Assessment | We examine the prediction performance of our model using a 10-fold cross-validation and compare it with competing statistical and machine learning methods. The statistical methods include FLM, PLFAM, and FGAM, described in Section 4.1, and a nonfunctional s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Prediction Assessment | We examine the prediction performance of our model using a 10-fold cross-validation and compare it with competing statistical and machine learning methods. The statistical methods include FLM, PLFAM, and FGAM, described in Section 4.1, and a nonfunctional s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Spatial Functional Predictors with Measurement Errors | In practice, X(s; t) is often not directly observable, and instead, we only observe its surrogate containing measurement errors. It is well known that climate data products, especially the high-resolution data, are error prone for various reasons (e.g., Mat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Spatial Functional Predictors with Measurement Errors | In practice, X(s; t) is often not directly observable, and instead, we only observe its surrogate containing measurement errors. It is well known that climate data products, especially the high-resolution data, are error prone for various reasons (e.g., Mat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Prediction | Given the hierarchical models, we simultaneously estimate model parameters, perform the spatial variable selection, and make predictions for new observations. To carry out such analysis, we incorporating new functional and scalar predictors, W new , Z new ,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Prediction | Given the hierarchical models, we simultaneously estimate model parameters, perform the spatial variable selection, and make predictions for new observations. To carry out such analysis, we incorporating new functional and scalar predictors, W new , Z new ,... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Spatial Variable Selection | The model selection in the functional regression model is typically performed via truncation, which first determines a p based on how much total variation in X or W can be explained by its truncated expansion and then uses the same first p FPC scores in the... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Spatial Variable Selection | The model selection in the functional regression model is typically performed via truncation, which first determines a p based on how much total variation in X or W can be explained by its truncated expansion and then uses the same first p FPC scores in the... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Cross-validation strategies for data with temporal, spatial, hierarchical, or phylogenetic structure

- DOI : `10.1111/ecog.02881`
- TEI : `corpus\papers\tei\roberts_2017_cross_validation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Cross-validation with structured data | Ecological variables (observations of biota) commonly contain four types of internal structure: autocorrelation in time, autocorrelation in space, group dependence structures, and phylogenetic structure (i.e. relatedness). These can lead to two issues in st... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Box 2. Blocking by individual or group | We estimated resource selection functions (RSFs) for 43 female elk Cervus elaphus monitored using satellite telemetry in Alberta, Canada. We fitted generalized linear mixed models (GLMM) with a Bernoulli response (1  use by elk; 0  available, i.e. random... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Accepted Ar ticle | (especially if the species migrated post-glacially from a single ice-age refugium, structuring genetic relatedness in space). In this case, the model may attribute part of the effect of the unmeasured covariates to coastal distance, which would result in bi... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Accepted Ar ticle | 'This article is protected by copyright. All rights reserved.' covariates need not be orthogonal to model structure, as assumed implicitly by methods in the previous paragraph. Resulting model predictions may perform fine in a situation where the correlatio... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Blocking to account for phylogenetic correlations | Species properties are often phylogenetically conserved, meaning that closely related species tend to be more similar to each other than distant relatives. Consequently, analyzing data across species can lead to phylogenetically correlated residuals, result... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Blocking to account for random effect structures | A somewhat different structure is presented by hierarchical data, such as blocked or nested experimental designs, data replicated by individuals in groups, or repeated measurements such as animal telemetry data. In these cases, data are structured by units... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Box 2: Blocking by group | Blocking to account for phylogenetic correlations Species properties are often phylogenetically conserved, meaning that closely related species tend to be more similar to each other than distant relatives. Consequently, analyzing data across species can lea... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Accepted Ar ticle | statistical methods, typically leading to over-optimistic confidence intervals and incorrect p-values (e.g. Ives and Zhu 2006) . The second issue, overfitting to the dependence structure of the data, describes the phenomenon that the model may absorb struct... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Accepted Ar ticle | to blocks entirely lacking either presences or absences (e.g. withholding the centre square in Figure 4d for validation). Unbalanced mean values of the response can also make cross-validation problematic if, for example, one tries to validate predictions us... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Avoiding extrapolation | Environments tend to be structured in space and time: climates tend to be similar in nearby locations just as they tend to be similar in consecutive time periods. Therefore, because blocking to achieve structural independence in cross-validation requires th... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Cross-validation with structured data | Ecological variables (observations of biota) commonly contain four types of internal structure: autocorrelation in time, autocorrelation in space, group dependence structures, and phylogenetic structure (i.e. relatedness). These can lead to two issues in st... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Final thoughts | In this review and synthesis, we have discussed the role of block cross-validation for better estimating prediction errors. It addresses prediction optimism, arising from nonindependent hold-out or from overfitting data dependence with covariates. We did no... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Crowdsourced air traffic data from the OpenSky Network 2019-2020

- DOI : `10.1093/jtm/taaa011`
- TEI : `corpus\papers\tei\2026-04-23_paper_opensky_network_dataset_essd_2021.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Data cleaning | To make the data accessible and meet requirements, complex pre-processing is needed in order to reduce the reduce the data volume and eliminate the need to understand all system aspects in order to use the data. Moreover, the infor-mation quality needs to b... |
| low_priority_review | `DataSourceCandidate` | 45 | Technical validation | In the following, we provide some statistics showing that our flights dataset reflects the air traffic reality as different time series showing the effect of the COVID-19 pandemic at different airports and for different airlines. Table 2 shows the distribut... |

### DIFFUSION CONVOLUTIONAL RECURRENT NEURAL NETWORK: DATA-DRIVEN TRAFFIC FORECASTING

- TEI : `corpus\papers\tei\2026-04-23_paper_dcrnn_traffic_forecasting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | T Metric HA ARIMA Kal VAR SVR FNN FC-LSTM DCRNN MAE 4.16 3.99 4.42 3.99 3.99 3.44 2.77 15 min RMSE 7.80 8.21 7.89 8.45 7.94 6.30 5.38 METR-LA 30 min MAPE 13.0% MAE 4.16 RMSE 7.80 MAPE 13.0% MAE 4.16 9.6% 5.15 10.45 12.7% 6.90 10.2% 9.3% 5.41 5.05 9.13 10.87... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | 15 min 30 min 1 hour MAE RMSE MAPE MAE RMSE MAPE MAE RMSE MAPE DCRNN 2.77 5.38 7.3% 3.15 6.45 8.8% 3.60 7.60 10.5% GCRNN 2.80 5.51 7.5% 3.24 6.74 9.0% 3.81 8.16 10.9% '&11 '&5116(4 '&511 0$( 0LQ 0LQ +RUL]RQ +RXU |

### Data Descriptor: A global dataset of air temperature derived from satellite remote sensing and weather stations

- DOI : `10.1038/sdata.2018.246`
- TEI : `corpus\papers\tei\A global dataset of air temperature derived from satellite remote sensing and weather stations.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 60 | Input data | The Global Historical Climatology Network -Monthly (GHCN-M) dataset 13 is used as the source for reference air temperatures. This dataset provides monthly average air temperature at a large number of weather stations from sometimes up to more than 100 years... |
| review_for_dataset_use | `DataSourceCandidate` | 60 | Input data | The Global Historical Climatology Network -Monthly (GHCN-M) dataset 13 is used as the source for reference air temperatures. This dataset provides monthly average air temperature at a large number of weather stations from sometimes up to more than 100 years... |
| low_priority_review | `DataSourceCandidate` | 45 | Background & Summary | Air temperature is a fundamental biophysical variable that influences almost all biotic processes, as well as many abiotic processes globally. Gridded climatologies describe how air temperature varies geographically and seasonally, but in reality there are... |
| low_priority_review | `DataSourceCandidate` | 45 | Background & Summary | Air temperature is a fundamental biophysical variable that influences almost all biotic processes, as well as many abiotic processes globally. Gridded climatologies describe how air temperature varies geographically and seasonally, but in reality there are... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Stacked generalisation | Predictions of air temperature based on GWR and on CSWR are finally combined to make an overall prediction of air temperature, using stacked generalisation. Stacked generalisation is a method to optimally combine multiple statistical models into an ensemble... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Stacked generalisation | Predictions of air temperature based on GWR and on CSWR are finally combined to make an overall prediction of air temperature, using stacked generalisation. Stacked generalisation is a method to optimally combine multiple statistical models into an ensemble... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Geographically weighted regression | When a regression is applied over geographically-distributed data, the coefficients of that regression model need not in fact to be constant over space. Geographically weighted regression was developed to deal with this non-stationarity. Rather than calibra... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Geographically weighted regression | When a regression is applied over geographically-distributed data, the coefficients of that regression model need not in fact to be constant over space. Geographically weighted regression was developed to deal with this non-stationarity. Rather than calibra... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Climate space weighted regression | The logic of applying repeated weighted regressions based on proximity in geographic space can equally be extended to proximity in climate space. The relationship between air temperature and LST could even be more consistent over stations with similar clima... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Climate space weighted regression | The logic of applying repeated weighted regressions based on proximity in geographic space can equally be extended to proximity in climate space. The relationship between air temperature and LST could even be more consistent over stations with similar clima... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Technical Validation | The dataset we describe consists of predictions made from a statistical model that we have developed. Independent observations of air temperature, with which we might validate these predictions, are not available. However, the nature of our statistical mode... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Technical Validation | The dataset we describe consists of predictions made from a statistical model that we have developed. Independent observations of air temperature, with which we might validate these predictions, are not available. However, the nature of our statistical mode... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Datasheets for Datasets

- TEI : `corpus\papers\tei\gebru_2021_datasheets.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Composition | Dataset creators should read through these questions prior to any data collection and then provide answers once data collection is complete. Most of the questions in this section are intended to provide dataset consumers with the information they need to ma... |
| low_priority_review | `DataSourceCandidate` | 45 | Motivation | For what purpose was the dataset created? Was there a specific task in mind? Was there a specific gap that needed to be filled? Please provide a description. The dataset was created to enable research on predicting sentiment polarity-i.e., given a piece of... |
| low_priority_review | `DataSourceCandidate` | 45 | N/A. | Any other comments? Movie Review Polarity Thumbs Up? Sentiment Classification using Machine Learning Techniques None. Preprocessing/cleaning/labeling Was any preprocessing/cleaning/labeling of the data done (e.g., discretization or bucketing, tokenization,... |
| low_priority_review | `DataSourceCandidate` | 45 | See preprocessing below. | Is the dataset self-contained, or does it link to or otherwise rely on external resources (e.g., websites, tweets, other datasets)? If it links Fig. 1 . Example datasheet for Pang and Lee's polarity dataset [22] , page 1. The data was mostly observable as r... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Preprocessing/cleaning/labeling | Dataset creators should read through these questions prior to any preprocessing, cleaning, or labeling and then provide answers once these tasks are complete. The questions in this section are intended to provide dataset consumers with the information they... |

### Decapod Biodiversity Hotspots and Environmental Drivers: A Macroecological Approach About Bycatch Species in Brazil

- DOI : `10.1111/jbi.70076`
- TEI : `corpus\papers\tei\Decapod Biodiversity Hotspots and Environmental Drivers - A Macroecological.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | / Species Richness and Phylogenetic Diversity Index | We calculated species richness (SR) for each 1° × 1° grid cell by counting the number of unique decapod species with occurrence records within each cell. To estimate the Phylogenetic Diversity index, the mitogenomic phylogenetic Decapod tree from Shen et al... |
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental Factors | Data from environmental factors were extracted from Bio-ORACLE: Marine data layers for Ecological Modelling version 2.2 (Assis et al. 2017) using the R package 'sdmpredictors' (Bosch and Fernandez 2023) . Were extracted 24 present benthic layers for the fol... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Results | A total of 104 species were analysed to calculate SR, comprising 43,002 occurrence points, while 98 species were used for PD.SES and PE.SES metrics, distributed across 169 grid cells with 1° × 1° resolution within the Brazilian Exclusive Economic Zone. Acro... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 1 / |

### Deep Integro-Difference Equation Models for Spatio-Temporal Forecasting

- TEI : `corpus\papers\tei\Deep_integro_difference_equation_models_for_spatio_temporal_forecasting_W2982441595.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Applying the SST-trained IDE to radar-reflectivity data | In this section we carry out an unusual experiment, where we take the CNN-IDE with parameters estimated with the SST data and use it for forecasting radar reflectivity data. The data we consider are a set of 12 images of radar reflectivities obtained near S... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Comparative study | In Section 4.2 we fitted the CNN and covariance function using directly observed, complete data from the SST product. In this section we show the model's use for forecasting in the realistic setting when observational data are incomplete and noisy. Here, th... |

### Delineating neighborhoods: An approach combining urban morphology with point and flow datasets

- DOI : `10.1177/2399808319832612`
- TEI : `corpus\papers\tei\Delineating_Neighborhoods_An_Approach_Combining_Urban_Morphology_with_Point_and__W4392552160.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Step 2: Multiple neighborhood dimensions captured through spatial networks | Networks are representations of relationships (i.e., edges) between objects (i.e., nodes). Geographical networks are a specific form of networks where (1) nodes are geographical locations defined in dialog with geographical theories, and (2) these geographi... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Methodology Case study: Leuven, Belgium | We illustrate our methodology using the case of the city of Leuven, Belgium. This city is home to just over 100,000 inhabitants and includes a sizeable semi-permanent population of students and researchers affiliated with its institutes of higher education,... |

### Detecting space-time agglomeration processes over the Great Recession using firm-level micro-geographic data

- DOI : `10.1007/s10109-020-00332-4`
- TEI : `corpus\papers\tei\Detecting_space_time_agglomeration_processes_over_the_Great_Recession_using_firm_W3043560367.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | The dataset | The analysis employs a large sample of single-plant manufacturing joint-stock companies located in the Italian continental territory. The firm-level data are drawn from the AIDA database (Bureau Van Dijk) that provides personal information and balance sheet... |

### Detecting space-time clusters of COVID-19 in Brazil: mortality, inequality, socioeconomic vulnerability, and the relative risk of the disease in Brazilian municipalities

- DOI : `10.1007/s10109-020-00344-0`
- TEI : `corpus\papers\tei\Detecting_space_time_clusters_of_COVID_19_in_Brazil_mortality_inequality_socioec_W3134692574.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 10 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 12 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Dependent variables Direct Indirect Total SVI -0.09314893 -0.10293739 -0.19608632 Simulated p-values 0.20196 0.20293 0.20228 GINI 1.2802934 1.41483177 2.69512519 Simulated p-values <0.001*** <0.001*** <0.001*** Motality rate 0.01534331 0.01695565 0.03229895... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 9 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 11 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Spatial modeling | We implement a Moran's I test on the GLM residuals to detect the presence of spatial autocorrelation (Anselin 1988; Anselin and Bera 1998) and justify the use of the subsequent spatial modeling. First, we conduct a Spatial Lag Model (Eq. 4) to estimate how... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Non-spatial modeling | To examine the role of socioeconomic characteristics on the presence of COVID-19 clusters, we select three indicators reflecting population characteristics and COVID-19 mortality: the GINI index, (IPEA 2015) the Brazilian Social Vulnerability Index (SVI) (A... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Data and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Regression results | The results obtained through the GLM showed that there was a significant positive correlation between the predictor variables in relation to the relative risk at the level of the municipalities belonging to the nine emerging clusters (Fig. 4 ). The GLM resu... |
| low_priority_review | `ModelTableCandidate` | 34 | GROBID table | Table 16 |
| low_priority_review | `ModelTableCandidate` | 34 | GROBID table | Variable Coefficient SE z-value Probability Constant -0.0613326 0.127557 -0.480826 0.63064 GINI 118.985 0.249604 476.696 0.000*** SVI 0.120072 0.172886 0.694515 0.48736 Mortality rate 0.0160655 0.000671939 239.091 0.000*** Lambda 0.617606 0.0177266 348.406... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Detecting space-time patterns of disease risk under dynamic background population

- DOI : `10.1007/s10109-022-00377-7`
- TEI : `corpus\papers\tei\Detecting_space_time_patterns_of_disease_risk_under_dynamic_background_populatio_W4224261078.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |

### Determinants and spatial dependence of innovation in Brazilian regions: evidence from a Spatial Tobit Model

- DOI : `10.1590/0103-6351/4456`
- TEI : `corpus\papers\tei\Araujo2019Determinants.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Results | Three versions of the model were estimated using 2 years of pooled data (2004 and 2005) with a total sample size of 1,116 observations (558 microregions x 2 years). The fi rst version is an OLS (model 1) that includes all the variables but without spatial f... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Results | Three versions of the model were estimated using 2 years of pooled data (2004 and 2005) with a total sample size of 1,116 observations (558 microregions x 2 years). The fi rst version is an OLS (model 1) that includes all the variables but without spatial f... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |

### Determinants of Airbnb prices in European cities: A spatial econometrics approach

- DOI : `10.1016/j.tourman.2021.104319`
- TEI : `corpus\papers\tei\Determinants of Airbnb prices in European cities A spatial econometrics approach.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 3 |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 5 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Model selection | Our analysis is based on Python programming language and the PySAL package (Rey & Anselin, 2007) . The scripts prepared for the spatial regressions and robustness checks are published along with the datasets at Zenodo. First, Moran's I is calculated to test... |
| low_priority_review | `ModelEvidenceCandidate` | 63 | Spatial models | If the observations of the explained variable are affected by the neighbouring observations, we need to include a spatial lag in our model. The spatial lag of the dependent variable (also noted as WY) represents the linear combination of y constructed from... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Dataset | In order to collect Airbnb offers that would be presented to a real user, an automated experiment was conducted based on web-scraping. With the use of a web-automation framework (Selenium WebDriver), search queries were executed on the Airbnb platform that... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Regression results | Figs. 3 4 5 summarise the results for size, quality, and location attributes. The graphs present the results for the baseline OLS and the three spatial models: the colour of the circle reveals the estimation method, while the transparency shows whether the... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Robustness checks | To further verify our results, various robustness checks were carried out. Fig. B1 shows the coefficients of selected variables for the weekend and weekday samples. The differences in statistical significance are minor: e.g., there are some changes in the c... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Dataset and methodology |  |
| low_priority_review | `ModelEvidenceCandidate` | 45 | Considerations for methodology | The results show that measures based on the distance from certain points (e.g., city centre) are not optimal for measuring the price premium for location. However, the TripAdvisor indices, based on up-todate data on tourist preferences, provided detailed in... |

### Differential Evolvability Along Lines of Least Resistance of Upper and Lower Molars in Island House Mice

- DOI : `10.1371/journal.pone.0018951`
- TEI : `corpus\papers\tei\ade4_houmousr - Differential Evolvability Along Lines of Least Resistance of Upper and Lower Molars in Island House Mice.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |

### Direct and indirect genetic and fine-scale location effects on breeding date in song sparrows

- DOI : `10.1111/1365-2656.12575`
- TEI : `corpus\papers\tei\Direct_and_indirect_genetic_and_fine_scale_location_effects_on_breeding_date_in__W2483210804.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Results | The final data set comprised 1040 breeding dates in 38 years (1976) (1977) (1978) (1979) from a mean of 28Á5 AE 15Á3 breeding pairs per year. Breeding date varied substantially among years (Fig. 1a ), with an overall mean Julian date of 107 AE 13 (April 17t... |
| low_priority_review | `DataSourceCandidate` | 45 | location variance | The degree to which variation in breeding date and other life-history traits stems from fine-scale (i.e. local) vs. broad-scale (i.e. regional) environmental variation is of intrinsic interest and must be modelled to minimize bias in estimated additive gene... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | spatial variation | Observed breeding locations spanned the extent of available habitat on Mandarte (Fig. 2 ). Visual inspection showed considerable heterogeneity in breeding date at a very small spatial scale (Fig. 2 ). Indeed, Moran's I showed no evidence of significant SAC... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 . |

### Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918

- DOI : `10.1073/pnas.1612838113/-/DCSupplemental.www.pnas.org/cgi/doi/10.1073/pnas.1612838113`
- TEI : `corpus\papers\tei\Grantz2016Disparities.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 52 | Data Collection and Outcome Definitions. | Census tract-level data on demographic characteristics in 1920 were collected from the National Historical Geographic Information System website (22) . Influenza mortality data were obtained from maps published in a report by the City of Chicago Department... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Univariate regression unadjusted RR (95% CI) Multivariate regression adjusted RR (95% CI) Percentage illiterate 1.056 (1.048, 1.063) 1.028 (1.020, 1.036) Population density (per acre) 1.001 (0.999, 1.002) 0.996 (0.994, 0.997) Percentage homeowners... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Correlation coefficient (95% CI) P value Population density 0.293 (0.249, 0.306) <0.001 Illiteracy 0.262 (0.239, 0.298) <0.001 Homeownership -0.071 (-0.038, -0.106) 0.11 Unemployment -0.136 (-0.114, -0.179) 0.002 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Demographic data from the 1920 census (22) and the home location of pneumonia and influenza mortality data by week from September 29 to November 16, 1918 (23) were available for 496 of Chicago's 499 census tracts. There were 7,971 influenza and pneumonia de... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Significance | The pervasiveness of influenza among humans and its rapid spread during pandemics create a false sense that all humans are affected equally. In this work, we show that neighborhood-level social determinants were associated with greater burdens of pandemic i... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Association Between Sociodemographic Factors and Mortality. | The covariates included in the Poisson model were age, population density (total population divided by total area in acres of each census tract), illiteracy rate (number of people over 10 y of age who were illiterate divided by the total population in each... |

### Do spatial interactions fuel the climate-conflict vicious cycle? The case of the African continent

- DOI : `10.1007/s43071-020-00007-8`
- TEI : `corpus\papers\tei\Do_spatial_interactions_fuel_the_climate_conflict_vicious_cycle_The_case_of_the__W3105913746.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Robustness checks and estimation details | Regarding the estimation procedure, our analysis is based on the routines developed in STATA by Belotti et al. (2017) under the command xsmle, which are based on quasi-maximum likelihood techniques described in Elhorst (2009) and LeSage and Pace (2009) . 12... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Data | The empirical analysis is conducted on an original georeferenced database that combines conflict data with climate and socio-economic information resulting in a panel dataset for the entire African continent divided into 3402 georeferenced cells covering th... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Research methods and empirical approaches: an open debate | The two most common methods used in the field of weather conditions and armed conflicts linkages are: large-N statistical analysis and qualitative case study. As emphasised by Salehyan (2014) , the choice of the research method, together with the specific s... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Methods and data |  |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 8 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | (W150- (W150- (W150- (W250- (W250- (W250- D150) D250) D500) D150) D250) D500) NC it-1 (a) 0.475*** 0.534*** 0.479*** 0.480*** 0.479*** 0.473*** (0.01) (0.01) (0.01) (0.01) (0.01) (0.01) W 150/250 NC it 0.661*** 1.189*** 0.718*** 0.576*** 0.558*** 0.527*** (... |

### Driving Factor Analysis of Ecosystem Service Balance for Watershed Management in the Lancang River Valley, Southwest China

- DOI : `10.3390/land10050522`
- TEI : `corpus\papers\tei\Driving_Factor_Analysis_of_Ecosystem_Service_Balance_for_Watershed_Management_in_W3160802222.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Data Sources and Processing | (1) Land use and land cover. In this study, land cover data with a 100 m × 100 m resolution in 2015 were provided by the Data Center for Resources and Environmental Sciences, Chinese Academy of Sciences (RESDC, Beijing) ( http://www.resdc.cn , 1 September 2... |
| low_priority_review | `DataSourceCandidate` | 45 | Data Sources and Processing | (1) Land use and land cover. In this study, land cover data with a 100 m × 100 m resolution in 2015 were prov by the Data Center for Resources and Environmental Sciences, Chinese Academy o ences (RESDC, Beijing) ( http://www.resdc.cn , 1 September 2020). Ba... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | Driving Factor Analysis of ES Balance Based on Geographically Weighted Regression Model | The Geographical Weighted Regression (GWR) model is a kind of regression model that can detect the changes in the variable structure and variable relationship caused by geographical location changes, which is called spatial non-stationarity [41] . Compared... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Validation of GWR Model and Spatial Stationarity of Explanatory Variables | Comparing the adjusted R 2 of GWR and OLS demonstrated that the goodness-of-fit values of GWR models were higher than those of the corresponding OLS models in various ESs, indicating that the regression effect of the GWR model was better than that of the Fo... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Application and Advantages of GWR Model | Recently, several studies have proved that human activities and landscape patterns are important factors influencing ES supply, demand and balance [51, 55] . Our results contributed to providing effective information and guidance for ES management. Previous... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Conclusions | Regional land use status is an important factor driving the change in ES supply and demand. In this study, based on the LULC matrix model, four kinds of ES supply, demand and balance in the Lancang river valley were quantified, and the spatial distribution... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Validation of GWR Model and Spatial Stationarity of Explanatory Variables | Comparing the adjusted R 2 of GWR and OLS demonstrated that the goodness-of-fit values of GWR models were higher than those of the corresponding OLS models in various ESs, indicating that the regression effect of the GWR model was better than that of the OL... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | OLS Analysis and Corresponding Explanatory Variable Selection | Comparing the OLS results of four dependent variables revealed that LPI was the major impact factor of all dependent variables (Table 1 ). The correlation coefficients were all greater than 0.7 and all were negatively impacted. Type Provisioning Services Re... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial Differentiation Analysis of Dominant Explanatory Variables | The screening results of dominant explanatory variables at pixel scale indicated that four kinds of ES balance were affected by seven types dominant explanatory variables with negative or positive directions (Figure 6 ). For provisioning service balance, 93... |

### ECONOMICS OF SITE SPEC1fi1C NITROGEN MANAGEMENT IN CORN PRODUCTION

- TEI : `corpus\papers\tei\Anselin-SpatialEconometricApproach-2004.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Section 1 | Geographic information systems (GIS) and global positioning systems (GPS) are transforming large-scale commercial agriculture throughout the world. This technology is often labeled "precision agriculture" and has given new life to the old idea of site-speci... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | STANDARD SAR Variables COEFF kg ha-l Prob COEFF kg ha-l Prob Constant 5863.68 0.0000 5942.87 0.0000 N 11.5415 0.0000 10.8791 0.0000 N2 -0.0358 0.0000 -0.0243 0.0000 Low E 851.134 0.0000 418.883 0.0000 Slope E 199.967 0.0003 205.053 0.0021 Hilltop -1206.12 0... |
| low_priority_review | `ModelEvidenceCandidate` | 72 | Spatial Econometric Models | Spatial autocorrelation has received growing attention in the economic modeling of natural resources and environmental factors (for recent reviews, see Anselin and Bera; Anselin 2001a Anselin ,b, 2002)) . It can be incorporated in a regression model in two... |
| low_priority_review | `ModelEvidenceCandidate` | 67 | Spatial Models | Regression crop response functions have the advantage of fitting easily into the traditional crop production economics decision model (Heady and Dillon, Dillon and Anderson) . This also extends to site-specific management, as demonstrated by Lowenberg-DeBoe... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Profitability of VRT-N | The optimal level N by landscape position is computed in the standard fashion using ordinary calculus. Net returns over fertilizer cost, VRT application fee, added non-N fertilizer costs for maintenance, and extra harvest and handling costs are taken into a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Returns by N Rate Application | A comparison of the returns from different N rates is given in table 2 . The returns were estimated for two uniform application rates and for a variable rate application following the four landscape positions in our study. The two uniform rates were used to... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |

### Early-season biomass and weather enable robust cereal rye cover crop biomass predictions

- DOI : `10.1002/ael2.20121`
- TEI : `corpus\papers\tei\Huddell2024Earlyseason.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Random forest model and validation | To improve the accuracy of predictions, we also fit a random forest machine learning model on the dataset using the randomForest package v. 4.7-11 in R (Breiman, 2001; Liaw & Wiener, 2002) . We specified a random forest model with the training parameters nt... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Core Ideas | • Cereal rye winter cover crop biomass modeled on data from 35 site-years. • We found a strong relationship between early and late-season biomass. • Random forest model with early-season biomass and weather data performed well. • Similar approach could impr... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |

### Ectothermy and the macroecology of home range scaling in snakes

- DOI : `10.1111/geb.13225`
- TEI : `corpus\papers\tei\Todd2020Ectothermy.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | TA B L E 1 | Competing models explaining variation in home range size using the most inclusive dataset-without sexspecific estimates of home range continents (Appendix; Supporting Information Table S1 , Figure S1 ). Two studies of one elapid species could not be analyse... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / D ISCUSS I ON | Snakes are notoriously difficult to study due to their low detectability (Durso & Seigel, 2015; Durso et al., 2011; Willson et al., 2011) , and, as a result, tend to be underrepresented in ecological literature compared with mammals and birds (Bonnet et al.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / RE SULTS | Our literature search returned 98 studies that met the inclusion criteria, providing home range estimates for 50 species from 5 Model category Predictors k AICc ∆AICc w Single variable Mass 5 181.95 0.00 .929 Global Mass + Habitats + Aquatic + Elevation + N... |

### Effect of correlated observation error on parameters, predictions, and uncertainty

- DOI : `10.1002/wrcr.20499`
- TEI : `corpus\papers\tei\tiedeman_green_2013_observation_error.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | Calculating Observation Error Variance-Covariance Matrix by First-Order Error Propagation | [12] When calibration observations are derived from multiple direct measurements, the observation error variances and covariances can be estimated by propagating the measurement error (Figure 1 ) [e.g., Sherman, 1989; Tellinghuisen, 2001; Feldman et al., 20... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Effect of Observation Error Correlation on Uncertainty for a Simple Inverse Model 2.4.1. Effect on Parameter Variance | [20] To derive a general expression for the effects of observation error correlations on parameter uncertainty, equation ( 9a ) is used with the assumption that the model is linear with respect to the parameters. The parameter variance-covariance matrix in... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Parameter and Prediction Uncertainty | where s 2 ¼ S/(nd À np) is the calculated error variance of the regression and X is a nd Â np matrix of observation sensitivities @y 0 i b ð Þ=@b j . For nonlinear models, X generally differs for different sets of parameter values. Estimated parameter varia... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |

### Efficiency Assessment of Approximated Spatial Predictions for Large Datasets

- TEI : `corpus\papers\tei\Efficiency_assessment_of_approximated_spatial_predictions_for_large_datasets_W2982906409.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Application to Soil Moisture Data | To show the effectiveness of our suggested TLR tuning parameter settings for real datasets, we compare the estimation and prediction performance of the TLR approximation to the exact MLE for the soil moisture dataset, with a 64-bit 20-core Intel Xeon Gold 6... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 8 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 5 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 7 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 9 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 10 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 11 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 12 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 13 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 15 : |
| low_priority_review | `truncated` |  |  | 7 autres candidats non affiches dans ce rapport |

### Efficiency of spatially multiscale machine learning models in addressing spatial non-stationarity and enhancing predictive accuracy

- DOI : `10.1007/s10109-026-00493-8`
- TEI : `corpus\papers\tei\Efficiency of spatially multiscale machine learning models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 66 | Spatially multiscale geographically weighted models | This section introduces the SM-GW framework and explains how location-specific bandwidths are estimated, stabilized, and applied for prediction. Geographically weighted models rely on a single, globally optimized bandwidth, which is applied uniformly across... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Properties of datasets | The first characteristic analyzed was the complexity of the functional relationship. Relative gains by functional form are summarized in Fig. 6 , and corresponding absolute accuracies (mean RMSE) are shown in Figure 15 . For linear regression, the largest r... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Empirical findings | The incorporation of geographical covariates, specifically geographical coordinates, is a straightforward and cost-effective method to mitigate spatial non-stationarity in spatial datasets. However, our experiments reveal that this approach is unreliable an... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Experimental design | The research involved the development and comprehensive evaluation of a variety of predictive models. Initially, global models were constructed using Linear Regression (LR), Random Forest (RF), Support Vector Machines (SVM) and Extreme Gradient Boosting (XG... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Computational complexity | The computational cost of GW and SM-GW models is dominated by repeated local model fitting during bandwidth tuning and prediction. Let n denote the number of training observations, n test the number of prediction locations, p the number of predictors, m the... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Bandwidth | The final experiment explores the influence of varying kernel bandwidth on predictive accuracy. The distribution of bandwidth values differs for each algorithm (Figures. 11 Fig. 10 Radar plot of relative improvement across dataset characteristics. Each axis... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Theoretical implications | Spatially multiscale variants-i.e., location-specific bandwidths estimated on a training grid and interpolated into a continuous bandwidth surface-consistently underperformed relative to their single-bandwidth geographically weighted counterparts in terms o... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals

- DOI : `10.1111/geb.12999`
- TEI : `corpus\papers\tei\Barreto2019Environmental.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | / Diversity measures | We mapped the geographical distribution of terrestrial mammals by recording their presence in each grid cell. We used SAM (spatial analysis in macroecology; T. F. L. Rangel, Diniz-Filho, & Bini, 2006; T. F. Rangel, Diniz-Filho, & Bini, 2010) to calculate th... |
| low_priority_review | `DataSourceCandidate` | 47 | / Diversity measures | We mapped the geographical distribution of terrestrial mammals by recording their presence in each grid cell. We used SAM (spatial analysis in macroecology; T. F. L. Rangel, Diniz-Filho, & Bini, 2006; T. F. Rangel, Diniz-Filho, & Bini, 2010) to calculate th... |
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental predictors | To incorporate environmental productivity, temperature, elevation and climatic stability into our analyses, we compiled, respectively, the following variables: (a) mean AET (Trabucco & Zomer, 2010) ; (b) mean annual temperature (Fick & Hijmans, 2017) ; (c)... |
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental predictors | To incorporate environmental productivity, temperature, elevation and climatic stability into our analyses, we compiled, respectively, the following variables: (a) mean AET (Trabucco & Zomer, 2010) ; (b) mean annual temperature (Fick & Hijmans, 2017) ; (c)... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / Statistical analysis | We designed a path model according to a hypothesis of how the environmental factors are likely to influence SR and PD, in addition to how PD is influenced by SR (Figure 1 ). The path model can assess: (a) the direct effect of each variable on richness and P... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / Statistical analysis | We designed a path model according to a hypothesis of how the environmental factors are likely to influence SR and PD, in addition to how PD is influenced by SR (Figure 1 ). The path model can assess: (a) the direct effect of each variable on richness and P... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | / INTRODUC TI ON | Biodiversity encompasses multiple dimensions, such as phylogenetic and functional diversity, and species richness (SR), which have varying degrees of spatial covariation (Stevens & Tello, 2018) . Environmental factors are correlated differently with each di... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | / INTRODUC TI ON | Biodiversity encompasses multiple dimensions, such as phylogenetic and functional diversity, and species richness (SR), which have varying degrees of spatial covariation (Stevens & Tello, 2018) . Environmental factors are correlated differently with each di... |

### Environmental factors influencing spotted hyena and lion population biomass across Africa

- DOI : `10.1002/ece3.8359`
- TEI : `corpus\papers\tei\Jones2021Environmental.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 58 | / Sites and data | The influences of environmental variables upon spotted hyena and lion biomass were investigated from 14 published sites across Africa (Figure 1 ). From these sites, data were obtained on predator and prey biomass, temperature metrics, precipitation metrics,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Statistical analyses | The relationships between key variables (prey biomass, predator biomass, temperature variables, precipitation variables, and vegetation cover) were analyzed initially to enable an appropriate statistical analyses strategy. In many cases where it is appropri... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / D ISCUSS I ON | Using PLS regression, the influences upon spotted hyena and lion biomass were assessed, focusing on competition, prey biomass, temperature, precipitation, and vegetation cover. The initial model runs (PLS 1a for spotted hyena biomass, and PLS 2a for lion bi... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / RE SULTS | The r 2 and p-values of the PLS regressions for both spotted hyena and lion are summarized in Table 3 . PLS 1a assessed influences upon spotted hyena biomass and the whole model is significant in explaining spotted hyena biomass, with a p-value of <.05 and... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | ACK N OWLED G M ENTS | This work was supported by a Natural Environment Research Council studentship (NE/L002485/1) through the London NERC Doctoral Training Partnership. We are grateful for the detailed comments provided by the Associate Editor and by Professor Matthew Hayward a... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | TA B L E 1 | Sites from Hatton et al.'s (2015) database included in the spotted hyena and lion biomass analyses (Aitchison, 1982; Pollard et al., 2006) . To avoid this, the vegetation data were transformed by the centered log-ratio, following Kucera and Malmgren (1998)... |

### Erratum to: Housing price prediction: parametric versus semi-parametric spatial hedonic models

- DOI : `10.1007/s10109-017-0257-y`
- TEI : `corpus\papers\tei\Erratum_to_Housing_price_prediction_parametric_versus_semi_parametric_spatial_he_W2755598338.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | Section 1 | J.-M. Montero et al. Table 1 continued Model Specification Spatial lag Spatial drift Nonparametric functions of covariates Response Covariates Error Housing price prediction: parametric versus… 109 |

### Estimating dynamic spatial panel data models with endogenous regressors using synthetic instruments

- DOI : `10.1007/s10109-022-00397-3`
- TEI : `corpus\papers\tei\Estimating_dynamic_spatial_panel_data_models_with_endogenous_regressors_using_sy_W4306175449.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | 3 | Estimating dynamic spatial panel data models with endogenous… In contrast, the bias for the comparator is negligible, and since everything else is the same, it appears that the primary cause of the larger bias is the presence of spatial lags. For the spatia... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | 3 | Estimating dynamic spatial panel data models with endogenous… fitting regressions in which the dependent variable is the k ′ th endogenous vari- able ̃ tk and the independent variables are the eigenvectors i . The outcome is the isolation of the relevant su... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 8 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 17 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | True value Number of instruments 110 40 26 12 = 0.2 0.1967 0.1981 0.2 0.1999 1 = 1 0.8703 0.8669 0.8766 0.8683 2 = 0.5 0.5449 0.5452 0.5419 0.5439 3 = 0.75 0.848 0.8499 0.8322 0.8529 4 = 1 1.0891 1.0866 1.0915 1.0898 Table 9 Mean parameter estimates: 2 = 0.... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 15 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 16 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 25 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Number of instruments True value 292 152 40 19 = 0.75 0.747 0.7485 0.7494 0.7486 = 0.3 0.312 0.3108 0.3038 0.3015 1 = 4 3.9994 4.002 4.0063 4.0072 2 = 3 2.9941 2.995 2.9963 3.0004 3 = 2 1.9895 1.9907 1.9894 1.9976 4 = 1 1.0011 1.0109 1.0143 1.022 =-0.6 -0.6... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | n.b. italics denote estimates from simple specification |

### Estimating individual effects and their spatial spillovers in linear panel data models: Public capital spillovers after all?

- TEI : `corpus\papers\tei\Estimating_individual_effects_and_their_spatial_spillovers_in_linear_panel_data__W2747659787.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 : |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Model | Fixed effects models implicitly assume that the individual effects are correlated with the covariates. But they somehow ignore this correlation in the estimation procedure. In fact, what the within and analogous transformations do (see e.g. Beer and Riedl,... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Coefficients β γ Π µ Π α Private capital 0.199 * * * 0.260 * * * 0.197 * * * -0.477 * * * (0.030) (0.043) (0.052) (0.089) Labour 0.724 * * * -0.027 -0.212 * * * 0.101 (0.035) (0.050) (0.066) (0.115) Unemployment rate -0.002 -0.007 * * * -0.013 0.035 * (0.00... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Coefficients β γ Π µ Π α Private capital 0.255 * * * 0.259 * * * 0.351 * * * -0.601 * * * (0.037) (0.055) (0.081) (0.135) Labour 0.676 * * * -0.045 -0.666 * * * -0.100 (0.059) (0.078) (0.132) (0.217) Unemployment rate -0.003 -0.009 * * * 0.009 0.067 * * (0.... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Coefficients β γ Π µ Π α Private Capital 0.252 * * * 0.419 * * * 0.342 * * * -0.909 * * * (0.040) (0.068) (0.084) (0.180) Labour 0.666 * * * -0.279 * * * -0.776 * * * (0.050) (0.084) (0.118) Unemployment rate -0.011 * * * -0.008 * * * (0.002) (0.003) Public... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | det(A) = T 2N det (I N ) det w w -w (I N ) -1 w = T 2N det (w w -w w) = 0 (5.2) Proof of Proposition 2. Since the correlated random effects spatial-(X, µ) panel data model is linear in parameters, it is identified iff det( X X) = 0. |

### Estimation and Inference of Quantile Spatially Varying Coefficient Models Over Complicated Domains

- DOI : `10.1080/01621459.2025.2480867`
- TEI : `corpus\papers\tei\Estimation and Inference of Quantile Spatially Varying Coefficient Models Over Complicated Domains.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Application | In this section, we employ the proposed method to analyze age-adjusted mortality data for the United States. An additional application to the Particulate Matter (PM) data study is presented in the supplementary material due to space constraints. The mortali... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Quantile SVCMs | i=1 is a random sample of size n from the joint distribution of (Y, X, S), where X = (X 0 , . . . , X p ) is (1 + p)-dimensional covariate vector with X 0 = 1 and Y is the response of interest for a location S = (S 1 , S 2 ) distributed on a bounded domain... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Methodological Implementation and Statistical Inference | This section details the practical aspects of applying the proposed methods in our statistical analysis. Specifically, it outlines strategies for selecting tuning parameters and triangulation and describes methods employed to construct pointwise confidence... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

### Estimation and inference in spatially varying coefficient models

- DOI : `10.1002/env.2485`
- TEI : `corpus\papers\tei\Estimation and inference in spatially varying coefficient models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 5 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Null hypothesis Corresponding variables p value 𝛽 0 (u) = 𝛽 0 Intercept < 0.001 𝛽 1 (u) = 𝛽 1 PPTN 0.406 𝛽 2 (u) = 𝛽 2 RH 0.688 𝛽 3 (u) = 𝛽 3 T min 0.430 𝛽 4 (u) = 𝛽 4 T max 0.020 𝛽 5 (u) = 𝛽 5 WS < 0.001 𝛽 6 (u) = 𝛽 6 TCDC < 0.001 𝛽 k (u) = 𝛽 k , k = 0, 1,... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 5 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Null hypothesis Corresponding variables p value 𝛽 0 (u) = 𝛽 0 Intercept < 0.001 𝛽 1 (u) = 𝛽 1 PPTN 0.406 𝛽 2 (u) = 𝛽 2 RH 0.688 𝛽 3 (u) = 𝛽 3 T min 0.430 𝛽 4 (u) = 𝛽 4 T max 0.020 𝛽 5 (u) = 𝛽 5 WS < 0.001 𝛽 6 (u) = 𝛽 6 TCDC < 0.001 𝛽 k (u) = 𝛽 k , k = 0, 1,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Testing individual function stationarity | One important question arose in varying-coefficient literature: "Does a particular set of local parameter estimates exhibit significant spatial variation?". To answer this question, we focus on testing the following null hypothesis: To conduct a hypothesis... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Testing individual function stationarity | One important question arose in varying-coefficient literature: "Does a particular set of local parameter estimates exhibit significant spatial variation?". To answer this question, we focus on testing the following null hypothesis: To conduct a hypothesis... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Bivariate spline estimators | For a nonnegative integer r, let C r (Ω) be the collection of all rth continuously differentiable functions over Ω. Given a triangulation △, let  r d (△) = {s ∈ C r (Ω) ∶ s/ 𝜏 ∈ P d (𝜏), 𝜏 ∈ △} be a spline space of degree d and smoothness r over triangulat... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Bivariate spline estimators | For a nonnegative integer r, let C r (Ω) be the collection of all rth continuously differentiable functions over Ω. Given a triangulation △, let  r d (△) = {s ∈ C r (Ω) ∶ s/ 𝜏 ∈ P d (𝜏), 𝜏 ∈ △} be a spline space of degree d and smoothness r over triangulat... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | INTRODUCTION | In spatial data analysis, a common problem is to identify the nature of the relationship that exists between variables. In many situations, a simple "global" model often cannot explain the relationships between some sets of variables, which is referred to a... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | INTRODUCTION | In spatial data analysis, a common problem is to identify the nature of the relationship that exists between variables. In many situations, a simple "global" model often cannot explain the relationships between some sets of variables, which is referred to a... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 2 |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Estimation and prediction for spatial generalized linear mixed models with parametric links via reparameterized importance sampling

- TEI : `corpus\papers\tei\Estimation_and_prediction_for_spatial_generalized_linear_mixed_models_with_param_W2909133069.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | Analysis of radionuclide concentrations on the Rongelap island | The dataset consists of the measurements of γ-ray counts y i observed during t i seconds at ith coordinate on the Rongelap island, i = 1, . . . , n, n = 157. This data set was analyzed by Diggle et al. (1998) and Christensen (2004) , among others, using a P... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Analysis of the incidence rates of the Rhizoctonia root rot | In this example we analyze the root infection rates caused by Rhizoctonia fungi on wheat and barley. Data were collected at 100 locations where 15 plants were pulled out at each location and the total number of crown roots and infected crown roots were coun... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Binomial response variables | For binomial response variables, the mean, f ν (z), lies between 0 and 1. It is helpful to think of the inverse link function as having the form f ν (z) = F ν (z) where F ν is the cdf of a real-valued continuous random variable with support being the whole... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Matérn Exp-power Spherical Exponential Ensemble NegScore 63976 64923 63896 62482 36797 RMSE 21359 21499 21406 21185 17329 |

### Evaluating the performance of AIC and BIC for selecting spatial econometric models

- DOI : `10.1007/s43071-022-00030-x`
- TEI : `corpus\papers\tei\Evaluating_the_performance_of_AIC_and_BIC_for_selecting_spatial_econometric_mode_W4313202005.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | The LM tests for spatial econometric models and the information criteria | Consider the Spatial Independent Model (SIM), also known as the Non-Spatial Econometric Model (NSEM), defined as: where y is a ( n × 1 ) vector of observations of the dependent variable, Χ is a [ n × (k + 1) ] matrix of observations of k independent variabl... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 9 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 10 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 11 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 12 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 14 |
| low_priority_review | `truncated` |  |  | 8 autres candidats non affiches dans ce rapport |

### Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced statistical models

- DOI : `10.1371/journal.pone.0277499`
- TEI : `corpus\papers\tei\agridat_tesfaye.millet - Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Evolutionary processes, dispersal limitation and climatic history shape current diversity patterns of European dragonflies

- DOI : `10.1111/ecog.03137`
- TEI : `corpus\papers\tei\Pinkert2017Evolutionary.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Distribution and trait data | Digital distribution maps from two IUCN Red List Assessments (Riservato et al. 2009 , Kalkman et al. 2010) were reassigned to an equal-area grid (CGRS, cell size of approximately 50 km × 50 km) with functions provided in the Rpackage RSAGA (Brenning 2008) .... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Measures of diversity | We investigated patterns of dragonfly diversity in terms of three different aspects: species richness, endemism and phylogenetic diversity. Endemism is commonly defined as the proportion of species that are restricted to a certain geographical area. Accordi... |
| low_priority_review | `ModelEvidenceCandidate` | 49 | Regression models | To assess which factors determine patterns of species richness, corrected weighted endemism, and phylogenetic diversity (i.e. total taxonomic distinctiveness and MPD), we used generalized additive models implemented in the Rpackage mgcv (Wood 2011) . In all... |

### Examining the effects of green infrastructure on residential sales prices in Omaha, Nebraska

- DOI : `10.1016/j.ufug.2020.126778`
- TEI : `corpus\papers\tei\Examining the effects of green infrastructure on residential sales prices in Omaha Nebraska.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Data Preparation and Analysis | We obtained records of all arm's-length residential property sales (i.e., transactions between unrelated parties acting in their own self-interest) and associated housing characteristics for January 2000-August 2018 from the Douglas County Assessor. We clea... |
| low_priority_review | `DataSourceCandidate` | 48 | Data Preparation and Analysis | We obtained records of all arm's-length residential property sales (i.e., transactions between unrelated parties acting in their own self-interest) and associated housing characteristics for January 2000-August 2018 from the Douglas County Assessor. We clea... |
| low_priority_review | `DataSourceCandidate` | 46 | Study Site | The City of Omaha, NE, USA has a land area of 127.09 mi 2 (329 km 2 ), a population of 408,958, the median household income is $53,789, and more than 15% of residents are persons in poverty (US Census Bureau, 2010) . Omaha is comprised of both municipal sep... |
| low_priority_review | `DataSourceCandidate` | 46 | Study Site | The City of Omaha, NE, USA has a land area of 127.09 mi 2 (329 km 2 ), a population of 408,958, the median household income is $53,789, and more than 15% of residents are persons in poverty (US Census Bureau, 2010) . Omaha is comprised of both municipal sep... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Repeat-Sales Model | We estimate a repeat-sales model, which, as noted above, evaluates the change in a property's value between sales. These models, relative to a traditional hedonic approach, are less susceptible to omitted variable bias because time-invariant characteristics... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Repeat-Sales Model | We estimate a repeat-sales model, which, as noted above, evaluates the change in a property's value between sales. These models, relative to a traditional hedonic approach, are less susceptible to omitted variable bias because time-invariant characteristics... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | We present several specifications of the repeat-sales model, which differ in terms of GI-park buffer zones and the set of properties included in the estimation (Table 4 ). Control variables J o u r n a l P r e -p r o o f exhibited the expected signs and rel... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | We present several specifications of the repeat-sales model, which differ in terms of GI-park buffer zones and the set of properties included in the estimation (Table 4 ). Control variables J o u r n a l P r e -p r o o f exhibited the expected signs and rel... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | J o u r n a l P r e -p r o o f | Objective Our objective is to examine whether GI affects residential property prices. Using data from Omaha, NE, USA we estimate a repeat-sales model-an extension of the standard hedonic property model-to evaluate how the installation of GI features in exis... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | J o u r n a l P r e -p r o o f | Objective Our objective is to examine whether GI affects residential property prices. Using data from Omaha, NE, USA we estimate a repeat-sales model-an extension of the standard hedonic property model-to evaluate how the installation of GI features in exis... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Exploring Spatial Data Mining Techniques: Predicting Zinc Concentration with Kriging Methods and Geographically Weighted Regression Spatial data mining methods were used to pred...

- DOI : `10.14246/irspsd.13.2_145`
- TEI : `corpus\papers\tei\Krotha_2025_Zinc_Kriging_GWR.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 68 | Geographically weighted regression | Geographically Weighted Regression (GWR) is an analysis method for spatial point data that allows values missing from the data set to be interpolated. It is applied with the knowledge that the direction and strength of a relationship between a dependent var... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Geographically weighted Regression analysis (GWR) | GWR can be performed with the spgwr package in R. Figure 9 displays a contour map of the expected zinc concentration and a plot of the standard error of predictions, which illustrates the degree of uncertainty and variability in the estimated zinc values ac... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Universal Kriging | Kriging is one of several methods that use a small sample of sampled data points to estimate a variable's value over a continuous spatial field. Two examples of values that vary across a random spatial field are the average monthly concentration of ozone ov... |
| low_priority_review | `ModelEvidenceCandidate` | 47 | METHODS | In order to use Kriging or optimal prediction techniques, we must ascertain the spatial correlation's structure. This problem is known as the structural analysis problem in geostatistics, and it becomes important in the ensuing Kriging procedure. The accura... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 4 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Description Value Fixed bandwidth 228 Number of data points 155 The effective number of parameters 59.32127 (residual: 2traces-traces's) Effective degrees of freedom (residual: 95.67873 2traces-traces's) Sigma (residual:2traces-traces's) 171.8668 The effect... |

### Extracting spatial effects from machine learning model using local interpretation method: An example of SHAP and XGBoost

- DOI : `10.1016/j.compenvurbsys.2022.101845`
- TEI : `corpus\papers\tei\Extracting spatial effects from machine learning model using local interpretation method_SHAP and XGBoost.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | An example of modelling ride-hailing service demand in Chicago | Simulations in the previous section demonstrate that machine learning model is accurate even when complex spatial and non-spatial effects present, and SHAP can be used to estimate these effects. In this section, we show an empirical example of using SHAP to... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Conclusions | Machine learning models have become increasingly common in modelling and predicting spatial phenomena. Interpretability is a major challenge in machine learning that limits its further adoption in spatial data modelling when the interest is in discovering t... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Results | In Table 2 , an overall assessment of model performance demonstrates that both models fit the data well. According to the RMSE of the various partial components, MGWR is better at modelling continuous spatial heterogeneity in β 0 and β 1 , whereas XGBoost i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Table 1 summarises the overall model accuracy for both SLM and XGBoost. Because of the model estimation process is different in statistical and machine learning models, the R 2 value (1 -∑ (y -ŷ) 2 / ∑ (y -y) 2 ) and residual Root Mean Square Error (RMSE) w... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Interpretable machine learning and SHAP | The goal of interpretable machine learning is to understand how models make predictions and to answer questions such as what the relationships between input and output are and what features are most important in driving the prediction. Model-specific and mo... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Comparisons of SHAP-explained machine learning to spatial statistical models | Spatial autocorrelation and spatial heterogeneity are the two wellknown spatial effects in spatial analysis and modelling (Anselin, 1988) . Spatial autocorrelation refers to the process that creates clusters of values, and this effect is usually accounted f... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | SLM XGBoost R 2 0.811 0.783 RMSE of residuals (ε) 1.005 1.088 Moran's I of residuals (ε) 0.013 0.055 RMSE of spatial lag (ρWy) 0.016 0.272 RMSE of parametric term 1 (β 1 X 1 ) 0.007 0.218 RMSE of parametric term 2 (β 2 X 2 ) 0.011 0.187 |

### Fast Nonseparable Gaussian Stochastic Process with Application to Methylation Level Interpolation

- TEI : `corpus\papers\tei\Gu2020Fast.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | S3 Comparison to approximation method by blocks | In this subsection, we compare our exact and fast computation of the nonseparable GaSP model with a straightforward approximation, in which the long sequence is divided into small blocks and GaSP models are built independently in each block. Assume the data... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | S2 Combing feature data into the nonseparable model | To impute the methylation levels, some site-specific features such as genomic position, DNA sequence properties, cis-regulatory element, can be used as covariates in a regression model. Incorporating regressors/covariates is less studied in the nonseparable... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Application 1: WGBS data | We first compare the out-of-sample prediction of different methods using the criteria discussed above for 10 6 methylation levels at chromosome 1 in the WGBS dataset (Ziller et al., 2013) . In this dataset, 24 samples are available in total and we randomly... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Numerical comparison | We evaluate the nonseparable GaSP model in (1) and compare to several alternative methods: two linear regression strategies (by site in (18) and by sample in ( 19 )), nearest neighbor method (using only the observed methylation level closest to the unobserv... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | RMSE P CI (95%) L CI (95%) Accuracy Nonseparable GaSP .0296 .958 .103 .991 Nearest neighbor .350 / / .774 Linear model by site .0342 .944 .099 .990 Random forest by site .0339 / / .989 Linear model by sample .0304 .957 .106 .990 Random forest by sample .030... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | s D can be expressed y * i (s D ) T = y(s D ) T β i + ϵ i , where y * i (s D ) is the i th row of y * (s D ) and ϵ i ∼ MN(0, σ 2 i0 I n ). The least squares (LS) estimator of β i is βi = y(s D )y(s D ) T -1 y(s D )y * i (s D ) T , |

### Fast Spatio-Temporally Varying Coefficient Modeling With Reluctant Interaction Selection

- DOI : `10.1111/gean.70005`
- TEI : `corpus\papers\tei\Geographical Analysis - 2025 - Murakami - Fast Spatio‐Temporally Varying Coefficient Modeling With Reluctant Interaction.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | / Model for Data | We consider the following model: where 𝑥 𝑝 (𝑠, 𝒕) is the 𝑝-th covariate observed at site 𝑠 at time 𝒕, with 𝑝 = 1 assumed to be constant (i.e., 𝑥 1 (𝑠, 𝒕) = 1). 𝜎 2 is the noise variance. Following GAM-related studies using a linear combination of spatial an... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 6 / |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Outline | This section applies the proposed method to analyze hourly and monthly larceny counts per square km, which we will call the larceny density (source: Crime Dashboard: https://www. sanfranciscopolice.org/stay-safe/crime-data/crime-dashboard ), by 194 district... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | / Property of the Model | Although both our STVC model and GAM consider basis functions for modeling STVCs, the former has several advantages as follows. First, the number of basis functions/eigenvectors is automatically determined by the number of positive eigenvalues, explaining p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Result | Table 4 summarizes the error statistics and computation time. LM achieves a reasonable accuracy because it implicitly considers dynamic spatio-temporal patterns through LarcenyPre. However, S demonstrates superior adjusted R-squares(𝑅 2 𝑎𝑑𝑗 ), log-likelihoo... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Result | Figure 8 compares the RMSEs for the strong and weak STVCs. For reference, LM and S are compared again. In Case I, GTWR and STc int outperform GWR and S, confirming the importance of considering temporal patterns in regression coefficients. However, GTWR exh... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | / Methodology | We develop a fast and flexible STVC model that defines each varying coefficient as a sum of constant (mean), (i) spatial, (ii) 𝑄 cyclic/non-cyclic temporal, and (iii) 𝑄 cyclic/non-cyclic spatio-temporal processes. Section 3.1 introduces our STVC model and S... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Comparison With GTWR 4.3.1 / Outline | This section compares the proposed method with GWR and GTWR, which are widely used for modeling SVC and STVC, respectively. Following our model, an exponential kernel is used for their local weighting, and the bandwidth is optimized by minimizing the correc... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Model | This study considers the explained variable 𝑦(𝑠, 𝒕) observed at site 𝑠 ∈ {1, . . . , 𝑆} in a study region 𝐷 ⊂ ℝ 2 at time 𝒕 = {𝑡 1 , . . . , 𝑡 𝑄 } measured on single or multiple axes (e.g., year, week, and hour) indexed by 𝑞 ∈ {1, . . . , 𝑄}. Since the type... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Outline | This section considers the following regression model: where 𝑥 𝑝 (𝑖, 𝒕) ∼ 𝑁(0, 1) and 𝒕 = {𝑡 1 , 𝑡 2 }. The following specifications are considered for the three coefficients: where {𝑏 1 , 𝑏 2 , 𝑏 3 } = {1, 2, -0.5} and [⋅] denotes standardization to zero m... |

### Fire and forest loss in the Dominican Republic during the 21st Century

- DOI : `10.1101/2021.06.15.448604`
- TEI : `corpus\papers\tei\Fire_and_forest_loss_in_the_Dominican_Republic_during_the_21st_Century_W3166721665.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Spatio-temporal patterns | Regarding spatio-temporal features, both forest loss and fire density showed patterns of cyclical variation of their spatial autocorrelation, and featured multiple spatial layouts of HH clusters and LL clusters in shifting locations throughout the DR over t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Spatial modeling | For both the long-term and annual approaches, I conducted exploratory spatial data analysis (ESDA) and fitted several models using maximum likelihood estimation. First, I assessed the normality of the variables using Shapiro-Wilk tests and QQ plots, and app... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial dependence between Forest loss and Fire density | The results of the diagnostic for spatial dependence indicated that a spatial error specification was suitable for the data of the 2001-2018 period (Table S2 ). Both the coefficient and the intercept estimates for each model were positive and significant in... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Summary FORESTLOSS0118∼ statistic FIRESMODIS † Intercept (Std. Error; P r(> /z/)) 0.099 (0.005; p ≪ 0.01) Coefficient (Std. Error; P r(> /z/)) 0.250 (0.015; p ≪ 0.01) λ (LR test value, p-value) 0.732 (243.26; p ≪ 0.01) Moran's I test for residuals (p-value)... |

### Fitting Dynamic Regression Models to Seshat Data Permalink

- DOI : `10.21237/C7clio9137696`
- TEI : `corpus\papers\tei\Turchin_2018_FittingDynamicRegressionSeshatData_Cliodynamics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Data Collection | To populate the Databank, for each NGA we consult the literature and chronologically list all polities that were located in the NGA, or encompassed it. We chose a temporal sampling rate of one hundred years, and we only included polities that span a century... |
| low_priority_review | `DataSourceCandidate` | 47 | Multiple Imputation | Dealing with Missing Data, Uncertainty, and Expert Disagreement Due to the fragmentary nature of the information that is available about past societies it is not possible to reliably code all variables for all polities. There is therefore a non-trivial amou... |
| low_priority_review | `DataSourceCandidate` | 46 | Aggregation of Social Complexity Data into "Complexity Components" | As the preceding discussion shows, during the data collection stage complex variables are broken down into simpler components and data are gathered for each component. Before analysis we assemble simpler (often, binary) variables into more quantitative meas... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Results: Processes Influencing the Evolution of Info | The first step in the analysis aims to understand how much variability in the results is introduced by missing data, uncertainty, and expert disagreement. As was explained above (Dealing with Missing Data, Uncertainty, and Expert Disagreement), I generated... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Sample Size and Structure | Once all Complexity Characteristics (CCs) are aggregated they are put together in a data file whose columns are polity name, NGA name, time (in centuries), and the values of eight CCs (see the SOM for a description of the data file published as part of R-sc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Missing data. | For missing data we impute values as follows. Suppose for some polity we have a missing value for variable A and coded values for variables B through H. We select a subset of cases from the full dataset in which all variables A through H have values and bui... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Cross-validation | One interesting issue in helping us interpret multiple imputation results is how accurately the stochastic regression approach can predict missing values. Most importantly, does this approach actually yield better estimates than, for example, simply using t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Results: k-Fold Cross-Validation of Info | Ability to accurately predict values of Complexity Components also supports the approach of using stochastic regression with multiple imputation. Using existing values to impute the missing ones yields smaller variation in imputed values, compared to, for e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | The Evolution of Information Systems | This article will illustrate these ideas and methods of analysis by focusing on processes that may influence the evolution of one component of social complexity, information systems, using the Seshat: Global History Databank (Turchin et al. 2015) . There is... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Complicating Factors | Time-series data, thus, offer us a possibility of resolving causal relationships between variables. However, in real-life applications there are many factors that could defeat our ability to detect cause-effect arrows. One fundamental difficulty is that alt... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Dynamic Regression Methods | The general regression model that I used above to investigate factors affecting the evolution of the Seshat measure of information complexity (Info) takes the following form: Here Yi,t is the response variable; in our case it is the value of Info coded for... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### Flexible nonlinear spatial autoregressive models: a gradient boosting approach with closed-form estimation

- DOI : `10.1111/gean.12268`
- TEI : `corpus\papers\tei\spbbost_article.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 8 : |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Functional gradient descent boosting with additive models | Statistical boosting introduced by Friedman et al. (2000) provides a natural bridge between machine learning algorithms and interpretable statistical models through generalized additive models (GAMs) (Hastie and Tibshirani, 1990) . Gradient boosting methods... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Calibration grid and selection of W | The far-prediction protocol partitions California into ten contiguous environmental blocks: five latitude bands crossed with a coastal/inland split based on ocean proximity == INLAND. For each test block, the four other blocks of the same environmental clas... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | F.1. Overview | The calibration of BSPA SAR CFE addresses three coupled choices: (i) the spatial weight matrix W ; (ii) the degrees of freedom ν of the bivariate spline b sp (x, y) entering the regression specification, with ν = 0 encoding the absence of a bivariate spatia... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Estimation algorithm | Algorithm 1 summarizes the complete estimation procedure. To ensure memory efficiency for very large samples (e.g., n = 250, 000), the spboost package leverages C++ via Rcpp and RcppEigen for all operations involving the spatial weights matrix W . This spar... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | F.5. Triplet evaluation and regime classification | For each CV mode and each split, candidate matrices are rebuilt on the fold-specific prediction support tr ∪ te. For each triplet (W (c) , ν, m), BSPA SAR CFE is fitted on the training set with W (c) train = normW{W (c) [tr, tr]}, the baseline hedonic formu... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Prediction regimes and neighbourhood preservation under spatial cross-validation | The empirical analysis is organised around two prediction regimes. In far-prediction, test observations are spatially distant from the training support, as in ecological or environmental extrapolation. In near-prediction, test observations are embedded in a... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 10 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 11 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 : |
| low_priority_review | `truncated` |  |  | 13 autres candidats non affiches dans ce rapport |

### Flexible shrinkage in high-dimensional Bayesian spatial autoregressive models

- TEI : `corpus\papers\tei\Flexible_shrinkage_in_high_dimensional_Bayesian_spatial_autoregressive_models_W2803996363.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 : |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Regions, spatial weights and data | For the empirical illustration we use data on regional economic growth on a sample of 273 European NUTS-2 regions of 28 European countries. The dependent variable in the regression framework is the average annual growth rate of per capita gross value added... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Econometric framework | We start by considering a model of the form where y is an N -dimensional vector of dependent variables and S(•) describes a linear transformation dependent on a not yet specified parameter. X is an N × K matrix of explanatory variables (with a vector of one... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Empirical illustration | In this section we aim at illustrating the performance of the proposed model specification using real data on pan-European regional economic growth and its empirical determinants. Specifically, we consider a cross-regional spatial Durbin model specification... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | q = 10 q = 20 RMSE β σ 2 ρ Time β σ 2 ρ Time K = 50 None 0.0184 0.2319 0.0044 1.02 0.0180 0.3072 0.0028 1.00 SSVS 0.0078 0.0150 0.0032 1.00 0.0107 0.0189 0.0021 1.00 NG 0.0090 0.0155 0.0034 1.05 0.0111 0.0168 0.0022 1.06 DL 0.0089 0.0185 0.0035 1.01 0.0120... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | q = 10 q = 20 RMSE dr β σ 2 ρ Time β σ 2 ρ Time K = 50 None 0.0250 0.0371 0.0072 1.02 0.0248 0.0363 0.0043 1.00 SSVS 0.0096 0.0273 0.0051 1.00 0.0127 0.0318 0.0034 1.00 NG 0.0122 0.0276 0.0053 1.05 0.0149 0.0300 0.0034 1.06 DL 0.0130 0.0357 0.0058 1.01 0.01... |

### Forecasting community reassembly using climate-linked spatiotemporal ecosystem models

- DOI : `10.1111/ecog.05471`
- TEI : `corpus\papers\tei\Forecasting_community_reassembly_using_climate_linked_spatio_temporal_ecosystem__W3123407648.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Estimation | We estimate all parameters using the vector autoregressive spatio-temporal (VAST) package (Thorson and Barnett 2017) in the R statistical environment (<www .r-project.org> ). This software package permits alternative specifications for the spatial correlati... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | ( ) | where a(g, x) is the association of each location g with a spatial knot x (i.e. A is a sparse matrix representing bilinear interpolation between knots, where a(g, x) = 0 for all but three knots x for each location g), λ c (c, f c ) is the association betwee... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methods | We seek to develop a spatio-temporal ecosystem model that can measure and forecast community reassembly. Specifically, we seek to account for nonlocal mechanistic associations between multiple system components ('ecological teleconnections') that are measur... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Model specification and interpretation | We specify that summer bottom temperature has the same spatio-temporal variation for both net-sensor measurements and ROMS hindcasts/projections, and the same for winter surface temperature for the NOAA reanalysis product and ROMS hindcasts/projections. We... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model structure | Specifically, we model the value y(g, c, t) for ecosystem variables at multiple locations in several years; g indexes each of n g modeled locations, c indexes each of n c variables and t indexes each of n t years (we use parentheses to indicate indexing for... |

### Forecasting hourly emergency department arrival using time series analysis

- DOI : `10.12968/bjhc.2019.0067`
- TEI : `corpus\papers\tei\Forecasting_hourly_emergency_department_arrival_using_time_series_analysis_W2999030003.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Methodology | Data regarding emergency department arrival patterns were retrospectively extracted from the EPIC database used by a hospital in Iowa. Hourly emergency department arrival data was collected from January 2014-August 2017. Table 1 shows the arrivals by day. A... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Framework explaining the method | The framework used in this study comprises four sections: data pre-processing, exploratory analysis, anomaly detection and forecasting. Every step in the framework encompasses various models and algorithms, each adjustable with various parameters. A typical... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Performance measures Seasonal Seasonal Root mean Auto Auto Auto auto auto Mean squared regression1 regression2 regression3 regression1 regression2 error error Coefficient 0.159 0.100 0.047 -0.584 -0.274 1.001 1.55 Standard error 0.005 0.005 0.005 0.005 0.005 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Models performance Measures TBATS Holt-Winters Neural net ARIMA Mean error 1.75 1.19 1.40 1.00 Root mean squared error 2.28 27.86 3.26 1.55 |

### Forests on the move: Tracking climate-related treeline changes in mountains of the northeastern United States

- DOI : `10.1111/jbi.14708`
- TEI : `corpus\papers\tei\Tourville2023Forests.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | / Spatial data processing | To examine the factors potentially influencing the spatial dynamics of treeline advance, both climatological and topographical variables were extracted for the Presidential Range (Table 1 , Appendix S2 in Supporting Information). We could not conduct a simi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Data analyses | To test our first hypothesis (treelines have advanced upslope, H1), the differences between the elevation of each randomly placed sample point on our contemporary imagery (see Remote sensing analysis) and historic imagery were calculated to quantify mean tr... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Factors moderating treeline advance | Model comparison procedures selected the best multiple linear regression model that included both climate and topographical variables (elevation, slope, aspect and AGDD) predicting the magnitude of treeline shifts (R 2 adj = 0.32, see Appendix S10 in Suppor... |

### Fuzzy clustering with spatial-temporal information

- DOI : `10.18637/jss.v087.c03`
- TEI : `corpus\papers\tei\Fuzzy_clustering_with_spatial_temporal_information_W2928446372.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 : |

### GAT-Metas: GeoAI-based metaheuristic framework for solving combinatorial optimization problems

- DOI : `10.1007/s10109-026-00499-2`
- TEI : `corpus\papers\tei\GAT_Metas_GeoAI_based_metaheuristic_framework_for_solving_combinatorial_optimiza_W7164823193.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Study area and spatial representation | For the empirical application, we focus on the optimization problem of dockless e-scooter parking zones in the Seoul metropolitan area, South Korea. The dockless micro-mobility has rapidly increased and led to uncontrolled and illegal parking problems. In 2... |

### GEOSTATISTICAL ANALYSIS OF SOIL CONTAMINATION IN THE SWISS JURA

- TEI : `corpus\papers\tei\Atteia_1994_soil_contamination_Swiss_Jura_EnvPollution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Sampling strategy | One aim of the survey was to map the distribution of potential pollutants in the soil over the whole of the region and to detect trends if they were present. This would require fairly even coverage, and a grid was chosen for the purpose. A second aim was to... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Two-way analysis of variance | We also analysed the variance by the combination of geology and land use, and the proportions of the variance accounted for by this combination are given in Table 7a . For Cd, Cr, Cu and Pb these proportions are close to the sums of the proportions separate... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Ordinary kriging | Mapping a regionalized variable is best done by kriging from a sample, and it is being used increasingly in soil studies (Burrough, 1993) . Basically it involves estimating from measurements a variable, in our case the concentration of metal or its logarith... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Regression | For each sampling point, the total depth of the soil in the field was also recorded and in the laboratory we measured the pH. Table 7b shows the R 2, the proportion of the soil variance explained by the regression between these factors considered as indepen... |

### GIS tools and programming languages for creating models of public and private transport potential accessibility in Szczecin, Poland

- DOI : `10.1007/s10109-020-00337-z`
- TEI : `corpus\papers\tei\GIS_tools_and_programming_languages_for_creating_models_of_public_and_private_tr_W3133655964.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Area and data | The research area covers the city of Szczecin in its administrative boundaries, situated in north-western Poland. In 2018, the city had a population of approximately 400 thousand people (data published by the City Hall). The City Hall provides population da... |
| low_priority_review | `DataSourceCandidate` | 45 | Individual transport modelsparameters | For the purposes of this article, the author has created an original model of private transport operation in Szczecin using Google Maps® API data, which had been downloaded with the help of a dedicated application written in Python 2.7. A basic grid of road... |

### GWRBoost:A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships

- TEI : `corpus\papers\tei\A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships_GWRBoost.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 72 | Variants of geographically weighted regression | Numerous variants have been developed to improve the GWR in various aspects. Several studies focus on the improvement of optimal bandwidth selection. Generally, the choice of bandwidth is crucial to the fitting result of GWR (Fotheringham et al., 2003) . A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Variants of geographically weighted regression | Numerous variants have been developed to improve the GWR in various aspects. Several studies focus on the improvement of optimal bandwidth selection. Generally, the choice of bandwidth is crucial to the fitting result of GWR (Fotheringham et al., 2003) . A... |
| low_priority_review | `ModelEvidenceCandidate` | 66 | Computation of Akaike information criterion | The AIC and AICc are the most common metrics to evaluate the fit performance of the GWR model, which are an unbiased estimate of the expected Kullback-Leibler information and a trade-off between goodness of fit and the degree of freedom. In a fitting task,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Computation of Akaike information criterion | The AIC and AICc are the most common metrics to evaluate the fit performance of the GWR model, which are an unbiased estimate of the expected Kullback-Leibler information and a trade-off between goodness of fit and the degree of freedom. In a fitting task,... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Additive linear model for located observations | In the classic geographically weighted model, an independent linear function is applied to formulate the relationships between dependent and independent variables for each observation i at the specific location: where (u i , v i ) denotes the location of i-... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Additive linear model for located observations | In the classic geographically weighted model, an independent linear function is applied to formulate the relationships between dependent and independent variables for each observation i at the specific location: where (u i , v i ) denotes the location of i-... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Model OLS GWR GWRBoost RSS 1639.063 ± 72.52 83.900 ± 5.049 36.797 ± 2.601 AIC 2385.642 ± 27.65 773.374 ± 36.050 225.512 ± 42.061 AICc 2385.739 ± 27.65 839.926 ± 35.383 274.817 ± 41.207 R 2 0.072 ± 0.02 0.952 ± 0.003 0.979 ± 0.002 Adjusted R 2 0.066 ± 0.02 0... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Model OLS GWR GWRBoost RSS 982.206 388.626 261.478 AIC 4499.669 3168.118 2289.994 AICc 4499.720 3315.637 2437.513 R 2 0.557 0.825 0.882 Adjusted R 2 0.556 0.790 0.858 Moran's I 0.333 0.066 -0.027 |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted Models

- TEI : `corpus\papers\tei\Gollini_2015_GWmodel_JSS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 63 | LCR GW regression vs. previous penalized GW regression models | It is important to clarify the difference between our LCR GW regression (say, LCR-GWR) and the GW ridge regression (GWRR) demonstrated in Wheeler (2007) . Essentially, LCR-GWR is more locally-focused than GWRR. GWRR similarly applies a local compensation, b... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Example | We examine the use of our local compensation approach with the same GW regression that is specified in Section 6, where voter turnout is a function of the eight predictor variables of the Dublin election data. For the corresponding global regression, the vi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model building with collinear data | If we explore the local condition numbers for models with different structures, it may be possible to build GW regression models which avoid collinearity. Here, we code a function to calibrate and then estimate a basic (un-adjusted) GW regression. This func... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Robust GW regression | To identify and reduce the effect of outliers in GW regression, various robust extensions have been proposed, two of which are described in Fotheringham et al. (2002) . The first robust model re-fits a GW regression with a filtered data set that has been fo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Data sets | The GWmodel package comes with five example data sets, these are: (i) Georgia, (ii) LondonHP, (iii) USelect, (iv) DubVoter, and (v) EWHP. The Georgia data consists of selected 1990 US census variables (with n = 159) for counties in the US state of Georgia;... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Example | We now demonstrate the fitting of the basic and robust GW regressions described, to the Dublin voter turnout data. Our regressions attempt to accurately predict the proportion of the electorate who turned out on voting night to cast their vote in the 2004 G... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | GW regression 6.1. Basic GW regression | The most popular GW model is GW regression (Brunsdon et al. 1996 (Brunsdon et al. , 1998)) , where spatiallyvarying relationships are explored between the dependent and independent variables. Exploration commonly consists of mapping the resultant local regr... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Example | To demonstrate GW regression as spatial predictor, we use the EWHP data set. Here our aim is to predict the dependent variable, house price (PurPrice) using a subset of the nine independent variables described in Section 2, each of which reflect some hedoni... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | LowEduc: Without any formal educational. | Age18_24: Age group 18-24. Age25_44: Age group 25-44. Age45_64: Age group 45-64. Thus the eight independent variables reflect measures of migration, public housing, high social class, unemployment, educational attainment, and three adult age groups. The EWH... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | GW principal components analysis | Principal components analysis (PCA) is a key method for the analysis of multivariate data (see Jolliffe 2002) . A member of the unconstrained ordination family, it is commonly used to explain the covariance structure of a (high-dimensional) multivariate dat... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Example | For applications of PCA and GW PCA, we again use the Dublin voter turnout data, this time focussing on the eight variables: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44 and Age45_64 (i.e., the independent variables of the regression fits in Sec... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | GW summary statistics | This section presents the simplest form of GW modelling with GW summary statistics (Brunsdon et al. 2002; Fotheringham et al. 2002) . Here, we describe how to calculate GW means, GW standard deviations and GW measures of skew; which constitute a set of basi... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Generalized Spatial and Spatiotemporal Autoregressive Conditional Heteroscedasticity

- TEI : `corpus\papers\tei\Generalised_spatial_and_spatiotemporal_autoregressive_conditional_heteroscedasti_W2511771736.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | p-Value 0.9712 0.0000 0.0000 - - - - 0.0000 - 0.0000 0.0000 0.0000 0.0000 0.4565 0.4852 SARspARCH Standard Error 0.1629 0.0397 0.0632 - - - - 0.0665 - 0.0278 0.0400 0.0015 0.0161 0.0106 0.0106 2484.686 Estimate -0.0059 -0.2641 0.5365 - - - - 0.3188 - 0.2624... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | //A 2 // < 1 (cf. Theorem 18.2.19 of |

### Geographic range size and speciation in honeyeaters

- DOI : `10.1186/s12862-022-02041-6`
- TEI : `corpus\papers\tei\Geographic range size and speciation in honeyeaters.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Phylogenetic inference | We used recent phylogenomic analyses [59, 60] in conjunction with traditional nuclear and mitochondrial markers [53] to construct a comprehensive phylogeny of honeyeaters. We followed the IOC world bird list (version 10.2; [77] ), which recognises 191 speci... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Phylogenetic regressions | To test the relationship between range size and speciation, while accounting for other factors that are likely to influence this relationship, measures of range size, shape, and position for each species were treated as traits and used in phylogenetic gener... |

### Geographically Weighted Cox Regression for Prostate Cancer Survival Data in Louisiana

- TEI : `corpus\papers\tei\Geographically_Weighted_Cox_Regression_for_Prostate_Cancer_Survival_Data_in_Loui_W2969402787.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Model Assessment Criterion | The bandwidth h in (8) should not be chosen arbitrarily. For Cox regression on a dataset where covariates are fixed but their effects are time-varying, Verweij and van Houwelingen (1995) suggested using partial likelihood based AIC for model selection. Here... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Motivating Example | The SEER Program provides information on cancer statistics in an effort to reduce the cancer burden among the U.S. population. We consider the prostate cancer data from July to December 2005 diagnoses for Louisiana from their November 2014 submission (Hu an... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Stochastic Neighborhood Weighting Function | We now review some traditional weighting schemes for geographically weighted regression. Suppose again, for now, that the precise (latitude, longitude) location of each observation is available. As in Hu (2017) and Hu and Huffer (2019) , a natural way to ac... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Geographically Weighted Cox Model | We first consider the case where the precise location of each observation is available, and is represented in (latitude, longitude) pairs. Let (T i , δ i , Z i , s i ), i = 1, ..., n, denote an independent sample of right-censored survival data from differe... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | C2 w i (s), i = 1, • • • , n follow regularity conditions of Theorem 3.2 in |

### Geographically Weighted Logistic Regression Applied to Credit Scoring Models*

- DOI : `10.1590/1808-057x201703760`
- TEI : `corpus\papers\tei\Geographically Weighted Logistic Regression Applied to Credit Scoring Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Coeffi cients Standard Deviation Wald Statistic Ratio of Chances Intercept -1.3068 0.0893 -14.6338* - d_age1 -0.5665 0.084 -6.7440* 0.567 d_age2 -0.2891 0.0907 -3.1874* 0.749 d_age4 0.1481 0.0635 2.3323* 1.160 d_age5 0.5684 0.0653 8.7044* 1.765 d_... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Geographically Weighted Logistic Regression | When the response variable is binary, GWR should be applied via Geographically Weighted Logistic Regression (GWLR), in which the formula for obtaining the probability of the event of interest occurring is given by: or still, in the form: in which π(x j ) is... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Global Model via Logistic Regression | Th e global model was developed using the development sample, containing 10,944 records. Th e variables used in developing the model were all of the dummies created based on the categorizations presented in Table 5 . Using the stepwise variable selection me... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 14 | All attributes of the rate of unemployment and infl ation variables presented similar levels of credit risk, and for this reason, they were excluded from the study. Th e categories for the other variables are found in Table 5 . It is observed in Table 5 tha... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Comparison Between the Models | Th e metrics used to compare the models developed via GWLR and Logistic Regression were: the AICc informational criteria (Hurvich, Simonoff, & Tsai, 1998) , the accuracy of the models, the percentage of false positives, the sum of the value of false positiv... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Comparison Between the Models | Th e comparison between the Logistic Regression model and the GWLR Adaptive Gaussian model was made using the following metrics: International AICc Criterion, Accuracy, Percentage of False Positives, Sum of Value of False Positive Debt, and Expected Monetar... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Database | Th e data related to this study refer to transactions involving Consumer Direct Credit (CDC) granted by a Brazilian fi nancial institution to clients residing in the Distrito Federal (DF). Th ese transactions are paid in installments over periods between 0... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Local Models via Geographically Weighted Logistic Regression (GWLR) | As described in the methodology, four models using the GWLR were developed, one for each weighting function shown in Table 1 . Th e predictive variables used were those selected by the logistic regression model, shown in Table 6 . Th e best model using GWLR... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial indicators | Moran's I (Moran, 1950) is one of the most widely used global indicators for verifying the existence of spatial correlation. Global indicators present a single measure of spatial tendency for the whole region being studied, they allow the hypothesis of the... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Univariate and Bivariate Analyses | Th e results on general default rates and those by region are shown in Tables 3 and 4 and the spatial distribution of default rates is found in Figure 6 . As shown in Table 3 , the general default rate in the DF was 27.66%; thus, it can be observed in Table... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Geographically neural network weighted regression for the accurate estimation of spatial non-stationarity

- DOI : `10.1080/13658816.2019.1707834`
- TEI : `corpus\papers\tei\Geographically neural network weighted regression for the accurate estimation of spatial non-stationarity.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 10 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Dataset | We designed a squared area with a length of 12 units as the simulated space and set the distance between two adjacent points to 0.5 (Figure 4(a) ). Accordingly, 625 observation points in this area are distributed on 25 × 25 matrix. The spatial coordinates o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model diagnosis | Testing for spatial non-stationarity of the parameters in the GNNWR model is quite important and some appropriate statistics for model diagnosis should be developed. The optimal bandwidth of the weight kernel should be determined prior to computing the fina... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Study area and data | The second case study is in the coastal area of Zhejiang (CAZ), China (Figure 4(b) ). Red tides is the primary cause of marine ecological damage in the CAZ and causes serious harm to the economic development and public safety in Zhejiang Province (Zhang et... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Experimental implementation | A four-layer feed-forward network is one of the most commonly used neural network architectures and is considered to be highly effective for nonlinear problems (Tamura and Tateishi 1997, Cetin et al. 2004) . Therefore, we design a four-layer SWNN architectu... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | OLS model | In spatial analysis, the OLS model is a basic method to identify the nature of the relationships among the factors in the form of a linear regression. In this technique, the relations between the dependent variabley i and the independent variables x i1 ; x... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Model design and estimation | The estimation process of the GNNWR model is shown in Figure 2 . First, we randomly divide the data into three sets: training dataset, validation dataset and testing dataset. It should be noted that the OLS coefficients, which denote the average relationshi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Conclusions | In this study, based on a concept similar to the GWR model, we propose a GNNWR model that combines OLS with an SWNN model to estimate spatial non-stationarity. SWNN is designed to precisely construct the nonstationary weight matrix by using the superior fit... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | GWR model | The basic concern associated with the GWR model is that a global model's coefficient estimates may be unable to express the sophisticated local variations over space. Therefore, the global form is extended by the GWR to allow local estimations, and the GWR... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 9 . |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Geographically weighted elastic net logistic regression

- DOI : `10.1007/s10109-018-0280-7`
- TEI : `corpus\papers\tei\Geographically_weighted_elastic_net_logistic_regression_W2892463357.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 54 | GW logistic regression (GW-LR) | For GW models, a moving-window kernel is used, where data falling under the kernel are weighted by their distance to the kernel centre using a distance-decay function. These weighted data subsets are then used to calculate location-specific models or statis... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methods | To situate the new GW-ENLR approach, details on logistic regression (LR), elastic net logistic regression (ENLR) and GW logistic regression (GW-LR) are also provided. These regressions will also be fitted to the case study data sets, for context and to demo... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | 3 | Geographically weighted elastic net logistic regression residing in either the north or the south, the binary response has no variance-consisting only of ones or only of zeros.) This is in contrast to the election case study where there is greater spatial h... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | 3 | Geographically weighted elastic net logistic regression For the election case study, it is observed: • The ENLR model drops two predictors in % Employed and % Over 65, where this is not unexpected given these predictors show the strongest correlations with... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Table 2 | The coefficient estimates from the study regression models, where the first, second and third quartiles (Q) of the coefficient distribution for the geographically weighted logistic regression (GW-LR) are given, and where the first, second and third quartile... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Logistic regression (LR) | An LR is a specific GLM with a logit link function of any number Q which is defined as: where y i1 is a 0/1 indicator at location i, β 0 is the intercept term, x ik is the value of the kth predictor variable at location i, m is the number of predictor varia... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | US election data | The US election data were constructed from two sources. First, voting data for each of the 3,108 mainland counties in the US was downloaded from Tony McGovern's Github site (McGovern 2017) and then linked to county outlines in the maps R package (Becker et... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | US species data | A second US data set was extracted from the ecospat R package (Broennimann et al. 2016 ). The ecospat.testNiche.nat data set covers no specific year and is described as being 'test data for the niche dynamics analysis in the native range of a hypothetical s... |

### Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data

- DOI : `10.1080/13658816.2013.865739`
- TEI : `corpus\papers\tei\Geographicallyweightedregressionwithanon-Euclideandistance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Spatial analysis of the GWR residuals | Figure 5a -c depicts discrepancy maps for the absolute residuals (i.e. the absolute value of the actual PURCHASE price minus the GWR predicted PURCHASE price) from the three GWR models using ED, ND and TT metrics. Here, Figure 5a subtracts the absolute resi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | London house price and hedonic data | As a case study, a house price data set for London, UK, is used to assess and compare GWR models with different distance metrics. This data set is sampled from a house price data set provided by the Nationwide Building Society of the United Kingdom and was... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Investigation of a single model specification | It is unrealistic to delve deeper into all 720 GWR models, one by one. Thus, we choose a representative model to illustrate more specific differences in the GWR fits using ED, ND and TT metrics. As shown in Figure 3 , there is relatively little reduction in... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Global regressions | As with any GWR study, it is important to estimate the parameters of the global regression, so that this benchmark model can be compared to its GWR counterpart. As there is no single agreed functional form in hedonic price modelling (Halvorsen and Pollakows... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | GWR calibrations with ED, ND and TT metrics | We now calibrate the corresponding GWR models to the same 120 OLS regressions, above. Here we apply GWR using ED (the basic fit), ND and TT metrics, using both fixed and adaptive kernel bandwidths, with each bandwidth found optimally via the minimised AIC c... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | International Journal of Geographical Information Science | numerous contributions have been made. For example, different kernel functions have been suggested (e.g. Brunsdon et al. 1996 , Fotheringham et al. 1998 , Yrigoyen et al. 2007 ) and different rules to select an optimum bandwidth have also been proposed (e.g... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Summary of the OLS regression and GWR models | Bandwidth, R-squared and AIC c results for model no. 42, using OLS regression and GWR are given in Table 1 . Observe that the bandwidths for the GWR models using ND and TT metrics are actually relatively similar to each other. Here we need to look again at... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Abs_Res (EDF -NDF) | -14813 to -5000 -5000 to -1000 -1000 to 1000 1000 to 5000 5000 to 40823 24,000 16,000 8000 4000 0 14 B. Lu et al. estimates of our GWR models. Here, discrepancy maps can again be produced by subtracting the coefficient estimates for each hedonic variable (a... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Further observations | Although each GWR model is specified with a different AIC c defined optimal bandwidth, it is argued that the observed differences in goodness-of-fit and the estimated coefficients (at least for FLOORSZ) are fundamentally caused by the distinctive measuremen... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | London road network data | Road network data produced by the UK Ordnance Survey (OS) in 2001 is used to calculate the ND and TT metrics for our GWR models. To get a relatively accurate TT, the road speed limits are used as the average speeds for each road link. The locations of the s... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial analysis of the GWR coefficients | GWR is most commonly used in an exploratory fashion, where the local coefficient estimates are mapped to investigate for any change in data relationships across space. As such, it is important to investigate for relative changes amongst the coefficient |
| low_priority_review | `ModelEvidenceCandidate` | 48 | International Journal of Geographical Information Science | hedonic characteristics are typically divided into locational attributes, structural attributes, neighbourhood attributes and other features (Goodman 1989, Chin and Chau 2003) . Accordingly for our study, the sale price, PURCHASE, the dependent variable, is... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### Geomorphic process rates of landslides along a humidity gradient in the tropical Andes

- DOI : `10.1016/j.geomorph.2011.10.029`
- TEI : `corpus\papers\tei\muenchow2012_lsl_dataset.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Estimation of geomorphic process rates | We calculated geomorphic process rates to assess the contribution of shallow landslides to landscape evolution (Caine, 1976) . Process rates were estimated in the first place as average values of each study area and time period represented, and were later d... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Data and methods |  |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 7 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 8 |

### Geospatial Analysis of Airbnb Data: Understanding Distribution Patterns, User Satisfaction, and Economic Impacts in Major Global Cities

- DOI : `10.31410/ITEMA.2024.131`
- TEI : `corpus\papers\tei\Geospatial analysis on Airbnb data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 53 | DATA AND METHODOLOGY | The study in this section highlights the methodologies used for the analysis of Airbnb listings across multiple cities to uncover the impact of various amenities and other factors on user satisfaction metrics, such as overall ratings and communication ratin... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Regression Analysis | A multiple regression analysis using an Ordinary Least Squares (OLS) model was performed to assess the impact of variables such as the number of bedrooms, bathrooms, maximum guests, and minimum stay on the average daily rate (ADR) in USD. The model identifi... |

### Global Patterns of Taxonomic Uncertainty and its Impacts on Biodiversity Research

- DOI : `10.1093/sysbio/syaf010`
- TEI : `corpus\papers\tei\Global Patterns of Taxonomic Uncertainty and its Impacts on Biodiversity Research.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Taxonomic Data | We followed the taxonomy employed in fully sampled phylogenies available for amphibians (Jetz and Pyron 2018) , turtles and crocodiles (Colston et al. 2020) , squamates (Tonini et al. 2016) , birds (Jetz et al. 2012) , and mammals (Upham, Esselstyn and Jetz... |
| low_priority_review | `DataSourceCandidate` | 45 | Species-Level Covariates | Attributes related to species biology included body size and habitat use. For body size, we used body mass data for birds, mammals, and reptiles, which had on average a data coverage exceeding 95% (n = 24,758 out of 25,811 species), and body length for amph... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Determinants of Synonym Count Variation | We modeled synonym counts per species (crossspecies analyses) and the average number of synonyms (i.e., total number of synonyms divided by the total number of species) per grid cell (assemblage-level analyses) separately for amphibians, reptiles, birds, an... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Assemblage-Level Covariates | For assemblage-level analyses, we modeled the average number of synonyms per grid cell for each taxonomic class separately across three spatial grains (110, 220, and 440 km). As predictors, we used latitude, as well as median values per grid cell for elevat... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |

### Global hotspots of shark interactions with industrial longline fisheries

- DOI : `10.3389/fmars.2022.1062447`
- TEI : `corpus\papers\tei\Burns_2024_GlobalHotspotsSharkLongline.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Model parameters | Fishing effort is known to have at least some influence on catch. We tested three different fishing effort parameters (Supplementary Material, Table S4 ). Publicly available fishing effort data associated with target catch (tuna and tuna-like species; "targ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Identifying hotspots of shark interactions with industrial longline fishing | We built Random Forest (RF) machine learning models to estimate spatially explicit shark catch risk. The RF modeling approach consists of a series of "trees" that are trained independently using a combination of predictor variables and rows of data that are... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 3 |

### Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints

- DOI : `10.1111/geb.13762`
- TEI : `corpus\papers\tei\Global variation in the relationship between avian phylogenetic diversity and functional distance is driven by environmental context and constraints.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | / Assemblage, morphological and phylogenetic data | More than 17,000 bird assemblages were taken directly from Weeks et al. (2022) . These were created from a 110 km x110km grid (roughly 1° latitude and 1° longitude at the equator, Behrmann projection), and excluded all non-terrestrial cells (>50% ocean or >... |

### Graph WaveNet for Deep Spatial-Temporal Graph Modeling

- TEI : `corpus\papers\tei\2026-04-23_paper_graph_wavenet_spatial_temporal_graph_modeling.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Effect of the Self-Adaptive Adjacency Matrix | To verify the effectiveness of our proposed adaptive adjacency matrix, we conduct experiments with Graph WaveNet using five different adjacency matrix configurations. Table 3 shows the average score of MAE, RMSE, and MAPE over 12 prediction horizons. We fin... |
| low_priority_review | `DataSourceCandidate` | 45 | Experimental Results | Table 2 compares the performance of Graph WaveNet and baseline models for 15 minutes, 30 minutes and 60 minutes ahead prediction on METR-LA and PEMS-BAY datasets. Graph WaveNet obtains the superior results on both datasets. It outperforms temporal models in... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |

### Harbour porpoise responses to pile-driving diminish over time

- DOI : `10.1098/rsos.190335`
- TEI : `corpus\papers\tei\Graham2019Harbour.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Management implications | Given the widespread distribution and abundance of harbour porpoises in the North Sea, potential disturbance impacts on protected populations must be considered within consent applications for most, if not all, wind farm developments in this region. Several... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Harbour porpoises were present within the windfarm construction site throughout the construction period in 2017 (figure 5 ). The number of detection positive hours fluctuated during the year but there was no evidence of a negative temporal trend in occurren... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Material and methods | Following the approach used to study responses of harbour porpoises to a seismic airgun survey [14] , we used echolocation detectors and noise recorders to model harbour porpoise detections along a gradient royalsocietypublishing.org/journal/rsos R. Soc. op... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | model estimate s.e. z-value p-value AIC (a) 24-h response log(distance) * piling order þ no. vessel locations_1 km 619.4 (intercept) 0.8352 0.1548 5.397 ,0.001 log(distance):piling order 0.1864 0.0597 3.123 0.002 log(distance) 20.5734 0.0616 29.305 ,0.001 p... |

### Hedonic real estate price estimation with the spatiotemporal geostatistical model

- DOI : `10.1007/s43071-023-00039-w`
- TEI : `corpus\papers\tei\Hedonic_real_estate_price_estimation_with_the_spatiotemporal_geostatistical_mode_W4388671500.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 2 |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Dependent variable: transaction price [ten thousand JPY] (1) (2) (3) No time dummy, No regional dummy No time dummy & No regional dummy No time dummy & With regional dummy With less property-level spatial variable With full property-level spatial variable W... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Dependent variable: Transaction price [ten thousand JPY] OLS Geostatistical SLX SDEM model β β β θ β θ Estimate S.E Estimate S.E Estimate S.E Estimate S.E Estimate S.E Estimate S.E Property characteristics Newly built dummy -0.071 (0.099) 0.066 (0.088) -0.0... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Bayesian kriging and out-of-sample prediction, based on geostatistical models | The geostatistical model is effective in providing a statistically sound model by determining separately the effects of the explanatory variables and spatiotemporal effect. This model is particularly useful in situations where the predictive rationale has b... |

### How do Indigenous and local knowledge systems respond to climate change?

- DOI : `10.5751/ES-12481-260327`
- TEI : `corpus\papers\tei\Popovici2021How.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Climatic variables |

### How to Control for Many Covariates? Reliable Estimators Based on the Propensity Score

- DOI : `10.1093/pan/mpp036`
- TEI : `corpus\papers\tei\huber_lechner_wunsch_2013.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Sample selection and treatment definition | In that we are interested in evaluating typical labour market programmes in a representative industrialized economy we exclude East Germany and Berlin from the analysis since they are still affected by the aftermath of Reunification. We start from a sample... |
| low_priority_review | `DataSourceCandidate` | 45 | Strength of selection and share of treated | The upper panels of those tables contain indicator variables for the magnitude of the selection and the share of the treated (the medium cases being the references). 32 We find that the RMSE increases in the strength of selection and the sources appear to b... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 5 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | .2: Analysis of features of matching estimators by OLS regression: Earnings (sample sizes) Variables (all indicators) IPW Kernel Matching Parametric*) Sample Size 300 1200 4800 300 1200 4800 300 1200 4800 300 1200 4800 Constant 191 96 40 171 82 34 180 103 6... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables (all indicators) IPW Kernel Matching Parametric Sample Size 300 1200 4800 300 1200 4800 300 1200 4800 300 1200 4800 Constant 7.4 3.6 1.5 7.1 3.2 1.3 7.1 3.7 2.0 7.1 4.0 1.3 Features of the data generating process Selection: Random (-1.0) -1.0 (-0.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | General structure of the estimators considered | As discussed by Smith and Todd (2005) , Busso, DiNardo, and McCrary (2009a) and Angrist and Pischke (2009) among many others, all estimators adjusting for covariates can be understood as different methods that weight the observed outcomes using weights, . ˆ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Direct matching | When comparing nearest neighbour matching to the other direct matching estimators we replicate the result frequently found in the literature: although being the least biased for all sample sizes nearest neighbour matching is not competitive in terms of RMSE... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Descriptive statistics | The upper part of Table 3 .1 presents descriptive statistics for the two outcome variables we considered: average monthly earnings over the 3 years after entering unemployment, and an indicator whether there has been some employment in that period. This cho... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Variable Treated Control Standardized Probit estimation difference of selection equation mean std. mean std. in % coef. std. error Employed .63 0.56 .48 0.50 9 - - Earnings in EUR 1193 1041 1115 1152 9 - - Constant term - - - - - -4.90 .22 Age / 10 3.6 3.5... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### How to check a simulation study

- DOI : `10.1093/ije/dyad134`
- TEI : `corpus\papers\tei\white_2024_check_simulation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Example | The scripts simcheck03.do and simcheck03.R generate a single data set of size 100 000 using a particular data-generating mechanism. They include standard descriptive statistics such as a cross-tabulation of D against E, showing that there is an unconditiona... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Example | The scripts simcheck08.do and simcheck08.R explore the estimates data sets produced by simcheck07.do and simcheck07.R. They plot the standard error estimates against the point estimates by method of analysis. Results differ between the packages. In Stata (F... |
| low_priority_review | `DataSourceCandidate` | 48 | (vi) Make it easy to recreate any simulated data set | The estimates data set should include an identifier for the simulated data set alongside every estimate. If we can recreate the simulated data set for any particular identifier, then we can explore method failures and outliers (see points below). There are... |
| low_priority_review | `DataSourceCandidate` | 45 | (viii) Look for outliers | It is important to examine the estimates data set carefully. A useful visual device is a scatter plot of the standard error estimate against the point estimate over all repetitions, separated by the data-generating mechanism and method. This scatter plot ca... |
| low_priority_review | `DataSourceCandidate` | 45 | Example | The scripts simcheck05.do and simcheck05.R recognize that either the imputation step or the model fitting to the imputed data may fail. They therefore detect either of these failures and post missing values to the estimates data set. |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Term Explanation Aspects of a simulation study 1 Aims What question(s) the simulation study addresses Data-generating mechanisms How the simulated data sets are to be generated Estimands The quantity or quantities to be estimated by the analysis of each sim... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Aim To compare multiple imputation with complete case analysis Data-generating methods a Quantitative confounder C is drawn from a standard Normal distribution. Binary exposure E and binary outcome D are drawn from logistic models depending on C (so E does... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Performance measure Data-generating mechanism Full data Complete case analysis Multiple imputation Bias in point estimate (Monte Carlo error < 0.02) MCAR 0.00 -0.01 0.00 MAR -0.02 -0.16 -0.02 MNAR -0.01 -0.03 0.05 Empirical standard error (Monte Carlo error... |

### Identification of a gene associated with avian migratory behaviour

- DOI : `10.1098/rspb.2010.2567`
- TEI : `corpus\papers\tei\Mueller et al 2011, spatial or population model data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 45 | MATERIAL AND METHODS | (a) Samples Thirteen European/African blackcap populations representing the entire range of geographical variation in migration patterns, from Cape Verde to western Russia, have been sampled in the years 1989-1996 (figure 1 ). We also included a sample of b... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

### Impact of COVID-19 on financial returns: a spatial dynamic panel data model with random effects

- DOI : `10.1007/s43071-022-00025-8(`
- TEI : `corpus\papers\tei\Impact_of_COVID_19_on_financial_returns_a_spatial_dynamic_panel_data_model_with__W4294074015.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 52 | Data | The balanced panel dataset consists of weekly financial stock market indexes and the weekly number of deaths in 41 countries, i.e. Australia, Austria, Belgium, Brazil, Canada, Chile, China, Colombia, Denmark, Egypt, Finland, France, Germany, Hungary, India,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Empirical evidence | In Table 1 we report the main regression results. First, focusing on the returns, the significance and impact of the coefficients seem to be similar in the specifications SEM2SRRE, SEMSRRE, and SEMSR, while some difference emerges for the model with only th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Model specification | We specify a spatial-temporal model aimed at describing the impact of the number of deaths due to Covid-19 to financial markets returns. We denote by I i;t the equity market index of the country i on the last open market day of the week t. Then, the equity... |

### Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and Eigenvector Spatial Filtering Features

- DOI : `10.3390/ijgi11040242`
- TEI : `corpus\papers\tei\Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and Eigenvector Spatial Filtering Features.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Performance Evaluation | To retrieve a more objective performance evaluation of our approach, we adopted the idea of nested cross-validation (CV). The fundamental idea of CV is to separate the dataset into different parts: training and testing. This ensures that the information of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Geographically Weighted Regression | To benchmark our proposed modelling approach, we use both a traditional "a-spatial" RF and a classical spatial statistical model, namely a Geographically Weighted Regression (GWR). GWR has been successfully used to model various geospatial application domai... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Importance of Explanatory Variables | In this section, we look at the influence that each explanatory variable (i.e., features) has on the tested models (Table 4 ). For the RF models, the relative feature importance of the final model is extracted. Relative feature importance is obtained by sca... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Meuse Models Non-Spatial | Spatial Lag ESF GWR Regarding the California models, the results are quite different. First, spatial features are largely predominant in the spatial lag and ESF models, which indicates that spatial autocorrelation is important for the house-price models. Se... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | 4. | For each hyper-parameter candidate, average the assessment metric values across L folds and choose the best hyper-parameter. In our experiments, the hyperparameter that was tested was m try . 5. Calculate spatial features on the outer-train. 6. Perform cros... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Data Sources | Two public spatial datasets with different properties are used in this study to test the usability of the proposed modelling. usually the main focus of this dataset. Flooding frequency and distance to the river can be considered as covariates in regression... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Meuse River Dataset | Meuse is a classical spatial dataset in geostatistics that consists of samples collected in a flood plain of the river Meuse in the Netherlands. Hengl et al. [22] used Meuse dataset for one of the experiments where distance-based spatial features were intro... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Random Forest | Random forest (RF) is used in this study for its general accuracy and successful applications in diverse geoscientific problems [28, 35, 49] . RF has also been used as a framework recently to integrate distance variables in spatial prediction [22] . During... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | California Housing Dataset | This dataset contains 20,640 observations of California housing prices based on 1990 California census data. Each row represents a census block group or district (the smallest geographical unit for which the U.S. Census Bureau publishes sample data). It was... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | California Housing Dataset | This dataset contains 20,640 observations of California housing prices based on 1990 California census data. Each row represents a census block group or district (the smallest geographical unit for which the U.S. Census Bureau publishes sample data). It was... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Eigenvector spatial filtering (ESF) is a regression technique proposed by Getis and | Griffith [43] to enhance the model results in the presence of spatial dependence. This idea is originated from Moran's I, in which the spatial weight matrix is used to capture the spatial covariations. ESF decomposition is conducted on the matrix where I is... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Section 4.1 describes the specification of the models, such as which spatial features were constructed and selected for the models as well as the values of the optimized parameters. In Section 4.2, we analyze the impact of the explanatory variables and how... |
| low_priority_review | `truncated` |  |  | 9 autres candidats non affiches dans ce rapport |

### Incorporating spatial and genetic competition into breeding pipelines with the R package gencomp

- DOI : `10.1038/s41437-024-00743-9`
- TEI : `corpus\papers\tei\agridat_connolly.potato - Incorporating spatial and genetic competition into breeding pipelines with the R package gencomp.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 53 | First step: competition matrix | Following the logic presented in the "Methods" section, the first step is to build the competition matrix. For this, gencomp has two functions: prepfor and prepcrop. The former is designed to deal with tree breeding trials, and the latter, with crop breedin... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Third step: main results | The resp function provides a list of the most relevant outputs: (i) results of the likelihood ratio tests (if lrtest = TRUE in asr or asr_ma), (ii) variance components, (iii) heritabilities of the DGE and the total genotypic effects (if cor = TRUE in asr or... |

### Induced earthquakes and house prices: the role of spatiotemporal and global effects

- DOI : `10.1007/s10109-022-00403-8`
- TEI : `corpus\papers\tei\Induced_earthquakes_and_house_prices_the_role_of_spatiotemporal_and_global_effec_W4318962811.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | 3 | Induced earthquakes and house prices: the role of spatiotemporal… identify the cumulative effects of these increasingly frequent and stronger earthquakes using a seismological model specifically developed to measure the seismic activity in the region. This... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | Econometric specification | The hedonic equation adopted in this paper to determine the impact of earthquakes on housing prices reads as: where p i denotes the log transaction price of house i per square meter of living space. 5 The spatiotemporal lag ∑ i-1 j=N-N F w ij p j with coeff... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Results | Table 1 reports the results of eleven initial models in which total PGV is taken up as one single measure to further explain the decision to adopt the econometric model set out in Equ. (6) from an empirical viewpoint. The first row reports the coefficient a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | 3 | Induced earthquakes and house prices: the role of spatiotemporal… The spatial lag of the dependent variable measuring house prices captures the extent to which the price of a house is affected by the price of houses surrounding it. This lag is motivated by... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | From short-term direct to long-term total effects | Direct interpretation of Equ. (6), after it has been estimated, is difficult because its coefficients do not represent marginal effects of the explanatory variables. The latter can be obtained by taking partial derivatives of the reduced form of the model i... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |

### Integrated species distribution models fitted in INLA are sensitive to mesh parameterisation

- DOI : `10.1111/ecog.06391`
- TEI : `corpus\papers\tei\Integrated species distribution models fitted in INLA are sensitive to mesh parameterisation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Modelling | The R code for data preparation and model fitting was based on the R-package ( www.r-project.org ) 'PointedSDMs' ver. 0.2.1.9004 ( https://github.com/oharar/PointedSDMs ), which is built on the widely used 'R-INLA' package (Lindgren and Rue 2015) . It was i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data and covariates | We used two sources of E. serotinus data for our study (Fig. 1 ), the first from the field survey that is part of the National Bat Monitoring Programme (NBMP) of the UK's Bat Conservation Trust (BCT). The field survey consists of a structured mobile acousti... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | How do the covariate effects differ between models? | The empirical semi-variograms for each covariate showed evidence for spatial autocorrelation in temperature, arable, and grassland. Semi-variance for these variables increased with increasing distance, but was comparatively stable for broadleaf (Supporting... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model evaluation and comparison | To investigate the effect of mesh density on overall inference, we compared the spatial predictions of each model by mapping the mean as well as the SD of the estimated intensity on a regular grid with a 5 km resolution. Next, we focused on the individual m... |

### Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions

- DOI : `10.1111/geb.13792`
- TEI : `corpus\papers\tei\Global Ecology and Biogeography - 2023 - Mäkinen - Integrated species distribution models to account for sampling biases.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | / Model validation | We validated models with fourfold block-wise cross-validation on the PA data set, and the PO data set was used only for model training. In cross-validation, folds were formed by splitting the PA sites into 20 spatially distinct blocks and grouping blocks in... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | / Model validation | We validated models with fourfold block-wise cross-validation on the PA data set, and the PO data set was used only for model training. In cross-validation, folds were formed by splitting the PA sites into 20 spatially distinct blocks and grouping blocks in... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / DISCUSS ION | We tested integration of the opportunistically sampled PO data and the species checklist-based PA data for fitting integrated SDMs for 71 hummingbird species on the extent of the species' whole ranges. Of the different integration methods (tested, e.g. in A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / DISCUSS ION | We tested integration of the opportunistically sampled PO data and the species checklist-based PA data for fitting integrated SDMs for 71 hummingbird species on the extent of the species' whole ranges. Of the different integration methods (tested, e.g. in A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Effect | First order S econd order EVI measured with the Moran's I, and thus the changes in the covariate effect estimates were not associated with the spatial structure of the covariates. See Table S1 .6 in Appendix 1 for a table of Moran's I of each covariate rast... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Effect | First order S econd order EVI measured with the Moran's I, and thus the changes in the covariate effect estimates were not associated with the spatial structure of the covariates. See Table S1 .6 in Appendix 1 for a table of Moran's I of each covariate rast... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Model comparison | Our results show that integrated SDMs can help address limited amounts of the occurrence data but the improvements are conditional on accounting for different biases of the data sets, such as the sampling bias of the PO data, as can be expected based on pre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Model comparison | Our results show that integrated SDMs can help address limited amounts of the occurrence data but the improvements are conditional on accounting for different biases of the data sets, such as the sampling bias of the PO data, as can be expected based on pre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Data sets | We obtained PO, PA and expert range map data for 71 hummingbird species from a previous data integration study (Ellis-Soto et al., 2021) . Their data were accessible through the Map of Life ( mol . org ): PO observations are originally from GBIF ( https://... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Data sets | We obtained PO, PA and expert range map data for 71 hummingbird species from a previous data integration study (Ellis-Soto et al., 2021) . Their data were accessible through the Map of Life ( mol . org ): PO observations are originally from GBIF ( https://... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | / INTRODUC TI ON | Information about species distributions is widely used for assessing species vulnerability to climate and land use change (Dawson et al., 2011; Jetz et al., 2007) , and for optimizing species conservation efforts (Hannah et al., 2020; Jetz et al., 2022; Jun... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | / INTRODUC TI ON | Information about species distributions is widely used for assessing species vulnerability to climate and land use change (Dawson et al., 2011; Jetz et al., 2007) , and for optimizing species conservation efforts (Hannah et al., 2020; Jetz et al., 2022; Jun... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Is environment destiny? Spatial analysis of the relationship between geographic factors and obesity in Türkiye

- DOI : `10.1080/09603123.2023.2248016`
- TEI : `corpus\papers\tei\Ylmaz2023Environment.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Coefficient (B) Std. Error t-Statistic VIF Intercept 48.685 7.301 6.662 - Precipitation -0.022 0.030 -0.731 1.135 Slope 36.564 8.744 4.181 1.110 Air pollution -0.066 0.051 -1.307 1.220 Elevation -0.005 0.001 -4.194 1.212 R-Squared 0.679 Adjusted R... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Results | Results from the OLS regression model are summarized in Table 1 . Adjusted R 2 value of 0.618 indicates that the four predictor variables explained nearly 60% of total variance in the regional level adult obesity prevalence. There was no multicollinearity i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | OLS | OLS is a regression analysis method that is used to represent a dependent variable's dependence on one or more independent variables. The regression line or curve is calculated using this method by reducing the variance in the data. To put it another way, O... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | GWR | The GWR is a modification of the OLS regression model. In order to represent the relationships between these characteristics and a dependent outcome of local interest, GWR is a regression model technique for spatial analysis that takes non-stationary estima... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Statistical analyses | The estimate and analytical handling of various spatial effects, such as spatial dependency, spatial autocorrelation, and spatial heterogeneity, require the application of a spatial regression model. When variables are locally fluctuating, spatially depende... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Obesity prevalence | The adult obesity prevalence data were obtained from Türkiye Nutrition and Health Survey-2010. In this epidemiological study, data from a total of 6183 individuals (2418 men, 3765 women) aged 19-64 years were evaluated. The obesity prevalence of the partici... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Precipitation | Precipitation data were obtained from the database of the General Directorate of Meteorology under the Turkish Ministry of Environment, Urbanisation and Climate Change. The climate data of the provinces in TR between 1927 and 2022 are included in the databa... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Strengths and limitations | The strengths of this study are that (1) it is the first to investigate the relationship between the geographical characteristics of the Türkiye's regions and the prevalence of obesity, (2) the data were obtained from reliable sources and objectively, (3) t... |

### Italexit, is it another Brexit?

- DOI : `10.1007/s10109-019-00307-0`
- TEI : `corpus\papers\tei\Italexit_is_it_another_Brexit_W2963814876.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Consider a data-generating process | This is based on a Toeplitz matrix d ij , ∀i, j, of dimension N = 20, where d ij denotes the distance between regions i and j , and w N,ij = d -2 ij with zeros on the main diagonal and subsequently row normalized, giving N . Hence, is an N-by-1 vector drawn... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Estimates | In Table 1 , because the parameter estimates are based on differences, no estimate of the constant c is provided. This estimate is subsequently constructed as the difference between observed time mean ln e and the expected time mean ln ê given by Table 1 es... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | 3 | Italexit, is it another Brexit? by time-varying matrix 5 t .Although the system may still tend towards equilibrium, equilibrium will be continuously disturbed and new equilibrium levels established as t varies. Secondly, ln t may also depend on unobserved e... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | connectivity. In subsequent model estimates, parameter interpretation is aided by normalizing by dividing * N by its maximum eigenvalue, to give 4 N . Accordingly, the maximum eigenvalue of N is one, and the continuous range for which Given Eq. ( 2 ), multi... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Parameter Estimates Standard error 0.6525 0.003769 1 0.5353 0.01045 1 0.1272 0.002116 2 0.02636 0.0006568 -0.40060 0.008868 2 -0.79750 2 0.0753 2 0.0003 |

### Joint variable selection of both fixed and random effects for Gaussian process-based spatially varying coefficient models

- DOI : `10.1080/13658816.2022.2097684`
- TEI : `corpus\papers\tei\Dambon_2022_SVC_variable_selection_IJGIS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Description Summary statistics [in %] Variable Percentage of population in each ED … Min. Mean SD Max. DiffAdd … who are one-year migrants 1.90 9.86 6.13 34.74 LARent … who are local authority renters 0.00 15.17 24.69 100.00 SC1 … who are social class one (... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Data | As an application, we consider the Dublin Voter data set. It consists of the voter turnout in the 2002 General Elections and 8 other demographic covariates for n ¼ 322 electoral divisions in the Greater Dublin area (Ireland), see Figure 3 . All nine variabl... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Cross-validation | In the last section we examined the goodness of fit combined with model complexity as well as parameter estimation. We now turn to predictive performance. Here, we expect that due to high degree of flexibility of full SVC models, methods without any kind of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | GP-based SVC models | Let n be the number of observations, let p be the number of covariates x ðjÞ 2 R n , j ¼ 1, . . . , p, for a fixed effect, and let q be the number of covariates w ðkÞ 2 R n , k ¼ 1, . . . , q, with random coefficients, i.e., SVCs. The fixed and random effec... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Models and methodologies | We use two models in our comparison. The first one is a simple linear model where we apply the adaptive LASSO for variable selection. Since we use the standardized covariate Z:GenEl2004 as our response, we do not expect an intercept in the model. The coeffi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | A.4. Coordinate descent iterations | We briefly discuss the coordinate descent in PMLE from Sections 5.2 and 5.3. For the two covariates Z.DiffAdd and Z.SC1, we give the covariance parameters for respective SVCs at individual steps t in the coordinate descent in Figure A2 . We have chosen thes... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | RMSE |

### Journal of Statistical Software

- DOI : `10.18637/jss.v077.i11`
- TEI : `corpus\papers\tei\surveillance_measles.weser - Spatio-Temporal Analysis of Epidemic Phenomena Using the R Package surveillance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Data handling and visualization | The generated 'epidataCS' object imdepi is a simple list of the checked ingredients events, stgrid, W and qmatrix. Several methods for data handling and visualization are available for such objects as listed in Table 2 and briefly presented in the remainder... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Basic example | To illustrate statistical inference with twinstim, we will estimate several models for the simplified and "untied" IMD data presented in Section 3.2. In the endemic component, we include the district-specific population density as a multiplicative offset, a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Covariates | The hhh4 model framework allows for covariate effects on the endemic or epidemic contributions to disease incidence. Covariates may vary over both regions and time and thus obey the same T × I matrix structure as the observed counts. For infectious disease... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data ingredients | The core events data must be provided in the form of a 'SpatialPointsDataFrame' as defined by the package sp (Bivand et al. 2013 ): R> summary(events) Object of class SpatialPointsDataFrame Coordinates: min max x 4039 4665 y 2710 3525 Is projected: TRUE pro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Modeling and inference | Having prepared the data as an object of class 'epidataCS', the function twinstim can be used to perform likelihood inference for conditional intensity models of the form (2). The main arguments for twinstim are the formulae of the endemic and epidemic line... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Random effects | Paul and Held (2011) introduced random effects for 'hhh4' models, which are useful if the districts exhibit heterogeneous incidence levels not explained by observed covariates, and especially if the number of districts is large. For infectious disease surve... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Special cases: Single-component models | If the epidemic component is omitted in Equation 2, the point process model becomes equivalent to a Poisson regression model for aggregated counts. This provides a link to ecological regression approaches in general (Waller and Gotway 2004) and to the count... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Modeling and inference | For multivariate surveillance time series of counts such as the measlesWeserEms data, the function hhh4 fits models of the form (10) via (penalized) maximum likelihood. We start by modeling the measles counts in the Weser-Ems region by a slightly simplified... |

### Journal of the American Statistical Association

- DOI : `10.1198/016214502760047140`
- TEI : `corpus\papers\tei\gotway_young_2002_spatial_support.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Cokriging | Multivariate spatial prediction, or cokriging, was developed to improve the prediction of an "undersampled" spatial variable by exploiting its spatial correlation with a related spatial variable that is more easily and extensively measured. Consider predict... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | We observe But the nature of or analyze the process is Examples Point Point Point kriging; prediction of undersampled variables Area Point Ecological inference; quadrat counts Point Line Contouring Point Area Use of areal centroids; spatial smoothing; block... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 65 | Areal Regression Models | Flowerdew and Green (1989, 1992, 1994 ) used explanatory variables collected on the target units to improve estimates from areal interpolation. Consider the simple example given by Flowerdew and Green (1989) in which the variable of interest is a count vari... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 65 | Bayesian Areal Regression Models | Mugglin and Carlin (1998) extended the work of Flowerdew and Green using a Bayesian approach to areal interpolation. They initially considered the case in which an outcome variable of interest, Y , was measured on i D 11 2 regions (the source units) and pre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 61 | Spatial Smoothing Methods | With these methods, a smooth surface is tted to data for the source units and used to interpolate values at the nodes of a ne grid. The interpolated values are then summed or averaged over the target units to obtain areal estimates for these units. Let Z4A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Block Kriging | Consider the process 8Z4s5 2 s 2 D < d 9, where Z4s5 represents the value of the random variable at a known location s and s varies continuously over a spatial domain D. Assume that Z4s5 has mean OE4s5 and covariance function cov4Z4u51 Z4v55 D C4u1 v5 for u... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | C4u1 v5 du dv=-B--A i -0 | Because data on any support can be built from data with point support, these relationships can be used for both the case where -A i -< -B-(aggregation) and the case where -B-< -A i -(disaggregation). However, unlike in the previous case, where we observed p... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | The General Change of Support Problem | The different types of spatial data (point, line, area, surface), occurring naturally or as a result of the measurement process, potentially allow many ways of integrating these different types of spatial data. Arbia (1989) uses the term spatial data transf... |

### LamaH-CE: LArge-SaMple DAta for Hydrology and Environmental Sciences for Central Europe

- DOI : `10.5281/zenodo.4525244`
- TEI : `corpus\papers\tei\klingler_2021_lamah.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Meteorological data | Given the extent of the ECMWF (European Centre for Medium-Range Weather Forecasts) ERA5-Land dataset with global coverage (Muñoz Sabater et al., 2021) , it was possible to obtain gap-free time series with daily and hourly resolutions for 15 meteorological v... |

### Large-scale recovery of an endangered amphibian despite ongoing exposure to multiple stressors

- TEI : `corpus\papers\tei\Large_scale_recovery_of_an_endangered_amphibian_despite_ongoing_exposure_to_mult_W2529413741.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Materials and Methods | Frog Surveys. Surveys targeted all lentic water bodies in Yosemite as shown on US Geological Survey 7.5′ topographic maps. Counts of R. sierrae life stages (adults, juveniles, and tadpoles) were made during diurnal visual encounter surveys of the entire wat... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

### Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial

- DOI : `10.1111/ecog.01243`
- TEI : `corpus\papers\tei\Lean-season primary productivity and heat dissipation as key drivers of geographic body-size variation in a widespread marsupial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Hypothesis Mechanism Predicted pattern Reference Environmental variables Heat conservation Reduced surface to volume ratios Body size decreases with Bergmann (1847) Mean winter/annual of larger individuals increases temperature minimum heat conservation in... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Environmental variables and covariate extraction | Gridded environmental covariates for Australia were sourced or derived from datasets obtained from the Australian Bureau of Meteorology (BoM) (2010; Ͻ www.bom.gov.au Ͼ ) and the British Atmospheric Data Centre (BADC) (2008; Ͻ www.badc.nerc.ac.uk Ͼ ) as well... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Model fi tting and selection | To test the ability of proposed drivers to explain geographic body size variation in T. vulpecula , both individually and in combination, we fi t aspatial regression models (i.e. linear models that do not account for spatial dependence) and spatial simultan... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Mono-causal environmental predictors of body size | Aspatial regression models demonstrated that T. vulpecula body size decreases with increasing temperature and increases with indices of primary productivity (Fig. 2b -d ), which is consistent with hypotheses based on thermoregulatory responses and food avai... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | 4-EV | Wet-bulb temperature is the lowest temperature that can be reached under current ambient conditions by the evaporation of water only. Overheating should also be a more critical problem during warmer periods than during cooler periods and so we assessed mean... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Geographical variation in possum body size | Trichosurus vulpecula specimens from the coastal habitats of southeastern Australia are markedly larger than those of the remainder of the continent (Fig. 1 ). However, T. vulpecula body-size variation does conform to Bergmann ' s rule and increases with la... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Multi-causal models for possum body size | Our multi-causal models similarly supported the heat dissipation and primary productivity hypotheses (Table 2 ). For both the aspatial and spatial SAR analyses, the top AICc-ranked multi-causal model was of the form CBL ϭ SummerMaxTemp ϩ MinSeasP -PET ϩ Isl... |

### Learning from wildfires: A scalable framework to evaluate treatment effects on burn severity

- DOI : `10.1002/ecs2.70073`
- TEI : `corpus\papers\tei\Chamberlain2024Learning.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Treatments and past wildfires | We acquired treatment history data from the Forest Activity Tracker System (FACTS) database for all FS lands. For Schneider Springs, we also acquired treatment history layers from the DNR, and for Bootleg, we acquired additional treatment history layers fro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Bootleg Fire | For the Bootleg Fire, final RF models explained 53.3% of the variation in burn severity, as measured by continuous RdNBR, with a final model RMSE of 208. Top predictors of burn severity for the Bootleg Fire represented a range of fire weather, bioclimatic,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Study areas | We applied our framework to evaluate drivers of burn severity and treatment effectiveness within the Bootleg Fire in south-central Oregon and the Schneider Springs Fire in central Washington (Figure 2 ). Across both fires, a variety of mechanical thinning a... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Burn severity mapping | We used the Landsat-derived relative differenced normalized burn ratio (RdNBR) (Miller & Thode, 2007) to quantify burn severity within the Bootleg and Schneider Springs Fires. We used Google Earth Engine code described in Parks, Holsinger, Voss, et al. (201... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Modeling drivers of burn severity using machine learning | We evaluated the influence of all continuous predictor variables on burn severity using a RF regression modeling approach (i.e., machine learning). The purpose of this analysis was to identify top drivers of burn severity that could then be accounted for wh... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Modeling treatment effectiveness using spatial regression | We used SAR models to statistically evaluate treatment effectiveness while holding top bioclimatic, fire weather, and topographic factors constant. For SAR analyses, we sampled all treatment and control polygons within each fire, with sample points centered... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Schneider Springs Fire | For the Schneider Springs Fire, final RF models explained 57.0% of the variation in burn severity, as measured by continuous RdNBR, with a final model RMSE of 231. Schneider Springs exhibited multiple important predictors of burn severity across the fire (F... |

### Leveraging principal component analysis to uncover urban pedestrian dynamics

- DOI : `10.1007/s10109-025-00469-0`
- TEI : `corpus\papers\tei\Leveraging_principal_component_analysis_to_uncover_urban_pedestrian_dynamics_W4411182749.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data preparation | To prepare the data for PCA, we reshape the raw hourly counts into two alternative structures for daily and weekly analysis. In the reformatted datasets, each row corresponds to a single sensor-day or sensor-week observation, represented as a 24-column or 1... |

### LightGBM: A Highly Efficient Gradient Boosting Decision Tree

- TEI : `corpus\papers\tei\2026-04-23_paper_lightgbm_gradient_boosting_decision_tree.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |

### Local niche differences predict genotype associations in sister taxa of desert tortoise

- DOI : `10.1111/ddi.12927`
- TEI : `corpus\papers\tei\Inman2019Local.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | / In support of phylogenetic boundaries: Local species-environment relationships | We found evidence for two, but not three, multivariate clusters in the local regression coefficient maps. A third category, if coinciding F I G U R E 5 Two multivariate clusters of habitat selection identified from local regression coefficient maps of speci... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | / Local niche models and spatial scale | In order to further investigate differences in species-environment relationships between G. agassizii and G. morafkai, we calibrated local species-environment relationships within our focal study area around the secondary contact zone to estimate local vari... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Habitat-genotype association | We hypothesized that landscape patterns in the interpolated MGWR coefficient maps (representing spatially varying species-environment relationships) would be congruent with previously reported phylogenetic differences found in the secondary contact zone ide... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Modelling overview | We developed a two-step modelling approach drawing on the strengths of both SDM and MGWR (Figure 2 ) to explore spatial In step 1, we use SDM to develop range-wide ecological niche models for each species separately and test hypotheses of niche equivalency.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Niche comparisons | We hypothesized that the niches of the two species would show similarities due to relatedness and niche conservation, but that differences would also be apparent due to geographic isolation over the past 6 million years. We therefore compared their niches u... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Species distribution modelling | We used MaxEnt v. 3.4.0 (Phillips, Dudik, & Schapire, 2018) to create distribution models for each species separately and for a combined portions of the two species' known ranges were compiled from Nussear et al. (2009) and augmented with additional observa... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | / A novel coupled modelling approach | The use of local regression to explore spatial variation in species-environment relationships is not new to SDM but has been difficult to apply given the widespread reliance on binary (presence-absence or presence-background) calibration data necessitating... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | / Habitat-genotype association | Kendall's tau values representing the degree to which local regression coefficient maps from MGWR were correlated with our genotype association index, ranged from -0.43 to 0.40 (Table 4 ) and indicated a modest overall agreement between any given species-en... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / INTRODUC TI ON | The relationships between the distributions of species and their ecological properties have long been central to biogeographic inquiry (Grinnell, 1917; MacArthur, 1972) . More recently, quantitative methods to define ecological niches have become essential... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Local niche models and spatial scale | The reduced set of nine principal components identified to investigate spatial patterns in local species-environment relationships included the 1st and 3rd components of the physiographic PCA (PHYS), the 1st and 3rd components of the climate PCA (CLIM), the... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | TA B L E 3 | Pearson's correlation coefficient between speciesenvironment relationships for Gopherus agassizii and Gopherus morafkai ecological niche models for each explanatory variable (see Table 1 for descriptions) 0 to 0.999 (Figure 4 ). The approximate spatial scal... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Niche comparisons | Relative contributions of explanatory variables were not correlated between species (ρ = 0.432, p = 0.286; Table 2 ). For example, the explanatory variable Ppt_dry contributed the most (40.5%) for G. agassizii, but for G. morafkai, Ppt_CV provided the great... |

### Localized Hotspots Drive Continental Geography of Abnormal Amphibians on U.S. Wildlife Refuges

- DOI : `10.1371/journal.pone.0077467`
- TEI : `corpus\papers\tei\Localized_Hotspots_Drive_Continental_Geography_of_Abnormal_Amphibians_on_U_S_Wil_W1996549386.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Description of the data set | Total amphibians examined in the field: The field data were organized by collection, where a collection is a sampling of one or more individuals of a species of amphibian at a site. Altogether we conducted a total 1,477 collections including 68,359 individu... |
| low_priority_review | `DataSourceCandidate` | 45 | Overview of patterns of abnormality occurrence | Amphibians with skeletal and eye abnormalities occurred infrequently on USFWS Refuge lands, based on our analysis of 48,081 amphibians representing 32 species of frogs and toads and 462 wetland sites (core dataset, Methods). One-third of the 675 collection... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Spatially implicit hierarchical modeling | We used Generalized Linear Mixed Effects Regression (GLMM) models in R ( [67] , library lme4) to estimate a mean national abnormality frequency and to compare species, time, and space as predictors of collection level abnormality prevalence (Text S1). Our m... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Power law analysis | We used the binomial form of Taylor's Power Law [39] to test for aggregation in our data set (Text S1). This analysis tests the strength of a linear regression relationship between the calculated site-level variance and the variance predicted from randomly... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Temporal and species variation in abnormality frequencies | We found no evidence of synchronous, year-to-year variation or consistent differences in abnormality prevalence among amphibian species (Figure 3 , Tables 1 and S5 , and Text S1), although asynchronous variation in abnormalities through time clearly occurre... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Fixed Effects DF AIC Δ AIC Region 9 1386 0 Refuge 133 1387 1 Year+Region 18 1393 7 Region+Species 26 1403 17 Size+Region+Species 27 1404 18 Year+Region+Species 35 1410 24 Site 463 1426 40 None 2 1429 42 Species 19 1435 48 Year 11 1437 51 |

### Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America

- DOI : `10.1016/j.oneear.2020.02.007`
- TEI : `corpus\papers\tei\Macchi_2020_LongTermCropRotationDiversification_oneear.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 54 | Data Processing | Data from the first full rotation cycle of each experiment were removed so that only effects of ''established'' rotations are considered (n = 10,424). Maize yield data were then linearly detrended for each site separately. For the analysis of changes in yie... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Effects of Crop-Rotational Diversity on the Productivity and Resilience of Maize Yields | Results from two multilevel regression models show that maize yields are predicted by rotational complexity index (RCI). Detrended maize yield is predicted by RCI (A) and RCI interacted across gradient of environmental conditions (environmental index [EI])... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

### Lower bumblebee colony reproductive success in agricultural compared with urban environments

- DOI : `10.1098/rspb.2018.0807`
- TEI : `corpus\papers\tei\Samuelson2018Lower.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | (f ) Statistical analysis | For each analysis, we built a comparison set of models including the full model (for predictors; see below) and all subsets, including the basic model containing only the constant and residual variance (all-subset approach). We selected the model or set of... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Material and methods (a) Bumblebee colonies | We collected 176 foraging Bombus terrestris audax queens in Windsor Great Park, Surrey, UK during March and April 2016. Queens were chilled and transported to the lab where they were immediately screened microscopically for the endoparasites Nosema spp., Ap... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | (e) Land-use classification | Following best practice in the field [31, 32] , we classified land use at multiple radii surrounding each site using GIS analysis, based on satellite imagery with additional ground-truthing for agricultural sites. Agricultural sites were surveyed because ma... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Results | Land-use category strongly predicted the number of live sexual offspring (gynes and males) produced over the colony life cycle (figure 2a ; electronic supplementary material, table S1a ). Village colonies were significantly more likely to produce sexual off... |

### MOSTLY HARMLESS SIMULATIONS? USING MONTE CARLO STUDIES FOR ESTIMATOR SELECTION *

- TEI : `corpus\papers\tei\advani_kitagawa_sloczynski_2019.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Application | To demonstrate the empirical relevance of the theoretical results discussed above, and consider the extent to which they might be a problem in practice, we provide an application of EMCS procedures to a real-world dataset. In these data we have an experimen... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | C Empirical Application: Structured EMCS Procedure | Here we detail precisely the procedure followed to implement the structured EMCS in our empirical application. As noted previously, we begin each structured EMCS replication by generating a fixed number of treated and nontreated observations to match the nu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Procedures | In Section 2 we noted that for the placebo design we require some choice of π and λ, where λ determines the degree of covariate overlap between the 'placebo treated' and 'placebo control' observations and π determines the proportion of the 'placebo treated'... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | The Structured Design | The idea of the structured design is instead to create a parameterised approximation to the original (unknown) data generating process, and then draw samples from the approximated process. To begin, a fixed number of treated and control observations are cre... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Estimators | In all our simulations we study the impact of the NSW programme on earnings in 1978. We consider seven nonexperimental estimators: linear regression, Oaxaca-Blinder, inverse probability weighting (IPW), doubly-robust regression, uniform kernel matching, nea... |

### MWPCR: Multiscale Weighted Principal Component Regression for High-dimensional Prediction

- TEI : `corpus\papers\tei\Zhu2017Mwpcr.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | ADNI PET Data | Alzheimer's disease (AD) is the most common form of dementia and results in the loss of memory, thinking and language skills. AD is an escalating national epidemic and a genetically complex, progressive, and fatal neurodegenetive disease. The incidence of A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model Setup | The proposed MWPCR consists of two components: a low-rank model for multi-scale weighted PCA (MWPCA) and a prediction model. Let Q (ℓ) be a p × p weight matrix at the ℓ-th scale for ℓ = 1, . . . , L. The low-rank model for MWPCA can be written as for ℓ = 1,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | ADAS-Cog Score Prediction | The second goal is to use MWPCR to identify FDG-PET imaging biomarkers observed at baseline to accurately predict the change in the ADAS-Cog test score (or TOTAL 11 ) at least two years later after initial assessment. The TOTAL 11 , which measures the cogni... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data Structure | Consider data from n independent subjects. For each subject, we observe a q y × 1 vector of discrete or continuous responses, denoted by y i = (y i,1 , . . . , y i,q y ) T , a q z × 1 vector of discrete and/or continuous clinical covariates, denoted by z i... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Binary Classification | The first goal is to use MWPCR to classify subjects from ADNI to either AD or NC group based on their FDG-PET images. It is associated with the second primary objective of ADNI aiming at developing new diagnostic methods for AD intervention, prevention, and... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Importance Score Weights | As discussed in Section 2.3, at each location g, w I,g is calculated based on a statistical model between (x g , z) and y in order to perform feature selection according to each feature's discriminative importance. Statistically, most existing methods (Bair... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |

### Macaque Monkeys Perceive the Flash Lag Illusion

- DOI : `10.1371/journal.pone.0058788`
- TEI : `corpus\papers\tei\Macaque Monkeys Perceive the Flash Lag Illusion.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Data analysis | Data analysis was done in MATLAB using custom-written code. We fitted psychometric functions to the subjects' probability of reporting that the moving bar was located ahead of the flashed bar at different veridical spatial offsets, using the psignifit3 tool... |

### Machine Learning Estimation of Heterogeneous Causal Effects: Empirical Monte Carlo Evidence

- DOI : `10.1111/0034-6527.00321`
- TEI : `corpus\papers\tei\knaus_lechner_strittmatter_emcs.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | 1000 observations 4000 observations M SE /Bias/ SD JB M SE /Bias/ SD JB ITE0 with selection and without random noise Random Forest: Infeasible No variation in dependent variable Conditional mean regression 3.69 0.62 1.78 6% 2.79 1.33 1.49 4% MOM IPW 10.52 2... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | A.2 Descriptive statistics | This Appendix provides descriptive statistics of the dataset that is used to build the EMCS. Table A .1 shows the mean and the standard deviation of the outcome, the estimated propensity score, and the variables that are used to estimate the propensity scor... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Specification of ITE | We are not able to observe the ITEs or any of its aggregates in a real world dataset. Therefore, we either need to estimate or to specify them. We choose the latter because estimation might favor similar estimators under investigation. Thus, our goal is to... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | C Implementation | This Appendix provides a brief description of the implementation steps of the compared estimators. 31 Before, Figure C .1 provides a graphical summary how different parameters enter the estimation as either the only inputs, as necessary, or as optional nuis... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Random Forest | The building block of Random Forests for conditional mean estimation are regression trees (Breiman et al., 1984) . Regression trees recursively partition the sample along covariates to minimize MSE of the outcome. This leads to the tree structure and the me... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | B.2 Description of ITEs | This Appendix complements the basic statistics of the baseline DGP provided in Table 4 in the main text. is therefore favorable for most unemployed. However, we build in one feature that is often observed in applications, namely 'cream-skimming' (see, e.g.,... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Cross-fitting | Some approaches require the estimation of the nuisance parameters in a first step. We follow Chernozhukov et al. (2018) and apply cross-fitting to remove bias due to overfitting that is induced if nuisance and main parameters are estimated using the same ob... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | D.4 Computation time | This appendix shows the average computation times (in seconds) of the different estimation approaches. We computed all our results on a SWITCHengines cloud with 8 cores and 8GB RAM. It is difficult to compare the computation times between Random Forests and... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Mapping sea bird densities over the North Sea: spatially aggregated estimates and temporal changes

- DOI : `10.1002/env.723`
- TEI : `corpus\papers\tei\Pebesma_Duin_Burrough_2005_fulmar_Environmetrics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | SPATIALLY AGGREGATED ESTIMATES | The high resolution maps of Figure 6 show a wealth of spatial patterns. The corresponding standard errors (Figure 7 ) are fairly high, however, because each prediction corresponds to an area the size of an individual measurement (point kriging). For larger... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Trend model | For modelling the trend in the observed Fulmaris glacialis densities, we looked at the external variables of sea water depth and distance to the coast. Figure 4 shows that (i) average densities increased with increasing water depth, and that given water dep... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |

### Measurement error caused by spatial misalignment in environmental epidemiology

- DOI : `10.1093/biostatistics/kxn033`
- TEI : `corpus\papers\tei\gryparis_2009.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | MODELING FRAMEWORK | To introduce our notation, let X be the vector of the true exposures and W be the vector of its errorprone, but not misaligned, measurements. Moreover, let S be the vector of smoothed estimates of X based on W, U = W -X the vector of measurement errors, V =... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Bayesian approaches | In the fully Bayesian approach, one fits a joint model for the health and the exposure data. A fully Bayesian measurement error model adjusts in a natural way for the extra uncertainty associated with using the predicted exposure values in the health model... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |

### Measures of biologically relevant environmental heterogeneity improve prediction of regional plant species richness

- DOI : `10.1111/jbi.12911`
- TEI : `corpus\papers\tei\Measures_of_biologically_relevant_environmental_heterogeneity_improve_prediction_W2559284275.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 56 | Environmental data | We obtained data representing a broad suite of environmental variables from the sources documented below. Following an initial phase of model development, using all variables, we selected a subset of variables (see below) for inclusion in final model constr... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Species richness | The GBIF database (Global Biodiversity Information Facility, 2014; www.gbif.org ) was queried for localities of vascular plant specimens collected within South Africa using the 'dismo' library (Hijmans et al., 2016) implemented in R (R Core Team, 2015). Ali... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Species richness models based on random subsamples of QDS | In order to cater for potential deficiencies in species sampling associated with the use of herbarium records (Gotelli & Colwell, 2001) and autocorrelation, the models were developed 100 times with only 20% of QDS randomly selected at each iteration. The ac... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Boosted regression tree modelling | Boosted regression trees (BRT) provide a machine learningbased model of response variables without null-hypothesis significance testing using incremental shrinkage to reduce the contributions of additional variables and control over-fitting (Elith et al., 2... |

### MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions

- DOI : `10.1111/2041-210X.13762`
- TEI : `corpus\papers\tei\Sydenham2021Metacomnet.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | TA B L E 1 | Variables included in the MetaComNet network model. The data frame contains columns with response variables including: (i) number, or presence or absence, of observed interactions between a pollinator species and a plant species in a particular study site.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | TA B L E 1 | Variables included in the MetaComNet network model. The data frame contains columns with response variables including: (i) number, or presence or absence, of observed interactions between a pollinator species and a plant species in a particular study site.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Occurrence of interactions | The presence or absence of interactions between the bee species and plant within a site. The variable was transformed into a two-level categorical variable for models using classification trees and left as a numeric variable (zero or one) for the models usi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Occurrence of interactions | The presence or absence of interactions between the bee species and plant within a site. The variable was transformed into a two-level categorical variable for models using classification trees and left as a numeric variable (zero or one) for the models usi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Predicting flower-visitor species richness, diversity and abundance | Predicted bee species richness and abundance were positively correlated with observed flower-visitor species richness, diversity and abundance. The Pearson correlation coefficient between observed flower-visitor species richness, diversity or abundance, and... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Predicting flower-visitor species richness, diversity and abundance | Predicted bee species richness and abundance were positively correlated with observed flower-visitor species richness, diversity and abundance. The Pearson correlation coefficient between observed flower-visitor species richness, diversity or abundance, and... |

### Method of the Geographically Weighted Regression and an Example for its Application

- DOI : `10.15196/RS04105`
- TEI : `corpus\papers\tei\Fabian2014Method.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | PPS | -15000.0 15000.1 -25000.0 25000.1 -35000.0 35000.1 -45000.0 45000.1 -Multicollinearity was examined with the help of a Red indicator; the value of which can be between 0 and 1, and the closer it is to 0, the smaller the effect of multicollinearity is (Kovác... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | PPS | -15000.0 15000.1 -25000.0 25000.1 -35000.0 35000.1 -45000.0 45000.1 -Multicollinearity was examined with the help of a Red indicator; the value of which can be between 0 and 1, and the closer it is to 0, the smaller the effect of multicollinearity is (Kovác... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Local analysis of the fragmentation of regional development in Europe | With the help of an example for the application, the paper presents in which aspects the use of the GWR method is better than the use of global regression. Beginning with defining the regional framework: the calculations refer first of all to the EU member... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Local analysis of the fragmentation of regional development in Europe | With the help of an example for the application, the paper presents in which aspects the use of the GWR method is better than the use of global regression. Beginning with defining the regional framework: the calculations refer first of all to the EU member... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Weighting options | The weighting options of fixed kernels: the shape and the extension of the kernel is unchanged during the examination. w ij = 1 each i,j where j is a point in the space where the observation was made and i is a point in the space whose parameter was estimat... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Weighting options | The weighting options of fixed kernels: the shape and the extension of the kernel is unchanged during the examination. w ij = 1 each i,j where j is a point in the space where the observation was made and i is a point in the space whose parameter was estimat... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Geographically weighted regression | Regression is one of the most widespread mathematical-statistical tools of social scientific researches. Its popularity is based on its essence, since this is a method which is suitable to explore the relationships between the phenomena being the key object... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Geographically weighted regression | Regression is one of the most widespread mathematical-statistical tools of social scientific researches. Its popularity is based on its essence, since this is a method which is suitable to explore the relationships between the phenomena being the key object... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Unstandardised coefficients Standardised coefficient t Sig. B standard error Beta Constant -17838.8 1824.1 -9.8 0.0 Rate of people employed in the tertiary sector 383.3 16.7 0.536 23.0 0.0 Rate of economically actives 304.1 26.2 0.264 11.6 0.0 Unemployment... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Unstandardised coefficients Standardised coefficient t Sig. B standard error Beta Constant -17838.8 1824.1 -9.8 0.0 Rate of people employed in the tertiary sector 383.3 16.7 0.536 23.0 0.0 Rate of economically actives 304.1 26.2 0.264 11.6 0.0 Unemployment... |

### Methods for Estimating Regional Skewness of Annual Peak Flows in Parts of Eastern New York and Pennsylvania, Based on Data Through Water Year 2013

- DOI : `10.1002/0471725153`
- TEI : `corpus\papers\tei\Veilleux2021USGSFloodSkew.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Annual Exceedance Probability Analyses | To estimate regional skew for parts of eastern New York and Pennsylvania, a flood-frequency analysis must first be conducted for each streamgage to determine the station skew and its associated mean square error (MSE). The B17C guidelines recommend fitting... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Summary | Bulletin 17C (B17C) guidelines recommend fitting the log-Pearson Type III (LP-III) distribution to a series of annual peak flows at a station by using the method of moments. The LP-III distribution is described by three moments: the mean, the standard devia... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Calculating Pseudo Record Length | The pseudo record length of the annual peak-flow series at each streamgage is used in the regional skew study in several steps, including unbiasing the station skew and its mean square error, determining the concurrent record length between two streamgages,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Bayesian Weighted Least Squares/Bayesian Generalized Least Squares Regression Diagnostics | To determine whether a regression model is a good representation of the data and which regression parameters, if any, should be included in the model, diagnostic statistics have been developed to evaluate how well a model fits a regional hydrologic dataset... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Purpose and Scope | The purpose of this report is to present the results of a B-WLS/B-GLS analysis of regional skew for parts of eastern New York and Pennsylvania (fig. 1A ). The scope of the project includes 183 streamgages in the Mid-Atlantic region (hydrologic units 0202, 0... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Final Bayesian Weighted Least Squares/ Bayesian Generalized Least Squares Model | A constant B-WLS/B-GLS model (having a skew of 0.32 and developed by using data from 183 streamgages with at least 36 years of P RL each) produced the only statistically significant model of skew in the study area (table 3 ). A constant model does not expla... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Section 1 | Tables 1. Streamgages that were considered for use in the regional skew analysis for parts of eastern New York and Pennsylvania ..................................................26 2. Basin characteristics considered for use as explanatory variables in the... |

### Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback

- DOI : `10.1098/rspb.2022.0358`
- TEI : `corpus\papers\tei\Mistletoes could moderate drought impacts on birds but are themselves susceptible to drought-induced dieback.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | level | fixed effect description site-level spatial location WGS84 decimal latitude longitude to 2 m accuracy region 10-level factor defining regional clusters of monitoring sites. Included as a random term in mistletoe and bird models land use 9-level factor: prim... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | (c) Climate data | We sourced climate data from the Australian National University Climate surface database (ANUCLIM v. 6.1 [34] ). We obtained national monthly maximum temperature and rainfall measures between 2017 and 2020 and derived these measures for each of our monitori... |

### Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA

- DOI : `10.1002/rra.3835`
- TEI : `corpus\papers\tei\Lombard2021Model.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Data | Streamflow gages were selected for this study based on their inclusion in, or proximity to, the freshwater range of the GOM DPS of Atlantic salmon in Maine (Figure 1 ). The surficial geologic materials in the basins are predominantly glacial till and fine a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Baseflow prediction | We present a baseflow estimation equation to help water resource managers identify and prioritize stream reaches with potential Atlantic Salmon habitat for conservation and restoration. By identifying basin characteristics that explain much of the variabili... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Baseflow separation | In order to assess relative amounts of groundwater-derived baseflow, it was important to use a baseflow separation technique that removed most of the direct runoff and thus did not conflate aquifer outflows and direct runoff. Partington et al. (2012) found... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Statistical analyses | Percentage of sand and gravel aquifers in the basin and basin-wide mean July precipitation produced the model to predict mean August baseflow with the best fit, the lowest standard error, and lowest Mallow's Cp value (Equation [1] ). where BF aug is the mea... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Section 1 | Recently, the services identified a need to "inventory and prioritize freshwater habitats that provide the best opportunity for salmon recovery, including climate resilient habitats" in the Final Recovery Plan for the GOM DPS of Atlantic Salmon (USFWS and N... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Mapping | We applied the baseflow regression model throughout a single watershed, the Narraguagus in eastern coastal Maine (44 32 0 30 00 N latitude, 67 52 0 53 00 E longitude), as an example of how the equation could be applied and visualized. The stream network for... |

### Model selection and model averaging for matrix exponential spatial models

- DOI : `10.1080/07474938.2022.2047507`
- TEI : `corpus\papers\tei\Model selection and model averaging for matrix exponential spatial models_nodatafound.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | The matrix exponential specification | We consider the following cross-sectional MESS(1, 1) model where y ¼ ðy 1 , :::, y n Þ 0 is the n Â 1 vector of an outcome variable, X is the n Â k matrix of non-stochastic exogenous variables with the matching parameter vector b, W and M are the n Â n spat... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | The matrix exponential specification | We consider the following cross-sectional MESS(1, 1) model where y ¼ ðy 1 , :::, y n Þ 0 is the n Â 1 vector of an outcome variable, X is the n Â k matrix of non-stochastic exogenous variables with the matching parameter vector b, W and M are the n Â n spat... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 6 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 6 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | W 1 W 2 W 3 W 4 MS MA a ¼ 0.2 n ¼ 169 RMSE of a 0.034 0.046 0.063 0.082 0.034 s ¼ 0.2 RMSE of s 0.087 0.094 0.137 0.201 0.086 b 1 ¼2 RMSE of b 1 0.074 0.079 0.078 0.082 0.074 b 2 ¼1 RMSE of b 2 0.079 0.079 0.083 0.084 0.079 Loss 3.223 21.300 29.087 33.987 3... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | W 1 W 2 W 3 W 4 MS MA a ¼ 0.2 n ¼ 169 RMSE of a 0.173 0.145 0.097 0.081 0.088 s ¼ 0.2 RMSE of s 0.177 0.208 0.161 0.182 0.193 b 1 ¼2 RMSE of b 1 0.081 0.080 0.079 0.079 0.080 b 2 ¼1 RMSE of b 2 0.080 0.080 0.080 0.078 0.079 Loss 7.307 6.461 5.376 2.838 4.09... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | W 1 W 2 W 3 W 4 MS MA a ¼ 0.2 n ¼ 169 RMSE of a 0.032 0.047 0.061 0.084 0.034 s ¼ 0.2 RMSE of s 0.087 0.095 0.132 0.187 0.087 b 1 ¼2 RMSE of b 1 0.076 0.080 0.079 0.084 0.075 b 2 ¼1 RMSE of b 2 0.080 0.080 0.084 0.087 0.080 Loss 3.221 21.377 29.073 34.087 3... |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### Model-Based Spatial Data Fusion

- DOI : `10.1146/annurev-statistics-042424-`
- TEI : `corpus\papers\tei\gelfand_schliep_2026_spatial_fusion.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Invasive Plants in New England | We illustrate this data fusion using data from New England on invasive plant species (Gelfand & Shirota 2019) . The spatial domain consists of a subregion of six New England states (Connecticut, Rhode Island, Massachusetts, Vermont, New Hampshire, and Maine... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | TYPES OF FUSIONS | Our general review of the spatial fusion framework envisions the response process of interest as operating at the point level. This enables the conceptual spatial data to be viewed as a set of point locations and marks. Such data can be modeled jointly as [... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Fusion Modeling Using Stochastic Integration | The fusion of point-referenced with areal data, scenario b, is the most common, where each is assumed to be varying around the true surface. Fuentes & Raftery (2005) apply this modeling structure in the environmental exposure setting, where they conceptuali... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Hurricane Helene Storm Totals | Hurricane Helene devastated parts of western North Carolina between September 24 and 27, 2024. To illustrate its significance, we obtained precipitation data from monitoring stations and satellites to perform the data fusion. We denote as source 1 the North... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Modeling presence-only data. | There has been increased growth in the analysis of presence-only data, noting that this type of data is not inferior to presence/absence data. In principle, presence-only data offer a complete census, while presence/absence data, which are confined to a spe... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Modeling presence/absence data. | Given the set of visited points, modeling the presence/absence data at the point scale assumes Y(s) ∼ Bernoulli(p(s)), where p(s) is the probability that the species occurs at site s. The probability of presence can then be linked to a set of environmental... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | The Fusion Modeling | The data fusion considered here differs from that in Section 3 since we do not have two sources informing us about a common response. Rather, we have two different data types informing us about the distribution of a species. The extra information available... |

### Modeling Massive Spatial Datasets Using a Conjugate Bayesian Linear Regression Framework

- DOI : `10.1080/01621459.2015.1044091`
- TEI : `corpus\papers\tei\Modeling_massive_spatial_datasets_using_a_conjugate_Bayesian_linear_modeling_fra_W3004792015.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Conjugate Bayesian linear geostatistical models | A conjugate Bayesian linear regression model is written as where y is an n × 1 vector of observations of the dependent variable, X is an n × p matrix (assumed to be of rank p) of independent variables (covariates or predictors) and its first column is usual... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Spatial Meta-Kriging | A different approach toward BIG DATA problems relies upon divide and conquer methods. The idea here is divide and conquer (or map and reduce) by pooling posterior inference across a partition of data subsets. Once again consider the Bayesian linear regressi... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial prediction | Let L = { l1 , l2 , . . . , lñ } be a set of ñ locations where we wish to predict the outcome y(ℓ). Let Ỹ be an ñ×1 vector with i-th element Ỹ ( li ) and let w be the ñ×1 vector with elements w( li ). The predictive model augments the joint distribution p(θ... |

### Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data

- DOI : `10.1371/journal.pone.0265613`
- TEI : `corpus\papers\tei\Modeling of spatial pattern and influencing factors of cultivated land quality in Henan Province based on spatial big data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Conclusions | Starting from the perspective of spatial pattern, this paper adopts the analysis method of spatial autocorrelation while coupling the normalized results of cultivated land area to study the spatial aggregation characteristics and differences of cultivated l... |
| low_priority_review | `DataSourceCandidate` | 46 | Data preprocessing. | This paper takes the quality of cultivated land in 159 urban areas of Henan Province in 2018 as the research object, details of the sources of the underlying data are shown in Table 1 . Based on the standard of "Cultivated Land Quality Grade", the quality o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Spatial autocorrelation analysis. | The first law of geography proposed by Tobler(1970) has been the theoretical basis for spatial autocorrelation analysis, and cultivated land as continuous space also satisfies this law [21] that there is spatial correlation or similarity. Detecting the pres... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 59 | Research methodology | Area weighting method and data normalization. Determination of spatial weights is the basis for spatial correlation analysis, through the spatial statistical analysis of the adjacency of cultivated land patches in the study area. This paper selects the Quee... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Influence factor analysis | This study selected five influencing factors with strong spatial correlation with the quality of cultivated land, namely IGR, slope, urbanization rate, pesticide use and TAMP, as independent variables and CLQGCA as dependent variables, and constructed a spa... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Data and research methodology |  |

### Modelling the dispersal of the two main hosts of the raccoon rabies variant in heterogeneous environments with landscape genetics

- DOI : `10.1111/eva.12161`
- TEI : `corpus\papers\tei\RiouxPaquette2014Modelling.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Isolation-by-resistance models | In the past, a large number of studies have relied solely on Euclidian distance (isolation-by-distance model, or IBD) or on the number of discrete barriers (isolation-by-barrier model, or IBB) between samples to explain genetic differentiation. However, the... |
| low_priority_review | `DataSourceCandidate` | 45 | Results | For the two species, no pair of loci exhibited significant linkage disequilibrium. A single locus showed a significant departure from Hardy-Weinberg equilibrium (locus PLM20 in raccoons). All loci were highly variable: the number of alleles per locus in rac... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Proportion of the Range in Continuous landscape variables Description landscape (%) MRM buffers Landscape composition Field proportion (%) Natural open areas and cropfields 46.0 [0.000-1.000] Forested lands' proportion (%) Natural forests, logged and sylvic... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Multiple regression on distance matrices | MRM is derived from partial Mantel tests of matrix correlations, in which predictor matrices (in this case, landscape variables, see paragraph below and Appendix A) are used to explain variation in a response matrix (genetic distance). Because of nonindepen... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Multi-Level Restricted Maximum Likelihood Covariance Estimation and Kriging for Large Non-Gridded Spatial Datasets

- DOI : `10.1016/j.spasta.2015.10.006`
- TEI : `corpus\papers\tei\Multi_level_restricted_maximum_likelihood_covariance_estimation_and_kriging_for__W1744580911.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Numerical Study and Statistical Examples | In this section we test the numerical efficiency and accuracy of our solver for computing the terms log det{ Ci W (θ)} and γW ( θ) = C-1 W ( θ) ZW for Matérn covariances. Our results show that we are able to solve problems of up to 128,000 observations and... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | Since φ(r; θ) is in C f +1 (R), then by Taylor's theorem we have that for every x ∈ B a φ(x, y; θ) = ∑ /α/≤ f D α x φ(a,y;θ) α! (x -a) α + R α (x, y; θ), where (x -a) α := (x 1 -a 1 ) α 1 • • • (x d - a d ) α d , α! := α 1 ! • • • α d !, and R α (x, y; θ) :... |

### Multicollinearity in spatial genetics: separating the wheat from the chaff using commonality analyses

- DOI : `10.1111/mec.13029`
- TEI : `corpus\papers\tei\Multicollinearity_in_spatial_genetics_separating_the_wheat_from_the_chaff_using__W2150251862.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Dealing with multicollinearity | There is a growing awareness of multicollinearity issues in spatial genetics (Garroway et al. 2011; Wedding et al. 2011; Dudaniec et al. 2012; Blair et al. 2013) , and several approaches have been proposed to deal with multicollinearity issues. The simplest... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Direct gradient analyses in spatial genetics | Spatial genetics, including both landscape and seascape genetics, is an ebullient scientific field that aims at investigating the influence of spatial heterogeneity on the spatial distribution of genetic variation (Manel et al. 2003; Holderegger & Wagner 20... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Third illustration: data set III | Absolute zero-order Pearson's correlations among predictors in landscape B ranged from 0.089 to 0.766, while VIF ranged from 1.072 to 14.573 (Fig. 1 , panel b 4 ), suggesting potential multicollinearity issues in this example. The most problematic predictor... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | 2014; see Box 3). | In our illustrations, we only considered a set of five predictors, a reasonable number when considering current spatial genetic studies (Zeller et al. 2012) . Nevertheless, the number of commonalities would have increased from 31 to 63 with a single additio... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Box 2. Commonality coefficients in comparison with other regression-type metrics | Commonality analysis is similar to other variance-partitioning techniques in that it partitions the regression effect into orthogonal nonoverlapping parts. Unlike product measures, relative weights or general dominance weights that partition the regression... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Commonality analysis | Commonality analysis (CA) is a detailed variancepartitioning procedure that was developed in the 1960s (Newton & Spurrel 1967) . From the field of human sciences, it was very recently brought to the attention of ecologists (Ray-Mukherjee et al. 2014). CA ca... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Advantages of commonality analyses | As a preliminary remark, note that because of multicollinearity among spatial features, zero-order correlations can be non-null despite no true causal relationship between the dependent variable and spatial predictors (e.g. f 1 in data set I or f 4 in data... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | MRDM and LRDM | When the maximal cost distance was set to 1500 m (data sets I and III), genetic distances were approximately normally distributed (Fig. 2a-c ), allowing the use of linear regression such as MRDM (e.g. Braunisch et al. 2010; Blair et al. 2013; Nanninga et al... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Product measures (or Pratt measures; Pratt 1987) | For a given predictor, product measure is the zero-order correlation coefficient multiplied by the corresponding beta weight, thus reflecting in a single metric both direct and total effects of a predictor on the dependent variable. The computation of produ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Simulated data | We first created two distinct artificial landscapes A and B (Fig. 1 , panels a 1 and b 1 ) of 128 9 128 pixels each. The resolution (size of pixels) was arbitrarily set to 10 m. Both landscapes had distinct configurations but the same composition: a continu... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Beta weights | Beta weights correspond to classical regression weights when variables are z-transformed (by subtracting the mean and dividing by the standard deviation of the variable). Beta weights are thus comparable across various predictors. In logistic regressions, w... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Multiple stressors and the cause of amphibian abnormalities

- TEI : `corpus\papers\tei\Reeves2010Multiple.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | Predator exclusion experiment | Predator exclusion cages (diameter 3 depth ¼ 76.2 3 76.2 cm) were obtained from Team NuMark (Victoria, Texas, USA). Fiberglass window screen was sewn with fishing line to the sides and bottom of the cage to reduce cage mesh size and prohibit entry by invert... |
| review_for_dataset_use | `DataSourceCandidate` | 51 | Study area and selection of study sites | The KNWR comprises 797 200 ha in south-central Alaska, including four designated wilderness areas: Mystery Hills, Swanson River, Skilak Lake, and Tustemena Lake (Wilderness Act of 1964: 16 U.S.C. 1131-1136). The refuge also contains 345 km of roads, most of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Statistical analysis and hypothesis evaluation for field data | We used the Akaike information criterion (AIC) to determine which measured environmental variables best predicted amphibian abnormalities in the KNWR (Burnham and Anderson 2002) . We used generalized linear models (GLIM; PROC GENMOD in SAS version 9.1.3, SA... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Statistical assessment of skeletal abnormalities | Skeletal abnormalities were best predicted by a model including dragonflies, metals, and organic contaminants, along with frog size and developmental stage (Fig. 1 , Tables 2 and 3 ; Appendix D: Fig. D2 ). This model had a quasi-R 2 of 0.89, and the Hosmer-... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Amputation experiment | Experimental animals were harvested from eight recently laid egg masses, Gosner stages 9-12, on 13 May 2008. Eggs were reared to Gosner stage 28, at which point limb amputations began. Tadpoles (n ¼ 32, Best models step 3 Metal PCA 2 þ larval dragonfly abun... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 2 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 3 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 4 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 5 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Model Likelihood Parameters Trials AIC DAIC Quasi-R 2 (%) Intercept only À780.4789 4 3744 1568.958 NA NA Saturated model À737.0573 13 3744 1500.115 NA NA Univariate models step 1 Larval dragonfly abundance À754.4664 4 3744 1516.933 0 60 Organic PCA 2 À762.6... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Para- Quasi-R 2 Model Likelihood meters Trials AIC DAIC (%) Intercept only À351.8538 1 3744 705.7076 NA NA Saturated model À336.7327 13 3744 699.4654 NA NA Best models step 1 Larval beetle abundance À346.0375 2 3744 696.075 0 38 Developmental stage À347.044... |

### Multiplicative Interaction in Generalized Linear Models

- TEI : `corpus\papers\tei\Multiplicative interaction in generalized linear models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Mulltiplicative Interaction in GLMs 1023 | 6. An Application of a Log-Bilinear Model to Counts of Potato Cyst Nematodes on Potatoes Table 1 gives the number of newly formed cysts on 11 potato genotypes for five potato cyst nematode populations belonging to the species Globodera pallida (part of a la... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Visual Displays of Interaction by Means of Biplots | Biplots constitute a powerful tool for displaying interaction which is described by the multiplicative terms in an AMMI model (Gabriel, 1971; Kempton, 1984) . In a biplot, rows and columns are represented by points in twoor three-dimensional space. The coor... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | GLMs and AMMI Models | In a GLM for the random variable y the known link function g( ) transforms the expectation of y, W(y) = ,u, to the linear predictor 71 = xT,3, where the vector x contains the values of the independent variables and the vector ,3 the unknown parameters (McCu... |

### Multiscale Geographically Weighted Regression

- DOI : `10.1201/9781003435464`
- TEI : `corpus\papers\tei\Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 66 | Multiscale Geographically Weighted Regression | The above paragraph highlights an important distinction between research focused on data and research focused on processes. Throughout most of its long history, human geography, for example, has been primarily concerned with data. Initially the focus was on... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Local Versus Global Models | From the origins of the quantitative 'turn' across many social sciences came a focus on relationships between attributes with regression-based models, as exemplified by equation (1.1), being especially popular: where y i is the variable of interest measured... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | A Conceptual Overview of MGWR | In the calibration of a global model, such as those in equations (1.1) and (1.2), with spatial data recorded at a number of locations, the typical procedure would involve using the data on y, x 1 , x 2 , . . . x k recorded at each location in a single calib... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Setting the Scene | Research in many fields is prompted by the empirical observation that the values of most attributes vary over space and/or time. The earliest astronomers were guided by observing the night sky and noting the changes in the positions of certain stars or by o... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Section 1 | Taylor M. Oshan is assistant professor in the Center for Geospatial Information Science in the Department of Geographical Sciences, University of Maryland, as well as an affiliate of the Social Data Science Center, the Maryland Population Research Center, a... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Preface | It is 20 years since the publication of the seminal text on geographically weighted regression (GWR) by Fotheringham et al. (2002) , almost 30 years since the first crude articulations of this approach appeared (Fotheringham & Rogerson, 1993; Rogerson & Fot... |

### Multiscale geographically and temporally weighted regression: exploring the spatiotemporal determinants of housing prices

- DOI : `10.1080/13658816.2018.1545158`
- TEI : `corpus\papers\tei\Chao Wu, Fu Ren, Wei Hu & Qingyun Du_2018_MGTWR.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Abbreviation Min Max Mean Std. Structural variables Property Fee (Yuan/m 2 • month) FEE 0.800 16.000 3.715 1.347 Green ratio GREEN 10.000 90.000 34.454 8.695 Plot ratio PLOT 0.400 14.930 3.725 1.714 Parking space ratio PARKING 0.071 9.660 1.141 0.... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Estimated coefficients Standard deviation t-value p-value Constant -0.232*** 14.2834 -8.523 .000 FEE 0.121*** 0.017 7.118 .000 GREEN 0.105 *** 0.015 6.771 .000 PLOT -0.014*** 0.018 -0.827 .008 PARKING 0.016 0.016 1.015 .310 CBD -0.169 *** 0.023 -7... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Spatial bandwidth AICc Min Q1 Mean Q3 Max Constant 0.053 852.827 -90.743 -3.685 -0.025 3.747 112.877 FEE 75.980 -122.591 0.321 0.322 0.322 0.322 0.322 GREEN 75.980 -122.613 0.250 0.250 0.250 0.250 0.250 PLOT 75.980 -122.589 -0.135 -0.135 -0.134 -0... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Min Q1 Mean Q3 Max Constant -1.675 -0.515 -0.077 0.425 1.499 FEE -0.765 0.173 0.285 0.373 1.052 GREEN -0.362 0.004 0.054 0.107 0.509 PLOT -0.798 -0.037 0.015 0.068 1.004 PARKING -0.570 -0.051 -0.010 0.059 2.236 CBD -1.264 -0.583 -0.414 -0.283 0.55... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Datasets and variables | Based on data availability and hedonic theory (Rosen 1974) , we use the real transaction housing price data from 2010 to 2017 (source: Shenzhen Research Centre of Digital City Engineering). We select the real estate unit with an accurate geographic location... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Geographically and temporally weighted regression | To effectively address spatiotemporal heterogeneity, Huang et al. (2010) extended GWR to GTWR. The form of GTWR is described as follows: where u i ; v i ; t i ð Þ are the space-time coordinates of the ith sample, and β k u i ; v i ; t i ð Þ is the estimated... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model calibration and comparison | First, the HPM is conducted to model the housing prices. There is a high correlation between CBD and RAIL STATION because the CBD is near Shenzhen North Railway Station. The variance inflation factors (VIFs) of CBD and RAIL STATION, representing their multi... |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Multiscale patterns of rarity in fungi, inferred from fruiting records

- DOI : `10.1111/geb.12918`
- TEI : `corpus\papers\tei\Multiscale_patterns_of_rarity_in_fungi_inferred_from_fruiting_records_W2938748080.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | / Composition of the data sets | The UK local data set consists of 62,087 occurrence records of 2,319 fungal species, spanning the years 1950-2014 (inclusive). A total of 310 observers contributed records from 1,558 different localities, all within a 30 km radius of Salisbury, Wiltshire, U... |
| low_priority_review | `DataSourceCandidate` | 45 | / Species abundance distributions | All species abundance distributions were fitted using the R package "sads" (Prado, Miranda, & Chalom, 2016) , which uses maximum likelihood methods to fit and compare different models. These were the gamma, lognormal and Weibull (the three most commonly use... |
| low_priority_review | `DataSourceCandidate` | 45 | / Species and rank abundance distributions | The species abundance distribution for UK national scale records was best fitted by the lognormal distribution (AIC = 33,305.1; Figure 2a ). No other models provided a good fit to the data (Supporting Information Table S1 ), with the next best fit provided... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Relationships between abundance at local and national scales | Relationships between the number of records at local and national scales were examined with a generalized additive model (GAM) procedure, using the "mgcv" package in R. To examine abundanceoccupancy relationships, we followed Holt and Gaston (2003) and Zuck... |

### Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM

- DOI : `10.1080/13658816.2023.2270285`
- TEI : `corpus\papers\tei\Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| low_priority_review | `ModelEvidenceCandidate` | 66 | A Geographical Gaussian Process GAM for SVC modelling | GAMs provide a method for calibrating regression models with unspecified functions of the predictor variables, of the form: where z j may be a scalar or a vector. These can be extended such that each f j ðz j Þ is a linear regression coefficient on another... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | A GGP-GAM analysis | Spatially varying coefficient models with the GGP-GAM were undertaken using the OSGB projected parliamentary constituency in Figure 4 . The geometric centroids of each parliamentary constituency were extracted to generate X and Y (Easting and Northing) vari... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | A MGWR analysis | Finally it also is possible to compare the GGP-GAM results with those from a MGWR. Summaries of model fit and accuracy are shown in Table 6 . Comparing the diagnostics of AIC, adjusted R 2 , and MAE for the GGP-GAM and MGWR models indicates that the MGWR mo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Data | A spatial analysis of the factors associated with the 2016 referendum on EU membership (Brexit) was used to empirically illustrate the proposed GGP-GAM approach and to compare it with MGWR. Census and voting data were obtained from the parlitools R package... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | GAMs | Generalized Additive Models (GAMs) are general in that they can handle outputs with many types of distributions and not just linear relationships, polynomial or not (Wood 2006; Fahrmeir et al. 2022) . They are additive and because they generate multiple mod... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Discussion and conclusion | Spatially varying coefficient (SVC) models explicitly accommodate process spatial nonstationarity, where statistical relationships expressed using regression coefficient estimates are allowed to vary with location. SVCs provide an explicit representation of... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 6 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 . |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Multivariable geostatistics in S: the gstat package $

- DOI : `10.1016/j.cageo.2004.03.012`
- TEI : `corpus\papers\tei\pebesma2004.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 58 | Handling spatial data in S | Prediction locations are often gridded, and observations sometimes are. As noted above, a number of efficiency gains can be obtained when the grid topology of data, if present, is available to gstat. Storing prediction results as grids (2D matrices) can be... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Univariable prediction | Let Z(s) be a vector of length n with observations Z(s 1 ),y,Z(s n ) observed at spatial locations s i arbitrarily spread in R 1 , R 2 or R 3 . The variability in observations Z(s) is usually thought of as consisting of a trend and a residual, and the trend... |

### Multivariate Adaptive Regression Splines

- TEI : `corpus\papers\tei\kooperberg2014_MARS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 58 | Having made the connection between knot selection and basis function (variable) selection, we can now apply any stand... | Many well-known variable selection techniques have been successfully used in polynomial spline algorithms. Smith [9] proposed to start with a large number of equidistant knots, and to use stepwise deletion of knots (basis functions) from there. Stepwise kno... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Higher Dimensional Problems | For higher dimensional problems the approach taken in adaptive regression spline methodologies is to consider selected tensor products of one-dimensional basis functions as basis functions for the higher dimensional problem. Note that the tensor product of... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | (see Splines in Nonparametric Regression). | If (2) is used to estimate a regression function the coefficients can be estimated by least squares or maximum likelihood. This is a standard parametric regression problem. The complication in using this model is that it is not clear where to put the knots.... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Example | We applied the Polymars methodology to data from a study of the dependence of ozone on wind speed, temperature and radiation level over 111 days in 1973 in 3 New York metropolitan areas [16] . This data set is analyzed in many other places [17, 18] (see Reg... |

### Network dependence in multi-indexed data on international trade flows

- DOI : `10.1007/s43071-020-00005-w(`
- TEI : `corpus\papers\tei\Network_dependence_in_multi_indexed_data_on_international_trade_flows_W3014741955.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 |
| low_priority_review | `ModelEvidenceCandidate` | 52 | The Ma ´tya ´s model | Ma ´tya ´s (1997) made an early attempt to introduce multidimensional fixed effects for (log-linear) gravity model specifications such as that in (1). 5 The dependent variable y ijt in (1) reflects an N 2 T Â 1 vector of (logged) trade flows between N count... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | The model | We set forth an extension of the conventional panel gravity model that allows for origin-, destination-and origin-destination-based network dependence. The matrix expressions in (3) represent the network dependence panel gravity model for origindestination... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Multi-indexed panel gravity models | In multidimensional panel data sets, the dependent variable of a panel gravity model is observed along three indices, such as y ijt ; i ¼ 1; . . .; N i ; j ¼ 1; . . .; N j ; t ¼ 1; . . .; T. |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 |

### New regionally modelled soil layers improve prediction of vegetation type relative to that based on global soil models

- DOI : `10.1111/ddi.12973`
- TEI : `corpus\papers\tei\New_regionally_modelled_soil_layers_improve_prediction_of_vegetation_type_relati_W2966907708.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 52 | / Environmental data | The floristic composition of the vegetation at each soil sampling point was quantified using the first three axes used by Bergh et al. (2014) to represent patterns of genus-level floristic similarity between the vegetation units making up the Succulent Karo... |
| low_priority_review | `DataSourceCandidate` | 46 | / Literature and data search and georeferencing | To obtain published data on soil edaphic characteristics, a literature search was conducted within the Scopus database. We also searched the "grey" literature accessible at https ://open.uct.ac.za/ handl e/11427/ 7909 and http://schol ar.sun.ac.za/ . Studie... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / INTRODUC TI ON | Freely available geospatial datasets have transformed biological research capabilities by providing extensive information on environmental conditions (Hampton et al., 2013; Ladeau, Han, Rosi-Marshall, & Weathers, 2017) . The biological community has made go... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | / Boosted regression models | Use of machine learning algorithms such as BRTs for modelling spatial variation in response variables requires the association of these variables with predictor variables. Within the GCFR, several environmental variables show covariation (see Appendix S1: F... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Boosted regression tree analysis | Boosted regression tree (BRT) model construction was performed following Elith, Leathwick, and Hastie (2008) using the "dismo" library (Hijmans, Phillips, Leathwick, & Elith, 2017) in R. The variables that were initially included in the model prior to simpl... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / D ISCUSS I ON | As anticipated by the authors of SoilGrids (Hengl et al., 2017 ), our regional model of soil properties yielded a more faithful representation of the soil properties of the GCFR than their global map. The main reason for this is that our analyses made use o... |

### New trajectories of the Hungarian regional development: balanced and rush growth of territorial capital

- DOI : `10.15196/RS05107`
- TEI : `corpus\papers\tei\Jona2015HungarianTerritorialCapital.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Aggregated index Sub-index/ dimension Variables Total domestic income per capita Net export sales revenue per 1000 people Issued capital for 1 firm Economic Equity for 1 firm capital Total firms for 1000 residents High-tech business service per 1000 residen... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Aggregated index Sub-index/ dimension Variables Total domestic income per capita Net export sales revenue per 1000 people Issued capital for 1 firm Economic Equity for 1 firm capital Total firms for 1000 residents High-tech business service per 1000 residen... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Results | Calculating the arithmetic average (average) between 2004 and 2010 the territorial capital as the national level was increasing by 9,66%, indicating that the annual average growth of territorial capital was 1,38%. Between 2005 and 2006, the highest accumula... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Results | Calculating the arithmetic average (average) between 2004 and 2010 the territorial capital as the national level was increasing by 9,66%, indicating that the annual average growth of territorial capital was 1,38%. Between 2005 and 2006, the highest accumula... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Research model and applied methods | Before beginning of operationalization, some important details need to be clarified. To date, RGTC has not been scrutinized, empirically, therefore in this study inductive methods were applied in some rare cases (Vieira-Tsotras 2013) . When researching terr... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Research model and applied methods | Before beginning of operationalization, some important details need to be clarified. To date, RGTC has not been scrutinized, empirically, therefore in this study inductive methods were applied in some rare cases (Vieira-Tsotras 2013) . When researching terr... |

### Niche conservatism limits the distribution of Medicago in the tropics

- DOI : `10.1111/ecog.06085`
- TEI : `corpus\papers\tei\Niche conservatism limits the distribution of Medicago in the tropics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Medicago distribution data | The global distribution data of Medicago were compiled from published floras, checklists, online databases, field investigations and herbarium specimens (see Supporting information for the list of all sources). The compiled data mainly included administrati... |
| review_for_dataset_use | `DataSourceCandidate` | 50 | Medicago distribution data | The global distribution data of Medicago were compiled from published floras, checklists, online databases, field investigations and herbarium specimens (see Supporting information for the list of all sources). The compiled data mainly included administrati... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Geographical variation in energy-richness relationship | Interestingly, energy was positively correlated with species richness in temperate Asia, Europe and North America (Fig. 3 , Supporting information) and temperate biomes (tundra, boreal forest, temperate seasonal forest, temperate grassland/desert and woodla... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Geographical variation in energy-richness relationship | Interestingly, energy was positively correlated with species richness in temperate Asia, Europe and North America (Fig. 3 , Supporting information) and temperate biomes (tundra, boreal forest, temperate seasonal forest, temperate grassland/desert and woodla... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Richness-energy relationship across continents, biomes and latitudes | We find that the energy variables are significantly correlated to Medicago species richness and they explain between 23 and 66% of the total variance, only next to Quaternary climate change variables (Supporting information). Interestingly, the effect of en... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Richness-energy relationship across continents, biomes and latitudes | We find that the energy variables are significantly correlated to Medicago species richness and they explain between 23 and 66% of the total variance, only next to Quaternary climate change variables (Supporting information). Interestingly, the effect of en... |

### Notes on the earth package

- DOI : `10.1214/aos/1176347963.pdf`
- TEI : `corpus\papers\tei\Earth_MARS__a_note_on_earth.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Short versus long binomial data | Use the function expand.bpairs to convert the "short" form of the data (with a twocolumn binomial pair response) to the equivalent "long" form (with a single response column of TRUEs and FALSEs). See the help page of expand.bpairs for an example. Models bui... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | (ii) Factor response (multinomial response). | This example is for a factor with more than two levels. (For factors with just two levels, see the previous example.) multinom.mod <-earth(pclass~., data=etitanic, glm=list(family=binomial), trace=1) Internally in earth, the factor pclass is expanded to thr... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Further notes on the allowed argument | The basic MARS model building strategy is always applied even when there is an allowed function. For example, earth considers a term for addition only if all factors of that term except the new one are already in a model term. This means that an allowed fun... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Generating the same model as lm | Sometimes we would like to generate the same model as lm, with all predictors entering linearly. But the linpreds argument doesn't stipulate that a predictor must enter the model, only that if it enters it should enter linearly. If a variable has negligible... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | If GCVs are so important, why don't linear models use them? | First a few words about overfitting. An overfit model fits the training data well but won't give good predictions on new data. The idea is that the training data capture the underlying structure in the system being modeled, plus noise. We want to model the... |

### Novel approach to the analysis of spatially-varying treatment effects in onfarm experiments

- DOI : `10.1016/j.fcr.2020.107783`
- TEI : `corpus\papers\tei\rakshit2020_gartner_dataset.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Minnesota data: summary of the analysis | It is clear that the south-eastern (bottom-right corner) part of the field has the steepest negative relationship between yield and elevation, which means that yield increases at a higher rate when one moves from a high to a lower elevation. The other drast... |
| low_priority_review | `DataSourceCandidate` | 46 | Minnesota data: summary of the analysis | It is clear that the south-eastern (bottom-right corner) part of the field has the steepest negative relationship between yield and elevation, which means that yield increases at a higher rate when one moves from a high to a lower elevation. The other drast... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Minnesota data: inadequacy of the global model | Although spatial variation in yield across the field is evident from Fig. 1 , spatial variation in the relationship between yield and elevation is not readily apparent. Left panel of Fig. 6 shows the global linear relationship between yield and elevation, w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Minnesota data: inadequacy of the global model | Although spatial variation in yield across the field is evident from Fig. 1 , spatial variation in the relationship between yield and elevation is not readily apparent. Left panel of Fig. 6 shows the global linear relationship between yield and elevation, w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Bandwidth selection for modelling yield based on treatment factors | Here we develop a bandwidth selection method for the Argentinian data shown in Fig. 2 . The aim is to estimate the spatially-varying treatment effects of the six nitrogen treatments on the yield. Because treatment factors are not spatial explanatory variabl... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Bandwidth selection for modelling yield based on treatment factors | Here we develop a bandwidth selection method for the Argentinian data shown in Fig. 2 . The aim is to estimate the spatially-varying treatment effects of the six nitrogen treatments on the yield. Because treatment factors are not spatial explanatory variabl... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Geographically weighted regression | The underlying template model for the GWR is given by where the unknown quantities β and ϵ are the model parameters and error terms, respectively. We denote = … ⊤ ϵ (ϵ , , ϵ ) n 1 and assume ∼ τ ϵ 0 I ℕ( , ) 2 , i.e., the error terms are independent and nor... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Geographically weighted regression | The underlying template model for the GWR is given by where the unknown quantities β and ϵ are the model parameters and error terms, respectively. We denote = … ⊤ ϵ (ϵ , , ϵ ) n 1 and assume ∼ τ ϵ 0 I ℕ( , ) 2 , i.e., the error terms are independent and nor... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Graphical display of the GWR results. | Although the primary focus of a GWR analysis is to compute and plot the spatially-varying treatment effects (e.g., see Fig. 12 ), these plots may not be readily interpretable, particularly when high order terms greater than the linear term are included in a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Graphical display of the GWR results. | Although the primary focus of a GWR analysis is to compute and plot the spatially-varying treatment effects (e.g., see Fig. 12 ), these plots may not be readily interpretable, particularly when high order terms greater than the linear term are included in a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Bandwidth selection for modelling yield using spatial variables | Here we consider bandwidth selection for the Minnesota field experiment data shown in Fig. 1 . The aim is to model yield as a function of the spatial variable elevation. Both leave-one-out cross-validation and AIC select small bandwidths for this dataset. U... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Bandwidth selection for modelling yield using spatial variables | Here we consider bandwidth selection for the Minnesota field experiment data shown in Fig. 1 . The aim is to model yield as a function of the spatial variable elevation. Both leave-one-out cross-validation and AIC select small bandwidths for this dataset. U... |
| low_priority_review | `truncated` |  |  | 22 autres candidats non affiches dans ce rapport |

### O impacto das cooperativas na produção agropecuária brasileira: uma análise econométrica espacial The impact of cooperatives on Brazilian agricultural production: a spatial econ...

- DOI : `10.1590/1806-9479.2019.187145`
- TEI : `corpus\papers\tei\Neves2019Impacto.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 54 | Efeito da associação a cooperativas | Prosseguindo com a análise proposta na estratégia empírica, o modelo foi estimado, incialmente, por MQO, com os resultados sendo reportados na Tabela 4 13 . 13 Note que, para a estimação dos modelos econométricos, a variável de interesse (associação a coope... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Efeito da associação a cooperativas | Prosseguindo com a análise proposta na estratégia empírica, o modelo foi estimado, incialmente, por MQO, com os resultados sendo reportados na Tabela 4 13 . 13 Note que, para a estimação dos modelos econométricos, a variável de interesse (associação a coope... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | 564/ 576 | tal valor indicam autocorrelação espacial positiva, bem como valores menores que o da relação sugerem autocorrelação espacial negativa. Espera-se que, com o teste de Moran, possam ser obtidos três tipos de informações. A primeira remete ao nível de signific... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | 564/ 576 | tal valor indicam autocorrelação espacial positiva, bem como valores menores que o da relação sugerem autocorrelação espacial negativa. Espera-se que, com o teste de Moran, possam ser obtidos três tipos de informações. A primeira remete ao nível de signific... |

### Oblique geographic coordinates as covariates for digital soil mapping

- DOI : `10.5194/soil-6-269-2020`
- TEI : `corpus\papers\tei\Moller_2020_OGC.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | A2.1 meuse | For the meuse dataset, the accuracy of OGCs combined with auxiliary data was consistently higher than the accuracy of OGCs without auxiliary data, irrespective of the accuracy metric and the number of coordinate rasters (Fig. A1 ). The accuracy of OGCs init... |
| low_priority_review | `DataSourceCandidate` | 45 | A2.3 Swiss rainfall | For the Swiss rainfall dataset, the accuracy of OGCs generally increased with the number of coordinate rasters (Fig. A5 ). The increase in accuracy was steep at first, then gradual. For Pearson's R 2 , the optimal number of coordinate rasters was 33 and for... |
| low_priority_review | `DataSourceCandidate` | 45 | Predictive accuracy | For all four datasets, there were large overlaps in the accuracies of the methods, as accuracies varied across the 100 repeated splits (Figs. 7 , A2 , A4 and A6 ). However, an analysis on the Vindum dataset revealed that the accuracies generally correlated... |
| low_priority_review | `DataSourceCandidate` | 45 | Vindum | For the Vindum dataset, accuracies of predictions obtained with OGCs, without auxiliary data, increased with the number of coordinate rasters up to an optimum at seven coordinate rasters (Fig. 4 ). However, with more than seven coordinate rasters, accuracie... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | A1.1 meuse | We mapped zinc contents for the meuse dataset (155 points). The meuse dataset contains covariates including the flooding frequency and the distance to the river. We added two covariates in the form of a digital elevation model (DEM, https://www.ahn.nl/ , la... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | A1.3 Swiss rainfall | The Swiss rainfall dataset contains 467 rainfall observations from Switzerland from 8 May 1986. We did not use any covariates for this dataset, and we therefore tested only purely spatial methods. We tested ordinary kriging with correction for anisotropy, E... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | A1.2 eberg | We mapped soil types for the eberg dataset. The eberg dataset contains 3670 soil observations. We removed points outside the coverage of the covariates and points without a soil type classification. Furthermore, we removed the soil types "Moor" and "HMoor",... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Additional datasets | For the three additional datasets, the effect of increasing the number of coordinate rasters without auxiliary data was generally the same as for the Vindum dataset. In all three cases, there was relatively little, if any, increase in accuracy after an init... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Choice of method | At Vindum, the three most accurate methods were kriging, RFsp with auxiliary data and OGCs with auxiliary data. For meuse, OGCs and EDFs combined with auxiliary data were most accurate and for eberg, OGCs combined with auxiliary data were most accurate. For... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Conclusions | We have shown in this study that the use of oblique geographic coordinates (OGCs) is a reliable method for integrating auxiliary data with spatial trends for modeling and mapping soil properties. In most cases, the method eliminated the orthogonal artifacts... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Covariate importance | For the Vindum dataset, the most important covariate from the auxiliary data was the depth of sinks (Table 6 ). The most likely reason for its high importance is the presence of a large sink with very high SOM contents northwest of the middle of this study... |
| low_priority_review | `truncated` |  |  | 9 autres candidats non affiches dans ce rapport |

### On the brink: mapping the last strongholds of the critically endangered flapper skate (Dipturus intermedius)

- DOI : `10.1002/ece3.71650`
- TEI : `corpus\papers\tei\Loca2025OnThe.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 54 | / Environmental Data | Environmental predictor variables were selected based on established models of skate distribution and included depth (m), distance from coast (m), mean bottom temperature (°C), mean bottom current velocity (ms -1 ), mean maximum benthic primary productivity... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 2 / |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Model Development | To develop a robust model, a stepwise approach was taken to incorporate key dependencies. Temporal dependency was accounted for by applying a rw1 random walk trend to the year and quarter (time of year) variables (Zuur et al. 2017) . To account for survey-r... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Data Exploration | Initial data exploration was carried out according to methods outlined by Zuur et al. (2010) ; predictor variables were checked for collinearity, outliers and normality. Correlations between variables were observed within a correlation matrix generated usin... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / INLA | The INLA framework (Rue et al. 2009 ) was used to model flapper skate presence in the NE Atlantic in R ( www. r-inla. org/ ). INLA is designed to work with latent Gaussian models, a class of models that includes generalised linear models, spatial and spatio... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 3 / |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Log Link mean ID Model formulation function Dispersion AICc BIC DIC WAIC CV MSPE A Bernoulli GAM logit 0.561 5487.300 5646.305 4898.595 4897.772 0.186 0.057 B Bernoulli logit 0.567 5519.834 5733.865 4854.025 4853.124 0.184 0.057 GAM + smoothed bathymetry C... |

### On the determinants of Airbnb location and its spatial distribution

- DOI : `10.1177/1354816618825415`
- TEI : `corpus\papers\tei\EugenioMartin_CazorlaArtiles_GonzalezMartel_2019_AirbnbCanarySpatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Estimates Elasticities Airbnb price 3.401*** (0.401) 4.456*** Population 0.010*** (0.000) 0.214*** Tourist visits 0.0723*** (0.007) 0.388*** Spatially lagged tourist visits 2.084*** (0.731) 0.575*** Tourist visits to protected areas À0.228*** (0.0... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Estimates Elasticities (total effect) Nature-based destinations Airbnb price 2.625*** (0.450) 3.871*** Population 0.011*** (0.001) 0.248*** Tourist visits À0.004 (0.006) À0.026 Spatially lagged tourist visits 1.044* (0.630) 0.324 Sun and beach des... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Bivariate spatial correlation | For the purpose of this article, bivariate spatial correlation is the key to understand the spatial relationship between established hotels and P2P accommodation. A natural extension of the Moran's I statistic is the bivariate Moran's I statistic. It should... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Spatial econometrics modeling | A positive Airbnb spatial autocorrelation suggests that its location depends on the location of other Airbnb properties nearby. Such positive value is an indicator of the presence of agglomeration effects. It can be tested with spatial econometrics analysis... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial econometrics analysis | The estimates of the determinants of Airbnb entry location are shown in Table 4 . They show that the spatial autoregressive coefficient is significant, so that the spatial approach makes sense. It is positive, so that it proves the presence of agglomeration... |

### On the use of hedonic regression models to measure the effect of energy efficiency on residential property transaction prices: Evidence for Portugal and selected data issues

- DOI : `10.1016/j.eneco.2020.104699`
- TEI : `corpus\papers\tei\Energy efficiency hedonic prices Portugal.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 6 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Sub-market Existing apartments New apartments Existing houses New houses Benchmark estimate 0.118** 0.123** 0.045** 0.055** (0.0019) (0.0024) (0.0061) (0.0062) Parameter results, averages over 1000 replications (+) n = 500 0.121 0.134 0.047 0.067 (0.034) (0... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 6 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Sub-market Existing apartments New apartments Existing houses New houses Benchmark estimate 0.118** 0.123** 0.045** 0.055** (0.0019) (0.0024) (0.0061) (0.0062) Parameter results, averages over 1000 replications (+) n = 500 0.121 0.134 0.047 0.067 (0.034) (0... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Measurement errors | This section investigates the extent to which the energy efficiency partial effects are sensitive to the introduction of either dependent or explanatory variables with measurement errors. To illustrate the former case, the transaction price logarithm is rep... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Measurement errors | This section investigates the extent to which the energy efficiency partial effects are sensitive to the introduction of either dependent or explanatory variables with measurement errors. To illustrate the former case, the transaction price logarithm is rep... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Robustness analysis and cross-country comparisons | To test the robustness of the results presented in the previous section, several models were run with different energy efficiency measurements. Table 4 presents the results for two of such measurements. The first applies the nominal annual primary energy ne... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Robustness analysis and cross-country comparisons | To test the robustness of the results presented in the previous section, several models were run with different energy efficiency measurements. Table 4 presents the results for two of such measurements. The first applies the nominal annual primary energy ne... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Large samples | The impact of using different sample sizes on the quality of the regression results was investigated through experiments in which the hedonic regression models were rerun for a number of samples with different sizes. In particular, the energy efficiency coe... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Large samples | The impact of using different sample sizes on the quality of the regression results was investigated through experiments in which the hedonic regression models were rerun for a number of samples with different sizes. In particular, the energy efficiency coe... |
| low_priority_review | `truncated` |  |  | 16 autres candidats non affiches dans ce rapport |

### Once upon Multivariate Analyses: When They Tell Several Stories about Biological Evolution

- DOI : `10.1371/journal.pone.0132801`
- TEI : `corpus\papers\tei\ade4_houmousr - Once upon Multivariate Analyses When They Tell Several Stories about Biological Evolution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | Congruence between main directions of within-group variance among well-sampled groups | The direction of main variance (Pmax) was assessed in the three well-sampled groups of Gardouch (France) and the islands Marion and Corsica. 100 bootstrapped estimates were calculated for each Pmax, providing a 95% confidence interval for the estimation of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 59 | Comparison between patterns of differentiation provided by the different multivariate methods | The representations of differentiation provided by the different multivariate methods applied to the same dataset (molar shape) were compared as follow. The scores of the group means on axes of a given analysis provide a configuration that can be compared t... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Different methods, different evolutionary patterns, all biologically relevant | Considering the present case study, the PCA and the CVA highlight different evolutionary patterns in the evolution of molar shape in insular populations of house mice (Fig 4 ; schematic representation Fig 6 ). The PCA, be it on the total variance or on betw... |

### OpenML Benchmarking Suites

- TEI : `corpus\papers\tei\bischl_2021_openml_suites.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 49 | Retrieving Existing Suites | Existing benchmark suites can be easily downloaded via any of the OpenML client libraries using its unique id or alias (see Figure 2 ). The tasks and datasets are all uniformly formatted, and come with extensive meta-data to streamline the execution of benc... |
| low_priority_review | `DataSourceCandidate` | 45 | A Brief History of Benchmarking Suites | The machine learning field has long recognized the importance of dataset repositories. The UCI repository [Dheeru and Taniskidou, 2017] and LIBSVM [Chang and Lin, 2011] offer a wide range of datasets. Many more focused repositories also exist, such as UCR [... |
| low_priority_review | `DataSourceCandidate` | 45 | Usage of the OpenML-CC18 | The OpenML-CC18 has been acknowledged and used in various studies. 1 For instance, Van Wolputte and Blockeel [2020] used it to study iterative imputation algorithms for imputing missing values, König et al. [2020] used it to develop methods to improve upon... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Design Criteria | The OpenML-CC18 contains all verified and publicly licenced OpenML datasets until mid-2018 that satisfy a large set of clear requirements for thorough yet practical benchmarking: (a) The number of observations is between 500 and 100 000 to focus on medium-s... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Benchmark Suite Design | The AutoML benchmark explicitly sources part of their datasets from the OpenML-CC18, but also includes datasets used in AutoML competitions (primarily Guyon et al. [2019] ) or previous comparisons of AutoML systems. A step-by-step list of recreating the ben... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | OpenML | OpenML is a collaborative platform that allows anyone to share new datasets, and enables anyone to easily import these datasets and subsequently share their own models and experiments run on them. It organizes everything based on four fundamental, machine-r... |

### Overcompensation and phase effects in a cyclic common vole population: between first and second-order cycles

- DOI : `10.1111/1365-2656.12257`
- TEI : `corpus\papers\tei\Overcompensation_and_phase_effects_in_a_cyclic_common_vole_population_between_fi_W2054417955.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | ON THE ORDER OF DENSITY-DEPENDENCE IN COMMON VOLES | The observed patterns of DD are in contrast to many northern field vole (Microtus agrestis) and greysided vole (Myodes rufocanus) populations, where a stronger delayed DD signature and longer cycles are observed (e.g. Hansen, Stenseth, & Henttonen 1999) , w... |
| low_priority_review | `DataSourceCandidate` | 45 | PITFALLS OF LOG-LINEAR MODELLING | The parameters of the AR(1) model (eqn 5) are estimated to r 0 = 0.92 [0.56; 1.27], α = -1.18 [-1.39;-0.98], σ = 1.48. Overcompensation occurs whenever α < -1 (Ives et al. 2003) , and more stable dynamics when -1 < α < 0. Here we observe therefore overcompe... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Accepted Article | This article is protected by copyright. All rights reserved. arbitrary threshold which can strongly affect estimates of density-dependence (Steen & Haydon, 2000) . We fit direct and delayed density dependent functions on PGRs through a minimisation of the r... |

### PMLB v1.0: An open-source dataset collection for benchmarking machine learning methods

- TEI : `corpus\papers\tei\romano_2022_pmlb.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Pandas profiling reports | We generate summary statistic reports for each dataset using pandas-profiling. These reports provide detailed quantitative descriptions of each dataset, including correlation structures between features and agging of duplicate and missing values. Browsing t... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | New datasets with rich metadata | Since PMLB's original release (v0.2) [2] , we have made substantial improvements in collecting new datasets. PMLB now includes benchmark datasets for regression problems (in addition to classication problems, which have been supported since earlier versions... |

### POWER-LAW MODELS FOR INFECTIOUS DISEASE SPREAD 1

- DOI : `10.1214/14-AOAS743`
- TEI : `corpus\papers\tei\surveillance_fluBYBW - Power-law models for infectious disease spread.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 |

### Patterns of livestock activity on heterogeneous subalpine pastures reveal distinct responses to spatial autocorrelation, environment and management

- DOI : `10.1186/s40462-015-0053-6`
- TEI : `corpus\papers\tei\Patterns of livestock activity on heterogeneous subalpine pastures reveal distinct responses to spatial autocorrelation environment and management.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Differences between study areas | Apart from the general effects unifying most of the study areas, specific covariate effects were only present in particular areas (Fig. 4 ). Most remarkably, there was no effect of terrain slope on grazing and resting intensity in Stocking rate Grazing inte... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Challenges in the analysis of livestock activity patterns | Quantification of animal activity patterns is greatly facilitated by bio-logging systems, such as the employed GPS tracking. This yielded fairly accurate (absolute accuracy of around ±3 m) position records over extended periods -2 -1 0 1 2 Posterior estimat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Correlations of covariate effects with characteristics of study areas | We tested various characteristics of the study areas for their ability to explain the rank-order of covariate effects across areas (Fig. 6 ). Only those covariates that were significant in the majority of models, namely terrain slope, stocking rate, nutrien... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Statistical analysis of activity patterns | The activity data consisted of position counts y i of grazing, resting, and walking observations in each grid cell i. Because the data was over-dispersed, i.e. the variance in the data exceeded the mean, we assumed it to follow a negative binomial (NB) like... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Background | A quarter of the global land surface is covered by managed grasslands and many of them are strongly influenced and structured by grazing livestock [1] . The intensity of pasture use is a primary driver of grassland ecology and related ecosystem services [2]... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Estimates of additional model parameters | Besides the fixed covariates effects, five other parameters were estimated for the regression models of each activity and study area (Table 3 ). Small values of NB parameter κ indicated over-dispersion for resting, especially in areas D-F, where patterns we... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Calculation of environmental and management covariates | The effects of seven possible covariates influencing grazing, resting, and walking intensity were evaluated: elevation, terrain slope, insolation, forage quality, distance to the shed, distance to nearest water source, and stocking rate. The seven covariate... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Common drivers of grazing, resting, and walking intensity | The estimated effects of environmental and management covariates on the intensity of grazing, resting, and walking agreed reasonably well across all six study areas (Fig. 4 ). The main determinants of grazing intensity were terrain slope, forage quality, an... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Common influences of the environment on livestock activity patterns | Understanding and controlling livestock distribution is of major importance in heterogeneous and rugged landscapes. Because natural patterns of increased resource availability are likely to be reinforced by the animals' utilization patterns [10, 42] , inapp... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Covariate effects estimated for individual animals, daytime and season | Covariate effects estimated for subsets of the data generally agreed with the results obtained for the aggregated data per area (Fig. 5 and Additional file 4 with effects of all covariates and activities). Individual variation in the response of grazing int... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Sensitivity of model results to spatial autocorrelation and prior choice | Estimates of fixed covariate effects may depend on the specification of the random error terms and, if fitted in a Bayesian context as done here using INLA, their associated prior distributions [26, 27, 37] . Specifying error terms to account for spatial au... |

### Phylogeography Takes a Relaxed Random Walk in Continuous Space and Time

- DOI : `10.1093/molbev/msq067`
- TEI : `corpus\papers\tei\Lemey_2010_RelaxedRandomWalk_molbev_msq067.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | Rabies Epidemic Analysis | As an example of pathogen dispersal during an epidemic, we apply the BD and RRW models to examine a 30-year rabies virus (RABV) epizootic among North American raccoons (Biek et al. 2007) . Bayesian coalescent analysis of serially sampled viral genetic data... |

### Physically constrained spatiotemporal modeling: generating clear-sky constructions of land surface temperature from sparse, remotely sensed satellite data

- DOI : `10.1080/02664763.2019.1681384`
- TEI : `corpus\papers\tei\Physically_constrained_spatiotemporal_modeling_generating_clear_sky_construction_W2980619698.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | t)). | There is substantial bias for some of the satellite passings (passings 11, 18, and 21 again stand out, with bias greater than 3 • C) but bias is expected at some points in time, due to the physical constraint enforced by the diurnal cycle. As shown in Figur... |
| review_for_dataset_use | `DataSourceCandidate` | 50 | Description of the data | The motivating examples for this research come from two remotely sensed datasets: the Houston region provides an example featured with a hot, humid, and cloudy summer while, in contrast, Phoenix was selected for its hot, dry, and sunny summer weather, thus... |
| low_priority_review | `DataSourceCandidate` | 47 | Construction of spatial basis functions | The method described in the previous subsection requires a set of areal basis functions X suitable for describing the spatial variability of the diurnal cycle parameters over a general region of interest. While there are several choices of spatial basis fun... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Date & Time RMSE ( • C) Bias ( • C) Coverage CI Width ( • C) Percent Missing 1 2014-06-28 11:18 (Terra Satellite) 2.17 0.64 95.4% 17.15 93.3% 2 2014-06-28 12:48 (Aqua Satellite) 1.6 0.31 98.5% 18.73 97.6% 3 2014-06-28 21:36 (Terra Satellite) 1.78 0.64 97.6%... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Date & Time RMSE ( • C) Bias ( • C) Coverage CI Width ( • C) Percent Missing 1 2003-09-11 11:36 (Terra Satellite) 3.11 2.3 95.4% 11.87 0.2% 2 2003-09-11 13:12 (Aqua Satellite) 2.37 -0.73 98.4% 11.96 0.6% 3 2003-09-11 22:00 (Terra Satellite) 2.17 1.47 98.2%... |

### Precision Agriculture: Economics of Nitrogen Management in Corn Using Sitespecific Crop Response Estimates from a Spatial Regression Model

- TEI : `corpus\papers\tei\Economics of Nitrogen Management in Corn Using Sitespecific cross response.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | DATA | N response data was collected from strip trials on four farms in the Río Cuarto area, Córdoba Province, Argentina, in the 1998-99 crop season. This paper deals only with the yield data (8288 observations) from the farm "Las Rosas" located at 63º 50' 50" of... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Spatial Autocorrelation. | Spatial autocorrelation, or more generally, spatial dependence, is the situation where the dependent variable or error term at each location is correlated with observations on the dependent variable or values for the error term at other locations. The gener... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | RESULTS | Diagnostics tests for spatial dependence in the OLS model confirm that there is spatial autocorrelation in the data and that an error model should be used. There is also some presence of heteroskedasticity. The LM-error test for "Las Rosas" farm is 2762, wh... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Returns to Uniform Rate and to Variable Rate N. | Returns from N above fertilizer cost were estimated for two uniform application rates and for VRA by landscape position (Table 3 ). Two uniform rates were used to represent the range of N rates currently used in the Río Cuarto area. The higher uniform N rat... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | OLS Regression Estimates for "Las Rosas" Treatments: Full Pass Low East Slope E Hilltop Slope W Constant 67.1486 67.1486 60.6389 46.5788 60.1828 N 0.0873 0.0873 0.1047 0.1487 0.1208 t value 4.25 4.25 4.54 6.35 6.42 Probability 0.00 0.00 0.00 0.00 0.00 N² -0... |

### Predicting Fusarium Head Blight Epidemics With Weather-Driven Pre-and Post-Anthesis Logistic Regression Models

- DOI : `10.1094/PHYTO-11-12-0304-R`
- TEI : `corpus\papers\tei\Predicting_Fusarium_Head_Blight_Epidemics_With_Weather_Driven_Pre_and_Post_Anthe_W2132383899.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Hourly data imputations. | Multiple imputations are superior to case-wise deletion and missing-indicator analysis (64) . Missing values in a w j were multiply imputed using the R package Amelia II (version 1.2-14), with the following specified options: logistic transformation of rh (... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | MATERIALS AND METHODS | The observational data matrix. FHB severity and incidence were rated in fungicide-untreated plots maintained by collaborators participating in USWBSI-funded projects. FHB severity (S) is defined as the mean percentage of a wheat spike's surface area with FH... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Model performance. | The AIC, sensitivity (proportion of major epidemics classified correctly), specificity (proportion of non-major epidemics classified correctly), and overall misclassification rate (proportion of fhb observations classified incorrectly) of the logistic and a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Dimension reduction in modeling. | Some form of variable selection was desirable to adhere to the objective of creating parsimonious models. Forward and backward stepwise regression methods violate several statistical principles (22, 46, 68) and are now highly discouraged for model developme... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Training and test data sets. | Each version of the FHB data matrix was partitioned into training and test data sets, with 70% of the observations going into the training data and the remaining 30% into the test data. The training data were used for model building. Test data were used to... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Section 1 | In the United States, Fusarium head blight (FHB) of wheat (Triticum aestivum L. em. Thell) is caused primarily by Fusarium graminearum sensu stricto of the F. graminearum species complex (44) . Major FHB epidemics have occurred somewhere in the United State... |

### Predicting climate change impacts on critical fisheries species in Fijian marine systems and its implications for protected area spatial planning

- DOI : `10.1111/ddi.13709`
- TEI : `corpus\papers\tei\Lawson2023Predicting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | / Species occurrence data | Our work draws on existing datasets that are publicly available for Fijian coasts. We focussed on the islands of Vanua Levu and Viti Levu and immediately surrounding area, where we expect protected areas are likely to be concentrated in future. Due to the r... |
| low_priority_review | `DataSourceCandidate` | 46 | / Data limitations and challenges | We relied on the accuracy of GBIF contributors for our invertebrate distributions, which may not be completely accurate despite our cleaning process. Many invertebrate species do not have robust abundance data records for Fiji and Oceania broadly, despite t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Environmental and climate data | Biophysical variables were selected for inclusion in analysis based on life history traits of each taxa type, using available literature and prior SDM studies on similar species to limit the number of irrelevant predictors (Santini et al., 2020) . Climatic... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Species distribution modelling | An ODMAP (Overview, Data, Model, Assessment and Prediction; Zurell et al., 2020) protocol describing the modelling pipeline is available in the Supplementary material (Table S2 ). To compare the predictive capability of different environmental variables, we... |

### Predicting the effects of climate change on deep-water coral distribution around New Zealand-Will there be suitable refuges for protection at the end of the 21st century?

- DOI : `10.1111/gcb.16389`
- TEI : `corpus\papers\tei\Anderson2022Predicting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Model outputs and estimation of uncertainty | Each BRT and RF model, for each taxon, was fitted to spatial grids of the predictor variables to estimate a habitat suitability value for each TA B L E 2 Initial set of environmental predictors considered for habitat suitability models Variable Description... |

### Primary productivity explains size variation across the Pallid bat's western geographic range

- DOI : `10.1111/1365-2435.13092`
- TEI : `corpus\papers\tei\Kelly2018Primary.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental variables | We acquired spatially gridded environmental datasets to inform tests of the heat conservation and dissipation, seasonality and were generated using data from weather station monthly averages between the years 1960-1990 (Hijmans et al., 2005) . To test the s... |
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental variables | We acquired spatially gridded environmental datasets to inform tests of the heat conservation and dissipation, seasonality and were generated using data from weather station monthly averages between the years 1960-1990 (Hijmans et al., 2005) . To test the s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / Data analyses | Prior to investigating geographic size variability, we tested for any evidence of sexual size dimorphism using Welch's two sample t test. Male and female Pallid bats did not differ in size (see Section 3), and therefore, we pooled males and females for subs... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | / Data analyses | Prior to investigating geographic size variability, we tested for any evidence of sexual size dimorphism using Welch's two sample t test. Male and female Pallid bats did not differ in size (see Section 3), and therefore, we pooled males and females for subs... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / RE SULTS | We found no evidence of sexual size dimorphism when we used centroid size of the lateral or ventral views of cranium as proxies for A. pallidus body size, (lateral cranium: t = -0.57, df = 173, p = .57, ventral cranium: t = -0.27, df = 173, p = .78). Our an... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / RE SULTS | We found no evidence of sexual size dimorphism when we used centroid size of the lateral or ventral views of cranium as proxies for A. pallidus body size, (lateral cranium: t = -0.57, df = 173, p = .57, ventral cranium: t = -0.27, df = 173, p = .78). Our an... |

### Putting MARS into space. Non-linearities and spatial effects in hedonic models

- DOI : `10.1111/pirs.12738`
- TEI : `corpus\papers\tei\lopez_2023.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | SP-MARS-1 SP-MARS-2 SP-MARS-3 SP-MARS-4 SP-MARS-5 | Non-linear spatial lag terms ðWy À 8:89Þ þ 0.184 ----ð8:89 À WyÞ þ À0.278 ----ðWy À 8:46Þ þ -0.237 ---ð8:46 À WyÞ þ -0.144 ---ðWy À 9:82Þ þ --0.550 --ð9:82 À WyÞ þ --0.136 --ðWy À 8:38Þ þ --0.324 --ðWy À 10:62Þ þ --À1.887 -- :34 À WyÞ þ ---0.190 -ðWy À 8:59... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / THE MARS ALGORITHM: ST. PERTERSBURG HOUSING MARKET | This section illustrates the application of the MARS algorithm for the estimation of a hedonic model of housing prices in St. Petersburg and evaluates the sensitivity of this algorithm to the automatic selection of non-linear terms. We develop a hedonic mod... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | ANNEX A | Table A1 shows the results of the GAM estimation. The first column shows the results of the estimation of the GAM without spatial lag. The second column, the model SP-GAM, includes the term Wy. T A B L E A 1 GAM estimation. GAM SP-GAM Intercept 8.661 (0.004... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Non-linear spatial term Wy | In this subsection, we estimate five models using the MARS algorithm with the same tuning parameters that are used in Section 3. The results from applying this estimation procedure are shown in Table 3 . The hypothesis that we propose in this paper is that... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | / The MARS algorithm | As with any regression model, the objective of this methodology is to build an econometric model to explain the variation of a dependent variable Y ¼ ðy 1 , …, y n Þ 0 with a set of potential explanatory variables X ¼ ðX 1 , …, X p Þ, where To achieve this... |

### Quantification of Neighborhood-Level Social Determinants of Health in the Continental United States

- DOI : `10.1001/jamanetworkopen.2019.19928`
- TEI : `corpus\papers\tei\kolak_2020_oi_190747.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Health Outcomes and Violent Crime | To estimate associations between social determinants of health and health outcomes for a subset of data, the mortality rate at the census-tract level was used for the Chicago, for which we had sufficiently high-quality direct measurements of premature morta... |
| low_priority_review | `DataSourceCandidate` | 45 | Population and Spatial Scale | In this cross-sectional multivariate analysis, the first phase of the study included all populated census tracts of the continental United States (n = 71 901), with a total observed population of approximately 312 million persons based on census estimates.... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Regression Analysis | We estimated associations between premature mortality rates in Chicago using the 4 indices derived from the dominant principal components while controlling for the violent crime rate. The indices were used as input to retain the greatest information rather... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Regression Analysis | We found that in Chicago, more than 60% of the variation in premature mortality at the neighborhood level was associated with SDOH dimensions alone, even after accounting for violent crime and underlying spatial structures. An association was observed betwe... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |

### Quantifying the small-area spatio-temporal dynamics of the Covid-19 pandemic in Scotland during a period with limited testing capacity

- DOI : `10.1016/j.spasta.2021.100508`
- TEI : `corpus\papers\tei\Quantifying_the_small_area_spatio_temporal_dynamics_of_the_Covid_19_pandemic_in__W3154458050.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | Limitations with the data | As discussed in the introduction wide-scale testing of Covid-19 was not available during the first wave of the pandemic, and the public were instead advised to phone NHS 24 if they developed Covid-like symptoms. These considerations motivate our use of the... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Journal Pre-proof 412 413 414 415 416 417 418 419 420 421 422 423 424 425 Quantity DIC p.d LMPL temporal autocorrelation structure is not entirely sufficient for capturing the W Spatio-temporal correlation model matrix AR(1) -I AR(1) -L AR(2) -I AR(2) -L D=... |

### Quasi-likelihood functions, generalized linear models, and the Gauss-Newton method

- TEI : `corpus\papers\tei\wedderburn1974_Quasi-likelihood or generalized linear models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | E@taj E@6 al8*al8j -F(z-A)21 aA aA E{ V(1t)}12J fl&fl since V(,ut) var (z). Also we have -E(8f 4 -E V()J#} -l ( V() m} V(#)Df il V(1 a alCb I al C6 1 altl alj which completes the proof. |

### RESAMPLING METHODS FOR SPATIAL REGRESSION MODELS UNDER A CLASS OF STOCHASTIC DESIGNS 1

- DOI : `10.1214/009053606000000551`
- TEI : `corpus\papers\tei\lahiri_2006.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | 2.2. | The stochastic sampling design. Let f (x) be a probability density function on R 0 and let {X n } be a sequence of independent and identically distributed (i.i.d.) random vectors with probability density function f (x) such that {X n } and {Z(s) : s ∈ R d }... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | 8. Proof of Theorem 1. Let v(s) = Λ -1 n w(s), s ∈ R n , η d n = n -1 λ d n , C -1 n = η d n λ -d/2 n Λ -1 n , n ≥ 1. |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | Proof of Theorem 1. Let ξ † n,i (t) ≡ 1 0 ψ ′ (Z(s i ) -uw(s i ) ′ (t -β)) du, 1 ≤ i ≤ n. By Taylor's expansion, the left-hand side of (3.3) equals n i=1 w(s i )ψ(Z(s i )) - n i=1 w(s i )w(s i ) ′ (t -β)ξ † n,i (t) (8.3) = n i=1 w(s i )ψ(Z(s i )) - n i=1 w(... |

### REVISITING GUERRY'S DATA: INTRODUCING SPATIAL CONSTRAINTS IN MULTIVARIATE ANALYSIS

- DOI : `10.1214/10-AOAS356`
- TEI : `corpus\papers\tei\HistData_Guerry - Revisiting Guerrys data Introducing spatial constraints in multivariate analysis.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Standard approaches. | We use the data set compiled by Michael Friendly and available at http://www.math.yorku.ca/SCS/Gallery/guerry/ . This data set has been recently analyzed by Dykes and Brunsdon (2007) to illustrate a new interactive visualization tool and is now distributed... |
| low_priority_review | `DataSourceCandidate` | 46 | Application to Guerry's data. | Here we consider p = 6 variables measured for n = 85 observations (départements of France). As only quantitative variables have been recorded, principal component analysis [PCA, Hotelling (1933) ] is well adapted. Applying PCA to the correlation matrix wher... |
| low_priority_review | `DataSourceCandidate` | 45 | 2.3. | Toward an integration of multivariate and geographical aspects. The integration of multivariate and spatial information has a long history in ecology. The simplest approach considered a two-step procedure where the data are first summarized with multivariat... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Conclusions. | We have presented different ways of incorporating the spatial information in multivariate analysis methods. While PCA is not constrained, spatial information can be introduced as a partition (BCA), a polynomial of geographic coordinates (PCAIV-POLY), a subs... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Moran's eigenvector maps. | An alternative way to build spatial predictors is by the diagonalization of the spatial weighting matrix W. de Jong, Sprenger and van Veen (1984) have shown that the upper and lower bounds of MC for a given spatial weighting matrix W are equal to λ max (n/1... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Spatial explanatory variables. | Principal component analysis with respect to the instrumental variables [PCAIV, Rao (1964) ], also known as redundancy analysis [van den Wollenberg (1977) ], is a direct extension of PCA and multiple regression adapted to the case of multivariate response d... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Moran scatterplot. | If the spatial weighting matrix is row-standardized, we can define the lag vector z = Wz (i.e., zi = n j=1 w ij x j ) composed of the weighted (by the spatial weighting matrix) averages of the neighboring values. Equation (4) can then be rewritten as since... |

### Random forest as a generic framework for predictive modeling of spatial and spatio-temporal variables

- DOI : `10.7717/peerj.5518`
- TEI : `corpus\papers\tei\hengl2018_Random forest as a generic framework.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Meuse data set (regression, 2D, no covariates) | In the first example, we compare the performance of a state-of-the-art model-based geostatistical model, based on the implementation in the geoR package (Diggle & Ribeiro Jr, 2007) , with the RFsp model as implemented in the ranger package (Wright & Ziegler... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | likfit: WARNING: This step can be time demanding! --------------------------------------------------------------likfi... | where lambda=0 indicates transformation by natural logarithm (positively skewed response). Once we have estimated the variogram model, we can generate predictions, i.e., the prediction map using Eq. ( 12 ): > locs <-meuse.grid@coords > zinc.ok <-krige.conv(... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Ebergötzen data set (binomial and multinomial variables, 2D, with covariates) | As Random Forest is a generic algorithm, it can also be used to map binomial (occurrencetype) and multinomial (factor-type) responses. These are considered to be ''classificationtype'' problems in Machine Learning. Mostly the same algorithms can be applied... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Summary results | We have defined a RFsp framework for spatial and spatiotemporal prediction of sampled variables as a data-driven modeling approach that uses three groups of covariates inside a single method: 1. geographical proximity to and composition of the sampling loca... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | The National Geochemical Survey data set, multivariate case (regression, 2D) | Because RF is a decision tree-based method, this opens a possibility to model multiple variables within a single model, i.e., by using type of variable as a covariate. This means that prediction values will show discrete jumps, depending on which variable t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | CONCLUSIONS | We have shown that random forest can be used to generate unbiased spatial predictions and model and map uncertainty. Through several standard textbook datasets, we have shown that the predictions produced using RFsp are often equally accurate (based on repe... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Spatial prediction | Spatial prediction is concerned with the prediction of the occurence, quantity and/or state of geographical phenomena, usually based on training data, e.g., ground measurements or samples y(s i ),i = 1...n, where s i ∈ D is a spatial coordinate (e.g., easti... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Random forest for spatial data (RFsp) | RF is in essence a non-spatial approach to spatial prediction in a sense that sampling locations and general sampling pattern are ignored during the estimation of MLA model parameters. This can potentially lead to sub-optimal predictions and possibly system... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Random forest | Random forest (RF) (Breiman, 2001; Prasad, Iverson & Liaw, 2006; Biau & Scornet, 2016) is an extension of bagged trees. It has been primarily used for classification problems and several benchmarking studies have proven that it is one of the best machine le... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | METHODS AND MATERIALS |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Geographical covariates | One of the key principles of geography is that ''everything is related to everything else, but near things are more related than distant things'' (Miller, 2004) . This principle forms the basis of geostatistics, which converts this rule into a mathematical... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | NRCS data set (weighted regression, 3D) | In many cases training data sets (points) come with variable measurement errors or have been collected with a sampling bias. If information about the data quality of each individual observation is known, then it also makes sense to use this information to p... |

### RealCause: Realistic Causal Inference Benchmarking

- TEI : `corpus\papers\tei\neal_realcause_2020.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Model Selection | We just saw that predictive performance is indicative of causal performance when choosing hyperparameters within a model class, but what about selecting between model classes after choosing hyperparameters via predictive cross-validation? The results are mu... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | LALONDE LBIDD TEST PSID CPS TWINS IHDP QUAD EXP LOG LINEAR T KS 0.9995 1.0 0.9837 0.9290 0.5935 0.9772 0.4781 0.3912 T ES 0.6971 0.3325 0.7576 0.5587 0.8772 0.6975 0.4157 0.3815 Y KS 0.4968 1.0 0.8914 0.3058 0.2204 0.9146 0.4855 0.4084 Y ES 0.3069 0.1516 0.... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | LALONDE LBIDD TEST PSID CPS TWINS IHDP QUAD EXP LOG LINEAR (T,Y ) Wass1 0.0304 0.1500 0.5004 0.2019 0.2009 0.0456 0.1510 0.2832 (T,Y ) Wass2 0.0123 0.0797 0.4924 0.1636 0.4277 0.1314 0.2380 0.3172 (T,Y ) FR 0.0 0.0776 0.5581 0.2825 0.0 0.0014 0.0140 0.7946... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Distribution Assumption | We use the output of the MLPs to parameterize the distributions of selection and outcome. For example, for binary data (such as treatment), we apply the logistic sigmoid activation function to the last layer to parameterize the mean parameter of the Bernoul... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | PRELIMINARIES AND NOTATION | Let T be a binary scalar random variable denoting the treatment. Let W be a set of random variables that corresponds to the observed covariates. Let Y be a scalar random variable denoting the outcome of interest. Let e(w) denote the propensity score P(T = 1... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 : |
| low_priority_review | `truncated` |  |  | 25 autres candidats non affiches dans ce rapport |

### Really Doing Great at Estimating CATE? A Critical Look at ML Benchmarking Practices in Treatment Effect Estimation

- TEI : `corpus\papers\tei\curth_2021_cate_benchmarking.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Learning Algorithms and how DGPs can determine their performance. | A plethora of ML-based CATE estimators have been proposed in recent years. Here, we distinguish them along two key axes 1 : (i) the underlying ML method and (ii) the estimation strategy. The former is straightforward and refers simply to the ML method used... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Background: Problem Setup and Learning Algorithms | We operate under the standard setup in the potential outcomes (PO) framework [47] . That is, we assume that any individual, associated with (pre-treatment) covariates X ∈ X , has two potential outcomes Y (0) and Y (1) of which only Y = Y (W ) = W Y (1) + (1... |

### Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach

- DOI : `10.1016/j.eneco.2015.08.003`
- TEI : `corpus\papers\tei\BaltaOzkan2015Regional.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 51 | GROBID table | Table 11 . Missing observations and cross-checking of data |
| review_for_dataset_use | `VariableTableCandidate` | 51 | GROBID table | Table 11 . Missing observations and cross-checking of data |
| review_for_dataset_use | `VariableTableCandidate` | 49 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 49 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Name of variable Data Availability Year Data Source 1 Scale of Data Data processing Scotland 2011 GROS NUTS3 - England and Wales 2011 ONS -Census Aggregated Age of Population LSOA to NUTS3 Number of Scotland 2011 SNS Data Zone Aggregated Households England... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Name of variable Data Availability Year Data Source 1 Scale of Data Data processing Scotland 2011 GROS NUTS3 - England and Wales 2011 ONS -Census Aggregated Age of Population LSOA to NUTS3 Number of Scotland 2011 SNS Data Zone Aggregated Households England... |
| low_priority_review | `ModelEvidenceCandidate` | 71 | Methodology | Elhorst (2010) proposes a general-to-specific approach to arrive at the most suitable econometric model. Equation ( 1 ) offers a family of related spatial econometric models: where Y is a (N x 1) vector of observations on a dependent variable and X is an (N... |
| low_priority_review | `ModelEvidenceCandidate` | 71 | Methodology | Elhorst (2010) proposes a general-to-specific approach to arrive at the most suitable econometric model. Equation ( 1 ) offers a family of related spatial econometric models: where Y is a (N x 1) vector of observations on a dependent variable and X is an (N... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Dependent variable: PV data | The data on PV deployment comes from the Central FIT Register, published by the Ofgem Eserve Database and includes FIT installations as of 30 June 2013. The database lists installed and declared capacities (kW) for different technology and installation type... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Dependent variable: PV data | The data on PV deployment comes from the Central FIT Register, published by the Ofgem Eserve Database and includes FIT installations as of 30 June 2013. The database lists installed and declared capacities (kW) for different technology and installation type... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Model specification | In order to investigate the drivers of PV uptake across 134 regions, following on previous studies and within constraints on the available data, the following model has been employed 12 : (4) In equation ( 4 ) i denotes regions and u is an independently and... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Model specification | In order to investigate the drivers of PV uptake across 134 regions, following on previous studies and within constraints on the available data, the following model has been employed 12 : (4) In equation ( 4 ) i denotes regions and u is an independently and... |
| low_priority_review | `truncated` |  |  | 10 autres candidats non affiches dans ce rapport |

### Regression models for prediction of corn yield in the state of Paraná (Brazil) from 2012 to 2014

- DOI : `10.4025/actasciagron.v40i1.36494`
- TEI : `corpus\papers\tei\Regression models for prediction of corn yield in the state of Parana Brazil from 2012 to 2014.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Material and methods | The area of study comprises the state of Paraná, and this study uses data related to the average corn yield of the main harvest (summer harvest) in the state municipalities, considering variables related to the altitude (m), soil agricultural potential, pre... |

### Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions

- DOI : `10.1093/isq/sqz068`
- TEI : `corpus\papers\tei\Jones2019Regulatory.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Entire dataset 2005-2013 2008 cross-section 2013 cross-section Variables Mean Std. dev. N Mean Std. dev. Min. Max. N Mean Std. dev. Min. Max. N Dependent variable Basel II adoption 2.318 3.127 783 3.500 4.109 0 10 96 3.108 3.118 0 10 65 Spatial lags Spatial... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Entire dataset 2005-2013 2008 cross-section 2013 cross-section Variables Mean Std. dev. N Mean Std. dev. Min. Max. N Mean Std. dev. Min. Max. N Dependent variable Basel II adoption 2.318 3.127 783 3.500 4.109 0 10 96 3.108 3.118 0 10 65 Spatial lags Spatial... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Data and Methodology | To test our argument about the impact of interdependence and cross-border interactions on regulators' responses to Basel II, we estimate a series of spatial lag and spatial autoregressive models of Basel II adoption among countries outside the Basel Committ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Data and Methodology | To test our argument about the impact of interdependence and cross-border interactions on regulators' responses to Basel II, we estimate a series of spatial lag and spatial autoregressive models of Basel II adoption among countries outside the Basel Committ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Spatial Lag Variables | To analyze the effect of interdependence in the spread of Basel II to the financial periphery, we use a spatial lag model, in which the key explanatory variables are weighted observations of the dependent variable in other units. Spatial lags are calculated... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Spatial Lag Variables | To analyze the effect of interdependence in the spread of Basel II to the financial periphery, we use a spatial lag model, in which the key explanatory variables are weighted observations of the dependent variable in other units. Spatial lags are calculated... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Robustness: Spatial Autoregressive Models | To test the robustness of our results, we estimate a series of spatial autoregressive models. While autoregressive models are often preferred to spatial-OLS models to avoid simultaneity bias, they require the sample of countries included in the connectivity... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Robustness: Spatial Autoregressive Models | To test the robustness of our results, we estimate a series of spatial autoregressive models. While autoregressive models are often preferred to spatial-OLS models to avoid simultaneity bias, they require the sample of countries included in the connectivity... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Robustness: Alternate Measure of the Dependent Variable | In the main models reported in Tables 2 and 3 above, the dependent variable of the extent of Basel II adoption is measured using the sum of Basel II components adopted. While this is a straightforward measure, there might be a concern that the index is not... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Robustness: Alternate Measure of the Dependent Variable | In the main models reported in Tables 2 and 3 above, the dependent variable of the extent of Basel II adoption is measured using the sum of Basel II components adopted. While this is a straightforward measure, there might be a concern that the index is not... |

### Relationships between the distribution of wildlife and livestock diversity

- DOI : `10.1111/ddi.13133`
- TEI : `corpus\papers\tei\Relationships between the distribution of wildlife and livestock diversity.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | / Distributional and environmental data | We calculated wildlife and livestock diversity indices for each of the 10 × 10 km UTM grid cells within mainland Spain, after removing island territories to avoid insularity effects, and costal grid cells to avoid size effects. A total of 5,033 grid cells w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Statistical analyses | To analyse the relationship between wild species richness and livestock breed richness and environmental variables while accounting for the spatial non-stationarity of these relationships, we performed geographically weighted regression models (GWR) (Fother... |

### Remote sensing-based measurement of Living Environment Deprivation: Improving classical approaches with machine learning

- DOI : `10.1371/journal.pone.0176684`
- TEI : `corpus\papers\tei\Remote sensing-based measurement of leaving environment depravation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Land cover features | Land cover features describe the composition of the urban scene in terms of the amount of basic land cover types: vegetation, soil, gray impervious surfaces (asphalt and industrial roofing), orange impervious surfaces (clay tile roofs and similar), shadow a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Model interpretation | Interpretation of linear models is usually performed by examining the sign, size and significance of the estimated parameters. The main results for both the linear and spatial models are displayed in Table 4 . The models include the four extracted factors-f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Results | We describe the main results according to the following precepts: model interpretation, to cover the output of each of the models estimated; and model performance, to assess in detail the relative advantages of each approach in predicting the LED index. Bef... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Model performance | Once we have a good idea of how the models produce predictions; what the variables are, and which approach contributes most to generating the estimates of the LED index, we turn to the question of how good these predictions are. Validation and performance a... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Conclusions | This paper explores the potential of two machine learning methods, GBR and RF, to predict the LED index in Liverpool (UK) using land cover, spectral, texture and structure variables extracted from a very high spatial resolution aerial image. We compare the... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methods | The derived features are not particularly useful for explaining LED by themselves. They need to be combined into a single model that creates predictions based on existing estimates. Conceptually, this may be represented as: where f(Á) is a function that com... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Gradient Boost Regressor (GBR) | The second machine learning algorithm that is included is a Gradient Boost Regressor (GBR). Similar to the RF, it is an ensemble that combines the output of several models to produce a single prediction for the outcome variable. Boosting is a technique that... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial linear model | One way to improve the predictive performance of a linear model, while maintaining much of its interpretability, may be to extend it to accommodate spatial autocorrelation. In cases where the spatial nature of the data is relevant to the process being studi... |

### Reporting quality of randomised controlled trial abstracts among high-impact general medical journals: a review and analysis

- DOI : `10.1136/bmjopen-2016-011082`
- TEI : `corpus\papers\tei\Hays_2016_ReportingQualityRCTAbstracts_bmjopen011082.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | METHODS Search strategy and study selection | We conducted a descriptive, cross-sectional study of RCT abstracts in five journals with the highest impact factors in 2014. 22 We included abstracts published between 2011 and 2014 in The New England Journal of Medicine (NEJM), the Annals of Internal Medic... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |

### Reproductive traits explain occupancy of predicted distributions in a genus of eastern North American understory herbs

- DOI : `10.1111/ddi.13297`
- TEI : `corpus\papers\tei\Miller2021Reproductive.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Incorporating reproductive life history traits | We used beta regression to relate reproductive life history traits to We ran beta regression models with several life history predictor variables and used Akaike's Information Criterion (AICc; calculated using AICcmodavg [Mazerolle, 2019] ) to determine bes... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Climate variables | Climate variables were generated by Wang et al. (2016) at 1 km 2 resolution (ClimateNA v5.10 software package; available at http:// tinyu rl.com/Clima teNA ), accessed September 2017. These data include 27 monthly, seasonal and annual climate variables cali... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Incorporating life history traits | The best-fit beta regression model included the non-interactive effects of flower type, ovule number, and seed mass for the mean model and employed a logit link (AICc = -4.83; Loglik =11.92, df =6, pseudo R 2 = 0.70; X 2 = 23.65, p <.001; Table 3 ). The mea... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / D ISCUSS I ON | Our results support the hypothesis that variation in proportional occupancies (POs) of Trillium species' predicted suitable areas (based on models of fundamental niches) can be explained by flower type-a component of trillium life history that relates to an... |

### Revista de Administração Contemporânea Journal of Contemporary Administration

- DOI : `10.1590/1982-7849rac2022200387.en`
- TEI : `corpus\papers\tei\Miquelluti2022Application.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Data cleaning and yield detrending | We utilized the National Water Agency (ANA) daily precipitation data set, focusing only on municipalities, in the state of Paraná, with an operational weather station. The time series spans from January 20, 1979 to April 01, 2015 for 41 weather stations, on... |
| review_for_dataset_use | `DataSourceCandidate` | 50 | Data cleaning and yield detrending | We utilized the National Water Agency (ANA) daily precipitation data set, focusing only on municipalities, in the state of Paraná, with an operational weather station. The time series spans from January 20, 1979 to April 01, 2015 for 41 weather stations, on... |
| low_priority_review | `DataSourceCandidate` | 46 | Data pre-processing and clustering | In order to fill missing values we applied multiple imputation by chained equations (MICE) using the R software (Buuren & Groothuis-Oudshoorn, 2000) and then calculated the standardized precipitation index (SPI) with a three-month scale, thus capturing seve... |
| low_priority_review | `DataSourceCandidate` | 46 | Data pre-processing and clustering | In order to fill missing values we applied multiple imputation by chained equations (MICE) using the R software (Buuren & Groothuis-Oudshoorn, 2000) and then calculated the standardized precipitation index (SPI) with a three-month scale, thus capturing seve... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Weather index insurance | The state of Paraná is an important producer of soybean, being the second largest producer in Brazil. In spite of the evolution in crop technology and crop management, yields are highly susceptible to drought in some regions of the state, with as much of 50... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Weather index insurance | The state of Paraná is an important producer of soybean, being the second largest producer in Brazil. In spite of the evolution in crop technology and crop management, yields are highly susceptible to drought in some regions of the state, with as much of 50... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Geographically weighted quantile lasso | A natural extension to the geographically weighted regression (GWR) is the geographically weighted quantile regression (GWQR) model, which has the following form: Revista de Administração Contemporânea, v. 26, n. 3, e-200387, 2022/ doi.org/10.1590/1982-7849... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Geographically weighted quantile lasso | A natural extension to the geographically weighted regression (GWR) is the geographically weighted quantile regression (GWQR) model, which has the following form: Revista de Administração Contemporânea, v. 26, n. 3, e-200387, 2022/ doi.org/10.1590/1982-7849... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Yield index modeling | We observe for the cluster representing the western and northern portions of Paraná that the December SPI presents the greatest impact on yields (Figures 1 and 2 ). Given that we assume, based on state reports (Secretaria da Agricultura e do Abastecimento,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Yield index modeling | We observe for the cluster representing the western and northern portions of Paraná that the December SPI presents the greatest impact on yields (Figures 1 and 2 ). Given that we assume, based on state reports (Secretaria da Agricultura e do Abastecimento,... |

### Rising coastal groundwater as a result of sea-level rise will influence contaminated coastal sites and underground infrastructure

- DOI : `10.22541/essoar.168500245.55690018/v1`
- TEI : `corpus\papers\tei\Hill_2023_RisingCoastalGroundwater_essoar.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | National Assessment of Exposed and Contaminated Sites | To identify all Superfund sites that may be exposed to potential coastal groundwater inundation or influence from changed groundwater flow directions, we delineated coastal areas where groundwater conditions may be affected by a rising sea surface. Such coa... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | San Francisco Bay Comparison with Superfund and State-Managed Sites | We used a similar study of the San Francisco Bay Area to estimate the number of statemanaged contaminated sites that may be exposed to rising coastal groundwater, in addition to Superfund sites. State-managed sites are not necessarily less hazardous than fe... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Implications of our results | A synthetic conceptual model is needed for contaminated sites that represents the full range of hazards in a changing climate including rising groundwater, changes in groundwater salinity and other chemical characteristics, and potential changes in groundwa... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | 411 412 representing relatively high percentages. 413 3.2 San Francisco Bay Area Comparison: Superfund and State-Managed Sites |

### SGWR: similarity and geographically weighted regression

- DOI : `10.1080/13658816.2024.2342319`
- TEI : `corpus\papers\tei\Lessani_Li_2024_SGWR.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 12 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Data Observations Predictors Dependent Variable Geographical Unit Housing 21,613 6 Price Neighborhood Crime 2,841 13 Crime rate County Mental health 68,356 12 Mental health prevalence Census tract (Contagious US) Depression HIV 1,072 2,526 12 7 Depression p... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 12 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Data Observations Predictors Dependent Variable Geographical Unit Housing 21,613 6 Price Neighborhood Crime 2,841 13 Crime rate County Mental health 68,356 12 Mental health prevalence Census tract (Contagious US) Depression HIV 1,072 2,526 12 7 Depression p... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Beyond geographical distance | Waldo Tobler's First Law of Geography underscores the significance of spatial proximity in shaping relationships and interactions, thereby serving as a cornerstone in spatial analysis and geographical studies. Consequently, prior research primarily employed... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Beyond geographical distance | Waldo Tobler's First Law of Geography underscores the significance of spatial proximity in shaping relationships and interactions, thereby serving as a cornerstone in spatial analysis and geographical studies. Consequently, prior research primarily employed... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Experimental datasets | Five distinct datasets are used to evaluate the proposed model: housing prices, crime rates, and three health outcomes -focusing on mental health, depression prevalence, and HIV. The housing dataset pertains to King County, Washington, US, and it consists o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Experimental datasets | Five distinct datasets are used to evaluate the proposed model: housing prices, crime rates, and three health outcomes -focusing on mental health, depression prevalence, and HIV. The housing dataset pertains to King County, Washington, US, and it consists o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Performance of the models | The performance of the three models, namely GWR, ordinary least squares (OLS), and SGWR, were evaluated based on several statistical measures. Additionally, we briefly discussed the results of SGWR with MGWR model. The OLS model, serving as our baseline mod... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Performance of the models | The performance of the three models, namely GWR, ordinary least squares (OLS), and SGWR, were evaluated based on several statistical measures. Additionally, we briefly discussed the results of SGWR with MGWR model. The OLS model, serving as our baseline mod... |
| low_priority_review | `truncated` |  |  | 40 autres candidats non affiches dans ce rapport |

### SPATIAL MACHINE-LEARNING MODEL DIAGNOSTICS: A MODEL-AGNOSTIC DISTANCE-BASED APPROACH A PREPRINT

- TEI : `corpus\papers\tei\Brenning_2023_SpatialMLDiagnostics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 59 | Case study description: the Meuse dataset | The Meuse dataset contains 155 observations of (logarithmic) topsoil zinc concentration (logZn in log-ppm) as the response variable, and several possible predictor variables. Zinc concentrations in this study area are related to the amount of contaminated s... |
| review_for_dataset_use | `DataSourceCandidate` | 51 | Case study description: the Maipo dataset | The dataset used is a well-documented case study consisting of 400 fields (7713 grid cells in total) with 4 different fruit-tree crops in central Chile (Peña and Brenning, 2015) . To simulate use cases with typical learning sample sizes, data from 100 field... |
| low_priority_review | `DataSourceCandidate` | 46 | Case study 2: spatial classification | Crop classification using multispectral satellite image time series is a broad and important ML task in environmental remote sensing. Knowledge of SPEPs is important in order to assess the potential of classifiers to be applied in adjacent study regions. Th... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Computational versus theoretically motivated measures of spatial model performance | Theoretically derived measures of uncertainty such as kriging variances or prediction intervals of linear regression models provide a reliable uncertainty assessment when their model assumptions are satisfied. In the regionalization case study, computationa... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Case Study 1: regionalization using ML and geostatistics | The first case study is a well-known dataset on topsoil heavy-metal concentration on a floodplain of the Meuse river in the Netherlands as included in the sp package in R (Pebesma and Bivand, 2005) . It is widely used to introduce geostatistical interpolati... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | The role of autocorrelation and independence in spatial model assessment | It has previously been proposed to choose the buffer distance based on the range of residual autocorrelation (Brenning, 2005; Le Rest et al., 2014; Valavi et al., 2019) . Nevertheless, this starts from the intuition that test samples must be independent, al... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial prediction error profiles | In the Meuse case study, the SPEPs revealed a strong dependence of performance on prediction distance for all methods, with some surprising similarities between (geo-)statistical and ML techniques (Figure 2 ). Overall, interpolation techniques that do not i... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Regionalization techniques and their assessment | In this case study, spatial diagnostics of the following contrasting spatial prediction methods were compared: 1. Nearest-neigbour interpolation (NN) was chosen as a simple deterministic baseline method. 2. Ordinary kriging (OK) was included as a basic geos... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | Distance-based spatial model assessment and interpretation | In the model-agnostic spatial model assessment, SPEPs demonstrated their ability to highlight strengths and weaknesses of different models in predicting the response locally, and in transferring the modeled relationships to more distant regions. In combinat... |

### SPATIO-TEMPORAL MODELS WITH ERRORS IN COVARIATES: MAPPING OHIO LUNG CANCER MORTALITY

- TEI : `corpus\papers\tei\SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Description of covariates | It is well known that smoking is a very important risk factor for lung cancer. Other factors, such as gender, race, age, urban living and socio-economic status (SES), may also be involved. Gender, race and age information is available directly from our data... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Results | We once again ran five independent chains using our Gibbs-Metropolis algorithm for 2200 iterations each; plots similar in appearance to Figure 1 suggested discarding the first 200 samples as an adequate burn-in period. Total computation time was about 50 mi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Model development | We start with the basic spatial model for the 1988 data only, and as such we suppress the subscript t for now. Since the data are lung cancer death counts by gender and race, an additive log-linear model with a Poisson likelihood is appropriate. We add the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Posterior estimates were calculated for the above model (1) and ( 3 )-(6). Recalling that the p G 's and q G 's are bounded between 0 and 1, we chose a fairly vague gamma(1, 100) prior for N and set O "0)01, allowing modest spatial correlation among the p G... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | SPATIAL MODELLING WITH COVARIATES |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model statement | The study of the trend of risk for a given disease in space and time may provide important clues in exploring underlying causes of the disease and helping to develop environmental health policy. This can be done by constructing a Poisson log-linear spatio-t... |

### STATISTICAL PLASMODE SIMULATIONS -POTENTIALS, CHALLENGES AND RECOMMENDATIONS

- DOI : `10.1038/ng.2764`
- TEI : `corpus\papers\tei\schreck_2024_plasmode.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Feature Parametric Simulations Statistical Plasmodes Data-generating process (DGP) DGP is to be specified in advance No DGP specification is required Outcome-generating model (OGM) Parameters of a chosen OGM to be Parameters of a chosen OGM to be estimated... |

### Sampled Grid Pairwise Likelihood (SG-PL): An Efficient Approach for Spatial Regression on Large Data

- TEI : `corpus\papers\tei\Sampled Grid Pairwise Likelihood_homesales_datasets.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 5 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |

### Scale and correlation in multiscale geographically weighted regression (MGWR)

- DOI : `10.1007/s10109-025-00468-1`
- TEI : `corpus\papers\tei\Scale_and_correlation_in_multiscale_geographically_weighted_regression_MGWR_W4411091431.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Evaluation criteria | One of the primary objectives of this study is to understand the link between the estimation of spatial process scale and the two types of correlations (spatial autocorrelation and bivariate collinearity). Therefore, an examination of the optimal bandwidths... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Data generating process | The data generating process (DGP) utilized followed an MGWR-like regression specification that incorporates two covariates ( X 1 and X 2 ), one intercept parameter ( β 0 ), and two slope parameters ( 1 and 2 ). The three parameters are configured to potenti... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Impact of collinearity | To isolate the potential impact of collinearity on (M)GWR, the DGP was controlled so that the covariates were not spatially autocorrelated. Collinearity has essentially no impact on the estimation of the parameter surface that is uncorrelated (i.e., interce... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Impact of collinearity | Similar to the trend from the smaller sample experiment, when the two covariates are randomly spatially distributed, increasing collinearity increases estimation error for coefficients of the two covariates without much effect on the intercept and the incre... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Impact of spatial autocorrelation | In contrast, when there is no collinearity between the two covariates, spatial autocorrelation in covariates has spillover effects on the estimation accuracy of the intercept and the associated bandwidth. There are increased levels of estimation error for a... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Impact of spatial autocorrelation | The general impact due solely to spatial autocorrelation in both covariates is similar for both MGWR and GWR in that it still increases estimation error for all three surfaces, but there is no longer an issue with misestimation of the intercept bandwidth, e... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Spatial autocorrelation and collinearity | The combined effects of both types of correlation have never previously been examined for (M)GWR, and there appears to be a cumulative impact on the results compared to each individual factor. As both types of correlation get stronger, it takes many more it... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatially autocorrelated covariates | To simulate realistic covariates that follow Tobler's first law of geography, "Everything is related to everything else, but near things are more related than distant things" (Tobler 1970) , a first-order spatial autoregression specification was used and is... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Introduction | Spatially heterogeneous processes may vary from location to location in their magnitude and nature. Several strategies have been proposed to capture this spatial nonstationarity using local models because traditional global models are likely to produce misl... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Constant SNR σ MGWR bandwidth GWR parameter estimates bandwidth surface estimate b 0 b 1 b 2 b 0 0.874 1.5 623 148 50 90 0 0.655 2.5 624 227 71 139 1 0.87 1.5 147 623 50 90 1 0.636 2.5 197 623 73 130 |

### Scale-dependent effects of urbanization on avian diversity in a Neotropical region

- DOI : `10.1007/s11252-024-01624-z`
- TEI : `corpus\papers\tei\UrbanEcosystems_2025_UrbanizationAvianDiversity_s11252.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Assessing the effects of local and landscape variables on species richness | To test the unique and shared effects of local (environmental) and regional (land-cover) variables on species richness, we carried out variation partitioning based on partial redundancy analysis (RDA) using the sum across all five sampling visits for each s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Sampling design | We used a hierarchical design stratified into a gradient of urbanization, which allowed us to differentiate between local and regional effects of urbanization. To investigate the effects of urbanization across scales, bird data were sampled in 24 plots (100... |

### Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum

- DOI : `10.1111/mec.15833`
- TEI : `corpus\papers\tei\Sex-specific spatial variation in fitness in the highly dimorphic.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | / Joint estimation of effective fecundities and both pollen and seed dispersal kernels | We used a method that uses information about the genotype and the spatial location of adults and seedlings to jointly estimate pollen and seed dispersal kernels and the individual male and female effective fecundities-a proxy for fitness (see Introduction).... |
| low_priority_review | `DataSourceCandidate` | 47 | / Microsatellite genotyping | We genotyped both adults and their progeny in our focal population (available at https://doi.org/10.5061/dryad.ngf1v hhst ). For both adults and seedlings, sampled leaves were preserved in silica gel prior to DNA extraction using a modified version of the C... |
| low_priority_review | `DataSourceCandidate` | 45 | / Study species and site | Leucadendron rubrum is a dioecious wind-pollinated shrub species endemic to the Western Cape of South Africa (Rebelo, 2001) where natural fires occur every 10-15 years (Kraaij et al., 2011; van Wilgen et al., 2010) . Leucadendron rubrum belongs to the famil... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | / Multivariate sex-specific selection analysis | Inspired by the multivariate framework of Lande and Arnold (1983) , we examined in a single full model the relationship between the relative effective fecundity as the response variable and the following explanatory variables: canopy diameter, leaf area, pl... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | / Novel methods for dealing with spatial bias affecting selection estimates in plants | Technical and methodological improvements in parentage assignations now allow for estimation of plant fitness in natural populations from genetic data, and provide the link between fitness and plant traits through selection gradients analyses (e.g., Burczyk... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Dispersal occurred on a smaller spatial scale for seed than for pollen | For both pollen and seed dispersal kernels, our analysis revealed fat-tailed dispersal kernels (i.e., b s and b p < 1; Figure 2 and Table 1 ). Seed and pollen immigration rates were of the same order of magnitude (11% and 15% for seed and pollen respectivel... |

### Short-Term Rental Platform in the Urban Tourism Context: A Geographically Weighted Regression (GWR) and a Multiscale GWR (MGWR) Approaches

- DOI : `10.1111/gean.12259`
- TEI : `corpus\papers\tei\Geographical Analysis - 2020 - Shabrina - Short‐Term Rental Platform in the Urban Tourism Context A Geographically.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Statistical base-lining | In the first instance, it was necessary to ensure that the chosen parameters exhibit no strong correlation with one another. Thus, we calculate the variance inflation factor (VIF) that assesses how much variances increase if predictors are correlated. No co... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Statistical base-lining | In the first instance, it was necessary to ensure that the chosen parameters exhibit no strong correlation with one another. Thus, we calculate the variance inflation factor (VIF) that assesses how much variances increase if predictors are correlated. No co... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model comparison and performance | Table 4 shows the comparison between the results of the implemented models, including the global model and two local models, through the models' goodness of fit. It shows that both local models have a significantly better fit than the global regression mode... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model comparison and performance | Table 4 shows the comparison between the results of the implemented models, including the global model and two local models, through the models' goodness of fit. It shows that both local models have a significantly better fit than the global regression mode... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Traditional accommodation from the Ordnance Survey Points of Interest (POI) data 2018. | including guest houses, bed and breakfast, hostels, hotels, motels, country houses, inns, youth hostels, and other youth classifications. Fig. 2b shows the data across London. It illustrates the concentration of 1382 hotels distributed in only 644 LSOAs (13... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Traditional accommodation from the Ordnance Survey Points of Interest (POI) data 2018. | including guest houses, bed and breakfast, hostels, hotels, motels, country houses, inns, youth hostels, and other youth classifications. Fig. 2b shows the data across London. It illustrates the concentration of 1382 hotels distributed in only 644 LSOAs (13... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | The Geographically Weighted Regression and multiscale GWR (MGWR) | Simple linear regression, the most used technique in geographical analysis, assumes changes across space to be universal, which is not always the case in every spatial context. Variations across geographical space, known as spatial non-stationarity, might b... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | The Geographically Weighted Regression and multiscale GWR (MGWR) | Simple linear regression, the most used technique in geographical analysis, assumes changes across space to be universal, which is not always the case in every spatial context. Variations across geographical space, known as spatial non-stationarity, might b... |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### Simplifying the interpretation of continuous time models for spatio-temporal networks

- DOI : `10.1007/s10109-020-00345-z`
- TEI : `corpus\papers\tei\Simplifying_the_interpretation_of_continuous_time_models_for_spatio_temporal_net_W3185530119.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data analysis | Both real and simulated data were analysed using the same approach. The first aim of the analyses was to identify for each connection recorded in the network the time of day at which the journey from origin to destination takes the longest (time of maximum... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Simplifying the interpretation of continuous time models… estimating continuous temporal network properties. Information about pattern features and continuous temporal network properties was easy to interpret with a clear 'real-world' meaning. In this case,... |

### Simulation study to evaluate when Plasmode simulation is superior to parametric simulation in comparing classification methods on high-dimensional data

- DOI : `10.1371/journal.pone.0322887`
- TEI : `corpus\papers\tei\stolte_2025.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Misspecification of the OGM. | A very general approach to modify classification models applicable to all models that output predicted probabilities is described in [8] . The predicted probabilities π of the model are transformed into log-odds log( π /(1 -π )). These log-odds are multipli... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | Classification methods. | Within our parametric or Plasmode method comparison studies, we compare several methods for binary classification including • Ridge logistic regression [13] , • LASSO logistic regression [14] , • Support vector machine (SVM) [15] , • k-nearest neighbors (KN... |

### Simulation study to evaluate when Plasmode simulation is superior to parametric simulation in estimating the mean squared error of the least squares estimator in linear regression

- DOI : `10.1371/journal.pone.0299989`
- TEI : `corpus\papers\tei\stolte_2024.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Results | In this Section, we evaluate the results of the simulations. First, we explain the plots for one simple scenario and type of deviation. Then, the different resampling strategies for Plasmode are compared. Afterward, we discuss the results for the different... |

### Soybean yield is positively linked to organic matter, but planting date remains more influential

- DOI : `10.1002/saj2.20779`
- TEI : `corpus\papers\tei\Malone2024Soybean.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Core Ideas | • In a dataset from producer-managed fields, higher organic matter was linked to higher soybean yield. • Soybean yield was positively associated with soil organic matter and permanganate oxidizable carbon, but not autoclaved citrate extractable nitrogen. •... |
| low_priority_review | `DataSourceCandidate` | 45 | Factors outside of soil health contribute to soybean yield | Other factors in the model were also significant predictors of crop yield in this dataset, namely, mapped clay content, soil test K, and planting date, all with a larger standardized coefficient than SOM or POXC (Tables 2 and 3 ). Soil test K levels may hav... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Multiple linear regression analysis | To account for some of the known factors that impact soybean yield, we used multiple linear regression to explore the relationship of both SOM and POXC with soybean yield, with separate models for each soil health test. The overall model including SOM or PO... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data analysis | Data analysis was conducted using R version 4.2.1 (R Core Team, 2022) in Rstudio 2022.12.0 (Posit Team, 2022), primarily using the packages within "tidyverse" (Wickham et al., 2019) and "lmerTest" (Kuznetsova et al., 2017) . The map of points was created us... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Soybean yield and soil health indicators align | Soil health testing should align with desired functional outcomes (Wade et al., 2022) , which our data support for both SOM and POXC relating positively, albeit weakly, to soybean productivity (Tables 2 and 3 ; Figure 4 ) (Liptzin et al., 2022) . Yet it is... |

### Space-time Modelling with Long-memory Dependence: Assessing Ireland's Wind Power Resource

- DOI : `10.2307/2347679`
- TEI : `corpus\papers\tei\Haslett_Raftery_1989_wind_AppliedStatistics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data analysis | Dr Kent's comparison of the square root transformation at different levels of aggregation with the log-normal transformation elsewhere is perceptive; Carlin and Haslett (1982) found this effective for hourly data. He is correct in his surmise that transform... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | The Data | The data are hourly wind speeds and directions at each of 12 synoptic meteorological stations during the period 1961-78; see Fig. 1 . The wind speeds were recorded in knots (1 knot = 0.5148 m/s), but converted to metres per second for analysis. Here we pres... |

### Spatial Autoregressive Models for Scan Statistic

- TEI : `corpus\papers\tei\Spatial_autoregressive_models_for_scan_statistic_W2991142729.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Estimation of the spatial autoregressive parameter | It should be noted that i) the spatial correlation assumption is considered under both hypotheses H 0 and H 1 , and ii) the intensity of spatial correlation (ρ * ) should not vary between these two hypotheses because it depends on the spatial structure of t... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Computing the significance | In the following, let λ refer to the scan statistic of one of the three previous methods (λ G , λ P -SAR or λ N P -SAR ). Since the distribution of λ under H 0 does not have a closed form, Kulldorff et al. (2009) suggested to evaluate the statistical signif... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Results | Figure 1 presents the comparison of the Gaussian spatial scan statistic and the parametric and nonparametric SAR scan statistics according to type I error for different values of ρ. Regarding the classical spatial scan statistics, the type I error sharply i... |

### Spatial Clustering Overview and Comparison: Accuracy, Sensitivity, and Computational Expense

- DOI : `10.1080/00045608.2014.958389`
- TEI : `corpus\papers\tei\Spatial Clustering Overview and Comparison_cincinnati.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 63 | Methods and Data | The performance of seven popular and widely applied spatial clustering methods is examined in this article. The formal mathematical details for each approach are given in Appendix A. As noted previously, although cluster detection methods are often structur... |

### Spatial Data Analysis with R

- TEI : `corpus\papers\tei\Spatial Data Analysis with R - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Scale and resolution | The term "scale" is tricky. In its narrow geographic sense, it is the the ratio of a distance on a (paper) map to the actual distance. So if a distance of 1 cm on map "A" represents 100 m in the real world, the map scale is 1/10,000 (1:10,000 or 10-4). If 1... |
| low_priority_review | `DataSourceCandidate` | 45 | Spatial autocorrelation | The concept of spatial autocorrelation is an extension of temporal autocorrelation. It is a bit more complicated though. Time is one-dimensional, and only goes in one direction, ever forward. Spatial objects have (at least) two dimensions and complex shapes... |
| low_priority_review | `DataSourceCandidate` | 45 | ˓→colors(50))[10*(income+1)]) | Income inequality is often expressed with the Gini coefficient. For our data set the Gini coefficient is 0.581. Now assume that the household data was grouped by some kind of census districts. I create different districts, in our case rectangular raster cel... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | California House Price Data | Now get the county boundaries and assign CRS of the houses data matches that of the counties (because they are both in longitude/latitude!). crs(hvect) <-crs(counties) Do a spatial query (points in polygon) cnty <-extract(counties, hvect) head(cnty) ## id.y... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | By grid cell | An alternative approach would be to compute a model for grid cells. Let's use the 'Teale Albers' projection (often used when mapping the entire state of California). TA <-"+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000␣ ˓→+datum=W... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | California precipitation | if (!require("rspat")) remotes::install_github('rspatial/rspat') ## Loading required package: rspat ## Loading required package: terra ## terra 1.7.62 DEATH VALLEY 36.47 -116.87 -59 7.4 9.5 7.5 3.4 1.7 1.0 3.7 ## 2 ID743 THERMAL/FAA AIRPORT 33.63 -116.17 -3... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Get the data | if (!require("rspat")) remotes::install_github("rspatial/rspat") ## Loading required package: rspat ## Loading required package: terra ## terra 1.7.62 library(rspat) h <-spat_data('houses2000') I have selected some variables on on housing and population. Yo... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Random Forest | CART gives us a nice result to look at that can be easily interpreted (as you just illustrated with your answer to Question 1). But the approach suffers from high variance (meaning that the model tends to be over-fit, it is different each time a somewhat di... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Regression | rp <-predict(wc, rrf, na.rm=TRUE) plot(rp) Note that the regression predictions are well-behaved, in the sense that they are between 0 and 1. However, they are continuous within that range, and if you wanted presence/absence, you would need a threshold. To... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial Data Analysis with R | Notice that there are six values, because the regression tree has six leaves. |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial Data Analysis with R | The residualso appear to be autocorrelated. A formal test: Clearly, there is spatial autocorrelation. Our model cannot be trusted. so let's try SAR models. |
| low_priority_review | `ModelEvidenceCandidate` | 46 | LOCAL REGRESSION | Regression models are typically "global". That is, all date are used simultaneously to fit a single model. In some cases it can make sense to fit more flexible "local" models. Such models exist in a general regression framework (e.g. generalized additive mo... |

### Spatial Data in R

- TEI : `corpus\papers\tei\Spatial Data in R - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Transforming raster data | Vector data can be transformed from lon/lat coordinates to planar and back without loss of precision. This is not the case with raster data. A raster consists of rectangular cells of the same size (in terms of the units of the CRS; their actual size may var... |
| low_priority_review | `DataSourceCandidate` | 46 | Raster data | Raster data is commonly used to represent spatially continuous phenomena such as elevation. A raster divides the world into a grid of equally sized rectangles (referred to as cells or, in the context of satellite remote sensing, pixels) that all have one or... |

### Spatial Panel Models of Crop Yield Response to Weather: Econometric Specification Strategies and Prediction Performance

- DOI : `10.1017/aae.2021.29`
- TEI : `corpus\papers\tei\div-class-title-spatial-panel-models-of-crop-yield-response-to-weather-econometric-specification-strategies-and-prediction-performance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables # of Obs. Mean Median S.D. Min. Max Corn yields by county, 1981-2012 (bu/ac) 33,344 115.3 116.0 33.5 0.0 236.6 Growing degree days (GDDs) for 8-32°C 33,344 149.9 151.0 12.0 92.5 180.7 Extreme growing degree days (GDDs) for 34°C or above 33,344 3.7... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Estimation Results and Prediction Performances | We estimate 14 different model specifications. First, we estimate the response coefficients using the balanced panel data . The estimation results for the models in Equations ( 3 )-( 10 ) are presented in Table 3 . The full estimation results are available... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | NonSpatial Panel Regression | A general crop yield response function specifying the relationships in Equation ( 1 ) can be presented as the panel regression equation: where g(⋅) is a nonlinear function of heat units, h it , with the response coefficients β, the second and third terms ar... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data and Spatial Weights Matrix | To implement a prediction performance comparison, we assemble county data to estimate the corn yield response function in the US. Because corn yields are heavily dependent on adequate rainfall or irrigation, we consider the US counties to the east of the 10... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Spatial Correlation in Crop Yields | In the general crop yield response function of Equation ( 2 ), an essential assumption of the panel regression is that observed crop choices are optimal and do not change (Deschênes and Greenstone, 2007) . Since crop choice is the optimized decision under t... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Spatial Aggregation in Weather | For a better description of the following model specifications, we estimate the county-level crop yield response function with the Parameter-elevation Relationship on Independent Slopes Model (PRISM) weather data, which is high resolution (4 × 4 km) grid ce... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial Correlation in Weather | It is widely noted that weather variables exhibit spatial correlation (Auffhammer et al., 2013; Dell et al., 2014) . The previous literature of the Ricardian approaches motivated the use of spatial lags on weather variables by their spatial correlation (Bay... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Specification of Heat Exposure Bins | As initiated in Schlenker and Roberts (2009) , nonlinear temperature impacts on crop yields are evident. Cooper et al. (2017) studied specification bias in crop yield response function and argued the necessity of a flexible function form. Carter et al. (201... |
| low_priority_review | `ModelTableCandidate` | 34 | GROBID table | Table 5 . |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 4 . |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Out-of-Sample Bootstrapping (1981-2012): 27 Years for Estimation 5 Years for Prediction with 1000 Replications Out-of- Welch Test for Equal Prediction Accuracy (Absolute t value Only) In-Sample Sample Mean Pooled FE RE SEM KKP SLX SAR Pooled FE RE SEM KKP S... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Spatial Statistics for Data Science

- DOI : `10.1007/s13253-023-00571-0`
- TEI : `corpus\papers\tei\Spatial Statistics for Data Science - Moraga.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Cross-validation | The performance indices presented above can be computed using a new dataset or by splitting an existing dataset into a training dataset to fit the model and a testing dataset for validation. In cross-validation, the data is randomly split into several disjo... |
| low_priority_review | `DataSourceCandidate` | 47 | The localmoran() function | The localmoran() function of the spdep package can be used to compute the Local Moran's I for a given dataset. The arguments of localmoran() include a numeric vector with the values of the variable, a list with the neighbor weights, and the name of an alter... |
| low_priority_review | `DataSourceCandidate` | 45 | Cross-validation | We can assess the performance of each of the methods presented above using K-fold cross-validation and the root mean squared error (RMSE). First, we split the data in K parts. For each part, we use the remaining K -1 parts (training data) to fit the model a... |
| low_priority_review | `DataSourceCandidate` | 45 | No spatial autocorrelation | Positive spatial autocorrelation Spatial autocorrelation can be assessed using indices that summarize the degree to which similar observations tend to occur near each other over the study area. Two common indices that are used to assess spatial autocorrelat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | A summary of the results can be inspected by typing summary(res). | The data frame res$summary.fitted.values contains the fitted values. The indices of the rows corresponding to the predictions can be obtained with inla.stack.index() specifying the tag "pred.pp" of the prediction stack. index <-inla.stack.index(stk.full.pp,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Stack with data for estimation and prediction | We now create a stack with the data for estimation and prediction that organizes data, effects, and projection matrices. We create stacks for estimation (stk.e) and prediction (stk.p) using tag to identify the type of data, data with the list of data vector... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Data | The meuse data from the sp package contains zinc and other soil-heavy metal concentrations collected at locations in a flood plain of the river Meuse near Stein, The Netherlands (Figure 14 .1). meuse.grid contains prediction grid locations for the meuse dat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Housing prices in Boston, Massachusetts, USA | The Boston housing prices are in the spData package (Bivand et al., 2022) , and can be obtained with the st_read() function of the sf package (Pebesma, 2022a) as follows. library(sf) library(spData) map <-st_read(system.file("shapes/boston_tracts.shp", pack... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Model-based geostatistics | Model-based geostatistics can be used to analyze spatial data related to an underlying spatially continuous phenomenon that have been collected at a finite set of locations. Model-based geostatistics employs statistical models to capture the spatial correla... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Observed Solanum plant species in Bolivia | In this example, we estimate the intensity of Solanum plant species in Bolivia from January 2015 to December 2022 which are obtained from the Global Biodiversity Information Facility (GBIF) database with the spocc package. We retrieve the data using the occ... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | A summary of the results can be inspected with summary(res). The object res$summary.fixed provides the mean and quantiles of the posterior distribution of the intercept and coefficients of the covariates. res$summary.fixed mean sd 0.025quant 0.5quant b0 3.8... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Spatial disease risk models | Bayesian hierarchical models enable to obtain smoothed disease relative risks by including covariates and random effects to borrow information from neighboring areas. Spatial disease risk models are commonly specified using a Poisson distribution for the ob... |
| low_priority_review | `truncated` |  |  | 7 autres candidats non affiches dans ce rapport |

### Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome

- DOI : `10.1371/journal.pone.0138456`
- TEI : `corpus\papers\tei\Guitet2015Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Environmental data | For all plots, we extracted from GIS all environmental variables assumed to influence forest growth that were freely accessible on available maps (Table 2 ). For continuous variables, we computed the mean values over the plot area, while for categorical var... |
| low_priority_review | `DataSourceCandidate` | 46 | Environmental data | For all plots, we extracted from GIS all environmental variables assumed to influence forest growth that were freely accessible on available maps (Table 2 ). For continuous variables, we computed the mean values over the plot area, while for categorical var... |
| low_priority_review | `DataSourceCandidate` | 45 | Satisfactory accuracy can be achieve for REDD+ operational scales | The comparison of our test dataset and training dataset showed that forest inventories with a sampling rate of between 0.1 and 0.5% estimated biomass with an accuracy <10% for large blocks (>100 km²) and for a large majority of 10 to 50-km² sites (respectiv... |
| low_priority_review | `DataSourceCandidate` | 45 | Satisfactory accuracy can be achieve for REDD+ operational scales | The comparison of our test dataset and training dataset showed that forest inventories with a sampling rate of between 0.1 and 0.5% estimated biomass with an accuracy <10% for large blocks (>100 km²) and for a large majority of 10 to 50-km² sites (respectiv... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Reference a Context Data used for AGB Predictive variables used for Model measurement modelling Locality Cover Main Resolution Field plot Very Remote GIS space Allometry Predicted RMSE (ha) vegetation (ha) High sensing layers range (Mg.ha -1 ) types b Remot... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Theme Description of variables for selected plots |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Reference a Context Data used for AGB Predictive variables used for Model measurement modelling Locality Cover Main Resolution Field plot Very Remote GIS space Allometry Predicted RMSE (ha) vegetation (ha) High sensing layers range (Mg.ha -1 ) types b Remot... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Theme Description of variables for selected plots |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### Spatial analysis and factors associated with leptospirosis in Santa Catarina, Brazil, 2001-2015

- DOI : `10.1590/0037-8682-0466-2020`
- TEI : `corpus\papers\tei\Spatial analysis and factors associated with leptospirosis in Santa Catarina Brazil 2001-2015.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables description Beta coefficient Standard error p-value R² Minimum temperature (°C) 0.25 0.03 <0.001 0.16 Mean temperature (°C) 0.26 0.04 <0.001 0.13 Maximum temperature (°C) 0.18 0.04 <0.001 0.07 Minimum altitude (m) -0.002 0.0002 <0.001 0.24 Mean al... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Statistical analysis | Initially, to evaluate the association between the incidence of leptospirosis in SC and climatic, environmental, and demographic factors, a multiple linear regression model was fitted. The dependent variable was the natural logarithm of the rate of leptospi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Figure 2 | shows a map with incidence rates of leptospirosis from 2001-2015 in all municipalities of SC. The highest incidences were found in the eastern and western portions of SC, indicating clusters of municipalities with similar incidence rates and a possible spat... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Linear regression model Spatial error model Coefficient p-value Coefficient p-value Intercept -0.13 0.89 1.00 0.46 Minimum altitude (m) -0.002 <0.0001 -0.002 <0.0001 Maximum temperature (°C) 0.09 0.02 0.04 0.45 Existence of risk area 0.22 0.09 0.11 0.39 R²... |

### Spatial autocorrelation in fitness affects the estimation of natural selection in the wild

- DOI : `10.1111/2041-210X.12448`
- TEI : `corpus\papers\tei\Spatial autocorrelation in fitness affects the estimation of natural selection in the wild.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Principal coordinate matrices of neighbour matrices | The PCNM method is a special case of a wider family of methods that are classically called Moran's eigenvectors maps. The general principle of MEM is based on the extraction of eigenvectors from a distance (or connectivity) matrix among spatial units (Dray,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | C O N T R O L L I N G F O R S P A T I A L A U T O C O R R E L A T I O N I N F I T N E S S | Our study showed that spatial units (i.e. nest boxes) in the study system are not independent in the context of Lande and Arnold's regression. This pseudoreplication caused a spatial autocorrelation in residuals of our selection models, which violates one o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | E F F E C T S O F S P A T I A L A U T O C O R R E L A T I O N O N S E L E C T I O N E S T I M A T I O N | The effects of spatial autocorrelation on regression coefficients are still actively debated in the literature with some authors arguing that regression coefficients are generally not severely affected by spatial autocorrelation (Hawkins et al. 2007) , whil... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Results | Significant and positive spatial autocorrelation in fitness was found at 208 m and 416 m (Fig. 2 ) where Moran's indexes were, respectively, equal to 0Á16 (SD = 0Á025) and 0Á12 (SD = 0Á022). A significant but weaker positive spatial autocorrelation was also... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | S E L E C T I O N A N A L Y S I S A N D G E O S T A T I S T I C S I N A B L U E T I T D A T A S E T | Selection on laying date, clutch size and incubation duration were estimated from their association with the number of fledglings, considered here as a proxy for fitness. Traits were standardized by year (zero mean and unit variance within each year), and r... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | S E L E C T I O N A N A L Y S I S A N D G E O S T A T I S T I C S O N S I M U L A T E D D A T A S E T S | Finally, we ran simulations to assess the relative efficiency in controlling for spatial autocorrelation in residuals of the four geostatistical models. We used a subset of the volcano data set in R (R Core Team 2014), which consists of a 10 m by 10 m grid... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Simultaneous autoregressive models: SAR-lag and SAR-err | The simultaneous autoregressive model (SAR) is a special case of GLS model, where spatial autocorrelation is taken into account using a spatial weight matrix. The neighbourhood matrix, A, is a n*n matrix of spatial weight, which represents a measure of the... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | SELECTION DIFFERENTIAL (Clutch size) Non-spatial model GLS model SAR-lag model SAR-err model PCNM model S(CS) 0Á138 AE 0Á018*** 0Á131 AE 0Á017*** 0Á125 AE 0Á017*** 0Á120 AE 0Á018*** 0Á109 AE 0Á017*** logLik À29 À34 À24 À26 À11 A I C 6 5 7 5 5 6 6 1 4 4 Mora... |

### Spatial distribution and determinants of HIV high burden in the Southern African sub-region

- DOI : `10.1371/journal.pone.0301850`
- TEI : `corpus\papers\tei\Adetokunboh2024HIVSouthernAfrica.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Data analysis | This study is a secondary data analysis from country-wide and community-based surveys. HIV prevalence for each included country was analyzed using the most recent DHS data. The analyses processes were as follows: a. The logistic regression analyses of assoc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Data analysis | This study is a secondary data analysis from country-wide and community-based surveys. HIV prevalence for each included country was analyzed using the most recent DHS data. The analyses processes were as follows: a. The logistic regression analyses of assoc... |

### Spatial distribution of wood volume in Brazilian savannas

- DOI : `10.1590/0001-3765201920180666`
- TEI : `corpus\papers\tei\SILVEIRA2019Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | eXPLOrATOrY ANALYSIS | The statistics of the wood volume (m 3 ha -1 ) obtained from field-based forest inventory indicate that average (48.5 m 3 ha -1 ) and median (44.7 m 3 ha -1 ) values are close to one another, indicating a symmetry in the distribution of the wood volume data... |
| low_priority_review | `DataSourceCandidate` | 45 | eXPLOrATOrY ANALYSIS | The statistics of the wood volume (m 3 ha -1 ) obtained from field-based forest inventory indicate that average (48.5 m 3 ha -1 ) and median (44.7 m 3 ha -1 ) values are close to one another, indicating a symmetry in the distribution of the wood volume data... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | WOOD VOLUMe MODeLLINg | All parameters used in our multivariate regression model had significant coefficients (Table II ) and the residuals were normally distributed (Shapiro-Wilk, p = 0.98), with a coefficient of determination (R²) of 0.55 and a mean absolute error (MAe) of 34.5%... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | WOOD VOLUMe MODeLLINg | All parameters used in our multivariate regression model had significant coefficients (Table II ) and the residuals were normally distributed (Shapiro-Wilk, p = 0.98), with a coefficient of determination (R²) of 0.55 and a mean absolute error (MAe) of 34.5%... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | WOOD VOLUMe MODeLLINg AND regreSSION KrIgINg | We used a stepwise regression technique based on the Akaike information criterion (AIC) to select the most significant independent variables to build the wood volume model. The total database was randomly divided into a fitting set (70% of the database) and... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | WOOD VOLUMe MODeLLINg AND regreSSION KrIgINg | We used a stepwise regression technique based on the Akaike information criterion (AIC) to select the most significant independent variables to build the wood volume model. The total database was randomly divided into a fitting set (70% of the database) and... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | SPATIAL DISTrIBUTION OF WOOD VOLUMe | Both the global map generated by the regression model (rMSe = 11.6 %) (Figure 6 ) and the map corrected by the regression kriging technique (Figure 7 ) revealed a decrease in the wood volume from the middle towards the northern portions of the state. This i... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | SPATIAL DISTrIBUTION OF WOOD VOLUMe | Both the global map generated by the regression model (rMSe = 11.6 %) (Figure 6 ) and the map corrected by the regression kriging technique (Figure 7 ) revealed a decrease in the wood volume from the middle towards the northern portions of the state. This i... |

### Spatial panel count data: modeling and forecasting of urban crimes

- DOI : `10.1007/s43071-021-00019-y(`
- TEI : `corpus\papers\tei\Spatial_panel_count_data_modeling_and_forecasting_of_urban_crimes_W4226320725.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Forecasting Pittsburgh's crime counts using spatial panel count data models | In this section, we begin by applying static Poisson spatial panel models to Pittsburgh's crime counts. To forecast the number of Part I crimes in the census tracts of Pittsburgh for each month of 2013, a one-step-ahead expanding window forecast is employed... |
| low_priority_review | `DataSourceCandidate` | 46 | Spatial panel count data models | The econometric framework proposed here is quite general, but takes into account the main features of the crime counts to be found in the empirical application below as documented in Chapter 2 of Liesenfeld et al. (2017) . We start with the static Poisson s... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Forecasting using the Poisson spatial panel model | As the focus of this paper is on forecasting, we now derive the minimum mean squared error (MMSE) predictor for the Poisson spatial panel model. We focus on one-step-ahead forecasts, which involves an evaluation of the conditional mean function (1) at t ¼ T... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Application | The proposed models will now be applied in a predictive exercise using the same data set as in Liesenfeld et al. (2017) on severe crime counts in Pittsburgh, PA. We briefly describe the data set and then present empirical results from fitting the Poisson sp... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Model (1) (2) (3) (4) Estimator PMLE PMLE PMLE qdGMM Estimates for Jan. 2008 to Dec. 2012 PartI tÀ1 0.057Ã Ã Ã ( 0.002 ) WPartI t 0.116Ã Ã Ã 0.124Ã Ã Ã 0.499Ã Ã Ã ( 0.018 ) ( 0.016 ) ( 0.004 ) WPartI tÀ1 0.058Ã Ã Ã 0.051Ã Ã Ã ( 0.020 ) ( 0.012 ) logðPartII... |

### Spatial prediction of plant invasion using a hybrid of machine learning and geostatistical method

- DOI : `10.1002/ece3.11605`
- TEI : `corpus\papers\tei\Shen2024Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 54 | / Study area | The homogeneous property of the FIA sampling design and its national sampling intensity of nearly one plot per 2400 hectares provides a unique opportunity to study plant invasions across time and space (Bechtold & Patterson, 2005) . The study area was subdi... |
| low_priority_review | `DataSourceCandidate` | 45 | / Cross-validation and performance evaluation | Cross-validation is a very useful tool for evaluating the performance of statistical models (Arlot & Celisse, 2010; Kohavi, 1995) . It helps understand how the model can be generalizable to an independent dataset, and it is often applied to estimate model p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / DISCUSS ION | The above results suggest that BRTOK and LASOK can successfully predict the general trend, but one needs to focus on the following three details in the utilization of these algorithms: 1. Prediction performance: Machine learning (ML) has become an outstandi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Invasive plants data | The U.S. Forest Inventory and Analysis (FIA) program has been collecting invasive plant occurrence and distribution through all public and private US forests for several decades. It has provided largescale samples and high-dimensional variables which can be... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | F I G U R E 3 | Relative importance of each variable as identified by BRT, BRTOK, and LASOK from 15 ecoregions that are associated with invasive plant cover (see Table 1 for ecological variable definition), which are shown in decreasing order. Technically, as machine learn... |

### Spatial prediction of soil properties using EBLUP with the Matérn covariance function

- DOI : `10.1016/j.geoderma.2007.04.028`
- TEI : `corpus\papers\tei\Spatial prediction of soil properties using EBLUP.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | (1) Zn concentration along the Meuse River | This famous example comes from Burrough and McDonnell (1998) where topsoil zinc concentration along the river Meuse, the Netherlands was observed. This dataset shows a strong trend and it is expected to be a good application for BLUP. The data are obtained... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | The Zn concentration along the Meuse River | First we determine parameters of the Matérn variogram of the data and residuals using the profile-likelihood method. Fig. 3a shows the log-likelihood contour as a function of r and ν for the data. The plot shows the optimum value of ν is around 1 with r val... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Methods of comparison | To see the benefit of the computation using more advanced and statistically sound BLUP, we compare it with methods conventionally used in pedometrics: (1) REML-EBLUP with the Matérn covariance function: define the trend function and design matrix M, estimat... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Soil pH data in the Hunter Valley | Fig. 7 shows the trend model (Eq. ( 23 )) fitted to the soil pH data, using REMLthe parameters are: β 0 = 7.14, β 1 = -0.0002, β 2 = 0.31 (RMSD = 0.67). It illustrates the decrease in soil pH about 1 unit with distance of 4 km from west to east, and the inc... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |

### Spatial process-based transfer learning for prediction problems

- DOI : `10.1007/s10109-024-00455-y`
- TEI : `corpus\papers\tei\Spatial_process_based_transfer_learning_for_prediction_problems_W4407028120.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | How our transfer learning works | In SpTrans, y and y s depend on the common explanatory variables X and X s , respec- tively. In general, such common explanatory variables improve transfer learning accuracy. However, spatial patterns in each region are usually mutually independent (e.g., e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Necessity of transfer learning to stabilize spatial prediction | Although the spatial process model was relatively stable for small samples, limitations arising from the small target dataset size persisted. For example, consider the spatial prediction of land prices (standardized to mean zero and variance one) in the Osa... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Learning algorithm | Although ẑ0 predicts the unobserved explained variable y 0 in the target area, it can be unstable given a small sample size. We address this challenge by introducing a pre-trained ẑ1 , … ,ẑ S to stabilize the prediction. The procedure for predicting y 0 in... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Model | Our objective was to improve spatial prediction accuracy in the target area through transfer learning from large samples in the source areas. We assumed the source and target areas to contain large and small data samples, respectively. As summarized in Fig.... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Concluding remarks | In this study, we developed SpTrans as a transfer learning method that considers spatial dependence and common patterns across the source and target areas. Unlike typical transfer learning algorithms that ignore spatial dependence, the proposed method achie... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Results | Figure 5 presents the median RMSE values and their 95% confidence bounds over the 200 simulations. Although the flexibility of GBDT is widely recognized, GBDT loc exhibited a suboptimal accuracy owing to the small sample size, as consistent with Fig. 1 . Th... |

### Spatial shopping behavior during the Corona pandemic: insights from a micro-econometric store choice model for consumer electronics and furniture retailing in Germany

- DOI : `10.1007/s10109-023-00408-x`
- TEI : `corpus\papers\tei\Spatial_shopping_behavior_during_the_Corona_pandemic_insights_from_a_micro_econo_W4362583278.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Further data processing | The street addresses of the survey respondents (residential address) and physical stores were geocoded automatically by accessing the OpenStreetMap address database (OSM Nominatim). Based on these coordinates, travel times between consumer and store locatio... |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Description Dummy variable indicating if consumer i is under 25 years old [1] or not [0] Dummy variable indicating if consumer i is at least 65 years old [1] or not [0] Dummy variable indicating if consumer i is male [1] or not [0] Dummy variable indicating... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 5 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables 2019 2021 Participa- Expendi- Participa- Expenditure tion Equa- ture Equa- tion Equa- Equation tion tion tion Store choice Store attraction ln number of items j 0.968*** (0.074) -0.083*** (0.003) 0.737*** (0.095) -0.190*** (0.005) Dumm... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables 2019 2021 Participa- Expendi- Participation Expenditure tion equa- ture equa- equation equation tion tion Store choice Store attraction ln number of items j 0.902*** (0.074) -0.016*** (0.002) 0.712*** (0.100) -0.081*** (0.002) Dummy Cr... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | DSM j | Dummy variable indicating if the physical CE store j is located in a shopping mall [1] or not [0] Clustering with competitors Hansen accessibility for spatial proximity of store j to all other K competitors (airline Dummy variables indicating if the physica... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Collection of store data | With respect to CE retailing, the inclusion criterion for consideration in the model analysis was that the respective (physical or online) store offered at least the following product range groups: "Electrical Household Appliances, Lighting (comprehensive)"... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Determinants of channel and store choice | For each of the three survey regions, one hurdle model consisting of two model parts was estimated. Tables 4 and 5 show the results with respect to CE and furniture shopping for the Middle Upper Rhine Region. Results for the other two survey areas can be fo... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Spatial shopping behavior during the Corona pandemic: insights… perceived burden of masks were also surveyed and integrated into the model as explanatory variables. The study approach demonstrates that online and physical retailers can be incorporated into... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Spatial shopping behavior during the Corona pandemic: insights… Routing Machine), with travel time being defined as the fastest route between origins and destinations in terms of car driving time in minutes. It was assumed that car travel time is the best p... |

### Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis

- DOI : `10.1186/s41043-022-00309-7`
- TEI : `corpus\papers\tei\Seboka2022Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 6 |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables Coefficient Standard error t-statistic Probability Robust VIF probability Intercept 0.244 0.037 6.56 0.000 0.000 Proportion poor wealth index Proportion poor sanitation -0.542 0.001 0.1731 0.0002 -3.108 3.120 0.002 0.001 0.0124 0.000 1... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables Mean STD Minimum Maximum Median Non- stationarity (p values) Proportion poor wealth index Proportion poor sanitation Proportion inadequate diet Proportion rural residents Proportion uneducated mothers -0.169 -0.131 0.066 0.243 0.338 0.... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables: the proportion of poor wealth index, poor GWR sanitation, inadequate diet, rural residents, and undedicated mothers Residual squares 6.28 Effective number 23.17 Sigma 0.149 AIC Multiple R-squared -280.232 0.419 Adjusted R-squared 0.374 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Modeling spatial relationships | Using 2019 survey data, spatial regression modeling was used to investigate determinants of observed spatial patterns of stunting among children under the age of five. Spatial processes may operate at local or global scales. Accordingly, the OLS, GWR, and M... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Spatial regression analysis | Ordinary least square OLS model was employed to explore spatial regression assumptions and estimate variable coefficients of selected explanatory variables on under-five stunting. The OLS regression identified predictors of each hot spot of under-five stunt... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Performance comparison of the global and local spatial regression models | The OLS, GWR, and MGWR models were used to investigate the relationships between under-five stunting and its predictors. To begin, global spatial regression models were used to investigate geographical predictors of stunting in children under the age of fiv... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Statistical analysis | This study used multiple spatial statistical models to analyze the geographical variations and trends of stunting among Ethiopian children under the age of five. Furthermore, we have employed global ordinary least squares (OLS) to assess the global relation... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 7 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Spatial variability of saturated hydraulic conductivity and its links with other soil properties at the regional scale

- DOI : `10.1038/s41598-021-86862-3`
- TEI : `corpus\papers\tei\Usowicz_2021_SpatialSaturatedHydraulicConductivity_s41598.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data analysis. | Classical statistics. Basic statistics with the mean, standard deviation, coefficient of variation, minimum, maximum, skewness, and kurtosis were calculated for each soil property. Both kurtosis and skewness values of 0 indicate in general symmetrical distr... |
| low_priority_review | `DataSourceCandidate` | 45 | Section 1 | The K value depends largely on the pore size distribution (PSD), especially on the share and continuity of relatively large pores (macropores) 9, [16] [17] [18] [19] [20] . In a study conducted by Kim et al. 21 , the area of the largest pores explained almo... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Spatially Varying Coefficient Model for Neuroimaging Data with Jump Discontinuities

- TEI : `corpus\papers\tei\Spatially Varying Coefficient Model for Neuroimaging Data With Jump Discontinuities.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 60 | Model Setup | We consider imaging measurements in a template and clinical variables (e.g., age, gender, and height) from n subjects. Let D represent a 3D volume and d and d 0 , respectively, denote a point and the center of a voxel in D. Let D 0 be the union of all cente... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Step (I. | 2) is to estimate η i (d) for all d ∈ D. We employ the local linear regression technique to estimate all individual functions η i (d). Let We develop an algorithm to estimate C i (d) as follows. Let K loc (•) be a univariate kernel function and ) be the res... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | β * (d 0 ) = (β 1 * (d 0 ), . . . , β p * (d 0 )) T be the true value of β(d 0 ) at voxel d 0 . We first establish the uniform convergence rate of { β(d 0 ) : d 0 ∈ D 0 }. Theorem 1. Under assumptions (C1)-(C4) |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | • (i) √ n[ β(d 0 ) -β * (d 0 )] → L N (0, Ω -1 X Σ y (d 0 , d 0 )) for any d 0 ∈ D 0 , where → L denotes convergence in distribution; • (ii) sup d 0 ∈D 0 // β(d 0 ) -β * (d 0 )// 2 = O p ( n -1 log(1 + N D )) Remark 1. Theorem 1 (i) just restates a standard... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | d 0 ; h s ) -βj * (d 0 ; h s ) and dm∈B(d 0 ,hs)∩D 0 ω(1) j (d, d m ; h s ) ∆j (d m ). Theo- rem 4 (iii) ensures that Σ( √ n βj * (d 0 ; h s )) is a uniform consistent estimator of Σ (1) j (d 0 ; h s ) across d 0 ∈ D 0 . Theorem 4 (iv) ensures that √ n{ βj... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | T 1 (h s ) = sup d 0 ∈D 0 dm,d m ∈B(d 0 ,hs)∩D 0 ωj (d 0 , d m ; h s )ω j (d 0 , d m ; h s ){ Σy (d m , d m ) -Σ y (d m , d m )} , T 2 (h s ) = sup d 0 ∈D 0 dm,d m ∈B(d 0 ,hs)∩D 0 {ω j (d 0 , d m ; h s ) - ω(0) j (d 0 , d m ; h s )}ω j (d 0 , d m ; h s )Σ y... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | K st (D β j (d 0 , d 0 ; h s-1 )/C n ) as s = 1. Let ∆j (d 0 ) = βj (d 0 ) -β j * (d 0 ) and ∆ j * (d 0 , d 0 ) = β j * (d 0 ) -β j * (d 0 ). It follows from Theorem 1 that D β j (d 0 , d 0 ; h 0 )/C n can be written as D β j (d 0 , d 0 ; h 0 )/C n = C -1 n... |

### Spatially explicit summary statistics for historical population genetic inference

- DOI : `10.1111/2041-210X.12489`
- TEI : `corpus\papers\tei\Spatially_explicit_summary_statistics_for_historical_population_genetic_inferenc_W1926750735.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1. (continued) Total number Total number of statistics of statistics according to according to Summary number of Summary number of Acronym statistic localities (l) Acronym statistic localities (l) Non-spatial Locality-wise statistics d Wx Euclidian di... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Moran's I (I), Variogram (V), Monmonier's algorithm (M) and Mantel's correlogram (C) | The remaining four SSS classes (Appendix S1) focus on estimating spatial genetic autocorrelation from a subset of the NSS (Table 1 ). Developed over half a century ago to test for spatial autocorrelation (Moran 1950 ), Moran's I (Table 1 ) is commonly used... |

### Spatially structured statistical network models for landscape genetics

- DOI : `10.1002/ecm.1355`
- TEI : `corpus\papers\tei\Spatially_structured_statistical_network_models_for_landscape_genetics_W2909968513.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 54 | Missing data | In previous sections, we assumed that all nodes in the network were fully observed and that one observation, y i , was obtained for each node, but this is unusual in practice. Consider the general case where there are n obs total observations at m nodes nod... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Correlation and partial correlation | A key component of an SSEN is the conditional dependence (i.e., structure) implied by the edges. When an edge exists between nodes, w ij [ 0, then nodes i and j are first-order neighbors and are considered connected (e.g., V 1 and V 2 , Fig. 3a ). If two no... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | CONCLUSIONS | There is an undeniable need for quantitative methods in landscape genetics that can be used to explore questions about spatial structure in genetic data sets. SA models provide a natural framework to investigate those questions. Spatial autocorrelation unde... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Simulated example | Observed genetic patterns may be produced by the combined influence of geographic distance, resistance, and barriers, rather than a single evolutionary process (Landguth and Cushman 2010) . The SA model can be used to account for proximity in terms of varia... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | CAR AND ICAR MODELS | If the SA model has a Gaussian error distribution, it can be written as where the "error" models are e $ Nð0; r 2 e IÞ and g $ Nð0; RÞ: The mean structure describes the conditional mean of the response given a set of covariates, if they are present. In Eq.... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Calculating edge weights | A SSEN can be used to represent landscape-genetic relationships, where nodes represent the location of individuals or sub-populations, and edges describe the functional relationship (e.g., animal movement or gene flow) between nodes. Thus, the resistance di... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Genetic distance Resistance model AIC D IBD IBD 22,518.94 D IBD IBR 22,520.23 D IBD IBB 22,527.61 D IBR IBD 22,589 D IBR IBR 22,573.6 D IBR IBB 22,588.43 D IBB IBD 20,414.75 D IBB IBR 20,399.52 D IBB IBB 20,342.68 |

### Spatially varying coefficient modeling for large datasets: Eliminating N from spatial regressions

- DOI : `10.1016/j.spasta.2019.02.003`
- TEI : `corpus\papers\tei\SVC_Murakami.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | An empirical study | As an illustration, GWR and M-SVC the Tokyo railway station (Tokyo_d) [km], share of green area in 1km grids (Green), and anticipated flooding depth (Flood) [m] . We include distance-based covariates (Station_d and Tokyo_d), which can confound with SVCs and... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | Model | This approach is based on the Moran coefficient (MC; Moran, 1950) , which is a diagnostic statistic of spatial dependence. MC for y = [y (s 1 ) , . . . , y(s N )] ′ is formulated as: where C is a symmetric spatial proximity matrix with zero diagonal entries... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Modeling | The cost for the eigen-decomposition of (I -11 ′ /N)C(I -11 ′ /N) is O(N 3 ), which is intractable for large N. Besides, if C is given using a distance-decay function like in our case, the N × N matrix must be stored before the decomposition. The modeling i... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Summary | Our approach is summarized in Fig. 1 . In the modeling step, we apply (i) a rank reduction, and each SVC is expressed as a linear combination of L approximate eigenvectors Ê (N × L). In the estimation step, we first apply (ii) a pre-compression, and the SVC... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Result | This section first quantifies influence from the following three approximations: (i) the eigenapproximation, (ii) the pre-compression, and (iii) the sequential estimation. Regarding (i), the original M-SVC model (M-SVC) and our M-SVC with the eigen-approxim... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Result ( N ≤ 12,000) | This section compares M-SVC (iii) to GWR assuming N ∈ {6000, 9000, 12,000} and K ∈ {2, 4, 6, 8}. Fig. 8 portrays the mean bias for the large-scale SVCs (left) and the small-scale SVCs (right). This result shows that the biases are quite small irrespective o... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Result (N ≤ 100,000) | The previous subsection shows that accuracy of M-SVC (iii) for small-scale β k decreases as N increases. To clarify whether M-SVC (iii) estimates remain accurate and computationally tractable for larger samples, we performed another simulations with N ∈ {20... |

### Spatio-Temporal Graph Convolutional Networks: A Deep Learning Framework for Traffic Forecasting

- TEI : `corpus\papers\tei\2026-04-23_paper_stgcn_traffic_forecasting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data Preprocessing | The standard time interval in two datasets is set to 5 minutes. Thus, every node of the road graph contains 288 data points per day. The linear interpolation method is used to fill missing values after data cleaning. In addition, data input are normalized b... |
| low_priority_review | `DataSourceCandidate` | 45 | Training Efficiency and Generalization | To see the benefits of the convolution along time axis in our proposal, we summarize the comparison of training time between STGCN and GCGRU in Table 3 . In terms of fairness, GCGRU consists of three layers with 64, 64, 128 units respectively in the experim... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Experimental Settings | All experiments are compiled and tested on a Linux cluster (CPU: Intel(R) Xeon(R) CPU E5-2620 v4 @ 2.10GHz, GPU: NVIDIA GeForce GTX 1080). In order to eliminate atypical traffic, only workday traffic data are adopted in our experiment [Li et al., 2015] . We... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Model MAE BJER4 (15/ 30/ 45 min) MAPE (%) RMSE HA 5.21 14.64 7.56 LSVR 4.24/ 5 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Model MAE PeMSD7(M) (15/ 30/ 45 min) MAPE (%) RMSE MAE PeMSD7(L) (15/ 30/ 45 min) MAPE (%) RMSE HA 4.01 10.61 7.20 4.60 12.50 8.05 LSVR 2.50/ 3.63/ 4.54 5.81/ 8.88/ 11.50 4.55/ 6.67/ 8.28 2.69/ 3.85/ 4.79 6.27/ 9.48/ 12.42 4.88/ 7.10/ 8.72 ARIMA 5.55/ 5.86/... |

### Spatio-Temporal Interpolation using gstat

- DOI : `10.18637/jss.v063.i15.`
- TEI : `corpus\papers\tei\Graler_2016_gstat_spatiotemporal_RJournal.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 49 | Application and illustration | The data set used is taken from AirBase foot_1 , the air quality data base for Europe provided by the European Environmental Agency (EEA). We focus on a single air quality indicator, particulate matter with a diameter less than 10 µm, measured at rural back... |

### Spatio-temporal Bayesian model selection for disease mapping

- DOI : `10.1002/env.2410`
- TEI : `corpus\papers\tei\Carroll2016Spatiotemporal.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Initial model selection structure | The initial model selection formula that we consider is a mixture of model linear predictors and is as follows: where α 0 is an intercept and w l provides the weight for the l th of L linear predictor alternatives, notated as ω lij . This weight is in the f... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | / Initial model selection structure | The initial model selection formula that we consider is a mixture of model linear predictors and is as follows: where α 0 is an intercept and w l provides the weight for the l th of L linear predictor alternatives, notated as ω lij . This weight is in the f... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Alternative linear predictors | The alternative linear predictors described here are associated with the four different model selection methodologies described in Section 2.2. The alternative linear predictors differ per fitted model selection extension and are chosen such that they repre... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Alternative linear predictors | The alternative linear predictors described here are associated with the four different model selection methodologies described in Section 2.2. The alternative linear predictors differ per fitted model selection extension and are chosen such that they repre... |

### Spatio-temporal mapping of sea floor sediment pollution in the North Sea

- DOI : `10.1007/3-540-26535-x_31`
- TEI : `corpus\papers\tei\Pebesma_Duin_2005_pcb_book_chapter.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Exhaustive information | The spatial pattern of PCB138 measurements (Fig. 1 ) shows a decreasing PCB138 concentration with increasing distance from the coast. Although the summary statistics of Table 1 indicate that the PCB138 concentrations decrease over time, Fig. 1 suggests that... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial correlation of ) , ( t s Z | is hard to infer for each year, as Table 1 tells that sample sizes are small. Fig. 2 however suggests that residual variability does not vary considerably over time. For that reason we assumed that residual spatial correlation is constant over time and we c... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial prediction | Cokriging predictions for the four main years under model (1), with cross variography shown in Fig. 4 , are shown in Fig. 5 . The cokriging is a four-variable universal cokriging with sea depth as predictor (or external drift) variable. Each variable has a... |

### Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill

- DOI : `10.1093/icesjms/fsx079`
- TEI : `corpus\papers\tei\Spatio_temporal_models_reveal_subtle_changes_to_demersal_communities_following_t_W2618167169.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | Diet classification. | We classified species based on their published dietary preferences. We use published diet data for each species (Aydin et al., 2007) to classify the dominant prey type for each species. We defined species diet as predominantly invertebrate (>80% of diet is... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Statistical model | We constructed separate models for each groundfish species to understand the spatial and temporal patterns of occurrence and abundance. We estimated a model for each species independently and subsequently combined the model outputs to generate a suite of mu... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Defining areas for comparison across the Gulf of Alaska | We identified eleven areas across the GOA to compare groundfish communities through time (Figure 1 ). Each area was bounded by the 50 and 150 m bathymetric isopleths, and by natural bathymetric breaks (canyons) resulting in irregularly shaped areas that ran... |

### Spatio-temporal networks: reachability, centrality and robustness

- DOI : `10.1098/rsos.160196`
- TEI : `corpus\papers\tei\Spatio_temporal_networks_reachability_centrality_and_robustness_W2463273966.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Spatio-temporal paths and distance measures | In general, a spatio-temporal path from node v 0 may visit multiple distinct vertices before reaching its destination node. A spatio-temporal path consisting of n ≥ 0 hops, starting with origin node v 0 at timestep t 1 , is described as the sequence of n +... |
| low_priority_review | `DataSourceCandidate` | 45 | US Domestic Flights (US Flights). | The flights network is constructed from actual take-off and landing times of domestic passenger flights in the USA in the month of February 2014. Each node is a US airport. Our approach to extracting transit speeds is similar to London Metro. Time zones are... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |

### Spatiotemporal Impacts of Ideology and Social Vulnerability on COVID-19 for the United States

- DOI : `10.1101/2023.07.21.23292785`
- TEI : `corpus\papers\tei\Spatial_Modeling_of_Sociodemographic_Risk_for_COVID_19_Mortality_W4385269757.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Data Assembly | Predictor data are collected from a number of sources: variable descriptions and sources are listed in Table 1 . All data were normalized based on a 0 to 1 scaling structure. Figure 2 shows the spatial distributions of a select set of independent variables.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Spatial Autocorrelation | The Moran's I statistic, measures spatial autocorrelation 34, 35, 42 . Here n is the number of spatial units, w i j are spatial weights, x is the variable being tested for autocorrelation with mean x, and W = ∑ i, j w i j . The Moran's I weight matrix speci... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | 10/15 | Delta Wave: Random Forest Feature Importance Delta wave random forest feature importance for housing composition, diabetes, minority status and language, and democratic voting percentages (2020 US presidential election). Other feature importance maps can be... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Regression Analysis and Geographically Weighted Random Forest | We construct regionalized Poisson regression models (with population as an offset) for each of the three time windows (Alpha, Delta, and Omicron), using all fifteen variables, with cumulative county-level death counts as the dependent variable. Normality as... |

### Spatiotemporal high-resolution prediction and mapping: methodology and application to dengue disease

- DOI : `10.1007/s10109-021-00368-0`
- TEI : `corpus\papers\tei\Spatiotemporal_high_resolution_prediction_and_mapping_methodology_and_applicatio_W4213094559.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Data and exploratory data analysis | The data were obtained from existing databases. Annual observations at district level on the population at risk (see Online Resource 1) and monthly dengue incidence at district level (see Fig. 1 ) were obtained from the Bandung Central Statistical Bureau (2... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | The estimated generalized Geoadditive-Gaussian Markov Random Field model and prediction | The first step in estimating the FGG-GMRF model given by Eq. ( 33 ) is the construction of a triangle mesh of the study area for the application of the Finite Element Method (FEM) and LSPDE approach. As described in Appendix 1, the accuracy of the FEM calcu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | 3 | Spatiotemporal high-resolution prediction and mapping:… of the total variance for the average temperature indicates that only a small part of the variability of the relative risk of dengue in districts and subdistricts is explained by the average temperatur... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | The fusion area-cell spatiotemporal generalized geoadditive-Gaussian field model | As observed above, combining low-resolution and high-resolution data to generate high-resolution predictions entails the risk of misalignment (Moraga et al. 2017; Utazi et al. 2019) . To handle misalignment, we first stack the corresponding objects of the a... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | 3 | Spatiotemporal high-resolution prediction and mapping:… data with linear covariates. However, methods that address area-to-cell misalignment in spatiotemporal non-Gaussian data with nonlinear covariates are less well known. This applies especially to Poisso... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Summary and conclusions | Effective and efficient control of a variety of spatial problems, including dengue disease abatement, requires data at a fine spatiotemporal scale. However, data availability at the same (especially fine) spatial scale is quite rare (Moraga et al. 2017; Uta... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Spatiotemporal high-resolution prediction and mapping:… of order one (RW1) or two (RW2) 9 (Bernardinelli et al. 1995; Martinez-Bello et al. 2017b; Schrödle and Held 2011) : with u k,t ∼ N 0, 2 k white noise, and 2 k denoting the variance of the RW process c... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Spatiotemporal high-resolution prediction and mapping:… temporal structure matrices by the geometric means of the diagonal elements of their inverses. However, the random walk models of order one (RW1) and two (RW2) are intrinsic Gaussian Markov random fiel... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Application: relative dengue risk at subdistrict level in Bandung, 2012-2018 | Bandung city is divided into 30 districts and 151 subdistricts. The districts are third level administrative units within a province, and the subdistricts are fourth level administrative units. Every district in Bandung city consists of a minimum of four su... |

### Spatiotemporal species distribution models of colony census and at-sea survey data for Fratercula cirrhata (Tufted Puffin) and F. corniculata (Horned Puffin) reveal long-term de...

- DOI : `10.1093/ornithapp/duag053`
- TEI : `corpus\papers\tei\Stoner_2026_KodiakPuffinDeclines_duag053_full.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Colony models | For colony data, we again used a VAST Poisson-link delta-model, but this time we set the encounter probability to 1 because absences were not recorded. We used species ordination (i.e., 1 factor for both species) to model spatial and spatiotemporal variatio... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | At-sea models | We modeled at-sea transect samples with a VAST Poisson-link delta generalized mixed effects model with a gamma error distribution (Thorson 2018 , Thorson et al. 2021b ) and applied area sampled as an offset. VAST uses a delta-model that estimates separate l... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Colony Models | To our knowledge, this is the first application of VAST species distribution models to assess trends in colony count data for seabirds. The best-supported VAST model for colony surveys provided strong explanatory power (78%) relative to the null model (Tabl... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | , see Online Supplementary Material for a color version of this figure). | Spatial and spatiotemporal model components explained more variation than combined vessel effects, "catchability," and habitat covariates (81% vs. <1%) within our model structure (Table 1 ). Vessel effects revealed boat size as a more important driver of su... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | At-Sea Models | The best-supported at-sea VAST model provided strong explanatory power (82%) relative to the null model (Table 1 ). Spatial components of modeled densities were weakly negatively correlated between species (-0.35), but the strong correlation of spatiotempor... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Puffin Environmental Responses and Habitat Use | Decadal patterns in abundance derived from at-sea surveys and shared between Kodiak Archipelago puffins generally varied more between than within periods characterized by similar climate within the Gulf of Alaska. Puffin populations declined from the late 1... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Spatial and spatiotemporal Data type variation Vessel effects Catchability formula Habitat formula PDE ΔAIC At-sea Yes Yes ∼month + time ∼depth + dist_shore 3 + 0.82 0 ssta + pdo Yes Yes ∼month + time ∼depth + dist_shore 3 + ssta 0.82 27.85 Yes Yes ∼month +... |

### Spatiotemporally explicit model averaging for forecasting of Alaskan groundfish catch

- DOI : `10.1002/ece3.4488`
- TEI : `corpus\papers\tei\Spatiotemporally_explicit_model_averaging_for_forecasting_of_Alaskan_groundfish__W2904556857.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 52 | / DATA | The data for this study were collated from two datasets provided by the National Oceanic and Atmospheric Administration (NOAA). Of primary use were the annual longline survey data of the Marine Ecology and Stock Assessment (MESA) Program conducted by the Au... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / INTRODUC TI ON | Forecasting is a vital component of fisheries management and furnishes necessary input for management decisions. However, forecasting models are often based on simplistic time series trend analyses, which do not capture spatial information. Parametric time... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / RE SULTS | Friedman tests for all four species revealed significant differences across model techniques (sablefish: χ 2 = 74.022, p ≤ 0.0001; Pacific cod: χ 2 = 365.501, p ≤ 0.0001; Pacific halibut: χ 2 = 152.471, p ≤ 0.0001; giant grenadier: χ 2 = 460.030, p ≤ 0.0001... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | / Spatial model with ARIMA | A spatially varying coefficient model as described above was fit over space for each year i = 1990, 1991, …, J -1. The fitted CPUE values for year i given as CORREIA were then used to fit an ARIMA model for each station, yielding the fitted ARIMA values Ỹsp... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Hierarchical Bayesian forecasting | To implement Bayesian forecasting methods, I chose a hierarchical independent Gaussian process model. Let Z i denote the observed data, and O i be the corresponding true values for station s r , r = 1, …, n at time and N = n × (J -1) be the total number of... |

### Special Issue: Precision Agriculture TEMPORAL VARIATION AND SPATIAL DISTRIBUTION OF RELATIVE INDICES OF LEAF CHLOROPHYLL IN GRAPEVINE cv. CHARDONNAY

- DOI : `10.1590/1809-4430-Eng.Agric.v39nep74-84/2019`
- TEI : `corpus\papers\tei\TEMPORAL VARIATION AND SPATIAL DISTRIBUTION OF RELATIVE INDICES OF LEAF CHLOROPHYLL IN GRAPEVINE cv. CHARDONNAY.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | TABLE 1 . |
| low_priority_review | `ModelEvidenceCandidate` | 53 | MATERIAL AND METHODS | The study was conducted in a commercial wine grape orchard (Vitis vinifera L.), cv. 'Chardonnay', with a total area of 1.10 ha, located in the municipality of Espírito Santo do Pinhal, state of São Paulo, Brazil (coordinates: 22º 10' 49.1" S and 46º 44' 28.... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 4 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | DAP Model Nugget effect Level Range (m) SDI (%) RMSE Area 1 41 Spherical 18.09 20.66 55.10 3.61 W 4.39 57 Exponential 9.71 14.89 5.20 0.80 W 3.93 64 Exponential 7.74 16.25 20.00 4.66 W 3.77 78 Exponential 4.57 9.36 45.78 10.42 M 2.64 85 Exponential 4.32 7.6... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 5 . |

### Statistical parametric simulation studies based on real data

- DOI : `10.1002/9780470594001`
- TEI : `corpus\papers\tei\sauer_2026_real_data_simulation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 52 | Parametric DGMs and other options | Parametric DGMs We refer to the DGMs employed in parametric simulations, which are the focus of this paper, as parametric DGMs. Such DGMs correspond to parametric stochastic models that can be represented in closed form (Morris et al., 2019; Schreck et al.,... |

### Statistical stream temperature modelling with SSN and INLA: an introduction for conservation practitioners

- DOI : `10.1139/cjfas-2023-0136`
- TEI : `corpus\papers\tei\Struthers2024BanffStreamTemperature.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Results | The AugTw values spanned a range of 11 • C (min = 2.6; max = 13.6) throughout the study area, with an average value of 6.8 • C (±2.3 SD). In general, the coldest temperatures were recorded in the Forty-Mile Creek watershed (mean = 5.7 • C ± 2.1 SD), and the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Data exploration | We first examined the raw data for possible outliers and relationships following methods outlined by Zuur et al. (2010) . Any hourly temperature values greater than 15 • C were flagged (i.e., uncharacteristically high) and carefully examined before being ex... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model performance | Model performance was assessed by implementing an LOOCV procedure by extracting the posterior-fitted values, and then subtracting these values from the observed values to calculate the root mean square error (RMSE) and mean absolute error (MAE) statistics:... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Model terms | We used a geographic information system (ArcGIS 10.8) to derive three landscape-scale covariates at the location of each stream temperature logger: elevation (m), drainage contributing area (km 2 ; log-10 transformed), and reach slope (%). Elevation can be... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Model Model framework description Fixed effects Model type AIC/WAIC r 2 RMSE MAE SSN SSN-1 Elevation, Reach Slope, Lake Effect Spatial 353 0.71 1.23 0.74 SSN-2 Elevation, Reach Slope, Lake Effect Non-spatial 404 0.54 1.53 1.11 INLA INLA-1 Elevation, Reach S... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |

### Structure identification and variable selection in geographically weighted regression models

- DOI : `10.1080/00949655.2017.1311896`
- TEI : `corpus\papers\tei\Structure identification and variable selection in geographically weighted regression models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Step | Remark: In general, the GWGlasso method leads to a mixed GWR model when the irrelevant explanatory variables (if any) are removed. With the above notations, the mixed GWR model is of the form The GWGlasso method can also yield the shrunk estimates of the sp... |

### Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer

- DOI : `10.1007/s10640-021-00536-2`
- TEI : `corpus\papers\tei\Schutt2021Systematic.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 53 | Choice of the Meta-Analytic Model | Multivariate meta-analytic models including moderating variables have become a standard framework to help explain the very likely presence of heterogeneity in effect sizes in applied economic research (Stanley and Doucouliagos 2012; Ringquist 2013 ). 13 Acc... |
| low_priority_review | `DataSourceCandidate` | 53 | Choice of the Meta-Analytic Model | Multivariate meta-analytic models including moderating variables have become a standard framework to help explain the very likely presence of heterogeneity in effect sizes in applied economic research (Stanley and Doucouliagos 2012; Ringquist 2013 ). 13 Acc... |
| low_priority_review | `DataSourceCandidate` | 46 | Data Characteristics | The data characteristics reveal that on average studies working with larger samples tend to report smaller estimates. By contrast, studies based on sales data collected at individual house level do not differ significantly from studies using assessed values... |
| low_priority_review | `DataSourceCandidate` | 46 | Data Characteristics | The data characteristics reveal that on average studies working with larger samples tend to report smaller estimates. By contrast, studies based on sales data collected at individual house level do not differ significantly from studies using assessed values... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 4 ( |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | (7) On NPL -0.026 (0.090) 0.029 (0.065) -0.046 (0.045) 0.086 (0.086) -0.017 (0.018) 0.007 (0.049) 0.026 (0.023) -0.016 (0.015) 0.039 (0.027) -0.084 (0.089) 184 0.613 (6) Non-hazardous site -0.108*** (0.033) 0.021 (0.047) 0.064* (0.035) 0.074 (0.063) -0.022... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 4 ( |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | (7) On NPL -0.026 (0.090) 0.029 (0.065) -0.046 (0.045) 0.086 (0.086) -0.017 (0.018) 0.007 (0.049) 0.026 (0.023) -0.016 (0.015) 0.039 (0.027) -0.084 (0.089) 184 0.613 (6) Non-hazardous site -0.108*** (0.033) 0.021 (0.047) 0.064* (0.035) 0.074 (0.063) -0.022... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Subsample Analysis | Several moderators are not included in the baseline regression shown in column (1) due to missing observations or because these moderators only serve as replacements for explanatory variables already included. In a first step, I add these moderators to the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Subsample Analysis | Several moderators are not included in the baseline regression shown in column (1) due to missing observations or because these moderators only serve as replacements for explanatory variables already included. In a first step, I add these moderators to the... |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### TABRED: ANALYZING PITFALLS AND FILLING THE GAPS IN TABULAR DEEP LEARNING BENCHMARKS

- TEI : `corpus\papers\tei\rubachev_2025_tabred.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | PARTICULATE-MATTER-UKAIR-2017 | Tags: Tabular, Timesplit Needed, Timesplit Possible #Samples: 394299 #Features: 6 Year: 2017 Comments: Hourly particulate matter air pollution data of Great Britain for the year 2017. Time features available, prior work uses random split. There are only 6 f... |
| low_priority_review | `DataSourceCandidate` | 45 | RESULTS | In this section, we evaluate all techniques outlined above. Results are summarized in Table 3 . Below, we highlight our key takeaways. GBDT and MLP with embeddings (MLP-PLR) are the overall best models on the TabReD benchmark. These findings suggest that nu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | A.1 EXPLORATION OF TABRED DATASETS: SHIFTS | In this section, we explore the temporal shift aspect of the TabReD datasets. We plot standard deviations of MLP ensemble predictions over time together with model errors over the same timeframe. The plots are in Figure 2 . These plots show a more nuanced v... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | VESSEL POWER S | Tags: Synthetic or Untraceable, Tabular, Timesplit Needed, Timesplit Possible #Samples: 546543 #Features: 10 Year: 2022 Comments: Synthetic version of Vessel Power dataset YEAR Tags: HomE #Samples: 515345 #Features: 90 Year: 2011 Comments: This dataset desc... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | A CLOSER LOOK AT THE EXISTING TABULAR DL BENCHMARKS | In this section, we take a closer look at the existing benchmarks for tabular deep learning. We analyze dataset sizes, number of features, the presence of temporal shift and its treatment. We also point out the issues of some datasets that we find notable.... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | F DETAILED ACADEMIC DATASETS OVERVIEW | In this section, we go through each dataset, and list its problems and prior uses in literature. We specify whether time-based splits should preferably be used for the dataset and whether it is available (e.g. datasets come with timestamps). We also adhere... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Dataset # Samples # Features Source Task Description Sberbank Housing 28K Ecom Offers 160K Homesite Insurance 260K HomeCredit Default 381K (1.5M) 696 392 119 299 Cooking Time 319K (12.8M) 192 Delivery ETA 350K (17.0M) 223 Maps Routing 279K (13.6M) 986 Weath... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### THE ROLE OF NONFARM INFLUENCES IN RICARDIAN ESTIMATES OF CLIMATE CHANGE IMPACTS ON US AGRICULTURE

- DOI : `10.1093/ajae/aaz047`
- TEI : `corpus\papers\tei\The Role of Nonfarm Influences in Ricardian Estimates of Climate Change Impacts on US Agriculture.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Climate Data | Climate data are obtained from two sources. The primary source is Schlenker and Roberts (2009) , which provides a detailed daily gridded data set for 1950-2005 based on the interpolation of daily weather station data and monthly gridded data from the PRISM... |
| low_priority_review | `DataSourceCandidate` | 48 | Socioeconomic Data | Following the literature, the analysis also includes control variables, namely, population density and income per capita ( online 11 The four additional CGMs are the second generation Canadian Earth System Model (CanESM2), the Community Climate System Model... |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | 2012 0.028 [2.7] À0.358 [À5.61] 26.1 [6.5] 0.000792 [10.22] 0.208 [11.08] À0.000351 [À6.67] 1,790 Recent Cross-sections 2002 2007 0.00982 0.00774 [0.9] [0.89] À0.463 À0.276 [À6.77] [À5.14] 16.3 7.9 [3.73] [2.32] 0.00148 0.00098 [11.02] [11.34] 0.278 0.174 [... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 8 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Eastern Nonurban Counties With Complete Data (n ¼ 1,790) With Incomplete Data (n ¼ 2,236) M Min Mmax r l min max r Soil quality controls: Average water capacity 0.150 0.070 0.225 0.026 0.147 0.070 0.225 0.027 (fraction) Clay content (%) 28.2 4.2 5... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Independent 2009 2010 2011 2012 2013 2014 2016 variables A. Nonirrigated Cropland Cash Rent Degree-days 0.0878 0.115 0.101 0.103 0.0833 0.101 0.123 (10-30 C) [5.84] [7.89] [7.01] [6.45] [4.94] [6.03] [7.27] Degree-days (>30 C) |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### THE SPATIAL CONFOUNDING ENVIRONMENT

- TEI : `corpus\papers\tei\ICLR-2024-space-the-spatial-confounding-environment.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | DataCollection Treatment Spatial Unit Region #Covariates #Nodes #Edges SpaceEnv Type #SpaceDatasets Social Vulnerability and Welfare census tract Texas 16 6,828 21,585 cdcsvi_limteng_hburdic_cont continuous 12 cdcsvi_nohsdp_poverty_cont continuous 11 cdcsvi... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Name Description Training data X obs , A and Ỹ Counterfactuals Ỹ a for each treatment value a ∈ A, computed with Eq. (1). For contin- uous treatments, a discretization of /A/ = 100 values is used Graph and coordinates A list of edges and coordinate matrix T... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Sharing and documentation of collections and environments | The SpaceEnvs supported in our Python package are publicly available through our Harvard Dataverse research repository. The metadata for each generated environment is contained in their corresponding entry at our Harvard Dataverse repository, including the... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 9 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |

### The CAMELS data set: catchment attributes and meteorology for large-sample studies

- DOI : `10.1016/S0022-1694`
- TEI : `corpus\papers\tei\addor_2017_camels.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 56 | Comparison with the MOPEX data set | The CAMELS data set is similar to the data set produced for MOPEX (Duan et al., 2006; Schaake et al., 2006) in that it provides hydroclimatic time series and geophysical attributes for a large number of basins in the CONUS. MOPEX data have been used in a la... |
| low_priority_review | `DataSourceCandidate` | 45 | Location and topography | Location information and topographic indices were extracted for each catchment by N15 (Table 1 ). We display these attributes on maps to introduce the main topographic features of the CONUS. Elevation obviously exerts a key control on catchment behavior (Fi... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Attribute Description Unit Data source References gauge_id catchment identifier (eight-digit USGS - N15 -USGS data hydrologic unit code) huc_02 region (two-digit USGS hydrologic unit code) - N15 -USGS data gauge_name gauge name, followed by the state - N15... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Attribute Description Unit Data source References p_mean mean daily precipitation mm day -1 N15 -Daymet * pet_mean mean daily PET, estimated by N15 us- mm day -1 N15 -Daymet * ing Priestley-Taylor formulation calibrated for each catchment aridity aridity (P... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Attribute Description Unit Data source References q_mean mean daily discharge mm day -1 N15 -USGS data * runoff_ratio runoff ratio (ratio of mean daily discharge to mean daily - N15 -USGS data * Eq. (2) in Sawicz et al. (2011) precipitation) stream_elas str... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Attribute Description Unit Data source References forest_frac forest fraction - N15 -USGS data lai_max maximum monthly mean of the leaf area index (based - MODIS * on 12 monthly means) lai_diff difference between the maximum and minimum - MODIS * monthly me... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Attribute Description Unit Data source References soil_depth_pelletier depth to bedrock (maximum 50 m) m Pelletier et al. (2016) soil_depth_statsgo soil depth (maximum 1.5 m; layers marked as water and m Miller and White (1998) bedrock were excluded) -STATS... |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### The Effect of Weather Conditions on Fertilizer Applications: A Spatial Dynamic Panel Data Analysis

- DOI : `10.1023/A:1018789623581`
- TEI : `corpus\papers\tei\2026-04-23_paper_bille_rogna_weather_fertilizer_spatial_dynamic_panel.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 52 | Data description | In this Section we briefly introduce a description of the data used in our empirical analysis. The dependent variable is the amount of fertilizer applied on a given portion of agricultural land. Relying on data related to quantities at national level would... |
| low_priority_review | `DataSourceCandidate` | 46 | Data Interpolation | We found several missing values over time in both the price of agricultural outputs (PAO) and the price of fertilizer (PF), especially for the latter one. To avoid the elimination of a large number of cells as well as to allow for the inclusion of these rel... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Conclusions | The present paper analyse the relation between abnormal weather conditions and fertilizer applications at world level, by considering four macro-regions -Europe (CAP), South America, South-East Asia and Africa -and using a recent dataset of gridded data whi... |
| low_priority_review | `ModelEvidenceCandidate` | 58 | Controlling for Spatial Error Correlations | Although the model in equation ( 1 ), or equivalently (2), is considered quite general in its form, in this paper we also allow for the possibility of the error terms to be spatially correlated. Several statistical hypothesis testing that check for the pres... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Model Specification | In this Section we provide details on the model specification to study the effect of extreme weather conditions on the use of fertilizers in Europe, South America, South-East Asia and Africa. More in general we try to specify the most appropriate and flexib... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Discussions on Spatial Error Correlations and Fertilizer Prices | In this Section we propose to re-estimate the model in equation ( 2 ), by controlling for spatial error autocorrelations to improve estimation efficiency and by including fertilizer (Urea) prices, since their omission could bias the estimates. Additionally,... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Yeo-Johnson Power Transformation and Robustness Checks | In this Section we briefly report the main results of some robustness checks of our model specification in equation ( 2 ), i.e. the estimation results are almost the same in terms of both the sign and the magnitude for the majority of the regressors conside... |

### The False Dilemma: Bayesian vs. Frequentist * 1

- TEI : `corpus\papers\tei\2026-04-23_paper_inla_approximate_bayesian_inference_latent_gaussian.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 58 | Metaphysical values: | by their writings, we can extract some information about scientist's thoughts. Knowledge is framed by feelings, emotions, facts and, even, faiths. How to consider, then, classical and continuous disputes among the full range of possible positions between re... |

### The GWmodel R package: Further Topics for Exploring Spatial Heterogeneity using Geographically Weighted Models

- TEI : `corpus\papers\tei\Lu_2014_GWmodel_further_topics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| low_priority_review | `ModelEvidenceCandidate` | 58 | GW summary statistics | Although simple to calculate and map, GW summary statistics can act as a vital precursor to an application of a subsequent GW model. For example, GW standard deviations will highlight areas of high variability for a given variable; areas where a subsequent... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Basic and mixed GW regression | The basic form of the GW regression model is 0 1 where i y is the dependent variable at location i; ik x is the value of the kth independent variable at location i; m is the number of independent variables; 0 i β is the intercept parameter at location i; ik... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Dublin 2004 voter turnout data | The DubVoter data is the main study data set and is used throughout sections 3 to 5 and section 7. This data is composed of nine percentage variables foot_0 322 = n , measuring: (A) voter turnout in the Irish 2004 Dáil elections and (B) eight characteristic... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | US 2004 election data | The USelect data is only used in section 6, for demonstrating a GW DA. It consists of the results of the 2004 US presidential election at the county level ( 3111 = n ), together with a collection of socio-economic (census) variables (27) . A variant of this... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Heteroskedastic GW regression | Basic GW regression assumes that the error term is normally distributed with zero mean and constant (stationary) variance over the study region (𝜀 𝑖 ~𝑁(0, 𝜎 2 )). An extension of GW regression is possible, which allows a non-stationary error variance ( 𝜀 𝑖... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Local collinearity diagnostics for a basic GW regression | The problem of collinearity amongst the predictor variables of a regression model has long been acknowledged and can lead to a loss of precision and power in the coefficient estimates (42) . This issue is heightened in GW regression since: (A) its effects c... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Multiple hypothesis tests with GW regression | For GW regression, pseudo t-values can be used to test, in a purely informal sense, for evidence of local coefficient estimates that are significantly different from zero (e.g. 49). For each coefficient estimate, 𝛽 � 𝑘 (𝑢, 𝑣) at location i, the pseudo t-val... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Concluding remarks | This study, together with its companion study (23) , demonstrates the application of a wide range of techniques for investigating spatial heterogeneity, using functions provided by the GWmodel R package. Topics include that of (i) GW summary statistics, (ii... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Variable Intercept DiffAdd LARent SC1 Unempl p-value 0.35 0.17 0.28 0.02 0.00 Variable LowEduc Age18_24 Age25_44 Age45_64 p-value 0.19 0.04 0.29 0.19 The optimal bandwidth for the basic GW regression is found at N = 109 in accordance to an automatic AICc ap... |

### The Impact of Energy Price on CO2 Emissions in China: A Spatial Econometric Analysis

- DOI : `10.1016/j.scitotenv.2019.135942`
- TEI : `corpus\papers\tei\The impact of energy price on CO2 emissions in China - A spatial econometric analysis.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . Main Results from Spatial Panel Data Models |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . Decomposition of Marginal Impact |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 . Sensitivity and Robust Analyses |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables (1) SLR (2) SEM (3) SAC lnEP -0.165*** -0.161** -0.161*** (0.056) (0.066) (0.061) lnPOP 0.508*** 0.650*** 0.556*** (0.152) (0.143) (0.157) lnURB 0.402*** 0.352*** 0.356*** (0.131) (0.121) (0.124) lnPGDP 0.657*** 0.837*** 0.772*** (0.058) (0.049) (... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Journal Pre-proof Variables Direct effect Indirect effect Total effect lnEP -0.169*** -0.070** -0.239*** (0.053) (0.035) (0.084) lnPOP 0.522*** 0.206*** 0.727*** (0.156) (0.071) (0.211) lnURB 0.426*** 0.172** 0.598*** (0.137) (0.069) (0.195) lnPGDP 0.667***... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Journal Pre-proof Variables (1) DSAR (2) LSLR (3) LSEM (4) LSAC Lag.lnCO2 1.295*** -- -- -- (0.117) -- -- -- lnEP -0.186*** -- -- -- 0.058 -- -- -- Lag. lnEP -- -0.180*** -0.143** -0.161*** -- (0.056) (0.060) (0.060) lnPOP 0.738*** 0.618*** 0.678*** 0.623**... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | J o u r n a l P r e -p r o o f | We investigate this research question by applying a longitudinal data at the Chinese provincial level. The focus on regions is warranted because regional carbon emissions are closely linked to key structural factors such as local economic development level,... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | J o u r n a l P r e -p r o o f | China's current energy markets, where each Chinese region sets its own energy market trading rules relatively independent from others, and energy trading is generally carried out within the region but less frequently across regions. To increase the role of... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Test of Spatial Effect and Model Selection | Before estimating any spatial econometric models, it is essential to test the existence of spatial effects in our sample. Following methods recommended by Elhorst (2010) , we applied three different tests to validate the existence of spatial effect, namely... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Lagrange Multiplier (LM) test to determine whether to establish a spatial lag regression model specified in Equation 5 or a spatial error model specified in Equation 6. We estimated four different non-spatial panel data models and contrast each model's esti... |

### The Importance of Scale for Spatial-Confounding Bias and Precision of Spatial Regression Estimators

- DOI : `10.1214/10-STS326`
- TEI : `corpus\papers\tei\paciorek_2010_spatial_scale.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | Analytic Framework | To consider bias from unmeasured spatially varying confounders, take the following model as the data-generating mechanism, with the notation as in Section 1. For each location, s, suppose the correlation of X(s) and Z(s) over repeated sampling at the locati... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | CASE STUDY: BIRTHWEIGHT AND AIR POLLUTION | Chronic health effects of ambient air pollution in developed countries involve small relative risks, but are of considerable public health importance because of widespread exposure. Epidemiologic studies attempt to estimate a small effect from data with hig... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Identifiability | A key consideration in the basic model (2) is identifiability of β x and g(s). A closely-related question is how the estimation procedure attributes variability between the exposure and the spatial residual term (the random effects). In the simple linear mo... |

### The Importance of Scale in Spatially Varying Coefficient Modeling

- DOI : `10.1080/24694452.2018.1462691`
- TEI : `corpus\papers\tei\The Importance of Scale in Spatially Varying Coefficient Modeling.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Model Parameter Notation Case GWR Bandwidth b {0.2, 0.6, 1.0, 2.0} GWRa Adaptive bandwidth b(s i ) ad {0.1, 0.3, 0.5, 1.0} ESF Ratio of predictor variables being selected q {0.2, 0.4, 0.6, 0.8} RE-ESF Scale a k {0.2, 0.6, 1.0, 2.0} Variance r k {0.1, 1.0} |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Global Estimation (ESF and RE-ESF) | This global approach estimates the SVCs by fitting spatial process models. The spatial expansion and ESFbased approaches are representative of such methods, where the former fits trend surface models, whereas the latter fits ESF models describing spatially... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatially Varying Coefficient Modeling | The Overarching SVC Model A linear SVC model is formulated as follows: where y i represents the response variable at the ith sample site, with i 2 f1; :::; Ng, x i,k represents the kth predictor variable, with k 2 f1; :::; Kg, e i represents the disturbance... |

### The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps

- DOI : `10.1600/036364425X17466502618876`
- TEI : `corpus\papers\tei\Wootton2025LimitedLegacy.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Detecting the legacy of post-glacial recolonization on the Alpine floristic structure- | We examined whether there is a signal of post-glacial recolonization in the spatial structure of the Alpine flora by regressing dispersal ability, standardized species richness, standardized phylogenetic diversity and phylogenetic endemism against all combi... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | RESULTS | Floristic spatial structure-All floristic measures showed strong spatial patterns (Fig. 2 ). In general, mean dispersal ability and standardized phylogenetic diversity were greater at the periphery of the Alps and decreased towards the interior. Standardize... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | MATERIALS AND METHODS |  |

### The Practical Use of Semiparametric Models in Field Trials

- DOI : `10.1198/1085711031265`
- TEI : `corpus\papers\tei\Semiparametric models in field trials.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 62 | Model Selection Criteria | If the graph of residuals against a covariate suggests that a smooth function of the covariate be included in the model, it is necessary to select a span for the smoother by minimizing a suitable criterion. Four such criteria are: cross-validation (CV) (Sto... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | ADDITIVE AND SEMIPARAMETRIC MODELS | Additive models (Hastie and Tibshirani 1986, 1990 ) are a generalization of linear regression models. Let •(:) be the expected value of the response, Y = (Y 1 ; : : : ; Y n ), corresponding to explanatory variables X = (X 1 ; : : : ; X q ). In a linear mode... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | OTHER SPATIAL MODELS | In Sections 5.1.2 and 5.2.2 we compared the semiparametric spatial analysis with a loess smoother with conventional analysis of variance. In this section we look at another parametric approach to modeling the spatial variation in variety trials. Gilmour et... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Row span Bed span df AICc AIC GCV CV 1 1 3.0 0.128 ¡1.928 0.216 0.216 1 30/34 3.3 0.094 ¡1.996 0.211 0.205 14/16 20/34 4.6 0.001 ¡2.071 0.185 0.185 12/16 20/34 5.0 ¡0.018 ¡2.098 0.181 0.181 10/16 15/34 6.7 ¡0.071 ¡2.169 0.170 0.171 10/16 10/34 8.7 ¡0.098 ¡2... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 . |

### The Wald Test of Common Factors in Spatial Model Specification Search Strategies

- DOI : `10.1017/pan.2020.23`
- TEI : `corpus\papers\tei\Juhl2020Wald.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 56 | . An Illustrative Example of the Different Spatial Processes | Before outlining the alternative spatial model specifications, it is useful to contrast the different spatial processes with respect to their substantive implications for empirical political science research. Spillover effects occur whenever the behavior (e... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | . An Illustrative Example of the Different Spatial Processes | Before outlining the alternative spatial model specifications, it is useful to contrast the different spatial processes with respect to their substantive implications for empirical political science research. Spillover effects occur whenever the behavior (e... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | . An Illustrative Example of the Different Spatial Processes | Before outlining the alternative spatial model specifications, it is useful to contrast the different spatial processes with respect to their substantive implications for empirical political science research. Spillover effects occur whenever the behavior (e... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Substantive and Residual Dependence in Cross-Sectional Models | In regression analyses utilizing cross-sectional data, three different types of interaction effects can be distinguished that generate spatial autocorrelation in the dependent variable. First, endogenous interaction effects occur whenever the units' outcome... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Substantive and Residual Dependence in Cross-Sectional Models | In regression analyses utilizing cross-sectional data, three different types of interaction effects can be distinguished that generate spatial autocorrelation in the dependent variable. First, endogenous interaction effects occur whenever the units' outcome... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Substantive and Residual Dependence in Cross-Sectional Models | In regression analyses utilizing cross-sectional data, three different types of interaction effects can be distinguished that generate spatial autocorrelation in the dependent variable. First, endogenous interaction effects occur whenever the units' outcome... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Motivation | The correct specification of the inherently unknown spatial process generating observable patterns of interrelatedness among the units of analysis constitutes a considerable challenge in crosssectional studies. In particular, distinguishing substantively me... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Motivation | The correct specification of the inherently unknown spatial process generating observable patterns of interrelatedness among the units of analysis constitutes a considerable challenge in crosssectional studies. In particular, distinguishing substantively me... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Motivation | The correct specification of the inherently unknown spatial process generating observable patterns of interrelatedness among the units of analysis constitutes a considerable challenge in crosssectional studies. In particular, distinguishing substantively me... |

### The black box of regional growth

- DOI : `10.1007/s10109-020-00341-3`
- TEI : `corpus\papers\tei\The_black_box_of_regional_growth_W3128558887.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Explanatory power of the models 0.072-0.193 N/A 0.084-0.362 0.50-0.71 Modelling approach OLS Synthetic con- trol method OLS Spatial lag model; Spatial Durbin model Explanatory variables Controls Entrepreneurship Initial regional GDP (conver- capital (number... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| low_priority_review | `ModelEvidenceCandidate` | 50 | From growth regression to systematic growth deviations | One way to identify systematic growth deviations is to look at the fixed effects ̂ r for each r ∈ REG n estimated with the model specified in Eq. ( 1 ). However, there are (1) two issues with such an identification strategy. The first one is purely statisti... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Systematic regional growth deviations | This section presents the analysis of systematic deviations in regional growth. First, we obtain the matrix of prediction errors E 90 24 as in Eq. ( 2 ) and transform it into the matrix of standardised prediction errors Z 90 24 , according to Eq. ( 3 ). As... |

### The distance decay effect and spatial reach of spillovers

- DOI : `10.1007/s10109-024-00440-5`
- TEI : `corpus\papers\tei\The_distance_decay_effect_and_spatial_reach_of_spillovers_W4397032875.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | 3 | 3. Spatial autocorrelation statistics are usually designed to test the null hypothesis that there is no relationship among realizations of a single variable, but the tests may be extended to consider spatial relations between variables. 4. Measures of spati... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | 3 | The distance decay effect and spatial reach of spillovers Table 1 Estimation results for different spatial weight matrix specifications Regional and time fixed effects are controlled for in all columns Regionally clustered heteroskedasticity-robust signific... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Basic results | Table 1 reports the estimation results of our spatially augmented neoclassical growth model for different specifications of the spatial weight matrix or matrices. The estimates in column [1] are based on one common spatial weight matrix for all spatial lags... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Robustness checks | Since the empirical literature usually works with different variants of the spatially augmented neoclassical growth framework, in this section we briefly draw attention to three alternative specifications. Their results are reported in Table 2 . Column [1]... |
| low_priority_review | `ModelTableCandidate` | 34 | GROBID table | Table 1 Table 2 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | [1] [2] [3] coeff p value coeff p value coeff p value Coefficient estimates regressors ( m ′) ln(inv t ) 0.002 0.27 0.002 0.36 0.009 0.00 ln(n t + g + q) -0.007 0.06 -0.008 0.02 0.003 0.34 ln(educ t ) -0.004 0.00 ln(sci&tech t ) 0.011 0.00 ln(y t-1 ) -0.081... |

### The generalized spatial random effects model in R

- DOI : `10.1007/s43071-022-00024-9(`
- TEI : `corpus\papers\tei\The_generalized_spatial_random_effects_model_in_R_W4283464891.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | The generalized spatial random effects model | Consider a general static panel model that includes a spatial lag of the dependent variable: where y is an NT Â 1 vector of observations on the dependent variable, X is a NT Â k matrix of observations on the non-stochastic exogenous regressors, I T an ident... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Public capital productivity | The third and last example from Millo (2014) is the Munnell Alicia (1990) "Public capital productivity" model. It involves a social production function, estimated with the main goal of assessing the productivity of public capital (roads, water facilities, o... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Cigarette | A spatial econometrics paper would not be complete without the ubiquitous "Cigarette" example, whose pervasiveness made it a standard which helps comparing different pieces of research. Featuring prominently in a number of textbooks (one for all, Baltagi 20... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Evapotranspiration | The next example, "Evapotranspiration", is taken from Croissant and Millo (2018, Ch. 10). Obojes et al. (2015) explore the effect of vegetation composition and structure on water balance on some high elevation grasslands in the Alps. They repeatedly measure... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Rice farming | The "Rice farming" example of Druska and Horrace (2004) regards the estimation of a production frontier equation relating rice output to the following inputs: seed, urea, phosphate, labour hours and land size, all but phosphate in logs. Dummy variables acco... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Independent random effects | (Anselin 1998) considers a panel data regression model with spatial errors and incorrelated individual heterogeneity (a special case of the model presented above setting k ¼ 0 i.e. without a spatial lag). In this case, l $ IIDð0; r 2 l Þ, and the remainder... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Misspecification of the spatial lag vs. error | In this subsection we illustrate the effect of omitting the SAR term from different DGPs containing spatial lags. As the comparison between the density of GSRE (red lines) and SAR?GSRE (blue lines) estimates shows, the former are severely biased if the DGP... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Rice farming model ANS KKP GSRE SAR?GSRE / 0.199*** 0.195*** 0.190*** 0.188*** 0.044 0.045 0.053 0.052 q 1 0.000 0.736*** -0.647 -0.906 0.032 2.339 2.310 q 2 0.739*** 0.736*** 0.738*** 0.669*** 0.031 0.032 0.032 0.056 k 0.000 0.000 0.000 0.179* 0.096 ML est... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | model Evapotranspiration ANS KKP GSRE SAR?GSRE / 0.282*** 0.281*** 0.278*** 0.291*** 0.083 0.084 0.098 0.091 q 1 0.000 0.878*** -0.132 0.265 0.023 1.790 1.330 q 2 0.880*** 0.878*** 0.880*** 0.907*** 0.022 0.023 0.022 0.028 k 0.000 0.000 0.000 -0.287 0.291 M... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### The impact of spatial outliers on spatial correlation: the role of the local influence function

- DOI : `10.1007/s10109-025-00488-x`
- TEI : `corpus\papers\tei\The_impact_of_spatial_outliers_on_spatial_correlation_the_role_of_the_local_infl_W7131311041.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Appendix: Comparison of local Moran and local influence | See Figs. 14 and 15 . LI 1 2 3 LI quadrant HH LH NA Local Moran Fig. 15 Direct comparison of local Moran values and local influence (LI) for the Eurostat dataset |

### The influence of diet-mediated exposure of avian influenza on adult survival, recruitment and territory occupancy in peregrine falcons Scientific Reports

- DOI : `10.1038/s41598-026-42721-7`
- TEI : `corpus\papers\tei\The_influence_of_diet_mediated_exposure_of_avian_influenza_on_adult_survival_rec_W7134287601.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Observed Occupancy | We used the package glmmTMB [62] to construct mixed models with observed occupancy as a binomial response (occupied/unoccupied). Because our dataset included only a single occupancy classification per territory per year, rather than repeated within-season v... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Φ pent p N K . Log-lik AIC 1338. ΔAIC ~Region * time ~Region * time . 38 -631.43 85 0.00 ~Region * time + . 1339. Gender ~Region * time . 39 -630.56 12 0.27 ~Region * time + . 1340. ~Region * time Gender . 39 -631.27 55 1.70 ~Region * time + ~Region * time... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | ACCEPTED MANUSCRIPT Predictors p N K Log-lik AIC ΔAIC ~Year + Region + . Y X R . 38 -203.63 449.26 0.00 ~Year . . 39 -226.55 475.10 25.85 ~Year + Region . . 39 -226.33 476.65 27.40 ~Region . . 40 -240.79 485.59 36.33 |

### The spatial-temporal variation of poverty determinants

- DOI : `10.1016/j.spasta.2022.100631`
- TEI : `corpus\papers\tei\The_spatial_temporal_variation_of_poverty_determinants_W4210301362.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Spatial-temporal determinants of poverty at multiple administrative levels | The interpretation accuracy of the multi-linear regression models constructed between poverty incidence and the explanatory variables in each county in Hubei and each village in Yunyang County are shown in Tables 3 and 4 , respectively. The results indicate... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | The LMG metric for variable importance analysis | In this study, we aimed to examine the annual relative importance of various explanatory variables and their detailed relationships with poverty using variable importance metrics (VIM) in regression models. We selected multiple linear regression (MLR) analy... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Data and methods |  |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | 2013 2014 2015 2016 2017 2018 2019 Adjusted R 2 0.85 0.85 0.74 0.78 0.73 0.43 0.15 RMSE 4.43 3.93 3.50 2.91 2.47 2.64 0.26 F-statistic 21.76*** 21.38*** 31.18*** 13.38*** 10.68*** 3.71*** 1.64* *** for P-value < 1e-3, ** for < 1e-2 and * for < 5e-1. |

### The stability of geodemographic cluster assignments over an intercensal period

- DOI : `10.1007/s10109-016-0226-x`
- TEI : `corpus\papers\tei\The_stability_of_geodemographic_cluster_assignments_over_an_intercensal_period_W2309656522.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 8 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Domain Subdomain Variables Demographic Age Age 0-4; age 5-14; age 25-44; age 45-64; age 65-89; age 90? structure Family Single; married or in a registered same-sex civil partnership; divorced or structure separated; no children household; non-dependent chil... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Clusters 1 2 3 4 5 6 7 8 Age 0-4 132 132 97 73 76 109 81 111 Age 5-14 116 101 92 45 94 115 100 105 Age 25-44 113 132 102 137 79 100 85 96 Age 45-64 82 73 103 63 127 97 121 90 Age 65-89 66 60 104 62 129 94 117 113 Age 90 and over 60 58 146 107 129... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Cluster Description Household variables associated with Household variables associated with increased assignment to category decreased assignment to category 1 Suburban Population density, flatted housing, Semi-detached housing, detached diversity agricultu... |

### Time-Lag in Responses of Birds to Atlantic Forest Fragmentation: Restoration Opportunity and Urgency

- DOI : `10.1371/journal.pone.0147909`
- TEI : `corpus\papers\tei\Uezu2016Time.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 62 | Data Analysis | Bird richness (number of species, i.e. alpha diversity) was obtained from the survey data of species groups. To find evidence for time lag in species responses, we related bird richness indices with landscape variables (AREA and PROX, log transformed) from... |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Bird groups Independent variables Pseudo R 2 AICc Δi AIC w AIC Endemic AREA78+PROX78 0.80 85.5 0.00 0.41 Endemic AREA78 0.72 85.7 0.17 0.38 1-2 types of forest AREA78 0.58 115.0 0.00 0.37 1-2 types of forest AREA78+PROX78 0.65 116.0 1.13 0.21 Low abundance... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Most important models and parameters | Models for 1978 had the highest chance of being selected and better explained the variation of many bird groups' richness (Table 2 ): Atlantic Forest endemics, species proximal to their distribution limit, those with low forest-type flexibility (1-2 types),... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Models | Var. 1 Var. 2 Type m00 Null model m01 AREA65 PROX65 Additive effect m02 AREA78 PROX78 Additive effect m03 AREA03 PROX03 Additive effect m04 AREA65 Single variable m05 AREA78 Single variable m06 AREA03 Single variable m07 PROX65 Single variable m08 PROX78 Si... |

### Top-down scale approaches for multiscale GWR with locally adaptive bandwidths

- DOI : `10.1007/s10109-025-00481-4`
- TEI : `corpus\papers\tei\atds_mgwr_ghislain_geniaux.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 11 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 11 |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Algorithm 1 (atds_gwr) | We formally introduce the Algorithm 1 (atds_gwr), titled atds_gwr, which implements the top-down scale approach for univariate GWR to estimate model (4). In the following subsections, we provide a detailed discussion of its key components and explain how th... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Algorithm 1 (atds_gwr) | We formally introduce the Algorithm 1 (atds_gwr), titled atds_gwr, which implements the top-down scale approach for univariate GWR to estimate model (4). In the following subsections, we provide a detailed discussion of its key components and explain how th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Computational efficiency of our algorithms | Our Algorithm 2 (tds_mgwr) algorithm has a computational complexity of O(4k dn 2 ). At each iteration, a maximum of four GWR estimations is required, while the ordered bandwidth sequence ensures that the total number of univariate GWR computations (4k d) re... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Computational efficiency of our algorithms | Our Algorithm 2 (tds_mgwr) algorithm has a computational complexity of O(4k dn 2 ). At each iteration, a maximum of four GWR estimations is required, while the ordered bandwidth sequence ensures that the total number of univariate GWR computations (4k d) re... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Computational issues | The MGWR algorithm proposed by FYK2017 has a computational complexity of O(kdn 2 log(n)), where k is the number of covariates, d is the number of backfitting iterations, and log(n) arises from the golden-section search used to determine the optimal bandwidt... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Computational issues | The MGWR algorithm proposed by FYK2017 has a computational complexity of O(kdn 2 log(n)), where k is the number of covariates, d is the number of backfitting iterations, and log(n) arises from the golden-section search used to determine the optimal bandwidt... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Computational Efficiency assessment | While theoretical computational complexity offers an estimate of the expected computation time, a practical comparison of these algorithms' performance remains essential. Table 6 offers an initial assessment of computational efficiency across estimators usi... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | AICc as stopping criterion | In such a gradient boosting algorithm, we need a stopping criterion to determine the terminal bandwidth size at which the coefficient estimation no longer improves. Among the two natural candidates for GWR-like estimations that avoid overfitting by choosing... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | AICc as stopping criterion | In such a gradient boosting algorithm, we need a stopping criterion to determine the terminal bandwidth size at which the coefficient estimation no longer improves. Among the two natural candidates for GWR-like estimations that avoid overfitting by choosing... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | First stage: algorithm 2 (tds_mgwr) | The properties of the top-down scale approach, identified in the univariate case with a decreasing sequence of bandwidths, can also help reduce computation times in standard multiscale GWR. In the standard application of the backfitting algorithm proposed b... |
| low_priority_review | `truncated` |  |  | 23 autres candidats non affiches dans ce rapport |

### Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes

- DOI : `10.1111/1365-2664.13699`
- TEI : `corpus\papers\tei\Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | / Occupancy modelling | To assess the trade-off between avian biodiversity and agricultural intensity, we fitted trade-off curves between the two (Phalan et al., 2011) . As a proxy for biodiversity, we estimated the probability of occupancy per species using a Bayesian framework (... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Section 1 | tural intensity metrics (meat yield, energy yield and profit) and a range of environmental covariates in a hierarchical Bayesian occupancy framework. 3. Woodland extent in the landscape consistently determines how individual bird species, and the bird commu... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Landscape composition and environmental conditions | We used covariates that reflected variation in landscape composition and environmental conditions within our study region. Considering the importance of habitat availability for determining species' occurrence (Fahrig, 2013) , we calculated the woodland ext... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / RE SULTS | Bird occupancy varied strongly across the land systems explored, from natural woodlands and grasslands to subsistence ranching, silvopastoral systems and intensified agriculture (pastures and cropping). Our best fitting occupancy model contained three covar... |

### Transitive properties: a spatial econometric analysis of new business creation around transit

- DOI : `10.1080/17421772.2019.1523548`
- TEI : `corpus\papers\tei\Transitive_properties_a_spatial_econometric_analysis_of_new_business_creation_ar_W2894926662.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 61 | DATA AND STUDY AREAS | Data Three primary types of data are used in this analysis: information on transit systems, individual business data and socio-demographic covariates provided by the census. Table 1 describes the data and each of their sources in detail. The data on transit... |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Unexpected Smoo Residual Multicolli with sign for Business thing Adjusted standard nearity Breusch- Koenker- changing significant Overall Other factors Model type rates N R 2 error condition Pagan Bassett significance a variables Score b Pros Cons... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Mejia | Similarly, Credit (2017) and Chatman et al. (2016) find that proximity to transit stations is generally a strong predictor of new business activity in the retail, service, information and finance/insurance industries. Both papers use time-series data to eva... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Exposure variables for new business creation | In order to evaluate empirically the logical choices of background exposure variables to construct a suitable dependent variable for use in a spatial regression, the best-performing method from each of the four possible exposure variables is chosenalong wit... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | NAICS, North American Industry Classification System. | Transitive properties: a spatial econometric analysis of new business creation around transit given year (Walls & Associates, 2012) . For this paper, businesses that started in 2011 in four industries of interestall knowledge, high-tech, 1 producer services... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Regression results | Table 5 shows the summarized significant, transit-specific results of the pooled and regional spatial Durbin models for each business type of interest; for detailed regression results for each of the 24 individual models, see Appendix B in the supplemental... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 . |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 6 . |

### Trends and determinants of late antenatal care initiation in three East African countries, 2007-2016: A population based crosssectional analysis

- DOI : `10.1371/journal.pgph.0000534`
- TEI : `corpus\papers\tei\Trends_and_determinants_of_late_antenatal_care_initiation_in_three_East_African__W4291618218.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 54 | Data analysis | The data were managed, cleaned, coded, and analysed using STATA version 17 (StataCorp, College Station, Texas 77845 USA [13] . The chi-square test was conducted to compare respondents' demographic and socioeconomic characteristics by late initiation of ANC.... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

### Tropical Cyclone Precipitation Response to Surface Warming in Aquaplanet Simulations With Uniform Thermal Forcing

- DOI : `10.1029/2021JD035197`
- TEI : `corpus\papers\tei\Tropical_Cyclone_Precipitation_Response_to_Surface_Warming_in_Aquaplanet_Simulat_W4200402469.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Estimating Thermodynamic and Dynamic Contributions to TC Precipitation Change | While Figure 8 shows that TC precipitation depends on both TC intensity and outer size changes, it is still unclear how much these dynamic changes control precipitation changes compared to environmental thermodynamic changes in the simulations. Higher SSTs... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | TC Precipitation Analysis Methods | To compare TC precipitation among the different model simulations and on a common spatial grid, composites of TC precipitation are calculated using the NodeFileCompose algorithm within TempestExtremes (Ullrich et al., 2021) . NodeFileCompose takes the TC pr... |

### Uncovering spatiotemporal micromobility patterns through the lens of space-time cubes and GIS tools

- DOI : `10.1007/s10109-023-00418-9`
- TEI : `corpus\papers\tei\Uncovering_spatiotemporal_micromobility_patterns_through_the_lens_of_space_time__W4380681014.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data | As was mentioned previously, collaboration agreements were established with the companies named "Movo" (mopeds + scooters) and "Muving" (mopeds). In the case of "BiciMAD" (bikes), this was not necessary because they publicly share their data on their websit... |
| low_priority_review | `DataSourceCandidate` | 45 | Processing and cleaning the datasets | The data processing workflow covered entering, cleaning, transforming, and outputting the final valid datasets (using Python vs. 3.8). For all the datasets, the initial cleaning process involved eliminating those observations (origin points) with trip dista... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Study context, data and methodology |  |
| low_priority_review | `ModelEvidenceCandidate` | 50 | 3 | Uncovering spatiotemporal micromobility patterns through… the specific times that increase profitability. During weekdays, the results show that there are some locations associated with high departure counts coming from residential (clusters Wd1 and Wd2) an... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Research on micromobility's spatiotemporal patterns | In the last decade, there has been a growing body of literature related to studying spatiotemporal travel patterns for shared mobility and micromobility services, especially bike-sharing programs as they were the first schemes deployed. For example, Corcora... |

### Understanding Airbnb spatial distribution in a southern European city: The case of Barcelona

- DOI : `10.1016/j.apgeog.2019.102136`
- TEI : `corpus\papers\tei\lagonigro2020_Understanding Airbnb spatial distribution in a southern European city The case of barcelona.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Study area, data and methodology | The city of Barcelona is located on the north east coast of Spain. It has an extension of 102.16 km 2 and a population of 1,620,343 inhabitants distributed in 73 neighborhoods in 10 districts (Fig. 1 ). It comprises 4.7 km of linear beach extension, with 7... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Results | In the previous section, Fig. 2 presents the map of the ratio of Airbnb 1 We consider as the city center, the centroid of the census tract corresponding to Plaça Catalunya, the main square in Barcelona, and its surrounding areas. locations over the total ho... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Conclusions | This study provides insight on the spatial distribution of the Airbnb accommodations in the city of Barcelona, mainly in the old city and surrounding areas. Some social and economic urban liberal plans in the city of Barcelona, have successively transformed... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | OLS GWR Min Q1 Med Q3 Max F3 test p-value Coef. p-value Intercept 34.90 0.000 À 62.77 À 2.56 4.53 21.94 88.08 0.87 0.938 Low education (%) 0.036 0.045 À 0.19 À 0.01 0.01 0.04 0.35 1.52 0.000 Family Income (log) Dwellings < 75m 2 (%) À 3.22 À 0.01 0.000 0.01... |

### Understanding different dominance patterns in western Amazonian forests

- DOI : `10.1111/ele.14351`
- TEI : `corpus\papers\tei\MatasGranados2023Understanding.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Data processing | We excluded all individuals not identified to species level (mean 14% of individuals per plot), since plot data came from different projects and morphospecies were not crosschecked. We also excluded individuals from doubtful identifications, e.g. 'cf.' and... |
| low_priority_review | `DataSourceCandidate` | 45 | Identifying dominant species | Since plot size varied among datasets, we identified dominant species as follows: • We transformed the absolute abundances of each species into relative abundances following the formula to species i in plot j: where n ij is the abundance of species i in plo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Local abundance-regional frequency relationship by habitat type | To test the relationship between local abundance and regional frequency of dominant species and the differences in the relationship across habitat types, we built beta regression models with a logit link function. We used the mean local relative abundance o... |

### Unveiling the impact of machine learning algorithms on the quality of online geocoding services: a case study using COVID-19 data

- DOI : `10.1007/s10109-023-00435-8`
- TEI : `corpus\papers\tei\Unveiling_the_impact_of_machine_learning_algorithms_on_the_quality_of_online_geo_W4391229060.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Machine learning classifiers for evaluation of address accuracy | To identify matching and non-matching address pairings in each service, the authors trained seven machine learning models with independent variables generated using seventeen distinct text similarity methods. Additionally, semantic similarity in the geocodi... |

### Using Geographically Weighted Regression to Explore Local Crime Patterns

- DOI : `10.1177/0894439307298925`
- TEI : `corpus\papers\tei\cahill2007_Using Geographically Weighted Regression to Explore Local Crime Patterns.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 1 Descriptive Statistics for Violence and Structural Measures |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | A Global Model of Violence in Portland | A multivariate model was developed to estimate average levels of violence in Portland during the 1998 to 2002 period. The model was developed at the block group level using OLS regression. The model is considered to be global as one parameter is estimated f... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Section 1 | E cological studies of crime have long demonstrated the tendency of criminal events to cluster in space. The search for ecological covariates of crime has been aided in recent decades by the development of multivariate statistical techniques and guided by e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | Crime Data and Structural Measures | Violent crime data (including homicide, sexual assault, robbery, and aggravated assault) were collected from the Portland Bureau of Police for the years 1998 to 2002. The location and date of each reported crime was collected, and those data were geocoded a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | GWR | One of the problems with estimating global regression models for spatial data is that variations over space that might exist in the data are suppressed. In the example given above, the relationship between a violence measure and violence predictors is assum... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | GWR Clusters | The exploratory utility of GWR parameters can be extended by clustering together locations with similar parameter values for all variables (i.e., where whole models of violence are similar). This synthesizes the often huge amount of output created by the GW... |

### Using geovisual analytics to compare the performance of geographically weighted discriminant analysis versus its global counterpart, linear discriminant analysis

- DOI : `10.1080/13658816.2012.722638`
- TEI : `corpus\papers\tei\Foley_Demsar_2013_GWDA_vs_LDA_IJGIS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 54 | Data | For our case study, we use a data set describing the results of the 2004 US presidential election at the county level together with a selection of socio-economic variables (Robinson 2012) . GW statistical methods, in particular GWR, have been used to analys... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Downloaded by [McMaster University] at 21:36 22 April 2013 | Geovisual analytics involves the development of tools and techniques that combine computational methods with interactive visual representations to make sense of large, complex multivariate spatio-temporal data sets. In this context, make sense of refers to... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Spatial autocorrelation in misclassifications | One justification for the use of the related technique of GWR is when strong spatial autocorrelation of the residuals is observed in traditional linear regression models (Fotheringham et al. 2002) . If using a global method on spatially heterogeneous data (... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatial non-stationarity in the classification functions | GWDA captures spatial non-stationarity in the relationship betweeen the categories and the predictor variables through the spatially varying classification function parameters (Section 2). If the predictor variables are standardised prior to the classificat... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Introduction | Spatial data sets, those containing locational and attribute information, are increasingly commonly encountered and are often extremely large. A plethora of special statistical techniques has recently been developed to analyse these large and often complex... |

### Using simulation studies to evaluate statistical methods

- DOI : `10.1002/sim.8086`
- TEI : `corpus\papers\tei\morris_2019_simulation_studies.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Exploration and visualisation of results | The first result to note is that there were no missing θi or ŜE( θi ), and "separation" was not an issue. We first explore the raw results. Figure 3 plots the estimates θi and ŜE( θ) i for the two data-generating mechanisms and three methods, with means dis... |
| low_priority_review | `DataSourceCandidate` | 48 | Data-generating mechanisms: | We consider two data-generating mechanisms. For both, data are simulated on n obs = 500 patients, representing a possible phase III trial with survival outcome. Let X i ∈ (0, 1) be an indicator denoting assignment to treatment, where assignment is generated... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 3 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | TABLE 6 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Statistical Task Target Examples of Performance Example Measures Analysis Estimation Estimand Bias, empirical SE, Kuss compares a number of existing mean-squared error, coverage methods in terms of bias, power, and coverage. 26 Testing Null hypothesis Type... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 4 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Overall By Primary Target Null Hyp-Selected Predictive Performance Estimand othesis Model Performance Other Measure (n = 64) (n = 21) (n = 8) (n = 3) (n = 4) Convergence 12/85 (14%) 10/61 (16%) 1/15 (7%) 1/6 (17%) 0/2 0/1 Bias 63/80 (79%) 59/64 (92%) 1/9 (1... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Performance Measure Definition Estimate Monte Carlo SE of Estimate Bias E[ θ] -𝜃 |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | n sim = E(Coverage) × (1 -E(Coverage)) (Monte Carlo SE req ) 2 (1) |

### Vegetation cover in relation to socioeconomic factors in a tropical city assessed from sub-meter resolution imagery

- DOI : `10.1002/eap.01673`
- TEI : `corpus\papers\tei\Martinuzzi1960Vegetation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Dependent variables |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Accepted Article | This article is protected by copyright. All rights reserved. As a robustness check for spatial non-stationarity, we fit geographically weighted regression (GWR) models for each spatial model (as in Locke et al. 2016) . GWR creates a family of local regressi... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Accepted Article | This article is protected by copyright. All rights reserved. In addition, we found that both residential and non-residential vegetation were associated with many of the same individual variables, but in different ways (Table 4 ). In the majority of the obse... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Relationship between urban vegetation and socioeconomic characteristics | We found that models containing both socioeconomic and environmental variables had a better fit than models including either only socioeconomic or only environmental variables, even when accounting for model complexity (Table 3 ). This was true for all of o... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 4 . |

### Visitation patterns across mobility groups: wandering, commuting, and exploring

- DOI : `10.1007/s10109-026-00501-x`
- TEI : `corpus\papers\tei\Visitation_patterns_across_mobility_groups_wandering_commuting_and_exploring_W7164540984.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Individual mobility data and data preprocessing | To investigate differences in individual mobility behavior and evaluate the generalizability of discovered patterns across diverse urban contexts, we analyzed high-resolution movement trajectories from two cities: Auckland, New Zealand, and Rio de Janeiro,... |
| low_priority_review | `DataSourceCandidate` | 46 | Data preprocessing | See Table 6 . |
| low_priority_review | `DataSourceCandidate` | 45 | 2013; Uteng 2009b). | While the overall structure of mobility profiles was consistent across Auckland and Rio de Janeiro, we observed notable differences in the distribution of individuals across these profiles and the specific mobility behaviors within each group. For instance,... |
| low_priority_review | `DataSourceCandidate` | 45 | Segregation analysis | After grouping individuals into mobility categories, we aimed to assess the level of segregation among them. Segregation can be conceptualized in various ways (Massey and Denton 1988) ; however, in this study, we were specifically interested in how well the... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Methods and data |  |

### Volatility and regional growth in Europe: Does space matter?

- TEI : `corpus\papers\tei\Volatility_and_Regional_Growth_in_Europe_Does_Space_Matter_W1954601627.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 : |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | INSERT TABLE 4 AROUND HERE | Column 2 of Table 3 presents the results from the spatial Durbin model, whereas the spatial lag model and the spatial error model are presented respectively in columns 6 Similar results are obtained when the Moran's I test is calculated for the different re... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | INSERT TABLE 7 AROUND HERE 6 Conclusions | This paper has investigated the relationship between volatility and economic growth in a sample of 279 European regions over the period 1995-2008. To that end we have estimated a two-way fixed panel data model using spatial econometric techniques that allow... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Authors (year) Sample Period Methodology Results Chatterjee and 48 US states 1963-1999 Cross-section Negative but not significant Shukayev (2006) Chandra (2003) 48 US states 1977-2001 Frontier estimation Non-linear link. Positive for high-growth and negativ... |

### WFDE5: bias-adjusted ERA5 reanalysis data for impact studies

- DOI : `10.5194/hess-22-3515-2018`
- TEI : `corpus\papers\tei\2026-04-23_paper_eobs_daily_gridded_observations_essd_2020.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Comparison with FLUXNET2015 and WFDEI | The FLUXNET2015 (FN2015) meteorological data (Chu, 2015; Pastorello et al., 2017) are not included in the data assimilation of the ERA5 reanalysis. Therefore, these data provide an opportunity to assess the degree to which the ERA5 and WFDE5 meteorological... |
| low_priority_review | `DataSourceCandidate` | 45 | Conclusions | The WFDE5 dataset will be useful for forcing surface models and especially for near-recent hydrological and agricultural analyses. It will also be used for bias correction of the CMIP6 GCM model output in the third phase of ISIMIP. WFDE5 benefits from the i... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Dataset Summary Location ERA5 ECMWF reanalysis product https://cds.climate.copernicus.eu/cdsapp#!/home (last access: 26 August 2020) CRU TS4.03 Climate Research Unit gridded station http://data.ceda.ac.uk/badc/cru/data/cru_ts/cru_ts_4.03 observations (multi... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Dataset attribute Details Horizontal coverage Global Horizontal resolution 0.5 • × 0.5 • Vertical coverage Surface Temporal coverage -1 January 1979 00:00:00 to 31 December 2018 23:00:00 for variables Wind, Tair, PSurf and Qair -1 January 1979 07:00:00 to 3... |

### Wave after wave: determining the temporal lag in Covid-19 infections and deaths using spatial panel data from Germany

- DOI : `10.1007/s43071-022-00027-6(`
- TEI : `corpus\papers\tei\Wave_after_wave_determining_the_temporal_lag_in_Covid_19_infections_and_deaths_u_W4296266985.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Temperature data | The medical literature reports that respiratory diseases and infections follow seasonal cycles and are susceptible to temperature (e.g., Shaman et al. 2010; Martinez 2018 ). Similar patterns have recently been confirmed for the coronavirus. Ma et al. (2020)... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | Empirical strategy | To identify the time lag between the number of cases and the number of deaths, I rely on a spatial econometric approach, which allows me to model direct effects within the geographical unit of interest, while accounting for possible interaction effects with... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Intensive care cases | To be able to derive an unbiased estimate of the time lag between infections and death cases, I control for the number of daily new intensive care (IC) cases per federal state, i.e., the number of patients that have contracted the corona disease and are und... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 4 |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 6 |

### What dictates income in New York City? SHAP analysis of income estimation based on Socioeconomic and Spatial Information Gaussian Processes (SSIG)

- DOI : `10.1057/s41599-023-01548-7`
- TEI : `corpus\papers\tei\Bai2023WhatDictates.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 62 | Data collection and pre-processing | Labelled data. Our study focusses on NYC, one of the most advanced global economies. In addition, Table 1 presents the Between-district Gini Coefficients (StatisticalHelp, 2022) and Decile Dispersion Ratios (the ratio between the average income of the riche... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 |

### When Do Neural Nets Outperform Boosted Trees on Tabular Data?

- TEI : `corpus\papers\tei\mcelfresh_2023_tabzilla.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | Data Preprocessing | *Was any preprocessing/cleaning/labeling of the data done (e.g., discretization or bucketing, tokenization, part-of-speech tagging, SIFT feature extraction, removal of instances, processing of missing values)? If so, please provide a description. If not, yo... |
| low_priority_review | `DataSourceCandidate` | 48 | D.2.6 Dataset size analysis | In this section, we investigate the association between dataset size and performance. In Section 2.2 we show that, when compared to NNs and baselines, GBDTs perform relatively better with larger datasets; this is based on a negative correlations between nor... |
| low_priority_review | `DataSourceCandidate` | 48 | D.7 Forward Feature Selection for Identifying Important Dataset Attributes | In this section, we present a different method for determining which dataset attributes are related to performance differences between algorithms. Here we use greedy forward feature selection [24] to identify important dataset attributes. In these experimen... |
| low_priority_review | `DataSourceCandidate` | 47 | Experimental design. | For each dataset, we use the ten train/test folds provided by OpenML, which allows our results on the test folds to be compared with other works that used the same OpenML datasets. Since we also need validation splits in order to run hyperparameter tuning,... |
| low_priority_review | `DataSourceCandidate` | 45 | D.2.1 Relative performance tables | First, we show the ranking of all tuned algorithms according to each performance metric, averaged over datasets: log loss (Table 7 ), F1 score (Table 8 ), and ROC-AUC (Table 9 ). These are similar to Table 1 , but with different metrics. Rankings are calcul... |
| low_priority_review | `DataSourceCandidate` | 45 | D.3 Additional experiments from Section 2.2 | Recall from Section 2.2 that ∆ ℓℓ denotes the difference in normalized log loss between the best neural net and the best GBDT method. Table 14 and Figure 12 shows the dataset properties with the largest absolute correlation with ∆ ℓℓ . To evaluate the predi... |
| low_priority_review | `DataSourceCandidate` | 45 | Datasheet Composition | *What are the instances?(that is, examples; e.g., documents, images, people, countries) Are there multiple types of instances? (e.g., movies, users, ratings; people, interactions between them; nodes, edges) Each instance is a tabular datapoint. The makeup o... |
| low_priority_review | `DataSourceCandidate` | 45 | Metafeature Analysis | In this section, we answer the question, "What properties of a dataset are associated with certain techniques, or families of techniques, outperforming others?" We answer this question by computing the correlation of metafeatures with three different quanti... |
| low_priority_review | `DataSourceCandidate` | 45 | Relative Algorithm Performance | In this section, we answer the question, "How do individual algorithms, and families of algorithms, perform across a wide variety of datasets?" We especially consider whether the difference between GBDTs and NNs is significant. No individual algorithm domin... |
| low_priority_review | `DataSourceCandidate` | 45 | TabZilla Benchmark Suite | In order to accelerate tabular data research, we release the TabZilla Benchmark Suite: a collection of the 36 'hardest' of the 176 datasets we studied in Section 2. We use the following three criteria. Hard for baseline algorithms. As discussed in Section 2... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 : |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Analysis of Algorithms for Tabular Data | In this section, we present a large-scale study of techniques for tabular data across a wide variety of datasets. Our analysis seeks to answer the following two questions. 1. How do algorithms (and algorithm families) compare across a wide variety of datase... |
| low_priority_review | `truncated` |  |  | 15 autres candidats non affiches dans ce rapport |

### Women's political empowerment and welfare policy decisions: a spatial analysis of European countries

- DOI : `10.1080/17421772.2021.1905173`
- TEI : `corpus\papers\tei\Women s political empowerment and welfare policy decisions - a spatial analysis of European countries.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 49 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 48 | GROBID table | Variable Mean SD Minimum Maximum Dependent variables Total social expenditure 22.75469 4.51608 13.064 34.178 Health expenditure 5.62344 1.371659 2.202 8.869 Family expenditure 2.308087 0.9933268 0.297 4.454 Family allowances 0.9903482 0.5285749 0.08 2.564 P... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 7 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Social expenditure W GDP W REGIME W NEIGH Total 0.705*** 0.404*** -0.298*** (9.859) (4.285) (-3.203) Health 0.638*** 0.667*** -0.704*** (6.948) (6.132) (-6.122) Family 0.0537 0.615*** 0.149 (0.652) (5.774) (1.491) Housing -0.00871 0.670*** -0.539*** (-0.099... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Unemployment 0.00522 (0.966) -0.0404*** (-3.236) Yes Yes 0.00325 (0.566) -0.0525*** (-2.621) -0.0493** (-2.156) 0.300*** (4.186) 0.0907*** (14.48) 240.6545 425 Active labour market -0.00699** (-2.186) -0.00537 (-0.725) Yes Yes -0.00709** (-2.112) -0.00744 (... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Unemployment -0.000421 (-0.0540) -0.000237 (-0.0239) -1.461*** (-5.085) 0.0321 (0.442) -0.0524*** (-8.225) 0.00459*** (5.449) 0.00415*** (4.309) 0.0308*** (3.569) 0.00480*** (3.733) 0.163* (1.942) -0.00679 (-1.065) Active labour market 0.00946* (1.908) -0.0... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Family allowances Parental leave Childcare Child benefit Women in parl -0.00580*** 0.00424*** 0.00586*** -0.000258 (-2.729) (2.908) (2.796) (-0.232) W*Women in parl -0.00655 0.0112*** 0.0109*** -0.00797*** (-1.612) (3.955) (2.630) (-3.733) Control... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables W GDP W REGIME W NEIGH Women in parl (spatial lag) 25.68*** 25.39*** 25.78*** (84.31) (53.57) (52.78) Women in parl (time lag) 24.07*** 24.07*** 24.07*** (40.85) (40.85) (40.85) Female labour force 43.75*** 43.75*** 43.75*** (265.2) (265.2) (265.2... |
| low_priority_review | `truncated` |  |  | 8 autres candidats non affiches dans ce rapport |

### XGBoost: A Scalable Tree Boosting System

- TEI : `corpus\papers\tei\2026-04-23_paper_xgboost_scalable_tree_boosting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Column Block for Parallel Learning | The most time consuming part of tree learning is to get the data into sorted order. In order to reduce the cost of sorting, we propose to store the data in in-memory units, which we called block. Data in each block is stored in the compressed column (CSC) f... |
| low_priority_review | `DataSourceCandidate` | 45 | Sparsity-aware Split Finding | In many real-world problems, it is quite common for the input x to be sparse. There are multiple possible causes for sparsity: 1) presence of missing values in the data; 2) frequent zero entries in the statistics; and, 3) artifacts of feature engineering su... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Regularized Learning Objective | For a given data set with n examples and m features D = {(xi, yi)} (/D/ = n, xi ∈ R m , yi ∈ R), a tree ensemble model (shown in Fig. 1 ) uses K additive functions to predict the output. where F = {f (x) = w q(x) }(q : R m → T, w ∈ R T ) is the space of reg... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |

### Yield Response Surfaces, Isoquants, and Economic Fertilizer Optima for Coastal Bermudagrass'

- TEI : `corpus\papers\tei\welch1963.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | Multiple Regression Analysis | Yearly yield data were used to calculate multiple regression equations for each of the years 1955, 1956, and 1957 . Also, equations based on the average 3-year yields were calculated for 1955-57 with and without the N P K term included. The form of the quad... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Response Surfaces | Yield response surfaces, prepared from the yields predicted by the 195 5-57 NPK-omitted multiple regression equation, are shown in Figures 1 , 2 , and 3. These response surfaces in Figures IA, 1B, 2A, 2B, 3A, and 3B show the effect on yield of varying 2 fer... |

### elifesciences.org

- DOI : `10.7554/eLife.02851`
- TEI : `corpus\papers\tei\Global distribution maps of the leishmaniases.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Estimation of population living in areas of environmental risk | Population living in areas of risk was estimated by using a threshold probability to reclassify the probabilistic risk maps into a binary risk map, then extracting the total human population in the 'at risk' areas using a gridded data set of human populatio... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Materials and methods | A boosted regression tree (BRT) modelling framework was used to generate global predicted environmental risk maps for CL and VL. This framework required four key information components: (i) a map of the consensus of evidence for the global extents of the le... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Conclusions | These maps represent evidence-based estimates of the current global distribution of the leishmaniases incorporating a comprehensive occurrence database and a rigorous statistical modelling framework with associated uncertainty statistics. We estimate that 1... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Modelled distribution of the leishmaniases | Figures 1B-4B show the global predicted environmental risk maps for CL and VL. Table 2 identifies the top five predictor variables in each of the four modelled regions (since CL and VL were modelled separately in the Old World and New World) as measured by... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Summarising the BRT model | The relative importance of predictor variables was quantified for the final BRT ensemble. Relative importance is defined as the number of times a variable is selected for splitting, weighted by the squared improvement to the model as a result of each split... |

### k-nearest neighbors prediction and classification for spatial data

- DOI : `10.1007/978-1-4612-2642-0`
- TEI : `corpus\papers\tei\k_nearest_neighbors_prediction_and_classification_for_spatial_data_W2806671728.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 64 | Environmental case study | In this part, we investigate the performance of the proposed k-NN prediction method using the famous Swiss Jura data set ( https://sites.google.com/site/goovaertspierr e/pierregoovaertswebsite/download/jura-data ). This dataset was collected by the Swiss Fe... |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Case Primary variable Secondary variables 1 Cadmium Nickel, Zinc 2 Copper Lead, Nickel, Zinc 3 Lead Copper, Nickel, Zinc |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Fisheries case study | We consider data from the coastal demersal sea It should be noted that the Senegalese and Mauritanian upwellings affect the spatial and seasonal distributions of coastal demersal fish. Thus, it is important to study the locations of the fish species in this... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | L * = L(g * ). Note that g * depends on the distribution of (X, Y ) which is unknown. An estimator g n of g is based on the observations {(X i , Y i ) i∈On }; Y is predicted by g n (X; (X i , Y i ) i∈On ). The performance of g n is measured by the condition... |

### on the interpretability of predictors in spatial data science: the information horizon

- DOI : `10.1038/s41598-020-73773-y`
- TEI : `corpus\papers\tei\Behrens_ViscarraRossel_2020_InformationHorizon.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Reference models and prediction accuracy. | The prediction accuracies of the different models are presented in Fig. 7 . Figure 8 shows the corresponding maps. 0.0 0.4 0.8 Rsq GMS GMS restricted EDF GMS restricted + EDF GRF 100 GRF 10 Rhine-Hesse Piracicaba Meuse Figure 7. Modelling cross-validation a... |
| review_for_dataset_use | `DataSourceCandidate` | 53 | Reference models. | The benchmark model to test structural dependence used Gaussian mixed scaling (GMS) 15 of relevant terrain attributes. Gaussian mixed scaling is an approach to decompose scales of numerical environmental predictors and specifically terrain attributes. It is... |
| review_for_dataset_use | `DataSourceCandidate` | 50 | Study sites. | The description of the study sites is reproduced form Behrens et al. 4 . Figure 1 shows the sample locations draped over the corresponding digital elevation models (DEM). The Meuse dataset consists of 155 samples of the River Meuse floodplain in the Netherl... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Variography. | To calculate the range of spatial dependence of a soil property, we derived spherical variograms using the gstat package 13 in R 12 . The spherical model has the most interpretable values for nugget, sill and range, as it does not approach the sill asymptot... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Section 1 | Vol:.(1234567890) Scientific RepoRtS / (2020) 10:16737 / https://doi.org/10.1038/s41598-020-73773-y www.nature.com/scientificreports/ In spatial modelling with machine learning, using a sufficient number of meaningless (or structurally independent) predicto... |

### paper:doi:10.1002/eap.01794

- DOI : `10.1002/eap.01794`
- TEI : `corpus\papers\tei\A_spatially_explicit_hierarchical_model_to_characterize_population_viability_W2891253401.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Accepted Article | This article is protected by copyright. All rights reserved. PVA is a relatively well-established tool for assessing extinction risks at local scales (e.g., a single population) where the demographic processes that govern viability-survival, individual grow... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Survival and juvenile-to-adult transitions | The model to estimate survival of juveniles and adults and the rate at which juveniles transition to adults relies on capture-recapture data. Data are assembled into an encounter history for each individual, which indicates for each year of the study if the... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Population viability | We compute population viability for each grid cell as the probability that the population of a cell becomes locally extinct or extirpated (P ex ) within an arbitrary period that encompasses multiple generations of the focal species. For each grid cell, we c... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Rate of population change | We combine posterior distributions of survival, transition rates, and recruitment into a posterior distribution for the annual rate of population change for each grid cell ( ). Specifically, within cell j, we sample the posterior distributions of each demog... |

### paper:doi:10.1080/10618600.2020.1754225

- DOI : `10.1080/10618600.2020.1754225`
- TEI : `corpus\papers\tei\Generalized Spatially Varying Coefficient Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | A c c e p t e d M a n u s c r i p t | It is interesting to compare our model to some other approaches in the literature. We choose the GAM as the competing model, which is the typical model to analyze such data. To be more specific, we assume that ** where (•) k   's are unknown univariate fu... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Methodology | For the GSVCM described in (1) and (2), the estimation of the coefficient functions can be achieved by maximizing the quasi-likelihood function, ( , . Note that estimation of the varying coefficient functions requires a degree of statistical smoothing. In t... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | A c c e p t e d M a n u s c r i p t | We simulate data according to the GSVCM using corresponding links with the following three scenarios:  Scenario 1: For 2 1, , , ~N o rm a l( , ) ii i n Y   , where 2 0 1 1 2 0 .2 5 , ( ) ( ) , i i i i i XX        SS and ~U n ifo rm ( 0 ,1), 0 ,1... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | 0 , , kp  , let 2 { , } km kk m      Q γγ . Then, the bivariate spline estimators of () k  s are ˆ( ) ( ) ( ) k m k m k m B     B ss γs , for 0 , , kp  . A c c e p t e d M a n u s c r i p t 2.3 Asymptotic Results Let 0 0 ( , ) ( ) , ( , |

### paper:doi:10.1080/24694452.2017.1352480

- DOI : `10.1080/24694452.2017.1352480`
- TEI : `corpus\papers\tei\fotheringham2017_Wenbai Yang, and Wei Kang.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 3 . |
| low_priority_review | `ModelEvidenceCandidate` | 66 | S | cale is a fundamental geographic concept and is the focus of a huge and diverse literature that discusses the various roles that scale plays in different geographical contexts (e.g., Harvey 1968; Moellering and Tobler 1972; Brenner 2001; Tate and Atkinson 2... |
| low_priority_review | `ModelEvidenceCandidate` | 64 | Bandwidth Comparison | Because MGWR relaxes the assumption of a single bandwidth for all the relationships being modeled, we expect MGWR to be able to differentiate between relationships that are relatively homogeneous and those that are relatively heterogeneous and to be able to... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Multiscale Geographically Weighted Regression (MGWR) | A. Stewart Fotheringham,* Wenbai Yang, y and Wei Kang* *School of Geographical Sciences & Urban Planning, Arizona State University y School of Geography & Geosciences, University of St. Andrews Scale is a fundamental geographic concept, and a substantial li... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | SGWR | SGWR is an extension of GWR that allows for the coexistence of local and global relationships. It can be considered as a special case of MGWR. For the observation i 2 1; 2; : : : ; n f gat location u i ; v i ð Þ, the linear regression model is where k a is... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | GWR | Traditional or global regression assumes that the relationships being examined through the model's parameters are constant over space. This assumption is relaxed in GWR by allowing the parameters to vary spatially. The GWR model formulation can be described... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Bandwidth Selection | Bandwidth selection is relatively straightforward in GWR and SGWR because only a single bandwidth is required. The optimal bandwidth is selected through trials: In each trial, a bandwidth is selected, then either GWR or SGWR is fitted using the bandwidth, t... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Goodness of Fit | The RSS, as shown in Equation ( 18 ), is used to evaluate the goodness of fit of both models to the known set of y i values (with ŷi being the estimated response variable). Although RSS is not a perfect indicator of goodness of fit in that it is neither uni... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Local Parameter Estimation Accuracy | The ability of both GWR and MGWR to replicate the known parameter surfaces is measured by the root mean squared error (RMSE) of the coefficient b j : where bj .u i ; v i ) is the estimated coefficient for location i from either GWR or MGWR. A smaller RMSE j... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Local Parameter Estimation Accuracy | The ability of GWR and MGWR to replicate each of the two known parameter surfaces is shown in Figure 13 , which depicts the RMSE values for both parameter surfaces for each of the 100 simulations. As expected, given the equal degree of heterogeneity in the... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Optimal Bandwidth Vector | Figure 4 shows the resulting bandwidths from the calibration of a GWR model and an equivalent MGWR model on the 100 simulated data sets for Design Process 1. In Figure 4 , b Ã is the single optimal 1 , and b Ã 2 are the optimal bandwidths for each of the th... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Optimal Bandwidth Vector | Figure 11 displays the single optimal bandwidth for GWR and the two separate optimal bandwidths generated by MGWR for each of the 100 simulated data sets produced from Simulated Design 2. In this case, because the two parameter surfaces have the same degree... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### paper:doi:10.1111/ecog.05651

- DOI : `10.1111/ecog.05651`
- TEI : `corpus\papers\tei\i_WiBB_i_an_integrated_method_for_quantifying_the_relative_importance_of_predict_W3200721675.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 50 | The application of WiBB method to Mimulus dataset | It is not enough to fully understand the usefulness of WiBB method only for simulated data set, for real world problems usually are much more complex. Here we demonstrate an application of the new method on an empirical dataset to evaluate the relative impo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | The principle of the WiBB method and its implementation | In this present study, WiBB is an integrated index, combining three components mentioned above, to determine the rank order of importance of predictor variables. The first one is a modification of SW, the relative sum of weights (SWi). The idea of SW is to... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Application of WiBB to an empirical study | To test the applicability of the WiBB method, we applied it to an empirical dataset with observations of species' presences and pseudoabsences from various localities (below). The goal was to see if WiBB could provide strong information about the relative i... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Other variable selection approaches | For ecologists, variable selection unusually means to distinguish between large effect variables and variables with smaller effects on the response variable. From a practical perspective, it may generally be good enough to give the importance order of varia... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Applications to empirical datasets | We applied WiBB with a general linear model in a dataset of species occurrence records and bioclimatic predictors, and we got meaningful results that highly conformed to our expectation that TP syn had the highest relative importance in terms of determining... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Innovations of WiBB and potential applications | The two key innovations of the WiBB method are the implementation of bootstrap resampling and the dividing of model weights among predictors. First, the application of the bootstrap strategy is a major step forward for reducing estimation uncertainty. For L... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | The performance of β* and SW methods | The differences in effect sizes of predictors across datasets, as estimates of unstandardised regression coefficients in full models of LM and GLM, were generally consistent with preset correlation structures (strong, moderate, weak and spurious; Supporting... |

### paper:doi:10.1257/aer.102.5.1898

- DOI : `10.1257/aer.102.5.1898`
- TEI : `corpus\papers\tei\A Rational Expectations Approach to Hedonic Price Regressions with Time-Varying Unobserved Product Attributes - The Price of Pollution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | B. Air Quality Data | We measure individuals' average marginal willingness-to-pay (MWTP) to avoid three of the EPA's major criteria air pollutants (California Air Resources Board 1990 -2006) . 5 The MWTP is a key determinant of the benefits of any new air pollution regulation, s... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | B. The Marginal Willingness to Pay to Avoid Air Pollution | In our application, we allow Bay Area housing prices to be determined by different hedonic price functions in each of three separate periods: (i) 1990-1994, (ii) 1995-2000, and (iii) 2001-2006. 9 These periods correspond (roughly) to periods of depreciation... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 - |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 - |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 5 - |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 - |

### paper:doi:10.1590/01047760201521021532

- DOI : `10.1590/01047760201521021532`
- TEI : `corpus\papers\tei\ESTIMACAO DE VOLUME DE MADEIRA DE EUCALIPTO POR COKRIGAGEM KRIGAGEM E REGRESSAO.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 |

### paper:tei:2026_04_23_paper_random_forest_breiman_2001_tei

- TEI : `corpus\papers\tei\2026-04-23_paper_random_forest_breiman_2001.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | Categorical Variables | Some or all of the input variables may be categoricals and since we want to define additive combinations of variables, we need to define how categoricals will be treated so they can be combined with numerical variables. My approach is that each time a categ... |
| low_priority_review | `DataSourceCandidate` | 45 | Empirical Results on Strength and Correlation | The purpose of this section is to look at the effect of strength and correlation on the generalization error. Another aspect that we wanted to get more understanding of was the lack of sensitivity in the generalization error to the group size F. To conduct... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Outline of Paper | Section 2 gives some theoretical background for random forests. Use of the Strong Law of Large Numbers shows that they always converge so that overfitting is not a problem. We give a simplified and extended version of the Amit and Geman [1997] analysis to s... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Using Out-Of-Bag Estimates to Monitor Error, Strength, and Correlation | In my experiments with random forests, bagging is used in tandem with random feature selection. Each new training set is drawn, with replacement, from the original training set. Then a tree is grown on the new training set using random feature selection. Th... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 7 . |

### paper:tei:geocomputation_with_r_tei

- TEI : `corpus\papers\tei\Geocomputation-with-R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 53 | Spatial tuning of machine-learning hyperparameters | Section 11.4 introduced machine learning as part of statistical learning. To recap, we adhere to the following definition of machine learning by Jason Brownlee foot_98 : Machine learning, more specifically the field of predictive modeling, is primarily conc... |
| low_priority_review | `DataSourceCandidate` | 49 | Transport zones | Although transport systems are primarily based on linear features and nodes -including pathways and stations -it often makes sense to start with areal data, to break continuous space into tangible units ( ). In Hollander, 2016 addition to the boundary defin... |
| low_priority_review | `DataSourceCandidate` | 48 | Vector data | Spatial vector data comes in a wide variety of file formats, most of which can be read-in via the sf function st_read(). Behind the scenes this calls GDAL. To find out which data formats sf supports, run st_drivers(). Here, we show only the first five drive... |
| low_priority_review | `DataSourceCandidate` | 46 | Data and data preparation | All the data needed for the subsequent analyses is available via the RQGIS package. data( , , , , , ) "study_area" "random_points" "comm" "dem" "ndvi" package = "RQGIS" study_area is an sf polygon representing the outlines of the study area. random_points i... |
| low_priority_review | `DataSourceCandidate` | 46 | The raster package offers nine data types when saving a raster: LOG1S, INT1S, INT1U, INT2S, INT2U, INT4S, INT4U, FLT4... | . 23 The data type determines the bit representation of the raster object written to disk (Table 7 .4). Which data type to use depends on the range of the values of your raster object. The more values a data type can represent, the larger the file will get... |
| low_priority_review | `DataSourceCandidate` | 45 | CRSs in R | Two main ways to describe CRS in R are an epsg code or a proj4string definition. Both of these approaches have advantages and disadvantages. An epsg code is usually shorter, and therefore easier to remember. The code also refers to only one, well-defined co... |
| low_priority_review | `DataSourceCandidate` | 45 | File formats | Geographic datasets are usually stored as files or in spatial databases. File formats can either store vector or raster data, while spatial databases such as PostGIS 15 can store both (see also ). Today the variety of file Section 9.6.2 formats may seem bew... |
| low_priority_review | `DataSourceCandidate` | 45 | Points of interest | The osmdata package provides easy-to-use access to OSM data (see also Section 7.2). Instead of downloading shops for the whole of Germany, we restrict the query to the defined metropolitan areas, reducing computational load and providing shop locations only... |
| low_priority_review | `DataSourceCandidate` | 45 | Spatial joining | Joining two non-spatial datasets relies on a shared 'key' variable, as described in Spatial data joining applies the same concept, but instead Section 3.2.3. relies on shared areas of geographic space (it is also know as spatial overlay). As with attribute... |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Exercises | 1. Run a NMDS using the percentage data of the community matrix. Report the stress value and compare it to the stress value as retrieved from the NMDS using presence-absence data. What might explain the observed difference? 2. Compute all the predictor rast... |
| low_priority_review | `ModelEvidenceCandidate` | 60 | mlr building blocks | The code in this section largely follows the steps we have introduced in Section 11.5.2. The only differences are the following: 1. The response variable is numeric, hence a regression task will replace the classification task of . Section 11.5.2 2. Instead... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Conventional modeling approach in R | Before introducing the mlr package, an umbrella-package providing a unified interface to dozens of learning algorithms ( ), it is worth taking Section 11.5 a look at the conventional modeling interface in R. This introduction to supervised statistical learn... |
| low_priority_review | `truncated` |  |  | 8 autres candidats non affiches dans ce rapport |

### paper:tei:gwr4manual_409_tei

- TEI : `corpus\papers\tei\GWR4manual_409.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 62 | Step 1: The Data Tab | Data preparation < What fields do I have to prepare in my dataset? > To calibrate a GWR model, you must prepare a tabular dataset that contains fields of dependent and independent variables, and x-y coordinates. Every variable should consist of numeric valu... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Local terms Global terms | Main features (1) Semiparametric GWR As noted above, a most remarkable feature of this release is the function to fit semiparametric GWR models, which allow you to mix globally fixed terms and locally varying terms of explanatory variables simultaneously. T... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Step 2: The Model Tab | If the data file you specified on the "Data" tab page is successfully opened, field names will appear in the "Variable (Field) list" list box in the middle of the "Model" tab page. If there is no field name or the listings in the list box are insufficient,... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | --------------------------------------from here--------------------------------------------------Area_num: the sequen... | ID number of the location (automatically assigned), Areal_key: if you selected this in the model tab, the field will be included. x_coord: x coordinate of the regression points (data observations) y_coord: y coordinate of the regression points (data observa... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Geographical variability test | < What is this test? > Geographical variability for each varying coefficient is tested by model comparison. For testing the geographical variability of the kth varying coefficient, a model comparison is carried out between the fitted GWR and a model in whic... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Step 3: The Kernel Tab | (1) < kernel function type >: Choose one of the four available options for geographical kernel weighting. (2) < bandwidth selection method >: Choose one of the three available options for bandwidth size selection. A larger bandwidth will estimate geographic... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Example output | Imagine an example of Gaussian GWR with three local terms and two global terms using the Georgia data sample: When the model is fit with the geographical variability test, the adaptive kernel function, the golden section search for finding the optimal bandw... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Selection criteria | In the golden section and interval searches, the optimal bandwidth size is determined by means of comparison of model selection indicators with different bandwidth sizes. The criterion is also used for several modelling options described previously. < AICc... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Introduction | What is GWR4? GWR4 is a new release of a Microsoft Windows-based application software for calibrating geographically weighted regression (GWR) models, which can be used to explore geographically varying relationships between dependent/response variables and... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | < Variable settings for semiparametric models > | To fit a semiparametric model, most of the operations needed are the same as those used in the case of traditional GWR models. One additional thing is to specify the global term by moving independent variables for global terms to the "Global" box. |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Geographically weighted Poisson regression (GWPR) | A GWPR model and its semiparametric variant are shown as The dependent variable should be an integer that is greater than or equal to zero. i N is the offset variable at the ith location. This term is often the size of the population at risk or the expected... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Local terms | Global terms < Example of semiparametric Gaussian GWR > The following equation is an example of a semiparametric Gaussian GWR model using the Georgia sample data with the following specifications: 01 23 12 PctBatch ( , ) ( , )PctRural ( , )PctPov ( , )PctBl... |

### paper:tei:inference_for_lattice_models_1993_tei

- TEI : `corpus\papers\tei\inference-for-lattice-models-1993.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 48 | Bootstrapping Dependent Data | The bootstrap paradigm involves resampling (groups of) observations rather than deleting them. When D is divided into congruent subregions D X ,...,D K , Hall (1985a) has suggested two types of resampling. One is to assign the data Z* to the region D k , k... |
| low_priority_review | `DataSourceCandidate` | 46 | Transforming the Data | Now try to model the data by fitting additive row and column effects: A t = a + r kU) + c m + <5,•, k(i) e {1,..., 10}, l(i) e {1,..., 7}, (7.5.3) where the ith district is located at grid node (k(i), Hi)), a is the overall mean, r k is the fcth row effect... |
| low_priority_review | `DataSourceCandidate` | 45 | 1(h) = j). (k(h), 1(h)) is the grid node nearest county h. | minimizing L*( ), q is the number of large-scale parameters fitted, and Xi(at) is the upper 100(1 -a)% point of the chi-squared distribution on 1 degree of freedom. For η = 99, q = 1, k = 1, and a = 0.05, the 95% confidence interval becomes {φ: L*($) < L*($... |
| low_priority_review | `DataSourceCandidate` | 45 | Cross-Validation and Model Selection | The conditionally specified models are in a very convenient form for crossvalidation. Suppose the observation Z(s,) is deleted from the data set and predicted using the other observations [Z(sj): j Φ i). Depending on the loss function specified for predicti... |
| low_priority_review | `DataSourceCandidate` | 45 | Smoothing | Another approach to incorporating spatial information into discriminant analysis is either to presmooth the input electromagnetic-intensity data or to postsmooth the output of standard classification algorithms (Switzer, 1983) . Such smoothers are expected... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 59 | Fitting the Spatial Model | Given in the following text is a (resistant) way of mapping the districts of Scotland, to look for unusually large and unusually small lip-cancer incidence rates, that takes into account unequal variances. From the model (7.5.6), a, {/•*}, and {c,} can be f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Auto-Gaussian Model | For reasons given in the previous section, the confirmatory analysis of the SIDS data will be based on the auto-Gaussian (or CG) model (Section 6.6) of Freeman-Tukey transformed counts (7.6.1). The logistic transformation was not used because it has small-s... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Explanatory Variables | The model (7.5.6) is purely spatial in that its explanatory variables have entries of 0 and 1, describing the spatial locations of the counties relative to each other. To investigate reasons for the spatial clustering and the incidence rates of districts 4... |
| low_priority_review | `ModelTableCandidate` | 36 | GROBID table | Table 7 .5 Maximum Likelihood Estimates of Small-Scale-Variation Parameters (τ 2 ,φ) and 95% Confidence Intervals (ci) for Spatial Dependence Parameter φ, for the 1974-1978 Data* |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | Then the m.l. estimator ή η of η = (β', γ')' satisfies ή" -> η, in probability, •/ 1/2 (ή" -η) Gau(0,1), in distribution, (7.3.16) |

### spacetime: Spatio-Temporal Data in R

- TEI : `corpus\papers\tei\Pebesma_2012_spacetime_JSS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 46 | Panel data | The panel data discussed in Section 2 are imported as a full spatio-temporal data.frame (STFDF), and linked to the proper state polygons of maps. We can obtain the states polygons from package map (Brownrigg and Minka 2012) by: R> library("maps") R> states.... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Classes and methods for spatio-temporal data | The different layouts, or types, of spatio-temporal data discussed in Section 3 have been implemented in the spacetime R package, along with methods for import, export, coercion, selection, and visualisation. |

### spmoran (ver. 0.2.0): An R package for Moran eigenvector-based scalable spatial additive mixed modeling

- TEI : `corpus\papers\tei\spmoran_package_Murakami.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Variables Description tokyo Logarithm of the distance from the nearest railway station to Tokyo Station [km] station Logarithm of the distance to the nearest railway station [km] flood Anticipated inundation depth [m] |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Covariates Coefficients Select SVC or Constant Consider NVC Select NVC or Constant x With SVC x_sel x_nvc x_nvc_sel xconst Without SVC xconst_nvc xconst_nvc_sel |
| low_priority_review | `ModelEvidenceCandidate` | 62 | Spatially and non-spatially varying coefficient models 2.3.1. Varying coefficient modeling | Effects from covariates can vary depending on covariate value. For example, distance to railway station might have strong impact if the distance is small while weak if the distance is large. To capture such effect, the resf function estimates coefficients v... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Eigenvector spatial filtering (ESF) model | The classical ESF model is formulated as follows: = ∑ = where is a fixed coefficient (see Eq.2). captures residual spatial dependence to estimate and infer regression coefficients appropriately. If spatial dependence in residuals is ignored, coefficient sta... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Random effects ESF (RE-ESF) model | The RE-ESF model is formulated as follows: As with the classical ESF, this model is useful to estimate and infer regression coefficients in the presence of residual spatial dependence. Unlike ESF, is given by a random spatial process approximating a Gaussia... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Small area estimation | Small area estimation (SAE; Ghosh and Rao, 1994) is a statistical technique estimating parameters for small areas such as districts and municipality. SAE is useful to obtain reliable small area statistics from noisy data. Suppose that the raw data in the I-... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Moran eigenvector-based spatial regression models | This package assumes the following analysis steps: (a) define Moran eigenvectors; (b) spatial regression using these eigenvectors. Hereafter, Section 2.1 explains (a) whereas Sections 2.2 to 2.5 explain (b). |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Low rank spatial lag model | The low rank spatial lag model (LSLM) approximates the following model: = + + , ~ 0, , where is defined by the classical spatial lag model (SLM) with parameters ρ and . Just like the original SLM, ρ takes a value between 1 and 1/λN (< 0). ρ > 0 in the prese... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Spatially and non-spatially varying coefficient model | Coefficients can vary both spatially and non-spatially. Given that, Murakami and Griffith (2020) developed a spatially and non-spatially varying coefficient (SNVC) model which is defined as = ∑ , , = + + , , = + , + ( , ), ~ 0, . This model defines the k-th... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Low rank spatial econometric models | While Section 2 explains distance-based ESF, RE-ESF, and other spatial regression models approximating a GP (i.e., a geostatistical model), this section explains low rank spatial econometric models, approximating spatial econometric models (see Murakami et... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- [[paper_dataset_ingestion_gaps_2026-07]]
