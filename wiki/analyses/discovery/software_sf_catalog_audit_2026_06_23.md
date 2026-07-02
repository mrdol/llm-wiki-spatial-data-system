---
title: Synthèse du catalogue spatial et des objets sf
type: analysis
created: 2026-06-23
updated: 2026-06-24
sources:
  - data/Final_datasets/sf/catalogue_sf_index.RData
  - data/Final_datasets/sf/catalogue_sf_metadata_audit.RData
  - .kg/graph.sqlite
tags: [datasets, sf, crs, spatiotemporal, knowledge-graph, benchmark]
---

# Synthèse du catalogue spatial et des objets `sf`

Dernière mise à jour : 24 juin 2026

> Mise à jour du 24 juin 2026 : le catalogue Python a été reclassé avec des
> critères de modélisation plus stricts. Le nombre 232 décrit le périmètre qui
> avait servi à la conversion `sf` initiale ; il ne représente plus le nombre
> courant de bons candidats dans le catalogue unifié.

## Mise à jour du catalogue Python et du catalogue unifié

La classification Python exige désormais : une dimension spatiale, au moins
10 observations, une réponse identifiable et au moins deux covariables. Les
contours, masques et couches de référence sont déclassés comme auxiliaires.

| Catalogue Python avant dédoublonnage | Nombre |
|---|---:|
| Bons candidats spatiaux | 85 |
| Spatial simple | 72 |
| Auxiliaires ou incomplets | 75 |
| **Total** | **232** |

Après fusion et dédoublonnage R/Python, le catalogue unifié contient :

| Catégorie unifiée | Nombre |
|---|---:|
| Bons candidats spatiaux | 197 |
| Spatial simple | 202 |
| ML non spatial | 568 |
| Auxiliaires ou incomplets | 186 |
| **Total** | **1 153** |

Les 197 bons candidats se répartissent en 82 Python et 115 R. L'audit donne :

- Python : 82 sur 82 passent les critères de modélisation ;
- R : 25 passent et 90 restent à revoir.

`geodatasets::australia` est désormais classé comme géométrie de référence et
`Declasser auxiliaire`. Il ne fait plus partie des bons candidats analytiques.
L'index `sf` existant conserve néanmoins son RDS, car il a été construit avec
l'ancienne sélection. Il devra être régénéré après la correction du catalogue R.

## 1. Périmètre initial

Le catalogue combiné R et Python contient **232 candidats spatiaux** retenus pour
la préparation des objets `sf`.

La décomposition actuelle est la suivante :

| Statut | Nombre | Interprétation |
|---|---:|---|
| Objets `sf` convertis | 142 | Fichiers RDS présents et chargeables |
| Rejets de conversion | 7 | Adaptateur ou source supplémentaire nécessaire |
| Géométrie à obtenir par jointure | 51 | Pas de géométrie directement constructible |
| Doublons inter-packages retirés | 32 | Même jeu distribué par plusieurs packages |
| **Total** | **232** | |

Les 142 conversions correspondent à **142 fichiers RDS distincts**. Les objets
portant le même libellé, notamment les quatre variantes de `gstat::jura` et les
deux variantes de `surveillance::hagelloch`, sont distingués par leur
`record_id`.

## 2. Jeux actuellement prêts

Les **142 objets `sf` prêts** se répartissent ainsi :

| Dimension | Répartition |
|---|---|
| Langage source | 59 R, 83 Python |
| Famille géométrique cataloguée | 84 polygonaux, 58 ponctuels |
| Réponse connue | 87 |
| Formule identifiée | 16 |
| CRS présent dans le fichier avant audit | 91 |
| Dimension temporelle confirmée après audit | 8 |

Le terme *prêt* signifie ici que le fichier existe, peut être chargé avec
`readRDS()` et contient une géométrie `sf`. Cela ne signifie pas que toutes les
métadonnées sont complètes ni que le jeu est immédiatement adapté à tous les
modèles spatiaux.

Exemple de chargement :

```r
load("data/Final_datasets/sf/catalogue_sf_index.RData")

chemin <- index_sf$sf_path[index_sf$utilisable == "TRUE"][1]
dataset_sf <- readRDS(chemin)

dataset_sf
sf::st_crs(dataset_sf)
plot(sf::st_geometry(dataset_sf))
```

## 3. Rôle du CRS

Un objet sans CRS peut être affiché isolément, car R peut tracer ses coordonnées
XY. En revanche, l’absence de CRS empêche de savoir de façon fiable :

- où se trouve le jeu sur Terre ;
- si les coordonnées sont exprimées en degrés, mètres ou unités locales ;
- comment le superposer à une autre couche ou à un fond de carte ;
- comment le reprojeter ;
- comment calculer des distances, surfaces ou buffers avec des unités correctes ;
- comment construire des voisinages fondés sur une distance métrique.

Les voisinages polygonaux de type reine ou tour reposent principalement sur la
topologie. Ils peuvent parfois être calculés sans CRS, mais un CRS reste
nécessaire pour contrôler la cohérence géographique et combiner les données avec
d'autres couches.

Il ne faut jamais affecter automatiquement `EPSG:4326` sur la seule base d'une
bbox compatible avec des longitudes et latitudes.

## 4. Audit des 51 CRS absents

Un audit conservateur a été exécuté sur les 51 objets dont le CRS n'était pas
renseigné. Il examine :

1. les différentes colonnes géométriques du RDS ;
2. l'objet source du package R ;
3. les fichiers et éventuels fichiers `.prj` associés ;
4. la documentation locale du package ;
5. la bbox et les noms de coordonnées ;
6. la possibilité de transformer le CRS candidat vers EPSG:4326 ;
7. la plausibilité de l'étendue obtenue.

### Résultats

| Verdict | Nombre | Action |
|---|---:|---|
| CRS documenté, confiance élevée | 5 | Peut être appliqué après sauvegarde |
| Candidat plausible, confiance moyenne | 7 | Revue supplémentaire avant application |
| Bbox seule, confiance faible | 7 | Ne pas appliquer |
| CRS inconnu | 30 | Documentation ou source externe requise |
| Coordonnées à corriger | 1 | Corriger avant attribution du CRS |
| Fausse détection spatiale | 1 | Ne pas attribuer de CRS |
| **Total** | **51** | |

### CRS confirmés

| Dataset | CRS confirmé | Source de preuve |
|---|---|---|
| `spDataLarge::lsl` | EPSG:32717 | Documentation du package |
| `GWmodel::LondonHP` | EPSG:27700 | Documentation du package |
| `gstat::DE_RB_2005` | EPSG:32632 | Documentation du package |
| `sp::meuse` | EPSG:28992 | Documentation du package |
| `sp::meuse.grid` | EPSG:28992 | Documentation du package |

Les cinq transformations de contrôle vers EPSG:4326 ont produit des étendues
géographiques plausibles.

Après cet audit :

- 91 jeux possèdent déjà un CRS dans leur RDS ;
- 5 CRS supplémentaires sont vérifiés ;
- **96 jeux disposent donc d'un CRS présent ou vérifié** ;
- 46 jeux restent sans CRS suffisamment prouvé.

Les propositions moyennes n'ont pas été écrites dans les fichiers RDS.

### Cas particuliers

- Les variantes géographiques de `gstat::jura` sont compatibles avec
  EPSG:4326, mais les variantes `prediction.dat` et `validation.dat` utilisent
  un système local sans EPSG suffisamment documenté.
- `agridat::usgs.herbicides` stocke les longitudes ouest avec un signe positif.
  Les longitudes doivent être corrigées avant d'utiliser EPSG:4326.
- `agridat::ortiz.tomato.covs` est une fausse détection spatiale : la variable
  `Day` représente des degrés-jours et les axes détectés ne constituent pas une
  paire longitude/latitude.

## 5. Audit temporel

Le catalogue signalait initialement **26 jeux spatio-temporels**. L'audit a
comparé la variable normalisée `T` avec les colonnes originales, leurs noms,
leurs classes et la documentation du jeu.

### Résultat corrigé

| Verdict | Nombre |
|---|---:|
| Temporel confirmé, `T` exploitable | 7 |
| Temporel confirmé, `T` à reconstruire | 1 |
| Faux positif | 16 |
| Faux positif dû à une structure large | 1 |
| Faux positif dû aux degrés-jours | 1 |
| **Total** | **26** |

Les **8 jeux réellement temporels** sont :

- `gstat::DE_RB_2005` ;
- `surveillance::hagelloch` ;
- `spatstat.data::nbfires` ;
- `agridat::gartner.corn` ;
- `agridat::lasrosas.corn` ;
- `agridat::usgs.herbicides` ;
- `geodatasets::home_sales` ;
- `libpysal::SanFran Crime`.

Pour `libpysal::SanFran Crime`, la dimension temporelle est réelle, mais `T`
doit être reconstruite à partir de `Date` et `Time` plutôt qu'à partir de
`DayOfWeek`.

### Faux positif de `pol_pres15`

`spDataLarge::pol_pres15` avait été déclaré temporel parce que le catalogue
avait classé `I_candidates_total` comme colonne temporelle. La variable `T`
recopiait donc une variable électorale et non une date.

Le jeu contient néanmoins deux tours électoraux dans des colonnes larges :

- `I_*` pour le premier tour ;
- `II_*` pour le second tour.

Il peut devenir un jeu à deux périodes après une restructuration explicite au
format long, mais il ne doit pas être considéré comme temporel dans son état
actuel.

## 6. Intersection des critères de qualité

Les catégories R/Python et point/polygone sont alternatives et ne doivent pas
être utilisées comme critères simultanés.

L'intersection étudiée est donc :

- fichier `sf` prêt ;
- CRS présent ou documenté ;
- réponse connue ;
- formule disponible ;
- dimension temporelle réelle.

Avant validation manuelle, le KG retournait un candidat :
`spDataLarge::pol_pres15`.

Après correction du faux positif temporel, **aucun jeu ne coche simultanément
tous les critères**.

Sans imposer le critère temporel, `spDataLarge::pol_pres15` reste le seul jeu
polygonal qui combine actuellement CRS, réponse connue et formule documentée.

## 7. Jeu retenu pour le benchmark spatial

Le jeu proposé pour le premier benchmark est :

```text
spDataLarge::pol_pres15
```

### Raisons du choix

- 2 495 unités territoriales polonaises ;
- géométrie originale `MULTIPOLYGON` valide ;
- CRS EPSG:2180, projeté en mètres ;
- identifiant `TERYT` unique ;
- aucune géométrie vide ;
- réponse `I_turnout` sans valeur manquante ;
- deux tours électoraux pouvant être restructurés au format long ;
- taille suffisante pour comparer plusieurs méthodes spatiales.

Le fichier RDS utilise les centroïdes comme géométrie active. La géométrie
polygonale d'origine est conservée dans `geom_origine` et doit être réactivée
pour construire les voisinages de contiguïté :

```r
pol_pres15 <- readRDS(
  "data/final_datasets/sf/R_spDataLarge_pol_pres15_pol_pres15.rds"
)

sf::st_geometry(pol_pres15) <- "geom_origine"
pol_pres15 <- sf::st_make_valid(pol_pres15)
```

### Voisinages déjà testés

| Matrice | Arêtes | Voisins moyens | Îles | Maximum |
|---|---:|---:|---:|---:|
| Reine | 7 121 | 5,71 | 0 | 13 |
| Tour | 7 104 | 5,69 | 0 | 13 |

Ces résultats confirment que les 2 495 polygones forment un graphe de voisinage
sans unité isolée.

## 8. Protocole proposé pour le benchmark

Le benchmark pourra être organisé de la manière suivante :

1. charger le RDS et réactiver `geom_origine` ;
2. contrôler la validité et l'unicité de `TERYT` ;
3. supprimer la variable `T` erronée ;
4. restructurer les colonnes `I_*` et `II_*` au format long si l'analyse des
   deux tours est retenue ;
5. produire les cartes choroplèthes, distributions et diagnostics de valeurs
   manquantes ou atypiques ;
6. construire les voisinages reine, tour, k plus proches voisins et distance ;
7. standardiser les matrices de poids ;
8. calculer Moran global, Geary et les indicateurs locaux LISA ;
9. ajuster un modèle non spatial de référence ;
10. comparer SAR, SEM et SDM ;
11. utiliser une validation croisée spatiale par blocs ;
12. comparer RMSE, MAE, R² et autocorrélation spatiale des résidus.

## 9. Knowledge graph

Le KG a été reconstruit après les audits.

Il contient notamment :

- 149 entrées de conversion `sf` ;
- 142 datasets marqués `sf_ready = TRUE` ;
- 142 chemins RDS distincts et présents ;
- les verdicts de l'audit CRS ;
- les CRS candidats et leur niveau de confiance ;
- les verdicts temporels corrigés ;
- les liens vers les réponses, formules, géométries et fichiers RDS.

État global du graphe lors de la dernière reconstruction :

- 34 273 nœuds ;
- 36 147 relations.

## 10. Fichiers de référence

| Contenu | Fichier |
|---|---|
| Index des conversions | `data/Final_datasets/sf/catalogue_sf_index.RData` |
| Audit CRS et temps | `data/Final_datasets/sf/catalogue_sf_metadata_audit.RData` |
| Script de conversion | `Code_scrapping/r_catalog/build_sf_datasets.R` |
| Script d'audit | `Code_scrapping/r_catalog/audit_sf_crs_time.R` |
| Extracteur KG | `tools/kg/04_extract_dataset_catalogs.py` |
| Vérification du KG | `tools/kg/verify_sf_kg.py` |
| Graphe SQLite | `.kg/graph.sqlite` |

Les objets de l'audit peuvent être examinés avec :

```r
load("data/Final_datasets/sf/catalogue_sf_metadata_audit.RData")

View(audit_crs)
View(audit_time)
synthese_audit_metadata
```

## 11. Prochaines étapes recommandées

1. appliquer les cinq CRS confirmés aux RDS concernés ;
2. reconstruire `T` pour les huit jeux temporels réellement validés ;
3. corriger la détection automatique des variables temporelles dans le pipeline ;
4. traiter les sept rejets nécessitant un adaptateur spécifique ;
5. obtenir les géométries des 51 jeux fondés sur une jointure géographique ;
6. mettre en œuvre le benchmark complet sur `spDataLarge::pol_pres15`.

## Related Pages

- [[catalog_registry_schema_v3]]
