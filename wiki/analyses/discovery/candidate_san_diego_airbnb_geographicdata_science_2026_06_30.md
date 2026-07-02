---
title: Candidate Dataset — San Diego Airbnb (Geographic Data Science with Python)
type: analysis
created: 2026-06-30
updated: 2026-06-30
sources:
  - https://geographicdata.science/book/notebooks/11_regression.html
tags:
  - analysis
  - discovery
  - candidate-dataset
  - airbnb
  - spatial-regression
  - to-acquire
---

Candidat dataset repere lors d'une comparaison manuelle avec le dataset
`Python_geodatasets_geoda.airbnb` (GeoDa Chicago Airbnb 2015) deja present dans
le catalogue. Pas encore acquis ni converti en sf -- a traiter via le second
bloc de sources (publications scientifiques en spatial, repos GitHub,
entrepots de donnees) plutot que via les packages R/Python deja couverts.

## Identite (a confirmer/completer lors de l'acquisition)

- Nom : San Diego Airbnb listings (regression spatiale)
- Source principale : chapitre 11 du livre en ligne *Geographic Data Science
  with Python* (Rey, Arribas-Bel, Wolf) — https://geographicdata.science/book/notebooks/11_regression.html
- Statut : **different** du dataset Chicago deja dans le catalogue
  (`Python_geodatasets_geoda.airbnb`) — ne pas confondre, ce sont deux jeux
  distincts malgre le nom commun "Airbnb".

## Pourquoi le garder comme candidat

- Cas d'usage de regression spatiale avance (SAR/SEM, lags spatiaux explicites
  `wx_*`), plus riche methodologiquement que la version Chicago pour
  benchmarker des estimateurs spatiaux.
- Variables documentees explicitement dans le chapitre, avec une formule de
  base et des variantes augmentees :

```
log_price ~ accommodates + bathrooms + bedrooms + beds
          + rt_Private_room + rt_Shared_room
          + pg_Condominium + pg_House + pg_Other + pg_Townhouse
```

  Variantes augmentees ajoutent `d2balboa` (distance a Balboa Park) et des
  lags spatiaux `wx_*`.

- **Important** : cette formule EST explicitement presente dans le code du
  chapitre (verifie -- contrairement au dataset Chicago, ou ChatGPT avait
  propose une formule plausible mais non citee verbatim sur la page source
  GeoDa). Source fiable pour `formula_pub` une fois le dataset acquis.

## A faire lors de l'acquisition

1. Identifier la source brute des donnees (probablement Inside Airbnb San
   Diego + shapefile de quartiers San Diego, assembles dans le notebook du
   livre — pas un package R/Python existant, donc hors perimetre de
   `export_sf_metadata.R`/`generate_fiches.py` qui ne couvrent que les
   packages).
2. Verifier license/reutilisation des donnees Inside Airbnb (souvent
   restrictive sur la redistribution brute).
3. Si acquis : suivre le schema Tier 1-compatible standard (cf.
   `wiki/metadata/catalog_registry_schema_v3.md`), avec `formula_pub`
   directement renseignable depuis ce chapitre (pas besoin de recherche LLM,
   la source est deja identifiee ici).

## Sources

- Chapitre source : https://geographicdata.science/book/notebooks/11_regression.html
- Comparaison avec dataset existant : [[Python_geodatasets_geoda.airbnb]]

## Related Pages

- [[Python_geodatasets_geoda.airbnb]]
- [[catalog_registry_schema_v3]]
