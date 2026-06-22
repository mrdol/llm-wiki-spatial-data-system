Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

baltimore: House sales prices, Baltimore, MD 1978

House sales prices, Baltimore, MD 1978

Description

     House sales price and characteristics for a spatial hedonic
     regression, Baltimore, MD 1978. X,Y on Maryland grid, projection
     type unknown.

Usage

     baltimore

Format

     A data frame with 211 observations on the following 17 variables.

        * STATION: a numeric vector

        * PRICE: a numeric vector

        * NROOM: a numeric vector

        * DWELL: a numeric vector

        * NBATH: a numeric vector

        * PATIO: a numeric vector

        * FIREPL: a numeric vector

        * AC: a numeric vector

        * BMENT: a numeric vector

        * NSTOR: a numeric vector

        * GAR: a numeric vector

        * AGE: a numeric vector

        * CITCOU: a numeric vector

        * LOTSZ: a numeric vector

        * SQFT: a numeric vector

        * X: a numeric vector

        * Y: a numeric vector

Source

     Prepared by Luc Anselin. Original data made available by Robin
     Dubin, Weatherhead School of Management, Case Western Research
     University, Cleveland, OH.
     http://sal.agecon.uiuc.edu/datasets/baltimore.zip

References

     Dubin, Robin A. (1992). Spatial autocorrelation and neighborhood
     quality. Regional Science and Urban Economics 22(3), 433-452.


Variables detected from installed object

STATION: integer ; missing=0 ; examples=1, 2, 3

PRICE: numeric ; missing=0 ; examples=47, 113, 165

NROOM: numeric ; missing=0 ; examples=4, 7

DWELL: numeric ; missing=0 ; examples=0, 1

NBATH: numeric ; missing=0 ; examples=1, 2.5

PATIO: numeric ; missing=0 ; examples=0, 1

FIREPL: numeric ; missing=0 ; examples=0, 1

AC: numeric ; missing=0 ; examples=0, 1

BMENT: numeric ; missing=0 ; examples=2, 3

NSTOR: numeric ; missing=0 ; examples=3, 2

GAR: numeric ; missing=0 ; examples=0, 2

AGE: numeric ; missing=0 ; examples=148, 9, 23

CITCOU: numeric ; missing=0 ; examples=0, 1

LOTSZ: numeric ; missing=0 ; examples=5.7, 279.51, 70.64

SQFT: numeric ; missing=0 ; examples=11.25, 28.92, 30.62

X: numeric ; missing=0 ; examples=907, 922, 920

Y: numeric ; missing=0 ; examples=534, 574, 581

Examples
Run this code

     data(baltimore)
     str(baltimore)

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       baltimore_sf <- baltimore %>% st_as_sf(., coords = c("X","Y"))
       plot(baltimore_sf["PRICE"])
     }

