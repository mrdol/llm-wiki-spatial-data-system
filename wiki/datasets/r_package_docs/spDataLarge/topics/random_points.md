Rdocumentation
powered by

Search all packages and functions
spDataLarge (version 2.2.0)

random_points: Random points.

Random points.

Description

     An [sf] (EPSG:32717) object with 100 randomly sampled points
     (stratified by altitude) on the Mt. Mongón (Peru). For more
     details, please refer to Muenchow et al. (2013). The data is used
     in the "Ecology" chapter in Geocomputation with R. See
     <https://r.geocompx.org/eco.html> for details.

Format

     An [sf] object with 100 rows and 3 variables:

     id Plot ID.

     spri Number of vascular plant species per plot (species richness).

     geometry Simple feature point geometry.

References

     Muenchow, J., Bräuning, A., Rodríguez, E.F. & von Wehrden, H.
     (2013): Predictive mapping of species richness and plant species'
     distributions of a Peruvian fog oasis along an altitudinal
     gradient.  Biotropica 45, 5, 557-566, doi: 10.1111/btp.12049.


Variables detected from installed object

id: integer ; missing=0 ; examples=1, 2, 3

spri: integer ; missing=0 ; examples=4, 3

geometry: sfc_POINT/sfc ; missing=0

Examples
Run this code

     data("random_points", package = "spDataLarge")

