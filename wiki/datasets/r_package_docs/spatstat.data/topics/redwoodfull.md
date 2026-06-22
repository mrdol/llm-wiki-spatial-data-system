Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

redwoodfull: California Redwoods Point Pattern (Entire Dataset)

California Redwoods Point Pattern (Entire Dataset)

Description

     These data represent the locations of 195 seedlings and saplings
     of California Giant Redwood (_Sequoiadendron giganteum_) in a
     square sampling region.

     They were described and analysed by Strauss (1975).  This is the
     ``*full*'' dataset; most writers have analysed a subset extracted
     by Ripley (1977) which is available as ‘redwood’.

     Strauss (1975) divided the sampling region into two subregions I
     and II demarcated by a diagonal line.  The spatial pattern appears
     to be slightly regular in region I and strongly clustered in
     region II.

     Strauss (1975) writes: “It was felt that the seedlings would be
     scattered fairly randomly, except that a number of tight clusters
     would form around some of the redwood tree stumps present in the
     plot. A discontinuity in the soil, very roughly demarked by the
     diagonal line in the figure, was expected to cause a difference in
     clustering behaviour between regions I and II. Moreover, almost
     all the redwood stumps were situated in region II.”

     The dataset ‘redwoodfull’ contains the full point pattern of 195
     trees.  The window has been rescaled to the unit square.  Its
     physical size is approximately 130 feet across.

     The auxiliary information about the subregions is contained in
     ‘redwoodfull.extra’, which is a list with entries

       ‘rdiag’     The coordinates of the diagonal boundary
                   between regions I and II
       ‘regionI’   Region I as a window object
       ‘regionII’  Region II as a window object
       ‘regionR’   Ripley's subrectangle (approximate)
       ‘plotit’    Function to plot the full data and auxiliary markings

     Ripley (1977) extracted a subset of these data, containing 62
     points, lying within a square subregion which overlaps regions I
     and II.  He rescaled that subset to the unit square.  This subset
     has been re-analysed many times, and is the dataset usually known
     as ``the redwood data'' in the spatial statistics literature.  The
     exact dataset used by Ripley is supplied in the ‘spatstat’ library
     as ‘redwood’.

     The approximate position of the square chosen by Ripley within the
     ‘redwoodfull’ pattern is indicated by the window
     ‘redwoodfull.extra$regionR’.  There are some minor inconsistencies
     with ‘redwood’ since it originates from a different digitisation.

Usage

     data(redwoodfull)

Format

     The dataset ‘redwoodfull’ is an object of class ‘"ppp"’
     representing the point pattern of tree locations.  See
     ‘ppp.object’ for details of the format of a point pattern object.
     The window has been rescaled to the unit square.  Its physical
     size is approximately 128 feet across.

     The dataset ‘redwoodfull.extra’ is a list with entries

       ‘rdiag’     coordinates of endpoints of a line,
                   in format ‘list(x=numeric(2),y=numeric(2))’
       ‘regionI’   a window object
       ‘regionII’  a window object
       ‘regionR’   a window object
       ‘plotit’    Function with no arguments

Source

     Strauss (1975). The plot of the data published by Strauss (1975)
     was scanned and digitised by Sandra Pereira, University of Western
     Australia, 2002.

References

     Diggle, P.J. (1983) _Statistical analysis of spatial point
     patterns_.  Academic Press.

     Ripley, B.D. (1977) Modelling spatial patterns (with discussion).
     _Journal of the Royal Statistical Society, Series B_ *39*,
     172-212.

     Strauss, D.J. (1975) A model for clustering.  _Biometrika_ *62*,
     467-475.

See Also

     ‘redwood’

Examples
Run this code

            data(redwoodfull)
       if(require(spatstat.geom)) {
            plot(redwoodfull)
            redwoodfull.extra$plotit()
            # extract the pattern in region II
            redwoodII <- redwoodfull[, redwoodfull.extra$regionII]
        }

