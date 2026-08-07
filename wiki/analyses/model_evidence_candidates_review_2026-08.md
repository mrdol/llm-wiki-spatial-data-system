# Revue des candidats model evidence issus de l'audit TEI

Date : 2026-08-06

Ce rapport est genere automatiquement depuis `data/manifests/papers/model_evidence_audit.csv`.
Il sert a relire les passages candidats avant toute promotion vers les fiches datasets ou les preuves confirmees du KG.

## Synthese

- Lignes d'audit lues : 4198
- Candidats retenus dans ce rapport : 1336
- Papiers avec au moins un candidat : 113

### Par type

| Type | Nombre |
|---|---:|
| `DataSourceCandidate` | 723 |
| `ModelEvidenceCandidate` | 521 |
| `VariableTableCandidate` | 79 |
| `GenericEstimatorFormulaCandidate` | 13 |

### Par statut

| Statut | Nombre |
|---|---:|
| `extracted_needs_review` | 1323 |
| `rejected_generic_formula` | 13 |

### Action proposee

| Action | Nombre |
|---|---:|
| `review_for_dataset_use` | 571 |
| `review_for_model_evidence` | 479 |
| `low_priority_review` | 273 |
| `reject_generic` | 13 |

## Regle de lecture

- `review_for_dataset_use` : passage ou tableau prioritaire pour verifier qu'un papier utilise un dataset exploitable.
- `review_for_model_evidence` : passage utile pour verifier formule, estimateur, metriques ou specification empirique.
- `reject_generic` : equation generique d'estimateur, a ne pas transformer en formule publiee dataset.
- `low_priority_review` : signal conserve mais non prioritaire.

## Candidats par papier

### 02-0692-200 ts

- DOI : `10.1007/978-94-015-7799-1`
- TEI : `corpus\papers\tei\anselin1988.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | 5.S.1. Spatial Sampie or Spatial Population | The models typically considered in spatial econometrics, in the sense in which it has been defined for the purposes of this book, are framed in the context of regression analysis. The two main objectives are inference and forecasting. The focus for the form... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | 7.S.1. Bootstrapping in Regression Models: General Principles | The bootstrap and the related jackknife are examples of resampling techniques, which have recently received increased attention in statistics and econometrics. The principle behind these techniques is to use the randomness present in artificially created re... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | 9.S.1. General Principle or the Expansion Method | From an econometric viewpoint, the spatial expansion method can be considered as a special case of systematically varying coefficients in a regression model. The heterogeneity in the phenomenon under study is taken to be reflected in parameter values that d... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | A General Classific:ation oe Models | In Chapter 2, I argued that the main characteristic of spatial econometrics is the way in which spatial effects are taken into account. Of course, this presupposes that space has been formalized in one way or another. Typically, the use of a spatial weight... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | A Taxonomy of Spatial Linear Regression Models for Cross-Sec:tion Data | In this seetion, I present a general specifieation, which forms a framework to organize various modeling situations of interest in spatial eeonometries. The specification pertains to the situation where observations are available for a crossseetion of spati... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Bayesian Approaches to Model Seledion | As discussed in Section 7.2, in a Bayesian approach to model validation the data analysis as such is combined with the decision process inherent in the construction of hypotheses and choice between models. Formally, the evaluation of the validity of a model... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | CHAPTER 9 SPATIAL HETEROGENEITY | Many phenomena studied in regional science lead to structural instability over space, in the form of different response functions or systematically varying parameters. In addition, the measurement errors that result from the use of ad hoc spatial units of o... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Estimation in the Presence oe 8patially Dependent Error Terms | The linear regression model with spatially autoregressive errors is by far the most relevant spatial specification for applied empirical work on cross-sectional data. Indeed, models with spatially lagged dependent variables tend to have a much narrower scop... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | General Issues oe Model Validation in Spatial Analysis | It is generally accepted that the state of the art in spatial theory is still far from adequate to deal with the full scope of real problems faced by cities and regions. In this respect, larger and more complex models and theories have not always contribute... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | IU.2. Error Componmt Model. for Crou Seetion Data | In many situations where observations over time and across space are combined (panel data), the regression error term can reasonably be decomposed into a spatial component, a time-specific componenent and an overall component. Formally, where tJ. 1 is the e... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | SpatiaI EconometricB and Standard EconometricB. | I first consider the distinction between spatial econometrics and traditional econometrics. This can be approached from two main viewpoints. In one, the focus is on the subject matter. Accordingly, All statistical analyses of economic models in regional sci... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Dependence and Aggregation | The second factor which may cause spatial dependence is more fundamental, and foHows from the importance of space as an element in structuring explanations of human behavior. The essence of regional science and human geography is that location and distance... |
| low_priority_review | `truncated` |  |  | 70 autres candidats non affiches dans ce rapport |

### A Generalized Linear Model Approach to Spatial Data Analysis and Prediction

- TEI : `corpus\papers\tei\gotway1997.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 90 | ESTIMATION | For V written in the form given by Equation (2.13), with parameters that describe the spatial dependence among observations incorporated through R(ca), 1G obtained as a solution to Equation (2.9) provides a consistent estimator of /3, and the general equati... |
| review_for_dataset_use | `DataSourceCandidate` | 82 | SPATIAL DATA ANALYSIS: ESTIMATION AND PREDICTION WITH GENERALIZED LINEAR MODELS | In geostatistics, the elements of the correlation matrix R(af), described previously, are obtained from semivariogram models parameterized by constants denoting the nugget effect, the partial sill, and the range. Cressie (1991) described these models and Al... |

### A Review of Software for Spatial Econometrics in R

- DOI : `10.3390/math9111276`
- TEI : `corpus\papers\tei\A Review of Software for Spatial Econometrics in R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Driving Under the Influence | One of the main advantages of GMM methods in space is that this technique is able to handle additional endogenous variables (other than the spatial lag). For this reason we choose to employ the simulated county data set US Driving Under the Influence (DUI)... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Evolution of the ML Estimation | Bivand et al. [48] review the technical issues around the calculation of the log Jacobian term in ML and Bayesian model estimation. It had been established from the mid-1990s that sparse matrix decomposition (Cholesky for symmetric weights matrices and LU f... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Independent Random Effects | The Rice Farms dataset, with observations coming from a large number of small villages employing the same standard technology, is a good candidate for a random effects analysis, perhaps after controlling for the region (which itself is likely to be a source... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Interpretation and Impacts Evaluation | A fuller comparative treatment of model interpretation and the calculation of impacts is given by Bivand and Piras [52] . Difficulties arise from interaction between the spatial dependence modelled in the response, parameterized as λ and the coefficients on... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Filtering Methods | Spatial filtering methods as developed by Griffith [110] build on using standard linear and generalized linear models supplemented with selected eigenvectors from the spatial weights matrix. In [111] [112] [113] , examples were given of how standard and non... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Table 1. | Simulation of the power of a t-test on the regression coefficient at the nominal level of 0.05 for uncorrelated y and x and spatial dependence for the response ρ y and the covariate ρ x , following Smith and Lee [24] . 2 ρ x 0.5 ρ x 0.8 ρ y 0 0.0505 0.0504... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | The Pooled Spatial Model | If one could safely assume out any individual heterogeneity, spatial panels could be estimated by simply applying cross-sectional estimation techniques to the pooled dataset, employing an extended W matrix as specified above. This hypothesis, nevertheless,... |
| review_for_dataset_use | `DataSourceCandidate` | 98 | Developments and Alternative Approaches in Cross-Sectional Models | One of many implementations of Markov Random Field (MRF) spatially structured random effects in generalized additive models (GAM) is found in Wood [91] , implemented in [92] . The neighbour objects needs to be matched to the variable expressing the random e... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Endogeneity in Static Panel Data Models | As we mentioned early, the initial contribution to the application of GM methods for spatial panels dates back to [86] . The y considered a panel data model involving a first order spatially autoregressive disturbance term that, in turn, allowed for an erro... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Introduction | The term spatial econometrics was coined by the Belgian economist Jean Paelinck in 1974 during an address to the Dutch statistical association. A few years later with his famous book "Spatial Econometrics: Methods and Models" Luc Anselin was instrumental to... |
| low_priority_review | `DataSourceCandidate` | 69 | Spatial Panel Data Models | The econometric literature has considered panel regression models with spatially autocorrelated outcomes or disturbances and random or fixed individual effects for more than three decades now. The pioneering book of Anselin [1] and the famous Econometrica p... |
| low_priority_review | `DataSourceCandidate` | 69 | Used Car Prices | In the 1960s, Hanna [7] wanted to examine the effects of regional differences in state taxes and transportation charges on used car prices. The article lists data for the 48 coterminous US states and the District of Columbia. The data set was used by Hepple... |
| low_priority_review | `truncated` |  |  | 17 autres candidats non affiches dans ce rapport |

### A dimension reduction approach to edge weight estimation for use in spatial models

- TEI : `corpus\papers\tei\A dimension reduction approach to edge weight.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Basis functions and spatial models | If y(s) is an observation of a random process at location s ∈ D within some spatial domain (D is typically a subset of R 2 , but could also be the set of spatial regions under the areal data setting), with spatially indexed predictors x(s), a typical model... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Example: Mercer and Hall wheat yield data | We conclude this section with an analysis of the classic wheat yield dataset from Mercer and Hall (1911) and which is available in the spData R package. The version of the data used in the package was taken from Cressie (1993) . Mercer and Hall (1911) consi... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Visualizations of method and interpretation of basis coefficients | As discussed in Christensen and Hoff (2024) regarding the GDEF model, each possible edge weights matrix W corresponds to an embedding of the graph in high-dimensional Euclidean space which is unique up to isometry. The distances between nodes in this embedd... |
| low_priority_review | `DataSourceCandidate` | 61 | Method | Equations 3 and 4 describe two models for areal data, each parameterized by unknown edge weights matrix W. Let w be the q-length vector containing the unknown weights associated with the edges of graph G. The p × p edge weights matrix W may be constructed f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Introduction | Studies involving areal, or region indexed data are common in many settings including ecology (e.g. Hanks and Hooten, 2013) , economics (e.g. Arbia, 2012) , public health (e.g. Jin et al., 2005) and sociology (e.g. Garner and Raudenbush, 1991) . Models for... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Incorporating covariate information | We may be interested in the question of whether certain environmental features inhibit or facilitate connectivity between regions in our spatial domain. As such we may wish to model edge weights as a function of environmental covariates. Generally speaking,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Line graphs and an eigenvector basis | For a graph G, one may define its line graph L(G) as a graph with q nodes corresponding to each of the edges of G, and edges between each pair of nodes corresponding to coincident edges in the original graph G. (Edges are considered coincident if they share... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Prediction | The correlation structures of most models for areal data, including the GDEF and especially the CAR models, are sensitive to the structure of the graph on which they are defined (Wall, 2004; Christensen and Hoff, 2024) . As such, prediction for new or unobs... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Parameter estimation and model fitting | Much of the spatial deformation literature assumes settings in which there are replicate observations of the spatial process whose covariance is being estimated. Commentary on this assumption is provided in the supplemental material. Should we have replicat... |

### A geographic feature integrated multivariate linear regression method for house price prediction

- TEI : `corpus\papers\tei\A geographic feature integrated multivariate linear regression method.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Case Study | The King County Houses Sales data set has 21613 house sales records between May 2014 to May 2015. It provides prices and some other potentially related features(See table 1 ). Table 2 𝑅 2 of regression models Model Training Set Test Set Cross-validation lin... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Proposed approach | Our method can generally be summarized as two folds. First, find a proxy to contain the geographic information possibly related to the housing prices. This proxy is an index for classification to divide the data set into different classes. Then, for each cl... |
| low_priority_review | `DataSourceCandidate` | 66 | Fig. 1 Method schematic | Next part we show the prediction result of this method, along with the results of linear regressions as a comparison. To avoid the right-skewed distribution of the house prices that violate the requirement of Gauss-Markov theorem [15] , in data preprocessin... |
| low_priority_review | `DataSourceCandidate` | 61 | Introduction on linear regression | Assume in one data set, we have 𝑛 observed data 𝑥𝑖1, 𝑥𝑖2, . . . , 𝑥𝑖𝑝, 𝑦𝑖(𝑖 = 1,2, . . . , 𝑛) , then the linear regression model can be expressed as: in Social Science, Education and Humanities Research, Volume 496 Proceedings of the 2020 3rd International... |
| low_priority_review | `DataSourceCandidate` | 59 | Conclusion | This article proposes a geographic feature integrated linear regression method to solve the problem of predicting real estate prices. The framework of this method can easily be extended by adjusting the proxy variable for geographic information as well as a... |
| low_priority_review | `DataSourceCandidate` | 59 | Introduction | As a long-standing research content, the housing price is embracing more and more meanings with the development of society. Apart from satisfying the most fundamental housing demands, real estate has also become an important financial product. In some respe... |

### A new computationally simple test with an application to per capita county police expenditures

- TEI : `corpus\papers\tei\A new computationally simple test with an application to police dataset.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | An application | In order to further illustrate the test we consider a regression model relating county per capita police expenditures in the state of Mississippi to a number of explanatory variables. Let ors be the covariance between the disturbances corresponding to count... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | The test for spatial autocorrelation | The test for the absence of spatial autocorrelation is a test that ;' = 0 in (3). This test is based on the estimated residuals from (1). Let &= y-f(Xi, @). Also let Cov be the h, x 1 vector of products &ii, i<,j which are ordered in the same way as the ele... |

### A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models ☆

- DOI : `10.1016/j.regsciurbeco.2017.04.001`
- TEI : `corpus\papers\tei\MGWR-SAR_Geniaux&Martinetti.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | DGPs with spatial autocorrelation and spatially varying coefficients | In spatial econometric literature, a regression model that considers spatial autocorrelation of the endogenous variable Y is formally written as: where Y is the n-vector of the continuous dependent variable, X is a matrix of k exogenous explanatory variable... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Empirical study on Lucas county pricing data | We conclude the experimentations of the proposed MGWR-SAR( k k 0, , c v ) method and the W-identification procedure by testing their performance on a real data set. We consider the well-known Lucas county house-price dataset foot_1 , in line with what has b... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Estimators for models with spatial autocorrelation and spatial heterogeneity | Although most of the models involving local parameters are unidentifiable because they suppose more parameters than observations, we found in the literature different ways to approximate these local coefficients by introducing conditions on local continuity... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | Usual spatial-econometric estimation frameworks, based on models with spatial autocorrelation and with a given spatial weight matrix are sometimes unfeasible in the presence of model misspecification. In fact, they are unable to disentangle between real spa... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Motivations for spatially varying coefficient models in urban economics | Spatial heterogeneity problems in regression models are, in our point of view, inseparable from other issues such as non-linearities and spatial autocorrelation. It is the case, for example, of the effects of land area on land price in hedonic price functio... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Experiment 1: multicollinearity/concurvity problems | Before testing our family of estimators (MGWR-SAR), we first focus on the potential sources of bias estimation when the data are analyzed via a standard GWR model. To do that, we simulate different datasets, where the introduction of a spatially dependent v... |
| low_priority_review | `DataSourceCandidate` | 67 | Monte Carlo settings | All data are simulated over a coordinate space contained in the unit square [0, 1] 2 with n=1000 observations. We consider four CBDs, positioned around the four points (0.25, 0.25), (0.25, 0.75), (0.75, 0.25) and (0.75, 0.75) respectively, and a set of expl... |
| low_priority_review | `DataSourceCandidate` | 61 | Geographically Weighted Regression (GWR) estimation | For each observation i n ∈ {1, …, } we deal with a different vector of local coefficients β u v ( , ) i i . Consider the following weight matrix M, with size n×n, such that m K d h = ( , ) , for any i n ′ ∈ {1,…, }, with K () a kernel function based on the... |
| low_priority_review | `DataSourceCandidate` | 47 | Conclusions and future works | The goal of this paper was to study the problem of spatial regression models with spatial autocorrelation of the dependent variable and spatial heterogeneity of the parameters, a subject that has not received enough attention in the literature, but that it... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | GWR MGWR | β 0 and β 2 stat. β 0 stat. β 2 stat. 6631 0.1090 0.3344 0.1953 RMSE 0.6816 0.1460 0.3656 0.2289 β u v ( , ) i i 0 BIAS 0.0044 0.0037 0.0039 0.0053 RMSE 0.0068 0.0059 0.0063 0.0073 β u v ( , ) i i 0 BIAS -0.5843 -0.1300 -0.3559 -0.2547 RMSE 0.6011 0.1674 0.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 69 | Experiment 2: robustness of MGWR-SAR estimators | The first experiment taught us that it is preferable to use mixed models whenever we detect that certain independent variables are spatially dependent, and that the coefficients corresponding to those variables and the intercept should be kept stationary. I... |

### A space-time conditional intensity model for invasive meningococcal disease occurrence

- DOI : `10.1111/j.1541-0420.2011.01684.x`
- TEI : `corpus\papers\tei\spatstat.data_meningitis - A SpaceTime Conditional Intensity Model for Invasive Meningococcal Disease Occurrence.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 97 | Application to the IMD Data | Although visual comparisons between the finetypes and heuristic comparisons of the estimates of separate finetype-specific models are possible, this does not allow to assess potential differences statistically. We thus conduct a joint analysis of the two fi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Extension: Type-Specific twinstim | Although the model of the previous subsection allows for a finetype-specific infectivity through the vector of unpredictable marks m j , it is not applicable for a joint modelling of both finetypes. This is because finetypes do not change during transmissio... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Specification of the Endemic Component h(t, s) | The endemic component is of the multiplicative form h(t, s) = ρ(t, s) exp(β z(t, s)), where ρ(t, s) is a known spatio-temporal intensity offset, e.g. the population density at time t in the district containing the location s, such that the endemic rate of i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Statistical Inference | This section deals with likelihood inference for the parameters of the CIF in (5) based on the observed marked spatio-temporal point pattern x = {(t i , s i , m i ) : i = 1, . . . , n}, where the event type κ i is part of the vector of marks m i , and n is... |

### A spatiotemporal weighted regression model (STWR v1.0) for analyzing local nonstationarity in space and time

- DOI : `10.5194/gmd-13-6149-2020`
- TEI : `corpus\papers\tei\A spatiotemporal weighted regression model for nontationarity.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Case study 1 | The time interval of observations in case study 1 was one unit, such as 1 s or 1 d. The value changes of x 1 and x 2 were generated by η 1 = 0.5 and η 2 = 0.1 and were affected by T 1 V with ϕ = 0.5 and n power = 1. This means that x 1 and x 2 only changed... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Case study 2 | The time interval of observations in case study 2 was 10 units. The value change of x 1 was generated by η 1 = 0.5 and affected by T 3 V with ϕ = 0.5, and n power = 2. x 2 was generated by η 2 = 2 and affected by T 2 V with ϕ = 1 and n power = 1, which indi... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results with simulated data | We compared the results of OLS, GWR, GTWR, and STWR. A total of 333 random sample points for five time stages (t 0 , t 1 , t 2 , t 3 , and t 4 from old to new) were collected from the 25×25 lattice generated in the abovementioned DGP. To simplify the calcul... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | The strategy of time distance decay | Since GWR is the background of our work, it is helpful to first give a brief overview of the GWR framework. The basic formulation of GWR can be described in the two equations below (Fotheringham et al., 2003) . In Eq. ( 1 ), y i is a response variable of re... |
| review_for_dataset_use | `DataSourceCandidate` | 83 | Section 1 | various natural and socioeconomic processes. Many studies have attempted to introduce time as a new dimension into a geographically weighted regression (GWR) model, but the actual results are sometimes not satisfying or even worse than the original GWR mode... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Experiments with real-world data | To further test the performance of STWR, we used data on precipitation δ 2 H isotopes in the northeastern United States in another case study. We chose δ 2 H data in 3 d from 29 to 31 October 2012, which includes enough spatiotemporal data for the test. Her... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Steps of using STWR for prediction | In this paper, STWR is used to predict the current values of regression points with known coordinates. The prediction formulas of STWR are more complicated than GWR because the spatial distance is calculated directly from the regression point to each observ... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Case study 3 | The time interval of observations in case study 3 was 200 units. In both case studies 1 and 2, the coefficients in Eq. ( 1 ) were unchanged. In contrast, in case study 3, three surfaces of coefficients changed over time, which were generated by the trends T... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Bandwidth selection and parameter estimation | Some goodness-of-fit diagnostics (Loader, 1999) are widely used in general GWR-based models, such as the crossvalidation (CV) score (Cleveland, 1979; Bowman, 1984) and the Akaike information criterion (AIC) (Akaike, 1973 (Akaike, , 1998)) . For STWR, we use... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Introduction | Time, space, and attributes are three essential characteristics in geographic entities, and they are recorded to reflect the state and evolution of various real-world phenomena and processes. Because space and time frame all aspects of the discipline of geo... |
| low_priority_review | `ModelEvidenceCandidate` | 54 | Discussion and conclusions | Spatiotemporal data analysis is important in many scientific studies. Due to the complexity of spatiotemporal models, the spatiotemporal effect may not be fully taken into account when the temporal and spatial information is manipulated simultaneously. In p... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Reasonable searching range and procedure of optimization | In order to obtain the optimized α and θ for STWR (Eqs. 8 and 9), the search range should be limited. Here we use the distance from each regression point p ( t) i to its Mth nearest neighbor as the initial spatial bandwidth b St at t. The range of b St is w... |

### Above ground carbon stock mapping over Coimbatore and Nilgiris Biosphere: a key source to the C sink

- DOI : `10.1080/17583004.2021.1962979`
- TEI : `corpus\papers\tei\Hari2021Above.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically weighted regression model (GWR) | GWR-a spatial regression model influenced by the revision of equation (01) with the sample observations' locational attribute as an estimating factor [65, 66] . The GWR equation is projected as, where Ŷ is the dependent AGC variable for the associated indep... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Stepwise multiple linear regression model (SMLR) | SMLR-the most widely used non-spatial predictive regression analysis technique to explain the correlation between dependent and independent variables [61, 62] . Using SMLR in AGC estimation, the stepwise regression fitting method was adapted by applying it... |
| low_priority_review | `DataSourceCandidate` | 62 | In-situ and satellite data | The forest inventory sample plots for the dominant species of 0.1 ha (31.6 m Â 31.6 m) [27] comprises measurements of age, diameter at breast height (DBH; 1.37 m above the ground), height for an individual tree, and were aggregated as the plot value [28] .... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Model comparison | For evaluating the model's performance, Taylor diagram analysis was performed [80] . Through the law of cosines, statistics of R, RMSE and SD were plotted contemporaneously to analyse their relation in Figure 7 . All the SMLR model years exhibited practical... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Synergy of AGC and ET | Evapotranspiration-a predominant ramification variable-is the crux of climate and agricultural feedback that bridges the essential biogeochemical cycles-hydrological, energy, and carbon [85, 86] . To understand the systematic relation between the hydrologic... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Gwr model | Geographically Weighted Regression (GWR)-the local spatial model was used to reckon AGC with spatial autocorrelation preponderance. GWR was fitted with a suitable variable using the Ordinary Least Square (OLS) regression model. Regulating both, the variable... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | SMLR model | For the precise understanding of AGC dynamics, SMLR-a prevalent multivariate method of stepwise regression model was used for an accurate assessment. To prognosticate the estimate, SMLR was used to produce quantitatively fitting variable coefficients with t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Methodology and model-description | To estimate AGC at a regional scale, SMLR-a nonspatial predictive regression analysis and GWRspatially weighted regression analysis models were constructed and used in this study. To maximize the study's understanding, the better estimated AGC model was att... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Optimization of variables | As the potential predictors of AGC estimation, the development of spectral, texture, climatic and topographical variables were contrived. For the spectral variables, to utilize the maximum absorption of the red (R) and near-infrared (NIR) wavelengths, along... |
| low_priority_review | `ModelEvidenceCandidate` | 50 | Introduction | Carbon (futurity-C) is stored in all known life forms which accounts the same as it was when our planrt Earth is formed. C is neither created nor destroyed. It is restructured continuously within the entwined system [1, 2] . Above Ground Carbon/ Biomass (AG... |

### Airbnb Offer in Spain-Spatial Analysis of the Pattern and Determinants of Its Distribution

- DOI : `10.3390/ijgi8030155`
- TEI : `corpus\papers\tei\Airbnb Offer in Spain—Spatial Analysis of the Pattern and Determinants of Its Distribution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Finding Factors That Explain the Distribution of Airbnb Listings | In order to identify the factors affecting the distribution of Airbnb listings in Spain, we developed a series of regression models. We built eight models: for each territorial unit of analysis (municipality and tourist areas/sites) and for each type of Air... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and Methods |  |
| low_priority_review | `DataSourceCandidate` | 46 | Data | Homesharing platforms, including Airbnb, do not provide public data on numbers and performance of their rentals. However, such information can be obtained from their webpages through web scrapping. For our analysis, we collected Airbnb data using the script... |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 5 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Factors Affecting the Distribution of Airbnb Listings | After developing four simple regression models at the municipal level, the majority of the explaining variables proved to significantly affect the dependent variables (Table A5 in Appendix D). This is partially a result of a large sample size. Despite corre... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Measuring Concentration and Spatial Autocorrelation of Airbnb Listings, Population and Hotel Supply | In order to numerically describe the level of spatial concentration of the supply of housing, hotel and peer-to-peer accommodation in Spanish municipalities, we employed the Hoover index. It is a widely used metric of spatial concentration, popular in popul... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Factors Affecting the Distribution of Airbnb Listings | After developing four simple regression models at the municipal level, the majority of the explaining variables proved to significantly affect the dependent variables (Table A5 in appendix D). This is partially a result of a large sample size. Despite corre... |

### An Ensemble Learning Approach for Estimating High Spatiotemporal Resolution of Ground-Level Ozone in the Contiguous United States

- DOI : `10.1021/acs.est.0c01791`
- TEI : `corpus\papers\tei\Requia2020Ensemble.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Cross Validation (Seventh Stage). | We performed individual 10-fold cross validation for each one of the three models applied in this study: neural network, random forest, and gradient boosting. Here, we first divided the monitoring sites into 10 splits, and then we trained the models with 90... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model Training (Fourth Stage). | After imputing missing values, we standardized the dataset. Considering a variable "X", data standardization was based on X ij -X mean /X std where X ij is the raw data of the variable "X" on day i in the site j and X mean and X std are the mean and standar... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Predictions (Fifth Stage) and Ensemble Model (Sixth Stage). | After filling in missing values and interpolating data to 1 km grid cells, all predictor variables were available across the study area. Then, we used the trained models to predict daily maximum 8 h O 3 concentrations at each 1 km × 1 km grid cell in the co... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Study Design. | This study was conducted in seven stages. First, we accessed multiple datasets that included daily maximum 8 h O 3 concentrations at sites across the United States and the predictor variables for O 3 , which included weather parameters, gridded output from... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | MATERIALS AND METHODS |  |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | * sı Supporting Information | The Supporting Information is available free of charge at https://pubs.acs.org/doi/10.1021/acs.est.0c01791 . Study design, data source, R script used in the machine learning analyses, list of predictor variables, parameters tuned for base learners, cross-va... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 83 | RESULTS AND DISCUSSION | Table 1 shows the cross-validated R 2 RMSE (square root of the average value of the square of the residual) and slope from the ensemble model by year and for the entire period. For the individual models (neural network, random forest, and gradient boosting)... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Machine Learning Approaches. | We used three machine learning models in this study, including a neural network, random forest, and gradient boosting. All three models were used to attempt to model the complex relationship between the dependent variable and predictor variables with differ... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | INTRODUCTION | Ground-level ozone (O 3 ) primarily results from photochemical reactions involving nitrogen oxides (NO x = NO + NO 2 ) and volatile organic compounds (VOCs) in the presence of sunlight. 1 The spatial variation of O 3 concentration is strongly linked to acti... |

### An Introduction to Spatial Data Analysis and Visualisation in R

- TEI : `corpus\papers\tei\Introduction to Spatial Data Analysis and Visualisation in R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Downloading data from the CDRC data website | Before we introduce you to R and Rstudio, we will first download some data from the CDRC Data Service. On an internet browser go to https://data.cdrc.ac.uk/ In the top right of the screen you will see options to log in or register for an account. If you hav... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Inference with regression | In real world applications, we have access to a set of observations from which we can compute the least squares line, but the population regression line is unobserved. So our regression line is one of many that could be estimated. A different set of Output... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Mutliple regression | So we have seen our models with just one predictor or explanatory variable. We can build 'better' models by increasing the number of predictors. In our case we can also add another variable into the model for predicting the number of people with degree leve... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Practical 10: Geographically Weighted Regression in R | An Introduction to Spatial Data Analysis and Visualisation in R -Guy Lansley & James Cheshire (2016) This practical will teach you how to run a Geographically Weighted Regression (GWR). GWR is a multivariate model which can indicate where non-stationarity m... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Regression analysis | A simple linear regression plots a single straight line of predicted values as the model for a relationship. It is a simplification of the real world and its processes, that assumes that there is approximately a linear relationship between X and Y. Another... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Run a GWR | GWR is the term introduced by Fotheringham, Charlton and Brunsdon (1997, 2002) to describe a family of regression models in which the coefficients are allowed to vary spatially. GWR uses the coordinates of each sample point or zone centroid, ti, as a target... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Run a linear model | First, we will run a linear model to understand the global relationship between our variables in our study area. In this case, the percentage of people with qualifications is our dependent variable, and the percentages of unemployed economically active adul... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Using gridExtra | We will now consider some of the other outputs. We will create four maps in one image to show the original distributions of our unemployed and White British variables, and their coefficients in the GWR model. To facet four maps in tmap we can use functions... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Mean House Price (£) | 170,000 to 484,520 484,520 to 624,840 624,840 to 892,000 892,000 to 1,243,500 1,243,500 to 9,285,189 Missing It is also possible to now run a linear model between our unemployment variable from the 2011 Census and our new average house price variable. model... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Running a local spatial autocorrelation | We will first create a moran plot which looks at each of the values plotted against their spatially lagged values. It basically explores the relationship between the data and their neighbours as a scatter plot. The style refers to how the weights are coded.... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | R squared | In the output above we saw there was something called the residuals. The residuals are the differences between the observed values of Y for each case minus the predicted or expected value of Y, in other words the distances between each point in the dataset... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Loading point data into R | In this practical we will be handling house price paid data originally made available for free by the Land Registry. The sample dataset can be downloaded from the CDRC website here . The data is formatted as CSV where each row is a unique house sale, includ... |
| low_priority_review | `truncated` |  |  | 12 autres candidats non affiches dans ce rapport |

### An ensemble-based model of PM 2.5 concentration across the contiguous United States with high spatiotemporal resolution

- DOI : `10.1016/j.envint.2019.104909`
- TEI : `corpus\papers\tei\Di2019Ensemble.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Base learners and ensemble model | The details of neural network, random forest and gradient boosting algorithms can be found elsewhere (Bishop, 2006) . A simple explanation is that all three machine learning algorithms attempt to model the complex relationship between input variables (X's,... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Machine learning algorithms | Neural networks are able to model any kind of nonlinear and interactive relationship given enough data, suitable for modeling PM 2.5 , where the underlying atmospheric dynamics are elusive, and variables have complex interactions (Bishop, 1995; Haykin and N... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | Table 1 presents the cross-validated R 2 by year. R 2 values ranged from 0.75 to 0.90, with an average of 0.86, indicating good model performance. The spatial R 2 ranged from 0.73 to 0.91, with an average of 0.89, demonstrating that our model can well captu... |
| low_priority_review | `DataSourceCandidate` | 69 | Meteorological conditions | Meteorological conditions were retrieved from the North American Regional Reanalysis (NOAA) data set, with more details about this data set found elsewhere (Kalnay et al., 1996) . The full list of 16 meteorological variables can be found in the supplementar... |
| low_priority_review | `DataSourceCandidate` | 63 | AOD measurements and related satellite data | The Moderate Resolution Imaging Spectroradiometer (MODIS) instrument aboard the Earth Observing System (EOS) satellite has been widely used to measure AOD (Salomonson et al., 1989; King et al., 1992) . The Multi-Angle Implementation of Atmospheric Correctio... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 4 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Gradient boosting % Neural network % Random forest % Spatially lagged monitored PM 2.5 46.52% AOD related variables [c] 9.25% Spatially lagged monitored PM 2.5 28.96% CMAQ PM 2.5 11.58% Spatially lagged monitored PM 2.5 2.68% CMAQ PM 2.5 16.51% CMAQ PM 2.5... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Generalized additive model | Both mixed-effect models and geographically weighted regression assume a linear relationship between predictor variables and the dependent variable, although the coefficients may vary. Generalized additive models use smoothing functions to account for nonli... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Model prediction | After filling in missing values and interpolating, all input variables were available across the study area. We trained the three base learners and the ensemble model with input variables and monitored PM 2.5 as the dependent variable, and then used trained... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 86 | Discussion | Our ensemble model incorporates PM 2.5 predictions from three machine learning algorithms, including neural network, random forest, and gradient boosting, and achieved excellent performance, with a spatial R 2 of 0.89 and spatial RMSE of 1.26 μg/m 3 . Tempo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Conclusion | We used an ensemble model to integrate neural network, random forest and gradient boosting to estimate daily PM 2.5 from 2000 to 2015 for the entire contiguous United States. Predictor variables included satellite measurements, chemical transport model pred... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | (caption on next page) | indistinguishable under the same color scale (Fig. 6 ). The local regression predicting address-specific differences from the 1-km average was examined in the Boston metropolitan area. Fig. 7 shows the estimated concentrations on 100 m × 100 m grid. |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Annals of the American Association of Geographers

- DOI : `10.1080/24694452.2024.2350982`
- TEI : `corpus\papers\tei\GeoShapley A Game Theory Approach to Measuring Spatial Effects in Machine Learning Models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | An Empirical Example of House Price Modeling | To demonstrate the utility of GeoShapley empirically, I use a case study of housing price modeling in the Greater Seattle area, King County, Washington. This case is selected due to the widely recognized importance of geographic location for home values. Th... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Department of Geography, Florida State University, USA | This article introduces GeoShapley, a game theory approach to measuring spatial effects in machine learning models. GeoShapley extends the Nobel Prize-winning Shapley value framework in game theory by conceptualizing location as a player in a model predicti... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | GeoShapley Applied to Models | Empirically, as illustrated in Figure 5 , a true model is often unknown to us. Instead, we rely on the available data, such as features X and outcome y, to fit a model, generate predictions, and use an explanation method to explain the model, thereby facili... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | GeoShapley Principles | Extending from the Shapley value framework, the fundamental concept of GeoShapley, denoted as /, involves considering location features as a single joint player in the model explanation stage. The concept is that joint players participate in the game togeth... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Simulated Examples Simulation Design | This section validates GeoShapley values and their interpretations and provides an example of applying GeoShapley to explain a true model and machine learning models using simulated data. Murdoch et al. (2019) suggested that the evaluation of an explanation... |
| review_for_dataset_use | `DataSourceCandidate` | 76 | Discussion | From both simulated and empirical examples, it is evident that the GeoShapley value provides a useful framework for explaining spatial and nonspatial effects from machine learning models, which helps to better understand the complex processes and relationsh... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 69 | Shapley Value Basics | Shapley values originate from the field of coalitional game theory, named in honor of Nobel Prize Laureate Lloyd Shapley, who introduced the concept in his seminal work (Shapley 1953) . Note that the spelling of Shapley is similar to that of the popular geo... |

### Assessing NO 2 Concentration and Model Uncertainty with High Spatiotemporal Resolution across the Contiguous United States Using Ensemble Model Averaging

- DOI : `10.1021/acs.est.9b03358`
- TEI : `corpus\papers\tei\Di2019Assessing.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 85 | INTRODUCTION | NO 2 , or nitrogen dioxide, is a gaseous air pollutant, which can affect the respiratory system 1 by increasing susceptibility to respiratory infections, 2 exacerbating asthma symptoms, 3 and decreasing pulmonary function. 4 In addition to respiratory sympt... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | DISCUSSION | In this paper, we present an ensemble model to incorporate neural network, random forest, and gradient boosting to estimate daily NO 2 across the contiguous United States. Performance of the ensemble model was excellent, with crossvalidated mean R 2 of 0.79... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Meteorological Data. | Reanalysis data sets rely on data sourced from land-surface monitors, ship, aircraft, satellite radiosondes, pibals, and other sources. The National Oceanic and Atmospheric Administration (NOAA) assimilates these data sets into a data assimilation system an... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Study Area and NO 2 Measurements. | Our study area is the contiguous United States, including 48 states and Washington, DC. The contiguous United States has several NO 2 monitoring networks included in the Air Quality System (AQS) from the Environmental Protection Agency (EPA), encompassing 9... |
| low_priority_review | `DataSourceCandidate` | 69 | Land-cover Variables. | A large percentage of surface NO 2 concentrations stems from local traffic emissions, which are sensitive to land-cover patterns 50 and can be approximated by land-cover terms. Hence, land-use variables are among the most important predictor variables in NO... |
| low_priority_review | `DataSourceCandidate` | 58 | Other Ancillary Variables. | The retrieval algorithm of satellite-based NO 2 is affected by aerosol, surface reflectance 53 /surface albedo, and cloud contamination, 54 although the agreement of satellite-based NO 2 with in situ measurements is usually good. 55 To correct possible erro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Ensemble Model. | To blend NO 2 estimations from the three machine learning algorithms, we used a generalized additive model with penalized spline on both location and NO 2 estimation to account for geographic weights where f 1 denotes a thin plate spline for an interaction... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Environmental Science & Technology | Article the temporal variations and the satellite-derived NO 2 was less important as a result. In the long term, the spatial distribution of surface NO 2 contrasts with that of PM 2.5 and ozone ( Figure S4 ). High NO 2 levels cluster along highways and citi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Three Machine Learning Algorithms. | Previous studies have used neural network, random forest, 63 and other machine learning algorithms to estimate surface-level NO 2 . 17, 23, 33, 34 In these studies, land-cover variables, satellite measurements and other predictors were input variables of th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 73 | METHODS | 3.1. Overview. Our NO 2 model was based on an ensemble model that took estimates from three independent machine learning algorithms. We first fit neural network, random forest, and gradient boosting algorithms with all input predictor variables and monitore... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | RESULTS | The mean cross-validated R 2 was 0.79 for daily NO 2 . The twostep modeling framework indeed improved model performance, with total R 2 improved from 0. S2 ). The spatial R 2 , which we defined as the R 2 between annual averaged monitored NO 2 and estimated... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Model Prediction. | We predicted daily NO 2 at 1 km × 1 km grid cells in the study area with the trained model. In total, there are over 11 million grid cells in the entire study area. The trained model here included trained neural networks, random forests, gradient boosting m... |

### Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data

- DOI : `10.1371/journal.pone.0157166`
- TEI : `corpus\papers\tei\agridat_kayad.alfalfa - Assessing the Spatial Variability of Alfalfa Yield Using Satellite Imagery and Ground-Based Data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 82 | Alfalfa yield data | For better quality of alfalfa yield, the crop was harvested at 10% bloom (harvest number 9 and 11), 30% bloom (harvest number 10) and 50% bloom (harvest number 8) stages of the alfalfa crop. Considering the climate at the time of harvesting and the behavior... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and Methods |  |
| low_priority_review | `DataSourceCandidate` | 61 | Alfalfa yield monitoring | A large rectangular baler (CLAAS model Quadrant 3200), equipped with a hay yield monitoring system (model 500 of Harvest Tec), was used for recording, on-the-go, the alfalfa yield data at the time of baling (Fig 3 ). The monitoring system provided data on t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Geostatistical analysis | The spatial variability of alfalfa yield was assessed by employing geostatistical tools. Geostatistical analysis, including semivariogram model fitting and kriging procedures, were carried out using the ArcGIS software program (ver. 2010). As depicted in Fi... |

### Balancing structural complexity with ecological insight in Spatio-temporal species distribution models

- DOI : `10.1111/2041-210X.13957`
- TEI : `corpus\papers\tei\Laxton2022Balancing.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Existing methods for species distribution modelling include: | approaches developed to deal with presence-only datasets (such as maximum entropy algorithm, distance sampling, similarity, and envelope methods such as MAXENT, Gower metric, Mahalanobis distance, and ecological niche factor analysis); machine-learning algo... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Data | We investigate the spatial distribution of a resident breeding population of Eurasian crane in England following the return of the species to the UK in 1979 (Stanbury, 2011) , with the aim of predicting the distribution of the population in future years. Br... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Single-field models | In order to explore what level of model complexity is needed to answer relevant ecological questions based on the crane data, we start with a relatively simple spatio-temporal model in continuous space. To improve our understanding of the spatio-temporal di... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | / DISCUSS ION | In this paper, we have fitted four different models of varying complexity. The simplest model is a spatio-temporal model with a single likelihood with an IID assumption between years. We will now compare the relative benefits of the different models with re... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | TA B L E 1 | Posterior mean and 95% credible intervals for: Regression coefficients of environmental covariates; scaling parameter ( ) representing the interaction between G(s) and the probability of crane presence; temporal correlation parameter from the AR1 process; p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / INTRODUC TI ON | The continuing increase and the improvement both of the availability and detail of ecological information, and of computational resources allows realistically complex and flexible statistical models to be fitted to ecological data. However, increasing struc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 77 | / Point process methodology and INLA | As model complexity increases-for example, when spatiotemporal correlation structures are included as complex model components-an advantageous approach can be found in Bayesian hierarchical modelling (Cressie et al., 2009) . Hierarchical models allow parame... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | / RE SULTS | In both the binomial presence/absence model (Equation 2 ) and marked point process model (Equation 4 ), which incorporated an AR1 temporal correlation structure, the correlation parameter for the AR1 process, t , (which is bounded between -1 and 1) was esti... |

### Bayesian analysis of agricultural ®eld experiments

- TEI : `corpus\papers\tei\Bayesian analysis of agricultural field experiments.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion on the Paper by Besag and Higdon | Fig. 14 . Wireframe plots of sample variograms for the base and ®nal models for each county (1998), Gilmour et al. (1998) and Smith et al. (1998) . Fig. 14 presents the sample variograms of the residuals for base and ®nal models for each county. Both models... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | A randomized complete-block variety trial on wheat | In this section, we reanalyse an RCB experiment on wheat, carried out at El BataÂ n, Mexico, by the International Center for Improvement of Maize and Wheat. There are three separate single-column replicates, each containing 50 varieties, and so we apply one... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Other Gaussian representations | An appealing alternative approach is to represent fertility by a process in continuous space and to integrate over each plot to obtain corresponding average values i , as proposed in the pioneering work of Whittle (1954) and MateÂ rn (1960) . Of course, the... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Binary data from an experiment on morning-glory plants | In this section, we describe an analysis of binary observations, though the complete data are in the form of counts. This is one aspect of an experiment concerning the maintenance of genetic variation in morning-glory (Ipomoea purpurea) plants: in particula... |
| low_priority_review | `DataSourceCandidate` | 69 | Donald A. Preece (University of Kent, Canterbury) | Experiments on agricultural crops may be on land at a research station, or on farmers' ®elds or possibly on terrain newly cleared for agriculture. The land may be alluvial soil, or savannah, or a terrace on a mountain-side. Statistical methodology that is b... |
| low_priority_review | `DataSourceCandidate` | 62 | Results | Fig. 1 shows two dierent additive decompositions of the yields. The upper one corresponds to the basic Bayesian formulation, with Gaussian components for the likelihood and the variety and fertility priors. This agrees closely with the decomposition when Ga... |
| low_priority_review | `DataSourceCandidate` | 61 | A variety trial on strawberries | In this section, we compare several dierent analyses of a small data set involving eight varieties of strawberries. The data are reproduced in Table 4 ; see also Mead (1988) , chapter 10. As is evident, shading from a hedge severely delayed crop production... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Prior distributions for fertility effects 2.3.1. Basic Gaussian representation | In specifying a basic prior distribution for the fertilities , over a q 1 Â q 2 array, we restrict attention to a class of non-stationary Gaussian intrinsic autoregressions (KuÈ nsch, 1987; Besag et al., 1991; Besag and Kooperberg, 1995) . Let i $ j denote... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Discussion | In this paper, we have developed Bayesian methodology for the analysis of agricultural ®eld experiments, a topic that has received little attention previously despite a vast frequentist Fig. 7 . Individual and combined variety estimates for the top 10 varie... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Other issues | Gilmour and Talbot add competition and interference to the list of possible complications. We agree that design, rather than analysis, should play the key role in tackling these, though additional plots may then be required. One advantage of spatial analysi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Locally quadratic representation | When 0:5, equation (2.5) is equivalent to locally planar interpolation of fertilities by the method of ordinary least squares. An alternative is to adopt locally quadratic interpolation, based on the eight plots closest to i, in which case the weights attac... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Comparisons | Some discussants suggest that the comparisons we make between Bayesian and frequentist analysis are unfair, in optimizing the one but not the other. Several complain that there is no attempt at assessment, which is correct and partly re¯ects the diculty in... |
| low_priority_review | `truncated` |  |  | 4 autres candidats non affiches dans ce rapport |

### Benchmarking Regression Models Under Spatial Heterogeneity

- DOI : `10.4230/LIPIcs.GIScience.2023.11`
- TEI : `corpus\papers\tei\Wiedemann_Martin_Westerholt_2023_SpatialHeterogeneityBenchmark.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data-generating processes (DGPs) | One of our investigated DGPs represents a linear relationship of Y on k independent variables x j (j ∈ [1..k]). It is given as where x ij is the j-th feature of the i-th sample, (u i , v i ) are the coordinates of the i-th sample, and β j (u i , v i ) is th... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Datasets | There are five real-world, publicly available datasets that we employ for validation: The California housing dataset 5 was generated from the 1990 California census. Our goal is to predict the median house price from the location and seven other variables,... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Random Forest Regression models | Random Forests (RFs) are established machine learning models for regression tasks and have been shown to be very successful for a wide range of applications. We choose RFs as the main non-linear model in our experiments since it is arguably most prominent i... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results obtained from real-world data | To validate the model selection tree presented in Figure 9 on real-world data, we first compute an indicator for the degree of non-stationarity. The LOSH statistic [21] offers a way to estimate local heterogeneity in terms of a local, spatially-weighted var... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Random Forests | Aside from simply extending non-linear models by adding geographic coordinates or spatial features as covariates, another option is to fit them locally, as a non-linear counterpart to GWR. Similar to [11] , we implement this approach for RFs. To provide a l... |
| review_for_dataset_use | `DataSourceCandidate` | 89 | Conclusions | While many promising regression methods were developed specifically for spatial data, there is a lack of analysis about the properties of data that render such models superior. We contribute to a better understanding of these conditions with an analysis sys... |
| review_for_dataset_use | `DataSourceCandidate` | 76 | Results obtained from synthetic data | The model performances in terms of test-data RMSE are visualized in Figure 4 , divided by data generating function (row), spatial non-stationarity (x-axis), and noise level (y-axis). Only the scenarios with 1000 samples and uniformly distributed noise ϵ are... |
| review_for_dataset_use | `DataSourceCandidate` | 75 | Methods | We simulate a spatial regression problem with synthetically generated data that are subject to spatial heterogeneity. Spatial heterogeneity in our analysis stems from two effects; on the one hand, the dependence of the dependent variable foot_0 Y on the ind... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Proposed criteria for model selection | Our experiments on synthetic data allow to derive recommendations for choosing a model, dependent on the prediction task and on data availability. In general, the results in Figure 4 render linear models such as SLX most suitable for the linear DGP, with cl... |
| low_priority_review | `DataSourceCandidate` | 65 | Results based on real-world data | We experiment with five benchmark datasets that have been used in previous work on spatial data analysis and prediction, e.g. [19, 22, 14, 1] . The following sub-section first introduces these datasets. Afterward, we discuss the results obtained. |
| low_priority_review | `DataSourceCandidate` | 64 | Related work | Statistical learning methods have been adapted to geospatial data since a long time. A major step towards accounting for spatial heterogeneity has been the proposal of local models, such as Geographically Weighted Regression (GWR) [3, 9] . Next to variants... |
| low_priority_review | `DataSourceCandidate` | 61 | Non-stationary coefficients β | In contrast to previous work assuming a complete variation of the coefficients [10, 13] , we argue that with many types of real-world processes, it would be more reasonable for the coefficients to vary around a constant value c j . To simulate this, we fram... |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### Boosting Algorithms: Regularization, Prediction and Model Fitting

- DOI : `10.1214/07-STS242`
- TEI : `corpus\papers\tei\GAMboosting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 94 | R> x <-t(exprs(westbc)) R> y <-pData(westbc)$nodal.y | We aim at using L 2 Boosting for classification (see Section 3.2.1), with classical AIC based on the binomial log-likelihood for stopping the boosting iterations. Thus, we first transform the factor y to a numeric variable with 0/1 coding: |
| low_priority_review | `DataSourceCandidate` | 68 | Slow Overfitting Behavior | It had been debated until about the year 2000 whether the AdaBoost algorithm is immune to overfitting when running more iterations, that is, stopping would not be necessary. It is clear nowadays that Ada-Boost and also other boosting algorithms are overfitt... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | 5.3.1 | Componentwise linear least squares. We consider L 2 Boosting with componentwise linear least squares. Denote by the n × n hat matrix for the linear least squares fitting operator using the j th predictor variable denotes the Euclidean norm for a vector x ∈... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | BinomialBoosting | For binary classification with Y ∈ {0, 1}, Binomi-alBoosting uses the negative binomial log-likelihood from (3.1) as loss function. The algorithm is described in Section 3.3.2. Since the population minimizer is f * (x) = log[p(x)/(1p(x))]/2, estimates from... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Componentwise Linear Least Squares for Linear Models | Boosting can be very useful for fitting potentially high-dimensional generalized linear models. Consider the base procedure It selects the best variable in a simple linear model in the sense of ordinary least squares fitting. When using L 2 Boosting with th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | R> yfit <-as.numeric(y) -1 | The general framework implemented in mboost allows us to specify the negative gradient (the ngradient argument) corresponding to the surrogate loss function, here the squared error loss implemented as a function rho, and a different evaluating loss function... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Trees | In the machine learning community, regression trees are the most popular base procedures. They have the advantage to be invariant under monotone transformations of predictor variables, that is, we do not need to search for good data transformations. Moreove... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Binary Classification | For binary classification, the response variable is Y ∈ {0, 1} with P[Y = 1] = p. Often, it is notationally more convenient to encode the response by Ỹ = 2Y -1 ∈ {-1, +1} (this coding is used in mboost as well). We consider the negative binomial log-likelih... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Connections to binary classification. | Motivated from the population point of view, the L 2 -or L 1 -loss can also be used for binary classification. For Y ∈ {0, 1}, the population minimizers are Thus, the population minimizer of the L 1 -loss is the Bayes classifier. Moreover, both the L 1 -and... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Initialization of Boosting | We have briefly described in Sections 2.1 and 4.1 the issue of choosing an initial value f [0] (•) for boosting. This can be quite important for applications where we would like to estimate some parts of a model in an unpenalized (nonregularized) fashion, w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | PoissonBoosting | For count data with Y ∈ {0, 1, 2, . . .}, we can use Poisson regression: we assume that Y /X = x has a Poisson(λ(x)) distribution and the goal is to estimate the function f (x) = log(λ(x)). The negative loglikelihood yields then the loss function ρ(y, f ) =... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 77 | Methodology and Applications | Boosting methodology has been used for various other statistical models than what we have discussed in the previous sections. Models for multivariate responses are studied in [20, 59] ; some multiclass boosting methods are discussed in [33, 95] . Other work... |
| low_priority_review | `truncated` |  |  | 9 autres candidats non affiches dans ce rapport |

### Building a sustainable development index and spacial assessment of municipalities inequalities in the state of Ceará

- DOI : `10.1590/0034-7612163114`
- TEI : `corpus\papers\tei\Silva2018Construcao.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | AGGREGATING INDICATORS THROUGH SPATIAL ECONOMETRIC MODELING | The standardized SDI of each municipality was used to form a spatial stochastic process, i.e., a sequence of random variables ordered according to the geographic criterion, forming spatial data. According to Almeida (2012) this spatial data is a sample of p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 99 | SPATIAL MODELING TO MEASURE INEQUALITY IN MUNICIPALITIES OF THE STATE OF CEARÁ | The spatial econometric modeling began with the standardization of the indicators formed by the confirmatory factorial analysis, determining value 1 for the municipality with the highest index and 0 for the municipality with the lowest index. There is evide... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | BUILDING THE SUSTAINABLE DEVELOPMENT INDEX | The statistical analysis of the data seeking to create the SDI started with the application of the CFA, considering all the indicators presented in table 1. In order to ensure the factorial validity of the CFA model, indicators with no significant factorial... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | INTRODUCTION | Brazil presents the tenth highest GINI index in the world, which confirms a marked social inequality. Additionally, there are significant interstate and regional differences (Barros, 2011) . According to Araújo (2009) , the focus of inequality lies in the d... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | WEIGHTING CALCULATION OF THE SUSTAINABLE DEVELOPMENT INDEX | Based on the set of indicators presented in chart 1, the weighting calculation of the Sustainable Development Index (SDI) was conducted using the Confirmatory Factor Analysis (CFA). A reflexive model was adjusted because the level of development in each dim... |

### Cluster detection of spatial regression coefficients

- DOI : `10.1002/sim.7172`
- TEI : `corpus\papers\tei\Lee2016Cluster.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Southeast U.S.A Cancer Mortality Data | The dataset comprises 616 counties in seven U.S. states: Alabama, Florida, Georgia, Mississippi, North Carolina, South Carolina, and Tennessee. For each county, the cancer mortality rate is defined as the number of deaths of cancer patients per 100,000 popu... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Test for Spatial Cluster Effects in a Simplified Setting | Let D denote a spatial domain of interest in R 2 . Let N denote the number of cells that partition the spatial domain D and form a spatial lattice. For cell i = 1, … , N, let y i denote the ith response variable. We model the response variable as y i = 𝜇 i... |
| review_for_dataset_use | `DataSourceCandidate` | 88 | Introduction | Cluster detection, the identification of spatial units adjacent in space that are associated with distinctive patterns of data of interest relative to background variation, is an important problem in disciplines such as spatial epidemiology and disease surv... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Evaluation of Coverage of the True Clusters | For two true clusters, we evaluated the coverage of detected clusters. We considered a total of three different two cluster settings. The two circular clusters have the same radius 3/25 unit. The two clusters are adjacent each other in the first setting and... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Single Cluster | In Section 2.1, a fixed cluster is assumed to be known a priori. Now, we relax this assumption and consider spatial cluster detection in the regression coefficients without assuming a fixed cluster. Let C = {C 1 , C 2 , …} denote the set of all possible clu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Multiple Clusters | To detect potential additional clusters, we propose a sequential algorithm. That is, we estimate the first cluster Ĉ1 = arg max C∈C F(C), where C is pre-defined with N cells on the spatial lattice and the maximum radius is R max . To test H 0 ∶ 𝜽 C = 0 for... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Simultaneous Detection | Table II's left panel and Table III's top panel provide the significant clusters and the corresponding coefficient estimates that were detected via the simultaneous detection method at 𝛼 = 0.05. There are a total Table III. Coefficients estimates for sequen... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Two-Stage Detection | Table II's right panel and Table III 's bottom panel provide the significant clusters and the corresponding coefficient estimates that were detected via the two-stage detection method at 𝛼 = 0.05. There are a total of five detected clusters with one overlap... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Simulation Study | We conducted a simulation study to evaluate our previous methodology for a single cluster or two clusters that have either overlapping or non-overlapping cells. We consider a 25×25 square grid in the unit square [0, 1] × [0, 1], which is partitioned into 62... |
| low_priority_review | `ModelEvidenceCandidate` | 51 | Conclusions and Discussion | We have developed in this paper a new methodology to detect spatial clusters in the regression coefficients. Both the simultaneous detection and the two-stage detection methods can be used to find geographic regions that have different relationship between... |

### Comparing spatially varying coefficient models: a case study examining violent crime rates and their relationships to alcohol outlets and illegal drug arrests

- DOI : `10.1007/s10109-008-0073-5`
- TEI : `corpus\papers\tei\wheeler2008_Comparing spatially varying coefficient models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Estimating Houston violent crime rates with spatially varying coefficient models | In this section, we present the results of estimating the GWR and Bayesian SVCP model parameters for the Houston violent crime data. For the violent crime data, the base model is where y is the natural log of the number of violent crimes (murder, robbery, r... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically weighted regression | The technical details underlying GWR have been described elsewhere (Fotheringham et al. 2002 ), but we review the basics here for completeness. In GWR, a regression model can be fitted at each observation location in the dataset. The spatial coordinates of... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model prediction | Also of interest in spatial regression models and violent crime analysis is the prediction of the response variable for a new observation, for example the crime rate at a new census tract or for a tract for which violent crime data are missing. Both GWR and... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Bayesian SVCP model and coefficient shrinkage | In comparing the GWR and SVCP models on similar footing, features in model properties become apparent. One such feature is the similarity between the Bayesian SVCP model and ridge regression, which allows us to summarize the nature of the Bayesian shrinkage... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 92 | Introduction | Statistical models enable estimation of associations between an outcome of interest and a set of covariates measured on the same observational units. Statistical linear model theory provides the pervasive analytic tool of linear regression for Gaussian outc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 90 | Conclusions | In this paper, we have compared two different approaches, geographically weighted regression and a Bayesian SVCP model, for estimating potentially spatially varying regression coefficients for alcohol sales outlets and illegal drug violations to explain Fig... |

### Crowdsourced air traffic data from the OpenSky Network 2019-2020

- DOI : `10.1093/jtm/taaa011`
- TEI : `corpus\papers\tei\2026-04-23_paper_opensky_network_dataset_essd_2021.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 83 | Derivation of flights | We define a flight for the purpose of this dataset as the continuous time between the first received ADS-B contact of one specific aircraft and the last. Such a flight's length must be at least 15 min. This filter avoids noise from misconfigured transponder... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Data cleaning | To make the data accessible and meet requirements, complex pre-processing is needed in order to reduce the reduce the data volume and eliminate the need to understand all system aspects in order to use the data. Moreover, the infor-mation quality needs to b... |
| low_priority_review | `DataSourceCandidate` | 69 | Background | Crowdsourced research projects are a form of "citizen science" whereby members of the public can join larger scientific efforts by contributing to smaller tasks. In the past, such efforts have taken many forms including attempting to detect extra-terrestria... |
| low_priority_review | `DataSourceCandidate` | 69 | Crowdsourced collection | The raw data used to generate the dataset were recorded by more than 3000 crowdsourced sensors of the OpenSky Network. The network records the payloads of all 1090 MHz secondary surveillance radar downlink transmissions of aircraft along with the timestamps... |
| low_priority_review | `DataSourceCandidate` | 69 | Decoding | Decoding ADS-B correctly is a complex task. Although libraries and tutorials such as that of Sun et al. (2019) exist, it remains a tedious task that requires a deep understanding of the underlying link layer technology Mode S. Moreover, the sheer volume of... |
| low_priority_review | `DataSourceCandidate` | 69 | Technical validation | In the following, we provide some statistics showing that our flights dataset reflects the air traffic reality as different time series showing the effect of the COVID-19 pandemic at different airports and for different airlines. Table 2 shows the distribut... |
| low_priority_review | `DataSourceCandidate` | 69 | Usage notes | This dataset may differ from other data sources due to limitations of ADS-B data. On the other hand, there are advantages as it reflects all aircraft types rather than only commercial airlines. It is important to note that ADS-B equipage has been increasing... |
| low_priority_review | `DataSourceCandidate` | 51 | Introduction | In this paper, we present a dataset of global flight movements derived from crowdsourced air traffic control data collected by the OpenSky Network (Schäfer et al., 2014) , which are widely used in many fields, including several areas pertaining to Earth sys... |

### DIFFUSION CONVOLUTIONAL RECURRENT NEURAL NETWORK: DATA-DRIVEN TRAFFIC FORECASTING

- TEI : `corpus\papers\tei\2026-04-23_paper_dcrnn_traffic_forecasting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 94 | EXPERIMENTAL SETTINGS | Baselines We compare DCRNN foot_0 with widely used time series regression models, including (1) HA: Historical Average, which models the traffic flow as a seasonal process, and uses weighted All neural network based approaches are implemented using Tensorfl... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | INTRODUCTION | Spatiotemporal forecasting is a crucial task for a learning system that operates in a dynamic environment. It has a wide range of applications from autonomous vehicles operations, to energy and smart grid optimization, to logistics and supply chain manageme... |
| low_priority_review | `DataSourceCandidate` | 58 | E DETAILED EXPERIMENTAL SETTINGS | HA Historical Average, which models the traffic flow as a seasonal process, and uses weighted average of previous seasons as the prediction. The period used is 1 week, and the prediction is based on aggregated data from previous weeks. For example, the pred... |
| low_priority_review | `DataSourceCandidate` | 49 | CONCLUSION | In this paper, we formulated the traffic prediction on road network as a spatiotemporal forecasting problem, and proposed the diffusion convolutional recurrent neural network that captures the spatiotemporal dependencies. Specifically, we use bidirectional... |

### Data Descriptor: A global dataset of air temperature derived from satellite remote sensing and weather stations

- DOI : `10.1038/sdata.2018.246`
- TEI : `corpus\papers\tei\Hooker2018Global.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Background & Summary | Air temperature is a fundamental biophysical variable that influences almost all biotic processes, as well as many abiotic processes globally. Gridded climatologies describe how air temperature varies geographically and seasonally, but in reality there are... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Climate space weighted regression | The logic of applying repeated weighted regressions based on proximity in geographic space can equally be extended to proximity in climate space. The relationship between air temperature and LST could even be more consistent over stations with similar clima... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Input data | The Global Historical Climatology Network -Monthly (GHCN-M) dataset 13 is used as the source for reference air temperatures. This dataset provides monthly average air temperature at a large number of weather stations from sometimes up to more than 100 years... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Stacked generalisation | Predictions of air temperature based on GWR and on CSWR are finally combined to make an overall prediction of air temperature, using stacked generalisation. Stacked generalisation is a method to optimally combine multiple statistical models into an ensemble... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Technical Validation | The dataset we describe consists of predictions made from a statistical model that we have developed. Independent observations of air temperature, with which we might validate these predictions, are not available. However, the nature of our statistical mode... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Usage Notes | We provide files with predicted air temperatures from 2003 to 2016. However, we also provide files with monthly coefficients for both GWR and CSWR models, and provide the stacked generalisation coefficients in Table 1 and in a separated file, meaning that a... |
| review_for_dataset_use | `DataSourceCandidate` | 96 | General approach | Air temperature is fundamentally a spatio-temporal phenomenon, varying in both space and time. Adding to this complexity, temperatures vary at daily and seasonal scales. If we were to develop a model to predict air temperature for a given month, that month... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Geographically weighted regression | When a regression is applied over geographically-distributed data, the coefficients of that regression model need not in fact to be constant over space. Geographically weighted regression was developed to deal with this non-stationarity. Rather than calibra... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Coefficients and model predictions | Once both GWR and CSWR models are calibrated, a first result consists of the respective monthly β coefficients. Figure 3 shows these coefficients for the month of June, with the maps illustrating how the GWR β coefficients vary geographically, and the clima... |

### Determinants and spatial dependence of innovation in Brazilian regions: evidence from a Spatial Tobit Model

- DOI : `10.1590/0103-6351/4456`
- TEI : `corpus\papers\tei\Araujo2019Determinants.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 3 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | Introduction | The location of innovation and the role of proximity in knowledge fl ows have received increasing attention in the regional science and economic geography literatures. Assessing innovation from a regional perspective assumes that innovative activities are i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 75 | Results | Three versions of the model were estimated using 2 years of pooled data (2004 and 2005) with a total sample size of 1,116 observations (558 microregions x 2 years). The fi rst version is an OLS (model 1) that includes all the variables but without spatial f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Local Innovation (PatPC). | The dependent variable is patent applications per capita for each region, a proxy for local innovation (Moreno et al., 2005; Crescenzi et al 2007; Autant-Bernard and LeSage, 2011; Kang and Dall'erba 2014; Corsatea and Jayet, 2014; Paci et al., 2014) . Paten... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Regional determinants of innovation | Innovation does not occur in the same manner in different locations. Remarkably, it depends on fi rms' local environment because fi rms not only use internal resources to innovate but also employ external local factors to foster innovation. Knowledge creati... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Methodology and model specifi cation | The role of geography in innovation was fi rst shown by Jaffe (1989) , who applied an adapted version of Griliches' (1979) KPF to geographical units. Later, this set of econometric models was improved with spatial econometrics tools and more specifi c data... |
| low_priority_review | `ModelEvidenceCandidate` | 46 | Conclusions | Innovation depends on a wide range of factors. Several elements that can benefi t from the innovation results must be considered when analysing this phenomenon from the regional point of view. For this reason, many studies have sought to explore how and why... |

### Determinants of Airbnb prices in European cities: A spatial econometrics approach

- DOI : `10.1016/j.tourman.2021.104319`
- TEI : `corpus\papers\tei\Determinants of Airbnb prices in European cities A spatial econometrics approach.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Dataset | In order to collect Airbnb offers that would be presented to a real user, an automated experiment was conducted based on web-scraping. With the use of a web-automation framework (Selenium WebDriver), search queries were executed on the Airbnb platform that... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model selection | Our analysis is based on Python programming language and the PySAL package (Rey & Anselin, 2007) . The scripts prepared for the spatial regressions and robustness checks are published along with the datasets at Zenodo. First, Moran's I is calculated to test... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | Dataset and methodology |  |
| low_priority_review | `VariableTableCandidate` | 48 | GROBID table | Table 3 |
| low_priority_review | `VariableTableCandidate` | 48 | GROBID table | Table 4 |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 5 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Spatial models | If the observations of the explained variable are affected by the neighbouring observations, we need to include a spatial lag in our model. The spatial lag of the dependent variable (also noted as WY) represents the linear combination of y constructed from... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 79 | Regression results | Figs. 3 4 5 summarise the results for size, quality, and location attributes. The graphs present the results for the baseline OLS and the three spatial models: the colour of the circle reveals the estimation method, while the transparency shows whether the... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 77 | Considerations for methodology | The results show that measures based on the distance from certain points (e.g., city centre) are not optimal for measuring the price premium for location. However, the TripAdvisor indices, based on up-todate data on tourist preferences, provided detailed in... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Managerial and policy implications | The proposed methodology enables a more accurate measurement of price premiums related to various listing attributes. Therefore, our results are highly relevant for both the hospitality sector, as well as for urban planners. Investors and prospective hosts... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Robustness checks | To further verify our results, various robustness checks were carried out. Fig. B1 shows the coefficients of selected variables for the weekend and weekday samples. The differences in statistical significance are minor: e.g., there are some changes in the c... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Differential Evolvability Along Lines of Least Resistance of Upper and Lower Molars in Island House Mice

- DOI : `10.1371/journal.pone.0018951`
- TEI : `corpus\papers\tei\ade4_houmousr - Differential Evolvability Along Lines of Least Resistance of Upper and Lower Molars in Island House Mice.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and Methods |  |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Samples | The study was based on wild-trapped populations of house mice (Mus musculus domesticus). Sampling included mainland populations (Southern France and Northern Italy) and insular populations from Sardinia, Corsica, and Piana, an islet 0.06 km 2 large and 300... |
| low_priority_review | `DataSourceCandidate` | 48 | Size and shape descriptors | The overall shape of each molar was measured as the outline of the two-dimensional projection of the tooth viewed from the occlusal surface, with focus towards the basis of the crown at the widest part of the tooth. This outline registers the relative posit... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Differential allometry responsible for different evolvability of the upper and lower molars | We thus looked for a factor that may drive a faster evolution of the upper molar compared to the lower molar. Size evolution is often marked on islands, being part of the ''island syndrome'' [44, 45] . Accordingly, mice in Piana are larger and display large... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Directions of greatest variance as lines of least resistance to evolution | Directions of evolution were evaluated in two ways: first, as the first eigenvector of a VCV matrix including all samples, and hence expressing the total variance across mainland and the various islands. Despite including a part of intra-population variance... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Direction of variance, direction of co-variation between teeth, and allometry | Directions of evolution between populations were evaluated as the difference of the averaged FCs per locality. The main direction of shape variance was calculated as the first eigenvector (V1) of the variance-covariance (VCV) matrix of the FCs. Main directi... |

### ECONOMICS OF SITE SPEC1fi1C NITROGEN MANAGEMENT IN CORN PRODUCTION

- TEI : `corpus\papers\tei\Anselin-SpatialEconometricApproach-2004.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Profitability of VRT-N | The optimal level N by landscape position is computed in the standard fashion using ordinary calculus. Net returns over fertilizer cost, VRT application fee, added non-N fertilizer costs for maintenance, and extra harvest and handling costs are taken into a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Section 1 | Geographic information systems (GIS) and global positioning systems (GPS) are transforming large-scale commercial agriculture throughout the world. This technology is often labeled "precision agriculture" and has given new life to the old idea of site-speci... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Sensitivity Analysis of the Models and Estimation Techniques | In order to further assess the sensitivity of the computed physical and economic returns to the econometric modeling strategy, a total of twelve combinations of different model specifications, spatial weights, and estimation techniques are compared in table... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Econometric Models | Spatial autocorrelation has received growing attention in the economic modeling of natural resources and environmental factors (for recent reviews, see Anselin and Bera; Anselin 2001a Anselin ,b, 2002)) . It can be incorporated in a regression model in two... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Models | Regression crop response functions have the advantage of fitting easily into the traditional crop production economics decision model (Heady and Dillon, Dillon and Anderson) . This also extends to site-specific management, as demonstrated by Lowenberg-DeBoe... |
| low_priority_review | `DataSourceCandidate` | 69 | Background | Site-specific fertilizer application is not a new idea. In the United States, the first extension recommendations on intensive soil sampling and variable rate fertilizer application appeared as early as the mid 1920s (Linsley and Bauer) . The recent resurge... |
| low_priority_review | `DataSourceCandidate` | 60 | Returns by N Rate Application | A comparison of the returns from different N rates is given in table 2 . The returns were estimated for two uniform application rates and for a variable rate application following the four landscape positions in our study. The two uniform rates were used to... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 1 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | STANDARD SAR Variables COEFF kg ha-l Prob COEFF kg ha-l Prob Constant 5863.68 0.0000 5942.87 0.0000 N 11.5415 0.0000 10.8791 0.0000 N2 -0.0358 0.0000 -0.0243 0.0000 Low E 851.134 0.0000 418.883 0.0000 Slope E 199.967 0.0003 205.053 0.0021 Hilltop -1206.12 0... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Methodology | The approach is based on a spatial econometric methodology (Anselin 1988 ). The motivation for this choice is three-fold. First, it accounts explicitly for the effects of spatial autocorrelation due to spillovers, externalities or other imperfections in mod... |

### Efficiency of spatially multiscale machine learning models in addressing spatial non-stationarity and enhancing predictive accuracy

- DOI : `10.1007/s10109-026-00493-8`
- TEI : `corpus\papers\tei\Efficiency of spatially multiscale machine learning models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Empirical findings | The incorporation of geographical covariates, specifically geographical coordinates, is a straightforward and cost-effective method to mitigate spatial non-stationarity in spatial datasets. However, our experiments reveal that this approach is unreliable an... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Experimental design | The research involved the development and comprehensive evaluation of a variety of predictive models. Initially, global models were constructed using Linear Regression (LR), Random Forest (RF), Support Vector Machines (SVM) and Extreme Gradient Boosting (XG... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Future directions | Despite their effectiveness in addressing spatial non-stationarity, geographically weighted models have several important drawbacks, foremost among them computational cost. In contrast to a single global model, a geographically weighted approach requires fi... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Properties of datasets | The first characteristic analyzed was the complexity of the functional relationship. Relative gains by functional form are summarized in Fig. 6 , and corresponding absolute accuracies (mean RMSE) are shown in Figure 15 . For linear regression, the largest r... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatially multiscale geographically weighted models | This section introduces the SM-GW framework and explains how location-specific bandwidths are estimated, stabilized, and applied for prediction. Geographically weighted models rely on a single, globally optimized bandwidth, which is applied uniformly across... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | Conclusion | This study systematically evaluated geographically weighted and spatially multiscale geographically weighted (SM-GW) models across Linear Regression, Random Forest Support Vector Machines and Extreme Gradient Boosting using synthetic datasets with controlle... |
| review_for_dataset_use | `DataSourceCandidate` | 83 | Non-geographic baseline models | Non-geographic baseline models are included to provide a reference for evaluating the added value of spatial weighting and multiscale extensions. These models assume spatial stationarity and do not explicitly incorporate spatial proximity, representing comm... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Computational complexity | The computational cost of GW and SM-GW models is dominated by repeated local model fitting during bandwidth tuning and prediction. Let n denote the number of training observations, n test the number of prediction locations, p the number of predictors, m the... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and methods |  |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Synthetic spatial datasets | To assess and compare the predictive accuracy (quantified by accuracy metrics) of algorithms under controlled spatial conditions, a set of 135 synthetic datasets was generated. The use of synthetic datasets allows for precise manipulation of data properties... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Bandwidth | The final experiment explores the influence of varying kernel bandwidth on predictive accuracy. The distribution of bandwidth values differs for each algorithm (Figures. 11 Fig. 10 Radar plot of relative improvement across dataset characteristics. Each axis... |
| low_priority_review | `DataSourceCandidate` | 61 | Discussion | In this study, a comprehensive evaluation of geographically weighted models was conducted. This section discusses the results. The examination begins by assessing the improvements in accuracy achieved by various model variants, including the addition of geo... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Environmental factors explain the spatial mismatches between species richness and phylogenetic diversity of terrestrial mammals

- DOI : `10.1111/geb.12999`
- TEI : `corpus\papers\tei\Barreto2019Environmental.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 96 | / Diversity measures | We mapped the geographical distribution of terrestrial mammals by recording their presence in each grid cell. We used SAM (spatial analysis in macroecology; T. F. L. Rangel, Diniz-Filho, & Bini, 2006; T. F. Rangel, Diniz-Filho, & Bini, 2010) to calculate th... |
| review_for_dataset_use | `DataSourceCandidate` | 92 | / Species richness, phylogenetic diversity and their relationship | The PD of an assemblage is strongly determined by SR, but the relative change in PD between two regions is not always consistent with the relative change in richness between the same two regions (Tucker & Cadotte, 2013) . Here we found that, at the regional... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | / Environmental predictors | To incorporate environmental productivity, temperature, elevation and climatic stability into our analyses, we compiled, respectively, the following variables: (a) mean AET (Trabucco & Zomer, 2010) ; (b) mean annual temperature (Fick & Hijmans, 2017) ; (c)... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / RE SULTS | The PD of mammal assemblages is largely determined by the number of species they contain (SR), but the magnitude of the relationship between these two dimensions of biodiversity shifts across the geographical space (standardized path coefficients averaged a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Statistical analysis | We designed a path model according to a hypothesis of how the environmental factors are likely to influence SR and PD, in addition to how PD is influenced by SR (Figure 1 ). The path model can assess: (a) the direct effect of each variable on richness and P... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | / INTRODUC TI ON | Biodiversity encompasses multiple dimensions, such as phylogenetic and functional diversity, and species richness (SR), which have varying degrees of spatial covariation (Stevens & Tello, 2018) . Environmental factors are correlated differently with each di... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | / Concluding remarks | Previous studies have shown that even though SR and PD are strongly correlated, the spatial patterns in mammalian SR do not account for the variation in PD, and such mismatches provide insights into ecological and evolutionary processes (Davies & Buckley, 2... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | / D ISCUSS I ON | Our spatial path analysis confirmed that although much of the relationship between environmental factors and PD can be explained by SR, once SR is held constant, the environmental-PD SR relationships offer insights into the relative importance of speciation... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / Environmental correlates of species richness and phylogenetic diversity | Environmental conditions relate differently to the richness of assemblages and PD controlled by richness (PD SR ) across the space, varying in direction and magnitude, and supporting the idea that spatial mismatches between SR and PD are governed, at least... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | / Phylogenetic uncertainty | To account for uncertainty in the evolutionary history of mammals, we replicated the GWPath analyses 1,000 times, each time using the PD calculated from a differently randomly sampled phylogeny from a posterior distribution of 10,000 fully resolved trees (K... |

### Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced statistical models

- DOI : `10.1371/journal.pone.0277499`
- TEI : `corpus\papers\tei\agridat_tesfaye.millet - Evaluation of finger millet (Eleusine coracana (L.) Gaertn.) in multi-environment trials using enhanced.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 93 | Variance components | The genetic variance, error variance, and heritability for each trial from the final fitted Spatial +FA models are presented in Table 6 . The estimates for variance component parameters Table 5. Genetic correlation between environments. Assosa Assosa Assosa... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and methods |  |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Discussion | Following advances in statistical science and knowledge, methods of data analysis for crop variety evaluation programs have improved over recent years [22, 33, 34] . However, these improved statistical techniques have not yet been well utilized in many crop... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Statistical models | A general model for the analysis of GxE data can be built by stacking the data vectors for each trial, y nx1 ð Þ ¼ y 0 1 . . . y 0 n � � 0 , where n ¼ P t j¼1 n j , for the j th trial. In similar manner, all the fixed and random effects in the model as well... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Spatial analysis | Individual trials were subjected to separate analyses to account for non-genetic effects using the Gilmour et al. approach (1997) [25] . The initial model fitted for each trial was a randomized complete block (RCB) model with random block/replication and va... |

### Exploring Spatial Data Mining Techniques: Predicting Zinc Concentration with Kriging Methods and Geographically Weighted Regression Spatial data mining methods were used to pred...

- DOI : `10.14246/irspsd.13.2_145`
- TEI : `corpus\papers\tei\Krotha_2025_Zinc_Kriging_GWR.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically weighted Regression analysis (GWR) | GWR can be performed with the spgwr package in R. Figure 9 displays a contour map of the expected zinc concentration and a plot of the standard error of predictions, which illustrates the degree of uncertainty and variability in the estimated zinc values ac... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically weighted regression | Geographically Weighted Regression (GWR) is an analysis method for spatial point data that allows values missing from the data set to be interpolated. It is applied with the knowledge that the direction and strength of a relationship between a dependent var... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | INTRODUCTION | "Spatial data mining" is the process of identifying interesting and undiscovered patterns in spatial data. Spatial data mining (Franklin, 2005; Setiawan and Rosadi, 2011) is the application of data mining techniques to spatial data (Behrens and Viscarra Ros... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Universal Kriging | Kriging is one of several methods that use a small sample of sampled data points to estimate a variable's value over a continuous spatial field. Two examples of values that vary across a random spatial field are the average monthly concentration of ozone ov... |
| review_for_dataset_use | `DataSourceCandidate` | 86 | METHODS | In order to use Kriging or optimal prediction techniques, we must ascertain the spatial correlation's structure. This problem is known as the structural analysis problem in geostatistics, and it becomes important in the ensuing Kriging procedure. The accura... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Semivariogram models | Theoretical semivariogram models are dependent on the selection of three parameters, namely sill (c), range (a), and nugget (). From the plot, we can assume that the nugget is 0, the range lies between 300 and 700, and the sill is between 0.5 and 1. Based o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 64 | CONCLUSION | In this research, we conducted comprehensive spatial analysis and prediction tasks using various techniques, including applying different semivariogram models such as experimental, linear, and Maté rn. The Maté rn model exhibited the lowest error rate of 1.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | DISCUSSION: POLICY IMPLICATIONS OF ZINC CONTAMINATION PREDICTIONS | This study introduces an advanced approach to predicting zinc contamination in the Meuse River floodplains using Universal Kriging and geographically weighted regression. The application of the matern semivariogram model, which achieved an error sum of squa... |

### Extracting spatial effects from machine learning model using local interpretation method: An example of SHAP and XGBoost

- DOI : `10.1016/j.compenvurbsys.2022.101845`
- TEI : `corpus\papers\tei\Extracting spatial effects from machine learning model using local interpretation method_SHAP and XGBoost.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | An example of modelling ride-hailing service demand in Chicago | Simulations in the previous section demonstrate that machine learning model is accurate even when complex spatial and non-spatial effects present, and SHAP can be used to estimate these effects. In this section, we show an empirical example of using SHAP to... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Comparisons of SHAP-explained machine learning to spatial statistical models | Spatial autocorrelation and spatial heterogeneity are the two wellknown spatial effects in spatial analysis and modelling (Anselin, 1988) . Spatial autocorrelation refers to the process that creates clusters of values, and this effect is usually accounted f... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Conclusions | Machine learning models have become increasingly common in modelling and predicting spatial phenomena. Interpretability is a major challenge in machine learning that limits its further adoption in spatial data modelling when the interest is in discovering t... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion | Previous sections demonstrate the utility of SHAP to interpret XGBoost model of spatial data under both simulated and empirical scenarios. In this section, we discuss some further issues and opportunities. First, the use of SHAP to provide reliable estimate... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Interpretable machine learning and SHAP | The goal of interpretable machine learning is to understand how models make predictions and to answer questions such as what the relationships between input and output are and what features are most important in driving the prediction. Model-specific and mo... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | Table 1 summarises the overall model accuracy for both SLM and XGBoost. Because of the model estimation process is different in statistical and machine learning models, the R 2 value (1 -∑ (y -ŷ) 2 / ∑ (y -y) 2 ) and residual Root Mean Square Error (RMSE) w... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | In Table 2 , an overall assessment of model performance demonstrates that both models fit the data well. According to the RMSE of the various partial components, MGWR is better at modelling continuous spatial heterogeneity in β 0 and β 1 , whereas XGBoost i... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Simulation design | The matrix form of a Spatial Lag Model (SLM) is given in Eq. ( 3 ) where y is the dependent variable, X is a matrix of independent variables (i.e. features), β are the coefficients, and ε is the error term. The inclusion of a spatial lag term ρWy distinguis... |
| review_for_dataset_use | `DataSourceCandidate` | 78 | A comparison to MGWR for modelling spatial heterogeneity 3.2.1. Simulation design | This section demonstrates how to use SHAP to extract spatially varying effects from machine learning models with comparison to Geographically Weighted Regression (GWR). GWR has been widely used to model spatially varying relationships. It fits locally weigh... |
| low_priority_review | `DataSourceCandidate` | 46 | Model comparison when complex effects co-exist 3.3.1. Simulation design | From Section 3.1 and Section 3.2, it is suggesting that XGBoost model produces similar overall performance when comparing to SLM and MGWR model. And SHAP can be used to explain the XGBoost model and generate parameters that are consistent with these in SLM... |

### Fast Spatio-Temporally Varying Coefficient Modeling With Reluctant Interaction Selection

- DOI : `10.1111/gean.70005`
- TEI : `corpus\papers\tei\Geographical Analysis - 2025 - Murakami - Fast Spatio‐Temporally Varying Coefficient Modeling With Reluctant Interaction.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Outline | This section applies the proposed method to analyze hourly and monthly larceny counts per square km, which we will call the larceny density (source: Crime Dashboard: https://www. sanfranciscopolice.org/stay-safe/crime-data/crime-dashboard ), by 194 district... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Section 1 | Although each STVC is typically assumed to obey a single spatio-temporal process, it may depend on multiple processes. Specifically, regression coefficients can exhibit (i) spatial, (ii) temporal, and/or (iii) spatio-temporal variations (Figure 1 ). For exa... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | / Result | Figure 5 summarizes the RMSEs. In many cases, the RMSE values are the smallest when the fitted and true processes coincide. Interestingly, the full model STc int also performs the best in most cases. This result suggests that the proposed method accurately... |
| low_priority_review | `DataSourceCandidate` | 62 | / Model for Data | We consider the following model: where 𝑥 𝑝 (𝑠, 𝒕) is the 𝑝-th covariate observed at site 𝑠 at time 𝒕, with 𝑝 = 1 assumed to be constant (i.e., 𝑥 1 (𝑠, 𝒕) = 1). 𝜎 2 is the noise variance. Following GAM-related studies using a linear combination of spatial an... |
| low_priority_review | `DataSourceCandidate` | 50 | / Marginal Likelihood | The marginal log-likelihood of our model (Equation 11 ) with respect to the variance parameters where where 𝑘 𝑿. 𝑮 𝑲,𝒚 is defined similarly for 𝒚. The following marginal Bayesian information criterion (BIC) is obtained from the log-likelihood (see Delattre... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | TABLE 6 / |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Outline | This section considers the following regression model: where 𝑥 𝑝 (𝑖, 𝒕) ∼ 𝑁(0, 1) and 𝒕 = {𝑡 1 , 𝑡 2 }. The following specifications are considered for the three coefficients: where {𝑏 1 , 𝑏 2 , 𝑏 3 } = {1, 2, -0.5} and [⋅] denotes standardization to zero m... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Property of the Model | Although both our STVC model and GAM consider basis functions for modeling STVCs, the former has several advantages as follows. First, the number of basis functions/eigenvectors is automatically determined by the number of positive eigenvalues, explaining p... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Result | Table 4 summarizes the error statistics and computation time. LM achieves a reasonable accuracy because it implicitly considers dynamic spatio-temporal patterns through LarcenyPre. However, S demonstrates superior adjusted R-squares(𝑅 2 𝑎𝑑𝑗 ), log-likelihoo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | / Model | This study considers the explained variable 𝑦(𝑠, 𝒕) observed at site 𝑠 ∈ {1, . . . , 𝑆} in a study region 𝐷 ⊂ ℝ 2 at time 𝒕 = {𝑡 1 , . . . , 𝑡 𝑄 } measured on single or multiple axes (e.g., year, week, and hour) indexed by 𝑞 ∈ {1, . . . , 𝑄}. Since the type... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | / Comparison With GTWR 4.3.1 / Outline | This section compares the proposed method with GWR and GTWR, which are widely used for modeling SVC and STVC, respectively. Following our model, an exponential kernel is used for their local weighting, and the bandwidth is optimized by minimizing the correc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | / Result | Figure 8 compares the RMSEs for the strong and weak STVCs. For reference, LM and S are compared again. In Case I, GTWR and STc int outperform GWR and S, confirming the importance of considering temporal patterns in regression coefficients. However, GTWR exh... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Flexible nonlinear spatial autoregressive models: a gradient boosting approach with closed-form estimation

- DOI : `10.1111/gean.12268`
- TEI : `corpus\papers\tei\spbbost_article.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Comparative near-prediction evaluation with standardised tuning | The final estimator comparison is conducted under near-prediction, the regime corresponding to dense spatial prediction settings. Hyperparameters of competing models are tuned on the same 50 near-prediction calibration folds: m stop for gamboost, (m stop ,... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | F.1. Overview | The calibration of BSPA SAR CFE addresses three coupled choices: (i) the spatial weight matrix W ; (ii) the degrees of freedom ν of the bivariate spline b sp (x, y) entering the regression specification, with ν = 0 encoding the absence of a bivariate spatia... |
| review_for_dataset_use | `DataSourceCandidate` | 99 | Data, estimators, and calibration grid | The dependent variable is log(median house value). Structural covariates are median house age, total rooms, total bedrooms, population, number of households, median household income, and three dummies derived from ocean proximity. Observations labelled ISLA... |
| review_for_dataset_use | `DataSourceCandidate` | 92 | Calibration grid and selection of W | The far-prediction protocol partitions California into ten contiguous environmental blocks: five latitude bands crossed with a coastal/inland split based on ocean proximity == INLAND. For each test block, the four other blocks of the same environmental clas... |
| review_for_dataset_use | `DataSourceCandidate` | 88 | Introduction | Spatial autoregressive (SAR) models constitute a central framework in spatial econometrics for capturing spatial dependence across observations (Ord, 1975; Anselin, 1988) . They allow researchers to quantify spatial spillovers, that is, how outcomes observe... |
| low_priority_review | `DataSourceCandidate` | 65 | Monte Carlo simulation design | To evaluate the finite-sample properties of the proposed estimators, we conduct a series of Monte Carlo experiments based on synthetic spatial datasets. Two types of spatial autoregressive data-generating processes (DGPs) are considered: the spatial autoreg... |
| low_priority_review | `DataSourceCandidate` | 64 | Monte Carlo results for E4 experiments | This experiment investigates three interconnected challenges that arise in empirical spatial applications: variable selection in the presence of geographically structured covariates and spurious distance variables, the robustness of ρ to the choice of mstop... |
| low_priority_review | `DataSourceCandidate` | 59 | Determinant-free estimation of the spatial parameter | A crucial question is whether determinant-free spatial estimation remains valid when the regression function is estimated nonparametrically. If the additive estimator altered the structure of the residual projection operator, the quasi-score equation underl... |
| low_priority_review | `DataSourceCandidate` | 58 | A boosting framework for nonlinear spatial autoregressive models | This section develops the estimation framework and the theoretical foundations of the proposed nonlinear spatial autoregressive model. The key idea is that determinant-free estimation of the spatial parameter remains valid even when the regression function... |
| low_priority_review | `DataSourceCandidate` | 57 | Experiment E1: baseline Monte Carlo experiments. | In a first set of experiments (E1), we evaluate all estimators considered in this paper, excluding the tree-based variant based on xgboost whose asymptotic properties are not established in the present framework, across the parameter configurations describe... |
| low_priority_review | `DataSourceCandidate` | 45 | Conclusion | This paper develops a determinant-free estimation framework for nonlinear spatial autoregressive models. The central theoretical result is that the Closed-Form Estimator (CFE) remains valid when the regression function is estimated nonparametrically through... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 8 : |
| low_priority_review | `truncated` |  |  | 13 autres candidats non affiches dans ce rapport |

### GWRBoost:A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships

- TEI : `corpus\papers\tei\A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships_GWRBoost.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computation of Akaike information criterion | The AIC and AICc are the most common metrics to evaluate the fit performance of the GWR model, which are an unbiased estimate of the expected Kullback-Leibler information and a trade-off between goodness of fit and the degree of freedom. In a fitting task,... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Evaluation metrics | For evaluation, we use six metrics to investigate the performance of the model, which include: • Root mean square error (RMSE): where β j (u i , v i ) is the j-th coefficient and βj (u i , v i ) is the coefficient estimates at location (u i , v i ). • Resid... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Variants of geographically weighted regression | Numerous variants have been developed to improve the GWR in various aspects. Several studies focus on the improvement of optimal bandwidth selection. Generally, the choice of bandwidth is crucial to the fitting result of GWR (Fotheringham et al., 2003) . A... |
| review_for_dataset_use | `DataSourceCandidate` | 87 | Empirical case study | In this section, we aim to use the NYC education data set provided by GeoDa Lab ( https://geodacenter.github. io/data-and-lab//NYC-Census-2000 ) to show the practical value of our proposed method. The NYC education data set collected educated information on... |
| low_priority_review | `DataSourceCandidate` | 62 | Gradient boosting method | As a type of ensemble learning method, gradient boosting algorithms obtain competitive results in various applications (Bentéjac et al., 2021) . Generally, the gradient boosting method develops an additive model by applying a variety of basic models to lear... |
| low_priority_review | `DataSourceCandidate` | 50 | Sensitivity analysis of hypterparameters | In the general ensemble learning process, the overfitting problem will be more significant with the increase of base learners. The number of base learners and the learning rate per learner holds are crucial to the performance of output results. To investiga... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | Additive linear model for located observations | In the classic geographically weighted model, an independent linear function is applied to formulate the relationships between dependent and independent variables for each observation i at the specific location: where (u i , v i ) denotes the location of i-... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Introduction | It is essential to consider spatial heterogeneity of relationships between located variables in the analysis of any geographical process, which is also referred to as spatial nonstationarity (Goodchild, 2004) . The quantification analysis of the relationshi... |

### GWmodel: An R Package for Exploring Spatial Heterogeneity Using Geographically Weighted Models

- TEI : `corpus\papers\tei\Gollini_2015_GWmodel_JSS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Concluding remarks: Criticisms and Bayesian models | Collinearity is a problem in any form of regression modelling and the importance of assessing and taking action has been raised by the many commentaries on local collinearity in GW regression (Wheeler and Tiefelsdorf 2005; Wheeler 2007 Wheeler , 2009 Wheele... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Example | We examine the use of our local compensation approach with the same GW regression that is specified in Section 6, where voter turnout is a function of the eight predictor variables of the Dublin election data. For the corresponding global regression, the vi... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | LCR GW regression vs. previous penalized GW regression models | It is important to clarify the difference between our LCR GW regression (say, LCR-GWR) and the GW ridge regression (GWRR) demonstrated in Wheeler (2007) . Essentially, LCR-GWR is more locally-focused than GWRR. GWRR similarly applies a local compensation, b... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model building with collinear data | If we explore the local condition numbers for models with different structures, it may be possible to build GW regression models which avoid collinearity. Here, we code a function to calibrate and then estimate a basic (un-adjusted) GW regression. This func... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Robust GW regression | To identify and reduce the effect of outliers in GW regression, various robust extensions have been proposed, two of which are described in Fotheringham et al. (2002) . The first robust model re-fits a GW regression with a filtered data set that has been fo... |
| review_for_dataset_use | `DataSourceCandidate` | 92 | Data sets | The GWmodel package comes with five example data sets, these are: (i) Georgia, (ii) LondonHP, (iii) USelect, (iv) DubVoter, and (v) EWHP. The Georgia data consists of selected 1990 US census variables (with n = 159) for counties in the US state of Georgia;... |
| review_for_dataset_use | `DataSourceCandidate` | 85 | GW principal components analysis | Principal components analysis (PCA) is a key method for the analysis of multivariate data (see Jolliffe 2002) . A member of the unconstrained ordination family, it is commonly used to explain the covariance structure of a (high-dimensional) multivariate dat... |
| review_for_dataset_use | `DataSourceCandidate` | 85 | LowEduc: Without any formal educational. | Age18_24: Age group 18-24. Age25_44: Age group 25-44. Age45_64: Age group 45-64. Thus the eight independent variables reflect measures of migration, public housing, high social class, unemployment, educational attainment, and three adult age groups. The EWH... |
| review_for_dataset_use | `DataSourceCandidate` | 83 | Example | To demonstrate GW regression as spatial predictor, we use the EWHP data set. Here our aim is to predict the dependent variable, house price (PurPrice) using a subset of the nine independent variables described in Section 2, each of which reflect some hedoni... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Example | As an example, we find the distance matrix for the house price data for England and Wales (EWHP), as described in Section 2. Here, the distance matrix can be calculated: (a) within a function of a specific GW model or (b) outside of the function and saved u... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Example | For applications of PCA and GW PCA, we again use the Dublin voter turnout data, this time focussing on the eight variables: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44 and Age45_64 (i.e., the independent variables of the regression fits in Sec... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Example | We now demonstrate the fitting of the basic and robust GW regressions described, to the Dublin voter turnout data. Our regressions attempt to accurately predict the proportion of the electorate who turned out on voting night to cast their vote in the 2004 G... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data

- DOI : `10.1080/13658816.2013.865739`
- TEI : `corpus\papers\tei\Geographicallyweightedregressionwithanon-Euclideandistance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | International Journal of Geographical Information Science | numerous contributions have been made. For example, different kernel functions have been suggested (e.g. Brunsdon et al. 1996 , Fotheringham et al. 1998 , Yrigoyen et al. 2007 ) and different rules to select an optimum bandwidth have also been proposed (e.g... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | London road network data | Road network data produced by the UK Ordnance Survey (OS) in 2001 is used to calculate the ND and TT metrics for our GWR models. To get a relatively accurate TT, the road speed limits are used as the average speeds for each road link. The locations of the s... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial analysis of the GWR residuals | Figure 5a -c depicts discrepancy maps for the absolute residuals (i.e. the absolute value of the actual PURCHASE price minus the GWR predicted PURCHASE price) from the three GWR models using ED, ND and TT metrics. Here, Figure 5a subtracts the absolute resi... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Introduction | Waldo Tobler's celebrated dictum, to which he referred as the first law of geography, has been widely adopted as a basic principle in Geographic Information Science (Goodchild 1992) . It is at the core of many spatial techniques, such as those found in spat... |
| review_for_dataset_use | `DataSourceCandidate` | 90 | London house price and hedonic data | As a case study, a house price data set for London, UK, is used to assess and compare GWR models with different distance metrics. This data set is sampled from a house price data set provided by the Nationwide Building Society of the United Kingdom and was... |
| review_for_dataset_use | `DataSourceCandidate` | 86 | Summary and discussion | In summary, a GWR model using a TT metric appears most suited to our London house price data set, followed closely by a GWR model using a ND metric. A basic GWR model using an ED metric appears least suited to this data, while all GWR models should use a fi... |
| review_for_dataset_use | `DataSourceCandidate` | 85 | International Journal of Geographical Information Science | hedonic characteristics are typically divided into locational attributes, structural attributes, neighbourhood attributes and other features (Goodman 1989, Chin and Chau 2003) . Accordingly for our study, the sale price, PURCHASE, the dependent variable, is... |
| low_priority_review | `DataSourceCandidate` | 68 | Geographically weighted regression | GWR is a non-stationary technique that models spatially varying relationships. Compared with a basic (global) regression, the coefficients in GWR are functions of spatial location. Fotheringham et al. (1998 Fotheringham et al. ( , 2002) ) give a general for... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Further observations | Although each GWR model is specified with a different AIC c defined optimal bandwidth, it is argued that the observed differences in goodness-of-fit and the estimated coefficients (at least for FLOORSZ) are fundamentally caused by the distinctive measuremen... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Global regressions | As with any GWR study, it is important to estimate the parameters of the global regression, so that this benchmark model can be compared to its GWR counterpart. As there is no single agreed functional form in hedonic price modelling (Halvorsen and Pollakows... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Investigation of a single model specification | It is unrealistic to delve deeper into all 720 GWR models, one by one. Thus, we choose a representative model to illustrate more specific differences in the GWR fits using ED, ND and TT metrics. As shown in Figure 3 , there is relatively little reduction in... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Summary of the OLS regression and GWR models | Bandwidth, R-squared and AIC c results for model no. 42, using OLS regression and GWR are given in Table 1 . Observe that the bandwidths for the GWR models using ND and TT metrics are actually relatively similar to each other. Here we need to look again at... |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |

### Geomorphic process rates of landslides along a humidity gradient in the tropical Andes

- DOI : `10.1016/j.geomorph.2011.10.029`
- TEI : `corpus\papers\tei\muenchow2012_lsl_dataset.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Statistical modeling | Statistical-empirical landslide distribution models are widely used for landslide susceptibility mapping based on inventory data (Brenning, 2005) . We used the generalized additive model (GAM) to analyze the distribution of landslide initiation points in ea... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Study areas | We investigated landslide distribution and geomorphic process rates in two study areas, the Reserva Biológica San Francisco (RBSF) and the Masanamaca area, which are located in the Andes of Southern Ecuador on the semi-arid and perhumid sides of the contine... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Estimation of geomorphic process rates | We calculated geomorphic process rates to assess the contribution of shallow landslides to landscape evolution (Caine, 1976) . Process rates were estimated in the first place as average values of each study area and time period represented, and were later d... |
| review_for_dataset_use | `DataSourceCandidate` | 83 | Conclusions | Our comparative study in semi-arid and humid areas of the tropical Andes of Southern Ecuador revealed a considerable diversity of landslide types as well as high geomorphic process rates associated with landslide activity. Human disturbances including road... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Data and methods |  |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Data | Landslides were mapped in the RBSF area in 1998 in the field by Stoyan (2000) , who additionally used aerial photos of 1962 , 1969 , 1976 , 1989 , and 1998 (Instituto Geográfico Militar of Ecuador, IGM; scale 1:60,000). The first author additionally mapped... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | The study areas in a South American context | Our comparison of two contrasting study areas provided an insight into landslide distribution patterns and triggering mechanisms along a strong humidity gradient in a region that is strongly affected by a variety of landslide types. At a regional scale, dur... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 1 |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Introduction | Landslides are common phenomena in the Andes of Southern Ecuador, where they not only cause economic damage, but also enhance biodiversity and contribute to landscape evolution in a megadiverse hotspot (>5000 vascular plant species per 10,000 km 2 ; Barthlo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Relationships between landslides and vegetation 5.4.1. Influence of vegetation on slope stability | Vegetation may exert an important influence on slope stability in general as well as in our study areas, especially the RBSF area (Restrepo et al., 2009; Gao and Maro, 2010) . Hydrological and mechanical effects of vegetation can be distinguished (Roering e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Geomorphic process rates | In the semi-arid Masamanaca area, the larger number of smaller mass movements in the conglomerate subarea resulted in nearly the same LMR values as in the metamorphic subarea (~0.4-4.4 vs. 0.3-2.6 mm yr -1 ; ranges correspond to the upper and lower bound of... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Graph WaveNet for Deep Spatial-Temporal Graph Modeling

- TEI : `corpus\papers\tei\2026-04-23_paper_graph_wavenet_spatial_temporal_graph_modeling.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 91 | Introduction | Spatial-temporal graph modeling has received increasing attention with the advance of graph neural networks. It aims to model the dynamic node-level inputs by assuming interdependency between connected nodes, as demonstrated by Figure 1 . Spatial-temporal g... |
| low_priority_review | `DataSourceCandidate` | 69 | Experiments | We verify Graph WaveNet on two public traffic network datasets, METR-LA and PEMS-BAY released by Li et al. [2018b] . METR-LA records four months of statistics on traffic speed on 207 sensors on the highways of Los Angeles County. PEMS-BAY contains six month... |
| low_priority_review | `DataSourceCandidate` | 66 | Experimental Results | Table 2 compares the performance of Graph WaveNet and baseline models for 15 minutes, 30 minutes and 60 minutes ahead prediction on METR-LA and PEMS-BAY datasets. Graph WaveNet obtains the superior results on both datasets. It outperforms temporal models in... |
| low_priority_review | `DataSourceCandidate` | 63 | Baselines | We compare Graph WaveNet with the following models. • ARIMA. Auto-Regressive Integrated Moving Average model with Kalman filter [Li et al., 2018b] . Data Models 15 min 30 min 60 min MAE RMSE MAPE MAE RMSE MAPE MAE RMSE MAPE METR-LA ARIMA [Li et al., 2018b]... |
| low_priority_review | `DataSourceCandidate` | 63 | Effect of the Self-Adaptive Adjacency Matrix | To verify the effectiveness of our proposed adaptive adjacency matrix, we conduct experiments with Graph WaveNet using five different adjacency matrix configurations. Table 3 shows the average score of MAE, RMSE, and MAPE over 12 prediction horizons. We fin... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 : |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Experimental Setups | Our experiments are conducted under a computer environment with one Intel(R) Core(TM) i9-7900X CPU @ 3.30GHz and one NVIDIA Titan Xp GPU card. To cover the input sequence length, we use eight layers of Graph WaveNet with a sequence of dilation factors 1, 2,... |

### How do Indigenous and local knowledge systems respond to climate change?

- DOI : `10.5751/ES-12481-260327`
- TEI : `corpus\papers\tei\Popovici2021How.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Climatic variables |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | RESULTS | Three categories of observations emerged as critical impacts of a changing climate on crop production in the interviews. Specifically, farmer interviewees noted a shift in the rainy season, increased temperatures, and unexpected cold days. We combined quali... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Climate trend analyses | We used 30 years of a daily gridded climatological data product assembled by Moraes et al. (2020) to extract climate trends for the four study districts. A suite of climate metrics was designed to quantify the types of changes that were described by local f... |

### Identification of a gene associated with avian migratory behaviour

- DOI : `10.1098/rspb.2010.2567`
- TEI : `corpus\papers\tei\Mueller et al 2011, spatial or population model data.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | MATERIAL AND METHODS | (a) Samples Thirteen European/African blackcap populations representing the entire range of geographical variation in migration patterns, from Cape Verde to western Russia, have been sampled in the years 1989-1996 (figure 1 ). We also included a sample of b... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | RESULTS (a) Within-population tests | In both populations with data on individual migratory activity (southern France and southern Germany; figure 1 ), migratory restlessness was associated with the genotypes of the ADCYAP1 locus (table 1). Individual mean allele length at ADCYAP1 correlated po... |

### Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and Eigenvector Spatial Filtering Features

- DOI : `10.3390/ijgi11040242`
- TEI : `corpus\papers\tei\Incorporating Spatial Autocorrelation in Machine Learning Models Using Spatial Lag and Eigenvector Spatial Filtering Features.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | 4. | For each hyper-parameter candidate, average the assessment metric values across L folds and choose the best hyper-parameter. In our experiments, the hyperparameter that was tested was m try . 5. Calculate spatial features on the outer-train. 6. Perform cros... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | California Housing Dataset | This dataset contains 20,640 observations of California housing prices based on 1990 California census data. Each row represents a census block group or district (the smallest geographical unit for which the U.S. Census Bureau publishes sample data). It was... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | California Housing Dataset | This dataset contains 20,640 observations of California housing prices based on 1990 California census data. Each row represents a census block group or district (the smallest geographical unit for which the U.S. Census Bureau publishes sample data). It was... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data Sources | Two public spatial datasets with different properties are used in this study to test the usability of the proposed modelling. usually the main focus of this dataset. Flooding frequency and distance to the river can be considered as covariates in regression... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Eigenvector spatial filtering (ESF) is a regression technique proposed by Getis and | Griffith [43] to enhance the model results in the presence of spatial dependence. This idea is originated from Moran's I, in which the spatial weight matrix is used to capture the spatial covariations. ESF decomposition is conducted on the matrix where I is... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Importance of Explanatory Variables | In this section, we look at the influence that each explanatory variable (i.e., features) has on the tested models (Table 4 ). For the RF models, the relative feature importance of the final model is extracted. Relative feature importance is obtained by sca... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | The volume of data generated in recent years is increasing tremendously and a large proportion of big data is geospatial (e.g., remote-sensing imagery, GPS trajectories, weather measurements) [1] . Geospatial big data bears the same features as normal big d... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Meuse River Dataset | Meuse is a classical spatial dataset in geostatistics that consists of samples collected in a flood plain of the river Meuse in the Netherlands. Hengl et al. [22] used Meuse dataset for one of the experiments where distance-based spatial features were intro... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Performance Evaluation-RMSE Error | In Table 5 we see the training and test errors derived from RMSE values across the models. In both datasets, models with spatial features yielded the lowest test errors. That is the ESF model Meuse with a test error of 171.82 and the Spatial Lag model Calif... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Random Forest | Random forest (RF) is used in this study for its general accuracy and successful applications in diverse geoscientific problems [28, 35, 49] . RF has also been used as a framework recently to integrate distance variables in spatial prediction [22] . During... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Lag Features | The spatial lag features capture the spatial autocorrelation of the dependent variables (y) in surrounding areas. The spatial lag of location i is calculated as the weighted sum of values from location i to j: A spatial weight matrix (w ij ) is necessary to... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Related Work | Research on the combination of spatial features and ML is emerging in these years. Behrens et al. [25] introduced a spatial modeling framework with generic EDF as additional spatial covariates. They combined EDF with other commonly used environmental covari... |
| low_priority_review | `truncated` |  |  | 10 autres candidats non affiches dans ce rapport |

### Incorporating spatial and genetic competition into breeding pipelines with the R package gencomp

- DOI : `10.1038/s41437-024-00743-9`
- TEI : `corpus\papers\tei\agridat_connolly.potato - Incorporating spatial and genetic competition into breeding pipelines with the R package gencomp.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Second step: model fitting | We can proceed with model fitting once Z c is constructed. The model fitting step is the most computationally intensive. To optimize time and computational resources, gencomp internally utilizes the Average Information (Gilmour et al. 1995) algorithm of the... |
| review_for_dataset_use | `DataSourceCandidate` | 98 | Third step: main results | The resp function provides a list of the most relevant outputs: (i) results of the likelihood ratio tests (if lrtest = TRUE in asr or asr_ma), (ii) variance components, (iii) heritabilities of the DGE and the total genotypic effects (if cor = TRUE in asr or... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | First step: competition matrix | Following the logic presented in the "Methods" section, the first step is to build the competition matrix. For this, gencomp has two functions: prepfor and prepcrop. The former is designed to deal with tree breeding trials, and the latter, with crop breedin... |
| low_priority_review | `DataSourceCandidate` | 61 | Competition affects the selection | The availability of a tool that facilitates the management of competition in plant breeding trials is important since genetic competition represents a systematic bias that can distort the candidates' genotypic values and hamper the selection process (Besag... |
| low_priority_review | `DataSourceCandidate` | 61 | Motivating examples | Using the example datasets (euca and potato, described below), we demonstrate the usage of gencomp and the effects of modeling the genetic competition. For the second objective, we compare four models: a "traditional" mixed model (TMM, without spatial adjus... |

### Integrated species distribution models to account for sampling biases and improve range-wide occurrence predictions

- DOI : `10.1111/geb.13792`
- TEI : `corpus\papers\tei\Makinen2023Integrated.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Effect | First order S econd order EVI measured with the Moran's I, and thus the changes in the covariate effect estimates were not associated with the spatial structure of the covariates. See Table S1 .6 in Appendix 1 for a table of Moran's I of each covariate rast... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / DISCUSS ION | We tested integration of the opportunistically sampled PO data and the species checklist-based PA data for fitting integrated SDMs for 71 hummingbird species on the extent of the species' whole ranges. Of the different integration methods (tested, e.g. in A... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Data sets | We obtained PO, PA and expert range map data for 71 hummingbird species from a previous data integration study (Ellis-Soto et al., 2021) . Their data were accessible through the Map of Life ( mol . org ): PO observations are originally from GBIF ( https://... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / INTRODUC TI ON | Information about species distributions is widely used for assessing species vulnerability to climate and land use change (Dawson et al., 2011; Jetz et al., 2007) , and for optimizing species conservation efforts (Hannah et al., 2020; Jetz et al., 2022; Jun... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Model comparison | Our results show that integrated SDMs can help address limited amounts of the occurrence data but the improvements are conditional on accounting for different biases of the data sets, such as the sampling bias of the PO data, as can be expected based on pre... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Model validation | We validated models with fourfold block-wise cross-validation on the PA data set, and the PO data set was used only for model training. In cross-validation, folds were formed by splitting the PA sites into 20 spatially distinct blocks and grouping blocks in... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Studying data-deficient species and areas | The general assumption that data integration benefits data-deficient species, which are scarcely observed due to low population abundance or low detectability, was not fully supported by our study. Our results showed that the PA model performed in the cross... |
| review_for_dataset_use | `DataSourceCandidate` | 94 | Model Definition Likelihood Intensity function | Presence-only PO Integrated + additional sampling effect PO + PA + samp. Note: PO and PA models were fitted with a single data type, and the integrated model PO + PA and its modifications were fitted with both data types. PO + PA + samp. introduces an addit... |
| review_for_dataset_use | `DataSourceCandidate` | 94 | / Integrated models | An overview of the five models assessed and their likelihood and intensity functions is given in Table 1 . We defined the observation model for the PO data as an inhomogenous Poisson point process (IPPP) conditional on the intensity of the process (Renner e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Limitations of the study and future perspectives | By involving different types of species information in the model inference and validation propagates uncertainties and biases in the results. We considered expert range maps as fixed truth of species occurrence status despite expert range maps have been sho... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | / CON CLUS ION | We have shown that compared to traditional models using a single data type, integrated SDMs provide advantages for predicting a species entire range. Specifically, integrated SDMs offered predictions of greater accuracy and lower uncertainty. This predictiv... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / Model fitting | We fitted models for each species separately with integrated nested laplace integration (INLA) through the R-INLA package and applied stochastic partial differential equations (SPDE) for fitting the spatial latent effects (Bakka et al., 2018; Lindgren & Rue... |

### Journal of Statistical Software

- DOI : `10.18637/jss.v077.i11`
- TEI : `corpus\papers\tei\surveillance_measles.weser - Spatio-Temporal Analysis of Epidemic Phenomena Using the R Package surveillance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data ingredients | The core events data must be provided in the form of a 'SpatialPointsDataFrame' as defined by the package sp (Bivand et al. 2013 ): R> summary(events) Object of class SpatialPointsDataFrame Coordinates: min max x 4039 4665 y 2710 3525 Is projected: TRUE pro... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Special cases: Single-component models | If the epidemic component is omitted in Equation 2, the point process model becomes equivalent to a Poisson regression model for aggregated counts. This provides a link to ecological regression approaches in general (Waller and Gotway 2004) and to the count... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Data handling and visualization | The generated 'epidataCS' object imdepi is a simple list of the checked ingredients events, stgrid, W and qmatrix. Several methods for data handling and visualization are available for such objects as listed in Table 2 and briefly presented in the remainder... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Data structure: 'epidata' | New SIR-type event data typically arrive in the form of a simple data frame with one row per individual and sequential event time points as columns. For the 1861 Hagelloch measles epidemic, such a data set of the 188 affected children is contained in the su... |
| low_priority_review | `DataSourceCandidate` | 69 | Data structure: 'epidataCS' | The first step toward fitting a twinstim is to turn the relevant data into an object of the dedicated class 'epidataCS'. (The suffix "CS" indicates that the data-generating point process is indexed in continuous space.) The primary ingredients of this class... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Basic example | To illustrate statistical inference with twinstim, we will estimate several models for the simplified and "untied" IMD data presented in Section 3.2. In the endemic component, we include the district-specific population density as a multiplicative offset, a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Covariates | The hhh4 model framework allows for covariate effects on the endemic or epidemic contributions to disease incidence. Covariates may vary over both regions and time and thus obey the same T × I matrix structure as the observed counts. For infectious disease... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Modeling and inference | Having prepared the data as an object of class 'epidataCS', the function twinstim can be used to perform likelihood inference for conditional intensity models of the form (2). The main arguments for twinstim are the formulae of the endemic and epidemic line... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Random effects | Paul and Held (2011) introduced random effects for 'hhh4' models, which are useful if the districts exhibit heterogeneous incidence levels not explained by observed covariates, and especially if the number of districts is large. For infectious disease surve... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Spatial interaction | Up to now, the model assumed that the epidemic can only arrive from directly adjacent districts because w ji = 1(j ∼ i), and that all districts have the same potential φ for importing cases from neighboring regions. Given the ability of humans to travel fur... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Modeling and inference | For multivariate surveillance time series of counts such as the measlesWeserEms data, the function hhh4 fits models of the form (10) via (penalized) maximum likelihood. We start by modeling the measles counts in the Weser-Ems region by a slightly simplified... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 86 | Model class: twinSIR | The point process model twinstim (Section 3) is indexed in a continuous spatial domain, i.e., the set of possible event locations consists of the whole observation region and is thus infinite. However, if infections can only occur at a known discrete set of... |
| low_priority_review | `truncated` |  |  | 8 autres candidats non affiches dans ce rapport |

### MetaComNet: A random forest-based framework for making spatial predictions of plant-pollinator interactions

- DOI : `10.1111/2041-210X.13762`
- TEI : `corpus\papers\tei\Sydenham2021Metacomnet.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | TA B L E 1 | Variables included in the MetaComNet network model. The data frame contains columns with response variables including: (i) number, or presence or absence, of observed interactions between a pollinator species and a plant species in a particular study site.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Occurrence of interactions | The presence or absence of interactions between the bee species and plant within a site. The variable was transformed into a two-level categorical variable for models using classification trees and left as a numeric variable (zero or one) for the models usi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Local scale: | At the scale of individual flowers within habitats, the occurrence and number of bee-plant interactions will depend on the attractiveness of the flower. Flower attractiveness depends in part on their relative abundance (Fowler et al., 2016; Stavert et al.,... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | / INTRODUC TI ON | Nearly nine of every 10 species of flowering plants rely on interactions, mainly with insects, for cross-pollination (Ollerton et al., 2011) . However, wild plants are experiencing a shortage of pollinators in both natural and managed terrestrial ecosystems... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / DISCUSS ION | The aim of this study was to develop and test a framework for producing spatially explicit predictions of plant-pollinator networks. Despite the relatively low predictive importance of landscape level variables, there was a considerable spatial difference i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / Mapping flower-visitor species richness | The random forest regression models produced the most accurate predictions of observed pairwise interactions (Figure 2 ), and equal to or stronger relationships with the number of pairwise interactions, and species richness, diversity and abundance of flowe... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / Modelling and predicting empirical bee-plant interactions | We assembled a data frame where each row was defined by a study site, a plant species found within the study site, and one of the bee species occurring in the 16 study sites (Tables 1 and 2 ). The data frame included (response) variables for the presence (1... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | / Bee-flower network sampling | We sampled bee-flower networks along 16 roadsides (sites) in Southeast Norway in 2017. Eight of the study sites were located on sandy sediments and the remaining eight were located on clay dominated sediments (Skoog, 2018) . At each study site, flowervisiti... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Landscape scale: | Pollinator communities are assembled through dispersal processes (Hagen et al., 2012) and through mechanisms of species sorting determined by the suitability of an area as habitat for the species (environmental filtering). Dispersal rates depend in part on... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | / Predicting flower-visitor species richness, diversity and abundance | Predicted bee species richness and abundance were positively correlated with observed flower-visitor species richness, diversity and abundance. The Pearson correlation coefficient between observed flower-visitor species richness, diversity or abundance, and... |

### Model selection and model averaging for matrix exponential spatial models

- DOI : `10.1080/07474938.2022.2047507`
- TEI : `corpus\papers\tei\Yang2022Model.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | The matrix exponential specification | We consider the following cross-sectional MESS(1, 1) model where y ¼ ðy 1 , :::, y n Þ 0 is the n Â 1 vector of an outcome variable, X is the n Â k matrix of non-stochastic exogenous variables with the matching parameter vector b, W and M are the n Â n spat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Spatial weights matrix selection | Our goal is to select the spatial weights matrices that minimize a certain criterion function. As such, we follow the literature on the MS and MA problems (Hansen, 2007; Li, 1987; Wan et al., 2010; Zhang and Yu, 2018) to determine a selection criterion func... |

### Multiplicative Interaction in Generalized Linear Models

- TEI : `corpus\papers\tei\Multiplicative interaction in generalized linear models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Visual Displays of Interaction by Means of Biplots | Biplots constitute a powerful tool for displaying interaction which is described by the multiplicative terms in an AMMI model (Gabriel, 1971; Kempton, 1984) . In a biplot, rows and columns are represented by points in twoor three-dimensional space. The coor... |
| low_priority_review | `DataSourceCandidate` | 59 | Standar-dizing and Orthonor-malizing the Column Inter-action Effects | For the calculations involved in the standardization and orthonormalization of the column interaction effects, see Section 3.1. If convergence has occurred, stop, otherwise go back to Section 3.2 using the values for f and 3, from Sections 3.4 and 3.5. Chan... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 82 | Introduction | In r-ecenit year-s thier h1as been a revival of inltercest in thlC USC of bilinear multiplicative models for interaction in the analysis of two-way geniotype by environimienit tables in planit breediing. For a loing time regiession oIn the mean (Yates and C... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | GLMs and AMMI Models | In a GLM for the random variable y the known link function g( ) transforms the expectation of y, W(y) = ,u, to the linear predictor 71 = xT,3, where the vector x contains the values of the independent variables and the vector ,3 the unknown parameters (McCu... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Forming Initial Values for the Column Main and Interaction Effects | When a GAMMI model with K axes is to be fitted and no results are available from fits with M < K axes, fit a main effects model to the two-way table, -,ii = v + ai + f31, and save the estimates , of the column main effects. Also choose arbitrary column scor... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Mulltiplicative Interaction in GLMs 1023 | 6. An Application of a Log-Bilinear Model to Counts of Potato Cyst Nematodes on Potatoes Table 1 gives the number of newly formed cysts on 11 potato genotypes for five potato cyst nematode populations belonging to the species Globodera pallida (part of a la... |

### Multiscale Geographically Weighted Regression

- DOI : `10.1201/9781003435464`
- TEI : `corpus\papers\tei\Multiscale Geographically Weighted Regression_Stewart et al__previewpdf.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Multiscale Geographically Weighted Regression | The above paragraph highlights an important distinction between research focused on data and research focused on processes. Throughout most of its long history, human geography, for example, has been primarily concerned with data. Initially the focus was on... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Preface | It is 20 years since the publication of the seminal text on geographically weighted regression (GWR) by Fotheringham et al. (2002) , almost 30 years since the first crude articulations of this approach appeared (Fotheringham & Rogerson, 1993; Rogerson & Fot... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | A Conceptual Overview of MGWR | In the calibration of a global model, such as those in equations (1.1) and (1.2), with spatial data recorded at a number of locations, the typical procedure would involve using the data on y, x 1 , x 2 , . . . x k recorded at each location in a single calib... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Local Versus Global Models | From the origins of the quantitative 'turn' across many social sciences came a focus on relationships between attributes with regression-based models, as exemplified by equation (1.1), being especially popular: where y i is the variable of interest measured... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Setting the Scene | Research in many fields is prompted by the empirical observation that the values of most attributes vary over space and/or time. The earliest astronomers were guided by observing the night sky and noting the changes in the positions of certain stars or by o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 82 | Introduction to Local Modeling | parameter bias outweighs the reduction in uncertainty. If the process being modeled has a high degree of spatial variability, the bandwidth will be small; if the process has low spatial variability, the bandwidth will be large. A global process will result... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | Section 1 | Taylor M. Oshan is assistant professor in the Center for Geospatial Information Science in the Department of Geographical Sciences, University of Maryland, as well as an affiliate of the Social Data Science Center, the Maryland Population Research Center, a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Why "Local"-the Role of Spatial Context | The raison d'être of local models is that the processes being modeled might vary across space. Consequently, it is pertinent to ask how and why processes could vary over space and which processes might be susceptible to such variation. Clearly, there is no... |

### Multiscale geographically and temporally weighted regression: exploring the spatiotemporal determinants of housing prices

- DOI : `10.1080/13658816.2018.1545158`
- TEI : `corpus\papers\tei\Chao Wu, Fu Ren, Wei Hu & Qingyun Du_2018_MGTWR.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Datasets and variables | Based on data availability and hedonic theory (Rosen 1974) , we use the real transaction housing price data from 2010 to 2017 (source: Shenzhen Research Centre of Digital City Engineering). We select the real estate unit with an accurate geographic location... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically and temporally weighted regression | To effectively address spatiotemporal heterogeneity, Huang et al. (2010) extended GWR to GTWR. The form of GTWR is described as follows: where u i ; v i ; t i ð Þ are the space-time coordinates of the ith sample, and β k u i ; v i ; t i ð Þ is the estimated... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Introduction | Geographically weighted regression (GWR) is a popular local regression method that has been applied within a variety of disciplines (Brunsdon et al. 1996 , Fotheringham et al. 1998 , Bitter et al. 2007 , Nilsson 2014 ). In addition, many studies have focuse... |
| review_for_dataset_use | `VariableTableCandidate` | 79 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 79 | GROBID table | Variables Estimated coefficients Standard deviation t-value p-value Constant -0.232*** 14.2834 -8.523 .000 FEE 0.121*** 0.017 7.118 .000 GREEN 0.105 *** 0.015 6.771 .000 PLOT -0.014*** 0.018 -0.827 .008 PARKING 0.016 0.016 1.015 .310 CBD -0.169 *** 0.023 -7... |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 2 . |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 6 . |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 7 . |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Variables Spatial bandwidth AICc Min Q1 Mean Q3 Max Constant 0.053 852.827 -90.743 -3.685 -0.025 3.747 112.877 FEE 75.980 -122.591 0.321 0.322 0.322 0.322 0.322 GREEN 75.980 -122.613 0.250 0.250 0.250 0.250 0.250 PLOT 75.980 -122.589 -0.135 -0.135 -0.134 -0... |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Variables Min Q1 Mean Q3 Max Constant -1.675 -0.515 -0.077 0.425 1.499 FEE -0.765 0.173 0.285 0.373 1.052 GREEN -0.362 0.004 0.054 0.107 0.509 PLOT -0.798 -0.037 0.015 0.068 1.004 PARKING -0.570 -0.051 -0.010 0.059 2.236 CBD -1.264 -0.583 -0.414 -0.283 0.55... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Variables Abbreviation Min Max Mean Std. Structural variables Property Fee (Yuan/m 2 • month) FEE 0.800 16.000 3.715 1.347 Green ratio GREEN 10.000 90.000 34.454 8.695 Plot ratio PLOT 0.400 14.930 3.725 1.714 Parking space ratio PARKING 0.071 9.660 1.141 0.... |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM

- DOI : `10.1080/13658816.2023.2270285`
- TEI : `corpus\papers\tei\Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | A Geographical Gaussian Process GAM for SVC modelling | GAMs provide a method for calibrating regression models with unspecified functions of the predictor variables, of the form: where z j may be a scalar or a vector. These can be extended such that each f j ðz j Þ is a linear regression coefficient on another... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data | A spatial analysis of the factors associated with the 2016 referendum on EU membership (Brexit) was used to empirically illustrate the proposed GGP-GAM approach and to compare it with MGWR. Census and voting data were obtained from the parlitools R package... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion and conclusion | Spatially varying coefficient (SVC) models explicitly accommodate process spatial nonstationarity, where statistical relationships expressed using regression coefficient estimates are allowed to vary with location. SVCs provide an explicit representation of... |
| review_for_dataset_use | `DataSourceCandidate` | 83 | A simulation case study | Simulated spatial data sets with varying degrees of regression relationship heterogeneity were used to examine the performance of the GGP-GAM and to compare that with the performance of a standard MGWR. The simulated data were created in a similar way to Fo... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 4 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | A GGP-GAM analysis | Spatially varying coefficient models with the GGP-GAM were undertaken using the OSGB projected parliamentary constituency in Figure 4 . The geometric centroids of each parliamentary constituency were extracted to generate X and Y (Easting and Northing) vari... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | A MGWR analysis | Finally it also is possible to compare the GGP-GAM results with those from a MGWR. Summaries of model fit and accuracy are shown in Table 6 . Comparing the diagnostics of AIC, adjusted R 2 , and MAE for the GGP-GAM and MGWR models indicates that the MGWR mo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | GAMs | Generalized Additive Models (GAMs) are general in that they can handle outputs with many types of distributions and not just linear relationships, polynomial or not (Wood 2006; Fahrmeir et al. 2022) . They are additive and because they generate multiple mod... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | Introduction | A standard linear regression seeks to model the relationship between a response variable and a series of predictor variables. Via ordinary least squares (OLS), it estimates a single set of unknown regression coefficients for each predictor (and intercept) t... |

### Multivariable geostatistics in S: the gstat package $

- DOI : `10.1016/j.cageo.2004.03.012`
- TEI : `corpus\papers\tei\pebesma2004.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Handling spatial data in S | Prediction locations are often gridded, and observations sometimes are. As noted above, a number of efficiency gains can be obtained when the grid topology of data, if present, is available to gstat. Storing prediction results as grids (2D matrices) can be... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | Formula interface | The gstat S package uses the S formula interface, (Chambers and Hastie, 1992) , which is also found in the regression and ANOVA functions (lm, aov), generalised linear models (glm), and many other regression modelling or prediction methods. The first functi... |
| low_priority_review | `DataSourceCandidate` | 60 | C code | The gstat C code used for the gstat package consists of approximately 25,000 lines of ''native'' gstat code, and 14,000 lines of C code in the Meschach matrix, library (Stewart and Leyk, 1994 ; Meschach home page: http:// www.math.uiowa.edu/Bdstewart/mescha... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Univariable prediction | Let Z(s) be a vector of length n with observations Z(s 1 ),y,Z(s n ) observed at spatial locations s i arbitrarily spread in R 1 , R 2 or R 3 . The variability in observations Z(s) is usually thought of as consisting of a trend and a residual, and the trend... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | Extensions | Gstat provides a number of highly useful extensions to the straightforward application of Eqs. (2) and (3): Kriging in a local neighbourhood: Instead of using all data, only data in a local neighbourhood around s 0 are used for predicting Z(s 0 ), where nei... |

### Multivariate Adaptive Regression Splines

- TEI : `corpus\papers\tei\kooperberg2014_MARS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Example | We applied the Polymars methodology to data from a study of the dependence of ozone on wind speed, temperature and radiation level over 111 days in 1973 in 3 New York metropolitan areas [16] . This data set is analyzed in many other places [17, 18] (see Reg... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Having made the connection between knot selection and basis function (variable) selection, we can now apply any stand... | Many well-known variable selection techniques have been successfully used in polynomial spline algorithms. Smith [9] proposed to start with a large number of equidistant knots, and to use stepwise deletion of knots (basis functions) from there. Stepwise kno... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Higher Dimensional Problems | For higher dimensional problems the approach taken in adaptive regression spline methodologies is to consider selected tensor products of one-dimensional basis functions as basis functions for the higher dimensional problem. Note that the tensor product of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | The Polymars Algorithm | Polymars [5] is another adaptive polynomial spline methodology for multivariate regression. The set-up for Polymars is identical to that for MARS, except that Polymars allows the response to be multivariate as well. This was done with the classification pro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | (see Splines in Nonparametric Regression). | If (2) is used to estimate a regression function the coefficients can be estimated by least squares or maximum likelihood. This is a standard parametric regression problem. The complication in using this model is that it is not clear where to put the knots.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | Section 1 | The multivariate adaptive regression splines (MARS) algorithm applies an adaptive regression spline algorithm to the multiple regression problem. Seen as a function estimation problem, the nonparametric multiple regression problem is to estimate that is, to... |

### Niche conservatism limits the distribution of Medicago in the tropics

- DOI : `10.1111/ecog.06085`
- TEI : `corpus\papers\tei\Yang2022Niche.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographical variation in energy-richness relationship | Interestingly, energy was positively correlated with species richness in temperate Asia, Europe and North America (Fig. 3 , Supporting information) and temperate biomes (tundra, boreal forest, temperate seasonal forest, temperate grassland/desert and woodla... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Richness-energy relationship across continents, biomes and latitudes | We find that the energy variables are significantly correlated to Medicago species richness and they explain between 23 and 66% of the total variance, only next to Quaternary climate change variables (Supporting information). Interestingly, the effect of en... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Medicago distribution data | The global distribution data of Medicago were compiled from published floras, checklists, online databases, field investigations and herbarium specimens (see Supporting information for the list of all sources). The compiled data mainly included administrati... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Introduction | One of the fundamental patterns for large-scale species diversity is the increase in species number from poles to the tropics, also known as the latitudinal diversity gradient (LDG) (Rosenzweig 1995 , Willig et al. 2003 , Pontarp et al. 2019) . Although a l... |
| low_priority_review | `DataSourceCandidate` | 63 | Whittaker's biomes | We first constructed the Whittaker's biomes (Whittaker 1975 ) using two abiotic factors: mean annual precipitation and mean annual temperature of each grid cell estimated as explained above. Based on this, we divided the gridded distribution of Medicago int... |
| low_priority_review | `DataSourceCandidate` | 59 | Conclusions | Our findings show that long-term climate stability and environmental energy determine the distributions of Medicago at the global, continental and biome scales. In contrast to the energy hypothesis, our results suggest that high Medicago species richness is... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Mediterranean climatic niche and Medicago species richness | In order to evaluate how species richness varies with the deviation from Mediterranean climatic niche, we first identified the grid cells of the Mediterranean basin. Next, we extracted the mean value of six bioclimatic variables (which included three temper... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 63 | Models and statistical analyses | First, we used univariate generalized linear models (GLMs) to evaluate the effects of each climatic variables on the geographical patterns in species richness. To assess the consistency in relationships between species richness and climate variables in diff... |

### Notes on the earth package

- DOI : `10.1214/aos/1176347963.pdf`
- TEI : `corpus\papers\tei\Earth_MARS__a_note_on_earth.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Further notes on the allowed argument | The basic MARS model building strategy is always applied even when there is an allowed function. For example, earth considers a term for addition only if all factors of that term except the new one are already in a model term. This means that an allowed fun... |
| low_priority_review | `DataSourceCandidate` | 67 | Datasets for measuring performance | In the next section we will discuss some common cross-validation mistakes. But first we review some aspects of measuring a model's performance, and the datasets needed to do that. Understanding the role of these datasets is important for applying cross-vali... |
| low_priority_review | `DataSourceCandidate` | 64 | Short versus long binomial data | Use the function expand.bpairs to convert the "short" form of the data (with a twocolumn binomial pair response) to the equivalent "long" form (with a single response column of TRUEs and FALSEs). See the help page of expand.bpairs for an example. Models bui... |
| low_priority_review | `DataSourceCandidate` | 61 | A short introduction to Flexible Discriminant Analysis | Flexible Discriminant Analysis (FDA) is Linear Discriminant Analysis (LDA) on steroids. LDA uses a hyperplane to separate the classes. FDA replaces this hyperplane with a curved or bent surface to better separate the classes. The trick FDA uses to achieve t... |
| low_priority_review | `DataSourceCandidate` | 61 | Introduction | The earth R package [19, 22] builds regression models using the techniques in Friedman's papers "Multivariate Adaptive Regression Splines" [7] and "Fast MARS" [8] . The package can be downloaded from https://CRAN.R-project.org/package=earth . The term "MARS... |
| low_priority_review | `DataSourceCandidate` | 61 | Remarks | We mention first that several of the arguments in the call to plot.earth above simply remove display elements. The defaults for these arguments are inappropriate for this somewhat unusual plot (we aren't usually interested in the in-fold R 2 s). Note how va... |
| low_priority_review | `DataSourceCandidate` | 61 | What is the best value for nfold? | The question of choosing the number of cross-validation folds remains an open research question. We can only suggest that you try 5-or 10-fold cross-validation, unless you have a small dataset. With a small dataset some experimentation may be needed to get... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | (ii) Factor response (multinomial response). | This example is for a factor with more than two levels. (For factors with just two levels, see the previous example.) multinom.mod <-earth(pclass~., data=etitanic, glm=list(family=binomial), trace=1) Internally in earth, the factor pclass is expanded to thr... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Remarks on evimp | The evimp function is useful in practice but the following issues can make it misleading. Collinear (or otherwise related) variables can mask each other's importance, just as in linear models. This means that if two predictors are closely related, the earth... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | 13.6 | What is a GCV, in simple terms? GCVs are important for MARS because the backward pass uses GCVs to evaluate model subsets. Usually when testing a model (not necessarily a MARS model) we want to test generalization performance, and so want to measure error o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | GLM examples | The examples below show how to specify earth-glm models. The examples are only to illustrate the syntax and not necessarily useful models. In these examples we use trace=1 so earth shows how it expands the input data (as explained in Chapter 5 "Factors (cat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Generating the same model as lm | Sometimes we would like to generate the same model as lm, with all predictors entering linearly. But the linpreds argument doesn't stipulate that a predictor must enter the model, only that if it enters it should enter linearly. If a variable has negligible... |
| low_priority_review | `truncated` |  |  | 6 autres candidats non affiches dans ce rapport |

### Novel approach to the analysis of spatially-varying treatment effects in onfarm experiments

- DOI : `10.1016/j.fcr.2020.107783`
- TEI : `corpus\papers\tei\rakshit2020_gartner_dataset.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Bandwidth selection for modelling yield using spatial variables | Here we consider bandwidth selection for the Minnesota field experiment data shown in Fig. 1 . The aim is to model yield as a function of the spatial variable elevation. Both leave-one-out cross-validation and AIC select small bandwidths for this dataset. U... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Cross-validation and AIC for bandwidth selection | Irrespective of which kernel function is selected, the choice of bandwidth is crucial for local estimation of the model coefficients. A large bandwidth oversmooths the local effects and produces local estimates that are close to the global estimate, while a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion | In this paper, we proposed a novel approach for estimating spatially-varying relationships in on-farm experiments. We discussed two important scenarios of modelling yield data obtained from yield monitoring systems: (i) as a function of a spatial explanator... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Graphical display of the GWR results. | Although the primary focus of a GWR analysis is to compute and plot the spatially-varying treatment effects (e.g., see Fig. 12 ), these plots may not be readily interpretable, particularly when high order terms greater than the linear term are included in a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Kernel function | Several kernel functions, namely Gaussian, exponential, bi-square and tri-cube, have been described in terms of distance decay (Gollini et al., 2015, pp. 5-6) . The Gaussian and exponential kernels are continuous functions of the distance and thus produce n... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Las Rosas data: estimation and display of the spatially-varying regression coefficients | Fig. 12 shows spatial variation in the local estimates of the regression coefficients corresponding to the quadratic template model fitted to the Las Rosas strip experiment data. Fig. 13 shows the adjusted pvalues corresponding to the linear and quadratic t... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Las Rosas data: inadequacy of the global model | Fig. 2 shows the variation in the yield (measured in quintals/ha) where the east-slope, low-east and some parts of the west-slope zone on average produced higher yield than the hilltop and remaining parts of the west-slope zone. These zonal performances can... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Minnesota data: estimation and display of the spatially-varying slope coefficients | Fig. 8 shows the varying spatial relationship between yield and elevation in the Minnesota data. The contours in the plot help to identify zones with similar coefficients, and such a display could be helpful in assisting analysts to delineate separate manag... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Minnesota data: inadequacy of the global model | Although spatial variation in yield across the field is evident from Fig. 1 , spatial variation in the relationship between yield and elevation is not readily apparent. Left panel of Fig. 6 shows the global linear relationship between yield and elevation, w... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | In this section, we discuss the analyses of yield responses from two on-farm experiments, applying the above described approach, and present the results. Yield data in these experiments (see Figs. 1 and 2 ) were recorded along with geo-coordinates of the ha... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | Conclusions | The novelty of the presented approach can be summarized as follows: • Adapts Geographically Weighted Regression (GWR) to on-farm ex- perimentation (OFE). • Allows estimation of spatially-varying treatment effects. • Develops methods for selecting smoothing... |
| review_for_dataset_use | `DataSourceCandidate` | 87 | Example datasets: Minnesota and Las Rosas corn field experiments | Figs. 1 and 2 show the yield recorded using combine harvesters from the corn field experiments in Minnesota, USA and Las Rosas, Argentina, respectively. The Minnesota and Las Rosas datasets are publicly available by the names of gartner.corn and lasrosas.co... |
| low_priority_review | `truncated` |  |  | 10 autres candidats non affiches dans ce rapport |

### O impacto das cooperativas na produção agropecuária brasileira: uma análise econométrica espacial The impact of cooperatives on Brazilian agricultural production: a spatial econ...

- DOI : `10.1590/1806-9479.2019.187145`
- TEI : `corpus\papers\tei\Neves2019Impacto.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Efeito da associação a cooperativas | Prosseguindo com a análise proposta na estratégia empírica, o modelo foi estimado, incialmente, por MQO, com os resultados sendo reportados na Tabela 4 13 . 13 Note que, para a estimação dos modelos econométricos, a variável de interesse (associação a coope... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Análise espacial dos dados | A Análise Exploratória de Dados Espaciais realizada sobre as variáveis dependente e de controle, conforme já estabelecido, foi dividida em duas partes: global e local. Em ambas as análises foi preciso determinar o tipo mais apropriado de matrizes de pondera... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Cooperativismo no Brasil ruralrelevância e heterogeneidades | A literatura relativa à economia das organizações explica a existência das cooperativas agropecuárias por sua habilidade de: a) engendrar economias de escala; b) acessar novos mercados, inclusive internacionais; c) reduzir custos por meio da integração vert... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Função de produção | Pode-se tomar uma relação funcional de produção genérica ( ) , , , Y f L K T = … , como descrita por Humphrey (1997) , em que Y é a produção resultante da combinação dos fatores trabalho L, do capital K, da terra T etc. e adaptá-la ao objetivo deste trabalh... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | 564/ 576 | tal valor indicam autocorrelação espacial positiva, bem como valores menores que o da relação sugerem autocorrelação espacial negativa. Espera-se que, com o teste de Moran, possam ser obtidos três tipos de informações. A primeira remete ao nível de signific... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Aspectos espaciais | Para a investigação pretendida, tem-se como primeiro passo a análise exploratória dos dados espaciais (Aede). Esta Aede foi desenvolvida por meio dos testes de I de Moran, que consideram tanto perspectivas globais quanto locais acerca das variáveis. A propo... |

### Oblique geographic coordinates as covariates for digital soil mapping

- DOI : `10.5194/soil-6-269-2020`
- TEI : `corpus\papers\tei\Moller_2020_OGC.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | A1.1 meuse | We mapped zinc contents for the meuse dataset (155 points). The meuse dataset contains covariates including the flooding frequency and the distance to the river. We added two covariates in the form of a digital elevation model (DEM, https://www.ahn.nl/ , la... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | A1.2 eberg | We mapped soil types for the eberg dataset. The eberg dataset contains 3670 soil observations. We removed points outside the coverage of the covariates and points without a soil type classification. Furthermore, we removed the soil types "Moor" and "HMoor",... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | A1.3 Swiss rainfall | The Swiss rainfall dataset contains 467 rainfall observations from Switzerland from 8 May 1986. We did not use any covariates for this dataset, and we therefore tested only purely spatial methods. We tested ordinary kriging with correction for anisotropy, E... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Additional datasets | For the three additional datasets, the effect of increasing the number of coordinate rasters without auxiliary data was generally the same as for the Vindum dataset. In all three cases, there was relatively little, if any, increase in accuracy after an init... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Appendix A: Methods and results for additional datasets |  |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Choice of method | At Vindum, the three most accurate methods were kriging, RFsp with auxiliary data and OGCs with auxiliary data. For meuse, OGCs and EDFs combined with auxiliary data were most accurate and for eberg, OGCs combined with auxiliary data were most accurate. For... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Covariate importance | For the Vindum dataset, the most important covariate from the auxiliary data was the depth of sinks (Table 6 ). The most likely reason for its high importance is the presence of a large sink with very high SOM contents northwest of the middle of this study... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Method comparison 2.3.1 Vindum | We use the 285 SOM observations from the Vindum study area in order to test the accuracy of predictions made by random forest models using OGCs as covariates. In addition to OGCs, we also employed 19 data layers with auxiliary data, which Pouladi et al. (20... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Conclusions | We have shown in this study that the use of oblique geographic coordinates (OGCs) is a reliable method for integrating auxiliary data with spatial trends for modeling and mapping soil properties. In most cases, the method eliminated the orthogonal artifacts... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Introduction | Machine learning has become a frequently applied means for mapping soil properties in geographic space. The most common approach is to train models from soil observations and covariates in the form of geographic data layers. The models can often provide rel... |
| review_for_dataset_use | `DataSourceCandidate` | 85 | Additional datasets | We also compared OGCs to other methods based on the three additional datasets meuse, eberg and Swiss rainfall. The methods in the comparison depended on the dataset. For the meuse dataset, we tested all the methods tested on the Vindum dataset, with the add... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and methods |  |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### On the determinants of Airbnb location and its spatial distribution

- DOI : `10.1177/1354816618825415`
- TEI : `corpus\papers\tei\EugenioMartin_CazorlaArtiles_GonzalezMartel_2019_AirbnbCanarySpatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Bivariate spatial correlation | For the purpose of this article, bivariate spatial correlation is the key to understand the spatial relationship between established hotels and P2P accommodation. A natural extension of the Moran's I statistic is the bivariate Moran's I statistic. It should... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial weight matrix | The building of the spatial weight matrix W is critical for the results, so that careful thinking is required for its construction. W is a square matrix that relates all pairs of origin-destinations ij in space. Generally speaking, three kinds of formal exp... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 4 . |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 5 . |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Variables Estimates Elasticities Airbnb price 3.401*** (0.401) 4.456*** Population 0.010*** (0.000) 0.214*** Tourist visits 0.0723*** (0.007) 0.388*** Spatially lagged tourist visits 2.084*** (0.731) 0.575*** Tourist visits to protected areas À0.228*** (0.0... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Variables Estimates Elasticities (total effect) Nature-based destinations Airbnb price 2.625*** (0.450) 3.871*** Population 0.011*** (0.001) 0.248*** Tourist visits À0.004 (0.006) À0.026 Spatially lagged tourist visits 1.044* (0.630) 0.324 Sun and beach des... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Local tests of bivariate spatial correlation | The empirical strategy to obtain the local tests of bivariate spatial correlation is based on a series of steps. The first step requires incremental Moran's I tests to find out the distance that maximizes the z-score value of the test. The results show that... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 75 | Methodology | The article provides results on bivariate spatial correlation and spatial econometrics. The methodological details are explained below. |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Spatial econometrics modeling | A positive Airbnb spatial autocorrelation suggests that its location depends on the location of other Airbnb properties nearby. Such positive value is an indicator of the presence of agglomeration effects. It can be tested with spatial econometrics analysis... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Spatial econometrics analysis | The estimates of the determinants of Airbnb entry location are shown in Table 4 . They show that the spatial autoregressive coefficient is significant, so that the spatial approach makes sense. It is positive, so that it proves the presence of agglomeration... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | P2P spatial competition | We have leaned on the article written by Gutie ´rrez et al. (2017) . This article works with spatial correlations. They had been employed previously in a tourism context (see for instance, Luo and Yang, 2013) . However, this is the only article that has ana... |

### Once upon Multivariate Analyses: When They Tell Several Stories about Biological Evolution

- DOI : `10.1371/journal.pone.0132801`
- TEI : `corpus\papers\tei\ade4_houmousr - Once upon Multivariate Analyses When They Tell Several Stories about Biological Evolution.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Comparison between patterns of differentiation provided by the different multivariate methods | The representations of differentiation provided by the different multivariate methods applied to the same dataset (molar shape) were compared as follow. The scores of the group means on axes of a given analysis provide a configuration that can be compared t... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion | The mathematical properties of common multivariate methods such as the Principal Component Analysis and the Canonical Variate Analysis (a.k.a Linear Discriminant Analysis) are well known [15, 16] . These analyses are basic methods in the context of geometri... |
| review_for_dataset_use | `DataSourceCandidate` | 94 | Characterization of the direction of main variance in well-sampled groups | The standardization by the intragroup variance W should impact CVA more if groups displayed marked directions of main variance parallel in the different groups. Such direction of main variance for a group i corresponds to the first eigenvector of a PCA on t... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Case study: molar shape divergence of house mice on islands | The house mouse (Mus musculus domesticus) is a highly successful colonizer because it accompanied human travels since archaeological times [28, 29] . This has led to a complex phylogeographic pattern across worldwide populations of mice (e.g. [30] [31] [32]... |
| low_priority_review | `DataSourceCandidate` | 69 | Material | A total of 432 first upper molars were considered in the analyses (Table 1 ; Fig 2 ). All mice were sub-adults and adults, the criteria being the eruption of the third molars that occurs at weaning. Sexual dimorphism has not been documented so far in molar... |
| low_priority_review | `DataSourceCandidate` | 69 | Phylogenetics: Independent colonization of the different archipelago | A total of 424 mt DNA control region sequences of 834 bp were obtained from GenBank. The populations from the four archipelagos are found on different branches of the phylogenetic tree, suggesting that Orkney, Guillou Island, Marion Island and Corsica were... |
| low_priority_review | `DataSourceCandidate` | 67 | Congruence between main directions of within-group variance among well-sampled groups | The direction of main variance (Pmax) was assessed in the three well-sampled groups of Gardouch (France) and the islands Marion and Corsica. 100 bootstrapped estimates were calculated for each Pmax, providing a 95% confidence interval for the estimation of... |
| low_priority_review | `DataSourceCandidate` | 53 | Introduction | In the last few decades, geometric morphometrics [1, 2] has been established as a powerful tool to characterize shape variation of complex morphological structures, in contexts as diverse as phylogenetic diversification [3, 4] , developmental biology [5, 6]... |
| low_priority_review | `DataSourceCandidate` | 48 | Outline analysis | The molar shape was approximated by the 2D outline of the tooth seen from the occlusal surface, the focus being made towards the base of the crown, which is only affected by heavy wear [53] . Each outline was defined by a set of 64 points, the starting poin... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 77 | Different methods, different evolutionary patterns, all biologically relevant | Considering the present case study, the PCA and the CVA highlight different evolutionary patterns in the evolution of molar shape in insular populations of house mice (Fig 4 ; schematic representation Fig 6 ). The PCA, be it on the total variance or on betw... |

### POWER-LAW MODELS FOR INFECTIOUS DISEASE SPREAD 1

- DOI : `10.1214/14-AOAS743`
- TEI : `corpus\papers\tei\surveillance_fluBYBW - Power-law models for infectious disease spread.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Power-law extension. | To implement the power-law principle in the network of geographical regions, we first need to define a distance measure on which the power law acts. There are two natural choices: Euclidean distance between centroid coordinates and the order of neighbourhoo... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Introduction. | The spatio-temporal point process model proposed by Meyer, Elias and Höhle (2012) is designed for time-space-mark data {(t i , s i , m i ) : i = 1, . . . , n} of individual case reports to describe the occurrence of infections ('events') and their potential... |
| review_for_dataset_use | `DataSourceCandidate` | 94 | 4.1. | Cases of invasive meningococcal disease in Germany, [2002] [2003] [2004] [2005] [2006] [2007] [2008] (see Figure 2 ). In the original analysis of the IMD data [Meyer, Elias and Höhle (2012) ], comprehensive AIC-based model selection yielded a linear time tr... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Inference. | We set ω 1 = 1 for identifiability and estimate the decay parameter d and the unconstrained weights ω 2 , . . . , ω M on the log-scale to enforce positivity. Supplied with the enhanced score function and Fisher information matrix, estimation of parametric w... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Introduction. | The multivariate time-series model established by Held and Paul (2012) [see also Paul and Held (2011), Paul, Held and Toschke (2008) , Held, Höhle and Hofmann (2005) ] is designed for spatially and temporally aggregated surveillance data, that is, disease c... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Section 1 | 1. Introduction. The surveillance of infectious diseases constitutes a key issue of public health and modelling their spread is basic to the prevention and control of epidemics. An important task is the timely detection of disease outbreaks, for which popul... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Inference. | Model parameters are estimated via maximization of the full (log-)likelihood, applying a quasi-Newton algorithm with analytical gradient and Hessian [see Meyer and Held (2014) , Section 1.1]. We estimate kernel parameters on the log-scale to avoid constrain... |

### Precision Agriculture: Economics of Nitrogen Management in Corn Using Sitespecific Crop Response Estimates from a Spatial Regression Model

- TEI : `corpus\papers\tei\Economics of Nitrogen Management in Corn Using Sitespecific cross response.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | DATA | N response data was collected from strip trials on four farms in the Río Cuarto area, Córdoba Province, Argentina, in the 1998-99 crop season. This paper deals only with the yield data (8288 observations) from the farm "Las Rosas" located at 63º 50' 50" of... |
| review_for_dataset_use | `DataSourceCandidate` | 99 | METHODOLOGY | Response function estimation using spatial econometric techniques requires three steps: 1) Specification tests and diagnostics for the presence of spatial effects, 2) The formal specification of spatial effects in econometric models, and 3) The estimation o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | RESULTS | Diagnostics tests for spatial dependence in the OLS model confirm that there is spatial autocorrelation in the data and that an error model should be used. There is also some presence of heteroskedasticity. The LM-error test for "Las Rosas" farm is 2762, wh... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 84 | INTRODUCTION | Technologies based on computerized information and global positioning systems (GPS) are transforming large-scale commercial agriculture throughout the world. This technology is often labeled "precision agriculture" and is giving new life to the old idea of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Spatial Autocorrelation. | Spatial autocorrelation, or more generally, spatial dependence, is the situation where the dependent variable or error term at each location is correlated with observations on the dependent variable or values for the error term at other locations. The gener... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Returns to Uniform Rate and to Variable Rate N. | Returns from N above fertilizer cost were estimated for two uniform application rates and for VRA by landscape position (Table 3 ). Two uniform rates were used to represent the range of N rates currently used in the Río Cuarto area. The higher uniform N rat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Spatial Regression Models. | Since the estimates from the spatial regression model are going to be used in a decision model to measure costs, profits, etc., then accurate estimates are needed. This is the main role of an error model, whereas, in the lag model, the main role is to predi... |
| low_priority_review | `ModelEvidenceCandidate` | 47 | LITERATURE REVIEW | Site-specific fertilizer application is an old idea. In the US, the first extension recommendations on intensive soil sampling and variable rate fertilizer application appeared in 1929 (Linsley and Bauer, 1929) . The recent resurgence of interest in the ide... |

### Primary productivity explains size variation across the Pallid bat's western geographic range

- DOI : `10.1111/1365-2435.13092`
- TEI : `corpus\papers\tei\Kelly2018Primary.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Data analyses | Prior to investigating geographic size variability, we tested for any evidence of sexual size dimorphism using Welch's two sample t test. Male and female Pallid bats did not differ in size (see Section 3), and therefore, we pooled males and females for subs... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / RE SULTS | We found no evidence of sexual size dimorphism when we used centroid size of the lateral or ventral views of cranium as proxies for A. pallidus body size, (lateral cranium: t = -0.57, df = 173, p = .57, ventral cranium: t = -0.27, df = 173, p = .78). Our an... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Specimens and geometric morphometric analysis | Our sample was composed of 175 adult Pallid bat crania (male = 82, female = 93) spanning a latitudinal gradient across the western part of their range (Figure 1 , Table S1 ). Using a Canon Powershot SLR camera mounted on a copy stand, we obtained digital im... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | / D ISCUSS I ON | The Pallid bat exhibits substantial geographic variation in body size and dietary ecology, and our objective was to identify the environmental factors that best explain this variation. We found that Pallid bats tend to be larger in the northern part of thei... |
| low_priority_review | `DataSourceCandidate` | 69 | / INTRODUC TI ON | Body size is tightly associated with the life history, ecology and physiology of animals (Isaac, 2005; Lindstedt & Boyce, 1985; Porter & Kearney, 2009) . Within a species, adult body sizes can vary substantially across space and time, and the mechanisms gen... |
| low_priority_review | `DataSourceCandidate` | 63 | / Environmental variables | We acquired spatially gridded environmental datasets to inform tests of the heat conservation and dissipation, seasonality and were generated using data from weather station monthly averages between the years 1960-1990 (Hijmans et al., 2005) . To test the s... |

### Quantification of Neighborhood-Level Social Determinants of Health in the Continental United States

- DOI : `10.1001/jamanetworkopen.2019.19928`
- TEI : `corpus\papers\tei\kolak_2020_oi_190747.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Discussion | The design, implementation, and evaluation of effective policies at the local, state, and federal levels to improve health outcomes can be improved through a deeper understanding of the complexities of social and economic disparities. In this study, we aime... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Regression Analysis | We estimated associations between premature mortality rates in Chicago using the 4 indices derived from the dominant principal components while controlling for the violent crime rate. The indices were used as input to retain the greatest information rather... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Regression Analysis | We found that in Chicago, more than 60% of the variation in premature mortality at the neighborhood level was associated with SDOH dimensions alone, even after accounting for violent crime and underlying spatial structures. An association was observed betwe... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Health Outcomes and Violent Crime | To estimate associations between social determinants of health and health outcomes for a subset of data, the mortality rate at the census-tract level was used for the Chicago, for which we had sufficiently high-quality direct measurements of premature morta... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Population and Spatial Scale | In this cross-sectional multivariate analysis, the first phase of the study included all populated census tracts of the continental United States (n = 71 901), with a total observed population of approximately 312 million persons based on census estimates.... |
| review_for_dataset_use | `DataSourceCandidate` | 75 | Limitations | Our study had several limitations. Notably, our analysis was an in-depth empirical exploration of SDOH indicators, their interactions, and their associations with premature mortality within a limited period. Because of the potentially unmeasured factors and... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Principal Component Analysis | Four principal components-the socioeconomic advantage index, the limited mobility index, the urban core opportunity index, and the mixed immigrant cohesion and accessibility index-met the Kaiser criterion for inclusion. Together, they accounted for 71% of t... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Regionalization Analysis | We conducted a dimension-reducing clustering analysis to decompose tracts into typologies that had similar SDOH characteristics. Similar to principal component analyses, this clustering analysis is a machine learning technique that uses unsupervised algorit... |
| low_priority_review | `DataSourceCandidate` | 69 | Regionalization Analysis | A cumulative SDOH index was calculated by adding all 4 component index scores, weighting each by their proportional variance from the principal component analysis. A cumulative SDOH index mapped across the continental United States (eFigure 3 in the Supplem... |
| low_priority_review | `DataSourceCandidate` | 62 | Results | Among the 71 901 census tracts (n = 312 million persons) examined across the continental United States, a median (interquartile range [IQR]) of 27.2% (47.1%) of residents had minority status, 12.1% (7.5%) had disabilities, 22.9% (7.6%) were 18 years and you... |
| low_priority_review | `DataSourceCandidate` | 53 | Introduction | The consequences of social determinants of health (SDOH) increasingly dominate public health discussions in the United States, as population health outcomes have not kept pace with those of other developed nations despite higher per-person spending for medi... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Quasi-likelihood functions, generalized linear models, and the Gauss-Newton method

- TEI : `corpus\papers\tei\wedderburn1974_Quasi-likelihood or generalized linear models.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 92 | GENERALIZED LINEAR MODELS | We now derive a result which includes the result of Nelder & Wedderburn (1972) as a special case. Suppose that some function of the mean f (I) can be expressed in the form f (I) = EXAxi = Y, say, where the x's are known variables. Then in the notation of th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | ESTIMATION USING QUASI-LIKELIHOODS | This section discusses maximum quasi-likelihood estimates and shows that their precision may be estimated from the expected second derivatives of K in the same way as the precision of maximum likelihood estimates may be estimated from the expected second de... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | INTRODUCTION | This paper is mainly concerned with fitting regression models, linear or nonlinear, in which the variance of each observation is specified to be either equal to, or proportional to, some function of its expectation. If the form of distribution of the observ... |
| reject_generic | `GenericEstimatorFormulaCandidate` | 0 | GROBID raw formula | E@taj E@6 al8*al8j -F(z-A)21 aA aA E{ V(1t)}12J fl&fl since V(,ut) var (z). Also we have -E(8f 4 -E V()J#} -l ( V() m} V(#)Df il V(1 a alCb I al C6 1 altl alj which completes the proof. |

### REVISITING GUERRY'S DATA: INTRODUCING SPATIAL CONSTRAINTS IN MULTIVARIATE ANALYSIS

- DOI : `10.1214/10-AOAS356`
- TEI : `corpus\papers\tei\HistData_Guerry - Revisiting Guerrys data Introducing spatial constraints in multivariate analysis.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 93 | 2.3. | Toward an integration of multivariate and geographical aspects. The integration of multivariate and spatial information has a long history in ecology. The simplest approach considered a two-step procedure where the data are first summarized with multivariat... |
| review_for_dataset_use | `DataSourceCandidate` | 85 | Conclusions. | We have presented different ways of incorporating the spatial information in multivariate analysis methods. While PCA is not constrained, spatial information can be introduced as a partition (BCA), a polynomial of geographic coordinates (PCAIV-POLY), a subs... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Standard approaches. | We use the data set compiled by Michael Friendly and available at http://www.math.yorku.ca/SCS/Gallery/guerry/ . This data set has been recently analyzed by Dykes and Brunsdon (2007) to illustrate a new interactive visualization tool and is now distributed... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Application to Guerry's data. | Here we consider p = 6 variables measured for n = 85 observations (départements of France). As only quantitative variables have been recorded, principal component analysis [PCA, Hotelling (1933) ] is well adapted. Applying PCA to the correlation matrix wher... |
| low_priority_review | `DataSourceCandidate` | 61 | Spatial partition. | One alternative is to consider a spatial partition of the study area. In this case, the spatial information is coded as a categorical variable, and each category corresponds to a region of the whole study area. This partitioning can be inherent to the data... |
| low_priority_review | `DataSourceCandidate` | 61 | Trend surface of geographic coordinates. | From the EDA point of view, the data exploration has been conceptualized by Tukey (1977) in the quasi-mathematical form DATA = SMOOTH + ROUGH . Trend sur-Fig. 6 . Maps of the terms of a second-degree orthogonal polynomial. Centroids of départements have bee... |
| low_priority_review | `DataSourceCandidate` | 60 | Moran's coefficient. | Once the spatial weights have been defined, the spatial autocorrelation statistics can then be computed. Let us consider the n-by-1 vector x = [x 1 • • • x n ] T containing measurements of a quantitative variable for n spatial units. The usual formulation f... |
| low_priority_review | `DataSourceCandidate` | 49 | Introduction. | A recent study [Friendly (2007) ] revived André-Michel Guerry's (1833) Essai sur la Statistique Morale de la France. Guerry gathered data on crimes, suicide, literacy and other "moral statistics" for various départements (i.e., counties) in France. He provi... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Moran's eigenvector maps. | An alternative way to build spatial predictors is by the diagonalization of the spatial weighting matrix W. de Jong, Sprenger and van Veen (1984) have shown that the upper and lower bounds of MC for a given spatial weighting matrix W are equal to λ max (n/1... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Moran scatterplot. | If the spatial weighting matrix is row-standardized, we can define the lag vector z = Wz (i.e., zi = n j=1 w ij x j ) composed of the weighted (by the spatial weighting matrix) averages of the neighboring values. Equation (4) can then be rewritten as since... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Spatial explanatory variables. | Principal component analysis with respect to the instrumental variables [PCAIV, Rao (1964) ], also known as redundancy analysis [van den Wollenberg (1977) ], is a direct extension of PCA and multiple regression adapted to the case of multivariate response d... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Regional distribution of photovoltaic deployment in the UK and its determinants: A spatial econometric approach

- DOI : `10.1016/j.eneco.2015.08.003`
- TEI : `corpus\papers\tei\BaltaOzkan2015Regional.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Dependent variable: PV data | The data on PV deployment comes from the Central FIT Register, published by the Ofgem Eserve Database and includes FIT installations as of 30 June 2013. The database lists installed and declared capacities (kW) for different technology and installation type... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Literature Review | There has been a growing interest in examining the driving factors of PV installations. The process of adoption of new technologies is influenced by many factors, including geographic characteristics and peer effects (Bollinger and Gillingham, 2012; Snape a... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Data and Model Specification |  |
| review_for_dataset_use | `DataSourceCandidate` | 75 | Introduction | UK climate change and energy policy goals legislate an 80% emissions reduction target from 1990 levels by 2050 via the Climate Change Act (CCA, 2008) while ensuring security of supply and affordability. Additionally, the European directive 2009/28/EC impose... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 6 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Results | An OLS estimation was performed and the estimation results are reported in Table 7 where R 2 denotes the coefficient of determination and AIC is the Akaike Information Criterion. In order to check for the diagnostics of the model, Breusch-Pagan heteroscedas... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 81 | Model specification | In order to investigate the drivers of PV uptake across 134 regions, following on previous studies and within constraints on the available data, the following model has been employed 12 : (4) In equation ( 4 ) i denotes regions and u is an independently and... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Methodology | Elhorst (2010) proposes a general-to-specific approach to arrive at the most suitable econometric model. Equation ( 1 ) offers a family of related spatial econometric models: where Y is a (N x 1) vector of observations on a dependent variable and X is an (N... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | A C C E P T E D | M A N U S C R I P T SAR-type models. Corrado and Fingleton (2012) further argue that the coefficient estimate for the WY variable may be significant because it may be picking up the effects of omitted WX variables or nonlinearities in the WX variables if th... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | UK policy on photovoltaics | After years of slow progress, the UK has had a sudden rapid increase in deployment of solar PVs. According to the latest statistics, in 2013, over 2TWh of electricity was generated by solar PVs, compared to 20GWh in 2009 (DECC, 2014a) . This can be seen as... |

### Regulatory Convergence in the Financial Periphery: How Interdependence Shapes Regulators' Decisions

- DOI : `10.1093/isq/sqz068`
- TEI : `corpus\papers\tei\Jones2019Regulatory.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data and Methodology | To test our argument about the impact of interdependence and cross-border interactions on regulators' responses to Basel II, we estimate a series of spatial lag and spatial autoregressive models of Basel II adoption among countries outside the Basel Committ... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial Lag Variables | To analyze the effect of interdependence in the spread of Basel II to the financial periphery, we use a spatial lag model, in which the key explanatory variables are weighted observations of the dependent variable in other units. Spatial lags are calculated... |
| review_for_dataset_use | `DataSourceCandidate` | 75 | Data Description | Our data on Basel II adoption by countries outside of the Basel Committee cover one hundred jurisdictions. 13 The majority of the data (ca. eighty countries) come from the annual survey of non-members of the Basel Committee conducted by the Financial Stabil... |
| low_priority_review | `VariableTableCandidate` | 48 | GROBID table | Table 1 . |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Entire dataset 2005-2013 2008 cross-section 2013 cross-section Variables Mean Std. dev. N Mean Std. dev. Min. Max. N Mean Std. dev. Min. Max. N Dependent variable Basel II adoption 2.318 3.127 783 3.500 4.109 0 10 96 3.108 3.118 0 10 65 Spatial lags Spatial... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Robustness: Spatial Autoregressive Models | To test the robustness of our results, we estimate a series of spatial autoregressive models. While autoregressive models are often preferred to spatial-OLS models to avoid simultaneity bias, they require the sample of countries included in the connectivity... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Robustness: Alternate Measure of the Dependent Variable | In the main models reported in Tables 2 and 3 above, the dependent variable of the extent of Basel II adoption is measured using the sum of Basel II components adopted. While this is a straightforward measure, there might be a concern that the index is not... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Estimation Methodology | Our choice of estimation methodology is driven by our substantive interest in the behavior of countries outside of the Basel Committee and our theoretical expectation that regulation is shaped by interdependence. To evaluate the effect of interdependence, w... |

### Remote Sensing Image Analysis with R

- TEI : `corpus\papers\tei\Remote Sensing Image Analysis with R - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Principal component analysis | Multi-spectral data are sometimes transformed to helps to reduce the dimensionality and noise in the data. The principal components transform is a generic data reduction method that can be used to create a few uncorrelated bands from a larger set of correla... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Thresholding | We can apply basic rules to get an estimate of spatial extent of different Earth surface features. Note that NDVI values are standardized and ranges between -1 to +1. Higher values indicate more green cover. Cells with NDVI values greater than 0.4 are defin... |

### Remote sensing-based measurement of Living Environment Deprivation: Improving classical approaches with machine learning

- DOI : `10.1371/journal.pone.0176684`
- TEI : `corpus\papers\tei\Remote sensing-based measurement of leaving environment depravation.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Gradient Boost Regressor (GBR) | The second machine learning algorithm that is included is a Gradient Boost Regressor (GBR). Similar to the RF, it is an ensemble that combines the output of several models to produce a single prediction for the outcome variable. Boosting is a technique that... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model performance | Once we have a good idea of how the models produce predictions; what the variables are, and which approach contributes most to generating the estimates of the LED index, we turn to the question of how good these predictions are. Validation and performance a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | We describe the main results according to the following precepts: model interpretation, to cover the output of each of the models estimated; and model performance, to assess in detail the relative advantages of each approach in predicting the LED index. Bef... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial linear model | One way to improve the predictive performance of a linear model, while maintaining much of its interpretability, may be to extend it to accommodate spatial autocorrelation. In cases where the spatial nature of the data is relevant to the process being studi... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Remote sensing derived variables | We downloaded the most updated (up to February 2016) GE images of Liverpool city with enough zoom level to be similar to VHR imagery with sub-meter pixel size using a tool for automatic downloading of image tiles from the Google Satellite Map web service (... |
| review_for_dataset_use | `DataSourceCandidate` | 87 | Introduction | The use of remote sensing data to gather socioeconomic information is based on the premise that the physical appearance of a human settlement is a reflection of the society that created it and on the assumption that people living in urban areas with similar... |
| low_priority_review | `DataSourceCandidate` | 66 | Data | Our analysis is geographically focused on the British city of Liverpool. Liverpool is located in the North West of England (see Fig 1 ) and is among its ten largest cities. Its exact position varies depending on the city definition used. For example, if the... |
| low_priority_review | `DataSourceCandidate` | 61 | Land cover features | Land cover features describe the composition of the urban scene in terms of the amount of basic land cover types: vegetation, soil, gray impervious surfaces (asphalt and industrial roofing), orange impervious surfaces (clay tile roofs and similar), shadow a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Methods | The derived features are not particularly useful for explaining LED by themselves. They need to be combined into a single model that creates predictions based on existing estimates. Conceptually, this may be represented as: where f(Á) is a function that com... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Model interpretation | Interpretation of linear models is usually performed by examining the sign, size and significance of the estimated parameters. The main results for both the linear and spatial models are displayed in Table 4 . The models include the four extracted factors-f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Baseline linear model | Our first approach, which serves as a benchmark, is to assume a linear combination to approximate f(Á). Mathematically, this implies that Eq (1) becomes: where α, β, γ, δ and z are (vectors of) parameters and is an error term assumed to be i.i.d. following... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Conclusions | This paper explores the potential of two machine learning methods, GBR and RF, to predict the LED index in Liverpool (UK) using land cover, spectral, texture and structure variables extracted from a very high spatial resolution aerial image. We compare the... |

### SGWR: similarity and geographically weighted regression

- DOI : `10.1080/13658816.2024.2342319`
- TEI : `corpus\papers\tei\SGWR similarity and geographically weighted regression.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Beyond geographical distance | Waldo Tobler's First Law of Geography underscores the significance of spatial proximity in shaping relationships and interactions, thereby serving as a cornerstone in spatial analysis and geographical studies. Consequently, prior research primarily employed... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computational time | Computational time is a critical metric when evaluating the efficiency of regression models, particularly in cases involving large datasets or complex calculations. Efficient models that provide accurate results in less time are highly valuable in the data... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Experimental datasets | Five distinct datasets are used to evaluate the proposed model: housing prices, crime rates, and three health outcomes -focusing on mental health, depression prevalence, and HIV. The housing dataset pertains to King County, Washington, US, and it consists o... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Geographically weighted regression | Global regression models operate on the assumption that the relationships being analyzed through the parameters of the model are spatially invariant. GWR, however, provides a more elaborated approach by relaxing the spatial constancy assumption inherent in... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model interpretation | We particularly discuss the relationship between housing price and its relevant independent variables using two models among five datasets since it has been often used in the literature (Mathur 2013 , Gunasilan 2021) . The independent variables are bedrooms... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Performance of the models | The performance of the three models, namely GWR, ordinary least squares (OLS), and SGWR, were evaluated based on several statistical measures. Additionally, we briefly discussed the results of SGWR with MGWR model. The OLS model, serving as our baseline mod... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | The role of similarity weight matrix | Tables 2-6 delineate the impact of varying a values on the performance of the model across five different datasets -housing, crime, mental health, depression, and HIV dataset, respectively. An a value lower than 1 signifies an improvement, indicating the pr... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | Introduction | The geographically weighted regression (GWR) is a local regression method that enables the modeling of spatially varying relationships (Fotheringham et al. 1997 , Brunsdon et al. 2010) . It does this by allowing regression coefficients to vary over space ra... |
| review_for_dataset_use | `DataSourceCandidate` | 89 | Evaluating SGWR model against the enhanced GWR models | Our analysis reveals that while there are several extensions to the GWR model, such as incorporating non-Euclidean distances (Lu et al. 2014) and using geographically neural network weighted regression (Du et al. 2020) , these are often tailored to specific... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Residual values comparison | As visualized in Figure 5 (a), the OLS and GWR models exhibit a tall and narrow distribution, indicating a broad range of residuals. In contrast, the residual distribution is more tightly centered around zero with shorter tails in the SGWR model. A similar... |
| low_priority_review | `DataSourceCandidate` | 63 | Conclusion | GWR uses a localized approach to regression, where each observation is assessed in relation to its neighboring data points based on geographical proximity. In the proposed SGWR, we augment this approach by considering the similarity of data attributes in ad... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `truncated` |  |  | 7 autres candidats non affiches dans ce rapport |

### SPATIAL MACHINE-LEARNING MODEL DIAGNOSTICS: A MODEL-AGNOSTIC DISTANCE-BASED APPROACH A PREPRINT

- TEI : `corpus\papers\tei\Brenning_2023_SpatialMLDiagnostics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Case study description: the Meuse dataset | The Meuse dataset contains 155 observations of (logarithmic) topsoil zinc concentration (logZn in log-ppm) as the response variable, and several possible predictor variables. Zinc concentrations in this study area are related to the amount of contaminated s... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial variable importance profiles | Interpolation, regression, and hybrid models displayed a clear difference in the relative importance of sqrt.dist and elev compared to the x/y coordinates. Specifically, MLR, KED and GWR showed, on average, very similar, distanceinsensitive importance profi... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | Case Study 1: regionalization using ML and geostatistics | The first case study is a well-known dataset on topsoil heavy-metal concentration on a floodplain of the Meuse river in the Netherlands as included in the sp package in R (Pebesma and Bivand, 2005) . It is widely used to introduce geostatistical interpolati... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Case study description: the Maipo dataset | The dataset used is a well-documented case study consisting of 400 fields (7713 grid cells in total) with 4 different fruit-tree crops in central Chile (Peña and Brenning, 2015) . To simulate use cases with typical learning sample sizes, data from 100 field... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Case study 2: spatial classification | Crop classification using multispectral satellite image time series is a broad and important ML task in environmental remote sensing. Knowledge of SPEPs is important in order to assess the potential of classifiers to be applied in adjacent study regions. Th... |
| low_priority_review | `DataSourceCandidate` | 62 | Spatial leave-one-out for model assessment | In spatial prediction of categorical response variables (i.e., classification) and quantitative response variables (i.e., regression or regionalization), we use a model M to predict unobserved response values based on observed values of p predictor variable... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Computational versus theoretically motivated measures of spatial model performance | Theoretically derived measures of uncertainty such as kriging variances or prediction intervals of linear regression models provide a reliable uncertainty assessment when their model assumptions are satisfied. In the regionalization case study, computationa... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | Introduction | Machine-learning (ML) and hybrid geostatistical-ML models such as regression-kriging have become increasingly popular in spatial prediction modeling (for example, Hengl et al., 2015; Sekulić et al., 2020) . While parametric geostatistical techniques such as... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Spatial prediction error profiles | In the Meuse case study, the SPEPs revealed a strong dependence of performance on prediction distance for all methods, with some surprising similarities between (geo-)statistical and ML techniques (Figure 2 ). Overall, interpolation techniques that do not i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 67 | The role of autocorrelation and independence in spatial model assessment | It has previously been proposed to choose the buffer distance based on the range of residual autocorrelation (Brenning, 2005; Le Rest et al., 2014; Valavi et al., 2019) . Nevertheless, this starts from the intuition that test samples must be independent, al... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Prediction in entire area | Prediction distance GWR in the R implementation in package spgwr (Bivand and Yu, 2020) was used with an inner CV for optimizing the bandwidth parameter. A global bandwidth parameter instead of local ones was chosen to reduce the probability of overfitting.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Spatial prediction error profiles (SPEPs) | In order to visualize the average relationship between prediction error and distance, a spatial LOO error err (r) L (M ) needs to be estimated as a function of prediction distance. For this purpose, the recorded distances d (k) are binned. Within each of th... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### SPATIO-TEMPORAL MODELS WITH ERRORS IN COVARIATES: MAPPING OHIO LUNG CANCER MORTALITY

- TEI : `corpus\papers\tei\SPATIOTEMPORAL MODELS WITH ERRORS IN COVARIATES_OHIO LUNG CANCER DATA.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Description of covariates | It is well known that smoking is a very important risk factor for lung cancer. Other factors, such as gender, race, age, urban living and socio-economic status (SES), may also be involved. Gender, race and age information is available directly from our data... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model development | We start with the basic spatial model for the 1988 data only, and as such we suppress the subscript t for now. Since the data are lung cancer death counts by gender and race, an additive log-linear model with a Poisson likelihood is appropriate. We add the... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | We once again ran five independent chains using our Gibbs-Metropolis algorithm for 2200 iterations each; plots similar in appearance to Figure 1 suggested discarding the first 200 samples as an adequate burn-in period. Total computation time was about 50 mi... |
| review_for_dataset_use | `DataSourceCandidate` | 86 | INTRODUCTION | The issue of environmental justice (that is, the equitable distribution of exposures to and adverse outcomes from environmental hazards among various socio-demographic subgroups) is attracting increasing public attention. Through accurate assessment of envi... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | DISCUSSION | In this paper we have presented a spatio-temporal modelling framework that allows for (possibly spatially correlated) errors in the observed covariates. We have applied our methods to the smoothing of observed county-level lung cancer mortality rates over a... |
| low_priority_review | `DataSourceCandidate` | 64 | Description of data set | The Ohio lung cancer data set consists of C GHIR , the numbers of lung cancer deaths in county i for gender j and race k (white and non-white) during year t, and n GHIR , the corresponding population counts, where i"1, 2 , I, j"1, 2, k"1, 2 and t"1, 2 , ¹.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Results | Posterior estimates were calculated for the above model (1) and ( 3 )-(6). Recalling that the p G 's and q G 's are bounded between 0 and 1, we chose a fairly vague gamma(1, 100) prior for N and set O "0)01, allowing modest spatial correlation among the p G... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 80 | Introduction | The simple Poisson spatial model constructed in the last section incorporates spatial correlation through the prior distributions for estimating the underlying true log relative risk parameter GHI . In this way each estimate of GHI can 'borrow strength' fro... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Model statement | The study of the trend of risk for a given disease in space and time may provide important clues in exploring underlying causes of the disease and helping to develop environmental health policy. This can be done by constructing a Poisson log-linear spatio-t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | SPATIAL MODELLING WITH COVARIATES |  |
| review_for_model_evidence | `ModelEvidenceCandidate` | 58 | Results | Using the above model and prior structure, we ran our MCMC sampler for 2200 iterations, discarding the first 200 samples from each chain as preconvergence burn-in. Thus, we used a total of 10,000 samples to compute the posterior summaries. We discovered tha... |
| low_priority_review | `ModelEvidenceCandidate` | 53 | Model comparison | Caution should be taken in interpreting any kind of model, and naturally our hierarchical spatio-temporal models are no exception. With models as complex as ours, it is particularly important to investigate the sensitivity of any conclusions to changes in m... |

### Sampled Grid Pairwise Likelihood (SG-PL): An Efficient Approach for Spatial Regression on Large Data

- TEI : `corpus\papers\tei\Sampled Grid Pairwise Likelihood_homesales_datasets.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 98 | Background: Pairwise Likelihood for Spatial Regression | Pairwise Likelihood (PL) methods, as a class of composite likelihoods (Varin et al., 2011) , have gained attention for their ability to handle complex dependencies in large datasets where full likelihood estimation is intractable. The fundamental idea is to... |
| low_priority_review | `DataSourceCandidate` | 61 | SG-PL Algorithm | The SG-PL algorithm has several user-defined parameters that can influence its performance: • R H3 (H3 resolution): This determines the size of the hexagonal grid cells. Smaller cells (higher R H3 ) mean that pairs are sampled from more localized areas, pot... |
| low_priority_review | `DataSourceCandidate` | 60 | Introduction | The proliferation of geospatial technologies, including remote sensing, social media, Internet of Things (IoT) devices, and detailed administrative records, has led to an unprecedented availability of large spatial datasets. These datasets offer rich opport... |
| low_priority_review | `DataSourceCandidate` | 59 | Simulation Study | A Monte Carlo simulation study was conducted to assess the statistical accuracy and computational performance of the proposed SG-PL method. Its performance was compared against a standard benchmark, the Generalized Moments (GM) estimator for Spatial Error M... |

### Sex-specific spatial variation in fitness in the highly dimorphic Leucadendron rubrum

- DOI : `10.1111/mec.15833`
- TEI : `corpus\papers\tei\Sex-specific spatial variation in fitness in the highly dimorphic.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | / Dispersal occurred on a smaller spatial scale for seed than for pollen | For both pollen and seed dispersal kernels, our analysis revealed fat-tailed dispersal kernels (i.e., b s and b p < 1; Figure 2 and Table 1 ). Seed and pollen immigration rates were of the same order of magnitude (11% and 15% for seed and pollen respectivel... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | / Joint estimation of effective fecundities and both pollen and seed dispersal kernels | We used a method that uses information about the genotype and the spatial location of adults and seedlings to jointly estimate pollen and seed dispersal kernels and the individual male and female effective fecundities-a proxy for fitness (see Introduction).... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | / Study species and site | Leucadendron rubrum is a dioecious wind-pollinated shrub species endemic to the Western Cape of South Africa (Rebelo, 2001) where natural fires occur every 10-15 years (Kraaij et al., 2011; van Wilgen et al., 2010) . Leucadendron rubrum belongs to the famil... |
| low_priority_review | `DataSourceCandidate` | 69 | / Measurements of adult traits in the field | For adult shrubs, we measured in 2004 three traits describing plant architecture and three traits describing leaf morphology (available at https://doi.org/10.5061/dryad.ngf1v hhst ). All six traits are known to be sexually dimorphic in this species (Harris... |
| low_priority_review | `DataSourceCandidate` | 63 | / Microsatellite genotyping | We genotyped both adults and their progeny in our focal population (available at https://doi.org/10.5061/dryad.ngf1v hhst ). For both adults and seedlings, sampled leaves were preserved in silica gel prior to DNA extraction using a modified version of the C... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | / Multivariate sex-specific selection analysis | Inspired by the multivariate framework of Lande and Arnold (1983) , we examined in a single full model the relationship between the relative effective fecundity as the response variable and the following explanatory variables: canopy diameter, leaf area, pl... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 99 | / Novel methods for dealing with spatial bias affecting selection estimates in plants | Technical and methodological improvements in parentage assignations now allow for estimation of plant fitness in natural populations from genetic data, and provide the link between fitness and plant traits through selection gradients analyses (e.g., Burczyk... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | / INTRODUC TI ON | Plant species with separate sexes are relatively uncommon (i.e., 5-6%, Renner, 2014) . Separate sexes have nonetheless evolved repeatedly among flowering plants (Renner, 2014) , and such transitions have often given rise to the evolution of morphological di... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | / Sex differences in morphology, spatial distribution and analysis of number of cones | We tested for sex differences in morphology using linear mixedeffects models (LMMs) with spatially autocorrelated random effects. We analysed all measured adult traits describing either plant architecture or leaf morphology. Random individual effects can be... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | / Pollen and seed dispersal kernels typical of plant dispersal behaviour | Our spatially explicit method allowed the estimation of dispersal kernels, which revealed a fat-tailed seed dispersal kernel in the anemochorous L. rubrum. Most seeds dispersed close to the mother plant, but some fraction dispersed much further. Similarly,... |

### Short-Term Rental Platform in the Urban Tourism Context: A Geographically Weighted Regression (GWR) and a Multiscale GWR (MGWR) Approaches

- DOI : `10.1111/gean.12259`
- TEI : `corpus\papers\tei\Geographical Analysis - 2020 - Shabrina - Short‐Term Rental Platform in the Urban Tourism Context A Geographically.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Methodological contribution | This article has compared two local models (GWR and MGWR) against the global OLS model, to understand the fast-changing urban phenomenon of the short-term platform. Methodologically, the value of our article lies in the model specification and results that... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Statistical base-lining | In the first instance, it was necessary to ensure that the chosen parameters exhibit no strong correlation with one another. Thus, we calculate the variance inflation factor (VIF) that assesses how much variances increase if predictors are correlated. No co... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Traditional accommodation from the Ordnance Survey Points of Interest (POI) data 2018. | including guest houses, bed and breakfast, hostels, hotels, motels, country houses, inns, youth hostels, and other youth classifications. Fig. 2b shows the data across London. It illustrates the concentration of 1382 hotels distributed in only 644 LSOAs (13... |
| review_for_dataset_use | `VariableTableCandidate` | 80 | GROBID table | Table 5 . |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Model comparison and performance | Table 4 shows the comparison between the results of the implemented models, including the global model and two local models, through the models' goodness of fit. It shows that both local models have a significantly better fit than the global regression mode... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | The Geographically Weighted Regression and multiscale GWR (MGWR) | Simple linear regression, the most used technique in geographical analysis, assumes changes across space to be universal, which is not always the case in every spatial context. Variations across geographical space, known as spatial non-stationarity, might b... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Model interpretation | We have modeled the relationship between Airbnb and other elements of urban tourism using both GWR and MGWR models. For our dependent variable, the Airbnb density is examined We analyze this relationship individually, by comparing the GWR and MGWR results a... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Introduction | The travel and tourism industry is one of the most prominent sectors of the global economy, contributing nearly 10.2% of the world's GDP in 2016 and affecting more than 109 million jobs worldwide (World Travel and Tourism Council 2017) . Despite constantly... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 57 | The public transport accessibility index | Public transportation is an integral part of tourism, especially in an urban setting. In London, the highest proportion of the population (up to 46%) uses public transportation to commute, 35% relies on cars, 11% travels daily on foot, and 3.8% uses bicycle... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 55 | Results and discussion | As the global regression might suffer from the inefficiency of the parameter estimates due to the spatial autocorrelation of the residuals, we model our variables using local models: GWR and MGWR to capture the spatial heterogeneity in the local system. |

### Spatial Clustering Overview and Comparison: Accuracy, Sensitivity, and Computational Expense

- DOI : `10.1080/00045608.2014.958389`
- TEI : `corpus\papers\tei\Spatial Clustering Overview and Comparison_cincinnati.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Methods and Data | The performance of seven popular and widely applied spatial clustering methods is examined in this article. The formal mathematical details for each approach are given in Appendix A. As noted previously, although cluster detection methods are often structur... |
| low_priority_review | `DataSourceCandidate` | 69 | Downloaded by [University of Leeds] at 04:19 02 November 2014 | Scan-based approaches are appealing because in many ways they combine the best elements of exploratory and confirmatory spatial data analysis. In contrast to nonhierarchical and hierarchical clustering techniques, scan-based approaches tend to be more explo... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Background | A primary objective of cluster analysis is to assign objects (or events, incidents, enumeration districts, neighborhoods, subregions, etc.) to classes of significance. These classes are conceived to ultimately reflect some underlying structure or process as... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Section 1 | Cluster analysis continues to be an important exploratory technique in scientific inquiry. It is used widely in geography, public health, criminology, ecology, and many other fields. Spatial cluster detection is driven by geographic information correspondin... |

### Spatial Data Analysis with R

- TEI : `corpus\papers\tei\Spatial Data Analysis with R - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | By grid cell | An alternative approach would be to compute a model for grid cells. Let's use the 'Teale Albers' projection (often used when mapping the entire state of California). TA <-"+proj=aea +lat_1=34 +lat_2=40.5 +lat_0=0 +lon_0=-120 +x_0=0 +y_0=-4000000␣ ˓→+datum=W... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | California House Price Data | Now get the county boundaries and assign CRS of the houses data matches that of the counties (because they are both in longitude/latitude!). crs(hvect) <-crs(counties) Do a spatial query (points in polygon) cnty <-extract(counties, hvect) head(cnty) ## id.y... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | California precipitation | if (!require("rspat")) remotes::install_github('rspatial/rspat') ## Loading required package: rspat ## Loading required package: terra ## terra 1.7.62 DEATH VALLEY 36.47 -116.87 -59 7.4 9.5 7.5 3.4 1.7 1.0 3.7 ## 2 ID743 THERMAL/FAA AIRPORT 33.63 -116.17 -3... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Random Forest | CART gives us a nice result to look at that can be easily interpreted (as you just illustrated with your answer to Question 1). But the approach suffers from high variance (meaning that the model tends to be over-fit, it is different each time a somewhat di... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatial autocorrelation | The concept of spatial autocorrelation is an extension of temporal autocorrelation. It is a bit more complicated though. Time is one-dimensional, and only goes in one direction, ever forward. Spatial objects have (at least) two dimensions and complex shapes... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Scale and resolution | The term "scale" is tricky. In its narrow geographic sense, it is the the ratio of a distance on a (paper) map to the actual distance. So if a distance of 1 cm on map "A" represents 100 m in the real world, the map scale is 1/10,000 (1:10,000 or 10-4). If 1... |
| review_for_dataset_use | `DataSourceCandidate` | 82 | Get the data | if (!require("rspat")) remotes::install_github("rspatial/rspat") ## Loading required package: rspat ## Loading required package: terra ## terra 1.7.62 library(rspat) h <-spat_data('houses2000') I have selected some variables on on housing and population. Yo... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Spatial Data Analysis with R | Notice that there are six values, because the regression tree has six leaves. |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Spatial Data Analysis with R | The residualso appear to be autocorrelated. A formal test: Clearly, there is spatial autocorrelation. Our model cannot be trusted. so let's try SAR models. |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Regression | rp <-predict(wc, rrf, na.rm=TRUE) plot(rp) Note that the regression predictions are well-behaved, in the sense that they are between 0 and 1. However, they are continuous within that range, and if you wanted presence/absence, you would need a threshold. To... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Distance based measures | As we are using a planar coordinate system we can use the dist function to compute the distances between pairs of points. If we were using longitude/latitude we could compute distance via spherical trigonometry functions. These are available in the sp, rast... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Zonation | Geographic data are often aggregated by zones. While we would like to have data at the most granular level that is possible or meanigful (individuals, households, plots, sites), reality is that we often can only get data that is aggregated. Rather than havi... |
| low_priority_review | `truncated` |  |  | 5 autres candidats non affiches dans ce rapport |

### Spatial Data in R

- TEI : `corpus\papers\tei\Spatial Data in R - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 98 | Transforming raster data | Vector data can be transformed from lon/lat coordinates to planar and back without loss of precision. This is not the case with raster data. A raster consists of rectangular cells of the same size (in terms of the units of the CRS; their actual size may var... |
| review_for_dataset_use | `DataSourceCandidate` | 96 | Raster data | Raster data is commonly used to represent spatially continuous phenomena such as elevation. A raster divides the world into a grid of equally sized rectangles (referred to as cells or, in the context of satellite remote sensing, pixels) that all have one or... |
| review_for_dataset_use | `DataSourceCandidate` | 76 | Simple representation of spatial data | The basic data types in R are numbers, characters, logical (TRUE or FALSE) and factor values. Values of a single type can be combined in vectors and matrices, and variables of multiple types can be combined into a data.frame. We can represent (only very) ba... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Creating SpatRaster objects | A SpatRaster can easily be created from scratch using the function rast. The default settings will create a global raster data structure with a longitude/latitude coordinate reference system and 1 by 1 degree cells. You can change these settings by providin... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Modifying a SpatRaster object | There are several functions that deal with modifying the spatial extent of SpatRaster objects. The crop function lets you take a geographic subset of a larger raster object. You can crop a SpatRaster by providing an extent object or another spatial object f... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Reading raster data | Again we need to get a filename for an example file. f <-system.file("ex/logo.tif", package="terra") basename(f) ## [1] "logo.tif" Now we can do r <-rast(f) r ## class : SpatRaster ## dimensions : 77, 101, 3 (nrow, ncol, nlyr) ## resolution : 1, 1 (x, y) ##... |
| low_priority_review | `DataSourceCandidate` | 65 | Coordinate Reference Systems (CRS) 6.2.1 Angular coordinates | The earth has an irregular spheroid-like shape. The natural coordinate reference system for geographic data is longitude/latitude. This is an angular coordinate reference system. The latitude 𝜑 (phi) of a point is the angle between the equatorial plane and... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Raster algebra | Many generic functions that allow for simple and elegant raster algebra have been implemented for Raster objects, including the normal algebraic operators such as +, -, *, /, logical operators such as >, >=, <, ==, ! and functions like abs, round, ceiling,... |

### Spatial Panel Models of Crop Yield Response to Weather: Econometric Specification Strategies and Prediction Performance

- DOI : `10.1017/aae.2021.29`
- TEI : `corpus\papers\tei\div-class-title-spatial-panel-models-of-crop-yield-response-to-weather-econometric-specification-strategies-and-prediction-performance.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data and Spatial Weights Matrix | To implement a prediction performance comparison, we assemble county data to estimate the corn yield response function in the US. Because corn yields are heavily dependent on adequate rainfall or irrigation, we consider the US counties to the east of the 10... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Estimation Results and Prediction Performances | We estimate 14 different model specifications. First, we estimate the response coefficients using the balanced panel data . The estimation results for the models in Equations ( 3 )-( 10 ) are presented in Table 3 . The full estimation results are available... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Introduction | Because weather is a direct input to the biological process of plant growth, agriculture has been the focus of many studies of climate impacts on crop yield production. Two primary approaches to research on the relationship between weather/climate and agric... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Variables # of Obs. Mean Median S.D. Min. Max Corn yields by county, 1981-2012 (bu/ac) 33,344 115.3 116.0 33.5 0.0 236.6 Growing degree days (GDDs) for 8-32°C 33,344 149.9 151.0 12.0 92.5 180.7 Extreme growing degree days (GDDs) for 34°C or above 33,344 3.7... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | NonSpatial Panel Regression | A general crop yield response function specifying the relationships in Equation ( 1 ) can be presented as the panel regression equation: where g(⋅) is a nonlinear function of heat units, h it , with the response coefficients β, the second and third terms ar... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 84 | Conclusion and Discussion | Due to the enhanced accessibility and ability to manage weather, climate, and soil data, climate econometrics (Hsiang, 2016) has become one of the most widely used tools to forecast the impact of climate change on agriculture. In the literature, the Ricardi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Spatial Aggregation in Weather | For a better description of the following model specifications, we estimate the county-level crop yield response function with the Parameter-elevation Relationship on Independent Slopes Model (PRISM) weather data, which is high resolution (4 × 4 km) grid ce... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Spatial Correlation in Crop Yields | In the general crop yield response function of Equation ( 2 ), an essential assumption of the panel regression is that observed crop choices are optimal and do not change (Deschênes and Greenstone, 2007) . Since crop choice is the optimized decision under t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Specification of Heat Exposure Bins | As initiated in Schlenker and Roberts (2009) , nonlinear temperature impacts on crop yields are evident. Cooper et al. (2017) studied specification bias in crop yield response function and argued the necessity of a flexible function form. Carter et al. (201... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Spatial Correlation in Weather | It is widely noted that weather variables exhibit spatial correlation (Auffhammer et al., 2013; Dell et al., 2014) . The previous literature of the Ricardian approaches motivated the use of spatial lags on weather variables by their spatial correlation (Bay... |

### Spatial Statistics for Data Science

- DOI : `10.1007/s13253-023-00571-0`
- TEI : `corpus\papers\tei\Spatial Statistics for Data Science - Moraga.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Covariates | In our model, we use average temperature and precipitation as covariates. Monthly values of these variables globally can be obtained with the worldclim_global() function of geodata. library(geodata) covtemp <-worldclim_global(var = "tavg", res = 10, path =... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Cross-validation | We can assess the performance of each of the methods presented above using K-fold cross-validation and the root mean squared error (RMSE). First, we split the data in K parts. For each part, we use the remaining K -1 parts (training data) to fit the model a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data | The meuse data from the sp package contains zinc and other soil-heavy metal concentrations collected at locations in a flood plain of the river Meuse near Stein, The Netherlands (Figure 14 .1). meuse.grid contains prediction grid locations for the meuse dat... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Flexdashboard | The flexdashboard package (Sievert et al., 2022a) allows us to create dashboards in HTML format that contain several related data visualizations. Ex-amples of dashboards created with flexdashboard can be seen at the RStudio website 7 . Chapter 12 of Moraga... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Housing prices in Boston, Massachusetts, USA | The Boston housing prices are in the spData package (Bivand et al., 2022) , and can be obtained with the st_read() function of the sf package (Pebesma, 2022a) as follows. library(sf) library(spData) map <-st_read(system.file("shapes/boston_tracts.shp", pack... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model-based geostatistics | Model-based geostatistics can be used to analyze spatial data related to an underlying spatially continuous phenomenon that have been collected at a finite set of locations. Model-based geostatistics employs statistical models to capture the spatial correla... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Observed Solanum plant species in Bolivia | In this example, we estimate the intensity of Solanum plant species in Bolivia from January 2015 to December 2022 which are obtained from the Global Biodiversity Information Facility (GBIF) database with the spocc package. We retrieve the data using the occ... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Stack with data for estimation and prediction | We now create a stack with the data for estimation and prediction that organizes data, effects, and projection matrices. We create stacks for estimation (stk.e) and prediction (stk.p) using tag to identify the type of data, data with the list of data vector... |
| review_for_dataset_use | `DataSourceCandidate` | 84 | A.3 Packages for data visualization A.3.1 ggplot2 | The ggplot2 package (Wickham et al., 2022a) uses a grammar of graphics which defines the rules of structuring mathematic and aesthetic elements to build graphs layer-by-layer. To create a plot with ggplot2, we call ggplot() specifying the data frame with th... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | # Domain polygon is converted into a SpatialPolygons domain.polys <-Polygons(list(Polygon(loc.d)), '0') domainSP <-Sp... | # Because the mesh is larger than the study area, we need to # compute the intersection between each polygon # in the dual mesh and the study area library(rgeos) w <-sapply(1:length(dmesh), function(i) { if (gIntersects(dmesh[i, ], domainSP)) return(gArea(g... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Spatial neighborhood matrices | Areal or lattice data arise when a study region is partitioned into a finite number of areas at which outcomes are aggregated. Examples of areal data are the number of individuals with a certain disease in municipalities of a country, the number of road acc... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Cross-validation | The performance indices presented above can be computed using a new dataset or by splitting an existing dataset into a training dataset to fit the model and a testing dataset for validation. In cross-validation, the data is randomly split into several disjo... |
| low_priority_review | `truncated` |  |  | 26 autres candidats non affiches dans ce rapport |

### Spatial Structure of Above-Ground Biomass Limits Accuracy of Carbon Mapping in Rainforest but Large Scale Forest Inventories Can Help to Overcome

- DOI : `10.1371/journal.pone.0138456`
- TEI : `corpus\papers\tei\Guitet2015Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | A high local variability and a weak spatial structure led to large uncertainties in local biomass estimates | Variograms applied on the mixed datasets (Fig 3 ) showed high and significant semi-variance at the beginning of the curve (i.e. nugget of about 6,000 equivalent to a difference of about 110 Mg.ha -1 between neighbouring plots, located less than 500 m apart)... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Coarse-graining improved the accuracy of maps | The pan-tropical maps at their original resolution (i.e. 1km) were poorly correlated with the test dataset (RMSEP > 80, R² = 0.02 and slope 0.1) whereas the accuracy of our complete model (i.e. KR) was largely improved at this resolution (RMSEP = 63, R² = 0... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Statistical analyses | Statistical analyses followed three steps that are summarized in Fig 2 . In the first step we used all our data to produce variograms in order to examine the spatial structure of biomass and its consequences in terms of accuracy for interpolating from field... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Combining remote-sensing and large scale forest inventories can improve the accuracy of biomass maps | Our review of literature focusing on "biomass mapping in tropical forest", shows that RMSE hardly reach 75Mg.ha -1 in old-growth forests (i.e. a relative error of about 20%), for a 1-km resolution or less (Table 1 ). The performance obtained with our forest... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Materials and Methods |  |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Environmental data | For all plots, we extracted from GIS all environmental variables assumed to influence forest growth that were freely accessible on available maps (Table 2 ). For continuous variables, we computed the mean values over the plot area, while for categorical var... |
| low_priority_review | `DataSourceCandidate` | 69 | Field measurements | We used two different forest inventories produced by French public organizations (Fig 1 ). The first inventory was done by CTFT (Centre Technique Forestier Tropical) between 1974 and 1976 in the northern part of the French Guiana [36] . CTFT data were scann... |
| low_priority_review | `DataSourceCandidate` | 63 | Satisfactory accuracy can be achieve for REDD+ operational scales | The comparison of our test dataset and training dataset showed that forest inventories with a sampling rate of between 0.1 and 0.5% estimated biomass with an accuracy <10% for large blocks (>100 km²) and for a large majority of 10 to 50-km² sites (respectiv... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 1 . |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Reference a Context Data used for AGB Predictive variables used for Model measurement modelling Locality Cover Main Resolution Field plot Very Remote GIS space Allometry Predicted RMSE (ha) vegetation (ha) High sensing layers range (Mg.ha -1 ) types b Remot... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Theme Description of variables for selected plots |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### Spatial distribution of wood volume in Brazilian savannas

- DOI : `10.1590/0001-3765201920180666`
- TEI : `corpus\papers\tei\SILVEIRA2019Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | INTRODUCTION | The Brazilian Savanna biome, also known as Cerrado, occupies about 2.5 million square kilometres, which represents approximately 25% of the country's territory. This biome is among the most endangered eco-regions in the world due to high conversion rates an... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | STUDY AreA AND DATA COLLeCTION | This study was conducted in a Brazilian Savanna vegetation type, known as Cerrado Sensu Stricto, which falls within the state borders of Minas eDUArDA M.O. SILVeIrA et al. WOOD VOLUMe IN BrAZILIAN SAVANNAS An Acad Bras Cienc (2019) 91(4) e20180666 3 / 12 ge... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | WOOD VOLUMe MODeLLINg | All parameters used in our multivariate regression model had significant coefficients (Table II ) and the residuals were normally distributed (Shapiro-Wilk, p = 0.98), with a coefficient of determination (R²) of 0.55 and a mean absolute error (MAe) of 34.5%... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | WOOD VOLUMe MODeLLINg AND regreSSION KrIgINg | We used a stepwise regression technique based on the Akaike information criterion (AIC) to select the most significant independent variables to build the wood volume model. The total database was randomly divided into a fitting set (70% of the database) and... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | MATERIALS AND METHODS |  |
| low_priority_review | `DataSourceCandidate` | 61 | eXPLOrATOrY ANALYSIS | The statistics of the wood volume (m 3 ha -1 ) obtained from field-based forest inventory indicate that average (48.5 m 3 ha -1 ) and median (44.7 m 3 ha -1 ) values are close to one another, indicating a symmetry in the distribution of the wood volume data... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | SPATIAL DISTrIBUTION OF WOOD VOLUMe | Both the global map generated by the regression model (rMSe = 11.6 %) (Figure 6 ) and the map corrected by the regression kriging technique (Figure 7 ) revealed a decrease in the wood volume from the middle towards the northern portions of the state. This i... |

### Spatial prediction of soil properties using EBLUP with the Matérn covariance function

- DOI : `10.1016/j.geoderma.2007.04.028`
- TEI : `corpus\papers\tei\Spatial prediction of soil properties using EBLUP.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | BLUP | Best Linear Unbiased Prediction (BLUP) arises from a statistical theory (Robinson, 1991) , a full discussion on the theoretical aspects is given in Lark et al. (2006) . Following the main equations are introduced. The general linear spatial model for a rand... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Soil pH data in the Hunter Valley | Fig. 7 shows the trend model (Eq. ( 23 )) fitted to the soil pH data, using REMLthe parameters are: β 0 = 7.14, β 1 = -0.0002, β 2 = 0.31 (RMSD = 0.67). It illustrates the decrease in soil pH about 1 unit with distance of 4 km from west to east, and the inc... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | The Zn concentration along the Meuse River | First we determine parameters of the Matérn variogram of the data and residuals using the profile-likelihood method. Fig. 3a shows the log-likelihood contour as a function of r and ν for the data. The plot shows the optimum value of ν is around 1 with r val... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Introduction | Spatial prediction of soil properties has become a common topic in soil science research. This is enhanced by the advancement of technology that enabled collection of on-thego proximal sensors and also remotely-sensed imagery for use in precision agricultur... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | (1) Zn concentration along the Meuse River | This famous example comes from Burrough and McDonnell (1998) where topsoil zinc concentration along the river Meuse, the Netherlands was observed. This dataset shows a strong trend and it is expected to be a good application for BLUP. The data are obtained... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Methods of comparison | To see the benefit of the computation using more advanced and statistically sound BLUP, we compare it with methods conventionally used in pedometrics: (1) REML-EBLUP with the Matérn covariance function: define the trend function and design matrix M, estimat... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Topsoil clay content in the Edgeroi area | Using stepwise regression on the prediction set (200 observations), we obtained the following linear regression of top soil clay content as a function of Clay_Index (Landsat TM [Band#5/ Band#7]), Radiometrics K (K), elevation (Elev), and topographic wetness... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 78 | Discussion | Theoretically RK should not perform better than REML-EBLUP as it assumes an independent fixed model and the random effect. It has been shown that the estimation of variogram of the residuals may be biased by using RK especially at large lags, and the predic... |

### Spatial trends and projections of chronic malnutrition among children under 5 years of age in Ethiopia from 2011 to 2019: a geographically weighted regression analysis

- DOI : `10.1186/s41043-022-00309-7`
- TEI : `corpus\papers\tei\Seboka2022Spatial.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 4 |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 5 |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Variables: the proportion of poor wealth index, poor GWR sanitation, inadequate diet, rural residents, and undedicated mothers Residual squares 6.28 Effective number 23.17 Sigma 0.149 AIC Multiple R-squared -280.232 0.419 Adjusted R-squared 0.374 |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 6 |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables Coefficient Standard error t-statistic Probability Robust VIF probability Intercept 0.244 0.037 6.56 0.000 0.000 Proportion poor wealth index Proportion poor sanitation -0.542 0.001 0.1731 0.0002 -3.108 3.120 0.002 0.001 0.0124 0.000 1... |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Explanatory variables Mean STD Minimum Maximum Median Non- stationarity (p values) Proportion poor wealth index Proportion poor sanitation Proportion inadequate diet Proportion rural residents Proportion uneducated mothers -0.169 -0.131 0.066 0.243 0.338 0.... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Modeling spatial relationships | Using 2019 survey data, spatial regression modeling was used to investigate determinants of observed spatial patterns of stunting among children under the age of five. Spatial processes may operate at local or global scales. Accordingly, the OLS, GWR, and M... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Spatial regression analysis | Ordinary least square OLS model was employed to explore spatial regression assumptions and estimate variable coefficients of selected explanatory variables on under-five stunting. The OLS regression identified predictors of each hot spot of under-five stunt... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 86 | Introduction | Undernutrition is a severe global health problem, but it is particularly prevalent among children under the age of five in Sub-Saharan Africa (SSA) [1] [2] [3] [4] . Height-forage or more commonly, stunting, is a measure of linear growth, and children whose... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 75 | Performance comparison of the global and local spatial regression models | The OLS, GWR, and MGWR models were used to investigate the relationships between under-five stunting and its predictors. To begin, global spatial regression models were used to investigate geographical predictors of stunting in children under the age of fiv... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Factors affecting the spatial variation of childhood stunting | Regarding spatial predictors of stunting among under-five children in Ethiopia, GWR output produced predicted under-five stunting maps of geographic areas where mothers' education, household sanitation, household wealth index, residence, and diet were stron... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Variables of the study | The study outcome, stunting, was defined as a height-forage that was less than 2 SD of the median height-for-age, according to WHO international growth criteria (i.e., HAZ < -2) [1, 5] . We employed sampling weights and a stratified sample design to constru... |
| low_priority_review | `truncated` |  |  | 2 autres candidats non affiches dans ce rapport |

### Spatially varying coefficient modeling for large datasets: Eliminating N from spatial regressions

- DOI : `10.1016/j.spasta.2019.02.003`
- TEI : `corpus\papers\tei\SVC_Murakami.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | An empirical study | As an illustration, GWR and M-SVC the Tokyo railway station (Tokyo_d) [km], share of green area in 1km grids (Green), and anticipated flooding depth (Flood) [m] . We include distance-based covariates (Station_d and Tokyo_d), which can confound with SVCs and... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Modeling | The cost for the eigen-decomposition of (I -11 ′ /N)C(I -11 ′ /N) is O(N 3 ), which is intractable for large N. Besides, if C is given using a distance-decay function like in our case, the N × N matrix must be stored before the decomposition. The modeling i... |
| low_priority_review | `DataSourceCandidate` | 69 | Simulation with large samples (5000 ≤ N ≤ 100,000) 5.2.1. Simulation settings | This section compares estimation accuracy and computational time for M-SVC (iii) , which was found to be accurate and relatively fast when N is small, with those for GWR using large samples. FB-GWR is not compared because it is computationally too expensive... |
| low_priority_review | `DataSourceCandidate` | 60 | Simulation settings | Synthetic data {y, x 1 , . . . where β k is generated with the following spatial moving average specification: where C is the row-standardize version of a proximity matrix whose (i, j)th element equals exp(- The spatial coordinates are drawn from two indepe... |
| low_priority_review | `DataSourceCandidate` | 56 | Introduction | Spatial and spatiotemporal data are increasing in size. For example, remotely sensed land cover, weather, and other information are provided as high-resolution images, which consist of a massive number of cells/samples (e.g., Griffith, 2015) . Socio-economi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Model | This approach is based on the Moran coefficient (MC; Moran, 1950) , which is a diagnostic statistic of spatial dependence. MC for y = [y (s 1 ) , . . . , y(s N )] ′ is formulated as: where C is a symmetric spatial proximity matrix with zero diagonal entries... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Summary | Our approach is summarized in Fig. 1 . In the modeling step, we apply (i) a rank reduction, and each SVC is expressed as a linear combination of L approximate eigenvectors Ê (N × L). In the estimation step, we first apply (ii) a pre-compression, and the SVC... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 75 | Future directions | While large spatial data modeling is a recent hot topic, related discussions are quite limited when it comes to SVC modeling. Given this background, this study develops a fast M-SVC approach that estimates multiscale SVCs. We achieve the computational effic... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Result ( N ≤ 12,000) | This section compares M-SVC (iii) to GWR assuming N ∈ {6000, 9000, 12,000} and K ∈ {2, 4, 6, 8}. Fig. 8 portrays the mean bias for the large-scale SVCs (left) and the small-scale SVCs (right). This result shows that the biases are quite small irrespective o... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Estimation | The likelihood maximization can be very slow because it includes 2K shrinkage parameters in Θ ∈ {θ 1 , . . . , θ K }, where θ k ∈ {τ k , α k }, that do not have closed form solutions. For example, if 10 SVCs are assumed, 20 shrinkage parameters must be esti... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Fast evaluation of the term including | Then, as derived in Appendix, Eq. ( 19 ), including the inversion P -1 , can be expressed as follows: where 19 ), ( 21 ) does not include the inversion of a large matrix including θ K , which we want to estimate. Eq. ( 21 ) still has Q -1 , whose complexity... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Parameter estimation | The M-SVC model is estimated by the Type II restricted likelihood (empirical Bayes) method This restricted likelihood has an analytic expression if p (y, u 1 , . . . u K /b, Θ) and p(u 1 , . . . , u K ) are Gaussians probability density functions. Using thi... |

### Spatio-Temporal Graph Convolutional Networks: A Deep Learning Framework for Traffic Forecasting

- TEI : `corpus\papers\tei\2026-04-23_paper_stgcn_traffic_forecasting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 79 | Data Preprocessing | The standard time interval in two datasets is set to 5 minutes. Thus, every node of the road graph contains 288 data points per day. The linear interpolation method is used to fill missing values after data cleaning. In addition, data input are normalized b... |
| low_priority_review | `DataSourceCandidate` | 69 | Benefits of Spatial Topology | Previous methods did not incorporate spatial topology and modeled the time series in a coarse-grained way. Differently, through modeling spatial topology of the sensors, our model STGCN has achieved a significant improvement on short and mid-and-long term f... |
| low_priority_review | `DataSourceCandidate` | 62 | Experiment Results | Table 1 and 2 demonstrate the results of STGCN and baselines on the datasets BJER4 and PeMSD7(M/L). Our proposed model achieves the best performance with statistical significance (two-tailed T-test, α = 0.01, P < 0.01) in all three evaluation metrics. We ca... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Experimental Settings | All experiments are compiled and tested on a Linux cluster (CPU: Intel(R) Xeon(R) CPU E5-2620 v4 @ 2.10GHz, GPU: NVIDIA GeForce GTX 1080). In order to eliminate atypical traffic, only workday traffic data are adopted in our experiment [Li et al., 2015] . We... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Chebyshev Polynomials Approximation | To localize the filter and reduce the number of parameters, the kernel Θ can be restricted to a polynomial of Λ as Θ(Λ) = K-1 k=0 θ k Λ k , where θ ∈ R K is a vector of polynomial coefficients. K is the kernel size of graph convolution, which determines the... |

### Spatio-Temporal Interpolation using gstat

- DOI : `10.18637/jss.v063.i15.`
- TEI : `corpus\papers\tei\Graler_2016_gstat_spatiotemporal_RJournal.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | The collection and processing of spatio-temporal data is rapidly increasing due to technological advances and the societal need for analysis of variables that vary in space and time, such as weather and air quality variables, and crop yields. Analysis of sp... |
| review_for_dataset_use | `DataSourceCandidate` | 97 | Application and illustration | The data set used is taken from AirBase foot_1 , the air quality data base for Europe provided by the European Environmental Agency (EEA). We focus on a single air quality indicator, particulate matter with a diameter less than 10 µm, measured at rural back... |
| review_for_dataset_use | `DataSourceCandidate` | 77 | Results and discussion | In terms of added value of spatio-temporal kriging measured in cross-validation results, Table 3 shows hardly any benefit in the illustrative example. This effect can to a large degree already be explained from the spatio-temporal variograms: a temporal lag... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 98 | Covariance models | The covariance models implemented in gstat and presented in this paper are introduced in the following. Besides further extensions we focus on the basic classes of the separable, product-sum, metric and sum-metric spatio-temporal covariance functions. The b... |

### Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer

- DOI : `10.1007/s10640-021-00536-2`
- TEI : `corpus\papers\tei\Schutt2021Systematic.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Choice of the Meta-Analytic Model | Multivariate meta-analytic models including moderating variables have become a standard framework to help explain the very likely presence of heterogeneity in effect sizes in applied economic research (Stanley and Doucouliagos 2012; Ringquist 2013 ). 13 Acc... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | The world's annual generation of waste equalled two billion tonnes in 2016 and is expected to reach 3.4 billion tonnes by 2050 (Kaza et al. 2018) . This poses serious threats to the environment in general and may generate externalities for residents living... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Previous Reviews and Meta-Analyses | The first reviews in this area (Farber 1998; Zeiss 1998; Boyle and Kiel 2001; Jackson 2001 ; also Brinkley and Leach 2019) were qualitative and aimed to identify moderators explaining the apparent heterogeneity of waste site-related property-price effects (... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Subsample Analysis | Several moderators are not included in the baseline regression shown in column (1) due to missing observations or because these moderators only serve as replacements for explanatory variables already included. In a first step, I add these moderators to the... |
| review_for_dataset_use | `DataSourceCandidate` | 98 | Selection of Studies | The strategy employed for identifying relevant studies followed the MEAR-Net guidelines 6 for conducting and reporting meta-analyses (Stanley et al. 2013) and involved three steps. First, seven search engines suitable for the complexity of a predefined sear... |
| review_for_dataset_use | `DataSourceCandidate` | 96 | Heterogeneity of Effect Size | The meta-regression results are reported in Table 4 . Column (1) shows the baseline WLS-RE PEESE model. Selection of this specification follows the results of a Q-test rejecting the null hypothesis of no heterogeneity at the estimate level and a subsequent... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Methodology | Whereas the mere number of explanatory variables does not seem to be an important factor, some moderators reflecting the comprehensiveness or quality of the econometric specification do significantly affect the reported effect size. 29 First, not controllin... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Methodology | The choice of the appropriate meta-analytic model is a point of ongoing discussion in the literature (Nelson and Kennedy 2009; Stanley and Doucouliagos 2012; Ringquist 2013) . The core of the debate revolves around the best identification of, and correction... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Site Characteristics | As expected, studies with multiple sites in the proximity of residential properties report higher effect sizes on average. In other words, multiple waste sites affect residential property values more adversely than single sites. By contrast, there seem to b... |
| low_priority_review | `DataSourceCandidate` | 64 | Data Characteristics | The data characteristics reveal that on average studies working with larger samples tend to report smaller estimates. By contrast, studies based on sales data collected at individual house level do not differ significantly from studies using assessed values... |
| low_priority_review | `DataSourceCandidate` | 58 | Validity and Reliability Requirements | BTs use existing effect-size estimates from one or more previous studies to infer the effect size for a new policy application (Boyle et al. 2013) . In principle, BT based on MRA is a form of function transfer, as the meta-equation can be calibrated to fit... |
| review_for_dataset_use | `VariableTableCandidate` | 78 | GROBID table | Table 4 ( |
| low_priority_review | `truncated` |  |  | 7 autres candidats non affiches dans ce rapport |

### The Effect of Weather Conditions on Fertilizer Applications: A Spatial Dynamic Panel Data Analysis

- DOI : `10.1023/A:1018789623581`
- TEI : `corpus\papers\tei\2026-04-23_paper_bille_rogna_weather_fertilizer_spatial_dynamic_panel.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Data description | In this Section we briefly introduce a description of the data used in our empirical analysis. The dependent variable is the amount of fertilizer applied on a given portion of agricultural land. Relying on data related to quantities at national level would... |
| review_for_dataset_use | `DataSourceCandidate` | 82 | Conclusions | The present paper analyse the relation between abnormal weather conditions and fertilizer applications at world level, by considering four macro-regions -Europe (CAP), South America, South-East Asia and Africa -and using a recent dataset of gridded data whi... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Data Interpolation | We found several missing values over time in both the price of agricultural outputs (PAO) and the price of fertilizer (PF), especially for the latter one. To avoid the elimination of a large number of cells as well as to allow for the inclusion of these rel... |
| low_priority_review | `DataSourceCandidate` | 48 | Stability and First-differencing | To ensure stable spatio-temporal processes the condition ρ + φ + γ < 1 must be satisfied. During a preliminary estimation procedure of equation ( 1 ), we found the above condition to be numerically satisfied for the 4 macro-regions. However, all the four su... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Controlling for Spatial Error Correlations | Although the model in equation ( 1 ), or equivalently (2), is considered quite general in its form, in this paper we also allow for the possibility of the error terms to be spatially correlated. Several statistical hypothesis testing that check for the pres... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Yeo-Johnson Power Transformation and Robustness Checks | In this Section we briefly report the main results of some robustness checks of our model specification in equation ( 2 ), i.e. the estimation results are almost the same in terms of both the sign and the magnitude for the majority of the regressors conside... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 87 | Results and Discussion | In this Section we report and discuss our main estimation results and the potential policy implications derived from them. For the estimation results, we used the function spml in the R package splm (Millo et al., 2012) . Alternatively, Stata command xsmle... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Model Specification | In this Section we provide details on the model specification to study the effect of extreme weather conditions on the use of fertilizers in Europe, South America, South-East Asia and Africa. More in general we try to specify the most appropriate and flexib... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | Discussions on Spatial Error Correlations and Fertilizer Prices | In this Section we propose to re-estimate the model in equation ( 2 ), by controlling for spatial error autocorrelations to improve estimation efficiency and by including fertilizer (Urea) prices, since their omission could bias the estimates. Additionally,... |

### The False Dilemma: Bayesian vs. Frequentist * 1

- TEI : `corpus\papers\tei\2026-04-23_paper_inla_approximate_bayesian_inference_latent_gaussian.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 69 | Ethical values: | we can find an appeal to ethical values as parts of arguments about both schools. Wilson (2003) affirms that Bayesian methods are a more ethical approach to clinical trials and other problems. On the contrary, Fisher (1996) affirms that "Ethical difficultie... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Metaphysical values: | by their writings, we can extract some information about scientist's thoughts. Knowledge is framed by feelings, emotions, facts and, even, faiths. How to consider, then, classical and continuous disputes among the full range of possible positions between re... |

### The GWmodel R package: Further Topics for Exploring Spatial Heterogeneity using Geographically Weighted Models

- TEI : `corpus\papers\tei\Lu_2014_GWmodel_further_topics.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | GW summary statistics | Although simple to calculate and map, GW summary statistics can act as a vital precursor to an application of a subsequent GW model. For example, GW standard deviations will highlight areas of high variability for a given variable; areas where a subsequent... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Monte Carlo tests for regression coefficient non-stationarity | For a mixed GW regression, difficulties arise when deciding whether a relationship should be fixed globally or allowed to vary locally. Here Fotheringham et al. (32) adopt a stepwise procedure, where all possible combinations of global and locally-varying r... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | US 2004 election data | The USelect data is only used in section 6, for demonstrating a GW DA. It consists of the results of the 2004 US presidential election at the county level ( 3111 = n ), together with a collection of socio-economic (census) variables (27) . A variant of this... |
| review_for_dataset_use | `DataSourceCandidate` | 88 | Dublin 2004 voter turnout data | The DubVoter data is the main study data set and is used throughout sections 3 to 5 and section 7. This data is composed of nine percentage variables foot_0 322 = n , measuring: (A) voter turnout in the Irish 2004 Dáil elections and (B) eight characteristic... |
| low_priority_review | `DataSourceCandidate` | 52 | Introduction | In this study, we present a collection of local (non-stationary) statistical models, termed geographically weighted (GW) models (1) . A GW model suits situations when spatial data are poorly described by the global (stationary) model form, and for some regi... |
| low_priority_review | `DataSourceCandidate` | 45 | R > library(GWmodel) R > library(RColorBrewer) R > data(DubVoter) | R > gwss.1 <-gwss(Dub.voter,vars = c("GenEl2004", "LARent", "Unempl"), kernel="bisquare", adaptive=TRUE, bw=48) R > gwss.mc <-montecarlo.gwss(Dub.voter,vars = c("GenEl2004", "LARent", "Unempl"), kernel="bisquare", adaptive=TRUE, bw=48) R > gwss.mc.data <-da... |
| review_for_dataset_use | `VariableTableCandidate` | 79 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Examples: PCA to GW PCA | For applications of PCA and GW PCA, we investigate these eight variables: DiffAdd, LARent, SC1, Unempl, LowEduc, Age18_24, Age25_44 and Age45_64. We standardise the data and specify the PCA with the covariance matrix. The same (globally) standardised data i... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | GW discriminant analysis | The theoretical context for DA is briefly described. Suppose a population, of which each object belongs to k possible categories; and a training set X , where each row vector 𝒙 𝒊 indicates an observation belonging to category l (𝑙 ∈ {1, ⋯ , 𝑘}); then for an... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 72 | Basic and mixed GW regression | The basic form of the GW regression model is 0 1 where i y is the dependent variable at location i; ik x is the value of the kth independent variable at location i; m is the number of independent variables; 0 i β is the intercept parameter at location i; ik... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Heteroskedastic GW regression | Basic GW regression assumes that the error term is normally distributed with zero mean and constant (stationary) variance over the study region (𝜀 𝑖 ~𝑁(0, 𝜎 2 )). An extension of GW regression is possible, which allows a non-stationary error variance ( 𝜀 𝑖... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Local collinearity diagnostics for a basic GW regression | The problem of collinearity amongst the predictor variables of a regression model has long been acknowledged and can lead to a loss of precision and power in the coefficient estimates (42) . This issue is heightened in GW regression since: (A) its effects c... |
| low_priority_review | `truncated` |  |  | 1 autres candidats non affiches dans ce rapport |

### The Practical Use of Semiparametric Models in Field Trials

- DOI : `10.1198/1085711031265`
- TEI : `corpus\papers\tei\Semiparametric models in field trials.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Model Selection Criteria | If the graph of residuals against a covariate suggests that a smooth function of the covariate be included in the model, it is necessary to select a span for the smoother by minimizing a suitable criterion. Four such criteria are: cross-validation (CV) (Sto... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | ADDITIVE AND SEMIPARAMETRIC MODELS | Additive models (Hastie and Tibshirani 1986, 1990 ) are a generalization of linear regression models. Let •(:) be the expected value of the response, Y = (Y 1 ; : : : ; Y n ), corresponding to explanatory variables X = (X 1 ; : : : ; X q ). In a linear mode... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 84 | INTRODUCTION | There is a large statistical methodology on experimental designs and analyses to account for spatial trends in experiments such as agricultural or forestry trials. Sophisticated designs, for example alpha designs and row-column designs, are frequently used... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 77 | OTHER SPATIAL MODELS | In Sections 5.1.2 and 5.2.2 we compared the semiparametric spatial analysis with a loess smoother with conventional analysis of variance. In this section we look at another parametric approach to modeling the spatial variation in variety trials. Gilmour et... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 68 | Semiparametric Modeling | The spatial trend in the yields from Trial A may be modeled as either a two-dimensional trend E(Y rb ) = • + ½ j + lo(r; b) where Y rb is the yield of the plot in row r and bed b, which is planted with cultivar j; j = 1; : : : ; 272, and lo(r; b) represents... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Analysis of Trial B | The standard analysis of variance model for a split-plot experiment is a simple example of a mixed model so the Gilmour et al. (1997) model is able to maintain the error strata of the split-plot while modeling the spatial variation. We tted three models wit... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Approximate and Bootstrap F Tests | If a decrease in the span is associated with an apparently small change in the criteria, then a natural question is whether the change is statistically signi cant. Cleveland and Devlin (1988) and Hastie and Tibshirani (1987, 1990 ) discussed approximate F t... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | TRIAL B 5.3.1 Semiparametric Modeling | The semiparametric analysis of Trial B is complicated by the split-plot design. The spatial models discussed earlier assume a single error term. It is possible to ignore the split-plot design, t a semiparametric model to the yields from the subplots, and te... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | DISCUSSION | Unexpected trends in eld trials, if overlooked, can affect estimates of treatment effects or reduce the precision of estimation, particularly in experiments with many treatments and low replication, such as early stage variety trials. We have presented grap... |
| low_priority_review | `ModelEvidenceCandidate` | 45 | GRAPHICAL METHODS | An initial check for the presence of a trend is to calculate the residuals from a model with all treatment effects and interactions, but no block effects or other spatial terms, and plot them against position in the eld, as a function of row number or bed n... |

### The Wald Test of Common Factors in Spatial Model Specification Search Strategies

- DOI : `10.1017/pan.2020.23`
- TEI : `corpus\papers\tei\Juhl2020Wald.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| low_priority_review | `DataSourceCandidate` | 64 | . Analytical Derivation and Asymptotic Distribution of the Wald Statistic | Consider a situation in which a test needs to be constructed in order to evaluate a single nonlinear restriction H 0 : g (λ) = 0, where λ is a parameter vector and g (•) is some function that is continuously differentiable in a neighborhood of λ. For this g... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Substantive and Residual Dependence in Cross-Sectional Models | In regression analyses utilizing cross-sectional data, three different types of interaction effects can be distinguished that generate spatial autocorrelation in the dependent variable. First, endogenous interaction effects occur whenever the units' outcome... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | . An Illustrative Example of the Different Spatial Processes | Before outlining the alternative spatial model specifications, it is useful to contrast the different spatial processes with respect to their substantive implications for empirical political science research. Spillover effects occur whenever the behavior (e... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 71 | Empirical Example: Spatial Contagion Effects in Economic Voting | An empirical example helps to demonstrate the consequences of the problem for applied research aiming to evaluate the empirical evidence for a theorized mechanism while ruling out alternative mechanisms. To this end, I reanalyze a study conducted by William... |

### The terra package

- TEI : `corpus\papers\tei\The terra package - Hijmans.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 71 | CHAPTER THREE CREATING SPATRASTER OBJECTS | A SpatRaster can easily be created from scratch using the function rast. The default settings will create a global raster data structure with a longitude/latitude coordinate reference system and 1 by 1 degree cells. You can change these settings by providin... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Modifying a SpatRaster object | There are several methods that deal with modifying the spatial extent of SpatRaster objects. The crop method lets you take a geographic subset of a larger terra object. You can crop a SpatRaster by providing an extent object or another spatial object from w... |
| low_priority_review | `DataSourceCandidate` | 69 | Summarize | When used with a SpatRaster object as first argument, normal summary statistics functions such as min, max and mean return a SpatRaster. You can use global if, instead, you want to obtain a summary for all cells of a single SpatRaster object. You can use fr... |

### Top-down scale approaches for multiscale GWR with locally adaptive bandwidths

- DOI : `10.1007/s10109-025-00481-4`
- TEI : `corpus\papers\tei\atds_mgwr_ghislain_geniaux.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computational efficiency of our algorithms | Our Algorithm 2 (tds_mgwr) algorithm has a computational complexity of O(4k dn 2 ). At each iteration, a maximum of four GWR estimations is required, while the ordered bandwidth sequence ensures that the total number of univariate GWR computations (4k d) re... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computational efficiency of our algorithms | Our Algorithm 2 (tds_mgwr) algorithm has a computational complexity of O(4k dn 2 ). At each iteration, a maximum of four GWR estimations is required, while the ordered bandwidth sequence ensures that the total number of univariate GWR computations (4k d) re... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computational issues | The MGWR algorithm proposed by FYK2017 has a computational complexity of O(kdn 2 log(n)), where k is the number of covariates, d is the number of backfitting iterations, and log(n) arises from the golden-section search used to determine the optimal bandwidt... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Computational issues | The MGWR algorithm proposed by FYK2017 has a computational complexity of O(kdn 2 log(n)), where k is the number of covariates, d is the number of backfitting iterations, and log(n) arises from the golden-section search used to determine the optimal bandwidt... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | Spatially varying coefficient models are extensively employed across various application domains, especially in cases where it is crucial to account for spatial heterogeneity within coefficient models. These domains include house markets, land use, populati... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | Spatially varying coefficient models are extensively employed across various application domains, especially in cases where it is crucial to account for spatial heterogeneity within coefficient models. These domains include house markets, land use, populati... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Prediction methods for multiscale GWR-type models | For the GWR, out-of-sample predictions can be made either through extrapolation procedures of the estimated coefficients or by re-estimating the optimized model on the training data, using the training data while selecting the locations of the observations... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Prediction methods for multiscale GWR-type models | For the GWR, out-of-sample predictions can be made either through extrapolation procedures of the estimated coefficients or by re-estimating the optimized model on the training data, using the training data while selecting the locations of the observations... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Simulation results comparing top-down scale GWR with standard GWR in a univariate setting | To illustrate the properties of the top-down scale approach for univariate GWR, we will examine four prototypical spatial patterns for a single covariate: flat spatial pattern, concentric spatial pattern, evolving spatial pattern, and dual spatial pattern.... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Simulation results comparing top-down scale GWR with standard GWR in a univariate setting | To illustrate the properties of the top-down scale approach for univariate GWR, we will examine four prototypical spatial patterns for a single covariate: flat spatial pattern, concentric spatial pattern, evolving spatial pattern, and dual spatial pattern.... |
| review_for_dataset_use | `DataSourceCandidate` | 90 | Computational Efficiency assessment | While theoretical computational complexity offers an estimate of the expected computation time, a practical comparison of these algorithms' performance remains essential. Table 6 offers an initial assessment of computational efficiency across estimators usi... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Monte Carlo design | In this section, we will employ three simulated DGPs to illustrate the properties of the proposed estimation algorithms. We will rely on two DGPs inspired by previously used in the literature for multiscale Geographically Weighted Regression, namely the DGP... |
| low_priority_review | `truncated` |  |  | 19 autres candidats non affiches dans ce rapport |

### Understanding Airbnb spatial distribution in a southern European city: The case of Barcelona

- DOI : `10.1016/j.apgeog.2019.102136`
- TEI : `corpus\papers\tei\lagonigro2020_Understanding Airbnb spatial distribution in a southern European city The case of barcelona.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Results | In the previous section, Fig. 2 presents the map of the ratio of Airbnb 1 We consider as the city center, the centroid of the census tract corresponding to Plaça Catalunya, the main square in Barcelona, and its surrounding areas. locations over the total ho... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Study area, data and methodology | The city of Barcelona is located on the north east coast of Spain. It has an extension of 102.16 km 2 and a population of 1,620,343 inhabitants distributed in 73 neighborhoods in 10 districts (Fig. 1 ). It comprises 4.7 km of linear beach extension, with 7... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Discussion | The spatial analysis of socioeconomic variables at global scales can mask geographical variations on the factors describing the phenomenon being observed. Some recent studies have analyzed the Airbnb phenomenon, uncovering complicated local patterns of part... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | Conclusions | This study provides insight on the spatial distribution of the Airbnb accommodations in the city of Barcelona, mainly in the old city and surrounding areas. Some social and economic urban liberal plans in the city of Barcelona, have successively transformed... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 2 |
| review_for_model_evidence | `ModelEvidenceCandidate` | 60 | Literature review | Airbnb, a company founded in San Francisco in 2008, emerged as the most successful platform in the field of accommodation connecting hosts and tourists around the world. Airbnb proposed a new business model centered on cost-savings, household amenities, and... |

### Using Geographically Weighted Regression to Explore Local Crime Patterns

- DOI : `10.1177/0894439307298925`
- TEI : `corpus\papers\tei\cahill2007_Using Geographically Weighted Regression to Explore Local Crime Patterns.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Crime Data and Structural Measures | Violent crime data (including homicide, sexual assault, robbery, and aggravated assault) were collected from the Portland Bureau of Police for the years 1998 to 2002. The location and date of each reported crime was collected, and those data were geocoded a... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | GWR Clusters | The exploratory utility of GWR parameters can be extended by clustering together locations with similar parameter values for all variables (i.e., where whole models of violence are similar). This synthesizes the often huge amount of output created by the GW... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Section 1 | E cological studies of crime have long demonstrated the tendency of criminal events to cluster in space. The search for ecological covariates of crime has been aided in recent decades by the development of multivariate statistical techniques and guided by e... |
| low_priority_review | `VariableTableCandidate` | 48 | GROBID table | Table 1 Descriptive Statistics for Violence and Structural Measures |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | A Global Model of Violence in Portland | A multivariate model was developed to estimate average levels of violence in Portland during the 1998 to 2002 period. The model was developed at the block group level using OLS regression. The model is considered to be global as one parameter is estimated f... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | GWR | One of the problems with estimating global regression models for spatial data is that variations over space that might exist in the data are suppressed. In the example given above, the relationship between a violence measure and violence predictors is assum... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 76 | Crime and Communities Perspective | Ecological research is founded on the idea that understanding the characteristics of places-including physical and social measures-that affect the number of targets and offenders in an area is necessary to an understanding of the causes of crime. Theoretica... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 56 | Conclusion | Generally, the results support the application of GWR in this context as the results provided insight into the spatial patterns of parameter relationships. The GWR modeling exercise thus demonstrated the efficacy of this method for descriptive purposes-for... |
| low_priority_review | `ModelEvidenceCandidate` | 52 | A Local Model of Violence in Portland | In the context of the present study, the application of GWR is warranted for several reasons. The OLS model, although promising, left more than 60% of the variance in the violence measure unexplained. Furthermore, one parameter estimate (ICE) had a counteri... |
| low_priority_review | `ModelEvidenceCandidate` | 48 | Discussion | The application of GWR to a model of violence rates and its comparison to an OLS base model has yielded several striking results. Theoretically, the OLS model, although not as robust as hoped, did provide support for the criminal opportunity theory. Five of... |

### WFDE5: bias-adjusted ERA5 reanalysis data for impact studies

- DOI : `10.5194/hess-22-3515-2018`
- TEI : `corpus\papers\tei\2026-04-23_paper_eobs_daily_gridded_observations_essd_2020.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | The development, calibration, and evaluation of impact models require good-quality historical meteorological datasets. These are needed to both drive the impact models themselves and characterize their performances over the historical period. The availabili... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Validation with a global hydrological model | Of great importance for driving impact models such as global hydrological models is the climate forcing input, since the water balance components are highly dependent on it (Müller Schmied et al., 2016) . In order to test WFDE5 in terms of suitability for u... |
| review_for_dataset_use | `DataSourceCandidate` | 99 | Comparison with FLUXNET2015 and WFDEI | The FLUXNET2015 (FN2015) meteorological data (Chu, 2015; Pastorello et al., 2017) are not included in the data assimilation of the ERA5 reanalysis. Therefore, these data provide an opportunity to assess the degree to which the ERA5 and WFDE5 meteorological... |
| review_for_dataset_use | `DataSourceCandidate` | 86 | Extraction and aggregation of reanalysis data | ERA5 reanalysis data are available in the CDS on regular latitude-longitude grids at 0.25 • × 0.25 • , as a result of finite-element-based linear interpolation from the original reduced Gaussian grid at ∼ 0.28 • , and atmospheric parameters are distributed... |
| review_for_dataset_use | `DataSourceCandidate` | 77 | Dataset Processing | All computations were carried out within the CDS Toolbox, a python coding environment to retrieve, process, plot, and download data from the C3S Climate Data Store (CDS, C3S, 2020a). The CDS Toolbox scripts used to generate the dataset are publicly availabl... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Conclusions | The WFDE5 dataset will be useful for forcing surface models and especially for near-recent hydrological and agricultural analyses. It will also be used for bias correction of the CMIP6 GCM model output in the third phase of ISIMIP. WFDE5 benefits from the i... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 1 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 4 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Dataset Summary Location ERA5 ECMWF reanalysis product https://cds.climate.copernicus.eu/cdsapp#!/home (last access: 26 August 2020) CRU TS4.03 Climate Research Unit gridded station http://data.ceda.ac.uk/badc/cru/data/cru_ts/cru_ts_4.03 observations (multi... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Dataset attribute Details Horizontal coverage Global Horizontal resolution 0.5 • × 0.5 • Vertical coverage Surface Temporal coverage -1 January 1979 00:00:00 to 31 December 2018 23:00:00 for variables Wind, Tair, PSurf and Qair -1 January 1979 07:00:00 to 3... |

### XGBoost: A Scalable Tree Boosting System

- TEI : `corpus\papers\tei\2026-04-23_paper_xgboost_scalable_tree_boosting.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 93 | INTRODUCTION | Machine learning and data-driven approaches are becoming very important in many areas. Smart spam classifiers protect our email by learning from massive amounts of spam data and user feedback; advertising systems learn to match the right ads with the right... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Regularized Learning Objective | For a given data set with n examples and m features D = {(xi, yi)} (/D/ = n, xi ∈ R m , yi ∈ R), a tree ensemble model (shown in Fig. 1 ) uses K additive functions to predict the output. where F = {f (x) = w q(x) }(q : R m → T, w ∈ R T ) is the space of reg... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Approximate Algorithm | The exact greedy algorithm is very powerful since it enumerates over all possible splitting points greedily. However, it is impossible to efficiently do so when the data does not fit entirely into memory. Same problem also arises in the dis- tributed settin... |
| review_for_dataset_use | `DataSourceCandidate` | 71 | Column Block for Parallel Learning | The most time consuming part of tree learning is to get the data into sorted order. In order to reduce the cost of sorting, we propose to store the data in in-memory units, which we called block. Data in each block is stored in the compressed column (CSC) f... |
| low_priority_review | `DataSourceCandidate` | 69 | Sparsity-aware Split Finding | In many real-world problems, it is quite common for the input x to be sparse. There are multiple possible causes for sparsity: 1) presence of missing values in the data; 2) frequent zero entries in the statistics; and, 3) artifacts of feature engineering su... |

### Yield Response Surfaces, Isoquants, and Economic Fertilizer Optima for Coastal Bermudagrass'

- TEI : `corpus\papers\tei\welch1963.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 81 | Response Surfaces | Yield response surfaces, prepared from the yields predicted by the 195 5-57 NPK-omitted multiple regression equation, are shown in Figures 1 , 2 , and 3. These response surfaces in Figures IA, 1B, 2A, 2B, 3A, and 3B show the effect on yield of varying 2 fer... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 74 | Section 1 | torial experiment with Coastal bermudagrass on Cecil soil are used to obtain a yield equation by multiple regression. T h e yield equation is then used in calculations for response surfaces, isoquants, and economic fertilizer optima. T H E agronomic-economi... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 66 | Multiple Regression Analysis | Yearly yield data were used to calculate multiple regression equations for each of the years 1955, 1956, and 1957 . Also, equations based on the average 3-year yields were calculated for 1955-57 with and without the N P K term included. The form of the quad... |

### on the interpretability of predictors in spatial data science: the information horizon

- DOI : `10.1038/s41598-020-73773-y`
- TEI : `corpus\papers\tei\Behrens_ViscarraRossel_2020_InformationHorizon.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Reference models. | The benchmark model to test structural dependence used Gaussian mixed scaling (GMS) 15 of relevant terrain attributes. Gaussian mixed scaling is an approach to decompose scales of numerical environmental predictors and specifically terrain attributes. It is... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Reference models and prediction accuracy. | The prediction accuracies of the different models are presented in Fig. 7 . Figure 8 shows the corresponding maps. 0.0 0.4 0.8 Rsq GMS GMS restricted EDF GMS restricted + EDF GRF 100 GRF 10 Rhine-Hesse Piracicaba Meuse Figure 7. Modelling cross-validation a... |
| review_for_dataset_use | `DataSourceCandidate` | 81 | Section 1 | Vol:.(1234567890) Scientific RepoRtS / (2020) 10:16737 / https://doi.org/10.1038/s41598-020-73773-y www.nature.com/scientificreports/ In spatial modelling with machine learning, using a sufficient number of meaningless (or structurally independent) predicto... |
| review_for_dataset_use | `DataSourceCandidate` | 79 | Beyond the information horizon-descriptive uncertainty and contextual complexity. | We recently showed that when finer to coarser scales are successively removed from a set of all scales of a GMS modelling, prediction accuracy usually remains high, even if only the coarsest scales remain in the model 4 . In cases where the prediction accur... |
| review_for_dataset_use | `DataSourceCandidate` | 76 | Study sites. | The description of the study sites is reproduced form Behrens et al. 4 . Figure 1 shows the sample locations draped over the corresponding digital elevation models (DEM). The Meuse dataset consists of 155 samples of the River Meuse floodplain in the Netherl... |
| low_priority_review | `DataSourceCandidate` | 60 | Variography. | To calculate the range of spatial dependence of a soil property, we derived spherical variograms using the gstat package 13 in R 12 . The spherical model has the most interpretable values for nugget, sill and range, as it does not approach the sill asymptot... |

### paper:doi:10.1080/24694452.2017.1352480

- DOI : `10.1080/24694452.2017.1352480`
- TEI : `corpus\papers\tei\fotheringham2017_Wenbai Yang, and Wei Kang.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Multiscale Geographically Weighted Regression (MGWR) | A. Stewart Fotheringham,* Wenbai Yang, y and Wei Kang* *School of Geographical Sciences & Urban Planning, Arizona State University y School of Geography & Geosciences, University of St. Andrews Scale is a fundamental geographic concept, and a substantial li... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Optimal Bandwidth Vector | Figure 4 shows the resulting bandwidths from the calibration of a GWR model and an equivalent MGWR model on the 100 simulated data sets for Design Process 1. In Figure 4 , b Ã is the single optimal 1 , and b Ã 2 are the optimal bandwidths for each of the th... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | S | cale is a fundamental geographic concept and is the focus of a huge and diverse literature that discusses the various roles that scale plays in different geographical contexts (e.g., Harvey 1968; Moellering and Tobler 1972; Brenner 2001; Tate and Atkinson 2... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Simulation Design 1 | This simulated data set is used to examine the relative performances of GWR and MGWR when the DGP is such that the local parameter surfaces exhibit varying degrees of spatial heterogeneity. Specifically, the DGP is We designed three different parameter surf... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Goodness of Fit | Figure 8 displays the values of the RSS for the OLS, GWR, and MGWR models using each of the 100 simulated data sets. Also included are the values of the noise introduced into each data set ( P e 2 i ). It is clear that OLS is a relatively poor model to appl... |
| review_for_dataset_use | `DataSourceCandidate` | 74 | Initialization and Convergence Criteria | To compare the relative performances of GWR and MGWR we first established viable values for the stopping criterion (SOC-f) and the starting values of the local parameter estimates in the MGWR routine. Table 1 presents typical evidence from across the 100 ca... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Simulation Design | To demonstrate the performance of MGWR and to compare it with GWR, several questions need to be addressed: 1. Does MGWR produce reliable estimates of scale through the independent bandwidths for each covariate and how do these compare to the single optimize... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Simulation Design 1 | We now describe the results of calibrating the model in Equation ( 11 ) by OLS, GWR, and MGWR using the 100 random data sets resulting from applying the DGP described in Simulation Design 1 where the parameter surfaces have unequal degrees of spatial hetero... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Simulation Design 2 | We now describe the results of calibrating the model by OLS, GWR, and MGWR using the 100 random data sets resulting from applying the DGP described in Simulation Design 2 where the parameter surfaces have equal spatial heterogeneity. We again use SOC-f 10 ¡... |
| low_priority_review | `DataSourceCandidate` | 49 | Evaluation Methods | Several evaluation methods were employed to address the questions listed earlier regarding the relative performance of both MGWR and GWR using the data sets drawn from both simulation designs. |
| low_priority_review | `DataSourceCandidate` | 46 | Optimal Bandwidth Vector | Figure 11 displays the single optimal bandwidth for GWR and the two separate optimal bandwidths generated by MGWR for each of the 100 simulated data sets produced from Simulated Design 2. In this case, because the two parameter surfaces have the same degree... |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Table 3 . |
| low_priority_review | `truncated` |  |  | 10 autres candidats non affiches dans ce rapport |

### paper:tei:2026_04_23_paper_random_forest_breiman_2001_tei

- TEI : `corpus\papers\tei\2026-04-23_paper_random_forest_breiman_2001.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Empirical Results on Strength and Correlation | The purpose of this section is to look at the effect of strength and correlation on the generalization error. Another aspect that we wanted to get more understanding of was the lack of sensitivity in the generalization error to the group size F. To conduct... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Outline of Paper | Section 2 gives some theoretical background for random forests. Use of the Strong Law of Large Numbers shows that they always converge so that overfitting is not a problem. We give a simplified and extended version of the Amit and Geman [1997] analysis to s... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Random Forests Using Linear Combinations of Inputs | If there are only a few inputs, say M, taking F an appreciable fraction of M might lead an increase in strength but higher correlation. Another approach consists of defining more features by taking random linear combinations of a number of the input variabl... |
| review_for_dataset_use | `DataSourceCandidate` | 76 | Empirical Results in Regression | In regression forests we use random feature selection on top of bagging. Therefore, we can use the monitoring provided by out-of-bag estimation to give estimates of PE*(forest), PE*(tree) and ρ . These are derived similarly to the estimates in classificatio... |
| low_priority_review | `DataSourceCandidate` | 69 | Categorical Variables | Some or all of the input variables may be categoricals and since we want to define additive combinations of variables, we need to define how categoricals will be treated so they can be combined with numerical variables. My approach is that each time a categ... |
| low_priority_review | `DataSourceCandidate` | 68 | Conjecture: Adaboost is a Random Forest | Various classifiers can be modified to use both a training set and a set of weights on the training set. Consider the following random forest: a large collection of K different sets of non-negative sum-one weights on the training set is defined. Denote thes... |
| low_priority_review | `DataSourceCandidate` | 58 | 4.Random Forests Using Random Input Selection | The simplest random forest with random features is formed by selecting at random, at each node, a small group of input variables to split on. Grow the tree using CART methodology to maximum size and do not prune. Denote this procedure by Forest-RI. The size... |
| low_priority_review | `DataSourceCandidate` | 58 | Exploring the Random Forest Mechanism | A forest of trees is impenetrable as far as simple interpretations of its mechanism go. In some applications, analysis of medical experiments for example, it is critical to understand the interaction of variables that is providing the predictive accuracy. A... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Using Out-Of-Bag Estimates to Monitor Error, Strength, and Correlation | In my experiments with random forests, bagging is used in tandem with random feature selection. Each new training set is drawn, with replacement, from the original training set. Then a tree is grown on the new training set using random feature selection. Th... |

### paper:tei:geocomputation_with_r_tei

- TEI : `corpus\papers\tei\Geocomputation-with-R.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | (R)SAGA | The System for Automated Geoscientific Analyses (SAGA; Table 9 .1) provides the possibility to execute SAGA modules via the command line interface (saga_cmd.exe under Windows and just saga_cmd under Linux) (see the SAGA wiki on modules foot_77 ). In additio... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Conventional modeling approach in R | Before introducing the mlr package, an umbrella-package providing a unified interface to dozens of learning algorithms ( ), it is worth taking Section 11.5 a look at the conventional modeling interface in R. This introduction to supervised statistical learn... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Exercises | 1. Read the script 10-centroid-alg.R in the code folder of the book's GitHub repo. •Which of the best practices covered in does it Section 10.2 follow? •Create a version of the script on your computer in an IDE such as RStudio (preferably by typing-out the... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Generalized linear model | To implement a GLM in mlr, we must create a task containing the landslide data. Since the response is binary (two-category variable), we create a classification task with makeClassifTask() (for regression tasks, use makeRegrTask(), see ?makeRegrTask for oth... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Local operations | Local operations comprise all cell-by-cell operations in one or several layers. A good example is the classification of intervals of numeric values into groups such as grouping a digital elevation model into low (class 1), middle (class 2) and high elevatio... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | The raster package offers nine data types when saving a raster: LOG1S, INT1S, INT1U, INT2S, INT2U, INT4S, INT4U, FLT4... | . 23 The data type determines the bit representation of the raster object written to disk (Table 7 .4). Which data type to use depends on the range of the values of your raster object. The more values a data type can represent, the larger the file will get... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | mlr building blocks | The code in this section largely follows the steps we have introduced in Section 11.5.2. The only differences are the following: 1. The response variable is numeric, hence a regression task will replace the classification task of . Section 11.5.2 2. Instead... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Conclusions | Resampling methods are an important part of a data scientist's toolbox ( ). This chapter used cross-validation to assess predictive James et al., 2013 performance of various models. As described in observations Section 11.4, with spatial coordinates may not... |
| review_for_dataset_use | `DataSourceCandidate` | 95 | Map algebra | Map algebra makes raster processing really fast. This is because raster datasets only implicitly store coordinates. To derive the coordinate of a specific cell, we have to calculate it using its matrix position and the raster resolution and origin. For the... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | Conclusions | In this chapter we have ordinated the community matrix of the lomas Mt. Mongón with the help of a NMDS ( ). The first axis, representing Section 14.3 the main floristic gradient in the study area, was modeled as a function of environmental predictors which... |
| review_for_dataset_use | `DataSourceCandidate` | 91 | Introduction | This chapter will provide brief explanations of the fundamental geographic data models: vector and raster. We will introduce the theory behind each data model and the disciplines in which they predominate, before demonstrating their implementation in R. The... |
| review_for_dataset_use | `DataSourceCandidate` | 80 | Geometric operations on raster data | Geometric raster operations include the shift, flipping, mirroring, scaling, rotation or warping of images. These operations are necessary for a variety of applications including georeferencing, used to allow images to be overlaid on an accurate map with a... |
| low_priority_review | `truncated` |  |  | 47 autres candidats non affiches dans ce rapport |

### paper:tei:gwr4manual_409_tei

- TEI : `corpus\papers\tei\GWR4manual_409.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Local terms Global terms | Main features (1) Semiparametric GWR As noted above, a most remarkable feature of this release is the function to fit semiparametric GWR models, which allow you to mix globally fixed terms and locally varying terms of explanatory variables simultaneously. T... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Step 1: The Data Tab | Data preparation < What fields do I have to prepare in my dataset? > To calibrate a GWR model, you must prepare a tabular dataset that contains fields of dependent and independent variables, and x-y coordinates. Every variable should consist of numeric valu... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Step 2: The Model Tab | If the data file you specified on the "Data" tab page is successfully opened, field names will appear in the "Variable (Field) list" list box in the middle of the "Model" tab page. If there is no field name or the listings in the list box are insufficient,... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Step 3: The Kernel Tab | (1) < kernel function type >: Choose one of the four available options for geographical kernel weighting. (2) < bandwidth selection method >: Choose one of the three available options for bandwidth size selection. A larger bandwidth will estimate geographic... |
| low_priority_review | `DataSourceCandidate` | 61 | Coordinate Min Max Range ------------------------------------------------------------ | -coord 635964.300000 1059706.000000 423741.700000 Y-coord 3401148.000000 3872640.000000 471492.000000 Diagnostic information Residual sum of squares: 1648.136749 Effective number of parameters (model: trace(S)): 28.690376 Effective number of parameters (var... |
| low_priority_review | `DataSourceCandidate` | 61 | The "Prediction at non-regression points" option | When this box is checked, you can provide a list of x-y coordinates for estimating local geographical coefficients and local goodness-of-fit indicators. This can be used for displaying a gridded surface of geographically varying coefficients or diagnosis of... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Geographical variability test | < What is this test? > Geographical variability for each varying coefficient is tested by model comparison. For testing the geographical variability of the kth varying coefficient, a model comparison is carried out between the fitted GWR and a model in whic... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Geographically weighted Poisson regression (GWPR) | A GWPR model and its semiparametric variant are shown as The dependent variable should be an integer that is greater than or equal to zero. i N is the offset variable at the ith location. This term is often the size of the population at risk or the expected... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Local terms | Global terms < Example of semiparametric Gaussian GWR > The following equation is an example of a semiparametric Gaussian GWR model using the Georgia sample data with the following specifications: 01 23 12 PctBatch ( , ) ( , )PctRural ( , )PctPov ( , )PctBl... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | LtoG / GtoL variable selection. | Like the geographical variability test, for each term in the "Local" list box the LtoG variable selection routine conducts a series of model comparison tests between the originally fitted model and a model in which a varying term has been changed to a fixed... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Selection criteria | In the golden section and interval searches, the optimal bandwidth size is determined by means of comparison of model selection indicators with different bandwidth sizes. The criterion is also used for several modelling options described previously. < AICc... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Standardisation | If this option is checked, all of the independent variables are standardised by z-transformation so that each variable has zero mean and one standard deviation. It is useful for interpreting estimated coefficients under the same metric. In some cases, stand... |
| low_priority_review | `truncated` |  |  | 7 autres candidats non affiches dans ce rapport |

### paper:tei:inference_for_lattice_models_1993_tei

- TEI : `corpus\papers\tei\inference-for-lattice-models-1993.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | 1(h) = j). (k(h), 1(h)) is the grid node nearest county h. | minimizing L*( ), q is the number of large-scale parameters fitted, and Xi(at) is the upper 100(1 -a)% point of the chi-squared distribution on 1 degree of freedom. For η = 99, q = 1, k = 1, and a = 0.05, the 95% confidence interval becomes {φ: L*($) < L*($... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Auto-Gaussian Model | For reasons given in the previous section, the confirmatory analysis of the SIDS data will be based on the auto-Gaussian (or CG) model (Section 6.6) of Freeman-Tukey transformed counts (7.6.1). The logistic transformation was not used because it has small-s... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | l f Exploratory Spatial Data Analysis | A summary of the findings of Section 6.2, for the 1974-1978 SIDS data, follows. 1. It is concluded that the Freeman-Tukey (square-root) transformation Z, = (1000(5^ )/«,) 1/2 + (1000(5, + I)/«,)' 72 (7.6.1) is a variance-controlling transformation; that is,... |
| review_for_dataset_use | `DataSourceCandidate` | 98 | Gaussian Maximum Likelihood Estimation | Under the assumption Ζ ~ GAU^, Σ), the negative loglikelihood ΖΛη) is given by Ζ,(η) = (/i/2)log(2ir) + (l/2)log( /X/) + (l/2)(z -μ)^" 1 ^ -μ). (7.2.18) where the parameter η is made up of functions of the mean vector μ and the variance matrix X. The m.l. e... |
| review_for_dataset_use | `DataSourceCandidate` | 96 | Bootstrapping Dependent Data | The bootstrap paradigm involves resampling (groups of) observations rather than deleting them. When D is divided into congruent subregions D X ,...,D K , Hall (1985a) has suggested two types of resampling. One is to assign the data Z* to the region D k , k... |
| review_for_dataset_use | `DataSourceCandidate` | 96 | Semiparametric Bootstrap | If one is willing to make parametric or semiparametric assumptions about the large-and small-scale variation in the data, it is sometimes possible to write the stochastic model in terms of i.i.d. components that can be estimated and then resampled (Freedman... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Hypothesis Testing for Spatial Dependence in a Linear Regression Model | Suppose the data follow a linear model Ζ = Χβ + δ, where δ is a zero-mean conditionally specified Gaussian (CG) process such that δ ~ Gau(0 where Η is a known symmetric η Χ η matrix and γ is the spatial-dependence parameter. A statistic for testing H 0 : y... |
| review_for_dataset_use | `DataSourceCandidate` | 93 | Modeling Large-Scale Variation | Consider the auto-Gaussian model (6.3.11), where the Freeman-Tukey transformed SID rate Z, [given by (7.6.1)] plays the role of the Z(s,) and s, = (*,, y,y are the coordinates of the ith county seat. Then, from (6.6.4), Ζ ~ Gau^, (/ -C) l M). (7.6.13) The f... |
| review_for_dataset_use | `DataSourceCandidate` | 78 | REGIONAL MAPPING: SCOTLAND LIP-CANCER DATA | The first part of this section is based on a resistant method of regional mapping presented in Cressie and Guo (1987) , and the second part on a parametric (Bayesian) spatial analysis presented in Clayton and Kaldor (1987) ; both are applied to lip-cancer i... |
| review_for_dataset_use | `DataSourceCandidate` | 70 | Transforming the Data | Now try to model the data by fitting additive row and column effects: A t = a + r kU) + c m + <5,•, k(i) e {1,..., 10}, l(i) e {1,..., 7}, (7.5.3) where the ith district is located at grid node (k(i), Hi)), a is the overall mean, r k is the fcth row effect... |
| low_priority_review | `DataSourceCandidate` | 68 | Regularization | Instability due to ill-conditioned matrices Η may be reduced by some form of regularization, such as smoothing or shrinking the least-squares estimator θ 0 . Let θ^ be an ultrasmooth estimator for θ; may be of uniform intensity [i.e., 0j(s) = k, for all s e... |
| low_priority_review | `DataSourceCandidate` | 63 | Cross-Validation and Model Selection | The conditionally specified models are in a very convenient form for crossvalidation. Suppose the observation Z(s,) is deleted from the data set and predicted using the other observations [Z(sj): j Φ i). Depending on the loss function specified for predicti... |
| low_priority_review | `truncated` |  |  | 17 autres candidats non affiches dans ce rapport |

### spacetime: Spatio-Temporal Data in R

- TEI : `corpus\papers\tei\Pebesma_2012_spacetime_JSS.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 81 | Classes and methods for spatio-temporal data | The different layouts, or types, of spatio-temporal data discussed in Section 3 have been implemented in the spacetime R package, along with methods for import, export, coercion, selection, and visualisation. |
| review_for_dataset_use | `DataSourceCandidate` | 79 | R> xs1 | coordinates X2010.08.05.10.00.00 X2010.08.05.11.00.00 point1 (0, 0) 9.66 9.64 point2 (0, 1) 21.20 19.50 point3 (1, 1) 29.90 32.10 X2010.08.05.12.00.00 X2010.08.05.13.00.00 point1 8.98 11.4 point2 19.60 19.8 point3 30.20 29.8 as time values are difficult to... |
| review_for_dataset_use | `DataSourceCandidate` | 73 | Discussion | Handling and analyzing spatio-temporal data is often complicated by the size and complexity of these data. Also, data may come in many different forms, they may be time-rich, space-rich, and come as sets of space-time points or as trajectories. Building on... |
| review_for_dataset_use | `DataSourceCandidate` | 72 | Panel data | The panel data discussed in Section 2 are imported as a full spatio-temporal data.frame (STFDF), and linked to the proper state polygons of maps. We can obtain the states polygons from package map (Brownrigg and Minka 2012) by: R> library("maps") R> states.... |

### spmoran (ver. 0.2.0): An R package for Moran eigenvector-based scalable spatial additive mixed modeling

- TEI : `corpus\papers\tei\spmoran_package_Murakami.tei.xml`

| Action | Type | Score | Section/table | Extrait candidat |
|---|---|---:|---|---|
| review_for_dataset_use | `DataSourceCandidate` | 100 | Introduction | This package provides functions estimating Moran eigenvector-based scalable spatial additive mixed models and related spatial models. In concrete, this package implements standard spatial regression models and extensions, including spatially and non-spatial... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Reference | Croissant, Y., and Millo, G. (2008) Panel data econometrics in R: The plm package. Journal of statistical software, 27(2), 1-43. -Donegan, C., Chun, Y., Hughes, A.E. (2020) Bayesian estimation of spatial filters with Moran's eigenvectors and hierarchical sh... |
| review_for_dataset_use | `DataSourceCandidate` | 100 | Spatially and non-spatially varying coefficient models 2.3.1. Varying coefficient modeling | Effects from covariates can vary depending on covariate value. For example, distance to railway station might have strong impact if the distance is small while weak if the distance is large. To capture such effect, the resf function estimates coefficients v... |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Table 2 : |
| review_for_dataset_use | `VariableTableCandidate` | 77 | GROBID table | Covariates Coefficients Select SVC or Constant Consider NVC Select NVC or Constant x With SVC x_sel x_nvc x_nvc_sel xconst Without SVC xconst_nvc xconst_nvc_sel |
| low_priority_review | `VariableTableCandidate` | 47 | GROBID table | Table 2 . |
| low_priority_review | `VariableTableCandidate` | 46 | GROBID table | Variables Description tokyo Logarithm of the distance from the nearest railway station to Tokyo Station [km] station Logarithm of the distance to the nearest railway station [km] flood Anticipated inundation depth [m] |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Eigenvector spatial filtering (ESF) model | The classical ESF model is formulated as follows: = ∑ = where is a fixed coefficient (see Eq.2). captures residual spatial dependence to estimate and infer regression coefficients appropriately. If spatial dependence in residuals is ignored, coefficient sta... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Random effects ESF (RE-ESF) model | The RE-ESF model is formulated as follows: As with the classical ESF, this model is useful to estimate and infer regression coefficients in the presence of residual spatial dependence. Unlike ESF, is given by a random spatial process approximating a Gaussia... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 100 | Small area estimation | Small area estimation (SAE; Ghosh and Rao, 1994) is a statistical technique estimating parameters for small areas such as districts and municipality. SAE is useful to obtain reliable small area statistics from noisy data. Suppose that the raw data in the I-... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 70 | Low rank spatial error model | The low rank spatial error model (LSEM) approximates the following model: is defined by the classical spatial error model (SEM) with parameters λ and . λ takes a positive value in the presence of positive spatial dependence while ρ < 0 in the presence of ne... |
| review_for_model_evidence | `ModelEvidenceCandidate` | 69 | Moran eigenvector-based spatial regression models | This package assumes the following analysis steps: (a) define Moran eigenvectors; (b) spatial regression using these eigenvectors. Hereafter, Section 2.1 explains (a) whereas Sections 2.2 to 2.5 explain (b). |
| low_priority_review | `truncated` |  |  | 3 autres candidats non affiches dans ce rapport |
