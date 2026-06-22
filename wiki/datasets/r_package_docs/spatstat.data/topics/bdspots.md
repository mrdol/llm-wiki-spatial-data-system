Rdocumentation
powered by

Search all packages and functions
spatstat.data (version 3.1.9)

bdspots: Breakdown Spots in Microelectronic Materials

Breakdown Spots in Microelectronic Materials

Description

     A list of three point patterns, each giving the locations of
     electrical breakdown spots on a circular electrode in a
     microelectronic capacitor.

Usage

     data(bdspots)

Format

     A list (of class ‘"listof"’) of three spatial point patterns, each
     representing the spatial locations of breakdown spots on an
     electrode. The three electrodes are circular discs, of radii 169,
     282 and 423 microns respectively. Spatial coordinates are given in
     microns.

Details

     The application of successive voltage sweeps to the metal gate
     electrode of a microelectronic capacitor generates multiple
     breakdown spots on the electrode.  The spatial distribution of
     these breakdown spots in MIM (metal-insulator-metal) and MIS
     (metal-insulator-semiconductor) structures was observed and
     analysed by Miranda et al (2010, 2013) and Saura et al (2013a,
     2013b, 2014).

     The data given here are the breakdown spot patterns for three
     circular electrodes of different radii, 169, 282 and 423 microns
     respectively, in MIM structures analysed in Saura et al (2013a).

Source

     Professor Enrique Miranda, Departament d'Enginyeria Electronica,
     Escola d'Enginyeria, Universitat Autonoma de Barcelona, Barcelona,
     Spain.

References

     Miranda, E. and O'Connor, E. and Hurley, P.K. (2010) Simulation of
     the breakdown spots spatial distribution in high-_K_ dielectrics
     and model validation using the ‘spatstat’ package for _R_
     language.  _ECS Transactions_ *33* (3) 557-562.

     Miranda, E., Jimenez, D., Sune, J., O'Connor, E., Monaghan, S.,
     Povey, I., Cherkaoui, K. and Hurley, P. K. (2013) Nonhomogeneous
     spatial distribution of filamentary leakage current paths in
     circular area Pt/HfO2/Pt capacitors.  _J. Vac. Sci. Technol. B_
     *31*, 01A107.

     Saura, X., Sune, J., Monaghan, S., Hurley, P.K. and Miranda, E.
     (2013a) Analysis of the breakdown spot spatial distribution in
     Pt/HfO2/Pt capacitors using nearest neighbor statistics.  _J.
     Appl. Phys._ *114*, 154112.

     Saura, X., Moix, D., Sune, J., Hurley, P.K. and Miranda, E.
     (2013b) Direct observation of the generation of breakdown spots in
     MIM structures under constant voltage stress.  _Microelectronics
     Reliability_ *53*, 1257-1260.

     Saura, X., Monaghan, S., Hurley, P.K., Sune, J.  and Miranda, E.
     (2014) Failure analysis of MIM and MIS structures using
     point-to-event distance and angular probability distributions.
     _IEEE Transactions on Devices and Materials Reliability_ *14* (4)
     1080-1090.

Examples
Run this code

     data(bdspots)
       if(require(spatstat.geom)) {
     plot(bdspots, equal.scales=TRUE)
       }

