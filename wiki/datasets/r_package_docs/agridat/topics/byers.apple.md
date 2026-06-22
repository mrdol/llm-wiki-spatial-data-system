Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

byers.apple: Diameters of apples

Diameters of apples

Description

     Measurements of the diameters of apples

Format

     A data frame with 480 observations on the following 6 variables.

     ‘tree’ tree, 10 levels

     ‘apple’ apple, 24 levels

     ‘size’ size of apple

     ‘appleid’ unique id number for each apple

     ‘time’ time period, 1-6 = (week/2)

     ‘diameter’ diameter, inches

Details

     Experiment conducted at the Winchester Agricultural Experiment
     Station of Virginia Polytechnic Institute and State University.
     Twentyfive apples were chosen from each of ten apple trees.

     Of these, there were 80 apples in the largest size class, 2.75
     inches in diameter or greater.

     The diameters of the apples were recorded every two weeks over a
     12-week period.

Source

     Schabenberger, Oliver and Francis J. Pierce. 2002.  _Contemporary
     Statistical Models for the Plant and Soil Sciences_. CRC Press,
     Boca Raton, FL.


Variables detected from installed object

tree: factor ; missing=0 ; examples=T01

apple: factor ; missing=0 ; examples=A01

size: integer ; missing=0 ; examples=7

appleid: integer ; missing=0 ; examples=1

time: integer ; missing=0 ; examples=1, 2, 3

diameter: numeric ; missing=29 ; examples=2.9

Examples
Run this code

     ## Not run:

       library(agridat)
       data(byers.apple)
       dat <- byers.apple

       libs(lattice)
       xyplot(diameter ~ time | factor(appleid), data=dat, type=c('p','l'),
              strip=strip.custom(par.strip.text=list(cex=.7)),
              main="byers.apple")

       # Overall fixed linear trend, plus random intercept/slope deviations
       # for each apple.  Observations within each apple are correlated.
       libs(nlme)
       libs(lucid)
       m1 <- lme(diameter ~ 1 + time, data=dat,
                 random = ~ time|appleid, method='ML',
                 cor = corAR1(0, form=~ time|appleid),
                 na.action=na.omit)
       vc(m1)
       ##       effect   variance   stddev corr
       ##  (Intercept) 0.007354   0.08575    NA
       ##         time 0.00003632 0.006027 0.83
       ##     Residual 0.0004555  0.02134    NA
     ## End(Not run)

