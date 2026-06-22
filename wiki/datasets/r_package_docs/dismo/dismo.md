# dismo package help

## Package Description

- Package: dismo
- Title: Species Distribution Modeling
- Version: 1.3-16
- Date: 2024-11-24
- Description: Methods for species distribution modeling, that is, predicting the environmental similarity of any site to that of the locations of known occurrences of a species.
- Authors@R: c(
 	person("Robert J.", "Hijmans", role = c("cre", "aut"),  
			email = "r.hijmans@gmail.com", comment = c(ORCID = "0000-0001-5872-2872")),
	person("Steven", "Phillips", role = "aut"),
    person("John", "Leathwick", role = "aut"),
    person("Jane", "Elith", role = "aut"))
- Author: Robert J. Hijmans [cre, aut] (<https://orcid.org/0000-0001-5872-2872>),
  Steven Phillips [aut],
  John Leathwick [aut],
  Jane Elith [aut]
- Maintainer: Robert J. Hijmans <r.hijmans@gmail.com>
- Depends: R (>= 3.6.3), raster (>= 3.5-21), sp (>= 1.4-5)
- Imports: Rcpp, methods, terra (>= 1.5-34)
- Suggests: rJava (>= 0.9-7), XML, ROCR, deldir, gstat, randomForest,
kernlab, jsonlite, gbm (>= 2.1.1)
- License: GPL (>= 3)
- URL: https://rspatial.org/raster/sdm/
- BugReports: https://github.com/rspatial/dismo/issues/

## Help Pages

- acaule: Solanum acaule data
- bioclim: Bioclim
- biovars: bioclimatic variables
- boxplot: Box plot of model evaluation data
- calc.deviance: Calculate deviance
- circleHull: Circle hull model
- circles: Circles range
- convHull: Convex hull model
- dcEvaluate: Evaluate by distance class
- density: density
- dismo-package: Species distribution modeling
- DistModel: Class "DistModel"
- domain: Domain
- ecocrop: Ecocrop model
- ecolim: Ecolim model
- evaluate: Model evaluation
- evaluateROCR: Model testing with the ROCR package
- gbif: Data from GBIF
- gbm.data: Anguilla australis distribution data
- gbm.fixed: gbm fixed
- gbm.holdout: gbm holdout
- gbm.interactions: gbm interactions
- gbm.persp: gbm perspective plot
- gbm.plot: gbm plot
- gbm.plot.fits: gbm plot fitted values
- gbm.simplify: gbm simplify
- gbm.step: gbm step
- geocode: Georeferencing with Google
- geoDist: Geographic distance model
- geoIDW: Inverse-distance weighted model
- gmap: Get a Google map
- gridSample: Stratified regular sample on a grid
- kfold: k-fold partitioning
- mahal: Mahalanobis model
- maxent: Maxent
- mess: Multivariate environmental similarity surfaces (MESS)
- ModelEvaluation: Class "ModelEvaluation"
- nicheEquivalency: Niche equivalency
- nicheOverlap: Niche overlap
- nullRandom: Random null model
- pairs: Pair plots
- plot: Plot predictor values
- plotEval: Plot model evaluation data
- pointValues: point values
- predict: Distribution model predictions
- prepareData: Prepare data for model fitting
- pwdSample: Pair-wise distance sampling
- randomPoints: Random points
- rectHull: Rectangular hull model
- response: response plots
- ssb: Spatial sorting bias
- threshold: Find a threshold
- voronoi: Voronoi polygons
- voronoiHull: Voronoi hull model

## Package Rd Help

Species distribution modeling

Description

     This package implements a few species distribution models,
     including an R link to the 'maxent' model, and native
     implementations of Bioclim and Domain. It also provides a number
     of functions that can assist in using Boosted Regresssion Trees.

     A good place to start is the vignette, which you can access by
     typing 'vignette('sdm', 'dismo')'

     In addition there are a number of functions, such sampling
     background points, k-fold sampling, and for model evaluation (AUC)
     that are useful for these and for other species distribution
     modeling methods available in R (e.g. GLM, GAM, and RandomForest).

Author(s):

     Robert J. Hijmans, Steven Phillips, John Leathwick and Jane Elith

