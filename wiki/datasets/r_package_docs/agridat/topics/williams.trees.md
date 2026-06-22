Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

williams.trees: Multi-environment trial of trees, height / survival of 37 species at 6 sites in Thailand

Multi-environment trial of trees, height / survival of 37 species at 6
sites in Thailand

Description

     Multi-environment trial of trees, height / survival of 37 species
     at 6 sites in Thailand

Format

     A data frame with 222 observations on the following 4 variables.

     ‘env’ Environment factor, 6 levels

     ‘gen’ Genetic factor, 37 levels

     ‘height’ Height (cm)

     ‘survival’ Survival percentage

Details

     Planted in 1985 at six sites in Thailand.  RCB with 3 reps.  The
     data here is the mean of the three reps.  Plots were 5 meters
     square with spacing 2m x 2m.  Measurements collected at 24 months.
     The ‘gen’ column in the data is actually _seedlot_, as some tree
     species have multiple seed lots.  The trees are mostly acacia and
     eucalyptus.

     Used with permission of Emlyn Williams.

Source

     Williams, ER and Luangviriyasaeng, V. 1989.  Statistical analysis
     of tree species trial and seedlot:site interaction in Thailand.
     Chapter 14 of _Trees for the Tropics: Growing Australian
     Multipurpose Trees and Shrubs in Developing Countries_. Pages
     145-152.  https://aciar.gov.au/publication/MN010

References

     E. R. Williams and A. C. Matheson and C. E Harwood, Experimental
     Design and Analysis for Tree Improvement.  CSIRO Publishing, 2002.


Variables detected from installed object

env: factor ; missing=0 ; examples=Ratchaburi

gen: factor ; missing=0 ; examples=G01, G02, G03

height: integer ; missing=0 ; examples=334, 348, 424

survival: integer ; missing=0 ; examples=49, 86, 72

Examples
Run this code

     ## Not run:

     library(agridat)
     data(williams.trees)
     dat <- williams.trees

     libs(lattice)
     xyplot(survival~height|env,dat, main="williams.trees", xlab="Height",
     ylab="Percent surviving")
     ## End(Not run)

