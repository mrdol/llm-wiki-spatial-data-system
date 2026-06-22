Rdocumentation
powered by

Search all packages and functions
SpatialEpi (version 1.2.8)

pennLC: Pennsylvania Lung Cancer

Pennsylvania Lung Cancer

Description

     County-level (n=67) population/case data for lung cancer in
     Pennsylvania in 2002, stratified on race (white vs non-white),
     gender and age (Under 40, 40-59, 60-69 and 70+).  Additionally,
     county-specific smoking rates.

Usage

     pennLC

Format

     List of 3 items

     geo a table of county IDs, longitude/latitude of the geographic
          centroid of each county

     data a table of county IDs, number of cases, population and strata
          information

     smoking a table of county IDs and proportion of smokers

     spatial.polygon an object of class SpatialPolygons

Source

     Population data was obtained from the 2000 decennial census, lung
     cancer and smoking data were obtained from the Pennsylvania
     Department of Health website:
     <https://www.health.pa.gov/Pages/default.aspx>

Examples
Run this code

     data(pennLC)
     pennLC$geo
     pennLC$data
     pennLC$smoking
     # Map smoking rates in Pennsylvania
     mapvariable(pennLC$smoking[,2], pennLC$spatial.polygon)

