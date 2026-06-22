Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

NYleukemia: Upstate New York Leukemia Data

Upstate New York Leukemia Data

Description

     Census tract level (‘n=281’) leukemia data for the 8 counties in
     upstate New York from 1978-1982, paired with population data from
     the 1980 census. Note that 4 census tracts were completely
     surrounded by another unique census tract; when applying the
     Bayesian cluster detection model in ‘bayes_cluster()’, we merge
     them with the surrounding census tracts yielding ‘n=277’ areas.

Usage

     NYleukemia

Format

     List with 5 items:

     geo table of the FIPS code, longitude, and latitude of the
          geographic centroid of each census tract

     data table of the FIPS code, number of cases, and population of
          each census tract

     spatial.polygon bject of class SpatialPolygons

     surrounded row IDs of the 4 census tracts that are completely
          surrounded by the

     surrounding census tracts

References

     Turnbull, B. W. et al (1990) Monitoring for clusters of disease:
     application to leukemia incidence in upstate New York _American
     Journal of Epidemiology_, *132*, 136-143

Examples
Run this code

     ## Load data and convert coordinate system from latitude/longitude to grid
     data(NYleukemia)
     map <- NYleukemia$spatial.polygon
     population <- NYleukemia$data$population
     cases <- NYleukemia$data$cases
     centroids <- latlong2grid(NYleukemia$geo[, 2:3])

     ## Identify the 4 census tract to be merged into their surrounding census tracts.
     remove <- NYleukemia$surrounded
     add <- NYleukemia$surrounding

     ## Merge population and case counts
     population[add] <- population[add] + population[remove]
     population <- population[-remove]
     cases[add] <- cases[add] + cases[remove]
     cases <- cases[-remove]

     ## Modify geographical objects accordingly
     map <- SpatialPolygons(map@polygons[-remove], proj4string=CRS("+proj=longlat +ellps=WGS84"))
     centroids <- centroids[-remove, ]

     ## Plot incidence in latitude/longitude
     plotmap(cases/population, map, log=TRUE, nclr=5)
     points(grid2latlong(centroids), pch=4)

