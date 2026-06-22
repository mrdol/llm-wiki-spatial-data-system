Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

kadam.millet.uniformity: Uniformity trial of millet

Uniformity trial of millet

Description

     Uniformity trial of millet in India during 2 years

Usage

     data("kadam.millet.uniformity")

Format

     A data frame with 240 observations on the following 4 variables.

     ‘year’ year

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, ounces

Details

     Uniformity trials conducted during the kharip (monsoon) seasons of
     1933 and 1934 at Kundewadi, Niphad, in the district of Nasik,
     India. Bajari (pearl millet) strain 54 was used.

     In 1933:

     Field width: 8 plots * 16.5 feet

     Field length: 10 plots * 33 feet

     In 1934:

     Field width: 8 plots * 16.5 feet

     Field length: 20 plots * 16.5 feet

Source

     B. S. Kadam and S. M. Patel. (1937).  Studies in Field-Plot
     Technique With P. Typhoideum Rich.  The Empire Journal Of
     Experimental Agriculture, 5, 219-230.
     https://archive.org/details/in.ernet.dli.2015.25282

References

     None.


Variables detected from installed object

year: integer ; missing=0 ; examples=1933

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=93, 96, 92

Examples
Run this code

     ## Not run:

     library(agridat)

       data(kadam.millet.uniformity)
       dat <- kadam.millet.uniformity

       # similar to Kadam fig 1
       libs(desplot)
       desplot(dat, yield ~ col*row,
               subset=year==1933,
               flip=TRUE, aspect=(10*33)/(8*16.5), # true aspect
               main="kadam.millet.uniformity 1933")

       desplot(dat, yield ~ col*row,
               subset=year==1934,
               flip=TRUE, aspect=(20*16.5)/(8*16.5), # true aspect
               main="kadam.millet.uniformity 1934")
     ## End(Not run)

