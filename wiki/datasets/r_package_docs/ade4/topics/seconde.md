Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

seconde: Students and Subjects

Students and Subjects

Description

     The ‘seconde’ data frame gives the marks of 22 students for 8
     subjects.

Usage

     data(seconde)

Format

     This data frame (22,8) contains the following columns: - HGEO:
     History and Geography - FRAN: French literature - PHYS: Physics -
     MATH: Mathematics - BIOL: Biology - ECON: Economy - ANGL: English
     language - ESPA: Spanish language

Source

     Personal communication


Variables detected from installed object

HGEO: numeric ; missing=0 ; examples=11.6, 13.6, 13.2

FRAN: numeric ; missing=0 ; examples=8.7, 12.3, 12.1

PHYS: numeric ; missing=0 ; examples=4.5, 6.2, 8.5

MATH: numeric ; missing=0 ; examples=7.6, 8.5, 6.3

BIOL: numeric ; missing=0 ; examples=9, 12, 11.6

ECON: numeric ; missing=0 ; examples=6.5, 11.5, 11

ANGL: numeric ; missing=0 ; examples=10, 7, 13

ESPA: numeric ; missing=0 ; examples=15.5, 12, 14.5

Examples
Run this code

     data(seconde)
     if(adegraphicsLoaded()) {
       scatter(dudi.pca(seconde, scan = FALSE), row.plab.cex = 1, col.plab.cex = 1.5)
     } else {
       scatter(dudi.pca(seconde, scan = FALSE), clab.r = 1, clab.c = 1.5)
     }

