Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

goulden.splitsplit: Split-split-plot experiment of wheat

Split-split-plot experiment of wheat

Description

     Split-split-plot experiment of wheat

Usage

     data("goulden.splitsplit")

Format

     A data frame with 160 observations on the following 9 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield

     ‘inoc’ inoculate

     ‘trt’ treatment number

     ‘gen’ genotype

     ‘dry’ dry/wet dust application

     ‘dust’ dust treatment

     ‘block’ block

Details

     An interesting split-split plot experiment in which the sub-plot
     treatments have a 2*5 factorial structure.

     An experiment was conducted in 1932 on the experimental field of
     the Dominion Rust Research Laboratory.  The study was designed to
     determine the effect on the incidence of root rot, of variety of
     wheat, kinds of dust for seed treatment, method of application of
     the dust, and efficacy of soil inoculation with the root-rot
     organism.

     The field had 4 blocks.

     Each block has 2 whole plots for the genotypes.

     Each whole-plot had 10 sub-plots for the 5 different kinds of dust
     and 2 methods of application.

     Each sub-plot had 2 sub-sub-plots, one for inoculated soil and the
     other one for uninoculated soil.

Source

     C. H. Goulden, (1939).  _Methods of statistical analysis_, 1st ed.
     Page 18.  https://archive.org/stream/methodsofstatist031744mbp

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 10, 11

yield: integer ; missing=0 ; examples=64, 69, 67

inoc: factor ; missing=0 ; examples=Uninoc

trt: integer ; missing=0 ; examples=5, 7, 1

gen: factor ; missing=0 ; examples=Marquis

dry: factor ; missing=0 ; examples=Dry

dust: factor ; missing=0 ; examples=DuBay, Check, Ceresan

block: factor ; missing=0 ; examples=B1

Examples
Run this code

     ## Not run:

     library(agridat)
     data(goulden.splitsplit)
     dat <- goulden.splitsplit

     libs(desplot)

     ## Experiment design. Goulden p. 152-153
     ## desplot(gen ~ col*row, data=dat,
     ##         out1=block, out2=trt, text=dust, col=inoc, cex=1,
     ##         main="goulden.splitsplit")

     desplot(dat, yield ~ col*row,
             out1=block, out2=gen,
             col=inoc, num=trt, cex=1,
             main="goulden.splitsplit")

     # Match Goulden table 40
     m1 <- aov(yield ~ gen
               + dust + dry + dust:dry + gen:dust + gen:dry + gen:dust:dry
               + inoc + inoc:gen + inoc:dust + inoc:dry
               + inoc:dust:dry +inoc:gen:dust + inoc:gen:dry
               + Error(block/(gen+gen:dust:dry+gen:inoc:dry)), data=dat)
     summary(m1)
     ## End(Not run)

