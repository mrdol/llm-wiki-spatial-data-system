Rdocumentation
powered by

Search all packages and functions
sp (version 2.2.1)

meuse.grid: Prediction Grid for Meuse Data Set

Prediction Grid for Meuse Data Set

Description

     The ‘meuse.grid’ data frame has 3103 rows and 7 columns; a grid
     with 40 m x 40 m spacing that covers the Meuse study area (see
     meuse)

Usage

     data(meuse.grid)

Format

     This data frame contains the following columns:

     x a numeric vector; x-coordinate (see meuse)

     y a numeric vector; y-coordinate (see meuse)

     dist distance to the Meuse river; obtained by a spread (spatial
          distance) GIS operation, from border of river; normalized to
          $[0,1]$

     ffreq flooding frequency class, for definitions see this item in
          meuse; it is not known how this map was generated

     part.a arbitrary division of the area in two areas, a and b

     part.b see ‘part.a’

     soil soil type, for definitions see this item in meuse; it is
          questionable whether these data come from a real soil map,
          they do not match the published 1:50 000 map

Details

     ‘x’ and ‘y’ are in RD New, the Dutch topographical map coordinate
     system. Roger Bivand projected this to UTM in the R-Grass
     interface package.

References

     See the meuse documentation


Variables detected from installed object

x: numeric ; missing=0 ; examples=181180, 181140

y: numeric ; missing=0 ; examples=333740, 333700

part.a: numeric ; missing=0 ; examples=1

part.b: numeric ; missing=0 ; examples=0

dist: numeric ; missing=0 ; examples=0, 0.0122243

soil: factor ; missing=0 ; examples=1

ffreq: factor ; missing=0 ; examples=1

Examples
Run this code

     data(meuse.grid)
     coordinates(meuse.grid) = ~x+y
     proj4string(meuse.grid) <- CRS("+init=epsg:28992")
     gridded(meuse.grid) = TRUE
     spplot(meuse.grid)

