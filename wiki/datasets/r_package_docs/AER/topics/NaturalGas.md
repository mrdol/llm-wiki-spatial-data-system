Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

NaturalGas: Natural Gas Data

Natural Gas Data

Description

     Panel data originating from 6 US states over the period 1967-1989.

Usage

     data("NaturalGas")

Format

     A data frame containing 138 observations on 10 variables.

     state factor. State abbreviation.

     statecode factor. State Code.

     year factor coding year.

     consumption Consumption of natural gas by the residential sector.

     price Price of natural gas

     eprice Price of electricity.

     oprice Price of distillate fuel oil.

     lprice Price of liquefied petroleum gas.

     heating Heating degree days.

     income Real per-capita personal income.

Source

     The data are from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’


Variables detected from installed object

state: factor ; missing=0 ; examples=NY

statecode: factor ; missing=0 ; examples=35

year: factor ; missing=0 ; examples=1967, 1968, 1969

consumption: integer ; missing=0 ; examples=313656, 319282, 331326

price: numeric ; missing=0 ; examples=1.42, 1.38, 1.37

eprice: numeric ; missing=0 ; examples=2.98, 2.91, 2.84

oprice: numeric ; missing=0 ; examples=7.4, 7.77, 7.96

lprice: numeric ; missing=0 ; examples=1.47, 1.42, 1.38

heating: integer ; missing=0 ; examples=6262, 6125, 6040

income: numeric ; missing=0 ; examples=10903.75, 11370.02, 11578.68

Examples
Run this code

     data("NaturalGas")
     summary(NaturalGas)

