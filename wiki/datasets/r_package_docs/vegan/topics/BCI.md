Rdocumentation
powered by

Search all packages and functions
vegan (version 2.7.3)

BCI: Barro Colorado Island Tree Counts

Barro Colorado Island Tree Counts

Description

     Tree counts in 1-hectare plots in the Barro Colorado Island and
     associated site information.

Usage

     data(BCI)
     data(BCI.env)

Format

     A data frame with 50 plots (rows) of 1 hectare with counts of
     trees on each plot with total of 225 species (columns). Full Latin
     names are used for tree species. The names were updated with The
     Plant List web service (now phased out) and Kress et al. (2009)
     which allows matching 207 of species against
     doi:10.5061/dryad.63q27 <https://doi.org/10.5061/dryad.63q27>
     (Zanne et al., 2014). The original species names are available as
     attribute ‘original.names’ of ‘BCI’. See Examples for changed
     names.

     For ‘BCI.env’, a data frame with 50 plots (rows) and nine site
     variables derived from Pyke et al. (2001) and Harms et al. (2001):

     ‘UTM.EW’: UTM coordinates (zone 17N) East-West.

     ‘UTM.NS’: UTM coordinates (zone 17N) North-South.

     ‘Precipitation’: Precipitation in mm per year.

     ‘Elevation’: Elevation in m above sea level.

     ‘Age.cat’: Forest age category.

     ‘Geology’: The Underlying geological formation.

     ‘Habitat’: Dominant habitat type based on the map of habitat types
          in 25 grid cells in each plot (Harms et al. 2001, excluding
          streamside habitat). The habitat types are ‘Young’ forests
          (_ca._ 100 years), old forests on > 7 degree slopes
          (‘OldSlope’), old forests under 152 m elevation (‘OldLow’)
          and at higher elevation (‘OldHigh’) and ‘Swamp’ forests.

     ‘River’: ‘"Yes"’ if there is streamside habitat in the plot.

     ‘EnvHet’: Environmental Heterogeneity assessed as the Simpson
          diversity of frequencies of ‘Habitat’ types in 25 grid cells
          in the plot.

Details

     Data give the numbers of trees at least 10 cm in diameter at
     breast height (DBH) in each one hectare quadrat in the 1982 BCI
     plot. Within each plot, all individuals were tallied and are
     recorded in this table. The full survey included smaller trees
     with DBH 1 cm or larger, but the ‘BCI’ dataset is a subset of
     larger trees as compiled by Condit et al. (2002). The full data
     with thinner trees has densities above 4000 stems per hectare, or
     about ten times more stems than these data. The dataset ‘BCI’ was
     provided (in 2003) to illustrate analysis methods in ‘vegan’. For
     scientific research on ecological issues we strongly recommend to
     access complete and more modern data (Condit et al. 2019) with
     updated taxonomy (Condit et al. 2020).

     The data frame contains only the Barro Colorado Island subset of
     the full data table of Condit et al. (2002).

     The quadrats are located in a regular grid. See ‘BCI.env’ for the
     coordinates.

     A full description of the site information in ‘BCI.env’ is given
     in Pyke et al. (2001) and Harms et al. (2001). _N.B._ Pyke et al.
     (2001) and Harms et al. (2001) give conflicting information about
     forest age categories and elevation.

Source

     <https://www.science.org/doi/10.1126/science.1066854> for
     community data and References for environmental data. For updated
     complete data (incl. thinner trees down to 1 cm), see Condit et
     al. (2019).

References

     Condit, R, Pitman, N, Leigh, E.G., Chave, J., Terborgh, J.,
     Foster, R.B., Nuñez, P., Aguilar, S., Valencia, R., Villa, G.,
     Muller-Landau, H.C., Losos, E. & Hubbell, S.P. (2002).
     Beta-diversity in tropical forest trees. _Science_ 295, 666-669.

     Condit R., Pérez, R., Aguilar, S., Lao, S., Foster, R. & Hubbell,
     S. (2019). Complete data from the Barro Colorado 50-ha plot:
     423617 trees, 35 years [Dataset].  _Dryad_.
     doi:10.15146/5xcp-0d46 <https://doi.org/10.15146/5xcp-0d46>

     Condit, R., Aguilar, S., Lao, S., Foster, R., Hubbell, S. (2020).
     BCI 50-ha Plot Taxonomy [Dataset].  _Dryad_.  doi:10.15146/R3FH61
     <https://doi.org/10.15146/R3FH61>

     Harms K.E., Condit R., Hubbell S.P. & Foster R.B. (2001) Habitat
     associations of trees and shrubs in a 50-ha neotropical forest
     plot. _J. Ecol._ 89, 947-959.

     Kress W.J., Erickson D.L, Jones F.A., Swenson N.G, Perez R.,
     Sanjur O. & Bermingham E. (2009) Plant DNA barcodes and a
     community phylogeny of a tropical forest dynamics plot in Panama.
     _PNAS_ 106, 18621-18626.

     Pyke, C. R., Condit, R., Aguilar, S., & Lao, S. (2001). Floristic
     composition across a climatic gradient in a neotropical lowland
     forest. _Journal of Vegetation Science_ 12, 553-566.
     doi:10.2307/3237007 <https://doi.org/10.2307/3237007>

     Zanne A.E., Tank D.C., Cornwell, W.K., Eastman J.M., Smith, S.A.,
     FitzJohn, R.G., McGlinn, D.J., O’Meara, B.C., Moles, A.T., Reich,
     P.B., Royer, D.L., Soltis, D.E., Stevens, P.F., Westoby, M.,
     Wright, I.J., Aarssen, L., Bertin, R.I., Calaminus, A., Govaerts,
     R., Hemmings, F., Leishman, M.R., Oleksyn, J., Soltis, P.S.,
     Swenson, N.G., Warman, L. & Beaulieu, J.M. (2014) Three keys to
     the radiation of angiosperms into freezing environments. _Nature_
     506, 89-92.  doi:10.1038/nature12872
     <https://doi.org/10.1038/nature12872> (published online Dec 22,
     2013).

See Also

     Extra-CRAN package ‘natto’ (<https://github.com/jarioksa/natto>)
     has data set ‘BCI.env2’ with original grid data of Harms et al.
     (2001) habitat classification, and data set ‘BCI.taxon’ of APG III
     classification of tree species.


Variables detected from installed object

Abarema.macradenia: integer ; missing=0 ; examples=0

Vachellia.melanoceras: integer ; missing=0 ; examples=0

Acalypha.diversifolia: integer ; missing=0 ; examples=0

Acalypha.macrostachya: integer ; missing=0 ; examples=0

Adelia.triloba: integer ; missing=0 ; examples=0

Aegiphila.panamensis: integer ; missing=0 ; examples=0

Alchornea.costaricensis: integer ; missing=0 ; examples=2, 1

Alchornea.latifolia: integer ; missing=0 ; examples=0

Alibertia.edulis: integer ; missing=0 ; examples=0

Allophylus.psilospermus: integer ; missing=0 ; examples=0

Alseis.blackiana: integer ; missing=0 ; examples=25, 26, 18

Amaioua.corymbosa: integer ; missing=0 ; examples=0

Anacardium.excelsum: integer ; missing=0 ; examples=0

Andira.inermis: integer ; missing=0 ; examples=0

Annona.spraguei: integer ; missing=0 ; examples=1, 0

Apeiba.glabra: integer ; missing=0 ; examples=13, 12, 6

Apeiba.tibourbou: integer ; missing=0 ; examples=2, 0, 1

Aspidosperma.desmanthum: integer ; missing=0 ; examples=0

Astrocaryum.standleyanum: integer ; missing=0 ; examples=0, 2, 1

Astronium.graveolens: integer ; missing=0 ; examples=6, 0, 1

Attalea.butyracea: integer ; missing=0 ; examples=0, 1

Banara.guianensis: integer ; missing=0 ; examples=0

Beilschmiedia.pendula: integer ; missing=0 ; examples=4, 5, 7

Brosimum.alicastrum: integer ; missing=0 ; examples=5, 2, 4

Brosimum.guianense: integer ; missing=0 ; examples=0

Calophyllum.longifolium: integer ; missing=0 ; examples=0, 2

Casearia.aculeata: integer ; missing=0 ; examples=0

Casearia.arborea: integer ; missing=0 ; examples=1, 3

Casearia.commersoniana: integer ; missing=0 ; examples=0, 1

Casearia.guianensis: integer ; missing=0 ; examples=0

Casearia.sylvestris: integer ; missing=0 ; examples=2, 1, 0

Cassipourea.guianensis: integer ; missing=0 ; examples=2, 0, 1

Cavanillesia.platanifolia: integer ; missing=0 ; examples=0

Cecropia.insignis: integer ; missing=0 ; examples=12, 5, 7

Cecropia.obtusifolia: integer ; missing=0 ; examples=0

Cedrela.odorata: integer ; missing=0 ; examples=0

Ceiba.pentandra: integer ; missing=0 ; examples=0, 1

Celtis.schippii: integer ; missing=0 ; examples=0

Cespedesia.spathulata: integer ; missing=0 ; examples=0

Chamguava.schippii: integer ; missing=0 ; examples=0

Chimarrhis.parviflora: integer ; missing=0 ; examples=0

Maclura.tinctoria: integer ; missing=0 ; examples=0

Chrysochlamys.eclipes: integer ; missing=0 ; examples=0

Chrysophyllum.argenteum: integer ; missing=0 ; examples=4, 1, 2

Chrysophyllum.cainito: integer ; missing=0 ; examples=0

Coccoloba.coronata: integer ; missing=0 ; examples=0

Coccoloba.manzinellensis: integer ; missing=0 ; examples=0

Colubrina.glandulosa: integer ; missing=0 ; examples=0

Cordia.alliodora: integer ; missing=0 ; examples=2, 3

Cordia.bicolor: integer ; missing=0 ; examples=12, 14, 35

Cordia.lasiocalyx: integer ; missing=0 ; examples=8, 6

Coussarea.curvigemma: integer ; missing=0 ; examples=0

Croton.billbergianus: integer ; missing=0 ; examples=2, 0

Cupania.cinerea: integer ; missing=0 ; examples=0

Cupania.latifolia: integer ; missing=0 ; examples=0

Cupania.rufescens: integer ; missing=0 ; examples=0

Cupania.seemannii: integer ; missing=0 ; examples=2, 1

Dendropanax.arboreus: integer ; missing=0 ; examples=0, 3, 6

Desmopsis.panamensis: integer ; missing=0 ; examples=0, 4

Diospyros.artanthifolia: integer ; missing=0 ; examples=1

Dipteryx.oleifera: integer ; missing=0 ; examples=1, 3

Drypetes.standleyi: integer ; missing=0 ; examples=2, 1

Elaeis.oleifera: integer ; missing=0 ; examples=0

Enterolobium.schomburgkii: integer ; missing=0 ; examples=0

Erythrina.costaricensis: integer ; missing=0 ; examples=0

Erythroxylum.macrophyllum: integer ; missing=0 ; examples=0, 1

Eugenia.florida: integer ; missing=0 ; examples=0, 1

Eugenia.galalonensis: integer ; missing=0 ; examples=0

Eugenia.nesiotica: integer ; missing=0 ; examples=0, 1

Eugenia.oerstediana: integer ; missing=0 ; examples=3, 2, 5

Faramea.occidentalis: integer ; missing=0 ; examples=14, 36, 39

Ficus.colubrinae: integer ; missing=0 ; examples=0, 1

Ficus.costaricana: integer ; missing=0 ; examples=0

Ficus.insipida: integer ; missing=0 ; examples=0

Ficus.maxima: integer ; missing=0 ; examples=1, 0

Ficus.obtusifolia: integer ; missing=0 ; examples=0

Ficus.popenoei: integer ; missing=0 ; examples=0

Ficus.tonduzii: integer ; missing=0 ; examples=0, 1

Ficus.trigonata: integer ; missing=0 ; examples=0

Ficus.yoponensis: integer ; missing=0 ; examples=1, 0

Garcinia.intermedia: integer ; missing=0 ; examples=0, 1

Garcinia.madruno: integer ; missing=0 ; examples=4, 0

Genipa.americana: integer ; missing=0 ; examples=0, 1

Guapira.myrtiflora: integer ; missing=0 ; examples=3, 1, 0

Guarea.fuzzy: integer ; missing=0 ; examples=1, 0

Guarea.grandifolia: integer ; missing=0 ; examples=0

Guarea.guidonia: integer ; missing=0 ; examples=2, 6

Guatteria.dumetorum: integer ; missing=0 ; examples=6, 16

Guazuma.ulmifolia: integer ; missing=0 ; examples=0

Guettarda.foliacea: integer ; missing=0 ; examples=1, 5

Gustavia.superba: integer ; missing=0 ; examples=10, 5, 0

Hampea.appendiculata: integer ; missing=0 ; examples=0, 1

Hasseltia.floribunda: integer ; missing=0 ; examples=5, 9, 4

Heisteria.acuminata: integer ; missing=0 ; examples=0

Heisteria.concinna: integer ; missing=0 ; examples=4, 5

Hirtella.americana: integer ; missing=0 ; examples=0

Hirtella.triandra: integer ; missing=0 ; examples=21, 14, 5

Hura.crepitans: integer ; missing=0 ; examples=0

Hieronyma.alchorneoides: integer ; missing=0 ; examples=0, 2

Inga.acuminata: integer ; missing=0 ; examples=0

Inga.cocleensis: integer ; missing=0 ; examples=2, 4

Inga.goldmanii: integer ; missing=0 ; examples=0, 1

Inga.laurina: integer ; missing=0 ; examples=0

Inga.semialata: integer ; missing=0 ; examples=0, 2

Inga.nobilis: integer ; missing=0 ; examples=0, 1

Inga.oerstediana: integer ; missing=0 ; examples=0

Inga.pezizifera: integer ; missing=0 ; examples=0

Inga.punctata: integer ; missing=0 ; examples=3, 0

Inga.ruiziana: integer ; missing=0 ; examples=0

Inga.sapindoides: integer ; missing=0 ; examples=2, 0, 3

Inga.spectabilis: integer ; missing=0 ; examples=0, 2

Inga.umbellifera: integer ; missing=0 ; examples=0

Jacaranda.copaia: integer ; missing=0 ; examples=6, 10, 9

Lacistema.aggregatum: integer ; missing=0 ; examples=1, 0

Lacmellea.panamensis: integer ; missing=0 ; examples=1, 0

Laetia.procera: integer ; missing=0 ; examples=0, 1

Laetia.thamnia: integer ; missing=0 ; examples=0, 1

Lafoensia.punicifolia: integer ; missing=0 ; examples=0

Licania.hypoleuca: integer ; missing=0 ; examples=0

Licania.platypus: integer ; missing=0 ; examples=0

Lindackeria.laurina: integer ; missing=0 ; examples=0

Lonchocarpus.heptaphyllus: integer ; missing=0 ; examples=7, 3

Luehea.seemannii: integer ; missing=0 ; examples=1, 0

Macrocnemum.roseum: integer ; missing=0 ; examples=0

Maquira.guianensis.costaricana: integer ; missing=0 ; examples=4, 3, 7

Margaritaria.nobilis: integer ; missing=0 ; examples=0

Marila.laxiflora: integer ; missing=0 ; examples=1, 0

Maytenus.schippii: integer ; missing=0 ; examples=2, 0

Miconia.affinis: integer ; missing=0 ; examples=0

Miconia.argentea: integer ; missing=0 ; examples=2, 0, 1

Miconia.elata: integer ; missing=0 ; examples=0

Miconia.hondurensis: integer ; missing=0 ; examples=0

Mosannona.garwoodii: integer ; missing=0 ; examples=1, 0

Myrcia.gatunensis: integer ; missing=0 ; examples=1, 0

Myrospermum.frutescens: integer ; missing=0 ; examples=0

Nectandra.cissiflora: integer ; missing=0 ; examples=0, 1, 2

Nectandra.lineata: integer ; missing=0 ; examples=0

Nectandra.purpurea: integer ; missing=0 ; examples=1, 0

Ochroma.pyramidale: integer ; missing=0 ; examples=1, 0

Ocotea.cernua: integer ; missing=0 ; examples=0, 1

Ocotea.oblonga: integer ; missing=0 ; examples=0, 1

Ocotea.puberula: integer ; missing=0 ; examples=0

Ocotea.whitei: integer ; missing=0 ; examples=1, 0, 2

Oenocarpus.mapora: integer ; missing=0 ; examples=22, 21, 14

Ormosia.amazonica: integer ; missing=0 ; examples=0

Ormosia.coccinea: integer ; missing=0 ; examples=0

Ormosia.macrocalyx: integer ; missing=0 ; examples=0

Pachira.quinata: integer ; missing=0 ; examples=0

Pachira.sessilis: integer ; missing=0 ; examples=0

Perebea.xanthochyma: integer ; missing=0 ; examples=0, 1

Cinnamomum.triplinerve: integer ; missing=0 ; examples=0, 1

Picramnia.latifolia: integer ; missing=0 ; examples=0, 1

Piper.reticulatum: integer ; missing=0 ; examples=0

Platymiscium.pinnatum: integer ; missing=0 ; examples=3, 5

Platypodium.elegans: integer ; missing=0 ; examples=2, 1, 3

Posoqueria.latifolia: integer ; missing=0 ; examples=0, 1

Poulsenia.armata: integer ; missing=0 ; examples=24, 16, 28

Pourouma.bicolor: integer ; missing=0 ; examples=5, 3, 0

Pouteria.fossicola: integer ; missing=0 ; examples=0

Pouteria.reticulata: integer ; missing=0 ; examples=5, 7, 3

Pouteria.stipitata: integer ; missing=0 ; examples=0, 1

Prioria.copaifera: integer ; missing=0 ; examples=13, 12

Protium.costaricense: integer ; missing=0 ; examples=5, 4, 1

Protium.panamense: integer ; missing=0 ; examples=2, 0

Protium.tenuifolium: integer ; missing=0 ; examples=11, 8, 3

Pseudobombax.septenatum: integer ; missing=0 ; examples=0

Psidium.friedrichsthalianum: integer ; missing=0 ; examples=0

Psychotria.grandis: integer ; missing=0 ; examples=0

Pterocarpus.rohrii: integer ; missing=0 ; examples=1, 0

Quararibea.asterolepis: integer ; missing=0 ; examples=11, 12, 15

Quassia.amara: integer ; missing=0 ; examples=0

Randia.armata: integer ; missing=0 ; examples=3, 2, 1

Sapium.broadleaf: integer ; missing=0 ; examples=0

Sapium.glandulosum: integer ; missing=0 ; examples=0, 1

Schizolobium.parahyba: integer ; missing=0 ; examples=0

Senna.dariensis: integer ; missing=0 ; examples=0

Simarouba.amara: integer ; missing=0 ; examples=14, 6, 16

Siparuna.guianensis: integer ; missing=0 ; examples=3, 2, 1

Siparuna.pauciflora: integer ; missing=0 ; examples=0, 1

Sloanea.terniflora: integer ; missing=0 ; examples=1, 0, 2

Socratea.exorrhiza: integer ; missing=0 ; examples=15, 22, 31

Solanum.hayesii: integer ; missing=0 ; examples=0

Sorocea.affinis: integer ; missing=0 ; examples=1

Spachea.membranacea: integer ; missing=0 ; examples=0

Spondias.mombin: integer ; missing=0 ; examples=1, 0

Spondias.radlkoferi: integer ; missing=0 ; examples=2, 0, 3

Sterculia.apetala: integer ; missing=0 ; examples=1, 2, 0

Swartzia.simplex.var.grandiflora: integer ; missing=0 ; examples=3, 0

Swartzia.simplex.continentalis: integer ; missing=0 ; examples=1, 4, 2

Symphonia.globulifera: integer ; missing=0 ; examples=0, 1

Handroanthus.guayacan: integer ; missing=0 ; examples=1, 0

Tabebuia.rosea: integer ; missing=0 ; examples=1, 2

Tabernaemontana.arborea: integer ; missing=0 ; examples=9, 5, 6

Tachigali.versicolor: integer ; missing=0 ; examples=6, 1, 3

Talisia.nervosa: integer ; missing=0 ; examples=0

Talisia.princeps: integer ; missing=0 ; examples=1, 0

Terminalia.amazonia: integer ; missing=0 ; examples=1, 0

Terminalia.oblonga: integer ; missing=0 ; examples=0

Tetragastris.panamensis: integer ; missing=0 ; examples=5, 7, 10

Tetrathylacium.johansenii: integer ; missing=0 ; examples=0

Theobroma.cacao: integer ; missing=0 ; examples=1, 0

Thevetia.ahouai: integer ; missing=0 ; examples=0

Tocoyena.pittieri: integer ; missing=0 ; examples=0, 1

Trattinnickia.aspera: integer ; missing=0 ; examples=3, 1

Trema.micrantha: integer ; missing=0 ; examples=0

Trichanthera.gigantea: integer ; missing=0 ; examples=0

Trichilia.pallida: integer ; missing=0 ; examples=0, 1

Trichilia.tuberculata: integer ; missing=0 ; examples=18, 27, 28

Trichospermum.galeottii: integer ; missing=0 ; examples=0

Triplaris.cumingiana: integer ; missing=0 ; examples=0

Trophis.caucana: integer ; missing=0 ; examples=2, 0

Trophis.racemosa: integer ; missing=0 ; examples=1, 0

Turpinia.occidentalis: integer ; missing=0 ; examples=0, 1

Unonopsis.pittieri: integer ; missing=0 ; examples=1, 5, 12

Virola.multiflora: integer ; missing=0 ; examples=0

Virola.sebifera: integer ; missing=0 ; examples=17, 12, 11

Virola.surinamensis: integer ; missing=0 ; examples=4, 3, 2

Vismia.baccifera: integer ; missing=0 ; examples=0

Vochysia.ferruginea: integer ; missing=0 ; examples=0

Xylopia.macrantha: integer ; missing=0 ; examples=1, 0

Zanthoxylum.ekmanii: integer ; missing=0 ; examples=3, 4, 8

Zanthoxylum.juniperinum: integer ; missing=0 ; examples=0, 1

Zanthoxylum.panamense: integer ; missing=0 ; examples=2

Zanthoxylum.setulosum: integer ; missing=0 ; examples=0

Zuelania.guidonia: integer ; missing=0 ; examples=0

Examples
Run this code

     data(BCI, BCI.env)
     head(BCI.env)
     ## see changed species names
     oldnames <- attr(BCI, "original.names")
     taxa <- cbind("Old Names" = oldnames, "Current Names" = names(BCI))
     noquote(taxa[taxa[,1] != taxa[,2], ])

