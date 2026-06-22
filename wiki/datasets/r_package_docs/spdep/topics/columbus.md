Rdocumentation
powered by

Search all packages and functions
spdep (version 1.4.2)

columbus: Columbus OH spatial analysis data set

Columbus OH spatial analysis data set

Description

     The data set is now part of the spData package

Usage

     data(columbus)

Examples
Run this code

     columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1], quiet=TRUE)
     col.gal.nb <- read.gal(system.file("weights/columbus.gal", package="spData")[1])

