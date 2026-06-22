Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

besag.checks: Check variety yields in winter wheat.

Check variety yields in winter wheat.

Description

     Check variety yields in winter wheat.

Usage

     data("besag.checks")

Format

     A data frame with 364 observations on the following 4 variables.

     ‘yield’ yield, units of 10g

     ‘row’ row

     ‘col’ column

     ‘gen’ genotype/variety

Details

     This data was used by Besag to show the spatial variation in a
     field experiment, but Besag did not use the data for any analysis.

     Yields of winter wheat varieties (Bounty and Huntsman) at the
     Plant Breeding Institute, Cambridge, in 1980. These data are the
     'checks' genotypes in a larger variety trial.

     There is a column of checks, then five columns of new varieties.
     Repeat.

     Plot dimensions approx 1.5 by 4.5 metres

     Field length: 52 rows * 4.5 m = 234 m

     Field width: 31 columns * 1.5 m = 46.5

     Electronic version of data supplied by David Clifford.

Source

     Besag, J.E. & Kempton R.A. (1986).  Statistical analysis of field
     experiments using neighbouring plots.  Biometrics, 42, 231-251.
     https://doi.org/10.2307/2531047

References

     Kempton, Statistical Methods for Plant Variety Evaluation, page
     91-92


Variables detected from installed object

yield: integer ; missing=0 ; examples=385, 451, 359

row: integer ; missing=0 ; examples=52, 51, 50

col: integer ; missing=0 ; examples=1

gen: factor ; missing=0 ; examples=Huntsman, Bounty

Examples
Run this code

     ## Not run:

     library(agridat)
     data(besag.checks)
     dat <- besag.checks
       libs(desplot)
       desplot(dat, yield~col*row,
               num=gen, aspect=234/46.5, # true aspect
               main="besag.checks")
     ## End(Not run)

