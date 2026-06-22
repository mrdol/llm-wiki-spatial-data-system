Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

hdpg: Genetic Variation In Human Populations

Genetic Variation In Human Populations

Description

     This data set gives genotypes variation of 1066 individuals
     belonging to 52 predefined populations, for 404 microsatellite
     markers.

Usage

     data(hdpg)

Format

     ‘hdpg’ is a list of 3 components.

     tab is a data frame with the genotypes of 1066 individuals encoded
          with 6 characters (individuals in row, locus in column), for
          example ‘123098’ for a heterozygote carrying alleles ‘123’
          and ‘098’, ‘123123’ for a homozygote carrying two alleles
          ‘123’ and, ‘000000’ for a not classified locus (missing
          data).

     ind is a a data frame with 4 columns containing information about
          the 1066 individuals: ‘hdpg$ind$id’ containing the Diversity
          Panel identification number of each individual, and three
          factors ‘hdpg$ind$sex’, ‘hdpg$ind$population’ and
          ‘hdpg$ind$region’ containing the names of the 52 populations
          belonging to 7 major geographic regions (see details).

     locus is a dataframe containing four columns:
          ‘hdpg$locus$marknames’ a vector of names of the
          microsatellite markers, ‘hdpg$locus$allbyloc’ a vector
          containing the number of alleles by loci,
          ‘hdpg$locus$chromosome’ a factor defining a number for one
          chromosome and, ‘hdpg$locus$maposition’ indicating the
          position of the locus in the chromosome.

Details

     The rows of ‘hdpg$pop’ are the names of the 52 populations
     belonging to the geographic regions contained in the rows of
     ‘hdpg$region’. The chosen regions are: America, Asia, Europe,
     Middle East North Africa, Oceania, Subsaharan AFRICA.
     The 52 populations are: Adygei, Balochi, Bantu, Basque, Bedouin,
     Bergamo, Biaka Pygmies, Brahui, Burusho, Cambodian, Columbian,
     Dai, Daur, Druze, French, Han, Hazara, Hezhen, Japanese, Kalash,
     Karitiana, Lahu, Makrani, Mandenka, Maya, Mbuti Pygmies,
     Melanesian, Miaozu, Mongola, Mozabite, Naxi, NewGuinea, Nilote,
     Orcadian, Oroqen, Palestinian, Pathan, Pima, Russian, San,
     Sardinian, She, Sindhi, Surui, Tu, Tujia, Tuscan, Uygur, Xibo,
     Yakut, Yizu, Yoruba.
     ‘hdpg$freq’ is a data frame with 52 rows, corresponding to the 52
     populations described above, and 4992 microsatellite markers.

Source

     Extract of data prepared by the Human Diversity Panel Genotypes
     (invalid
     http://research.marshfieldclinic.org/genetics/Freq/FreqInfo.htm)

     prepared by Hinda Haned, from data used in: Noah A. Rosenberg,
     Jonatahan K. Pritchard, James L. Weber, Howard M. Cabb, Kenneth K.
     Kidds, Lev A. Zhivotovsky, Marcus W. Feldman (2002) Genetic
     Structure of human Populations _Science_, *298*, 2381-2385.

     Lev A. Zhivotovsky, Noah Rosenberg, and Marcus W. Feldman (2003).
     Features of Evolution and Expansion of Modern Humans, Inferred
     from Genomewide Microsatellite Markers _Am. J. Hum. Genet_, *72*,
     1171-1186.

Examples
Run this code

     data(hdpg)
     names(hdpg)
     str(hdpg)

