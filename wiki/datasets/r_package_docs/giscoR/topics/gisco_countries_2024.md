Rdocumentation
powered by

Search all packages and functions
giscoR (version 1.1.0)

gisco_countries_2024: Countries 2024 'sf' object

Countries 2024 'sf' object

Description

     This object contains the administrative boundaries at country
     level of the world.

Format

     A ‘sf’ object with ‘MULTIPOLYGON’ geometries, resolution: 1:20
     million and EPSG:4326. with 263 rows and 12 variables:

     ‘CNTR_ID’ Country ID as per Eurostat.

     ‘CNTR_NAME’ Official country name in local language.

     ‘NAME_ENGL’ Country name in English.

     ‘NAME_FREN’ Country name in French.

     ‘ISO3_CODE’ ISO 3166-1 alpha-3 code of each country, as provided
          by GISCO.

     ‘SVRG_UN’ Sovereign status as per United Nations.

     ‘CAPT’ Capital city.

     ‘EU_STAT’ European Union member.

     ‘EFTA_STAT’ EFTA member.

     ‘CC_STAT’ EU candidate member.

     ‘NAME_GERM’ Country name in German.

     ‘geometry’ Geometry field.

Source

     CNTR_RG_20M_2024_4326.gpkg file.

See Also

     ‘gisco_get_countries()’

     Other datasets: ‘gisco_coastal_lines’, ‘gisco_countrycode’,
     ‘gisco_db’, ‘gisco_nuts_2024’


Variables detected from installed object

CNTR_ID: character ; missing=0 ; examples=CD, CF, CG

CNTR_NAME: character ; missing=0 ; examples=République Démocratique du Congo-Kongo-Kongó-Kongu-Kongo, République Centrafricaine-Ködörösêse Tî Bêafrîka, Congo-Kongo-Kongó

NAME_ENGL: character ; missing=0 ; examples=Democratic Republic of The Congo, Central African Republic, Congo

NAME_FREN: character ; missing=19 ; examples=République démocratique du Congo, République centrafricaine, Congo

ISO3_CODE: character ; missing=0 ; examples=COD, CAF, COG

SVRG_UN: character ; missing=0 ; examples=UN Member State

CAPT: character ; missing=30 ; examples=Kinshasa, Bangui, Brazzaville

EU_STAT: character ; missing=0 ; examples=F

EFTA_STAT: character ; missing=0 ; examples=F

CC_STAT: character ; missing=0 ; examples=F

NAME_GERM: character ; missing=20 ; examples=Demokratische Republik Kongo, Zentralafrikanische Republik, Kongo

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     data("gisco_countries_2024")
     head(gisco_countries_2024)

