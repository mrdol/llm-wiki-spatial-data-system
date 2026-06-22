Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

ponderosa: Ponderosa Pine Tree Point Pattern

Ponderosa Pine Tree Point Pattern

Description

     The data record the locations of 108 Ponderosa Pine (_Pinus
     ponderosa_) trees in a 120 metre square region in the Klamath
     National Forest in northern California, published as Figure 2 of
     Getis and Franklin (1987).

     Franklin et al. (1985) determined the locations of approximately
     5000 trees from United States Forest Service aerial photographs
     and digitised them for analysis. Getis and Franklin (1987)
     selected a 120 metre square subregion that appeared to exhibit
     clustering. This subregion is the ‘ponderosa’ dataset.

     In principle these data are equivalent to Figure 2 of Getis and
     Franklin (1987) but they are not exactly identical; some of the
     spatial locations appear to be slightly perturbed.

     The data points identified as A, B, C on Figure 2 of Getis and
     Franklin (1987) correspond to points numbered 42, 7 and 77 in the
     dataset respectively.

Usage

     data(ponderosa)

Format

     Typing ‘data(ponderosa)’ gives access to two objects, ‘ponderosa’
     and ‘ponderosa.extra’.

     The dataset ‘ponderosa’ is a spatial point pattern (object of
     class ‘"ppp"’) representing the point pattern of tree positions.
     See ‘ppp.object’ for details of the format.  Spatial coordinates
     are given in metres.

     The dataset ‘ponderosa.extra’ is a list containing supplementary
     data. The entry ‘id’ contains the index numbers of the three
     special points A, B, C in the point pattern. The entry ‘plotit’ is
     a function that can be called to produce a nice plot of the point
     pattern.

Source

     Prof. Janet Franklin, University of California, Santa Barbara

References

     Franklin, J., Michaelsen, J. and Strahler, A.H. (1985) Spatial
     analysis of density dependent pattern in coniferous forest stands.
     _Vegetatio_ *64*, 29-36.

     Getis, A. and Franklin, J. (1987) Second-order neighbourhood
     analysis of mapped point patterns.  _Ecology_ *68*, 473-477.

Examples
Run this code

        data(ponderosa)
       if(require(spatstat.geom)) {
        ponderosa.extra$plotit()
        }

