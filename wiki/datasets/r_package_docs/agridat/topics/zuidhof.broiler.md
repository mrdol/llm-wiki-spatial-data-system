Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

zuidhof.broiler: Daily weight, feed, egg measurements for a broiler chicken

Daily weight, feed, egg measurements for a broiler chicken

Description

     Daily weight, feed, egg measurements for a broiler chicken

Format

     A data frame with 59 observations on the following 6 variables.

     ‘bw’ Body weight, grams

     ‘targetbw’ Target body weight, grams

     ‘adfi’ Average daily feed intake, grams

     ‘adg’ Average daily gain, grams

     ‘eggwt’ Egg weight, grams

     ‘age’ Age, days

Details

     Using graphs like the one in the examples section, the authors
     discovered that a drop in body weight commonly occurs around the
     time of first egg production.

     Used with permission of Martin Zuidhof.

Source

     Martin J. Zuidhof and Robert A. Renema and Frank E. Robinson,
     (2008).  Understanding Multiple, Repeated Animal Measurements with
     the Help of PROC GPLOT.  SAS Global Forum 2008, Paper 250-2008.
     https://support.sas.com/resources/papers/proceedings/pdfs/sgf2008/250-2008.pdf


Variables detected from installed object

bw: integer ; missing=35 ; examples=2068, 2132, 2234

targetbw: integer ; missing=35 ; examples=2216, 2278, 2369

adfi: numeric ; missing=35 ; examples=85, 91.7, 99.5

adg: numeric ; missing=35 ; examples=2.8, 21.3, 25.5

eggwt: numeric ; missing=9 ; examples=50.1, 52.3, 51.1

age: integer ; missing=0 ; examples=143, 146, 150

Examples
Run this code

     ## Not run:

     library(agridat)
     data(zuidhof.broiler)
     dat <- zuidhof.broiler

     dat <- transform(dat, age=age/7) # Change days into weeks

     # Reproducing figure 1 of Zuidhof et al.

     # Plot using left axis
     op <- par(mar=c(5,4,4,4))
     plot(bw~age, dat, xlab="Age (weeks)", ylab="Bodyweight (g)",
          main="zuidhof.broiler",
          xlim=c(20,32), ylim=c(0,4000), pch=20)
     lines(targetbw~age, subset(dat, !is.na(targetbw)), col="black")

     # Now plot using the right axis
     par(new=TRUE)
     plot(adfi~age, subset(dat, !is.na(adfi)),
          xlab="", ylab="", xlim=c(20,32), xaxt="n",yaxt="n",
          ylim=c(-50,175), type="s", lty=2)
     axis(4, at=c(-50,-25,0,25,50,75,100,125,150,175), col="red", col.axis="red")
     mtext("Weight (g)", side=4, line=2, col="red")
     lines(adg~age, subset(dat, !is.na(adg)), col="red", type="s", lty=1, lwd=2)
     abline(h=c(0,52), col="red")
     with(dat, segments(age, 0, age, eggwt, col="red"))

     legend(20, -40, c("Body weight", "Target BW", "Feed/day", "Gain/day", "Egg wt"),
            bty="n", cex=.5, ncol=5,
            col=c("black","black","red","red","red"),
            lty=c(-1,1,2,1,1), lwd=c(1,1,1,2,1), pch=c(20,-1,-1,-1,-1))
     par(op)
     ## End(Not run)

