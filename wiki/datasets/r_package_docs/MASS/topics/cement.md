Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

cement: Heat Evolved by Setting Cements

Heat Evolved by Setting Cements

Description

     Experiment on the heat evolved in the setting of each of 13
     cements.

Usage

     cement

Format

     ‘x1, x2, x3, x4’ Proportions (%) of active ingredients.

     ‘y’ heat evolved in cals/gm.

Details

     Thirteen samples of Portland cement were set. For each sample, the
     percentages of the four main chemical ingredients was accurately
     measured.  While the cement was setting the amount of heat evolved
     was also measured.

Source

     Woods, H., Steinour, H.H. and Starke, H.R. (1932) Effect of
     composition of Portland cement on heat evolved during hardening.
     _Industrial Engineering and Chemistry_, *24*, 1207-1214.

References

     Hald, A. (1957) _Statistical Theory with Engineering
     Applications._ Wiley, New York.


Variables detected from installed object

x1: integer ; missing=0 ; examples=7, 1, 11

x2: integer ; missing=0 ; examples=26, 29, 56

x3: integer ; missing=0 ; examples=6, 15, 8

x4: integer ; missing=0 ; examples=60, 52, 20

y: numeric ; missing=0 ; examples=78.5, 74.3, 104.3

Examples
Run this code

     lm(y ~ x1 + x2 + x3 + x4, cement)

