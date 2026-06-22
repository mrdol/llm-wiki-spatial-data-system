Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

lord.rice.uniformity: Uniformity trial of rice

Uniformity trial of rice

Description

     Uniformity trial of rice in Ceylon, 1929.

Usage

     data("lord.rice.uniformity")

Format

     A data frame with 560 observations on the following 5 variables.

     ‘field’ field

     ‘row’ row

     ‘col’ column

     ‘grain’ grain weight, pounds per plot

     ‘straw’ straw weight, pounds per plot

Details

     In 1929, eight fields 1/5 acre in size were broadcast seeded with
     rice at the Anuradhapura Experiment Station in the northern dry
     zone of Ceylon. After broadcast, the fields were marked into 10 ft
     by 10 ft squares. At harvest, weights of grain and straw were
     recorded.

     Fields 10-14 were on one side of a drain, and fields 26-28 on the
     other side.

     Each field was surrounded by a bund. Plots next to the bunds had
     higher yields.

     Field width: 5 plots * 10 feet = 50 feet

     Field length: 14 plots * 10 feet = 140 feet

     Conclusions: "It would appear that plots of about 1/87 acre are
     the most effective."

Source

     Lord, L. (1931).  A Uniformity Trial with Irrigated Broadcast
     Rice.  The Journal of Agricultural Science, 21(1), 178-188.
     https://doi.org/10.1017/S0021859600008029

References

     None


Variables detected from installed object

field: integer ; missing=0 ; examples=10

row: integer ; missing=0 ; examples=1

col: integer ; missing=0 ; examples=1, 2, 3

grain: numeric ; missing=0 ; examples=9.2, 8.4, 8.5

straw: numeric ; missing=0 ; examples=12.2, 11.7, 12.5

Examples
Run this code

     ## Not run:

     library(agridat)
     data(lord.rice.uniformity)
     dat <- lord.rice.uniformity

     # match table on page 180
     ## libs(dplyr)
     ## dat
     ##   field grain straw
     ##   <chr> <dbl> <dbl>
     ## 1 10      590   732
     ## 2 11      502   600
     ## 3 12      315   488
     ## 4 13      291   538
     ## 5 14      489   670
     ## 6 26      441   560
     ## 7 27      451   629
     ## 8 28      530   718

     # There are consistently high yields along all edges of the field
     # libs(lattice)
     # bwplot(grain ~ factor(col)|field,dat)
     # bwplot(grain ~ factor(col)|field,dat)

     # Heatmaps
     libs(desplot)
     desplot(dat, grain ~ col*row|field,
             flip=TRUE, aspect=140/50,
             main="lord.rice.uniformity")

     # bivariate scatterplots
     # xyplot(grain ~ straw|field, dat)
     ## End(Not run)

