Rdocumentation
powered by

Search all packages and functions
vegan (version 2.7.3)

sipoo: Birds in the Archipelago of Sipoo (Sibbo and Borgå)

Birds in the Archipelago of Sipoo (Sibbo and Borgå)

Description

     Land birds on islands covered by coniferous forest in the Sipoo
     Archipelago, southern Finland.

Usage

       data(sipoo)
       data(sipoo.map)

Format

     The ‘sipoo’ data frame contains data of occurrences of 50 land
     bird species on 18 islands in the Sipoo Archipelago (Simberloff &
     Martin, 1991, Appendix 3). The species are referred by 4+4 letter
     abbreviation of their Latin names (but using five letters in two
     species names to make these unique).

     The ‘sipoo.map’ data contains the geographic coordinates of the
     islands in the ETRS89-TM35FIN coordinate system (EPSG:3067) and
     the areas of islands in hectares.

Source

     Simberloff, D. & Martin, J.-L.  (1991).  Nestedness of insular
     avifaunas: simple summary statistics masking complex species
     patterns.  _Ornis Fennica_ 68:178-192.


Variables detected from installed object

Pandhali: numeric ; missing=0 ; examples=0

Falcsubb: numeric ; missing=0 ; examples=1, 0

Tetrtetr: numeric ; missing=0 ; examples=0

Scolrust: numeric ; missing=0 ; examples=0

Colupalu: numeric ; missing=0 ; examples=0

Cucucano: numeric ; missing=0 ; examples=0

Apusapus: numeric ; missing=0 ; examples=0

Picucanu: numeric ; missing=0 ; examples=0

Dryomart: numeric ; missing=0 ; examples=0

Jynxtorq: numeric ; missing=0 ; examples=0

Deliurbi: numeric ; missing=0 ; examples=0

Hirurust: numeric ; missing=0 ; examples=0

Motaalba: numeric ; missing=0 ; examples=1

Anthtriv: numeric ; missing=0 ; examples=0

Trogtrog: numeric ; missing=0 ; examples=0

Prunmodu: numeric ; missing=0 ; examples=0

Turdpila: numeric ; missing=0 ; examples=0

Turdphil: numeric ; missing=0 ; examples=0

Turdmeru: numeric ; missing=0 ; examples=0

Turdilia: numeric ; missing=0 ; examples=0

Eritrube: numeric ; missing=0 ; examples=0

Oenaoena: numeric ; missing=0 ; examples=0, 1

Phoephoe: numeric ; missing=0 ; examples=0

Acroarun: numeric ; missing=0 ; examples=0

Acroscir: numeric ; missing=0 ; examples=0

Hippicte: numeric ; missing=0 ; examples=0

Sylvatri: numeric ; missing=0 ; examples=0

Sylvbori: numeric ; missing=0 ; examples=0

Sylvcurr: numeric ; missing=0 ; examples=0

Sylvcomm: numeric ; missing=0 ; examples=0

Phylsibi: numeric ; missing=0 ; examples=0

Phyltrocs: numeric ; missing=0 ; examples=0

Phyltrocd: numeric ; missing=0 ; examples=0

Reguregu: numeric ; missing=0 ; examples=0, 1

Muscstri: numeric ; missing=0 ; examples=0

Ficehypo: numeric ; missing=0 ; examples=0

Parumajo: numeric ; missing=0 ; examples=0, 1

Parucaer: numeric ; missing=0 ; examples=0

Paruater: numeric ; missing=0 ; examples=0

Parumont: numeric ; missing=0 ; examples=0

Cardchlo: numeric ; missing=0 ; examples=0

Cardspin: numeric ; missing=0 ; examples=1, 0

Pyrrpyrr: numeric ; missing=0 ; examples=0

Loxicurv: numeric ; missing=0 ; examples=0

Frincoel: numeric ; missing=0 ; examples=1

Sturvulg: numeric ; missing=0 ; examples=0

Orioorio: numeric ; missing=0 ; examples=0

Corvcoro: numeric ; missing=0 ; examples=0

Corvcora: numeric ; missing=0 ; examples=0

Garrglan: numeric ; missing=0 ; examples=0

Examples
Run this code

     data(sipoo)
     data(sipoo.map)
     plot(N ~ E, data=sipoo.map, asp = 1)

