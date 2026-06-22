# Dataset manifests

Fichiers a utiliser en priorite:

- `catalogue_datasets_software.xlsx`: classeur principal, avec une feuille pour les tables principales et une feuille pour les auxiliaires.
- `software_r_catalog_main_datasets.csv`: version tabulaire R du catalogue principal.
- `excluded_datasets.csv`: registre des payloads volontairement exclus et raison de l'exclusion.

Conventions:

- `software_*`: inventaires, audits et decisions concernant les datasets fournis par des packages R ou Python.
- `dryad_*` et `zenodo_*`: traces de decouverte de depots scientifiques encore distinctes du catalogue software.
- `*.records.jsonl` et `*.seed-log.jsonl`: traces techniques de scraping, non destinees a la consultation courante.

Les donnees brutes ne doivent pas etre stockees ici. Les PDF sont places dans `corpus/raw/pdf/`.
