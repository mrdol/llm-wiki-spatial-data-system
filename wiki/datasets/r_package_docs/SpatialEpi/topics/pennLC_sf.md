Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

pennLC_sf: Pennsylvania Lung Cancer

Pennsylvania Lung Cancer

Description

     County-level (n=67) population/case data for lung cancer in
     Pennsylvania in 2002, stratified on race (white vs non-white),
     gender and age (Under 40, 40-59, 60-69 and 70+). Additionally,
     county-specific smoking rates.

Usage

     pennLC_sf

Format

     An sf ‘POLYGON’ data frame with 1072 rows = 67 counties x 2 race x
     2 gender x 4 age bands

     county Pennsylvania county

     cases Number of cases per county split by strata

     population Population per county split by strata

     race Race (w = white and o = non-white)

     gender Gender (f = female and m = male)

     age Age (4 bands)

     smoking Overall county smoking rate (not broken down by strata)

     geometry Geometric representation of counties in Pennsylvania

Source

     Population data was obtained from the 2000 decennial census, lung
     cancer and smoking data were obtained from the Pennsylvania
     Department of Health
     website:<https://www.health.pa.gov/Pages/default.aspx>.


Variables detected from installed object

county: character ; missing=0 ; examples=adams

cases: integer ; missing=0 ; examples=0, 1

population: integer ; missing=0 ; examples=1492, 365, 68

race: factor ; missing=0 ; examples=o

gender: factor ; missing=0 ; examples=f

age: factor ; missing=0 ; examples=Under.40, 40.59, 60.69

smoking: numeric ; missing=0 ; examples=0.234

geometry: sfc_POLYGON/sfc ; missing=0

Examples
Run this code

     library(ggplot2)
     library(dplyr)
     # Sum cases & population for each county
     lung_cancer_rate <- pennLC_sf %>%
       group_by(county) %>%
       summarize(cases = sum(cases), population = sum(population)) %>%
       mutate(rate = cases/population)

     # Static map of Pennsylvania lung cancer rates for each county
     ## Not run:

     ggplot() +
       geom_sf(data = lung_cancer_rate, aes(fill = rate))
     ## End(Not run)

