Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

bronzefilter: Bronze gradient filter data

Bronze gradient filter data

Description

     These data represent a spatially inhomogeneous pattern of circular
     section profiles of particles, observed in a longitudinal plane
     section through a gradient sinter filter made from bronze powder,
     prepared by Ricardo Bernhardt, Dresden.

     The material was produced by sedimentation of bronze powder with
     varying grain diameter and subsequent sintering, as described in
     Bernhardt et al. (1997).

     The data are supplied as a marked point pattern of circle centres
     marked by circle radii.  The coordinates of the centres and the
     radii are recorded in mm.  The field of view is an 18 * 7 mm
     rectangle.

     The data were first analysed by Hahn et al. (1999).

Usage

     data(bronzefilter)

Format

     An object of class ‘"ppp"’ representing the point pattern of cell
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of bronze grain profile centre
       ‘y’      Cartesian y-coordinate of bronze grain profile centre
       ‘marks’  radius of bronze grain profile

     See ‘ppp.object’ for details of the format.  All coordinates are
     recorded in mm.

Source

     R.\ Bernhardt (section image), H.\ Wendrock (coordinate
     measurement).  Adjusted, formatted and communicated by U.\ Hahn.

References

     Bernhardt, R., Meyer-Olbersleben, F. and Kieback, B. (1997)
     Fundamental investigation on the preparation of gradient
     structures by sedimentation of different powder fractions under
     gravity.  _Proc. of the 4th Int. Conf. On Composite Engineering,
     July 6-12 1997, ICCE/4_, Hawaii, Ed. David Hui, 147-148.

     Hahn U., Micheletti, A., Pohlink, R., Stoyan D. and Wendrock,
     H.(1999) Stereological analysis and modelling of gradient
     structures.  _Journal of Microscopy_, *195*, 113-124.

Examples
Run this code

       data(bronzefilter)
       if(require(spatstat.geom)) {
       plot(bronzefilter, markscale=2)
       }

