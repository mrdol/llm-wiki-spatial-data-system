Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

motors: Accelerated Life Testing of Motorettes

Accelerated Life Testing of Motorettes

Description

     The ‘motors’ data frame has 40 rows and 3 columns.  It describes
     an accelerated life test at each of four temperatures of 10
     motorettes, and has rather discrete times.

Usage

     motors

Format

     This data frame contains the following columns:

     ‘temp’ the temperature (degrees C) of the test.

     ‘time’ the time in hours to failure or censoring at 8064 hours (=
          336 days).

     ‘cens’ an indicator variable for death.

Source

     Kalbfleisch, J. D. and Prentice, R. L. (1980) _The Statistical
     Analysis of Failure Time Data._ New York: Wiley.

     taken from

     Nelson, W. D. and Hahn, G. J. (1972) Linear regression of a
     regression relationship from censored data.  Part 1 - simple
     methods and their application.  _Technometrics_, *14*, 247-276.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

temp: integer ; missing=0 ; examples=150

time: integer ; missing=0 ; examples=8064

cens: integer ; missing=0 ; examples=0

Examples
Run this code

     library(survival)
     plot(survfit(Surv(time, cens) ~ factor(temp), motors), conf.int = FALSE)
     # fit Weibull model
     motor.wei <- survreg(Surv(time, cens) ~ temp, motors)
     ## IGNORE_RDIFF_BEGIN
     summary(motor.wei)
     ## IGNORE_RDIFF_END
     # and predict at 130C
     unlist(predict(motor.wei, data.frame(temp=130), se.fit = TRUE))

     motor.cox <- coxph(Surv(time, cens) ~ temp, motors)
     summary(motor.cox)
     # predict at temperature 200
     plot(survfit(motor.cox, newdata = data.frame(temp=200),
          conf.type = "log-log"))
     summary( survfit(motor.cox, newdata = data.frame(temp=130)) )

