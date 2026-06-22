Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

NYleukemia_sf: Upstate New York Leukemia

Upstate New York Leukemia

Description

     Census tract level (‘n=281’) leukemia data for the 8 counties in
     upstate New York from 1978-1982, paired with population data from
     the 1980 census. Note that 4 census tracts were completely
     surrounded by another unique census tract; when applying the
     Bayesian cluster detection model in ‘bayes_cluster()’, we merge
     them with the surrounding census tracts yielding ‘n=277’ areas.

Usage

     NYleukemia_sf

Format

     An sf 'POLYGON' data frame with 281 rows and 4 variables:

     geometry Geometric representation of 8 counties in upstate New
          York

     cases Number of cases per county

     population Population of each census tract

     censustract.FIPS 11-digit Federal Information Processing System
          identification number for each county

Source

     Turnbull, B. W. et al (1990) Monitoring for clusters of disease:
     application to leukemia incidence in upstate New York _American
     Journal of Epidemiology_, *132*, 136-143


Variables detected from installed object

population: numeric ; missing=0 ; examples=3540, 948, 2519

cases: numeric ; missing=0 ; examples=3.08284, 0.02218, 0.23198

censustract.FIPS: factor ; missing=0 ; examples=36007000100, 36007001000, 36053030402

geometry: sfc_MULTIPOLYGON/sfc ; missing=0

Examples
Run this code

     # Static map of NY Leukemia rate per county
     library(ggplot2)
     ## Not run:

     ggplot(NYleukemia_sf) +
       geom_sf(aes(fill= cases/population)) +
       scale_fill_gradient(low = "white", high = "red")
     ## End(Not run)

