Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

alaska: Alaska multipolygon

Alaska multipolygon

Description

     The object loaded is a ‘sf’ object containing the state of Alaska
     from the US Census Bureau with a few variables from American
     Community Survey (ACS)

Usage

     alaska

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

     The object is in projected coordinates using Alaska Albers
     (EPSG:3467).

Source

     <https://www.census.gov/geographies/mapping-files/time-series/geo/tiger-line-file.html>

See Also

     See the tigris package: https://cran.r-project.org/package=tigris


Variables detected from installed object

GEOID: character ; missing=0 ; examples=02

NAME: character ; missing=0 ; examples=Alaska

REGION: factor ; missing=0 ; examples=West

AREA: units ; missing=0 ; examples=1718924.55674743

total_pop_10: numeric ; missing=0 ; examples=691189

total_pop_15: numeric ; missing=0 ; examples=733375

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(alaska)

       plot(alaska["total_pop_15"])
     }

