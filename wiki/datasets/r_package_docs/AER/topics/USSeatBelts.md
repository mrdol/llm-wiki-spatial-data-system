Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

USSeatBelts: Effects of Mandatory Seat Belt Laws in the US

Effects of Mandatory Seat Belt Laws in the US

Description

     Balanced panel data for the years 1983-1997 from 50 US States,
     plus the District of Columbia, for assessing traffic fatalities
     and seat belt usage.

Usage

     data("USSeatBelts")

Format

     A data frame containing 765 observations on 12 variables.

     state factor indicating US state (abbreviation).

     year factor indicating year.

     miles millions of traffic miles per year.

     fatalities number of fatalities per million of traffic miles
          (absolute frequencies of fatalities = ‘fatalities’ times
          ‘miles’).

     seatbelt seat belt usage rate, as self-reported by state
          population surveyed.

     speed65 factor. Is there a 65 mile per hour speed limit?

     speed70 factor. Is there a 70 (or higher) mile per hour speed
          limit?

     drinkage factor. Is there a minimum drinking age of 21 years?

     alcohol factor. Is there a maximum of 0.08 blood alcohol content?

     income median per capita income (in current US dollar).

     age mean age.

     enforce factor indicating seat belt law enforcement (‘"no"’,
          ‘"primary"’, ‘"secondary"’).

Details

     Some data series from Cohen and Einav (2003) have not been
     included in the data frame.

Source

     Online complements to Stock and Watson (2007).

References

     Cohen, A., and Einav, L. (2003). The Effects of Mandatory Seat
     Belt Laws on Driving Behavior and Traffic Fatalities. _The Review
     of Economics and Statistics_, *85*, 828-843

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

state: factor ; missing=0 ; examples=AK

year: factor ; missing=0 ; examples=1983, 1984, 1985

miles: numeric ; missing=0 ; examples=3358, 3589, 3840

fatalities: numeric ; missing=0 ; examples=0.0446694456040859, 0.0373363047838211, 0.0330729149281979

seatbelt: numeric ; missing=209 ; examples=0.449999988079071, 0.660000026226044

speed65: factor ; missing=0 ; examples=no

speed70: factor ; missing=0 ; examples=no

drinkage: factor ; missing=0 ; examples=yes

alcohol: factor ; missing=0 ; examples=no

income: numeric ; missing=0 ; examples=17973, 18093, 18925

age: numeric ; missing=0 ; examples=28.2349662780762, 28.343542098999, 28.3728160858154

enforce: factor ; missing=0 ; examples=no

Examples
Run this code

     data("USSeatBelts")
     summary(USSeatBelts)

     library("lattice")
     xyplot(fatalities ~ as.numeric(as.character(year)) | state, data = USSeatBelts, type = "l")

