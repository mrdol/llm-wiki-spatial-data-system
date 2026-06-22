Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

mariages: Correspondence Analysis Table

Correspondence Analysis Table

Description

     This array contains the socio-professionnal repartitions of 5850
     couples.

Usage

     data(mariages)

Format

     The ‘mariages’ data frame has 9 rows and 9 columns. The rows
     represent the wife's socio-professionnal category and the columns
     the husband's socio-professionnal category (1982).
     Codes for rows and columns are identical : agri (Farmers), ouva
     (Farm workers), pat (Company directors (commerce and industry)),
     sup (Liberal profession, executives and higher intellectual
     professions), moy (Intermediate professions), emp (Other
     white-collar workers), ouv (Manual workers), serv (Domestic
     staff), aut (other workers).

Source

     Vallet, L.A. (1986) Activité professionnelle de la femme mariée et
     détermination de la position sociale de la famille. Un test
     empirique : la France entre 1962 et 1982. _Revue Française de
     Sociologie_, *27*, 656-696.


Variables detected from installed object

Hagri: integer ; missing=0 ; examples=420, 2, 9

Houva: integer ; missing=0 ; examples=3, 12, 1

Hpat: integer ; missing=0 ; examples=8, 0, 333

Hsup: integer ; missing=0 ; examples=2, 0, 38

Hmoy: integer ; missing=0 ; examples=2, 0, 24

Hemp: integer ; missing=0 ; examples=4, 1, 22

Houv: integer ; missing=0 ; examples=20, 10, 48

Hserv: integer ; missing=0 ; examples=0, 7

Haut: integer ; missing=0 ; examples=0, 3

Examples
Run this code

     data(mariages)
     w <- dudi.coa(mariages, scan = FALSE, nf = 3)

     if(adegraphicsLoaded()) {
       g1 <- scatter(w, met = 1, posi = "bottomleft", plot = FALSE)
       g2 <- scatter(w, met = 2, posi = "bottomleft", plot = FALSE)
       g3 <- scatter(w, met = 3, posi = "bottomleft", plot = FALSE)
       ## g4 <- score(w, 3)
       G <- ADEgS(list(g1, g2, g3), layout = c(2, 2))

     } else {
       par(mfrow = c(2, 2))
       scatter(w, met = 1, posi = "bottom")
       scatter(w, met = 2, posi = "bottom")
       scatter(w, met = 3, posi = "bottom")
       score(w, 3)
       par(mfrow = c(1, 1))
     }

