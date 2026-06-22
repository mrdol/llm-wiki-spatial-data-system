Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

shelling: Artillery Impacts in Ukraine

Artillery Impacts in Ukraine

Description

     Spatial point patterns of the impacts of high-explosive artillery
     rounds in two fields in eastern Ukraine.

Usage

     data(shelling)

Format

     ‘shelling’ and ‘shelling2’ are point patterns (objects of class
     ‘"ppp"’) containing 106 and 110 points respectively inside
     polygonal observation windows. Spatial coordinates are given in
     metres, relative to an origin at the southwest corner of the
     containing rectangle.

Details

     The datasets ‘shelling’ and ‘shelling2’ give the spatial locations
     of impact marks, likely the result of high-explosive artillery
     rounds, in two fields in eastern Ukraine scarred by shelling.

     The fields are 1 km south of the village of Yakovlivka, near the
     cities of Soledar and Bakhmut, in Bakhmut Raion, Donetsk Oblast,
     Ukraine.  ‘shelling’ is located at 48 degrees 41 minutes 36
     seconds North, 38 degrees 09 minutes 08 seconds East, while
     ‘shelling2’ is an adjacent field to the east, at approximately 48
     degrees 41 minutes 38 seconds North, 38 degrees 09 minutes 33
     seconds East.

     The data were extracted by Tilman Davies from satellite imagery
     taken on 19 June 2022 and provided by Google Earth (2022).  Data
     were accessed on 18 April 2024.  The coordinates of the individual
     impact points and the region boundary were geo-located using
     Google Earth Pro. For each field, the resulting raw latitude and
     longitude coordinates were projected to approximate planar
     distances in meters using the centroid of the field.  Spatial
     coordinates in the datasets are given in metres, relative to an
     origin at the southwest corner of the containing rectangle.

     The data were first analysed by Baddeley, Davies and Hazelton
     (2025).

Source

     Google Earth and Tilman Davies <mailto:Tilman.Davies@otago.ac.nz>.

References

     Google Earth Pro (2022). Satellite imagery of Soledar taken on 19
     June 2022.  Google Earth Pro 7.3.6, Maxar Technologies, Airbus.
     <https://earth.google.com/web>.

     Baddeley, A., Davies, T.M. and Hazelton, M.L. (2025) An improved
     estimator of the pair correlation function of a spatial point
     process. _Biometrika_, to appear.

Examples
Run this code

     if(require(spatstat.geom)) {
       plot(shelling, pch=3)
       N <- onearrow(830, 400, 830, 530, "N")
       plot(N, add=TRUE)
       shelling <- rescale(shelling, 1000, "km")
       if(require(spatstat.explore)) {
         plot(density(shelling))
       }
     }

     if(require(spatstat.geom)) {
       plot(shelling2, pch=3)
       A <- onearrow(465, 590, 465, 710, "N")
       plot(A, add=TRUE)
       alpha <- atan2(775.7, 471.4) # about 59 degrees
       plot(rotate(shelling2, alpha))
       plot(rotate(A, alpha), add=TRUE)
     }

