Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

nz_height: High points in New Zealand

High points in New Zealand

Description

     Top 101 heighest points in New Zealand (2017). See
     <https://data.linz.govt.nz/layer/50284-nz-height-points-topo-150k/>
     for details.

Usage

     nz_height

Format

     FORMAT:

        * t50_fid: ID

        * elevation: Height above sea level in m

        * geometry: sfc_POINT

Source

     <https://data.linz.govt.nz>


Variables detected from installed object

t50_fid: integer ; missing=0 ; examples=2353944, 2354404, 2354405

elevation: integer ; missing=0 ; examples=2723, 2820, 2830

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       summary(nz_height)
       plot(nz$geom)
       plot(nz_height$geom, add = TRUE)
     }
     ## Not run:

     library(dplyr)
     # After downloading data
     unzip("lds-nz-height-points-topo-150k-SHP.zip")
     nz_height = st_read("nz-height-points-topo-150k.shp") %>%
       top_n(n = 100, wt = elevation)
     library(tmap)
     tmap_mode("view")
     qtm(nz) +
       qtm(nz_height)
     f = list.files(pattern = "*nz-height*")
     file.remove(f)
     ## End(Not run)

