Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

coop: Co-operative Trial in Analytical Chemistry

Co-operative Trial in Analytical Chemistry

Description

     Seven specimens were sent to 6 laboratories in 3 separate batches
     and each analysed for Analyte.  Each analysis was duplicated.

Usage

     coop

Format

     This data frame contains the following columns:

     ‘Lab’ Laboratory, ‘L1’, ‘L2’, ..., ‘L6’.

     ‘Spc’ Specimen, ‘S1’, ‘S2’, ..., ‘S7’.

     ‘Bat’ Batch, ‘B1’, ‘B2’, ‘B3’ (nested within ‘Spc/Lab’),

     ‘Conc’ Concentration of Analyte in g/kg.

Source

     Analytical Methods Committee (1987) Recommendations for the
     conduct and interpretation of co-operative trials, _The Analyst_
     *112*, 679-686.

References

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.

See Also

     ‘chem’, ‘abbey’.


Variables detected from installed object

Lab: factor ; missing=0 ; examples=L1

Spc: factor ; missing=0 ; examples=S1

Bat: factor ; missing=0 ; examples=B1, B2

Conc: numeric ; missing=0 ; examples=0.29, 0.33

