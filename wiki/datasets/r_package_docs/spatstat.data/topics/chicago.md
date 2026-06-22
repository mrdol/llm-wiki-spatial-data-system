Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

chicago: Chicago Crime Data

Chicago Crime Data

Description

     This dataset is a record of spatial locations of crimes reported
     in the period 25 April to 8 May 2002, in an area of Chicago
     (Illinois, USA) close to the University of Chicago.  The original
     crime map was published in the Chicago Weekly News in 2002.

     The data give the spatial location (street address) of each crime
     report, and the type of crime. The type labels are interpreted as
     follows:

       ‘assault’   battery/assault
       ‘burglary’  burglary
       ‘cartheft’  motor vehicle theft
       ‘damage’    criminal damage
       ‘robbery’   robbery
       ‘theft’     theft
       ‘trespass’  criminal trespass

     All crimes occurred on or near a street. The data give the
     coordinates of all streets in the survey area, and their
     connectivity.

     Spatial coordinates are expressed in feet (one foot is 0.3048
     metres).

     The dataset ‘chicago’ is an object of class ‘"lpp"’ representing a
     point pattern on a linear network.  See ‘lpp’ for further
     information on the format.

     These data were published and analysed in Ang, Baddeley and Nair
     (2012).

Usage

     data(chicago)

Format

     Object of class ‘"lpp"’.  See ‘lpp’.

Source

     Chicago Weekly News, 2002.  Manually digitised by Adrian Baddeley
     <mailto:Adrian.Baddeley@curtin.edu.au>.

References

     Ang, Q.W. (2010) _Statistical methodology for events on a
     network_.  Master's thesis, School of Mathematics and Statistics,
     University of Western Australia.

     Ang, Q.W., Baddeley, A. and Nair, G. (2012) Geometrically
     corrected second-order analysis of events on a linear network,
     with applications to ecology and criminology.  _Scandinavian
     Journal of Statistics_ *39*, 591-617.

     Chicago Weekly News website: <http://www.chicagoweeklynews.com>

Examples
Run this code

     data(chicago)
       if(require(spatstat.linnet)) {
     plot(chicago)
     plot(as.linnet(chicago), main="Chicago Street Crimes",col="green")
     plot(as.ppp(chicago), add=TRUE, col="red", chars=c(16,2,22,17,24,15,6))
       }

