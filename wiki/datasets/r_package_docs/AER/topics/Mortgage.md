Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

Fixed versus Adjustable Mortgages

Description

     Cross-section data about fixed versus adjustable mortgages for 78
     households.

Usage

     data("Mortgage")

Format

     A data frame containing 78 observations on 16 variables.

     rate Factor with levels ‘"fixed"’ and ‘"adjustable"’.

     age Age of the borrower.

     school Years of schooling for the borrower.

     networth Net worth of the borrower.

     interest Fixed interest rate.

     points Ratio of points paid on adjustable to fixed rate mortgages.

     maturities Ratio of maturities on adjustable to fixed rate
          mortgages.

     years Years at the present address.

     married Factor. Is the borrower married?

     first Factor. Is the borrower a first-time home buyer?

     selfemp Factor. Is the borrower self-employed?

     tdiff The difference between the 10-year treasury rate less the
          1-year treasury rate.

     margin The margin on the adjustable rate mortgage.

     coborrower Factor. Is there a co-borrower?

     liability Short-term liabilities.

     liquid Liquid assets.

Source

     The data is from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

     Dhillon, U.S., Shilling, J.D. and Sirmans, C.F. (1987). Choosing
     Between Fixed and Adjustable Rate Mortgages. _Journal of Money,
     Credit and Banking_, *19*, 260-267.

See Also

     ‘Baltagi2002’


Variables detected from installed object

rate: factor ; missing=0 ; examples=adjustable

age: integer ; missing=0 ; examples=38

school: integer ; missing=0 ; examples=22

networth: numeric ; missing=0 ; examples=7.558

interest: numeric ; missing=0 ; examples=13.62

points: numeric ; missing=0 ; examples=2.33

maturities: numeric ; missing=0 ; examples=1.5

years: integer ; missing=0 ; examples=1

married: factor ; missing=0 ; examples=no

first: factor ; missing=0 ; examples=yes

selfemp: factor ; missing=0 ; examples=no

tdiff: numeric ; missing=0 ; examples=1.38

margin: numeric ; missing=0 ; examples=1.5

coborrower: factor ; missing=0 ; examples=no

liability: numeric ; missing=0 ; examples=3.69

liquid: numeric ; missing=0 ; examples=8.91

Examples
Run this code

     data("Mortgage")
     plot(rate ~ interest, data = Mortgage, breaks = fivenum(Mortgage$interest))
     plot(rate ~ margin, data = Mortgage, breaks = fivenum(Mortgage$margin))
     plot(rate ~ coborrower, data = Mortgage)

