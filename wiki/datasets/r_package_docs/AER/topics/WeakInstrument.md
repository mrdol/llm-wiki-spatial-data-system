Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

WeakInstrument: Artificial Weak Instrument Data

Artificial Weak Instrument Data

Description

     Artificial data set to illustrate the problem of weak instruments.

Usage

     data("WeakInstrument")

Format

     A data frame containing 200 observations on 3 variables.

     y dependent variable.

     x regressor variable.

     z instrument variable.

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

y: numeric ; missing=0 ; examples=2.829, 2.681, 0.873

x: numeric ; missing=0 ; examples=1.39, 1.134, 0.934

z: numeric ; missing=0 ; examples=0.05, -0.534, -0.002

Examples
Run this code

     data("WeakInstrument")
     fm <- ivreg(y ~ x | z, data = WeakInstrument)
     summary(fm)

