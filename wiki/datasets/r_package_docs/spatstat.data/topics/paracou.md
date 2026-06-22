Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

paracou: Kimboto trees at Paracou, French Guiana

Kimboto trees at Paracou, French Guiana

Description

     This dataset is a point pattern of adult and juvenile Kimboto
     trees (_Pradosia cochlearia_ or _P. ptychandra_) recorded at
     Paracou in French Guiana.  See Flores (2005).

     The dataset ‘paracou’ is a point pattern (object of class ‘"ppp"’)
     containing the spatial coordinates of each tree, marked by age (a
     factor with levels ‘adult’ and ‘juvenile’. The survey region is a
     rectangle approximately 400 by 525 metres. Coordinates are given
     in metres.

     Note that the data contain duplicated points (two points at the
     same location). To determine which points are duplicates, use
     ‘duplicated.ppp’.  To remove the duplication, use ‘unique.ppp’.

Usage

     data(paracou)

Source

     Data kindly contributed by Olivier Flores.  All data belong to
     CIRAD <https://www.cirad.fr> and UMR EcoFoG and are included in
     ‘spatstat’ with permission.  Original data sources: juvenile and
     some adult trees collected by Flores (2005); adult tree data
     sourced from CIRAD Paracou experimental plots dataset (2003
     campaign).

References

     Flores, O. (2005) _ Determinisme de la regeneration chez quinze
     especes d'arbres tropicaux en foret guyanaise: les effets de
     l'environnement et de la limitation par la dispersion._ PhD
     Thesis, University of Montpellier 2, Montpellier, France.

     Picard, N, Bar-Hen, A., Mortier, F. and Chadoeuf, J. (2009) The
     multi-scale marked area-interaction point process: a model for the
     spatial pattern of trees.  _Scandinavian Journal of Statistics_
     *36* 23-41

Examples
Run this code

       if(require(spatstat.geom)) {
     plot(paracou, cols=2:3, chars=c(16,3))
       }

