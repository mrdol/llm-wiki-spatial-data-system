Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

longleaf: Longleaf Pines Point Pattern

Longleaf Pines Point Pattern

Description

     Locations and sizes of Longleaf pine trees.  A marked point
     pattern.

     The data record the locations and diameters of 584 Longleaf pine
     (_Pinus palustris_) trees in a 200 x 200 metre region in southern
     Georgia (USA).  They were collected and analysed by Platt, Evans
     and Rathbun (1988).

     This is a marked point pattern; the mark associated with a tree is
     its diameter at breast height (‘dbh’), a convenient measure of its
     size.  Several analyses have considered only the ``adult'' trees
     which are conventionally defined as those trees with ‘dbh’ greater
     than or equal to 30 cm.

     The pattern is regarded as spatially inhomogeneous.

Usage

     data(longleaf)

Format

     An object of class ‘"ppp"’ representing the point pattern of tree
     locations.  Entries include

       ‘x’      Cartesian x-coordinate of tree in metres
       ‘y’      Cartesian y-coordinate of tree in metres
       ‘marks’  diameter at breast height, in centimetres.

     See ‘ppp.object’ for details of the format of a point pattern
     object.

Source

     Platt, Evans and Rathbun (1988)

References

     Platt, W. J., Evans, G. W. and Rathbun, S. L. (1988) The
     population dynamics of a long-lived Conifer (Pinus palustris).
     _The American Naturalist_ *131*, 491-525.

     Rathbun, S. L. and Cressie, N. (1994) A space-time survival point
     process for a longleaf pine forest in southern Georgia. _Journal
     of the American Statistical Association_ *89*, 1164-1173.

Examples
Run this code

         data(longleaf)
       if(require(spatstat.geom)) {
         plot(longleaf)
         plot(cut(longleaf, breaks=c(0,30,Inf), labels=c("Sapling","Adult")))
       }

