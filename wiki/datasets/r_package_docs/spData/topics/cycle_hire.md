Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

cycle_hire: Cycle hire points in London

Cycle hire points in London

Description

     Points representing cycle hire points accross London.

Usage

     cycle_hire

Format

     FORMAT:

        * id: Id of the hire point

        * name: Name of the point

        * area: Area they are in

        * nbikes: The number of bikes currently parked there

        * nempty: The number of empty places

        * geometry: sfc_POINT

Source

     <https://www.data.gov.uk/>


Variables detected from installed object

id: integer ; missing=0 ; examples=1, 2, 3

name: factor ; missing=0 ; examples=River Street, Phillimore Gardens, Christopher Street

area: factor ; missing=0 ; examples=Clerkenwell, Kensington, Liverpool Street

nbikes: integer ; missing=0 ; examples=4, 2, 0

nempty: integer ; missing=0 ; examples=14, 34, 32

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(cycle_hire)
       # or
       cycle_hire <- st_read(system.file("shapes/cycle_hire.geojson", package="spData"))

       plot(cycle_hire)
     }

     ## Not run:

     # Download the data
     cycle_hire = readr::read_csv("http://cyclehireapp.com/cyclehirelive/cyclehire.csv",
       col_names = FALSE, skip = TRUE)
     cycle_hire = cycle_hire[c_names]
     c_names = c("id", "name", "area", "lat", "lon", "nbikes", "nempty")
     cycle_hire = st_sf(cycle_hire, st_multipoint(c_names[c("lon", "lat")]))
     ## End(Not run)

