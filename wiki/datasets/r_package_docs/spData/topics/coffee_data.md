Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

coffee_data: World coffee production data

World coffee production data

Description

     A tiny dataset containing estimates of global coffee in thousands
     of 60 kg bags produced by country. Purpose: teaching **not**
     research.

Usage

     coffee_data

Format

     A data frame (tibble) with 58 for the following 12 variables:

        * name_long: name of country or coffee variety

        * coffee_production_2016: production in 2016

        * coffee_production_2017: production in 2017

Details

     The examples section shows how this can be joined with spatial
     data to create a simple map.

Source

     The International Coffee Organization (ICO). See
     http://www.ico.org/ and http://www.ico.org/prices/m1-exports.pdf


Variables detected from installed object

name_long: character ; missing=0 ; examples=Angola, Bolivia, Brazil

coffee_production_2016: integer ; missing=9 ; examples=3, 3277, 37

coffee_production_2017: integer ; missing=11 ; examples=4, 2786, 38

Examples
Run this code

     head(coffee_data)
     ## Not run:

     if (requireNamespace("dplyr")) {
     library(dplyr)
     library(sf)
     # found by searching for "global coffee data"
     u = "http://www.ico.org/prices/m1-exports.pdf"
     download.file(u, "data.pdf", mode = "wb")
     if (requireNamespace("pdftables")) { # requires api key
     pdftables::convert_pdf(input_file = "data.pdf", output_file = "coffee-data-messy.csv")
     d = read_csv("coffee-data-messy.csv")
     file.remove("coffee-data-messy.csv")
     file.remove("data.pdf")
     coffee_data = slice(d, -c(1:9)) %>%
             select(name_long = 1, coffee_production_2016 = 2, coffee_production_2017 = 3) %>%
             filter(!is.na(coffee_production_2016)) %>%
             mutate_at(2:3, str_replace, " ", "") %>%
             mutate_at(2:3, as.integer)
     world_coffee = left_join(world, coffee_data)
     plot(world_coffee[c("coffee_production_2016", "coffee_production_2017")])
     b = c(0, 500, 1000, 2000, 3000)
     library(tmap)
     tm_shape(world_coffee) +
       tm_fill("coffee_production_2017", title = "Thousand 60kg bags", breaks = b,
               textNA = "No data", colorNA = NULL)
     tmap_mode("view") # for an interactive version
     }}
     ## End(Not run)

