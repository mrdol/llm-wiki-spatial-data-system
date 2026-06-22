Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

buntaran.wheat: Multi-environment trial of wheat in Sweden in 2016.

Multi-environment trial of wheat in Sweden in 2016.

Description

     Multi-environment trial of wheat in Sweden in 2016.

Usage

     data("buntaran.wheat")

Format

     A data frame with 1069 observations on the following 7 variables.

     ‘zone’ Geographic zone: south, middle, north

     ‘loc’ Location

     ‘rep’ Block replicate (up to 4)

     ‘alpha’ Incomplete-block in the alpha design

     ‘gen’ Genotype (cultivar)

     ‘yield’ Dry matter yield, kg/ha

Details

     Dry matter yield from wheat trials in Sweden in 2016. The
     experiments in each location were multi-rep with incomplete blocks
     in an alpha design.

     Electronic data are from the online supplement of Buntaran (2020)
     and also from the "init" package at
     https://github.com/Flavjack/inti.

Source

     Buntaran, Harimurti et al. (2020).  Cross-validation of stagewise
     mixed-model analysis of Swedish variety trials with winter wheat
     and spring barley.  Crop Science, 60, 2221-2240.
     http://doi.org/10.1002/csc2.20177

References

     None.


Variables detected from installed object

zone: factor ; missing=0 ; examples=south

loc: factor ; missing=0 ; examples=07bm20

rep: factor ; missing=0 ; examples=R1, R2

alpha: factor ; missing=0 ; examples=A2, A3, A7

gen: factor ; missing=0 ; examples=G22455, G23286

yield: numeric ; missing=0 ; examples=727.3249, 721.4117, 830.3894

Examples
Run this code

     ## Not run:

     data(buntaran.wheat)
     library(agridat)
     dat <- buntaran.wheat
     library(lattice)
     bwplot(yield~loc|zone, dat, layout=c(1,3),
            scales=list(x=list(rot=90)),
            main="buntaran.wheat")
     ## End(Not run)

