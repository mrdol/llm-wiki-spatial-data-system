Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

OECDGas: Gasoline Consumption Data

Gasoline Consumption Data

Description

     Panel data on gasoline consumption in 18 OECD countries over 19
     years, 1960-1978.

Usage

     data("OECDGas")

Format

     A data frame containing 342 observations on 6 variables.

     country Factor indicating country.

     year Year.

     gas Logarithm of motor gasoline consumption per car.

     income Logarithm of real per-capita income.

     price Logarithm of real motor gasoline price.

     cars Logarithm of the stock of cars per-capita.

Source

     The data is from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

     Baltagi, B.H. and Griffin, J.M. (1983). Gasoline Demand in the
     OECD: An Application of Pooling and Testing Procedures. _European
     Economic Review_, *22*, 117-137.

See Also

     ‘Baltagi2002’


Variables detected from installed object

country: factor ; missing=0 ; examples=Austria

year: integer ; missing=0 ; examples=1960, 1961, 1962

gas: numeric ; missing=0 ; examples=4.173244195, 4.1009891049, 4.0731765511

income: numeric ; missing=0 ; examples=-6.474277179, -6.426005835, -6.407308295

price: numeric ; missing=0 ; examples=-0.334547613, -0.351327614, -0.379517692

cars: numeric ; missing=0 ; examples=-9.766839569, -9.608621845, -9.457256552

Examples
Run this code

     data("OECDGas")

     library("lattice")
     xyplot(exp(cars) ~ year | country, data = OECDGas, type = "l")
     xyplot(exp(gas) ~ year | country, data = OECDGas, type = "l")

