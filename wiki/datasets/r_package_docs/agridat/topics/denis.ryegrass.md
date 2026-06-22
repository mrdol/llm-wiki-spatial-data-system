Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

denis.ryegrass: Multi-environment trial of perennial ryegrass in France

Multi-environment trial of perennial ryegrass in France

Description

     Plant strength of perennial ryegrass in France for 21 genotypes at
     7 locations.

Format

     A data frame with 147 observations on the following 3 variables.

     ‘gen’ genotype, 21 levels

     ‘loc’ location, 7 levels

     ‘strength’ average plant strength * 100

Details

     INRA conducted a breeding trial in western France with 21
     genotypes at 7 locations.  The observed data is 'strength'
     averaged over 7-10 plants per plot and three plots per location
     (after adjusting for blocking effects).  Each plant was scored on
     a scale 0-9.

     The original data had a value of 86.0 for genotype G1 at location
     L4-this was replaced by an additive estimated value of 361.2 as in
     Gower and Hand (1996).

Source

     Jean-Baptiste Denis and John C. Gower, 1996.  Asymptotic
     confidence regions for biadditive models: interpreting
     genotype-environment interaction, _Applied Statistics_, 45,
     479-493.  https://doi.org/10.2307/2986069

References

     Gower, J.C. and Hand, D.J., 1996.  Biplots.  Chapman and Hall.


Variables detected from installed object

gen: factor ; missing=0 ; examples=G01, G02, G03

loc: factor ; missing=0 ; examples=L1

strength: numeric ; missing=0 ; examples=266, 359, 321.7

Examples
Run this code

     library(agridat)
     data(denis.ryegrass)
     dat <- denis.ryegrass

     # biplots (without ellipses) similar to Denis figure 1
     libs(gge)
     m1 <- gge(dat, strength ~ gen*loc, scale=FALSE)
     biplot(m1, main="denis.ryegrass biplot")

