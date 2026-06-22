Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

petrol: N. L. Prater's Petrol Refinery Data

N. L. Prater's Petrol Refinery Data

Description

     The yield of a petroleum refining process with four covariates.
     The crude oil appears to come from only 10 distinct samples.

     These data were originally used by Prater (1956) to build an
     estimation equation for the yield of the refining process of crude
     oil to gasoline.

Usage

     petrol

Format

     The variables are as follows

     ‘No’ crude oil sample identification label. (Factor.)

     ‘SG’ specific gravity, degrees API.  (Constant within sample.)

     ‘VP’ vapour pressure in pounds per square inch. (Constant within
          sample.)

     ‘V10’ volatility of crude; ASTM 10% point. (Constant within
          sample.)

     ‘EP’ desired volatility of gasoline. (The end point.  Varies
          within sample.)

     ‘Y’ yield as a percentage of crude.

Source

     N. H. Prater (1956) Estimate gasoline yields from crudes.
     _Petroleum Refiner_ *35*, 236-238.

     This dataset is also given in D. J. Hand, F. Daly, K. McConway, D.
     Lunn and E. Ostrowski (eds) (1994) _A Handbook of Small Data
     Sets._ Chapman & Hall.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

No: factor ; missing=0 ; examples=A

SG: numeric ; missing=0 ; examples=50.8

VP: numeric ; missing=0 ; examples=8.6

V10: integer ; missing=0 ; examples=190

EP: integer ; missing=0 ; examples=205, 275, 345

Y: numeric ; missing=0 ; examples=12.2, 22.3, 34.7

Examples
Run this code

     library(nlme)
     Petrol <- petrol
     Petrol[, 2:5] <- scale(as.matrix(Petrol[, 2:5]), scale = FALSE)
     pet3.lme <- lme(Y ~ SG + VP + V10 + EP,
                     random = ~ 1 | No, data = Petrol)
     pet3.lme <- update(pet3.lme, method = "ML")
     pet4.lme <- update(pet3.lme, fixed. = Y ~ V10 + EP)
     anova(pet4.lme, pet3.lme)

