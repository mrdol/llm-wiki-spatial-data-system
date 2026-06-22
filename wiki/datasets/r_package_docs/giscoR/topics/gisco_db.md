Rdocumentation
powered by

Search all packages and functions
giscoR (version 1.1.0)

gisco_db: Cached GISCO database

Cached GISCO database

Description

     Database with the list of files in the GISCO API as of 2026-01-12.

Format

     A tibble with 9,714 rows.

Details

     This database is used to redirect the corresponding functions to
     the right API endpoints.

     This version of the database is used if there is a problem during
     update. Please use ‘gisco_get_cached_db()’ with ‘update_cache =
     TRUE’ to update the corresponding API endpoints.

Source

     GISCO API ‘datasets.json’.

See Also

     Other datasets: ‘gisco_coastal_lines’, ‘gisco_countries_2024’,
     ‘gisco_countrycode’, ‘gisco_nuts_2024’

     Other database utils: ‘gisco_get_cached_db()’,
     ‘gisco_get_metadata()’


Variables detected from installed object

id_giscor: character ; missing=0 ; examples=coastal_lines

year: numeric ; missing=0 ; examples=2006

epsg: numeric ; missing=90 ; examples=3035

resolution: numeric ; missing=1293 ; examples=1

spatialtype: character ; missing=54 ; examples=RG

nuts_level: character ; missing=4053 ; examples=0

level: character ; missing=9047 ; examples=CITY

ext: character ; missing=0 ; examples=csv, geojson, gpkg

api_file: character ; missing=0 ; examples=csv/COAS_RG_01M_2006_3035.csv, geojson/COAS_RG_01M_2006_3035.geojson, gpkg/COAS_RG_01M_2006_3035.gpkg

api_entry: character ; missing=0 ; examples=https://gisco-services.ec.europa.eu/distribution/v2/coas

last_updated: Date ; missing=0 ; examples=2026-01-12

Examples
Run this code

     data("gisco_db")
     gisco_db |>
       dplyr::glimpse()

