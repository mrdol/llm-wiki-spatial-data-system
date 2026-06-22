Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

perthi02: Contingency Table with a partition in Molecular Biology

Contingency Table with a partition in Molecular Biology

Description

     This data set gives the amino acids of 904 proteins distributed in
     three classes.

Usage

     data(perthi02)

Format

     ‘perthi02’ is a list of 2 components.

     tab is a data frame 904 rows (proteins of 201 species) 20 columns
          (amino acids).

     cla is a factor of 3 classes of protein

     The levels of ‘perthi02$cla’ are ‘cyto’ (cytoplasmic proteins)
     ‘memb’ (integral membran proteins) ‘peri’ (periplasmic proteins)

Source

     Perriere, G. and Thioulouse, J. (2002) Use of Correspondence
     Discriminant Analysis to predict the subcellular location of
     bacterial proteins.  _Computer Methods and Programs in
     Biomedicine_, *70*, 2, 99-105.

Examples
Run this code

     data(perthi02)
     plot(discrimin.coa(perthi02$tab, perthi02$cla, scan = FALSE))

