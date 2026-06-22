# CARBayesST package help

## Package Description

- Package: CARBayesST
- Title: Spatio-Temporal Generalised Linear Mixed Models for Areal Unit
Data
- Version: 4.0
- Date: 2023-10-31
- Description: Implements a class of univariate and multivariate spatio-temporal generalised linear mixed models for areal unit data, with inference in a Bayesian setting using Markov chain Monte Carlo (MCMC) simulation. The response variable can be binomial, Gaussian, or Poisson, but for some models only the binomial and Poisson data likelihoods are available. The spatio-temporal autocorrelation is modelled by  random effects, which are assigned conditional autoregressive (CAR) style prior distributions. A number of different random effects structures are available, including models similar to Rushworth et al. (2014) <doi:10.1016/j.sste.2014.05.001>. Full details are given in the vignette accompanying this package. The creation and development of this package was supported by the Engineering and Physical Sciences Research Council  (EPSRC) grants EP/J017442/1 and EP/T004878/1 and the Medical Research Council (MRC) grant MR/L022184/1.
- Author: Duncan Lee, Alastair Rushworth, Gary Napier and William Pettersson 
- Maintainer: Duncan Lee <Duncan.Lee@glasgow.ac.uk>
- Depends: MASS, R (>= 3.5.0), Rcpp (>= 0.11.5)
- Imports: CARBayesdata, coda, dplyr, GGally, ggplot2, gridExtra, gtools,
leaflet, matrixStats, MCMCpack, parallel, sf, spam, spdep,
stats, truncdist, truncnorm, utils
- License: GPL (>= 2)
- URL: https://github.com/duncanplee/CARBayesST
- BugReports: https://github.com/duncanplee/CARBayesST/issues

## Help Pages

- CARBayesST-package: Spatio-Temporal Generalised Linear Mixed Models For Areal Unit Data
- coef.CARBayesST: Extract the regression coefficients from a model.
- fitted.CARBayesST: Extract the fitted values from a model.
- logLik.CARBayesST: Extract the estimated loglikelihood from a fitted model.
- model.matrix.CARBayesST: Extract the model (design) matrix from a model.
- MVST.CARar: Fit a multivariate spatio-temporal generalised linear mixed model to data, with a multivariate spatio-temporal autoregressive process.
- print.CARBayesST: Print a summary of the fitted model to the screen.
- residuals.CARBayesST: Extract the residuals from a model.
- ST.CARadaptive: Fit a spatio-temporal generalised linear mixed model to data, with a spatio-temporal

autoregressive process that has an adaptive autocorrelation stucture.
- ST.CARanova: Fit a spatio-temporal generalised linear mixed model to data, with spatial and  temporal main

effects and a spatio-temporal interaction.
- ST.CARar: Fit a spatio-temporal generalised linear mixed model to data, with a spatio-temporal

autoregressive process.
- ST.CARclustrends: Fit a spatio-temporal generalised linear mixed model to data, with a clustering 

of temporal trend functions and a temporally common spatial surface.
- ST.CARlinear: Fit a spatio-temporal generalised linear mixed model to data, where the spatial

units have linear time trends with spatially varying intercepts and slopes.
- ST.CARlocalised: Fit a spatio-temporal generalised linear mixed model to data, with a spatio-temporal

autoregressive process and a piecewise constant intercept term.
- ST.CARsepspatial: Fit a spatio-temporal generalised linear mixed model to data, with a common 

temporal main effect and separate spatial surfaces with individual variances.
- W.estimate: Estimate an appropriate neighbourhood matrix for a set of spatial data using a baseline neighbourhood matrix and a  graph based optimisation algorithm.

## Package Rd Help

Spatio-Temporal Generalised Linear Mixed Models For Areal Unit Data

Description

     Implements a class of univariate and multivariate spatio-temporal
     generalised linear mixed models for areal unit data, with
     inference in a Bayesian setting using Markov chain Monte Carlo
     (MCMC) simulation. The response variable can be binomial, Gaussian
     or Poisson, but for some models only the binomial and Poisson data
     likelihoods are available. The spatio-temporal autocorrelation is
     modelled by random effects, which are assigned conditional
     autoregressive (CAR) style prior distributions. A number of
     different random effects structures are available, and full
     details are given in the vignette accompanying this package and
     the references below. The creation and development of this package
     was supported by the Engineering and Physical Sciences Research
     Council (EPSRC) grants EP/J017442/1 and EP/T004878/1 and the
     Medical Research Council (MRC) grant MR/L022184/1.

Details

       Package:  CARBayesST
       Type:     Package
       Version:  4.0
       Date:     2023-10-31
       License:  GPL (>= 2)

Author(s):

     Author: Duncan Lee, Alastair Rushworth, Gary Napier and William
     Pettersson

     Maintainer: Duncan Lee <Duncan.Lee@glasgow.ac.uk>

References

     Bernardinelli, L., D. Clayton, C.Pascuto, C.Montomoli,
     M.Ghislandi, and M. Songini (1995). Bayesian analysis of
     space-time variation in disease risk. Statistics in Medicine, 14,
     2433-2443.

     Knorr-Held, L. (2000). Bayesian modelling of inseparable
     space-time variation in disease risk.  Statistics in Medicine, 19,
     2555-2567.

     Lee, D and Lawson, C (2016). Quantifying the spatial inequality
     and temporal trends in maternal smoking rates in Glasgow, Annals
     of Applied Statistics, 10, 1427-1446.

     Lee, D and Rushworth, A and Napier, G (2018). Spatio-Temporal
     Areal Unit Modeling in R with Conditional Autoregressive Priors
     Using the CARBayesST Package, Journal of Statistical Software, 84,
     9, 1-39.

     Lee, D and Meeks, K and Pettersson, W (2021). Improved inference
     for areal unit count data using graph-based optimisation.
     Statistics and Computing, 31:51.

     Lee D, Robertson C, and Marques, D (2022). Quantifying the
     small-area spatio-temporal dynamics of the Covid-19 pandemic in
     Scotland during a period with limited testing capacity, Spatial
     Statistics, https://doi.org/10.1016/j.spasta.2021.100508.

     Napier, G, D. Lee, C. Robertson, A. Lawson, and K. Pollock (2016).
     A model to estimate the impact of changes in MMR vaccination
     uptake on inequalities in measles susceptibility in Scotland,
     Statistical Methods in Medical Research, 25, 1185-1200.

     Napier, G., Lee, D., Robertson, C., and Lawson, A. (2019). A
     Bayesian space-time model for clustering areal units based on
     their disease trends, Biostatistics, 20, 681-697.

     Rushworth, A., D. Lee, and R. Mitchell (2014). A spatio-temporal
     model for estimating the long-term effects of air pollution on
     respiratory hospital admissions in Greater London.  Spatial and
     Spatio-temporal Epidemiology 10, 29-38.

     Rushworth, A., Lee, D., and Sarran, C (2017).  An adaptive
     spatio-temporal smoothing model for estimating trends and step
     changes in disease risk. Journal of the Royal Statistical Society
     Series C, 66, 141-157.

Examples

     ## See the examples in the function specific help files and in the vignette
     ## accompanying this package.

