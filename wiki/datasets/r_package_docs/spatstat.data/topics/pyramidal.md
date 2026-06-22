Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

pyramidal: Pyramidal Neurons in Cingulate Cortex

Pyramidal Neurons in Cingulate Cortex

Description

     Point patterns giving the locations of pyramidal neurons in
     micrographs from area 24, layer 2 of the cingulate cortex in the
     human brain.  There is one point pattern from each of 31 human
     subjects.  The subjects are divided into three groups: controls
     (12 subjects), schizoaffective (9 subjects) and schizophrenic (10
     subjects).

     Each point pattern is recorded in a unit square region; the unit
     of measurement is unknown.

     These data were introduced and analysed by Diggle, Lange and Benes
     (1991).

Usage

     data(pyramidal)

Format

     ‘pyramidal’ is a hyperframe with 31 rows, one row for each
     subject. It has a column named ‘Neurons’ containing the point
     patterns of neuron locations, and a column named ‘group’ which is
     a factor with levels ‘"control", "schizoaffective",
     "schizophrenic"’ identifying the grouping of subjects.

Source

     Peter Diggle's website.

References

     Diggle, P.J., Lange, N. and Benes, F.M. (1991). Analysis of
     variance for replicated spatial point patterns in clinical
     neuroanatomy.  _Journal of the American Statistical Association_
     *86*, 618-625.

Examples
Run this code

       if(require(spatstat.geom)) {
     pyr <- pyramidal
     pyr$grp <- abbreviate(pyramidal$group, minlength=7)
     plot(pyr, quote(plot(Neurons, pch=16, main=grp)), main="Pyramidal Neurons")
       }

