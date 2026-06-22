Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

aminoacyl: Codon usage

Codon usage

Description

     ‘aminoacyl’ is a list containing the codon counts of 36 genes
     encoding yeast aminoacyl-tRNA-synthetase(S.Cerevisiae).

Usage

     data(aminoacyl)

Format

     ‘aminoacyl’ is a list containing the 5 following objects:

     genes is a vector giving the gene names.

     localisation is a vector giving the cellular localisation of the
          proteins (M = mitochondrial, C = cytoplasmic, I =
          indetermined, CI = cyto and mito).

     codon is a vector containing the 64 triplets.

     AA is a factor giving the amino acid names for each codon.

     usage.codon is a dataframe containing the codon counts for each
          gene.

Source

     Data prepared by D. Charif
     <mailto:Delphine.Charif@versailles.inra.fr>

References

     Chiapello H., Olivier E., Landes-Devauchelle C., Nitschké P. and
     Risler J.L (1999) Codon usage as a tool to predict the cellular
     localisation of eukariotic ribosomal proteins and aminoacyl-tRNA
     synthetases. _Nucleic Acids Res._, *27*, 14, 2848-2851.

Examples
Run this code

     data(aminoacyl)
     aminoacyl$genes
     aminoacyl$usage.codon
     dudi.coa(aminoacyl$usage.codon, scannf = FALSE)

