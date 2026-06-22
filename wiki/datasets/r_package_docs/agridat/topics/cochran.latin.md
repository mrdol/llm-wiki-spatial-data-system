Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

cochran.latin: Latin square design in wheat

Latin square design in wheat

Description

     Six wheat plots were sampled by six operators and shoot heights
     measured. The operators sampled plots in six ordered sequences.
     The dependent variate was the difference between measured height
     and true height of the plot.

Format

     A data frame with 36 observations on the following 4 variables.

     ‘row’ row

     ‘col’ column

     ‘operator’ operator factor

     ‘diff’ difference between measured height and true height

Source

     Cochran, W.G. and Cox, G.M. (1957), _Experimental Designs_, 2nd
     ed., Wiley and Sons, New York.


Variables detected from installed object

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

operator: factor ; missing=0 ; examples=f, b, a

diff: numeric ; missing=0 ; examples=3.5, 4.2, 6.7

Examples
Run this code

     ## Not run:

     library(agridat)
     data(cochran.latin)
     dat <- cochran.latin

     libs(desplot)
     desplot(dat, diff~col*row,
             text=operator, cex=1, # aspect unknown
             main="cochran.latin")

     dat <- transform(dat, rf=factor(row), cf=factor(col))
     aov.dat <- aov(diff ~ operator + Error(rf*cf), dat)
     summary(aov.dat)
     model.tables(aov.dat, type="means")
     ## End(Not run)

