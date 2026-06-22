Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

ichtyo: Point sampling of fish community

Point sampling of fish community

Description

     This data set gives informations between a faunistic array, the
     total number of sampling points made at each sampling occasion and
     the year of the sampling occasion.

Usage

     data(ichtyo)

Format

     ‘ichtyo’ is a list of 3 components.

     tab is a faunistic array with 9 columns and 32 rows.

     eff is a vector of the 32 sampling effort.

     dat is a factor where the levels are the 10 years of the sampling
          occasion.

Details

     The value _n(i,j)_ at the _ith_ row and the _jth_ column in ‘tab’
     corresponds to the number of sampling points of the _ith_ sampling
     occasion (in ‘eff’) that contains the _jth_ species.

Source

     Dolédec, S., Chessel, D. and Olivier, J. M. (1995) L'analyse des
     correspondances décentrée: application aux peuplements
     ichtyologiques du haut-Rhône. _Bulletin Français de la Pêche et de
     la Pisciculture_, *336*, 29-40.

Examples
Run this code

     data(ichtyo)
     dudi1 <- dudi.dec(ichtyo$tab, ichtyo$eff, scannf = FALSE)
     s.class(dudi1$li, ichtyo$dat, wt = ichtyo$eff / sum(ichtyo$eff))

