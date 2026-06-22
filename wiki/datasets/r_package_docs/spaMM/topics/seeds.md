Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

seeds: Seed germination data

Seed germination data

Description

     A classic toy data set, “from research conducted by microbiologist
     Dr P. Whitney of Surrey University. A batch of tiny seeds is
     brushed onto a plate covered with a certain extract at a given
     dilution. The numbers of germinated and ungerminated seeds are
     subsequently counted” (Crowder, 1978). Two seed types and two
     extracts are here considered in a 2x2 factorial design.

Usage

     data("seeds")

Format

     The data frame includes 21 observations on the following
     variables:

     plate Factor for replication;

     seed Seed type, a factor with two levels O73 and O75;

     extract Root extract, a factor with two levels Bean and Cucumber;

     r Number of seeds that germinated;

     n Total number of seeds tested

Source

     Crowder (1978), Table 3.

References

     Crowder, M.J., 1978. Beta-binomial anova for proportions. Appl.
     Statist., 27, 34-37.

     Y. Lee and J. A. Nelder. 1996. Hierarchical generalized linear
     models (with discussion). J. R. Statist. Soc. B, 58: 619-678.


Variables detected from installed object

plate: integer ; missing=0 ; examples=1, 2, 3

seed: factor ; missing=0 ; examples=O75

extract: factor ; missing=0 ; examples=Bean

r: integer ; missing=0 ; examples=10, 23

n: integer ; missing=0 ; examples=39, 62, 81

Examples
Run this code

     # An extended quasi-likelihood (EQL) fit as considered by Lee & Nelder (1996):
     data("seeds")
     fitme(cbind(r,n-r)~seed*extract+(1|plate),family=binomial(),
           rand.family=Beta(),
           method="EQL-", # see help("method") for difference with "EQL+" method
           data=seeds)

