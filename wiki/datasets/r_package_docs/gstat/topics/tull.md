Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

tull: Südliche Tullnerfeld data set

Südliche Tullnerfeld data set

Description

     The Südliche Tullnerfeld is a part of the Danube river basin in
     central Lower Austria and due to its homogeneous aquifer well
     suited for a model-oriented geostatistical analysis. It contains
     36 official water quality measurement stations, which are
     irregularly spread over the region.

Usage

     data(tull)

Format

     The data frames contain the following columns:

     x X location in meter

     y Y location in meter

     S411 Station name

     S429 Station name

     S849 Station name

     S854 Station name

     S1502 Station name

     S1584 Station name

     S1591 Station name

     S2046 Station name

     S2047 Station name

     S2048 Station name

     S2049 Station name

     S2051 Station name

     S2052 Station name

     S2053 Station name

     S2054 Station name

     S2055 Station name

     S2057 Station name

     S2058 Station name

     S2059 Station name

     S2060 Station name

     S2061 Station name

     S2062 Station name

     S2063 Station name

     S2064 Station name

     S2065 Station name

     S2066 Station name

     S2067 Station name

     S2070 Station name

     S2071 Station name

     S2072 Station name

     S2128 Station name

     S5319 Station name

     S5320 Station name

     S5321 Station name

     S5322 Station name

     S5323 Station name

References

     Werner G. Müller, Collecting Spatial Data, 3rd edition. Springer
     Verlag, Heidelberg, 2007


Variables detected from installed object

x: numeric ; missing=0 ; examples=-0.35033708, 0.44179775, 0.34910112

y: numeric ; missing=0 ; examples=0.12268914, -0.06204494, 0.01139326

Examples
Run this code

     data(tull)

     # TULLNREG = read.csv("TULLNREG.csv")

     # I modified tulln36des.csv, such that the first line only contained: x,y
     # resulting in row.names that reflect the station ID, as in
     # tull36 = read.csv("tulln36des.csv")

     # Chlorid92 was read & converted by:
     #Chlorid92=read.csv("Chlorid92.csv")
     #Chlorid92$Datum = as.POSIXct(strptime(Chlorid92$Datum, "%d.%m.%y"))

     summary(tull36)
     summary(TULLNREG)
     summary(Chlorid92)

     # stack & join data to x,y,Date,Chloride form:
     cl.st = stack(Chlorid92[-1])
     names(cl.st) = c("Chloride", "Station")
     cl.st$Date = rep(Chlorid92$Datum, length(names(Chlorid92))-1)
     cl.st$x = tull36[match(cl.st[,"Station"], row.names(tull36)), "x"]
     cl.st$y = tull36[match(cl.st[,"Station"], row.names(tull36)), "y"]
     # library(lattice)
     # xyplot(Chloride~Date|Station, cl.st)
     # xyplot(y~x|Date, cl.st, asp="iso", layout=c(16,11))
     summary(cl.st)
     plot(TULLNREG, pch=3, asp=1)
     points(y~x, cl.st, pch=16)

