Rdocumentation
powered by

Search all packages and functions
ade4 (version 1.7.24)

aviurba: Ecological Tables Triplet

Ecological Tables Triplet

Description

     This data set is a list of information about 51 sites : bird
     species and environmental variables.
     A data frame contains biological traits for each species.

Usage

     data(aviurba)

Format

     This list contains the following objects:

     fau is a data frame 51 sites 40 bird species.

     mil is a data frame 51 sites 11 environmental variables (see
          details).

     traits is a data frame 40 species 4 biological traits (see
          details).

     species.names.fr is a vector of the species names in french.

     species.names.la is a vector of the species names in latin.

     species.family is a factor : the species families.

Details

     ‘aviurba$mil’ contains for each site, 11 habitat attributes
     describing the degree of urbanization. The presence or absence of
     farms or villages, small buildings, high buildings, industry,
     fields, grassland, scrubby areas, deciduous woods, coniferous
     woods, noisy area are noticed. At least, the vegetation cover
     (variable 11) is a factor with 8 levels from a minimum cover (R5)
     up to a maximum (R100).
     ‘aviurba$traits’ contains four factors : feeding habit
     (insectivor, granivore, omnivore), feeding stratum (ground,
     aerial, foliage and scrub), breeding stratum (ground, building,
     scrub, foliage) and migration strategy (resident, migrant).

Source

     Dolédec, S., Chessel, D., Ter Braak,C. J. F. and Champely S.
     (1996) Matching species traits to environmental variables: a new
     three-table ordination method. _Environmental and Ecological
     Statistics_, *3*, 143-166.

Examples
Run this code

     data(aviurba)
     a1 <- dudi.coa(aviurba$fau, scan = FALSE, nf=4)
     a2 <- dudi.acm(aviurba$mil, row.w = a1$lw, scan = FALSE, nf = 4)
     plot(coinertia(a1, a2, scan = FALSE))

