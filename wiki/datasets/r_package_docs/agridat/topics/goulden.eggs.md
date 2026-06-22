Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

goulden.eggs: Sample of egg weights on 24 consecutive days

Sample of egg weights on 24 consecutive days

Description

     Sample of egg weights on 24 consecutive days

Usage

     data("goulden.eggs")

Format

     A data frame with 240 observations on the following 2 variables.

     ‘day’ day

     ‘weight’ weight

Details

     Data are the weights of 10 eggs taken at random on each day for 24
     days.  Day 1 was Dec 10, and Day 24 was Jan 2.

     The control chart for standard deviations shows 4 values beyond
     the upper limits. The data reveals a single, unusually large egg
     on each of these days.  These are almost surely double-yolk eggs.

Source

     Cyrus H. Goulden (1952).  _Methods of Statistical Analysis_, 2nd
     ed. Page 425.

References

     None.


Variables detected from installed object

day: integer ; missing=0 ; examples=1

weight: integer ; missing=0 ; examples=55, 53, 56

Examples
Run this code

     ## Not run:

     library(agridat)
     data(goulden.eggs)
     dat <- goulden.eggs

     libs(qicharts)
     # Figure 19-4 of Goulden. (Goulden uses 1/n when calculating std dev)
     op <- par(mfrow=c(2,1))
     qic(weight, x = day, data = dat, chart = 'xbar',
         main = 'goulden.eggs - Xbar chart',
         xlab = 'Date', ylab = 'Avg egg weight' )
     qic(weight, x = day, data = dat, chart = 's',
         main = 'goulden.eggs - S chart',
         xlab = 'Date', ylab = 'Std dev egg weight' )
     par(op)
     ## End(Not run)

