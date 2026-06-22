Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

newick.eg: Phylogenetic trees in Newick format

Phylogenetic trees in Newick format

Description

     This data set contains various exemples of phylogenetic trees in
     Newick format.

Usage

     data(newick.eg)

Format

     ‘newick.eg’ is a list containing 14 character strings in Newick
     format.

Source

     Trees 1 to 7 were obtained from the phylip software.

     Trees 8 and 9 were obtained by Clémentine Carpentier-Gimaret.

     Tree 10 was obtained from Treezilla Data Sets .

     Trees 11 and 12 are taken from Bauwens and Díaz-Uriarte (1997).

     Tree 13 is taken from Cheverud and Dow (1985).

     Tree 13 is taken from Martins and Hansen (1997).

References

     Bauwens, D. and Díaz-Uriarte, R. (1997) Covariation of
     life-history traits in lacertid lizards: a comparative study.
     _American Naturalist_, *149*, 91-111.

     Cheverud, J. and Dow, M.M. (1985) An autocorrelation analysis of
     genetic variation due to lineal fission in social groups of rhesus
     macaques.  _American Journal of Physical Anthropology_, *67*,
     113-122.

     Martins, E. P. and Hansen, T.F. (1997) Phylogenies and the
     comparative method: a general approach to incorporating
     phylogenetic information into the analysis of interspecific data.
     _American Naturalist_, *149*, 646-667.

Examples
Run this code

     data(newick.eg)
     newick2phylog(newick.eg[[11]])
     radial.phylog(newick2phylog(newick.eg[[7]]), circ = 1,
      clabel.l = 0.75)

