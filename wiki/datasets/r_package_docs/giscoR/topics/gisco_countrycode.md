Rdocumentation
powered by

Search all packages and functions
giscoR (version 1.1.0)

gisco_countrycode: Database with different country code schemes and world regions

Database with different country code schemes and world regions

Description

     A tibble containing conversions between different country code
     schemes (Eurostat/ISO2 and 3) as well as geographic regions as
     provided by the World Bank and the UN (M49 Standard). This
     database has been extracted from the ‘countrycode’ package.

Format

     A data frame object with 249 rows and 13 variables:

     ‘ISO3_CODE’ Eurostat code of each country.

     ‘CNTR_CODE’ ISO 3166-1 alpha-2 code of each country.

     ‘iso2c’ ISO 3166-1 alpha-3 code of each country.

     ‘iso.name.en’ ISO English short name.

     ‘cldr.short.en’ English short name as provided by the Unicode
          Common Locale Data Repository.

     ‘continent’ As provided by the World Bank.

     ‘un.region.code’ Numeric region code UN (M49).

     ‘un.region.name’ Region name UN (M49).

     ‘un.regionintermediate.code’ Numeric intermediate Region.

     ‘un.regionintermediate.name’ Intermediate Region name UN (M49).

     ‘un.regionsub.code’ Numeric sub-region code UN (M49).

     ‘un.regionsub.name’ Sub-Region name UN (M49).

     ‘eu’ Logical indicating if the country belongs to the European
          Union.

World Regions:

     Regions are defined as per the geographic regions defined by the
     UN (see <https://unstats.un.org/unsd/methodology/m49/>. Under this
     scheme Cyprus is assigned to Asia.

Source

     countrycode::codelist *v1.6.1*.

See Also

     ‘gisco_get_countries()’, countrycode::codelist.

     See also the Unicode Common Locale Data Repository.

     Other datasets: ‘gisco_coastal_lines’, ‘gisco_countries_2024’,
     ‘gisco_db’, ‘gisco_nuts_2024’


Variables detected from installed object

ISO3_CODE: character ; missing=0 ; examples=ABW, AFG, AGO

CNTR_CODE: character ; missing=5 ; examples=AW, AF, AO

iso2c: character ; missing=0 ; examples=AW, AF, AO

iso.name.en: character ; missing=0 ; examples=Aruba, Afghanistan, Angola

cldr.short.en: character ; missing=3 ; examples=Aruba, Afghanistan, Angola

continent: character ; missing=7 ; examples=Americas, Asia, Africa

un.region.code: numeric ; missing=2 ; examples=19, 142, 2

un.region.name: character ; missing=2 ; examples=Americas, Asia, Africa

un.regionintermediate.code: numeric ; missing=142 ; examples=29, 17

un.regionintermediate.name: character ; missing=142 ; examples=Caribbean, Middle Africa

un.regionsub.code: numeric ; missing=2 ; examples=419, 34, 202

un.regionsub.name: character ; missing=2 ; examples=Latin America and the Caribbean, Southern Asia, Sub-Saharan Africa

eu: logical ; missing=0 ; examples=FALSE

Examples
Run this code

     data("gisco_countrycode")
     dplyr::glimpse(gisco_countrycode)

