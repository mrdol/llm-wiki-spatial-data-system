Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

bond.diallel: Diallel cross of winter beans

Diallel cross of winter beans

Description

     Diallel cross of winter beans

Format

     A data frame with 36 observations on the following 3 variables.

     ‘female’ female parent

     ‘male’ male parent

     ‘yield’ yield, grams/plot

     ‘stems’ stems per plot

     ‘nodes’ podded nodes per stem

     ‘pods’ pods per podded node

     ‘seeds’ seeds per pod

     ‘weight’ weight (g) per 100 seeds

     ‘height’ height (cm) in April

     ‘width’ width (cm) in April

     ‘flower’ mean flowering date in May

Details

     Yield in grams/plot for full diallel cross between 6 inbred lines
     of winter beans.  Values are means over two years.

Source

     D. A. Bond (1966). Yield and components of yield in diallel
     crosses between inbred lines of winter beans (Viciafaba).  _The
     Journal of Agricultural Science_, 67, 325-336.
     https://doi.org/10.1017/S0021859600017329

References

     Peter John, _Statistical Design and Analysis of Experiments_, p.
     85.


Variables detected from installed object

female: factor ; missing=0 ; examples=G24, G31, G36

male: factor ; missing=0 ; examples=G24

yield: numeric ; missing=0 ; examples=172.8, 247.7, 267.5

stems: numeric ; missing=0 ; examples=20.5, 26.8, 26.3

nodes: numeric ; missing=0 ; examples=2.99, 3.24, 3.42

pods: numeric ; missing=0 ; examples=1.45, 1.39, 1.31

seeds: numeric ; missing=0 ; examples=2.91, 3, 3.13

weight: numeric ; missing=0 ; examples=68.7, 69.5, 75.5

height: numeric ; missing=0 ; examples=20.05, 25.13, 23.2

width: numeric ; missing=0 ; examples=16.04, 22.29, 20.88

flower: numeric ; missing=0 ; examples=10.38, 10.68, 7.93

Examples
Run this code

     ## Not run:

       library(agridat)
       data(bond.diallel)
       dat <- bond.diallel

       # Because these data are means, we will not be able to reproduce
       # the anova table in Bond. More useful as a multivariate example.

       libs(corrgram)
       corrgram(dat[ , 3:11], main="bond.diallel",
                lower=panel.pts)

       # Multivariate example from sommer package
       corrgram(dat[,c("stems","pods","seeds")],
                lower=panel.pts, upper=panel.conf, main="bond.diallel")

       libs(sommer)
       m1 <- mmer(cbind(stems,pods,seeds) ~ 1,
                  random= ~ vs(female)+vs(male),
                  rcov= ~ vs(units),
                  dat)

       #### genetic variance covariance
       cov2cor(m1$sigma$`u:female`)
       cov2cor(m1$sigma$`u:male`)
       cov2cor(m1$sigma$`u:units`)
     ## End(Not run)

