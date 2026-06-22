Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

skulls: Morphometric Evolution

Morphometric Evolution

Description

     This data set gives four anthropometric measures of 150 Egyptean
     skulls belonging to five different historical periods.

Usage

     data(skulls)

Format

     The ‘skulls’ data frame has 150 rows (egyptean skulls) and 4
     columns (anthropometric measures).  The four variables are the
     maximum breadth (V1), the basibregmatic height (V2), the
     basialveolar length (V3) and the nasal height (V4). All
     measurements were taken in millimeters.

Details

     The measurements are made on 5 groups and 30 Egyptian skulls. The
     groups are defined as follows :
     1 - the early predynastic period (circa 4000 BC)
     2 - the late predynastic period (circa 3300 BC)
     3 - the 12th and 13th dynasties (circa 1850 BC)
     4 - the Ptolemiac period (circa 200 BC)
     5 - the Roman period (circa 150 BC)

Source

     Thompson, A. and Randall-Maciver, R. (1905) _Ancient races of the
     Thebaid_, Oxford University Press.

References

     Manly, B.F. (1994) _Multivariate Statistical Methods. A primer_,
     Second edition. Chapman & Hall, London. 1-215.
     The example is treated pp. 6, 13, 51, 64, 72, 107, 112 and 117.


Variables detected from installed object

V1: numeric ; missing=0 ; examples=131, 125

V2: numeric ; missing=0 ; examples=138, 131, 132

V3: numeric ; missing=0 ; examples=89, 92, 99

V4: numeric ; missing=0 ; examples=49, 48, 50

Examples
Run this code

     data(skulls)
     pca1 <- dudi.pca(skulls, scan = FALSE)
     fac <- gl(5, 30)
     levels(fac) <- c("-4000", "-3300", "-1850", "-200", "+150")
     dis.skulls <- discrimin(pca1, fac, scan = FALSE)
     if(!adegraphicsLoaded())
       plot(dis.skulls)

