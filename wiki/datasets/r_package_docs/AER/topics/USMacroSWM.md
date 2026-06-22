Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USMacroSWM: Monthly US Macroeconomic Data (1947-2004, Stock & Watson)

Monthly US Macroeconomic Data (1947-2004, Stock & Watson)

Description

     Time series data on 4 US macroeconomic variables for 1947-2004.

Usage

     data("USMacroSWM")

Format

     A monthly multiple time series from 1947(1) to 2004(4) with 4
     variables.

     production index of industrial production.

     oil oil price shocks, starting 1948(1).

     cpi all-items consumer price index.

     expenditure personal consumption expenditures price deflator,
          starting 1959(1).

Source

     Online complements to Stock and Watson (2007).

References

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘USMacroSW’, ‘USMacroSWQ’, ‘USMacroB’,
     ‘USMacroG’


Variables detected from installed object

production: numeric ; missing=0 ; examples=17.04, 17.14, 17.24

oil: numeric ; missing=12 ; examples=0.06, 0

cpi: numeric ; missing=0 ; examples=21.48, 21.62, 22

expenditure: numeric ; missing=144 ; examples=20.32

Examples
Run this code

     data("USMacroSWM")
     plot(USMacroSWM)

