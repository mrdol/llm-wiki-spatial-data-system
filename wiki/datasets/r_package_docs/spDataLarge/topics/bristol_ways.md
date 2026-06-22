Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

bristol_ways: Datasets providing a snapshot of Bristol's transport system

Datasets providing a snapshot of Bristol's transport system

Description

     Data used in the transport chapter in Geocomputation with R. See
     <https://r.geocompx.org/transport.html> for details.

Usage

     bristol_ways

Format

     sf data frame objects

Source

     <https://wicid.ukdataservice.ac.uk/> and other open access sources


Variables detected from installed object

highway: factor ; missing=0 ; examples=road

maxspeed: character ; missing=2465 ; examples=20 mph, 70 mph

ref: character ; missing=2333 ; examples=B3130, M4

geometry: sfc_LINESTRING/sfc ; missing=0

Examples
Run this code

     ## Not run:

     library(sf)
     bristol_ways
     bristol_od
     bristol_region
     bristol_ttwa
     bristol_zones
     bristol_stations
     ## End(Not run)

