Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

gordon: People in Gordon Square

People in Gordon Square

Description

     This dataset records the location of people sitting on a grass
     patch in Gordon Square, London, at 3pm on a sunny afternoon.

     The dataset ‘gordon’ is a point pattern (object of class ‘"ppp"’)
     containing the spatial coordinates of each person.

     The grass patch is an irregular polygon with two holes.

     Coordinates are given in metres.

Usage

     data(gordon)

Source

     Andrew Bevan, University College London.

References

     Baddeley, A., Turner, R., Mateu, J. and Bevan, A. (2013) Hybrids
     of Gibbs point process models and their implementation.  _Journal
     of Statistical Software_ *55*:11, 1-43.  ‘DOI:
     10.18637/jss.v055.i11’

Examples
Run this code

     data(gordon)
       if(require(spatstat.geom)) {
     plot(gordon)
       }

