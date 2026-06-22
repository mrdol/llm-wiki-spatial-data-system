Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

rangaswamy.groundnut.uniformity: Uniformity trial of groundnut

Uniformity trial of groundnut

Description

     Uniformity trial of groundnut

Usage

     data("rangaswamy.groundnut.uniformity")

Format

     A data frame with 96 observations on the following 3 variables.

     ‘row’ row ordinate

     ‘col’ column ordinate

     ‘yield’ yield, kg/plot

Details

     The year of the experiment is unknown, but before 1995.

     Field width: 8 plots x 4 m = 32 m

     Field length: 12 plots x .75 m = 8 m

Source

     R. Rangaswamy. (1995).  A Text Book of Agricultural Statistics.
     New Age International Publishers.  Table 19.1. Page 237.
     https://www.google.com/books/edition/A_Text_Book_of_Agricultural_Statistics/QDLWE4oakSgC

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=0.7, 0.9, 0.85

Examples
Run this code

     ## Not run:

     library(agridat)
     data(rangaswamy.groundnut.uniformity)
     dat <- rangaswamy.groundnut.uniformity

     require(desplot)
     desplot(dat, yield ~ col*row,
             flip=TRUE, aspect=(12*.75)/(8*4),
             main="rangaswamy.groundnut.uniformity")
     ## End(Not run)

