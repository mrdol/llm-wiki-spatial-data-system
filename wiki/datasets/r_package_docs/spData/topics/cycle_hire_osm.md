Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

cycle_hire_osm: Cycle hire points in London from OSM

Cycle hire points in London from OSM

Description

     Dataset downloaded using the osmdata package representing cycle
     hire points accross London.

Usage

     cycle_hire_osm

Format

        * osm_id: The OSM ID

        * name: The name of the cycle point

        * capacity: How many bikes it can take

        * cyclestreets_id: The ID linked to cyclestreets' photomap

        * description: Additional description of points

        * geometry: sfc_POINT

Source

     <https://www.openstreetmap.org>

See Also

     See the osmdata package:
     https://cran.r-project.org/package=osmdata


Variables detected from installed object

osm_id: factor ; missing=0 ; examples=108539, 598093293, 772536185

name: factor ; missing=92 ; examples=Windsor Terrace, Pancras Road, King's Cross, Clerkenwell, Ampton Street

capacity: numeric ; missing=115 ; examples=14, 11, 20

cyclestreets_id: factor ; missing=539 ; examples=26743

description: factor ; missing=533 ; examples=Barclays Cycle Hire

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(cycle_hire_osm)
       # or
       cycle_hire_osm <- st_read(system.file("shapes/cycle_hire_osm.geojson", package="spData"))

       plot(cycle_hire_osm)
     }

     # Code used to download the data:
     ## Not run:

     library(osmdata)
     library(dplyr)
     library(sf)
     q = add_osm_feature(opq = opq("London"), key = "network", value = "tfl_cycle_hire")
     lnd_cycle_hire = osmdata_sf(q)
     cycle_hire_osm = lnd_cycle_hire$osm_points
     nrow(cycle_hire_osm)
     plot(cycle_hire_osm)
     cycle_hire_osm = dplyr::select(cycle_hire_osm, osm_id, name, capacity,
                                    cyclestreets_id, description) %>%
       mutate(capacity = as.numeric(capacity))
     names(cycle_hire_osm)
     nrow(cycle_hire_osm)
     ## End(Not run)

