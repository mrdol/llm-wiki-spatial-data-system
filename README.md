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
  datasets/              Fiches de datasets documentés
  estimators/            Fiches d’estimateurs
  metadata/              Schémas et règles de métadonnées
  analyses/              Synthèses, découvertes et profils progressifs
  sources/               Sources de données par famille

pipeline_portals/
  python/                Scrapers des entrepôts de données
  notebook/              Versions notebook des scrapers

pipeline_lit/
  Recherche et analyse de papiers scientifiques liés aux données

data/
  manifests/             Traces machine des découvertes et résultats
  candidates/            Candidats issus des recherches
  downloads/             Données téléchargées, non versionnées dans Git

scripts/
  Scripts utilitaires pour extraction, metadata et littérature
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

Les datasets téléchargés sont stockés dans :

```text
data/downloads/
Ce dossier est volontairement ignoré par Git, car il peut contenir des fichiers lourds.
```
Les manifests gardent la trace des données téléchargées ou candidates.

## MCP
Le serveur MCP permet au LLM d’interroger le catalogue local et les manifests sans relire manuellement tout le système.

Dans ce projet, le MCP n’est pas un RAG complet. Il sert surtout de couche d’accès structurée aux informations locales : datasets, métadonnées, chemins, sources, papiers et estimateurs.

## État actuel
Le système contient actuellement :

des scrapers institutionnels ;
des scrapers de portails scientifiques ;
des scripts de recherche de papiers ;
des fiches conceptuelles ;
des fiches d’estimateurs ;
des manifests de datasets logiciels R/Python ;
une cartographie des datasets disponibles dans plusieurs langages.

## Origine
Ce projet est basé initialement sur le modèle llm-wiki-karpathy, puis adapté pour un usage de recherche sur les données spatiales et spatio-temporelles.

