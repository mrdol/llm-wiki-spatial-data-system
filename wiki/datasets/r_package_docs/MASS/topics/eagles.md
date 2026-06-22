Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

eagles: Foraging Ecology of Bald Eagles

Foraging Ecology of Bald Eagles

Description

     Knight and Skagen collected during a field study on the foraging
     behaviour of wintering Bald Eagles in Washington State, USA data
     concerning 160 attempts by one (pirating) Bald Eagle to steal a
     chum salmon from another (feeding) Bald Eagle.

Usage

     eagles

Format

     The ‘eagles’ data frame has 8 rows and 5 columns.

     ‘y’ Number of successful attempts.

     ‘n’ Total number of attempts.

     ‘P’ Size of pirating eagle (‘L’ = large, ‘S’ = small).

     ‘A’ Age of pirating eagle (‘I’ = immature, ‘A’ = adult).

     ‘V’ Size of victim eagle (‘L’ = large, ‘S’ = small).

Source

     Knight, R. L. and Skagen, S. K. (1988) Agonistic asymmetries and
     the foraging ecology of Bald Eagles.  _Ecology_ *69*, 1188-1194.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S-PLUS._ Fourth Edition. Springer.


Variables detected from installed object

y: integer ; missing=0 ; examples=17, 29

n: integer ; missing=0 ; examples=24, 29, 27

P: factor ; missing=0 ; examples=L

A: factor ; missing=0 ; examples=A, I

V: factor ; missing=0 ; examples=L, S

Examples
Run this code

     eagles.glm <- glm(cbind(y, n - y) ~ P*A + V, data = eagles,
                       family = binomial)
     dropterm(eagles.glm)
     prof <- profile(eagles.glm)
     plot(prof)
     pairs(prof)

