Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

amacrine: Hughes' Amacrine Cell Data

Hughes' Amacrine Cell Data

Description

     Austin Hughes' data: a point pattern of displaced amacrine cells
     in the retina of a rabbit. A marked point pattern.

Usage

     data(amacrine)

Format

     An object of class ‘"ppp"’ representing the point pattern of cell
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of cell
       ‘y’      Cartesian y-coordinate of cell
       ‘marks’  factor with levels ‘off’ and ‘on’
                indicating ``off'' and ``on'' cells

     See ‘ppp.object’ for details of the format.

Notes:

     Austin Hughes' data: a point pattern of displaced amacrine cells
     in the retina of a rabbit. 152 ``on'' cells and 142 ``off'' cells
     in a rectangular sampling frame.

     The true dimensions of the rectangle are 1060 by 662 microns. The
     coordinates here are scaled to a rectangle of height 1 and width
     1060/662 = 1.601 so the unit of measurement is approximately 662
     microns.

     The data were analysed by Diggle (1986).

Source

     Peter Diggle, personal communication

References

     Diggle, P. J. (1986). Displaced amacrine cells in the retina of a
     rabbit: analysis of a bivariate spatial point pattern.  _J.
     Neurosci. Meth._ *18*, 115-125.

Examples
Run this code

       if(require(spatstat.geom)) {
     amacrine
     (Ama <- rescale(amacrine))
       }

