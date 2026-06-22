Rdocumentation
powered by

Search all packages and functions
GWmodel (version 2.4.1)

EWHP: House price data set (DataFrame) in England and Wales

House price data set (DataFrame) in England and Wales

Description

     A house price data set for England and Wales from 2001 with 9
     hedonic (explanatory) variables.

Usage

     data(EWHP)

Format

     A data frame with 519 observations on the following 12 variables.

     Easting a numeric vector, X coordinate

     Northing a numeric vector, Y coordinate

     PurPrice a numeric vector, the purchase price of the property

     BldIntWr a numeric vector, 1 if the property was built during the
          world war, 0 otherwise

     BldPostW a numeric vector, 1 if the property was built after the
          world war, 0 otherwise

     Bld60s a numeric vector, 1 if the property was built between 1960
          and 1969, 0 otherwise

     Bld70s a numeric vector, 1 if the property was built between 1970
          and 1979, 0 otherwise

     Bld80s a numeric vector, 1 if the property was built between 1980
          and 1989, 0 otherwise

     TypDetch a numeric vector, 1 if the property is detached (i.e. it
          is a stand-alone house), 0 otherwise

     TypSemiD a numeric vector, 1 if the property is semi detached, 0
          otherwise

     TypFlat a numeric vector, if the property is a flat (or
          'apartment' in the USA), 0 otherwise

     FlrArea a numeric vector, floor area of the property in square
          metres

Author(s):

     Binbin Lu <mailto:binbinlu@whu.edu.cn>

References

     Fotheringham, A.S., Brunsdon, C., and Charlton, M.E. (2002),
     Geographically Weighted Regression: The Analysis of Spatially
     Varying Relationships, Chichester: Wiley.


Variables detected from installed object

Easting: integer ; missing=0 ; examples=599500, 575400, 530300

Northing: integer ; missing=0 ; examples=142200, 167200, 177300

PurPrice: numeric ; missing=0 ; examples=65000, 45000, 50000

BldIntWr: integer ; missing=0 ; examples=0, 1

BldPostW: integer ; missing=0 ; examples=0

Bld60s: integer ; missing=0 ; examples=0

Bld70s: integer ; missing=0 ; examples=0

Bld80s: integer ; missing=0 ; examples=1, 0

TypDetch: integer ; missing=0 ; examples=0

TypSemiD: integer ; missing=0 ; examples=1, 0

TypFlat: integer ; missing=0 ; examples=0, 1

FlrArea: numeric ; missing=0 ; examples=78.947857262, 94.365909386, 41.331525273

Examples
Run this code

     ###
     data(EWHP)
     head(ewhp)
     houses.spdf <- SpatialPointsDataFrame(ewhp[, 1:2], ewhp)
      ####Get the border of England and Wales
     data(EWOutline)
     plot(ewoutline)
     plot(houses.spdf, add = TRUE, pch = 16)

