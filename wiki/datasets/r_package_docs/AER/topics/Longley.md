Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

Longley's Regression Data

Description

     US macroeconomic time series, 1947-1962.

Usage

     data("Longley")

Format

     An annual multiple time series from 1947 to 1962 with 4 variables.

     employment Number of people employed (in 1000s).

     price GNP deflator.

     gnp Gross national product.

     armedforces Number of people in the armed forces.

Details

     An extended version of this data set, formatted as a
     ‘"data.frame"’ is available as ‘longley’ in base R.

Source

     Online complements to Greene (2003). Table F4.2.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

     Longley, J.W. (1967). An Appraisal of Least-Squares Programs from
     the Point of View of the User. _Journal of the American
     Statistical Association_, *62*, 819-841.

See Also

     ‘longley’, ‘Greene2003’


Variables detected from installed object

employment: numeric ; missing=0 ; examples=60323, 61122, 60171

price: numeric ; missing=0 ; examples=83, 88.5, 88.2

gnp: numeric ; missing=0 ; examples=234289, 259426, 258054

armedforces: numeric ; missing=0 ; examples=1590, 1456, 1616

Examples
Run this code

     data("Longley")
     library("dynlm")

     ## Example 4.6 in Greene (2003)
     fm1 <- dynlm(employment ~ time(employment) + price + gnp + armedforces,
       data = Longley)
     fm2 <- update(fm1, end = 1961)
     cbind(coef(fm2), coef(fm1))

     ## Figure 4.3 in Greene (2003)
     plot(rstandard(fm2), type = "b", ylim = c(-3, 3))
     abline(h = c(-2, 2), lty = 2)

