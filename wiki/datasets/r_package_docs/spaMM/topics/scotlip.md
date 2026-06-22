Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

scotlip: Lip cancer in Scotland 1975 - 1980

Lip cancer in Scotland 1975 - 1980

Description

     This data set provides counts of lip cancer diagnoses made in
     Scottish districts from 1975 to 1980, and additional information
     relative to these data from Clayton and Kaldor (1987) and Breslow
     and Clayton (1993).  The data set contains (for each district)
     counts of disease events and estimates of the fraction of the
     population involved in outdoor industry (agriculture, fishing, and
     forestry) which exposes it to sunlight.

     ‘data("scotlip")’ actually loads a data frame, ‘scotlip’, and an
     adjacency matrix, ‘Nmatrix’, between 56 Scottish districts, as
     given by Clayton and Kaldor (1987, Table 1).

Usage

     data("scotlip")

Format

     The data frame includes 56 observations on the following 7
     variables:

     gridcode alternative district identifier.

     id numeric district identifier (1 to 56).

     district district name.

     cases number of lip cancer cases diagnosed 1975 - 1980.

     population total person years at risk 1975 - 1980.

     prop.ag percent of the population engaged in outdoor industry.

     expec offsets considered by Breslow and Clayton (1993, Table 6,
          'Exp' variable)

     The rows are ordered according to ‘gridcode’, so that they match
     the rows of ‘Nmatrix’.

References

     Clayton D, Kaldor J (1987). Empirical Bayes estimates of
     age-standardized relative risks for use in disease mapping.
     Biometrics, 43: 671 - 681.

     Breslow, NE, Clayton, DG. (1993). Approximate Inference in
     Generalized Linear Mixed Models. Journal of the American
     Statistical Association: 88 9-25.


Variables detected from installed object

gridcode: integer ; missing=0 ; examples=1, 2, 3

id: integer ; missing=0 ; examples=6, 4, 1

district: factor ; missing=0 ; examples=Skye-Lochalsh, Banff-Buchan, Caithness

cases: integer ; missing=0 ; examples=9, 39, 11

population: integer ; missing=0 ; examples=28324, 231337, 83190

prop.ag: numeric ; missing=0 ; examples=16, 10

expec: numeric ; missing=0 ; examples=1.4, 8.7, 3

Examples
Run this code

     data("scotlip")
     fitme(cases~I(log(expec)), data=scotlip, family=poisson)

     ## see 'help(autoregressive)' for additional examples involving 'scotlip'.

