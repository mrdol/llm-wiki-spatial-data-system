Rdocumentation
powered by

Search all packages and functions
gstat (version 2.1.6)

meuse.all: Meuse river data set - original, full data set

Meuse river data set - original, full data set

Description

     This data set gives locations and top soil heavy metal
     concentrations (ppm), along with a number of soil and landscape
     variables, collected in a flood plain of the river Meuse, near the
     village Stein. Heavy metal concentrations are bulk sampled from an
     area of approximately 15 m x 15 m.

Usage

     data(meuse.all)

Format

     This data frame contains the following columns:

     sample sample number

     x a numeric vector; x-coordinate (m) in RDM (Dutch topographical
          map coordinates)

     y a numeric vector; y-coordinate (m) in RDM (Dutch topographical
          map coordinates)

     cadmium topsoil cadmium concentration, ppm.; note that zero
          cadmium values in the original data set have been shifted to
          0.2 (half the lowest non-zero value)

     copper topsoil copper concentration, ppm.

     lead topsoil lead concentration, ppm.

     zinc topsoil zinc concentration, ppm.

     elev relative elevation

     om organic matter, as percentage

     ffreq flooding frequency class

     soil soil type

     lime lime class

     landuse landuse class

     dist.m distance to river Meuse (metres), as obtained during the
          field survey

     in.pit logical; indicates whether this is a sample taken in a pit

     in.meuse155 logical; indicates whether the sample is part of the
          ‘meuse’ (i.e., filtered) data set; in addition to the samples
          in a pit, an sample (139) with outlying zinc content was
          removed

     in.BMcD logical; indicates whether the sample is used as part of
          the subset of 98 points in the various interpolation examples
          of Burrough and McDonnell

Note:

     ‘sample’ refers to original sample number.  Eight samples were
     left out because they were not indicative for the metal content of
     the soil. They were taken in an old pit. One sample contains an
     outlying zinc value, which was also discarded for the meuse (155)
     data set.

Author(s):

     The actual field data were collected by Ruud van Rijn and Mathieu
     Rikken; data compiled for R by Edzer Pebesma

References

     P.A. Burrough, R.A. McDonnell, 1998. Principles of Geographical
     Information Systems. Oxford University Press.

See Also

     meuse.alt


Variables detected from installed object

sample: numeric ; missing=0 ; examples=1, 2, 3

x: numeric ; missing=0 ; examples=181072, 181025, 181165

y: numeric ; missing=0 ; examples=333611, 333558, 333537

cadmium: numeric ; missing=0 ; examples=11.7, 8.6, 6.5

copper: numeric ; missing=0 ; examples=85, 81, 68

lead: numeric ; missing=0 ; examples=299, 277, 199

zinc: numeric ; missing=0 ; examples=1022, 1141, 640

elev: numeric ; missing=0 ; examples=7.909, 6.983, 7.8

dist.m: numeric ; missing=0 ; examples=50, 30, 150

om: numeric ; missing=2 ; examples=13.6, 14, 13

ffreq: numeric ; missing=0 ; examples=1

soil: numeric ; missing=0 ; examples=1

lime: numeric ; missing=0 ; examples=1

landuse: factor ; missing=1 ; examples=Ah

in.pit: logical ; missing=0 ; examples=FALSE

in.meuse155: logical ; missing=0 ; examples=TRUE

in.BMcD: logical ; missing=0 ; examples=FALSE

Examples
Run this code

     data(meuse.all)
     summary(meuse.all)

