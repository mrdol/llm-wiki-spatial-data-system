Rdocumentation
powered by

Search all packages and functions
HistData (version 1.0.0)

Waite's data on Patterns in Fingerprints

Description

     Waite (1915) was interested in analyzing the association of
     patterns in fingerprints, and produced a table of counts for 2000
     right hands, classified by the number of fingers describable as a
     "whorl", a "small loop" (or neither). Because each hand
     contributes five fingers, the number of ‘Whorls + Loops’ cannot
     exceed 5, so the contingency table is necessarily triangular.

     Karl Pearson (1904) introduced the test for independence in
     contingency tables, and by 1913 had developed methods for
     "restricted contingency tables," such as the triangular table
     analyzed by Waite.  The general formulation of such tests for
     association in restricted tables is now referred to as models for
     quasi-independence.

Format

     A frequency data frame with 36 observations on the following 3
     variables, representing a 6 x 6 table giving the
     cross-classification of the fingers on 2000 right hands as a
     whorl, small loop or neither.

     ‘Whorls’ Number of whorls, an ordered factor with levels ‘0’ < ‘1’
          < ‘2’ < ... < ‘5’

     ‘Loops’ Number of small loops, an ordered factor with levels ‘0’ <
          ‘1’ < ‘2’ < ‘3’ < ‘4’ < ‘5’

     ‘count’ Number of hands

Details

     Cells for which ‘Whorls + Loops > 5’ have ‘NA’ for ‘count’

Source

     Stigler, S. M. (1999). _Statistics on the Table_. Cambridge, MA:
     Harvard University Press, table 19.4.

References

     Pearson, K. (1904). Mathematical contributions to the theory of
     evolution. XIII. On the theory of contingency and its relation to
     association and normal correlation. Reprinted in _Karl Pearson's
     Early Statistical Papers_, Cambridge: Cambridge University Press,
     1948, 443-475.

     Waite, H. (1915). The analysis of fingerprints, _Biometrika_, 10,
     421-478.


Variables detected from installed object

Whorls: ordered/factor ; missing=0 ; examples=0, 1, 2

Loops: ordered/factor ; missing=0 ; examples=0

count: integer ; missing=15 ; examples=78, 106, 130

Examples
Run this code

     data(Fingerprints)
     xtabs(count ~ Whorls + Loops, data=Fingerprints)

