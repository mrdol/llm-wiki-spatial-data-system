# mgwrsar package help

## Package Description

- Package: mgwrsar
- Title: GWR, Mixed GWR with Spatial Autocorrelation and Multiscale
GWR/GTWR (Top-Down Scale Approaches)
- Version: 1.3.2
- Date: 2026-03-02
- Description: Provides methods for Geographically Weighted Regression with spatial autocorrelation (Geniaux and Martinetti 2017) <doi:10.1016/j.regsciurbeco.2017.04.001>. Implements Multiscale Geographically Weighted Regression with Top-Down Scale approaches (Geniaux 2026) <doi:10.1007/s10109-025-00481-4>.
- Authors@R: c(person(given = "Ghislain",
                      family = "Geniaux",
                      role = c("aut", "cre"),
                      email = "ghislain.geniaux@inrae.fr"),
               person(given = "Davide",
                      family = "Martinetti",
                      role = "aut"),
               person(given = "César",
                      family = "Martinez",
                      role = "aut"))
- Author: Ghislain Geniaux [aut, cre],
  Davide Martinetti [aut],
  César Martinez [aut]
- Maintainer: Ghislain Geniaux <ghislain.geniaux@inrae.fr>
- Depends: R (>= 3.5.0), sp, Matrix
- Imports: Rcpp, ggplot2, sf, knitr, methods, doParallel, foreach, nabor,
mapview, rlang, dplyr, gridExtra, grid, mboost, mgcv, caret,
stringr, SMUT,plotly, RhpcBLASctl, magrittr, lifecycle
- Suggests: rmarkdown
- License: GPL (>= 2)

## Help Pages

- atds_gwr: atds_gwr Top-Down Scaling approach of GWR
- coef.mgwrsar: coef for mgwrsar model
- find_TP: Search of a suitable set of target points.

find_TP is a wrapper function that identifies  a set of target points

based on spatial smoothed OLS residuals.
- fitted.mgwrsar: fitted for mgwrsar model
- golden_search_2d_bandwidth: Optimization of 2D Bandwidths (Spatial and Temporal) using Golden Section Search
- golden_search_bandwidth: Golden search bandwidth (deprecated)
- int_prems: Reorder Intercept Column First
- internal_functions: Internal Functions for mgwrsar Package
- kernel_matW: kernel_matW

A function that returns a sparse weight matrix based computed with a specified

kernel (gauss,bisq,tcub,epane,rectangle,triangle) considering coordinates

provides in S and a given bandwidth. If NN<nrow(S) only NN firts neighbours are considered.

If Type!='GD' then S should have additional columns and several

kernels and bandwidths should be be specified by the user.
- make_unique_by_structure: Ensure Uniqueness of Coordinates or Values in 1D, 2D, or 3D Structures
- MGWRSAR: Estimation of linear and local linear model with spatial autocorrelation model (mgwrsar).
- mgwrsar-class: Class of mgwrsar Model.
- mgwrsar_bootstrap_test: A bootstrap test for Betas for mgwrsar class model.
- mgwrsar_bootstrap_test_all: A bootstrap test for testing nullity of all Betas for mgwrsar class model,
- multiscale_gwr: Multiscale Geographically Weighted Regression (MGWR)
- mydata: mydata is a simulated data set of a mgwrsar model
- mydatasf: mydataf is a Simple Feature object with real estate data in south of France.
- normW: Row Normalization of Sparse Matrix
- plot.mgwrsar: Plot method for mgwrsar model
- plot_effect: plot_effect

plot_effect is a function that plots the effect of a variable X_k with spatially varying coefficient, i.e X_k * Beta_k(u_i,v_i) for comparing the magnitude of effects of between variables.
- predict.mgwrsar: predict method for mgwrsar model
- reord_D: reord_D
- reord_M_R: reord_M
- residuals.mgwrsar: residuals for mgwrsar model
- search_bandwidths: Bandwidth Selection via Multi-round Grid Search based on AICc
- simu_multiscale: Simulate Data Generating Processes (DGP) for Multiscale GWR
- summary.mgwrsar: summary for mgwrsar model
- summary_Matrix: Summary of a Sparse Matrix
- TDS_MGWR: Top-Down Scale (TDS) and Adaptive Top-Down Scale (ATDS) Estimation for MGWR

## Package Rd Help

No package-level Rd help page found.
