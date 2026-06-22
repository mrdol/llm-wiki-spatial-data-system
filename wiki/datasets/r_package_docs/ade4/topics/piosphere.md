Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

piosphere: Plant traits response to grazing

Plant traits response to grazing

Description

     Plant species cover, traits and environmental parameters recorded
     around livestock watering points in different habitats of central
     Namibian farmlands. See the Wesuls et al. (2012) paper for a full
     description of the data set.

Usage

     data(piosphere)

Format

     ‘piosphere’ is a list of 4 components.

     veg is a data frame containing plant species cover

     traits is a data frame with plant traits

     env is a data frame with environmental variables

     habitat is a factor describing habitat/years for each site

Source

     Wesuls, D., Oldeland, J. and Dray, S. (2012) Disentangling plant
     trait responses to livestock grazing from spatio-temporal
     variation: the partial RLQ approach. _Journal of Vegetation
     Science_, *23*, 98-113.

Examples
Run this code

     data(piosphere)
     names(piosphere)
     afcL <- dudi.coa(log(piosphere$veg + 1), scannf = FALSE)
     acpR <- dudi.pca(piosphere$env, scannf = FALSE, row.w = afcL$lw)
     acpQ <- dudi.hillsmith(piosphere$traits, scannf = FALSE, row.w = afcL$cw)
     rlq1 <- rlq(acpR, afcL, acpQ, scannf = FALSE)
     plot(rlq1)

