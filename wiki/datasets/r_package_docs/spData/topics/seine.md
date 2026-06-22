Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

seine: Small river network in France

Small river network in France

Description

     Lines representing the Seine, Marne and Yonne rivers.

Usage

     seine

Format

     FORMAT:

        * name: name

        * geometry: sfc_MULTILINESTRING

     The object is in the RGF93 / Lambert-93 CRS.

Source

     <https://www.naturalearthdata.com/>

See Also

     See the rnaturalearth package:
     https://cran.r-project.org/package=rnaturalearth


Variables detected from installed object

name: character ; missing=0 ; examples=Marne, Seine, Yonne

geometry: sfc_MULTILINESTRING/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       seine
       plot(seine)
     }
     ## Not run:

     library(sf)
     library(rnaturalearth)
     library(tidyverse)

     seine = ne_download(scale = 10, type = "rivers_lake_centerlines",
                         category = "physical", returnclass = "sf") %>%
             filter(name %in% c("Yonne", "Seine", "Marne")) %>%
             select(name = name_en) %>%
             st_transform(2154)
     ## End(Not run)

