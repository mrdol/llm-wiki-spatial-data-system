Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

cochran.bib: Multi-environment trial of corn, balanced incomplete block design

Multi-environment trial of corn, balanced incomplete block design

Description

     Balanced incomplete block design in corn

Format

     A data frame with 52 observations on the following 3 variables.

     ‘loc’ location/block, 13 levels

     ‘gen’ genotype/line, 13 levels

     ‘yield’ yield, pounds/plot

Details

     Incomplete block design.  Each loc/block has 4 genotypes/lines.
     The blocks are planted at different locations.

     Conducted in 1943 in North Carolina.

Source

     North Carolina Agricultural Experiment Station, United States
     Department of Agriculture.

References

     Cochran, W.G. and Cox, G.M. (1957), _Experimental Designs_, 2nd
     ed., Wiley and Sons, New York, p. 448.


Variables detected from installed object

loc: factor ; missing=0 ; examples=B01

gen: factor ; missing=0 ; examples=G03, G06, G09

yield: numeric ; missing=0 ; examples=25.3, 19.9, 29

Examples
Run this code

     ## Not run:

     library(agridat)

     data(cochran.bib)
     dat <- cochran.bib

     # Show the incomplete-block structure
     libs(lattice)
     redblue <- colorRampPalette(c("firebrick", "lightgray", "#375997"))
     levelplot(yield~loc*gen, dat,
               col.regions=redblue,
               xlab="loc (block)", main="cochran.bib - incomplete blocks")

     with(dat, table(gen,loc))
     rowSums(as.matrix(with(dat, table(gen,loc))))
     colSums(as.matrix(with(dat, table(gen,loc))))

     m1 = aov(yield ~ gen + Error(loc), data=dat)
     summary(m1)

     libs(nlme)
     m2 = lme(yield ~ -1 + gen, data=dat, random=~1|loc)
     ## End(Not run)

