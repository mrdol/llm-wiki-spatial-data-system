# Synthese courte - pipeline datasets papier et spatialtidymodels

Date: 2026-08-13

## 1. Objectif du travail

Le projet `llm-wiki-spatial-data-system` vise a construire une chaine reproductible pour identifier, documenter, transformer et evaluer des jeux de donnees spatiaux utilisables dans des benchmarks de regression spatiale. Le resultat attendu n'est pas seulement un catalogue de donnees, mais un systeme complet reliant :

- les papiers scientifiques et leurs DOI ;
- les datasets associes, lorsqu'ils sont accessibles ;
- les preuves extraites des papiers : variable reponse, covariables, formule empirique, estimateurs testes, metriques et structure spatiale ;
- les fiches Markdown de documentation ;
- les artefacts `sf` exploitables en R ;
- les metadonnees consommees par le package R `spatialtidymodels`.

Le principe de travail retenu est strict : ne pas inventer de formule, de variable ou de source. Si une information n'est pas trouvee dans le papier, le dataset, le TEI, le KG ou une source fiable, elle reste documentee comme manquante.

## 2. Etat actuel du corpus et du KG

Le graphe de connaissances a fortement augmente avec l'integration des papiers et des datasets issus de DataCite, Dryad, Figshare, Zenodo, Dataverse et des packages R/Python.

| Element | Etat actuel |
|---|---:|
| Noeuds KG | 57 528 |
| Relations KG | 73 661 |
| Papiers dans le KG | 898 |
| Entrées `PaperDatasetUse` | 222 |
| PDF dans `corpus/papers/raw_pdf/` | 223 |
| TEI dans `corpus/papers/tei/` | 232 |
| Dossiers bruts papier dans `data/raw/papers/` | 89 |
| Artefacts paper `.rds` dans `data/final_datasets/sf/` | 58 |
| Fiches datasets papier `paper_*.md` | 58 |
| Datasets dans `packages/spatialtidymodels/inst/metadata/datasets.json` | 147 |
| Datasets actuellement promus comme benchmark-ready dans le package | 28 |

Il faut bien distinguer trois niveaux :

- `PaperDatasetUse` : lien papier-dataset identifie, pas forcement exploitable.
- Fiche dataset papier : documentation creee, mais pas toujours benchmarkable.
- Dataset package-ready : donnees, Y/X, formule utilisable et statut suffisamment propre pour `spatialtidymodels`.

Aujourd'hui, environ 28 datasets sont directement utilisables dans le package. Plusieurs autres sont en `manual_review` ou `almost_ready`, mais ne doivent pas etre promus sans verification supplementaire.

## 3. Pipeline en 14 phases

La procedure de reference est documentee dans :

`wiki/metadata/paper_dataset_ingestion_pipeline_2026-08.md`

Elle organise le passage d'un papier + dataset brut vers une fiche benchmarkable :

1. Lire les candidats issus du harvest.
2. Tenter le telechargement automatique des PDF.
3. Integrer les PDF recuperes manuellement si besoin.
4. Telecharger les fichiers datasets associes.
5. Produire une bibliographie enrichie avec `Biblio_from_pdf`.
6. Fusionner les references retenues dans `corpus/bib/references.bib`.
7. Lancer GROBID pour produire les TEI.
8. Reconstruire le KG.
9. Explorer les liens papier-dataset-formule.
10. Produire un audit des candidats.
11. Curer le manifeste de decision.
12. Ecrire ou completer les loaders R pour produire des objets `sf`.
13. Generer les fiches Markdown homogenes.
13bis. Verifier chaque fiche contre le papier source.
14. Promouvoir uniquement les datasets propres vers le package.

La phase 13bis est devenue obligatoire. C'est elle qui evite de promouvoir des formules generiques d'estimateurs, des produits de prediction, des datasets de classification ou des variables reconstruites sans preuve comme si c'etaient des benchmarks de regression continue.

## 4. Outils recents mis en place

Plusieurs outils ont ete ajoutes pour rendre le pipeline moins manuel et plus controlable.

| Outil | Role |
|---|---|
| `tools/harvest_datacite.R` | Interroge DataCite avec des profils thematiques et filtre les candidats par spatialite, modele, DOI article, citations, taille minimale et acces. |
| `tools/run_datacite_harvest_pipeline.py` | Lance la chaine harvest -> verification LLM -> application des decisions -> ingestion KG. |
| `tools/verify_datacite_candidates.py` | Produit un rapport de verification des candidats, avec `keep`, `needs_manual_check` ou `reject`. |
| `tools/apply_datacite_verification.R` | Applique les decisions et retire les rejets du fichier candidat. |
| `tools/ingest_datacite_verified.py` | Cree ou met a jour les liens `PaperDatasetUse`, les manifests et le BibTeX de staging. |
| `tools/pdf_resolver.py` | Resout les DOI vers des PDF legaux : deja present, PMC/NCBI S3, Unpaywall, OpenAlex, depot institutionnel, editeur, puis action manuelle. |
| `tools/ingest_manual_downloads.py` | Rattache les telechargements manuels au projet et aux manifests. |
| `tools/stage_biblio_from_pdf_datacite.py` | Prepare le passage par `Biblio_from_pdf` pour produire des BibTeX a partir des PDF. |
| `tools/kg/08_extract_model_evidence.py` | Extrait les preuves de modeles, formules et estimateurs depuis TEI/KG. |
| `tools/kg/09_extract_paper_dataset_uses.py` | Structure les relations papier-dataset et ajoute les candidats issus des audits. |
| `tools/kg/query_kg.py` | Permet d'interroger un DOI papier pour voir les datasets lies, leur statut, Y/X, formule et artefact local. |
| `code/r_catalog/build_sf_datasets_papers.R` | Construit les `.rds` `sf` pour les datasets papier. |
| `code/r_catalog/generate_fiches_papers.R` | Genere les fiches papier dans un format rapproche des fiches issues des packages. |
| `code/package_metadata/export_spatialtidymodels_metadata.py` | Exporte les metadonnees vers le package R. |

Un point important a ete stabilise : les papiers datasets ne passent plus directement par `gg/regression_article.bib` comme source finale. Le chemin propre est maintenant : PDF -> `Biblio_from_pdf` -> `corpus/bib/references.bib` -> GROBID -> KG -> fiches -> package.

### 4bis. Anatomie de `tools/run_datacite_harvest_pipeline.py`

Ce script n'est pas un harvester : c'est un orchestrateur qui enchaine 4 etapes independantes, chacune desactivable avec `--skip-harvest`, `--skip-verification`, `--skip-apply`, `--skip-ingestion` :

1. `tools/harvest_datacite.R` -- interroge l'API DataCite et produit les candidats bruts.
2. `tools/verify_datacite_candidates.py` -- verification LLM (Claude, `--model`, defaut `claude-sonnet-4-5`) qui classe chaque candidat en `keep` / `needs_manual_check` / `reject`. Par defaut le rapport mensuel de verification en cours est ecrase (`--force`) ; `--no-force-verification` conserve le rapport existant.
3. `tools/apply_datacite_verification.R` -- applique ces decisions et retire les `reject` du fichier de candidats.
4. `tools/ingest_datacite_verified.py` -- cree/actualise les liens `PaperDatasetUse` dans le KG, les manifests et le BibTeX de staging.

L'etape 1 (le harvest R) est elle-meme un entonnoir en plusieurs temps, important a comprendre pour lire les options :

- Des requetes DataCite sont construites par profil thematique (voir plus bas), chacune combinant termes de modele spatial + termes de geometrie (+ termes du profil si different de `core`).
- Chaque resultat brut recoit un **pre-score** (regex sur titre/description/sujets/formats : presence de geometrie, de signal de regression, de signal de modele spatial fort, de depot prioritaire type Zenodo/Dryad/Figshare/Dataverse, penalite si signal "produit fini" ou spatio-temporel).
- Seuls les candidats avec pre-score positif et DOI d'article parent (sauf `require_parent=FALSE`) sont conserves, tries par pre-score, puis on ne garde que les `--openalex-limit` premiers : c'est le filtre le plus grossier, applique **avant** l'enrichissement couteux.
- Ces survivants sont enrichis via OpenAlex (nombre de citations de l'article parent) et Crossref (metadonnees bibliographiques), avec `--crossref-workers` requetes en parallele.
- Un second passage de classification (`screening_tier`) separe `high_open_spatial_regression` / `medium_spatial_regression_article_not_oa` / `medium_spatiotemporal_review` / `medium_open_weak_model_signal` / `low_reject`. Les `low_reject` sont elimines, ainsi que tout candidat sous le seuil `--min-citations` ou deja couvert par un enregistrement existant.
- Le resultat final est trie par score de priorite et tronque a `--target` candidats.

Explication de la commande donnee en exemple :

```powershell
python tools/run_datacite_harvest_pipeline.py `
  --target 300 `
  --openalex-limit 700 `
  --min-citations 5 `
  --crossref-workers 4 `
  --min-dataset-size-kb 200 `
  --profiles core,agriculture_economic,public_health,natural_hazards `
  --strict-spatial-only `
  --rscript "C:\Users\jdoliveira\AppData\Local\Programs\R\R-4.5.3\bin\Rscript.exe"
```

| Option | Valeur | Effet |
|---|---|---|
| `--target 300` | valeur par defaut | Plafond final de candidats retenus apres tout le filtrage. |
| `--openalex-limit 700` | reduit (defaut 1200) | Seuls les 700 candidats les mieux pre-scores recoivent l'enrichissement OpenAlex/Crossref (etape couteuse en appels API) ; un run plus rapide/moins cher, au prix de perdre les candidats classes 701-1200 par le pre-score. |
| `--min-citations 5` | valeur par defaut | L'article parent doit avoir au moins 5 citations OpenAlex (les articles sans citation count connu passent quand meme). |
| `--crossref-workers 4` | augmente (defaut 1) | 4 requetes Crossref en parallele au lieu d'une seule -- plus rapide, un peu plus agressif vis-a-vis de l'API Crossref. |
| `--min-dataset-size-kb 200` | relve (defaut script 50) | Ecarte les depots DataCite trop petits pour contenir de vraies donnees (code seul, stub de metadonnees). Le seuil de 200 Ko correspond a la valeur `MIN_DATASET_SIZE_BYTES` desormais codee en dur dans `tools/harvest_datacite.R`, relevee cette session apres decouverte d'un stub taxonomique Plazi/Zenodo (16 Ko au total) qui passait le seuil precedent. |
| `--profiles core,agriculture_economic,public_health,natural_hazards` | sous-ensemble | Ne lance que 4 des 9 profils thematiques disponibles (`THEME_PROFILES` dans `harvest_datacite.R` : `core`, `transport_mobility`, `energy_infrastructure`, `public_health`, `natural_hazards`, `education_inequality`, `agriculture_economic`, `marine_littoral`, `urban_services`, `public_policy_governance`) au lieu de tous les lancer (`all` ou liste complete). `core` = requete generique modele+geometrie sans restriction thematique ; chaque autre profil ajoute ses propres mots-cles (ex. `agriculture_economic` = crop yield, agriculture, farmland, land value, farm, soil productivity) combines aux termes de modele et de geometrie. |
| `--strict-spatial-only` | active (defaut off) | Exclut les candidats dont le texte porte un signal spatio-temporel/panel (`flag_spatiotemporal`) du perimetre cible, meme s'ils passent les autres filtres -- ne garde que les candidats coupe-transversale simple, coherent avec le choix de ne pas encore construire de route panel/spatio-temporel dans le pipeline. |
| `--rscript "...\Rscript.exe"` | chemin explicite | Necessaire sur cette machine car R n'est pas sur le PATH (installe dans `AppData\Local\Programs\R\R-4.5.3\bin\`) ; sinon le script tente `R_SCRIPT` puis `PATH` puis un chemin par defaut code en dur dans `find_rscript()`. |

## 5. Situation des datasets papier

Les fiches papier sont maintenant mieux normalisees, mais toutes ne sont pas benchmarkables. Les principaux motifs de blocage sont :

- dataset de classification ou presence/absence, pas regression continue ;
- produit final de prediction sur grille, sans table d'apprentissage Y/X ;
- reponse derivee d'un modele, par exemple coefficient GWR ou cluster ;
- covariables du papier non presentes dans les fichiers bruts ;
- matrice spatiale W originale absente ;
- donnees panel ou spatio-temporelles demandant une reduction explicite ;
- dataset trop petit ou sans covariable ;
- fichier dataset payant, inaccessible ou seulement partiellement telechargeable.

Exemples traites recemment :

- Les grilles PM2.5, NO2 et O3 ont ete reconnues comme produits de prediction, pas comme tables d'apprentissage completes. Des versions monitor-level ont ete amorcees, mais les covariables originales restent difficiles a reconstruire.
- `uk_photovoltaic` est un bon cas scientifique, mais notre artefact local est au niveau LAD alors que le papier travaille en NUTS3 avec 9 covariables publiees. Il faut reconstruire la table NUTS3 avant promotion.
- `biomass_rainforest` a ete reanalyse : la reponse AGB peut etre reconstruite depuis les simulations du dataset, mais les covariables environnementales du GLM publie doivent etre documentees comme sources externes si elles ne sont pas toutes localement disponibles.
- Les datasets geostatistiques comme `swiss_rainfall` ou `vindum` ne doivent pas etre forces artificiellement en regression multivariee ; ils peuvent etre utilises avec covariables spatiales explicites si celles-ci sont justifiees.

## 6. Package `spatialtidymodels`

Le package contient maintenant une couche de metadonnees plus riche :

- `packages/spatialtidymodels/inst/metadata/datasets.json`
- `packages/spatialtidymodels/inst/metadata/estimators.json`

Les benchmarks ont ete ameliores pour retourner des metriques comparables :

- RMSE et MAE calcules sur les predictions concatenees ;
- temps total de calcul par estimateur ;
- diagnostic de Moran sur les residus, avec l'objectif de minimiser la structure spatiale residuelle ;
- parametres spatiaux quand ils existent, par exemple `rho` ou `lambda`.

Les estimateurs integres couvrent plusieurs familles : OLS, SAR/SEM/SDM, GWR/MGWR/MGWRSAR, SpBoost, Random Forest, XGBoost, spatialML/GRF, spatialRF, RFGLS et spmoran selon les cas. Les modeles sans parametre spatial scalaire unique ne doivent pas afficher artificiellement `rho` ou `lambda`.

## 6bis. Methode de lecture dirigee des papiers source

La phase 13bis (verification fiche vs papier) et, plus generalement, toute etape qui touche a une variable, un seuil ou une affirmation du papier, repose sur une pratique volontairement nommee **lecture dirigee** : on ne lit jamais un papier de bout en bout dans l'espoir de "tomber" sur l'information, on lit une section precise pour repondre a une question de verification precise. Le PDF (`corpus/papers/raw_pdf/`) et le TEI (`corpus/papers/tei/`) restent la source d'arbitrage finale, au-dessus de toute metadonnee DataCite/OpenAlex/Crossref ou de tout README de depot.

Principe pratique :

- Une question de verification = une section ciblee, jamais tout le document. Exemples de questions et de sections correspondantes :
  - "Le PDF telecharge est-il vraiment cet article ?" -> page 1 uniquement (titre, auteurs, revue, DOI), compare mot a mot a la citation attendue.
  - "Quelle est la vraie variable reponse ?" -> section Methods (souvent "Data analysis" ou equivalent), pas le resume.
  - "Ou sont archivees les donnees reelles ?" -> section "Data Availability Statement" (fin d'article ou remerciements), jamais supposee a partir du nom du depot DataCite.
  - "Quel seuil de fiabilite les auteurs utilisent-ils eux-memes ?" -> notes de bas de tableau (footnotes), qui contiennent souvent des regles de filtrage (taille minimale d'echantillon, periode retenue) reutilisables telles quelles dans le loader plutot que d'en inventer une nouvelle.
- Un fichier local (PDF, TEI, CSV, README de depot) n'est jamais suppose correct parce qu'il porte le bon nom de fichier. Le nom de fichier et les metadonnees DataCite peuvent mentir ; seul le contenu fait foi.
- Toute affirmation extraite ainsi doit etre tracee : citation de page/section dans `FORMULA_OVERRIDES` (`code/r_catalog/generate_fiches_papers.R`) ou dans `dataset_download_note` (`inst/kg/paper_dataset_uses.json`), pas seulement retenue en memoire de session.

Cas reels rencontres cette session, qui justifient la regle :

- Trois PDF locaux se sont averes etre le mauvais document ou un document incomplet (une annexe seule, un rapport interne different de l'article) alors que le nom de fichier et les metadonnees DataCite semblaient corrects. Chaque fois, seule la comparaison page 1 vs citation attendue a permis de le detecter, puis de retelecharger le bon PDF et de regenerer le TEI (`tools/kg/02_run_grobid.py --pdf ... --force`).
- Deux "Data Availability Statement" se sont reveles trompeurs a la lecture directe : l'un affirmait que toutes les donnees etaient sur Dryad alors que la geometrie des sites n'y a jamais ete deposee (treeline) ; l'autre listait un depot Dryad complet mais precisait, dans la meme phrase, que les donnees d'observation brutes etaient "available on request" aupres d'une personne nommee, pas telechargeables (puffins Baleares). Dans les deux cas, une lecture des metadonnees seules (ou de la liste de fichiers Dryad) sans lire la phrase du DAS aurait conclu a tort "donnees manquantes, dataset non exploitable" sans en comprendre la vraie raison.
- Le seuil de fiabilite utilise pour agreger `FrogAbnormalities.csv` en prevalence par site (n >= 50 metamorphes) n'a pas ete invente : il vient telle quelle d'une note de bas de Table 1 de Reeves et al. (2010), trouvee en lisant le tableau, pas le texte courant.
- La variable reponse du dataset landraces haricot (`genepool`) n'apparaissait dans aucun nom de colonne evident ni dans le README du depot ; elle n'a ete identifiee qu'en lisant directement la section Methods 2.4.1 du papier, qui la nomme explicitement comme variable reponse du premier modele.

## 7. Limites actuelles

Le pipeline est fonctionnel, mais il reste des limites importantes.

Le harvest DataCite ramene beaucoup de faux positifs. Meme avec les filtres de citations, taille minimale, spatialite et verification LLM, une partie des candidats correspond a des archives de code, des produits finaux, des datasets non spatiaux, des donnees de classification ou des supplements incomplets.

Le telechargement automatique des PDF reste fragile. Les depots ouverts comme PMC, Dryad, Figshare ou Zenodo sont gerables, mais Wiley, Taylor & Francis, Springer ou Royal Society peuvent bloquer les scripts. Le nouveau resolver PDF reduit ce probleme en cherchant d'abord PMC/NCBI S3, Unpaywall, OpenAlex et les depots institutionnels.

Les fiches ne doivent pas etre considerees comme fiables uniquement parce qu'elles existent. Une fiche `paper_*.md` est une documentation intermediaire ; seule la combinaison papier lu, donnees locales inspectees, formule verifiee et benchmark_readiness valide permet une promotion package.

Enfin, l'objectif de 200 datasets benchmarkables reste ambitieux. Le projet dispose deja d'une base solide, mais le taux de conversion entre candidats bruts et datasets vraiment benchmarkables est faible. Il faut donc augmenter le volume de harvest tout en renforcant les filtres et la curation.

## 8. Prochains points a traiter

Les prochaines priorites proposees sont :

1. Terminer le traitement de la derniere vague DataCite : PDF, datasets, GROBID, KG, loaders, fiches, verification.
2. Stabiliser les cas `almost_ready` qui peuvent rejoindre rapidement le package.
3. Separer clairement les routes regression continue, classification/SDM, geostatistique univariee et panel/spatio-temporel.
4. Ameliorer le harvest par profils thematiques : transport, energie, sante publique hors pollution, risques naturels, education, agriculture economique, littoral, services urbains, politiques publiques.
5. Continuer a reduire les faux positifs avec des filtres de taille, type de fichier, DOI article, open access et evidence de modele.
6. Produire progressivement un tableau de bord des benchmarks avec RMSE, MAE, temps de calcul et Moran residuel par schema de validation croisee.

Le point central pour la suite est de ne pas chercher seulement plus de datasets, mais plus de datasets avec preuves suffisantes : papier accessible, dataset telechargeable, variables identifiables, formule ou specification empirique, structure spatiale exploitable et artefact `sf` reproductible.
