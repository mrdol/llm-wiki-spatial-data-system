Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USGasB: US Gasoline Market Data (1950-1987, Baltagi)

US Gasoline Market Data (1950-1987, Baltagi)

Description

     Time series data on the US gasoline market.

Usage

     data("USGasB")

Format

     An annual multiple time series from 1950 to 1987 with 6 variables.

     cars Stock of cars.

     gas Consumption of motor gasoline (in 1000 gallons).

     price Retail price of motor gasoline.

     population Population.

     gnp Real gross national product (in 1982 dollars).

     deflator GNP deflator (1982 = 100).

Source

     The data are from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’, ‘USGasG’


Variables detected from installed object

cars: numeric ; missing=0 ; examples=49195212, 51948796, 53301329

gas: numeric ; missing=0 ; examples=40617285, 43896887, 46428148

price: numeric ; missing=0 ; examples=0.272, 0.276, 0.287

population: numeric ; missing=0 ; examples=152271, 154878, 157553

gnp: numeric ; missing=0 ; examples=1090.4, 1179.2, 1226.1

deflator: numeric ; missing=0 ; examples=26.1, 27.9, 28.3

Examples
Run this code

     data("USGasB")
     plot(USGasB)

