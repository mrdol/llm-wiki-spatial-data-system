# plm package help

## Package Description

- Package: plm
- Title: Linear Models for Panel Data
- Version: 2.6-7
- Date: 2025-11-13
- Description: A set of estimators for models and (robust) covariance matrices, and tests for panel data
             econometrics, including within/fixed effects, random effects, between, first-difference, 
             nested random effects as well as instrumental-variable (IV) and Hausman-Taylor-style models,
             panel generalized method of moments (GMM) and general FGLS models,
             mean groups (MG), demeaned MG, and common correlated effects (CCEMG) and pooled (CCEP) estimators
             with common factors, variable coefficients and limited dependent variables models.
             Test functions include model specification, serial correlation, cross-sectional dependence,
             panel unit root and panel Granger (non-)causality. Typical references are general econometrics 
             text books such as Baltagi (2021), Econometric Analysis of Panel Data (<doi:10.1007/978-3-030-53953-5>),
             Hsiao (2014), Analysis of Panel Data (<doi:10.1017/CBO9781139839327>), and Croissant and Millo (2018), 
             Panel Data Econometrics with R (<doi:10.1002/9781119504641>).
- Authors@R: c(person(given = "Yves",      family = "Croissant",    role = c("aut"), email = "yves.croissant@univ-reunion.fr"),
             person(given = "Giovanni",  family = "Millo",        role = c("aut"), email = "giovanni.millo@deams.units.it"),
             person(given = "Kevin",     family = "Tappe",        role = c("aut", "cre"), email = "kevin.tappe@bwi.uni-stuttgart.de"),
             person(given = "Ott",       family = "Toomet",       role = "ctb", email = "otoomet@gmail.com"),
             person(given = "Christian", family = "Kleiber",      role = "ctb", email = "Christian.Kleiber@unibas.ch"), 
             person(given = "Achim",     family = "Zeileis",      role = "ctb", email = "Achim.Zeileis@R-project.org"),
             person(given = "Arne",      family = "Henningsen",   role = "ctb", email = "arne.henningsen@googlemail.com"),
             person(given = "Liviu",     family = "Andronic",     role = "ctb"),
             person(given = "Nina",      family = "Schoenfelder", role = "ctb"))
- Author: Yves Croissant [aut],
  Giovanni Millo [aut],
  Kevin Tappe [aut, cre],
  Ott Toomet [ctb],
  Christian Kleiber [ctb],
  Achim Zeileis [ctb],
  Arne Henningsen [ctb],
  Liviu Andronic [ctb],
  Nina Schoenfelder [ctb]
- Maintainer: Kevin Tappe <kevin.tappe@bwi.uni-stuttgart.de>
- Depends: R (>= 3.2.0)
- Imports: MASS, bdsmatrix, collapse (>= 1.8.9), zoo, nlme, sandwich,
lattice, lmtest, maxLik, Rdpack, Formula, stats
- Suggests: AER, car, statmod, urca, pder, texreg, knitr, rmarkdown,
fixest, lfe
- License: GPL (>= 2)
- URL: https://cran.r-project.org/package=plm,
https://github.com/ycroissant/plm
- BugReports: https://github.com/ycroissant/plm/issues

## Help Pages

- aneweytest: Angrist and Newey's version of Chamberlain test for fixed effects
- Cigar: Cigarette Consumption
- cipstest: Cross-sectionally Augmented IPS Test for Unit Roots in Panel Models
- cortab: Cross--sectional correlation matrix
- Crime: Crime in North Carolina
- detect.lindep: Functions to detect linear dependence
- EmplUK: Employment and Wages in the United Kingdom
- ercomp: Estimation of the error components
- fixef.plm: Extract the Fixed Effects
- Gasoline: Gasoline Consumption
- Grunfeld: Grunfeld's Investment Data
- has.intercept: Check for the presence of an intercept in a formula or in a fitted

model
- Hedonic: Hedonic Prices of Census Tracts in the Boston Area
- index.plm: Extract the indexes of panel data
- is.pbalanced: Check if data are balanced
- is.pconsecutive: Check if time periods are consecutive
- is.pseries: Check if an object is a pseries
- LaborSupply: Wages and Hours Worked
- lag.plm: lag, lead, and diff for panel data
- make.dummies: Create a Dummy Matrix
- make.pbalanced: Make data balanced
- make.pconsecutive: Make data consecutive (and, optionally, also balanced)
- Males: Wages and Education of Young Males
- model.frame.pdata.frame: model.frame and model.matrix for panel data
- mtest: Arellano--Bond Test of Serial Correlation
- nobs.plm: Extract Total Number of Observations Used in Estimated Panelmodel
- Parity: Purchasing Power Parity and other parity relationships
- pbgtest: Breusch--Godfrey Test for Panel Models
- pbltest: Baltagi and Li Serial Dependence Test For Random Effects Models
- pbnftest: Modified BNF--Durbin--Watson Test and Baltagi--Wu's LBI Test for Panel

Models
- pbsytest: Bera, Sosa-Escudero and Yoon Locally--Robust Lagrange Multiplier

Tests for Panel Models and Joint Test by Baltagi and Li
- pcce: Common Correlated Effects estimators
- pcdtest: Tests of cross-section dependence for panel models
- pdata.frame: pdata.frame: a data.frame for panel data
- pdim: Check for the Dimensions of the Panel
- pdwtest: Durbin--Watson Test for Panel Models
- pFtest: F Test for Individual and/or Time Effects
- pggls: General FGLS Estimators
- pgmm: Generalized Method of Moments (GMM) Estimation for Panel Data
- pgrangertest: Panel Granger (Non-)Causality Test (Dumitrescu/Hurlin (2012))
- phansitest: Simes Test for unit roots in panel data
- pht: Hausman--Taylor Estimator for Panel Data
- phtest: Hausman Test for Panel Models
- piest: Chamberlain estimator and test for fixed effects
- pldv: Panel estimators for limited dependent variables
- plm: Panel Data Estimators
- plm-deprecated: Deprecated functions of plm
- plm-package: plm package: linear models for panel data
- plm.fast: Option to Switch On/Off Fast Data Transformations
- plmtest: Lagrange FF Multiplier Tests for Panel Models
- pmg: Mean Groups (MG), Demeaned MG and CCE MG estimators
- pmodel.response: A function to extract the model.response
- pooltest: Test of Poolability
- predict.plm: Model Prediction for plm Objects
- Produc: US States Production
- pseries: panel series
- pseriesfy: Turn all columns of a pdata.frame into class pseries.
- punbalancedness: Measures for Unbalancedness of Panel Data
- purtest: Unit root tests for panel data
- pvar: Check for Cross-Sectional and Time Variation
- pvcm: Variable Coefficients Models for Panel Data
- pwaldtest: Wald-style Chi-square Test and F Test
- pwartest: Wooldridge Test for AR(1) Errors in FE Panel Models
- pwfdtest: Wooldridge first--difference--based test for AR(1) errors in levels

or first--differenced panel models
- pwtest: Wooldridge's Test for Unobserved Effects in Panel Models
- r.squared: R squared and adjusted R squared for panel models
- ranef.plm: Extract the Random Effects
- re-export_functions: Functions exported from other packages
- RiceFarms: Production of Rice in Indonesia
- sargan: Hansen--Sargan Test of Overidentifying Restrictions
- Snmesp: Employment and Wages in Spain
- SumHes: The Penn World Table, v. 5
- summary.plm: Summary for plm objects
- vcovBK: Beck and Katz Robust Covariance Matrix Estimators
- vcovDC: Double-Clustering Robust Covariance Matrix Estimator
- vcovG: Generic Lego building block for Robust Covariance Matrix Estimators
- vcovHC.plm: Robust Covariance Matrix Estimators
- vcovNW: Newey and West (1987) Robust Covariance Matrix Estimator
- vcovSCC: Driscoll and Kraay (1998) Robust Covariance Matrix Estimator
- Wages: Panel Data of Individual Wages
- within_intercept: Overall Intercept for Within Models Along its Standard Error

## Package Rd Help

plm package: linear models for panel data

Description

     plm is a package for R which intends to make the estimation of
     linear panel models straightforward. plm provides functions to
     estimate a wide variety of models and to make (robust) inference.

Details

     For a gentle and comprehensive introduction to the package, please
     see the package's vignette.

     The main functions to estimate models are:

        * 'plm': panel data estimators using 'lm' on transformed data,

        * 'pvcm': variable coefficients models

        * 'pgmm': generalized method of moments (GMM) estimation for
          panel data,

        * 'pggls': estimation of general feasible generalized least
          squares models,

        * 'pmg': mean groups (MG), demeaned MG and common correlated
          effects (CCEMG) estimators,

        * 'pcce': estimators for common correlated effects mean groups
          (CCEMG) and pooled (CCEP) for panel data with common factors,

        * 'pldv': panel estimators for limited dependent variables.

     Next to the model estimation functions, the package offers several
     functions for statistical tests related to panel data/models.

     Multiple functions for (robust) variance-covariance matrices are
     at hand as well.

     The package also provides data sets to demonstrate functions and
     to replicate some text book/paper results.  Use
     'data(package="plm")' to view a list of available data sets in the
     package.

Author(s):

     *Maintainer*: Kevin Tappe
     <mailto:kevin.tappe@bwi.uni-stuttgart.de>

     Authors:

        * Yves Croissant <mailto:yves.croissant@univ-reunion.fr>

        * Giovanni Millo <mailto:giovanni.millo@deams.units.it>

     Other contributors:

        * Ott Toomet <mailto:otoomet@gmail.com> [contributor]

        * Christian Kleiber <mailto:Christian.Kleiber@unibas.ch>
          [contributor]

        * Achim Zeileis <mailto:Achim.Zeileis@R-project.org>
          [contributor]

        * Arne Henningsen <mailto:arne.henningsen@googlemail.com>
          [contributor]

        * Liviu Andronic [contributor]

        * Nina Schoenfelder [contributor]

See Also

     Useful links:

        * <https://cran.r-project.org/package=plm>

        * <https://github.com/ycroissant/plm>

        * Report bugs at <https://github.com/ycroissant/plm/issues>

Examples

     data("Produc", package = "plm")
     zz <- plm(log(gsp) ~ log(pcap) + log(pc) + log(emp) + unemp,
               data = Produc, index = c("state","year"))
     summary(zz)

     # replicates some results from Baltagi (2013), table 3.1
     data("Grunfeld", package = "plm")
     p <- plm(inv ~ value + capital,
              data = Grunfeld, model="pooling")

     wi <- plm(inv ~ value + capital,
               data = Grunfeld, model="within", effect = "twoways")

     swar <- plm(inv ~ value + capital,
                 data = Grunfeld, model="random", effect = "twoways")

     amemiya <- plm(inv ~ value + capital,
                    data = Grunfeld, model = "random", random.method = "amemiya",
                    effect = "twoways")

     walhus <- plm(inv ~ value + capital,
                   data = Grunfeld, model = "random", random.method = "walhus",
                   effect = "twoways")

