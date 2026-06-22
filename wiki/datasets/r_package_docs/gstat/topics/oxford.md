Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

oxford: Oxford soil samples

Oxford soil samples

Description

     Data: 126 soil augerings on a 100 x 100m square grid, with 6
     columns and 21 rows. Grid is oriented with long axis
     North-north-west to South-south-east Origin of grid is
     South-south-east point, 100m outside grid.

     Original data are part of a soil survey carried out by P.A.
     Burrough in 1967. The survey area is located on the chalk
     downlands on the Berkshire Downs in Oxfordshire, UK. Three soil
     profile units were recognised on the shallow Rendzina soils; these
     are Ia - very shallow, grey calcareous soils less than 40cm deep
     over chalk; Ct - shallow to moderately deep, grey-brown calcareous
     soils on calcareous colluvium, and Cr: deep, moderately acid,
     red-brown clayey soils.  These soil profile classes were
     registered at every augering.

     In addition, an independent landscape soil map was made by
     interpolating soil boundaries between these soil types, using
     information from the changes in landform.  Because the soil varies
     over short distances, this field mapping caused some soil borings
     to receive a different classification from the classification
     based on the point data.

     Also registered at each auger point were the site elevation (m),
     the depth to solid chalk rock (in cm) and the depth to lime in cm.
     Also, the percent clay content, the Munsell colour components of
     VALUE and CHROMA , and the lime content of the soil (as tested
     using HCl) were recorded for the top two soil layers (0-20cm and
     20-40cm).

     Samples of topsoil taken as a bulk sample within a circle of
     radius 2.5m around each sample point were used for the laboratory
     determination of Mg (ppm), OM1 %, CEC as mequ/100g air dry soil,
     pH, P as ppm and K (ppm).

Usage

     data(oxford)

Format

     This data frame contains the following columns:

     PROFILE profile number

     XCOORD x-coordinate, field, non-projected

     YCOORD y-coordinate, field, non-projected

     ELEV elevation, m.

     PROFCLASS soil class, obtained by classifying the soil profile at
          the sample site

     MAPCLASS soil class, obtained by looking up the site location in
          the soil map

     VAL1 Munsell colour component VALUE, 0-20 cm

     CHR1 Munsell colour component CHROMA, 20-40 cm

     LIME1 Lime content (tested using HCl), 0-20 cm

     VAL2 Munsell colour component VALUE, 0-20 cm

     CHR2 Munsell colour component CHROMA, 20-40 cm

     LIME2 Lime content (tested using HCl), 20-40 cm

     DEPTHCM soil depth, cm

     DEP2LIME depth to lime, cm

     PCLAY1 percentage clay, 0-20 cm

     PCLAY2 percentage clay, 20-40 cm

     MG1 Magnesium content (ppm), 0-20 cm

     OM1 organic matter (%), 0-20 cm

     CEC1 CES as mequ/100g air dry soil, 0-20 cm

     PH1 pH, 0-20 cm

     PHOS1 Phosphorous, 0-20 cm, ppm

     POT1 K (potassium), 0-20 cm, ppm

Note:

     ‘oxford.jpg’, in the gstat package external directory (see example
     below), shows an image of the soil map for the region

Author(s):

     P.A. Burrough; compiled for R by Edzer Pebesma

References

     P.A. Burrough, R.A. McDonnell, 1998. Principles of Geographical
     Information Systems. Oxford University Press.


Variables detected from installed object

PROFILE: numeric ; missing=0 ; examples=1, 2, 3

XCOORD: numeric ; missing=0 ; examples=100

YCOORD: numeric ; missing=0 ; examples=2100, 2000, 1900

ELEV: numeric ; missing=0 ; examples=598, 597, 610

PROFCLASS: factor ; missing=0 ; examples=Ct

MAPCLASS: factor ; missing=0 ; examples=Ct, Ia

VAL1: numeric ; missing=0 ; examples=3, 4

CHR1: numeric ; missing=0 ; examples=3

LIME1: numeric ; missing=0 ; examples=4

VAL2: numeric ; missing=0 ; examples=4, 5

CHR2: numeric ; missing=0 ; examples=4

LIME2: numeric ; missing=0 ; examples=4

DEPTHCM: numeric ; missing=0 ; examples=61, 91, 46

DEP2LIME: numeric ; missing=0 ; examples=20

PCLAY1: numeric ; missing=0 ; examples=15, 25, 20

PCLAY2: numeric ; missing=0 ; examples=10, 20

MG1: numeric ; missing=0 ; examples=63, 58, 55

OM1: numeric ; missing=0 ; examples=5.7, 5.6, 5.8

CEC1: numeric ; missing=0 ; examples=20, 22, 17

PH1: numeric ; missing=0 ; examples=7.7, 7.5

PHOS1: numeric ; missing=0 ; examples=13, 9.2, 10.5

POT1: numeric ; missing=0 ; examples=196, 157, 115

Examples
Run this code

     data(oxford)
     summary(oxford)
     # open the following file with a jpg viewer:
     system.file("external/oxford.jpg", package="gstat")

