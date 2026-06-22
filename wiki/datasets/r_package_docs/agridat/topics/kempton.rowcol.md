Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

kempton.rowcol: Row-column experiment of wheat

Row-column experiment of wheat

Description

     Row-column experiment of wheat, 35 genotypes, 2 reps.

Format

     A data frame with 68 observations on the following 5 variables.

     ‘rep’ replicate factor, 2 levels

     ‘row’ row

     ‘col’ column

     ‘gen’ genotype factor, 35 levels

     ‘yield’ yield

Details

     Included to illustrate REML analysis of a row-column design.

Source

     R A Kempton and P N Fox, _Statistical Methods for Plant Variety
     Evaluation_, Chapman and Hall, 1997.


Variables detected from installed object

rep: factor ; missing=0 ; examples=R1

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

gen: factor ; missing=0 ; examples=G20, G04, G33

yield: numeric ; missing=0 ; examples=3.77, 3.21, 4.55

Examples
Run this code

     ## Not run:

     library(agridat)
     data(kempton.rowcol)
     dat <- kempton.rowcol
     dat <- transform(dat, rowf=factor(row), colf=factor(col))

     libs(desplot)
     desplot(dat, yield~col*row|rep,
             num=gen, out1=rep, # unknown aspect
             main="kempton.rowcol")

     # Model with rep, row, col as random.  Kempton, page 62.
     # Use "-1" so that the vcov matrix doesn't include intercept
     libs(lme4)
     m1 <- lmer(yield ~ -1 + gen + rep + (1|rep:rowf) + (1|rep:colf), data=dat)

     # Variance components match Kempton.
     print(m1, corr=FALSE)

     # Standard error of difference for genotypes.  Kempton page 62, bottom.
     covs <- as.matrix(vcov(m1)[1:35, 1:35])
     vars <- diag(covs)
     vdiff <- outer(vars, vars, "+") - 2 * covs
     sed <- sqrt(vdiff[upper.tri(vdiff)])
     min(sed) # Minimum SED
     mean(sed) # Average SED
     max(sed) # Maximum SED
     ## End(Not run)

