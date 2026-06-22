Rdocumentation
powered by

Search all packages and functions
GWmodel (version 2.4.1)

LondonHP: London house price data set (SpatialPointsDataFrame)

London house price data set (SpatialPointsDataFrame)

Description

     A house price data set with 18 hedonic variables for London in
     2001.

Usage

     data(LondonHP)

Format

     A SpatialPointsDataFrame object (proj4string set to
     "+init=epsg:27700 +datum=OSGB36").

     The "data" slot is a data frame with 372 observations on the
     following 21 variables.

     X a numeric vector, X coordinate

     Y a numeric vector, Y coordinate

     PURCHASE a numeric vector, the purchase price of the property

     FLOORSZ a numeric vector, floor area of the property in square
          metres

     TYPEDETCH a numeric vector, 1 if the property is detached (i.e. it
          is a stand-alone house), 0 otherwise

     TPSEMIDTCH a numeric vector, 1 if the property is semi detached, 0
          otherwise

     TYPETRRD a numeric vector, 1 if the property is in a terrace of
          similar houses (commonly referred to as a 'row house' in the
          USA), 0 otherwise

     TYPEBNGLW a numeric vector, if the property is a bungalow (i.e. it
          has only one floor), 0 otherwise

     TYPEFLAT a numeric vector, if the property is a flat (or
          'apartment' in the USA), 0 otherwise

     BLDPWW1 a numeric vector, 1 if the property was built prior to
          1914, 0 otherwise

     BLDPOSTW a numeric vector, 1 if the property was built between
          1940 and 1959, 0 otherwise

     BLD60S a numeric vector, 1 if the property was built between 1960
          and 1969, 0 otherwise

     BLD70S a numeric vector, 1 if the property was built between 1970
          and 1979, 0 otherwise

     BLD80S a numeric vector, 1 if the property was built between 1980
          and 1989, 0 otherwise

     BLD90S a numeric vector, 1 if the property was built between 1990
          and 2000, 0 otherwise

     BATH2 a numeric vector, 1 if the property has more than 2
          bathrooms, 0 otherwise

     GARAGE a numeric vector,1 if the house has a garage, 0 otherwise

     CENTHEAT a numeric vector, 1 if the house has central heating, 0
          otherwise

     BEDS2 a numeric vector, 1 if the property has more than 2
          bedrooms, 0 otherwise

     UNEMPLOY a numeric vector, the rate of unemployment in the census
          ward in which the house is located

     PROF a numeric vector, the proportion of the workforce in
          professional or managerial occupations in the census ward in
          which the house is located

Author(s):

     Binbin Lu <mailto:binbinlu@whu.edu.cn>

References

     Fotheringham, A.S., Brunsdon, C., and Charlton, M.E. (2002),
     Geographically Weighted Regression: The Analysis of Spatially
     Varying Relationships, Chichester: Wiley.

     Lu, B, Charlton, M, Harris, P, Fotheringham, AS (2014)
     Geographically weighted regression with a non-Euclidean distance
     metric: a case study using hedonic house price data.
     International Journal of Geographical Information Science 28(4):
     660-681


Variables detected from installed object

PURCHASE: numeric ; missing=0 ; examples=157000, 113500, 81750

FLOORSZ: numeric ; missing=0 ; examples=77, 75, 64

TYPEDETCH: integer ; missing=0 ; examples=1, 0

TPSEMIDTCH: integer ; missing=0 ; examples=0

TYPETRRD: integer ; missing=0 ; examples=0, 1

TYPEBNGLW: integer ; missing=0 ; examples=1, 0

TYPEFLAT: integer ; missing=0 ; examples=0, 1

BLDPWW1: integer ; missing=0 ; examples=0, 1

BLDPOSTW: integer ; missing=0 ; examples=0

BLD60S: integer ; missing=0 ; examples=0

BLD70S: integer ; missing=0 ; examples=0

BLD80S: integer ; missing=0 ; examples=0, 1

BLD90S: integer ; missing=0 ; examples=0

BATH2: integer ; missing=0 ; examples=0

BEDS2: integer ; missing=0 ; examples=1, 0

GARAGE1: integer ; missing=0 ; examples=0, 1

CENTHEAT: integer ; missing=0 ; examples=1, 0

UNEMPLOY: numeric ; missing=0 ; examples=0.0356676816007

PROF: numeric ; missing=0 ; examples=0.478699211643

BLDINTW: integer ; missing=0 ; examples=1, 0

Examples
Run this code

     data(LondonHP)
     data(LondonBorough)
     ls()
     plot(londonborough)
     plot(londonhp, add=TRUE)

