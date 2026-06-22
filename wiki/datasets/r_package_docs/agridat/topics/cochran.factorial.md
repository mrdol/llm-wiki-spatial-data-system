Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

cochran.factorial: Factorial experiment of beans, 2x2x2x2

Factorial experiment of beans, 2x2x2x2

Description

     Factorial experiment of beans, 2x2x2x2.

Usage

     data("cochran.factorial")

Format

     A data frame with 32 observations on the following 4 variables.

     ‘rep’ rep factor

     ‘block’ block factor

     ‘trt’ treatment factor, 16 levels

     ‘yield’ yield (pounds)

     ‘d’ dung treatment, 2 levels

     ‘n’ nitrogen treatment, 2 levels

     ‘p’ phosphorous treatment, 2 levels

     ‘k’ potassium treatment, 2 levels

Details

     Conducted by Rothamsted Experiment Station in 1936.

     There were 4 treatment factors:

     2 d dung levels: None, 10 tons/acre.

     2 n nitrochalk levels: None, 0.4 hundredweight nitrogen per acre.

     2 p superphosphate levels: None, 0.6 hundredweight per acre

     2 k muriate of potash levels: None, 1 hundredweight K20 per acres.

     The response variable is the yield of beans.

Source

     Cochran, W.G. and Cox, G.M. (1957), Experimental Designs, 2nd ed.,
     Wiley and Sons, New York, p. 160.


Variables detected from installed object

rep: factor ; missing=0 ; examples=R1

block: factor ; missing=0 ; examples=B1

trt: factor ; missing=0 ; examples=p, k, d

yield: integer ; missing=0 ; examples=45, 55, 53

d: integer ; missing=0 ; examples=1, 0

n: integer ; missing=0 ; examples=1

p: integer ; missing=0 ; examples=0, 1

k: integer ; missing=0 ; examples=1, 0

Examples
Run this code

     ## Not run:

     library(agridat)
     data(cochran.factorial)
     dat <- cochran.factorial

     # Ensure factors
     dat <- transform(dat, d=factor(d), n=factor(n), p=factor(p), k=factor(k))

     # Cochran table 6.5.
     m1 <- lm(yield ~ rep * block + (d+n+p+k)^3, data=dat)
     anova(m1)

     libs(FrF2)
     aliases(m1)
     MEPlot(m1, select=3:6,
            main="cochran.factorial - main effects plot")
     ## End(Not run)

