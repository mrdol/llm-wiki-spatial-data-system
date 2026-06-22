Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

mucosa: Cells in Gastric Mucosa

Cells in Gastric Mucosa

Description

     A bivariate inhomogeneous point pattern, giving the locations of
     the centres of two types of cells in a cross-section of the
     gastric mucosa of a rat.

Usage

     data(mucosa)

Format

     An object of class ‘"ppp"’, see ‘ppp.object’.  This is a multitype
     point pattern with two types of points, ‘ECL’ and ‘other’.

Details

     This point pattern dataset gives the locations of cell centres in
     a cross-section of the gastric mucosa (mucous membrane of the
     stomach) of a rat. The rectangular observation window has been
     scaled to unit width. The lower edge of the window is closest to
     the outside of the stomach.

     The cells are classified into two types: _ECL cells_
     (enterochromaffin-like cells) and _other_ cells. There are 86 ECL
     cells and 807 other cells in the dataset.  ECL cells are a type of
     neuroendocrine cell which synthesize and secrete histamine.  One
     hypothesis of interest is whether the spatially-varying
     intensities of ECL cells and other cells are proportional.

     The data were originally collected by Dr Thomas Berntsen.  The
     data were discussed and analysed in Moller and Waagepetersen
     (2004, pp. 2, 169).

     The associated object ‘mucosa.subwin’ is the smaller window to
     which the data were restricted for analysis by Moller and
     Waagepetersen.

     The scale of spatial coordinates is unknown (R. Waagepetersen,
     personal communication).

Source

     Dr Thomas Berntsen and Prof Rasmus Waagepetersen.

References

     Moller, J. and Waagepetersen, R. (2004).  _Statistical Inference
     and Simulation for Spatial Point Processes_.  Chapman and
     Hall/CRC.

Examples
Run this code

       if(require(spatstat.geom)) {
       plot(mucosa, chars=c(1,3), cols=c("red", "green"))
       plot(mucosa.subwin, add=TRUE, lty=3)
       }

