Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

theobald.barley: Multi-environment trial of barley, multiple years & fertilizer levels

Multi-environment trial of barley, multiple years & fertilizer levels

Description

     Barley yields at multiple locs, years, fertilizer levels

Usage

     data("theobald.barley")

Format

     A data frame with 105 observations on the following 5 variables.

     ‘yield’ yield, tonnes/ha

     ‘gen’ genotype

     ‘loc’ location, 5 levels

     ‘nitro’ nitrogen kg/ha

     ‘year’ year, 2 levels

Details

     Theobald and Talbot used BUGS to fit a fully Bayesian model for
     yield response curves.

     Locations of the experiment were in north-east Scotland.

     Assumed nitrogen cost 400 pounds per tonne.  Grain prices used
     were 100, 110, and 107.50 pounds per tonne for Georgie, Midas and
     Sundance.

Source

     Chris M. Theobald and Mike Talbot, (2002).  The Bayesian choice of
     crop variety and fertilizer dose.  _Appl Statistics_, 51, 23-36.
     https://doi.org/10.1111/1467-9876.04863

     Data provided by Chris Theobald and Mike Talbot.


Variables detected from installed object

yield: numeric ; missing=0 ; examples=4.206, 4.785, 4.501

gen: factor ; missing=0 ; examples=Georgie

loc: factor ; missing=0 ; examples=C1, C3, C4

nitro: integer ; missing=0 ; examples=0

year: integer ; missing=0 ; examples=1976

Examples
Run this code

     ## Not run:

     library(agridat)

     data(theobald.barley)
     dat <- theobald.barley
     dat <- transform(dat,  env=paste(loc,year,sep="-"))
     dat <- transform(dat, income=100*yield - 400*nitro/1000)

     libs(lattice)
     xyplot(income~nitro|env, dat, groups=gen, type='b',
            auto.key=list(columns=3), main="theobald.barley")
     ## End(Not run)

