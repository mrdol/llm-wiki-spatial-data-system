# spatstat.data package help

## Package Description

- Package: spatstat.data
- Title: Datasets for 'spatstat' Family
- Version: 3.1-9
- Date: 2025-10-18
- Description: Contains all the datasets for the 'spatstat' family of packages.
- Authors@R: c(person("Adrian", "Baddeley", 
                    role = c("aut", "cre"),
       	            email = "Adrian.Baddeley@curtin.edu.au",
		    comment = c(ORCID="0000-0001-9499-8382")),
	     person("Rolf", "Turner", 
                    role = "aut",
 	            email="rolfturner@posteo.net",
		    comment=c(ORCID="0000-0001-5521-5218")),
	    person("Ege",   "Rubak", 
                    role = "aut",
		    email = "rubak@math.aau.dk",
		    comment=c(ORCID="0000-0002-6675-533X")),
            person("W", "Aherne", role="ctb"),
            person("Freda", "Alexander", role="ctb"),
            person("Qi Wei", "Ang", role="ctb"),
            person("Sourav", "Banerjee", role="ctb"),
            person("Mark", "Berman", role="ctb"),
            person("R", "Bernhardt", role="ctb"),
            person("Thomas", "Berndtsen", role="ctb"),
            person("Andrew", "Bevan", role="ctb"),
            person("Jeffrey", "Betts", role="ctb"),
            person("Ray", "Cartwright", role="ctb"),
            person("Lucia", "Cobo Sanchez", role="ctb"),
            person("Richard", "Condit", role="ctb"),
            person("Francis", "Crick", role="ctb"),
            person("Marcelino", "de la Cruz Rot", role="ctb"),
            person("Jack", "Cuzick", role="ctb"),
            person("Tilman", "Davies", role="ctb"),
            person("Peter", "Diggle", role="ctb"),
            person("Michael", "Drinkwater", role="ctb"),
            person("Stephen", "Eglen", role="ctb"),
            person("Robert", "Edwards", role="ctb"),
            person("Johannes", "Elias", role="ctb"),
            person("AE", "Esler", role="ctb"),
            person("Gregory", "Evans", role="ctb"),
            person("Bernard", "Fingleton", role="ctb"),
            person("Olivier", "Flores", role="ctb"),
            person("David", "Ford", role="ctb"),
            person("Robin", "Foster", role="ctb"),
            person("Janet", "Franklin", role="ctb"),
            person("Neba", "Funwi-Gabga", role="ctb"),
            person("DJ", "Gerrard", role="ctb"),
            person("Andy", "Green", role="ctb"),
            person("Tim", "Griffin", role="ctb"),
            person("Ute", "Hahn", role="ctb"),
            person("RD", "Harkness", role="ctb"),
            person("Arthur", "Hickman", role="ctb"),
            person("Stephen", "Hubbell", role="ctb"),
            person("Austin", "Hughes", role="ctb"),
            person("Jonathan", "Huntington", role="ctb"),
            person("MJ", "Hutchings", role="ctb"),
            person("Jackie", "Inwald", role="ctb"),
            person("Valerie", "Isham", role="ctb"),
            person("Aruna", "Jammalamadaka", role="ctb"),
            person("Carl", "Knox-Robinson", role="ctb"),
            person("Mahdieh", "Khanmohammadi", role="ctb"),
            person("Tero", "Kokkila", role="ctb"),
            person("Bas", "Kooijman", role="ctb"),
            person("Kenneth", "Kosik", role="ctb"),
            person("Peter", "Kovesi", role="ctb"),
            person("Lily", "Kozmian-Ledward", role="ctb"),
            person("Robert", "Lamb", role="ctb"),
            person("NA", "Laskurain", role="ctb"),
            person("George", "Leser", role="ctb"),
            person("Marie-Colette", "van Lieshout", role="ctb"),
            person("AF", "Mark", role="ctb"),
            person("Sebastian", "Meyer", role="ctb"),
            person("Jorge", "Mateu", role="ctb"),
            person("Annikki", "Makela", role="ctb"),
            person("Enrique", "Miranda", role="ctb"),
            person("Nicoletta", "Nava", role="ctb"),
            person("M", "Numata", role="ctb"),
            person("Matti", "Nummelin", role="ctb"),
            person("Jens Randel", "Nyengaard", role="ctb"),
            person("Yosihiko", "Ogata", role="ctb"),
            person("Si", "Palmer", role="ctb"),
            person("Antti", "Penttinen", role="ctb"),
            person("Sandra", "Pereira", role="ctb"),
            person("Nicolas", "Picard", role="ctb"),
            person("William", "Platt", role="ctb"),
            person("Stephen", "Rathbun", role="ctb"),
            person("Brian", "Ripley", role="ctb"),
            person("Roger", "Sainsbury", role="ctb"),
            person("Dietrich", "Stoyan", role="ctb"),
            person("David", "Strauss", role="ctb"),
            person("L", "Strand", role="ctb"),
            person("Masaharu", "Tanemura", role="ctb"),
            person("Graham", "Upton", role="ctb"),
            person("Bill", "Venables", role="ctb"),
            person("Ulrich", "Vogel", role="ctb"),
            person("Sasha", "Voss", role="ctb"),
            person("Rasmus", "Waagepetersen", role="ctb"),
            person("Keith", "Watkins", role="ctb"),
            person("H", "Wendrock", role="ctb")
		    )
- Author: Adrian Baddeley [aut, cre] (ORCID:
    <https://orcid.org/0000-0001-9499-8382>),
  Rolf Turner [aut] (ORCID: <https://orcid.org/0000-0001-5521-5218>),
  Ege Rubak [aut] (ORCID: <https://orcid.org/0000-0002-6675-533X>),
  W Aherne [ctb],
  Freda Alexander [ctb],
  Qi Wei Ang [ctb],
  Sourav Banerjee [ctb],
  Mark Berman [ctb],
  R Bernhardt [ctb],
  Thomas Berndtsen [ctb],
  Andrew Bevan [ctb],
  Jeffrey Betts [ctb],
  Ray Cartwright [ctb],
  Lucia Cobo Sanchez [ctb],
  Richard Condit [ctb],
  Francis Crick [ctb],
  Marcelino de la Cruz Rot [ctb],
  Jack Cuzick [ctb],
  Tilman Davies [ctb],
  Peter Diggle [ctb],
  Michael Drinkwater [ctb],
  Stephen Eglen [ctb],
  Robert Edwards [ctb],
  Johannes Elias [ctb],
  AE Esler [ctb],
  Gregory Evans [ctb],
  Bernard Fingleton [ctb],
  Olivier Flores [ctb],
  David Ford [ctb],
  Robin Foster [ctb],
  Janet Franklin [ctb],
  Neba Funwi-Gabga [ctb],
  DJ Gerrard [ctb],
  Andy Green [ctb],
  Tim Griffin [ctb],
  Ute Hahn [ctb],
  RD Harkness [ctb],
  Arthur Hickman [ctb],
  Stephen Hubbell [ctb],
  Austin Hughes [ctb],
  Jonathan Huntington [ctb],
  MJ Hutchings [ctb],
  Jackie Inwald [ctb],
  Valerie Isham [ctb],
  Aruna Jammalamadaka [ctb],
  Carl Knox-Robinson [ctb],
  Mahdieh Khanmohammadi [ctb],
  Tero Kokkila [ctb],
  Bas Kooijman [ctb],
  Kenneth Kosik [ctb],
  Peter Kovesi [ctb],
  Lily Kozmian-Ledward [ctb],
  Robert Lamb [ctb],
  NA Laskurain [ctb],
  George Leser [ctb],
  Marie-Colette van Lieshout [ctb],
  AF Mark [ctb],
  Sebastian Meyer [ctb],
  Jorge Mateu [ctb],
  Annikki Makela [ctb],
  Enrique Miranda [ctb],
  Nicoletta Nava [ctb],
  M Numata [ctb],
  Matti Nummelin [ctb],
  Jens Randel Nyengaard [ctb],
  Yosihiko Ogata [ctb],
  Si Palmer [ctb],
  Antti Penttinen [ctb],
  Sandra Pereira [ctb],
  Nicolas Picard [ctb],
  William Platt [ctb],
  Stephen Rathbun [ctb],
  Brian Ripley [ctb],
  Roger Sainsbury [ctb],
  Dietrich Stoyan [ctb],
  David Strauss [ctb],
  L Strand [ctb],
  Masaharu Tanemura [ctb],
  Graham Upton [ctb],
  Bill Venables [ctb],
  Ulrich Vogel [ctb],
  Sasha Voss [ctb],
  Rasmus Waagepetersen [ctb],
  Keith Watkins [ctb],
  H Wendrock [ctb]
- Maintainer: Adrian Baddeley <Adrian.Baddeley@curtin.edu.au>
- Depends: R (>= 3.5.0)
- Imports: spatstat.utils (>= 3.1-2), Matrix
- Suggests: spatstat.geom, spatstat.random, spatstat.explore,
spatstat.model, spatstat.linnet
- License: GPL (>= 2)
- URL: http://spatstat.org/
- BugReports: https://github.com/spatstat/spatstat.data/issues

## Help Pages

- amacrine: Hughes' Amacrine Cell Data
- anemones: Beadlet Anemones Data
- ants: Harkness-Isham ants' nests data
- austates: Australian States and Mainland Territories
- bdspots: Breakdown Spots in Microelectronic Materials
- bei: Tropical rain forest trees
- betacells: Beta Ganglion Cells in Cat Retina
- bramblecanes: Hutchings' Bramble Canes data
- bronzefilter: Bronze gradient filter data
- btb: Bovine Tuberculosis Data
- cells: Biological Cells Point Pattern
- cetaceans: Point patterns of whale and dolphin sightings.
- chicago: Chicago Crime Data
- chorley: Chorley-Ribble Cancer Data
- clmfires: Castilla-La Mancha Forest Fires
- concrete: Air Bubbles in Concrete
- copper: Berman-Huntington points and lines data
- copyExampleFiles: Copy Data Files for Example
- demohyper: Demonstration Example of Hyperframe of Spatial Data
- demopat: Artificial Data Point Pattern
- dendrite: Dendritic Spines Data
- finpines: Pine saplings in Finland.
- flu: Influenza Virus Proteins
- ganglia: Beta Ganglion Cells in Cat Retina, Old Version
- gordon: People in Gordon Square
- gorillas: Gorilla Nesting Sites
- hamster: Aherne's hamster tumour data
- heather: Diggle's Heather Data
- humberside: Humberside Data on Childhood Leukaemia and Lymphoma
- hyytiala: Scots pines and other trees at Hyytiala
- japanesepines: Japanese Pines Point Pattern
- Kovesi: Colour Sequences with Uniform Perceptual Contrast
- lansing: Lansing Woods Point Pattern
- letterR: Window in Shape of Letter R
- longleaf: Longleaf Pines Point Pattern
- meningitis: Invasive Meningococcal Disease Cases in Germany
- mucosa: Cells in Gastric Mucosa
- murchison: Murchison gold deposits
- nbfires: Point Patterns of New Brunswick Forest Fires
- nztrees: New Zealand Trees Point Pattern
- osteo: Osteocyte Lacunae Data: Replicated Three-Dimensional Point Patterns
- paracou: Kimboto trees at Paracou, French Guiana
- ponderosa: Ponderosa Pine Tree Point Pattern
- pyramidal: Pyramidal Neurons in Cingulate Cortex
- redwood: California Redwoods Point Pattern (Ripley's Subset)
- redwoodfull: California Redwoods Point Pattern (Entire Dataset)
- residualspaper: Data and Code From JRSS Discussion Paper on Residuals
- shapley: Galaxies in the Shapley Supercluster
- shelling: Artillery Impacts in Ukraine
- simba: Simulated data from a two-group experiment with replication

  within each group.
- simdat: Simulated Point Pattern
- simplenet: Simple Example of Linear Network
- spatstat.data-package: The spatstat.data Package
- spiders: Spider Webs on Mortar Lines of a Brick Wall
- sporophores: Sporophores Data
- spruces: Spruces Point Pattern
- stonetools: Palaeolithic Stone Tools
- swedishpines: Swedish Pines Point Pattern
- urkiola: Urkiola Woods Point Pattern
- vesicles: Vesicles Data
- waka: Trees in Waka national park
- waterstriders: Waterstriders data.

  Three independent replications of a point pattern

  formed by insects.

## Package Rd Help

The spatstat.data Package

Description

     The 'spatstat.data' package contains the datasets for the
     'spatstat' family of packages.

Details

     The 'spatstat.data' package contains the datasets for the
     'spatstat' family of packages.

     These are spatial datasets; they are objects belonging to classes
     of spatial data defined in other sub-packages of the 'spatstat'
     family.  In order to handle these datasets correctly, we recommend
     loading the 'spatstat' package.

Licence:

     This library and its documentation are usable under the terms of
     the "GNU General Public License", a copy of which is distributed
     with R.

Author(s):

     Adrian Baddeley <mailto:Adrian.Baddeley@curtin.edu.au>, Rolf
     Turner <mailto:rolfturner@posteo.net> and Ege Rubak
     <mailto:rubak@math.aau.dk>.

