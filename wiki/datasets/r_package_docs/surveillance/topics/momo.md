Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

momo: Danish 1994-2008 all-cause mortality data for eight age groups

Danish 1994-2008 all-cause mortality data for eight age groups

Description

     Weekly number of all cause mortality from 1994-2008 in each of the
     eight age groups <1, 1-4, 5-14, 15-44, 45-64, 65-74, 75-84 and 85+
     years, see Höhle and Mazick (2010).

Usage

     data(momo)

Format

     An object of class ‘"sts"’ containing the weekly number of
     all-cause deaths in Denmark, 1994-2008 (782 weeks), for each of
     the eight age groups <1, 1-4, 5-14, 15-44, 45-64, 65-74, 75-84 and
     85+ years. A special feature of the EuroMOMO data is that weeks
     follow the ISO 8601 standard, which can be handled by the ‘"sts"’
     class.

     The ‘population’ slot of the ‘momo’ object contains the population
     size in each of the eight age groups.  These are yearly data
     obtained from the StatBank Denmark.

Source

     _European monitoring of excess mortality for public health action_
     (EuroMOMO) project. <https://www.euromomo.eu/>.

     Department of Epidemiology, Statens Serum Institute, Copenhagen,
     Denmark StatBank Denmark, Statistics Denmark,
     <https://www.statistikbanken.dk/>

References

     Höhle, M. and Mazick, A. (2010). Aberration detection in R
     illustrated by Danish mortality monitoring. In T. Kass-Hout and X.
     Zhang (eds.), _Biosurveillance: A Health Protection Priority_,
     chapter 12. Chapman & Hall/CRC.
     Preprint available at
     <https://staff.math.su.se/hoehle/pubs/hoehle_mazick2009-preprint.pdf>

Examples
Run this code

     data("momo")
     momo

     ## show the period 2000-2008 with customized x-axis annotation
     ## (this is Figure 1 in Hoehle and Mazick, 2010)
     oopts <- surveillance.options("stsTickFactors" = c("%G" = 1.5, "%Q"=.75))
     plot(momo[year(momo) >= 2000,], ylab = "", xlab = "Time (weeks)",
          par.list = list(las = 1), col = c(gray(0.5), NA, NA),
          xaxis.tickFreq = list("%G"=atChange, "%Q"=atChange),
          xaxis.labelFreq = list("%G"=atChange), xaxis.labelFormat = "%G")
     surveillance.options(oopts)

     if (surveillance.options("allExamples")) {

     ## stratified monitoring from 2007-W40 using the Farrington algorithm
     phase2 <- which(epoch(momo) >= "2007-10-01")
     momo2 <- farrington(momo, control = list(range=phase2, alpha=0.01, b=5, w=4))
     print(colSums(alarms(momo2)))
     plot(momo2, col = c(8, NA, 4), same.scale = FALSE)

     ## stripchart of alarms (Figure 5 in Hoehle and Mazick, 2010)
     plot(momo2, type = alarm ~ time, xlab = "Time (weeks)", main = "",
          alarm.symbol = list(pch=3, col=1, cex=1.5))

     }

