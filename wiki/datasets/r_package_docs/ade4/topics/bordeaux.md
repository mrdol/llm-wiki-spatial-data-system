Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

bordeaux: Wine Tasting

Wine Tasting

Description

     The ‘bordeaux’ data frame gives the opinions of 200 judges in a
     blind tasting of five different types of claret (red wine from the
     Bordeaux area in the south western parts of France).

Usage

     data(bordeaux)

Format

     This data frame has 5 rows (the wines) and 4 columns (the
     judgements) divided in excellent, good, mediocre and boring.

Source

     van Rijckevorsel, J. (1987) _The application of fuzzy coding and
     horseshoes in multiple correspondence analysis_.  DSWO Press,
     Leiden (p. 32)


Variables detected from installed object

excellent: numeric ; missing=0 ; examples=45, 87, 0

good: numeric ; missing=0 ; examples=126, 93, 0

mediocre: numeric ; missing=0 ; examples=24, 19, 52

boring: numeric ; missing=0 ; examples=5, 1, 148

Examples
Run this code

     data(bordeaux)
     bordeaux
     score(dudi.coa(bordeaux, scan = FALSE))

