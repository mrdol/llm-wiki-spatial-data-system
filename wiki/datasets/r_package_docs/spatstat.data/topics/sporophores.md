Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

sporophores: Sporophores Data

Sporophores Data

Description

     Spatial pattern of sporophores of three species of fungi around a
     tree.

Usage

     data(sporophores)

Format

     A multitype spatial point pattern (an object of class ‘"ppp"’ with
     factor-valued marks indicating the species).  Spatial coordinates
     are given in centimetres.  Levels of the species variable are ‘"L
     laccata"’, ‘"L pubescens"’ and ‘"Hebloma spp"’.

Details

     Ford, Mason and Pelham (1980) studied the spatial locations of
     sporophores of three species of mycorrhizal fungi distributed
     around a young birch tree in agricultural soil.  The dataset given
     here is the spatial pattern in the fifth year after the tree was
     planted.  The species are _Laccaria laccata_, _Lactarius
     pubescens_ and _Hebloma_ spp.

Source

     Data generously provided by Dr E.D. Ford.  Please cite Ford et al
     (1980) in any use of these data.

References

     Ford, E.D., Mason, P.A. and Pelham, J. (1980) Spatial patterns of
     sporophore distribution around a young birch tree in three
     successive years.  _Transactions of the British Mycological
     Society_ *75*, 287-296.

Examples
Run this code

       if(require(spatstat.geom)) {
     ## reproduce Fig 1 in Ford et al (1980)
     plot(sporophores, chars=c(16,1,2), cex=0.6, leg.args=list(cex=1.1))
     points(0,0,pch=16, cex=2)
     text(15,8,"Tree", cex=0.75)
       }

