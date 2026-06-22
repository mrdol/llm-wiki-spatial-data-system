Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

GermanUnemployment: Unemployment in Germany Data

Unemployment in Germany Data

Description

     Time series of unemployment rate (in percent) in Germany.

Usage

     data("GermanUnemployment")

Format

     A quarterly multiple time series from 1962(1) to 1991(4) with 2
     variables.

     unadjusted Raw unemployment rate,

     adjusted Seasonally adjusted rate.

Source

     Online complements to Franses (1998).

References

     Franses, P.H. (1998). _Time Series Models for Business and
     Economic Forecasting_. Cambridge, UK: Cambridge University Press.

See Also

     ‘Franses1998’


Variables detected from installed object

unadjusted: numeric ; missing=0 ; examples=1.1, 0.5, 0.4

adjusted: numeric ; missing=0 ; examples=0.6, 0.7

Examples
Run this code

     data("GermanUnemployment")
     plot(GermanUnemployment, plot.type = "single", col = 1:2)

