Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

OrangeCounty: Orange County Employment

Orange County Employment

Description

     Quarterly time series data on employment in Orange county,
     1965-1983.

Usage

     data("OrangeCounty")

Format

     A quarterly multiple time series from 1965 to 1983 with 2
     variables.

     employment Quarterly employment in Orange county.

     gnp Quarterly real GNP.

Source

     The data is from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

See Also

     ‘Baltagi2002’


Variables detected from installed object

employment: numeric ; missing=0 ; examples=288, 298.75, 302.78

gnp: numeric ; missing=0 ; examples=906.6016, 919.6007, 934.0129

Examples
Run this code

     data("OrangeCounty")
     plot(OrangeCounty)

