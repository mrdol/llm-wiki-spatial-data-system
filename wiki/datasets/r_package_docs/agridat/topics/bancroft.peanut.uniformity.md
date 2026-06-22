Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

bancroft.peanut.uniformity: Uniformity trial of peanuts

Uniformity trial of peanuts

Description

     Uniformity trial of peanuts in Alabama, 1946.

Usage

     data("bancroft.peanut.uniformity")

Format

     A data frame with 216 observations on the following 5 variables.

     ‘row’ row

     ‘col’ column

     ‘yield’ yield, pounds per plot

     ‘block’ block

Details

     The data are obtained from two parts of the same field, located at
     Wiregrass Substation, Headland, Alabama, USA.  Each part had 18
     rows, 3 feet wide, 100 feet long. Plots were harvested in 1946.
     Green weights in pounds were recorded.

     Each plot was 16.66 linear feet of row and 3 feet in width, 50 sq
     feet.

     Field width: 6 plots * 16.66 feet = 100 feet

     Field length: 18 plots * 3 feet = 54 feet

     Conclusions: Based on the relative efficiencies, increasing the
     size of the plot along the row is better than across the row.
     Narrow, rectangular plots are more efficient.

Source

     Bancroft, T. A. et a1., (1948).  Size and Shape of Plots and
     Distribution of Plot Yield for Field Experiments with Peanuts.
     Alabama Agricultural Experiment Station Progress Report, sec. 39.
     Table 4, page 6.
     https://aurora.auburn.edu/bitstream/handle/11200/1345/0477PROG.pdf;sequence=1

References

     None


Variables detected from installed object

row: integer ; missing=0 ; examples=1, 2, 3

col: integer ; missing=0 ; examples=1

yield: numeric ; missing=0 ; examples=1.86, 2.32, 2.55

block: factor ; missing=0 ; examples=B1

Examples
Run this code

     ## Not run:

     library(agridat)
     data(bancroft.peanut.uniformity)
     dat <- bancroft.peanut.uniformity

     # match means Bancroft page 3
     ## dat
     ## # A tibble: 2 x 2
     ##   block    mn
     ##   <chr> <dbl>
     ## 1 B1     2.46
     ## 2 B2     2.05

     libs(desplot)
     desplot(dat, yield ~ col*row|block,
             flip=TRUE, aspect=(18*3)/(6*16.66), # true aspect
             main="bancroft.peanut.uniformity")
     ## End(Not run)

