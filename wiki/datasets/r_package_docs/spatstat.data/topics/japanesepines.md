Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

japanesepines: Japanese Pines Point Pattern

Japanese Pines Point Pattern

Description

     The data give the locations of saplings of Japanese black pine
     (_Pinus thunbergii_) in a square sampling region in a natural
     forest.  The observations were originally collected by Numata
     (1961).

     These data are used as a standard example in the textbook of
     Diggle (2003); see pages 1, 14, 19, 22, 24, 56-57 and 61.

Usage

     data(japanesepines)

Format

     An object of class ‘"ppp"’ representing the point pattern of 65
     tree sapling locations in a 5.7 x 5.7 metre square, rescaled to
     the unit square and rounded to two decimal places.

     See ‘ppp.object’ for details of the format of a point pattern
     object.

Source

     Diggle (2003), obtained from Numata (1961)

References

     Diggle, P.J. (2003) _Statistical Analysis of Spatial Point
     Patterns_.  Arnold Publishers.

     Numata, M. (1961) Forest vegetation in the vicinity of Choshi.
     Coastal flora and vegetation at Choshi, Chiba Prefecture. IV.
     _Bulletin of Choshi Marine Laboratory, Chiba University_ *3*,
     28-48 (in Japanese).

Examples
Run this code

       if(require(spatstat.geom)) {
        japanesepines
        summary(japanesepines)
        ## rescale to metres
        (Jpines <- rescale(japanesepines))
       }

