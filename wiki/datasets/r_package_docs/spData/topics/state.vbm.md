Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

state.vbm: US State Visibility Based Map

US State Visibility Based Map

Description

     A SpatialPolygonsDataFrame object to plot a Visibility Based Map.

Usage

     state.vbm

Format

     An object of class ‘SpatialPolygonsDataFrame’ with 50 rows and 2
     columns.

Details

     A SpatialPolygonsDataFrame object to plot a map of the US states
     where the sizes of the states have been adjusted to be more equal.
     This map can be useful for plotting state data using colors
     patterns without the larger states dominating and the smallest
     states being lost. The original map is copyrighted by Mark
     Monmonier.  Official publications based on this map should
     acknowledge him. Comercial publications of maps based on this
     probably need permission from him to use.

Author(s):

     Greg Snow <mailto:greg.snow@imail.org> (of this compilation)

Source

     The data was converted from the maps library for S-PLUS.  S-PLUS
     uses the map with permission from the author. This version of the
     data has not received permission from the author (no attempt made,
     not that it was refused), most of my uses I feel fall under fair
     use and do not violate copyright, but you will need to decide for
     yourself and your applications.

References

     <http://www.markmonmonier.com/index.htm>,
     <http://euclid.psych.yorku.ca/SCS/Gallery/bright-ideas.html>


Variables detected from installed object

center_x: numeric ; missing=0 ; examples=92.8459383753501, 10.2258503401361, 31.9299719887955

center_y: numeric ; missing=0 ; examples=26.2100840336135, 18.556462585034, 33.2408963585434

Examples
Run this code

     if (requireNamespace("sp", quietly = TRUE)) {
       library(sp)
       data(state.vbm)
       plot(state.vbm)

       tmp <- state.x77[, 'HS Grad']
       tmp2 <- cut(tmp, seq(min(tmp), max(tmp), length.out=11),
                 include.lowest=TRUE)
       plot(state.vbm, col=cm.colors(10)[tmp2])
     }

