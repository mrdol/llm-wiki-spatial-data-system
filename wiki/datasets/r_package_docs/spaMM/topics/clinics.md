Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

clinics: Toy dataset for binomial response

Toy dataset for binomial response

Description

     A small data set used by Booth & Hobert (1998).

Usage

     data("clinics")

Format

     A data frame with 16 observations on the following 4 variables.

     ‘npos’ a numeric vector

     ‘nneg’ a numeric vector

     ‘treatment’ a numeric vector

     ‘clinic’ a numeric vector

References

     Booth, J.G., Hobert, J.P. (1998) Standard errors of prediction in
     generalized linear mixed models. J. Am. Stat. Assoc. 93: 262-272.


Variables detected from installed object

npos: numeric ; missing=0 ; examples=11, 16, 14

nneg: numeric ; missing=0 ; examples=25, 4, 5

treatment: numeric ; missing=0 ; examples=1

clinic: integer ; missing=0 ; examples=1, 2, 3

Examples
Run this code

     data(clinics)
     ## Not run:

     # The dataset was built as follows
     npos <- c(11,16,14,2,6,1,1,4,10,22,7,1,0,0,1,6)
     ntot <- c(36,20,19,16,17,11,5,6,37,32,19,17,12,10,9,7)
     treatment <- c(rep(1,8),rep(0,8))
     clinic <-c(seq(8),seq(8))
     clinics <- data.frame(npos=npos,nneg=ntot-npos,treatment=treatment,clinic=clinic)
     ## End(Not run)

