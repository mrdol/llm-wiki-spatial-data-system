Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

crampton.pig: Weight gain in pigs for different treatments

Weight gain in pigs for different treatments

Description

     Weight gain in pigs for different treatments, with initial weight
     and feed eaten as covariates.

Usage

     data("crampton.pig")

Format

     A data frame with 50 observations on the following 5 variables.

     ‘treatment’ feed treatment

     ‘rep’ replicate

     ‘weight1’ initial weight

     ‘feed’ feed eaten

     ‘weight2’ final weight

Details

     A study of the effect of initial weight and feed eaten on the
     weight gaining ability of pigs with different feed treatments.

     The data are extracted from Ostle. It is not clear that
     'replicate' is actually a blocking replicate as opposed to a
     repeated measurement.  The original source document needs to be
     consulted.

Source

     Crampton, EW and Hopkins, JW. (1934).  The Use of the Method of
     Partial Regression in the Analysis of Comparative Feeding Trial
     Data, Part II.  The Journal of Nutrition, 8, 113-123.
     https://doi.org/10.1093/jn/8.3.329

References

     Bernard Ostle. Statistics in Research, Page 458.
     https://archive.org/details/secondeditionsta001000mbp

     Goulden (1939). Methods of Statistical Analysis, 1st ed. Page
     256-259.  https://archive.org/details/methodsofstatist031744mbp


Variables detected from installed object

treatment: factor ; missing=0 ; examples=T1

rep: factor ; missing=0 ; examples=R1, R2, R3

weight1: integer ; missing=0 ; examples=30, 21

feed: integer ; missing=0 ; examples=674, 628, 661

weight2: integer ; missing=0 ; examples=195, 177, 180

Examples
Run this code

     ## Not run:

       library(agridat)

       data(crampton.pig)
       dat <- crampton.pig

       dat <- transform(dat, gain=weight2-weight1)
       libs(lattice)
       # Trt 4 looks best
       xyplot(gain ~ feed, dat, group=treatment, type=c('p','r'),
              auto.key=list(columns=5),
              xlab="Feed eaten", ylab="Weight gain", main="crampton.pig")

       # Basic Anova without covariates
       m1 <- lm(weight2 ~ treatment + rep, data=dat)
       anova(m1)
       # Add covariates
       m2 <- lm(weight2 ~ treatment + rep + weight1 + feed, data=dat)
       anova(m2)
       # Remove treatment, test this nested model for significant treatments
       m3 <- lm(weight2 ~ rep + weight1 + feed, data=dat)
       anova(m2,m3) # p-value .07. F=2.34 matches Ostle
     ## End(Not run)

