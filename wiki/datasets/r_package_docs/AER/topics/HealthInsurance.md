Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

HealthInsurance: Medical Expenditure Panel Survey Data

Medical Expenditure Panel Survey Data

Description

     Cross-section data originating from the Medical Expenditure Panel
     Survey survey conducted in 1996.

Usage

     data("HealthInsurance")

Format

     A data frame containing 8,802 observations on 11 variables.

     health factor. Is the self-reported health status “healthy”?.

     age age in years.

     limit factor. Is there any limitation?

     gender factor indicating gender.

     insurance factor. Does the individual have a health insurance?

     married factor. Is the individual married?

     selfemp factor. Is the individual self-employed?

     family family size.

     region factor indicating region.

     ethnicity factor indicating ethnicity: African-American,
          Caucasian, other.

     education factor indicating highest degree attained: no degree,
          GED (high school equivalent), high school, bachelor, master,
          PhD, other.

Details

     This is a subset of the data used in Perry and Rosen (2004).

Source

     Online complements to Stock and Watson (2007).

References

     Perry, C. and Rosen, H.S. (2004). “The Self-Employed are Less
     Likely than Wage-Earners to Have Health Insurance. So What?” in
     Holtz-Eakin, D. and Rosen, H.S. (eds.), _Entrepeneurship and
     Public Policy_, MIT Press.

     Stock, J.H. and Watson, M.W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

health: factor ; missing=0 ; examples=yes

age: numeric ; missing=0 ; examples=31, 54

limit: factor ; missing=0 ; examples=no

gender: factor ; missing=0 ; examples=male, female

insurance: factor ; missing=0 ; examples=yes

married: factor ; missing=0 ; examples=yes

selfemp: factor ; missing=0 ; examples=yes, no

family: numeric ; missing=0 ; examples=4, 5

region: factor ; missing=0 ; examples=south, west

ethnicity: factor ; missing=0 ; examples=cauc

education: factor ; missing=0 ; examples=bachelor, highschool, ged

Examples
Run this code

     data("HealthInsurance")
     summary(HealthInsurance)
     prop.table(xtabs(~ selfemp + insurance, data = HealthInsurance), 1)

