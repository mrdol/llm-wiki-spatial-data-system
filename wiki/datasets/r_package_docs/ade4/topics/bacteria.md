Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

bacteria: Genomes of 43 Bacteria

Genomes of 43 Bacteria

Description

     ‘bacteria’ is a list containing 43 species and genomic
     informations : codons, amino acid and bases.

Usage

     data(bacteria)

Format

     This list contains the following objects:

     code is a factor with the amino acid names for each codon.

     espcodon is a data frame 43 species 64 codons.

     espaa is a data frame 43 species 21 amino acid.

     espbase is a data frame 43 species 4 bases.

Source

     Data prepared by J. Lobry <mailto:Jean.Lobry@univ-lyon1.fr>
     starting from <https://www.jcvi.org/>.

Examples
Run this code

     data(bacteria)
     names(bacteria$espcodon)
     names(bacteria$espaa)
     names(bacteria$espbase)
     sum(bacteria$espcodon) # 22,619,749 codons

     if(adegraphicsLoaded()) {
       g <- scatter(dudi.coa(bacteria$espcodon, scann = FALSE),
         posi = "bottomleft")
     } else {
       scatter(dudi.coa(bacteria$espcodon, scann = FALSE),
         posi = "bottomleft")
     }

