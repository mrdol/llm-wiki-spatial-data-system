Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

ShipAccidents: Ship Accidents

Ship Accidents

Description

     Data on ship accidents.

Usage

     data("ShipAccidents")

Format

     A data frame containing 40 observations on 5 ship types in 4
     vintages and 2 service periods.

     type factor with levels ‘"A"’ to ‘"E"’ for the different ship
          types,

     construction factor with levels ‘"1960-64"’, ‘"1965-69"’,
          ‘"1970-74"’, ‘"1975-79"’ for the periods of construction,

     operation factor with levels ‘"1960-74"’, ‘"1975-79"’ for the
          periods of operation,

     service aggregate months of service,

     incidents number of damage incidents.

Details

     The data are from McCullagh and Nelder (1989, p. 205, Table 6.2)
     and were also used by Greene (2003, Ch. 21), see below.

     There are five ships (observations 7, 15, 23, 31, 39) with an
     operation period _before_ the construction period, hence the
     variables ‘service’ and ‘incidents’ are necessarily 0. An
     additional observation (34) has entries representing _accidentally
     empty cells_ (see McCullagh and Nelder, 1989, p. 205).

     It is a bit unclear what exactly the above means. In any case, the
     models are fit only to those observations with ‘service > 0’.

Source

     Online complements to Greene (2003).

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

     McCullagh, P. and Nelder, J.A. (1989). _Generalized Linear
     Models_, 2nd edition. London: Chapman & Hall.

See Also

     ‘Greene2003’


Variables detected from installed object

type: factor ; missing=0 ; examples=A

construction: factor ; missing=0 ; examples=1960-64, 1965-69

operation: factor ; missing=0 ; examples=1960-74, 1975-79

service: numeric ; missing=0 ; examples=127, 63, 1095

incidents: numeric ; missing=0 ; examples=0, 3

Examples
Run this code

     data("ShipAccidents")
     sa <- subset(ShipAccidents, service > 0)

     ## Greene (2003), Table 21.20
     ## (see also McCullagh and Nelder, 1989, Table 6.3)
     sa_full <- glm(incidents ~ type + construction + operation, family = poisson,
       data = sa, offset = log(service))
     summary(sa_full)

     sa_notype <- glm(incidents ~ construction + operation, family = poisson,
       data = sa, offset = log(service))
     summary(sa_notype)

     sa_noperiod <- glm(incidents ~ type + operation, family = poisson,
       data = sa, offset = log(service))
     summary(sa_noperiod)

     ## model comparison
     anova(sa_full, sa_notype, test = "Chisq")
     anova(sa_full, sa_noperiod, test = "Chisq")

     ## test for overdispersion
     dispersiontest(sa_full)
     dispersiontest(sa_full, trafo = 2)

