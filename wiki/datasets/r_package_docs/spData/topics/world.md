Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

world: World country polygons

World country polygons

Description

     The object loaded is a ‘sf’ object containing a world map data
     from Natural Earth with a few variables from World Bank

Usage

     world

Format

     Formal class 'sf' [package "sf"]; the data contains a data.frame
     with 177 obs. of 11 variables:

        * iso_a2: character vector of ISO 2 character country codes

        * name_long: character vector of country names

        * continent: character vector of continent names

        * region_un: character vector of region names

        * subregion: character vector of subregion names

        * type: character vector of type names

        * area_km2: integer vector of area values

        * pop: integer vector of population in 2014

        * lifeExp: integer vector of life expectancy at birth in 2014

        * gdpPercap: integer vector of per-capita GDP in 2014

        * geom: sfc_MULTIPOLYGON

     The object is in geographical coordinates using the WGS84 datum.

Source

     <https://www.naturalearthdata.com/>

     <https://data.worldbank.org/>

See Also

     See the rnaturalearth package:
     https://cran.r-project.org/package=rnaturalearth


Variables detected from installed object

iso_a2: character ; missing=2 ; examples=FJ, TZ, EH

name_long: character ; missing=0 ; examples=Fiji, Tanzania, Western Sahara

continent: character ; missing=0 ; examples=Oceania, Africa

region_un: character ; missing=0 ; examples=Oceania, Africa

subregion: character ; missing=0 ; examples=Melanesia, Eastern Africa, Northern Africa

type: character ; missing=0 ; examples=Sovereign country, Indeterminate

area_km2: numeric ; missing=0 ; examples=19289.9707329765, 932745.792357074, 96270.6010408472

pop: numeric ; missing=10 ; examples=885806, 52234869, 35535348

lifeExp: numeric ; missing=10 ; examples=69.96, 64.163, 81.9530487804878

gdpPercap: numeric ; missing=17 ; examples=8222.25378436842, 2402.09940362843, 43079.1425247165

geom: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       data(world)
       # or
       world <- st_read(system.file("shapes/world.gpkg", package="spData"))

       plot(world)
     }

