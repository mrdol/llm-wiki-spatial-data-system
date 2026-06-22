Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

measles.weser: Measles in the Weser-Ems region of Lower Saxony, Germany, 2001-2002

Measles in the Weser-Ems region of Lower Saxony, Germany, 2001-2002

Description

     Weekly counts of new measles cases for the 17 administrative
     districts (NUTS-3 level) of the “Weser-Ems” region of Lower
     Saxony, Germany, during 2001 and 2002, as reported to the Robert
     Koch institute according to the Infection Protection Act
     (“Infektionsschutzgesetz”, IfSG).
     ‘data("measlesWeserEms")’ is a corrected version of
     ‘data("measles.weser")’ (see Format section below).  These data
     are illustrated and analyzed in Meyer et al. (2017, Section 5),
     see ‘vignette("hhh4_spacetime")’.

Usage

     data("measles.weser")
     data("measlesWeserEms")

Format

     ‘data("measles.weser")’ is an object of the old ‘"disProg"’ class,
     whereas ‘data("measlesWeserEms")’ is of the new class ‘"sts"’.

     Furthermore, the following updates have been applied for
     ‘data("measlesWeserEms")’:

        * it includes the two districts “SK Delmenhorst” (03401) and
          “SK Wilhemshaven” (03405) with zero counts, which are ignored
          in ‘data("measles.weser")’.

        * it corrects the time lag error for year 2002 caused by a
          redundant pseudo-week “0” with 0 counts only (the row
          ‘measles.weser$observed[53,]’ is nonsense).

        * it has one more case attributed to “LK Oldenburg” (03458)
          during 2001/W17, i.e., 2 cases instead of 1. This reflects
          the official data as of “Jahrbuch 2005”, whereas
          ‘data("measles.weser")’ is as of “Jahrbuch 2004”.

        * it contains a map of the region (as a
          ‘"SpatialPolygonsDataFrame"’) with the following variables:

          ‘GEN’ district label.

          ‘AREA’ district area in m^2.

          ‘POPULATION’ number of inhabitants (as of 31/12/2003).

          ‘vaccdoc.2004’ proportion with a vaccination card among
              screened abecedarians (2004).

          ‘vacc1.2004’ proportion with at least one vaccination against
              measles among abecedarians presenting a vaccination card
              (2004).

          ‘vacc2.2004’ proportion of doubly vaccinated abecedarians
              among the ones presenting their vaccination card at
              school entry in the year 2004.

        * it uses the correct format for the official district keys,
          i.e., 5 digits (initial 0).

        * its attached neighbourhood matrix is more general: a distance
          matrix (neighbourhood orders) instead of just an adjacency
          indicator matrix (special case ‘nbOrder == 1’).

        * population fractions represent data as of 31/12/2003 (LSN,
          2004, document “A I 2 - hj 2 / 2003”). There are only minor
          differences to the ones used for ‘data("measles.weser")’.

Source

     Measles counts were obtained from the public SurvStat database of
     the Robert Koch institute: <https://survstat.rki.de/>.

     A shapefile of Germany's districts as of 01/01/2009 was obtained
     from the German Federal Agency for Cartography and Geodesy
     (<https://gdz.bkg.bund.de/>).  The map of the 17 districts of the
     “Weser-Ems” region (‘measlesWeserEms@map’) is a simplified subset
     of this shapefile using a 30% reduction via the Douglas-Peucker
     reduction method as implemented at <https://MapShaper.org>.

     Population numbers were obtained from the Federal Statistical
     Office of Lower Saxony (LSN).

     Vaccination coverage was obtained from the public health
     department of Lower Saxony (NLGA, “Impfreport”).

References

     Meyer, S., Held, L. and Höhle, M. (2017): Spatio-temporal analysis
     of epidemic phenomena using the R package ‘surveillance’.
     _Journal of Statistical Software_, *77* (11), 1-55.
     doi:10.18637/jss.v077.i11 <https://doi.org/10.18637/jss.v077.i11>

Examples
Run this code

     ## old "disProg" object
     data("measles.weser")
     measles.weser
     plot(measles.weser, as.one=FALSE)

     ## new "sts" object (with corrections)
     data("measlesWeserEms")
     measlesWeserEms
     plot(measlesWeserEms)

