Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

tithonia: Phylogeny and quantitative traits of flowers

Phylogeny and quantitative traits of flowers

Description

     This data set describes the phylogeny of 11 flowers as reported by
     Morales (2000). It also gives morphologic and demographic traits
     corresponding to these 11 species.

Usage

     data(tithonia)

Format

     ‘tithonia’ is a list containing the 2 following objects :

     tre is a character string giving the phylogenetic tree in Newick
          format.

     tab is a data frame with 11 species and 14 traits (6 morphologic
          traits and 8 demographic).

Details

     Variables of ‘tithonia$tab’ are the following ones :
     morho1: is a numeric vector that describes the seed size (mm)
     morho2: is a numeric vector that describes the flower size (mm)
     morho3: is a numeric vector that describes the female leaf size
     (cm)
     morho4: is a numeric vector that describes the head size (mm)
     morho5: is a integer vector that describes the number of flowers
     per head
     morho6: is a integer vector that describes the number of seeds per
     head
     demo7: is a numeric vector that describes the seedling height (cm)
     demo8: is a numeric vector that describes the growth rate (cm/day)
     demo9: is a numeric vector that describes the germination time
     demo10: is a numeric vector that describes the establishment (per
     cent)
     demo11: is a numeric vector that describes the viability (per
     cent)
     demo12: is a numeric vector that describes the germination (per
     cent)
     demo13: is a integer vector that describes the resource allocation
     demo14: is a numeric vector that describes the adult height (m)

Source

     Data were obtained from Morales, E. (2000) Estimating phylogenetic
     inertia in Tithonia (Asteraceae) : a comparative approach.
     _Evolution_, *54*, 2, 475-484.

Examples
Run this code

     data(tithonia)
     phy <- newick2phylog(tithonia$tre)
     tab <- log(tithonia$tab + 1)
     table.phylog(scalewt(tab), phy)
     gearymoran(phy$Wmat, tab)
     gearymoran(phy$Amat, tab)

