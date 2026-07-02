---
name: enrich-metadata
description: >
  Genere des fiches wiki completes (6 blocs de metadonnees enrichies) pour les
  datasets spatiaux retenus dans catalogue_sf_index, via le script
  Code_scrapping/r_catalog/generate_fiches.py. Le catalogue sert de filtre
  uniquement. Y, X, N, T, CRS, bbox sont extraits directement des objets sf ;
  la selection des candidats Y/X est faite par un LLM (Claude Sonnet 4.6),
  pas par heuristique de script. Invoquer quand l'utilisateur dit :
  "enrichis les metadonnees", "genere les fiches sf", "cree les fiches du
  catalogue", "batch r_package", "traite les .rds". Necessite
  data/sf_catalog_metadata.json -- si absent, demander d'executer
  Code_scrapping/r_catalog/export_sf_metadata.R dans RStudio (ou Rscript).
---

# enrich-metadata

Genere les fiches wiki dataset selon les 6 blocs de metadata_construction.pdf.
Vocabulaire : CONTEXT.md. Schema valide par : LLM-wiki-Assessment/eval/tier1_structural.py
(les libelles de champs y sont en anglais et litteraux -- voir plus bas).

**Ce skill n'est plus un template a suivre manuellement.** La generation reelle
se fait par le script `Code_scrapping/r_catalog/generate_fiches.py`, qui :

1. lit `data/sf_catalog_metadata.json` (produit par `export_sf_metadata.R`,
   lequel ne fait QUE de la typologie statistique par colonne -- continuous/
   count/binary/rate/categorical -- et separe deterministiquement les
   coordonnees x/y et les identifiants, sans aucun jugement Y/X) ;
2. appelle Claude Sonnet 4.6 (1 appel par dataset, mis en cache dans
   `data/yx_llm_cache.json`) pour selectionner les candidats Y et X parmi les
   colonnes typees -- le LLM peut ignorer des colonnes (ex : codes
   administratifs FIPS/MSA) si elles ne sont ni une cible ni une covariable
   utile ;
3. rend la fiche au format Bloc 1-6 ci-dessous dans `wiki/datasets/packages/<dataset_id>.md`.

Ce skill sert maintenant de **documentation du flux reel**, pas de template
concurrent. Si tu dois generer des fiches, execute le script -- ne genere pas
de fiches "a la main" en suivant un ancien template, le format divergerait de
ce que `tier1_structural.py` valide.

Principe : catalogue index_sf = filtre uniquement. Y, X, N, T, CRS = extraits
du sf. La documentation de reference est dans wiki/datasets/r_package_docs/.

---

## Etape 0 -- Verifier le JSON

Verifier que `data/sf_catalog_metadata.json` existe et est recent.

Si absent ou perime : demander a l'utilisateur de lancer (RStudio ou Rscript) :

```r
source("Code_scrapping/r_catalog/export_sf_metadata.R")
```

ou en ligne de commande :

```bash
Rscript Code_scrapping/r_catalog/export_sf_metadata.R
```

Lire les compteurs en tete du JSON :
`n_datasets_inspected`, `n_exact_duplicates`, `n_suspect_versions`, `n_ok`

Si `n_suspect_versions > 0` : passer a l'Etape 1 avant de generer les fiches.

---

## Etape 1 -- Resoudre les doublons suspects

Pour chaque groupe dans `suspect_versions` du JSON :

Lire la fiche de documentation de chaque version :
`wiki/datasets/r_package_docs/<Package>/topics/<dataset>.md`
(le nom du package respecte la casse du repertoire ; le nom du dataset
est en minuscules avec extension .md)

Comparer les versions sur ces criteres (dans l'ordre de priorite) :

| Critere | Signal dans la fiche doc |
|---|---|
| Version corrigee/augmentee | Titre contient "Corrected", "Augmented", "Extended" |
| Plus de variables | Section Format : plus de colonnes documentees |
| Coordonnees incluses | Mention de LON/LAT ou x/y dans les colonnes |
| Reference publiee | Section References non vide |
| Version plus recente | Numero de version du package dans l'en-tete |

Proposer : "Je recommande de retenir `<dataset_id>` (`<package>`) car `<raison courte>`.
Les autres versions seront marquees `duplicate_of`. Confirmes-tu ?"

Attendre confirmation avant de marquer quoi que ce soit.

Une fois confirme : encoder le choix dans `CONFIRMED_KEEP` /
`CONFIRMED_DISCARD` en tete de `Code_scrapping/r_catalog/generate_fiches.py`
(ce sont les ensembles qui pilotent `should_keep()`).

---

## Etape 2 -- Generer les fiches (batch)

Executer le script directement -- il gere le JSON, le cache LLM, les doublons,
et l'ecriture des fiches :

```bash
PYTHON="C:/Users/jdoliveira/SynologyDrive/johnny D'OLIVEIRA/Travaux stages/.venv/Scripts/python.exe"
"$PYTHON" Code_scrapping/r_catalog/generate_fiches.py --overwrite
```

Options utiles :

- `--dry-run` : affiche le bilan sans ecrire de fichiers.
- `--no-llm` : desactive l'appel LLM pour Y/X (fiches avec Y/X "not identified").
- `--refresh-llm` : ignore le cache et rappelle le LLM pour chaque dataset.

Necessite `ANTHROPIC_API_KEY` dans `.env` a la racine du repo pour l'etape Y/X.

Apres batch -> lancer `eval-fiche` sur toutes les fiches creees (`wiki/datasets/packages/*.md`).

---

## Format de fiche genere (reference, pas un template a copier)

Le script produit ce format -- les libelles de champs sont en anglais et
litteraux car `tier1_structural.py` les recherche par regex exacte dans le
corps du texte (ex: `data\s*type\s*:`), independamment du titre de section
sous lequel ils se trouvent. Seul `## Related Pages` doit rester un titre de
section litteral (pas de fallback regex pour ce champ).

```markdown
---
title: <dataset_id>
type: dataset
created: <date>
updated: <date>
sources:
  - <rds_path>
tags: [dataset, r-package|python-package, spatial, <geom_type_lowercase>]
---

<description courte, extraite de la doc du package ou generique>

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: <selectionnees par le LLM parmi les colonnes typees>
- Candidate Y typology: <continuous|count|binary|rate|categorical|unknown>
- Candidate X variables: <selectionnees par le LLM>
- Candidate X typology: <continuous|categorical|spatial|temporal|...>
- Coordinates (x, y - excluded from X candidates): <colonnes x/y, routage deterministe>
- Identifier columns (excluded from X candidates): <colonnes id/code/key, routage deterministe>
- Variables inspected: yes (auto - export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y / Detail X
(tables avec classe R, typologie, plage, NA%)

> Selection Y/X (claude-sonnet-4-6) : <rationale du LLM>

### Formule - niveau publication

- formula_pub / x_terms_pub / y_term_pub : pending (sauf si extrait de la doc du
  package, ou propage automatiquement depuis un homologue Python/R -- voir
  "Correspondance Python/R" plus bas)
- Reference publication : pending ou extraite de la doc

### Statut regression canonique

- Statut : pending | bon candidat | a verifier | mauvais candidat |
  mis de cote | candidat par analogie -- non verifie
- Niveau de preuve : n/a | verbatim | code | article | analogie
- Methode d'estimation : pending ou libelle libre (OLS, GWR, GLM Poisson, SEM/SAR,
  krigeage, Bayesien hierarchique, twinSIR, PLS, ...)
- Correspondance Python/R : dataset_id de l'homologue si `PYTHON_R_HOMOLOGS`
  en contient un, sinon "aucune identifiee"
- Note : explique la propagation homologue ou reste "n/a"

### Formule - niveau systeme

- formula_used / x_terms_used / y_term_used : pending

## Bloc 2 - Identification et DOI

- Dataset ID, Dataset name, Source family, Source, Source URL
- Dataset DOI: none (declare explicitement absent -- warning, pas erreur, dans Tier 1)
- Publication DOI: pending
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1/2/3 (tache/famille/variante) : pending - a completer manuellement
  ou via enrich-metadata-web une fois la publication associee identifiee
- Bloc `modeling_evidence:` (yaml) : existing_model_found, equation_text,
  equation_family, model_family, source_type, source_ref, confidence --
  reflete le meme statut que "Statut regression canonique" du Bloc 1, requis
  par `DATASET_ENRICHED_PATTERNS` de `tier1_structural.py` (warning si absent)

## Bloc 4 - Typologie des donnees

- Data type, Structure, N observations, T periods, Variable temporelle, N/T profile

## Bloc 5 - Resolution et etendue

- Spatial/Temporal resolution, Spatial extent, Time range
- Type de geometrie, CRS EPSG, CRS nom, CRS analyse recommande

## Bloc 6 - Reproductibilite

- License present/name/URL/open: unknown (a completer)
- Reproducibility status, Code available, Repository

## Quality Control

<warnings NA>20%, CRS manquant, geometrie complexe, ou "Aucune anomalie detectee">

## Related Pages

- Source: <label source>
```

---

## Champs auto-remplis vs. pending

| Bloc | Auto (sf + LLM + doc package) | Pending (article / web / decision manuelle) |
|---|---|---|
| 1 | Y/X candidats + typologies (LLM), coordonnees/identifiants exclus (script), formule + Statut regression canonique **si homologue Python/R deja resolu** | formula_pub, formula_used, leurs termes (sinon) ; Statut/Niveau de preuve/Methode restent "pending" tant qu'aucune recherche manuelle ou aucun homologue ne les alimente |
| 2 | dataset_id, package, source URL | Publication DOI, Year |
| 3 | Bloc `modeling_evidence:` (miroir du Bloc 1, auto si homologue resolu) | Modele niveau 1/2/3 (necessite la publication associee ou une decision methodologique) |
| 4 | N, T, data_type, structure, profil_nt | -- |
| 5 | geom_type, CRS, bbox, resolution spatiale (heuristique geometrie) | resolution/etendue temporelle si T>1 |
| 6 | -- | licence, reproducibility detail |

Les champs pending peuvent etre completes par un futur skill `enrich-metadata-web`
(lecture de publication associee, lookup DOI/licence) -- pas encore implemente.

---

## Etape 3 -- Correspondance Python/R et formules par analogie (Tache 1-4, mission 2026-07)

Un meme jeu de donnees sous-jacent est parfois distribue sous deux enveloppes
de package differentes (ex: `Python_libpysal_georgia` et
`R_GWmodel_GeorgiaCounties_Gedu.counties` sont le meme dataset Georgia de
Fotheringham et al. 2002 ; seule la doc R contenait la formule exploitable).

### 3a. Verification systematique de l'homologue

`generate_fiches.py` maintient une table `PYTHON_R_HOMOLOGS` (dataset_id ->
dataset_id de l'homologue). A chaque generation/regeneration de fiche :

1. Si `did` a une entree dans `PYTHON_R_HOMOLOGS` et que la fiche de
   l'homologue existe deja avec un `formula_pub` non-pending, la formule, le
   statut, le niveau de preuve, la methode et la source sont **propages
   automatiquement** (`find_homolog_formula()`), avec une note explicite de
   propagation dans le champ "Note".
2. Si aucun homologue n'est enregistre dans la table mais qu'un dataset au
   nom ou aux variables tres proches existe dans l'autre langage, l'ajouter
   manuellement a `PYTHON_R_HOMOLOGS` dans `generate_fiches.py` avant de
   regenerer.
3. **Ne jamais classer un dataset en "mauvais candidat" sans avoir verifie
   l'existence d'un homologue croise Python/R.**

### 3b. Formule candidate par analogie

Quand aucune formule verbatim/article n'est trouvee et qu'aucun homologue
n'existe, un dataset peut recevoir une formule **candidat par analogie**
lorsqu'un autre dataset deja classe "bon candidat" partage une structure
substantiellement similaire (variables, geographie, domaine).

Cette decision **n'est jamais automatisee** (pas de regle de similarite
textuelle/statistique) -- c'est un jugement explicite du LLM ou de
l'utilisateur au moment de la revue :

- Statut : `candidat par analogie -- non verifie`
- Niveau de preuve : `analogie`
- Note : nommer le dataset de reference et expliciter pourquoi l'analogie
  est substantiellement coherente (variable reponse plausible, covariables
  reellement presentes dans le fichier, direction de causalite sensee) --
  ne jamais proposer une formule uniquement parce que deux datasets
  partagent un mot-cle ou une origine geographique superficielle.

Exemple traite : `Python_libpysal_Snow` (cholera de John Snow, Londres 1854)
sans formule publiee -> analogie avec les modeles de comptage de maladies en
fonction de facteurs de proximite (`geoda.nydata`, `pennLC_sf`), domaine
substantiellement identique (epidemiologie spatiale de comptages ponctuels).

`tier1_structural.py` verifie la coherence Statut/Niveau de preuve (les deux
doivent indiquer l'analogie ensemble, jamais l'un sans l'autre) et qu'un
"bon candidat" a bien une formule non vide -- voir skill `eval-fiche`.

---

## Apres le batch

Lancer `eval-fiche` sur toutes les fiches generees (`wiki/datasets/packages/*.md`).
Reporter : N fiches creees, N PASS, N AMBER, N doublons suspects resolus.

Ne jamais modifier les `.rds` ni les fiches doc brutes (`topics/<dataset>.md`).
Ne jamais regenerer "a la main" en suivant un ancien template -- toujours
passer par `generate_fiches.py` pour rester synchronise avec Tier 1.
