Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

shafi.tomato.uniformity: Uniformity trial of tomato

Uniformity trial of tomato

Description

     Uniformity trial of tomato in India

Usage

     data("shafi.tomato.uniformity")

Format

     A data frame with 200 observations on the following 3 variables.

     ‘row’ row ordinate

     ‘col’ column ordinate

     ‘yield’ yield, kg/plot

Details

     The experiment was conducted at the Regional Research Station
     Faculty of Agriculture, SKUAST-K Wadura Campus during 2006.

     The original data was collected on 1m x 1m plots. The data here
     are aggregated 2m x 2m plots.

     Field length: 20 row * 2 m = 40 m

     Field width: 10 col * 2 m = 20 m

Source

     Shafi, Sameera (2007).  On Some Aspects of Plot Techniques in
     Field Experiments on Tomato (Lycopersicon esculentum mill.) in
     Soils of Kashmir.  Thesis. Univ. of Ag. Sciences & Technology of
     Kashmir. Table 2.2.1.
     https://krishikosh.egranth.ac.in/assets/pdfjs/web/viewer.html?file=https

References

     Shafi, Sameera; S.A.Mir, Nageena Nazir, and Anjum Rashid. (2010).
     Optimum plot size for tomato by using S-PLUS and R-software's in
     the soils of Kashmir.  Asian J. Soil Sci., 4, 311-314.
     http://researchjournal.co.in/upload/assignments/4_311-314.pdf


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=6.56, 6.396, 6.478

Examples
Run this code

     ## Not run:

       library(agridat)
       data(shafi.tomato.uniformity)
       dat <- shafi.tomato.uniformity

       libs(desplot)
       desplot(dat, yield ~ col*row,
               aspect=40/20, # true aspect
               main="shafi.tomato.uniformity")
     ## End(Not run)

