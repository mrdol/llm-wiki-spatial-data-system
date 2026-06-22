Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

betacells: Beta Ganglion Cells in Cat Retina

Beta Ganglion Cells in Cat Retina

Description

     Point pattern of cells in the retina, each cell classified as `on'
     or `off' and labelled with the cell profile area.

Usage

     data(betacells)

Format

     ‘betacells’ is an object of class ‘"ppp"’ representing the point
     pattern of cell locations.  Entries include

       ‘x’      Cartesian x-coordinate of cell
       ‘y’      Cartesian y-coordinate of cell
       ‘marks’  data frame of marks

     Cartesian coordinates are given in microns.

     The data frame of marks has two columns:

       ‘type’  factor with levels ‘off’ and ‘on’
               indicating ``off'' and ``on'' cells
       ‘area’  numeric vector giving the
               areas of cell profiles (in square microns)

     See ‘ppp.object’ for details of the format.

Notes:

     This is a new, corrected version of the old dataset ‘ganglia’. See
     below.

     These data represent a pattern of beta-type ganglion cells in the
     retina of a cat recorded by W\"assle et al. (1981).  Beta cells
     are associated with the resolution of fine detail in the cat's
     visual system.  They can be classified anatomically as ``on'' or
     ``off''.

     Statistical independence of the arrangement of the ``on''- and
     ``off''-components would strengthen the evidence for Hering's
     (1878) `opponent theory' that there are two separate channels for
     sensing ``brightness'' and ``darkness''.  See W\"assle et al
     (1981). There is considerable current interest in the arrangement
     of cell mosaics in the retina, see Rockhill et al (2000).

     The dataset is a marked point pattern giving the locations, types
     (``on'' or ``off''), and profile areas of beta cells observed in a
     rectangle of dimensions 750 x 990 microns.  Coordinates are given
     in microns (thousandths of a millimetre) and areas are given in
     square microns.

     The original source is Figure 6 of W\"assle et al (1981), which is
     a manual drawing of the beta mosaic observed in a microscope
     field-of-view of a whole mount of the retina.  Thus, all beta
     cells in the retina were effectively projected onto the same
     two-dimensional plane.

     The data were scanned in 2004 by Stephen Eglen from Figure 6(a) of
     W\"assle et al (1981).  Image analysis software was used to
     identify the soma (cell body). The x,y location of each cell was
     taken to be the centroid of the soma. The type of each cell
     (``on'' or `off'') was identified by referring to Figures 6(b) and
     6(d).  The area of each soma (in square microns) was also
     computed.

     Note that this is a corrected version of the ‘ganglia’ dataset
     provided in earlier versions of ‘spatstat’.  The earlier data
     ‘ganglia’ were not faithful to the scale in the original paper and
     contain some scanning errors.

Source

     W\"assle et al (1981), Figure 6(a), scanned and processed by
     Stephen Eglen <mailto:S.J.Eglen@damtp.cam.ac.uk>.

References

     Hering, E. (1878) Zur Lehre von Lichtsinn. Vienna.

     Van Lieshout, M.N.M. and Baddeley, A.J. (1999) Indices of
     dependence between types in multivariate point patterns.
     _Scandinavian Journal of Statistics_ *26*, 511-532.

     Rockhill, R.L., Euler, T. and Masland, R.H. (2000) Spatial order
     within but not between types of retinal neurons. _Proc. Nat. Acad.
     Sci. USA_ *97*(5), 2303-2307.

     W\"assle, H., Boycott, B. B. & Illing, R.-B. (1981). Morphology
     and mosaic of on- and off-beta cells in the cat retina and some
     functional considerations. _Proc. Roy. Soc. London Ser. B_ *212*,
     177-195.

Examples
Run this code

        plot(betacells)
       if(require(spatstat.geom)) {
        area <- marks(betacells)$area
        plot(betacells %mark% sqrt(area/pi), markscale=1)
        }

