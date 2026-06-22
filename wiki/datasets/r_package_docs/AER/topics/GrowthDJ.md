Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

GrowthDJ: Determinants of Economic Growth

Determinants of Economic Growth

Description

     Growth regression data as provided by Durlauf & Johnson (1995).

Usage

     data("GrowthDJ")

Format

     A data frame containing 121 observations on 10 variables.

     oil factor. Is the country an oil-producing country?

     inter factor. Does the country have better quality data?

     oecd factor. Is the country a member of the OECD?

     gdp60 Per capita GDP in 1960.

     gdp85 Per capita GDP in 1985.

     gdpgrowth Average growth rate of per capita GDP from 1960 to 1985
          (in percent).

     popgrowth Average growth rate of working-age population 1960 to
          1985 (in percent).

     invest Average ratio of investment (including Government
          Investment) to GDP from 1960 to 1985 (in percent).

     school Average fraction of working-age population enrolled in
          secondary school from 1960 to 1985 (in percent).

     literacy60 Fraction of the population over 15 years old that is
          able to read and write in 1960 (in percent).

Details

     The data are derived from the Penn World Table 4.0 and are given
     in Mankiw, Romer and Weil (1992), except ‘literacy60’ that is from
     the World Bank's World Development Report.

Source

     Journal of Applied Econometrics Data Archive.

     <http://qed.econ.queensu.ca/jae/1995-v10.4/durlauf-johnson/>

References

     Durlauf, S.N., and Johnson, P.A. (1995). Multiple Regimes and
     Cross-Country Growth Behavior. _Journal of Applied Econometrics_,
     *10*, 365-384.

     Koenker, R., and Zeileis, A. (2009). On Reproducible Econometric
     Research. _Journal of Applied Econometrics_, *24*(5), 833-847.

     Mankiw, N.G, Romer, D., and Weil, D.N. (1992). A Contribution to
     the Empirics of Economic Growth.  _Quarterly Journal of
     Economics_, *107*, 407-437.

     Masanjala, W.H., and Papageorgiou, C. (2004). The Solow Model with
     CES Technology: Nonlinearities and Parameter Heterogeneity.
     _Journal of Applied Econometrics_, *19*, 171-201.

See Also

     ‘OECDGrowth’, ‘GrowthSW’


Variables detected from installed object

oil: factor ; missing=0 ; examples=no

inter: factor ; missing=0 ; examples=yes, no

oecd: factor ; missing=0 ; examples=no

gdp60: numeric ; missing=5 ; examples=2485, 1588, 1116

gdp85: numeric ; missing=13 ; examples=4371, 1171, 1071

gdpgrowth: numeric ; missing=4 ; examples=4.8, 0.8, 2.2

popgrowth: numeric ; missing=14 ; examples=2.6, 2.1, 2.4

invest: numeric ; missing=0 ; examples=24.1, 5.8, 10.8

school: numeric ; missing=3 ; examples=4.5, 1.8

literacy60: numeric ; missing=18 ; examples=10, 5

Examples
Run this code

     ## data for non-oil-producing countries
     data("GrowthDJ")
     dj <- subset(GrowthDJ, oil == "no")
     ## Different scalings have been used by different authors,
     ## different types of standard errors, etc.,
     ## see Koenker & Zeileis (2009) for an overview

     ## Durlauf & Johnson (1995), Table II
     mrw_model <- I(log(gdp85) - log(gdp60)) ~ log(gdp60) +
       log(invest/100) + log(popgrowth/100 + 0.05) + log(school/100)
     dj_mrw <- lm(mrw_model, data = dj)
     coeftest(dj_mrw)

     dj_model <- I(log(gdp85) - log(gdp60)) ~ log(gdp60) +
       log(invest) + log(popgrowth/100 + 0.05) + log(school)
     dj_sub1 <- lm(dj_model, data = dj, subset = gdp60 < 1800 & literacy60 < 50)
     coeftest(dj_sub1, vcov = sandwich)

     dj_sub2 <- lm(dj_model, data = dj, subset = gdp60 >= 1800 & literacy60 >= 50)
     coeftest(dj_sub2, vcov = sandwich)

