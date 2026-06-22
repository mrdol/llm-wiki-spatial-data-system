Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

vegtf: Vegetation in Trois-Fontaines

Vegetation in Trois-Fontaines

Description

     This data set contains abundance values (Braun-Blanquet scale) of
     80 plant species for 337 sites. Data have been collected by Sonia
     Said and Francois Debias.

Usage

     data(vegtf)

Format

     ‘vegtf’ is a list with the following components:

     veg a data.frame with the abundance values of 80 species (columns)
          in 337 sites (rows)

     xy a data.frame with the spatial coordinates of the sites

     area a data.frame (area) which define the boundaries of the study
          site

     sp.names a vector containing the species latin names

     nb a neighborhood object (class ‘nb’ defined in package ‘spdep’)

     Spatial an object of the class ‘SpatialPolygons’ of ‘sp’,
          containing the map

Source

     Dray, S., Said, S. and Debias, F. (2008) Spatial ordination of
     vegetation data using a generalization of Wartenberg's
     multivariate spatial correlation.  _Journal of vegetation
     science_, *19*, 45-56.

Examples
Run this code

     if(requireNamespace("spdep", quietly = TRUE) & requireNamespace("adespatial", quietly = TRUE)) {
       data(vegtf)
       coa1 <- dudi.coa(vegtf$veg, scannf = FALSE)
       ms.coa1 <- adespatial::multispati(coa1, listw = spdep::nb2listw(vegtf$nb), nfposi = 2,
         nfnega = 0, scannf = FALSE)
       summary(ms.coa1)
       plot(ms.coa1)

       if(adegraphicsLoaded()) {
         g1 <- s.value(vegtf$xy, coa1$li[, 1], Sp = vegtf$Spatial, pSp.col = "white", plot = FALSE)
         g2 <- s.value(vegtf$xy, ms.coa1$li[, 1], Sp = vegtf$Spatial, pSp.col = "white", plot = FALSE)
         g3 <- s.label(coa1$c1, plot = FALSE)
         g4 <- s.label(ms.coa1$c1, plot = FALSE)
         G <- ADEgS(list(g1, g2, g3, g4), layout = c(2, 2))
       } else {
         par(mfrow = c(2, 2))
         s.value(vegtf$xy, coa1$li[, 1], area = vegtf$area, include.origin = FALSE)
         s.value(vegtf$xy, ms.coa1$li[, 1], area = vegtf$area, include.origin = FALSE)
         s.label(coa1$c1)
         s.label(ms.coa1$c1)
       }
     }

