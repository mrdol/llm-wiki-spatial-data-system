Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

goulden.latin: Latin square experiment for testing fungicide

Latin square experiment for testing fungicide

Description

     Latin square experiment for testing fungicide

Usage

     data("goulden.latin")

Format

     A data frame with 25 observations on the following 4 variables.

     ‘trt’ treatment factor, 5 levels

     ‘yield’ yield

     ‘row’ row

     ‘col’ column

Details

     Five treatments were tested to control stem rust in wheat.
     Treatment codes and descriptions: A = Dusted before rains.  B =
     Dusted after rains.  C = Dusted once each week.  D = Drifting,
     once each week.  E = Not dusted.

Source

     Cyrus H. Goulden (1952).  _Methods of Statistical Analysis_, 2nd
     ed. Page 216.


Variables detected from installed object

trt: factor ; missing=0 ; examples=B, C, D

yield: numeric ; missing=0 ; examples=4.9, 9.3, 7.6

row: integer ; missing=0 ; examples=5, 4, 3

col: integer ; missing=0 ; examples=1

Examples
Run this code

     ## Not run:

     library(agridat)
     library(agridat)
     data(goulden.latin)
     dat <- goulden.latin

     libs(desplot)
     desplot(dat, yield ~ col*row,
             text=trt, cex=1, # aspect unknown
             main="goulden.latin")

     # Matches Goulden.
     m1 <- lm(yield~ trt + factor(row) + factor(col), data=dat)
     anova(m1)
     ## End(Not run)

