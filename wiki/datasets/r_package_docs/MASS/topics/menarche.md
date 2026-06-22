Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

menarche: Age of Menarche in Warsaw

Age of Menarche in Warsaw

Description

     Proportions of female children at various ages during adolescence
     who have reached menarche.

Usage

     menarche

Format

     This data frame contains the following columns:

     ‘Age’ Average age of the group.  (The groups are reasonably age
          homogeneous.)

     ‘Total’ Total number of children in the group.

     ‘Menarche’ Number who have reached menarche.

Source

     Milicer, H. and Szczotka, F. (1966) Age at Menarche in Warsaw
     girls in 1965.  _Human Biology_ *38*, 199-203.

     The data are also given in
     Aranda-Ordaz, F.J. (1981) On two families of transformations to
     additivity for binary response data.  _Biometrika_ *68*, 357-363.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

Age: numeric ; missing=0 ; examples=9.21, 10.21, 10.58

Total: numeric ; missing=0 ; examples=376, 200, 93

Menarche: numeric ; missing=0 ; examples=0

Examples
Run this code

     mprob <- glm(cbind(Menarche, Total - Menarche) ~ Age,
                  binomial(link = probit), data = menarche)

