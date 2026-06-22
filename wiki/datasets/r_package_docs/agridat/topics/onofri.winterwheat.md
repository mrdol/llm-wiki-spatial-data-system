Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

onofri.winterwheat: Multi-environment trial of winter wheat, 7 years

Multi-environment trial of winter wheat, 7 years

Description

     Multi-environment trial of winter wheat, 7 years, 8 gen

Usage

     data("onofri.winterwheat")

Format

     A data frame with 168 observations on the following 5 variables.

     ‘year’ year, numeric

     ‘block’ block, 3 levels

     ‘plot’ plot, numeric

     ‘gen’ genotype, 7 levels

     ‘yield’ yield for each plot

Details

     Yield of 8 durum winter wheat varieties across 7 years with 3
     reps.

     Downloaded electronic version from here Nov 2015:
     https://www.casaonofri.it/Biometry/index.html

     Used with permission of Andrea Onofri.

Source

     Andrea Onofri, Egidio Ciriciofolo (2007).  Using R to Perform the
     AMMI Analysis on Agriculture Variety Trials.  R News, Vol. 7, No.
     1, pp. 14-19.

References

     F. Mendiburu.  AMMI.
     https://tarwi.lamolina.edu.pe/~fmendiburu/AMMI.htm

     A. Onofri.
     https://accounts.unipg.it/~onofri/RTutorial/CaseStudies/WinterWheat.htm


Variables detected from installed object

year: integer ; missing=0 ; examples=1996

block: factor ; missing=0 ; examples=B1, B2, B3

plot: integer ; missing=0 ; examples=2, 110, 181

gen: factor ; missing=0 ; examples=Colosseo

yield: numeric ; missing=0 ; examples=6.73, 6.96, 5.35

Examples
Run this code

     library(agridat)
     data(onofri.winterwheat)
     dat <- onofri.winterwheat
     dat <- transform(dat, year=factor(dat$year))

     m1 <- aov(yield ~ year + block:year + gen + gen:year, dat)
     anova(m1) # Matches Onofri figure 1

     libs(agricolae)
     m2 <- AMMI(dat$year, dat$gen, dat$block, dat$yield)
     plot(m2)
     title("onofri.winterwheat - AMMI biplot")

