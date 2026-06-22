Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

vv: Precomputed variogram for PM10 in data set air

Precomputed variogram for PM10 in data set air

Description

     Precomputed variogram for PM10 in data set air

Usage

     data(vv)

Format

     data set structure is explained in variogramST.


Variables detected from installed object

np: numeric ; missing=0 ; examples=0, 3456, 16554

dist: numeric ; missing=1 ; examples=13.8102787619448, 29.5017140376743, 49.0977201224818

gamma: numeric ; missing=1 ; examples=10.9839335653935, 23.4168408732029, 29.572173895799

id: character ; missing=0 ; examples=lag0

timelag: numeric ; missing=0 ; examples=0

spacelag: numeric ; missing=0 ; examples=0, 10, 30

avgDist: numeric ; missing=0 ; examples=0, 13.8079103667026, 29.501200003679

Examples
Run this code

     ## Not run:

     # obtained by:
     library(spacetime)
     library(gstat)
     data(air)
     suppressWarnings(proj4string(stations) <- CRS(proj4string(stations)))
     rural = STFDF(stations, dates, data.frame(PM10 = as.vector(air)))
     rr = rural[,"2005::2010"]
     unsel = which(apply(as(rr, "xts"), 2, function(x) all(is.na(x))))
     r5to10 = rr[-unsel,]
     vv = variogram(PM10~1, r5to10, width=20, cutoff = 200, tlags=0:5)
     ## End(Not run)

