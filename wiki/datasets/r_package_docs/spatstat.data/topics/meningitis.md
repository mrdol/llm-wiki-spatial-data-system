Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

meningitis: Invasive Meningococcal Disease Cases in Germany

Invasive Meningococcal Disease Cases in Germany

Description

     Spatial locations of cases of invasive meningococcal disease in
     Germany, and information on the population density.

Usage

     data(meningitis)

Format

     ‘meningitis’ is a list (of class ‘"solist"’) containing two
     entries,

        * ‘cases’: a multitype point pattern (object of class ‘"ppp"’)
          giving the spatial location of each case.  Points are
          classified into types B and C according to the serotype for
          each case.

        * ‘kreise’: a tessellation (object of class ‘"tess"’) giving
          the division of Germany into administrative districts
          (Kreise).  Tiles are marked with a numeric estimate of the
          average population density.

Details

     These data give the spatial locations of 636 cases of invasive
     meningococcal disease in Germany, together with information on the
     division of Germany into administrative districts, and estimates
     of population density in each district.

     The data were extracted from the dataset ‘imdepi’ in the package
     ‘surveillance’. They have been simplified and converted to
     ‘spatstat’ format.  The original data were analysed by Meyer,
     Elias and Hoehle (2012).  The simplified data provided here were
     analysed in Baddeley, Davies and Hazelton (2025).

     The dataset ‘meningitis’ is a list (of class ‘"solist"’)
     containing two elements, ‘cases’ and ‘kreise’.

     The first element ‘cases’ is a spatial point pattern (object of
     class ‘"ppp"’) containing 636 points giving the locations of the
     cases. This is a multitype point pattern, that is, it has marks
     which are categorical values, classifying each point into type B
     or C, according to the serotype of each case.  According to the
     ‘surveillance’ documentation, these data are from cases caused by
     the two most common meningococcal finetypes in Germany,
     ‘B:P1.7-2,4:F1-5’ (of serogroup B) and ‘C:P1.5,2:F3-3’ (of
     serogroup C).  The observation window for the point pattern is a
     polygonal representation of the national border of Germany.
     Coordinates are given in kilometres.

     The second element ‘kreise’ is a tessellation (object of class
     ‘"tess"’) giving the division of Germany into administrative
     districts. Each tile of the tessellation is marked by a numerical
     value which is an estimate of the average population density
     (people per square kilometre) in the district.

Source

     Obtained from package ‘surveillance’.

     IMD case reports: German Reference Centre for Meningococci at the
     Department of Hygiene and Microbiology,
     Julius-Maximilians-Universitaet Universitaet Wuerzburg, Germany
     (<https://www.hygiene.uni-wuerzburg.de/meningococcus/>).  Thanks
     to Dr. Johannes Elias and Prof. Dr. Ulrich Vogel for providing the
     data.

     Shapefile of Germany's districts as at 2009-01-01: German Federal
     Agency for Cartography and Geodesy, Frankfurt am Main, Germany,
     <https://gdz.bkg.bund.de/>.

References

     Meyer, S., Elias, J. and Hoehle, M.  (2012): A space-time
     conditional intensity model for invasive meningococcal disease
     occurrence. _Biometrics_, *68*, 607-616.
     doi:10.1111/j.1541-0420.2011.01684.x

     Baddeley, A., Davies, T.M. and Hazelton, M.L. (2025) An improved
     estimator of the pair correlation function of a spatial point
     process. _Biometrika_, to appear.

Examples
Run this code

        if(require(spatstat.geom)) {
          plot(meningitis$cases)
          plot(meningitis$kreise, do.col=TRUE, col=grey(seq(1, 0, length=32)))
          ## count cases in each district
          qc <- with(meningitis, quadratcount(cases, tess=kreise))
        }

