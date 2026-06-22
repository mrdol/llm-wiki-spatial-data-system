Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

UKInflation: UK Manufacturing Inflation Data

UK Manufacturing Inflation Data

Description

     Time series of observed and expected price changes in British
     manufacturing.

Usage

     data("UKInflation")

Format

     A quarterly multiple time series from 1972(1) to 1985(2) with 2
     variables.

     actual Actual inflation.

     expected Expected inflation.

Source

     Online complements to Greene (2003), Table F8.1.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

     Pesaran, M.H., and Hall, A.D. (1988). Tests of Non-nested Linear
     Regression Models Subject To Linear Restrictions. _Economics
     Letters_, *27*, 341-348.

See Also

     ‘Greene2003’


Variables detected from installed object

actual: numeric ; missing=0 ; examples=0.99, 1.62, 1.87

expected: numeric ; missing=0 ; examples=0.79, 1.94, 2.97

Examples
Run this code

     data("UKInflation")
     plot(UKInflation)

