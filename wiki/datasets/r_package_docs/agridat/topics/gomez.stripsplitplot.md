Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

gomez.stripsplitplot: Strip-split-plot experiment of rice

Strip-split-plot experiment of rice

Description

     A strip-split-plot experiment with three reps, genotype as the
     horizontal strip, nitrogen fertilizer as the vertical strip, and
     planting method as the subplot factor.

Format

     ‘yield’ grain yield in kg/ha

     ‘planting’ planting factor, P1=broadcast, P2=transplanted

     ‘rep’ rep, 3 levels

     ‘nitro’ nitrogen fertilizer, kg/ha

     ‘gen’ genotype, G1 to G6

     ‘col’ column

     ‘row’ row

Details

     Note, this is a superset of the the 'gomez.stripplot' data.

     Used with permission of Kwanchai Gomez.

Source

     Gomez, K.A. and Gomez, A.A.. 1984, Statistical Procedures for
     Agricultural Research.  Wiley-Interscience.  Page 155.


Variables detected from installed object

yield: integer ; missing=0 ; examples=2373, 4007, 2620

planting: factor ; missing=0 ; examples=P1

rep: factor ; missing=0 ; examples=R1

nitro: integer ; missing=0 ; examples=0

gen: factor ; missing=0 ; examples=G1, G2, G3

col: integer ; missing=0 ; examples=1

row: integer ; missing=0 ; examples=2, 6, 8

Examples
Run this code

     ## Not run:

     library(agridat)
     data(gomez.stripsplitplot)
     dat <- gomez.stripsplitplot

     # Layout
     libs(desplot)
     desplot(dat, gen ~ col*row,
             out1=rep, col=nitro, text=planting, cex=1,
             main="gomez.stripsplitplot")

     # Gomez table 4.19, ANOVA of strip-split-plot design
     dat <- transform(dat, nf=factor(nitro))
     m1 <- aov(yield ~ nf * gen * planting +
               Error(rep + rep:nf + rep:gen + rep:nf:gen), data=dat)
     summary(m1)

     # There is a noticeable linear trend along the y coordinate which may be
     # an artifact that blocking will remove, or may need to be modeled.
     # Note the outside values in the high-nitro boxplot.
     libs("HH")
     interaction2wt(yield ~ nitro + gen + planting + row, dat,
                    x.between=0, y.between=0,
                    x.relation="free")
     ## End(Not run)

