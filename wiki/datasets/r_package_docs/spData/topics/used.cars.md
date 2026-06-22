Rdocumentation
powered by

Search all packages and functions
spData (version 2.3.4)

used.cars: US 1960 used car prices

US 1960 used car prices

Description

     The ‘used.cars’ data frame has 48 rows and 2 columns. The data set
     includes a neighbours list for the 48 states excluding DC from
     poly2nb().

Usage

     used.cars

Format

     This data frame contains the following columns:

        * tax.charges: taxes and delivery charges for 1955-9 new cars

        * price.1960: 1960 used car prices by state

Source

     Hanna, F. A. 1966 Effects of regional differences in taxes and
     transport charges on automobile consumption, in Ostry, S., Rhymes,
     J. K. (eds) Papers on regional statistical studies, Toronto:
     Toronto University Press, pp. 199-223.

References

     Hepple, L. W. 1976 A maximum likelihood model for econometric
     estimation with spatial series, in Masser, I (ed) Theory and
     practice in regional science, London: Pion, pp. 90-104.


Variables detected from installed object

tax.charges: numeric ; missing=0 ; examples=129, 218, 176

price.1960: numeric ; missing=0 ; examples=1461, 1601, 1469

Examples
Run this code

     if (requireNamespace("spdep", quietly = TRUE)) {
       library(spdep)
       data(used.cars)
       moran.test(used.cars$price.1960, nb2listw(usa48.nb))
       moran.plot(used.cars$price.1960, nb2listw(usa48.nb),
                labels=rownames(used.cars))
       uc.lm <- lm(price.1960 ~ tax.charges, data=used.cars)
       summary(uc.lm)

       lm.morantest(uc.lm, nb2listw(usa48.nb))
       lm.morantest.sad(uc.lm, nb2listw(usa48.nb))
       lm.LMtests(uc.lm, nb2listw(usa48.nb))

       if (requireNamespace("spatialreg", quietly = TRUE)) {
         library(spatialreg)
         uc.err <- errorsarlm(price.1960 ~ tax.charges, data=used.cars,
                            nb2listw(usa48.nb), tol.solve=1.0e-13,
                            control=list(tol.opt=.Machine$double.eps^0.3))
         summary(uc.err)
         uc.lag <- lagsarlm(price.1960 ~ tax.charges, data=used.cars,
                          nb2listw(usa48.nb), tol.solve=1.0e-13,
                          control=list(tol.opt=.Machine$double.eps^0.3))
         summary(uc.lag)
         uc.lag1 <- lagsarlm(price.1960 ~ 1, data=used.cars,
                           nb2listw(usa48.nb), tol.solve=1.0e-13,
                           control=list(tol.opt=.Machine$double.eps^0.3))
         summary(uc.lag1)
         uc.err1 <- errorsarlm(price.1960 ~ 1, data=used.cars,
                             nb2listw(usa48.nb), tol.solve=1.0e-13,
                             control=list(tol.opt=.Machine$double.eps^0.3),
                             Durbin=FALSE)
         summary(uc.err1)
       }

     }

