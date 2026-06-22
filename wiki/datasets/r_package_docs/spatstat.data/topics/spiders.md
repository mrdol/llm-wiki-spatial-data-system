Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

spiders: Spider Webs on Mortar Lines of a Brick Wall

Spider Webs on Mortar Lines of a Brick Wall

Description

     Data recording the locations of small spider webs on the network
     of mortar lines of a brick wall.

Usage

     data("spiders")

Format

     Object of class ‘"lpp"’ representing a pattern of points on a
     linear network. Spatial coordinates are expressed in millimetres.

Details

     The data give the positions of 48 webs of the urban wall spider
     _Oecobius navus_ on the mortar lines of a brick wall, recorded by
     Voss (1999) and manually digitised by Mark Handcock.  The mortar
     spaces provide the only opportunity for constructing webs (Voss
     1999; Voss et al 2007) so this is a pattern of points on a network
     of lines.

     The habitat preferences of this species were studied in detail by
     Voss et al (2007). Questions of interest include evidence for
     non-uniform density of webs and for interaction between nearby
     individuals.

     Observations were made inside a square quadrat of side length
     1.125 metres. The original hand-drawn map was digitised manually
     by Mark S. Handcock, and reformatted as a ‘spatstat’ object by Ang
     Qi Wei.

     The dataset ‘spiders’ is an object of class ‘"lpp"’ (point pattern
     on a linear network). Coordinates are given in millimetres. The
     linear network has 156 vertices and a total length of 20.22
     metres.

     _Please cite Voss et al (2007) with any use of these data._

Source

     Dr Sasha Voss. Coordinates manually recorded by M.S. Handcock and
     formatted by Q.W. Ang.

     _Please cite Voss et al (2007) with any use of these data._

References

     Ang, Q.W. (2010) _Statistical methodology for events on a
     network_.  Master's thesis, School of Mathematics and Statistics,
     University of Western Australia.

     Voss, S. (1999) Habitat preferences and spatial dynamics of the
     urban wall spider: _Oecobius annulipes_ Lucas.  Honours Thesis,
     Department of Zoology, University of Western Australia.

     Voss, S., Main, B.Y. and Dadour, I.R. (2007) Habitat preferences
     of the urban wall spider _Oecobius navus_ (Araneae, Oecobiidae).
     _Australian Journal of Entomology_ *46*, 261-268.

Examples
Run this code

       if(require(spatstat.linnet)) {
     plot(spiders, show.window=FALSE, pch=16)
        }

