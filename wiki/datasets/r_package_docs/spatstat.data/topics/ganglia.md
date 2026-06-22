Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

ganglia: Beta Ganglion Cells in Cat Retina, Old Version

Beta Ganglion Cells in Cat Retina, Old Version

Description

     Point pattern of retinal ganglion cells identified as `on' or
     `off'.  A marked point pattern.

Usage

     data(ganglia)

Format

     An object of class ‘"ppp"’ representing the point pattern of cell
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of cell
       ‘y’      Cartesian y-coordinate of cell
       ‘marks’  factor with levels ‘off’ and ‘on’
                indicating ``off'' and ``on'' cells

     See ‘ppp.object’ for details of the format.

Notes:

     *Important: these data are INCORRECT.  See below.*

     The data represent a pattern of beta-type ganglion cells in the
     retina of a cat recorded in Figure 6(a) of W\"assle et al. (1981).

     The pattern was first analysed by W\"assle et al (1981) using
     nearest neighbour distances. The data used in their analysis are
     not available.

     The present dataset ‘ganglia’ was scanned from Figure 6(a) of
     W\"assle et al (1981) in the early 1990's, but we have no further
     information.  This dataset is the one analysed by Van Lieshout and
     Baddeley (1999) using multitype J functions, and by Stoyan (1995)
     using second order methods (pair correlation and mark
     correlation).

     It has now been discovered that these data are *incorrect*.  They
     are not faithful to the scale in Figure 6 of W\"assle et al
     (1981), and they contain some scanning errors.  Hence they should
     not be used to address the original scientific question.  They
     have been retained only for comparison with other analyses in the
     statistical literature.

     A new, corrected dataset, scanned from the original microscope
     image, has been provided under the name ‘betacells’.  Use that
     dataset for any further study.

Warnings:

     These data are incorrect.  Use the new corrected dataset
     ‘betacells’.

Source

     W\"assle et al (1981), data supplied by Marie-Colette van Lieshout
     and attributed to Peter Diggle

References

     Stoyan, D. (1995) Personal communication.

     Van Lieshout, M.N.M. and Baddeley, A.J. (1999) Indices of
     dependence between types in multivariate point patterns.
     _Scandinavian Journal of Statistics_ *26*, 511-532.

     W\"assle, H., Boycott, B. B. & Illing, R.-B. (1981).  Morphology
     and mosaic of on- and off-beta cells in the cat retina and some
     functional considerations.  _Proc. Roy. Soc. London Ser. B_ *212*,
     177-195.

