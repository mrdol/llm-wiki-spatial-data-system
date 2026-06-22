Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

waynick.soil: Soil nitrogen and carbon in two fields

Soil nitrogen and carbon in two fields

Description

     Soil nitrogen and carbon in two fields

Format

     A data frame with 200 observations on the following 6 variables.

     ‘field’ field name, 2 levels

     ‘sample’ sample number

     ‘x’ x ordinate

     ‘y’ y ordinate

     ‘nitro’ nitrogen content, percent

     ‘carbon’ carbon content, percent

Details

     Two fields were studied, one at University Farm in Davis, the
     other near Oakley.  The Davis field is silty clay loam, the Oakley
     field is blow sand.

Source

     Waynick, Dean, and Sharp, Leslie. (1918).  Variability in soils
     and its significance to past and future soil investigations, I-II.
     University of California press.
     https://archive.org/details/variabilityinsoi45wayn


Variables detected from installed object

field: factor ; missing=0 ; examples=Davis

sample: integer ; missing=0 ; examples=1, 2, 3

x: integer ; missing=0 ; examples=0

y: integer ; missing=0 ; examples=210, 180, 150

nitro: numeric ; missing=0 ; examples=0.104, 0.086, 0.08

carbon: numeric ; missing=0 ; examples=1.167, 1.048, 0.958

Examples
Run this code

     ## Not run:

     library(agridat)
     data(waynick.soil)
     dat <- waynick.soil

     # Strong relationship between N,C
     libs(lattice)
     xyplot(nitro~carbon|field, data=dat, main="waynick.soil")

     # Spatial plot
     libs(sp, gstat)
     d1 <- subset(dat, field=="Davis")
     d2 <- subset(dat, field=="Oakley")
     coordinates(d1) <- data.frame(x=d1$x, y=d1$y)
     coordinates(d2) <- data.frame(x=d2$x, y=d2$y)
     spplot(d1, zcol = "nitro", cuts=8, cex = 1.6,
            main = "waynick.soil - Davis field - nitrogen",
            col.regions =  bpy.colors(8), key.space = "right")

     # Variogram
     v1 <- gstat::variogram(nitro~1, data=d1)
     plot(v1, main="waynick.soil - Davis field - nitrogen") # Maybe hasn't reached sill
     ## End(Not run)

