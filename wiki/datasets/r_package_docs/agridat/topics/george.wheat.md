Rdocumentation
powered by

Search all packages and functions
agridat (version 1.26)

george.wheat: Multi-location/year breeding trial in California

Multi-location/year breeding trial in California

Description

     Multi-location/year breeding trial in California

Usage

     data("george.wheat")

Format

     A data frame with 13996 observations on the following 5 variables.

     ‘gen’ genotype number

     ‘year’ year

     ‘loc’ location

     ‘block’ block

     ‘yield’ yield per plot

Details

     This is a nice example of data from a breeding trial, in which
     some check genotypes are kepts during the whole experiment, while
     other genotypes enter and leave the breeding program.  The data is
     highly unbalanced with respect to genotypes-by-environments.

     Results of late-stage small-trials of 211 genotypes of wheat in
     California, conducted at 9 locations during the years 2004-2018.

     Each trial was an RCB with 4 blocks.

     The authors used this data to look at GGE biplots across years and
     concluded that repeatable genotype-by-location patterns were weak,
     and therefore the California cereal production region is a large,
     unstable, mega-environment.

     Data downloaded 2019-10-29 from Dryad,
     https://doi.org/10.5061/dryad.bf8rt6b.  Data are public domain.

Source

     Nicholas George and Mark Lundy (2019).  Quantifying Genotype x
     Environment Effects in Long-Term Common Wheat Yield Trials from an
     Agroecologically Diverse Production Region.  Crop Science, 59,
     1960-1972.  https://doi.org/10.2135/cropsci2019.01.0010

References

     None


Variables detected from installed object

gen: integer ; missing=0 ; examples=112, 1340

year: integer ; missing=0 ; examples=2013

loc: factor ; missing=0 ; examples=Yolo2

block: factor ; missing=0 ; examples=B1, B4

yield: integer ; missing=43 ; examples=1319, 1500, 1291

Examples
Run this code

     ## Not run:

       library(agridat)
       libs(lattice, reshape2)
       data(george.wheat)
       dat <- george.wheat

       dat$env <- paste0(dat$year, ".", dat$loc)
       # average reps, cast to matrix
       mat <- reshape2::acast(dat, gen ~ env, value.var="yield", fun=mean, na.rm=TRUE)
       lattice::levelplot(mat, aspect="m",
                          main="george.wheat", xlab="genotype", ylab="environment",
                          scales=list(x=list(cex=.3,rot=90),y=list(cex=.5)))
     ## End(Not run)

