Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

ChinaIncome: Chinese Real National Income Data

Chinese Real National Income Data

Description

     Time series of real national income in China per section (index
     with 1952 = 100).

Usage

     data("ChinaIncome")

Format

     An annual multiple time series from 1952 to 1988 with 5 variables.

     agriculture Real national income in agriculture sector.

     industry Real national income in industry sector.

     construction Real national income in construction sector.

     transport Real national income in transport sector.

     commerce Real national income in commerce sector.

Source

     Online complements to Franses (1998).

References

     Chow, G.C. (1993). Capital Formation and Economic Growth in China.
     _Quarterly Journal of Economics_, *103*, 809-842.

     Franses, P.H. (1998). _Time Series Models for Business and
     Economic Forecasting_. Cambridge, UK: Cambridge University Press.

See Also

     ‘Franses1998’


Variables detected from installed object

agriculture: numeric ; missing=0 ; examples=100, 101.6, 103.3

commerce: numeric ; missing=0 ; examples=100, 133, 136.4

construction: numeric ; missing=0 ; examples=100, 138.1, 133.3

industry: numeric ; missing=0 ; examples=100, 133.6, 159.1

transport: numeric ; missing=0 ; examples=100, 120, 136

Examples
Run this code

     data("ChinaIncome")
     plot(ChinaIncome)

