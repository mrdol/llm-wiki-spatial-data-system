Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

walker: Walker Lake sample and exhaustive data sets

Walker Lake sample and exhaustive data sets

Description

     This is the Walker Lake data sets (sample and exhaustive data
     set), used in Isaaks and Srivastava's Applied Geostatistics.

Usage

     data(walker)

Format

     This data frame contains the following columns:

     Id Identification Number

     X Xlocation in meter

     Y Ylocation in meter

     V V variable, concentration in ppm

     U U variable, concentration in ppm

     T T variable, indicator variable

Note:

     This data sets was obtained from the data sets on ai-geostats
     (link no longer functioning)

References

     Applied Geostatistics by Edward H. Isaaks, R. Mohan Srivastava;
     Oxford University Press.


Variables detected from installed object

U: numeric ; missing=0 ; examples=10.029, 0.063, 4.726

V: numeric ; missing=0 ; examples=75.38, 4.39, 50.38

Examples
Run this code

     library(sp)
     data(walker)
     summary(walker)
     summary(walker.exh)

