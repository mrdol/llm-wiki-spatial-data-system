Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

friday87: Faunistic K-tables

Faunistic K-tables

Description

     This data set gives informations about sites, species and
     environmental variables.

Usage

     data(friday87)

Format

     ‘friday87’ is a list of 4 components.

     fau is a data frame containing a faunistic table with 16 sites and
          91 species.

     mil is a data frame with 16 sites and 11 environmental variables.

     fau.blo is a vector of the number of species per group.

     tab.names is the name of each group of species.

Source

     Friday, L.E. (1987) The diversity of macroinvertebrate and
     macrophyte communities in ponds, _Freshwater Biology_, *18*,
     87-104.

Examples
Run this code

     data(friday87)
     wfri <- data.frame(scale(friday87$fau, scal = FALSE))
     wfri <- ktab.data.frame(wfri, friday87$fau.blo,
         tabnames = friday87$tab.names)

     if(adegraphicsLoaded()) {
       g1 <- kplot(sepan(wfri), row.plabels.cex = 2)
     } else {
       kplot(sepan(wfri), clab.r = 2, clab.c = 1)
     }

