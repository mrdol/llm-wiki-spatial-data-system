Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

lander.multi.uniformity: Uniformity trials of wheat and chari, 4 years on the same land.

Uniformity trials of wheat and chari, 4 years on the same land.

Description

     Uniformity trials of wheat and chari, 4 years on the same land, in
     India.

Usage

     data("lander.multi.uniformity")

Format

     A data frame with 780 observations on the following 5 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, maunds per plot

     ‘year’ year

     ‘crop’ crop

Details

     Note, "chari" in this paper is _Andropogon Sorghum_, and "wheat"
     is _Triticum vulgare_.

     Uniformity trials carried out at Rawalpindi, India.

     The area consisted of 5 fields (D4,D5,D6,D7,D8), each 5 acres in
     size. Each of these 5 fields was divided into three sub-divisions
     A, B, C, by means of two strong bunds each 5 feet wide. These 3
     sub-divisions were divided into 5 blocks, each consisting of 13
     experimental plots with 14 non-experiment strips 5 feet wide
     separating the plots from the other. The dimensions of the plot
     were 207 ft 5 in by 19 ft 1 in.

     The same land was used for 4 consecutive crops. The first crop was
     wheat, followed by chari (sorghum), followed by wheat 2 times.

     Field width: 207.42 * 5 plots = 1037.1 feet

     Field length: (19.08+5)*39 rows = 939.12 feet

     Conclusions: It is evident, therefore, that soil heterogenity as
     revealed by any one crop cannot be a true index of the subsequent
     behavior of that area with respect to other crops. Even the same
     crop raised in different seasons has not shown any constancy as
     regards soil heterogeneity.

Source

     Lander, P. E. et al. (1938).  Soil Uniformity Trials in the Punjab
     I.  Ind. J. Agr. Sci. 8:271-307.

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=6.7, 8.6, 8.3

year: integer ; missing=0 ; examples=1929

crop: factor ; missing=0 ; examples=wheat

Examples
Run this code

     ## Not run:

     library(agridat)
     data(lander.multi.uniformity)
     dat <- lander.multi.uniformity

     # Yearly means, similar to Lander table 7
     ## filter(dat)
     ## 1 1929   18.1
     ## 2 1930   58.3
     ## 3 1931   22.8
     ## 4 1932   14.1

     # heatmaps for all years
     libs(desplot)
     dat$year <- factor(dat$year)
     desplot(dat, yield ~ col*row|year,
             flip=TRUE, aspect=(1037.1/939.12),
             main="lander.multi.uniformity")
     ## End(Not run)

