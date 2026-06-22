Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

chats: Pair of Variables

Pair of Variables

Description

     This data set is a contingency table of age classes and fecundity
     classes of cats _Felis catus_.

Usage

     data(chats)

Format

     ‘chats’ is a data frame with 8 rows and 8 columns.
     The 8 rows are age classes (age1, ..., age8).
     The 8 columns are fecundity classes (f0, f12, f34, ..., fcd).
     The values are cats numbers (contingency table).

Source

     Legay, J.M. and Pontier, D. (1985) Relation âge-fécondité dans les
     populations de Chats domestiques, Felis catus. _Mammalia_, *49*,
     395-402.


Variables detected from installed object

f0: numeric ; missing=0 ; examples=8, 6, 4

f12: numeric ; missing=0 ; examples=15, 12, 7

f34: numeric ; missing=0 ; examples=44, 36, 18

f56: numeric ; missing=0 ; examples=11, 21, 13

f78: numeric ; missing=0 ; examples=7, 11, 12

f9a: numeric ; missing=0 ; examples=4, 6

fbc: numeric ; missing=0 ; examples=0, 1, 2

fcd: numeric ; missing=0 ; examples=0, 1, 2

Examples
Run this code

     data(chats)
     chatsw <- as.table(t(chats))
     chatscoa <- dudi.coa(data.frame(t(chats)), scann = FALSE)

     if(adegraphicsLoaded()) {
       g1 <- table.value(chatsw, ppoints.cex = 1.3, meanX = TRUE, ablineX = TRUE, plabel.cex = 1.5,
         plot = FALSE)
       g2 <- table.value(chatsw, ppoints.cex = 1.3, meanY = TRUE, ablineY = TRUE, plabel.cex = 1.5,
         plot = FALSE)
       g3 <- table.value(chatsw, ppoints.cex = 1.3, coordsx = chatscoa$c1[,
       1], coordsy = chatscoa$l1[, 1], meanX = TRUE, ablineX = TRUE, plot = FALSE)
       g4 <- table.value(chatsw, ppoints.cex = 1.3, meanY = TRUE, ablineY = TRUE,
         coordsx = chatscoa$c1[, 1], coordsy = chatscoa$l1[, 1], plot = FALSE)
       G <- ADEgS(list(g1, g2, g3, g4), layout = c(2, 2))

     } else {
       par(mfrow = c(2, 2))
       table.cont(chatsw, abmean.x = TRUE, csi = 2, abline.x = TRUE, clabel.r = 1.5, clabel.c = 1.5)
       table.cont(chatsw, abmean.y = TRUE, csi = 2, abline.y = TRUE, clabel.r = 1.5, clabel.c = 1.5)
       table.cont(chatsw, x = chatscoa$c1[, 1], y = chatscoa$l1[, 1], abmean.x = TRUE, csi = 2,
         abline.x = TRUE, clabel.r = 1.5, clabel.c = 1.5)
       table.cont(chatsw, x = chatscoa$c1[, 1], y = chatscoa$l1[, 1], abmean.y = TRUE, csi = 2,
         abline.y = TRUE, clabel.r = 1.5, clabel.c = 1.5)
       par(mfrow = c(1, 1))
     }

