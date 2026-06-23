# Guide — Objets `sf` et unification spatiale des jeux de données

Référence : *Geocomputation with R* (R. Lovelace, J. Nowosad, J. Muenchow),
exemplaire local `corpus/papers/raw_pdf/Geocomputation-with-R.pdf`
(§2.2 *Simple features*, §5.2.2 *Centroids / point on surface*, ch. 7
*Reprojecting geographic data*).

Ce document explique ce qu'est un objet `sf`, les opérations utiles, et la
convention d'unification adoptée pour le projet. Il sert de référence au script
`Code_scrapping/r_catalog/build_sf_datasets.R`.

---

## 1. Qu'est-ce qu'un objet `sf` ?

Un objet `sf` est un `data.frame` classique auquel s'ajoute **une colonne
géométrie « collante »** (classe `sfc`, *simple feature column*). Chaque cellule
de cette colonne est une géométrie unitaire (classe `sfg` : un point, un
polygone, etc.). La colonne `sfc` porte aussi le **système de coordonnées
(CRS)**.

Points clés du livre (§2.2) :

- On peut voir un `sf` comme un **« spatial data.frame »** : on manipule les
  attributs comme dans un `data.frame` ordinaire, la géométrie suit.
- Comportement *sticky* : la géométrie reste attachée lors des `[`, `subset`,
  `dplyr::filter`, etc. Pour obtenir le tableau d'attributs **sans** géométrie,
  on utilise explicitement `sf::st_drop_geometry()`.
- Simple Features est un standard OGC ; 17 types existent, 7 sont courants
  (`POINT`, `MULTIPOINT`, `LINESTRING`, `MULTILINESTRING`, `POLYGON`,
  `MULTIPOLYGON`, `GEOMETRYCOLLECTION`).

```r
library(sf)
class(monsf)              # "sf" "data.frame"
st_geometry_type(monsf)   # type(s) de géométrie
st_crs(monsf)             # CRS (NA si inconnu)
st_drop_geometry(monsf)   # data.frame d'attributs seul
```

---

## 2. Créer un `sf` selon les trois cas du projet

### Cas A — coordonnées seules (pas de géométrie)
```r
sf_obj <- st_as_sf(df, coords = c("x", "y"), crs = crs_natif, remove = FALSE)
# remove = FALSE garde les colonnes x/y d'origine
```

### Cas B — géométrie déjà présente
- Objet déjà `sf` : rien à faire.
- Objet `sp` (`Spatial*`, hérité) : `st_as_sf(obj)`.
- Fichier spatial (`.geojson`, `.gpkg`, `.shp`, `.parquet`) : `st_read(chemin)`.
- Colonne WKT texte : `st_as_sf(df, wkt = "geometry", crs = crs_natif)`.

### Cas C — grille
```r
grille <- st_make_grid(emprise, cellsize = pas)   # crée les cellules
# ou conversion d'un raster :  terra::as.polygons(rast) |> st_as_sf()
```

Si aucun de ces cas n'est applicable (ni géométrie, ni coordonnées, ni grille),
le jeu est **rejeté comme non convertible** : sans géométrie, il ne pourra pas
être utilisé en modélisation spatiale.

---

## 3. Dériver la géométrie point (cœur de la convention)

Objectif : chaque jeu doit avoir, en plus de sa géométrie d'origine, **une
géométrie point** et **deux colonnes de coordonnées** (axes X/Y).

Règles (issues du livre §5.2.2) :

| Géométrie d'origine | Géométrie point dérivée | Fonction |
|---------------------|-------------------------|----------|
| Grille / cellules   | centroïde de la cellule | `st_centroid()` |
| Polygone / multipolygone | point garanti **à l'intérieur** | `st_point_on_surface()` |
| Point / multipoint  | le point lui-même       | (inchangé / `st_centroid` si multipoint) |

Pourquoi `st_point_on_surface()` pour les polygones et non le centroïde : le
livre montre (Figure 5.3) que **le centroïde peut tomber hors du polygone**
(forme en « donut », multipolygone d'îles). `st_point_on_surface()` garantit que
le point est dans l'objet parent — indispensable pour étiqueter/relier
correctement.

```r
geom_point <- switch(
  famille,
  polygone = st_point_on_surface(st_geometry(sf_obj)),
  grille   = st_centroid(st_geometry(sf_obj)),
  point    = st_geometry(sf_obj)
)
```

---

## 4. Extraire les coordonnées X/Y

`st_coordinates()` renvoie la matrice des coordonnées de la géométrie point ;
on la colle comme deux colonnes standardisées (`X`, `Y`).

```r
xy <- st_coordinates(geom_point)
sf_obj$X <- xy[, 1]
sf_obj$Y <- xy[, 2]
```

On obtient ainsi le data.frame « sûr d'avoir XY dedans » : après
`st_drop_geometry()`, `X` et `Y` restent disponibles pour les statistiques et
la modélisation.

---

## 5. Conserver à la fois la géométrie d'origine et le point

Un `sf` n'a **qu'une géométrie active** à la fois, mais peut **stocker plusieurs
colonnes `sfc`**. On garde donc les deux et on choisit l'active :

```r
sf_obj$geom_origine <- st_geometry(sf_obj)   # polygone/grille d'origine
sf_obj$geom_point   <- geom_point            # point dérivé
st_geometry(sf_obj) <- "geom_point"          # le point devient l'actif par défaut
```

La géométrie d'origine (polygone/grille) reste nécessaire **plus tard** pour les
matrices de voisinage/contiguïté (impossibles sur des points ; possibles sur
polygones et grilles).

---

## 6. CRS et projection (différé)

Dans cette première passe, on **n'effectue pas** la reprojection : on se contente
d'**enregistrer** le CRS natif et un drapeau indiquant s'il est métrique.

```r
crs_txt      <- st_crs(sf_obj)$input          # ex. "EPSG:4326"
est_projete  <- isFALSE(st_is_longlat(sf_obj)) # TRUE si déjà en mètres
```

La reprojection vers le CRS métrique de la zone (ch. 7 du livre, `st_transform()`)
fera une **étape dédiée** ultérieure, sur les jeux marqués non projetés (degrés).

---

## 7. Dimension temporelle

Pas d'objet spatio-temporel (`stars`, `spacetime`). Si le jeu a une colonne
temporelle, on la copie dans une variable de nom **`T`** ; l'objet reste un `sf`
simple :

```r
if (!is.null(col_temps)) sf_obj[["T"]] <- sf_obj[[col_temps]]
```

Convention finale : un jeu = un `sf` spatial, éventuellement **+ variable `T`**.

---

## 8. Forme finale unifiée d'un jeu

Chaque jeu retenu devient un `sf` avec :

1. `geom_point` (géométrie active) + `geom_origine` (polygone/grille si dispo) ;
2. colonnes de coordonnées `X`, `Y` ;
3. les attributs d'origine (dont la/les variable(s) réponse et covariables) ;
4. éventuellement la variable temporelle `T` ;
5. métadonnées enregistrées dans l'index : CRS natif, `est_projete`,
   type de géométrie d'origine, `n`, `k`, présence d'une formule, type de
   réponse (continu/discret), statut `utilisable`.

---

## 9. Opérations `sf` de référence (mémo)

| Besoin | Fonction `sf` |
|--------|---------------|
| Construire depuis coordonnées | `st_as_sf(df, coords=…)` |
| Lire un fichier spatial | `st_read()` |
| Convertir un objet `sp` | `st_as_sf()` |
| Type de géométrie | `st_geometry_type()` |
| Centroïde | `st_centroid()` |
| Point garanti intérieur | `st_point_on_surface()` |
| Extraire X/Y | `st_coordinates()` |
| Lire / poser le CRS | `st_crs()` |
| Tester degrés vs mètres | `st_is_longlat()` |
| Reprojeter (étape ultérieure) | `st_transform()` |
| Attributs sans géométrie | `st_drop_geometry()` |
| Fabriquer une grille | `st_make_grid()` |

---

## 10. Statistiques visées (sur les jeux unifiés)

Une fois les jeux au format `sf`, on produit des comptages sur : `N` (par
tranches de taille), `K`, présence d'une formule, présence d'une géométrie
(toujours vraie par construction après filtrage), et **type de réponse
continu vs discret** (les continus étant convertibles en discret — d'où
l'importance de compter les continus).
