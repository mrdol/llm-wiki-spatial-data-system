Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

fulmar: Fulmaris glacialis data

Fulmaris glacialis data

Description

     Airborne counts of Fulmaris glacialis during the Aug/Sept 1998 and
     1999 flights on the Dutch (Netherlands) part of the North Sea
     (NCP, Nederlands Continentaal Plat).

Usage

     data(fulmar)

Format

     This data frame contains the following columns:

     year year of measurement: 1998 or 1999

     x x-coordinate in UTM zone 31

     y y-coordinate in UTM zone 31

     depth sea water depth, in m

     coast distance to coast of the Netherlands, in km.

     fulmar observed density (number of birds per square km)

Author(s):

     Dutch National Institute for Coastal and Marine Management (RIKZ)

See Also

     ncp.grid

     E.J. Pebesma, R.N.M. Duin, P.A. Burrough, 2005. Mapping Sea Bird
     Densities over the North Sea: Spatially Aggregated Estimates and
     Temporal Changes. Environmetrics 16, (6), p 573-587.


Variables detected from installed object

year: numeric ; missing=0 ; examples=1998

x: numeric ; missing=0 ; examples=614192.3, 613150.8, 619644.7

y: numeric ; missing=0 ; examples=5875490, 5872947, 5888800

depth: numeric ; missing=0 ; examples=6, 9

coast: numeric ; missing=0 ; examples=3.445307, 3.042531

fulmar: numeric ; missing=0 ; examples=0

Examples
Run this code

     data(fulmar)
     summary(fulmar)
     ## Not run:

     demo(fulmar)
     ## End(Not run)

