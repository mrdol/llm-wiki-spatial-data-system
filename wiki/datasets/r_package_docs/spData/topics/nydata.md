Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

nydata: New York leukemia data

New York leukemia data

Description

     New York leukemia data taken from the data sets supporting Waller
     and Gotway 2004 (the data should be loaded by running
     ‘example(NY_data)’ to demonstrate spatial data import techniques)

Usage

     nydata

Format

     A data frame with 281 observations on the following 12 variables,
     and the binary coded spatial weights used in the source.

        * AREANAME: name of census tract

        * AREAKEY: unique FIPS code for each tract

        * X: x-coordinate of tract centroid (in km)

        * Y: y-coordinate of tract centroid (in km)

        * POP8: population size (1980 U.S. Census)

        * TRACTCAS: number of cases 1978-1982

        * PROPCAS: proportion of cases per tract

        * PCTOWNHOME: percentage of people in each tract owning their
          own home

        * PCTAGE65P: percentage of people in each tract aged 65 or more

        * Z: ransformed propoprtions

        * AVGIDIST: average distance between centroid and TCE sites

        * PEXPOSURE: "exposure potential": inverse distance between
          each census tract centroid and the nearest TCE site, IDIST,
          transformed via log(100*IDIST)

        * Cases: as TRACTCAS with more digits

        * Xm: X in metres

        * Ym: Y in metres

        * Xshift: feature offset

        * Yshift: feature offset

Details

     The examples section shows how the DBF files from the book website
     for Chapter 9 were converted into the ‘nydata’ data frame and the
     ‘listw_NY’ spatial weights list. The ‘shapes’ directory includes
     the original version of the UTM18 census tract boundaries imported
     from BNA format
     (http://sedac.ciesin.columbia.edu/ftpsite/pub/census/usa/tiger/ny/bna_st/t8_36.zip)
     before the OGR/GDAL BNA driver was available. The ‘NY8_utm18’
     shapefile was constructed using a bna2mif converter and converted
     to shapefile format after adding data using ‘writeOGR’. The new
     file ‘NY8_bna_utm18.gpkg’ has been constructed from the original
     BNA file, but read using the OGR BNA driver with GEOS support. The
     NY8 shapefile and GeoPackage NY8_utm18.gpkg include invalid
     polygons, but because the OGR BNA driver may have GEOS support
     (used here), the tract polygon objects in NY8_bna_utm18.gpkg are
     valid.

Source

     http://www.sph.emory.edu/~lwaller/ch9index.htm

References

     Waller, L. and C. Gotway (2004) _Applied Spatial Statistics for
     Public Health Data_. New York: John Wiley and Sons.


Variables detected from installed object

AREANAME: factor ; missing=83 ; examples=Binghamton city

AREAKEY: factor ; missing=0 ; examples=36007000100, 36007000200, 36007000300

X: numeric ; missing=0 ; examples=4.069397, 4.639371, 5.709063

Y: numeric ; missing=0 ; examples=-67.3533, -66.8619, -66.9775

POP8: numeric ; missing=0 ; examples=3540, 3560, 3739

TRACTCAS: numeric ; missing=0 ; examples=3.08, 4.08, 1.09

PROPCAS: numeric ; missing=0 ; examples=0.00087, 0.001146, 0.000292

PCTOWNHOME: numeric ; missing=0 ; examples=0.32773109, 0.42682927, 0.33773959

PCTAGE65P: numeric ; missing=0 ; examples=0.14661017, 0.23511236, 0.13800481

Z: numeric ; missing=0 ; examples=0.14197, 0.35555, -0.58165

AVGIDIST: numeric ; missing=0 ; examples=0.2373852, 0.2087413, 0.1708548

PEXPOSURE: numeric ; missing=0 ; examples=3.167099, 3.038511, 2.838229

Examples
Run this code

     ## NY leukemia

     if (requireNamespace("sf", quietly = TRUE)) {
     library(foreign)
     nydata <- read.dbf(system.file("misc/nydata.dbf", package="spData")[1])
     nydata <- sf::st_as_sf(nydata, coords=c("X", "Y"), remove=FALSE)
     plot(sf::st_geometry(nydata))

     nyadjmat <- as.matrix(read.dbf(system.file("misc/nyadjwts.dbf",
                                                package="spData")[1])[-1])
     ID <- as.character(names(read.dbf(system.file("misc/nyadjwts.dbf",
                                                   package="spData")[1]))[-1])
     identical(substring(ID, 2, 10), substring(as.character(nydata$AREAKEY), 2, 10))

     if (requireNamespace("sf", quietly = TRUE)) {
     library(spdep)
     listw_NY <- mat2listw(nyadjmat, as.character(nydata$AREAKEY), style="B")
     }
     }

