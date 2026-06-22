Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

buech: Buech basin

Buech basin

Description

     This data set contains informations about Buech basin
     characteristics.

Usage

     data(buech)

Format

     ‘buech’ is a list with the following components:

     tab1 a data frame with 10 environmental variables collected on 31
          sites in Juin (1984)

     tab2 a data frame with 10 environmental variables collected on 31
          sites in September (1984)

     xy a data frame with the coordinates of the sites

     contour a data frame for background map

     nb the neighbouring graph between sites, object of the class ‘nb’

     Spatial an object of the class ‘SpatialPolygons’ of ‘sp’,
          containing the map

Details

     Variables of ‘buech$tab1’ and ‘buech$tab2’ are the following ones:
     pH ; Conductivity (mu S/cm) ; Carbonate (water hardness (mg/l
     CaCO3)) ; hardness (total water hardness (mg/l CaCO3)) ;
     Bicarbonate (alcalinity (mg/l HCO3-)) ; Chloride (alcalinity (mg/l
     Cl-)) ; Suspens (particles in suspension (mg/l)) ; Organic
     (organic particles (mg/l)) ; Nitrate (nitrate rate (mg/l NO3-)) ;
     Ammonia (amoniac rate (mg/l NH4-))

Source

     Vespini, F. (1985) _Contribution à l'étude hydrobiologique du
     Buech, rivière non aménagée de Haute-Provence_. Thèse de troisième
     cycle, Université de Provence.

     Vespini, F., Légier, P. and Champeau, A. (1987) Ecologie d'une
     rivière non aménagée des Alpes du Sud : Le Buëch (France) I.
     Evolution longitudinale des descripteurs physiques et chimiques.
     _Annales de Limnologie_, *23*, 151-164.

Examples
Run this code

     data(buech)
     if(adegraphicsLoaded()) {
       if(requireNamespace("sp", quietly = TRUE)) {
         g1 <- s.label(buech$xy, Sp = buech$Spatial, nb = buech$nb,
           pSp.col = "transparent", plot = FALSE)
         g2 <- s.value(buech$xy, buech$tab2$Suspens - buech$tab1$Suspens,
           Sp = buech$Spatial, nb = buech$nb, pSp.col = "transparent", plot = FALSE)
         G <- cbindADEg(g1, g2, plot = TRUE)
       }
     }

