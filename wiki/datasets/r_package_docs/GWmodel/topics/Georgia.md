Rdocumentation
powered by

Search all packages and functions
GWmodel (version 2.4.1)

Georgia census data set (csv file)

Description

     Census data from the county of Georgia, USA

Usage

     data(Georgia)

Format

     A data frame with 159 observations on the following 13 variables.

     AreaKey An identification number for each county

     Latitude The latitude of the county centroid

     Longitud The longitude of the county centroid

     TotPop90 Population of the county in 1990

     PctRural Percentage of the county population defined as rural

     PctBach Percentage of the county population with a bachelors
          degree

     PctEld Percentage of the county population aged 65 or over

     PctFB Percentage of the county population born outside the US

     PctPov Percentage of the county population living below the
          poverty line

     PctBlack Percentage of the county population who are black

     ID a numeric vector of IDs

     X a numeric vector of x coordinates

     Y a numeric vector of y coordinates

Details

     This data set can also be found in GWR 3 and in spgwr.

References

     Fotheringham S, Brunsdon, C, and Charlton, M (2002),
     Geographically Weighted Regression: The Analysis of Spatially
     Varying Relationships, Chichester: Wiley.


Variables detected from installed object

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

     data(Georgia)
     ls()
     coords <- cbind(Gedu.df$X, Gedu.df$Y)
     educ.spdf <- SpatialPointsDataFrame(coords, Gedu.df)
     spplot(educ.spdf, names(educ.spdf)[4:10])

