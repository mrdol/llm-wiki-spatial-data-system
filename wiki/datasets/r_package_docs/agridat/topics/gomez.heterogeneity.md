Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

gomez.heterogeneity: RCB experiment of rice, heterogeneity of regressions

RCB experiment of rice, heterogeneity of regressions

Description

     RCB experiment of rice, heterogeneity of regressions

Usage

     data("gomez.heterogeneity")

Format

     ‘gen’ genotype

     ‘yield’ yield kg/ha

     ‘tillers’ tillers no/hill

Details

     An experiment with 3 genotypes to examine the relationship of
     yield to number of tillers.

     Used with permission of Kwanchai Gomez.

Source

     Gomez, K.A. and Gomez, A.A.. 1984, Statistical Procedures for
     Agricultural Research.  Wiley-Interscience.  Page 377.

References

     None.


Variables detected from installed object

gen: factor ; missing=0 ; examples=IR15114A

yield: integer ; missing=0 ; examples=5932, 4050, 4104

tillers: numeric ; missing=0 ; examples=7.98, 5.72, 4.95

Examples
Run this code

     ## Not run:

     library(agridat)
     data(gomez.heterogeneity)
     dat <- gomez.heterogeneity

       libs(lattice)
       xyplot(yield ~ tillers, dat, groups=gen,
              type=c("p","r"),
              main="gomez.heterogeneity")
     ## End(Not run)

