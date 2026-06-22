Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

christidis.wheat.uniformity: Uniformity trial of wheat

Uniformity trial of wheat

Description

     Uniformity trial of wheat at Cambridge, UK in 1931.

Usage

     data("christidis.wheat.uniformity")

Format

     A data frame with 288 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield

Details

     Two blocks, 24 rows each. In block A, each 90-foot row was divided
     into 12 units, each unit 7.5 feet long. Rows were 8 inches wide.

     Field width: 12 units * 7.5 feet = 90 feet

     Field length: 24 rows * 8 inches = 16 feet

Source

     Christidis, Basil G (1931).  The importance of the shape of plots
     in field experimentation.  _The Journal of Agricultural Science_,
     21, 14-37. Table VI, p. 28.
     https://dx.doi.org/10.1017/S0021859600007942

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: integer ; missing=0 ; examples=85, 87, 88

Examples
Run this code

     ## Not run:

     library(agridat)
     data(christidis.wheat.uniformity)
     dat <- christidis.wheat.uniformity

     # sum(dat$yield) # Matches Christidis

      libs(desplot)
      desplot(dat, yield ~  col*row,
              flip=TRUE, aspect=16/90, # true aspect
              main="christidis.wheat.uniformity")
     ## End(Not run)

