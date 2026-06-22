Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

VA: Veteran's Administration Lung Cancer Trial

Veteran's Administration Lung Cancer Trial

Description

     Veteran's Administration lung cancer trial from Kalbfleisch &
     Prentice.

Usage

     VA

Format

     A data frame with columns:

     ‘stime’ survival or follow-up time in days.

     ‘status’ dead or censored.

     ‘treat’ treatment: standard or test.

     ‘age’ patient's age in years.

     ‘Karn’ Karnofsky score of patient's performance on a scale of 0 to
          100.

     ‘diag.time’ times since diagnosis in months at entry to trial.

     ‘cell’ one of four cell types.

     ‘prior’ prior therapy?

Source

     Kalbfleisch, J.D. and Prentice R.L. (1980) _The Statistical
     Analysis of Failure Time Data._ Wiley.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

stime: numeric ; missing=0 ; examples=72, 411, 228

status: numeric ; missing=0 ; examples=1

treat: factor ; missing=0 ; examples=1

age: numeric ; missing=0 ; examples=69, 64, 38

Karn: numeric ; missing=0 ; examples=60, 70

diag.time: numeric ; missing=0 ; examples=7, 5, 3

cell: factor ; missing=0 ; examples=1

prior: factor ; missing=0 ; examples=0, 10

