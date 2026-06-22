Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USMacroSWQ: Quarterly US Macroeconomic Data (1947-2004, Stock & Watson)

Quarterly US Macroeconomic Data (1947-2004, Stock & Watson)

Description

     Time series data on 2 US macroeconomic variables for 1947-2004.

Usage

     data("USMacroSWQ")

Format

     A quarterly multiple time series from 1947(1) to 2004(4) with 2
     variables.

     gdp real GDP for the United States in billions of chained (2000)
          dollars seasonally adjusted, annual rate.

     tbill 3-month treasury bill rate. Quarterly averages of daily
          dates in percentage points at an annual rate.

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘USMacroSW’, ‘USMacroSWM’, ‘USMacroB’,
     ‘USMacroG’


Variables detected from installed object

gdp: numeric ; missing=0 ; examples=1570.5, 1568.7, 1568

tbill: numeric ; missing=0 ; examples=0.38, 0.73667

Examples
Run this code

     data("USMacroSWQ")
     plot(USMacroSWQ)

