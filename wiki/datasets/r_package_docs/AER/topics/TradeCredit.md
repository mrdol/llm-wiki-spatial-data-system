Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

TradeCredit: Trade Credit and the Money Market

Trade Credit and the Money Market

Description

     Macroeconomic time series data from 1946 to 1966 on trade credit
     and the money market.

Usage

     data("TradeCredit")

Format

     An annual multiple time series from 1946 to 1966 on 7 variables.

     trade Nominal total trade money.

     reserve Nominal effective reserve money.

     gnp GNP in current dollars.

     utilization Degree of market utilization.

     interest Short-term rate of interest.

     size Mean real size of the representative economic unit (1939 =
          100).

     price GNP price deflator (1958 = 100).

Source

     The data are from Baltagi (2002).

References

     Baltagi, B.H. (2002). _Econometrics_, 3rd ed. Berlin, Springer.

     Laffer, A.B. (1970). Trade Credit and the Money Market. _Journal
     of Political Economy_, *78*, 239-267.

See Also

     ‘Baltagi2002’


Variables detected from installed object

trade: numeric ; missing=0 ; examples=140.1, 153.5, 159.1

reserve: numeric ; missing=0 ; examples=16.083, 16.7, 16.505

gnp: numeric ; missing=0 ; examples=208.5, 231.3, 257.6

utilization: numeric ; missing=0 ; examples=3.0703, 3.2561, 3.1687

interest: numeric ; missing=0 ; examples=0.61, 0.87, 1.11

size: numeric ; missing=0 ; examples=114.95, 127.72, 133.89

price: numeric ; missing=0 ; examples=0.667, 0.746, 0.796

Examples
Run this code

     data("TradeCredit")
     plot(TradeCredit)

