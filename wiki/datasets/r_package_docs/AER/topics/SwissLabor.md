Rdocumentation
powered by

Search all packages and functions
AER (version 1.2.16)

SwissLabor: Swiss Labor Market Participation Data

Swiss Labor Market Participation Data

Description

     Cross-section data originating from the health survey SOMIPOPS for
     Switzerland in 1981.

Usage

     data("SwissLabor")

Format

     A data frame containing 872 observations on 7 variables.

     participation Factor. Did the individual participate in the labor
          force?

     income Logarithm of nonlabor income.

     age Age in decades (years divided by 10).

     education Years of formal education.

     youngkids Number of young children (under 7 years of age).

     oldkids Number of older children (over 7 years of age).

     foreign Factor. Is the individual a foreigner (i.e., not Swiss)?

Source

     Journal of Applied Econometrics Data Archive.

     <http://qed.econ.queensu.ca/jae/1996-v11.3/gerfin/>

References

     Gerfin, M. (1996). Parametric and Semi-Parametric Estimation of
     the Binary Response Model of Labour Market Participation. _Journal
     of Applied Econometrics_, *11*, 321-339.


Variables detected from installed object

participation: factor ; missing=0 ; examples=no, yes

income: numeric ; missing=0 ; examples=10.787497, 10.524251, 10.968578

age: numeric ; missing=0 ; examples=3, 4.5, 4.6

education: numeric ; missing=0 ; examples=8, 9

youngkids: numeric ; missing=0 ; examples=1, 0

oldkids: numeric ; missing=0 ; examples=1, 0

foreign: factor ; missing=0 ; examples=no

Examples
Run this code

     data("SwissLabor")

     ### Gerfin (1996), Table I.
     fm_probit <- glm(participation ~ . + I(age^2), data = SwissLabor,
       family = binomial(link = "probit"))
     summary(fm_probit)

     ### alternatively
     fm_logit <- glm(participation ~ . + I(age^2), data = SwissLabor,
       family = binomial)
     summary(fm_logit)

