# Pipeline d'ingestion des jeux de donnees issus de papiers

Date : 2026-08-06

Ce document decrit le cheminement a suivre lorsqu'un papier scientifique, une source DataCite, Zenodo, Figshare, Dryad, Dataverse, GitHub ou une autre source externe pointe vers un jeu de donnees potentiellement exploitable pour le projet `llm-wiki-spatial-data-system`.

L'objectif n'est pas de creer directement une fiche dataset definitive. L'objectif est de faire passer chaque candidat par un sas de verification : bibliographie, PDF, TEI, KG, audit, curation, telechargement, preprocessing, fiche wiki, puis metadata package.

## Vue d'ensemble

```text
Recherche bibliographique / DataCite harvest
  -> candidats papier-dataset
  -> validation bibliographique
  -> PDF local legal/open access
  -> GROBID TEI
  -> parse TEI + lecture dirigee
  -> audit model evidence
  -> candidats KG
  -> rapport de revue
  -> curation humaine
  -> telechargement dataset
  -> preprocessing + conversion sf
  -> fiche dataset complete
  -> export metadata package
  -> spatialtidymodels
```

## Phase 1 - Rechercher des papiers et datasets candidats

But : trouver des papiers qui utilisent ou publient des jeux de donnees spatiaux exploitables.

Scripts et fichiers responsables :

- `tools/search_bib.md` : prompt de recherche bibliographique ciblee.
- `code/pipeline_lit/search_bib_candidates.py` : recherche bibliographique assistee quand disponible.
- `tools/harvest_datacite.R` : collecte DataCite de datasets candidats.
- `tools/run_datacite_harvest_pipeline.py` : lance la collecte, la verification et l'application des corrections si le pipeline DataCite est utilise.
- `tools/verify_datacite_candidates.py` : verification automatique/LLM des candidats DataCite.
- `tools/apply_datacite_verification.R` : applique les decisions de verification aux sorties DataCite.

Sorties a consulter :

- `gg/regression_article_search_*.md`
- `gg/regression_article_search_*.csv`
- `data/manifests/papers/datacite_spatial_dataset_candidates.csv`
- `data/manifests/papers/datacite_spatial_dataset_candidates.json`
- fichiers de verification manuelle dans `data/manifests/papers/`

Decision attendue :

- garder comme candidat ;
- rejeter ;
- demander verification manuelle ;
- chercher une meilleure source de donnees.

## Phase 2 - Valider bibliographiquement les papiers

But : separer les candidats bruts des papiers qu'on accepte de suivre dans le projet.

Scripts et fichiers responsables :

- `gg/regression_article.bib` : bibliographie de travail des articles relies a des datasets.
- `gg/datacite_from_pdf_2026-08.bib` : bibliographie produite depuis PDF, si `Biblio_from_pdf` est utilise.
- `tools/stage_biblio_from_pdf_datacite.py` : staging entre les PDF DataCite et le flux `Biblio_from_pdf`.
- `tools/download_doi_pdfs.py` : tentative de recuperation des PDF open access a partir des DOI.
- `code/package_metadata/download_regression_article_pdfs.py` : telechargement ou audit des PDF associes aux references de travail.

Sorties a consulter :

- `gg/regression_article.bib`
- `gg/regression_article_pdf_download_manifest_2026-08.tsv`
- `gg/regression_article_missing_pdf_download_manifest_2026-08.tsv`
- `gg/doi_pdf_download_manifest_2026-08.tsv`

Decision attendue :

- papier valide bibliographiquement ;
- PDF local disponible ;
- papier payant/non accessible, donc a rejeter ou a garder uniquement comme reference bibliographique ;
- papier sans dataset exploitable, donc a rejeter du flux dataset.

## Phase 3 - Promouvoir les papiers dans le corpus general

But : faire entrer uniquement les papiers valides dans le corpus principal du KG.

Scripts et fichiers responsables :

- `corpus/bib/references.bib` : bibliographie generale du corpus.
- `corpus/papers/raw_pdf/` : PDF locaux a traiter.
- `tools/kg/01_extract_bib.py` : extrait les references BibTeX vers le KG.

Sorties a consulter :

- `.kg/extracted/bib_nodes.jsonl`
- `.kg/extracted/bib_edges.jsonl`

Commande typique :

```powershell
python tools/kg/01_extract_bib.py
```

Decision attendue :

- le papier est present dans `references.bib` ;
- le champ `file` pointe vers un PDF local ;
- le papier peut passer a GROBID.

## Phase 4 - Convertir les PDF en TEI avec GROBID

But : transformer les PDF en XML TEI afin que les scripts puissent lire les sections, tableaux, references, formules et mentions de datasets.

Scripts et fichiers responsables :

- `tools/kg/02_run_grobid.py`
- `corpus/papers/raw_pdf/`
- `corpus/papers/tei/`

Sorties a consulter :

- `corpus/papers/tei/*.tei.xml`
- logs de GROBID dans la console

Commandes typiques :

```powershell
python tools/kg/02_run_grobid.py --from-bib
```

ou via le pipeline complet :

```powershell
python tools/kg/run_all.py --run-grobid --from-bib
```

Decision attendue :

- TEI cree ;
- TEI deja existant et saute ;
- PDF impossible a traiter ;
- OCR necessaire si le PDF est scanne.

## Phase 5 - Parser les TEI et produire l'audit de lecture dirigee

But : extraire les structures utiles du TEI sans confondre les equations generiques d'estimateur avec les formules empiriques appliquees aux donnees.

Scripts et fichiers responsables :

- `tools/kg/03_parse_tei.py`
- `tools/kg/section_role_rules.yml`
- `tools/kg/section_role.py`

Le parseur score les sections et tableaux selon leur role probable :

- `data_source`
- `preprocessing`
- `empirical_model`
- `results_model`
- `variable_tables`
- `model_tables`
- `generic_theory`
- `simulation`

Sorties a consulter :

- `.kg/extracted/tei_nodes.jsonl`
- `.kg/extracted/tei_edges.jsonl`
- `.kg/summaries/tei_parse_summary.md`
- `data/manifests/papers/model_evidence_audit.csv`

Commande typique :

```powershell
python tools/kg/03_parse_tei.py
```

Decision attendue :

- reperer les sections a forte priorite ;
- identifier les tableaux de variables ;
- bloquer les formules generiques ;
- conserver les formules candidates en statut `extracted_needs_review`.

## Phase 6 - Transformer l'audit en candidats KG

But : rendre les signaux issus de l'audit interrogeables dans le KG sans les valider automatiquement.

Scripts et fichiers responsables :

- `tools/kg/audit_reader.py`
- `tools/kg/08_extract_model_evidence.py`
- `tools/kg/09_extract_paper_dataset_uses.py`

Types de noeuds crees :

- `FormulaCandidate`
- `GenericEstimatorFormulaCandidate`
- `DataSourceCandidate`
- `VariableTableCandidate`
- `ModelTableCandidate`
- `ModelEvidenceCandidate`
- `PaperDatasetUseCandidate`

Sorties a consulter :

- `.kg/extracted/model_evidence_nodes.jsonl`
- `.kg/extracted/model_evidence_edges.jsonl`
- `.kg/extracted/paper_dataset_use_nodes.jsonl`
- `.kg/extracted/paper_dataset_use_edges.jsonl`

Commandes typiques :

```powershell
python tools/kg/08_extract_model_evidence.py
python tools/kg/09_extract_paper_dataset_uses.py
```

Decision attendue :

- ne pas promouvoir automatiquement ;
- isoler les candidats a relire ;
- conserver le statut :
  - `extracted_needs_review`
  - `blocked_needs_manual_review`
  - `rejected_generic_formula`

## Phase 7 - Produire le rapport de revue des candidats

But : fournir un document humain qui liste les passages prioritaires par papier.

Scripts et fichiers responsables :

- `tools/kg/10_make_audit_candidate_review.py`

Sortie a consulter :

- `wiki/analyses/model_evidence_candidates_review_2026-08.md`

Commande typique :

```powershell
python tools/kg/10_make_audit_candidate_review.py
```

Le rapport propose des actions :

- `review_for_dataset_use`
- `review_for_model_evidence`
- `reject_generic`
- `low_priority_review`

Decision attendue :

- selectionner les vrais datasets exploitables ;
- identifier les passages qui donnent la source de donnees ;
- identifier les variables Y/X ;
- identifier la formule ou la specification empirique ;
- rejeter les candidats theoriques ou trop vagues.

## Phase 8 - Interroger le KG

But : explorer rapidement les candidats par papier, type ou statut.

Script responsable :

- `tools/kg/query_kg.py`

Commandes utiles :

```powershell
python tools/kg/query_kg.py --audit-candidates --limit 20
python tools/kg/query_kg.py --audit-candidates --audit-paper Yang2022Niche --limit 10
python tools/kg/query_kg.py --audit-candidates --audit-kind DataSourceCandidate --limit 10
python tools/kg/query_kg.py --audit-candidates --audit-status extracted_needs_review --limit 10
python tools/kg/query_kg.py --paper-dataset-gaps
python tools/kg/query_kg.py --paper-dataset-uses 10.1007/s10109-025-00481-4
```

Sorties a consulter :

- affichage console ;
- `.kg/graph.sqlite` si une requete SQLite plus fine est necessaire.

Decision attendue :

- prioriser les papiers/datasets a curer ;
- reperer les faux positifs ;
- preparer la phase de telechargement des donnees.

## Phase 9 - Reconstruire le graphe SQLite

But : rendre toutes les sorties JSONL interrogeables dans une base unique.

Scripts responsables :

- `tools/kg/04_build_graph.py`
- `tools/kg/06_make_summaries.py`
- `tools/kg/07_export_agent_index.py`

Sorties a consulter :

- `.kg/graph.sqlite`
- `.kg/summaries/`
- index agent exporte par `07_export_agent_index.py`

Commandes typiques :

```powershell
python tools/kg/04_build_graph.py
python tools/kg/06_make_summaries.py
python tools/kg/07_export_agent_index.py stats
```

Decision attendue :

- verifier le nombre de noeuds/edges ;
- verifier que les nouveaux candidats apparaissent dans le KG ;
- verifier que les relations `HAS_AUDIT_CANDIDATE` et `HAS_PAPER_DATASET_USE_CANDIDATE` existent.

## Phase 10 - Telecharger les datasets candidats valides

But : recuperer les donnees seulement apres avoir etabli qu'elles sont probablement exploitables.

Ordre recommande :

```text
audit KG
  -> fiche candidate courte ou ligne de manifeste
  -> telechargement dataset
  -> inspection locale
  -> preprocessing
  -> fiche definitive
```

Le telechargement ne doit pas attendre la fiche definitive, mais il doit attendre une validation minimale :

- source de donnees identifiable ;
- donnees accessibles legalement ;
- lien de telechargement fonctionnel ;
- objet spatial probable ;
- papier ou documentation associee.

Dossiers cibles recommandes :

- donnees brutes : `data/raw/papers/<paper_or_dataset_slug>/`
- scripts de preprocessing : `code/paper_datasets/<dataset_slug>/`
- donnees finales : `data/final_datasets/sf/`

Sorties a consulter :

- manifest de telechargement a creer pour chaque vague ;
- logs de telechargement ;
- fichiers bruts conserves ;
- fichiers `.rds` ou `.gpkg` preprocesses.

Decision attendue :

- donnees telechargees ;
- format lisible ;
- taille raisonnable ;
- presence de coordonnees, geometrie, raster ou matrice W ;
- variables Y/X presentes ou reconstructibles.

## Phase 11 - Pretraiter et convertir en sf

But : produire une version propre et benchmarkable du dataset.

Scripts responsables :

- scripts dedies a creer dans `code/paper_datasets/<dataset_slug>/`
- scripts de conversion sf deja utilises pour les datasets packages si reutilisables
- fonctions communes du package `spatialtidymodels` si elles deviennent stables

Sorties a consulter :

- `data/final_datasets/sf/<source>_<dataset>.rds`
- eventuellement `.gpkg` pour conserver une version geospatiale standard
- logs de preprocessing

Checks minimaux :

- nombre d'observations ;
- variable reponse ;
- covariables ;
- geometrie ou coordonnees ;
- CRS ;
- valeurs manquantes ;
- doublons ;
- coherence avec le papier source ;
- formule ou specification empirique.

## Phase 12 - Creer ou actualiser les fiches datasets

But : transformer un dataset valide en metadata lisible par humain et exploitable par le package.

Scripts responsables :

- scripts de generation de fiches datasets existants dans le projet ;
- `code/package_metadata/export_spatialtidymodels_metadata.py` pour l'export package ;
- fichiers schema dans `wiki/metadata/`.

Sorties a consulter :

- `wiki/datasets/fiches_datasets/<dataset>.md`
- `packages/spatialtidymodels/inst/metadata/datasets.json`

La fiche definitive doit contenir au minimum :

- description du dataset et topic ;
- source papier/donnees ;
- DOI papier ou URL source ;
- acces donnees ;
- nombre d'observations ;
- variables ;
- formule candidate ou publiee ;
- type spatial ;
- CRS/geometrie/coordonnees ;
- quality control ;
- relation aux estimateurs eligibles.

Decision attendue :

- fiche validee ;
- dataset exporte dans les metadata package ;
- dataset listable depuis `spatialtidymodels`.

## Phase 13 - Rendre le dataset utilisable dans spatialtidymodels

But : rendre les datasets propres appelables par les fonctions du package.

Scripts responsables :

- `code/package_metadata/export_spatialtidymodels_metadata.py`
- `packages/spatialtidymodels/R/benchmark-datasets.R`
- `packages/spatialtidymodels/inst/metadata/datasets.json`
- fonctions package :
  - `available_benchmark_datasets()`
  - `benchmark_spatial_dataset()`
  - `explain_dataset()`
  - `explain_estimator()`

Sorties a consulter :

- `packages/spatialtidymodels/inst/metadata/datasets.json`
- sortie R de `available_benchmark_datasets()`
- sortie R de `explain_dataset("<dataset>")`
- premiers benchmarks de validation.

Commandes R typiques :

```r
library(spatialtidymodels)

available_benchmark_datasets()
explain_dataset("nom_dataset")

bench <- benchmark_spatial_dataset(
  "nom_dataset",
  estimators = c("ols", "random_forest", "sar_lag"),
  cv_scheme = "near_prediction",
  near_n_reps = 3,
  near_test_size = 100
)

bench$results
bench$resample_results
```

## Pipeline complet

Commande KG complete, sans relancer GROBID :

```powershell
python tools/kg/run_all.py
```

Commande KG complete avec GROBID :

```powershell
python tools/kg/run_all.py --run-grobid --from-bib
```

Ordre des etapes dans `run_all.py` :

```text
01_extract_bib.py
02_run_grobid.py                  optionnel
03_parse_tei.py
04_extract_dataset_catalogs.py
04_extract_web_sources.py
export_spatialtidymodels_metadata.py
08_extract_model_evidence.py
09_extract_paper_dataset_uses.py
10_make_audit_candidate_review.py
04_build_graph.py
06_make_summaries.py
07_export_agent_index.py stats
```

## Regle importante

Un candidat extrait automatiquement ne doit jamais devenir directement une fiche dataset definitive.

Il doit passer par au moins ces validations :

1. le papier utilise vraiment un dataset empirique ;
2. le dataset est spatial ;
3. la source de telechargement fonctionne ;
4. les donnees sont lisibles localement ;
5. les variables Y/X ou la specification empirique sont identifiees ;
6. le preprocessing est documente ;
7. une version finale benchmarkable existe.

Le KG sert donc de sas de curation. Les fiches wiki et le package ne doivent consommer que les elements valides ou explicitement marques comme candidats.
