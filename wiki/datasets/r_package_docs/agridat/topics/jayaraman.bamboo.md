Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

jayaraman.bamboo: Bamboo progeny trial

Bamboo progeny trial

Description

     Bamboo progeny trial in 2 locations, 3 blocks

Usage

     data("jayaraman.bamboo")

Format

     A data frame with 216 observations on the following 5 variables.

     ‘loc’ location factor

     ‘block’ block factor

     ‘tree’ tree factor

     ‘family’ family factor

     ‘height’ height, cm

Details

     Data from a replicated trial of bamboo at two locations in Kerala,
     India.  Each location had 3 blocks.  In each block were 6
     families, with 6 trees in each family.

Source

     K. Jayaraman (1999). "A Statistical Manual For Forestry Research".
     Forestry Research Support Programme for Asia and the Pacific. Page
     170.

References

     None


Variables detected from installed object

loc: factor ; missing=0 ; examples=Vellanikkara

block: factor ; missing=0 ; examples=B1

tree: factor ; missing=0 ; examples=T1, T2, T3

family: factor ; missing=0 ; examples=F1

height: integer ; missing=0 ; examples=142, 95, 138

Examples
Run this code

     ## Not run:

       library(agridat)
       data(jayaraman.bamboo)
       dat <- jayaraman.bamboo

       # very surprising differences between locations
       libs(lattice)
       bwplot(height ~ family|loc, dat, main="jayaraman.bamboo")
       # match Jayarman's anova table 6.3, page 173
       # m1 <- aov(height ~ loc+loc:block + family + family:loc +
       #  family:loc:block, data=dat)
       # anova(m1)

       # more modern approach with mixed model, match variance components needed
       # for equation 6.9, heritability of the half-sib averages as
       m2 <- lme4::lmer(height ~ 1 + (1|loc/block) + (1|family/loc/block), data=dat)
       lucid::vc(m2)
     ## End(Not run)

