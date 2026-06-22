Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

freight: Freight dataset

Freight dataset

Description

     A set of data on airfreight breakage. Data are given on 10 air
     shipments, each carrying 1000 ampules of some substance. For each
     shipment, the number of ampules found broken upon arrival, and the
     number of times the shipments were transferred from one aircraft
     to another, are recorded.

Usage

     data("freight")

Format

     The data frame includes 10 observations on the following
     variables:

     broken number of ampules found broken upon arrival.

     transfers number of times the shipments were transferred from one
          aircraft to another.

     id Shipment identifier.

Source

     The data set is reported by Kutner et al. (2003) and used by
     Sellers & Shmueli (2010) to illustrate COMPoisson analyses.

References

     Kutner MH, Nachtsheim CJ, Neter J, Li W (2005, p. 35). Applied
     Linear Regression Models, Fourth Edition. McGraw-Hill.

     Sellers KF, Shmueli G (2010) A Flexible Regression Model for Count
     Data. Ann. Appl. Stat. 4: 943–961


Variables detected from installed object

broken: numeric ; missing=0 ; examples=16, 9, 17

transfers: numeric ; missing=0 ; examples=1, 0, 2

id: integer ; missing=0 ; examples=1, 2, 3

Examples
Run this code

     ## see ?COMPoisson for examples

