Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

Numbers of Car Insurance claims

Description

     The data given in data frame ‘Insurance’ consist of the numbers of
     policyholders of an insurance company who were exposed to risk,
     and the numbers of car insurance claims made by those
     policyholders in the third quarter of 1973.

Usage

     Insurance

Format

     This data frame contains the following columns:

     ‘District’ factor: district of residence of policyholder (1 to 4):
          4 is major cities.

     ‘Group’ an ordered factor: group of car with levels <1 litre,
          1-1.5 litre, 1.5-2 litre, >2 litre.

     ‘Age’ an ordered factor: the age of the insured in 4 groups
          labelled <25, 25-29, 30-35, >35.

     ‘Holders’ numbers of policyholders.

     ‘Claims’ numbers of claims

Source

     L. A. Baxter, S. M. Coutts and G. A. F. Ross (1980) Applications
     of linear models in motor insurance.  _Proceedings of the 21st
     International Congress of Actuaries, Zurich_ pp. 11-29.

     M. Aitkin, D. Anderson, B. Francis and J. Hinde (1989)
     _Statistical Modelling in GLIM._ Oxford University Press.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S-PLUS._ Fourth Edition. Springer.


Variables detected from installed object

District: factor ; missing=0 ; examples=1

Group: ordered/factor ; missing=0 ; examples=<1l

Age: ordered/factor ; missing=0 ; examples=<25, 25-29, 30-35

Holders: integer ; missing=0 ; examples=197, 264, 246

Claims: integer ; missing=0 ; examples=38, 35, 20

Examples
Run this code

     ## main-effects fit as Poisson GLM with offset
     glm(Claims ~ District + Group + Age + offset(log(Holders)),
         data = Insurance, family = poisson)

     # same via loglm
     loglm(Claims ~ District + Group + Age + offset(log(Holders)),
           data = Insurance)

