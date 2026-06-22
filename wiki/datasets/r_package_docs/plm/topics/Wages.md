Rdocumentation
powered by

Search all packages and functions
plm (version 2.6.7)

Panel Data of Individual Wages

Description

     A panel of 595 individuals from 1976 to 1982, taken from the Panel
     Study of Income Dynamics (PSID).

     The data are organized as a stacked time series/balanced panel,
     see *Examples* on how to convert to a ‘pdata.frame’.

Format

     A data frame containing:

     exp years of full-time work experience.

     wks weeks worked.

     bluecol blue collar?

     ind works in a manufacturing industry?

     south resides in the south?

     smsa resides in a standard metropolitan statistical area?

     married married?

     sex a factor with levels ‘"male"’ and ‘"female"’

     union individual's wage set by a union contract?

     ed years of education.

     black is the individual black?

     lwage logarithm of wage.

Details

     _total number of observations_ : 4165

     _observation_ : individuals

     _country_ : United States

Source

     Online complements to Baltagi (2001):

     <https://www.wiley.com/legacy/wileychi/baltagi/>

     Online complements to Baltagi (2013):

     <https://bcs.wiley.com/he-bcs/Books?action=resource&bcsId=4338&itemId=1118672321&resourceId=13452>

References

     Baltagi BH (2001). _Econometric Analysis of Panel Data_, 3rd
     edition. John Wiley and Sons ltd.

     Baltagi BH (2013). _Econometric Analysis of Panel Data_, 5th
     edition. John Wiley and Sons ltd.

     Cornwell C, Rupert P (1988). “Efficient Estimation With Panel
     Data: an Empirical Comparison of Instrumental Variables
     Estimators.” _Journal of Applied Econometrics_, *3*, 149-155.


Variables detected from installed object

exp: integer ; missing=0 ; examples=3, 4, 5

wks: integer ; missing=0 ; examples=32, 43, 40

bluecol: factor ; missing=0 ; examples=no

ind: integer ; missing=0 ; examples=0

south: factor ; missing=0 ; examples=yes

smsa: factor ; missing=0 ; examples=no

married: factor ; missing=0 ; examples=yes

sex: factor ; missing=0 ; examples=male

union: factor ; missing=0 ; examples=no

ed: integer ; missing=0 ; examples=9

black: factor ; missing=0 ; examples=no

lwage: numeric ; missing=0 ; examples=5.56068, 5.72031, 5.99645

Examples
Run this code

     # data set 'Wages' is organized as a stacked time series/balanced panel
     data("Wages", package = "plm")
     Wag <- pdata.frame(Wages, index=595)

