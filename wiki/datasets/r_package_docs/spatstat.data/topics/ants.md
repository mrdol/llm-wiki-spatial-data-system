Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

Harkness-Isham ants' nests data

Description

     These data give the spatial locations of nests of two species of
     ants, _Messor wasmanni_ and _Cataglyphis bicolor_, recorded by
     Professor R.D. Harkness at a site in northern Greece, and
     described in Harkness & Isham (1983).  The full dataset (supplied
     here) has an irregular polygonal boundary, while most analyses
     have been confined to two rectangular subsets of the pattern (also
     supplied here).

     The harvester ant _M. wasmanni_ collects seeds for food and builds
     a nest composed mainly of seed husks. _C. bicolor_ is a
     heat-tolerant desert foraging ant which eats dead insects and
     other arthropods. Interest focuses on whether there is evidence in
     the data for intra-species competition between _Messor_ nests
     (i.e. competition for resources) and for preferential placement of
     _Cataglyphis_ nests in the vicinity of _Messor_ nests.

     The full dataset is displayed in Figure 1 of Harkness & Isham
     (1983).  See *Usage* below to produce a comparable plot.  It
     comprises 97 nests (68 Messor and 29 Cataglyphis) inside an
     irregular convex polygonal boundary, together with annotations
     showing a foot track through the region, the boundary between
     field and scrub areas inside the region, and indicating the two
     rectangular subregions A and B used in their analysis.

     Rectangular subsets of the data were analysed by Harkness & Isham
     (1983), Isham (1984), Takacs & Fiksel (1986), S\"arkk\"a (1993,
     section 5.3), H\"ogmander and S\"arkk\"a (1999) and Baddeley &
     Turner (2000).  The full dataset (inside its irregular boundary)
     was first analysed by Baddeley & Turner (2005b).

     The dataset ‘ants’ is the full point pattern enclosed by the
     irregular polygonal boundary.  The x and y coordinates are
     eastings (E-W) and northings (N-S) scaled so that 1 unit equals
     0.5 feet.  This is a multitype point pattern object, each point
     carrying a mark indicating the ant species (with levels
     ‘Cataglyphis’ and ‘Messor’).

     The dataset ‘ants.extra’ is a list of auxiliary information:

     ‘A’ and ‘B’ The subsets of the pattern within the rectangles A and
          B demarcated in Figure 1 of Harkness & Isham (1983).  These
          are multitype point pattern objects.

     ‘trackNE’ and ‘trackSW’ coordinates of two straight lines bounding
          the foot track.

     ‘fieldscrub’ The endpoints of a straight line separating the
          regions of `field' and `scrub': scrub to the North and field
          to the South.

     ‘side’ A ‘function(x,y)’ that determines whether the location
          ‘(x,y)’ is in the scrub or the field. The function can be
          applied to numeric vectors ‘x’ and ‘y’, and returns a factor
          with levels ‘"scrub"’ and ‘"field"’.  This function is useful
          as a spatial covariate.

     ‘plotit’ A function which produces a plot of the full dataset.

Usage

     data(ants)

Format

     ‘ants’ is an object of class ‘"ppp"’ representing the full point
     pattern of ants' nests.  See ‘ppp.object’ for details of the
     format.  The coordinates are scaled so that 1 unit equals 0.5
     feet.  The points are marked by species (with levels ‘Cataglyphis’
     and ‘Messor’).

     ‘ants.extra’ is a list with entries

     A point pattern of class ‘"ppp"’

     B point pattern of class ‘"ppp"’

     trackNE data in format ‘list(x=numeric(2),y=numeric(2))’ giving
          the two endpoints of line markings

     trackSW data in format ‘list(x=numeric(2),y=numeric(2))’ giving
          the two endpoints of line markings

     fieldscrub data in format ‘list(x=numeric(2),y=numeric(2))’ giving
          the two endpoints of line markings

     side Function with arguments ‘x,y’

     plotit Function

Source

     Harkness and Isham (1983).  Nest coordinates kindly provided by
     Prof Valerie Isham.  Polygon coordinates digitised by Adrian
     Baddeley from a reprint of Harkness & Isham (1983).

References

     Baddeley, A. and Turner, R. (2000) Practical maximum
     pseudolikelihood for spatial point patterns. _Australian and New
     Zealand Journal of Statistics_ *42*, 283-322.

     Baddeley, A. and Turner, R. (2005a) Spatstat: an R package for
     analyzing spatial point patterns.  _Journal of Statistical
     Software_ *12*:6, 1-42.  URL: ‘www.jstatsoft.org’, ISSN:
     1548-7660.

     Baddeley, A. and Turner, R. (2005b) Modelling spatial point
     patterns in R.  In: A. Baddeley, P. Gregori, J. Mateu, R. Stoica,
     and D. Stoyan, editors, _Case Studies in Spatial Point Pattern
     Modelling_, Lecture Notes in Statistics number 185. Pages 23-74.
     Springer-Verlag, New York, 2006.  ISBN: 0-387-28311-0.

     Harkness, R.D. and Isham, V. (1983) A bivariate spatial point
     pattern of ants' nests. _Applied Statistics_ *32*, 293-303.

     Hogmander, H. and Sarkka, A. (1999) Multitype spatial point
     patterns with hierarchical interactions. _Biometrics_ *55*,
     1051-1058.

     Isham, V.S. (1984) Multitype Markov point processes: some
     approximations. _Proceedings of the Royal Society of London,
     Series A_, *391*, 39-53.

     Takacs, R. and Fiksel, T. (1986) Interaction pair-potentials for a
     system of ants' nests. _Biometrical Journal_ *28*, 1007-1013.

     Sarkka, A. (1993) _Pseudo-likelihood approach for pair potential
     estimation of Gibbs processes_. Number 22 in Jyvaskyla Studies in
     Computer Science, Economics and Statistics. University of
     Jyvaskyla, Finland.

Examples
Run this code

       if(require(spatstat.geom)) {

       # Equivalent to Figure 1 of Harkness and Isham (1983)

       data(ants)
       ants.extra$plotit()

       # Data in subrectangle A, rotated
       # Approximate data used by Sarkka (1993)

       angle <- atan(diff(ants.extra$fieldscrub$y)/diff(ants.extra$fieldscrub$x))
       plot(rotate(ants.extra$A, -angle))

       # Approximate window used by Takacs and Fiksel (1986)

       tfwindow <- boundingbox(Window(ants))
       antsTF <- ppp(ants$x, ants$y, window=tfwindow)
       plot(antsTF)
       }

