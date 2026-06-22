Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

lsl: Landslide dataset from Southern Ecuador

Landslide dataset from Southern Ecuador

Description

     Data used in the "Statistical learning for geographic data"
     chapter in Geocomputation with R. See
     <https://r.geocompx.org/spatial-cv.html> for details.

Usage

     lsl

Format

     The landslide dataset consists of two objects (CRS: UTM zone 17S;
     EPSG:32717):

       1. ‘lsl’ A ‘data.frame’ object representing the coordinates of
          landslide initiation points with 350 rows and 8 columns.

       2. ‘study_mask’ An ‘sf’-object delineating the natural part of
          the study area.

Source

     Landslide dataset of the RSAGA package: ‘data("landslides",
     package = "RSAGA")’.

     *Landslide Data:*

     Muenchow, J., Brenning, A., Richter, R. (2012): Geomorphic process
     rates of landslides along a humidity gradient in the tropical
     Andes, Geomorphology 139-140, 271-284. DOI:
     10.1016/j.geomorph.2011.10.029.

     Stoyan, R. (2000): Aktivitaet, Ursachen und Klassifikation der
     Rutschungen in San Francisco/Suedecuador. Unpublished diploma
     thesis, University of Erlangen-Nuremberg, Germany.

See Also

     ‘?ta.tif’


Variables detected from installed object

x: numeric ; missing=0 ; examples=713887.726935, 712787.726935, 713407.726935

y: numeric ; missing=0 ; examples=9558536.759956, 9558916.759956, 9560306.759956

lslpts: factor ; missing=0 ; examples=FALSE

slope: numeric ; missing=0 ; examples=33.7518539428711, 39.4082145690918, 37.4540939331055

cplan: numeric ; missing=0 ; examples=0.0231804493814707, -0.0386389084160328, -0.0133291082456708

cprof: numeric ; missing=0 ; examples=0.00319306110031903, -0.0171878132969141, 0.00967108737677336

elev: numeric ; missing=0 ; examples=2422.81, 2051.771, 1957.832

log10_carea: numeric ; missing=0 ; examples=2.78431921251746, 4.14601253967446, 3.64355613875429

Examples
Run this code

     data("lsl", "study_mask", package = "spDataLarge")

