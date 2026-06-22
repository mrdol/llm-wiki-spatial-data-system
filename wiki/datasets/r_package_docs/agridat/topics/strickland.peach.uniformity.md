Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

strickland.peach.uniformity: Uniformity trial of peach

Uniformity trial of peach

Description

     Uniformity trial of peach trees in Australia.

Usage

     data("strickland.peach.uniformity")

Format

     A data frame with 144 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, pounds per tree

Details

     Yields are the weight of peaches per individual tree in pounds.

Source

     A. G. Strickland (1935).  Error in horticultural experiments.
     Journal of Agriculture, Victoria, 33, 408-416.
     https://handle.slv.vic.gov.au/10381/386642

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: integer ; missing=0 ; examples=85, 72, 119

Examples
Run this code

     ## Not run:

     library(agridat)

       data(strickland.peach.uniformity)
       dat <- strickland.peach.uniformity

       mean(dat$yield) # 131.3, Strickland has 131.3
       sd(dat$yield)/mean(dat$yield) # 31.1, Strickland has 34.4

       libs(desplot)
       desplot(dat, yield ~ col*row,
               main="strickland.peach.uniformity",
               flip=TRUE, aspect=1)
     ## End(Not run)

