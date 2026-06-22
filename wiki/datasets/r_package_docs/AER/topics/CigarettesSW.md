Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

CigarettesSW: Cigarette Consumption Panel Data

Cigarette Consumption Panel Data

Description

     Panel data on cigarette consumption for the 48 continental US
     States from 1985-1995.

Usage

     data("CigarettesSW")

Format

     A data frame containing 48 observations on 7 variables for 2
     periods.

     state Factor indicating state.

     year Factor indicating year.

     cpi Consumer price index.

     population State population.

     packs Number of packs per capita.

     income State personal income (total, nominal).

     tax Average state, federal and average local excise taxes for
          fiscal year.

     price Average price during fiscal year, including sales tax.

     taxs Average excise taxes for fiscal year, including sales tax.

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘CigarettesB’


Variables detected from installed object

state: factor ; missing=0 ; examples=AL, AR, AZ

year: factor ; missing=0 ; examples=1985

cpi: numeric ; missing=0 ; examples=1.07599997520447

population: numeric ; missing=0 ; examples=3973000, 2327000, 3184000

packs: numeric ; missing=0 ; examples=116.486282348633, 128.534591674805, 104.522613525391

income: numeric ; missing=0 ; examples=46014968, 26210736, 43956936

tax: numeric ; missing=0 ; examples=32.5000038146973, 37, 31

price: numeric ; missing=0 ; examples=102.181671142578, 101.474998474121, 108.578750610352

taxs: numeric ; missing=0 ; examples=33.3483352661133, 37, 36.1704177856445

Examples
Run this code

     ## Stock and Watson (2007)
     ## data and transformations
     data("CigarettesSW")
     CigarettesSW <- transform(CigarettesSW,
       rprice  = price/cpi,
       rincome = income/population/cpi,
       rtax    = tax/cpi,
       rtdiff  = (taxs - tax)/cpi
     )
     c1985 <- subset(CigarettesSW, year == "1985")
     c1995 <- subset(CigarettesSW, year == "1995")

     ## convenience function: HC1 covariances
     hc1 <- function(x) vcovHC(x, type = "HC1")

     ## Equations 12.9--12.11
     fm_s1 <- lm(log(rprice) ~ rtdiff, data = c1995)
     coeftest(fm_s1, vcov = hc1)
     fm_s2 <- lm(log(packs) ~ fitted(fm_s1), data = c1995)
     fm_ivreg <- ivreg(log(packs) ~ log(rprice) | rtdiff, data = c1995)
     coeftest(fm_ivreg, vcov = hc1)

     ## Equation 12.15
     fm_ivreg2 <- ivreg(log(packs) ~ log(rprice) + log(rincome) | log(rincome) + rtdiff, data = c1995)
     coeftest(fm_ivreg2, vcov = hc1)
     ## Equation 12.16
     fm_ivreg3 <- ivreg(log(packs) ~ log(rprice) + log(rincome) | log(rincome) + rtdiff + rtax,
       data = c1995)
     coeftest(fm_ivreg3, vcov = hc1)

     ## More examples can be found in:
     ## help("StockWatson2007")

