Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

bramblecanes: Hutchings' Bramble Canes data

Hutchings' Bramble Canes data

Description

     Data giving the locations and ages of bramble canes in a field.  A
     marked point pattern.

Usage

     data(bramblecanes)

Format

     An object of class ‘"ppp"’ representing the point pattern of plant
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of plant
       ‘y’      Cartesian y-coordinate of plant
       ‘marks’  factor with levels 0,1, 2 indicating age

     See ‘ppp.object’ for details of the format.

Notes:

     These data record the (x,y) locations and ages of bramble canes in
     a field 9 metres square, rescaled to the unit square.  The canes
     were classified according to age as either newly emergent, one or
     two years old. These are encoded as marks 0, 1 and 2 respectively
     in the dataset.

     The data were recorded and analysed by Hutchings (1979) and
     further analysed by Diggle (1981a, 1981b, 1983), Diggle and Milne
     (1983), and Van Lieshout and Baddeley (1999). All analyses found
     that the pattern of newly emergent canes exhibits clustering,
     which Hutchings attributes to ``vigorous vegetative
     reproduction''.

Source

     Hutchings (1979), data published in Diggle (1983)

References

     Diggle, P. J. (1981a) Some graphical methods in the analysis of
     spatial point patterns.  In _Interpreting multivariate data_, V.
     Barnett (Ed.)  John Wiley and Sons.

     Diggle, P. J. (1981b).  Statistical analysis of spatial point
     patterns.  _N.Z. Statist._ *16*, 22-41.

     Diggle, P.J. (1983) _Statistical analysis of spatial point
     patterns_.  Academic Press.

     Diggle, P. J. and Milne, R. K. (1983) Bivariate Cox processes:
     some models for bivariate spatial point patterns.  _Journal of the
     Royal Statistical Soc. Series B_ *45*, 11-21.

     Hutchings, M. J. (1979) Standing crop and pattern in pure stands
     of Mercurialis perennis and Rubus fruticosus in mixed deciduous
     woodland.  _Oikos_ *31*, 351-357.

     Van Lieshout, M.N.M. and Baddeley, A.J. (1999) Indices of
     dependence between types in multivariate point patterns.
     _Scandinavian Journal of Statistics_ *26*, 511-532.

Examples
Run this code

       if(require(spatstat.geom)) {
        bramblecanes
        # convert coordinates to metres
        (Bram <- rescale(bramblecanes))
        }

