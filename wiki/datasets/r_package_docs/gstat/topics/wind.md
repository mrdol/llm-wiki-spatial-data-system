Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

Ireland wind data, 1961-1978

Description

     Daily average wind speeds for 1961-1978 at 12 synoptic
     meteorological stations in the Republic of Ireland (Haslett and
     raftery 1989). Wind speeds are in knots (1 knot = 0.5418 m/s), at
     each of the stations in the order given in Fig.4 of Haslett and
     Raftery (1989, see below)

Usage

     data(wind)

Format

     data.frame ‘wind’ contains the following columns:

     year year, minus 1900

     month month (number) of the year

     day day

     RPT average wind speed in knots at station RPT

     VAL average wind speed in knots at station VAL

     ROS average wind speed in knots at station ROS

     KIL average wind speed in knots at station KIL

     SHA average wind speed in knots at station SHA

     BIR average wind speed in knots at station BIR

     DUB average wind speed in knots at station DUB

     CLA average wind speed in knots at station CLA

     MUL average wind speed in knots at station MUL

     CLO average wind speed in knots at station CLO

     BEL average wind speed in knots at station BEL

     MAL average wind speed in knots at station MAL

     data.frame ‘wind.loc’ contains the following columns:

     Station Station name

     Code Station code

     Latitude Latitude, in DMS, see examples below

     Longitude Longitude, in DMS, see examples below

     MeanWind mean wind for each station, metres per second

Note:

     This data set comes with the following message: ``Be aware that
     the dataset is 532494 bytes long (thats over half a Megabyte).
     Please be sure you want the data before you request it.''

     The data were obtained on Oct 12, 2008, from:
     http://www.stat.washington.edu/raftery/software.html The data are
     also available from statlib.

     Locations of 11 of the stations (ROS, Rosslare has been thrown out
     because it fits poorly the spatial correlations of the other
     stations) were obtained from:
     http://www.stat.washington.edu/research/reports/2005/tr475.pdf

     Roslare lat/lon was obtained from google maps, location Roslare.
     The mean wind value for Roslare comes from Fig. 1 in the original
     paper.

     Haslett and Raftery proposed to use a sqrt-transform to stabilize
     the variance.

Author(s):

     Adrian Raftery; imported to R by Edzer Pebesma

References

     These data were analyzed in detail in the following article:

     Haslett, J. and Raftery, A. E. (1989). Space-time Modelling with
     Long-memory Dependence: Assessing Ireland's Wind Power Resource
     (with Discussion). Applied Statistics 38, 1-50.

     and in many later papers on space-time analysis, for example:

     Tilmann Gneiting, Marc G. Genton, Peter Guttorp: Geostatistical
     Space-Time Models, Stationarity, Separability and Full symmetry.
     Ch. 4 in: B. Finkenstaedt, L. Held, V. Isham, Statistical Methods
     for Spatio-Temporal Systems.


Variables detected from installed object

Station: factor ; missing=0 ; examples=Valentia, Belmullet, Claremorris

Code: factor ; missing=0 ; examples=VAL, BEL, CLA

Latitude: factor ; missing=0 ; examples=51d56'N, 54d14'N, 53d43'N

Longitude: factor ; missing=0 ; examples=10d15'W, 10d00'W, 8d59'W

MeanWind: numeric ; missing=0 ; examples=5.48, 6.75, 4.32

Examples
Run this code

     data(wind)
     summary(wind)
     wind.loc
     library(sp) # char2dms
     wind.loc$y = as.numeric(char2dms(as.character(wind.loc[["Latitude"]])))
     wind.loc$x = as.numeric(char2dms(as.character(wind.loc[["Longitude"]])))
     coordinates(wind.loc) = ~x+y

     ## Not run:

     # fig 1:
     library(maps)
     library(mapdata)
     map("worldHires", xlim = c(-11,-5.4), ylim = c(51,55.5))
     points(wind.loc, pch=16)
     text(coordinates(wind.loc), pos=1, label=wind.loc$Station)
     ## End(Not run)

     wind$time = ISOdate(wind$year+1900, wind$month, wind$day)
     # time series of e.g. Dublin data:
     plot(DUB~time, wind, type= 'l', ylab = "windspeed (knots)", main = "Dublin")

     # fig 2:
     #wind = wind[!(wind$month == 2 & wind$day == 29),]
     wind$jday = as.numeric(format(wind$time, '%j'))
     windsqrt = sqrt(0.5148 * as.matrix(wind[4:15]))
     Jday = 1:366
     windsqrt = windsqrt - mean(windsqrt)
     daymeans = sapply(split(windsqrt, wind$jday), mean)
     plot(daymeans ~ Jday)
     lines(lowess(daymeans ~ Jday, f = 0.1))

     # subtract the trend:
     meanwind = lowess(daymeans ~ Jday, f = 0.1)$y[wind$jday]
     velocity = apply(windsqrt, 2, function(x) { x - meanwind })

     # match order of columns in wind to Code in wind.loc:
     pts = coordinates(wind.loc[match(names(wind[4:15]), wind.loc$Code),])

     # fig 3, but not really yet...
     dists = spDists(pts, longlat=TRUE)
     corv = cor(velocity)
     sel = !(as.vector(dists) == 0)
     plot(as.vector(corv[sel]) ~ as.vector(dists[sel]),
             xlim = c(0,500), ylim = c(.4, 1), xlab = "distance (km.)",
             ylab = "correlation")
     # plots all points twice, ignores zero distance
     # now really get fig 3:
     ros = rownames(corv) == "ROS"
     dists.nr = dists[!ros,!ros]
     corv.nr = corv[!ros,!ros]
     sel = !(as.vector(dists.nr) == 0)
     plot(as.vector(corv.nr[sel]) ~ as.vector(dists.nr[sel]), pch = 3,
             xlim = c(0,500), ylim = c(.4, 1), xlab = "distance (km.)",
             ylab = "correlation")
     # add outlier:
     points(corv[ros,!ros] ~ dists[ros,!ros], pch=16, cex=.5)
     xdiscr = 1:500
     # add correlation model:
     lines(xdiscr, .968 * exp(- .00134 * xdiscr))

