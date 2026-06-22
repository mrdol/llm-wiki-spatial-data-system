Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

DutchAdvert: TV and Radio Advertising Expenditures Data

TV and Radio Advertising Expenditures Data

Description

     Time series of television and radio advertising expenditures (in
     real terms) in The Netherlands.

Usage

     data("DutchAdvert")

Format

     A four-weekly multiple time series from 1978(1) to 1994(13) with 2
     variables.

     tv Television advertising expenditures.

     radio Radio advertising expenditures.

Source

     Originally available as an online supplement to Franses (1998).
     Now available via online complements to Franses, van Dijk and
     Opschoor (2014).

     <https://www.cambridge.org/us/academic/subjects/economics/econometrics-statistics-and-mathematical-economics/time-series-models-business-and-economic-forecasting-2nd-edition>

References

     Franses, P.H. (1998). _Time Series Models for Business and
     Economic Forecasting_. Cambridge, UK: Cambridge University Press.

     Franses, P.H., van Dijk, D. and Opschoor, A. (2014). _Time Series
     Models for Business and Economic Forecasting_, 2nd ed. Cambridge,
     UK: Cambridge University Press.

See Also

     ‘Franses1998’


Variables detected from installed object

tv: numeric ; missing=0 ; examples=14000.00585, 13304.5332, 13342.77929

radio: numeric ; missing=0 ; examples=1954, 1952.711914, 1859.740112

Examples
Run this code

     data("DutchAdvert")
     plot(DutchAdvert)

     ## EACF tables (Franses 1998, Sec. 5.1, p. 99)
     ctrafo <- function(x) residuals(lm(x ~ factor(cycle(x))))
     ddiff <- function(x) diff(diff(x, frequency(x)), 1)
     eacf <- function(y, lag = 12) {
       stopifnot(all(lag > 0))
       if(length(lag) < 2) lag <- 1:lag
       rval <- sapply(
         list(y = y, dy = diff(y), cdy = ctrafo(diff(y)),
              Dy = diff(y, frequency(y)), dDy = ddiff(y)),
         function(x) acf(x, plot = FALSE, lag.max = max(lag))$acf[lag + 1])
       rownames(rval) <- lag
       return(rval)
     }

     ## Franses (1998, p. 103), Table 5.4
     round(eacf(log(DutchAdvert[,"tv"]), lag = c(1:19, 26, 39)), digits = 3)

