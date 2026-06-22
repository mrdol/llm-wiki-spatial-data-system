Rdocumentation
powered by

Search all packages and functions
MASS (version 7.3.65)

geyser: Old Faithful Geyser Data

Old Faithful Geyser Data

Description

     A version of the eruptions data from the ‘Old Faithful’ geyser in
     Yellowstone National Park, Wyoming. This version comes from
     Azzalini and Bowman (1990) and is of continuous measurement from
     August 1 to August 15, 1985.

     Some nocturnal duration measurements were coded as 2, 3 or 4
     minutes, having originally been described as ‘short’, ‘medium’ or
     ‘long’.

Usage

     geyser

Format

     A data frame with 299 observations on 2 variables.

       ‘duration’  numeric  Eruption time in mins
       ‘waiting’   numeric  Waiting time for this eruption

Note:

     The ‘waiting’ time was incorrectly described as the time to the
     next eruption in the original files, and corrected for ‘MASS’
     version 7.3-30.

References

     Azzalini, A. and Bowman, A. W. (1990) A look at some data on the
     Old Faithful geyser.  _Applied Statistics_ *39*, 357-365.

     Venables, W. N. and Ripley, B. D. (2002) _Modern Applied
     Statistics with S._ Fourth edition.  Springer.

See Also

     ‘faithful’.

     CRAN package ‘sm’.


Variables detected from installed object

waiting: numeric ; missing=0 ; examples=80, 71, 57

duration: numeric ; missing=0 ; examples=4.0166667, 2.15, 4

