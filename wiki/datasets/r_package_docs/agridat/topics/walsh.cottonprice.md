Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

walsh.cottonprice: Acres and price of cotton 1910-1943

Acres and price of cotton 1910-1943

Description

     Acres and price of cotton 1910-1943

Format

     A data frame with 34 observations on the following 9 variables.

     ‘year’ year, numeric 1910-1943

     ‘acres’ acres of cototn (1000s)

     ‘cotton’ price per pound (cents) in previous year

     ‘cottonseed’ price per ton (dollars) in previous year

     ‘combined’ cotton price/pound + 1.857 x cottonseed price/pound
          (cents)

     ‘index’ price index, 1911-1914=100

     ‘adjcotton’ adjusted cotton price per pound (cents) in previous
          year

     ‘adjcottonseed’ adjusted cottonseed price per ton (dollars) in
          previous year

     ‘adjcombined’ adjusted combined price/pound (cents)

Details

     The 'index' is a price index for all farm commodities.

Source

     R.M. Walsh (1944).  Response to Price in Production of Cotton and
     Cottonseed, _Journal of Farm Economics_, 26, 359-372.
     https://doi.org/10.2307/1232237


Variables detected from installed object

year: integer ; missing=0 ; examples=1910, 1911, 1912

acres: integer ; missing=0 ; examples=32480, 35634, 33199

cotton: numeric ; missing=0 ; examples=13.52, 13.96, 9.65

cottonseed: numeric ; missing=0 ; examples=24.15, 25.99, 17.15

combined: numeric ; missing=0 ; examples=15.76, 16.37, 11.24

index: integer ; missing=0 ; examples=98, 100

adjcotton: numeric ; missing=0 ; examples=13.8, 13.96, 9.65

adjcottonseed: numeric ; missing=0 ; examples=24.64, 25.99, 17.15

adjcombined: numeric ; missing=0 ; examples=16.08, 16.37, 11.24

Examples
Run this code

     ## Not run:

     library(agridat)

     data(walsh.cottonprice)
     dat <- walsh.cottonprice

     dat <- transform(dat, acres=acres/1000) # convert to million acres

     percentchg <- function(x){ # percent change from previous to current
       ix <- 2:(nrow(dat))
       c(NA, (x[ix]-x[ix-1])/x[ix-1])
     }

     # Compare percent change in acres with percent change in previous price
     # using constant dollars
     dat <- transform(dat, chga = percentchg(acres), chgp = percentchg(adjcombined))

     with(dat, cor(chga, chgp, use='pair')) # .501 correlation
     libs(lattice)
     xyplot(chga~chgp, dat, type=c('p','r'),
            main="walsh.cottonprice",
            xlab="Percent change in previous price", ylab="Percent change in acres")
     ## End(Not run)

