Rdocumentation
powered by

Search all packages and functions
giscoR (version 1.1.0)

gisco_coastal_lines: Coastal lines 2016 'sf' object

Coastal lines 2016 'sf' object

Description

     This object contains the coastal lines of the world.

Format

     A ‘sf’ object with ‘POLYGON’ geometries, resolution: 1:20 million
     and EPSG:4326.

Source

     COAS_RG_20M_2016_4326.gpkg file.

See Also

     ‘gisco_get_coastal_lines()’

     Other datasets: ‘gisco_countries_2024’, ‘gisco_countrycode’,
     ‘gisco_db’, ‘gisco_nuts_2024’


Variables detected from installed object

COAS_ID: integer ; missing=0 ; examples=1, 2, 3

geometry: sfc_POLYGON/sfc ; missing=0

Examples
Run this code

     library(sf)
     data("gisco_coastal_lines")
     gisco_coastal_lines

