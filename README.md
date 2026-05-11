# LLM Wiki Spatial Data System

Prototype de système de découverte, documentation et préparation de jeux de données spatiaux et spatio-temporels pour la modélisation.

Ce projet combine :
- un wiki local orienté LLM ;
- un serveur MCP pour interroger le catalogue local ;
- des pipelines de scraping pour entrepôts de données ;
- des pipelines de recherche bibliographique ;
- des manifests machine pour tracer les jeux de données, papiers, métadonnées et décisions de sélection.

## Objectif

L’objectif est d’aider à identifier des jeux de données utilisables pour des modèles spatiaux ou spatio-temporels.

Un jeu de données candidat doit idéalement contenir :
- une dimension spatiale ;
- une dimension temporelle si possible ;
- une variable à expliquer `Y` ;
- des variables explicatives candidates `X_candidate` ;
- des variables sélectionnées `X_selected` après inspection ;
- une documentation ou un papier scientifique associé ;
- des indices de modélisation existante dans un article, un code ou une métadonnée.

## Structure Du Projet

```text
wiki/
  concepts/              Définitions utiles au système
  datasets/              Fiches de datasets documentés (par entrepôt)
  estimators/            Fiches d’estimateurs
  metadata/              Schémas et règles de métadonnées
  analyses/              Synthèses, découvertes et profils progressifs
  sources/               Sources de données par famille
  eval_queue.md          File d’attente de révision manuelle (Tier 3)

Code_scrapping/
  pipeline_portals/
    python/              Scrapers des entrepôts de données
    notebook/            Versions notebook des scrapers
  pipeline_lit/          Recherche et analyse de papiers scientifiques
  R/                     Scripts R pour estimateurs et extraction
  extract_r_software_datasets.R
  find_software_dataset_papers.py
  load_datasets_to_dataframes.py
  prepare_estimator_fiches.py

LLM-wiki-Assessment/
  eval/                  Pipeline d’évaluation des fiches wiki (Tier 1/2/3)
    run_eval.py          Point d’entrée principal
    tier1_structural.py  Vérifications structurelles (0 token)
    tier2_semantic.py    Évaluation sémantique LLM-as-judge
    tier3_queue.py       Gestion de la file de révision manuelle
    hooks/pre-commit     Hook git : évalue les fiches avant chaque commit
  tests/
    unit/                Tests de format et de liens wiki
    validation/          Tests DOI, licences, manifests, policy

data/
  manifests/             Traces machine (JSON, JSONL, CSV) — versionnées
    datasets/            Manifests des datasets découverts ou téléchargés
    papers/              Manifests des papiers scientifiques
    runs/                Logs de téléchargement et d’exécution
  candidates/            Métadonnées des candidats — versionnées
    papers/              Papiers associés aux estimateurs
    datasets/            Fichiers téléchargés — ignorés par Git
  Final_datasets/        Données validées localement — ignorées par Git
```
## Sources couvertes

Le système couvre trois familles de sources.

### Entrepôts de données

- Zenodo
- Figshare
- Dryad
- Dataverse
- data.gouv
- INSEE
- CEPII
- Eurostat
- OECD
- World Bank
- UN Comtrade

### Sources logicielles

Le système documente aussi des datasets distribués dans des packages logiciels :

- packages R avec jeux de données spatiaux ou spatio-temporels ;
- packages Python comme `geodatasets`, `libpysal`, `giddy`, `geosnap`, `xarray`, `movingpandas`, `scikit-mobility`.

### Sources bibliographiques

- OpenAlex
- Crossref
- DOI
- papiers scientifiques associés aux datasets candidats

## Rôle du wiki

Le wiki sert de mémoire structurée, lisible à la fois par un humain et par le LLM.

Il contient :

- les définitions conceptuelles ;
- les fiches de datasets ;
- les fiches d’estimateurs ;
- les règles de sélection ;
- les analyses produites pendant la recherche ;
- les liens entre datasets, papiers, variables et estimateurs.

## Rôle des manifests

Les fichiers dans `data/manifests/` sont des traces structurées au format JSON, JSONL ou CSV.

Ils servent à :

- retrouver ce qui a été découvert ;
- éviter de scraper plusieurs fois la même source ;
- conserver les DOI, URLs, licences, chemins locaux et décisions ;
- fournir au MCP et au LLM une base locale exploitable.

## Données téléchargées

Les fichiers de données réels sont ignorés par Git. Seuls les manifests et métadonnées sont versionnés.

| Dossier | Statut Git | Contenu |
|---|---|---|
| `data/manifests/` | versionné | traces JSON/JSONL/CSV des découvertes |
| `data/candidates/papers/` | versionné | JSONL des papiers estimateurs |
| `data/candidates/datasets/` | ignoré | fichiers bruts téléchargés des portails |
| `data/Final_datasets/` | ignoré | datasets validés pour la modélisation |
| `data/downloads/` | ignoré | (ancien dossier, conservé localement) |

Les manifests dans `data/manifests/` gardent la trace de tout ce qui a été découvert ou téléchargé.

## Pipeline d’évaluation des fiches wiki

Le dossier `LLM-wiki-Assessment/` contient un pipeline de contrôle qualité à 3 niveaux.

| Niveau | Nom | Rôle | Coût |
|---|---|---|---|
| Tier 1 | Structural | Vérifie les sections obligatoires, le frontmatter YAML, les liens internes | 0 token |
| Tier 2 | Semantic | Évaluation LLM-as-judge de la cohérence métadonnées/contenu | tokens Claude |
| Tier 3 | Queue | Fiches bloquées ou rejetées orientées vers révision manuelle | 0 token |

**Commandes principales :**

```bash
# Évaluer une fiche
python LLM-wiki-Assessment/eval/run_eval.py wiki/datasets/zenodo/zenodo_xxx.md

# Tout passer (pytest + Tier 1 + Tier 2)
python LLM-wiki-Assessment/eval/run_eval.py --all

# Tests unitaires seulement
python -m pytest LLM-wiki-Assessment/tests/
```

Le hook `pre-commit` évalue automatiquement toutes les fiches wiki modifiées avant chaque commit.

## MCP

Le serveur MCP permet au LLM d’interroger le catalogue local et les manifests sans relire manuellement tout le système.

Dans ce projet, le MCP n’est pas un RAG complet. Il sert surtout de couche d’accès structurée aux informations locales : datasets, métadonnées, chemins, sources, papiers et estimateurs.

## État actuel

Le système contient actuellement :

- des scrapers pour 11 entrepôts institutionnels et scientifiques ;
- des scrapers de portails scientifiques (Zenodo, Dryad, Figshare, Dataverse) ;
- des scripts de recherche de papiers (OpenAlex, Crossref) ;
- des fiches conceptuelles, d’estimateurs et de datasets ;
- des manifests de datasets logiciels R/Python ;
- une cartographie des datasets disponibles dans plusieurs langages ;
- un pipeline d’évaluation qualité des fiches wiki (Tier 1/2/3) ;
- un hook pre-commit pour la validation automatique.

## Origine
Ce projet est basé initialement sur le modèle llm-wiki-karpathy, puis adapté pour un usage de recherche sur les données spatiales et spatio-temporelles.

