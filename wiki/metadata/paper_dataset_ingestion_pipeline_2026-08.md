---
title: Pipeline d'ingestion des jeux de donnees issus de papiers
type: metadata
created: 2026-08-06
updated: 2026-08-12
sources: []
tags: [metadata, pipeline, kg, papers, ingestion]
---

# Pipeline d'ingestion des jeux de donnees issus de papiers

Date : 2026-08-12 (actualise -- version precedente obsolete, numerotation
divergente de celle reellement suivie en session)

Ce document decrit le cheminement reellement suivi, en 14 phases, lorsqu'un
lot de candidats papier-dataset (typiquement issu d'une moisson DataCite) est
transforme en fiches wiki benchmarkables. Il fait foi sur la numerotation :
toute divergence avec un autre document doit etre corrigee au profit de
celui-ci.

## Vue d'ensemble (14 phases)

```text
Phase 1  - Consulter la moisson DataCite / le manifeste de candidats
Phase 2  - Telecharger automatiquement les PDF
Phase 3  - Recuperer manuellement les PDF non accessibles automatiquement
Phase 4  - Telecharger les datasets valides
Phase 5  - Produire le BibTeX depuis PDF (Biblio_from_pdf)
Phase 6  - Fusionner les references dans corpus/bib/references.bib
Phase 7  - Convertir les PDF en TEI (GROBID)
Phase 8  - Reconstruire le knowledge graph (KG)
Phase 9  - Explorer les preuves extraites du KG
Phase 10 - Generer le rapport d'audit des candidats
Phase 11 - Construire le manifeste de curation
Phase 12 - Ecrire/completer les loaders R (conversion sf)
Phase 13 - Generer les fiches dataset
Phase 13bis - Verifier chaque fiche contre le papier source (OBLIGATOIRE)
Phase 14 - Controler la promotion package et exporter les metadata
```

## Phase 1 - Consulter la moisson DataCite / le manifeste de candidats

But : partir d'un lot de candidats deja identifies (recherche DataCite ou
autre source) plutot que de relancer une recherche bibliographique a
l'aveugle.

Scripts et fichiers responsables :

- `tools/harvest_datacite.R` : collecte DataCite de datasets candidats.
- `tools/run_datacite_harvest_pipeline.py` : orchestre collecte + verification.
- `tools/verify_datacite_candidates.py` : verification automatique/LLM des candidats.
- `tools/apply_datacite_verification.R` : applique les decisions de verification.

Sorties a consulter :

- `data/manifests/papers/datacite_spatial_dataset_candidates.json`
- `data/manifests/papers/datacite_verification_report_2026-08.md`
- `data/manifests/papers/datacite_verified_ingestion_manifest.json`

Decision attendue : garder/rejeter/verifier manuellement chaque candidat du lot.

## Phase 2 - Telecharger automatiquement les PDF

But : recuperer les PDF open access via DOI avant toute intervention manuelle.

Scripts responsables :

- `tools/pdf_resolver.py` : route recommandee pour les nouveaux lots. Il
  applique l'ordre `DOI -> PMC ID Converter -> NCBI S3 pmc-oa-opendata ->
  Unpaywall/OpenAlex -> Playwright optionnel`, ignore les DOI marques
  `rejected_user_excluded`, et ne sauvegarde un fichier que si ses octets
  commencent par `%PDF-`.
- `tools/download_doi_pdfs.py`
- `code/package_metadata/download_regression_article_pdfs.py`

Sorties a consulter :

- `gg/doi_pdf_resolver_manifest_2026-08.tsv`
- `gg/doi_pdf_download_manifest_2026-08.tsv`
- `corpus/papers/raw_pdf/` (PDF recuperes)

Commande recommandee pour un lot explicite, sans navigateur :

```powershell
python tools/pdf_resolver.py --doi 10.xxxx/yyyy --doi 10.zzzz/wwww
```

Ajouter `--use-playwright` seulement apres echec des routes API/OA stables.
Le fallback navigateur sait maintenant construire des routes editeur courantes
(`doi.org`, Wiley `/doi/`, `/doi/epdf/`, `/doi/pdfdirect/`, Taylor & Francis
`/doi/pdf/`, Royal Society `/doi/pdf/`) puis chercher des indices visibles
comme `PDF`, `Download`, `href` contenant `pdf`, et verifier les reponses reseau
ou evenements de telechargement. Il ne conserve le fichier que si les octets
commencent par `%PDF-`.

Commande navigateur headless :

```powershell
python tools/pdf_resolver.py `
  --doi 10.1111/ele.14478 `
  --use-playwright `
  --playwright-timeout 20 `
  --max-browser-clicks 8
```

Commande navigateur visible avec profil persistant, utile quand l'editeur laisse
passer une session interactive mais bloque un navigateur automatise neuf :

```powershell
python tools/pdf_resolver.py `
  --doi 10.1111/ele.14478 `
  --use-playwright `
  --playwright-headed `
  --browser-profile data/browser_profiles/wiley_oa `
  --manual-browser-wait 90 `
  --playwright-timeout 30
```

Le dossier `data/browser_profiles/` est local et ignore par Git, car il peut
contenir des cookies de navigation. Si une page demande captcha, login ou acces
institutionnel, la decision correcte est `MANUAL_ACTION_REQUIRED` /
`CAPTCHA_OR_LOGIN_REQUIRED`, pas une tentative de contournement.

Decision attendue : PDF local disponible, ou passage en Phase 3.

## Phase 3 - Recuperer manuellement les PDF non accessibles automatiquement

But : traiter les papiers payants ou non indexes correctement, dont le PDF a
ete recupere a la main (portail editeur, acces institutionnel, etc.).

Script responsable :

- `tools/ingest_manual_downloads.py` : enregistre et rattache un PDF depose
  manuellement au bon enregistrement du manifeste.

Decision attendue : PDF present et rattache au bon DOI/bib_key, ou papier
marque non accessible et exclu du flux dataset.

## Phase 4 - Telecharger les datasets valides

But : recuperer les donnees brutes (pas seulement le PDF) une fois le papier
valide bibliographiquement.

Dossier cible : `data/raw/papers/<bib_key>/` (zip, csv, shapefile, raster,
README/data_dictionary tels que fournis par les auteurs).

Decision attendue : donnees telechargees, lisibles, source identifiee ;
`local_raw_dir` renseigne dans le KG (`inst/kg/paper_dataset_uses.json`).

## Phase 5 - Produire le BibTeX depuis PDF (Biblio_from_pdf)

But : generer une entree BibTeX propre pour chaque PDF retenu.

Scripts responsables :

- `Biblio_from_pdf/` (outil dedie, execution PDF -> `.bib`)
- `tools/stage_biblio_from_pdf_datacite.py` : staging entre les PDF DataCite
  et le flux `Biblio_from_pdf` (phases `dedupe-dry-run` / `dedupe-apply`
  incluses pour eviter les doublons de cle).
- `tools/sync_manual_retrievals_status.py` : synchronise le statut des
  recuperations manuelles (Phase 3) avec le manifeste ; limitation connue :
  le matching par titre casse si les PDF ont deja ete renommes en citekey
  (Phase 6) -- verifier directement le champ `local_pdf` en cas de doute
  plutot que de faire confiance au rapport du script.

Sortie a consulter : `Biblio_from_pdf/llm_wiki_datacite_*.bib`

Decision attendue : entree `.bib` correcte (titre, auteurs, annee, DOI, champ
`file` pointant vers le PDF local).

## Phase 6 - Fusionner les references dans corpus/bib/references.bib

But : faire entrer uniquement les entrees validees dans la bibliographie
generale du corpus.

Les articles de datasets papiers passent par Biblio_from_pdf (Phase 5) PUIS
directement dans `corpus/bib/references.bib` -- il n'y a pas de detour par
`gg/regression_article.bib` pour ce flux (tranche explicitement le
2026-08-12 : le routage via regression_article.bib avait ete envisage puis
abandonne).

Script responsable :

- `Biblio_from_pdf/tools/import_to_llm_wiki.py`

Decision attendue : le papier est present dans `references.bib`, le champ
`file` pointe vers un PDF local, aucune collision de cle.

## Phase 7 - Convertir les PDF en TEI (GROBID)

But : transformer les PDF en XML TEI pour que les scripts puissent lire
sections, tableaux, references, formules et mentions de datasets.

Scripts responsables :

- `tools/kg/02_run_grobid.py`

Sorties a consulter : `corpus/papers/tei/*.tei.xml`

Commande typique :

```powershell
python tools/kg/02_run_grobid.py --from-bib
```

## Phase 8 - Reconstruire le knowledge graph (KG)

But : relancer la chaine complete d'extraction KG (bib, TEI, evidence,
paper-dataset uses, graphe) sans dupliquer ni ecraser le travail existant.

Script responsable :

- `tools/kg/run_all.py` (orchestre 01_extract_bib -> 02_run_grobid [optionnel]
  -> 03_parse_tei -> 04_extract_dataset_catalogs -> 04_extract_web_sources ->
  export_spatialtidymodels_metadata -> 08_extract_model_evidence ->
  09_extract_paper_dataset_uses -> 09b_llm_disambiguate [optionnel] ->
  10_make_audit_candidate_review -> 04_build_graph -> 06_make_summaries ->
  07_export_agent_index)

Important : `inst/kg/paper_dataset_uses.json` est une entree lue par ces
scripts pour le rattachement dataset-papier, pas ecrasee integralement --
verifier le docstring du script avant de le relancer si un doute existe sur
la conservation du travail deja fait (statuts `raw_data_downloaded`,
`local_raw_dir`, etc.).

Commande typique :

```powershell
python tools/kg/run_all.py --run-grobid --from-bib
```

## Phase 9 - Explorer les preuves extraites du KG

But : verifier concretement ce que le KG a extrait pour un papier donne avant
de passer a la curation.

Script responsable :

- `tools/kg/query_kg.py`

Commandes utiles :

```powershell
python tools/kg/query_kg.py --audit-candidates --limit 20
python tools/kg/query_kg.py --paper-dataset-gaps
python tools/kg/query_kg.py --paper-dataset-uses 10.xxxx/xxxxx
```

## Phase 10 - Generer le rapport d'audit des candidats

But : produire un document humain qui liste, par papier, les passages
prioritaires (source de donnees, variables Y/X, formule) releves par le KG.

Script responsable : `tools/kg/10_make_audit_candidate_review.py`

Sortie a consulter : `wiki/analyses/model_evidence_candidates_review_2026-08.md`

## Phase 11 - Construire le manifeste de curation

But : consolider candidats fiches `paper_*`, manifestes DataCite verifies,
relations `PaperDatasetUse` du KG et audit TEI dans un seul tableau de
decision (`choose_priority()`), pour eviter de creer directement des fiches
definitives depuis des signaux bruts.

Script responsable : `tools/build_paper_dataset_curation_manifest.py`

Sorties a consulter :

- `data/manifests/papers/paper_dataset_benchmark_candidates.json`
- `wiki/analyses/paper_dataset_benchmark_candidates_2026-08.md`

Decision attendue : priorite `high` / `medium` / `low` par dataset candidat.

## Phase 12 - Ecrire/completer les loaders R (conversion sf)

But : produire, pour chaque dataset valide, un loader R reexecutable qui
convertit les donnees brutes en objet `sf` unifie.

Script responsable : `code/r_catalog/build_sf_datasets_papers.R`
(`PAPER_DATASET_LOADERS`, une entree `record_id -> load_xxx()` par dataset ;
chaque loader retourne `list(obj=<sf>, row=list(coordinate_columns=,
identifier_variables=, datetime_columns=, candidate_y_variables=))`).

Sortie : `data/final_datasets/sf/paper_<record_id>.rds`

Checks minimaux avant de passer en Phase 13 : nombre d'observations,
variable reponse, covariables, geometrie/CRS, valeurs manquantes, doublons,
coherence avec le papier source (ne pas se fier au seul nom de fichier --
verifier le contenu reel).

## Phase 13 - Generer les fiches dataset

But : produire une fiche `wiki/datasets/fiches_datasets/paper_<id>.md`
(format Bloc 1-6) par dataset converti en sf.

Script responsable : `code/r_catalog/generate_fiches_papers.R`
(dictionnaires `LOADER_TO_DIR`, `FORMULA_OVERRIDES`, `PAPER_READINESS` a
completer a la main pour chaque nouveau `record_id` ; sans entree,
retombe sur des heuristiques generiques -- `infer_description_fields()`,
`is_temporal_candidate()` -- qui peuvent se tromper sur des noms de
variables ambigus ou generiques, voir Phase 13bis).

Commande :

```powershell
Rscript code/r_catalog/generate_fiches_papers.R [record_id ...]
```

## Phase 13bis - Verifier chaque fiche contre le papier source (OBLIGATOIRE)

But : `generate_fiches_papers.R` derive la majorite du contenu d'une fiche
par des heuristiques automatiques (typologie, N/T, description, estimateurs
eligibles) qui peuvent se tromper silencieusement -- confusion nom de
variable/temps, description copiee depuis un autre dataset partageant un mot-cle,
covariable citee dans le papier mais qui n'en est en realite pas une (poids
de variance, critere d'exclusion, masque de zone d'etude), etc. Ces erreurs
ne sont pas detectees par Tier 1 (structurel) ni par un Tier 2 generique : il
faut relire le papier.

Cette phase est **obligatoire** immediatement apres toute execution de
`generate_fiches_papers.R` portant sur un ou plusieurs `record_id`, avant de
passer a la Phase 14. Ne pas la sauter meme si le lot semble petit.

Pour chaque fiche generee ou regeneree :

1. Relire le papier source (`corpus/papers/raw_pdf/<bib_key>.pdf`, sections
   Methods/Data/Results, ou a defaut le README/data_dictionary du depot de
   donnees) -- pas seulement le README deja consulte au moment d'ecrire le
   loader.
2. Comparer point par point avec la fiche :
   - `formula_pub`/`formula_used` : chaque covariable listee correspond-elle
     a une covariable de la moyenne du modele publie, et non a un poids de
     variance, un critere d'exclusion de donnees ou un masque de zone d'etude ?
   - Bloc 4 (N/T, structure) : la variable temporelle detectee est-elle
     vraiment un temps (pas une covariable bioclimatique/numerique dont le
     nom contient un token type "month"/"year") ? Un panel declare par le
     loader (`row$datetime_columns`) est-il bien reflete ?
   - Bloc "Description du jeu de donnees" (Topic/Observation unit/Observed
     population) : correspond-il au bon papier, ou a-t-il pu etre confondu
     avec un autre dataset partageant un mot-cle du titre/record_id ?
   - `benchmark_readiness`/`estimator_eligibility` : les estimateurs proposes
     sont-ils compatibles avec le type de Y (une reponse binaire ne doit pas
     recevoir `ols`/`sar_lag`/`sem_error`/`sdm_mixed` -- verifier le registre
     reel du package, `packages/spatialtidymodels/R/13-benchmark-spatial.R`,
     avant d'assumer qu'un estimateur listе est reellement executable) ?
   - N observations : correspond-il a l'echantillon d'analyse du papier
     (apres apurement des valeurs manquantes documente par les auteurs), ou
     au fichier brut avant nettoyage ?
3. Documenter toute divergence trouvee (fichier, ligne, nature de l'erreur,
   citation du papier qui contredit la fiche) avant de corriger quoi que ce
   soit -- ne jamais corriger silencieusement une fiche sans le signaler.
4. Corriger la fiche (ou le script generateur si l'erreur est systemique,
   i.e. affecte plusieurs `record_id` via la meme heuristique) et
   regenerer.

Ne pas promouvoir une fiche en Phase 14 tant que cette verification n'a pas
ete faite au moins une fois sur sa version courante.

## Phase 14 - Controler la promotion package et exporter les metadata

But : separer une fiche dataset documentee d'un dataset reellement utilisable
par `spatialtidymodels`, puis exporter les metadata consommees par le
package.

Bloc obligatoire pour les fiches `paper_*.md` :

```yaml
benchmark_readiness:
  benchmark_status: ready | almost_ready | needs_preprocessing | needs_covariate_join | needs_original_W | manual_review | not_ready_*
  package_include: yes | no | manual_review
  missing_items: "raison courte"
  reason: "justification"
```

Scripts responsables :

- `tools/check_paper_benchmark_readiness.py` : controle les statuts et
  bloque les promotions incoherentes.
- `code/package_metadata/export_spatialtidymodels_metadata.py` : exporte
  toutes les fiches en metadata, ne marque `benchmark_ready = true` que si
  `package_include: "yes"` et `benchmark_status: ready`.
- `packages/spatialtidymodels/inst/metadata/datasets.json` : metadata
  consommee par le package.

Commandes :

```powershell
python tools/check_paper_benchmark_readiness.py
python code/package_metadata/export_spatialtidymodels_metadata.py
```

Regles de promotion :

- `package_include: "yes"` est interdit si `benchmark_status` n'est pas `ready` ;
- un dataset papier ne doit pas entrer dans les benchmarks package sans
  variable reponse, covariables, support spatial, formule ou specification
  defendable, et artefact local final (`.rds`) ;
- documenter l'etape manquante plutot que fabriquer une formule ou une source.

## Regle importante

Un candidat extrait automatiquement ne doit jamais devenir directement une
fiche dataset definitive. Il doit passer par :

1. le papier utilise vraiment un dataset empirique ;
2. le dataset est spatial ;
3. la source de telechargement fonctionne ;
4. les donnees sont lisibles localement (contenu verifie, pas seulement le nom de fichier) ;
5. les variables Y/X ou la specification empirique sont identifiees ;
6. le preprocessing est documente ;
7. la fiche generee a ete verifiee contre le papier source (Phase 13bis) ;
8. une version finale benchmarkable existe.

Le KG sert de sas de curation. Les fiches wiki et le package ne doivent
consommer que les elements valides ou explicitement marques comme candidats.

## Related Pages

- [[model_evidence_candidates_review_2026-08]]
- [[catalog_registry_schema_v3]]
- [[quality_pedigree_schema_v1]]
