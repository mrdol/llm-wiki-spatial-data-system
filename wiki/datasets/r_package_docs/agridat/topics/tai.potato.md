Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

tai.potato: Multi-environment trial of potato

Multi-environment trial of potato

Description

     Multi-environment trial of potato tuber yields

Usage

     data("tai.potato")

Format

     A data frame with 48 observations on the following 6 variables.

     ‘yield’ yield, kg/plot

     ‘gen’ genotype code

     ‘variety’ variety name

     ‘env’ environment code

     ‘loc’ location

     ‘year’ year

Details

     Mean tuber yield of 8 genotypes in 3 locations over two years.
     Katahdin and Sebago are check varieties.  Each location was
     planted as a 4-rep RCB design.

     In Tai's plot of the stability parameters, F5751 and Sebago were
     in the average stability area.  The highest yielding genotype
     F6032 had an unstable performance.

Source

     G.C.C. Tai, 1971.  Genotypic stability analysis and its
     application to potato regional trials.  Crop Sci 11, 184-190.
     Table 2, p. 187.
     https://doi.org/10.2135/cropsci1971.0011183X001100020006x

References

     George Fernandez (1991).  Analysis of Genotype x Environment
     Interaction by Stability Estimates.  _Hort Science_, 26, 947-950.


Variables detected from installed object

yield: numeric ; missing=0 ; examples=11.72, 9.39, 19.32

gen: factor ; missing=0 ; examples=G1

variety: factor ; missing=0 ; examples=F5317

env: factor ; missing=0 ; examples=E1, E2, E3

loc: factor ; missing=0 ; examples=NB, NS

year: integer ; missing=0 ; examples=65, 66

Examples
Run this code

     ## Not run:

     library(agridat)
     data(tai.potato)
     dat <- tai.potato

     libs(lattice)
     dotplot(variety ~ yield|env, dat, main="tai.potato")

     # fixme - need to add tai() example

     # note, st4gi::tai assumes there are replications in the data
     # https://github.com/reyzaguirre/st4gi/blob/master/R/tai.R
     ## End(Not run)

