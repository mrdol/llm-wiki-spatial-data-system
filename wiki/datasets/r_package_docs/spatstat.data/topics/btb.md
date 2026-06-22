Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

btb: Bovine Tuberculosis Data

Bovine Tuberculosis Data

Description

     Geospatial data of 873 farm locations with detected bovine
     tuberculosis in Cornwall, UK, over the years 1989-2002.  This
     data-set was first analysed in Diggle, Zheng and Durr (2005).

Usage

     data(btb)

Format

     Loading this dataset supplies the point pattern ‘btb’ and the
     additional object ‘btb.extra’.

     ‘btb’ is a marked point pattern (see ‘ppp.object’) containing 873
     points.  Its spatial coordinates are Eastings and Northings in
     kilometres giving the farm locations. It has two columns of marks:

       ‘year’         Year of detection:
                      a ‘factor’ with levels 1989 to 2002
       ‘spoligotype’  Spoligotype of tuberculosis:
                      a ‘factor’ with four levels
                      “9”, “12”, “15”, “20”

     Loading the dataset ‘btb’ will also load the object ‘btb.extra’
     containing additional data. This is a list (of class ‘"solist"’)
     containing two elements,

       ‘standard’  The standard version of the BTB dataset
                   used in many publications. This is a marked point pattern,
                   identical to ‘btb’ except that its window of observation
                   is a slightly larger and simpler polygon than the window of
                   ‘btb’.
       ‘full’      A more extensive dataset
                   compiled from files supplied by Professor Diggle.
                   This is a marked point pattern, identical to ‘standard’
                   except that it includes 46 additional farm locations where
                   bovine tuberculosis was detected, but where the spoligotype
                   was not one of the four common spoligotypes. There are 919 data
                   points altogether.
                   The attribute ‘attr(full, "retained")’ is a logical vector
                   indicating which of the points in ‘full’ was retained
                   or deleted to obtain ‘standard’.

Source

     Professor Peter Diggle.

     Roger Sainsbury of the UK's State Veterinary Service helped to
     collect the data-set. Jackie Inwald and Si Palmer of the
     Department of Bacterial Diseases, Veterinary Laboratories Agency,
     Weybridge, UK carried out the spoligotyping.

     Peter Diggle supplied the point coordinates, spoligotype data and
     year data, and the coordinates of the window used in ‘btb.extra’.

     Tilman Davies drew the finer window used in ‘btb’.

References

     Diggle, P.J., Zheng, P. and Durr, P. (2005) Nonparametric
     estimation of spatial segregation in a multivariate point process:
     bovine tuberculosis in Cornwall, UK.  _Applied Statistics_, *54*,
     645-658.

Examples
Run this code

       if(require(spatstat.geom)) {
         summary(btb)
         plot(subset(btb, select=spoligotype), cols=2:5)
       }

