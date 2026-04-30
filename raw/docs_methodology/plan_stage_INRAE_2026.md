# Plan de travail détaillé — Stage INRAE 2026

**Constitution d'une banque de données spatio-temporelles de référence**  
*Étudiant M2 Data Science / Économétrie-ML · Encadrant : Ghislain Geniaux*  
*Durée : 6 mois · Début : 1 Avril · INRAE Avignon, unité Ecodéveloppement*

---

## Cadrage préliminaire (Semaines 1–2)

- Installation environnement R / Python / Git / Codex DONE
- Prise en main des entrepôts cibles (Zenodo, Dryad, OpenAlex, Copernicus…)
- Lecture des références clés + revue sur le format datapaper (*Scientific Data*, *Data in Brief*, *Geoscience Data Journal*)
- Prise en main des outils de scraping (Scrapy, Playwright, APIs Semantic Scholar, OpenAlex, Crossref, Unpaywall)

<span style="color:red; font-weight:bold">
1_cadrage_preliminaire.md décrit l'avanvement.
Rajouter spatial et spatio-temporel et pertinence dans les tableau avec une évaluation de 1 à 4, facilité d'usage. Durant cette phase d'évaluation identifier 3 à 4 jeux de données spatial + spatial_temporel. Faire un tableau de description générique de ces jeux
type endogène , size n - T , résolution spatiale - temporelle, problématique et enjeux méthodologique, covariates, source (url), citation, estimateur,
</span>

---

## Phase 0 — Conception de la typologie des jeux de données cibles (Semaines 2–4)

C'est la **phase de design du benchmark**, conduite en collaboration étroite avec
l'encadrant. Elle produit le **document de référence** qui guide l'intégralité des
phases suivantes. Aucune collecte ne commence avant que cette typologie soit validée.

### Objectif

Définir formellement l'espace de diversité que la banque doit couvrir selon plusieurs
axes orthogonaux, de façon à ce que l'ensemble des datasets collectés constitue un
**plan d'expérience cohérent** — et non une accumulation opportuniste de sources.

---

### Axe 1 — Domaines thématiques

| Code | Domaine                                        | Exemples de variables réponse                                                                                                                                                                |
|------|------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IMM  | Marchés immobiliers                            | Prix de vente, loyers, rendements locatifs                                                                                                                                                   |
| AGR  | Agriculture / rendements                       | Rendement céréalier, surface cultivée, NDVI                                                                                                                                                  |
| ECO  | Écologie / biodiversité                        | Richesse spécifique, abondance, présence/absence                                                                                                                                             |
| ENV  | Environnement / pollution                      | PM2.5, NO₂, nitrates, indice de qualité de l'air                                                                                                                                             |
| CLI  | Climat / météorologie                          | Température, précipitations, anomalies thermiques                                                                                                                                            |
| EPI  | Épidémiologie / santé                          | Incidence, mortalité, hospitalisations, vaccination                                                                                                                                          |
| PHY  | Épidémio-surveillance des maladies des plantes | Taux d'incidence parcellaire, prévalence de pathogènes fongiques/bactériens/viraux, intensité d'attaque (échelle ordinale), date de premier foyer détecté, vitesse de propagation épidémique |
| ECN  | Économie régionale                             | PIB/habitant, chômage, inégalités, flux navetteurs                                                                                                                                           |
| SOC  | Sciences sociales / démographie                | Ségrégation, densité, mobilité résidentielle                                                                                                                                                 |

Objectif : couvrir **au moins 5 domaines distincts**, avec si possible plusieurs
datasets par domaine.

---

### Axe 2 — Format spatial et structure de l'espace

#### 2.1 Type de support spatial

| Type                      | Description                              | Exemples                                      |
|---------------------------|------------------------------------------|-----------------------------------------------|
| **Points géoréférencés**      | Coordonnées précises, support irrégulier | Transactions immobilières, stations de mesure |
| **Polygones administratifs**  | Agrégation sur unités spatiales définies | INSEE, Eurostat, données électorales          |
| **Grille régulière (raster)** | Grille spatiale régulière                | ERA5, données satellitaires                   |
| **Réseau**                    | Nœuds ou arêtes d'un réseau              | Trafic routier, flux migratoires              |

#### 2.2 Caractéristiques de l'échantillonnage spatial

| Propriété               | Modalités                                                              |
|-------------------------|------------------------------------------------------------------------|
| **Exhaustivité spatiale**   | Exhaustif / Partiel (sous-échantillon)                                 |
| **Régularité**              | Grille régulière / Irrégulier / Aléatoire / Stratifié                  |
| **Biais d'échantillonnage** | Aléatoire / Préférentiel                                               |
| **Emprise**                 | Locale / Nationale / Européenne / Mondiale                             |
| **Résolution spatiale**     | Fine (< 1 km, parcelle, IRIS) / Moyenne (commune) / Grossière (NUTS2+) |

---

### Axe 3 — Structure temporelle

#### 3.1 Présence et nature de la dimension temporelle

| Type                         | Description                                       |
|------------------------------|---------------------------------------------------|
| **Coupe transversale pure**      | Un seul instant — cas dégénéré utile              |
| **Séries temporelles spatiales** | Plusieurs périodes, même ensemble d'unités        |
| **Panel spatial équilibré**      | Toutes les unités observées à toutes les périodes |
| **Panel spatial non équilibré**  | Unités manquantes à certaines périodes            |
| **Données d'événements**         | Instants irréguliers par unité                    |
| **Données continues**            | Signal quasi-continu (capteurs, monitoring)       |

#### 3.2 Caractéristiques de l'échantillonnage temporel

| Propriété               | Modalités                                                            |
|-------------------------|----------------------------------------------------------------------|
| **Exhaustivité temporelle** | Exhaustif / Lacunaire                                                |
| **Régularité**              | Régulier (journalier, mensuel, annuel) / Irrégulier                  |
| **Longueur de la série**    | Courte (T < 5) / Moyenne (5 ≤ T ≤ 20) / Longue (T > 20)              |
| **Fréquence**               | Infraquotidienne / Journalière / Hebdomadaire / Mensuelle / Annuelle |

#### 3.3 Type de panel

| Type de panel              | Description                         | Implication méthodologique         |
|----------------------------|-------------------------------------|------------------------------------|
| **Panel court large** (N >> T) | Beaucoup d'unités, peu de périodes  | Économétrie spatiale, effets fixes |
| **Panel long étroit** (T >> N) | Peu d'unités, longues séries        | Séries temporelles multivariées    |
| **Panel carré** (N ≈ T)        | Équilibre unités/périodes           | Méthodes mixtes                    |
| **Pseudo-panel**               | Unités agrégées (cohortes, groupes) | Construction préalable requise     |
| **Panel rotatif**              | Renouvellement partiel des unités   | Biais potentiel d'attrition        |

---

### Axe 4 — Type de variable endogène

| Code  | Type                 | Description                         | Exemples                           | Modèles adaptés                           |
|-------|----------------------|-------------------------------------|------------------------------------|-------------------------------------------|
| **CONT**  | Continue non bornée  | Valeurs réelles, approx. gaussienne | Prix log-transformés, températures | LM, SAR, GWR, BSPA                        |
| **CONT+** | Continue positive    | Valeurs strictement positives       | Revenus bruts, concentrations      | GLM Gamma, log-normal                     |
| **PROP**  | Proportion / taux    | Valeurs dans [0,1]                  | Taux de chômage, vaccination       | GLM Beta, logistique fractionnaire        |
| **BIN**   | Binaire              | 0/1                                 | Présence/absence, défaut           | GLM Logistique, probit spatial            |
| **POLY**  | Polytomique nominale | Catégories sans ordre               | Occupation du sol, mode transport  | Logit multinomial                         |
| **ORD**   | Ordinale             | Catégories ordonnées                | Classe DPE, score vulnérabilité    | Probit/logit ordonné                      |
| **COUNT** | Comptage             | Entiers positifs, sur-dispersés     | Nombre de cas, richesse spécifique | GLM Poisson, Neg. Binomiale               |
| **PRES**  | Présence seulement   | Sans absence confirmée              | Données GBIF, naturalistes         | MaxEnt, modèles à biais d'échantillonnage |
| **SURV**  | Survie / durée       | Temps avant événement, censuré      | Durée de vente, survie entreprise  | Cox spatial, modèles de durée             |

Objectif : couvrir **au moins 5 types d'endogènes distincts**, priorité sur
CONT, COUNT, BIN et PROP.

---

### Axe 5 — Structure de la dépendance spatio-temporelle

| Type                             | Description                                 | Signature typique                       |
|----------------------------------|---------------------------------------------|-----------------------------------------|
| **Autocorrélation spatiale globale** | Dépendance diffuse, stationnarité           | Moran's I élevé, variogramme tabulaire  |
| **Hétérogénéité spatiale locale**    | Coefficients variables, non-stationnarité   | GWR significatif, R² spatial hétérogène |
| **Autocorrélation temporelle**       | Dépendance entre périodes consécutives      | ACF significative sur résidus           |
| **Interaction spatio-temporelle**    | Dépendance spatiale variable dans le temps  | Modèles STAR, MGWRSAR, STVC             |
| **Diffusion spatiale**               | Propagation dans l'espace au cours du temps | Épidémies, innovations, prix            |
| **Dépendance réseau**                | Contiguïté non-euclidienne                  | Matrices W définies par réseau          |

---

### Axe 6 — Taille et complexité

| Dimension            | Petite | Moyenne   | Grande  |
|----------------------|--------|-----------|---------|
| N (unités spatiales) | < 500  | 500–5 000 | \> 5 000 |
| T (périodes)         | < 5    | 5–20      | \> 20    |
| P (covariables)      | < 5    | 5–20      | \> 20    |

---

### Plan d'expérience cible

Matrice de couverture cible (extrait) :

|                                     | CONT        | COUNT       | BIN         | PROP        |
|-------------------------------------|-------------|-------------|-------------|-------------|
| IMM + points + événements           | **Obligatoire** | —           | Optionnel   | —           |
| ECO + points + panel équilibré      | Optionnel   | **Obligatoire** | **Obligatoire** | —           |
| ENV + grille + série longue         | **Obligatoire** | —           | —           | Optionnel   |
| EPI + polygones + panel court large | —           | **Obligatoire** | **Obligatoire** | **Obligatoire** |
| ECN + polygones + panel court large | **Obligatoire** | —           | —           | **Obligatoire** |

---

### Livrables Phase 0

- **Document de typologie formalisé** (RMarkdown) : définition complète des 6 axes,
  glossaire, exemples illustratifs par cellule
- **Matrice de couverture cible** validée par l'encadrant — document contractuel
  pour les phases suivantes
- **Grille de scoring des candidats** opérationnalisée à partir de la matrice
- **Fiche de candidature standardisée** : template à remplir pour chaque dataset
  candidat identifié en Phases 1 et 2
- **Définition du jeu de données central de référence** : un dataset unique,
  choisi conjointement avec l'encadrant, incarnant le cas canonique du benchmark.
  Il sert de fil conducteur pédagogique et méthodologique à travers toutes les
  phases du stage et du datapaper. Caractéristiques arrêtées avec l'encadrant :

  | Dimension               | Caractéristique retenue                                                                                          |
  |-------------------------|------------------------------------------------------------------------------------------------------------------|
  | **Structure temporelle**    | Panel spatial **équilibré**, T moyen (10–20 périodes annuelles)                                                      |
  | **Support spatial**         | Polygones administratifs, **exhaustif spatialement**                                                                 |
  | **Exhaustivité temporelle** | Complète (aucune donnée manquante)                                                                               |
  | **Type d'endogène**         | **Continue (CONT)** — permettant d'appliquer l'ensemble du portefeuille sans adaptation                              |
  | **Structure de dépendance** | Autocorrélation spatiale globale + hétérogénéité spatiale + autocorrélation temporelle                           |
  | **Taille**                  | N moyen (500–2 000 unités), P moyen (5–15 covariables)                                                           |
  | **Domaine**                 | À définir avec l'encadrant — candidats naturels : chômage communal ou qualité de l'air départementale sur 15 ans |
  | **Licence**                 | CC-BY 4.0 obligatoire                                                                                            |

  Ce jeu central est utilisé pour : (i) illustrer et valider les protocoles de
  split, (ii) produire les figures et tableaux de référence du datapaper,
  (iii) servir de cas d'usage introductif dans le guide méthodologique et les
  *Usage Notes* du datapaper.

---

## Phase 1 — Exploration de la littérature scientifique (Semaines 4–10)

Phase **centrale et la plus chronophage** du stage. Elle combine une exploration
manuelle experte et le développement d'un pipeline automatisé. La grille issue
de la Phase 0 guide en permanence la sélection.

### Volet 1A — Exploration manuelle de la littérature (Semaines 4–7)

#### Stratégie de recherche bibliographique

Pour chaque domaine thématique cible, recherches systématiques dans :

- **Google Scholar**, **Web of Science**, **Scopus** — avec équations documentées
- **arXiv** (stat.AP, econ.GN, q-bio) pour les preprints récents
- Revues spécialisées : *Journal of Regional Science*, *Spatial Statistics*, *Geographical Analysis*, *Ecological Informatics*, *Environmental Research Letters*

#### Grille d'analyse par article identifié

| Champ                               | Description                                                                        |
|-------------------------------------|------------------------------------------------------------------------------------|
| Référence                           | DOI, auteurs, revue, année                                                         |
| Domaine thématique                  | Code Axe 1                                                                         |
| Description du dataset              | Variable réponse, covariables, N, emprise                                          |
| Type d'endogène                     | Code Axe 4                                                                         |
| Structure spatio-temporelle         | Codes Axes 2 & 3                                                                   |
| Structure de dépendance             | Code Axe 5                                                                         |
| **Scripts de reproduction disponibles** | Oui / Non / Partiel — lien vers dépôt Git, OSF, Zenodo ou supplémentaire           |
| **Langage des scripts**                 | R / Python / Stata / Matlab / autre                                                |
| **Type de scripts**                     | Collecte seule / Nettoyage / Modélisation / Pipeline complet                       |
| **Niveau de réutilisabilité**           | A (pipeline complet) / B (modélisation + données) / C (partiel) / D (inaccessible) |
| Disponibilité du dataset            | Lien direct / entrepôt / sur demande                                               |
| Licence dataset                     | CC-BY / propriétaire / non précisée                                                |
| Score matrice Phase 0               | 0–10                                                                               |
| Statut                              | Retenu / Écarté / À vérifier                                                       |

> La présence de scripts de reproduction constitue un critère de qualité
> supplémentaire et une ressource directement exploitable pour la Phase 6. Quand
> ils existent (niveaux A ou B), ils sont téléchargés et archivés dans
> `scripts/00_reproduced/` avec référence à l'article source.

#### Livrables Volet 1A

- Base bibliographique annotée (~100–200 articles examinés, ~30–50 retenus), gérée sous Zotero avec export CSV
- Carte thématique des sources (domaines × types × disponibilité)
- Inventaire des datasets accessibles directement vs. sur demande vs. inaccessibles
- **Inventaire des scripts de reproduction** avec évaluation du niveau de réutilisabilité (A–D)

---

### Volet 1B — Pipeline automatisé de détection dans la littérature (Semaines 6–10)

#### Architecture du pipeline

```
pipeline_lit/
├── 01_query/
│   ├── query_openalex.py          # API OpenAlex (200M+ articles, open)
│   ├── query_semanticscholar.py   # API Semantic Scholar
│   └── query_crossref.py          # métadonnées DOI + liens
├── 02_filter/
│   ├── filter_keywords.py         # filtrage mots-clés spatiaux/temporels
│   └── filter_domains.py          # filtrage thématique (Axe 1)
├── 03_extract/
│   ├── extract_data_mentions.py   # détection mentions de datasets
│   ├── extract_script_mentions.py # détection mentions de scripts/code
│   ├── fetch_fulltext.py          # fulltexts via Unpaywall
│   └── parse_data_section.py      # extraction sections "Data", "Code availability"
├── 04_qualify/
│   ├── check_doi_datasets.py      # requête inverse DataCite
│   ├── check_availability.py      # vérif. liens entrepôts
│   ├── check_scripts.py           # vérif. dépôts de code (GitHub, OSF, Zenodo)
│   ├── check_license.py           # détection de licence
│   └── score_matrix.py            # scoring sur grille Phase 0
└── 05_output/
    └── export_candidates.py       # export CSV/JSON des candidats qualifiés
```

#### Détection des scripts de reproduction

En complément de la détection des datasets, le pipeline identifie les articles
pour lesquels **des scripts de reproduction sont disponibles**, via :

- Sections *Code Availability* ou *Software Availability* dans le fulltext
- Mentions de dépôts de code : GitHub, GitLab, OSF, Zenodo, Figshare

```python
CODE_REPO_PATTERNS = [
    r"github\.com/[a-zA-Z0-9_\-]+/[a-zA-Z0-9_\-]+",
    r"gitlab\.com/[a-zA-Z0-9_\-]+/[a-zA-Z0-9_\-]+",
    r"10\.5281/zenodo\.\d+",
    r"10\.6084/m9\.figshare\.\d+",
    r"10\.17605/OSF\.IO/[A-Z0-9]+",
    r"cran\.r-project\.org/package=\w+",
]
```

Les scripts récupérés sont évalués selon leur réutilisabilité :

| Niveau | Description                                                        |
|--------|--------------------------------------------------------------------|
| **A**      | Pipeline complet reproductible (collecte + modélisation + figures) |
| **B**      | Scripts de modélisation seuls, données incluses ou accessibles     |
| **C**      | Scripts partiels ou nécessitant des adaptations substantielles     |
| **D**      | Mentionnés mais inaccessibles ou non fonctionnels                  |

#### Stratégie DOI datasets

Combinaison optimale pour identifier les datasets liés à un article :

1. **Requête inverse DataCite** — datasets référençant le DOI de l'article dans le champ `relatedIdentifier`
2. **Extraction de patterns DOI dans le fulltext** — préfixes `10.5281`, `10.5061`, `10.6084`, `10.17605`, `10.7910`, `10.1594`, `10.17632`, `10.21227`
3. **Champ** `datasets` **OpenAlex** — en complément pour la couverture récente

#### Livrables Volet 1B

- Pipeline Python documenté et versionné sur Git
- Base de candidats qualifiés (~200–500 entrées scorées sur grille Phase 0)
- **Inventaire des scripts de reproduction** avec niveau de réutilisabilité (A–D)
- Rapport de couverture : validation croisée automatique vs. manuel (Volet 1A)

---

## Phase 2 — Exploration des banques de données ouvertes existantes (Semaines 7–12)

*Parallèle au Volet 1B. Cible les sources institutionnelles et portails thématiques,
indépendamment de toute publication scientifique.*

### Cartographie des sources institutionnelles

#### Portails gouvernementaux et institutionnels

| Source          | Domaine                               | Granularité spatiale         |
|-----------------|---------------------------------------|------------------------------|
| data.gouv.fr    | Multi-thématique France               | Commune / IRIS / Département |
| Eurostat        | Économie, démographie, agriculture EU | NUTS 2/3                     |
| INSEE open data | Économie, logement, population        | IRIS / Commune               |
| DVF             | Prix immobiliers France               | Parcelle                     |
| EPA (USA)       | Pollution air/eau/sol                 | Monitoring stations          |
| SEDAC (NASA)    | Population, environnement, climat     | Global rasters               |

#### Portails environnementaux et climatiques

| Source         | Domaine                        | Résolution              |
|----------------|--------------------------------|-------------------------|
| Copernicus CDS | Climat, atmosphère             | 0.25° / journalier      |
| ATMO France    | Qualité de l'air               | Stations / interpolé    |
| GBIF           | Biodiversité, occurrences      | Coordonnées ponctuelles |
| PANGAEA        | Données marines et géosciences | Variable                |
| ERA5 (ECMWF)   | Réanalyse climatique           | 0.25° / horaire         |

#### Portails épidémiologiques et de santé

| Source                        | Domaine                          |
|-------------------------------|----------------------------------|
| WHO Global Health Observatory | Maladies, mortalité              |
| CDC Wonder (USA)              | Mortalité, maladies infectieuses |
| ECDC (Europe)                 | Épidémies, surveillance          |
| HealthData.gov                | Multi-thématique santé USA       |

#### Entrepôts généralistes

- **Zenodo** (CERN) — `10.5281`
- **Dryad** — `10.5061`
- **Figshare** — `10.6084`
- **OSF** — `10.17605`
- **Harvard Dataverse** — `10.7910`
- **PANGAEA** — `10.1594`
- **Mendeley Data** — `10.17632`

### Pipeline de scraping des portails

```
pipeline_portals/
├── 01_apis/
│   ├── scrape_zenodo.py
│   ├── scrape_dryad.py
│   ├── scrape_gbif.py
│   └── scrape_datagouv.py
├── 02_portals/
│   ├── scrape_eurostat.py
│   ├── scrape_sedac.py
│   └── scrape_copernicus.py
├── 03_qualify/
│   ├── check_spatiotemporal.py
│   ├── check_download.py
│   └── score_matrix.py
└── 04_output/
    └── export_portal_candidates.py
```

#### Critères de scoring automatique (0–10)

| Critère                                               | Poids |
|-------------------------------------------------------|-------|
| Présence de coordonnées géographiques ou polygones    | 3     |
| Présence d'au moins 3 dates/périodes distinctes       | 2     |
| Variable réponse continue ou de comptage identifiable | 2     |
| Licence CC-BY ou équivalent                           | 2     |
| N ≥ 200 observations par période                      | 1     |

### Livrables Phase 2

- Pipeline de scraping documenté et versionné
- Catalogue consolidé (~50–100 datasets scorés et classés)
- Matrice de couverture observée vs. cible : identification des cellules encore vides

---

## Phase 3 — Sélection, téléchargement et curation (Semaines 11–15)

Session de sélection conjointe pour retenir **8 à 12 jeux de données finaux**.
Le **jeu central** est prioritairement validé et traité en premier.

Pour chaque dataset retenu, Codex assiste la génération de scripts de
téléchargement, nettoyage, harmonisation (CRS uniforme, format de date standardisé)
et enrichissement minimal.

### Livrables Phase 3

- Répertoires `data/raw/` + `data/processed/` structurés et versionnés
- Fiche signalétique standardisée par dataset
- Dictionnaire des variables (RMarkdown/HTML)

---

## Phase 4 — Structuration et protocoles d'apprentissage (Semaines 14–17)

### Architecture de stockage

```
benchmark_stdata/
├── data/
│   ├── raw/
│   ├── processed/
│   └── splits/
├── metadata/
│   ├── fiches/
│   └── dictionnaires/
├── scripts/
│   ├── 00_reproduced/          # scripts issus de la littérature (Volet 1A/1B)
│   ├── 01_lit_pipeline/
│   ├── 02_portal_pipeline/
│   ├── 03_collect/
│   ├── 04_clean/
│   ├── 05_split/
│   └── 06_model/
├── results/
│   └── benchmarks/
└── docs/
    └── guide_methodologique.Rmd
```

### Protocoles de séparation Train/Test/Validation

**Pour les données à forte autocorrélation spatiale**

- Découpage par blocs spatiaux (`blockCV`, `spatialsample`) calibrés sur le variogramme empirique

**Pour les données spatio-temporelles**

- Découpage temporel strict (périodes de test postérieures à l'entraînement)
- Variante "leave-one-period-out" pour données courtes

**Pour les données à hétérogénéité spatiale forte**

- Stratification spatiale sur clusters k-means spatiaux

### Livrables Phase 4

- Package R `benchutils` (split, chargement standardisé, diagnostic de fuite spatiale)
- Guide méthodologique v1

---

## Phase 5 — Choix des matrices d'interaction spatiale (Semaines 15–17)

Avant toute modélisation, une étape dédiée est consacrée à la **spécification et
à la mise en concurrence des matrices de pondération spatiale W**, qui conditionnent
directement les résultats de l'ensemble des modèles spatiaux.

### Enjeu méthodologique

La matrice W encode une hypothèse sur la structure de la dépendance spatiale.
Retenir une seule spécification sans comparaison introduit un biais non contrôlé
qui invaliderait les comparaisons inter-modèles.

### Familles de matrices à mettre en concurrence

#### Matrices de contiguïté

| Type                 | Description                         | Cas d'usage                  |
|----------------------|-------------------------------------|------------------------------|
| **Rook (ordre 1)**       | Contiguïté par arête uniquement     | Polygones réguliers, grilles |
| **Queen (ordre 1)**      | Contiguïté par arête et sommet      | Polygones administratifs     |
| **Contiguïté d'ordre k** | Extension aux voisins d'ordre 2, 3… | Propagation à distance       |

#### Matrices de distance

| Type                         | Description                       | Paramètre clé             |
|------------------------------|-----------------------------------|---------------------------|
| **k plus proches voisins (kNN)** | k voisins les plus proches        | k ∈ {4, 6, 8, 10}         |
| **Seuil de distance**            | Toutes les unités dans un rayon d | d calibré sur variogramme |
| **Distance inverse (IDW)**       | Poids = 1/d^α                     | α ∈ {1, 2}                |
| **Noyau gaussien**               | Poids = exp(−d²/h²)               | h = bandwidth             |

#### Matrices économiques et fonctionnelles

| Type                   | Description                                | Cas d'usage              |
|------------------------|--------------------------------------------|--------------------------|
| **Flux économiques**       | Échanges commerciaux, navetteurs           | Économie régionale       |
| **Similarité d'attributs** | Poids basé sur ressemblance de covariables | Hétérogénéité thématique |
| **Réseau de transport**    | Distance réseau (temps de trajet)          | Données urbaines         |

### Protocole de sélection

Pour chaque dataset, les matrices candidates sont évaluées selon :

1. **Critère de Moran's I** : maximisation du signal spatial sur la variable réponse
2. **Critère de vraisemblance** : sélection par AIC/BIC sur un SAR ou SEM de référence
3. **Critère de stabilité** : robustesse des estimations à un changement de W
4. **Critère de conditionnement** : vérification que W est bien définie positive après standardisation en ligne

```r
library(spdep); library(spatialreg)

W_candidates <- list(
  rook   = nb2listw(poly2nb(sf_obj, queen = FALSE)),
  queen  = nb2listw(poly2nb(sf_obj, queen = TRUE)),
  knn5   = nb2listw(knn2nb(knearneigh(coords, k = 5))),
  knn10  = nb2listw(knn2nb(knearneigh(coords, k = 10))),
  dist50 = nb2listw(dnearneigh(coords, 0, 50000))
)

# Comparaison par Moran's I
lapply(W_candidates, function(w) moran.test(y, w))

# Comparaison par AIC sur SAR
lapply(W_candidates, function(w) AIC(lagsarlm(y ~ X, listw = w)))
```

La matrice retenue est documentée et justifiée dans la fiche signalétique.
**Toutes les matrices candidates restent disponibles** pour les analyses de
sensibilité.

### Livrables Phase 5

- Fonction R `select_W()` intégrée à `benchutils`
- Table de sélection des matrices par dataset (critères Moran, AIC, stabilité)
- Note méthodologique sur les choix retenus — matériau pour la section *Methods* du datapaper

---

## Phase 6 — Modélisation et benchmarking (Semaines 17–23)

### Principe général

Pour chaque jeu de données, produire une **fiche de benchmarking reproductible**
(Quarto) avec métriques comparables. Le jeu central est traité en premier.

### Portefeuille de modèles

#### Niveau 1 — Baselines non spatiales

- `lm` / GLM (gaussien, Poisson, Gamma, Beta selon la variable réponse)
- GAM (`mgcv::gam`) avec splines sur coordonnées
- Random Forest (`ranger`)
- Gradient Boosting (`xgboost` / `lightgbm`)

#### Niveau 2 — Modèles spatiaux statiques (coupe transversale)

- SAR / SEM (`spatialreg::lagsarlm`, `spatialreg::errorsarlm`)
- GWR / MGWR (`mgwrsar`)
- **SVC par filtrage des valeurs propres spatiales (Murakami & Griffith)**  
  Modèle à coefficients spatialement variables (SVC) estimé par décomposition
  spectrale de la matrice W. Les vecteurs propres de Moran sélectionnés par
  AIC/BIC approximent la variation spatiale non paramétrique des effets.
  Implémentation via le package R `spmoran` :

  ```r
  library(spmoran)
  meig <- meigen(cmat = W)          # décomposition spectrale de W
  res  <- resf_vc(y = y, x = X, meig = meig)  # estimation SVC
  ```

#### Niveau 3 — Modèles spatio-temporels

- Panel spatial à effets fixes spatiaux + AR temporel
- MGWRSAR avec dimension temporelle (`mgwrsar`)
- BSPA — Boosting Spatial Autoregressive (méthode développée par l'encadrant)
- **STVC — Spatiotemporally Varying Coefficients (Murakami 2025)**  
  Extension spatio-temporelle du filtrage des vecteurs propres. Le modèle STVC
  estime des coefficients variant conjointement dans l'espace et dans le temps
  par décomposition spectrale sur la structure spatio-temporelle de W.  
  Référence : Murakami, D. (2025). *Spatiotemporally varying coefficient modeling
  via Moran eigenvector maps*. Implémentation via `spmoran` (version ≥ 2.0) :

  ```r
  meig_st  <- meigen_st(cmat = W, t = T)          # structure spatio-temporelle
  res_stvc <- resf_vc(y = y, x = X, meig = meig_st, nvc = TRUE)
  coef_st  <- res_stvc$b_vc    # array coefficients [N × T × P]
  ```

  Les deux estimateurs SVC (statique) et STVC (dynamique) forment une famille
  cohérente directement comparable à GWR/MGWRSAR, particulièrement pertinente
  pour les datasets de type panel spatial équilibré.

### Métriques d'évaluation standardisées

| Métrique                | Usage                           |
|-------------------------|---------------------------------|
| RMSE, MAE, MAPE         | Précision prédictive globale    |
| Moran's I sur résidus   | Autocorrélation résiduelle      |
| R² spatial local        | Hétérogénéité de la performance |
| Temps de calcul         | Scalabilité                     |
| Couverture des IC à 95% | Calibration des intervalles     |

### Rôle de Codex dans cette phase

- Génération des scripts de modélisation à partir de templates standardisés
- Adaptation automatique du type de modèle au type de variable réponse
- Génération des visualisations (cartes de résidus, cartes de coefficients SVC/STVC, graphiques de performance)
- Revue systématique par l'étudiant avant toute exécution

> **Point de vigilance** : les sorties Codex doivent être auditées soigneusement
> pour `mgwrsar`, `spatialreg` et `spmoran` dont les syntaxes sont non-standard.
> Prévoir des sessions hebdomadaires de revue de code avec l'encadrant.

### Livrables Phase 6

- Fiches de benchmarking Quarto reproductibles par dataset
- Tableau comparatif consolidé (toutes métriques × tous modèles × tous datasets)
- Script maître `run_benchmark.R` entièrement reproductible
- Cartes de coefficients SVC et STVC pour les datasets panel équilibrés

---

## Rapport de mi-parcours (Semaines 12–13)

À mi-stage, l'étudiant produit un **rapport de mi-parcours** à destination de
l'université (jury de stage ou responsable de formation), conforme aux exigences
institutionnelles du Master.

### Contenu

**1. Avancement des travaux** (~2 pages)

- Bilan des Phases 0 à 2 : typologie construite, pipelines opérationnels, premier inventaire des sources
- État de la matrice de couverture : cellules remplies vs. vides
- Difficultés rencontrées (accès données, licences, qualité des métadonnées) et solutions adoptées

**2. Premiers résultats** (~2 pages)

- Statistiques descriptives sur le corpus exploré (articles examinés, taux de disponibilité des datasets, taux de présence de scripts de reproduction)
- Présentation du jeu central retenu : justification du choix, premières statistiques spatiales (Moran's I, variogramme empirique)
- Premier résultat de benchmarking si disponible (modèles Niveau 1 sur le jeu central)

**3. Plan de travail révisé pour la seconde moitié** (~1 page)

- Ajustements éventuels du périmètre (datasets abandonnés, nouveaux candidats)
- Calendrier révisé jusqu'à la fin du stage

**4. Questions méthodologiques ouvertes** (~1 page)

- Points à arbitrer avec l'encadrant pour la seconde moitié
- Problèmes techniques identifiés (choix de matrices W, protocoles de split pour types de données particuliers, etc.)

### Format et transmission

- Document de **8 à 12 pages** hors annexes, en français
- Annexes : extrait de la matrice de couverture, fiche signalétique du jeu central, premiers graphiques de diagnostic spatial
- Transmis simultanément à l'université **et à l'encadrant** pour validation conjointe avant envoi officiel

---

## Phase 7 — Rédaction du datapaper (Semaines 19–25)

*En collaboration étroite avec l'encadrant, points bimensuels à partir de la
semaine 19.*

### Revue cible : *Scientific Data* (Nature Portfolio)

### Structure du datapaper

#### 1. Background & Summary (~500 mots — conjoint)

- Nécessité d'un benchmark spatio-temporel standardisé
- Lacunes des benchmarks existants
- Contribution : diversité structurelle, reproductibilité, protocoles spatialement cohérents, recensement des scripts de reproduction

#### 2. Methods (étudiant + relecture encadrant)

- Conception de la typologie (Phase 0) et plan d'expérience
- Pipelines de collecte automatisée, dont détection des scripts de reproduction
- Pipeline de nettoyage et d'harmonisation
- Justification des protocoles de split
- Protocole de sélection des matrices W (Phase 5)
- Description du package `benchutils`

#### 3. Data Records (étudiant, à partir des fiches signalétiques)

- Tableau synthétique : domaine, type d'endogène, N, emprise, résolution, licence, DOI Zenodo, **présence de scripts associés**
- Description structurée de chaque jeu, avec mise en avant du **jeu central**

#### 4. Technical Validation (conjoint)

- Résultats de benchmarking synthétiques
- Comparaison SVC / STVC vs. GWR / MGWRSAR : gains et contextes d'usage
- Sensibilité aux choix de matrices W
- Recommandations d'usage par type de méthode

#### 5. Usage Notes (étudiant)

- Instructions de reproduction (dépôt Git + Zenodo)
- API du package `benchutils`
- Cas d'usage illustrés sur le **jeu central**

### Dépôts prérequis à la soumission

- Banque de données sur **Zenodo** (DOI permanent, CC-BY 4.0)
- Code (`benchutils` + pipelines) sur **GitHub** avec tag de version

### Calendrier interne

| Semaine | Étape                                                |
|---------|------------------------------------------------------|
| 19      | Réunion de cadrage éditorial                         |
| 21      | Drafts *Data Records* + *Methods* v1                     |
| 22      | Retour encadrant, révision                           |
| 23      | Draft complet v1 + dépôt Zenodo                      |
| 24      | Révision conjointe *Background* + *Technical Validation* |
| 25      | Relecture finale, mise en forme selon guidelines     |
| 26      | Soumission                                           |

> La soumission en fin de stage est réaliste mais conditionnée à la qualité des
> données et à la complétude du benchmarking. Une soumission dans les 2 mois
> suivant le départ de l'étudiant reste une issue très satisfaisante si le draft
> est solide.

---

## Phase 8 — Rapport de stage et clôture (Semaines 23–26)

### Structure du rapport de stage

1. Contexte et enjeux des benchmarks spatiaux
2. Conception de la typologie (Phase 0) : axes, matrice, jeu central
3. Pipelines de collecte : littérature, portails, scripts de reproduction
4. Protocoles de validation spatiale et sélection des matrices W
5. Résultats de benchmarking : analyse comparative incluant SVC et STVC
6. Contribution au datapaper
7. Conclusion et perspectives (enrichissement de la banque, intégration dans `mgwrsar`)

### Présentation interne

- Présentation à l'unité Ecodéveloppement (fin de stage)
- Support Quarto avec visualisations interactives et cartes de coefficients SVC/STVC

---

## Calendrier synthétique global

```
Sem.  1- 2  │ Cadrage, infrastructure, outils
Sem.  2- 4  │ ══ Phase 0 : Conception de la typologie + définition du jeu central
Sem.  4- 7  │ Phase 1A : Exploration manuelle de la littérature
Sem.  6-10  │ Phase 1B : Pipeline automatisé littérature + scripts de reproduction
Sem.  7-12  │ Phase 2  : Exploration banques institutionnelles
Sem. 11-12  │ Session de sélection conjointe des datasets finaux
Sem. 11-15  │ Phase 3  : Téléchargement & curation
Sem. 12-13  │ ══ Rapport de mi-parcours (université + encadrant)
Sem. 14-17  │ Phase 4  : Architecture & protocoles de split
Sem. 15-17  │ Phase 5  : Sélection & comparaison des matrices W
Sem. 17-23  │ Phase 6  : Modélisation & benchmarking (SVC, STVC, BSPA, MGWRSAR…)
Sem. 19     │ ── Lancement rédaction datapaper
Sem. 19-25  │ Phase 7  : Rédaction collaborative datapaper
Sem. 23     │ ── Dépôt Zenodo + tag GitHub
Sem. 23-26  │ Phase 8  : Rapport de stage + présentation interne
Sem. 25-26  │ ── Soumission datapaper
```

---

## Points d'attention pour l'encadrement

### Sur la Phase 0

Investissement de l'encadrant le plus critique du stage. Prévoir 2 à 3 réunions
dédiées en semaines 2–4 pour construire conjointement la matrice de couverture et
définir le jeu central.

### Sur les scripts de reproduction

Leur collecte systématique (Volet 1B) ajoute une valeur considérable : les scripts
de niveaux A et B peuvent directement alimenter la Phase 6 comme baselines
pré-validées, et leur recensement constitue un apport original du datapaper.

### Sur SVC et STVC (Murakami)

S'assurer que la version de `spmoran` installée est ≥ 2.0 pour accéder aux
fonctionnalités STVC. La comparaison SVC statique vs. STVC dynamique est
particulièrement instructive sur les datasets panel équilibrés et devrait faire
l'objet d'une section dédiée dans *Technical Validation*.

### Sur la validité des splits spatiaux

Un découpage aléatoire standard produira des métriques optimistes pour tous les
modèles spatiaux. Prévoir une séance dédiée dès la Phase 4.

### Sur le rapport de mi-parcours

Anticiper la date de dépôt imposée par l'université dès le début du stage. Le
contenu doit être validé par l'encadrant avant transmission officielle.

### Sur les ressources de calcul

MGWR, BSPA et STVC ont des temps de calcul significatifs pour N > 5 000. Anticiper
l'accès à un serveur INRAE ou cluster dès la Phase 6.

---

## Références

- Geniaux, G. & Martinetti, D. (2018). A new method for dealing simultaneously with spatial autocorrelation and spatial heterogeneity in regression models. *Regional Science and Urban Economics*, 72, 74–85.
- Fotheringham, A. S., Yang, W. & Kang, W. (2017). Multiscale geographically weighted regression (MGWR). *Annals of the American Association of Geographers*, 107(6), 1247–1265.
- Murakami, D. & Griffith, D. A. (2019). Spatially varying coefficient modeling for large datasets: Eliminating N from spatial regressions. *Spatial Statistics*, 30, 39–64.
- Murakami, D. (2025). Spatiotemporally varying coefficient modeling via Moran eigenvector maps. *Geographical Analysis* (in press).
- Bühlmann, P., Hothorn, T. et al. (2007). Boosting algorithms: Regularization, prediction and model fitting. *Statistical Science*, 22(4), 477–505.
- Wood, S. (2006). *Generalized Additive Models: An Introduction with R*. CRC Press.
- Hastie, T. & Tibshirani, R. (1993). Varying-coefficient models. *Journal of the Royal Statistical Society Series B*, 55(4), 757–779.