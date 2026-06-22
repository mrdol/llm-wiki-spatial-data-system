Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

coombs.rice.uniformity: Uniformity trial of rice in Malaysia

Uniformity trial of rice in Malaysia

Description

     Uniformity trial of rice in Malaysia

Usage

     data("coombs.rice.uniformity")

Format

     A data frame with 54 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield in gantangs per plot

Details

     Estimated harvest date is 1915 or earlier.

     Field length, 18 plots * 1/2 chain.

     Field width, 3 plots * 1/2 chain.

Source

     Coombs, G. E. and J. Grantham (1916).  Field Experiments and the
     Interpretation of their results.  The Agriculture Bulletin of the
     Federated Malay States, No 7.
     https://www.google.com/books/edition/The_Agricultural_Bulletin_of_the_Federat/M2E4AQAAMAAJ

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

yield: numeric ; missing=0 ; examples=13.6, 12, 11.4

Examples
Run this code

     ## Not run:

       library(agridat)
       data(coombs.rice.uniformity)
       dat <- coombs.rice.uniformity

       # Data check. Matches Coombs 709.4
       # sum(dat$yield)

       # There are an excess number of 12s and 14s in the yield
       libs(lattice)
       qqmath( ~ yield, dat) # weird

       libs(desplot)
       desplot(dat, yield ~ col*row,
               main="coombs.rice.uniformity",
               flip=TRUE, aspect=(18 / 3))
     ## End(Not run)

