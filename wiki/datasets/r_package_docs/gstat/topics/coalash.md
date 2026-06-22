Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

coalash: Coal ash samples from a mine in Pennsylvania

Coal ash samples from a mine in Pennsylvania

Description

     Data obtained from Gomez and Hazen (1970, Tables 19 and 20) on
     coal ash for the Robena Mine Property in Greene County
     Pennsylvania.

Usage

     data(coalash)

Format

     This data frame contains the following columns:

     x a numeric vector; x-coordinate; reference unknown

     y a numeric vector; x-coordinate; reference unknown

     coalash the target variable

Note:

     data are also present in package fields, as coalash.

Author(s):

     unknown; R version prepared by Edzer Pebesma; data obtained from
     <http://homepage.divms.uiowa.edu/~dzimmer/spatialstats/>, Dale
     Zimmerman's course page

References

     N.A.C. Cressie, 1993, Statistics for Spatial Data, Wiley.

     Gomez, M. and Hazen, K. (1970). Evaluating sulfur and ash
     distribution in coal seems by statistical response surface
     regression analysis. U.S. Bureau of Mines Report RI 7377.

     see also fields manual:
     <https://www.image.ucar.edu/GSP/Software/Fields/fields.manual.coalashEX.Krig.shtml>


Variables detected from installed object

x: integer ; missing=0 ; examples=1

y: integer ; missing=0 ; examples=14, 15, 16

coalash: numeric ; missing=0 ; examples=10.21, 9.92, 11.17

Examples
Run this code

     data(coalash)
     summary(coalash)

