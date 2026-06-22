Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

GrowthSW: Determinants of Economic Growth

Determinants of Economic Growth

Description

     Data on average growth rates over 1960-1995 for 65 countries,
     along with variables that are potentially related to growth.

Usage

     data("GrowthSW")

Format

     A data frame containing 65 observations on 6 variables.

     growth average annual percentage growth of real GDP from 1960 to
          1995.

     rgdp60 value of GDP per capita in 1960, converted to 1960 US
          dollars.

     tradeshare average share of trade in the economy from 1960 to
          1995, measured as the sum of exports (X) plus imports (M),
          divided by GDP; that is, the average value of (X + M)/GDP
          from 1960 to 1995.

     education average number of years of schooling of adult residents
          in that country in 1960.

     revolutions average annual number of revolutions, insurrections
          (successful or not) and coup d'etats in that country from
          1960 to 1995.

     assassinations average annual number of political assassinations
          in that country from 1960 to 1995 (in per million
          population).

Source

     Online complements to Stock and Watson (2007).

References

     Beck, T., Levine, R., and Loayza, N. (2000). Finance and the
     Sources of Growth. _Journal of Financial Economics_, *58*,
     261-300.

     Stock, J. H. and Watson, M. W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’, ‘GrowthDJ’, ‘OECDGrowth’


Variables detected from installed object

growth: numeric ; missing=0 ; examples=1.915167927742, 0.617645084857941, 4.30475902557373

rgdp60: numeric ; missing=0 ; examples=765.999816894531, 4462.00146484375, 2953.99951171875

tradeshare: numeric ; missing=0 ; examples=0.140501976013184, 0.156622976064682, 0.157703220844269

education: numeric ; missing=0 ; examples=1.45000004768372, 4.98999977111816, 6.71000003814697

revolutions: numeric ; missing=0 ; examples=0.133333340287209, 0.933333337306976, 0

assassinations: numeric ; missing=0 ; examples=0.866666674613953, 1.93333327770233, 0.200000002980232

Examples
Run this code

     data("GrowthSW")
     summary(GrowthSW)

