Rdocumentation
powered by

Search all packages and functions
vegan (version 2.7.3)

dune: Vegetation and Environment in Dutch Dune Meadows.

Vegetation and Environment in Dutch Dune Meadows.

Description

     The dune meadow vegetation data, ‘dune’, has cover class values of
     30 species on 20 sites. The corresponding environmental data frame
     ‘dune.env’ has following entries:

Usage

       data(dune)
       data(dune.env)

Format

     ‘dune’ is a data frame of observations of 30 species at 20 sites.
     The species names are abbreviated to 4+4 letters (see
     ‘make.cepnames’). The following names are changed from the
     original source (Jongman et al. 1987): _Leontodon autumnalis_ to
     _Scorzoneroides_, and _Potentilla palustris_ to _Comarum_.

     ‘dune.env’ is a data frame of 20 observations on the following 5
     variables:

     A1: a numeric vector of thickness of soil A1 horizon.

     Moisture: an ordered factor with levels: ‘1’ < ‘2’ < ‘4’ < ‘5’.

     Management: a factor with levels: ‘BF’ (Biological farming), ‘HF’
          (Hobby farming), ‘NM’ (Nature Conservation Management), and
          ‘SF’ (Standard Farming).

     Use: an ordered factor of land-use with levels: ‘Hayfield’ <
          ‘Haypastu’ < ‘Pasture’.

     Manure: an ordered factor with levels: ‘0’ < ‘1’ < ‘2’ < ‘3’ <
          ‘4’.

Source

     Jongman, R.H.G, ter Braak, C.J.F & van Tongeren, O.F.R. (1987).
     _Data Analysis in Community and Landscape Ecology_. Pudoc,
     Wageningen.


Variables detected from installed object

Achimill: numeric ; missing=0 ; examples=1, 3, 0

Agrostol: numeric ; missing=0 ; examples=0, 4

Airaprae: numeric ; missing=0 ; examples=0

Alopgeni: numeric ; missing=0 ; examples=0, 2, 7

Anthodor: numeric ; missing=0 ; examples=0

Bellpere: numeric ; missing=0 ; examples=0, 3, 2

Bromhord: numeric ; missing=0 ; examples=0, 4

Chenalbu: numeric ; missing=0 ; examples=0

Cirsarve: numeric ; missing=0 ; examples=0

Comapalu: numeric ; missing=0 ; examples=0

Eleopalu: numeric ; missing=0 ; examples=0

Elymrepe: numeric ; missing=0 ; examples=4

Empenigr: numeric ; missing=0 ; examples=0

Hyporadi: numeric ; missing=0 ; examples=0

Juncarti: numeric ; missing=0 ; examples=0

Juncbufo: numeric ; missing=0 ; examples=0

Lolipere: numeric ; missing=0 ; examples=7, 5, 6

Planlanc: numeric ; missing=0 ; examples=0

Poaprat: numeric ; missing=0 ; examples=4, 5

Poatriv: numeric ; missing=0 ; examples=2, 7, 6

Ranuflam: numeric ; missing=0 ; examples=0

Rumeacet: numeric ; missing=0 ; examples=0

Sagiproc: numeric ; missing=0 ; examples=0

Salirepe: numeric ; missing=0 ; examples=0

Scorautu: numeric ; missing=0 ; examples=0, 5, 2

Trifprat: numeric ; missing=0 ; examples=0

Trifrepe: numeric ; missing=0 ; examples=0, 5, 2

Vicilath: numeric ; missing=0 ; examples=0

Bracruta: numeric ; missing=0 ; examples=0, 2

Callcusp: numeric ; missing=0 ; examples=0

Examples
Run this code

     data(dune)
     data(dune.env)

