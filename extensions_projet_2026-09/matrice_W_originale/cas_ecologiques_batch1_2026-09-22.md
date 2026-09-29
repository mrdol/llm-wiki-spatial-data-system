# Cas d'application : 3 jeux ecologiques (Chicago, Midwest, Portugal)

Suite du [README](README.md) apres le cas [Hainan/li_energy](cas_hainan_li_energy_2026-09-10.md).
Contrairement a `li_energy` et `wald_test` (papier d'econometrie spatiale
avec W declaree), aucun des 3 papiers source ici n'utilise de matrice de
poids SAR/SEM classique -- les 3 W construites sont donc des
**specifications geographiques inventees par le projet**, pas des
reconstructions de la methode des auteurs. Aucune valeur publiee de type
SAR/SEM n'existe pour juger leur plausibilite (contrairement a Hainan, ou
les elasticites publiees servaient de repere).

Scripts : `code/r_catalog/build_influenza_chicago_panel_W.R`,
`build_midwest_crop_yield_panel_W.R`, `build_portugal_covid_municipal_panel_W.R`.
Sorties : `data/final_datasets/weights/paper_{influenza_mortality_chicago,
midwest_crop_yield, portugal_covid_municipal}_W.rds`.

## `paper_influenza_mortality_chicago` (Grantz et al. 2016, PNAS)

Contiguite reine standard sur `geom_origine` (496 census tracts, `GISJOIN`).
1 seule composante connexe, aucun isolat -- cas propre, aucun patch
necessaire.

## `paper_midwest_crop_yield` (Park, Li & Li 2022, JASA)

**Pas une reconstruction geometrique** : le supplement JASA
(`MidwestData.RData`) fournit `dist.mat`, la matrice de distance (km)
inter-comtes **des auteurs eux-memes**, verifiee (symetrique, diagonale
nulle), ordonnee sur `CountyI.info` (403 comtes). W construite en k=8 plus
proches voisins sur cette distance (k = defaut du projet, voir
`spatial_knn_args()`), pas une reproduction de leur noyau bayesien
spatialement variable (BSVFM) mais fondee sur une source de distance
fidele aux auteurs -- plus solide qu'une reconstruction par geometrie
rejointe.

Deux points trouves en verifiant avant de construire :
- **`county_key` (nom de comte seul) n'est pas un identifiant unique** --
  "Adair" existe a la fois en Iowa et dans le Missouri. Utiliser
  `State`+`CountyI` (ou `CountyI` seul, identifiant numerique des auteurs).
  Bug potentiellement plus large que ce chantier W si `county_key` sert
  ailleurs dans le pipeline -- a signaler separement.
- **Lake County (Illinois)** ressortait isole en contiguite reine (verifie
  non-artefact de topologie : toujours isole avec `snap=1000m`) -- ses
  vrais voisins geographiques (Cook County IL, Wisconsin) sont hors
  perimetre des 403 comtes de l'etude. Le kNN sur `dist.mat` resout ce cas
  nativement (k=8 parmi les 403, sans notion de contiguite), aucun patch
  special necessaire contrairement a Hainan/li_energy.

## `paper_portugal_covid_municipal` (Barbosa et al. 2022, Geospatial Health)

Le papier utilise N=278 municipalites continentales (Acores/Madere exclus,
donnees indisponibles pour les auteurs) ; l'artefact local en contient 298
(jointure geoBoundaries PRT/ADM2, deja documente dans la fiche). Construction
demandee sur les 298, pas le sous-ensemble continental.

Contiguite reine -> 12 composantes connexes : 1 bloc continental (271
communes), plusieurs sous-reseaux internes aux archipeles (Acores/Madere,
tailles 9/5/3/2/2 -- iles reellement voisines entre elles dans le
shapefile) et **6 communes a degre zero** (Angra do Heroismo, Corvo, Horta,
Porto Santo, Santa Cruz da Graciosa, Vila do Porto). Ce n'est pas un
artefact : Acores/Madere n'ont reellement aucune frontiere avec le
continent ni, pour ces 6, avec une autre commune de leur propre archipel.

Traitement : **patch uniquement les 6 degre-zero**, kNN=1 par distance de
centroide verifiee (ex. Corvo -> Santa Cruz das Flores, 26.7 km ; Vila do
Porto -> Povoacao, 89.6 km) -- la separation continent/Acores/Madere et les
sous-reseaux internes aux archipels restent intacts (contiguite geographique
reelle, pas une lacune). 6 composantes connexes apres patch (jamais 1, par
construction).

**Anomalie trouvee, non corrigee ici** : la commune "LAGOA" a l'attribut
`distrito="ACORES"` alors que sa geometrie est bien en Algarve continental
(bbox verifiee : x=[-8.53,-8.37], y=[37.10,37.19]) -- collision de nom avec
la vraie Lagoa acorienne (Sao Miguel). N'affecte pas cette W (fondee sur la
geometrie, pas le label), mais reste un bug d'attribut a signaler si
`distrito`/`ars` sert de covariable ou de filtre ailleurs.

## `paper_usgs_flood_skew` -- retire du chantier

Verifie (session 2026-09-22) : **ce n'est pas un panel**. 183 stations, une
ligne chacune (`site_no`/`IndexNo` uniques) ; `T` = `BegYear`, une
covariable d'annee de debut d'enregistrement historique par station, pas un
index temporel repete. Deja `benchmark_status: "ready"`,
`package_include: "yes"`, `benchmark_task: "regression_continuous"` --
traite correctement en coupe transversale par le harnais principal. Le tag
`Structure: panel_ou_series` de son Bloc 4 est une erreur de classification
sans consequence fonctionnelle (juste une incoherence de metadonnee),
puisque le jeu n'a jamais transite par le harnais panel.

## Statut

Reconstructions plausibles, non prouvees identiques a une quelconque
reference (aucune des 3 n'existe cote auteurs). Ne servent pas de base a
une promotion `package_include` tant que le wiring complet (section
`### Panel spatial - structure et W` sur chaque fiche, cf.
`paper_li_energy_price_co2_china`) n'est pas fait.
