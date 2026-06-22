Rdocumentation
powered by

Search all packages and functions
giscoR (version 1.1.0)

gisco_nuts_2024: NUTS 2024 'sf' object

NUTS 2024 'sf' object

Description

     This dataset represents the regions for levels 0, 1, 2 and 3 of
     the Nomenclature of Territorial Units for Statistics (NUTS) for
     2024.

Format

     A ‘sf’ object with ‘MULTIPOLYGON’ geometries, resolution: 1:20
     million and EPSG:4326. with 1798 rows and 10 variables:

     ‘NUTS_ID’ NUTS identifier.

     ‘LEVL_CODE’ NUTS level code (0,1,2,3).

     ‘CNTR_CODE’ Eurostat Country code.

     ‘NAME_LATN’ NUTS name on Latin characters.

     ‘NUTS_NAME’ NUTS name on local alphabet.

     ‘MOUNT_TYPE’ Mount Type, see *Details*.

     ‘URBN_TYPE’ Urban Type, see *Details*.

     ‘COAST_TYPE’ Coast Type, see *Details*.

     ‘geo’ Same as ‘NUTS_ID’, provided for compatibility with
          ‘eurostat’.

     ‘geometry’ geometry field.

Details

     ‘MOUNT_TYPE’: Mountain typology:

        * ‘1’: More than 50 % of the surface is covered by topographic
          mountain areas.

        * ‘2’: More than 50 % of the regional population lives in
          topographic mountain areas.

        * ‘3’: More than 50 % of the surface is covered by topographic
          mountain areas and where more than 50 % of the regional
          population lives in these mountain areas.

        * ‘4’: Non-mountain region / other regions.

        * ‘0’: No classification provided.

     ‘URBN_TYPE’: Urban-rural typology:

        * ‘1’: Predominantly urban region.

        * ‘2’: Intermediate region.

        * ‘3’: Predominantly rural region.

        * ‘0’: No classification provided.

     ‘COAST_TYPE’: Coastal typology:

        * ‘1’: Coastal (on coast).

        * ‘2’: Coastal (less than 50% of population living within 50
          km. of the coastline).

        * ‘3’: Non-coastal region.

        * ‘0’: No classification provided.

Source

     NUTS_RG_20M_2024_4326.gpkg file.

See Also

     ‘gisco_get_nuts()’

     Other datasets: ‘gisco_coastal_lines’, ‘gisco_countries_2024’,
     ‘gisco_countrycode’, ‘gisco_db’


Variables detected from installed object

NUTS_ID: character ; missing=0 ; examples=AL011, AL012, AL013

LEVL_CODE: integer ; missing=0 ; examples=3

CNTR_CODE: character ; missing=0 ; examples=AL

NAME_LATN: character ; missing=0 ; examples=Dibër, Durrës, Kukës

NUTS_NAME: character ; missing=0 ; examples=Dibër, Durrës, Kukës

MOUNT_TYPE: integer ; missing=1448 ; examples=1

URBN_TYPE: integer ; missing=633 ; examples=3

COAST_TYPE: integer ; missing=1457 ; examples=1

geo: character ; missing=0 ; examples=AL011, AL012, AL013

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     data("gisco_nuts_2024")
     head(gisco_nuts_2024)

