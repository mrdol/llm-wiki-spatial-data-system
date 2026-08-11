---
title: Revue des candidats model evidence issus de l'audit TEI
type: metadata
created: 2026-08-06
updated: 2026-08-10
sources: [data/manifests/papers/model_evidence_audit.csv]
tags: [metadata, kg, audit, tei, model-evidence, review]
---

# Revue des candidats model evidence issus de l'audit TEI

Date : 2026-08-06

Ce rapport est genere automatiquement depuis `data/manifests/papers/model_evidence_audit.csv`.
Il sert a relire les passages candidats avant toute promotion vers les fiches datasets ou les preuves confirmees du KG.

## Synthese

- Lignes d'audit lues : 5674
- Candidats retenus dans ce rapport : 1361
- Papiers avec au moins un candidat : 142

### Par type

| Type | Nombre |
|---|---:|
| `ModelEvidenceCandidate` | 792 |
| `ModelTableCandidate` | 260 |
| `VariableTableCandidate` | 158 |
| `DataSourceCandidate` | 132 |
| `GenericEstimatorFormulaCandidate` | 19 |

### Par statut

| Statut | Nombre |
|---|---:|
| `extracted_needs_review` | 1342 |
| `rejected_generic_formula` | 19 |

### Action proposee

| Action | Nombre |
|---|---:|
| `low_priority_review` | 940 |
| `review_for_model_evidence` | 233 |
| `review_for_dataset_use` | 169 |
| `reject_generic` | 19 |

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

### A geographic feature integrated multivariate linear regression method for house price prediction

- TEI : `corpus\papers\tei\A geographic feature integrated multivariate linear regression method.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Case Study | The King County Houses Sales data set has 21613 house sales records between May 2014 to May 2015. It provides prices and some other potentially related features(See table 1 ). Table 2 𝑅 2 of regression models Model Training Set Test Set Cross-validation lin... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Proposed approach | Our method can generally be summarized as two folds. First, find a proxy to contain the geographic information possibly related to the housing prices. This proxy is an index for classification to divide the data set into different classes. Then, for each cl... |

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

### A space-time conditional intensity model for invasive meningococcal disease occurrence

- DOI : `10.1111/j.1541-0420.2011.01684.x`
- TEI : `corpus\papers\tei\spatstat.data_meningitis - A SpaceTime Conditional Intensity Model for Invasive Meningococcal Disease Occurrence.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 50 | Extension: Type-Specific twinstim | Although the model of the previous subsection allows for a finetype-specific infectivity through the vector of unpredictable marks m j , it is not applicable for a joint modelling of both finetypes. This is because finetypes do not change during transmissio... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Specification of the Endemic Component h(t, s) | The endemic component is of the multiplicative form h(t, s) = ρ(t, s) exp(β z(t, s)), where ρ(t, s) is a known spatio-temporal intensity offset, e.g. the population density at time t in the district containing the location s, such that the endemic rate of i... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 1 |

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

### Annals of the American Association of Geographers

- DOI : `10.1080/24694452.2024.2350982`
- TEI : `corpus\papers\tei\GeoShapley A Game Theory Approach to Measuring Spatial Effects in Machine Learning Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 62 | GeoShapley Applied to Models | Empirically, as illustrated in Figure 5 , a true model is often unknown to us. Instead, we rely on the available data, such as features X and outcome y, to fit a model, generate predictions, and use an explanation method to explain the model, thereby facili... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Department of Geography, Florida State University, USA | This article introduces GeoShapley, a game theory approach to measuring spatial effects in machine learning models. GeoShapley extends the Nobel Prize-winning Shapley value framework in game theory by conceptualizing location as a player in a model predicti... |

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

### Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data

- DOI : `10.1371/journal.pone.0157166`
- TEI : `corpus\papers\tei\agridat_kayad.alfalfa - Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and Methods |  |

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

### Decapod Biodiversity Hotspots and Environmental Drivers: A Macroecological Approach About Bycatch Species in Brazil

- DOI : `10.1111/jbi.70076`
- TEI : `corpus\papers\tei\Decapod Biodiversity Hotspots and Environmental Drivers - A Macroecological.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 47 | / Species Richness and Phylogenetic Diversity Index | We calculated species richness (SR) for each 1° × 1° grid cell by counting the number of unique decapod species with occurrence records within each cell. To estimate the Phylogenetic Diversity index, the mitogenomic phylogenetic Decapod tree from Shen et al... |
| low_priority_review | `DataSourceCandidate` | 45 | / Environmental Factors | Data from environmental factors were extracted from Bio-ORACLE: Marine data layers for Ecological Modelling version 2.2 (Assis et al. 2017) using the R package 'sdmpredictors' (Bosch and Fernandez 2023) . Were extracted 24 present benthic layers for the fol... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | / Results | A total of 104 species were analysed to calculate SR, comprising 43,002 occurrence points, while 98 species were used for PD.SES and PE.SES metrics, distributed across 169 grid cells with 1° × 1° resolution within the Brazilian Exclusive Economic Zone. Acro... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | TABLE 1 / |

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

### Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced statistical models

- DOI : `10.1371/journal.pone.0277499`
- TEI : `corpus\papers\tei\agridat_tesfaye.millet - Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 51 | Materials and methods |  |

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

### GWRBoost:A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships

- TEI : `corpus\papers\tei\A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships_GWRBoost.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 72 | Variants of geographically weighted regression | Numerous variants have been developed to improve the GWR in various aspects. Several studies focus on the improvement of optimal bandwidth selection. Generally, the choice of bandwidth is crucial to the fitting result of GWR (Fotheringham et al., 2003) . A... |
| low_priority_review | `ModelEvidenceCandidate` | 66 | Computation of Akaike information criterion | The AIC and AICc are the most common metrics to evaluate the fit performance of the GWR model, which are an unbiased estimate of the expected Kullback-Leibler information and a trade-off between goodness of fit and the degree of freedom. In a fitting task,... |
| low_priority_review | `ModelEvidenceCandidate` | 56 | Additive linear model for located observations | In the classic geographically weighted model, an independent linear function is applied to formulate the relationships between dependent and independent variables for each observation i at the specific location: where (u i , v i ) denotes the location of i-... |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 1 : |
| low_priority_review | `ModelTableCandidate` | 33 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Model OLS GWR GWRBoost RSS 1639.063 ± 72.52 83.900 ± 5.049 36.797 ± 2.601 AIC 2385.642 ± 27.65 773.374 ± 36.050 225.512 ± 42.061 AICc 2385.739 ± 27.65 839.926 ± 35.383 274.817 ± 41.207 R 2 0.072 ± 0.02 0.952 ± 0.003 0.979 ± 0.002 Adjusted R 2 0.066 ± 0.02 0... |
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Model OLS GWR GWRBoost RSS 982.206 388.626 261.478 AIC 4499.669 3168.118 2289.994 AICc 4499.720 3315.637 2437.513 R 2 0.557 0.825 0.882 Adjusted R 2 0.556 0.790 0.858 Moran's I 0.333 0.066 -0.027 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |

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

### Geographic range size and speciation in honeyeaters

- DOI : `10.1186/s12862-022-02041-6`
- TEI : `corpus\papers\tei\Geographic range size and speciation in honeyeaters.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 53 | Phylogenetic inference | We used recent phylogenomic analyses [59, 60] in conjunction with traditional nuclear and mitochondrial markers [53] to construct a comprehensive phylogeny of honeyeaters. We followed the IOC world bird list (version 10.2; [77] ), which recognises 191 speci... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Phylogenetic regressions | To test the relationship between range size and speciation, while accounting for other factors that are likely to influence this relationship, measures of range size, shape, and position for each species were treated as traits and used in phylogenetic gener... |

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

### How do Indigenous and local knowledge systems respond to climate change?

- DOI : `10.5751/ES-12481-260327`
- TEI : `corpus\papers\tei\How do Indigenous and local knowledge systems respond to climate change.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Climatic variables |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| review_for_dataset_use | `VariableTableCandidate` | 46 | GROBID table | Climatic variables |

### Identification of a gene associated with avian migratory behaviour

- DOI : `10.1098/rspb.2010.2567`
- TEI : `corpus\papers\tei\Mueller et al 2011, spatial or population model data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelEvidenceCandidate` | 45 | MATERIAL AND METHODS | (a) Samples Thirteen European/African blackcap populations representing the entire range of geographical variation in migration patterns, from Cape Verde to western Russia, have been sampled in the years 1989-1996 (figure 1 ). We also included a sample of b... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 . |

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

### LightGBM: A Highly Efficient Gradient Boosting Decision Tree

- TEI : `corpus\papers\tei\2026-04-23_paper_lightgbm_gradient_boosting_decision_tree.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 2 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |

### Macaque Monkeys Perceive the Flash Lag Illusion

- DOI : `10.1371/journal.pone.0058788`
- TEI : `corpus\papers\tei\Macaque Monkeys Perceive the Flash Lag Illusion.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Data analysis | Data analysis was done in MATLAB using custom-written code. We fitted psychometric functions to the subjects' probability of reporting that the moving bar was located ahead of the flashed bar at different veridical spatial offsets, using the psignifit3 tool... |

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
- TEI : `corpus\papers\tei\Method of the Geographically Weighted Regression and an Example for its Application.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | PPS | -15000.0 15000.1 -25000.0 25000.1 -35000.0 35000.1 -45000.0 45000.1 -Multicollinearity was examined with the help of a Red indicator; the value of which can be between 0 and 1, and the closer it is to 0, the smaller the effect of multicollinearity is (Kovác... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Local analysis of the fragmentation of regional development in Europe | With the help of an example for the application, the paper presents in which aspects the use of the GWR method is better than the use of global regression. Beginning with defining the regional framework: the calculations refer first of all to the EU member... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Weighting options | The weighting options of fixed kernels: the shape and the extension of the kernel is unchanged during the examination. w ij = 1 each i,j where j is a point in the space where the observation was made and i is a point in the space whose parameter was estimat... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Geographically weighted regression | Regression is one of the most widespread mathematical-statistical tools of social scientific researches. Its popularity is based on its essence, since this is a method which is suitable to explore the relationships between the phenomena being the key object... |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 1 |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Unstandardised coefficients Standardised coefficient t Sig. B standard error Beta Constant -17838.8 1824.1 -9.8 0.0 Rate of people employed in the tertiary sector 383.3 16.7 0.536 23.0 0.0 Rate of economically actives 304.1 26.2 0.264 11.6 0.0 Unemployment... |

### Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback

- DOI : `10.1098/rspb.2022.0358`
- TEI : `corpus\papers\tei\Mistletoes could moderate drought impacts on birds but are themselves susceptible to drought-induced dieback.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 45 | level | fixed effect description site-level spatial location WGS84 decimal latitude longitude to 2 m accuracy region 10-level factor defining regional clusters of monitoring sites. Included as a random term in mistletoe and bird models land use 9-level factor: prim... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 62 | (c) Climate data | We sourced climate data from the Australian National University Climate surface database (ANUCLIM v. 6.1 [34] ). We obtained national monthly maximum temperature and rainfall measures between 2017 and 2020 and derived these measures for each of our monitori... |

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

### Once upon Multivariate Analyses: When They Tell Several Stories about Biological Evolution

- DOI : `10.1371/journal.pone.0132801`
- TEI : `corpus\papers\tei\ade4_houmousr - Once upon Multivariate Analyses When They Tell Several Stories about Biological Evolution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 55 | Congruence between main directions of within-group variance among well-sampled groups | The direction of main variance (Pmax) was assessed in the three well-sampled groups of Gardouch (France) and the islands Marion and Corsica. 100 bootstrapped estimates were calculated for each Pmax, providing a 95% confidence interval for the estimation of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 59 | Comparison between patterns of differentiation provided by the different multivariate methods | The representations of differentiation provided by the different multivariate methods applied to the same dataset (molar shape) were compared as follow. The scores of the group means on axes of a given analysis provide a configuration that can be compared t... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Different methods, different evolutionary patterns, all biologically relevant | Considering the present case study, the PCA and the CVA highlight different evolutionary patterns in the evolution of molar shape in insular populations of house mice (Fig 4 ; schematic representation Fig 6 ). The PCA, be it on the total variance or on betw... |

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

### Quasi-likelihood functions, generalized linear models, and the Gauss-Newton method

- TEI : `corpus\papers\tei\wedderburn1974_Quasi-likelihood or generalized linear models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | E@taj E@6 al8*al8j -F(z-A)21 aA aA E{ V(1t)}12J fl&fl since V(,ut) var (z). Also we have -E(8f 4 -E V()J#} -l ( V() m} V(#)Df il V(1 a alCb I al C6 1 altl alj which completes the proof. |

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

### Sampled Grid Pairwise Likelihood (SG-PL): An Efficient Approach for Spatial Regression on Large Data

- TEI : `corpus\papers\tei\Sampled Grid Pairwise Likelihood_homesales_datasets.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `ModelTableCandidate` | 32 | GROBID table | Table 5 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 3 : |
| low_priority_review | `ModelTableCandidate` | 31 | GROBID table | Table 4 : |

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
