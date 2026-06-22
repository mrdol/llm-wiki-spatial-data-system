Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

santacatalina: Indirect Ordination

Indirect Ordination

Description

     This data set gives the densities per hectare of 11 species of
     trees for 10 transects of topographic moisture values (mean of
     several stations per class).

Usage

     data(santacatalina)

Format

     a data frame with 11 rows and 10 columns

Source

     Gauch, H. G. J., Chase, G. B. and Whittaker R. H. (1974)
     Ordination of vegetation samples by Gaussian species
     distributions. _Ecology_, *55*, 1382-1390.


Variables detected from installed object

v1: numeric ; missing=0 ; examples=36, 4, 0

v2: numeric ; missing=0 ; examples=646, 450, 0

v3: numeric ; missing=0 ; examples=472, 670, 0

v4: numeric ; missing=0 ; examples=212, 820, 6

v5: numeric ; missing=0 ; examples=48, 1304, 26

v6: numeric ; missing=0 ; examples=4, 724, 58

v7: numeric ; missing=0 ; examples=4, 248, 186

v8: numeric ; missing=0 ; examples=0, 106, 322

v9: numeric ; missing=0 ; examples=0, 124, 156

v10: numeric ; missing=0 ; examples=0, 22, 242

Examples
Run this code

     data(santacatalina)
     coa1 <- dudi.coa(log(santacatalina + 1), scan = FALSE) # 2 factors

     if(adegraphicsLoaded()) {
       g1 <- table.value(log(santacatalina + 1), plot = FALSE)
       g2 <- table.value(log(santacatalina + 1)[, sample(10)], plot = FALSE)
       g3 <- table.value(log(santacatalina + 1)[order(coa1$li[, 1]), order(coa1$co[, 1])], plot = FALSE)
       g4 <- scatter(coa1, posi = "bottomright", plot = FALSE)
       G <- ADEgS(list(g1, g2, g3, g4), layout = c(2, 2))
     } else {
       par(mfrow = c(2, 2))
       table.value(log(santacatalina + 1))
       table.value(log(santacatalina + 1)[, sample(10)])
       table.value(log(santacatalina + 1)[order(coa1$li[, 1]), order(coa1$co[, 1])])
       scatter(coa1, posi = "bottomright")
       par(mfrow = c(1, 1))
     }

