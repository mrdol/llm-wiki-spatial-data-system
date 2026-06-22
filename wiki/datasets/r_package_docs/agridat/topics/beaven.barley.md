Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

beaven.barley: Yields of 8 barley varieties in 1913 as used by Student.

Yields of 8 barley varieties in 1913 as used by Student.

Description

     Yields of 8 barley varieties in 1913.

Usage

     data("beaven.barley")

Format

     A data frame with 160 observations on the following 4 variables.

     ‘row’ row

     ‘col’ column

     ‘gen’ genotype

     ‘yield’ yield (grams)

Details

     Eight races of barley were grown on a regular pattern of plots.

     These data were prepared from Richey (1926) because the text was
     cleaner.

     Each plot was planted 40 inches on a side, but only the middle
     square 36 inches on a side was harvested.

     Field width: 32 plots * 3 feet = 96 feet

     Field length: 5 plots * 3 feet = 15 feet

Source

     Student. (1923).  On testing varieties of cereals.  _Biometrika_,
     271-293.

     https://doi.org/10.1093/biomet/15.3-4.271

References

     Frederick D. Richey (1926).  The moving average as a basis for
     measuring correlated variation in agronomic experiments.  _Jour.
     Agr. Research_, 32, 1161-1175.


Variables detected from installed object

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

gen: factor ; missing=0 ; examples=a, f, c

yield: numeric ; missing=0 ; examples=236.5, 210.4, 291.1

Examples
Run this code

     ## Not run:

     library(agridat)

     data(beaven.barley)
     dat <- beaven.barley

     # Match the means shown in Richey table IV
     tapply(dat$yield, dat$gen, mean)
     ##       a       b       c       d       e       f       g       h
     ## 298.080 300.710 318.685 295.260 306.410 276.475 304.605 271.820

     # Compare to Student 1923, diagram I,II
     libs(desplot)
     desplot(dat, yield ~ col*row,
             aspect=15/96, # true aspect
             main="beaven.barley - variety trial", text=gen)
     ## End(Not run)

