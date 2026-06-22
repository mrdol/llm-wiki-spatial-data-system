Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

rankrock: Ordination Table

Ordination Table

Description

     This data set gives the classification in order of preference of
     10 music groups by 51 students.

Usage

     data(rankrock)

Format

     A data frame with 10 rows and 51 columns.
     Each column contains the rank (1 for the favorite, ..., 10 for the
     less appreciated)
     attributed to the group by a student.


Variables detected from installed object

X1: integer ; missing=0 ; examples=6, 10, 5

X2: integer ; missing=0 ; examples=7, 9, 8

X3: integer ; missing=0 ; examples=4, 9, 8

X4: integer ; missing=0 ; examples=7, 8, 4

X5: integer ; missing=0 ; examples=7, 5, 2

X6: integer ; missing=0 ; examples=10, 8, 6

X7: integer ; missing=0 ; examples=9, 10, 6

X8: integer ; missing=0 ; examples=3, 2, 9

X9: integer ; missing=0 ; examples=10, 5, 3

X10: integer ; missing=0 ; examples=1, 9, 2

X11: integer ; missing=0 ; examples=7, 3, 8

X12: integer ; missing=0 ; examples=3, 6, 2

X13: integer ; missing=0 ; examples=7, 2, 6

X14: integer ; missing=0 ; examples=1, 7, 6

X15: integer ; missing=0 ; examples=7, 9, 3

X16: integer ; missing=0 ; examples=6, 4, 5

X17: integer ; missing=0 ; examples=8, 5, 4

X18: integer ; missing=0 ; examples=8, 6, 4

X19: integer ; missing=0 ; examples=10, 8, 9

X20: integer ; missing=0 ; examples=6, 9, 5

X21: integer ; missing=0 ; examples=9, 5, 4

X22: integer ; missing=0 ; examples=9, 6, 7

X23: integer ; missing=0 ; examples=10, 9, 2

X24: integer ; missing=0 ; examples=9, 8, 6

X25: integer ; missing=0 ; examples=9, 8, 7

X26: integer ; missing=0 ; examples=5, 7, 3

X27: integer ; missing=0 ; examples=10, 8, 7

X28: integer ; missing=0 ; examples=9, 8, 2

X29: integer ; missing=0 ; examples=4, 7, 8

X30: integer ; missing=0 ; examples=6, 5, 4

X31: integer ; missing=0 ; examples=9, 5, 3

X32: integer ; missing=0 ; examples=1, 2, 3

X33: integer ; missing=0 ; examples=1, 5, 4

X34: integer ; missing=0 ; examples=8, 1, 6

X35: integer ; missing=0 ; examples=9, 6, 5

X36: integer ; missing=0 ; examples=6, 5, 7

X37: integer ; missing=0 ; examples=6, 9, 4

X38: integer ; missing=0 ; examples=6, 4, 5

X39: integer ; missing=0 ; examples=10, 6, 5

X40: integer ; missing=0 ; examples=6, 5, 3

X41: integer ; missing=0 ; examples=6, 2, 5

X42: integer ; missing=0 ; examples=4, 5, 7

X43: integer ; missing=0 ; examples=6, 5, 4

X44: integer ; missing=0 ; examples=9, 4, 1

X45: integer ; missing=0 ; examples=7, 8, 6

X46: integer ; missing=0 ; examples=8, 9, 3

X47: integer ; missing=0 ; examples=9, 8, 3

X48: integer ; missing=0 ; examples=9, 6, 5

X49: integer ; missing=0 ; examples=8, 9, 7

X50: integer ; missing=0 ; examples=8, 9, 6

X51: integer ; missing=0 ; examples=4, 6, 2

Examples
Run this code

     data(rankrock)
     dudi1 <- dudi.pca(rankrock, scannf = FALSE, nf = 3)
     if(adegraphicsLoaded()) {
       g <- scatter(dudi1, row.plab.cex = 1.5)
     } else {
       scatter(dudi1, clab.r = 1.5)
     }

