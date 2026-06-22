Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

khin.rice.uniformity: Uniformity trial of rice

Uniformity trial of rice

Description

     Uniformity trial of rice in Burma, 1948.

Usage

     data("khin.rice.uniformity")

Format

     A data frame with 1080 observations on the following 3 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, oz/plot

Details

     A uniformity trial of rice. Conducted at the Mudon Agricultural
     Station, Burma, in 1947-48.  Basic plots were 3 feet square.

     Field width: 30 plots * 3 feet.

     Field length: 36 plots * 3 feet.

     Transcription details: Data typed by K.Wright.

Source

     Khin, San. 1950.  Investigation into the relative costs of rice
     experiments based on the efficiency of designs.  Dissertation:
     Imperial College of Tropical Agriculture (ICTA).  Appendix XV.
     https://hdl.handle.net/2139/42422

References

     None.


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=7, 7.5, 7.25

Examples
Run this code

     ## Not run:

     library(agridat)

       data(khin.rice.uniformity)
       dat <- khin.rice.uniformity

       libs(desplot)
       desplot(dat, yield ~ col*row,
               flip=TRUE,
               main="khin.rice.uniformity",
               aspect=(36*3)/(30*3)) # true aspect
     ## End(Not run)

