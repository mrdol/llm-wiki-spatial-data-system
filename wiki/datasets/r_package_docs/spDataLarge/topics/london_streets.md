Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

london_streets: Streets of london downloaded from OSM

Streets of london downloaded from OSM

Description

     Data used in the "Bridges to GIS" chapter in Geocomputation with
     R. See <https://r.geocompx.org/gis.html> for details.

Usage

     london_streets

Format

     An sf-object with one attribute (‘osm_id’) and one ‘geometry’
     column.

Source

     OpenStreetMap (see <https://www.openstreetmap.org/>).


Variables detected from installed object

osm_id: factor ; missing=0 ; examples=31030, 31039, 31959

geometry: sfc_LINESTRING/sfc ; missing=0

Examples
Run this code

     ## Not run:

     library(sf)
     library(osmdata)
     library(spData)
     library(dplyr)
     data(cycle_hire)
     points = cycle_hire[1:25, ]
     b_box = sf::st_bbox(points)
     london_streets = opq(b_box) %>%
             add_osm_feature(key = "highway") %>%
             osmdata_sf() %>%
             `[[`("osm_lines")
     london_streets = dplyr::select(london_streets, 1)
     ## End(Not run)

