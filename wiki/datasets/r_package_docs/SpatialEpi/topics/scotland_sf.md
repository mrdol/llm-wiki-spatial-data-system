Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

scotland_sf: Lip Cancer in Scotland

Lip Cancer in Scotland

Description

     County-level (n=56) data for lip cancer among males in Scotland
     between 1975-1980

Usage

     scotland_sf

Format

     A data frame with 56 rows representing counties and 5 variables:

     geometry Geometric representation of counties in Scotland

     cases Number of Lip Cancer cases per county

     county.names Scotland County name

     AFF Proportion of the population who work in agricultural fishing
          and farming

     expected Expected number of lip cancer cases

Source

     Kemp I., Boyle P., Smans M. and Muir C. (1985) Atlas of cancer in
     Scotland, 1975-1980, incidence and epidemiologic perspective
     _International Agency for Research on Cancer_ *72*.

References

     Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of
     age-standardized relative risks for use in disease mapping.
     _Biometrics_, *43*, 671-681.


Variables detected from installed object

county.names: factor ; missing=0 ; examples=skye-lochalsh, gordon, western.isles

cases: numeric ; missing=0 ; examples=9, 20, 13

expected: numeric ; missing=0 ; examples=1.4, 6.6, 4.4

AFF: numeric ; missing=0 ; examples=0.16, 0.07

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     library(ggplot2)
     ## Not run:

     ggplot() +
     geom_sf(data = scotland_sf, aes(fill= cases))
     ## End(Not run)

