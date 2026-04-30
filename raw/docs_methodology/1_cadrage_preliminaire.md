
# CADRAGE PRELIMINAIRE

*Date : 2026-04-03*

# Introduction

Ce document presente un cadrage preliminaire du stage. Il recense les principaux entrepots, portails et couches de decouverte utiles pour identifier et recuperer de grands jeux de donnees spatio-temporels. Il a aussi vocation a organiser la suite du travail, notamment la typologie des variables, les criteres de selection des jeux de donnees et les scripts prioritaires a developper.

# 1. Cadrage (Semaines 1-2)

Cette phase initiale vise a poser les bases techniques et conceptuelles du projet.  
Elle correspond a une phase d'exploration, de prise en main des outils et de structuration du pipeline de collecte.

## 1.1 Mise en place de l'environnement de travail

- installation et configuration de R
- installation et configuration de Python
- mise en place de Git pour le versionnement
- prise en main de l'environnement de developpement (RStudio, VS Code)
- structuration initiale du projet

## 1.2 Prise en main des entrepots cibles

- exploration des entrepots generalistes : 
  - Zenodo
  - Dryad
  - Dataverse
- exploration des couches de decouverte : 
  - OpenAlex
  - Crossref
  - DataCite
- exploration des portails thematiques : 
  - Copernicus
  - GBIF
  - NOAA

Objectif : comprendre les types de données disponibles, les formats, les metadonnees et les modalites d'acces.

## 1.3 Revue de litterature sur les data papers

Lecture ciblée de publications de référence :

- *Scientific Data*
- *Data in Brief*
- *Geoscience Data Journal*

Objectifs :

- comprendre le format "data paper"
- identifier les standards de description des données
- analyser les bonnes pratiques de structuration et de documentation

## 1.4 Prise en main des outils de collecte et d'extraction

- frameworks de scraping : 
  - Scrapy
  - Playwright
- APIs scientifiques : 
  - OpenAlex
  - Crossref
  - Unpaywall
  - Semantic Scholar

Objectifs :

- tester differentes methodes de collecte
- comparer scraping vs API
- preparer les futurs scripts automatises

# 2. Entrepots de donnees cibles

## 2.1 Legende

- `Type` : entrepot generaliste, portail thematique, portail institutionnel, couche de decouverte
- `API` : acces programmable aux metadonnees ou aux donnees
- `Bulk download` : possibilite de telechargement massif ou snapshot

## 2.2 Entrepots generalistes

| Source                        | Type                              | API | Bulk download | Licence frequente                       | Domaines couverts                                  | Scripts a ecrire                                    |
|-------------------------------|-----------------------------------|-----|---------------|-----------------------------------------|----------------------------------------------------|-----------------------------------------------------|
| [Zenodo](https://zenodo.org/)                        | Entrepot generaliste              | Oui | Oui           | Souvent CC-BY, variable selon depot     | Multi-thematique, datasets lies a articles et code | `scrape_zenodo.py`, filtre licence, filtre geo/temps  |
| [Dryad](https://datadryad.org/)                         | Entrepot generaliste cure         | Oui | Partiel       | Souvent ouverte, souvent CC0 ou ouverte | Bio, ecologie, sante, environnement                | `scrape_dryad.py`, extraction metadonnees et fichiers |
| [Figshare](https://figshare.com/)                      | Entrepot generaliste              | Oui | Partiel       | Variable, souvent ouverte               | Multi-thematique                                   | `scrape_figshare.py`                                  |
| [Dataverse / Harvard Dataverse](https://dataverse.org/) | Entrepot generaliste / SHS        | Oui | Oui           | Variable, souvent ouverte               | Economie, socio-demo, enquetes, panels             | `scrape_dataverse.py`, recherche datasets et panels   |
| [OSF](https://osf.io/)                           | Plateforme projets et replication | Oui | Partiel       | Variable                                | Replication, annexes, jeux lies a papiers          | `scrape_osf.py`, detection datasets et code           |
| [Mendeley Data](https://data.mendeley.com/)                 | Entrepot generaliste              | Oui | Partiel       | Variable                                | Multi-thematique                                   | `scrape_mendeley.py`                                  |

## 2.3 Couches de decouverte

| Source           | Type                                 | API | Bulk download | Licence frequente     | Domaines couverts                         | Scripts a ecrire                            |
|------------------|--------------------------------------|-----|---------------|-----------------------|-------------------------------------------|---------------------------------------------|
| [OpenAIRE Graph](https://graph.openaire.eu/)   | Graphe de decouverte                 | Oui | Oui           | Ouverte selon service | Liens publications, donnees, logiciels    | `query_openaire.py`, resolution DOI           |
| [OpenAlex](https://docs.openalex.org/)         | Couche de decouverte bibliographique | Oui | Oui           | Ouverte               | Articles, relations vers datasets         | `query_openalex.py`, `extract_data_mentions.py` |
| [DataCite Commons](https://commons.datacite.org/) | Couche de decouverte DOI datasets    | Oui | Oui           | Metadonnees ouvertes  | Datasets DOIes, relations article-dataset | `check_datacite_related.py`                   |
| [Crossref](https://api.crossref.org/)         | Couche de decouverte DOI articles    | Oui | Oui           | Metadonnees ouvertes  | Publications et liens associes            | `query_crossref.py`                           |
| [Unpaywall](https://unpaywall.org/)        | Couche de decouverte full text OA    | Oui | Oui           | Donnees OA            | Full text OA pour extraction de mentions  | `fetch_fulltext.py`                           |
| [re3data](https://www.re3data.org/)          | Annuaire d'entrepots                 | Oui | Non principal | Metadonnees ouvertes  | Trouver entrepots specialises             | `seed_repositories_from_re3data.py`           |

## 2.4 Portails climat, environnement et biodiversite

| Source                        | Type                                | API           | Bulk download | Licence frequente                                    | Domaines couverts                               | Scripts a ecrire en premier                          |
|-------------------------------|-------------------------------------|---------------|---------------|------------------------------------------------------|-------------------------------------------------|------------------------------------------------------|
| [Copernicus Climate Data Store](https://cds.climate.copernicus.eu/) | Portail climat                      | Oui           | Oui           | Variable, souvent ouverte avec conditions Copernicus | ERA5, reanalyses, projections, atmosphere       | `scrape_copernicus.py`, requetes ERA5                  |
| [Copernicus Data Space](https://dataspace.copernicus.eu/)         | Portail EO / satellite              | Oui           | Oui           | Conditions Copernicus                                | Sentinel, imagerie, land monitoring             | `scrape_copernicus_dataspace.py`                       |
| [PANGAEA](https://pangaea.de/)                       | Entrepot thematique                 | Oui           | Oui           | Variable, souvent ouverte                            | Geosciences, ocean, climat, environnement       | `scrape_pangaea.py`                                    |
| [GBIF](https://www.gbif.org/)                          | Portail biodiversite                | Oui           | Oui           | Tres souvent CC-BY, CC0 ou CC-BY-NC                  | Occurrences, presence-only, biodiversite        | `scrape_gbif.py`, controle coords et dates             |
| [NOAA NCEI](https://www.ncei.noaa.gov/)                     | Portail climat et meteo             | Oui           | Oui           | Ouverte, gouvernement US                             | Stations, climat, meteo longues series          | `scrape_ncei.py`, recuperation stations et inventaires |
| [NASA SEDAC](https://sedac.ciesin.columbia.edu/)                    | Portail environnement et population | Oui / partiel | Oui           | Variable, souvent ouverte                            | Population, air, environnement, rasters globaux | `scrape_sedac.py`                                      |
| [NASA Earthdata](https://www.earthdata.nasa.gov/)                | Portail Earth observation           | Oui           | Oui           | Variable selon collection                            | MODIS, VIIRS, sols, eau, atmosphere             | `scrape_earthdata.py`                                  |
| [OpenTopography](https://opentopography.org/)                | Portail topographie                 | Oui           | Oui           | Variable                                             | MNT, LiDAR                                      | `scrape_opentopography.py`                             |
| [WorldClim](https://www.worldclim.org/)                     | Portail climat                      | Non / limite  | Oui           | Usage academique ouvert                              | Climatologies, bioclim                          | `download_worldclim.py`                                |
| [CHELSA](https://chelsa-climate.org/)                        | Portail climat haute resolution     | Limite        | Oui           | Ouverte ou academique                                | Climat haute resolution                         | `download_chelsa.py`                                   |

## 2.5 Portails publics et statistiques

| Source          | Type                             | API           | Bulk download | Licence frequente                 | Domaines couverts                           | Scripts a ecrire en premier  |
|-----------------|----------------------------------|---------------|---------------|-----------------------------------|---------------------------------------------|------------------------------|
| [data.gouv.fr](https://www.data.gouv.fr/)    | Portail public national          | Oui           | Oui           | Licence Ouverte, Etalab, variable | France multi-thematique                     | `scrape_datagouv.py`           |
| [INSEE](https://www.insee.fr/)           | Portail stats publiques          | Oui           | Oui           | Ouverte sous conditions INSEE     | Demographie, emploi, revenus, logement      | `scrape_insee.py`              |
| [Eurostat](https://ec.europa.eu/eurostat/)        | Portail stats UE                 | Oui           | Oui           | Ouverte UE                        | Economie, demographie, agriculture, regions | `scrape_eurostat.py`           |
| [GISCO](https://ec.europa.eu/eurostat/web/gisco)           | Geodonnees UE                    | Oui           | Oui           | Ouverte UE                        | Limites administratives, fonds de carte     | `download_gisco_boundaries.py` |
| [DVF](https://explore.data.gouv.fr/fr/immobilier)             | Jeu ou portail immobilier France | Oui / exports | Oui           | Ouverte France                    | Transactions immobilieres                   | `scrape_dvf.py`                |
| [World Bank Data](https://data.worldbank.org/) | Portail international            | Oui           | Oui           | Ouverte World Bank                | Macro, pauvrete, developpement              | `scrape_worldbank.py`          |
| [OECD Data](https://data.oecd.org/)       | Portail international            | Oui           | Oui           | Ouverte OCDE                      | Socio-economie comparative                  | `scrape_oecd.py`               |
| [UN Data](https://data.un.org/)         | Portail international            | Oui           | Oui           | Variable                          | Indicateurs globaux                         | `scrape_undata.py`             |
| [HDX](https://data.humdata.org/)             | Portail humanitaire              | Oui           | Oui           | Variable, souvent ouverte         | Crises, mobilite, admin boundaries          | `scrape_hdx.py`                |

## 2.6 Portails sante

| Source         | Type                       | API           | Bulk download | Licence frequente     | Domaines couverts                   | Scripts a ecrire en premier |
|----------------|----------------------------|---------------|---------------|-----------------------|-------------------------------------|-----------------------------|
| [WHO GHO](https://www.who.int/data/gho)        | Portail sante mondial      | Oui           | Oui           | Ouverte OMS selon jeu | Mortalite, maladies, vaccins        | `scrape_who_gho.py`           |
| [ECDC](https://www.ecdc.europa.eu/en/publications-data)           | Portail sante UE           | Oui / exports | Oui           | Variable              | Surveillance epidemiologique Europe | `scrape_ecdc.py`              |
| [CDC WONDER](https://wonder.cdc.gov/)     | Portail sante US           | Limite        | Exports       | Gouvernement US       | Mortalite, sante publique           | `scrape_cdc_wonder.py`        |
| [data.cdc.gov](https://data.cdc.gov/)   | Portail open data sante US | Oui           | Oui           | Ouverte US            | Sante publique US                   | `scrape_cdc_data.py`          |
| [HealthData.gov](https://healthdata.gov/) | Portail sante US           | Oui           | Oui           | Variable              | Sante multi-thematique              | `scrape_healthdata.py`        |

## 2.7 Agriculture, geodonnees et occupation du sol

| Source          | Type                      | API           | Bulk download | Licence frequente  | Domaines couverts                 | Scripts a ecrire en premier |
|-----------------|---------------------------|---------------|---------------|--------------------|-----------------------------------|-----------------------------|
| [FAOSTAT](https://www.fao.org/faostat/)         | Portail agriculture       | Oui           | Oui           | Ouverte FAO        | Production, cultures, terres      | `scrape_faostat.py`           |
| [USDA NASS](https://www.nass.usda.gov/)       | Portail agriculture US    | Oui           | Oui           | Gouvernement US    | Rendements, surfaces, pratiques   | `scrape_usda_nass.py`         |
| [ESA WorldCover](https://esa-worldcover.org/)  | Portail occupation du sol | Non / limite  | Oui           | Ouverte            | Land cover global                 | `download_worldcover.py`      |
| [Geofabrik / OSM](https://download.geofabrik.de/) | Geodonnees derivees       | Oui / exports | Oui           | ODbL               | Reseaux, POI, bati                | `download_geofabrik.py`       |
| [Natural Earth](https://www.naturalearthdata.com/)   | Fonds cartographiques     | Non / limite  | Oui           | Domaine public     | Limites, hydro, relief            | `download_naturalearth.py`    |
| [GADM](https://gadm.org/)            | Limites administratives   | Non / limite  | Oui           | Licence specifique | Limites administratives mondiales | `download_gadm.py`            |

# 3. Revue preliminaire sur le format data paper

Le data paper est un format de publication scientifique centre sur la description, la documentation et la mise a disposition d'un jeu de donnees.  
Il ne vise pas principalement a tester une hypothese, mais a rendre les donnees visibles, reutilisables et correctement documentees.

## 3.1 Objectifs du data paper

- decrire precisement un jeu de donnees ;
- expliciter les methodes de collecte, de traitement et de structuration ;
- documenter la couverture spatiale et temporelle ;
- preciser les metadonnees, formats, licences et conditions de reutilisation ;
- favoriser la reproductibilite et la reutilisation scientifique.

## 3.2 References et revues a examiner

- *Scientific Data*
- *Data in Brief*
- *Geoscience Data Journal*
- *Earth System Science Data*
- *Biodiversity Data Journal*
- *Journal of Open Data*
- *Data Science Journal*
- *GigaScience*
- *F1000Research*
- *Open Research Europe*

## 3.3 Elements a observer dans ces revues

- structure generale des articles ;
- niveau de detail dans la description des donnees ;
- place accordee aux metadonnees ;
- description des methodes de collecte et de nettoyage ;
- modalites de depot des jeux de donnees ;
- articulation entre article, DOI et entrepot de donnees ;
- informations sur la reutilisation potentielle des donnees.

# 4. Typologie preliminaire des variables

Cette section a vocation a etre enrichie au fur et a mesure du cadrage.

## 4.1 Variables d'identification

- identifiant du jeu de donnees
- titre
- DOI
- source
- URL
- auteur ou organisme producteur

## 4.2 Variables spatiales

- pays
- region
- departement
- commune
- coordonnees
- grille raster
- shapefile ou unite administrative
- projection / systeme de coordonnees

## 4.3 Variables temporelles

- date d'observation
- annee
- mois
- jour
- frequence
- periode de couverture
- date de mise a jour

## 4.4 Variables thematiques

- agriculture
- climat
- biodiversite
- environnement
- sante
- economie regionale
- demographie
- immobilier

## 4.5 Variables techniques

- format de fichier
- taille
- mode d'acces
- disponibilite API
- possibilite de telechargement massif
- licence
- restrictions d'usage

# 5. Exemples de jeux vises par domaine

| Code | Domaine                                | Sources a prioriser                          | Exemples de jeux vises                                                    |
|------|----------------------------------------|----------------------------------------------|---------------------------------------------------------------------------|
| `IMM`  | Marches immobiliers                    | DVF, data.gouv.fr, Dataverse, Zenodo         | Transactions geocodees, prix de vente, loyers, transactions parcellaires  |
| `AGR`  | Agriculture / rendements               | FAOSTAT, USDA NASS, Copernicus, WorldCover   | Rendements, surfaces cultivees, cultures annuelles, indices de vegetation |
| `ECO`  | Ecologie / biodiversite                | GBIF, Dryad, PANGAEA, Zenodo                 | Occurrences d'especes, abondance, presence-absence                        |
| `ENV`  | Environnement / pollution              | Copernicus CDS, SEDAC, data.gouv.fr, NOAA    | PM2.5, NO2, nitrates, qualite de l'air, eau, sol                          |
| `CLI`  | Climat / meteorologie                  | Copernicus CDS, NOAA NCEI, WorldClim, CHELSA | Temperature, precipitations, reanalyses, anomalies                        |
| `EPI`  | Epidemiologie / sante                  | WHO GHO, ECDC, CDC, HealthData.gov           | Incidence, mortalite, hospitalisations, vaccination                       |
| `PHY`  | Epidemiologie des maladies des plantes | data.gouv.fr, Copernicus, Zenodo, Dryad      | Incidence parcellaire, foyers, dates de detection, propagation            |
| `ECN`  | Economie regionale                     | Eurostat, INSEE, World Bank, OECD, Dataverse | PIB, chomage, flux, indicateurs territoriaux                              |
| `SOC`  | Sciences sociales / demographie        | INSEE, Eurostat, Dataverse, HDX              | Population, segregation, mobilite, pauvrete, densite                      |

# 6. Scripts prioritaires a developper

- `query_openalex.py`
- `query_crossref.py`
- `check_datacite_related.py`
- `fetch_fulltext.py`
- `scrape_zenodo.py`
- `scrape_dryad.py`
- `scrape_dataverse.py`
- `scrape_gbif.py`
- `scrape_copernicus.py`
- `scrape_datagouv.py`
- `scrape_eurostat.py`