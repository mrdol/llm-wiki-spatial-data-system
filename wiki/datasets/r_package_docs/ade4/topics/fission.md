Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

fission: Fission pattern and heritable morphological traits

Fission pattern and heritable morphological traits

Description

     This data set contains the mean values of five highly heritable
     linear combinations of cranial metric (GM1-GM3) and non metric
     (GN1-GN2) for 8 social groups of Rhesus Macaques on Cayo Santiago.
     It also describes the fission tree depicting the historical
     phyletic relationships.

Usage

     data(fission)

Format

     ‘fission’ is a list containing the 2 following objects :

     tre is a character string giving the fission tree in Newick
          format.

     tab is a data frame with 8 social groups and five traits : cranial
          metrics (GM1, GM2, GM3) and cranial non metrics (GN1, GN2)

References

     Cheverud, J. and Dow, M.M. (1985) An autocorrelation analysis of
     genetic variation due to lineal fission in social groups of rhesus
     macaques.  _American Journal of Physical Anthropology_, *67*,
     113-122.

Examples
Run this code

     data(fission)
     fis.phy <- newick2phylog(fission$tre)
     table.phylog(fission$tab[names(fis.phy$leaves),], fis.phy, csi = 2)
     gearymoran(fis.phy$Amat, fission$tab)

