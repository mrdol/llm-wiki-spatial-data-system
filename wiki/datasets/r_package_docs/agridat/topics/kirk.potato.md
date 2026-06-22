Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

kirk.potato: Variety trial of potatoes, highly replicated

Variety trial of potatoes, highly replicated

Description

     Variety trial of potatoes, highly replicated

Usage

     data("kirk.potato")

Format

     A data frame with 380 observations on the following 5 variables.

     ‘row’ row ordinate

     ‘col’ column ordinate

     ‘rep’ replicate (not block)

     ‘gen’ genotype (variety)

     ‘yield’ yield, pounds per plot

Details

     A highly-replicated variety trial of potatoes planted in 1924 with
     check plots every 5th row.  Entries were not randomized.  The rod
     rows were planted in series across the field, the rows spaced five
     links apart (nearly 3.5 feet) and with 3.5 foot passes between the
     series.

     The replicates are sometimes dis-jointed, so are not really
     blocks.

Source

     Kirk, L. E. and C. H. Goulden (1925) Some statistical observations
     on a yield test of potato varieties.  Scientific Agriculture, 6,
     89-97.
     https://www.google.com/books/edition/Canadian_Journal_of_Agriculture_Science/TgIkAQAAMAAJ

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

rep: integer ; missing=5 ; examples=1

gen: factor ; missing=5 ; examples=Ck1, G01, G02

yield: numeric ; missing=5 ; examples=16, 14.5, 14

Examples
Run this code

     ## Not run:

       library(agridat)
       data(kirk.potato)
       dat <- kirk.potato
       libs(desplot)
       desplot(dat, yield ~ col*row,
               flip=TRUE, aspect=1,
               main="kirk.potato")

       # Match means in Table I
       libs(dplyr)
       dat
     ## End(Not run)

