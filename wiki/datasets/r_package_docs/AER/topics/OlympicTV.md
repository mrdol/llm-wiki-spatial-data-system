Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

OlympicTV: Television Rights for Olympic Games

Television Rights for Olympic Games

Description

     Television rights for Olympic Games for US networks (in millions
     USD).

Usage

     data("OlympicTV")

Format

     A data frame with 10 observations and 2 variables.

     rights time series of television rights (in million USD),

     network factor coding television network.

Source

     Online complements to Franses (1998).

References

     Franses, P.H. (1998). _Time Series Models for Business and
     Economic Forecasting_. Cambridge, UK: Cambridge University Press.

See Also

     ‘Franses1998’


Variables detected from installed object

rights: ts ; missing=0 ; examples=0.394, 1.5, 4.5

network: factor ; missing=0 ; examples=CBS, NBC, ABC

Examples
Run this code

     data("OlympicTV")
     plot(OlympicTV$rights)

