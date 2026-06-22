Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

kiesselbach.oats.uniformity: Uniformity trial of oats

Uniformity trial of oats

Description

     Uniformity trial of oats at Nebraska in 1916.

Usage

     data("kiesselbach.oats.uniformity")

Format

     A data frame with 207 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield bu/ac

Details

     Experiment conducted in 1916.  Crop was Kerson oats. Each plot
     covered 1/30th acre.  Oats were drilled in plats 66 inches wide by
     16 rods long. The drill was 66 inches wide.  Plats were separated
     by a space of 16 inches between outside drill rows.

     The source document includes three photographs of the field.

     1 acre = 43560 sq feet

     1/30 acre = 1452 sq feet = 16 rods * 16.5 ft/rod * 5.5 ft

     Field width: 3 plats * 16 rods/plat * 16.5 ft/rod = 792 feet

     Field length: 69 plats * 5.5 ft + 68 gaps * 1.33 feet = 469 feet

Source

     Kiesselbach, Theodore A. (1917).  Studies Concerning the
     Elimination of Experimental Error in Comparative Crop Tests.
     University of Nebraska Agricultural Experiment Station Research
     Bulletin No. 13.  Pages 51-72.
     https://archive.org/details/StudiesConcerningTheEliminationOfExperimentalErrorInComparativeCrop
     https://digitalcommons.unl.edu/extensionhist/430/

References

     None.


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=75.5, 84.8, 86.3

Examples
Run this code

     ## Not run:

     library(agridat)

       data(kiesselbach.oats.uniformity)
       dat <- kiesselbach.oats.uniformity

       range(dat$yield) # 56.7 92.8 match Kiesselbach p 64.

       libs(desplot)
       desplot(dat, yield ~ col*row,
               tick=TRUE, flip=TRUE, aspect=792/469, # true aspect
               main="kiesselbach.oats.uniformity")
     ## End(Not run)

