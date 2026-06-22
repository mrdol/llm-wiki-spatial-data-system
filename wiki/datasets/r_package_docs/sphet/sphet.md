# sphet package help

## Package Description

- Package: sphet
- Title: Estimation of Spatial Autoregressive Models with and without
Heteroskedastic Innovations
- Version: 2.1-1
- Date: 2024-12-06
- Description: Functions for fitting Cliff-Ord-type spatial autoregressive models with and without heteroskedastic innovations using Generalized Method of Moments estimation are provided. Some support is available for fitting spatial HAC models, and for fitting with non-spatial endogeneous variables using instrumental variables.
- Authors@R: c(person("Gianfranco", "Piras", role = c("aut", "cre"), 
            email = "gpiras@mac.com", 
            comment=c(ORCID="0000-0003-0225-6061")),
            person("Roger","Bivand", role = c("ctb"), 
            email = "Roger.Bivand@nhh.no", 
            comment=c(ORCID="0000-0003-2392-6140")))
- Author: Gianfranco Piras [aut, cre] (<https://orcid.org/0000-0003-0225-6061>),
  Roger Bivand [ctb] (<https://orcid.org/0000-0003-2392-6140>)
- Maintainer: Gianfranco Piras <gpiras@mac.com>
- Depends: R (>= 3.0.1)
- Imports: nlme, spatialreg, spdep, Matrix, sp, methods, stats, utils,
mvtnorm, stringr, coda, spData (>= 2.3.1), sf
- License: GPL-2
- URL: https://github.com/gpiras/sphet
- BugReports: https://github.com/gpiras/sphet/issues

## Help Pages

- circular: Generate circular weigthing matrices
- coldis: Object of class distance for Columbus dataset 

10-nearest neighbors matrix for columbus dataset
- distance: Distance measures available in distance
- gstslshet: GM estimation of a Cliff-Ord type model with Heteroskedastic Innovations
- impacts.error_sphet: Generate impacts for objects of class error_sphet created in sphet
- impacts.gstsls: Generate impacts for spreg lag and sarar models
- impacts.ols_sphet: Generate impacts for objects of class ols_sphet created in sphet
- impacts.stsls_sphet: Generate impacts for objects of class lag_gmm created in sphet
- kpjtest: Kelejian and Piras J-test
- listw2dgCMatrix: Interface between Matrix class objects and weights list
- print.sphet: print method for class sphet
- print.summary.sphet: print method for class sphet
- read.gwt2dist: Read distance ojbects
- sphet: Estimation of spatial models with heteroskedastic innovations
- spreg: GM estimation of a Cliff-Ord type model with Heteroskedastic Innovations
- stslshac: Spatial two stages least square with HAC standard errors
- summary.sphet: print method for class sphet
- utilities: Functions used by gstslshet.

## Package Rd Help

Estimation of spatial models with heteroskedastic innovations

Description

     A set of functions to estimate spatial models with heteroskedastic
     innovations

Details

       Package:   sphet
       Type:      Package
       Version:   1.12
       Date:      2021-06-17
       License:   GPL
       LazyLoad:  yes

Author(s):

     Gianfranco Piras <mailto:gpiras@mac.com>

References

     Piras, Gianfranco (2010) sphet: Spatial Models with
     Heteroskedastic Innovations in R, _Journal of Statistical
     Software_ June 2010, Volume 35, Issue 1.

     Bivand, R; Millo, G; Piras, G. (2021) A Review of Software for
     Spatial Econometrics in R _Mathematics_ 9 (11):1276.

     Bivand, R; Piras, G. (2015) Comparing Implementations of
     Estimation Methods for Spatial Econometrics, _Journal of
     Statistical Software_, Volume 63, Issue 18, 1-36.

