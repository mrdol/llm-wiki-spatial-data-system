Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

urban_agglomerations: Major urban areas worldwide

Major urban areas worldwide

Description

     Dataset in a 'long' form from the United Nations population
     division with projections up to 2050. Includes only the top 30
     largest areas by population at 5 year intervals.

Usage

     urban_agglomerations

Format

     Selected variables:

        * year: Year of population estimate

        * country_code: Code of country

        * urban_agglomeration: Name of the urban agglomeration

        * population_millions: Estimated human population

        * geometry: sfc_POINT


Variables detected from installed object

index: numeric ; missing=0 ; examples=1, 2, 3

year: numeric ; missing=0 ; examples=1950, 1955, 1960

rank
order: numeric ; missing=0 ; examples=6, 5

country
code: numeric ; missing=0 ; examples=32

country_or_area: character ; missing=0 ; examples=Argentina

city_code: numeric ; missing=0 ; examples=20058

urban_agglomeration: character ; missing=0 ; examples=Buenos Aires

note: numeric ; missing=234 ; examples=1

population_millions: numeric ; missing=0 ; examples=5.16614, 5.910271, 6.761837

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     if (requireNamespace("sf", quietly = TRUE)) {
       library(sf)
       plot(urban_agglomerations)
     }
     # Code used to download the data:
     ## Not run:

     f = "WUP2018-F11b-30_Largest_Cities_in_2018_by_time.xls"
     download.file(
       destfile = f,
       url = paste0("https://population.un.org/wup/Download/Files/", f)
      )
     library(dplyr)
     library(sf)
     urban_agglomerations = readxl::read_excel(f, skip = 16) %>%
         st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)
     names(urban_agglomerations)
     names(urban_agglomerations) <- gsub(" |\\n", "_", tolower(names(urban_agglomerations)) ) %>%
             gsub("\\(|\\)", "", .)
     names(urban_agglomerations)
     urban_agglomerations
     usethis::use_data(urban_agglomerations, overwrite = TRUE)
     file.remove("WUP2018-F11b-30_Largest_Cities_in_2018_by_time.xls")
     ## End(Not run)

