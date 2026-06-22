Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

toxicity: Homogeneous Table

Homogeneous Table

Description

     This data set gives the toxicity of 7 molecules on 17 targets
     expressed in -log(mol/liter)

Usage

     data(toxicity)

Format

     ‘toxicity’ is a list of 3 components.

     tab is a data frame with 7 columns and 17 rows

     species is a vector of the names of the species in the 17 targets

     chemicals is a vector of the names of the 7 molecules

Source

     Devillers, J., Thioulouse, J. and Karcher W. (1993) Chemometrical
     Evaluation of Multispecies-Multichemical Data by Means of
     Graphical Techniques Combined with Multivariate Analyses.
     _Ecotoxicology and Environnemental Safety_, *26*, 333-345.

Examples
Run this code

     data(toxicity)
     if(adegraphicsLoaded()) {
       table.image(toxicity$tab, labelsy = toxicity$species, labelsx = toxicity$chemicals, nclass = 7,
         ptable.margin = list(b = 5, l = 25, t = 25, r = 5), ptable.y.pos = "left", pgrid.draw = TRUE)
       table.value(toxicity$tab, labelsy = toxicity$species, labelsx = toxicity$chemicals,
         ptable.margin = list(b = 5, l = 5, t = 25, r = 26))
     } else {
       table.paint(toxicity$tab, row.lab = toxicity$species, col.lab = toxicity$chemicals)
       table.value(toxicity$tab, row.lab = toxicity$species, col.lab = toxicity$chemicals)
     }

