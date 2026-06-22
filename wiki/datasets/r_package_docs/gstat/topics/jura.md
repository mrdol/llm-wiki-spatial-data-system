Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

jura: Jura data set

Jura data set

Description

     The jura data set from Pierre Goovaerts' book (see references
     below). It contains four ‘data.frame’s: prediction.dat,
     validation.dat and transect.dat and juragrid.dat, and three
     ‘data.frame’s with consistently coded land use and rock type
     factors, as well as geographic coordinates. The examples below
     show how to transform these into spatial (sp) objects in a local
     coordinate system and in geographic coordinates, and how to
     transform to metric coordinate reference systems.

Usage

     data(jura)

Format

     The ‘data.frames’ prediction.dat and validation.dat contain the
     following fields:

     Xloc X coordinate, local grid km

     Yloc Y coordinate, local grid km

     Landuse see book and below

     Rock see book and below

     Cd mg cadmium kg^-1 topsoil

     Co mg cobalt kg^-1 topsoil

     Cr mg chromium kg^-1 topsoil

     Cu mg copper kg^-1 topsoil

     Ni mg nickel kg^-1 topsoil

     Pb mg lead kg^-1 topsoil

     Zn mg zinc kg^-1 topsoil

     The ‘data.frame’ juragrid.dat only has the first four fields.  In
     addition the ‘data.frame’s jura.pred, jura.val and jura.grid also
     have inserted third and fourth fields giving geographic
     coordinates:

     long Longitude, WGS84 datum

     lat Latitude, WGS84 datum

Note:

     The points data sets were obtained from
     http://home.comcast.net/~pgoovaerts/book.html, which seems to be
     no longer available; the grid data were kindly provided by Pierre
     Goovaerts.

     The following codes were used to convert ‘prediction.dat’ and
     ‘validation.dat’ to ‘jura.pred’ and ‘jura.val’ (see examples
     below):

     Rock Types: 1: Argovian, 2: Kimmeridgian, 3: Sequanian, 4:
     Portlandian, 5: Quaternary.

     Land uses: 1: Forest, 2: Pasture (Weide(land), Wiese, Grasland),
     3: Meadow (Wiese, Flur, Matte, Anger), 4: Tillage (Ackerland,
     bestelltes Land)

     Points 22 and 100 in the validation set
     (‘validation.dat[c(22,100),]’) seem not to lie exactly on the grid
     originally intended, but are kept as such to be consistent with
     the book.

     Georeferencing was based on two control points in the Swiss grid
     system shown as Figure 1 of Atteia et al. (see above) and further
     points digitized on the tentatively georeferenced scanned map.
     RMSE 2.4 m. Location of points in the field was less precise.

Author(s):

     Data preparation by David Rossiter (dgr2@cornell.edu) and Edzer
     Pebesma; georeferencing by David Rossiter

References

     Goovaerts, P. 1997. Geostatistics for Natural Resources
     Evaluation. Oxford Univ. Press, New-York, 483 p. Appendix C
     describes (and gives) the Jura data set.

     Atteia, O., Dubois, J.-P., Webster, R., 1994, Geostatistical
     analysis of soil contamination in the Swiss Jura: Environmental
     Pollution 86, 315-327

     Webster, R., Atteia, O., Dubois, J.-P., 1994, Coregionalization of
     trace metals in the soil in the Swiss Jura: European Journal of
     Soil Science 45, 205-218


Variables detected from installed object

Xloc: numeric ; missing=0 ; examples=2.672, 3.589, 4.01

Yloc: numeric ; missing=0 ; examples=3.558, 4.443, 4.713

Landuse: integer ; missing=0 ; examples=3, 2

Rock: integer ; missing=0 ; examples=5, 1

Cd: numeric ; missing=0 ; examples=1.57, 2.045, 1.203

Co: numeric ; missing=0 ; examples=8.28, 10.8, 12

Cr: numeric ; missing=0 ; examples=37.12, 40.8, 53.2

Cu: numeric ; missing=0 ; examples=18.6, 11.48, 13.04

Ni: numeric ; missing=0 ; examples=18.6, 21.52, 23.92

Pb: numeric ; missing=0 ; examples=38.2, 33.36, 26.56

Zn: numeric ; missing=0 ; examples=65.2, 112.8, 91.6

Examples
Run this code

     data(jura)
     summary(prediction.dat)
     summary(validation.dat)
     summary(transect.dat)
     summary(juragrid.dat)

     # the following commands were used to create objects with factors instead
     # of the integer codes for Landuse and Rock:
     ## Not run:

       jura.pred = prediction.dat
       jura.val = validation.dat
       jura.grid = juragrid.dat

       jura.pred$Landuse = factor(prediction.dat$Landuse,
             labels=levels(juragrid.dat$Landuse))
       jura.pred$Rock = factor(prediction.dat$Rock,
             labels=levels(juragrid.dat$Rock))
       jura.val$Landuse = factor(validation.dat$Landuse,
             labels=levels(juragrid.dat$Landuse))
       jura.val$Rock = factor(validation.dat$Rock,
             labels=levels(juragrid.dat$Rock))
     ## End(Not run)

     # the following commands convert data.frame objects into spatial (sp) objects
     #   in the local grid:
     require(sp)
     coordinates(jura.pred) = ~Xloc+Yloc
     coordinates(jura.val) = ~Xloc+Yloc
     coordinates(jura.grid) = ~Xloc+Yloc
     gridded(jura.grid) = TRUE

     # the following commands convert the data.frame objects into spatial (sp) objects
     #   in WGS84 geographic coordinates
     # example is given only for jura.pred, do the same for jura.val and jura.grid
     # EPSG codes can be found by searching make_EPSG()
     jura.pred <- as.data.frame(jura.pred)
     coordinates(jura.pred) = ~ long + lat
     proj4string(jura.pred) = CRS("+init=epsg:4326")

