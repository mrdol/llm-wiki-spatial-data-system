Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USMacroB: US Macroeconomic Data (1959-1995, Baltagi)

US Macroeconomic Data (1959-1995, Baltagi)

Description

     Time series data on 3 US macroeconomic variables for 1959-1995,
     extracted from the Citibank data base.

Usage

     data("USMacroB")

Format

     A quarterly multiple time series from 1959(1) to 1995(2) with 3
     variables.

     gnp Gross national product.

     mbase Average of the seasonally adjusted monetary base.

     tbill Average of 3 month treasury-bill rate (per annum).

Source

     The data is from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’, ‘USMacroSW’, ‘USMacroSWQ’, ‘USMacroSWM’, ‘USMacroG’


Variables detected from installed object

gnp: numeric ; missing=0 ; examples=1915.1, 1947.7, 1941.8

mbase: numeric ; missing=0 ; examples=139.33, 140.53, 141.53

tbill: numeric ; missing=0 ; examples=2.8003, 3.0193, 3.533

Examples
Run this code

     data("USMacroB")
     plot(USMacroB)

