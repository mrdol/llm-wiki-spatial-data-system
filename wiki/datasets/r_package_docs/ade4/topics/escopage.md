Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

escopage: K-tables of wine-tasting

K-tables of wine-tasting

Description

     This data set describes 27 characteristics of 21 wines distributed
     in four fields : rest, visual, olfactory and global.

Usage

     data(escopage)

Format

     ‘escopage’ is a list of 3 components.

     tab is a data frame with 21 observations (wines) and 27 variables.

     tab.names is the vector of the names of sub-tables : "rest"
          "visual" "olfactory" "global".

     blo is a vector of the numbers of variables for each sub-table.

Source

     Escofier, B. and Pagès, J. (1990) _Analyses factorielles simples
     et multiples : objectifs, méthodes et interprétation_ Dunod,
     Paris. 1-267.

     Escofier, B. and Pagès, J. (1994) Multiple factor analysis (AFMULT
     package).  _Computational Statistics and Data Analysis_, *18*,
     121-140.

Examples
Run this code

     data(escopage)
     w <- data.frame(scale(escopage$tab))
     w <- ktab.data.frame(w, escopage$blo)
     names(w)[1:4] <- escopage$tab.names
     plot(mfa(w, scan = FALSE))

