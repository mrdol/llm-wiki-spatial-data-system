Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

rothamsted.brussels: RCB experiment of brussels sprouts, 9 fertilizer treatments

RCB experiment of brussels sprouts, 9 fertilizer treatments

Description

     RCB experiment of brussels sprouts, 9 fertilizer treatments

Format

     A data frame with 48 observations on the following 5 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield of saleable sprouts, pounds

     ‘trt’ treatment, 9 levels

     ‘block’ block, 4 levels

Details

     The block numbers are arbitrary, and may not match the orignal
     source.

     Plots were 10 yards x 14 yards.  Plot orientation is not clear.

Source

     Rothamsted Experimental Station Report 1934-36.  Brussels sprouts:
     effect of sulphate of ammonia, poultry manure, soot and rape dust,
     pp. 191-192. Harpenden: Lawes Agricultural Trust.

References

     McCullagh, P. and Clifford, D., (2006).  Evidence for conformal
     invariance of crop yields, _Proceedings of the Royal Society A:
     Mathematical, Physical and Engineering Science_, 462, 2119-2143.
     https://doi.org/10.1098/rspa.2006.1667


Variables detected from installed object

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

yield: integer ; missing=0 ; examples=235, 213, 216

trt: factor ; missing=0 ; examples=low dust, none

block: factor ; missing=0 ; examples=B1

Examples
Run this code

     ## Not run:

     library(agridat)
     data(rothamsted.brussels)
     dat <- rothamsted.brussels

     libs(lattice)
     bwplot(yield~trt, dat, main="rothamsted.brussels")

       libs(desplot)
       desplot(dat, yield~col*row,
               num=trt, out1=block, cex=1, # aspect unknown
               main="rothamsted.brussels")
     ## End(Not run)

