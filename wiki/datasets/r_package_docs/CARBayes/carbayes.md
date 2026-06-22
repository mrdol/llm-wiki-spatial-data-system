# CARBayes package help

## Package Description

- Package: CARBayes
- Title: Spatial Generalised Linear Mixed Models for Areal Unit Data
- Version: 6.1.1
- Date: 2024-03-08
- Description: Implements a class of univariate and multivariate spatial generalised linear mixed models for areal unit data, with inference in a Bayesian setting using Markov chain Monte Carlo (MCMC) simulation using a single or multiple Markov chains. The response variable can be binomial, Gaussian, multinomial, Poisson or zero-inflated Poisson (ZIP), and spatial autocorrelation is modelled by a set of random effects that are assigned a conditional autoregressive (CAR) prior distribution. A number of different models are available for univariate spatial data, including models with no random effects as well as random effects modelled by different types of CAR prior, including the BYM model (Besag et al., 1991, <doi:10.1007/BF00116466>) and Leroux model (Leroux et al., 2000, <doi:10.1007/978-1-4612-1284-3_4>). Additionally,  a multivariate CAR (MCAR) model for multivariate spatial data is available, as is a two-level hierarchical model for modelling data relating to individuals within areas. Full details are given in the vignette accompanying this package. The initial creation of this package was supported by the Economic and Social Research Council (ESRC) grant RES-000-22-4256, and on-going development has been supported by the Engineering and Physical Science Research Council (EPSRC) grant EP/J017442/1, ESRC grant ES/K006460/1, Innovate UK / Natural Environment Research Council (NERC) grant NE/N007352/1 and the TB Alliance. 
- Author: Duncan Lee
- Maintainer: Duncan Lee <Duncan.Lee@glasgow.ac.uk>
- Depends: MASS, R (>= 3.5.0), Rcpp (>= 0.11.5)
- Imports: CARBayesdata, coda, dplyr, GGally, glmnet, igraph, mapview,
MCMCpack, parallel, RColorBrewer, sf, spam, spdep, stats,
truncnorm, utils
- License: GPL (>= 2)
- URL: https://github.com/duncanplee/CARBayes
- BugReports: https://github.com/duncanplee/CARBayes/issues

## Help Pages

- CARBayes-package: Spatial Generalised Linear Mixed Models for Areal Unit Data
- fitted.CARBayes: Extract the fitted values from a model.
- highlight.borders: Creates an sf data.frame object (from the sf package) identifying a subset of borders 

between neighbouring areas.
- logLik.CARBayes: Extract the estimated loglikelihood from a fitted model.
- model.matrix.CARBayes: Extract the model (design) matrix from a model.
- MVS.CARleroux: Fit a multivariate spatial generalised linear mixed model to data, where the 

    random effects are modelled by a multivariate conditional autoregressive model.
- print.CARBayes: Print a summary of a fitted CARBayes model to the screen.
- residuals.CARBayes: Extract the residuals from a model.
- S.CARbym: Fit a spatial generalised linear mixed model to data, where the random effects 

have a BYM conditional autoregressive prior.
- S.CARdissimilarity: Fit a spatial generalised linear mixed model to data, where the random effects 

have a localised conditional autoregressive prior.
- S.CARleroux: Fit a spatial generalised linear mixed model to data, where the random effects 

have a Leroux conditional autoregressive prior.
- S.CARlocalised: Fit a spatial generalised linear mixed model to data, where a set of spatially 

smooth random effects  are augmented with a piecewise constant intercept process.
- S.CARmultilevel: Fit a spatial generalised linear mixed model  to multi-level areal unit data, 

    where the spatial random effects have a Leroux conditional autoregressive 

    prior.
- S.glm: Fit a generalised linear model to data.
- S.RAB: Fit a spatial generalised linear model with anisotropic basis functions to data

for computationally efficient localised spatial smoothing, where the parameters 

are estimated by penalised maximum likelihood estimation with a ridge regression 

penalty.

## Package Rd Help

Spatial Generalised Linear Mixed Models for Areal Unit Data

Description

     Implements a class of univariate and multivariate spatial
     generalised linear mixed models for areal unit data, with
     inference in a Bayesian setting using Markov chain Monte Carlo
     (MCMC) simulation using a single or multiple Markov chains. The
     response variable can be binomial, Gaussian, multinomial, Poisson
     or zero-inflated Poisson (ZIP), and spatial autocorrelation is
     modelled by a set of random effects that are assigned a
     conditional autoregressive (CAR) prior distribution. A number of
     different models are available for univariate spatial data,
     including models with no random effects as well as random effects
     modelled by different types of CAR prior, including the BYM model
     (Besag et al., 1991, <doi:10.1007/BF00116466>) and the Leroux
     model (Leroux et al., 2000, <doi:10.1007/978-1-4612-1284-3_4>).
     Additionally, a multivariate CAR (MCAR) model for multivariate
     spatial data is available, as is a two-level hierarchical model
     for modelling data relating to individuals within areas. Full
     details are given in the vignette accompanying this package. The
     initial creation of this package was supported by the Economic and
     Social Research Council (ESRC) grant RES-000-22-4256, and on-going
     development has been supported by the Engineering and Physical
     Science Research Council (EPSRC) grant EP/J017442/1, ESRC grant
     ES/K006460/1, Innovate UK / Natural Environment Research Council
     (NERC) grant NE/N007352/1 and the TB Alliance.

Details

       Package:  CARBayes
       Type:     Package
       Version:  6.1.1
       Date:     2024-03-08
       License:  GPL (>= 2)

Author(s):

     Maintainer: Duncan Lee <Duncan.Lee@glasgow.ac.uk>

References

     Besag, J. and York, J and Mollie, A (1991). Bayesian image
     restoration with two applications in spatial statistics. Annals of
     the Institute of Statistics and Mathematics 43, 1-59.

     Gelfand, A and Vounatsou, P (2003). Proper multivariate
     conditional autoregressive models for spatial data analysis,
     Biostatistics, 4, 11-25.

     Kavanagh, L., D. Lee, and G. Pryce (2016). Is Poverty
     Decentralising? Quantifying Uncertainty in the Decentralisation of
     Urban Poverty, Annals of the American Association of Geographers,
     106, 1286-1298.

     Lee, D. and Mitchell, R (2012). Boundary detection in disease
     mapping studies.  Biostatistics, 13, 415-426.

     Lee, D and Sarran, C (2015). Controlling for unmeasured
     confounding and spatial misalignment in long-term air pollution
     and health studies, Environmetrics, 26, 477-487.

     Lee, D (2024). Computationally efficient localised spatial
     smoothing of disease rates using anisotropic basis functions and
     penalised regression fitting, Spatial Statistics, 59, 100796.

     Leroux B, Lei X, Breslow N (2000). "Estimation of Disease Rates in
     SmallAreas: A New Mixed Model for Spatial Dependence." In M
     Halloran, D Berry (eds.), _Statistical Models in Epidemiology, the
     Environment and Clinical Trials_, pp. 179-191. Springer-Verlag,
     New York.

     Roberts, G and Rosenthal, J (1998). Optimal scaling of discrete
     approximations to the Langevin diffusions, Journal of the Royal
     Statistical Society Series B 60, 255-268.

Examples

     ## See the examples in the function specific help files and in the vignette
     ## accompanying this package.

