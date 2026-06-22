Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

stonetools: Palaeolithic Stone Tools

Palaeolithic Stone Tools

Description

     This dataset is a spatial point pattern giving the locations of
     palaeolithic stone tools (‘lithic’ specimens) and animal bone
     fragments (‘bone’), accurately surveyed in a layer of soil at
     David's Site, Olduvai Gorge, Tanzania. The surveyed layer is about
     20 cm thick and approximately 1.85 million years old.

     Details of the study, and data analysis, are reported by
     Diez-Martin et al. (2021). Please cite this article in any use of
     the data.

     The data are presented as a two-dimensional point pattern with two
     columns of marks: the vertical position ‘Z’ (numeric) and the type
     of artefact ‘TYPE’ (factor with levels ‘BONE’ and ‘LITHIC’). The
     window of observation is an irregular polygon, approximately 40 by
     30 metres across.  Spatial coordinates and vertical coordinate are
     expressed in metres.  There are 3563 bone fragments and 1182
     lithic specimens making a total of 4745 points.

Usage

     data("stonetools")

Format

     Marked spatial point pattern (object of class ‘"ppp"’, see
     ‘ppp.object’) with two columns of marks, ‘Z’ (numeric) and ‘TYPE’
     (factor with levels ‘BONE’ and ‘LITHIC’). The window of
     observation is an irregular polygon. Spatial coordinate unit is
     metres.

Source

     Dr. L. Cobo and Prof. F. Diez-Martin.  Please cite Diez-Martin et
     al (2021) in any use of these data.

References

     Diez-Martin, F., Cobo-Sanchez, L., Baddeley, A., Uribelarrea, D.,
     Mabulla, A., Baquedano, E. and Dominguez-Rodrigo, M. (2021)
     Tracing the spatial imprint of Oldowan technological behaviors: A
     view from DS (Bed I, Olduvai Gorge, Tanzania).  _PLOS ONE, Public
     Library of Science_, *16*, 1-47.  ‘DOI:
     10.1371/journal.pone.0254603’

Examples
Run this code

       if(require(spatstat.geom)) {
     plot(subset(stonetools, select=TYPE), cex=0.5, cols=2:3)
       }

