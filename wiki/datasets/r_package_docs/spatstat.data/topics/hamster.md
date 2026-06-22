Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

Aherne's hamster tumour data

Description

     Point pattern of cell nuclei in hamster kidney, each nucleus
     classified as either `dividing' or `pyknotic'.  A multitype point
     pattern.

Usage

     data(hamster)

Format

     An object of class ‘"ppp"’ representing the point pattern of cell
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of cell
       ‘y’      Cartesian y-coordinate of cell
       ‘marks’  factor with levels ‘"dividing"’
                and ‘"pyknotic"’.

     See ‘ppp.object’ for details of the format.

Notes:

     These data were presented and analysed by Diggle (1983, section
     7.3).

     The data give the positions of the centres of the nuclei of
     certain cells in a histological section of tissue from a
     laboratory-induced metastasising lymphoma in the kidney of a
     hamster.

     The nuclei are classified as either "pyknotic" (corresponding to
     dying cells) or "dividing" (corresponding to cells arrested in
     metaphase, i.e. in the act of dividing). The background void is
     occupied by unrecorded, interphase cells in relatively large
     numbers.

     The sampling window is a square, originally about 0.25 mm square
     in real units, which has been rescaled to the unit square.

Source

     Dr W. A. Aherne, Department of Pathology, University of
     Newcastle-upon-Tyne, UK. Data supplied by Prof. Peter Diggle

References

     Diggle, P.J. (1983) _Statistical analysis of spatial point
     patterns_.  Academic Press.

Examples
Run this code

       if(require(spatstat.geom)) {
       hamster
       ## rescale to microns
       (Ham <- rescale(hamster))
       }

