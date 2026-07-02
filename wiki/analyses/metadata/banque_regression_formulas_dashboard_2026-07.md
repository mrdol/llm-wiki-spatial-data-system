---
title: banque_regression_formulas_dashboard_2026-07
type: analysis
created: 2026-07-02
updated: 2026-07-02
sources:
  - data/manifests/datasets/software_catalog_combined.RData
  - data/manifests/datasets/software_catalog_curated_final.RData
  - tools/regression_formulas_2026-07/regression_findings.py
tags: [analysis, dashboard, banque, regression-formulas, curation, software-catalog]
---

Tableau de bord actualisé de l'état d'avancement de la banque de fiches datasets (packages R/Python), reprenant la structure de l'entonnoir existant et y ajoutant les nouvelles dimensions issues de la mission "formules de régression canoniques" (2026-07).

> **Périmètre et limite de la reconstitution** — La partie "entonnoir amont" ci-dessous a été recalculée directement à partir des fichiers `.RData` de curation (`software_catalog_combined.RData`, `software_catalog_curated_final.RData`) via `tools/regression_formulas_2026-07/inspect_rdata_funnel2.R`, faute d'accès au support beamer original cité dans la mission (non présent dans ce dépôt). La structure textuelle demandée (jeux curés → non spatiaux / spatialement exploitables → statiques / avec dimension temporelle) est respectée, mais la mise en forme visuelle du beamer d'origine n'a pas pu être reproduite à l'identique.

## Entonnoir amont — curation du catalogue software (R + Python)

### Étape 1 — Catalogue combiné complet (avant arbitrage des doublons R/Python)

Source : `software_catalog_combined.RData::catalogue_combine_complet` (1178 lignes).

| Categorie | Python | R | Total |
|---|---|---|---|
| Bons candidats spatial | 85 | 72 | 157 |
| Spatial simple | 72 | 183 | 255 |
| ML non spatial | 0 | 566 | 566 |
| Declasser auxiliaire | 75 | 125 | 200 |
| **Total** | **232** | **946** | **1178** |

### Étape 2 — Catalogue curé final (après arbitrage des doublons R/Python, décision `keep`)

Source : `software_catalog_curated_final.RData::Synthese` (783 lignes réparties en 5 feuilles).

| Feuille | Lignes | dont `keep = yes` (R) | dont `keep = yes` (Python) | dont `keep = yes` (total) |
|---|---|---|---|---|
| Bons_candidats_spatial | 211 | 0 | 98 | **98** |
| Spatial_simple | 88 | 0 | 11 | 11 |
| ML_non_spatial | 459 | 0 | 8 | 8 |
| Declasser_auxiliaire_Python | 14 | — | 14 | 14 |
| Declasser_auxiliaire_R | 11 | 0 | — | 0 |
| **Total** | **783** | | | **131** |

> Note lue dans `Synthese` : "Les doublons Python déjà présents dans R ne sont pas inclus ici, car ils étaient isolés dans la feuille 'Déjà dans R' du classeur Python." Le CSV final est plat ; la colonne `final_sheet` indique la feuille d'origine.

### Étape 3 — Banque de fiches wiki effectivement générée

Les **98 datasets `keep = yes` de la feuille `Bons_candidats_spatial`** sont exactement les 98 fiches actuellement présentes dans `wiki/datasets/packages/` (vérifié par correspondance 1:1 avec `tools/regression_formulas_2026-07/check_files.py`). C'est le périmètre sur lequel porte tout le reste de ce tableau de bord.

### Statique vs. dimension temporelle (parmi les 98 fiches retenues)

Source : colonne `has_datetime` de `Bons_candidats_spatial` (catalogue amont, avant les corrections N/T de la Tâche 2 — voir section dédiée ci-dessous pour les corrections fiche-par-fiche).

| Profil | N fiches |
|---|---|
| Statique (`has_datetime = No`) | 74 |
| Avec dimension temporelle (`has_datetime = Yes`) | 24 |
| **Total** | **98** |

### Tailles N et nombre de variables K (catalogue amont, 98 fiches retenues)

| | N (observations) | K (variables) |
|---|---|---|
| Min | 24 | 2 |
| 1er quartile | 77 | 24 |
| Médiane | 117 | 35 |
| Moyenne | 48 162 (forte asymétrie — quelques très grands N) | 44.65 |
| 3e quartile | 1 506 | 60 |
| Max | 4 251 660 | 140 |

## Nouvelles dimensions (mission formules de régression, 2026-07)

Périmètre : les 98 fiches de `wiki/datasets/packages/`. Source : `tools/regression_formulas_2026-07/regression_findings.py` (table `FINDINGS`, croisée avec chaque fiche).

### Statut régression canonique

| Statut | N fiches | % |
|---|---|---|
| ✅ Bon candidat | 36 | 36.7% |
| 🟡 À vérifier | 7 | 7.1% |
| 🔵 Candidat par analogie — non vérifié | 27 | 27.6% |
| ❌ Mauvais candidat | 27 | 27.6% |
| 🔖 Mis de côté (objet dérivé, ex. matrice de voisinage) | 1 | 1.0% |
| **Total** | **98** | 100% |

### Niveau de preuve (bons candidats + candidats par analogie, N=63)

| Niveau de preuve | N fiches |
|---|---|
| Verbatim (équation/code exact retrouvé dans la source) | 33 |
| Analogie (candidat par analogie, non vérifié) | 27 |
| Article (formule tirée d'une source tierce) | 8 |
| Code (reconstruite à partir de la liste de variables) | 1 |

### Répartition par méthode d'estimation (bons candidats + candidats par analogie)

| Méthode | N fiches |
|---|---|
| OLS | 29 |
| GWR (régression géographiquement pondérée) | 14 |
| GLM / GLMM (Poisson, binomial, logistique) | 7 |
| SEM / SAR (autorégression spatiale) | 5 |
| Krigeage (universel / spatio-temporel) | 3 |
| twinSIR (survie / processus de comptage épidémique) | 2 |
| Bayésien hiérarchique (CAR) | 1 |
| PLS | 1 |
| Régression multiple log-log | 1 |

### Tâche 4, 2e passe (2026-07-02) — revue analogie des 59 mauvais candidats / à vérifier

La première passe (2026-07-01) n'avait proposé une formule par analogie que pour 2 fiches
découvertes hors périmètre de la mission (`Python_libpysal_Snow`, `Python_libpysal_chicagoSDOH`).
Une revue systématique des 59 fiches classées `mauvais candidat` (48) ou `à vérifier` (11) par
la mission a ensuite été menée (`tools/regression_formulas_2026-07/task4_full_pass.py`), en
lisant les variables Y/X réelles de chaque fiche :

- **25 fiches** reclassées `candidat par analogie — non vérifié` avec une formule structurellement
  cohérente (jamais basée sur un mot-clé ou une géographie superficielle) :
  - **9 fiches** GeoDa "small area" (`charleston1`, `hickory1`, `lansing1`, `orlando1`,
    `sacramento1`, `savannah1`, `seattle1`, `tampa1`, `milwaukee1`) — même schéma de colonnes
    (`HH_INC`/`HSG_VAL`/`POV_TOT` ~ composition démographique/raciale/emploi), analogie à
    `spdata.boston` (hédonique census-tract).
  - **3 fiches** santé publique (`chicago_health`, `health_indicators`, `health`) — analogie à
    `geoda.us_sdoh` (déterminants sociaux de la santé).
  - **3 fiches** socioéconomiques (`nyc_neighborhoods`, `Python_libpysal_NYC_Socio-Demographics`,
    `phoenix_acs`) — analogie à `geoda.police`/`geoda.us_sdoh`.
  - `airbnb` (analogie hédonique Baltimore/Boston), `nyc` (idem, + note sur un pattern de
    colonnes suffixées par année à vérifier séparément), `Python_libpysal_Elections`
    (analogie à `USelect2004`, GWR électorale), `R_gstat_jura_jura.pred`/`jura.val`/
    `R_ade4_tintoodiel` (analogie à `meuse.all`, régression métaux lourds), `R_gstat_oxford`
    (analogie à `gartner.corn`, élévation), `R_spData_properties` (hédonique directe),
    `R_ade4_irishdata` (analogie à `wallace.iowaland`, économie rurale), et `R_spData_world`
    (courbe de Preston 1975, relation canonique documentée dans la littérature plutôt
    qu'analogie à un autre jeu de la banque).
- **30 fiches** revues et **maintenues sans changement** avec justification explicite de
  l'absence d'analogie pertinente (pas simplement ignorées) : 17 fiches `ade4` supplémentaires
  (structure d'ordination multivariée confirmée, ou colonnes non identifiables), 3 fiches
  GeoDa "PCTIME"/établissements d'entreprise (aucun bon candidat comparable dans la banque),
  et 10 autres cas (grilles de prédiction, données trop minces, covariables administratives
  circulaires, etc. — détail complet dans `task4_full_pass.py`).
- **4 fiches** laissées inchangées car déjà résolues lors de la 1ère passe (`chile_labor`,
  `oribatid`, `DE_RB_2005`, `depmunic`).

Aucune reclassification directe en `bon candidat` n'a résulté de cette revue — toutes les
formules proposées restent explicitement étiquetées `candidat par analogie — non vérifié`
(niveau de preuve `analogie`), en attente de confirmation.

### Résolution par homologues Python/R (Tâche 3)

**5 paires** de datasets identiques sous enveloppe Python et R résolues en propageant la formule d'un côté vers l'autre :

| Paire | Dataset source de la formule |
|---|---|
| `Python_libpysal_georgia` ↔ `R_GWmodel_GeorgiaCounties_Gedu.counties` | R (GWmodel, Fotheringham et al. 2002) — cas confirmé dans la mission |
| `R_GWmodel_LondonBorough_londonborough` ↔ `R_GWmodel_LondonHP_londonhp` | LondonHP porte les observations hédoniques ; londonborough les polygones |
| `R_agridat_lasrosas.corn_lasrosas.corn` ↔ `Python_geodatasets_geoda.lasrosas` | GeoDa (Anselin, Bongiovanni & Lowenberg-DeBoer 2004) |
| `R_sp_meuse_meuse` ↔ `R_gstat_meuse.all_meuse.all` | gstat (tutoriel officiel Pebesma) |
| `R_spdep_oldcol_COL.OLD` ↔ `Python_geodatasets_spdata.columbus` | spData (Anselin 1988) |

Aucun cas de "mauvais candidat" reclassé en "bon candidat" grâce à un homologue n'a été identifié au-delà de ces 5 paires. Un quasi-doublon intra-Python (pas un homologue Python/R au sens de la Tâche 3) a en revanche été repéré lors de la revue Tâche 4 : `Python_geodatasets_geoda.nyc_neighborhoods` et `Python_libpysal_NYC_Socio-Demographics` partagent un schéma de colonnes quasi identique (probable même donnée NYC distribuée sous deux packages) — à vérifier séparément.

### Corrections de métadonnées N/T (Tâche 2)

**8 fiches** corrigées : une variable continue par observation (timestamp GPS, date de vente individuelle, indicateur de santé...) avait été prise à tort pour un axe temporel répété (`Structure: panel` avec `T periods` élevé), alors qu'il s'agit de coupes transversales.

| Fiche | Avant | Après |
|---|---|---|
| `R_spDataLarge_pol_pres15_pol_pres15` | N=2495, T=2069, panel | N=2495, T=1, coupe transversale |
| `R_agridat_gartner.corn_gartner.corn` | N=4949, T=4949, panel | N=4949, T=1, coupe transversale |
| `R_spData_house_house` | N=25357, T=1444, panel | N=25357, T=1, coupe transversale |
| `Python_libpysal_chicagoSDOH` | N=791, T=617, panel | N=791, T=1, coupe transversale |
| `Python_geodatasets_geoda.home_sales` | N=21613, T=372, panel | N=21613, T=1, coupe transversale |
| `Python_geodatasets_geoda.charleston2` | N=42, T=40, panel | N=42, T=1, coupe transversale |
| `Python_geodatasets_geoda.hickory2` | N=29, T=29, panel | N=29, T=1, coupe transversale |
| `Python_geodatasets_geoda.lansing2` | N=46, T=42, panel | N=46, T=1, coupe transversale |

### Corrections de licence (Tâche 2)

**5 fiches** `agridat` corrigées : licence package déclarée à tort `GPL-2`, alors que `wiki/datasets/r_package_docs/agridat/agridat.md` documente `MIT + file LICENSE` — `gartner.corn`, `lasrosas.corn`, `ortiz.tomato.covs`, `usgs.herbicides`, `wallace.iowaland`. Une licence spécifique aux données (distincte de la licence du package) a en outre été documentée pour `gartner.corn` (Creative Commons BY-SA 3.0, University of Minnesota Precision Agriculture Center).

Vérification systématique (`license_crosscheck.py`) sur les 48 fiches disposant d'une documentation `r_package_docs` correspondante : aucune autre divergence détectée.

## Sources et reproductibilité

- Table de référence et scripts : `tools/regression_formulas_2026-07/` (voir son `README.md`)
- Données brutes de ce tableau de bord : `data/manifests/datasets/banque_regression_dashboard_2026-07.json` et `.csv`
- Entonnoir amont recalculé via : `tools/regression_formulas_2026-07/inspect_rdata_funnel2.R` (sortie sauvegardée dans `rdata_funnel_report.txt` du même dossier)

## Related Pages

- [[catalog_registry_schema_v3]]
