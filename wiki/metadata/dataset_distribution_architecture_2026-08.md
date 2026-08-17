---
title: Dataset Distribution Architecture (spatialtidymodels)
type: metadata
created: 2026-08-17
updated: 2026-08-17
sources: []
tags: [metadata, package, spatialtidymodels, distribution, architecture, proposal]
---

Analyse et proposition d'architecture pour la distribution des jeux de donnees du package `spatialtidymodels` en dehors du depot `llm-wiki-karpathy`. Document de decision -- la partie "Option 3" n'est **pas implementee** ; seuls le schema de metadonnees et la distinction source/tache le sont (session 2026-08-17).

## 1. Constat de depart

`inst/metadata/datasets.json` documente 289 fiches. Parmi elles :

- 155 marquees `package_include: "yes"` par la fiche elle-meme ;
- 117 passent en plus tous les blockers structurels du script d'export (`benchmark_ready = TRUE` -- formule executable, `## Estimator eligibility` et `Selection Y/X` presents, tache non-classification, etc.) et sont donc **effectivement** exposees par `available_benchmark_datasets()` ;
- 7 sont en plus embarquees comme objets `data()` natifs du package (`georgia`, `columbus_crime`, `london_hp`, `boston_housing`, `dub_voter`, `ewhp`, `lasrosas`), utilisables sans le depot source ;
- les 110 autres datasets `benchmark_ready` ne sont utilisables que depuis l'interieur du depot `llm-wiki-karpathy` (chemin `data/final_datasets/sf/...` resolu par `find_benchmark_repo_root()`).

Le README du package documentait a tort ce chiffre comme "155 exposes" -- corrige en pointant vers `benchmark_ready` (117), pas `package_include` (155), lors de l'audit de reprise du 2026-08-17.

## 2. Trois architectures possibles

### Option 1 -- Tout dans `spatialtidymodels`

Les ~110 datasets manquants deviennent des objets `data()` embarques, comme les 7 actuels.

- **Avantages** : simple, fonctionne hors ligne apres installation, aucune dependance reseau au moment du benchmark.
- **Inconvenients** : couple code et donnees dans un seul cycle de publication (toute mise a jour d'un dataset = republier le package) ; taille du package qui grossit a chaque nouveau dataset ajoute au pipeline (le pipeline papiers en ajoute regulierement, cf. les 32 sous-jeux `korea_hedonic_housing` ajoutes en une session) ; questions de licence non resolues pour les datasets papier dont la licence de redistribution n'a pas ete verifiee ; ne passe pas a l'echelle si le catalogue continue de croitre.

### Option 2 -- Package de donnees separe

`spatialtidymodels` (logiciel) + `spatialtidymodelsData` (ou plusieurs packages de donnees thematiques).

- **Avantages** : separation propre code/donnees, versions independantes, package logiciel reste leger.
- **Inconvenients** : deux (ou plus) packages a maintenir et synchroniser ; le(s) package(s) de donnees peuvent eux-memes devenir volumineux ; les questions de licence restent entieres, juste deplacees.

### Option 3 -- Entrepot externe + cache local (recommandee)

`spatialtidymodels` = logiciel + catalogue de metadonnees + une poignee de datasets de demonstration (les 7 actuels suffisent pour cet usage). La banque complete vit dans un entrepot scientifique externe (Recherche Data Gouv, Zenodo, ou toute solution institutionnelle adaptee -- a discuter, non tranche ici) ; l'utilisateur telecharge et met en cache localement ce dont il a besoin.

- **Avantages** : package logiciel toujours leger ; la banque de donnees grossit sans jamais republier le package ; chaque dataset garde sa propre tracabilite de licence/DOI externe ; scalable a 500+ datasets sans probleme.
- **Inconvenients** : necessite une connexion reseau au premier usage de chaque dataset non bundled ; necessite de choisir et operer un entrepot d'hebergement ; plus de pieces mobiles (cache local a gerer, checksums a verifier).

**Recommandation** : Option 3 en configuration hybride -- 5 a 10 petits datasets bundled pour les tests/exemples rapides (deja le cas), banque complete distante, cache local transparent, et les datasets dont la licence de redistribution n'est pas confirmee restent **references** (URL + DOI) sans etre re-heberges.

Cette recommandation n'a pas ete validee comme decision finale -- elle attend une confirmation explicite avant toute mise en oeuvre (choix de l'entrepot, budget de stockage, politique de cache).

## 3. Schema technique detaille -- Option 3 (proposition, non implementee)

### 3.1 Nouveaux champs du registre dataset

Deja implementes cote generateur (`code/package_metadata/export_spatialtidymodels_metadata.py`) et cote lecteur R (`R/metadata-registry.R`), disponibles dans `inst/metadata/datasets.json` et `available_benchmark_datasets()` des aujourd'hui :

| Champ | Calcule comment | Statut |
|---|---|---|
| `parent_dataset` | Lu depuis le bullet `Parent dataset:` du Bloc 2 de la fiche wiki (present uniquement sur les fiches issues d'un decoupage, ex. `paper_korea_hedonic_housing_2012`) | **implemente** |
| `source_dataset_id` | `parent_dataset` si present, sinon `dataset_id` lui-meme | **implemente** |
| `benchmark_task_id` | Toujours `dataset_id` (une tache de benchmark par fiche, decoupee ou non) | **implemente** |
| `bundled` | `TRUE` si `data_object` est renseigne (les 7 datasets `data()` actuels) | **implemente** |
| `storage` | `"bundled"` ou `"repo_only"` aujourd'hui ; `"remote_cached"` reserve pour l'Option 3 | **implemente** (valeur `remote_cached` jamais produite pour l'instant) |

Prepares dans le schema (colonnes presentes, `NULL`/`NA`/`FALSE` par defaut) mais **pas encore peuples** -- necessitent une decision (entrepot, verification de licence) avant de recevoir de vraies valeurs :

| Champ | A quoi il servira | Pourquoi non peuple maintenant |
|---|---|---|
| `download_url` | URL de telechargement dans l'entrepot externe choisi | Aucun entrepot choisi |
| `redistribution_allowed` | La licence source autorise-t-elle la re-heberger ? | Necessite une verification de licence par dataset -- travail de fond, pas inventable |
| `license_verified` | La licence a-t-elle ete effectivement controlee (pas juste recopiee de la fiche) ? | Idem |
| `checksum_sha256` | Integrite du fichier telecharge/cache | Calculable seulement une fois un artefact distribuable fixe |
| `size_bytes` | Budget de telechargement affichable a l'utilisateur avant de lancer un download | Idem |
| `benchmark_suite` | Liste des suites versionnees (section 4) contenant ce dataset | Depend du design des suites, voir section 4 |

**Important (deja applique)** : ces nouveaux champs sont ajoutes dans `ESTIMATOR_TAXONOMY`/`parse_dataset_fiche()` du script generateur -- source de verite -- pas ecrits a la main dans le JSON installe, qui serait ecrase au prochain export.

### 3.2 API future (esquisse, non implementee)

```r
available_benchmark_datasets()             # deja existant, colonnes storage/bundled/... deja presentes
download_benchmark_dataset(id, cache_dir = NULL)   # a ecrire : telecharge + verifie checksum + cache local
download_benchmark_suite(suite_id)                  # a ecrire : telecharge tous les datasets d'une suite
```

`download_benchmark_dataset()` consulterait `storage`/`download_url`/`checksum_sha256` du registre, ne ferait rien si `storage == "bundled"` (deja disponible via `data()`), et refuserait de telecharger un dataset avec `redistribution_allowed == FALSE` (erreur explicite renvoyant vers la source originale plutot qu'un contournement).

## 4. Concept "benchmark suites" (proposition, non implementee)

Une suite = une liste versionnee de `benchmark_task_id`, pensee comme un jeu d'evaluation standard reproductible (par analogie avec un split train/test versionne).

```text
sar_reference_v1        -- taches pertinentes pour comparer des variantes SAR
sem_reference_v1
spatial_prediction_v1
```

Extension proposee, retrocompatible (ne change rien a l'usage actuel par liste explicite de datasets) :

```r
benchmark_spatial_suite(
  datasets = "sar_reference_v1",   # NOUVEAU : accepte aussi un nom de suite ...
  estimators = c("sar_lag", "new_sar")
)
# ... equivalent, aujourd'hui deja possible, a :
benchmark_spatial_suite(
  datasets = c("columbus_crime", "georgia", "..."),
  estimators = c("sar_lag", "new_sar")
)
```

`benchmark_spatial_suite()` resoudrait un `character(1)` correspondant a une suite connue (table `benchmark_suite_registry()` a definir, elle-meme alimentee par le champ `benchmark_suite` du registre dataset) vers la liste de `benchmark_task_id` correspondante, puis suivrait le chemin existant. Aucune modification cassante de la signature actuelle.

## 5. Ne pas compter un decoupage comme plusieurs sources (implemente)

Probleme concret observe : `paper_korea_hedonic_housing` a ete decoupe en 32 sous-jeux temporels (31 annees + 1 bloc regroupe pre-1989) pour augmenter le nombre de taches de benchmark disponibles sans fabriquer de donnees. Sans garde-fou, ces 32 taches compteraient comme 32 sources independantes dans n'importe quel comptage/statistique agrege ("X datasets" affiches quelque part), ce qui fausserait artificiellement toute conclusion ponderee par nombre de sources.

Verifie sur le registre actuel :

```text
289 benchmark_task_id distincts (une par fiche)
257 source_dataset_id distincts (289 - 32 doublons de korea_hedonic_housing + 1 pour le parent lui-meme)
```

`source_dataset_id` est l'identifiant a utiliser pour toute statistique du type "N sources independantes couvertes" ; `benchmark_task_id` reste l'identifiant a utiliser pour toute execution effective de benchmark (chaque tache a sa propre formule executee, son propre resultat).

**Non fait volontairement** : une ponderation automatique dans `compare_estimator_variant()` qui reduirait le poids des cas provenant de la meme `source_dataset_id` (pour eviter qu'une source tres decoupee domine un verdict agrege). C'est une decision statistique qui merite sa propre discussion, pas un choix a figer silencieusement dans le code.

## 6. Ce qui reste ouvert

- Choix de l'entrepot externe pour l'Option 3 (aucun choisi).
- Politique de verification de licence par dataset avant `redistribution_allowed = TRUE`.
- Design de `benchmark_suite_registry()` et des suites elles-memes (quels datasets dans `sar_reference_v1` ?).
- Ponderation par source independante dans le moteur de comparaison (section 5).
- Ces quatre points necessitent une validation explicite avant implementation -- rien n'a ete uploade, aucun `.rda` supplementaire n'a ete cree.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- [[catalog_registry_schema_v3]]
