Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

nbfires: Point Patterns of New Brunswick Forest Fires

Point Patterns of New Brunswick Forest Fires

Description

     Point patterns created from yearly records, provided by the New
     Brunswick Department of Natural Resources, of all fires falling
     under their jurisdiction for the years 1987 to 2003 inclusive
     (with the year 1988 omitted until further notice).

Usage

     data(nbfires)

Format

     Executing ‘data(nbfires)’ gives access to four objects: ‘nbfires’,
     ‘nbw.rect’, ‘nbw.seg’ and ‘nbfires.extra’.

     The object ‘nbfires’ is a marked point pattern (an object of class
     ‘"ppp"’) consisting of all of the fires in the years 1987 to 2003
     inclusive, with the omission of 1988.  The marks consist of a data
     frame of auxiliary information about the fires; see _Details._
     Patterns for individual years can be extracted using the function
     ‘split.ppp()’.  (See *Examples*.)

     The object ‘nbw.rect’ is a rectangular window which covers central
     New Brunswick.  It is provided for use in illustrative and
     ‘practice’ calculations inasmuch as the use of a rectangular
     window simplifies some computations considerably.

     The object ‘nbw.seg’ is a line segment pattern (object of class
     ‘"psp"’) consisting of all the boundary segments of the polygonal
     window of New Brunswick. The segments are classified into
     different types of boundary by ‘marks(nbw.seg)’.  This is a data
     frame with three columns:

        * The column ‘type’ describes the physical type of the border.
          It is a factor with levels ‘"land"’ (land border), ‘"river"’
          (river border), ‘"coast"’ (coast of the mainland) and
          ‘"island"’ (coast of the 5 islands).  To plot this
          classification, type ‘plot(nbw.seg)’.

        * The column ‘share’ specifies the territory which shares the
          border with New Brunswick. It is a factor with levels
          ‘"Quebec"’, ‘"NovaScotia"’, ‘"USA"’ and ‘"water"’.  To plot
          this classification, type
          ‘plot(nbw.seg,which.marks="share")’.

        * The column ‘full’ specifies both the physical type of border
          and the adjacent territory. It is a factor with levels
          ‘"coast"’, ‘"island"’, ‘"landNovaScotia"’, ‘"landQuebec"’,
          ‘"riverQuebec"’, ‘"landUSA"’, ‘"riverUSAnorth"’,
          ‘"riverUSAsouth"’.  To plot this classification, type
          ‘plot(nbw.seg,which.marks="full")’.

     For conformity with other datasets, ‘nbfires.extra’ is a list
     containing all the supplementary data. It contains copies of
     ‘nbw.rect’ and ‘nbw.seg’.

Details

     The coordinates of the fire locations were provided in terms of
     latitude and longitude, to the nearest minute of arc.  These were
     converted to New Brunswick stereographic projection coordinates
     (Thomson, Mephan and Steeves, 1977) which was the coordinate
     system in which the map of New Brunswick - which constitutes the
     observation window for the pattern - was obtained.  The conversion
     was done using a ‘C’ program kindly provided by Jonathan Beaudoin
     of the Department of Geodesy and Geomatics, University of New
     Brunswick.

     Finally the data and window were rescaled since the use of the New
     Brunswick stereographic projection coordinate system resulted in
     having to deal with coordinates which are expressed as very large
     integers with a bewildering number of digits.  Amongst other
     things, these huge numbers tended to create very untidy axis
     labels on graphs.  The width of the bounding box of the window was
     made equal to 1000 units. In addition the lower left hand corner
     of this bounding box was shifted to the origin. The height of the
     bounding box was changed proportionately, resulting in a value of
     approximately 959.

     In the final dataset ‘nbfires’, one coordinate unit is equivalent
     to 0.403716 kilometres. To convert the data to kilometres, use
     ‘rescale(nbfires)’.

     The window for the fire patterns comprises 6 polygonal components,
     consisting of mainland New Brunswick and the 5 largest islands.
     Some lakes which should form holes in the mainland component are
     currently missing; this problem may be remedied in future
     releases. The window was formed by ‘simplifying’ the map that was
     originally obtained.  The simplification consisted in reducing
     (using an interactive visual technique) the number of polygon
     edges in each component.  For instance the number of edges in the
     mainland component was reduced from over 138,000 to 500.

     For some purposes it is probably better to use a discretized (mask
     type) window.  See *Examples*.

     Because of the coarseness of the coordinates of the original data
     (1 minute of longitude is approximately 1 kilometer at the
     latitude of New Brunswick), data entry errors, and the
     simplification of the observation window, many of the original
     fire locations appeared to be outside of the window.  This problem
     was addressed by shifting the location of the ‘outsider’ points
     slightly, or deleting them, as seemed appropriate.

     Note that the data contain duplicated points (two points at the
     same location). To determine which points are duplicates, use
     ‘duplicated.ppp’. To remove the duplication, use ‘unique.ppp’.

     The columns of the data frame comprising the marks of ‘nbfires’
     are:

     year This a _factor_ with levels 1987, 1989, ..., 2002, 2003.
          Note that 1988 is not present in the levels.

     fire.type A factor with levels ‘forest’, ‘grass’, ‘dump’, and
          ‘other’.

     dis.date The discovery date of the fire, which is the nearest
          possible surrogate for the starting time of the fire.  This
          is an object of class ‘POSIXct’ and gives the starting
          discovery time of the fire to the nearest minute.

     dis.julian The discovery date and time of the fire, expressed in
          ‘Julian days’, i.e. as a decimal fraction representing the
          number of days since the beginning of the year (midnight 31
          December).

     out.date The date on which the fire was judged to be ‘out’. This
          is an object of class ‘POSIXct’ and gives the ‘out’ time of
          the fire to the nearest minute.

     out.julian The date and time at which the fire was judged to be
          ‘out’, expressed in Julian days.

     cause General cause of the fire.  This is a factor with levels
          ‘unknown’, ‘rrds’ (railroads), ‘misc’ (miscellaneous),
          ‘ltning’ (lightning), ‘for.ind’ (forest industry), ‘incend’
          (incendiary), ‘rec’ (recreation), ‘resid’ (resident), and
          ‘oth.ind’ (other industry).  Causes ‘unknown’, ‘ltning’, and
          ‘incend’ are supposedly designated as ‘final’ by the New
          Brunswick Department of Natural Resources, meaning (it seems)
          “that's all there is to it”.  Other causes are apparently
          intended to be refined by being combined with “source of
          ignition”.  However cross-tabulating ‘cause’ with ‘ign.src’ -
          see below - reveals that very often these three ‘causes’ are
          associated with an “ignition source” as well.

     ign.src Source of ignition, a factor with levels ‘cigs’
          (cigarette/match/pipe/ashes), ‘burn.no.perm’ (burning without
          a permit), ‘burn.w.perm’ (burning with a permit),
          ‘presc.burn’ (prescribed burn), ‘wood.spark’ (wood spark),
          ‘mach.spark’ (machine spark), ‘campfire’, ‘chainsaw’,
          ‘machinery’, ‘veh.acc’ (vehicle accident), ‘rail.acc’
          (railroad accident), ‘wheelbox’ (wheelbox on railcars),
          ‘hot.flakes’ (hot flakes off railcar wheels), ‘dump.fire’
          (fire escaping from a dump), ‘ashes’ (ashes, briquettes,
          burning garbage, etc.)

     fnl.size The final size of the fire (area burned) in hectares, to
          the nearest 10th hectare.

     Note that due to data entry errors some of the “out dates” and
     “out times” in the original data sets were actually _earlier_ than
     the corresponding “discovery dates” and “discover times”. In such
     cases all corresponding entries of the marks data frame (i.e.
     ‘dis.date’, ‘dis.julian’, ‘out.date’, and ‘out.julian’) were set
     equal to ‘NA’.  Also, some of the dates and times were missing
     (equal to ‘NA’) in the original data sets.

     The ‘ignition source’ data were given as integer codes in the
     original data sets.  The code book that I obtained gave
     interpretations for codes 1, 2, ..., 15.  However the actually
     also contained codes of 0, 16, 17, 18, and in one instance 44.
     These may simply be data entry errors. These uninterpretable
     values were assigned the level ‘unknown’.  Many of the years had
     most, or sometimes all, of the ignition source codes equal to 0
     (hence turning out as ‘unknown’, and many of the years had many
     missing values as well.  These were also assigned the level
     ‘unknown’.  Of the 7108 fires in ‘nbfires’, 4354 had an ‘unknown’
     ignition source.  This variable is hence unlikely to be very
     useful.

     There are also anomalies between ‘cause’ and ‘ign.src’, e.g.
     ‘cause’ being ‘unknown’ but ‘ign.src’ being ‘cigs’,
     ‘burn.no.perm’, ‘mach.spark’, ‘hot.flakes’, ‘dump.fire’ or
     ‘ashes’.  Particularly worrisome is the fact that the cause
     ‘ltning’ (!!!) is associate with sources of ignition ‘cigs’,
     ‘burn.w.perm’, ‘presc.burn’, and ‘wood.spark’.

Source

     The data were kindly provided by the New Brunswick Department of
     Natural Resources.  Special thanks are due to Jefferey Betts for a
     great deal of assistance.

References

     Turner, Rolf. Point patterns of forest fire locations.
     _Environmental and Ecological Statistics_ *16* (2009) 197 - 223,
     ‘DOI:10.1007/s10651-007-0085-1’.

     Thomson, D. B., Mephan, M. P., and Steeves, R. R. (1977) The
     stereographic double projection. Technical Report 46, University
     of New Brunswick, Fredericton, N. B., Canada URL:
     ‘gge.unb.ca/Pubs/Pubs.html’.

Examples
Run this code

     if(interactive()) {
       if(require(spatstat.geom)) {
     # Get the year 2000 data.
     X <- split(nbfires,"year")
     Y.00 <- X[["2000"]]
     # Plot all of the year 2000 data, marked by fire type.
     plot(Y.00,which.marks="fire.type")
     # Cut back to forest and grass fires.
     Y.00 <- Y.00[marks(Y.00)$fire.type %in% c("forest","grass")]
     # Plot the year 2000 forest and grass fires marked by fire duration time.
     stt  <- marks(Y.00)$dis.julian
     fin  <- marks(Y.00)$out.julian
     marks(Y.00) <- cbind(marks(Y.00),dur=fin-stt)
     plot(Y.00,which.marks="dur")
     # Look at just the rectangular subwindow (superimposed on the entire window).
     nbw.mask <- as.mask(Window(nbfires), dimyx=500)
     plot(nbw.mask, col=c("green", "white"))
     plot(Window(nbfires), border="red", add=TRUE)
     plot(Y.00[nbw.rect],use.marks=FALSE,add=TRUE)
     plot(nbw.rect,add=TRUE,border="blue")
       if(require(spatstat.explore)) {
         # Look at the K function for the year 2000 forest and grass fires.
         K.00 <- Kest(Y.00)
         plot(K.00)
        }
     # Rescale to kilometres
     NBF <- rescale(nbfires)
       }
     }

