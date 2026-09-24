# Cas d'application : marrot (methode documentee) et stwr (noyau CV, non reconstructible exactement)

Suite du [README](README.md) apres [Hainan/li_energy](cas_hainan_li_energy_2026-09-10.md)
et [le lot ecologique](cas_ecologiques_batch1_2026-09-22.md). Trouves en
lisant les TEI associes aux fiches Tier B/C (`corpus/papers/tei/`), pas
identifies au premier passage (recherche par titre flou insuffisante,
corrigee par une recherche par DOI dans le contenu -- voir discussion en
session).

Scripts : `code/r_catalog/build_marrot_panel_W.R`,
`build_stwr_precip_isotope_panel_W.R`. Sorties :
`data/final_datasets/weights/paper_{marrot_spatial_autocorrelation_fitness,
stwr_precip_isotope}_W.rds`.

## `paper_marrot_spatial_autocorrelation_fitness` (Marrot, Garant & Charmantier 2015, MEE)

**Seul cas de ce lot ou la methode de construction de W est explicitement
documentee par les auteurs** (Cas 1 du README : seuil de distance) :
"Truncate this distance matrix at a distance of a threshold value t [...]
t is generally chosen as the minimum distance that maintains all sampling
units connected using a minimum spanning tree algorithm (Borcard, Gillet &
Legendre 2011)."

Reconstruction : distance euclidienne (geodesique, `sf::st_distance`) entre
les 140 nichoirs distincts (position stable verifiee), seuil t = plus
grande arete de l'arbre couvrant minimal (algorithme de Prim implemente
directement sur la matrice de distance, calcul objectif, pas une valeur
choisie) = **254.1 m**. Graphe de voisinage au seuil t, row-standardized.
Cardinalite 2-29 voisins/nichoir, 1 seule composante connexe (par
construction de l'arbre couvrant minimal).

**Reserve** : ce seuil est documente pour leur modele PCNM ; leur modele
SAR cite "a spatial weight matrix" (Lichstein et al. 2002) sans reconfirmer
une construction distincte -- hypothese retenue que le meme seuil sert de
base aux deux, non confirmee explicitement pour le cas SAR dans le texte
lu.

## `paper_stwr_precip_isotope` (Que et al. 2020, GMD -- papier STWR v1.0 lui-meme)

Le TEI **confirme qu'il s'agit exactement de l'etude de cas empirique du
papier** (116 sites, nord-est des Etats-Unis, 3 jours 29-31 oct. 2012,
"272 points for model calibration", modele `y = b0 + b1*ppt + b2*tmean +
b3*height + e`) -- correspondance verifiee ligne a ligne avec l'artefact
local (116 sites distincts, 3 timestamps, N=272).

Mais leur ponderation n'est pas une W statique : noyau continu
spatio-temporel (Gaussian ou bisquare, papier ne precise pas lequel pour
cette etude de cas), **bande passante optimisee par validation croisee**
("we use cross-validation (CV) as the default searching criteria") --
non reconstructible sans reexecuter entierement leur procedure
d'optimisation, hors perimetre d'une session (consigne de l'encadrant).

Construction retenue : kNN k=8 (defaut du projet, `spatial_knn_args()`) sur
les 116 sites distincts -- **specification projet informee par la forme
generale de leur noyau (adaptatif), pas une reconstruction de leur bande
passante**. 1 seule composante connexe.

## Statut

Les deux W sont plausibles et documentees, mais avec des niveaux de
confiance differents :
- `marrot` : methode de construction reconstruite fidelement (regle
  objective, documentee par les auteurs pour leur usage PCNM).
- `stwr` : jeu de donnees confirme identique, mais W elle-meme non
  reconstructible (bande passante CV) -- specification projet.

Aucune des deux n'est verifiee contre une valeur publiee (SAR/GWR) faute de
sortie numerique comparable directement extraite du texte. Ne servent pas
de base a une promotion `package_include` tant que le wiring complet
(section `### Panel spatial - structure et W` sur chaque fiche) n'est pas
fait.
