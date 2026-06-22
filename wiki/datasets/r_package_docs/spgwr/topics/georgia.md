Rdocumentation
powered by

Search all packages and functions
spgwr (version 0.6.37)

georgia: Georgia census data set (SpatialDataFramePolygons)

Georgia census data set (SpatialDataFramePolygons)

Description

     The Georgia census data set from Fotheringham et al. (2002) in
     GPKG format.

Usage

     data(georgia)

Format

     A SpatialPolygonsDataFrame object.

     The "data" slot is a data frame with 159 observations on the
     following 13 variables.

     AreaKey a numeric vector

     Latitude a numeric vector

     Longitud a numeric vector

     TotPop90 a numeric vector

     PctRural a numeric vector

     PctBach a numeric vector

     PctEld a numeric vector

     PctFB a numeric vector

     PctPov a numeric vector

     PctBlack a numeric vector

     ID a numeric vector

     X a numeric vector

     Y a numeric vector

Details

     Variables are from GWR3 file GeorgiaData.csv.

Source

     Originally:
     http://www.census.gov/geo/cob/bdy/co/co90shp/co13_d90_shp.zip,
     currently behind:
     <https://www.census.gov/geographies/mapping-files/time-series/geo/carto-boundary-file.1990.html>
     choosing 1990 Census and Georgia; <http://gwr.nuim.ie/>

References

     Fotheringham, A.S., Brunsdon, C., and Charlton, M.E., 2002,
     Geographically Weighted Regression: The Analysis of Spatially
     Varying Relationships, Chichester: Wiley.


Variables detected from installed object

SR_ID: factor ; missing=0 ; examples=1, 2, 3

AreaKey: integer ; missing=0 ; examples=13001, 13003, 13005

Latitude: numeric ; missing=0 ; examples=31.75339, 31.29486, 31.55678

Longitud: numeric ; missing=0 ; examples=-82.28558, -82.87474, -82.45115

TotPop90: integer ; missing=0 ; examples=15744, 6213, 9566

PctRural: numeric ; missing=0 ; examples=75.6, 100, 61.7

PctBach: numeric ; missing=0 ; examples=8.2, 6.4, 6.6

PctEld: numeric ; missing=0 ; examples=11.43, 11.77, 11.11

PctFB: numeric ; missing=0 ; examples=0.64, 1.58, 0.27

PctPov: numeric ; missing=0 ; examples=19.9, 26, 24.1

PctBlack: numeric ; missing=0 ; examples=20.76, 26.86, 15.42

ID: integer ; missing=0 ; examples=133, 158, 146

X: numeric ; missing=0 ; examples=941396.6, 895553, 930946.4

Y: numeric ; missing=0 ; examples=3521764, 3471916, 3502787

Examples
Run this code

     data(georgia)
     plot(gSRDF)
     data(gSRouter)

