# SpatialEpi package help

## Package Description

- Package: SpatialEpi
- Title: Methods and Data for Spatial Epidemiology
- Version: 1.2.8
- Description: Methods and data for cluster detection and disease mapping.
- Authors@R: c(
    person("Cici", "Chen", email = "cicichen@u.washington.edu", role = "ctb"),
    person("Albert Y.", "Kim", email = "albert.ys.kim@gmail.com", role = c("aut", "cre"), comment = c(ORCID = "0000-0001-7824-306X")),
    person("Michelle", "Ross", email = "micher3@u.washington.edu", role = "ctb"),
    person("Jon", "Wakefield", email = "jonno@uw.edu", role = c("aut")),
    person("Mikael","Moise", email = "amoise@smith.edu", role = c("aut"),comment = c(ORCID = "0000-0002-3608-1178"))
    )
- Author: Cici Chen [ctb],
  Albert Y. Kim [aut, cre] (<https://orcid.org/0000-0001-7824-306X>),
  Michelle Ross [ctb],
  Jon Wakefield [aut],
  Mikael Moise [aut] (<https://orcid.org/0000-0002-3608-1178>)
- Maintainer: Albert Y. Kim <albert.ys.kim@gmail.com>
- Depends: R (>= 3.0.2), sp
- Imports: Rcpp, MASS, spdep
- Suggests: rmarkdown, markdown, knitr, testthat (>= 3.0.0), ggplot2,
dplyr
- License: GPL-2
- URL: https://github.com/rudeboybert/SpatialEpi
- BugReports: https://github.com/rudeboybert/SpatialEpi/issues

## Help Pages

- bayes_cluster: Bayesian Cluster Detection Method
- besag_newell: Besag-Newell Cluster Detection Method
- circle: Compute cartesian coordinates of a cluster center and radius
- create_geo_objects: Create geographical objects to be used in Bayesian Cluster Detection Method
- eBayes: Empirical Bayes Estimates of Relative Risk
- EBpostdens: Produce plots of empirical Bayes posterior densities when the data Y are Poisson with expected number E and relative risk theta, with the latter having a gamma distribution with known values alpha and beta, which are estimated using empirical Bayes.
- EBpostthresh: Produce the probabilities of exceeding a threshold given a posterior gamma distribution.
- estimate_lambda: Estimate lambda values
- expected: Compute Expected Numbers of Disease
- GammaPriorCh: Compute Parameters to Calibrate a Gamma Distribution
- grid2latlong: Convert Coordinates from Grid to Latitude/Longitude
- kulldorff: Kulldorff Cluster Detection Method
- latlong2grid: Convert Coordinates from Latitude/Longitude to Grid
- leglabs: Make legend labels
- LogNormalPriorCh: Compute Parameters to Calibrate a Log-normal Distribution
- mapvariable: Plot Levels of a Variable in a Colour-Coded Map
- NYleukemia: Upstate New York Leukemia Data
- NYleukemia_sf: Upstate New York Leukemia
- pennLC: Pennsylvania Lung Cancer
- pennLC_sf: Pennsylvania Lung Cancer
- plotmap: Plot Levels of a Variable in a Colour-Coded Map
- polygon2spatial_polygon: Convert a Polygon to a Spatial Polygons Object
- process_MCMC_sample: Process MCMC Sample
- scotland: Lip Cancer in Scotland
- scotland_sf: Lip Cancer in Scotland
- zones: Create set of all single zones and output geographical information

## Package Rd Help

No package-level Rd help page found.
