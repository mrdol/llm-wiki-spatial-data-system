Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

ConsumerGood: Properties of a Fast-Moving Consumer Good

Properties of a Fast-Moving Consumer Good

Description

     Time series of distribution, market share and price of a
     fast-moving consumer good.

Usage

     data("ConsumerGood")

Format

     A weekly multiple time series from 1989(11) to 1991(9) with 3
     variables.

     distribution Distribution.

     share Market share.

     price Price.

Source

     Online complements to Franses (1998).

References

     Franses, P.H. (1998). _Time Series Models for Business and
     Economic Forecasting_. Cambridge, UK: Cambridge University Press.

See Also

     ‘Franses1998’


Variables detected from installed object

distribution: numeric ; missing=0 ; examples=0.905, 0.9, 0.988

share: numeric ; missing=0 ; examples=2.740407, 3.00839, 2.203097

price: numeric ; missing=0 ; examples=105.9539, 106.2491, 107.1034

Examples
Run this code

     data("ConsumerGood")
     plot(ConsumerGood)

