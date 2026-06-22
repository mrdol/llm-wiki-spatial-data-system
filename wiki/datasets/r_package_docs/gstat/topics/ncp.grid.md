Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

ncp.grid: Grid for the NCP, the Dutch part of the North Sea

Grid for the NCP, the Dutch part of the North Sea

Description

     Gridded data for the NCP (Nederlands Continentaal Plat, the Dutch
     part of the North Sea), for a 5 km x 5 km grid; stored as
     data.frame.

Usage

     data(ncp.grid)

Format

     This data frame contains the following columns:

     x x-coordinate, UTM zone 31

     y y-coordinate, UTM zone 31

     depth sea water depth, m.

     coast distance to the coast of the Netherlands, in km.

     area identifier for administrative sub-areas

Author(s):

     Dutch National Institute for Coastal and Marine Management (RIKZ);
     data compiled for R by Edzer Pebesma

See Also

     fulmar


Variables detected from installed object

x: numeric ; missing=0 ; examples=511500, 516500, 521500

y: numeric ; missing=0 ; examples=6129000

depth: numeric ; missing=0 ; examples=30

coast: numeric ; missing=0 ; examples=248, 247, 244

area: numeric ; missing=0 ; examples=1

Examples
Run this code

     data(ncp.grid)
     summary(ncp.grid)

