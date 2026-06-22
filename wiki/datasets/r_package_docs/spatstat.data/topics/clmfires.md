Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

clmfires: Castilla-La Mancha Forest Fires

Castilla-La Mancha Forest Fires

Description

     This dataset is a record of forest fires in the Castilla-La Mancha
     region of Spain between 1998 and 2007.  This region is
     approximately 400 by 400 kilometres.  The coordinates are recorded
     in kilometres.

     The dataset ‘clmfires’ is a point pattern (object of class
     ‘"ppp"’) containing the spatial coordinates of each fire, with
     marks containing information about each fire.  There are 4 columns
     of marks:

       ‘cause’        cause of fire (see below)
       ‘burnt.area’   total area burned, in hectares
       ‘date’         the date of fire, as a value of class ‘Date’
       ‘julian.date’  number of days elapsed since 1 January 1998

     The ‘cause’ of the fire is a factor with the levels ‘lightning’,
     ‘accident’ (for accidents or negligence), ‘intentional’ (for
     intentionally started fires) and ‘other’ (for other causes
     including unknown cause).

     The format of ‘date’ is “Year-month-day”, e.g.  “2005-07-14” means
     14 July, 2005.

     The accompanying dataset ‘clmfires.extra’ is a list of two items
     ‘clmcov100’ and ‘clmcov200’ containing covariate information for
     the entire Castilla-La Mancha region. Each of these two elements
     is a list of four images (objects of class ‘"im"’) named
     ‘elevation’, ‘orientation’, ‘slope’ and ‘landuse’.  The ‘landuse’
     image is factor-valued with the factor having levels ‘urban’,
     ‘farm’ (for farms or orchards), ‘meadow’, ‘denseforest’ (for dense
     forest), ‘conifer’ (for conifer forest or plantation),
     ‘mixedforest’, ‘grassland’, ‘bush’, ‘scrub’ and ‘artifgreen’ for
     artificial greens such as golf courses.

     These images (effectively) provide values for the four covariates
     at every location in the study area. The images in ‘clmcov100’ are
     100 by 100 pixels in size, while those in ‘clmcov200’ are 200 by
     200 pixels.  For easy handling, ‘clmcov100’ and ‘clmcov200’ also
     belong to the class ‘"listof"’ so that they can be plotted and
     printed immediately.

Usage

     data(clmfires)

Format

     ‘clmfires’ is a marked point pattern (object of class ‘"ppp"’).
     See ‘ppp.object’.

     ‘clmfires.extra’ is a list with two components, named ‘clmcov100’
     and ‘clmcov200’, which are lists of pixel images (objects of class
     ‘"im"’).

Remark:

     The precision with which the coordinates of the locations of the
     fires changed between 2003 and 2004.  From 1998 to 2003 many of
     the locations were recorded as the centroid of the corresponding
     “district unit”; the rest were recorded as exact UTM coordinates
     of the centroids of the fires.  In 2004 the system changed and the
     exact UTM coordinates of the centroids of the fires were used for
     _all_ fires.  There is thus a strongly apparent “gridlike” quality
     to the fire locations for the years 1998 to 2003.

     There is however no actual duplication of points in the 1998 to
     2003 patterns due to “jittering” having been applied in order to
     avoid such duplication.  It is not clear just _how_ the fire
     locations were jittered.  It seems unlikely that the jittering was
     done using the ‘jitter()’ function from ‘R’ or the ‘spatstat’
     function ‘rjitter’.

     Of course there are many sets of points which are _virtually_
     identical, being separated by distances induced by the jittering.
     Typically these distances are of the order of 40 metres which is
     unlikely to be meaningful on the scale at which forest fires are
     observed.

     Caution should therefore be exercised in any analyses of the
     patterns for the years 1998 to 2003.

Source

     Professor Jorge Mateu.

Examples
Run this code

       if(require(spatstat.geom)) {
     plot(clmfires, which.marks="cause", cols=2:5, cex=0.25)
     plot(clmfires.extra$clmcov100)
     # Split the clmfires pattern by year and plot the first and last years:
     yr  <- factor(format(marks(clmfires)$date,format="%Y"))
     X   <- split(clmfires,f=yr)
     fAl <- c("1998","2007")
     plot(X[fAl],use.marks=FALSE,main.panel=fAl,main="")
       }

