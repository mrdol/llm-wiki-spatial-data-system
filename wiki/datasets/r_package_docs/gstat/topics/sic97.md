Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

sic97: Spatial Interpolation Comparison 1997 data set: Swiss Rainfall

Spatial Interpolation Comparison 1997 data set: Swiss Rainfall

Description

     The text below is copied from the data item at ai-geostats, (link
     no longer working).

Usage

     data(sic97) #

Format

     The data frames contain the following columns:

     ID this integer value is the number (unique value) of the
          monitoring station

     rainfall rainfall amount, in 10th of mm

Note:

     See the pdf that accompanies the original file for a description
     of the data. The .dxf file with the Swiss border is not included
     here.

Author(s):

     Gregoire Dubois and others.


Variables detected from installed object

ID: integer ; missing=0 ; examples=13, 14, 22

rainfall: integer ; missing=0 ; examples=151, 255, 79

Examples
Run this code

     data(sic97)
     image(demstd)
     points(sic_full, pch=1)
     points(sic_obs, pch=3)

