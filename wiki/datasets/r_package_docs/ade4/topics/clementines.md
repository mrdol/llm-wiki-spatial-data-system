Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

clementines: Fruit Production

Fruit Production

Description

     The ‘clementines’ is a data set containing the fruit production of
     20 clementine trees during 15 years.

Usage

     data(clementines)

Format

     A data frame with 15 rows and 20 columns

Source

     Tisné-Agostini, D. (1988) _Description par analyse en composantes
     principales de l'évolution de la production du clémentinier en
     association avec 12 types de porte-greffe_. Rapport technique, DEA
     Analyse et modélisation des systèmes biologiques, Université Lyon
     1.


Variables detected from installed object

a1: numeric ; missing=0 ; examples=18.6, 37.6, 71.6

a2: numeric ; missing=0 ; examples=17, 38.2, 67.8

a3: numeric ; missing=0 ; examples=19, 36.2, 90.4

a4: numeric ; missing=0 ; examples=6, 48.6, 77

a5: numeric ; missing=0 ; examples=15.8, 43.6, 81.6

a6: numeric ; missing=0 ; examples=0, 22.8, 36.6

a7: numeric ; missing=0 ; examples=6.2, 31, 62

a8: numeric ; missing=0 ; examples=5, 30.2, 31.1

a9: numeric ; missing=0 ; examples=7.2, 27, 65

a10: numeric ; missing=0 ; examples=0, 25.8, 60.8

a11: numeric ; missing=0 ; examples=8, 19.4, 60.2

a12: numeric ; missing=0 ; examples=15, 38, 71.4

a13: numeric ; missing=0 ; examples=2.8, 35.8, 66.6

a14: numeric ; missing=0 ; examples=4.4, 35.4, 48

a15: numeric ; missing=0 ; examples=6.6, 34.8, 52

a16: numeric ; missing=0 ; examples=4, 28.6, 34.1

a17: numeric ; missing=0 ; examples=2.4, 41.2, 30

a18: numeric ; missing=0 ; examples=9.6, 24.4, 54

a19: numeric ; missing=0 ; examples=0, 33.8, 47.6

a20: numeric ; missing=0 ; examples=2.2, 31.2, 57.6

Examples
Run this code

     data(clementines)

     op <- par(no.readonly = TRUE)
     par(mfrow = c(5, 4))
     par(mar = c(2, 2, 1, 1))
     for(i in 1:20) {
       w0 <- 1:15
       plot(w0, clementines[, i], type = "b")
       abline(lm(clementines[, i] ~ w0))
     }
     par(op)

     pca1 <- dudi.pca(clementines, scan = FALSE)
     if(adegraphicsLoaded()) {
       g1 <- s.corcircle(pca1$co, plab.cex = 0.75)
       g2 <- s1d.barchart(pca1$li[, 1], p1d.hori = FALSE)
     } else {
       s.corcircle(pca1$co, clab = 0.75)
       barplot(pca1$li[, 1])
     }

     op <- par(no.readonly = TRUE)
     par(mfrow = c(5, 4))
     par(mar = c(2, 2, 1, 1))
     clem0 <- pca1$tab
     croi <- 1:15
     alter <- c(rep(c(1, -1), 7), 1)
     for(i in 1:20) {
       y <- clem0[,i]
       plot(w0, y, type = "b", ylim = c(-2, 2))
       z <- predict(lm(clem0[, i] ~ croi * alter))
       points(w0, z, pch = 20, cex = 2)
       for(j in 1:15)
         segments(j, y[j], j, z[j])
     }
     par(op)
     par(mfrow = c(1, 1))

