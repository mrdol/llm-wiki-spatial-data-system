Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

KleinI: Klein Model I

Klein Model I

Description

     Klein's Model I for the US economy.

Usage

     data("KleinI")

Format

     An annual multiple time series from 1920 to 1941 with 9 variables.

     consumption Consumption.

     cprofits Corporate profits.

     pwage Private wage bill.

     invest Investment.

     capital Previous year's capital stock.

     gnp Gross national product.

     gwage Government wage bill.

     gexpenditure Government spending.

     taxes Taxes.

Source

     Online complements to Greene (2003). Table F15.1.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

     Klein, L. (1950). _Economic Fluctuations in the United States,
     1921-1941_. New York: John Wiley.

     Maddala, G.S. (1977). _Econometrics_. New York: McGraw-Hill.

See Also

     ‘Greene2003’


Variables detected from installed object

consumption: numeric ; missing=0 ; examples=39.8, 41.9, 45

cprofits: numeric ; missing=0 ; examples=12.7, 12.4, 16.9

pwage: numeric ; missing=0 ; examples=28.8, 25.5, 29.3

invest: numeric ; missing=0 ; examples=2.7, -0.2, 1.9

capital: numeric ; missing=0 ; examples=180.1, 182.8, 182.6

gnp: numeric ; missing=0 ; examples=44.9, 45.6, 50.1

gwage: numeric ; missing=0 ; examples=2.2, 2.7, 2.9

gexpenditure: numeric ; missing=0 ; examples=2.4, 3.9, 3.2

taxes: numeric ; missing=0 ; examples=3.4, 7.7, 3.9

Examples
Run this code

     data("KleinI", package = "AER")
     plot(KleinI)

     ## Greene (2003), Tab. 15.3, OLS
     library("dynlm")
     fm_cons <- dynlm(consumption ~ cprofits + L(cprofits) + I(pwage + gwage), data = KleinI)
     fm_inv <- dynlm(invest ~ cprofits + L(cprofits) + capital, data = KleinI)
     fm_pwage <- dynlm(pwage ~ gnp + L(gnp) + I(time(gnp) - 1931), data = KleinI)
     summary(fm_cons)
     summary(fm_inv)
     summary(fm_pwage)

     ## More examples can be found in:
     ## help("Greene2003")

