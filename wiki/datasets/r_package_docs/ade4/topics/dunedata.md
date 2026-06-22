Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

dunedata: Dune Meadow Data

Dune Meadow Data

Description

     ‘dunedata’ is a data set containing for 20 sites, environmental
     variables and plant species.

Usage

     data(dunedata)

Format

     ‘dunedata’ is a list with 2 components.

     envir is a data frame with 20 rows (sites) 5 columns
          (environnemental variables).

     veg is a data frame with 20 rows (sites) 30 columns (plant
          species).

Source

     Jongman, R. H., ter Braak, C. J. F.  and van Tongeren, O. F. R.
     (1987) _Data analysis in community and landscape ecology_, Pudoc,
     Wageningen.

Examples
Run this code

     data(dunedata)
     summary(dunedata$envir)
     is.ordered(dunedata$envir$use)
     score(dudi.mix(dunedata$envir, scan = FALSE))

