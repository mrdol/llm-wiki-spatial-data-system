Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USMoney

Description

     Money, output and price deflator time series data, 1950-1983.

Usage

     data("USMoney")

Format

     A quarterly multiple time series from 1950 to 1983 with 3
     variables.

     gnp nominal GNP.

     m1 M1 measure of money stock.

     deflator implicit price deflator for GNP.

Source

     Online complements to Greene (2003), Table F20.2.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

See Also

     ‘Greene2003’


Variables detected from installed object

gnp: numeric ; missing=0 ; examples=267.6, 277.1, 294.8

m1: numeric ; missing=0 ; examples=110.2, 111.75, 112.95

deflator: numeric ; missing=0 ; examples=56.04, 56.21, 56.41

Examples
Run this code

     data("USMoney")
     plot(USMoney)

