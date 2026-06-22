Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

housetasks: Contingency Table

Contingency Table

Description

     The ‘housetasks’ data frame gives 13 housetasks and their
     repartition in the couple.

Usage

     data(housetasks)

Format

     This data frame contains four columns : wife, alternating, husband
     and jointly.  Each column is a numeric vector.

Source

     Kroonenberg, P. M. and Lombardo, R. (1999) Nonsymmetric
     correspondence analysis: a tool for analysing contingency tables
     with a dependence structure. _Multivariate Behavioral Research_,
     *34*, 367-396


Variables detected from installed object

Wife: numeric ; missing=0 ; examples=156, 124, 77

Alternating: numeric ; missing=0 ; examples=14, 20, 11

Husband: numeric ; missing=0 ; examples=2, 5, 7

Jointly: numeric ; missing=0 ; examples=4, 13

Examples
Run this code

     data(housetasks)
     nsc1 <- dudi.nsc(housetasks, scan = FALSE)

     if(adegraphicsLoaded()) {
       s.label(nsc1$c1, plab.cex = 1.25)
       s.arrow(nsc1$li, add = TRUE, plab.cex = 0.75)
     } else {
       s.label(nsc1$c1, clab = 1.25)
       s.arrow(nsc1$li, add.pl = TRUE, clab = 0.75)
     }

