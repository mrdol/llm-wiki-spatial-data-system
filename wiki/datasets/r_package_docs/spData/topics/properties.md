Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

Dataset of properties in the municipality of Athens (sf)

Description

     A dataset of apartments in the municipality of Athens for 2017.
     Point location of the properties is given together with their main
     characteristics and the distance to the closest metro/train
     station.

Usage

     properties

Format

     An sf object of 1000 points with the following 6 variables.

        * id: An unique identifier for each property.

        * size : The size of the property (unit: square meters)

        * price : The asking price (unit: euros)

        * prpsqm : The asking price per squre meter (unit:
          euroes/square meter).

        * age : Age of property in 2017 (unit: years).

        * dist_metro: The distance to closest train/metro station
          (unit: meters).

See Also

     depmunic


Variables detected from installed object

id: character ; missing=0 ; examples=7836, 7238, 368

size: integer ; missing=0 ; examples=74, 77, 85

price: integer ; missing=0 ; examples=95000, 165000, 22000

prpsqm: numeric ; missing=0 ; examples=1283.78378378, 2142.85714286, 258.823529412

age: numeric ; missing=0 ; examples=47, 10, 42

dist_metro: numeric ; missing=0 ; examples=623.874637516, 509.471980965, 862.132568594

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       if (requireNamespace("spdep", quietly = TRUE)) {
         library(sf)
         library(spdep)

         data(properties)

         summary(properties$prpsqm)

         pr.nb.800 <- dnearneigh(properties, 0, 800)
         pr.listw <- nb2listw(pr.nb.800)

         moran.test(properties$prpsqm, pr.listw)
         moran.plot(properties$prpsqm, pr.listw, xlab = "Price/m^2", ylab = "Lagged")
       }
     }

