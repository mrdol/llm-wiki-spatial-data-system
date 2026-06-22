Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

kempton.competition: Sugar beet trial with competition effects

Sugar beet trial with competition effects

Description

     Yield of sugar beets for 36 varieties in a 3-rep RCB experiment.
     Competition effects are present.

Format

     A data frame with 108 observations on the following 5 variables.

     ‘gen’ genotype, 36 levels

     ‘rep’ rep, 3 levels

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, kg/plot

Details

     Entries are grown in 12m rows, 0.5m apart.  Guard rows were grown
     alongside replicate boundaries, but yields of these plots are not
     included.

Source

     R Kempton, 1982.  Adjustment for competition between varieties in
     plant breeding trials, _Journal of Agricultural Science_, 98,
     599-611.  https://doi.org/10.1017/S0021859600054381


Variables detected from installed object

gen: factor ; missing=0 ; examples=G19, G29, G08

rep: factor ; missing=0 ; examples=R1

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

yield: numeric ; missing=0 ; examples=12, 20.2, 4.3

Examples
Run this code

     ## Not run:

     library(agridat)

     data(kempton.competition)
     dat <- kempton.competition

     # Raw means in Kempton table 2
     round(tapply(dat$yield, dat$gen, mean),2)

     # Fixed genotype effects, random rep effects,
     # Autocorrelation of neighboring plots within the same rep, phi = -0.22
     libs(nlme)
     m1 <- lme(yield ~ -1+gen, random=~1|rep, data=dat,
               corr=corAR1(form=~col|rep))
     # Lag 1 autocorrelation is negative--evidence of competition
     plot(ACF(m1), alpha=.05, grid=TRUE, main="kempton.competition",
          ylab="Autocorrelation between neighborning plots")

     # Genotype effects
     round(fixef(m1),2)

     # Variance of yield increases with yield
     plot(m1, main="kempton.competition")
     ## End(Not run)

