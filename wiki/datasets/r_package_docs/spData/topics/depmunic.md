Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

depmunic: Municipality departments of Athens (Sf)

Municipality departments of Athens (Sf)

Description

     The geographic boundaries of departments (sf) of the municipality
     of Athens. This is accompanied by various characteristics in these
     areas.

Usage

     depmunic

Format

     An sf object of 7 polygons with the following 7 variables.

        * num_dep: An unique identifier for each municipality
          department.

        * airbnb: The number of airbnb properties in 2017

        * museums: The number of museums

        * population: The population recorded in census at 2011.

        * pop_rest: The number of citizens that the origin is a non
          european country.

        * greensp: The area of green spaces (unit: square meters).

        * area: The area of the polygon (unit: square kilometers).

See Also

     properties


Variables detected from installed object

num_dep: integer ; missing=0 ; examples=1, 2, 3

airbnb: numeric ; missing=0 ; examples=2171, 721, 524

museums: numeric ; missing=0 ; examples=17, 1, 0

population: numeric ; missing=0 ; examples=72962, 102439, 45168

pop_rest: numeric ; missing=0 ; examples=8202, 5009, 2735

greensp: numeric ; missing=0 ; examples=433582, 478951, 43311.6

area: numeric ; missing=0 ; examples=7.20501858229, 4.83593499111, 5.61876557098

geometry: sfc_POLYGON/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(depmunic)

       depmunic$foreigners <- 100*depmunic$pop_rest/depmunic$population
       plot(depmunic["foreigners"], key.pos=1)
     }

