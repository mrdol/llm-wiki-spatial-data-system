Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

redwood: California Redwoods Point Pattern (Ripley's Subset)

California Redwoods Point Pattern (Ripley's Subset)

Description

     The data represent the locations of 62 seedlings and saplings of
     California Giant Redwood (_Sequoiadendron giganteum_) recorded in
     a square sampling region.  They originate from Strauss (1975); the
     present data are a subset extracted by Ripley (1977) in a
     subregion that has been rescaled to a unit square.  (The original
     physical size of the unit is approximately 63.1 feet).

     Two versions of this dataset are provided: ‘redwood’ and
     ‘redwood3’.

     The dataset ‘redwood’ was obtained from the ‘spatial’ package.  In
     this version the coordinates are given to 2 decimal places
     (multiples of 0.01 units) except for one point which has an x
     coordinate of 0.999, presumably to ensure that it is properly
     inside the window.

     The dataset ‘redwood3’ was obtained from Peter Diggle's webpage.
     In this version the coordinates are given to 3 decimal places
     (multiples of 0.001 units). The ordering of the points is not the
     same in the two datasets.

     There are many further analyses of this dataset. It is often used
     as a canonical example of a clustered point pattern (see e.g.
     Diggle, 1983).

     The original, full redwood dataset is supplied in the
     ‘spatstat.data’ package as ‘redwoodfull’.

Usage

     data(redwood)

Format

     An object of class ‘"ppp"’ representing the point pattern of tree
     locations.  The window has been rescaled to the unit square.

     See ‘ppp.object’ for details of the format of a point pattern
     object.

Source

     Original data of Strauss (1975), subset extracted by Ripley
     (1977).  Data obtained from Ripley's package ‘spatial’ and from
     Peter Diggle's website.

References

     Diggle, P.J. (1983) _Statistical analysis of spatial point
     patterns_.  Academic Press.

     Ripley, B.D. (1977) Modelling spatial patterns (with discussion).
     _Journal of the Royal Statistical Society, Series B_ *39*,
     172-212.

     Strauss, D.J. (1975) A model for clustering.  _Biometrika_ *62*,
     467-475.

See Also

     ‘redwoodfull’

