Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

meuse.alt: Meuse river altitude data set

Meuse river altitude data set

Description

     This data set gives a point set with altitudes, digitized from the
     1:10,000 topographical map of the Netherlands.

Usage

     data(meuse.alt)

Format

     This data frame contains the following columns:

     x a numeric vector; x-coordinate (m) in RDM (Dutch topographical
          map coordinates)

     y a numeric vector; y-coordinate (m) in RDM (Dutch topographical
          map coordinates)

     alt altitude in m. above NAP (Dutch zero for sea level)

See Also

     meuse.all


Variables detected from installed object

x: numeric ; missing=0 ; examples=180332.41, 180427, 180473

y: numeric ; missing=0 ; examples=333022.5, 333028.63, 333179.69

alt: numeric ; missing=0 ; examples=37.8, 36.4, 38

Examples
Run this code

     data(meuse.alt)
     library(lattice)
     xyplot(y~x, meuse.alt, aspect = "iso")

