Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

farms: Ecological Factors in Farm Management

Ecological Factors in Farm Management

Description

     The ‘farms’ data frame has 20 rows and 4 columns. The rows are
     farms on the Dutch island of Terschelling and the columns are
     factors describing the management of grassland.

Usage

     farms

Format

     This data frame contains the following columns:

     ‘Mois’ Five levels of soil moisture - level 3 does not occur at
          these 20 farms.

     ‘Manag’ Grassland management type (‘SF’ = standard, ‘BF’ =
          biological, ‘HF’ = hobby farming, ‘NM’ = nature
          conservation).

     ‘Use’ Grassland use (‘U1’ = hay production, ‘U2’ = intermediate,
          ‘U3’ = grazing).

     ‘Manure’ Manure usage - classes ‘C0’ to ‘C4’.

Source

     J.C. Gower and D.J. Hand (1996) _Biplots_. Chapman & Hall, Table
     4.6.

     Quoted as from:
     R.H.G. Jongman, C.J.F. ter Braak and O.F.R. van Tongeren (1987)
     _Data Analysis in Community and Landscape Ecology._ PUDOC,
     Wageningen.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

Mois: factor ; missing=0 ; examples=M1, M2

Manag: factor ; missing=0 ; examples=SF, BF

Use: factor ; missing=0 ; examples=U2

Manure: factor ; missing=0 ; examples=C4, C2

Examples
Run this code

     farms.mca <- mca(farms, abbrev = TRUE)  # Use levels as names
     eqscplot(farms.mca$cs, type = "n")
     text(farms.mca$rs, cex = 0.7)
     text(farms.mca$cs, labels = dimnames(farms.mca$cs)[[1]], cex = 0.7)

