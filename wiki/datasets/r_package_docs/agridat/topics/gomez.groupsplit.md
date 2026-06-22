Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

gomez.groupsplit: Group balanced split-plot design in rice

Group balanced split-plot design in rice

Description

     Group balanced split-plot design in rice

Format

     A data frame with 270 observations on the following 7 variables.

     ‘col’ column

     ‘row’ row

     ‘rep’ replicate factor, 3 levels

     ‘fert’ fertilizer factor, 2 levels

     ‘gen’ genotype factor, 45 levels

     ‘group’ grouping (genotype) factor, 3 levels

     ‘yield’ yield of rice

Details

     Genotype group S1 is less than 105 days growth duration, S2 is
     105-115 days growth duration, S3 is more than 115 days.

     Used with permission of Kwanchai Gomez.

Source

     Gomez, K.A. and Gomez, A.A.. 1984, Statistical Procedures for
     Agricultural Research.  Wiley-Interscience.  Page 120.


Variables detected from installed object

col: integer ; missing=0 ; examples=1, 3, 5

row: integer ; missing=0 ; examples=27, 9, 4

rep: factor ; missing=0 ; examples=R1, R2

fert: factor ; missing=0 ; examples=F1, F2

gen: factor ; missing=0 ; examples=G01

group: factor ; missing=0 ; examples=S1

yield: numeric ; missing=0 ; examples=4.252, 4.331, 3.548

Examples
Run this code

     library(agridat)
     data(gomez.groupsplit)
     dat <- gomez.groupsplit

     # Gomez figure 3.10.  Obvious fert and group effects
     libs(desplot)
     desplot(dat, group ~ col*row,
             out1=rep, col=fert, text=gen, # aspect unknown
             main="gomez.groupsplit")

     # Gomez table 3.19 (not partitioned by group)
     m1 <- aov(yield ~ fert*group + gen:group + fert:gen:group +
                 Error(rep/fert/group), data=dat)
     summary(m1)

