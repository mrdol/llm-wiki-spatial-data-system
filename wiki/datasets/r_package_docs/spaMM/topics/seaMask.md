Rdocumentation
powered by

Search all packages and functions
spaMM (version 4.6.65)

seaMask: Masks of seas or lands

Masks of seas or lands

Description

     These convenient masks can be added to maps of (parts of) the
     world to mask map information for these areas.

     However, many other tools may be available since this
     documentation was conceived. See e.g. the ‘rnaturalearth’ package,
     used to provide a sea mask in an example for ‘filled.mapMM’

Usage

     data("seaMask")
     data("landMask")
     # data("worldcountries") # deprecated and removed
     # data("oceanmask") # deprecated and removed

Format

     ‘seaMask’ and ‘landMask’ are data frames with two variables, ‘x’
     and ‘y’ for longitude and latitude.  Its contents are suitable for
     use with ‘polypath’: they define different polygones, each
     separated by a row of ‘NA’s.

     ‘worldcountries’ and ‘oceanmask’ were
     ‘sp::SpatialPolygonsDataFrame’ objects previously included in
     spaMM (see Details for replacement). Such objects were useful for
     creating land masks for different geographical projections.

Details

     The removed objects ‘worldcountries’ and ‘oceanmask’ were suitable
     for plots involving geographical projections not available through
     ‘map’, and more generally for raster plots. A land mask could be
     produced out of ‘worldcountries’ by filling the countries, as by
     ‘fill="black"’ in the code for ‘country.layer’ in the Examples in
     <https://gitlab.mbb.univ-montp2.fr/francois/spamm-ref/-/blob/master/vignettePlus/example_raster.html>.
     These objects may now be available through the same web page, but
     a better place to look for the same functionality is the ‘IsoriX’
     package (objects ‘CountryBorders’ and ‘OceanMask’).

     ‘seaMask’ and ‘landMask’ were created from the world map in the
     maps package.  ‘polypath’ requires polygons, while
     ‘map(interior=FALSE,plot=FALSE)’ returns small segments.
     ‘landMask’ is the result of reconnecting the segments into full
     coastlines of all land blocks.

See Also

     <https://gitlab.mbb.univ-montp2.fr/francois/spamm-ref/-/blob/master/vignettePlus/example_raster.html>
     for access to, and use of ‘worldcountries’ and ‘oceanmask’;
     <https://cran.r-project.org/package=IsoriX> for replacement
     ‘CountryBorders’ and ‘OceanMask’ for these objects.


Variables detected from installed object

x: numeric ; missing=1432 ; examples=-83.6444473266602, -82.8075256347656, -82.5613861083984

y: numeric ; missing=1432 ; examples=10.9249877929688, 9.74085521697998, 9.56581687927246

Examples
Run this code

     ## Predicting behaviour for a land bird: simplified fit for illustration
     data("blackcap")
     bfit <- fitme(migStatus ~ means+ Matern(1|longitude+latitude),data=blackcap,
                    fixed=list(lambda=0.5537,phi=1.376e-05,rho=0.0544740,nu=0.6286311))

     ## the plot itself, with a sea mask,
     ## and an ad hoc 'pointmask' to see better the predictions on small islands
     #
     def_pointmask <- function(xy,r=1,npts=12) {
       theta <- 2*pi/npts *seq(npts)
       hexas <- lapply(seq(nrow(xy)), function(li){
         p <- as.numeric(xy[li,])
         hexa <- cbind(x=p[1]+r*cos(theta),y=p[2]+r*sin(theta))
         rbind(rep(NA,2),hexa) ## initial NA before each polygon
       })
       do.call(rbind,hexas)
     }
     ll <- blackcap[,c("longitude","latitude")]
     pointmask <- def_pointmask(ll[c(2,4,5,6,7),],r=0.8) ## small islands only
     #
     if (spaMM.getOption("example_maxtime")>1) {
       data("seaMask")

       filled.mapMM(bfit,add.map=TRUE,
                  plot.title=title(main="Inferred migration propensity of blackcaps",
                                    xlab="longitude",ylab="latitude"),
                  decorations=quote(points(pred[,coordinates],cex=1,pch="+")),
                  plot.axes=quote({axis(1);axis(2);
                             polypath(rbind(seaMask,pointmask),border=FALSE,
                                      col="grey", rule="evenodd")
                  }))
     }

