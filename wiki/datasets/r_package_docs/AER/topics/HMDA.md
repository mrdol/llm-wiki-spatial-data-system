Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

HMDA: Home Mortgage Disclosure Act Data

Home Mortgage Disclosure Act Data

Description

     Cross-section data on the Home Mortgage Disclosure Act (HMDA).

Usage

     data("HMDA")

Format

     A data frame containing 2,380 observations on 14 variables.

     deny Factor. Was the mortgage denied?

     pirat Payments to income ratio.

     hirat Housing expense to income ratio.

     lvrat Loan to value ratio.

     chist Factor. Credit history: consumer payments.

     mhist Factor. Credit history: mortgage payments.

     phist Factor. Public bad credit record?

     unemp 1989 Massachusetts unemployment rate in applicant's
          industry.

     selfemp Factor. Is the individual self-employed?

     insurance Factor. Was the individual denied mortgage insurance?

     condomin Factor. Is the unit a condominium?

     afam Factor. Is the individual African-American?

     single Factor. Is the individual single?

     hschool Factor. Does the individual have a high-school diploma?

Details

     Only includes variables used by Stock and Watson (2007), some of
     which had to be generated from the raw data.

Source

     Online complements to Stock and Watson (2007).

References

     Munnell, A. H., Tootell, G. M. B., Browne, L. E. and McEneaney, J.
     (1996).  Mortgage Lending in Boston: Interpreting HMDA Data.
     _American Economic Review_, *86*, 25-53.

     Stock, J. H. and Watson, M. W. (2007). _Introduction to
     Econometrics_, 2nd ed. Boston: Addison Wesley.

See Also

     ‘StockWatson2007’


Variables detected from installed object

deny: factor ; missing=0 ; examples=no

pirat: numeric ; missing=0 ; examples=0.221000003814697, 0.265, 0.372000007629395

hirat: numeric ; missing=0 ; examples=0.221000003814697, 0.265, 0.247999992370605

lvrat: numeric ; missing=0 ; examples=0.8, 0.921875, 0.920398009950249

chist: factor ; missing=0 ; examples=5, 2, 1

mhist: factor ; missing=0 ; examples=2

phist: factor ; missing=0 ; examples=no

unemp: numeric ; missing=0 ; examples=3.90000009536743, 3.20000004768372

selfemp: factor ; missing=0 ; examples=no

insurance: factor ; missing=0 ; examples=no

condomin: factor ; missing=0 ; examples=no

afam: factor ; missing=0 ; examples=no

single: factor ; missing=0 ; examples=no, yes

hschool: factor ; missing=0 ; examples=yes

Examples
Run this code

     data("HMDA")

     ## Stock and Watson (2007)
     ## Equations 11.1, 11.3, 11.7, 11.8 and 11.10, pp. 387--395
     fm1 <- lm(I(as.numeric(deny) - 1) ~ pirat, data = HMDA)
     fm2 <- lm(I(as.numeric(deny) - 1) ~ pirat + afam, data = HMDA)
     fm3 <- glm(deny ~ pirat, family = binomial(link = "probit"), data = HMDA)
     fm4 <- glm(deny ~ pirat + afam, family = binomial(link = "probit"), data = HMDA)
     fm5 <- glm(deny ~ pirat + afam, family = binomial(link = "logit"), data = HMDA)

     ## More examples can be found in:
     ## help("StockWatson2007")

