Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

doubs: Pair of Ecological Tables

Pair of Ecological Tables

Description

     This data set gives environmental variables, fish species and
     spatial coordinates for 30 sites.

Usage

     data(doubs)

Format

     ‘doubs’ is a list with 4 components.

     env is a data frame with 30 rows (sites) and 11 environmental
          variables.

     fish is a data frame with 30 rows (sites) and 27 fish species.

     xy is a data frame with 30 rows (sites) and 2 spatial coordinates.

     species is a data frame with 27 rows (species) and 4 columns
          (names).

Details

     The rows of ‘doubs$env’, ‘doubs$fish’ and ‘doubs$xy’ are 30 sites
     along the Doubs, a French and Switzerland river.

     ‘doubs$env’ contains the following variables: dfs - distance from
     the source (km * 10), alt - altitude (m), slo (log(x + 1) where
     _x_ is the slope (per mil * 100), flo - minimum average stream
     flow (m3/s * 100), pH (* 10), har - total hardness of water (mg/l
     of Calcium), pho - phosphates (mg/l * 100), nit - nitrates (mg/l *
     100), amm - ammonia nitrogen (mg/l * 100), oxy - dissolved oxygen
     (mg/l * 10), bdo - biological demand for oxygen (mg/l * 10).

     ‘doubs$fish’ contains the abundance of the following fish species:
     _Cottus gobio_ (Cogo), _Salmo trutta fario_ (Satr), _Phoxinus
     phoxinus_ (Phph), _Nemacheilus barbatulus_ (Neba), _Thymallus
     thymallus_ (Thth), _Telestes soufia agassizi_ (Teso),
     _Chondrostoma nasus_ (Chna), _Chondostroma toxostoma_ (Chto),
     _Leuciscus leuciscus_ (Lele), _Leuciscus cephalus cephalus_
     (Lece), _Barbus barbus_ (Baba), _Spirlinus bipunctatus_ (Spbi),
     _Gobio gobio_ (Gogo), _Esox lucius_ (Eslu), _Perca fluviatilis_
     (Pefl), _Rhodeus amarus_ (Rham), _Lepomis gibbosus_ (Legi),
     _Scardinius erythrophtalmus_ (Scer), _Cyprinus carpio_ (Cyca),
     _Tinca tinca_ (Titi), _Abramis brama_ (Abbr), _Ictalurus melas_
     (Icme), _Acerina cernua_ (Acce), _Rutilus rutilus_ (Ruru), _Blicca
     bjoerkna_ (Blbj), _Alburnus alburnus_ (Alal), _Anguilla anguilla_
     (Anan).

     ‘doubs$species’ contains the names of the 27 fish species. The
     four columns correspond to: 1 = scientific name (Genus species), 2
     = French common name, 3 = English common name, 4 = Four character
     code.

Source

     Verneaux, J. (1973) _Cours d'eau de Franche-Comté (Massif du
     Jura).  Recherches écologiques sur le réseau hydrographique du
     Doubs. Essai de biotypologie_.  Thèse d'état, Besançon. 1-257.

References

     See a French description of fish species at
     <http://pbil.univ-lyon1.fr/R/pdf/pps047.pdf>.
     Chessel, D., Lebreton, J.D. and Yoccoz, N.G. (1987) Propriétés de
     l'analyse canonique des correspondances. Une illustration en
     hydrobiologie. _Revue de Statistique Appliquée_, *35*, 4, 55-72.

Examples
Run this code

     data(doubs)
     pca1 <- dudi.pca(doubs$env, scan = FALSE)
     pca2 <- dudi.pca(doubs$fish, scale = FALSE, scan = FALSE)
     coiner1 <- coinertia(pca1, pca2, scan = FALSE)

     if(adegraphicsLoaded()) {
       g1 <- s.corcircle(coiner1$aX, plot = FALSE)
       g2 <- s.value(doubs$xy, coiner1$lX[, 1], plot = FALSE)
       g3 <- s.value(doubs$xy, coiner1$lX[, 2], plot = FALSE)
       g4 <- s.arrow(coiner1$c1, plot = FALSE)
       g5 <- s.match(coiner1$mX, coiner1$mY, plot = FALSE)
       g6 <- s.corcircle(coiner1$aY, plot = FALSE)
       g7 <- s.arrow(coiner1$l1, plot = FALSE)
       g8 <- s.value(doubs$xy, coiner1$lY[, 1], plot = FALSE)
       g9 <- s.value(doubs$xy, coiner1$lY[, 2], plot = FALSE)
       G <- ADEgS(list(g1, g2, g3, g4, g5, g6, g7, g8, g9), layout = c(3, 3))

     } else {
       par(mfrow = c(3, 3))
       s.corcircle(coiner1$aX)
       s.value(doubs$xy, coiner1$lX[, 1])
       s.value(doubs$xy, coiner1$lX[, 2])
       s.arrow(coiner1$c1)
       s.match(coiner1$mX, coiner1$mY)
       s.corcircle(coiner1$aY)
       s.arrow(coiner1$l1)
       s.value(doubs$xy, coiner1$lY[, 1])
       s.value(doubs$xy, coiner1$lY[, 2])
       par(mfrow = c(1, 1))
     }

