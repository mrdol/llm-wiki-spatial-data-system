Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

EuroEnergy: European Energy Consumption Data

European Energy Consumption Data

Description

     Cross-section data on energy consumption for 20 European
     countries, for the year 1980.

Usage

     data("EuroEnergy")

Format

     A data frame containing 20 observations on 2 variables.

     gdp Real gross domestic product for the year 1980 (in million 1975
          US dollars).

     energy Aggregate energy consumption (in million kilograms coal
          equivalence).

Source

     The data are from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’


Variables detected from installed object

gdp: integer ; missing=0 ; examples=45451, 62049, 2003

energy: integer ; missing=0 ; examples=30633, 58894, 1211

Examples
Run this code

     data("EuroEnergy")
     energy_lm <- lm(log(energy) ~ log(gdp), data = EuroEnergy)
     influence.measures(energy_lm)

