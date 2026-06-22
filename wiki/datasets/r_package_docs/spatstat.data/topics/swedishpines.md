Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

swedishpines: Swedish Pines Point Pattern

Swedish Pines Point Pattern

Description

     The data give the locations of pine saplings in a Swedish forest.

Usage

     data(swedishpines)

Format

     An object of class ‘"ppp"’ representing the point pattern of tree
     locations in a rectangular plot 9.6 by 10 metres.

     Cartesian coordinates are given in _decimetres_ (multiples of 0.1
     metre) rounded to the nearest decimetre.  Type
     ‘rescale(swedishpines)’ to get an equivalent dataset where the
     coordinates are expressed in metres.

     See ‘ppp.object’ for details of the format of a point pattern
     object.

Note:

     For previous analyses see Ripley (1981, pp. 172-175), Venables and
     Ripley (1997, p. 483), Baddeley and Turner (2000).

Source

     Strand (1972), Ripley (1981)

References

     Baddeley, A. and Turner, R. (2000) Practical maximum
     pseudolikelihood for spatial point patterns.  _Australian and New
     Zealand Journal of Statistics_ *42*, 283-322.

     Ripley, B.D. (1981) _Spatial statistics_.  John Wiley and Sons.

     Strand, L. (1972).  A model for stand growth.  _IUFRO Third
     Conference Advisory Group of Forest Statisticians_, INRA, Institut
     National de la Recherche Agronomique, Paris.  Pages 207-216.

     Venables, W.N. and Ripley, B.D. (1997) _Modern applied statistics
     with S-PLUS_.  Second edition. Springer Verlag.

Examples
Run this code

       if(require(spatstat.geom)) {
          swedishpines

          ## rescale to metres
          rescale(swedishpines)
       }

