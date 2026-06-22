Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USConsump1979: US Consumption Data (1970-1979)

US Consumption Data (1970-1979)

Description

     Time series data on US income and consumption expenditure,
     1970-1979.

Usage

     data("USConsump1979")

Format

     An annual multiple time series from 1970 to 1979 with 2 variables.

     income Disposable income.

     expenditure Consumption expenditure.

Source

     Online complements to Greene (2003). Table F1.1.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

See Also

     ‘Greene2003’, ‘USConsump1950’, ‘USConsump1993’


Variables detected from installed object

income: numeric ; missing=0 ; examples=751.6, 779.2, 810.3

expenditure: numeric ; missing=0 ; examples=672.1, 696.8, 737.1

Examples
Run this code

     data("USConsump1979")
     plot(USConsump1979)

     ## Example 1.1 in Greene (2003)
     plot(expenditure ~ income, data = as.data.frame(USConsump1979), pch = 19)
     fm <- lm(expenditure ~ income, data = as.data.frame(USConsump1979))
     summary(fm)
     abline(fm)

