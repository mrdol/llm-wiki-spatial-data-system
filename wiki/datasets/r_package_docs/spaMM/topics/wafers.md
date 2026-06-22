Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

wafers: Data from a resistivity experiment for semiconductor materials.

Data from a resistivity experiment for semiconductor materials.

Description

     This data set was reported and analyzed by Robinson et al. (2006)
     and reanalyzed by Lee et al. (2011). The data “deal with wafers in
     a single etching process in semiconductor manufacturing. Wafers
     vary through time since there are some variables that are not
     perfectly controllable in the etching process. For this reason,
     wafers produced on any given day (batch) may be different from
     those produced on another day (batch). To measure variation over
     batch, wafers are tested by choosing several days at random. In
     this data, resistivity is the response of interest. There are
     three variables, gas flow rate (x1), temperature (x2), and
     pressure (x3) and one random effect (batch or day).” (Lee et al
     2011).

Usage

     data("wafers")

Format

     The data frame includes 198 observations on the following
     variables:

     y resistivity.

     batch batch, indeed.

     X1 gas flow rate.

     X2 temperature.

     X3 pressure.

Source

     This data set was manually pasted from Table 3 of Lee et al.
     (2011). Transcription errors may have occurred.

References

     Robinson TJ, Wulff SS, Montgomery DC, Khuri AI. 2006. Robust
     parameter design using generalized linear mixed models. Journal of
     Quality Technology 38: 38-65.

     Lee, Y., Nelder, J.A., and Park, H. 2011. HGLMs for quality
     improvement.  Applied Stochastic Models in Business and Industry
     27, 315-328.


Variables detected from installed object

X1: numeric ; missing=0 ; examples=-1, 1

X2: numeric ; missing=0 ; examples=-1, 1

X3: numeric ; missing=0 ; examples=-1

batch: factor ; missing=0 ; examples=1

y: numeric ; missing=0 ; examples=186.56, 378.06, 196.32

Examples
Run this code

     ## see examples in the main Documentation page for the package.

