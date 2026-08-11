# Référentiels de jointure géométrique externe

Ce dossier contient les scripts et la documentation des jointures nom/code → géométrie
utilisées pour les datasets Bloc 3 (entrepôts) dont les données brutes ne portent que
des codes/noms administratifs (pas de coordonnées ni de géométrie directe).

Les fichiers de géométrie eux-mêmes sont dans `data/reference/admin_boundaries/`
(version allégée : uniquement les couches/niveaux effectivement utilisés).

**Règle appliquée systématiquement : aucune jointure n'est commise sans vérification
0 ligne non appariée (`assert n_unmatched == 0`).** Les correspondances ambiguës ou
partielles sont rapportées, jamais forcées silencieusement.

## Référentiels disponibles

| Pays / zone | Niveau | Fichier | Source | Colonne clé |
|---|---|---|---|---|
| Turquie | ADM1 (provinces, 81) | `turkey_adm1_provinces.gpkg` | GADM 4.1 | `NAME_1` + `VARNAME_1` (variantes) |
| Corée du Sud | sigungu (municipalités, 250 dont 11 agrégées) | `korea_sigungu_kostat2018.gpkg` | KOSTAT 2018 (via `southkorea/southkorea-maps` GitHub) | `name` (Hangul natif), `code` |
| Chine | ADM1 (provinces, 33 dissoutes) | `china_adm1_provinces_dissolved.gpkg` | GADM 4.1 | `NAME_1` (anglais) |
| Chine | ADM2 (préfectures, 368) + ADM1 (municipalités de rang provincial) | `china_adm2_prefectures.gpkg` | GADM 4.1 | `NL_NAME_2` / `NL_NAME_1` (chinois natif, séparateur `\|` simplifié/traditionnel) |
| Maroc | ADM2 (provinces/préfectures, 75, découpage post-réforme 2015) | `morocco_adm2_provinces_geoboundaries.gpkg` | geoBoundaries (OSM, ODbL) | `shapeName` (mixte anglais/français/arabe) |
| Mexique | Municipios (2469) | `mexico_municipios_inegi.gpkg` | Package R `mxmaps` (diegovalle), source INEGI Marco Geoestadístico | `region` (code INEGI 5 chiffres CVE_ENT+CVE_MUN) |

**Note Maroc** : GADM ADM2 (54 unités, découpage pré-2015) a été écarté car il ne
correspond pas au nombre officiel actuel de provinces/préfectures (75) — utiliser
`morocco_adm2_provinces_geoboundaries.gpkg`, pas GADM, pour ce pays.

**Note Mexique** : `mxmunicipio.map.RData` du package `mxmaps` est au format
ggplot2 "fortify" (long/lat/order/piece/hole), pas un objet sf. Reconstruit via
`export_mx2.R` (union des pièces par code région ; ~61 points sur 133k marqués
"hole" traités comme anneaux simples, impact négligeable pour une jointure par code).

## Scripts de jointure (référence, à adapter par dataset)

- `join_turkey.py` — nom de province (`IL_ADI`) → GADM ADM1, verifié 81/81
- `join_korea.py` — nom sigungu (Hangul) → KOSTAT, avec dissolution des 11 grandes
  villes subdivisées et 1 district renommé (vérifié par centroïde), 229/229
- `join_china_provinces.py` — nom de province (anglais) → GADM ADM1 dissous, avec
  alias (Nei Mongol→Inner Mongolia, Ningxia Hui→Ningxia, Xinjiang Uygur→Xinjiang),
  30/30 sur 2 datasets
- `join_morocco.py` — nom de province → geoBoundaries ADM2, normalisation (accents,
  mots administratifs, script arabe) + 7 alias orthographiques vérifiés, 75/75
- `join_mexico.py` — code INEGI (CVE_ENT+CVE_MUN) → mxmaps municipios, 860/860
  (jointure par code, pas par nom — la plus fiable des 6)
- `join_china_cities.py` — nom de ville (chinois natif) → GADM ADM2/ADM1, avec
  éclatement des variantes simplifié/traditionnel (séparateur `\|`) et 1 renommage
  administratif vérifié par recherche indépendante (Xiangfan→Xiangyang, 2010-12-09),
  108/108

## Réutilisation pour un nouveau dataset du même pays

1. Charger le référentiel correspondant depuis `data/reference/admin_boundaries/`
   (pas besoin de retélécharger).
2. Adapter le script de jointure le plus proche : nom de la colonne source, alias
   éventuels à vérifier au cas par cas (un nouveau dataset peut utiliser une
   orthographe/convention différente de celle déjà couverte par les alias existants).
3. Toujours revérifier `n_unmatched == 0` avant d'écrire le gpkg final — ne jamais
   supposer qu'un alias validé sur un dataset précédent couvre automatiquement un
   nouveau cas sans re-test.
