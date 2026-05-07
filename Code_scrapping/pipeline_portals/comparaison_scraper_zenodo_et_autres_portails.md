# Pourquoi le scraper Zenodo semble plus complet que les autres

## Idee principale

Le fichier `pipeline_portals/python/scrape_zenodo.py` semble plus complet parce qu'il a servi de scraper pilote du systeme.

C'est le premier scraper ou la logique complete de decouverte a ete portee depuis les prototypes R vers Python. Il contient donc encore beaucoup de fonctions directement dans le fichier, alors que les autres scrapers sont plus proches de l'architecture cible : un petit script specifique par entrepot, plus des fonctions communes dans `portal_common.py`.

## Ce que fait Zenodo en plus

Le scraper Zenodo ne se contente pas de chercher des fichiers. Il fait plusieurs operations dans le meme script :

- interrogation de l'API Zenodo avec pagination ;
- gestion du rythme des requetes et des erreurs HTTP ;
- verification que l'enregistrement est bien un dataset ;
- detection separee du signal spatial et du signal temporel ;
- extraction des fichiers disponibles et de leurs formats ;
- identification des formats spatiaux comme `nc`, `shp`, `geojson`, `gpkg`, `tif` ;
- extraction des DOI de publications associees ;
- enrichissement via OpenAlex quand un DOI de papier est trouve ;
- reconstruction de l'abstract OpenAlex ;
- detection de signaux de modelisation dans le titre ou l'abstract ;
- estimation legere de `n_obs` et `t_periods` depuis les metadonnees ou un extrait de CSV ;
- production de sorties JSON, CSV ou Markdown plus lisibles.

## Pourquoi les autres scrapers sont plus courts

Les autres scrapers comme Figshare, Dryad, Dataverse, data.gouv, INSEE, CEPII, Eurostat, OECD, World Bank ou UN Comtrade sont construits comme des connecteurs specialises.

Leur role principal est de :

- parler correctement a la source concernee ;
- interroger l'API officielle quand elle existe ;
- parser une page HTML quand il n'y a pas d'API propre ;
- extraire les URLs de fichiers ;
- normaliser les resultats dans le meme schema que les autres sources ;
- laisser les fonctions communes traiter les elements generiques.

Cela veut dire qu'ils ont moins de logique embarquee directement dans le fichier. Une partie du travail est mutualisee dans `portal_common.py`.

## Role de `portal_common.py`

`portal_common.py` est le module commun des scrapers.

Il contient les fonctions reutilisables :

- detection d'extensions spatiales ;
- detection de signaux spatiaux et temporels ;
- selection des URLs telechargeables ;
- controle des fichiers lourds avant telechargement ;
- extraction de DOI ;
- enrichissement des papiers via OpenAlex ;
- scoring de signaux de modelisation ;
- export JSONL, CSV, Markdown ;
- parsing HTML statique avec BeautifulSoup quand c'est utile.

L'objectif est d'eviter de recopier la meme logique dans chaque scraper.

## Les trois niveaux de scraping

Le systeme utilise maintenant trois niveaux :

1. API officielle avec `requests`

Utilise quand la source expose des donnees structurees en JSON, XML ou SDMX.

Exemples : Zenodo, Figshare, Dryad, Dataverse, data.gouv, World Bank, OpenAlex, Crossref.

2. HTML statique avec BeautifulSoup

Utilise quand une source propose surtout des pages web contenant des liens de fichiers.

Exemples : certaines pages CEPII, INSEE, Eurostat, OECD ou UN Comtrade.

3. Page dynamique avec Playwright

Utilise seulement quand la page depend de JavaScript et que `requests` ne voit pas les liens ou les contenus utiles.

Playwright est plus lourd, car il lance un navigateur. Il doit donc rester une solution de secours.

## Pourquoi il ne faut pas tout mettre dans chaque scraper

Il serait possible de rendre chaque scraper totalement autonome, avec toute la logique de filtrage, scoring, enrichissement papier et telechargement dans chaque fichier.

Mais ce serait moins maintenable :

- les corrections devraient etre repetees dans tous les fichiers ;
- les criteres de selection risqueraient de diverger selon les sources ;
- le systeme deviendrait plus difficile a lire ;
- les erreurs seraient plus nombreuses quand on ajoute un nouveau portail.

L'architecture preferee est donc :

- un scraper court et specifique pour chaque source ;
- un module commun pour les operations generiques ;
- une sortie normalisee commune pour tous les candidats datasets.

## Direction cible

A terme, Zenodo devrait etre rapproche des autres scrapers.

Cela signifie :

- deplacer les fonctions vraiment generiques de `scrape_zenodo.py` vers `portal_common.py` ;
- garder dans `scrape_zenodo.py` uniquement ce qui est specifique a l'API Zenodo ;
- enrichir les autres scrapers avec les memes criteres quand leurs sources le permettent ;
- produire des candidats comparables entre portails.

L'objectif final n'est pas que tous les fichiers aient la meme taille.

L'objectif est que tous les scrapers produisent des candidats datasets comparables, avec :

- source ;
- titre ;
- description ;
- fichiers ;
- formats ;
- licence ;
- signaux spatiaux ;
- signaux temporels ;
- DOI dataset ;
- DOI papier associe ;
- abstract si disponible ;
- indices de modelisation ;
- decision de garder, revoir ou ecarter.

## Conclusion

Zenodo semble plus complet parce qu'il est le prototype le plus avance du systeme.

Les autres scrapers ne sont pas necessairement moins importants. Ils sont plus modulaires et s'appuient davantage sur les fonctions communes.

La bonne evolution du systeme consiste a harmoniser les criteres de selection entre tous les portails, sans recopier toute la logique de Zenodo dans chaque fichier.
