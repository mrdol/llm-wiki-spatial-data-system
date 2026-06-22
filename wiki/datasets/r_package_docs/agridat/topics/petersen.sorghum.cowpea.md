Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

petersen.sorghum.cowpea: Intercropping experiment of sorghum/cowpea

Intercropping experiment of sorghum/cowpea

Description

     Intercropping experiment of sorghum/cowpea.

Usage

     data("petersen.sorghum.cowpea")

Format

     A data frame with 18 observations on the following 5 variables.

     ‘block’ block

     ‘srows’ sorghum rows

     ‘crows’ cowpea rows

     ‘syield’ sorghum yield, kg/ha

     ‘cyield’ cowpea yield, kg/ha

Details

     An intercropping experiment in Tanzania.  The treatments consisted
     of four ratios of sorghum rows to cowpea rows as 1:4, 2:3, 3:2,
     4:1.

     The sole-crop yields with 5 rows per crop are also given (not part
     of the blocks).

Source

     Roger G Petersen (1994).  Agricultural Field Experiments.  Marcel
     Dekker Inc, New York.  Page 372.

References

     None


Variables detected from installed object

block: factor ; missing=2 ; examples=B1

srows: integer ; missing=0 ; examples=1, 2, 3

crows: integer ; missing=0 ; examples=4, 3, 2

syield: integer ; missing=0 ; examples=956, 2144, 2635

cyield: integer ; missing=0 ; examples=1444, 1114, 818

Examples
Run this code

     ## Not run:

     libs(agridat)
     data(petersen.sorghum.cowpea)
     dat <- petersen.sorghum.cowpea

     # Petersen figure 10.4a
     tmp <- dat

     with(tmp, plot(srows, syield + cyield,
                    col="blue", type='l', xlim=c(0,5), ylim=c(0,4000)) )
     with(tmp, lines(srows, syield) )
     with(tmp, lines(srows, cyield, col="red") )
     title("Cow Pea (red), Sorghum (black), Total (blue)")
     title("petersen.sorghum.cowpea", line=0.5)
     ## End(Not run)

