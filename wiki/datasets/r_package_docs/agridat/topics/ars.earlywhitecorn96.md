Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

ars.earlywhitecorn96: Multi-environment trial of early white food corn

Multi-environment trial of early white food corn

Description

     Multi-environment trial of early white food corn for 60 white
     hybrids.

Format

     A data frame with 540 observations on the following 9 variables.

     ‘loc’ location, 9 levels

     ‘gen’ gen, 60 levels

     ‘yield’ yield, bu/ac

     ‘stand’ stand, percent

     ‘rootlodge’ root lodging, percent

     ‘stalklodge’ stalk lodging, percent

     ‘earht’ ear height, inches

     ‘flower’ days to flower

     ‘moisture’ moisture, percent

Details

     Data are the average of 3 replications.

     Yields were measured for each plot and converted to bushels / acre
     and adjusted to 15.5 percent moisture.

     Stand is expressed as a percentage of the optimum plant stand.

     Lodging is expressed as a percentage of the total plants for each
     hybrid.

     Ear height was measured from soil level to the top ear leaf
     collar.  Heights are expressed in inches.

     Days to flowering is the number of days from planting to
     mid-tassel or mid-silk.

     Moisture of the grain was measured at harvest.

Source

     L. Darrah, R. Lundquist, D. West, C. Poneleit, B. Barry, B. Zehr,
     A. Bockholt, L. Maddux, K. Ziegler, and P. Martin. (1996).  _White
     Food Corn 1996 Performance Tests_.  Agricultural Research Service
     Special Report 502.


Variables detected from installed object

loc: factor ; missing=0 ; examples=Knoxville,TN

gen: factor ; missing=0 ; examples=AgriGold_A6680W, AgriGold_XA4323W, Asgrow_XP7555W

yield: numeric ; missing=0 ; examples=138.2, 151, 139.6

stand: numeric ; missing=60 ; examples=91.1, 86.1, 94.4

rootlodge: numeric ; missing=240 ; examples=0

stalklodge: numeric ; missing=180 ; examples=0, 0.6

earht: numeric ; missing=240 ; examples=47.3, 45, 46.3

flower: numeric ; missing=300 ; examples=67.3, 67.7, 67

moisture: numeric ; missing=0 ; examples=21.7, 21.5, 19.8

Examples
Run this code

     ## Not run:

       library(agridat)

       data(ars.earlywhitecorn96)
       dat <- ars.earlywhitecorn96

       libs(lattice)
       # These views emphasize differences between locations
       dotplot(gen~yield, dat, group=loc, auto.key=list(columns=3),
               main="ars.earlywhitecorn96")
       ## dotplot(gen~stalklodge, dat, group=loc, auto.key=list(columns=3),
       ##         main="ars.earlywhitecorn96")
       splom(~dat[,3:9], group=dat$loc, auto.key=list(columns=3),
             main="ars.earlywhitecorn96")

       # MANOVA
       m1 <- manova(cbind(yield,earht,moisture) ~ gen + loc, dat)
       m1
       summary(m1)
     ## End(Not run)

