Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

chazeb: Charolais-Zebus

Charolais-Zebus

Description

     This data set gives six different weights of 23 charolais and zebu
     oxen.

Usage

     data(chazeb)

Format

     ‘chazeb’ is a list of 2 components.

     tab is a data frame with 23 rows and 6 columns.

     cla is a factor with two levels "cha" and "zeb".

Source

     Tomassone, R., Danzard, M., Daudin, J. J. and Masson J. P.  (1988)
     _Discrimination et classement_, Masson, Paris. p. 43

Examples
Run this code

     data(chazeb)
     if(!adegraphicsLoaded())
       plot(discrimin(dudi.pca(chazeb$tab, scan = FALSE),
         chazeb$cla, scan = FALSE))

