Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

humberside: Humberside Data on Childhood Leukaemia and Lymphoma

Humberside Data on Childhood Leukaemia and Lymphoma

Description

     Spatial locations of cases of childhood leukaemia and lymphoma,
     and randomly-selected controls, in North Humberside.  A marked
     point pattern.

Usage

     data(humberside)

Format

     The dataset ‘humberside’ is an object of class ‘"ppp"’
     representing a marked point pattern.  Entries include

       ‘x’      Cartesian x-coordinate of home address
       ‘y’      Cartesian y-coordinate of home address
       ‘marks’  factor with levels ‘case’ and ‘control’
                indicating whether this is a disease case
                or a control.

     See ‘ppp.object’ for details of the format.

     Spatial coordinates are expressed as multiples of 100 metres.

     The dataset ‘humberside.convex’ is an object of the same format,
     representing the same point pattern data, but contained in a
     larger, 5-sided convex polygon.

Notes:

     Cuzick and Edwards (1990) first presented and analysed these data.

     The data record 62 cases of childhood leukaemia and lymphoma
     diagnosed in the North Humberside region of England between 1974
     and 1986, together with 141 controls selected at random from the
     birth register for the same period.

     The data are represented as a marked point pattern, with the
     points giving the spatial location of each individual's home
     address (actually, the centroid for the postal code) and the marks
     identifying cases and controls.

     Coordinates are expressed in units of 100 metres, and the
     resolution is 100 metres. At this resolution, there are some
     duplicated points.  To determine which points are duplicates, use
     ‘duplicated.ppp’.  To remove the duplication, use ‘unique.ppp’.

     Two versions of the dataset are supplied, both containing the same
     point coordinates, but using different windows.  The dataset
     ‘humberside’ has a polygonal window with 102 edges which closely
     approximates the Humberside region, while ‘humberside.convex’ has
     a convex 5-sided polygonal window originally used by Diggle and
     Chetwynd (1991) and shown in Figure 1 of that paper. (This
     pentagon has been modified slightly from the original data, by
     shifting two vertices horizontally by 1 unit, so that the pentagon
     contains all the data points.)

Source

     Dr Ray Cartwright and Dr Freda Alexander.  Published and analysed
     in Cuzick and Edwards (1990), see Table 1.  Pentagonal boundary
     from Diggle and Chetwynd (1991), Figure 1.  Point coordinates and
     pentagonal boundary supplied by Andrew Lawson.  Detailed region
     boundary was digitised by Adrian Baddeley
     <mailto:Adrian.Baddeley@curtin.edu.au>, 2005, from a reprint of
     Cuzick and Edwards (1990).

References

     J. Cuzick and R. Edwards (1990) Spatial clustering for
     inhomogeneous populations.  _Journal of the Royal Statistical
     Society, series B_, *52* (1990) 73-104.

     P.J. Diggle and A.G. Chetwynd (1991) Second-order analysis of
     spatial clustering for inhomogeneous populations. _Biometrics_ 47
     (1991) 1155-1163.

Examples
Run this code

       if(require(spatstat.geom)) {
        humberside
        summary(humberside)
        plot(humberside)
        plot(Window(humberside.convex), add=TRUE, lty=2)
        ## convert to metres
        (Hum <- rescale(humberside))
        ## convert to kilometres
        (HumK <- rescale(humberside, 10, "km"))
       }

