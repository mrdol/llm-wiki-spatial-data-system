Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

scotland: Lip Cancer in Scotland

Lip Cancer in Scotland

Description

     County-level (n=56) data for lip cancer among males in Scotland
     between 1975-1980

Usage

     scotland

Format

     List containing:

     geo a table of county IDs, x-coordinates (eastings) and
          y-coordinates (northings) of the geographic centroid of each
          county.

     data a table of county IDs, number of cases, population and strata
          information

     spatial.polygon a Spatial Polygons class (See
          SpatialPolygons-class) map of Scotland

     polygon a polygon map of Scotland (See ‘polygon2spatial_polygon()’

Source

     Kemp I., Boyle P., Smans M. and Muir C. (1985) Atlas of cancer in
     Scotland, 1975-1980, incidence and epidemiologic perspective
     _International Agency for Research on Cancer_ *72*.

References

     Clayton D. and Kaldor J. (1987) Empirical Bayes estimates of
     age-standardized relative risks for use in disease mapping.
     _Biometrics_, *43*, 671-681.

Examples
Run this code

     data(scotland)
     data <- scotland$data
     scotland.map <- scotland$spatial.polygon
     SMR <- data$cases/data$expected
     mapvariable(SMR,scotland.map)

