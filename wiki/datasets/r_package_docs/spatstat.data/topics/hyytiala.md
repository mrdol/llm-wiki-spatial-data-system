Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

hyytiala: Scots pines and other trees at Hyytiala

Scots pines and other trees at Hyytiala

Description

     This dataset is a spatial point pattern of trees recorded at
     Hyytiala, Finland.  The majority of the trees are Scots pines.
     See Kokkila et al (2002).

     The dataset ‘hyytiala’ is a point pattern (object of class
     ‘"ppp"’) containing the spatial coordinates of each tree, marked
     by species (a factor with levels ‘aspen’, ‘birch’, ‘pine’ and
     ‘rowan’).  The survey region is a 20 by 20 metre square.
     Coordinates are given in metres.

Usage

     data(hyytiala)

Source

     Nicolas Picard

References

     Kokkila, T., Makela, A. and Nikinmaa E. (2002) A method for
     generating stand structures using Gibbs marked point process.
     _Silva Fennica_ *36* 265-277.

     Picard, N, Bar-Hen, A., Mortier, F. and Chadoeuf, J. (2009) The
     multi-scale marked area-interaction point process: a model for the
     spatial pattern of trees.  _Scandinavian Journal of Statistics_
     *36* 23-41

Examples
Run this code

     data(hyytiala)
       if(require(spatstat.geom)) {
     plot(hyytiala, cols=2:5)
       }

