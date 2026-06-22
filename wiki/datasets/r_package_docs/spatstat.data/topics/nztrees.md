Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

nztrees: New Zealand Trees Point Pattern

New Zealand Trees Point Pattern

Description

     The data give the locations of trees in a forest plot.

     They were collected by Mark and Esler (1970) and were extracted
     and analysed by Ripley (1981, pp. 169-175).  They represent the
     positions of 86 trees in a forest plot approximately 140 by 85
     feet.

     Ripley discarded from his analysis the eight trees at the
     right-hand edge of the plot (which appear to be part of a planted
     border) and trimmed the window by a 5-foot margin accordingly.

Usage

     data(nztrees)

Format

     An object of class ‘"ppp"’ representing the point pattern of tree
     locations.  The Cartesian coordinates are in feet.

     See ‘ppp.object’ for details of the format of a point pattern
     object.

Note:

     To trim a 5-foot margin off the window, type ‘nzsub <-
     nztrees[owin(c(0,148),c(0,95)) ]’

Source

     Mark and Esler (1970), Ripley (1981).

References

     Ripley, B.D. (1981) _Spatial statistics_.  John Wiley and Sons.

     Mark, A.F. and Esler, A.E. (1970) An assessment of the
     point-centred quarter method of plotless sampling in some New
     Zealand forests.  _Proceedings of the New Zealand Ecological
     Society_ *17*, 106-110.

