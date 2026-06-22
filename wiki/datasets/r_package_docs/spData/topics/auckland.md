Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

auckland: Marshall's infant mortality in Auckland dataset

Marshall's infant mortality in Auckland dataset

Description

     (Use ‘example(auckland)’ to load the data from shapefile and
     generate neighbour list on the fly).  The ‘auckland’ data frame
     has 167 rows (census area units - CAU) and 4 columns. The dataset
     also includes the "nb" object ‘auckland.nb’ of neighbour relations
     based on contiguity, and the "polylist" object ‘auckpolys’ of
     polygon boundaries for the CAU. The ‘auckland’ data frame includes
     the following columns:

Usage

     auckland

Format

     This data frame contains the following columns:

        * Easting: a numeric vector of x coordinates in an unknown
          spatial reference system

        * Northing: a numeric vector of y coordinates in an unknown
          spatial reference system

        * M77_85: a numeric vector of counts of infant (under 5 years
          of age) deaths in Auckland, 1977-1985

        * Und5_81: a numeric vector of population under 5 years of age
          at the 1981 Census

Details

     The contiguous neighbours object does not completely replicate
     results in the sources, and was reconstructed from ‘auckpolys’;
     examination of figures in the sources suggests that there are
     differences in detail, although probably not in substance.

Source

     Marshall R M (1991) Mapping disease and mortality rates using
     Empirical Bayes Estimators, Applied Statistics, 40, 283-294;
     Bailey T, Gatrell A (1995) Interactive Spatial Data Analysis,
     Harlow: Longman - INFOMAP data set used with permission.

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       auckland <- sf::st_read(system.file("shapes/auckland.gpkg", package="spData")[1])
       plot(sf::st_geometry(auckland))
       if (requireNamespace("spdep", quietly = TRUE)) {
         auckland.nb <- spdep::poly2nb(auckland)
       }
     }

