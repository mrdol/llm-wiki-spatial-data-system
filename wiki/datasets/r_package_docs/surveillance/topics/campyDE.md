Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

campyDE: Campylobacteriosis and Absolute Humidity in Germany 2002-2011

Campylobacteriosis and Absolute Humidity in Germany 2002-2011

Description

     Weekly number of reported campylobacteriosis cases in Germany,
     2002-2011, together with the corresponding absolute humidity (in
     g/m^3) that week. The absolute humidity was computed according to
     the procedure by Dengler (1997) using the means of representative
     weather station data from the German Climate service.

Usage

     data(campyDE)

Format

     A ‘data.frame’ containing the following columns

     ‘date’ ‘Date’ instance containing the Monday of the reporting
          week.

     ‘case’ Number of reported cases that week.

     ‘state’ Boolean indicating whether there is external knowledge
          about an outbreak that week

     ‘hum’ Mean absolute humidity (in g/m^3) of that week as measured
          by a single representative weather station.

     ‘l1.hum’-‘l5.hum’ Lagged version (lagged by 1-5) of the ‘hum’
          covariate.

     newyears Boolean indicating whether the reporting week corresponds
          to the first two weeks of the year (TRUE) or not (FALSE).
          Note: The first week of a year is here defined as the first
          reporting week, which has its corresponding Monday within new
          year.

     christmas Boolean indicating whether the reporting week
          corresponds to the last two weeks of the year (TRUE) or not
          (FALSE). Note: This are the first two weeks before the
          ‘newyears’ weeks.

     O104period Boolean indicating whether the reporting week
          corresponds to the W21-W30 period of increased
          gastroenteritis awareness during the O104:H4 STEC outbreak.

Source

     The data on campylobacteriosis cases have been queried from the
     Survstat@RKI database of the German Robert Koch Institute
     (<https://survstat.rki.de/>).

     Data for the computation of absolute humidity were obtained from
     the German Climate Service (Deutscher Wetterdienst), Climate data
     of Germany, available at <https://www.dwd.de>.

     A complete data description and an analysis of the data can be
     found in Manitz and Höhle (2013).

References

     Manitz, J. and Höhle, M. (2013): Bayesian outbreak detection
     algorithm for monitoring reported cases of campylobacteriosis in
     Germany.  Biometrical Journal, 55(4), 509-526.


Variables detected from installed object

date: Date ; missing=0 ; examples=2001-12-31, 2002-01-07, 2002-01-14

case: integer ; missing=0 ; examples=514, 913, 1023

state: numeric ; missing=0 ; examples=0

hum: numeric ; missing=1 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

l1.hum: numeric ; missing=1 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

l2.hum: numeric ; missing=2 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

l3.hum: numeric ; missing=3 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

l4.hum: numeric ; missing=4 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

l5.hum: numeric ; missing=5 ; examples=3.66162267554153, 5.22741825145503, 5.69028577113823

newyears: numeric ; missing=0 ; examples=0, 1

christmas: numeric ; missing=0 ; examples=1, 0

O104period: logical ; missing=0 ; examples=FALSE

Examples
Run this code

     # Load the data
     data("campyDE")

     # O104 period is W21-W30 in 2011
     stopifnot(all(campyDE$O104period == (
       (campyDE$date >= as.Date("2011-05-23")) &
       (campyDE$date < as.Date("2011-07-31"))
     )))

     # Make an sts object from the data.frame
     cam.sts <- sts(epoch=campyDE$date, observed=campyDE$case, state=campyDE$state)

     # Plot the result
     plot(cam.sts)

