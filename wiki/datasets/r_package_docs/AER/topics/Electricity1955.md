Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

Electricity1955: Cost Function of Electricity Producers (1955, Nerlove Data)

Cost Function of Electricity Producers (1955, Nerlove Data)

Description

     Cost function data for 145 (+14) US electricity producers in 1955.

Usage

     data("Electricity1955")

Format

     A data frame containing 159 observations on 8 variables.

     cost total cost.

     output total output.

     labor wage rate.

     laborshare cost share for labor.

     capital capital price index.

     capitalshare cost share for capital.

     fuel fuel price.

     fuelshare cost share for fuel.

Details

     The data contains several extra observations that are aggregates
     of commonly owned firms. Only the first 145 observations should be
     used for analysis.

Source

     Online complements to Greene (2003). Table F14.2.

     <https://pages.stern.nyu.edu/~wgreene/Text/tables/tablelist5.htm>

References

     Greene, W.H. (2003). _Econometric Analysis_, 5th edition. Upper
     Saddle River, NJ: Prentice Hall.

     Nerlove, M. (1963) “Returns to Scale in Electricity Supply.” In C.
     Christ (ed.), _Measurement in Economics: Studies in Mathematical
     Economics and Econometrics in Memory of Yehuda Grunfeld_. Stanford
     University Press, 1963.

See Also

     ‘Greene2003’, ‘Electricity1970’


Variables detected from installed object

cost: numeric ; missing=0 ; examples=0.082, 0.661, 0.99

output: numeric ; missing=0 ; examples=2, 3, 4

labor: numeric ; missing=0 ; examples=2.09, 2.05

laborshare: numeric ; missing=0 ; examples=0.3164, 0.2073, 0.2349

capital: numeric ; missing=0 ; examples=183, 174, 171

capitalshare: numeric ; missing=0 ; examples=0.4521, 0.6676, 0.5799

fuel: numeric ; missing=0 ; examples=17.9, 35.1

fuelshare: numeric ; missing=0 ; examples=0.2315, 0.1251, 0.1852

Examples
Run this code

     data("Electricity1955")
     Electricity <- Electricity1955[1:145,]

     ## Greene (2003)
     ## Example 7.3
     ## Cobb-Douglas cost function
     fm_all <- lm(log(cost/fuel) ~ log(output) + log(labor/fuel) + log(capital/fuel),
       data = Electricity)
     summary(fm_all)

     ## hypothesis of constant returns to scale
     linearHypothesis(fm_all, "log(output) = 1")

     ## Table 7.4
     ## log quadratic cost function
     fm_all2 <- lm(log(cost/fuel) ~ log(output) + I(log(output)^2) + log(labor/fuel) + log(capital/fuel),
       data = Electricity)
     summary(fm_all2)

     ## More examples can be found in:
     ## help("Greene2003")

