Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

lnd: The boroughs of London

The boroughs of London

Description

     Polygons representing large administrative zones in London

Usage

     lnd

Format

        * NAME: Borough name

        * GSS_CODE: Official code

        * HECTARES: How many hectares

        * NONLD_AREA: Area outside London

        * ONS_INNER: Office for national statistics code

        * SUB_2009: Empty column

        * SUB_2006: Empty column

        * geometry: sfc_MULTIPOLYGON

Source

     <https://github.com/Robinlovelace/Creating-maps-in-R>


Variables detected from installed object

NAME: factor ; missing=0 ; examples=Kingston upon Thames, Croydon, Bromley

GSS_CODE: factor ; missing=0 ; examples=E09000021, E09000008, E09000006

HECTARES: numeric ; missing=0 ; examples=3726.117, 8649.441, 15013.487

NONLD_AREA: numeric ; missing=0 ; examples=0

ONS_INNER: factor ; missing=0 ; examples=F

SUB_2009: factor ; missing=33

SUB_2006: factor ; missing=33

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(lnd)
       summary(lnd)
       plot(st_geometry(lnd))
     }

