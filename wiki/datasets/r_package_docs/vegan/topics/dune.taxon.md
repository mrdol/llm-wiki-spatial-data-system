Rdocumentation
powered by

Search all packages and functions
vegan (version 2.7.3)

dune.taxon: Taxonomic Classification and Phylogeny of Dune Meadow Species

Taxonomic Classification and Phylogeny of Dune Meadow Species

Description

     Classification table of the species in the ‘dune’ data set.

Usage

       data(dune.taxon)
       data(dune.phylodis)

Format

     ‘dune.taxon’ is data frame with 30 species (rows) classified into
     five taxonomic levels (columns). ‘dune.phylodis’ is a ‘dist’
     object of estimated coalescence ages extracted from
     doi:10.5061/dryad.63q27 <https://doi.org/10.5061/dryad.63q27>
     (Zanne et al. 2014) using tools in packages ‘ape’ and ‘phylobase’.

Details

     The families and orders are based on APG IV (2016) in vascular
     plants and on Hill et al. (2006) in mosses. The higher levels
     (superorder and subclass) are based on Chase & Reveal (2009).
     Chase & Reveal (2009) treat Angiosperms and mosses as subclasses
     of class Equisetopsida (land plants), but brylogists have
     traditionally used much more inflated levels which are adjusted
     here to match Angiosperm classification.

References

     APG IV [Angiosperm Phylogeny Group] (2016) An update of the
     Angiosperm Phylogeny Group classification for the orders and
     families of flowering plants: APG IV. _Bot. J. Linnean Soc._
     *181*: 1-20.

     Chase, M.W. & Reveal, J. L. (2009) A phylogenetic classification
     of the land plants to accompany APG III. _Bot. J. Linnean Soc._
     *161*: 122-127.

     Hill, M.O et al. (2006) An annotated checklist of the mosses of
     Europe and Macaronesia. _J. Bryology_ *28*: 198-267.

     Zanne A.E., Tank D.C., Cornwell, W.K., Eastman J.M., Smith, S.A.,
     FitzJohn, R.G., McGlinn, D.J., O’Meara, B.C., Moles, A.T., Reich,
     P.B., Royer, D.L., Soltis, D.E., Stevens, P.F., Westoby, M.,
     Wright, I.J., Aarssen, L., Bertin, R.I., Calaminus, A., Govaerts,
     R., Hemmings, F., Leishman, M.R., Oleksyn, J., Soltis, P.S.,
     Swenson, N.G., Warman, L. & Beaulieu, J.M. (2014) Three keys to
     the radiation of angiosperms into freezing environments. _Nature_
     *506*: 89-92.

See Also

     Functions ‘taxondive’, ‘treedive’, and ‘treedist’ use these data
     sets.


Variables detected from installed object

Genus: character ; missing=0 ; examples=Achillea, Agrostis, Aira

Family: character ; missing=0 ; examples=Asteraceae, Poaceae

Order: character ; missing=0 ; examples=Asterales, Poales

Superorder: character ; missing=0 ; examples=Asteranae, Lilianae

Subclass: character ; missing=0 ; examples=Magnoliidae

Examples
Run this code

       data(dune.taxon)
       data(dune.phylodis)

