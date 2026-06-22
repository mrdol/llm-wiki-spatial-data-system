Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

MarkDollar: DEM/USD Exchange Rate Returns

DEM/USD Exchange Rate Returns

Description

     A time series of intra-day percentage returns of Deutsche mark/US
     dollar (DEM/USD) exchange rates, consisting of two observations
     per day from 1992-10-01 through 1993-09-29.

Usage

     data("MarkDollar")

Format

     A univariate time series of 518 returns (exact dates unknown) for
     the DEM/USD exchange rate.

Source

     Journal of Business & Economic Statistics Data Archive.

     http://www.amstat.org/publications/jbes/upload/index.cfm?fuseaction=ViewArticles&pub=JBES&issue=96-2-APR

References

     Bollerslev, T., and Ghysels, E. (1996). Periodic Autoregressive
     Conditional Heteroskedasticity.  _Journal of Business & Economic
     Statistics_, *14*, 139-151.

See Also

     ‘MarkPound’

Examples
Run this code

     library("tseries")
     data("MarkDollar")

     ## GARCH(1,1)
     fm <- garch(MarkDollar, grad = "numerical")
     summary(fm)
     logLik(fm)

