Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

lansing: Lansing Woods Point Pattern

Lansing Woods Point Pattern

Description

     Locations and botanical classification of trees in Lansing Woods.

     The data come from an investigation of a 924 ft x 924 ft (19.6
     acre) plot in Lansing Woods, Clinton County, Michigan USA by D.J.
     Gerrard. The data give the locations of 2251 trees and their
     botanical classification (into hickories, maples, red oaks, white
     oaks, black oaks and miscellaneous trees).  The original plot size
     (924 x 924 feet) has been rescaled to the unit square.

     Note that the data contain duplicated points (two points at the
     same location). To determine which points are duplicates, use
     ‘duplicated.ppp’.  To remove the duplication, use ‘unique.ppp’.

Usage

     data(lansing)

Format

     An object of class ‘"ppp"’ representing the point pattern of tree
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of tree
       ‘y’      Cartesian y-coordinate of tree
       ‘marks’  factor with levels indicating species of
                each tree

     The levels of ‘marks’ are ‘blackoak’, ‘hickory’, ‘maple’, ‘misc’,
     ‘redoak’ and ‘whiteoak’.  See ‘ppp.object’ for details of the
     format of a point pattern object.

References

     Besag, J. (1978) Some methods of statistical analysis for spatial
     data. _Bull. Internat. Statist. Inst._ *44*, 77-92.

     Cox, T.F. (1976) The robust estimation of the density of a forest
     stand using a new conditioned distance method. _Biometrika_ *63*,
     493-500.

     Cox, T.F. (1979) A method for mapping the dense and sparse regions
     of a forest stand. _Applied Statistics_ *28*, 14-19.

     Cox, T.F. and Lewis, T. (1976) A conditioned distance ratio method
     for analysing spatial patterns. _Biometrika_ *63*, 483-492.

     Diggle, P.J. (1979a) The detection of random heterogeneity in
     plant populations. _Biometrics_ *33*, 390-394.

     Diggle, P.J. (1979b) Statistical methods for spatial point
     patterns in ecology. _Spatial and temporal analysis in ecology_.
     R.M. Cormack and J.K. Ord (eds.) Fairland: International
     Co-operative Publishing House. pages 95-150.

     Diggle, P.J. (1981) Some graphical methods in the analysis of
     spatial point patterns. In _Interpreting Multivariate Data_. V.
     Barnett (eds.) John Wiley and Sons. Pages 55-73.

     Diggle, P.J. (1983) _Statistical analysis of spatial point
     patterns_. Academic Press.

     Gerrard, D.J. (1969) Competition quotient: a new measure of the
     competition affecting individual forest trees. Research Bulletin
     20, Agricultural Experiment Station, Michigan State University.

     Lotwick, H.W. (1981) _Spatial stochastic point processes_. PhD
     thesis, University of Bath, UK.

     Ord, J.K. (1978) How many trees in a forest? _Mathematical
     Scientist_ *3*, 23-33.

Examples
Run this code

          data(lansing)
       if(require(spatstat.geom)) {
          plot(lansing)
          summary(lansing)
          plot(split(lansing))
          plot(split(lansing)$maple)
          ##  rescale to feet
          (Lan <- rescale(lansing))
       }

