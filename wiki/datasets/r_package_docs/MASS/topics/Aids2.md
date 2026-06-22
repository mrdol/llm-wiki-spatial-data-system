Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

Aids2: Australian AIDS Survival Data

Australian AIDS Survival Data

Description

     Data on patients diagnosed with AIDS in Australia before 1 July
     1991.

Usage

     Aids2

Format

     This data frame contains 2843 rows and the following columns:

     ‘state’ Grouped state of origin: ‘"NSW "’includes ACT and
          ‘"other"’ is WA, SA, NT and TAS.

     ‘sex’ Sex of patient.

     ‘diag’ (Julian) date of diagnosis.

     ‘death’ (Julian) date of death or end of observation.

     ‘status’ ‘"A"’ (alive) or ‘"D"’ (dead) at end of observation.

     ‘T.categ’ Reported transmission category.

     ‘age’ Age (years) at diagnosis.

Note:

     This data set has been slightly jittered as a condition of its
     release, to ensure patient confidentiality.

Source

     Dr P. J. Solomon and the Australian National Centre in HIV
     Epidemiology and Clinical Research.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

state: factor ; missing=0 ; examples=NSW

sex: factor ; missing=0 ; examples=M

diag: integer ; missing=0 ; examples=10905, 11029, 9551

death: integer ; missing=0 ; examples=11081, 11096, 9983

status: factor ; missing=0 ; examples=D

T.categ: factor ; missing=0 ; examples=hs

age: integer ; missing=0 ; examples=35, 53, 42

