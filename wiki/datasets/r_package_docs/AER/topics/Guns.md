Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

More Guns, Less Crime?

Description

     Guns is a balanced panel of data on 50 US states, plus the
     District of Columbia (for a total of 51 states), by year for
     1977-1999.

Usage

     data("Guns")

Format

     A data frame containing 1,173 observations on 13 variables.

     state factor indicating state.

     year factor indicating year.

     violent violent crime rate (incidents per 100,000 members of the
          population).

     murder murder rate (incidents per 100,000).

     robbery robbery rate (incidents per 100,000).

     prisoners incarceration rate in the state in the previous year
          (sentenced prisoners per 100,000 residents; value for the
          previous year).

     afam percent of state population that is African-American, ages 10
          to 64.

     cauc percent of state population that is Caucasian, ages 10 to 64.

     male percent of state population that is male, ages 10 to 29.

     population state population, in millions of people.

     income real per capita personal income in the state (US dollars).

     density population per square mile of land area, divided by 1,000.

     law factor. Does the state have a shall carry law in effect in
          that year?

Details

     Each observation is a given state in a given year.  There are a
     total of 51 states times 23 years = 1,173 observations.

Source

     Online complements to Stock and Watson (2007).

References

     Ayres, I., and Donohue, J.J. (2003). Shooting Down the ‘More Guns
     Less Crime’ Hypothesis. _Stanford Law Review_, *55*, 1193-1312.

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

year: factor ; missing=0 ; examples=1977, 1978, 1979

violent: numeric ; missing=0 ; examples=414.4, 419.1, 413.3

murder: numeric ; missing=0 ; examples=14.2, 13.3, 13.2

robbery: numeric ; missing=0 ; examples=96.8, 99.1, 109.5

prisoners: integer ; missing=0 ; examples=83, 94, 144

afam: numeric ; missing=0 ; examples=8.384873, 8.352101, 8.329575

cauc: numeric ; missing=0 ; examples=55.12291, 55.14367, 55.13586

male: numeric ; missing=0 ; examples=18.17441, 17.99408, 17.83934

population: numeric ; missing=0 ; examples=3.780403, 3.831838, 3.866248

income: numeric ; missing=0 ; examples=9563.148, 9932, 9877.028

density: numeric ; missing=0 ; examples=0.0745524, 0.0755667, 0.0762453

state: factor ; missing=0 ; examples=Alabama

law: factor ; missing=0 ; examples=no

Examples
Run this code

     ## data
     data("Guns")

     ## visualization
     library("lattice")
     xyplot(log(violent) ~ as.numeric(as.character(year)) | state, data = Guns, type = "l")

     ## Stock & Watson (2007), Empirical Exercise 10.1, pp. 376--377
     fm1 <- lm(log(violent) ~ law, data = Guns)
     coeftest(fm1, vcov = sandwich)

     fm2 <- lm(log(violent) ~ law + prisoners + density + income +
       population + afam + cauc + male, data = Guns)
     coeftest(fm2, vcov = sandwich)

     fm3 <- lm(log(violent) ~ law + prisoners + density + income +
       population + afam + cauc + male + state, data = Guns)
     printCoefmat(coeftest(fm3, vcov = sandwich)[1:9,])

     fm4 <- lm(log(violent) ~ law + prisoners + density + income +
       population + afam + cauc + male + state + year, data = Guns)
     printCoefmat(coeftest(fm4, vcov = sandwich)[1:9,])

