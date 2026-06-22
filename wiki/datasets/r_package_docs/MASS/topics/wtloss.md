Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

wtloss: Weight Loss Data from an Obese Patient

Weight Loss Data from an Obese Patient

Description

     The data frame gives the weight, in kilograms, of an obese patient
     at 52 time points over an 8 month period of a weight
     rehabilitation programme.

Usage

     wtloss

Format

     This data frame contains the following columns:

     ‘Days’ time in days since the start of the programme.

     ‘Weight’ weight in kilograms of the patient.

Source

     Dr T. Davies, Adelaide.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.


Variables detected from installed object

Days: integer ; missing=0 ; examples=0, 4, 7

Weight: numeric ; missing=0 ; examples=184.35, 182.51, 180.45

Examples
Run this code

     ## IGNORE_RDIFF_BEGIN
     wtloss.fm <- nls(Weight ~ b0 + b1*2^(-Days/th),
         data = wtloss, start = list(b0=90, b1=95, th=120))
     wtloss.fm
     ## IGNORE_RDIFF_END
     plot(wtloss)
     with(wtloss, lines(Days, fitted(wtloss.fm)))

