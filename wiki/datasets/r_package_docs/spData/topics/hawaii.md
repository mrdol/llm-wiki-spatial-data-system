Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

hawaii: Hawaii multipolygon

Hawaii multipolygon

Description

     The object loaded is a ‘sf’ object containing the state of Hawaii
     from the US Census Bureau with a few variables from American
     Community Survey (ACS)

Usage

     hawaii

Format

     Formal class 'sf' [package "sf"]; the data contains a data.frame
     with 1 obs. of 7 variables:

        * GEOID: character vector of geographic identifiers

        * NAME: character vector of state names

        * REGION: character vector of region names

        * AREA: area in square kilometers of units class

        * total_pop_10: numerical vector of total population in 2010

        * total_pop_15: numerical vector of total population in 2015

        * geometry: sfc_MULTIPOLYGON

     The object is in projected coordinates using Hawaii Albers Equal
     Area Conic (ESRI:102007).

Source

     <https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html>

See Also

     See the tigris package: https://cran.r-project.org/package=tigris


Variables detected from installed object

GEOID: character ; missing=0 ; examples=15

NAME: character ; missing=0 ; examples=Hawaii

REGION: factor ; missing=0 ; examples=West

AREA: units ; missing=0 ; examples=27722.6951619174

total_pop_10: numeric ; missing=0 ; examples=1333591

total_pop_15: numeric ; missing=0 ; examples=1406299

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(hawaii)

       plot(hawaii["total_pop_15"])
     }

