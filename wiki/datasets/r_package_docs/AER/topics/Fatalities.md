Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

US Traffic Fatalities

Description

     US traffic fatalities panel data for the “lower 48” US states
     (i.e., excluding Alaska and Hawaii), annually for 1982 through
     1988.

Usage

     data("Fatalities")

Format

     A data frame containing 336 observations on 34 variables.

     state factor indicating state.

     year factor indicating year.

     spirits numeric. Spirits consumption.

     unemp numeric. Unemployment rate.

     income numeric. Per capita personal income in 1987 dollars.

     emppop numeric. Employment/population ratio.

     beertax numeric. Tax on case of beer.

     baptist numeric. Percent of southern baptist.

     mormon numeric. Percent of mormon.

     drinkage numeric. Minimum legal drinking age.

     dry numeric. Percent residing in “dry” countries.

     youngdrivers numeric. Percent of drivers aged 15-24.

     miles numeric. Average miles per driver.

     breath factor. Preliminary breath test law?

     jail factor. Mandatory jail sentence?

     service factor. Mandatory community service?

     fatal numeric. Number of vehicle fatalities.

     nfatal numeric. Number of night-time vehicle fatalities.

     sfatal numeric. Number of single vehicle fatalities.

     fatal1517 numeric. Number of vehicle fatalities, 15-17 year olds.

     nfatal1517 numeric. Number of night-time vehicle fatalities, 15-17
          year olds.

     fatal1820 numeric. Number of vehicle fatalities, 18-20 year olds.

     nfatal1820 numeric. Number of night-time vehicle fatalities, 18-20
          year olds.

     fatal2124 numeric. Number of vehicle fatalities, 21-24 year olds.

     nfatal2124 numeric. Number of night-time vehicle fatalities, 21-24
          year olds.

     afatal numeric. Number of alcohol-involved vehicle fatalities.

     pop numeric. Population.

     pop1517 numeric. Population, 15-17 year olds.

     pop1820 numeric. Population, 18-20 year olds.

     pop2124 numeric. Population, 21-24 year olds.

     milestot numeric. Total vehicle miles (millions).

     unempus numeric. US unemployment rate.

     emppopus numeric. US employment/population ratio.

     gsp numeric. GSP rate of change.

Details

     Traffic fatalities are from the US Department of Transportation
     Fatal Accident Reporting System.  The beer tax is the tax on a
     case of beer, which is an available measure of state alcohol taxes
     more generally. The drinking age variable is a factor indicating
     whether the legal drinking age is 18, 19, or 20.  The two binary
     punishment variables describe the state's minimum sentencing
     requirements for an initial drunk driving conviction.

     Total vehicle miles traveled annually by state was obtained from
     the Department of Transportation. Personal income was obtained
     from the US Bureau of Economic Analysis, and the unemployment rate
     was obtained from the US Bureau of Labor Statistics.

Source

     Online complements to Stock and Watson (2007).

References

     Ruhm, C. J. (1996). Alcohol Policies and Highway Vehicle
     Fatalities.  _Journal of Health Economics_, *15*, 435-454.

     Stock, J. H. and Watson, M. W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

state: factor ; missing=0 ; examples=al

year: factor ; missing=0 ; examples=1982, 1983, 1984

spirits: numeric ; missing=0 ; examples=1.37000000476837, 1.36000001430511, 1.32000005245209

unemp: numeric ; missing=0 ; examples=14.3999996185303, 13.6999998092651, 11.1000003814697

income: numeric ; missing=0 ; examples=10544.15234375, 10732.7978515625, 11108.791015625

emppop: numeric ; missing=0 ; examples=50.6920394897461, 52.147029876709, 54.1680870056152

beertax: numeric ; missing=0 ; examples=1.53937947750092, 1.78899073600769, 1.71428561210632

baptist: numeric ; missing=0 ; examples=30.3556995391846, 30.3335990905762, 30.3115005493164

mormon: numeric ; missing=0 ; examples=0.328289985656738, 0.343409985303879, 0.359239995479584

drinkage: numeric ; missing=0 ; examples=19

dry: numeric ; missing=0 ; examples=25.0062999725342, 22.9941997528076, 24.0426006317139

youngdrivers: numeric ; missing=0 ; examples=0.211572006344795, 0.21076799929142, 0.211484000086784

miles: numeric ; missing=0 ; examples=7233.88720703125, 7836.34765625, 8262.990234375

breath: factor ; missing=0 ; examples=no

jail: factor ; missing=1 ; examples=no

service: factor ; missing=1 ; examples=no

fatal: integer ; missing=0 ; examples=839, 930, 932

nfatal: integer ; missing=0 ; examples=146, 154, 165

sfatal: integer ; missing=0 ; examples=99, 98, 94

fatal1517: integer ; missing=0 ; examples=53, 71, 49

nfatal1517: integer ; missing=0 ; examples=9, 8, 7

fatal1820: integer ; missing=0 ; examples=99, 108, 103

nfatal1820: integer ; missing=0 ; examples=34, 26, 25

fatal2124: integer ; missing=0 ; examples=120, 124, 118

nfatal2124: integer ; missing=0 ; examples=32, 35, 34

afatal: numeric ; missing=0 ; examples=309.43798828125, 341.834014892578, 304.872009277344

pop: numeric ; missing=0 ; examples=3942002.25, 3960008, 3988991.75

pop1517: numeric ; missing=0 ; examples=208999.59375, 202000.078125, 196999.96875

pop1820: numeric ; missing=0 ; examples=221553.4375, 219125.46875, 216724.09375

pop2124: numeric ; missing=0 ; examples=290000.0625, 290000.15625, 288000.15625

milestot: numeric ; missing=0 ; examples=28516, 31032, 32961

unempus: numeric ; missing=0 ; examples=9.69999980926514, 9.60000038146973, 7.5

emppopus: numeric ; missing=0 ; examples=57.7999992370605, 57.9000015258789, 59.5000038146973

gsp: numeric ; missing=0 ; examples=-0.0221247598528862, 0.046558253467083, 0.062797836959362

Examples
Run this code

     ## data from Stock and Watson (2007)
     data("Fatalities", package = "AER")
     ## add fatality rate (number of traffic deaths
     ## per 10,000 people living in that state in that year)
     Fatalities$frate <- with(Fatalities, fatal/pop * 10000)
     ## add discretized version of minimum legal drinking age
     Fatalities$drinkagec <- cut(Fatalities$drinkage,
       breaks = 18:22, include.lowest = TRUE, right = FALSE)
     Fatalities$drinkagec <- relevel(Fatalities$drinkagec, ref = 4)
     ## any punishment?
     Fatalities$punish <- with(Fatalities,
       factor(jail == "yes" | service == "yes", labels = c("no", "yes")))
     ## plm package
     library("plm")

     ## for comparability with Stata we use HC1 below
     ## p. 351, Eq. (10.2)
     f1982 <- subset(Fatalities, year == "1982")
     fm_1982 <- lm(frate ~ beertax, data = f1982)
     coeftest(fm_1982, vcov = vcovHC(fm_1982, type = "HC1"))

     ## p. 353, Eq. (10.3)
     f1988 <- subset(Fatalities, year == "1988")
     fm_1988 <- lm(frate ~ beertax, data = f1988)
     coeftest(fm_1988, vcov = vcovHC(fm_1988, type = "HC1"))

     ## pp. 355, Eq. (10.8)
     fm_diff <- lm(I(f1988$frate - f1982$frate) ~ I(f1988$beertax - f1982$beertax))
     coeftest(fm_diff, vcov = vcovHC(fm_diff, type = "HC1"))

     ## pp. 360, Eq. (10.15)
     ##   (1) via formula
     fm_sfe <- lm(frate ~ beertax + state - 1, data = Fatalities)
     ##   (2) by hand
     fat <- with(Fatalities,
       data.frame(frates = frate - ave(frate, state),
       beertaxs = beertax - ave(beertax, state)))
     fm_sfe2 <- lm(frates ~ beertaxs - 1, data = fat)
     ##   (3) via plm()
     fm_sfe3 <- plm(frate ~ beertax, data = Fatalities,
       index = c("state", "year"), model = "within")

     coeftest(fm_sfe, vcov = vcovHC(fm_sfe, type = "HC1"))[1,]
     ## uses different df in sd and p-value
     coeftest(fm_sfe2, vcov = vcovHC(fm_sfe2, type = "HC1"))[1,]
     ## uses different df in p-value
     coeftest(fm_sfe3, vcov = vcovHC(fm_sfe3, type = "HC1", method = "white1"))[1,]

     ## pp. 363, Eq. (10.21)
     ## via lm()
     fm_stfe <- lm(frate ~ beertax + state + year - 1, data = Fatalities)
     coeftest(fm_stfe, vcov = vcovHC(fm_stfe, type = "HC1"))[1,]
     ## via plm()
     fm_stfe2 <- plm(frate ~ beertax, data = Fatalities,
       index = c("state", "year"), model = "within", effect = "twoways")
     coeftest(fm_stfe2, vcov = vcovHC) ## different

     ## p. 368, Table 10.1, numbers refer to cols.
     fm1 <- plm(frate ~ beertax, data = Fatalities, index = c("state", "year"), model = "pooling")
     fm2 <- plm(frate ~ beertax, data = Fatalities, index = c("state", "year"), model = "within")
     fm3 <- plm(frate ~ beertax, data = Fatalities, index = c("state", "year"), model = "within",
       effect = "twoways")
     fm4 <- plm(frate ~ beertax + drinkagec + jail + service + miles + unemp + log(income),
       data = Fatalities, index = c("state", "year"), model = "within", effect = "twoways")
     fm5 <- plm(frate ~ beertax + drinkagec + jail + service + miles,
       data = Fatalities, index = c("state", "year"), model = "within", effect = "twoways")
     fm6 <- plm(frate ~ beertax + drinkage + punish + miles + unemp + log(income),
       data = Fatalities, index = c("state", "year"), model = "within", effect = "twoways")
     fm7 <- plm(frate ~ beertax + drinkagec + jail + service + miles + unemp + log(income),
       data = Fatalities, index = c("state", "year"), model = "within", effect = "twoways")
     ## summaries not too close, s.e.s generally too small
     coeftest(fm1, vcov = vcovHC)
     coeftest(fm2, vcov = vcovHC)
     coeftest(fm3, vcov = vcovHC)
     coeftest(fm4, vcov = vcovHC)
     coeftest(fm5, vcov = vcovHC)
     coeftest(fm6, vcov = vcovHC)
     coeftest(fm7, vcov = vcovHC)

     ## TODO: Testing exclusion restrictions

