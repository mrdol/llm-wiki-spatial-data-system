Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

jenkyn.mildew: Yields from treatment for mildew control

Yields from treatment for mildew control

Description

     Yields from treatment for mildew control

Format

     A data frame with 38 observations on the following 4 variables.

     ‘plot’ plot number

     ‘trt’ treatment factor, 4 levels

     ‘block’ block factor, 9 levels

     ‘yield’ grain yield, tons/ha

Details

     There were four spray treatments: 0 (none), 1 (early), 2 (late), R
     (repeated).

     Each treatment occurs once between each of the 9 ordered pairs of
     the other treatments.

     The first and last plot are not assigned to a block.

Source

     Norman Draper and Irwin Guttman (1980).  Incorporating Overlap
     Effects from Neighboring Units into Response Surface Models.
     _Appl Statist_, 29, 128-134.  https://doi.org/10.2307/2986297

References

     Maria Durban, Christine Hackett, Iain Currie.  Blocks, Trend and
     Interference in Field Trials.


Variables detected from installed object

plot: integer ; missing=0 ; examples=0, 1, 2

trt: factor ; missing=0 ; examples=R, T2

block: factor ; missing=0 ; examples=, B1

yield: numeric ; missing=0 ; examples=5.77, 5.73, 6.08

Examples
Run this code

     ## Not run:

     library(agridat)
     data(jenkyn.mildew)
     dat <- jenkyn.mildew

     libs(lattice)
     bwplot(yield ~ trt, dat, main="jenkyn.mildew", xlab="Treatment")

     # Residuals from treatment model show obvious spatial trends
     m0 <- lm(yield ~ trt, dat)
     xyplot(resid(m0)~plot, dat, ylab="Residual",
            main="jenkyn.mildew - treatment model")

     # The blocks explain most of the variation
     m1 <- lm(yield ~ trt + block, dat)
     xyplot(resid(m1)~plot, dat, ylab="Residual",
            main="jenkyn.mildew - block model")
     ## End(Not run)

