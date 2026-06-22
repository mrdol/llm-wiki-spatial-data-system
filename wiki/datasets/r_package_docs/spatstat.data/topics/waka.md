Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

waka: Trees in Waka national park

Trees in Waka national park

Description

     This dataset is a spatial point pattern of trees recorded at Waka
     National Park, Gabon.  See Balinga et al (2006).

     The dataset ‘waka’ is a point pattern (object of class ‘"ppp"’)
     containing the spatial coordinates of each tree, marked by the
     tree diameter at breast height ‘dbh’.  The survey region is a 100
     by 100 metre squawre.  Coordinates are given in metres, while the
     ‘dbh’ is in centimetres.

Usage

     data(waka)

Source

     Nicolas Picard

References

     Balinga, M., Sunderland, T., Walters, G., Issembe', Y., Asaha, S.
     and Fombod, E. (2006) _A vegetation assessment of the Waka
     national park, Gabon._ Herbier National du Gabon, LBG, MBG, WCS,
     FRP and Simthsonian Institution, Libreville, Gabon. CARPE Report,
     154 pp.  <http://carpe.umd.edu/>

     Picard, N., Bar-Hen, A., Mortier, F. and Chadoeuf, J. (2009) The
     multi-scale marked area-interaction point process: a model for the
     spatial pattern of trees.  _Scandinavian Journal of Statistics_
     *36* 23-41

Examples
Run this code

     data(waka)
       if(require(spatstat.geom)) {
     plot(waka, markscale=0.01)
     title(sub="Tree diameters to scale")
     plot(waka, markscale=0.04)
     title(sub="Tree diameters 4x scale")
        }

