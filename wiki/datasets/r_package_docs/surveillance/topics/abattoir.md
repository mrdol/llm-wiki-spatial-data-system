Rdocumentation
powered by

Search all packages and functions
surveillance (version 1.25.0)

abattoir: Abattoir Data

Abattoir Data

Description

     A synthetic dataset from the Danish meat inspection - useful for
     illustrating the beta-binomial CUSUM.

Usage

     data(abattoir)

Details

     The object of class ‘"sts"’ contains an artificial data set
     inspired by meat inspection data used by Danish Pig Production,
     Denmark. For each week the number of pigs with positive audit
     reports is recorded together with the total number of audits made
     that week.

References

     Höhle, M. (2010): Online change-point detection in categorical
     time series.  In: T. Kneib and G. Tutz (Eds.), Statistical
     Modelling and Regression Structures, Physica-Verlag.

See Also

     ‘categoricalCUSUM’

Examples
Run this code

     data("abattoir")
     plot(abattoir)
     population(abattoir)

