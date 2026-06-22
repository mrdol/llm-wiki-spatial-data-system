Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

concrete: Air Bubbles in Concrete

Air Bubbles in Concrete

Description

     Prof. Shin-ichi Igarashi's data: a point pattern of the locations,
     in a cross-section of a concrete body, of the centroids of air
     bubbles in the cement paste matrix surrounding particles of
     aggregate.

Usage

     data("concrete")

Format

     An object of class ‘"ppp"’ representing the point pattern of air
     bubble centroid locations. Spatial coordinates are expressed in
     microns.

Details

     The window of the point pattern is a binary mask (window of type
     ‘"mask"’; see ‘owin’ and ‘as.mask’ for more information about this
     type of window).  This window in effect consists of the cement
     paste matrix, or equivalently of the complement (in the observed
     cross-section) of the aggregate.

     Major scientific interest is focussed on analysing the
     distribution of the location of the air bubbles in the cement
     paste matrix.  These bubbles are important in assuring frost
     resistance of the concrete.  Each air bubble protects a region
     around it to a certain distance. To protect an entire concrete
     object against severe frost attack, it is necessary to cover the
     whole of the cement paste matrix with subsets of protected regions
     formed around the air bubbles. It is believed that the protected
     regions are related to the Dirichlet tessellation of the centroids
     of the bubbles, and the statistical properties of the protected
     regions can be determined from those of the Dirichlet
     tessellation.  In this regard, the areas of the tiles are
     particularly important.

Source

     Prof. Shin-ichi Igarashi, of the School of Geoscience and Civil
     Engineering, Kanazawa University, personal communication.

References

     Natesaiyer, K., Hover, K.C. and Snyder, K.A. (1992).
     Protected-paste volume of air-entrained cement paste: part 1.
     _Journal of Materials in Civil Engineering_ *4* No.2, 166 - 184.

     Murotani, T., Igarashi, S. and Koto, H. (2019). Distribution
     analysis and modeling of air voids in concrete as spatial point
     processes. _Cement and Concrete Research_ *115* 124 - 132.

Examples
Run this code

       if(require(spatstat.geom)) {
          plot(concrete,chars="+",cols="blue",col="yellow")
          # The aggregate is in yellow; the cement paste matrix is in white.

          # Unit of length: use \mu symbol for micron
          unitname(concrete) <- "\u00B5m"

          if(interactive()) {
            # Compute the Dirichlet tessellation
            dtc <- dirichlet(concrete)
            plot(dtc,ribbon=FALSE, col=sample(rainbow(dtc$n)))
            # Study Dirichlet tile areas
            areas <- tile.areas(dtc)
            aa <- areas/1000 # Divide by 1000 to avoid numerical instability
            # Fit a gamma distribution by the method of moments
            mm <- mean(aa)
            vv <- var(aa)
            shape <- mm^2/vv
            rate <- mm/vv
            rate <- rate/1000 # Adjust for rescaling
            hist(areas,probability=TRUE,ylim=c(0,7.5e-6),
               main="Histogram and density estimates for areas",ylab="",xlab="area")
            lines(density(areas),col="red")
            curve(dgamma(x,shape=shape,rate=rate),add=TRUE,col="blue")
            legend("topright",lty=1,col=c("red","blue"),
                   legend=c("non-parametric","gamma fit"),bty="n")
          }
       }

