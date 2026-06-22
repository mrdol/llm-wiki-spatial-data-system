Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

SplashDams: Data for Splash Dams in western Oregon

Data for Splash Dams in western Oregon

Description

     Data for Splash Dams in western Oregon

Usage

     SplashDams

Format

     Formal class 'SpatialPointsDataFrame with 232 obs. of 6 variables:

        * streamName

        * locationCode

        * height

        * lastDate

        * owner

        * datesUsed

Source

     R. R. Miller (2010) Is the Past Present? Historical Splash-dam
     Mapping and Stream Disturbance Detection in the Oregon Coastal
     Province. MSc. thesis, Oregon State University; packaged by
     Jonathan Callahan


Variables detected from installed object

streamName: factor ; missing=0 ; examples=Camp Creek, Mill Creek

locationCode: factor ; missing=0 ; examples=h

height: integer ; missing=201 ; examples=4, 10

lastDate: integer ; missing=22 ; examples=1956, 1957

owner: factor ; missing=54 ; examples=Gardiner Boom Company

datesUsed: factor ; missing=0 ; examples=1917-1956, 1917-1957

Examples
Run this code

     if (requireNamespace("sp", quietly = TRUE)) {
       library(sp)
       data(SplashDams)
       plot(SplashDams, axes=TRUE)
     }

